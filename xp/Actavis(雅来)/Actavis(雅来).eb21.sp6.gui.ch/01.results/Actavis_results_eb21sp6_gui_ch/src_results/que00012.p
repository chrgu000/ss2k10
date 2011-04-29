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
results.name= "中国格式凭证打印-按总帐参考号"
results.view-as= report
results.table[1]= "qaddb.glt_det" "53968" "" "/*CHARACTER,qaddb.glt_det.glt_domain,=,:域*/ TRUE  
    and /*CHARACTER,qaddb.glt_det.glt_ref,RANGE,:参考号*/ TRUE" no ""
results.table[2]= "qaddb.ac_mstr" "9634" "" "" no ""
results.table[3]= "qaddb.fm_mstr" "22094" "" "" no ""
results.field[1]= "qaddb.glt_det.glt_ref" "总帐凭证号" "x(14)" "" "character" "" "1" ",,,,,,,,"
results.field[2]= "qaddb.glt_det.glt_acct" "账户代码" "x(8)" "" "character" "" "1" ",,,,,,,,"
results.field[3]= "qaddb.ac_mstr.ac_desc" "账户名称" "x(24)" "" "character" "" "1" ",,,,,,,,"
results.field[4]= "qaddb.glt_det.glt_sub" "Sub-Acct" "x(8)" "" "character" "" "1" ",,,,,,,,"
results.field[5]= "qaddb.glt_det.glt_cc" "成本中心" "x(4)" "" "character" "" "1" ",,,,,,,,"
results.field[6]= "qaddb.glt_det.glt_project" "Project" "x(8)" "" "character" "" "1" ",,,,,,,,"
results.field[7]= "qaddb.glt_det.glt_desc" "Description" "x(24)" "" "character" "" "1" ",,,,,,,,"
results.field[8]= "qbf-008,IF ((qaddb.fm_mstr.fm_dr_cr AND (qaddb.glt_det.glt_amt >= 0))) THEN (qaddb.glt_det.glt_amt) ELSE ((IF ((qaddb.fm_mstr.fm_dr_cr AND (qaddb.glt_det.glt_amt < 0))) THEN (0) ELSE ((IF (qaddb.glt_det.glt_amt >= 0) THEN (qaddb.glt_det.glt_amt) ELSE (0)))))" "借方金额" "->>>>>>>9.99" "t1" "decimal" "n,qaddb.fm_mstr.fm_dr_cr,qaddb.glt_det.glt_amt" "1" ",,,,,,,,"
results.field[9]= "qbf-009,IF ((qaddb.fm_mstr.fm_dr_cr AND (qaddb.glt_det.glt_amt >= 0))) THEN (0) ELSE ((IF ((qaddb.fm_mstr.fm_dr_cr AND (qaddb.glt_det.glt_amt < 0))) THEN ((ABSOLUTE(qaddb.glt_det.glt_amt))) ELSE ((IF (qaddb.glt_det.glt_amt >= 0) THEN (0) ELSE ((ABSOLUTE(qaddb.glt_det.glt_amt)))))))" "贷方金额" "->>>>>>>9.99" "t1" "decimal" "n,qaddb.fm_mstr.fm_dr_cr,qaddb.glt_det.glt_amt" "1" ",,,,,,,,"
results.order[1]= "qaddb.glt_det.glt_ref" "ascending"
results.order[2]= "qaddb.glt_det.glt_acct" "ascending"
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
report.time= 0:01
report.left-margin= 1
report.page-size= 22
report.page-width= 140
report.column-spacing= 2
report.line-spacing= 1
report.top-margin= 1
report.before-body= 1
report.after-body= 1
report.page-eject= "qaddb.glt_det.glt_ref"
report.top-center[1]= "记帐凭证"
report.top-center[2]= "-----------"
report.bottom-left[1]= "|           制单： {VALUE qaddb.glt_det.glt_userid;x(8)}"
report.bottom-right[1]= "审核：　　　　　　　　　　　　　　｜"
*/

