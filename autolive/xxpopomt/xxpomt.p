/* pomt.p - PURCHASE ORDER MAINTENANCE - Regular and Blanket POs              */
/* Copyright 1986 QAD Inc. All rights reserved.                               */
/* $Id:: pomt.p 27571 2013-01-15 07:42:15Z j2x                             $: */
/*                                                                            */
/* MAINTAINS BOTH BLANKET AND REGULAR PURCHASE ORDERS.                        */
/*                                                                            */
/* REVISION: 1.0     LAST MODIFIED: 08/30/86    BY: PML *14*                  */
/* REVISION: 1.0     LAST MODIFIED: 02/11/86    BY: EMB                       */
/* REVISION: 2.0     LAST MODIFIED: 12/19/86    BY: PML *A3*                  */
/* REVISION: 2.0     LAST MODIFIED: 03/12/87    BY: EMB *A41*                 */
/* REVISION: 4.0     LAST MODIFIED: 03/10/88    BY: FLM *A108*                */
/* REVISION: 4.0     LAST MODIFIED: 12/27/87    BY: PML *A119*                */
/* REVISION: 4.0     LAST MODIFIED: 01/14/88    BY: WUG *A145*                */
/* REVISION: 4.0     LAST MODIFIED: 07/26/88    BY: RL  *C0028                */
/* REVISION: 4.0     LAST MODIFIED: 10/25/88    BY: WUG *A494*                */
/* REVISION: 4.0     LAST MODIFIED: 12/13/88    BY: MLB *A560*                */
/* REVISION: 4.0     LAST MODIFIED: 02/27/89    BY: WUG *B038*                */
/* REVISION: 4.0     LAST MODIFIED: 03/16/89    BY: MLB *A673*                */
/* REVISION: 4.0     LAST MODIFIED: 03/24/89    BY: FLM *A685*                */
/* REVISION: 4.0     LAST MODIFIED: 04/11/89    BY: FLM *A708*                */
/* REVISION: 5.0     LAST MODIFIED: 05/16/89    BY: MLB *B118*                */
/* REVISION: 5.0     LAST MODIFIED: 12/21/89    BY: FTB *B466*                */
/* REVISION: 5.0     LAST MODIFIED: 02/27/90    BY: EMB *B591*                */
/* REVISION: 6.0     LAST MODIFIED: 03/21/90    BY: FTB *D011*                */
/* REVISION: 6.0     LAST MODIFIED: 03/22/90    BY: FTB *D013*                */
/* REVISION: 6.0     LAST MODIFIED: 05/21/90    BY: WUG *D002*                */
/* REVISION: 5.0     LAST MODIFIED: 06/11/90    BY: RAM *B706*                */
/* REVISION: 6.0     LAST MODIFIED: 06/20/90    BY: RAM *D030*                */
/* REVISION: 6.0     LAST MODIFIED: 06/29/90    BY: WUG *D043*                */
/* REVISION: 6.0     LAST MODIFIED: 07/06/90    BY: EMB *D040*                */
/* REVISION: 6.0     LAST MODIFIED: 08/13/90    BY: SVG *D058*                */
/* REVISION: 6.0     LAST MODIFIED: 10/18/90    BY: PML *D109*                */
/* REVISION: 6.0     LAST MODIFIED: 10/24/90    BY: RAM *D135*                */
/* REVISION: 6.0     LAST MODIFIED: 10/27/90    BY: pml *D146*                */
/* REVISION: 6.0     LAST MODIFIED: 11/13/90    BY: pml *D221*                */
/* REVISION: 6.0     LAST MODIFIED: 01/02/91    BY: dld *D259*                */
/* REVISION: 6.0     LAST MODIFIED: 01/02/91    BY: MLB *D238*                */
/* REVISION: 6.0     LAST MODIFIED: 01/21/91    BY: dld *D311*                */
/* REVISION: 6.0     LAST MODIFIED: 02/11/91    BY: RAM *D345*                */
/* REVISION: 6.0     LAST MODIFIED: 03/07/91    BY: dld *D409*                */
/* REVISION: 6.0     LAST MODIFIED: 03/08/91    BY: RAM *D410*                */
/* REVISION: 6.0     LAST MODIFIED: 04/08/91    BY: RAM *D502*                */
/* REVISION: 6.0     LAST MODIFIED: 04/11/91    BY: RAM *D518*                */
/* REVISION: 6.0     LAST MODIFIED: 05/07/91    BY: RAM *D621*                */
/* REVISION: 6.0     LAST MODIFIED: 05/09/91    BY: RAM *D634*                */
/* REVISION: 6.0     LAST MODIFIED: 08/15/91    BY: pma *D829**/ /*rev only*/
/* REVISION: 7.0     LAST MODIFIED: 09/12/91    BY: RAM *F033*                */
/* REVISION: 6.0     LAST MODIFIED: 09/24/91    BY: RAM *D872*                */
/* REVISION: 6.0     LAST MODIFIED: 10/10/91    BY: dgh *D892*                */
/* REVISION: 7.0     LAST MODIFIED: 11/08/91    BY: MLV *F029*                */
/* REVISION: 6.0     LAST MODIFIED: 11/11/91    BY: RAM *D921*                */
/* REVISION: 7.0     LAST MODIFIED: 02/04/92    BY: RAM *F163*                */
/* REVISION: 7.0     LAST MODIFIED: 06/19/92    BY: tmd *F458*                */
/* REVISION: 7.0     LAST MODIFIED: 07/01/92    BY: afs *F727*                */
/* REVISION: 7.0     LAST MODIFIED: 07/31/92    BY: afs *F827*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 08/05/92    BY: tjs *G027*                */
/* REVISION: 7.3     LAST MODIFIED: 08/18/92    BY: tjs *G028*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 10/01/92    BY: tjs *G117*                */
/* REVISION: 7.3     LAST MODIFIED: 10/08/92    BY: tjs *G143*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 10/12/92    BY: tjs *G164*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 12/18/92    BY: afs *G465*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 01/05/93    BY: mpp *G481*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 01/06/93    BY: bcm *G417*                */
/* REVISION: 7.3     LAST MODIFIED: 02/11/93    BY: afs *G674*                */
/* REVISION: 7.3     LAST MODIFIED: 02/17/93    BY: tjs *G684*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 02/21/93    BY: afs *G716*                */
/* REVISION: 7.3     LAST MODIFIED: 02/22/93    BY: bcm *G717*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 02/23/93    BY: tjs *G728*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 02/23/93    BY: tjs *G735*                */
/* REVISION: 7.3     LAST MODIFIED: 03/15/93    BY: tjs *G810*                */
/* REVISION: 7.3     LAST MODIFIED: 03/16/93    BY: tjs *G815*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 04/09/93    BY: pma *G928*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 04/19/93    BY: tjs *G964*                */
/* REVISION: 7.3     LAST MODIFIED: 04/29/93    BY: afs *G972*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 05/26/93    BY: kgs *GB37*   (rev only)   */
/* REVISION: 7.4     LAST MODIFIED: 06/07/93    BY: jjs *H006*                */
/* REVISION: 7.4     LAST MODIFIED: 07/02/93    BY: dpm *H015*   (rev only)   */
/* REVISION: 7.4     LAST MODIFIED: 07/02/93    BY: dpm *H017*   (rev only)   */
/* REVISION: 7.4     LAST MODIFIED: 07/02/93    BY: dpm *H018*   (rev only)   */
/* REVISION: 7.4     LAST MODIFIED: 07/02/93    BY: jjs *H024*   (rev only)   */
/* REVISION: 7.4     LAST MODIFIED: 07/21/93    BY: dpm *H034*   (rev only)   */
/* REVISION: 7.4     LAST MODIFIED: 07/30/93    BY: cdt *H047*   (rev only)   */
/* REVISION: 7.4     LAST MODIFIED: 08/09/93    BY: bcm *H062*   (rev only)   */
/* REVISION: 7.4     LAST MODIFIED: 08/12/93    BY: tjs *H065*   (rev only)   */
/* REVISION: 7.4     LAST MODIFIED: 09/07/93    BY: tjs *H082*                */
/* REVISION: 7.4     LAST MODIFIED: 09/29/93    BY: cdt *H086*                */
/* REVISION: 7.4     LAST MODIFIED: 10/28/93    BY: dpm *H198*   (rev only)   */
/* REVISION: 7.4     LAST MODIFIED: 10/23/93    BY: cdt *H184*                */
/* REVISION: 7.4     LAST MODIFIED: 11/14/93    BY: afs *H221*                */
/* REVISION: 7.4     LAST MODIFIED: 02/10/94    BY: dpm *FM06*                */
/* REVISION: 7.4     LAST MODIFIED: 04/19/94    BY: WUG *FN46*                */
/* REVISION: 7.4     LAST MODIFIED: 05/23/94    BY: afs *FM85*                */
/* REVISION: 7.4     LAST MODIFIED: 05/27/94    BY: afs *FO49*                */
/* REVISION: 7.4     LAST MODIFIED: 06/17/94    BY: qzl *H392*                */
/* REVISION: 7.4     LAST MODIFIED: 06/21/94    BY: qzl *H397*                */
/* REVISION: 7.4     LAST MODIFIED: 09/11/94    BY: rmh *GM16*                */
/* REVISION: 7.4     LAST MODIFIED: 09/20/94    BY: ljm *GM74*                */
/* REVISION: 7.4     LAST MODIFIED: 10/27/94    BY: cdt *FS95*                */
/* REVISION: 7.4     LAST MODIFIED: 11/06/94    BY: rwl *GO27*                */
/* REVISION: 8.5     LAST MODIFIED: 11/10/94    BY: mwd *J034*                */
/* REVISION: 8.5     LAST MODIFIED: 02/21/95    BY: dpm *J044*                */
/* REVISION: 8.5     LAST MODIFIED: 03/29/95    BY: dzn *F0PN*                */
/* REVISION: 7.4     LAST MODIFIED: 05/03/95    BY: dxk *G0L7*                */
/* REVISION: 7.4     LAST MODIFIED: 08/16/95    BY: jym *G0V4*                */
/* REVISION: 7.4     LAST MODIFIED: 08/25/95    BY: ais *G0VN*                */
/* REVISION: 7.4     LAST MODIFIED: 09/19/95    BY: ais *G0X6*                */
/* REVISION: 8.5     LAST MODIFIED: 01/15/95    BY: kxn *J0BS*                */
/* REVISION: 8.5     LAST MODIFIED: 09/27/95    BY: taf *J053*                */
/* REVISION: 8.5     LAST MODIFIED: 03/19/96    BY: *J0CV* Robert Wachowicz   */
/* REVISION: 8.5     LAST MODIFIED: 04/09/96    BY: *J0HQ* Gary Morales       */
/* REVISION: 8.5     LAST MODIFIED: 05/15/96    BY: *J0LX* Kieu Nguyen        */
/* REVISION: 8.5     LAST MODIFIED: 07/19/96    BY: *J0ZS* Tamra Farnsworth   */
/* REVISION: 8.5     LAST MODIFIED: 08/16/96    BY: *J146* Sue Poland         */
/* REVISION: 8.6     LAST MODIFIED: 10/22/96    BY: *K004* Kurt De Wit        */
/* REVISION: 8.6     LAST MODIFIED: 12/18/96    BY: *J1CJ* Sue Poland         */
/* REVISION: 8.6     LAST MODIFIED: 01/22/97    BY: *J1B1* Robin McCarthy     */
/* REVISION: 8.6     LAST MODIFIED: 05/16/97    BY: *J1RQ* Suresh Nayak       */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E    LAST MODIFIED: 06/02/98    BY: *L020* Charles Yen        */
/* REVISION: 9.1     LAST MODIFIED: 05/28/99    BY: *J3G1* Santosh Rao        */
/* REVISION: 9.1     LAST MODIFIED: 08/02/99    BY: *N014* Robin McCarthy     */
/* REVISION: 9.1     LAST MODIFIED: 03/02/00    BY: *L0SH* Santosh Rao        */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* Revision: 1.13.2.6      BY: Niranjan Ranka      DATE: 05/24/00 ECO: *N0C7* */
/* Revision: 1.13.2.7      BY: Mudit Mehta         DATE: 07/06/00 ECO: *N0F3* */
/* Revision: 1.13.2.8      BY: Pat Pigatti         DATE: 07/14/00 ECO: *N0G2* */
/* Revision: 1.13.2.9      BY: Ashwini Ghaisas     DATE: 07/24/00 ECO: *J3Q2* */
/* Revision: 1.13.2.10     BY: Anup Pereira        DATE: 07/10/00 ECO: *N059* */
/* Revision: 1.13.2.11     BY: Ashwini Ghaisas     DATE: 08/18/00 ECO: *J3Q4* */
/* Revision: 1.13.2.12     BY: Ashwini Ghaisas     DATE: 09/06/00 ECO: *M0S8* */
/* Revision: 1.13.2.13     BY: Mudit Mehta         DATE: 09/26/00 ECO: *N0W9* */
/* Revision: 1.13.2.14     BY: Katie Hilbert       DATE: 04/01/01 ECO: *P002* */
/* Revision: 1.13.2.15     BY: Jean Miller         DATE: 12/12/01 ECO: *P03N* */
/* Revision: 1.13.2.16     BY: John Pison          DATE: 03/13/02 ECO: *N1BT* */
/* Revision: 1.13.2.17     BY: John Pison          DATE: 03/15/02 ECO: *N1D7* */
/* Revision: 1.13.2.18     BY: Dan Herman          DATE: 05/24/02 ECO: *P018* */
/* Revision: 1.13.2.22     BY: Andrea Suchankova   DATE: 10/15/02 ECO: *N13P* */
/* Revision: 1.13.2.23     BY: Narathip W.         DATE: 05/02/03 ECO: *P0R5* */
/* Revision: 1.13.2.25     BY: Paul Donnelly(SB)   DATE: 06/28/03 ECO: *Q00J* */
/* Revision: 1.13.2.27     BY: Dipesh Bector       DATE: 12/26/03 ECO: *P1H9* */
/* Revision: 1.13.2.28     BY: Salil Pradhan       DATE: 01/12/04 ECO: *P1HT* */
/* Revision: 1.13.2.29     BY: Bhagyashri Shinde   DATE: 02/27/04 ECO: *P1R1* */
/* Revision: 1.13.2.30     BY: Subramanian Iyer    DATE: 03/19/04 ECO: *N2QC* */
/* Revision: 1.13.2.31     BY: Ed van de Gevel     DATE: 03/07/05 ECO: *R00K* */
/* Revision: 1.13.2.32     BY: Tejasvi Kulkarni    DATE: 04/28/05 ECO: *P3JJ* */
/* Revision: 1.13.2.33     BY: Robin McCarthy      DATE: 09/01/05 ECO: *P2PJ* */
/* Revision: 1.13.2.34     BY: Andrew Dedman       DATE: 10/13/05 ECO: *R01P* */
/* Revision: 1.13.2.35     BY: Shilpa Kamath       DATE: 11/03/05 ECO: *R02B* */
/* Revision: 1.13.2.36     BY: Steve Nugent        DATE: 03/21/06 ECO: *R001* */
/* Revision: 1.13.2.37     BY: Robin McCarthy      DATE: 05/31/06 ECO: *R02F* */
/* Revision: 1.13.2.38     BY: Katie Hilbert       DATE: 07/19/06 ECO: *R07D* */
/* Revision: 1.13.2.39     BY: Prerita Joshi       DATE: 08/04/06 ECO: *P4XY* */
/* Revision: 1.13.2.46     BY: Ajit Philip.        DATE: 06/13/07 ECO: *Q15G* */
/* Revision: 1.13.2.47     BY: Ken Casey           DATE: 04/12/07 ECO: *R0C6* */
/* Revision: 1.13.2.50     BY: Rajalaxmi Ganji     DATE: 09/09/08 ECO: *R13V* */
/* Revision: 1.13.2.53     BY: Nan Zhang           DATE: 10/10/08 ECO: *R15P* */
/* Revision: 1.13.2.54     BY: Neil Curzon         DATE: 04/30/09 ECO: *R1HB* */
/* Revision: 1.13.2.55     BY: Yizhou Mao          DATE: 07/20/09 ECO: *R1M6* */
/* $Revision: 1.13.2.56 $  BY: Chandrakant Ingale  DATE: 02/02/10 ECO: *Q3T3* */
/*-Revision end---------------------------------------------------------------*/
 
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
 
/* ************************************************************************** */
/* Note: This code has been modified to run when called inside an MFG/PRO API */
/* method as well as from the MFG/PRO menu, using the global variable         */
/* c-application-mode to conditionally execute API- vs. UI-specific logic.    */
/* Before modifying the code, please review the MFG/PRO API Development Guide */
/* in the QAD Development Standards for specific API coding standards and     */
/* guidelines.                                                                */
/* ************************************************************************** */
 
/* DISPLAY TITLE */
{us/mf/mfdtitle.i}
/* Clear anything displayed by mftitle if api mode.*/
{us/mf/mfaititl.i}
{us/px/pxmaint.i}
 
/* Include 'getnbr' */
{us/gp/gpnbrgen.i}
{us/ap/apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */
 
/* ************************* INPUT-OUTPUT PARAMETERS ************************ */
define input parameter pBlanket as logical no-undo.
 
/* **************************** SHARED VARIABLES **************************** */
define new shared variable rndmthd  like rnd_rnd_mthd.
define new shared variable oldcurr  like po_curr.
define new shared variable line     like pod_line.
define new shared variable due_date like pod_due_date.
define new shared variable del-yn   like mfc_logical.
define new shared variable qty_ord  like pod_qty_ord.
define new shared variable so_job   like pod_so_job.
define new shared variable sngl_ln  like poc_ln_fmt.
define new shared variable disc     like pod_disc label "Ln Disc".
define new shared variable po_recno as recid.
define new shared variable vd_recno as recid.
define new shared variable yn       like mfc_logical initial yes.
define new shared variable ponbr    like po_nbr.
define new shared variable old_po_stat like po_stat.
define new shared variable line_opened as logical.
define new shared variable old_rev  like po_rev.
define new shared variable pocmmts  like mfc_logical label "Comments".
define new shared variable cmtindx  as integer.
define new shared variable base_amt like pod_pur_cost.
define new shared variable comment_type like po_lang.
define new shared variable new_po   like mfc_logical.
define new shared variable new_db   like si_db.
define new shared variable old_db   like si_db.
define new shared variable new_site like si_site.
define new shared variable old_site like si_site.
define new shared variable continue like mfc_logical no-undo.
define new shared variable tax_recno as recid.
define new shared variable poc_pc_line like mfc_logical initial yes.
define new shared variable impexp      like mfc_logical no-undo.
define new shared variable blanket as logical.
define new shared variable l_include_retain like mfc_logical
   initial yes no-undo.
 
/* NEW SHARED FRAMES */
define new shared frame a.
define new shared frame b.
define new shared frame vend.
define new shared frame ship_to.
 
/* ******************************** VARIABLES ******************************* */
define variable zone_to        like txe_zone_to.
define variable zone_from      like txe_zone_from.
define variable old_vend       like po_vend.
define variable old_ship       like po_ship.
define variable impexp_edit    like mfc_logical            no-undo.
define variable upd_okay       like mfc_logical            no-undo.
define variable dummyCharValue as character                no-undo.
define variable old_ers_opt    like po_ers_opt             no-undo.
define variable l_rebook_lines like mfc_logical initial no no-undo.
define variable poTrans as character no-undo.
define variable extKey as character no-undo.
define variable vend as character no-undo.
define variable l_leave        like mfc_logical            no-undo.
define variable imp-okay as logical no-undo.
define variable hBlockedTransactionlibrary as handle       no-undo.
define variable use-log-acctg   as logical    no-undo.
 
/* Global Shipping: Use Seq ID to generate PO nbr */
define variable l_errorst  like mfc_logical        no-undo.
define variable c_ponrm    like po_nrm             no-undo.
define variable i_errornum as   integer            no-undo.
define variable use_nrmseq as   logical initial no no-undo.
 
define variable lLegacyAPI as logical no-undo.
define variable l_api_undo as logical initial no no-undo.

define temp-table tt_nrm
   field tt_dataset like nr_dataset
   field tt_seqid   like nr_seqid
   field tt_nbrtype as   character
index idx_seqid_pk is unique primary tt_seqid.
 
form
   tt_seqid
with frame frame_seqid side-labels overlay row 2 columns 12.
 
setFrameLabels(frame frame_seqid:handle).
 
/* COMMON API CONSTANTS AND VARIABLES */
{us/mf/mfaimfg.i}
 
/* PURCHASE ORDER API TEMP-TABLE, NAMED USING THE "Api" PREFIX */
{us/po/popoit01.i}
 
{us/ic/icieit01.i}
{us/mf/mfctit01.i}
 
{us/po/pocnvars.i} /* Variables for consignment inventory */
{us/po/pocnpo.i}  /* Consignment procedures */
/*CHECK IF USER IS IN VIEWER MODE */
{us/gp/gpvwckhd.i}
 
/* PURCHASE ORDER MAINTENANCE API dataset definition */
{us/po/podsmt.i "reference-only"}
if c-application-mode = "API" then do on error undo, return:
 
   /* Get handle of API Controller */
   {us/bbi/gprun.i ""gpaigach.p"" "(output ApiMethodHandle)"}
 
   if valid-handle(ApiMethodHandle) then do:
      /* Get the PURCHASE ORDER MAINTENANCE API dataset from the controller */
      run getRequestDataset in ApiMethodHandle (
         output dataset dsPurchaseOrder bind).
 
      lLegacyAPI = false.
   end.
   else do:
      /* GET HANDLE OF API CONTROLLER */
      {us/bbi/gprun.i ""gpaigh.p""
               "(output ApiMethodHandle,
                 output ApiProgramName,
                 output ApiMethodName,
                 output apiContextString)"}
 
      /* GET LOCAL PO MASTER TEMP-TABLE */
      create ttPurchaseOrder.
      run getPurchaseOrderRecord in ApiMethodHandle
         (buffer ttPurchaseOrder).
 
      run getpoTrans in ApiMethodHandle
         (output poTrans).

      run getPurchaseOrderCmt in ApiMethodHandle
         (output table ttPurchaseOrderCmt).
      lLegacyAPI = true.
   end.

end.  /* If c-application-mode = "API" */
 
/*============================================================================*/
/* ****************************** Main Block ******************************** */
/*============================================================================*/
 
/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{us/bbi/gprun.i ""gpmfc01.p""
         "(input  ENABLE_SUPPLIER_CONSIGNMENT,
           input  11,
           input  ADG,
           input  SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}
 
assign
   blanket = pBlanket
   old_db = global_db.
 
/* DEFINE ROUND VARIABLES REQUIRED FOR PURCHASE ORDERS & RTS */
{us/po/pocurvar.i "NEW"}
/* DEFINE ROUND VARIABLES REQUIRED FOR TAX CALCULATIONS */
{us/tx/txcurvar.i "NEW"}
 
/* DEFINE TRAILER VARS AS NEW, SO THAT CORRECT _OLD FORMATS */
/* CAN BE ASSIGNED BASED ON INITIAL DEFINE                  */
{us/po/potrldef.i "NEW"}
 
{us/px/pxrun.i &PROC='initialize-variables'}
 
l_include_retain = no.
 
/* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
{us/bbi/gprun.i ""lactrl.p"" "(output use-log-acctg)"}
 
mainloop:
repeat:
 
   if c-application-mode = "API" and retry then
      return error.
 
   if c-application-mode = "API" and not lLegacyAPI then do:
      run getNextRecord in ApiMethodHandle (input "ttPurchaseOrderMaintenance").
      if return-value = {&RECORD-NOT-FOUND} then return.
   end.

   for first gl_ctrl where gl_domain = global_domain no-lock: end.
 
   assign
      so_job = ""
      disc = 0
      comment_type = global_type.
 
   {us/po/popomt02.i}  /* Shared frames a and b */
 
   /* ADDRESS FORMS */
   /* VENDOR ADDRESS */
   {us/mf/mfadform.i "vend" 1 SUPPLIER}
   /* SHIP TO ADDRESS */
   {us/mf/mfadform.i "ship_to" 41 SHIP_TO}
 
   if c-application-mode <> "API" then do:
      view frame dtitle.
      view frame a.
      view frame vend.
      view frame ship_to.
      view frame b.
   end.
 
   if c-application-mode = "API" and lLegacyAPI then do:
      if poTrans = "GETPONUM" then do:
         {us/px/pxrun.i &PROC='get-input'}
 
         assign ttPurchaseOrder.nbr = ponbr.
 
         run setPurchaseOrderRecord in ApiMethodHandle
            (buffer ttPurchaseOrder).
 
         return.
      end.
      else
         assign ponbr = ttPurchaseOrder.nbr.
   end. /* if c-application-mode = "API" */
 
   if c-application-mode <> "API" or
      (c-application-mode = "API" and not lLegacyAPI) then do:
      l_leave = yes.
 
      /* Check is any NRM sequences defined for Numbering */
      use_nrmseq = can-find(first nr_mstr
                            where nr_domain  = global_domain
                            and   nr_dataset begins "po_nbr."
                            and   nr_effdate <= today
                            and   (nr_exp_date = ? or nr_exp_date >=today)).
 
      c_ponrm = "".
 
      {us/px/pxrun.i &PROC='get-input'}
 
      if (c-application-mode <> "API" and keyfunction(lastkey) = "end-error")
         or (c-application-mode = "API" and l_api_undo) then
         undo mainloop, leave mainloop.
   end.
 
   do transaction on error undo, retry:
 
      if c-application-mode = "API" and retry then
         return error.
 
      for first poc_ctrl where poc_domain = global_domain no-lock: end.
      if not available poc_ctrl then do:
         create poc_ctrl.
         poc_domain = global_domain.
      end.
 
      assign
         sngl_ln = poc_ln_fmt
         pocmmts = poc_hcmmts.
 
      {us/px/pxrun.i &PROC='processRead' &PROGRAM='popoxr.p'
               &PARAM="(input ponbr,
                        buffer po_mstr,
                        input yes,
                        input yes)"
               &NOAPPERROR=true &CATCHERROR=true}
 
      if return-value = {&RECORD-NOT-FOUND} then do:
         clear frame vend.
         clear frame ship_to.
         clear frame b.
 
         /** For Qxtend to provide order number as part of message
          *  and then to made available with context for response
          *  In case of auto generated, response qdoc is void of
          *  context
          **/
 
 
         /* ADDING NEW RECORD */
         if {us/gp/gpisapi.i} then
            {us/bbi/pxmsg.i &MSGNUM=1 &ERRORLEVEL={&INFORMATION-RESULT} &MSGARG1=ponbr}
         else
            {us/bbi/pxmsg.i &MSGNUM=1 &ERRORLEVEL={&INFORMATION-RESULT}}
         .
 
         new_po = yes.
 
         {us/px/pxrun.i &PROC='createPurchaseOrder' &PROGRAM='popoxr.p'
                  &PARAM="(input ponbr,
                           input c_ponrm,
                           buffer po_mstr)"
                  &NOAPPERROR=true &CATCHERROR=true}
 
         {us/px/pxrun.i &PROC='initializeBlanketPO' &PROGRAM='popoxr.p'
                  &PARAM="(input blanket,
                           buffer po_mstr)"
                  &NOAPPERROR=true &CATCHERROR=true}
 
         if recid(poc_ctrl) = -1 then.
 
         if c-application-mode = "API" and lLegacyAPI then do:
            {us/bbi/gprun.i ""gpxrcrln.p""
                     "(input po_nbr,
                       input 0,
                       input ttPurchaseOrder.extRef,
                       input 0,
                       input 'po',
                       input '',
                       input '',
                       input '',
                       input '')"}
          end.
 
      end.  /* IF NOT AVAILABLE PO_MSTR */
      else do:
         /* CHECK IF SCHEDULED ORDER */
         {us/px/pxrun.i &PROC='validateScheduledOrder' &PROGRAM='popoxr.p'
                  &PARAM="(input po_sched,
                           input {&APP-ERROR-NO-REENTER-RESULT})"
                  &NOAPPERROR=true &CATCHERROR=true}
 
         if return-value <> {&SUCCESS-RESULT} then do:
            if c-application-mode <> "API" then do:
               next-prompt po_nbr.
               undo mainloop, retry mainloop.
            end.
            else
               undo mainloop, return error.
         end.
 
         if po_stat = "c" then do:
            /* PURCHASE ORDER CLOSED */
            {us/bbi/pxmsg.i &MSGNUM=326 &ERRORLEVEL={&INFORMATION-RESULT}}
         end.
 
         if po_stat = "x" then do:
            /* PURCHASE ORDER CANCELLED */
            {us/bbi/pxmsg.i &MSGNUM=395 &ERRORLEVEL={&INFORMATION-RESULT}}
         end.
 
         {us/px/pxrun.i &PROC='validatePODataBase' &PROGRAM='popoxr1.p'
                  &PARAM="(input po_nbr)"
                  &NOAPPERROR=true &CATCHERROR=true}
 
         if return-value <> {&SUCCESS-RESULT} then do:
            if c-application-mode <> "API" then
               undo mainloop, retry mainloop.
            else
               undo mainloop, return error.
         end.
 
         new_po = no.
 
         /* SUPPRESS THIS CODE IF INVOKED IN VIEWER MODE */
         if not isViewer then do:
            /* MODIFYING EXISTING RECORD */
            {us/bbi/pxmsg.i &MSGNUM=10 &ERRORLEVEL={&INFORMATION-RESULT}}
         end.
 
         if c-application-mode <> "API" then do:
           /* DISPLAY VENDOR ADDRESS */
           {us/mf/mfaddisp.i po_vend vend}
         end. /* c-application-mode <> "API" */

         {us/px/pxrun.i &PROC='validateBlanketPO'
                  &PROGRAM='popoxr.p'
                  &PARAM="(input po_type,
                           input blanket)"
                  &NOAPPERROR=true &CATCHERROR=true}
 
         if return-value <> {&SUCCESS-RESULT} then do:
            if c-application-mode <> "API" then
               undo mainloop, retry mainloop.
            else
               undo mainloop, return error.
         end.
 
         if c-application-mode <> "API" then
            {us/mf/mfaddisp.i po_ship ship_to}
 
         disc = po_disc_pct.
 
         {us/px/pxrun.i &PROC='getFirstPOLine' &PROGRAM='popoxr1.p'
                  &PARAM="(input po_nbr,
                           buffer pod_det)"
                  &NOAPPERROR=true &CATCHERROR=true}
 
         if available pod_det then
            so_job = pod_so_job.
 
         {us/px/pxrun.i &PROC='validateSiteSecurity' &PROGRAM='icsixr.p'
                  &PARAM="(input po_site,
                           input '')"
                  &NOAPPERROR=true &CATCHERROR=true}
 
         if return-value <> {&SUCCESS-RESULT} then do:
            if c-application-mode <> "API" then do:
               display
                  po_nbr
                  po_vend
                  po_ship
               with frame a.
 
               display
                  po_ord_date
                  po_due_date
                  po_buyer
                  po_bill
                  so_job
                  po_contract
                  po_contact
                  po_rmks
                  po_pr_list2
                  po_pr_list
                  disc
                  po_site
                  po_daybookset
                  po_project
                  po_confirm
                  po_curr
                  po_lang
                  po_taxable
                  po_taxc
                  po_tax_date
                  po_fix_pr
                  po_consignment
                  po_cr_terms
                  po_crt_int
                  po_user_id
                  po_req_id
                  pocmmts
               with frame b.
 
               pause.
               undo mainloop, retry.
            end.
            else
               undo mainloop, return error.
         end.
      end.   /* ELSE DO (available po_mstr) */
 
      if c-application-mode = "API" and lLegacyAPI then
         assign {us/mf/mfaiset.i po_app_owner ttPurchaseOrder.appOwner}.
 
      assign
         recno = recid(po_mstr).
 
      if po_cmtindx <> 0
      then
         pocmmts = yes.
      else if not new_po
      then
         pocmmts = no.
 
      if c-application-mode <> "API" then do:
         display
            po_nbr
            po_vend
            po_ship
         with frame a.
 
         display
            po_ord_date
            po_due_date
            po_buyer
            po_bill
            so_job
            po_contract
            po_contact
            po_rmks
            po_pr_list2
            po_pr_list
            disc
            po_site
            po_daybookset
            po_project
            po_confirm
            po_curr
            po_lang
            po_taxable
            po_taxc
            po_tax_date
            po_fix_pr
            po_consignment
            po_cr_terms
            po_crt_int
            po_user_id
            po_req_id
            pocmmts
         with frame b.
      end.  /* If c-application-mode <> "API" */
 
      assign
         old_vend = po_vend
         old_ship = po_ship.
 
      vendblk:
      do on error undo, retry:
         if retry and c-application-mode = "API" then
            return error.
 
         if c-application-mode <> "API" then do:
            prompt-for po_mstr.po_vend with frame a
            editing:
 
               /* FIND NEXT/PREVIOUS  RECORD */
               {us/mf/mfnp.i vd_mstr po_vend  " vd_mstr.vd_domain = global_domain and
                    vd_addr "  po_vend vd_addr vd_addr}
 
               if recno <> ? then do:
                  po_vend = vd_addr.
                  display
                     po_vend
                  with frame a.
 
                  for first ad_mstr
                     where ad_domain = global_domain
                     and   ad_addr = vd_addr
                  no-lock: end.
                  {us/mf/mfaddisp.i po_vend vend}
               end.
            end.
         end. /* if c-application-mode <>"API" */
         else do:
            if lLegacyAPI then do:
               assign
                  vend = po_vend
                  {us/mf/mfaiset.i vend ttPurchaseOrder.vend}.
 
               for first vd_mstr
                  where vd_domain = global_domain
                  and   vd_addr = vend
               no-lock: end.
 
               if not available vd_mstr then do:
                  /* Not a valid supplier */
                  {us/bbi/pxmsg.i &MSGNUM = 2 &ERRORLEVEL = 3}
                  undo, return error.
               end.
            end.
            else do:
               assign
               {us/mf/mfaistvl.i po_vend ttPurchaseOrderMaintenance.poVend}
               .
            end.
         end.
 
         /* DO NOT ALLOW MOD TO VENDOR IF ANY RECEIPTS */
         if (not new_po and po_vend <> old_vend) or
            (not new_po and po_vend entered)
         then do:
            {us/px/pxrun.i &PROC='validateSupplierReceipts' &PROGRAM='popoxr.p'
                     &PARAM="(input old_vend,
                              input po_nbr)"
                     &NOAPPERROR=true &CATCHERROR=true}
 
            if return-value <> {&SUCCESS-RESULT} then do:
               if c-application-mode <> "API" then do:
                  display old_vend @ po_vend with frame a.
                  next-prompt po_vend.
                  clear frame vend.
                  undo, retry.
               end.
               else
                  undo vendblk, return error.
            end.
            else
               l_rebook_lines = yes.
         end.
 
         if c-application-mode <> "API" then
            /* DISPLAY VENDOR ADDRESS */
            {us/mf/mfaddisp.i "input po_vend" vend}
 
         if not new_po and input po_vend <> old_vend
         then do:
            {us/px/pxrun.i &PROC='validateScheduledOrder' &PROGRAM='popoxr.p'
                     &PARAM="(input po_sched,
                              input {&APP-ERROR-RESULT})"
                     &NOAPPERROR=true &CATCHERROR=true}
 
            if return-value <> {&SUCCESS-RESULT} then do:
               if c-application-mode <> "API" then do:
                  clear frame vend.
                  display old_vend @ po_vend with frame a.
                  undo, retry.
               end.
               else
                  undo, return error.
            end.
         end.
 
         /* start blocked transaction library to run persistently */
         run mfairunh.p
            (input "mgbltrpl.p",
             input  ?,
             output hBlockedTransactionlibrary).
 
         {us/mg/mgbltrpl.i "hBlockedTransactionlibrary"}
 
         /* Check to see if blanket order or not */
         if pBlanket = true then do:
            /* Blanket order */
            /* Check to see if Supplier has any blocked transactions */
            if blockedSupplier(input input po_vend,
                               input {&PO003},
                               input true,
                               input "Supplier")
            then do:
               undo vendblk, retry.
            end.
         end. /* End if pBlanket */
         else do:
 
            /* Normal PO */
            /* Check to see if Supplier has any blocked transactions */
            if blockedSupplier(input input po_vend,
                               input {&PO009},
                               input true,
                               input "Supplier")
            then do:
               undo vendblk, retry.
            end.
         end.
 
         delete PROCEDURE hBlockedTransactionlibrary.
 
      end. /* vendblk */
 
      if c-application-mode <> "API" then do:
         {us/px/pxrun.i &PROC='validateSupplier' &PROGRAM='popoxr.p'
                  &PARAM="(input po_vend:screen-value)"
                  &NOAPPERROR=true &CATCHERROR=true}
      end.
      else do:
         if lLegacyAPI then do:
            assign
               vend = po_vend
               {us/mf/mfaiset.i vend ttPurchaseOrder.vend}.
         end. /* if lLegacyAPI */
         else do:
            assign
               vend = po_vend
               .
         end.
 
         {us/px/pxrun.i &PROC='validateSupplier' &PROGRAM='popoxr.p'
                  &PARAM="(input vend)"
                  &NOAPPERROR=true &CATCHERROR=true}
      end.
 
      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt po_vend with frame a.
            undo, retry.
         end.
         else
            undo, return error.
      end.
 
      if not available vd_mstr then do:
         /* USER ENTERED A SPECIFIC SUPPLIER NUMBER,         */
         /* WE NEED THE RECORD FOR THE RECID FUNCTION BELOW. */
         if c-application-mode <> "API" then do:
            {us/px/pxrun.i &PROC='processRead' &PROGRAM='adsuxr.p'
                     &PARAM="(input po_vend:screen-value,
                              buffer vd_mstr,
                              input no,
                              input yes)"
                     &NOAPPERROR=true &CATCHERROR=true}
         end.
         else do:
            {us/px/pxrun.i &PROC='processRead' &PROGRAM='adsuxr.p'
                     &PARAM="(input vend,
                              buffer vd_mstr,
                              input no,
                              input yes)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
         end.
      end.
 
      if new_po then do:
         if c-application-mode <> "API" then do:
            {us/px/pxrun.i &PROC='setSupplierDefaults' &PROGRAM='popoxr.p'
                     &PARAM="(input input po_vend,
                              buffer po_mstr)"}
         end.
         else do:
            {us/px/pxrun.i &PROC='setSupplierDefaults' &PROGRAM='popoxr.p'
                     &PARAM="(input vend,
                              buffer po_mstr)"}
         end.
 
         if po_cr_terms <> "" then do:
            {us/px/pxrun.i &PROC='getCreditTermsInterest' &PROGRAM='adcrxr.p'
                     &PARAM="(input  po_cr_terms,
                              output po_crt_int)"}
         end.
 
         if c-application-mode <> "API" then do:
            {us/px/pxrun.i &PROC='getTaxDataSupplier' &PROGRAM='adadxr.p'
                     &PARAM="(input input po_vend,
                              output po_taxable,
                              output po_taxc,
                              output po_tax_in,
                              output dummyCharValue,   /* Tax Type */
                              output po_tax_usage,
                              output dummyCharValue)"} /* Zone From */
         end.
         else do:
            {us/px/pxrun.i &PROC='getTaxDataSupplier' &PROGRAM='adadxr.p'
                     &PARAM="(input vend,
                              output po_taxable,
                              output po_taxc,
                              output po_tax_in,
                              output dummyCharValue,   /* Tax Type */
                              output po_tax_usage,
                              output dummyCharValue)"} /* Zone From */
         end.
 
         /* IF USING SUPPLIER CONSIGNMENT THEN INITIALIZE */
         /* CONSIGNMENT FIELDS.   */
         if using_supplier_consignment then do:
            {us/px/pxrun.i &PROC = 'initializeSuppConsignFields'
                     &PARAM="(input po_vend,
                              output po_consignment,
                              output po_max_aging_days,
                              output po_consign_cost_point)"}
 
            if return-value <> {&SUCCESS-RESULT} then do:
               if return-value = "3388" then do:
                  {us/bbi/pxmsg.i &MSGNUM=return-value &ERRORLEVEL=3
                           &MSGARG1=getTermLabel(""SUPPLIER_CONSIGNMENT"",30)}
               end.
               else do:
                  {us/bbi/pxmsg.i &MSGNUM=return-value &ERRORLEVEL=2}
               end.
 
               if c-application-mode <> "API" then do:
                  next-prompt po_vend with frame a.
                  undo, retry.
               end.
               else
                  undo mainloop, return error.
            end. /* if return-value <> */
 
            if c-application-mode <> "API" then
               display po_consignment with frame b.
         end. /* IF using_supplier_consignment */
      end. /* If new_po */
 
      if (c-application-mode <>  "API" or (c-application-mode = "API"
         and not lLegacyAPI)) then do:
         if ((not new_po) and (old_vend <> input po_vend))
         then do:
            {us/px/pxrun.i &PROC='validateSupplierCurrency' &PROGRAM='popoxr.p'
                     &PARAM="(input po_curr,
                              input input po_vend)"
                     &NOAPPERROR=true &CATCHERROR=true}
 
            if return-value <> {&SUCCESS-RESULT} then do:
               if c-application-mode <> "API" then
               next-prompt po_vend.
               undo, retry.
            end.
         end.
      end.
      else do:
         if ((not new_po) and
            (ttPurchaseOrder.vend <> ?) and
            (old_vend <> ttPurchaseOrder.vend))
         then do:
 
            {us/px/pxrun.i &PROC='validateSupplierCurrency' &PROGRAM='popoxr.p'
                     &PARAM="(input po_curr,
                              input ttPurchaseOrder.vend)"
                     &NOAPPERROR=true &CATCHERROR=true}
 
            if return-value <> {&SUCCESS-RESULT} then do:
               undo mainloop, return error.
            end.
         end.
      end.
 
      if c-application-mode <> "API" then
         assign
            po_vend = input po_vend.
      else do:
         if lLegacyAPI then
            assign
               {us/mf/mfaiset.i po_vend ttPurchaseOrder.vend}.
         else
            assign
               {us/mf/mfaiset.i po_vend ttPurchaseOrderMaintenance.poVend}.
      end.
 
      vd_recno = recid(vd_mstr).
 
      do on error undo, retry:
         if retry and c-application-mode = "API" then
            return error.
 
         if c-application-mode <> "API" then do:
            prompt-for po_mstr.po_ship with frame a
            editing:
               /* FIND NEXT/PREVIOUS  RECORD */
               {us/mf/mfnp.i ad_mstr po_ship  " ad_mstr.ad_domain = global_domain and
                    ad_addr "  po_ship ad_addr ad_addr}
               if recno <> ? then do:
                  po_ship = ad_addr.
                  display po_ship with frame a.
                  /* DISPLAY SHIP TO ADDRESS */
                  {us/mf/mfaddisp.i po_ship ship_to}
               end.
            end.
 
            {us/px/pxrun.i &PROC='validateShipTo' &PROGRAM='popoxr.p'
                     &PARAM="(input input po_ship)"
                     &NOAPPERROR=true &CATCHERROR=true}
 
         end.     /*if c-application-mode <> "API"*/
         else do:
            if lLegacyAPI then do:
               assign
               {us/mf/mfaiset.i po_ship ttPurchaseOrder.ship}.
 
               {us/px/pxrun.i &PROC='validateShipTo' &PROGRAM='popoxr.p'
                        &PARAM="(input po_ship)"
                        &NOAPPERROR=true &CATCHERROR=true}
            end. /* if lLegacyAPI */
            else do:
               assign
               {us/mf/mfaistvl.i po_ship ttPurchaseOrderMaintenance.poShip}.

               {us/px/pxrun.i &PROC='validateShipTo' &PROGRAM='popoxr.p'
                        &PARAM="(input input po_ship)"
                        &NOAPPERROR=true &CATCHERROR=true}
            end.
         end.
 
         if return-value <> {&SUCCESS-RESULT} then do:
            if c-application-mode <> "API" then
               undo, retry.
            else
               undo mainloop, return error.
         end.
 
         if c-application-mode <> "API" then do:
            assign
               po_ship = input po_ship.
            {us/mf/mfaddisp.i po_ship ship_to}
         end.
         else do:
            if not lLegacyAPI then
               po_ship = input po_ship.

            for first ad_mstr
               where ad_domain = global_domain
               and   ad_addr = po_ship
            no-lock: end.
 
            if not available ad_mstr then do:
               /* Not a valid choice */
               {us/bbi/pxmsg.i &MSGNUM = 13 &ERRORLEVEL = 3}
            end.
         end.
      end.   /* DO ON ERROR */
 
      /* SET GLOBAL REFERENCE VARIABLE FOR COMMENTS TO VENDOR */
      assign
         global_ref = po_vend
         po_recno   = recid(po_mstr)
         continue   = no
         del-yn     = no.
 
      /* PURCHASE ORDER MAINTENANCE -- ORDER HEADER subroutine */

      {us/bbi/gprun.i ""xxpomtb.p"" "(input using_supplier_consignment)"}
 
      if c-application-mode <> "API" then do:
         if del-yn then
            next mainloop.
         if continue = no then
            undo mainloop, retry.
      end.
      else do:
         if del-yn then
            return.
         if continue = no then
            undo mainloop, return error.
      end.
 
      if (oldcurr <> po_curr) or oldcurr = "" then do:
         /* SET CURRENCY DEPENDENT FORMATS */
         {us/po/pocurfmt.i}
         oldcurr = po_curr.
      end.
 
      {us/px/pxrun.i &PROC='getTaxDate' &PROGRAM='popoxr.p'
               &PARAM="(input po_tax_date,
                        input po_due_date,
                        input po_ord_date,
                        output tax_date)"
               &NOAPPERROR=true &CATCHERROR=true}
 
      /* DO NOT REBOOK LINES IF INVOKED IN VIEWER MODE */
      if isViewer then l_rebook_lines = false .
 
      if l_rebook_lines and
         not pBlanket
      then do:
         {us/bbi/gprun.i ""pomtrb.p"" "(input old_vend)"}.
         l_rebook_lines = no.
      end.
 
      /* FIND LAST LINE */
      line = 0.
 
      {us/px/pxrun.i &PROC='getLastPOLine' &PROGRAM='popoxr1.p'
               &PARAM="(input po_nbr,
                        output line)"
               &NOAPPERROR=true &CATCHERROR=true}
 
      po_recno = recid(po_mstr).
 
      /* IF BLANKET PO THEN BRING UP EXTRA SCREEN */
      if pBlanket then do:
         hide frame b no-pause.
         {us/bbi/gprun.i ""poblmt1.p""}
      end.
 
      hide frame a no-pause.
      hide frame vend no-pause.
      hide frame ship_to no-pause.
      hide frame b no-pause.
 
      /*COMMENTS */
      assign
         global_type = ""
         global_lang = po_lang.
 
      if pocmmts = yes then do on error undo mainloop, retry:
         if c-application-mode = "API" and lLegacyAPI then do:
            {us/gp/gpttcp.i ttPurchaseOrderCmt
                      ttTransComment
                     "ttPurchaseOrderCmt.apiExternalKey =
                      ttPurchaseOrder.apiExternalKey"}
 
            run setTransComment in ApiMethodHandle
               (input table ttTransComment).
         end.
 
         assign
            global_ref = po_vend
            cmtindx = po_cmtindx.
 
         if c-application-mode = "API" and not lLegacyAPI then do:
            run setCommonDataBuffer in ApiMethodHandle
               (input "ttPurchaseOrderComments").
         end.

         {us/bbi/gprun.i ""gpcmmt01.p"" "(input ""po_mstr"")"}
 
         if c-application-mode = "API" and not lLegacyAPI then do:
            run setCommonDataBuffer in ApiMethodHandle
               (input "").
         end.

         po_cmtindx = cmtindx.
 
      end.
   end.
 
   due_date = po_due_date.
 

   /* LINE ITEMS */
   {us/bbi/gprun.i ""popomta.p""}
 
   if use-log-acctg = TRUE and
      can-find (first lacd_det
                where lacd_domain            = global_domain
                  and lacd_internal_ref      = po_nbr
                  and lacd_shipfrom          = po_vend
                  and lacd_internal_ref_type = {&TYPE_PO}
                  no-lock)
   then do:
      if c-application-mode = "API" and not lLegacyAPI then do:
         run setCommonDataBuffer in ApiMethodHandle
            (input "ttLogisticsChargesDetail").
      end.

      {us/bbi/gprun.i ""lacamts.p""
         "(input global_domain,
           input '',
           input po_nbr,
           input '{&TYPE_PO}',
           input po_vend)"}.

      if c-application-mode = "API" and not lLegacyAPI then do:
         run setCommonDataBuffer in ApiMethodHandle
            (input "").
      end.
    end.
   /* TRAILER */
   hide all.
   if c-application-mode <> "API" then do:
      view frame dtitle.
      view frame a.
   end.
 
   if c-application-mode = "API" and not lLegacyAPI then do:
      run setCommonDataBuffer in ApiMethodHandle
         (input "ttPurchaseOrderTrailer").
   end.

   {us/bbi/gprun.i ""popomtf.p""}
 

   if c-application-mode = "API" and not lLegacyAPI then do:
      run setCommonDataBuffer in ApiMethodHandle
         (input "").
   end.

   /* IF IMPORT EXPORT FLAG IS SET TO YES CALL THE IMPORT EXPORT   */
   /* CREATE ROUTINE TO CREATE ie_mstr ied_det AND UPDATE  ie_mstr */
   if c-application-mode = "API" and not lLegacyAPI then do:
      run setCommonDataBuffer in ApiMethodHandle 
         (input "ttImportExportMaster").
   end.

   if impexp then do:
      imp-okay = no.
      {us/bbi/gprun.i ""iemstrcr.p""
               "(input ""2"",
                 input po_nbr,
                 input recid(po_mstr),
                 input-output imp-okay)"}
   end.
 
   if c-application-mode = "API" and not lLegacyAPI then do:
      run setCommonDataBuffer in ApiMethodHandle 
         (input "").
   end.

   /* IMPORT EXPORT UPDATE */
   if c-application-mode = "API" and not lLegacyAPI then do:
      run setCommonDataBuffer in ApiMethodHandle 
         (input "ttImportExportDetail").
   end.

   if not batchrun and impexp then do:
      {us/px/pxrun.i &PROC='import-export-update'}
   end.
 
   if c-application-mode = "API" and not lLegacyAPI then do:
      run setCommonDataBuffer in ApiMethodHandle 
         (input "").
   end.

   if not impexp_edit then do:     /* CLEAN UP FRAMES DISPLAYED */
      hide all no-pause.
      if c-application-mode <> "API" then
         view frame dtitle.
   end.
 
   /*DO NOT COPY IF INVOKED IN VIEWER MODE */
   if not isViewer  then do:
      {us/px/pxrun.i &PROC='copyPOToOtherDBs' &PROGRAM='popoxr.p'
               &PARAM="(input po_nbr,
                        input false /* NOT BLANKET PO MAINT */ )"
               &NOAPPERROR=true &CATCHERROR=true}
   end.
 
   release po_mstr no-error.
 
   if c-application-mode = "API" then
      leave mainloop.
 
end.
 
status input.
 
/* RETURN SUCCESS STATUS TO API CALLER */
if c-application-mode = "API" then
   return {&SUCCESS-RESULT}.
 
/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */
 
PROCEDURE get-input:
/*----------------------------------------------------------------------------
 * Purpose:     Prompt for po_nbr.
 *----------------------------------------------------------------------------*/
   if c-application-mode = "API" then
      l_api_undo = no.

   if c-application-mode <> "API"
   then do:
      prompt-for po_nbr with frame a
      editing:
 
         /* Allow last PO number refresh */
         if keyfunction(lastkey) = "RECALL" or lastkey = 307 then
            display ponbr @ po_nbr with frame a.
 
         /* FIND NEXT/PREVIOUS  RECORD */
         if blanket = false then do:
            /* Do not scroll thru RTS for PO or PO for RTS */
            {us/mf/mfnp05.i
               po_mstr
               po_nbr
               " po_mstr.po_domain = global_domain and po_type  <> ""B"" and
                 po_fsm_type = """""
               po_nbr
               "input po_nbr"}
         end.
         else do:
            {us/mf/mfnp01.i po_mstr po_nbr po_nbr po_type  " po_mstr.po_domain =
                 global_domain and ""B"" "  po_type}
         end.
 
         if recno <> ? then do:
 
            disc = po_disc_pct.
 
            /* DISPLAY VENDOR ADDRESS */
            {us/mf/mfaddisp.i po_vend vend}
            /* DISPLAY SHIP TO ADDRESS */
            {us/mf/mfaddisp.i po_ship ship_to}
 
            display
               po_nbr
               po_vend
               po_ship
            with frame a.
 
            display
               po_ord_date
               po_due_date
               po_buyer
               po_bill
               so_job
               po_contract
               po_contact
               po_rmks
               po_pr_list2
               po_pr_list
               disc
               po_site
               po_daybookset
               po_project
               po_confirm
               po_curr
               po_lang
               po_taxable
               po_taxc
               po_tax_date
               po_fix_pr
               po_cr_terms
               po_crt_int
               po_user_id
               po_req_id
               pocmmts
               po_consignment
            with frame b.
 
         end.  /* IF RECNO <> ? */
      end. /* PROMPT-FOR...EDITING */
   end.   /*if c-application-mode <> "API"*/
   else do:
      if not lLegacyAPI then
         assign
            {us/mf/mfaiprvl.i po_nbr ttPurchaseOrderMaintenance.poNbr}.
   end.

   if c-application-mode <> "API" or (c-application-mode = "API" and not
      lLegacyAPI) then
      for first po_mstr
         where po_domain = global_domain
         and   po_nbr = input po_nbr
      no-lock: end.
   else do:
      for first po_mstr
         where po_domain = global_domain
         and   po_nbr = ttPurchaseOrder.nbr:
      end.
   end.
 
   if available po_mstr
   then do:
      if not isViewer
      then do:
         {us/px/pxrun.i &PROC='validatePurchaseOrder' &PROGRAM='popoxr.p'
                  &PARAM="(buffer po_mstr)"
                  &NOAPPERROR=true &CATCHERROR=true}
 
         if return-value <> {&SUCCESS-RESULT} then do:
            if c-application-mode <> "API" then do:
               next-prompt po_nbr with frame a.
               undo, retry.
            end.
            else do:
               l_api_undo = yes.
               undo, return error.
            end.
         end.
      end. /* IF not isViewer */
   end. /* IF available po_mstr */
 
   if (c-application-mode <> "API" and input po_nbr <> "")
      or (c-application-mode = "API" and not lLegacyAPI) then
      ponbr = input po_nbr.
   else do:
      if (c-application-mode = "API" and ttPurchaseOrder.nbr <> "") then
         ponbr = ttPurchaseOrder.nbr.
   end.
 
   do transaction on error undo,retry:
 
      if c-application-mode = "API" and retry then do:
         l_api_undo = yes.
         return error.
      end.

      if (c-application-mode <> "API" and input po_nbr = "") or
         (c-application-mode = "API" and lLegacyAPI and
         (ttPurchaseOrder.nbr = "" or ttPurchaseOrder.nbr = ?)) or
         (c-application-mode = "API" and not lLegacyAPI and input po_nbr = "")
      then do:
 
         /* Global Shipping: Identify PO type using NRM */
         if use_nrmseq then do:
 
            /* Fill temp table for display */
            empty temp-table tt_nrm no-error.
 
            for each nr_mstr
               where nr_domain = global_domain
               and nr_dataset begins "po_nbr."
               and nr_effdate <= today
               and (nr_exp_date = ? or nr_exp_date >= today)
            no-lock:
 
               if can-find (first lngd_det
                            where lngd_lang = global_user_lang
                            and   lngd_dataset = "po_seq_id"
                            and   lngd_field = "seq_type"
                            and   lngd_key2  = substring(nr_dataset,8))
               then do:
 
                  create tt_nrm.
                  assign
                     tt_dataset = nr_dataset
                     tt_seqid   = nr_seqid
                     tt_nbrtype = substring(nr_dataset,8).
 
                  if recid(tt_nrm) = -1 then.
 
               end.
 
            end.
 
            /* Display empty as default Seq ID */
            if c-application-mode <> "API" then
            display
               "" @ tt_seqid
            with frame frame_seqid.
 
         end. /* if use_nrmseq */
 
         /* Set the Seq ID and return the value */
         settype:
         do on error undo, retry on endkey undo, leave:
 
            if use_nrmseq then do:
               if c-application-mode <> "API" then do:
                  prompt-for tt_seqid with frame frame_seqid editing:
                     {us/mf/mfnp05.i tt_nrm idx_seqid_pk
                        " true "
                        tt_seqid
                        " input tt_seqid"}
 
                     if recno <> ? then do:
                        display
                           tt_seqid
                        with frame frame_seqid.
                     end.
 
                  end. /* prompt-for tt_seqid */
               end. /* c-application-mode <> "API" */
               else do:
                  if not lLegacyAPI then
                     assign
                     {us/mf/mfaiprvl.i tt_seqid
                     ttPurchaseOrderMaintenance.seqID}.
               end.

               for first tt_nrm where tt_seqid = input tt_seqid
               no-lock: end.
 
               if not available tt_nrm and input tt_seqid <> ""
               then do:
                  /* Invalid Sequence */
                  {us/bbi/pxmsg.i &MSGNUM=2818 &ERRORLEVEL=3
                  &FIELDNAME=""ttPurchaseOrderMaintenance.seqID""}
                  if c-application-mode <> "API" then
                     next-prompt tt_seqid.
                  undo, retry.
               end.
 
               else if input tt_seqid <> "" then
                  c_ponrm = tt_nbrtype.
 
            end. /* if use_nrmseq */
 
            GetPoNbr:
            repeat:
 
               if input tt_seqid <> "" and use_nrmseq
               then do:
 
                  run getnbr
                      (input tt_seqid,
                       input today,
                       output ponbr,
                       output l_errorst,
                       output i_errornum).
 
               end. /* If input tt_seqid <> "" */
 
               else do:
                  {us/px/pxrun.i &PROC='getNextPONumber' &PROGRAM='popoxr.p'
                           &PARAM="(output ponbr)"
                           &NOAPPERROR=true
                           &CATCHERROR=true}
               end.
 
               if not can-find(first po_mstr
                               where po_domain = global_domain
                               and   po_nbr    = ponbr no-lock)
               then do:
                  leave GetPoNbr.
               end.
 
            end. /* GetPoNbr */
 
            /* PO number length is 8 */
            if length(ponbr) > 8
            then do:
               /* LENGTH MUST BE LESS THEN 8 */
               {us/bbi/pxmsg.i &MSGNUM=7982 &ERRORLEVEL=3}
               undo, retry settype.
            end.
 
         end. /* settype */
 
      end. /* if (c-application-mode <> "API" and input po_nbr = "") */
 
   end. /* DO TRANSACTION ON ERROR UNDO.. */
 
   {us/gp/gpbrparm.i &browse=gplu908.p &parm=c-brparm1 &val=poNbr}
 
END PROCEDURE.
 
PROCEDURE import-export-update:
   assign
      impexp_edit = no
      upd_okay = no.
 
   if c-application-mode <> "API" then do:
   /* VIEW/EDIT IMPORT/EXPORT DATA ? */
   {us/bbi/pxmsg.i &MSGNUM=271 &ERRORLEVEL={&INFORMATION-RESULT}
            &CONFIRM=impexp_edit}
   end.
   else
      if not lLegacyAPI then
         assign impexp_edit = yes.


   /* VIEW EDIT IMPORT EXPORT DATA ? */
   if impexp_edit then do:
      hide all.
      if c-application-mode <> "API" then do:
         view frame dtitle.
         view frame a.
      end.
 
      {us/bbi/gprun.i ""iedmta.p""
               "(input ""2"",
                 input po_mstr.po_nbr,
                 input-output upd_okay )" }
   end.
 
END PROCEDURE.
 
PROCEDURE initialize-variables:
   assign
      nontax_old         = nontaxable_amt:format in frame potot
      taxable_old        = taxable_amt:format
      lines_tot_old      = lines_total:format
      tax_tot_old        = tax_total:format
      order_amt_old      = order_amt:format
      prepaid_old        = po_prepaid:format in frame pomtd
      oldcurr = "".
 
   do transaction on error undo, retry:
      /* SET UP PRICING BY LINE VALUES */
      for first mfc_ctrl
         where mfc_domain = global_domain
         and   mfc_field = "poc_pc_line"
      no-lock:
         poc_pc_line = mfc_logical.
      end.
   end.
 
END PROCEDURE.
