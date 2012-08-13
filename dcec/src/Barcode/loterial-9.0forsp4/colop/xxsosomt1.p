/* xxsosomt1.p - SALES ORDER MAINTENANCE                                        */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.49.4.8 $                                                                           */
/*V8:ConvertMode=Maintenance                                                                 */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: *F0PN* dzn                */
/* REVISION: 8.5      LAST MODIFIED: 08/25/95   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: *J034* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: *J042* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: *J053* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 04/17/96   BY: *J0HR* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 04/19/96   BY: *J0JW* gwm                */
/* REVISION: 8.5      LAST MODIFIED: 04/26/96   BY: *J0KJ* DAH                */
/* REVISION: 8.5      LAST MODIFIED: 05/14/96   BY: *J0M3* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 07/10/96   BY: *J0YH* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: *J12Q* Andy Wasilczuk     */
/* REVISION: 8.6      LAST MODIFIED: 09/27/96   BY: *K007* svs                */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Elke Van Maele     */
/* REVISION: 8.6      LAST MODIFIED: 11/05/96   BY: *K01T* Stephane Collard   */
/* REVISION: 8.6      LAST MODIFIED: 05/07/97   BY: *J1P5* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 06/06/97   BY: *K0CZ* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 07/11/97   BY: *K0DH* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 08/06/97   BY: *J1YG* Seema Varma        */
/* REVISION: 8.6      LAST MODIFIED: 09/23/97   BY: *K0HB* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 11/18/97   BY: *J25B* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 11/18/97   BY: *K1BG* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 12/01/97   BY: *K1BN* Bryan Merich       */
/* REVISION: 8.6      LAST MODIFIED: 01/31/98   BY: *J2D6* Seema Varma        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00L* Ed van de Gevel    */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* David Morris       */
/* REVISION: 9.0      LAST MODIFIED: 02/24/99   BY: *M094* Jean Miller        */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/06/99   BY: *L0J4* Satish Chavan      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *N0CG* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 06/14/00   BY: *L0Y4* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 07/03/00   BY: *N0DX* Rajinder Kamra     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 11/19/00   BY: *M0WC* Rajesh Thomas      */
/* REVISION: 9.1      LAST MODIFIED: 12/18/00   BY: *M0TZ* Veena Lad          */
/* REVISION: 9.1      LAST MODIFIED: 10/16/00   BY: *N0WB* BalbeerS Rajput    */
/* Revision: 1.35          BY: Katie Hilbert      DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.36          BY: Sachin Shinde      DATE: 06/26/01  ECO: *M1C2* */
/* Revision: 1.37          BY: Ellen Borden       DATE: 02/27/01  ECO: *P007* */
/* Revision: 1.38          BY: Jean Miller        DATE: 08/08/01  ECO: *M11Z* */
/* Revision: 1.39          BY: Russ Witt          DATE: 09/21/01  ECO: *P01H* */
/* Revision: 1.40          BY: Ashwini Ghaisas    DATE: 01/10/02  ECO: *L194* */
/* Revision: 1.41          BY: Santhosh Nair      DATE: 03/05/02  ECO: *M1H1* */
/* Revision: 1.42          BY: Ashish Maheshwari  DATE: 05/14/02  ECO: *P06M* */
/* Revision: 1.43          BY: Ashish Maheshwari  DATE: 05/20/02  ECO: *P04J* */
/* Revision: 1.45          BY: Samir Bavkar       DATE: 04/29/02  ECO: *P042* */
/* Revision: 1.47          BY: Robin McCarthy     DATE: 07/03/02  ECO: *P08Q* */
/* Revision: 1.48          BY: Samir Bavkar       DATE: 07/07/02  ECO: *P0B0* */
/* Revision: 1.49          BY: Robin McCarthy     DATE: 07/15/02  ECO: *P0BJ* */
/* Revision: 1.49.4.1      BY: Ashish Maheshwari  DATE: 09/03/03  ECO: *N2KT* */
/* Revision: 1.49.4.4      BY: Rajaneesh S.       DATE: 10/07/03  ECO: *P15F* */
/* $Revision: 1.49.4.8 $ BY: Mike Dempsey         DATE: 11/27/03  ECO: *N2GM* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
 *  Sosomt1.p performs the 'driver' function for Sales Order and RMA
 *  Maintenance.  These two functions were previously handled by sosomt.p
 *  and fsrmamt.p.  This program was originally copied from sosomt.p.
*/

/* DISPLAY TITLE */
{mfdeclre.i}
{cxcustom.i "SOSOMT1.P"}
{gplabel.i}    /* EXTERNAL LABEL INCLUDE */
{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sosomt1_p_2 "Promise Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomt1_p_3 "Calculate Freight"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomt1_p_4 "Allocations"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomt1_p_5 "Confirmed"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomt1_p_6 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomt1_p_7 "Line Pricing"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomt1_p_8 "Reprice"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define input parameter         this-is-rma     as logical.

define new shared variable line like sod_line.
define new shared variable del-yn like mfc_logical.
define new shared variable qty_req like in_qty_req.
define new shared variable prev_due like sod_due_date.
define new shared variable prev_qty_ord like sod_qty_ord.
define new shared variable trnbr like tr_trnbr.
define new shared variable qty as decimal.
define new shared variable part as character format "x(18)".
define new shared variable eff_date as date.
define new shared variable all_days like soc_all_days.
define new shared variable all_avail like soc_all_avl.
define new shared variable sngl_ln  like soc_ln_fmt.
define new shared variable so_recno as recid.
define new shared variable cm_recno as recid.
define new shared variable comp like ps_comp.
define new shared variable cmtindx like cmt_indx.
define new shared  variable socmmts like soc_hcmmts label {&sosomt1_p_6}.
define new shared variable prev_abnormal like sod_abnormal.
define new shared variable promise_date as date label {&sosomt1_p_2}.
define new shared variable perform_date as date label "Perform Date".
define new shared variable base_amt like ar_amt.
define new shared variable sod_recno as recid.
define new shared variable consume like sod_consume.
define new shared variable prev_consume like sod_consume.
define  new shared  variable confirm like mfc_logical initial yes
                                     label {&sosomt1_p_5}.
define new shared variable sotrcust  like so_cust.
define new shared variable merror    like mfc_logical initial no.
define new shared variable so-detail-all like soc_det_all.
define new shared variable new_order like mfc_logical initial no.
define new shared variable sotax_trl like tax_trl.
define new shared variable tax_in    like cm_tax_in.
define new shared variable rebook_lines as logical initial no no-undo.
define new shared variable avail_calc as integer.
define new shared variable so_db       like dc_name.
define new shared variable inv_db      like dc_name.
define new shared variable mult_slspsn like mfc_logical no-undo.
define new shared variable undo_cust   like mfc_logical.
define new shared variable freight_ok  like mfc_logical initial yes.
define new shared variable old_ft_type like ft_type.
define new shared variable calc_fr     like mfc_logical label {&sosomt1_p_3}.
define new shared variable undo_flag   like mfc_logical.
define new shared variable disp_fr     like mfc_logical.
define new shared variable display_trail like mfc_logical initial yes.
define new shared variable soc_pc_line like mfc_logical initial yes.
define new shared variable socrt_int   like sod_crt_int.
define new shared variable impexp_label as character format "x(12)" no-undo.
define new shared variable impexp      like mfc_logical no-undo.
define new shared variable sonbr       like so_nbr.
define new shared variable picust      like cm_addr.
define new shared variable price_changed like mfc_logical.
define new shared variable line_pricing  like pic_so_linpri
   label {&sosomt1_p_7}.
define new shared variable reprice       like mfc_logical label {&sosomt1_p_8}
   initial no.
define new shared variable rndmthd like rnd_rnd_mthd.
define new shared variable oldcurr like so_curr.
define new shared variable balance_fmt as character.
define new shared variable limit_fmt as character.
define new shared variable prepaid_fmt as character no-undo.
define new shared variable prepaid_old as character no-undo.
define new shared variable trans_conv like sod_um_conv.

define variable lv_shipfrom  like so_site no-undo.
define variable comment_type like so_lang.
define variable old_so_print_pl like so_print_pl no-undo.
define variable impexp_edit like mfc_logical no-undo.
define variable upd_okay    like mfc_logical no-undo.
define variable batch_job   as logical.
define variable dev         as character.
define variable batch_id    as character.
define variable use-log-acctg as logical no-undo.

/*xx*/   DEFINE VARIABLE baseprice LIKE pi_list_price.
/*xx*/   DEFINE VARIABLE tot_var     LIKE ar_amt .
/*xx*/   DEFINE VARIABLE cuum       LIKE pt_um  .

/* RMA-SPECIFIC VARIABLES */
define variable rma-recno   as recid.

/* TEMP TABLE DEFINITIONS FOR APM/API */
{ifttcmdr.i "new"}
{ifttcmdv.i "new"}

{sobtbvar.i "new"}   /* BACK TO BACK SHARED WORKFILES AND VARIABLES */

{&SOSOMT1-P-TAG1}

/* RECORD BUFFERS */
define buffer   bill_cm     for  cm_mstr.

/* SHARED STREAMS AND FRAMES */
define new shared stream bi.
define new shared frame a.

define new shared variable wk_bs_line  like pih_bonus_line no-undo.
define new shared variable wk_bs_promo as character format "x(8)" no-undo.
define new shared variable wk_bs_listid like pih_list_id no-undo.
define new shared frame bi.

/* MOVED UP THE TRAILER FRAMES DEFINITION FROM sosomtc.p  */
define new shared frame sotot.
define new shared frame d.

{pppivar.i "new"}  /* PRICING VARIABLES */

define new shared variable cfexists like mfc_logical.
define new shared variable cf_cfg_path like mfc_char.
define new shared variable cf_cfg_suf  like mfc_char.
define new shared variable cf_chr   as character.
define new shared variable cf_cfg_strt_err  like mfc_logical.
define variable cf_default_model as character.
define variable cf_exe_loc as character.
define new shared variable phCfcfstrt as handle no-undo.
define new shared variable phCfEvents as handle no-undo.
define new shared variable CtrlFrame as widget-handle no-undo.
define variable err-stat as integer.
define variable checkwritepath as character.
define variable testfile as character.
define new shared variable calicodone like mfc_logical.

/* FREIGHT ACCRUAL TEMP TABLE DEFINITION */
{lafrttmp.i "new"}

/*THIS TEMP TABLE IS CREATED TO CALCULATE FREIGHT CHARGES  */
/*WHEN A NEW SALES ORDER LINE IS ADDED TO AN EXISTING ORDER*/
/*WHEN THE FREIGHT TYPE IS "INCLUDE".                      */
define new shared temp-table l_fr_table
       field l_fr_sonbr   like sod_nbr
       field l_fr_soline  like sod_line
       field l_fr_chrg    like sod_fr_chg
       field l_sodlist_pr like sod_list_pr
       index nbrline is primary l_fr_sonbr l_fr_soline.

{gptxcdec.i}
{etdcrvar.i "new"}
{etvar.i &new="new"}
{etrpvar.i &new="new"}

{etsotrla.i "NEW"}
{xxsosomt01.i}

{gpcrfmt.i}

/* FORM DEFINITION FOR HIDDEN FRAME BI */
{sobifrm.i}

FORM /*GUI*/  sod_det with frame bi width 80 THREE-D /*GUI*/.


/*DEFINE WORKFILE FOR QTY ACCUM USED BY BEST PRICING ROUTINES*/
{pppiwqty.i "new" }

/* ASSIGN ORIGINAL FORMAT TO _OLD VARIABLES */
assign
   nontax_old   = nontaxable_amt:format
   taxable_old  = taxable_amt:format
   line_tot_old = line_total:format
   disc_old     = disc_amt:format
   trl_amt_old  = so_trl1_amt:format
   tax_amt_old  = tax_amt:format
   ord_amt_old  = ord_amt:format
   prepaid_old  = so_prepaid:format
   container_old = container_charge_total:format
   line_charge_old = line_charge_total:format.

oldcurr = "".

for first gl_ctrl
fields(gl_rnd_mthd) no-lock:
end. /* FOR FIRST GL_CTRL */

/* SET LIMIT_FMT ACCORDING TO BASE CURR ROUND METHOD*/
limit_fmt = "->>>>,>>>,>>9.99".
run gpcrfmt
   (input-output limit_fmt,
    input gl_rnd_mthd).

/* SET BALANCE_FMT ACCORDING TO BASE CURR ROUND METHOD*/
balance_fmt = "->>>>,>>>,>>9.99".
run gpcrfmt
   (input-output balance_fmt,
    input gl_rnd_mthd).

/* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}
/*GUI*/ if global-beam-me-up then undo, leave.


do transaction on error undo, retry:       /* TRANSACTION 10 */

   for first soc_ctrl
   fields(soc_all soc_all_avl soc_all_days soc_confirm
          soc_det_all soc_edit_isb soc_hcmmts soc_lcmmts
          soc_ln_fmt soc_on_ord soc_req soc_so_hist soc_trl_ntax
          soc_trl_tax soc_use_btb)
   no-lock: end.

   if not available soc_ctrl then
      create soc_ctrl.
   assign
      all_days = soc_all_days
      all_avail = soc_all_avl
      sngl_ln = soc_ln_fmt
      socmmts = soc_hcmmts
      comment_type = global_type
      confirm = soc_confirm.

   /* BATCH PROCESSING PARAMETERS */
   for first mfc_ctrl
   fields(mfc_char mfc_field mfc_logical)
   where mfc_field = "soc_batch"
   no-lock: end.

   if available mfc_ctrl then
      batch_job = mfc_logical.

   for first mfc_ctrl
   fields(mfc_char mfc_field mfc_logical)
   where mfc_field = "soc_print_id"
   no-lock: end.

   if available mfc_ctrl then
      dev = mfc_char.

   for first mfc_ctrl
   fields(mfc_char mfc_field mfc_logical)
   where mfc_field = "soc_batch_id"
   no-lock: end.

   if available mfc_ctrl then
      batch_id = mfc_char.

   /* FOR RMA'S, VALUES USUALLY OBTAINED FROM SOC_CTRL */
   /* COME FROM RMC_CTRL.  GET SVC_CTRL ALSO - IT'LL   */
   /* BE NEEDED LATER ON...                            */
   if this-is-rma then do:

      for first rmc_ctrl
      fields(rmc_all_days rmc_consume rmc_det_all rmc_edit_isb
             rmc_hcmmts rmc_history rmc_lcmmts)
      no-lock: end.

      if not available rmc_ctrl then do:
         create rmc_ctrl.
         assign
            rmc_hcmmts = soc_hcmmts
            rmc_lcmmts = soc_lcmmts
            rmc_det_all = soc_det_all
            rmc_all_days = soc_all_days
            rmc_edit_isb = soc_edit_isb
            rmc_history = soc_so_hist.
      end.
      assign
         socmmts  = rmc_hcmmts
         consume  = rmc_consume
         all_days = rmc_all_days.
   end.   /* if this-is-rma */

end.                                       /* TRANSACTION 10 */

/* Transaction 20 */
do transaction on error undo, retry:

   /* SET UP PRICING BY LINE VALUES */
   for first mfc_ctrl
   fields(mfc_char mfc_field mfc_logical)
   where mfc_field = "soc_pc_line" no-lock:
      soc_pc_line = mfc_logical.
   end. /* FOR FIRST MFC_CTRL */

end. /* TRANSACTION 20 */

/* DETERMINE AND STORE THE WAY QTY AVAIL TO ALLOC IS CALCULATED */
if soc_all then do:
   if soc_on_ord then
      avail_calc = 2.
   else
      avail_calc = 1.
end.
else if soc_req then do:
   if soc_on_ord then
      avail_calc = 4.
   else
      avail_calc = 3.
end.

so_db = global_db.

/* Transaction 25 */
do transaction on error undo, retry:
   for first pic_ctrl no-lock: end.
   if not available pic_ctrl then
      create pic_ctrl.
end.

/* Check for existence of configurator control record*/
{gprun.i ""cfctrl.p"" "(""cf_w_mod"", output cfexists)"}
/*GUI*/ if global-beam-me-up then undo, leave.


if cfexists and this-is-rma then
   cfexists = no.
if cfexists then do:
   /* Determine Unix or Windows path format based on user O/S */
   /* For Windows users, 'opsys' responds with 'msdos' */
   /* On Pro 8.1 and 'WIN32' on Progress 8.2  */
   /* Progress 8.2 is 32-bit only - Win95 and NT */
   /* EVEN A UNIX USER CAN DELETE AN ORDER AND MUST HAVE ACCESS TO */
   /* THE CONFIGURATION FILES SO THAT THESE ARE DELETED WITH THE */
   /* ORDER LINES.                                                */
   if opsys = "msdos" or opsys = "WIN32" then do:
      cf_chr = "~\".
      /*GET THE WINDOWS PATH OF THE SALES ORDER CONFIGURATION FILES*/
      for first mfc_ctrl
      fields(mfc_char mfc_field mfc_logical)
      where mfc_field = "cf_w_so_cfg" no-lock:
         cf_cfg_path = mfc_char.
      end. /* FOR FIRST MFC_CTRL */
   end.

   else do:
      cf_chr = "/".
      /*GET THE UNIX PATH OF THE CONCINITY SO FILES */
      for first mfc_ctrl
      fields(mfc_char mfc_field mfc_logical)
      where mfc_field = "cf_u_so_cfg" no-lock:
         cf_cfg_path = mfc_char.
      end. /* FOR FIRST MFC_CTRL */
   end.

   /* VALIDATE THAT THE PATH IS ACCESSIBLE*/
   cf_cfg_strt_err = no.
   output to "cf_test.txt".

   display
      getTermLabel("DELETE_IF_FOUND",35) format "x(35)".
   output close.

   checkwritepath = cf_cfg_path + cf_chr + "cf_test.txt".
   testfile = search("cf_test.txt").
   if testfile <> ? then do:
      os-copy value(testfile) value(checkwritepath).
      err-stat = os-error.
      if err-stat = 0 then do:
         os-delete value(checkwritepath).
         err-stat = os-error.
      end.
      else err-stat = 1.
   end.
   else
      err-stat = 1.

   /*Determine if the user is able to run Concinity:  running */
   /*Progress 8.2+, running on Win95 or NT, and access to the */
   /*Concinity executable. */
   if cf_cfg_strt_err = no then do:
      cf_cfg_strt_err = yes.

      if (substring(proversion,1,1) = "8" and
          substring(proversion,3,1) >= "2" ) or
          substring(proversion,1,1) = "9"
      then do:

         if opsys = "WIN32" then do:

            /*GET THE LOCATION OF CONCINITY EXECUTABLE*/
            for first mfc_ctrl
            fields(mfc_char mfc_field mfc_logical)
            where mfc_field = "cf_w_exe" no-lock:
               cf_exe_loc = mfc_char.
            end. /* FOR FIRST MFC_CTRL */

            if cf_exe_loc <> "" and search(cf_exe_loc) <> ? then do:

               if err-stat = 0 then do:
                  /* The conditions to run Concinity have been met */
                  cf_cfg_strt_err = no.
                  /* OK to start Concinity, get the default model*/
                  for first mfc_ctrl
                  fields(mfc_char mfc_field mfc_logical)
                  where mfc_field = "cf_model" no-lock:
                     cf_default_model = mfc_char.
                  end. /* FOR FIRST MFC_CTRL */

                  /* Launch calico */
                       
                  {gprunmo.i &module  = "cf" &program = "cfcfstrt.p"
                     &param   = """(cf_default_model) """
                     &persistent = ""persistent set phCfcfstrt""}
                    
                  if cf_cfg_strt_err then do:
                     /* An error was discovered in trying to start Concinity */
                     {pxmsg.i &MSGNUM=1829 &ERRORLEVEL=4}
                     /* Concinity is unavailable */
                     delete PROCEDURE phCfcfstrt no-error.
                  end.
               end. /* if err-stat... */

               /* WE ONLY NEED TO TELL THE USER THAT THE LOCATION IS NOT  */
               /* ACCESSABLE AFTER WE KNOW HE/SHE IS A CONCINITY USER */
               else do:
                  if err-stat <> 0 then do:
                     /* Configuration location is inaccessible */
                     {pxmsg.i &MSGNUM=2003 &ERRORLEVEL=2}
                     cf_cfg_strt_err = yes.
                  end.
               end. /* end else if err-stat... */

            end. /* if cf_exe_loc... */

         end. /* if opsys... */

      end. /* if proversion... */

   end. /* if cf_cfg_strt_err... */

   /* The cf_cfg_strt_err variable is used throughout the process to */
   /* determine if Concinity is running. (no = no error,it's running)*/

   /*GET THE SALES ORDER SUFFIX FROM THE CONTROL FILE*/
   for first mfc_ctrl
   fields(mfc_char mfc_field mfc_logical)
   where mfc_field = "cf_so_suf" no-lock:
      cf_cfg_suf = mfc_char.
   end. /* FOR FIRST MFC_CTRL */

end. /* if cf_exists... */

mainloop:
repeat:

   if not this-is-rma then do:
      /* TRAILER FRAMES FOR RMA ARE HIDDED IN sosomtc.p */
      hide frame sotot no-pause.
      hide frame d no-pause.
   end. /* IF NOT THIS-IS-RMA */

   for first mfc_ctrl
   fields(mfc_char mfc_field mfc_logical)
   where mfc_field = "soc_batch" no-lock:
      batch_job = mfc_logical.
   end. /* FOR FIRST MFC_CTRL */

   {xxsosomt02.i}  /* FORM DEFINITIONS FOR SHARED FRAMES A AND B */

   cr_terms_changed = no.

   /* IF AN EXPLICIT TRANSACTION SURROUNDS THIS, SOC_CTRL */
   /* IS LOCKED FOR THE DURATION OF SO HEADER PROCESSING  */

   /* PROCESS SALES ORDER HEADER FRAMES */
   {gprun.i ""xxsosomta1.p""
      "(input this-is-rma,
        output return_int,
        output rma-recno)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   if return_int = 1 then next mainloop.
   if return_int = 2 then undo mainloop, next mainloop.
   if return_int = 3 then undo mainloop, retry mainloop.
   if return_int = 4 then undo mainloop, leave.

   /* FIND SO_MSTR NO-LOCK TO ENSURE THE USER DIDN'T DELETE */
   /* IT.  NO-LOCK ALSO PREVENTS WARNINGS RELATED TO THE    */
   /* OTHER EXPLICIT TRANSACTIONS IN THIS PROGRAM.          */
   for first so_mstr
   fields(so_ar_acct so_ar_cc so_ar_sub so_bill so_bol
          so_channel so_comm_pct so_conf_date so_cr_card
/*xx*/  so__chr01             
          so_cr_init so_cr_terms so_curr so_cust so_disc_pct
          so_due_date so_fix_pr so_fob so_fr_list so_fr_min_wt
          so_fr_terms so_lang so_nbr so_ord_date so_partial
          so_po so_prepaid so_pricing_dt so_primary so_print_pl
          so_print_so so_project so_pr_list so_pst_pct
          so_req_date so_rev so_rmks so_secondary so_ship
          so_shipvia so_site so_slspsn so_stat so_taxable
          so_taxc so_tax_date so_tax_pct so_trl1_amt
          so_trl1_cd so_trl2_amt so_trl2_cd so_trl3_amt
          so_trl3_cd so_userid so_weight_um)
   where recid(so_mstr) = so_recno
   no-lock: end.

   if not available so_mstr then undo mainloop, leave mainloop.

   /* During line-item entry/edit, the printing of packing list is disabled */
   do transaction:

      find so_mstr where recid(so_mstr) = so_recno exclusive-lock.
      assign
         old_so_print_pl = so_print_pl
         so_print_pl     = false.

   end. /* transaction */

   /* CHECK FOR A CHANGE TO THE CREDIT STATUS */
   if soc_use_btb
      and so_primary
   then do:
      /* PROCESS THE SO MASTER TO CREATE NEW EMT PO */
      {gprunp.i "soemttrg" "p" "process-order-header"
         "(input new_order,
           input so_nbr,
           output return-msg)" }

      if return-msg <> 0
      then do:
         {pxmsg.i &MSGNUM=return-msg &ERRORLEVEL=4}
         return-msg = 0.
         if not batchrun then pause.
         undo mainloop, retry mainloop.
      end. /* IF return-msg <> 0 */

   end. /* IF so_use_btb ... */

   /* LINE ITEMS */

   /* SOSOMTA.P'S THIRD INPUT PARAMETER IS USED BY RMA'S ONLY.   */
   /* YES INDICATES THAT RMA ISSUE LINES ARE BEING PROCESSED.    */
   /* FOR RMA'S, WE'LL CALL SOSOMTA.P TWICE - FIRST FOR ISSUES   */
   /* THEN FOR RMA RECEIPT LINES.                                */

   /* Identify context for QXtend */
   {gpcontxt.i
      &STACKFRAG = 'sosomta,sosomt1,fsrmamt'
      &FRAME = 'c' &CONTEXT = 'ISS'}

/**xx****11/17/2004*/
   {gprun.i ""xxsosomta.p""
      "(input this-is-rma,
        input rma-recno,
        input yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   /* Clear context for QXtend */
   {gpcontxt.i
      &STACKFRAG = 'sosomta,sosomt1,fsrmamt'
      &FRAME = 'c'}

   if this-is-rma then do:

      /* Identify context for QXtend */
      {gpcontxt.i
         &STACKFRAG = 'sosomta,sosomt1,fsrmamt'
         &FRAME = 'c' &CONTEXT = 'REC'}

      /* FOR RMA'S, WE CREATED OUR ISSUE LINES (THE PARTS WE'LL BE    */
      /* SENDING OUT TO CUSTOMERS).  NOW, CREATE THE RECEIPT LINES    */
      /* (THE PARTS THEY'RE RETURNING TO US).                         */
      {gprun.i ""sosomta.p""
         "(input this-is-rma,
           input rma-recno,
           input no)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      /* Clear context for QXtend */
      {gpcontxt.i
         &STACKFRAG = 'sosomta,sosomt1,fsrmamt'
         &FRAME = 'c'}

   end.    /* if this-is-rma */

   /* Reprice after Line processing */
   {gprun.i ""xxsosoprc.p""
      "(input so_recno,
        input reprice,
        input new_order,
        input line_pricing)" }
/*GUI*/ if global-beam-me-up then undo, leave.


   /* SET CREDIT & FREIGHT TERMS FIELDS */
   do transaction:

      if current_cr_terms <> "" and
         current_cr_terms <> so_cr_terms
      then
         assign
            cr_terms_changed = yes
            so_cr_terms = current_cr_terms.

      if current_fr_terms <> ""
         and so_manual_fr_terms = no
      then
         so_fr_terms = current_fr_terms.

      assign
         current_cr_terms = ""
         current_fr_terms = ""
         so_print_pl   =  old_so_print_pl.

   end.

   view frame a.
   display so_ship with frame a.

   /* IF LOGISTICS ACCOUNTING IS ENABLED AND VALID FREIGHT TERMS/LIST IS     */
   /* ENTERED DISPLAY THE LOGISTICS CHARGE DETAIL FRAME WHICH DISPLAYS THE   */
   /* DEFAULT LOGISTICS SUPPLIER FOR THIS ORDER WHICH CAN BE UPDATED IN THIS */
   /* FRAME. NOTE: A CORRESPONDING lacd_det RECORD IS CREATED AND THIS       */
   /* LOGISTICS SUPPLIER IS STORED THERE.                                    */
   if use-log-acctg and
      so_fr_terms <> "" and
      (can-find(first sod_det where sod_nbr = so_nbr and sod_fr_list <> ""))
   then do transaction on error undo, retry:

      for first ft_mstr fields (ft_lc_charge ft_accrual_level)
      where ft_terms = so_fr_terms no-lock:
      end. /* FOR FIRST FT_MSTR */

      if available ft_mstr
         and (ft_accrual_level = {&LEVEL_Shipment}
              or ft_accrual_level = {&LEVEL_Line})
      then do:

         lv_shipfrom = "".

         for first sod_det fields (sod_nbr sod_site)
         where sod_nbr = so_nbr no-lock:
            lv_shipfrom = sod_site.
         end.

         if ft_accrual_level = {&LEVEL_Shipment} and so_site <> "" then
            lv_shipfrom = so_site.

         /* DISPLAY LOGISTICS CHARGE DETAIL */
         {gprunmo.i  &module = "LA" &program = "laosupp.p"
                     &param  = """(input 'ADD',
                                   input '{&TYPE_SO}',
                                   input so_nbr,
                                   input lv_shipfrom,
                                   input ft_lc_charge,
                                   input ft_accrual_level,
                                   input yes,
                                   input yes)"""}
      end. /* IF AVAILABLE FT_MSTR AND ... */

   end.   /* TRANSACTION */

   do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

/**xx***/
        ASSIGN tot_var = 0 
                       baseprice = 0 .
 
        FIND FIRST icc_ctrl NO-LOCK NO-ERROR .
        FIND FIRST pt_mstr WHERE pt_part = icc_user1 NO-LOCK NO-ERROR.
        IF AVAILABLE pt_mstr  THEN cuum = pt_um.
        ELSE  cuum = "".
        FOR EACH sod_det WHERE sod_nbr = so_nbr AND sod__dec01 <> 0  NO-LOCK :
            FIND FIRST pt_mstr WHERE pt_part = sod_part NO-LOCK NO-ERROR .
            FIND LAST pi_mstr WHERE pi_list = "base"  AND pi_part_code = icc_user1 AND pi_um = cuum 
            AND ( so_ord_date >= pi_start  OR pi_start = ? ) AND ( so_ord_date <= pi_expire OR pi_expire = ? ) 
            NO-LOCK NO-ERROR .
            IF AVAILABLE pi_mstr  THEN baseprice = pi_list_price  .
            ELSE DO:
                BELL.
                MESSAGE "The Copper  basic  rate has not defined (Price List in the Menu 1.10.1.1 )  !  "  VIEW-AS ALERT-BOX ERROR BUTTONS OK. 
                baseprice = 0 .
            END.
            tot_var = tot_var + ( sod__dec01 - baseprice ) * sod_qty_ord * sod_um_conv * ( pt__dec01 + pt__dec02 ) .
        END.
        ASSIGN 
           so_mstr.so__dec01  = tot_var  .
/**xx***/


      /* INITIALIZE TRAILER CODES FROM CONTROL FILE FOR NEW ORDERS ONLY */
      {&SOSOMT1-P-TAG2}
      {gpgettrl.i &hdr_file="so" &ctrl_file="soc"}
      {&SOSOMT1-P-TAG3}

      /* FOR A VALID fr_list ENTERED IN SO HEADER, WHICH IS NOT A  */
      /* DEFAULT IN SALES ORDER CONTROL FILE, TRAILER CODE 1 IS    */
      /* UPDATED WITH TRAILER CODE OF THE FREIGHT LIST.            */
      if new_order
         and soc_use_frt_trl_cd
      then do:

         for first fr_mstr
         fields (fr_curr fr_list fr_site fr_trl_cd)
         where fr_list = so_fr_list
           and fr_site = so_site
           and fr_curr = so_curr
         no-lock:
            so_trl1_cd = fr_trl_cd.
         end. /* FOR FIRST fr_mstr */

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF new-order and ... */

      /* CALCULATE FREIGHT */
      if calc_fr and so_fr_terms = "" then do:
         /* INVALID FREIGHT TERMS */
         {pxmsg.i &MSGNUM=671 &ERRORLEVEL=2 &MSGARG1=so_fr_terms}
      end. /* IF CALC_FR AND SO_FR_TERMS */

      if calc_fr and so_fr_terms <> "" then do:
         {gprun.i ""sofrcalc.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


         if use-log-acctg then do:
            /* CREATE TAX RECORDS FOR FREIGHT ACCRUAL */
            {gprunmo.i  &module = "LA" &program = "lafrtax.p"
                        &param  = """(input so_site,
                                      input '{&TYPE_SO}',
                                      input (if so_tax_date <> ? then
                                                so_tax_date
                                             else if so_due_date <> ? then
                                                so_due_date
                                             else so_ord_date),
                                      input (if so_due_date <> ? then
                                                so_due_date
                                             else so_ord_date),
                                      input so_curr,
                                      input so_ex_rate,
                                      input so_ex_rate2,
                                      input ' ',  /* BLANK PVO_EX_RATETYPE */
                                      input so_exru_seq,
                                      input this-is-rma)"""}
         end.

      end.

   end.   /* TRANSACTION */

   /* TRAILER */
   for first bill_cm
   fields(cm_addr)
   where bill_cm.cm_addr = so_bill no-lock:
   end. /* FOR FIRST BILL_CM */

   cm_recno = recid(bill_cm).

   /* Maintain Trailer Section */
   {gprun.i ""xxsosomtc.p"" "(input this-is-rma)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   {gpdelp.i "soemttrg" "p"}

   /* IF VENDOR IS AUTHORIZED TO RECEIVE PO THEN QUEUE PO'S    */
   /* FOR TRANSMISSION                                         */
   /* IN MULTI EMT, CHANGE IS ALLOWED AT BOTH PBU AND SBU      */
   if so_primary then do:

      for each wkf-btb where w-msg-type <> ""
      break by w-po-nbr by w-msg-type:
/*GUI*/ if global-beam-me-up then undo, leave.


         if first-of(w-po-nbr)
            and not can-find(trq_mstr
                                where trq_doc_type = "PO"
                                  and trq_doc_ref  = w-po-nbr)
         then do:
            for first po_mstr
               fields(po_nbr po_xmit)
               where po_nbr = w-po-nbr
               no-lock:

               /* CREATE trq_mstr RECORD ALWAYS FOR A NEW EMT PO           */
               /* AND FOR EXPORTING EMT PO CHANGES ONLY WHEN THE           */
               /* VALUE OF po_xmit IS EQUAL TO "4" IMPLYING A VALID CHANGE */
               if not (    w-msg-type = "ORDCHG"
                       and po_xmit    <> "4")
               then do:

                  for first ad_mstr
                     fields(ad_addr ad_po_mthd)
                     where ad_addr = w-btb-vend
                     no-lock:
                  end. /* FOR FIRST ad_mstr */

                  for first vd_mstr
                     fields(vd_addr vd_rcv_held_so)
                     where vd_addr = w-btb-vend
                     no-lock:
                  end. /* FOR FIRST vd_mstr */

                  if available ad_mstr
                     and (ad_po_mthd = "e" or ad_po_mthd = "b")
                     and available vd_mstr
                     and (so_stat = ""
                          or (so_stat = "HD" and vd_rcv_held_so = yes))
                     and w-po-nbr <> ""
                  then do:
                     assign
                        doc-type = "PO"
                        doc-ref  = w-po-nbr
                        add-ref  = ""
                        msg-type = w-msg-type
                        trq-id   = 0.

                     /* QUEUE DOCUMENT FOR TRANSMISSION - BTB */
                     {gprun.i ""gpquedoc.p""
                        "(input-output doc-type,
                          input-output doc-ref,
                          input-output add-ref,
                          input-output msg-type,
                          input-output trq-id,
                          input yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  end. /* AVAIL AD_MSTR AND ... AND AVAIL VD_MSTR AND ...*/
               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF NOT ( w-msg-type .....) */
            end. /* FOR FIRST po_mstr */

            delete wkf-btb.

         end. /* IF FIRST-OF(W-PO-NBR) */

      end. /* EACH WKF-BTB WHERE W-MSG-TYPE <> "" */

   end.  /* IF SO_PRIMARY */

   if so_secondary then do:

      find first wkf-btb where w-msg-type <> ""
      exclusive-lock no-error.

      if available wkf-btb
      then do:

         assign
            doc-type = "SO"
            doc-ref  = w-so-nbr
            add-ref  = ""
            msg-type = w-msg-type
            trq-id   = 0.

         /* QUEUE DOCUMENT FOR TRANSMISSION - EMT */
         {gprun.i ""gpquedoc.p""
            "(input-output doc-type,
              input-output doc-ref,
              input-output add-ref,
              input-output msg-type,
              input-output trq-id,
              input yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      end.  /* AVAIL WKF-BTB AND INVOICE METHOD = EDI */

      if available wkf-btb then delete wkf-btb.

   end. /* SECONDARY SO */

   {&SOSOMT1-P-TAG4}

   /* IMPORT EXPORT FLAG IS SET TO YES CALL THE IMPORT EXPORT DETAIL */
   /* LINE MAINTENANCE PROGRAM FOR USER TO UPDATE ied_det            */

   if not batchrun and impexp then do:

      impexp_edit = no.

      /* VIEW EDIT IMPORT EXPORT DATA ? */
      {pxmsg.i &MSGNUM=271 &ERRORLEVEL=1 &CONFIRM=impexp_edit}

      if impexp_edit then do:
         hide frame sotot no-pause.
         hide frame d no-pause.
         upd_okay = no.
         {gprun.i ""iedmta.p""
            "(input ""1"",
              input so_nbr,
              input-output upd_okay )" }
/*GUI*/ if global-beam-me-up then undo, leave.

      end.
   end.    /* if not batchrun and impexp */

   if not this-is-rma then do:
      /* TRAILER FRAMES FOR RMA ARE HIDDED IN sosomtc.p */
      hide frame sotot no-pause.
      hide frame d no-pause.
   end. /* IF NOT THIS-IS-RMA */

   /* FOR RMA'S, THE ADDITIONAL TRAILER ROUTINE WILL OPTIONALLY   */
   /* REDISPLAY THE RMA LINES, AND ALLOWS THE USER TO SHIP AND    */
   /* RECEIVE RMA LINES FROM RMA MAINTENANCE.                     */
   if this-is-rma then do:
      {gprun.i ""fsrmamtu.p"" "(input rma-recno)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end.

   global_type = comment_type.

   /* Batch checking for SO processing*/
   for first sod_det
   fields(sod_nbr sod_confirm)
   where sod_nbr = so_nbr and not sod_confirm
   no-lock: end.

   if batch_job and available sod_det then do:
      {gprun.i ""sobatch.p""
         "(input so_nbr,
           input-output batch_job,
           input-output dev,
           input-output batch_id)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end.

end. /* mainloop */

if cfexists and cf_cfg_strt_err = no then do:
   /* Close configurations*/
        
   {gprunmo.i &module  = "cf" &program = "cfcfclos.p"
      &param   = """(input cf_cfg_path, input cf_chr,
                     cf_cfg_suf) """}
      
   /* Shut configurator*/
        
   {gprunmo.i &module  = "cf" &program = "cfcfstop.p"}
     
end.

status input.
