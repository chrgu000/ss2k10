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
    FIELD t1_part LIKE sod_part
    FIELD t1_qty_ship LIKE sod_qty_ship
    FIELD t1_price LIKE sod_list_pr
    FIELD t1_amt  AS  DECIMAL FORMAT "->>>,>>>,>>>,>>9.99<<<"
    FIELD t1_curr LIKE tr_curr
    FIELD t1_ex_rate LIKE tr_ex_rate
    FIELD t1_date LIKE tr_effdate
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

export delimiter ";"   "客户"  "客户名称"  "渠道"   "零件"  "发货数量" "单价（原币）"  "金额（原币）"  "货币"  "汇率"  . 

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
                   .

               
  END.

  FOR EACH tt NO-LOCK BREAK BY t1_vend  BY t1_channel BY t1_part:
  
      ACCUMULATE t1_qty_ship (TOTAL BY t1_part).
      ACCUMULATE t1_amt (TOTAL BY t1_part).
         
      IF LAST-OF(t1_part) THEN
	   export delimiter ";" t1_vend t1_name t1_channel t1_part  ( ACCUMULATE TOTAL BY t1_part t1_qty_ship )  t1_price (ACCUMULATE TOTAL BY t1_part t1_amt) t1_curr t1_ex_rate  .
	  
     {mfrpchk.i}
	  
	end .


end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}


    
