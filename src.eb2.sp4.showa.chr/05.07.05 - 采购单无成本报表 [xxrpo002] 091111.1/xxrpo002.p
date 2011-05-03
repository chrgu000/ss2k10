/* ss - 091009.1 by: jack */
/* ss - 091111.1 by: jack */
/*-Revision end--------------------------------------------------------------------------*/



/* DISPLAY TITLE */

{mfdtitle.i "091111.1"}

DEFINE VAR poorddate LIKE po_ord_date .
DEFINE VAR poorddate1 LIKE po_ord_date .
DEFINE VAR nbr LIKE po_nbr .
DEFINE VAR nbr1 LIKE po_nbr .
DEFINE VAR vend LIKE po_vend .
DEFINE VAR vend1 LIKE po_vend .
DEFINE VAR v_name LIKE ad_name .

form
   poorddate           colon 16  
   poorddate1         label {t001.i}  colon 45  
   
    vend           colon 16  
   vend1        label {t001.i}  colon 45  
  
   nbr       colon 16  
   nbr1    label {t001.i}  colon 45  
   
  
   
   
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
   
    if vend1 = hi_char then vend1 = "" .
    if nbr1   = hi_char   then nbr1  = "".
    if poorddate  = low_date   then poorddate = ?.
    if poorddate1 = hi_date then poorddate1 = ? .
    
    
    
   

    UPDATE  poorddate poorddate1 vend vend1 nbr nbr1   with frame a.

    if vend1 = "" then vend1 = hi_char .
    if nbr1 = ""   then  nbr1  = hi_char .
    if poorddate = ?   then poorddate = low_date .
    if poorddate1 = ? then poorddate1 = hi_date .
    
    
    

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

export delimiter ";" "供应商" "供应商名称" "订单" "项次" "零件" "订单日期"  "单位" "订购数量"  . 


     FOR EACH po_mstr WHERE (po_ord_date >= poorddate AND po_ord_date <= poorddate1) AND (po_vend >= vend AND po_vend <= vend1),
          EACH pod_det  NO-LOCK WHERE pod_nbr = po_nbr AND pod_pur_cost = 0  BREAK BY pod_nbr BY pod_line :
    
       IF FIRST-OF(pod_nbr) THEN DO:
      
	  find first ad_mstr where ad_addr = po_vend no-lock no-error .
       IF AVAILABLE ad_mstr THEN
           v_name = ad_name .
       ELSE 
           v_name = "" .
        END.
	   export delimiter ";" po_vend v_name pod_nbr pod_line pod_part  po_ord_date pod_um  pod_qty_ord .
	
     {mfrpchk.i}
	  
	end .


end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}


    
