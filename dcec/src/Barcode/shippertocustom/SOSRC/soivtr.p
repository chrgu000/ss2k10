/* GUI CONVERTED from soivtr.p (converter v1.71) Thu Apr 29 01:26:31 1999 */
/* soivtr.p - INVOICE SHIPMENT TRANSACTION                                   */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*V8:ConvertMode=Maintenance                                                 */
/*V8:RunMode=Character,Windows                                               */
/* REVISION: 4.0      LAST MODIFIED: 10/04/88   BY: emb *A466*               */
/* REVISION: 5.0      LAST MODIFIED: 03/16/89   BY: pml *B067*               */
/* REVISION: 5.0      LAST MODIFIED: 06/23/89   BY: MLB *B159*               */
/* REVISION: 6.0      LAST MODIFIED: 04/23/90   BY: WUG *D002*               */
/* REVISION: 6.0      LAST MODIFIED: 03/18/91   BY: MLB *D443*               */
/* REVISION: 6.0      LAST MODIFIED: 04/02/91   BY: WUG *D472*               */
/* REVISION: 6.0      LAST MODIFIED: 10/07/91   BY: alb *D887*               */
/* REVISION: 7.0      LAST MODIFIED: 11/06/91   BY: pma *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*               */
/* REVISION: 7.0      LAST MODIFIED: 05/12/92   BY: sas *F450*               */
/* REVISION: 7.0      LAST MODIFIED: 06/09/92   BY: tjs *F504*               */
/* REVISION: 7.0      LAST MODIFIED: 07/17/92   BY: tjs *F805*               */
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247*               */
/* REVISION: 7.4      LAST MODIFIED: 09/16/93   BY: dpm *H075*               */
/* REVISION: 7.4      LAST MODIFIED: 12/12/94   BY: dpm *FT84*               */
/* REVISION: 8.5      LAST MODIFIED: 03/29/95   BY: dpm *J044*               */
/* REVISION: 7.3      LAST MODIFIED: 10/05/95   BY: ais *G0YK*               */
/* REVISION: 7.4      LAST MODIFIED: 12/13/95   BY: ais *G1GC*               */
/* REVISION: 8.5      LAST MODIFIED: 10/19/95   BY: taf *J053*               */
/* REVISION: 8.5      LAST MODIFIED: 04/15/97   BY: *H0X6* Jim Williams      */
/* REVISION: 8.5      LAST MODIFIED: 01/16/98   BY: *J25N* Aruna Patil       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* REVISION: 8.6E     LAST MODIFIED: 06/25/98   BY: *L034* Markus Barone     */
/* REVISION: 8.6E     LAST MODIFIED: 06/30/98   BY: *L024* Sami Kureishy     */
/* REVISION: 9.0      LAST MODIFIED: 10/01/98   BY: *J2CZ* Reetu Kapoor      */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 04/21/99   BY: *F0Y0* Poonam Bahl       */
/*J2CZ** ADDED NO-UNDO, ASSIGN THROUGHOUT **/

         {mfdeclre.i}

         define shared variable eff_date as date.
         define shared variable ref like glt_det.glt_ref.
         define shared variable so_recno as recid.
         define shared variable trlot like tr_lot.
         define shared variable sod_recno as recid.
         define variable trqty like tr_qty_chg no-undo.
         define variable qty_left like tr_qty_chg no-undo.
         define  shared frame bi.
         define  shared stream bi.
         define  shared variable amd as character.

         define variable site like sod_site no-undo.

         define shared variable location like sod_loc.
         define shared variable lotser like sod_serial.
         define shared variable lotrf like sr_ref.
/*L024*  define shared variable exch_rate like exd_rate. */
/*L024*/ define shared variable exch_rate like exr_rate.
/*L024* *L00Y* define shared variable exch_rate2 like exd_rate. */
/*L024*/ define shared variable exch_rate2 like exr_rate2.
/*L00Y*/ define shared variable exch_ratetype like exr_ratetype.
/*L00Y*/ define shared variable exch_exru_seq like exru_seq.
         define shared variable transtype as character.
         define variable prev_found like mfc_logical no-undo.
         define new shared variable trgl_recno as recid.
         define new shared variable sct_recno as recid.
         define variable glcost like sct_cst_tot no-undo.
         define variable assay like tr_assay no-undo.
         define variable grade like tr_grade no-undo.
         define variable expire like tr_expire no-undo.
         define variable site_change as logical no-undo.
         define variable pend_inv as logical initial yes no-undo.

         define variable ec_ok as logical no-undo.
         define new shared variable tr_recno as recid .
         define variable in_update_instructions as character no-undo.
/*L034*/ define variable mc-error-number like msg_nbr no-undo.
/*L034*/ define variable base-price      like tr_price no-undo.
         /* DEFINE GL_TMP_AMT FOR USE IN MFIVTR.I */
         define variable gl_tmp_amt as decimal no-undo.
         define new shared variable sod_entity like en_entity.
         define variable gl_amt like glt_amt no-undo.
         define variable dr_acct like sod_acct no-undo.
         define variable dr_cc   like sod_cc no-undo.
         define variable from_entity like en_entity no-undo.
         define variable icx_acct like sod_acct no-undo.
         define variable icx_cc like sod_cc no-undo.
/*F0Y0*/ define variable l_lotedited like mfc_logical no-undo.

         define buffer   soddet     for sod_det.

         /* FIND GL_CTRL FILE FOR USE IN MFIVTR.I */
/*J2CZ** /*J053*/ find first gl_ctrl no-lock no-error. **/
/*J2CZ*/ for first gl_ctrl fields(gl_rnd_mthd) no-lock: end.

/*J2CZ**  find so_mstr no-lock where recid(so_mstr) = so_recno no-error. **/
/*J2CZ*/ for first so_mstr
/*J2CZ*/     fields(so_curr so_cust so_rev so_ship_date)
/*J2CZ*/     no-lock where recid(so_mstr) = so_recno: end.
         if not available so_mstr then leave.

/*J2CZ**   find sod_det no-lock where recid(sod_det) = sod_recno no-error. **/
/*J2CZ*/ for first sod_det no-lock where recid(sod_det) = sod_recno: end.
         if not available sod_det then leave.

/*J2CZ**     find si_mstr where si_site = sod_site no-lock. /*D472*/ **/
/*J2CZ*/ for first si_mstr
/*J2CZ*/     fields(si_cur_set si_entity si_gl_set si_site si_status)
/*J2CZ*/     where si_site = sod_site no-lock: end.

         sod_entity = si_entity.

/*J2CZ** find pt_mstr where pt_part = sod_part no-lock no-error.   /*D472*/ **/
/*J2CZ*/ for first pt_mstr
/*J2CZ*/     fields(pt_abc pt_avg_int pt_cyc_int pt_loc pt_part pt_prod_line
/*J2CZ*/            pt_rctpo_active pt_rctpo_status pt_rctwo_active
/*J2CZ*/            pt_rctwo_status pt_shelflife pt_um)
/*J2CZ*/ where pt_part = sod_part no-lock: end.

         if available pt_mstr then
/*J2CZ** find pl_mstr where pl_prod_line = pt_prod_line no-lock.   /*D472*/ **/
/*J2CZ*/ for first pl_mstr
/*J2CZ*/     fields(pl_inv_acct pl_inv_cc pl_prod_line)
/*J2CZ*/     where pl_prod_line = pt_prod_line no-lock: end.

         /* FORM DEFINITION FOR HIDDEN FRAME BI */
         {sobifrm.i}

         FORM /*GUI*/ 
             sod_det
         with  frame bi THREE-D /*GUI*/.


         if amd = "DELETE"
         then in_update_instructions = "no in_qty_req update".
         else in_update_instructions = "update in_qty_req".
         if amd = "DELETE" or amd = "MODIFY" then do:
            site_change = (frame bi sod_site <> sod_site).
           {mfivtr.i "input frame bi" in_update_instructions}
         end.
        /* Re-initialize the shared variables so that user entered */
        /* Sod_loc and sod_serial will be used for reshipment */
        assign
           location = ""
           lotser = ""
           lotrf = "".

         if amd = "ADD"
         then in_update_instructions = "no in_qty_req update".
         else in_update_instructions = "update in_qty_req".
         if amd = "ADD" or amd = "MODIFY" then do:
           {mfivtr.i " " in_update_instructions}
         end.
