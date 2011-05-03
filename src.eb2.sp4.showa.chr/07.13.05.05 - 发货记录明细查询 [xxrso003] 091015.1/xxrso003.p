/* ss - 091015.1 by: jack */
/*-Revision end--------------------------------------------------------------------------*/



/* DISPLAY TITLE */

{mfdtitle.i "091015.1"}

DEFINE VAR eff_date LIKE so_ord_date .
DEFINE VAR eff_date1 LIKE so_ord_date .
DEFINE VAR socust LIKE so_cust .
DEFINE VAR socust1 LIKE so_cust .
DEFINE VAR v_channel LIKE so_channel .
DEFINE VAR v_name LIKE ad_name .

DEFINE TEMP-TABLE tt
    FIELD t1_vend LIKE so_cust
    FIELD t1_name LIKE ad_name
    FIELD t1_channel LIKE so_channel
    FIELD t1_nbr LIKE sod_nbr
    FIELD t1_line LIKE sod_line
    FIELD t1_date LIKE tr_effdate
    FIELD t1_tax_usage LIKE sod_tax_usage
    FIELD t1_tax_env LIKE sod_tax_env
    FIELD t1_taxc LIKE sod_taxc
    FIELD t1_taxable LIKE sod_taxable
    FIELD t1_tax_in LIKE sod_tax_in
    FIELD t1_part LIKE sod_part
    FIELD t1_qty_ship LIKE sod_qty_ship
    FIELD t1_price LIKE sod_list_pr
    FIELD t1_amt  AS  DECIMAL FORMAT "->>>,>>>,>>>,>>9.99<<<"
    FIELD t1_curr LIKE tr_curr
    FIELD t1_ex_rate LIKE tr_ex_rate
   

    .

form
   
   socust           colon 25 
  

   eff_date           colon 16  
   eff_date1         label {t001.i}  colon 45 

  
  
   
   
   
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
   
    
    if eff_date  = low_date   then eff_date = ?.
    if eff_date1 = hi_date then eff_date1 = ? .
    
    
    
   

    UPDATE  socust eff_date eff_date1      with frame a.

   
    if eff_date = ?   then eff_date = low_date .
    if eff_date1 = ? then eff_date1 = hi_date .
    
    
    

    /* PRINTER SELECTION */
    /* OUTPUT DESTINATION SELECTION */
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
mainloop: 
do on error undo, return error on endkey undo, return error:                    



PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname,1,LENGTH(execname) - 2) SKIP.
PUT UNFORMATTED "#def :end" SKIP.

export delimiter ";"   "客户"  "客户名称"  "渠道"  "订单" "项次"    "零件"  "发货日期"  "发货数量" "单价（原币）"  "金额（原币）"  "货币"  "汇率"  "税用途"  "税环境"  "税类别" "是否纳税"  "是否含税"  . 

  FOR EACH tr_hist USE-INDEX tr_addr_eff NO-LOCK WHERE tr_addr = socust AND 
           (tr_effdate >= eff_date AND tr_effdate <= eff_date1) AND tr_type = "iss-so" :
          FIND FIRST so_mstr WHERE so_nbr = tr_nbr NO-LOCK NO-ERROR .
          IF AVAILABLE so_mstr THEN
              v_channel = so_channel .
         ELSE v_channel = "" .

        FIND FIRST ad_mstr WHERE ad_addr = tr_addr NO-LOCK NO-ERROR .
            IF AVAILABLE ad_mstr THEN
                v_name = ad_name .
             ELSE 
                 v_name = "" .
      
          FIND FIRST sod_det WHERE sod_nbr = tr_nbr AND sod_line = tr_line NO-LOCK NO-ERROR .
          IF AVAILABLE sod_det  THEN DO:
      
               CREATE tt .
              
               ASSIGN
                   t1_vend = tr_addr
                   t1_name = v_name
                   t1_channel = v_channel
                   t1_part = tr_part
                   t1_qty_ship = - tr_qty_chg
                   t1_price = tr_price * tr_ex_rate
                   t1_amt = tr_price * tr_ex_rate * ( - tr_qty_chg )
                   t1_curr = tr_curr
                   t1_ex_rate = tr_ex_rate
                   t1_nbr = sod_nbr
                   t1_line = sod_line
                   t1_date = tr_effdate
                   t1_tax_usage = sod_tax_usage
                   t1_tax_env = sod_tax_env
                   t1_taxc = sod_taxc
                   t1_taxable = sod_taxable 
                   t1_tax_in = sod_tax_in
                   .
          END.
               
  END.

  FOR EACH tt NO-LOCK BREAK BY t1_vend  BY t1_channel BY t1_part BY t1_date:
  
     export delimiter ";" t1_vend t1_name t1_channel  t1_nbr t1_line t1_part  t1_date   t1_qty_ship  t1_price  t1_amt
            t1_curr t1_ex_rate t1_tax_usage t1_tax_env t1_taxc  t1_taxable t1_tax_in  .
	  
     {mfrpchk.i}
	  
	end .


end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}


    
