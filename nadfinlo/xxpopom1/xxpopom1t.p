/* pomt.p - PURCHASE ORDER MAINTENANCE - Regular and Blanket POs              */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.13.2.23 $                                                */
/* REVISION: 1.0     LAST MODIFIED: 08/30/86    BY: PML *14*  */
/* REVISION: 1.0     LAST MODIFIED: 02/11/86    BY: EMB       */
/* REVISION: 2.0     LAST MODIFIED: 12/19/86    BY: PML *A3*  */
/* REVISION: 2.0     LAST MODIFIED: 03/12/87    BY: EMB *A41* */
/* REVISION: 4.0     LAST MODIFIED: 03/10/88    BY: FLM *A108**/
/* REVISION: 4.0     LAST MODIFIED: 12/27/87    BY: PML *A119**/
/* REVISION: 4.0     LAST MODIFIED: 01/14/88    BY: WUG *A145**/
/* REVISION: 4.0     LAST MODIFIED: 07/26/88    BY: RL  *C0028*/
/* REVISION: 4.0     LAST MODIFIED: 10/25/88    BY: WUG *A494**/
/* REVISION: 4.0     LAST MODIFIED: 12/13/88    BY: MLB *A560**/
/* REVISION: 4.0     LAST MODIFIED: 02/27/89    BY: WUG *B038**/
/* REVISION: 4.0     LAST MODIFIED: 03/16/89    BY: MLB *A673**/
/* REVISION: 4.0     LAST MODIFIED: 03/24/89    BY: FLM *A685**/
/* REVISION: 4.0     LAST MODIFIED: 04/11/89    BY: FLM *A708**/
/* REVISION: 5.0     LAST MODIFIED: 05/16/89    BY: MLB *B118**/
/* REVISION: 5.0     LAST MODIFIED: 12/21/89    BY: FTB *B466**/
/* REVISION: 5.0     LAST MODIFIED: 02/27/90    BY: EMB *B591**/
/* REVISION: 6.0     LAST MODIFIED: 03/21/90    BY: FTB *D011**/
/* REVISION: 6.0     LAST MODIFIED: 03/22/90    BY: FTB *D013**/
/* REVISION: 6.0     LAST MODIFIED: 05/21/90    BY: WUG *D002**/
/* REVISION: 5.0     LAST MODIFIED: 06/11/90    BY: RAM *B706**/
/* REVISION: 6.0     LAST MODIFIED: 06/20/90    BY: RAM *D030**/
/* REVISION: 6.0     LAST MODIFIED: 06/29/90    BY: WUG *D043**/
/* REVISION: 6.0     LAST MODIFIED: 07/06/90    BY: EMB *D040**/
/* REVISION: 6.0     LAST MODIFIED: 08/13/90    BY: SVG *D058**/
/* REVISION: 6.0     LAST MODIFIED: 10/18/90    BY: PML *D109**/
/* REVISION: 6.0     LAST MODIFIED: 10/24/90    BY: RAM *D135**/
/* REVISION: 6.0     LAST MODIFIED: 10/27/90    BY: pml *D146**/
/* REVISION: 6.0     LAST MODIFIED: 11/13/90    BY: pml *D221**/
/* REVISION: 6.0     LAST MODIFIED: 01/02/91    BY: dld *D259**/
/* REVISION: 6.0     LAST MODIFIED: 01/02/91    BY: MLB *D238**/
/* REVISION: 6.0     LAST MODIFIED: 01/21/91    BY: dld *D311**/
/* REVISION: 6.0     LAST MODIFIED: 02/11/91    BY: RAM *D345**/
/* REVISION: 6.0     LAST MODIFIED: 03/07/91    BY: dld *D409**/
/* REVISION: 6.0     LAST MODIFIED: 03/08/91    BY: RAM *D410**/
/* REVISION: 6.0     LAST MODIFIED: 04/08/91    BY: RAM *D502**/
/* REVISION: 6.0     LAST MODIFIED: 04/11/91    BY: RAM *D518**/
/* REVISION: 6.0     LAST MODIFIED: 05/07/91    BY: RAM *D621**/
/* REVISION: 6.0     LAST MODIFIED: 05/09/91    BY: RAM *D634**/
/* REVISION: 6.0     LAST MODIFIED: 08/15/91    BY: pma *D829**/ /*rev only*/
/* REVISION: 7.0     LAST MODIFIED: 09/12/91    BY: RAM *F033**/
/* REVISION: 6.0     LAST MODIFIED: 09/24/91    BY: RAM *D872**/
/* REVISION: 6.0     LAST MODIFIED: 10/10/91    BY: dgh *D892**/
/* REVISION: 7.0     LAST MODIFIED: 11/08/91    BY: MLV *F029**/
/* REVISION: 6.0     LAST MODIFIED: 11/11/91    BY: RAM *D921**/
/* REVISION: 7.0     LAST MODIFIED: 02/04/92    BY: RAM *F163**/
/* REVISION: 7.0     LAST MODIFIED: 06/19/92    BY: tmd *F458**/
/* REVISION: 7.0     LAST MODIFIED: 07/01/92    BY: afs *F727**/
/* REVISION: 7.0     LAST MODIFIED: 07/31/92    BY: afs *F827*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 08/05/92    BY: tjs *G027**/
/* REVISION: 7.3     LAST MODIFIED: 08/18/92    BY: tjs *G028*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 10/01/92    BY: tjs *G117**/
/* REVISION: 7.3     LAST MODIFIED: 10/08/92    BY: tjs *G143*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 10/12/92    BY: tjs *G164*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 12/18/92    BY: afs *G465*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 01/05/93    BY: mpp *G481*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 01/06/93    BY: bcm *G417**/
/* REVISION: 7.3     LAST MODIFIED: 02/11/93    BY: afs *G674**/
/* REVISION: 7.3     LAST MODIFIED: 02/17/93    BY: tjs *G684*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 02/21/93    BY: afs *G716**/
/* REVISION: 7.3     LAST MODIFIED: 02/22/93    BY: bcm *G717*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 02/23/93    BY: tjs *G728*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 02/23/93    BY: tjs *G735**/
/* REVISION: 7.3     LAST MODIFIED: 03/15/93    BY: tjs *G810**/
/* REVISION: 7.3     LAST MODIFIED: 03/16/93    BY: tjs *G815*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 04/09/93    BY: pma *G928*   (rev only)   */
/* REVISION: 7.3     LAST MODIFIED: 04/19/93    BY: tjs *G964**/
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
/* REVISION: 7.4     LAST MODIFIED: 09/07/93    BY: tjs *H082**/
/* REVISION: 7.4     LAST MODIFIED: 09/29/93    BY: cdt *H086**/
/* REVISION: 7.4     LAST MODIFIED: 10/28/93    BY: dpm *H198*   (rev only)   */
/* REVISION: 7.4     LAST MODIFIED: 10/23/93    BY: cdt *H184**/
/* REVISION: 7.4     LAST MODIFIED: 11/14/93    BY: afs *H221**/
/* REVISION: 7.4     LAST MODIFIED: 02/10/94    BY: dpm *FM06**/
/* REVISION: 7.4     LAST MODIFIED: 04/19/94    BY: WUG *FN46**/
/* REVISION: 7.4     LAST MODIFIED: 05/23/94    BY: afs *FM85**/
/* REVISION: 7.4     LAST MODIFIED: 05/27/94    BY: afs *FO49**/
/* REVISION: 7.4     LAST MODIFIED: 06/17/94    BY: qzl *H392**/
/* REVISION: 7.4     LAST MODIFIED: 06/21/94    BY: qzl *H397**/
/* REVISION: 7.4     LAST MODIFIED: 09/11/94    BY: rmh *GM16**/
/* REVISION: 7.4     LAST MODIFIED: 09/20/94    BY: ljm *GM74**/
/* REVISION: 7.4     LAST MODIFIED: 10/27/94    BY: cdt *FS95**/
/* REVISION: 7.4     LAST MODIFIED: 11/06/94    BY: rwl *GO27**/
/* REVISION: 8.5     LAST MODIFIED: 11/10/94    BY: mwd *J034**/
/* REVISION: 8.5     LAST MODIFIED: 02/21/95    BY: dpm *J044**/
/* REVISION: 7.4     LAST MODIFIED: 05/03/95    BY: dxk *G0L7**/
/* REVISION: 7.4     LAST MODIFIED: 08/16/95    BY: jym *G0V4**/
/* REVISION: 7.4     LAST MODIFIED: 08/25/95    BY: ais *G0VN**/
/* REVISION: 7.4     LAST MODIFIED: 09/19/95    BY: ais *G0X6**/
/* REVISION: 8.5     LAST MODIFIED: 01/15/95    BY: kxn *J0BS**/
/* REVISION: 8.5     LAST MODIFIED: 09/27/95    BY: taf *J053**/
/* REVISION: 8.5     LAST MODIFIED: 03/19/96    BY: *J0CV* Robert Wachowicz   */
/* REVISION: 8.5     LAST MODIFIED: 04/09/96    BY: *J0HQ* Gary Morales       */
/* REVISION: 8.5     LAST MODIFIED: 05/15/96    BY: *J0LX* Kieu Nguyen        */
/* REVISION: 8.5     LAST MODIFIED: 07/19/96    BY: *J0ZS* T. Farnsworth      */
/* REVISION: 8.5     LAST MODIFIED: 08/16/96    BY: *J146* Sue Poland         */
/* REVISION: 8.6     LAST MODIFIED: 10/22/96    BY: *K004* Kurt De Wit        */
/* REVISION: 8.6     LAST MODIFIED: 12/18/96    BY: *J1CJ* Sue Poland         */
/* REVISION: 8.6     LAST MODIFIED: 01/22/97    BY: *J1B1* Robin McCarthy     */
/* REVISION: 8.6     LAST MODIFIED: 05/16/97    BY: *J1RQ* Suresh Nayak       */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E    LAST MODIFIED: 06/02/98    BY: *L020* Charles Yen        */
/* REVISION: 9.1     LAST MODIFIED: 05/28/99    BY: *J3G1* Santosh Rao        */
/* REVISION: 9.1     LAST MODIFIED: 08/02/99    BY: *N014* Robin McCarthy     */
/* REVISION: 9.1     LAST MODIFIED: 03/02/00    BY: *L0SH* Santosh Rao        */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* Revision: 1.13.2.6   BY: Niranjan R.         DATE: 05/24/00  ECO: *N0C7*   */
/* Revision: 1.13.2.7   BY: Mudit Mehta         DATE: 07/06/00  ECO: *N0F3*   */
/* Revision: 1.13.2.8   BY: Pat Pigatti         DATE: 07/14/00  ECO: *N0G2*   */
/* Revision: 1.13.2.9   BY: Ashwini G.          DATE: 07/24/00  ECO: *J3Q2*   */
/* Revision: 1.13.2.10  BY: Anup Pereira        DATE: 07/10/00  ECO: *N059*   */
/* Revision: 1.13.2.11  BY: Ashwini G.          DATE: 08/18/00  ECO: *J3Q4*   */
/* Revision: 1.13.2.12  BY: Ashwini G.          DATE: 09/06/00  ECO: *M0S8*   */
/* Revision: 1.13.2.13  BY: Mudit Mehta         DATE: 09/26/00  ECO: *N0W9*   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.13.2.14      BY: Katie Hilbert  DATE: 04/01/01  ECO: *P002*    */
/* Revision: 1.13.2.15      BY: Jean Miller    DATE: 12/12/01  ECO: *P03N*    */
/* Revision: 1.13.2.16      BY: John Pison     DATE: 03/13/02  ECO: *N1BT*    */
/* Revision: 1.13.2.17      BY: John Pison     DATE: 03/15/02  ECO: *N1D7*    */
/* Revision: 1.13.2.18      BY: Dan Herman     DATE: 05/24/02  ECO: *P018* */
/* Revision: 1.13.2.22      BY: Andrea Suchankova DATE: 10/15/02 ECO: *N13P* */
/* $Revision: 1.13.2.23 $     BY: Narathip W.       DATE: 05/02/03 ECO: *P0R5* */
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
/*V8:ConvertMode=Maintenance                                                  */
/*                                                                            */
/* MAINTAINS BOTH BLANKET AND REGULAR PURCHASE ORDERS.                        */
/*                                                                            */
/* Creation: eB21SP3 Chui Last Modified: 20080624 By: Davild Xu *ss-20080624.1*/
/* ss-081210.1 by jack */
/*---Add Begin by davild 20080624.1*/
/* ss-081226.1 jack  */
/* ss-081230.1 jack */
/* ss-090104.1 jack */
/* ss-090108.1 jack */
/* ss-090109.1 jack */
/* ss -091105.1 by: jack */  /* 修改xxpopom1a.p*/
/*
xxpopom1t.p（popomt.p）
	xxrpomt.p(pomt.p)
		xxpopom1a.p(popomta.p)
			xxpopom1r.p(popomtr.p)
				xxpopom1r1.p(popomtr1.p)				
			xxpopomtea.p(popomtea.p)

a)首先判断5.2.1.24是否启动CER检验，若没有启动，处理逻辑与修改前一样；
b)在5.2.1.24启动后，若1.4.3中零件不需要CER，处理逻辑与修改前一样；
c)若在CER检查到生效日期小于采购单到期日期（pod_due_date）的非"不合格"CER，用户可以进行采购订单维护，否则提示用不能维护采购订单；
d)对于"M"类型采购，不需要进行CER检验，处理逻辑与修改前一样；
e)将查询到的CER代码，记录到采购订单明细资料中pod__chr08，若是限量采购类型，将已经订购数量记录在pod__dec01和xxcer_ord_qty中，若采购订单数量有修改，也必须修改pod__dec01内容(必须注意，当退换货时，订购数量 - 退货数量 <= 限购数量)。
f)将采购订单单头需求日期强制置空，以保证用户手工输入采购申请单时申请单需求日期和到期日期自动转为采购订单需求日期和到期日期；{****Davild0623****取申请单号的需求日期和到期日期}
g)采购订单明细中的税用途(pod_tax_usage)和纳税类型(pod_taxc)默认取值采购订单单头对应值(po_taxc/po_tax_usage)，用户可以修改；{****Davild0623****强制与表头一样}
h)若零件净重(pt_net_wt)小于零，则提示用户，该零件不能采购。
*/
/*---Add End   by davild 20080624.1*/
/* ss - 090617.1 by: jack */



/* SS - 100722.1 - RNB
[100722.1]

同时，财务要求修改5.7采购单维护程序，不允许修改“支付方式”(默认从供应商维护中自动获取)。

[100722.1]

SS - 100722.1 - RNE */

/* DISPLAY TITLE */
/* ss-081210.1 -b */
/* {mfdtitle.i "2+ "} */
/* ss-081226.1 -b */
/* {mfdtitle.i "081210.1 "} */
/* ss-081230.1 -b */
/* {mfdtitle.i "081226.1 "} */
/*
{mfdtitle.i "090109.1 "}
*/
/*
{mfdtitle.i "090617.1 "}
*/
/*
{mfdtitle.i "091105.1 "}
*/
/*{mfdtitle.i "100722.1 "}*/

/* ss-081230.1 -e */
/* ss-081210.1 -e */
/* ss-081226.1 -e */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100722.1  By: Bill Jiang */
/* SS - 110104.1  By: Roger Xiao */
/* SS - 110223.1  By: Roger Xiao */ /*just xxpopom1a.p: pod_taxable = po_taxable ;xxpopom1r1.p : cancel p_pod_disc_pct */
/* SS - 111010.1  By: Apple Tam */ /*增加项目编号（pod__chr01) */
/*-Revision end---------------------------------------------------------------*/
/* ss - 130307.1 by: jack */  /* modify xxpopomtf.p v_choifce initial no */
/*
{mfdtitle.i "111010.1"}
*/
{mfdtitle.i "130307.1"}


/* Clear anything displayed by mftitle if api mode.*/
{mfaititl.i}
{cxcustom.i "POMT.P"}
{pxmaint.i}

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
define new shared variable tax_in   like ad_tax_in.
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

/* ss-081210.1 -b */
define new shared var v_update as logical initial no .
/* ss-090104.1 -b */
/* define var v_pur_cost like pod_pur_cost .
define var v_disc_pct like pod_disc_pct .
define var v_choice as logical initial yes .
define var v_qty like pod_qty_ord .
define var v_logical as logical .
define var v_netcost like pod_pur_cost.
define var v_dummy_cost like pc_min_price.
define var v_minprice like  pc_min_price .
define var v_maxprice like pc_min_price .
define var v_duedate like po_due_date .
define var v_pc_recno as recid .

define temp-table tt
field tt_nbr like po_nbr 
field tt_part like pod_part
field tt_pur_cost like pod_pur_cost
field tt_disc_pct like pod_disc_pct .
*/
/* ss-090104.1 -e */

/* 用于存储每次进入时订单项次，对cer删除的同步更新 */
define temp-table tt2 
 field tt2_nbr like pod_nbr 
 field tt2_line like pod_line 
 field tt2_qty_ord like pod_qty_ord 
 field tt2__chr08 like pod__chr08 .

/* ss-081210.1 -e */
{&POMT-P-TAG2}
/* COMMON API CONSTANTS AND VARIABLES */
{mfaimfg.i}

/* PURCHASE ORDER API TEMP-TABLE, NAMED USING THE "Api" PREFIX */
{popoit01.i}

{icieit01.i}
{mfctit01.i}

{pocnvars.i} /* Variables for consignment inventory */
{pocnpo.i}  /* Consignment procedures */

if c-application-mode = "API" then do on error undo, return:

   /* GET HANDLE OF API CONTROLLER */
   {gprun.i ""gpaigh.p""
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

end.  /* If c-application-mode = "API" */

/*============================================================================*/
/* ****************************** Main Block ******************************** */
/*============================================================================*/

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_SUPPLIER_CONSIGNMENT,
     input 11,
     input ADG,
     input SUPPLIER_CONSIGN_CTRL_TABLE,
     output using_supplier_consignment)"}

assign
   blanket = pBlanket
   old_db = global_db.

/* DEFINE ROUND VARIABLES REQUIRED FOR PURCHASE ORDERS & RTS */
{pocurvar.i "NEW"}
/* DEFINE ROUND VARIABLES REQUIRED FOR TAX CALCULATIONS */
{txcurvar.i "NEW"}

/* DEFINE TRAILER VARS AS NEW, SO THAT CORRECT _OLD FORMATS */
/* CAN BE ASSIGNED BASED ON INITIAL DEFINE                  */
{potrldef.i "NEW"}

{pxrun.i &PROC='initialize-variables'}



mainloop:
repeat:
 /* ss-081226.1 -b */
 empty temp-table tt2 .
 /* ss-081226.1 -e */
   if c-application-mode = "API" and retry then
      return error.


   for first gl_ctrl no-lock:
   end.

   assign
      so_job = ""
      disc = 0
      comment_type = global_type.

   {popomt02.i}  /* Shared frames a and b */

   /* ADDRESS FORMS */
   /* VENDOR ADDRESS */
   {mfadform.i "vend" 1 SUPPLIER}
   /* SHIP TO ADDRESS */
   {mfadform.i "ship_to" 41 SHIP_TO}


   if c-application-mode <> "API" then
   do:
      view frame dtitle.
      view frame a.
      view frame vend.
      view frame ship_to.
      view frame b.
   end.  /* If c-application-mode <> "API" */

   if c-application-mode = "API" then
   do:
      if poTrans = "GETPONUM" then
      do:
         {pxrun.i &PROC='get-input'}
         assign ttPurchaseOrder.nbr = ponbr.
         run setPurchaseOrderRecord in ApiMethodHandle
            (buffer ttPurchaseOrder).

         return.
      end.
      else
         assign ponbr = ttPurchaseOrder.nbr.
   end. /* if c-application-mode = "API" */

   if c-application-mode <> "API" then
   do:
      {pxrun.i &PROC='get-input'}
      if keyfunction(lastkey) = "end-error" then
         undo mainloop, leave mainloop.
   end.  /* If c-application-mode <> "API" */

   do transaction on error undo, retry:

      if c-application-mode = "API" and retry then
         return error.

      for first poc_ctrl no-lock:
      end.
      if not available poc_ctrl then
         create poc_ctrl.

      assign
         sngl_ln = poc_ln_fmt
         pocmmts = poc_hcmmts.

      {pxrun.i &PROC='processRead' &PROGRAM='popoxr.p'
               &PARAM="(input ponbr,
                        buffer po_mstr,
                        input yes,
                        input yes)"
               &NOAPPERROR=TRUE &CATCHERROR=TRUE}

      if return-value = {&RECORD-NOT-FOUND} then do:

         clear frame vend.
         clear frame ship_to.
         clear frame b.
         /* MESSAGE #1 - ADDING NEW RECORD */
         {pxmsg.i
            &MSGNUM=1
            &ERRORLEVEL={&INFORMATION-RESULT}}
         {&POMT-P-TAG3}
         new_po = yes.

         {pxrun.i &PROC='createPurchaseOrder' &PROGRAM='popoxr.p'
                  &PARAM="(input ponbr,
                           buffer po_mstr)"
                  &NOAPPERROR=TRUE &CATCHERROR=TRUE}

         {pxrun.i &PROC='initializeBlanketPO' &PROGRAM='popoxr.p'
                  &PARAM="(input blanket,
                           buffer po_mstr)"
                  &NOAPPERROR=TRUE &CATCHERROR=TRUE}

         if recid(poc_ctrl) = -1 then.

         if c-application-mode = "API" then
            {gprun.i ""gpxrcrln.p""
                     "(input po_nbr,
                       input 0,
                       input ttPurchaseOrder.extRef,
                       input 0,
                       input 'po')"}

      end.  /* IF NOT AVAILABLE PO_MSTR */

      else do:
         if po_stat = "c" then do:
            /* MESSAGE #326 - PURCHASE ORDER CLOSED */
            {pxmsg.i
               &MSGNUM=326
               &ERRORLEVEL={&INFORMATION-RESULT}}
         end.
         if po_stat = "x" then do:
            /* MESSAGE #395 - PURCHASE ORDER CANCELLED */
            {pxmsg.i
               &MSGNUM=395
               &ERRORLEVEL={&INFORMATION-RESULT}}
         end.

         {pxrun.i &PROC='validatePODataBase' &PROGRAM='popoxr1.p'
                  &PARAM="(input po_nbr)"
                  &NOAPPERROR=true &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT} then do:
            if c-application-mode <> "API" then
               undo mainloop, retry mainloop.
            else /* if c-application-mode = "API"*/
               undo mainloop, return error.
         end.

         new_po = no.
         /* MESSAGE #10 - MODIFYING EXISTING RECORD */
         {pxmsg.i
             &MSGNUM=10
             &ERRORLEVEL={&INFORMATION-RESULT}}
         if c-application-mode <> "API" then
           /* DISPLAY VENDOR ADDRESS */
            {mfaddisp.i po_vend vend}

         {pxrun.i &PROC='validateBlanketPO'
                  &PROGRAM='popoxr.p'
                  &PARAM="(input po_type,
                           input blanket)"
                  &NOAPPERROR=true &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT} then do:
            if c-application-mode <> "API" then
               undo mainloop, retry mainloop.
            else /* if c-application-mode = "API"*/
               undo mainloop, return error.
         end.

         if c-application-mode <> "API" then
            {mfaddisp.i po_ship ship_to}

         disc = po_disc_pct.

         {pxrun.i &PROC='validateScheduledOrder' &PROGRAM='popoxr.p'
                  &PARAM="(input po_sched,
                           input {&WARNING-RESULT})"
                  &NOAPPERROR=true &CATCHERROR=true}

         {pxrun.i &PROC='getFirstPOLine' &PROGRAM='popoxr1.p'
                  &PARAM="(input po_nbr,
                           buffer pod_det)"
                  &NOAPPERROR=true &CATCHERROR=true}

         if available pod_det then
            so_job = pod_so_job.

         {pxrun.i &PROC='validateSiteSecurity' &PROGRAM='icsixr.p'
                  &PARAM="(input po_site,
                           input '')"
                  &NOAPPERROR=true &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT} then do:
            if c-application-mode <> "API" then
            do:
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
            end.  /* If c-application-mode <> "API" */
            else  /* If c-application-mode = "API" */
               undo mainloop, return error.
         end.
      end.


      if c-application-mode = "API" then
         assign {mfaiset.i po_app_owner ttPurchaseOrder.appOwner}.

      assign
         recno = recid(po_mstr).

      if po_cmtindx <> 0 then
         pocmmts = yes.

      if c-application-mode <> "API" then
      do:
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
  
  /* ss-081213.1 -b */
    for each pod_det no-lock where pod_nbr = po_nbr :
      if pod__chr08 <> "" then do :
        create tt2 .
        assign tt2_nbr = pod_nbr tt2_line = pod_line tt2_qty_ord = pod_qty_ord tt2__chr08 = pod__chr08 .
	end .

     end .
  /* ss-081213.1 -e */

      vendblk:
      do on error undo, retry:
         if retry and c-application-mode = "API" then
            return error.
         if c-application-mode <> "API" then
         do:
            prompt-for po_mstr.po_vend with frame a
            editing:

               /* FIND NEXT/PREVIOUS  RECORD */
               {mfnp.i vd_mstr po_vend vd_addr po_vend vd_addr vd_addr}

               if recno <> ? then
               do:
                  po_vend = vd_addr.
                  display
                     po_vend
                  with frame a.
                  for first ad_mstr where ad_addr = vd_addr  no-lock:
                  end.
                  {mfaddisp.i po_vend vend}
               end.
            end.
         end. /* if c-application-mode <>"API" */
         else
         do: /* if c-application-mode ="API" */
            assign vend = po_vend
                  {mfaiset.i vend ttPurchaseOrder.vend}.
            for first vd_mstr no-lock
                where vd_addr = vend:
            end.
            if not available vd_mstr then
            do:
               /* Not a valid supplier */
               {pxmsg.i &MSGNUM = 2 &ERRORLEVEL = 3}
               undo, return error.
            end.
         end.
         /* DO NOT ALLOW MOD TO VENDOR IF ANY RECEIPTS */
         if (not new_po and po_vend <> old_vend) or
            (not new_po and po_vend entered)
         then do:
            {pxrun.i &PROC='validateSupplierReceipts' &PROGRAM='popoxr.p'
                     &PARAM="(input old_vend,
                              input po_nbr)"
                     &NOAPPERROR=true &CATCHERROR=true}
            if return-value <> {&SUCCESS-RESULT} then do:
               if c-application-mode <> "API" then do:
                  display old_vend @ po_vend with frame a.
                  next-prompt po_vend.
                  clear frame vend.
                  undo, retry.
               end.  /* If c-application-mode <> "API" */
               else
                  undo vendblk, return error.
            end.
            else
               l_rebook_lines = yes.
         end.

         if c-application-mode <> "API" then
            /* DISPLAY VENDOR ADDRESS */
            {mfaddisp.i "input po_vend" vend}

         if not new_po and input po_vend <> old_vend
         then do:
            {pxrun.i &PROC='validateScheduledOrder' &PROGRAM='popoxr.p'
                     &PARAM="(input po_sched,
                              input {&APP-ERROR-RESULT})"
                     &NOAPPERROR=true &CATCHERROR=true}
            if return-value <> {&SUCCESS-RESULT} then do:
               if c-application-mode <> "API" then
               do:
                  clear frame vend.
                  display old_vend @ po_vend with frame a.
                  undo, retry.
               end.  /*if c-application-mode <> "API"*/
               else  /*if c-application-mode = "API"*/
                  undo, return error.
            end.
         end.

         /* SS - 110104.1 - B */
         if new_po then do:
            find first vd_mstr where vd_addr = input po_vend no-lock no-error.
            if not available vd_mstr then do:
               /* Not a valid supplier */
               {pxmsg.i &MSGNUM = 2 &ERRORLEVEL = 3}
               undo, retry.
            end.

            if vd__chr03 <> "AC" then do:
                message "错误:非AC状态的供应商,不允许新增订单,请重新输入" .
                undo,retry.
            end.
         end.
         /* SS - 110104.1 - E */


      end. /* vendblk */

      if c-application-mode <> "API" then
      do:
         {pxrun.i &PROC='validateSupplier' &PROGRAM='popoxr.p'
            &PARAM="(input po_vend:screen-value)"
            &NOAPPERROR=TRUE &CATCHERROR=TRUE}
      end.
      else /*if c-application-mode = "API"*/
      do:
         assign vend = po_vend
            {mfaiset.i vend ttPurchaseOrder.vend}.
         {pxrun.i
            &PROC='validateSupplier'
            &PROGRAM='popoxr.p'
            &PARAM="(input vend)"
            &NOAPPERROR=TRUE &CATCHERROR=TRUE}
      end.

      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then
         do:
            next-prompt po_vend with frame a.
            undo, retry.
         end.
         else    /*if c-application-mode = "API"*/
            undo, return error.
      end.

      if not available vd_mstr then do:
         /* USER ENTERED A SPECIFIC SUPPLIER NUMBER,         */
         /* WE NEED THE RECORD FOR THE RECID FUNCTION BELOW. */
         if c-application-mode <> "API" then do:
            {pxrun.i &PROC='processRead' &PROGRAM='adsuxr.p'
                  &PARAM="(input po_vend:screen-value,
                           buffer vd_mstr,
                           input no,
                           input yes)"
                  &NOAPPERROR=TRUE &CATCHERROR=TRUE}
         end.
         else    /*if c-application-mode = "API"*/
         do:
            {pxrun.i
                &PROC='processRead'
                &PROGRAM='adsuxr.p'
                &PARAM="(input vend,
                         buffer vd_mstr,
                         input no,
                         input yes)"
                &NOAPPERROR=TRUE
                &CATCHERROR=TRUE}
         end.
      end.

      if new_po then do:
         if c-application-mode <> "API" then do:
            {pxrun.i &PROC='setSupplierDefaults' &PROGRAM='popoxr.p'
                     &PARAM="(input input po_vend,
                              buffer po_mstr)"}
         end.
         else do:    /*if c-application-mode = "API"*/
            {pxrun.i
               &PROC='setSupplierDefaults'
               &PROGRAM='popoxr.p'
               &PARAM="(input vend,
                        buffer po_mstr)"}
         end.
         if po_cr_terms <> "" then do:
            {pxrun.i &PROC='getCreditTermsInterest' &PROGRAM='adcrxr.p'
                     &PARAM="(input po_cr_terms,
                              output po_crt_int)"}
         end.

         if c-application-mode <> "API" then do:
            {pxrun.i &PROC='getTaxData' &PROGRAM='adadxr.p'
                  &PARAM="(input input po_vend,
                           output po_taxable,
                           output po_taxc,
                           output tax_in,
                           output dummyCharValue,   /* Tax Type */
                           output po_tax_usage,
                        output dummyCharValue    /* Zone From */
                   )"}
         end.
         else do:    /*if c-application-mode = "API"*/
            {pxrun.i
                &PROC='getTaxData'
                &PROGRAM='adadxr.p'
                &PARAM="(input vend,
                         output po_taxable,
                         output po_taxc,
                         output tax_in,
                         output dummyCharValue,   /* Tax Type */
                         output po_tax_usage,
                         output dummyCharValue    /* Zone From */
                   )"}
         end.

         /* IF USING SUPPLIER CONSIGNMENT THEN INITIALIZE */
         /* CONSIGNMENT FIELDS.   */
         if using_supplier_consignment then do:
            {pxrun.i &PROC = 'initializeSuppConsignFields'
                     &PARAM="(input po_vend,
                              output po_consignment,
                              output po_max_aging_days)"}
            if return-value <> {&SUCCESS-RESULT}
               then do:
                  if return-value = "3388" then do:
                     {pxmsg.i &MSGNUM=return-value
                              &ERRORLEVEL=3
                              &MSGARG1=getTermLabel(""SUPPLIER_CONSIGNMENT"",30)}
                  end.
                  else do:
                     {pxmsg.i &MSGNUM=return-value &ERRORLEVEL=2}
                  end.
                  if c-application-mode <> "API"
                  then do:
                     next-prompt po_vend with frame a.
                     undo, retry.
                  end.
                  else    /*if c-application-mode = "API"*/
                     undo mainloop, return error.
            end. /* if return-value <> */
            if c-application-mode <> "API" then
               display po_consignment with frame b.
         end. /* IF using_supplier_consignment */
      end. /* If new_po */

      if (c-application-mode <>  "API")
      then do:
         if ((not new_po) and (old_vend <> input po_vend))
         then do:
            {pxrun.i &PROC='validateSupplierCurrency' &PROGRAM='popoxr.p'
                     &PARAM="(input po_curr,
                              input input po_vend)"
                     &NOAPPERROR=true &CATCHERROR=true}
            if return-value <> {&SUCCESS-RESULT} then do:
               next-prompt po_vend.
               undo, retry.
            end.
         end.
      end.
      else    /*if c-application-mode = "API"*/
      do:
         if ((not new_po) and
             (ttPurchaseOrder.vend <> ?) and
             (old_vend <> ttPurchaseOrder.vend))
         then do:

            {pxrun.i &PROC='validateSupplierCurrency' &PROGRAM='popoxr.p'
                     &PARAM="(input po_curr,
                              input ttPurchaseOrder.vend)"
                     &NOAPPERROR=TRUE &CATCHERROR=TRUE}

            if return-value <> {&SUCCESS-RESULT} then do:
               undo mainloop, return error.
            end.
         end.
      end.

      if c-application-mode <> "API" then
         assign
            po_vend = input po_vend.
      else
         assign {mfaiset.i po_vend ttPurchaseOrder.vend}.

      vd_recno = recid(vd_mstr).

      do on error undo, retry:
         if retry and c-application-mode = "API" then
            return error.
         if c-application-mode <> "API" then do:
            prompt-for po_mstr.po_ship with frame a
            editing:
               /* FIND NEXT/PREVIOUS  RECORD */
               {mfnp.i ad_mstr po_ship ad_addr po_ship ad_addr ad_addr}
               if recno <> ? then do:
                  po_ship = ad_addr.
                  display po_ship with frame a.
                  /* DISPLAY SHIP TO ADDRESS */
                  {mfaddisp.i po_ship ship_to}
               end.
            end.

            {pxrun.i &PROC='validateShipTo' &PROGRAM='popoxr.p'
                  &PARAM="(input input po_ship)"
                  &NOAPPERROR=TRUE &CATCHERROR=TRUE}
         end.
         else    /*if c-application-mode = "API"*/
         do:
            assign  {mfaiset.i po_ship ttPurchaseOrder.ship}.

            {pxrun.i &PROC='validateShipTo' &PROGRAM='popoxr.p'
                &PARAM="(input po_ship)"
                &NOAPPERROR=TRUE &CATCHERROR=TRUE}
         end.

         if return-value <> {&SUCCESS-RESULT} then do:
            if c-application-mode <> "API" then
               undo, retry.
            else    /*if c-application-mode = "API"*/
               undo mainloop, return error.
         end.

         if c-application-mode <> "API"
         then do:
            assign po_ship = input po_ship.
            {mfaddisp.i po_ship ship_to}
         end.   /* if c-application-mode <> "API" */
         else  /* if c-application-mode = "API" */
         do:
            for first ad_mstr where ad_addr = po_ship no-lock:
            end.
            if not available ad_mstr then
            do:
               /* Not a valid choice */
               {pxmsg.i &MSGNUM = 13 &ERRORLEVEL = 3}
            end.
         end.

      end.

      /* SET GLOBAL REFERENCE VARIABLE FOR COMMENTS TO VENDOR */
      assign
         global_ref = po_vend
         po_recno   = recid(po_mstr)
         continue   = no
         del-yn     = no.

      /* PURCHASE ORDER MAINTENANCE -- ORDER HEADER subroutine */
      {gprun.i ""xxpopom1b.p"" "(input using_supplier_consignment)"}	/*---Add by davild 20080624.1*/
      
      /* ss-081226.1 -b */
       for each tt2 : 
     find first pod_det where pod_nbr = tt2_nbr and pod_line = tt2_line and pod__chr08 = tt2__chr08 no-lock no-error .
     if not available pod_det then do :
        find first xxcer_mstr where  xxcer_Nbr = tt2__chr08 no-error.
	 if avail xxcer_mstr then do:
	   assign xxcer_ord_qty = xxcer_ord_qty - tt2_qty_ord .
	   end .
      end .  
   end .
    /* ss-081226.1 -e */

      if c-application-mode <> "API"
      then do:
          if del-yn then
            next mainloop.
         if continue = no then
            undo mainloop, retry.
      end.
      else
      do:
         if del-yn then
            return.
         if continue = no then
            undo mainloop, return error.
      end.

      if (oldcurr <> po_curr) or oldcurr = "" then
      do:
         /* SET CURRENCY DEPENDENT FORMATS */
         {pocurfmt.i}
         oldcurr = po_curr.
      end.

      {pxrun.i &PROC='getTaxDate' &PROGRAM='popoxr.p'
               &PARAM="(input po_tax_date,
                        input po_due_date,
                        input po_ord_date,
                        output tax_date)"
               &NOAPPERROR=true &CATCHERROR=true}

      if l_rebook_lines and
         not pBlanket
      then do:
         {gprun.i ""pomtrb.p"" "(input old_vend)"}.
         l_rebook_lines = no.
      end. /* IF L_REBOOK_LINES AND NOT BLANKET ORDER */

      /* FIND LAST LINE */
      line = 0.

      {pxrun.i &PROC='getLastPOLine' &PROGRAM='popoxr1.p'
               &PARAM="(input po_nbr,
                        output line)"
               &NOAPPERROR=true &CATCHERROR=true}

      po_recno = recid(po_mstr).

      /* IF BLANKET PO THEN BRING UP EXTRA SCREEN */
      if pBlanket then do:
         hide frame b no-pause.
         {gprun.i ""poblmt1.p""}
      end.

      /*V8!do: */
      hide frame a no-pause.
      hide frame vend no-pause.
      hide frame ship_to no-pause.
      hide frame b no-pause.
      /*V8!end. */

      /*COMMENTS */
      assign
         global_type = ""
         global_lang = po_lang.

      if pocmmts = yes then do on error undo mainloop, retry:
         if c-application-mode = "API" then
         do:
            {gpttcp.i ttPurchaseOrderCmt
                         ttTransComment
                         "ttPurchaseOrderCmt.apiExternalKey =
                          ttPurchaseOrder.apiExternalKey"}
             run setTransComment in ApiMethodHandle
                (input table ttTransComment).
         end.

         assign
            global_ref = po_vend
            cmtindx = po_cmtindx.

         {gprun.i ""gpcmmt01.p"" "(input ""po_mstr"")"}

         po_cmtindx = cmtindx.

      end.
   end.

   due_date = po_due_date.

   /* ss-081210.1 -b */
   v_update = no .
   /* ss-081210.1 -e */
  
   /* LINE ITEMS */
   {gprun.i ""xxpopom1a.p""}	/*---Add by davild 20080624.1*/

   /* TRAILER */
   hide all.
   if c-application-mode <> "API" then
   do:
      view frame dtitle.
      view frame a.
   end.   /*if c-application-mode <> "API"*/

   /* ss-090104.1 -b */
  /* {gprun.i ""popomtf.p""} */
  {gprun.i ""xxpopomtf.p""}
  /* ss-090104.1 -e */

   

   {&POMT-P-TAG1}
   /* IMPORT EXPORT UPDATE */
   if not batchrun and impexp then
   do:
      {pxrun.i &PROC='import-export-update'}
   end. /*IF NOT BATCHRUN AND IMPEXP */
   if not impexp_edit then do:     /* CLEAN UP FRAMES DISPLAYED */
      hide all no-pause.
      if c-application-mode <> "API" then
         view frame dtitle.
   end.

   {pxrun.i &PROC='copyPOToOtherDBs' &PROGRAM='popoxr.p'
            &PARAM="(input po_nbr,
                     input false /* NOT BLANKET PO MAINT */ )"
            &NOAPPERROR=true &CATCHERROR=true}

     /* ss-081210.1 -b */
   /* ss-090104.1 -b */
   /* empty temp-table tt .
   
   if v_update = yes then do :
      message "根据采购订单重新计算价格和折扣(Y/N)" view-as alert-box buttons yes-no update v_choice .
      if v_choice = yes then do :
       for each po_mstr where   po_nbr = ponbr no-lock :
           for each pod_det no-lock where  pod_nbr = po_nbr break by pod_part :
	     if index("xc",pod_status) = 0 then do :
	       v_qty = v_qty + pod_qty_ord .
	      end .
	      else do :
	       v_qty = v_qty + ( pod_qty_rcvd - pod_qty_rtnd ) .
	      end .
	    if last-of(pod_part) then do :

	 assign v_logical = yes    .

	    find first poc_ctrl where no-lock no-error .

             
		 {xxpopom1list.i}
	     
	     create tt .
	     assign tt_nbr = pod_nbr
	            tt_part = pod_part
		    tt_pur_cost = v_pur_cost
		    tt_disc_pct = v_disc_pct .

	    v_qty = 0 .
	    end . /* last-of */
	   
	   end . /* pod_det */
        end . /* po_mstr */
	   
	  for each tt no-lock :
	    for each pod_det where  pod_nbr = tt_nbr and pod_part = tt_part :
	     assign pod_pur_cost = tt_pur_cost pod_disc_pct = tt_disc_pct .
	     end .
	   end .  
        
      
     
      end . /* v_choice */
   end . /* v_update */  */
   /* ss-090104.1 -e */
/* ss - 090617.1 -b
   for each tt2 : 
     find first pod_det where pod_nbr = tt2_nbr and pod_line = tt2_line and pod__chr08 = tt2__chr08 no-lock no-error .
     if not available pod_det then do :
        find first xxcer_mstr where  xxcer_Nbr = tt2__chr08 no-error.
	 if avail xxcer_mstr then do:
	   assign xxcer_ord_qty = xxcer_ord_qty - tt2_qty_ord .
	  end .
      end .  
   end .
   ss - 090617.1 -e */  /* 在项次中删除时更新xxcer_ord_qty  xxpopom1h.p*/
    /* ss-081210.1 -b */

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
/*------------------------------------------------------------------------------
  Purpose:     Prompt for po_nbr.
  Notes:
  History:
------------------------------------------------------------------------------*/
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
            {mfnp05.i
               po_mstr
               po_nbr
               "po_type <> ""B"" and po_fsm_type = """""
               po_nbr
               "input po_nbr"}
         end.
         else do:
            {mfnp01.i po_mstr po_nbr po_nbr po_type ""B"" po_type}
         end.

         if recno <> ? then do:

            disc = po_disc_pct.

            /* DISPLAY VENDOR ADDRESS */
            {mfaddisp.i po_vend vend}
            /* DISPLAY SHIP TO ADDRESS */
            {mfaddisp.i po_ship ship_to}

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

   if c-application-mode <> "API" then
      for first po_mstr where po_nbr = input po_nbr no-lock:
      end.
   else /*if c-application-mode = "API" */
   do:
      for first po_mstr where po_nbr = ttPurchaseOrder.nbr:
      end.
   end.

   if available po_mstr
   then do:
      {pxrun.i &PROC='validateRTSOrder' &PROGRAM='popoxr.p'
               &PARAM="(input po_fsm_type)"
               &NOAPPERROR=true &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt po_nbr with frame a.
            undo, retry.
         end.   /*if c-application-mode <> "API"*/
         else /*if c-application-mode = "API" */
            undo, return error.
      end.
	/*---Add Begin by davild 20080709.1*/
	find first rqf_ctrl no-lock no-error.
	if avail rqf_ctrl then do:
		if po_confirm = yes and rqf__chr04 = "y" then do:
			message "此PO已被审核,不能进行操作." view-as alert-box .
			next-prompt po_nbr with frame a.
			undo, retry.
		end.
	end.
	/*---Add End   by davild 20080709.1*/

      {pxrun.i &PROC='validateEMTOrder' &PROGRAM='popoxr.p'
               &PARAM="(input po_is_btb)"
               &NOAPPERROR=true &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt po_nbr with frame a.
            undo, retry.
         end.   /*if c-application-mode <> "API"*/
         else /*if c-application-mode = "API" */
            undo, return error.
      end.
   end.

   if (c-application-mode <> "API" and input po_nbr <> "") then
      {&POMT-P-TAG4}
      ponbr = input po_nbr.
      {&POMT-P-TAG5}
   else
   do:
      if (c-application-mode = "API" and ttPurchaseOrder.nbr <> "")
      then
         ponbr = ttPurchaseOrder.nbr.
   end.

   do transaction on error undo,retry:
      if c-application-mode = "API" and retry then
         return error.
      if (c-application-mode <> "API" and input po_nbr = "") or
         (c-application-mode = "API" and
         (ttPurchaseOrder.nbr = "" or ttPurchaseOrder.nbr = ?))
      then do:

         {&POMT-P-TAG6}
         {pxrun.i
            &PROC='getNextPONumber'
            &PROGRAM='popoxr.p'
            &PARAM="(output ponbr)"
            &NOAPPERROR=TRUE
            &CATCHERROR=TRUE}

      end.
   end. /* DO TRANSACTION ON ERROR UNDO.. */

   {gpbrparm.i &browse=dtlu001.p &parm=c-brparm1 &val=poNbr}
END PROCEDURE.

PROCEDURE import-export-update:
/*------------------------------------------------------------------------------
  Purpose:
  Notes:
  History:
------------------------------------------------------------------------------*/
   assign
      impexp_edit = no
      upd_okay = no.
   /* MESSAGE #271 - VIEW/EDIT IMPORT/EXPORT DATA ? */
   {pxmsg.i
      &MSGNUM=271
      &ERRORLEVEL={&INFORMATION-RESULT}
      &CONFIRM=impexp_edit}
   /* VIEW EDIT IMPORT EXPORT DATA ? */
   if impexp_edit
   then do:
      hide all.
      if c-application-mode <> "API" then do:
         view frame dtitle.
         view frame a.
      end. /*if c-application-mode <> "API"*/

   {gprun.i ""iedmta.p""
      "(input ""2"",
        input po_mstr.po_nbr,
        input-output upd_okay )" }
   end.

END PROCEDURE.

PROCEDURE initialize-variables:
/*------------------------------------------------------------------------------
  Purpose:
  Notes:
  History:
------------------------------------------------------------------------------*/
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
      for first mfc_ctrl where mfc_field = "poc_pc_line"
      no-lock:
      end.
      if available mfc_ctrl then
         poc_pc_line = mfc_logical.
   end.

END PROCEDURE.
