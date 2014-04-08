/* poporcm.p - PURCHASE ORDER RECEIPT W/ SERIAL NUMBER CONTROL                */
/* Copyright 1986 QAD Inc. All rights reserved.                               */
/* $Id:: poporcm.p 32247 2013-06-20 14:55:00Z aew                          $: */
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
/* Revision: 1.76     BY: Ed van de Gevel        DATE: 18/03/05   ECO: *R00F* */
/* Revision: 1.77     BY: Andrew Dedman          DATE: 09/06/05   ECO: *R01P* */
/* Revision: 1.78     BY: Ellen Borden           DATE: 12/01/05   ECO: *R000* */
/* Revision: 1.80     BY: SurenderSingh Nihalani DATE: 05/16/06   ECO: *P4PQ* */
/* Revision: 1.81     BY: Robin McCarthy         DATE: 05/31/06   ECO: *R02F* */
/* Revision: 1.82     BY: Shilpa Kamath          DATE: 06/12/06   ECO: *R05X* */
/* Revision: 1.83     BY: SurenderSingh Nihalani DATE: 06/19/06   ECO: *P4S2* */
/* Revision: 1.84     BY: Robin McCarthy         DATE: 06/15/06   ECO: *R04H* */
/* Revision: 1.85     BY: Robin McCarthy         DATE: 06/30/06   ECO: *R04J* */
/* Revision: 1.86     BY: Xavier Prat            DATE: 06/15/06   ECO: *R03Q* */
/* Revision: 1.87     BY: SurenderSingh Nihalani DATE: 06/27/06   ECO: *P4TZ* */
/* Revision: 1.88     BY: Xavier Prat            DATE: 07/13/06   ECO: *R079* */
/* Revision: 1.89     BY: Rafiq S.               DATE: 07/13/06   ECO: *R081* */
/* Revision: 1.91     BY: Archana Kirtane        DATE: 05/25/07   ECO: *P5XG* */
/* Revision: 1.96     BY: Jean Miller            DATE: 09/07/07   ECO: *R0C5* */
/* Revision: 1.97     BY: Robin McCarthy         DATE: 01/11/08   ECO: *R08C* */
/* Revision: 1.98     BY: Antony LejoS           DATE: 06/20/08   ECO: *P6V4* */
/* Revision: 1.99     BY: Mukesh Singh           DATE: 12/31/08   ECO: *Q24C* */
/* Revision: 1.100    BY: Ashim Mishra           DATE: 01/14/09   ECO: *Q27D* */
/* Revision: 1.101    BY: Mukesh Singh           DATE: 03/12/09   ECO: *P61X* */
/* Revision: 1.103    BY: Anil Sudhakaran        DATE: 07/12/09   ECO: *R1LB* */
/* Revision: 1.105    BY: Jiang Wan              DATE: 08/07/09   ECO: *R1N2* */
/* Revision: 1.106    BY: Anil Sudhakaran        DATE: 08/19/09   ECO: *Q38P* */
/* Revision: 1.107    BY: Yizhou Mao             DATE: 09/01/09   ECO: *R1QF* */
/* Revision: 1.109    BY: Devna Sahai            DATE: 01/15/10   ECO: *R1TH* */
/* Revision: 1.110    BY: Avishek Chakraborty    DATE: 04/29/10   ECO: *Q3X0* */
/* $Revision: 1.111 $ BY: Yiqing Chen            DATE: 04/01/10   ECO: *R22Q* */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/******************************************************************************/
/* THIS PROGRAM WAS CLONED TO kbporcm.p 05/16/02, REMOVING UI.                */
/* CHANGES TO THIS PROGRAM MAY ALSO NEED TO BE APPLIED TO kbporcm.p           */
/* ANY CHANGES MADE TO POPORCM.P SHOULD ALSO BE MADE TO PORVISM.P             */
/******************************************************************************/
/* DISPLAY TITLE */

{us/bbi/mfdeclre.i}
{us/gp/gpuid.i}
{us/px/pxsevcon.i} /* SEVERITY PREPROCESSOR CONSTANT DEFINITION INCLUDE FILE */
{us/px/pxmaint.i}  /* STANDARD MAINTENANCE COMPONENT INCLUDE FILE */
{us/px/pxphdef.i mcpl}  /* INCLUDE FILE FOR DEFINING PERSISTENT HANDLE */
{us/px/pxpgmmgr.i} /* INCLUDE FILE FOR RETRIEVING PROGRAM MANAGER */
{us/bbi/gplabel.i}  /* EXTERNAL LABEL INCLUDE */
{us/po/porcsshp.i} /*SUBCONTRACT SHIPPER TEMP TABLE*/
{us/px/pxphdef.i ppitxr}
{us/pp/ppprlst.i}   /* PRICE LIST CONSTANTS */
{us/ap/apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */
{us/px/pxphdef.i soldxr}

/* COMMON VARIABLES, FRAMES & BUFFERS FOR RECEIPTS & RETURNS */
{us/po/porcdef.i "new"}

{us/gp/gpglefdf.i}

/* Define Handles for the programs. */
{us/px/pxphdef.i porcxr}
/*324*/ {xxexrt.i}
define input parameter p_int_ref_type   like lacd_internal_ref_type   no-undo.
define variable        l_poc_seq_rcv    like mfc_logical initial yes  no-undo.
/*@MODULE PRM BEGIN*/
/* DEFINE SHARED TEMP-TABLES FOR PRM */
{us/pj/pjportt.i "new"}
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
   label "Qty Open".
define new shared variable receivernbr         like prh_receiver.
define new shared variable maint               like mfc_logical       no-undo.
define new shared variable fill-all            like mfc_logical
   label "Receive All"   no-undo.
define new shared variable vendlot             like tr_vend_lot       no-undo.
define new shared variable receipt_date        like prh_rcp_date      no-undo.
define new shared variable prm-avail           like mfc_logical       no-undo.
/* KANBAN TRANSACTION NUMBER 0 FOR poporcb8.p, poporcb6.p, poporcc.p */
define new shared variable kbtransnbr          as integer             no-undo.
define new shared variable msg                 as character format "x(60)".
define new shared variable l_include_retain    like mfc_logical initial yes no-undo.
define variable poRctId                    as character format "x(60)" no-undo.
/*324*/ define variable vdrate      as decimal.
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

/* LOGISTICS CHARGE EXCHANGE RATES - ONE FOR EACH CURRENCY - USED
 * TO POPULATE LACOD_DET FROM LACD_DET */
define new shared temp-table tt_lac_exrate no-undo
   field tt_lac_curr    like base_curr
   field tt_lac_exrate  like exr_rate
   field tt_lac_exrate2 like exr_rate2
   field tt_lac_fixed   like po_fix_rate
   index tt_lac_curr
         tt_lac_curr.

/* LOCAL VARIABLES, BUFFERS AND FRAMES */
define variable undo_loop       like mfc_logical                        no-undo.
define variable pook            like mfc_logical.
define variable dbconn          like mfc_logical                        no-undo.
define variable pod-db-name     like pod_po_db                          no-undo.
define variable ers-proc        like poc_ers_proc                       no-undo.
define variable ent_exch        like exr_rate                           no-undo.
define variable ent_exch2       like exr_rate2                          no-undo.
define variable cmmt_yn         like mfc_logical  label "Comments"  no-undo.
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
define variable ordernum        like po_nbr                             no-undo.
define variable newprice        like pod_pur_cost                       no-undo.
define variable dummy_disc      like pod_disc_pct                       no-undo.
define variable rejected        like mfc_logical                        no-undo.
define variable mc-error-number like msg_nbr                            no-undo.
define variable error_flag      as   integer                            no-undo.
define variable err             as   integer                            no-undo.
define variable recno_sr_wkfl   as   recid                              no-undo.
define variable pc_recno        as   recid                              no-undo.
define variable use-log-acctg   as   logical                            no-undo.
define variable l_pt_lot_ser    as   character                          no-undo.
define variable manual_update   as   logical                            no-undo.
define variable l_isAuthorized  as   integer                            no-undo.
/* These variables are used in us/po/poporcm.i */
define variable hBlockedTransactionlibrary  as handle    no-undo.
define variable cBlockedTransactionMnemonic as character no-undo.
define variable lblPONbr        as   character                          no-undo.

/* Variables used by AIM. */
define variable LVQty like pod_qty_chg no-undo.

{us/mg/mgbltrpl.i "hBlockedTransactionlibrary"}

{us/px/pxmaint.i}

/*MAIN-BEGIN*/

/*@MODULE WIPLOTTRACE BEGIN*/
{us/wl/wlfnc.i} /*FUNCTION FORWARD DECLARATIONS*/
/*@MODULE WIPLOTTRACE END*/
{us/gp/gprunpdf.i "mcpl" "p"}

/* DEFINE & INITIALIZE CURRENCY DEPENDENT ROUNDING FORMAT VARS */
{us/po/pocurvar.i "NEW"}
{us/tx/txcurvar.i "NEW"}

/* DEFINE TRAILER VARS AS NEW, SO THAT CORRECT _OLD FORMATS */
/* CAN BE ASSIGNED BASED ON INITIAL DEFINE                  */
{us/po/potrldef.i "NEW"}

{us/tx/txcalvar.i}

{us/mf/mfaimfg.i} /* COMMON API CONSTANTS AND VARIABLES */

{us/po/popoit01.i} /* DEFINE API PURCHASE ORDER TEMP TABLES  */
{us/mc/mctrit01.i} /* DEFINE API TRANSACTION EXCHANGE RATES TEMP TABLE */
{us/ic/icicit01.i} /* DEFINE API INVENTORY CONTROL TEMP TABLES   */
{us/mf/mfctit01.i} /* DEFINE API TRANSACTION COMMENTS TEMP TABLES */

{us/gp/gpldform.i} /* Legal Document Record Form */

if c-application-mode = "API" then do:

   /* GET HANDLE OF API CONTROLLER */
   {us/bbi/gprun.i ""gpaigh.p""
      "(output ApiMethodHandle,
        output ApiProgramName,
        output ApiMethodName,
        output ApiContextString)"}

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


/* THIS PATCH IS NECESSARY WHEN SHORTAGE CLEARANCE FUNCTIONALITY IS   */
/* RUN. IN THAT CASE SOME PICK-SO PROGRAMS (WHICH POPULATED THAT      */
/* TABLES) ARE LAUNCHED TOO.                                          */
if {us/wh/whgpwhon.i} then do:
   {us/so/sosqvars.i "new"}
   {us/so/sotmpdef.i "new"}
end.
assign
   nontax_old    = nontaxable_amt:format
   taxable_old   = taxable_amt:format
   lines_tot_old = lines_total:format
   tax_tot_old   = tax_total:format
   order_amt_old = order_amt:format
   prepaid_old   = po_prepaid:format
   lblPONbr      = getTermLabel("PO_NUMBER",12).

issueld = no.

form
   po_nbr         colon 12   label "Order"
   po_vend
   po_stat
   ps_nbr         format "x(12)" to 78
with frame b side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).


assign
   cmmt-prefix = "RCPT:"
   transtype   = "RCT-PO"
   convertmode = "MAINT".

form
   ordernum       colon 15       label "Order"
   po_vend
   po_stat
   eff_date       colon 68
   ps_nbr         colon 15       label "Packing Slip"
   move           colon 68       label "Move to Next Operation"
   receivernbr    colon 15       label "Receiver"
   vndname        at    27       no-label
   fill-all       colon 68
   rma_bol        colon 15       label "BOL"
   cmmt_yn        colon 68
   ship_date      colon 68       label "Ship Date"
with frame a1 side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a1:handle).

/* IN THE HEADER OF THE RTS SHIPMENT THE receivernbr WILL NOW */
/* BE DISPLAYED WITH THE LABEL "Receiver/RTS Shipper"         */
form
   ordernum       colon 15       label "Order"
   po_vend
   po_stat
   eff_date       colon 68
   ps_nbr         colon 15       no-label
   move           colon 68       no-label
   vndname        at    27       no-label
   fill-all       colon 68       label "Ship All"
   receivernbr    colon 27       label "Receiver/RTS Shipper"
   cmmt_yn        colon 68
   rma_bol        colon 15       label "BOL"
with frame a2 side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a2:handle).

/* Hide the variable "move" from the frame if porec = false */
/* To avoid the value of move getting displayed */
if not porec and c-application-mode <> "API" then
   move:hidden in frame a2 = true.

/* HIDE BOL UNLESS IT IS RTS */
if (porec or (ports <> "RTS")) then do:
   rma_bol:hidden in frame a1 = true.
   rma_bol:hidden in frame a2 = true.
end.
/* DIFFERENT LABELS ARE DISPLAYED FOR SAME VARIABLE, */
/* SO NEED TO ASSIGN LABELS MANUALLY.                */
if dynamic-function('getTranslateFramesFlag' in h-label) then
assign
   receivernbr:label = getTermLabel("RECEIVER/RTS_SHIPPER",26)
   fill-all:label    = getTermLabel("SHIP_ALL",11).

form
   ent_exch colon 15
   space(2)
with frame seta1_sub overlay side-labels
   centered row frame-row(a) + 4.

/* SET EXTERNAL LABELS */
setFrameLabels(frame seta1_sub:handle).

/*@MODULE WIPLOTTRACE BEGIN*/
if is_wiplottrace_enabled() then do:
   run activate_wiplot_trace.
   /*BEGIN*/
   /* INITIALIZE WIP LOT TRACE SCRAP TEMP-TABLE */
   run init_scrap_input_wip_lot_temptable
      in h_wiplottrace_procs.
   /*END*/
end. /* IF IS_WIPLOTTRACE_ENABLED() */
/*@MODULE WIPLOTTRACE END*/

for first poc_ctrl
   where poc_domain = global_domain no-lock:
end.

assign
   rcv_type  = poc_rcv_type
   ers-proc  = poc_ers_proc.

assign
   maint       = true
   shipper_rec = false
   fiscal_rec  = false.


{us/bbi/gprun.i ""socrshc.p""}

for first shc_ctrl
   where shc_domain = global_domain
no-lock: end.

/*@MODULE PRM BEGIN*/
/* CHECK IF PRM IS INSTALLED */
{us/pj/pjchkprm.i}

/* PRM-ENABLED VARIABLE DEFINED IN PJCHKPRM.I */
prm-avail = prm-enabled.
/*@MODULE PRM END*/

/* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
{us/bbi/gprun.i ""lactrl.p"" "(output use-log-acctg)"}

/*DELETE SUBSHIPPER WORK TEMP TABLE RECORDS*/
empty temp-table tt_shipper_scroll no-error.

main-loop:
repeat:

   for first poc_ctrl
      where poc_domain = global_domain no-lock:
   end.

   /* RESET RECEIVE ALL FLAG TO DEFAULT FROM CONTROL FILE */
   /*@MODULE RCV-ALL BEGIN*/
   fill-all  = poc_rcv_all.
   /*@MODULE RCV-ALL END*/

   transtype   = "RCT-PO".

   /* DELETE qad_wkfl RECORDS */
   {us/px/pxrun.i &PROC='DeleteQadwkfl'
      &PROGRAM='porcxr.p'
      &PARAM="(input 'RECEIVER',
        input receivernbr,
        input SessionUniqueID,
        input global_userid)"
      &NOAPPERROR=true
      &CATCHERROR=true}

   if c-application-mode = "API" and retry
      then return error return-value.

   if c-application-mode = "API" then do:
      find next ttPurchaseOrderTrans
      no-lock no-error.
      if not available ttPurchaseOrderTrans then return.
   end.

   /* SPLIT THE ORIGINAL DO TRANSACTION BLOCK INTO TWO DO TRANSACTION */
   /* BLOCKS TO TAKE CARE OF ORACLE TRANSACTION SCOPING PROBLEM  .    */
   /* us/po/poporcm.i MOVED IN THE FIRST DO TRANSACTION BLOCK. COMMENTED    */
   /* CODE RELATED TO FOREIGN CURRENCY AND TRANSACTION COMMENTS FROM  */
   /* us/po/poporcm.i AND COPIED IT IN THIS PROGRAM                         */

   {us/gp/gprunp.i "soldxr" "p" "clearWorkTableOfLGAndGL"}

   do transaction:
      if porec
      then do:
         {us/po/poporcm.i &frame=a1}
      end. /* IF porec */
      else do:
         {us/po/poporcm.i &frame=a2}
      end. /* ELSE DO: */
      if execname = "fsrtvis.p"
      then do:
         if can-find (mfc_ctrl
            where mfc_ctrl.mfc_domain = global_domain
            and   mfc_field           = "enable_supplier_perf"
            and   mfc_logical)
            and   can-find (_File where _File-name = "vef_ctrl")
            and   receivernbr = ""
         then
            run getNextReceiverNbr (output receivernbr).

      end. /* IF EXECNAME = "fsrtvis.p" */
      else do:

         {us/px/pxrun.i &PROC = 'getReceiverPolicy' &PROGRAM = 'porcxr.p'
                  &HANDLE = ph_porcxr
                  &PARAM = "(output rcv_type,
                             output l_poc_seq_rcv)"
                  &CATCHERROR = true
                  &NOAPPERROR = true}

         if (   rcv_type    <> 2
            and receivernbr = ""
            and not l_poc_seq_rcv)
         then
            run getNextReceiverNbr (output receivernbr).

      end. /* NOT IF EXECNAME = "fsrtvis.p" */

   end. /* DO TRANSACTION */

/*324*/ if base_curr <> po_curr then do:
/*324*/    vdrate = getExratefromcodemstr(input po_curr,input base_curr,input eff_date).
/*324*/    if vdrate = -65535 then do:
/*324*/        {us/bbi/pxmsg.i &MSGNUM=81 &ERRORLEVEL={&APP-ERROR-RESULT}}
/*324*/        undo,retry.
/*324*/    end.
/*324*/ end.

   skipBlock:
   do:
      updateBlock:
      do on stop undo, leave:

         TRANSDO-BLOCK:
         do transaction:

            empty temp-table tt_lac_exrate .

            if base_curr <> po_curr
            then do:
               if not po_fix_rate
               then do:
                  seta1_sub:
                  do on error undo, retry:
                     if c-application-mode = "API"
                     then do:
                        {us/gp/gpttcp.i
                           ttPurchaseOrderTrans
                           ttTransExchangeRates
                           "ttPurchaseOrderTrans.nbr = po_mstr.po_nbr"
                           }
                        run setTransExchangeRates in apiMethodHandle
                           (input table ttTransExchangeRates).
                     end.  /* IF c-application-mode .. */

                     pause 0 before-hide.
/*324*/         {us/gp/gprunp.i "mcui" "p" "mc-ex-rate-input"
                        "(input po_curr,
                          input base_curr,
                          input eff_date,
                          input exch_exru_seq,
                          input false,
                          input frame-row(a) + 4,
                          input-output exch_rate,
                          input-output exch_rate2,
                          input-output po_fix_rate)"}
                     pause 0 before-hide.

                    /* CAPTURE EXCHANGE RATES */
                    for first lacd_det where
                       lacd_domain = global_domain and
                       lacd_internal_ref = po_nbr and
                       lacd_shipfrom     = po_vend and
                       lacd_internal_ref_type = {&TYPE_PO} and
                       lacd_curr = po_curr exclusive-lock:

                       create tt_lac_exrate .
                       assign tt_lac_exrate.tt_lac_curr    = lacd_curr
                              tt_lac_exrate.tt_lac_exrate  = exch_rate
                              tt_lac_exrate.tt_lac_exrate2 = exch_rate2
                              tt_lac_exrate.tt_lac_fixed   = lacd_fixed.
                    end.


                     if keyfunction(lastkey) = "end-error"
                        then
                        undo seta1_sub, retry seta1_sub.
                  end. /* DO ON ERROR UNDO, RETRY */
               end. /*IF NOT po_fix_rate */
            end. /* IF base_curr <> po_curr */

            /* GET LOGISTIC CHARGES IF THE CURRENCY DOES NOT MATCH BASE CURR */
            if can-find (first lacd_det where
                               lacd_domain = global_domain and
                               lacd_internal_ref = po_nbr and
                               lacd_shipfrom     = po_vend and
                               lacd_internal_ref_type = {&TYPE_PO}) then do:

               /* CAPTURE EXCHANGE RATES */
               for each lacd_det where
                        lacd_domain = global_domain   and
                        lacd_internal_ref = po_nbr and
                        lacd_shipfrom     = po_vend and
                        lacd_internal_ref_type = {&TYPE_PO} exclusive-lock break by
                        lacd_curr:

                  if last-of(lacd_curr) then do:
                     create tt_lac_exrate .
                     assign tt_lac_exrate.tt_lac_curr    = lacd_curr
                            tt_lac_exrate.tt_lac_exrate  = lacd_ex_rate
                            tt_lac_exrate.tt_lac_exrate2 = lacd_ex_rate2
                            tt_lac_exrate.tt_lac_fixed   = lacd_fixed.
                  end.
               end.

               /* UPDATE THE MATCHING CURRENCY OF THE PO */
               /* WE DO NOT WANT TO ASK FOR THE CURRENCY FOR LA CHARGES
                  IF THEY MATCH THE PO CURRENCY */
               for each tt_lac_exrate where
                        tt_lac_exrate.tt_lac_curr = po_curr exclusive-lock :

                   assign tt_lac_exrate.tt_lac_exrate  = exch_rate
                          tt_lac_exrate.tt_lac_exrate2 = exch_rate2.
               end.

               /* GO THROUGH AND CAPTURE THE EXCHANGE RATES WHERE CURRENCY NOT LIKE
                * THE PO */
               for each tt_lac_exrate where tt_lac_exrate.tt_lac_curr <> po_curr
                   exclusive-lock:

                   pause 0 before-hide.
/*324*/         {us/gp/gprunp.i "mcui" "p" "mc-ex-rate-input"
                      "(input tt_lac_exrate.tt_lac_curr,
                        input base_curr,
                        input eff_date,
                        input exch_exru_seq,
                        input false,
                        input frame-row(a) + 4,
                        input-output tt_lac_exrate.tt_lac_exrate,
                        input-output tt_lac_exrate.tt_lac_exrate2,
                        input-output tt_lac_exrate.tt_lac_fixed)"}
                   pause 0 before-hide.
               end.

               if keyfunction(lastkey) = "end-error" then
                  undo TRANSDO-BLOCK, retry TRANSDO-BLOCK.

               for each tt_lac_exrate no-lock:

                  for each lacd_det where
                           lacd_domain = global_domain and
                           lacd_internal_ref = po_nbr and
                           lacd_shipfrom     = po_vend and
                           lacd_internal_ref_type = {&TYPE_PO} and
                           lacd_curr = tt_lac_exrate.tt_lac_curr exclusive-lock:


                      for each lacod_det of lacd_det exclusive-lock:

                          assign
                             lacod_ex_rate  = tt_lac_exrate.tt_lac_exrate
                             lacod_ex_rate2 = tt_lac_exrate.tt_lac_exrate2.

                      end.
                  end.
               end.
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
                  {us/gp/gpttcp.i
                     ttPurchaseOrderTransCmt
                     ttTransComment
                     "ttPurchaseOrderTransCmt.nbr = po_mstr.po_nbr"
                     true
                     }
                  run setTransComment in apiMethodHandle
                     (input table ttTransComment).
               end. /* IF c-application-mode = .. */

               do on error undo, return error return-value:
                  {us/bbi/gprun.i ""gpcmmt01.p"" "(input ""po_mstr"")"}
               end. /* do on error undo, return .. */

               po_cmtindx = cmtindx.
            end. /* IF cmmt_yn */


            if porec
            then do:

               /* POP-UP TO COLLECT SHIPMENT INFORMATION */
               if shc_ship_rcpt
               then do:

                  if c-application-mode = "API" then do:
                     {us/gp/gpttcp.i
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
                     {us/bbi/gprun.i ""icshup.p""
                        "(input-output shipnbr,
                          input-output ship_date,
                          input-output inv_mov,
                          input 'RCT-PO', no,
                          input 10, input 20)"}
                  end.
               end. /* IF shc_ship_rcpt */

               run proc-sup-perf.

            end. /* IF porec */

            {us/gp/gpbrparm.i &browse=gplu908.p &parm=c-brparm1 &val=po_nbr}


            {us/px/pxrun.i
               &PROC='clearPOReceiptDetails'
               &PROGRAM='porcxr2.p'
               &NOAPPERROR=true
               &CATCHERROR=true}

            /* Transaction */


            run initialize_lines
               (input po_nbr, input po_vend, input po_curr).


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
      /*jpm*/ /*Temporarily remove PRM */
      /*

            if porec
               and prm-avail
            then do:
               empty temp-table ttprm-det no-error.
               empty temp-table ttpao-det no-error.
            end. /* IF POREC AND PRM-AVAIL */
            /*@MODULE PRM END*/
      */
            /* EMPTY LOGISTICS ACCOUNTING TEMP TABLE */
            for each tt-pvocharge exclusive-lock:
               delete tt-pvocharge.
            end.

            /* DISPLAY WARNING MESSAGE WHEN RECEIVE ALL IS YES */
            /* FOR LOT/SERIAL CONTROLLED ITEMS                 */
            if fill-all = yes
            then do:

               for each pod_det
                     where pod_domain = global_domain
                     and   pod_nbr    = po_nbr
                     and   pod_status = ""
                  no-lock use-index pod_nbrln:

                  for first pt_mstr
                     where pt_domain = global_domain
                     and   pt_part   = pod_part
                  no-lock:
                  end. /* FOR FIRST pt_mstr */

                  if available pt_mstr then do:
                     {us/px/pxrun.i &PROC  = 'getFieldDefault' &PROGRAM = 'ppitxr.p'
                              &HANDLE = ph_ppitxr
                              &PARAM = "( input  pod_part,
                                          input  pt_site,
                                          input ""pt_lot_ser"",
                                          output l_pt_lot_ser)"
                              &NOAPPERROR = true
                              &CATCHERROR = true}
                  end.

                  if available pt_mstr
                     and l_pt_lot_ser <> ""
                  then do:

                     /* LOT/SERIAL-CONTROLLED ITEMS EXIST. PLEASE CHECK QUANTITIES. */
                     {us/bbi/pxmsg.i &MSGNUM     = 6380
                        &ERRORLEVEL = 2}
                     leave.
                  end. /* IF AVAILABLE pt_mstr */

               end. /* FOR EACH pod_det */

            end. /* IF fill-all */


            /* RUN poporca.p TO SELECT EDIT ITEMS TO BE RECEIVED */
            assign
               lotserial = ""
               po_recno  = recid(po_mstr)
               proceed   = no.

            do on error undo, return error return-value:

               /* PASSES THE TEMP-TABLE AS AN OUTPUT PARAMETER THROUGH */
               /* POPORCA.P WHICH HAS TO BE USED IN POTAXDT.P          */

               {us/bbi/gprun.i ""poporca.p""
                  "(input p_int_ref_type,
                    input-output table tt_shipper_scroll,
                    output manual_update,
                    input-output shipnbr,
                    input-output inv_mov,
                    output table tt_po_tax)"}
            end.

            if (receivernbr <> "")
            and ( can-find(first prh_hist
                             where prh_domain   = global_domain
                             and   prh_receiver = receivernbr
                          )
                )
            then do:
               /* RECEIVER NUMBER ALREADY EXISTS */
               {us/bbi/pxmsg.i &MSGNUM=355 &ERRORLEVEL={&APP-ERROR-RESULT}}
               hide frame b no-pause.
               undo main-loop, retry main-loop.
            end. /* IF (receivernbr <> "") */

            /* UPDATE RMA BOL */
            if (not porec and ports = "RTS") then do:
               find first rma_mstr where
                  rma_domain = po_domain and
                  rma_nbr = po_nbr and
                  rma_prefix = "V"
               no-error.
               if available rma_mstr then
                  assign rma_rts_bol = rma_bol.
               release rma_mstr.
            end.

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
                  end. /*if pod_qty_chg <> 0*/
            end. /*for each pod_det*/

            /*********************************************************/
            /* If this is a return to supplier then reverse the sign */
            /*********************************************************/
            if not porec
               then

            run proc-rts (input po_nbr).

            run create_update_trans
               (input proceed,
               input shipnbr,
               input ship_date,
               input inv_mov,
               input no,
               input 0,
               input """",
               input table tt_shipper_scroll,
               input manual_update,
               input p_int_ref_type).


         end. /* DO TRANSACTION */

         leave skipBlock.
      end. /* UPDATEBLOCK */

      /* WHEN CTRL-C IS PRESSED WE NEED TO UNDO THE lgd_mstr */
      run clearEmptyLD(input lgdkey, yes).
      stop.
   end. /* SKIPBLOCK */

   /* CALCULATE AND EDIT TAXES */
   if proceed = yes
   then do:
      undo_trl2 = true.
      {us/bbi/gprun.i ""porctrl2.p""}
      if undo_trl2 then undo.

      /* PASSED THE SECOND PARAMETER AS TEMP-TABLE CONTAINING THE */
      /* RECEIVED LINES SO THAT POTAXDT.P WILL EDIT ONLY RECEIVED */
      /* LINES WHEN ALL TAX TYPES HAVE TAX BY LINE AS YES         */
      {us/bbi/gprun.i ""potaxdt.p""
         "(input po_recno,
           input table tt_po_tax)"}.

   end. /* IF PROCEED = YES AND .. */

   for each tt_po_tax
      exclusive-lock:
      delete tt_po_tax.
   end. /* FOR EACH tt_po_tax */

   if c-application-mode <> "API" then
      hide frame b no-pause.

   release po_mstr.

   do transaction:
      find qad_wkfl
         where qad_wkfl.qad_domain = global_domain
         and   qad_key1 = "ABS_ID"
         and   qad_key2 = SessionUniqueID
      exclusive-lock no-error.
      if available qad_wkfl then delete qad_wkfl.
   end.

   /* Do Fiscal Confirm */
   run clearEmptyLD(input lgdkey, yes).

   {us/gp/gprunp.i "soldxr" "p" "updateLegalNumToUnpostedGL"}

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
</Comment1>
------------------------------------------------------------------------------*/
   {us/bbi/gprun.i ""wlpl.p"" "persistent set h_wiplottrace_procs"}

   {us/bbi/gprun.i ""wlfl.p"" "persistent set h_wiplottrace_funcs"}

END PROCEDURE.

/*============================================================================*/
PROCEDURE create_update_trans:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
create_update_trans (
)
</Comment1>
------------------------------------------------------------------------------*/
   define input parameter proceed   like mfc_logical     no-undo.
   define input parameter shipnbr   like tr_ship_id      no-undo.
   define input parameter ship_date like prh_ship_date   no-undo.
   define input parameter inv_mov   like tr_ship_inv_mov no-undo.
   define input parameter ip_usage  as logical           no-undo.
   define input parameter ip_usage_qty as decimal no-undo.
   define input parameter ip_trnbr as character no-undo.
   define input parameter table for tt_shipper_scroll.
   define input parameter manual_update as logical no-undo.
   define input parameter p_int_ref_type   like lacd_internal_ref_type   no-undo.
   /* RUN poporcb.p TO CREATE RECEIPTS & UPDATE TRANSACTIONS */
   if proceed = yes then do:
      {us/px/pxrun.i &PROC='commitReceipt' &PROGRAM='porcxr.p'
         &PARAM="(input shipnbr,
           input ship_date,
           input inv_mov,
           input ip_usage,
           input ip_usage_qty,
           input ip_trnbr,
           input p_int_ref_type)"
         &NOAPPERROR=true
         &CATCHERROR=true}

      {us/bbi/gprun.i ""poporcd.p""}

      if manual_update then do:
         {us/bbi/gprun.i ""porcshpu.p""
            "(input table tt_shipper_scroll)"}
      end.

   end. /* IF PROCEED = YES */

END PROCEDURE.

/*============================================================================*/
PROCEDURE del-sr-wkfl:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
del-sr-wkfl (
)
</Comment1>
------------------------------------------------------------------------------*/
   {us/px/pxrun.i &PROC='clearPOReceiptDetails' &PROGRAM='porcxr2.p'
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
</Comment1>
------------------------------------------------------------------------------*/
   for each sr_wkfl
         where sr_wkfl.sr_domain = global_domain and  sr_userid = SessionUniqueID
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
</Comment1>
------------------------------------------------------------------------------*/
   define input parameter inpar_nbr  like pod_nbr      no-undo.
   define input parameter inpar_line like pod_line     no-undo.
   define input parameter inpar_site like pod_site     no-undo.
   define input parameter inpar_loc  like pod_loc      no-undo.
   define input parameter inpar_type like pod_rma_type no-undo.

   for first rmd_det
      where rmd_domain = global_domain
      and   rmd_nbr    = inpar_nbr
      and   rmd_prefix = "V"
      and   rmd_line   = inpar_line
   no-lock: end.

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
</Comment1>
------------------------------------------------------------------------------*/
   define input parameter inpar_part    like pod_part  no-undo.
   define input parameter inpar_vend    like po_vend   no-undo.
   define input parameter inpar_um      like pod_um    no-undo.
   define input parameter inpar_curr    like po_curr   no-undo.
   define input parameter l_inpar_vpart like pod_vpart no-undo.

   set_flag = no.

   /* ADDED VP_VEND_VPART IN THE FIELD LIST BELOW */
   {us/px/pxrun.i &PROC='processRead' &PROGRAM='ppsuxr.p'
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
</Comment1>
------------------------------------------------------------------------------*/

   define input parameter site       like pod_site               no-undo.
   define input parameter loc        like pod_loc                no-undo.
   define input parameter part       like pod_part               no-undo.
   define input parameter serial     like pod_serial             no-undo.
   define output parameter undo_loop like mfc_logical initial no no-undo.

   if porec or is-return then do:
      /* CHECK FOR SINGLE ITEM / SINGLE LOT/SERIAL LOCATION */
      for first loc_mstr
         where loc_domain = global_domain
         and   loc_site   = site
         and   loc_loc    = loc
      no-lock:
      end. /*FOR FIRST loc_mstr*/

      if available loc_mstr and loc_single = yes then do:
         recno_sr_wkfl = recid(sr_wkfl).
         run proc-gploc02 (input loc__qad01).

         error_flag = err.

         if error_flag = 0 and loc__qad01 = yes then do:
            /* CHECK PRIOR RECEIPT TRANSACTIONS (ld_det's) FOR
            DIFFERENT ITEMS OR LOT/SERIALS IN SAME LOCATION */
            {us/bbi/gprun.i ""gploc01.p""
               "(site,
                 loc,
                 part,
                 serial,
                 "" "",
                 loc__qad01,
                 output error_flag)"}

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
</Comment1>
------------------------------------------------------------------------------*/
   define input parameter ip_po_nbr  as character no-undo.
   define input parameter ip_po_vend as character no-undo.
   define input parameter ip_po_curr as character no-undo.

   define variable l_si_db like si_db no-undo.
   define variable vCancelBackOrder like mfc_logic no-undo.
   define variable vSiteId as character no-undo.
   define variable l_ordqty      like pod_qty_ord  no-undo.

   define buffer    b_pod_det    for pod_det.
   define buffer buff_pod_det for pod_det.

   /* DETAIL FRAME C AND SINGLE LINE PROCESSING FRAME D */
   preppoddet:
   for each pod_det
         where pod_det.pod_domain = global_domain and  pod_nbr = ip_po_nbr
         and pod_status <> "c"
         and pod_status <> "x":

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

      {us/px/pxrun.i &PROC='getSiteDatabase' &PROGRAM='icsixr.p'
         &PARAM="(input  pod_site,
           output l_si_db)"
         &NOAPPERROR=true
         &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT}
         or l_si_db <> global_db then
            next preppoddet.

      /*@MODULE RCV-ALL BEGIN*/
      {us/px/pxrun.i &PROC='processRead' &PROGRAM='ppitxr.p'
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

      if fill-all = yes
      then do:
         rejected  = no.
         if available pt_mstr then do:
            {us/px/pxrun.i &PROC  = 'getFieldDefault' &PROGRAM = 'ppitxr.p'
                     &HANDLE = ph_ppitxr
                     &PARAM = "( input  pod_part,
                                 input  pod_site,
                                 input ""pt_lot_ser"",
                                 output l_pt_lot_ser)"
                     &NOAPPERROR = true
                     &CATCHERROR = true}
         end.

         /* ONLY AUTO-FILL PARTS THAT ARE NOT LOT/SERIAL CONTROLLED */
         /* AND HAVE NO ATTRIBUTE (ERROR-FLAG = NO) CONFLICTS       */
         if not err_flag
            and (not available pt_mstr
                 or (available pt_mstr
                        and l_pt_lot_ser = ""
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

                  l_ordqty = ((pod_det.pod_qty_ord
                                  - pod_det.pod_qty_rcvd)
                                     * pod_det.pod_um_conv).

                  for each b_pod_det
                     where b_pod_det.pod_domain =  pod_det.pod_domain
                     and   b_pod_det.pod_part   =  pod_det.pod_part
                     and   b_pod_det.pod_nbr    =  pod_det.pod_nbr
                     and   b_pod_det.pod_site   =  pod_det.pod_site
                     and   b_pod_det.pod_loc    =  pod_det.pod_loc
                     and   b_pod_det.pod_line   <> pod_det.pod_line
                  no-lock:
                     l_ordqty = l_ordqty + ((b_pod_det.pod_qty_ord
                                                - b_pod_det.pod_qty_rcvd)
                                                   * b_pod_det.pod_um_conv).
                  end. /* FOR EACH b_pod_det */

                  {us/bbi/gprun.i ""icedit2.p""
                  "(input ""RCT-PO"",
                    input pod_site,
                    input pod_loc,
                    input pod_part,
                    input """",
                    input """",
                    input l_ordqty,
                    input pod_um,
                    input pod_nbr,
                    input string(pod_line),
                    output rejected)"}
               end. /* ELSE DO */
            end. /* IF POD_TYPE = "" AND POD_FSM_TYPE = "" */
            /*@MODULE RTS BEGIN*/
            /* RTS's generated by field service need sites, and  */
            /* locations identified. And qty properly expressed. */
            else if pod_fsm_type <> ""
            then do:
               assign
                  rejected  = no
                  reject1   = no
                  reject2   = no
                  issqty    = (pod_qty_ord - pod_qty_rcvd) * pod_um_conv.
               if pod_fsm_type = "RTS-ISS"
               then
                  for each b_pod_det
                     where b_pod_det.pod_domain =  pod_det.pod_domain
                     and   b_pod_det.pod_part   =  pod_det.pod_part
                     and   b_pod_det.pod_nbr    =  pod_det.pod_nbr
                     and   b_pod_det.pod_site   =  pod_det.pod_site
                     and   b_pod_det.pod_loc    =  pod_det.pod_loc
                     and   b_pod_det.pod_line   <> pod_det.pod_line
                  no-lock:
                     issqty = issqty + ((b_pod_det.pod_qty_ord
                                            - b_pod_det.pod_qty_rcvd)
                                               * b_pod_det.pod_um_conv).
                  end. /* FOR EACH b_pod_det */
               run find-rmd-det
                  (input pod_nbr, input pod_line, input pod_site,
                   input pod_loc, input pod_rma_type).

               /* RTS's receipts that have been previously  */
               /* issued from inventory do not need to test */
               /* the from site.                            */
               if fromsite <> "" then do:
                  {us/bbi/gprun.i ""icedit2.p""
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
               end. /* IF FROMSITE <> "" */

               /* RTS issues from inventory do not need to */
               /* test the tosite.                         */
               if tosite <> "" then do:
                  {us/bbi/gprun.i ""icedit2.p""
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
               end. /* IF TOSITE <> "" */

               if reject1 or reject2 then rejected = yes.
            end. /* ELSE IF POD_FSM_TYPE <> "" */
            /*@MODULE RTS END*/
            {us/bbi/gprun.i ""gpsiver.p""
                      "(input pod_site,
                        input ?,
                        output l_isAuthorized)"}
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
               {us/bbi/gprun.i ""rsoqty.p""
                  "(input  recid(pod_det),
                    input  eff_date,
                    output qopen)"}
               pod_bo_chg = qopen.
            end. /* ELSE DO: */
         end. /* ELSE DO: */

         /*! CHECK PRICE LIST FOR SCHEDULED ITEMS */
         if pod_sched and not pod_fix_pr then do:
            {us/bbi/gprun.i ""gpsct05.p""
                     "(input       pod_part,
                       input       pod_site,
                       input       2,
                       output      glxcst,
                       output      curcst)"}

            glxcst = glxcst * pod_um_conv.

            if ip_po_curr <> base_curr then do:
               {us/px/pxrun.i &PROC='mc-curr-conv'
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

               if mc-error-number <> 0 then do:
                  {us/bbi/pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.
            end. /* IF po_curr <> base_curr */

            if use-log-acctg then do:

               po_recno  = recid(po_mstr).

               if po_tot_terms_code <> "" then

               glxcst = pod_pur_cost.

            end. /* if use-log-acctg */

            dummy_disc = 0.
            {us/bbi/gprun.i ""gppccal.p""
                     "(input        pod_part,
                       input        qopen,
                       input        pod_um,
                       input        pod_um_conv,
                       input        ip_po_curr,
                       input        {&SUPPLIER-CLASSIFICATION},
                       input        pod_pr_list,
                       input        eff_date,
                       input        glxcst,
                       input        no,
                       input        dummy_disc,
                       input-output glxcst,
                       output       dummy_disc,
                       input-output newprice,
                       output       pc_recno)" }

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

         do for buff_pod_det:
            find buff_pod_det
               where recid(buff_pod_det) = recid(pod_det)
            no-lock no-error.
         end. /* DO FOR buff_pod_det */

         if pod_qty_chg <> 0 then do:
            create sr_wkfl.
            assign
               sr_domain = global_domain
               sr_userid = SessionUniqueID
               sr_lineid = string(pod_line)
               sr_site   = pod_site
               sr_loc    = pod_loc
               sr_lotser = ""
               sr_ref    = ""
               sr_qty    = pod_qty_chg.
            if recid(sr_wkfl) = -1 then .
            /* FORCE AIM TRIGGER EXECUTION */
            if {us/wh/whgpwhon.i} then do:
               assign LVQty = pod_qty_chg
                      pod_qty_chg = 0.

               assign pod_qty_chg = LVQty
                    sr_user2 = pod_part.
            end.
         end. /* IF POD_QTY_CHG <> 0 */

         run if_porec_or_is_return
            (input pod_site,   input  pod_loc, input pod_part,
             input pod_serial, output undo_loop).

         if undo_loop then undo preppoddet, next preppoddet.

         {us/bbi/gprun.i ""gpsiver.p""
            "(input pod_site,
              input ?,
              output return_int)"}

      end. /* IF FILL-ALL = YES */
      /*@MODULE RCV-ALL END*/


      {us/px/pxrun.i &PROC='assignDefaultsForNewLine' &PROGRAM='porcxr1.p'
               &PARAM="(buffer pod_det,
                        input  fill-all,
                        output vCancelBackOrder,
                        output vSiteId)"
               &NOAPPERROR=true
               &CATCHERROR=true}


   end. /* FOR EACH POD_DET */

END PROCEDURE.

/*============================================================================*/
PROCEDURE p-assign:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
p-assign (
)
</Comment1>
------------------------------------------------------------------------------*/

   define input  parameter l_pod_sched    like pod_sched    no-undo.
   define input  parameter l_qty_ord      like pod_qty_ord  no-undo.
   define input  parameter l_qty_rcvd     like pod_qty_rcvd no-undo.
   define input  parameter l_recid        as   recid        no-undo.
   define output parameter l_qty_chg      like pod_qty_chg  no-undo.

   if not l_pod_sched then
      assign l_qty_chg  = l_qty_ord - l_qty_rcvd.
   else do:
      {us/bbi/gprun.i ""rsoqty.p""
         "(input l_recid,
           input eff_date,
           output qopen)"}
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
</Comment1>
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

   {us/px/pxrun.i &PROC='initializeAttributes' &PROGRAM='porcxr1.p'
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
</Comment1>
------------------------------------------------------------------------------*/

   define input parameter loc__qad01 like loc__qad01 no-undo.

   for first sr_wkfl
      where recid(sr_wkfl) = recno_sr_wkfl:
   end. /* FOR FIRST SR_WKFL */

   {us/gp/gploc02.i  "buff1.pod_domain = global_domain and " pod_det pod_nbr
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
</Comment1>
------------------------------------------------------------------------------*/

   /* MESSAGE #596 - TRANSACTION CONFLICTS WITH SINGLE ITEM/LOT LOCATION */
   {us/bbi/pxmsg.i
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
</Comment1>
------------------------------------------------------------------------------*/
   define input parameter inpar_part like pod_part no-undo.

   /* UNABLE TO ISSUE OR RECEIVE FOR ITEM */
   {us/bbi/pxmsg.i &MSGNUM=161 &ERRORLEVEL={&WARNING-RESULT}
            &MSGARG1=inpar_part}

END PROCEDURE.

/*============================================================================*/
PROCEDURE proc-rts:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
proc-rts (
)
</Comment1>
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
            where sr_wkfl.sr_domain = global_domain and  sr_userid = SessionUniqueID
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
</Comment1>
------------------------------------------------------------------------------*/
   /** POP-UP TO COLLECT PERFORMANCE RECEIPT DATE **/
   /** CHECK THAT SUPPLIER PERFORMANCE DATA SHOULD BE COLLECTED **/
   if {us/px/pxfunct.i &FUNCTION = 'isSupplierPerformanceEnabled' &PROGRAM = 'adsuxr.p'}
   then do:
      {us/bbi/gprun.i ""popove.p""
               "(input recid(po_mstr))"}
   end. /* IF ENABLE SUPPLIER PERFORMANCE */

END PROCEDURE.

/*============================================================================*/
PROCEDURE proc1-mfmsg02:
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
proc1-mfmsg02 (
)
</Comment1>
------------------------------------------------------------------------------*/
   define input parameter inpar_status like pt_status no-undo.

   /* MESSAGE #373 - RESTRICTED TRANSACTION FOR STATUS CODE: */
   {us/bbi/pxmsg.i
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
            {us/bbi/pxmsg.i &MSGNUM=709
                     &ERRORLEVEL=3
                     &PAUSEAFTER=true}
            undo, retry.
         end. /*IF NOT si_auto_loc*/
      end. /* IF NOT AVALIABLE loc_mstr */

   /* MAKE SURE STATUS CODE EXISTS AND TRANSTYPE ALLOWED */
   for first is_mstr
      where is_mstr.is_domain = global_domain
      and   is_status         = l_status
   no-lock:
   end. /* FOR FIRST is_mstr */

   if not available is_mstr
   then do:
      /* INVENTORY STATUS IS NOT DEFINED */
      {us/bbi/pxmsg.i &MSGNUM=361 &ERRORLEVEL=3}
      undo, retry.
   end.

   for first isd_det
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
         {us/bbi/pxmsg.i &MSGNUM=7086 &ERRORLEVEL=3
                  &MSGARG1=p_transtype
                  &MSGARG2=p_site
                  &MSGARG3=p_location}
         undo, retry.
      end. /* IF batchrun = yes */
   end. /* IF AVAILABLE isd_det */

END PROCEDURE. /* p_validateTransaction */

PROCEDURE getNextReceiverNbr:
   define output parameter p_ReceiverNbr like prh_receiver no-undo.
   define buffer poc_ctrl for poc_ctrl.

   {us/mf/mfnctrlc.i "poc_ctrl.poc_domain = global_domain" "poc_ctrl.poc_domain"
   "prh_hist.prh_domain = global_domain"
      poc_ctrl
      poc_rcv_pre
      poc_rcv_nbr
      prh_hist
      prh_receiver
      p_ReceiverNbr}
END PROCEDURE. /* getNextReceiverNbr */
