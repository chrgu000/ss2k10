/* rsporc.p - Release Management Supplier Schedules - Shipper Confirm         */
/* Copyright 1986 QAD Inc. All rights reserved.                               */
/* $Id:: rsporc.p 31157 2013-05-16 13:44:05Z p8k                           $: */
/*                                                                            */
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
/* Revision: 1.95      BY: Paul Donnelly (SB)     DATE: 06/28/03  ECO: *Q005* */
/* Revision: 1.96      BY: Ed van de Gevel        DATE: 07/08/03  ECO: *Q003* */
/* Revision: 1.97      BY: Gnanasekar             DATE: 08/05/03  ECO: *P0XW* */
/* Revision: 1.98      BY: Deepak Rao             DATE: 08/20/03  ECO: *N2K3* */
/* Revision: 1.100     BY: Deepak Rao             DATE: 09/08/03  ECO: *N2KM* */
/* Revision: 1.102     BY: Anitha Gopal           DATE: 10/13/03  ECO: *N2LR* */
/* Revision: 1.103     BY: Pankaj Goswami         DATE: 12/16/03  ECO: *P1FV* */
/* Revision: 1.104     BY: Deepak Rao             DATE: 05/04/04  ECO: *P1ZD* */
/* Revision: 1.105     BY: Preeti Sattur          DATE: 06/02/04  ECO: *P24H* */
/* Revision: 1.108     BY: Veena Lad              DATE: 06/03/04  ECO: *P24K* */
/* Revision: 1.109     BY: Russ Witt              DATE: 06/21/04  ECO: *P1CZ* */
/* Revision: 1.110     BY: Sukhad Kulkarni        DATE: 06/25/04  ECO: *P26F* */
/* Revision: 1.113     BY: Paul Dreslinski        DATE: 10/30/04  ECO: *M1M3* */
/* Revision: 1.115     BY: Preeti Sattur          DATE: 11/15/04  ECO: *P2TP* */
/* Revision: 1.116     BY: Tejasvi Kulkarni       DATE: 12/28/04  ECO: *P31T* */
/* Revision: 1.117     BY: Tejasvi Kulkarni       DATE: 06/08/05  ECO: *R01M* */
/* Revision: 1.118     BY: Shivganesh Hegde       DATE: 07/21/05  ECO: *P3V6* */
/* Revision: 1.119     BY: Steve Nugent           DATE: 09/08/05  ECO: *P2PJ* */
/* Revision: 1.121     BY: Andrew Dedman          DATE: 10/13/05  ECO: *R01P* */
/* Revision: 1.122     BY: Julie Milligan         DATE: 10/17/05  ECO: *P37P* */
/* Revision: 1.124     BY: David Morris           DATE: 11/09/05  ECO: *R02G* */
/* Revision: 1.125     BY: Steven Nugent          DATE: 12/01/05  ECO: *R000* */
/* Revision: 1.127     BY: Ellen Borden           DATE: 01/17/06  ECO: *R008* */
/* Revision: 1.128     BY: Shridhar Mangalore     DATE: 02/19/06  ECO: *P4J2* */
/* Revision: 1.133     BY: Dan Herman             DATE: 03/15/06  ECO: *R001* */
/* Revision: 1.134     BY: Dan Herman             DATE: 05/04/06  ECO: *R02M* */
/* Revision: 1.136     BY: SurenderSingh Nihalani DATE: 05/16/06  ECO: *P4PQ* */
/* Revision: 1.137     BY: Changlin Zeng          DATE: 05/17/06  ECO: *R045* */
/* Revision: 1.138     BY: Robin McCarthy         DATE: 05/31/06  ECO: *R02F* */
/* Revision: 1.139     BY: SurenderSingh Nihalani DATE: 06/19/06  ECO: *P4S2* */
/* Revision: 1.140     BY: Robin McCarthy         DATE: 06/15/06  ECO: *R04H* */
/* Revision: 1.141     BY: Robin McCarthy         DATE: 06/30/06  ECO: *R04J* */
/* Revision: 1.142     BY: SurenderSingh Nihalani DATE: 06/27/06  ECO: *P4TZ* */
/* Revision: 1.143     BY: Xavier Prat            DATE: 07/05/06  ECO: *R07S* */
/* Revision: 1.144     BY: Changlin Zeng          DATE: 09/21/06  ECO: *R094* */
/* Revision: 1.147     BY: Edgar Roca             DATE: 11/28/06  ECO: *R0BV* */
/* Revision: 1.148     BY: Steve Nugent           DATE: 03/21/07  ECO: *R0FN* */
/* Revision: 1.150     BY: Julie Milligan         DATE: 06/04/07  ECO: *R0GW* */
/* Revision: 1.151     BY: Ambrose Almeida        DATE: 07/07/27  ECO: *Q189* */
/* Revision: 1.154     BY: Ken Casey              DATE: 07/28/07  ECO: *R0C6* */
/* Revision: 1.155     BY: Namita Patil           DATE: 11/17/07  ECO: *P5M4* */
/* Revision: 1.157     BY: Arun Nair              DATE: 11/17/07  ECO: *R08C* */
/* Revision: 1.158     BY: Neil Curzon            DATE: 03/17/08  ECO: *R0P6* */
/* Revision: 1.159     BY: Ruma Bibra             DATE: 04/01/08  ECO: *P6JW* */
/* Revision: 1.164     BY: Jean Miller            DATE: 06/17/08  ECO: *R0V9* */
/* Revision: 1.166     BY: Nan Zhang              DATE: 06/22/08  ECO: *R0JS* */
/* Revision: 1.167     BY: Niranjan Ranka         DATE: 08/26/08  ECO: *R12K* */
/* Revision: 1.168     BY: Kunal Pandya           DATE: 11/07/08  ECO: *Q1TR* */
/* Revision: 1.169     BY: Anju Dubey             DATE: 12/16/08  ECO: *R190* */
/* Revision: 1.170     BY: Steve Nugent           DATE: 02/13/09  ECO: *R1C1* */
/* Revision: 1.171     BY: Jiang Wan              DATE: 02/13/09  ECO: *R1BY* */
/* Revision: 1.173     BY: Prajakta Patil         DATE: 03/19/09  ECO: *P5Q7* */
/* Revision: 1.177     BY: Jean Miller            DATE: 05/06/09  ECO: *Q2TT* */
/* Revision: 1.178     BY: Jiang Wan              DATE: 07/31/09  ECO: *R1N2* */
/* Revision: 1.179     BY: Manjusha Inglay        DATE: 08/21/09  ECO: *Q2C9* */
/* Revision: 1.180     BY: Rajat Kulshreshtha     DATE: 10/29/09  ECO: *Q34B* */
/* Revision: 1.182     BY: Zhijun Guan            DATE: 09/09/09  ECO: *R1V9* */
/* Revision: 1.183     BY: Avishek Chakraborty    DATE: 04/29/10  ECO: *Q3X0* */
/* Revision: 1.184     BY: Yiqing Chen            DATE: 04/28/10  ECO: *R22Q* */
/* Revision: 1.186  BY: Avishek Chakraborty       DATE: 07/14/10  ECO: *R228* */
/* $Revision: 1.187 $ BY: Zheng Huang   DATE: 08/06/10 ECO: *R24M* */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*324******************************************By zy***********/
/* when have code_fldname = "Standard Cost Exchange Rate Type"*/
/* Standard PO , Supplier Scheduled Order & recive            */
/* use code_value as exchange rate type                       */
/* other wise use system standard exchange rate type          */

{us/mf/mfdtitle.i}
{us/gp/gpuid.i}
{us/mf/mfaititl.i}
{us/gl/gldydef.i new}
{us/gl/gldynrm.i new}

{us/po/porcdef.i "new" "new"}
{us/pp/ppprlst.i}   /* PRICE LIST CONSTANTS */
{us/ap/apconsdf.i}

/* User Update Restrictions Temp Table Definition */
{us/up/updaterestriction.i}

/* Define Handles for the programs. */
{us/px/pxphdef.i vdvdxr}
{us/px/pxphdef.i kbknbxr}
{us/px/pxphdef.i porcxr}
{us/px/pxphdef.i soldxr}

{us/px/pxmaint.i}

/* CONSTANTS */
{us/kb/kbconst.i}

/* KANBAN TEMP TABLE DEFINITIONS */
{us/kb/kbttkl.i}
{us/kb/kbtrtt.i}  /* KANBAN TRANSACTION CARD DETAIL INFORMATION */

/* Include the temp-table definition for tt_abs_shipper */
{us/so/sospdef.i}

{us/gp/gpldform.i}

/* TEMP-TABLE TO COLLECT PO LINE DETAIL DATA TO PROCESS FOR KANBAN TRANS */
define temp-table tt-poline-info no-undo
   field tt-poline-rowid         as rowid
   field tt-poNumber             as character
   field tt-poLine               as integer
   field tt-part                 as character
   field tt-qty                  as decimal
   field tt-loc                  as character
   field tt-lotser               as character
   field tt-ref                  as character
index tt-poline-rowid is unique
   tt-poline-rowid.

/* TEMP-TABLE ADDED TO COLLECT THE LINES WHICH ARE SHIPPED, */
/* WHICH CAN BE USED WHILE CALCULATING THE TAXES            */
define temp-table tt_po_tax
   field tt_po     like po_nbr
   field tt_line   like pod_line
index tt_po_line_indx tt_po tt_line.

define temp-table tt_receiver
   field tt_ponbr  like po_nbr
   field tt_recnbr like prh_receiver
index tt_primary
      tt_ponbr.

/* LOGISTICS CHARGE - PENDING VOUCHER MASTER TEMP TABLE DEFINITION */
define new shared temp-table tt-pvocharge no-undo
   field tt-lc_charge           like lc_charge
   field tt-pvo_id              as   integer
index tt-index
   tt-lc_charge
   tt-pvo_id.

define temp-table tt_po_lineqty no-undo
   field tt_part    like pt_part
   field tt_site    like pt_site
   field tt_loc     like pt_loc
   field tt_tpoline like pod_line
   field tt_qty     like mrp_qty
   index tt_index_part tt_part
         tt_site
         tt_loc.

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
define new shared variable conv          like um_conv label "Conversion"
   no-undo.
define new shared variable unit_cost     like tr_price label "Unit Cost".
define new shared variable ordernbr      like tr_nbr.
define new shared variable orderline     like tr_line.
define new shared variable so_job        like tr_so_job.
define new shared variable traddr        like tr_addr.
define new shared variable rmks          like tr_rmks.
define new shared variable dr_acct       like trgl_dr_acct.
define new shared variable dr_sub        like trgl_dr_sub.
define new shared variable dr_cc         like trgl_dr_cc.
define new shared variable project       like wo_project no-undo.
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
define variable send_ts_asn       as logical no-undo.
define variable trade_sale        as logical no-undo.
define variable l_line_active_yn  as logical no-undo.
define variable ip_wolot          like wo_lot no-undo.
define variable cum_id_expired    as logical no-undo.
define variable rcpt_time         like abs_arr_time no-undo.
define variable shipper_id        like abs_id no-undo.
define variable tempstr           as character no-undo.
define variable price_qty         as decimal.
define variable use-log-acctg     as logical no-undo.
define variable lv_error_num      as integer   no-undo.
define variable lv_name           as character no-undo.
define variable dftCOPAcct        like pl_pur_acct  no-undo.
define variable dftCOPSubAcct     like pl_pur_sub   no-undo.
define variable dftCOPCostCenter  like pl_pur_cc    no-undo.
define variable dftFLRAcct        like pl_flr_acct  no-undo.
define variable dftFLRSubAcct     like pl_flr_sub   no-undo.
define variable dftFLRCostCenter  like pl_flr_cc    no-undo.
define variable l_conv_cnt        like mfc_logical  no-undo.
define variable l_conv_cnt_prompt like mfc_logical  no-undo.
define variable l_abs_par_id      like abs_par_id   no-undo.
define variable l_cn              like mfc_logical  no-undo.
define variable err_flag          like mfc_logical initial no           no-undo.
define variable chg_attr         like mfc_logical label "Chg Attribute" no-undo.
define variable l_usage           like mfc_logical initial no           no-undo.
define variable absShipFrom like abs_mstr.abs_shipfrom no-undo.
define variable absID like abs_mstr.abs_id no-undo.
define variable cInventoryStatus    as character   no-undo initial "".
define variable hBlockedTransactionlibrary as handle no-undo.
define variable lagit             like mfc_logical  no-undo.
define variable poshivmt          like mfc_logical  no-undo.
define variable supplier-id       like abs_mstr.abs_shipfrom no-undo.
define variable shipper-id        like abs_mstr.abs_id       no-undo.
define variable posh-eff-date     as date           no-undo.
define variable ii                as integer        no-undo.
define variable ps-nbr            like prh_ps_nbr   no-undo.
define variable git-stat          like mfc_logical  initial false no-undo.
define variable l_rcv_type        like poc_rcv_type no-undo.
define variable poc_seq_rcv       as logical initial yes     no-undo.
define variable v_imflow          like im_flow      no-undo.
define variable l_po_locked       as   logical      no-undo.
define variable l_total           like sr_qty       no-undo.
define variable lLegacyAPI        as   logical      no-undo.
define variable l_int_ref_type    like lacd_internal_ref_type no-undo.
/* Global Shipping */
define variable c_form_code       like df_form_code    no-undo.
define variable c_ld_form_code    like df_ld_form_code no-undo.
define variable l_undo            like mfc_logical     no-undo.
define variable i_err_num         as   integer         no-undo.
define variable ld_max_lines      as   integer         no-undo.
define variable actual_lines      as   integer         no-undo.
define variable c_shpgrp          as   character       no-undo.

define variable l_po_nbrs as character no-undo initial "".

define buffer b_abs_mstr for abs_mstr.

define temp-table tt_abs_mstr     like abs_mstr.

define temp-table tt_abspli_ref no-undo
   field tt_abspli_pli_keyid like abspli_pli_keyid.

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

{us/gp/gpglefdf.i}

/* WORKFILE FOR POD RECEIPT ATTRIBUTES */
define new shared workfile attr_wkfl no-undo
   field chg_line    like sr_lineid
   field chg_assay   like tr_assay
   field chg_grade   like tr_grade
   field chg_expire  like tr_expire
   field chg_status  like tr_status
   field assay_actv  as logical
   field grade_actv  as logical
   field expire_actv as logical
   field status_actv as logical.

{us/mf/mfaimfg.i} /* COMMON API CONSTANTS AND VARIABLES */

{us/rs/rsdsporc.i "reference-only"} /* DEFINE TEMP TABLES FOR API 2.0  */
{us/po/popoit01.i} /* DEFINE API PURCHASE ORDER TEMP TABLES   */
{us/ic/icicit01.i} /* DEFINE API INVENTORY CONTROL TEMP TABLES   */
{us/mf/mftxit01.i} /* DEFINE API TRANSACTION TAX AMOUNTS TEMP TABLES   */
{us/px/pxmaint.i}  /* STANDARD MAINTENANCE COMPONENT INCLUDE FILE */

/* Define Buffers */
define buffer pod2 for pod_det.
define buffer pod3 for pod_det.
define buffer sub_abs for abs_mstr.

if c-application-mode = "API" then do:
   /* Get handle of API Controller */
   {us/bbi/gprun.i ""gpaigach.p"" "(output ApiMethodHandle)"}

   if valid-handle(ApiMethodHandle) then do:
      if execname = "lagitrc.p"
      or execname = "rsporc.p"
      then do:
         run getRequestDataset in ApiMethodHandle
            (output dataset dsPOShipperReceipt bind).
      end.
      else do:
         run getDataset in ApiMethodHandle (input "dsPOShipperReceipt",
                                    output dataset dsPOShipperReceipt bind).
      end.
      lLegacyAPI = false.
   end.
   else do:
      /* Get handle of API controller */
      run initAPI
         (output table ttPurchaseOrderShipTransTax,
          buffer ttPurchaseOrderShipperTrans).
      lLegacyAPI = true.
   end.
end. /* IF c-application-mode = "API" */

/* WIP Lot Trace functions and constants */
{us/wl/wlfnc.i} /*FUNCTION FORWARD DECLARATIONS*/
{us/wl/wlcon.i} /*CONSTANTS DEFINITIONS*/

/* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
{us/bbi/gprun.i ""lactrl.p"" "(output use-log-acctg)"}

l_int_ref_type = {&TYPE_POShipper}.

/* DETERMINE IF SHIPPER IS IN TRANSIT */
if use-log-acctg then do:
   {us/gp/gprunmo.i &module = "LA" &program = ""lagit.p""
              &param = """(output git-stat)"""}
end.

if use-log-acctg then do:
   /* CHECK IF THIS IS CALLED FROM SHIPPER/INVOICE MAINTENANCE */
   {us/bbi/gprun.i ""gpckpprg.p""
            "(input  'poshivmt',
              output poshivmt)"}

   if poshivmt then do:

      lagit = yes.

      for first qad_wkfl where qad_domain = global_domain
         and qad_key1   = SessionUniqueID
         and qad_key2   = "poshivmt"
      no-lock:
         assign
            shipper-id = qad_charfld[1]
            supplier-id = qad_charfld[2]
            posh-eff-date = qad_datefld[1].
      end.

      if not available qad_wkfl then return.

   end.
   else do:
      /* CHECK IF THIS IS LOGISTICS ACCOUNTING PO SHIPPER GIT RECEIPT PROGRAM */
      {us/bbi/gprun.i ""gpckpprg.p""
               "(input 'lagitrc',
                 output lagit)"}
   end.
end.

/* DELETE TEMP RECORDS FOR COPYING OPTION */
run removeTT_abs_mstr.

if is_wiplottrace_enabled() then do:
   {us/bbi/gprun.i ""wlpl.p"" "persistent set h_wiplottrace_procs"}
   {us/bbi/gprun.i ""wlfl.p"" "persistent set h_wiplottrace_funcs"}
end.

assign
   l_recalc_lbl = getTermLabelRtColon("RECALCULATE_FREIGHT",20).

{us/rc/rcwabsdf.i new}

{us/bbi/gprun.i ""socrshc.p""}

for first poc_ctrl where poc_domain = global_domain
no-lock: end.

for first shc_ctrl where shc_domain = global_domain
no-lock: end.

form
   abs_mstr.abs_shipfrom colon 20 label "Supplier"
   ad_name               at 45    no-label format "x(33)"
   abs_mstr.abs_id       colon 20 label "Shipper ID"
   ad_line1              at 45    no-label format "x(33)"
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   eff_date             colon 20
with frame bb side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame bb:handle).

/* POPUP TO PROMPT FOR FREIGHT RECALCULATION */
form
   space(1)
   l_recalc_lbl format "x(20)"
   l_recalc
with frame rr overlay no-labels centered row 11 .

if is_wiplottrace_enabled() then do:
   run init_poline_bkfl_input_wip_lot in h_wiplottrace_procs.
   run init_poline_bkfl_output_wip_lot in h_wiplottrace_procs.
end.

for first abs_mstr
   where recid(abs_mstr) = global_recid
no-lock: end.

if available abs_mstr then
   run SetMainScreen (input recid(abs_mstr)).

/* SET THE FLAG SO POPORCB.P WILL NOT CHG THE STATUS OF POD_DET IF */
/* THE LINE IS NOT RECEIVED */

/* SET shipper_id VARIABLE */
assign
   shipper_id = ""
   shipper_rec = true.

empty temp-table tt_po_lineqty.
mainloop:
repeat:

   if retry and poshivmt then do:

      for first qad_wkfl where qad_domain = global_domain
         and qad_key1   = SessionUniqueID
         and qad_key2   = "poshivmt"
      exclusive-lock:
         /* THIS IS SET TO INDICATE UNDO CONDITION FOR POSHIVMT PROGRAM */
         qad_logfld[1] = yes.
      end.

      return.
   end.

   empty temp-table tt_receiver.
   empty temp-table tt_po_tax.

   if c-application-mode = "API" and retry
      then return error return-value.

   if c-application-mode = "API" and not lLegacyAPI then do:
      run getNextRecord in apiMethodHandle (input "ttPOShipperReceipt").
      if return-value = {&RECORD-NOT-FOUND} then do:
         leave mainloop.
      end.
   end. /* if c-application-mode = "API" */

   run del_sr_wkfl.

   {us/gp/gprunp.i "soldxr" "p" "clearWorkTableOfLGAndGL"}

   do transaction with frame a:

      if c-application-mode = "API" and retry
         then return error return-value.

      /* EMPTY LOGISTICS ACCOUNTING TEMP TABLE */
      empty temp-table tt-pvocharge.

      if not poshivmt and c-application-mode <> "API" then do:

         prompt-for
            abs_mstr.abs_shipfrom
            abs_mstr.abs_id
         editing:

            if frame-field = "abs_shipfrom" then do:
               {us/mf/mfnp05.i abs_mstr abs_id
                  " abs_mstr.abs_domain = global_domain and abs_id  begins ""s""
                    and abs_type = ""r"""
                  abs_shipfrom
                  "input abs_shipfrom"}

               if recno <> ? then do:
                  for first ad_mstr where ad_domain = global_domain
                     and ad_addr   = abs_shipfrom
                  no-lock: end.

                  assign
                     disp_abs_id = substring(abs_id,2,50).

                  display
                     abs_mstr.abs_shipfrom
                     disp_abs_id     @ abs_id
                     ad_name         when(available ad_mstr)
                     ""              when(not available ad_mstr) @ ad_name
                     ad_line1        when(available ad_mstr)
                     ""              when(not available ad_mstr) @ ad_line1.
               end.
            end. /* if frame-field = abs_shipfrom */
            else if frame-field = "abs_id" then do:
               global_addr = input abs_shipfrom.

               {us/mf/mfnp05.i abs_mstr abs_id
                  " abs_mstr.abs_domain = global_domain and abs_shipfrom  = input
                    abs_shipfrom and
                    abs_id begins ""S"" and abs_type = ""R"""
                  abs_id """S"" + input abs_id"}

               if recno <> ? then do:
                  for first ad_mstr where ad_domain = global_domain
                     and ad_addr   = abs_shipfrom
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
         end. /* prompt-for */

         if available abs_mstr then
            assign shipper_id = substring(abs_id,2,20).

      end. /* if not poshivmt */

      if c-application-mode <> "API" then do:
         assign
            absShipFrom = input frame a abs_shipfrom
            absId       = input frame a abs_id.
      end. /* if c-application-mode <> "API" */
      else do:
         if not lLegacyAPI then
            assign
               {us/mf/mfaiprvl.i abs_mstr.abs_shipfrom
                  ttPOShipperReceipt.absShipfrom}
               {us/mf/mfaiprvl.i abs_mstr.abs_id
                  ttPOShipperReceipt.absId}
               absShipFrom = input abs_mstr.abs_shipfrom
               absId       = input abs_mstr.abs_id.
         else
            assign
               absShipFrom = ttPurchaseOrderShipperTrans.shipFrom
               absId       = ttPurchaseOrderShipperTrans.id.
      end. /* if c-application-mode = "API" */

      if not poshivmt
      then do:

         for first vd_mstr where vd_domain = global_domain
            and vd_addr   = absShipFrom
         no-lock: end.

         if not available vd_mstr then do:
            /* Not a valid Supplier */
            {us/bbi/pxmsg.i &MSGNUM=2 &ERRORLEVEL=3
               &FIELDNAME=""ttPOShipperReceipt.absShipfrom""}
            next-prompt abs_shipfrom.
            undo, retry.
         end.

         for first ad_mstr where ad_domain = global_domain
            and ad_addr   = absShipFrom
         no-lock: end.

         if c-application-mode <> "API" then
            display
               ad_name
               ad_line1.

         if absId = "" then do:
            /* Shipper ID Required */
            {us/bbi/pxmsg.i &MSGNUM=8188 &ERRORLEVEL=3}
            undo, retry.
         end.

      end. /* IF NOT poshivmt */
   end.

   if poshivmt then do:
       for first vd_mstr where vd_domain = global_domain
         and vd_addr   = supplier-id
      no-lock: end.

      for first ad_mstr where ad_domain = global_domain
         and ad_addr   = supplier-id
      no-lock: end.
   end.

   do transaction:

      for first abs_mstr where abs_domain   = global_domain
         and abs_shipfrom = (if not poshivmt then absShipFrom
                             else supplier-id)
         and abs_id       = (if not poshivmt then "s" + absId
                             else "s" + shipper-id)
         and abs_type       = "R"
      exclusive-lock: end.

      if not available abs_mstr then do:
         /* Shipper ID does not exist */
         {us/bbi/pxmsg.i &MSGNUM=8189 &ERRORLEVEL=3
            &FIELDNAME=""ttPOShipperReceipt.absId""}
         next-prompt abs_id with frame a.
         undo mainloop, retry mainloop.
      end.

      if substring(abs_status,2,1) = "y" then do:
         /* Shipper previously confirmed */
         {us/bbi/pxmsg.i &MSGNUM=8146 &ERRORLEVEL=3}
         undo mainloop, retry.
      end.

      /* Start blocked transaction library to run persistently */
      run mfairunh.p
         (input  "mgbltrpl.p",
          input  ?,
          output hBlockedTransactionlibrary).

      {us/mg/mgbltrpl.i "hBlockedTransactionlibrary"}

      /* Check to see if Supplier has any blocked transactions */
      if blockedSupplier(input (input abs_shipfrom),
                         input {&PO015},
                         input true,
                         input "Supplier")
      then do:
         undo mainloop, retry.
      end.

      delete PROCEDURE hBlockedTransactionlibrary.

      if substring(abs_status,2,1) = "t"
         and not poshivmt
         and lagit
      then do:
         /* Shipper previously received into a transit location */
         {us/bbi/pxmsg.i &MSGNUM=6113 &ERRORLEVEL=3}
         bell.
         undo mainloop, retry.
      end.

      empty temp-table tt_abspli_ref.

      /* Check to see if the pli_mstr record exists for this abs_id */
      for each abspli_ref where abspli_domain   = global_domain
         and abspli_abs_id   = abs_id
         and abspli_supplier = abs_shipfrom
      no-lock:

         for first tt_abspli_ref where tt_abspli_pli_keyid = abspli_pli_keyid
         no-lock: end.

         if not available tt_abspli_ref then do:
            create tt_abspli_ref.
            tt_abspli_pli_keyid = abspli_pli_keyid.
         end.
      end. /* FOR EACH ABSPLI_REF */

      if use-log-acctg
         and substring(abs_status,2,1) = "t"
         and not poshivmt
      then do:
         run deleteQadWkfl.
         run createQadWkfl.
      end.

      /* SET THE FISCAL ID FOR TAX ROUTINES */
      assign
         fiscal_id = string(abs_shipfrom, "x(8)") + substring(abs_id,2,50)
         abs_recid = recid(abs_mstr)
         ps_nbr    = substring(abs_id,2,50)
         eff_date  = if not poshivmt then today
                     else posh-eff-date.    /* EFFECTIVE DATE FROM POSHIVMT */

      if not poshivmt and c-application-mode <> "API" then
         update
            eff_date
         with frame bb.

      if c-application-mode = "API" then
         if not lLegacyAPI then
            assign
               {us/mf/mfaistvl.i eff_date ttPOShipperReceipt.effDate}.
         else
            assign
               {us/mf/mfaiset.i eff_date ttPurchaseOrderShipperTrans.effDate}.

      assign
         ship_date = if abs_mstr.abs_shp_date <> ? then abs_mstr.abs_shp_date
                     else eff_date
         ship_dt   = if abs_mstr.abs_shp_date <> ? then abs_mstr.abs_shp_date
                     else eff_date.

      /* VERIFY OPEN GL PERIOD FOR LINE ITEM SITE/ENTITY, */
      /* NOT PRIMARY ENTITY, AGAINST THE "IC" MODULE      */
      run assign-shipdb
         (input abs_shipto).

      if ship_db <> global_db then do:
         /* You must be in domain */
         {us/bbi/pxmsg.i &MSGNUM=6188 &ERRORLEVEL=3 &MSGARG1=ship_db}
         undo, retry.
      end.

      if global_db <> ship_db then do:
         {us/gp/gprunp.i "mgdompl" "p" "ppDomainConnect"
                   "(input  ship_db,
                     output lv_error_num,
                     output lv_name)"}

         /* Make sure ship-from domain is connected */
         if lv_error_num > 0 then do:
            /* Domain # is not available */
            {us/bbi/pxmsg.i &MSGNUM=lv_error_num &ERRORLEVEL=3 &MSGARG1=lv_name}
            undo, retry.
         end.
      end. /* if global_db <> ship_db then do: */

      /* Pop-up to collect shipment information */
      if shc_ship_rcpt then do:
         if c-application-mode = "API" then do:
            if not lLegacyAPI then do:
               run setCommonDataBuffer in ApiMethodHandle
                  (input "ttShipmentInfo").
            end.
            else do:
               {us/gp/gpttcp.i
                  ttPurchaseOrderShipperTrans
                  ttInventoryTrans
                  " "
                  true}

               run setInventoryTrans in apiMethodHandle
                  (input table ttInventoryTrans).
               run setInventoryTransRow in apiMethodHandle
                  (input ?).
            end.
         end.

         {us/bbi/gprun.i ""icshup.p""
                  "(input-output shipnbr,
                    input-output ship_date,
                    input-output inv_mov,
                    input 'RCT-PO',
                    input no,
                    input 10,
                    input 20)"}

         if c-application-mode = "API" and not lLegacyAPI then
            run setCommonDataBuffer in ApiMethodHandle(input "").
      end. /* if shc_ship_rcpt */

      run check_supperf
         (input abs_recid).

      for each work_abs_mstr exclusive-lock:
         delete work_abs_mstr.
      end.

      /* EXPLODE SHIPPER TO GET ORDER DETAIL */
      {us/bbi/gprun.i ""rcsoisa.p"" "(input recid(abs_mstr))"}

      l_po_nbrs = "".

      for each work_abs_mstr
         where work_abs_mstr.abs_id    begins "i"
         and   work_abs_mstr.abs_order <>     "":
         run check-locked-po
            (input work_abs_mstr.abs_order).
         if l_po_locked
         then do:
            /* ONE OR MORE LOCKED RECORDS WERE ENCOUNTERED */
            {us/bbi/pxmsg.i &MSGNUM=2800 &ERRORLEVEL=1}
            undo mainloop, retry mainloop.
         end. /* IF l_po_locked */
         if l_po_nbrs = "" then
            l_po_nbrs = work_abs_mstr.abs_order.
         else
            l_po_nbrs = l_po_nbrs + "," + work_abs_mstr.abs_order.
      end. /* FOR EACH work_abs_mstr */

      run recalc_freight
         (output l_cal).

      if not poshivmt then
         if l_cal = yes then do:
            if c-application-mode <> "API" then do:
               display
                  l_recalc_lbl
               with frame rr.

               update
                  l_recalc
               with frame  rr.
               hide frame rr.
            end. /* if c-application-mode <> "API" */
            else do:
               if not lLegacyAPI then
                  assign
                     {us/mf/mfaistvl.i l_recalc ttPOShipperReceipt.recalculate}.
            end. /* if c-application-mode = "API" */
         end.
      else
         l_recalc = no.

      /* THE PROCEDURE P_GLCALVAL, VERIFIES OPEN GL PERIOD FOR */
      /* SITE/ENTITY OF EACH LINE ITEM                         */
      run p_glcalval
         (output l_flag).

      if l_flag then do:
         if poshivmt then
            return.
         if c-application-mode <> "API" then
            next-prompt abs_mstr.abs_shipfrom with frame a.
         undo mainloop, retry mainloop.
      end.

      /* When the second ship id is processed, poc_ctrl is not available any
       * more. Therefore it needs to be found again. Otherwise Progress will
       * give an error when using its field (e.g. poc_fiscal_confirm).
       */
      for first poc_ctrl where poc_domain = global_domain
      no-lock: end.

      /* GO THRU WORKFILE FOR VALIDATION OF ORDERS AND SET CURRENT
      * PURCHASE PRICE */
      assign
         so_not_auto_count = 0
         so_auto_count     = 0
         any_subcontract   = no.

      for each work_abs_mstr no-lock,
      each pod_det exclusive-lock
         where pod_domain = global_domain
         and   pod_part = work_abs_mstr.abs_item
         and   pod_nbr  = abs_order
         and   pod_line = integer(abs_line),
      each po_mstr
         no-lock
         where po_domain = global_domain
         and   po_nbr = pod_nbr
       break by pod_nbr by pod_line
             on endkey undo mainloop, retry mainloop
             on error  undo mainloop, retry mainloop:

         if pod_status <> "" then do:
            l_cn = no.

            if c-application-mode <> "API" then do:
               /* PO # AND/OR PO LINE # CLOSED OR CANCELED. REOPEN */
               {us/bbi/pxmsg.i &MSGNUM=8848 &ERRORLEVEL=1
                  &MSGARG1=work_abs_mstr.abs_order
                  &MSGARG2=work_abs_mstr.abs_line
                  &CONFIRM=l_cn}
            end. /* if c-application-mode <> "API" */
            else
               l_cn = yes.

            if l_cn then do:
               {us/bbi/gprun.i ""rspostat.p""
                        "(input work_abs_mstr.abs_order,
                          input work_abs_mstr.abs_line)"}
            end.
            else
               undo mainloop, retry mainloop.

         end. /* IF pod_status <> "" */

         /*For Scheduled Orders, check if the system date is */
         /*within the scheduled order effective date range   */
         if pod_sched then do:
            {us/bbi/gprun.i ""rseffxr.p""
                     "(input  pod_nbr,
                       input  pod_line,
                       input  eff_date,
                       output l_line_active_yn)"}

            if l_line_active_yn = no then do:
               /*Order/line is not active*/
               {us/bbi/pxmsg.i &MSGNUM=6764 &ERRORLEVEL=4
                  &MSGARG1=pod_nbr
                  &MSGARG2=pod_line}
               undo mainloop, retry mainloop.
            end.
         end. /*if po_sched*/

         trade_sale = po_trade_sale.

         /* User Update Restriction Procedure Library */
         run mfairunh.p
            (input  "mgurpl.p",
             input  ?,
             output hUpdateRestrictedLibrary).

         /* User Update Restriction Constants */
         {us/mg/mgurpl.i "hUpdateRestrictedLibrary"}

         /* Retrieve Inventory Status Code */
         run getInventoryStatusCodeValue
            in hUpdateRestrictedLibrary
            (input  pod_site,
             input  pod_loc,
             input  pod_part,
             input  pod_serial,
             input  work_abs_mstr.abs_ref,
             output cInventoryStatus).

         /* VALIDATE IF THE USER UPDATE IS RESTRICTED */
         /* CLEAR TEMP TABLE RECORDS BEFORE CREATING NEW RECORD */
         empty temp-table ttUpdateRestrictionSignature.

         /* CREATE TEMP-TABLE RECORD */
         create ttUpdateRestrictionSignature.
         assign
            ttUpdateRestrictionSignature.category              = {&PORCT}
            ttUpdateRestrictionSignature.program               = execname
            ttUpdateRestrictionSignature.part                  = pod_part
            ttUpdateRestrictionSignature.site                  = pod_site
            ttUpdateRestrictionSignature.siteTo                = ?
            ttUpdateRestrictionSignature.location              = pod_loc
            ttUpdateRestrictionSignature.locationTo            = ?
            ttUpdateRestrictionSignature.inventoryStatus      = cInventoryStatus
            ttUpdateRestrictionSignature.inventoryStatusTo     = ?
            ttUpdateRestrictionSignature.account               = ?
            ttUpdateRestrictionSignature.subaccount            = ?
            ttUpdateRestrictionSignature.costCenter            = ?
            ttUpdateRestrictionSignature.project               = ?
            ttUpdateRestrictionSignature.changeInventoryStatus = ?.
         if recid(ttUpdateRestrictionSignature) = -1 then .

         if isUpdateRestricted
            (input table ttUpdateRestrictionSignature,
             input true)
         then
            undo mainloop, retry mainloop.

         delete PROCEDURE hUpdateRestrictedLibrary.

         if pod_type = "S" then
            any_subcontract = yes.

         {us/bbi/gprun.i ""poporca5.p""
                  "(input pod_nbr,
                    input pod_line,
                    input eff_date)"}

         if first-of(pod_nbr) then do:

            for each pod2 where pod2.pod_domain = global_domain
               and pod2.pod_nbr    = pod_det.pod_nbr
               and pod2.pod_qty_chg <> 0
            no-lock:
               find pod3 where recid(pod3) = recid(pod2) exclusive-lock.
               assign
                  pod3.pod_qty_chg = 0.
            end.

            if po_fix_rate = no then do:
               /* GET EXCHANGE RATE */
               {us/gp/gprunp.i "xxmcpl" "p" "mc-get-ex-rate"
                         "(input  po_curr,
                           input  base_curr,
                           input  exch_ratetype,
                           input  eff_date,
                           output exch_rate,
                           output exch_rate2,
                           output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {us/bbi/pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                  undo mainloop, retry mainloop.
               end.
            end.
            else
               assign
                  exch_rate = po_ex_rate
                  exch_rate2 = po_ex_rate2.

         end. /* if first-of(pod_nbr) */

         /* TOLERANCE CHECKING */
         assign
            qty_to_rcv = abs_qty - abs_ship_qty.

         accumulate qty_to_rcv(sub-total by pod_line).

         if last-of(pod_line) then do:
            assign
               total_received = ((accum sub-total by pod_line qty_to_rcv)
                              / pod_um_conv) + pod_qty_rcvd
               base_amt = pod_pur_cost.

            if po_curr <> base_curr then do:
               {us/gp/gprunp.i "xxmcpl" "p" "mc-curr-conv"
                         "(input  po_curr,
                           input  base_curr,
                           input  exch_rate,
                           input  exch_rate2,
                           input  base_amt,
                           input  false, /* DO NOT ROUND */
                           output base_amt,
                           output mc-error-number)"}
            end.

            if pod_sched or
               (not pod_sched and
               (total_received > pod_qty_ord and pod_qty_ord >= 0) or
               (total_received < pod_qty_ord and pod_qty_ord < 0))
            then do:
               {us/bbi/gprun.i ""rsporct.p""
                        "(input  (accum sub-total by pod_line qty_to_rcv),
                          input  recid(po_mstr),
                          input  recid(pod_det),
                          input  eff_date,
                          input  poc_tol_pct,
                          input  poc_tol_cst,
                          input  base_amt,
                          input  no,
                          input  yes,
                          output undo_loop1)"}

               if undo_loop1 then
                  undo mainloop, retry mainloop.
            end.

            /* WARN THE USER IF NO ACTIVE SCHEDULE EXISTS */
            run p-chk-act-schd
               (buffer pod_det).

            {us/bbi/gprun.i ""rsplqty.p""
                     "(input  recid(pod_det),
                       input  ((accum sub-total by pod_line qty_to_rcv)
                              / pod_um_conv),
                       output price_qty)"}

            {us/bbi/gprun.i ""gpsct05.p""
                     "(input  pod_part,
                       input  pod_site,
                       input  2,
                       output glxcst,
                       output curcst)"}
            assign
               glxcst   = glxcst * pod_um_conv
               newprice = 0.

            if po_curr <> base_curr then do:
               {us/gp/gprunp.i "xxmcpl" "p" "mc-curr-conv"
                         "(input  base_curr,
                           input  po_curr,
                           input  exch_rate2,
                           input  exch_rate,
                           input  glxcst,
                           input  true,
                           output glxcst,
                           output mc-error-number)"}

               if mc-error-number <> 0 then do:
                  {us/bbi/pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.
            end. /* IF po_curr <> base_curr */

            if use-log-acctg
               and po_tot_terms_code <> ""
            then
               glxcst = pod_pur_cost.

            assign
               l_list_price = glxcst
               dummy_disc   = 0.

            /* UPDATING PURCHASE COST ONLY FOR SCHEDULE ORDERS */
            /* WHEN FIXED PRICE IS SET TO NO*/
            if pod_sched
               and not pod_fix_pr
            then do:
               {us/bbi/gprun.i ""gppccal.p""
                        "(input        pod_part,
                          input        price_qty,
                          input        pod_um,
                          input        pod_um_conv,
                          input        po_curr,
                          input        {&SUPPLIER-CLASSIFICATION},
                          input        pod_pr_list,
                          input        eff_date,
                          input        glxcst,
                          input        no,
                          input        0.0,
                          input-output l_list_price,
                          output       dummy_disc,
                          input-output newprice,
                          output       pc_recno)"}

               /* IF NO LIST PRICE WAS FOUND LETS TRY TO CHECK FOR   */
               /* A VP_Q_PRICE FOR THE ITEM.  IF WE CANT FIND ONE,   */
               /* POD_PRICE WILL REMAIN AS IT WAS ORIGINALLY.        */
               if pc_recno = 0
                  or newprice = 0
               then do:
                  /* CHECKING FOR BLANK SUPPLIER BUT, WITH NO SPECIFIC */
                  /* SUPPLIER FOR AN INVENTORY ITEM                    */
                  for first vp_mstr where vp_mstr.vp_domain = global_domain
                     and  vp_part      = pod_part
                     and (vp_vend      = po_vend
                      or (vp_vend = ""
                     and not can-find(first vp_mstr
                                      where vp_domain = global_domain
                                        and vp_part = pod_part
                                        and vp_vend = po_vend)))
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
         end. /* last-of pod_line */

         /* FOR A NEGATIVE RECEIPT AGAINST A CONSIGNED LINE      */
         /* CHECK WHETHER A POSITIVE RECEIPT EXISTS FOR THE LINE */

         if work_abs_mstr.abs_qty < 0
            and pod_consignment
         then do:
            for each cnsix_mstr where cnsix_domain   = global_domain
               and cnsix_part     = pod_part
               and cnsix_site     = pod_site
               and cnsix_po_nbr   = work_abs_mstr.abs_order
               and cnsix_pod_line = integer(work_abs_mstr.abs_line)
               and cnsix_lotser   = work_abs_mstr.abs_lotser
               and cnsix_ref      = work_abs_mstr.abs_ref
            no-lock:
               accumulate cnsix_qty_consigned (total).
           end.

            if (accum total cnsix_qty_consigned) < absolute(lotserial_qty)
            then do:
               /* NO CONSIGNED INVENTORY CAN BE RETURNED FOR PO LINE */
               {us/bbi/pxmsg.i &MSGNUM=6303 &ERRORLEVEL=3
                  &MSGARG1=work_abs_mstr.abs_order
                  &MSGARG2=work_abs_mstr.abs_line}

               undo mainloop, retry mainloop.
            end.
         end. /* IF work_abs_mstr.abs_qty < 0 */

      end. /* for each work_abs_mstr */


      if any_subcontract then do:
         for each work_abs_mstr exclusive-lock
            where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty,
         each abs_mstr exclusive-lock
            where abs_mstr.abs_domain   = global_domain
            and   abs_mstr.abs_shipfrom = work_abs_mstr.abs_shipfrom
            and   abs_mstr.abs_id       = work_abs_mstr.abs_id,
         each po_mstr no-lock
            where po_domain = global_domain
            and   po_nbr = abs_order,
         each pod_det exclusive-lock
            where pod_domain = global_domain
            and   pod_nbr    = abs_order
            and   pod_line   = integer(abs_line)
            and   pod_type   = "S"
         break by pod_nbr by pod_line:

            work_qty = (abs_mstr.abs_qty - abs_mstr.abs_ship_qty)
                       / (if abs_mstr.abs__qad02 = pod_um
                          then
                             decimal(abs_mstr.abs__qad03)
                          else
                             pod_um_conv).

            accumulate work_qty(sub-total by pod_line).

            if last-of(pod_line) then
               assign
                  pod_qty_chg = accum sub-total by pod_line work_qty
                  pod_bo_chg  = pod_qty_ord - pod_qty_rcvd - pod_qty_chg.

         end.

         for each work_abs_mstr exclusive-lock
            where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty,
         each abs_mstr
            exclusive-lock
            where abs_mstr.abs_domain   = global_domain
            and   abs_mstr.abs_shipfrom = work_abs_mstr.abs_shipfrom
            and   abs_mstr.abs_id       = work_abs_mstr.abs_id,
         each po_mstr
            no-lock
            where po_domain = global_domain
            and   po_nbr    = abs_order,
         each pod_det exclusive-lock
               where pod_domain = global_domain
               and   pod_nbr = abs_order
               and   pod_line = integer(abs_line)
               and   pod_type = "S"
         break by pod_wo_lot by pod_op:

            if last-of(pod_op) then do:
               {us/bbi/gprun.i ""poporca6.p""
                        "(input ""receipt"",
                          input pod_nbr,
                          input pod_wo_lot,
                          input pod_op,
                          input ?)"}

               if c-application-mode = "API" and not lLegacyAPI then do:
                  run setCommonDataBuffer in ApiMethodHandle
                     (input "ttWIPLotTraceIssue").
               end.

               {us/bbi/gprun.i ""porwiplt.p""
                        "(input  recid(pod_det),
                          input  pod_wo_lot,
                          input  pod_op,
                          input  move,
                          input-output table tt_po_lineqty,
                          output undo_all)"}

               if c-application-mode = "API" and not lLegacyAPI then do:
                  run setCommonDataBuffer in ApiMethodHandle
                     (input "").
               end.

               if undo_all
               then
                  undo mainloop, retry mainloop.
            end.

            for first wo_mstr where wo_domain = global_domain
               and wo_lot    = pod_wo_lot
            no-lock: end.

            if available wo_mstr
               and wo_status = "C"
            then do:
               /* WORK ORDER ID IS CLOSED, PLANNED OR FIRM PLANNED */
               {us/bbi/pxmsg.i &MSGNUM=523 &ERRORLEVEL=2}

               /* WORK ORDER ID #, SCHEDULE ORDER # */
               {us/bbi/pxmsg.i &MSGNUM=3069 &ERRORLEVEL=1
                  &MSGARG1=pod_wo_lot
                  &MSGARG2=pod_nbr}
            end.

         end.   /* for each work_abs_mstr */
         empty temp-table tt_po_lineqty.
      end.   /* if any_subcontract */

      /* Record legal document number if fiscal receiving is requiried */
      if poc_fiscal_confirm then do:
         /* 4th paramter indicates Shipper, 5th parameter indicates  */
         /* a PO, 6th paramter indicates a DO.                       */
         run fillLDInfoForOrder(abs_mstr.abs_shipfrom,
                                abs_mstr.abs_shipto,
                                l_po_nbrs,
                                yes,
                                yes,
                                no,
                                yes).
         if return-value = {&APP-ERROR-RESULT}
         then do:
            hide frame rec-lgd.
            undo mainloop, retry mainloop.
         end.
      end. /* if poc_fiscal_confirm */

      yn = yes.
      /* Please confirm update */
      if not poshivmt then do:
         {us/bbi/pxmsg.i &MSGNUM=32 &ERRORLEVEL=1 &CONFIRM=yn}
      end.

      if not yn
         or keyfunction(lastkey) = "end-error"
      then
         undo mainloop, retry mainloop.

      if yn <> yes then
         undo mainloop, retry mainloop.

      if abs_inv_mov = ""
         and not any_subcontract
         /* Do not generate legal document when Fiscal Confirming is required. */
         and not poc_fiscal_confirm
      then do:

         /* Global Shipping */
         /* Get Inventory Movement Code and Form Code */
         {us/bbi/gprun.i ""gpimfcmt.p"" "
            (input  abs_shipfrom,
             input  """",
             input  abs_shipto,
             input  """",
             input  'RCT-PO',
             output abs_inv_mov,
             output c_form_code,
             output c_ld_form_code,
             output l_undo)"}

         if l_undo then undo, retry.

         {us/bbi/gprun.i ""gpgetgrp.p""
                  "(input  abs_shipfrom,
                    input  abs_shipto,
                    output c_shpgrp)"}

         for first sgid_det where sgid_domain = global_domain
            and sgid_grp     = c_shpgrp
            and sgid_inv_mov = abs_inv_mov
         no-lock:
            /* Get max lines for shipper with legal doc */
            {us/gp/gprunp.i "soldxr" "p" "getMaxLines"
                      "(input sgid_format,
                        input abs_inv_mov,
                        output ld_max_lines)"}

            if ld_max_lines > 0 then do:
               /* Max lines validation */
               {us/gp/gprunp.i "soldxr" "p" "getActualLines"
                         "(input recid(abs_mstr),
                           output actual_lines)"}
               if actual_lines > ld_max_lines then do:
                  /* Max line limit has been reached */
                  {us/bbi/pxmsg.i &MSGNUM=10654 &ERRORLEVEL=3}
                  undo mainloop, retry mainloop.
               end.
            end.
         end. /* for first sgid_det */
      end. /* if abs_inv_mov = "" */

      hide frame a.
      hide frame bb.

      {us/mf/mfnxtsq.i  "wo_mstr.wo_domain = global_domain and " wo_mstr wo_lot
                   woc_sq01 trlot}

      {us/px/pxrun.i &PROC       = 'getReceiverPolicy'
               &PROGRAM    = 'porcxr.p'
               &HANDLE     =  ph_porcxr
               &PARAM      = "(output l_rcv_type,
                               output poc_seq_rcv)"
               &CATCHERROR = true
               &NOAPPERROR = true}

      for first poc_ctrl
         where poc_domain = global_domain
      no-lock:
      end. /* FOR FIRST poc_ctrl */

      /* NOW GENERATE THE RECEIVER NUMBER FOR RECEIVER TYPE NOT EQUAL TO 2 WHEN */
      /* SEQUENTIAL RECEIVER NOT REQUIRED AND IT IS PASSD TO DOTRANS1-BLOCK     */

      if (poc_rcv_type <> 2
         and not poc_seq_rcv)
      then do:
         for each work_abs_mstr
            where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty
         no-lock,
            each abs_mstr
               where abs_mstr.abs_domain   = global_domain
               and   abs_mstr.abs_shipfrom = work_abs_mstr.abs_shipfrom
               and   abs_mstr.abs_id       = work_abs_mstr.abs_id
            no-lock,
               each po_mstr
                  where  po_mstr.po_domain = global_domain
                  and    po_nbr            = abs_mstr.abs_order
               no-lock
         break by po_nbr:
            if last-of(po_nbr)
            then do:
               {us/mf/mfnctrlc.i "poc_ctrl.poc_domain = global_domain"
                           "poc_ctrl.poc_domain"
                           "prh_hist.prh_domain = global_domain"
                            poc_ctrl poc_rcv_pre poc_rcv_nbr prh_hist
                            prh_receiver receivernbr}
               for first tt_receiver where tt_ponbr = po_nbr
               no-lock: end.

               if not available tt_receiver
               then do:
                  create tt_receiver.
                  assign
                     tt_ponbr  = po_nbr
                     tt_recnbr = receivernbr.
               end.
            end. /* IF LAST-OF(po_nbr) */
         end. /* FOR EACH work_abs_mstr */
      end. /* IF (poc_rcv_type <> 2 and ... */
   end. /* DO TRANSACTION */

   /* A TRANSACTION WAS ADDED AROUND THIS PROCEDURE SO THAT THE ENTIRE        */
   /* PROCEDURE COULD HAVE UNDO APPLIED WHEN AN ERROR OCCURRED.               */
   dotrans1-block:
   do transaction on error undo dotrans1-block, leave dotrans1-block:

      /* GO THRU WORKFILE AND PERFORM CONTAINER ITEM RECEIPTS */
      for each work_abs_mstr no-lock
         where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty,
      each abs_mstr exclusive-lock
         where abs_mstr.abs_domain   = global_domain
         and   abs_mstr.abs_shipfrom = work_abs_mstr.abs_shipfrom
         and   abs_mstr.abs_id       = work_abs_mstr.abs_id:

         run del_sr_wkfl.

         find pod_det where pod_domain = global_domain
            and pod_nbr    = abs_order
            and pod_line = integer(abs_line)
         exclusive-lock no-error.

         if not available pod_det
            and abs_item > ""
         then do:

            for first pt_mstr where pt_domain = global_domain
               and pt_part = abs_item
            no-lock: end.

            if available pt_mstr then do:

               for first in_mstr where in_domain = global_domain
                  and in_site   = pt_site
                  and in_part   = pt_part
               no-lock: end.

               for first pl_mstr where pl_domain    = global_domain
                  and pl_prod_line = pt_prod_line
               no-lock: end.

               {us/bbi/gprun.i ""glactdft.p""
                        "(input  ""PO_PUR_ACCT"",
                          input  pt_prod_line,
                          input  in_site,
                          input  if available vd_mstr then vd_type else """",
                          input  """",
                          input  no,
                          output cr_acct,
                          output cr_sub,
                          output cr_cc)"}

               {us/bbi/gprun.i ""glactdft.p""
                        "(input  ""WO_COP_ACCT"",
                          input  pt_prod_line,
                          input  in_site,
                          input  """",
                          input  """",
                          input  no,
                          output dftCOPAcct,
                          output dftCOPSubAcct,
                          output dftCOPCostCenter)"}

               {us/bbi/gprun.i ""glactdft.p""
                        "(input  ""WO_FLR_ACCT"",
                          input  pt_prod_line,
                          input  in_site,
                          input  """",
                          input  """",
                          input  no,
                          output dftFLRAcct,
                          output dftFLRSubAcct,
                          output dftFLRCostCenter)"}

               {us/gp/gpsct03.i &cost=sct_cst_tot}

               create sr_wkfl.
               assign
                  sr_domain   = global_domain
                  global_part = abs_item
                  part        = abs_item
                  sr_userid   = SessionUniqueID
                  sr_lineid   = abs_mstr.abs_line
                  sr_site     = abs_mstr.abs_site
                  sr_loc      = abs_mstr.abs_loc
                  sr_lotser   = abs_mstr.abs_lotser
                  sr_ref      = abs_mstr.abs_ref
                  sr_qty      = abs_mstr.abs_qty - abs_mstr.abs_ship_qty
                  unit_cost   = glxcst
                  so_job      = ""
                  traddr      = abs_mstr.abs_shipto
                  project     = ""
                  dr_acct     = if not pt_iss_pol then dftFLRAcct else dftCOPAcct
                  dr_sub      = if not pt_iss_pol then dftFLRSubAcct
                                else dftCOPSubAcct
                  dr_cc       = if not pt_iss_pol then dftFLRCostCenter
                                else dftCOPCostCenter
                  transtype   = "RCT-UNP"
                  issrct      = "RCT"
                  conv        = 1.

               rmks = getTermLabel("CONTAINER_RECEIPT",17).

               if recid(sr_wkfl) = -1 then .

               /* FOURTH PARAMETER IS KANBAN ID */
               /* NOT USED HERE SO PASS AS 0    */
               {us/bbi/gprun.i ""icintra.p""
                        "(input shipnbr,
                          input ship_date,
                          input '',
                          input 0,
                          input false)"}

               if available sr_wkfl then delete sr_wkfl.

            end. /* if available pt_mstr */

            assign
               abs_mstr.abs_ship_qty = abs_mstr.abs_qty.

         end. /* if not available pod_det and abs_item... */

      end.  /* FOR EACH */

      run dotrans1
         (input  send_ts_asn,
          input  trade_sale,
          output undo-loop).

      if undo-loop then
         undo dotrans1-block, leave dotrans1-block.

      if abs_recid <> ? then
         run MarkShipperConfirmed
            (input abs_recid,
             input send_ts_asn,
             input trade_sale).

      /* COPY AS BUFFER CONTAINER/ITEM INFORMATION TO SO CONTAINER */
      assign
         l_conv_cnt_prompt = no
         l_conv_cnt        = no.

      if can-find(first mfc_ctrl where mfc_field  = "l_conv_cnt"
         and mfc_domain = global_domain
         and mfc_logical)
      then do:

         for each work_abs_mstr
            where work_abs_mstr.abs_order <> ""
         no-lock:

            /* CHECK IF PO IS EMT PO, IF YES THE CHECK WHETHER IS OF */
            /* EMT TYPE 'DIR-SHIP' OR 'TRANSHIP'                     */
            if can-find(first po_mstr where po_domain = global_domain
               and po_nbr    = work_abs_mstr.abs_order
               and po_is_btb = yes)
            then do:

               for first pod_det where pod_domain = global_domain
                  and pod_nbr    = work_abs_mstr.abs_order
                  and pod_line   = integer(work_abs_mstr.abs_line)
               no-lock:

                  /* IF EMT TYPE IS TRANSHIP THEN MAKE FLAG YES */
                  if can-find(first sod_det where sod_domain = global_domain
                     and sod_btb_po   = work_abs_mstr.abs_order
                     and sod_part     = work_abs_mstr.abs_item
                     and sod_btb_type = "02"
                     and sod_line     = pod_sod_line
                     and sod_compl_stat = "")
                  then
                     l_conv_cnt_prompt = yes.
               end.
            end. /* IF CAN-FIND(FIRST po_mstr */
            else
               l_conv_cnt_prompt = yes.

            /* FLAG SET TO YES MEANS PROMPT NEEDS TO BE DISPLAYED   */
            /* NO NEED FOR CHECKING REMAINING work_abs_mstr RECORDS */
            if l_conv_cnt_prompt then
               leave.

         end. /* FOR EACH work_abs_mstr */

         if l_conv_cnt_prompt then do:
            l_conv_cnt        = yes.
            /* CONVERT CONTAINER/ITEMS TO SALES CONTAINER/ITEMS */
            {us/bbi/pxmsg.i &MSGNUM=6573 &ERRORLEVEL=1 &CONFIRM=l_conv_cnt}
         end.

         if l_conv_cnt
            and keyfunction(lastkey) <> "end-error"
         then do:

            convert_loop:
            for each work_abs_mstr
               where work_abs_mstr.abs_id  begins "c"
               or   (work_abs_mstr.abs_id  begins "i"
               and   work_abs_mstr.abs_par_id begins "c")
            no-lock
            by work_abs_mstr.abs_id:

               /* FOR CONTAINER RECORDS */
               if work_abs_mstr.abs_id begins "c" then do:
                  l_abs_par_id = work_abs_mstr.abs_id.

                  do while true:
                     /* FIND AN ITEM IN THE CONTAINER */
                     find first b_abs_mstr
                        where b_abs_mstr.abs_par_id = l_abs_par_id
                        and   b_abs_mstr.abs_domain = global_domain
                        and   b_abs_mstr.abs_shipfrom = work_abs_mstr.abs_shipfrom
                     no-lock no-error.

                     if available b_abs_mstr
                        and not(b_abs_mstr.abs_id begins "i")
                     then
                        l_abs_par_id = b_abs_mstr.abs_id.

                     /* LEAVE IF ITEM RECORD FOUND */
                     if (available b_abs_mstr
                        and b_abs_mstr.abs_id begins "i")
                        or not available b_abs_mstr
                     then
                        leave.

                  end. /* DO WHILE TRUE */

                  /* IF ITEM/CONTAINER IS DIR-SHIP THEN NEXT */
                  if can-find(first po_mstr
                     where po_nbr    = b_abs_mstr.abs_order
                     and   po_domain = global_domain
                     and   po_is_btb = yes)
                  then do:



                     for first pod_det
                        where pod_nbr    = b_abs_mstr.abs_order
                        and   pod_domain = global_domain
                        and   pod_line   = integer(b_abs_mstr.abs_line)
                     no-lock:

                        if can-find(first sod_det
                           where sod_btb_po   = b_abs_mstr.abs_order
                           and   sod_part     = b_abs_mstr.abs_item
                           and   sod_btb_type = "03"
                           and   sod_domain   = global_domain
                           and   sod_line     = pod_sod_line
                           and   sod_compl_stat = "")
                        then
                           next convert_loop.

                     end.
                  end. /* IF CAN-FIND(FIRST po_mstr */
               end. /* IF work_abs_mstr.abs_id BEGINS "c" */

               /* FOR ITEM RECORDS */
               else if can-find(first po_mstr
                  where po_nbr    = work_abs_mstr.abs_order
                  and   po_domain = global_domain
                  and   po_is_btb = yes)
               then do:

                  for first pod_det
                     where pod_nbr    = work_abs_mstr.abs_order
                     and   pod_domain = global_domain
                     and   pod_line   = integer(work_abs_mstr.abs_line)
                  no-lock:

                     /* IF EMT TYPE IS DIR-SHIP THEN SKIP RECORD */
                     if can-find(first sod_det
                        where sod_btb_po   = work_abs_mstr.abs_order
                        and   sod_part     = work_abs_mstr.abs_item
                        and   sod_btb_type = "03"
                        and   sod_domain   = global_domain
                        and   sod_line     = pod_sod_line
                        and   sod_compl_stat = "")
                     then
                        next convert_loop.

                  end.

               end. /* IF CAN-FIND(FIRST po_mstr */

               buffer-copy work_abs_mstr to tt_abs_mstr.

               assign
                  /* SHIP TO IS ASSIGNED BLANK VALUE, SO THAT WHEN */
                  /* SHIPPER WORKBENCH IS CREATED FOR DIFFERENT SHIP-TO */
                  /* THIS CONTAINER CAN BE USED */
                  tt_abs_mstr.abs_shipto   = ""
                  tt_abs_mstr.abs_shipfrom = work_abs_mstr.abs_site
                  tt_abs_mstr.abs_type     = "s"
                  tt_abs_mstr.abs_order    = ""
                  tt_abs_mstr.abs_line     = ""
                  tt_abs_mstr.abs_shp_date = ?
                  tt_abs_mstr.abs_ship_qty = 0
                  tt_abs_mstr.abs_domain   = global_domain.

               /* WEIGHT ASSIGNMENT PROCESS */
               if work_abs_mstr.abs_id begins "i" then do:

                  for first pt_mstr
                     where pt_part   = work_abs_mstr.abs_item
                     and   pt_domain = global_domain
                  no-lock:

                     assign
                        tt_abs_mstr.abs_gwt     = work_abs_mstr.abs_qty
                                                * pt_ship_wt
                        tt_abs_mstr.abs_nwt     = work_abs_mstr.abs_qty * pt_net_wt
                        tt_abs_mstr.abs_vol     = work_abs_mstr.abs_qty * pt_size
                        tt_abs_mstr.abs_wt_um   = pt_ship_wt_um
                        tt_abs_mstr.abs_vol_um  = pt_size_um
                        substring(tt_abs_mstr.abs__qad10,26,22) =
                           string(tt_abs_mstr.abs_gwt - tt_abs_mstr.abs_nwt)
                        tt_abs_mstr.abs_qty    = work_abs_mstr.abs_qty
                                               / decimal(work_abs_mstr.abs__qad03).



                  end.

                  /* ROLL CHILD INTO PARENT */
                  run update_container
                     (input tt_abs_mstr.abs_shipfrom,
                      input tt_abs_mstr.abs_par_id,
                      input tt_abs_mstr.abs_nwt,
                      input tt_abs_mstr.abs_gwt).



               end. /* IF work_abs_mstr.abs_id BEGINS "i" */



               if work_abs_mstr.abs_id begins "c" then do:

                  for first pt_mstr
                     where pt_part   = work_abs_mstr.abs_item
                     and   pt_domain = global_domain
                  no-lock:

                     assign
                        substring(tt_abs_mstr.abs__qad10,26,22) =
                           string(pt_ship_wt)
                        tt_abs_mstr.abs_gwt     = tt_abs_mstr.abs_gwt
                                                + (work_abs_mstr.abs_qty
                                                * pt_ship_wt)
                        tt_abs_mstr.abs_wt_um   = pt_ship_wt_um
                        tt_abs_mstr.abs_vol_um  = pt_size_um
                        tt_abs_mstr.abs__qad02  = pt_um.

                  end.

                  /* ROLL CHILD INTO PARENT*/
                  run update_container
                     (input tt_abs_mstr.abs_shipfrom,
                      input tt_abs_mstr.abs_par_id,
                      input tt_abs_mstr.abs_nwt,
                      input tt_abs_mstr.abs_gwt).



               end. /* IF work_abs_mstr.abs_id BEGINS "c" */

               /*CONTAINER WITHIN CONTAINER */
               if work_abs_mstr.abs_id begins "c" then
                  tt_abs_mstr.abs_par_id = "".

               /*ITEM WITHIN CONTAINER*/
               if work_abs_mstr.abs_id begins "i" then
                  tt_abs_mstr.abs_par_id = work_abs_mstr.abs_par_id.

               /* CHECK FOR EXISTING CONTAINER AND IF NOT AVAILABLE CREATE */
               find first abs_mstr
                  where abs_mstr.abs_shipfrom = tt_abs_mstr.abs_shipfrom
                  and   abs_mstr.abs_id       = tt_abs_mstr.abs_id
                  and   abs_mstr.abs_domain   = global_domain
               no-lock no-error.

               if available abs_mstr then do:

                  /* CONTAINER ALREADY EXISTS */
                  {us/bbi/pxmsg.i &MSGNUM=8293 &ERRORLEVEL=4}

                  delete tt_abs_mstr.
                  next convert_loop.

               end.

               if not available abs_mstr then do:

                  create abs_mstr.
                  buffer-copy tt_abs_mstr except oid_abs_mstr to abs_mstr.
                  delete tt_abs_mstr.

               end.
            end. /* FOR EACH work_abs_mstr */
         end. /* IF l_conv_cnt */
      end. /* IF CAN-FIND(FIRST mfc_ctrl */



      global_recid = abs_recid.

      if any_subcontract then do:
         for first abs_mstr where recid(abs_mstr) = global_recid
         exclusive-lock:
            /* Get Inventory Movement Code and Form Code */
            {us/bbi/gprun.i ""gpimfcmt.p"" "
                      (input  abs_mstr.abs_shipfrom,
                       input  """",
                       input  abs_mstr.abs_shipto,
                       input  """",
                       input  'RCT-PO',
                       output abs_mstr.abs_inv_mov,
                       output c_form_code,
                       output c_ld_form_code,
                       output l_undo)"}

            if l_undo then undo, retry.
         end.
      end.

      v_imflow = 0.

      if available abs_mstr then do:
         /* get transaction flow and transaction type by IMC */
         find first im_mstr where im_domain  = global_domain
                              and im_inv_mov = abs_inv_mov no-lock no-error.
         if available im_mstr then
            assign
               v_imflow  = im_flow.
      end.

      /* NO GENERATION OF LEGAL DOCUMENT */
      if v_imflow <> 0 and
         not poc_fiscal_confirm
      then do:
         /* Global Shipping */
         {us/bbi/gprun.i ""icshldmt.p""
                  "(input abs_recid,
                    input no,
                    output i_err_num)"}



         if i_err_num = 0 then do:
            /* Complement Salejob and remarks for legal document */
            {us/bbi/gprun.i ""icshldm1.p""
               "(input abs_recid,
                 input so_job,
                 input rmks)"}

            run assignPackingSlip(input abs_recid).

            find abs_mstr where recid(abs_mstr) = abs_recid no-lock no-error.
            if available abs_mstr then do:
               /* COLLECT INFO FOR THE LEGAL DOCUMENT */
               for first lgd_mstr where lgd_domain = global_domain
                  and lgd_shipper_id = abs_id
                  and lgd_type = yes no-lock:
                  {us/gp/gprunp.i "soldxr" "p" "saveLegalSiteLoc"
                     "(input abs_id,
                       input abs_shipfrom,
                       input """",
                       input abs_shipto,
                       input lgd_loc)"}
               end.
            end.

            /* Print Legal Document */
            if c-application-mode <> "API" and not lLegacyAPI then
              {us/bbi/gprun.i ""icldprt.p"" "(input abs_recid)"}
         end.
      end.

      run del_sr_wkfl.
      run deleteQadWkfl.

      /* Do Fiscal Confirm */
      run clearEmptyLD(input lgdkey, yes).

      {us/gp/gprunp.i "soldxr" "p" "updateLegalNumToUnpostedGL"}
   end. /* dotrans1-block*/

   if undo-loop
   then
      undo mainloop, retry mainloop.

   if c-application-mode <> "API" then do:
      hide message no-pause.
      hide frame bb.
   end. /* if c-application-mode <> "API" */
   if c-application-mode = "API" then leave.
   if poshivmt then leave.
end.

if is_wiplottrace_enabled() then
   delete PROCEDURE h_wiplottrace_procs no-error.
if is_wiplottrace_enabled() then
   delete PROCEDURE h_wiplottrace_funcs no-error.

if c-application-mode = "API" then return {&SUCCESS-RESULT}.

PROCEDURE upd-kit-inv:
   if not {us/bbi/gpiswrap.i} then do:
      /* Processing... Please wait */
      {us/bbi/pxmsg.i &MSGNUM=832 &ERRORLEVEL=1}
   end.

   for each work_abs_mstr no-lock
      where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty,
   each abs_mstr
      no-lock
      where abs_mstr.abs_domain   = global_domain
      and   abs_mstr.abs_shipfrom = work_abs_mstr.abs_shipfrom
      and   abs_mstr.abs_id       = work_abs_mstr.abs_id,
   each po_mstr
      no-lock
      where po_domain = global_domain
      and   po_nbr    = abs_mstr.abs_order,
   each pod_det
      no-lock
      where pod_domain = global_domain
      and   pod_part   =  work_abs_mstr.abs_item
      and   pod_nbr    = abs_mstr.abs_order
      and   pod_line   = integer(abs_mstr.abs_line)
   break by pod_nbr by pod_line:

      for first sod_det
         where sod_domain = global_domain
         and ((sod_nbr = po_so_nbr and sod_line = pod_sod_line)
         or   (sod_nbr = po_trade_sale_so and sod_line = pod_sod_line))
         and sod_compl_stat = ""
      no-lock: end.

      if available sod_det
         and sod_cfg_type = "2"
         and sod_fa_nbr = ""
      then do:

         accumulate abs_mstr.abs_qty (total by pod_line).

         if last-of(pod_line) then do:
            assign
               confirm_mode = no
               sod_recno = recid(sod_det).

            {us/bbi/gprun.i ""rcsoisk.p""
                     "(input recid(abs_mstr),
                       input confirm_mode,
                       input (accumulate total by pod_line
                              abs_mstr.abs_qty))"}

         end.
      end. /* if available sod_det and sod_cfg_type = "2" */
   end. /* for each work_abs_mstr ... breab by pod_nbr */

END PROCEDURE.   /* upd-kit-inv */

PROCEDURE p-chk-act-schd:
   define parameter buffer p_poddet for pod_det.

   if p_poddet.pod_sched
   then do:
      for first sch_mstr
         where  sch_domain = global_domain
         and    sch_nbr    = p_poddet.pod_nbr
         and    sch_line   = p_poddet.pod_line
      no-lock:
         for first schd_det
            where schd_domain  = sch_domain
            and   schd_type    = sch_type
            and   schd_nbr     = sch_nbr
            and   schd_line    = sch_line
            and   schd_rlse_id = sch_rlse_id
         no-lock:
         end. /* FOR FIRST schd_det */
      end. /* FOR FIRST sch_mstr */
      if not available schd_det
      then do:
         if p_poddet.pod_curr_rlse_id[1] = ""
         then do:
            /* NO ACTIVE SCHEDULE EXISTS */
            {us/bbi/pxmsg.i &MSGNUM=2362 &ERRORLEVEL=2}
         end. /* IF pod_curr_rlse_id[1] */
      end. /* IF NOT AVAILABLE schd_det  */
      else do:
         if (    schd_type           = 5
             and p_poddet.pod_curr_rlse_id[2] = "" )
         or (    schd_type           = 6
             and p_poddet.pod_curr_rlse_id[3] = "" )
         or (    schd_type           <> 5
             and schd_type           <> 6
             and p_poddet.pod_curr_rlse_id[1] = "" )
         then do:
            /* NO ACTIVE SCHEDULE EXISTS */
            {us/bbi/pxmsg.i &MSGNUM=2362 &ERRORLEVEL=2}
         end.  /*IF schd_type = 5*/
      end. /* ELSE DO */
   end. /* IF pod_sched */

END PROCEDURE.   /* p-chk-act-schd: */

PROCEDURE del_sr_wkfl:
   for each sr_wkfl
      where sr_domain = global_domain
      and   sr_userid = SessionUniqueID
   exclusive-lock:
      delete sr_wkfl.
   end.

END PROCEDURE.   /* del_sr_wkfl: */

PROCEDURE assign-shipdb:
   define input parameter shipto like abs_mstr.abs_shipto.

   for first si_mstr
      where si_domain = global_domain
      and   si_site = shipto
   no-lock:
      ship_db = si_db.
   end.

END PROCEDURE.   /* assign-shipdb */

PROCEDURE p_glcalval:
   define output parameter l_flag like mfc_logical no-undo.

   for each work_abs_mstr
      where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty
      and  (work_abs_mstr.abs_id begins "i"
      or    work_abs_mstr.abs_id begins "c")
   no-lock:
      for first si_mstr
         where si_domain = global_domain
         and   si_site   = work_abs_mstr.abs_site
      no-lock: end.

      if available si_mstr then do:

         /* CHECK GL EFFECTIVE DATE */
         {us/gp/gpglef01.i ""IC"" si_entity eff_date}

         if gpglef > 0 then do:
            {us/bbi/pxmsg.i &MSGNUM=gpglef &ERRORLEVEL=4 &MSGARG1=si_entity}
            l_flag = yes.
            return.
         end. /* IF GPGLEF > 0 */
      end. /* IF AVAILABLE SI_MSTR */
   end. /* FOR EACH WORK_ABS_MSTR */

END PROCEDURE.   /* p_glcalval */

PROCEDURE check_supperf:
/*-------------------------------------------------------------------------
 * Purpose:     Determine if supplier performance in installed
 *-------------------------------------------------------------------------*/
   define input parameter abs_recid as recid no-undo.

   if can-find (mfc_ctrl
      where mfc_domain = global_domain
      and   mfc_field = "enable_supplier_perf"
      and   mfc_logical)
      and   can-find (_File where _File-name = "vef_ctrl")
   then do:
      if c-application-mode = "API" and not lLegacyAPI then do:
         run setCommonDataBuffer in ApiMethodHandle
            (input "ttSupplierPerformInfo").
      end.

      {us/bbi/gprun.i ""rspove.p""
               "(input abs_recid,
                 input auto_receipt)"}

      if c-application-mode = "API" and not lLegacyAPI then
         run setCommonDataBuffer in ApiMethodHandle (input "").
   end.

END PROCEDURE. /*  check_supperf */

PROCEDURE dotrans1:
   define input  parameter i_send_ts_asn  as   logical     no-undo.
   define input  parameter i_trade_sale   as   logical     no-undo.
   define output parameter undo-loop      as   logical     no-undo.

   define variable l_abs_vend_lot         like sr_vend_lot no-undo.
   define variable SeqNbr                 as   integer     no-undo.
   define variable op-allSuccessful       as   logical     no-undo.
   define variable msg-text               as   character   no-undo.
   define variable loc                    as   character   no-undo.
   define variable loc1                   as   character   no-undo.
   define variable serial                 as   character   no-undo.
   define variable serial1                as   character   no-undo.
   define variable ref                    as   character   no-undo.
   define variable ref1                   as   character   no-undo.

   undo-loop = no.

   do transaction:

      empty temp-table tt-poline-info no-error.

      /* LOGIC TO STOP PO SHIPPER RECEIPT OF A PO SHIPPER       */
      /* CREATED WITH INVALID LOCATIONS WHEN THE SITE DISALLOWS */
      /* AUTOMATIC LOCATIONS.                                   */
      l_undotr = no.

      for each work_abs_mstr
         where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty no-lock,
      each abs_mstr
         where abs_mstr.abs_domain   = global_domain
         and   abs_mstr.abs_shipfrom = work_abs_mstr.abs_shipfrom
         and   abs_mstr.abs_id       = work_abs_mstr.abs_id
      no-lock:

         /* INTRODUCED CALL TO icedit.p TO CHECK FOR VALID LOCATION  */
         /* VARIABLE l_undotr SET TO YES WHEN INVALID LOCATION FOUND */
         if abs_mstr.abs_id begins "i" then
            for first pod_det
               where pod_domain = global_domain
               and   pod_nbr    = abs_mstr.abs_order
               and   pod_line   = integer(abs_mstr.abs_line)
            no-lock: end.

         /* MODIFYING THE BELOW CONDITION TO AVOID */
         /* CALLING ICEDIT.P FOR A MEMO TYPE PO */
         if (abs_mstr.abs_site   <> ""
            or abs_mstr.abs_loc <> "")
            and ((abs_mstr.abs_id begins "i"
            and available pod_det
            and pod_type <> "M")
            or not (abs_mstr.abs_id begins "i"))
            and not is_wiplottrace_enabled()
         then do:

            if pod_consignment
            then do:
               run p_validateTransaction (input  "CN-RCT",
                                          input abs_mstr.abs_site,
                                          input abs_mstr.abs_loc,
                                          input abs_mstr.abs_item,
                                          input abs_mstr.abs_lotser,
                                          input abs_mstr.abs_ref,
                                          output l_undotr).
            end. /* IF pod_consignment */
            else do:
               /* ACCUMULATE TOTAL QUANTITY FOR THE SAME */
               /* ITEM/SITE/LOCATION/LOTSER/REF */
               l_total = 0.
               for each b_abs_mstr
                  where b_abs_mstr.abs_domain   =  abs_mstr.abs_domain
                    and b_abs_mstr.abs_shipfrom =  abs_mstr.abs_shipfrom
                    and b_abs_mstr.abs_par_id   =  abs_mstr.abs_par_id
                    and b_abs_mstr.abs_item     =  abs_mstr.abs_item
                    and b_abs_mstr.abs_site     =  abs_mstr.abs_site
                    and b_abs_mstr.abs_loc      =  abs_mstr.abs_loc
                    and b_abs_mstr.abs_lotser   =  abs_mstr.abs_lotser
                    and b_abs_mstr.abs_ref      =  abs_mstr.abs_ref
               no-lock :
                  l_total = l_total + b_abs_mstr.abs_qty.
               end. /* FOR EACH b_abs_mstr */

               /* VALIDATE AVAILABLE QTY FOR SITE/LOCATION/LOTSERIAL/REF.    */
               {us/bbi/gprun.i ""icedit.p""
                        "(input  ""RCT-PO"",
                          input  abs_mstr.abs_site,
                          input  abs_mstr.abs_loc,
                          input  abs_mstr.abs_item,
                          input  abs_mstr.abs_lotser,
                          input  abs_mstr.abs_ref,
                          input  l_total,
                          input  abs_mstr.abs__qad02,
                          input  """",
                          input  """",
                          output l_undotr)"}
            end. /* ELSE DO */

            if l_undotr = yes
            then do:
               /* UNABLE TO ISSUE OR RECEIVE FOR ITEM */
               {us/bbi/pxmsg.i &MSGNUM=161 &ERRORLEVEL=3
                        &MSGARG1="abs_mstr.abs_item"}

               undo-loop = yes.
               return.
            end.
         end. /* IF abs_mstr.abs_site <> "" ... */
      end. /* FOR EACH work_abs_mstr ... */

      for each work_abs_mstr no-lock
         where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty,
      each abs_mstr exclusive-lock
         where abs_mstr.abs_domain   = global_domain
         and   abs_mstr.abs_shipfrom = work_abs_mstr.abs_shipfrom
         and   abs_mstr.abs_id       = work_abs_mstr.abs_id,
      each po_mstr
         no-lock
         where po_domain = global_domain
         and   po_nbr    = abs_mstr.abs_order,
      each pod_det exclusive-lock
         where pod_domain = global_domain
         and   pod_nbr    = abs_mstr.abs_order
         and   pod_line   = integer(abs_mstr.abs_line)
         and   pod_part   = work_abs_mstr.abs_item
      break by pod_nbr by pod_line:
         if lagit
            or (use-log-acctg and git-stat)
         then do:

            for first si_mstr
               where si_domain = global_domain
               and   si_site   = pod_site
            no-lock:
               if si_git_location = "" then do:
                  {us/bbi/pxmsg.i &MSGNUM=6105 &ERRORLEVEL=3 &MSGARG1=pod_site}
                  undo-loop = yes.
                  return.
               end.
            end.
         end. /* if use-log-acctg */

         if first-of(pod_nbr) then do:
            run del_sr_wkfl.

            if work_abs_mstr.abs__qad06 <> "" then do:
               /* CLEAR ALL THE TAX WORK FILE */
               for each tax_wkfl
                  where tax_nbr = po_nbr
               exclusive-lock:
                  delete tax_wkfl.
               end.
            end.
         end.

         find sr_wkfl
            where sr_domain = global_domain
            and   sr_userid = SessionUniqueID
            and   sr_lineid = abs_mstr.abs_line
            and   sr_site = abs_mstr.abs_site
            and   sr_loc = abs_mstr.abs_loc
            and   sr_lotser = abs_mstr.abs_lotser
            and   sr_ref = abs_mstr.abs_ref
         exclusive-lock no-error.

         if not available sr_wkfl then do:

            create sr_wkfl.
            assign
               sr_domain   = global_domain
               sr_userid   = SessionUniqueID
               sr_lineid   = abs_mstr.abs_line
               sr_site     = abs_mstr.abs_site
               sr_loc      = abs_mstr.abs_loc
               sr_lotser   = abs_mstr.abs_lotser
               sr_vend_lot = abs_mstr.abs_vend_lot
               sr_ref      = abs_mstr.abs_ref.

            if recid(sr_wkfl) = -1 then .

            /* IF THE SUPPLIER HAS BEEN SETUP TO CREATE THE KANBAN        */
            /* TRANSACTIONS, THEN SAVE THE PO LINE INFORMATION THAT       */
            /* WILL BE USED FOR KANBAN TRANSACTION PROCESSING.            */
            if vd_mstr.vd_kanban_supplier then do:
               find tt-poline-info where
                  tt-poline-rowid = rowid(pod_det) no-error.

               if not available tt-poline-info then do:
                  create tt-poline-info.
                  assign
                     tt-poline-rowid   = rowid(pod_det)
                     tt-poNumber       = pod_nbr
                     tt-poLine         = pod_line
                     tt-part           = pod_part
                     tt-lotser         = sr_lotser
                     tt-loc            = sr_loc
                     tt-ref            = sr_ref.
               end.
               else
                  /*  FOR MULTI-ENTRY, YOU CANNOT MAP THE MULTI-ENTRY */
                  /* VALUES TO THE KANBAN HISTORY VALUES, SO DO NOT   */
                  /* MAINTAIN THE LOC, LOT SERIAL AND REF VALUES.     */
                  assign
                     tt-loc    = ""
                     tt-lotser = ""
                     tt-ref = "".

            end. /* if vd_kanban_supplier */
         end.

         /* STORING THE QUANTITY IN INVENTORY UM TO     */
         /* AVOID ROUNDING ERRORS IN LD_DET AND TR_HIST */
         assign
            work_qty   = (abs_mstr.abs_qty - abs_mstr.abs_ship_qty)
                         / (if abs_mstr.abs__qad02 = pod_um
                            then
                               decimal(abs_mstr.abs__qad03)
                            else
                               pod_um_conv)
            sr_qty     = sr_qty + work_qty
            l_tot_qty  = decimal(sr__qadc01)
                       + (abs_mstr.abs_qty - abs_mstr.abs_ship_qty)
            sr__qadc01 = string(l_tot_qty).

         if vd_kanban_supplier
         then
            tt-poline-info.tt-qty = tt-poline-info.tt-qty + sr_qty.

         release sr_wkfl.

         run proc-attr-wkfl
            (input pod_line,           input pod_assay,
             input pod_grade,          input pod_expire,
             input pod_rctstat,        input pod_rctstat_active,
             input pod_part,           input pod_site,
             input pod_loc,            input recid(pod_det)).

         /*SET AND UPDATE INVENTORY DETAIL ATTRIBUTES*/
         find first attr_wkfl
            where chg_line = string(pod_line)
         exclusive-lock no-error.

         if available attr_wkfl
            and pod_type = ""
         then do:

            if status_actv = no then do:

               for each sr_wkfl
                  where sr_domain   = global_domain
                  and   ((sr_userid = SessionUniqueID
                  and   l_usage     = no)
                  or    (sr_userid  = SessionUniqueID + "cons" and l_usage) )
                  and   sr_lineid   = string(pod_line)
               no-lock
               break by sr_userid:
                  for first ld_det
                     where ld_domain = global_domain
                     and   ld_site   = sr_site
                     and   ld_loc    = sr_loc
                     and   ld_part   = pod_part
                     and   ld_lot    = sr_lotser
                     and   ld_ref    = sr_ref
                  no-lock: end.

                  if available ld_det then
                     chg_status = ld_status.
                  else do:
                     for first loc_mstr
                        where loc_domain = global_domain
                        and   loc_site   = sr_site
                        and   loc_loc    = sr_loc
                     no-lock: end.

                     if available loc_mstr then
                        chg_status = loc_status.
                     else do:
                        for first si_mstr
                           where si_domain = global_domain
                           and   si_site   = sr_site
                        no-lock: end.

                        if available si_mstr then
                           chg_status = si_status.

                     end. /* ELSE DO */
                  end. /* ELSE DO */
               end. /* FOR EACH sr_wkfl */
            end. /* IF status_actv = no */

            {us/bbi/gprun.i ""porcat02.p""
                     "(input  recid(pod_det),
                       input  chg_attr,
                       input  eff_date,
                       input-output chg_assay,
                       input-output chg_grade,
                       input-output chg_expire,
                       input-output chg_status,
                       input-output assay_actv,
                       input-output grade_actv,
                       input-output expire_actv,
                       input-output status_actv)"}

            /*TEST FOR ATTRIBUTE CONFLICTS*/
            {us/px/pxrun.i &PROC='validateAttributes' &PROGRAM='porcxr1.p'
                     &PARAM="(buffer pod_det,
                              input  eff_date,
                              input  chg_assay,
                              input  chg_grade,
                              input  chg_expire,
                              input  chg_status,
                              input  assay_actv,
                              input  grade_actv,
                              input  expire_actv,
                              input  status_actv)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

            if return-value <> {&SUCCESS-RESULT} then do:
               undo-loop = yes.
               return.
            end.
         end. /* IF AVAILABLE attr_wkfl */

         accumulate work_qty(sub-total by pod_line).

         if last-of(pod_line) then do:

            assign
               pod_qty_chg = accum sub-total by pod_line work_qty
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
                  tax_taxc  = right-trim(substring(abs_mstr.abs__qad06,3,3))
                  tax_env   = right-trim(substring(abs_mstr.abs__qad06,6,16))
                  tax_usage = right-trim(substring(abs_mstr.abs__qad06,22,8)).

               if substring(work_abs_mstr.abs__qad07,9,18) <> "" then
                  tax_price = decimal(substring(work_abs_mstr.abs__qad07,9,18))
                            / decimal(work_abs_mstr.abs__qad03) * pod_um_conv.
            end.

            /* CREATE THE TEMP-TABLE FOR COLLECTING THE LINES */
            /* EDITED, TO BE USED IN RECALCULATING THE TAXES  */
            for first tt_po_tax
               where tt_po   = pod_nbr
               and   tt_line = pod_line
            no-lock: end.

            if not available tt_po_tax then do:
               create tt_po_tax.
               assign
                  tt_po     = pod_nbr
                  tt_line   = pod_line.
            end.
         end. /* if last-of(pod_line) */

         if last-of(pod_nbr) then do:
            po_recno = recid(po_mstr).

            for first poc_ctrl
               where poc_domain = global_domain
            no-lock: end.

            if (poc_rcv_type <> 2
               and not poc_seq_rcv)
            then do:
               for first tt_receiver
                  where tt_ponbr = pod_nbr
               no-lock:
                  receivernbr = tt_recnbr.
               end. /* FOR FIRST tt_receiver */
            end. /* IF (poc_rcv_type <> 2 and ... */
            else do:
               {us/mf/mfnctrlc.i "poc_ctrl.poc_domain = global_domain"
                           "poc_ctrl.poc_domain"
                           "prh_hist.prh_domain = global_domain"
                            poc_ctrl poc_rcv_pre poc_rcv_nbr prh_hist
                            prh_receiver receivernbr}
            end. /* IF (poc_rcv_type = 2 and ... */

            if (oldcurr <> po_curr) or (oldcurr = "") then do:
               /* GET ROUNDING METHOD FROM CURRENCY MASTER */
               {us/gp/gprunp.i "xxmcpl" "p" "mc-get-rnd-mthd"
                         "(input  po_curr,
                           output rndmthd,
                           output mc-error-number)"}

               if mc-error-number <> 0 then do:
                  {us/bbi/pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                  if c-application-mode <> "WEB" then
                     pause 0.
                  undo-loop = yes.
                  return.
               end.

               oldcurr = po_curr.
            end.

            if po_fix_rate = no then do:
               /* GET EXCHANGE RATE */
               {us/gp/gprunp.i "xxmcpl" "p" "mc-get-ex-rate"
                         "(input  po_curr,
                           input  base_curr,
                           input  exch_ratetype,
                           input  eff_date,
                           output exch_rate,
                           output exch_rate2,
                           output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {us/bbi/pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
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
               fiscal_rec = true.
               {us/bbi/gprun.i  ""txdetcpy.p""
                         "(input fiscal_id,
                           input pod_nbr,
                           input ""24"",
                           input receivernbr,
                           input pod_nbr,
                           input ""21"")"}
            end.

            assign
               porec = yes
               is-return = no
               tax_tr_type = '21'
               transtype="RCT-PO"
               cmmt-prefix = "RCPT:".

            if c-application-mode <> "API" then
               hide frame bb no-pause.

            /* CALCULATE QTY OPEN FOR DISCRETE PO'S BEING RECEIVED  */
            /* THROUGH THE SCHEDULED ORDER RECEIPT FUNCTION. QTY    */
            /* OPEN IS NEEDED FOR SUPPLIER PERFORMANCE CALCULATIONS */
            if not pod_sched then do:
               {us/bbi/gprun.i ""rsoqty.p""
                        "(input  recid(pod_det),
                          input  receipt_date,
                          output qopen)"}
            end.

            /* PROCESS ANY WIP LOT TRACE LOT/SERIAL RECORDS */
            if is_wiplottrace_enabled()
               and is_operation_queue_lot_controlled
                  (pod_wo_lot, pod_op, OUTPUT_QUEUE)
               and pod_type = "s"
            then do:
               run create_wip_lot_recs
                  (input work_abs_mstr.abs_shipfrom,
                   input work_abs_mstr.abs_id,
                   input pod_line).
            end.

            /* RELEASE POD_DET ENSURES THAT IN ORACLE ENVIRONMENT */
            release pod_det.

            if use-log-acctg and git-stat then do:

               do ii = length(abs_mstr.abs_id)
                     - length(abs_mstr.abs_order) + 1 to 3 by -1:

                  if substring(abs_mstr.abs_id,ii,length(abs_mstr.abs_order))
                     = abs_mstr.abs_order
                  then do:

                     ps-nbr = substring(abs_mstr.abs_id,3,ii - 3).
                     leave.
                  end.
               end. /* do loop */

               for first prh_hist
                  where prh_domain = global_domain
                    and prh_ps_nbr   = ps-nbr
               exclusive-lock:
                  receivernbr = prh_receiver.
               end.
            end. /* if use-log-acctg and git-stat */

            if c-application-mode = "API" and lLegacyAPI then do:
               {us/gp/gpttcp.i
                  ttPurchaseOrderShipTransTax
                  ttTransTaxAmount
                  " "
                  true}

               run setTransTaxAmount in apiMethodHandle
                  (input table ttTransTaxAmount).
            end.

            do on error undo, return error return-value:
               shipnbr = substring(abs_mstr.abs_par,2,20).
               {us/bbi/gprun.i ""poporcb.p""
                        "(input  shipnbr,
                          input  ship_date,
                          input  inv_mov,
                          input  """",
                          input  auto_receipt,
                          input  no,
                          input  0,
                          input  0,
                          input  """",
                          input  0,
                          input  l_int_ref_type,
                          output op_rctpo_trnbr)"}

               /* THE TEMP TABLE TT-POLINE-INFO CONTAINS PO LINE DETAIL */
               /* INFORMATION TO PROCESS FOR KANBAN TRANSACTIONS.       */
               for each tt-poline-info:

                  {us/px/pxrun.i &PROC = 'getCardRecommendationsForPOLine'
                           &PROGRAM = 'kbknbxr.p'
                           &HANDLE = ph_kbknbxr
                           &PARAM = "(input tt-poline-rowid,
                                      input vd_mstr.vd_addr,
                                      input tt-poline-info.tt-qty,
                                      input {&KB-CARDEVENT-FILL},
                                      input no,  /* create inventory trans */
                                      input eff_date,
                                      output table tt_kanban_cards,
                                      output table tt_kanban_loop_messages)"
                           &NOAPPERROR = true
                           &CATCHERROR = true}

                  /* DISPLAY ANY MESSAGE FROM CARD PROCESSING */
                  for each tt_kanban_loop_messages:
                     msg-text = tt_klm_msg_text + " "
                              + getTermLabel("PURCHASE_ORDER", 20) + ": "
                              + tt-poline-info.tt-poNumber + " "
                              + getTermLabel("LINE", 10) + ": "
                              + string(tt-poline-info.tt-poLine) + " "
                              + getTermLabel("ITEM", 10) + ": "
                              + tt-poline-info.tt-part.
                     {us/bbi/pxmsg.i &MSGTEXT= msg-text}
                  end.

                  if return-value <> {&SUCCESS-RESULT} then do:
                     undo-loop = yes.
                     return.
                  end.

                  /* CLEAR THE TEMP TABLE USED FOR PROCESSING KANBAN       */
                  /* TRANSACTIONS IN HEADLESS MODE.                        */
                  empty temp-table tt-kbtr-card no-error.

                  /* CALL CONSUME ROP NOW */
                  seqNbr = 0.

                  /* STORE THE CARD DETAIL INFORMATION IN TT-KBTR-CARD, */
                  /* AND ~ PASS TO THE KANBAN TRANSACTION PROCESSING    */
                  /* PROGRAM                                            */
                  for each tt_kanban_cards
                     where tt_kc_recommend_to_process = yes
                     use-index tt_kc_event_seq
                  no-lock:

                     create tt-kbtr-card.
                     assign
                        seqNbr = seqNbr + 1
                        tt-kbtr-card.tt-seq           = seqNbr
                        tt-kbtr-card.tt-knbd-id       = tt_kc_knbd_id
                        tt-kbtr-card.tt-batchProcess  = yes
                        tt-kbtr-card.tt-transEvent    = {&KB-CARDEVENT-FILL}
                        tt-kbtr-card.tt-effDate       = eff_date
                        tt-kbtr-card.tt-createInvTran = no
                        tt-kbtr-card.tt-lotSerial     = tt-poline-info.tt-lotser
                        tt-kbtr-card.tt-lotRef        = tt-poline-info.tt-ref.

                     for each tr_hist
                        where tr_domain = global_domain
                        and   tr_nbr = po_nbr
                        and   tr_lot = receivernbr
                        and   tr_part = tt-part
                        and   tr_effdate = eff_date
                     no-lock:
                        tt-kbtr-card.tt-tr-trnbr =
                           if (tt-kbtr-card.tt-tr-trnbr = "") then
                              string(tr_trnbr)
                           else
                              tt-kbtr-card.tt-tr-trnbr + "," + string(tr_trnbr).
                     end.
                  end.  /* for each tt_kanban_cards  */

                  /* RUN SUBPROGRAM TO PROCESS KANBAN TRANSACTIONS.  */
                  {us/bbi/gprun.i ""kbtrp.p""
                           "(input table tt-kbtr-card,
                             input-output table tt-kbtr-msgs,
                             output op-allSuccessful)"}

                  if not op-allSuccessful then do:
                     for each tt-kbtr-msgs:
                        /* SHOW THE ERRORS */
                        msg-text = tt-kbtr-msgs.tt-error-msg + " "
                                 + getTermLabel("CARD_ID", 12) + ": "
                                 + string(tt-kbtr-msgs.tt-knbd-id).
                        {us/bbi/pxmsg.i &MSGTEXT = msg-text
                                 &ERRORLEVEL = tt-error-level}

                     end.

                     undo-loop = yes.
                     return.
                  end. /* not successful */

                  /* REMOVE TT-POLINE-INFO ONCE THE WORK HAS BEEN FINISHED */
                  delete tt-poline-info.

               end. /* for each tt-poline-info */
            end. /*  do on error undo, return error return-value: */

            if not poshivmt and c-application-mode <> "API" then
               view frame bb.

            {us/bbi/gprun.i ""poporcd.p""}

         end.  /* last-of (pod_nbr) */

         /* CALCULATE AND EDIT TAXES */
         if proceed = yes then

            /* PASSED THE SECOND PARAMETER AS TEMP-TABLE CONTAINING THE */
            /* RECEIVED LINES SO THAT POTAXDT.P WILL EDIT ONLY RECEIVED */
            /* LINES WHEN ALL TAX TYPES HAVE TAX BY LINE AS YES.        */
            {us/bbi/gprun.i ""potaxdt.p""
                     "(input po_recno,
                       input table tt_po_tax)"}.

         for each tt_abspli_ref:
            for each plid_det
               where plid_domain  = global_domain
               and plid_pli_keyid = tt_abspli_ref.tt_abspli_pli_keyid
            exclusive-lock:

               /* FIND THE CORRESPONDING PVO_MSTR RECORDS */
               /* TO ASSIGN THE ID */
               for first pvo_mstr
                  where pvo_domain     = global_domain
                  and pvo_order        = plid_order
                  and pvo_internal_ref = receivernbr
                  and pvo_line         = plid_order_line
               no-lock:
                  plid_pvo_id = pvo_id.
               end.
            end. /* for first plid_det */
         end. /* FOR EACH TT_PLI_MSTR */
      end.    /* for each work_abs_mstr */

      run upd-kit-inv.

      /* DETAILED ALLOCATION OF BTB SO AND SHIPMENT */
      /* OF THE BTB DIRECT DELIVERY SO LINES        */
      for first abs_mstr
         where recid(abs_mstr) = abs_recid
      no-lock: end.

      /* DETAILED ALLOCTION FOR EMT SO */
      {us/bbi/gprun.i ""rssoall.p""
               "(input abs_mstr.abs_id,
                 input abs_mstr.abs_shipfrom)"}

      /* SO SHIPMENT FOR DIRECT DELIVERY EMT SO */
      {us/bbi/gprun.i ""rcshld.p""
               "(input  abs_mstr.abs_id,
                 input  abs_mstr.abs_shipfrom,
                 input  i_send_ts_asn,
                 input  i_trade_sale,
                 output undo_tran)"}

      if undo_tran then do:
         undo-loop = yes.
         return.
      end.

      /* UPDATE THE SHIP QTY OF THE abs_mstr RECORD NOW.*/
      /* DO NOT UPDATE SHIP QTY FOR LOGISTICS ACCOUNTING PO GIT RECEIPT */
      if not lagit then
         for each work_abs_mstr
            no-lock
            where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty,
         each abs_mstr
            exclusive-lock
            where abs_mstr.abs_domain   = global_domain
            and   abs_mstr.abs_shipfrom = work_abs_mstr.abs_shipfrom
            and   abs_mstr.abs_id       = work_abs_mstr.abs_id:

         assign
            abs_mstr.abs_ship_qty = abs_mstr.abs_qty.

         /* PROCESS ABSX_DET RECORDS AND UPDATE SUBCONTRACT */
         /* SHIPPER ABS_MSTR RECORDS.                       */
         for each absx_det
            where absx_domain     = global_domain
            and   absx_po_shipper = abs_mstr.abs_id
         exclusive-lock:

            assign
               rcpt_time = time.

            /* UPDATE THE RECEIPT QTY, DATE, TIME ON THE SUBCONTRACT SHIPPER */
            for first sub_abs
               where sub_abs.abs_domain = global_domain
               and   sub_abs.oid_abs_mstr = absx_det.oid_abs_subcontract
            exclusive-lock: end.

            assign
               sub_abs.abs_rcpt_qty = sub_abs.abs_rcpt_qty + absx_qty_to_receive
               sub_abs.abs_scrap_qty = sub_abs.abs_scrap_qty + absx_qty_to_scrap
               sub_abs.abs_arr_date  = eff_date
               sub_abs.abs_arr_time  = rcpt_time.

            /*UPDATE ABSW_DET RECORD IF IT EXISTS */
            for first absw_det
               where absw_det.oid_abs_mstr = absx_det.oid_abs_subcontract
               and   absw_det.absw_lotser  = absx_det.absx_lotser
               and   absw_det.absw_ref     = absx_det.absx_ref
            exclusive-lock:
               assign
                  absw_rcpt_qty = absw_rcpt_qty + absx_qty_to_receive
                  absw_scrap_qty = absw_scrap_qty + absx_qty_to_scrap.

               if absw_rcpt_qty = absx_qty_to_receive then
                  assign
                     absw_receipt_date = eff_date
                     absw_receipt_time = rcpt_time.
               else
                  if absw_rcpt_qty = 0 then
                     assign
                        absw_receipt_date = ?
                        absw_receipt_time = 0.
            end.

            /* USE SUB SHIPPER WORK ORDER ID IF NOT EXPIRED. */
            if can-find(first wo_mstr
               where wo_domain = global_domain
               and   wo_lot = sub_abs.abs_order
               and   wo_due_date < today)
            then
               cum_id_expired = true.
            else
               assign
                  cum_id_expired = false
                  ip_wolot = sub_abs.abs_order.

            if cum_id_expired then do:
               for first pod_det
                  where pod_domain = global_domain
                  and   pod_nbr = absx_po_nbr
                  and   pod_line = absx_pod_line
               no-lock:
                  ip_wolot = pod_wo_lot.
               end.
            end.

            if absx_qty_to_receive <> 0 then
               run checkAbsPoXref
                  (input absx_det.oid_abs_subcontract,
                   input absx_po_nbr,
                   input absx_pod_line,
                   input ip_wolot,
                   input absx_qty_to_receive).

            /* DELETE ABSX_DET*/
            delete absx_det.

         end.
      end.  /* FOR EACH WORK_ABS */
   end. /* TRANSACTION  CREATE RCT-PO & ISS-SO */

END PROCEDURE.   /* dotrans1 */

PROCEDURE recalc_freight:
/*-------------------------------------------------------------------------
 * Purpose:     Displays the popup only if there exists a DIR-SHIP
 *              Sales Order with freight terms
 *-------------------------------------------------------------------------*/
   define output parameter l_cal  like mfc_logical no-undo.

   for each work_abs_mstr
      where work_abs_mstr.abs_order <> ""
   no-lock:

      for first sod_det
         where sod_domain   = global_domain
         and   sod_btb_po   = abs_order
         and   sod_part     = abs_item
         and   sod_line     = integer(abs_line)
         and   sod_btb_type = "03"
         and   sod_compl_stat = ""
      no-lock: end.

      if available sod_det
         and (can-find (first so_mstr
         where so_domain   = global_domain
         and   so_nbr      = sod_nbr
         and   so_fr_terms <> ""
         and   so_fr_list  <> ""
         and   so_compl_stat = ""))
      then do:
         l_cal = yes.
         return.
      end.
   end. /* FOR EACH work_abs_mstr */

END PROCEDURE.   /* recalc_freight */

PROCEDURE update_container:
/*-----------------------------------------------------------------------*/
   /*  Purpose:     Rolls net weight and gross weight of child into parent. */
/*-----------------------------------------------------------------------*/
   define input parameter p_shipfrom like abs_mstr.abs_shipfrom no-undo.
   define input parameter p_par_id   like abs_mstr.abs_par_id   no-undo.
   define input parameter p_nwt      like abs_mstr.abs_nwt      no-undo.
   define input parameter p_gwt      like abs_mstr.abs_gwt      no-undo.

   define buffer b_parent_container for abs_mstr.

   find b_parent_container
      where b_parent_container.abs_shipfrom = p_shipfrom
      and   b_parent_container.abs_id       = p_par_id
      and   b_parent_container.abs_domain   = global_domain
   exclusive-lock no-error.

   if available b_parent_container then
      assign
         b_parent_container.abs_nwt = b_parent_container.abs_nwt + p_nwt
         b_parent_container.abs_gwt = b_parent_container.abs_gwt + p_gwt.

END PROCEDURE.   /* update_container */

PROCEDURE initAPI:
/*-----------------------------------------------------------------------*/
   /*  Purpose:     Initialize the API handles and buffers                  */
/*-----------------------------------------------------------------------*/
   define output parameter table for  ttPurchaseOrderShipTransTax.
   define parameter buffer ttPurchaseOrderShipperTrans
                                 for ttPurchaseOrderShipperTrans.

   if c-application-mode = "API" then do:

      /* GET HANDLE OF API CONTROLLER */
      {us/bbi/gprun.i ""gpaigh.p""
               "(output ApiMethodHandle,
                 output ApiProgramName,
                 output ApiMethodName,
                 output ApiContextString)"}

      /* GET PURCHASE ORDER SHIPPER TRANSACTION TEMP-TABLE */
      run getPurchaseOrderShipperTransRecord in ApiMethodHandle
         (buffer ttPurchaseOrderShipperTrans).

      /* GET PURCHASE ORDER SHIPPER TRANSACTION TAX TEMP-TABLE */
      run getPurchaseOrderShipTransTax in ApiMethodHandle
         (output table ttPurchaseOrderShipTransTax).

   end. /* if c-application-mode = "API" */

END PROCEDURE.   /* initAPI */

PROCEDURE removeTT_abs_mstr:
/*-----------------------------------------------------------------------*/
   /*  Purpose:     Remove the tt_abs_mstr records                          */
/*-----------------------------------------------------------------------*/

empty temp-table tt_abs_mstr.

END PROCEDURE.   /* removeTT_abs_mstr */

PROCEDURE SetMainScreen:
/*-----------------------------------------------------------------------*/
   /*  Purpose:     Display the main entry screen                           */
/*-----------------------------------------------------------------------*/
   define input parameter ip_abs_recid as recid no-undo.

   for first abs_mstr where recid(abs_mstr) = ip_abs_recid
   no-lock: end.

   if available abs_mstr
      and abs_id begins "S"
      and abs_type = "R"
   then do:

      for first ad_mstr
         where ad_domain = global_domain
         and   ad_addr = abs_shipfrom
      no-lock: end.

      if not poshivmt and c-application-mode <> "API" then
         display
            abs_shipfrom
            substring(abs_id,2,50) @ abs_id
            ad_name
            ad_line1
         with frame a.

      eff_date = today.

      if not poshivmt and c-application-mode <> "API"  then
         display
            eff_date
         with frame bb.

   end.

END PROCEDURE.   /* SetMainScreen */

PROCEDURE MarkShipperConfirmed:
/*-----------------------------------------------------------------------*/
   /*  Purpose:     Display the main entry screen                           */
/*-----------------------------------------------------------------------*/
   define input parameter i_abs_recid as recid no-undo.
   define input parameter i_trade_sale as logical no-undo.
   define input parameter i_send_ts_asn as logical no-undo.

   /* MARK SHIPPER CONFIRMED */
   find abs_mstr where recid(abs_mstr) = i_abs_recid exclusive-lock.
   /* FOR LOGISTICS ACCOUNTING PO GIT RECEIPT MARK WITH t INSTEAD OF y */
   assign
      substring(abs_status,2,1) = if not lagit then "y" else "t"
      abs_eff_date              = eff_date.

   if abs_shp_date = ? then
      abs_shp_date = eff_date.

   for first so_mstr where so_domain = global_domain
      and so_nbr    = abs_order
      and so_compl_stat = ""
   no-lock: end.

   if available so_mstr and (so_primary = yes)
      and (so_secondary = yes)
   then do:

      if i_trade_sale then
         for first sod_det
            where sod_domain   = global_domain
            and   sod_nbr      = abs_order
            and   sod_line     = integer(abs_line)
            and   sod_btb_type = "01"
            and   sod_compl_stat = ""
         no-lock: end.
      else
         for first sod_det
            where sod_domain   = global_domain
            and   sod_nbr      = abs_order
            and   sod_line     = integer(abs_line)
            and   sod_btb_type = "03"
            and   sod_compl_stat = ""
         no-lock: end.

      if available sod_det then do:
         for first ad_mstr
            where ad_domain = global_domain
            and   ad_addr   = abs_mstr.abs_shipto
         no-lock: end.

         if available ad_mstr and
            substring(ad_edi_ctrl[1],1,1) = "e"
         then do:

            assign
               doc-type = "ASN"
               doc-ref  = abs_mstr.abs_shipfrom
               add-ref  = abs_id
               msg-type = "ASN".

            if (not i_trade_sale) or
               (i_trade_sale and i_send_ts_asn)
            then

            /* QUEUE DOCUMENT FOR TRANSMISSION - BTB */
            {us/bbi/gprun.i ""gpquedoc.p""
                     "(input-output doc-type,
                       input-output abs_shipfrom,
                       input-output abs_id,
                       input-output msg-type,
                       input-output trq-id,
                       input yes)"}.

         end.   /* if available ad_mstr */
      end. /* if available sod_det */
   end. /* if available so_mstr and so_primary and so_secondary */

END PROCEDURE.   /* MarkShipperConfirmed */

/* PROCEDURE TO CREATE attr_wkfl */

PROCEDURE proc-attr-wkfl:
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
      where chg_line = string(inpar_line)
   exclusive-lock no-error.

   if not available attr_wkfl then do:
      create attr_wkfl.
      chg_line = string(inpar_line).
   end.

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

END PROCEDURE. /* proc-attr-wkfl */

PROCEDURE createQadWkfl:
/*-------------------------------------------------------------
 * Purpose:  This procedure populates the qad_wkfl which determines
 *          if the shipper is in transit.
 *-------------------------------------------------------------*/

   create qad_wkfl.
   assign
      qad_domain    = global_domain
      qad_key1      = SessionUniqueID
      qad_key2      = "lagitrc"
      qad_logfld[1] = true.

   if recid(qad_wkfl) = -1 then .

   git-stat = qad_logfld[1].

END PROCEDURE.   /* createQadWkfl */

PROCEDURE deleteQadWkfl:
/*-------------------------------------------------------------
 * Purpose:  This procedure deletes the qad_wkfl
 *-------------------------------------------------------------*/

   for first qad_wkfl
      where qad_domain = global_domain
      and qad_key1 = SessionUniqueID
      and qad_key2 = "lagitrc"
   exclusive-lock:
      delete qad_wkfl.
   end.

END PROCEDURE.   /* deleteQadWkfl */

PROCEDURE checkAbsPoXref:
   /* This procedure checks to see if an absp_det record exists. The absp_det   */
   /* record gets created to indicate that there is a receipt quantity pending  */
   /* for a specific subcontract shipper.  This will prevent more than the qty  */
   /* originally shipped by the subcontract shipper from being received.        */
   /* The absp_det record is created and used by PO Receipts, PO Shipper        */
   /* Receipts and PO Returns.                                                  */

   define input parameter ip_oid_abs_mstr  as decimal    no-undo.
   define input parameter ip_po_nbr   as character  no-undo.
   define input parameter ip_po_line  like pod_line no-undo.
   define input parameter ip_cumid    as character  no-undo.
   define input parameter ip_rcpt_qty as decimal    no-undo.

   find absp_det
      where absp_det.oid_abs_mstr = ip_oid_abs_mstr
      and   absp_po_nbr   = ip_po_nbr
      and   absp_pod_line = ip_po_line
      and   absp_wo_lot   = ip_cumid
   exclusive-lock no-error.

   if available absp_det then do:
      absp_rcpt_qty = absp_rcpt_qty + ip_rcpt_qty.

      /*DELETE THE RECORD IF THE RCPT QTY GOES BACK DOWN TO ZERO*/
      if absp_rcpt_qty = 0 then
         delete absp_det.

   end. /*IF AVAILABLE*/

   else do:
      create absp_det.
      assign
         absp_det.oid_abs_mstr = ip_oid_abs_mstr
         absp_rcpt_qty         = ip_rcpt_qty
         absp_po_nbr           = ip_po_nbr
         absp_pod_line         = ip_po_line
         absp_wo_lot           = ip_cumid
         absp_mod_date         = today
         absp_mod_userid       = global_userid.

      if recid(absp_det) = -1 then .
   end.

END PROCEDURE. /* checkAbsPoXref */

PROCEDURE create_wip_lot_recs:
   define input parameter ip_shipfrom as character no-undo.
   define input parameter ip_abs_id like abs_mstr.abs_id no-undo.
   define input parameter ip_line as integer no-undo.

   define buffer abs_wiplot for abs_mstr.

   for each abs_wiplot
      where abs_wiplot.abs_domain = global_domain
      and   abs_wiplot.abs_shipfrom = ip_shipfrom
      and   abs_wiplot.abs_par_id  = ip_abs_id
   no-lock:

      run create_poline_bkfl_wip_lots in h_wiplottrace_procs
         (input abs_wiplot.abs_id,
          input ip_line,
          input abs_wiplot.abs_lotser,
          input abs_wiplot.abs_ref,
          input abs_wiplot.abs_qty).

   end.

END PROCEDURE.   /* create_wip_lot_recs */

PROCEDURE p_validateTransaction:

   define input parameter p_transtype like tr_type.
   define input parameter p_site      like tr_site.
   define input parameter p_location  like tr_loc.
   define input parameter p_part      like tr_part.
   define input parameter p_lotser    like pt_lot_ser.
   define input parameter p_ref       like sr_ref.
   define output parameter p_undotran like mfc_logical no-undo.

   define variable l_status  like si_status initial "" no-undo.

   for first ld_det
      where ld_det.ld_domain = global_domain
      and   ld_site          = p_site
      and   ld_loc           = p_location
      and   ld_part          = p_part
      and   ld_lot           = p_lotser
      and   ld_ref           = p_ref
   no-lock:
      l_status = ld_status.
   end. /* FOR FIRST ld_det */

   if not available ld_det
   then do:

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

      end. /* IF NOT AVALIABLE loc_mstr */
   end. /* IF NOT AVAILABLE ld_det */

   /* MAKE SURE STATUS CODE EXISTS AND TRANSTYPE ALLOWED */
   for first is_mstr
      where is_domain = global_domain
        and is_status = l_status
   no-lock: end.

   if not available is_mstr
   then do:
      /* INVENTORY STATUS IS NOT DEFINED */
      {us/bbi/pxmsg.i &MSGNUM=361 &ERRORLEVEL=3}
      undo, retry.
   end.

   for first isd_det
      where isd_domain  = global_domain
        and isd_tr_type = p_transtype
        and isd_status  = is_status
   no-lock: end.

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

PROCEDURE check-locked-po:
   define input parameter p_po_number like po_mstr.po_nbr no-undo.

   l_po_locked  = no.

   find po_mstr
      where po_domain = global_domain
      and   po_nbr    = p_po_number
   exclusive-lock no-wait no-error.

   if locked(po_mstr)
      or not available po_mstr
   then do:
      l_po_locked  = yes.
      return.
   end. /* IF LOCKED(po_mstr)... */

END PROCEDURE. /* PROCEDURE check-locked-po */

PROCEDURE assignPackingSlip:
   define input parameter pAbsRecid as recid no-undo.

   define buffer bf_abs_mstr for abs_mstr.
   define buffer lgd_mstr for lgd_mstr.
   define buffer lgdd_det for lgdd_det.

   for first abs_mstr where recid(abs_mstr) = pAbsRecid
   no-lock:
      /* Assign packing slip to lgd_ps_nbr */
      for each lgd_mstr where lgd_mstr.lgd_domain = global_domain
         and lgd_shipper_id = abs_mstr.abs_id
         and lgd_type = yes
      exclusive-lock:
         lgd_ps_nbr = substring(abs_mstr.abs_id,2).
      end.

      /* Assign packing slip qty to lgdd_ps_qty */
      for each lgdd_det exclusive-lock
         where lgdd_det.oid_lgd_mstr = lgd_mstr.oid_lgd_mstr,
         each bf_abs_mstr where bf_abs_mstr.abs_domain = global_domain
         and bf_abs_mstr.abs_par_id = abs_mstr.abs_id
         and bf_abs_mstr.abs_order = lgdd_order
         and bf_abs_mstr.abs_line = string(lgdd_order_line)
      no-lock:
         lgdd_ps_qty = bf_abs_mstr.abs_cum_qty.
      end.
   end.
END PROCEDURE.
