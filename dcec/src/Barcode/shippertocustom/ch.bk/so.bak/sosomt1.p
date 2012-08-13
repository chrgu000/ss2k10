/* GUI CONVERTED from sosomt1.p (converter v1.75) Sat May  5 08:31:07 2001 */
/* sosomt1.p - SALES ORDER MAINTENANCE                                  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
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
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00L* EvdGevel       */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan     */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan     */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* David Morris   */
/* REVISION: 9.0      LAST MODIFIED: 02/24/99   BY: *M094* Jean Miller    */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan     */
/* REVISION: 9.0      LAST MODIFIED: 06/14/00   BY: *L0Y4* Santosh Rao    */
/* REVISION: 9.0      LAST MODIFIED: 11/19/00   BY: *M0WC* Rajesh Thomas  */
/* REVISION: 9.0      LAST MODIFIED: 12/18/00   BY: *M0TZ* Veena Lad      */
/* REVISION: 9.0      LAST MODIFIED: 04/19/01   BY: *M11Z* Jean Miller    */

/*!
    Sosomt1.p performs the 'driver' function for Sales Order and RMA
    Maintenance.  These two functions were previously handled by sosomt.p
    and fsrmamt.p.  This program was originally copied from sosomt.p.
*/

         /* DISPLAY TITLE */
         {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sosomt1_p_1 "如果找到则删除"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomt1_p_2 "承诺日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomt1_p_3 "计算运费"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomt1_p_4 "分摊"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomt1_p_5 "已确认"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomt1_p_6 "说明"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomt1_p_7 "项目定价"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomt1_p_8 "重新定价"
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
         define new shared variable base_amt like ar_amt.
         define new shared variable sod_recno as recid.
         define new shared variable consume like sod_consume.
         define new shared variable prev_consume like sod_consume.
         define  new shared  variable confirm like mfc_logical
                  format "Y/N" initial yes label {&sosomt1_p_5}.
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

/*M017*/ /* TEMP TABLE DEFINITIONS FOR APM/API */
/*M017*/ {ifttcmdr.i "new"}
/*M017*/ {ifttcmdv.i "new"}

/*K004*/ {sobtbvar.i "new"}   /* BACK TO BACK SHARED WORKFILES AND VARIABLES */

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
/*K1BN*/    define new shared variable calicodone like mfc_logical.

         {gptxcdec.i}
/*L00L*/ {etdcrvar.i "new"}
/*L00L*/ {etvar.i &new="new"}
/*L00L*/ {etrpvar.i &new="new"}

/*L00L* /*J053*/ {mfsotrla.i "NEW"}              */
/*L00L*/ {etsotrla.i "NEW"}
/*J053*/ {sosomt01.i}


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

/*J042*/ FORM /*GUI*/  sod_det with frame bi width 80 THREE-D /*GUI*/.


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
/*J053*/ find first gl_ctrl no-lock.

/*J053*/ /* SET LIMIT_FMT ACCORDING TO BASE CURR ROUND METHOD*/
/*J053*/ limit_fmt = "->>>>,>>>,>>9.99".
/*J053*/ {gprun.i ""gpcurfmt.p"" "(input-output limit_fmt,
                                   input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J053*/ /* SET BALANCE_FMT ACCORDING TO BASE CURR ROUND METHOD*/
/*J053*/ balance_fmt = "->>>>,>>>,>>9.99".
/*J053*/ {gprun.i ""gpcurfmt.p"" "(input-output balance_fmt,
                                   input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         do transaction on error undo, retry:       /* TRANSACTION 10 */
            find first soc_ctrl no-lock no-error.
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
            find first mfc_ctrl where mfc_field = "soc_batch" no-lock no-error.
            if available mfc_ctrl then batch_job = mfc_logical.
            find first mfc_ctrl where mfc_field = "soc_print_id"
                             no-lock no-error.
            if available mfc_ctrl then dev = mfc_char.
            find first mfc_ctrl where mfc_field = "soc_batch_id"
                             no-lock no-error.
            if available mfc_ctrl then batch_id = mfc_char.

            /* FOR RMA'S, VALUES USUALLY OBTAINED FROM SOC_CTRL */
            /* COME FROM RMC_CTRL.  GET SVC_CTRL ALSO - IT'LL   */
            /* BE NEEDED LATER ON...                            */
            if this-is-rma then do:
                find first rmc_ctrl no-lock no-error.
                find first svc_ctrl no-lock no-error.
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

         do transaction on error undo, retry:       /* TRANSACTION 20 */

            /* SET UP PRICING BY LINE VALUES */
            find first mfc_ctrl where mfc_field = "soc_pc_line"
                no-lock no-error.
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
/*J042*/    find first pic_ctrl no-lock no-error.
/*J042*/    if not available pic_ctrl then
/*J042*/       create pic_ctrl.
/*J042*/ end.                                           /* TRANSACTION 25 */

/*K1BN*/ /* check for existance of configurator control record*/
/*K1BN*/ {gprun.i ""cfctrl.p"" "(""cf_w_mod"", output cfexists)"}
/*GUI*/ if global-beam-me-up then undo, leave.


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
/*K1BN*/       find mfc_ctrl where mfc_field = "cf_w_so_cfg" no-lock no-error.
/*K1BN*/       if available mfc_ctrl then cf_cfg_path = mfc_char.
/*K1BN*/    end.
/*K1BN*/    else do:
/*K1BN*/       cf_chr = "/".
/*K1BN*/       /*get the unix path of the concinity so files */
/*K1BN*/       find mfc_ctrl where mfc_field = "cf_u_so_cfg" no-lock no-error.
/*K1BN*/       if available mfc_ctrl then cf_cfg_path = mfc_char.
/*K1BN*/    end.

/*K1BN*/    /* validate that the path is accessible*/
/*K1BN*/    cf_cfg_strt_err = no.
/*K1BN*/    output to "cf_test.txt":U.
/*K1BN*/    display {&sosomt1_p_1}.
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
/*K1BN*/             find mfc_ctrl where mfc_field = "cf_w_exe" no-lock no-error.
/*K1BN*/             if available mfc_ctrl then cf_exe_loc = mfc_char.
/*K1BN*/             if cf_exe_loc ne "" and search(cf_exe_loc) ne ? then do:
/*K1BN*/                if err-stat eq 0 then do:
/*K1BN*/                   /* The conditions to run Concinity have been met */
/*K1BN*/                   cf_cfg_strt_err = no.
/*K1BN*/                   /* OK to start Concinity, get the default model*/
/*K1BN*/                   find mfc_ctrl where mfc_field = "cf_model"
/*K1BN*/                      no-lock no-error.
/*K1BN*/                   if available mfc_ctrl then cf_default_model = mfc_char.
/*K1BN*/                   /*launch calico*/
/*K1BN*/     
/*K1BN*/                   {gprunmo.i
                              &module  = "cf"
                              &program = "cfcfstrt.p"
                              &param   = """(cf_default_model) """
                              &persistent = ""persistent set phCfcfstrt""}
/*K1BN*/   
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
/*K1BN*/    find mfc_ctrl where mfc_field = "cf_so_suf" no-lock no-error.
/*K1BN*/    if available mfc_ctrl then cf_cfg_suf = mfc_char.
/*K1BN*/ end. /* if cf_exists... */

         mainloop:
         repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


/*J1P5*/ if not this-is-rma then do:
/*J1P5*/    /* TRAILER FRAMES FOR RMA ARE HIDDED IN sosomtc.p */
/*J1P5*/    hide frame sotot no-pause.
/*J1P5*/    hide frame sotrail no-pause.
/*J1P5*/    hide frame cttrail no-pause.
/*J1P5*/    hide frame d no-pause.
/*J1P5*/ end. /* IF NOT THIS-IS-RMA */

            find first mfc_ctrl where mfc_field = "soc_batch"
                no-lock no-error.
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
/*GUI*/ if global-beam-me-up then undo, leave.


/*J053*/       if return_int = 1 then next mainloop.
/*J053*/       if return_int = 2 then undo mainloop, next mainloop.
/*J053*/       if return_int = 3 then undo mainloop, retry mainloop.
/*J053*/       if return_int = 4 then undo mainloop, leave.

               /* FIND SO_MSTR NO-LOCK TO ENSURE THE USER DIDN'T DELETE */
               /* IT.  NO-LOCK ALSO PREVENTS WARNINGS RELATED TO THE    */
               /* OTHER EXPLICIT TRANSACTIONS IN THIS PROGRAM.          */
/*J0M3*/       find so_mstr where recid(so_mstr) = so_recno
/*J0YH*/       no-lock no-error.
/*J0YH* /*J0M3*/   exclusive-lock no-error.    */

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

            {gprun.i ""sosomta.p""
                "(input this-is-rma,
                    input rma-recno,
                    input yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            if this-is-rma then do:
            /* FOR RMA'S, WE CREATED OUR ISSUE LINES (THE PARTS WE'LL BE    */
            /* SENDING OUT TO CUSTOMERS).  NOW, CREATE THE RECEIPT LINES    */
            /* (THE PARTS THEY'RE RETURNING TO US).                         */
                {gprun.i ""sosomta.p""
                    "(input this-is-rma,
                      input rma-recno,
                      input no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

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
/*GUI*/ if global-beam-me-up then undo, leave.


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
/*M0TZ*/          and so_fr_terms  =  ""
/*M0TZ*/       then
/*J042*/          so_fr_terms = current_fr_terms.

/*J0HR*/        assign
/*J0HR*/           current_cr_terms = ""
/*J0HR*/          current_fr_terms = "".

               so_print_pl   =  old_so_print_pl.
/*J0M3*J053*   find so_mstr where recid(so_mstr) = so_recno no-lock.         */
            end. /* do transaction */

            view frame a.
            display
               so_ship
            with frame a.

            /*OVERIDE CANADIAN TAX DEFAULTS*/
            if gl_can then do:
                {gprun.i ""sosoctax.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.
            else if gl_vat then do:
                {gprun.i ""sosovtax.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.

            do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

/*J0M3*J053*    find so_mstr where recid(so_mstr) = so_recno exclusive-lock. */
                /* INITIALIZE TRAILER CODES FROM CONTROL FILE FOR NEW ORDERS ONLY */
                {gpgettrl.i &hdr_file="so" &ctrl_file="soc"}
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

/*M0WC*/        end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF new-order and ... */

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
/*GUI*/ if global-beam-me-up then undo, leave.

                end.

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
   /* TRANSACTION */

            /* TRAILER */
/*J0JW*/    find bill_cm where bill_cm.cm_addr = so_bill no-lock.
            cm_recno = recid(bill_cm).
/*J0JW  MOVED BELOW LINE ABOVE RECID FUNCTION
./*J053*/    find bill_cm where bill_cm.cm_addr = so_bill no-lock.
.*J0JW*/

/*J1P5**    {gprun.i ""sosomtc.p""} */
/*J1P5*/    {gprun.i ""sosomtc.p"" "(input this-is-rma)"}
/*GUI*/ if global-beam-me-up then undo, leave.



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
/*GUI*/ if global-beam-me-up then undo, leave.


                  if first-of(w-po-nbr)
                  and not can-find(trq_mstr where trq_doc_type = "PO"
                                              and trq_doc_ref = w-po-nbr)
/*K01T*/          and can-find(po_mstr where po_nbr = w-po-nbr)
                  then do:

                     find ad_mstr where ad_addr = w-btb-vend no-lock no-error.
                     find vd_mstr where vd_addr = w-btb-vend no-lock no-error.
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
                                   input yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     end. /* AVAIL AD_MSTR AND ... AND AVAIL VD_MSTR AND ...*/
/*K0HB*/              delete wkf-btb.

                  end. /* IF FIRST-OF(W-PO-NBR) */

/*K0HB*           MOVE DELETE INSIDE LOOP ONLY DELETE AFTER CREATE TRIGGER   */
/*K0HB*           delete wkf-btb.        */

               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* EACH WKF-BTB WHERE W-MSG-TYPE <> "" */

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
/*GUI*/ if global-beam-me-up then undo, leave.


               end.  /* AVAIL WKF-BTB AND INVOICE METHOD = EDI */

               if available wkf-btb then delete wkf-btb.

            end. /* SECONDARY SO */

/*J1P5**    MOVED THE REDISPLAY OF RMA LINES AFTER VIEW IMPORT/EXPORT  **
 *
 *            if this-is-rma then do:
 *                {gprun.i ""fsrmamtu.p""
 *                    "(input rma-recno)"}
 *            end.
 *J1P5**/

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
/*GUI*/ if global-beam-me-up then undo, leave.

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
/*GUI*/ if global-beam-me-up then undo, leave.

/*J1P5*/    end.

            global_type = comment_type.

            /*Adding batch checking for SO processing*/
            find first sod_det where sod_nbr = so_nbr
                        and   not sod_confirm no-lock no-error.
            if batch_job and available sod_det then do:
                {gprun.i ""sobatch.p""
                   "(input so_nbr,
                     input-output batch_job,
                     input-output dev,
                     input-output batch_id)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.

         end. /* mainloop */

/*K1BN*/ if cfexists and cf_cfg_strt_err = no then do:
/*K1BN*/    /*close configurations*/
/*K1BN*/     
/*K1BN*/    {gprunmo.i
               &module  = "cf"
               &program = "cfcfclos.p"
               &param   = """(input cf_cfg_path, input cf_chr,
                              cf_cfg_suf) """}
/*K1BN*/   
/*K1BN*/    /*shut configurator*/
/*K1BN*/     
/*K1BN*/    {gprunmo.i
               &module  = "cf"
               &program = "cfcfstop.p"}
/*K1BN*/   
/*K1BN*/ end.

         status input.
