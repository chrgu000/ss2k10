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
results.name= "未过账总帐事务查询-按科目汇总"
results.view-as= browse
results.table[1]= "qaddb.glt_det" "53968" "" "/*CHARACTER,qaddb.glt_det.glt_domain,=,:域*/ TRUE 
    and /*DATE,qaddb.glt_det.glt_effdate,RANGE,:输入日期*/ TRUE  
    AND  /*CHARACTER,qaddb.glt_det.glt_acct,RANGE,:输入帐户*/ TRUE  
    AND /*CHARACTER,qaddb.glt_det.glt_cc,RANGE,:输入成本中心*/ TRUE " no ""
results.field[1]= "qaddb.glt_det.glt_acct" "Account" "x(8)" "" "character" "" "1" ",,,,,,,,"
results.field[2]= "qaddb.glt_det.glt_sub" "Sub-Acct" "x(8)" "" "character" "" "1" ",,,,,,,,"
results.field[3]= "qaddb.glt_det.glt_cc" "CC" "x(4)" "" "character" "" "1" ",,,,,,,,"
results.field[4]= "qaddb.glt_det.glt_project" "Project" "x(8)" "" "character" "" "1" ",,,,,,,,"
results.field[5]= "qaddb.glt_det.glt_desc" "Description" "x(24)" "" "character" "" "1" ",,,,,,,,"
results.field[6]= "qaddb.glt_det.glt_amt" "Amount" "->>,>>>,>>>,>>9.99" "t1" "decimal" "" "1" ",,,,,,,,"
results.field[7]= "qaddb.glt_det.glt_doc" "Document" "x(16)" "" "character" "" "1" ",,,,,,,,"
results.field[8]= "qaddb.glt_det.glt_ref" "GL Reference" "x(14)" "" "character" "" "1" ",,,,,,,,"
results.field[9]= "qaddb.glt_det.glt_batch" "Batch" "x(8)" "" "character" "" "1" ",,,,,,,,"
results.order[1]= "qaddb.glt_det.glt_acct" "ascending"
results.order[2]= "qaddb.glt_det.glt_sub" "ascending"
results.order[3]= "qaddb.glt_det.glt_cc" "ascending"
results.order[4]= "qaddb.glt_det.glt_project" "ascending"
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
browse.prop[1]= "qaddb.glt_det" 3.74 "" 9
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
label.text[1]= "{qaddb.glt_det.glt_addr}"
report.format= "A4"
report.dimension= "210 x 297 mm"
report.time= 0:00
report.left-margin= 10
report.page-size= 70
report.page-width= 131
report.column-spacing= 1
report.line-spacing= 1
report.top-margin= 1
report.before-body= 1
report.after-body= 1
report.page-eject= ""
report.top-left[1]= "{VALUE qaddb.glt_det.glt_ref;x(14)}"
report.bottom-left[1]= "记账："
report.bottom-right[1]= "审核："
report.first-only[1]= " 未过账凭证汇总表"
report.first-only[2]= "---------------------"
*/

