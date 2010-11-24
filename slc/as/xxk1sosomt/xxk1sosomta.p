/* sosomta.p - SALES ORDER MAINTENANCE SINGLE LINE ITEMS                      */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 6.0      LAST MODIFIED: 03/19/90   BY: ftb *D007*                */
/* REVISION: 6.0      LAST MODIFIED: 04/06/90   BY: ftb *D002*added site      */
/* REVISION: 6.0      LAST MODIFIED: 04/10/90   BY: MLB *D021*                */
/* REVISION: 6.0      LAST MODIFIED: 07/06/90   BY: EMB *D040*                */
/* REVISION: 6.0      LAST MODIFIED: 08/09/90   BY: MLB *D055*                */
/* REVISION: 6.0      LAST MODIFIED: 12/06/90   BY: MLB *D238*                */
/* REVISION: 6.0      LAST MODIFIED: 12/14/90   BY: AFS *D260*                */
/* REVISION: 6.0      LAST MODIFIED: 04/10/91   BY: WUG *D512*                */
/* REVISION: 6.0      LAST MODIFIED: 09/17/91   BY: MLV *F015*                */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*                */
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 11/13/91   BY: WUG *D887*                */
/* REVISION: 6.0      LAST MODIFIED: 11/18/91   BY: afs *D934*                */
/* REVISION: 7.0      LAST MODIFIED: 03/23/92   BY: dld *F297*                */
/* REVISION: 7.0      LAST MODIFIED: 03/27/92   BY: pma *F315*                */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: afs *F356*                */
/* REVISION: 7.0      LAST MODIFIED: 04/16/92   BY: dld *F382*                */
/* REVISION: 7.0      LAST MODIFIED: 05/06/92   BY: tjs *F470*                */
/* REVISION: 7.0      LAST MODIFIED: 06/10/92   BY: tjs *F504*                */
/* REVISION: 7.3      LAST MODIFIED: 09/15/92   BY: tjs *G035*                */
/* REVISION: 7.3      LAST MODIFIED: 11/17/92   BY: tjs *G191*                */
/* REVISION: 7.3      LAST MODIFIED: 01/15/93   BY: afs *G501*                */
/* REVISION: 7.3      LAST MODIFIED: 01/21/93   BY: tjs *G579*                */
/* REVISION: 7.3      LAST MODIFIED: 02/04/93   BY: bcm *G415*                */
/* REVISION: 7.3      LAST MODIFIED: 02/24/93   BY: sas *G457*                */
/* REVISION: 7.3      LAST MODIFIED: 04/05/93   BY: bcm *G889*                */
/* REVISION: 7.3      LAST MODIFIED: 04/15/93   BY: tjs *G948*                */
/* REVISION: 7.4      LAST MODIFIED: 06/21/93   BY: pcd *H008*                */
/* REVISION: 7.4      LAST MODIFIED: 10/10/93   BY: cdt *H086*                */
/* REVISION: 7.4      LAST MODIFIED: 10/2/93    BY: cdt *H184*                */
/* REVISION: 7.4      LAST MODIFIED: 11/03/93   BY: bcm *H206*                */
/* REVISION: 7.4      LAST MODIFIED: 11/22/93   BY: afs *H238*                */
/* REVISION: 7.4      LAST MODIFIED: 01/13/94   BY: dpm *GI46*                */
/* REVISION: 7.4      LAST MODIFIED: 02/18/94   BY: afs *FL81*                */
/* REVISION: 7.4      LAST MODIFIED: 03/16/94   BY: afs *H295*                */
/* REVISION: 7.4      LAST MODIFIED: 03/28/94   BY: WUG *GJ21*                */
/* REVISION: 7.4      LAST MODIFIED: 04/08/94   BY: afs *H330*                */
/* REVISION: 7.3      LAST MODIFIED: 04/25/94   BY: cdt *GJ56*                */
/* REVISION: 7.4      LAST MODIFIED: 07/11/94   BY: bcm *H438*                */
/* REVISION: 7.4      LAST MODIFIED: 09/13/94   BY: bcm *H494*                */
/* REVISION: 7.4      LAST MODIFIED: 09/22/94   BY: jpm *GM78*                */
/* REVISION: 7.4      LAST MODIFIED: 10/16/94   BY: dpm *FR95*                */
/* REVISION: 7.3      LAST MODIFIED: 11/01/94   BY: ame *GN90*                */
/* REVISION: 7.3      LAST MODIFIED: 11/16/94   BY: qzl *FT43*                */
/* REVISION: 7.4      LAST MODIFIED: 12/14/94   BY: rxm *F09F*                */
/* REVISION: 7.4      LAST MODIFIED: 01/28/95   BY: ljm *G0D7*                */
/* REVISION: 7.4      LAST MODIFIED: 01/31/95   BY: bcm *F0G8*                */
/* REVISION: 8.5      LAST MODIFIED: 02/17/95   BY: dpm *J044*                */
/* REVISION: 7.4      LAST MODIFIED: 02/27/95   BY: jzw *H0BM*                */
/* REVISION: 7.4      LAST MODIFIED: 03/02/95   BY: aep *F0K6*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: rxm *F0PJ*                */
/* REVISION: 8.5      LAST MODIFIED: 03/05/95   BY: DAH *J042*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 7.4      LAST MODIFIED: 06/15/95   BY: rxm *G0Q5*                */
/* REVISION: 7.3      LAST MODIFIED: 10/12/95   BY: ais *G0Z8*                */
/* REVISION: 8.5      LAST MODIFIED: 11/07/95   BY: *J053* T. Farnsworth      */
/* REVISION: 8.5      LAST MODIFIED: 12/05/95   BY: *J04C* Tom Vogten         */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 04/29/96   BY: *J0KJ* Dennis Henson      */
/* REVISION: 8.5      LAST MODIFIED: 05/22/96   BY: *J0N2* Dennis Henson      */
/* REVISION: 8.5      LAST MODIFIED: 07/04/96   BY: *J0XR* Dennis Henson      */
/* REVISION: 8.5      LAST MODIFIED: 07/15/96   BY: *J0Z6* Andy Wasilczuk     */
/* REVISION: 8.5      LAST MODIFIED: 07/23/96   BY: *J0R1* Andy Wasilczuk     */
/* REVISION: 8.5      LAST MODIFIED: 08/01/96   BY: *J13C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 09/12/96   BY: *J152* Suresh Nayak       */
/* REVISION: 8.5      LAST MODIFIED: 09/18/96   BY: *G2F7* Sanjay Patil       */
/* REVISION: 8.6      LAST MODIFIED: 09/23/96   BY: *K003* Forrest Mori       */
/* REVISION: 8.6      LAST MODIFIED: 09/27/96   BY: *K007* Srinivasa Sharapady*/
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Elke Van Maele     */
/* REVISION: 8.6      LAST MODIFIED: 11/05/96   BY: *K01T* Stephane Collard   */
/* REVISION: 8.6      LAST MODIFIED: 11/08/96   BY: *J15C* Markus Barone      */
/* REVISION: 8.6      LAST MODIFIED: 01/01/97   BY: *K03Y* Jean Miller        */
/* REVISION: 8.5      LAST MODIFIED: 01/08/97   BY: *J1DS* Sue Poland         */
/* REVISION: 8.6      LAST MODIFIED: 02/15/97   BY: *J1L2* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 02/21/97   BY: *H0SM* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 05/19/97   BY: *K0DF* Taek-Soo Chang     */
/* REVISION: 8.6      LAST MODIFIED: 06/19/97   BY: *J1TL* Molly Balan        */
/* REVISION: 8.6      LAST MODIFIED: 07/15/97   BY: *K0G6* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 07/01/97   BY: *K0DH* Jim Williams       */
/* REVISION: 8.6      LAST MODIFIED: 07/21/97   BY: *K0GS* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 09/21/97   BY: *K0J4* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 09/27/97   BY: *K0HB* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   BY: *J22D* Molly Balan        */
/* REVISION: 8.6      LAST MODIFIED: 12/29/97   BY: *J28V* Surekha Joshi      */
/* REVISION: 8.6      LAST MODIFIED: 01/16/98   BY: *K1BN* Bryan Merich       */
/* REVISION: 8.6      LAST MODIFIED: 01/31/98   BY: *J2D6* Seema Varma        */
/* REVISION: 8.6      LAST MODIFIED: 02/12/98   BY: *K1GQ* Jim Williams       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 03/24/98   BY: *J2FG* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/03/98   BY: *L024* Sami Kureishy      */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* David Morris       */
/* REVISION: 9.0      LAST MODIFIED: 01/12/99   BY: *J38F* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 03/05/99   BY: *M09Y* Katie Hilbert      */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 05/11/99   BY: *J3FL* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney     */
/* REVISION: 9.1      LAST MODIFIED: 07/12/99   BY: *N011* Anup Pereira       */
/* REVISION: 9.1      LAST MODIFIED: 12/15/99   BY: *N05D* Steve Nugent       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 05/30/00   BY: *N0BC* Arul Victoria      */
/* REVISION: 9.1      LAST MODIFIED: 06/19/00   BY: *N0CG* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 06/29/00   BY: *N0DX* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00   BY: *L121* Gurudev Chennuru   */
/* REVISION: 9.1      LAST MODIFIED: 10/20/00   BY: *M0TV* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 11/03/00   BY: *L15F* Kaustubh Kulkarni  */
/* REVISION: 9.1      LAST MODIFIED: 10/20/00   BY: *N0WP* Mudit Mehta        */
/* Revision: 1.59         BY: Katie Hilbert       DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.60         BY: Russ Witt           DATE: 04/13/01  ECO: *P00J* */
/* Revision: 1.61         BY: Ellen Borden        DATE: 07/09/01  ECO: *P007* */
/* Revision: 1.62         BY: Rajesh Thomas       DATE: 07/23/01  ECO: *M136* */
/* Revision: 1.64         BY: Jean Miller         DATE: 08/07/01  ECO: *M11Z* */
/* Revision: 1.65         BY: Russ Witt           DATE: 08/17/01  ECO: *P01M* */
/* Revision: 1.66         BY: Russ Witt           DATE: 09/21/01  ECO: *P01H* */
/* Revision: 1.67         BY: Russ Witt           DATE: 10/17/01  ECO: *P021* */
/* Revision: 1.68         BY: Steve Nugent        DATE: 10/22/01  ECO: *P004* */
/* Revision: 1.69         BY: Ed van de Gevel     DATE: 12/03/01  ECO: *N16R* */
/* Revision: 1.72         BY: Inna Fox            DATE: 02/20/02  ECO: *M12Q* */
/* Revision: 1.74         BY: Steve Nugent        DATE: 12/05/01  ECO: *P00G* */
/* Revision: 1.76         BY: Jean Miller         DATE: 04/19/02  ECO: *P05M* */
/* Revision: 1.77         BY: Ashwini Ghaisas     DATE: 06/18/02  ECO: *M1ZF* */
/* Revision: 1.78         BY: Robin McCarthy      DATE: 11/08/02  ECO: *P0JS* */
/* Revision: 1.79         BY: Deepali Kotavadekar DATE: 12/20/02  ECO: *N22L* */
/* Revision: 1.81         BY: Richard Day         DATE: 03/14/03  ECO: *N29S* */
/* Revision: 1.83         BY: Shoma Salgaonkar    DATE: 05/06/03  ECO: *P0RC* */
/* Revision: 1.85         BY: Paul Donnelly (SB)  DATE: 06/28/03  ECO: *Q00L* */
/* Revision: 1.86         BY: Rajinder Kamra      DATE: 07/18/03  ECO: *Q013* */
/* Revision: 1.87         BY: K Paneesh           DATE: 08/01/03  ECO: *N2HS* */
/* Revision: 1.88         BY: Neil Curzon         DATE: 08/04/03  ECO: *Q017* */
/* Revision: 1.90         BY: Rajinder Kamra      DATE: 08/14/03  ECO: *Q021* */
/* Revision: 1.91         BY: Jyoti Thatte        DATE: 09/15/03  ECO: *P106* */
/* Revision: 1.92         BY: Veena Lad           DATE: 11/21/03  ECO: *P1BN* */
/* Revision: 1.93         BY: Ed van de Gevel     DATE: 12/24/03  ECO: *Q04S* */
/* Revision: 1.94         BY: Manish Dani         DATE: 02/13/04  ECO: *P1P0* */
/* Revision: 1.96         BY: Jean Miller         DATE: 02/23/04  ECO: *Q063* */
/* Revision: 1.97         BY: Katie Hilbert       DATE: 03/08/04  ECO: *Q06B* */
/* Revision: 1.99         BY: Gaurav Kerkar       DATE: 08/19/04  ECO: *P2G8* */
/* Revision: 1.100        BY: Preeti Sattur       DATE: 08/23/04  ECO: *P2G4* */
/* Revision: 1.101        BY: Ajit Philip         DATE: 09/01/04  ECO: *N2X6* */
/* Revision: 1.104        BY: Nishit V            DATE: 09/02/04  ECO: *P2HR* */
/* Revision: 1.105        BY: Ed van de Gevel     DATE: 11/29/04  ECO: *P2NF* */
/* Revision: 1.105.1.1    BY: Tejasvi Kulkarni    DATE: 04/20/05  ECO: *P3HK* */
/* Revision: 1.105.1.2    BY: Alok Gupta          DATE: 05/18/05  ECO: *Q0JF* */
/* Revision: 1.105.1.3    BY: Priya Idnani        DATE: 10/20/05  ECO: *P457* */
/* Revision: 1.105.1.4    BY: Amit Singh          DATE: 10/20/05  ECO: *P48V* */
/* $Revision: 1.105.1.5 $ BY: Sushant Pradhan     DATE: 04/18/06  ECO: *P4PD* */
/*By: Neil Gao 08/04/01 ECO: *SS 20080401* */
/* SS - 100620.1 By: Kaine Zhang */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/



/*V8:ConvertMode=Maintenance                                                  */
{mfdeclre.i}
{cxcustom.i "SOSOMTA.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{gprunpdf.i "mcpl" "p"}

/* CHANGES MADE TO THIS PROGRAM MAY ALSO NEED TO BE MADE */
/* TO PROGRAM fseomta.p.                                 */

define input parameter this-is-rma      as  logical.
define input parameter rma-recno        as  recid.
define input parameter rma-issue-line   as  logical.

/* CONSIGNMENT VARIABLES */
{socnvars.i}
define variable proc_id as character no-undo.

define new shared variable pl                like pt_prod_line.
define new shared variable undo_all          like mfc_logical  initial no.
define new shared variable sod_recno         as   recid.
define new shared variable sodcmmts          like soc_lcmmts   label "Comments".
define new shared variable prev_consume      like sod_consume.
define new shared variable clines            as   integer.
define new shared variable sod-detail-all    like soc_det_all.
define new shared variable sodreldate        like sod_due_date.
define new shared variable prev_type         like sod_type.
define new shared variable prev_site         like sod_site.
define new shared variable new_line          like mfc_logical.
define new shared variable solinerun         as   character.
define new shared variable delete_line       like mfc_logical.
define new shared variable sonbr             like sod_nbr.
define new shared variable soline            like sod_line.
define new shared variable new_site          like sod_site.
define new shared variable err_stat          as   integer.

define new shared variable temp_sod_qty_ord  like sod_qty_ord.
define new shared variable temp_sod_qty_ship like sod_qty_ship.
define new shared variable temp_sod_qty_all  like sod_qty_all.
define new shared variable temp_sod_qty_pick like sod_qty_pick.
define new shared variable save_parent_list  like sod_list_pr.
define new shared variable discount          as   decimal
   label "Discount" format "->>>9.9<<<".
define new shared variable reprice_dtl       like mfc_logical label "Reprice".

/* DEFINE RNDMTHD FOR CALL TO SOSOMTLA.P */
define     shared variable rndmthd           like rnd_rnd_mthd.
define     shared variable all_days          as   integer.
define     shared variable base_amt          like ar_amt.
define     shared variable calc_fr           like mfc_logical.
define     shared variable consume           like sod_consume.
define     shared variable del-yn            like mfc_logical.
define     shared variable inv_db            like dc_name.
define     shared variable line              like sod_line.
define     shared variable mult_slspsn       like mfc_logical   no-undo.
define     shared variable part              as   character     format "x(18)".
define     shared variable prev_due          like sod_due_date.
define     shared variable prev_qty_ord      like sod_qty_ord.
define     shared variable promise_date      as   date label    "Promise Date".
define     shared variable perform_date      as   date label    "Perform Date".
define     shared variable qty               like sod_qty_ord.
define     shared variable sngl_ln           like soc_ln_fmt.
define     shared variable so_db             like dc_name.
define     shared variable so_recno          as   recid.
define     shared variable so-detail-all     like soc_det_all.
define     shared variable soc_pc_line       like mfc_logical.
define     shared variable socrt_int         like sod_crt_int.
define     shared variable tax_in            like cm_tax_in.
define     shared variable reprice           like mfc_logical.
define     shared variable line_pricing      like mfc_logical.
define     shared variable new_order         like mfc_logical.

define variable l_sngl_ln               like  soc_ln_fmt     no-undo.
define variable cchar                   as    character.
define variable desc1                   like  pt_desc1.
define variable err-flag                as    integer.
define variable first_time              like  mfc_logical    initial yes.
define variable i                       as    integer.
define variable ptstatus                like  pt_status.
define variable imp-okay                like  mfc_logical    no-undo.
define variable frametitle              as    character      format "x(20)".
define variable frametitle-so           as    character      format "x(20)".
define variable frametitle-rma-iss      as    character      format "x(20)".
define variable frametitle-rma-rec      as    character      format "x(20)".
define variable rmd-recno               as    recid.
define variable rma-line-type           like  sod_fsm_type   initial " ".
define variable l_part                  like  pt_part        no-undo.
define variable mc-error-number         like  msg_nbr        no-undo.
define variable apm-ex-sub              as    character      format "x(24)"
   no-undo.
define variable error_flag              like  mfc_logical    no-undo.
define variable err_mess_no             like  msg_nbr        no-undo.
define variable cust-resv-loc           like  locc_loc       no-undo.
define variable useloc                  like  mfc_logical    no-undo.
define variable l_sonbr                 like  sod_nbr        no-undo.
define variable confirmApoAtpOrderLine  as    logical        no-undo initial no.
define variable apoDemandId             as    character      no-undo.
define variable apoMessageNumber        as    integer        no-undo.
define variable so_fld                  as    handle.
define variable so_fldname              as    handle.
define variable p-edi-rollback          as    logical        no-undo initial no.
define variable use-log-acctg           as    logical        no-undo.
define variable tax_type                like  tx2d_tr_type   no-undo.
define variable l_undo_all2             like  mfc_logical    no-undo.

/* THESE 'HANDLE' VARIABLES ARE USED TO GIVE DIFFERENT LABELS */
/* TO FIELDS WHEN MAINTAINING RMA RECEIPT LINES               */
define variable hdl-ord-qty-field   as  handle.
define variable hdl-ship-qty-field  as  handle.
define variable hdl-order-nbr-field as  handle.
define variable hdl-due-date-field  as  handle.

/* EMT VARIABLES */
define variable first-repeat     as   logical no-undo.
define variable err_flag         as   integer.

/* BACK TO BACK SHARED WORKFILES */
{sobtbvar.i}

define            variable disc_min_max   like mfc_logical.
define            variable disc_pct_err   as   decimal.
define new shared variable save_qty_ord   like sod_qty_ord.
define new shared variable cmtindx        like cmt_indx.
define new shared variable po-ack-wait    as   logical     no-undo.

define variable l_last_line    like sod_line no-undo.

define new shared stream apoAtpStream.

define new shared workfile sobfile no-undo
   field sobpart     like sob_part
   field sobsite     like sob_site
   field sobissdate  like sob_iss_date
   field sobqtyreq   like sob_qty_req
   field sobconsume  like sob_qty_req
   field sobabnormal like sob_qty_req.

/* TEMP TABLE TO TRACK SO DTL FIELD CHANGES FOR BOOKING HISTORY */
define temp-table tt_field_recs
   field tt_field_name  like tblcd_fld_name
   field tt_field_value as   character      format "x(30)" extent 5
   index tt_field_ix    is   unique primary
         tt_field_name.

define buffer sod_buff2 for sod_det.
define buffer rmdbuff   for rmd_det.

{pxmaint.i}

/* DEFINE HANDLES FOR THE PROGRAMS. */
{pxphdef.i giapoxr}

/* VARIABLE DEFINITIONS FOR gpfile.i */
{gpfilev.i}

/* DETERMINE IF CONTAINER AND LINE CHARGES IS ENABLES */
{cclc.i}

assign
   frametitle-so      = getFrameTitle("SALES_ORDER_LINE",20)
   frametitle-rma-iss = getFrameTitle("RMA_ISSUE_LINE",20)
   frametitle-rma-rec = getFrameTitle("RMA_RECEIPT_LINE",20).

define new shared frame a.
define new shared frame c.
define new shared frame d.

{&SOSOMTA-P-TAG1}
form
   space(1)
   so_nbr
   so_cust
   sngl_ln
with frame a side-labels width 80.
{&SOSOMTA-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DEFINE THE FORMS FOR THE STD CHECKER, TO MEET NOTES STANDARD #98 */
form with frame c width 80.
form with frame d width 80.
/* Define shared frames */
{solinfrm.i}
/*V8:HiddenDownFrame=c */

define shared temp-table tt_soddet no-undo like sod_det.

/* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

/* DETERMINE IF CUSTOMER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_CUSTOMER_CONSIGNMENT,
     input 10,
     input ADG,
     input CUST_CONSIGN_CTRL_TABLE,
     output using_cust_consignment)"}
if this-is-rma = yes
then
   using_cust_consignment = no.

/* READ SO_MSTR EARLY SO WE'RE ABLE TO SET THE MULTIPLE SALESPERSON   */
/* FLAG FOR ITS DISPLAY.  PREVENT A TRANSACTION BEING SCOPED TO THIS  */
/* ENTIRE PROCEDURE BLOCK BY NOT LOCKING RECORDS HERE.                */

for first so_mstr
   fields(so_domain      so_curr     so_cust       so_div
          so_due_date    so_bill     so_fsm_type   so_ex_rate
          so_ex_rate2    so_fix_pr   so_fr_list    so_nbr
          so_pricing_dt  so_primary  so_project    so_pr_list
          so_pst         so_req_date so_secondary  so_ship
          so_site        so_slspsn   so_taxable    so_taxc
          so_tax_env     so_tax_usage so_conf_date)
   where recid(so_mstr) = so_recno
no-lock: end.

{&SOSOMTA-P-TAG3}

for first soc_ctrl
   fields(soc_domain soc_apm    soc_lcmmts
          soc_calc_promise_date soc_atp_enabled
          soc_shp_lead          soc_use_btb)
    where soc_domain = global_domain
no-lock: end.

for first pic_ctrl
   fields (pic_domain pic_so_fact pic_so_rfact)
   where pic_domain = global_domain
no-lock: end.

/* IF WE'RE IN RMA MAINTENANCE, READ RMA/SERVICE CONTROL */
/* FILES AND RELATED RECORDS.                            */
if this-is-rma then do:

   for first rmc_ctrl
      fields (rmc_domain rmc_edit_isb rmc_lcmmts)
       where rmc_domain = global_domain
   no-lock: end.

   for first svc_ctrl
      fields (svc_domain svc_pt_prod)
      where svc_domain = global_domain
   no-lock: end.

   for first rma_mstr
      fields (rma_domain rma_contract rma_ctype rma_enduser rma_loc_iss
             rma_loc_rec rma_site_iss rma_site_rec)
      where recid(rma_mstr) = rma-recno
   no-lock: end.

   for first eu_mstr
      fields (eu_domain eu_addr eu_type)
       where eu_domain = global_domain and eu_addr = rma_enduser
   no-lock: end.

   if rma-issue-line then
      rma-line-type = "RMA-ISS".
   else
      rma-line-type = "RMA-RCT".
end.
else
   rma-recno = ?.

/* SET DISPLAY OF THE MULTIPLE SALESPERSON FLAG          */
/* MULPITLE COMMISSION UPDATES WILL ONLY HAPPEN IF TRUE. */
if so_slspsn[2] <> "" or so_slspsn[3] <> "" or so_slspsn[4] <> ""
then
   mult_slspsn = true.
else
   mult_slspsn = false.

/* PREPARE FOR POSSIBLE USER EXIT PROGRAMS */
if this-is-rma then do:
   if rma-issue-line then do:
      /* Issues */
      {fsmnp01.i ""fsrmamt.p"" 20 solinerun}
   end.
   else do:
      /* Returns */
      {fsmnp01.i ""fsrmamt.p"" 30 solinerun}
   end.
end.   /* if this-is-rma */
else do:
   {fsmnp01.i ""sosomt.p"" 20 solinerun}
end.

if sngl_ln then
   clines = 1.
{&SOSOMTA-P-TAG4}

/* FOR RMA'S, IT'S BETTER IF THE SO_NBR LABEL DOESN'T READ  */
/* "SALES ORDER", AND WE HAVE DIFFERENT LABELS FOR DUE DATE */
/* AND SOME CHANGES FOR RMA RECEIPT LINES REGARDING QTYS    */

if this-is-rma then do:
   assign
      hdl-order-nbr-field       = so_nbr:handle
      hdl-order-nbr-field:label = getTermLabel("RMA",6)
      hdl-due-date-field        = sod_det.sod_due_date:handle.
   if rma-issue-line then
      hdl-due-date-field:label  = getTermLabel("DUE_DATE",8).
   else
   assign
      hdl-ord-qty-field        = sod_det.sod_qty_ord:handle
      hdl-ord-qty-field:label  = getTermLabel("RETURN_QUANTITY",11)
      hdl-ship-qty-field       = sod_det.sod_qty_ship:handle
      hdl-ship-qty-field:label = getTermLabel("QUANTITY_RETURNED",14)
      hdl-due-date-field:label = getTermLabel("EXPECTED_DATE",13).
end.   /* if this-is-rma */

{&SOSOMTA-P-TAG5}

linefmt:
repeat on endkey undo, leave:

   {&SOSOMTA-P-TAG6}
   assign l_sngl_ln = sngl_ln.
   {&SOSOMTA-P-TAG7}
   if not first_time then
      update sngl_ln with frame a.

   if l_sngl_ln <> sngl_ln  then
      clear frame c all no-pause.

   clines = ?.
   if sngl_ln then
      clines = 1.
   {&SOSOMTA-P-TAG8}

   run getLastSodLIne (input  so_domain,
                       input  so_nbr,
                       output l_last_line).

   if line <> l_last_line
   then
      line = l_last_line.

   first_time = no.

   if this-is-rma then
      if rma-issue-line then
         frametitle = frametitle-rma-iss.
      else
         frametitle = frametitle-rma-rec.
   else
      {&SOSOMTA-P-TAG9}
      frametitle = frametitle-so.

   first-repeat = yes.

   mainloop:
   repeat with frame c down on endkey undo, next linefmt:

      find first so_mstr where recid(so_mstr) = so_recno
      exclusive-lock no-error.

      {&SOSOMTA-P-TAG10}

      reprice_dtl = reprice.

      display
         so_nbr
         so_cust
         sngl_ln
      with frame a.
      {&SOSOMTA-P-TAG11}

      /* Need this hide/view scheme to re-realize frames when they change.*/
      hide frame d.
      hide frame c.
      view frame c. /*to re-realize if single/multi line changes */
      if sngl_ln then view frame d.

      /*V8! hide message. */
      {mfdel.i sobfile}

      if this-is-rma then
         sodcmmts = rmc_lcmmts.
      else
         sodcmmts = soc_lcmmts.
      sod-detail-all = so-detail-all.

      /* RMA RECEIPT LINES DO NOT GET ALLOCATIONS */
      if this-is-rma and not rma-issue-line
         then sod-detail-all = no.

      {&SOSOMTA-P-TAG12}

      /* GET LAST RMA/SO ITEM LINE */
      if this-is-rma
      then do:

         run getLastSodLine
            (input so_domain,
             input so_nbr,
             output l_last_line).

         if line <> l_last_line
         then
            line = l_last_line.

      end. /* IF this-is-rma */

      /* SCREENS & REPORTS DON'T SUPPORT 4 DIGIT LINE NOS. */
      if line < 999 then line = line + 1.
      else if line = 999 then do:
         /* LINE CANNOT BE > 999 */
         run p-pxmsg (input 7418, input 2).
      end.

      for first sod_det where sod_domain = global_domain and
                              sod_nbr  = so_nbr and
                              sod_line = line
      no-lock: end.

      /* IF WE'RE MAINTAINING RMA'S, AN INPUT PARAMETER TOLD US */
      /* WHETHER WE'RE CURRENTLY DOING THE ISSUE OR RECEIPT     */
      /* LINES, AND RMA-LINE-TYPE NOW CONTAINS THE LITERAL      */
      /* WHICH SOD_DET'S USE TO IDENTIFY THIS TYPE OF LINE...   */
      /* SO, LOOK FOR THEM...                                   */
      if this-is-rma then do:
         do while available sod_det and
               sod_fsm_type <> rma-line-type:
            find next sod_det
               where sod_domain = global_domain and
                     sod_nbr = so_nbr
            no-lock no-error.
         end.
         if available sod_det then
            if sod_line < 999 then
               assign
                  line = sod_line + 1.
         else  do:
            line = 999.
            /* LINE CANNOT BE > 999 */
            run p-pxmsg (input 7418, input 2).
         end.
      end.     /* if this-is-rma */

      if not available sod_det or
         (this-is-rma and sod_fsm_type <> rma-line-type)
      then do:
         discount = if not pic_so_fact then 0 else 1.
         display
            line
            "" @ sod_part
            0  @ sod_qty_ord
            "" @ sod_um
            0  @ sod_list_pr
            discount
            0  @ sod_price
         with frame c.
      end.

      else do:

         desc1 = getTermLabel("ITEM_NOT_IN_INVENTORY",24).

         for first pt_mstr
         fields (pt_domain pt_desc1 pt_fr_class pt_loc pt_part pt_pm_code
                 pt_price pt_prod_line pt_ship_wt pt_ship_wt_um
                 pt_site pt_status pt_taxable pt_taxc pt_um)
          where pt_domain = global_domain and pt_part = sod_part
         no-lock: end.

         if available pt_mstr then
            desc1 = pt_desc1.
         else if sod_desc <> "" then
            desc1 = sod_desc.

         /* DETERMINE DISCOUNT DISPLAY FORMAT AND SET VARIABLE discount
          * ACCORDINGLY */
         {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}
         display
            line
            sod_part
            sod_qty_ord
            sod_um
            sod_list_pr
            discount
            sod_price
         with frame c.

         if sngl_ln then
            display
               sod_qty_all
               sod_qty_pick
               sod_qty_ship
               sod_qty_inv
               sod_loc
               sod_site
               sod_serial
               base_curr
               sod_std_cost
               desc1
               sod_pricing_dt
               sod_req_date
               sod_per_date
               sod_due_date
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
               sod_type
               sod_um_conv
               sod_consume
               sod-detail-all
               sod_slspsn[1]
               mult_slspsn
               sod_comm_pct[1]
               sod_taxable
               sod_taxc
              (sod_cmtindx <> 0) @ sodcmmts
               sod_crt_int
               sod_fix_pr
               sod_order_category
            with frame d.

         /* RMA RECEIPT LINES ARE FOR RETURNS FROM CUSTOMERS -  */
         /* OR, SHIPPING NEGATIVE QUANTITIES TO CUSTOMERS.      */
         /* IN RMA MAINTENANCE, HOWEVER, THESE NEGATIVE QTYS    */
         /* NEED TO DISPLAY AS POSITIVE VALUES (AND, IN THE     */
         /* RMD_DET FILE, THEY'RE STORED AS POSITIVE VALUES).   */
         if this-is-rma and not rma-issue-line then do:
            if sngl_ln then
               display
                  (sod_qty_ship * -1) @ sod_qty_ship
                  (sod_qty_inv  * -1) @ sod_qty_inv
               with frame d.
            display (sod_qty_ord * -1) @ sod_qty_ord
            with frame c.
         end.
      end.  /* else, available sod_det, do */

      /* EMT ROLL-BACK OF ADDED LINES                  */
      /*               - DELETING THEM IF ROLLING BACK */
      s-rollback = no.

      /* ONLY WHEN ENTERING THE LINE FRAME THE FIRST TIME */
      if soc_use_btb and not so_secondary and first-repeat then do:

         /* FIRST LOOP THROUGH ALL SO LINES TO FIND ALL EXISTING    */
         /* CMF RECORDS FOR ADDED LINES                             */
         for each sod_buff2
            where sod_buff2.sod_domain = global_domain and
                  sod_buff2.sod_nbr = so_nbr
         no-lock break by sod_buff2.sod_line:

            if last(sod_buff2.sod_line) then first-repeat = no.

            {gprun.i ""sobtbrb.p""
               "(input recid(so_mstr),
                 input sod_buff2.sod_line,
                 input ""pod_det"",
                 input ""pod_line"",
                 input p-edi-rollback,
                 output return-msg)" }

            /* DISPLAY ERROR MESSAGE RETURN FROM SOBTBRB.P */
            if return-msg <> 0 then do:
               run p-pxmsg (input return-msg, input 4).
               return-msg = 0.
               if not batchrun then pause.
               undo mainloop, retry.
            end.

            if sod_buff2.sod_btb_po + "," +
               trim(string(sod_buff2.sod_btb_pod_line, ">>9"))
               = s-cmdkeyval
            then do:
               assign
                  line =  sod_buff2.sod_line
                  s-rollback = yes
                  del-yn = yes.
               leave.
               /* IF CMF IS FOUND THEN LEAVE LOOP TO DELETE LINE */
            end.

         end.  /* for each sod_buff2 */

      end.  /*  roll-back of added lines */

      /* SKIP FURTHER UPDATES IF THIS LINE IS A BTB SO LINE THAT */
      /* HAS TO BE DELETED CAUSED BY A ROLL-BACK                 */
      /* (cmd_det exists for field "pod_line"                    */
      if not del-yn then do:
         s-rb-init = no.

         /* IF A REPLACEMENT PART IS SENT BACK BY THE CONFIGURATOR, */
         /* THE PROGRAM SHOULD REDISPLAY THE LINE NUMBER, THE       */
         /* REPLACEMENT PART AND PROMPT THE USER TO ENTER SITE      */
         {&SOSOMTA-P-TAG13}

         lineEntryLoop:
         repeat on endkey undo, next linefmt:
            update line with frame c
            editing:

               /* TO SHOW SO LINES FOR SELECTED SO IN CHAR AND GUI  */
               /* USING LOOK-UP OR DRILL DOWN BROWSE ON LINE FIELD. */
               {gpbrparm.i &browse=gpbr241.p &parm=c-brparm1 &val="so_nbr"}
               {gpbrparm.i &browse=gplu241.p &parm=c-brparm1 &val="so_nbr"}

               l_sonbr = so_nbr.

               on leave of line in frame c do:
                  /*V8!
                  do on error undo, leave:
                     {gpbrparm.i &browse=gpbr241.p
                                 &parm=c-brparm1 &val="l_sonbr"}
                     {gpbrparm.i &browse=gplu241.p
                                 &parm=c-brparm1 &val="l_sonbr"}

                     run q-leave in global-drop-down-utilities.
                  end. /* DO ON ERROR ... */

                  run q-set-window-recid in global-drop-down-utilities.
                  if return-value = "error"
                     then return no-apply. */

               end. /* ON LEAVE ... */

               /* NEXT/PREVIOUS PROCESSING MUST BE SENSITIVE TO THE   */
               /* TYPE OF ORDER BEING MAINTAINED (SALES ORDER OR RMA) */
               /* AND, IF RMA'S, THE TYPE OF LINE ITEM CURRENTLY      */
               /* BEING MAINTAINED (ISSUE OR RECEIPT)                 */
               if this-is-rma then do:
                  {mfnp05.i sod_det sod_nbrln
                     " sod_det.sod_domain = global_domain and sod_nbr  =
                     so_nbr and sod_fsm_type = rma-line-type"
                     sod_line
                     "line"}
               end.
               else do:
                  {mfnp01.i sod_det line sod_line so_nbr  "
                  sod_det.sod_domain = global_domain and sod_nbr "
                  sod_nbrln}
               end.

               if recno <> ? then do:

                  for first pt_mstr
                  fields(pt_domain pt_desc1 pt_fr_class pt_loc pt_part
                         pt_pm_code pt_price pt_prod_line
                         pt_ship_wt pt_ship_wt_um pt_site
                         pt_status pt_taxable pt_taxc pt_um)
                   where pt_domain = global_domain
                     and pt_part = sod_part no-lock:
                  end. /* FOR FIRST PT_MSTR */

                  if available pt_mstr then
                     desc1 = pt_desc1.
                  else
                     if sod_desc <> "" then
                        desc1 = sod_desc.
                     else
                        desc1 = getTermLabel("ITEM_NOT_IN_INVENTORY",24).
                  line = sod_line.

                  /* DETERMINE DISCOUNT DISPLAY FORMAT AND SET VARIABLE
                   * discount ACCORDINGLY */
                  {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}

                  display
                     line
                     sod_part
                     sod_qty_ord
                     sod_um
                     sod_list_pr
                     discount
                     sod_price
                  with frame c.

                  if sngl_ln then
                  display
                     sod_qty_all
                     sod_qty_pick
                     sod_qty_ship
                     sod_qty_inv
                     sod_loc
                     sod_site
                     sod_serial
                     sod_std_cost
                     desc1
                     base_curr
                     sod_pricing_dt
                     sod_req_date
                     sod_per_date
                     sod_due_date
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
                     sod_type
                     sod_um_conv
                     sod_consume
                     sod-detail-all
                     sod_slspsn[1]
                     mult_slspsn
                     sod_comm_pct[1]
                     sod_taxable
                     sod_taxc
                     (sod_cmtindx <> 0) @ sodcmmts
                     sod_crt_int
                     sod_fix_pr
                     sod_order_category
                  with frame d.

                  /* AS ABOVE, RMA RECEIPT LINES ARE RETURNS, AND  */
                  /* HAVE NEGATIVE SOD_QTY'S, HOWEVER, THESE QTYS  */
                  /* MUST DISPLAY POSITIVE TO THE USER.            */
                  if this-is-rma and not rma-issue-line then do:
                     if sngl_ln then
                        display
                           (sod_qty_ship * -1) @ sod_qty_ship
                           (sod_qty_inv  * -1) @ sod_qty_inv
                        with frame d.
                     display (sod_qty_ord * -1) @ sod_qty_ord
                     with frame c.
                  end.

               end.    /* if recno <> ? */

            end.    /* editing */

            /*
            * If the sales order was created by an application external to
            * MFG/PRO i.e. eQ using the API gateways then the user is not
            * allowed to create a new sales order line.
            */
            if so_app_owner <> "" and
               not can-find(sod_det where
                            sod_domain = global_domain
                       and  sod_nbr  = so_nbr
                       and  sod_line = input line)
            then do:
            run message-args (input 2948,
                              input 4,
                              input so_app_owner ,
                              input '').

               undo lineEntryLoop, next lineEntryLoop.
            end.
            else
               leave lineEntryLoop.

         end. /* repeat (lineEntryLoop)*/

         /* ADD/MOD/DELETE  */
         run create-tt-field-recs (input global_domain,
                                   input so_nbr,
                                   input input line,
                                   input this-is-rma,
                                   buffer sod_det).

      end.  /* if not del-yn */

      else  /* IF DEL-YN THEN FIND LINE TO DELETE */
      find sod_det
         where sod_domain = global_domain
          and  sod_nbr = so_nbr
          and  sod_line = line
      exclusive-lock no-error.

      {&SOSOMTA-P-TAG14}
      if not available sod_det then do:
         if line = 0 then do:
            /* INVALID LINE NUMBER */
            run p-pxmsg (input 642, input 4).
            undo mainloop, retry.
         end.

         if so_secondary then do:
            /* NEW LINE IS NOT ALLOWED AT THE SBU */
            run p-pxmsg (input 2939, input 3).
            undo mainloop, retry.
         end.

         if not new_order then
            reprice_dtl = yes.  /*This will cause line to be priced*/

         new_line = yes.
         run create-sod-det (buffer so_mstr,
                             buffer sod_det,
                             input global_domain,
                             input input line,
                             input consume,
                             input soc_lcmmts,
                             input socrt_int).
         {&SOSOMTA-P-TAG45}
         if this-is-rma then do:
            sodcmmts = rmc_lcmmts.
            create rmd_det.

            {&SOSOMTA-P-TAG17}
            assign
               rmd_domain    = global_domain
               rmd_nbr       = so_nbr
               rmd_prefix    = "C"
               rmd_line      = input line
               rmd_edit_isb  = rmc_edit_isb
               rmd_sa_nbr    = rma_contract
               sod_enduser   = rma_enduser
               sod_fsm_type  = rma-line-type
               /* RMD_SV_CODE WILL NOW HOLD THE SVC TYPE THAT */
               /* PROVIDES COVERAGE                           */
               rmd_sv_code   = rma_ctype
               sodcmmts      = rmc_lcmmts.
            {&SOSOMTA-P-TAG18}

            {fssvsel.i rma_ctype """" eu_type}

            /* FOR RMA ISSUE LINE, IF THE HEADER PROMISE DATE IS DIFFERENT  */
            /* FROM THE HEADER DUE DATE, DEFAULT THE LINE ITEM PROMISE DATE */
            /* TO THE HEADER PROMISE DATE. ELSE DEFAULT IT TO ?.            */
            /* ALSO DEFAULT THE LINE ITEM REQUIRED DATE TO ?                */

            {&SOSOMTA-P-TAG19}
            if rma-issue-line then do:

               assign
                  sod_rma_type  = "O"
                  rmd_type      = "O"
                  rmd_exp_date  = so_req_date
                  sod_due_date  = so_req_date
                  sod_per_date  = perform_date
                  when (perform_date <> so_req_date)
                  sod_site      = rma_site_iss
                  sod_loc       = rma_loc_iss.

            end.   /* if rma-issue-line */

            /* FOR RMA RECEIPT LINE, DEFAULT THE LINE ITEM REQUIRED DATE AND */
            /* PROMISE DATE TO ?                                             */
            else   /* this must be a receipt-line */
            assign
               sod_rma_type  = "I"
               rmd_type      = "I"
               rmd_exp_date  = so_due_date
               rmd_rma_rtrn  = yes
               sod_consume   = no
               sod_due_date  = so_due_date
               sod_site      = rma_site_rec
               sod_loc       = rma_loc_rec.
            {&SOSOMTA-P-TAG20}

            rmd-recno = recid(rmd_det).

         end.  /* if this-is-rma */

         /* INITIALIZE TAX MANAGEMENT FIELDS */
         assign
            sod_taxable   = so_taxable
            sod_taxc      = so_taxc
            sod_tax_usage = so_tax_usage
            /* FOR RMA'S, DON'T DEFAULT THE ENVIRONMENT BECAUSE IT MUST */
            /* BE RECALCULATED FOR RCPTS/ISS (DIFFERENT FROM/TO)        */
            sod_tax_env   = (if this-is-rma then "" else so_tax_env)
            sod_tax_in    = tax_in.

         sod_confirm = so_conf_date <> ?.
         if not this-is-rma then do:
            if so_req_date <> so_due_date then
               sod_req_date = so_req_date.
            if perform_date <> so_due_date then
               sod_per_date = perform_date.
         end. /* if not this-is-rma */

         /* Determine promise date  */
         /* If promise date entered on header, use that date */
         if promise_date <> ? then sod_promise_date = promise_date.

         /* Determine if due date needs to be set for an unconfirmed order  */
         if soc_calc_promise_date = yes
            and soc_atp_enabled = yes
            and sod_confirm = no
            and sod_due_date = ?
            then sod_due_date  = today + soc_shp_lead.

         {&SOSOMTA-P-TAG21}
         desc1 = "".
         assign line.

         /* DETERMINE DISCOUNT DISPLAY FORMAT AND SET VARIABLE discount
          * ACCORDINGLY */
         {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}
         display
            line sod_part sod_qty_ord sod_um
            sod_list_pr discount sod_price
         with frame c.

         {&SOSOMTA-P-TAG22}
         if sngl_ln then
         display
            sod_qty_all sod_qty_pick sod_qty_ship
            sod_qty_inv sod_loc sod_site sod_serial
            desc1 sod_std_cost base_curr
            sod_pricing_dt
            sod_req_date sod_per_date sod_due_date
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
            sod_type sod_um_conv sod_consume sod-detail-all
            sod_slspsn[1] mult_slspsn sod_comm_pct[1]
            sod_taxable
            sod_taxc
            sodcmmts
            sod_crt_int
            sod_fix_pr
            sod_order_category
         with frame d.

         {&SOSOMTA-P-TAG23}

         prompt-for sod_det.sod_part with frame c
         editing:
            /* FIND NEXT/PREVIOUS  RECORD */
            {mfnp.i pt_mstr sod_part  " pt_mstr.pt_domain = global_domain
            and pt_part "  sod_part pt_part pt_part}

            if recno <> ? then do:

               assign
                  desc1    = pt_desc1
                  sod_part = pt_part.

               if rma-line-type <> "RMA-RCT" then
                  run mcpl-mc-curr-conv (input base_curr,
                                         input so_curr,
                                         input so_ex_rate2,
                                         input so_ex_rate,
                                         input pt_price,
                                         input false,
                                         output sod_price,
                                         output mc-error-number).

               assign
                  sod_list_pr = if rma-line-type <> "RMA-RCT"
                                then sod_price
                                else sod_list_pr
                  sod_um = pt_um.

               /* FOR RMA'S, PRICE HAS NEVER DISPLAYED WHEN */
               /* THE USER NEXT/PREV'ED ON PART NUMBER.  TO */
               /* PREVENT CONFUSION WHEN RESTOCK AMOUNTS    */
               /* APPLY, DON'T DISPLAY THEM NOW EITHER.     */
               display
                  sod_part sod_um
                  sod_list_pr when (not this-is-rma)
                  sod_price   when (not this-is-rma)
               with frame c.
               {&SOSOMTA-P-TAG24}
               if sngl_ln then display desc1 with frame d.
               {&SOSOMTA-P-TAG25}
            end.

         end. /* end of editing */

         hide message no-pause.

         assign sod_part.

         l_part = sod_part.

         /* SEARCH CUSTOMER ITEM/ ITEM MASTER */
         {gprun.i ""sopart.p""
            "(input so_cust,
              input so_ship,
              input-output sod_part,
              output sod_custpart)"}

         for first pt_mstr
            fields(pt_domain pt_desc1 pt_fr_class pt_loc pt_part pt_pm_code
                   pt_price pt_prod_line pt_ship_wt pt_ship_wt_um
                   pt_site pt_status pt_taxable pt_taxc pt_um )
            where pt_domain = global_domain
             and  pt_part = sod_part
         no-lock: end.

         if l_part <> sod_part then do:
            display sod_part with frame c.
            /* CUSTOMER ITEM # REPLACED BY # */
            run message-args (input 56,
                              input 1,
                              input l_part,
                              input sod_part).
            if {gpiswrap.i} then pause 0.
         end. /* IF L_PART <> SOD_PART */

         if available pt_mstr and pt_pm_code = "F" then do with frame c:
            part = sod_part.

            /* SCROLLING WINDOW FOR FAMILY ITEMS, WAS SWBOM.P */
            {gprun.i ""sosobom.p""}.

            if part > "" then
               sod_part = part.

            display part @ sod_part.

            for first pt_mstr
               fields(pt_domain  pt_desc1 pt_fr_class pt_loc pt_part pt_pm_code
                      pt_price pt_prod_line pt_ship_wt pt_ship_wt_um
                      pt_site pt_status pt_taxable pt_taxc pt_um )
               where pt_domain = global_domain
                and  pt_part = sod_part
            no-lock: end.

         end. /* IF AVAILABLE PT_MSTR AND PT_PM_CODE = "F" */

         else if not available pt_mstr then do:
            /* SHIP TYPE SET TO (M)EMO */
            
/* ss 20071229 - b */
						message part "零件不存在".
						undo,retry.		
/* ss 20071229 - e */
            
            run p-pxmsg (input 25, input 2).
            sod_type = "M".

            /*V8! if not batchrun then
                  do:
                     pause.
                     hide message no-pause.
                     end. /* IF NOT BATCHRUN */
            */

         end. /* IF NOT AVAILABLE PT_MSTR */

         for first cm_mstr
         fields (cm_domain cm_addr cm_promo)
         where cm_domain = global_domain
          and  cm_addr = so_cust
         no-lock: end.
         if available cm_mstr then do:

            if soc_apm and cm_promo <> "" then do:
               /* CHECK IF PART BELONGS TO AN APM DIVISION */
               if available pt_mstr then do:
                  apm-ex-sub = "if/".
                  {gprunex.i
                     &module  = 'APM'
                     &subdir  = apm-ex-sub
                     &program = 'ifapm001.p'
                     &params  = "(input sod_part,
                                  input so_div,
                                  output error_flag,
                                  output err_mess_no)"}
                  if error_flag then do:
                     /* ITEM # LINE# DOES NOT BELONG TO */
                     /* APM DIVISION # */
                     run message-args (input err_mess_no,
                                       input 3,
                                       input sod_part,
                                       input so_div).

                     undo, next.
                  end.
                  /* CONFIGURED PART - CHECK COMPONENTS */
                  if pt_pm_code = "C" then do:

                     for each ps_mstr
                        where ps_domain = global_domain
                         and  ps_par = sod_part
                     no-lock:

                        apm-ex-sub = "if/".

                        {gprunex.i
                           &module  = 'APM'
                           &subdir  = apm-ex-sub
                           &program = 'ifapm001.p'
                           &params  = "(input ps_comp,
                                        input so_div,
                                        output error_flag,
                                        output err_mess_no)"}

                        if error_flag then do:
                           /* COMPONENT # DOES NOT BELONG TO */
                           /* APM DIVISION # */
                           run message-args (input 4543,
                                             input 3,
                                             input ps_comp,
                                             input so_div).

                           undo, leave.
                        end.

                     end.

                     if error_flag then undo, next.

                  end.

               end. /* IF AVAILABLE PT_MSTR */
               sod_div = so_div.

            end.  /* IF SOC_APM AND CM_PROMO <> "" */

         end.  /* IF AVAILABLE CM_MSTR */

         /* SET COMM PCT FROM SPD_DET IF AVAILABLE */
         pl = "".

         for first pt_mstr
         fields(pt_domain pt_desc1 pt_fr_class pt_loc pt_part pt_pm_code
                pt_price pt_prod_line pt_ship_wt pt_ship_wt_um
                pt_site pt_status pt_taxable pt_taxc pt_um)
          where pt_domain = global_domain
           and  pt_part = sod_part
          no-lock:
         end. /* FOR FIRST PT_MSTR */

         if this-is-rma and rma-issue-line and available pt_mstr then do:
            /* CHECK FOR ADD-RMA RESTRICTED TRANSACTION */
            assign
               ptstatus = pt_status
               substring(ptstatus,9,1) = "#".
            if can-find(isd_det where isd_domain = global_domain and
                                      isd_status = ptstatus and
                                      isd_tr_type = "ADD-RMA")
            then do:
            run message-args (input 358,
                              input 3,
                              input pt_status,
                              input '').
               undo, retry.
            end.
         end.  /* if this-is-rma... */

         /* FOR SO'S, PRODUCT LINE COMES FROM PT_MSTR.*/
         /* FOR RMA'S, IF "USE ITEM PRODUCT LINE",    */
         /* USE P/L FROM ITEM, ELSE USE P/L FROM THE  */
         /* SERVICE TYPE */
         {&SOSOMTA-P-TAG26}
         if not this-is-rma or svc_pt_prod then do:
            if available pt_mstr then
               pl = pt_prod_line.
         end.
         {&SOSOMTA-P-TAG27}
         if this-is-rma and not svc_pt_prod then do:
            {fssvsel.i rma_ctype """" eu_type}
            if available sv_mstr then pl = sv_prod_line.
            else if available pt_mstr then pl = pt_prod_line.
         end.

         sod_recno = recid(sod_det).
         {gprun.i ""sosocom.p""}

         {&SOSOMTA-P-TAG28}
         if available pt_mstr then do:
            /* INITIALIZE FREIGHT VALUES*/
            assign
               sod_fr_class = pt_fr_class
               sod_fr_wt_um = pt_ship_wt_um
               sod_fr_wt    = pt_ship_wt.

            assign
               ptstatus = pt_status
               substring(ptstatus,9,1) = "#".
            {&SOSOMTA-P-TAG29}
            if this-is-rma then .
            else do:
               {&SOSOMTA-P-TAG30}
               if can-find(isd_det where isd_domain = global_domain
                                    and  isd_status = ptstatus
                                    and  isd_tr_type = "ADD-SO")
               then do:
                  run message-args (input 358,
                                    input 3,
                                    input pt_status,
                                    input '').
                  undo, retry.
               end.
            end.    /* else do... */

            run setTaxDefaults.

            /* FOR SO'S, DEFAULT THE PT_MSTR LOCATION.  */
            /* FOR RMA'S, LOCATION CAME FROM THE HEADER */
            /* VALUES EARLIER.                          */
            if not this-is-rma and sod_btb_type <> "03" then do:
               /* SEE IF THERE IS A DEFAULT LOCATION FOR A  */
               /* CUSTOMER RESERVED LOCATION                */
              {gprun.i ""sorldft.p""
                 "(input so_ship,
                   input so_bill,
                   input so_cust,
                   input sod_site,
                   output cust-resv-loc,
                   output useloc)"}
               if useloc = yes then sod_loc = cust-resv-loc.
               else sod_loc = pt_loc.
            end.  /* if not this-is-rma...  */

            /* FOR RMA'S, WE MAY NEED PRODUCT LINE FROM */
            /* THE SERVICE TYPE, AND WE WANT ISSUE OR   */
            /* RECEIVE LOCATION FROM THE CONTROL FILE   */
            {&SOSOMTA-P-TAG31}
            if this-is-rma then do:
               if not svc_pt_prod then
                  if available sv_mstr then sod_prodline = sv_prod_line.
            end.    /* if this-is-rma */
            {&SOSOMTA-P-TAG32}

            if so_curr = base_curr then
            assign
               sod_price = if rma-line-type <> "RMA-RCT"
                           then pt_price
                           else sod_price
               sod_list_pr = if rma-line-type <> "RMA-RCT"
                             then pt_price
                             else sod_list_pr.

         end.  /* if available pt_mstr */
         else do:
            if not sngl_ln and so_site = "" then do:
               /* BLANK SITE NOT ALLOWED */
               run p-pxmsg (input 941, input 3).
               undo mainloop, retry.
            end.
            /* FOR RMA'S, WE MAY NEED TO GET PRODUCT LINE */
            /* FROM THE SERVICE TYPE...                   */
            if this-is-rma and not svc_pt_prod and available sv_mstr then
               sod_prodline = sv_prod_line.
         end.   /* else, not available pt_mstr, do */

         /*  Set default line site to pt_mstr site if header site is */
         /*  not valid for this item.                                */
         global_part = sod_part.
         if sod_type = "" then do:
            new_site = sod_site.
            {gprun.i ""gpptsi01.p""}
            if err_stat <> 0 then do:
               new_site = pt_site.
               {gprun.i ""gpptsi01.p""}
               if err_stat = 0 then do:
                  sod_site = pt_site.
                  /* Default site invalid; changed to Item default */
                  run message-args (input 6201,
                                    input 1,
                                    input sod_site,
                                    input '').
                  if not batchrun then pause.

                  /* SEE IF THERE IS A DEFAULT LOCATION FOR A  */
                  /* CUSTOMER RESERVED LOCATION                */
                  {gprun.i ""sorldft.p""
                     "(input so_ship,
                       input so_bill,
                       input so_cust,
                       input sod_site,
                       output cust-resv-loc,
                       output useloc)"}

                  sod_loc = if useloc
                            then
                               cust-resv-loc
                            else
                               pt_loc.

               end.
               /* If multi-line, we need to reject the line NOW. */
               else if not sngl_ln then do:
                  /* ITEM DOES NOT EXIST AT SITE */
                  run p-pxmsg (input 715, input 3).
                  if not batchrun then pause.
                  undo mainloop, retry.
               end.    /* if not sngl_ln */
            end.  /* if err_stat <> 0  */
         end.  /* if sod_type = "" */

      end. /* if new line */
      else do:  /* MODIFYING EXISTING LINE */

         /* IF WE'RE MAINTAINING RMA ISSUE LINES, AND THE    */
         /* USER HAS PICKED A RECEIPT LINE (OR VICE VERSA),  */
         /* DON'T LET HIM CONTINUE WITH IT...                */
         if this-is-rma then do:
            {&SOSOMTA-P-TAG33}
            if rma-issue-line then do:
               if sod_fsm_type = "RMA-ISS" then .
               else do:
                  /* NOT A VALID RMA ISSUE LINE */
                  run p-pxmsg (input 824, input 3).
                  undo mainloop, retry.
               end.
            end.    /* if rma-issue-line */
            else do:
               if sod_fsm_type = "RMA-RCT" then .
               else do:
                  /* NOT A VALID RMA RECEIPT LINE */
                  run p-pxmsg (input 7207, input 3).
                  undo mainloop, retry.
               end.
            end.    /* else do */
            {&SOSOMTA-P-TAG34}

            for first rmd_det
            fields(rmd_domain rmd_edit_isb rmd_exp_date rmd_line rmd_link
                   rmd_nbr rmd_prefix rmd_rma_line rmd_rma_nbr
                   rmd_rma_rtrn rmd_sa_nbr rmd_sv_code rmd_type)
             where rmd_domain = global_domain
              and  rmd_nbr    = sod_nbr
              and  rmd_prefix = "C"
              and  rmd_line   = sod_line no-lock:
            end. /* FOR FIRST RMD_DET */

            assign
               rmd-recno = recid(rmd_det).
         end.    /* if this-is-rma */

         assign
            global_loc = sod_loc
            new_line = no.

         /* Reverse old history */
         /* CREATE TEMP-TABLE WITH OLD LINE INFO */
         empty temp-table tt_soddet no-error.
         buffer-copy sod_det to tt_soddet.

         if sod_det.sod_confirm then
            run create-sobfile (
                buffer sod_det,
                input global_domain).

      end.   /* else, modify existing line, do */

      assign
         so_recno = recid(so_mstr)
         sod_recno = recid(sod_det).

      run setPoAckWait.

      /* THIS WILL CAUSE ANY WARNINGS THAT ARE DISPLAYED FOR THE */
      /* ITEM TO PAUSE.                                          */
      message.
      message.

      /* CALL CONSIGNMENT PROGRAM TO READ AND RETRIEVE CONSIGNMENT */
      /* HEADER IF IT EXISTS.  DO THIS ONLY ON NEW LINES.          */
      if using_cust_consignment and new_line then do:
         proc_id = "init".
         {gprunmo.i
            &program=""socnsod.p""
            &module="ACN"
            &param="""(input  proc_id,
                       input  sod_det.sod_nbr,
                       input  string(sod_det.sod_line),
                       input  sod_det.sod_part,
                       input  so_ship,
                       input  sod_det.sod_site,
                       input  no,
                       output l_undo_all2)"""}
      end. /* IF using_cust_consignment */

      /* SKIP FURTHER UPDATES IF THIS LINE IS A BTB SO LINE THAT */
      /* HAS TO BE DELETED CAUSED BY A ROLL-BACK */
      if not del-yn then do:

         /* THE LINE MAINTENANCE SUBROUTINES ARE TOLD   */
         /* WHETHER THEY'RE DOING SALES ORDERS OR RMA'S */
         /* AND, IF RMA'S, ARE PASSED ADDITIONAL INFO.  */
         /* ABOUT THE CURRENT RMA LINE.                 */
         {&SOSOMTA-P-TAG35}

         /* ADDED INPUT OF consign_flag AND using_cust_consignment */
         /* VARIABLE TO THE CALL TO sosomtla.p.                    */
         /* SS - 100620.1 - B
         {gprun.i ""xxsosomtla.p""
            "(input this-is-rma,
              input rma-recno,
              input rma-issue-line,
              input rmd-recno,
              input table tt_field_recs,
              input using_cust_consignment,
              output confirmApoAtpOrderLine)"}
        SS - 100620.1 - E */
        /* SS - 100620.1 - B */
        {gprun.i ""xxk1sosomtla.p""
            "(input this-is-rma,
              input rma-recno,
              input rma-issue-line,
              input rmd-recno,
              input table tt_field_recs,
              input using_cust_consignment,
              output confirmApoAtpOrderLine)"}
        /* SS - 100620.1 - E */

         if not sngl_ln then run checkLastKey.

      end.  /* if not del-yn */

      if undo_all then undo mainloop, next mainloop.

         /* CLEAN UP THE TEMP TABLE RECORDS*/
         for each tt_field_recs exclusive-lock:
            delete tt_field_recs.
         end.

      {&SOSOMTA-P-TAG36}

      if del-yn = yes then do:

/*SS 20080401 - B*/
					for first wo_mstr where wo_domain = global_domain and wo_nbr = sod_det.sod_nbr + string(sod_det.sod_line,"999")
						and wo_part = sod_det.sod_part no-lock:
						message "订单项已经排程,不能删除".
						undo mainloop, retry mainloop.
					end.
/*SS 20080401 - E*/

         for first wo_mstr
         fields (wo_domain wo_nbr wo_part)
            where wo_domain = global_domain
            and   wo_nbr  = (sod_det.sod_nbr + "." + string(sod_det.sod_line))
            and   wo_part = sod_det.sod_part
         no-lock:
            /* Final assy work order exists for this line */
            run p-pxmsg (input 515, input 2).
            pause.
         end. /* FOR FIRST WO_MSTR */

         if sod_det.sod_sched and
            (can-find (first sch_mstr where sch_domain = global_domain
                        and (sch_type = 1               and
                             sch_nbr  = sod_det.sod_nbr and
                             sch_line = sod_det.sod_line)) or
             can-find (first sch_mstr where sch_domain = global_domain
                        and (sch_type = 2               and
                             sch_nbr  = sod_det.sod_nbr and
                             sch_line = sod_det.sod_line)) or
             can-find (first sch_mstr where sch_domain = global_domain
                        and  sch_type = 3               and
                             sch_nbr  = sod_det.sod_nbr and
                             sch_line = sod_det.sod_line))
         then do:
            run p-pxmsg (input 6022, input 3).
            undo mainloop, retry mainloop.
         end.

         /* DELETE EMT RELATED DATA */

         /* PRIMARY SO */
         if soc_use_btb and not so_secondary then do:


            /* TRANSMIT DELETE OF PRIM. SO TO PO AND SEC. SO */
            run p-process-emt
               (output return-msg).

            /* DISPLAY ERROR MESSAGE RETURN FROM SOSOBTB1.P */
            if return-msg <> 0 and return-msg <> 343 then do:
               run p-pxmsg (input return-msg, input 3).
               return-msg = 0.
               undo mainloop, retry mainloop .
            end.

         end.  /* if soc_use_btb and so_primary */

         /* SECONDARY SO */
         if so_secondary then do:
            /* Deletion is not allowed from the SBU */
            run p-pxmsg (input 2938, input 3).
            undo mainloop, retry mainloop .
         end.

         /* PROCEDURE TO DELETE WORK FILE wkf-btb */

         run p-del-wkfbtb
            (input so_secondary,
             input so_stat,
             input so_inv_mthd,
             input sod_det.sod_btb_po).

         /* WE ONLY WANT TO DELETE INFO IN REMOTE DB'S IF LINE IS CONFIRMED */
         if sod_det.sod_confirm then do:

            /* Delete line information that might exist in other databases */
            for first si_mstr
               fields(si_domain si_db si_site)
               where si_domain = global_domain
               and   si_site   = sod_det.sod_site
            no-lock:
            end. /* FOR FIRST si_mstr */

            if available si_mstr
            and si_db <> so_db
            then do:

               {gprun.i ""gpmdas.p"" "(input si_db, output err-flag)" }

               if err-flag = 0
               or err-flag = 9
               then do:
                  assign
                     sonbr  = so_nbr
                     soline = sod_det.sod_line.
                  /* ADDED INPUT PARAMETER no TO NOT EXECUTE */
                  /* MFSOFC01.I AND MFSOFC02.I WHEN CALLED   */
                  /* FROM DETAIL LINES                       */
                  {gprun.i ""solndel.p"" "(input no)"}
               end. /* IF err-flag = 0 OR err-flag = 9 */

               /* Reset the db alias to the sales order database */
               {gprun.i ""gpmdas.p"" "(input so_db, output err-flag)" }
               sod_recno = recid(sod_det).

            end. /* IF AVAILABLE si_mstr and ... */

         end. /* if sod_confirm */

         /* DELETE ALLOCATION DETAIL*/
         run p-laddel.

         /* UPDATE ACCUM QTY WORKFILE WITH REVERSAL.  */
         /* save_parent_list DETERMINED IN sosomtla.p */
         if rma-line-type <> "RMA-RCT" and
            (line_pricing or not new_order)
         then do:

            {gprun.i ""gppiqty2.p""
               "(sod_det.sod_line,
                 sod_det.sod_part,
                 - save_qty_ord,
                 - (save_qty_ord * save_parent_list),
                 sod_det.sod_um,
                 yes,
                 yes,
                 yes)"}
         end.

         /* DELETE SALES ORDER LINE RELATED PRICE LIST HISTORY */
         if rma-line-type <> "RMA-RCT" then do:
            {gprun.i ""gppihdel.p""
               "(1, sod_det.sod_nbr, sod_det.sod_line)"}
         end.

         /* DELETE SOB_DET */

         /** TO DELETE SOB_DET RECORDS FOR CENTRAL DB WHEN A  **/
         /** SALES ORDER LINE WITH REMOTE DB IS DELETED       **/
         run p-sobdel.

         {&SOSOMTA-P-TAG37}
         if sod_det.sod_sched then do:
            find scx_ref where
                 scx_domain = global_domain   and
                 scx_type   = 1               and
                 scx_order  = sod_det.sod_nbr and
                 scx_line   = sod_det.sod_line
            exclusive-lock.
            delete scx_ref.
         end.

         /* DELETE IMPORT EXPORT RECORDS */
         find first ied_det where
                    ied_domain = global_domain and
                    ied_type = "1" and
                    ied_nbr  = so_nbr and
                    ied_line = sod_det.sod_line
         exclusive-lock no-error.
         if available ied_det then
            delete ied_det.
         {&SOSOMTA-P-TAG38}

         assign
            sod_det.sod_qty_ord  = temp_sod_qty_ord
            sod_det.sod_qty_ship = temp_sod_qty_ship
            sod_det.sod_qty_all  = temp_sod_qty_all
            sod_det.sod_qty_pick = temp_sod_qty_pick.

         if using_line_charges then do:
             /* DELETE SALES ORDER DETAIL LINE CHARGE RECORDS */
            {gprunmo.i
               &program = ""sosodlcd.p""
               &module = "ACL"
               &param = """(input sod_det.sod_nbr,
                            input sod_det.sod_line)"""}
         end.

         /* DELETE SALES ORDER DETAIL RELATIONSHIPS */
         {gprun.i ""sosoapm4.p"" "(input sod_det.sod_nbr,
                                   input sod_det.sod_line)"}

         /* IF LOGISTICS ACCOUNTING IS ENABLED */
         if use-log-acctg then do:

            tax_type = "41".
            if so_fsm_type = "RMA" then
               tax_type = "46".

            /* DELETE LOGISTICS ACCOUNTING tx2d_det RECORDS FOR SO LINE */
            {gprunmo.i &module = "LA" &program = "lataxdel.p"
                       &param  = """(input tax_type,
                                     input sod_det.sod_nbr,
                                     input sod_det.sod_line)"""}
         end.   /* use-log-acctg */

         delete sod_det.

         /* FOR RMA'S, WE HAVE SOME ADDITIONAL DELETE CLEANUP TO DO:
          *
          * - IF THE RMA LINE IS LINKED TO ANOTHER RMA LINE,
          * ERASE THAT LINK.  NOTE: AN RMA LINE NUMBER IS STORED
          * IN RMD_LINE. THE RMA LINE IT'S LINKED TO WOULD BE
          * NOTED IN RMD_LINK.
          *
          * - IF THE RMA RECEIPT LINE IS LINKED TO AN RTS, ERASE
          * THAT LINK. NOTE: THIS LINKAGE BETWEEN RMA'S AND
          * RTS'S IS ACCOMPLISHED VIA FIELDS RMD_RMA_LINE AND
          * RMD_RMA_NBR.  ON AN RTS RETURN LINE, THESE FIELDS
          * WOULD POINT TO THE RMA RECEIPT LINE, AND ON THE RMA
          * RECEIPT LINE, THEY'D POINT TO THE RTS RETURN LINE.  */

         if this-is-rma then do:

            run cleanUpLinkageForRMA.

            run clearRTS.

            delete rmd_det.
         end.    /* if this-is-rma */

         assign
            line = line - 1
            del-yn = no.
         clear frame c.
         if sngl_ln then clear frame d.

         /* Line Item deleted */
         run p-pxmsg (input 6, input 1).
         next mainloop.
      end.
      run pl-comment.

      if not sngl_ln then down 1 with frame c.

      /* IF IMPORT EXPORT MASTER RECORD EXIST  THEN CALL THE IMPORT     */
      /* EXPORT DETAIL LINE CREATION PROGRAM TO CREATE ied_det          */
      imp-okay = no.
      if can-find
         (first ie_mstr
             where ie_domain = global_domain
             and   ie_type = "1"
             and   ie_nbr =  sod_det.sod_nbr)
      then do:
         {gprun.i ""iedetcr.p""
            "(input ""1"",
              input sod_det.sod_nbr,
              input sod_det.sod_line,
              input recid(sod_det),
              input-output imp-okay)"}
         if imp-okay = no then undo mainloop, retry.
      end.

   end. /* mainloop: */

end. /* linefmt */

{&SOSOMTA-P-TAG39}

if sngl_ln then hide frame d.

hide frame c.
hide frame a.

{&SOSOMTA-P-TAG40}

PROCEDURE pl-comment:
/* ------------------------------------------------------------------
 * Purpose:     Display the comment for the associated price list.
 * Parameters:  <None>
 * Notes:
 * ------------------------------------------------------------------*/

   for first cm_mstr
      fields (cm_domain cm_addr cm_promo)
       where cm_domain = global_domain
       and   cm_addr = so_mstr.so_cust
   no-lock: end.

   if not sod_det.sod_bonus
      and soc_ctrl.soc_apm
      and available cm_mstr
      and cm_promo <> ""
      and not this-is-rma
   then
   for each pih_hist where
            pih_domain   = global_domain   and
            pih_doc_type = 1               and
            pih_nbr      = sod_det.sod_nbr and
            pih_line     = sod_det.sod_line
   no-lock:

      if pih_promo2 = "B" then do on endkey undo, leave:

         /* DISPLAY THE COMMENT ASSOCIATED TO THE PI_LIST */
         for first pi_mstr
            fields (pi_domain pi_cmtindx pi_list_id)
             where pi_domain = global_domain
              and  pi_list_id = pih_list_id
         no-lock:
            cmtindx = pi_mstr.pi_cmtindx.
            {gprun.i ""gpcmmt04.p"" "(input ""pi_mstr"")"}
         end. /* FOR FIRST PI_MSTR */

      end. /* CONTAIN BONUS STOCK PRICE LIST */
   end. /*  FOR EACH PIH_HIST  */

END PROCEDURE.

PROCEDURE p-sobdel:
/* ------------------------------------------------------------------
 * Purpose:     Delete configuration records
 * Parameters:  <None>
 * Notes:
 * ------------------------------------------------------------------*/

   for each sob_det where
            sob_domain = global_domain
        and sob_nbr    = sod_det.sod_nbr
        and sob_line   = sod_det.sod_line
   exclusive-lock:

      for each cmt_det
         where cmt_domain = global_domain
         and   cmt_indx   = sob_det.sob_cmtindx
      exclusive-lock:
         delete cmt_det.
      end. /* FOR EACH CMT_DET */

      if (line_pricing or not new_order) and
         so_db = global_db then do:
         {gprun.i ""gppiqty2.p""
            "(sod_det.sod_line,
              sob_part,
              - (sob_qty_req / sod_det.sod_um_conv),
              - (sob_tot_std * sob_qty_req / sod_det.sod_um_conv),
              sod_det.sod_um,
              yes,
              yes,
              yes)"}
      end.

      delete sob_det.

   end. /* FOR EACH SOB_DET */

   /* DELETE COST SIMULATION DETAIL */
   for each sct_det where
            sct_domain = global_domain  and
            sct_part = sod_det.sod_part and
            sct_sim  = string(sod_det.sod_nbr) + "."
                     + string(sod_det.sod_line)
   exclusive-lock:
      delete sct_det.
   end. /* FOR EACH SCT_DET */

   {&SOSOMTA-P-TAG41}

END PROCEDURE.

PROCEDURE p-laddel:
/* ------------------------------------------------------------------
 * Purpose:     Delete lad_det records
 * Parameters:  <None>
 * Notes:
 * -----------------------------------------------------------------*/

   for each lad_det where
            lad_domain  = global_domain     and
            lad_dataset = "sod_det"         and
            lad_nbr     = sod_det.sod_nbr   and
            lad_line = string(sod_det.sod_line)
   exclusive-lock:

      find ld_det
         where ld_domain = global_domain
          and  ld_site   = lad_site
          and  ld_loc    = lad_loc
          and  ld_lot    = lad_lot
          and  ld_ref    = lad_ref
          and  ld_part   = lad_part
      exclusive-lock no-error.

      if available ld_det then
         ld_qty_all = ld_qty_all - (lad_qty_all + lad_qty_pick).

      delete lad_det.

   end.

END PROCEDURE.

{&SOSOMTA-P-TAG42}

PROCEDURE p-pxmsg:
/* ------------------------------------------------------------------
 * Purpose:     Display messages
 * Parameters:  <None>
 * Notes:
 * ------------------------------------------------------------------*/
   define input parameter l_num  as integer no-undo.
   define input parameter l_stat as integer no-undo.

   {pxmsg.i &MSGNUM=l_num &ERRORLEVEL=l_stat}

END PROCEDURE.

PROCEDURE p-process-emt:
/* ------------------------------------------------------------------
 * Purpose:     Queue doc for transmission to SBU if line item deleted
 * Parameters:
 *              p-return-msg Error Message Number
 * Notes:
 * ------------------------------------------------------------------*/
   define output parameter p-return-msg like msg_mstr.msg_nbr no-undo.

   define variable use-cmf    as logical no-undo.
   define variable queue-doc  as logical no-undo.

   s-create-pod-line = no.

   find first wkf-btb2 where w2-sodline = sod_det.sod_line
   no-lock no-error.

   /* ADDED CODE TO UNQUEUE trq_mstr */

   if available wkf-btb2
      and w2-pod-so-status = ""
   then do:

      /* EXIT IF ANY PENDING CHANGES */
      if w2-cmf-status <> "x"
      then do:
         /* CHANGE ON BTB SO WITH PENDING CHANGES IS NOT ALLOWED */
         {pxmsg.i &MSGNUM=2834 &ERRORLEVEL=3}
         error_flag = yes.
         return.
      end. /* IF w2-cmf-status <> "x" */

      /* UNQUEUE DOCUMENT  FOR TRANSMISSION - BTB */
      for first trq_mstr
         fields(trq_domain trq_add_ref trq_doc_ref trq_doc_type
         trq_id trq_msg_type)
         where trq_domain   = global_domain
         and   trq_doc_type = "PO"
         and   trq_doc_ref  = sod_btb_po
      no-lock:
      end. /*FOR FIRST trq_mstr */

      if available trq_mstr
      then do:
         assign
            doc-type = trq_doc_type
            doc-ref  = trq_doc_ref
            add-ref  = trq_add_ref
            msg-type = trq_msg_type
            trq-id = trq_id.

         /* UNQUEUE DOCUMENT */
         {gprun.i ""gpquedoc.p""
            "(input-output doc-type,
              input-output doc-ref,
              input-output add-ref,
              input-output msg-type,
              input-output trq-id,
              input no)"}

         if trq-id <> 0
         then do:
            /* UNQUEUEING FAILED */
            {pxmsg.i &MSGNUM=2808 &ERRORLEVEL=3}
            error_flag = yes.
            return.
         end. /*IF trq-id <> 0 */
      end. /* IF AVAILABLE trq_mstr */
   end. /* IF AVAILABLE wkf-btb2 AND w2-pod_so_status = "" */

   if available wkf-btb2 and
      (w2-po-xmit = "2" or w2-po-xmit = "4"
   or (w2-po-xmit = "3" and w2-cmf-status = "x"))
   then
      assign
         queue-doc = yes
         use-cmf = yes.
   else
      assign
         queue-doc = no
         use-cmf = no.

   /* ADDED THE FOURTEENTH PARAMETER AS 'YES' */
   {gprun.i ""socram01.p""
      "(input sod_det.sod_nbr,
        input sod_det.sod_line,
        input-output sod_det.sod_btb_po,
        input-output sod_det.sod_btb_pod_line,
        input no,
        input yes,
        input sod_det.sod_site,
        input so_mstr.so_ship,
        input sod_det.sod_qty_ord,
        input no,
        input sod_det.sod_due_date,
        input sod_det.sod_due_date,
        input use-cmf,
        input yes,
        output p-return-msg)"}

   s-rollback = no.  /* RESET VARIABLE WHEN ROLLING BACK */

   /* Only continue processing if no error has occurred */
   if p-return-msg = 0 or p-return-msg = 343 then do:

      if queue-doc = yes then do:

         find first wkf-btb where
                w-so-nbr   = sod_det.sod_nbr
            and w-po-nbr   = sod_det.sod_btb_po
            and w-pod-line = sod_det.sod_btb_pod_line
         no-lock no-error.

         if not available wkf-btb
            or w-sod-line <> sod_det.sod_line
         then do:
            /* CREATE WORKFILE TO QUEUE DOCUMENT AGAIN */
            create wkf-btb.
            assign
               w-so-nbr   = sod_det.sod_nbr
               w-sod-line = sod_det.sod_line
               w-btb-vend = sod_det.sod_btb_vend
               w-btb-type = sod_det.sod_btb_type
               w-po-nbr   = sod_det.sod_btb_po
               w-pod-line = 0.
         end.  /* not available wkf-btb */

         w-msg-type = "ORDCHG".

      end. /* if queue-doc */

      /* DELETE DIRECT ALLOCATION AT THE SBU SITE */
      if available wkf-btb2 and
         (w2-po-xmit = "1" or w2-po-xmit = "2")
      then do:

         for first si_mstr
            fields(si_domain si_db si_site)
            where si_domain = global_domain
            and   si_site   = sod_det.sod_btb_vend
         no-lock:
         end. /* FOR FIRST si_mstr */

         if available si_mstr
         then do:

            /* SWITCH TO DATABASE OF SECONDARY BUSINESS UNIT */
            {gprun.i ""gpmdas.p"" "(input si_db, output err_flag)"}

         end. /* IF AVAILABLE si_mstr */

         if err_flag = 0
         then do:

            /* SBU DATABASE CONNECTION = OK */
            /* DELETE DIRECT SO ALLOCATIONS BTB ON SBU */
            {gprun.i ""sosoall.p""
               "(input sod_det.sod_nbr,
                 input sod_det.sod_line,
                 input so_mstr.so_ship,
                 input so_mstr.so_bill,
                 input so_mstr.so_cust,
                 input so_mstr.so_fsm_type,
                 input sod_det.sod_part,
                 input prev_qty_ord,
                 input sod_det.sod_um_conv,
                 input sod_det.sod_btb_vend,
                 input yes)"}
         end.      /* if err_flag = 0 */

         /* CHANGE DATABASE BACK TO PRIMARY BUSINESS UNIT */
         {gprun.i ""gpmdas.p"" "(input so_db, output err_flag)"}

      end. /* delete direct allocation */

   end. /* if return-msg */

END PROCEDURE.

PROCEDURE setTaxDefaults:
/* ------------------------------------------------------------------
 * Purpose:     Set tax defaults.
 *              Initialize tax management fields.
 *
 * Parameters:
 * Notes:
 * ------------------------------------------------------------------*/

   /* SET TAX DEFAULTS */
   /* INITIALIZE TAX MANAGEMENT FIELDS */
   assign
      sod_det.sod_taxable = (so_mstr.so_taxable and pt_mstr.pt_taxable)
      sod_det.sod_taxc = pt_taxc.
   {&SOSOMTA-P-TAG43}
   {&SOSOMTA-P-TAG44}
   assign
      sod_det.sod_prodline = pt_prod_line
      sod_det.sod_um  = pt_um.

END PROCEDURE.  /* setTaxDefaults */

PROCEDURE cleanUpLinkageForRMA:
/* ------------------------------------------------------------------
 * Purpose:     Clean up linkage within the current RMA.
 * Parameters:
 * Notes:
 * ------------------------------------------------------------------*/

   /* CLEAN UP LINKAGE WITHIN THE CURRENT RMA */
   find rmd_det where recid(rmd_det) = rmd-recno
   exclusive-lock no-error.
   if rmd_det.rmd_link <> 0 then do:
      find rmdbuff where
           rmdbuff.rmd_domain = global_domain and
           rmdbuff.rmd_nbr    = rmd_det.rmd_nbr and
           rmdbuff.rmd_prefix = "C"  and /* C = Customer */
           rmdbuff.rmd_line   = rmd_det.rmd_link
      exclusive-lock no-error.
      if available rmdbuff then
         rmdbuff.rmd_link = 0.
   end.    /* if rmd_det.rmd_link <> 0 then */

END PROCEDURE.  /* cleanUpLinkageForRMA */

PROCEDURE clearRTS:
/* ------------------------------------------------------------------
 * Purpose:     Clear an RTS, if exists, for receipt lines.
 * Parameters:
 * Notes:
 * ------------------------------------------------------------------*/

   /* FOR RECEIPT LINES, SEE IF THERE'S AN RTS TO CLEAR ALSO */
   if not rma-issue-line and rmd_det.rmd_rma_nbr <> " "then do:
      find rmdbuff where
           rmdbuff.rmd_domain = global_domain and
           rmdbuff.rmd_nbr    = rmd_det.rmd_rma_nbr and
           rmdbuff.rmd_prefix = "V"  and /* V = Vendor */
           rmdbuff.rmd_line   = rmd_det.rmd_rma_line
      exclusive-lock no-error.
      if available rmdbuff then
         assign
            rmdbuff.rmd_rma_nbr = " "
            rmdbuff.rmd_rma_line = 0.
   end.  /* if not rma-issue-line and... */

END PROCEDURE.  /* clearRTS */

PROCEDURE setPoAckWait:
/* ------------------------------------------------------------------
 * Purpose:     Set whether order is waiting for PO acknowledgement.
 *              Initialize tax management fields.
 * Parameters:
 * Notes:
 * ------------------------------------------------------------------*/

      /*  INITIAL ORDER WAITING FOR PO ACK */
      if can-find(trq_mstr where trq_domain = global_domain
                             and trq_doc_type = "SO"
                             and trq_doc_ref  = so_mstr.so_nbr
                             and (trq_msg_type = "ORDRSP-I"))
      then
         po-ack-wait = yes.

      else if so_primary and sod_det.sod_btb_po <> "" then do:

         for first po_mstr
            fields (po_domain po_nbr po_xmit)
            where po_domain = global_domain
              and po_nbr = sod_det.sod_btb_po
         no-lock:
            if (po_xmit = "2" or po_xmit = "5")
            then
               po-ack-wait = yes.
         end. /* FOR FIRST PO_MSTR */

      end.

END PROCEDURE.  /* setPoAckWait */

PROCEDURE checkLastKey:
/* ------------------------------------------------------------------
 * Purpose:     Check return key from sosomtla.p call.
 *              If a quote was created in Adexa's APO ATP model
 *              but user selects to cancel order line,
 *              the quote needs to be deleted.
 *      This is only applicable for multi line entry.
 *
 * Parameters:
 * Notes:
 * ------------------------------------------------------------------*/

   if keyfunction(lastkey) = "end-error" then do:
   /* During APO ATP processing, if user hits F4 within  */
   /* order entry before a request has been confirmed,   */
   /* the quote record in Adexa needs to be deleted.     */
      if confirmApoAtpOrderLine then do:
         {pxrun.i &proc='buildDemandId'
            &program='giapoxr.p'
            &handle=ph_giapoxr
            &param=("input so_mstr.so_nbr,
                     input sod_det.sod_line,
                     input sod_det.sod_site,
                     output apoDemandId")
            &module='GI1'}
         {pxrun.i &proc='deleteDemandRecord'
            &program='giapoxr.p'
            &handle=ph_giapoxr
            &param=("input sod_det.sod_site,
                     input sod_det.sod_part,
                     input apoDemandId,
                     output apoMessageNumber")
            &catcherror=TRUE
            &noapperror=TRUE
            &module='GI1'}
         if return-value <> {&SUCCESS-RESULT} then do:
           {pxmsg.i &MSGNUM=apoMessageNumber &MSGARG1=apoDemandId
                    &ERRORLEVEL={&WARNING-RESULT}}
         end.
      end.  /* confirmApoAtpOrderLine */
   end. /* keyfunction(lastkey) = "end-error" */

END PROCEDURE.  /* checkLastKey */

PROCEDURE message-args:
/*-----------------------------------------------------------------------
   Purpose:      To display message with arguments

   Parameters:   1. input i-msgnum - message number
                 2. input i-level - error level
                 3. input i-arg1  - argument 1
                 4. input i-arg2  - argument 2

   Note:         Procedure created to remove Error "Action Segment has exceeded
                 its limit of 63488 bytes".
-------------------------------------------------------------------------*/

   define input        parameter i-msgnum as integer no-undo.
   define input        parameter i-level  as integer no-undo.
   define input        parameter i-arg1   as character no-undo.
   define input        parameter i-arg2   as character no-undo.

   {pxmsg.i &MSGNUM= i-msgnum &ERRORLEVEL=i-level
               &MSGARG1 = i-arg1
               &MSGARG2 = i-arg2}

END PROCEDURE. /* message-args */


PROCEDURE mcpl-mc-curr-conv:
/*-----------------------------------------------------------------------
   Purpose:      To convert amount from i-curr1 to i-curr2

   Parameters:   1. input i-curr1 - source currency
                 2. input i-curr2 - target currency
                 3. input i-rate1 - rate1
                 4. input i-rate2 - rate2
                 5. input i-amt   - amount to convert
                 6. input i-round - if rounding is needed
                 7. output o-amt   - converted amount
                 8. output o-error - error number if any

   Note:         Procedure created to remove Error "Action Segment has exceeded
                 its limit of 63488 bytes".
-------------------------------------------------------------------------*/

   define input parameter i-curr1      like exr_curr1 no-undo.
   define input parameter i-curr2      like exr_curr1 no-undo.
   define input parameter i-rate1      like exr_rate  no-undo.
   define input parameter i-rate2      like exr_rate  no-undo.
   define input parameter i-amt        like ard_amt   no-undo.
   define input parameter i-round      as logical     no-undo.
   define output parameter o-amt       like ard_amt   no-undo.
   define output parameter o-error     like mc-error-number no-undo.

   {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input i-curr1,
                          input i-curr2,
                          input i-rate1,
                          input i-rate2,
                          input i-amt,
                          input i-round,
                          output o-amt,
                          output o-error)"}
    if o-error <> 0 then
       run p-pxmsg (input mc-error-number, input 2).

END PROCEDURE. /* mcpl-mc-curr-conv */

PROCEDURE create-tt-field-recs:
/*-----------------------------------------------------------------------
   Purpose:      To create records in temp table tt_field_recs

   Parameters:   1. input i-global-domain
                 2. input i-so-nbr
                 3. input i-line
                 4. input i-this-is-rma
                 5.  buffer sod_det

   Note:         Procedure created to remove Error "Action Segment has exceeded
                 its limit of 63488 bytes".
-------------------------------------------------------------------------*/

   define input parameter i-global-domain  like global_domain  no-undo.
   define input parameter i-so-nbr         like so_nbr         no-undo.
   define input parameter i-line           like sod_line       no-undo.
   define input parameter i-this-is-rma    like mfc_logical    no-undo.
   define       parameter buffer   sod_det for sod_det.

   define variable so_fld as handle     no-undo.
   define variable l_knt  as integer    no-undo.
   define buffer tblcd_det for tblcd_det.

   find sod_det
      where sod_domain = i-global-domain
      and   sod_nbr = i-so-nbr
      and   sod_line = i-line
   exclusive-lock no-error.
   if available sod_det and not i-this-is-rma then do:
      /* CLEAR TEMP TABLE RECORDS*/
      for each tt_field_recs exclusive-lock:
         delete tt_field_recs.
      end.

      /* SAVE BEFORE SNAPSHOT OF SO LINE TO TEMP TABLE */
      for each tblcd_det no-lock
         where tblcd_det.tblcd_domain = i-global-domain and
               tblcd_table = "sod_det":
         create tt_field_recs.
         assign tt_field_name = tblcd_fld_name.
         create buffer so_fldname for table "sod_det".
         so_fld = buffer sod_det:buffer-field(tblcd_fld_name).

         /* CHANGED tt_field_value TO ARRAY OF LENGTH 5        */
         /* AND CONDITIONALLY ASSIGNING BUFFER-VALUE OF so_fld */
         if so_fld:EXTENT <> 0
         then do l_knt = 1 to so_fld:EXTENT:
            tt_field_value[l_knt] = so_fld:BUFFER-VALUE[l_knt].
         end. /* IF so_fld:EXTENT <> 0 */
         else
            tt_field_value[1] = so_fld:BUFFER-VALUE.

      end. /* FOR EACH TBLCD_DET*/
   end. /* IF AVAILABLE SOD_DET*/

END PROCEDURE. /* create-tt-field-recs */

PROCEDURE create-sod-det:
/*-----------------------------------------------------------------------
   Purpose:      To create sod_det records

   Parameters:   1. buffer so_mstr
                 2. buffer sod_det
                 3. input i-global-domain
                 4. input i-line
                 5. input i-consume
                 6. input i-soc_lcmmts
                 7. input i-socrt_int

   Note:         Procedure created to remove Error "Action Segment has exceeded
                 its limit of 63488 bytes".
-------------------------------------------------------------------------*/

   define       parameter buffer so_mstr  for  so_mstr.
   define       parameter buffer sod_det  for  sod_det.
   define input parameter i-global-domain like global_domain no-undo.
   define input parameter i-line          like sod_line      no-undo.
   define input parameter i-consume       like sod_consume  no-undo.
   define input parameter i-soc-lcmmts    like soc_lcmmts    no-undo.
   define input parameter i-socrt-int     like sod_crt_int   no-undo.

   create sod_det.

   {&SOSOMTA-P-TAG15}
   assign
      sod_domain     = i-global-domain
      sod_nbr        =   so_nbr
      sod_line       = i-line
      sod_due_date   = so_due_date
      sod_pricing_dt = so_pricing_dt
      sod_pr_list    = so_pr_list
      sod_consume    = i-consume
      sod_site       = so_site
      sod_slspsn[1]  = so_slspsn[1]
      sod_slspsn[2]  = so_slspsn[2]
      sod_slspsn[3]  = so_slspsn[3]
      sod_slspsn[4]  = so_slspsn[4]
      sodcmmts       = i-soc-lcmmts
      sod_fr_list    = so_fr_list
      sod_fix_pr     = so_fix_pr
      sod_crt_int    = i-socrt-int
      sod_translt_days = decimal(substring(so_conrep,2,6))
      /* END USER DEFAULTS FROM CUSTOMER SHIP-TO, BUT MAY */
      /* BE OVERRIDDEN IN THE ISB DEFAULTS POPUP FOR EACH */
      /* LINE ITEM.                                       */
      sod_project     = so_project
      sod_dsc_project = so_project
      sod_dir_all     = no.
   {&SOSOMTA-P-TAG16}
END PROCEDURE. /* create-sod-det */

PROCEDURE getLastSodLine:
   /* Purpose : TO GET THE LAST ITEM LINE FROM SOD_DET  */
   /*---------------------------------------------------*/
   define input  parameter l_domain like sod_domain no-undo.
   define input  parameter l_ord    like sod_nbr    no-undo.
   define output parameter l_line   like sod_line   no-undo.

   define buffer b_sod_det for sod_det.

   for last b_sod_det
      fields(sod_domain sod_nbr sod_line)
   where
      sod_domain = l_domain and
      sod_nbr    = l_ord
   no-lock:

      l_line = sod_line.
   end. /* FOR LAST b_sod_det */
END PROCEDURE. /* getLastSodLine */

PROCEDURE create-sobfile:
/*-----------------------------------------------------------------------
   Purpose:      To create sobfile records

   Parameters:   1. buffer sod_det
                 2. input i-global-domain

   Note:         Procedure created to remove Error "Action Segment has exceeded
                 its limit of 63488 bytes".
-------------------------------------------------------------------------*/

   define       parameter buffer sod_det  for sod_det.
   define input parameter i-global-domain like global_domain no-undo.

   define buffer sob_det for sob_det.
   define buffer sobfile for sobfile.

   {mfdel.i sobfile}
   if sod_type = "" then

   for each sob_det
      where sob_domain = i-global-domain
        and sob_nbr  = sod_nbr
        and sob_line = sod_line
   no-lock:
      create sobfile.
      assign
         sobpart    = sob_part
         sobsite    = sob_site
         sobissdate = sob_iss_date
         sobqtyreq  = sob_qty_req .
      if sod_consume = yes then
         sobconsume  = - sob_qty_req.
      else
         sobabnormal = - sob_qty_req.
   end.  /* for each sob_det  */

END PROCEDURE. /* create-sobfile */

PROCEDURE p-del-wkfbtb:
/* Purpose : TO DELETE WORK FILE wkf-btb                            */
/*------------------------------------------------------------------*/

   define input parameter ip_so_secondary like so_secondary no-undo.
   define input parameter ip_so_stat      like so_stat      no-undo.
   define input parameter ip_so_invmthd   like so_inv_mthd  no-undo.
   define input parameter ip_sod_btbpo    like sod_btb_po   no-undo.

   if not ip_so_secondary
   then do:
      for each wkf-btb
         where w-msg-type <> ""
      exclusive-lock break by w-po-nbr:

         if last-of(w-po-nbr)
         then do:
            for first ad_mstr
               fields(ad_domain ad_addr ad_po_mthd)
               where ad_domain = global_domain
               and   ad_addr   = w-btb-vend
            no-lock:
            end. /* FOR FIRST ad_mstr */

            for first vd_mstr
               fields(vd_domain vd_addr vd_rcv_held_so)
               where vd_domain = global_domain
               and   vd_addr   = w-btb-vend
            no-lock:
            end. /* FOR FIRST vd_mstr */

            if available ad_mstr
               and (ad_po_mthd = "e"
               or   ad_po_mthd = "b")
               and available vd_mstr
               and ((can-find(first po_mstr
               where po_domain = global_domain
               and   po_nbr    = ip_sod_btbpo
               and   po_xmit   = "4"))
               or ((can-find(first po_mstr
               where po_domain = global_domain
               and   po_nbr    = ip_sod_btbpo
               and   po_xmit   = "1"))
               and (ip_so_stat = ""
               or  (ip_so_stat = "HD"
               and vd_rcv_held_so = yes))))
               and w-po-nbr <> ""
            then do:
               assign
                  doc-type = "PO"
                  doc-ref  = w-po-nbr
                  add-ref  = ""
                  msg-type = w-msg-type
                  trq-id   = 0.

               /* QUEUE DOCUMENT FOR TRANSMISSION - BTB */
               {gprun.i ""gpquedoc.p""
                  "(input-output doc-type,
                    input-output doc-ref,
                    input-output add-ref,
                    input-output msg-type,
                    input-output trq-id,
                    input yes)"}.

            end. /* IF AVAILABLE ad_mstr AND ... */
         end. /* IF LAST-OF(w-po-nbr) */
         delete wkf-btb.
      end. /* FOR EACH wkf-btb WHERE w-msg-type <> "" */
   end.  /* IF NOT ip_so_secondary */
   /* SECONDARY SO */
   else do:

      find first wkf-btb
         where w-msg-type <> ""
      exclusive-lock no-error.

      if available wkf-btb
         and substring(ip_so_invmthd,3 ,1) = "e"
      then do:
         assign
            doc-type = "SO"
            doc-ref  = w-so-nbr
            add-ref  = ""
            msg-type = w-msg-type
            trq-id   = 0.

         /* QUEUE DOCUMENT FOR TRANSMISSION - BTB */
         {gprun.i ""gpquedoc.p""
            "(input-output doc-type,
              input-output doc-ref,
              input-output add-ref,
              input-output msg-type,
              input-output trq-id,
              input yes)"}
      end.  /* IF AVAILABLE wkf-btb AND .... */

      if available wkf-btb
      then
         delete wkf-btb.
   end. /* ELSE DO */

END PROCEDURE. /* PROCEDURE p-del-wkfbtb */
