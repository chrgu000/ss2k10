/* GUI CONVERTED from rsporc.p (converter v1.77) Mon Dec 29 05:07:43 2003 */
/* rsporc.p - Release Management Supplier Schedules - Shipper Confirm         */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.93.1.6 $                                                      */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3      LAST MODIFIED: 10/12/92   BY: WUG *G462*                */
/* REVISION: 7.3      LAST MODIFIED: 01/18/93   BY: WUG *G563*                */
/* REVISION: 7.3      LAST MODIFIED: 06/03/93   BY: WUG *GB29*                */
/* REVISION: 7.3      LAST MODIFIED: 06/17/93   BY: WUG *GC41*                */
/* REVISION: 7.3      LAST MODIFIED: 07/26/93   BY: WUG *GD68*                */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*                */
/* REVISION: 7.4      LAST MODIFIED: 10/22/93   BY: WUG *H189*                */
/* REVISION: 7.4      LAST MODIFIED: 12/15/93   BY: dpm *H074*                */
/* REVISION: 7.4      LAST MODIFIED: 04/15/93   BY: dpm *H351*                */
/* REVISION: 7.4      LAST MODIFIED: 06/14/94   BY: afs *FO47*                */
/* REVISION: 7.4      LAST MODIFIED: 07/15/94   BY: WUG *GK73*                */
/* REVISION: 7.4      LAST MODIFIED: 09/15/94   by: slm *GM62*                */
/* REVISION: 7.4      LAST MODIFIED: 11/01/94   BY: ame *GN88*                */
/* REVISION: 7.4      LAST MODIFIED: 11/09/94   BY: WUG *GN76*                */
/* REVISION: 7.4      LAST MODIFIED: 11/17/94   BY: bcm *GO37*                */
/* REVISION: 7.4      LAST MODIFIED: 12/05/94   BY: bcm *H606*                */
/* REVISION: 7.4      LAST MODIFIED: 02/14/95   BY: WUG *G0F7*                */
/* REVISION: 7.4      LAST MODIFIED: 02/28/95   BY: dxk *F0KT*                */
/* REVISION: 8.5      LAST MODIFIED: 03/02/95   by: taf *J038*                */
/* REVISION: 8.5      LAST MODIFIED: 03/02/95   by: taf *J040*                */
/* REVISION: 7.4      LAST MODIFIED: 03/10/95   BY: bcm *G0H3*                */
/* REVISION: 7.4      LAST MODIFIED: 03/16/95   BY: bcm *G0HK*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 7.4      LAST MODIFIED: 03/31/95   BY: bcm *G0JN*                */
/* REVISION: 7.4      LAST MODIFIED: 04/06/95   BY: ame *H0CF*                */
/* REVISION: 7.4      LAST MODIFIED: 05/09/95   BY: dxk *G0MC*                */
/* REVISION: 7.4      LAST MODIFIED: 05/18/95   BY: vrn *H0DP*                */
/* REVISION: 8.5      LAST MODIFIED: 06/16/95   BY: rmh *J04R*                */
/* REVISION: 7.4      LAST MODIFIED: 09/12/95   BY: vrn *G0X3*                */
/* REVISION: 7.4      LAST MODIFIED: 10/06/95   BY: vrn *G0XW*                */
/* REVISION: 7.4      LAST MODIFIED: 12/14/95   BY: kjm *G1G8*                */
/* REVISION: 8.5      LAST MODIFIED: 01/17/95   BY: taf *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 02/07/96   BY: *J0CV* Robert Wachowicz   */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: rxm *H0KH*                */
/* REVISION: 8.5      LAST MODIFIED: 04/12/96   BY: rxm *G1RY*                */
/* REVISION: 8.5      LAST MODIFIED: 03/08/96   BY: vrn *G1NV*                */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: ejh *K001*                */
/* REVISION: 8.5      LAST MODIFIED: 07/16/96   BY: rxm *G1SV*                */
/* REVISION: 8.5      LAST MODIFIED: 07/19/96   BY: taf *J0ZS*                */
/* REVISION: 8.6      LAST MODIFIED: 09/17/96   BY: *G1QH* Aruna P.Patil      */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Kurt De Wit        */
/* REVISION: 8.6      LAST MODIFIED: 10/30/96   BY: *K003* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 12/06/96   BY: *K030* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 12/19/96   BY: *K022* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 02/24/97   BY: *K06C* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 02/25/97   BY: *G2L4* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 03/17/97   BY: *K080* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 04/02/97   BY: *K09H* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 04/07/97   BY: *K06J* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 04/15/96   BY: *K08N* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 06/23/97   BY: *H19V* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 07/17/97   BY: *K0DH* Taek-Soo Chang     */
/* REVISION: 8.6      LAST MODIFIED: 07/23/97   BY: *H1CB* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 07/29/97   BY: *H1CG* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 09/18/97   BY: *J211* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 12/02/97   BY: *J274* Seema Varma        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 03/18/98   BY: *J2G9* Sachin Shah        */
/* REVISION: 8.6E     LAST MODIFIED: 03/26/98   BY: *H1K3* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: *J2DD* Kawal Batra        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/26/98   BY: *J2MG* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 07/08/98   BY: *L020* Charles Yen        */
/* REVISION: 8.6E     LAST MODIFIED: 08/17/98   BY: *L062* Steve Nugent       */
/* REVISION: 8.6E     LAST MODIFIED: 09/02/98   BY: *H1N0* Seema Varma        */
/* REVISION: 8.6E     LAST MODIFIED: 11/12/98   BY: *J30M* Seema Varma        */
/* REVISION: 9.0      LAST MODIFIED: 03/29/99   BY: *J3BM* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 06/02/99   BY: *J3GM* Kedar Deherkar     */
/* REVISION: 9.0      LAST MODIFIED: 07/28/99   BY: *J3JZ* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 08/12/99   BY: *J3KJ* Bengt Johansson    */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney     */
/* REVISION: 9.1      LAST MODIFIED: 09/03/99   BY: *J3L4* Kedar Deherkar     */
/* REVISION: 9.1      LAST MODIFIED: 09/21/99   BY: *J3LL* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Bill Gates         */
/* REVISION: 9.1      LAST MODIFIED: 01/11/00   BY: *J3N7* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* David Morris       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 08/24/00   BY: *K26B* Gurudev C          */
/* REVISION: 9.1      LAST MODIFIED: 09/11/00   BY: *N0RT* BalbeerS Rajput    */
/* REVISION: 9.1      LAST MODIFIED: 11/07/00   BY: *L15J* Nikita Joshi       */
/* REVISION: 9.1      LAST MODIFIED: 12/20/00   BY: *L16V* Ravikumar K        */
/* REVISION: 9.1      LAST MODIFIED: 01/09/01   BY: *L170* Ashwini Ghaisas    */
/* REVISION: 9.1      LAST MODIFIED: 01/12/01   BY: *N0VL* Manish Kulkarni    */
/* REVISION: 9.1      LAST MODIFIED: 02/27/01   BY: *M12J* Ashwini Ghaisas    */
/* Revision: 1.70      BY: Niranjan Ranka         DATE: 05/11/01  ECO: *P00L* */
/* Revision: 1.71      BY: Jean Miller            DATE: 08/07/01  ECO: *M11Z* */
/* Revision: 1.72      BY: Hareesh V              DATE: 09/20/01  ECO: *M1GV* */
/* Revision: 1.73      BY: Veena Lad              DATE: 11/08/01  ECO: *M1PN* */
/* Revision: 1.74      BY: Mercy Chittilapilly    DATE: 11/19/01  ECO: *M1Q6* */
/* Revision: 1.75      BY: Robin McCarthy         DATE: 04/05/02  ECO: *P000* */
/* Revision: 1.76      BY: John Pison             DATE: 05/06/02  ECO: *N1HN* */
/* Revision: 1.77      BY: Jeff Wootton           DATE: 05/23/02  ECO: *P075* */
/* Revision: 1.78      BY: Ellen Borden           DATE: 05/24/02  ECO: *P018* */
/* Revision: 1.79      BY: Steve Nugent           DATE: 06/13/02  ECO: *P08K* */
/* Revision: 1.80      BY: Luke Pokic             DATE: 06/19/02  ECO: *P099* */
/* Revision: 1.83      BY: Tiziana Giustozzi      DATE: 06/20/02  ECO: *P093* */
/* Revision: 1.84      BY: Robin McCarthy         DATE: 07/15/02  ECO: *P0BJ* */
/* Revision: 1.85      BY: Tiziana Giustozzi      DATE: 07/24/02  ECO: *P09N* */
/* Revision: 1.86      BY: Vivek Gogte            DATE: 08/06/02  ECO: *N1QQ* */
/* Revision: 1.87      BY: Karan Motwani          DATE: 10/28/02  ECO: *N1Y7* */
/* Revision: 1.88      BY: Mamata Samant          DATE: 12/19/02  ECO: *N22K* */
/* Revision: 1.89      BY: Deepali Kotavadekar    DATE: 01/24/03  ECO: *N23Y* */
/* Revision: 1.92      BY: Katie Hilbert          DATE: 03/07/03  ECO: *N293* */
/* Revision: 1.93      BY: Dorota Hohol           DATE: 03/11/03  ECO: *P0N6* */
/* Revision: 1.93.1.1  BY: Gnanasekar             DATE: 07/22/03  ECO: *P0XW* */
/* Revision: 1.93.1.2  BY: Deepak Rao             DATE: 08/14/03  ECO: *N2K3* */
/* Revision: 1.93.1.3  BY: Deepak Rao             DATE: 09/04/03  ECO: *N2KM* */
/* Revision: 1.93.1.5  BY: Anitha Gopal           DATE: 10/10/03  ECO: *N2LR* */
/* $Revision: 1.93.1.6 $  BY: Pankaj Goswami  DATE: 12/24/03   ECO: *P1FV* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "2+ "}
{cxcustom.i "RSPORC.P"}
{gldydef.i new}
{gldynrm.i new}
{yyedcomlib.i}
IF f-howareyou("HAHA") = NO THEN LEAVE.

{porcdef.i "new" "new"}

/* LOGISTICS CHARGE - PENDING VOUCHER MASTER TEMP TABLE DEFINITION */
define new shared temp-table tt-pvocharge no-undo
   field tt-lc_charge           like lc_charge
   field tt-pvo_id              as   integer
   index tt-index
   tt-lc_charge
   tt-pvo_id.

/* Define Shared Variables */
define new shared variable qty_left      like tr_qty_chg.
define new shared variable rndmthd       like rnd_rnd_mthd.
define new shared variable trqty         like tr_qty_chg.
define new shared variable qty_req       like in_qty_req.
define new shared variable loc           like pt_loc.
define new shared variable lot_ser       like pt_lot_ser.
define new shared variable i             as integer.
define new shared variable qty           as decimal.
define new shared variable part          as character format "x(18)".
define new shared variable sod_recno     as recid.
define new shared variable fas_so_rec    as character.
define new shared variable ship_db       like global_db.
define new shared variable change_db     like mfc_logical.
define new shared variable ship_so       like so_nbr.
define new shared variable ship_line     like sod_line.
define new shared variable qty_ord       like sod_qty_ord.
define new shared variable qty_inv       like sod_qty_inv.
define new shared variable qty_chg       like sod_qty_chg.
define new shared variable trgl_recno    as recid.
define new shared variable sct_recno     as recid.
define new shared variable accum_wip     like tr_gl_amt.
define new shared variable nbr           like tr_nbr.
define new shared variable cr_acct       like trgl_cr_acct.
define new shared variable cr_sub        like trgl_cr_sub.
define new shared variable cr_cc         like trgl_cr_cc.
define new shared variable cr_proj       like trgl_cr_proj.
define new shared variable qty_iss_rcv   like tr_qty_loc.
define new shared variable sct_recid     as recid.
define new shared variable tr_recno      as recid.
define new shared variable issrct        as character format "x(3)".
define new shared variable conv          like um_conv label "Conversion" no-undo.
define new shared variable unit_cost     like tr_price label "Unit Cost".
define new shared variable ordernbr      like tr_nbr.
define new shared variable orderline     like tr_line.
define new shared variable so_job        like tr_so_job.
define new shared variable addr          like tr_addr.
define new shared variable rmks          like tr_rmks.
define new shared variable dr_acct       like trgl_dr_acct.
define new shared variable dr_sub        like trgl_dr_sub.
define new shared variable dr_cc         like trgl_dr_cc.
define new shared variable project       like wo_project.
define new shared variable lotserial_qty like sr_qty no-undo.
define new shared variable gl_sum        like mfc_logical initial yes
                                         format "Consolidated/Detail".
define new shared variable undo_all      like mfc_logical initial no.
define new shared variable batch         like ar_batch.
define new shared variable inv           like ar_nbr label "Invoice".
define new shared variable name          like ad_name.
define new shared variable desc1         like pt_desc1 format "x(49)".
define new shared variable yn            like mfc_logical.
define new shared variable post          like mfc_logical.
define new shared variable curr_amt      like glt_amt.
define new shared variable cust          like so_cust.
define new shared variable receivernbr   like prh_receiver.
define new shared variable maint         like mfc_logical no-undo initial true.
define new shared variable undo_trl2     like mfc_logical no-undo.
define new shared variable vendlot       like tr_vend_lot no-undo.
define new shared variable fiscal_rec    as logical initial false.
define new shared variable fiscal_id     like prh_receiver.

define new shared variable ship_dt       like so_ship_date.
define new shared variable um            like pt_um no-undo.

define new shared variable confirm_mode  like mfc_logical no-undo.
define new shared variable qopen         like pod_qty_rcvd.
define new shared variable receipt_date  like prh_rcp_date no-undo.
define new shared variable l_recalc      like mfc_logical no-undo initial yes.

/* DEFINE SHARED VARIABLE PRM-AVAIL SINCE IT IS REQUIRED */
/* BY THE SUBROUTINE POPORCB6.P                          */
define new shared variable prm-avail     like mfc_logical initial no no-undo.
/* KANBAN TRANSACTION NUMBER NEEDED FOR POPORCB8.P */
define new shared variable kbtransnbr    as integer no-undo.

define new shared variable h_wiplottrace_procs as handle no-undo.
define new shared variable h_wiplottrace_funcs as handle no-undo.

define shared variable global_recid as recid.

/* Define Local Variables */
define variable ship_date         like prh_ship_date no-undo.
define variable oldcurr           like po_curr.
define variable disp_abs_id       like abs_id.
define variable abs_recid         as recid.
define variable so_auto_count     as integer.
define variable so_not_auto_count as integer.
define variable newprice          as decimal.
define variable qty_to_rcv        as decimal.
define variable work_qty          like sr_qty.
define variable any_subcontract   as logical.
define variable total_received    like pod_qty_rcvd no-undo.
define variable dummy_disc        like pod_disc_pct no-undo.
define variable pc_recno          as recid no-undo.

define variable undo_tran         like mfc_logical no-undo.
define variable doc-type          as character.
define variable doc-ref           as character.
define variable add-ref           as character.
define variable msg-type          as character.
define variable trq-id            like trq_id.
define variable l_list_price      as decimal no-undo.
define variable l_flag            like mfc_logical  no-undo.
define variable undo-loop         as logical no-undo.
define variable mc-error-number   like msg_nbr no-undo.
define variable shipnbr           like tr_ship_id no-undo.
define variable inv_mov           like tr_ship_inv_mov no-undo.

define variable undo_loop1        like mfc_logical no-undo.
define variable l_tot_qty         like pod_qty_rcvd no-undo.
define variable l_recalc_lbl      like mfc_char    no-undo format "x(20)".
define variable l_cal             like mfc_logical no-undo.
define variable l_undotr          like mfc_logical no-undo.
define variable auto_receipt      like mfc_logical initial false no-undo.
define variable op_rctpo_trnbr    like tr_trnbr no-undo.

define variable tempstr           as character no-undo.
define variable price_qty         as decimal.
define variable use-log-acctg     as logical no-undo.

define variable dftCOPAcct        like pl_pur_acct  no-undo.
define variable dftCOPSubAcct     like pl_pur_sub   no-undo.
define variable dftCOPCostCenter  like pl_pur_cc    no-undo.
define variable dftFLRAcct        like pl_flr_acct  no-undo.
define variable dftFLRSubAcct     like pl_flr_sub   no-undo.
define variable dftFLRCostCenter  like pl_flr_cc    no-undo.

/* Workfiles */
define new shared workfile tax_wkfl
   field tax_nbr               like pod_nbr
   field tax_line              like pod_line
   field tax_env               like pod_tax_env
   field tax_usage             like pod_tax_usage
   field tax_taxc              like pod_taxc
   field tax_in                like pod_tax_in
   field tax_taxable           like pod_taxable
   field tax_price             like prh_pur_cost.

{gpglefdf.i}

/* WORKFILE FOR POD RECEIPT ATTRIBUTES */
define new shared workfile attr_wkfl no-undo
   field chg_line   like sr_lineid
   field chg_assay  like tr_assay
   field chg_grade  like tr_grade
   field chg_expire like tr_expire
   field chg_status like tr_status
   field assay_actv as logical
   field grade_actv as logical
   field expire_actv  as logical
   field status_actv  as logical.

/* Define Buffers */
define buffer pod2 for pod_det.
define buffer pod3 for pod_det.

/* WIP Lot Trace functions and constants */
{wlfnc.i} /*FUNCTION FORWARD DECLARATIONS*/
{wlcon.i} /*CONSTANTS DEFINITIONS*/

/* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}
/*GUI*/ if global-beam-me-up then undo, leave.


if is_wiplottrace_enabled() then do:
   {gprunmo.i &module="AWT" &program=""wlpl.p""
      &persistent="""persistent set h_wiplottrace_procs"""}
   {gprunmo.i &module="AWT" &program=""wlfl.p""
      &persistent="""persistent set h_wiplottrace_funcs"""}
end.

assign
   l_recalc_lbl = getTermLabelRtColon("RECALCULATE_FREIGHT",20).

{rcwabsdf.i new}

{gprun.i ""socrshc.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


for first poc_ctrl
   fields (poc_rcv_nbr poc_rcv_pre poc_tol_cst poc_tol_pct)
no-lock: end.

for first shc_ctrl
   fields (shc_ship_rcpt)
no-lock: end.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
abs_mstr.abs_shipfrom colon 28 label "Supplier"
   ad_name               at 45    no-label
   abs_mstr.abs_id       colon 28 label "Shipper ID"
   ad_line1              at 45    no-label
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
eff_date             colon 28
 SKIP(.4)  /*GUI*/
with frame bb side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-bb-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame bb = F-bb-title.
 RECT-FRAME-LABEL:HIDDEN in frame bb = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame bb =
  FRAME bb:HEIGHT-PIXELS - RECT-FRAME:Y in frame bb - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME bb = FRAME bb:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame bb:handle).

/* POPUP TO PROMPT FOR FREIGHT RECALCULATION */
FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
space(1)
   l_recalc_lbl format "x(20)"
   l_recalc
 SKIP(.4)  /*GUI*/
with frame rr overlay no-labels attr-space centered row 11  NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-rr-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame rr = F-rr-title.
 RECT-FRAME-LABEL:HIDDEN in frame rr = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame rr =
  FRAME rr:HEIGHT-PIXELS - RECT-FRAME:Y in frame rr - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME rr = FRAME rr:WIDTH-CHARS - .5.  /*GUI*/


for first abs_mstr
fields (abs_cum_qty abs_id abs_line abs_loc abs_lotser abs_order
        abs_qty abs_ref abs_shipfrom abs_shipto abs_ship_qty
        abs_shp_date abs_site abs_status abs_type abs__qad06
        abs__qad02)
where recid(abs_mstr) = global_recid
no-lock: end.

if available abs_mstr and abs_id begins "S" and abs_type = "R"
then do:

   for first ad_mstr
      fields (ad_addr ad_edi_ctrl ad_line1 ad_name)
   where ad_addr = abs_shipfrom
   no-lock: end.

   display
      abs_shipfrom
      substring(abs_id,2,50) @ abs_id
      ad_name
      ad_line1
   with frame a.

   eff_date = today.
   display
      eff_date
   with frame bb.

end.

/* SET THE FLAG SO POPORCB.P WILL NOT CHG THE STATUS OF POD_DET IF */
/* THE LINE IS NOT RECEIVED */
shipper_rec = true.

mainloop:
repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


   run del_sr_wkfl.

   do transaction with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


      /* EMPTY LOGISTICS ACCOUNTING TEMP TABLE */
      for each tt-pvocharge exclusive-lock:
         delete tt-pvocharge.
      end.

      prompt-for abs_shipfrom abs_id
      editing:

         if frame-field = "abs_shipfrom" then do:

            {mfnp05.i abs_mstr abs_id
               "abs_id begins ""s"" and abs_type = ""r"""
               abs_shipfrom
               "input abs_shipfrom"}

            if recno <> ? then do:

               for first ad_mstr
                  fields (ad_addr ad_edi_ctrl ad_line1 ad_name)
               where ad_addr = abs_shipfrom
               no-lock: end.

               assign
                  disp_abs_id = substring(abs_id,2,50).

               display
                  abs_shipfrom
                  disp_abs_id     @ abs_id
                  ad_name         when(available ad_mstr)
                  ""              when(not available ad_mstr) @ ad_name
                  ad_line1        when(available ad_mstr)
                  ""              when(not available ad_mstr) @ ad_line1.

            end.

         end. /* if frame-field = abs_shipfrom */

         else if frame-field = "abs_id" then do:

            global_addr = input abs_shipfrom.

            {mfnp05.i abs_mstr abs_id
               "abs_shipfrom = input abs_shipfrom and
                               abs_id begins ""S"" and abs_type = ""R"""
                               abs_id """S"" + input abs_id"}

            if recno <> ? then do:

               for first ad_mstr
                  fields (ad_addr ad_edi_ctrl ad_line1 ad_name)
               where ad_addr = abs_shipfrom
               no-lock: end.

               assign
                  disp_abs_id = substring(abs_id,2,50).

               display
                  abs_shipfrom
                  disp_abs_id     @ abs_id
                  ad_name         when(available ad_mstr)
                  ""              when(not available ad_mstr) @ ad_name
                  ad_line1        when(available ad_mstr)
                  ""              when(not available ad_mstr) @ ad_line1.

            end.

         end. /* if frame-field = abs_id */

         else do:
            status input.
            readkey.
            apply lastkey.
         end.

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* prompt-for */

      for first vd_mstr
         fields (vd_addr vd_type)
      where vd_addr = input abs_shipfrom
      no-lock: end.

      if not available vd_mstr then do:
         /* Not a valid Supplier */
         {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}
         next-prompt abs_shipfrom.
         undo, retry.
      end.

      for first ad_mstr
         fields (ad_addr ad_edi_ctrl ad_line1 ad_name)
      where ad_addr = input abs_shipfrom
      no-lock: end. /* FOR FIRST AD_MSTR */

      display
         ad_name
         ad_line1.

      if input abs_id = "" then do:
         /* Shipper ID Required */
         {pxmsg.i &MSGNUM=8188 &ERRORLEVEL=3}
         undo, retry.
      end.

   end.

   for first abs_mstr
   fields (abs_cum_qty abs_id abs_line abs_loc abs_lotser abs_order
           abs_qty abs_ref abs_shipfrom abs_shipto abs_ship_qty
           abs_shp_date abs_site abs_status abs_type abs__qad06
           abs__qad02)
    where abs_shipfrom = input abs_shipfrom
      and abs_id       = "S" + input abs_id
      and abs_type     = "R"
   no-lock: end.

   if not available abs_mstr then do:
      /* Shipper ID does not exist */
      {pxmsg.i &MSGNUM=8189 &ERRORLEVEL=3}
      undo, retry.
   end.

   if substring(abs_status,2,1) = "y" then do:
      /* Shipper previously confirmed */
      {pxmsg.i &MSGNUM=8146 &ERRORLEVEL=3}
      undo mainloop, retry.
   end.

   /*james*/
   if substring(abs_status,11,1) <> "y" then do:
       MESSAGE "Error: approval is required.".
       undo mainloop, retry.
   END.


   /* SET THE FISCAL ID FOR TAX ROUTINES */
   assign
      fiscal_id = string(abs_shipfrom, "x(8)") + substring(abs_id,2,50)
      abs_recid = recid(abs_mstr)
      ps_nbr    = substring(abs_id,2,50)
      eff_date  = today.

   update
      eff_date
   with frame bb.

   assign
      ship_date = if abs_mstr.abs_shp_date <> ? then
                     abs_mstr.abs_shp_date
                  else
                     eff_date
      ship_dt   = if abs_mstr.abs_shp_date <> ? then
                     abs_mstr.abs_shp_date
                  else
                     eff_date.

   /* VERIFY OPEN GL PERIOD FOR LINE ITEM SITE/ENTITY, */
   /* NOT PRIMARY ENTITY, AGAINST THE "IC" MODULE      */
   run assign-shipdb
      (input abs_shipto).

   if ship_db <> global_db then do:
      /* You must be in database */
      {pxmsg.i &MSGNUM=8191 &ERRORLEVEL=3}
      undo, retry.
   end.

   /* Make sure ship-from database is connected */
   if global_db <> "" and not connected(ship_db) then do:
      /* Database not available */
      {pxmsg.i &MSGNUM=2510 &ERRORLEVEL=3 &MSGARG1=ship_db}
      undo, retry.
   end.

   /* Pop-up to collect shipment information */
   if shc_ship_rcpt then do:
      {gprun.i ""icshup.p""
         "(input-output shipnbr,
           input-output ship_date,
           input-output inv_mov,
           input 'RCT-PO',
           input no,
           input 10,
           input 20)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end. /* if shc_ship_rcpt */

   run check_supperf
      (input abs_recid).

   for each work_abs_mstr exclusive-lock:
      delete work_abs_mstr.
   end.

   /* EXPLODE SHIPPER TO GET ORDER DETAIL */
   {gprun.i ""rcsoisa.p"" "(input recid(abs_mstr))"}
/*GUI*/ if global-beam-me-up then undo, leave.


   run recalc_freight
      (output l_cal).

   if l_cal = yes then do:
      display
         l_recalc_lbl
      with frame rr.
      update
         l_recalc
      with frame  rr.
      hide frame rr.
   end. /* IF l_cal THEN */

   /* THE PROCEDURE P_GLCALVAL, VERIFIES OPEN GL PERIOD FOR */
   /* SITE/ENTITY OF EACH LINE ITEM                         */
   run p_glcalval
      (output l_flag).
   if l_flag then do:
      next-prompt abs_mstr.abs_shipfrom with frame a.
      undo mainloop, retry mainloop.
   end. /* IF L_FLAG */

   /* GO THRU WORKFILE FOR VALIDATION OF ORDERS AND SET CURRENT
    * PURCHASE PRICE */
   assign
      so_not_auto_count = 0
      so_auto_count     = 0
      any_subcontract   = no.

   for each work_abs_mstr no-lock,
       each pod_det exclusive-lock
      where pod_part = work_abs_mstr.abs_item
        and pod_nbr  = abs_order
        and pod_line = integer(abs_line),
       each po_mstr
       fields (po_curr po_ex_rate po_ex_rate2 po_fix_rate
               po_nbr po_so_nbr po_vend po_tot_terms_code) no-lock
      where po_nbr = pod_nbr
   break by pod_nbr by pod_line
   on endkey undo mainloop, retry mainloop
   on error  undo mainloop, retry mainloop:
/*GUI*/ if global-beam-me-up then undo, leave.


      if pod_type = "S" then
         any_subcontract = yes.

      {gprun.i ""poporca5.p""
         "(input pod_nbr, input pod_line, input eff_date)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      if first-of(pod_nbr) then do:

         for each pod2 where
                  pod2.pod_nbr = pod_det.pod_nbr
              and pod2.pod_qty_chg <> 0
         no-lock:
            find pod3 where recid(pod3) = recid(pod2) exclusive-lock.
            assign
               pod3.pod_qty_chg = 0.
         end.

         if po_fix_rate = no then do:
            /* GET EXCHANGE RATE */
            {gprunp.i "mcpl" "p" "mc-get-ex-rate"
               "(input po_curr,
                 input base_curr,
                 input exch_ratetype,
                 input eff_date,
                 output exch_rate,
                 output exch_rate2,
                 output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               undo mainloop, retry mainloop.
            end.
         end.

         else
         assign
            exch_rate = po_ex_rate
            exch_rate2 = po_ex_rate2.

      end. /* if first-of(pod_nbr) */

      /* TOLERANCE CHECKING */
      qty_to_rcv = abs_qty - abs_ship_qty.
      accumulate qty_to_rcv(sub-total by pod_line).

      if last-of(pod_line) then do:

         assign
            total_received =
               ((accum sub-total by pod_line qty_to_rcv)
                   / pod_um_conv) + pod_qty_rcvd
            base_amt = pod_pur_cost.

         if po_curr <> base_curr then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input po_curr,
                 input base_curr,
                 input exch_rate,
                 input exch_rate2,
                 input base_amt,
                 input false, /* DO NOT ROUND */
                 output base_amt,
                 output mc-error-number)"}
         end.

         if pod_sched or
            (not pod_sched and
               (total_received > pod_qty_ord and pod_qty_ord >= 0) or
               (total_received < pod_qty_ord and pod_qty_ord < 0))
         then do:
            {gprun.i ""rsporct.p""
               "(input (accum sub-total by pod_line qty_to_rcv),
                 input recid(po_mstr),
                 input recid(pod_det),
                 input eff_date,
                 input poc_tol_pct,
                 input poc_tol_cst,
                 input base_amt,
                 input no,
                 input yes,
                 output undo_loop1)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            if undo_loop1 then undo mainloop, retry mainloop.
         end.

         /* WARN THE USER IF NO ACTIVE SCHEDULE EXISTS */
         run p-chk-act-schd
            (input pod_sched,
             input pod_curr_rlse_id[1]).

         {gprun.i ""rsplqty.p""
            "(input  recid(pod_det),
              input  ((accum sub-total by pod_line qty_to_rcv) / pod_um_conv),
              output price_qty)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         {gprun.i ""gpsct05.p""
                  "(input  pod_part,
                    input  pod_site,
                    input  2,
                    output glxcst,
                    output curcst)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         assign
            glxcst   = glxcst * pod_um_conv.
            newprice = 0.

         if po_curr <> base_curr
         then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
                      "(input   base_curr,
                        input   po_curr,
                        input   exch_rate2,
                        input   exch_rate,
                        input   glxcst,
                        input   true,
                        output  glxcst,
                        output  mc-error-number)"}
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end. /* mc-error-number <> 0 */
         end. /* IF po_curr <> base_curr */

         if use-log-acctg and po_tot_terms_code <> "" then
            glxcst = pod_pur_cost.

         assign
            l_list_price = glxcst
            dummy_disc   = 0.

         /* UPDATING PURCHASE COST ONLY FOR SCHEDULE ORDERS */

         if pod_sched
         then do:

            /* CHANGED EIGHTH INPUT PARAMETER TO glxcst FROM pod_pur_cost */
            {gprun.i ""gppccal.p""
               "(input        pod_part,
                 input        price_qty,
                 input        pod_um,
                 input        pod_um_conv,
                 input        po_curr,
                 input        pod_pr_list,
                 input        eff_date,
                 input        glxcst,
                 input        no,
                 input        0.0,
                 input-output l_list_price,
                 output       dummy_disc,
                 input-output newprice,
                 output       pc_recno)" }
/*GUI*/ if global-beam-me-up then undo, leave.


            /* IF NO LIST PRICE WAS FOUND LETS TRY TO CHECK FOR   */
            /* A VP_Q_PRICE FOR THE ITEM.  IF WE CANT FIND ONE,   */
            /* POD_PRICE WILL REMAIN AS IT WAS ORIGINALLY.        */
            if pc_recno = 0 or newprice = 0
            then do:
               /* CHECKING FOR BLANK SUPPLIER BUT, WITH NO SPECIFIC SUPPLIER */
               /* FOR AN INVENTORY ITEM                                      */
               for first vp_mstr
                  fields (vp_curr vp_part vp_q_price vp_q_qty
                          vp_um vp_vend vp_vend_part)
                  where vp_part      = pod_part
                  and ( vp_vend      = po_vend
                        or (vp_vend = ""
                            and not can-find(first vp_mstr
                            where vp_mstr.vp_part = pod_part
                            and   vp_mstr.vp_vend = po_vend)) )
                  and vp_vend_part = pod_vpart
               no-lock:

                  if price_qty >= vp_q_qty and
                     pod_um = vp_um        and
                     vp_q_price > 0        and
                     po_curr = vp_curr
                  then
                     pod_pur_cost = vp_q_price.

               end.

            end. /* IF PC_RECNO = 0 OR NEWPRICE = 0 */

            else
               pod_pur_cost = newprice.

         end. /* IF pod_sched */
      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* last-of pod_line */

      /* FOR A NEGATIVE RECEIPT AGAINST A CONSIGNED LINE      */
      /* CHECK WHETHER A POSITIVE RECEIPT EXISTS FOR THE LINE */

      if work_abs_mstr.abs_qty < 0
         and pod_consignment
         and not can-find
                 (first cnsix_mstr
                     where cnsix_part          = pod_part
                       and cnsix_site          = pod_site
                       and cnsix_po_nbr        = work_abs_mstr.abs_order
                       and cnsix_pod_line      = integer(work_abs_mstr.abs_line)
                       and cnsix_lotser        = work_abs_mstr.abs_lotser
                       and cnsix_ref           = work_abs_mstr.abs_ref
                       and cnsix_qty_consigned = abs(work_abs_mstr.abs_qty))
      then do:
         /* NO CONSIGNED INVENTORY CAN BE RETURNED FOR PO LINE */
         {pxmsg.i
            &MSGNUM=6303
            &ERRORLEVEL=3
            &MSGARG1=work_abs_mstr.abs_order
            &MSGARG2=work_abs_mstr.abs_line
         }
         undo mainloop, retry mainloop.
      end. /* IF work_abs_mstr.abs_qty < 0 */

   end. /* for each work_abs_mstr */

   if any_subcontract then do:

      for each work_abs_mstr no-lock
         where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty,
          each abs_mstr
               fields (abs_cum_qty abs_id abs_line abs_loc abs_lotser abs_order
                       abs_qty abs_ref abs_shipfrom abs_shipto abs_ship_qty
                       abs_shp_date abs_site abs_status abs_type abs__qad06
                       abs__qad02)
         no-lock
         where abs_mstr.abs_shipfrom = work_abs_mstr.abs_shipfrom
           and abs_mstr.abs_id       = work_abs_mstr.abs_id,
          each po_mstr
               fields (po_curr po_ex_rate po_ex_rate2 po_fix_rate
                       po_nbr po_so_nbr po_vend po_tot_terms_code) no-lock
         where  po_nbr = abs_order,
          each pod_det exclusive-lock
         where pod_nbr = abs_order and pod_line = integer(abs_line)
           and pod_type = "S"
      break by pod_nbr by pod_line:

         work_qty =
            (abs_mstr.abs_qty - abs_mstr.abs_ship_qty) / pod_um_conv.

         accumulate work_qty(sub-total by pod_line).

         if last-of(pod_line) then
            assign
               pod_qty_chg = accum sub-total by pod_line work_qty
               pod_bo_chg  = pod_qty_ord - pod_qty_rcvd - pod_qty_chg.

      end.

      for each work_abs_mstr no-lock
         where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty,
          each abs_mstr
               fields (abs_cum_qty abs_id abs_line abs_loc abs_lotser abs_order
                       abs_qty abs_ref abs_shipfrom abs_shipto abs_ship_qty
                       abs_shp_date abs_site abs_status abs_type abs__qad06
                       abs__qad02)
         no-lock
         where abs_mstr.abs_shipfrom = work_abs_mstr.abs_shipfrom
           and abs_mstr.abs_id       = work_abs_mstr.abs_id,
          each po_mstr
               fields (po_curr po_ex_rate po_ex_rate2 po_fix_rate
                       po_nbr po_so_nbr po_vend po_tot_terms_code) no-lock
         where po_nbr = abs_order,
          each pod_det exclusive-lock
         where pod_nbr = abs_order and pod_line = integer(abs_line)
           and pod_type = "S"
      break by pod_wo_lot by pod_op:
/*GUI*/ if global-beam-me-up then undo, leave.


         if last-of(pod_op) then do:
            {gprun.i ""poporca6.p""
               "(input ""receipt"",
                 input pod_nbr,
                 input pod_wo_lot,
                 input pod_op,
                 input ?)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            if is_wiplottrace_enabled() then do:
               for first wr_route
               where wr_lot = pod_wo_lot
                 and wr_op = pod_op
               no-lock:
                  if is_operation_queue_lot_controlled
                     (pod_wo_lot, pod_op, INPUT_QUEUE)
                  then do:
                     tempstr = pod_nbr + '/' + string(pod_line).
                     /*PO line is WIP lot traced, use PO Receipts*/
                     {pxmsg.i &MSGNUM=8462 &ERRORLEVEL=3 &MSGARG1=tempstr}
                     undo mainloop, retry mainloop.
                  end.
               end.
            end.

         end.
/*GUI*/ if global-beam-me-up then undo, leave.


         for first wo_mstr
            fields(wo_lot wo_status )
         where wo_lot = pod_wo_lot no-lock:
         end. /* FOR FIRST WO_MSTR */

         if available wo_mstr and wo_status = "C"
         then do:
            /* WORK ORDER ID IS CLOSED, PLANNED OR FIRM PLANNED */
            {pxmsg.i &MSGNUM=523 &ERRORLEVEL=2}
            /* WORK ORDER ID #, SCHEDULE ORDER # */
            {pxmsg.i &MSGNUM=3069 &ERRORLEVEL=1
                     &MSGARG1=pod_wo_lot" "
                     &MSGARG2=pod_nbr}
         end. /* IF AVAILABLE WO_MSTR */

      end.

   end.

   yn = yes.
   /* Please confirm update */
   {pxmsg.i &MSGNUM=32 &ERRORLEVEL=1 &CONFIRM=yn}
   if yn <> yes then undo, retry.

   do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

      {mfnxtsq.i wo_mstr wo_lot woc_sq01 trlot}
   end.
/*GUI*/ if global-beam-me-up then undo, leave.


   {&RSPORC-P-TAG1}
   /* GO THRU WORKFILE AND PERFORM CONTAINER ITEM RECEIPTS */
   for each work_abs_mstr no-lock
      where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty,
       each abs_mstr exclusive-lock
      where abs_mstr.abs_shipfrom = work_abs_mstr.abs_shipfrom
        and abs_mstr.abs_id = work_abs_mstr.abs_id:

      run del_sr_wkfl.

      find pod_det where pod_nbr  = abs_order and
                         pod_line = integer(abs_line)
      exclusive-lock no-error.

      if not available pod_det and abs_item > "" then do:

         for first pt_mstr
            fields (pt_iss_pol pt_part pt_prod_line pt_site)
         where pt_part = abs_item
         no-lock: end.

         if available pt_mstr then do:

            {&RSPORC-P-TAG2}
            for first in_mstr
            fields (in_cur_set in_gl_set in_part in_site in_gl_cost_site)
            where in_site = pt_site
              and in_part = pt_part no-lock:
            end. /* FOR FIRST IN_MSTR */

            for first pl_mstr
            fields (pl_cop_acct pl_cop_sub pl_cop_cc pl_flr_acct
                    pl_flr_sub pl_flr_cc pl_prod_line pl_pur_acct
                    pl_pur_sub pl_pur_cc)
            where pl_prod_line = pt_prod_line
            no-lock: end.

            {gprun.i ""glactdft.p"" "(input ""PO_PUR_ACCT"",
                                      input pt_prod_line,
                                      input in_site,
                                      input if available vd_mstr then
                                            vd_type else """",
                                      input """",
                                      input no,
                                      output cr_acct,
                                      output cr_sub,
                                      output cr_cc)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            {gprun.i ""glactdft.p"" "(input ""WO_COP_ACCT"",
                                      input pt_prod_line,
                                      input in_site,
                                      input """",
                                      input """",
                                      input no,
                                      output dftCOPAcct,
                                      output dftCOPSubAcct,
                                      output dftCOPCostCenter)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            {gprun.i ""glactdft.p"" "(input ""WO_FLR_ACCT"",
                                      input pt_prod_line,
                                      input in_site,
                                      input """",
                                      input """",
                                      input no,
                                      output dftFLRAcct,
                                      output dftFLRSubAcct,
                                      output dftFLRCostCenter)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            {gpsct03.i &cost=sct_cst_tot}

            create sr_wkfl.
            assign
               global_part = abs_item
               part        = abs_item
               sr_userid   = mfguser
               sr_lineid   = abs_mstr.abs_line
               sr_site     = abs_mstr.abs_site
               sr_loc      = abs_mstr.abs_loc
               sr_lotser   = abs_mstr.abs_lotser
               sr_ref      = abs_mstr.abs_ref
               sr_qty      = abs_mstr.abs_qty - abs_mstr.abs_ship_qty
               unit_cost   = glxcst
               so_job      = ""
               addr        = abs_mstr.abs_shipto
               project     = ""
               dr_acct     = if not pt_iss_pol then
                                dftFLRAcct
                             else
                                dftCOPAcct
               dr_sub      = if not pt_iss_pol then
                                dftFLRSubAcct
                             else
                                dftCOPSubAcct
               dr_cc       = if not pt_iss_pol then
                                dftFLRCostCenter
                             else
                                dftCOPCostCenter
               transtype   = "RCT-UNP"
               issrct      = "RCT"
               conv        = 1.

            rmks = getTermLabel("CONTAINER_RECEIPT",17).

            if recid(sr_wkfl) = -1 then .

            {gprun.i ""icintra.p"" "(shipnbr, ship_date, '', false)" }
/*GUI*/ if global-beam-me-up then undo, leave.


            if available sr_wkfl then delete sr_wkfl.

         end. /* if available pt_mstr */

         assign
            abs_mstr.abs_ship_qty = abs_mstr.abs_qty.

      end. /* if not available pod_det and abs_item... */

   end.  /* FOR EACH */

   run dotrans1
      (output undo-loop).
   if undo-loop then
      undo mainloop, retry mainloop.

   {&RSPORC-P-TAG3}
   do transaction:

      /* MARK SHIPPER CONFIRMED */
      find abs_mstr where recid(abs_mstr) = abs_recid exclusive-lock.
      assign
         substring(abs_status,2,1) = "y"
         abs_eff_date           = eff_date.

      if abs_shp_date = ? then
         abs_shp_date = eff_date.

      for first so_mstr
         fields (so_nbr so_primary so_secondary)
      where so_nbr = abs_order
      no-lock: end.

      if available so_mstr and (so_primary = yes)
         and (so_secondary = yes)
      then do:

         for first sod_det
         fields (sod_btb_type sod_cfg_type sod_fa_nbr sod_line sod_nbr)
         where sod_nbr      = abs_order
         and   sod_line     = integer(abs_line)
         and   sod_btb_type = "03"
         no-lock: end.

         if available sod_det then do:

            for first ad_mstr
            fields (ad_addr ad_edi_ctrl ad_line1 ad_name)
            where ad_addr = abs_mstr.abs_shipto
            no-lock: end.

            if available ad_mstr and
               substring(ad_edi_ctrl[1],1,1) = "e"
            then do:

               assign
                  doc-type = "ASN"
                  doc-ref  = abs_mstr.abs_shipfrom
                  add-ref  = abs_id
                  msg-type = "ASN".

               /* QUEUE DOCUMENT FOR TRANSMISSION - BTB */
               {gprun.i ""gpquedoc.p""
                  "(input-output doc-type,
                    input-output abs_shipfrom,
                    input-output abs_id,
                    input-output msg-type,
                    input-output trq-id,
                    input yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            end.

         end. /* if available sod_det */

      end. /* if available so_mstr and so_primary and so_secondary */

   end.   /* END TRANSACTION */

   global_recid = abs_recid.

   run del_sr_wkfl.

   hide message no-pause.

end.

if is_wiplottrace_enabled() then
   delete PROCEDURE h_wiplottrace_procs no-error.
if is_wiplottrace_enabled() then
   delete PROCEDURE h_wiplottrace_funcs no-error.

PROCEDURE upd-kit-inv:
/*-----------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
 -------------------------------------------------------------------------*/

   if not {gpiswrap.i} then do:
      /* Processing... Please wait */
      {pxmsg.i &MSGNUM=832 &ERRORLEVEL=1}
   end.

   for each work_abs_mstr no-lock
      where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty,
      each abs_mstr
      fields (abs_cum_qty abs_id abs_line abs_loc abs_lotser abs_order
              abs_qty abs_ref abs_shipfrom abs_shipto abs_ship_qty
              abs_shp_date abs_site abs_status abs_type abs__qad06
              abs__qad02) no-lock
      where abs_mstr.abs_shipfrom = work_abs_mstr.abs_shipfrom
      and   abs_mstr.abs_id       = work_abs_mstr.abs_id,
      each po_mstr
      fields (po_curr po_ex_rate po_ex_rate2 po_fix_rate
              po_nbr po_so_nbr po_vend po_tot_terms_code) no-lock
      where po_nbr = abs_mstr.abs_order,
      each pod_det
      fields (pod_bo_chg pod_curr_rlse_id pod_line pod_nbr pod_op
              pod_part pod_pr_list pod_ps_chg pod_pur_cost
              pod_qty_chg pod_qty_ord pod_qty_rcvd pod_sched
              pod_site pod_sod_line pod_type pod_um pod_um_conv
              pod_vpart pod_wo_lot) no-lock
      where pod_part = work_abs_mstr.abs_item
      and   pod_nbr  = abs_mstr.abs_order
      and   pod_line = integer(abs_mstr.abs_line)
   break by pod_nbr by pod_line:

      for first sod_det
      fields (sod_btb_type sod_cfg_type sod_fa_nbr sod_line sod_nbr)
      where sod_nbr  = po_so_nbr
      and   sod_line = pod_sod_line
      no-lock: end.

      if available sod_det and sod_cfg_type = "2"
         and sod_fa_nbr = ""
      then do:

         accumulate abs_mstr.abs_qty (total by pod_line).

         if last-of(pod_line) then do:

            confirm_mode = no.
            sod_recno = recid(sod_det).

            {gprun.i ""rcsoisk.p""
               "(input recid(abs_mstr),
                 input confirm_mode,
                 input (accumulate total by pod_line
                 abs_mstr.abs_qty))"}
/*GUI*/ if global-beam-me-up then undo, leave.


         end. /* if last-of(pod_line) */

      end. /* if available sod_det and sod_cfg_type = "2" */

   end. /* for each work_abs_mstr ... breab by pod_nbr */

END PROCEDURE.

PROCEDURE p-chk-act-schd:
/*-----------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
 -------------------------------------------------------------------------*/

   define input parameter l_pod_sched like pod_sched           no-undo.
   define input parameter l_curr_rlse like pod_curr_rlse_id[1] no-undo.

   if l_pod_sched and l_curr_rlse = ""
   then do:
      /* NO ACTIVE SCHEDULE EXISTS */
      {pxmsg.i &MSGNUM=2362 &ERRORLEVEL=2}
   end. /* IF POD_SCHED */

END PROCEDURE.

PROCEDURE del_sr_wkfl:
/*-----------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
 -------------------------------------------------------------------------*/

   for each sr_wkfl exclusive-lock where sr_userid = mfguser:
      delete sr_wkfl.
   end.

END PROCEDURE.

PROCEDURE assign-shipdb:
/*-----------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
 -------------------------------------------------------------------------*/
   define input parameter shipto like abs_mstr.abs_shipto.

   for first si_mstr
      fields (si_db si_entity si_site)
   where si_site = shipto
   no-lock: end.

   if not can-find(first dc_mstr)
   then
      ship_db = global_db.
   else
      ship_db = si_db.

END PROCEDURE.

PROCEDURE p_glcalval:
/*-----------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
 -------------------------------------------------------------------------*/
   define output parameter l_flag like mfc_logical no-undo.

   for each work_abs_mstr
      where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty and
         (work_abs_mstr.abs_id begins "i" or
          work_abs_mstr.abs_id begins "c")
   no-lock:

      for first si_mstr
         fields ( si_db si_entity si_site )
      where si_site = work_abs_mstr.abs_site
      no-lock: end.

      if available si_mstr then do:

         /* CHECK GL EFFECTIVE DATE */
         {gpglef01.i ""IC"" si_entity eff_date}

         if gpglef > 0 then do:
            {pxmsg.i &MSGNUM=gpglef &ERRORLEVEL=4 &MSGARG1=si_entity}
            l_flag = yes.
            return.
         end. /* IF GPGLEF > 0 */

      end. /* IF AVAILABLE SI_MSTR */

   end. /* FOR EACH WORK_ABS_MSTR */

END PROCEDURE.

PROCEDURE check_supperf:
/*-----------------------------------------------------------------------
  Purpose:     Determine if supplier performance in installed
  Parameters:
  Notes:
 -------------------------------------------------------------------------*/
   define input parameter abs_recid as recid no-undo.

   if can-find (mfc_ctrl where
                mfc_field = "enable_supplier_perf" and
                mfc_logical)          and
      can-find (_File where _File-name = "vef_ctrl")
   then do:

      {gprunmo.i &module="ASP" &program=""rspove.p""
         &param="""(input abs_recid, input auto_receipt)"""}

   end.  /* if enable supplier performance */

END PROCEDURE.

PROCEDURE dotrans1:
/*-----------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
 -------------------------------------------------------------------------*/
   define output parameter undo-loop as logical    no-undo.

   define variable l_abs_vend_lot      like sr_vend_lot no-undo.

   undo-loop = no.

   do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


      /* LOGIC TO STOP PO SHIPPER RECEIPT OF A PO SHIPPER       */
      /* CREATED WITH INVALID LOCATIONS WHEN THE SITE DISALLOWS */
      /* AUTOMATIC LOCATIONS.                                   */
      l_undotr = no.

      for each work_abs_mstr
      fields(abs_id abs_item abs_line abs_order abs_qty
             abs_shipfrom abs_ship_qty abs_site abs__qad03
             abs__qad06 abs__qad07)
      where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty no-lock,
          each abs_mstr
          fields(abs_cum_qty abs_eff_date abs_id abs_item abs_line abs_loc
                 abs_lotser abs_order abs_qty abs_ref abs_shipfrom
                 abs_shipto abs_ship_qty abs_shp_date abs_site abs_status
                 abs_type abs__qad06 abs__qad02)
         where abs_mstr.abs_shipfrom = work_abs_mstr.abs_shipfrom
           and abs_mstr.abs_id       = work_abs_mstr.abs_id
      no-lock:

         /* INTRODUCED CALL TO icedit.p TO CHECK FOR VALID LOCATION  */
         /* VARIABLE l_undotr SET TO YES WHEN INVALID LOCATION FOUND */

         if abs_mstr.abs_id begins "i"
         then
            for first pod_det
               fields(pod_nbr pod_line pod_type)
               where pod_nbr  = abs_mstr.abs_order
                and  pod_line = integer(abs_mstr.abs_line)
               no-lock:
            end. /* FOR FIRST pod_det */

         /* MODIFYING THE BELOW CONDITION TO AVOID */
         /* CALLING ICEDIT.P FOR A MEMO TYPE PO */

         if (abs_mstr.abs_site   <> ""
             or abs_mstr.abs_loc <> "")
         and ((abs_mstr.abs_id begins "i"
             and available pod_det
             and pod_type <> "M")
             or not (abs_mstr.abs_id begins "i"))
         then do:

            /* CHANGED EIGHTH INPUT PARAMETER FROM BLANK TO */
            /* abs_mstr.abs__qad02 TO PASS UNIT OF MEASURE  */
            /* CHANGED THE FIRST PARAMETER FROM "" to "RCT-PO" AND */
            /* THE SEVENTH PARAMETER FROM 0 TO abs_mstr.abs_qty.   */

            {gprun.i ""icedit.p""
               "(input ""RCT-PO"",
                 input abs_mstr.abs_site,
                 input abs_mstr.abs_loc,
                 input abs_mstr.abs_item,
                 input abs_mstr.abs_lotser,
                 input """",
                 input abs_mstr.abs_qty,
                 input abs_mstr.abs__qad02,
                 input """",
                 input """",
                 output l_undotr)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            if l_undotr = yes then do:
               undo-loop = yes.
               return.
            end. /* IF l_undotr = yes */

         end. /* IF abs_mstr.abs_site <> "" ... */

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH work_abs_mstr ... */

      for each work_abs_mstr no-lock
         where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty,
          each abs_mstr exclusive-lock
         where abs_mstr.abs_shipfrom = work_abs_mstr.abs_shipfrom
           and abs_mstr.abs_id = work_abs_mstr.abs_id,
          each po_mstr
        fields (po_curr po_ex_rate po_ex_rate2 po_fix_rate
                po_nbr po_so_nbr po_vend po_tot_terms_code) no-lock
         where po_nbr = abs_mstr.abs_order,
          each pod_det exclusive-lock
         where pod_nbr = abs_mstr.abs_order and
               pod_line = integer(abs_mstr.abs_line)
           and pod_part = work_abs_mstr.abs_item
      break by pod_nbr by pod_line:
/*GUI*/ if global-beam-me-up then undo, leave.


         l_abs_vend_lot = "".

         {gpextget.i &OWNER     = 'T2:T3'
                     &TABLENAME = 'abs_mstr'
                     &REFERENCE = 'SupplierLot'
                     &KEY1      = abs_mstr.abs_shipfrom
                     &KEY2      = abs_mstr.abs_id
                     &CHAR1     = l_abs_vend_lot}

         if first-of(pod_nbr) then do:

            run del_sr_wkfl.

            if work_abs_mstr.abs__qad06 <> "" then do:
               /* CLEAR ALL THE TAX WORK FILE */
               for each tax_wkfl exclusive-lock where tax_nbr = po_nbr:
                  delete tax_wkfl.
               end.
            end.

         end.

         find sr_wkfl where
              sr_userid = mfguser
          and sr_lineid = abs_mstr.abs_line
          and sr_site = abs_mstr.abs_site
          and sr_loc = abs_mstr.abs_loc
          and sr_lotser = abs_mstr.abs_lotser
          and sr_ref = abs_mstr.abs_ref
         exclusive-lock no-error.

         {&RSPORC-P-TAG4}
         if not available sr_wkfl then do:

            create sr_wkfl.
            assign
               sr_userid = mfguser
               sr_lineid = abs_mstr.abs_line
               sr_site = abs_mstr.abs_site
               sr_loc = abs_mstr.abs_loc
               sr_lotser = abs_mstr.abs_lotser
               sr_vend_lot = l_abs_vend_lot
               sr_ref = abs_mstr.abs_ref.

            if recid(sr_wkfl) = -1 then .

         end.

         /* STORING THE QUANTITY IN INVENTORY UM TO     */
         /* AVOID ROUNDING ERRORS IN LD_DET AND TR_HIST */
         assign
            work_qty  = (abs_mstr.abs_qty - abs_mstr.abs_ship_qty) / pod_um_conv
            sr_qty    = sr_qty + work_qty
            l_tot_qty = decimal(sr__qadc01) +
                        (abs_mstr.abs_qty - abs_mstr.abs_ship_qty)
            sr__qadc01 = string(l_tot_qty).

         accumulate work_qty(sub-total by pod_line).

         if last-of(pod_line) then do:

            pod_qty_chg = accum sub-total by pod_line work_qty.
            pod_ps_chg  = abs_mstr.abs_cum_qty.

            /* SET THE POD_BO_CHG VALUE TO STOP POPORCB.P FROM CHANGING THE */
            /* STATUS OF THE POD_LINE , TO RECEIVE PARTIAL QTY             */
            pod_bo_chg  = pod_qty_ord - (pod_qty_chg + pod_qty_rcvd ).

            if work_abs_mstr.abs__qad06 <> "" then do:

               /* THE ABS_MSTR ARE FROM FISCAL RECEIVING */
               create tax_wkfl.
               assign
                  tax_nbr     =  pod_nbr
                  tax_line    =  pod_line.

               if substring(abs_mstr.abs__qad06,1,1) = "Y" then
                  tax_taxable = true.
               if substring(abs_mstr.abs__qad06,2,1) = "Y" then
                  tax_in      = true.

               assign
                  tax_taxc    = right-trim(substring(abs_mstr.abs__qad06,3,3))
                  tax_env     = right-trim(substring(abs_mstr.abs__qad06,6,16))
                  tax_usage   = right-trim(substring(abs_mstr.abs__qad06,22,8)) .

               if substring(work_abs_mstr.abs__qad07,9,18) <> "" then
                  tax_price =
                     decimal(substring(work_abs_mstr.abs__qad07,9,18))
                     / decimal(work_abs_mstr.abs__qad03) * pod_um_conv.

            end.

         end. /* if last-of(pod_line) */

         if last-of(pod_nbr) then do:

            po_recno = recid(po_mstr).

            {mfnctrlc.i poc_ctrl poc_rcv_pre poc_rcv_nbr prh_hist
               prh_receiver receivernbr}

            for first poc_ctrl
            fields (poc_rcv_nbr poc_rcv_pre poc_tol_cst poc_tol_pct)
            no-lock: end.

            if (oldcurr <> po_curr) or (oldcurr = "") then do:
               /* GET ROUNDING METHOD FROM CURRENCY MASTER */
               {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                  "(input po_curr,
                    output rndmthd,
                    output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                  if c-application-mode <> "WEB" then
                     pause 0.
                  undo-loop = yes.
                  return.
               end.
               oldcurr = po_curr.
            end.

            if po_fix_rate = no then do:
               /* GET EXCHANGE RATE */
               {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                  "(input po_curr,
                    input base_curr,
                    input exch_ratetype,
                    input eff_date,
                    output exch_rate,
                    output exch_rate2,
                    output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                  undo-loop = yes.
                  return.
               end.
            end.

            else
               assign
                  exch_rate = po_ex_rate
                  exch_rate2 = po_ex_rate2.

            /* IF FISCAL RECEIVING THEN COPY THE TAX DETAIL RECORDS OF TRANS */
            /* TYPE 24 TO TRANS_TYPE 21                                      */
            if work_abs_mstr.abs__qad06 <> "" then do:
               fiscal_rec = true .
               {gprun.i  ""txdetcpy.p""
                  "(input fiscal_id,
                    input pod_nbr,
                    input ""24"",
                    input receivernbr,
                    input pod_nbr,
                    input ""21"")" }
/*GUI*/ if global-beam-me-up then undo, leave.

            end.

            assign
               porec = yes
               is-return = no
               tax_tr_type = '21'
               transtype="RCT-PO"
               cmmt-prefix = "RCPT:".

            hide frame bb no-pause.

            /* CALCULATE QTY OPEN FOR DISCRETE PO'S BEING RECEIVED  */
            /* THROUGH THE SCHEDULED ORDER RECEIPT FUNCTION. QTY    */
            /* OPEN IS NEEDED FOR SUPPLIER PERFORMANCE CALCULATIONS */
            if not pod_sched then do:
               {gprun.i ""rsoqty.p""
                  "(input recid(pod_det),
                    input receipt_date,
                    output qopen)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* if not pod_sched then do: */

            /* RELEASE POD_DET ENSURES THAT IN ORACLE ENVIRONMENT */
            release pod_det.

            {gprun.i ""poporcb.p""
               "(input shipnbr,
                 input ship_date,
                 input inv_mov,
                 input """",
                 input auto_receipt,
                 input no,
                 input 0,
                 input """",
                 output op_rctpo_trnbr)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            view frame bb.

            {gprun.i ""poporcd.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


         end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* last-of (pod_nbr) */

         /* CALCULATE AND EDIT TAXES */
         if proceed = yes then

            {gprun.i ""potaxdt.p""
               "(input po_recno)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      end.    /* for each work_abs_mstr */

      run upd-kit-inv.

      /* ADDED THE FOLLOWING CODE FOR DETAILED ALLOCATION OF BTB SO */
      /* AND SHIPMENT OF THE BTB DIRECT DELIVERY SO LINES           */

      for first abs_mstr
      fields (abs_cum_qty abs_id abs_line abs_loc abs_lotser
              abs_order abs_qty abs_ref abs_shipfrom abs_shipto
              abs_ship_qty abs_shp_date abs_site abs_status
              abs_type abs__qad06 abs__qad02)
      where recid(abs_mstr) = abs_recid
      no-lock: end.

      /* DETAILED ALLOCTION FOR EMT SO */
      {gprun.i ""rssoall.p""
         "(input abs_mstr.abs_id,
           input abs_mstr.abs_shipfrom)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      /* SO SHIPMENT FOR DIRECT DELIVERY EMT SO */
      {gprun.i ""rcshld.p""
         "(input abs_mstr.abs_id,
           input abs_mstr.abs_shipfrom,
           output undo_tran)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      if undo_tran then do:
         undo-loop = yes.
         return.
      end.

      /* UPDATE THE SHIP QTY OF THE abs_mstr RECORD NOW.*/
      for each work_abs_mstr no-lock
         where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty,
          each abs_mstr exclusive-lock
         where abs_mstr.abs_shipfrom = work_abs_mstr.abs_shipfrom
           and abs_mstr.abs_id = work_abs_mstr.abs_id:

         assign
            abs_mstr.abs_ship_qty = abs_mstr.abs_qty.

      end.

   end. /* TRANSACTION  CREATE RCT-PO & ISS-SO */

END PROCEDURE.

PROCEDURE recalc_freight:
/*-----------------------------------------------------------------------
  Purpose:     Displays the popup only if there exists a DIR-SHIP
               Sales Order with freight terms
  Parameters:
  Notes:
 -------------------------------------------------------------------------*/
   define output parameter l_cal  like mfc_logical no-undo.

   for each work_abs_mstr
   fields (abs_id abs_item abs_line abs_order abs_qty
           abs_shipfrom abs_ship_qty abs_site abs__qad03
           abs__qad06 abs__qad07)
   where work_abs_mstr.abs_order <> "" no-lock:

      for first sod_det
      fields (sod_btb_po sod_btb_type sod_cfg_type sod_fa_nbr
              sod_line sod_nbr sod_part )
      where sod_btb_po   = abs_order
        and sod_part     = abs_item
        and sod_line     = integer(abs_line)
        and sod_btb_type = "03"
      no-lock: end.

      if available sod_det              and
         (can-find (first so_mstr
                    where so_nbr      = sod_nbr
                      and so_fr_terms <> ""
                      and so_fr_list  <> "" ))
      then do:
         l_cal = yes.
         return .
      end. /* IF AVAILABLE sod_det AND .. */

   end. /* FOR EACH work_abs_mstr */

END PROCEDURE.