// Browser subset of lib/services/vietnamese_admin_text.dart.
// Deterministic STT post-processing; does not train or run a speech model.
export const DOCUMENT_TYPES = Object.freeze({
  "nghị quyết":"NQ","kết luận":"KL","chỉ thị":"CT","quyết định":"QĐ",
  "quy định":"QĐ","quy chế":"QC","báo cáo":"BC","biên bản":"BB",
  "công văn":"CV","tờ trình":"TTr","đề án":"ĐA","hướng dẫn":"HD",
  "kế hoạch":"KH","chương trình":"CTr","thông báo":"TB","thông tri":"TT",
});
export const ISSUERS = Object.freeze({
  "ban tuyên giáo và dân vận trung ương":"BTGDVTW",
  "ban tuyên giáo và dân vận tỉnh ủy":"BTGDVTU",
  "ủy ban kiểm tra trung ương":"UBKTTW",
  "ủy ban kiểm tra đảng ủy":"UBKTĐU",
  "đảng ủy công an huyện":"ĐUCAH",
  "ban tổ chức trung ương":"BTCTW",
  "ban tổ chức tỉnh ủy":"BTCTU",
  "ban tổ chức huyện ủy":"BTCHU",
  "văn phòng trung ương đảng":"VPTW",
  "văn phòng trung ương":"VPTW",
  "văn phòng tỉnh ủy":"VPTU",
  "văn phòng huyện ủy":"VPHU",
  "ban chấp hành trung ương":"TW",
  "ban thường vụ tỉnh ủy":"TU",
  "ban thường vụ huyện ủy":"HU",
  "ủy ban kiểm tra":"UBKT",
  "ban chỉ đạo":"BCĐ","tiểu ban":"TB","chi bộ":"CB",
  "quân ủy trung ương":"QUTW",
  "đảng ủy công an":"ĐUCA","đảng ủy quân sự":"ĐUQS",
  "ban bí thư":"TW","bộ chính trị":"TW",
  "trung ương":"TW","tỉnh ủy":"TU","huyện ủy":"HU",
  "đảng ủy":"ĐU","đại hội":"ĐH",
  "hát u":"HU","đê u":"ĐU","tê u":"TU","tê vê kép":"TW",
  "hu":"HU","tu":"TU","tw":"TW","vptw":"VPTW",
  "ubkttw":"UBKTTW","ubktđu":"UBKTĐU",
});
const CODE_TYPES = {
  ...DOCUMENT_TYPES, "en quy":"NQ","nờ quy":"NQ","nq":"NQ",
  "cê vê":"CV","xê vê":"CV","cv":"CV",
  "bê cê":"BC","bê xê":"BC","bc":"BC",
  "bê bê":"BB","bb":"BB",
  "quy đê":"QĐ","qđ":"QĐ","qd":"QĐ",
  "hát đê":"HD","hd":"HD","tê bê":"TB","tb":"TB",
  "ttr":"TTr","ctr":"CTr","kh":"KH","ct":"CT",
  "kl":"KL","qc":"QC","đa":"ĐA","tt":"TT",
};
const DIGITS={"không":0,"một":1,"hai":2,"ba":3,"bốn":4,"tư":4,
  "năm":5,"lăm":5,"sáu":6,"bảy":7,"tám":8,"chín":9,"mốt":1};
const NUMBER_WORDS=new Set([...Object.keys(DIGITS),"mười","mươi","trăm",
  "linh","lẻ","nghìn","ngàn"]);
const lower=(x)=>x.toLocaleLowerCase("vi").normalize("NFC");
function tokens(text) {
  return [...text.matchAll(/[\p{L}\p{M}]+|\d+/gu)].map(m=>
    ({word:lower(m[0]),start:m.index,end:m.index+m[0].length}));
}
function adjacent(text,t,a,b) {
  for(let i=a+1;i<b;i++) if(!/^[^\S\r\n]+$/u.test(text.slice(t[i-1].end,t[i].start))) return false;
  return true;
}
function match(text,t,at,map) {
  if(at>=t.length)return null;
  let best=null;
  for(const [phrase,code] of Object.entries(map)) {
    const words=phrase.split(" ");
    if(best&&best.next-at>=words.length)continue;
    if(at+words.length<=t.length&&adjacent(text,t,at,at+words.length)&&
      words.every((w,i)=>t[at+i].word===w))
      best={code,phrase,next:at+words.length};
  }
  return best;
}
function parseSmall(w) {
  if(!w.length)return 0;
  let i=0,n=0;
  if(w.length>=2&&w[1]==="trăm") {
    if(!(w[0] in DIGITS)||["mốt","lăm"].includes(w[0]))return null;
    n=DIGITS[w[0]]*100;i=2;
  }
  if(["linh","lẻ"].includes(w[i])) {
    if(!i)return null;
    i++;
  }
  if(i===w.length)return n;
  if(w[i]==="mười") {
    n+=10;i++;
    if(i<w.length) {if(!(w[i] in DIGITS))return null;n+=DIGITS[w[i++]];}
  } else if(w[i+1]==="mươi") {
    if(!(w[i] in DIGITS)||DIGITS[w[i]]<2)return null;
    n+=DIGITS[w[i]]*10;i+=2;
    if(i<w.length) {if(!(w[i] in DIGITS))return null;n+=DIGITS[w[i++]];}
  } else {
    if(!(w[i] in DIGITS)||["mốt","lăm"].includes(w[i]))return null;
    n+=DIGITS[w[i++]];
  }
  return i===w.length?n:null;
}
function parseWords(w) {
  if(w.length===1&&/^\d+$/u.test(w[0]))return {n:Number(w[0]),display:w[0]};
  if(w.length>=2&&w.length<=4&&(w[0]==="không"||w.length===4)&&
    w.every(x=>x in DIGITS)){
    const display=w.map(x=>DIGITS[x]).join("");
    return {n:Number(display),display};
  }
  const k=w.findIndex(x=>x==="nghìn"||x==="ngàn");
  if(k>=0) {
    if(!k||w.slice(k+1).some(x=>x==="nghìn"||x==="ngàn"))return null;
    const hi=parseSmall(w.slice(0,k));let low=w.slice(k+1);
    if(["linh","lẻ"].includes(low[0]))low=low.slice(1);
    const lo=parseSmall(low);
    if(hi===null||hi===0||lo===null)return null;
    const n=hi*1000+lo;return {n,display:String(n)};
  }
  const n=parseSmall(w);return n===null?null:{n,display:String(n)};
}
function readNumber(text,t,at,code=false){
  if(!t[at]||!(NUMBER_WORDS.has(t[at].word)||/^\d+$/u.test(t[at].word)))return null;
  let end=at;
  while(t[end]&&end-at<15&&
    (NUMBER_WORDS.has(t[end].word)||/^\d+$/u.test(t[end].word))&&
    adjacent(text,t,at,end+1))end++;
  let normal=null;
  for(let k=end;k>at;k--){
    const result=parseWords(t.slice(at,k).map(x=>x.word));
    if(result&&Number.isSafeInteger(result.n)){normal={...result,next:k};break;}
  }
  if(!code)return normal;
  let k=at;
  while(t[k]&&k-at<6&&(t[k].word in DIGITS)&&adjacent(text,t,at,k+1))k++;
  if(k-at>=2&&(!normal||normal.next<k)){
    const display=t.slice(at,k).map(x=>DIGITS[x.word]).join("");
    return {n:Number(display),display,next:k};
  }
  return normal;
}
function readBody(text,t,at) {
  return match(text,t,t[at]?.word==="của"?at+1:at,ISSUERS);
}
function compatible(a,b) {
  if(a.code!==b.code)return false;
  return a.code!=="QĐ"||a.phrase===b.phrase||
    ["qđ","qd","quy đê"].includes(b.phrase);
}
function edit(t,start,end,value){
  return {start:t[start].start,end:t[end-1].end,value};
}
function apply(text,edits) {
  let out=text,last=Infinity;
  for(const e of edits.sort((a,b)=>b.start-a.start)) {
    if(e.end>last)continue;
    out=out.slice(0,e.start)+e.value+out.slice(e.end);
    last=e.start;
  }
  return out;
}
function guarded(text,t,n){
  return !/^\s*[-/]/u.test(text.slice(t[n.next-1].end));
}
function spokenTypeFirst(text) {
  const t=tokens(text),edits=[];
  for(let i=0;i<t.length;i++){
    const first=match(text,t,i,DOCUMENT_TYPES);
    if(!first)continue;
    let at=first.next;
    if(t[at]?.word==="số")at++;
    const n=readNumber(text,t,at,true);
    if(!n||n.n>999999||!guarded(text,t,n)||!adjacent(text,t,i,n.next))continue;
    const kind=match(text,t,n.next,CODE_TYPES);
    if(!kind||!compatible(first,kind))continue;
    const body=readBody(text,t,kind.next);
    if(!body||!adjacent(text,t,n.next-1,body.next))continue;
    edits.push(edit(t,at,body.next,n.display+"-"+kind.code+"/"+body.code));
    i=body.next-1;
  }
  return apply(text,edits);
}
function spokenNumberFirst(text){
  const t=tokens(text),edits=[];
  for(let i=0;i<t.length;i++){
    if(t[i].word!=="số")continue;
    const n=readNumber(text,t,i+1,true);
    if(!n||n.n>999999||!guarded(text,t,n)||!adjacent(text,t,i,n.next))continue;
    const kind=match(text,t,n.next,CODE_TYPES);
    if(!kind)continue;
    const body=readBody(text,t,kind.next);
    if(!body||!adjacent(text,t,n.next-1,body.next))continue;
    // Mismatched explicit type before "số" must not silently be changed.
    const preceding=Object.entries(DOCUMENT_TYPES).find(([phrase])=>{
      const w=phrase.split(" ");return i>=w.length&&
        w.every((x,j)=>t[i-w.length+j].word===x)&&
        adjacent(text,t,i-w.length,i+1);
    });
    if(preceding&&!compatible({code:preceding[1],phrase:preceding[0]},kind))continue;
    edits.push(edit(t,i+1,body.next,n.display+"-"+kind.code+"/"+body.code));
    i=body.next-1;
  }
  return apply(text,edits);
}
function standalone(text){
  const t=tokens(text);
  if(!t.length)return text;
  const n=readNumber(text,t,0,true);
  if(!n||n.n>999999||!guarded(text,t,n))return text;
  const kind=match(text,t,n.next,CODE_TYPES);
  if(!kind)return text;
  const body=readBody(text,t,kind.next);
  // Don't turn quantities in sentences into document IDs.
  if(!body||body.next!==t.length||!adjacent(text,t,0,t.length))return text;
  return apply(text,[edit(t,0,body.next,n.display+"-"+kind.code+"/"+body.code)]);
}
function roman(n){
  const v=[[10,"X"],[9,"IX"],[5,"V"],[4,"IV"],[1,"I"]];
  let out="";
  for(const [x,s] of v)while(n>=x){out+=s;n-=x;}
  return out;
}
function romanRules(text) {
  const t=tokens(text),edits=[];
  for(let i=0;i<t.length;i++){
    const word=t[i].word;
    if(word==="đại"&&t[i+1]?.word==="hội"&&adjacent(text,t,i,i+2)){
      const marker=t[i+2]?.word;
      const explicit=["số","lần","thứ"].includes(marker);
      let at=i+(explicit?3:2);
      if(marker==="lần"&&t[at]?.word==="thứ")at++;
      if(!explicit){
        at=-1;
        for(let j=i+2;j+2<t.length&&j<i+14;j++){
          if(t[j].word==="lần"&&t[j+1].word==="thứ"&&
            !/[.!?;\n]/u.test(text.slice(t[i+1].end,t[j].start))){at=j+2;break;}
        }
      }
      if(at<0||!t[at]||(!explicit&&t[at].word==="năm"))continue;
      const n=readNumber(text,t,at);
      if(!n||n.n<1||n.n>30||!guarded(text,t,n))continue;
      edits.push(edit(t,marker==="số"?i+2:at,n.next,roman(n.n)));
      i=n.next-1;continue;
    }
    if((word==="khóa"||word==="quý")&&t[i+1]){
      if(word==="khóa"){
        const context=text.slice(Math.max(0,t[i].start-120),t[i].start)
          .toLowerCase().split(/[.!?;\n]/u).pop();
        if(context.includes("lớp ")||!["đại hội","đảng","quốc hội",
          "hội đồng nhân dân","ban chấp hành","tỉnh ủy","huyện ủy"]
          .some(x=>context.includes(x)))continue;
      }
      const n=readNumber(text,t,i+1);
      if(!n||n.n<1||n.n>(word==="quý"?4:30)||!guarded(text,t,n))continue;
      edits.push(edit(t,i+1,n.next,roman(n.n)));
      i=n.next-1;
    }
  }
  return apply(text,edits);
}
export function applyLearned(text,entries=[]) {
  let out=text;
  for(const {source,target} of [...entries].sort((a,b)=>b.source.length-a.source.length)){
    const a=source?.trim(),b=target?.trim();
    if(!a||!b||a.toLowerCase()===b.toLowerCase())continue;
    const quoted=a.replace(/[.*+?^$()|[\]{}\\]/g,"\\$&");
    out=out.replace(new RegExp("(?<![\\p{L}\\p{N}])"+quoted+
      "(?![\\p{L}\\p{N}])","giu"),()=>b);
  }
  return out;
}
export function normalize(text,learned=[]) {
  if(typeof text!=="string"||!text)return text||"";
  const v=text.normalize("NFC");
  return applyLearned(romanRules(standalone(spokenNumberFirst(spokenTypeFirst(v)))),learned);
}
