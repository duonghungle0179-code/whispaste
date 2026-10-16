import {normalize,singleWordCorrection} from "./normalizer.mjs";

const el=(id)=>document.getElementById(id);
let learned=[],recognition=null,recorder=null,audioStream=null,recorded=[];
let busy=false,speechFailed=false,baseline='';
const store=chrome.storage.local;
function message(text,error=false){el("status").textContent=text;el("status").style.color=error?"#a53333":"#215d57";}
function provider(){return el("provider").value;}
function setRecording(on){
  busy=on;el("start").disabled=on;el("stop").disabled=!on;
}
function updateResult(){
  baseline=normalize(el("raw").value,learned);
  el("result").value=baseline;
}
function updateCount(){el("learnCount").textContent="Đã lưu "+learned.length+" quy tắc sửa.";}
function endpointURL(){
  const raw=el("endpoint").value.trim();
  const url=new URL(raw);
  if(url.username||url.password||url.hash)throw new Error("Endpoint không được chứa mật khẩu hoặc dấu #.");
  const local=["localhost","127.0.0.1"].includes(url.hostname);
  if(url.protocol!=="https:"&&!(local&&url.protocol==="http:"))
    throw new Error("Endpoint phải dùng HTTPS (trừ localhost).");
  if(url.pathname==="/"||!url.pathname)
    throw new Error("Nhập đầy đủ đường dẫn tới API audio/transcriptions.");
  return url;
}
function permissionPattern(url){
  return url.protocol+"//"+url.hostname+"/*";
}
async function requestHostPermission(url){
  const origins=[permissionPattern(url)];
  if(await chrome.permissions.contains({origins}))return true;
  return chrome.permissions.request({origins});
}
async function saveConfig(){
  if(provider()==="remote"){
    try{
      const url=endpointURL();
      if(!await requestHostPermission(url)){
        message("Bạn chưa cấp quyền truy cập endpoint.",true);return false;
      }
    }catch(err){message(err.message,true);return false;}
  }
  await store.set({
    wpProvider:provider(),wpEndpoint:el("endpoint").value.trim(),
    wpModel:el("model").value.trim()||"whisper-1",
  });
  // API key is session-only: never write credentials into storage.local.
  await chrome.storage.session.set({wpApiKey:el("apiKey").value.trim()});
  message("Đã lưu cấu hình.");
  return true;
}
function showProvider(){
  el("remoteSettings").hidden=provider()!=="remote";
  if(provider()==="browser"&&!speechAPI()){
    message("Brave hoặc bản Chrome này không có SpeechRecognition. Hãy chọn Whisper-compatible API.",true);
  }else message("Sẵn sàng.");
}
function speechAPI(){return window.SpeechRecognition||window.webkitSpeechRecognition;}
async function startBrowserRecognition(){
  const Speech=speechAPI();
  if(!Speech){
    message("Trình duyệt không cung cấp SpeechRecognition tiếng Việt. Chọn phương thức API.",true);
    return;
  }
  speechFailed=false;
  recognition=new Speech();
  recognition.lang="vi-VN";recognition.interimResults=true;
  recognition.continuous=true;
  let finalText="";
  recognition.onresult=(event)=>{
    let interim="";
    for(let i=event.resultIndex;i<event.results.length;i++){
      const item=event.results[i];
      if(item.isFinal)finalText+=item[0].transcript+" ";
      else interim+=item[0].transcript+" ";
    }
    el("raw").value=(finalText+interim).trim();
    updateResult();
  };
  recognition.onerror=(event)=>{
    speechFailed=true;
    message("Lỗi nhận diện: "+event.error+". Nếu dùng Brave, chuyển sang phương thức API.",true);
  };
  recognition.onend=()=>{
    recognition=null;setRecording(false);
    if(!speechFailed){updateResult();message("Đã nhận diện. Có thể sửa rồi chèn vào ô nhập.");}
  };
  try{recognition.start();setRecording(true);message("Đang nghe tiếng Việt…");}
  catch(err){recognition=null;setRecording(false);message("Không khởi động được mic: "+err.message,true);}
}
function supportedMime(){
  for(const mime of ["audio/webm;codecs=opus","audio/webm","audio/mp4"]){
    if(MediaRecorder.isTypeSupported(mime))return mime;
  }
  return "";
}
async function startRemoteRecording(){
  try{
    const url=endpointURL();
    const approved=await requestHostPermission(url);
    if(!approved){message("Cần cấp quyền endpoint khi bấm Lưu cấu hình.",true);return;}
    audioStream=await navigator.mediaDevices.getUserMedia({audio:true});
    recorded=[];
    const mime=supportedMime();
    recorder=mime?new MediaRecorder(audioStream,{mimeType:mime}):new MediaRecorder(audioStream);
    recorder.ondataavailable=(event)=>{if(event.data.size)recorded.push(event.data);};
    recorder.onerror=(event)=>message("Lỗi ghi âm: "+(event.error?.message||"không xác định"),true);
    recorder.onstop=()=>{
      const type=recorder?.mimeType||mime||"audio/webm";
      const blob=new Blob(recorded,{type});recorded=[];
      audioStream?.getTracks().forEach(track=>track.stop());
      audioStream=null;recorder=null;
      transcribe(blob).catch(err=>message("Không thể nhận diện: "+err.message,true))
        .finally(()=>setRecording(false));
    };
    recorder.start(1000);setRecording(true);
    message("Đang ghi âm trên máy. Dừng để gửi tới endpoint bạn đã chọn.");
  }catch(err){
    audioStream?.getTracks().forEach(track=>track.stop());
    audioStream=null;recorder=null;setRecording(false);
    message("Không khởi động được ghi âm: "+err.message,true);
  }
}
async function transcribe(blob){
  if(!blob.size)throw new Error("Không ghi được âm thanh.");
  if(blob.size>25*1024*1024)throw new Error("Audio vượt 25 MB. Hãy chia bản ghi nhỏ hơn.");
  message("Đang gửi và chờ nhận diện tại endpoint đã cấu hình…");
  const form=new FormData();
  const ext=blob.type.includes("mp4")?"m4a":"webm";
  form.append("file",blob,"whispaste."+ext);
  form.append("model",el("model").value.trim()||"whisper-1");
  form.append("language","vi");
  const headers={};
  const key=el("apiKey").value.trim();
  if(key)headers.Authorization="Bearer "+key;
  const controller=new AbortController();
  const timer=setTimeout(()=>controller.abort(),120000);
  let response;
  try{
    response=await fetch(endpointURL().href,{
      method:"POST",headers,body:form,signal:controller.signal,
    });
  }finally{clearTimeout(timer);}
  if(!response.ok){
    // Do not echo server responses: they can contain sensitive data.
    throw new Error("API trả về HTTP "+response.status+". Kiểm tra endpoint, API key, CORS và mô hình.");
  }
  const payload=await response.json();
  if(typeof payload.text!=="string")throw new Error("API phải trả JSON có trường text.");
  el("raw").value=payload.text;
  updateResult();
  message("Nhận diện xong. Có thể sửa, sao chép hoặc chèn vào trang.");
}
async function start(){
  if(busy)return;
  if(provider()==="remote"){
    if(!await saveConfig())return;
    await startRemoteRecording();
  }else await startBrowserRecognition();
}
function stop(){
  if(recognition){recognition.stop();message("Đang kết thúc nhận diện…");return;}
  if(recorder&&recorder.state!=="inactive"){
    el("stop").disabled=true;
    recorder.stop();message("Đang xử lý âm thanh…");
  }
}
async function learnEditedResult(){
  const change=singleWordCorrection(baseline,el("result").value);
  if(!change)return false;
  const existing=learned.findIndex(entry=>
    entry.source.toLowerCase()===change.source.toLowerCase());
  if(existing>=0)learned[existing]=change;
  else if(learned.length<256)learned.push(change);
  else return false;
  await store.set({wpLearned:learned});
  updateCount();
  baseline=el("result").value;
  return true;
}
async function copy(){
  const text=el("result").value;
  if(!text.trim()){message("Chưa có văn bản để sao chép.",true);return false;}
  try{await navigator.clipboard.writeText(text);await learnEditedResult();message("Đã sao chép văn bản (và ghi nhớ từ sửa nếu có).");return true;}
  catch(err){message("Không sao chép được: "+err.message,true);return false;}
}
async function insert(){
  const text=el("result").value;
  if(!text.trim()){message("Chưa có văn bản để chèn.",true);return;}
  try{
    const tabs=await chrome.tabs.query({active:true,currentWindow:true});
    const tab=tabs[0];
    if(!tab?.id)throw new Error("Không tìm được tab đích.");
    const results=await chrome.scripting.executeScript({
      target:{tabId:tab.id},
      args:[text],
      func:(value)=>{
        const target=document.activeElement;
        if(!target)return {ok:false,reason:"no-focus"};
        const isArea=target instanceof HTMLTextAreaElement;
        const isInput=target instanceof HTMLInputElement &&
          ["text","search","url","email","tel"].includes(target.type);
        if((isArea||isInput)&&!target.disabled&&!target.readOnly){
          const pos=target.selectionStart??target.value.length;
          const end=target.selectionEnd??pos;
          const changed=target.value.slice(0,pos)+value+target.value.slice(end);
          const proto=isArea?HTMLTextAreaElement.prototype:HTMLInputElement.prototype;
          Object.getOwnPropertyDescriptor(proto,"value").set.call(target,changed);
          target.focus();target.setSelectionRange(pos+value.length,pos+value.length);
          target.dispatchEvent(new InputEvent("input",{
            bubbles:true,data:value,inputType:"insertText",
          }));
          return {ok:true};
        }
        if(target.isContentEditable){
          target.focus();
          const selection=window.getSelection();
          let range=selection?.rangeCount?selection.getRangeAt(0):null;
          if(!range||!target.contains(range.commonAncestorContainer)){
            range=document.createRange();range.selectNodeContents(target);
            range.collapse(false);
          }
          range.deleteContents();range.insertNode(document.createTextNode(value));
          range.collapse(false);selection.removeAllRanges();selection.addRange(range);
          target.dispatchEvent(new InputEvent("input",{
            bubbles:true,data:value,inputType:"insertText",
          }));
          return {ok:true};
        }
        return {ok:false,reason:"not-editable"};
      },
    });
    if(results?.[0]?.result?.ok){await learnEditedResult();message("Đã chèn văn bản (và ghi nhớ từ sửa nếu có).");return;}
    throw new Error("Không tìm thấy ô đang nhập hoặc ứng dụng không cho chèn.");
  }catch(err){
    const copied=await copy();
    if(copied)message("Không chèn trực tiếp được; đã sao chép để bạn Ctrl+V.");
    else message("Lỗi chèn: "+err.message,true);
  }
}
async function learn(){
  const source=el("wrong").value.trim(),target=el("right").value.trim();
  if(!source||!target||source===target||source.length>80||target.length>80){
    message("Nhập hai cụm khác nhau (tối đa 80 ký tự).",true);return;
  }
  const index=learned.findIndex(e=>e.source.toLowerCase()===source.toLowerCase());
  if(index>=0)learned[index]={source,target};
  else if(learned.length<256)learned.push({source,target});
  else {message("Từ điển đạt giới hạn 256 mục.",true);return;}
  await store.set({wpLearned:learned});
  updateCount();updateResult();
  el("wrong").value="";el("right").value="";
  message("Đã ghi nhớ cách sửa cho lần đọc tiếp theo.");
}
async function resetLearned(){
  if(!confirm("Xóa toàn bộ từ điển cá nhân?"))return;
  learned=[];await store.set({wpLearned:learned});
  updateCount();updateResult();message("Đã xóa từ điển cá nhân.");
}
async function init(){
  const saved=await store.get(["wpProvider","wpEndpoint","wpModel","wpLearned"]);
  learned=Array.isArray(saved.wpLearned)?saved.wpLearned.filter(e=>
    e&&typeof e.source==="string"&&typeof e.target==="string"):[];
  el("provider").value=saved.wpProvider==="remote"?"remote":"browser";
  el("endpoint").value=saved.wpEndpoint||"";
  el("model").value=saved.wpModel||"whisper-1";
  const session=await chrome.storage.session.get(["wpApiKey"]);
  el("apiKey").value=session.wpApiKey||"";
  updateCount();showProvider();
}
el("provider").addEventListener("change",()=>{showProvider();void store.set({wpProvider:provider()});});
el("saveSettings").addEventListener("click",()=>void saveConfig());
el("start").addEventListener("click",()=>void start());
el("stop").addEventListener("click",stop);
el("normalize").addEventListener("click",updateResult);
el("copy").addEventListener("click",()=>void copy());
el("insert").addEventListener("click",()=>void insert());
el("learn").addEventListener("click",()=>void learn());
el("clearLearned").addEventListener("click",()=>void resetLearned());
init().catch(err=>message("Lỗi khởi động: "+err.message,true));
