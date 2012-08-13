/* GUI CONVERTED from sosomta.p (converter v1.69) Wed Sep 10 15:19:31 1997 */
/* sosomta.p - SALES ORDER MAINTENANCE SINGLE LINE ITEMS                */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 03/19/90   BY: ftb *D007*          */
/* REVISION: 6.0      LAST MODIFIED: 04/06/90   BY: ftb *D002*added site*/
/* REVISION: 6.0      LAST MODIFIED: 04/10/90   BY: MLB *D021*          */
/* REVISION: 6.0      LAST MODIFIED: 07/06/90   BY: EMB *D040*          */
/* REVISION: 6.0      LAST MODIFIED: 08/09/90   BY: MLB *D055*          */
/* REVISION: 6.0      LAST MODIFIED: 12/06/90   BY: MLB *D238*          */
/* REVISION: 6.0      LAST MODIFIED: 12/14/90   BY: AFS *D260*          */
/* REVISION: 6.0      LAST MODIFIED: 04/10/91   BY: WUG *D512*          */
/* REVISION: 6.0      LAST MODIFIED: 09/17/91   BY: MLV *F015*          */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*          */
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 11/13/91   BY: WUG *D887*          */
/* REVISION: 6.0      LAST MODIFIED: 11/18/91   BY: afs *D934*          */
/* REVISION: 7.0      LAST MODIFIED: 03/23/92   BY: dld *F297*          */
/* REVISION: 7.0      LAST MODIFIED: 03/27/92   BY: pma *F315*          */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: afs *F356*          */
/* REVISION: 7.0      LAST MODIFIED: 04/16/92   BY: dld *F382*          */
/* REVISION: 7.0      LAST MODIFIED: 05/06/92   BY: tjs *F470*          */
/* REVISION: 7.0      LAST MODIFIED: 06/10/92   BY: tjs *F504*          */
/* REVISION: 7.3      LAST MODIFIED: 09/15/92   BY: tjs *G035*          */
/* REVISION: 7.3      LAST MODIFIED: 11/17/92   BY: tjs *G191*          */
/* REVISION: 7.3      LAST MODIFIED: 01/15/93   BY: afs *G501*          */
/* REVISION: 7.3      LAST MODIFIED: 01/21/93   BY: tjs *G579*          */
/* REVISION: 7.3      LAST MODIFIED: 02/04/93   BY: bcm *G415*          */
/* REVISION: 7.3      LAST MODIFIED: 02/24/93   BY: sas *G457*          */
/* REVISION: 7.3      LAST MODIFIED: 04/05/93   BY: bcm *G889*          */
/* REVISION: 7.3      LAST MODIFIED: 04/15/93   BY: tjs *G948*          */
/* REVISION: 7.4      LAST MODIFIED: 06/21/93   BY: pcd *H008*          */
/* REVISION: 7.4      LAST MODIFIED: 10/10/93   BY: cdt *H086*          */
/* REVISION: 7.4      LAST MODIFIED: 10/2/93    BY: cdt *H184*          */
/* REVISION: 7.4      LAST MODIFIED: 11/03/93   BY: bcm *H206*          */
/* REVISION: 7.4      LAST MODIFIED: 11/22/93   BY: afs *H238*          */
/* REVISION: 7.4      LAST MODIFIED: 01/13/94   BY: dpm *GI46*          */
/* REVISION: 7.4      LAST MODIFIED: 02/18/94   BY: afs *FL81*          */
/* REVISION: 7.4      LAST MODIFIED: 03/16/94   BY: afs *H295*          */
/* REVISION: 7.4      LAST MODIFIED: 03/28/94   BY: WUG *GJ21*          */
/* REVISION: 7.4      LAST MODIFIED: 04/08/94   BY: afs *H330*          */
/* REVISION: 7.3      LAST MODIFIED: 04/25/94   BY: cdt *GJ56*          */
/* REVISION: 7.4      LAST MODIFIED: 07/11/94   BY: bcm *H438*          */
/* REVISION: 7.4      LAST MODIFIED: 09/13/94   BY: bcm *H494*          */
/* REVISION: 7.4      LAST MODIFIED: 09/22/94   BY: jpm *GM78*          */
/* REVISION: 7.4      LAST MODIFIED: 10/16/94   BY: dpm *FR95*          */
/* REVISION: 7.3      LAST MODIFIED: 11/01/94   BY: ame *GN90*          */
/* REVISION: 7.3      LAST MODIFIED: 11/16/94   BY: qzl *FT43*          */
/* REVISION: 7.4      LAST MODIFIED: 12/14/94   BY: rxm *F09F*          */
/* REVISION: 7.4      LAST MODIFIED: 01/28/95   BY: ljm *G0D7*          */
/* REVISION: 7.4      LAST MODIFIED: 01/31/95   BY: bcm *F0G8*          */
/* REVISION: 8.5      LAST MODIFIED: 02/17/95   BY: dpm *J044*          */
/* REVISION: 7.4      LAST MODIFIED: 02/27/95   BY: jzw *H0BM*          */
/* REVISION: 7.4      LAST MODIFIED: 03/02/95   BY: aep *F0K6*          */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: rxm *F0PJ*          */
/* REVISION: 8.5      LAST MODIFIED: 03/05/95   BY: DAH *J042*          */
/* REVISION: 7.4      LAST MODIFIED: 06/15/95   BY: rxm *G0Q5*          */
/* REVISION: 7.3      LAST MODIFIED: 10/12/95   BY: ais *G0Z8*          */
/* REVISION: 8.5      LAST MODIFIED: 11/07/95   BY: taf *J053*          */
/* REVISION: 8.5      LAST MODIFIED: 12/05/95   BY: *J04C* Tom Vogten   */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: *J04C* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 04/29/96   BY: *J0KJ* Dennis Henson*/
/* REVISION: 8.5      LAST MODIFIED: 05/22/96   BY: *J0N2* Dennis Henson*/
/* REVISION: 8.5      LAST MODIFIED: 07/04/96   BY: *J0XR* Dennis Henson*/
/* REVISION: 8.5      LAST MODIFIED: 07/15/96   BY: ajw *J0Z6*          */
/* REVISION: 8.5      LAST MODIFIED: 07/23/96   BY: ajw *J0R1*          */
/* REVISION: 8.5      LAST MODIFIED: 08/01/96   BY: *J13C* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 09/12/96   BY: *J152* Suresh Nayak */
/* REVISION: 8.5      LAST MODIFIED: 09/18/96   BY: *G2F7* Sanjay Patil */
/* REVISION: 8.5      LAST MODIFIED: 10/02/96   BY: *J15C* Markus Barone*/
/* REVISION: 8.5      LAST MODIFIED: 01/08/97   BY: *J1DS* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 02/15/97   BY: *J1L2* Suresh Nayak */
/* REVISION: 8.5      LAST MODIFIED: 02/21/97   BY: *H0SM* Suresh Nayak */
/* REVISION: 8.5      LAST MODIFIED: 06/19/97   BY: *J1TL* Molly Balan  */
/* REVISION: 8.5      LAST MODIFIED: 05/21/97   BY: *J1RY* Tim Hinds    */

          {mfdeclre.i}

/*J04C*/    define input parameter this-is-rma      like mfc_logical.
/*J04C*/    define input parameter rma-recno        as  recid.
/*J04C*/    define input parameter rma-issue-line   like mfc_logical.

            define new shared workfile sobfile no-undo
                field sobpart like sob_part
                field sobsite like sob_site
                field sobissdate like sob_iss_date
                field sobqtyreq like sob_qty_req
                field sobconsume like sob_qty_req
                field sobabnormal like sob_qty_req.

/*J042***********************************
**            define new shared stream   bi.
**            define new shared frame    bi.
**J042**********************************/

/*J042*/    define     shared stream bi.
/*J042*/    define     shared frame  bi.

/*J053*/    /* DEFINE RNDMTHD FOR CALL TO SOSOMTLA.P */
/*J053*/    define shared variable rndmthd like rnd_rnd_mthd.
            define new shared variable pl               like pt_prod_line.
            define new shared frame    c.
            define new shared frame    d.
            define new shared variable undo_all         like mfc_logical
                                                        initial no.
            define new shared variable sod_recno        as recid.
            define new shared variable sodcmmts         like soc_lcmmts
                                                        label "说明".
            define new shared variable prev_consume     like sod_consume.
            define new shared variable clines           as integer.
            define new shared variable sod-detail-all   like soc_det_all.
            define new shared variable sodreldate       like sod_due_date.
            define new shared variable prev_type        like sod_type.
            define new shared variable prev_site        like sod_site.
/*F504*/    define new shared variable new_line         like mfc_logical.
/*GJ56*/ /* define new shared variable soc_isb_window   like mfc_logical. */
/*J04C*     SOC_EDIT_ISB HAS BEEN MOVED FROM MFC_CTRL TO SOC_CTRL */
/*J04C* /*GJ56*/ define new shared variable soc_edit_isb     like mfc_logical. */
/*G457*/    define new shared variable solinerun        as character.
/*G948*/    define new shared variable delete_line      like mfc_logical.
/*FL81*/    define new shared variable sonbr            like sod_nbr.
/*FL81*/    define new shared variable soline           like sod_line.
/*H295*/    define new shared variable new_site         like sod_site.
/*H295*/    define new shared variable err_stat         as integer.

/*J0R1*/    define new shared variable temp_sod_qty_ord  like sod_qty_ord.
/*J0R1*/    define new shared variable temp_sod_qty_ship like sod_qty_ship.
/*J0R1*/    define new shared variable temp_sod_qty_all  like sod_qty_all.
/*J0R1*/    define new shared variable temp_sod_qty_pick like sod_qty_pick.

            define     shared variable all_days         as integer.
            define     shared variable base_amt         like ar_amt.
/*H494*/    define     shared variable calc_fr          like mfc_logical.
            define     shared variable consume          like sod_consume.
            define     shared variable del-yn           like mfc_logical.
/*F040*/    define     shared variable inv_db           like dc_name.
            define     shared variable line             like sod_line.
/*F297*/    define     shared variable mult_slspsn      like mfc_logical
                                                        no-undo.
            define     shared variable part             as character
                                                        format "x(18)".
            define     shared variable prev_due         like sod_due_date.
            define     shared variable prev_qty_ord     like sod_qty_ord.
            define     shared variable promise_date     as date
                                                        label "承诺日期".
            define     shared variable qty              like sod_qty_ord.
            define     shared variable sngl_ln          like soc_ln_fmt.
/*H0SM*/    define            variable l_sngl_ln        like soc_ln_fmt no-undo.
/*F040*/    define     shared variable so_db            like dc_name.
            define     shared variable so_recno         as recid.
            define     shared variable so-detail-all    like soc_det_all.
/*H086*/    define     shared variable soc_pc_line      like mfc_logical.
/*H184*/    define     shared variable socrt_int        like sod_crt_int.
            define     shared variable tax_in           like cm_tax_in.

/*G457*/    define variable cchar           as character.
            define variable desc1           like pt_desc1.
/*FL81*/    define variable err-flag        as integer.
            define variable first_time      like mfc_logical initial yes.
            define variable i               as integer.
/*G889*/    define variable j               as integer.
            define variable open_qty        like mrp_qty.
            define variable prev_abnormal   like sod_abnormal.
/*F315*/    define variable ptstatus        like pt_status.
/*G889*/    define buffer   sod_buff        for sod_det.
/*G889*/    define variable vtclass         as character extent 3.
/*J044*/    define variable imp-okay like mfc_logical no-undo.
/*J04C*/    define variable frametitle      as character format "x(20)".
/*J04C*/    define variable frametitle-so   as character format "x(20)"
/*J04C*/           initial "     客户订单项     ".
/*J04C*/    define variable frametitle-rma-iss  as  character format "x(20)"
/*J04C*/           initial "  退料核准单发放项  ".
/*J04C*/    define variable frametitle-rma-rec  as  character format "x(20)"
/*J04C*/           initial " 退料核准单收货项 ".
/*J04C*/    define variable rmd-recno           as  recid.
/*J04C*/    define variable rma-line-type       like sod_fsm_type initial " ".

            /* THESE 'HANDLE' VARIABLES ARE USED TO GIVE DIFFERENT LABELS */
            /* TO FIELDS WHEN MAINTAINING RMA RECEIPT LINES               */
/*J04C*/    define variable hdl-ord-qty-field   as  handle.
/*J04C*/    define variable hdl-ship-qty-field  as  handle.
/*J04C*/    define variable hdl-order-nbr-field as  handle.
/*J04C*/    define variable hdl-due-date-field  as  handle.

/*J042*/    define new shared variable discount as decimal label "折扣"
                                                           format "->>>9.9<<<".
/*J042*/    define new shared variable reprice_dtl      like mfc_logical
                                                        label "重新定价".
/*J042*/    define     shared variable reprice          like mfc_logical.
/*J042*/    define     shared variable line_pricing     like mfc_logical.
/*J042*/    define     shared variable new_order        like mfc_logical.
/*J042*/    define new shared variable save_parent_list like sod_list_pr.
/*J0N2*/    define            variable disc_min_max     like mfc_logical.
/*J0N2*/    define            variable disc_pct_err     as decimal.
/*J0N2*/    define new shared variable save_qty_ord     like sod_qty_ord.

/*J04C*/    define buffer   rmdbuff             for rmd_det.
/*G2F7*/    define variable l_tmp_string1 as character no-undo.

/*J1RY*/    define new shared variable cf_pm_code     like pt_pm_code.
/*J1RY*/    define new shared variable cf_pt_part_o   like pt_part.
/*J1RY*/    define new shared variable cf_pt_part_n   like pt_part     no-undo.
/*J1RY*/    define new shared variable cf_line        like sod_line    no-undo.
/*J1RY*/    define new shared variable cf_rp_part     like mfc_logical no-undo.
/*J1RY*/    define shared variable cfexists           like mfc_logical.
/*J1RY*/    define shared variable cf_cfg_path        like mfc_char.
/*J1RY*/    define shared variable cf_chr               as character.
/*J1RY*/    define variable cf_sod__qadc01            like sod__qadc01.

         /* READ SO_MSTR EARLY SO WE'RE ABLE TO SET THE MULTIPLE SALESPERSON
            FLAG FOR ITS DISPLAY.  PREVENT A TRANSACTION BEING SCOPED TO THIS
            ENTIRE PROCEDURE BLOCK BY NOT LOCKING RECORDS HERE. */
/*J13C*  find so_mstr where recid(so_mstr) = so_recno. */
/*J13C*/ find so_mstr where recid(so_mstr) = so_recno no-lock.
         find first soc_ctrl no-lock.
         find first gl_ctrl no-lock.
/*J042*/ find first pic_ctrl no-lock.

         /* IF WE'RE IN RMA MAINTENANCE, READ RMA/SERVICE CONTROL */
         /* FILES AND RELATED RECORDS.                            */
/*J04C*/ if this-is-rma then do:
/*J04C*/    find first rmc_ctrl no-lock no-error.
/*J04C*/    find first svc_ctrl no-lock no-error.
/*J04C*/    find rma_mstr where recid(rma_mstr) = rma-recno
/*J13C*/        no-lock no-error.
/*J13C* /*J04C*/        exclusive-lock no-error.  */
/*J13C* /*J04C*/    assign rma-recno = recid(rma_mstr).     */
/*J04C*/    find eu_mstr where eu_addr = rma_enduser
/*J04C*/        no-lock no-error.
/*J04C*/    if rma-issue-line then
/*J04C*/        rma-line-type = "RMA-ISS".
/*J04C*/    else
/*J04C*/        rma-line-type = "RMA-RCT".
/*J04C*/ end.
/*J04C*/ else
/*J04C*/    assign rma-recno = ?.

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/*GM78*/ 
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
space(1)
         so_nbr
         so_cust
         sngl_ln
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*F297*/ /* SET DISPLAY OF THE MULTIPLE SALESPERSON FLAG          */
/*F297*/ /* MULPITLE COMMISSION UPDATES WILL ONLY HAPPEN IF TRUE. */
/*F297*/ if so_slspsn[2] <> "" or so_slspsn[3] <> "" or so_slspsn[4] <> ""
/*F297*/    then mult_slspsn = true.
/*F297*/ else mult_slspsn = false.

/*GJ56*/ /* Use an mfc_ctrl's logical field for the Edit ISB Default */
/*GJ56*/ /* pop-up window control.                                   */
/*GJ56*/ /* mfctrl01.i  mfc_ctrl                                     */
/*GJ56*/ /*         soc_isb_window                                   */
/*GJ56*/ /*         cchar                                            */
/*GJ56*/ /*         no                                               */
/*GJ56*/ /*         no}                                              */
/*GJ56*/ /* if cchar = "yes" then                                    */
/*GJ56*/ /*     soc_isb_window = yes.                                */

/*J04C*  SOC_EDIT_ISB IS NOW IN SOC_CTRL
./*GJ56*/ do transaction on error undo, retry:
./*GJ56*/    find first mfc_ctrl where mfc_field = "soc_edit_isb"
./*GJ56*/    no-lock no-error.
./*GJ56*/    if available mfc_ctrl then
./*GJ56*/       soc_edit_isb = mfc_logical.
./*GJ56*/ end.
.*J04C*/

/*J04C*  ADDED THE FOLLOWING */
         /* PREPARE FOR POSSIBLE USER EXIT PROGRAMS */
         if this-is-rma then do:
            if rma-issue-line then do:
                {fsmnp01.i    ""fsrmamt.p""
                                20
                                solinerun}            /****issues****/

            end.    /* if rma-issue-line */
            else do:
                {fsmnp01.i    ""fsrmamt.p""
                                30
                                solinerun}            /****returns***/
            end.
         end.   /* if this-is-rma */
         else do:
/*J04C*  END ADDED CODE */
/*G457*//*LB01*/{fsmnp01.i   ""zzsosomt.p""
                       20
                       solinerun}
/*J04C*/ end.

/*FR95*/ if sngl_ln then clines = 1.

/*LB01**FR95*/ {zzsolinfrm.i} /* Define shared frames */

/*G0D7*/ /*V8:HiddenDownFrame=c */
/*J04C* /*G0D7*/ /*V8:HiddenDownFrame=d */  */

         /* FOR RMA'S, IT'S BETTER IF THE SO_NBR LABEL DOESN'T READ  */
         /* "SALES ORDER", AND WE HAVE DIFFERENT LABELS FOR DUE DATE */
         /* AND SOME CHANGES FOR RMA RECEIPT LINES REGARDING QTYS    */
/*J04C*/ if this-is-rma then do:
/*J04C*/    assign
/*J04C*/        hdl-order-nbr-field       = so_nbr:handle
/*J04C*/        hdl-order-nbr-field:label = "RMA"
/*J04C*/        hdl-due-date-field        = sod_due_date:handle.
/*J04C*/    if rma-issue-line then
/*J04C*/            hdl-due-date-field:label = "到期日期".
/*J04C*/    else
/*J04C*/        assign
/*J04C*/            hdl-ord-qty-field        = sod_qty_ord:handle
/*J04C*/            hdl-ord-qty-field:label  = "退货数量"
/*J04C*/            hdl-ship-qty-field       = sod_qty_ship:handle
/*J04C*/            hdl-ship-qty-field:label = "退货量"
/*J04C*/            hdl-due-date-field:label = "预期日期".
/*J04C*/ end.   /* if this-is-rma */

         linefmt: repeat on endkey undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


/*H0SM*/    assign l_sngl_ln = sngl_ln.
            if not first_time then
            update sngl_ln with frame a.

/*H0SM*/    if l_sngl_ln <> sngl_ln then
/*H0SM*/       clear frame c all no-pause.

            clines = ?.
            if sngl_ln then clines = 1.
            first_time = no.

/*J0XR** /*J042*/    reprice_dtl = reprice. */

/*J04C*/       if this-is-rma then
/*J04C*/            if rma-issue-line then
/*J04C*/                assign frametitle = frametitle-rma-iss.
/*J04C*/            else
/*J04C*/                assign frametitle = frametitle-rma-rec.
/*J04C*/       else
/*J04C*/            assign frametitle = frametitle-so.

            mainloop:
            repeat with frame c down on endkey undo, next linefmt:
/*GUI*/ if global-beam-me-up then undo, leave.


/*J0XR*/       reprice_dtl = reprice.

               display so_nbr so_cust sngl_ln with frame a.

/*FR95*        {solinfrm.i} /* Define shared frames */ */
/*FR95*/ /* need this hide/view scheme to re-realize frames when they change.*/
/*FR95*/       hide frame d.
               hide frame c.
               view frame c. /*to re-realize if single/multi line changes */
/*FR95*/       /*Removed V8! code */
               if sngl_ln then view frame d.

               {mfdel.i sobfile}

/*J04C*/       if this-is-rma then
/*J04C*/            sodcmmts = rmc_lcmmts.
/*J04C*/       else
                    sodcmmts = soc_lcmmts.
               sod-detail-all = so-detail-all.

               /* RMA RECEIPT LINES DO NOT GET ALLOCATIONS */
/*J04C*/       if this-is-rma and not rma-issue-line
/*J04C*/            then sod-detail-all = no.

/*F0PJ*/       /* SCREENS & REPORTS DON'T SUPPORT 4 DIGIT LINE NOS. */
/*F0PJ*/       if line < 999 then
                  line = line + 1.
/*F0PJ*/       else
/*F0PJ*/       if line = 999 then do:
/*F0PJ*/          {mfmsg.i 7418 2}  /* LINE CANNOT BE > 999 */
/*F0PJ*/       end.

               find sod_det where sod_nbr = so_nbr and sod_line = line
               no-lock no-error.

/*J04C*        ADDED THE FOLLOWING */
               /* IF WE'RE MAINTAINING RMA'S, AN INPUT PARAMETER TOLD US */
               /* WHETHER WE'RE CURRENTLY DOING THE ISSUE OR RECEIPT     */
               /* LINES, AND RMA-LINE-TYPE NOW CONTAINS THE LITERAL      */
               /* WHICH SOD_DET'S USE TO IDENTIFY THIS TYPE OF LINE...   */
               /* SO, LOOK FOR THEM...                                   */

               if this-is-rma then do:
                    do while available sod_det
                        and sod_fsm_type <> rma-line-type:
                        find next sod_det where sod_nbr = so_nbr
                            no-lock no-error.
                    end.
                    if available sod_det then
                        if sod_line < 999 then
                            assign line = sod_line + 1.
                        else  do:
                            line = 999.
                            {mfmsg.i 7418 2}  /* LINE CANNOT BE > 999 */
                        end.
               end.     /* if this-is-rma */
/*J04C*        END ADDED CODE */

/*FR95*/       if not available sod_det
/*J04C*/       or (this-is-rma and
/*J04C*/           sod_fsm_type <> rma-line-type)
/*FR95*/       then do:
/*J042*/          discount = if not pic_so_fact then
/*J042*/                        0
/*J042*/                     else
/*J042*/                        1.
/*FR95*/          display line
/*FR95*/           "" @ sod_part
/*FR95*/           0  @ sod_qty_ord
/*FR95*/           "" @ sod_um
/*FR95*/           0  @ sod_list_pr
/*J042** /*FR95*/  0  @ sod_disc_pct **/
/*J042*/           discount
/*FR95*/           0  @ sod_price
/*FR95*/          with frame c.
/*FR95*/       end.
/*J04C*        if available sod_det then do:        */
/*J04C*/       else do:
/*GM78            desc1 = "ITEM NOT IN INVENTORY".  */
/*GM78*/          desc1 = "零件无库存".
                  find pt_mstr where pt_part = sod_part no-lock
                     no-error no-wait.
                  if available pt_mstr then
                     desc1 = pt_desc1.
                  else
                     if sod_desc <> "" then desc1 = sod_desc.
/*J042*/             /* DETERMINE DISCOUNT DISPLAY FORMAT AND SET VARIABLE discount
                        ACCORDINGLY */
/*J042*/             {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}
                     display line sod_part sod_qty_ord sod_um
/*J042**             sod_list_pr sod_disc_pct sod_price */
/*J042*/             sod_list_pr discount sod_price
                     with frame c.

                     if sngl_ln then
                        display sod_qty_all sod_qty_pick
                        sod_qty_ship sod_qty_inv
                        sod_loc sod_site sod_serial
/*LB01*/                /*base_curr sod_std_cost*/ desc1
/*J042*/                sod_pricing_dt
                        sod_req_date sod_per_date sod_due_date
/*G035*/                sod_fr_list
                        sod_acct sod_cc sod_dsc_acct sod_dsc_cc
/*F356*/                sod_project sod_confirm
                        sod_type sod_um_conv sod_consume sod-detail-all
/*F297*/                sod_slspsn[1] mult_slspsn sod_comm_pct[1]
/*H008*/                sod_taxable
/*H008*/                sod_taxc /* when (not {txnew.i}) */
/*H008*/                (sod_cmtindx <> 0) @
/*G415*/                sodcmmts
/*H184*/                sod_crt_int
/*H184*/                sod_fix_pr
                        with frame d.
                    /* RMA RECEIPT LINES ARE FOR RETURNS FROM CUSTOMERS -  */
                    /* OR, SHIPPING NEGATIVE QUANTITIES TO CUSTOMERS.      */
                    /* IN RMA MAINTENANCE, HOWEVER, THESE NEGATIVE QTYS    */
                    /* NEED TO DISPLAY AS POSITIVE VALUES (AND, IN THE     */
                    /* RMD_DET FILE, THEY'RE STORED AS POSITIVE VALUES).   */
/*J04C*/            if this-is-rma and not rma-issue-line then do:
/*J04C*/                if sngl_ln then
/*J04C*/                    display (sod_qty_ship * -1) @ sod_qty_ship
/*J04C*/                            (sod_qty_inv * -1) @ sod_qty_inv
/*J04C*/                    with frame d.
/*J04C*/                display (sod_qty_ord * -1) @ sod_qty_ord
/*J04C*/                with frame c.
/*J04C*/            end.
                  end.  /* else, available sod_det, do */
/*J1RY*/          /*if a replacement part is sent back by the configurator, */
/*J1RY*/          /*the program should redisplay the line number, the       */
/*J1RY*/          /*replacement part and prompt the user to enter site      */
/*J1RY*/          if not cf_rp_part then do:
                     update line with frame c editing:

/*J04C*              ADDED THE FOLLOWING */
                     /* NEXT/PREVIOUS PROCESSING MUST BE SENSITIVE TO THE   */
                     /* TYPE OF ORDER BEING MAINTAINED (SALES ORDER OR RMA) */
                     /* AND, IF RMA'S, THE TYPE OF LINE ITEM CURRENTLY      */
                     /* BEING MAINTAINED (ISSUE OR RECEIPT)                 */
                     if this-is-rma then do:
                        {mfnp05.i
                         sod_det
                         sod_nbrln
                         "sod_nbr = so_nbr and sod_fsm_type = rma-line-type"
                         sod_line
                         "line"}
                     end.
                     else do:
/*J04C*              END ADDED CODE */
                       {mfnp01.i sod_det line sod_line so_nbr sod_nbr sod_nbrln}
/*J04C*/             end.

                     if recno <> ? then do:
                        find pt_mstr where pt_part = sod_part
                        no-lock no-error no-wait.
                        if available pt_mstr then
                           desc1 = pt_desc1.
                        else
                        if sod_desc <> "" then
                           desc1 = sod_desc.
                        else
/*GM78                     desc1 = "ITEM NOT IN INVENTORY".  */
/*GM78*/                   desc1 = "零件无库存".
                        line = sod_line.
/*J042*/                /* DETERMINE DISCOUNT DISPLAY FORMAT AND SET VARIABLE discount ACCORDINGLY */
/*J042*/                {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}
                        display line sod_part sod_qty_ord sod_um
/*J042**                sod_list_pr sod_disc_pct sod_price */
/*J042*/                sod_list_pr discount sod_price
                        with frame c.

                        if sngl_ln then
                           display sod_qty_all sod_qty_pick
                           sod_qty_ship sod_qty_inv
                           sod_loc sod_site sod_serial
/*LB01*/                          /* sod_std_cost*/ desc1 /*base_curr*/
/*J042*/                   sod_pricing_dt
                           sod_req_date sod_per_date sod_due_date
/*G035*/                   sod_fr_list
                           sod_acct sod_cc sod_dsc_acct sod_dsc_cc
/*F356*/                   sod_project sod_confirm
                           sod_type sod_um_conv sod_consume sod-detail-all
/*F297*/                   sod_slspsn[1] mult_slspsn sod_comm_pct[1]
/*H008*/                   sod_taxable
/*H008*/                   sod_taxc /* when (not {txnew.i}) */
/*H008*/                   (sod_cmtindx <> 0) @
/*G415*/                   sodcmmts
/*H184*/                   sod_crt_int
/*H184*/                   sod_fix_pr
                           with frame d.

                           /* AS ABOVE, RMA RECEIPT LINES ARE RETURNS, AND  */
                           /* HAVE NEGATIVE SOD_QTY'S, HOWEVER, THESE QTYS  */
                           /* MUST DISPLAY POSITIVE TO THE USER.            */
/*J04C*/                   if this-is-rma and not rma-issue-line then do:
/*J04C*/                      if sngl_ln then
/*J04C*/                         display (sod_qty_ship * -1) @ sod_qty_ship
/*J04C*/                                 (sod_qty_inv * -1) @ sod_qty_inv
/*J04C*/                         with frame d.
/*J04C*/                      display (sod_qty_ord * -1) @ sod_qty_ord
/*J04C*/                      with frame c.
/*J04C*/                   end.
                     end.    /* if recno <> ? */
                     end.    /* editing */
/*J1RY*/          end. /*if not cf_rp_part*/
/*J1RY*/          if cf_rp_part then do:
/*J1RY*/             line = cf_line.
/*J1RY*/             display line with frame c.
/*J1RY*/          end.

                /* ADD/MOD/DELETE  */
               find sod_det where sod_nbr = so_nbr and sod_line = input line
               no-error.
               if not available sod_det then do:
                  if line = 0 then do:
                     {mfmsg.i 642 4}  /* Invalid line number */
                     undo mainloop, retry.
                  end.

/*J0KJ**          NO LONGER NECESSARY SINCE pih_hist IS MOVED TO iph_hist
**
** /*J042*/      /*CHECK TO SEE THAT PRICE LIST HISTORY FOR THIS LINE# DOES NOT
**                   EXIST, IF SO, PREVENT USE OF LINE# AND SET NEW AVAIL. LINE#*/
** /*J042*/        find first pih_hist where pih_doc_type = 1      and
** /*J042*/                                  pih_nbr      = so_nbr and
** /*J042*/                                  pih_line     = input line
** /*J042*/                            no-lock no-error.
** /*J042*/        if available pih_hist then do:
** /*J042*/           find last pih_hist where pih_doc_type = 1 and
** /*J042*/                                    pih_nbr      = so_nbr
** /*J042*/                              no-lock.
** /*J042*/           line = pih_line.
** /*J042*/           {mfmsg.i 6923 4} /*ENTERED LINE# EXISTS IN PRICE LIST HISTORY,
**                                        USE NEW LINE#*/
** /*J042*/           undo mainloop, retry.
** /*J042*/        end.
**J0KJ*/

/*J0XR*/          if not new_order then
/*J0XR*/             reprice_dtl = yes.  /*This will cause line to be priced*/

/*F504*/          new_line = yes.
                  create sod_det.

                  assign sod_nbr = so_nbr
                         sod_line       = input line
                         sod_due_date   = so_due_date
/*J042*/                 sod_pricing_dt = so_pricing_dt
/*J0N2*/                 sod_pr_list    = so_pr_list
                         sod_consume    = consume
/*F470*/                 sod_site       = so_site
                         sod_slspsn[1]  = so_slspsn[1]
                         sod_slspsn[2]  = so_slspsn[2]
                         sod_slspsn[3]  = so_slspsn[3]
                         sod_slspsn[4]  = so_slspsn[4]
                         sodcmmts       = soc_lcmmts
/*G035*/                 sod_fr_list    = so_fr_list
/*H184*/                 sod_fix_pr     = so_fix_pr
/*H184*/                 sod_crt_int    = socrt_int
                  /* END USER DEFAULTS FROM CUSTOMER SHIP-TO, BUT MAY   */
                  /* BE OVERRIDDEN IN THE ISB DEFAULTS POPUP FOR EACH   */
                  /* LINE ITEM.                                         */
/*J04C*/                  sod_enduser   = so_ship
/*F356*/                  sod_project    = so_project .

/*J04C*           ADDED THE FOLLOWING TO CREATE THE RMD_DET */
                  if this-is-rma then do:
                     assign sodcmmts = rmc_lcmmts.
                     create rmd_det.

                     assign rmd_nbr               = so_nbr
                          rmd_prefix              = "C"
                          rmd_line                = input line
                          rmd_edit_isb            = rmc_edit_isb
                          rmd_rma_rtrn            = no
                          rmd_sa_nbr              = rma_contract
                          sod_enduser             = rma_enduser
                          sod_fsm_type            = rma-line-type
/*J15C*/                  /* RMD_SV_CODE WILL NOW HOLD THE SVC TYPE THAT */
/*J15C*/                  /* PROVIDES COVERAGE                           */
/*J15C*/                  rmd_sv_code             = rma_ctype
/*J15C*/                  sodcmmts                = rmc_lcmmts.

                     {fssvsel.i rma_ctype """" eu_type}

                     if rma-issue-line then do:

                        assign
                           sod_rma_type  = "O"
                           rmd_type      = "O"
                           rmd_exp_date  = so_req_date
                           sod_due_date  = so_req_date
                           sod_per_date  = so_req_date
                           sod_req_date  = so_req_date
/*J0KJ**                   sod_pr_list   = rma_pr_list */
                           sod_site      = rma_site_iss
                           sod_loc       = rma_loc_iss.

                     end.   /* if rma-issue-line */

                     else   /* this must be a receipt-line */
                        assign
                            sod_rma_type  = "I"
                            rmd_type      = "I"
                            rmd_exp_date  = so_due_date
                            sod_consume   = no
                            sod_due_date  = so_due_date
                            sod_per_date  = so_due_date
                            sod_req_date  = so_due_date
/*J0KJ**                    sod_pr_list   = rma_crprlist */
                            sod_site      = rma_site_rec
                            sod_loc       = rma_loc_rec.

                     assign rmd-recno = recid(rmd_det).

                  end.  /* if this-is-rma */
/*J04C*           END ADDED CODE */

/*G415*/      /* INITIALIZE TAX MANAGEMENT FIELDS */
/*G415*/          if {txnew.i} then do:
/*G415*/             sod_taxable   = so_taxable.
/*G415*/             sod_taxc      = so_taxc.
/*G415*/             sod_tax_usage = so_tax_usage.
/*J04C* /*G415*/     sod_tax_env   = so_tax_env.  *TVO*/
/*J04C*/             /* FOR RMA'S, DON'T DEFAULT THE ENVIRONMENT BECAUSE IT MUST */
/*J04C*/             /* BE RECALCULATED FOR RCPTS/ISS (DIFFERENT FROM/TO)    *TVO*/
/*J04C*/             sod_tax_env   = (if this-is-rma then "" else so_tax_env).
/*H008*/             sod_tax_in    = tax_in.
/*G415*/          end.

/*F504*/          sod_confirm = so_conf_date <> ?.
/*J04C*/          if not this-is-rma then do:
                      if so_req_date <> so_due_date then
                          sod_req_date = so_req_date.
                      if promise_date <> so_due_date then
                          sod_per_date = promise_date.
/*J04C*/          end. /* if not this-is-rma */
                  if gl_can or gl_vat then sod_tax_in = tax_in.
                               /*cm_tax_in*/
                  if gl_can then sod_pst = so_pst.    /*cm_pst*/
/*G415**          if not gl_vat and not gl_can then assign */
/*G415*/          if /*H206** not gl_vat and not gl_can and **/
/*H206*/          not {txnew.i} then assign
                     sod_taxable = so_taxable
                  sod_taxc    = so_taxc.
                  desc1 = "".
                  assign line.

/*J042*/          /* DETERMINE DISCOUNT DISPLAY FORMAT AND SET VARIABLE discount
                     ACCORDINGLY */
/*J042*/          {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}
                  display line sod_part sod_qty_ord sod_um
/*J042**          sod_list_pr sod_disc_pct sod_price **/
/*J042*/          sod_list_pr discount sod_price
                  with frame c.

                  if sngl_ln then
                     display sod_qty_all sod_qty_pick sod_qty_ship
                     sod_qty_inv sod_loc sod_site sod_serial
/*LB01*/                     desc1 /*sod_std_cost base_curr*/
/*J042*/             sod_pricing_dt
                     sod_req_date sod_per_date sod_due_date
/*G035*/             sod_fr_list
                     sod_acct sod_cc sod_dsc_acct sod_dsc_cc
/*F356*/             sod_project sod_confirm
                     sod_type sod_um_conv sod_consume sod-detail-all
/*F297*/             sod_slspsn[1] mult_slspsn sod_comm_pct[1]
/*H008*/             sod_taxable
/*H008*/             sod_taxc /* when (not {txnew.i}) */
/*H008*/             sodcmmts
/*H184*/             sod_crt_int
/*H184*/             sod_fix_pr
                  with frame d.

/*J1RY*/          if not cf_rp_part then do:
                     prompt-for sod_det.sod_part with frame c editing:
                     /* FIND NEXT/PREVIOUS  RECORD */
                     {mfnp.i pt_mstr sod_part pt_part sod_part pt_part pt_part}

                     if recno <> ? then do:
                        desc1 = pt_desc1.
                        sod_part = pt_part.

/*G579*                 if so_curr = base_curr then assign */
/*G579*                 sod_price   = pt_price            */
/*G579*                 sod_list_pr = pt_price.           */
/*J0KJ** /*G579*/       sod_price = pt_price * so_ex_rate.*/
/*J0KJ*/                sod_price = if rma-line-type <> "RMA-RCT" then
/*J0KJ*/                            pt_price * so_ex_rate
/*J0KJ*/                            else
/*J0KJ*/                            sod_price.
/*J0KJ** /*G579*/       sod_list_pr = sod_price. */
/*J0KJ*/                sod_list_pr = if rma-line-type <> "RMA-RCT" then
/*J0KJ*/                              sod_price
/*J0KJ*/                              else
/*J0KJ*/                              sod_list_pr.
                        sod_um = pt_um.
/*J04C*/                /* FOR RMA'S, PRICE HAS NEVER DISPLAYED WHEN */
                        /* THE USER NEXT/PREV'ED ON PART NUMBER.  TO */
                        /* PREVENT CONFUSION WHEN RESTOCK AMOUNTS    */
                        /* APPLY, DON'T DISPLAY THEM NOW EITHER.     */
                        display sod_part sod_um
                             sod_list_pr
/*J04C*/                                 when (not this-is-rma)
                             sod_price
/*J04C*/                                 when (not this-is-rma)
                        with frame c.
                        if sngl_ln then display desc1 with frame d.
                     end.
                     end. /* end of editing */

/*J1TL*/             hide message no-pause.

/*J1RY*/          end. /*if not cf_rp_part*/
/*J1RY*/          if cf_rp_part then do:
/*J1RY*/             sod_part = cf_pt_part_n.
/*J1RY*/             display sod_part with frame c.
/*J1RY*/          end.

/*G0Z8         assign sod_part = caps(input sod_part).              */
/*J1RY*/       if not cf_rp_part then
/*G0Z8*/         assign sod_part.

               find pt_mstr where pt_part = sod_part no-lock no-error.
               if available pt_mstr and pt_pm_code = "F" then
                  do with frame c:
                     part = sod_part.
                     {gprun.i ""swbom.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

                     if part > "" then sod_part = part.
/*J1L2**             hide frame c.                                  */
                     display part @ sod_part.
                     find pt_mstr where pt_part = sod_part no-lock no-error.
                  end.

                  if not available pt_mstr then do:
                     find first cp_mstr where cp_cust = so_cust
                     and cp_cust_part = sod_part no-lock no-error.

/*GI46*/             if not available cp_mstr then
/*GI46*/                find first cp_mstr where cp_cust = so_ship
/*GI46*/                and cp_cust_part = sod_part no-lock no-error.
                        if not available cp_mstr then
                           find first cp_mstr where cp_cust = ""
                           and cp_cust_part = sod_part no-lock no-error.

                     if available cp_mstr then do:
                        find pt_mstr where pt_part = cp_part
                        no-lock no-error.
                        if available pt_mstr then do:
                           assign
                           sod_custpart = sod_part
                           sod_part     = pt_part.
                           display sod_part with frame c.
                           {mfmsg03.i 56 1 cp_cust_part cp_part """"}
                        end.
                     end.
                 /*F040 - Set the non-inventory flag now */
                     if not available pt_mstr then do:
                        {mfmsg.i 25 2} /* Ship type set to (M)emo */
                        sod_type = "M".
                     end.
                  end.

/*G0Z8*           * Only set customer part if customer entered customer part -
.                 * Don't guess
.                          /* SET CUSTOMER PART IF ANY */
.                  else do:
.                     find first cp_mstr where cp_part = sod_part and
.                     cp_cust = so_cust no-lock no-error.
./*GI46*/             if not available cp_mstr then
./*GI46*/                find first cp_mstr where cp_part = sod_part and
./*GI46*/                cp_cust = so_ship no-lock no-error.
.                        if available cp_mstr then
.                           sod_custpart = caps(cp_cust_part).
./*F09F*/                else do:
./*F09F*/                   find first cp_mstr where cp_part = sod_part and
./*F09F*/                   cp_cust = ""  no-lock no-error.
./*F09F*/                   if available cp_mstr then
./*F09F*/                      sod_custpart = caps(cp_cust_part).
./*F09F*/                end.
.                  end.
***G0Z8*/
/*G2F7*/ else do:
/*G2F7*  THIS SECTION TRIES TO GET CUSTOMER PART, IF UNIQE DEFINITION FOUND */

/*G2F7*/   assign
/*G2F7*/     l_tmp_string1 = "".
/*G2F7*/     if can-find(first cp_mstr where cp_part = sod_part and
/*G2F7*/                                            cp_cust = so_cust) then
/*G2F7*/        l_tmp_string1 = so_cust.
/*G2F7*/     else
/*G2F7*/     if can-find(first cp_mstr where cp_part = sod_part and
/*G2F7*/                                     cp_cust = so_ship) then
/*G2F7*/        l_tmp_string1 = so_ship.
/*G2F7*/
/*G2F7*/     find cp_mstr where cp_part = sod_part and
/*G2F7*/                        cp_cust = l_tmp_string1
/*G2F7*/                        use-index cp_part_cust
/*G2F7*/                        no-lock no-error.
/*G2F7*/     if available cp_mstr then do:
/*G2F7*/        sod_custpart = cp_cust_part.
/*G2F7*/     end. /* if available cp_mstr */

/*G2F7*/end. /* if entered part is an inventory item */

                   /* SET COMM PCT FROM SPD_DET IF AVAILABLE */
                   pl = "".
                   find pt_mstr where pt_part = sod_part no-lock no-error.

/*J04C*            ADDED THE FOLLOWING - DONE IN 7.4 WITH G0Q6 */
                   if this-is-rma and rma-issue-line
                   and available pt_mstr then do:
                    /* CHECK FOR ADD-RMA RESTRICTED TRANSACTION */
                    ptstatus = pt_status.
                    substring(ptstatus,9,1) = "#".
                    if can-find(isd_det where isd_status = ptstatus
                    and isd_tr_type = "ADD-RMA") then do:
                        {mfmsg02.i 358 3 pt_status}
                        undo, retry.
                    end.
                   end.  /* if this-is-rma... */
/*J04C*            END ADDED CODE */

                   /* FOR SO'S, PRODUCT LINE COMES FROM PT_MSTR.*/
                   /* FOR RMA'S, IF "USE ITEM PRODUCT LINE",    */
                   /* USE P/L FROM ITEM, ELSE USE P/L FROM THE  */
                   /* SERVICE TYPE */
/*J04C*/           if not this-is-rma or
/*J04C*/             svc_pt_prod then do:
                      if available pt_mstr then pl = pt_prod_line.
/*J04C*/           end.
/*J04C*/           if this-is-rma and not svc_pt_prod then do:
/*J04C*/              {fssvsel.i rma_ctype """" eu_type}
/*J04C*/              if available sv_mstr then
/*J04C*/                    pl = sv_prod_line.
/*J04C*/                else
/*J04C*/                    if available pt_mstr then pl = pt_prod_line.
/*J04C*/           end.
                   sod_recno = recid(sod_det).
                   {gprun.i ""sosocom.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


                   if available pt_mstr then do:
/*H438*/     /* INITIALIZE FREIGHT VALUES*/
/*H438*/                sod_fr_class = pt_fr_class.
/*H494*/                if calc_fr then
/*H438*/                   sod_fr_wt    = pt_ship_wt.
/*H438*/                sod_fr_wt_um = pt_ship_wt_um.

/*F315*/                ptstatus = pt_status.
/*F315*/                substring(ptstatus,9,1) = "#".
/*J04C*/                if this-is-rma then .
/*J04C*/                else do:
/*F315*/                    if can-find(isd_det where isd_status = ptstatus
/*F315*/                    and isd_tr_type = "ADD-SO") then do:
/*F315*/                        {mfmsg02.i 358 3 pt_status}
/*F315*/                        undo, retry.
/*F315*/                    end.
/*J04C*/                end.    /* else do... */

            /* SET TAX DEFAULTS */
/*G415*/    /* INITIALIZE TAX MANAGEMENT FIELDS */
                        if {txnew.i} then do:
                           sod_taxable = (so_taxable and pt_taxable).
                           sod_taxc = pt_taxc.
                        end.
/*G415***               if gl_vat or gl_can then do: */
/*G415*/                else
                           if gl_vat or gl_can then do:
                              if pt_taxable = yes and so_taxable = yes then do:
                              sod_taxable = yes.
                              sod_taxc = pt_taxc.
                           end.
                           else  do:
                              sod_taxable = no.
                              sod_taxc = pt_taxc.
                  /*IF PART VAT CODE <> 0% THEN USE THE SO_TAXC*/
                              if pt_taxable then do:
                                 find last vt_mstr where vt_class = pt_taxc
                                 and vt_start <= sod_due_date
                                 and vt_end >= sod_due_date
                                 and vt_tax_pct = 0
                                 no-lock no-error.
                                 if not available vt_mstr then
                                    sod_taxc = so_taxc.
                              end.
                           end.  /* else do */
/*G889*/       /* VALIDATE FEWER THAN 4 TAX CLASSES */
/*G889*/                   if not sngl_ln then do:
/*G889*/                      {gpvatchk.i &counter = j &buffer = sod_buff
                              &ref = so_nbr
                              &buffref = sod_nbr     &file = sod_det
                              &taxc = sod_taxc
                              &frame = "NO-FRAME"       &undo_yn = true
                              &undo_label = mainloop}
/*G889*/                   end.
                        end.     /* if gl_vat or gl_can.. */
                        else /*not gl_vat or gl_can or {txnew.i} */
                           if sod_taxable = yes and pt_taxable = no then do:
                              sod_taxable = no.
                              sod_taxc    = pt_taxc.
                           end.

                           /* FOR SO'S, DEFAULT THE PT_MSTR LOCATION.  */
                           /* FOR RMA'S, LOCATION CAME FROM THE HEADER */
                           /* VALUES EARLIER.                          */
                           assign
                              sod_prodline = pt_prod_line
/*J04C*                           sod_loc = pt_loc     */
                              sod_um  = pt_um.
/*J04C*/                   if not this-is-rma then
/*J04C*/                      sod_loc = pt_loc.

                           /* FOR RMA'S, WE MAY NEED PRODUCT LINE FROM */
                           /* THE SERVICE TYPE, AND WE WANT ISSUE OR   */
                           /* RECEIVE LOCATION FROM THE CONTROL FILE   */
/*J04C*/                   if this-is-rma then do:
/*J04C*/                        if not svc_pt_prod then
/*J04C*/                            if available sv_mstr then
/*J04C*/                                sod_prodline = sv_prod_line.
/*J04C*/                   end.    /* if this-is-rma */

                           if so_curr = base_curr then do:
/*J0KJ**                      sod_price = pt_price. */
/*J0KJ*/                      sod_price = if rma-line-type <> "RMA-RCT" then
/*J0KJ*/                                     pt_price
/*J0KJ*/                                  else
/*J0KJ*/                                     sod_price.
/*J0KJ**                      sod_list_pr = pt_price. */
/*J0KJ*/                      sod_list_pr = if rma-line-type <> "RMA-RCT" then
/*J0KJ*/                                       pt_price
/*J0KJ*/                                    else
/*J0KJ*/                                       sod_list_pr.
                           end.

/*G501**     (Cost determination cannot be done until we know the ship-from
 *           site on the line (currently in sosomtla).)
 *          /*F003 - Get default cost for site */
 *          /*G191 - Just get This Level costs for configured parents */
 *G191*                    if pt_pm_code <> "C" then do:
 *F382*         {gpsct05.i &part=pt_part &site=sod_site &cost=sct_cst_tot} **
 *F382*         {gpsct05.i &part=pt_part &site=so_site &cost=sct_cst_tot}
 *G191*                    end.
 *G191*                    else do:
 *G191*                       {gpsct05.i &part=pt_part &site=so_site
 *       &cost="sct_bdn_tl + sct_lbr_tl + sct_mtl_tl + sct_ovh_tl + sct_sub_tl"}
 *G191*                    end.
 *           sod_std_cost = glxcst.
 **G501*/

                     end.  /* if available pt_mstr */
/*H238*/             else
/*J04C*/             do:
                        if not sngl_ln and so_site = "" then do:
/*H0BM*                    {mfmsg03.i 906 3 """Site""" """" """" } */
/*H0BM*                    /* Blank not allowed */                 */
/*H0BM*/                   {mfmsg.i 941 3} /* BLANK SITE NOT ALLOWED */
/*H238*/                   undo mainloop, retry.
/*H238*/                end.
                        /* FOR RMA'S, WE MAY NEED TO GET PRODUCT LINE */
                        /* FROM THE SERVICE TYPE...                   */
/*J04C*/                if this-is-rma and not svc_pt_prod and
/*J04C*/                    available sv_mstr then
/*J04C*/                        sod_prodline = sv_prod_line.
/*J04C*/             end.   /* else, not available pt_mstr, do */

/*H295*/ /*  Set default line site to pt_mstr site if header site is */
/*H295*/ /*  not valid for this item.                                */
/*H295*/                global_part = sod_part.
/*H295*/                if sod_type = "" then do:
/*H295*/                   new_site = sod_site.
/*H295*/                   {gprun.i ""gpptsi01.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H295*/                   if err_stat <> 0 then do:
/*H295*/                      new_site = pt_site.
/*H295*/                      {gprun.i ""gpptsi01.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H295*/                      if err_stat = 0 then do:
/*H295*/                         sod_site = pt_site.
/*H295*/                         {mfmsg02.i 6201 1 sod_site}
/*J152*/                         pause.
/*H295*/           /* Default site invalid; changed to Item default */
/*H295*/                         end.
/*H295*/        /* If multi-line, we need to reject the line NOW. */
/*H295*/                         else if not sngl_ln then do:
/*H295*/                       {mfmsg.i 715 3} /* Item does not exist at site */
/*J0N2*/                            if not batchrun then pause.
/*H295*/                            undo mainloop, retry.
/*H295*/                         end.    /* if not sngl_ln */
/*H295*/                      end.  /* if err_stat <> 0  */
/*H295*/                   end.  /* if sod_type = "" */


                        end. /*if new line*/
                        else do:  /* MODIFYING EXISTING LINE */

/*J04C*                     ADDED THE FOLLOWING */
                            /* IF WE'RE MAINTAINING RMA ISSUE LINES, AND THE    */
                            /* USER HAS PICKED A RECEIPT LINE (OR VICE VERSA),  */
                            /* DON'T LET HIM CONTINUE WITH IT...                */
                            if this-is-rma then do:
                                if rma-issue-line then do:
                                    if sod_fsm_type = "RMA-ISS" then .
                                    else do:
                                        {mfmsg.i 824 3}
                                        /* NOT A VALID RMA ISSUE LINE */
                                        undo mainloop, retry.
                                    end.
                                end.    /* if rma-issue-line */
                                else do:
                                    if sod_fsm_type = "RMA-RCT" then .
                                    else do:
                                        {mfmsg.i 7207 3}
                                        /* NOT A VALID RMA RECEIPT LINE */
                                        undo mainloop, retry.
                                    end.
                                end.    /* else do */

                                find rmd_det where rmd_nbr = sod_nbr
                                    and rmd_line = sod_line and rmd_prefix = "C"
                                    no-lock no-error.
                                assign rmd-recno = recid(rmd_det).

                           end.    /* if this-is-rma */
/*J04C*                    END ADDED CODE */

/*F0K6*/                   global_loc = sod_loc.
/*F504*/                   new_line = no.

                   /* Reverse old history */
/*F504*                 if so_conf_date <> ? then do: */
                   /*CREATE SCREEN BUFFER WITH OLD LINE INFO*/
                           do with frame bi on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

/*FT43*/ /*     This overlap frame bi sets the display format of those */
/*FT43*/ /*     fields to what have been re-formatted in solinfrm.i    */
/*FT43*/                      FORM /*GUI*/ 
/*FT43*/                      sod_qty_ord          format "->>>>,>>9.9<<<<"
/*FT43*/                      sod_list_pr          format ">>>,>>>,>>9.99<<<"
/*FT43*/                      sod_disc_pct label "折扣%"     format "->>>>9.99"
/*FT43*/                      with frame bi width 80 THREE-D /*GUI*/.

                              FORM /*GUI*/  sod_det with frame bi width 80 THREE-D /*GUI*/.

                              {mfoutnul.i &stream_name = "bi"}
/*F504*/                      display stream bi sod_det with frame bi.
/*H330*/                      output stream bi close.
                           end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*F504*/                   if sod_confirm then do:
                              {mfdel.i sobfile}
                              if sod_type = "" then
                              for each sob_det where sob_nbr  = sod_nbr
                              and sob_line = sod_line
                              no-lock:
                              create sobfile.
                              assign sobpart    = sob_part
                              sobsite    = sob_site
                              sobissdate = sob_iss_date
                              sobqtyreq  = sob_qty_req .
                              if sod_consume = yes then
                                 sobconsume  = - sob_qty_req.
                              else sobabnormal = - sob_qty_req.
                           end.  /* for each sob_det  */
                        end.   /* if sod_confirm */
                     end.   /* else, modify existing line, do */

/*J152** FOLLOWING SECTION COMMENTED
* /*H295*/ /* Pause to show messages that will otherwise be hidden when */
* /*H295*/ /* the site pop-up appears in the next subroutine.           */
* /*H295*/             if sngl_ln then do:
* /*H295*/                message. message.
* /*H295*/             end.
*J152*/

                     so_recno = recid(so_mstr).
                     sod_recno = recid(sod_det).

/*J04C*              {gprun.i ""sosomtla.p""}  */

/*J1TL*/             /* THIS WILL CAUSE ANY WARNINGS THAT ARE DISPLAYED */
/*J1TL*/             /* FOR THE ITEM TO PAUSE.                          */
/*J1TL*/             message.
/*J1TL*/             message.

                     /* THE LINE MAINTENANCE SUBROUTINES ARE TOLD   */
                     /* WHETHER THEY'RE DOING SALES ORDERS OR RMA'S */
                     /* AND, IF RMA'S, ARE PASSED ADDITIONAL INFO.  */
                     /* ABOUT THE CURRENT RMA LINE.                 */
/*J04C*//*LB01*/     {gprun.i ""zzsosomtla.p""
                       "(input this-is-rma,
                         input rma-recno,
                         input rma-issue-line,
                         input rmd-recno)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*FR95*              if undo_all then undo mainloop, retry.*/
/*FR95*/             if undo_all then undo mainloop, next mainloop.

                     if del-yn = yes then do:

/*G0Q5*/                find first wo_mstr where wo_nbr =
/*G0Q5*/                (sod_nbr + "." + string(sod_line))
/*G0Q5*/                and wo_part = sod_part no-lock no-error.
/*G0Q5*/                if available wo_mstr then do:
/*G0Q5*/                   {mfmsg.i 515 2}
/*G0Q5*/                   /* Final assy work order exists for this line */
/*G0Q5*/                   pause.
/*G0Q5*/                end.

             /*GJ21 ADDED FOLLOWING IF BLOCK*/
                        if sod_sched and
                        (can-find (first sch_mstr where sch_type = 1
                        and sch_nbr = sod_nbr and sch_line = sod_line) or
                        can-find (first sch_mstr where sch_type = 2
                        and sch_nbr = sod_nbr and sch_line = sod_line) or
                        can-find (first sch_mstr where sch_type = 3
                        and sch_nbr = sod_nbr and sch_line = sod_line)) then do:
                           {mfmsg.i 6022 3}
                           undo mainloop, retry mainloop.
                        end.

/*FL81*/ /* Delete line information that might exist in other databases */
/*FL81*/                find si_mstr where si_site = sod_site no-lock.
/*FL81*/                if si_db <> so_db then do:
/*FL81*/                   {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*F0G8*/                   if err-flag = 0 or err-flag = 9 then do:
/*FL81*/                      assign
/*FL81*/                      sonbr  = so_nbr
/*FL81*/                      soline = sod_line .
/*FL81*/                      {gprun.i ""solndel.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*F0G8*/                   end.
/*FL81*/     /* Reset the db alias to the sales order database */
/*FL81*/                   {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*FL81*/                   sod_recno = recid(sod_det).
/*FL81*/                end.

          /* DELETE ALLOCATION DETAIL*/
/*GN90*                 for each lad_det where lad_dataset = "sod_det"*/
/*GN90*/                for each lad_det exclusive-lock where
                        lad_dataset = "sod_det"
                     and lad_nbr  = sod_nbr
                     and lad_line = string(sod_line):
                        find ld_det where ld_site = lad_site
                        and ld_loc  = lad_loc
                        and ld_lot  = lad_lot
/*D887*/                and ld_ref  = lad_ref
                        and ld_part = lad_part
                        exclusive-lock no-error.
                     if available ld_det then
                        ld_qty_all = ld_qty_all -
                        (lad_qty_all + lad_qty_pick).
                     delete lad_det.
                  end.

/*J042*/  /* UPDATE ACCUM QTY WORKFILE WITH REVERSAL.  save_parent_list
             DETERMINED IN sosomtla.p */
/*J0KJ*/ /*J042*/ if rma-line-type <> "RMA-RCT" and
/*J0KJ*/             (line_pricing or not new_order) then do:
/*J0N2*//*J042*//*LB01*/ {gprun.i ""zzgppiqty2.p"" "(
                                               sod_line,
                                               sod_part,
                                               - save_qty_ord,
                                               - (save_qty_ord *
                                                  save_parent_list),
                                               sod_um,
                                               yes,
/*J0Z6*/                                       yes,
                                               yes
                                              )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J042*/          end.

/*J042*/  /* DELETE SALES ORDER LINE RELATED PRICE LIST HISTORY */
/*J0KJ*/          if rma-line-type <> "RMA-RCT" then do:
/*J042*/             {gprun.i ""gppihdel.p"" "(
                                               1,
                                               sod_nbr,
                                               sod_line
                                              )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J0KJ*/          end.

          /* DELETE SOB_DET */
/*G948*/          delete_line = yes.
/*LB01*/          {gprun.i ""zzsosomtk.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


          /*GJ21 ADDED FOLLOWING BLOCK*/
                  if sod_sched then do:
                     find scx_ref
                     where scx_type = 1 and scx_order = sod_nbr and
                     scx_line = sod_line
                     exclusive-lock.

                     delete scx_ref.
                  end.

/*J044*/ /* DELETE IMPORT EXPORT RECORDS */
/*J044*/          find first ied_det exclusive-lock where
/*J044*/             ied_type = "1" and ied_nbr = so_nbr and ied_line = sod_line
/*J044*/             no-error.
/*J044*/          if available ied_det then delete ied_det.

/*J0R1*/ /* ADDED RESTORE OF QUANTITIES FOR DELETE TRIGGER SODD.T */
/*J0R1*/ /* QUANTITIES WERE ZEROED OUT OF SOD_DET IN SOSOMTLA.P   */
/*J0R1*/          assign
/*J0R1*/             sod_qty_ord  = temp_sod_qty_ord
/*J0R1*/             sod_qty_ship = temp_sod_qty_ship
/*J0R1*/             sod_qty_all  = temp_sod_qty_all
/*J0R1*/             sod_qty_pick = temp_sod_qty_pick.

/*J1RY*/          if cfexists then cf_sod__qadc01 = sod__qadc01.

                  delete sod_det.

/*J04C*           ADDED THE FOLLOWING */
                  /* FOR RMA'S, WE HAVE SOME ADDITIONAL DELETE CLEANUP TO DO:

                      - IF THE RMA LINE IS LINKED TO ANOTHER RMA LINE,
                         ERASE THAT LINK.  NOTE: AN RMA LINE NUMBER IS STORED
                         IN RMD_LINE. THE RMA LINE IT'S LINKED TO WOULD BE
                         NOTED IN RMD_LINK.

                     - IF THE RMA RECEIPT LINE IS LINKED TO AN RTS, ERASE
                         THAT LINK. NOTE: THIS LINKAGE BETWEEN RMA'S AND
                         RTS'S IS ACCOMPLISHED VIA FIELDS RMD_RMA_LINE AND
                         RMD_RMA_NBR.  ON AN RTS RETURN LINE, THESE FIELDS
                         WOULD POINT TO THE RMA RECEIPT LINE, AND ON THE RMA
                         RECEIPT LINE, THEY'D POINT TO THE RTS RETURN LINE.  */

                  if this-is-rma then do:
                        /* CLEAN UP LINKAGE WITHIN THE CURRENT RMA */
                        find rmd_det where recid(rmd_det) = rmd-recno
                            exclusive-lock no-error.
                        if rmd_det.rmd_link <> 0 then do:
                          find rmdbuff
/*J1DS*                       where rmdbuff.rmd_nbr    = rmd_det.rmd_rma_nbr  */
/*J1DS*/                      where rmdbuff.rmd_nbr    = rmd_det.rmd_nbr
                              and   rmdbuff.rmd_prefix = "C"  /* C = Customer */
/*J1DS*                       and   rmdbuff.rmd_line   = rmd_det.rmd_rma_line   */
/*J1DS*/                      and   rmdbuff.rmd_line   = rmd_det.rmd_link
                              exclusive-lock no-error.
                          if  available rmdbuff then
/*J1DS*/                      rmdbuff.rmd_link = 0.
/*J1DS*                       assign rmdbuff.rmd_nbr = " "  */
/*J1DS*                              rmdbuff.rmd_line = 0.  */
                        end.    /* if rmd_det.rmd_link <> 0 then */

                        /* FOR RECEIPT LINES, SEE IF THERE'S AN RTS TO CLEAR ALSO */
                        if not rma-issue-line and rmd_det.rmd_rma_nbr <> " "then do:
                          find rmdbuff
                              where rmdbuff.rmd_nbr    = rmd_det.rmd_rma_nbr
                              and   rmdbuff.rmd_prefix = "V"  /* V = Vendor */
                              and   rmdbuff.rmd_line   = rmd_det.rmd_rma_line
                              exclusive-lock no-error.
                          if  available rmdbuff then
/*J1DS*/                      assign rmdbuff.rmd_rma_nbr = " "
/*J1DS*/                             rmdbuff.rmd_rma_line = 0.
/*J1DS*                       assign rmdbuff.rmd_nbr = " "  */
/*J1DS*                              rmdbuff.rmd_line = 0.  */
                        end.  /* if not rma-issue-line and... */
                        delete rmd_det.
                  end.    /* if this-is-rma */
/*J04C*           END ADDED CODE */

                  line = line - 1.
                  del-yn = no.
                  clear frame c.
                  if sngl_ln then clear frame d.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.

/*J1RY*/          if cfexists and cf_sod__qadc01 <> "" then do:
/*J1RY*/             /* delete any associated configuration files*/
/*J1RY*/             os-delete value(cf_cfg_path + cf_chr  + cf_sod__qadc01).
/*J1RY*/          end.


                  {mfmsg.i 6 1}
/*FR95*           up 1 with frame c.   */
                  next mainloop.
               end.

/*FR95*        view frame dtitle. */
/*FR95*/       if not sngl_ln then down 1 with frame c.

/*J044*/ /* IF IMPORT EXPORT MASTER RECORD EXIST  THEN CALL THE IMPORT     */
/*J044*/ /* EXPORT DETAIL LINE CREATION PROGRAM TO CREATE ied_det          */

/*J044*/       imp-okay = no.
/*J044*/       if can-find
/*J044*/       (first ie_mstr where ie_type = "1" and ie_nbr =  sod_nbr)
/*J044*/       then do:
/*J044*/          {gprun.i ""iedetcr.p"" "(input ""1"",
                                           input sod_nbr,
                                           input sod_line,
                                           input recid(sod_det),
                                           input-output imp-okay)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J044*/          if imp-okay  = no  then undo mainloop, retry.
/*J044*/       end.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* mainloop: */

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* linefmt */

/*FR95*  hide frame a. */

         if sngl_ln then hide frame d.
         hide frame c.
/*FR95*/          hide frame a.
