/* GUI CONVERTED from sosomtla.p (converter v1.69) Wed Sep 17 13:28:40 1997 */
/* sosomtla.p - SALES ORDER MAINTENANCE LINE PRICE/QTY SUBROUTINE       */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 03/21/90   BY: ftb *D011*          */
/* REVISION: 6.0      LAST MODIFIED: 04/06/90   BY: ftb *D002*          */
/* REVISION: 6.0      LAST MODIFIED: 04/10/90   BY: MLB *D021*          */
/* REVISION: 6.0      LAST MODIFIED: 08/30/90   BY: EMB *D040*          */
/* REVISION: 6.0      LAST MODIFIED: 08/09/90   BY: MLB *D055*          */
/* REVISION: 6.0      LAST MODIFIED: 12/19/90   BY: afs *D266*          */
/* REVISION: 6.0      LAST MODIFIED: 01/18/91   BY: emb *D307*          */
/* REVISION: 6.0      LAST MODIFIED: 01/31/91   BY: afs *D327*          */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*          */
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 03/23/92   BY: dld *F297*          */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: afs *F356*          */
/* REVISION: 7.0      LAST MODIFIED: 04/16/92   BY: dld *F382*          */
/* REVISION: 7.0      LAST MODIFIED: 04/22/92   BY: afs *F420*          */
/* REVISION: 7.0      LAST MODIFIED: 04/30/92   BY: tjs *F463*          */
/* REVISION: 7.0      LAST MODIFIED: 05/06/92   BY: tjs *F470*          */
/* REVISION: 7.0      LAST MODIFIED: 06/11/92   BY: tjs *F504*          */
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: afs *F519*          */
/* REVISION: 7.0      LAST MODIFIED: 07/08/92   BY: tjs *F723*          */
/* REVISION: 7.0      LAST MODIFIED: 07/29/92   BY: tjs *F802*          */
/* REVISION: 7.0      LAST MODIFIED: 08/21/92   BY: afs *F862*          */
/* REVISION: 7.3      LAST MODIFIED: 09/15/92   BY: tjs *G035*          */
/* REVISION: 7.3      LAST MODIFIED: 10/28/92   BY: afs *G244*          */
/* REVISION: 7.3      LAST MODIFIED: 11/23/92   BY: tjs *G191*          */
/* REVISION: 7.3      LAST MODIFIED: 12/08/92   BY: tjs *G391*          */
/* REVISION: 7.3      LAST MODIFIED: 01/12/92   BY: tjs *G507*          */
/* REVISION: 7.3      LAST MODIFIED: 01/04/92   BY: afs *G501*          */
/* REVISION: 7.3      LAST MODIFIED: 02/08/92   BY: bcm *G415*          */
/* REVISION: 7.3      LAST MODIFIED: 02/18/93   BY: afs *G692*          */
/* REVISION: 7.3      LAST MODIFIED: 02/24/93   BY: sas *G457*          */
/* REVISION: 7.3      LAST MODIFIED: 04/10/93   BY: tjs *G830*          */
/* REVISION: 7.3      LAST MODIFIED: 04/27/93   BY: WUG *GA46*          */
/* REVISION: 7.3      LAST MODIFIED: 05/17/93   BY: afs *GB06*          */
/* REVISION: 7.3      LAST MODIFIED: 05/20/93   BY: kgs *GB18*          */
/* REVISION: 7.4      LAST MODIFIED: 06/21/93   BY: pcd *H008*          */
/* REVISION: 7.4      LAST MODIFIED: 08/06/93   BY: tjs *H059*          */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*          */
/* REVISION: 7.4      LAST MODIFIED: 09/29/93   BY: cdt *H086*          */
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184*          */
/* REVISION: 7.4      LAST MODIFIED: 11/22/93   BY: afs *H238*          */
/* REVISION: 7.4      LAST MODIFIED: 02/07/94   BY: afs *FL83*          */
/* REVISION: 7.4      LAST MODIFIED: 03/10/94   BY: cdt *H294*          */
/* REVISION: 7.4      LAST MODIFIED: 03/16/94   BY: afs *H295*          */
/* REVISION: 7.3      LAST MODIFIED: 04/25/94   BY: cdt *GJ56*          */
/* REVISION: 7.4      LAST MODIFIED: 05/27/94   BY: dpm *FO23*          */
/* REVISION: 7.4      LAST MODIFIED: 05/27/94   BY: qzl *H376*          */
/* REVISION: 7.4      LAST MODIFIED: 06/16/94   BY: qzl *H390*          */
/* REVISION: 7.3      LAST MODIFIED: 06/29/94   BY: cdt *GK52*          */
/* REVISION: 7.3      LAST MODIFIED: 06/15/94   BY: WUG *GK60*          */
/* REVISION: 7.3      LAST MODIFIED: 07/11/94   BY: dpm *FP33*          */
/* REVISION: 7.4      LAST MODIFIED: 07/18/94   BY: bcm *H443*          */
/* REVISION: 7.4      LAST MODIFIED: 07/21/94   BY: WUG *GK86*          */
/* REVISION: 7.4      LAST MODIFIED: 08/09/94   BY: bcm *H476*          */
/* REVISION: 7.4      LAST MODIFIED: 08/15/94   BY: WUG *FQ14*          */
/* REVISION: 7.4      LAST MODIFIED: 09/09/94   BY: afs *H510*          */
/* REVISION: 7.4      LAST MODIFIED: 09/26/94   BY: ljm *GM78*          */
/* REVISION: 7.4      LAST MODIFIED: 10/10/94   BY: bcm *H561*          */
/* REVISION: 7.4      LAST MODIFIED: 10/16/94   BY: dpm *FR95*          */
/* REVISION: 8.5      LAST MODIFIED: 10/18/94   BY: mwd *J034*          */
/* REVISION: 7.4      LAST MODIFIED: 11/02/94   BY: rxm *FT18*          */
/* REVISION: 7.4      LAST MODIFIED: 11/11/94   BY: qzl *FT43*          */
/* REVISION: 7.4      LAST MODIFIED: 12/13/94   BY: afs *FU56*          */
/* REVISION: 7.4      LAST MODIFIED: 01/13/95   BY: dpm *F0DR*          */
/* REVISION: 7.4      LAST MODIFIED: 01/25/95   BY: bcm *F0G8*          */
/* REVISION: 7.4      LAST MODIFIED: 02/10/95   BY: rxm *F0HM*          */
/* REVISION: 7.4      LAST MODIFIED: 03/03/95   BY: rxm *F0LM*          */
/* REVISION: 7.4      LAST MODIFIED: 03/14/95   BY: rxm *G0H7*          */
/* REVISION: 7.4      LAST MODIFIED: 03/21/95   BY: rxm *F0MV*          */
/* REVISION: 8.5      LAST MODIFIED: 03/07/95   BY: DAH *J042*          */
/* REVISION: 8.5      LAST MODIFIED: 07/11/95   BY: DAH *J05G*          */
/* REVISION: 8.5      LAST MODIFIED: 08/14/95   BY: DAH *J063*          */
/* REVISION: 8.5      LAST MODIFIED: 09/10/95   BY: DAH *J07R*          */
/* REVISION: 8.5      LAST MODIFIED: 10/04/95   BY: AME *J089*          */
/* REVISION: 7.4      LAST MODIFIED: 08/25/95   BY: jym *G0TW*          */
/* REVISION: 7.4      LAST MODIFIED: 09/06/95   BY: ais *G0WL*          */
/* REVISION: 7.4      LAST MODIFIED: 10/23/95   BY: rxm *G19G*          */
/* REVISION: 7.4      LAST MODIFIED: 11/13/95   BY: ais *H0GK*          */
/* REVISION: 7.4      LAST MODIFIED: 12/07/95   BY: rxm *H0FS*          */
/* REVISION: 8.5      LAST MODIFIED: 11/07/95   BY: taf *J053*          */
/* REVISION: 7.4      LAST MODIFIED: 12/19/95   BY: kjm *G1GV*          */
/* REVISION: 8.5      LAST MODIFIED: 04/03/96   BY: DAH *J0GT*          */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: *J04C* Sue Poland        */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: *J04C* Markus Barone     */
/* REVISION: 8.5      LAST MODIFIED: 04/17/96   BY: *J04C* Sue Poland        */
/* REVISION: 8.5      LAST MODIFIED: 04/30/96   BY: *J0KJ* Dennis Henson     */
/* REVISION: 8.5      LAST MODIFIED: 05/07/96   BY: *J0LL* Dennis Henson     */
/* REVISION: 8.5      LAST MODIFIED: 05/16/96   BY: *J0MY* Sue Poland        */
/* REVISION: 8.5      LAST MODIFIED: 05/20/96   BY: *J0N2* Dennis Henson     */
/* REVISION: 8.5      LAST MODIFIED: 06/10/96   BY: *J0VK* Markus Barone     */
/* REVISION: 8.5      LAST MODIFIED: 06/21/96   BY: *G1V1* Tony Patel        */
/* REVISION: 8.5      LAST MODIFIED: 07/02/96   BY: *J0XG* Dennis Henson     */
/* REVISION: 8.5      LAST MODIFIED: 07/04/96   BY: *J0XR* Dennis Henson     */
/* REVISION: 8.5      LAST MODIFIED: 07/12/96   BY: *J0Y5* Andy Wasilczuk    */
/* REVISION: 8.5      LAST MODIFIED: 07/11/96   BY: *J0YR* Kieu Nguyen       */
/* REVISION: 8.5      LAST MODIFIED: 07/16/96   BY: *J0Z6* Andy Wasilczuk    */
/* REVISION: 8.5      LAST MODIFIED: 07/23/96   BY: *J0R1* Andy Wasilczuk    */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: *J12Q* Andy Wasilczuk    */
/* REVISION: 8.5      LAST MODIFIED: 08/07/96   BY: *G29K* Markus Barone     */
/* REVISION: 8.5      LAST MODIFIED: 09/12/96   BY: *J152* Suresh Nayak      */
/* REVISION: 8.5      LAST MODIFIED: 10/17/96   BY: *H0N1* Suresh Nayak      */
/* REVISION: 8.5      LAST MODIFIED: 10/02/96   BY: *J15C* Markus Barone     */
/* REVISION: 8.5      LAST MODIFIED: 10/29/96   BY: *G2H6* Suresh Nayak      */
/* REVISION: 8.5      LAST MODIFIED: 12/23/96   BY: *J1CR* Sue Poland        */
/* REVISION: 8.5      LAST MODIFIED: 03/03/97   BY: *J1JV* Jim Williams      */
/* REVISION: 8.5      LAST MODIFIED: 04/08/97   BY: *J1N4* Aruna Patil       */
/* REVISION: 8.5      LAST MODIFIED: 08/06/96   BY: *J1YB* Sue Poland        */
/* REVISION: 8.5      LAST MODIFIED: 08/12/97   BY: *J1YL* Aruna Patil       */
/* REVISION: 8.5      LAST MODIFIED: 08/22/97   BY: *H1B1* Suresh Nayak      */
/* REVISION: 8.5      LAST MODIFIED: 09/05/97   BY: *J1XW* Ajit Deodhar      */
/* REVISION: 8.5      LAST MODIFIED: 05/21/97   BY: *J1RY* Tim Hinds         */
/* REVISION: 8.5      LAST MODIFIED: 09/16/97   BY: *J20Z* Cindy Votro       */
/* REVISION: 8.5      LAST MODIFIED: 11/14/03   BY: *LB01* Long Bo         */

/* REVISION: 8.5      LAST MODIFIED: 06/17/04   BY: *LB02* Long Bo          ->
                              ADD MINMUN QTY WARNING                         */

/* NOTE:  Any changes made here may also be needed in fseomtla.p        */

/*!
    SOSOMTLA.P maintains line item information (fields site through
    price) for Sales Orders and RMA's.  It is called by SOSOMTA.P, and
    calls SOSOMTLB.P for user maintenance of other line item fields.
    If this SO/RMA line may update the Installed Base, then it also
    calls SOSOMISB.P.
*/
/*!
    Input parameters are:

    this-is-rma: Will be yes in RMA Maintenance and no in
                 Sales Order Maintenance.
    rma-recno  : When processing an RMA, this is the rma_mstr
                 (the RMA header) recid.
    rma-issue-line:  When processing RMA's, this will be yes
                 when maintaining the issue (outgoing) lines, and
                 no when maintaining the receipt (incoming) lines.
                 In SO Maintenance, this will be yes.
    rmd-recno  : In RMA Maintenance, this will contain the recid
                 for rmd_det (the RMA line).  For SO Maintenance,
                 this will be ?.
*/

/*!
    *J0KJ* Applies v8.5 pricing to RMA issue lines.  The use of rma-issue-line
           will appear wherever a v8.5 pricing function will occur.  This
           supports both Sales Orders and RMA issue lines.  Where a coverage
           discount applies, it will be treated as a "manual" discount for the
           sake of price list history and any resultant calculation.

           RMA receipt lines will use pre v8.5 pricing functions.  A credit
           price list will be used to determine pricing along with any
           applicable restocking charge.  No price list history will be
           created. Any discount information required by the G/L posting
           routine sosoglb.p will be derived from the sales order line.

           SPECIAL NOTE: QAD FIELD sod__qadd01 IS BEING USED TO CONTAIN
                         THE COVERAGE DISCOUNT WHEN A RMA ISSUE LINE IS
                         INVOLVED.  IT WILL CONTAIN A VALUE ONLY WHEN
                         THE "MANUAL" DISCOUNT IS DUE TO THE COVERAGE
                         DISCOUNT, OTHERWISE IT WILL BE 0.
*/
         {mfdeclre.i}

/*J04C*/ define input parameter this-is-rma     like mfc_logical.
/*J04C*/ define input parameter rma-recno       as  recid.
/*J04C*/ define input parameter rma-issue-line  like mfc_logical.
/*J04C*/ define input parameter rmd-recno       as  recid.

/*J1RY*/ define shared variable cfexists          like mfc_logical.
/*J1RY*/ define shared variable cf_rp_part        like mfc_logical  no-undo.
/*J1RY*/ define new shared variable cf_undo       like mfc_logical.
/*J1RY*/ define new shared variable cf_sod_rec      as recid.
/*J1RY*/ define new shared variable cf_config     like mfc_logical.
/*J1RY*/ define new shared variable cf_rm_old_bom like mfc_logical.
/*J1RY*/ define new shared variable cf_error_bom  like mfc_logical.
/*J1RY*/ define new shared variable pt_cf_model     as character format "x(40)".
/*J1RY*/ define shared variable cf_chr              as character.
/*J1RY*/ define shared variable cf_cfg_path       like mfc_char.
/*J1RY*/ define shared variable cf_cfg_suf        like mfc_char.
/*J1RY*/ define shared variable delete_line       like mfc_logical.
/*J1RY*/ define shared variable cf_cfg_strt_err like mfc_logical.


/*J053*/ /* DEFINE RNDMTHD FOR CALL TO SOSOMTLB.P */
/*J053*/ define shared variable rndmthd like rnd_rnd_mthd.
         define shared variable line like sod_line.
         define shared variable del-yn like mfc_logical.
         define shared variable prev_due like sod_due_date.
         define shared variable prev_qty_ord like sod_qty_ord.
         define shared variable all_days as integer.
         define shared variable so_recno as recid.
         define shared variable sod_recno as recid.
         define new shared variable pcqty like sod_qty_ord.
         define new shared variable desc1 like pt_desc1.
         define variable desc2 like pt_desc2.
         define new shared variable cmtindx like cmt_indx.
         define shared variable sodcmmts like soc_lcmmts label "说明".
         define shared variable prev_abnormal like sod_abnormal.
         define variable modify_sob like mfc_logical initial no
            label "检查清单".
         define shared variable prev_consume like sod_consume.
         define shared variable consume like sod_consume.
         define shared variable promise_date as date label "承诺日期".
         define shared variable base_amt like ar_amt.
         define shared variable undo_all like mfc_logical.
         define variable yn like mfc_logical.
/*F0HM   define variable old_price like sod_price.
 *       define variable old_list_pr like sod_list_pr.
 *       define variable old_disc like sod_disc_pct. */
/*F0HM*/ define new shared variable old_price like sod_price.
/*F0HM*/ define new shared variable old_list_pr like sod_list_pr.
/*F0HM*/ define new shared variable old_disc like sod_disc_pct.
         define shared variable sngl_ln like soc_ln_fmt.
         define shared variable clines as integer.
         define variable open_qty like mrp_qty.
/*G501*/ define  new shared  variable old_site like sod_site.
         define shared variable sod-detail-all like soc_det_all.
         define variable qty_allocatable like in_qty_avail
            label "可备料量".
         define variable last_sod_price like sod_price.
         define new shared variable totallqty like sod_qty_all.
         define shared variable prev_type like sod_type.
         define shared variable prev_site like sod_site.
         define shared variable sodreldate like sod_due_date.
         define shared variable so_db like dc_name.
         define shared variable inv_db like dc_name.
         define new shared variable undo_all2 like mfc_logical.
/*F297*/ define shared variable mult_slspsn         like mfc_logical no-undo.
/*F504*/ define shared variable new_line            like mfc_logical.
/*F723*/ define new shared variable prev_confirm    like sod_confirm.
/*G501*/ define new shared variable err_stat        as integer.
/*G501*/ define new shared variable new_site        like sod_site.
/*G692*/ define new shared variable match_pt_um     like mfc_logical.
/*GJ56** define     shared variable soc_isb_window  like mfc_logical. */
/*J04C*  SOC_EDIT_ISB MOVED FROM MFC_CTRL TO SOC_CTRL */
/*J04C* /*GJ56*/ define shared variable soc_edit_isb like mfc_logical. */
/*J1CR*/ define            variable soc_returns_isb like soc__qadl01
/*J1CR*/                            label "客户订单退货更新已安装产品" no-undo.
/*J1CR*/ define            variable return-to-remove-isb like mfc_logical no-undo.
/*G457*/ define     shared variable solinerun       as character.
/*H008*/ define new shared variable old_sod_site    like sod_site no-undo.
/*H049*/ define     shared variable freight_ok      like mfc_logical.
/*H049*/ define     shared variable calc_fr         like mfc_logical.
/*H049*/ define     shared variable disp_fr         like mfc_logical.
/*H086*/ define            variable minprice        like pc_min_price.
/*H086*/ define            variable maxprice        like pc_min_price.
/*H086*/ define            variable warning         like mfc_logical initial no.
/*H086*/ define            variable warmess         like mfc_logical
/*H086*/                                            initial yes.
/*H086*/ define            variable minmaxerr       like mfc_logical.
/*H086*/ define new shared variable lineffdate      like so_due_date.
/*H086*/ define     shared variable soc_pc_line     like mfc_logical.
/*FL83*/ define            variable qty_avl         like sod_qty_all.
/*FL83*/ define new shared variable err-flag        as integer.
/*FO23*/ define new shared variable prev_qty_ship   like sod_qty_ship.
/*H443** define            variable tblprice        like sod_list_pr. **/
/*GK60*/ define            variable created_by_new_software
/*GK60*/                                            like mfc_logical.
/*H510** define            variable config_edited   like mfc_logical. **/
/*GK86*/ define            variable pm_code         as character.
/*H510*/ define            variable pc_recno        as recid.
/*H510*/ define new shared variable soc_pt_req      like mfc_logical.
/*FR95*/ define shared frame c.
/*FR95*/ define shared frame d.
/*FT43*/ define variable disc_origin like sod_disc_pct.
/*F0DR*/ define variable chg-db  like mfc_logical.
/*F0DR*/ define variable remote-base-curr like gl_base_curr.
/*F0DR*/ define new shared variable  exch-rate like exd_ent_rate.
/*F0LM*/ define variable old_um like sod_um.
/*J042*/ define            variable sobparent        like sob_parent.
/*J042*/ define            variable sobfeature       like sob_feature.
/*J042*/ define            variable sobpart          like sob_part.
/*J042*/ define     shared variable new_order        like mfc_logical.
/*J042*/ define new shared variable pics_type        like pi_cs_type
                                                     initial "9".
/*J042*/ define new shared variable part_type        like pi_part_type
                                                     initial "6".
/*J042*/ define     shared variable picust           like cm_addr.
/*J042*/ define            variable err_flag         as integer.
/*J0N2** /*J042*/ define            variable save_qty_ord like sod_qty_ord. */
/*J0N2*/ define     shared variable save_qty_ord     like sod_qty_ord.
/*J042*/ define            variable save_um          like sod_um.
/*J1JV /*J042*/ define     variable save_disc_pct    like sod_disc_pct. */
/*J1JV*/ define            variable save_disc_pct    as decimal.
/*J1JV*/ define            variable new_disc_pct     as decimal.
/*J042*/ define            variable umconv           like sod_um_conv.
/*J042*/ define     shared variable discount         as decimal.
/*J042*/ define     shared variable line_pricing     like mfc_logical.
/*J042*/ define     shared variable reprice          like mfc_logical.
/*J042*/ define     shared variable reprice_dtl      like mfc_logical.
/*J042*/ define            variable minerr           like mfc_logical.
/*J042*/ define            variable maxerr           like mfc_logical.
/*J042*/ define            variable man_disc_pct     as decimal.
/*J042*/ define            variable sys_disc_fact    as decimal.
/*J042*/ define            variable rfact            as integer.
/*J042*/ define            variable minmax_occurred  like mfc_logical
                                                     initial no no-undo.
/*J042*/ define     shared variable save_parent_list like sod_list_pr.
/*J04C*/ define            variable frametitle      as character format "x(20)".
/*J04C*/ define            variable coverage-discount  like sod_disc_pct.
/*J04C*/ define            variable restock-pct        like rma_rstk_pct.
/*J04C*/ define            buffer   rtsbuff             for rmd_det.
/*J0N2*/ define            variable disc_min_max       like mfc_logical.
/*J0N2*/ define            variable disc_pct_err       as decimal
/*J0N2*/                            format "->>>>,>>>,>>9.9<<<".
/*J0N2*/ define            variable last_list_price    like sod_list_pr.
/*J15C*/ define new shared variable restock-amt        like rmd_restock.

/*J0R1*/ define     shared variable temp_sod_qty_ord   like sod_qty_ord.
/*J0R1*/ define     shared variable temp_sod_qty_ship  like sod_qty_ship.
/*J0R1*/ define     shared variable temp_sod_qty_all   like sod_qty_all.
/*J0R1*/ define     shared variable temp_sod_qty_pick  like sod_qty_pick.

/*G2H6*/ define variable shipper_found as integer no-undo.
/*G2H6*/ define variable save_abs like abs_par_id no-undo.
/*H1B1*/ define variable l_prev_um_conv like sod_um_conv no-undo.

/*J0YR*/ define new shared frame bom.
/*J0YR*/ FORM /*GUI*/ 
/*J0YR*/    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
sod_sob_std colon 17
/*J0YR*/    sod_sob_rev colon 17 label "生效日期"
/*J0YR*/    sod_fa_nbr  colon 17
/*J0YR*/    space(2)
/*J0YR*/    sod_lot     colon 17
/*J0YR*/  SKIP(.4)  /*GUI*/
with frame bom overlay attr-space side-labels row 9 column 25 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-bom-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame bom = F-bom-title.
 RECT-FRAME-LABEL:HIDDEN in frame bom = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame bom =
  FRAME bom:HEIGHT-PIXELS - RECT-FRAME:Y in frame bom - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME bom = FRAME bom:WIDTH-CHARS - .5.  /*GUI*/


/*J042*/ {pppiwkpi.i "new"} /*Pricing workfile definition*/
/*J042*/ {pppivar.i}        /*Pricing variables*/
/*J0N2*/ {pppiwqty.i}       /*Reprice workfile definition*/

/*J042** /*H0FS*/ define new shared variable undo_all_config like mfc_logical
                                                                  no-undo. */
         {mfdatev.i}

/*J089*/ /*V8:HiddenDownFrame=c*/

/*FR95*/ /*DEFINE FORMS*/
/*LB01**FR95*/ {zzsolinfrm.i}

/*FR95*/  FORM /*GUI*/ 
             space(1)  sod_site  space(1)
/*J0VK*FR95* with frame c_site overlay row frame-row(c) column 16  */
/*J0VK*J04C*      /*V8! + 1 */.                                    */
/*J0VK*/  with frame c_site overlay column 16
/*J0VK*/       row frame-row(c)       + 1    THREE-D /*GUI*/.


undo_all = yes.

/*J0GT*/ assign
/*J0GT*/    exclude_confg_disc = no
/*J0GT*/    select_confg_disc  = no
/*J0GT*/    found_confg_disc   = no
/*J0GT*/ .

loopc:
do on error undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


/*FR95**
 * define shared frame c.
 * define shared frame d.
 *
 * /*DEFINE FORMS*/
 * {solinfrm.i}
 *FR95*/

   view frame c.
/*FR95*//*Removed V8! code */

   if sngl_ln then view frame d.

   find so_mstr where recid(so_mstr) = so_recno.
   find sod_det where recid(sod_det) = sod_recno.

/*J04C*/ if this-is-rma then do:
/*J04C*/    find rma_mstr where recid(rma_mstr) = rma-recno
/*J04C*/        exclusive-lock no-error.
/*J04C*/    restock-pct = rma_rstk_pct.
/*J15C*/    find eu_mstr where eu_addr = rma_enduser no-lock no-error.
/*J15C*/    {fssvsel.i rma_ctype """" eu_type}
/*J15C*J04C*if rma-issue-line then                            */
/*J04C*/    find rmd_det where recid(rmd_det) = rmd-recno
/*J04C*/         exclusive-lock no-error.
/*J04C*J04C*else do:                                          */
/*J04C*J04C*   find rmd_det where recid(rmd_det) = rmd-recno  */
/*J04C*J04C*       no-lock no-error.                          */
/*J04C*J04C*end.    /* else, not rma-issue-line, do */        */
/*J15C*/    if available rmd_det then
/*J15C*/       restock-amt = rmd_restock.
/*J04C*/    find first rmc_ctrl no-lock no-error.
/*J04C*/ end.

         find first soc_ctrl no-lock.
/*J1CR*/ soc_returns_isb = soc__qadl01.
         find first gl_ctrl no-lock.
/*GK52*/ /* find first svc_ctrl no-lock. */
/*GK52*/ find first svc_ctrl no-lock no-error.
/*J042*/ find first pic_ctrl no-lock.
/*J042*/ if pic_so_fact then
/*J042*/    rfact = pic_so_rfact.
/*J042*/ else
/*J042*/    rfact = pic_so_rfact + 2.

/*H510*/ /* Read price table required flag from mfc_ctrl */
/*H510*/ find first mfc_ctrl where mfc_field = "soc_pt_req" no-lock no-error.
/*H510*/ if available mfc_ctrl then soc_pt_req = mfc_logical.

         last_sod_price   = sod_price.

         status input.
         line = sod_line.
/*FT18   desc1 = "Item Not In Inventroy". */
/*FT18*/ desc1 = "零件无库存".
         desc2 = "".

/*GB18* If part now is in item master, blank memo item description */
   find pt_mstr where pt_part = sod_part no-lock no-error.
   if available pt_mstr then do:
      desc1 = pt_desc1.
      desc2 = pt_desc2.
/*GB18*/ if sod_desc <> "" then sod_desc = "".
/*G501** message  desc1 desc2. **/
   end.
   else if sod_desc <> "" then desc1 = sod_desc.

   /* SET GLOBAL PART VARIABLE */
   global_part = sod_part.

/*J042* DETERMINE DISCOUNT DISPLAY FORMAT */
/*J15C*J042* {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}  */
/*J15C*/ run p-disc-disp (input no).

         /* NOTE ABOUT QUANTITIES ON RMA'S:  THE QTY ORDERED IS STORED */
         /* IN BOTH SOD_DET AND RMD_DET.  IN RMD_DET, THE QUANTITY IS  */
         /* ALWAYS POSITIVE.  FOR RMA ISSUE LINES (REMEMBER, THESE ARE */
         /* REPAIRED/REPLACEMENT ITEMS WE'RE SENDING TO THE CUSTOMER), */
         /* SOD_QTY_ORD IS POSITIVE (IN FACT, WE DON'T WANT TO ALLOW   */
         /* NEGATIVES FOR RMA'S).  FOR RMA RECEIPT LINES, HOWEVER,     */
         /* (REMEMBER, THESE ARE FOR THE DEFECTIVE/BROKEN ITEMS THE    */
         /* CUSTOMER IS RETURNING) SOD_QTY_ORD IS NEGATIVE.            */
         /* FOR NEW RMA RECEIPT LINES, DON'T DISPLAY PRICE BECAUSE     */
         /* RESTOCKING CHARGES HAVEN'T BEEN CALCULATED YET.            */

/*J04C*/ if this-is-rma and not rma-issue-line then
/*J04C*/    display line
/*J04C*/            sod_part
/*J04C*/            (sod_qty_ord * -1) @ sod_qty_ord
/*J04C*/            sod_um
/*J04C*/            sod_list_pr  when (not new_line)
/*J0N2** /*J04C*/   discount when (discount > -9999.9999 and
**                                 discount < 9999.9999) */
/*J0N2*/            discount
/*J04C*/            sod_price when (not new_line)
/*J04C*/    with frame c.
/*J04C*/ else
            display line sod_part sod_qty_ord sod_um
/*J042**            sod_list_pr sod_disc_pct
** /*G0WL/*FT43*/       when (sod_disc_pct > -99999.99 and sod_disc_pct < 99999.99) */
** /*G0WL*/             when (sod_disc_pct >= -99999.99 and sod_disc_pct <= 99999.99)
**J042*/
/*J0N2** /*J042*/   sod_list_pr discount when (discount >= -9999.9999 and
**                                    discount <=  9999.9999) */
/*J0N2*/            sod_list_pr discount
                    sod_price
            with frame c.

   if sngl_ln then
      display sod_qty_all sod_qty_pick sod_qty_ship sod_qty_inv
              sod_site sod_loc sod_serial
/*LB01*/      /*sod_std_cost*/ desc1 /*base_curr*/
              sod_req_date sod_per_date sod_due_date
/*J042*/      sod_pricing_dt
/*G035*/      sod_fr_list
/*H0N1*/      sod_fix_pr sod_crt_int
              sod_acct sod_cc sod_dsc_acct sod_dsc_cc
/*F356*/      sod_project sod_confirm
              sod_type sod_um_conv sod_consume sod-detail-all
/*F519*/      sod_taxable sod_taxc /* (sod_cmtindx <> 0 ) @ sodcmmts */
/*H0N1** /*G415*/      when (not {txnew.i})                          */
/*F519*/      (sod_cmtindx <> 0 or (new_line and soc_lcmmts)) @ sodcmmts
/*F297*/      sod_slspsn[1] mult_slspsn sod_comm_pct[1]
/*G2H6**      sod_crt_int sod_fix_pr                                 */
      with frame d.

         /* REMEMBER, FOR RMA RECEIPT LINES, THE SOD_QTY'S ARE NEGATIVE */
         /* BUT THE USER WOULD PREFER SEEING POSITIVE NUMBERS...        */
/*J04C*/ if sngl_ln and this-is-rma and not rma-issue-line then
/*J04C*/    display (sod_qty_ship * -1) @ sod_qty_ship
/*J04C*/            (sod_qty_inv * -1)  @ sod_qty_inv
/*J04C*/    with frame d.

   assign
/*F723*/ prev_confirm = sod_confirm
   prev_type = sod_type
   prev_site = sod_site
   prev_due  = sod_due_date
   prev_qty_ord  = sod_qty_ord * sod_um_conv
   prev_abnormal = sod_abnormal
   prev_consume  = sod_consume
   del-yn = no.

/*J042*/ /*SAVE CURRENT QTY ORDERED,UM, AND PARENT LIST TO DETERMINE
           DIFFERENCE IF QTY, UM, OR PARENT LIST CHANGED WHEN CALLING
                      THE PRICING ROUTINES*/

/*J0KJ** /*J042*/ if line_pricing or not new_order then do: */
         /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
/*J0KJ*/ if rma-issue-line and (line_pricing or not new_order) then do:
/*J042*/    save_qty_ord = sod_qty_ord.
/*J042*/    save_um      = sod_um.
/*J042*/    if can-find(first sob_det where sob_nbr  = sod_nbr and
/*J042*/                                    sob_line = sod_line) then do:
/*J042*/       find first pih_hist where pih_doc_type = 1        and
/*J042*/                                 pih_nbr      = sod_nbr  and
/*J042*/                                 pih_line     = sod_line and
/*J042*/                                 pih_parent   = ""       and
/*J042*/                                 pih_feature  = ""       and
/*J042*/                                 pih_option   = ""       and
/*J042*/                                 pih_amt_type = "1"
/*J042*/                           no-lock no-error.
/*J042*/       if available pih_hist then
/*J042*/          save_parent_list = pih_amt.
/*J042*/       else do:
/*J042*/          save_parent_list = 0.
/*J042*/          for each sob_det where sob_nbr  = sod_nbr and
/*J042*/                                 sob_line = sod_line
/*J042*/                           no-lock:
/*J042*/             save_parent_list = save_parent_list + sob_tot_std.
/*J042*/          end.
/*J042*/          save_parent_list = sod_list_pr - save_parent_list.
/*J042*/       end.
/*J042*/    end.
/*J042*/    else
/*J042*/       save_parent_list = sod_list_pr.
/*J042*/ end.

         /* ORDER QUANTITY */
/*F802*  if sod_type <> "F" then do on error undo, retry: */
/*F802*/ if not sod_sched then
/*J04C*/ do:
/*F802*/ do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


         ststatus = stline[2].
         status input ststatus.

/*H008*/ old_sod_site = sod_site.

/*G1V1*/ find pt_mstr no-lock where pt_part = sod_part no-error.
/*G1V1*/ if available pt_mstr then do:
/*G1V1*/    pm_code = pt_pm_code.
/*G1V1*/    find ptp_det where ptp_part = pt_part
/*G1V1*/                   and ptp_site = sod_site no-lock no-error.
/*G1V1*/    if available ptp_det then pm_code = ptp_pm_code.
/*G1V1*/ end.

/*J0MY*/ pause 0.
/*G501*/ /* SITE - Allow site input through pop-up */
/*G1V1* /*J0MY*/ if sngl_ln then */
/*G1V1*/ if sngl_ln then do:
/*G1V1*/    if (new sod_det and pm_code = "C") or pm_code <> "C" then
/*J0MY*/       display sod_site with frame c_site.
/*G1V1*/ end.

/*J152**
* /*J0MY*/ else do:
* /*J0MY*/    message.  message.
* /*J0MY*/ end.
*J152*/

         setsite:
         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


/*J0MY*  ENSURE THE USER GETS A CHANCE TO OVERRIDE THE DEFAULT SITE *****
./*J034*/    if sod_site <> "" then do:
./*J034*/       {gprun.i ""gpsiver.p""
.                "(input sod_site, input ?, output return_int)"}
./*J034*/       if return_int = 0 then do:
./*J034*/          {mfmsg.i 725 4} /* USER DOES NOT HAVE ACCESS TO THIS SITE */
./*J034*/          if not batchrun then do:
./*J034*/             pause.
./*J034*/             clear frame c.
./*J034*/          end.
./*J034*/          undo loopc, leave loopc.
./*J034*/       end.
./*J034*/    end.
.*J0MY*********************/
/*FR95*     if sngl_ln then do: */
/*FR95*/    if sngl_ln then do on endkey undo, leave loopc:
/*J0MY*               pause 0.      */
/*J1RY*/        if cfexists then assign cf_rp_part = no.
/*FR95*         update sod_site
                with frame c_site overlay row 5 column 16 editing:
*/
/*J0MY* /*FR95*/        update sod_site with frame c_site editing:  */

/*G1V1*/       if (new sod_det and pm_code = "C") or pm_code <> "C" then do:
/*J0MY*/         set sod_site with frame c_site editing:
                    readkey.

                    /* DELETE */
                    /* (Delete logic repeated so delete on quantity is valid */
                    /* for multi-line mode.)                                 */
                    if lastkey = keycode("F5")
                    or lastkey = keycode("CTRL-D")
                    then do:
/*J04C*                ADDED THE FOLLOWING */
                       /* IF THIS IS AN RMA LINE, CHECK FOR LINKED RTS    */
                       /* LINES.  IF ANY, WARN USER OF LINKAGE.           */
                       if this-is-rma then do:
                          if rma-issue-line then do:
                          end.    /* if rma-issue-line */
                          else do for rtsbuff:
                             find rtsbuff
                              where rtsbuff.rmd_nbr    = rmd_det.rmd_rma_nbr
                              and   rtsbuff.rmd_prefix = "V"
                              and   rtsbuff.rmd_line   = rmd_det.rmd_rma_line
                              no-lock no-error.
                              if  available rtsbuff then do:
                                 {mfmsg.i 1120 2}
                                 /* THIS IS LINKED TO ONE OR MORE RTS LINES */
                              end.
                          end.    /* else, rma-receipt-line, do */
                       end.   /* if this-is-rma */
/*J04C*                END ADDED CODE */
                       del-yn = yes.
                       {mfmsg01.i 11 1 del-yn}
                       if sod_qty_inv <> 0 and del-yn then do:
                          {mfmsg.i 604 3} /* Outstanding qty to inv, */
                          undo.           /*  delete not allowed     */
                       end.


/*G2H6*/         shipper_found = 0.
/*G2H6*/         {gprun.i ""rcsddelb.p"" "(input sod_nbr, input sod_line,
                 input sod_site, output shipper_found, output save_abs)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G2H6*/         if shipper_found > 0 then do:
/*G2H6*/            {mfmsg03.i 1118 3 shipper_found save_abs """"}
/*G2H6*/            /* # Shippers/Containers exists for order, including # */
/*G2H6*/            undo.
/*G2H6*/         end.

                       if del-yn then do:
                          /*DELETE COMMENTS*/
/*H510*/                  for each cmt_det where cmt_indx = sod_cmtindx
/*H510*/                     exclusive-lock:
                             delete cmt_det.
                          end.
                          leave.
                       end.
                    end.    /* if lastkey... */
/*FR95*
 *                  else
 *                   if lastkey = keycode("F4")
 *                   or lastkey = keycode("CTRL-E")
 * /**               then leave loopc. **/
 *                   then undo loopc, leave.
 *FR95**/
                    else
                    apply lastkey.
                  end. /* editing: */
/*G1V1*/       end. /* if new sod_det */
            end.  /* update sod_site */

/*J034*/    {gprun.i ""gpsiver.p""
            "(input sod_site, input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/    if return_int = 0 then do:
/*J034*/       if sngl_ln then do:
/*J034*/          {mfmsg.i 725 3} /* USER DOES NOT HAVE ACCESS TO THIS SITE */
/*J034*/          next-prompt sod_site with frame c_site.
/*J034*/          undo setsite, retry.
/*J034*/       end.
/*J034*/       else do:
/*J034*/          {mfmsg.i 725 4} /* USER DOES NOT HAVE ACCESS TO THIS SITE */
/*J034*/          if not batchrun then pause.
/*J034*/          undo loopc, leave loopc.
/*J034*/       end.
/*J034*/    end.


            /* Validate the part/site combination */
            if sod_type = "" then do:

               new_site = sod_site.
               {gprun.i ""gpptsi01.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

               if err_stat <> 0 then do:

/*F0G8*/          /* COULD NOT CONNECT REMOTE DATABASE */
/*F0G8*/          if err_stat = 3 then do:
/*F0G8*/             /* ALLOW TO CONTINUE IF NOT CONFIRMED & ISSUE WARNING */
/*F0G8*/             if not sod_confirm then err_stat = 2.
/*F0G8*/             /* GIVE ERROR AND UNDO */
/*F0G8*/             else err_stat = 3.
/*F0G8*/             {mfmsg.i 2505 err_stat}
/*F0G8*/             if not sod_confirm then err_stat = 0.
/*F0G8*/             else do:
/*F0G8*/                pause 5.
/*F0G8*/                undo setsite, retry.
/*F0G8*/             end.
/*F0G8*/          end.
/*F0G8*/          else
/*H295*/          /* Changed validation to remove option to create in_mstr. */
                  if not sngl_ln then do:
                     /* Try to use default site in item master */
                     find pt_mstr where pt_part = sod_part no-lock.
                     if pt_site <> sod_site then do:
                        new_site = pt_site.
                        {gprun.i ""gpptsi01.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

                     end.
                  end.
                  if err_stat <> 0 then do:
                     {mfmsg.i 715 3} /* Item does not exist at site */
                     if not batchrun then pause.
                     undo setsite, retry.
                  end.

/*H295* - Changed validation to remove option to create in_mstr. **
 *                if sngl_ln then do:
 *                   if err_stat = 1 then do:
 *                      /* Create in_mstr so can update in_qty_req */
 *                      {mfmsg01.i 810 1 yn} /* OK to add? */
 *                      if not yn then undo setsite, retry.
 *                      create in_mstr.
 *                      in_part = sod_part.
 *                      in_site = sod_site.
 *                      /*F003 - Default new inventory costs from site */
 *                      find si_mstr where si_site = in_site no-lock no-error.
 *                      if available si_mstr
 *                         then assign in_gl_set  = si_gl_set
 *                                     in_cur_set = si_cur_set.
 *                      if available pt_mstr
 *                         then assign in_abc     = pt_abc
 *                                     in_avg_int = pt_avg_int
 *                                     in_cyc_int = pt_cyc_int.
 *                   end.
 *                   else do:
 *                      {mfmsg.i 715 3} /* Part does not exist at site */
 *                      undo setsite, retry.
 *                   end.
 *                end.
 *                else do:
 *                   /* Try to use default site in item master */
 *                   find pt_mstr where pt_part = sod_part no-lock.
 *                   if pt_site <> sod_site then do:
 *                      new_site = pt_site.
 *                      {gprun.i ""gpptsi01.p""}
 *                      if err_stat <> 0 then do:
 *                         /* Look for a valid site in the SO database */
 *                         find first in_mstr
 *                          where in_part = sod_part no-lock no-error.
 *                         if available in_mstr then do:
 *                            sod_site = in_site.
 *                            if sngl_ln then display sod_site.
 *                            err_stat = 0.
 *                         end.
 *                      end.
 *                   end.
 *                   /* If we still don't have a valid site, create one */
 *                   if err_stat <> 0 then do:
 *                      if pt_site <> "" then sod_site = pt_site.
 *                      /* Create in_mstr so can update in_qty_req */
 *                      {mfmsg02.i 811 1 sod_site}
 *                      /* Inventory Master created in site (sod_site) */
 *                      create in_mstr.
 *                      in_part = sod_part.
 *                      in_site = sod_site.
 *                      /*F003 - Default new inventory costs from site */
 *                      find si_mstr where si_site = in_site no-lock no-error.
 *                      if available si_mstr
 *                         then assign in_gl_set  = si_gl_set
 *                                     in_cur_set = si_cur_set.
 *                         assign in_abc     = pt_abc
 *                                in_avg_int = pt_avg_int
 *                                in_cyc_int = pt_cyc_int.
 *                   end.
 *                end.
 *
 *                if new(in_mstr) then do:
 *                   find ptp_det no-lock where ptp_part = in_part
 *                   and ptp_site = in_site no-error.
 *                   if available ptp_det then do:
 *                      if ptp_pm_code = "D"
 *                      then in_level = ptp_ll_drp.
 *                      else in_level = ptp_ll_bom.
 *                   end.
 *                   else do:
 *                      find pt_mstr where pt_part = sod_part no-lock.
 *                      if pt_pm_code <> "D" then in_level = pt_ll_code.
 *                   end.
 *                end.
 *******H295*/
               end.

               if desc2 <> "" or not sngl_ln then message desc1 desc2.
               /* Display available quantity at selected site */
/*G0H7         if new_line then do: */
                  new_site = sod_site.
                  {gprun.i ""zzbgpavlsi3.p""} /*lb03*/

/*lb03					
				/*lb02*--*/
		      	find pt_mstr no-lock where pt_part = sod_part no-error.
				find ptp_det no-lock where ptp_part = sod_part
						and ptp_site = sod_site no-error.
				message "最小订货量: " + 
						if available ptp_det then string(ptp_ord_min) 
						else if available pt_mstr then string(pt_ord_min)
						else "0".
                /*--lb02*/
lb03*/
/*GUI*/ if global-beam-me-up then undo, leave.

/*G0H7         end. */

            end. /* End part/site validation */

            if sngl_ln then do:
               display sod_site with frame d.
               hide frame c_site no-pause.
            end.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.

         global_site = sod_site.

/*J1RY*/ /*determine whether item is calico controlled*/
/*J1RY*/ if cfexists then do:
/*J1RY*/    cf_sod_rec = recid(sod_det).
/*J1RY*/    if recid(sod_det) = - 1 then.
/*J1RY*/    cf_undo = yes.
/*J1RY*/    {gprunmo.i
               &module  = "cf"
               &program = "cfsocfg1.p"
            }
/*J1RY*/    if cf_undo and not del-yn then undo loopc, leave.
/*J1RY*/ end. /*cfexists*/
/*J1RY*/ if cf_config and cf_rm_old_bom then do:
/*J1RY*/    delete_line = yes.
/*J1RY*/    /*delete the sales order bill*/
/*LB01*//*J1RY*/{gprun.i ""zzsosomtk.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J1RY*/    delete_line = no.
/*J1RY*/    {gprun.i ""gppihdel.p"" "(1, sod_nbr, sod_line)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J1RY*/ end.

/*J1RY*/ /*del-yn = yes if configurator returns a replcement item and    */
/*J1RY*/ /*user wishes to use this item and delete any exisitng line     */
/*J1RY*/ /*information. cf_undo = yes if error occued in the program or  */
/*J1RY*/ /*for example, the user tried to enter a sq line for a concinity*/
/*J1RY*/ /*controlled item and they were on a unix platform etc.         */


/*G501********** end section **/

         /* QUANTITY, ORDER UNIT OF MEASURE */
/*F0LM   COMMENTED OUT THIS SECTION
 *G501*  if not del-yn then
 *FR95*  set1: do with frame c on error undo, retry:  *
 *FR95*  set1: do with frame c on error undo, retry on endkey undo, leave loopc:
 *G191*    update sod_qty_ord sod_um with frame c editing:
 *G191*    if not new_line and available pt_mstr and pt_pm_code = "C"
 *G191*    and input sod_um <> sod_um then do:
 *G191*       {mfmsg.i 685 1} /* Unit of measure change not allowed */
 *G191*       undo loopc, retry.
 *G191*    end.
           readkey.
 *F0LM   END SECTION COMMENTED OUT */

/*F0LM*/ if not del-yn then do:
/*F0LM*/    old_um = sod_um.
/*H1B1*/    l_prev_um_conv = sod_um_conv.
/*F0LM*/    display sod_qty_ord sod_um with frame c.
/*J04C*/    if this-is-rma and not rma-issue-line then
/*J04C*/        display (sod_qty_ord * -1) @ sod_qty_ord
/*J04C*/        with frame c.
/*F0LM*/    set1:
/*F0LM*/    do with frame c on error undo, retry on endkey undo, leave loopc:
/*GUI*/ if global-beam-me-up then undo, leave.

/*F0LM*/       set sod_qty_ord sod_um go-on ("F5" "CTRL-D") with frame c.
/*F0LM*/       if not new_line and available pt_mstr and pt_pm_code = "C"
/*F0LM*/       and input sod_um <> old_um then do:
/*F0LM*/          {mfmsg.i 685 1} /* Unit of measure change not allowed */
/*F0LM*/          next-prompt sod_um with frame c.
/*F0LM*/          undo set1, retry.
/*F0LM*/       end.

/*J04C*        ADDED THE FOLLOWING */
               /* FOR RMA'S, THE USER MAY NOT ENTER NEGATIVE ORDER QUANTITY */
               /* IF THIS IS A RECEIPT LINE, WE MUST REVERSE THE SIGN ON    */
               /* THE QUANTITY THEY DO ENTER - RECALL THAT FOR RECEIPTS,    */
               /* SOD_QTY_ORD IS NEGATIVE AND RMD_QTY_ORD IS POSITIVE...    */
               if this-is-rma then do:
                    if sod_qty_ord < 0 then do:
                        {mfmsg.i 234 3}  /* ORDER QTY CANNOT BE NEGATIVE */
                        next-prompt sod_qty_ord with frame c.
                        undo set1, retry.
                    end.
                    if not rma-issue-line then
                        assign sod_qty_ord = -1 *  sod_qty_ord.

                    /* FOR RMA RECEIPT LINES, WARN USER IF HE ENTERS AN ORDER */
                    /* QTY TOO SMALL FOR WHAT'S ALREADY BEEN RECEIVED.        */
                    /* (THIS WAS A WARNING IN FSRMAREC.P ALSO)                */
                    if not rma-issue-line and (sod_qty_chg + sod_qty_ship)
                        < sod_qty_ord then do:
                        {mfmsg.i 7201 2}
                        /* QTY TO RECEIVE + QTY RECEIVED > QTY EXPECTED */
                    end.
              end.  /* if this-is-rma */
/*J04C*       END ADDED CODE */

              /* CONFIRM DELETE */
              if lastkey = keycode("F5")
              or lastkey = keycode("CTRL-D")
              then do:
/*J04C*          ADDED THE FOLLOWING */
                 /* IF THIS IS AN RMA LINE, CHECK FOR LINKED RTS    */
                 /* LINES.  IF ANY, WARN USER OF LINKAGE.           */
                 if this-is-rma then do:
                        if rma-issue-line then do:
                        end.    /* if rma-issue-line */
                        else do for rtsbuff:
                          find rtsbuff
                              where rtsbuff.rmd_nbr    = rmd_det.rmd_rma_nbr
                              and   rtsbuff.rmd_prefix = "V"
                              and   rtsbuff.rmd_line   = rmd_det.rmd_rma_line
                              no-lock no-error.
                          if  available rtsbuff then do:
                              {mfmsg.i 1120 2}
                              /* THIS RMA LINE IS LINKED TO ONE OR MORE RTS LINES */
                          end.
                        end.    /* else, rma-receipt-line, do */
                 end.   /* if this-is-rma */
/*J04C*          END ADDED CODE */
                 del-yn = yes.
                 {mfmsg01.i 11 1 del-yn}
                 if sod_qty_inv <> 0 and del-yn then do:
                    {mfmsg.i 604 3} /* Outstanding qty to inv, */
                    undo.           /* delete not allowed.     */
                 end.

/*G2H6*/         shipper_found = 0.
/*G2H6*/         {gprun.i ""rcsddelb.p"" "(input sod_nbr, input sod_line,
                 input sod_site, output shipper_found, output save_abs)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G2H6*/         if shipper_found > 0 then do:
/*G2H6*/            {mfmsg03.i 1118 3 shipper_found save_abs """"}
/*G2H6*/            /* # Shippers/Containers exists for order, including # */
/*G2H6*/            undo.
/*G2H6*/         end.

/*G501*/         if del-yn then do:
/*G501*/            /*DELETE COMMENTS*/
/*H510*/            for each cmt_det where cmt_indx = sod_cmtindx
/*H510*/               exclusive-lock:
/*G501*/               delete cmt_det.
/*G501*/            end.
/*F0LM /*G501*/            leave. */
/*G501*/         end.
              end.
/*FR95**      else
 *               if lastkey = keycode("F4")
 *               or lastkey = keycode("CTRL-E")
 *               then leave loopc.
 *FR95**/
/*F0LM        else
 *               apply lastkey.
 *
 *          end.  /* update editing: */
 *F0LM*/

/*G191*/ end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* set1 */
/*F0LM*/ end. /* del-yn do */
/*J04C*/ end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do on error... */
   end. /* if not sod_sched */
/*F802*/ else do:
/*H561*/    pause 0.
/*F802*/    {mfmsg.i 6014 1} /* Schedule exists for this order line */
/*F802*/ end.

   if del-yn then do:
      assign
/*FO23*/      prev_qty_ship = sod_qty_ship * sod_um_conv
/*J0R1*/      temp_sod_qty_ord  = sod_qty_ord
/*J0R1*/      temp_sod_qty_ship = sod_qty_ship
/*J0R1*/      temp_sod_qty_all  = sod_qty_all
/*J0R1*/      temp_sod_qty_pick = sod_qty_pick
              sod_qty_ord  = 0
              sod_qty_ship = 0
              sod_qty_all  = 0
              sod_qty_pick = 0.
   end.
   else do:

      ststatus = stline[3].
      status input ststatus.

      /* CALCULATE UM CONVERSION */
      {mfumcnv.i sod_um sod_part sod_um_conv}
      
      /*lb02--*/
      
      	find pt_mstr no-lock where pt_part = sod_part no-error.
		find ptp_det no-lock where ptp_part = sod_part
				and ptp_site = sod_site no-error.
		if available ptp_det then do:
			if ptp_ord_min <> 0 and sod_qty_ord * sod_um_conv < ptp_ord_min then do:
				message "警告：小于最小订货量 " + string(ptp_ord_min) 
				        + if available pt_mstr then pt_um else "".
				pause.
			end.
		end.
		else do:
			if available pt_mstr then do:
				if pt_ord_min <> 0 and sod_qty_ord * sod_um_conv < pt_ord_min then do:
					message "警告：小于最小订货量 " + string(pt_ord_min) + pt_um.
					pause.
				end.
			end.
		end.
      
      /*--LB02*/

      /* CALCULATE COST ACCORDING TO UM */
/*G391*/ if available pt_mstr then do:
/*F0DR*    {gpsct05.i &part=sod_part &site=sod_site &cost=sct_cst_tot} */
/*G507*     sod_std_cost = glxcst * sod_um_conv. */

/*F0DR*/    remote-base-curr = "".
/*F0DR*/    /* Find out if we need to change databases */
/*F0DR*/    find si_mstr where si_site = sod_site no-lock.
/*F0DR*/    chg-db = (si_db <> so_db).
/*F0DR*/    if chg-db then do:
/*F0DR*/      /* Switch to the Inventory site */
/*F0DR*/      {gprun.i ""gpalias2.p"" "(sod_site,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.


/*F0G8*/      if err-flag = 0 or err-flag = 9 then do:
/*F0DR*/         {gprun.i ""gpbascur.p"" "(output remote-base-curr)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*F0G8*/      end.
/*F0DR*/    end.
/*F0DR*/    {gprun.i ""gpsct05.p""
                    "(input sod_part,input sod_site,input 1,
                      output glxcst,output curcst)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*F0DR*/    exch-rate = 1.
/*F0DR*/    if remote-base-curr <> base_curr then do:
/*F0DR*/       {gpgtex8.i &ent_curr = base_curr
                         &curr     = remote-base-curr
                         &date     = so_ord_date
                         &exch_from = exd_ent_rate
                         &exch_to   = exch-rate}
/*F0DR*/    end.
/*F0DR*/    if chg-db then do:
/*F0DR*/       /* switch the database alias back to the sales order db */
/*F0DR*/       {gprun.i ""gpalias3.p"" "(so_db,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*F0DR*/    end.
/*G830*/    if new sod_det or (not new sod_det and pt_pm_code <> "C") then
/*H086*/       /* sod_std_cost = glxcst. */
/*H086*/       sod_std_cost = glxcst * sod_um_conv.
/*F0DR*     if sngl_ln then display sod_std_cost sod_um_conv with frame d.*/

/*J1XW** ** MOVED DISPLAY AFTER PRICING POP-UP TO RETAIN UM WARNINGS ** */
/*J1XW**
 * /*F0DR*/ /*   if sngl_ln then display sod_std_cost * exch-rate @ sod_std_cost*/
 * /*F0DR*/ /*   sod_um_conv with frame d.*/
 *J1XW**/

/*G391*/ end.

/*H086*/ /* Moved price conversion to line um up before all price table */
/*H086*/ /* and disc table calls. Because table routines now handle the */
/*H086*/ /* um conversion themselves.                                   */
/*H086*/ if new sod_det and available pt_mstr then do:
/*H086*/    sod_price = sod_price * sod_um_conv.
/*H086*/    sod_list_pr = sod_list_pr * sod_um_conv.
/*H086*/ end.

/*H086*/ /* POP-UP FOR REQUIRED ITEMS BEFORE PRICING */
/*J042** REVISIED POP-UP FOR REQUIRED ITEMS BEFORE PRICING**************
** /*H510** lineffdate = so_due_date. **/
** /*H510*/ lineffdate = so_ord_date.
** /*H086*/ if sngl_ln and soc_pc_line then do:
**
** /* THIS LOGIC EXISTS BECAUSE OF PROBLEMS WITH THE OVERLAY FRAME DISPLAY
**    AND CUSTOMER SCHEDULING MESSAGE 6014 ABOVE */
** /*H561*/    if sod_sched then
** /*H561*/       pause 2.
** /*H561*/    else
** /*H086*/       pause 0.
**
** /*H086*/    update
** /*H086*/       sod_due_date
** /*H184*/       sod_crt_int
** /*H086*/    with frame line_pop overlay.
**
** /*H086*/    display
** /*H086*/       sod_due_date
** /*H184*/       sod_crt_int
** /*H086*/    with frame d.
** /*H086*/    hide frame line_pop no-pause.
** /*H086*/    lineffdate = sod_due_date.
** /*H086*/ end.
** /*H086*/ if lineffdate = ? then
** /*H086*/    lineffdate = today.
**J042*/

/*J0N2**
** /*J042*/ if sngl_ln and (soc_pc_line or (not reprice and not new_order)) */
         /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
/*J0N2*/ if sngl_ln and (rma-issue-line or (not reprice and not new_order))
/*J042*/ then do:
/*J042*/    if sod_sched then
/*J042*/       pause 2.
/*J1XW** ** MOVED PAUSE 0 AFTER PRICING POP-UP TO RETAIN UM WARNINGS ** */
/*J1XW**
 * /*J042*/ else
 * /*J042*/    pause 0.
 *J1XW**/

/*J042*/
/*J0KJ** /*J042*/ update sod_pricing_dt when (soc_pc_line) */
            /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
/*J0KJ*/    update sod_pricing_dt when (rma-issue-line and soc_pc_line)
/*J0KJ** /*J042*/  sod_crt_int    when (soc_pc_line) */
/*J0KJ*/           sod_crt_int    when (rma-issue-line and soc_pc_line)
/*J0XR** /*J042*/  reprice_dtl    when (not reprice and not new_order) */
/*J0XR*/           reprice_dtl    when (not reprice_dtl and not new_order)
/*J0N2*/           sod_pr_list    when (rma-issue-line)
/*J042*/    with frame line_pop.
/*J042*/
/*J042*/    display sod_pricing_dt
/*J042*/            sod_crt_int
/*J042*/         /* reprice_dtl * currently not displaying w/frame d */
/*J042*/    with frame d.
/*J042*/    hide frame line_pop no-pause.
/*J1XW*/    pause 0.
/*J042*/ end.
/*J1XW*/ /*if sngl_ln and available pt_mstr then*/
/*J1XW*/ /*    display sod_std_cost * exch-rate @ sod_std_cost*/
/*J1XW*/ /*    sod_um_conv with frame d.*/


/*J042** PRICING LOGIC FOR BEST LIST PRICE REPLACES THIS CODE*************
** /*H086*/ /* PRICE TABLE LIST PRICE LOOK-UP */
** /*H086*/ if so_pr_list2 <> "" then do:
**
** /*H510*/    /* Added parameters for price table required, recid */
** /*H086*/    {gprun.i ""gppclst.p""
**                     "(input        so_pr_list2,
**                       input        sod_part,
**                       input        sod_um,
**                       input        sod_um_conv,
**                       input        lineffdate,
**                       input        so_curr,
**                       input        new_line,
**                       input        soc_pt_req,
**                       input-output sod_list_pr,
**                       input-output sod_price,
**                       output       minprice,
**                       output       maxprice,
**                       output       pc_recno
**                      )" }
** /*H443**    tblprice = sod_list_pr. **/
**
** /*H086*/ end.
**J042*/

/*J0GT*/ /* MOVED THE UPDATING OF pm_code FROM JUST ABOVE CALL TO */
/*J0GT*/ /* sosomtf8.p TO HERE IN ORDER TO UPDATE THE             */
/*J0GT*/ /* exclude_confg_disc VARIABLE WHICH gppibx.p FOR        */
/*J0GT*/ /* DISCOUNTS MUST TEST FOR.                              */

/*J0GT*/ pm_code = "".
/*J0GT*/ if available pt_mstr then pm_code = pt_pm_code.
/*J0GT*/ find ptp_det where ptp_part = sod_part and ptp_site = sod_site
/*J0GT*/ no-lock no-error.
/*J0GT*/ if available ptp_det then pm_code = ptp_pm_code.

/*J0GT*/ if pm_code = "C" then
/*J0GT*/    exclude_confg_disc = yes.

/*J042*/ /* INITIALIZE PRICING VARIABLES AND PRICING WORKFILE
            wkpi_wkfl FOR CURRENT sod_part*/

/*J0KJ** if line_pricing or reprice_dtl then do: */
         /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
/*J0KJ*/ if rma-issue-line and (line_pricing or reprice_dtl) then do:

            best_list_price = 0.
            best_net_price  = 0.
            min_price       = 0.
            max_price       = 0.
            sobparent       = "".
            sobfeature      = "".
            sobpart         = "".
/*J0N2*/    manual_list     = if sod_pr_list <> "" then
/*J0N2*/                         sod_pr_list
/*J0N2*/                      else
/*J0N2*/                         so_pr_list.

/*LB01*/    {gprun.i ""zzgppiwk01.p"" "(
                                      1,
                                      sod_nbr,
                                      sod_line
                                     )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J042*/
/*J042*/ /*GET BEST LIST TYPE PRICE LIST, SET MIN/MAX FIELDS*/

/*J0XR*/    /*Added sod_site, so_ex_rate to parameters*/
            {gprun.i ""gppibx.p"" "(
                                    pics_type,
                                    picust,
                                    part_type,
                                    sod_part,
                                    sobparent,
                                    sobfeature,
                                    sobpart,
                                    1,
                                    so_curr,
                                    sod_um,
                                    sod_pricing_dt,
                                    soc_pt_req,
                                    sod_site,
                                    so_ex_rate,
                                    output err_flag
                                   )"}
/*GUI*/ if global-beam-me-up then undo, leave.


            if soc_pt_req or best_list_price = 0 then do:
               find first wkpi_wkfl where wkpi_parent   = ""  and
                                          wkpi_feature  = ""  and
                                          wkpi_option   = ""  and
                                          wkpi_amt_type = "1"
                                    no-lock no-error.
               if soc_pt_req then do:
                  if (available wkpi_wkfl and wkpi_source = "1") or
                    not available wkpi_wkfl then do:
/*H0FS               {mfmsg03.i 6231 3 sod_part sod_um """"} */
/*H0FS*/             {mfmsg03.i 6231 4 sod_part sod_um """"}
                     /*Price table for sod_part in sod_um not found*/
                     if not batchrun then pause.
                     undo, return.
                  end.
               end.
               if best_list_price = 0 then do:
                  if not available wkpi_wkfl then do:
                     if available pt_mstr then do:
                        best_list_price = pt_price * so_ex_rate * sod_um_conv.
                        /*Create list type price list record in wkpi_wkfl*/
/*LB01*/              {gprun.i ""zzgppiwkad.p"" "(
                                                  sod_um,
                                                  sobparent,
                                                  sobfeature,
                                                  sobpart,
                                                  ""4"",
                                                  ""1"",
                                                  best_list_price,
                                                  0,
                                                  no
                                                 )"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     end.
                     else do:
                        /*Create list type price list record in wkpi_wkfl
                          for memo type*/
                        best_list_price = sod_list_pr.
/*LB01*/                {gprun.i ""zzgppiwkad.p"" "(
                                                  sod_um,
                                                  sobparent,
                                                  sobfeature,
                                                  sobpart,
                                                  ""7"",
                                                  ""1"",
                                                  best_list_price,
                                                  0,
                                                  no
                                                 )"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     end.
                  end.
                  else
/*J0GT**             best_list_price = sod_list_pr. */
/*J0GT*/             best_list_price = wkpi_amt.
               end.
            end.
            sod_list_pr = best_list_price.
            sod_price   = best_list_price.

            /*CALCULATE TERMS INTEREST*/

            if sod_crt_int <> 0 and (available pt_mstr or sod_type <> "")
            then do:
               sod_list_pr     = (100 + sod_crt_int) / 100 * sod_list_pr.
               sod_price       = sod_list_pr.
               best_list_price = sod_list_pr.
               /*Create credit terms interest wkpi_wkfl record*/
/*LB01*/        {gprun.i ""zzgppiwkad.p"" "(
                                         sod_um,
                                         sobparent,
                                         sobfeature,
                                         sobpart,
                                         ""5"",
                                         ""1"",
                                         sod_list_pr,
                                         0,
                                         no
                                        )"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.

            parent_list_price = best_list_price. /*gppiwk02.p needs this*/

/*J042*/ end. /*line_pricing or reprice_dtl*/

/*J042*/ /*UPDATE QTY AND EXT LIST IN ACCUMULATED QTY WORKFILES*/

/*J0KJ** /*J042*/ if line_pricing or not new_order then do: */
         /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
/*J0KJ*/ if rma-issue-line and (line_pricing or not new_order) then do:
            if ((save_parent_list <> sod_list_pr) or
                (save_um <> sod_um)) and save_qty_ord <> 0 then do:
/*LB01*/        {gprun.i ""zzgppiqty2.p"" "(
                                         sod_line,
                                         sod_part,
                                       - save_qty_ord,
                                       - (save_qty_ord * save_parent_list),
                                         save_um,
                                         yes,
/*J0Z6*/                                 yes,
                                         yes
                                        )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*LB01*/       {gprun.i ""zzgppiqty2.p"" "(
                                         sod_line,
                                         sod_part,
                                         sod_qty_ord,
                                         sod_qty_ord * sod_list_pr,
                                         sod_um,
                                         yes,
/*J0Z6*/                                 yes,
                                         yes
                                        )"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.
            else do:
/*LB01*/       {gprun.i ""zzgppiqty2.p"" "(
                                         sod_line,
                                         sod_part,
                                         sod_qty_ord - save_qty_ord,
                                         (sod_qty_ord - save_qty_ord) *
                                          sod_list_pr,
                                         sod_um,
                                         yes,
/*J0Z6*/                                 yes,
                                         yes
                                        )"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.
/*J042*/ end. /*line_pricing or not new_order*/

/*J042*/ /*GET BEST DISCOUNT TYPE PRICE LISTS*/

/*J0HR** /*J042*/ if line_pricing or reprice_dtl then do:   */
/*J0KJ** /*J0HR*/ if sod_list_pr <> 0 and (line_pricing or reprice_dtl) then do:*/
         /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
/*J0KJ*/ if rma-issue-line and sod_list_pr <> 0 and
/*J0KJ*/                   (line_pricing or reprice_dtl) then do:
/*J0GT**    item_cost = 0. /*will force gppibx03.p to cost at this level*/ */
/*J0XR** /*J0GT*/ item_cost = glxcst. **Now performed in gppibx03.p*/
/*J0XR*/    /*Added sod_site, so_ex_rate to parameters*/
            {gprun.i ""gppibx.p"" "(
                                    pics_type,
                                    picust,
                                    part_type,
                                    sod_part,
                                    sobparent,
                                    sobfeature,
                                    sobpart,
                                    2,
                                    so_curr,
                                    sod_um,
                                    sod_pricing_dt,
                                    no,
                                    sod_site,
                                    so_ex_rate,
                                    output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.


             /*CALCULATE BEST PRICE, EXCLUDING GLOBAL DISCOUNTS*/

/*LB01*/     {gprun.i ""zzgppibx04.p"" "(
                                       sobparent,
                                       sobfeature,
                                       sobpart,
                                       no,
                                       rfact
                                      )"}
/*GUI*/ if global-beam-me-up then undo, leave.

             sod_price = best_net_price.
             if sod_list_pr <> 0 then
                sod_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.
             else
                sod_disc_pct = 0.

             /*DETERMINE DISCOUNT DISPLAY FORMAT*/
/*J15C*      {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}  */
/*J15C*/     run p-disc-disp (input no).
/*J0N2**     display sod_list_pr discount when (discount >= -9999.9999 and
**                                                discount <=  9999.9999) */
/*J0N2*/     display sod_list_pr discount
                     sod_price with frame c.

/*J042*/ end. /*line_pricing or reprice_dtl*/

/*J042** THE FOLLOWING CODE REPLACED BY "BEST" PRICING ROUTINES**********
** /*H510*/ /* Bounce line if the required item/um price tbl was not found */
** /*H510*/ if soc_pt_req and (so_pr_list2 = "" or pc_recno = 0) then do:
** /*H0FS /*H510*/ {mfmsg03.i 6231 3 sod_part sod_um """"} */
** /*H0FS*/    {mfmsg03.i 6231 4 sod_part sod_um """"}
** /*H510*/    /* Price table for sod_part in sod_um not found */
** /*H510*/    if not batchrun then pause.
** /*H510*/    undo loopc, leave.
** /*H510*/ end.
**
**
**       /* CALCULATE PRICE IF NEW LINE ITEM */
** /*H390   if new sod_det and available pt_mstr then do: */
** /*H390*/ if new sod_det and (available pt_mstr or sod_type <> "") then do:
**
** /*H184*/ /* CALC TERMS INTEREST */
** /*H184*/ if sod_crt_int <> 0 then do:
** /*H184*/    assign
** /*H184*/       sod_list_pr = (100 + sod_crt_int) / 100 * sod_list_pr
** /*H184*/       sod_price   = (100 + sod_crt_int) / 100 * sod_price.
** /*H443**       tblprice = sod_list_pr. **/
** /*H184*/ end.
**
**         /* CHECK FOR DISCOUNT TABLE PRICE */
**          if so_pr_list <> "" then do:
** /*G391*/    /* Price per price list, um conversion & exchange rate */
** /*H086*/    /* sod_recno = recid(sod_det). */
** /*H086*/    /* pt_recno = recid(pt_mstr).  */
** /*G692*/    match_pt_um = soc_pl_req.
** /*F463*     pcqty = sod_qty_ord. */
** /*H510**    pcqty = sod_qty_ord * sod_um_conv. **/
** /*H510*/    pcqty = sod_qty_ord.
** /*H086*/    /* {gprun.i ""sopccal.p""} */
** /*H294*/    /* Use lineffdate for look-up, same as Price Table */
** /*H510*/    /* Added pc_recno to gppccal call below */
** /*G0TW*/          /* Added supplier discount percent as input 10 */
** /*H086*/    {gprun.i ""gppccal.p""
**                     "(input        sod_part,
**                       input        pcqty,
**                       input        sod_um,
**                       input        sod_um_conv,
**                       input        so_curr,
**                       input        so_pr_list,
**                       input        lineffdate,
**                       input        sod_std_cost,
**                       input        match_pt_um,
**                     input        0,
**                       input-output sod_list_pr,
**                       output       sod_disc_pct,
**                       input-output sod_price,
**                       output       pc_recno
**                      )" }
**
** /*G244**    display sod_disc_pct sod_price with frame c. **/
**         end.
**
** /*G692*/ /*Bounce the line if the required item/um price list was not found*/
** /*H510*/ if soc_pl_req and (so_pr_list = "" or pc_recno = 0) then do:
** /*G692*/    /* Price list for sod_part in sod_um not found */
** /*H0GK* /*H086*/ {mfmsg03.i 689 3 sod_part sod_um """"}         */
** /*H0GK*/    /* Required discount table for item in um not found*/
** /*H0GK*/    {mfmsg03.i 982 3 sod_part sod_um """"}
** /*H0FS /*H0GK*/    {mfmsg03.i 982 3 sod_part sod_um """"} */
** /*H0FS*/    {mfmsg03.i 982 4 sod_part sod_um """"}
** /*G692*/    if not batchrun then pause.
** /*G692*/    undo loopc, leave.
** /*G692*/ end.
**
** /*H390*  if so_curr <> base_curr and pt_price <> 0 then do: */
** /*H390*/ if so_curr <> base_curr and available pt_mstr and
** /*H390*/    pt_price <> 0 then do:
** /*G244*/    {mfmsg02.i 684 1
**            "pt_price * sod_um_conv, "">>>>,>>>,>>9.99<<<"" "}
**                                     /* Base currency list price: 19.99 */
** /*G244*/    /* If no price list result, convert the standard list price */
** /*G244*/    if sod_price = 0 and sod_list_pr = 0 then assign
** /*H086*/    /* sod_price   = pt_price * so_ex_rate */
** /*H086*/       sod_price   = pt_price * so_ex_rate * sod_um_conv
** /*G244*/       sod_list_pr = sod_price.                .
** /*G244*/ end.
**
** /*H086*/ /* Moved price conversion to line um up before all price table */
** /*H086*/ /* and disc table calls. Because table routines now handle the */
** /*H086*/ /* um conversion themselves.                                   */
** /*H086*/ /* sod_price = sod_price * sod_um_conv.                        */
** /*H086*/ /* sod_list_pr = sod_list_pr * sod_um_conv.                    */
**
** /*H443** if available pt_mstr and pt_pm_code = "C" and so_pr_list2 <> "" **/
** /*H443** then sod_list_pr = tblprice.                                    **/
**
** /*G244*/ display sod_list_pr sod_disc_pct
** /*G0WL/*FT43*/ when (sod_disc_pct > -99999.99 and sod_disc_pct < 99999.99) */
** /*G0WL*/ when (sod_disc_pct >= -99999.99 and sod_disc_pct <= 99999.99)
** /*G244*/ sod_price with frame c.
**
**       end.
**J042*/

/*H086*/ /* Moved price conversion to line um up before all price table */
/*H086*/ /* and disc table calls. Because table routines now handle the */
/*H086*/ /* um conversion themselves.                                   */
/*H086*/ /* if sod_um_conv <> 1 then do:                                */
/*H086*/ /*    sod_std_cost = sod_std_cost * sod_um_conv.               */
/*H086*/ /*    if ln_fmt then display sod_std_cost with frame d.        */
/*H086*/ /* end.                                                        */

/*FT43* assign
*       old_price = sod_price
*       old_list_pr = sod_list_pr
*       old_disc = sod_disc_pct.  *FT43*/

/*H510** config_edited = no. **/

/*J0GT** MOVED ABOVE FIRST CALL TO gppibx.p
**    pm_code = "".
**    if available pt_mstr then pm_code = pt_pm_code.
**    find ptp_det where ptp_part = sod_part and ptp_site = sod_site
**    no-lock no-error.
**    if available ptp_det then pm_code = ptp_pm_code.
**J0GT*/

/*J0KJ*/ /* HERE'S WHERE WE PRICE A RMA RECEIPT LINE */

/*J0KJ*/ if this-is-rma and not rma-issue-line and (new_line or reprice_dtl)
/*J0KJ*/ then do:
/*J15C*/    sod_price = 0.
/*J0KJ*/    if so_crprlist <> "" and available pt_mstr then do:
/*J0KJ*/       assign
/*J0KJ*/          pt_recno = recid(pt_mstr)
/*J0XG** /*J0KJ*/ pcqty    = sod_qty_ord * sod_um_conv */
/*J0XG*/          pcqty    = sod_qty_ord
/*J0KJ*/       .
/*J0KJ*/       {gprun.i ""sopccal.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J0KJ*/    end.
/*J15C*BEGIN DELETE** PROCEDURE P-SYNC-RESTOCK REPLACES FOLLOWING **
 *J0KJ*     if restock-pct <> 0 then
 *J0LL*        assign
 *J0XG*           sod_list_pr  = sod_price
 *J0LL*           sod_disc_pct = restock-pct
 *J0KJ*           sod_price    = sod_list_pr -
 *J0KJ*                          (restock-pct * sod_list_pr * 0.01)
 *J0LL*        .
 *J15C**END DELETE**/
/*J15C*/    /* LIST PRICE FOR RECEIPT WILL ALWAYS BE CREDIT PRICE */
/*J15C*/    sod_list_pr = sod_price.
/*J15C*/    run p-sync-restock (input "default").
/*J0KJ*/ end.   /* if this-is-rma and... */

      /* CONFIGURATIONS */
      /* GK86 changes moved to subroutine */
      if pm_code = "C" then do:

/*J042**
** /*H0FS*/ /* DO MIN/MAX PRICE CHECKING BEFORE LOWER LEVEL COMPONENTS' PRICES
**             ARE ROLLED INTO PARENT PRICES */
** /*H0FS*/    if so_pr_list2 <> "" then do:
** /*H0FS*/       assign
** /*H0FS*/          warmess = yes
** /*H0FS*/          warning = yes.
** /*H0FS*/       {gprun.i ""gpmnmx.p""
**                        "(input        warning,
**                          input        warmess,
**                          input        minprice,
**                          input        maxprice,
**                          output       minmaxerr,
**                          input-output sod_list_pr,
**                             input-output sod_price,
**                        input sod_part
**                         )" }
**
** /*H0FS*/       display sod_list_pr sod_price with frame c.
** /*H0FS*/    end.
**J042*/

/*F0HM*/ assign
/*F0HM*/    old_price = sod_price
/*F0HM*/    old_list_pr = sod_list_pr
/*F0HM*/    old_disc = sod_disc_pct.

/*J04C*/    /* IF THIS IS AN RMA RECEIPT FOR A CONFIGURED ITEM,    */
            /* THE USER DOES NOT GET TO INPUT OPTIONS AND CREATE   */
            /* SOB_DET'S.                                          */
/*J04C*/    if this-is-rma and not rma-issue-line then .
/*J04C*/    else do:
/*H510*/        undo_all2 = true.
/*LB01*//*H510*/  {gprun.i ""zzsosomtf8.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J0YR*/        hide frame bom.
/*J042** /*H0FS*/    if undo_all_config then undo loopc, leave. */
/*H510*/        if undo_all2 then undo loopc, retry.
/*J04C*/    end.   /* if this-is-rma... */

      end.  /* if pm_code = "C" */

/*J042*/ /*CALCULATE BEST PRICE BASED ON GLOBAL DISCOUNTS*/

/*J0KJ** /*J042*/ if line_pricing or reprice_dtl then do: */
         /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
/*J0KJ*/ if rma-issue-line and (line_pricing or reprice_dtl) then do:

            sobparent  = "".
            sobfeature = "".
            sobpart    = "".

            best_list_price = sod_list_pr.

/*J0GT*/    /*IF CONFIGURED PRODUCT AND DISCOUNTS WERE FOUND WHERE
              pi_confg_disc = YES, THEN CALL gppibx.p FOR DISCOUNTS
              AND PROCESS THE DISCOUNTS WHERE pi_confg_disc = YES.
              WHEN PROCESSING THESE DISCOUNTS, THE USE OF LIST PRICE
              IS REQUIRED FOR ALL BUT DISCOUNT PERCENT TYPE DISCOUNTS.
              SINCE best_list_price NOW CONTAINS THE LIST PRICE OF
              THE ENTIRE CONFIGURATION THE DISCOUNTS THAT APPLY
              ACROSS THE ENTIRE CONFIGURATION CAN NOW BE TESTED.
            */

/*J0HR** /*J0GT*/    if exclude_confg_disc and found_confg_disc then do:    */
/*J0HR*/    if sod_list_pr <> 0 and exclude_confg_disc and found_confg_disc
/*J0HR*/    then do:
/*J0GT*/       assign
/*J0GT*/          exclude_confg_disc = no
/*J0GT*/          select_confg_disc  = yes
/*J0XR** /*J0GT*/ item_cost          = glxcst **Now performed in gppibx03.p*/
/*J0GT*/       .
/*J0XR*/       /*Added sod_site, so_ex_rate to parameters*/
/*J0GT*/       {gprun.i ""gppibx.p"" "(
                                       pics_type,
                                       picust,
                                       part_type,
                                       sod_part,
                                       sobparent,
                                       sobfeature,
                                       sobpart,
                                       2,
                                       so_curr,
                                       sod_um,
                                       sod_pricing_dt,
                                       no,
                                       sod_site,
                                       so_ex_rate,
                                       output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J0GT*/       /*READ THE CONFIGURATION AND SELECT COMPONENT LEVEL
                 DISCOUNTS.
               */
/*J0GT*/       {gprun.i ""sopicnfg.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J0GT*/    end.

/*J0HR*/    if sod_list_pr <> 0 then do:
/*LB01*/       {gprun.i ""zzgppibx04.p"" "(
                                      sobparent,
                                      sobfeature,
                                      sobpart,
                                      yes,
                                      rfact
                                     )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J0HR*/    end.

            /*TEST FOR BEST OVERALL PRICE EITHER BASED ON INDIVIDUAL
              DISCOUNTS ADDED UP OR GLOBAL DISCOUNTS INDEPENDENT OF
              COMPONENTS (IF ANY).  UPON DETERMINING THE WINNER, DELETE
              LOSERS FROM wkpi_wkfl*/

/*J0HR*/    /*NOT ONLY MUST THE BEST PRICE WIN, BUT THERE MUST BE FOUND
              SUPPORTING DISCOUNT RECORDS.*/

/*J0HR*     if best_net_price <= sod_price then do:     */
/*J0HR*/    if best_net_price <= sod_price
/*J0HR*/       and can-find(first wkpi_wkfl where
/*J0HR*/                   lookup(wkpi_amt_type, "2,3,4,9") <> 0
/*J0HR*/                      and wkpi_confg_disc = yes
/*J0HR*/                      and wkpi_source     = "0") then do:
               sod_price = best_net_price.
/*J0HR**
.               if sod_list_pr <> 0 then
.                  sod_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.
.              else
.                  sod_disc_pct = 0.
**J0HR*/

               for each wkpi_wkfl where lookup(wkpi_amt_type, "2,3,4,9")
/*J0HR*                                <> 0 and wkpi_source = "0"     */
/*J0HR*/                               <> 0
                                       and wkpi_confg_disc = no
                                  exclusive-lock:
                  delete wkpi_wkfl.
               end.
            end.
            else do:
/*J0HR**
.               if sod_list_pr <> 0 then
.                  sod_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.
.               else
.                  sod_disc_pct = 0.
**J0HR*/

/*J0HR*/       if can-find(first wkpi_wkfl
/*J0HR*/                   where lookup(wkpi_amt_type, "2,3,4,9") <> 0
/*J0HR*/                     and wkpi_confg_disc = no) then do:
                    for each wkpi_wkfl where lookup(wkpi_amt_type, "2,3,4,9")
                                  <> 0 and wkpi_source = "0"
                                       and wkpi_confg_disc = yes
                                  exclusive-lock:
                        delete wkpi_wkfl.
                    end.
               end.     /* if can-find(first wkpi_wkfl.... */
/*J0HR*/       else
/*J0HR*/          sod_price = best_net_price.
/*J0HR*/    end.    /* else do */

/*J0HR*/    if sod_list_pr <> 0 then
/*J0HR*/       sod_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.
/*J0HR*/    else
/*J0HR*/       sod_disc_pct = 0.

/*J0HR*/    /* JUST IN CASE SYSTEM DISCOUNTS CHANGED SINCE THE LAST PRICING  */
/*J0HR*/    /* AND THE USER MANUALLY ENTERED THE PRICE (OR DISCOUNT), RETAIN */
/*J0HR*/    /* THE PREVIOUS sod_price (THAT'S WHAT THE USER WANTS) AND REVISE*/
/*J0HR*/    /* THE MANUAL DISCOUNT ADJUSTMENT TO COMPENSATE.                 */

/*J0KJ*/    find first wkpi_wkfl where wkpi_parent   = sobparent  and
/*J0KJ*/                               wkpi_feature  = sobfeature and
/*J0KJ*/                               wkpi_option   = sobpart    and
/*J0KJ*/                               wkpi_amt_type = "2"        and
/*J0KJ*/                               wkpi_source   = "1"
/*J0KJ*/                         no-lock no-error.

/*J0N2** /*J0HR*/    if last_sod_price <> sod_price and */
/*J0LL** /*J0KJ*/       available wkpi_wkfl and wkpi_amt <> sod__qadd01 */
/*J0N2** /*J0LL*/ available wkpi_wkfl */
/*J0N2*/    if available wkpi_wkfl
/*J0KJ**
** /*J0HR*/       can-find(first pih_hist where pih_doc_type = 1
** /*J0HR*/                                 and pih_nbr      = sod_nbr
** /*J0HR*/                                 and pih_line     = sod_line
** /*J0HR*/                                 and pih_confg_disc
** /*J0HR*/                                 and pih_source   = "1"
** /*J0HR*/                                 and pih_amt_type = "2"
** /*J0HR*/                                 and pih_option   = "") then do:
**J0KJ*/
/*J0KJ*/    then do:
/*J1JV /*J0HR*/       save_disc_pct = sod_disc_pct.   */
/*J1JV*/       save_disc_pct = if sod_list_pr <> 0 then
/*J1JV*/                          (1 - (sod_price / sod_list_pr)) * 100
/*J1JV*/                       else
/*J1JV*/                           0.
/*J0HR*/       sod_price     = last_sod_price.
/*J0HR*/       if sod_list_pr <> 0 then
/*J1JV /*J0HR*/   sod_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.   */
/*J1JV*/          new_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.
/*J0HR*/       else
/*J1JV /*J0HR*/   sod_disc_pct = 0.   */
/*J1JV*/          new_disc_pct = 0.
/*J1JV*/       sod_disc_pct = new_disc_pct.

/*J0KJ**
** /*J0HR*/       find first wkpi_wkfl where wkpi_parent   = sobparent  and
** /*J0HR*/                                  wkpi_feature  = sobfeature and
** /*J0HR*/                                  wkpi_option   = sobpart    and
** /*J0HR*/                                  wkpi_amt_type = "2"        and
** /*J0HR*/                                  wkpi_source   = "1"
** /*J0HR*/                            no-lock no-error.
**J0KJ*/

/*J0HR*/       if pic_disc_comb = "1" then do:      /*cascading discount*/
/*J0HR*/          if available wkpi_wkfl then
/*J0N2**
** /*J0HR*/             sys_disc_fact = ((100 - save_disc_pct) / 100) /
** /*J0HR*/                             ((100 - wkpi_amt)      / 100).
**J0N2*/
/*J0N2*/             sys_disc_fact = if not found_100_disc then
/*J0N2*/                                ((100 - save_disc_pct) / 100) /
/*J0N2*/                                ((100 - wkpi_amt)      / 100)
/*J0N2*/                             else
/*J0N2*/                                0.
/*J0HR*/          else
/*J0HR*/             sys_disc_fact =  (100 - save_disc_pct) / 100.
/*J0HR*/          if sys_disc_fact = 1 then
/*J1JV /*J0HR*/      man_disc_pct  = sod_disc_pct.   */
/*J1JV*/             man_disc_pct  = new_disc_pct.
/*J0HR*/          else do:
/*J0N2*/             if sys_disc_fact <> 0 then do:
/*J1JV /*J0HR*/         discount      = (100 - sod_disc_pct) / 100.   */
/*J1JV*/                discount      = (100 - new_disc_pct) / 100.
/*J0HR*/                man_disc_pct  = (1 - (discount / sys_disc_fact)) * 100.
/*J0N2*/             end.
/*J1JV*/             else do:
/*J1JV*/                if available wkpi_wkfl then
/*J1JV*/                   man_disc_pct = new_disc_pct -
/*J1JV*/                                  (save_disc_pct - wkpi_amt).
/*J0N2*/                else
/*J1JV /*J0N2*/            man_disc_pct  = sod_disc_pct - 100.  */
/*J1JV*/                   man_disc_pct  = new_disc_pct - 100.
/*J1JV*/             end.
/*J0HR*/          end.
/*J0HR*/       end.
/*J0HR*/       else do:
/*J0HR*/          if available wkpi_wkfl then
/*J1JV /*J0HR*/      man_disc_pct = sod_disc_pct -  */
/*J1JV*/             man_disc_pct = new_disc_pct -
/*J0HR*/                            (save_disc_pct - wkpi_amt).
/*J0HR*/          else
/*J1JV /*J0HR*/      man_disc_pct = sod_disc_pct - save_disc_pct.   */
/*J1JV*/             man_disc_pct = new_disc_pct - save_disc_pct.
/*J0HR*/       end.

/*LB01*//*J0HR*/  {gprun.i ""zzgppiwkad.p"" "(sod_um,
                                         sobparent,
                                         sobfeature,
                                         sobpart,
                                         ""1"",
                                         ""2"",
                                         0,
                                         man_disc_pct,
                                         yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J0HR*/    end. /* last_sod_price <> sod_price */

/*J042*/ end. /*line_pricing or reprice_dtl*/

/*J04C*  ADDED THE FOLLOWING */
         /* RMA ISSUE LINES MAY ALSO HAVE A DISCOUNT FROM THE SERVICE    */
         /* TYPE. CALCULATE LINE DISCOUNT AS THE 'NORMAL SALES ORDER'    */
         /* DISCOUNT AMOUNT, AND ADD TO THAT THE DISCOUNT DUE TO THE     */
         /* SERVICE TYPE COVERAGE.                                       */
         if this-is-rma
/*J0MY*  and sod_list_pr <> 0 */
         then do:
/*J0LL**    if rma-issue-line and (line_pricing or reprice_dtl) then do: */
/*J0N2** /*J0LL*/ if rma-issue-line and (new_line or reprice_dtl) then do: */
            /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
/*J0N2*/    if rma-issue-line and (new_order or reprice_dtl) then do:
/*J0N2** /*J0LL*/ if new_line then do: */
                  /* FOR ISSUE LINES, CHECK FOR ADDITIONAL SERVICE TYPE */
                  /* DISCOUNT.                                          */
/*J15C*/          /* RMA_CTYPE WAS CHANGED TO RMD_SV_CODE AND MADE      */
/*J15C*/          /* INPUT-OUTPUT; SOD_QTY_SHIP WAS ADDED               */
                  {gprun.i ""fsrmadsc.p""
                        "(input        rma_contract,
                          input        if available pt_mstr
                                          then pt_fsc_code
                                          else """",
                          input        sod_due_date,
                          input        sod_qty_ship,
                          input        rma-recno,
                          input        rmd-recno,
                          input        new_line,
                          input-output rmd_sv_code,
                          input-output rmd_chg_type,
                          output       coverage-discount,
                          output       sod_contr_id)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J0N2*/          if sod_list_pr <> 0 then
/*J0LL*/             sod_covered_amt = sod_list_pr * (coverage-discount / 100).
/*J0N2*/          else do:
/*J0N2*/             sod_covered_amt = 0.
/*J0N2*/             sod__qadd01     = 0.
/*J0N2*/          end.
/*J0N2** /*J0LL*/ end. */

            /* NOTE:  sod__qadd01 IS USED TO CONTAIN THE ACTUAL DISCOUNT     */
            /*        PERCENT THAT IS THE EQUIVALENT OF THE COVERAGE AMOUNT  */
            /*        (UNLESS APPLYING THE COVERAGE AMOUNT REDUCES sod_price */
            /*        BELOW 0, THEN IT WILL REPRESENT sod_price PRIOR TO     */
            /*        APPLYING THE COVERAGE AMOUNT).                         */
            /*        SINCE MULTIPLE DISCOUNTS CAN BE APPLIED IN A CASCADING */
            /*        MANNER, THE COVERAGE DISCOUNT AND sod__qadd01 MAY NOT  */
            /*        BE THE SAME, ALTHOUGH THEY WILL REPRESENT THE SAME     */
            /*        AMOUNT. sod__qadd01 WILL ONLY CONTAIN A VALUE WHEN THE */
            /*        MANUAL DISCOUNT IS DUE TO THE COVERAGE DISCOUNT, ELSE  */
            /*        IT WILL CONTAIN 0.                                     */
            /*                                                               */
            /*        sod_covered_amt WILL ALWAYS MAINTAIN THE EQUIVALENT OF */
            /*        THE COVERAGE DISCOUNT.  THIS IS REQUIRED IN ORDER TO   */
            /*        ADJUST THE MINIMUM AND MAXIMUM THRESHOLD VALUES WHEN   */
            /*        TESTING THE NET PRICE AGAINST THESE THRESHOLDS.        */

/*J0N2** /*J0LL*/ if line_pricing or reprice_dtl then do: */
/*J0N2*/       if sod_list_pr <> 0 and (line_pricing or reprice_dtl) then do:
                  find first wkpi_wkfl where wkpi_parent   = sobparent  and
                                             wkpi_feature  = sobfeature and
                                             wkpi_option   = sobpart    and
                                             wkpi_amt_type = "2"        and
                                             wkpi_source   = "1"
                                        no-lock no-error.

/*J0LL*/          if not available wkpi_wkfl /* or (available wkpi_wkfl and
                                                 wkpi_amt = sod__qadd01) */
                  then do:
                     assign
/*J1JV                  save_disc_pct   = sod_disc_pct  */
/*J1JV*/                save_disc_pct   = if sod_list_pr <> 0 then
/*J1JV*/                                     (1 - (sod_price / sod_list_pr)) * 100
/*J1JV*/                                  else
/*J1JV*/                                      0.
/*J0LL**                sod_price       = sod_price + sod_covered_amt */
/*J0LL**                sod_covered_amt = sod_list_pr * (coverage-discount / 100)
                     .  */
                     if sod_price - sod_covered_amt > 0 then
                        sod_price       = sod_price - sod_covered_amt.
                     else do:
/*J0LL**                sod_covered_amt = sod_price. */
                        sod_price       = 0.
                     end.
/*J1JV               sod_disc_pct       = (1 - (sod_price / sod_list_pr)) * 100.  */
/*J1JV*/             new_disc_pct       = (1 - (sod_price / sod_list_pr)) * 100.
/*J1JV*/             sod_disc_pct       = new_disc_pct.

                     if pic_disc_comb = "1" then do:     /*cascading discount*/
/*J0LL**
**                        if available wkpi_wkfl then
**                           sys_disc_fact = ((100 - save_disc_pct) / 100) /
**                                             ((100 - wkpi_amt)      / 100).
**                      else
**J0LL*/
                                  sys_disc_fact =  (100 - save_disc_pct) / 100.
                        if sys_disc_fact = 1 then
/*J1JV                     man_disc_pct  = sod_disc_pct.   */
/*J1JV*/                   man_disc_pct  = new_disc_pct.
                        else do:
/*J0N2*/                   if sys_disc_fact <> 0 then do:
/*J1JV                        discount      = (100 - sod_disc_pct) / 100.  */
/*J1JV*/                      discount      = (100 - new_disc_pct) / 100.
                              man_disc_pct  = (1 - (discount / sys_disc_fact))
                                               * 100.
/*J0N2*/                   end.
/*J0N2*/                   else
/*J1JV /*J0N2*/               man_disc_pct  = sod_disc_pct - 100.   */
/*J1JV*/                      man_disc_pct  = new_disc_pct - 100.
                        end.
                     end.
                     else do:                            /*additive discount*/
/*J0LL**
**                        if available wkpi_wkfl then
**                              man_disc_pct = sod_disc_pct -
**                                          (save_disc_pct - wkpi_amt).
**                      else
**J0LL*/
/*J1JV                        man_disc_pct = sod_disc_pct - save_disc_pct.   */
/*J1JV*/                      man_disc_pct = new_disc_pct - save_disc_pct.
                     end.

/*LB01*/         {gprun.i ""zzgppiwkad.p"" "(
                                               sod_um,
                                               sobparent,
                                               sobfeature,
                                               sobpart,
                                               ""1"",
                                               ""2"",
                                               0,
                                               man_disc_pct,
                                               yes
                                              )"}
/*GUI*/ if global-beam-me-up then undo, leave.


                     sod__qadd01 = man_disc_pct.
                  end.
                  else do:
/*J0LL**             sod_covered_amt = sod_list_pr * (coverage-discount / 100). */
                     sod__qadd01     = 0.
                  end.
/*J0LL*/       end. /* line_pricing or reprice_dtl */
            end.    /* if rma-issue-line ... */
            else do:
               /* ELSE, IF THIS IS A RECEIPT LINE, THE USER MAY SEE */
               /* SOME 'DISCOUNT' AS A RESULT OF THE RESTOCK CHARGE */
               /* IN THIS CASE, GIVE HIM A MESSAGE TO CLARIFY.      */
               if not rma-issue-line and restock-pct <> 0 then do:
                  {mfmsg.i 1186 1}
                  /* RESTOCKING CHARGE APPLIES TO THIS LINE ITEM */
               end.
            end.    /* else, rma-receipt-line, do */
         end.   /* if this-is-rma */

/*J04C*  END ADDED CODE */

/*FT43*/ assign
/*FT43*/       old_price = sod_price
/*FT43*/       old_list_pr = sod_list_pr
/*FT43*/       old_disc = sod_disc_pct.

/*J0HR**
./*H443*/ if sod_list_pr = 0 then do:
./*H443*/    sod_list_pr = sod_price.
./*H443*/    display sod_list_pr with frame c.
./*H443*/ end.
**J0HR*/

         /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
/*J0KJ*/ if rma-issue-line then
/*J15C*/ do:
/*J0HR*/    if sod_list_pr <> 0 then
/*J0HR*/       sod_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.
/*J0HR*/    else
/*J0HR*/       sod_disc_pct = 0.

/*J042*/ /*DETERMINE DISCOUNT DISPLAY FORMAT*/

/*J0N2*/ /* TEST FOR DISCOUNT RANGE VIOLATION.  IF FOUND, CREATE/MAINTAIN */
/*J0N2*/ /* MANUAL DISCOUNT TO RECONCILE THE DIFFERENCE BETWEEN THE SYSTEM*/
/*J0N2*/ /* DISCOUNT AND THE MIN OR MAX ALLOWABLE DISCOUNT, DEPENDING ON  */
/*J0N2*/ /* THE VIOLATION.                                                */

/*J15C*J0N2*  disc_min_max = no.                                  */
/*J15C*J042*  {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}  */
/*J0N2** /*J042*/ display sod_list_pr discount when (discount >= -9999.9999 and
** /*J042*/                                    discount <=  9999.9999)
** /*J042*/         sod_price with frame c.
**J0N2*/

/*J15C*/    run p-disc-disp (input yes).
/*J0N2*/    if disc_min_max then do:     /* found a discount range violation */
/*J15C**BEGIN DELETE**
 *J0N2*     {mfmsg03.i 6931 2 disc_pct_err """" """"}
 *J0N2*     if not batchrun then
 *J0N2*        pause.
 *J0N2*     if rma-issue-line then do:
 *J15C**END DELETE**/
/*J0N2*/       save_disc_pct = disc_pct_err.
/*J1JV /*J0N2*/sod_disc_pct  = if pic_so_fact then   */
/*J1JV*/       new_disc_pct  = if pic_so_fact then
/*J0N2*/                          (1 - discount) * 100
/*J0N2*/                       else
/*J0N2*/                          discount.
/*J1JV*/       sod_disc_pct  = new_disc_pct.
/*J0N2*/       find first wkpi_wkfl where wkpi_parent   = sobparent  and
/*J0N2*/                                  wkpi_feature  = sobfeature and
/*J0N2*/                                  wkpi_option   = sobpart    and
/*J0N2*/                                  wkpi_amt_type = "2"        and
/*J0N2*/                                  wkpi_source   = "1"
/*J0N2*/                            no-lock no-error.

/*J0N2*/       if pic_disc_comb = "1" then do:     /*cascading discount*/
/*J0N2*/          if available wkpi_wkfl then
/*J0N2*/             sys_disc_fact = ((100 - save_disc_pct) / 100) /
/*J0N2*/                               ((100 - wkpi_amt)      / 100).
/*J0N2*/          else
/*J0N2*/             sys_disc_fact =  (100 - save_disc_pct) / 100.
/*J0N2*/          if sys_disc_fact = 1 then
/*J1JV /*J0N2*/      man_disc_pct  = sod_disc_pct.   */
/*J1JV*/             man_disc_pct  = new_disc_pct.
/*J0N2*/          else do:
/*J0N2*/             if sys_disc_fact <> 0 then do:
/*J1JV /*J0N2*/         discount      = (100 - sod_disc_pct) / 100.   */
/*J1JV*/                discount      = (100 - new_disc_pct) / 100.
/*J0N2*/                man_disc_pct  = (1 - (discount / sys_disc_fact))
/*J0N2*/                                * 100.
/*J0N2*/             end.
/*J0N2*/             else
/*J1JV /*J0N2*/         man_disc_pct  = sod_disc_pct - 100.   */
/*J1JV*/                man_disc_pct  = new_disc_pct - 100.
/*J0N2*/          end.
/*J0N2*/       end.
/*J0N2*/       else do:                            /*additive discount*/
/*J0N2*/          if available wkpi_wkfl then
/*J1JV /*J0N2*/        man_disc_pct = sod_disc_pct -   */
/*J1JV*/               man_disc_pct = new_disc_pct -
/*J0N2*/                            (save_disc_pct - wkpi_amt).
/*J0N2*/          else
/*J1JV /*J0N2*/      man_disc_pct = sod_disc_pct - save_disc_pct.   */
/*J1JV*/             man_disc_pct = new_disc_pct - save_disc_pct.
/*J0N2*/       end.

/*LB01*/ /*J0N2*/ {gprun.i ""zzgppiwkad.p"" "(
                                         sod_um,
                                         sobparent,
                                         sobfeature,
                                         sobpart,
                                         ""1"",
                                         ""2"",
                                         0,
                                         man_disc_pct,
                                         yes
                                        )"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J1JV*/        sod_price = sod_list_pr * (1 - (new_disc_pct / 100)).

/*J15C*J0N2* end.  /* if rma-issue-line */  */

/*J1JV /*J0N2*/ sod_price = sod_list_pr * (1 - (sod_disc_pct / 100)).   */

/*J0N2*/    end.  /* if disc_min_max */

/*J15C*/ end.  /* if rma-issue-line */
/*J1JV*/ else do:
/*J1JV*/    if disc_min_max then do:
/*J1JV*/       sod_disc_pct = if pic_so_fact then
/*J1JV*/                         (1 - discount) * 100
/*J1JV*/                      else
/*J1JV*/                          discount.
/*J1JV*/       sod_price = sod_list_pr * (1 - (sod_disc_pct / 100)).
/*J1JV*/    end.
/*J1JV*/ end.

/*J15C*J0N2* {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}  */
/*J15C*/ run p-disc-disp (input no).
/*J0N2*/ display sod_list_pr discount sod_price with frame c.

/*J042** THE FOLLOWING CODE REPLACED BY "BEST" PRICING ROUTINE********
** /*H086*/ /* PRICE TABLE MIN/MAX WARNING FOR DISC TABLES. PLUG PRICES */
** /*H0FS*/ /* CONFIGURED PRODUCT PRICES CHECKED ABOVE BEFORE LOWER LEVEL
**             COMPONENTS ROLLED INTO PRICES */
** /*H0FS /*H086*/ if so_pr_list2 <> "" then do: */
** /*H0FS*/ if pm_code <> "C" and
** /*H0FS*/ so_pr_list2 <> "" then do:
** /*H086*/    assign
** /*H086*/       warmess = yes
** /*H086*/       warning = yes.
** /*H0FS*/    /* ADDED sod_part & REMOVED sod_um_conv PARAMETERS BELOW */
** /*H086*/    {gprun.i ""gpmnmx.p""
**                     "(input        warning,
**                       input        warmess,
**                       input        minprice,
**                       input        maxprice,
**                       output       minmaxerr,
**                       input-output sod_list_pr,
**                       input-output sod_price,
**                     input sod_part
**                      )" }
** /*H086*/    display sod_list_pr sod_price with frame c.
** /*H086*/ end.
**J042*/

/*J042** /*FT43*/ disc_origin = sod_disc_pct.
** /*FT43*/ if sod_disc_pct > 99999.99 or sod_disc_pct < -99999.99 then do:
** /*G0WL*/    /* DISCOUNT IS OUT OF RANGE AND WILL BE SET TO ALL 9'S  */
** /*FT43*/    {mfmsg.i 667 2}
** /*G0WL  /*FT43*/ sod_disc_pct = 0.   */
** /*G0WL*/    sod_disc_pct = 99999.99.
** /*FT43*/ end.
**J042*/
/*J0N2**
** /*J042*/ if discount >= 9999.9999 or discount <= -9999.9999 then do:
** /*FT43*/    {mfmsg.i 667 2}
** /*FT43*/    sod_disc_pct = 0.
** /*J042*/    discount     = if pic_so_fact then 1 else 0.
** /*FT43*/ end.
**J0N2*/

/*J1JV /*J042*/ save_disc_pct   = sod_disc_pct.    */
/*J1JV*/ save_disc_pct   = if sod_list_pr <> 0 then
/*J1JV*/                      (1 - (sod_price / sod_list_pr)) * 100
/*J1JV*/                   else
/*J1JV*/                       0.
/*J0N2*/ last_list_price = sod_list_pr.

/*J042** update sod_list_pr sod_disc_pct with frame c.
** /*G0WL  /*FT43*/ if sod_disc_pct <> 0 then disc_origin = sod_disc_pct. */
** /*G0WL*/ if (disc_origin >= -99999.99 and disc_origin <= 99999.99)
** /*G0WL*/    or sod_disc_pct <> 0
** /*G0WL*/ then disc_origin = sod_disc_pct.
**J042*/

         /* FOR RMA RECEIPT LINES, DISCOUNT PERCENT PROBABLY WON'T APPLY    */
         /* BUT, LET USER ENTER ONE - EXCEPT IN THOSE CASES WHERE A         */
         /* RESTOCKING CHARGE APPLIES.  RESTOCKING CHARGES AND DISCOUNTS    */
         /* CANNOT BE USED IN CONJUNCTION.                                  */
/*J15C*/ /* IF THE USER CHANGES THE HEADER SVC TYPE, WE NEED TO ALLOW       */
/*J15C*/ /* HIM TO UPDATE THE DISCOUNT BECAUSE WE NO LONGER KNOW IF THE     */
/*J15C*/ /* OLD SVC TYPE HAD A RESTOCKING CHARGE.  IF THE USER DOESN'T      */
/*J15C*/ /* CHANGE ANYTHING, THE OLD RESTOCKING CHARGE OR DISCOUNT APPLIES. */
/*J15C*/ /* IF SOMETHING CHANGES, THE NEW DISCOUNT WILL APPLY, UNLESS THE   */
/*J15C*/ /* THE NEW SVC TYPE HAS A RESTOCKING CHARGE, IN WHICH CASE THAT    */
/*J15C*/ /* PERCENT WILL OVERRIDE THE ENTERED DISCOUNT.                     */

/*J0N2*/ do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


/*J0N2*/    if new_order or reprice_dtl then
/*J042*/       update sod_list_pr
/*J042*/          /*    discount   lb03 2004-07-21 */
/*J15C*J04C*             when (not (not rma-issue-line and restock-pct <> 0) )*/
                         /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
/*J15C*/                 when (rma-issue-line or restock-pct = 0 or
/*J15C*/                       rmd_sv_code <> rma_ctype)
/*J042*/       with frame c.

/*J042** /*FT43*/ if sod_disc_pct <> 0 then disc_origin = sod_disc_pct.*/

/*J042*/    /*CHECK MIN/MAX FOR LIST PRICE VIOLATIONS
              CREATE wkpi_wkfl IF MIN OR MAX ERROR OCCURS*/

            /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
/*J0KJ*/    if rma-issue-line then do:

/*J1N4*/    /* THE FIFTH PARAMETER ( UM CONVERSION ) IS CHANGED FROM   */
/*J1N4*/    /* sod_um_conv to "1"                                      */
               {gprun.i ""gpmnmx01.p"" "(
                                         yes,
                                         yes,
                                         min_price,
                                         max_price,
/*J1N4*/                                 1,
/*J0Y5*/                                 no,
/*J0Y5*/                                 sod_nbr,
/*J0Y5*/                                 sod_line,
/*J12Q*/                                 yes,
                                         output minmaxerr,
                                         output minerr,
                                         output maxerr,
                                         input-output sod_list_pr,
                                         input-output sod_price
                                        )"}
/*GUI*/ if global-beam-me-up then undo, leave.


               if minerr then do:      /*list price below min. allowed*/
/*LB01*/         {gprun.i ""zzgppiwkad.p"" "(
                                            sod_um,
                                            sobparent,
                                            sobfeature,
                                            sobpart,
                                            ""2"",
                                            ""1"",
                                            sod_list_pr,
                                            0,
                                            yes
                                           )"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.
               if maxerr then do:     /*list price above max. allowed*/
/*LB01*/           {gprun.i ""zzgppiwkad.p"" "(
                                            sod_um,
                                            sobparent,
                                            sobfeature,
                                            sobpart,
                                            ""3"",
                                            ""1"",
                                            sod_list_pr,
                                            0,
                                            yes
                                           )"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.
               if minerr or maxerr then do:

                  sod_disc_pct      = 0.
/*J0KJ*/          sod__qadd01       = 0.
/*J063*/          discount          = if pic_so_fact then 1 else 0.
                  parent_list_price = sod_list_pr.  /*gppiwk02.p needs this*/
                  display sod_list_pr discount sod_price with frame c.

/*J07R*/          /*IF ANY EXISTING DISCOUNTS, CREATE/MAINTAIN "MANUAL" DISCOUNT
                    TO NEGATE DISCOUNT AND MAINTAIN PRICING HISTORY*/

/*J07R*/          find first wkpi_wkfl where wkpi_parent   = sobparent  and
/*J07R*/                                     wkpi_feature  = sobfeature and
/*J07R*/                                     wkpi_option   = sobpart    and
/*J07R*/                                     wkpi_amt_type = "2"        and
/*J07R*/                                     wkpi_source   = "1"
/*J07R*/                               no-lock no-error.
/*J07R*/
/*J07R*/          if pic_disc_comb = "1" then do:       /*cascading*/
/*J07R*/             if available wkpi_wkfl then
/*J0N2**
** /*J07R*/                sys_disc_fact = ((100 - save_disc_pct) / 100) /
** /*J07R*/                                ((100 - wkpi_amt     ) / 100).
**J0N2*/
/*J0N2*/                sys_disc_fact = if not found_100_disc then
/*J0N2*/                                   ((100 - save_disc_pct) / 100) /
/*J0N2*/                                   ((100 - wkpi_amt)      / 100)
/*J0N2*/                                else
/*J0N2*/                                   0.
/*J07R*/             else
/*J07R*/                sys_disc_fact =  (100 - save_disc_pct) / 100.
/*J07R*/             if sys_disc_fact <> 1 or available wkpi_wkfl then do:
/*J0N2*/                if sys_disc_fact <> 0 then
/*J07R*/                   man_disc_pct  = (1 - (1 / sys_disc_fact)) * 100.
/*J0N2*/                else
/*J0N2*/                   man_disc_pct  = -100.

/*LB01*/              {gprun.i ""zzgppiwkad.p"" "(
                                                  sod_um,
                                                  sobparent,
                                                  sobfeature,
                                                  sobpart,
                                                  ""1"",
                                                  ""2"",
                                                  0,
                                                  man_disc_pct,
                                                  yes
                                                 )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J07R*/             end.
/*J07R*/          end.
/*J07R*/          else do:                              /*additive*/
/*J07R*/             if available wkpi_wkfl then
/*J07R*/                man_disc_pct = - (save_disc_pct - wkpi_amt).
/*J07R*/             else
/*J07R*/                man_disc_pct = - save_disc_pct.
/*J07R*/             if save_disc_pct <> 0 or available wkpi_wkfl then do:

/*LB01*/                 {gprun.i ""zzgppiwkad.p"" "(
                                                  sod_um,
                                                  sobparent,
                                                  sobfeature,
                                                  sobpart,
                                                  ""1"",
                                                  ""2"",
                                                  0,
                                                  man_disc_pct,
                                                  yes
                                                 )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J07R*/             end.
/*J07R*/          end.
               end.
               else do:

/*J042*/          /*TEST TO SEE IF LIST PRICE AND/OR DISCOUNT ARE MANUALLY
                    ENTERED.  IF SO UPDATE PRICING WORKFILE TO REFLECT THE
                    CHANGE.*/

                  if sod_list_pr entered or discount entered then do:
                     if sod_list_pr entered then do:
/*LB01*/              {gprun.i ""zzgppiwkad.p"" "(
                                                  sod_um,
                                                  sobparent,
                                                  sobfeature,
                                                  sobpart,
                                                  ""1"",
                                                  ""1"",
                                                  sod_list_pr,
                                                  0,
                                                  yes
                                                 )"}
/*GUI*/ if global-beam-me-up then undo, leave.

                        parent_list_price = sod_list_pr. /*for gppiwk02.p*/

/*J0N2*/                /*Tag as a repricing candidate since net price could
                          be affected by change in list price.  Also, update
                          extended list amount accumulation used by best
                          pricing.*/

/*J0N2*/                if line_pricing or not new_order then do:

/*J0N2*/                   find first wrep_wkfl where wrep_parent
/*J0N2*/                                          and wrep_line = sod_line
/*J0N2*/                                        exclusive-lock.
/*J0N2*/                   if available wrep_wkfl then
/*J0N2*/                      wrep_rep = yes.

/*J0N2*//*LB01*/           {gprun.i ""zzgppiqty2.p"" "(
                                                     sod_line,
                                                     sod_part,
                                                     0,
                                                     sod_qty_ord *
                                                    (sod_list_pr -
                                                     last_list_price),
                                                     sod_um,
                                                     yes,
/*J0Z6*/                                             yes,
                                                     yes
                                                    )"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J0N2*/                end.

/*J0XG** /*J0N2*/       if this-is-rma then */
                        /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
/*J0XG*/                if rma-issue-line then
/*J0N2*/                   sod_covered_amt = sod_list_pr *
/*J0N2*/                                     (coverage-discount / 100).
                     end.
                     if discount entered then do:
/*J0KJ*/                sod__qadd01     = 0.
                        if pic_so_fact then
/*J1JV                     sod_disc_pct = (1 - discount) * 100.   */
/*J1JV*/                   new_disc_pct = (1 - discount) * 100.
                        else
/*J1JV                     sod_disc_pct = discount.    */
/*J1JV*/                   new_disc_pct = discount.
/*J1JV*/                sod_disc_pct = new_disc_pct.

/*J15C**BEGIN DELETE**
 *J0N2*                 disc_min_max = no.
 *J0N2*                 {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}
 *J0N2*                 if disc_min_max then do:
 *J0N2*                    {mfmsg03.i 6932 3 disc_pct_err """" """"}
 *J0N2*                    /* DISCOUNT # VIOLATES THE MIN OR MAX ALLOWABLE */
 *J0N2*                    if not batchrun then
 *J0N2*                       pause.
 *J15C**END DELETE**/
/*J15C*/                run p-disc-disp (input yes).
/*J15C*/                if disc_min_max then
/*J0N2*/                   undo, retry.
/*J15C*J0N2*            end.  */

                        find first wkpi_wkfl where wkpi_parent = sobparent and
                                                wkpi_feature  = sobfeature and
                                                wkpi_option   = sobpart    and
                                                wkpi_amt_type = "2"        and
                                                wkpi_source   = "1"
                                             no-lock no-error.

                        if pic_disc_comb = "1" then do:  /*cascading discount*/
                           if available wkpi_wkfl then
/*J0N2**
**                                 sys_disc_fact = ((100 - save_disc_pct) / 100) /
**                                                ((100 - wkpi_amt)      / 100).
**J0N2*/
/*J0N2*/                      sys_disc_fact = if not found_100_disc then
/*J0N2*/                                         ((100 - save_disc_pct) / 100) /
/*J0N2*/                                         ((100 - wkpi_amt)      / 100)
/*J0N2*/                                      else
/*J0N2*/                                         0.
                           else
                                sys_disc_fact =  (100 - save_disc_pct) / 100.
                           if sys_disc_fact = 1 then
/*J1JV                        man_disc_pct  = sod_disc_pct.   */
/*J1JV*/                      man_disc_pct  = new_disc_pct.
                           else do:
/*J0N2*/                      if sys_disc_fact <> 0 then do:
/*J1JV                           discount     = (100 - sod_disc_pct) / 100.  */
/*J1JV*/                         discount     = (100 - new_disc_pct) / 100.
                                 man_disc_pct = (1 - (discount / sys_disc_fact))
                                                * 100.
/*J0N2*/                      end.
/*J1JV*/                      else do:
/*J1JV*/                         if available wkpi_wkfl then
/*J1JV*/                            man_disc_pct = new_disc_pct -
/*J1JV*/                                           (save_disc_pct - wkpi_amt).
/*J0N2*/                         else
/*J1JV /*J0N2*/                     man_disc_pct  = sod_disc_pct - 100.  */
/*J1JV*/                            man_disc_pct  = new_disc_pct - 100.
/*J1JV*/                      end.
                           end.
                        end.
                        else do:                         /*additive discount*/
                           if available wkpi_wkfl then
/*J1JV                         man_disc_pct = sod_disc_pct -   */
/*J1JV*/                       man_disc_pct = new_disc_pct -
                                             (save_disc_pct - wkpi_amt).
                           else
/*J1JV                         man_disc_pct = sod_disc_pct - save_disc_pct.   */
/*J1JV*/                       man_disc_pct = new_disc_pct - save_disc_pct.
                        end.

/*LB01*/              {gprun.i ""zzgppiwkad.p"" "(
                                                  sod_um,
                                                  sobparent,
                                                  sobfeature,
                                                  sobpart,
                                                  ""1"",
                                                  ""2"",
                                                  0,
                                                  man_disc_pct,
                                                  yes
                                                 )"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     end.
/*J1JV               sod_price = sod_list_pr * (1 - (sod_disc_pct / 100)).   */
/*J1JV*/             sod_price = sod_list_pr * (1 - (new_disc_pct / 100)).
                     display sod_price with frame c.
                  end. /*sod_list_pr entered or discount entered*/
/*J042*/       end. /*not minerr and not maxerr*/
/*J0KJ*/    end. /*rma-issue-line*/

/*J15C*J0N2* end. /* do on error undo, retry (for update of sod_list_pr) */  */

/*J12Q* /*J0KJ*/ if this-is-rma and not rma-issue-line          */
/*J12Q* /*J0KJ*/ and restock-pct <> 0 then                      */
/*J12Q*/    if this-is-rma and not rma-issue-line
/*J15C*/       and (sod_list_pr entered or discount entered)
/*J12Q*/    then
/*J15C*/    do:
/*J15C*BEGIN DELETE** PROCEDURE P-SYNC-RESTOCK REPLACES FOLLOWING **
 *J12Q*        if restock-pct <> 0 then
 *J0KJ*           assign sod_price  = sod_list_pr -
 *J0KJ*                               (restock-pct * sod_list_pr * 0.01).
 *J12Q*        else do:
 *J12Q*           sod_disc_pct = if pic_so_fact then
 *J12Q*                             (1 - discount) * 100
 *J12Q*                          else
 *J12Q*                             discount.
 *J12Q*           sod_price    = sod_list_pr -
 *J12Q*                          (sod_disc_pct * sod_list_pr * 0.01).
 *J12Q*        end.  /* else no restock charge */
 *J15C**END DELETE**/
/*J15C*/       run p-sync-restock (input "discount").
/*J15C*/       if disc_min_max  and
/*J15C*/          restock-pct = 0
/*J15C*/       then
/*J15C*/          undo, retry.
/*J15C*/       display discount with frame c.
/*J15C*/    end.  /* if RMA receipt & list or disc changed */

/*J15C*/ end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* do on error undo, retry (for update of sod_list_pr) */

/*J042** THE FOLLOWING CODE REPLACED BY "BEST" PRICING ROUTINE**********
** /*H086*/ /* PRICE TABLE MIN/MAX WARNING FOR USER INPUT. PLUG PRICES */
** /*H0FS*/ /* CONFIGURED PRODUCT PRICES CHECKED ABOVE BEFORE LOWER LEVEL
**             COMPONENTS ROLLED INTO PRICES */
** /*H0FS /*H086*/ if so_pr_list2 <> "" then do: */
** /*H0FS*/ if pm_code <> "C" and
** /*H0FS*/ so_pr_list2 <> "" then do:
** /*H086*/    assign
** /*H086*/       warmess = yes
** /*H086*/       warning = yes.
** /*H0FS*/    /* ADDED sod_part & REMOVED sod_um_conv PARAMETERS BELOW */
** /*H086*/    {gprun.i ""gpmnmx.p""
**                     "(input        warning,
**                       input        warmess,
**                       input        minprice,
**                       input        maxprice,
**                       output       minmaxerr,
**                       input-output sod_list_pr,
**                       input-output sod_price,
**                     input sod_part
**                      )" }
** /*H086*/    display sod_list_pr sod_price with frame c.
** /*H086*/ end.
**
**
**      /* Recalculate default net price */
**      if (not (old_disc = 0 and old_list_pr <> old_price))
** /*G0WL*/    and sod_list_pr <> old_list_pr
** /*G0WL*/    or sod_list_pr entered
** /*G0WL*/    or sod_disc_pct entered
** /*G0WL*/    or disc_origin <> old_disc
** /*FT43*   and (sod_list_pr <> old_list_pr or sod_disc_pct <> old_disc) then
**       sod_price = sod_list_pr * (1 - (sod_disc_pct / 100)).   *FT43*/
** /*G0WL/*FT43*/ and (sod_list_pr <> old_list_pr or disc_origin <> old_disc) */
** /*FT43*/ then sod_price = sod_list_pr * (1 - (disc_origin / 100)).
**J042*/

/*H476*/ display sod_price with frame c.

         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

/*H476**    update sod_price with frame c. **/
/*J1JV /*J042*/    save_disc_pct = sod_disc_pct.   */
/*J1JV*/    save_disc_pct   = if sod_list_pr <> 0 then
/*J1JV*/                         (1 - (sod_price / sod_list_pr)) * 100
/*J1JV*/                      else
/*J1JV*/                          0.
/*J04C*/    old_price = sod_price.
            /* IF THE USER IS MAINTAINING AN RMA RECEIPT LINE, AND HAS */
            /* A 100% RESTOCKING CHARGE, THEN THE NET PRICE WILL       */
            /* ALWAYS BE ZERO, AND THE USER CANNOT OVERRIDE IT.  SO,   */
            /* LET HIM UPDATE PRICE UNDER ALL OTHER CIRCUMSTANCES.     */
            /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
/*J0N2*/    if (new_order or reprice_dtl) and (rma-issue-line
/*J0N2** /*J04C*/ if rma-issue-line */
/*J04C*/    or (not rma-issue-line and restock-pct <> 100)) then
/*H476*/       set sod_price with frame c.

            /* Disallow price change if uninvoiced shipment exists */
            if sod_price <> last_sod_price and sod_qty_inv <> 0 then do:
               {mfmsg.i 546 3} /*"Invoice qty pending, use inv maint"*/
               undo, retry.
            end.

/*H086*/    /* PRICE TABLE MIN/MAX ERROR */
/*J042**    REPLACE CALL TO gpmnmx.p WITH gpmnmx01.p******************
** /*H0FS*/ /* CONFIGURED PRODUCT PRICES CHECKED ABOVE BEFORE LOWER LEVEL
**             COMPONENTS ROLLED INTO PRICES */
** /*H0FS /*H086*/ if so_pr_list2 <> "" then do: */
** /*H0FS*/ if pm_code <> "C" and
** /*H0FS*/ so_pr_list2 <> "" then do:
** /*H086*/    assign
** /*H086*/       warmess = yes
** /*H086*/       warning = no.
** /*H0FS*/    /* ADDED sod_part & REMOVED sod_um_conv PARAMETERS BELOW */
** /*H086*/    {gprun.i ""gpmnmx.p""
**                      "(input        warning,
**                        input        warmess,
**                        input        minprice,
**                        input        maxprice,
**                        output       minmaxerr,
**                        input-output sod_list_pr,
**                        input-output sod_price,
**                     input sod_part
**                      )" }
**J042*/

/*J0KJ*/    /*IF RMA ISSUE LINE AND DISCOUNT COVERAGE EXISTS, EXCLUDE
              COVERAGE AMOUNT FROM THE NET PRICE BY ADJUSTING THE MIN
              AND MAX AMOUNTS RELATIVE TO THE COVERAGE AMOUNT*/

            /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
/*J0KJ*/    if rma-issue-line then do:

/*J0LL** /*J0KJ*/       if this-is-rma and not minmax_occurred then do: */
/*J0LL*/       if this-is-rma then do:

/*J0KJ*/          if min_price <> 0 then
/*J0KJ*/             min_price = min_price - sod_covered_amt.
/*J0KJ*/          if max_price <> 0 then
/*J0KJ*/             max_price = max_price - sod_covered_amt.
/*J0KJ*/       end.

/*J1N4*/    /* THE FIFTH PARAMETER ( UM CONVERSION ) IS CHANGED FROM   */
/*J1N4*/    /* sod_um_conv to "1"                                      */
/*J042*/       {gprun.i ""gpmnmx01.p"" "(
                                         no,
                                         yes,
                                         min_price,
                                         max_price,
/*J1N4*/                                 1,
/*J0Y5*/                                 no,
/*J0Y5*/                                 sod_nbr,
/*J0Y5*/                                 sod_line,
/*J12Q*/                                 yes,
                                         output minmaxerr,
                                         output minerr,
                                         output maxerr,
                                         input-output sod_list_pr,
                                         input-output sod_price
                                        )"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*H086*/       if minmaxerr then do:
/*J042*******************************************************
** /*H476*/       if sod_price > maxprice then
** /*H476*/          display maxprice @ sod_price with frame c.
** /*H476*/       else
** /*H476*/          display minprice @ sod_price with frame c.
**J042******************************************************/
/*J042*/          minmax_occurred = yes.
/*J042*/          if sod_price > max_price and max_price <> 0 then
/*J042*/             display max_price @ sod_price with frame c.
/*J042*/          else
/*J042*/             display min_price @ sod_price with frame c.
/*H086*/          undo, retry.
/*H086*/       end.
/*J042** /*H086*/ end. **/

/*J0KJ*/    end.

/*J0N2** end. /* do on error undo, retry */ */

/*J0HR**
.      if sod_list_pr = 0 then do:
./*F0MV*/ sod_disc_pct = 0.
.         sod_list_pr = sod_price.
.         display sod_list_pr with frame c.
.      end.
**J0HR*/
/*J1YL*/ if sod_list_pr = 0 and sod_price <> 0 then do:
/*J1YL*/   sod_list_pr = sod_price.
/*J1YL*/   display sod_list_pr with frame c.
/*J1YL*/ end.
/*J1YL*/ {gprun.i ""zzgppiwkad.p"" "(
                                  sod_um,
                                  sobparent,
                                  sobfeature,
                                  sobpart,
                                  ""1"",
                                  ""1"",
                                  sod_list_pr,
                                  sod_disc_pct,
                                  no
                                 )"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J04C*     ADDED THE FOLLOWING */
            /* FOR RMA RECEIPT LINES THE DISCOUNT PERCENT MUST BE */
            /* HELD CONSTANT.  SO, IF THE USER CHANGED LIST PRICE,*/
            /* NET PRICE WAS RECALCULATED BEFORE HE HAD THE CHANCE*/
            /* TO UPDATE IT.  IF THE USER HAS NOW CHANGED THE NET */
            /* PRICE, RECALCULATE THE LIST PRICE ACCORDING TO THE */
            /* FIXED DISCOUNT PERCENT (WHICH, FOR RMA RECEIPT     */
            /* LINES, IS A RESTOCKING CHARGE )                    */
            if this-is-rma and not rma-issue-line
/*J15C*/       and old_price <> sod_price
/*J15C*        and restock-pct <> 0  */
            then do:
/*J15C*        assign sod_list_pr = sod_price / (1 - .01 * restock-pct).  */
/*J15C*/       run p-sync-restock (input "price").
/*J15C*/       if disc_min_max  and
/*J15C*/          restock-pct = 0
/*J15C*/       then
/*J15C*/          undo, retry.
               display
                  sod_list_pr
/*J15C*/          discount
               with frame c.
            end.  /* if RMA receipt & net price changed */

/*J15C*     else  */
/*J04C*     END ADDED CODE */
/*H0FS      if sod_price entered and sod_list_pr <> 0 then do: */
/*J042** /*H0FS*/    if sod_list_pr <> 0 then do: */
/*J0KJ** /*J042*/ if (sod_price entered or minmax_occurred) and sod_list_pr <> 0*/
/*J0N2**
** /*J0KJ*/    if rma-issue-line and sod_list_pr <> 0 and (sod_price entered or
** /*J0KJ*/                                                minmax_occurred)
**J0N2*/
/*J15C*J0N2*if sod_list_pr <> 0  */
            /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
/*J15C*/    if rma-issue-line and
               sod_list_pr <> 0
            then do:
/*J1JV         sod_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.  */
/*J1JV*/       new_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.
/*J1JV*/       sod_disc_pct = new_disc_pct.
/*J042*/       /*DETERMINE DISCOUNT DISPLAY FORMAT*/
/*J15C**BEGIN DELETE**
 *J0N2*        disc_min_max = no.
 *J042*        {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}
 *J0N2*        if disc_min_max then do:
 *J0N2*           {mfmsg03.i 6932 3 disc_pct_err """" """"}
 *J0N2*           /* DISCOUNT # VIOLATES THE MIN OR MAX ALLOWABLE */
 *J0N2*           if not batchrun then
 *J0N2*              pause.
 *J15C**END DELETE**/
/*J15C*/       run p-disc-disp (input yes).
/*J15C*/       if disc_min_max then
/*J0N2*/          undo, retry.
/*J15C*J0N2*   end.  */

/*J042**
** /*FT43*/ if sod_disc_pct > 99999.99 or sod_disc_pct < -99999.99 then do:
** /*G0WL*/    /* DISCOUNT IS OUT OF RANGE AND WILL BE SET TO ALL 9'S  */
** /*FT43*/    {mfmsg.i 667 2}
** /*G0WL/*FT43*/ sod_disc_pct = 0.          */
** /*G0WL*/    sod_disc_pct = 99999.99.
** /*FT43*/ end.
**J042*/

/*J0N2**
** /*J042*/    if discount >= 9999.9999 or discount <= -9999.9999 then do:
** /*FT43*/       {mfmsg.i 667 2}
** /*FT43*/       sod_disc_pct = 0.
** /*J042*/       discount     = if pic_so_fact then 1 else 0.
** /*FT43*/    end.
**J0N2*/

/*J042**       display sod_disc_pct with frame c.**/
/*J042*/       display discount with frame c.
            end.

/*J042*/    /*TEST TO SEE IF NET PRICE HAS BEEN ENTERED, IF SO CREATE A
              DISCOUNT TYPE MANUAL RECORD TO wkpi_wkfl*/

/*J0KJ** /*J042*/ if (sod_price entered or minmax_occurred) and
**             sod_list_pr <> 0 then do: */
            /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
/*J0KJ*/    if rma-issue-line and sod_list_pr <> 0 and (sod_price entered or
/*J0KJ*/                                           minmax_occurred) then do:
/*J0KJ*/       sod__qadd01     = 0.
               minmax_occurred = no.

               find first wkpi_wkfl where wkpi_parent   = sobparent  and
                                          wkpi_feature  = sobfeature and
                                          wkpi_option   = sobpart    and
                                          wkpi_amt_type = "2"        and
                                          wkpi_source   = "1"
                                    no-lock no-error.

               if pic_disc_comb = "1" then do:          /*cascading discount*/
                  if available wkpi_wkfl then
/*J0N2**
**                       sys_disc_fact = ((100 - save_disc_pct) / 100) /
**                                     ((100 - wkpi_amt)      / 100).
**J0N2*/
/*J0N2*/             sys_disc_fact = if not found_100_disc then
/*J0N2*/                                ((100 - save_disc_pct) / 100) /
/*J0N2*/                                ((100 - wkpi_amt)      / 100)
/*J0N2*/                             else
/*J0N2*/                                0.
                  else
                     sys_disc_fact =  (100 - save_disc_pct) / 100.
                  if sys_disc_fact = 1 then
/*J1JV               man_disc_pct  = sod_disc_pct.   */
/*J1JV*/             man_disc_pct  = new_disc_pct.
                  else do:
/*J0N2*/             if sys_disc_fact <> 0 then do:
/*J1JV                  discount      = (100 - sod_disc_pct) / 100.   */
/*J1JV*/                discount      = (100 - new_disc_pct) / 100.
                        man_disc_pct  = (1 - (discount / sys_disc_fact)) * 100.
/*J0N2*/             end.
/*J1JV*/             else do:
/*J1JV*/                if available wkpi_wkfl then
/*J1JV*/                   man_disc_pct = new_disc_pct -
/*J1JV*/                                  (save_disc_pct - wkpi_amt).
/*J0N2*/                else
/*J1JV /*J0N2*/            man_disc_pct  = sod_disc_pct - 100.  */
/*J1JV*/                   man_disc_pct  = new_disc_pct - 100.
/*J1JV*/             end.
                  end.
               end.
               else do:                                 /*additive discount*/
                  if available wkpi_wkfl then
/*J1JV               man_disc_pct = sod_disc_pct -   */
/*J1JV*/             man_disc_pct = new_disc_pct -
                                    (save_disc_pct - wkpi_amt).
                  else
/*J1JV               man_disc_pct = sod_disc_pct - save_disc_pct.   */
/*J1JV*/             man_disc_pct = new_disc_pct - save_disc_pct.
               end.

/*LB01*/      {gprun.i ""zzgppiwkad.p"" "(
                                         sod_um,
                                         sobparent,
                                         sobfeature,
                                         sobpart,
                                         ""1"",
                                         ""2"",
                                         0,
                                         man_disc_pct,
                                         yes
                                        )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J042*/    end.  /*sod_price entered or minmax_occurred*/

/*J0N2*/ end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do on error undo, retry (for set sod_price) */

/*J042*/ /*SET DETAIL FREIGHT LIST, IF ANY.  DETERMINED THRU PRICING
           ROUTINES*/

/*J042*/ if current_fr_list <> "" then
/*J042*/    sod_fr_list = current_fr_list.

/*G501** This routine no longer needed - moved site prompt up before
 *       quantity; loc, lot/ser, confirm prompts down into sosomtlb.
 *    /*F040* - GET THE SITE, SET THE INVENTORY DATABASE */
 *    undo_all2 = true.
 *    {gprun.i ""sosomtsi.p""}
 *    if undo_all2 then undo loopc, retry.
 **G501*/

/*GB06*/ /* Set the default allocation quantity */
/*FL83** if new_line then do: **/
/*FL83**    {mfsoall.i}       **/
/*FL83** end.                 **/
/*FL83*/ if new_line
/*FL83*/    and sod_confirm
/*FL83*/    and sod_qty_ord > 0
/*FL83*/    and all_days <> 0
/*FL83*/    and (sod_due_date - (today + 1) < all_days)
/*FL83*/    then do:
/*FL83*/
/*FL83*/    if sod_type = "" then do:
/*FL83*/       new_site = sod_site.
/*FL83*/       {gprun.i ""gpalias2.p"" "(new_site, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*FL83*/       {gprun.i ""soqtyavl.p"" "(sod_part, sod_site, output qty_avl)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*FL83*/       {gprun.i ""gpalias3.p"" "(so_db, output err-flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*FU56*/       qty_avl = qty_avl / sod_um_conv.
/*FL83*/       /* (Note: qty pick and ship must be zero since line is new) */
/*FP33*/       if soc_all_avl = no then sod_qty_all = max(sod_qty_ord,0).
/*FP33*             sod_qty_all = max( min(sod_qty_ord, qty_avl) , 0). */
/*FP33*/       else sod_qty_all = max( min(sod_qty_ord, qty_avl) , 0).
/*FL83*/    end.
/*FL83*/    else
/*FL83*/       sod_qty_all = max( sod_qty_ord, 0 ).
/*FL83*/
/*FL83*/ end.

/*J04C*  ADDED THE FOLLOWING */
         /* FOR RMA'S, ALLOW USER TO OVERRIDE THE DEFAULT PRODUCT LINE */
         /* UP TO THE POINT IN TIME WHERE THEY'VE SHIPPED/INVOICED     */
         if this-is-rma and sngl_ln and sod_qty_ship = 0
         and sod_qty_inv = 0 then do:
            {gprun.i ""fsrmapl.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

            display
                      sod_acct sod_cc sod_dsc_acct sod_dsc_cc
            with frame d.
         end.
/*J04C*  END ADDED CODE */

         /* Update other sales order line information */
         undo_all2 = true.


/*J04C*  {gprun.i ""sosomtlb.p""}   */

         /* SOSOMTLB.P WILL, FOR RMA'S, CREATE/MODIFY THE RMD_DET */
/*H1B1*/ /* ADDITIONAL PARAMETER l_prev_um_conv PASSED TO sosomtlb.p */

/*LB01*//*J04C*/{gprun.i ""zzsosomtlb.p""
                "(input this-is-rma,
                  input rma-recno,
                  input rma-issue-line,
                  input rmd-recno,
          input l_prev_um_conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*G19G   if undo_all2 then undo loopc, leave. */
/*G19G*/ if undo_all2 then do:
/*G19G*/    hide message.
/*G19G*/    undo loopc, leave.
/*G19G*/ end.

      if sod_per_date = ? then sod_per_date = sod_due_date.
      if sod_req_date = ? then sod_req_date = sod_due_date.

/*G1GV*  LOAD SOD_CONTR_ID FROM SO_PO FOR SO_SHIPPER MAINT */
/*G29K*/ if not this-is-rma then
/*G1GV*/    assign sod_contr_id = so_po.

      if not available pt_mstr then do:
         update desc1 with frame d.
         sod_desc = desc1.
      end.

/*J042*/ /*DELETE OLD PRICE LIST HISTORY, CREATE NEW PRICE LIST HISTORY,
           MAINTAIN LAST PRICED DATE IN so_mstr (so_priced_dt)*/

/*J0KJ** /*J042*/ if line_pricing or reprice_dtl then do: */
/*J0N2** /*J0KJ*/ if rma-issue-line and (line_pricing or reprice_dtl) then do:*/
         /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
/*J0N2*/ if rma-issue-line and (new_order or reprice_dtl) then do:
/*J05G*/    best_net_price = sod_price. /*for "accrual" type price lists*/
/*LB01*/   {gprun.i ""zzgppiwk02.p"" "(
                                      1,
                                      sod_nbr,
                                      sod_line,
                                      sod_dsc_acct,
                                      sod_dsc_cc,
                                      sod_project
                                     )"}
/*GUI*/ if global-beam-me-up then undo, leave.

            so_priced_dt = today.
/*J042*/ end.

         /* FOR RMA'S, RMD_EDIT_ISB CONTROLS THE ISB DEFAULTS POPUP. */
         /* FOR SALES ORDERS, BASE POPUP ON SVC_SHIP_ISB AND PT_ISB. */
/*J04C*  ADDED THE FOLLOWING */
         if this-is-rma then do:
            if available svc_ctrl then
                if svc_ship_isb and rmd_edit_isb
/*J1CR*/        and ( available pt_mstr or not svc_pt_mstr )
                then do:
                    {gprun.i ""sosomisb.p""
                        "(input so_recno,
                          input sod_recno,
                          input new_line,
                          input rmd_edit_isb)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                end.  /* if svc_ship_isb and... */
         end.   /* if this-is-rma */
         else do:
/*J04C*  END ADDED CODE */
/*J1CR*/    /* FOR RETURNS, DISPLAY "EDIT ISB DEFAULTS" FRAME IF USER IS
               UPDATING ISB WITH RETURNS AND THIS PART EXISTS SOMEWHERE
               IN THE INSTALLED BASE.  FOR REGULAR SO'S, DISPLAY THIS
               FRAME ONLY IF SHIPPING TO ISB AND PART IS FLAGGED FOR ISB */
/*J1CR*
./*GK52*/    if available svc_ctrl and svc_ship_isb and
./*G457*/        available pt_mstr and
./*G457*/        pt_isb
.*J1CR*/
/*J1CR*/    if (sod_qty_ord < 0 and available svc_ctrl and svc_ship_isb and soc_returns_isb
/*J1CR*/         and can-find (first isb_mstr where isb_part = sod_part))
/*J1CR*/    or (sod_qty_ord >= 0 and available svc_ctrl and svc_ship_isb and
/*J1CR*/        available pt_mstr  and pt_isb)
/*G457*/    then do:
/*J1CR*         Changed 4th input parm from soc_edit_isb to... */
/*GJ56*/        {gprun.i ""sosomisb.p""
                    "(input so_recno,
                      input sod_recno,
                      input new_line,
                      input if sod_qty_ord < 0 then
                                soc_returns_isb
                            else soc_edit_isb)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G457*/    end.
/*J04C*/ end.   /* else (this isn't an rma) do: */

/*J04C*  ADDED INPUT PARAMETERS FOR THE USER EXIT PROGRAMS */
/*G457*/ if solinerun <> "" then do:
/*J04C* /*G457*/    {gprun.i solinerun}     */
/*J04C*/            {gprun.i solinerun
/*J1YB*/                "(input so_recno, input sod_recno)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J1YB*                 """(input so_recno,  input sod_recno)"""}  */
/*G457*/ end.

      /* LINE COMMENTS */
      if sodcmmts = yes then do:
         cmtindx = sod_cmtindx.
         global_ref = sod_part.
/*LB01*/ {gprun.i ""zzgpcmmt01.p"" "(input ""sod_det"")"}
/*GUI*/ if global-beam-me-up then undo, leave.
         sod_cmtindx = cmtindx.
      end.

/*F420*/ end.

/*F040* - UPDATE THE INVENTORY DATABASE FILES */
/*F504*/ if sod_confirm then do:
/*LB01*/   {gprun.i  ""zzsosomtu1.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*F504*/ end.
/*H059*/ else do:  /* UPDATE sob_det ONLY */
/*H059*/    if available pt_mstr and pt_pm_code = "C" then do:
/*H059*/    {gprun.i ""sosomti.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H059*/    end.
/*H059*/ end.

/*F420**   end. **/

   undo_all = no.
end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*do*/

/*FT43*/ /* at the request of srk, added no-pause for GUI */
/*FT43*  /*FR95*/ hide frame c_site.
*        /*FR95*/ hide frame line_pop.  *FT43*/
/*FT43*/ hide frame c_site no-pause.
/*FT43*/ hide frame line_pop no-pause.
/*H0FS*/ pause 0.

/*J1RY*/ if cfexists and cf_rm_old_bom and not undo_all
/*J1RY*/ then do:
/*J1RY*/    /*if the user chose to remove the old bom (as they modified the*/
/*J1RY*/    /*file) then we need to issue a save to save the config. and   */
/*J1RY*/    /*write the filename and model and config.status to the qad    */
/*J1RY*/    /* user fields.                                                */
/*J1RY*/   if search(cf_cfg_path + cf_chr + sod__qadc01) <> ?
/*J1RY*/   then os-delete value(cf_cfg_path + cf_chr + sod__qadc01).
/*J1RY*/   /* Write sod_det fields */
/*J1RY*/   sod__qadc01
/*J1RY*/   = lc(sod_nbr) + "_" + string(sod_line) + "." + lc(cf_cfg_suf).
/*J1RY*/   sod__qadc02 = pt_cf_model.
/*J1RY*/   sod__qadc03 = "".
/*J1RY*/   /*issue save to calico*/
/*J20Z*/     
/*J1RY*/   {gprunmo.i
              &module  = "cf"
              &program = "cfcfsave.p"
              &param   = """(string(cf_cfg_path + cf_chr + sod__qadc01))"""
           }
/*J20Z*/   
/*J1RY*/ end.

/*J1RY*/ if cfexists and not undo_all and not cf_rp_part
/*J1RY*/ then do:
/*J1RY*/    /*on a configured product, if the user selects qty ord = 0 std.  */
/*J1RY*/    /*functionality will delete the items bom. the functionality must*/
/*J1RY*/    /*also extend to deleting the created concinity qad_fields and   */
/*J1RY*/    /*associated files.                                              */
/*J1RY*/    if available sod_det and sod_qty_ord = 0 then do:
/*J1RY*/       os-delete value(cf_cfg_path + cf_chr + sod__qadc01).
/*J1RY*/       assign
/*J1RY*/          sod__qadc01 = ""
/*J1RY*/          sod__qadc02 = ""
/*J1RY*/          sod__qadc03 = "".
/*J1RY*/    end.
/*J1RY*/ end.

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
/*J1RY*/ end.

/*J15C**BEGIN ADD**/
         PROCEDURE p-sync-restock:
            /*****************************************************************/
            /* THIS PROCEDURE RE-APPLIES A RESTOCKING CHARGE TO AN RMA       */
            /* RECEIPT LINE IF A PERCENT EXISTS AND KEEPS NECESSARY FIELDS   */
            /* IN SYNC.  IT TAKES ON INPUT AS FOLLOWS.                       */
            /*                                                               */
            /* MODE - IF "default", INITIAL SETUP FOR DEFAULT PRICING        */
            /*        IF "discount", DISCOUNT OR LIST PRICE WAS UPDATED      */
            /*        IF "price", NET PRICE WAS UPDATED                      */
            /*****************************************************************/
            define input        parameter mode         as character.

            if not available sod_det  or
               not available rmd_det  or
               not available rma_mstr or
               not available pic_ctrl
            then
               leave.

            if restock-pct <> 0 then do:
               if mode = "default"  or
                  mode = "discount"
               then
                  sod_price       = sod_list_pr * (1 - restock-pct / 100).
               else if mode = "price" then
                  sod_list_pr     = if restock-pct <> 100
                                       then sod_price / (1 - restock-pct / 100)
                                       else sod_list_pr.

               assign
                  restock-amt     = sod_list_pr - sod_price
                  /* SOD_DISC_PCT HOLDS RESTOCK CHARGE PERCENTAGE */
                  sod_disc_pct    = restock-pct
                  /* SOD_COVERED_AMT HOLDS RESTOCK CHARGE AMOUNT  */
                  sod_covered_amt = restock-amt.

            end.  /* if restock-pct <> 0 */

            else do:
               if mode = "default" or
                  mode = "price"
               then
                  sod_disc_pct    = if sod_list_pr <> 0
                                       then (1 - (sod_price / sod_list_pr)) * 100
                                       else 0.
               else if mode = "discount" then
                  assign
                     sod_disc_pct = if pic_so_fact
                                       then (1 - discount) * 100
                                       else discount
                     sod_price    = sod_list_pr -
                                       (sod_disc_pct * sod_list_pr * 0.01).

               assign
                  restock-amt     = 0
                  sod_covered_amt = 0.

            end.  /* else do */

            assign
               rmd_sv_code  = rma_ctype
               /* SOD_CONTR_ID HOLDS CONTRACT # IF CONTRACT SVC TYPE USED */
               sod_contr_id = if not available sv_mstr  or
                                 sv_mstr.sv_svc_type = "W"
                                 then ""
                                 else rma_contract.

            run p-disc-disp (input yes).
         END PROCEDURE.  /* p-sync-restock */

         PROCEDURE p-disc-disp:
            /*****************************************************************/
            /* THIS PROCEDURE WILL CHECK THE SO OR RMA LINE'S DISCOUNT FIELD */
            /* TO INSURE THAT IT COMPLIES WITH THE PRICING CONTROL FILE      */
            /* FORMAT.  IT TAKES ON INPUT AS FOLLOWS.                        */
            /*                                                               */
            /* WARN - IF YES, A MESSAGE WILL BE DISPLAYED WITH A PAUSE       */
            /*****************************************************************/
            define input        parameter warn         like mfc_logical.

            if not available sod_det  or
               not available pic_ctrl
            then
               leave.

            disc_min_max = no.
            {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}
            if disc_min_max and
               warn
            then do:
               {mfmsg03.i 6932 3 disc_pct_err """" """"}
               /* DISCOUNT # VIOLATES THE MIN OR MAX ALLOWABLE */
               if not batchrun then
                  pause.
            end.  /* if disc_min_max */
         END PROCEDURE.  /* p-disc-disp */
/*J15C**END ADD**/
