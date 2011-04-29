/* xxpocima.p 利用xx_inv_mstr 和 xx_ship_det 自动cimload popomt poporc */
/*----rev history-------------------------------------------------------------------------------------*/
/* Revision: eb2sp4      BY: Ching Ye     DATE: 11/26/07  ECO: *SS - 20071126.1* */
/* SS - 110307.1  By: Roger Xiao */ /*原版{mfdtitle.i "2+ "}, vp_mstr 区分保税非保税,vp_part : P,M开头区分 */
/*-Revision end---------------------------------------------------------------*/


{mfdtitle.i "110307.1"}
   
/*定义变量*/
Define variable Eoutputstatment AS CHARACTER FORMAT "x(200)". 
Define variable Eonetime        AS CHARACTER FORMAT "x(1)" init "N".
Define variable outputstatment AS CHARACTER FORMAT "x(200)".
Define variable woutputstatment AS CHARACTER .
DEF VAR fn_me AS CHAR FORMAT "x(30)" INIT "/home/mfg/fn_me.txt" .
def var v9000 as char.
define var v_rctdate as date initial today .

def var site like si_site init "gsa01".
def var site1 like   si_site init "gsa01".
def var vend like  po_vend  .
def var vend1 like    po_vend  .
def var shipno like xx_ship_no  .
def var shipno1 like xx_ship_no  .
def var shipline like xx_ship_line init 0.
def var shipline1 like xx_ship_line init 9999.
def var rcvddate like tr_effdate init today.
def var tmpstr as char.
define variable usection as char format "x(16)".
def var tmpmonth as char.
def var j as integer.
def var i as integer.
def var datestr as char.
def var glbasecurr like gl_base_curr.
DEF VAR v_flag AS LOGICAL.
def var tstr as char.
def var tstr1 as char.
def var errstr as char.
def var ciminputfile  as char.
def var cimoutputfile as char.
def var tmp_order_qty like tr_qty_loc.
def var tmp_lot as char.
def var tmp_cost like tr_qty_loc.
def var tmp_fix_rate as char.
def var tmp_loc like pt_loc.
def var tmp_qty like tr_qty_loc.
def var tmp_part like pt_part.
def var tmp_flagt like pt_part.
def var tmp_line like pod_line.
def var  curr like  po_curr.
DEF VAR jj AS INTEGER .
DEF VAR tmp_ponbr LIKE po_nbr.
DEF VAR v_flagyn AS LOGICAL INIT NO .
DEF VAR v_flagpo AS LOGICAL INIT NO .

/* 取得xx_inv_mstr 和 xx_ship_det中的原始资料 */
DEF TEMP-TABLE pott 
    FIELD pott_shipno LIKE xx_ship_no
    FIELD pott_site LIKE xx_inv_site
    FIELD pott_vend LIKE xx_inv_vend
    FIELD pott_case like xx_ship_case
    FIELD pott_part_vend LIKE xx_ship_part
    FIELD pott_pkg LIKE xx_ship_pkg
    FIELD pott_qty_unit like xx_ship_qty_unit
    FIELD pott_qty like xx_ship_qty
    field pott_inv_pm  like xx_inv_pm   /* SS - 110307.1 */

    FIELD pott_status LIKE xx_ship_status
    FIELD pott_price like xx_ship_price
    FIELD pott_value like xx_ship_value
    FIELD pott_curr like xx_ship_curr
    FIELD pott_rcvddate like tr_effdate
    FIELD pott_line like xx_ship_line
    FIELD pott_part_zh like xx_ship_part
    field pott_loc like pt_loc
    field pott_lot like tr_serial
    field pott_fix_rate as char
    field pott_order_type like xx_ship_type
    field pott_rate like xx_inv_rate
    field pott_cost like xx_ship_price
    .

/* 在进行CIMLOAD之前，先显示要处理的数据 */
DEF TEMP-TABLE  tt1a
    field   tt1a_nbr like po_nbr
    field   tt1a_curr like po_curr
    field   tt1a_line like pod_line
    field   tt1a_vend like po_vend
    field   tt1a_fix_rate  as char
    field   tt1a_openqty like pod_qty_ord
    field   tt1a_part like pod_part
    field   tt1a_site like pod_site
    field   tt1a_lot like tr_serial
    field   tt1a_loc like pt_loc
    field   tt1a_flag as char
    field   tt1a_shipno like xx_ship_no
    field   tt1a_rmks like pt_desc1
    field   tt1a_vendpart like pt_part
    field   tt1a_rcvddate LIKE tr_effdate
    FIELD   tt1a_type AS CHAR
    FIELD   tt1a_cost LIKE xx_ship_price
    .

DEF TEMP-TABLE  tt2
    field   tt2_nbr like po_nbr.

/* 存放错误信息的资料 */
DEF TEMP-TABLE tte 
    FIELD tte_type1 AS CHAR
    FIELD tte_type AS CHAR
    FIELD tte_vend LIKE po_vend
    FIELD tte_part LIKE pt_part
    FIELD tte_desc AS CHAR FORMAT "x(120)".

/*定义过程*/
{xxpocimdatain_out.i}  

FORM
    SKIP(1)
    site      COLON 20    LABEL "地点" site1 colon 50 label   {t001.i}      
    vend      COLON 20    LABEL "供应商" vend1 colon 50 label   {t001.i}  
    shipno    COLON 20    LABEL "发票号" shipno1 colon 50 label   {t001.i}  
    shipline  COLON 20    LABEL "项次" shipline1 colon 50 label   {t001.i} 
    v_rctdate colon 20    label "到货日期"
    rcvddate  COLON 20    LABEL "收货生效日期"
    fn_me     COLON 20    LABEL "导入出错的信息文件"
    SKIP(1)
    v_flagpo  COLON 20    LABEL "是否创建新的PO"
    v_flagyn  COLON 20    LABEL "是否进行批量收货"
    SKIP(1)
    with frame a side-labels width 80 ATTR-SPACE .

/* Main Repeat */
mainloop:
repeat :
    hide all no-pause .
    view frame dtitle .
    view frame a .

    IF site1 = hi_char THEN site1 = "".
    IF vend1 = hi_char THEN vend1 = "".
    IF shipno1 = hi_char THEN shipno1 = "".

    update 
      site
      site1
      vend
      vend1
      shipno
      shipno1
      shipline
      shipline1
      v_rctdate
      rcvddate
      fn_me
      v_flagpo
      v_flagyn
      with frame a.
  
    IF site1 = "" THEN site1 = hi_char.
    IF vend1 = "" THEN vend1 = hi_char.
    IF shipno1 = "" THEN shipno1 = hi_char.

if v_rctdate = ? then do:
    message "错误:日期不可为空,请重新输入.". 
    next-prompt v_rctdate with frame a.
    undo,retry.
end.
if rcvddate = ? then do:
    message "错误:日期不可为空,请重新输入.". 
    next-prompt rcvddate with frame a.
    undo,retry.
end.



    {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
               
    {mfphead.i}
    
    /* 清空临时表 */
    FOR EACH pott:
      DELETE pott.
    END.
    FOR EACH tte:
      DELETE tte.
    END.
    FOR EACH tt1a:
      DELETE tt1a.
    END.
  
    /*检测数据*/
    {xxpocimcheck.i} 

    usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "poreceiver" .
    OUTPUT TO VALUE (fn_me) .
    /*OUTPUT TO VALUE (usection) .*/
    EXPORT DELIMITER ";" "类型" "错误类型" "客户代码" "订单/零件号" 
                         "错误描述" .
    FOR EACH tte :
        EXPORT DELIMITER ";" tte .
    END.
    OUTPUT CLOSE .

    UNDO mainloop, RETRY mainloop.   
end.
 
 
