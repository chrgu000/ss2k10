/* GUI CONVERTED from poporcm.p (converter v1.78) Thu Nov 11 05:04:15 2010 */
/* poporcm.p - PURCHASE ORDER RECEIPT W/ SERIAL NUMBER CONTROL                */
/* Copyright 1986-2010 QAD Inc., Santa Barbara, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* REVISION: 7.0      LAST MODIFIED: 11/19/91   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 12/09/91   BY: RAM *F033*                */
/* REVISION: 7.0      LAST MODIFIED: 12/09/91   BY: RAM *F070*                */
/* REVISION: 7.0      LAST MODIFIED: 01/31/92   BY: RAM *F126*                */
/* REVISION: 7.0      LAST MODIFIED: 02/04/92   BY: RAM *F163*                */
/* REVISION: 7.0      LAST MODIFIED: 02/06/92   BY: RAM *F177*                */
/* REVISION: 7.0      LAST MODIFIED: 02/14/92   BY: sas *F153*                */
/* REVISION: 7.0      LAST MODIFIED: 02/24/92   BY: sas *F211*                */
/* REVISION: 7.0      LAST MODIFIED: 03/09/92   BY: RAM *F269*                */
/* REVISION: 7.0      LAST MODIFIED: 03/11/92   BY: pma *F087*                */
/* REVISION: 7.0      LAST MODIFIED: 03/24/92   BY: RAM *F311*                */
/* REVISION: 7.3      LAST MODIFIED: 08/12/92   BY: tjs *G028*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 10/22/92   BY: afs *G116*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 09/23/92   BY: mpp *G481*                */
/* REVISION: 7.3      LAST MODIFIED: 11/03/92   BY: mpp *G263*                */
/* REVISION: 7.3      LAST MODIFIED: 11/10/92   BY: pma *G304*                */
/* REVISION: 7.3      LAST MODIFIED: 12/15/92   BY: tjs *G443*                */
/* REVISION: 7.3      LAST MODIFIED: 12/21/92   BY: tjs *G460*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 01/11/93   BY: bcm *G425*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 02/16/93   BY: tjs *G675*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 02/16/93   BY: tjs *G684*                */
/* REVISION: 7.3      LAST MODIFIED: 02/19/93   BY: sas *G647*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 02/22/93   BY: tjs *G718*                */
/* REVISION: 7.3      LAST MODIFIED: 04/19/93   BY: tjs *G964*                */
/* REVISION: 7.3      LAST MODIFIED: 04/26/93   BY: WUG *GA34*                */
/* REVISION: 7.3      LAST MODIFIED: 05/13/93   BY: kgs *GA90*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 05/21/93   BY: kgs *GB26*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 05/21/93   BY: kgs *GB35*                */
/* REVISION: 7.4      LAST MODIFIED: 06/18/93   BY: jjs *H010*                */
/* REVISION: 7.4      LAST MODIFIED: 07/02/93   BY: dpm *H014*                */
/* REVISION: 7.4      LAST MODIFIED: 07/02/93   BY: jjs *H020*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 07/06/93   BY: jjs *H024*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*                */
/* REVISION: 7.4      LAST MODIFIED: 09/10/93   BY: tjs *H093*                */
/* REVISION: 7.4      LAST MODIFIED: 10/06/93   BY: dpm *H075*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 10/23/93   BY: cdt *H184*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 11/05/93   BY: bcm *H210*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 11/12/93   BY: afs *H219*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 11/14/93   BY: afs *H220*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 11/16/93   BY: afs *H227*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 11/19/93   BY: afs *H236*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 03/28/94   BY: WUG *GI86*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/94   BY: dpm *H074*                */
/* REVISION: 7.4      LAST MODIFIED: 04/20/94   BY: tjs *GI57*                */
/* REVISION: 7.3      LAST MODIFIED: 04/21/94   BY: dpm *FN24*                */
/* REVISION: 7.2      LAST MODIFIED: 08/01/94   BY: dpm *FP66*                */
/* REVISION: 7.3      LAST MODIFIED: 08/10/94   BY: ais *FQ01*                */
/* REVISION: 7.4      LAST MODIFIED: 09/11/94   BY: rmh *GM16*                */
/* REVISION: 7.4      LAST MODIFIED: 09/20/94   BY: ljm *GM74*                */
/* REVISION: 7.4      LAST MODIFIED: 10/11/94   BY: cdt *FS26*                */
/* REVISION: 7.4      LAST MODIFIED: 10/18/94   BY: cdt *FS54*                */
/* REVISION: 7.4      LAST MODIFIED: 10/27/94   BY: cdt *FS95*                */
/* REVISION: 7.4      LAST MODIFIED: 11/08/94   BY: bcm *GO37*                */
/* REVISION: 8.5      LAST MODIFIED: 11/22/94   BY: mwd *J034*                */
/* REVISION: 8.5      LAST MODIFIED: 12/09/94   BY: taf *J038*                */
/* REVISION: 8.5      LAST MODIFIED: 01/05/95   BY: pma *J040*                */
/* REVISION: 7.4      LAST MODIFIED: 01/20/95   BY: smp *F0F5*                */
/* REVISION: 8.5      LAST MODIFIED: 01/30/95   BY: ktn *J041*                */
/* REVISION: 7.4      LAST MODIFIED: 03/10/95   BY: jpm *H0BZ*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: aed *G0JV*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 7.4      LAST MODIFIED: 03/31/95   BY: bcm *G0JN*                */
/* REVISION: 8.5      LAST MODIFIED: 09/20/95   BY: kxn *J07M*                */
/* REVISION: 8.5      LAST MODIFIED: 06/16/95   BY: rmh *J04R*                */
/* REVISION: 7.4      LAST MODIFIED: 10/06/95   BY: vrn *G0XW*                */
/* REVISION: 8.5      LAST MODIFIED: 01/09/96   BY: tjs *J0B1*                */
/* REVISION: 8.5      LAST MODIFIED: 10/09/95   BY: taf *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 02/14/96   BY: rxm *H0JJ*                */
/* REVISION: 8.5      LAST MODIFIED: 02/05/96   BY: *J0CV* Robert Wachowicz   */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: rxm *H0KH*                */
/* REVISION: 8.5      LAST MODIFIED: 07/16/96   BY: rxm *G1SV*                */
/* REVISION: 8.5      LAST MODIFIED: 07/22/96   BY: rxm *H0M3*                */
/* REVISION: 8.6      LAST MODIFIED: 10/18/96   BY: *K003* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 12/06/96   BY: *K030* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 10/15/97   BY: *J22T* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: *J2DD* Kawal Batra        */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 06/26/98   BY: *J2MG* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 07/09/98   BY: *L020* Charles Yen        */
/* REVISION: 8.6E     LAST MODIFIED: 08/04/98   BY: *J2VC* Ajit Deodhar       */
/* REVISION: 8.6E     LAST MODIFIED: 08/19/98   BY: *L062* Steve Nugent       */
/* REVISION: 8.6E     LAST MODIFIED: 09/04/98   BY: *L08R* Steve Goeke        */
/* REVISION: 8.6E     LAST MODIFIED: 09/16/98   BY: *K1WX* Steve Nugent       */
/* REVISION: 8.6E     LAST MODIFIED: 10/26/98   BY: *L0CF* Sami Kureishy      */
/* REVISION: 8.6E     LAST MODIFIED: 11/12/98   BY: *J30M* Seema Varma        */
/* REVISION: 9.0      LAST MODIFIED: 04/16/99   BY: *J2DG* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 05/15/99   BY: *J39K* Sanjeev Assudani   */
/* REVISION: 9.1      LAST MODIFIED: 07/07/99   BY: *N00N* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 09/03/99   BY: *J3L4* Kedar Deherkar     */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Dan Herman         */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Thelma Stronge     */
/* REVISION: 9.1      LAST MODIFIED: 03/20/00   BY: *N08V* Bill Gates         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/18/00   BY: *L0Z4* Abhijeet Thakur    */
/* REVISION: 9.1      LAST MODIFIED: 07/11/00   BY: *N0FS* Arul Victoria      */
/* Revision: 1.40     BY: Satish Chavan          DATE: 06/27/00   ECO: *N0DK* */
/* Revision: 1.41     BY: Mark Brown             DATE: 08/13/00   ECO: *N0KQ* */
/* Revision: 1.42     BY: Nikita Joshi           DATE: 11/07/00   ECO: *L15J* */
/* Revision: 1.43     BY: Ravikumar K            DATE: 12/20/00   ECO: *L16V* */
/* Revision: 1.44     BY: Mudit Mehta            DATE: 09/30/00   ECO: *N0WT* */
/* Revision: 1.45     BY: Rajesh Kini            DATE: 02/27/01   ECO: *M12H* */
/* Revision: 1.46     BY: Katie Hilbert          DATE: 04/01/01   ECO: *P002* */
/* Revision: 1.47     BY: Rajaneesh Sarangi      DATE: 05/08/01   ECO: *M0W6* */
/* Revision: 1.48     BY: Hareesh V              DATE: 08/06/01   ECO: *M1GV* */
/* Revision: 1.52     BY: John Pison             DATE: 03/08/02   ECO: *N1BT* */
/* Revision: 1.53     BY: Ashwini Ghaisas        DATE: 04/26/02   ECO: *M1XB* */
/* Revision: 1.54     BY: Jeff Wootton           DATE: 04/26/02   ECO: *P03G* */
/* Revision: 1.55     BY: Ellen Borden           DATE: 05/24/02   ECO: *P018* */
/* Revision: 1.56     BY: Lena Lim               DATE: 05/30/02   ECO: *P07G* */
/* Revision: 1.58     BY: Jeff Wootton           DATE: 06/03/02   ECO: *P079* */
/* Revision: 1.59     BY: Luke Pokic             DATE: 06/28/02   ECO: *P099* */
/* Revision: 1.61     BY: Tiziana Giustozzi      DATE: 06/20/02   ECO: *P093* */
/* Revision: 1.62     BY: Robin McCarthy         DATE: 07/15/02   ECO: *P0BJ* */
/* Revision: 1.63     BY: Tiziana Giustozzi      DATE: 07/24/02   ECO: *P09N* */
/* Revision: 1.65     BY: Pawel Grzybowski       DATE: 03/27/03   ECO: *P0NT* */
/* Revision: 1.66     BY: Orawan S.              DATE: 05/26/03   ECO: *P0RG* */
/* Revision: 1.68     BY: Paul Donnelly          DATE: 06/28/03   ECO: *Q005* */
/* Revision: 1.69     BY: Vinay Soman            DATE: 09/25/03   ECO: *P145* */
/* Revision: 1.70     BY: Nishit V               DATE: 01/27/04   ECO: *P1LB* */
/* Revision: 1.71     BY: Subramanian Iyer       DATE: 03/19/04   ECO: *N2QC* */
/* Revision: 1.72     BY: Sachin Deshmukh        DATE: 08/26/04   ECO: *P2GP* */
/* Revision: 1.73     BY: Dan Herman             DATE: 11/04/04   ECO: *M1V1* */
/* Revision: 1.74     BY: Tejasvi Kulkarni       DATE: 12/29/04   ECO: *P31T* */
/* Revision: 1.75     BY: Swati Sharma           DATE: 03/04/05   ECO: *P3B2* */
/* Revision: 1.75.1.2 BY: SurenderSingh Nihalani DATE: 05/16/06   ECO: *P4PQ* */
/* Revision: 1.75.1.3 BY: SurenderSingh Nihalani DATE: 06/12/06   ECO: *P4S2* */
/* Revision: 1.75.1.4 BY: SurenderSingh Nihalani DATE: 06/19/06   ECO: *P4TZ* */
/* Revision: 1.75.1.6 BY: Archana Kirtane        DATE: 05/25/07   ECO: *P5XG* */
/* Revision: 1.75.1.9 BY: Alex Joy               DATE: 01/25/08   ECO: *P61X* */
/* Revision: 1.75.1.11 BY: Antony LejoS          DATE: 06/13/08   ECO: *P6V4* */
/* Revision: 1.75.1.14 BY: Swarna M              DATE: 12/19/08   ECO: *Q24C* */
/* Revision: 1.75.1.15 BY: Ashim Mishra          DATE: 01/14/09   ECO: *Q27D* */
/* Revision: 1.75.1.16 BY: Nafees Khan           DATE: 01/22/09   ECO: *Q294* */
/* Revision: 1.75.1.18 BY: Anil Sudhakaran       DATE: 08/17/09   ECO: *Q38P* */
/* Revision: 1.75.1.19 BY: Avishek Chakraborty   DATE: 03/09/10   ECO: *Q3X0* */
/* Revision: 1.75.1.20 BY: Ashim Mishra          DATE: 07/14/10   ECO: *Q47X* */
/* $Revision: 1.75.1.21 $ BY: Ambrose Almeida       DATE: 11/11/10   ECO: *Q4GN* */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */

/******************************************************************************/
/* THIS PROGRAM WAS CLONED TO kbporcm.p 05/16/02, REMOVING UI.                */
/* CHANGES TO THIS PROGRAM MAY ALSO NEED TO BE APPLIED TO kbporcm.p           */
/* ANY CHANGES MADE TO POPORCM.P SHOULD ALSO BE MADE TO PORVISM.P             */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdeclre.i}
{cxcustom.i "POPORCM.P"}
{pxsevcon.i} /* SEVERITY PREPROCESSOR CONSTANT DEFINITION INCLUDE FILE */
{pxmaint.i}  /* STANDARD MAINTENANCE COMPONENT INCLUDE FILE */
{pxphdef.i mcpl}  /* INCLUDE FILE FOR DEFINING PERSISTENT HANDLE */
{pxpgmmgr.i} /* INCLUDE FILE FOR RETRIEVING PROGRAM MANAGER */
{gplabel.i}  /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE poporcm_p_1 "Move to Next Operation"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporcm_p_2 "Packing Slip"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporcm_p_3 "Order"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporcm_p_4 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporcm_p_5 "Ship Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporcm_p_6 "Qty Open"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporcm_p_7 "Ship All"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporcm_p_8 "Receive All"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporcm_p_9 "Receiver"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporcm_p_10 "Receiver/RTS Shipper"
/* MaxLen: 26 Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* COMMON VARIABLES, FRAMES & BUFFERS FOR RECEIPTS & RETURNS */
{porcdef.i "new"}

{gpglefdf.i}

/*@MODULE PRM BEGIN*/
/* DEFINE SHARED TEMP-TABLES FOR PRM */
{pjportt.i "new"}
/*@MODULE PRM END*/

define temp-table tt_po_tax
   field tt_po   like po_nbr
   field tt_line like pod_line
   index tt_po_line_indx tt_po tt_line.

/* NEW SHARED VARIABLES, BUFFERS AND FRAMES */
define new shared variable h_wiplottrace_procs as   handle            no-undo.
define new shared variable h_wiplottrace_funcs as   handle            no-undo.
define new shared variable convertmode         as   character         no-undo.
define new shared variable fiscal_rec          as   logical initial   no.
define new shared variable rndmthd             like rnd_rnd_mthd.
define new shared variable fiscal_id           like prh_receiver.
define new shared variable qopen               like pod_qty_rcvd
   label {&poporcm_p_6}.
define new shared variable receivernbr         like prh_receiver.
define new shared variable maint               like mfc_logical       no-undo.
define new shared variable fill-all            like mfc_logical
   label {&poporcm_p_8}   no-undo.
define new shared variable vendlot             like tr_vend_lot       no-undo.
define new shared variable receipt_date        like prh_rcp_date      no-undo.
define new shared variable prm-avail           like mfc_logical       no-undo.
/* KANBAN TRANSACTION NUMBER 0 FOR poporcb8.p, poporcb6.p, poporcc.p */
define new shared variable kbtransnbr          as integer             no-undo.
define new shared variable msg                 as character format "x(60)".
define new shared variable l_include_retain    like mfc_logical initial yes
   no-undo.
define new shared variable l_ex_rate           like exr_rate          no-undo.
define new shared variable l_ex_rate2          like exr_rate2         no-undo.
define new shared frame b.
define new shared workfile tax_wkfl
   field tax_nbr     like pod_nbr
   field tax_line    like pod_line
   field tax_env     like pod_tax_env
   field tax_usage   like pod_tax_usage
   field tax_taxc    like pod_taxc
   field tax_in      like pod_tax_in
   field tax_taxable like pod_taxable
   field tax_price   like prh_pur_cost.

/*WORKFILE FOR POD RECEIPT ATTRIBUTES*/
define new shared workfile attr_wkfl no-undo
   field chg_line    like sr_lineid
   field chg_assay   like tr_assay
   field chg_grade   like tr_grade
   field chg_expire  like tr_expire
   field chg_status  like tr_status
   field assay_actv  as   logical
   field grade_actv  as   logical
   field expire_actv as   logical
   field status_actv as   logical.

/* LOGISTICS CHARGE - PENDING VOUCHER MASTER TEMP TABLE DEFINITION */
define new shared temp-table tt-pvocharge no-undo
   field tt-lc_charge           like lc_charge
   field tt-pvo_id              as   integer
   index tt-index
   tt-lc_charge
   tt-pvo_id.

/* LOCAL VARIABLES, BUFFERS AND FRAMES */
define variable undo_loop       like mfc_logical                        no-undo.
define variable pook            like mfc_logical.
define variable dbconn          like mfc_logical                        no-undo.
define variable pod-db-name     like pod_po_db                          no-undo.
define variable ers-proc        like poc_ers_proc                       no-undo.
define variable ent_exch        like exr_rate                           no-undo.
define variable ent_exch2       like exr_rate2                          no-undo.
define variable cmmt_yn         like mfc_logical  label {&poporcm_p_4}  no-undo.
define variable rcv_type        like poc_rcv_type                       no-undo.
define variable err_flag        like mfc_logical                        no-undo.
define variable vndname         like ad_name                            no-undo.
define variable issqty          like pod_qty_ord                        no-undo.
define variable fromsite        like pod_site                           no-undo.
define variable fromloc         like pod_loc                            no-undo.
define variable tosite          like pod_site                           no-undo.
define variable toloc           like pod_loc                            no-undo.
define variable reject1         like mfc_logical                        no-undo.
define variable reject2         like mfc_logical                        no-undo.
define variable ship_date       like prh_ship_date                      no-undo.
define variable shipnbr         like tr_ship_id                         no-undo.
define variable inv_mov         like tr_ship_inv_mov                    no-undo.
define variable pur_cost        like pod_pur_cost                       no-undo.
define variable set_flag        like mfc_logical                        no-undo.
{&POPORCM-P-TAG3}
define variable ordernum        like po_nbr                             no-undo.
{&POPORCM-P-TAG4}
define variable newprice        like pod_pur_cost                       no-undo.
define variable dummy_disc      like pod_disc_pct                       no-undo.
define variable rejected        like mfc_logical                        no-undo.
define variable mc-error-number like msg_nbr                            no-undo.
define variable error_flag      as   integer                            no-undo.
define variable err             as   integer                            no-undo.
define variable recno_sr_wkfl   as   recid                              no-undo.
define variable pc_recno        as   recid                              no-undo.
define variable use-log-acctg   as   logical                            no-undo.
define variable l_isAuthorized  as integer                              no-undo.
define variable lblPONbr        as character                            no-undo.
{pxmaint.i}

/*MAIN-BEGIN*/

/*@MODULE WIPLOTTRACE BEGIN*/
{wlfnc.i} /*FUNCTION FORWARD DECLARATIONS*/
/*@MODULE WIPLOTTRACE END*/
{gprunpdf.i "mcpl" "p"}

/* DEFINE & INITIALIZE CURRENCY DEPENDENT ROUNDING FORMAT VARS */
{pocurvar.i "NEW"}
{txcurvar.i "NEW"}

/* DEFINE TRAILER VARS AS NEW, SO THAT CORRECT _OLD FORMATS */
/* CAN BE ASSIGNED BASED ON INITIAL DEFINE                  */
{potrldef.i "NEW"}

{txcalvar.i}

{mfaimfg.i} /* COMMON API CONSTANTS AND VARIABLES */

{popoit01.i} /* DEFINE API PURCHASE ORDER TEMP TABLES  */
{mctrit01.i} /* DEFINE API TRANSACTION EXCHANGE RATES TEMP TABLE */
{icicit01.i} /* DEFINE API INVENTORY CONTROL TEMP TABLES   */
{mfctit01.i} /* DEFINE API TRANSACTION COMMENTS TEMP TABLES */

if c-application-mode = "API" then do:

   /* GET HANDLE OF API CONTROLLER */
   {gprun.i ""gpaigh.p""
            "(output ApiMethodHandle,
              output ApiProgramName,
              output ApiMethodName,
              output ApiContextString)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   /* GET PURCHASE ORDER TRANSACTION TEMP-TABLE */
   run getPurchaseOrderTrans in ApiMethodHandle
     (output table ttPurchaseOrderTrans).

   /* GET PURCHASE ORDER TRANSACTION COMMENT TEMP-TABLE */
   run getPurchaseOrderTransCmt in ApiMethodHandle
      (output table ttPurchaseOrderTransCmt).

   /* GET PURCHASE ORDER TRANSACTION DETAIL TEMP-TABLE */
   run getPurchaseOrderTransDet in ApiMethodHandle
      (output table ttPurchaseOrderTransDet).

   /* GET PURCHASE ORDER TRANSACTION DETAIL COMMENT TEMP-TABLE */
   run getPurchaseOrderTransDetCmt in ApiMethodHandle
      (output table ttPurchaseOrderTransDetCmt).

end. /* if c-application-mode = "API" */


{&POPORCM-P-TAG2}
assign
   nontax_old    = nontaxable_amt:format
   taxable_old   = taxable_amt:format
   lines_tot_old = lines_total:format
   tax_tot_old   = tax_total:format
   order_amt_old = order_amt:format
   prepaid_old   = po_prepaid:format
   lblPONbr      = getTermLabel("PO_NUMBER",12).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
po_nbr         colon 12   label {&poporcm_p_3}
   po_vend
   po_stat
   ps_nbr         format "x(12)" to 78
 SKIP(.4)  /*GUI*/
with frame b side-labels no-attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

{&POPORCM-P-TAG5}
assign
   cmmt-prefix = "RCPT:"
   transtype   = "RCT-PO"
   convertmode = "MAINT".

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
ordernum       colon 15       label {&poporcm_p_3}
   po_vend
   po_stat
   eff_date       colon 68
   ps_nbr         colon 15       label {&poporcm_p_2}
   move           colon 68       label {&poporcm_p_1}
   receivernbr    colon 15       label {&poporcm_p_9}
   vndname        at    27       no-attr-space no-label
   fill-all       colon 68
   cmmt_yn        colon 68
   ship_date      colon 68       label {&poporcm_p_5}
 SKIP(.4)  /*GUI*/
with frame a1 attr-space side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a1 = F-a1-title.
 RECT-FRAME-LABEL:HIDDEN in frame a1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a1 =
  FRAME a1:HEIGHT-PIXELS - RECT-FRAME:Y in frame a1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a1 = FRAME a1:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame a1:handle).

/* IN THE HEADER OF THE RTS SHIPMENT THE receivernbr WILL NOW */
/* BE DISPLAYED WITH THE LABEL "Receiver/RTS Shipper"         */
FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
ordernum       colon 15       label {&poporcm_p_3}
   po_vend
   po_stat
   eff_date       colon 68
   ps_nbr         colon 15       no-label
   move           colon 68       no-label
   vndname        at    27       no-attr-space no-label
   fill-all       colon 68       label {&poporcm_p_7}
   receivernbr    colon 27       label {&poporcm_p_10}
   cmmt_yn        colon 68
 SKIP(.4)  /*GUI*/
with frame a2 attr-space side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a2-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a2 = F-a2-title.
 RECT-FRAME-LABEL:HIDDEN in frame a2 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a2 =
  FRAME a2:HEIGHT-PIXELS - RECT-FRAME:Y in frame a2 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a2 = FRAME a2:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame a2:handle).

/* Hide the variable "move" from the frame if porec = false */
/* To avoid the value of move getting displayed */

if not porec and c-application-mode <> "API" then
   move:hidden in frame a2 = true.

/* DIFFERENT LABELS ARE DISPLAYED FOR SAME VARIABLE, */
/* SO NEED TO ASSIGN LABELS MANUALLY.                */
if dynamic-function('getTranslateFramesFlag' in h-label) then
assign
       receivernbr:label = getTermLabel("RECEIVER/RTS_SHIPPER",26)
       fill-all:label    = getTermLabel("SHIP_ALL",11).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
ent_exch colon 15
   space(2)
 SKIP(.4)  /*GUI*/
with frame seta1_sub attr-space overlay side-labels
   centered row frame-row(a) + 4 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-seta1_sub-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame seta1_sub = F-seta1_sub-title.
 RECT-FRAME-LABEL:HIDDEN in frame seta1_sub = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame seta1_sub =
  FRAME seta1_sub:HEIGHT-PIXELS - RECT-FRAME:Y in frame seta1_sub - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME seta1_sub = FRAME seta1_sub:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame seta1_sub:handle).

/*@MODULE WIPLOTTRACE BEGIN*/
if is_wiplottrace_enabled() then do:
   run activate_wiplot_trace.
end. /* IF IS_WIPLOTTRACE_ENABLED() */
/*@MODULE WIPLOTTRACE END*/

for first poc_ctrl
      fields( poc_domain poc_ers_proc poc_rcv_all poc_rcv_type )  where
      poc_ctrl.poc_domain = global_domain no-lock:
end. /* FOR FIRST POC_CTRL */

assign
   rcv_type  = poc_rcv_type
   ers-proc  = poc_ers_proc.

assign
   maint       = true
   shipper_rec = false
   fiscal_rec  = false.

{&POPORCM-P-TAG6}
{gprun.i ""socrshc.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


for first shc_ctrl
fields( shc_domain shc_ship_rcpt)
 where shc_ctrl.shc_domain = global_domain no-lock:
end. /* FOR FIRST SHC_CTRL */

/*@MODULE PRM BEGIN*/
/* CHECK IF PRM IS INSTALLED */
{pjchkprm.i}

/* PRM-ENABLED VARIABLE DEFINED IN PJCHKPRM.I */
prm-avail = prm-enabled.
/*@MODULE PRM END*/

/* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}
/*GUI*/ if global-beam-me-up then undo, leave.


main-loop:
repeat:

   for first poc_ctrl
      where poc_ctrl.poc_domain = global_domain
   no-lock:
   end. /* FOR FIRST POC_CTRL */
   /* RESET RECEIVE ALL FLAG TO DEFAULT FROM CONTROL FILE */
   /*@MODULE RCV-ALL BEGIN*/
   fill-all  = poc_rcv_all.
   /*@MODULE RCV-ALL END*/

   transtype   = "RCT-PO".

/* DELETE qad_wkfl RECORDS */
   {pxrun.i &PROC='DeleteQadwkfl'
            &PROGRAM='porcxr.p'
            &PARAM="(input 'RECEIVER',
                     input receivernbr,
                     input mfguser,
                     input global_userid)"
            &NOAPPERROR=True
            &CATCHERROR=True}

   if c-application-mode = "API" and retry
      then return error return-value.

   if c-application-mode = "API" then do:
      find next ttPurchaseOrderTrans
      no-lock no-error.
      if not available ttPurchaseOrderTrans then return.
   end.

   /* SPLIT THE ORIGINAL DO TRANSACTION BLOCK INTO TWO DO TRANSACTION */
   /* BLOCKS TO TAKE CARE OF ORACLE TRANSACTION SCOPING PROBLEM  .    */
   /* poporcm.i MOVED IN THE FIRST DO TRANSACTION BLOCK. COMMENTED    */
   /* CODE RELATED TO FOREIGN CURRENCY AND TRANSACTION COMMENTS FROM  */
   /* poporcm.i AND COPIED IT IN THIS PROGRAM                         */

   {&POPORCM-P-TAG7}
   do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

      if porec
      then do:
         {poporcm.i &frame=a1}
      end. /* IF porec */
      else do:
         {poporcm.i &frame=a2}
      end. /* ELSE DO: */
      if execname = "fsrtvis.p"
      then do:
         if can-find (mfc_ctrl
            where mfc_ctrl.mfc_domain = global_domain
            and   mfc_field           = "enable_supplier_perf"
            and   mfc_logical)
            and   can-find (_File where _File-name = "vef_ctrl")
            and   receivernbr = ""
         then do:
            {mfnctrlc.i
               "poc_ctrl.poc_domain = global_domain"
               "poc_ctrl.poc_domain"
               "prh_hist.prh_domain = global_domain"
               poc_ctrl
               poc_rcv_pre
               poc_rcv_nbr
               prh_hist
               prh_receiver
               receivernbr}
         end. /* IF ENABLE SUPPLIER PERFORMANCE */
      end. /* IF EXECNAME = "fsrtvis.p" */
   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO TRANSACTION */
   {&POPORCM-P-TAG8}

   do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


      {&POPORCM-P-TAG9}
      if base_curr <> po_curr
      then do:
         if not po_fix_rate
         then do:
            seta1_sub:
            do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


               if c-application-mode = "API"
                  then do:
                  {gpttcp.i
                          ttPurchaseOrderTrans
                          ttTransExchangeRates
                          "ttPurchaseOrderTrans.nbr = po_mstr.po_nbr"
                  }
                  run setTransExchangeRates in apiMethodHandle
                     (input table ttTransExchangeRates).
               end.  /* IF c-application-mode .. */

               {gprunp.i "mcui" "p" "mc-ex-rate-input"
                  "(input po_curr,
                    input base_curr,
                    input eff_date,
                    input exch_exru_seq,
                    input false,
                    input frame-row(a) + 4,
                    input-output exch_rate,
                    input-output exch_rate2,
                    input-output po_fix_rate)"}

               assign
                  l_ex_rate  = exch_rate
                  l_ex_rate2 = exch_rate2 .

               if keyfunction(lastkey) = "end-error"
               then
                  undo seta1_sub, retry seta1_sub.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO ON ERROR UNDO, RETRY */
         end. /*IF NOT po_fix_rate */
      end. /* IF base_curr <> po_curr */

      /* ADD COMMENTS, IF DESIRED */
      if cmmt_yn
      then do:
         if c-application-mode <> "API"
            then do:
            if porec
            then
               hide frame a1 no-pause.
            else
               hide frame a2 no-pause.
         end.

         /*@TO-DO - NEED TO CHECK HOW THESE DEFAULTS GET INTO COMMENTS IN XUI*/
         assign
            cmtindx    = po_cmtindx
            global_ref = cmmt-prefix + " " + po_nbr.

         if c-application-mode = "API"
            then do:
            {gpttcp.i
                   ttPurchaseOrderTransCmt
                   ttTransComment
                   "ttPurchaseOrderTransCmt.nbr = po_mstr.po_nbr"
                   true
            }
            run setTransComment in apiMethodHandle
               (input table ttTransComment).
         end. /* IF c-application-mode = .. */

         do on error undo, return error return-value:
            {gprun.i ""gpcmmt01.p"" "(input ""po_mstr"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end. /* do on error undo, return .. */

         po_cmtindx = cmtindx.
      end. /* IF cmmt_yn */

      {&POPORCM-P-TAG10}
      if porec
      then do:

         /* POP-UP TO COLLECT SHIPMENT INFORMATION */
         if shc_ship_rcpt
         then do:

            if c-application-mode = "API" then do:
               {gpttcp.i
                         ttPurchaseOrderTrans
                         ttInventoryTrans
                         " "
                         true
               }
               run setInventoryTrans in apiMethodHandle
                  (input table ttInventoryTrans).
               run setInventoryTransRow in apiMethodHandle (input ?).
            end.

            do on error undo, return error return-value:
               {gprun.i ""icshup.p""
                  "(input-output shipnbr,
                    input-output ship_date,
                    input-output inv_mov,
                    input 'RCT-PO', no,
                    input 10, input 20)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.
         end. /* IF shc_ship_rcpt */

         run proc-sup-perf.

      end. /* IF porec */

      {gpbrparm.i &browse=gplu908.p &parm=c-brparm1 &val=po_nbr}

      {&POPORCM-P-TAG11}
      {pxrun.i
         &PROC='clearPOReceiptDetails'
         &PROGRAM='porcxr2.p'
         &NOAPPERROR=true
         &CATCHERROR=true}

      /* Transaction */

      {&POPORCM-P-TAG12}
      run initialize_lines
         (input po_nbr, input po_vend, input po_curr).

      {&POPORCM-P-TAG13}
      if c-application-mode <> "API" then do:
         if porec
         then
            hide frame a1 no-pause.
         else
            hide frame a2 no-pause.
      end.

      /* PRM FUNCTIONALITY ONLY APPLIES WHEN PO BEING RECEIVED */
      /* NOT WHEN RETURN TO SUPPLIER AND WHEN PRM INSTALLED    */
      /* CLEAR PREVIOUS TEMP TABLE DATA IF ANY EXISTS          */
      /*@MODULE PRM BEGIN*/

      if porec
      and prm-avail
      then do:
         empty temp-table ttprm-det no-error.
         empty temp-table ttpao-det no-error.
      end. /* IF POREC AND PRM-AVAIL */
      /*@MODULE PRM END*/

      /* EMPTY LOGISTICS ACCOUNTING TEMP TABLE */
      for each tt-pvocharge exclusive-lock:
         delete tt-pvocharge.
      end.

      /* DISPLAY WARNING MESSAGE WHEN RECEIVE ALL IS YES */
      /* FOR LOT/SERIAL CONTROLLED ITEMS                 */
      if fill-all = yes
      then do:

         for each pod_det
            fields (pod_domain pod_nbr pod_status pod_part)
            where pod_domain = global_domain
            and   pod_nbr    = po_nbr
            and   pod_status = ""
         no-lock use-index pod_nbrln:

            for first pt_mstr
               fields (pt_domain pt_part pt_lot_ser)
               where pt_domain = global_domain
               and   pt_part   = pod_part
            no-lock:
            end. /* FOR FIRST pt_mstr */

            if available pt_mstr
               and pt_lot_ser <> ""
            then do:

               /* LOT/SERIAL-CONTROLLED ITEMS EXIST. PLEASE CHECK QUANTITIES. */
               {pxmsg.i &MSGNUM     = 6380
                        &ERRORLEVEL = 2}
               leave.
            end. /* IF AVAILABLE pt_mstr */

         end. /* FOR EACH pod_det */

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF fill-all */

      {&POPORCM-P-TAG14}
      /* RUN poporca.p TO SELECT EDIT ITEMS TO BE RECEIVED */
      assign
         lotserial = ""
         po_recno  = recid(po_mstr)
         proceed   = no.

      do on error undo, return error return-value:
         /* PASSES THE TEMP-TABLE AS AN OUTPUT PARAMETER THROUGH */
         /* POPORCA.P WHICH HAS TO BE USED IN POTAXDT.P          */
         {gprun.i ""poporca.p""
            "(output table tt_po_tax)"}
/*GUI*/ if global-beam-me-up then undo, leave.

      end.

      if (receivernbr <> "")
      and ( can-find(first prh_hist
                       where prh_domain   = global_domain
                       and   prh_receiver = receivernbr
                    )
          )
      then do:
         /* RECEIVER NUMBER ALREADY EXISTS */
         {pxmsg.i &MSGNUM=355 &ERRORLEVEL={&APP-ERROR-RESULT}}

         hide frame b no-pause.
         undo main-loop, retry main-loop.

      end. /* if (receivernbr <> "") */

      for each pod_det
         where pod_nbr     = po_nbr
     and pod_domain    = global_domain:
            if pod_qty_chg <> 0
            then do:
               for first tt_po_tax
                  where  tt_po   = pod_nbr
                  and    tt_line = pod_line:
               end. /*for first tt_po_tax*/
               if not available tt_po_tax
               then do:
                  create tt_po_tax.
                  assign tt_po   = pod_nbr
                         tt_line = pod_line.
               end. /*if not available tt_po_tax*/
            end. /*if pod_qty_chg*/
      end. /*for each pod_det*/

      /*********************************************************/
      /* If this is a return to supplier then reverse the sign */
      /*********************************************************/
      if not porec
      then
      /*@MODULE RTS BEGIN*/
         run proc-rts (input po_nbr).
      /*@MODULE RTS END*/

      run create_update_trans
          (input proceed,
           input shipnbr,
           input ship_date,
           input inv_mov,
           input no,
           input 0,
           input """").

      {&POPORCM-P-TAG15}
   end. /* DO TRANSACTION */

   {&POPORCM-P-TAG16}
   /* CALCULATE AND EDIT TAXES */
   if proceed = yes
   then do:
      undo_trl2 = true.
      {gprun.i ""porctrl2.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

      if undo_trl2 then undo.

      /* PASSED THE SECOND PARAMETER AS TEMP-TABLE CONTAINING THE */
      /* RECEIVED LINES SO THAT POTAXDT.P WILL EDIT ONLY RECEIVED */
      /* LINES WHEN ALL TAX TYPES HAVE TAX BY LINE AS YES         */
      {gprun.i ""potaxdt.p""
         "(input po_recno,
           input table tt_po_tax)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   end. /* IF PROCEED = YES AND .. */

   for each tt_po_tax
   exclusive-lock:
      delete tt_po_tax.
   end. /* FOR EACH tt_po_tax */

   if c-application-mode <> "API" then
      hide frame b no-pause.

   {&POPORCM-P-TAG17}
   /* DELETE EXCH RATE USAGE RECORDS */
   {pxrun.i &PROC='deleteExchangeRateUsage' &PROGRAM='mcexxr.p'
      &PARAM="(input exch_exru_seq)"
      &NOAPPERROR=true
      &CATCHERROR=true}

   release po_mstr.
   {&POPORCM-P-TAG1}

end. /* REPEAT: */

status input.

/*@MODULE WIPLOTTRACE BEGIN*/
if is_wiplottrace_enabled() then
   delete PROCEDURE h_wiplottrace_procs no-error.

if is_wiplottrace_enabled() then
   delete PROCEDURE h_wiplottrace_funcs no-error.
/*@MODULE WIPLOTTRACE END*/

/*MAIN-END*/

/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */

/*============================================================================*/
PROCEDURE activate_wiplot_trace:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
activate_wiplot_trace (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   {gprunmo.i &module="AWT" &program=""wlpl.p""
      &persistent="""persistent set h_wiplottrace_procs"""}

   {gprunmo.i &module="AWT" &program=""wlfl.p""
      &persistent="""persistent set h_wiplottrace_funcs"""}

END PROCEDURE.

/*============================================================================*/
PROCEDURE create_update_trans:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
create_update_trans (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter proceed   like mfc_logical     no-undo.
   define input parameter shipnbr   like tr_ship_id      no-undo.
   define input parameter ship_date like prh_ship_date   no-undo.
   define input parameter inv_mov   like tr_ship_inv_mov no-undo.
   define input parameter ip_usage  as logical           no-undo.
   define input parameter ip_usage_qty as decimal no-undo.
   define input parameter ip_trnbr as character no-undo.

   /* RUN poporcb.p TO CREATE RECEIPTS & UPDATE TRANSACTIONS */
   if proceed = yes then do:
      {pxrun.i &PROC='commitReceipt' &PROGRAM='porcxr.p'
               &PARAM="(input shipnbr,
                        input ship_date,
                        input inv_mov,
                        input ip_usage,
                        input ip_usage_qty,
                        input ip_trnbr)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      {gprun.i ""poporcd.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


   end. /* IF PROCEED = YES */

END PROCEDURE.

/*============================================================================*/
PROCEDURE del-sr-wkfl:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
del-sr-wkfl (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   {pxrun.i &PROC='clearPOReceiptDetails' &PROGRAM='porcxr2.p'
      &NOAPPERROR=true
      &CATCHERROR=true}

END PROCEDURE.

/*============================================================================*/
PROCEDURE delete-sr-wkfl:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
delete-sr-wkfl (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   for each sr_wkfl
          where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
          exclusive-lock:
      delete sr_wkfl.
   end. /* FOR EACH SR_WKFL */

END PROCEDURE.

/*============================================================================*/
PROCEDURE find-rmd-det:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
find-rmd-det (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter inpar_nbr  like pod_nbr      no-undo.
   define input parameter inpar_line like pod_line     no-undo.
   define input parameter inpar_site like pod_site     no-undo.
   define input parameter inpar_loc  like pod_loc      no-undo.
   define input parameter inpar_type like pod_rma_type no-undo.

   for first rmd_det
         fields( rmd_domain rmd_line rmd_loc rmd_nbr rmd_prefix rmd_site)
          where rmd_det.rmd_domain = global_domain and  rmd_nbr = inpar_nbr
         and rmd_prefix = "V"
         and rmd_line   = inpar_line no-lock:
   end. /* FOR FIRST RMD_DET */

   /* Set up RTS Issues */
   if inpar_type = "O" then
   assign
      issqty    = issqty * -1
      fromsite  = inpar_site
      fromloc   = inpar_loc
      tosite    = rmd_site
      toloc     = rmd_loc.

   /* Set up RTS Receipts */
   if inpar_type = "I" then
   assign
      fromsite = rmd_site
      fromloc  = rmd_loc
      tosite   = inpar_site
      toloc    = inpar_loc.

END PROCEDURE.

/*============================================================================*/
PROCEDURE find-vp-mstr:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
find-vp-mstr (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter inpar_part    like pod_part  no-undo.
   define input parameter inpar_vend    like po_vend   no-undo.
   define input parameter inpar_um      like pod_um    no-undo.
   define input parameter inpar_curr    like po_curr   no-undo.
   define input parameter l_inpar_vpart like pod_vpart no-undo.

   set_flag = no.

   /* ADDED VP_VEND_VPART IN THE FIELD LIST BELOW */
   {pxrun.i &PROC='processRead' &PROGRAM='ppsuxr.p'
      &PARAM="(input inpar_part,
                     input inpar_vend,
                     input l_inpar_vpart,
                     buffer vp_mstr,
                     input {&NO_LOCK_FLAG},
                     input {&NO_WAIT_FLAG})"
      &NOAPPERROR=true
      &CATCHERROR=true}

   if return-value = {&SUCCESS-RESULT} and
      qopen      >= vp_q_qty and
      inpar_um   =  vp_um    and
      vp_q_price >  0        and
      inpar_curr =  vp_curr then
   assign
      set_flag = yes
      pur_cost = vp_q_price.

END PROCEDURE.

/*============================================================================*/
PROCEDURE if_porec_or_is_return:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
if_porec_or_is_return (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter site       like pod_site               no-undo.
   define input parameter loc        like pod_loc                no-undo.
   define input parameter part       like pod_part               no-undo.
   define input parameter serial     like pod_serial             no-undo.
   define output parameter undo_loop like mfc_logical initial no no-undo.

   if porec or is-return then do:
      /* CHECK FOR SINGLE ITEM / SINGLE LOT/SERIAL LOCATION */
      for first loc_mstr
            fields( loc_domain loc_loc loc_single loc_site loc__qad01)
             where loc_mstr.loc_domain = global_domain and  loc_site = site
            and loc_loc  = loc no-lock:
      end. /* FOR FIRST LOC_MSTR */

      if available loc_mstr and loc_single = yes then do:
         recno_sr_wkfl = recid(sr_wkfl).
         run proc-gploc02 (input loc__qad01).

         error_flag = err.

         if error_flag = 0 and loc__qad01 = yes then do:
            /* CHECK PRIOR RECEIPT TRANSACTIONS (ld_det's) FOR
            DIFFERENT ITEMS OR LOT/SERIALS IN SAME LOCATION */
            {gprun.i ""gploc01.p""
               "(site,
                       loc,
                       part,
                       serial,
                       "" "",
                       loc__qad01,
                       output error_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            if error_flag <> 0
               /* ADJUSTING QTY ON A PREVIOUS VIOLATION (CREATED
               BEFORE THIS PATCH) OF SINGLE ITEM/LOT/SERIAL
               LOCATION ALLOWED; CREATING ANOTHER VIOLATION
               DISALLOWED.
               */
               and can-find(ld_det  where ld_det.ld_domain = global_domain and
               ld_site = site
               and ld_loc = loc and ld_part = part
               and ld_lot = serial and ld_ref = "") then
               error_flag = 0.
         end. /* IF ERROR_FLAG = 0 AND LOC__QAD01 = YES */

         if error_flag <> 0 then do:
            run proc-mfmsg.

            /* TRANSACTION CONFLICTS WITH SINGLE ITEM/LOT LOC */
            undo_loop = yes.
         end. /* IF ERROR_FLAG <> 0 */
      end.  /* IF AVAILABLE LOC_MSTR AND LOC_SINGLE = YES */
   end. /* IF POREC OR IS-RETURN */

END PROCEDURE.

/*============================================================================*/
PROCEDURE initialize_lines:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
initialize_lines (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter ip_po_nbr  as character no-undo.
   define input parameter ip_po_vend as character no-undo.
   define input parameter ip_po_curr as character no-undo.

   define variable l_si_db like si_db no-undo.
   define variable vCancelBackOrder like mfc_logic no-undo.
   define variable vSiteId as character no-undo.

   {&POPORCM-P-TAG18}
   /* DETAIL FRAME C AND SINGLE LINE PROCESSING FRAME D */
   preppoddet:
   for each pod_det
          where pod_det.pod_domain = global_domain and  pod_nbr = ip_po_nbr
         and pod_status <> "c"
         and pod_status <> "x":
/*GUI*/ if global-beam-me-up then undo, leave.


      /********************************************************/
      /*  If this is an rtv po then we need to check the type */
      /*  For normal receipts, the field will be blank.       */
      /*  For an rtv type it will be I.                       */
      /*  For an rtv return it will be O.                     */
      /*  For Return to Supplier transactions, the sign of    */
      /*  pod_qty_chg is reversed for display purposes,       */
      /*  because we are on a return screen. Before the       */
      /*  transaction is complete we reverse the signs to     */
      /*  to negative again.                                  */
      /********************************************************/
      if porec then do:
         if pod_rma_type <> "I"  and
            pod_rma_type <> ""   then next preppoddet.
      end. /* IF POREC */
      else if pod_rma_type <> "O" then next preppoddet.

      {pxrun.i &PROC='getSiteDatabase' &PROGRAM='icsixr.p'
         &PARAM="(input  pod_site,
                        output l_si_db)"
         &NOAPPERROR=true
         &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT}
         or l_si_db <> global_db then
            next preppoddet.

      /*@MODULE RCV-ALL BEGIN*/
      {pxrun.i &PROC='processRead' &PROGRAM='ppitxr.p'
         &PARAM="(input  pod_part,
                        buffer pt_mstr,
                        input  {&NO_LOCK_FLAG},
                        input  {&NO_WAIT_FLAG})"
         &NOAPPERROR=true
         &CATCHERROR=true}

      run proc-attr-wkfl
         (input pod_line,           input pod_assay,
         input pod_grade,          input pod_expire,
         input pod_rctstat,        input pod_rctstat_active,
         input pod_part,           input pod_site,
         input pod_loc,            input recid(pod_det)).

      if fill-all = yes then do:
         rejected  = no.
         /* ICEDIT2 PERFORMS CHECK AGAINST RECEIPT WHICH AFFECT */
         /* INVENTORY.TO RESTRICT THE RECEIPT WHEN PO LINE IS   */
         /* EITHER OF TYPE "S" (SUBCONTRACT) OR  "M" (MEMO),    */
         /* WHICH DOES NOT AFFECTS UPDATE INVENTORY.            */

         if (pod_type = "M" or pod_type = "S") and
            available pt_mstr                  and
            can-find(first isd_det
             where isd_det.isd_domain = global_domain and  isd_status  =
             string(pt_status,"x(8)") + "#"
            and isd_tr_type = transtype)  then do:

            /* RESTRICTED TRANSACTION FOR STATUS CODE */

            run proc1-mfmsg02 (input pt_status).
            undo preppoddet, next preppoddet.
         end. /* IF POD_TYPE = "M" OR POD_TYPE = "S" */

         /* ONLY AUTO-FILL PARTS THAT ARE NOT LOT/SERIAL CONTROLLED */
         /* AND HAVE NO ATTRIBUTE (ERROR-FLAG = NO) CONFLICTS       */
         if not err_flag
            and (not available pt_mstr
                 or (available pt_mstr
                        and pt_lot_ser = ""
                        and pod_type <> "S"))
         then do:

            if pod_type = ""
               and pod_fsm_type = ""
            then do:

               if pod_consignment
               then do:
                  run p_validateTransaction (input  "CN-RCT",
                                             input  pod_site,
                                             input  pod_loc,
                                             input  pod_part,
                                             output rejected).
               end. /* IF pod_consignment */
               else do:
                  {gprun.i ""icedit2.p""
                     "(input ""RCT-PO"",
                       input pod_site,
                       input pod_loc,
                       input pod_part,
                       input """",
                       input """",
                       input (pod_qty_ord - pod_qty_rcvd) * pod_um_conv,
                       input pod_um,
                       input pod_nbr,
                       input string(pod_line),
                       output rejected)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end. /* ELSE DO */

            end. /* IF POD_TYPE = "" AND POD_FSM_TYPE = "" */
            /*@MODULE RTS BEGIN*/
            /* RTS's generated by field service need sites, and  */
            /* locations identified. And qty properly expressed. */
            else if pod_fsm_type <> "" then do:
               assign
                  rejected  = no
                  reject1   = no
                  reject2   = no
                  issqty    = (pod_qty_ord - pod_qty_rcvd) * pod_um_conv.

               run find-rmd-det
                  (input pod_nbr, input pod_line, input pod_site,
                  input pod_loc, input pod_rma_type).

               /* RTS's receipts that have been previously  */
               /* issued from inventory do not need to test */
               /* the from site.                            */
               if fromsite <> "" then do:
                  {gprun.i ""icedit2.p""
                     "(input ""ISS-TR"",
                             input fromsite,
                             input fromloc,
                             input pod_part,
                             input """",
                             input """",
                             input issqty,
                             input pod_um,
                             input """",
                             input """",
                             output reject1)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end. /* IF FROMSITE <> "" */

               /* RTS issues from inventory do not need to */
               /* test the tosite.                         */
               if tosite <> "" then do:
                  {gprun.i ""icedit2.p""
                     "(input ""RCT-TR"",
                       input tosite,
                       input toloc,
                       input pod_part,
                       input """",
                       input """",
                       input issqty,
                       input pod_um,
                       input """",
                       input """",
                       output reject2)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end. /* IF TOSITE <> "" */

               if reject1 or reject2 then rejected = yes.
            end. /* ELSE IF POD_FSM_TYPE <> "" */
            /*@MODULE RTS END*/
            {gprun.i ""gpsiver.p""
                     "(input pod_site,
                       input ?,
                       output l_isAuthorized)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            if l_isAuthorized = 0
            then
               rejected = yes.

            if rejected then do on endkey undo, retry:

               run proc-mfmsg02 (input pod_part).

               pod_qty_chg = 0.

               run p-assign
                  (input  pod_sched,
                  input  pod_qty_ord,
                  input  pod_qty_rcvd,
                  input  recid(pod_det),
                  output pod_bo_chg).

            end. /* IF REJECTED */
            else do:
               pod_bo_chg = 0.

               run p-assign
                  (input  pod_sched,
                  input  pod_qty_ord,
                  input  pod_qty_rcvd,
                  input  recid(pod_det),
                  output pod_qty_chg).

            end. /* ELSE DO: */
         end. /* IF NOT ERR_FLAG */
         else do:
            pod_qty_chg = 0.

            if not pod_sched then
               pod_bo_chg = pod_qty_ord - pod_qty_rcvd.
            else do:
               {gprun.i ""rsoqty.p""
                  "(input  recid(pod_det),
                          input  eff_date,
                          output qopen)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               pod_bo_chg = qopen.
            end. /* ELSE DO: */
         end. /* ELSE DO: */

         /*! CHECK PRICE LIST FOR SCHEDULED ITEMS */
         if pod_sched then do:
           {gprun.i ""gpsct05.p""
                    "(input       pod_part,
                      input       pod_site,
                      input       2,
                      output      glxcst,
                      output      curcst)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            glxcst = glxcst * pod_um_conv.

            if ip_po_curr <> base_curr
            then do:
               {pxrun.i &PROC='mc-curr-conv'
                        &PROGRAM='mcpl.p'
                        &HANDLE=ph_mcpl
                        &PARAM="(input base_curr,
                                 input ip_po_curr,
                                 input exch_rate2,
                                 input exch_rate,
                                 input glxcst,
                                 input true,
                                 output glxcst,
                                 output mc-error-number)"}

               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end. /*IF mc-error-number <> 0 */
            end. /* IF po_curr <> base_curr */

            if use-log-acctg then do:

               po_recno  = recid(po_mstr).

               if po_tot_terms_code <> "" then

                  glxcst = pod_pur_cost.

            end. /* if use-log-acctg */

            dummy_disc = 0.
            /* CHANGED EIGHTH INPUT PARAMETER TO glxcst FROM pod_pur_cost */
            /* AND ELEVENTH PARAMETER TO glxcst FROM newprice             */
            {gprun.i ""gppccal.p""
                     "(input        pod_part,
                       input        qopen,
                       input        pod_um,
                       input        pod_um_conv,
                       input        ip_po_curr,
                       input        pod_pr_list,
                       input        eff_date,
                       input        glxcst,
                       input        no,
                       input        dummy_disc,
                       input-output glxcst,
                       output       dummy_disc,
                       input-output newprice,
                       output       pc_recno)" }
/*GUI*/ if global-beam-me-up then undo, leave.


            /* IF NO LIST PRICE WAS FOUND LETS TRY TO CHECK FOR   */
            /* A VP_Q_PRICE FOR THE ITEM.  IF WE CANT FIND ONE,   */
            /* POD_PRICE WILL REMAIN AS IT WAS ORIGINALLY.        */

            if pc_recno = 0 or newprice = 0 then do:

               run find-vp-mstr
                  (input pod_part, input ip_po_vend,
                  input pod_um,   input ip_po_curr,
                  input pod_vpart).

               if set_flag then pod_pur_cost = pur_cost.

            end. /* IF PC_RECNO = 0 OR NEWPRICE = 0 */
            else pod_pur_cost = newprice.
         end. /* IF POD_SCHED */

         if not porec then
         assign
            pod_qty_chg = - pod_qty_chg
            pod_bo_chg  = - pod_bo_chg.

         if pod_qty_chg <> 0 then do:
            create sr_wkfl. sr_wkfl.sr_domain = global_domain.
            assign
               sr_userid = mfguser
               sr_lineid = string(pod_line)
               sr_site   = pod_site
               sr_loc    = pod_loc
               sr_lotser = ""
               sr_ref    = ""
               {&POPORCM-P-TAG19}
               sr_qty    = pod_qty_chg.
            if recid(sr_wkfl) = -1 then .
         end. /* IF POD_QTY_CHG <> 0 */

         run if_porec_or_is_return
            (input pod_site,   input  pod_loc, input pod_part,
            input pod_serial, output undo_loop).

         if undo_loop then undo preppoddet, next preppoddet.

         {gprun.i ""gpsiver.p""
            "(input pod_site,
                    input ?,
                    output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      end. /* IF FILL-ALL = YES */
      /*@MODULE RCV-ALL END*/

      {&POPORCM-P-TAG20}
      {pxrun.i &PROC='assignDefaultsForNewLine' &PROGRAM='porcxr1.p'
         &PARAM="(buffer pod_det,
                        input  fill-all,
                        output vCancelBackOrder,
                        output vSiteId)"
         &NOAPPERROR=true
         &CATCHERROR=true}

      {&POPORCM-P-TAG21}
   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH POD_DET */

END PROCEDURE.

/*============================================================================*/
PROCEDURE p-assign:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
p-assign (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input  parameter l_pod_sched    like pod_sched    no-undo.
   define input  parameter l_qty_ord      like pod_qty_ord  no-undo.
   define input  parameter l_qty_rcvd     like pod_qty_rcvd no-undo.
   define input  parameter l_recid        as   recid        no-undo.
   define output parameter l_qty_chg      like pod_qty_chg  no-undo.

   if not l_pod_sched then
      assign l_qty_chg  = l_qty_ord - l_qty_rcvd.
   else do:
      {gprun.i ""rsoqty.p""
         "(input l_recid,
                 input eff_date,
                 output qopen)"}
/*GUI*/ if global-beam-me-up then undo, leave.

      assign l_qty_chg  = qopen.
   end. /* ELSE DO */

END PROCEDURE.

/*============================================================================*/
PROCEDURE proc-attr-wkfl:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
proc-attr-wkfl (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter inpar_line           like pod_line           no-undo.
   define input parameter inpar_assay          like pod_assay          no-undo.
   define input parameter inpar_grade          like pod_grade          no-undo.
   define input parameter inpar_expire         like pod_expire         no-undo.
   define input parameter inpar_rctstat        like pod_rctstat        no-undo.
   define input parameter inpar_rctstat_active like pod_rctstat_active no-undo.
   define input parameter inpar_part           like pod_part           no-undo.
   define input parameter inpar_site           like pod_site           no-undo.
   define input parameter inpar_loc            like pod_loc            no-undo.
   define input parameter inpar_recid          as   recid              no-undo.

   /*INITIALIZE ATTRIBUTE VARIABLES WITH CURRENT SETTINGS*/
   find first attr_wkfl
      where chg_line = string(inpar_line) exclusive-lock no-error.
   if not available attr_wkfl then do:
      create attr_wkfl.
      chg_line = string(inpar_line).
   end. /* IF NOT AVAILABLE ATTR_WKFL */

   {pxrun.i &PROC='initializeAttributes' &PROGRAM='porcxr1.p'
      &PARAM="(buffer pod_det,
                     input  eff_date,
                     output chg_assay,
                     output chg_grade,
                     output chg_expire,
                     output chg_status,
                     output assay_actv,
                     output grade_actv,
                     output expire_actv,
                     output status_actv,
                     output err_flag)"
      &NOAPPERROR=true
      &CATCHERROR=true}

END PROCEDURE.

/*============================================================================*/
PROCEDURE proc-gploc02:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
proc-gploc02 (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter loc__qad01 like loc__qad01 no-undo.

   for first sr_wkfl
         where recid(sr_wkfl) = recno_sr_wkfl:
   end. /* FOR FIRST SR_WKFL */

   {gploc02.i  "buff1.pod_domain = global_domain and " pod_det pod_nbr
   pod_line pod_part}

   err = error_flag.

END PROCEDURE.

/*============================================================================*/
PROCEDURE proc-mfmsg:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
proc-mfmsg (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   /* MESSAGE #596 - TRANSACTION CONFLICTS WITH SINGLE ITEM/LOT LOCATION */
   {pxmsg.i
      &MSGNUM=596
      &ERRORLEVEL={&WARNING-RESULT}}

END PROCEDURE.

/*============================================================================*/
PROCEDURE proc-mfmsg02:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
proc-mfmsg02 (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter inpar_part like pod_part no-undo.

   /* MESSAGE #161 - UNABLE TO ISSUE OR RECEIVE FOR ITEM */
   {pxmsg.i
      &MSGNUM=161
      &ERRORLEVEL={&WARNING-RESULT}
      &MSGARG1=inpar_part}

END PROCEDURE.

/*============================================================================*/
PROCEDURE proc-rts:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
proc-rts (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter inpar_nbr like po_nbr no-undo.

   for each pod_det
          where pod_det.pod_domain = global_domain and  pod_nbr      =
          inpar_nbr
         and pod_rma_type =  "O"
         and pod_status   <> "c"
         and pod_status   <> "x" exclusive-lock:

      if pod_qty_chg <> 0 then
      assign
         pod_qty_chg = - pod_qty_chg
         pod_bo_chg  = - pod_bo_chg
         pod_ps_chg  = - pod_ps_chg.

      for each sr_wkfl exclusive-lock
             where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
            and sr_lineid = string(pod_line):
         sr_qty = - sr_qty.
      end. /* FOR EACH SR_WKFL */
   end. /* FOR EACH POD_DET */

END PROCEDURE.

/*============================================================================*/
PROCEDURE proc-sup-perf:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
proc-sup-perf (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   /** POP-UP TO COLLECT PERFORMANCE RECEIPT DATE **/
   /** CHECK THAT SUPPLIER PERFORMANCE DATA SHOULD BE COLLECTED **/
   if {pxfunct.i &FUNCTION = 'isSupplierPerformanceEnabled' &PROGRAM = 'adsuxr.p'}
   then do:
      {gprunmo.i &module="ASP" &program =""popove.p""
         &param="""(input recid(po_mstr))"""}
   end. /* IF ENABLE SUPPLIER PERFORMANCE */

END PROCEDURE.

/*============================================================================*/
PROCEDURE proc1-mfmsg02:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
proc1-mfmsg02 (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter inpar_status like pt_status no-undo.

   /* MESSAGE #373 - RESTRICTED TRANSACTION FOR STATUS CODE: */
   {pxmsg.i
      &MSGNUM=373
      &ERRORLEVEL={&APP-ERROR-RESULT}
      &MSGARG1="inpar_status"}

END PROCEDURE.

PROCEDURE p_validateTransaction:

   define input parameter p_transtype like tr_type.
   define input parameter p_site      like tr_site.
   define input parameter p_location  like tr_loc.
   define input parameter p_part      like tr_part.
   define output parameter p_undotran like mfc_logical no-undo.

   define variable l_status  like si_status initial "" no-undo.

      for first loc_mstr
         fields (loc_site loc_loc loc_status loc_single loc__qad01 loc_domain)
         where loc_mstr.loc_domain = global_domain
         and   loc_site            = p_site
         and   loc_loc             = p_location
      no-lock:
         l_status = loc_status.
      end. /* FOR FIRST loc_mstr */

      if not available loc_mstr
      then do:

         for first si_mstr
            where si_mstr.si_domain = global_domain
            and   si_site           = p_site
         no-lock:
            l_status = si_status.
         end. /* FOR FIRST si_mstr */
         if not si_auto_loc
         then do:
            p_undotran = Yes.
            {pxmsg.i &MSGNUM=709
                     &ERRORLEVEL=3
                     &PAUSEAFTER=true}
            undo, retry.
         end. /*IF NOT si_auto_loc*/
      end. /* IF NOT AVALIABLE loc_mstr */

   /* MAKE SURE STATUS CODE EXISTS AND TRANSTYPE ALLOWED */
   for first is_mstr
      fields (is_status is_domain)
      where is_mstr.is_domain = global_domain
      and   is_status         = l_status
   no-lock:
   end. /* FOR FIRST is_mstr */

   if not available is_mstr
   then do:
      /* INVENTORY STATUS IS NOT DEFINED */
      {pxmsg.i &MSGNUM=361 &ERRORLEVEL=3}
      undo, retry.
   end.

   for first isd_det
      fields (isd_tr_type isd_status isd_bdl_allowed isd_domain)
      where isd_det.isd_domain = global_domain
      and   isd_tr_type        = p_transtype
      and   isd_status         = is_status
   no-lock:
   end. /* FOR FIRST isd_det */

   if available isd_det
   then do:
      if (batchrun            =  yes
          and isd_bdl_allowed <> yes)
         or batchrun <> yes
      then do:
      p_undotran = yes.
         /* TRANSACTION RESTRICTED FOR SITE/LOC */
         {pxmsg.i &MSGNUM=7086 &ERRORLEVEL=3
                  &MSGARG1=p_transtype
                  &MSGARG2=p_site
                  &MSGARG3=p_location}
         undo, retry.
      end. /* IF batchrun = yes */
   end. /* IF AVAILABLE isd_det */

END PROCEDURE. /* p_validateTransaction */
