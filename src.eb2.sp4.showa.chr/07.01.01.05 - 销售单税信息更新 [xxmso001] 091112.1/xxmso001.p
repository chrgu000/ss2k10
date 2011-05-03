/* ss - 091112.1 by: jack */
/*-Revision end--------------------------------------------------------------------------*/



/* DISPLAY TITLE */

{mfdtitle.i "091112.1"}


DEFINE VAR nbr LIKE so_nbr .
DEFINE VAR nbr1 LIKE so_nbr .
DEFINE VAR cust LIKE so_cust .
DEFINE VAR cust1 LIKE so_cust .
define var ord like so_ord_date .
define var ord1 like so_ord_date .
define var v_update AS LOGICAL  .

DEFINE TEMP-TABLE tt
    FIELD tt_nbr LIKE so_nbr
    FIELD tt_cust LIKE so_cust
    FIELD tt_curr LIKE so_curr
    FIELD tt_line LIKE sod_line
    FIELD tt_tax_usage LIKE sod_tax_usage
    FIELD tt_tax_env LIKE sod_tax_env
    FIELD tt_taxc LIKE sod_taxc
    FIELD tt_taxable LIKE sod_taxable
    FIELD tt_tax_in LIKE sod_tax_in
    .

form

   nbr           colon 16  
   nbr1        label {t001.i}  colon 45  
   
   cust       colon 16  
   cust1    label {t001.i}  colon 45  
    
   ord      colon 16  
   ord1    label {t001.i} colon 45  SKIP
    v_update COLON 16  LABEL "更新"
 SKIP(1)
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
   
    
   
    if nbr1  = hi_char   then nbr1 = "".
    if cust1   = hi_char   then cust1  = "".
   if ord = low_date then ord = ? .
    if ord1 = hi_date then ord1 = ? .
    
   

    UPDATE  nbr nbr1 cust cust1 ord  ord1 v_update  with frame a.

    
    if nbr1 = ""   then nbr1 = hi_char .
    if cust1 = ""   then  cust1  = hi_char .
    if  ord = ? then ord = low_date  .
    if  ord1 = ? then ord1 = hi_date  .
    

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

export delimiter ";" "订单"  "客户"  "客户币别" "项次" "零件"  "税用途" "税环境" "税类别" "应纳税" "是否含税"   .

  FOR EACH so_mstr NO-LOCK WHERE (so_nbr >= nbr AND so_nbr <= nbr1 ) 
      AND (so_cust >= cust AND so_cust <= cust1)
      AND (so_ord_date >= ord AND so_ord_date <= ord1) ,
      EACH sod_det NO-LOCK WHERE sod_nbr = so_nbr   :
        
      FIND FIRST cm_mstr WHERE cm_addr = so_cust NO-LOCK NO-ERROR .
      IF AVAILABLE cm_mstr THEN DO:
          IF cm_curr = "RMB" THEN DO:
              IF sod_tax_usage <> "s17" OR sod_tax_env <> "china" OR sod_taxc <> "vp" OR sod_taxable =   NO OR sod_tax_in = YES   THEN DO:
                  
                  CREATE tt  .
                  
                  ASSIGN
                      tt_nbr = sod_nbr
                      tt_line = sod_line
                      tt_curr = cm_curr
                      tt_cust = so_cust
                      tt_tax_usage = sod_tax_usage
                      tt_tax_env = sod_tax_env
                      tt_taxc = sod_taxc
                      tt_taxable = sod_taxable
                      tt_tax_in = sod_tax_in 
                      .
              END.

          END.    /* cm_curr = "rmb" */
          ELSE DO:
                IF sod_tax_usage <> "S0" OR sod_tax_env <> "china" OR sod_taxc <> "vp" OR sod_taxable =   NO OR sod_tax_in = YES   THEN DO:
                  CREATE tt  .
                  ASSIGN
                      tt_nbr = sod_nbr
                      tt_line = sod_line
                      tt_curr = cm_curr
                      tt_cust = so_cust
                      tt_tax_usage = sod_tax_usage
                      tt_tax_env = sod_tax_env
                      tt_taxc = sod_taxc
                      tt_taxable = sod_taxable
                      tt_tax_in = sod_tax_in 
                      .
              END.
          END.        /* cm_curr <> "rmb" */
      END.  /* avaiailabel cm_mstr */

    END.    /* so_mstr */

    
    FOR EACH tt NO-LOCK BREAK BY tt_nbr BY tt_line :
     
        IF v_update  THEN DO:
              
             FIND FIRST sod_det WHERE sod_nbr = tt_nbr AND sod_line = tt_line NO-ERROR .
              IF AVAILABLE sod_det  THEN DO:
                  IF tt_curr = "rmb" THEN DO:
                      ASSIGN
                          sod_tax_usage = "S17"
                          sod_tax_env = "CHINA"
                          sod_taxc = "VP"
                          sod_taxable = YES
                          sod_tax_in = NO
                           .
                  END.
                  ELSE DO:
                       ASSIGN
                          sod_tax_usage = "S0"
                          sod_tax_env = "CHINA"
                          sod_taxc = "VP"
                          sod_taxable = YES
                          sod_tax_in = NO
                           .

                  END.
              END.

        END.
       
        EXPORT DELIMITER ";" tt .	
      
       {mfrpchk.i}
      
    end .

end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}


    
