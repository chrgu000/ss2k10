/* apvomt.p - AP VOUCHER MAINTENANCE                                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.56 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 1.0      LAST MODIFIED: 12/18/86   by: PML *A3*                  */
/* REVISION: 6.0      LAST MODIFIED: 04/19/91   by: MLV *D546*                */
/*                                   05/30/91   by: MLV *D665*                */
/*                                   06/04/91   by; MLV *D671*                */
/*                                   06/06/91   by: MLV *D674*                */
/* REVISION: 7.0      LAST MODIFIED: 07/26/91   by: MLV *F001*                */
/*                                   08/12/91   by: MLV *F002*                */
/*                                   09/13/91   by: MLV *F013*                */
/*                                   10/11/91   by: DGH *D892*                */
/*                                   10/16/91   by: MLV *F022*                */
/*                                   11/01/91   by: MLV *F031*                */
/*                                   11/12/91   by: MLV *F029*                */
/*                                   11/15/91   by: MLV *F037*                */
/*                                   01/10/92   by: MLV *F082*                */
/*                                   01/11/92   by: MLV *F083*                */
/*                                   01/21/92   by: MLV *F090*                */
/*                                   01/24/92   by: MLV *F094*                */
/*                                   02/04/92   by: MLV *F149*                */
/*                                   02/05/92   by: TMD *F169*                */
/*                                   02/05/92   by: MLV *F164*                */
/*                                   02/26/92   by: MLV *F238*                */
/*                                   03/22/92   by: TMD *F303*                */
/*                                   04/13/92   by: MLV *F365*                */
/*                                   05/15/92   by: MLV *F499*                */
/*                                   06/19/92   by: TMD *F458*   (rev only)   */
/*                                   06/24/92   by: JJS *F681*   (rev only)   */
/*                                   07/02/92   by: MLV *F725*                */
/*                                   07/23/92   by: MLV *F807*                */
/* REVISION: 7.3      LAST MODIFIED: 08/24/92   by: MPP *G004*                */
/*                                   09/03/92   by: MLV *G042*                */
/*                                   09/09/92   by: MLV *G053*                */
/*                                   10/14/92   by: MPP *G186**  (rev only)   */
/*                                   11/30/92   by: bcm *G369*                */
/*                                   12/02/92   by: bcm *G381*   (rev only)   */
/*                                   01/04/93   by: jms *G495*                */
/*                                   12/14/92   by: bcm *G418*                */
/*                                   01/06/93   by: mpp *G475*                */
/*                                   01/12/93   by: jms *G537*                */
/*                                   02/24/93   by: jms *G698*                */
/*                                   02/22/93   by: bcm *G717*                */
/*                                   02/24/93   by: jms *G742*   (rev only)   */
/*                                   03/01/93   by: jms *G762*   (rev only)   */
/*                                   03/12/93   by: jms *G806*                */
/*                                   03/17/93   by: jjs *G842*                */
/*                                   03/22/93   by: jms *G854*                */
/*                                   03/22/93   by: jms *G860*   (rev only)   */
/*                                   03/30/93   by: bcm *G887*   (rev only)   */
/*                                   03/31/93   by: bcm *G889**  (rev only)   */
/*                                   04/09/93   by: bcm *G927**               */
/*                                   04/15/93   by: bcm *G954**  (rev only)   */
/*                                   04/15/93   by: bcm *G957**  (rev only)   */
/*                                   04/17/93   by: jms *G965*   (rev only)   */
/*                                   04/19/93   by: jms *G978*   (rev only)   */
/*                                   04/23/93   by: jjs *GA30*   (rev only)   */
/*                                   04/30/93   by: bcm *GA58*                */
/*                                   05/15/93   by: pma *GB00*   (rev only)   */
/*                                   06/03/93   by: pcd *GB66*                */
/*                                   06/08/93   by: jms *GB87*   (rev only)   */
/*                                   06/11/93   by: jms *GC14*   (rev only)   */
/*                                   06/15/93   by: pcd *GC27*   (rev only)   */
/*                                   06/28/93   by: wep *GC75*   (rev only)   */
/*                                   06/28/93   by: jms *GC78*                */
/*                                   06/28/93   by: jms *GD32*   (rev only)   */
/* REVISION  7.4      LAST MODIFIED: 07/20/93   by: wep *H037*                */
/*                                   07/22/93   by: pcd *H039*                */
/*                                   08/08/93   by: bcm *H060*                */
/*                                   08/18/93   by: wep *H077*                */
/*                                   08/20/93   by: pcd *H079*                */
/*                                   08/23/83   by: jms *H080*   (rev only)   */
/*                                   09/16/93   by: pcd *H117*                */
/*                                   09/16/93   by: wep *H118*                */
/*                                   10/06/93   by: jjs *H149*   (rev only)   */
/*                                   11/30/93   by: jjs *H248*                */
/*                                   11/30/93   by: pcd *H249*   (rev only)   */
/*                                   01/24/94   by: jjs *H181*                */
/*                                   02/25/94   by: pcd *H199*                */
/*                                   03/01/94   by: pmf *FM53*                */
/*                                   03/03/94   by: tjs *H070*                */
/*                                   03/03/94   by: bcm *H290*                */
/*                                   03/31/94   by: srk *FN16*                */
/*                                   02/25/94   by: pcd *H311*                */
/*                                   05/10/94   by: pmf *FO06*                */
/*                                   06/02/94   by: pmf *FO54*                */
/*                                   06/14/94   by: bcm *H383*                */
/*                                   07/25/94   by: bcm *H456*                */
/*                                   07/27/94   by: bcm *H460*                */
/*                                   08/10/94   by: bcm *H478*                */
/*                                   08/24/94   by: cpp *GL39*                */
/*                                   09/12/94   by: slm *GM17*                */
/*                                   09/15/94   by: pmf *GM68*                */
/*                                   10/21/94   by: str *FS68*                */
/*                                   10/27/94   by: ame *FS90*                */
/*                                   11/07/94   by: str *FT44*                */
/*                                   01/23/95   by: str *H09W*                */
/*                                   02/09/95   by: srk *H0B4*                */
/*                                   02/22/95   by: str *F0JB*                */
/*                                   03/02/95   by: wjk *F0KL*                */
/*                                   03/29/95   by: dzn *F0PN*                */
/*                                   04/20/95   by: wjk *H0CS*                */
/*                                   07/06/95   by: jzw *H0F6*                */
/*                                   12/12/95   by: mys *G1G1*                */
/*                                   01/24/96   by: mys *H0JC*                */
/* REVISION: 8.5      LAST MODIFIED: 07/11/95   BY: CDT *J057*                */
/*                                   09/20/95   by: mwd *J053*                */
/*                                   03/12/96   by: jzw *G1Q6*                */
/* REVISION: 8.5      LAST MODIFIED: 02/27/96   BY: *J0CV* Brandy J Ewing     */
/*                                   04/22/96   BY: jzw *H0KC*                */
/* REVISION: 8.6      LAST MODIFIED: 06/25/96   BY: BJL *K001*                */
/*                                   08/21/96   by: pmf *J148*                */
/*                                   10/10/96   by: svs *K007*                */
/*                                   01/22/97   by: bkm *H0R6*                */
/*                                   01/28/97   by: rxm *J1FR*                */
/*                                   01/29/97   by: *K05F* Eugene Kim         */
/*                                   02/17/97   by: *K01R* E. Hughart         */
/*                                   03/10/97   by: *K084* Jeff Wootton       */
/*                                   04/09/97   by: *J1NJ* Robin McCarthy     */
/* REVISION: 8.6      LAST MODIFIED: 09/23/97   BY: *J21B* Irine D'mello      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 04/01/98   By: *L00K* rup                */
/* REVISION: 8.6E     LAST MODIFIED: 05/08/98   BY: *J2KX* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton       */
/* Pre-86E commented code removed, view in archive revision 1.18              */
/* REVISION: 9.0      LAST MODIFIED: 12/07/98   BY: *J34H* G.Latha            */
/* REVISION: 9.0      LAST MODIFIED: 12/15/98   BY: *J34F* Vijaya Pakala      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/12/99   BY: *M0BC* David Sinclair     */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/15/99   BY: *M0BG* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 04/13/00   BY: *L0VW* Shilpa Athalye     */
/* REVISION: 9.1      LAST MODIFIED: 06/09/00   BY: *L0Z9* Falguni Dalal      */
/* REVISION: 9.1      LAST MODIFIED: 07/20/00   BY: *M0PQ* Falguni Dalal      */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* Jacolyn Needer     */
/* REVISION: 9.1      LAST MODIFIED: 08/21/00   BY: *N0MG* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 11/22/00   BY: *L15T* Veena Lad          */
/* REVISION: 9.1      LAST MODIFIED: 10/19/00   BY: *N0W0* Mudit Mehta        */
/* Revision: 1.44     BY: Katie Hilbert            DATE: 04/01/01 ECO: *P002* */
/* Revision: 1.45     BY: Ed van de Gevel          DATE: 12/03/01 ECO: *N16R* */
/* Revision: 1.46     BY: Mamata Samant            DATE: 01/14/02 ECO: *M1Q5* */
/* Revision: 1.47     BY: Ellen Borden             DATE: 04/17/02 ECO: *P043* */
/* Revision: 1.48     BY: Patrick Rowan            DATE: 04/30/02 ECO: *P05Q* */
/* Revision: 1.49     BY: Samir Bavkar             DATE: 02/14/02 ECO: *P04G* */
/* Revision: 1.52     BY: Mamata Samant            DATE: 06/19/02 ECO: *N1K9* */
/* Revision: 1.53     BY: Samir Bavkar             DATE: 06/20/02 ECO: *P09D* */
/* Revision: 1.54     BY: Luke Pokic               DATE: 07/01/02 ECO: *P09Z* */
/* Revision: 1.55     BY: Robin McCarthy           DATE: 07/15/02 ECO: *P0BJ* */
/* $Revision: 1.56 $  BY: Manjusha Inglay          DATE: 07/29/02 ECO: *N1P4* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*! --------------------------------------------------------------------------*
 * Version 8.6F Program Structure (of significant programs only):-
 *
 *  apvomt.p           Voucher Maintenance, menu 28.1
 *    apvobidf.i       Define before-image for vod_det and vph_hist
 *    apvoprdf.i       Define prh_inv_qty temp-table
 *    apvomtf.p        Open a Batch number
 *    apvomtg.p        Select Voucher Reference number
 *    apvomtk.p        Process GL and Cost impact (before update)
 *      apvomtk1.p     (not used at this point, see below)
 *      apvomtk3.p     (not used at this point, see below)
 *    apvomtc.p        Select PO number, Supplier number, display header fields
 *      apvomtc1.p     PO List frame
 *    apvomtk1.p       Reverse previous Cost Update (when deleting voucher)
 *    apvopru1.p       Store prh_inv_qty's in temp-table (when deleting voucher)
 *      apvoprdf.i     Define prh_inv_qty temp-table
 *I     apvopru3.p     Update prh_inv_qty's on inventory databases
 *I       apvoprdf.i   Define prh_inv_qty temp-table
 *    apvomtm.p        Update second header panel (currency, bank, etc.)
 *      apvomte.p      GTM Tax Class and Environment pop-up
 *    apvomta.p        Control PO receipt
 *      apvomta.i      Variables for apvomta.p
 *      apvomtj.p      Auto Receiver matching
 *      apvomta5.p     Update Receivers
 *        apvorate.i   Calculate rate variance
 *        apvomta6.p   Intrastat
 *        apvomta2.p   Cost dialog box
 *I         apvomtab.p Cost dialog box, get costing method
 *I           t016.i   Ask for "Inventory"/"Variance" (t016.i text)
 *I           t017.i   Ask for "WIP"/"Variance" (t017.i text)
 *      apvomta4.p     Backout and create voucher receipt details (but not GL)
 *        apvomta3.p   Determine accounts for variances
 *          apvotax.i  Inventory cost tax calculation
 *I         apvomtac.p Determine accounts for variances
 *    apvomtb.p        Distribution lines
 *      apvomth.p      Calculate tax and display Tax Distribution
 *        apvomti.p    Create vod_det tax lines and display (if recreate taxes)
 *I         apvomti0.p Get QOH and costing method
 *        apvomti.p    same
 *I         apvomti0.p Get QOH and costing method
 *      apvomtb1.p     Hold Amount / Confirm panel, Supplier Balance update
 *    apvomtk.p        Process GL and Cost impact (after update)
 *      apvobidf.i     Define before-image for vod_det and vph_hist
 *      apvomtk1.p     Reverse previous Item Cost Update
 *        apvobidf.i   Define before-image for vod_det and vph_hist
 *I       apvomtka.p   Reverse previous Item Cost Update
 *I         ictrans.i  Create Inventory transactions
 *I         nrm.p      New instance of NRM on inventory database
 *I         apvoglu1.p GL transactions for confirmed cost adjustments
 *        apvoglu1.p   GL transactions for confirmed cost adjustments
 *      apapgl3.p      Reverse of apapgl.p
 *        apvobidf.i   Define before-image for vod_det and vph_hist
 *        apglpl.p     procedure apgl-create-all-glt
 *      apapgl.p       Create GL transactions
 *        apglpl.p     procedure apgl-create-all-glt
 *                     (also run by aprvvo.p, apvoco.p, apvoco01.p)
 *          gpglpl.p   procedure gpgl-convert-to-account-currency
 *          gpglpl.p   procedure gpgl-create-one-glt
 *      apvomtk3.p     Loop through vph and prh, run apvocsu1.p
 *        apvocsu1.p   Update Item Cost, create tr_hist and trgl_det
 *                     (also run from apvoco.p and apvoco01.p)
 *          apvotax.i  Inventory cost tax calculation
 *I         apvocsua.p Update Item Cost, create tr_hist and trgl_det
 *I           nrm.p    New instance of NRM on inventory database
 *I           apvoglu1.p GL transactions for confirmed cost adjustments
 *          apvoglu1.p GL transactions for confirmed cost adjustments
 *      apvopru1.p     Store prh_inv_qty's in temp-table
 *        apvoprdf.i   Define prh_inv_qty temp-table
 *        apvopru2.p   Store one prh_inv_qty in temp-table
 *          apvoprdf.i Define prh_inv_qty temp-table
 *I       apvopru3.p   Update prh_inv_qty's on inventory databases
 *I         apvoprdf.i Define prh_inv_qty temp-table
 *    apvomtd.p        Set Batch status
 *
*I = runs connected to inventory site database
  *----------------------------------------------------------------------------*
   */
   {mfdtitle.i "2+ "}
   {cxcustom.i "APVOMT.P"}

   /* ********** Begin Translatable Strings Definitions ********* */

   &SCOPED-DEFINE apvomt_p_2 "Control"
   /* MaxLen: Comment: */

   &SCOPED-DEFINE apvomt_p_3 "Batch"
   /* MaxLen: Comment: */

   &SCOPED-DEFINE apvomt_p_4 "Voucher All"
   /* MaxLen: Comment: */

   /* ********** End Translatable Strings Definitions ********* */

   {gldydef.i new}
   {gldynrm.i new}
   {apconsdf.i}

/******** DEFINE VARIABLES *************************************************/
define new shared variable del-yn like mfc_logical initial no.
define new shared variable apref like ap_ref.
define new shared variable jrnl like glt_ref.
define new shared variable batch like ap_batch label {&apvomt_p_3}.
define new shared variable aptotal like ap_amt label {&apvomt_p_2}.
define new shared variable old_amt like ap_amt.
define new shared variable old_base_amt like ap_base_amt.
define new shared variable ckdref like ckd_ref.
define new shared variable old_effdate like ap_effdate.
define new shared variable set_sub as integer initial 0.
define new shared variable set_mtl as integer initial 0.
define new shared variable fill-all like mfc_logical
   label {&apvomt_p_4} initial yes.
define new shared variable new_vchr like mfc_logical initial no.
define new shared variable ap_recno as recid.
define new shared variable vo_recno as recid.
define new shared variable vd_recno as recid.
define new shared variable old_vend like ap_vend.
define new shared variable base_amt like ar_amt.
define new shared variable desc1 like bk_desc format "x(30)".
define new shared variable undo_all like mfc_logical.
define new shared variable vod_recno as recid.
define new shared variable curr_amt like glt_curr_amt.
define new shared variable ship-name like ad_name.
define new shared variable base_det_amt like glt_amt.
define new shared variable ba_recno as recid.
define new shared variable bactrl like ba_ctrl.
define new shared variable totinvdiff like ap_amt.
define new shared variable first_vo_in_batch like mfc_logical.
define new shared variable old_vo_amt like ap_amt.
define new shared variable yes_char as character
   format "!".
define new shared variable no_char as character
   format "!".
define new shared variable tax_class like ad_taxc no-undo.
define new shared variable tax_usage like ad_tax_usage no-undo.
define new shared variable tax_taxable like ad_taxable no-undo.
define new shared variable tax_in    like ad_tax_in no-undo.
define new shared variable undo_tframe like mfc_logical.
define new shared variable auto-select like mfc_logical.
define new shared variable po-attached like mfc_logical.
define new shared variable process_tax like mfc_logical.
define new shared variable tax_tr_type like tx2d_tr_type initial "22".
define new shared variable first_pass  like mfc_logical.
define new shared variable pmt_exists  like mfc_logical.
define new shared variable base_prepay like vo_prepay.
define new shared variable next_loopc  as logical no-undo.
define new shared variable taxchanged  as logical no-undo.
define new shared variable rndmthd     like rnd_rnd_mthd.
define new shared variable old_curr     like vo_curr.
define new shared variable l_flag      like mfc_logical no-undo initial false.
define new shared variable vchr_logistics_chrgs  like mfc_logical
       label "Voucher Logistics Charges" initial no no-undo.
define new shared variable incl_blank_suppliers  like mfc_logical no-undo.

{&APVOMT-P-TAG1}

/* USED FOR SCROLLING WINDOW SWCSBD.P */
define new shared variable supp_bank like ad_addr no-undo.

define variable gltline       like glt_line.
define variable glvalid       like mfc_logical.
define variable valid_acct    like mfc_logical.
define variable get_cu_mstr   like mfc_logical.
define variable apc_ext_ref   like mfc_logical.
define variable tax_nbr       like tx2d_nbr initial "*".
define variable action        as character format "x(1)" initial "2".

define variable ctrldiff           like ap_amt.
define variable confirm_undo       like mfc_logical no-undo.
define variable init-daybook       like dy_dy_code.
define variable old_vo_prepay      like vo_prepay no-undo.
define variable l_ap_base_amt      like ap_base_amt no-undo.
define variable logistics_charge_voucher like mfc_logical no-undo.
define variable use-log-acctg      as logical no-undo.

define new shared frame a.
define new shared frame voucher.
define new shared frame order.
define new shared frame vohdr1.
define new shared frame vohdr2.
define new shared frame vohdr2a.
define new shared frame vohdr3.

define buffer apmstr1 for ap_mstr.
define buffer vomstr1 for vo_mstr.
{etvar.i &new = "new"}        /* COMMON EURO VARIABLES */

/* DEFINE 'BEFORE IMAGE' WORKFILES */
{apvobidf.i "NEW"}

/* DEFINE PRH_HIST UPDATE TEMP-TABLE */
{apvoprdf.i "new"}

/* DEFINE VARIABLES FOR DISPLAY OF VAT REG NUMBER AND COUNTRY CODE */
{apvtedef.i &var="new shared"}

/* DEFINE VARIABLES FOR GPGLEF.P (GL CALENDAR VALIDATION) */
{gpglefdf.i}

/* DEFINE VARIABLES FOR GPFIELD.I */
&if defined(gpfieldv) = 0 &then
      &global-define gpfieldv
      {gpfieldv.i}
&endif

/* FIND FIRST CHARACTERS OF YES/NO IN MFC_LOGICAL FOR U.S.TAXES */
{gpfield.i &field_name='mfc_logical'}
yes_char = substring(field_format,1,1).
no_char = substring(field_format,index(field_format,"/") + 1,1).

{&APVOMT-P-TAG2}
find first gl_ctrl no-lock.

{gprun.i ""gldydft.p"" "(input ""AP"",
                         input ""VO"",
                         input gl_entity,
                         output dft-daybook,
                         output daybook-desc)"}

init-daybook = dft-daybook.

/* DEFINE CURRENCY FORMATTING VARIABLES FOR VOHDR1 AND VOHDR2 */
{apcurvar.i "NEW"}

/* DEFINE FORM A */
/* NOTE THIS FORM CHANGED TO FORMAT BATCH TOTALS TO 3 DECIMALS */
{apvofma.i}

/*DEFINE FORM B*/
{apvofmb.i}
{&APVOMT-P-TAG3}

/* SAVE ORIGINAL FORMAT VALUES */
assign
   ap_amt_old         = ap_amt:format in frame vohdr1
   vo_prepay_old      = vo_prepay:format in frame vohdr2a
   vo_holdamt_old     = vo_hold_amt:format in frame vohdr2a
   vo_ndisc_old       = vo_ndisc_amt:format in frame vohdr2a.

/******* MAINLOOP: ***********************************************************
***      MAIN LOGIC SECTION                                                ***
******************************************************************************/
mainloop:
repeat with frame a:

   /* GET BATCH DATA */
   {gprun.i ""apvomtf.p""}
   if keyfunction(lastkey) = "END-ERROR" then leave.
   if keyfunction(lastkey) = "." then leave. /* (F4 in CIM) */
   if ba_recno <> 0 then
         find ba_mstr where recid(ba_mstr) = ba_recno no-lock.

   /********** LOOPB: *********************************************************
   ***         PROCESS VOUCHER                                              ***
   ***************************************************************************/
   loopb:
   repeat with frame vohdr1:

      if available ba_mstr then
            display ba_total with frame a.

      pmt_exists = no.
      view frame a.
      view frame voucher.
      view frame order.
      view frame vohdr1.
      view frame vohdr2.

      /* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
      {gprun.i ""lactrl.p"" "(output use-log-acctg)"}
      if use-log-acctg then incl_blank_suppliers = no.

      /* GET VOUCHER DATA */
      /* NOTE APVOMTG HAS BEEN CHANGED TO GET THE ROUNDING METHOD */
      /* AND THE DISPLAY FORMATS FOR THE FIELDS IN FRAMES         */
      /* VOHDR1 AND VOHDR2.  IF NEW VOUCHER, USES BASE_CURR INFO  */
      {gprun.i ""apvomtg.p""}
      if keyfunction(lastkey) = "END-ERROR" then leave.
      if keyfunction(lastkey) = "." then leave. /* (F4 in CIM) */
      {&APVOMT-P-TAG4}
      assign
         new_vchr = no
         process_tax = no.

      /************* TRANSACTION:  ************************************************
      ***            EDIT VOUCHER DATA                                          ***
      ****************************************************************************/
      do for apc_ctrl transaction:

         /* GL IMPACT MANAGER - 0 ==> save before image */
         find ap_mstr where ap_ref = input ap_ref and
            ap_type = "VO" no-lock no-error.
         if available ap_mstr then do:
            find vo_mstr where vo_ref = ap_ref no-lock no-error.
            assign
               old_vo_prepay = vo_prepay
               ap_recno = recid (ap_mstr)
               vo_recno = recid (vo_mstr)
               aptotal = ap_amt.
         end.
         else
            assign
               old_vo_prepay = 0
               ap_recno = ?
               vo_recno = ?.

         {gprun.i ""apvomtk.p"" "(0)"}

         /**************** LOOPC: ****************************************************
         ***               ADD/MOD/DELETE LOGIC                                    ***
         ****************************************************************************/
         loopc:
         do while true:
            if c-application-mode <> 'Web-ChUI' then
               view frame dtitle.

            /* ADD/MOD/DELETE  */
            find first apc_ctrl no-lock.

            if not available ap_mstr then do:

               find first apc_ctrl no-lock.
               create ap_mstr.
               assign
                  ap_ref ap_type = "VO"
                  ap_batch = batch
                  ap_date = today
                  ap_entity = gl_entity
                  ap_effdate = today
                  ap_dy_code = init-daybook
                  ap_curr = gl_base_curr
                  aptotal = 0.
               if recid(ap_mstr) = -1 then .
               create vo_mstr.
               assign vo_ref = ap_ref
                  vo_curr = ap_curr
                  vo_confirmed = apc_confirm.
               if recid(vo_mstr) = -1 then .

               assign
                  process_tax = yes
                  new_vchr = yes
                  first_pass = yes
                  ap_disc_acct = gl_apds_acct
                  ap_disc_sub = gl_apds_sub
                  ap_disc_cc = gl_apds_cc.

               display
                  ap_disc_acct
                  ap_disc_sub
                  ap_disc_cc
               with frame vohdr2.
               {&APVOMT-P-TAG5}

            end. /*** ADD NEW ***/

            else do:
               {&APVOMT-P-TAG6}
               old_effdate = ap_effdate.
            end.

            /***** CHECK THAT VOUCHER IS IN BATCH *****/
            if batch <> "" and  batch <> ap_batch then do:
               {pxmsg.i &MSGNUM=1152 &ERRORLEVEL=3}
               pause.
               undo, retry.
            end.

            /*** CREATE OR UPDATE BATCH MASTER IF VOUCHER ***/

            if batch = "" then batch = ap_batch.
            find ba_mstr where ba_batch = batch and ba_module = "AP"
               exclusive-lock no-error.

            assign
               ba_recno = recid(ba_mstr)
               ba_userid = global_userid
               ba_date = today
               first_vo_in_batch = no.

            display ba_batch @ batch
               ba_ctrl @ bactrl ba_total with frame a.

            /* SEE APVOMTG FOR SPECIAL FORMATTING FOR THESE AMOUNTS.*/
            display
               ap_amt
               aptotal
               ap_effdate
               ap_vend
               vo_tax_date
               vo_ship
               vo_is_ers   /* DISPLAY IF IT'S ERS, BUT NEVER UPDATE */
            with frame vohdr1.

            display
               vo_curr
               vo_separate
               ap_ckfrm
               vo_type
               vo_invoice
               ap_date
               vo_cr_terms
               vo_disc_date
               vo_due_date
               ap_acct
               ap_sub
               ap_cc
               ap_disc_acct
               ap_disc_sub
               ap_disc_cc
               ap_rmk
               ap_entity
               ap_bank
               ap_expt_date
               vo__qad02
            with frame vohdr2.
            {&APVOMT-P-TAG7}

            if ap_bank <> "" then
               find bk_mstr where bk_code = ap_bank no-lock no-error.
            {&APVOMT-P-TAG8}
            if available bk_mstr then
               display bk_desc @ desc1 with frame vohdr2.
            {&APVOMT-P-TAG9}

            /* DO NOT PASS GO IF THE VOUCHER IS SELECTED FOR PAYMENT*/
            if vo_amt_chg <> 0 or vo_disc_chg <> 0 then do:
               /* VOUCHER SELECTED FOR PAYMENT.  MOD. NOT ALLOWED*/
               {pxmsg.i &MSGNUM=2209 &ERRORLEVEL=3}
               pause.
               undo, retry.
            end.

            /* BACKOUT BATCH TOTALS*/

            /* BACK OUT BATCH TOTAL MOVED BELOW SO AS TO */
            /* DISPLAY BATCH TOTALS CORRECTLY WHEN USER  */
            /* ENTERS NO/YES TO THE ACTION MESSAGE       */

            assign
               old_amt = ap_amt - vo_applied
               old_base_amt = ap_base_amt - vo_base_applied
               old_vend = ap_vend
               recno = recid(ap_mstr)
               del-yn = no
               ap_recno = recid(ap_mstr)
               vo_recno = recid(vo_mstr)
               undo_all = yes.

            /* IF VOUCHER IS NEW,                              */
            /* APVOMTC.P RESETS THE VO_CURR TO VD_CURR,        */
            /* AND RE-SETS THE ROUNDING VALUES AND THE FORMATS */
            /* FOR FIELDS IN FRAMES VOHDR1 AND VOHDR2.         */

            {gprun.i ""apvomtc.p""}

            if undo_all then do:
               {gprun.i ""apvoundo.p"" "(input po-attached,
                                         output confirm_undo)"}
               if confirm_undo = no then next loopc.
               else undo loopb, retry.
            end.

            assign base_prepay = 0.
            /* BACKOUT VENDOR PREPAY BALANCE BY OLD VOUCHER PREPAY */

            if old_vo_prepay <> 0 then do:
               find vd_mstr where vd_addr = ap_vend exclusive-lock
                  no-error.
               if available vd_mstr then do:

                  assign base_prepay = old_vo_prepay.
                  if base_curr <> vo_curr then

                  /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                               "(input vo_curr,
                                 input base_curr,
                                 input vo_ex_rate,
                                 input vo_ex_rate2,
                                 input base_prepay,
                                 input true, /* ROUND */
                                 output base_prepay,
                                 output mc-error-number)"}.
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.

                  vd_prepay = vd_prepay - base_prepay.
               end.
            end.

            find vd_mstr where recid(vd_mstr) = vd_recno no-lock
               no-error.

            /******************* DELETE PROCESSING *************************************/
            if del-yn then do:

               /* DON'T ALLOW DELETE IF GL CLOSED*/
               if vo_confirmed then do:

                  /* VERIFY GL CALENDAR FOR SPECIFIED ENTITY */
                  {gpglef.i ""AP"" ap_entity ap_effdate "loopb"}

               end. /* IF VO_CONFIRMED */

               {&APVOMT-P-TAG10}
               /* DON'T ALLOW DELETE IF NO GAPS ALLOWED IN SEQUENCE */
               allow-gaps = no.
               if daybooks-in-use and ap_dy_code > "" then do:
                  {gprunp.i "nrm" "p" "nr_can_void"
                     "(input  ap_dy_code,
                       output allow-gaps)"}

                  if not allow-gaps then do:
                     {pxmsg.i &MSGNUM=1349 &ERRORLEVEL=3}
                     undo loopb, retry.
                  end. /* if not allow-gaps */
               end. /* if daybooks-in-use and ap_dy_code > "" */

               /* CHECK FOR PAYMENT */
               if vo_applied <> 0 then do:
                  ckdref = "".
                  find first ckd_det where ckd_voucher = ap_ref
                     no-lock no-error.

                  repeat
                        on endkey undo, next loopb:
                     if available ckd_det then do:
                        find ck_mstr where ck_ref = ckd_ref
                           no-lock no-error.
                        if available ck_mstr and ck_status <> "VOID"
                        then do:
                           ckdref = ckd_ref.
                           {pxmsg.i &MSGNUM=1166 &ERRORLEVEL=3 &MSGARG1=ckdref}
                           /*DELETE NOT ALLOWED, PAYMENT HAS BEEN APPLIED*/
                           undo loopb, retry.
                        end.
                     end.
                     else leave.
                     find next ckd_det where ckd_voucher = ap_ref
                        no-lock no-error.
                  end.
               end.  /** IF VO_APPLIED <> 0 **/

               /* CHECK IF LOGISTICS CHARGE VOUCHER */
               logistics_charge_voucher = false.
               if use-log-acctg then
                  for first vph_hist no-lock
                  where vph_ref = vo_ref
                     and (can-find(first pvo_mstr where pvo_id = vph_pvo_id
                                     and pvo_lc_charge <> "")):
                     logistics_charge_voucher = true.
                  end. /* FOR FIRST VPH_HIST */

               /* BACKOUT ANY COST UPDATES */
               if not logistics_charge_voucher then do:
                  {gprun.i ""apvomtk1.p""}
               end.
               else do:
                  {gprunmo.i &module = "LA" &program = "apvolacu.p"
                             &param  = """(input 0,
                                           input vo_ref)"""}
               end.

               /* REVERSE PO RECEIPTS/PENDING VOUCHERS WHEN DELETING VOUCHER */
               for each vph_hist exclusive-lock
                     where vph_ref = vo_ref:
                  /* IF LOGISTICS CHARGE VOUCHER */
                  if use-log-acctg and
                     can-find(first pvo_mstr where pvo_id = vph_pvo_id
                                               and pvo_lc_charge <> "") then
                     /* BACKOUT PENDING VOUCHER AMT */
                     run backoutPendingVoucherAmount
                        (input vph_pvo_id,
                         input vph_pvod_id_line,
                         input vph_curr_amt).
                  else
                     /* BACKOUT PENDING VOUCHER QTY */
                     run backoutPendingVoucherQuantity
                        (input vph_pvo_id,
                         input vph_inv_qty).

                  delete vph_hist.
               end.

               if global_db <> ""
               then do:
                  /* UPDATE PRH_INV_QTY ON INVENTORY DATABASES */
                  for each prhup_wkfl exclusive-lock:
                     delete prhup_wkfl.
                  end.
                  {gprun.i ""apvopru1.p""
                     "(input vo_ref)"}
               end.

               /********* DELETE VOUCHER DETAIL *********/
               /*FIND THE ENTITY FOR THE CREDIT ACCOUNT*/
               for each vod_det exclusive-lock where vod_ref = vo_ref:
                  if vo_confirmed then do:

                     assign
                        base_amt = - vod_base_amt
                        curr_amt = - vod_amt
                        base_det_amt = base_amt
                        vod_recno = recid(vod_det)
                        undo_all = yes.

                     if jrnl = "" then do:
                        /* GET NEXT JOURNAL REFERENCE NUMBER  */
                        {mfnctrl.i apc_ctrl apc_jrnl glt_det
                           glt_ref jrnl}
                        release glt_det.
                        release apc_ctrl.
                     end. /* IF jrnl = "" */

                     {gprun.i ""apapgl.p""}
                     if undo_all then undo mainloop, leave.
                  end.
                  delete vod_det.
               end.  /** DELETE VOUCHER DETAIL **********/

               /******** DELETE TAX DETAIL RECORDS *********/
               {gprun.i ""txdelete.p"" "(input tax_tr_type,
                                         input vo_ref,
                                         input tax_nbr)"}

               /******* DELETE ATTACHED PURCHASE ORDERS *****/
               for each vpo_det exclusive-lock where vpo_ref = vo_ref:
                  delete vpo_det.
               end.  /*** DELETE ATTACHED... ****************/

               /********** UPDATE VENDOR BALANCE *************/
               if vo_confirmed and old_amt <> 0 then do:
                  find vd_mstr where vd_addr = old_vend
                     exclusive-lock.
                  assign
                     base_amt = old_base_amt
                     vd_balance = vd_balance - base_amt.
               end.
               if ap_remit <> "" then do:
                  find ad_mstr exclusive-lock where
                     ad_addr = ap_remit no-error.
                  if available ad_mstr then
                     delete ad_mstr.
               end.
               if daybooks-in-use then do:
                  find first glt_det where glt_ref = ap_ref
                     no-lock no-error.
                  if available glt_det then do:
                     if glt_dy_num > ""
                     then do:
                        {gprunp.i "nrm" "p" "nr_void_value"
                           "(input glt_dy_code,
                             input glt_dy_num,
                             input getTermLabel('DELETED_AP_MASTER',35))"}
                     end. /* IF glt_dy_num > "" */

                  end. /* if available glt_det */
               end. /* if daybooks-in-use */

               /* DELETE RATE USAGE */
               {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                  "(input vo_exru_seq)"}

               assign
                  ba_total = ba_total - ap_amt.
               {&APVOMT-P-TAG11}

               delete vo_mstr.

               /* DELETE RATE USAGE */
               {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                  "(input ap_exru_seq)"}

               delete ap_mstr.
               display ba_total with frame a.
               clear frame voucher.
               clear frame order all.
               clear frame vohdr1.
               clear frame vohdr2.
               clear frame vohdr2a.
               del-yn = no.
               next loopb.
            end.   /** IF DEL-YN **/
            /******************* END DELETE PROCESSING ********************************/

            ststatus = stline[3].
            status input ststatus.

            /* DEFAULT CUSTOMER/SUPPLIER BANK TO FIRST */
            /* AVAILABLE CUSTOMER/SUPPLIER BANK DETAIL */
            if vo__qad02 = "" then do:
               {&APVOMT-P-TAG20}
               find first csbd_det where csbd_addr = ap_vend
                  and csbd_beg_date <=  ap_effdate
                  and csbd_end_date >= ap_effdate no-lock no-error.
               if available csbd_det then vo__qad02 = csbd_bank.
            end.

            /* SUPP_BANK IS USED FOR SCROLLING WINDOW SWCSBD.P */
            supp_bank = ap_vend.

            display
               vo_tax_date
               vo_ship
            with frame vohdr1.

            {&APVOMT-P-TAG12}
            display
               vo_curr
               ap_bank
               vo_invoice
               ap_date
               vo_cr_terms
               vo_disc_date
               vo_due_date
               ap_rmk
               vo_separate
               ap_ckfrm
               vo_type
               ap_expt_date
               ap_acct
               ap_sub
               ap_cc
               ap_disc_acct
               ap_disc_sub
               ap_disc_cc
               ap_entity
               vo__qad02
            with frame vohdr2.

            undo_all = yes.
            next_loopc = no.

            /* NOTE: APVOMTM ALLOWS UPDATE OF THE CURRENCY. IF    */
            /* THE CURRENCY IS CHANGED, THEN IT WILL RESET  THE   */
            /* ROUNDING VALUES AND FORMATS                        */
            {gprun.i ""apvomtm.p""}

            /* l_flag IS SET TO true IN BATCH MODE IN apvomte.p */
            /* FOR AN ERROR ENCOUNTERED.                        */
            if l_flag
            then
               undo mainloop, leave mainloop.

            if undo_all then undo loopb, retry.

            if next_loopc then do:
               /* ADD TO VENDOR PREPAY BALANCE THE OLD VOUCHER PREPAY */
               if base_prepay <> 0 then do:
                  for first vd_mstr where vd_addr = ap_vend
                        exclusive-lock:
                  end.
                  if available vd_mstr then
                     assign vd_prepay = vd_prepay + base_prepay.
               end. /* IF base_prepay <> 0 */
               next loopc.
            end. /* IF next_loopc */

            {&APVOMT-P-TAG13}
            hide frame a no-pause.
            hide frame voucher no-pause.
            hide frame order no-pause.
            hide frame vohdr1 no-pause.
            hide frame vohdr2 no-pause.
            hide frame vohdr2a no-pause.

            assign
               totinvdiff    = 0
               ap_recno      = recid(ap_mstr)
               vo_recno      = recid(vo_mstr)
               vd_recno      = recid(vd_mstr)
               l_ap_base_amt = 0
               ba_total      = ba_total - ap_amt.

            if po-attached then do:
               {gprun.i ""apvomta.p""}
               /* l_flag IS SET TO true IN BATCH MODE IN apvomta5.p */
               /* FOR AN ERROR ENCOUNTERED.                         */
               if l_flag
               then
                  undo mainloop, leave mainloop.
            end.
            else /* IF PO NOT ATTACHED */
               if use-log-acctg and vchr_logistics_chrgs then do:
                  {gprunmo.i &module = "LA" &program = "apvolaa.p"}
                  /* l_flag IS SET TO true IN BATCH MODE IN apvolaa5.p */
                  /* FOR AN ERROR ENCOUNTERED.                         */
                  if l_flag
                  then
                     undo mainloop, leave mainloop.
               end. /* IF USE-LOG-ACCTG and VCHR_LOGISTICS_CHRGS*/


            {gprun.i ""apvomtb.p"" "(input 0)"}
            /* l_flag IS SET TO true IN BATCH MODE IN apvomtb.p */
            /* FOR AN ERROR ENCOUNTERED.                        */
            if l_flag
            then
               undo mainloop, leave mainloop.
            display ba_total with frame a.

            first_pass = false.  /* PROTECTS HEADER DATA */

            /* VERIFY AP BASE AMOUNT (ap_base_amt) WITH TOTAL */
            /* OF VOUCHER BASE AMOUNT (vod_base_amt).         */

            for each vod_det
               fields (vod_acct vod_amt vod_base_amt vod_desc
                       vod_dy_code vod_entity vod_ln vod_ref
                       vod_tax_at vod_type)
               where vod_ref = ap_ref
            no-lock:
               assign
                  l_ap_base_amt = vod_base_amt + l_ap_base_amt.
            end. /* FOR EACH VOD_DET */

            if l_ap_base_amt <> ap_base_amt then
            assign
               ap_base_amt = l_ap_base_amt.

            if ap_curr <> base_curr
            then do:
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ap_curr,
                    input base_curr,
                    input ap_ex_rate,
                    input ap_ex_rate2,
                    input ap_amt,
                    input true,
                    output l_ap_base_amt,
                    output mc-error-number)"}

               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end. /* IF mc-error-number <> 0 */

               if ap_base_amt <> l_ap_base_amt
               then do:
                  run p_create_vod_det (buffer ap_mstr,
                                        input  vo_confirmed).
               end. /* IF ap_base_amt <> l_ap_base_amt */
            end. /* IF ap_curr <> base_curr */

            {&APVOMT-P-TAG14}
            if (aptotal <> ap_amt and aptotal <> 0)
               then

            /******************* CTRL_BLOCK:  ******************************************
            ***                  TOTALS DON'T ADD UP                                 ***
            ****************************************************************************/
            ctrl_block:
            do on error undo, leave:

               view frame a.
               view frame voucher.
               view frame order.
               view frame vohdr1.
               view frame vohdr2.
               view frame vohdr3.

               display ap_amt with frame vohdr1.

               ctrldiff = ap_amt - aptotal.
               action   = "2".
               /* CONTROL: # DISTRIBUTION #: DIFF #. */
               bell.

               /*****************************************************************************/
               action_block:
               do on endkey undo, retry:
                  /*****************************************************************************/
                  input clear.
                  {pxmsg.i &MSGNUM=1163 &ERRORLEVEL=1
                           &MSGARG1=aptotal &MSGARG2=ap_amt
                           &MSGARG3=ctrldiff}

                  /*V8-*/
                  {pxmsg.i &MSGNUM=1721 &ERRORLEVEL=1 &CONFIRM=action}
                  /* 1:Accept/2:Edit/3:Cancel */
                  /*V8+*/
                  /*V8!
                  /* ADDED SECOND, THIRD, FOURTH AND FIFTH PARAMETER */
                  {gprun.i ""gpaecupd.p"" "(input-output action,
                                            input 1721,
                                            input getTermLabel('&Accept', 9),
                                            input getTermLabel('&Edit', 9),
                                            input getTermLabel('&Cancel', 9))"}
                  */

                  if action = "2" then
                     {&APVOMT-P-TAG15}
                     next loopc.
                     {&APVOMT-P-TAG16}
                  else
                  if action = "3" then
                     undo loopb, retry.
                  else
                  if action <> "1" then
                     undo action_block, retry.
               end. /*** ACTION_BLOCK ***/

            end. /** CTRL_BLOCK: **/
            /******************* END OF CTRL_BLOCK ***************************************/

            leave.
         end. /*** LOOPC ***/
         /**************** END OF LOOPC **********************************************/

         /* GL IMPACT MANAGER - 1 ==> PROCESS GL */
         {gprun.i ""apvomtk.p"" "(1)"}

         /****** DELETE REFERENCE IF VOUCHER IS EMPTY *****/
         if not can-find(first vod_det where
            vod_det.vod_ref = vo_ref)
            and not can-find(first vph_hist where
            vph_hist.vph_ref = vo_ref)
            and (ap_amt - vo_applied = 0) then do:

            {pxmsg.i &MSGNUM=1159 &ERRORLEVEL=2} /* DELETING REFERENCE */
            do on endkey undo, leave:
               pause.
            end.

            /* BACKOUT VENDOR BALANCE */
            if vo_confirmed and
               (old_amt <> (ap_amt - vo_applied) or
               ap_vend <> old_vend)
            then do:
               find vd_mstr
                  where vd_addr = old_vend
                  exclusive-lock no-error.
               assign
                  base_amt = old_amt.

               if ap_curr <> base_curr
               then do:
                  /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input ap_curr,
                       input base_curr,
                       input ap_ex_rate,
                       input ap_ex_rate2,
                       input old_amt,
                       input true, /* ROUND */
                       output base_amt,
                       output mc-error-number)"}.
                  if mc-error-number <> 0
                  then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end. /* IF MC-ERROR-NUMBER <> 0 */
               end. /* IF AP_CURR <> BASE_CURR */
               assign
                  vd_balance = vd_balance - base_amt.

               if ap_vend <> old_vend then
                  find vd_mstr
                  where vd_addr = ap_vend
                  exclusive-lock no-error.
               assign
                  base_amt   = ap_base_amt - vo_base_applied
                  vd_balance = vd_balance  + base_amt.
            end. /* IF VO_CONFIRMED.... */

            /* BACKOUT VENDOR PREPAY BALANCE*/
            if vo_prepay <> 0 then do:
               find vd_mstr where vd_addr = ap_vend exclusive-lock
                  no-error.
               if available vd_mstr then do:
                  base_prepay = vo_prepay.
                  if base_curr <> vo_curr then
                  do:

                     /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input vo_curr,
                          input base_curr,
                          input vo_ex_rate,
                          input vo_ex_rate2,
                          input base_prepay,
                          input true, /* ROUND */
                          output base_prepay,
                          output mc-error-number)"}.
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.

                  end.

                  vd_prepay = vd_prepay - base_prepay.
               end.
            end.

            for each vpo_det exclusive-lock where vpo_ref = vo_ref:
               delete vpo_det.
            end.

            /* DELETE MISCELLANEOUS CHEQUE SUPPLIER'S */
            /* REMIT-TO ADDRESS                       */
            if ap_remit <> "" then do:
               find ad_mstr where ad_addr = ap_remit exclusive-lock
                  no-error.
               if available ad_mstr then delete ad_mstr.
            end.

            {&APVOMT-P-TAG17}
            /* DELETE RATE USAGE */
            {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
               "(input ap_exru_seq)"}

            delete ap_mstr.

            /* DELETE RATE USAGE */
            {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
               "(input vo_exru_seq)"}

            delete vo_mstr.

         end. /*** DELETE REFERENCE IF VOUCHER EMPTY ***/

      end.
      /************* END OF TRANSACTION: ******************************************/
   {&APVOMT-P-TAG18}

   end.
   /********** END OF LOOPB: ***************************************************/

   {gprun.i ""apvomtd.p""}

end.
/******* END OF MAINLOOP: ***************************************************/

status input.
{&APVOMT-P-TAG19}

/*------------------------------------------------------------------*/
procedure backoutPendingVoucherQuantity:
/*------------------------------------------------------------------*/
/* Purpose: This procedure backs out the vouchered quantity from the*/
/*          pending voucher records when a voucher is deleted.      */
/*                                                                  */
/*------------------------------------------------------------------*/
   define input  parameter ip_pvo_id    as integer   no-undo.
   define input  parameter ip_vouchered_qty   as decimal no-undo.


   for first pvo_mstr
       where pvo_lc_charge         = ""
         and pvo_internal_ref_type = {&TYPE_POReceiver}
         and pvo_id                = ip_pvo_id
         exclusive-lock:

            assign
               pvo_last_voucher = ""
               pvo_vouchered_qty = if ip_vouchered_qty >= pvo_vouchered_qty
                                   then 0   /* TO ACCOUNT FOR USAGE VAR. */
                                   else pvo_vouchered_qty - ip_vouchered_qty.

   end. /*for first pvo_mstr*/
end procedure. /*backoutPendingVoucherQuantity*/

/*------------------------------------------------------------------*/
procedure backoutPendingVoucherAmount:
/*------------------------------------------------------------------*/
/* Purpose: This procedure backs out the vouchered amounts from the */
/*          pending voucher records when a voucher for logistics    */
/*          charges is deleted.                                     */
/*                                                                  */
/*------------------------------------------------------------------*/
   define input  parameter ip_pvo_id          as integer   no-undo.
   define input  parameter ip_pvod_id_line    as integer   no-undo.
   define input  parameter ip_vouchered_amt   as decimal no-undo.


   for first pvo_mstr exclusive-lock
             where pvo_id = ip_pvo_id,
       each  pvod_det exclusive-lock
             where pvod_id = pvo_id
               and pvod_id_line = ip_pvod_id_line:

            assign
               pvo_last_voucher = ""
               pvod_vouchered_amt = pvod_vouchered_amt - ip_vouchered_amt
               pvo_vouchered_amt = pvo_vouchered_amt - ip_vouchered_amt.

   end. /*for first pvo_mstr*/
end procedure. /*backoutPendingVoucherAmount*/


/* WHEN ROUNDING VARIANCE EXISTS FOR A VOUCHER, A SYSTEM GENERATED vod_det */
/* RECORD WILL BE CREATED, WITH TRANSACTION TYPE "x". THE BASE VALUE WILL  */
/* BE UPDATED WITH VARIANCE AMT AND THE AMOUNT IN FOREIGN CURRENCY WILL BE */
/* UPDATED WITH ZERO VALUE.                                                */

PROCEDURE  p_create_vod_det:

   define       parameter buffer         apmstr for ap_mstr.
   define input parameter p_vo_confirmed like mfc_logical no-undo.

   define variable l_rnd_variance        like ap_base_amt no-undo.
   define variable l_vchr_ln             like vod_ln      no-undo.

   assign
      l_vchr_ln          = 0
      l_rnd_variance     = l_ap_base_amt - apmstr.ap_base_amt
      apmstr.ap_base_amt = l_ap_base_amt.

   for first cu_mstr
      fields (cu_curr cu_ex_rnd_acct)
      where cu_curr = apmstr.ap_curr
   no-lock:
   end. /* FOR FIRST cu_mstr */

   if available cu_mstr
   then do:
      find first vod_det
         where vod_ref  = apmstr.ap_ref
           and vod_type = "x"
      exclusive-lock no-error.

      if available vod_det
      then
         vod_base_amt = vod_base_amt + l_rnd_variance.
      else do:
         for last vod_det
            fields (vod_acct vod_amt vod_base_amt vod_desc vod_dy_code
                    vod_entity vod_ln vod_ref vod_tax_at vod_type)
            where vod_ref = apmstr.ap_ref
         no-lock:
            l_vchr_ln = vod_ln.
         end. /* FOR LAST vod_det */

         for first ac_mstr
            fields (ac_code ac_desc)
            where ac_code = cu_ex_rnd_acct
         no-lock:
         end. /* FOR FIRST ac_mstr */

         create vod_det.
         assign
            vod_entity   = apmstr.ap_entity
            vod_desc     = if available ac_mstr
                           then
                              ac_desc
                           else
                              " "
            vod_acct     = cu_ex_rnd_acct
            vod_tax_at   = "n"
            vod_ref      = apmstr.ap_ref
            vod_dy_code  = dft-daybook
            vod_ln       = (l_vchr_ln + 1)
            vod_type     = "x"
            vod_amt      = 0
            vod_base_amt = l_rnd_variance.

         if recid(vod_det) = -1
         then .

      end. /* IF AVAILABLE vod_det ELSE DO */

      if  p_vo_confirmed
      and (apmstr.ap_amt  <> old_amt or
           apmstr.ap_vend <> old_vend)
      and available vod_det
      and vod_type = "x"
      then do:

         find first vd_mstr
            where vd_addr = apmstr.ap_vend
         exclusive-lock no-error.

         if available vd_mstr
         then
            vd_balance = vd_balance + l_rnd_variance.

      end. /* IF AVAILABLE vod_det AND ... */

      if  vod_type     = "x"
      and vod_base_amt = 0
      then
         delete vod_det.

   end. /* IF AVAILABLE cu_mstr */
END PROCEDURE. /* p_create_vod_det */