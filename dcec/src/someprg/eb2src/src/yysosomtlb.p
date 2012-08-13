/* sosomtlb.p  - SALES ORDER MAINTENANCE LINE DETAIL SUBROUTINE              */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.34.1.42.5.4 $                                                 */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 6.0      LAST MODIFIED: 01/31/91   BY: afs *D327*               */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*               */
/* REVISION: 6.0      LAST MODIFIED: 11/13/91   BY: WUG *D887*               */
/* REVISION: 7.0      LAST MODIFIED: 01/13/92   BY: afs *F042*               */
/* REVISION: 7.0      LAST MODIFIED: 02/21/92   BY: afs *F223*               */
/* REVISION: 7.0      LAST MODIFIED: 03/24/92   BY: dld *F297*               */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: afs *F356*               */
/* REVISION: 7.0      LAST MODIFIED: 04/16/92   BY: dld *F382*               */
/* REVISION: 7.0      LAST MODIFIED: 06/12/92   BY: tjs *F504*               */
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: afs *F519*               */
/* REVISION: 7.0      LAST MODIFIED: 06/26/92   BY: afs *F711*               */
/* REVISION: 7.0      LAST MODIFIED: 07/27/92   BY: tjs *F765*               */
/* REVISION: 7.0      LAST MODIFIED: 07/27/92   BY: tjs *F802*               */
/* REVISION: 7.3      LAST MODIFIED: 09/17/92   BY: tjs *G035*               */
/* REVISION: 7.3      LAST MODIFIED: 10/06/92   BY: mpp *G013*               */
/* REVISION: 7.3      LAST MODIFIED: 01/26/93   BY: bcm *G429*               */
/* REVISION: 7.3      LAST MODIFIED: 02/08/93   BY: bcm *G415*               */
/* REVISION: 7.3      LAST MODIFIED: 04/05/93   BY: bcm *G889*               */
/* REVISION: 7.3      LAST MODIFIED: 04/15/93   BY: tjs *G948*               */
/* REVISION: 7.4      LAST MODIFIED: 06/21/93   BY: pcd *H008*               */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*               */
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184*               */
/* REVISION: 7.4      LAST MODIFIED: 02/11/94   BY: dpm *FM10*               */
/* REVISION: 7.4      LAST MODIFIED: 03/18/94   BY: dpm *FM25*               */
/* REVISION: 7.4      LAST MODIFIED: 06/10/94   BY: qzl *H380*               */
/* REVISION: 7.4      LAST MODIFIED: 07/11/94   BY: bcm *H438*               */
/* REVISION: 7.4      LAST MODIFIED: 08/17/94   BY: dpm *FQ29*               */
/* REVISION: 7.4      LAST MODIFIED: 08/29/94   BY: bcm *H494*               */
/* REVISION: 7.4      LAST MODIFIED: 09/02/94   BY: dpm *FQ53*               */
/* REVISION: 7.4      LAST MODIFIED: 10/28/94   BY: dpm *FR95*               */
/* REVISION: 7.4      LAST MODIFIED: 11/07/94   BY: str *FT44*               */
/* REVISION: 7.4      LAST MODIFIED: 11/16/94   BY: qzl *FT43*               */
/* REVISION: 7.4      LAST MODIFIED: 11/21/94   BY: afs *H605*               */
/* REVISION: 7.4      LAST MODIFIED: 01/13/95   BY: dpm *F0DR*               */
/* REVISION: 7.4      LAST MODIFIED: 01/17/95   BY: srk *G0C1*               */
/* REVISION: 7.4      LAST MODIFIED: 01/31/95   BY: bcm *F0G8*               */
/* REVISION: 7.4      LAST MODIFIED: 02/23/95   BY: jzw *H0BM*               */
/* REVISION: 7.4      LAST MODIFIED: 03/06/95   BY: wjk *H0BT*               */
/* REVISION: 7.4      LAST MODIFIED: 03/09/95   BY: kjm *F0K6*               */
/* REVISION: 7.4      LAST MODIFIED: 03/31/95   BY: rxm *F0PR*               */
/* REVISION: 7.4      LAST MODIFIED: 04/17/95   BY: jpm *H0CJ*               */
/* REVISION: 8.5      LAST MODIFIED: 03/05/95   BY: DAH *J042*               */
/* REVISION: 7.4      LAST MODIFIED: 10/23/95   BY: rxm *G19G*               */
/* REVISION: 7.4      LAST MODIFIED: 11/22/95   BY: ais *H0H2*               */
/* REVISION: 8.5      LAST MODIFIED: 11/07/95   BY: taf *J053*               */
/* REVISION: 8.5      LAST MODIFIED: 12/01/95   BY: *J04C* Sue Poland        */
/* REVISION: 8.5      LAST MODIFIED: 12/04/95   BY: *J04C* Tom Vogten        */
/* REVISION: 8.6      LAST MODIFIED: 09/27/96   BY: svs *K007*               */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Elke Van Maele    */
/* REVISION: 8.6      LAST MODIFIED: 11/05/96   BY: *H0NR* Suresh Nayak      */
/* REVISION: 8.6      LAST MODIFIED: 12/31/96   BY: *K03Y* Jean Miller       */
/* REVISION: 8.6      LAST MODIFIED: 06/16/97   BY: *J1SY* Suresh Nayak      */
/* REVISION: 8.6      LAST MODIFIED: 06/25/97   BY: *K0FM* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 07/15/97   BY: *K0G6* Arul Victoria     */
/* REVISION: 8.6      LAST MODIFIED: 07/01/97   BY: *K0DH* Jim Williams      */
/* REVISION: 8.6      LAST MODIFIED: 08/06/97   BY: *J1YG* Seema Varma       */
/* REVISION: 8.6      LAST MODIFIED: 07/22/97   BY: *H1B1* Suresh Nayak      */
/* REVISION: 8.6      LAST MODIFIED: 09/09/97   BY: *H1F2* Todd Runkle       */
/* REVISION: 8.6      LAST MODIFIED: 09/29/97   BY: *K0HB* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 10/08/97   BY: *K0N5* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 11/18/97   BY: *J25B* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 12/18/97   BY: *K15N* Jerry Zhou        */
/* REVISION: 8.6      LAST MODIFIED: 01/23/98   BY: *J2BW* Nirav Parikh      */
/* REVISION: 8.6      LAST MODIFIED: 01/31/98   BY: *J2D6* Seema Varma       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 03/21/98   BY: *K1KQ* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* Old ECO marker removed, but no ECO header exists *G501*                   */
/* REVISION: 8.6E     LAST MODIFIED: 08/03/98   BY: *L024* Sami Kureishy     */
/* REVISION: 8.6E     LAST MODIFIED: 03/11/99   BY: *J3C5* Anup Pereira      */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney    */
/* REVISION: 9.1      LAST MODIFIED: 12/15/99   BY: *N05D* Steve Nugent      */
/* REVISION: 9.1      LAST MODIFIED: 01/19/2000 BY: *L0PY* Kedar Deherkar    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *N0CG* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED: 06/30/00   BY: *N0DX* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb               */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00   BY: *L121* Gurudev C         */
/* REVISION: 9.1      LAST MODIFIED: 12/18/00   BY: *M0TZ* Veena Lad         */
/* REVISION: 9.1      LAST MODIFIED: 10/17/00   BY: *N0WB* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED: 02/26/01   BY: *M126* Sandeep P         */
/* Revision: 1.34.1.16    BY: Katie Hilbert     DATE: 04/01/01 ECO: *P002*   */
/* Revision: 1.34.1.19    BY: Sandeep P.        DATE: 03/14/01 ECO: *M13J*   */
/* Revision: 1.34.1.22    BY: Russ Witt         DATE: 06/13/01 ECO: *P00J*   */
/* REVISION: 9.1      LAST MODIFIED: 29 JUN 2001 BY: *N0ZX* Ed van de Gevel  */
/* Revision: 1.34.1.23    BY: Dan Herman          DATE: 07/09/01 ECO: *P007* */
/* Revision: 1.34.1.25    BY: Reetu Kapoor        DATE: 08/01/01 ECO: *N0ZT* */
/* Revision: 1.34.1.26    BY: Russ Witt           DATE: 09/21/01 ECO: *P01H* */
/* Revision: 1.34.1.27    BY: Russ Witt           DATE: 10/17/01 ECO: *P021* */
/* Revision: 1.34.1.28    BY: Steve Nugent        DATE: 10/22/01 ECO: *P004* */
/* Revision: 1.34.1.30    BY: Santhosh Nair       DATE: 12/10/01 ECO: *M1H1* */
/* Revision: 1.34.1.31    BY: B. Gates            DATE: 03/04/02 ECO: *N1BT* */
/* Revision: 1.34.1.32    BY: Inna Fox            DATE: 02/14/02 ECO: *M12Q* */
/* Revision: 1.34.1.33    BY: Patrick Rowan       DATE: 03/24/02 ECO: *P00G* */
/* Revision: 1.34.1.34    BY: Inna Fox            DATE: 04/17/02 ECO: *P05J* */
/* Revision: 1.34.1.35    BY: Ashish M.           DATE: 05/20/02 ECO: *P04J* */
/* Revision: 1.34.1.36    BY: Russ Witt           DATE: 06/03/02 ECO: *P07M* */
/* Revision: 1.34.1.37    BY: Anitha Gopal        DATE: 06/17/02 ECO: *N1KQ* */
/* Revision: 1.34.1.38    BY: Steve Nugent        DATE: 08/08/02 ECO: *P0DN* */
/* Revision: 1.34.1.41    BY: John Pison          DATE: 08/30/02 ECO: *P0HM* */
/* Revision: 1.34.1.42    BY: Ed van de Gevel     DATE: 12/03/02 ECO: *N1XD* */
/* Revision: 1.34.1.42.5.1 BY: Mercy Chittilapilly DATE: 06/05/03 ECO: *N2DJ* */
/* Revision: 1.34.1.42.5.2 BY: Somesh Jeswani      DATE: 09/29/03 ECO: *P14M* */
/* Revision: 1.34.1.42.5.3 BY: Ashish Maheshwari DATE: 11/28/03 ECO: *P1CN* */
/* $Revision: 1.34.1.42.5.4 $ BY: Ed van de Gevel DATE: 12/02/03 ECO: *P0QT* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* REVISION: 8.5      LAST MODIFIED: 11/14/03   BY: *LB01* Long Bo         */
/* REVISION: eb2+sp7     retrofit: 06/21/05   BY: *tfq* Tao fengqin         */

         /*!
            SOSOMTLB.P is called by SOSOMTLA.P to maintain data elements in the
            larger line item data entry frame in SO and RMA Maintenance.
          */

         /*!
            Input parameters are:

            this-is-rma:    Will be yes in RMA Maintenance and no in Sales
                            Order Maintenance.
            rma-recno:      When processing an RMA, this is the rma_mstr (the
                            RMA header) recid.
            rma-issue-line: When processing RMA's, this will be yes when
                            maintaining the issue (outgoing) lines, and no
                            when maintaining the receipt (incoming) lines.
                            In SO Maintenance, this will be yes.
            rmd-recno:      In RMA Maintenance, this will contain the recid
                            for rmd_det (the RMA line).  For SO Maintenance,
                            this will be ?.
            l_prev_um_conv: When the User changes the type to "M" on sales
                            Order or RMA Maintenance then the Inventory will
                            be correctly de-allocated using correct Um
            l_sodqtyord   : Store the previous Quantity to Order to reduce the
                            Quantity Required when user changes the Ship Type
                            from <blank> to Memo.

            Input/Output parameters are:

            confirmApoAtpOrderLine:
                            Logical whether to confirm APO ATP request in
                            Adexa model.

            Output parameters are:

            atp-site:             Site returned from APO ATP request.
            atp-cum-qty:          Quantity returned from APO ATP request.
            atp-qty-site-changed: Logical whether Site or Quantity from APO ATP
                                  changed from orginal order line request.

*/

{mfdeclre.i}
/*tfq {cxcustom.i "SOSOMTLB.P"}*/
/*tfq*/ {cxcustom.i "yySOSOMTLB.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* CHANGES MADE HERE MAY ALSO NEED TO BE MADE IN fseomtlb.p */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sosomtlb_p_2 "Salesperson 4"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomtlb_p_3 "Salesperson 3"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomtlb_p_4 "Salesperson 2"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomtlb_p_5 "Salesperson 1"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define input parameter this-is-rma     as  logical.
define input parameter rma-recno       as  recid.
define input parameter rma-issue-line  as  logical.
define input parameter rmd-recno       as  recid.
define input parameter l_prev_um_conv  like sod_um_conv no-undo.
define input parameter using_consignment like mfc_logical no-undo.
define input parameter l_sodqtyord     like sod_qty_ord no-undo.
define input-output parameter confirmApoAtpOrderLine
                                       as logical        no-undo.
define output parameter atp-site       like  sod_site    no-undo.
define output parameter atp-cum-qty    like  sod_qty_ord no-undo.
define output parameter atp-qty-site-changed as logical  no-undo.

define new shared variable zone_to   like txz_tax_zone.
define new shared variable zone_from like txz_tax_zone.
define new shared variable tax_usage like so_tax_usage no-undo.
define new shared variable tax_env   like so_tax_env no-undo.
define new shared variable temp_zone like txz_tax_zone.
define new shared variable l_loop_seta like mfc_logical no-undo.

/* DEFINE RNDMTHD FOR CALL TO GPFRLWT.P */
define shared variable rndmthd like rnd_rnd_mthd.
define shared variable prev_type like sod_type .
define shared variable all_days as integer.
define shared variable clines as integer.
define shared variable desc1 like pt_desc1.
define shared variable line like sod_line.
define shared variable sngl_ln like soc_ln_fmt.
define shared variable sod_recno as recid.
define shared variable sodcmmts like soc_lcmmts.
define shared variable sod-detail-all like soc_det_all.
define shared variable so_recno as recid.
define shared variable totallqty like sod_qty_all.
define shared variable so_db like dc_name.
define shared variable inv_db like dc_name.
define shared variable undo_all2 like mfc_logical.
define shared variable mult_slspsn like mfc_logical no-undo.
define shared variable new_line like mfc_logical.
define shared variable old_sod_site like sod_site no-undo.
define shared variable freight_ok   like mfc_logical.
define shared variable old_ft_type  like ft_type.
define shared variable calc_fr      like mfc_logical.
define shared variable disp_fr      like mfc_logical.
define shared variable soc_pc_line  like mfc_logical.
define shared variable err-flag as integer.
define shared variable sonbr like sod_nbr.
define shared variable soline like sod_line.
define shared variable exch-rate like exr_rate.
define shared variable exch-rate2 like exr_rate2.
define shared variable discount as decimal.
define shared variable reprice_dtl like mfc_logical.
define shared variable promise_date as date.

define variable sort as character format "x(28)" extent 4 no-undo.
define variable counter as integer no-undo.
define variable valid_acct like mfc_logical.
define variable glvalid             like mfc_logical.
define variable detqty              like sod_qty_ord.
define variable old_site like sod_site.
define variable continue like mfc_logical no-undo.
define variable prev_qty_all like sod_qty_all no-undo.
define variable warn like mfc_logical no-undo.
define variable rma-receipt-line   as  logical.
define variable frametitle         as character format "x(20)".
/* TAX_IN IS USED BY FSRMAVAT.P */
define shared variable new_order       like  mfc_logical.
define shared variable tax_in          like  cm_tax_in.
define variable sodstdcost like sod_std_cost no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable pkg_code_alt like pt_part extent 7 no-undo.
define variable ord_mult_alt like sod_ord_mult extent 7 no-undo.
define variable charge_type_alt like cct_charge_type extent 7 no-undo.
define variable i as integer no-undo.
define variable old_pkg_code like sod_pkg_code no-undo.
define variable last-field as character no-undo.
define variable old_charge_type like cct_charge_type no-undo.
define variable v_charge_type like cct_charge_type no-undo.
define variable msgnbr as integer no-undo.
define variable chargeable like mfc_logical no-undo.
define variable c-alt-container as character format "x(20)" no-undo.
define variable c-std-pack as character format "x(12)" no-undo.
define variable c-charge-type as character format "x(12)" no-undo.
define variable this-is-so as logical no-undo.
define variable atp-ok         as logical            no-undo.
define variable atp-due-date   like sod_due_date     no-undo.
define variable auto-prom-date like sod_promise_date no-undo.
define variable prev-confirm   like sod_confirm      no-undo.
define variable atp-due-date-changed like mfc_logical no-undo.

/* BTB VARIABLES */
define shared variable s-btb-so        as   logical.
define shared variable s-sec-due       as   date.
define        variable exp-del         as   date.
define        variable pri-due         as   date.
define        variable transnbr        like cmf_trans_nbr.
define        variable prev-promise-date   like sod_promise_date.
define shared variable prev-due-date   like sod_due_date.
define shared variable po-ack-wait     as logical no-undo.
define        variable p-edi-rollback  as logical no-undo
   initial no.
define variable net_avail like sod_qty_all no-undo.
define variable new_record as logical no-undo.

define variable l_use_edi        like mfc_logical initial yes no-undo.
define variable l_update_qty_all like mfc_logical initial no  no-undo.
define variable l_invalid_category like mfc_logical initial no no-undo.
define variable l_old_fr_list      like sod_fr_list            no-undo.

define variable moduleGroup            as character no-undo.
define variable checkAtp               as logical   no-undo.
define variable useApoAtp              as logical   no-undo.
define variable errorResult            as character no-undo.
define variable apoAtpDelAvail         as logical   no-undo
   initial yes.
define variable apoAtpDelAvailMsg      as integer   no-undo.
define variable stdAtpUsed             as logical   no-undo.

define shared stream apoAtpStream.

{pxmaint.i}
/* Define Handles for the programs. */
{pxphdef.i sosoxr1}
{pxphdef.i giapoxr}
/* End Define Handles for the programs. */

/* APO ATP Global Defines */
{giapoatp.i}

{&SOSOMTLB-P-TAG1}

{sobtbvar.i}    /* BACK TO BACK SHARED WORKFILES AND VARIABLES */

{gptxcdec.i}    /* DECLARATIONS FOR gptxcval.i */

{gpfilev.i} /* VARIABLE DEFINITIONS FOR gpfile.i */

/*IT WAS NECESSARY TO MOVE THIS DEFINITION OF SHARED FRAME AND */
/*STREAM TO A LOCATION BEFORE THE DEFS OF SHARED FRAMES C AND D*/
/*BECAUSE IT DOES NOT BEHAVE CORRECTLY IN PROGRESS v7          */
define shared stream bi.
define shared frame bi.
define shared frame c.
define shared frame d.
define shared frame a.

/* FORM DEFINITION FOR HIDDEN FRAME BI */
{sobifrm.i}

form sod_det with frame bi width 80.

/* THE SHARED VARIABLE current_fr_terms IS DEFINED IN pppivar.i, BUT */
/* SINCE ONLY THIS VARIABLE IS REQUIRED, TO AVOID OVERHEADS IT HAS   */
/* BEEN EXPLICITLY DEFINED HERE, INSTEAD OF CALLING PPPIVAR.I        */
define shared variable current_fr_terms   like so_fr_terms.

/*THIS TEMP TABLE IS CREATED TO CALCULATE FREIGHT CHARGES  */
/*WHEN A NEW SALES ORDER LINE IS ADDED TO AN EXISTING ORDER*/
/*WHEN THE FREIGHT TYPE IS "INCLUDE".                      */
define shared temp-table  l_fr_table
       field l_fr_sonbr   like sod_nbr
       field l_fr_soline  like sod_line
       field l_fr_chrg    like sod_fr_chg
       field l_sodlist_pr like sod_list_pr
       index nbrline is primary l_fr_sonbr l_fr_soline.

/*DEFINE SHARED FORMS*/
/*tfq {solinfrm.i}*/
/*tfq*/ {yysolinfrm.i} 

/* CONSIGNMENT VARIABLES */
{socnvars.i}
define variable proc_id as character no-undo.
using_cust_consignment = using_consignment.

form
   sod_pkg_code    colon 20 label "Container Item"
   sod_ord_mult    colon 20
   sod_charge_type colon 20
   sod_alt_pkg     colon 20
with frame cont_pop overlay side-labels centered row 12.
/* SET EXTERNAL LABELS */
setFrameLabels(frame cont_pop:handle).

{&SOSOMTLB-P-TAG6}
form
   space(1)
   so_nbr
   so_cust
   sngl_ln
with frame a side-labels width 80.
{&SOSOMTLB-P-TAG7}
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   pkg_code_alt[1]
   pkg_code_alt[2]
   pkg_code_alt[3]
   pkg_code_alt[4]
   pkg_code_alt[5]
   pkg_code_alt[6]
   pkg_code_alt[7]
with frame alt overlay centered side-labels attr-space
title color normal (getFrameTitle("ALTERNATE_CONTAINERS",29)).
 /* SET EXTERNAL LABELS */
setFrameLabels(frame alt:handle).

form
   c-alt-container   at 8
   c-std-pack   at 28
   c-charge-type  at 42 skip(1)

   " 01."             at 3
   pkg_code_alt[1]    at 8
   ord_mult_alt[1]    at 30
   charge_type_alt[1] at 44 skip

   " 02."             at 3
   pkg_code_alt[2]    at 8
   ord_mult_alt[2]    at 30
   charge_type_alt[2] at 44 skip

   " 03."             at 3
   pkg_code_alt[3]    at 8
   ord_mult_alt[3]    at 30
   charge_type_alt[3] at 44 skip

   " 04."             at 3
   pkg_code_alt[4]    at 8
   ord_mult_alt[4]    at 30
   charge_type_alt[4] at 44 skip

   " 05."             at 3
   pkg_code_alt[5]    at 8
   ord_mult_alt[5]    at 30
   charge_type_alt[5] at 44 skip

   " 06."             at 3
   pkg_code_alt[6]    at 8
   ord_mult_alt[6]    at 30
   charge_type_alt[6] at 44 skip

   " 07."              at 3
   pkg_code_alt[7]     at 8
   ord_mult_alt[7]     at 30
   charge_type_alt[7]  at 44 skip
with frame alt-clc overlay centered no-labels width 60
title color normal (getFrameTitle("ALTERNATE_CONTAINERS",29)).
 /* SET EXTERNAL LABELS */
setFrameLabels(frame alt-clc:handle).

 /* DETERMINE IF CONTAINER AND LINE CHARGES ARE ENABLED */
{cclc.i}

assign
   c-alt-container = getTermLabel("ALTERNATE_CONTAINER",20)
   c-std-pack = getTermLabel("STD_PACK_QTY",12)
   c-charge-type = getTermLabel("CHARGE_TYPE",12).

/* ENSURE NECESSARY CODE_MSTR RECORDS EXIST */
if this-is-rma and
   not can-find(code_mstr where code_fldname = "tr_type"
                and code_value = "ISS-RMA")
then run createCodeMstr.

find first so_mstr
   where recid(so_mstr) = so_recno exclusive-lock no-error.

find first sod_det
   where recid(sod_det) = sod_recno exclusive-lock no-error.

for first soc_ctrl
      fields(soc_all_avl
             soc_due_calc
             soc_lcmmts
             soc_atp_enabled
             soc_horizon
             soc_shp_lead
             soc_calc_promise_date
             soc_use_btb) no-lock:
end. /* FOR FIRST SOC_CTRL */

rma-receipt-line = no.
if this-is-rma then do:
   find rma_mstr where recid(rma_mstr) = rma-recno
      exclusive-lock no-error.
   find rmd_det where recid(rmd_det) = rmd-recno
      exclusive-lock no-error.

   for first rmc_ctrl
         fields(rmc_lcmmts) no-lock:
   end. /* FOR FIRST RMC_CTRL */

   if not rma-issue-line then
      rma-receipt-line = yes.
end.

this-is-so =  if so_fsm_type = "" then yes else no.

old_site = input frame bi sod_site.

run siteChanged.

for first si_mstr
      fields(si_auto_loc si_db si_site si_status)
      where si_site = sod_site no-lock:
end. /* FOR FIRST SI_MSTR */

/* SET SLS, DISC ACCTS BASED ON PRODUCT LINE, SITE, CUST TYPE, CHANNEL */

for first pt_mstr
      fields(pt_part)
      where pt_part = sod_part no-lock:
end. /* FOR FIRST PT_MSTR */

if available pt_mstr then pt_recno = recid(pt_mstr).
else pt_recno = ?.
{&SOSOMTLB-P-TAG4}
if new_line then do:
   {gprun.i ""soplsd.p""}
end.
{&SOSOMTLB-P-TAG5}

sodcmmts = (sod_cmtindx <> 0 or (new_line and soc_lcmmts)).
if this-is-rma and new_line then
   sodcmmts = rmc_lcmmts.

if sngl_ln then do:
   /* Convert cost from remote base currency to local base currency */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input  """",
        input  base_curr,
        input  exch-rate,
        input  exch-rate2,
        input  sod_std_cost,
        input  false,
        output sodstdcost,
        output mc-error-number)" }
   if mc-error-number <> 0 then
      run display_msg (input mc-error-number, input 2).

   display
      sod_site sod_loc sod_serial
      sod_qty_all sod_qty_pick
      sod_pricing_dt
    /*tfq  sodstdcost @ sod_std_cost  */
      sod_due_date sod_req_date sod_per_date
      sod_promise_date
      sod_fr_list
      sod_acct
      sod_sub
      sod_cc
      sod_project
      sod_dsc_acct
      sod_dsc_sub
      sod_dsc_cc
      sod_dsc_project
      sod_confirm
      sod_type sod_um_conv
      sod-detail-all
      sod_taxable
      sod_taxc
      sod_order_category
      sodcmmts
   with frame d.
end. /* if sngl_ln */

seta:
/* Prompt for rest of the line information on single line screen */
do on error undo, retry:

   /* Initialize to no so that if could not connect to APO ATP   */
   /* and user starts all over, that APO ATP processing will be  */
   /* attempted again.                                           */
   stdAtpUsed = no.

   if sngl_ln then do:
      /* ADD EDITING TO SET GLOBAL LOC FOR LOT/SER LOOKUP */

      assign
         prev_qty_all  = if new sod_det then 0 else sod_qty_all
         prev-promise-date = sod_promise_date
         prev-due-date = sod_due_date
         prev-confirm  = sod_confirm.

      if not so_secondary and soc_use_btb then
         rollback:
      do on error undo, retry:

         for first cm_mstr
               fields(cm_addr)
               where cm_addr = so_cust no-lock:
         end. /* FOR FIRST CM_ADDR */

         /* CONVERT A DATE TO A STRING VARIABLE */
         s-cmdval = string ( sod_due_date ).

         /* ROLL-BACK */
         {gprun.i ""sobtbrb.p""
            "(input recid(so_mstr),
              input sod_line,
              input ""pod_det"",
              input ""pod_due_date"",
              input p-edi-rollback,
              output return-msg)" }

         /* DISPLAY ERROR MESSAGE RETURN FROM SOBTBRB.P */
         if return-msg <> 0 then do:
            run display_msg (input return-msg, input 4).
            assign
               s-rb-init = no
               return-msg = 0.
               if not (batchrun or {gpiswrap.i}) then pause.
            undo rollback, return.

         end.

         /* CONVERT A STRING VARIABLE TO A DATE */
         sod_due_date = date(s-cmdval).
         display sod_due_date with frame d.
      end.  /* rollback */

      l_old_fr_list = sod_fr_list.

      run setUpdateQtyAll.

      /* RMA RECEIPT LINES DO NOT GET ALLOCATIONS. */
      {&SOSOMTLB-P-TAG8}
      set
         sod_loc
        /*tfq  sod_std_cost    when (not available pt_mstr) */
         sod_serial
         sod_qty_all     when (not rma-receipt-line)
         /* BTB DIR-SHIP LINES DO NOT GET ALLOCATIONS IN PBU          */
         /* BTB TRANSHIP WITH EDI LINES DO NOT GET ALLOCATIONS IN PBU */
         and  (not s-btb-so or l_update_qty_all)
         sod_comm_pct[1] when (sod_slspsn[1] <> "")
         sod_acct
         sod_sub
         sod_cc
         sod_project
         sod_dsc_acct    when (new_line or reprice_dtl)
         sod_dsc_sub     when (new_line or reprice_dtl)
         sod_dsc_cc      when (new_line or reprice_dtl)
         sod_dsc_project when (new_line or reprice_dtl)
         sod_confirm     when (sod_confirm = no or new_line)
         sod_req_date
         sod_promise_date when (not po-ack-wait or so_primary)
         sod_due_date    when (not po-ack-wait or not so_primary)
         sod_per_date
         sod_fix_pr
         sod_type        when (sod_qty_inv = 0 and
                               sod_qty_ship = 0 and
                               sod_type = "")
         sod_um_conv     when (sod_btb_type = "01")
         /* RMA RECEIPT LINES DO NOT GET TO CONSUME FORECAST */
         /* NOR DO THEY GET ALLOCATIONS */
         sod_consume     when (not rma-receipt-line)
         sod-detail-all  when (not rma-receipt-line)
         /* DETAIL ALLOCATIONS ARE NOT ALLOWED ON BTB SO LINES */
                         and  (not s-btb-so)
         sod_taxable
         sod_taxc
         sod_fr_list
         sod_order_category
         sodcmmts
      with frame d
      editing:
         if frame-field = "sod_serial" and
            input sod_loc <> global_loc then
            global_loc = input sod_loc.
         readkey.
         apply lastkey.
      end. /* END EDITING */

      /* FOR RMA RECEIPT LINES, BECAUSE WE'RE EXPECTING     */
      /* TO RECEIVE THESE ITEMS INTO THE SPECIFIED SITE     */
      /* LOC, BE SURE IT'S VALID.                           */
      if this-is-rma and not rma-issue-line then do:
         /* SOD_SITE IS SCHEMA-VALIDATED */

         for first si_mstr
               fields(si_auto_loc si_db si_site si_status)
               where si_site = sod_site no-lock:
         end. /* FOR FIRST SI_MSTR */

         if  not can-find(loc_mstr
            where loc_site  = sod_site
            and   loc_loc   = sod_loc)
         then do:
            /* WARN USER OF MISSING LOC IF AUTOLOCATIONS FOR SITE */
            if si_auto_loc then
               run display_msg (input 229, input 2).
               /* LOCATION MASTER DOES NOT EXIST */
            /* IF SITE DOESN'T HAVE AUTOLOCATIONS, GIVE ERROR */
            else do:
               run display_msg (input 229, input 3).
               next-prompt sod_loc with frame d.
               undo, retry.
            end.
         end.     /* if not can-find loc_mstr */
         else do:

            /* ENSURE THIS SITE/LOCATION VALID FOR ISS-RMA */

            for first loc_mstr
                  fields(loc_loc loc_site loc_status)
                  where loc_site = sod_site
                  and loc_loc = sod_loc no-lock:
            end. /* FOR FIRST LOC_MSTR */

            for first ld_det
                  fields(ld_loc ld_lot ld_part ld_ref ld_site
                         ld_status)
                  where ld_site = sod_site
                  and ld_loc  = sod_loc
                  and ld_part = sod_part
                  and ld_lot  = sod_serial
                  and ld_ref  = string(sod_ref) no-lock:
            end. /* FOR FIRST LD_DET */

            if can-find(isd_det where isd_tr_type = "ISS-RMA"
               and isd_status = (if available ld_det then ld_status else
                                 if available loc_mstr then loc_status else
                                 si_status))
            then do:
               /* RESTRICTED TRANSACTION FOR STATUS CODE: */
               {pxmsg.i &MSGNUM=373 &ERRORLEVEL=3
                        &MSGARG1=
                  "if available ld_det then ld_status
                   else
                   if available loc_mstr then loc_status
                   else si_status"}
               if sngl_ln then
               next-prompt sod_loc
               with frame d.
               undo, retry.
            end.
         end.  /* else can-find loc_mstr, do */
      end.  /* if this-is-rma and ... */

      assign
         continue = yes
         warn     = no
         atp-ok = yes
         atp-due-date = ?.

         /* Determine promise date and due date defaulting  */
         if sod_confirm = yes
         and ((not this-is-rma) or rma-issue-line)
         and soc_calc_promise_date = yes
         /* DO FOR RMA ISSUE LINES, NOT RECEIPT LINES */
         and not (s-btb-so = yes and sod_btb_type > "01")
         then do:
            run p-calc-date-defaults (input so_ship,
                                    input sod_site,
                                    input sod_req_date,
                                    input-output sod_promise_date,
                                    input-output sod_due_date).

            display
               sod_promise_date
               sod_due_date
            with frame d.
            pause 0.
         end.  /* sod_confirm = yes...  */

      run checkSiteDB.

      if err-flag = 0 or err-flag = 9 then do:

         /* Validate ATP if necessary */
         if sod_qty_ord - sod_qty_ship > 0
         and not sod_sched
         and ((not this-is-rma) or rma-issue-line)
            /* DO FOR RMA ISSUE LINES, NOT RECEIPT LINES */
         and not (s-btb-so = yes and sod_btb_type > "01")
         then do:
            hide frame d.
            hide frame c.
            hide frame a.

   /* When an APO ATP request was processed with insufficient demand, */
   /* the user may choose to modify the order line to match the APO   */
   /* ATP results.  If the atp-due-date field is populated, this   */
   /* indicates that the user has chosen to override the original     */
   /* input with data returned from APO ATP.                          */
   /* Order line site, date and quantity are modified to the APO ATP  */
   /* site, date and quantity only for:                               */
   /* - multi line order entry or                                     */
   /* - single line order entry when quantity has changed or          */
   /* - site has changed                                              */

            run updateWithApoAtpData.

   /* DETERMINE IF TO USE APO ATP FOR MODULE */
            run setUpForApoAtp.

            if checkAtp then
               run p-check-atp.

            view frame a.
            view frame c.
            view frame d.
            pause 0.

            if checkAtp and useApoAtp then do:
               if keyfunction(lastkey) = "end-error" then do:
                  next-prompt sod_loc with frame d.
                  undo, retry.
               end.

               if not continue then do:
                  next-prompt sod_due_date with frame d.
                  undo, retry.
               end.

               run updateWithApoAtpData.

               /* errorResult 0 - Confirm Order Line             */
               /* errorResult 1 - Change date for order line     */
               /* errorResult 2 - Change quantity for order line */
               /* errorResult 3 - Site changed for order line    */
               /* When date, quantity or site changed,           */
               /* return user to order line.                     */
               if errorResult = "0" then
                  confirmApoAtpOrderLine = yes.
               else if errorResult = "1" then do:
                  display sod_due_date with frame d.
                  next-prompt sod_due_date with frame d.
                  undo, retry.
         end.
               else if errorResult = "2" then do:
                  display sod_qty_ord with frame c.
                  atp-qty-site-changed = true.
               end.
               else if errorResult = "3" then do:
                  display sod_due_date with frame d.
                  atp-qty-site-changed = true.
               end.
            end. /* checkAtp and useApoAtp */
         end. /* Validate ATP if necessary */

      end. /* if err-flag */

      if si_db <> so_db then do:
         {gprun.i ""gpalias3.p"" "(so_db,output err-flag)" }
      end.  /* if si_db <> so_db */

      if warn then do:
         /* QTY AVAILABLE FOR ITEM */
         {pxmsg.i &MSGNUM=237 &ERRORLEVEL=2
                  &MSGARG1=" sod_part + "": "" + string(net_avail) "}
         if not batchrun
         then do:
            /* DO YOU WISH TO CONTINUE? */
            {pxmsg.i &MSGNUM=7734 &ERRORLEVEL=2 &CONFIRM=continue
                     &CONFIRM-TYPE='LOGICAL'}
         end. /* IF NOT BATCHRUN */
         next-prompt sod_qty_all with frame d.
         if not continue then do:
            hide message.
            undo, retry.
         end.
         else hide message.
      end.


      if checkAtp and useApoAtp = no then do:
      /* Change due date if different date returned */
      atp-due-date-changed = no.
      if atp-due-date <> ?
      and atp-due-date <> sod_due_date then
         assign
           atp-due-date-changed = yes
           sod_due_date = atp-due-date.

      if atp-due-date-changed then display sod_due_date with frame d.

      if atp-ok = no then do:
           {pxmsg.i &MSGNUM=4099 &ERRORLEVEL=3 &MSGARG1=sod_due_date}
           /*  ATP Enforcement Error, Qty Ordered not allowed  */
           /*  For  Due Date xxxxxxxx                          */
           next-prompt sod_due_date  with frame d.
           if not batchrun and not {gpiswrap.i} then pause.
           undo, retry.
      end.

      /* RESET PROMISE DATE IF NEEDED */
      /* ONLY RESET IF CALC PROMISE DATE = YES */

      if soc_calc_promise_date = yes
      then do:
         if (sod_due_date <> prev-due-date
         or  sod_confirm <> prev-confirm)
         and (sod_promise_date = ? or atp-due-date-changed = yes)
         and sod_confirm = yes
         and sod_due_date <> ?
         /* DO FOR RMA ISSUE LINES, NOT RECEIPT LINES */
         and ((not this-is-rma) or rma-issue-line)
         /* BYPASS EMT ITEMS */
         and not (s-btb-so = yes and sod_btb_type > "01") then do:
            auto-prom-date = ?.
            run p-calc-prom-or-due-date (input so_ship,
                                         input sod_site,
                                         input-output sod_due_date,
                                         input-output auto-prom-date).

            if auto-prom-date <> ? then
               sod_promise_date = auto-prom-date.
            if auto-prom-date <> ? then
               display sod_promise_date with frame d.

         end.   /* Sod_due_date <> prev_due... */
      end. /* soc_calc_promise_date = yes */
      end. /* checkAtp and useApoAtp = no */

      /* Allow only zero or positive quantity for allocation */
      if sod_qty_all < 0 then do:
         /* Qty allocated  cannot be < 0 */
         run display_msg (input 6230, input 3).
         next-prompt sod_qty_all  with frame d.
         undo, retry.
      end.

      /* Allow allocations only for confirmed lines */
      if sod_qty_all <> 0 and not sod_confirm then do:
         run display_msg (input 688, input 3).
         /* Allocs not allowed for unconfirmed lines */
         next-prompt sod_confirm with frame d.
         undo, retry.
      end.

      /* VALIDATE THE AVAILABILITY OF THE REMOTE DATABASE */
      if sod_confirm and global_db <> "" then do:

         for first si_mstr
               fields(si_auto_loc si_db si_site si_status)
               where si_site = sod_site no-lock:
         end. /* FOR FIRST SI_MSTR */

         if not connected(si_db) then do:
            run display_msg (input 2505, input 3).
            next-prompt sod_confirm with frame d.
            undo, retry.
         end.
      end.

      /* MULTI EMT DO NOT ALLOW DATE CHANGE AT THE SBU */
      if so_secondary and not new_line
         and sod_promise_date <> prev-promise-date
         and (sod_btb_type = "03" or sod_btb_type = "02") then do:
         run display_msg (input 2825, input 3).
         /* NO CHANGE IS ALLOWED ON EMT SO */
         next-prompt sod_promise_date with frame d.
         undo, retry.
      end.

      if so_secondary and not new_line
         and sod_due_date <> prev-due-date
         and (sod_btb_type = "03" or sod_btb_type = "02") then do:
         run display_msg (input 2825, input 3).
         /* NO CHANGE IS ALLOWED ON EMT SO */
         next-prompt sod_due_date with frame d.
         undo, retry.
      end.

      /* VALIDATE FREIGHT LIST */
      if sod_fr_list <> "" then do:

         for first fr_mstr
               fields(fr_curr fr_list fr_site)
               where fr_list = sod_fr_list
               and fr_site = sod_site
               and fr_curr = so_curr no-lock:
         end. /* FOR FIRST FR_MSTR */

         if not available fr_mstr then

         for first fr_mstr
               fields(fr_curr fr_list fr_site)
               where fr_list = sod_fr_list
               and fr_site = sod_site
               and fr_curr = base_curr no-lock:
         end. /* FOR FIRST FR_MSTR */

         if not available fr_mstr then do:
            /* FREIGHT LIST # NOT FOUND FOR SITE # CURRENCY */
            {pxmsg.i &MSGNUM=670 &MSGARG1=sod_fr_list &MSGARG2=sod_site
                     &MSGARG3=so_curr}
            next-prompt sod_fr_list with frame d.
            undo, retry.
         end.
      end.     /* if sod_fr_list <> "" */

      if sod_fr_list <> l_old_fr_list
      then
         sod_manual_fr_list = yes.

      /* INITIALIZE SETTINGS */
      {gprunp.i "gpglvpl" "p" "initialize"}

      /* ACCT/SUB/CC/PROJ VALIDATION */
      {gprunp.i "gpglvpl" "p" "validate_fullcode"
         "(input  sod_acct,
           input  sod_sub,
           input  sod_cc,
           input  sod_project,
           output valid_acct)"}

      if valid_acct = no then
         next-prompt sod_acct with frame d.
      if valid_acct = no then
         undo, retry.


      /* INITIALIZE SETTINGS */
      {gprunp.i "gpglvpl" "p" "initialize"}

      /* ACCT/SUB/CC/PROJ VALIDATION */
      {gprunp.i "gpglvpl" "p" "validate_fullcode"
         "(input  sod_dsc_acct,
           input  sod_dsc_sub,
           input  sod_dsc_cc,
           input  sod_dsc_project,
           output valid_acct)"}

      if valid_acct = no then
         next-prompt sod_dsc_acct with frame d.
      if valid_acct = no then
         undo, retry.

      if so_curr <> base_curr then do:

         for first ac_mstr
               fields(ac_code ac_curr)
               where ac_code = sod_acct no-lock:
         end. /* FOR FIRST AC_MSTR */

         if available ac_mstr and ac_curr <> so_curr
            and ac_curr <> base_curr then do:
            run display_msg (input 134, input 3).
            /*ACCT CURR MUST EITHER BE TRANS OR BASE CURR*/
            next-prompt sod_acct with frame d.
            undo, retry.
         end.

         for first ac_mstr
               fields(ac_code ac_curr)
               where ac_code = sod_dsc_acct no-lock:
         end. /* FOR FIRST AC_MSTR */

         if available ac_mstr and ac_curr <> so_curr
            and ac_curr <> base_curr then do:
            run display_msg (input 134, input 3).
            /*ACCT CURR MUST EITHER BE TRANS OR BASE CURR*/
            next-prompt sod_dsc_acct with frame d.
            undo, retry.
         end.
      end.

      /* VALIDATE TAXCODE*/
      {gptxcval.i &code=sod_taxc &frame="d"}

      /* VALIDATE sod_order_category AGAINST GENERALIZED CODES */
      l_invalid_category = no.
      if sod_order_category <> "" then
         run ValidateCategory
            (input sod_order_category,
             output l_invalid_category).
      if l_invalid_category then
         /* VALUE MUST EXIST IN GENERALIZED CODES */
            run display_msg (input 716,
                             input 3).
      if l_invalid_category then next-prompt sod_order_category with frame d.
      if l_invalid_category then undo, retry.


      /* FOLLOWING TESTS NOT NEEDED FOR RMA RECEIPT LINES BECAUSE */
      /* ALLOCATIONS ON THEM WILL ALWAYS BE ZERO.                 */
      /* VALIDATE IF QTY ORD > 0 */
      if sod_qty_ord >= 0 and
         sod_qty_ord < sod_qty_all + sod_qty_pick + sod_qty_ship
         and not sod_sched
         and not rma-receipt-line
         /* ALLOCATIONS ON BTB SO LINES ARE ZERO */
         and not s-btb-so
      then do:
         repeat:
            run display_msg (input 4999, input 3).
            /* Ord qty cannot be < alloc+pick+ship */
            update sod_qty_all with frame d.
            continue = yes.
            warn = no.

            for first si_mstr
                  fields(si_auto_loc si_db si_site si_status)
                  where si_site = sod_site no-lock:
            end. /* FOR FIRST SI_MSTR */

            run allocationCheck.

            if warn then do:
               /* QTY AVAILABLE FOR ITEM */
               {pxmsg.i &MSGNUM=237 &ERRORLEVEL=2
                        &MSGARG1=" sod_part + "": "" + string(net_avail) "}
               if not batchrun
               then do:
                  /* DO YOU WISH TO CONTINUE? */
                  {pxmsg.i &MSGNUM=7734 &ERRORLEVEL=2 &CONFIRM=continue
                           &CONFIRM-TYPE='LOGICAL'}
               end. /* IF NOT BATCHRUN */
               if not continue then
                  undo, retry.
            end.    /* if warn */

            if sod_qty_all < 0 then do:
               run display_msg (input 6230, input 3).
               /* Qty allocated  cannot be < 0 */
               next-prompt sod_qty_all  with frame d.
               undo, retry.
            end.
            if sod_qty_ord >= sod_qty_all +
               sod_qty_pick + sod_qty_ship
               then leave.
         end.    /* repeat */
         if keyfunction(lastkey) = "end-error" then undo, retry.
      end.   /* if sod_qty_ord >= 0 ... */

      /* FOLLOWING TESTS NOT NEEDED FOR RMA RECEIPT LINES BECAUSE */
      /* ALLOCATIONS ON THEM WILL ALWAYS BE ZERO.                 */
      /* VALIDATE IF QTY ORD < 0                                  */

      if sod_qty_ord < 0
         and not sod_sched
         and not rma-receipt-line
      then do:
         repeat on error undo, retry:

            if (sod_qty_all<> 0 or sod_qty_ship > 0 or
               sod_qty_pick > 0)
            then do:
               /* ORD QTY CANNOT BE < ALLOC+PICK+SHIP */
               run display_msg (input 4999, input 3).
               update sod_qty_all with frame d.
            end.
            else leave.

         end. /* END OF REPEAT ON ERROR, UNDO RETRY */
         if keyfunction(lastkey) = "end-error" then undo, retry.
      end. /* END OF IF sod_qty_ord < 0  */

      /* Update commission percentages if there are multiple salespersons. */
      if mult_slspsn and sngl_ln then
      set_comm:
      do on error undo, retry on endkey undo, leave seta:
         form
            sod_slspsn[1]     colon 15 label {&sosomtlb_p_5}
            sod_comm_pct[1]   colon 26 no-label
            sort[1]           colon 35 no-label
            sod_slspsn[2]     colon 15 label {&sosomtlb_p_4}
            sod_comm_pct[2]   colon 26 no-label
            sort[2]           colon 35 no-label
            sod_slspsn[3]     colon 15 label {&sosomtlb_p_3}
            sod_comm_pct[3]   colon 26 no-label
            sort[3]           colon 35 no-label
            sod_slspsn[4]     colon 15 label {&sosomtlb_p_2}
            sod_comm_pct[4]   colon 26 no-label
            sort[4]           colon 35 no-label
         with frame set_comm overlay side-labels
            centered row 16 width 66.

         run setSort.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame set_comm:handle).
         display
            sod_slspsn
            sod_comm_pct
            sort
         with frame set_comm.
         update sod_comm_pct with frame set_comm.
         hide frame set_comm no-pause.
      end.

      /* FREIGHT WEIGHTS */
      if sod_fr_list <> "" then do:
         set_wt:
         do on error undo, retry:
            freight_ok = yes.
            if sngl_ln and (calc_fr or disp_fr) then do:
               detqty = sod_qty_ord - sod_qty_ship.

               /* ASSIGN so_fr_terms WITH THE FREIGHT TERMS FROM */
               /* THE BEST PRICING ROUTINE TO PREVENT ANY ERROR  */
               /* OR WARNING MESSAGES FROM BEING DISPLAYED AT    */
               /* THE LINE LEVEL                                 */

               if current_fr_terms <> ""
                  and so_manual_fr_terms = no
               then
                  so_fr_terms = current_fr_terms.

               if old_ft_type = "5"
               then do:
                  for first l_fr_table
                      where l_fr_sonbr  = sod_nbr
                        and l_fr_soline = sod_line
                      no-lock:
                  end. /* FOR FIRST l_fr_table */
                  if not available l_fr_table
                  then do:
                     create l_fr_table.
                        assign
                           l_fr_sonbr   = sod_nbr
                           l_fr_soline  = sod_line
                           l_fr_chrg    = 0
                           l_sodlist_pr = (if reprice_dtl
                                           then sod_list_pr
                                           else 0).
                  end. /* IF NOT AVAILABLE l_fr_table */

                  l_fr_chrg = (if new_line
                               then 0
                               else sod_fr_chg).
               end. /* IF old_ft_type = "5" */

               /* IF IT IS A VALID DATE, USE THE DUE DATE.  OTHERWISE, USE */
               /* THE CURRENT DATE.                                        */
               /* ADDED SECOND EXCHANGE RATE BELOW                         */
               /* ADDED INPUT PARAMETERS sod_nbr, sod_line AND sod_sob_std */
             /*tfq   {gprun.i ""gpfrlwt.p""
                  "(input so_curr,
                    input so_ex_rate,
                    input so_ex_rate2,
                    input so_fr_min_wt, input so_fr_terms,
                    input so_ship,
                    if sod_due_date <> ?
                    then sod_due_date
                    else today,
                    input sod_fr_list, input sod_part,
                    input detqty, input sod_site,
                    input sod_type, input sod_um,
                    input calc_fr,
                    input disp_fr,
                    input sod_nbr,
                    input sod_line,
                    input sod_sob_std,
                    input-output sod_fr_wt,
                    input-output sod_fr_wt_um,
                    input-output sod_fr_class,
                    input-output sod_fr_chg,
                    input-output freight_ok)"}
            end.    /* if sngl_ln and... */ */
             /*tfq*/   {gprun.i ""yygpfrlwt.p""
                  "(input so_curr,
                    input so_ex_rate,
                    input so_ex_rate2,
                    input so_fr_min_wt, input so_fr_terms,
                    input so_ship,
                    if sod_due_date <> ?
                    then sod_due_date
                    else today,
                    input sod_fr_list, input sod_part,
                    input detqty, input sod_site,
                    input sod_type, input sod_um,
                    input calc_fr,
                    input disp_fr,
                    input sod_nbr,
                    input sod_line,
                    input sod_sob_std,
                    input-output sod_fr_wt,
                    input-output sod_fr_wt_um,
                    input-output sod_fr_class,
                    input-output sod_fr_chg,
                    input-output freight_ok)"}
            end.    /* if sngl_ln and... */ 
            
            if not freight_ok then
            do:
               /* FREIGHT ERROR DETECTED - CHARGES MAY BE INCOMPLETE */
               run display_msg (input 669, input 2).
               if not {gpiswrap.i} then
               pause.
               undo set_wt, leave set_wt.
            end.
         end.
      end.    /* if sod_fr_lst <> "" */

      run determineQuantityAllocated.

      {&SOSOMTLB-P-TAG10}
      if (sod-detail-all or sod_qty_ord entered
         and totallqty <> 0 )
         and (sod_qty_all > 0
         or (sod_qty_all = 0 and input frame bi sod_qty_all > 0))
         and sod_type = "" then
         /* DO DETAIL ALLOCATIONS */
         run doDetailAllocations.
      {&SOSOMTLB-P-TAG11}

      if sod_qty_all < totallqty
         and not l_update_qty_all
      then
         sod_qty_all = totallqty.
      {&SOSOMTLB-P-TAG9}

      /* GET TAX MANAGEMENT DATA */
      {gprun.i ""sosomtlc.p"" "(input this-is-rma)"}
      if not l_loop_seta then leave seta.

   end.    /* if sngl_ln */
   else do: /* multi line */

      {gptxcval.i &code=sod_taxc  &frame="NO-FRAME"}
      /* Validate accounts and cost centers as they don't get validated */
      /* In multi line format */

      /* INITIALIZE SETTINGS */
      {gprunp.i "gpglvpl" "p" "initialize"}

      /* ACCT/SUB/CC/PROJ VALIDATION */
      {gprunp.i "gpglvpl" "p" "validate_fullcode"
         "(input  sod_acct,
           input  sod_sub,
           input  sod_cc,
           input  sod_project,
           output glvalid)"}
      if glvalid = no then  undo seta , leave.

      /* INITIALIZE SETTINGS */
      {gprunp.i "gpglvpl" "p" "initialize"}

      /* ACCT/SUB/CC/PROJ VALIDATION */
      {gprunp.i "gpglvpl" "p" "validate_fullcode"
         "(input  sod_dsc_acct,
           input  sod_dsc_sub,
           input  sod_dsc_cc,
           input  sod_dsc_project,
           output glvalid)"}
      if glvalid = no then  undo seta , leave.

      if so_curr <> base_curr then do:

         for first ac_mstr
               fields(ac_code ac_curr)
               where ac_code = sod_acct no-lock:
         end. /* FOR FIRST AC_CODE */

         if available ac_mstr and ac_curr <> so_curr
         and ac_curr <> base_curr then do:
            run display_msg (input 134, input 3).
            /*ACCT CURR MUST EITHER BE TRANS OR BASE CURR*/
            undo seta, leave.
         end.

         for first ac_mstr
               fields(ac_code ac_curr)
               where ac_code = sod_dsc_acct
               no-lock:
         end. /* FOR FIRST AC_MSTR */

         if available ac_mstr and ac_curr <> so_curr
            and ac_curr <> base_curr then do:
            run display_msg (input 134, input 3).
            /*ACCT CURR MUST EITHER BE TRANS OR BASE CURR*/
            undo seta, leave.
         end.
      end.    /* if so_curr <> base_curr */

      /* VALIDATE IF QTY ORD > 0 */

      if ((sod_qty_ord >= 0 and sod_qty_ord < sod_qty_all
         + sod_qty_pick + sod_qty_ship)
         or (sod_qty_ord < 0 and
         (sod_qty_all <>0 or sod_qty_pick >0 or sod_qty_ship > 0))
         and not sod_sched)
      then do:
          run display_msg (input 4999, input 3).
         /* Ord qty cannot be < alloc+pick+ship */
         undo seta, leave.
      end.
   end. /* multi line */

   /* DISPLAY CONSIGNMENT FRAMES */
   if using_cust_consignment and this-is-so then do:
      proc_id = "popup-update".
      {gprunmo.i
         &program=""socnsod.p""
         &module="ACN"
         &param="""(input proc_id,
           input sod_nbr,
           input string(sod_line),
           input sod_part,
           input so_ship,
           input sod_site,
           input no)"""}
   end. /* IF using_cust_consignment */

   if using_container_charges and this-is-so then do:
      setcontainer:
         /* Prompt for rest of the line information on single line screen */
      do on error undo, retry on endkey undo, leave setcontainer:
         display
            sod_pkg_code
            sod_ord_mult
            sod_charge_type
            sod_alt_pkg
         with frame cont_pop.

         assign
            v_charge_type = ""
            last-field = ""
            old_pkg_code = sod_pkg_code
            old_charge_type = sod_charge_type.

         set
            sod_pkg_code
            sod_ord_mult
            sod_charge_type
            sod_alt_pkg
         with frame cont_pop editblk: editing:
            if frame-field <> "" then last-field = frame-field.
            readkey.
            apply lastkey.
            hide message.
            if (go-pending or (last-field <> frame-field))
               then do:
               if go-pending then do:
                  if last-field = "sod_pkg_code" and
                     frame-field = "sod_pkg_code" then do:

                     if input sod_pkg_code = "" then
                        sod_charge_type = "".
                     else
                        if old_pkg_code <> input sod_pkg_code
                        then do:

                           run validate_container
                                        (input (input sod_pkg_code),
                                         output chargeable,
                                         output v_charge_type,
                                         output msgnbr).

                           if msgnbr > 0 then do:
                              run display_msg (input msgnbr,
                                               input 4).
                              /* ITEM HAS NOT BEEN DEFINED AS A CONTAINER */
                              next-prompt sod_pkg_code with frame cont_pop.
                              next editblk.
                           end. /*IF MSGNBR > 0*/

                           if chargeable then
                              run get_charge_type
                                            (input (input sod_pkg_code),
                                             input (if sod_dock > "" then
                                                    sod_dock else
                                                    if sod_ship > "" then
                                                    sod_ship else so_ship),
                                             input so_curr,
                                             input-output v_charge_type).
                           display v_charge_type @ sod_charge_type
                              with frame cont_pop.
                     end. /* else if old_pkg_code */
                  end. /*IF LAST-FIELD = "SOD_PKG_CODE"*/

                  else if last-field = "sod_charge_type" and
                     frame-field = "sod_charge_type" and
                     old_charge_type <> input sod_charge_type
                     and input sod_charge_type > ""
                     then do:
                        run validate_charge_type
                                    (input (input sod_charge_type),
                                     input yes,
                                     output msgnbr).

                        if msgnbr > 0 then do:
                           run display_msg (input msgnbr,
                                            input 4).
                            /* NOT A VALID CHARGE TYPE */
                           next-prompt sod_charge_type
                           with frame cont_pop.
                           next editblk.
                        end.
                  end. /*ELSE IF*/
               end. /* IF go-pending then do*/
               else
                  if last-field = "sod_pkg_code" and
                  frame-field <> "sod_pkg_code" and
                  input sod_pkg_code > "" and
                  input sod_pkg_code <> old_pkg_code
                  then do:

                  run validate_container (input (input sod_pkg_code),
                                          output chargeable,
                                          output v_charge_type,
                                          output msgnbr).

                  if msgnbr > 0 then do:
                     run display_msg (input msgnbr,
                                      input 4).
                    /* ITEM HAS NOT BEEN DEFINED AS A CONTAINER */
                     next-prompt sod_pkg_code with frame cont_pop.
                     next editblk.
                  end. /*IF MSGNBR > 0*/

                  if chargeable then
                     run get_charge_type (input (input sod_pkg_code),
                                          input (if sod_dock > "" then
                                                    sod_dock else
                                                 if sod_ship > "" then
                                                    sod_ship else so_ship),
                                          input so_curr,
                                          input-output v_charge_type).
                  display v_charge_type @ sod_charge_type
                     with frame cont_pop.
                  old_pkg_code = input sod_pkg_code.

               end. /*if last-field = "sod_pkg_code"*/

               else
                  if last-field = "sod_charge_type" and
                  frame-field <> "sod_charge_type" and
                  input sod_charge_type > "" and
                  input sod_charge_type <> old_charge_type
                  then do:
                  run validate_charge_type
                                    (input (input sod_charge_type),
                                     input yes,
                                     output msgnbr).

                  if msgnbr > 0 then do:
                     run display_msg (input msgnbr,
                                      input 4).
                     /* NOT A VALID CHARGE TYPE */
                     next-prompt sod_charge_type
                     with frame cont_pop.
                     next editblk.
                  end.
                  old_charge_type = input sod_charge_type.
               end.  /*if last-field = "sod_charge_type" */
            end. /*go-pending or (last-field <> frame-field))*/
         end. /*EDITBLK*/

         hide frame cont_pop no-pause.

         if sod_alt_pkg then do:
            {rcsomtac.i}
         end.
      end. /*Setcontainer*/
   end. /* IF USING_CONT_CHARGES */

   if using_line_charges and this-is-so then
      run UpdateLineCharges
         (input recid(so_mstr),
          input recid(sod_det)).


   /* FOR RMA'S, UPDATE RMD_DET SPECIFIC DATA ELEMENTS.  */
   /* IF THIS ISN'T SINGLE-LINE MODE, FSRMALIN.P WILL    */
   /* NOT GIVE THE USER A POPUP WINDOW...                */
   if this-is-rma then do:
      {gprun.i ""fsrmalin.p""
         "(input rma-issue-line,
           input new_line,
           input rma-recno,
           input rmd-recno,
           input sod_recno,
           input tax_in,
           input so_db)"}
   end.

   /* SECONDARY SO */
   /* VALIDATE MODIFICATION OF SOD_DUE_DATE                   */

   if so_secondary and not new_line
      and sod_promise_date <> prev-promise-date then do:

      /* TRANSMIT CHANGES ON SECONDARY SO TO PRIMARY PO AND SO */
      {gprun.i ""sosobtb2.p""
         "(input recid(sod_det),
           input ""sod_promise_date"",
           input string(prev-promise-date) ,
           output return-msg)"}

      /* DISPLAY ERROR MESSAGE RETURN FROM SOSOBTB2.P */
      if return-msg <> 0 then do:
         run display_msg (input return-msg, input 3).
         if not (batchrun or {gpiswrap.i}) then pause.
         undo seta, retry seta.
      end.

   end. /* not so_primary and change of sod_due_date */

   /* PRIMARY SO */
   /* CALCULATE DUE DATE WHEN CHANGING SOD_REQ_DATE OR AT CREATION */
   if    s-btb-so and not so_secondary
      and (new_line or sod_due_date <> prev-due-date)
      and soc_due_calc
   then do:

      {gprun.i ""sodueclc.p""
         "(input sod_due_date,
           input sod_part,
           input so_cust,
           input sod_btb_type,
           input sod_site,
           output s-sec-due,
           output pri-due,
           output exp-del,
           input yes)" }

      assign
         sod_promise_date = exp-del when (sod_promise_date = ?)
         sod_exp_del      = exp-del
         sod_due_date     = pri-due.

   end. /* due date calculation */

   /* Delete allocations if the ship_type is not blank */
   if sod_type <> ""
      and (prev_type <> sod_type)
      and not new sod_det
   then do:
      {gprun.i ""gpalias3.p"" "( si_db, output err-flag)" }
      if err-flag = 0 or err-flag = 9 then do:

         /* ADDITIONAL PARAMETERS prev_qty_all old_sod_site       */
         /* l_prev_um_conv PASSED TO SOLADDEL.P SO THAT INVENTORY */
         /* WILL BE CORRECTLY DE-ALLOCATED WHEN THE SHIP TYPE IS  */
         /* CHANGED TO "M" ON EXISTING SALES ORDERS.              */

         {gprun.i ""soladdel.p""
            "(input sod_nbr,
              input sod_line,
              input prev_qty_all,
              input old_sod_site,
              input l_prev_um_conv,
              input l_sodqtyord)"}

      end.
      {gprun.i ""gpalias3.p"" "(so_db, output err-flag)"}
   end.
   {&SOSOMTLB-P-TAG3}
   undo_all2 = false.
end. /* seta: set up for update block */

hide frame set_comm no-pause.

hide frame cont_pop no-pause.

PROCEDURE display_msg:
   define input parameter ip_msg_nbr as integer no-undo.
   define input parameter ip_error_level as integer no-undo.

   {pxmsg.i &MSGNUM = ip_msg_nbr &ERRORLEVEL = ip_error_level}

END PROCEDURE. /*DISPLAY_MSG*/

PROCEDURE validate_container:
   define input parameter ip_container like ptc_part no-undo.
   define output parameter op_chargeable like mfc_logical no-undo.
   define output parameter op_charge_type like cct_charge_type no-undo.
   define output parameter op_msg_nbr as integer no-undo.

   assign
      op_chargeable = false
      op_charge_type = ""
      op_msg_nbr = 4447. /* ITEM HAS NOT BEEN DEFINED AS A CONTAINER*/

   for first ptc_det
      fields(ptc_part ptc_charge ptc_charge_type)
      no-lock where
         ptc_part = ip_container:
      assign
         op_chargeable = ptc_charge
         op_msg_nbr = 0.
      if ptc_charge then op_charge_type = ptc_charge_type.
   end.

END PROCEDURE. /* VALIDATE_CONTAINER*/

PROCEDURE get_charge_type:
   define input parameter ip_container like ptc_part no-undo.
   define input parameter ip_shipto like so_ship no-undo.
   define input parameter ip_curr like so_curr no-undo.
   define input-output parameter io_charge_type like cct_charge_type.

   for first cclsc_mstr
      fields(cclsc_shipto cclsc_part
             cclsc_curr cclsc_charge_type)
      no-lock where
         cclsc_shipto = ip_shipto
      and cclsc_part = ip_container
      and cclsc_curr = ip_curr:
   end.
   if not available cclsc_mstr then
     for first cclsc_mstr
        fields(cclsc_shipto cclsc_part
               cclsc_curr cclsc_charge_type)
        no-lock where
        cclsc_shipto = ""
        and cclsc_part = ip_container
        and cclsc_curr = ip_curr:
   end.
   if available cclsc_mstr then
      io_charge_type = cclsc_charge_type.

END PROCEDURE. /*GET_CHARGE_TYPE*/

PROCEDURE validate_charge_type:
   define input parameter ip_container like ptc_part no-undo.
   define input parameter ip_container_type like mfc_logical no-undo.
   define output parameter op_msg_nbr as integer no-undo.

   op_msg_nbr = 4396. /* NOT A VALID CHARGE TYPE */

   for first cct_mstr
      fields(cct_charge_type cct_container_type)
      no-lock where
         cct_charge_type = ip_container
      and cct_container_type = ip_container_type:
      op_msg_nbr = 0.
   end.

END PROCEDURE. /*VALIDATE_CHARGE_TYPE*/

/* Calculate promise and/or due date via transit time table */
PROCEDURE p-calc-prom-or-due-date:

   define input parameter p-cust like cm_addr     no-undo.
   define input parameter p-site like pt_site     no-undo.
   define input-output parameter p-due-date
                           like sod_due_date      no-undo.
   define input-output parameter p-promise-date
                           like sod_promise_date  no-undo.

   /* attempt to calculate promise date now... */
   /* retrieve address record of ship-to customer */
   for first ad_mstr
      fields (ad_addr
              ad_ctry
              ad_state
              ad_city)
   where ad_addr = p-cust :

      for first si_mstr
         fields(si_site si_db)
      where si_site = p-site
      no-lock:
         /* Switch to the Inventory site */
         {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }

         {gprun.i ""sopromdt.p""
                  "(input p-site,
                    input ad_ctry,
                    input ad_state,
                    input ad_city,
                    input """",
                    input-output p-due-date,
                    input-output p-promise-date)" }

         /* Switch back to the sales order site */
         {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }

      end. /* FOR FIRST si_mstr */
   end. /* for first ad_mstr */

END PROCEDURE.   /* p-calc-prom-or-due-date */

/*  Calculate promise and due date defaults  */
PROCEDURE p-calc-date-defaults:

   define input parameter p-cust like cm_addr     no-undo.
   define input parameter p-site like pt_site     no-undo.
   define input parameter p-required-date
                          like sod_req_date  no-undo.
   define input-output parameter p-promise-date
                           like sod_promise_date  no-undo.
   define input-output parameter p-due-date
                           like sod_due_date      no-undo.

   /* If promise <> ? and due <> ? the no defaulting */
   if p-due-date <> ? and p-promise-date <> ? then leave.

   /* If promise = ? and due <> ? then               */
   /*  calc promise date from due date now...        */
   if p-promise-date = ? and p-due-date <> ? then do:
      run p-calc-prom-or-due-date (input p-cust,
                                   input p-site,
                                   input-output p-due-date,
                                   input-output p-promise-date).
      leave.
   end. /* calculate promise date... */

   /* If promise = <> ? and due = ? then               */
   /*  calc due date from promise date now...          */
   if p-promise-date <> ? and p-due-date = ? then do:
      run p-calc-prom-or-due-date (input p-cust,
                                   input p-site,
                                   input-output p-due-date,
                                   input-output p-promise-date).
      leave.
   end. /* calculate due date... */

   /* If promise = ? and due = ?              */
   if p-promise-date = ? and p-due-date = ? then do:
      /* if new order and.. */
      if new_line = yes then do:
         /* if required date present,  then... */
         if p-required-date <> ? then do:
            /* 1. Default Promise date from Required date */
            p-promise-date = p-required-date.

            /* 2. Attempt to calculate due date from promise date now */
            run p-calc-prom-or-due-date (input p-cust,
                                         input p-site,
                                         input-output p-due-date,
                                         input-output p-promise-date).
            /* 3. if due not calculated, default to required date */
            if p-due-date = ? then p-due-date = p-required-date.
            leave.
         end. /* p-required-date <> ? */

         else do:  /* p-required-date = ? */
            /* 1. due date = today + shipping lead time        */
            p-due-date = today + soc_ctrl.soc_shp_lead.
            /* 2. calc promise date from due date now...        */
            run p-calc-prom-or-due-date (input p-cust,
                                         input p-site,
                                         input-output p-due-date,
                                         input-output p-promise-date).
            leave.
         end. /* p-required-date = ? */
      end. /* if new_line = yes */
      /* Note: if new_line = no, and ATP is on, use best avail */
      /* due date, but this is done later in the code...       */
   end.  /* promise and due = ? */
END PROCEDURE.   /* p-calc-date-defaults */


PROCEDURE createRemoteLines:
   /* WE DON'T CREATE THE REMOTE LINES UNLESS THE LINE IS CONFIRMED */
   if si_mstr.si_db <> so_db and sod_det.sod_confirm then do:
      {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }
      if err-flag = 0 or err-flag = 9 then do:

         /* ADDED INPUT PARAMETER no TO NOT EXECUTE MFSOFC01.I   */
         /* AND MFSOFC02.I WHEN CALLED FROM DETAIL LINE          */
         {gprun.i ""solndel.p""
            "(input no)"}
      end.
      /* Reset the db alias to the sales order database */
      {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }
      sod_recno = recid(sod_det).
   end.
   else do:
      {gprun.i ""solndel1.p""}
   end.
END PROCEDURE.   /* createRemoteLines */


PROCEDURE determineQuantityAllocated:
   /* Determine total quantity allocated */
   {gprun.i ""gpalias3.p"" "(si_mstr.si_db, output err-flag)" }
   if err-flag = 0 or err-flag = 9 then do:
      {gprun.i ""soladqty.p"" "(sod_det.sod_nbr, sod_line,
                                sod_um_conv, output totallqty )"}
   end.
   {gprun.i ""gpalias3.p"" "(so_db, output err-flag)"}

END PROCEDURE.   /* determineQuantityAllocated */

PROCEDURE doDetailAllocations:
   {gprun.i ""gpalias3.p"" "(si_mstr.si_db, output err-flag)" }
   if err-flag = 0 or err-flag = 9 then do:
      {gprun.i ""solcal1.p"" "( input sod_det.sod_site, input sod_nbr,
                                input sod_line , input sod_part,
                                input sod_um_conv , input sod_loc,
                                input sod_serial, input sod_qty_ord ,
                                input sod_qty_all, input sod_qty_pick,
                                input sod_qty_ship, input sod_due_date,
                                input-output totallqty )"}
   end.
   {gprun.i ""gpalias3.p"" "(so_db, output err-flag)"}

end procedure.  /*  doDetailAllocations */

PROCEDURE allocationCheck:
   if si_mstr.si_db <> so_db then do:
      {gprun.i ""gpalias2.p"" "(sod_det.sod_site,output err-flag)" }
   end.

   if err-flag = 0 or err-flag = 9 then do:
      if soc_ctrl.soc_all_avl and sod_qty_all > 0
         and sod_type = ""
      then do:
         assign new_record = new sod_det.

         {gprun.i ""soallchk.p""
            "(sod_part,
              sod_site,
              prev_qty_all * l_prev_um_conv,
              sod_qty_all * sod_um_conv,
              new_record,
              so_mstr.so_ship,
              so_bill,
              so_cust,
              so_fsm_type,
              output warn,
              output net_avail)" }

      end. /* if soc_all_avl */
   end. /* if err-flag */

   if si_db <> so_db then do:
      {gprun.i ""gpalias3.p"" "(so_db,output err-flag)" }
   end.  /* if si_db <> so_db */
END PROCEDURE. /* allocationCheck */

PROCEDURE ValidateCategory:
   define input parameter ip_category like sod_order_category no-undo.
   define output parameter op_error like mfc_logical no-undo.

   if not ({gpcode.v ip_category "line_category"})
   then op_error = yes.
   else op_error = no.
END PROCEDURE. /* ValidateCategory */

PROCEDURE UpdateLineCharges:
   define input parameter ip_sorecid as recid no-undo.
   define input parameter ip_sodrecid as recid no-undo.

   {gprunmo.i
      &module = "ACL"
      &program = ""rcsolcmt.p""
      &param = """(input ip_sorecid,
                   input ip_sodrecid)"""}

END PROCEDURE.

PROCEDURE createCodeMstr:
      create code_mstr.
      assign
         code_fldname = "tr_type"
         code_value   = "ISS-RMA".
         code_cmmt    = getTermLabel("PSEUDO_TRANS-TYPE_FOR_RMA_RECEIPT",40).
      if recid(code_mstr) = -1 then .

END PROCEDURE.

PROCEDURE siteChanged:

   /* ON SITE CHANGE IF THE ITEM IN NEW SITE IS NOT CONFIGURED THEN */
   /* DELETE SALES ORDER BILL RECORDS (sob_det), ALLOCATION DETAIL  */
   /* RECORDS (lad_det), COST RECORDS (sct_det); UPDATES FORECAST   */
   /* AND MRP DETAIL (mrp_det) AND UPDATES INVENTORY DETAIL BY      */
   /* LOCATION (ld_det) FOR PREVIOUS SITE                           */

   if sod_det.sod_site <> old_site
      and new_line = no
      and ((can-find (first pt_mstr
                      where pt_part    =  sod_det.sod_part
                      and   pt_pm_code <> "c")
           or can-find (first ptp_det
                        where ptp_part    =  sod_det.sod_part
                        and   ptp_site    =  old_site
                        and   ptp_pm_code <> "c"))
                        and (can-find (first ptp_det
                                       where ptp_part    =  sod_det.sod_part
                                       and   ptp_site    =  sod_det.sod_site
                                       and   ptp_pm_code <> "c" )))
      then do:

         for first si_mstr
               fields(si_auto_loc si_db si_site si_status)
               where si_site = old_site no-lock:
         end. /* FOR FIRST SI_MSTR */

         assign
            sonbr  = sod_nbr
            soline = sod_line .

         run createRemoteLines.
      end.
END PROCEDURE.

PROCEDURE setSort:
      sort = "".
      do counter = 1 to 4:

         for first sp_mstr
               fields(sp_addr sp_sort)
               where sp_addr = sod_det.sod_slspsn[counter]
               no-lock:
         end. /* FOR FIRST SP_MSTR */

         if available sp_mstr then
            sort[counter] = sp_sort.
      end.
END PROCEDURE.

PROCEDURE setUpdateQtyAll:
      for first po_mstr
         fields(po_inv_mthd)
         where po_nbr = sod_det.sod_btb_po
         no-lock:
      end. /* FOR FIRST po_mstr */
      if available po_mstr
         and (right-trim(substring(po_inv_mthd,2,24)) = "")
      then
         l_use_edi = no.
      if (sod_btb_type = "02"
         and sod_qty_all > 0
         and not l_use_edi)
      then
         l_update_qty_all = yes.
END PROCEDURE.

PROCEDURE checkSiteDB:

      for first si_mstr
            fields(si_auto_loc si_db si_site si_status)
            where si_site = sod_det.sod_site no-lock:
      end. /* FOR FIRST SI_MSTR */

      if si_db <> so_db then do:
         {gprun.i ""gpalias2.p"" "(sod_site,output err-flag)" }
      end.

      if err-flag = 0 or err-flag = 9 then do:
         if soc_ctrl.soc_all_avl and sod_qty_all > 0
            and sod_type = ""
         then do:
            assign new_record = new sod_det.

            /* CONVERTED THIRD PARAMETER PREV_QTY_ALL AND FOURTH */
            /* PARAMETER SOD_QTY_ALL TO INVENTORY UM             */
            {gprun.i ""soallchk.p""
               "(sod_part,
                 sod_site,
                 prev_qty_all * l_prev_um_conv,
                 sod_qty_all * sod_um_conv,
                 new_record,
                 so_mstr.so_ship,
                 so_bill,
                 so_cust,
                 so_fsm_type,
                 output warn,
                 output net_avail)" }

            {&SOSOMTLB-P-TAG2}
         end. /* if soc_all_avl */
      end. /* if err-flag = 0 or err-flag = 9 */

END PROCEDURE.

PROCEDURE setUpForApoAtp:
/* ---------------------------------------------------------------------------
Purpose:       This procedure determines APO ATP should be used.
               If it is in use then open io stream used for APO ATP.
Exceptions:    None
Conditions:
Pre:
Post:
Notes:
History:
----------------------------------------------------------------------------*/

   if this-is-rma then moduleGroup = "RMA".
   else moduleGroup = "SO".

   /* Get Apo Atp setup only if standard Atp was not used. */
   /* If standard Atp is used and the setup is run,       */
   /* useApoAtp will be set incorrectly.                  */
   if stdAtpUsed = no then do:
   /* Determine if Apo Atp is in Use */
      {pxrun.i &proc='getApoAtpSetup' &program='sosoxr1.p'
            &handle=ph_sosoxr1
            &param="(input sod_det.sod_site,
                     input sod_part,
                     input sod_confirm,
                     input sod_type,
                     input sod_btb_type,
                     input sod_due_date,
                     input sod_qty_ord,
                     input sod_um_conv,
                     input moduleGroup,
                     input new_line,
                     input prev-confirm,
                     output checkAtp,
                     output useApoAtp,
                     output apoAtpDelAvail,
                     output apoAtpDelAvailMsg)"}
   end.

   if checkAtp and useApoAtp then do:
   /* After a new order line has been entered or an existing line      */
   /* is modified where the confirm flag is changed from no to yes     */
   /* then initialize Apo Atp values based on order line.              */

      assign atp-site = sod_det.sod_site
         atp-cum-qty = sod_qty_ord
         atp-due-date = sod_due_date.

      if apoAtpDelAvail then do:
      /* A Shared Stream cannot be used with app server logic */
      /* Open the apoAtpStream */
         {pxrun.i &proc='openApoAtpIOStream' &program='giapoxr.p'
                  &handle=ph_giapoxr
                  &catcherror=TRUE
                  &noapperror=TRUE
                  &module='GI1'}
      end.
   end.  /* checkAtp and useApoAtp */

END PROCEDURE. /* setUpForApoAtp */

PROCEDURE p-check-atp:
/* ---------------------------------------------------------------------------
Purpose:       This procedure determines if there are any problems
               with ATP Enforcement for the confirmed order line.
               APO ATP or standard ATP enforcement will be used for
               determining the output.
Exceptions:    None
Conditions:
Pre:
Post:
Notes:
History:
----------------------------------------------------------------------------*/

   {gprun.i ""soatpck.p""
           "(input so_mstr.so_cust,
             input so_ship,
             input so_bill,
             input sod_det.sod_nbr,
             input sod_line,
             input sod_site,
             input sod_part,
             input sod_due_date,
             input sod_um_conv,
             input sod_um,
             input (sod_qty_ord - sod_qty_ship),
             input sod_btb_type,
             input sod_confirm,
             input no,
             input soc_ctrl.soc_atp_enabled,
             input soc_horizon,
             input sod_type,
             input sod_consume,
             input sngl_ln,
             input useApoAtp,
             input moduleGroup,
             input apoAtpDelAvail,
             input apoAtpDelAvailMsg,
             output atp-ok,
             output atp-due-date,
             output atp-cum-qty,
             output atp-site,
             output errorResult,
             output continue,
             output stdAtpUsed)"}

   /* If Standard Atp enforcement was used,  */
   /* No Apo Atp checks should be done.      */
   if stdAtpUsed then useApoAtp = no.

END PROCEDURE. /* p-check-atp  */

PROCEDURE updateWithApoAtpData:
/* ---------------------------------------------------------------------------
Purpose:       This procedure updates site, date and quantity
               returned from apo atp.
               This is for single line processing only.
Exceptions:    None
Conditions:
Pre:
Post:
Notes:
History:

Inputs/Outputs:
None
----------------------------------------------------------------------------*/

   /* When atp-due-date = ?  then      */
   /* no changes were made by APO ATP  */
   if atp-due-date <> ? then do:
      if sod_det.sod_site <> atp-site or
      sod_qty_ord <> atp-cum-qty then
         atp-qty-site-changed.

      /* If Users Selects To Confirm Order Line with Atp Due Date */
      if errorResult = "0" and sod_due_date <> atp-due-date
         then sod_due_date = atp-due-date.

      if (errorResult = "2" or errorResult = "3") then
         assign
            sod_site     = atp-site
            sod_due_date = atp-due-date
            sod_qty_ord  = atp-cum-qty.
      else if errorResult = "1" then
         assign
            sod_site     = atp-site
            sod_due_date = atp-due-date.
   end.

END PROCEDURE. /* updateWithApoAtpData */

