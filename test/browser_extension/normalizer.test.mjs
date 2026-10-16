import test from "node:test";
import assert from "node:assert/strict";
import {normalize,singleWordCorrection,DOCUMENT_TYPES,ISSUERS,applyLearned}
  from "../../browser-extension/normalizer.mjs";

test("the important Vietnamese archive and Roman numeral examples",()=>{
  const examples=[
    ["hai mươi chín công văn đảng ủy","29-CV/ĐU"],
    ["số hai chín công văn đảng ủy","số 29-CV/ĐU"],
    ["Nghị quyết không ba en quy hát u","Nghị quyết 03-NQ/HU"],
    ["công văn số hai mươi chín công văn đảng ủy","công văn số 29-CV/ĐU"],
    ["báo cáo không hai báo cáo đảng ủy","báo cáo 02-BC/ĐU"],
    ["quyết định số 23 quyết định ủy ban kiểm tra đảng ủy",
      "quyết định số 23-QĐ/UBKTĐU"],
    ["Đại hội số năm 2026","Đại hội V 2026"],
    ["Đại hội năm 2026","Đại hội năm 2026"],
    ["Đại hội số mười ba","Đại hội XIII"],
    ["Đại hội lần thứ năm","Đại hội lần thứ V"],
    ["Quốc hội khóa mười lăm","Quốc hội khóa XV"],
    ["quý bốn năm 2026","quý IV năm 2026"],
    ["29 công văn đảng ủy cần xử lý","29 công văn đảng ủy cần xử lý"],
    ["số 29, công văn đảng ủy","số 29, công văn đảng ủy"],
    ["Quyết định 29 quy định đảng ủy",
      "Quyết định 29 quy định đảng ủy"],
    ["191/CV/ĐU","191/CV/ĐU"],
    ["05-TTr/ĐU","05-TTr/ĐU"],
  ];
  for(const [input,expected] of examples){
    assert.equal(normalize(input),expected,input);
    assert.equal(normalize(normalize(input)),expected,"idempotent: "+input);
  }
});

test("192 combinations of documented types and named issuing bodies",()=>{
  const wanted=[
    "đảng ủy","huyện ủy","tỉnh ủy","trung ương",
    "văn phòng trung ương","ủy ban kiểm tra trung ương",
    "ủy ban kiểm tra đảng ủy","chi bộ","ban chỉ đạo",
    "tiểu ban","đảng ủy công an","đảng ủy công an huyện",
  ];
  for(const [type,code] of Object.entries(DOCUMENT_TYPES)){
    for(const issuer of wanted){
      const input=type+" số hai mươi chín "+type+" "+issuer;
      const expected=type+" số 29-"+code+"/"+ISSUERS[issuer];
      assert.equal(normalize(input),expected,input);
    }
  }
});

test("single word learning rejects unsafe or ambiguous changes",()=>{
  assert.deepEqual(singleWordCorrection("Báo cáo của huyền ủy",
    "Báo cáo của huyện ủy"),{source:"huyền",target:"huyện"});
  assert.equal(singleWordCorrection("văn bản A","văn bản B"),null);
  assert.equal(singleWordCorrection("Nghị quyết không ba","Nghị quyết 03"),null);
  assert.equal(singleWordCorrection("Công văn Đảng ủy","Công văn ĐU"),null);
  assert.equal(singleWordCorrection("Nghị quyết 03-NQ/HU","Nghị quyết 03-NQ/TW"),null);
  assert.equal(singleWordCorrection("hai sai","ba đúng"),null);
  assert.equal(applyLearned("của huyền ủy",[{source:"huyền",target:"huyện"}]),
    "của huyện ủy");
});
