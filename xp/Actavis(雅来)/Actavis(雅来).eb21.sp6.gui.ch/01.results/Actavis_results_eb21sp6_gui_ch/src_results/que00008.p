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
results.name= "供应商余额汇总查询"
results.view-as= browse
results.table[1]= "qaddb.vd_mstr" "8148" "" "/*CHARACTER,qaddb.vd_mstr.vd_domain,=,:域*/ TRUE 
    and /*CHARACTER,qaddb.vd_mstr.vd_addr,RANGE,:输入供应商代码范围*/ TRUE 
    and (qaddb.vd_mstr.vd_balance <> 0 
    or qaddb.vd_mstr.vd_prepay <> 0) " no ""
results.table[2]= "qaddb.ad_mstr" "13228" "WHERE qaddb.ad_mstr.ad_domain = qaddb.vd_mstr.vd_domain AND qaddb.ad_mstr.ad_addr = qaddb.vd_mstr.vd_addr" "" no ""
results.field[1]= "qaddb.vd_mstr.vd_addr" "代码" "x(8)" "" "character" "" "1" ",,,,,,,,"
results.field[2]= "qaddb.ad_mstr.ad_name" "供应商名称" "x(28)" "" "character" "" "1" ",,,,,,,,"
results.field[3]= "qaddb.vd_mstr.vd_balance" "应付帐余额" "->>>,>>>,>>9.99" "t0" "decimal" "" "1" ",,,,,,,,"
results.field[4]= "qaddb.vd_mstr.vd_prepay" "预付帐余额" "->>,>>>,>>>,>>9.99" "t0" "decimal" "" "1" ",,,,,,,,"
results.field[5]= "qbf-005,qaddb.vd_mstr.vd_balance - qaddb.vd_mstr.vd_prepay" "应付总金额" "->>>>>>>9.99" "t0" "decimal" "n,qaddb.vd_mstr.vd_balance,qaddb.vd_mstr.vd_prepay" "1" ",,,,,,,,"
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
label.text[1]= "{qaddb.ad_mstr.ad_name}"
label.text[2]= "{qaddb.ad_mstr.ad_addr}"
label.text[3]= "{qaddb.ad_mstr.ad_city}, {qaddb.ad_mstr.ad_state} {qaddb.ad_mstr.ad_zip}"
label.text[4]= "{qaddb.ad_mstr.ad_country}"
report.format= "A4"
report.dimension= "210 x 297 mm"
report.time= 0:00
report.left-margin= 3
report.page-size= 70
report.page-width= 93
report.column-spacing= 1
report.line-spacing= 1
report.top-margin= 15
report.before-body= 1
report.after-body= 1
report.page-eject= ""
report.bottom-left[1]= "{TIME}"
report.bottom-right[1]= "{PAGE}"
report.first-only[1]= "应付帐款汇总报表"
*/

