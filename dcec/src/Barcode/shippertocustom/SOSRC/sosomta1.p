/* GUI CONVERTED from sosomta1.p (converter v1.75) Sat May  5 08:31:11 2001 */
/* sosomta1.p - PROCESS SALES ORDER HEADER FRAMES                       */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.       */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                       */
/* REVISION: 8.5      LAST MODIFIED: 02/21/96   BY: sxb *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 03/04/96   BY: tjs *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 04/26/96   BY: *J0KJ* Dennis Hensen      */
/* REVISION: 8.5      LAST MODIFIED: 05/13/96   BY: *J0M3* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 05/23/96   BY: *J0NH* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 05/23/96   BY: *J0R6* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 07/19/96   BY: *J0ZZ* T. Farnsworth      */
/* REVISION: 8.5      LAST MODIFIED: 08/27/96   BY: *G2D5* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Elke Van Maele     */
/* REVISION: 8.6      LAST MODIFIED: 11/05/96   BY: *K01T* Stephane Collard   */
/* REVISION: 8.6      LAST MODIFIED: 05/06/97   BY: *K0CZ* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 06/11/97   BY: *K0DQ* Taek-Soo Chang     */
/* REVISION: 8.6      LAST MODIFIED: 07/01/97   BY: *H1B3* Seema Varma        */
/* REVISION: 8.6      LAST MODIFIED: 07/15/97   BY: *K0G6* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 07/11/97   BY: *K0DH* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 09/27/97   BY: *K0HB* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 11/17/97   BY: *J26C* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 12/17/97   BY: *J288* Surekha Joshi      */
/* REVISION: 8.6      LAST MODIFIED: 12/29/97   BY: *J28V* Surekha Joshi      */
/* REVISION: 8.6      LAST MODIFIED: 01/08/98   BY: *J29J* Surekha Joshi      */
/* REVISION: 8.6      LAST MODIFIED: 01/15/98   BY: *K1FK* Jim Williams       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 12/23/98   BY: *M045* Raphael Thoppil    */
/* REVISION: 9.0      LAST MODIFIED: 12/28/98   BY: *J2ZM* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 02/16/99   BY: *J3B4* Madhavi Pradhan    */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 07/24/00   BY: *J3Q2* Ashwini G.         */
/* REVISION: 9.0      LAST MODIFIED: 09/28/00   BY: *M0T7* Rajesh Kini        */
/* REVISION: 9.0      LAST MODIFIED: 10/03/00   BY: *L14Q* Abhijeet Thakur    */
/* REVISION: 9.0      LAST MODIFIED: 02/21/01   BY: *M125* Satish Chavan      */
/* REVISION: 9.0      LAST MODIFIED: 04/20/01   BY: *M11Z* Jean Miller        */

/* Note: This program is called by SOSOMT1.P.  It was initially split from
   SOSOMT.P due to compile size limits.  */

     {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sosomta1_p_1 "项目定价"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomta1_p_2 "说明"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomta1_p_3 " 货物发往 "
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomta1_p_4 "已确认"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomta1_p_5 " 销售至 "
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomta1_p_6 "计算运费"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomta1_p_7 "承诺日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomta1_p_8 "重新定价"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomta1_p_9 "客户订单"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*J29J PATCH REPLACED LITERAL STRINGS WITH VARIABLES DEFINED IN FSCONST.I */

         {socurvar.i}

         /* Input/Output Parameters */
/*J04C*/ define input  parameter this-is-rma as logical.
         define output parameter not_okay    as integer.
/*J04C*/ define output parameter rma-recno   as recid.

         define shared variable rndmthd     like rnd_rnd_mthd.
         define shared variable oldcurr     like so_curr.
         define shared variable line        like sod_line.
         define shared variable del-yn      like mfc_logical.
         define shared variable qty_req     like in_qty_req.
         define shared variable prev_due    like sod_due_date.
         define shared variable prev_qty_ord like sod_qty_ord.
         define shared variable trnbr       like tr_trnbr.
         define shared variable qty         as decimal.
         define shared variable part        as character format "x(18)".
         define shared variable eff_date    as date.
         define shared variable all_days    like soc_all_days.
         define shared variable all_avail   like soc_all_avl.
         define shared variable sngl_ln     like soc_ln_fmt.
         define shared variable so_recno    as recid.
         define shared variable cm_recno    as recid.
         define shared variable comp        like ps_comp.
         define shared variable cmtindx     like cmt_indx.
         define shared variable sonbr       like so_nbr.
         define shared variable socmmts     like soc_hcmmts
                                        label {&sosomta1_p_2}.
         define shared variable prev_abnormal like sod_abnormal.
         define shared variable promise_date as date label {&sosomta1_p_7}.
         define shared variable base_amt    like ar_amt.
         define shared variable consume     like sod_consume.
         define shared variable prev_consume like sod_consume.
         define shared variable confirm     like mfc_logical
         format "Y/N" initial yes label {&sosomta1_p_4}.
         define shared variable sotrcust    like so_cust.
/*M11Z*  define variable sotrnbr         like so_nbr.   */
         define shared variable merror      like mfc_logical initial no.
         define shared variable so-detail-all like soc_det_all.
         define shared variable new_order   like mfc_logical initial no.
         define shared variable sotax_trl   like tax_trl.
         define shared variable tax_in      like cm_tax_in.
         define shared variable rebook_lines as logical initial no no-undo.
         define shared variable avail_calc  as integer.
         define shared variable so_db       like dc_name.
         define shared variable inv_db      like dc_name.
         define        buffer bill_cm       for cm_mstr.
         define shared variable mult_slspsn like mfc_logical no-undo.
         define        variable counter     as integer no-undo.
         define shared variable undo_cust   like mfc_logical.
         define shared variable freight_ok  like mfc_logical initial yes.
         define shared variable old_ft_type like ft_type.
         define shared variable calc_fr     like mfc_logical
                        label {&sosomta1_p_6}.
         define shared variable undo_flag   like mfc_logical.
         define shared variable disp_fr     like mfc_logical.
         define shared variable display_trail like mfc_logical initial yes.
         define shared variable soc_pc_line like mfc_logical initial yes.
         define shared variable socrt_int   like sod_crt_int.
         define shared variable impexp      like mfc_logical no-undo.
         define shared variable picust      like cm_addr.
         define shared variable price_changed like mfc_logical.
         define shared variable line_pricing  like pic_so_linpri
                                          label {&sosomta1_p_1}.
         define shared variable reprice       like mfc_logical
                                          label {&sosomta1_p_8} initial no.
         define shared variable balance_fmt as character.
         define shared variable limit_fmt   as character.
         define shared variable prepaid_fmt as character no-undo.
         define shared variable prepaid_old as character no-undo.
/*M11Z* define variable impexp_label as character format "x(8)" no-undo. */
         define        variable in_batch_proces as logical.

/*J04C*/ define        variable msgnbr          as  integer no-undo.
         define        variable call-number     like rma_ca_nbr initial " ".
/*J0M3*/ define        variable local-undo      as  integer no-undo.

/*M11Z* /*K004*/ define shared variable s-prev-so-stat  like so_stat. */
/*J26C*/ define variable l_old_shipto like  so_ship no-undo.
/*J26C*/ define new shared variable l_edittax    like mfc_logical
/*J26C*/                                              initial no no-undo.

/*M11Z*/ define variable emt-bu-lvl    like global_part no-undo.
/*M11Z*/ define variable save_part     like global_part no-undo.
/*M11Z*/ define variable l-shipto      like so_ship     no-undo.

/*K004*/ {sobtbvar.i }    /* BACK TO BACK SHARED WORKFILES AND VARIABLES */

         define     shared frame a.
         define new shared frame sold_to.
         define new shared frame ship_to.
/*J2ZM*/ define new shared frame ship_to1.
/*J2ZM*/ define new shared frame ship_to2.
         define new shared frame b.

/*M11Z*  {gptxcdec.i} */

         /* Form Definition for frame d: Second Trailer Frame */
         {sosomt01.i}

/*J29J*/ /* FIELD SERVICE VARIABLE'S DEFINITION */
/*J29J*/ {fsconst.i}

/*M11Z** find first gl_ctrl no-lock.            */
/*M11Z** find first pic_ctrl no-lock no-error.  */

/*M11Z*/ for first gl_ctrl
/*M11Z*/ fields(gl_ar_acct gl_ar_cc)
/*M11Z*/ no-lock: end.

/*M11Z*/ for first pic_ctrl
/*M11Z*/ fields(pic_so_date pic_so_linpri)
/*M11Z*/ no-lock: end.

         /* THE LOCAL-UNDO VARIABLE HANDLES UNDO PROCESSING WITHIN SOSOMTA1.P */
         /* AS IT HAS THE 'NO-UNDO' ATTRIBUTE, IT GETS SET TO INDICATE THE    */
         /* APPROPRIATE PROCESSING FOR THE CALLING ROUTINE (SOSOMT1.P), THEN  */
         /* PROCESSING DONE IN THE CURRENT TRANSACTION IS UNDONE.  IF THE     */
         /* USER SUCCESSFULLY EXECUTES THE CODE IN THIS PROGRAM (AND HENCE,   */
         /* NO 'UNDO' IS NECESSARY), THIS WILL BE SET TO 0 FOR SOSOMT1.P.     */
         /* VALUES USED BY THIS UNDO FLAG ARE:            */
         /* 1 = NEXT MAINLOOP (WITH NO UNDO)              */
         /* 2 = UNDO MAINLOOP, NEXT MAINLOOP              */
         /* 3 = UNDO MAINLOOP, RETRY MAINLOOP             */
         /* 4 = UNDO MAINLOOP, LEAVE                      */

/*J0M3*/ assign
            local-undo = 4
            not_okay   = 4. /* undo mainloop, leave */

/*J0NH*  do transaction /* #1 */ on error undo, leave:  */
/*J3Q2** /*J0NH*/ do transaction on error undo, leave on endkey undo, return: */

/*J0M3*     not_okay = 0. /* OK; Continue processing */     */
/*J0M3*     hide all no-pause.                              */

/*J2ZM** BEGIN DELETE**
 * /*V8-*/ /*V8! if global-tool-bar and global-tool-bar-handle <> ? then
 *      view global-tool-bar-handle.  */ /*V8+*/
 *J2ZM** END DELETE **/

/*M11Z** find first soc_ctrl no-lock.  */
/*M11Z*/ for first soc_ctrl
/*M11Z*/ fields(soc_all_days soc_confirm soc_cr_hold soc_det_all
/*M11Z*/        soc_fob soc_hcmmts soc_print soc_shp_lead soc_so
/*M11Z*/        soc_so_pre soc_use_btb)
/*M11Z*/ no-lock: end.

/*J04C*/ if this-is-rma then
/*J0R6*/ do:
            /* DELETE ANY HANGING SR_WKFL'S FROM PREVIOUS RMA     */
            /* MAINTENANCE SHIPMENT/RECEIPT THAT WASN'T COMPLETED */
/*J0R6*/    for each sr_wkfl exclusive-lock where sr_userid = mfguser:
/*J0R6*/       delete sr_wkfl.
/*J0R6*/    end.

/*M0T7*/    /* DELETE ANY HANGING LOTW_WKFL'S FROM PREVIOUS RMA     */
/*M0T7*/    /* MAINTENANCE RECEIPT THAT WASN'T COMPLETED            */
/*M0T7*/    {gprun.i ""gplotwdl.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


/*M11Z** /*J04C*/        find first rmc_ctrl no-lock.  */
/*M11Z*/    for first rmc_ctrl
/*M11Z*/    fields(rmc_all_days rmc_consume rmc_det_all rmc_hcmmts
/*M11Z*/           rmc_so_nbr rmc_so_pre rmc_swsa)
/*M11Z*/    no-lock: end.

/*J0R6*/ end.
/*J04C*/ else
            socmmts = soc_hcmmts.

         /* Form Defintions for Frame A and B */
         {sosomt02.i}

         /* CREATE SOLD_TO & SHIP_TO FRAMES */
         {mfadform.i "sold_to" 1 {&sosomta1_p_5}}
         {mfadform.i "ship_to" 41 {&sosomta1_p_3}}
/*J2ZM*/ {mfadform.i "ship_to1" 41 {&sosomta1_p_3}}
/*J2ZM*/ {mfadform.i "ship_to2" 41 {&sosomta1_p_3}}

/*J0M3*  /*V8-*/
.        display dtitle format "x(78)"
.        with no-labels width 80 row 1 column 2
.        frame dtitle no-box no-attr-space.
./*V8+*/  *J0M3*/

         view frame a.
         view frame sold_to.
         view frame ship_to.
         view frame b.

/*M045*/ new_order = no.

         /* Get the Sales Order Number */
         prompt-for so_nbr with frame a editing:

            /* ALLOW LAST SO NUMBER REFRESH */
            if keyfunction(lastkey) = "RECALL" or lastkey = 307
            then display sonbr @ so_nbr with frame a.

            /* IF WE'RE MAINTAINING RMA'S, NEXT/PREV ON RMA'S, */
            /* ELSE, NEXT/PREV ON SALES ORDERS.                */
/*J04C*/    if this-is-rma then do:
/*J29J*/       /* CHANGED THIRD PARAMETER FROM SO_FSM_TYPE = ""RMA"" TO */
/*J29J*/       /* SO_FSM_TYPE = RMA_C                                   */
/*J04C*/       {mfnp05.i
                        so_mstr
                        so_fsm_type
                        "so_fsm_type = rma_c"
                        so_nbr
                        "input so_nbr"}
/*J04C*/    end.
/*J04C*/    else do:
               /* FIND NEXT/PREVIOUS RECORD - SO'S ONLY */
/*J04C*        {mfnp.i so_mstr so_nbr so_nbr so_nbr so_nbr so_nbr}  */
/*J04C*/       {mfnp05.i
                        so_mstr
                        so_fsm_type
                        "so_fsm_type = "" "" "
                        so_nbr
                        "input so_nbr"}
/*J04C*/    end.

            if recno <> ? then do with frame b:

               {mfaddisp.i so_cust sold_to}
               {mfaddisp.i so_ship ship_to}

               display
                  so_nbr
                  so_cust
                  so_bill
                  so_ship
               with frame a.

/*M11Z*/       promise_date = ?.

               find first sod_det where sod_nbr = so_nbr no-lock no-error.
/*M11Z*/       if available sod_det then
/*M11Z*/          promise_date = sod_per_date.

/*M11Z*        if available sod_det and sod_per_date <> ? then   */
/*M11Z*           promise_date = sod_per_date.                   */
/*M11Z*        else                                              */
/*M11Z*           promise_date = ?.                              */

               if so_conf_date = ? then
                  confirm = no.
               else
                  confirm = yes.

               if so_slspsn[2] <> "" or
                  so_slspsn[3] <> "" or
                  so_slspsn[4] <> ""
               then
                  mult_slspsn = true.
               else
                  mult_slspsn = false.

               /* Display so_ord_date, etc in frame B */
               {sosomtdi.i}

            end. /* IF RECNO <> ? */

         end. /* PROMPT-FOR SO_NBR */

/*J3Q2*/ do transaction on error undo, leave on endkey undo, return:
/*GUI*/ if global-beam-me-up then undo, leave.


            if input so_nbr = "" then do:

/*J04C*/       if this-is-rma then do:
/*J04C*/          /* GET NEXT RMA NUMBER WITH PREFIX */
/*J04C*/          {fsnctrl2.i rmc_ctrl
                              rmc_so_nbr
                              so_mstr
                              so_nbr
                              sonbr
                              rmc_so_pre
                              rma_mstr
                              rma_prefix
                              ""C""
                              rma_nbr}
/*M11Z** /*J04C*/ find first rmc_ctrl no-lock.  */
/*M11Z*/          for first rmc_ctrl
/*M11Z*/          fields(rmc_all_days rmc_consume rmc_det_all rmc_hcmmts
/*M11Z*/                 rmc_so_nbr rmc_so_pre rmc_swsa)
/*M11Z*/          no-lock: end.

/*J04C*/       end.   /* if this-is-rma */

/*J04C*/       else do:
                  /* GET NEXT SALES ORDER NUMBER WITH PREFIX */
                  {mfnctrlc.i
                     soc_ctrl soc_so_pre soc_so so_mstr so_nbr sonbr}
/*J04C*/       end.   /* ELSE, THIS IS SO - GET NEXT NUMBER */

            end. /* IF INPUT SO_NBR = "" */
            else   /* TAKE SONBR AS ENTERED BY USER */
               sonbr = input so_nbr.

         end.  /* DO TRANSACTION ON ERROR UNDO.. */

/*J0M3*/ if sonbr = " " then
/*J0M3*/    return.

/*J0M3*/ trans2:
         do transaction /* #2 */ on error undo, retry:

            old_ft_type = "".

            find so_mstr where so_nbr = sonbr exclusive-lock no-error.

            if not available so_mstr then do:

/*J04C*/       if this-is-rma and not available rmc_ctrl then
/*M11Z** /*J04C*/ find first rmc_ctrl no-lock no-error.  */
/*M11Z*/          for first rmc_ctrl
/*M11Z*/          fields(rmc_all_days rmc_consume rmc_det_all rmc_hcmmts
/*M11Z*/                 rmc_so_nbr rmc_so_pre rmc_swsa)
/*M11Z*/          no-lock: end. /* FOR FIRST RMC_CTRL */

/*M11Z**       find first soc_ctrl no-lock.  */
/*M11Z*/       for first soc_ctrl
/*M11Z*/       fields(soc_all_days soc_confirm soc_cr_hold soc_det_all
/*M11Z*/              soc_fob soc_hcmmts soc_print soc_shp_lead soc_so
/*M11Z*/              soc_so_pre soc_use_btb)
/*M11Z*/       no-lock: end. /* FOR FIRST SOC_CTRL */

               clear frame sold_to.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame sold_to = F-sold_to-title.
               clear frame ship_to.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame ship_to = F-ship_to-title.
               clear frame b.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.

/*M11Z**       {mfmsg.i 1 1} /* ADDING NEW RECORD */         */
/*M11Z*/       /* ADDING NEW RECORD */
/*M11Z*/       run p-mfmsg (input 1, input 1).

               create so_mstr.
               new_order = yes.
               assign
                  so_nbr       = sonbr
                  so_ord_date  = today
                  so_due_date  = today + soc_shp_lead
                  so_print_so  = soc_print
                  so_fob       = soc_fob
                  confirm      = soc_confirm
                  /* SET SO_PRINT_PL SO IT DOES NOT PRINT WHILE IT IS */
                  /* BEING CREATED. IT IS RESET TO YES IN SOSOMTC.P   */
                  so_print_pl  = no
/*K0DQ*/          so_userid    = global_userid
                  socmmts      = soc_hcmmts.

/*J04C*        ADDED THE FOLLOWING */
               /* FOR RMA'S, HEADER INFORMATION IS ALSO    */
               /*  STORED IN RMA_MSTR */
               if this-is-rma then do:
                  create rma_mstr.
                  assign
                     rma_nbr   = sonbr
                     rma_ord_date = today
                     so_req_date = today + soc_shp_lead
                     rma_req_date = so_req_date
                     so_due_date = today
                     rma_exp_date = so_due_date
                     rma_prt_rec = so_print_so
                     rma_prefix = "C"
                     socmmts = rmc_hcmmts
                     confirm = yes
/*J29J**             so_fsm_type = "RMA". */
/*J29J*/             so_fsm_type = rma_c.

                  if recid(rma_mstr) = -1 then .
               end.    /* if this-is-rma */
/*J04C*        END ADDED CODE */

            end. /* IF NOT AVAILABLE SO_MSTR */

            else do: /* IF AVAILABLE SO_MSTR */

/*J04C*        {mfmsg.i 10 1} /* EDITING EXISTING RECORD */     */
/*M11Z*/ /*** Moved code to new EMT trigger procedure *****************
 * /*K004*/       /* added next section - BTB  */
 * /*K01T*/       /* added next section */
 *              /* CLEAN UP WORKFILES */
 *              for each wkf-btb exclusive-lock:
 *                 delete wkf-btb.
 *              end.
 *
 *              /* CREATE WORKFILE FOR EACH LINE TO CHECK ON EXISTING PO'S */
 *              if soc_use_btb and not new_order then do:
 *
 *                 for each sod_det where sod_nbr = so_nbr no-lock:
 *                    find first wkf-btb where w-so-nbr = sod_nbr
 *                                         and w-po-nbr = sod_btb_po
 *                                         and w-pod-line = sod_btb_pod_line
 *                    exclusive-lock no-error.
 *                    if not available wkf-btb then do:
 *                       create wkf-btb.
 *                       assign
 *                          w-so-nbr   = so_nbr
 *                          w-sod-line = sod_line
 *                          w-po-nbr   = sod_btb_po
 *                          w-pod-line = sod_btb_pod_line
 *                          w-btb-vend = sod_btb_vend
 *                          w-btb-type = sod_btb_type
 *                          w-msg-type = "".
 *                    end.
 *                 end.  /* each sod_det */
 *
 *              end.  /* if soc_use_btb and not new_order */
 * /*K01T*/       /* end of added next section */
 ****************************/

               /* SECONDARY SO */
/*K0DH*        if not so_primary then do:            */
/*K0DH*/       if so_secondary then do:
                  /* IF SECONDARY SO AND PO CHANGE LOAD NOT YET ACKNOWLEDGED */
                  /* OR PO CHANGES NOT YET ACKNOWLEDGED, THEN ERROR...      */
                  if can-find(trq_mstr where trq_doc_type = "SO"
                                         and trq_doc_ref  = so_nbr
                                         and (trq_msg_type = "ORDRSP-S" or
                                              trq_msg_type = "ORDRSP-C"))
                  then do:
/*M11Z**             {mfmsg.i 2812 3}                              */
/*M11Z*/             run p-mfmsg (input 2812, input 3).
                     /* Modific. is not allowed on Processed Secondary SO */
                     if not batchrun then pause.
                     not_okay = 3. /* undo mainloop, retry mainloop */
                     return.
                  end. /* if can-find trq_mstr */
/*K0G6**
./*K0G6*/         /*  INITIAL ORDER WAITING FOR PO ACK */
./*K0G6*/ /*K0CZ*/          if can-find(trq_mstr where trq_doc_type = "SO":U
./*K0G6*/ /*K0CZ*/                                 and trq_doc_ref  = so_nbr
./*K0G6*/ /*K0CZ*/                            and (trq_msg_type = "ORDRSP-I":U))
./*K0G6*/ /*K0CZ*/          then do:
./*K0G6*/ /*K0CZ*/             {mfmsg.i 2935 3}
./*K0G6*/ /*K0CZ*/             /* Modific. is not allowed awaiting PO ack  */
./*K0G6*/ /*K0CZ*/             if not batchrun then pause.
./*K0G6*/ /*K0CZ*/             not_okay = 3. /* undo mainloop, retry mainloop */
./*K0G6*/ /*K0CZ*/             return.
./*K0G6*/ /*K0CZ*/          end. /* if can-find trq_mstr */  **/
               end.  /* secundary SO */

/*M11Z*/ /* Moved logic to EMT trigger program soemttrg.p *****************
 *
 *              /* CLEAN UP WORKFILES */
 *              for each wkf-btb2 exclusive-lock:
 *                 delete wkf-btb2.
 *              end.
 *
 *              /* PRIMARY SO */
 * /*K0DH*        if soc_use_btb and so_primary then                      */
 * /*K0HB*        IN MULTI EMT ALSO KEEP TRACK OF CHANGE AT THE SBU */
 * /*K0HB* /*K0DH*/  if soc_use_btb and not so_secondary then                */
 * /*K0HB*/       if soc_use_btb then
 *              /* CREATE WKF TO KEEP TRACK OF THE POSSIBILITY TO MODIFY */
 *              /* EACH BTB SO LINE */
 *              for each sod_det where sod_nbr = sonbr no-lock:
 *
 *                 find po_mstr where po_nbr = sod_btb_po no-lock no-error.
 *                 find pod_det where pod_nbr = sod_btb_po
 *                                and pod_line = sod_btb_pod_line
 *                 no-lock no-error.
 *                 if not available po_mstr or not available pod_det then next.
 *
 *                 find cmf_mstr where cmf_doc_type = "PO"
 *                                 and cmf_doc_ref = po_nbr
 *                 no-lock no-error.
 *                 find trq_mstr where trq_doc_ref = po_nbr no-lock no-error.
 *
 *                 create wkf-btb2.
 *                 assign
 *                    w2-sodline = sod_line
 *                    w2-sod-btb-type = sod_btb_type
 *                    w2-po-xmit = po_xmit
 *                    w2-pod-so-status = pod_so_status
 *                    w2-cmf-status = if avail cmf_mstr then cmf_status
 *                                                          else "x"
 *                    w2-avail-trq = available trq_mstr.
 *
 *              end. /* for each sod_det */
 * /*K004*/       /* end added section*/
 ******************************************/ /*M11Z*/

               /* ENSURE WE HAVE THE CORRECT ORDER TYPE */
/*J04C*        if so_fsm_type <> ""         */
/*J04C*/       if (not this-is-rma and so_fsm_type <> "")
/*J29J** /*J04C*/  or (this-is-rma and so_fsm_type <> "RMA") */
/*J29J*/           or (this-is-rma and so_fsm_type <> rma_c)
               then do:
/*J04C*/          if so_fsm_type = " " then
/*J04C*/             msgnbr = 1282.
                     /* THIS IS SALES ORD. USE SALES ORDER MAINT FOR UPDATES */
/*J29J** /*J04C*/ else if so_fsm_type = "SEO" then */
/*J29J*/          else if so_fsm_type = seo_c then
/*J04C*/             msgnbr = 1281.
                     /* THIS IS SERVICE ENGINEER ORD. USE SEO MAINT FOR UPDATE */
/*J29J** /*J04C*/ else if so_fsm_type = "SC" then */
/*J29J*/          else if so_fsm_type = scontract_c then
/*J04C*/             msgnbr = 1280.
                     /* THIS IS SERVICE CONTR. USE CONTRACT MAINT FOR UPDATE */
/*J29J** /*J04C*/ else if so_fsm_type = "RMA" then */
/*J29J*/          else if so_fsm_type = rma_c then
/*J04C*/             msgnbr = 7190.
                     /* THIS IS AN RMA. CANNOT PROCESS */

/*J29J*/          /* CHECKING FOR INVOICED CALL */
/*J29J*/          else if so_fsm_type = fsmro_c then
/*J29J*/             msgnbr = 2450.
/*J29J*/             /* THIS IS AN INVOICD CALL. USE CALL MAINT/CAR FOR UPDATE. */

/*J04C*           {mfmsg.i 7190 3}     */
/*M11Z** /*J04C*/ {mfmsg.i msgnbr 3}        */
/*M11Z*/          run p-mfmsg (input msgnbr, input 3).

/*J0M3*/          local-undo = 3.
/*J0M3*/          leave trans2.      /* Nothing's been modified - no undo needed. */
/*J0M3*           not_okay = 3.      */
/*J0M3*           return.        */
               end. /* IF SO_FSM_TYPE <> "" */

/*M11Z** /*J04C*/ {mfmsg.i 10 1} /* EDITING EXISTING RECORD */  */
/*M11Z*/       /* EDITING EXISTING RECORD */
/*M11Z*/       run p-mfmsg (input 10, input 1).

/*J04C*/       if this-is-rma then
/*J04C*/          find rma_mstr where rma_nbr = so_nbr
/*J04C*/          and rma_prefix = "C" no-lock no-error.

               /* Check Site Security */
               {gprun.i ""gpsiver.p""
                  "(input so_site, input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               if return_int = 0 then do:
                  display
                     so_nbr
                     so_cust
                     so_bill
                     so_ship
                  with frame a.

                  /* Display so_order_date, etc with frame B */
                  {sosomtdi.i}

                  /* User does not have access to this site */
/*M11Z*           {mfmsg.i 725 3} /* USER DOES NOT HAVE ACCESS TO THIS SITE*/ */
/*M11Z*/          run p-mfmsg (input 725, input 3).
/*J0M3*           not_okay = 3.    */
/*J0M3*           return.          */
/*J0M3*/          local-undo = 3.
/*J0M3*/          leave trans2.      /* Nothing's been modified - no undo needed. */
               end. /* IF RETURN_INT = 0 */

               /* CHECK FOR BATCH SHIPMENT RECORD */
               in_batch_proces = no.
               {sosrchk.i so_nbr in_batch_proces}
               if in_batch_proces then do:
/*J0M3*           not_okay = 3.    */
/*J0M3*           return.          */
/*J0M3*/          local-undo = 3.
/*J0M3*/          leave trans2.      /* Nothing's been modified - no undo needed. */
               end.

               /* Display the Sold to Address */
               {mfaddisp.i so_cust sold_to}

               if not available ad_mstr then do:
                  hide message no-pause.
/*M11Z**          {mfmsg.i 3 2} /* CUSTOMER DOES NOT EXIST */  */
/*M11Z*/          /* CUSTOMER DOES NOT EXIST */
/*M11Z*/          run p-mfmsg (input 3, input 2).
               end. /* IF NOT AVAILABLE AD_MSTR */

               /* Display the Ship-To Address */
               {mfaddisp.i so_ship ship_to}

               if so_conf_date = ? then
                  confirm = no.
               else
                  confirm = yes.

               new_order = no.
/*M11Z**       find ft_mstr where ft_terms = so_fr_terms no-lock no-error.  */
/*M11Z*/       for first ft_mstr
/*M11Z*/       fields(ft_terms ft_type)
/*M11Z*/       where ft_terms = so_fr_terms no-lock:
/*M11Z*/       end. /* FOR FIRST FT_MSTR */

               if available ft_mstr then old_ft_type = ft_type.

               if so_sched then do:
/*M11Z**          {mfmsg.i 8210 2}                              */
/*M11Z*/          run p-mfmsg (input 8210, input 2).
                  /* ORDER WAS CREATED BY SCHEDULED ORDER MAINT */
               end.

            end. /* ELSE IF AVAILABLE SO_MSTR */

/*J288*/    /* FOR RMAs CONSUME FORECAST FLAG ON THE HEADER SHOULD DEFAULT */
/*J288*/    /* FROM RMA/RTS CONTROL FILE                                   */
/*J04C*/    if this-is-rma then
/*G2D5** /*J04C*/        assign so-detail-all = rmc_det_all. */
/*J04C*/       assign
/*J04C*/          so-detail-all = rmc_det_all
/*J288*/          consume       = rmc_consume
/*G2D5*/          all_days      = rmc_all_days.
/*J04C*/    else
/*G2D5**       so-detail-all = soc_det_all.             */
/*G2D5*/       assign
/*J04C*/          so-detail-all = soc_det_all
/*J288*/          consume       = yes
/*G2D5*/          all_days      = soc_all_days.

/*J288** /*G2D5*/    consume = yes. */

            recno = recid(so_mstr).

            /* CHECK FOR COMMENTS*/
            if so_cmtindx <> 0 then
               socmmts = yes.

            display
               so_nbr
               so_cust
               so_bill
               so_ship
            with frame a.

/*M11Z*/    /* Create a record for the Sales Order Header if this is emt */
/*M11Z*/    if soc_use_btb and so_primary then do:
/*M11Z*/       {gprunp.i "soemttrg" "p" "create-temp-so-mstr"
                  "(input so_nbr)"}
/*M11Z*/    end.

/*M11Z*/    assign
/*M11Z*        sotrnbr  = so_nbr  */
/*M11Z*/       promise_date = ?
               sotrcust = so_cust.

            find first sod_det where sod_nbr = so_nbr no-lock no-error.
/*M11Z*/    if available sod_det then
/*M11Z*/       promise_date = sod_per_date.

/*M11Z*     if available sod_det and sod_per_date <> ? then   */
/*M11Z*        promise_date = sod_per_date.                   */
/*M11Z*     else                                              */
/*M11Z*        promise_date = ?.                              */

            if so_slspsn[2] <> "" or
               so_slspsn[3] <> "" or
               so_slspsn[4] <> ""
            then
               mult_slspsn = true.
            else
               mult_slspsn = false.

            /* Display SO ORder Date, etc in Frame B */
            {sosomtdi.i}

/*J04C*     ADDED THE FOLLOWING */
            /* FOR RMA'S, THE USER MAY OPTIONALLY ATTACH A CALL */
            /* NUMBER TO THE ORDER.  CALL FSRMACA.P TO GET THAT */
            /* CALL NUMBER, AND, IF ENTERED, DEFAULT RELEVANT   */
            /* CALL FIELDS TO THE RMA BEING CREATED.            */
            if this-is-rma and new_order then do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


               display
                  so_nbr
               with frame a.

               {gprun.i ""fsrmaca.p""
                     "(input  recid(rma_mstr),
                       input  recid(so_mstr),
                       output call-number)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               if call-number = "?" then undo, retry.

               assign
                  so-detail-all = rmc_det_all.

               display
                  so_ship
                  so_bill
                  so_cust
               with frame a.

               display
                  so_po
               with frame b.

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
    /* if this-is-rma and... */
/*J04C*     END ADDED CODE */

/*J26C*/    l_old_shipto = so_ship.

            /* GET SOLD-TO, BILL-TO, AND SHIP-TO CUSTOMER */
            /* FOR RMA'S, ALSO GET THE END USER        */
/*M11Z*/    assign
               so_recno  = recid(so_mstr)
               undo_cust = true.

/*J04C*     ADDED INPUT PARMS */
            {gprun.i ""sosomtcm.p""
                  "(input this-is-rma,
                    input recid(rma_mstr),
                    input new_order)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            if undo_cust then do:
/*J0M3*        not_okay = 3.    */
/*J0M3*        return.          */
/*J0M3*/       local-undo = 3.
/*J0M3*/       undo trans2, leave.  /* MUST UNDO CREATION OF SO_MSTR */
            end. /* IF UNDO_CUST */

/*J26C*/    /* SHIP-TO CANNOT BE CHANGED; QUANTITY TO INVOICE EXISTS */
/*J26C*/    if l_old_shipto <> "" and
/*J26C*/       l_old_shipto <> so_ship and
/*J26C*/       {txnew.i}
/*J26C*/    then do:
/*J26C*/       if can-find(first sod_det where sod_nbr = so_nbr and
/*J26C*/          sod_qty_inv <> 0 ) then do:
/*J26C*/          /* OUTSTANDING QTY TO INVCE; SHIP-TO TAXES CANNOT BE UPDATED */
/*M11Z** /*J26C*/ {mfmsg.i 2363 4}             */
/*M11Z*/          run p-mfmsg (input 2363, input 4).
/*J26C*/          display l_old_shipto @ so_ship with frame a.
/*J26C*/          local-undo = 3.
/*J26C*/          undo trans2, leave trans2.
/*J26C*/       end. /* IF CAN-FIND FIRST SOD_DET */
/*J26C*/    end. /* IF SHIP-TO IS CHANGED IN GTM */

/*J04C*     ADDED THE FOLLOWING */
            /* WHEN CREATING A NEW RMA, SOSOMTCM.P LOADS IN THE DEFAULT    */
            /* END USER (THE CUSTOMER), AND ALLOWS THE USER TO CHANGE IT.  */
            /* IF HE F4-ED OUT OF SOSOMTCM.P, THEN, RMA_ENDUSER GETS       */
            /* UNDONE AND LEFT BLANK, SO, FIX IT HERE...                   */
            if this-is-rma and new_order then do:

               if rma_enduser = "" then
                  assign
                     rma_enduser = so_cust
                     rma_cust_ven = so_cust.

               find eu_mstr where eu_addr = rma_enduser
               no-lock no-error.

               /* IF USER DIDN'T ATTACH A CALL TO THIS RMA (AND DEFAULT */
               /* SOME OF THE CALL FIELDS INTO THIS NEW ORDER), THEN    */
               /* OPTIONALLY DISPLAY SERVICE CONTRACTS FOR THIS END USER*/
               if call-number = " " then do:
                  {gprun.i ""fsrmasv.p""
                                "(input      rma_enduser,
                                  input        eu_type,
                                  input        rmc_swsa,
                                  input-output rma_contract,
                                  input-output rma_ctype,
                                  input-output rma_crprlist,
                                  input-output rma_pr_list,
                                  input-output rma_rstk_pct)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.    /* if call-number = " " */

            end.    /* if this-is-rma and new_order */
/*J04C*     END ADDED CODE */

/*J26C*/    /* SHIP-TO CHANGED; UPDATE TAX DATA ON CONFIRMATION. PREVIOUS */
/*J26C*/    /* HEADER TAX ENVIRONMENT BLANKED OUT FOR RECALCULATION LATER */
/*J26C*/    l_edittax = no.

/*J26C*/    if not batchrun and
/*J26C*/       l_old_shipto <> "" and
/*J26C*/       l_old_shipto <> so_ship and
/*J26C*/       {txnew.i}
/*J26C*/    then do:

/*J26C*/       /* SHIP-TO CHANGED; UPDATE TAX DATA? */
/*J26C*/       {mfmsg01.i 2351 1 l_edittax }

/*J26C*/       if l_edittax then do:
/*J26C*/          /* LOAD DEFAULT TAX CLASS & USAGE */
/*J26C*/          find ad_mstr where ad_addr = so_ship no-lock no-error.
/*J26C*/          if not available ad_mstr then
/*J26C*/             find ad_mstr where ad_addr = so_cust no-lock no-error.
/*J26C*/          if available ad_mstr then do:
/*J26C*/            assign
/*J26C*/               so_taxable   = ad_taxable
/*J26C*/               so_tax_usage = ad_tax_usage
/*J26C*/               so_taxc = ad_taxc.
/*J26C*/         end.
/*J26C*/         so_tax_env = "".
/*J26C*/       end.  /* IF l_edittax IS TRUE */

/*J26C*/    end. /* IF SHIP-TO CHANGED IN GTM AND NOT BATCHRUN */

            find cm_mstr where cm_mstr.cm_addr = so_cust no-lock.
            find bill_cm where bill_cm.cm_addr = so_bill no-lock.
            find ad_mstr where ad_addr = so_bill no-lock.

            if ad_inv_mthd = "" then do:
               find ad_mstr where ad_addr = so_ship  no-lock.
               if ad_inv_mthd = "" then
                  find ad_mstr where ad_addr = so_cust  no-lock.
            end. /* IF AD_INV_MTHD = "" */

            if new_order then
               so_inv_mthd = ad_inv_mthd.
            if new_order then
               substring(so_inv_mthd,3,1) = substring(ad_edi_ctrl[5],1,1).

            /*SET CUSTOMER VARIABLE USED BY PRICING ROUTINE gppibx.p*/
            picust = so_cust.
            if so_cust <> so_ship and
               can-find(cm_mstr where cm_mstr.cm_addr = so_ship)
            then
               picust = so_ship.

            if new_order then
               line_pricing = pic_so_linpri.
            else
               line_pricing = no.

            order-header:
            do on error undo, retry with frame b:
/*GUI*/ if global-beam-me-up then undo, leave.


               ststatus = stline[2].
               status input ststatus.
               del-yn = no.

               /* SET DEFAULTS WHEN CREATING A NEW ORDER - */
               /* USE SHIP-TO CUSTOMER INFO FOR DEFAULT IF */
               /* AVAILABLE ELSE USE SOLD-TO INFO          */
               if new so_mstr then do:
/*L14Q**          if so_cust <> so_ship and                                 */
/*L14Q**          can-find(cm_mstr where cm_mstr.cm_addr = so_ship) then   */
/*L14Q**          find cm_mstr where cm_mstr.cm_addr = so_ship no-lock.  */

/*M11Z*/          run assign_new_so.
/*M11Z*/       /*************************************************
 * /*L14Q*/      if so_cust <> so_ship
 * /*L14Q*/      then do:
 * /*L14Q*/         if can-find(cm_mstr where cm_mstr.cm_addr = so_ship)
 * /*L14Q*/         then do:
 * /*L14Q*/            for first cm_mstr
 * /*L14Q*/               fields(cm_addr cm_ar_acct cm_ar_cc cm_balance
 * /*L14Q*/                      cm_cr_hold cm_cr_limit cm_cr_terms cm_curr
 * /*L14Q*/                      cm_disc_pct cm_fix_pr cm_fr_list cm_fr_min_wt
 * /*L14Q*/                      cm_fr_terms cm_fst_id cm_lang cm_partial cm_pst
 * /*L14Q*/                      cm_rmks cm_shipvia cm_site cm_slspsn cm_taxable
 * /*L14Q*/                      cm_taxc cm_tax_in)
 * /*L14Q*/               where cm_mstr.cm_addr = so_ship no-lock:
 * /*L14Q*/            end. /* FOR FIRST cm_mstr */
 * /*L14Q*/            so_lang = cm_mstr.cm_lang.
 * /*L14Q*/         end. /* IF CAN-FIND */
 * /*L14Q*/         else
 * /*L14Q*/         do:
 * /*L14Q*/            for first ad_mstr
 * /*L14Q*/               fields(ad_addr ad_city ad_country ad_edi_ctrl
 * /*L14Q*/                      ad_inv_mthd ad_lang ad_line1 ad_line2 ad_name
 * /*L14Q*/                      ad_pst_id ad_state ad_taxable ad_taxc ad_tax_in
 * /*L14Q*/                      ad_tax_usage ad_zip)
 * /*L14Q*/               where ad_addr = so_ship no-lock:
 * /*L14Q*/            end. /* FOR FIRST ad_mstr */
 * /*L14Q*/            so_lang = ad_lang.
 * /*L14Q*/         end. /* ELSE DO */
 * /*L14Q*/      end. /* IF so_cust <> so_ship */
 * /*L14Q*/      else
 * /*L14Q*/         so_lang = cm_mstr.cm_lang.
 **************************************************/ /*M11Z*/

                  assign
                     so_cr_terms = bill_cm.cm_cr_terms
                     so_curr     = bill_cm.cm_curr
                     so_fix_pr   = cm_mstr.cm_fix_pr
                     so_disc_pct = cm_mstr.cm_disc_pct
                     so_shipvia  = cm_mstr.cm_shipvia
                     so_partial  = cm_mstr.cm_partial
                     so_rmks     = cm_mstr.cm_rmks
                     so_site     = cm_mstr.cm_site
                     so_taxable  = cm_mstr.cm_taxable
                     so_taxc     = cm_mstr.cm_taxc
                     so_pst      = cm_mstr.cm_pst
                     so_fst_id   = cm_mstr.cm_fst_id
                     so_pst_id   = ad_pst_id   /*ship-to*/
                     so_fr_list   = cm_mstr.cm_fr_list
                     so_fr_terms  = cm_mstr.cm_fr_terms
                     so_fr_min_wt = cm_mstr.cm_fr_min_wt
/*K0DQ*/             so_userid    = global_userid.

/*L14Q*           so_lang     = ad_lang.        */

                  /* Check Site Security */
                  {gprun.i ""gpsiver.p""
                     "(input so_site, input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  if return_int = 0 then do:
                     {mfmsg02.i 2711 2 so_site} /*USER DOESN'T HAVE ACCESS*/
                                                /*TO DEFAULT SITE XXXX    */
                     so_site = "".
                     display
                        so_site
                     with frame b.
                  end.

                  /* GET DEFAULT TERMS INTEREST FOR ORDER */
                  socrt_int = 0.
                  if so_cr_terms <> "" then do:

/*M11Z**             find ct_mstr where ct_code = so_cr_terms  */
/*M11Z**             no-lock no-error.                          */
/*M11Z*/             for first ct_mstr
/*M11Z*/             fields(ct_code ct_terms_int)
/*M11Z*/             where ct_code = so_cr_terms no-lock:
/*M11Z*/             end. /* FOR FIRST CT_MSTR */

                     if available ct_mstr then socrt_int = ct_terms_int.
                  end. /* SO_CR_TERMS <> "" */

                  /* SET NEW TAX DEFAULTS FOR GLOBAL TAX */
                  if {txnew.i} then do:
                     /* LOAD DEFAULT TAX CLASS & USAGE */
                     find ad_mstr where ad_addr = so_ship no-lock no-error.
                     if not available ad_mstr then
                     find ad_mstr where ad_addr = so_cust no-lock no-error.
                     if available ad_mstr then do:
/*M11Z*/                assign
                           so_taxable   = ad_taxable
                           so_tax_usage = ad_tax_usage
                           so_taxc = ad_taxc.
                     end.
                  end.  /* SET TAX DEFAULTS */

                  /* SET DEFAULTS FOR ALL FOUR SALESPERSONS. */
                  do counter = 1 to 4:

                     so_slspsn[counter] = cm_mstr.cm_slspsn[counter].

                     if cm_mstr.cm_slspsn[counter] <> "" then do:
                        find spd_det where spd_addr = so_slspsn[counter]
                                       and spd_prod_ln = ""
                                       and spd_part = ""
/*H1B3**                and spd_cust = so_cust no-lock no-error. */
/*H1B3*/                               and spd_cust = cm_mstr.cm_addr
/*H1B3*/                no-lock no-error.
                        if available spd_det then
                           so_comm_pct[counter] = spd_comm_pct.
                        else do:
                           find sp_mstr where sp_addr
                              = cm_mstr.cm_slspsn[counter]
                           no-lock no-error.
                           if available sp_mstr then
                              so_comm_pct[counter] = sp_comm_pct.
                        end. /* ELSE IF NOT AVAILABLE SPD_DET */
                     end. /* IF CM_MSTR.CM_SLSPSN[CTR] <> "" */

                  end. /* DO COUNTER = 1 TO 4 */

                  if so_slspsn[2] <> "" or
                     so_slspsn[3] <> "" or
                     so_slspsn[4] <> ""
                  then
                     mult_slspsn = true.
                  else
                     mult_slspsn = false.

                  if bill_cm.cm_ar_acct <> "" then do:
                     so_ar_acct = bill_cm.cm_ar_acct.
                     so_ar_cc   = bill_cm.cm_ar_cc.
                  end.
                  else do:
                     so_ar_acct = gl_ar_acct.
                     so_ar_cc   = gl_ar_cc.
                  end.

               end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* SET DEFAULTS IF NEW SO_MSTR */

               /* Load Default Tax Class and Usage */
               if {txnew.i} then do:
                  if not available ad_mstr then
                  find ad_mstr where ad_addr = so_cust no-lock no-error.
                  if available(ad_mstr) then
                     tax_in  = ad_tax_in.
               end.  /* SET TAX DEFAULTS */
               else
                  tax_in = cm_mstr.cm_tax_in.

               if not new so_mstr and so_invoiced = yes then do:
/*M11Z**         {mfmsg.i 603 2}                 */
/*M11Z*/         run p-mfmsg (input 603, input 2).
                 /* INVOICE PRINTED BUT NOT POSTED, PRESS ENTER TO CONTINUE */
                 if not batchrun then pause.
               end. /* IF NOT NEW SO_MSTR AND SO_INVOICED = YES */

/*M125** /*J3B4*/ if this-is-rma then */
/*M125*/       if this-is-rma
/*M125*/       then do:
/*J3B4*/          for first svc_ctrl
/*J3B4*/          fields(svc_hold_call) no-lock:
/*J3B4*/          end. /* FOR FIRST SVC_CTRL */
/*M125*/          assign
/*M125*/             rma_bill_to = so_bill
/*M125*/             rma_ship    = so_ship.
/*M125*/       end. /* IF this-is-rma */

               /* CHECK CREDIT LIMIT */
               if bill_cm.cm_cr_limit < bill_cm.cm_balance then do:

/*J3B4*/          if this-is-rma then do:

/*J3B4*/             if svc_hold_call = 1 then do:
/*J3B4*/                /* CUSTOMER BALANCE */
/*J3B4*/                {mfmsg02.i  615 2 "bill_cm.cm_balance, "balance_fmt" "}
/*J3B4*/                /* CREDIT LIMIT */
/*J3B4*/                {mfmsg02.i  617 1 "bill_cm.cm_cr_limit,"limit_fmt" "}
/*J3B4*/                if so_stat = "" then do:
/*J3B4*/                   /* RMA ORDER PLACED ON CREDIT HOLD */
/*J3B4*/                   {mfmsg03.i 690 1 """RMA Order""" """" """" }
/*J3B4*/                   assign so_stat = "HD".
/*J3B4*/                end. /* IF SO_STAT = "" */
/*J3B4*/             end. /* IF SVC_HOLD_CALL = 1 */

/*J3B4*/             if svc_hold_call = 2 then do:
/*J3B4*/                /* CUSTOMER BALANCE */
/*J3B4*/                {mfmsg02.i  615 4 "bill_cm.cm_balance, "balance_fmt" "}
/*J3B4*/                /* CREDIT LIMIT */
/*J3B4*/                {mfmsg02.i  617 1 "bill_cm.cm_cr_limit,"limit_fmt" "}
/*J3B4*/                assign local-undo = 2.
/*J3B4*/                undo trans2, leave.     /* MUST UNDO RMA CREATION */
/*J3B4*/             end. /* IF SVC_HOLD_CALL = 2 */

/*J3B4*/          end. /* IF THIS-IS-RMA */

/*J3B4*/          else do:
                     {mfmsg02.i  615 2 "bill_cm.cm_balance, "balance_fmt" "}
                     {mfmsg02.i  617 1 "bill_cm.cm_cr_limit,"limit_fmt" "}
                     if so_stat = "" and soc_cr_hold then do:
                        {mfmsg03.i 690 1 ""{&sosomta1_p_9}"" """" """" }
                        /* SALES ORDER PLACED ON CREDIT HOLD */
                        so_stat = "HD".
                     end. /* IF SO_STAT = "" AND SOC_CR_HOLD */
/*J3B4*/          end. /* ELSE DO */

               end. /* IF CM_CR_LIMIT < CM_BALANCE */

               /* CHECK CREDIT HOLD */
               if new so_mstr and bill_cm.cm_cr_hold  then do:

/*J04C*           ADDED THE FOLLOWING */
                  if this-is-rma then do:
/*J3B4**             find first svc_ctrl no-lock no-error.  */
                     if svc_hold_call = 1 then do:
/*M11Z**                {mfmsg.i 614 2}                */
/*M11Z*/                run p-mfmsg (input 614, input 2).
                        /* CUSTOMER ON CREDIT HOLD */
                        so_stat = "HD".
                     end.
                     else if svc_hold_call = 2 then do:
/*M11Z**                {mfmsg.i 614 3}   */
/*M11Z*/                run p-mfmsg (input 614, input 3).
/*J0M3*                 not_okay = 2.   */
/*J0M3*                 return.         */
/*J0M3*/                local-undo = 2.
/*J0M3*/                undo trans2, leave.     /* MUST UNDO RMA CREATION */
                     end.
                  end.    /* if this-is-rma */
                  else do:
/*J04C*           END ADDED CODE */
/*M11Z**             {mfmsg.i  614 2 }               */
/*M11Z*/             run p-mfmsg (input 614, input 2).
                     so_stat = "HD".
/*J04C*/          end.    /* else, this isn't an RMA */

               end.

/*J04C*/       if this-is-rma then
/*J04C*/          rma-recno = recid(rma_mstr).
/*J04C*/       else
/*J04C*/          rma-recno = ?.

               /* UPDATE FRAME B - HEADER, TAX, SLSPSNS, FRT, ALLOCS */
               {sosomtdi.i} /* DISPLAY SO_ORD_DATE, ETC IN FRAME B */

               undo_flag = true.
/*K1FK*        {gprun.i ""sosomtp.p""} */
/*K1FK*/       {gprun.i ""sosomtp.p"" "(input this-is-rma)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               /* IF UNDO_FLAG THEN NEXT MAINLOOP (IN SOSOMT.P). */
               /* JUMP OUT IF S.O. WAS (SUCCESSFULLY) DELETED */
               if not can-find(so_mstr where so_nbr = input so_nbr)
               then do:
/*J0M3*           not_okay = 1.    */
/*J0M3*           return.          */
/*J0M3*/          local-undo = 1.
/*J0M3*/          leave trans2.     /* SO'S ALREADY BEEN DELETED - NOTHING TO UNDO */
               end. /* IF NOT CAN-FIND(SO_MSTR..) */

               if undo_flag then do:
/*J0M3*           not_okay = 2.      */
/*J0M3*           return.            */
/*J0M3*/          local-undo = 2.
/*J0M3*/          undo trans2, leave.  /* AN UNKNOWN ERROR OCCURRED NEEDING UNDO. */
               end. /* IF UNDO_FLAG */

/*J0ZZ*        if (oldcurr <> so_curr) then do:            */
/*J0ZZ*/       if (oldcurr <> so_curr) or oldcurr = "" then do:

                  /* SET CURRENCY DEPENDENT FORMATS */
                  {socurfmt.i}

                  /* SET THE CURRENCY DEPENDENT FORMAT FOR PREPAID */
                  prepaid_fmt = prepaid_old.
                  {gprun.i ""gpcurfmt.p""
                     "(input-output prepaid_fmt, input rndmthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  oldcurr = so_curr.

               end. /* IF OLDCURR <> SO_CURR */

/*J28V**       if promise_date = ? then promise_date = so_due_date. */

/*J28V*/       /* FOR RMAs,IF THE HEADER PROMISE DATE (promise_date) is LEFT */
/*J28V*/       /* BLANK, SET IT TO THE HEADER DUE DATE (so_req_date)         */
/*J28V*/       if promise_date = ? then do :
/*J28V*/          if this-is-rma then
/*J28V*/             promise_date = so_req_date.
/*J28V*/          else
/*J28V*/             promise_date = so_due_date.
/*J28V*/       end. /* IF promise_date = ? */

               if so_req_date = ? then
                  so_req_date = so_due_date.

/*J0KJ*/       if so_fsm_type <> "" and so_pricing_dt = ? then
/*J0KJ*/           so_pricing_dt = so_ord_date.

               if so_pricing_dt = ? then do:
                  if pic_so_date = "ord_date" then
                     so_pricing_dt = so_ord_date.
                  else
                  if pic_so_date = "req_date" then
                     so_pricing_dt = so_req_date.
                  else
                  if pic_so_date = "per_date" then
                     so_pricing_dt = promise_date.
                  else
                  if pic_so_date = "due_date" then
                     so_pricing_dt = so_due_date.
                  else
                     so_pricing_dt = today.
               end. /* IF SO_PRICING_DT = ? */

/*J04C*        ADDED THE FOLLOWING */
               if this-is-rma then do:
                  /* LET USER ENTER OTHER RMA-HEADER-SPECIFIC FIELDS */
                  {gprun.i ""fsrmah1.p""
                            "(input rma-recno,
                              input recid(so_mstr),
                              input new_order,
                              output undo_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  if undo_flag then
                     undo order-header, retry order-header.
               end. /* if this-is-rma */
/*J04C*         END ADDED CODE */

            end. /* ORDER HEADER */

/*M11Z* /*K004*/    s-prev-so-stat = so_stat. */

            if rebook_lines then do:
               {gprun.i ""sosomtrb.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

               rebook_lines = false.
            end.

            /* DETAIL - FIND LAST LINE */
            line = 0.

/*J0KJ**    NO LONGER NECESSARY SINCE INVOICED pih_hist MOVES TO iph_hist
**          find last pih_hist where pih_doc_type = 1 and
**                    pih_nbr      = so_mstr.so_nbr
**              use-index pih_nbr no-lock no-error.
**          if available pih_hist then
**             line = pih_line.
**          else do:
**J0KJ*/
            find last sod_det where sod_nbr = so_mstr.so_nbr
            use-index sod_nbrln no-lock no-error.
            if available sod_det then
               line = sod_line.

/*J0KJ**    end. /* ELSE IF NOT AVAILABLE PIH_HIST */ */

            /* Check for custom program set up in menu system */
/*J04C*/    if this-is-rma then do:
/*J04C*/       {fsmnp02.i ""fsrmamt.p"" 10
                        """(input so_recno, input rma-recno)"""}
/*J04C*/    end.
/*J04C*/    else do:
/*J04C*          ADDED INPUT PARAMETER */
               {fsmnp02.i ""sosomt.p"" 10
                       """(input so_recno)"""}
/*J04C*/    end.

/*M11Z*/    /* If EMT, determine the Comment Type */
/*M11Z*/    run determine-bu-lvl
/*M11Z*/       (output emt-bu-lvl).

            /* COMMENTS */
/*M11Z*/    assign
               global_lang = so_mstr.so_lang
               global_type = "".

            if socmmts = yes then do:
/*M11Z*/       assign
                  cmtindx    = so_mstr.so_cmtindx
                  global_ref = so_mstr.so_cust
/*M11Z*/          save_part  = global_part
/*M11Z*/          global_part = emt-bu-lvl.
               {gprun.i ""gpcmmt01.p"" "(input ""so_mstr"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*M11Z*/       assign
                  so_mstr.so_cmtindx = cmtindx
/*M11Z*/          global_part = save_part.
/*J04C*/       if this-is-rma then
/*J04C*/          rma_mstr.rma_cmtindx = cmtindx.
            end. /* IF SOCMMTS = YES */

            /* GET SHIP-TO NUMBER IF CREATING NEW SHIP-TO */
            if so_mstr.so_ship = "qadtemp" + mfguser then do:
/*M11Z*/       run create-new-shipto
                  (output l-shipto).
/*M11Z*/       so_mstr.so_ship = l-shipto.
/*M11Z*/       /**************************************************
 *              find ad_mstr where ad_addr = so_mstr.so_ship exclusive-lock.
 *              {mfactrl.i cmc_ctrl cmc_nbr ad_mstr ad_addr so_mstr.so_ship}
 *              ad_addr = so_mstr.so_ship.
 *              create ls_mstr.
 *              assign
 *                 ls_type = "ship-to"
 *                 ls_addr = so_mstr.so_ship.
 *              {mfmsg02.i 638 1 so_mstr.so_ship}
 *****************************************************/ /*M11Z*/
            end. /* IF SO_SHIP = "qadtemp" + MFGUSER */

            /* IF THEY'VE MADE IT TO HERE, ALL IS WELL */
/*J0M3*/    local-undo = 0.

         end. /* DO TRANSACTION #2 */

/*J0M3*/ if local-undo = 0 then do:
            /*INITIALIZE QTY ACCUMULATION WORKFILES USED BY BEST PRICING*/
            {gprun.i ""gppiqty1.p"" "(input ""1"",
                    input so_mstr.so_nbr,
                    input yes,
                    input yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J0M3*/ end.  /* if local-undo = 0 */

         hide frame sold_to no-pause.
         hide frame ship_to no-pause.
/*J2ZM*/ hide frame ship_to1 no-pause.
/*J2ZM*/ hide frame ship_to2 no-pause.
         hide frame b1 no-pause.
         hide frame b no-pause.
         hide frame a no-pause.
/*J0M3*/ not_okay = local-undo.

/*M11Z*/ PROCEDURE p-mfmsg:

            define input parameter l_num  as integer no-undo.
            define input parameter l_stat as integer no-undo.
            {mfmsg.i l_num l_stat}

/*M11Z*/ END PROCEDURE. /* PROCEDURE P-MFMSG */

/*M11Z*/ PROCEDURE assign_new_so:

            if so_mstr.so_cust <> so_mstr.so_ship
            then do:
               if can-find(cm_mstr where cm_mstr.cm_addr = so_ship)
               then do:
                  for first cm_mstr
                     fields(cm_addr cm_ar_acct cm_ar_cc cm_balance
                            cm_cr_hold cm_cr_limit cm_cr_terms cm_curr
                            cm_disc_pct cm_fix_pr cm_fr_list cm_fr_min_wt
                            cm_fr_terms cm_fst_id cm_lang cm_partial cm_pst
                            cm_rmks cm_shipvia cm_site cm_slspsn cm_taxable
                            cm_taxc cm_tax_in)
                     where cm_mstr.cm_addr = so_mstr.so_ship no-lock:
                  end. /* FOR FIRST cm_mstr */
                  so_mstr.so_lang = cm_mstr.cm_lang.
               end. /* IF CAN-FIND */
               else
               do:
                  for first ad_mstr
                     fields(ad_addr ad_city ad_country ad_edi_ctrl
                            ad_inv_mthd ad_lang ad_line1 ad_line2 ad_name
                            ad_pst_id ad_state ad_taxable ad_taxc ad_tax_in
                            ad_tax_usage ad_zip)
                     where ad_addr = so_mstr.so_ship no-lock:
                  end. /* FOR FIRST ad_mstr */
                  so_mstr.so_lang = ad_lang.
               end. /* ELSE DO */
            end. /* IF so_cust <> so_ship */
            else
               so_mstr.so_lang = cm_mstr.cm_lang.

/*M11Z*/ END PROCEDURE. /* PROCEDURE assign_new_so */

/*M11Z*/ PROCEDURE determine-bu-lvl:
/*M11Z*/    define output parameter p-emt-bu-lvl like global_part.

/*M11Z*/       p-emt-bu-lvl = "".
/*M11Z*/        if soc_ctrl.soc_use_btb then do:
/*M11Z*/          if so_mstr.so_primary and not so_mstr.so_secondary then
/*M11Z*/             p-emt-bu-lvl = "PBU".
/*M11Z*/          else if so_mstr.so_primary and so_mstr.so_secondary then
/*M11Z*/             p-emt-bu-lvl = "MBU".
/*M11Z*/          else if so_mstr.so_secondary then
/*M11Z*/             p-emt-bu-lvl = "SBU".
/*M11Z*/       end.

/*M11Z*/ END PROCEDURE.

/*M11Z*/ PROCEDURE create-new-shipto:

            define output parameter p-shipto like so_mstr.so_ship.

            find ad_mstr where ad_addr = "qadtemp" + mfguser exclusive-lock.

            /* Get Next Record Number */
            {mfactrl.i cmc_ctrl cmc_nbr ad_mstr ad_addr p-shipto}

            ad_addr = p-shipto.

            create ls_mstr.
            assign
               ls_type = "ship-to"
               ls_addr = p-shipto.

            if recid(ls_mstr) = -1 then.

            /* Ship-To Record Added */
            {mfmsg02.i 638 1 p-shipto}

/*M11Z*/ END PROCEDURE.
