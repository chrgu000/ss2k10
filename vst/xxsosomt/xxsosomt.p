/* sosomt.p   - SALES ORDER MAINTENANCE                                 */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 1.0      LAST MODIFIED: 03/20/86   BY: pml                 */
/* REVISION: 6.0      LAST MODIFIED: 06/29/90   BY: WUG *D043*          */
/* REVISION: 6.0      LAST MODIFIED: 03/20/90   BY: ftb *D007*          */
/* REVISION: 6.0      LAST MODIFIED: 03/21/90   BY: ftb *D011*          */
/* REVISION: 6.0      LAST MODIFIED: 03/22/90   BY: ftb *D013*          */
/* REVISION: 6.0      LAST MODIFIED: 04/16/90   BY: MLB *D021*          */
/* REVISION: 6.0      LAST MODIFIED: 08/09/90   BY: MLB *D055*          */
/* REVISION: 6.0      LAST MODIFIED: 10/19/90   BY: pml *D109*          */
/* REVISION: 6.0      LAST MODIFIED: 11/14/90   BY: MLB *D208*          */
/* REVISION: 6.0      LAST MODIFIED: 12/06/90   BY: MLB *D238*          */
/* REVISION: 6.0      LAST MODIFIED: 01/02/91   BY: dld *D259*          */
/* REVISION: 6.0      LAST MODIFIED: 01/02/91   BY: afs *D308*(rev only)*/
/* REVISION: 6.0      LAST MODIFIED: 03/04/91   BY: afs *D396*(rev only)*/
/* REVISION: 6.0      LAST MODIFIED: 03/08/91   BY: dld *D409*          */
/* REVISION: 6.0      LAST MODIFIED: 04/18/91   BY: afs *D541*          */
/* REVISION: 7.0      LAST MODIFIED: 09/17/91   BY: MLV *F015*          */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*          */
/* REVISION: 6.0      LAST MODIFIED: 10/01/91   BY: afs *D884*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 10/29/91   BY: MLV *F029*          */
/* REVISION: 7.0      LAST MODIFIED: 11/13/91   BY: afs *F038*          */
/* REVISION: 7.0      LAST MODIFIED: 11/14/61   BY: afs *F042*          */
/* REVISION: 6.0      LAST MODIFIED: 11/18/91   BY: afs *D934*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 12/01/91   BY: afs *F039*          */
/* REVISION: 7.0      LAST MODIFIED: 02/04/92   BY: MLV *F150*          */
/* REVISION: 7.0      LAST MODIFIED: 02/21/92   BY: afs *F223*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 03/04/92   BY: tjs *F247*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 03/17/92   BY: tjs *F273*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 03/25/92   BY: tmd *F263*          */
/* REVISION: 7.0      LAST MODIFIED: 03/24/92   BY: dld *F297*          */
/* REVISION: 7.0      LAST MODIFIED: 03/31/92   BY: afs *F338*          */
/* REVISION: 7.0      LAST MODIFIED: 04/02/92   BY: afs *F253*          */
/* REVISION: 7.0      LAST MODIFIED: 04/02/92   BY: dld *F349*          */
/* REVISION: 7.0      LAST MODIFIED: 04/08/92   BY: tmd *F367*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: dld *F358*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 04/10/92   BY: afs *F356*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 04/16/92   BY: dld *F382*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 04/22/92   BY: afs *F420*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 04/22/92   BY: tjs *F421*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 04/30/92   BY: tjs *F463*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 05/06/92   BY: tjs *F470*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 05/11/92   BY: tjs *F444*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 05/29/92   BY: tjs *F504*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: afs *F519*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 06/18/92   BY: tmd *F458*          */
/* REVISION: 7.0      LAST MODIFIED: 06/23/92   BY: afs *F678*          */
/* REVISION: 7.0      LAST MODIFIED: 06/26/92   BY: afs *F676*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 06/26/92   BY: afs *F711*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 06/30/92   BY: tjs *F698*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 07/07/92   BY: tjs *F496*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 07/08/92   BY: tjs *F723*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 07/13/92   BY: tjs *F764*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 07/24/92   BY: tjs *F765*          */
/* REVISION: 7.0      LAST MODIFIED: 07/24/92   BY: tjs *F802*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 07/31/92   BY: tjs *F815*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 07/29/92   BY: emb *F817*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 08/21/92   BY: afs *F862*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 08/24/92   BY: tjs *F835*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 09/17/92   BY: tjs *G035*          */
/* REVISION: 7.3      LAST MODIFIED: 10/06/92   BY: tjs *G129*          */
/* REVISION: 7.3      LAST MODIFIED: 10/07/92   BY: mpp *G013*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247*          */
/* REVISION: 7.3      LAST MODIFIED: 11/03/92   BY: sas *G242*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 11/05/92   BY: afs *G262*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 11/05/92   BY: afs *G244*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 11/18/92   BY: tjs *G191*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 12/08/92   BY: tjs *G391*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 12/17/92   BY: tjs *G454*          */
/* REVISION: 7.3      LAST MODIFIED: 12/21/92   BY: tjs *G456*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 12/31/92   BY: mpp *G484*          */
/* REVISION: 7.3      LAST MODIFIED: 01/12/93   BY: tjs *G507*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 01/13/93   BY: tjs *G522*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 01/15/93   BY: afs *G501*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 01/18/93   BY: tjs *G557*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 01/21/93   BY: tjs *G579*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 01/26/93   BY: bcm *G429*          */
/* REVISION: 7.3      LAST MODIFIED: 01/27/93   BY: tjs *G599*          */
/* REVISION: 7.3      LAST MODIFIED: 02/04/93   BY: bcm *G415*          */
/* REVISION: 7.3      LAST MODIFIED: 02/09/93   BY: tjs *G588*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 02/18/93   BY: afs *G692*          */
/* REVISION: 7.3      LAST MODIFIED: 12/18/92   BY: sas *G457*          */
/* REVISION: 7.3      LAST MODIFIED: 03/09/93   BY: tjs *G789*          */
/* REVISION: 7.3      LAST MODIFIED: 03/16/93   BY: bcm *G823*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 03/23/93   BY: tjs *G858*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 04/05/93   BY: bcm *G889*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 04/08/93   BY: tjs *G830*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 04/16/93   BY: tjs *G911*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 04/19/93   BY: tjs *G948*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 04/20/93   BY: afs *G970*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 04/26/93   BY: bcm *GA36*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 05/17/93   BY: afs *GB06*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 05/20/93   BY: kgs *GA92*          */
/* REVISION: 7.3      LAST MODIFIED: 05/20/93   BY: kgs *GB18*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 05/20/93   BY: kgs *GA60*          */
/* REVISION: 7.3      LAST MODIFIED: 05/21/93   BY: tjs *GA70*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 05/21/93   BY: tjs *G962*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 05/25/93   BY: afs *GB31*          */
/* REVISION: 7.3      LAST MODIFIED: 06/07/93   BY: tjs *GA64*(rev only)*/
/* REVISION: 7.4      LAST MODIFIED: 06/21/93   BY: pcd *H008*          */
/* REVISION: 7.4      LAST MODIFIED: 07/30/93   BY: cdt *H048*          */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*          */
/* REVISION: 7.4      LAST MODIFIED: 09/29/93   BY: tjs *H082*          */
/* REVISION: 7.4      LAST MODIFIED: 09/22/93   BY: cdt *H086*          */
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: bcm *H185*          */
/* REVISION: 7.4      LAST MODIFIED: 10/28/93   BY: dpm *H067*(rev only)*/
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184*          */
/* REVISION: 7.4      LAST MODIFIED: 11/22/93   BY: afs *H238*(rev only)*/
/* REVISION: 7.4      LAST MODIFIED: 01/28/94   BY: afs *GI55*          */
/* REVISION: 7.4      LAST MODIFIED: 04/19/94   BY: WUG *FN46*          */
/* REVISION: 7.4      LAST MODIFIED: 04/21/94   BY: dpm *GJ49*          */
/* REVISION: 7.4      LAST MODIFIED: 05/23/94   BY: afs *FM85*          */
/* REVISION: 7.4      LAST MODIFIED: 05/26/94   BY: afs *GH40*          */
/* REVISION: 7.4      LAST MODIFIED: 06/21/94   BY: qzl *H397*          */
/* REVISION: 7.4      LAST MODIFIED: 07/19/94   BY: qzl *H446*          */
/* REVISION: 7.4      LAST MODIFIED: 08/17/94   BY: dpm *FQ25*          */
/* REVISION: 7.4      LAST MODIFIED: 09/10/94   BY: bcm *GM05*          */
/* REVISION: 7.4      LAST MODIFIED: 09/22/94   BY: jpm *GM78*          */
/* REVISION: 7.4      LAST MODIFIED: 10/20/94   BY: rmh *FQ08*          */
/* REVISION: 7.4      LAST MODIFIED: 10/29/94   BY: bcm *FT06*          */
/* REVISION: 8.5      LAST MODIFIED: 11/28/94   BY: mwd *J034*          */
/* REVISION: 7.4      LAST MODIFIED: 01/12/95   BY: ais *F0C7*          */
/* REVISION: 8.5      LAST MODIFIED: 02/23/95   BY: dpm *J044*          */
/* REVISION: 8.5      LAST MODIFIED: 03/02/95   BY: DAH *J042*          */
/* REVISION: 8.5      LAST MODIFIED: 03/13/95   BY: jlf *J042*          */
/* REVISION: 7.4      LAST MODIFIED: 03/15/95   BY: WUG *G0CW*          */
/* REVISION: 7.4      LAST MODIFIED: 04/06/95   BY: rxm *G0K8*          */
/* REVISION: 7.4      LAST MODIFIED: 05/01/95   BY: vrn *F0R2           */
/* REVISION: 7.4      LAST MODIFIED: 05/02/95   BY: jxz *G0LS*          */
/* REVISION: 7.4      LAST MODIFIED: 10/23/95   BY: ais *G19P*          */
/* REVISION: 7.4      LAST MODIFIED: 12/07/95   BY: rxm *H0FS*          */
/* REVISION: 7.4      LAST MODIFIED: 02/05/96   BY: ais *G0NX*          */
/* REVISION: 8.5      LAST MODIFIED: 02/21/96   BY: taf *J053*          */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: *J04C* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: *J0HR* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: *J12Q* Andy Wasilczuk*/
/* REVISION: 8.6      LAST MODIFIED: 06/03/97   BY: *K0DQ* Taek-Soo Chang */
/* REVISION: 8.6E    LAST MODIFIED: 04/23/98 BY: *L00L* EvdGevel REV ONLY */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98 BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98 BY: *J314* Alfred Tan        */
/* REVISION: 9.1     LAST MODIFIED: 12/14/99 BY: *N05D* Steve Nugent      */
/* REVISION: 9.1     LAST MODIFIED: 08/12/00 BY: *N0KN* myb               */
/* ADM1    11/17/03 Brian Lo -  add audit trail logic      */

/*J034*  * MOVED MFDTITLE.I UP FROM BELOW */
/*131023.1*********************************************************************
 * 关于销售系统，当生产部门在7.1.1中把销售订单录入完毕，可否增加一个节点，
 * 让财务部门进行审核单价，当财务部门审核无误后，才可以在7.9.2中作预先出货单。
 * call stack: xxsosomt.p->xxsosomt1.p->xxsosomtc.p->xxsosomtc2.p
 * 控制设置在CODE_MSTR fldname = "WHEN_SO_HOLD_DISABL_SHIP"
 *131023.1********************************************************************/
         /* DISPLAY TITLE */
         {mfdtitle.i "131023.1"}  /*H238*/

/*N05D*/ /* CHANGES MADE TO THIS PROGRAM MAY ALSO NEED TO BE */
/*N05D*/ /* MADE TO PROGRAM fseomt.p.                        */

/*L00L*/ {etdcrvar.i "new"}
/*L00L*/ {etvar.i &new="new"}
/*L00L*/ {etrpvar.i &new="new"}

/*!

    With J04C, Sales Orders and RMAs are maintained in common code.  Sosomt.p
    and fsrmamt.p both call sosomt1.p for their processing.  The one input
    parameter to sosomt1.p tells it whether RMA's or SO's are being maintained.

*/

/*J04C*/    pause 0.

           /* THE INPUT PARAMETER TO SOSOMT1.P, NO, MEANS, "NO, THIS IS    */
           /* NOT AN RMA" TO THAT PROGRAM.                                 */

/*ADM1/*J04C*/   {gprun.i  ""sosomt1.p""*/
/*ADM1*/   {gprun.i  ""xxsosomt1.p""
                     "(input no)"}

/*J04C*  ALL THIS HAS BEEN MOVED TO SOSOMT1.P...

/*J053*/ define new shared variable rndmthd like rnd_rnd_mthd.
/*J053*/ define new shared variable oldcurr like so_curr.
/*G247** define shared variable mfguser as character. **/
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
/*J042*  define variable sonbr like so_nbr.*/
/*J042*/ define new shared variable sonbr like so_nbr.
         define variable yn like mfc_logical initial yes.
/*J053*  define variable i as integer.                                        */
/*GB31*/ define  new shared  variable socmmts like soc_hcmmts label "Comments".
         define new shared variable prev_abnormal like sod_abnormal.
         define new shared variable promise_date as date label "Promise Date".
         define new shared variable base_amt like ar_amt.
         define variable comment_type like so_lang.
         define new shared variable sod_recno as recid.
         define new shared variable consume like sod_consume /* initial no*/ .
         define new shared variable prev_consume like sod_consume.
/*GB31*/ define  new shared  variable confirm like mfc_logical
/*GB31*/  format "yes/no" initial yes label "Confirmed".
         define new shared variable sotrcust like so_cust.
         define variable sotrnbr like so_nbr.
         define new shared variable merror like mfc_logical initial no.
/*GB31** define buffer somstr for so_mstr. **/
         define new shared variable so-detail-all like soc_det_all.
/*F297** define variable old_slspsn like so_slspsn. */
/*GB31** define new shared variable old_slspsn like so_slspsn no-undo. */
         define new shared variable new_order like mfc_logical initial no.
         define new shared variable sotax_trl like tax_trl.
         define new shared variable tax_in like cm_tax_in.
/*F297** define variable rebook_lines as logical initial no. */
/*F297*/ define new shared variable rebook_lines as logical initial no no-undo.
/*F040*/ define new shared variable avail_calc as integer.
/*F040*/ define new shared variable so_db like dc_name.
/*F040*/ define new shared variable inv_db like dc_name.
/*F039*/ define buffer bill_cm for cm_mstr.
/*F297*/ define new shared variable mult_slspsn like mfc_logical no-undo.
/*J053** /*F297*/ define variable counter as integer no-undo. ****/
/*F297*/ define variable sort as character format "x(28)" extent 4 no-undo.
/*F297*/ define variable keylist as character
/*F297*/ initial "RETURN,TAB,BACK-TAB,GO,13,9,509,245,513,301,248" no-undo.
/*GB31** define new shared variable tax_recno as recid. **/
/*GB31** define variable tax_date like tax_effdate. **/
/*F0R2*/ define variable old_so_print_pl like so_print_pl no-undo.
/*F678*/ define new shared frame a.
/*J053*  ** THESE FRAMES WERE MOVED TO SOSOMTA1.P ***********************
/*F678*/ define new shared frame sold_to.
/*F678*/ define new shared frame ship_to.
/*GB31*/ define new shared frame b.
 *J053 END***************************************************************/
/*F678*/ define new shared variable undo_cust like mfc_logical.
/*G035*/ define new shared variable freight_ok like mfc_logical initial yes.
/*G035*/ define new shared variable old_ft_type like ft_type.
/*H048** define variable calc_fr like mfc_logical label "Calc Freight".*/
/*H048*/ define new shared variable calc_fr like mfc_logical
/*H048*/                                    label "Calculate Freight".
/*G035*/ define variable alloc   like mfc_logical label "Allocations".
/*GB31** define variable old_fr_terms like so_fr_terms.            **/
/*GB31** define variable old_um like fr_um.                        **/
/*GB31** define new shared variable undo_sosomtb like mfc_logical. **/
/*GB31*/ define new shared variable undo_flag like mfc_logical.
/*H049*/ define new shared variable disp_fr like mfc_logical.
/*H082*/ define new shared variable display_trail like mfc_logical initial yes.
/*H086*/ define new shared variable soc_pc_line like mfc_logical initial yes.
/*H184*/ define new shared variable socrt_int like sod_crt_int.
/*J044*/ define new shared variable impexp   like mfc_logical no-undo.
/*J044*/ define            variable impexp_edit like mfc_logical no-undo.
/*J044*/ define            variable upd_okay    like mfc_logical no-undo.
/*G0LS*/ define variable batch_job as logical.
/*G0LS*/ define variable dev       as character.
/*G0LS*/ define variable batch_id  as character.
/*J053*  /*G0NX*/ define variable in_batch_proces as logical. */
/*J042*/ define new shared variable picust like cm_addr.
/*J042*/ define new shared variable price_changed like mfc_logical.
/*J042*/ define new shared variable line_pricing like pic_so_linpri
                                                 label "Line Pricing".
/*J042*/ define new shared variable reprice like mfc_logical label "Reprice"
                                            initial no.
/*J042*/ define new shared stream bi.
/*J042*/ define new shared frame bi.
/*J053*/ define new shared variable balance_fmt as character.
/*J053*/ define new shared variable limit_fmt as character.
/*J053*/ define new shared variable prepaid_fmt as character no-undo.
/*J053*/ define new shared variable prepaid_old as character no-undo.

/*J042*/ form
/*J042*/    sod_qty_ord                format "->>>>,>>9.9<<<<"
/*J042*/    sod_list_pr                format ">>>,>>>,>>9.99<<<"
/*J042*/    sod_disc_pct label "Disc%" format "->>>>9.99"
/*J042*/ with frame bi width 80.

/*J042*/ form sod_det with frame bi width 80.

/*J042*/ {pppivar.i "new"}  /* PRICING VARIABLES */

/*J042*/ /*DEFINE WORKFILE FOR QTY ACCUM USED BY BEST PRICING ROUTINES*/
         {pppiwqty.i "new" }
/*J042**
** /*H0FS*/ define new shared variable qo_recno as recid.
** /*H0FS*/ define new shared variable qod_recno as recid.
** /*H0FS*/ define new shared variable qoc_pt_req like mfc_logical.
** *!qo_recno, qod_recno AND qoc_pt_req HAVE BEEN ADDED TO THIS PROGRAM IN ORDER
**  TO COMPLY WITH gppccala.p WHICH IS USED FOR BOTH SALES ORDERS, QUOTES AND
**  RMAs.  THESE VARIABLES WILL NOT BE USED DURING SALES ORDER MAINTENANCE.
**
**
** /*H0FS*/ {gpfowfop.i "new"}   /* work3_list SHARED WORKFILE AND VARIABLES */
**J042*/

/*G429*/ {gptxcdec.i}
/*J053*/ {mfsotrla.i "NEW"}

/*J053*/ {sosomt01.i}

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
/*J053*/ /* SET BALANCE_FMT ACCORDING TO BASE CURR ROUND METHOD*/
/*J053*/ balance_fmt = "->>>>,>>>,>>9.99".
/*J053*/ {gprun.i ""gpcurfmt.p"" "(input-output balance_fmt,
                                   input gl_rnd_mthd)"}

         do transaction /*#1*/ on error undo, retry:
            find first soc_ctrl no-lock no-error.
            if not available soc_ctrl then create soc_ctrl.
            all_days = soc_all_days.
            all_avail = soc_all_avl.
            sngl_ln = soc_ln_fmt.
            socmmts = soc_hcmmts.
            comment_type = global_type.
            confirm = soc_confirm.
/*J042* /*H0FS*/ disc_tbl_req = soc_pl_req. */

/*G0LS*/    /* ADDING BATCH PROCESSING PARAMETERS */
/*G0LS*/    find first mfc_ctrl where mfc_field = "soc_batch" no-lock no-error.
/*G0LS*/    if available mfc_ctrl then batch_job = mfc_logical.
/*G0LS*/    find first mfc_ctrl where mfc_field = "soc_print_id"
/*G0LS*/                        no-lock no-error.
/*G0LS*/    if available mfc_ctrl then dev = mfc_char.
/*G0LS*/    find first mfc_ctrl where mfc_field = "soc_batch_id"
/*G0LS*/                        no-lock no-error.
/*G0LS*/    if available mfc_ctrl then batch_id = mfc_char.

         end. /* DO TRANSACTION #1 */

/*H086*/ /* SET UP PRICING BY LINE VALUES */
/*H086*/ do transaction /*#2*/ on error undo, retry:
/*H086*/    find first mfc_ctrl where mfc_field = "soc_pc_line"
/*H086*/    no-lock no-error.
/*H086*/    if available mfc_ctrl then do:
/*H086*/       soc_pc_line = mfc_logical.
/*H086*/    end.
/*H086*/ end. /* DO TRANSACTION #2 */

/*F040*/ /* DETERMINE AND STORE THE WAY QTY AVAIL TO ALLOC IS CALCULATED */
/*F040*/ /* (THE RESULTING SETTING WILL MATCH THE FIRST FIELD IN SOSOPM.P) */
         if soc_all then do:
            if soc_on_ord then avail_calc = 2.
                          else avail_calc = 1.
         end.
         else if soc_req then do:
            if soc_on_ord then avail_calc = 4.
                          else avail_calc = 3.
         end.

/*J053** find first gl_ctrl no-lock. *****/

/*F040*/ so_db = global_db.

/*J042*/ do transaction /*#3*/ on error undo, retry:
/*J042*/    find first pic_ctrl no-lock no-error.
/*J042*/    if not available pic_ctrl then
/*J042*/       create pic_ctrl.
/*J042*/ end. /* DO TRANSACTION #3 */

         mainloop: repeat:

/*G19P*/    find first mfc_ctrl where mfc_field = "soc_batch" no-lock no-error.
/*G19P*/    if available mfc_ctrl then batch_job = mfc_logical.

/*J053*/    {sosomt02.i}  /* FORM DEFINITIONS FOR SHARED FRAMES A AND B */
/*J053*/    view frame dtitle.
/*J053*/    view frame a.

/*J053*/    /* PROCESS SALES ORDER HEADER FRAMES */
/*J053*/    {gprun.i ""sosomta1.p"" "(output return_int)"}
/*J12Q*/    cr_terms_changed = no.

/*J053*/    if return_int = 1 then next mainloop.
/*J053*/    if return_int = 2 then undo mainloop, next mainloop.
/*J053*/    if return_int = 3 then undo mainloop, retry mainloop.
/*J053*/    if return_int = 4 then undo mainloop, leave.
/*J053******** SPLIT OUT ORDER HEADER INPUT FRAME PROCESSING TO SOSOMTA1.P **
 *          do transaction /*#4*/ on error undo, retry:
 *
 *             hide all no-pause.
 *
/*GM78*/ /*V8! if global-tool-bar and global-tool-bar-handle <> ? then
 *             view global-tool-bar-handle.  */
 *
 *             find first soc_ctrl no-lock.
 *             socmmts = soc_hcmmts.
 *
/*GB31*/       {sosomt02.i}  /* FORM DEFINITIONS FOR SHARED FRAMES A AND B */
 *
/*GB31*/       /* FORMS FOR FREIGHT (D) AND ALLOCS (E) MOVED TO SOSOMTP.P */
 *
 *             {mfadform.i "sold_to" 1 " Sold-To "}
/*GM05*/       {mfadform.i "ship_to" 41 " Ship-To "}
/*GM05*****    {mfadform.i "ship_to" "41 row 5" " Ship-To "}  **/
/*F678*****    {mfadform.i "bill_to" 41 " Bill-To "} **/
 *
 *             view frame dtitle.
 *             view frame a.
 *             view frame sold_to.
 *             view frame ship_to.
 *             view frame b.
 *
 *             prompt-for so_nbr with frame a editing:
 *
/*F038*/          /* ALLOW LAST SO NUMBER REFRESH */
 *                if keyfunction(lastkey) = "RECALL" or lastkey = 307
 *                 then display sonbr @ so_nbr with frame a.
 *
 *                /* FIND NEXT/PREVIOUS RECORD */
 *                {mfnp.i so_mstr so_nbr so_nbr so_nbr so_nbr so_nbr}
 *
 *                if recno <> ? then do with frame b:
 *                   {mfaddisp.i so_cust sold_to}
 *                   {mfaddisp.i so_ship ship_to}
 *                   display so_nbr so_cust so_bill so_ship with frame a.
 *                   find first sod_det where sod_nbr = so_nbr no-lock no-error.
 *                   if available sod_det and sod_per_date <> ?
 *                      then promise_date = sod_per_date.
 *                      else promise_date = ?.
 *                   if so_conf_date = ? then confirm = no. else confirm = yes.
 *
/*F297*/             if so_slspsn[2] <> "" or
/*F297*/                so_slspsn[3] <> "" or
/*F297*/                so_slspsn[4] <> "" then mult_slspsn = true.
/*F297*/             else mult_slspsn = false.
 *
/*G035*/             {sosomtdi.i} /* DISPLAY SO_ORD_DATE, ETC IN FRAME B */
 *                end. /* IF RECNO <> ? */
 *             end. /* PROMPT-FOR SO_NBR */
 *
 *             if input so_nbr = "" then do:
/*G692*/          /* Get next sales order number with prefix */
/*G692**          {mfnctrl.i soc_ctrl soc_so so_mstr so_nbr sonbr} **/
/*G692*/          {mfnctrlc.i soc_ctrl soc_so_pre soc_so so_mstr so_nbr sonbr}
 *             end. /* IF INPUT SO_NBR = "" */
 *             else sonbr = input so_nbr.
 *          end.  /* DO TRANSACTION #4 */
 *
 *          do transaction /*#5*/ on error undo, retry:
 *
/*G035*/       old_ft_type = "".
 *             find so_mstr where so_nbr = sonbr exclusive-lock no-error.
 *             if not available so_mstr then do:
 *                find first soc_ctrl no-lock.
 *                clear frame sold_to.
 *                clear frame ship_to.
 *                clear frame b.
 *                {mfmsg.i 1 1} /* ADDING NEW RECORD */
 *
 *                create so_mstr.
 *                new_order = yes.
 *                assign so_nbr       = sonbr
 *                       so_ord_date  = today
 *                       so_due_date  = today + soc_shp_lead
 *                       so_print_so  = soc_print
 *                       so_fob       = soc_fob
 *                       confirm      = soc_confirm
/*FQ25*/                 /* SET SO_PRINT_PL SO IT DOES NOT PRINT WHILE IT IS */
/*FQ25*/                 /* BEING CREATED. IT IS RESET TO YES IN SOSOMTC.P   */
/*FQ25*/                 so_print_pl  = no
/*K0DQ*/                 so_userid    = global_userid
 *                       socmmts      = soc_hcmmts.
 *             end. /* IF NOT AVAILABLE SO_MSTR */
 *             else do: /* IF AVAILABLE SO_MSTR */
 *                {mfmsg.i 10 1} /* EDITING EXISTING RECORD */
 *
/*G457*/          if so_fsm_type <> "" then do:
/*G457*/             {mfmsg.i 7190 3}
/*G457*/             undo mainloop, retry mainloop.
/*G457*/          end.
 *
/*J034*/          {gprun.i ""gpsiver.p"" "(input so_site,
 *                                         input ?,
 *                                         output return_int)"}
 *
/*J034*/          if return_int = 0 then do:
/*J034*/             display so_nbr so_cust so_bill so_ship with frame a.
/*J034*/             {sosomtdi.i} /* display so_order_date, etc with frame b */
/*J034*/             {mfmsg.i 725 3} /* USER DOES NOT HAVE ACCESS TO THIS SITE*/
/*J034*/             undo mainloop, retry mainloop.
/*J034*/          end. /* IF RETURN_INT = 0 */
 *
 * /*G0NX*/       /* Check for batch shipment record */
 * /*G0NX*/       in_batch_proces = no.
 * /*G0NX*/       {sosrchk.i so_nbr in_batch_proces}
 * /*G0NX*/       if in_batch_proces
 * /*G0NX*/       then undo mainloop, retry mainloop.
 *
 *                {mfaddisp.i so_cust sold_to}
 *                if not available ad_mstr then do:
 *                   hide message no-pause.
 *                   {mfmsg.i 3 2} /* CUSTOMER DOES NOT EXIST */
 *                end. /* IF NOT AVAILABLE AD_MSTR */
 *
 *                {mfaddisp.i so_ship ship_to}
 *
 *                if so_conf_date = ? then confirm = no.
 *                else confirm = yes.
/*F253*/          new_order = no.
/*G035*/          find ft_mstr where ft_terms = so_fr_terms no-lock no-error.
/*G035*/          if available ft_mstr then old_ft_type = ft_type.
 *
/*FN46*/          if so_sched then do:
/*FN46*/             {mfmsg.i 8210 2}
/*FN46*/          end.
 *             end. /* ELSE IF AVAILABLE SO_MSTR */
 *
 *             so-detail-all = soc_det_all.
 *             recno = recid(so_mstr).
 *
 *             /* CHECK FOR COMMENTS*/
 *             if so_cmtindx <> 0 then socmmts = yes.
 *
 *             display so_nbr so_cust so_bill so_ship with frame a.
 *             sotrnbr = so_nbr.
 *             sotrcust = so_cust.
 *
 *             find first sod_det where sod_nbr = so_nbr no-lock no-error.
 *             if available sod_det and sod_per_date <> ?
 *                then promise_date = sod_per_date.
 *                else promise_date = ?.
 *
/*F297*/       if so_slspsn[2] <> "" or
/*F297*/          so_slspsn[3] <> "" or
/*F297*/          so_slspsn[4] <> "" then mult_slspsn = true.
/*F297*/       else mult_slspsn = false.
 *
/*G035*/       {sosomtdi.i} /* DISPLAY SO_ORD_DATE, ETC IN FRAME B */
 *
/*F678*/       /* GET SOLD-TO, BILL-TO, AND SHIP-TO CUSTOMER */
/*F678*/       so_recno = recid(so_mstr).
/*F678*/       undo_cust = true.
/*F678*/       {gprun.i ""sosomtcm.p""}
/*F678*/       if undo_cust then undo mainloop, retry.
 *
/*F678*/       find cm_mstr where cm_mstr.cm_addr = so_cust no-lock.
/*F678*/       find bill_cm where bill_cm.cm_addr = so_bill no-lock.
/*G0K8*/       find ad_mstr where ad_addr = so_bill no-lock.
/*G0K8*/       if ad_inv_mthd = "" then do:
/*FM85*/          find ad_mstr where ad_addr = so_ship  no-lock.
/*G0K8*/          if ad_inv_mthd = "" then
/*G0K8*/             find ad_mstr where ad_addr = so_cust  no-lock.
/*G0K8*/       end. /* IF AD_INV_MTHD = "" */
/*H397*/       if new_order then so_inv_mthd = ad_inv_mthd.
/*G0CW*/       if new_order then substr(so_inv_mthd,3,1)
/*G0CW*/                       = substr(ad_edi_ctrl[5],1,1).
 *
/*J042*/       /*SET CUSTOMER VARIABLE USED BY PRICING ROUTINE gppibx.p*/
 *             picust = so_cust.
 *             if so_cust <> so_ship and
 *                can-find(cm_mstr where cm_mstr.cm_addr = so_ship) then
 *                   picust = so_ship.
 *
/*J042*/       if new_order then
 *                line_pricing = pic_so_linpri.
 *             else
 *                line_pricing = no.
 *
 *             order-header:
 *             do on error undo, retry with frame b:
 *
 *                ststatus = stline[2].
 *                status input ststatus.
 *                del-yn = no.
 *
 *                /* SET DEFAULTS WHEN CREATING A NEW ORDER - */
 *                /* USE SHIP-TO CUSTOMER INFO FOR DEFAULT IF */
 *                /* AVAILABLE ELSE USE SOLD-TO INFO          */
 *                if new so_mstr then do:
 *                   if so_cust <> so_ship and
 *                    can-find(cm_mstr where cm_mstr.cm_addr = so_ship) then
 *                      find cm_mstr where cm_mstr.cm_addr = so_ship no-lock.
 *                   assign
 *                    so_cr_terms = bill_cm.cm_cr_terms
 *                    so_curr     = bill_cm.cm_curr
 *
/*J042 PRICE LISTS NO LONGER INITIALIZED FROM cm_mstr
**                    so_pr_list  = cm_mstr.cm_pr_list
/*H086*/              so_pr_list2 = cm_mstr.cm_pr_list2
**J042*/
 *
/*H086*/              so_fix_pr   = cm_mstr.cm_fix_pr
 *                    so_disc_pct = cm_mstr.cm_disc_pct
 *                    so_shipvia  = cm_mstr.cm_shipvia
 *                    so_partial  = cm_mstr.cm_partial
 *                    so_rmks     = cm_mstr.cm_rmks
 *                    so_site     = cm_mstr.cm_site
 *                    so_taxable  = cm_mstr.cm_taxable
 *                    so_taxc     = cm_mstr.cm_taxc
 *                    so_pst      = cm_mstr.cm_pst
 *                    so_fst_id   = cm_mstr.cm_fst_id
 *                    so_pst_id   = ad_pst_id   /*ship-to*/
/*G035*/              so_fr_list   = cm_mstr.cm_fr_list
/*G035*/              so_fr_terms  = cm_mstr.cm_fr_terms
/*G035*/              so_fr_min_wt = cm_mstr.cm_fr_min_wt
/*K0DQ*/              so_userid    = global_userid
 *                    so_lang     = ad_lang.
 *
/*J034*/              {gprun.i ""gpsiver.p"" "(input so_site,
 *                                             input ?,
 *                                             output return_int)"}
 *
/*J034*/              if return_int = 0 then do:
/*J034*/                 {mfmsg02.i 2711 2 so_site} /*USER DOESN'T HAVE ACCESS*/
/*J034*/                                            /*TO DEFAULT SITE XXXX    */
/*J034*/                 so_site = "".
/*J034*/                 display so_site with frame b.
/*J034*/              end.
 *
/*H184*/              /* GET DEFAULT TERMS INTEREST FOR ORDER */
/*H184*/              socrt_int = 0.
/*H184*/              if so_cr_terms <> "" then do:
/*H184*/                 find ct_mstr where ct_code = so_cr_terms
/*H184*/                    no-lock no-error.
/*H184*/                 if available ct_mstr then socrt_int = ct_terms_int.
/*H184*/              end. /* SO_CR_TERMS <> "" */
 *
/*H008*/              /* SET NEW TAX DEFAULTS FOR GLOBAL TAX */
 *                    if {txnew.i} then do:
 *                       /* LOAD DEFAULT TAX CLASS & USAGE */
 *                       find ad_mstr where ad_addr = so_ship no-lock no-error.
/*H185*/                 if not available ad_mstr then
 *                        find ad_mstr where ad_addr = so_cust no-lock no-error.
 *                       if available ad_mstr then do:
/*H185*/                    so_taxable   = ad_taxable.
 *                          so_tax_usage = ad_tax_usage.
 *                          so_taxc = ad_taxc.
 *                       end.
/*H008*/              end.  /* SET TAX DEFAULTS */
 *
/*H086*************** display so_fr_list with frame b. */
 *
/*F297*************** /* MOVED INTO A LOOP FOR ALL FOUR SALESPERSONS. */
**                    so_slspsn[1] = cm_mstr.cm_slspsn[1].
**                    so_slspsn[2] = cm_mstr.cm_slspsn[2].
**                    find sp_mstr where sp_addr = cm_mstr.cm_slspsn[1]
**                       no-lock no-error.
**                    if available sp_mstr then so_comm_pct[1] = sp_comm_pct.
**                    if cm_mstr.cm_slspsn[2] <> "" then do:
**                       find sp_mstr where sp_addr = cm_mstr.cm_slspsn[2]
**                        no-lock no-error.
**                       if available sp_mstr then so_comm_pct[2] = sp_comm_pct.
**                    end.
**F297 END**********/
 *
 *
/*F297*/              /* SET DEFAULTS FOR ALL FOUR SALESPERSONS. */
/*F297*/              do counter = 1 to 4:
/*F297*/                  so_slspsn[counter] = cm_mstr.cm_slspsn[counter].
/*F297*/                  if cm_mstr.cm_slspsn[counter] <> "" then do:
/*F0C7*/                     find spd_det where spd_addr = so_slspsn[counter]
/*F0C7*/                              and spd_prod_ln = ""
/*F0C7*/                              and spd_part = ""
/*F0C7*/                              and spd_cust = so_cust no-lock no-error.
/*F0C7*/                     if available spd_det
/*F0C7*/                     then so_comm_pct[counter] = spd_comm_pct.
/*F0C7*/                     else do:
/*F297*/                        find sp_mstr where sp_addr
/*F297*/                           = cm_mstr.cm_slspsn[counter]
/*F297*/                           no-lock no-error.
/*F297*/                        if available sp_mstr then
/*F297*/                          so_comm_pct[counter] = sp_comm_pct.
/*F0C7*/                     end. /* ELSE IF NOT AVAILABLE SPD_DET */
/*F297*/                  end. /* IF CM_MSTR.CM_SLSPSN[CTR] <> "" */
/*F297*/              end. /* DO COUNTER = 1 TO 4 */
 *
/*F297*/              if so_slspsn[2] <> "" or
/*F297*/                 so_slspsn[3] <> "" or
/*F297*/                 so_slspsn[4] <> ""  then mult_slspsn = true.
/*F297*/              else mult_slspsn = false.
 *
/*H185** /*H008*/     if not {txnew.i} then
*********************    tax_in = cm_mstr.cm_tax_in. **/
 *
/*F458********** /* MOVED CAPTURE OF TAX RATES TO AFTER CAPTURE OF "TAX DATE" */
**                    /* IF TAXABLE GET TAX RATES */
**                    if not gl_vat then do:
**                       {gptax.i}
**                       sotax_trl = no.
**                       if available tax_mstr then do:
**                           if gl_can then so_pst_pct = tax_tax_pct[2].
**                          else do:  /*u.s. tax*/
**                             so_tax_pct[1] = tax_tax_pct[1].
**                             so_tax_pct[2] = tax_tax_pct[2].
**                             so_tax_pct[3] = tax_tax_pct[3].
**                             sotax_trl = tax_trl.
**                          end.
**                       end.
**                    end. /* IF NOT GL_VAT */
**F458 END *********/
 *
 *                    if bill_cm.cm_ar_acct <> "" then do:
 *                       so_ar_acct = bill_cm.cm_ar_acct.
 *                       so_ar_cc   = bill_cm.cm_ar_cc.
 *                    end.
 *                    else do:
 *                       so_ar_acct = gl_ar_acct.
 *                       so_ar_cc   = gl_ar_cc.
 *                    end.
 *                 end.  /* SET DEFAULTS IF NEW SO_MSTR */
 *
/*H185*/           if {txnew.i} then do:
 *                    /* LOAD DEFAULT TAX CLASS & USAGE */
 *                    find ad_mstr where ad_addr = so_ship no-lock no-error.
 *                    if not available ad_mstr then
 *                       find ad_mstr where ad_addr = so_cust no-lock no-error.
 *                    if available(ad_mstr) then
 *                       tax_in  = ad_tax_in.
 *                 end.  /* SET TAX DEFAULTS */
 *                 else
 *                    tax_in = cm_mstr.cm_tax_in.
/**H185** END **/
 *
 *                 if not new so_mstr and so_invoiced = yes then do:
 *                    {mfmsg.i 603 2}
 *                 /* INVOICE PRINTED BUT NOT POSTED, PRESS ENTER TO CONTINUE */
/*FQ08*/              if not batchrun then pause.
/*FQ08**************  pause.*/
 *                 end. /* IF NOT NEW SO_MSTR AND SO_INVOICED = YES */
 *
 *                 /* CHECK CREDIT LIMIT */
 *                 if bill_cm.cm_cr_limit < bill_cm.cm_balance then do:
 *              {mfmsg02.i  615 2 "bill_cm.cm_balance,""->>>>,>>>,>>9.99"" "}
 *              {mfmsg02.i  617 1 "bill_cm.cm_cr_limit,"->>>>,>>>,>>9.99"" "}
/*G692*/              if so_stat = "" and soc_cr_hold then do:
/*G692*/                 {mfmsg03.i 690 1 """Sales Order""" """" """" }
/*G692*/                 /* SALES ORDER PLACED ON CREDIT HOLD */
/*G692*/                 so_stat = "HD".
/*G692*/              end. /* IF SO_STAT = "" AND SOC_CR_HOLD */
 *                 end. /* IF CM_CR_LIMIT < CM_BALANCE */
 *
 *                 /* CHECK CREDIT HOLD */
 *                 if new so_mstr and bill_cm.cm_cr_hold  then do:
 *                    {mfmsg.i  614 2 }
 *                    so_stat = "HD".
 *                 end.
 *
/*G035*/           {sosomtdi.i} /* DISPLAY SO_ORD_DATE, ETC IN FRAME B */
 *
/*GB31******************************************************************
 *                 ALL UPDATES OF FRAME b MOVED TO sosomtp.p           *
 **********************************************************************/
/*GB31*/           /* UPDATE FRAME B - HEADER, TAX, SLSPSNS, FRT, ALLOCS */
/*GB31*/           undo_flag = true.
/*GB31*/           {gprun.i ""sosomtp.p""}
 *
/*GJ49*/           /* IF UNDO_FLAG THEN NEXT MAINLOOP. */
/*GI55*/           /* JUMP OUT IF SO WAS (SUCCESSFULLY) DELETED */
/*GI55*/           if not can-find(so_mstr where so_nbr = input so_nbr)
/*GI55*/              then next mainloop.
/*GJ49*/           if undo_flag then undo mainloop, next mainloop.
 *
 *                 if promise_date = ? then promise_date = so_due_date.
 *                 if so_req_date = ? then so_req_date = so_due_date.
 *
/*J042*/           if so_pricing_dt = ? then do:
 *                    if pic_so_date = "ord_date" then
 *                       so_pricing_dt = so_ord_date.
 *                    else
 *                    if pic_so_date = "req_date" then
 *                       so_pricing_dt = so_req_date.
 *                    else
 *                    if pic_so_date = "per_date" then
 *                       so_pricing_dt = promise_date.
 *                    else
 *                    if pic_so_date = "due_date" then
 *                       so_pricing_dt = so_due_date.
 *                    else
 *                       so_pricing_dt = today.
/*J042*/           end. /* IF SO_PRICING_DT = ? */
 *
 *              end. /* ORDER HEADER */
 *
 *              if rebook_lines then do:
 *                 {gprun.i ""sosomtrb.p""}
 *                 rebook_lines = false.
 *              end.
 *
 *              /* DETAIL - FIND LAST LINE */
 *              line = 0.
 *
/*J042*/        find last pih_hist where pih_doc_type = 1 and
 *                                       pih_nbr      = so_mstr.so_nbr
 *                                 use-index pih_nbr no-lock no-error.
 *              if available pih_hist then
 *                 line = pih_line.
/*J042*/        else do:
 *                 find last sod_det where sod_nbr = so_mstr.so_nbr
 *                                   use-index sod_nbrln no-lock no-error.
 *                 if available sod_det then line = sod_line.
 *              end. /* ELSE IF NOT AVAILABLE PIH_HIST */
 *
/*G457*/        /* Check for custom program set up in menu system */
/*G457*/        {fsmnp02.i ""sosomt.p"" 10}
 *
 *              /* COMMENTS */
 *              global_lang = so_mstr.so_lang.
 *              global_type = "".
 *              if socmmts = yes then do:
 *                 cmtindx = so_mstr.so_cmtindx.
 *                 global_ref = so_mstr.so_cust.
 *                 {gprun.i ""gpcmmt01.p"" "(input ""so_mstr"")"}
 *                 so_mstr.so_cmtindx = cmtindx.
 *              end. /* IF SOCMMTS = YES */
 *
 *              /* GET SHIP-TO NUMBER IF CREATING NEW SHIP-TO */
/*GH40**        if so_mstr.so_ship = ""                  then do: **/
/*GH40*/        if so_mstr.so_ship = "qadtemp" + mfguser then do:
/*FM85*/           find ad_mstr where ad_addr = so_mstr.so_ship exclusive-lock.
 *                 {mfactrl.i cmc_ctrl cmc_nbr ad_mstr ad_addr so_mstr.so_ship}
/*F678*/           ad_addr = so_mstr.so_ship.
/*F678*/           create ls_mstr.
/*F678*/           assign ls_type = "ship-to"
 *                        ls_addr = so_mstr.so_ship.
 *                 {mfmsg02.i 638 1 so_mstr.so_ship}
 *              end.
 *
 *           end. /* DO TRANSACTION #5 */
 *
/*J042*/     /*INITIALIZE QTY ACCUMULATION WORKFILES USED BY BEST PRICING*/
 *           {gprun.i ""gppiqty1.p"" "(input ""1"",
 *                                     input so_mstr.so_nbr,
 *                                     input yes,
 *                                     input yes)"}
 *
 *           hide frame sold_to no-pause.
 *           hide frame ship_to no-pause.
/*H086*/     hide frame b1 no-pause.
 *           hide frame b no-pause.
 *           hide frame a no-pause.
 *J053******** END OF SPLIT OUT TO SOSOMTA1.P */

/*F0R2*/     /* DURING LINE-ITEM ENTRY/EDIT, THE PRINTING OF PACKING LIST IS
/*F0R2*/        DISABLED */
/*F0R2*/     do transaction /*#6*/:
/*J053*/        find so_mstr where recid(so_mstr) = so_recno exclusive-lock.
/*F0R2*/        assign old_so_print_pl = so_print_pl
/*F0R2*/               so_print_pl     = false.
/*J053*/        find so_mstr where recid(so_mstr) = so_recno no-lock.
/*F0R2*/     end. /* DO TRANSACTION #6 */

             /* LINE ITEMS */
             {gprun.i ""sosomta.p""}

/*J042*/     /*TEST FOR AT END OF ORDER PRICING OR REPRICING REQUIREMENTS
               AND SUBSEQUENT PROCESSING OF SUCH*/

             if new_order and not line_pricing then do:
                /*ALL LINES NEED TO BE PRICED, ENTERED PRICES WILL BE RETAINED*/
                for each sod_det where sod_nbr = so_mstr.so_nbr no-lock:
                   sod_recno = recid(sod_det).
                   /*TRANSACTION HISTORY WILL BE REWRITTEN WITH REVISED PRICE*/
                   do transaction /*#6*/ on error undo, retry:
                      {gprun.i ""sosoprln.p"" "(input no,
                                                input yes,
                                                input yes,
                                                input yes,
                                                input yes,
                                                input no,
/*J12Q*/                                        input 0,
/*J12Q*/                                        input yes
/*J12Q*/                                        )"}
/*J12Q*                                         input 0)"}    */
/*J053*/              find so_mstr where recid(so_mstr) = so_recno
/*J053*/                 exclusive-lock.
                      so_priced_dt = today.
/*J053*/              find so_mstr where recid(so_mstr) = so_recno no-lock.
                   end. /* DO TRANSACTION #6 */
                end. /* FOR EACH SOD_DET WHERE..*/
             end. /* IF NEW_ORDER AND NOT LINE_PRICING */

             if reprice or new_order then do:
                price_changed = no.
            /*CHECK REPRICE TABLE TO DETERMINE WHICH LINES REQUIRE REPRICING*/
                for each wrep_wkfl where wrep_parent and
                                         wrep_rep
                                   no-lock:
                   find sod_det where sod_nbr  = so_mstr.so_nbr and
                                      sod_line = wrep_line
                                no-lock.
                   if available sod_det then do:
                      sod_recno = recid(sod_det).
                      /*REVERSE OLD TRANSACTION HISTORY*/
                      do with frame bi on error undo, retry:
                         form sod_det with frame bi width 80.
                         {mfoutnul.i &stream_name = "bi"}
                         display stream bi sod_det with frame bi.
                         output stream bi close.
                      end. /* DO WITH FRAME BI */
                      do transaction /*#7*/ on error undo, retry:
                         {gprun.i ""sosoprln.p"" "(input yes,
                                                   input yes,
                                                   input yes,
                                                   input yes,
                                                   input no,
                                                   input no,
/*J12Q*/                                           input 0,
/*J12Q*/                                           input yes
/*J12Q*/                                           )"}
/*J12Q*                                            input 0)"}     */
/*J053*/                 find so_mstr where recid(so_mstr) = so_recno
/*J053*/                    exclusive-lock.
                         so_priced_dt = today.
/*J053*/                 find so_mstr where recid(so_mstr) = so_recno no-lock.
                      end. /* DO TRANSACTION #7 */
                   end. /* IF AVAILABLE SOD_DET */
                end. /* FOR EACH WREP_WKFL */

                if /*pic_so_redisp and*/ price_changed then do:
                   {gprun.i ""sophdp.p""} /*RE-DISPLAY LINE ITEMS*/
                end. /* IF PRICE_CHANGED */
/*J042*/     end. /* IF REPRICE OR NEW_ORDER */

/*J042*/     /* SET CREDIT & FREIGHT TERMS FIELDS */
/*J042*/     do transaction /*#8*/ on error undo, retry:
/*J053*/        find so_mstr where recid(so_mstr) = so_recno exclusive-lock.
/*J12Q* /*J042*/        if current_cr_terms <> "" then        */
/*J12Q*/        if current_cr_terms <> "" then do:
/*J12Q*/           cr_terms_changed = yes.
/*J042*/           so_cr_terms = current_cr_terms.
/*J12Q*/        end.
/*J042*/        if current_fr_terms <> "" then
/*J042*/           so_fr_terms = current_fr_terms.
/*J053******* COMBINED TRANSACTIONS 8 & 9 -- REDUNDANT TO UNLOCK/RELOCK **
/*J042*/     end. /* DO TRANSACTION #8 */
/*F0R2*/     do transaction /*#9*/:
**J053  END **************************************************************/
/*F0R2*/        so_print_pl   =  old_so_print_pl.
/*J053*/        find so_mstr where recid(so_mstr) = so_recno no-lock.
/*F0R2*/     end. /* DO TRANSACTION #9 */

             view frame a.
             display so_ship with frame a.

             /* CHECK WHETHER TO SET CANADIAN OR VAT TAX DEFAULTS*/
             if gl_can then do:
                {gprun.i ""sosoctax.p""}
             end.
/*G454*/     else if gl_vat then do:
/*G454*/        {gprun.i ""sosovtax.p""}
/*G454*/     end.

/*G035*/     do transaction /*#10*/ on error undo, retry:
/*J053*/        find so_mstr where recid(so_mstr) = so_recno exclusive-lock.
                /* INIT TRAILER CODES FROM CONTROL FILE FOR NEW ORDERS ONLY */
/*FT06*/        {gpgettrl.i &hdr_file="so" &ctrl_file="soc"}
/*J053*/        find so_mstr where recid(so_mstr) = so_recno no-lock.

/*FT06** REPLACED FOLLOWING SECTION WITH gpgettrl.i **
**
** /*G035*/     /* TRAILER CODE DEFAULTS */
** /*G035*/     if new_order then do:
** /*G035*/        so_trl1_cd = soc_trl_ntax[1].
** /*G035*/        so_trl2_cd = soc_trl_ntax[2].
** /*G035*/        so_trl3_cd = soc_trl_ntax[3].
**
** /*G035*/        if so_taxable and (sotax_trl or gl_vat or gl_can
** /*H446*/        or {txnew.i})
** /*G035*/        then do:
** /*G035*/           if soc_trl_tax[1] <> "" then so_trl1_cd = soc_trl_tax[1].
** /*G035*/           if soc_trl_tax[2] <> "" then so_trl2_cd = soc_trl_tax[2].
** /*G035*/           if soc_trl_tax[3] <> "" then so_trl3_cd = soc_trl_tax[3].
** /*G035*/        end.
** /*G035*/     end. /* IF NEW_ORDER */
*FT06** END REPLACED **/

/*G035*/        /* CALCULATE FREIGHT */
/*G035*/        if calc_fr and so_fr_list <> "" and so_fr_terms <> "" then do:
/*G035*/           {gprun.i ""sofrcalc.p""}
/*H049************ if not freight_ok then do:                              */
/*H049************    {mfmsg.i 677 2}  Freight charge not added to trailer */
/*H049************ end.                                                    */
/*G035*/        end.
/*G035*/     end. /* DO TRANSACTION #10 */

             /* PROCESS TRAILER & TAXES */
/*G599*      cm_recno = recid(cm_mstr). */
/*J053*/     find bill_cm where bill_cm.cm_addr = so_bill no-lock.
/*G599*/     cm_recno = recid(bill_cm).
             {gprun.i ""sosomtc.p""}

/*J044*/     /*IF IMPORT-EXPORT FLAG IS SET TO YES, CALL THE IMPORT-EXPORT */
/*J044*/     /* DETAIL LINE MAINTENANCE PROGRAM FOR USER TO UPDATE ied_det */

/*J044*/    if not batchrun and impexp then do:
/*J044*/       impexp_edit = no.
/*J044*/       {mfmsg01.i 271 1 impexp_edit} /* VIEW/EDIT IMP-EXP DATA? */
/*J044*/       if impexp_edit then do:
/*J044*/          hide all no-pause.
/*J044*/          view frame dtitle.
/*J044*/          view frame a.
/*J044*/          upd_okay = no.
/*J044*/          {gprun.i ""iedmta.p"" "(input ""1"",
                                          input so_nbr,
                                          input-output upd_okay )"}
/*J044*/       end. /* IF IMPEXP_EDIT */
/*J044*/    end. /* IF NOT BATCHRUN AND IMPEXP */
            global_type = comment_type.

/*G0LS*/    /* ADDING BATCH CHECKING FOR SO PROCESSING */
/*G0LS*/    find first sod_det where sod_nbr = so_nbr
/*G0LS*/                       and   not sod_confirm no-lock no-error.
/*G0LS*/    if batch_job and available sod_det then do:
/*G0LS*/       {gprun.i ""sobatch.p"" "(input so_nbr,
                                        input-output batch_job,
                                        input-output dev,
                                        input-output batch_id)"
                                        }
/*G0LS*/    end. /* IF BATCH_JOB AND AVAILABLE SOD_DET */

         end. /* MAINLOOP:REPEAT: */

         status input.
.*J04C*/
