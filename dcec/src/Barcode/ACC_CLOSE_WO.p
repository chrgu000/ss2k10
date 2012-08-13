{mfdtitle.i }
DEFINE VAR mdate like wo_ord_date label "date". 
DEFINE VAR mdate1 like wo_ord_date LABEL "To".
DEFINE VAR entity LIKE acd_entity.
DEFINE VAR mperiod LIKE acd_per.
DEFINE VAR myear AS INT FORMAT "9999".
DEFINE VAR pre_iss_amount LIKE tr_gl_amt INITIAL "0" LABEL "pre_iss".
DEFINE VAR cur_iss_amount LIKE tr_gl_amt INITIAL "0" LABEL "cur_iss".
DEFINE VAR pre_rct_amount LIKE tr_gl_amt INITIAL "0" LABEL "pre_rct".
DEFINE VAR cur_rct_amount LIKE tr_gl_amt INITIAL "0" LABEL "cur_rct".
DEFINE VAR pre_lbr LIKE op_lbr_cost INITIAL "0" LABEL "pre_lbr".
DEFINE VAR cur_lbr LIKE op_lbr_cost INITIAL "0" LABEL "cur_lbr".
DEFINE VAR pre_bdn LIKE op_bdn_cost INITIAL "0" LABEL "pre_bdn".
DEFINE VAR cur_bdn LIKE op_bdn_cost INITIAL "0" LABEL "cur_bdn".
DEFINE VAR mraw_tot LIKE tr_gl_amt INITIAL "0" LABEL "consume_tot".
DEFINE VAR rct_tot LIKE tr_gl_amt INITIAL "0" LABEL "rct_tot".
DEFINE VAR o_var LIKE wo_mtl_var INITIAL "0" LABEL "other_var".
DEFINE VAR var_tot LIKE wo_mtl_var INITIAL "0" LABEL "var_tot".
DEFINE VAR bal AS INT INITIAL "0" LABEL "Balance".
FORM
    SKIP(0.5)
    entity COLON 12 
    mperiod COLON 35 LABEL "Period"
    myear COLON 50 LABEL "Year"
   
    WITH FRAME a  WIDTH 80 THREE-D SIDE-LABELS.

ASSIGN /*sys_date = TODAY*/
          myear = YEAR(TODAY).
 FIND FIRST gl_ctrl NO-LOCK NO-ERROR.  
 entity = gl_entity.
 FIND FIRST glc_cal WHERE glc_start <= TODAY AND glc_end >= TODAY NO-LOCK NO-ERROR.
 mperiod = glc_per.

/*DEFINE FRAME out 
    
    wo_ord_date /*COLON 10*/
    wo_due_date /*COLON 25*/
    
     wo_stat_close_date /*COLON 40*/
    wo_close_date /*COLON 55*/
    wo_nbr /*COLON 70*/
    wo_lot /*COLON 90*/

    wo_part /*COLON 100*/
    pt_desc1 /*COLON 125*/
    
    wo_qty_comp /*COLON 150*/
    wo_routing /*COLON 170*/
    wo_lbr_tot /*COLON 190*/
    wo_bdn_tot /*COLON 210*/
    wo_mthd_var /*COLON 230*/
    sct_lbr_tl /*COLON 245*/
    sct_bdn_tl /*COLON 265*/
  
   pt_desc2 /*colon 125 */
    WITH   STREAM-IO DOWN WIDTH 290.*/
DEFINE FRAME out
    wo_ord_date 
   /* wo_due_date
    wo_stat_close_date 
    wo_close_date */
    wo_nbr 
    wo_lot 
    wo_status LABEL "status"
   pre_iss_amount
   cur_iss_amount
   pre_bdn
            cur_bdn
            pre_lbr
            cur_lbr
          mraw_tot
            pre_rct_amount
            cur_rct_amount
         rct_tot
            
            
            
            
            wo_mtl_var
            /* wo_part 
    pt_desc1 
  pt_desc2
    wo_qty_comp */
    /*wo_routing 
    wo_lbr_tot 
    wo_bdn_tot*/ 
    wo_mthd_var 
    o_var
            var_tot
          bal
    WITH STREAM-IO DOWN WIDTH 290.
/*setFrameLabels(FRAME OUT : HANDLE).*/
REPEAT:
     DISPLAY mperiod entity myear WITH FRAME a.     
    /*if mdate = low_date then mdate = ?.
if mdate1 = hi_date then mdate1 = ?.
UPDATE mdate mdate1 WITH FRAME a.
IF MDATE = ? THEN MDATE = LOW_DATE.

IF MDATE1 = ? THEN MDATE1 = HI_DATE.*/

  /* OUTPUT DESTINATION SELECTION */
  /* {gpselout.i &printType = "printer"
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
               &defineVariables = "yes"}*/
                {mfselbpr.i "printer" 80}

   {mfphead.i}
                    FIND FIRST glc_cal WHERE glc_start <= TODAY AND glc_end >= TODAY NO-LOCK NO-ERROR.

                    FOR EACH wo_mstr WHERE wo_acct_close = NO OR (wo_acct_close AND month(wo_close_date) = glc_per AND YEAR(wo_close_date) = glc_year)  NO-LOCK WITH FRAME out WIDTH 290 :
      FIND pt_mstr WHERE pt_part = wo_part NO-LOCK NO-ERROR.
     /* FIND sct_det WHERE sct_part = wo_part AND sct_site = wo_site AND sct_sim = 'standard' NO-LOCK NO-ERROR.*/
      /*put skip.*/
    FOR EACH tr_hist WHERE tr_type = 'iss-wo' AND tr_nbr = wo_nbr AND tr_lot = wo_lot AND tr_effdate < glc_start NO-LOCK:
       pre_iss_amount = pre_iss_amount + tr_gl_amt.
        
        END.
         FOR EACH tr_hist WHERE tr_type = 'iss-wo' AND tr_nbr = wo_nbr AND tr_lot = wo_lot AND tr_effdate >= glc_start AND tr_effdate <= glc_end NO-LOCK:
      cur_iss_amount = cur_iss_amount + tr_gl_amt.
        
        END. 
        FOR EACH tr_hist WHERE tr_type = 'rct-wo' AND tr_nbr = wo_nbr AND tr_lot = wo_lot AND tr_effdate < glc_start NO-LOCK:
      pre_rct_amount = pre_rct_amount + tr_gl_amt.
        END.
         FOR EACH tr_hist WHERE tr_type = 'rct-wo' AND tr_nbr = wo_nbr AND tr_lot = wo_lot AND tr_effdate >= glc_start AND tr_effdate <= glc_end NO-LOCK:
      cur_rct_amount = cur_rct_amount + tr_gl_amt.
        END.
        FOR EACH op_hist WHERE op_type = 'labor' AND op_wo_nbr = wo_nbr AND op_wo_lot = wo_lot AND op_date < glc_start NO-LOCK:
            pre_lbr = pre_lbr + op_lbr_cost.
            pre_bdn = pre_bdn + op_bdn_cost.
        END.
         FOR EACH op_hist WHERE op_type = 'labor' AND op_wo_nbr = wo_nbr AND op_wo_lot = wo_lot AND op_date >= glc_start AND op_date <= glc_end NO-LOCK:
            cur_lbr = cur_lbr + op_lbr_cost.
            cur_bdn = cur_bdn + op_bdn_cost.
        END.
        mraw_tot = pre_iss_amount + cur_iss_amount + pre_bdn + cur_bdn + pre_lbr + cur_lbr.
        rct_tot = pre_rct_amount + cur_rct_amount.
        o_var = wo_bdn_var + wo_lbr_var + wo_sub_var.
       var_tot = o_var + wo_mtl_var + wo_mthd_var.
       bal =  rct_tot - mraw_tot + VAR_tot. 
       DISPLAY 
           wo_ord_date 
   /* wo_due_date
    wo_stat_close_date 
    wo_close_date */
    wo_nbr 
    wo_lot 
    wo_status
   pre_iss_amount
   cur_iss_amount
   pre_bdn
            cur_bdn
            pre_lbr
            cur_lbr
          mraw_tot
            pre_rct_amount
            cur_rct_amount
         rct_tot
            
            
            
            
            wo_mtl_var
            /* wo_part 
    pt_desc1 
  pt_desc2
    wo_qty_comp */
    /*wo_routing 
    wo_lbr_tot 
    wo_bdn_tot*/ 
    wo_mthd_var 
    o_var
            var_tot
           bal.

      /* if pt_desc2 <> '' then do:
                     down 1 .
                    put space(125).
                    put pt_desc2.
                   
                 end.*/
      
      
      END.

        {mftrl080.i}  
      
      
      END.
