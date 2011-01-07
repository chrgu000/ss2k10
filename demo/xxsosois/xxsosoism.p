/* sosoism.p - SALES ORDER SHIPMENT WITH SERIAL NUMBERS                       */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 1.0      LAST MODIFIED: 07/28/86   BY: PML                       */
/* REVISION: 6.0      LAST MODIFIED: 03/14/90   BY: emb *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 03/14/90   BY: WUG *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 04/30/90   BY: MLB *D021*                */
/* REVISION: 6.0      LAST MODIFIED: 12/17/90   BY: WUG *D447*                */
/* REVISION: 6.0      LAST MODIFIED: 01/14/91   BY: emb *D313*                */
/* REVISION: 6.0      LAST MODIFIED: 02/18/91   BY: afs *D354*                */
/* REVISION: 6.0      LAST MODIFIED: 03/18/91   BY: MLB *D443*                */
/* REVISION: 6.0      LAST MODIFIED: 04/03/91   BY: afs *D477*   (rev only)   */
/* REVISION: 6.0      LAST MODIFIED: 04/08/91   BY: afs *D497*                */
/* REVISION: 6.0      LAST MODIFIED: 04/09/91   BY: afs *D510*                */
/* REVISION: 6.0      LAST MODIFIED: 05/09/91   BY: emb *D643*                */
/* REVISION: 6.0      LAST MODIFIED: 05/28/91   BY: emb *D661*                */
/* REVISION: 6.0      LAST MODIFIED: 06/04/91   BY: emb *D673*                */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*                */
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: MLV *F029*                */
/* REVISION: 7.0      LAST MODIFIED: 11/13/91   BY: WUG *D887*                */
/* REVISION: 7.0      LAST MODIFIED: 11/18/91   BY: WUG *D858*                */
/* REVISION: 7.0      LAST MODIFIED: 11/18/91   BY: WUG *D953*                */
/* REVISION: 7.0      LAST MODIFIED: 11/25/91   BY: SAS *F017*                */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*                */
/* REVISION: 7.0      LAST MODIFIED: 02/19/92   BY: afs *F209*                */
/* REVISION: 7.0      LAST MODIFIED: 04/22/92   BY: afs *F379*                */
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: tjs *F504*                */
/* REVISION: 7.0      LAST MODIFIED: 07/01/92   BY: tjs *F726*                */
/* REVISION: 7.0      LAST MODIFIED: 07/27/92   BY: tjs *F732*                */
/* REVISION: 7.0      LAST MODIFIED: 07/23/92   BY: tjs *F805*                */
/* REVISION: 7.3      LAST MODIFIED: 09/17/92   BY: tjs *G035*                */
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247*                */
/* REVISION: 7.2      LAST MODIFIED: 11/09/92   BY: emb *G292*                */
/* REVISION: 7.3      LAST MODIFIED: 11/09/92   BY: afs *G302*                */
/* REVISION: 7.3      LAST MODIFIED: 12/05/92   BY: mpp *G484*                */
/* REVISION: 7.3      LAST MODIFIED: 02/19/93   BY: tjs *G702*                */
/* REVISION: 7.2      LAST MODIFIED: 03/16/93   BY: tjs *G451*                */
/* REVISION: 7.3      LAST MODIFIED: 03/18/93   BY: afs *G818*                */
/* REVISION: 7.3      LAST MODIFIED: 04/26/93   BY: WUG *GA39*                */
/* REVISION: 7.3      LAST MODIFIED: 06/09/93   BY: sas *GB82*                */
/* REVISION: 7.3      LAST MODIFIED: 06/11/93   BY: sas *GC18*                */
/* REVISION: 7.3      LAST MODIFIED: 06/25/93   BY: WUG *GC74*                */
/* REVISION: 7.3      LAST MODIFIED: 06/28/93   BY: afs *GC22*                */
/* REVISION: 7.3      LAST MODIFIED: 07/01/93   BY: jjs *GC96*                */
/* REVISION: 7.3      LAST MODIFIED: 07/27/93   BY: tjs *GD76*                */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*                */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*                */
/* REVISION: 7.4      LAST MODIFIED: 11/14/93   BY: afs *H222*                */
/* REVISION: 7.4      LAST MODIFIED: 01/24/94   BY: afs *FL52*                */
/* REVISION: 7.4      LAST MODIFIED: 07/20/94   BY: bcm *H447*                */
/* Oracle changes (share-locks)      09/13/94   BY: rwl *FR31*                */
/* REVISION: 7.4      LAST MODIFIED: 09/23/94   BY: ljm *GM78*                */
/* REVISION: 8.5      LAST MODIFIED: 10/05/94   BY: mwd *J034*                */
/* REVISION: 8.5      LAST MODIFIED: 10/21/94   BY: rmh *FQ08*                */
/* REVISION: 8.5      LAST MODIFIED: 11/01/94   BY: ame *GN90*                */
/* REVISION: 8.5      LAST MODIFIED: 11/11/94   BY: jxz *FT56*                */
/* REVISION: 8.5      LAST MODIFIED: 12/20/94   BY: rxm *F0B4*                */
/* REVISION: 8.5      LAST MODIFIED: 01/07/95   BY: smp *G0BM*                */
/* REVISION: 8.5      LAST MODIFIED: 01/16/95   BY: rxm *F0F0*                */
/* REVISION: 8.5      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 8.5      LAST MODIFIED: 03/30/95   BY: pmf *G0JW*                */
/* REVISION: 8.5      LAST MODIFIED: 06/16/95   BY: rmh *J04R*                */
/* REVISION: 8.5      LAST MODIFIED: 04/06/95   BY: tvo *H0BJ*                */
/* REVISION: 8.5      LAST MODIFIED: 07/18/95   BY: taf *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 02/07/96   BY: ais *G0NX*                */
/* REVISION: 8.5      LAST MODIFIED: 03/11/96   BY: wjk *J0DV*                */
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: *J04C* Markus Barone      */
/* REVISION: 8.5      LAST MODIFIED: 06/13/96   BY: *G1Y6* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 07/18/96   BY: *J0ZX* Andy Wasilczuk     */
/* REVISION: 8.5      LAST MODIFIED: 07/28/96   BY: *J0ZZ* Tamra Farnsworth   */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Kurt De Wit        */
/* REVISION: 8.6      LAST MODIFIED: 11/25/96   BY: *K01X* Jeff Wootton       */
/* REVISION: 8.6      LAST MODIFIED: 01/02/97   BY: *J1D8* Sue Poland         */
/* REVISION: 8.6      LAST MODIFIED: 05/14/97   BY: *G2MT* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 07/14/97   BY: *G2NY* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 07/11/97   BY: *K0DH* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 09/02/97   BY: *J205* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 10/24/97   BY: *K0JV* Surendra Kumar     */
/* REVISION: 8.6      LAST MODIFIED: 10/29/97   BY: *G2Q3* Steve Nugent       */
/* REVISION: 8.6      LAST MODIFIED: 11/03/97   BY: *J22N* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 11/07/97   BY: *K15N* Jim Williams       */
/* REVISION: 8.6      LAST MODIFIED: 01/14/98   BY: *J29W* Aruna Patil        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 04/27/98   BY: *L00L* Adam Harris        */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 05/12/98   BY: *J2DD* Kawal Batra        */
/* REVISION: 8.6E     LAST MODIFIED: 06/22/98   BY: *H1JB* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 07/12/98   BY: *L024* Sami Kureishy      */
/* REVISION: 8.6E     LAST MODIFIED: 09/02/98   BY: *H1LZ* Manish Kulkarni    */
/* REVISION: 8.6E     LAST MODIFIED: 09/15/98   BY: *J2YT* Irine D'mello      */
/* REVISION: 8.6E     LAST MODIFIED: 09/16/98   BY: *L092* Steve Goeke        */
/* REVISION: 8.6E     LAST MODIFIED: 02/16/99   BY: *J3B4* Madhavi Pradhan    */
/* REVISION: 9.1      LAST MODIFIED: 07/13/99   BY: *J2MD* A. Philips         */
/* REVISION: 9.1      LAST MODIFIED: 09/08/99   BY: *N02S* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 10/06/99   BY: *N03Z* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 10/21/99   BY: *N04X* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 10/27/99   BY: *N03P* Mayse Lai          */
/* REVISION: 9.1      LAST MODIFIED: 11/03/99   BY: *N04P* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 01/02/00   BY: *N07J* Pat Pigatti        */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Luke Pokic         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 02/16/00   BY: *N06R* Denis Tatarik      */
/* REVISION: 9.1      LAST MODIFIED: 04/21/00   BY: *N09J* Denis Tatarik      */
/* REVISION: 9.1      LAST MODIFIED: 06/05/00   BY: *N0CZ* John Pison         */
/* REVISION: 9.1      LAST MODIFIED: 07/11/00   BY: *M0PQ* Falguni Dalal      */
/* REVISION: 9.1      LAST MODIFIED: 07/20/00   BY: *L0QV* Manish Kulkarni    */
/* REVISION: 9.1      LAST MODIFIED: 08/16/00   BY: *N0K6* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00   BY: *M0T3* Rajesh Kini        */
/* REVISION: 9.1      LAST MODIFIED: 12/14/00   BY: *M0XX* Ashwini Ghaisas    */
/* REVISION: 9.1      LAST MODIFIED: 01/11/01   BY: *M0XM* Rajesh Lokre       */
/* REVISION: 9.1      LAST MODIFIED: 10/10/00   BY: *N0WB* Mudit Mehta        */
/* Revision: 1.34.1.34     BY: Katie Hilbert       DATE: 04/01/01 ECO: *P002* */
/* Revision: 1.34.1.35     BY: Ellen Borden        DATE: 07/09/01 ECO: *P007* */
/* Revision: 1.34.1.36     BY: Annasaheb Rahane    DATE: 09/12/01 ECO: *N129* */
/* Revision: 1.34.1.39     BY: Nikita Joshi        DATE: 01/14/02 ECO: *M1MH* */
/* Revision: 1.34.1.40     BY: Santosh Rao         DATE: 02/18/02 ECO: *N19C* */
/* Revision: 1.34.1.41     BY: Rajaneesh Sarangi   DATE: 02/21/02 ECO: *L13N* */
/* Revision: 1.34.1.45     BY: Patrick Rowan       DATE: 04/24/02 ECO: *P00G* */
/* Revision: 1.34.1.47     BY: Jean Miller         DATE: 05/21/02 ECO: *P05V* */
/* Revision: 1.34.1.50     BY: Samir Bavkar        DATE: 05/08/02 ECO: *P042* */
/* Revision: 1.34.1.53     BY: Robin McCarthy      DATE: 07/03/02 ECO: *P08Q* */
/* Revision: 1.34.1.54     BY: Robin McCarthy      DATE: 07/15/02 ECO: *P0BJ* */
/* Revision: 1.34.1.56     BY: Samir Bavkar        DATE: 08/15/02 ECO: *P09K* */
/* Revision: 1.34.1.57     BY: Samir Bavkar        DATE: 08/18/02 ECO: *P0FS* */
/* Revision: 1.34.1.58     BY: Samir Bavkar        DATE: 08/28/02 ECO: *P0H5* */
/* Revision: 1.34.1.59     BY: Deepak Rao          DATE: 10/24/02 ECO: *N1Y3* */
/* Revision: 1.34.1.60     BY: Robin McCarthy      DATE: 11/08/02 ECO: *P0JS* */
/* Revision: 1.34.1.61     BY: Mercy Chittilapilly DATE: 01/15/03 ECO: *N244* */
/* Revision: 1.34.1.62     BY: Dorota Hohol        DATE: 02/25/03 ECO: *P0N6* */
/* Revision: 1.34.1.63     BY: Narathip W.         DATE: 05/08/03 ECO: *P0RL* */
/* Revision: 1.34.1.65     BY: Paul Donnelly (SB)  DATE: 06/28/03 ECO: *Q00L* */
/* Revision: 1.34.1.66     BY: Ed van de Gevel     DATE: 07/08/03 ECO: *Q003* */
/* Revision: 1.34.1.67     BY: Deepak Rao          DATE: 08/20/03 ECO: *N2K3* */
/* Revision: 1.34.1.68     BY: Deepak Rao          DATE: 09/08/03 ECO: *N2KM* */
/* Revision: 1.34.1.69     BY: Mercy Chittilapilly DATE: 01/12/04 ECO: *P1JM* */
/* Revision: 1.34.1.72     BY: Robin McCarthy      DATE: 04/19/04 ECO: *P15V* */
/* Revision: 1.34.1.73     BY: Robin McCarthy      DATE: 08/09/04 ECO: *Q0BZ* */
/* Revision: 1.34.1.74     BY: Ed van de Gevel     DATE: 06/10/04 ECO: *Q08R* */
/* Revision: 1.34.1.75     BY: Bhavik Rathod       DATE: 11/26/04 ECO: *P2X0* */
/* Revision: 1.34.1.77     BY: Vinod Kumar         DATE: 12/06/04 ECO: *P2TK* */
/* Revision: 1.34.1.78     BY: Abhishek Jha        DATE: 01/16/05 ECO: *P34D* */
/* Revision: 1.34.1.80     BY: Abhishek Jha        DATE: 01/26/05 ECO: *P353* */
/* Revision: 1.34.1.81     BY: Bhagyashri Shinde   DATE: 02/04/05 ECO: *P36P* */
/* Revision: 1.34.1.81.1.1 BY: Shoma Salgaonkar    DATE: 03/10/05 ECO: *P3CF* */
/* Revision: 1.34.1.81.1.2 BY: Vinod Kumar         DATE: 06/24/05 ECO: *Q0K1* */
/* Revision: 1.34.1.81.1.3 BY: Priya Idnani        DATE: 08/22/05 ECO: *P3YR* */
/* Revision: 1.34.1.81.1.5 BY: Jean Miller         DATE: 01/11/06 ECO: *Q0PD* */
/* Revision: 1.34.1.81.1.6 BY: Munira Savai        DATE: 04/20/06 ECO: *P4N7* */
/* Revision: 1.34.1.81.1.7 BY: Antony LejoS        DATE: 11/04/07 ECO: *P5T1* */
/* $Revision: 1.34.1.81.1.8 $   BY: Iram Momin     DATE: 10/30/07  ECO: *P69Z*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/******************************************************************************/
/* Due to the introduction of the module Project Realization Management (PRM) */
/* the term Material Order (MO) replaces all previous references to Service   */
/* Engineer Order (SEO) in the user interface. Material Order is a type of    */
/* Sales Order used by an engineer to obtain inventory needed for service     */
/* work. In PRM, a material order is used to obtain inventory for project     */
/* work.                                                                      */
/******************************************************************************/

/*****************************************************************************/
/*                                                                           */
/*    Any for each loops which go through every sod_det for a                */
/*    so_nbr (i.e. for each sod_det where sod_nbr = so_nbr )                 */
/*    should have the following statments first in the loop.                 */
/*                                                                           */
/*       if (sorec = fsrmarec    and sod_fsm_type  <> "RMA-RCT")             */
/*       or (sorec = fsrmaship   and sod_fsm_type  <> "RMA-ISS")             */
/*       or (sorec = fssormaship and sod_fsm_type  =  "RMA-RCT")             */
/*       or (sorec = fssoship    and sod_fsm_type  <> "")                    */
/*       then next.                                                          */
/*                                                                           */
/*    This is to prevent rma receipt line from being processed               */
/*    when issue lines are processed (sas).                                  */
/*                                                                           */
/*    Also, sosoisa.p is called by fsrmamtu.p which is called                */
/*    from fsrmamt.p (rma maintenance). Any shared variables                 */
/*    added to sosoisa.p will need to be added to one or both                */
/*    of the above rma programs....                                          */
/*                                                                           */
/*****************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{cxcustom.i "SOSOISM.P"}
{gplabel.i}    /* EXTERNAL LABEL INCLUDE */
{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */

{sosois1.i}

define new shared variable rndmthd   like rnd_rnd_mthd.
define new shared variable  copyusr  like mfc_logical.
define new shared variable fill_all  like mfc_logical label "Ship Allocated"
   initial no.
define new shared variable fill_pick like mfc_logical label "Ship Picked"
   initial yes.
define new shared variable so_mstr_recid as recid.
define new shared variable qty_left like tr_qty_chg.
define new shared variable trqty like tr_qty_chg.
define new shared variable eff_date like glt_effdate label "Effective".
define new shared variable trlot like tr_lot.
define new shared variable ref like glt_ref.
define new shared variable qty_req like in_qty_req.
define new shared variable open_ref like sod_qty_ord.
define new shared variable fas_so_rec as character.
define new shared variable undo-all like mfc_logical no-undo.
define new shared variable cline as character.
define new shared variable lotserial_control as character.
define new shared variable issue_or_receipt as character.
define new shared variable total_lotserial_qty like sod_qty_chg.
define new shared variable multi_entry like mfc_logical label "Multi Entry".
define new shared variable site like sr_site no-undo.
define new shared variable location like sr_loc no-undo.
define new shared variable lotserial like sr_lotser no-undo.
define new shared variable lotserial_qty like sr_qty no-undo.
define new shared variable trans_um like pt_um.
define new shared variable trans_conv like sod_um_conv.
define new shared variable loc like pt_loc.
define new shared variable sod_recno as recid.
define new shared variable exch_rate like exr_rate.
define new shared variable exch_rate2 like exr_rate2.
define new shared variable exch_ratetype like exr_ratetype.
define new shared variable exch_exru_seq like exru_seq.
define new shared variable change_db like mfc_logical.
define new shared variable so_db like dc_name.
define new shared variable ship_site like sod_site.
define new shared variable ship_db like dc_name.
define new shared variable ship_entity like en_entity.
define new shared variable ship_so like so_nbr.
define new shared variable ship_line like sod_line.
define new shared variable new_site like so_site.
define new shared variable new_db like so_db.
define new shared variable lotref like sr_ref format "x(8)" no-undo.
define new shared variable lotrf  like sr_ref format "x(8)" no-undo.
define new shared variable transtype as character initial "ISS-SO".
define new shared variable freight_ok  like mfc_logical.
define new shared variable old_ft_type like ft_type.
define new shared variable calc_fr     like mfc_logical label "Calculate Freight".
define new shared variable undo-select like mfc_logical no-undo.
define new shared variable disp_fr   like mfc_logical label "Display Weights".
define new shared variable qty_chg   like sod_qty_chg.
define new shared variable gl_amt    like sod_fr_chg.
define new shared variable accum_qty_all like sod_qty_all.
define new shared variable site_to   like sod_site.
define new shared variable loc_to    like sod_loc.
define new shared variable batch_id  like bcd_batch.
define new shared variable dev       as character label "Output".
define new shared variable new_line  like mfc_logical.
define new shared variable base_amt  like ar_amt.

define variable oldcurr      like so_curr no-undo.
define variable prefix       as character initial "C" no-undo.
define variable cchar        as   character no-undo.
define variable recalc       like mfc_logical initial true no-undo.
define variable vSOToHold    like so_nbr no-undo.
define variable errorNbr     as integer no-undo.
define variable l_undo       like mfc_logical no-undo.
define variable filllbl      as character format "x(15)" no-undo.
define variable fillpk       as character format "x(15)" no-undo.
define variable err-flag     as integer no-undo.
define variable old_um       like fr_um no-undo.
define variable batch_update  like mfc_logical label "Auto Batch Shipment"
   no-undo.
define variable batch_mfc     like mfc_logical no-undo.
define variable btemp_mfguser as character no-undo.
define variable batch_review    like mfc_logical no-undo.
define variable l_old_entity    like si_entity no-undo.
define variable db_undo         like mfc_logical no-undo.
define variable l_recalc        like mfc_logical no-undo.
define variable mc-error-number like msg_nbr     no-undo.
define variable err_check       like mfc_logical no-undo.
define variable lv_undo_flag    as logical no-undo.
define variable use-log-acctg   as logical no-undo.
define variable tax_type        like tx2d_tr_type no-undo.
define variable lv_shipfrom     like so_site no-undo.
define variable lv_nrm_seqid    like lac_soship_nrm_id no-undo.
define variable lv_shipment_id  as character format "x(24)" no-undo.
define variable lv_accrue_freight as logical no-undo.
define variable order-on-shipper as logical no-undo.
define variable old_fr_terms  like so_fr_terms no-undo.
define variable l_parent_abs_id  like abs_id    no-undo.
define variable l_batch_mfguser as character    no-undo.
define variable lv_error_num    as integer      no-undo.
define variable lv_name         as character    no-undo.
define variable ok_to_ship      as logical      no-undo.

define temp-table tt_sod_det no-undo
   field tt_sod_nbr  like sod_nbr
   field tt_sod_line like sod_line
   field tt_pr_found as logical
   index i_sodnbr tt_sod_nbr.

{&SOSOISM-P-TAG1}
/* COMMON API CONSTANTS AND VARIABLES */
{mfaimfg.i}

/* ASN API TEMP-TABLE */
{soshxt01.i}

{txcalvar.i}

{socnvars.i}         /* CONSIGNMENT VARIABLES. */

{etdcrvar.i "NEW"}
{etsotrla.i "NEW"}

if c-application-mode = "API" then do:

   /*
   * GET HANDLE OF API CONTROLLER
   */
   {gprun.i ""gpaigh.p""
      "(output apiMethodHandle,
        output apiProgramName,
        output apiMethodName,
        output apiContextString)"}

   /*
   * GET SO SHIPMENT HDR TEMP-TABLE
   */
   run getSoShipHdrRecord in apiMethodHandle
      (buffer ttSoShipHdr).

   /* WHEN CALLED FROM AN API (EDI ECOMMERCE) PROGRAM, WE NEED
      TO UPDATE THE EXECNAME TO SOSOISM.P SO THAT THE FUNCTIONALITY
      AVAILABLE IN SO SHIPMENT MAINTENANCE IS AVAILABLE TO THE API PROGRAM.
      THE EXECNAME HAS TO BE SET TO THE SOSOIS.P, WHICH IS A MENU LEVEL
      PROGRAM
   */
   execname = "sosois.p".
end. /* IF c-application-mode = "API" */

{socnis.i}           /* CONSIGNMENT TEMP-TABLE DEFINITION */
{lafrttmp.i "new"}   /* FREIGHT ACCRUAL TEMP-TABLE DEFINITION */

define buffer srwkfl for sr_wkfl.
define buffer somstr for so_mstr.

{&SOSOISM-P-TAG12}

/*************SET INITIAL VALUES************ */
assign
   issue_or_receipt = getTermLabel("ISSUE",8)
   filllbl = getTermLabel("SHIP_ALLOCATED",14) + ":"
   fillpk  = getTermLabelRtColon("SHIP_PICKED",15).

/* ASSIGN ORIGINAL FORMAT TO _OLD VARIABLES */
assign
   nontax_old   = nontaxable_amt:format
   taxable_old  = taxable_amt:format
   line_tot_old = line_total:format
   disc_old     = disc_amt:format
   trl_amt_old  = so_trl1_amt:format
   tax_amt_old  = tax_amt:format
   ord_amt_old  = ord_amt:format
   container_old = container_charge_total:format
   line_charge_old = line_charge_total:format.

/* DEFINE VARIABLES USED IN GPGLEF1.P (GL CALENDAR VALIDATION) */
{gpglefv.i}

/* INPUT OPTION FORM */
{&SOSOISM-P-TAG13}
form
   so_nbr         colon 12   label "Order"
   filllbl        at 24      no-label
   fill_all                  no-label space(3)
   so_cust
   ship_site
   eff_date       colon 12
   fillpk         at 24      no-label
   fill_pick                 no-label space(3)
   ad_name        no-label
with frame a side-labels width 80.
{&SOSOISM-P-TAG14}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

fill_pick:hidden = true.

form
   so_fr_list       colon 26
   so_fr_min_wt     colon 26
   fr_um            no-label
   so_fr_terms      colon 26
   calc_fr          colon 26
   disp_fr          colon 26
with frame d overlay side-labels centered row 7 width 50.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).
{&SOSOISM-P-TAG10}

/* Pop-up frame for batch update info */
form
   batch_update colon 30
   dev          colon 30
   batch_id     colon 30
with frame batr_up width 50 column 15
title color normal (getFrameTitle("BATCH_PROCESSING",24))
side-labels overlay.

/* SET EXTERNAL LABELS */
setFrameLabels(frame batr_up:handle).

/* SET EXTERNAL LABELS */
assign
   filllbl = getTermLabelRtColon("SHIP_ALLOCATED",15)
   fillpk  = getTermLabelRtColon("SHIP_PICKED",15).

/* CHECK TO SEE IF CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_CUSTOMER_CONSIGNMENT,
           input 10,
           input ADG,
           input CUST_CONSIGN_CTRL_TABLE,
           output using_cust_consignment)"}

if sorec = fsrmarec then
assign
   filllbl = getTermLabelRtColon("RECEIVE_ALL",15)
   fillpk  = "".

if c-application-mode <> "API" then do:
   display
      filllbl
      fillpk
   with frame a.

   view frame a.
end. /* IF C-APPLICATION-MODE <> "API" */

assign
   eff_date = today
   so_db = global_db.

run find-mfcctrl.

do transaction:

   run p_find_mfc.

   for first fac_ctrl
      fields (fac_domain fac_so_rec)
      where   fac_domain = global_domain
   no-lock:
      fas_so_rec = string(fac_so_rec).
   end.

end.  /* transaction to find control file variables. */

/* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

run p-find-mfc-rec.


/* Need to undo the mainloop and after that set a field */
upperloop:
repeat:

   if c-application-mode = "API" and retry
      then return error return-value.

   /* DISPLAY */
   mainloop:

   do on error undo mainloop, leave mainloop:
      if c-application-mode = "API" and retry
         then return error return-value.

      if c-application-mode <> "API" then do:
         /*V8! hide all no-pause.
         if global-tool-bar and global-tool-bar-handle <> ? then
         view global-tool-bar-handle.
         view frame a. */
      end. /* IF C-APPLICATION-MODE <> "API" */

      do transaction:
         if c-application-mode = "API" and retry
            then return error return-value.

         if c-application-mode <> "API" then do:
            display
              eff_date
              fill_all
               fill_pick   when (sorec <> fsrmarec)
            with frame a.

            prompt-for
               so_nbr
               eff_date
               fill_all
               fill_pick when (sorec <> fsrmarec)
               ship_site
            with frame a
            editing:

               if frame-field = "so_nbr" then do:
                  /* FIND NEXT/PREVIOUS RECORD */
                  /* IF WE'RE SHIPPING/RECEIVING RMA'S, NEXT/PREV ON RMA'S */
                  /* ONLY ELSE, NEXT/PREV ON SALES ORDERS.                 */
                  if sorec = fsrmarec or sorec = fsrmaship then do:
                     {mfnp05.i
                        so_mstr
                        so_fsm_type
                        "so_domain = global_domain and so_fsm_type  =
                        ""RMA"" "
                        so_nbr
                        "input so_nbr"}
                  end.
                  else do:
                     /* FIND NEXT/PREVIOUS RECORD - SO'S ONLY */
                     {mfnp05.i
                        so_mstr
                        so_fsm_type
                        "so_domain = global_domain and so_fsm_type  = ""
                        "" "
                        so_nbr
                        "input so_nbr"}
                  end.
                  if recno <> ? then do:
                     display so_nbr so_cust with frame a.

                     for first ad_mstr
                        fields (ad_domain ad_addr ad_name)
                        where  ad_domain = global_domain
                        and    ad_addr = so_cust
                     no-lock:
                        display ad_name with frame a.
                     end.

                     calc_fr = so_fr_list <> "".
                  end.
               end.
               else do:
                  readkey.
                  apply lastkey.
               end.

            end.
         end. /* IF C-APPLICATION-MODE <> "API" */
         else
            assign
               {mfaiset.i eff_date ttSoShipHdr.ed_eff_date}
               {mfaiset.i fill_all ttSoShipHdr.ed_fill_all}
               {mfaiset.i fill_pick ttSoShipHdr.ed_fill_pick}
               {mfaiset.i ship_site ttSoShipHdr.ed_so_site}.

         {&SOSOISM-P-TAG15}
         assign
            eff_date
            fill_all
            fill_pick
            ship_site
            oldcurr = "".
         if eff_date = ? then eff_date = today.

         old_ft_type = "".

         if c-application-mode <> "API" then
            find so_mstr
               using so_nbr
               where so_domain = global_domain
            exclusive-lock no-error no-wait.
         else
            for first so_mstr where
               so_domain = global_domain and
               so_nbr = ttSoShipHdr.nbr exclusive-lock:
            end.
         if locked so_mstr then do:
            /* SALES ORDER BEING MODIFIED, PLEASE WAIT */
            {pxmsg.i &MSGNUM=666 &ERRORLEVEL=2}
            if c-application-mode <> "API" then
               pause 5.
            undo,retry.
         end.

         if not available so_mstr then do:
            {pxmsg.i &MSGNUM=609 &ERRORLEVEL=3}
            /* Sales order does not exist */
            next-prompt so_nbr with frame a.
            undo, retry.
         end.

         if so_conf_date = ? then do:
            {pxmsg.i &MSGNUM=621 &ERRORLEVEL=2}
            /* warning: Sales Order not confirmed */
         end.

         /* IF THIS IS AN RMA AND WE ARE SALES ORDER ONLY MODE, ERROR */
         if (can-find(rma_mstr
            where rma_domain = global_domain
            and   rma_nbr    = so_nbr
            and   rma_prefix = prefix))
         then do:
            if  sorec = fssoship  then do:
               /* CANNOT PROCESS IF ONLY SALES ORDERS */
               {pxmsg.i &MSGNUM=7190 &ERRORLEVEL=3}
               undo, retry.
            end.
         end.
         else

         if  sorec = fsrmaship  or
             sorec = fsrmaall   or
             sorec = fsrmarec
         then do:
            /* This is not an RMA */
            {pxmsg.i &MSGNUM=7191 &ERRORLEVEL=3}
            undo, retry.
         end.

         run p_err_msg ( input so_fsm_type, input so_secondary,
                         output err_check ).
         if err_check then
            undo, retry.

         for first sod_det
            fields (sod_domain sod_bo_chg sod_btb_type sod_confirm
                    sod_fsm_type sod_line sod_loc sod_nbr
                    sod_part sod_qty_all sod_qty_chg
                    sod_qty_ord sod_qty_ship sod_rma_type
                    sod_serial sod_site sod_taxc)
             where  sod_domain = global_domain
             and   (sod_nbr = so_nbr
             and   (sod_btb_type = "02" or sod_btb_type = "03") )
         no-lock: end.

         if available sod_det then do:
            /* BTB ORDERS ARE NOT ALLOWED IN THIS TRANSACTION */
            {pxmsg.i &MSGNUM=2822 &ERRORLEVEL=3}
            undo, retry.
         end.

         /* Determine if this order will be processed with a credit card
          * and validate that the credit card info is valid and that the
          * authorized amount is enough to process the order.  Issue
          * warning if an error occurs */
         {gprunp.i "soccval" "p" "preValidateCCProcessing"
            "(input so_nbr, output errorNbr)"}
         if errorNbr <> 0 then do:
            {pxmsg.i &MSGNUM=errorNbr &ERRORLEVEL=2}
            if c-application-mode <> "API" then do:
               if not batchrun then pause.
            end.
         end.

         /* FIND EXCH RATE IF CURRENCY NOT BASE */

         if not so_fix_rate then do:

            /* Create usage records for posting; delete later. */
            {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                      "(input  so_curr,
                        input  base_curr,
                        input  so_ex_ratetype,
                        input  eff_date,
                        output exch_rate,
                        output exch_rate2,
                        output exch_exru_seq,
                        output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               undo, retry.
            end.

         end.
         else
            assign
               exch_rate     = so_ex_rate
               exch_rate2    = so_ex_rate2
               exch_exru_seq = so_exru_seq.

         if (oldcurr <> so_curr) or (oldcurr = "")
         then do:

            /** GET ROUNDING METHOD FROM CURRENCY MASTER **/
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                      "(input so_curr,
                        output rndmthd,
                        output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               undo, retry.
            end. /* if mc-error-number <> 0 */

            {socurfmt.i}
            oldcurr = so_curr.
         end. /* IF OLDCURR <> SO_CURR */
         {&SOSOISM-P-TAG2}

         for first ad_mstr
            fields (ad_domain ad_addr ad_name)
            where   ad_domain = global_domain
            and     ad_addr = so_cust
         no-lock: end.

         if c-application-mode <> "API" then
            display
               so_cust
               ad_name
            with frame a.

         calc_fr = so_fr_list <> "".

         for first ft_mstr
            fields (ft_domain ft_terms ft_type)
            where   ft_domain = global_domain
            and     ft_terms = so_fr_terms
         no-lock:
            old_ft_type = ft_type.
         end.

         /* Check to see if batch update exists */
         run check-batch.

         if available qad_wkfl and
            not batch_review then undo, retry.

         if so_stat <> "" then do:
            /* SALES ORDER STATUS NOT BLANK */
            {pxmsg.i &MSGNUM=623 &ERRORLEVEL=2}
         end.

         run find-cm-mstr
            (input so_bill,
             input so_invoiced).

         /* Determine the ship-from domain */
         if ship_site = "" then do:

            /* Take the domain from the first line */
            for first sod_det
               fields (sod_domain sod_bo_chg sod_btb_type sod_confirm
                       sod_fsm_type sod_line sod_loc sod_nbr
                       sod_part sod_qty_all sod_qty_chg
                       sod_qty_ord sod_qty_ship sod_rma_type
                       sod_serial sod_site sod_taxc)
                where  sod_det.sod_domain = global_domain
                and    sod_nbr = so_nbr
            no-lock: end.

            for first si_mstr
               fields (si_domain si_db si_entity si_site)
               where   si_domain = global_domain
               and     si_site = sod_site
            no-lock: end.

            if not available si_mstr then
               ship_db = global_db.
            else do:

               ship_db = si_db.

               /* Check to see if SO affects other domain */
               /* (If so, the user must pick one)            */
               for each sod_det
                  fields (sod_domain sod_bo_chg sod_btb_type sod_confirm
                          sod_fsm_type sod_line sod_loc sod_nbr
                          sod_part sod_qty_all sod_qty_chg
                          sod_qty_ord sod_qty_ship sod_rma_type
                          sod_serial sod_site sod_taxc)
                  where   sod_domain = global_domain
                  and     sod_nbr = so_nbr
                  and     sod_site <> si_site
                  and     sod_confirm
               no-lock:

                  for first si_mstr
                     fields (si_domain si_db si_entity si_site)
                     where   si_domain = global_domain
                     and     si_site = sod_site
                  no-lock: end.

                  if available si_mstr and si_db <> ship_db then do:
                     {pxmsg.i &MSGNUM=6252 &ERRORLEVEL=4}
                     /* SO spans domains, site must be specified */
                     display si_site @ ship_site with frame a.
                     undo mainloop, retry.
                  end.

               end.  /* FOR EACH SOD_DET */

            end.   /* ELSE DO - IF NOT AVAIL SI_MSTR */

            ship_entity = "".

            /* PERFORM GL CALENDER VALIDATION WHEN ship_site IS BLANK
             * AND "Ship Allocated" OR "Ship Picked" IS YES. */

            /* PROCESS SHIPMENT FROM THE CIM FILE ONLY               */
            /* DURING BATCHRUN OF SALES ORDER SHIPMENTS AND WHEN THE */
            /* FLAG 'Ship One Line During CIM' IS SET TO YES IN      */
            /* WAREHOUSE CONTROL FILE                                */

            if fill_all
            or fill_pick
            then do:

               l_old_entity = "".

               for each sod_det no-lock
                  where sod_domain = global_domain
                  and   sod_nbr = so_nbr
                  and   sod_confirm
               break by sod_site:

                  if first-of(sod_site) then do:

                     for first si_mstr
                        fields (si_domain si_db si_entity si_site)
                        where   si_domain = global_domain
                        and     si_site = sod_site
                     no-lock: end.

                     if l_old_entity <> si_entity then do:
                        l_old_entity = si_entity.

                        {gpglef3.i &from_db = so_db
                           &to_db   = si_db
                           &module  = ""IC""
                           &entity  = si_entity
                           &date    = eff_date
                           &prompt  = "eff_date"
                           &frame   = "a"
                           &loop    = "mainloop"}
                     end. /* IF L_OLD_ENTITY <> SI_ENTITY */

                  end. /* IF FIRST-OF(SOD_SITE) */

               end. /* FOR EACH sod_det */

            end. /* IF INPUT FILL_ALL = YES OR INPUT FILL_PICK = YES */

         end.  /* IF SHIP-SITE = "" */

         else do:

            for first si_mstr
               fields (si_domain si_db si_entity si_site)
                where  si_domain = global_domain and  si_site = ship_site
            no-lock: end.

            if not available si_mstr then do:
               {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}  /* Site does not exist */
               next-prompt ship_site with frame a.
               undo, retry.
            end.

            assign
               ship_db     = si_db
               ship_entity = si_entity.
         end.

         if ship_site <> ""
            and available si_mstr
         then do:

            l_undo = no.

            run find-soddet
               (input so_nbr,
                input ship_site,
                output l_undo).

            if l_undo and batchrun then
               undo upperloop, leave upperloop.
            else if l_undo then do:
               next-prompt ship_site with frame a.
               undo, retry.
            end.

            {gprun.i ""gpsiver.p""
                     "(input si_site,
                       input recid(si_mstr),
                       output return_int)"}

            if return_int = 0 then do:
               {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
               /* USER DOES NOT HAVE ACCESS TO THIS SITE */
               next-prompt ship_site with frame a.
               undo, retry.
            end.

         end.

         if global_db <> ship_db then do:
            /* MAKE SURE SHIP-FROM DOMAIN IS CONNECTED */
            {gprunp.i "mgdompl" "p" "ppDomainConnect"
                      "(input  ship_db,
                        output lv_error_num,
                        output lv_name)"}

            if lv_error_num <> 0 then do:
               /* DOMAIN # IS NOT AVAILABLE */
               {pxmsg.i &MSGNUM=lv_error_num &ERRORLEVEL=3 &MSGARG1=lv_name}
               next-prompt ship_site with frame a.
               undo mainloop, retry.
            end.
         end. /* if global_db <> ship_db then do: */

         /* VALIDATE OPEN GL PERIOD FOR SPECIFIED ENTITY AND
          * DOMAIN. WE ONLY NEED TO DO THIS IF THE SITE FIELD
          * WAS ENTERED, BECAUSE OTHERWISE WE DON'T KNOW WHICH
          * ENTITY TO VALIDATE YET. THIS IS OK BECAUSE THE LINE
          * ITEMS WILL ALSO BE VALIDATED. */

         if ship_entity <> "" then do:

            /* VALIDATE GL PERIOD FOR SPECIFIED ENTITY/DOMAIN */
            {gpglef3.i &from_db = so_db
               &to_db   = ship_db
               &module  = ""IC""
               &entity  = ship_entity
               &date    = eff_date
               &prompt  = "eff_date"
               &frame   = "a"
               &loop    = "mainloop"}

         end. /* IF SHIP_ENTITY <> "" */

         /* FREIGHT LIST, MIN SHIP WEIGHT & FREIGHT TERMS PARAMETERS */
         if calc_fr then do:

            if so_fr_list <> "" then do:

               for first fr_mstr
                  fields (fr_domain fr_curr fr_list fr_site fr_um)
                  where   fr_domain = global_domain
                  and     fr_list   = so_fr_list
                  and     fr_site   = so_site
                  and     fr_curr   = so_curr
               no-lock: end.

               if not available fr_mstr then
               for first fr_mstr
                  fields (fr_domain fr_curr fr_list fr_site fr_um)
                  where   fr_domain = global_domain
                  and     fr_list   = so_fr_list
                  and     fr_site   = so_site
                  and     fr_curr   = base_curr
               no-lock: end.

               disp_fr = yes.
               if c-application-mode <> "API" then
                  display
                     so_fr_list
                     so_fr_min_wt
                     so_fr_terms
                     calc_fr
                     disp_fr
                  with frame d.

            end.

            assign
               old_fr_terms = so_fr_terms
               old_um = "".

            if available fr_mstr then do:
               if c-application-mode <> "API" then
                  display fr_um with frame d.
               old_um = fr_um.
            end.

            set_d:
            do on error undo, retry:

               if c-application-mode = "API" and retry
                  then return error return-value.


               if c-application-mode <> "API" then
                  set so_fr_min_wt so_fr_terms calc_fr disp_fr with frame d.
               else
                  assign
                     {mfaiset.i
                        so_fr_min_wt ttSoShipHdr.ed_fr_min_wt}
                     {mfaiset.i
                        so_fr_terms ttSoShipHdr.ed_fr_terms}
                     {mfaiset.i
                        calc_fr ttSoShipHdr.ed_calc_fr}
                     {mfaiset.i
                        disp_fr ttSoShipHdr.ed_disp_fr}.

               if so_fr_list <> "" or (so_fr_list = "" and calc_fr)
               then do:

                  for first fr_mstr
                     fields (fr_domain fr_curr fr_list fr_site fr_um)
                     where   fr_domain = global_domain
                     and     fr_list   = so_fr_list
                     and     fr_site   = so_site
                     and     fr_curr   = so_curr
                  no-lock: end.

                  if not available fr_mstr then
                  for first fr_mstr
                     fields (fr_domain fr_curr fr_list fr_site fr_um)
                     where   fr_domain = global_domain
                     and     fr_list   = so_fr_list
                     and     fr_site   = so_site
                     and     fr_curr = base_curr
                  no-lock: end.

                  if not available fr_mstr then do:
                     /* WARN: FREIGHT LIST # NOT FOUND FOR SITE # CURRENCY */
                     {pxmsg.i &MSGNUM=670 &ERRORLEVEL=2
                              &MSGARG1=so_fr_list
                              &MSGARG2=so_site
                              &MSGARG3=so_curr}
                     /* Lines may be ok. No lines added, so no default.*/
                     if c-application-mode <> "API" then do:
                        if not batchrun then pause.
                     end.
                  end.

                  if c-application-mode <> "API" then
                     display fr_um with frame d.

                  if old_um <> fr_um then do:
                     {pxmsg.i &MSGNUM=675 &ERRORLEVEL=2}
                     /* WARNING: UNIT OF MEASURE HAS CHANGED */
                     if c-application-mode <> "API" then do:
                        if not batchrun then pause.
                     end.
                  end.

               end.

               if so_fr_terms <> "" or (so_fr_terms = "" and calc_fr)
               then do:

                  for first ft_mstr
                     fields (ft_domain ft_terms ft_type ft_lc_charge
                             ft_accrual_level)
                     where   ft_domain = global_domain
                     and     ft_terms  = so_fr_terms
                  no-lock: end.

                  if not available ft_mstr then do:
                     /* INVALID FREIGHT TERMS */
                     {pxmsg.i &MSGNUM=671 &ERRORLEVEL=3 &MSGARG1=so_fr_terms}
                     next-prompt so_fr_terms with frame d.
                     undo set_d, retry.
                  end.

               end.

               /* IF LOGISTICS ACCOUNTING IS ENABLED */
               if so_fr_terms <> old_fr_terms and use-log-acctg then do:
                  order-on-shipper = no.

                  /* CHECK IF ORDER ATTACHED TO AN UNCONFIRMED SHIPPER */
                  {gprunmo.i  &module = "LA" &program = "larcsh02.p"
                              &param  = """(input so_nbr,
                                            output l_parent_abs_id,
                                            output order-on-shipper)"""}

                  if order-on-shipper then do:
                     /* FREIGHT TERMS CANNOT BE CHANGED. ORDER ON SHIPPER # */
                     {pxmsg.i &MSGNUM = 5373 &ERRORLEVEL = 3
                              &MSGARG1 = substring(l_parent_abs_id,2)}
                     next-prompt so_fr_terms with frame d.
                     undo set_d, retry.
                  end.
                  else do:
                     if so_fr_terms = "" then do:

                        tax_type = "41".
                        if so_fsm_type = "RMA" then
                           tax_type = "46".

                        /* DELETE ALL LOGISTICS ACCTG tx2d_det RECORDS FOR SO */
                        {gprunmo.i &module = "LA" &program = "lataxdel.p"
                                   &param  = """(input tax_type,
                                                 input so_nbr,
                                                 input 0)"""}

                        /* DELETE LOGISTICS ACCTG CHARGE DETAIL */
                        {gprunmo.i  &module = "LA" &program = "laosupp.p"
                                    &param  = """(input 'DELETE',
                                                  input '{&TYPE_SO}',
                                                  input so_nbr,
                                                  input ' ',
                                                  input ' ',
                                                  input ' ',
                                                  input no,
                                                  input no)"""}
                     end.
                     else do:
                        /* UPDATE LOGISTICS ACCTG CHARGE DETAIL */
                        {gprunmo.i  &module = "LA" &program = "laosupp.p"
                                    &param  = """(input 'MODIFY',
                                                  input '{&TYPE_SO}',
                                                  input so_nbr,
                                                  input ' ',
                                                  input ft_lc_charge,
                                                  input ft_accrual_level,
                                                  input no,
                                                  input no)"""}
                    end.
                  end.   /* else (not on shipper) */
               end.   /* if so_fr_terms <> old_fr_terms */

               if c-application-mode <> "API" then
                  hide frame d no-pause.

            end.
         end.

         ship_so = so_nbr.

         /* Update batch shipment information if batch in use */
         /* (unless an existing batch job is already queued)  */
         run update-batch.

      end.  /* SO number input transaction */

      do transaction:
         if c-application-mode = "API" and retry
            then undo MAINLOOP, leave MAINLOOP.
         /* Switch domains to get next trlot based on remote */
         /* Work order master for shipping transaction if necessary */
         change_db = (ship_db <> global_db).
         if change_db then do:
            {gprun.i ""gpalias3.p"" "(input ship_db, output err-flag)"}

            run check-db-connect (input ship_db, output db_undo).

            if db_undo then
               undo mainloop, retry mainloop.

            /* RETRIEVE FAC CONTROL FILE SETTINGS FROM REMOTE DOMAIN */
            {gprun.i ""sofactrl.p"" "(output fas_so_rec)"}

         end.

         {gprun.i ""gpnxtsq.p"" "(output trlot)"}

         if change_db then do:
            {gprun.i ""gpalias3.p"" "(input so_db, output err-flag)"}

            run check-db-connect (input so_db, output db_undo).

            if db_undo then
               undo mainloop, retry mainloop.
         end.
      end.

      /* INITIALIZE TEMP FREIGHT ACCRUAL TEMP-TABLE */
      for each tt-frcalc exclusive-lock:
          delete tt-frcalc.
      end.

      if not batch_review then do:

         for each sr_wkfl
            where sr_domain = global_domain
            and   sr_userid = mfguser
         exclusive-lock:
            delete sr_wkfl.
         end.

         if can-find(first lotw_wkfl
            where lotw_domain = global_domain
            and   lotw_mfguser = mfguser)
         then do:
            for each lotw_wkfl
               where lotw_domain  = global_domain
               and   lotw_mfguser = mfguser
            exclusive-lock:
               delete lotw_wkfl.
            end. /* FOR EACH lotw_wkfl  */
         end. /* IF CAN-FIND(lotw_wkfl) */

      end. /* IF NOT batch_review */


      /* Switch domains to find allocations if necessary */
      change_db = (ship_db <> global_db).
      if change_db then do:
         {gprun.i ""gpalias3.p"" "(input ship_db, output err-flag)"}

         run check-db-connect (input ship_db, output db_undo).

         if db_undo then
            undo mainloop, retry mainloop.

         {gprun.i ""sosoiss3.p""} /* Delete sr_wkfl in remote db */

         {gprun.i ""gpalias3.p"" "(input so_db, output err-flag)"}

         run check-db-connect (input so_db, output db_undo).

         if db_undo then
            undo mainloop, retry mainloop.
      end.

      /* CHECK FOR EXISTING ALLOCATIONS AND RESET BACKORDER CHANGE QUANTITY */
      /* (Get all lines to reset the change quantities) */
      if not batch_review then
      for each sod_det
         where sod_domain = global_domain
         and   sod_nbr    = so_nbr
      exclusive-lock
         break by sod_site
               by sod_loc
               by sod_serial
               by sod_part:

         assign
            sod_qty_chg = 0
            sod_bo_chg  = 0.

         if first-of(sod_part) then
            accum_qty_all = 0.

         if not (sod_site = ship_site or ship_site = "") then next.

         /* Consider skipping this record based on something */
         if    (sorec = fsrmarec    and sod_rma_type  <> "I")
            or (sorec = fsrmaship   and sod_rma_type  <> "O")
            or (sorec = fssormaship and sod_rma_type  =  "I")
            or (sorec = fssoship    and sod_fsm_type  <> "")
         then
            next.

         ship_line = sod_line.

         /* Check for allocations if shipping based on allocations */
         {&SOSOISM-P-TAG3}
         if fill_all
         or fill_pick
         then do:
            {&SOSOISM-P-TAG4}

            if using_cust_consignment
               and sod_consignment
            then do:
               /* CREATE CONSIGNMENT TEMP-TABLE RECORD */
               {gprunmo.i &module  = "ACN"
                          &program = "socnship.p"
                          &param   = """(input  sod_nbr,
                                         input  sod_line,
                                         input  sod_site,
                                         input  sod_loc,
                                         input  sod_part,
                                         input  sod_serial,
                                         input  ' ',
                                         input  sod_qty_chg,
                                         output ok_to_ship,
                                         input-output table
                                            tt_consign_shipment_detail)"""}

               if not ok_to_ship
               then do:
                  pause.   /* TO SEE ERROR MESSAGE FROM socnship.p */
                  undo mainloop, retry mainloop.
               end.

            end.  /* if using_cust_consignment */

            accum_qty_all = accum_qty_all + sod_qty_all.

            qty_chg = 0.

            {gprun.i ""gpalias3.p"" "(input ship_db, output err-flag)"}

            run check-db-connect
               (input ship_db, output db_undo).

            if db_undo then
               undo mainloop, retry mainloop.

            {&SOSOISM-P-TAG5}
            {gprun.i ""sosoisu1.p""}
            {&SOSOISM-P-TAG6}

            {gprun.i ""gpalias3.p"" "(input so_db, output err-flag)"}

            run check-db-connect
               (input so_db, output db_undo).

            if db_undo then
               undo mainloop, retry mainloop.

            if change_db then
               sod_qty_chg = qty_chg.

         end.   /* IF fill_all */

         if (sod_fsm_type = "RMA-RCT"
            and sod_qty_ord  < 0 )
         then
            sod_bo_chg = sod_qty_ord - sod_qty_ship + sod_qty_chg.
         else
            sod_bo_chg = if sod_qty_ord >= 0 then
                            max((sod_qty_ord - sod_qty_ship - sod_qty_chg),0)
                         else
                            min((sod_qty_ord - sod_qty_ship - sod_qty_chg),0).

      end.  /*for each sod_det*/

      if change_db then do:
         {gprun.i ""gpalias3.p"" "(input so_db, output err-flag)"}

         run check-db-connect (input so_db, output db_undo).

         if db_undo then
            undo mainloop, retry mainloop.
      end.

      assign
         so_mstr_recid = recid(so_mstr)
         undo-select   = true.

      release sod_det.

      run p-sel-line-qty.

      if undo-select and batchrun then
         undo upperloop, leave upperloop.
      else if undo-select then
         undo mainloop, retry mainloop.

      undo-all = yes.

      /* REVERSE SIGNS FOR TRAILER IF WE ARE IN FSRMAREC MODE */
      if sorec = fsrmarec then do:
         undo-select = false.
         {gprun.i ""sosoiss4.p""}
         if undo-select then
            undo mainloop, retry mainloop.
      end. /* IF sorec = false THEN DO */

      lv_accrue_freight = no.
      /* IF LOGISTICS ACCOUNTING IS ENABLED AND VALID FREIGHT TERMS/LIST IS   */
      /* ENTERED DISPLAY THE LOGISTICS CHARGE DETAIL FRAME WHICH DISPLAYS THE */
      /* LOGISTICS SUPPLIER FOR THIS ORDER STORED IN THE lacd_det.            */
      /* IF THE USER CHANGES THIS SUPPLIER IT WILL NOT BE UPDATED IN lacd_det */
      /* RECORD, IT WILL BE HOWEVER BE STORED IN THE PENDING VOUCHER RECORD   */
      /* CREATED FOR VOUCHERING THIS ACCRUAL.                                 */
      if use-log-acctg
         and so_fr_terms <> ""
         and (can-find(first sod_det
         where sod_domain = global_domain
         and   sod_nbr = so_nbr
         and   sod_fr_list <> ""))
      then do transaction on error undo, retry:

         for first ft_mstr
            fields (ft_domain ft_lc_charge ft_accrual_level)
            where   ft_domain = global_domain
            and     ft_terms = so_fr_terms
          no-lock:
            if ft_accrual_level = {&LEVEL_Shipment}
               or ft_accrual_level = {&LEVEL_Line}
            then do:

               assign
                  lv_accrue_freight = yes
                  lv_shipfrom = "".

               for first sod_det
                  fields (sod_domain sod_nbr sod_site)
                  where   sod_domain = global_domain
                  and     sod_nbr = so_nbr
                no-lock:
                  lv_shipfrom = sod_site.
               end.

               if ft_accrual_level = {&LEVEL_Shipment}
                  and so_site <> ""
               then
                  lv_shipfrom = so_site.

               /* DISPLAY LOGISTICS CHARGE DETAIL */
               {gprunmo.i  &module = "LA" &program = "laosupp.p"
                           &param  = """(input 'ADD',
                                         input '{&TYPE_SO}',
                                         input so_nbr,
                                         input lv_shipfrom,
                                         input ft_lc_charge,
                                         input ft_accrual_level,
                                         input if not batchrun
                                               then
                                                  yes
                                               else
                                                  no,
                                         input no)"""}

               /* GET THE SO SHIPMENT SEQUENCE ID DEFINED IN LOGISTICS     */
               /* ACCOUNTING CONTROL FILE.                                 */
               lv_nrm_seqid = "".
               for first lac_ctrl
                   where lac_domain = global_domain
               no-lock:
                  lv_nrm_seqid = lac_soship_nrm_id.
               end.

               lv_undo_flag = true.

               /* ENTER SHIPMENT-ID FOR DISCRETE SHIPMENTS */
               {gprunmo.i  &module = "LA" &program = "lalgship.p"
                           &param  = """(input lv_nrm_seqid,
                                         output lv_shipment_id,
                                         input-output lv_undo_flag)"""}

               if lv_undo_flag and batchrun then
                  undo upperloop, leave upperloop.
               else if lv_undo_flag then
                  undo mainloop, retry mainloop.
            end. /* IF FT_ACCRUAL_LEVEL ... */
         end. /* FOR FIRST FT_MSTR ... */
      end.   /* TRANSACTION */

      /* CALCULATE FREIGHT */
      if calc_fr
         and so_fr_terms <> ""
      then do transaction:

         so_mstr_recid = recid(so_mstr).

         /* FREIGHT CHARGE AND WEIGHT CALC FOR SHIPMENTS */
         {gprun.i ""sofrcals.p""
                  "(input table tt_sod_det,
                    input ' ')"}

         for each tt_sod_det
         exclusive-lock:
            delete tt_sod_det.
         end.

      end.   /* TRANSACTION */

      /* Make sure the alias is pointed back to the central db */
      if change_db then do:
         {gprun.i ""gpalias3.p"" "(input so_db, output err-flag)"}

         run check-db-connect (input so_db, output db_undo).

         if db_undo then
            undo mainloop, retry mainloop.
      end.

      /* TRAILER DATA INPUT */
      {gprun.i ""sosoisc.p""
               "(output l_recalc,
                 input-output table tt_consign_shipment_detail)"}

      if undo-all then do:

         for each sr_wkfl
            where sr_domain = global_domain
            and   sr_userid = mfguser
         exclusive-lock:
            delete sr_wkfl.
         end.

         for each sod_det
            where sod_domain = global_domain
            and   sod_nbr = so_nbr
         exclusive-lock:
            assign
               sod_qty_chg = 0
               sod_bo_chg  = 0.
         end.

         next.
      end. /* IF undo-all THEN */

      /* Determine if this order will be processed with a credit card
       * and validate that the credit card info is valid and that the
       * authorized amount is enough to process the order.  Issue
       * warning if an error occurs and "remember" the order number
       * so that at the end of shipment we can put the order on hold. */
      {gprunp.i "soccval" "p" "postValidateCCProcessing"
                "(input so_nbr,
                  input ord_amt,
                  output errorNbr)"}

      if errorNbr <> 0 then do:
         {pxmsg.i &MSGNUM=errorNbr &ERRORLEVEL=2}
         {pxmsg.i &MSGNUM=3468 &ERRORLEVEL=2} /*ORDER PLACED ON HOLD*/
         if not batchrun then
           pause.
         /* Mark the sales order to put on hold. */
         vSOToHold = so_nbr.
      end. /*If errorNbr <> 0 then do:*/

      {gpdelp.i "soccval" "p"} /*Delete persistent procedure*/

      /* If batch update, create batch record */
      if batch_update then do transaction:
         run create-batch.

         if use-log-acctg
            and lv_accrue_freight
         then
            run storeFreightDetailsInQadWkfl
               (input l_batch_mfguser,
                input lv_shipment_id).

         if using_cust_consignment then
            run storeShipmentInQadWkfl
               (input l_batch_mfguser).

      end.  /* Batch record creation */
      else do:

         /* PROCESS SHIPMENTS ENTERED */
         so_mstr_recid = recid(so_mstr).

         run p-post-freight-accrual.

         /* Delete exchange rate usage if not attached to SO */
         if exch_exru_seq <> so_exru_seq then
            run delete-ex-rate-usage
               (input exch_exru_seq).

         if undo-select then
            undo mainloop, retry mainloop.

         /* RECALCULATE SALES ORDER TAX DETAILS (TYPE 11) */
         run p-recalc-so-tax-det.

         /* Delete sr_wkfl in the shipping domain */
         {gprun.i ""gpalias3.p"" "(ship_db, output err-flag)"}

         run check-db-connect (input ship_db, output db_undo).

         if db_undo then
            undo mainloop, retry mainloop.

         {gprun.i ""sosoiss3.p""}

         /* Make sure the alias is pointed back to the central db */
         {gprun.i ""gpalias3.p"" "(so_db, output err-flag)"}

         run check-db-connect (input so_db, output db_undo).

         if db_undo then
            undo mainloop, retry mainloop.

      end.

      {&SOSOISM-P-TAG7}
      release so_mstr.

      /* RETURN SUCCESS STATUS TO API CALLER */
      if c-application-mode = "API" then return {&SUCCESS-RESULT}.

   end. /*mainloop*/

   if vSOToHold <> "" then do transaction:
      for first ccc_ctrl
         fields (ccc_domain ccc_cc_hold_status)
         where   ccc_domain = global_domain
      no-lock:
         for first so_mstr
            where so_domain = global_domain
            and   so_nbr = vSOToHold
         exclusive-lock:
            so_stat = ccc_cc_hold_status.
         end.
         vSOToHold = "".
      end.
      release so_mstr.
   end. /*If vSOToHold <> "" then do transaction:*/
   {&SOSOISM-P-TAG11}

end. /*UPPERLOOP*/

PROCEDURE check-db-connect:
   define input        parameter connect_db like dc_name     no-undo.
   define output       parameter db_undo    like mfc_logical no-undo.

   db_undo = err-flag = 2 or err-flag = 3.
   if db_undo then do:
      /* DOMAIN # IS NOT AVAILABLE */
      {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4 &MSGARG1=connect_db}
      next-prompt ship_site with frame a.
   end.

END PROCEDURE. /* check-db-connect */

PROCEDURE check-batch:

   batch_review = false.

   for first qad_wkfl
      fields (qad_domain qad_charfld qad_datefld qad_decfld qad_key1 qad_key2)
      where   qad_domain = global_domain
      and     qad_key1 = "sosois.p" + so_mstr.so_nbr
      and     qad_key2 = "BATCH"
   no-lock: end.

   if available qad_wkfl then do:

      if qad_charfld[4] <> "" then
         for first lngd_det
            fields (lngd_dataset lngd_field lngd_key1
                    lngd_lang lngd_translation)
            where   lngd_dataset = "bcd_det"
            and     lngd_field = "bcd_run_stat"
            and     lngd_key1 = qad_charfld[4]
            and     lngd_lang = global_user_lang
         no-lock: end.

      if available lngd_det and qad_charfld[4] = "3" then do:
         /* ERROR: Batch shipment already exists with status: */
         {pxmsg.i &MSGNUM=1122 &ERRORLEVEL=3 &MSGARG1=lngd_translation}
         return.
      end.
      else if available lngd_det then do:
         /* WARNING: Batch shipment already exists with status: */
         {pxmsg.i &MSGNUM=1122 &ERRORLEVEL=2 &MSGARG1=lngd_translation}
      end.
      else do:
         /* Batch shipment already exists */
         {pxmsg.i &MSGNUM=1121 &ERRORLEVEL=2}
      end.

      /* Continue? */
      {pxmsg.i &MSGNUM=2233 &ERRORLEVEL=1 &CONFIRM=batch_review}
      if not batch_review then return.

      /* Set mfguser to match batch file */
      /* Along with ship_site?           */
      assign
         btemp_mfguser = mfguser
         ship_site     = qad_charfld[2]
         ship_db       = qad_charfld[3].

      /* This procedure has been created to avoid the standard checker
       * to give an error message on the modification of the mfguser
       * variable.         */
      {gprun.i ""gpmfguse.p""
         "(input ""sosois.p"" + so_mstr.so_nbr, output mfguser)"}

      batch_review = true.

   end.  /* Batch shipment check */

END PROCEDURE. /* check-batch */

PROCEDURE update-batch:

   for first mfc_ctrl
      fields (mfc_domain mfc_char mfc_date mfc_decimal mfc_field
              mfc_integer mfc_logical mfc_type)
      where   mfc_domain = global_domain
      and     mfc_field = "soc_is_batch"
   no-lock: end.

   if available mfc_ctrl
      and mfc_logical = yes
      and not (available qad_wkfl
      and qad_wkfl.qad_charfld[4] = "")
   then
      bat_loop:
      do with frame batr_up on error undo, return error
                            on endkey undo, return error:
        if c-application-mode = "API" and retry
           then return error return-value.

         if c-application-mode <> "API" then
            update batch_update.
         else
            {mfaiset.i batch_update ttSoShipHdr.ed_batch_upd}.

         if batch_update
         then do with frame batr_up:

            if c-application-mode <> "API" then
               update dev batch_id.
            else
              assign
                 {mfaiset.i dev ttSoShipHdr.ed_device}
                 {mfaiset.i batch_id ttSoShipHdr.ed_batch_id}.


            if dev = "" then do:
               {pxmsg.i &MSGNUM=2235 &ERRORLEVEL=3}
               next-prompt dev.
               undo bat_loop, retry.
            end.

            if batch_id = ""
               or not can-find(bc_mstr
               where bc_domain = global_domain
               and   bc_batch = batch_id)
            then do:
               {pxmsg.i &MSGNUM=67 &ERRORLEVEL=3}
               /* Batch control record does not exist */
               next-prompt batch_id.
               undo bat_loop, retry.
            end.

            if (dev = "terminal"
               or dev = "/dev/tty"
               or dev = "tt:")
            then do:
               /* Output to terminal not allowed for batch request */
               {pxmsg.i &MSGNUM=66 &ERRORLEVEL=3}
               next-prompt dev.
               undo bat_loop, retry.
            end.
         end.   /* IF batch_update */

         /* Assign a unique userid for the shipping workfile */
         assign
            btemp_mfguser = mfguser.

         /* This procedure has been created to avoid the standard checker
          * to give an error message on the modification of the mfguser
          * variable.         */
         {gprun.i ""gpmfguse.p""
                  "(input ""sosois.p"" + so_mstr.so_nbr,
                    output mfguser)"}

         if c-application-mode <> "API" then
         hide frame batr_up.

      end.   /* batloop */
END PROCEDURE. /* update-batch */

PROCEDURE create-batch:

   /* No need to create batch if it is already queued normally */
   if not (available qad_wkfl and
      qad_wkfl.qad_charfld[4] = "") then do:

      /* Reset the status for a failed batch */
      if available qad_wkfl then qad_charfld[4] = "".

      bcdparm = "".
      {mfquoter.i so_mstr.so_nbr}
      {mfquoter.i eff_date}
      {mfquoter.i ship_site}
      {mfquoter.i ship_db}

      for first bc_mstr
         fields (bc_domain bc_batch bc_priority)
         where   bc_domain = global_domain
         and     bc_batch = batch_id
      no-lock: end.

      create bcd_det.
      assign
         bcd_domain = global_domain
         bcd_batch    = batch_id
         bcd_priority = bc_priority
         bcd_date_sub = today
         bcd_time_sub = string(time,"HH:MM:SS")
         bcd_perm     = false
         bcd_userid   = global_userid
         bcd_exec     = "soisbt.p"
         bcd_dev      = dev
         bcd_parm     = bcdparm
         bcd_process  = yes.

      /* Request queued for batch processing */
      {pxmsg.i &MSGNUM=64 &ERRORLEVEL=1}

      /* Create qad_wkfl rec for quick identification of batch */
      find qad_wkfl
         where qad_domain = global_domain
         and   qad_key1   = mfguser
         and   qad_key2   = "BATCH"
      exclusive-lock no-error.

      /* If the record doesn't exist, create it.*/
      if not available qad_wkfl then do:
         create qad_wkfl.
         qad_domain = global_domain.
         assign
            qad_key1 = mfguser
            qad_key2 = "BATCH"
            qad_charfld[1] = so_nbr
            qad_datefld[1] = eff_date
            qad_charfld[2] = ship_site
            qad_charfld[3] = ship_db
            qad_charfld[5] = string(l_recalc, "yes/no")
            qad_decfld[1]  = gl_amt.  /* freight charge */
         if qad_charfld[2] = ? then qad_charfld[2] = "".
      end.

   end. /* IF NOT AVAILABLE QAD_WKFL AND .... */

   else do: /* AVAILABLE QAD_WKFL AND QAD_CHARFLD[4] = "" */

      /* UPDATE THE FREIGHT IN CASE WE CHANGE THE SHIPMENT QTY AND  */
      /* THEREFORE THE FREIGHT AFTER IT WAS QUEUED.                 */
      find qad_wkfl
         where qad_domain = global_domain
         and   qad_key1   = mfguser
         and   qad_key2 = "BATCH"
      exclusive-lock no-error.
      if available qad_wkfl then
         qad_decfld[1]  = gl_amt.  /* freight charge */

   end. /* AVAILABLE QAD_WKFL AND QAD_CHARFLD[4] = "" */

   /* SAVE MFGUSER USED FOR QAD_WKFL BEFORE RESET */
   l_batch_mfguser =  mfguser.

   /* Reset mfguser to original setting */
   /* This procedure has been created to avoid the standard checker
    * to give an error message on the modification of the mfguser
    * variable.         */
   {gprun.i ""gpmfguse.p"" "(input btemp_mfguser, output mfguser)"}

END PROCEDURE.  /* create-batch */

PROCEDURE find-mfcctrl:

   for first mfc_ctrl
      fields (mfc_domain mfc_char mfc_date mfc_decimal mfc_field
              mfc_integer mfc_logical mfc_type)
      where   mfc_domain = global_domain
      and     mfc_field = "soc_is_batch"
   no-lock: end.

   if available mfc_ctrl then do:
      assign
         batch_mfc    = true
         batch_update = mfc_logical.

      for first mfc_ctrl
         fields (mfc_domain mfc_char mfc_date mfc_decimal mfc_field
                 mfc_integer mfc_logical mfc_type)
         where   mfc_domain = global_domain
         and     mfc_field  = "soc_is_dev"
      no-lock:
         dev = mfc_char.
      end.

      for first mfc_ctrl
         fields (mfc_domain mfc_char mfc_date mfc_decimal mfc_field
                 mfc_integer mfc_logical mfc_type)
         where   mfc_domain = global_domain
         and     mfc_field  = "soc_is_batid"
      no-lock:
         batch_id = mfc_char.
      end.

   end. /* IF AVAILABLE MFC_CTRL */

END PROCEDURE.

PROCEDURE find-cm-mstr:
   define input parameter inpar_bill like so_bill.
   define input parameter inpar_inv  like so_invoiced.

   for first cm_mstr
      fields (cm_domain cm_addr cm_cr_hold)
       where  cm_domain = global_domain
       and    cm_addr = inpar_bill
   no-lock: end.

   if cm_cr_hold then do:
      /* warning: Customer on credit hold */
      {pxmsg.i &MSGNUM=614 &ERRORLEVEL=2}
      if c-application-mode <> "API" then do:
         if not batchrun then pause.
      end.
   end.

   if inpar_inv then do:
      /* Invoice printed but not posted */
      {pxmsg.i &MSGNUM=603 &ERRORLEVEL=2}
      if c-application-mode <> "API" then do:
         if not batchrun then pause.
      end.
   end.

END PROCEDURE.

PROCEDURE p_find_mfc:

   find mfc_ctrl
      where mfc_domain = global_domain
      and   mfc_field = "fas_so_rec"
   exclusive-lock no-error.

   if available mfc_ctrl then do:
      find first fac_ctrl
         where fac_domain = global_domain
      exclusive-lock no-error.
      if available fac_ctrl then do:
         fac_so_rec = mfc_logical.
         delete mfc_ctrl.
      end.
      release fac_ctrl.

   end.

END PROCEDURE.

PROCEDURE delete-ex-rate-usage:
   define input parameter i_exru_seq like so_exru_seq no-undo.

   {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                    "(input i_exru_seq)"}

END PROCEDURE.  /* delete-ex-rate-usage */

PROCEDURE p_err_msg:
   define input  parameter fsmtype  like so_fsm_type no-undo.
   define input  parameter sosecond like so_secondary no-undo.
   define output parameter err_chk  like mfc_logical  no-undo.

   /* DO NOT LET USERS SHIP MO'S OR CALL ACTIVITY */
   /* RECORDING ORDERS IN SOSOIS.P... */
   if fsmtype = "SEO" then do:
      err_chk = yes.
      /* MATERIAL ORDERS ARE NOT SHIPPED HERE */
      {pxmsg.i &MSGNUM=3358 &ERRORLEVEL=3}
      return.
   end.   /* if so_fsm_type = "SEO" */

   else if fsmtype = "FSM-RO" then do:
      err_chk = yes.
      /* USE CALL ACTIVITY RECORDING FOR THIS ORDER */
      {pxmsg.i &MSGNUM=1058 &ERRORLEVEL=3}
      return.
   end.   /* if so_fsm_type = "FSM-RO" */

   else if fsmtype = "SC"
        or fsmtype = "PRM"
   then do:
      err_chk = yes.
      /* INVALID ORDER TYPE */
      {pxmsg.i &MSGNUM=5103 &ERRORLEVEL=3}
      return.
   end. /* IF FSMTYPE = "SC" */

   if sosecond then do:
      err_chk = yes.
      /* BTB ORDERS ARE NOT ALLOWED IN THIS TRANSACTION */
      {pxmsg.i &MSGNUM=2822 &ERRORLEVEL=3}
      return.
   end. /* IF SOSECOND */

END PROCEDURE. /* P_ERR_MSG */

{&SOSOISM-P-TAG8}

PROCEDURE p-find-mfc-rec:

   copyusr = no.

   {mfctrl01.i mfc_ctrl so_copy_usr cchar no no}

   if cchar = "yes" then
      copyusr = yes.

END PROCEDURE. /* P-FIND-MFC-REC */

PROCEDURE p-sel-line-qty:

   /* SELECT LINES AND QUANTITES FOR SHIPMENT */
   {gprun.i ""xxsosoisd.p""
            "(input-output table tt_consign_shipment_detail,
              output       table tt_sod_det,
              input        '',
              input        '')"}

   /* RESET SOD_QTY_CHG, SOD_BO_CHG TO ZERO */
   /* IF THE USER ABORTED OUT OF SOSOISD.P  */
   if undo-select then
      for each sod_det
         where sod_domain = global_domain
         and   sod_nbr = so_mstr.so_nbr
      exclusive-lock:
         assign
            sod_qty_chg = 0
            sod_bo_chg  = 0.
   end. /* FOR EACH SOD_DET */

END PROCEDURE. /* P-SEL-LINE-QTY */

PROCEDURE p-recalc-so-tax-det:

   if so_mstr.so_fsm_type = "" and
      l_recalc
   then do:

      /* For orders which are owned and invoiced by an */
      /* External system, shipment does not mean invoice. */
      /* The external system will send an invoice, MFG/PRO */
      /* Will not update sod_qty_inv or invoice the trailer */
      /* Charges.  Should additonal charges be added during */
      /* Shipment, the charges will be exported to the external */
      /* System via calls to the Logistics API. */
      if so_app_owner > "" then do:

         /* If external invoicing, fiddle with invoice stuff here. */
         if can-find (lgs_mstr
            where lgs_domain = global_domain
            and   lgs_app_id = so_app_owner
            and   lgs_invc_imp = yes)
         then do:

            /* Ready to invoice here only if invoiced */
            /* exceeds the amount ordered for all lines. */
            so_to_inv = not can-find(first sod_det
               where sod_domain = global_domain
               and   sod_nbr = so_nbr
               and   sod_qty_ivcd < sod_qty_ord).

            /* If invoicing then */
            if so_to_inv then do:
               /* Logistics will Invoice the shipped amount. */
               /* Thus do not change the quantity to invoice here. */
               /* The tax calculations done earlier included */
               /* the shipped qty in the tax calculation. */
               /* This is not desirable and may double bill. */
               /* Only use the quanitity to invoice (sod_qty_inv) */
               /* to calc the taxes, not the qty shipped. So */
               /* recalculate the Invoice taxes with no sod_qty_chg */
               {gprun.i ""txcalc.p""
                        "(input  '13',
                          input  so_nbr,
                          input  '',
                          input  0,
                          input  no,
                          output result-status)"}
            end.
            else do:
               /* GTM has made a mess of the tx2d to invoice. */
               /* We need to copy the existing '11' records into */
               /* '13' records to keep track of the external */
               /* taxes and to keep GTM and tax method 3 happy. */
               {gprun.i ""txdetcpy.p""
                        "(input so_nbr,
                          input '',
                          input '11',
                          input so_nbr,
                          input '',
                          input '13')"}
            end.

            /* Are any trailer charges still outstanding? */
            if so_trl1_amt <> 0 or
               so_trl2_amt <> 0 or
               so_trl3_amt <> 0
            then do:
               /* Inform the Owner of the order */
               {gprunmo.i &module = "LG" &program = "lgtrlex.p"
                          &param  = """(input so_nbr)"""}
               /* Do not invoice at this time. */
               so_to_inv = no.
            end.
         end.
         else do:
            /* Let shipper operate normally */
            {gprun.i ""txcalc.p""
                     "(input  '11',
                       input  so_mstr.so_nbr,
                       input  so_mstr.so_quote,
                       input  0,
                       input  no,
                       output result-status)"}
         end.
      end.
      else do: /* Non logistics order */
         /* TYPE 11 TAX DETAIL RECS DON'T EXIST FOR SCHEDULED ORDERS */
         if not so_sched then do:
            {gprun.i ""txcalc.p""
                     "(input  '11',
                       input  so_mstr.so_nbr,
                       input  so_mstr.so_quote,
                       input  0,
                       input  no,
                       output result-status)"}
         end.
      end.
   end. /* IF SO_MSTR.SO_FSM_TYPE = "" AND L_RECALC */

   if so_mstr.so_fsm_type = "RMA"
   then do:

      for first tx2d_det
         fields (tx2d_domain tx2d_edited tx2d_nbr tx2d_ref tx2d_tr_type)
         where   tx2d_domain = global_domain
         and     tx2d_ref = so_mstr.so_nbr
         and tx2d_nbr = ''
         and tx2d_tr_type = '36'
         and tx2d_edited
      no-lock:
         /* Previous tax values edited. Recalculate? */
         {pxmsg.i &MSGNUM=917 &ERRORLEVEL=2 &CONFIRM=recalc}
      end.

      if recalc then do:
         /* THE POST FLAG IS SET  TO 'NO' BECAUSE WE ARE NOT CREATING */
         /* QUANTUM REGISTER RECORDS FROM THIS CALL TO TXCALC.P       */
         {gprun.i ""txcalc.p""
                  "(input  '36',
                    input  so_mstr.so_nbr,
                    input  '',
                    input  0 /*ALL LINES*/,
                    input no,
                    output result-status)"}
      end. /* IF RECALC */

   end.

END PROCEDURE. /* P-RECALC-SO-TAX-DET */

PROCEDURE p-post-freight-accrual:
   /* MOVED THE FREIGHT ACCRUAL POSTING AFTER SHIPMENTS ARE PROCESSED.       */

   /* WHEN POSTING FREIGHT WITH LOGISTICS ACCOUNTING WE NEED THE TRANSACTION */
   /* NUMBER(tr_trnbr)FOR THE "ISS-SO" TRANSACTION. THIS NUMBER IS USED TO   */
   /* RELATE THE TRGL_DET RECORDS CREATED IN LAFRPST.P TO "ISS-SO"           */
   /* TRANSACTION(TR_HIST) RECORD.                                           */

   undo-select = false.

   {&SOSOISM-P-TAG9}
   /* PROCESS SHIPMENTS ENTERED */
   run p_shipment.

   /* POST FREIGHT ACCRUALS */
   if gl_amt <> 0
   then do:

      /* IF LOGISTICS ACCOUNTING IS ENABLED THEN CREATE PENDING VOUCHER */
      /* MASTER AND DETAIL RECORDS AND POST THE FREIGHT TO THE GL.      */
      if use-log-acctg
         and lv_accrue_freight
      then do:

         for first so_mstr
            fields (so_domain so_curr so_exru_seq so_ex_rate so_ex_rate2
                    so_ex_ratetype so_nbr so_ship so_ship_date so_bol
                    so_channel)
            where recid(so_mstr) = so_mstr_recid
         no-lock:
         end. /* FOR FIRST so_mstr */

         for first ft_mstr
            fields (ft_domain ft_lc_charge ft_accrual_level)
            where   ft_domain = global_domain
            and     ft_terms = so_fr_terms
         no-lock:

            /* CREATE FREIGHT ACCRUAL RECORDS */
            {gprunmo.i &module = "LA" &program = "lafrpst.p"
                       &param  = """(input '{&TYPE_SOShipment}',
                                     input lv_shipment_id,
                                     input so_bol,
                                     input so_ship_date,
                                     input eff_date,
                                     input so_ship,
                                     input '{&TYPE_SO}',
                                     input so_curr,
                                     input so_ex_rate,
                                     input so_ex_rate2,
                                     input ' ',  /* BLANK PVO_EX_RATETYPE */
                                     input so_exru_seq,
                                     input so_cust)"""}
         end. /* FOR FIRST FT_MSTR */
      end. /* IF use-log-acctg */
      else do:
         {gprun.i ""sofrpst.p"" "(input eff_date)"}
      end. /* IF use-log-acctg IS FALSE */
      gl_amt = 0.
   end. /* IF GL_AMT <> 0 */

END PROCEDURE. /* P-POST-FREIGHT-ACCRUAL */


PROCEDURE find-soddet:

   define input  parameter p_sonbr    like so_nbr      no-undo.
   define input  parameter p_shipsite like sod_site    no-undo.
   define output parameter p_l_undo   like mfc_logical no-undo.

   for first sod_det
      fields (sod_domain sod_nbr sod_site)
      where   sod_domain = global_domain
      and     sod_nbr  = p_sonbr
      and     sod_site = p_shipsite
   no-lock: end.
   if not available sod_det then do:
      /* THE SITE ENTERED ON HEADER DOES NOT BELONG TO THE */
      /* LINE ITEM SITES OF SALES ORDER.                   */
      {pxmsg.i &MSGNUM=4561 &ERRORLEVEL=3 &MSGARG1=p_sonbr}
      p_l_undo = yes.
   end. /* IF NOT AVAILABLE sod_det */

END PROCEDURE.

PROCEDURE p_shipment:
/* PROCEDURE p_shipment VERIFIES THAT SHIPMENTS ARE PROCESSED FOR ONLY */
/* NON-ERRONEOUS LINE ITEMS DURING CIM LOAD WHEN THE FLAG              */
/* Ship One Line During CIM IS SET TO YES IN WAREHOUSE CONTROL FILE    */

   for first sr_wkfl
      where sr_domain = global_domain
      and   sr_userid = mfguser
   no-lock: end.

   /* PROCESS SHIPMENTS ENTERED */
   {gprun.i ""sosoisa.p""
      "(input-output table tt_consign_shipment_detail)"}

END PROCEDURE. /* PROCEDURE p_shipment */

PROCEDURE storeFreightDetailsInQadWkfl:

   /* IF THE SHIPMENT IS DONE IN BATCH MODE THE FREIGHT IS CALC-  */
   /* ULATED WHEN AN SHIPMENT IS ENTERED AND THE ACTUAL SHIPMENT  */
   /* ALONG WITH THE FREIGHT POSTING IS DONE IN THE BATCH MODE    */
   /* THROUGH SOISBT.P - SO BATCH SHIPMENT PROCESSOR              */
   /* WITH LOGISTICS ACCOUNTING ENABLED WE STORE THE FREIGHT      */
   /* DETAILS WHEN THE FREIGHT IS CALCULATED IN A TEMP-TABLE      */
   /* AND USE THAT TEMP-TABLE TO POST FREIGHT.                    */
   /* WHEN FREIGHT IS POSTED IN BATCH, WE NEED TO STORE THE TEMP- */
   /* TABLE DATA TO QAD_WKFL SO THAT IT IS AVAILABLE WHEN POSTING */
   /* FREIGHT IN SOISBT.P                                         */

   define input  parameter ip_mfguser      as character no-undo.
   define input parameter  ip_shipment_id  as character no-undo.

   /* WE DO NOT NEED THE OUTPUT - FOURTH PARAMETER FROM LAFRTTM1.P */
   /* STORE IT IN A TEMP VARIABLE.                                 */
   define variable l_temp as character no-undo.

   /* GET qad_wkfl RECORD FOR THE BATCH MODE */
   for first qad_wkfl
      where qad_domain = global_domain
      and   qad_key1 = ip_mfguser  /* CONTAINS sosois.p+so_nbr */
      and   qad_key2 = "BATCH"
   no-lock:

      {gprunmo.i  &module = "LA" &program = "lafrttm1.p"
                  &param  = """(input 0,
                                input ip_mfguser,
                                input ip_shipment_id,
                                output l_temp)"""}
   end. /* FOR FIRST QAD_WKFL */
END PROCEDURE. /* PROCEDURE storeFreightDetailsInQadWkfl */

PROCEDURE storeShipmentInQadWkfl:
   define input  parameter ip_mfguser      as character no-undo.

   /* GET qad_wkfl RECORD FOR THE BATCH MODE */
   for first qad_wkfl
      where qad_domain = global_domain
      and   qad_key1 = ip_mfguser /* sosois.p + so_nbr */
      and   qad_key2 = "BATCH"
   no-lock:

      /* TRANSFER CONSIGNMENT TEMP-TABLE TO qad_wkfl, SO THAT     */
      /* IT CAN BE RECONSTRUCTED WHEN RUN IN BATCH MODE.          */
      {gprunmo.i &program = "socntmp.p" &module  = "ACN"
                 &param   = """(input 0,
                                input ip_mfguser,
                                input-output table
                                   tt_consign_shipment_detail)"""}

   end.
END PROCEDURE. /* PROCEDURE storeShipmentInQadWkfl */
