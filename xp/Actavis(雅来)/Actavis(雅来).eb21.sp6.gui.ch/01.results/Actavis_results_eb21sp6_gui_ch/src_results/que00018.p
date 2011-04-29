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
results.name= "回款查询"
results.view-as= report
results.table[1]= "qaddb.ar_mstr" "48795" "" "/*CHARACTER,qaddb.ar_mstr.ar_domain,=,:域*/ TRUE 
 and /*DATE,qaddb.ar_mstr.ar_effdate,RANGE,:收款日期范围*/ TRUE
 AND qaddb.ar_mstr.ar_type = ""P""
 AND /*CHARACTER,qaddb.ar_mstr.ar_bill,RANGE,:客户编码范围*/ TRUE" no ""
results.table[2]= "qaddb.ad_mstr" "13228" "WHERE qaddb.ad_mstr.ad_domain = qaddb.ar_mstr.ar_domain and qaddb.ad_mstr.ad_addr = qaddb.ar_mstr.ar_acct " "" no ""
results.table[3]= "qaddb.ard_det" "50530" "WHERE qaddb.ard_det.ard_domain = qaddb.ar_mstr.ar_domain AND  qaddb.ard_det.ard_nbr = qaddb.ar_mstr.ar_nbr" "qaddb.ard_det.ard_type <> ""N"" " no ""
results.table[4]= "qaddb.cm_mstr" "61396" "WHERE qaddb.ad_mstr.ad_domain = qaddb.cm_mstr.cm_domain AND  qaddb.ad_mstr.ad_addr = qaddb.cm_mstr.cm_addr" "" no ""
results.field[1]= "qaddb.ar_mstr.ar_bill" "Bill-To" "x(8)" "" "character" "" "1" ",,,,,,,,"
results.field[2]= "qaddb.ad_mstr.ad_name" "Name" "x(28)" "" "character" "" "1" ",,,,,,,,"
results.field[3]= "qaddb.cm_mstr.cm_type" "Type" "x(4)" "" "character" "" "1" ",,,,,,,,"
results.field[4]= "qaddb.cm_mstr.cm_region" "Region" "x(4)" "" "character" "" "1" ",,,,,,,,"
results.field[5]= "qaddb.ar_mstr.ar_effdate" "Eff Date" "99/99/99" "" "date" "" "1" ",,,,,,,,"
results.field[6]= "qaddb.ard_det.ard_amt" "Amount" "->>>>,>>>,>>9.99" "t0t1" "decimal" "" "1" ",,,,,,,,"
results.field[7]= "qaddb.ard_det.ard_ref" "Invoice No." "x(8)" "" "character" "" "1" ",,,,,,,,"
results.field[8]= "qaddb.ar_mstr.ar_prepayment" "Prepayment" "yes/no" "" "logical" "" "1" ",,,,,,,,"
results.field[9]= "qbf-009,SUBSTRING(qaddb.ard_det.ard_nbr,INTEGER((LENGTH(qaddb.ar_mstr.ar_bill) + 1)),INTEGER(8))" "Check Num" "x(15)" "" "character" "s,qaddb.ard_det.ard_nbr,qaddb.ar_mstr.ar_bill" "1" ",,,,,,,,"
results.field[10]= "qaddb.ard_det.ard_type" "T" "x(1)" "" "character" "" "1" ",,,,,,,,"
results.order[1]= "qaddb.ar_mstr.ar_bill" "ascending"
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
report.format= "Letter"
report.dimension= "8-1/2 x 11 in"
report.time= 0:01
report.left-margin= 1
report.page-size= 60
report.page-width= 122
report.column-spacing= 1
report.line-spacing= 1
report.top-margin= 1
report.before-body= 1
report.after-body= 1
report.page-eject= ""
report.top-center[1]= "回款查询"
*/

