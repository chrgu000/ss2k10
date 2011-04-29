/* reuvup.p  - REPETITIVE   ACCUMULATED USAGE VARIANCE POST                   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.9.1.10 $                                                               */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN77*                */
/* REVISION: 7.3      LAST MODIFIED: 11/03/94   BY: WUG *GN98*                */
/* REVISION: 7.3      LAST MODIFIED: 01/05/95   BY: cpp *FT95*                */
/* REVISION: 7.3      LAST MODIFIED: 02/10/95   BY: srk *G0DS*                */
/* REVISION: 7.3      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 8.5      LAST MODIFIED: 05/12/95   BY: pma *J04T*                */
/* REVISION: 8.5      LAST MODIFIED: 09/05/95   BY: srk *J07G*                */
/* REVISION: 7.3      LAST MODIFIED: 01/10/96   BY: emb *G1K9*                */
/* REVISION: 8.5      LAST MODIFIED: 05/01/96   BY: jym *G1MN*                */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: ejh *K001*                */
/* REVISION: 8.5      LAST MODIFIED: 06/20/96   BY: taf *J0VG*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/19/99   BY: *N01B* John Corda         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 11/17/99   BY: *N04H* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/11/00   BY: *N0RQ* BalbeerS Rajput    */
/* Revision: 1.9.1.7   BY: Robin McCarthy        DATE: 10/01/01  ECO: *P025*  */
/* Revision: 1.9.1.8  BY: Vivek Gogte DATE: 08/06/02 ECO: *N1QQ* */
/* $Revision: 1.9.1.10 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/*Revision:eb21sp3        last modified;07/21/09   by:*SS - 090712.1*                   */


/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*
  SS - 090712.1
     1.增加生产线描述.
     2.提取人工费率，机器费率，人工附加%
*/

/*V8:ConvertMode=Report                                                       */
/*
{mfdtitle.i "2+ "}
*/

{mfdeclre.i}
{ssvdef.i " " }
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE reuvup_p_1 "Consolidated!Debit"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvup_p_2 "Cum Order Cumulative Variance"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvup_p_3 "Consolidated!Credit"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvup_p_4 "Cum Order Variance To Post"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvup_p_6 "Total Cumulative Variance"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvup_p_7 "Update"
/* MaxLen: 9 Comment: FACILITATE SIMULATION MODE PRINTING */

&SCOPED-DEFINE reuvup_p_8 "Total Variance To Post"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvup_p_9 "Show Zero Variance to Post"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvup_p_10 "Show Zero Cumulative Variance"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

&SCOPED-DEFINE simulation true
   /* PREPROCESSOR USED FOR REPORT'S WITH SIMULATION OPTION */

   {gldydef.i new}
   {gldynrm.i new}

   {gpglefv.i}
    /* {ssvdef.i } */
/*ss - 2008.03.23 - B*/     
define input parameter i_eff_date LIKE tr_effdate .
define input parameter i_part     like wo_part.
define input parameter i_part1    like wo_part.
define input parameter i_site     like wo_site.
define input parameter i_site1     like wo_site .
define input parameter i_line     like wo_line.
define input parameter i_line1     like wo_line .
define INPUT PARAMETER i_zero_unposted_var like mfc_logical .
define INPUT PARAMETER i_zero_cum_var like mfc_logical .
DEFINE INPUT  PARAMETER  i_lot  LIKE wo_lot .
DEFINE INPUT  PARAMETER  i_lot1 LIKE wo_lot .
/*ss - 2008.03.23 - E*/
   define buffer womstr for wo_mstr.

define new shared workfile work_op_recids no-undo
   field work_op_recid as recid.
define new shared workfile work_gltw no-undo like gltw_wkfl.

define variable cons_dr_amt like trgl_gl_amt column-label {&reuvup_p_1}
   no-undo.
define variable cons_cr_amt like trgl_gl_amt column-label {&reuvup_p_3}
   NO-UNDO.
  

define variable eff_date like tr_effdate.
define variable part like wo_part.
define variable part1 like wo_part label {t001.i}.
define variable site like wo_site.
define variable site1 like wo_site label {t001.i}.
define variable line like wo_line.
define variable line1 like wo_line label {t001.i}.
DEFINE variable i as integer.

define variable lot like wo_lot.
define variable lot1 like wo_lot label {t001.i}.


define variable total_cum_var_amt like glt_amt
   label {&reuvup_p_6} no-undo.
define variable total_var_to_post like glt_amt
   label {&reuvup_p_8} no-undo.
define variable update_yn like mfc_logical label {&reuvup_p_7}.
define variable wo_cum_var_amt like glt_amt
   label {&reuvup_p_2}.
define variable wo_var_to_post like glt_amt
   label {&reuvup_p_4}.

define variable zero_unposted_var like mfc_logical
   label {&reuvup_p_9} initial no no-undo.
define variable zero_cum_var like mfc_logical
   label {&reuvup_p_10} initial no no-undo.

define variable l_msg like msg_mstr.msg_desc NO-UNDO.


DEFINE BUFFER b_womstr FOR wo_mstr .
DEFINE VARIABLE wcdesc LIKE wc_desc .
DEFINE VARIABLE desc1  LIKE pt_desc1 .
DEFINE VARIABLE desc2  LIKE pt_desc2 .
DEFINE VARIABLE wclbrrate LIKE wc_lbr_rate .
DEFINE VARIABLE wcbdnpct  LIKE wc_bdn_pct  .
DEFINE VARIABLE wcmchbdn  LIKE wc_mch_bdn .
DEFINE VARIABLE woqtyord LIKE wo_qty_ord .
DEFINE VARIABLE skip_flag AS  LOGICAL INIT NO .

form
   lot                  colon 20
   lot1                 colon 45
   part                 colon 20
   part1                colon 45
   site                 colon 20
   site1                colon 45
   line                 colon 20
   line1                colon 45
   skip(1)
   zero_unposted_var    colon 32
   zero_cum_var         colon 32
   eff_date             colon 32
   update_yn            colon 32
with frame a side-labels width 80 attr-space.

/*
/* SET EXTERNAL LABELS */
*/
/* THE FOLLOWING FORM STATEMENT REPORTS RECORDS WITH */
/* SITES WHICH HAVE CLOSED GL PERIOD FOR THAT ENTITY */
form
   wo_lot
   wo_site
   msg_desc format "x(40)"
   si_entity
with frame entity-closed width 132 no-attr-space down.           
/* SET EXTERNAL LABELS */
/*
setFrameLabels(frame entity-closed:handle).
*/
    ASSIGN eff_date = i_eff_date
           part     = i_part    
           part1    = i_part1   
           site     = i_site    
           site1    = i_site1   
           line     = i_line    
           line1    = i_line1  
           zero_unposted_var = i_zero_unposted_var
           zero_cum_var      = i_zero_cum_var 
           lot = i_lot
           lot1 = i_lot1 
           .	

            
find mfc_ctrl  where mfc_ctrl.mfc_domain = global_domain and  mfc_field =
"rpc_using_new" no-lock no-error.
if not available mfc_ctrl or mfc_logical = false then do:
   /* THIS MODULE HAS NOT BEEN ENABLED IN CONTROL FILE MAINTENANCE */
   {pxmsg.i &MSGNUM=5119 &ERRORLEVEL=3}
   message.
   message.
   leave.
end.

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.
 /* eff_date = today. */

mainloop:
repeat:
                ASSIGN skip_flag = NO  . 
   i = 0.

   if lot1 = hi_char then lot1 = "".
   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".
   if line1 = hi_char then line1 = "".
   
/*ss - 2008.03.23 - B*/    
/*
   update
      lot
      lot1
      part
      part1
      site
      site1
      line
      line1
      zero_unposted_var
      zero_cum_var
      eff_date
      update_yn
   with frame a.

   bcdparm = "".
   {mfquoter.i lot              }
   {mfquoter.i lot1             }
   {mfquoter.i part             }
   {mfquoter.i part1            }
   {mfquoter.i site             }
   {mfquoter.i site1            }
   {mfquoter.i line             }
   {mfquoter.i line1            }
   {mfquoter.i zero_unposted_var}
   {mfquoter.i zero_cum_var     }
   {mfquoter.i eff_date         }
   {mfquoter.i update_yn        }
*/
/*ss - 2008.03.23 - E*/ 

   if lot1 = "" then lot1 = hi_char.
   if part1 = "" then part1 = hi_char.
   if site1 = "" then site1 = hi_char.
   if line1 = "" then line1 = hi_char.
/*ss - 2008.03.23 - B*/ 

   /*SITE (RANGE-OF) SECURITY CHECK*/
   if not batchrun then do:
      {gprun.i ""gpsirvr.p""
         "(input site, input site1, output return_int)"}
       
      if return_int = 0 then do:
         next-prompt site with frame a.
         undo mainloop, retry mainloop.
        
      end.

   END.
   
 /*   

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

   {mfphead.i}
*/
/*ss - 2008.03.23 - E*/ 


   for each gltw_wkfl exclusive-lock  where gltw_wkfl.gltw_domain =
   global_domain and  gltw_batch = mfguser:
      delete gltw_wkfl.
   end.

   total_cum_var_amt = 0.
   total_var_to_post = 0.

   /* STANDARDS SHOWN ARE CONTAINED WITHIN THE CUMULATIVE WORK ORDER */
   {pxmsg.i &MSGNUM=3678 &ERRORLEVEL=1 &MSGBUFFER=l_msg}

   /* FRAME DEFINED HERE SO THAT IT WILL PRINT ON ALL PAGES OF THE OUTPUT */
   form
      skip(1)
      l_msg no-label
   with frame footer width 132 page-bottom.

   /* SET EXTERNAL LABELS */
/*ss - 2008.03.23 - B*/    	
   /*
   l_msg:screen-value in frame footer = l_msg.
 view frame footer. */
/*ss - 2008.03.23 - E*/ 
   /*NOTE: LOOK AT ALL ORDERS CLOSED OR NOT*/

   wo-loop:
   for each wo_mstr no-lock
          where wo_mstr.wo_domain = global_domain and (  wo_type = "c"
         and wo_lot >= lot and wo_lot <= lot1
         and wo_part >= part and wo_part <= part1
         and wo_site >= site and wo_site <= site1
         and wo_line >= line and wo_line <= line1
         and (wo_rel_date <= eff_date or wo_rel_date = ?)
         and (wo_due_date >= eff_date or wo_due_date = ?)
         and wo_nbr = ""
         ) use-index wo_type_part
         by wo_type by wo_site by wo_part
         by wo_line by wo_due_date by wo_lot:

      /* VALIDATE OPEN GL PERIOD FOR SPECIFIED ENTITY */
      find si_mstr  where si_mstr.si_domain = global_domain and  si_site =
      wo_site no-lock.
      assign gpglef_entity = si_entity
         gpglef_effdate = eff_date
         gpglef_tr_type = "IC".

      {gprun.i ""gpglef1.p""
         "( input gpglef_tr_type,
           input gpglef_entity,
           input gpglef_effdate,
           output gpglef_result,
           output gpglef_msg_nbr)"
         }

      if gpglef_msg_nbr > 0 then do:
         /* INVALID PERIOD */
         if gpglef_result = 1 then
         find msg_mstr where msg_nbr = 3016 and
            msg_lang = global_user_lang no-lock no-error.
         /* PERIOD CLOSED FOR ENTITY */
         else
         find msg_mstr where msg_nbr = 3036 and
            msg_lang = global_user_lang no-lock NO-ERROR.
/*ss - 2008.03.23 - B*/     
/*        
         display
            wo_lot
            wo_site
            msg_desc when (available msg_mstr)
            si_entity
         with frame entity-closed.
          
         down 1 with frame entity-closed.
*/
/*ss - 2008.03.23 - E*/         
         next wo-loop.
      end. /* INVALID ENTITY */
/*
      page.
*/
      for each work_gltw  where work_gltw.gltw_domain = global_domain
      exclusive-lock:
         delete work_gltw.
      end.

      for each work_op_recids exclusive-lock:
         delete work_op_recids.
      end.

      do for womstr transaction:
         find womstr where recid(womstr) = recid(wo_mstr)	
         exclusive-lock.
         /*ss - 2008.03.23 - B*/  
         /*REPORT AND POST USAGE VARIANCES*/
         /*
         {gprun.i ""reuvpst.p"" "(input wo_lot, input eff_date,
              output wo_cum_var_amt, output wo_var_to_post,
              input zero_unposted_var, input zero_cum_var )"}
         */
   
         
          {gprun.i ""ssreuvt.p"" "(input wo_lot, input eff_date,
              output wo_cum_var_amt, output wo_var_to_post,
              input zero_unposted_var, input zero_cum_var )"}
              
              
        /*ss - 2008.03.23 - E*/  
         total_cum_var_amt = total_cum_var_amt + wo_cum_var_amt.
         total_var_to_post = total_var_to_post + wo_var_to_post.
         
/* ss - 2008.03.20 - B if up_dateyn = yes then */
         for each work_op_recids,
               each op_hist no-lock
               where recid(op_hist) = work_op_recid,
               each opgl_det no-lock
                where opgl_det.opgl_domain = global_domain and  opgl_trnbr =
                op_trnbr
               break by opgl_trnbr by opgl_gl_ref by opgl_sequence
            with frame f-a:
/*ss - 2008.03.23 - B*/  

/*
           /* SET EXTERNAL LABELS */
            setFrameLabels(frame f-a:handle).
            display
               opgl_trnbr format ">>>>>>>9"
               when (update_yn = yes)
               opgl_gl_ref
               when (update_yn = yes)
               opgl_type
               op_wo_op
               opgl_dr_acct
               opgl_dr_sub
               opgl_dr_cc
               opgl_dr_proj
               opgl_cr_acct
               opgl_cr_sub
               opgl_cr_cc
               opgl_cr_proj
               opgl_gl_amt
            with width 132.
*/
/*ss - 2008.03.23 - E*/  
            create work_gltw. work_gltw.gltw_domain = global_domain.

            assign
               work_gltw.gltw_ref = opgl_gl_ref
               work_gltw.gltw_acct = opgl_dr_acct
               work_gltw.gltw_sub = opgl_dr_sub
               work_gltw.gltw_cc = opgl_dr_cc
               work_gltw.gltw_project = opgl_dr_proj
               work_gltw.gltw_date = op_tran_date
               work_gltw.gltw_effdate = op_date
               work_gltw.gltw_amt = opgl_gl_amt.

            create work_gltw. work_gltw.gltw_domain = global_domain.

            assign
               work_gltw.gltw_ref = opgl_gl_ref
               work_gltw.gltw_acct = opgl_cr_acct
               work_gltw.gltw_sub = opgl_cr_sub
               work_gltw.gltw_cc = opgl_cr_cc
               work_gltw.gltw_project = opgl_cr_proj
               work_gltw.gltw_date = op_tran_date
               work_gltw.gltw_effdate = op_date
               work_gltw.gltw_amt = - opgl_gl_amt.
         END.
         
 /*ss - 2008.03.26 - B*/  
 /*
             ASSIGN skip_flag = FALSE   .       
             */
             FOR EACH tt1 NO-LOCK BREAK BY tt1_site  BY tt1_peri BY tt1_pare by tt1_lot BY tt1_cc  :
             	
             	ACCUMULATE tt1_qty_comp ( TOTAL BY tt1_site BY tt1_peri BY tt1_pare   by tt1_lot BY tt1_cc    ) .
             	ACCUMULATE tt1_qty_iss ( TOTAL BY tt1_site BY tt1_peri BY tt1_pare  by tt1_lot BY tt1_cc    ) .
             	ACCUMULATE tt1_setup_std_hrs ( TOTAL BY tt1_site BY tt1_peri BY tt1_pare  by tt1_lot BY tt1_cc    ) .
             	ACCUMULATE tt1_setup_act_hrs ( TOTAL BY tt1_site BY tt1_peri BY tt1_pare  by tt1_lot  BY tt1_cc    ) .
             	ACCUMULATE tt1_setup_lbr_rte ( TOTAL BY tt1_site BY tt1_peri  BY tt1_pare by tt1_lot BY tt1_cc    ) .
             	ACCUMULATE tt1_setup_burden_rte ( TOTAL BY tt1_site BY tt1_peri BY tt1_pare by tt1_lot   BY tt1_cc    ) .
             	ACCUMULATE tt1_run_std_hrs ( TOTAL BY tt1_site BY tt1_peri BY tt1_pare  by tt1_lot  BY tt1_cc    ) .
             	ACCUMULATE tt1_run_act_hrs ( TOTAL BY tt1_site BY tt1_peri BY tt1_pare   by tt1_lot BY tt1_cc    ) .
             	ACCUMULATE tt1_run_lbr_rte ( TOTAL BY tt1_site BY tt1_peri BY tt1_pare  by tt1_lot BY tt1_cc    ) .
             	ACCUMULATE tt1_run_burden_rte ( TOTAL BY tt1_site BY tt1_peri BY tt1_pare by tt1_lot BY tt1_cc    ) .
             	ACCUMULATE tt1_price ( TOTAL BY tt1_site BY tt1_peri  BY tt1_pare by tt1_lot BY tt1_cc    ) .
              ACCUMULATE tt1_run_per_time ( TOTAL BY tt1_site BY tt1_peri  BY tt1_pare by tt1_lot  BY tt1_cc    ) .
              /*            
              PUT SKIP tt1_lot '  ' tt1_site ' ' tt1_pare ' ' tt1_cc ' '  '人工使用差异：' tt1_run_lbr_rte   '准备人工使用差异:' tt1_setup_lbr_rte SKIP .
              */
              
             	IF LAST-OF (tt1_cc) THEN DO:
             	  FIND pt_mstr WHERE pt_domain = global_domain 
             	                 AND pt_part = tt1_pare 
             	                 NO-LOCK NO-ERROR .
             	  IF AVAILABLE pt_mstr THEN ASSIGN desc1 = pt_desc1 desc2 = pt_desc2 .
             
                  /* SS - 090721.1 - RNB */
		  
             	  FIND wc_mstr WHERE wc_domain = global_domain  
             	                 AND wc_wkctr = op_wkctr
				 AND wc_mch = op_mch 
             	                 NO-LOCK NO-ERROR .	  
             	  IF AVAILABLE wc_mstr  THEN ASSIGN wcdesc = wc_desc  
             	                                wclbrrate = wc_lbr_rate
             	                                wcbdnpct = wc_bdn_pct 
             	                                wcmchbdn = wc_mch_bdn
             	                                .
                   
		   /*

                  for first wr_route where wr_domain = global_domain  AND wr_lot = tt1_lot no-lock ,
		      first wc_mstr where wc_domain = global_domain and wc_wkctr = wr_wkctr and wc_mch = wr_mch no-lock :
                      ASSIGN wcdesc = wc_desc  
             	                                wclbrrate = wc_lbr_rate
             	                                wcbdnpct = wc_bdn_pct 
             	                                wcmchbdn = wc_mch_bdn .
		  end.
		  */
				 
                 /* SS - 090721.1 - RNE */


             	  FOR FIRST  b_womstr WHERE b_womstr.wo_domain = global_domain
             	                 AND b_womstr.wo_lot = tt1_lot
             	                 AND b_womstr.wo_type = 'c'  NO-LOCK :
             	       ASSIGN woqtyord = b_womstr.wo_qty_ord  .
             	  END .   
             	  /*
                IF NOT skip_flag THEN PUT  SKIP .
                */
               	PUT  UNFORMATTED  tt1_peri  ";"
		
                tt1_pare       ";" 
                  tt1_lot  ";"
		            desc1 ";"
                desc2 ";"
                tt1_cc   " "
                wcdesc  ";"
                wclbrrate ";"
                wcbdnpct  / 100   ";"
                wcmchbdn   ";"
                ACCUMULATE TOTAL BY tt1_cc tt1_qty_comp  ";"
              woqtyord   ";"
                tt1_setup_per_time  ";"
                tt1_setup_std_hrs   ";"
                tt1_setup_act_hrs   ";"
                tt1_setup_std_hrs  -  tt1_setup_act_hrs  ";"
                ( ACCUMULATE TOTAL BY tt1_cc tt1_setup_lbr_rte )   ";"
                ( ACCUMULATE TOTAL BY tt1_cc tt1_setup_burden_rte  ) ";"
                ( ACCUMULATE TOTAL BY tt1_cc tt1_run_per_time )   ";"
                ( ACCUMULATE TOTAL BY tt1_cc tt1_run_std_hrs )     ";"
                ( ACCUMULATE TOTAL BY tt1_cc tt1_run_act_hrs )    ";"
                (( ACCUMULATE TOTAL BY tt1_cc tt1_run_std_hrs )   -  ( ACCUMULATE TOTAL BY tt1_cc tt1_run_act_hrs  ))  ";"
                ( ACCUMULATE TOTAL BY tt1_cc tt1_run_lbr_rte )     ";"
                ( ACCUMULATE TOTAL BY tt1_cc tt1_run_burden_rte )   ";"
                (ACCUMULATE TOTAL BY tt1_cc tt1_qty_iss)   ";"  
                ACCUMULATE TOTAL BY tt1_cc tt1_price ";"
                ( ACCUMULATE TOTAL BY tt1_cc tt1_price )  *  ( ACCUMULATE TOTAL BY tt1_cc tt1_qty_iss ) 
                SKIP
                .
                /*
                ASSIGN skip_flag = TRUE  . 
                */
              END .  

              
/*                PUT tt1_site tt1_lot tt1_pare tt1_cc  tt1_setup_lbr_rte tt1_setup_burden_rte tt1_run_lbr_rte  tt1_run_burden_rte SKIP . */
             END.       
 /*ss - 2008.03.26 - E*/        
 
/* ss - 2008.03.20 - E if up_dateyn = yes then */

         if not update_yn THEN   undo, leave.
         /*IF WO CLOSED THEN DON'T DO ANYTHING CUZ WE ALREADY HAVE*/
         if wo_status = "c" then undo, leave.
      end.

      for each work_gltw where work_gltw.gltw_domain = global_domain :
         i = i - 1.
         create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.

         assign
            gltw_wkfl.gltw_ref = work_gltw.gltw_ref
            gltw_wkfl.gltw_line = i
            gltw_wkfl.gltw_acct = work_gltw.gltw_acct
            gltw_wkfl.gltw_sub = work_gltw.gltw_sub
            gltw_wkfl.gltw_cc = work_gltw.gltw_cc
            gltw_wkfl.gltw_project = work_gltw.gltw_project
            gltw_wkfl.gltw_date = work_gltw.gltw_date
            gltw_wkfl.gltw_effdate = work_gltw.gltw_effdate
            gltw_wkfl.gltw_amt = work_gltw.gltw_amt
            gltw_wkfl.gltw_userid = mfguser
            gltw_wkfl.gltw_batch = mfguser
            .
      end.

   END.
   
/*ss - 2008.03.23 - B*/
/*
   page.

   do with frame v:
  
  	
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame v:handle).
      display
         total_cum_var_amt
         colon 66 skip
         total_var_to_post
         colon 66
      with frame v side-labels width 132.
      
   end. /* do with */
*/
/*ss - 2008.03.23 - E*/  

   for each gltw_wkfl exclusive-lock
          where gltw_wkfl.gltw_domain = global_domain and  gltw_wkfl.gltw_batch
          = mfguser
         and gltw_wkfl.gltw_userid = mfguser
         break
         by gltw_wkfl.gltw_userid
         by gltw_wkfl.gltw_acct
         by gltw_wkfl.gltw_sub
         by gltw_wkfl.gltw_cc
         by gltw_wkfl.gltw_project with frame f-b:
 /*        	
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame f-b:handle).
*/
      if first-of(gltw_wkfl.gltw_project) then do:
         cons_dr_amt = 0.
         cons_cr_amt = 0.
      end.

      if gltw_wkfl.gltw_amt >= 0
         then cons_dr_amt = cons_dr_amt + gltw_wkfl.gltw_amt.
      else cons_cr_amt = cons_cr_amt - gltw_wkfl.gltw_amt.
      
/*ss - 2008.03.23 - B*/  
/*  
      if last-of(gltw_wkfl.gltw_project) then DO:
    	
         display
            space(40)
            gltw_wkfl.gltw_acct
            gltw_wkfl.gltw_sub
            gltw_wkfl.gltw_cc
            gltw_wkfl.gltw_project
            cons_dr_amt
            cons_cr_amt
         with width 132.
          
      end.
*/
/*ss - 2008.03.23 - E*/ 

      delete gltw_wkfl.
      
   END.
   LEAVE .
/*ss - 2008.03.23 - B*/ 
/*
{mfrtrail.i}
 
*/

END .
/*ss - 2008.03.23 - E*/    

