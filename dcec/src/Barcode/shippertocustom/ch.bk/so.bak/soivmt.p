/* GUI CONVERTED from soivmt.p (converter v1.75) Sat May  5 08:30:57 2001 */
/* soivmt.p - INVOICE MAINTENANCE                                            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                        */
/*V8:RunMode=Character,Windows                                               */
/* REVISION: 1.0      LAST MODIFIED: 08/31/86   BY: pml *17*                 */
/* REVISION: 6.0      LAST MODIFIED: 03/22/90   BY: ftb *D013*               */
/* REVISION: 6.0      LAST MODIFIED: 03/22/90   BY: ftb *D007*               */
/* REVISION: 6.0      LAST MODIFIED: 04/05/90   BY: ftb *D002*               */
/* REVISION: 6.0      LAST MODIFIED: 06/29/90   BY: WUG *D043*               */
/* REVISION: 6.0      LAST MODIFIED: 08/16/90   BY: MLB *D055*               */
/* REVISION: 6.0      LAST MODIFIED: 10/17/90   BY: pml *D109*               */
/* REVISION: 6.0      LAST MODIFIED: 12/11/90   BY: MLB *D238*               */
/* REVISION: 6.0      LAST MODIFIED: 01/02/91   BY: dld *D259*               */
/* REVISION: 6.0      LAST MODIFIED: 01/19/91   BY: dld *D316*               */
/* REVISION: 6.0      LAST MODIFIED: 02/13/91   BY: afs *D348*(rev only)     */
/* REVISION: 6.0      LAST MODIFIED: 03/08/91   BY: dld *D409*               */
/* REVISION: 6.0      LAST MODIFIED: 03/18/91   BY: MLB *D443*               */
/* REVISION: 6.0      LAST MODIFIED: 06/18/91   BY: emb *D710*               */
/* REVISION: 6.0      LAST MODIFIED: 07/07/91   BY: afs *D747*(rev only)     */
/* REVISION: 6.0      LAST MODIFIED: 07/08/91   BY: afs *D751*(rev only)     */
/* REVISION: 6.0      LAST MODIFIED: 07/13/91   BY: afs *D767*               */
/* REVISION: 6.0      LAST MODIFIED: 08/14/91   BY: MLV *D825*               */
/* REVISION: 7.0      LAST MODIFIED: 09/17/91   BY: MLV *F015*               */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*               */
/* REVISION: 7.0      LAST MODIFIED: 10/29/91   BY: MLV *F029*               */
/* REVISION: 6.0      LAST MODIFIED: 11/14/91   BY: afs *D928*               */
/* REVISION: 7.0      LAST MODIFIED: 11/16/91   BY: pml *F048*               */
/* REVISION: 7.0      LAST MODIFIED: 01/16/92   BY: afs *F038*               */
/* REVISION: 7.0      LAST MODIFIED: 01/17/92   BY: afs *F039*               */
/* REVISION: 7.0      LAST MODIFIED: 01/18/92   BY: afs *F042*               */
/* REVISION: 7.0      LAST MODIFIED: 02/13/92   BY: tjs *F191*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 03/02/92   BY: tjs *F247*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 03/18/92   BY: tjs *F273*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 03/22/92   BY: TMD *F263*               */
/* REVISION: 7.0      LAST MODIFIED: 03/25/92   BY: dld *F297*               */
/* REVISION: 7.0      LAST MODIFIED: 03/31/92   BY: afs *F338*               */
/* REVISION: 7.0      LAST MODIFIED: 04/01/92   BY: afs *F344*               */
/* REVISION: 7.0      LAST MODIFIED: 04/02/92   BY: afs *F253*               */
/* REVISION: 7.0      LAST MODIFIED: 04/02/92   BY: dld *F349*               */
/* REVISION: 7.0      LAST MODIFIED: 04/08/92   BY: tmd *F367*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: dld *F358*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 04/10/92   BY: afs *F356*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 04/22/92   BY: tjs *F421*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 04/30/92   BY: tjs *F463*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 05/06/92   BY: tjs *F470*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 05/11/92   BY: afs *F471*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 05/22/92   BY: tjs *F444*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 06/05/92   BY: tjs *F504*               */
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: afs *F519*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 06/18/92   BY: tmd *F458*               */
/* REVISION: 7.0      LAST MODIFIED: 06/26/92   BY: afs *F676*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 06/26/92   BY: afs *F711*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 06/30/92   BY: tjs *F646*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 06/30/92   BY: tjs *F698*               */
/* REVISION: 7.0      LAST MODIFIED: 07/07/92   BY: tjs *F496*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 07/09/92   BY: tjs *F739*               */
/* REVISION: 7.0      LAST MODIFIED: 07/14/92   BY: tjs *F764*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 07/24/92   BY: tjs *F765*               */
/* REVISION: 7.0      LAST MODIFIED: 07/24/92   BY: tjs *F802*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 07/31/92   BY: tjs *F815*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 08/21/92   BY: afs *F862*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 08/24/92   BY: tjs *F859*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 08/24/92   BY: tjs *F835*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 09/04/92   BY: afs *G056*               */
/* REVISION: 7.3      LAST MODIFIED: 09/17/92   BY: tjs *G035*               */
/* REVISION: 7.3      LAST MODIFIED: 09/30/92   BY: tjs *G112*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 10/06/92   BY: tjs *G129*               */
/* REVISION: 7.3      LAST MODIFIED: 10/21/92   BY: afs *G219*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247*               */
/* REVISION: 7.3      LAST MODIFIED: 11/05/92   BY: afs *G244*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 11/16/92   BY: tjs *G318*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 01/04/92   BY: tjs *G456*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 12/01/92   BY: mpp *G484*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 01/07/93   BY: tjs *G507*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 01/13/93   BY: tjs *G530*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 01/15/93   BY: afs *G501*               */
/* REVISION: 7.3      LAST MODIFIED: 01/21/93   BY: tjs *G579*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 01/26/93   BY: bcm *G429*               */
/* REVISION: 7.3      LAST MODIFIED: 02/01/93   BY: tjs *G588*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 02/10/93   BY: bcm *G416*               */
/* REVISION: 7.3      LAST MODIFIED: 02/18/93   BY: afs *G692*               */
/* REVISION: 7.3      LAST MODIFIED: 02/25/93   BY: sas *G457*               */
/* REVISION: 7.3      LAST MODIFIED: 03/16/93   BY: bcm *G823*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 03/23/93   BY: tjs *G858*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 04/05/93   BY: bcm *G889*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 04/15/93   BY: tjs *G948*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 04/20/93   BY: afs *G970*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 05/20/93   BY: kgs *GA92*               */
/* REVISION: 7.3      LAST MODIFIED: 05/20/93   BY: kgs *GB18*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 05/20/93   BY: kgs *GA60*               */
/* REVISION: 7.3      LAST MODIFIED: 05/28/93   BY: kgs *GB31*               */
/* REVISION: 7.3      LAST MODIFIED: 06/14/93   BY: afs *GC26*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 06/18/93   BY: bcm *GC50*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 06/22/93   by: cdt *GC58*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 07/01/93   by: cdt *GC90*(rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 07/09/93   by: bcm *GA70*(rev only)     */
/* REVISION  7.4      LAST MODIFIED  06/07/93   BY: skk *H002*(soivtrl2)     */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*               */
/* REVISION: 7.4      LAST MODIFIED: 10/04/93   BY: dpm *H075*(rev only)     */
/* REVISION: 7.4      LAST MODIFIED: 09/27/93   BY: cdt *H086*               */
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: bcm *H185*               */
/* REVISION: 7.4      LAST MODIFIED: 10/27/93   BY: dpm *H067*(rev only)     */
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184*               */
/* REVISION: 7.4      LAST MODIFIED: 11/22/93   BY: afs *H238*(rev only)     */
/* REVISION: 7.4      LAST MODIFIED: 01/28/94   BY: afs *GI55*               */
/* REVISION: 7.4      LAST MODIFIED: 02/24/94   BY: cdt *H282*               */
/* REVISION: 7.4      LAST MODIFIED: 04/21/94   BY: dpm *GJ49*               */
/* REVISION: 7.4      LAST MODIFIED: 05/17/94   BY: dpm *FN83*               */
/* REVISION: 7.4      LAST MODIFIED: 05/23/94   BY: afs *FM85*               */
/* REVISION: 7.4      LAST MODIFIED: 05/26/94   BY: afs *GH40*               */
/* REVISION: 7.4      LAST MODIFIED: 10/10/94   BY: ljm *GN23*               */
/* REVISION: 7.4      LAST MODIFIED: 10/21/94   BY: rmh *FQ08*               */
/*                                   10/29/94   BY: bcm *FT06*               */
/* REVISION: 8.5      LAST MODIFIED: 12/03/94   BY: mwd *J034*               */
/* REVISION: 7.4      LAST MODIFIED: 01/12/95   BY: ais *F0C7*               */
/* REVISION: 8.5      LAST MODIFIED: 02/10/95   BY: dpm *J044*               */
/* REVISION: 7.4      LAST MODIFIED: 02/15/95   BY: rxm *G0F4*               */
/* REVISION: 7.4      LAST MODIFIED: 04/06/95   BY: rxm *G0K8*               */
/* REVISION: 8.5      LAST MODIFIED: 04/11/95   BY: DAH *J042*               */
/* REVISION: 8.5      LAST MODIFIED: 07/14/95   BY: taf *J053*               */
/* REVISION: 7.4      LAST MODIFIED: 02/05/96   BY: ais *G0NX*               */
/* REVISION: 8.5      LAST MODIFIED: 03/12/96   BY: GWM *J0F8*               */
/* REVISION: 8.5      LAST MODIFIED: 04/10/96   BY: DAH *J0HR*               */
/* REVISION: 8.5      LAST MODIFIED: 04/17/96   BY: *J04C* Sue Poland        */
/* REVISION: 8.5      LAST MODIFIED: 04/17/96   BY: *J04C* Markus Barone     */
/* REVISION: 8.5      LAST MODIFIED: 04/29/96   BY: *J0KJ* Dennis Hensen     */
/* REVISION: 8.5      LAST MODIFIED: 07/02/96   BY: *J0WF* Sue Poland        */
/* REVISION: 8.5      LAST MODIFIED: 08/01/96   BY: *J0ZZ* T. Farnsworth     */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: aal *K001*               */
/* REVISION: 8.5      LAST MODIFIED: 08/02/96   BY: *J12Q* Andy Wasilczuk    */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Elke Van Maele    */
/* REVISION: 8.6      LAST MODIFIED: 03/12/97   BY: *K07K* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 05/02/97   BY: *J1QH* Ajit Deodhar      */
/* REVISION: 8.6      LAST MODIFIED: 06/03/97   BY: *K0DQ* Taek-Soo Chang    */
/* REVISION: 8.6      LAST MODIFIED: 08/06/97   BY: *J1YG* Seema Varma       */
/* REVISION: 8.6      LAST MODIFIED: 08/27/97   BY: *K0HN* Jean Miller       */
/* REVISION: 8.6      LAST MODIFIED: 11/18/97   BY: *J25B* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 11/18/97   BY: *K1BG* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 12/16/97   BY: *H1HF* Niranjan R.       */
/* REVISION: 8.6      LAST MODIFIED: 01/16/98   BY: *J25N* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 01/26/98   BY: *J29R* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 01/31/98   BY: *J2D7* Niranjan R.       */
/* REVISION: 8.6      LAST MODIFIED: 01/31/98   BY: *J2BC* Aruna Patil       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 04/27/98   BY: *L00L* Adam Harris       */
/* REVISION: 8.6E     LAST MODIFIED: 05/06/98   BY: *J2DD* Kawal Batra       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* REVISION: 8.6E     LAST MODIFIED: 06/05/98   BY: *L01M* Jean Miller       */
/* REVISION: 8.6E     LAST MODIFIED: 06/24/98   BY: *L01G* R. McCarthy       */
/* REVISION: 8.6E     LAST MODIFIED: 07/09/98   BY: *J2Q9* Niranjan R.       */
/* Old ECO marker removed, but no ECO header exists *GM05*                   */
/* REVISION: 8.6E     LAST MODIFIED: 07/01/98   BY: *L024* Sami Kureishy     */
/* REVISION: 9.0      LAST MODIFIED: 11/17/98   BY: *H1LN* Poonam Bahl       */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* Sandy Brown       */
/* REVISION: 9.0      LAST MODIFIED: 12/15/98   BY: *J34F* Vijaya Pakala     */
/* REVISION: 9.0      LAST MODIFIED: 12/16/98   BY: *J2ZM* Reetu Kapoor      */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 07/09/99   BY: *J3J0* G.Latha           */
/* REVISION: 9.0      LAST MODIFIED: 06/14/00   BY: *L0Y4* Santosh Rao       */
/* REVISION: 9.0      LAST MODIFIED: 10/03/00   BY: *L14Q* Abhijeet Thakur   */
/* REVISION: 9.0      LAST MODIFIED: 11/19/00   BY: *M0WC* Rajesh Thomas     */
/* REVISION: 9.0      LAST MODIFIED: 11/30/00   BY: *L15Z* Veena Lad         */
/* REVISION: 9.0      LAST MODIFIED: 12/18/00   BY: *M0TZ* Veena Lad         */
/* REVISION: 9.0      LAST MODIFIED: 04/24/01   BY: *M11Z* Jean Miller       */

         /* DISPLAY TITLE */
         {mfdtitle.i "0+ "}  /*L00L*/

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE soivmt_p_1 "重新定价"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmt_p_2 "服务发票"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmt_p_3 "服务工程师订单"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmt_p_4 "服务合同"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmt_p_5 "项目定价"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmt_p_6 "承诺日期"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmt_p_7 "说明"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmt_p_8 "显示重量"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmt_p_9 "计算运费"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmt_p_10 " 货物发往 "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmt_p_11 " 销售至 "
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */

         {gldydef.i new}
         {gldynrm.i new}

/*L00L*/ {etvar.i &new="new"}
/*L00L*/ {etdcrvar.i "new"}
/*L00L*/ {etrpvar.i &new="new"}

         define new shared variable rndmthd like rnd_rnd_mthd.
         define new shared variable oldcurr like so_curr.
         define new shared variable line like sod_line.
         define new shared variable del-yn like mfc_logical.
         define new shared variable qty_req like in_qty_req.
         define new shared variable qty_all like in_qty_all.
         define new shared variable prev_due like sod_due_date.
         define new shared variable prev_qty_ord like sod_qty_ord.
         define new shared variable trnbr like tr_trnbr.
         define new shared variable qty as decimal.
         define new shared variable part as character format "x(18)".
         define new shared variable eff_date as date.
         define new shared variable all_days like soc_all_days.
         define new shared variable all_avail like soc_all_avl.
         define new shared variable ln_fmt like soc_ln_fmt.
         define new shared variable ref like glt_det.glt_ref.
         define new shared variable so_recno as recid.
         define new shared variable comp like ps_comp.
         define new shared variable trlot like tr_lot.
         define new shared variable cmtindx like cmt_indx.
         define variable yn like mfc_logical initial yes.
         define new shared variable sonbr like so_nbr.
         define buffer somstr for so_mstr.
         define new shared variable socmmts like soc_hcmmts label {&soivmt_p_7}.
         define variable trqty like tr_qty_chg.
         define variable qty_left like tr_qty_chg.
         define new shared variable promise_date as date label {&soivmt_p_6}.
         define new shared variable base_amt like ar_amt.
         define variable comment_type like so_lang.
         define variable sotrnbr like so_nbr.
         define variable sotrcust like so_cust.
         define new shared variable cm_recno as recid.
         define new shared variable new_order like mfc_logical initial no.
         define new shared variable sotax_trl like tax_trl.
         define new shared variable tax_in like cm_tax_in.
/*L024*  define new shared variable exch_rate like exd_rate. */
/*L024*/ define new shared variable exch_rate like exr_rate.
/*L024* *L00Y* define new shared variable exch_rate2 like exd_rate. */
/*L024*/ define new shared variable exch_rate2 like exr_rate2.
/*L00Y*/ define new shared variable exch_ratetype like exr_ratetype.
/*L00Y*/ define new shared variable exch_exru_seq like exru_seq.
         define new shared variable so_db like dc_name.
         define new shared variable inv_db like dc_name.
         define new shared variable avail_calc as integer.
         define buffer bill_cm for cm_mstr.
         define new shared variable mult_slspsn like mfc_logical no-undo.
         define variable counter as integer no-undo.
         define variable sort as character format "x(28)" extent 4 no-undo.
         define variable keylist as character
          initial "RETURN,TAB,BACK-TAB,GO,13,9,509,245,513,301,248" no-undo.
         define new shared variable tax_recno as recid.
         define new shared variable ad_recno as recid.
         define new shared variable ship2_addr like so_ship.
         define new shared variable ship2_pst_id like cm_pst_id.
         define new shared variable ship2_lang like cm_lang.
         define new shared variable ship2_ref like cm_addr.
         define new shared variable undo_taxc like mfc_logical.
         define new shared frame a.
         define new shared frame sold_to.
         define new shared frame ship_to.
         define new shared variable undo_cust like mfc_logical.
         define new shared variable rebook_lines like mfc_logical no-undo.
         define new shared variable so_mstr_recid as recid.
         define new shared variable freight_ok like mfc_logical initial yes.
         define new shared variable old_ft_type like ft_type.
         define new shared variable calc_fr like mfc_logical
            label {&soivmt_p_9}.
         define variable old_fr_terms like so_fr_terms.
         define new shared variable old_um like fr_um.
         define new shared variable undo_soivmtb like mfc_logical.
         define new shared variable undo_flag like mfc_logical.
         define new shared frame b.
         define new shared variable disp_fr like mfc_logical
            label {&soivmt_p_8}.
         define new shared frame b1.
         define new shared variable soc_pc_line like mfc_logical initial yes.
         define new shared variable socrt_int like sod_crt_int.
         define            variable msgref as character format "x(20)".
         define new shared variable impexp like mfc_logical no-undo.
         define            variable impexp_edit like mfc_logical no-undo.
         define            variable upd_okay    like mfc_logical no-undo.
         define new shared variable picust like cm_addr.
         define new shared variable price_changed like mfc_logical.
         define new shared variable reprice like mfc_logical
                                            label {&soivmt_p_1} initial no.
         define            variable in_batch_proces as logical.
         define new shared variable balance_fmt as character.
         define new shared variable limit_fmt as character.
         define new shared variable prepaid_fmt as character no-undo.
         define variable prepaid_old as character no-undo.
         define new shared frame sotot.
         define new shared variable line_pricing like pic_so_linpri
                                                 label {&soivmt_p_5}.
         define new shared variable l_edittax    like mfc_logical
                                                      initial no no-undo.
/*M11Z* /*L0Y4*/ define new shared variable prev-ship-to like so_ship no-undo. */

         define            variable l_old_shipto like  so_ship no-undo.
         define            variable l_undo_shipto like mfc_logical no-undo.
/*H1LN*/ define            variable l_retrobill   like mfc_logical no-undo.
/*M11Z*/ define            variable emt-bu-lvl    like global_part no-undo.
/*M11Z*/ define            variable save_part     like global_part no-undo.

/*J2ZM*/    define new shared frame ship_to1.
/*J2ZM*/    define new shared frame ship_to2.

         define new shared stream bi.
         define new shared frame bi.

         {pppivar.i "new"}  /* Shared pricing variables */
         {pppiwqty.i "new"} /* Workfile for accum qty for pricing routines */

         {gptxcdec.i}    /* DECLARATIONS FOR gptxcval.i */

         /* DUE TO THE SHARED USE OF SOSOMTCM.P WITH SALES ORDER MNT */
         {sobtbvar.i "new"} /* BACK TO BACK SHARED WORKFILES AND VARIABLES */

/*L00L*  {mfsotrla.i "NEW"}  */
/*L00L*/ {etsotrla.i "NEW"}
         {soivmt01.i}

/*M017*/ /* TEMP TABLE DEFINITIONS FOR APM/API */
/*M017*/ {ifttcmdr.i "new"}
/*M017*/ {ifttcmdv.i "new"}

         if daybooks-in-use then
            {gprun.i ""nrm.p"" "persistent set h-nrm"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*L01G **** MOVED TO INTERNAL PROCEDURE p-get-formats
 *       /* ASSIGN ORIGINAL FORMAT TO _OLD VARIABLES */
 *       assign
 *          nontax_old = nontaxable_amt:format
 *          taxable_old = taxable_amt:format
 *          line_tot_old = line_total:format
 *          line_pst_old = line_pst:format
 *          disc_old     = disc_amt:format
 *          trl_amt_old = so_trl1_amt:format
 *          tax_amt_old = tax_amt:format
 *          tot_pst_old = total_pst:format
 *          tax_old     = tax[1]:format
 *          amt_old     = amt[1]:format
 *          ord_amt_old = ord_amt:format
 *          prepaid_old = so_prepaid:format.
 *
 *       /* SET LIMIT_FMT AND BALANCE_FMT FOR USE IN MFMSG02.I */
 *       assign
 *          oldcurr = ""
 *          balance_fmt = "->>>>,>>>,>>9.99"
 *          limit_fmt = "->>>>,>>>,>>9.99".
 *
 *       /* SET LIMIT_FMT ACCORDING TO BASE CURR ROUND METHOD*/
 *       {gprun.i ""gpcurfmt.p"" "(input-output limit_fmt,
 *                                 input gl_rnd_mthd)"}
 *       /* SET BALANCE_FMT ACCORDING TO BASE CURR ROUND METHOD*/
 *       {gprun.i ""gpcurfmt.p"" "(input-output balance_fmt,
 *                                 input gl_rnd_mthd)"}
 *L01G **** END SECTION MOVED TO INTERNAL PROCEDURE p-get-formats */

/*L01G*/ run p-get-formats.

/*H1LN*/ if execname = "rcrbrp01.p" then
/*H1LN*/    l_retrobill = yes.

         /* FORM DEFINITION FOR HIDDEN FRAME BI */
         {sobifrm.i}

         FORM /*GUI*/  sod_det with frame bi width 80 THREE-D /*GUI*/.


/*J2DD** SECTION MOVED TO INTERNAL PROCEDURE **
 *       do transaction on error undo, retry:
 *          find first soc_ctrl no-lock no-error.
 *          if not available soc_ctrl then create soc_ctrl.
 *          assign
 *             ln_fmt = soc_ln_fmt
 *             comment_type = global_type.
 *       end.
 *
 *       do transaction on error undo, retry:
 *          /* SET UP PRICING BY LINE VALUES */
 *          find first mfc_ctrl where mfc_field = "soc_pc_line"
 *          /* exclusive  no-error. */
 *          no-lock no-error.
 *          if available mfc_ctrl then do:
 *             soc_pc_line = mfc_logical.
 *          end.
 *       end.
 *
 *       if soc_all then do:
 *          if soc_on_ord then avail_calc = 2.
 *                        else avail_calc = 1.
 *       end.
 *       else if soc_req then do:
 *          if soc_on_ord then avail_calc = 4.
 *                        else avail_calc = 3.
 *       end.
 **J2DD** END OF SECTION MOVED **/

/*J2DD*/ run new-proc-j2dd in THIS-PROCEDURE.

         do transaction on error undo, retry:
            find first pic_ctrl no-lock no-error.
            if not available pic_ctrl then
               create pic_ctrl.
         end.

         so_db = global_db.

         /* INITIALIZING SR_WKFL */

         for each sr_wkfl where sr_userid = mfguser exclusive-lock:
            delete sr_wkfl.
         end. /* FOR EACH SR_WKFL WHERE SR_USERID = MFGUSER */

         mainloop:
         repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

            hide all no-pause.

            do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


               find first gl_ctrl no-lock.
               find first soc_ctrl no-lock no-error.
               socmmts = soc_hcmmts. /* Set default comments */

               /* DISPLAY SELECTION FORM */

               {soivmt02.i}  /* Definitions for shared frames a & b & b1 */

               {mfadform.i "sold_to" 1 {&soivmt_p_11}}
               {mfadform.i "ship_to" 41 {&soivmt_p_10}}
/*J2ZM*/       {mfadform.i "ship_to1" 41 {&soivmt_p_10}}
/*J2ZM*/       {mfadform.i "ship_to2" 41 {&soivmt_p_10}}

               /*GUI: view frame dtitle. */
IF global-tool-bar AND global-tool-bar-handle ne ? THEN
  view global-tool-bar-handle. /*GUI*/

               view frame a.
               view frame sold_to.
               view frame ship_to.
               view frame b.

               prompt-for so_mstr.so_nbr with frame a editing:

                  /* FIND NEXT/PREVIOUS  RECORD */
                  {mfnp.i so_mstr so_nbr so_nbr so_nbr so_nbr so_nbr}

                  if keyfunction(lastkey) = "RECALL":U or lastkey = 307
                  then
                     display sonbr @ so_nbr with frame a.

                  if recno <> ? then do:
                     {mfaddisp.i so_cust sold_to}
                     {mfaddisp.i so_ship ship_to}
                     display
                        so_nbr
                        so_cust
                        so_bill
                        so_ship
                     with frame a.
                     find first sod_det where sod_nbr = so_nbr no-lock no-error.
                     if available sod_det and sod_per_date <> ?
                     then
                        promise_date = sod_per_date.
                     else
                        promise_date = ?.

                     if so_slspsn[2] <> "" or
                        so_slspsn[3] <> "" or
                        so_slspsn[4] <> ""
                     then
                        mult_slspsn = true.
                     else
                        mult_slspsn = false.
                     if not new_order then socrt_int = so__qad02.
/*L00L*              {soivmtdi.i} /* display so_ord_date, etc in frame b */ */
/*L00L*/             run p-disp-frameb in THIS-PROCEDURE.
                  end. /* if recno <> ? then do */

               end. /* prompt-for with editing */

               if input so_nbr = "" then do:
                  /* Get next sales order number with prefix */
                  {mfnctrlc.i soc_ctrl soc_so_pre soc_so so_mstr so_nbr sonbr}
               end.
               else
                  sonbr = input so_nbr.

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do transaction */

            do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


               old_ft_type = "".
               find so_mstr where so_nbr = sonbr exclusive-lock no-error.

               if not available so_mstr then do:

                  find first soc_ctrl no-lock no-error.
                  clear frame sold_to.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame sold_to = F-sold_to-title.
                  clear frame ship_to.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame ship_to = F-ship_to-title.
                  clear frame b.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
                  {mfmsg.i 1 1} /* ADDING NEW RECORD */

                  create so_mstr.
                  assign
                     new_order    = yes
                     so_nbr       = sonbr
                     so_ord_date  = today
                     so_due       = today
                     so_ship_date = today
/*L15Z*/             /* READY TO INVOICE FLAG SHOULD BE SET   */
/*L15Z*/             /* TO NO INITIALLY WHEN ORDER IS CREATED */
/*L15Z**             so_to_inv    = yes */
/*L15Z*/             so_to_inv    = no
                     so_conf_date = today
                     so_print_pl  = no
                     socmmts      = soc_hcmmts
                     so_fob       = soc_fob
                     so_userid    = global_userid.

               end. /* if not available so_mstr */

               else do:

                  /* Check for batch shipment record */
                  in_batch_proces = no.
                  {sosrchk.i so_nbr in_batch_proces}
                  if in_batch_proces
                  then
                     undo mainloop, retry mainloop.

                  /* I.E. IF AVAIL SO_MSTR */
                  if so_conf_date = ? then do:
                     {mfmsg.i 621 2} /* WARNING: SALES ORDER NOT CONFIRMED */
                  end.

                  /* SO'S AND RMA'S ARE UPDATEABLE IN PENDING INV. MAINT., */
                  /* ALTHOUGH THE USER WILL BE SOMEWHAT LIMITED AS TO WHAT */
                  /* HE CAN SEE/MAINTAIN ON RMA'S.                         */
                  if so_fsm_type <> ""
                  and so_fsm_type <> "RMA":U
                  then do:
                     if so_fsm_type = "SC" then
                        msgref = {&soivmt_p_4}.
                     else if so_fsm_type = "SEO":U then
                        msgref = {&soivmt_p_3}.
                     else
                        msgref = {&soivmt_p_2}.
                     {mfmsg03.i 7326 3  msgref """" """"} /* THIS IS A #
                                                             CANNOT PROCESS */
                     if not batchrun then pause.
                     undo mainloop, retry mainloop.
                  end.

                  {mfmsg.i 10 1}  /* MODIFYING EXISTING RECORD */

                  {mfaddisp.i so_cust sold_to}
                  if not available ad_mstr then do:
                     hide message no-pause.
                     {mfmsg.i 3 2}  /* NOT A VALID CUSTOMER */
                  end.

                  {mfaddisp.i so_ship ship_to}
/*J2Q9*/ /* MOVED ASSIGNMENT BELOW TO AVOID ACTION SEGMENT ERROR */
/*J2Q9**          socmmts = so_cmtindx <> 0. */
                  assign
                     socrt_int = so__qad02
/*J2Q9*/             socmmts = so_cmtindx <> 0
                     new_order = no.

                  find ft_mstr where ft_terms = so_fr_terms no-lock no-error.
                  if available ft_mstr then old_ft_type = ft_type.

                  {gprun.i ""gpsiver.p""
                           "(input so_site, input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  if return_int = 0 then do:
                     display so_site with frame b.
                     {mfmsg.i 725 3} /* USER DOES NOT HAVE ACCESS TO SITE */
                     pause.
                     undo mainloop, retry mainloop.
                  end.

/*J2Q9*/          if so_sched then
/*J2Q9*/             /* ORDER WAS CREATED BY SCHEDULED ORDER MAINTENANCE */
/*J2Q9*/             {mfmsg.i 8210 2}

               end. /* else do (available so_mstr) */

               assign
                  recno = recid(so_mstr)
                  sotrnbr = so_nbr
                  sotrcust = so_cust.
               display
                  so_nbr
                  so_cust
                  so_bill
                  so_ship
               with frame a.

               if so_ship_date = ? then so_ship_date = today.
               find first sod_det where sod_nbr = so_nbr
                                    and sod_confirm
               no-lock no-error.
               if available sod_det and sod_per_date <> ? then
                  promise_date = sod_per_date.
               else
                  promise_date = ?.

               if so_slspsn[2] <> "" or
                  so_slspsn[3] <> "" or
                  so_slspsn[4] <> ""
               then
                  mult_slspsn = true.
               else
                  mult_slspsn = false.

/*L00L*        {soivmtdi.i} /* display so_ord_date, etc in frame b */ */
/*L00L*/       run p-disp-frameb in THIS-PROCEDURE.   /* display frame b */

               /* Get sold-to, bill-to, and ship-to customer */
               assign
                  so_recno = recid(so_mstr)
                  undo_cust = true.

               if so_fsm_type = "RMA":U then
               find rma_mstr where rma_nbr = so_nbr and
                                   rma_prefix = "C" no-lock.

               l_old_shipto = so_ship.

               /* SOSOMTCM.P INPUT PARMS INDICATE IF THIS IS RMA */
               {gprun.i ""sosomtcm.p""
                        "(input     (available rma_mstr),
                          input     if available rma_mstr then recid(rma_mstr)
                          else ?,
                          input     no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               if undo_cust then undo mainloop, retry.

               /* THIS BLOCK OF CODE EXECUTED WHEN SHIP-TO IS CHANGED IN GTM */
               if l_old_shipto <> "" and l_old_shipto <> so_ship and {txnew.i}
               then do:
                  l_undo_shipto = true.
                  /* IF SHIP-TO IS CHANGED */
                 run p-shipto-change in THIS-PROCEDURE
                   (INPUT so_recno,
                    INPUT-OUTPUT l_undo_shipto).
                 if l_undo_shipto then do:
                    display
                       l_old_shipto @ so_ship
                    with frame a.
                    undo mainloop, retry mainloop.
                 end. /* IF L_UNDO_SHIPTO */
               end.  /* IF SHIP-TO IS CHANGED IN GTM */

               find cm_mstr where cm_mstr.cm_addr = so_cust no-lock.
               find bill_cm where bill_cm.cm_addr = so_bill no-lock.
               find ad_mstr where ad_addr = so_bill no-lock.
               if ad_inv_mthd = "" then do:
                  find ad_mstr where ad_addr = so_ship  no-lock.
                  if ad_inv_mthd = "" then
                     find ad_mstr where ad_addr = so_cust  no-lock.
               end.

               /* SET CUSTOMER VARIABLE USED BY PRICING ROUTINE gppibx.p */
               picust = so_cust.
               if so_cust <> so_ship and
                  can-find(cm_mstr where cm_mstr.cm_addr = so_ship)
               then
                  picust = so_ship.

               order-header:
               do on error undo, retry with frame b:
/*GUI*/ if global-beam-me-up then undo, leave.


                  /* DO NOT ALLOW RMA'S TO BE DELETED IN PENDING INVOICE MAINT */
                  if so_fsm_type = " " then
                     ststatus = stline[2].
                  else
                     ststatus = stline[3].
                  status input ststatus.
                  del-yn = no.

                  /* SET DEFAULTS WHEN CREATING A NEW ORDER - */
                  /* USE SHIP-TO CUSTOMER INFO FOR DEFAULT IF */
                  /* AVAILABLE ELSE USE SOLD-TO INFO          */
                  if new so_mstr then do:
                     /* Moved code to internal procedure for
                       compile size reason */
                     run assign_new_so in THIS-PROCEDURE.
                  end.  /* new SO header initialization */

                  /* LOAD DEFAULT TAX CLASS & USAGE */
                  if {txnew.i} then do:
                     find ad_mstr where ad_addr = so_ship no-lock no-error.
                     if not available ad_mstr then
                        find ad_mstr where ad_addr = so_cust no-lock no-error.
                     if available(ad_mstr) then
                        tax_in  = ad_tax_in.
                  end.  /* set tax defaults */
                  else
                     tax_in = cm_mstr.cm_tax_in.

                  if not new so_mstr then socmmts = so_cmtindx <> 0.
                  if not new so_mstr and so_invoiced = yes then do:
                     {mfmsg.i 603 2} /* INVOICE PRINTED BUT NOT POSTED,
                                        PRESS ENTER TO CONTINUE.*/
                     if not batchrun then
                        pause.
                  end.

                  /* CHECK CREDIT LIMIT */
                  if bill_cm.cm_cr_limit < bill_cm.cm_balance then do:
                     /* CUSTOMER BALANCE */
                     {mfmsg02.i 615 2 "bill_cm.cm_balance,"balance_fmt" "}
                     /* CREDIT LIMIT */
                     {mfmsg02.i 617 1 "bill_cm.cm_cr_limit,"limit_fmt" "}
                  end.

                  /* CHECK CREDIT HOLD  */
                  if bill_cm.cm_cr_hold  then do:
                     {mfmsg.i  614 2 } /* CUSTOMER ON CREDIT HOLD */
                     if new so_mstr then so_stat = "HD".
                  end.

                  if not new_order then socrt_int = so__qad02.
/*L00L*           {soivmtdi.i} /* display so_ord_date, etc in frame b */ */
/*L00L*/          recno = recid(so_mstr).
/*L00L*/          run p-disp-frameb in THIS-PROCEDURE.   /* display frame b */

                  undo_flag = true.
                  {gprun.i ""soivmtp.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


                  /* Jump out if SO was (successfully) deleted */
                  if not can-find(so_mstr where so_nbr = input so_nbr)
                  then next mainloop.
                  if undo_flag then undo mainloop, next mainloop.

               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* order-header: do on error */

               cr_terms_changed = no.

               if (oldcurr <> so_curr) or (oldcurr = "") then do:
                  /* SET CURRENCY DEPENDENT FORMATS */
                  {socurfmt.i}
                  oldcurr = so_curr.
                  /* SET CURRENCY DEPENDENT FORMAT FOR PREPAID_FMT */
                  prepaid_fmt = prepaid_old.
                  {gprun.i ""gpcurfmt.p"" "(input-output prepaid_fmt,
                                            input rndmthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.

               if promise_date = ? then promise_date = so_mstr.so_due_date.
               if so_mstr.so_req_date = ? then
                  so_mstr.so_req_date = so_mstr.so_due_date.

               if so_fsm_type <> "" and so_pricing_dt = ? then
                  so_pricing_dt = so_ord_date.
               if so_pricing_dt    = ? then do:
                  if pic_so_date   = "ord_date" then
                     so_pricing_dt = so_ord_date.
                  else if pic_so_date   = "req_date" then
                     so_pricing_dt = so_req_date.
                  else if pic_so_date   = "per_date" then
                     so_pricing_dt = promise_date.
                  else if pic_so_date   = "due_date" then
                     so_pricing_dt = so_due_date.
                  else
                     so_pricing_dt = today.
               end.

               /* COMMENTS */
               assign
                  global_lang = so_mstr.so_lang
                  global_type = "".

/*M11Z*/       /* If EMT, determine the Comment Type */
/*M11Z*/       emt-bu-lvl = "".
/*M11Z*/        if soc_use_btb then do:
/*M11Z*/          if so_primary and not so_secondary then
/*M11Z*/             emt-bu-lvl = "PBU".
/*M11Z*/          else if so_primary and so_secondary then
/*M11Z*/             emt-bu-lvl = "MBU".
/*M11Z*/          else if so_secondary then
/*M11Z*/             emt-bu-lvl = "SBU".
/*M11Z*/       end.

               if socmmts = yes then do:
                  assign
                     cmtindx = so_mstr.so_cmtindx
                     global_ref = so_mstr.so_cust
/*M11Z*/             save_part  = global_part
/*M11Z*/             global_part = emt-bu-lvl.
                  {gprun.i ""gpcmmt01.p"" "(input ""so_mstr"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*M11Z*/          global_part = save_part.
                  so_mstr.so_cmtindx = cmtindx.
               end.

               /* Assign next automatic number for new ship-to customer */
               if so_mstr.so_ship = "QADTEMP":U + mfguser then do:
              run update-addr (input-output so_mstr.so_ship).           /*J34F*/
/*J34F** BEGIN DELETE **
 *         find ad_mstr where ad_addr = so_mstr.so_ship exclusive-lock.
 *          {mfactrl.i cmc_ctrl cmc_nbr ad_mstr ad_addr so_mstr.so_ship}
 *          ad_addr = so_mstr.so_ship.
 *          create ls_mstr.
 *          assign ad_addr = so_mstr.so_ship
 *                 ls_type = "ship-to"
 *                 ls_addr = so_mstr.so_ship.
 *          {mfmsg02.i 638 1 so_mstr.so_ship}
 *J34F** END DELETE **/
               end.

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* do transaction: SO Header updates */

            /* FIND LAST LINE */
            line = 0.

            for each sod_det where
                     sod_nbr = so_mstr.so_nbr by sod_line
            descending:
               line = sod_line.
               leave.
            end.

            /* INITIALIZE ACCUM QTY WORKFILES USED BY PRICING ROUTINES */
            {gprun.i ""gppiqty1.p"" "(""1"",
                                      so_mstr.so_nbr,
                                      yes,
                                      yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            hide frame sold_to no-pause.
            hide frame ship_to no-pause.
/*J2ZM*/    hide frame ship_to1 no-pause.
/*J2ZM*/    hide frame ship_to2 no-pause.
            hide frame b1 no-pause.
            hide frame b no-pause.
            hide frame a no-pause.

            /* LINE ITEMS */
            hide frame a.
            {gprun.i ""soivmta.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


            /* TEST FOR PRICING OR REPRICING REQUIREMENTS AND SUBSEQUENT */
            /* PROCESSING                                                */

/*H1LN*/    /* SKIPPING REPRICING AFTER LINE PROCESSING FOR RETROBILLED ITEMS */
/*H1LN*/    if not l_retrobill then
               {gprun.i ""sosoprc.p"" "(input so_recno,
                                        input reprice,
                                        input new_order,
                                        input line_pricing)" }
/*GUI*/ if global-beam-me-up then undo, leave.


            view frame a.
            display so_mstr.so_ship with frame a.

            /*OVERRIDE CANADIAN TAX DEFAULTS*/
            if gl_can then do:
               {gprun.i ""soivctax.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.
            else if gl_vat then do:
               {gprun.i ""soivvtax.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.

            do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

               {gpgettrl.i &hdr_file="so" &ctrl_file="soc"}

/*M0WC*/       if new_order
/*M0WC*/          and soc__qadl04
/*M0WC*/       then do:
/*M0WC*/          for first fr_mstr
/*M0WC*/             fields (fr_curr fr_list fr_site fr_trl_cd)
/*M0WC*/             where     fr_list = so_fr_list
/*M0WC*/                   and fr_site = so_site
/*M0WC*/                   and fr_curr = so_curr
/*M0WC*/             no-lock:
/*M0WC*/          end. /* FOR FIRST fr_mstr */

/*M0WC*/          if available fr_mstr
/*M0WC*/          then
/*M0WC*/             so_trl1_cd = fr_trl_cd.

/*M0WC*/       end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF new-order and ... */

               if current_cr_terms <> "" and current_cr_terms <> so_cr_terms
               then do:
                   assign
                      so_cr_terms = current_cr_terms
                      cr_terms_changed = yes.
               end.
/*M0TZ**       if current_fr_terms <> "" then */
/*M0TZ*/       if current_fr_terms <> ""
/*M0TZ*/          and so_fr_terms  =  ""
/*M0TZ*/       then
                  so_fr_terms = current_fr_terms.
               assign
                  current_cr_terms = ""
                  current_fr_terms = "".

               /* CALCULATE FREIGHT */
               if calc_fr and so_fr_terms = "" then do:
                  {mfmsg03.i 671 2 so_fr_terms """" """"} /* INVALID FRT TERMS */
               end. /* if calc_fr and so_fr_terms */

               if calc_fr and so_mstr.so_fr_terms <> ""
               then do:
                  so_mstr_recid = recid(so_mstr).
                  {gprun.i ""sofrcali.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.

/*L15Z*/       /* READY TO INVOICE FLAG SHOULD BE SET  */
/*L15Z*/       /* TO YES ONLY IF ORDER IS NOT INVOICED */
/*L15Z*/       if not so_invoiced
/*L15Z*/       then
/*L15Z*/          so_to_inv = yes.

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
   /* do transaction */

            /* TRAILER */
            cm_recno = recid(bill_cm).
            {gprun.i ""soivmtc.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


            /* IMPORT EXPORT FLAG IS SET TO YES CALL THE IMPORT EXPORT DETAIL */
            /* LINE MAINTENANCE PROGRAM FOR USER TO UPDATE ied_det            */

            if not batchrun and impexp then do:
               impexp_edit = no.
               {mfmsg01.i 271 1 impexp_edit} /* VIEW EDIT IMPORT EXPORT DATA ? */
               if impexp_edit then do:
                  upd_okay = no.
                  hide all no-pause .
                  /*GUI: view frame dtitle. */
IF global-tool-bar AND global-tool-bar-handle ne ? THEN
  view global-tool-bar-handle. /*GUI*/

                  view frame a.
                  {gprun.i ""iedmta.p"" "(input ""1"",
                                          input so_nbr,
                                          input-output upd_okay )" }
/*GUI*/ if global-beam-me-up then undo, leave.

               end.
            end.
            global_type = comment_type.

/*J3J0*/    release so_mstr.

         end.
         status input.

         if daybooks-in-use then delete procedure h-nrm no-error.

         /****************** INTERNAL PROCEDURES **********************/

/*L01G*/ procedure p-get-formats:
         /* -----------------------------------------------------------
          Purpose:     assigns formats of various amount fields to
                       variables for use with CDR.
          Parameters:  <none>
          Notes:       Moved out of main line of code to reduce compile
                       size
         -------------------------------------------------------------*/

         /* ASSIGN ORIGINAL FORMAT TO _OLD VARIABLES */
         assign
            nontax_old = nontaxable_amt:format in frame sotot
            taxable_old = taxable_amt:format in frame sotot
            line_tot_old = line_total:format in frame sotot
            line_pst_old = line_pst:format in frame cttrail
            disc_old     = disc_amt:format in frame sotot
            trl_amt_old = so_trl1_amt:format in frame sotot
            tax_amt_old = tax_amt:format in frame sotot
            tot_pst_old = total_pst:format in frame cttrail
            tax_old     = tax[1]:format in frame cttrail
            amt_old     = amt[1]:format in frame cttrail
            ord_amt_old = ord_amt:format in frame sotot
            prepaid_old = so_prepaid:format in frame d.

         /* SET LIMIT_FMT AND BALANCE_FMT FOR USE IN MFMSG02.I */
         assign
            oldcurr = ""
            balance_fmt = "->>>>,>>>,>>9.99"
            limit_fmt = "->>>>,>>>,>>9.99".

         /* SET LIMIT_FMT ACCORDING TO BASE CURR ROUND METHOD*/
         {gprun.i ""gpcurfmt.p"" "(input-output limit_fmt,
                                   input gl_ctrl.gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         /* SET BALANCE_FMT ACCORDING TO BASE CURR ROUND METHOD*/
         {gprun.i ""gpcurfmt.p"" "(input-output balance_fmt,
                                   input gl_ctrl.gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*L01G*/ end procedure.

         PROCEDURE assign_new_so:
         /* -----------------------------------------------------------
          Purpose:     When this is a new Sales Order, assigns all of
                       the so_mstr header information
          Parameters:  <none>
          Notes:       Moved out of main line of code to reduce compile
                       size
         -------------------------------------------------------------*/

         find first soc_ctrl no-lock.
         find current so_mstr.
         find cm_mstr where cm_mstr.cm_addr = so_cust no-lock.
         find bill_cm where bill_cm.cm_addr = so_bill no-lock.
         find ad_mstr where ad_addr = so_bill no-lock.

         if ad_inv_mthd = "" then do:
            find ad_mstr where ad_addr = so_ship  no-lock.
            if ad_inv_mthd = "" then
               find ad_mstr where ad_addr = so_cust  no-lock.
         end.

/*L14Q** if so_cust <> so_ship and                                */
/*L14Q** can-find(cm_mstr where cm_mstr.cm_addr = so_ship) then   */
/*L14Q**    find cm_mstr where cm_mstr.cm_addr = so_ship no-lock. */

/*L14Q*/ if so_cust <> so_ship
/*L14Q*/ then do:
/*L14Q*/    if can-find(cm_mstr where cm_mstr.cm_addr = so_ship)
/*L14Q*/    then do:
/*L14Q*/       for first cm_mstr
/*L14Q*/          fields(cm_addr cm_ar_acct cm_ar_cc cm_balance
/*L14Q*/                 cm_cr_hold cm_cr_limit cm_cr_terms cm_curr
/*L14Q*/                 cm_disc_pct cm_fix_pr cm_fr_list cm_fr_min_wt
/*L14Q*/                 cm_fr_terms cm_fst_id cm_lang cm_partial cm_pst
/*L14Q*/                 cm_rmks cm_shipvia cm_site cm_slspsn cm_taxable
/*L14Q*/                 cm_taxc cm_tax_in)
/*L14Q*/          where cm_mstr.cm_addr = so_ship no-lock:
/*L14Q*/       end. /* FOR FIRST cm_mstr */
/*L14Q*/       so_lang = cm_mstr.cm_lang.
/*L14Q*/    end. /* IF CAN-FIND */
/*L14Q*/    else
/*L14Q*/    do:
/*L14Q*/       for first ad_mstr
/*L14Q*/          fields(ad_addr ad_city ad_country ad_inv_mthd ad_lang
/*L14Q*/                 ad_line1 ad_line2 ad_name ad_pst_id ad_state
/*L14Q*/                 ad_taxable ad_taxc ad_tax_in ad_tax_usage ad_zip)
/*L14Q*/          where ad_addr = so_ship no-lock:
/*L14Q*/       end. /* FOR FIRST ad_mstr */
/*L14Q*/       so_lang = ad_lang.
/*L14Q*/    end. /* ELSE DO */
/*L14Q*/ end. /* IF so_cust <> so_ship */
/*L14Q*/ else
/*L14Q*/    so_lang = cm_mstr.cm_lang.

/*H1LN*/ /* SO_FIX_PR = YES FOR RETROBILLED ITEMS       */
/*H1LN*/ /* TO AVOID SALES ORDER REPRICING.             */
/*H1LN*/ /* NO CUSTOMER DISCOUNT FOR RETROBILLED ITEMS. */

         assign
            so_cr_terms = bill_cm.cm_cr_terms
            so_curr = bill_cm.cm_curr
/*H1LN**    so_fix_pr = cm_mstr.cm_fix_pr     */
/*H1LN*/    so_fix_pr = if not l_retrobill then cm_mstr.cm_fix_pr else yes
/*H1LN**    so_disc_pct = cm_mstr.cm_disc_pct */
/*H1LN*/    so_disc_pct = if not l_retrobill then cm_mstr.cm_disc_pct else 0
            so_shipvia = cm_mstr.cm_shipvia
            so_partial = cm_mstr.cm_partial
            so_rmks = cm_mstr.cm_rmks
            so_site = cm_mstr.cm_site
            so_taxable = cm_mstr.cm_taxable
            so_taxc = cm_mstr.cm_taxc
            so_pst = cm_mstr.cm_pst
            so_fst_id = cm_mstr.cm_fst_id
            so_pst_id = ad_pst_id
/*L14Q**    so_lang = ad_lang             */
            so_fr_list = cm_mstr.cm_fr_list
            so_fr_terms = cm_mstr.cm_fr_terms
            so_fr_min_wt = cm_mstr.cm_fr_min_wt
            so_inv_mthd = ad_inv_mthd
            socmmts = soc_hcmmts
            so_userid = global_userid.

         {gprun.i ""gpsiver.p""
          "(input so_site, input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         if return_int = 0 then do:
            {mfmsg02.i 2711 2 so_site} /* USER DOES NOT HAVE ACCESS
                                          TO DEFAULT SITE */
            so_site = "".
            display so_site with frame b.
         end.

         socrt_int = 0.

         if so_cr_terms <> "" then do:
            find ct_mstr where ct_code = so_cr_terms no-lock no-error.
            if available ct_mstr then socrt_int = ct_terms_int.
         end.

         if {txnew.i} then do:
            find ad_mstr where ad_addr = so_ship no-lock no-error.
            if not available ad_mstr then
               find ad_mstr where ad_addr = so_cust no-lock no-error.
            if available(ad_mstr) then do:
               assign
                  so_taxable = ad_taxable
                  so_tax_usage = ad_tax_usage
                  so_taxc = ad_taxc.
            end.
         end.

         do counter = 1 to 4:
            so_slspsn[counter] = cm_mstr.cm_slspsn[counter].

            if cm_mstr.cm_slspsn[counter] <> "" then do:

               find sp_mstr where sp_addr = cm_mstr.cm_slspsn[counter]
               no-lock no-error.

               find spd_det where
                    spd_addr = cm_mstr.cm_slspsn[counter] and
                    spd_prod_ln = "" and
                    spd_part = "" and
                    spd_cust = cm_mstr.cm_addr
               no-lock no-error.

               if available spd_det then
                  so_comm_pct[counter] = spd_comm_pct.
               else if available sp_mstr then
                  so_comm_pct[counter] = sp_comm_pct.

            end. /* if cm_mstr.cm_slspsn[counter] <> ""  */
         end. /* do counter  */

         if so_slspsn[2] <> "" or
         so_slspsn[3] <> "" or
         so_slspsn[4] <> "" then
            mult_slspsn = true.
         else
            mult_slspsn = false.

         if bill_cm.cm_ar_acct <> "" then do:
            assign
               so_ar_acct = bill_cm.cm_ar_acct
               so_ar_cc = bill_cm.cm_ar_cc.
         end.
         else do:
            find first gl_ctrl no-lock no-error.
            if not available gl_ctrl then
               create gl_ctrl.
            assign
               so_ar_acct = gl_ar_acct
               so_ar_cc = gl_ar_cc.
         end.

         END PROCEDURE. /* assign_new_so */


         PROCEDURE new-proc-j2dd:
         /* -----------------------------------------------------------
          Purpose:     Reads soc_ctrl and mfc_control and sets local
                       variables
          Parameters:  None
          Notes:       Moved out of main line of code to reduce compile
                       size, new procedure in /*J2DD*/
         -------------------------------------------------------------*/

         do transaction on error undo, retry:
            find first soc_ctrl no-lock no-error.
            if not available soc_ctrl then
               create soc_ctrl.
            assign
               ln_fmt = soc_ln_fmt
               comment_type = global_type.
         end.

         do transaction on error undo, retry:
            /* SET UP PRICING BY LINE VALUES */
            find first mfc_ctrl where mfc_field = "soc_pc_line"
            no-lock no-error.
            if available mfc_ctrl then do:
               soc_pc_line = mfc_logical.
            end.
         end.

         /* Determine and store the way qty avail to alloc is calculated */
         /* (The resulting setting will match the first field in sosopm.p */

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

         END PROCEDURE. /* new-proc-j2dd */


         PROCEDURE p-disp-frameb:
         /* -----------------------------------------------------------
          Purpose:     Displays information in frame b
          Parameters:  None
          Notes:       Moved out of main line of code to reduce compile
                       size, new procedure in /*L00L*/
         -------------------------------------------------------------*/

         find first soc_ctrl no-lock no-error.
/*L024*  find first so_mstr where recid(so_mstr) = recno exclusive-lock no-error. */

/*L01M*  {soivmtdi.i} */

/*L01M*/ /* THE FOLLOWING CODE WAS ADDED FROM soivmtdi.i */
         if new_order then
            socmmts = soc_hcmmts.
         else
/*L024*     socmmts = (so_cmtindx <> 0).  */
/*L024*/    socmmts = (so_mstr.so_cmtindx <> 0).

         display
            so_ord_date
            so_ship_date
            so_req_date
            so_pr_list
            so_curr
            so_lang
            promise_date
            so_site
            so_taxable
            so_taxc
            so_tax_date
            so_due_date
            so_channel
            so_fix_pr
            so_pricing_dt
            so_project
            so_cr_terms
            so_po
            socrt_int
            so_rmks
            reprice
            so_userid
         with frame b.
/*L01M*/ /* END OF ADDED CODE */

         END PROCEDURE.  /* p-disp-frameb */


         PROCEDURE p-shipto-change:
         /* -----------------------------------------------------------
          Purpose:     Check to see if valid to change ship-to and reassign
                       tax fields in so_mstr header record if valid
          Parameters:
             so_recno:   input parm   Contains recid of current SO
             l_undo_ship output parm  If no then don't change ship-tp
          Notes:
         -------------------------------------------------------------*/
         define input parameter so_recno as recid no-undo.
         define input-output parameter l_undo_shipto like mfc_logical no-undo.

         find so_mstr where recid(so_mstr) = so_recno exclusive-lock.

         /* SHIP-TO CANNOT BE CHANGED; QUANTITY TO INVOICE EXISTS */
         if l_old_shipto <> "" and
            l_old_shipto <> so_ship and
            {txnew.i}
         then do:
            if can-find(first sod_det where sod_nbr = so_nbr and
                        sod_qty_inv <> 0 )
            then do:
               l_undo_shipto = true.
               {mfmsg.i 2363 4} /* OUTSTANDING QTY TO INVOICE, SHIP-TO TAXES
                                   CANNOT BE UPDATED */
               if not batchrun then pause.
               leave.
            end. /* if can-find */
         end. /* if l_old_shipto */

         /* SHIP-TO CHANGED; UPDATE TAX DATA ON CONFIRMATION. PREVIOUS */
         /* HEADER TAX ENVIRONMENT BLANKED OUT FOR RECALCULATION LATER */

         l_edittax = no.
         if not batchrun and
            l_old_shipto <> "" and
            l_old_shipto <> so_ship and
            {txnew.i}
         then do:
            {mfmsg01.i 2351 1 l_edittax } /* SHIP-TO CHANGED; UPDATE TAX DATA? */
            if l_edittax then do:
               /* LOAD DEFAULT TAX CLASS & USAGE */
               find ad_mstr where ad_addr = so_ship no-lock no-error.
               if not available ad_mstr then
                  find ad_mstr where ad_addr = so_cust no-lock no-error.
               if available ad_mstr then do:
                  assign
                     so_taxable   = ad_taxable
                     so_tax_usage = ad_tax_usage
                     so_taxc = ad_taxc.
               end. /* if available ad_mstr */
               so_tax_env = "".
            end.  /* if l_edittax is true */
         end. /* if ship-to changed in GTM and not batchrun */

         l_undo_shipto = false.

         END PROCEDURE.  /* p-shipto-change */

/*J34F** ADDED INTERNAL PROCEDURE TO AVOID ACTION SEGMENT ERROR **/
procedure update-addr:
define input-output parameter ship_addr like so_ship no-undo.

find ad_mstr where ad_addr = ship_addr       exclusive-lock.
{mfactrl.i cmc_ctrl cmc_nbr ad_mstr ad_addr ship_addr}
 create ls_mstr.
 assign
        ad_addr = ship_addr
        ls_type = "ship-to"
        ls_addr = ship_addr.
 {mfmsg02.i 638 1 ship_addr}
end procedure.
/*J34F** END ADDED PROCEDURE **/
