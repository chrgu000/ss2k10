/*
databases= "qaddb"
config= query
version= 2.1A
results.status-area= true 
results.toolbar= true 
results.summary= false
results.governor= 0
results.govergen= false
results.detail-level= 0
results.name= "�й���ʽƾ֤��ӡ-�����ʲο���(��ʽ��ӡ)"
results.view-as= report
results.table[1]= "qaddb.glt_det" "53968" "" "/*CHARACTER,qaddb.glt_det.glt_domain,=,:��*/ TRUE  
 and  /*CHARACTER,qaddb.glt_det.glt_ref,RANGE,:�ο���*/ TRUE" no ""
results.table[2]= "qaddb.ac_mstr" "9634" "" "" no ""
results.table[3]= "qaddb.fm_mstr" "22094" "" "" no ""
results.table[4]= "qaddb.cc_mstr" "53253" "" "" no ""
results.field[1]= "qaddb.glt_det.glt_ref" "����ƾ֤��" "x(16)" "" "character" "" "1" ",,,,,,,,"
results.field[2]= "qaddb.glt_det.glt_acct" "�˻�" "x(6)" "" "character" "" "1" ",,,,,,,,"
results.field[3]= "qaddb.ac_mstr.ac_desc" "�˻�����" "x(22)" "" "character" "" "1" ",,,,,,,,"
results.field[4]= "qaddb.cc_mstr.cc_desc" "�ɱ�����" "x(8)" "" "character" "" "1" ",,,,,,,,"
results.field[5]= "qaddb.glt_det.glt_desc" "     ����" "x(20)" "" "character" "" "1" ",,,,,,,,"
results.field[6]= "qbf-006,IF ((qaddb.fm_mstr.fm_dr_cr AND (qaddb.glt_det.glt_amt >= 0))) THEN (qaddb.glt_det.glt_amt) ELSE ((IF ((qaddb.fm_mstr.fm_dr_cr AND (qaddb.glt_det.glt_amt < 0))) THEN (0) ELSE ((IF (qaddb.glt_det.glt_amt >= 0) THEN (qaddb.glt_det.glt_amt) ELSE (0)))))" "�跽���" "->>>>>>>9.99" "t1" "decimal" "n,qaddb.fm_mstr.fm_dr_cr,qaddb.glt_det.glt_amt" "1" ",,,,,,,,"
results.field[7]= "qbf-007,IF ((qaddb.fm_mstr.fm_dr_cr AND (qaddb.glt_det.glt_amt >= 0))) THEN (0) ELSE ((IF ((qaddb.fm_mstr.fm_dr_cr AND (qaddb.glt_det.glt_amt < 0))) THEN ((ABSOLUTE(qaddb.glt_det.glt_amt))) ELSE ((IF (qaddb.glt_det.glt_amt >= 0) THEN (0) ELSE ((ABSOLUTE(qaddb.glt_det.glt_amt)))))))" "�������" "->>>>>>>9.99" "t1" "decimal" "n,qaddb.fm_mstr.fm_dr_cr,qaddb.glt_det.glt_amt" "1" ",,,,,,,,"
results.order[1]= "qaddb.glt_det.glt_ref" "ascending"
results.order[2]= "qaddb.glt_det.glt_line" "ascending"
export.type= PROGRESS
export.use-headings= no 
export.fixed-width= no 
export.prepass= no 
export.base-date= ?
export.record-start= ""
export.record-end= "32,13,10"
export.field-delimiter= "34"
export.field-separator= "32"
export.delimit-type= "*"
export.description= "PROGRESS Export"
label.type= "Default layout"
label.dimension= "3-1/2""x15/16"""
label.left-margin= 0
label.label-width= 35
label.total-height= 5
label.vert-space= 1
label.horz-space= 0
label.number-across= 1
label.number-copies= 1
label.omit-blank= true 
report.format= "A4"
report.dimension= "210 x 297 mm"
report.time= 0:00
report.left-margin= 1
report.page-size= 22
report.page-width= 102
report.column-spacing= 0
report.line-spacing= 1
report.top-margin= 0
report.before-body= 1
report.after-body= 1
report.page-eject= "qaddb.glt_det.glt_ref"
report.top-center[1]= "����ƾ֤"
report.top-center[2]= "-----------"
report.bottom-left[1]= "|           �Ƶ��� {VALUE qaddb.glt_det.glt_userid;x(8)}"
report.bottom-right[1]= "��ˣ���������������������������������������"
*/

