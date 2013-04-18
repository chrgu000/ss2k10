/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.46.1.7 $                                                      */
/*                                                                            */
/* This program is the main driver program for purchase order line creation   */
/* updation and deletion                                                      */
/*                                                                            */
/* Revision: 1.0     Modified: 04/29/86    BY: PML                            */
/* Revision: 1.0     Modified: 10/29/86    BY: EMB *39*                       */
/* Revision: 2.0     Modified: 11/19/86    BY: PML *A3*                       */
/* Revision: 2.0     Modified: 03/12/87    BY: EMB *A41*                      */
/* Revision: 2.1     Modified: 06/17/87    BY: WUG *A69*                      */
/* Revision: 2.1     Modified: 06/17/87    BY: WUG *A70*                      */
/* Revision: 2.1     Modified: 08/12/87    BY: PML *A83*                      */
/* Revision: 2.1     Modified: 09/09/87    BY: PML *A92*                      */
/* Revision: 2.1     Modified: 09/09/87    BY: WUG *A94*                      */
/* Revision: 2.1     Modified: 10/02/87    BY: PML *A95*                      */
/* Revision: 4.0     Modified: 03/10/88    BY: FLM *A108*                     */
/* Revision: 4.0     Modified: 12/27/87    BY: PML *A119*                     */
/* Revision: 4.0     Modified: 03/14/88    BY: FLM *A184*                     */
/* Revision: 4.0     Modified: 04/18/88    BY: FLM *A189*                     */
/* Revision: 4.0     Modified: 06/15/88    BY: FLM *A268*                     */
/* Revision: 4.0     Modified: 07/22/88    BY: FLM *A346*                     */
/* Revision: 4.0     Modified: 09/06/88    BY: FLM *A419*                     */
/* Revision: 4.0     Modified: 09/08/88    BY: FLM *A425*                     */
/* Revision: 4.0     Modified: 09/20/88    BY: FLM *A445*                     */
/* Revision: 4.0     Modified: 09/26/88    BY: RL  *C0028*                    */
/* Revision: 4.0     Modified: 03/24/89    BY: FLM *A685*                     */
/* Revision: 5.0     Modified: 04/06/89    BY: MLB *B088*                     */
/* Revision: 5.0     Modified: 07/07/89    BY: MLB *B177*                     */
/* Revision: 5.0     Modified: 10/30/89    BY: MLB *B365*                     */
/* Revision: 5.0     Modified: 12/21/89    BY: FTB *B466*                     */
/* Revision: 5.0     Modified: 02/05/90    BY: FTB *Bftb*                     */
/* Revision: 5.0     Modified: 02/27/90    BY: EMB *B591*                     */
/* Revision: 6.0     Modified: 03/21/90    BY: FTB *D011*                     */
/* Revision: 6.0     Modified: 05/15/90    BY: WUG *D002*                     */
/* Revision: 5.0     Modified: 06/11/90    BY: RAM *B706*                     */
/* Revision: 6.0     Modified: 07/06/90    BY: EMB *D040*                     */
/* Revision: 6.0     Modified: 08/14/90    BY: SVG *D058*                     */
/* Revision: 6.0     Modified: 08/31/90    BY: RAM *D030*                     */
/* Revision: 6.0     Modified: 10/22/90    BY: RAM *D124*                     */
/* Revision: 6.0     Modified: 12/20/90    BY: RAM *D274*                     */
/* Revision: 6.0     Modified: 01/02/91    BY: MLB *D238*                     */
/* Revision: 6.0     Modified: 03/08/91    BY: RAM *D410*                     */
/* Revision: 6.0     Modified: 04/08/91    BY: RAM *D502*                     */
/* Revision: 6.0     Modified: 04/10/91    BY: WUG *D512*                     */
/* Revision: 6.0     Modified: 04/11/91    BY: RAM *D518*                     */
/* Revision: 6.0     Modified: 05/07/91    BY: RAM *D621*                     */
/* Revision: 6.0     Modified: 05/09/91    BY: RAM *D634*                     */
/* Revision: 6.0     Modified: 08/15/91    BY: PMA *D829*                     */
/* Revision: 7.0     Modified: 09/10/91    BY: MLV *F006*                     */
/* Revision: 6.0     Modified: 09/24/91    BY: RAM *D872*                     */
/* Revision: 6.0     Modified: 11/11/91    BY: RAM *D921*                     */
/* Revision: 6.0     Modified: 11/15/91    BY: RAM *D952*                     */
/* Revision: 7.0     Modified: 11/19/91    BY: PMA *F003*                     */
/* Revision: 7.0     Modified: 12/09/91    BY: RAM *F033*                     */
/* Revision: 7.0     Modified: 02/03/92    BY: pma *F085*                     */
/* Revision: 7.0     Modified: 03/25/92    BY: MLV *F316*                     */
/* Revision: 7.0     Modified: 05/20/92    BY: MLV *F514*                     */
/* Revision: 7.0     Modified: 07/31/92    BY: afs *F827*                     */
/* Revision: 7.0     Modified: 08/06/92    BY: tjs *G027*                     */
/* Revision: 7.3     Modified: 08/18/92    BY: tjs *G028*                     */
/* Revision: 7.3     Modified: 12/18/92    BY: afs *G465*                     */
/* Revision: 7.3     Modified: 01/08/93    BY: bcm *G417*                     */
/* Revision: 7.3     Modified: 02/17/93    BY: tjs *G684*                     */
/* Revision: 7.3     Modified: 02/23/93    BY: tjs *G728*                     */
/* Revision: 7.3     Modified: 04/09/93    BY: pma *G928*                     */
/* Revision: 7.3     Modified: 04/29/93    BY: afs *G972*                     */
/* Revision: 7.4     Modified: 06/09/93    BY: jjs *H006*                     */
/* Revision: 7.4     Modified: 07/02/93    BY: dpm *H017*                     */
/* Revision: 7.4     Modified: 07/02/93    BY: dpm *H018*                     */
/* Revision: 7.4     Modified: 07/21/93    BY: dpm *H034*                     */
/* Revision: 7.4     Modified: 07/30/93    BY: cdt *H047*                     */
/* Revision: 7.4     Modified: 09/07/93    BY: tjs *H082*                     */
/* Revision: 7.4     Modified: 09/29/93    BY: cdt *H086*                     */
/* Revision: 7.4     Modified: 10/28/93    BY: dpm *H198*                     */
/* Revision: 7.4     Modified: 10/23/93    BY: cdt *H184*                     */
/* Revision: 7.3     Modified: 11/12/93    BY: cdt *GH13*                     */
/* Revision: 7.4     Modified: 11/14/93    BY: afs *H221*                     */
/* Revision: 7.4     Modified: 02/16/94    BY: cdt *FM21*                     */
/* Revision: 7.4     Modified: 03/10/94    BY: cdt *H294*                     */
/* Revision: 7.4     Modified: 04/13/94    BY: dpm *GJ18*                     */
/* Revision: 7.4     Modified: 05/21/94    BY: qzl *H374*                     */
/* Revision: 7.4     Modified: 06/15/94    BY: qzl *H388*                     */
/* Revision: 7.4     Modified: 06/30/94    BY: afs *GK49*                     */
/* Revision: 7.4     Modified: 07/01/94    BY: afs *FP20*                     */
/* Revision: 7.4     Modified: 07/18/94    BY: bcm *H441*                     */
/* Revision: 7.4     Modified: 09/08/94    BY: rxm *FQ83*                     */
/* Revision: 7.4     Modified: 09/09/94    BY: dpm *FQ93*                     */
/* Revision: 7.4     Modified: 09/10/94    BY: afs *H510*                     */
/* Revision: 7.4     Modified: 09/29/94    BY: bcm *H541*                     */
/* Revision: 7.4     Modified: 11/09/94    BY: srk *GO05*                     */
/* Revision: 8.5     Modified: 11/09/94    BY: mwd *J034*                     */
/* Revision: 8.5     Modified: 12/01/94    BY: taf *J038*                     */
/* Revision: 8.5     Modified: 02/23/95    BY: dpm *J044*                     */
/* Revision: 8.5     Modified: 04/26/95    BY: sxb *J04D*                     */
/* Revision: 7.4     Modified: 12/30/94    BY: rxm *F0C8*                     */
/* Revision: 7.4     Modified: 01/28/95    BY: ljm *G0D7*                     */
/* Revision: 7.4     Modified: 02/09/95    BY: jxz *F0HF*                     */
/* Revision: 7.4     Modified: 03/29/95    BY: rxm *F0PJ*                     */
/* Revision: 7.4     Modified: 08/10/95    BY: jym *G0V1*                     */
/* Revision: 7.4     Modified: 08/16/95    BY: jym *F0TM*                     */
/* Revision: 7.4     Modified: 08/25/95    BY: jym *G0TW*                     */
/* Revision: 7.4     Modified: 09/19/95    BY: ais *G0X6*                     */
/* Revision: 7.4     Modified: 10/05/95    BY: ais *H0G7*                     */
/* Revision: 7.4     Modified: 10/18/95    BY: dxk *G0XK*                     */
/* Revision: 7.4     Modified: 11/13/95    BY: ais *H0GK*                     */
/* Revision: 7.4     Modified: 12/07/95    BY: rxm *H0FS*                     */
/* Revision: 8.5     Modified: 10/03/95    BY: taf *J053*                     */
/* Revision: 8.5     Modified: 03/19/96    BY: *J0CV* Robert Wachowicz        */
/* Revision: 8.5     Modified: 04/11/96    BY: *G1QK* ais                     */
/* Revision: 8.5     Modified: 05/15/96    BY: *J0MK* Sue Poland              */
/* Revision: 8.5     Modified: 07/02/96    BY: *H0LW* Dwight Kahng            */
/* Revision: 8.5     Modified: 09/04/96    BY: *H0ML* Suresh Nayak            */
/* Revision: 8.5     Modified: 09/05/96    BY: *G2D3* Ajit Deodhar            */
/* Revision: 8.5     Modified: 09/20/96    BY: *G2FX* Ajit Deodhar            */
/* Revision: 8.5     Modified: 10/22/96    BY: *H0NJ* Ajit Deodhar            */
/* Revision: 8.5     Modified: 11/19/96    BY: *H0PG* Suresh Nayak            */
/* Revision: 8.5     Modified: 12/03/96    BY: *H0Q3* Ajit Deodhar            */
/* Revision: 8.5     Modified: 03/26/97    BY: *H0VL* Suresh Nayak            */
/* Revision: 8.5     Modified: 03/26/97    BY: *H0V3* Jim Williams            */
/* Revision: 8.5     Modified: 02/11/97    BY: *J1YW* B. Gates                */
/* Revision: 8.5     Modified: 10/09/97    BY: *J231* Patrick Rowan           */
/* Revision: 8.5     Modified: 10/22/97    BY: *J23Z* Nirav Parikh            */
/* Revision: 8.5     Modified: 10/27/97    BY: *H1GB* Seema Varma             */
/* Revision: 8.5     Modified: 02/12/98    BY: *J2FB* Mandar K.               */
/* Revision: 8.6E    Modified: 02/23/98    BY: *L007* A. Rahane               */
/* Revision: 8.6E    Modified: 05/09/98    BY: *L00Y* Jeff Wootton            */
/* Old ECO marker removed, but no ECO header exists *H015*                    */
/* Old ECO marker removed, but no ECO header exists *H0JS*                    */
/* Revision: 8.6E    Modified: 06/02/98    BY: *L020* Charles Yen             */
/* Revision: 8.6E    Modified: 08/31/98    BY: *J2Y0* Manish K.               */
/* Revision: 9.0     Modified: 12/08/98    BY: *M02C* Jim Williams            */
/* Revision: 9.0     Modified: 03/13/99    BY: *M0BD* Alfred Tan              */
/* Revision: 9.1     Modified: 05/28/99    BY: *L0DW* Ranjit Jain             */
/* Revision: 9.1     Modified: 07/12/99    BY: *J3J2* Santosh Rao             */
/* Revision: 9.1     Modified: 08/13/99    BY: *J3KP* Anup Pereira            */
/* Revision: 9.1     Modified: 09/13/99    BY: *N014* Robin McCarthy          */
/* Revision: 9.1     Modified: 02/24/00    BY: *N087* Rajesh Kini             */
/* Revision: 9.1     Modified: 03/24/00    BY: *N08T* Annasaheb Rahane        */
/* Revision: 1.34          BY: Niranjan R.        DATE: 05/24/00  ECO: *N0C7* */
/* Revision: 1.35          BY: Mudit Mehta        DATE: 07/03/00  ECO: *N0F3* */
/* Revision: 1.36          BY: Anup Pereira       DATE: 07/10/00  ECO: *N059* */
/* Revision: 1.37          BY: Mark Brown         DATE: 08/17/00  ECO: *N0LJ* */
/* Revision: 1.38          BY: Katie Hilbert      DATE: 08/24/00  ECO: *N0NQ* */
/* Revision: 1.39          BY: Zheng Huang        DATE: 08/24/00  ECO: *N0SF* */
/* Revision: 1.41          BY: Zheng Huang        DATE: 08/24/00  ECO: *N0TB* */
/* REVISION: 9.1           LAST MODIFIED: 09/29/00    BY: *N0WP* Mudit Mehta  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.43          BY: Rajesh Lokre       DATE: 05/09/01  ECO: *N0YL* */
/* Revision: 1.45          BY: Nikita Joshi       DATE: 07/27/01  ECO: *M1G5* */
/* Revision: 1.46.1.1      BY: Nikita Joshi       DATE: 08/12/01  ECO: *M1H2* */
/* Revision: 1.46.1.3      BY: Ashish Kapadia     DATE: 11/21/01  ECO: *N16F* */
/* Revision: 1.46.1.4      BY: Mark Christian     DATE: 12/21/01  ECO: *N175* */
/* Revision: 1.46.1.5      BY: Anitha Gopal       DATE: 02/08/02  ECO: *N192* */
/* $Revision: 1.46.1.7 $  BY:Adeline Kinehan  DATE: 10/16/01  ECO: *N13P* */
/* ADM1   07/14/04  Brian Lo - add audit trail                                */
/*                    by *ADM*  ShiyuHe    DATE: 09/22/04  -Check pod_qty_ord */ 
/*                                                                            */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

/***************************************************************************/
/*     PROGRAM popomta.p WAS USED AS A TEMPLATE FOR NEW PROGRAM giapimpf.p */
/*     IN THE ON/Q PLANNING AND OPTIMIZATION API INTERFACE PROJECT.  NEW   */
/*     FUNCTIONAL AND STRUCTURAL CHANGES MADE TO popomta.p SHOULD BE       */
/*     EVALUATED FOR SUITABILITY FOR INCLUSION WITHIN giapimpf.p.          */
/***************************************************************************/

/************************************************************************/
/*    THIS PROGRAM HANDLES BOTH MULTI-LINE AND SINGLE-LINE ENTRY.       */
/************************************************************************/
/* ss-20121220.1 by Steven */


{mfdeclre.i}
{cxcustom.i "POPOMTA.P"}
{gplabel.i}
{pxmaint.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE popomta_p_2 "Comments"
/* MaxLen: Comment: */

{&POPOMTA-P-TAG1}
/* ********** End Translatable Strings Definitions ********* */

/* **************************** NEW SHARED FRAMES *************************** */
define new shared frame chead.
define new shared frame c.
define new shared frame d.

/* ************************** NEW SHARED VARIABLES ************************** */
define new shared variable ext_cost_fmt        as character.
define new shared variable cmtindx             as integer.
define new shared variable clines              as integer initial ?.
define new shared variable price_came_from_req as log no-undo.
define new shared variable pod_recno           as recid.
define new shared variable old_pod_site   like pod_site.
define new shared variable new_pod        like mfc_logical.
define new shared variable desc1          like pt_desc1.
define new shared variable desc2          like pt_desc2.
define new shared variable qty_ord        like pod_qty_ord.
define new shared variable old_qty_ord    like pod_qty_ord.
define new shared variable ext_cost       like pod_pur_cost.
define new shared variable old_pod_status like pod_status.
define new shared variable old_type       like pod_type.
define new shared variable mfgr           like vp_mfgr.
define new shared variable mfgr_part      like vp_mfgr_part.
define new shared variable st_qty         like pod_qty_ord.
define new shared variable st_um          like pod_um.
define new shared variable old_um         like pod_um.
define new shared variable podnbr         like pod_nbr.
define new shared variable podline        like pod_line.
define new shared variable podreqnbr      like pod_req_nbr.
define new shared variable poc_pt_req     like mfc_logical.
define new shared variable req_ok         like mfc_logical.
define new shared variable continue       like mfc_logical.
define new shared variable match_pt_um    like mfc_logical initial no.
define new shared variable podcmmts       like mfc_logical label {&popomta_p_2}.
define new shared variable pcqty          like pod_qty_ord.
define new shared variable base_cost      like pod_pur_cost.

/* REQUISITION BY SITE WORKFILE INCLUDE FILE */
{poprwkfl.i &new="new"}

/* **************************** SHARED VARIABLES **************************** */
define shared variable line_opened as logical.
define shared variable po_recno    as recid.
define shared variable vd_recno    as recid.
define shared variable blanket   like mfc_logical.
define shared variable new_db    like si_db.
define shared variable old_db    like si_db.
define shared variable new_site  like si_site.
define shared variable old_site  like si_site.
define shared variable base_amt  like pod_pur_cost.
define shared variable rndmthd   like rnd_rnd_mthd.
define shared variable line      like sod_line.
define shared variable due_date  like pod_due_date.
define shared variable del-yn    like mfc_logical.
define shared variable so_job    like pod_so_job.
define shared variable disc      like pod_disc_pct.
define shared variable sngl_ln   like poc_ln_fmt.
define shared variable tax_in    like ad_tax_in.
define shared variable impexp    like mfc_logical no-undo.
define shared variable using_grs like mfc_logical no-undo.

/* LOCAL VARIABLES */
define variable return_status    as   character       no-undo.
define variable oot_poum         as   character       no-undo.
define variable oot_rqum         as   character       no-undo.
define variable frame_row        as   integer         no-undo.
define variable l_actual_disc    as   decimal         no-undo.
define variable l_display_disc   as   decimal         no-undo.
define variable oot_ponetcst     as   decimal         no-undo.
define variable oot_rqnetcst     as   decimal         no-undo.
define variable l_min_disc       as   decimal         initial -99.99 no-undo.
define variable l_max_disc       as   decimal         initial 999.99 no-undo.
define variable l_sngl_ln        like poc_ln_fmt      no-undo.
define variable netcost          like pod_pur_cost.
define variable old_disc_pct     like pod_disc_pct.
define variable minprice         like pc_min_price.
define variable maxprice         like pc_min_price.
define variable lineffdate       like po_due_date.
define variable dummy_cost       like pc_min_price.
define variable old_pur_cost     like pod_pur_cost.
define variable old_vpart        like pod_vpart.
define variable oot_pod_site     like pod_site        no-undo.
define variable oot_pod_req_nbr  like pod_req_nbr     no-undo.
define variable oot_pod_req_line like pod_req_line    no-undo.
define variable rev              like pod_rev         no-undo.
define variable w_pod_req_nbr    like pod_req_nbr.
define variable w_pod_req_line   like pod_req_line.
define variable w_pod_part       like pod_part.
define variable w_pod_pur_cost   like pod_pur_cost.
define variable w_pod_disc_pct   like pod_disc_pct.
define variable w_pod_qty_ord    like pod_qty_ord.
define variable w_pod_need       like pod_need.
define variable w_pod_due_date   like pod_due_date.
define variable w_pod_um         like pod_um.
define variable w_pod_um_conv    like pod_um_conv.
define variable w_pod_project    like pod_project.
define variable w_pod_acct       like pod_acct.
define variable w_pod_sub        like pod_sub         no-undo.
define variable w_pod_cc         like pod_cc.
define variable w_pod_request    like pod_request.
define variable w_pod_approve    like pod_approve.
define variable w_pod_apr_code   like pod_apr_code.
define variable w_pod_desc       like pod_desc.
define variable w_pod_taxc       like pod_taxc.
define variable w_pod_taxable    like pod_taxable.
define variable w_pod_vpart      like pod_vpart.
define variable w_pod_cmtindx    like pod_cmtindx.
define variable w_pod_lot_rcpt   like pod_lot_rcpt.
define variable w_pod_rev        like pod_rev.
define variable w_pod_loc        like pod_loc.
define variable w_pod_insp_rqd   like pod_insp_rqd.
define variable w_mfgr           like mfgr.
define variable w_mfgr_part      like mfgr_part.
define variable w_desc1          like desc1.
define variable w_desc2          like desc2.
define variable l_netunitcost    like netcost         no-undo.
{&POPOMTA-P-TAG2}
define variable first_time       like mfc_logical     initial yes.
define variable yn               like mfc_logical     initial no.
define variable dummyDecimal     as   decimal         no-undo.
define variable dummyChar        as   character       no-undo.
define variable siteDB           as   character       no-undo.
define variable supplierUM       as   character       no-undo.
define variable mfgItem          as   character       no-undo.
define variable mfgId            as   character       no-undo.
define variable itemAvailable    as   logical         no-undo.
define variable ReqCommentIndex  as   integer         no-undo.
define variable old_crt_int      like pod_crt_int     no-undo.
define variable oldUnitCost      like pod_pur_cost    no-undo.
define variable oldDiscountPct   like pod_disc_pct    no-undo.
define variable l_pod_type       like pod_type        no-undo.

define variable result as character no-undo.

/*ss20130118 b*/
define new shared variable myflag as log no-undo.
/*ss20130118 e*/

/*COMMON API CONSTANTS AND VARIABLES*/
{mfaimfg.i}

/*PURCHASE ORDER API TEMP-TABLE, NAMED USING THE "api" PREFIX*/
{popoit01.i}
{mfctit01.i}

if c-application-mode = "API" then do on error undo, return:

   /*GET HANDLE OF API CONTROLLER*/
   {gprun.i ""gpaigh.p"" "(output ApiMethodHandle,
                                    output ApiProgramName,
                                    output ApiMethodName,
                                    output apiContextString)"}

   create ttPurchaseOrderDet.
   run getFirstPoToDetLink in ApiMethodHandle
         (buffer ttPurchaseOrderDet).
   assign result = RETURN-VALUE.

   run getPurchaseOrderDetCmt in ApiMethodHandle
                (output table ttPurchaseOrderDetCmt).

end.  /* If c-application-mode = "API" */

/* ********************************** MAIN ********************************** */
if sngl_ln then
   clines = 1.

/* PURCHASE ORDER MAINTENANCE SINGLE LINE ITEMS */
/* DEFINES: frame chead, frame c, frame d, and frame line_pop */
{mfpomtb.i}

/*V8:HiddenDownFrame=c */
/*V8:HiddenDownFrame=d */

find first clc_ctrl no-lock no-error.
if not available clc_ctrl then do:
   {gprun.i ""gpclccrt.p""}
   find first clc_ctrl no-lock.
end.

find first poc_ctrl no-lock.

/* READ PRICE TABLE REQUIRED FLAG FROM MFC_CTRL */
{pxrun.i &PROC='getPriceListRequired' &PROGRAM='popoxr.p'
    &PARAM="(output poc_pt_req)"
    &NOAPPERROR=TRUE &CATCHERROR=TRUE}

/* SET EXT_COST FORMAT FOR FRAME D */
ext_cost_fmt = ext_cost:format.
{gprun.i ""gpcurfmt.p""
   "(input-output ext_cost_fmt,
     input rndmthd)"}
ext_cost:format = ext_cost_fmt.

find po_mstr where recid(po_mstr) = po_recno.
find vd_mstr where recid(vd_mstr) = vd_recno no-lock.

if result = {&RECORD-NOT-FOUND} then
   return.

{&POPOMTA-P-TAG3}
linefmt:
repeat on endkey undo, leave:
   if retry and c-application-mode = "API" then
      undo linefmt, return error.

   if result = {&RECORD-NOT-FOUND} then
      return.

   if c-application-mode <> "API" then
   do:
      hide frame d no-pause.
      hide frame c no-pause.
      view frame dtitle.
      display
         po_nbr
         po_vend
         sngl_ln
         with frame chead.
   end.  /* If c-application-mode <> "API" */

   /* If in API mode we need to set sngl_ln to true to */
   /* allow all variables to be set.                   */
   if c-application-mode = "API" then
      assign sngl_ln = yes.

   assign l_sngl_ln = sngl_ln.

   {&POPOMTA-P-TAG4}
   if not first_time then
      {&POPOMTA-P-TAG5}
   if c-application-mode <> "API" then
      update sngl_ln with frame chead.

   if l_sngl_ln <> sngl_ln and c-application-mode <> "API" then
      clear frame c all no-pause.

   clines = ?.
   if sngl_ln then
      clines = 1.

   first_time = no.
   {&POPOMTA-P-TAG6}
   if c-application-mode <> "API" then
   do:
      view frame c.

      if sngl_ln then
         view frame d.
   end.  /* If c-application-mode <> "API" */

   /*ADM1*/
   {gpaud.i &uniq_num1 = 01  &uniq_num2 = 02
      &db_file = pod_det &db_field = pod_nbr}
   /*ADM1 end*/
   /* SINGLE LINE ENTRY */
   mainloop:
   repeat on endkey undo, next linefmt:
      if (c-application-mode = "API" ) and retry then
         undo mainloop, return error.
      if (c-application-mode = "API") and (result = {&RECORD-NOT-FOUND}) then
         leave.

      do transaction:
         if  using_grs
         and return_status begins "undo_pod_line_mark_req_oot"
         /*TO DO Yet to find, how the above condition could be achieved in API*/
         then do:
            {gprunmo.i
               &program="popomtrc.p"
               &module="GRS"
               &param="""(input yes,
                          input oot_pod_site,
                          input oot_pod_req_nbr,
                          input oot_pod_req_line,
                          input lookup('reroute',return_status) > 0,
                          input oot_ponetcst,
                          input oot_poum,
                          input oot_rqnetcst,
                          input oot_rqum)"""}

            if c-application-mode <> "API" then
            do:
               view frame dtitle.
               view frame chead.
               view frame c.
               if sngl_ln then
                  view frame d.
            end.  /* If c-application-mode <> "API" */

            return_status = "".

            /* return messages & process need to be replicated in Write method*/
            /* MESSAGE #2103 - REQUISITION LINE WAS MARKED OUT OF TOLERANCE */
            {pxmsg.i
               &MSGNUM=2103
               &ERRORLEVEL={&INFORMATION-RESULT}}

            /* MESSAGE #2124 - REQUISITION LINE WAS NOT ADDED TO THE PO */
            {pxmsg.i
               &MSGNUM=2124
               &ERRORLEVEL={&INFORMATION-RESULT}
               &MSGARG1=oot_pod_req_nbr
               &MSGARG2=string(oot_pod_req_line)}
         end. /* IF USING_GRS AND .... */
      end. /* DO TRANSACTION */

      do transaction:
         assign
            continue = yes
            podcmmts = poc_lcmmts.

         req_ok = no.

         /* SCREENS & REPORTS DON'T SUPPORT 4 DIGIT LINE NUMBERS. */
         if line < 999 then
            line = line + 1.
         else do :
            {pxrun.i &PROC='validatePOLineNumber' &PROGRAM='popoxr1.p'
                     &PARAM="(input line)"
                     &NOAPPERROR=True &CATCHERROR=True}
         end.

         {pxrun.i &PROC='processRead' &PROGRAM='popoxr1.p'
                  &PARAM="(input po_nbr,
                           input line,
                           buffer pod_det,
                           input false,
                           input false)"
                  &NOAPPERROR=True &CATCHERROR=True}
         if return-value = {&RECORD-NOT-FOUND}
             and c-application-mode <> "API" then do:
            /* CLEAR DISPLAY */
            display
               line
               po_site @ pod_site
               "" @ pod_req_nbr
               "" @ pod_part
               0 @ pod_qty_ord
               "" @ pod_um
               0 @ pod_pur_cost
               0 @ pod_disc_pct
               with frame c.

            assign
               desc1 = getTermLabel("ITEM_NOT_IN_INVENTORY",24).
               desc2 = "".

            if sngl_ln then
               clear frame d no-pause.
         end.

         if return-value = {&SUCCESS-RESULT} then do:
            assign
               desc1 = pod_desc
               desc2 = ""
               st_qty = 0
               st_um = pod_um.

            {pxrun.i &PROC='getBasicItemData' &PROGRAM='ppitxr.p'
                     &PARAM="(input pod_part,
                              output desc1,
                              output desc2,
                              output dummyDecimal,
                              output dummyChar,
                              output dummyChar,
                              output st_um,
                              output dummyChar)"
                     &NOAPPERROR=True
                     &CATCHERROR=True}

            st_qty = pod_qty_ord * pod_um_conv.

            if pod_desc <> "" then
               desc1 = pod_desc.

            {pxrun.i &PROC='uiDisplayFrameCandD'
                     &NOAPPERROR=True
                     &CATCHERROR=True}
         end. /* IF RETURN-VALUE = {&SUCCESS-RESULT}  */

         if c-application-mode <> "API" then
            display line with frame c.
         setline:
         do on error undo, retry:
            if retry and c-application-mode = "API" then
               undo setline, return error.

            if c-application-mode <> "API" then
            do:
               hide frame line_pop no-pause.
               set line with frame c
               editing:
                  /* FIND NEXT RECORD */
                  {mfnp01.i pod_det line pod_line po_nbr pod_nbr pod_nbrln}

                  if recno <> ? then do:
                     assign
                        line = pod_line
                        desc1 = pod_desc
                        desc2 = ""
                        st_qty = 0
                        st_um = "".

                     find pt_mstr
                     where pt_part = pod_part
                     no-lock no-error no-wait.
                     if available pt_mstr then
                        assign
                           desc1 = pt_desc1
                           desc2 = pt_desc2
                           st_um = pt_um.

                     st_qty = pod_qty_ord * pod_um_conv.
                     if pod_desc <> "" then
                        desc1 = pod_desc.

                     {pxrun.i &PROC='uiDisplayFrameCandD'
                              &NOAPPERROR=True
                              &CATCHERROR=True}

                     req_ok = no.
                     find last req_det
                       where req_nbr = pod_req_nbr
                       no-lock no-error.
                     if available req_det then do:
                        if can-find(first vp_mstr where vp_vend = po_vend
                        and vp_part = req_part) then
                        req_ok = yes.
                     end.
                  end.  /* Recno <> ? */
               end. /* END EDITING */
            end.  /* If c-application-mode <> "API" */
            else
            do:
               assign
                  {mfaiset.i line ttPurchaseOrderDet.line}.
            end.

            {pxrun.i &PROC='processRead' &PROGRAM='popoxr1.p'
                     &PARAM="(input po_nbr,
                              input line,
                              buffer pod_det,
                              input yes,
                              input yes)"
                     &NOAPPERROR=True
                     &CATCHERROR=True}
            if return-value = {&RECORD-NOT-FOUND}
               and (po_stat = "c" or po_stat = "x") then do:
               if c-application-mode <> "API" then
                  yn = no.
               else
                  yn = yes.

               /* MESSAGE #345 - ADDING NEW LINE TO CLOSED PO */
               /* REOPEN PURCHASE ORDER? */
               {pxmsg.i
                  &MSGNUM=345
                  &ERRORLEVEL={&INFORMATION-RESULT}
                  &CONFIRM=yn}

               if yn = yes then do:
                  {pxrun.i &PROC='reopenPurchaseOrder' &PROGRAM='popoxr.p'
                           &PARAM="(input po_nbr)"
                           &NOAPPERROR=True &CATCHERROR=True}
                  line_opened = true.
               end. /* IF YN = YES */

               if yn = no then do:
                  if c-application-mode <> "API" then
                  do:
                     hide frame line_pop no-pause.
                     next-prompt line with frame c.
                     undo setline, retry.
                  end.
                  else
                     undo setline, return error.
               end. /* IF YN = NO */
            end.  /*  IF NOT AVAILABLE POD_DET AND */
         end. /* END SETLINE */

         if c-application-mode <> "API" then
            assign line.
         else
         do:
           assign
            {mfaiset.i line ttPurchaseOrderDet.line}.
         end.

         price_came_from_req = false.
         
         /* ADD/MOD/DELETE  */
         {pxrun.i &PROC='processRead' &PROGRAM='popoxr1.p'
                  &PARAM="(input po_nbr,
                           input line,
                           buffer pod_det,
                           input no,
                           input no)"
                  &NOAPPERROR=True
                  &CATCHERROR=True}
         if return-value = {&RECORD-NOT-FOUND} then do:
            if c-application-mode <> "API" then
            do:

               {pxrun.i &PROC='validatePOLineNumber' &PROGRAM='popoxr1.p'
                        &PARAM="(input line:screen-value)"
                        &NOAPPERROR=True &CATCHERROR=True}
               if return-value <> {&SUCCESS-RESULT} then do:
                  undo, retry.
               end.

               display
                  line
                  po_site @ pod_site
                  "" @ pod_req_nbr
                  "" @ pod_part
                   0 @ pod_qty_ord
                 "" @ pod_um
                  0 @ pod_pur_cost
                  0 @ pod_disc_pct
               with frame c.

               clear frame d no-pause.
            end.  /* If c-application-mode <> "API" */
            else  /*if c-application-mode = "API" */
            do:
               {pxrun.i &PROC='validatePOLineNumber' &PROGRAM='popoxr1.p'
                        &PARAM="(ttPurchaseOrderDet.line)"
                        &NOAPPERROR=True &CATCHERROR=True}
               if return-value <> {&SUCCESS-RESULT} then
                  undo, return error.
            end. /*end of else c-application-mode ="API" */

            /* ADDING NEW RECORD */
            /* MESSAGE #1 - ADDING NEW RECORD */
            {pxmsg.i
               &MSGNUM=1
               &ERRORLEVEL={&INFORMATION-RESULT}}
            {pxrun.i &PROC='createPurchaseOrderLine' &PROGRAM='popoxr1.p'
                     &PARAM="(input po_nbr,
                              input line,
                              buffer pod_det)"
                     &NOAPPERROR=True &CATCHERROR=True}
            assign
               pod_due_date   = due_date
               pod_crt_int    = po_crt_int
               pod_disc_pct   = disc
               pod_so_job     = so_job
               pod_lot_rcpt   = clc_polot_rcpt
               pod_tax_in     = tax_in.

            {pxrun.i &PROC='initializeBlanketPOLine' &PROGRAM='popoxr1.p'
                     &PARAM="(input blanket,
                              buffer pod_det)"
                     &NOAPPERROR=True &CATCHERROR=True}

            assign
               desc1 = pod_desc
               desc2 = "".

            assign
               new_pod = yes
               req_ok = no
               pod_recno = recid(pod_det)
               old_pod_site = pod_site
               continue = no.   /* CHECK REQUISITION & APPROVAL ETC */
            /* NOW, ALL popomti.p DOES IS JUST GET SITE */
            {gprun.i ""popomti.p""}
            if c-application-mode <> "API" then
            do:
               if continue = no then
                  undo mainloop, next mainloop.
            end.  /* If c-application-mode <> "API" */
            else
               if continue = no then
                  undo mainloop, return error.

            /* GET REQUISITION INFO */
            frame_row = frame-row(c) + frame-line(c) - 1.

            /* ADDED OUTPUT PARAMETER l_pod_type BELOW*/
            {gprun.i ""popomtr.p"" "(input yes,
                  input frame_row,
                  input po_curr,
                  input po_vend,
                  input pod_site,
                  input po_taxable,
                  input po_ex_rate,
                  input po_ex_rate2,
                  input po_taxc,
                  output w_pod_req_nbr,
                  output w_pod_req_line,
                  output w_pod_part,
                  output w_pod_pur_cost,
                  output w_pod_disc_pct,
                  output w_pod_qty_ord,
                  output w_pod_need,
                  output w_pod_due_date,
                  output w_pod_um,
                  output w_pod_um_conv,
                  output w_pod_project,
                  output w_pod_acct,
                  output w_pod_sub,
                  output w_pod_cc,
                  output w_pod_request,
                  output w_pod_approve,
                  output w_pod_apr_code,
                  output w_pod_desc,
                  output w_pod_taxc,
                  output w_pod_taxable,
                  output w_pod_vpart,
                  output w_pod_cmtindx,
                  output w_pod_lot_rcpt,
                  output w_pod_rev,
                  output w_pod_loc,
                  output w_pod_insp_rqd,
                  output w_mfgr,
                  output w_mfgr_part,
                  output w_desc1,
                  output w_desc2,
                  output continue,
                  output ReqCommentIndex,
                  output l_pod_type)"}
            if c-application-mode <> "API" and continue = no then
                  undo mainloop, next mainloop.
            else if c-application-mode = "API" and continue = no then
                  undo mainloop, return error.

            if w_pod_req_nbr > "" then do:
            	 /* ss-20121220.1 -b*/
               find first rqd_det where rqd_nbr = w_pod_req_nbr 
               and rqd_line = w_pod_req_line no-lock no-error. 
               if avail rqd_det then do:
               	  pod_due_date = rqd_due_date.               	  
               end.               
            	 /* ss-20121220.1 -e*/
               assign
                  pod_req_nbr      = w_pod_req_nbr
                  pod_req_line     = w_pod_req_line
                  pod_part         = w_pod_part
                  pod_pur_cost     = w_pod_pur_cost
                  pod_disc_pct     = w_pod_disc_pct
                  pod_qty_ord      = w_pod_qty_ord
                  pod_need         = w_pod_need
              /*  pod_due_date     = w_pod_due_date   *ss-20121220.1 */ 
                  pod_um           = w_pod_um
                  pod_um_conv      = w_pod_um_conv
                  pod_project      = w_pod_project
                  pod_acct         = w_pod_acct
                  pod_sub          = w_pod_sub
                  pod_cc           = w_pod_cc
                  pod_request      = w_pod_request
                  pod_approve      = w_pod_approve
                  pod_apr_code     = w_pod_apr_code
                  pod_desc         = w_pod_desc
                  pod_taxc         = w_pod_taxc
                  pod_taxable      = w_pod_taxable
                  pod_vpart        = w_pod_vpart
                  pod_cmtindx      = w_pod_cmtindx
                  pod_lot_rcpt     = w_pod_lot_rcpt
                  pod_rev          = w_pod_rev
                  pod_loc          = w_pod_loc
                  pod_insp_rqd     = w_pod_insp_rqd
                  mfgr             = w_mfgr
                  mfgr_part        = w_mfgr_part
                  desc1            = w_desc1
                  desc2            = w_desc2
                  pod_type         = l_pod_type.
            end.
 
            price_came_from_req = using_grs and pod_pur_cost <> 0.

            if po_project > '' then
               pod_project = po_project.
            if c-application-mode <> "API" then
               display
                  pod_req_nbr
                  pod_part
                  pod_qty_ord
                  pod_um
                  pod_pur_cost
                  pod_disc_pct
                  with frame c.

            assign disc = pod_disc_pct.

            assign
               podcmmts = pod_cmtindx <> 0 or (poc_lcmmts)
               continue = no.
            /*ADM1*/
            {gpaud1.i &uniq_num1 = 01  &uniq_num2 = 02
               &db_file = pod_det &db_field = pod_nbr}
            /*ADM1 end*/               
            {gprun.i ""popomtea.p""}
            if c-application-mode <> "API" and continue = no then
               undo mainloop, next mainloop.
            else if c-application-mode = "API" and continue = no then
               undo mainloop, return error.
            /* CHECK IF ITEM PLANNING RECORD AVAILABLE IF SO CHECK */
            /* IF INSPECTION OF LOCATION REQUIRED    */

            {pxrun.i &PROC='getSiteDataBase' &PROGRAM='icsixr.p'
                     &PARAM="(input pod_site,
                              output siteDB)"
                     &NOAPPERROR=True &CATCHERROR=True}
            /* IN MULTI-DB INSPECTION LOCATION IS HANDLED BY popomte1.p */
            if siteDB = global_db then do:
            /* CHANNGED OUTPUT PARAMETR pod_insp_rqd TO INPUT-OUTPUT PARAMETER */
               {pxrun.i &PROC='getInspectionRequired' &PROGRAM='ppipxr.p'
                        &PARAM="(input pod_part,
                                 input pod_site,
                                 input-output pod_insp_rqd)"
                        &NOAPPERROR=True &CATCHERROR=True}
            end. /* IF siteDB = GLOBAL_DB */
            if pod_insp_rqd then do :
               {pxrun.i &PROC='getInspectionLocation' &PROGRAM='popoxr1.p'
                        &PARAM="(output pod_loc)"
                        &NOAPPERROR=True
                        &CATCHERROR=True}
            end.
            {pxrun.i &PROC='getERSLineOption' &PROGRAM='aperxr.p'
                     &PARAM="(input po_ers_opt,
                              input po_pr_lst_tp,
                              input po_vend,
                              input pod_part,
                              input pod_site,
                              output pod_ers_opt,
                              output pod_pr_lst_tp)"
                     &NOAPPERROR=True &CATCHERROR=True}
         end. /* NEW pod_det: site, req AND part prompts */
         else do:
            old_pod_site = pod_site.
            /* MODIFY EXISTING LINE - REVERSE OLD HISTORY */

            {pxrun.i &PROC='validateSiteSecurity' &PROGRAM='icsixr.p'
                     &PARAM="(input pod_site,
                              input '')"
                     &NOAPPERROR=True
                     &CATCHERROR=True}
            if return-value <> {&SUCCESS-RESULT} then
            do:
               if c-application-mode <> "API" then
               do:
                  if not batchrun then
                     pause.
                  undo mainloop, retry.
               end.
               else
                  undo mainloop, return error.
            end. /* If return-value <> {&SUCCESS-RESULT} */

            if po_stat <> "c" and po_stat <> "x" and
               pod_status <> "c" and pod_status <> "x" then do:
               assign
                  pod_recno = recid(pod_det)
                  po_recno = recid(po_mstr).
               {pxrun.i &PROC='reversePOTransactionHistory' &PROGRAM='popoxr1.p'
                        &PARAM="(input pod_nbr,
                                 input pod_site,
                                 input pod_line)"
                        &NOAPPERROR=True &CATCHERROR=True}

            end. /* if po_stat <> "c" and po_stat <> "x" and */
            assign
               new_pod = no
               desc1 = pod_desc
               desc2 = "".
               
          /*ADM1*/
          {gpaud1.i &uniq_num1 = 01  &uniq_num2 = 02
             &db_file = pod_det &db_field = pod_nbr}
          /*ADM1 end*/                
          end. /* Else Do */

         status input.
         line = pod_line.

         {pxrun.i &PROC='getBasicItemData' &PROGRAM='ppitxr.p'
                  &PARAM="(input pod_part,
                           output desc1,
                           output desc2,
                           output dummyDecimal,
                           output dummyChar,
                           output dummyChar,
                           output st_um,
                           output dummyChar)"}
         if return-value = {&SUCCESS-RESULT} then
            itemAvailable = true.
         else
            itemAvailable = false.

         if not itemAvailable then
            assign
               desc1 = getTermLabel("ITEM_NOT_IN_INVENTORY",24)
               st_um = pod_um.

         if pod_desc <> "" then
            desc1 = pod_desc.

         if pod_desc <> "" then desc1 = pod_desc.

         if not sngl_ln then do:
            {pxmsg.i
               &MSGTEXT= "desc1 + "" "" + desc2"
            }
         end.

         /* SET GLOBAL PART VARIABLE */
         assign
            global_part = pod_part
            old_qty_ord = pod_qty_ord
            old_pur_cost = pod_pur_cost
            old_pod_status = pod_status
            old_type = pod_type
            old_vpart = pod_vpart
            old_um = pod_um
            old_disc_pct = pod_disc_pct.

         /* DISPLAY FRAMES C & D, INITAILIZE mfgr */
         {pxrun.i &PROC='uiDisplayFrameCandD'
                  &NOAPPERROR=True
                  &CATCHERROR=True}

         ststatus = stline[2].
         status input ststatus.
         del-yn = no.

         {pxrun.i &PROC='getManufacturerItemData' &PROGRAM='ppsuxr.p'
                  &PARAM="(input pod_part,
                           input '',
                           input po_vend,
                           output mfgItem,
                           output mfgId,
                           output supplierUM)"
                  &NOAPPERROR=True &CATCHERROR=True}

         if return-value = {&SUCCESS-RESULT} then do:
            if pod_um      = "" and
               pod_req_nbr = ""
            then
               pod_um = supplierUM.
         end.

         if pod_um = "" and
            itemAvailable then
            pod_um = st_um.

         if c-application-mode <> "API" then
            display
               pod_qty_ord
               pod_um
               pod_pur_cost
               l_display_disc @ pod_disc_pct
               with frame c.

         setc-1:
         do on error undo, retry:
            if retry and c-application-mode = "API" then
               undo setc-1, return error.
            if c-application-mode <> "API" then
               hide frame line_pop no-pause.
            pod_recno = recid(pod_det).

            if  not sngl_ln
            and pod_sched
            then
               pause 0.
               
            {gprun.i ""popomth.p""}
            /*ADM1 for DELETE action*/
            {gpaud2xx.i &uniq_num1 = 01  &uniq_num2 = 02
               &db_file = pod_det &db_field = pod_nbr &db_field1 = pod_line}
            /*ADM1 end*/
                           
            if c-application-mode <> "API" and
               keyfunction(lastkey) = "end-error" then
               undo mainloop, retry.

            if c-application-mode <> "API" and continue = no then
               next mainloop.
            else if c-application-mode = "API" and continue = no then
            do:
               run getNextApiLine (output result).
               next mainloop.
            end.

            {pxrun.i &PROC='getPOLinePricingEffectiveDate' &PROGRAM='popoxr1.p'
                     &PARAM="(input poc_pc_line,
                             input po_ord_date,
                             input pod_due_date,
                             output lineffdate)"
                     &NOAPPERROR=True
                     &CATCHERROR=True}

            if sngl_ln and poc_pc_line then
            setc-1a:
            do on error undo, retry:
               pause 0.
               old_crt_int = pod_crt_int.
               if c-application-mode <> "API" then
                  update
                     pod_due_date
                     pod_crt_int
                  with frame line_pop no-validate.
               else  /* c-application-mode = "API" */
                 assign
                   {mfaiset.i pod_due_date  ttPurchaseOrderDet.dueDate}
                   {mfaiset.i pod_crt_int  ttPurchaseOrderDet.crtInt}.

               /* CHECKS FOR ACCESS ON PO LINE CREDIT TERMS INTEREST */
               if pod_crt_int <> old_crt_int then do:
                  {pxrun.i &PROC='validatePOLineCreditTermsInt'
                           &PROGRAM='popoxr1.p'
                           &PARAM="(input pod_crt_int)"
                           &NOAPPERROR=true
                           &CATCHERROR=true}

                  if return-value <> {&SUCCESS-RESULT} then do:
                     next-prompt pod_crt_int with frame line_pop no-validate.
                     undo setc-1a, retry setc-1a.
                  end.
               end. /* IF pod_crt_int <> old_crt_int */

               if c-application-mode <> "API" then
               do:
                  display pod_due_date pod_crt_int with frame d.
                  hide frame line_pop no-pause.
               end.
               lineffdate = pod_due_date.
            end.

            if lineffdate = ? then
               lineffdate = today.

            /* ONLY CHECK PRICE LIST WHEN LINE IS CREATED */
            if new_pod then do:

               /* DO NOT RE-CALCULATE THE PRICING RELATED DATA   */
               /* FOR AN ITEM ADDED FROM A PURCHASE REQUISITION  */
               /* WHEN THE GRS MODULE HAS BEEN ACTIVATED         */
               if not price_came_from_req
               then do:

                  /* CALCULATES THE PRICING RELATED DATA */
                  {pxrun.i &PROC='getPricingData'
                           &PROGRAM='popoxr1.p'
                           &PARAM="(buffer pod_det,
                                    input poc_pt_req,
                                    input poc_pl_req,
                                    input po_pr_list2,
                                    input po_pr_list,
                                    input lineffdate,
                                    input po_curr,
                                    input new_pod,
                                    input disc,
                                    input-output old_pur_cost,
                                    input-output old_disc_pct,
                                    output netcost,
                                    output dummy_cost,
                                    output minprice,
                                    output maxprice)"
                           &NOAPPERROR=True
                           &CATCHERROR=True}

                  if return-value <> {&SUCCESS-RESULT} then
                     if c-application-mode <> "API" then
                        undo mainloop, retry.
                     else
                        undo mainloop, return error.

                  if c-application-mode <> "API" and keyfunction(lastkey) = "end-error"
                  then
                     undo mainloop, retry.

               end. /* IF not price_came_from_req */

               /* ONLY DISPLAY BASE COST WHEN ADDING NEW LINES. SINCE    */
               /* THATS THE ONLY TIME IT'S CALCULATED IN POPOMTH.P       */
               if new pod_det and
                  po_curr <> base_curr and
                  pod_pur_cost <> 0
               then do:
                  /* MESSAGE #684 - BASE CURRENCY LIST PRICE */
                  {pxmsg.i
                     &MSGNUM=684
                     &ERRORLEVEL={&INFORMATION-RESULT}
                     &MSGARG1= "base_cost, "">>>>,>>>,>>9.99<<<"" "}
               end. /* if new pod_det */

            end.  /* Price checking for new line */

            if c-application-mode <> "API" then
               display pod_pur_cost with frame c.
            if pod_pur_cost = 0 then do:
               assign
                 pod_pur_cost = dummy_cost
                 old_pur_cost = pod_pur_cost.
               if c-application-mode <> "API" then
                  display pod_pur_cost with frame c.
            end.

            st_qty = pod_qty_ord * pod_um_conv.

            if sngl_ln and c-application-mode <> "API" then
               display st_qty with frame d.

            setc-2:
            do while true on error undo, retry:
             if retry and c-application-mode = "API" then
                undo setc-2, return error.

               {pxrun.i &PROC='setPOLineCostAndDiscountPercent'
                        &PROGRAM='popoxr1.p'
                        &PARAM="(input old_disc_pct,
                                 input old_pur_cost,
                                 output l_actual_disc,
                                 buffer pod_det)"
                        &NOAPPERROR=True
                        &CATCHERROR=True}

               assign
                  oldUnitCost = pod_pur_cost
                  oldDiscountPct = pod_disc_pct.
               if not pod_sched then
                  if c-application-mode <> "API" then
                     update
                        pod_pur_cost
                        pod_disc_pct
                      with frame c no-validate.
                  else
                     assign
                        {mfaiset.i pod_pur_cost  ttPurchaseOrderDet.purCost}
                        {mfaiset.i pod_disc_pct  ttPurchaseOrderDet.discPct}
                         .

               else
                  /* SCHEDULE EXISTS FOR THIS ORDER LINE */
                  {pxmsg.i &MSGNUM=6014 &ERRORLEVEL=1}

               /* VALIDATES PO LINE UNIT COST */
               if pod_pur_cost <>  oldUnitCost then do:
                  {pxrun.i &PROC='validatePOLineUnitCost' &PROGRAM='popoxr1.p'
                           &PARAM="(input pod_pur_cost)"
                           &NOAPPERROR=true
                           &CATCHERROR=true}

                  if return-value <> {&SUCCESS-RESULT} then do:
                     if c-application-mode <> "API" then
                     do:
                        next-prompt
                        pod_pur_cost
                        with frame c no-validate.
                        undo setc-2, retry setc-2.
                     end.
                     else
                        undo setc-2, return error.
                  end.
               end.

               /* VALIDATES PO LINE DISCOUNT PERCENT */
               if pod_disc_pct <>  oldDiscountPct then do:
                 {pxrun.i &PROC='validatePOLineDiscountPct' &PROGRAM='popoxr1.p'
                          &PARAM="(input pod_disc_pct)"
                          &NOAPPERROR=true
                          &CATCHERROR=true}

                  if return-value <> {&SUCCESS-RESULT} then do:
                     next-prompt
                        pod_disc_pct
                     with frame c no-validate.

                     undo setc-2, retry setc-2.
                  end.
               end.

               if (c-application-mode <> "API" and not pod_disc_pct entered)
                  or (c-application-mode = "API" and pod_disc_pct = ?)
                     then pod_disc_pct = l_actual_disc.

               if pod_pur_cost <> old_pur_cost
                  and pod_qty_rcvd <> 0 then do:
                  yn = no.
                  if c-application-mode <> "API" then
                  do:
                     /* MESSAGE #333 - ITEMS RECEIVED FOR THIS LINE - */
                    /* CHANGE PURCHASE PRICE? */
                     {pxmsg.i
                        &MSGNUM=333
                        &ERRORLEVEL={&WARNING-RESULT}
                        &CONFIRM=yn}
                     /*{mfmsg01.i 333 2 yn}*/
                     if yn = no then
                     do:
                        pod_pur_cost = old_pur_cost.
                        display pod_pur_cost with frame c.
                        next-prompt pod_pur_cost with frame c.
                        undo setc-2, retry.
                     end.
                  end.  /* if c-application-mode <> API */

               end.

               {pxrun.i &PROC='validatePOCostsForMinMaxViolation'
                        &PROGRAM='popoxr1.p'
                        &PARAM="(input po_pr_list2,
                                 input pod_part,
                                 input maxprice,
                                 input minprice,
                                 input-output dummy_cost,
                                 input-output pod_pur_cost)"
                        &NOAPPERROR=True
                        &CATCHERROR=True}

               if return-value <> {&SUCCESS-RESULT} then do:
                  {pxrun.i &PROC='setUnitCostWithMinMaxPrice'
                           &PROGRAM='popoxr1.p'
                           &PARAM="(input maxprice,
                                    input minprice,
                                    input-output pod_pur_cost,
                                    input-output pod_disc_pct)"
                           &NOAPPERROR=True
                           &CATCHERROR=True}

                  next setc-2.
               end.

               if po_pr_list2 <> "" then do:
                  {pxrun.i &PROC='getNetUnitCost' &PROGRAM='popoxr1.p'
                           &PARAM="(buffer pod_det,
                                    output netcost)"
                           &NOAPPERROR=True
                           &CATCHERROR=True}
               end.

               {pxrun.i &PROC='validatePOCostsForMinMaxViolation'
                        &PROGRAM='popoxr1.p'
                        &PARAM="(input po_pr_list2,
                                 input pod_part,
                                 input maxprice,
                                 input minprice,
                                 input-output dummy_cost,
                                 input-output netcost)"
                        &NOAPPERROR=True
                        &CATCHERROR=True}

               if return-value <> {&SUCCESS-RESULT} then do:
                  {pxrun.i &PROC='setNetCostWithMinMaxPrice'
                           &PROGRAM='popoxr1.p'
                           &PARAM="(input maxprice,
                                    input minprice,
                                    input-output netcost,
                                    input-output pod_disc_pct,
                                    input-output dummy_cost,
                                    input-output pod_pur_cost)"
                           &NOAPPERROR=True
                           &CATCHERROR=True}

                  next setc-2.
               end.

               /* CHECK OUT OF TOLERANCE CONDITION FOR GRS REQ'S */
               if using_grs then do:

                  /* ADDED SECOND EXCHANGE RATE BELOW */
                  {gprunmo.i
                     &program="popomtra.p"
                     &module="GRS"
                     &param="""(input yes,
                        input pod_site,
                        input pod_req_nbr,
                        input pod_req_line,
                        input pod_pur_cost,
                        input po_ex_rate,
                        input po_ex_rate2,
                        input po_curr,
                        input po_fix_rate,
                        input po_vend,
                        input pod_disc_pct,
                        input pod_qty_ord,
                        input pod_um,
                        input pod_um_conv,
                        input pod_part,
                        input new_pod,
                        output oot_ponetcst,
                        output oot_poum,
                        output oot_rqnetcst,
                        output oot_rqum,
                        output return_status)"""}

                  assign oot_pod_site = pod_site
                     oot_pod_req_nbr = pod_req_nbr
                     oot_pod_req_line = pod_req_line.

                  if return_status = 'undoretry_unitcostprompt' then do:
                     if c-application-mode <> "API" then
                     do:
                        next-prompt pod_pur_cost with frame c.
                        undo setc-2, retry.
                     end.  /* If c-application-mode = "API" */
                     else
                        undo setc-2, return error.
                  end.
                  else if return_status begins 'undo_pod_line_mark_req_oot'
                     then do:
                        if c-application-mode <> "API" then
                           undo mainloop, retry mainloop.
                        else
                           undo mainloop, return error.
                  end.
               end.
               leave setc-2.
            end.
            /* END OF setc-2 BLOCK */

            if pod_pur_cost <> old_pur_cost or
               pod_disc_pct <> old_disc_pct or (new_pod and
               (pod__qad09 + pod__qad02 / 100000) = 0) then do:
               pod__qad09 = pod_pur_cost * (1 - (pod_disc_pct / 100)).
               pod__qad02 = (pod_pur_cost * (1 - (pod_disc_pct / 100))
               - pod__qad09) * 100000.
            end.

            {pxrun.i &PROC='validatePurchaseCost' &PROGRAM='popoxr1.p'
                     &PARAM="(input pod_pur_cost)"
                     &NOAPPERROR=True &CATCHERROR=True}
            if (pod_pur_cost <> 0) and
               (sngl_ln = yes) then do:
               {pxrun.i &PROC='getNetUnitCost' &PROGRAM='popoxr1.p'
                        &PARAM="(buffer pod_det,
                                 output l_netunitcost)"
                        &NOAPPERROR=True
                        &CATCHERROR=True}
               /* MESSAGE #5014 - NET UNIT COST = # */
               /* The display format for Net Unit Cost should */
               /* not specify more than 5 decimal places */
               {pxmsg.i
                  &MSGNUM=5014
                  &ERRORLEVEL={&INFORMATION-RESULT}
                  &MSGARG1= "l_netunitcost, ""->>>,>>>,>>9.99<<<"" "
                  &MSGARG2=""""
                  &MSGARG3=""""}
            end. /* IF (POD_PUR_COST <> 0) AND .. */

            if sngl_ln = yes then do:
               assign continue = no
                  pod_recno = recid(pod_det).
/*ADM         {gprun.i ""popomtd.p""}*/
/*ADM*/         {gprun.i ""popomtdxxxx.p""}

/*ss20130118 b*/	if myflag = yes then do:
						undo mainloop,retry mainloop.
					end.

               if c-application-mode <> "API" and continue = no then
                  undo mainloop, next mainloop.
               else if c-application-mode = "API" and continue = no then
                  undo mainloop, return error.

            end.
            else do:
               assign continue = no
                  pod_recno = recid(pod_det).
/*ADM         {gprun.i ""popomtd2.p""}*/
/*ADM*/         {gprun.i ""popomtd2xx.p""}
               if c-application-mode <> "API" then
                  if continue = no then
                     undo mainloop, next mainloop.
               else  /* c-application-mode = "API" */
                  if continue = no then
                     undo mainloop, return error.
            end.

            if not using_grs then do:

               {pxrun.i &PROC='validateRequisitionRequired' &PROGRAM='popoxr1.p'
                        &PARAM="(buffer pod_det,
                                 input blanket)"
                        &NOAPPERROR=True &CATCHERROR=True}

               if return-value <> {&SUCCESS-RESULT} then do:
                  line = line - 1.
                  clear frame c.
                  /* Single Line Entry. */
                  if sngl_ln then
                     clear frame d all no-pause.
                  if c-application-mode <> "API" then
                     next mainloop.
                  else
                     undo mainloop, return error.
               end.

            end. /* IF NOT using_grs*/

            /* SET pod_need AND pod_per_date, IF STILL BLANK */
            if pod_need = ? then
               pod_need = pod_due_date.

            if pod_per_date = ? then
               pod_per_date = pod_due_date.

            /* ADD COMMENTS IF DESIRED */
            if podcmmts = yes or c-application-mode = "API"
            then do on error undo mainloop, retry:
               if c-application-mode <> "API" then
               do:
                 hide frame d no-pause.
                 hide frame c no-pause.
                 hide frame chead no-pause.
                 hide frame dtitle no-pause.
               end.  /* If c-application-mode <> "API" */

               if c-application-mode = "API" then
               do:
                  {gpttcp.i ttPurchaseOrderDetCmt
                            ttTransComment
                            "ttPurchaseOrderDetCmt.nbr
                            = ttPurchaseOrderDet.nbr and
                            ttPurchaseOrderDetCmt.line
                            = ttPurchaseOrderDet.line"}

                  run setTransComment in ApiMethodHandle (input table ttTransComment).

               end.

               cmtindx = pod_cmtindx.
               global_ref = pod_part.
               {gprun.i ""gpcmmt01.p"" "(input ""pod_det"")"}

               pod_cmtindx = cmtindx.

               if c-application-mode <> "API" then
               do:
                 view frame dtitle.
                 view frame chead.
                 view frame c.

                 if sngl_ln then
                    view frame d.
               end.  /* If c-application-mode <> "API" */

            end.

            {pxrun.i &PROC='updatePOLineData' &PROGRAM='popoxr1.p'
                     &PARAM="(input pod_nbr,
                              input pod_line,
                              input old_pod_status,
                              input old_type,
                              input blanket)"
                     &NOAPPERROR=True &CATCHERROR=True}
         end.  /* SETC-1 */

         if c-application-mode <> "API" then
            if not sngl_ln then down 1 with frame c.

         {pxrun.i &PROC='getPurchaseOrderLinePOSite' &PROGRAM='popoxr1.p'
                  &PARAM="(input po_site,
                           input pod_site,
                           output pod_po_site)"
                  &NOAPPERROR=True &CATCHERROR=True}

         {pxrun.i &PROC='createIntrastatDetail' &PROGRAM='popoxr1.p'
                  &PARAM="(buffer pod_det)" &NOAPPERROR=True &CATCHERROR=True}
         if return-value <> {&SUCCESS-RESULT} then
         do:
            if c-application-mode <> "API" then
               next mainloop.
            else
               return error.
               next mainloop.
         end.

      end. /* Do transaction */
      if c-application-mode = "API" then
      do:
        run getNextApiLine (output result).
      end.
      /*ADM1*/
      {gpaud2xx.i &uniq_num1 = 01  &uniq_num2 = 02
         &db_file = pod_det &db_field = pod_nbr &db_field1 = pod_line}
      /*ADM1 end*/       
   end. /* Mainloop: repeat */
end. /* Linefmt: repeat */
/*ADM1*/
{gpaud3.i &uniq_num1 = 01  &uniq_num2 = 02
   &db_file = pod_det &db_field = pod_nbr}
/*ADM1 end*/ 
{&POPOMTA-P-TAG7}
hide frame d no-pause.
hide frame c.

/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */

/*============================================================================*/
PROCEDURE uiDisplayFrameCandD :

/*------------------------------------------------------------------------------
  Purpose:  Purchase order maintenance - display frames C & D, initialize mfgr.
  Notes:
  History:  Code moved from pomta01.i into this procedure.
------------------------------------------------------------------------------*/
/*@TO DO We need to define all the variables here */
   if pod_det.pod_disc_pct >  l_max_disc then
      l_display_disc =  l_max_disc.
   else if pod_disc_pct < l_min_disc then
      l_display_disc = l_min_disc.
   else
      l_display_disc = pod_disc_pct. /*61*/

   if c-application-mode <> "API" then
      display
         line
         pod_site
         pod_req_nbr
         pod_part
         pod_qty_ord
         pod_um
         pod_pur_cost
         l_display_disc @ pod_disc_pct
         with frame c.

   /* Single Line Entry. */
   if sngl_ln then do:
/*@TO DO Also Run in writeData popoxd1.p*/
      {pxrun.i &PROC='getPOLineExtendedCost' &PROGRAM='popoxr1.p'
               &PARAM="(input pod_nbr,
                        input pod_line,
                        input rndmthd,
                        output ext_cost)"
               &NOAPPERROR=True &CATCHERROR=True}

      if c-application-mode <> "API" then
         display
            pod_qty_rcvd
            pod_so_job
            pod_fix_pr
            pod_crt_int
            pod_lot_rcpt
            pod_loc
            pod_rev
            pod_vpart
            desc1
            desc2
            pod_due_date
            pod_per_date
            pod_need
            pod_status
            pod_acct
            pod_sub
            pod_cc
            pod_project
            pod_type
            pod_taxable
            pod_taxc
            pod_insp_rqd
            pod_um_conv
            st_qty
            st_um
            pod_cst_up
            pod_qty_chg
            podcmmts
            ext_cost when (ext_cost <> ? )
            with frame d.

      if pod_blanket <> "" then do:
         msg_var1 = pod_blanket.
         if pod_blnkt_ln <> 0 then do:
            msg_var1 = msg_var1 + "/" + string(pod_blnkt_ln).
         end.

         {gprun.i ""gpmsg03.p""
            "(input 386,
              input 1,
              input msg_var1,
              input string(pod_rel_nbr),
              input string(pod_rel_qty))"}
      end.

      assign mfgr = ""
         mfgr_part = "".

      {pxrun.i &PROC='getManufacturerItemData' &PROGRAM='ppsuxr.p'
               &PARAM="(input pod_part,
                        input pod_vpart,
                        input po_mstr.po_vend,
                        output mfgr_part,
                        output mfgr,
                        output supplierUM)" &NOAPPERROR=True &CATCHERROR=True}

      if c-application-mode <> "API" then
         display
            mfgr
            mfgr_part
            with frame d.
   end. /* IF sngl_ln */

   /* IF NOT sngl_ln */
   else if pod_vpart <> "" or
      pod_vpart  = "" then
      find first vp_mstr
         where vp_part = pod_part
         and vp_vend_part = pod_vpart
         and vp_vend = po_vend
         no-lock no-error.

END PROCEDURE.

PROCEDURE getNextApiLine.

define output parameter result as character no-undo.

   create ttPurchaseOrderDet.
   run getNextPoToDetLink in ApiMethodHandle
      (buffer ttPurchaseOrderDet).
   assign result = RETURN-VALUE.

END PROCEDURE.
