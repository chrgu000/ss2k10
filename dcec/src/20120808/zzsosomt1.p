/* GUI CONVERTED from sosomt1.p (converter v1.69) Wed Sep 17 13:28:33 1997 */
/* sosomt1.p - SALES ORDER MAINTENANCE                                  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 8.5      LAST MODIFIED: 08/25/95   BY: *J04C* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: *J034* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: *J042* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: *J053* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 04/17/96   BY: *J0HR* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 04/26/96   BY: *J0KJ* DAH          */
/* REVISION: 8.5      LAST MODIFIED: 05/14/96   BY: *J0M3* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 07/10/96   BY: *J0YH* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: *J12Q* Andy Wasilczuk*/
/* REVISION: 8.5      LAST MODIFIED: 05/07/97   BY: *J1P5* Ajit Deodhar */
/* REVISION: 8.5      LAST MODIFIED: 08/06/97   BY: *J1YG* Seema Varma  */
/* REVISION: 8.5      LAST MODIFIED: 05/22/97   BY: *J1RY* Tim Hinds    */
/* REVISION: 8.5      LAST MODIFIED: 09/16/97   BY: *J20Z* Cindy Votro  */
/* REVISION: 8.5      LAST MODIFIED: 11/17/03   BY: *LB01* Long Bo         */

/*!
    Sosomt1.p performs the 'driver' function for Sales Order and RMA
    Maintenance.  These two functions were previously handled by sosomt.p
    and fsrmamt.p.  This program was originally copied from sosomt.p.
*/

         /* DISPLAY TITLE */
         {mfdeclre.i}

         define input parameter         this-is-rma     like mfc_logical.

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
         define new shared  variable socmmts like soc_hcmmts label "说明".
         define new shared variable prev_abnormal like sod_abnormal.
         define new shared variable promise_date as date label "承诺日期".
         define new shared variable base_amt like ar_amt.
         define new shared variable sod_recno as recid.
         define new shared variable consume like sod_consume.
         define new shared variable prev_consume like sod_consume.
         define  new shared  variable confirm like mfc_logical
                  format "Y/N" initial yes label "已确认".
         define new shared variable sotrcust like so_cust.
         define new shared variable merror like mfc_logical initial no.
         define new shared variable so-detail-all like soc_det_all.
         define new shared variable new_order like mfc_logical initial no.
         define new shared variable sotax_trl like tax_trl.
         define new shared variable tax_in like cm_tax_in.
         define new shared variable rebook_lines like mfc_logical initial no no-undo.
         define new shared variable avail_calc as integer.
         define new shared variable so_db like dc_name.
         define new shared variable inv_db like dc_name.
         define new shared variable mult_slspsn like mfc_logical no-undo.
/*J042**
.         define new shared variable qo_recno as recid.
.         define new shared variable qod_recno as recid.
.         define new shared variable qoc_pt_req like mfc_logical.
**J042*/
         define new shared variable undo_cust like mfc_logical.
         define new shared variable freight_ok like mfc_logical initial yes.
         define new shared variable old_ft_type like ft_type.
         define new shared variable calc_fr like mfc_logical
                                            label "计算运费".
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
                                                 label "项目定价".
/*J042*/ define new shared variable reprice like mfc_logical label "重新定价"
                                            initial no.
/*J053*/ define new shared variable rndmthd like rnd_rnd_mthd.
/*J053*/ define new shared variable oldcurr like so_curr.
/*J053*/ define new shared variable balance_fmt as character.
/*J053*/ define new shared variable limit_fmt as character.
/*J053*/ define new shared variable prepaid_fmt as character no-undo.
/*J053*/ define new shared variable prepaid_old as character no-undo.

/*LB01*/ define new shared variable sotrnbr like so_nbr.     
         define variable yn like mfc_logical initial yes.
/*J053*  define variable i as integer.          */
         define variable comment_type like so_lang.
/*LB01   define variable sotrnbr like so_nbr. */
/*J053*  define variable counter as integer no-undo.    */
         define variable sort as character format "x(28)" extent 4 no-undo.
         define variable keylist as character
                initial "RETURN,TAB,BACK-TAB,GO,13,9,509,245,513,301,248" no-undo.
         define variable old_so_print_pl like so_print_pl no-undo.
         define variable alloc   like mfc_logical label "分摊".
         define variable impexp_edit like mfc_logical no-undo.
         define variable upd_okay    like mfc_logical no-undo.
         define variable batch_job   like mfc_logical.
         define variable dev         as character.
         define variable batch_id    as character.
/*J053*  define variable in_batch_proces like mfc_logical.    */

         /* RMA-SPECIFIC VARIABLES */
         define            variable msgref      as character format "x(20)".
         define            variable rma-recno   as recid.
         define            variable call-number like rma_ca_nbr initial " ".
         define            variable eutype      like eu_type.

         /* RECORD BUFFERS */
         define            buffer   bill_cm     for  cm_mstr.
         define            buffer   rmdbuff     for  rmd_det.

         /* SHARED STREAMS AND FRAMES */
/*J042*/ define new shared stream bi.
         define new shared frame a.
/*J053*  ** THESE FRAMES WERE MOVED TO SOSOMTA1.P ***********************
.        define new shared frame sold_to.
.        define new shared frame ship_to.
.        define new shared frame b.
.*J053 END***************************************************************/
/*J042*/ define new shared frame bi.

/*J1P5*/ /* MOVED UP THE TRAILER FRAMES DEFINITION FROM sosomtc.p */
/*J1P5*/  define new shared frame sotot.
/*J1P5*/  define new shared frame d.

/*J042*  {gpfowfop.i "new"}   /* work3_list SHARED WORKFILE AND VARIABLES */   */
/*J042*/ {pppivar.i "new"}  /* PRICING VARIABLES */

/*J1RY*/ define new shared variable cfexists like mfc_logical.
/*J1RY*/ define new shared variable cf_cfg_path like mfc_char.
/*J1RY*/ define new shared variable cf_cfg_suf  like mfc_char.
/*J1RY*/ define new shared variable cf_chr   as character.
/*J1RY*/ define new shared variable cf_cfg_strt_err  like mfc_logical.
/*J1RY*/ define variable cf_default_model as character.
/*J1RY*/ define variable cf_exe_loc as character.
/*J1RY*/ define new shared variable phCfcfstrt as handle no-undo.
/*J1RY*/ define variable err-stat as integer.
/*J1RY*/ define variable checkwritepath as character.
/*J1RY*/ define variable testfile as character.

         {gptxcdec.i}
/*J053*/ {mfsotrla.i "NEW"}
/*J053*/ {sosomt01.i}

/*J042*/ FORM /*GUI*/ 
/*J042*/    sod_qty_ord                format "->>>>,>>9.9<<<<"
/*J042*/    sod_list_pr                format ">>>,>>>,>>9.99<<<"
/*J042*/    sod_disc_pct label "折扣%" format "->>>>9.99"
/*J042*/ with frame bi width 80 THREE-D /*GUI*/.


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
                assign socmmts  = rmc_hcmmts
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
            if soc_on_ord then avail_calc = 2.
            else avail_calc = 1.
         end.
         else if soc_req then do:
            if soc_on_ord then avail_calc = 4.
            else avail_calc = 3.
         end.

/*J053*  find first gl_ctrl no-lock.    */
         so_db = global_db.

/*J042*/ do transaction on error undo, retry:           /* TRANSACTION 25 */
/*J042*/    find first pic_ctrl no-lock no-error.
/*J042*/    if not available pic_ctrl then
/*J042*/       create pic_ctrl.
/*J042*/ end.                                           /* TRANSACTION 25 */

/*J1RY*/ /* check for existance of configurator control record*/
/*J1RY*/ {gprun.i ""cfctrl.p"" "(""cf_w_mod"", output cfexists)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J1RY*/ if cfexists and this-is-rma then
/*J1RY*/    cfexists = no.
/*J1RY*/ if cfexists then do:
/*J1RY*/    /* Determine Unix or Windows path format based on user O/S */
/*J1RY*/    /* For Windows users, 'opsys' responds with 'msdos' */
/*J1RY*/    /* on Pro 8.1 and 'WIN32' on Progress 8.2  */
/*J1RY*/    /* (Progress 8.2 is 32-bit only - Win95 and NT) */
/*J1RY*/    /* Even a Unix user can delete an order and must have access to */
/*J1RY*/    /* the configuration files so that these are deleted with the */
/*J1RY*/    /* order lines.                                                */
/*J1RY*/    if opsys = "msdos":U or opsys = "WIN32":U then do:
/*J1RY*/       cf_chr = "~\".
/*J1RY*/       /*get the Windows path of the sales order configuration files*/
/*J1RY*/       find mfc_ctrl where mfc_field = "cf_w_so_cfg" no-lock no-error.
/*J1RY*/       if available mfc_ctrl then cf_cfg_path = mfc_char.
/*J1RY*/    end.
/*J1RY*/    else do:
/*J1RY*/       cf_chr = "/".
/*J1RY*/       /*get the unix path of the concinity so files */
/*J1RY*/       find mfc_ctrl where mfc_field = "cf_u_so_cfg" no-lock no-error.
/*J1RY*/       if available mfc_ctrl then cf_cfg_path = mfc_char.
/*J1RY*/    end.

/*J1RY*/    /* validate that the path is accessible*/
/*J1RY*/    cf_cfg_strt_err = no.
/*J1RY*/    output to "cf_test.txt":U.
/*J1RY*/    display "如果找到则删除".
/*J1RY*/    output close.
/*J1RY*/    checkwritepath = cf_cfg_path + cf_chr + "cf_test.txt":U.
/*J1RY*/    testfile = search("cf_test.txt").
/*J1RY*/    if testfile <> ? then do:
/*J1RY*/      os-copy value(testfile) value(checkwritepath).
/*J1RY*/      err-stat = os-error.
/*J1RY*/      if err-stat = 0 then do:
/*J1RY*/         os-delete value(checkwritepath).
/*J1RY*/         err-stat = os-error.
/*J1RY*/      end.
/*J1RY*/      else err-stat = 1.
/*J1RY*/    end.
/*J1RY*/    else err-stat = 1.
/*J1RY*/    if err-stat <> 0 then do:
/*J1RY*/      {mfmsg.i 2003 4}
/*J1RY*/      /* Configuration file directory is inaccessable */
/*J1RY*/      cf_cfg_strt_err = yes.
/*J1RY*/    end.

/*J1RY*/    /*Determine if the user is able to run Concinity:  running */
/*J1RY*/    /*Progress 8.2+, running on Win95 or NT, and access to the */
/*J1RY*/    /*Concinity executable. */
/*J1RY*/    if cf_cfg_strt_err = no then do:
/*J1RY*/       cf_cfg_strt_err = yes.
/*J1RY*/       if substring(proversion,1,1) = "8" and
/*J1RY*/          substring(proversion,3,1) >= "2" then do:
/*J1RY*/          if opsys = "WIN32":U then do:
/*J1RY*/             /*get the location of Concinity executable*/
/*J1RY*/             find mfc_ctrl where mfc_field = "cf_w_exe" no-lock no-error.
/*J1RY*/             if available mfc_ctrl then cf_exe_loc = mfc_char.
/*J1RY*/             if cf_exe_loc <> "" and search(cf_exe_loc) <> ? then do:
/*J1RY*/                if err-stat = 0 then do:
/*J1RY*/                   /* The conditions to run Concinity have been met */
/*J1RY*/                   cf_cfg_strt_err = no.
/*J1RY*/                   /* OK to start Concinity, get the default model*/
/*J1RY*/                   find mfc_ctrl where mfc_field = "cf_model"
/*J1RY*/                      no-lock no-error.
/*J1RY*/                   if available mfc_ctrl then cf_default_model = mfc_char.
/*J1RY*/                   /*launch calico*/
/*J20Z*/     
/*J1RY*/                   {gprunmo.i
                              &module  = "cf"
                              &program = "cfcfstrt.p"
                              &param   = """(cf_default_model)"""
                              &persistent = ""persistent set phCfcfstrt""
                           }
/*J20Z*/   
/*J1RY*/                   if cf_cfg_strt_err then do:
/*J1RY*/                      /* An error was discovered in trying to start Concinity */
/*J1RY*/                      {mfmsg.i 1829 4}
/*J1RY*/                      /* Concinity is unavailable */
/*J1RY*/                      delete procedure phCfcfstrt no-error.
/*J1RY*/                   end.
/*J1RY*/                end. /* if err-stat... */
/*J1RY*/             end. /* if cf_exe_loc... */
/*J1RY*/          end. /* if opsys... */
/*J1RY*/       end. /* if proversion... */
/*J1RY*/    end. /* if cf_cfg_strt_err... */
/*J1RY*/    /* The cf_cfg_strt_err variable is used throughout the process to */
/*J1RY*/    /* determine if Concinity is running. (no = no error,it's running)*/

/*J1RY*/    /*get the sales order suffix from the control file*/
/*J1RY*/    find mfc_ctrl where mfc_field = "cf_so_suf" no-lock no-error.
/*J1RY*/    if available mfc_ctrl then cf_cfg_suf = mfc_char.
/*J1RY*/ end. /* if cf_exists... */

         mainloop: repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


/*J1P5*/ if not this-is-rma then do:
/*J1P5*/ /* TRAILER FRAMES FOR RMA ARE HIDDED IN sosomtc.p */
/*J1P5*/    hide frame sotot no-pause.
/*J1P5*/    hide frame sotrail no-pause.
/*J1P5*/    hide frame cttrail no-pause.
/*J1P5*/    hide frame d no-pause.
/*J1P5*/ end. /* IF NOT THIS-IS-RMA */

            find first mfc_ctrl where mfc_field = "soc_batch"
                no-lock no-error.
            if available mfc_ctrl then batch_job = mfc_logical.

/*LB01**J053*/ {zzsosomt02.i}  /* FORM DEFINITIONS FOR SHARED FRAMES A AND B */
/*J0KJ** /*J053*/    view frame dtitle. */
/*J0KJ** /*J053*/    view frame a.      */

/*J12Q*/    cr_terms_changed = no.

/*J0YH*/ /* IF AN EXPLICIT TRANSACTION SURROUNDS THIS, SOC_CTRL */
         /* IS LOCKED FOR THE DURATION OF SO HEADER PROCESSING  */
/*J0YH* /*J0M3*/    do transaction on error undo, retry:    */

/*J053*/       /* PROCESS SALES ORDER HEADER FRAMES */
/*J04C*        ADDED THIS-IS-RMA INPUT PARM, AND RMA-RECNO OUTPUT */
/*LB01*/       {gprun.i ""zzsosomta1.p"" "(input this-is-rma,
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
/*J0YH*/            no-lock no-error.

/*J0YH* /*J0M3*/            exclusive-lock no-error.    */
/*J0M3*/       if not available so_mstr then undo mainloop, leave mainloop.

/*J0YH* /*J0M3*/    end.  /* transaction */     */

/*J053******** SPLIT OUT ORDER HEADER INPUT FRAME PROCESSING TO SOSOMTA1.P **
.            do transaction on error undo, retry:        /* TRANSACTION 30 */
.
.                /*V8!
.                    hide all no-pause.
.                    if global-tool-bar and global-tool-bar-handle <> ? then
.                    view global-tool-bar-handle.
.                */
.
.                if this-is-rma then
.                    find first rmc_ctrl no-lock.
.                else do:
.                    find first soc_ctrl no-lock.
.                    socmmts = soc_hcmmts.
.                end.
.
.                {sosomt02.i}  /* Form definitions for shared frames a and b */
.
.                {mfadform.i "sold_to" 1 " Sold-To "}
.                {mfadform.i "ship_to" 41 " Ship-To "}
.
.                view frame dtitle.
.                view frame a.
.                view frame sold_to.
.                view frame ship_to.
.                view frame b.
.
.                prompt-for so_nbr with frame a editing:
.
.                   if keyfunction(lastkey) = "RECALL" or lastkey = 307
.                   then display sonbr @ so_nbr with frame a.
.                    /* IF WE'RE MAINTAINING RMA'S, NEXT/PREV ON RMA'S, */
.                    /* ELSE, NEXT/PREV ON SALES ORDERS.                */
.                    if this-is-rma then do:
.                        {mfnp05.i
.                        so_mstr
.                        so_fsm_type
.                        "so_fsm_type = ""RMA"" "
.                        so_nbr
.                        "input so_nbr"}
.                    end.
.                    else do:
.                        {mfnp05.i
.                        so_mstr
.                        so_fsm_type
.                        "so_fsm_type = "" "" "
.                        so_nbr
.                        "input so_nbr"}
.                    end.
.
.                   if recno <> ? then do with frame b:
.                       {mfaddisp.i so_cust sold_to}
.                       {mfaddisp.i so_ship ship_to}
.                       display so_nbr so_cust so_bill so_ship with frame a.
.                       find first sod_det where sod_nbr = so_nbr
.                           no-lock no-error.
.                       if available sod_det and sod_per_date <> ?
.                       then promise_date = sod_per_date.
.                       else promise_date = ?.
.                       if so_conf_date = ?
.                       then confirm = no.
.                       else confirm = yes.
.
.                       if so_slspsn[2] <> "" or
.                          so_slspsn[3] <> "" or
.                          so_slspsn[4] <> ""
.                       then mult_slspsn = true.
.                       else mult_slspsn = false.
.
.                       {sosomtdi.i} /* display so_ord_date, etc in frame b */
.                   end.    /* if recno <> ? */
.                end.    /* prompt-for so_nbr editing */
.
.                if input so_nbr = "" then do:
.                    if this-is-rma then do:
.                    /* GET NEXT RMA NUMBER WITH PREFIX */
.                       {fsnctrl2.i rmc_ctrl
.                          rmc_so_nbr
.                          so_mstr
.                          so_nbr
.                          sonbr
.                          rmc_so_pre
.                          rma_mstr
.                          rma_prefix
.                          ""C""
.                          rma_nbr}
.                       find first rmc_ctrl no-lock.
.                    end.   /* if this-is-rma */
.                    else do:
.                        /* GET NEXT SALES ORDER NUMBER WITH PREFIX */
.                        {mfnctrlc.i soc_ctrl soc_so_pre soc_so
.                            so_mstr so_nbr sonbr}
.                    end.   /* else, this is SO */
.                end.    /* if input so_nbr = "" */
.                else  /* TAKE SONBR AS ENTERED BY USER */
.                   sonbr = input so_nbr.
.
.            end.                                    /* TRANSACTION 30 */
.
.            do transaction on error undo, retry:    /* TRANSACTION 40 */
.
.                old_ft_type = "".
.                find so_mstr where so_nbr = sonbr exclusive-lock no-error.
.                if not available so_mstr then do:
.                   if this-is-rma and not available rmc_ctrl then
.                        find first rmc_ctrl no-lock no-error.
.                   find first soc_ctrl no-lock.
.                   clear frame sold_to.
.                   clear frame ship_to.
.                   clear frame b.
.                   {mfmsg.i 1 1}
.
.                   create so_mstr.
.                   assign
.                      new_order = yes
.                      so_nbr       = sonbr
.                      so_ord_date  = today
.                      so_req_date  = today
.                      so_due_date  = today + soc_shp_lead
.                      so_print_so  = soc_print
.                      so_fob       = soc_fob
.                      confirm      = soc_confirm
.                     /* set so_print_pl so it does not print while it is  */
.                     /* being created. It is reset to yes in sosomtc.p     */
.                      so_print_pl  = no
.                      socmmts      = soc_hcmmts .
.
.                   /* FOR RMA'S, HEADER INFORMATION IS ALSO    */
.                   /*  STORED IN RMA_MSTR */
.                   if this-is-rma then do:
.                        create rma_mstr.
.                        assign rma_nbr   = sonbr
.                                rma_ord_date = today
.                                rma_req_date = today
.                                rma_exp_date = so_due_date
.                                rma_prt_rec = so_print_so
.                                rma_prefix = "C"
.                                socmmts = rmc_hcmmts
.                                confirm = yes
.                                so_fsm_type = "RMA".
.                       if recid(rma_mstr) = -1 then .
.                    end.    /* if this-is-rma */
.                end.  /* if not available so_mstr */
.
.                else do:
.                   {mfmsg.i 10 1}
.
.                   /* THIS PROGRAM MAINTAINS RMA'S AND SALES ORDERS ONLY */
.                   /* SO ORDERS RELATED TO SC'S (SERVICE CONTRACTS) AND  */
.                   /* SEO'S (SERVICE ENGINEER ORDERS) SHOULD GET ERRORS  */
.                   if so_fsm_type <> ""
.                      and so_fsm_type <> "RMA" then do:
.                     if so_fsm_type = "SC"
.                     then msgref = "Service Contract".
.                     else
.                        if so_fsm_type = "SEO"
.                        then msgref = "Service Engineer Order".
.                        else msgref = "Service Invoice".
.                        {mfmsg03.i 7326 3  msgref """" """"}
.                        /* THIS IS A # CANNOT PROCESS */
.                        undo mainloop, retry mainloop.
.                   end.     /* if so_fsm_type <> "" */
.
.                   if so_fsm_type = "RMA" then
.                        if this-is-rma then do:
.                            find rma_mstr where rma_nbr = so_nbr
.                              and rma_prefix = "C" no-lock no-error.
.                            rma-recno = recid(rma_mstr).
.                        end.
.                        else do:
.                            msgref = "RMA".
.                            {mfmsg.i 7326 3 msgref """" """"}
.                            undo mainloop, retry mainloop.
.                        end.
.
.                   /* CHECK FOR BATCH SHIPMENT RECORD */
.                   in_batch_proces = no.
.                   {sosrchk.i so_nbr in_batch_proces}
.                   if in_batch_proces
.                   then undo mainloop, retry mainloop.
.
.                   {mfaddisp.i so_cust sold_to}
.                   if not available ad_mstr then do:
.                       hide message no-pause.
.                       {mfmsg.i 3 2}
.                       /* NOT A VALID CUSTOMER */
.                   end.
.
.                   {mfaddisp.i so_ship ship_to}
.
.                   if so_conf_date = ?
.                   then confirm = no.
.                   else confirm = yes.
.                   new_order = no.
.                   find ft_mstr where ft_terms = so_fr_terms
.                        no-lock no-error.
.                   if available ft_mstr
.                   then old_ft_type = ft_type.
.
.                   if so_sched then do:
.                        {mfmsg.i 8210 2}
.                        /* ORDER WAS CREATED BY SCHEDULED ORDER MAINT */
.                   end.
.                end.  /* else, available so_mstr, do: */
.
.                if this-is-rma then
.                    assign so-detail-all = rmc_det_all.
.                else
.                    assign
.                        so-detail-all = soc_det_all
.                        recno         = recid(so_mstr).
.
.                /* CHECK FOR COMMENTS*/
.                if so_cmtindx <> 0 then socmmts = yes.
.
.                display  so_nbr so_cust so_bill so_ship
.                with frame a.
.
.                assign
.                    sotrnbr = so_nbr
.                    sotrcust = so_cust.
.
.                find first sod_det where sod_nbr = so_nbr
.                    no-lock no-error.
.                if available sod_det and sod_per_date <> ?
.                then promise_date = sod_per_date.
.                else promise_date = ?.
.
.
.                if so_slspsn[2] <> "" or
.                   so_slspsn[3] <> "" or
.                   so_slspsn[4] <> "" then mult_slspsn = true.
.                else mult_slspsn = false.
.
.                {sosomtdi.i} /* display so_ord_date, etc in frame b */
.
.                /* FOR RMA'S, THE USER MAY OPTIONALLY ATTACH A CALL */
.                /* NUMBER TO THE ORDER.  CALL FSRMACA.P TO GET THAT */
.                /* CALL NUMBER, AND, IF ENTERED, DEFAULT RELEVANT   */
.                /* CALL FIELDS TO THE RMA BEING CREATED.            */
.                if this-is-rma and new_order then do on error undo, retry:
.                    display so_nbr with frame a.
.                    {gprun.i ""fsrmaca.p""
.                         "(input  recid(rma_mstr),
.                            input  recid(so_mstr),
.                            output call-number)"}
.                    if call-number = "?" then undo, retry.
.                    assign so-detail-all = rmc_det_all.
.                    display so_ship
.                        so_bill
.                        so_cust
.                    with frame a.
.                    display so_po
.                    with frame b.
.                end.    /* if this-is-rma and... */
.
.                /* GET SOLD-TO, BILL-TO, SHIP-TO ADDRESSES */
.                /* FOR RMA'S, ALSO GET THE END USER        */
.                so_recno = recid(so_mstr).
.                undo_cust = true.
.                {gprun.i ""sosomtcm.p""
.                    "(input this-is-rma,
.                        input recid(rma_mstr),
.                        input new_order)"}
.                if undo_cust then undo mainloop, retry.
.
.                /* WHEN CREATING A NEW RMA, SOSOMTCM.P LOADS IN THE DEFAULT    */
.                /* END USER (THE CUSTOMER), AND ALLOWS THE USER TO CHANGE IT.  */
.                /* IF HE F4-ED OUT OF SOSOMTCM.P, THEN, RMA_ENDUSER GETS       */
.                /* UNDONE AND LEFT BLANK, SO, FIX IT HERE...                   */
.                 if this-is-rma and new_order then do:
.                    if rma_enduser = "" then
.                        assign rma_enduser = so_cust
.                               rma_cust_ven = so_cust.
.                    find eu_mstr where eu_addr = rma_enduser
.                        no-lock no-error.
.                    /* IF USER DIDN'T ATTACH A CALL TO THIS RMA */
.                    /* (AND DEFAULT SOME OF THE CALL FIELDS     */
.                    /* INTO THIS NEW ORDER), THEN OPTIONALLY    */
.                    /* DISPLAY SERVICE CONTRACTS FOR THIS END   */
.                    /* USER.                                    */
.                    if call-number = " " then do:
.                           {gprun.i ""fsrmasv.p""
.                                "(input      rma_enduser,
.                                  input        eu_type,
.                                  input        rmc_swsa,
.                                  input-output rma_contract,
.                                  input-output rma_ctype,
.                                  input-output rma_crprlist,
.                                  input-output rma_pr_list,
.                                  input-output rma_rstk_pct)"}
.                    end.    /* if call-number = " " */
.                end.    /* if this-is-rma and new_order */
.
.                find cm_mstr where cm_mstr.cm_addr = so_cust no-lock.
.                find bill_cm where bill_cm.cm_addr = so_bill no-lock.
.                find ad_mstr where ad_addr = so_bill no-lock.
.                if ad_inv_mthd = "" then do:
.                    find ad_mstr where ad_addr = so_ship  no-lock.
.                    if ad_inv_mthd = "" then
.                       find ad_mstr where ad_addr = so_cust  no-lock.
.                end.
.                if new_order then so_inv_mthd = ad_inv_mthd.
.                if new_order then
.                    substr(so_inv_mthd,3,1) = substr(ad_edi_ctrl[5],1,1).
.
.                order-header:
.                do on error undo, retry with frame b:
.
.                   ststatus = stline[2].
.                   status input ststatus.
.                   del-yn = no.
.
.                   /* SET DEFAULTS WHEN CREATING A NEW ORDER - */
.                   /* USE SHIP-TO CUSTOMER INFO FOR DEFAULT IF */
.                   /* AVAILABLE ELSE USE SOLD-TO INFO          */
.                   if new so_mstr then do:
.                       if so_cust <> so_ship and
.                       can-find(cm_mstr where cm_mstr.cm_addr = so_ship) then
.                           find cm_mstr where cm_mstr.cm_addr = so_ship no-lock.
.                       assign
.                           so_cr_terms = bill_cm.cm_cr_terms
.                           so_curr     = bill_cm.cm_curr
.                           so_pr_list  = cm_mstr.cm_pr_list
.                           so_pr_list2 = cm_mstr.cm_pr_list2
.                           so_fix_pr   = cm_mstr.cm_fix_pr
.                           so_disc_pct = cm_mstr.cm_disc_pct
.                           so_shipvia  = cm_mstr.cm_shipvia
.                           so_partial  = cm_mstr.cm_partial
.                           so_rmks     = cm_mstr.cm_rmks
.                           so_site     = cm_mstr.cm_site
.                           so_taxable  = cm_mstr.cm_taxable
.                           so_taxc     = cm_mstr.cm_taxc
.                           so_pst      = cm_mstr.cm_pst
.                           so_fst_id   = cm_mstr.cm_fst_id
.                           so_pst_id   = ad_pst_id   /*ship-to*/
.                           so_fr_list   = cm_mstr.cm_fr_list
.                           so_fr_terms  = cm_mstr.cm_fr_terms
.                           so_fr_min_wt = cm_mstr.cm_fr_min_wt
.                           so_lang     = ad_lang.
.
.                        /* GET DEFAULT TERMS INTEREST FOR ORDER */
.                        socrt_int = 0.
.                        if so_cr_terms <> "" then do:
.                            find ct_mstr where ct_code = so_cr_terms
.                                no-lock no-error.
.                            if available ct_mstr then
.                                socrt_int = ct_terms_int.
.                        end.
.
.                        /* SET NEW TAX DEFAULTS */
.                        if {txnew.i} then do:
.                           /* LOAD DEFAULT TAX CLASS & USAGE */
.                           find ad_mstr where ad_addr = so_ship no-lock no-error.
.                            if not available ad_mstr then
.                              find ad_mstr where ad_addr = so_cust no-lock no-error.
.                           if available ad_mstr then do:
.                               assign
.                                  so_taxable   = ad_taxable
.                                  so_tax_usage = ad_tax_usage
.                                  so_taxc      = ad_taxc.
.                           end.
.                        end.  /* set tax defaults */
.
.                        /* SET DEFAULTS FOR ALL FOUR SALESPERSONS. */
.                        do counter = 1 to 4:
.                            so_slspsn[counter] = cm_mstr.cm_slspsn[counter].
.                            if cm_mstr.cm_slspsn[counter] <> "" then do:
.                                find spd_det where spd_addr = so_slspsn[counter] and
.                                    spd_prod_ln = "" and
.                                    spd_part = "" and
.                                    spd_cust = so_cust no-lock no-error.
.                               if available spd_det
.                               then so_comm_pct[counter] = spd_comm_pct.
.                               else do:
.                                    find sp_mstr where sp_addr =
.                                        cm_mstr.cm_slspsn[counter]
.                                        no-lock no-error.
.                                    if available sp_mstr then
.                                        so_comm_pct[counter] = sp_comm_pct.
.                               end.     /* else, not avail spd_det, do */
.                           end.     /* if cm_mstr.cm_slspsn... */
.                        end.    /* do counter = 1 to 4 */
.
.                        if so_slspsn[2] <> "" or
.                           so_slspsn[3] <> "" or
.                           so_slspsn[4] <> ""  then mult_slspsn = true.
.                        else mult_slspsn = false.
.
.                        if bill_cm.cm_ar_acct <> "" then do:
.                           assign
.                               so_ar_acct = bill_cm.cm_ar_acct
.                               so_ar_cc   = bill_cm.cm_ar_cc.
.                       end.
.                       else do:
.                           assign
.                               so_ar_acct = gl_ar_acct
.                               so_ar_cc   = gl_ar_cc.
.                       end.
.                   end.  /* set defaults if new so_mstr */
.
.                   if {txnew.i} then do:
.                       /* LOAD DEFAULT TAX CLASS & USAGE */
.                       find ad_mstr where ad_addr = so_ship
.                           no-lock no-error.
.                       if not available ad_mstr then
.                           find ad_mstr where ad_addr = so_cust
.                               no-lock no-error.
.                       if available(ad_mstr) then
.                           tax_in  = ad_tax_in.
.                   end.  /* set tax defaults */
.                   else
.                       tax_in = cm_mstr.cm_tax_in.
.
.                   if not new so_mstr and so_invoiced = yes then do:
.                       {mfmsg.i 603 2}
.                       /* Invoice printed but not posted,
.                          press enter to continue */
.
.                       if not batchrun then pause.
.                   end.
.
.                   /* CHECK CREDIT LIMIT */
.                   if bill_cm.cm_cr_limit < bill_cm.cm_balance then do:
.                       {mfmsg02.i  615 2
.                           "bill_cm.cm_balance,""->>>>,>>>,>>9.99"" "}
.                       {mfmsg02.i  617 1
.                           "bill_cm.cm_cr_limit,""->>>>,>>>,>>9.99"" "}
.                        if so_stat = "" and soc_cr_hold then do:
.                            {mfmsg03.i 690 1 """Sales Order""" """" """" }
.                            /* Sales Order placed on credit hold */
.                            so_stat = "HD".
.                        end.
.                   end.    /* if bill_cm.cr_limit < ... */
.
.                   /* CHECK CREDIT HOLD */
.                   /* FOR RMA'S, ACTION WITH A CUSTOMER ON CREDIT HOLD IS    */
.                   /* DETERMINED BY SVC_HOLD_CALL.  IF THIS FLAG IS 0, NO    */
.                   /* ACTION IS TAKEN. IF IT'S 1, THE USER IS WARNED. IF     */
.                   /* IT'S 2, THE RMA MAY NOT BE ENTERED.                    */
.                   if new so_mstr and bill_cm.cm_cr_hold  then do:
.                        if this-is-rma then do:
.                            if svc_hold_call = 1 then do:
.                                {mfmsg.i 614 2}
.                                /* CUSTOMER ON CREDIT HOLD */
.                                so_stat = "HD".
.                            end.
.                            else if svc_hold_call = 2 then do:
.                                {mfmsg.i 614 3}
.                                undo mainloop, retry.
.                            end.
.                        end.    /* if this-is-rma */
.                        else do:
.                           {mfmsg.i  614 2 }
.                           so_stat = "HD".
.                        end.    /* else, this isn't an RMA */
.                   end.    /* if new so_mstr and... */
.
.                   {sosomtdi.i} /* display so_ord_date, etc in frame b */
.
.                   undo_flag = true.
.
.                   /* CALL SOSOMTP.P TO DO FRAME B UPDATES */
.                   {gprun.i ""sosomtp.p""}
.
.                   /* Jump out if SO was (successfully) deleted */
.                   if not can-find(so_mstr where so_nbr = input so_nbr) then
.                        next mainloop.
.                   if undo_flag then undo mainloop, next mainloop.
.
.                   if promise_date = ? then promise_date = so_due_date.
.                   if so_req_date = ? then so_req_date = so_due_date.
.
.                   if this-is-rma then do:
.                    /* LET USER ENTER OTHER RMA-HEADER-SPECIFIC FIELDS */
.                        {gprun.i ""fsrmah1.p""
.                            "(input rma-recno,
.                              input recid(so_mstr),
.                              input new_order,
.                              output undo_flag)"}
.                        if undo_flag then
.                            undo order-header, retry order-header.
.                    end. /* if this-is-rma */
.
.                end. /*order header*/
.                if rebook_lines then do:
.                   {gprun.i ""sosomtrb.p""}
.                   rebook_lines = false.
.                end.
.
.                /* DETAIL - FIND LAST LINE */
.                line = 0.
.                find last sod_det where sod_nbr = so_mstr.so_nbr
.                    use-index sod_nbrln
.                    no-lock no-error.
.                if available sod_det then line = sod_line.
.
.                /* Check for custom program set up in menu system */
.                if this-is-rma then do:
.                    {fsmnp02.i    ""fsrmamt.p"" 10
.                            """(input so_recno, input rma-recno)"""} /****header****/
.                end.
.                else do:
.                     {fsmnp02.i ""sosomt.p"" 10
.                            """(input so_recno)"""}
.                end.
.
.                /* COMMENTS */
.                assign
.                    global_lang = so_mstr.so_lang
.                    global_type = "".
.                if socmmts = yes then do:
.                    assign
.                       cmtindx = so_mstr.so_cmtindx
.                       global_ref = so_mstr.so_cust.
.                   {gprun.i ""gpcmmt01.p"" "(input ""so_mstr"")"}
.                   so_mstr.so_cmtindx = cmtindx.
.                   if this-is-rma then
.                        rma_mstr.rma_cmtindx = cmtindx.
.                end.
.
.                /* Get ship-to number if creating new ship-to */
.                if so_mstr.so_ship = "qadtemp" + mfguser then do:
.                    find ad_mstr where ad_addr = so_mstr.so_ship
.                        exclusive-lock.
.                   {mfactrl.i cmc_ctrl cmc_nbr ad_mstr
.                       ad_addr so_mstr.so_ship}
.                   ad_addr = so_mstr.so_ship.
.                   create ls_mstr.
.                   assign ls_type = "ship-to"
.                          ls_addr = so_mstr.so_ship.
.                   {mfmsg02.i 638 1 so_mstr.so_ship}
.                   /* SHIP-TO RECORD ADDED: */
.                end.
.
.            end.   /* TRANSACTION 40 */
.
.            hide frame sold_to no-pause.
.            hide frame ship_to no-pause.
.            hide frame b1 no-pause.
.            hide frame b no-pause.
.            hide frame a no-pause.
.*J053******** END OF SPLIT OUT TO SOSOMTA1.P */

            /* During line-item entry/edit, the printing of packing list is
                disabled */
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

/*LB01*/    {gprun.i ""zzsosomta.p""
                "(input this-is-rma,
                    input rma-recno,
                    input yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            if this-is-rma then do:
            /* FOR RMA'S, WE CREATED OUR ISSUE LINES (THE PARTS WE'LL BE    */
            /* SENDING OUT TO CUSTOMERS).  NOW, CREATE THE RECEIPT LINES    */
            /* (THE PARTS THEY'RE RETURNING TO US).                         */
/*LB01*/	   	{gprun.i ""zzsosomta.p""
                    "(input this-is-rma,
                      input rma-recno,
                      input no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.    /* if this-is-rma */

/*J042*/    /*TEST FOR AT END OF ORDER PRICING OR REPRICING REQUIREMENTS
               AND SUBSEQUENT PROCESSING OF SUCH*/
            if new_order and not line_pricing then do:
                /*ALL LINES NEED TO BE PRICED, ENTERED PRICES WILL BE RETAINED*/
                for each sod_det where sod_nbr       = so_mstr.so_nbr
/*J0KJ*/                           and sod_fsm_type <> "RMA-RCT" no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

                   sod_recno = recid(sod_det).
                   /*TRANSACTION HISTORY WILL BE REWRITTEN WITH REVISED PRICE*/
                   do transaction /*#6*/ on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                      {gprun.i ""sosoprln.p"" "(input no,
                                                input yes,
                                                input yes,
                                                input yes,
                                                input yes,
                                                input no,
/*J12Q*/                                        input 0,
/*J12Q*/                                        input yes
/*J12Q*/                                        )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J12Q*                                         input 0)"}         */
/*J0M3*J053*          find so_mstr where recid(so_mstr) = so_recno          */
/*J0M3*J053*             exclusive-lock.                                    */
                      so_priced_dt = today.
/*J0M3*J053*          find so_mstr where recid(so_mstr) = so_recno no-lock. */
                   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO TRANSACTION #6 */
                end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH SOD_DET WHERE..*/
            end. /* IF NEW_ORDER AND NOT LINE_PRICING */

            if reprice or new_order then do:
                price_changed = no.
            /*CHECK REPRICE TABLE TO DETERMINE WHICH LINES REQUIRE REPRICING*/
                for each wrep_wkfl where wrep_parent and
                                         wrep_rep
                                   no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

                   find sod_det where sod_nbr  = so_mstr.so_nbr and
                                      sod_line = wrep_line
/*J0HR*/                        no-lock no-error.
                   if available sod_det then do:
                      sod_recno = recid(sod_det).
                      /*REVERSE OLD TRANSACTION HISTORY*/
                      do with frame bi on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                         FORM /*GUI*/  sod_det with frame bi width 80 THREE-D /*GUI*/.

                         {mfoutnul.i &stream_name = "bi"}
                         display stream bi sod_det with frame bi.
                         output stream bi close.
                      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO WITH FRAME BI */
                      do transaction /*#7*/ on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                         {gprun.i ""sosoprln.p"" "(input yes,
                                                   input yes,
                                                   input yes,
                                                   input yes,
                                                   input no,
                                                   input no,
/*J12Q*/                                           input 0,
/*J12Q*/                                           input yes
/*J12Q*/                                           )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J12Q*                                            input 0)"}        */
/*J0M3*J053*             find so_mstr where recid(so_mstr) = so_recno        */
/*J0M3*J053*                exclusive-lock.                                  */
                         so_priced_dt = today.
/*J0M3*J053*             find so_mstr where recid(so_mstr) = so_recno no-lock.*/
                      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO TRANSACTION #7 */
                   end. /* IF AVAILABLE SOD_DET */
                end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH WREP_WKFL */

                if /*pic_so_redisp and*/ price_changed then do:
                   {gprun.i ""sophdp.p""}
/*GUI*/ if global-beam-me-up then undo, leave.
 /*RE-DISPLAY LINE ITEMS*/
                end. /* IF PRICE_CHANGED */
/*J042*/    end. /* IF REPRICE OR NEW_ORDER */


/*J042*/    /* SET CREDIT & FREIGHT TERMS FIELDS */
            do transaction:
/*J0M3*J053*   find so_mstr where recid(so_mstr) = so_recno exclusive-lock.  */
/*J12Q* /*J042*/       if current_cr_terms <> "" then   do: */
/*J12Q*/       if current_cr_terms <> "" and current_cr_terms <> so_cr_terms
/*J12Q*/       then do:
/*J12Q*/           cr_terms_changed = yes.
/*J042*/           so_cr_terms = current_cr_terms.
/*J12Q*/       end.
/*J042*/       if current_fr_terms <> "" then
/*J042*/           so_fr_terms = current_fr_terms.
/*J0HR*/        assign
/*J0HR*/           current_cr_terms = ""
/*J0HR*/           current_fr_terms = ""
/*J0HR*/        .
               so_print_pl   =  old_so_print_pl.
/*J0M3*J053*   find so_mstr where recid(so_mstr) = so_recno no-lock.         */
            end.

            view frame a.
            display so_ship with frame a.
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

                /* CALCULATE FREIGHT */
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
/*LB01*/    {gprun.i ""zzsosomtc.p"" "(input this-is-rma)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            /* FOR RMA'S, THE ADDITIONAL TRAILER ROUTINE WILL OPTIONALLY   */
            /* REDISPLAY THE RMA LINES, AND ALLOWS THE USER TO SHIP AND    */
            /* RECEIVE RMA LINES FROM RMA MAINTENANCE.                     */

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
/*J1P5*/ /* TRAILER FRAMES FOR RMA ARE HIDDED IN sosomtc.p */
/*J1P5*/        hide frame sotot no-pause.
/*J1P5*/        hide frame sotrail no-pause.
/*J1P5*/        hide frame cttrail no-pause.
/*J1P5*/        hide frame d no-pause.
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
                {gprun.i ""sobatch.p"" "(input so_nbr,
                                     input-output batch_job,
                                     input-output dev,
                                     input-output batch_id)"
                                     }
/*GUI*/ if global-beam-me-up then undo, leave.

            end.

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* mainloop */

/*J1RY*/ if cfexists and cf_cfg_strt_err = no then do:
/*J1RY*/    /*close configurations*/
/*J20Z*/     
/*J1RY*/    {gprunmo.i
               &module  = "cf"
               &program = "cfcfclos.p"
               &param   = """(input cf_cfg_path, input cf_chr,
                              cf_cfg_suf)"""
            }
/*J20Z*/   
/*J1RY*/    /*shut configurator*/
/*J20Z*/     
/*J1RY*/    {gprunmo.i
               &module  = "cf"
               &program = "cfcfstop.p"
            }
/*J20Z*/   
/*J1RY*/ end.

         status input.
