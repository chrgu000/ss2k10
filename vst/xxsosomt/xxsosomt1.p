/* sosomt1xx.p - SALES ORDER MAINTENANCE                                  */
/*     copied from sosomt1.p - SALES ORDER MAINTENANCE                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.34.2.7 $                                              */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 8.5      LAST MODIFIED: 08/25/95   BY: *J04C* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: *J034* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: *J042* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: *J053* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 04/17/96   BY: *J0HR* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 04/26/96   BY: *J0KJ* DAH          */
/* REVISION: 8.5      LAST MODIFIED: 05/14/96   BY: *J0M3* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 07/10/96   BY: *J0YH* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: *J12Q* Andy Wasilczuk    */
/* REVISION: 8.6      LAST MODIFIED: 09/27/96   BY: *K007* svs          */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Elke Van Maele    */
/* REVISION: 8.6      LAST MODIFIED: 11/05/96   BY: *K01T* Stephane Collard  */
/* REVISION: 8.6      LAST MODIFIED: 05/07/97   BY: *J1P5* Ajit Deodhar */
/* REVISION: 8.6      LAST MODIFIED: 06/06/97   BY: *K0CZ* Kieu Nguyen  */
/* REVISION: 8.6      LAST MODIFIED: 07/11/97   BY: *K0DH* Kieu Nguyen  */
/* REVISION: 8.6      LAST MODIFIED: 08/06/97   BY: *J1YG* Seema Varma  */
/* REVISION: 8.6      LAST MODIFIED: 09/23/97   BY: *K0HB* Kieu Nguyen  */
/* REVISION: 8.6      LAST MODIFIED: 11/18/97   BY: *J25B* Aruna Patil  */
/* REVISION: 8.6      LAST MODIFIED: 11/18/97   BY: *K1BG* Aruna Patil  */
/* REVISION: 8.6      LAST MODIFIED: 12/01/97   BY: *K1BN* Bryan Merich */
/* REVISION: 8.6      LAST MODIFIED: 01/31/98   BY: *J2D6* Seema Varma  */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6ELAST MODIFIED: 04/23/98 BY: *L00L* EvdGevel */
/* REVISION: 8.6ELAST MODIFIED: 05/20/98 BY: *K1Q4* Alfred Tan          */
/* REVISION: 8.6ELAST MODIFIED: 10/04/98 BY: *J314* Alfred Tan               */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* David Morris */
/* REVISION: 9.0      LAST MODIFIED: 02/24/99   BY: *M094* Jean Miller  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 10/06/99   BY: *L0J4* Satish Chavan     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *N0CG* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED: 06/14/00   BY: *L0Y4* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED: 07/03/00   BY: *N0DX* Rajinder Kamra    */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb               */
/* REVISION: 9.1      LAST MODIFIED: 11/19/00   BY: *M0WC* Rajesh Thomas     */
/* REVISION: 9.1      LAST MODIFIED: 12/18/00   BY: *M0TZ* Veena Lad         */
/* REVISION: 9.1      LAST MODIFIED: 10/16/00   BY: *N0WB* BalbeerS Rajput   */
/* REVISION: 9.0      LAST MODIFIED: 06/05/01   BY: *M11Z* Jean Miller       */
/* REVISION: 9.1      LAST MODIFIED: 06/26/01   BY: *M1C2* Sachin Shinde     */
/* REVISION: 9.1      LAST MODIFIED: 08/09/01   BY: *M1H1* Santhosh Nair     */
/* REVISION: 9.1      LAST MODIFIED: 06/11/01   BY: *L194* Sandeep P.        */
/* Revision: 1.34.2.6   BY: Julie Milligan    DATE: 11/28/01 ECO: *N162*     */
/* $Revision: 1.34.2.7 $   BY: Ashish M.       DATE: 02/15/02 ECO: *N193*     */
/* ADM1    11/17/03 Brian Lo -  add audit trail logic      */

/*!
    Sosomt1.p performs the 'driver' function for Sales Order and RMA
    Maintenance.  These two functions were previously handled by sosomt.p
    and fsrmamt.p.  This program was originally copied from sosomt.p.
*/

         /* DISPLAY TITLE */
         {mfdeclre.i}
/*N0WB*/ {cxcustom.i "SOSOMT1.P"}
/*M11Z*  {gplabel.i &ClearReg=yes} */
/*M11Z*/ {gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

/*N0DX
 * &SCOPED-DEFINE sosomt1_p_1 "DELETE IF FOUND"
 * /* MaxLen: Comment: */
 *N0DX*/

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
/*N162*/ {pxmaint.i}
         /* Define Handles for the programs. */
/*N162*/ {pxphdef.i giapoxr}
         /* End Define Handles for the programs. */

/*N162*/ /* APO ATP Global Defines */
/*N162*/ {giapoatp.i}


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
         define new shared variable base_amt like ar_amt.
         define new shared variable sod_recno as recid.
         define new shared variable consume like sod_consume.
         define new shared variable prev_consume like sod_consume.
         define  new shared  variable confirm like mfc_logical
                  format "yes/no" initial yes label {&sosomt1_p_5}.
         define new shared variable sotrcust like so_cust.
         define new shared variable merror like mfc_logical initial no.
         define new shared variable so-detail-all like soc_det_all.
         define new shared variable new_order like mfc_logical initial no.
         define new shared variable sotax_trl like tax_trl.
         define new shared variable tax_in like cm_tax_in.
         define new shared variable rebook_lines as logical initial no no-undo.
         define new shared variable avail_calc as integer.
         define new shared variable so_db like dc_name.
         define new shared variable inv_db like dc_name.
         define new shared variable mult_slspsn like mfc_logical no-undo.
/*J042**
 *       define new shared variable qo_recno as recid.
 *       define new shared variable qod_recno as recid.
 *       define new shared variable qoc_pt_req like mfc_logical.
**J042*/
         define new shared variable undo_cust like mfc_logical.
         define new shared variable freight_ok like mfc_logical initial yes.
         define new shared variable old_ft_type like ft_type.
         define new shared variable calc_fr like mfc_logical
                                            label {&sosomt1_p_3}.
         define new shared variable undo_flag like mfc_logical.
         define new shared variable disp_fr like mfc_logical.
         define new shared variable display_trail like mfc_logical initial yes.
         define new shared variable soc_pc_line like mfc_logical initial yes.
         define new shared variable socrt_int like sod_crt_int.
         define new shared variable impexp_label as character format "x(12)"
                                                 no-undo.
         define new shared variable impexp   like mfc_logical no-undo.
/*J042*/ define new shared variable sonbr like so_nbr.
/*J042*/ define new shared variable picust like cm_addr.
/*J042*/ define new shared variable price_changed like mfc_logical.
/*J042*/ define new shared variable line_pricing like pic_so_linpri
                                                 label {&sosomt1_p_7}.
/*J042*/ define new shared variable reprice like mfc_logical label {&sosomt1_p_8}
                                            initial no.
/*J053*/ define new shared variable rndmthd like rnd_rnd_mthd.
/*J053*/ define new shared variable oldcurr like so_curr.
/*J053*/ define new shared variable balance_fmt as character.
/*J053*/ define new shared variable limit_fmt as character.
/*J053*/ define new shared variable prepaid_fmt as character no-undo.
/*J053*/ define new shared variable prepaid_old as character no-undo.
/*M1C2*/ define new shared variable trans_conv like sod_um_conv.
/*J042*  define variable sonbr like so_nbr.     */
         define variable yn like mfc_logical initial yes.
/*J053*  define variable i as integer.          */
         define variable comment_type like so_lang.
/*M11Z*  define variable sotrnbr like so_nbr.  */
/*J053*  define variable counter as integer no-undo.    */
/*M11Z*  define variable sort as character format "x(28)" extent 4 no-undo. */
/*M11Z*  define variable keylist as character
 *          initial "RETURN,TAB,BACK-TAB,GO,13,9,509,245,513,301,248" no-undo. */
         define variable old_so_print_pl like so_print_pl no-undo.
/*M11Z*  define variable alloc   like mfc_logical label {&sosomt1_p_4}. */
         define variable impexp_edit like mfc_logical no-undo.
         define variable upd_okay    like mfc_logical no-undo.
         define variable batch_job   as logical.
         define variable dev         as character.
         define variable batch_id    as character.
/*N162*/ define variable moduleGroup         as character no-undo initial "SO".
/*N162*/ define variable messageField        as character no-undo.
/*N162*/ define variable messageNumber       like msg_nbr no-undo.

/*J053*  define variable in_batch_proces as logical.    */

         /* RMA-SPECIFIC VARIABLES */
/*M11Z*  define variable msgref      as character format "x(20)" no-undo. */
         define variable rma-recno   as recid no-undo.
/*M11Z*  define variable call-number like rma_ca_nbr initial " " no-undo. */
/*M11Z*  define variable eutype      like eu_type no-undo.                */

         /* EMT SPECIFIC VARIABLES */
/*M11Z* /*K004*/ define new shared variable s-prev-so-stat like so_stat no-undo. */
/*M11Z* /*L0Y4*/ define new shared variable prev-ship-to like so_ship     no-undo. */
/*M11Z* /*L0Y4*/ define new shared variable l_status   like mfc_logical no-undo.   */

/*M1H1*/ /*THIS TEMP TABLE IS CRESTED TO CALCULATE FREIGHT CHARGES  */
/*M1H1*/ /*WHEN A NEW SALES ORDER LINE IS ADDED TO AN EXISTING ORDER*/
/*M1H1*/ /*WHEN THE FREIGHT TYPE IS "INCLUDE".                      */
/*M1H1*/ define new shared temp-table l_fr_table
/*M1H1*/        field l_fr_sonbr   like sod_nbr
/*M1H1*/        field l_fr_soline  like sod_line
/*M1H1*/        field l_fr_chrg    like sod_fr_chg
/*M1H1*/        field l_sodlist_pr like sod_list_pr
/*M1H1*/        index nbrline is primary l_fr_sonbr l_fr_soline.

/*M017*/ /* TEMP TABLE DEFINITIONS FOR APM/API */
/*M017*/ {ifttcmdr.i "new"}
/*M017*/ {ifttcmdv.i "new"}

/*K004*/ {sobtbvar.i "new"}   /* BACK TO BACK SHARED WORKFILES AND VARIABLES */

/*N0WB*/ {&SOSOMT1-P-TAG1}

         /* RECORD BUFFERS */
         define            buffer   bill_cm     for  cm_mstr.
/*M11Z*  define            buffer   rmdbuff     for  rmd_det. */

         /* SHARED STREAMS AND FRAMES */
/*J042*/ define new shared stream bi.
         define new shared frame a.

/*J053*  ** THESE FRAMES WERE MOVED TO SOSOMTA1.P ***********************
 *        define new shared frame sold_to.
 *       define new shared frame ship_to.
 *       define new shared frame b.
 *J053 END***************************************************************/
/*K007*/ define new shared variable wk_bs_line  like pih_bonus_line no-undo.
/*K007*/ define new shared variable wk_bs_promo as character format "x(8)"
/*K007*/                                        no-undo.
/*K007*/ define new shared variable wk_bs_listid like pih_list_id no-undo.
/*J042*/ define new shared frame bi.

/*J1P5*/ /* MOVED UP THE TRAILER FRAMES DEFINITION FROM sosomtc.p  */
/*J1P5*/  define new shared frame sotot.
/*J1P5*/  define new shared frame d.

/*J042*  {gpfowfop.i "new"}   /* work3_list SHARED WORKFILE AND VARIABLES */   */
/*J042*/ {pppivar.i "new"}  /* PRICING VARIABLES */

/*K1BN*/ define new shared variable cfexists like mfc_logical.
/*K1BN*/ define new shared variable cf_cfg_path like mfc_char.
/*K1BN*/ define new shared variable cf_cfg_suf  like mfc_char.
/*K1BN*/ define new shared variable cf_chr   as character.
/*K1BN*/ define new shared variable cf_cfg_strt_err  like mfc_logical.
/*K1BN*/ define variable cf_default_model as character.
/*K1BN*/ define variable cf_exe_loc as character.
/*K1BN*/ define new shared variable phCfcfstrt as handle no-undo.
/*K1BN*/ define new shared variable phCfEvents as handle no-undo.
/*K1BN*/ define new shared variable CtrlFrame as widget-handle no-undo.
/*K1BN*/ define variable err-stat as integer.
/*K1BN*/ define variable checkwritepath as character.
/*K1BN*/ define variable testfile as character.
/*K1BN*/ define new shared variable calicodone like mfc_logical.

/*L194** BEGIN DELETE **
 * /*L0J4*/ /* SHARED VARIABLE CREDIT-FUNC IS USED TO IDENTIFY              */
 * /*L0J4*/ /* CREDIT FUNCTIONS                                             */
 * /*L0J4*/ /* YES -> INDICATES A CREDIT FUNCTION                           */
 * /*L0J4*/ /* NO  -> INDICATES NON-CREDIT FUNCTION                         */
 *
 * /*L0J4*/ define new shared variable credit-func like mfc_logical initial no
 * /*L0J4*/                                                         no-undo.
 *L194** END DELETE */

         {gptxcdec.i}
/*L00L*/ {etdcrvar.i "new"}
/*L00L*/ {etvar.i &new="new"}
/*L00L*/ {etrpvar.i &new="new"}

/*L00L* /*J053*/ {mfsotrla.i "NEW"}              */
/*L00L*/ {etsotrla.i "NEW"}
/*J053*/ {sosomt01.i}

/*N0CG*/ {gpcrfmt.i}

/*J2D6*/ /* REPLACED BELOW BLOCK BY SOBIFRM.I */
/*J2D6** BEGIN DELETE **
 * /*J042*/ form
 * /*J042*/    sod_qty_ord                format "->>>>,>>9.9<<<<"
 * /*J042*/    sod_list_pr                format ">>>,>>>,>>9.99<<<"
 * /*J042*/    sod_disc_pct label "Disc%" format "->>>>9.99"
 * /*J042*/ with frame bi width 80.
 *J2D6** END DELETE   */

/*J2D6*/ /* FORM DEFINITION FOR HIDDEN FRAME BI */
/*J2D6*/ {sobifrm.i}

/*J042*/ form sod_det with frame bi width 80.

/*J042*/ /*DEFINE WORKFILE FOR QTY ACCUM USED BY BEST PRICING ROUTINES*/
         {pppiwqty.i "new" }

/*J053*/ /* ASSIGN ORIGINAL FORMAT TO _OLD VARIABLES */
/*J053*/ assign
/*J053*/   nontax_old   = nontaxable_amt:format
/*J053*/   taxable_old  = taxable_amt:format
/*J053*/   line_tot_old = line_total:format
/*J053*/   line_pst_old = line_pst:format
/*J053*/   disc_old     = disc_amt:format
/*J053*/   trl_amt_old  = so_trl1_amt:format
/*J053*/   tax_amt_old  = tax_amt:format
/*J053*/   tot_pst_old  = total_pst:format
/*J053*/   tax_old      = tax[1]:format
/*J053*/   amt_old      = amt[1]:format
/*J053*/   ord_amt_old  = ord_amt:format
/*J053*/   prepaid_old  = so_prepaid:format.

/*J053*/ oldcurr = "".
/*N0CG** /*J053*/ find first gl_ctrl no-lock. */
/*N0CG*/ for first gl_ctrl
/*N0CG*/    fields(gl_can gl_rnd_mthd gl_vat) no-lock:
/*N0CG*/ end. /* FOR FIRST GL_CTRL */

/*J053*/ /* SET LIMIT_FMT ACCORDING TO BASE CURR ROUND METHOD*/
/*J053*/ limit_fmt = "->>>>,>>>,>>9.99".
/*N0CG** /*J053*/ {gprun.i ""gpcurfmt.p"" "(input-output limit_fmt, */
/*N0CG**                           input gl_rnd_mthd)"}             */

/*N0CG*/ run gpcrfmt (input-output limit_fmt,
                      input gl_rnd_mthd).

/*J053*/ /* SET BALANCE_FMT ACCORDING TO BASE CURR ROUND METHOD*/
/*J053*/ balance_fmt = "->>>>,>>>,>>9.99".
/*N0CG** /*J053*/ {gprun.i ""gpcurfmt.p"" "(input-output balance_fmt, */
/*N0CG**                                    input gl_rnd_mthd)"}      */

/*N0CG*/ run gpcrfmt (input-output balance_fmt,
                      input gl_rnd_mthd).

         do transaction on error undo, retry:       /* TRANSACTION 10 */
/*N0CG**    find first soc_ctrl no-lock no-error.  */
/*N0CG*/    for first soc_ctrl
/*N0CG*/       fields(soc_all soc_all_avl soc_all_days soc_confirm
/*N0CG*/              soc_det_all soc_edit_isb soc_hcmmts soc_lcmmts
/*N0CG*/              soc_ln_fmt soc_on_ord soc_req soc_so_hist soc_trl_ntax
/*N0CG*/              soc_trl_tax soc_use_btb) no-lock:
/*N0CG*/    end. /* FOR FIRST SOC_CTRL */

            if not available soc_ctrl then create soc_ctrl.
            assign
                all_days = soc_all_days
                all_avail = soc_all_avl
                sngl_ln = soc_ln_fmt
                socmmts = soc_hcmmts
                comment_type = global_type
/*J042*         disc_tbl_req = soc_pl_req   */
                confirm = soc_confirm.

            /* BATCH PROCESSING PARAMETERS */
/*N0CG**    find first mfc_ctrl where mfc_field = "soc_batch"  */
/*N0CG**    no-lock no-error.                                  */
/*N0CG*/    for first mfc_ctrl
/*N0CG*/       fields(mfc_char mfc_field mfc_logical)
/*N0CG*/       where mfc_field = "soc_batch" no-lock:
/*N0CG*/    end. /* FOR FIRST MFC_CTRL */

            if available mfc_ctrl then batch_job = mfc_logical.
/*N0CG**    find first mfc_ctrl where mfc_field = "soc_print_id"  */
/*N0CG**                     no-lock no-error.                    */
/*N0CG*/    for first mfc_ctrl
/*N0CG*/       fields(mfc_char mfc_field mfc_logical)
/*N0CG*/       where mfc_field = "soc_print_id" no-lock:
/*N0CG*/    end. /* FOR FIRST MFC_CTRL */

            if available mfc_ctrl then dev = mfc_char.
/*N0CG**    find first mfc_ctrl where mfc_field = "soc_batch_id"  */
/*N0CG**                     no-lock no-error.                    */
/*N0CG*/    for first mfc_ctrl
/*N0CG*/       fields(mfc_char mfc_field mfc_logical)
/*N0CG*/       where mfc_field = "soc_batch_id" no-lock:
/*N0CG*/    end. /* FOR FIRST MFC_CTRL */

            if available mfc_ctrl then batch_id = mfc_char.

            /* FOR RMA'S, VALUES USUALLY OBTAINED FROM SOC_CTRL */
            /* COME FROM RMC_CTRL.  GET SVC_CTRL ALSO - IT'LL   */
            /* BE NEEDED LATER ON...                            */
            if this-is-rma then do:
/*N0CG**        find first rmc_ctrl no-lock no-error.           */
/*N0CG*/        for first rmc_ctrl
/*N0CG*/           fields(rmc_all_days rmc_consume rmc_det_all rmc_edit_isb
/*N0CG*/                  rmc_hcmmts rmc_history rmc_lcmmts) no-lock:
/*N0CG*/        end. /* FOR FIRST RMC_CTRL */

/*N0CG*/ /* COMMENTED THE BELOW FIND FIRST ON SVC_CTRL SINCE IT IS NOT */
/*N0CG*/ /* BEING USED                                                 */
/*N0CG**        find first svc_ctrl no-lock no-error.                  */

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

/*N162*/ /* BEGIN ADD SECTION */
         if can-find(mfc_ctrl where mfc_field = {&USE_APO_ATP_FOR_SO}
            and mfc_logical)
         then do:

            {pxrun.i &proc = 'validateDemandListenerExists'
                &program = 'giapoxr.p'
                &handle = ph_giapoxr
                &param = "(input moduleGroup,
                           output messageNumber,
                           output messageField)"
                &catcherror = true
                &noapperror = true
                &bolton = 'GI1'}

            if return-value <> {&SUCCESS-RESULT} then do:
               {pxmsg.i &MSGNUM = messageNumber
                        &ERRORLEVEL= {&WARNING-RESULT}
                        &MSGARG1 = messageField}
               pause.
            end.

         end. /* use Apo Atp? */
/*N162*/ /* END ADD SECTION */
         do transaction on error undo, retry:       /* TRANSACTION 20 */

            /* SET UP PRICING BY LINE VALUES */
/*N0CG**    find first mfc_ctrl where mfc_field = "soc_pc_line"       */
/*N0CG**        no-lock no-error.                                     */
/*N0CG*/    for first mfc_ctrl
/*N0CG*/       fields(mfc_char mfc_field mfc_logical)
/*N0CG*/       where mfc_field = "soc_pc_line" no-lock:
/*N0CG*/    end. /* FOR FIRST MFC_CTRL */

            if available mfc_ctrl then do:
               soc_pc_line = mfc_logical.
            end.

         end.                                       /* TRANSACTION 20 */

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

/*J053*  find first gl_ctrl no-lock.    */
         so_db = global_db.

/*J042*/ do transaction on error undo, retry:           /* TRANSACTION 25 */
/*N0CG** /*J042*/    find first pic_ctrl no-lock no-error.                */
/*N0CG*/    for first pic_ctrl
/*N0CG*/       no-lock:
/*N0CG*/    end. /* FOR FIRST PIC_CTRL */
/*J042*/    if not available pic_ctrl then
/*J042*/       create pic_ctrl.
/*J042*/ end.                                           /* TRANSACTION 25 */

/*K1BN*/ /* check for existance of configurator control record*/
/*K1BN*/ {gprun.i ""cfctrl.p"" "(""cf_w_mod"", output cfexists)"}

/*K1BN*/ if cfexists and this-is-rma then
/*K1BN*/    cfexists = no.
/*K1BN*/ if cfexists then do:
/*K1BN*/    /* Determine Unix or Windows path format based on user O/S */
/*K1BN*/    /* For Windows users, 'opsys' responds with 'msdos' */
/*K1BN*/    /* on Pro 8.1 and 'WIN32' on Progress 8.2  */
/*K1BN*/    /* (Progress 8.2 is 32-bit only - Win95 and NT) */
/*K1BN*/    /* Even a Unix user can delete an order and must have access to */
/*K1BN*/    /* the configuration files so that these are deleted with the */
/*K1BN*/    /* order lines.                                                */
/*K1BN*/    if opsys = "msdos":U or opsys = "WIN32":U then do:
/*K1BN*/       cf_chr = "~\".
/*K1BN*/       /*get the Windows path of the sales order configuration files*/
/*N0CG** /*K1BN*/  find mfc_ctrl where mfc_field = "cf_w_so_cfg"  */
/*N0CG**           no-lock no-error.                              */
/*N0CG*/       for first mfc_ctrl
/*N0CG*/          fields(mfc_char mfc_field mfc_logical)
/*N0CG*/          where mfc_field = "cf_w_so_cfg" no-lock:
/*N0CG*/       end. /* FOR FIRST MFC_CTRL */

/*K1BN*/       if available mfc_ctrl then cf_cfg_path = mfc_char.
/*K1BN*/    end.
/*K1BN*/    else do:
/*K1BN*/       cf_chr = "/".
/*K1BN*/       /*get the unix path of the concinity so files */
/*N0CG** /*K1BN*/ find mfc_ctrl where mfc_field = "cf_u_so_cfg"  */
/*N0CG**          no-lock no-error.                              */

/*N0CG*/       for first mfc_ctrl
/*N0CG*/          fields(mfc_char mfc_field mfc_logical)
/*N0CG*/          where mfc_field = "cf_u_so_cfg" no-lock:
/*N0CG*/       end. /* FOR FIRST MFC_CTRL */

/*K1BN*/       if available mfc_ctrl then cf_cfg_path = mfc_char.
/*K1BN*/    end.

/*K1BN*/    /* validate that the path is accessible*/
/*K1BN*/    cf_cfg_strt_err = no.
/*K1BN*/    output to "cf_test.txt":U.
/*N0DX /*K1BN*/ display {&sosomt1_p_1}. */
/*N0DX*/        display getTermLabel("DELETE_IF_FOUND",35) format "x(35)".
/*K1BN*/    output close.
/*K1BN*/    checkwritepath = cf_cfg_path + cf_chr + "cf_test.txt":U.
/*K1BN*/    testfile = search("cf_test.txt").
/*K1BN*/    if testfile <> ? then do:
/*K1BN*/      os-copy value(testfile) value(checkwritepath).
/*K1BN*/      err-stat = os-error.
/*K1BN*/      if err-stat = 0 then do:
/*K1BN*/         os-delete value(checkwritepath).
/*K1BN*/         err-stat = os-error.
/*K1BN*/      end.
/*K1BN*/      else err-stat = 1.
/*K1BN*/    end.
/*K1BN*/    else err-stat = 1.

/*K1BN*/    /*Determine if the user is able to run Concinity:  running */
/*K1BN*/    /*Progress 8.2+, running on Win95 or NT, and access to the */
/*K1BN*/    /*Concinity executable. */
/*K1BN*/    if cf_cfg_strt_err = no then do:
/*K1BN*/       cf_cfg_strt_err = yes.
/*M094* /*K1BN*/       if substring(proversion,1,1) = "8" and       */
/*M094* /*K1BN*/          substring(proversion,3,1) ge "2" then do: */
/*M094*/       if (substring(PROVERSION,1,1) = "8" and
/*M094*/           substring(PROVERSION,3,1) >= "2" ) or
/*M094*/           substring(PROVERSION,1,1) = "9" then do:
/*K1BN*/          if opsys = "WIN32":U then do:
/*K1BN*/             /*get the location of Concinity executable*/
/*N0CG** /*K1BN*/    find mfc_ctrl where mfc_field = "cf_w_exe"     */
/*N0CG**             no-lock no-error.                              */
/*N0CG*/             for first mfc_ctrl
/*N0CG*/                fields(mfc_char mfc_field mfc_logical)
/*N0CG*/                where mfc_field = "cf_w_exe" no-lock:
/*N0CG*/             end. /* FOR FIRST MFC_CTRL */

/*K1BN*/             if available mfc_ctrl then cf_exe_loc = mfc_char.
/*K1BN*/             if cf_exe_loc ne "" and search(cf_exe_loc) ne ? then do:
/*K1BN*/                if err-stat eq 0 then do:
/*K1BN*/                   /* The conditions to run Concinity have been met */
/*K1BN*/                   cf_cfg_strt_err = no.
/*K1BN*/                   /* OK to start Concinity, get the default model*/
/*N0CG** /*K1BN*/          find mfc_ctrl where mfc_field = "cf_model"     */
/*N0CG** /*K1BN*/             no-lock no-error.                           */
/*N0CG*/                   for first mfc_ctrl
/*N0CG*/                      fields(mfc_char mfc_field mfc_logical)
/*N0CG*/                      where mfc_field = "cf_model" no-lock:
/*N0CG*/                   end. /* FOR FIRST MFC_CTRL */

/*K1BN*/                 if available mfc_ctrl then cf_default_model = mfc_char.
/*K1BN*/                   /*launch calico*/
/*K1BN*//*V8!
/*K1BN*/                   {gprunmo.i
                              &module  = "cf"
                              &program = "cfcfstrt.p"
                              &param   = """(cf_default_model) """
                              &persistent = ""persistent set phCfcfstrt""}
/*K1BN*/ */
/*K1BN*/                   if cf_cfg_strt_err then do:
/*K1BN*/                      /* An error was discovered in trying to start Concinity */
/*K1BN*/                      {mfmsg.i 1829 4}
/*K1BN*/                      /* Concinity is unavailable */
/*K1BN*/                      delete procedure phCfcfstrt no-error.
/*K1BN*/                   end.
/*K1BN*/                end. /* if err-stat... */
/*K1BN*/ /* We only need to tell the user that the location is not accessable */
/*K1BN*/ /* after we know he/she is a Concinity user */
/*K1BN*/                else do:
/*K1BN*/                    if err-stat ne 0 then do:
/*K1BN*/                        {mfmsg.i 2003 2}
/*K1BN*/                        /* Configuration location is inaccessible */
/*K1BN*/                        cf_cfg_strt_err = yes.
/*K1BN*/                    end.
/*K1BN*/                end. /* end else if err-stat... */
/*K1BN*/             end. /* if cf_exe_loc... */
/*K1BN*/          end. /* if opsys... */
/*K1BN*/       end. /* if proversion... */
/*K1BN*/    end. /* if cf_cfg_strt_err... */
/*K1BN*/    /* The cf_cfg_strt_err variable is used throughout the process to */
/*K1BN*/    /* determine if Concinity is running. (no = no error,it's running)*/

/*K1BN*/    /*get the sales order suffix from the control file*/
/*N0CG** /*K1BN*/ find mfc_ctrl where mfc_field = "cf_so_suf"   */
/*N0CG**          no-lock no-error.                             */
/*N0CG*/    for first mfc_ctrl
/*N0CG*/       fields(mfc_char mfc_field mfc_logical)
/*N0CG*/       where mfc_field = "cf_so_suf" no-lock:
/*N0CG*/    end. /* FOR FIRST MFC_CTRL */

/*K1BN*/    if available mfc_ctrl then cf_cfg_suf = mfc_char.
/*K1BN*/ end. /* if cf_exists... */

         mainloop:
         repeat:

/*J1P5*/ if not this-is-rma then do:
/*J1P5*/    /* TRAILER FRAMES FOR RMA ARE HIDDED IN sosomtc.p */
/*J1P5*/    hide frame sotot no-pause.
/*J1P5*/    hide frame sotrail no-pause.
/*J1P5*/    hide frame cttrail no-pause.
/*J1P5*/    hide frame d no-pause.
/*J1P5*/ end. /* IF NOT THIS-IS-RMA */

/*N0CG**    find first mfc_ctrl where mfc_field = "soc_batch"  */
/*N0CG**       no-lock no-error.                               */
/*N0CG*/    for first mfc_ctrl
/*N0CG*/       fields(mfc_char mfc_field mfc_logical)
/*N0CG*/       where mfc_field = "soc_batch" no-lock:
/*N0CG*/    end. /* FOR FIRST MFC_CTRL */

            if available mfc_ctrl then batch_job = mfc_logical.

/*J053*/    {sosomt02.i}  /* FORM DEFINITIONS FOR SHARED FRAMES A AND B */
/*J0KJ** /*J053*/    view frame dtitle. */
/*J0KJ** /*J053*/    view frame a.      */

/*J12Q*/    cr_terms_changed = no.

/*J0YH*/ /* IF AN EXPLICIT TRANSACTION SURROUNDS THIS, SOC_CTRL */
         /* IS LOCKED FOR THE DURATION OF SO HEADER PROCESSING  */
/*J0YH* /*J0M3*/    do transaction on error undo, retry:    */

/*J053*/       /* PROCESS SALES ORDER HEADER FRAMES */
/*J04C*        ADDED THIS-IS-RMA INPUT PARM, AND RMA-RECNO OUTPUT */
/*J053*/       {gprun.i ""sosomta1.p"" "(input this-is-rma,
                                         output return_int,
                                         output rma-recno)"}

/*J053*/       if return_int = 1 then next mainloop.
/*J053*/       if return_int = 2 then undo mainloop, next mainloop.
/*J053*/       if return_int = 3 then undo mainloop, retry mainloop.
/*J053*/       if return_int = 4 then undo mainloop, leave.

               /* FIND SO_MSTR NO-LOCK TO ENSURE THE USER DIDN'T DELETE */
               /* IT.  NO-LOCK ALSO PREVENTS WARNINGS RELATED TO THE    */
               /* OTHER EXPLICIT TRANSACTIONS IN THIS PROGRAM.          */
/*N0CG** /*J0M3*/       find so_mstr where recid(so_mstr) = so_recno    */
/*N0CG** /*J0YH*/            no-lock no-error.                          */
/*N0CG*/       for first so_mstr
/*N0CG*/          fields(so_ar_acct so_ar_cc so_ar_sub so_bill so_bol
/*N0CG*/                 so_channel so_comm_pct so_conf_date so_cr_card
/*N0CG*/                 so_cr_init so_cr_terms so_curr so_cust so_disc_pct
/*N0CG*/                 so_due_date so_fix_pr so_fob so_fr_list so_fr_min_wt
/*N0CG*/                 so_fr_terms so_lang so_nbr so_ord_date so_partial
/*N0CG*/                 so_po so_prepaid so_pricing_dt so_primary so_print_pl
/*N0CG*/                 so_print_so so_project so_pr_list so_pst_pct
/*N0CG*/                 so_req_date so_rev so_rmks so_secondary so_ship
/*N0CG*/                 so_shipvia so_site so_slspsn so_stat so_taxable
/*N0CG*/                 so_taxc so_tax_date so_tax_pct so_trl1_amt
/*N0CG*/                 so_trl1_cd so_trl2_amt so_trl2_cd so_trl3_amt
/*N0CG*/                 so_trl3_cd so_userid so_weight_um)
/*N0CG*/          where recid(so_mstr) = so_recno no-lock:
/*N0CG*/       end. /* FOR FIRST SO_MSTR */

/*J0YH* /*J0M3*/            exclusive-lock no-error.    */
/*J0M3*/       if not available so_mstr then undo mainloop, leave mainloop.

/*J0YH* /*J0M3*/    end.  /* transaction */     */

/*M11Z*/ /* Removed old commented out block of code from J053 */

            /* During line-item entry/edit, the         */
            /* the printing of packing list is disabled */
            do transaction:
/*J0M3*J053*   find so_mstr where recid(so_mstr) = so_recno exclusive-lock. */
/*J0YH*/       find so_mstr where recid(so_mstr) = so_recno exclusive-lock.
               assign old_so_print_pl = so_print_pl
                      so_print_pl     = false.
/*J0M3*J053*   find so_mstr where recid(so_mstr) = so_recno no-lock.        */
            end. /* transaction */

            /* LINE ITEMS */
            /* SOSOMTA.P'S THIRD INPUT PARAMETER IS USED BY RMA'S ONLY.   */
            /* YES INDICATES THAT RMA ISSUE LINES ARE BEING PROCESSED.    */
            /* FOR RMA'S, WE'LL CALL SOSOMTA.P TWICE - FIRST FOR ISSUES   */
            /* THEN FOR RMA RECEIPT LINES.                                */

/*ADM1            {gprun.i ""sosomta.p""*/
/*ADM1*/    {gprun.i ""sosomtaxx.p""            
                "(input this-is-rma,
                    input rma-recno,
                    input yes)"}

            if this-is-rma then do:
            /* FOR RMA'S, WE CREATED OUR ISSUE LINES (THE PARTS WE'LL BE    */
            /* SENDING OUT TO CUSTOMERS).  NOW, CREATE THE RECEIPT LINES    */
            /* (THE PARTS THEY'RE RETURNING TO US).                         */
                {gprun.i ""sosomta.p""
                    "(input this-is-rma,
                      input rma-recno,
                      input no)"}
            end.    /* if this-is-rma */

/*J2D6*/     /* REPLACED BELOW BLOCK BY SOSOPRC.P */
/*J2D6** BEGIN DELETE **
 * /*J042*/    /*TEST FOR AT END OF ORDER PRICING OR REPRICING REQUIREMENTS
 *                AND SUBSEQUENT PROCESSING OF SUCH*/
 *          if new_order and not line_pricing then do:
 *              /*ALL LINES NEED TO BE PRICED, ENTERED PRICES WILL BE RETAINED*/
 *              for each sod_det where sod_nbr       = so_mstr.so_nbr
 * /*J0KJ*/                           and sod_fsm_type <> "RMA-RCT" no-lock:
 *                 sod_recno = recid(sod_det).
 *                 /*TRANSACTION HISTORY WILL BE REWRITTEN WITH REVISED PRICE*/
 *                 do transaction /*#6*/ on error undo, retry:
 *                    {gprun.i ""sosoprln.p"" "(input no,
 *                                              input yes,
 *                                              input yes,
 *                                              input yes,
 *                                              input yes,
 *                                              input no,
 * /*J12Q*/                                     input 0,
 * /*J12Q*/                                     input yes
 * /*J12Q*/                                     )"}
 * /*J12Q*                                         input 0)"}         */
 * /*J0M3*J053*          find so_mstr where recid(so_mstr) = so_recno      */
 * /*J0M3*J053*             exclusive-lock.                                */
 *                       so_priced_dt = today.
 * /*J0M3*J053*       find so_mstr where recid(so_mstr) = so_recno no-lock. */
 *                    end. /* DO TRANSACTION #6 */
 *                 end. /* FOR EACH SOD_DET WHERE..*/
 *             end. /* IF NEW_ORDER AND NOT LINE_PRICING */
 *
 *          if reprice or new_order then do:
 *              price_changed = no.
 *          /*CHECK REPRICE TABLE TO DETERMINE WHICH LINES REQUIRE REPRICING*/
 *              for each wrep_wkfl where wrep_parent and
 *                                       wrep_rep
 *                                 no-lock:
 *                 find sod_det where sod_nbr  = so_mstr.so_nbr and
 *                                    sod_line = wrep_line
 *
 * /*J0HR*/                        no-lock no-error.
 *                 if available sod_det then do:
 *                    sod_recno = recid(sod_det).
 *                    /*REVERSE OLD TRANSACTION HISTORY*/
 *                    do with frame bi on error undo, retry:
 *                       form sod_det with frame bi width 80.
 *                       {mfoutnul.i &stream_name = "bi"}
 *                       display stream bi sod_det with frame bi.
 *                       output stream bi close.
 *                    end. /* DO WITH FRAME BI */
 *                    do transaction /*#7*/ on error undo, retry:
 *                       {gprun.i ""sosoprln.p"" "(input yes,
 *                                                 input yes,
 *                                                 input yes,
 *                                                 input yes,
 *                                                 input no,
 *                                                 input no,
 * /*J12Q*/                                        input 0,
 * /*J12Q*/                                        input yes
 * /*J12Q*/                                        )"}
 * /*J12Q*                                         input 0)"}        */
 * /*J0M3*J053*          find so_mstr where recid(so_mstr) = so_recno        */
 * /*J0M3*J053*             exclusive-lock.                                  */
 *                          so_priced_dt = today.
 * /*J0M3*J053*          find so_mstr where recid(so_mstr) = so_recno no-lock.*/
 *                    end. /* DO TRANSACTION #7 */
 *                 end. /* IF AVAILABLE SOD_DET */
 *              end. /* FOR EACH WREP_WKFL */
 *
 *              if /*pic_so_redisp and*/ price_changed then do:
 *                 {gprun.i ""sophdp.p""} /*RE-DISPLAY LINE ITEMS*/
 *              end. /* IF PRICE_CHANGED */
 * /*J042*/    end. /* IF REPRICE OR NEW_ORDER */
 *J2D6** END DELETE   */

            /* Reprice after line item entry */
/*J2D6*/    {gprun.i ""sosoprc.p""  "(input so_recno,
                                      input reprice,
                                      input new_order,
                                      input line_pricing)" }

/*J042*/    /* SET CREDIT & FREIGHT TERMS FIELDS */
            do transaction:
/*J0M3*J053*   find so_mstr where recid(so_mstr) = so_recno exclusive-lock.  */
/*J12Q* /*J042*/       if current_cr_terms <> "" then   do: */
/*J12Q*/       if current_cr_terms <> "" and current_cr_terms <> so_cr_terms
/*J12Q*/       then do:
/*J12Q*/           cr_terms_changed = yes.
/*J042*/           so_cr_terms = current_cr_terms.
/*J12Q*/       end.
/*M0TZ** /*J042*/ if current_fr_terms <> "" then */
/*M0TZ*/       if current_fr_terms <> ""
/*N193** /*M0TZ*/ and so_fr_terms  =  "" */
/*N193*/          and so__qadl04 = no
/*M0TZ*/       then
/*J042*/           so_fr_terms = current_fr_terms.

/*J0HR*/        assign
/*J0HR*/           current_cr_terms = ""
/*J0HR*/          current_fr_terms = "".

               so_print_pl   =  old_so_print_pl.
/*J0M3*J053*   find so_mstr where recid(so_mstr) = so_recno no-lock.         */
            end.

            view frame a.
            display
               so_ship
            with frame a.

            /*OVERIDE CANADIAN TAX DEFAULTS*/
            if gl_can then do:
                {gprun.i ""sosoctax.p""}
            end.
            else if gl_vat then do:
                {gprun.i ""sosovtax.p""}
            end.

            do transaction on error undo, retry:
/*J0M3*J053*    find so_mstr where recid(so_mstr) = so_recno exclusive-lock. */
                /* INITIALIZE TRAILER CODES FROM CONTROL FILE FOR NEW ORDERS ONLY */
/*N0WB*/        {&SOSOMT1-P-TAG2}
                {gpgettrl.i &hdr_file="so" &ctrl_file="soc"}
/*N0WB*/        {&SOSOMT1-P-TAG3}
/*J0M3*J053*    find so_mstr where recid(so_mstr) = so_recno no-lock.        */

/*M0WC*/        /* FOR A VALID fr_list ENTERED IN SO HEADER, WHICH IS NOT A  */
/*M0WC*/        /* DEFAULT IN SALES ORDER CONTROL FILE, TRAILER CODE 1 IS    */
/*M0WC*/        /* UPDATED WITH TRAILER CODE OF THE FREIGHT LIST.            */
/*M0WC*/        if new_order
/*M0WC*/           and soc__qadl04
/*M0WC*/        then do:
/*M0WC*/           for first fr_mstr
/*M0WC*/              fields (fr_curr fr_list fr_site fr_trl_cd)
/*M0WC*/              where     fr_list = so_fr_list
/*M0WC*/                    and fr_site = so_site
/*M0WC*/                    and fr_curr = so_curr
/*M0WC*/              no-lock:
/*M0WC*/           end. /* FOR FIRST fr_mstr */

/*M0WC*/           if available fr_mstr
/*M0WC*/           then
/*M0WC*/              so_trl1_cd = fr_trl_cd.

/*M0WC*/        end. /* IF new-order and ... */

                /* CALCULATE FREIGHT */
/*K1BG** /*J25B*/ if calc_fr and so_fr_terms = "" then */
/*K1BG*/        if calc_fr and so_fr_terms = "" then do:
/*J25B*/           /* INVALID FREIGHT TERMS */
/*J25B*/           {mfmsg03.i 671 2 so_fr_terms """" """"}
/*K1BG*/        end. /* IF CALC_FR AND SO_FR_TERMS */

/*J1YG**        if calc_fr and so_fr_list <> "" */
/*J1YG*/        if calc_fr
                and so_fr_terms <> "" then do:
                    {gprun.i ""sofrcalc.p""}
                end.

            end.   /* TRANSACTION */

            /* TRAILER */
/*N0CG** /*J0JW*/    find bill_cm where bill_cm.cm_addr = so_bill no-lock. */
/*N0CG*/    for first bill_cm
/*N0CG*/       fields(cm_addr)
/*N0CG*/       where bill_cm.cm_addr = so_bill no-lock:
/*N0CG*/    end. /* FOR FIRST BILL_CM */

            cm_recno = recid(bill_cm).
/*J0JW  MOVED BELOW LINE ABOVE RECID FUNCTION
./*J053*/    find bill_cm where bill_cm.cm_addr = so_bill no-lock.
.*J0JW*/

/*J1P5**    {gprun.i ""sosomtc.p""} */
/*J1P5*/    {gprun.i ""xxsosomtc.p"" "(input this-is-rma)"}


/*K004*/ /* added next section */
            /* CHECK FOR A CHANGE TO THE CREDIT STATUS */
/*K01T* if soc_use_btb and not new_order and so_primary */
/*K01T*/    if soc_use_btb and so_primary
/*M11Z*/ /********************************
 *          and s-prev-so-stat <> so_stat then do:
 *
 * /*K0DH*        for each sod_det where sod_nbr = so_nbr no-lock:       */
 * /*K0DH*/       for each sod_det where sod_nbr = so_nbr and
 * /*K0DH*/               (sod_btb_type = "02" or sod_btb_type = "03")
 * /*K0DH*/       no-lock:
 *
 *                 /* TRANSMIT CHANGES ON PRIM. SO TO PO AND SEC. SO */
 * /*K0HB*           ADD input no before output return-msg */
 *                 {gprun.i ""sosobtb1.p""
 *                          "(input recid(sod_det),
 *                            input no,
 *                            input ""?"",
 *                            input ""?"",
 *                            input 0,
 *                            input ?,
 *                            input ?,
 *                            input ""so_stat"",
 *                            input no,
 *                            output return-msg)" }
 *
 *                 /* DISPLAY ERROR MESSAGE RETURN FROM SOSOBTB1.P */
 *                 if return-msg <> 0  then do:
 *                    {mfmsg.i return-msg 3}
 *                    return-msg = 0.
 *                    undo mainloop, retry mainloop.
 *                 end.
 *
 *              end.  /* FOR EACH SOD_DET */
 *******************/
/*M11Z*/    then do:
/*M11Z*/       {gprunp.i "soemttrg" "p" "process-order-header"
                  "(input new_order,
                    input so_nbr,
                    output return-msg)" }
/*M11Z*/       if return-msg <> 0 then do:
/*M11Z*/          {mfmsg.i return-msg 4}
/*M11Z*/          return-msg = 0.
/*M11Z*/          if not batchrun then pause.
/*M11Z*/          undo mainloop, retry mainloop.
/*M11Z*/       end. /* if return-msg <> 0 */
            end. /* Trigger EMT Purchase Order */

/*M11Z*/    {gpdelp.i "soemttrg" "p"}

            /* IF VENDOR IS AUTHORIZED TO RECEIVE PO THEN QUEUE PO'S     */
            /* FOR TRANSMISSION - In Multi EMT Change is allowed at both */
            /* The Primary and Secondardy (PBU and SBU)                  */
/*K0DH*     if so_primary then do:                                      */
/*K0HB*  /*K0DH*/    if not so_secondary then do:                       */
/*K0HB*/    if so_primary then do:

/*K01T*        for each wkf-btb where w-msg-type <> "" exclusive-lock */
/*K01T*/       for each wkf-btb where w-msg-type <> ""
               break by w-po-nbr by w-msg-type:

                  if first-of(w-po-nbr)
                  and not can-find(trq_mstr where trq_doc_type = "PO"
                                              and trq_doc_ref = w-po-nbr)
/*K01T*/          and can-find(po_mstr where po_nbr = w-po-nbr)
                  then do:

/*N0CG**          find ad_mstr where ad_addr = w-btb-vend no-lock no-error. */
/*N0CG**          find vd_mstr where vd_addr = w-btb-vend no-lock no-error. */

/*N0CG*/             for first ad_mstr
/*N0CG*/                fields(ad_addr ad_po_mthd)
/*N0CG*/                where ad_addr = w-btb-vend no-lock:
/*N0CG*/             end. /* FOR FIRST AD_MSTR */

/*N0CG*/             for first vd_mstr
/*N0CG*/                fields(vd_addr vd_rcv_held_so)
/*N0CG*/                where vd_addr = w-btb-vend no-lock:
/*N0CG*/             end. /* FOR FIRST VD_MSTR */

                     if     available ad_mstr
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

                        /* QUEUE DOCUMENT FOR TRANSMISSION - EMT */
                        {gprun.i ""gpquedoc.p""
                                 "(input-output doc-type,
                                   input-output doc-ref,
                                   input-output add-ref,
                                   input-output msg-type,
                                   input-output trq-id,
                                   input yes)"}.
                     end. /* AVAIL AD_MSTR AND ... AND AVAIL VD_MSTR AND ...*/
/*K0HB*/              delete wkf-btb.

                  end. /* IF FIRST-OF(W-PO-NBR) */

/*K0HB*           MOVE DELETE INSIDE LOOP ONLY DELETE AFTER CREATE TRIGGER   */
/*K0HB*           delete wkf-btb.        */

               end. /* EACH WKF-BTB WHERE W-MSG-TYPE <> "" */

            end.  /* IF SO_PRIMARY */

/*K0HB*     else do:  /* SECUNDARY SO */     */
/*K0HB*/    if so_secondary then do:

               find first wkf-btb where w-msg-type <> ""
               exclusive-lock no-error.

/*K0CZ*        if available wkf-btb and substring(so_inv_mthd,3 ,1) = "e"  */
/*K0CZ*/       if available wkf-btb
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

               end.  /* AVAIL WKF-BTB AND INVOICE METHOD = EDI */

               if available wkf-btb then delete wkf-btb.

            end. /* SECONDARY SO */
/*K004*/ /* end added section */


/*J1P5**    MOVED THE REDISPLAY OF RMA LINES AFTER VIEW IMPORT/EXPORT  **
 *
 *            if this-is-rma then do:
 *                {gprun.i ""fsrmamtu.p""
 *                    "(input rma-recno)"}
 *            end.
 *J1P5**/

/*N0WB*/    {&SOSOMT1-P-TAG4}
            /* IMPORT EXPORT FLAG IS SET TO YES CALL THE IMPORT EXPORT DETAIL */
            /* LINE MAINTENANCE PROGRAM FOR USER TO UPDATE ied_det            */

            if not batchrun and impexp then do:
                impexp_edit = no.
                {mfmsg01.i 271 1 impexp_edit} /* VIEW EDIT IMPORT EXPORT DATA ? */
                if impexp_edit then do:

/*J1P5**       ** WE DO NOT WANT TO USE "HIDE ALL" IN NON-TOP-LEVEL PROGRAMS **
 *                 hide all no-pause .
 *                 view frame dtitle.
 *                 view frame a.
 *J1P5**/

/*J1P5*/           hide frame sotot no-pause.
/*J1P5*/           hide frame sotrail no-pause.
/*J1P5*/           hide frame cttrail no-pause.
/*J1P5*/           hide frame d no-pause.

                    upd_okay = no.
                    {gprun.i ""iedmta.p""
                                "(input ""1"",
                                   input so_nbr,
                                   input-output upd_okay )" }
                end.

            end.    /* if not batchrun and impexp */

/*J1P5*/    if not this-is-rma then do:
/*J1P5*/       /* TRAILER FRAMES FOR RMA ARE HIDDED IN sosomtc.p */
/*J1P5*/       hide frame sotot no-pause.
/*J1P5*/       hide frame sotrail no-pause.
/*J1P5*/       hide frame cttrail no-pause.
/*J1P5*/       hide frame d no-pause.
/*J1P5*/    end. /* IF NOT THIS-IS-RMA */

            /* FOR RMA'S, THE ADDITIONAL TRAILER ROUTINE WILL OPTIONALLY   */
            /* REDISPLAY THE RMA LINES, AND ALLOWS THE USER TO SHIP AND    */
            /* RECEIVE RMA LINES FROM RMA MAINTENANCE.                     */

/*J1P5*/  /* MOVED THE REDISPLAY OF RMA LINES AFTER VIEW IMPORT/EXPORT  */
/*J1P5*/    if this-is-rma then do:
/*J1P5*/        {gprun.i ""fsrmamtu.p"" "(input rma-recno)"}
/*J1P5*/    end.

            global_type = comment_type.

            /*Adding batch checking for SO processing*/
/*N0CG**    find first sod_det where sod_nbr = so_nbr            */
/*N0CG**                and   not sod_confirm no-lock no-error.  */

/*N0CG*/    for first sod_det
/*N0CG*/       fields(sod_nbr sod_confirm)
/*N0CG*/       where sod_nbr = so_nbr and
/*N0CG*/             not sod_confirm no-lock:
/*N0CG*/    end. /* FOR FIRST SOD_DET */

            if batch_job and available sod_det then do:
                {gprun.i ""sobatch.p""
                   "(input so_nbr,
                     input-output batch_job,
                     input-output dev,
                     input-output batch_id)"}
            end.

         end. /* mainloop */

/*K1BN*/ if cfexists and cf_cfg_strt_err = no then do:
/*K1BN*/    /*close configurations*/
/*K1BN*//*V8!
/*K1BN*/    {gprunmo.i
               &module  = "cf"
               &program = "cfcfclos.p"
               &param   = """(input cf_cfg_path, input cf_chr,
                              cf_cfg_suf) """}
/*K1BN*/ */
/*K1BN*/    /*shut configurator*/
/*K1BN*//*V8!
/*K1BN*/    {gprunmo.i
               &module  = "cf"
               &program = "cfcfstop.p"}
/*K1BN*/ */
/*K1BN*/ end.

         status input.
