/* rcshwbb.p - SHIPPER WORKBENCH - SUB PROGRAM                                */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.127.1.6 $                                                */
/* VERSION 7.5        LAST MODIFIED: 07/18/95   BY: GWM  *J049*               */
/* VERSION 8.5        LAST MODIFIED: 04/16/96   BY: GWM  *J0JC*               */
/* VERSION 8.5        LAST MODIFIED: 04/24/96   BY: GWM  *J0K8*               */
/* REVISION: 8.5      LAST MODIFIED: 06/05/96   BY: GWM  *J0QY*               */
/* REVISION: 8.5      LAST MODIFIED: 07/10/96   BY: AJW  *J0YL*               */
/* REVISION: 8.5      LAST MODIFIED: 07/28/96   BY: taf  *J12M*               */
/* REVISION: 8.5      LAST MODIFIED: 07/31/96   BY: jpm  *J134*               */
/* REVISION: 8.6      LAST MODIFIED: 08/03/96   BY: *K003* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 09/20/96   BY: TSI  *K005*               */
/* REVISION: 8.6      LAST MODIFIED: 10/30/96   BY: *K003* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 10/31/96   BY: *K003* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 12/02/96   BY: *J18G* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 12/03/96   BY: *K02T* Chris Theisen      */
/* REVISION: 8.6      LAST MODIFIED: 12/25/96   BY: *K03S* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 12/30/96   BY: *K022* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 01/26/96   BY: *K03K* Vinay Nayak-Sujir  */
/* REVISION: 8.5      LAST MODIFIED: 02/12/97   BY: *J1HV* Bill Gates         */
/* REVISION: 8.6      LAST MODIFIED: 02/28/97   BY: *K06K* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke        */
/* REVISION: 8.5      LAST MODIFIED: 03/24/97   BY: *J1LY* Kieu Nguyen        */
/* REVISION: 8.5      LAST MODIFIED: 03/24/97   BY: *G2M9* David Seo          */
/* REVISION: 8.6      LAST MODIFIED: 05/09/97   BY: *K0CZ* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 06/11/97   BY: *K0DY* Taek-Soo Chang     */
/* REVISION: 8.6      LAST MODIFIED: 07/13/97   BY: *K0DH* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 09/23/97   BY: *K0J7* John Worden        */
/* REVISION: 8.6      LAST MODIFIED: 09/24/97   BY: *K0JC* John Worden        */
/* REVISION: 8.6      LAST MODIFIED: 10/24/97   BY: *J246* Nirav Parikh       */
/* REVISION: 8.6      LAST MODIFIED: 10/28/97   BY: *K165* John Worden        */
/* REVISION: 8.6      LAST MODIFIED: 11/11/97   BY: *K18W* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 11/18/97   BY: *J22Y* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 12/19/97   BY: *K1F0* Niranjan Ranka     */
/* REVISION: 8.6      LAST MODIFIED: 11/24/97   BY: *K15N* Jim Williams       */
/* REVISION: 8.6      LAST MODIFIED: 01/30/98   BY: *J2BZ* Seema Varma        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 04/06/98   BY: *J2CQ* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/01/98   BY: *K1NF* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 06/01/98   BY: *J2LW* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 06/08/98   BY: *J2MH* Dans Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 07/16/98   BY: *L042* Surekha Joshi      */
/* REVISION: 8.6E     LAST MODIFIED: 07/22/98   BY: *J2M7* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 07/30/98   BY: *J2RL* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 08/05/98   BY: *J2S5* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 08/11/98   BY: *J2TP* Poonam Bahl        */
/* REVISION: 8.6E     LAST MODIFIED: 08/19/98   BY: *K1WG* Seema Varma        */
/* REVISION: 8.6E     LAST MODIFIED: 09/10/98   BY: *J2ZC* Manish Kulkarni    */
/* REVISION: 9.0      LAST MODIFIED: 11/09/98   BY: *J33X* Seema Varma        */
/* REVISION: 9.0      LAST MODIFIED: 11/19/98   BY: *J34T* Poonam Bahl        */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *J35D* Manish Kulkarni    */
/* REVISION: 9.0      LAST MODIFIED: 01/12/99   BY: *J37V* Seema Varma        */
/* REVISION: 9.0      LAST MODIFIED: 01/11/99   BY: *J389* Surekha Joshi      */
/* REVISION: 9.0      LAST MODIFIED: 02/02/99   BY: *J399* Poonam Bahl        */
/* REVISION: 9.0      LAST MODIFIED: 02/17/99   BY: *J394* Poonam Bahl        */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 06/07/99   BY: *K20P* Sanjeev Assudani   */
/* REVISION: 9.1      LAST MODIFIED: 08/06/99   BY: *K21H* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 08/18/99   BY: *K223* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 09/29/99   BY: *K238* Kedar Deherkar     */
/* REVISION: 9.1      LAST MODIFIED: 10/05/99   BY: *K21N* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 10/28/99   BY: *J3GJ* Sachin Shinde      */
/* REVISION: 9.1      LAST MODIFIED: 11/09/99   BY: *K22Q* Joseph Fernando    */
/* REVISION: 9.1      LAST MODIFIED: 05/28/99   BY: *N004* Patrick Rowan      */
/* REVISION: 9.1      LAST MODIFIED: 12/02/99   BY: *L0M0* Manish Kulkarni    */
/* REVISION: 9.1      LAST MODIFIED: 02/16/00   BY: *L0RV* Sachin Shinde      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/24/00   BY: *L0PR* Kedar Deherkar     */
/* REVISION: 9.1      LAST MODIFIED: 08/04/00   BY: *L12G* Ashwini Ghaisas    */
/* REVISION: 9.1      LAST MODIFIED: 08/16/00   BY: *L12R* Ashwini Ghaisas    */
/* REVISION: 9.1      LAST MODIFIED: 08/28/00   BY: *M0RX* Ashwini Ghaisas    */
/* REVISION: 9.1      LAST MODIFIED: 08/28/00   BY: *N0NH* Dave Caveney       */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00   BY: *L14M* Falguni Dalal      */
/* REVISION: 9.1      LAST MODIFIED: 10/30/00   BY: *M0VG* Seema Tyagi        */
/* REVISION: 9.1      LAST MODIFIED: 02/07/01   BY: *M110* Kaustubh Kulkarni  */
/* REVISION: 9.1      LAST MODIFIED: 09/30/00   BY: *N0WX* Mudit Mehta        */
/* Revision: 1.81       BY: Reetu Kapoor           DATE: 03/28/01 ECO: *N0TY* */
/* Revision: 1.82       BY: Kirti Desai            DATE: 05/21/01 ECO: *M16Y* */
/* Revision: 1.83       BY: Russ Witt              DATE: 06/01/01 ECO: *P00J* */
/* Revision: 1.85       BY: Kedar Deherkar         DATE: 07/02/01 ECO: *M1B7* */
/* Revision: 1.88       BY: Dan Herman             DATE: 07/06/01 ECO: *P007* */
/* Revision: 1.89       BY: Hareesh V              DATE: 07/10/01 ECO: *K26P* */
/* Revision: 1.90       BY: Kirti Desai            DATE: 07/24/01 ECO: *M1D0* */
/* Revision: 1.91       BY: Nikita Joshi           DATE: 10/03/01 ECO: *M1FF* */
/* Revision: 1.92       BY: Steve Nugent           DATE: 10/15/01 ECO: *P004* */
/* Revision: 1.93       BY: Rajaneesh Sarangi      DATE: 02/21/02 ECO: *L13N* */
/* Revision: 1.94       BY: Vandna Rohira          DATE: 03/22/02 ECO: *N1CN* */
/* Revision: 1.95       BY: Katie Hilbert          DATE: 04/15/02 ECO: *P03J* */
/* Revision: 1.96       BY: Samir Bavkar           DATE: 08/15/02 ECO: *P09K* */
/* Revision: 1.105      BY: John Pison             DATE: 10/29/02 ECO: *N1YK* */
/* Revision: 1.107      BY: Shoma Salgaonkar       DATE: 11/19/02 ECO: *N1Z6* */
/* Revision: 1.109      BY: Anitha Gopal           DATE: 01/06/03 ECO: *N23F* */
/* Revision: 1.110      BY: Seema Tyagi            DATE: 02/22/03 ECO: *N27L* */
/* Revision: 1.112      BY: Paul Donnelly (SB)     DATE: 06/28/03 ECO: *Q00K* */
/* Revision: 1.113      BY: Rajinder Kamra         DATE: 05/05/03 ECO: *Q003* */
/* Revision: 1.114      BY: Deepak Rao             DATE: 11/06/03 ECO: *P18L* */
/* Revision: 1.115      BY: Mercy Chittilapilly    DATE: 02/04/04 ECO: *P1MN* */
/* Revision: 1.116      BY: Robin McCarthy         DATE: 04/19/04 ECO: *P15V* */
/* Revision: 1.119      BY: Mandar Gawde           DATE: 05/17/04 ECO: *P1YF* */
/* Revision: 1.120      BY: Sukhad Kulkarni        DATE: 05/21/04 ECO: *P211* */
/* Revision: 1.121      BY: Vinay Soman            DATE: 05/28/04 ECO: *P23X* */
/* Revision: 1.122      BY: Kirti Desai            DATE: 06/30/04 ECO: *Q09X* */
/* Revision: 1.123      BY: Vivek Gogte            DATE: 07/28/04 ECO: *Q0BM* */
/* Revision: 1.124      BY: Shivaraman V.          DATE: 11/19/04 ECO: *Q0FK* */
/* Revision: 1.125      BY: Shivanand H            DATE: 12/06/04 ECO: *P2Y9* */
/* Revision: 1.126      BY: Binoy John             DATE: 01/27/05 ECO: *P33X* */
/* Revision: 1.127      BY: Somesh Jeswani         DATE: 02/16/05 ECO: *P38B* */
/* Revision: 1.127.1.1  BY: Sukhad Kulkarni        DATE: 03/10/05 ECO: *P3CD* */
/* Revision: 1.127.1.3  BY: Alok Gupta             DATE: 04/13/05 ECO: *P3GQ* */
/* Revision: 1.127.1.4  BY: Jignesh Rachh          DATE: 05/17/05 ECO: *P3KL* */
/* Revision: 1.127.1.5  BY: Alok Gupta             DATE: 05/19/05 ECO: *P3M0* */
/* $Revision: 1.127.1.6 $        BY: Charulata Pingale      DATE: 12/20/05 ECO: *P4BZ* */



/* LAST MODIFIED: 2008/06/16   BY: Softspeed roger xiao   ECO: *xp001*      */  /*add disp 出货指示号,流水号*/
/* LAST MODIFIED: 2008/06/16   BY: Softspeed roger xiao   ECO: *xp002*      */  /*add 相关发票信息:form inv*/
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{cxcustom.i "RCSHWBB.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{rcinvtbl.i new}  /* DEFINITIONS NEEDED FOR rcinvcon.i */

/* INPUT PARAMETERS */
define input parameter ship_from  as character.
define input parameter tmp_prefix as character.
define input parameter abs_recid  as recid.

/* SHARED VARIABLES */
define new shared variable new_site like si_site.
define new shared variable err_stat as integer.
define new shared variable so_db as character.
define new shared variable cmtindx like cmt_indx.

define shared variable ship_so   like so_nbr.
define shared variable ship_line like sod_line.

define shared variable global_recid as recid.

/* LOCAL VARIABLES */
define variable save_frame_line  as integer          no-undo.
define variable i                as integer          no-undo.
define variable first_column     as character format "x(5)" no-undo.
define variable transtype        as character initial "ISS-UNP" no-undo.
define variable nullstr          as character        no-undo.
define variable undotran         like mfc_logical    no-undo.
define variable del-yn           like mfc_logical    no-undo.
define variable delete_recid     as recid            no-undo.
define variable sel_var_add      as integer format "9" no-undo.
define variable sel_var_del      as integer format "9" no-undo.
define variable error_lot        as logical          no-undo.
define variable error_part       as logical          no-undo.
define variable valid_entry      as logical          no-undo.
define variable refresh          as logical          no-undo.
define variable cont_id          as character format "x(9)" no-undo.
define variable return_code      as integer          no-undo.
define variable sort_recs        as logical          no-undo.
define variable create_recs      as logical          no-undo.
define variable gwt_um           as character        no-undo.
define variable disp_line        as character format "x(69)" no-undo.
define variable shipto_name      like ad_name        no-undo.
define variable shipto_code      like abs_shipto     no-undo.
define variable nwt_old          like abs_nwt        no-undo.
define variable absship_recid    as recid            no-undo.
define variable par_id           as character        no-undo.
define variable cnsm_req         as logical          no-undo.
define variable open_qty         like schd_all_qty   no-undo.
define variable peg_qty          like schd_all_qty   no-undo.
define variable shipgrp          like sgad_grp       no-undo.
define variable cmmts            like mfc_logical label "Comments" no-undo.
define variable parent_abs_recid as recid            no-undo.
define variable errorst          as logical          no-undo.
define variable errornum         as integer          no-undo.
define variable can_discard      as logical          no-undo.
define variable msgnum           as integer          no-undo.
define variable pick_qty         like sod_qty_pick   no-undo.
define variable tmp_qty          like sod_qty_pick   no-undo.
define variable avail_qty        like sod_qty_pick   no-undo.
define variable old_lot          like lad_lot        no-undo.
define variable old_qty          like lad_qty_all    no-undo.
define variable old_loc          like lad_loc        no-undo.
define variable old_site         like lad_site       no-undo.
define variable old_ref          like lad_ref        no-undo.
define variable kit_comp         as logical          no-undo.
define variable del_lad          as logical          no-undo.
define variable cmf_flg          as logical          no-undo.
define variable qty_old          as decimal          no-undo.
define variable vol_old          as decimal          no-undo.
define variable v_editall        as logical          no-undo.
define variable ch_nwt           like abs_nwt        no-undo.
define variable next_editloop    as logical          no-undo.
define variable next_mainloop    as logical          no-undo.
define variable original_nwt     like abs_nwt        no-undo.
define variable original_gwt     like abs_gwt        no-undo.
define variable so_ok            as logical          no-undo.
define variable part_order       like abs_order      no-undo.
define variable part_order_line  like abs_line       no-undo.
define variable v-abs_format     like abs_mstr.abs_format no-undo.
define variable adj_qty          like ld_qty_all     no-undo.
define variable fas_so_rec       as character.
define variable leave_editloop   as logical          no-undo.
define variable l_abs_pick_qty   like sod_qty_pick   no-undo.
define variable v_unpicked_qty   like sod_qty_pick   no-undo.
define variable l_part_qty       like abs_qty        no-undo.
define variable l_twt_old        like abs_nwt        no-undo.
define variable l_abs_tare_wt    like abs_nwt        no-undo.
define variable l_twt_um         as character        no-undo.
define variable l_tr_type        like tr_type        no-undo.
define variable l_order_change   like mfc_logical    no-undo.
define variable l_warning        like mfc_logical    no-undo.
define variable rcf_file_found   like mfc_logical    no-undo.
define variable l_updalloc       like mfc_logical    no-undo.
define variable l_delproc        like mfc_logical    no-undo.
define variable cancel_bo        like mfc_logical    no-undo.
define variable l_prev_pick_qty  like l_abs_pick_qty no-undo.
define variable l_lad_qty_all    like lad_qty_all    no-undo.
define variable l_avail_qty      like lad_qty_all    no-undo.
define variable vLastField       as character        no-undo.
define variable vErrorOrder      like mfc_logical    no-undo.
define variable vErrorOrderLine  like mfc_logical    no-undo.
define variable vErrorMsgNumber  as integer          no-undo.
define variable vErrorSite       like sod_site       no-undo.
define variable vNewOrder        like mfc_logical    no-undo.
define variable vOldAbsID        like abs_id         no-undo.
define variable vOldOrder        like abs_order      no-undo.
define variable vOldLine         like abs_line       no-undo.
define variable clc_file_found   like mfc_logical    no-undo.
define variable shpc_file_found  like mfc_logical    no-undo.
define variable add_container    as logical          no-undo.
define variable add_item         as logical          no-undo.
define variable sodfanbr         like sod_fa_nbr.
define variable l_msgar1         as character format "x(26)" extent 2 no-undo.
define variable add_parent_container    like mfc_logical no-undo.
define variable add_existing_container  like mfc_logical no-undo.
define variable using_container_charges like mfc_logical no-undo.
define variable using_line_charges      like mfc_logical no-undo.
define variable ok_to_recalc_wt_vol     like mfc_logical no-undo.

define variable h_nrm as handle no-undo.

define variable use-log-acctg as logical no-undo.
define variable l_FrTermsErr like mfc_logical no-undo.
define variable l_FrTermsOnFirstOrder like so_fr_terms no-undo.

define variable l_undochk     like mfc_logical initial "no" no-undo.
define variable l_absso_recid as   recid                    no-undo.
define variable l_abs_recid    as   recid       no-undo initial ?.
define variable l_confirm_comp like mfc_logical no-undo.
define variable l_abs_qty      like abs_qty     no-undo.
define variable ret-flag       as   integer     no-undo.
define variable l_stat         like si_status   no-undo.
define variable ok_to_ship     as logical       no-undo.
define variable l_shipto_id    as character     no-undo.
define variable l_dock_id      as character     no-undo.

define variable l_allowed      like mfc_logical no-undo.
define variable l_ship_id      as character     no-undo.
define variable l_addr         as character     no-undo.


define variable l_orig_order like abs_order  no-undo .
define variable l_orig_line  like abs_line   no-undo .
define variable l_tmp_qty      like abs_qty     no-undo initial 0.
define variable l_ship_qty   like abs_qty    no-undo.

{socnvars.i}   /* CONSIGNMENT VARIABLES */

{socnis.i}     /* CUSTOMER CONSIGNMENT SHIPMENT TEMP-TABLE DEFINITION */

{rcexptbl.i new}

define temp-table  abs-tt no-undo
  fields abs-tt-id   like  abs_id
  fields abs-tt-nbr  like  abs_order
  fields abs-tt-item like  abs_item
  fields abs-tt-line like  abs_line
  fields abs-tt-qty  like  abs_qty
index abs-tt-id abs-tt-id .

/* BUFFERS */
define buffer ship_line       for abs_mstr.
define buffer abs_parent_buff for abs_mstr.
define buffer abs_child_buff  for abs_mstr.

assign
   l_msgar1[1] = getTermLabel("FOR_SALES_ORDERS",22)
   l_msgar1[2] = getTermLabel("FOR_REMOTE_INVENTORY",26).

/* CONTAINER WORKBENCH FORMS */
{xxrcshwbfmxp2.i} /*xp001*/
form 
    ship_line.abs__chr03 colon 5 format "x(28)" label "箱唛" 
    ship_line.abs__chr04 colon 5 format "x(28)" no-label
    ship_line.abs__chr05 colon 5 format "x(28)" no-label
    ship_line.abs__chr06 colon 5 format "x(28)" no-label
    ship_line.abs__chr07 colon 5 format "x(28)" no-label

with frame inv2 centered row 9 overlay side-labels title color normal  "箱唛" .  /*xp002*/



/* DETERMINE IF CUST. SEQ. CONTROL FILE EXISTS */
run check_tablename
   (input "rcf_ctrl",
   output rcf_file_found).

/* DETERMINE IF SHIPMENT PERFORMANCE CONTROL FILE EXISTS */
run check_tablename
   (input "shpc_ctrl",
    output shpc_file_found).

/*DETERMINE IF CONTAINER AND LINE CHARGES IS ENABLED */
run check_tablename
    (input "ccl_ctrl",
     output clc_file_found).

if can-find (mfc_ctrl
   where mfc_domain = global_domain
   and   mfc_field = "enable_container_charges"
   and   mfc_logical)
   and   clc_file_found
then
   using_container_charges =  yes.

if can-find (mfc_ctrl
   where mfc_ctrl.mfc_domain = global_domain
   and mfc_field = "enable_line_charges"
   and mfc_logical) and clc_file_found
then
   using_line_charges =  yes.

/* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

/* CHECK TO SEE IF CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_CUSTOMER_CONSIGNMENT,
           input 10,
           input ADG,
           input CUST_CONSIGN_CTRL_TABLE,
           output using_cust_consignment)"}

/* INITIALIZE CENTRAL DOMAIN NAME */
/* COMBINED THE FOLLOWING ASSIGNMENTS IN A SINGLE */
/* ASSIGN STATEMENT TO REDUCE ACTION SEGMENT SIZE */
assign
   so_db = global_db
   del_lad = no
   parent_abs_recid = abs_recid
   absship_recid = abs_recid.

find first fac_ctrl
   where fac_domain = global_domain
no-lock no-error.
if available fac_ctrl then
   fas_so_rec = string(fac_so_rec).

/* Check whether all data is editable, or only informational fields */
run ip_editall (abs_recid, output v_editall).

find ship_line where recid(ship_line) = abs_recid  /*no-lock*/ /*xp002*/  no-error.

if not available ship_line then
   assign
      add_container          = true
      add_item               = true
      add_parent_container   = true
      add_existing_container = true
      create_recs            = true.
else do:
   assign
      shipto_code  = ship_line.abs_shipto
      v-abs_format = ship_line.abs_format
      sort_recs    = true.

   find ad_mstr
      where ad_domain = global_domain
      and   ad_addr = ship_line.abs_shipto
   no-lock no-error.
   if available ad_mstr then
      shipto_name = ad_name.
end.

/* GET SHIPTO AND DOCKID */
{gprunp.i "sopl" "p" "getShipToAndDockID"
    "(input abs_shipto,
      output l_shipto_id,
      output l_dock_id)"}

MAINLOOP:
repeat:

   l_absso_recid = ?.

   /* CREATE NEW RECORDS */
   if create_recs then do:
      {gprun.i ""rcctwbc.p""
               "(input ship_from,
                 input add_container,
                 input add_item,
                 input add_parent_container,
                 input tmp_prefix,
                 input true,
                 input shipto_code,
                 input l_dock_id,
                 input-output abs_recid)"}.

      if add_existing_container then do:
         {gprun.i ""rcshwbd.p""
                  "(input ship_from,
                    input tmp_prefix,
                    input shipto_code,
                    input v-abs_format,
                    input-output abs_recid)"}
      end.

      /* RESORT AND REPAINT THE SCREEN WITH NEW RECORDS */
      assign
         sort_recs   = true
         create_recs = false.

   end. /* IF CREATE_RECS */

   EDITLOOP:
   repeat with frame k:
      /* INITIALIZE L_UPDALLOC, L_DELPROC AND L_SHIP_QTY */
      assign
            l_updalloc = yes
        l_delproc = no
        l_ship_qty = 0.
    
      /* SORT THE RECORDS AND EXCLUSIVE-LOCK THEM ALL */
      if sort_recs then do:

         {gprun.i ""rcshwbs.p""
                  "(input abs_recid,
                    input tmp_prefix,
                    output return_code)"}.

         /* HANDLE ERRORS */
         if return_code > 0 then
            undo EDITLOOP, leave MAINLOOP.

         assign
            sort_recs = false
            abs_recid = ?
            refresh   = true.
      end.

      if l_abs_recid <> ? then
         assign
            abs_recid   = l_abs_recid
            l_abs_recid = ?.

      /* REPAINT THE SCREEN */
      if refresh then do:

         ststatus = stline[10].
         status input ststatus.
         clear frame k all no-pause.

         /* FIND SAVED RECORD */
         if abs_recid <> ? then
         find ship_line where recid(ship_line) = abs_recid
             /*no-lock*/ /*xp002*/  no-error.

         /* NO SAVED RECORD OR SAVED RECORD NOT FOUND */
         if abs_recid = ? or not available ship_line then do:

            find first ship_line
               where ship_line.abs_domain = global_domain
               and   ship_line.abs_shipfrom = ship_from
               and   ship_line.abs_shipto begins tmp_prefix
             /*no-lock*/ /*xp002*/  no-error.

            /* NO MORE RECORDS AVAILABLE SO LEAVE EDITING */
            if not available ship_line then
              leave MAINLOOP.

            assign
               save_frame_line = 1
               abs_recid = ?.
         end.

         /* BACK OFF RECORDS SO THAT THE RECORD WILL BE DISPLAYED */
         /* IN THE SAME FRAME LINE AS BEFORE */
         i = save_frame_line.

         do while i > 1:

            find prev ship_line
               where ship_line.abs_domain = global_domain
               and   ship_line.abs_shipfrom = ship_from
               and   ship_line.abs_shipto begins tmp_prefix
             /*no-lock*/ /*xp002*/  no-error.

            i = i - 1.
         end.

         /* REFRESH THE FRAME */
         i = 0.

         /*do while i < 7:*/ /*xp001*/
         do while i < 6:

            if available ship_line then do:

               for first sod_det
                  fields (sod_domain sod_cfg_type sod_contr_id sod_fa_nbr
                          sod_line sod_nbr sod_part sod_pickdate
                          sod_qty_all sod_qty_ord sod_qty_pick
                          sod_qty_ship sod_sched sod_type sod_site
                          sod_um_conv sod__qadl01)
                  where sod_domain = global_domain
                  and   sod_nbr    = ship_line.abs_order
                  and   sod_line   = integer(abs_line) no-lock:
               end. /* FOR FIRST SOD_DET */

               /* SET UP DISP_LINE */
               {rcshwbb1.i}

               display
                  fill(".",minimum(4,integer(ship_line.abs__qad06)))
                  + ship_line.abs__qad06
                  @ first_column
                  disp_line
               with frame k.

               find next ship_line
                  where ship_line.abs_domain = global_domain
                  and   ship_line.abs_shipfrom = ship_from
                  and   ship_line.abs_shipto begins tmp_prefix
               /*no-lock*/ /*xp002*/ no-error.
            end.

            i = i + 1.

            /*if i < 7 then down 1 with frame k. */ /*xp001*/
            if i < 6 then down 1 with frame k.
         end. /* DO WHILE I < 7 */

         /* INTRODUCED TRANSACTION BLOCK TO MINIMISE abs_mstr LOCKING */
         do transaction:

            /* FIND THE SAVED RECORD */
            if abs_recid <> ? then
               find ship_line
                  where recid(ship_line) = abs_recid
               exclusive-lock no-error.

            /* FIND THE FIRST RECORD */
            else
               find first ship_line
                  where ship_line.abs_domain = global_domain
                  and   ship_line.abs_shipfrom = ship_from
                  and   ship_line.abs_shipto begins tmp_prefix
               exclusive-lock no-error.

         end. /* do transaction */
         /* MOVE UP TO THE SELECTED RECORD IN THE FRAME */
         up frame-line(k) - save_frame_line.

         refresh = false.
      end. /* IF REFRESH */

      /* RESTORE FIRST_COLUMN */
      color display normal first_column with frame k.

      find pt_mstr
         where pt_domain = global_domain
         and   pt_part = ship_line.abs_item
      no-lock no-error.
      find sod_det
         where sod_domain = global_domain
         and   sod_nbr = ship_line.abs_order
         and   sod_line = integer(abs_line)
      no-lock no-error.

      find so_mstr
         where so_domain = global_domain
         and   so_nbr = ship_line.abs_order
      no-lock no-error.

      cnsm_req = can-find(first absr_det
         where absr_domain = global_domain
         and   absr_shipfrom = abs_shipfrom
         and absr_id = abs_id).

      /* SET UP DISP_LINE */
      {rcshwbb1.i}

      if ship_line.abs_id    begins "C"
         or ship_line.abs_id begins "I"
      then do:
         /* SET GLOBAL_DB USING ABS_SITE */
         old_site = "".
         new_site = ship_line.abs_site.
         {gprun.i ""gpalias.p""}

         /* SWITCH TO THE INVENTORY SITE */
         if so_db <> global_db then do:
            {gprun.i ""gpalias2.p""
               "(input ship_line.abs_site, output errornum)"}
            if errornum <> 0 and errornum <> 9 then do:
               /* DOMAIN # IS NOT AVAILABLE */
               run p-pxmsg (input 6137,
                            input 4,
                            input l_msgar1[2]).

            end.
            /* FIND FINAL ASSEMBLY CONTROL IN REMOTE DOMAIN */
            {gprun.i ""sofactrl.p"" "(output fas_so_rec)"}
         end.

         /* SWITCH BACK TO THE SALES ORDER DOMAIN */
         if so_db <> global_db then do:
            {gprun.i ""gpalias3.p"" "(input so_db, output errornum)"}
            if errornum <> 0 and errornum <> 9 then do:
               /* DOMAIN # IS NOT AVAILABLE */
               run p-pxmsg (input 6137,
                            input 4,
                            input l_msgar1[1]).
            end.
         end.
      end. /* IF ship_line.abd_id begins "C"... */

      display
         disp_line
      with frame k.

      {absupack.i  "ship_line" 3 22 "l_abs_pick_qty"}

      {absupack.i  "ship_line" 26 22 "l_abs_tare_wt"}

      assign
         vOldAbsID = ship_line.abs_id
         vOldOrder = ship_line.abs_order
         vOldLine  = ship_line.abs_line.

      status input stline[13].

      /* DISPLAY OTHER INFO FOR THE RECORD IN THE LOWER FRAME */
      display
         ship_line.abs_order @ part_order
         ship_line.abs_line  @ part_order_line
         ship_line.abs_qty
         l_abs_pick_qty
         l_abs_tare_wt
         ship_line.abs_wt_um @ l_twt_um
         ship_line.abs__qad02
         ship_line.abs_site
         ship_line.abs_loc
         ship_line.abs_nwt
         ship_line.abs_wt_um
         ship_line.abs_lotser
         ship_line.abs_gwt
         ship_line.abs_wt_um @ gwt_um
         ship_line.abs_ref
         sod_type     when (available sod_det)
         ""           when (not available sod_det) @ sod_type
         ship_line.abs_vol
         ship_line.abs_vol_um
         cnsm_req
         pt_desc1     when (available pt_mstr)
         ""           when (not available pt_mstr) @ pt_desc1
         sod_contr_id when (available sod_det)
         ""           when (not available sod_det) @ sod_contr_id
         cmmts
         cancel_bo
         ship_line.abs_fa_lot
         ship_line.abs__chr01 
         ship_line.abs__chr02 /*xp001*/
      with frame sample.

      l_prev_pick_qty = l_abs_pick_qty.

      /* HANDLE THE UPPER FRAME INTERFACE ONLY IN NON-BATCH MODE */
      if not batchrun then do:

         /* ENABLE UPPER FRAME FOR INPUT */
         set first_column
            with frame k
         editing:

            readkey.

            if lastkey = keycode("F9")
               or keyfunction(lastkey) = "CURSOR-UP"
               or lastkey = keycode("F10")
               or keyfunction(lastkey) = "CURSOR-DOWN"
               or lastkey = keycode("F5")
               or lastkey = keycode("CTRL-D")
               or lastkey = keycode("F1")
               or lastkey = keycode("CTRL-X")
               or lastkey = keycode("PF1")
               or lastkey = keycode("F3")
               or lastkey = keycode("PF3")
               or lastkey = keycode("CTRL-T")
               or keyfunction(lastkey) = "GO"
               or keyfunction(lastkey) = "END-ERROR"
               or lastkey = keycode("F4")
               or lastkey = keycode("RETURN")
               or keyfunction(lastkey) = "page-up"
               or lastkey = keycode("F7")
               or keyfunction(lastkey) = "page-down"
               or lastkey = keycode("F8")
               or ({gpiswrap.i} and
                   (keyfunction(lastkey) = "help" or lastkey = keycode(" ")))
               or lastkey = keycode("CTRL-E")
            then
               leave.

         end. /* EDITING */

         if {gpiswrap.i} and keyfunction(lastkey) = "help" then do:
            apply lastkey.
            next EDITLOOP.
         end.




/*********************************************************************************xp002*/
if ship_line.abs_id begins "i" then do:
    if (lastkey = keycode("F1")
        or lastkey = keycode("PF1")
        or lastkey = keycode("CTRL-X")
        or lastkey = keycode("RETURN")
        or keyfunction(lastkey) = "GO")
        or ({gpiswrap.i} and lastkey = keycode(" "))
    then do transaction :
        view frame inv2 .
        disp 
            ship_line.abs__chr03 
            ship_line.abs__chr04 
            ship_line.abs__chr05 
            ship_line.abs__chr06 
            ship_line.abs__chr07
        with frame inv2 .

        set 
            ship_line.abs__chr03 
            ship_line.abs__chr04 
            ship_line.abs__chr05 
            ship_line.abs__chr06 
            ship_line.abs__chr07
        with frame inv2 .

        find first abs_mstr 
            where abs_mstr.abs_domain = ship_line.abs_domain 
            and abs_mstr.abs_shipfrom = ship_line.abs_shipfrom 
            and abs_mstr.abs_par_id   = ship_line.abs_par_id
            and abs_mstr.abs_id       = ship_line.abs_id 
        no-error .
        if avail abs_mstr then do:
            assign 
            abs_mstr.abs__chr03 = ship_line.abs__chr03 
            abs_mstr.abs__chr04 = ship_line.abs__chr04 
            abs_mstr.abs__chr05 = ship_line.abs__chr05 
            abs_mstr.abs__chr06 = ship_line.abs__chr06 
            abs_mstr.abs__chr07 = ship_line.abs__chr07
            .
        end.

        hide frame inv2 no-pause .
    end.
end. /*if ship_line.abs_id begins "i"*/
/*xp002**********************************************************************************/













         /* HANDLE THE END-ERROR KEY */
         if lastkey = keycode("F4")
            or keyfunction(lastkey) = "END-ERROR"
         then
            leave EDITLOOP.

         if (lastkey = keycode("F9")
            or keyfunction(lastkey) = "CURSOR-UP"
            or lastkey = keycode("F10")
            or keyfunction(lastkey) = "CURSOR-DOWN")
            or keyfunction(lastkey) = "page-up"
            or lastkey = keycode("F7")
            or keyfunction(lastkey) = "page-down"
            or lastkey = keycode("F8")
         then do:

            run navigate_proc.

         end. /* IF CURSOR KEYS */

         cmmts = ship_line.abs_cmtindx > 0.

         /* HANDLE GO KEY */


/*********************************************************************************xp002*
         if (lastkey = keycode("F1")
            or lastkey = keycode("PF1")
            or lastkey = keycode("CTRL-X")
            or lastkey = keycode("RETURN")
            or keyfunction(lastkey) = "GO")
            or ({gpiswrap.i} and lastkey = keycode(" "))
         then

         SET_DATA:
         do on endkey undo SET_DATA, leave SET_DATA
            on error undo SET_DATA, retry SET_DATA:
         end. 
*xp002**********************************************************************************/
/*删除了SET_DATA整段程式*/




      /* HANDLE F5 KEY */
      /*if (lastkey = keycode("F5")
         or lastkey = keycode("CTRL-D"))
      then do:
         next_editloop = no.
         run delete_proc (output next_editloop).

         l_absso_recid = ?.

         if next_editloop then next editloop.

      end.  IF LASTKEY = KEYCODE F5 */ /*xp002*/

   end. /* IF NOT BATCHRUN */

   /* HANDLE F3 KEY */
   /* ALWAYS ENTER ADD MODE WHEN BATCH-RUN */
   /* if batchrun
      or lastkey = keycode("F3")
      or lastkey = keycode("PF3")
      or lastkey = keycode("CTRL-T")
   then do:
      assign
         next_editloop  = no
         next_mainloop  = no
         leave_editloop = no
         l_delproc      = no.

      run add_proc (output next_editloop, output next_mainloop, output leave_editloop).
      if next_editloop then next editloop.
      if next_mainloop then next mainloop.
      if leave_editloop then leave editloop.

   end. LASTKEY = KEYCODE F3 */  /*xp002*/

end. /* EDITLOOP */

/* CLEAN UP RECORDS */
run p_clean_up ( input ship_from, input tmp_prefix ).

if lastkey = keycode("F4") or
   keyfunction(lastkey) = "END-ERROR" or
   keyfunction(lastkey) = "ENDKEY" or
   ( batchrun and keyfunction(lastkey) = "." ) or
   lastkey = keycode("CTRL-E")
then
   leave MAINLOOP.

end. /* MAINLOOP */

hide frame k no-pause.
hide frame sample no-pause.

/* END OF MAIN PROCEDURE BODY */


PROCEDURE create_tt :

   define input parameter  ip_sod_nbr   like  sod_nbr  no-undo.
   define input parameter  ip_sod_line  like  sod_line no-undo.
   define input parameter  ip_sod_part  like  sod_part no-undo.

   define variable  ip_abs_pick_qty  like abs_qty      no-undo.

   for each abs_mstr
      where abs_domain = global_domain
        and abs_id begins "i"
        and   abs_order = ip_sod_nbr
        and abs_line    = string(ip_sod_line)
        and abs_item    = ip_sod_part
        and abs_qty  <> abs_ship_qty no-lock :
      {absupack.i  "abs_mstr" 3 22 "ip_abs_pick_qty" }
         find first abs-tt
         where  abs-tt-id = abs_id  no-lock no-error .

      if  not available abs-tt
      then do:
         create abs-tt .
         abs-tt-id   = abs_id .
      end. /* IF  not available abs-tt */
      assign
         abs-tt-nbr  = abs_order
         abs-tt-item  = abs_item
         abs-tt-line  = abs_line
         abs-tt-qty  = (abs_qty - abs_ship_qty - ip_abs_pick_qty ) *
                                       decimal(abs__qad03 ) .
   end. /* FOR EACH abs_mstr */

END PROCEDURE.  /* create_tt */

PROCEDURE compute_openqty :

   /* THE LOGIC OF OPENQTY.I  HAS  BEEN REPLACED WITH THE LOGIC  */
   /* CREATING THE TEMP-TABLE abs-tt AND THEN COMPUTING          */
   /* THE  OPEN QTY FROM THE TEMP-TABLE RECORDS  . THIS WAS DONE */
   /* OWING TO ORACLE COMMIT ISSUE                               */

   define input  parameter  ip_sod_nbr   like  sod_nbr  no-undo .
   define input  parameter  ip_sod_line  like  sod_line no-undo.
   define input  parameter  ip_sod_part  like  sod_part no-undo.
   define output parameter  ip_openqty   like abs_qty  no-undo.

   define variable open_qty  like open_qty initial 0  no-undo.

   for first sod_det
      fields (sod_domain sod_cfg_type sod_contr_id sod_fa_nbr
              sod_line sod_nbr sod_part sod_pickdate
              sod_qty_all sod_qty_ord sod_qty_pick
              sod_qty_ship sod_sched sod_type sod_site
              sod_um_conv sod__qadl01)
      where sod_domain = global_domain
        and sod_nbr   = ip_sod_nbr
        and sod_line  = ip_sod_line
        and sod_part  = ip_sod_part
   no-lock:

      for each abs-tt
         where abs-tt.abs-tt-nbr   = ip_sod_nbr
           and abs-tt.abs-tt-item  = ip_sod_part
           and abs-tt.abs-tt-line  = string(ip_sod_line)  :
        ip_openqty  = ip_openqty + abs-tt-qty .
      end. /* FOR EACH abs-tt */

      assign
         ip_openqty   = ip_openqty / sod_um_conv
         ip_openqty   = sod_qty_ord - sod_qty_pick - sod_qty_ship  - ip_openqty .
   end. /* FOR FIRST sod_det */

END PROCEDURE.  /* compute_openqty  */



PROCEDURE ip_editall:

   /* Set flag determining whether non-informational fields (any */
   /* field actually used during confirmation, such as quantities, */
   /* site, sales order #, etc) are allowed to be edited.  Only */
   /* purely informational fields (such as comments) may be editing */
   /* for non-SO shippers or confirmed SO shippers. */

   /* PARAMETERS */
   define input  parameter i_recid   as recid             no-undo.
   define output parameter o_editall as logical initial true no-undo.

   /* LOCAL VARIABLES */
   define variable v_par_recid as recid no-undo.

   /* BUFFERS */
   define buffer b_abs_mstr for abs_mstr.

   /* PROCEDURE BODY */

   /* Find top-level parent shipper or preshipper */
   {gprun.i ""gpabspar.p""
            "(input i_recid,
              input 'PS',
              input false,
              output v_par_recid)"}

   find b_abs_mstr no-lock where recid(b_abs_mstr) = v_par_recid
      no-error.

   {&RCSHWBB-P-TAG10}
   if available b_abs_mstr             and
      (b_abs_mstr.abs_id begins "s" or
      b_abs_mstr.abs_id begins "p")   and
      (can-find (im_mstr where im_domain = global_domain and (
      im_inv_mov = b_abs_mstr.abs_inv_mov and
      im_tr_type <> "ISS-SO")) or
      substring(b_abs_mstr.abs_status,2,1) = "y")
   then
      o_editall = false.

   {&RCSHWBB-P-TAG11}

   else o_editall = true.

END PROCEDURE.  /* ip_editall */

{gpnrseq.i}

{rccmf.i}

PROCEDURE delete_proc:
   define output parameter next_editloop as logical no-undo.

   DEL_LOOP:
   do on endkey undo DEL_LOOP, leave DEL_LOOP
         on error undo DEL_LOOP, retry DEL_LOOP:
      if not v_editall then do:
         {pxmsg.i &MSGNUM=5811 &ERRORLEVEL=3}
         /* Selection only available for unconfirmed SO shippers */
         next_editloop = yes.
         return.
      end.  /* if not v_editall */

      save_frame_line = frame-line(k).
      color display input first_column with frame k.

      /* DISPLAY F5 SELECTION FRAME */
      hide frame sample no-pause.
      view frame m1.

      display
         del-form-line-1
         del-form-line-2
         del-form-line-3
         del-form-line-4
         del-form-line-5
      with frame m1.

      assign
         sel_var_del = 0
         valid_entry = false.

      GET_SELECTION:
      do on endkey undo GET_SELECTION, leave GET_SELECTION
            on error undo GET_SELECTION, retry GET_SELECTION:

         /* PLEASE ENTER A SELECTION */
         {pxmsg.i &MSGNUM=39 &ERRORLEVEL=1
                  &CONFIRM=sel_var_del
                  &CONFIRM-TYPE='NON-LOGICAL'}

         if sel_var_del < 1 or sel_var_del > 5 then do:
            {pxmsg.i &MSGNUM=13 &ERRORLEVEL=3} /* NOT A VALID CHOICE */
            undo GET_SELECTION, retry GET_SELECTION.
         end.

         if ship_line.abs_id begins "i" and
            (sel_var_del <> 1 and sel_var_del <> 2)
         then do:
            /* THIS OPTION NOT ALLOWED FOR .. */
            {pxmsg.i &MSGNUM=761 &ERRORLEVEL=3}
            undo GET_SELECTION, retry GET_SELECTION.
         end.

         if sel_var_del = 1 then do:
            find abs_parent_buff
               where recid(abs_parent_buff) = parent_abs_recid
            no-lock.

            if abs_parent_buff.abs_nr_id <> "" then do:
               run chk_delnbr
                  (input abs_parent_buff.abs_nr_id,
                   output can_discard,
                   output errorst,
                   output errornum).
               if errorst then do:
                  {pxmsg.i &MSGNUM=errornum &ERRORLEVEL=4}
                  undo GET_SELECTION, retry GET_SELECTION.
               end. /* errorst */

               msgnum = if abs_parent_buff.abs_id begins "p"
                        then
                           5944
                        else 5946.

               if not can_discard then do:
                  {pxmsg.i &MSGNUM=msgnum &ERRORLEVEL=4}
                  /*DELETION PROHIBITED, GAPS IN (PRE-)SHIPPER SEQUENCE
                  NOT PERMITTED*/
                  undo GET_SELECTION, retry GET_SELECTION.
               end. /* not can_discard*/
            end. /* if abs_parent_buff.abs_nr_id <> "" */

            if abs_parent_buff.abs_preship_nr_id <> "" then do:
               run chk_delnbr
                  (input abs_parent_buff.abs_preship_nr_id,
                   output can_discard,
                   output errorst,
                   output errornum).
               if errorst then do:
                  {pxmsg.i &MSGNUM=errornum &ERRORLEVEL=4}
                  undo GET_SELECTION, retry GET_SELECTION.
               end. /* errorst */

               if not can_discard then do:
                  {pxmsg.i &MSGNUM=5944 &ERRORLEVEL=4}
                  /*DELETION PROHIBITED, GAPS IN PRE-SHIPPER SEQUENCE
                  NOT PERMITTED*/
                  undo GET_SELECTION, retry GET_SELECTION.
               end. /* not can_discard */
            end. /* if abs_parent_buff.abs_preship_nr_id <> "" */
         end. /* if sel_var_del = 1 */

         /* DELETE RESTRICTION FOR PRE-SHIPPER/SHIPPER   */
         /* ON SELECTING OPTION 2 TO 5                   */

         if (sel_var_del >= 2 and sel_var_del <= 5)
            and ((ship_line.abs_id >= "p" and
            ship_line.abs_id <= "p" + hi_char) or
            (ship_line.abs_id >= "s" and
            ship_line.abs_id <= "s" + hi_char))
         then do:
            /* THIS OPTION IS NOT ALLOWED FOR THE SELECTED RECORDS */
            {pxmsg.i &MSGNUM=761 &ERRORLEVEL=3}
            undo GET_SELECTION, retry GET_SELECTION.
         end. /* END OF if sel_var_del >= 2 and sel_var_del <= 5 */

         /* CHECK FOR ORPHAN ITEM RECORDS */
         if ship_line.abs_par_id = ""
            and sel_var_del = 2 or sel_var_del = 4
         then do:
            for each abs_mstr
               where abs_mstr.abs_domain = global_domain
               and   abs_mstr.abs_shipfrom = ship_from
               and   abs_mstr.abs_par_id = ship_line.abs_id
            no-lock:
               if abs_mstr.abs_id begins "i" then do:
                  /* CANNOT ORPHAN AN ITEM RECORD */
                  {pxmsg.i &MSGNUM=762 &ERRORLEVEL=3}
                  undo GET_SELECTION, retry GET_SELECTION.
               end. /* if abs_id begins i */
            end. /* for each abs_mstr */
         end. /* if par_id = "" and 2 or 4 */

         del-yn = false.
         /* REMOVE / DELETE RECORD, PLEASE CONFIRM */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if not del-yn then
            undo GET_SELECTION, leave GET_SELECTION.
         valid_entry = true.
      end. /* GET SELECTION */

      /* GENERAL ALLOCATE PICKED QUANTITY ? */
      if sel_var_del >= 1 and
         sel_var_del <= 5 and
         del-yn
      then do:
         {pxmsg.i &MSGNUM=3411 &ERRORLEVEL=1 &CONFIRM=l_updalloc}
         if not l_updalloc then
        l_delproc = yes.
      end. /* IF SEL_VAR_DEL */

      /* HIDE DELETE FRAME */
      hide frame m1 no-pause.
      view frame sample.

      /* HANDLE DELETE SELECTION */
      if valid_entry then do:
         delete_recid = recid(ship_line).
         kit_comp =  (ship_line.abs_par_id begins  "i").
         /* SUBTRACT WEIGHT FROM PARENTS */
         if sel_var_del <> 1 then do:
            assign
               original_nwt = ship_line.abs_nwt
               original_gwt = ship_line.abs_gwt.

            {absupack.i  "ship_line" 26 22 "l_abs_tare_wt"}

            if sel_var_del = 2 or sel_var_del = 4 then
               assign
                  l_twt_old = l_abs_tare_wt * -1
                  nwt_old = ship_line.abs_nwt * -1.
            else
               assign
                  l_twt_old = (ship_line.abs_gwt - ship_line.abs_nwt) * -1
                  nwt_old = ship_line.abs_nwt * -1.

            if (ship_line.abs_id begins "i" and sel_var_del = 2)
               or (sel_var_del = 3 or sel_var_del = 5 )
            then do:
               {gprun.i ""icshnwt.p""
                        "(input recid(ship_line),
                          input nwt_old,
                          input yes,
                          input ship_line.abs_wt_um)"}
            end. /* IF SHIP_LINE.ABS_ID BEGINS "I" ...*/

            {gprun.i ""icshnwt.p""
                     "(input recid(ship_line),
                       input l_twt_old,
                       input no,
                       input ship_line.abs_wt_um)"}

         end. /* SEL_VAR_DEL <> 1 */

         /* REMOVE CONTAINER RECORD OR DELETE CONTAINER RECORD */
         if (sel_var_del = 2 or sel_var_del = 4)
            and ship_line.abs_id begins "c"
         then do:
            for each abs_mstr
               where abs_mstr.abs_domain = global_domain
               and   abs_mstr.abs_shipfrom = ship_from
               and   abs_mstr.abs_par_id = ship_line.abs_id
            exclusive-lock:

               /* CHANGE PARENT POINTERS OF CHILD RECORDS */
               assign
                  abs_mstr.abs_par_id = ship_line.abs_par_id
                  abs_mstr.abs__qad06 =
                  string(integer(abs_mstr.abs__qad06) - 1,"9").

               /* ADJUST LEVELS OF CHILD RECORDS */
               {gprun.i ""rcctwbu3.p"" "(input recid(abs_mstr))"}
            end. /* for each abs_mstr */

            /* Delete custom shipper document information
             * associated with the record */
            {gprun.i ""sofsde.p"" "(input recid(ship_line))"}
         end. /* IF SEL_VAR_DEL = 2 OR 4 */

         /* REMOVE STRUCTURE OR DELETE STRUCTURE */
         if sel_var_del = 3 or sel_var_del = 5 then do:

            /* SET ALL CHILD RECORD SHIPTO'S TO ""      */
            /* FOR DELETES WILL ALLOW FIND NEXT TO FIND */
            /* THE CORRECT RECORD */
            {gprun.i ""rcctwbu2.p"" "(delete_recid)"}.
         end. /* if sel_var_del = 3 or 5 */

         if sel_var_del = 4 or sel_var_del = 5 then
            assign
               ship_line.abs_nwt = original_nwt
               ship_line.abs_gwt = original_gwt
               ship_line.abs_par_id = "".

         /* REMOVE RECORD - REMOVE STRUCTURE */
         if sel_var_del = 4 or sel_var_del = 5 then
            ship_line.abs_shipto = ship_line.abs__qad05.

         /* CHECK FOR NEXT RECORD */
         find next ship_line
            where ship_line.abs_domain = global_domain
            and   ship_line.abs_shipfrom = ship_from
            and   ship_line.abs_shipto begins tmp_prefix
         no-lock no-error.

         if available ship_line then
            abs_recid = recid(ship_line).
         else do:
            /* IF NO NEXT RECORD THEN FIND PREVIOUS RECORD */
            find ship_line
               where recid(ship_line) = delete_recid
            no-lock no-error.

            find prev ship_line
               where ship_line.abs_domain = global_domain
               and   ship_line.abs_shipfrom = ship_from
               and   ship_line.abs_shipto begins tmp_prefix
            no-lock no-error.

            if available ship_line then do:
               abs_recid = recid(ship_line).
               if save_frame_line > 1 then
                  save_frame_line = save_frame_line - 1.
            end. /* available ship_line */
            else
               /* NO RECORDS LEFT SO RESET */
               assign
                  abs_recid = ?
                  save_frame_line = 1.
         end. /* ELSE DO */

         if sel_var_del = 5 then do:

            /* DELETE ALLOCATIONS AND RESET THE SHIPPER SALES ORDER, */
            /* LINE AND PICK QTY.                                    */
            {gprun.i ""rcctwbu1.p""
                     "(input delete_recid,
                       input yes,
                       input no,
                       input l_delproc,
                       output undotran)"}

            if undotran then
               undo DEL_LOOP, retry DEL_LOOP.
         end. /* IF SEL_VAR_DEL = 5 */

         /* HANDLE DELETES */
         if sel_var_del = 2 or sel_var_del = 3 then do:

            find ship_line
               where recid(ship_line) = delete_recid
            exclusive-lock no-error.

            /* DELETE ABSR_DET RECORDS */
            if ship_line.abs_id begins "i" then do:
               {gprun.i ""rcdlabsr.p"" "(input delete_recid)"}

               /* DELETE SEQUENCES */
               run delete_sequences (input delete_recid).

               /* DELETE SHIPPER USER FIELDS AND LINE CHARGES */
               if using_line_charges or using_container_charges then
                  run delete_absl_absd_detail (input delete_recid).

               /* DELETE SHIPMENT PERFORMANCE REASON CODES */
               run delete_shipment_reasons
                  (input delete_recid).

            end.

            /* IF DELETE STRUCTURE THEN DELETE ALL CHILDREN */
            if sel_var_del = 3 then do:

               if using_container_charges or using_line_charges then
                  /* DELETE THE USER FIELDS FROM THE CONTAINER*/
                  run delete_absl_absd_detail (input delete_recid).

               /* DELETE ALL CHILD RECORDS */
               {gprun.i ""rcctwbu1.p""
                        "(input delete_recid,
                          input yes,   /* ALLOCATION */
                          input yes,   /* DELETE */
                          input l_delproc,
                          output undotran)"}

               if undotran then
                  undo DEL_LOOP, retry DEL_LOOP.

            end.

            /* IF DELETE KIT PARENT THEN DELETE ALL COMPONENTS */
            if sel_var_del = 2 and
               ship_line.abs_id begins "i"
            then do:
               /* CAN'T CHECK sod_det, SO MAY HAVE BEEN DELETED */
               find first abs_mstr
                  where abs_mstr.abs_domain = global_domain
                  and   abs_mstr.abs_shipfrom = ship_from
                  and   abs_mstr.abs_par_id = ship_line.abs_id
               no-lock no-error.
               if available abs_mstr then do:
                  /* DELETE ALL COMPONENT RECORDS */
                  /* ALLOCATION = YES & DELETE = YES                */
                  {gprun.i ""rcctwbu1.p""
                           "(input delete_recid,
                             input yes,
                             input yes,
                             input l_delproc,
                             output undotran)"}
                  if undotran then
                     undo DEL_LOOP, retry DEL_LOOP.
               end. /* available abs_mstr */

               del_lad = kit_comp.

           if not l_updalloc then
              l_ship_qty = ship_line.abs_qty.

               /* SET GLOBAL_DB USING ABS_SITE */
               new_site = ship_line.abs_site.
               {gprun.i ""gpalias.p""}

               /* SWITCH TO THE INVENTORY SITE */
               if so_db <> global_db then do:
                  {gprun.i ""gpalias2.p""
                           "(input ship_line.abs_site, output errornum)"}
                  if errornum <> 0 and errornum <> 9 then do:
                     /* DOMAIN # IS NOT AVAILABLE */
                     run p-pxmsg (input 6137,
                                  input 4,
                                  input l_msgar1[2]).
                     undo DEL_LOOP, retry DEL_LOOP.
                  end. /* if errornum <> 0 and 9 */
               end. /* if so_db <> global_db */

               /* CONVERTED - L_ABS_PICK_QTY TO INVENTORY UM */
               {gprun.i ""soitallb.p""
                        "(input ship_line.abs_order,
                          input ship_line.abs_line,
                          input ship_line.abs_item,
                          input ship_line.abs_site,
                          input ship_line.abs_loc,
                          input ship_line.abs_lotser,
                          input ship_line.abs_ref,
                          input - l_ship_qty *
                                decimal(ship_line.abs__qad03),
                          input - l_abs_pick_qty *
                                decimal(ship_line.abs__qad03),
                          input del_lad,
                          input l_delproc,
                          output avail_qty,
                          output tmp_qty,
                          output undotran)"}

               if undotran then
                  undo del_loop, retry del_loop.

               /* SWITCH BACK TO THE SALES ORDER DOMAIN */
               if so_db <> global_db then do:

                  /* UPDATE SALES ORDER DETAIL QTY ALL AND */
                  /* PICK IN REMOTE DOMAIN                 */
                  {gprun.i ""sosopka3.p""
                     "(input ship_line.abs_order,
                       input ship_line.abs_line,
                       input l_abs_pick_qty,
                       input ship_line.abs__qad03,
                       input l_delproc)"}

                  {gprun.i ""gpalias3.p"" "(input so_db, output errornum)"}

                  if errornum <> 0 and errornum <> 9 then do:
                     /* DOMAIN # IS NOT AVAILABLE */
                     run p-pxmsg (input 6137,
                                  input 4,
                                  input l_msgar1[1]).
                     undo DEL_LOOP, retry DEL_LOOP.
                  end. /* errornum <> 0 and 9 */
               end. /* if so_db <> global_db */

               find sod_det
                  where sod_det.sod_domain = global_domain
                  and   sod_nbr = ship_line.abs_order
                  and   sod_line = integer (ship_line.abs_line)
               no-lock no-error.

               if available sod_det
                  and sod_cfg_type <> "2"
               then do:
                  /* UPDATE DETAIL QTY ALL, QTY PICK */
                  /* CONVERTED - L_ABS_PICK_QTY TO INVENTORY UM */
                  {gprun.i ""sosopka2.p""
                           "(input ship_line.abs_order,
                             input integer (ship_line.abs_line),
                             input - l_abs_pick_qty * decimal(ship_line.abs__qad03),
                             input l_delproc)"}

                  if sod_sched then
                     sod_pickdate = ?.

                  find so_mstr
                     where so_domain = global_domain
                     and   so_nbr = sod_nbr
                  no-lock no-error.

                  if available so_mstr
                     and so_secondary
                  then
                     run create-so-cmf (input recid (sod_det)).
               end. /* available sod_det and sod_cfg ... */

               del_lad = no.

            end. /* if sel_var_del = 2 and id beings i */

            /* Delete custom shipper document information
             * associated with the record */
            {gprun.i ""sofsde.p"" "(input recid(ship_line))"}

            /* DELETE RECORD */
            for first clc_ctrl
               fields (clc_domain clc_lotlevel)
               where   clc_domain = global_domain
            no-lock: end.

            if  available clc_ctrl then do:

               if clc_lotlevel = 1 then do:
                  for each lotw_wkfl
                     where lotw_domain = global_domain
                     and   lotw_mfguser = mfguser
                     and   lotw_lotser  = ship_line.abs_lotser
                     and   lotw_part    = ship_line.abs_item
                  exclusive-lock:
                     delete lotw_wkfl.
                  end. /* FOR EACH lotw_wkfl */
               end.  /* IF clc_lotlevel */

               if clc_lotlevel = 2 then do:
                  for each lotw_wkfl
                     where lotw_domain = global_domain
                     and   lotw_mfguser = mfguser
                     and   lotw_lotser  = ship_line.abs_lotser
                  exclusive-lock:
                     delete lotw_wkfl.
                  end. /* FOR EACH lotw_wkfl */
               end. /* IF clc_lotlevel */

            end. /* IF AVAILABLE clc_ctrl */

            delete ship_line.

         end. /* if sel_var_del = 2 or 3 */

         if sel_var_del = 1 then do:

            find abs_parent_buff
               where abs_parent_buff.abs_domain = global_domain
               and   recid(abs_parent_buff) = parent_abs_recid
            no-lock.

            for each absc_det
               where absc_domain = global_domain
               and   absc_abs_id = abs_parent_buff.abs_id
            exclusive-lock:
               delete absc_det.
            end.

            if using_container_charges or using_line_charges then
               /* DELETE THE USER FIELDS FROM THE CONTAINER*/
               run delete_absl_absd_detail (input recid(abs_parent_buff)).

            for each ship_line
               where ship_line.abs_domain = global_domain
               and   ship_line.abs_shipfrom = ship_from
               and   ship_line.abs_shipto begins tmp_prefix
            exclusive-lock:
               if ship_line.abs_par_id begins "i" then
                  del_lad = yes.
               else
                  del_lad = no.

               if not l_updalloc then
              l_ship_qty = ship_line.abs_qty.
        
               {absupack.i  "ship_line" 3 22 "l_abs_pick_qty"}

               if ship_line.abs_id begins "C"
               or ship_line.abs_id begins "I"
               then do:

                  /* SET GLOBAL_DB USING ABS_SITE */
                  new_site = ship_line.abs_site.
                  {gprun.i ""gpalias.p""}

                  /* SWITCH TO THE INVENTORY SITE */
                  if so_db <> global_db then do:
                     {gprun.i ""gpalias2.p""
                              "(input ship_line.abs_site, output errornum)"}

                      if errornum <> 0 and errornum <> 9 then do:
                        /* DOMAIN # IS NOT AVAILABLE */
                        run p-pxmsg (input 6137,
                                     input 4,
                                     input l_msgar1[2]).
                        undo DEL_LOOP, retry DEL_LOOP.
                     end. /* errornum <> 0 or 9 */
                  end. /* if so_db <> global_db */

                  /* DELETE ALLOCATION */

                  /* CONVERTED - L_ABS_PICK_QTY TO INVENTORY UM */
                  {gprun.i ""soitallb.p""
                           "(input ship_line.abs_order,
                             input ship_line.abs_line,
                             input ship_line.abs_item,
                             input ship_line.abs_site,
                             input ship_line.abs_loc,
                             input ship_line.abs_lotser,
                             input ship_line.abs_ref,
                             input - l_ship_qty *
                                   decimal(ship_line.abs__qad03),
                             input - l_abs_pick_qty *
                                   decimal(ship_line.abs__qad03),
                             input del_lad,
                             input l_delproc,
                             output avail_qty,
                             output tmp_qty,
                             output undotran)"}

                  if undotran then
                     undo del_loop, retry del_loop.

                  del_lad = no.

                  /* SWITCH BACK TO THE SALES ORDER DOMAIN */
                  if so_db <> global_db then do:

                     /* UPDATE SALES ORDER DETAIL QTY ALL AND */
                     /* PICK IN REMOTE DOMAIN                 */
                     {gprun.i ""sosopka3.p""
                        "(input ship_line.abs_order,
                          input ship_line.abs_line,
                          input l_abs_pick_qty,
                          input ship_line.abs__qad03,
                          input l_delproc)"}

                     {gprun.i ""gpalias3.p"" "(so_db, output errornum)"}
                     if errornum <> 0 and errornum <> 9 then do:
                        /* DOMAIN # IS NOT AVAILABLE */
                        run p-pxmsg (input 6137,
                                     input 4,
                                     input l_msgar1[1]).
                        undo DEL_LOOP, retry DEL_LOOP.
                     end. /* if errornum <> 0 or 9 */
                  end. /* if so_db <> global_db */
               end. /* IF ship_line.abs_id BEGINS "C" ... */

               /* UPDATE ALLOCATION, PICK, AND SEND CMF MSG  */
               find sod_det
                  where sod_domain = global_domain
                  and   sod_nbr = ship_line.abs_order
                  and   sod_line = integer (ship_line.abs_line)
               no-lock no-error.

               if available sod_det
                  and sod_cfg_type <> "2"
               then do:
                  /* CONVERTED - L_ABS_PICK_QTY TO INVENTORY UM */
                  {gprun.i ""sosopka2.p""
                           "(input ship_line.abs_order,
                             input integer (ship_line.abs_line),
                             input - l_abs_pick_qty * decimal(ship_line.abs__qad03),
                             input l_delproc)"}

                  find so_mstr
                     where so_domain = global_domain
                     and   so_nbr = sod_nbr
                  no-lock no-error.

                  if available so_mstr
                     and so_secondary
                  then
                     run create-so-cmf (input recid (sod_det)).

                  if sod_sched then
                     sod_pickdate = ?.

               end. /* if available sod_det and ... */

               /* DELETE ABSR_DET RECORDS */
               if ship_line.abs_id begins "i"
               then do:
                  {gprun.i ""rcdlabsr.p""
                           "(input recid(ship_line))"}

                  /* DELETE SEQUENCES */
                  run delete_sequences
                     (input recid(ship_line)).

                  /* DELETE SHIPPER USER FIELDS AND LINE CHARGES */
                  if using_line_charges or using_container_charges then
                     run delete_absl_absd_detail (input recid(ship_line)).

                 /* DELETE SHIPMENT PERFORMANCE REASON CODES */
                 run delete_shipment_reasons
                    (input recid(ship_line)).

               end. /* abs_id begins "i" */

               /* Delete custom shipper document information
                * associated with the record */
               {gprun.i ""sofsde.p"" "(input recid(ship_line))"}

               for each lotw_wkfl
                  where lotw_domain = global_domain
                  and   lotw_mfguser = mfguser
               exclusive-lock:
                  delete lotw_wkfl.
               end.

               {gprun.i ""nrm.p"" " " "persistent set h_nrm"}

               /* RECORD CREATION IN nrh_hist WITH ACTION AS 'VOID' AFTER */
               /* DELETION OF SHIPPER */
               run nr_void_value in h_nrm(input ship_line.abs_nr_id,
                                          input substring(ship_line.abs_id,2),
                                          input " ").

               /* TO RELEASE THE LOCK ON nr_mstr/nrh_hist HELD BY THE HANDLE */
               delete procedure h_nrm no-error.

               delete ship_line.

            end. /* for each ship_line */

            assign
               abs_recid = ?
               save_frame_line = 1.

         end. /* sel_var_del = 1 */
         /* REPAINT THE SCREEN WITH NEW RECORDS */
         refresh = true.

      end. /* IF VALID_ENTRY */
   end. /* del_loop */

END PROCEDURE. /* delete_proc */

PROCEDURE add_proc:
   define output parameter next_editloop as logical no-undo.
   define output parameter next_mainloop as logical no-undo.
   define output parameter leave_editloop as logical no-undo.

   if not v_editall then do:
      {pxmsg.i &MSGNUM=5811 &ERRORLEVEL=3}
      /* Selection only available for */
      /* unconfirmed, non-SO shippers */
      next_editloop = yes.
      return.
   end.  /* if not v_editall */

   /* ALLOW ADDING COMPONENT TO A KIT ITEM  */
   if ship_line.abs_id begins "i" and
      (not available sod_det or
      ((sod_det.sod_cfg_type <> "2" or sod_det.sod_type <> "" or
      ship_line.abs_item <> sod_det.sod_part)))
   then do:
      {pxmsg.i &MSGNUM=13 &ERRORLEVEL=3} /* NOT A VALID SELECTION */
      next_editloop = yes.
      return.
   end.

   color display input first_column with frame k.

   /* DISPLAY F3 ADD OPTIONS FRAME */
   hide frame sample no-pause.
   view frame m.

   assign
      valid_entry = false
      sel_var_add = 1
      save_frame_line = frame-line(k).

   /* GET USER SELECTION */
   GET_SELECTION_2:
   do on endkey undo GET_SELECTION_2, leave GET_SELECTION_2
      on error undo GET_SELECTION_2, retry GET_SELECTION_2:

      /* PLEASE SELECT A FUNCTION */
      {pxmsg.i &MSGNUM=39 &ERRORLEVEL=1
               &CONFIRM=sel_var_add
               &CONFIRM-TYPE='NON-LOGICAL'}

      if (sel_var_add < 1 or sel_var_add > 4)
         or (sel_var_add <> 1 and ship_line.abs_id begins "i")
      then do:
         {pxmsg.i &MSGNUM=13 &ERRORLEVEL=3} /* NOT A VALID CHOICE */
         undo GET_SELECTION_2, retry GET_SELECTION_2.
      end. /* if sel_var_add < 1 ... */

      valid_entry = true.
   end. /* get_selection_2 */

   /* HIDE FRAMES FOR ADD */
   hide frame m no-pause.
   hide frame sample no-pause.
   hide frame k no-pause.

   if batchrun and
      (lastkey = keycode("F4") or
      keyfunction(lastkey) = "END-ERROR" or
      keyfunction(lastkey) = "ENDKEY" or
      keyfunction(lastkey) = "."    or
      lastkey = keycode("CTRL-E"))
   then do:
      leave_editloop = yes.
      return.
   end. /* IF BATCHRUN AND */

   /* PROCESS F3 ADD SELECTION */
   if valid_entry then do:

      /*** TRUTH TABLE - SEL_VAR */
      /*               1  2  3   */
      /*                         */
      /* ADD_ITEM      T  F  T   */
      /* ADD_CONTAINER F  T  T   */
      /* ADD_PARENT    F  F  T   */
      /***************************/

      assign
         abs_recid = recid(ship_line)
         add_container = true
         add_item = true
         add_existing_container = true
         add_parent_container = true.

      /* ADD AN ITEM RECORD */
      if sel_var_add = 1 then
         assign
            add_container = false
            add_existing_container = false
            add_parent_container = false.

      /* ADD A CONTAINER RECORD */
      if sel_var_add = 2 then
         assign
            add_item = false
            add_existing_container = false
            add_parent_container = false.

      if sel_var_add = 3 then
         add_existing_container = false.

      if sel_var_add = 4 then
         assign
            add_item = false
            add_parent_container = false
            add_container = false.

      create_recs = true.
      assign next_mainloop = yes.
      return.
   end. /* IF VALID ENTRY */
END PROCEDURE. /* add_proc */

PROCEDURE navigate_proc:
   define variable n as integer no-undo.
   define variable loopMax as integer no-undo.

   if (keyfunction(lastkey) = "page-down" or
       lastkey = keycode("F8"))
   then do with frame k:

      loopMax = frame-down - frame-line + 1.

      PAGEDOWNLOOP:
      do n = 1 to loopMax:

         if l_absso_recid <> ? then
            find first ship_line
               where recid(ship_line) = l_absso_recid
            no-lock no-error.

         find next ship_line
            where ship_line.abs_domain = global_domain
            and   ship_line.abs_shipfrom = ship_from
            and   ship_line.abs_shipto begins tmp_prefix
         exclusive-lock no-error.

         if available ship_line then
            l_absso_recid = recid(ship_line).

         if not available ship_line then do:
            find last ship_line
               where ship_line.abs_domain = global_domain
               and   ship_line.abs_shipfrom = ship_from
               and   ship_line.abs_shipto >= tmp_prefix
               and   ship_line.abs_shipto <= tmp_prefix  + fill(hi_char,8)
            exclusive-lock no-error.

            leave PAGEDOWNLOOP.
         end.
      end.

      run findSalesOrderDet.

      if available ship_line
         and can-find(first absl_det
         where absl_domain = global_domain
         and   absl_abs_id = ship_line.abs_id
         and   absl_abs_shipfrom = ship_line.abs_shipfrom)
       then
         /*ADDITIONAL LINE CHARGES EXIST FOR THIS LINE ITEM*/
         run p-pxmsg (input 4457,
                      input 1,
                      input "").
      assign
         save_frame_line = 1
         abs_recid = recid(ship_line)
         refresh = yes.

      return.

   end. /* If (keyfunction(lastkey) = "page-down" or ... */

   if (keyfunction(lastkey) = "page-up" or
       lastkey = keycode("F7"))
   then do with frame k:

      loopMax = frame-line - 1 + frame-down.

      PAGEUPLOOP:
      do n = 1 to loopMax:

         if l_absso_recid <> ? then
            find first ship_line
               where recid(ship_line) = l_absso_recid
            no-lock no-error.

         find prev ship_line
            where ship_line.abs_domain = global_domain
            and   ship_line.abs_shipfrom = ship_from
            and   ship_line.abs_shipto begins tmp_prefix
         exclusive-lock no-error.

         if available ship_line then
            l_absso_recid = recid(ship_line).

         if not available ship_line then do:
            find first ship_line
               where ship_line.abs_domain = global_domain
               and   ship_line.abs_shipfrom = ship_from
               and   ship_line.abs_shipto begins tmp_prefix
            exclusive-lock no-error.

            leave PAGEUPLOOP.
         end.
      end.

      run findSalesOrderDet.

      if available ship_line
         and can-find(first absl_det
         where absl_domain = global_domain
         and   absl_abs_id = ship_line.abs_id
         and absl_abs_shipfrom = ship_line.abs_shipfrom)
      then
         /*ADDITIONAL LINE CHARGES EXIST FOR THIS LINE ITEM*/
         run p-pxmsg (input 4457,
                      input 1,
                      input "").

      assign
         save_frame_line = 1
         abs_recid = recid(ship_line)
         refresh = yes.

      return.

   end. /* If (keyfunction(lastkey) = "page-up" or ... */


   /* HANDLE CURSOR MOVEMENT UP */
   if (lastkey = keycode("F9")
      or keyfunction(lastkey) = "CURSOR-UP")
   then do:

      if l_absso_recid <> ? then
         find first ship_line
            where recid(ship_line) = l_absso_recid
         no-lock no-error.

      /* MOVE UP ONE LINE IN SCROLLING WINDOW */
      find prev ship_line
         where ship_line.abs_domain = global_domain
         and   ship_line.abs_shipfrom = ship_from
         and   ship_line.abs_shipto begins tmp_prefix
      exclusive-lock no-error.

      if available ship_line then do:
         l_absso_recid = recid(ship_line).

         run findSalesOrderDet.

         up 1 with frame k.

         /* SET UP DISP_LINE */
         {rcshwbb1.i}

         display
            fill(".",minimum(4,integer(ship_line.abs__qad06)))
            + ship_line.abs__qad06
            @ first_column
            disp_line
         with frame k.

         if can-find(first absl_det
            where absl_det.absl_domain = global_domain
            and   absl_abs_id = ship_line.abs_id
            and  absl_abs_shipfrom = ship_line.abs_shipfrom)
         then
            /*ADDITIONAL LINE CHARGES EXIST FOR THIS LINE ITEM*/
            run p-pxmsg (input 4457,
                         input 1,
                         input "").
      end.
      else do:
         /* NO RECORD FOUND */
         find first ship_line
            where ship_line.abs_domain = global_domain
            and   ship_line.abs_shipfrom = ship_from
            and   ship_line.abs_shipto begins tmp_prefix
         exclusive-lock no-error.

         bell.

         if can-find(first absl_det
            where absl_det.absl_domain = global_domain
            and   absl_abs_id = ship_line.abs_id
            and   absl_abs_shipfrom = ship_line.abs_shipfrom)
         then
            /*ADDITIONAL LINE CHARGES EXIST FOR THIS LINE ITEM*/
            run p-pxmsg (input 4457,
                         input 1,
                         input "").
      end.
   end. /* IF LASTKEY = F9 */

   /* HANDLE CURSOR MOVEMENT DOWN */
   if (lastkey = keycode("F10")
      or keyfunction(lastkey) = "CURSOR-DOWN")
   then do:

      if l_absso_recid <> ? then
         find first ship_line
            where recid(ship_line) = l_absso_recid
         no-lock no-error.

      /* MOVE DOWN ONE LINE IN SCROLLING WINDOW */
      find next ship_line
         where ship_line.abs_domain = global_domain
         and   ship_line.abs_shipfrom = ship_from
         and   ship_line.abs_shipto begins tmp_prefix
      exclusive-lock no-error.

      if available ship_line then do:
         l_absso_recid = recid(ship_line).

         run findSalesOrderDet.

         down 1 with frame k.

         if can-find(first absl_det  where absl_det.absl_domain = global_domain
         and  absl_abs_id = ship_line.abs_id
                     and absl_abs_shipfrom = ship_line.abs_shipfrom)
         then /*ADDITIONAL LINE CHARGES EXIST FOR THIS LINE ITEM*/
            run p-pxmsg (input 4457,
                         input 1,
                         input "").

         /* SET UP DISP_LINE */
         {rcshwbb1.i}

         display
            fill(".",minimum(4,integer(ship_line.abs__qad06)))
            + ship_line.abs__qad06
            @ first_column
            disp_line
         with frame k.
      end.

      else do:

         /* NO RECORD FOUND */
         find last ship_line
            where ship_line.abs_domain = global_domain
            and   ship_line.abs_shipfrom = ship_from
            and   ship_line.abs_shipto >= tmp_prefix
            and   ship_line.abs_shipto <= tmp_prefix + fill(hi_char,8)
         exclusive-lock no-error.

         bell.

      end.
   end. /* IF LASTKEY = F10 */
END PROCEDURE. /* navigate_proc */

PROCEDURE p_clean_up:

   define input parameter l_shpfrm  like abs_shipfrom no-undo.
   define input parameter l_tmpprfx as   character    no-undo.

   for each ship_line
      where ship_line.abs_domain = global_domain
      and   ship_line.abs_shipfrom    = l_shpfrm
      and   ship_line.abs_shipto begins l_tmpprfx
   exclusive-lock:

      ship_line.abs_shipto = ship_line.abs__qad05.
   end.

end. /* PROCEDURE p_clean_up */

PROCEDURE p_update_alloc:
   /* THIS PROCEDURE IS USED FOR UPDATING THE LD_DET AND LAD_DET   */
   /* WHEN THE SALES ORDER IS CHANGED.                             */

   /* LOCAL VARIABLES */
   define variable l_adj_qty  like ld_qty_all   no-undo.
   define variable l_sod_all  like sod_qty_all  no-undo.

   /* THE PROGRAM SOITALLD.P WHICH IS USED FOR UPDATING THE  */
   /* LAD_DET AND LD_DET FOR CHANGE IN ALLOCATION AND PICK.  */
   /* CANNOT BE USED FOR CREATING THE DETAIL ALLOCATIONS FOR */
   /* CHANGE IN SO, SINCE IT ONLY UPDATES THE EXISTING LAD_DET */
   /* IF CHANGE IN SHIP AND PICK ARE BOTH NON ZERO. AND DOESNT */
   /* CREATE ONE IF NONE EXIST. WE HANDLE THIS BY USING 2 CALLS */
   /* TO SOITALLA.P, ONE TO CREATE AN LAD_DET WITH PICK = SHIP. */
   /* AND THE SECOND TO ADJUST THE PICK QTY.                    */

   /* SET GLOBAL_DB USING ABS_SITE */
   new_site = ship_line.abs_site.
   {gprun.i ""gpalias.p""}

   /* SWITCH TO THE INVENTORY SITE */
   if so_db <> global_db then do:
      {gprun.i ""gpalias2.p""
               "(input  ship_line.abs_site,
                 output errornum)"}

      if errornum <> 0 and errornum <> 9 then do:
         /* DOMAIN # IS NOT AVAILABLE */
         run p-pxmsg (input 6137,
                      input 4,
                      input l_msgar1[2]).
         undotran = yes.
         return.
      end. /* IF ERRORNUM <> 0 ... */
   end. /* IF SO_DB <> GLOBAL_DB */

   /* DO THE GENERAL ALLOCATIONS */
   for first soc_ctrl
      fields (soc_domain soc_all_days)
      where   soc_domain = global_domain
   no-lock:
   end.

   {gprun.i ""soitallc.p""
            "(input ship_line.abs_order,
              input integer(ship_line.abs_line),
              input soc_all_days,
              input ship_line.abs_qty *
                    decimal(ship_line.abs__qad03) / sod_det.sod_um_conv,
              output l_sod_all)"}

   /* CREATE DETAIL ALLOCATIONS */
   {gprun.i ""soitalla.p""
            "(input ship_line.abs_order,
              input ship_line.abs_line,
              input ship_line.abs_item,
              input ship_line.abs_site,
              input ship_line.abs_loc,
              input ship_line.abs_lotser,
              input ship_line.abs_ref,
              input ship_line.abs_qty * decimal(ship_line.abs__qad03),
              input 0,
              output adj_qty,
             output undotran)"}

   /* ADJUST THE PICK QTY IF NECESSARY*/
   if l_abs_pick_qty <> ship_line.abs_qty
      and not undotran
   then do:
      {gprun.i ""soitalla.p""
               "(input ship_line.abs_order,
                 input ship_line.abs_line,
                 input ship_line.abs_item,
                 input ship_line.abs_site,
                 input ship_line.abs_loc,
                 input ship_line.abs_lotser,
                 input ship_line.abs_ref,
                 input (l_abs_pick_qty - ship_line.abs_qty) *
                       decimal(ship_line.abs__qad03),
                 input 0,
                 output l_adj_qty,
                 output undotran)"}

   end. /* IF L_ABS_PICK_QTY <> SHIP_LINE.ABS_QTY  */

   assign
      adj_qty    = adj_qty     + l_adj_qty.

   /* SWITCH BACK TO THE SALES ORDER DOMAIN */
   if so_db <> global_db then do:

      /* UPDATE SALES ORDER DETAIL QTY ALL AND PICK */
      /* IN REMOTE DOMAIN                         */
      if not kit_comp then do:
         {gprun.i ""sosopka2.p""
                  "(input ship_line.abs_order,
                    input integer (ship_line.abs_line),
                    input l_abs_pick_qty
                          * decimal(ship_line.abs__qad03),
                    input l_delproc)"}
      end. /* IF NOT KIT_COMP */

      {gprun.i ""gpalias3.p"" "(input so_db, output errornum)"}

      if errornum <> 0 and errornum <> 9 then do:
         /* DOMAIN # IS NOT AVAILABLE */
         run p-pxmsg (input 6137,
                      input 4,
                      input l_msgar1[1]).
         undotran = yes.
         return.
      end. /* IF ERRORNUM <> 0 ... */
   end. /* IF SO_DB <> GLOBAL_DB */

   if undotran then
      return.

   /* UPDATE THE SALES ORDER QTY ALL, QTY PICK */
   if not kit_comp then do:

      /* IF GENERAL ALLOCATIONS WERE DONE PREVIOUSLY THEN UPDATE */
      /* THE SOD_QTY_ALL IN THE CENTRAL DOMAIN BEFORE ADJUSTMENT OF  */
      /* THE PICK QTY BY SOSOPKA2.P.                             */
      if sod_det.sod_qty_all = 0 then do:
         find sod_det
            where sod_domain = global_domain
            and   sod_nbr  = ship_line.abs_order
            and   sod_line = integer(ship_line.abs_line)
         exclusive-lock.

         assign
            sod_qty_all = l_sod_all.

         find sod_det
            where sod_domain = global_domain
            and  sod_nbr  = ship_line.abs_order
            and  sod_line = integer(ship_line.abs_line)
         no-lock.
      end. /* IF SOD_DET.SOD_QTY_ALL = 0 */

      /* UPDATE THE SO QTY PICKED */
      {gprun.i ""sosopka2.p""
               "(input ship_line.abs_order,
                 input integer (ship_line.abs_line),
                 input l_abs_pick_qty
                       * decimal(ship_line.abs__qad03),
                 input l_delproc)"}

   end. /* IF NOT KIT_COMP */
END PROCEDURE. /* P_UPDATE_ALLOC */

PROCEDURE p_update_alloc1:
   /* THIS PROCEDURE IS USED FOR UPDATING THE LD_DET AND LAD_DET   */
   /* WHEN THE SHIP AND/OR PICK QTY IS CHANGED.                    */

   /* SET GLOBAL_DB USING ABS_SITE */
   new_site = ship_line.abs_site.
   {gprun.i ""gpalias.p""}

   /* SWITCH TO THE INVENTORY SITE */
   if so_db <> global_db then do:
      {gprun.i ""gpalias2.p""
               "(input  ship_line.abs_site,
                 output errornum)"}

      if errornum <> 0 and errornum <> 9 then do:
         /* DOMAIN # IS NOT AVAILABLE */
         run p-pxmsg (input 6137,
                      input 4,
                      input l_msgar1[2]).
         undotran = yes.
         return.
      end. /* IF ERRORNUM <> 0 ... */
   end. /* IF SO_DB <> GLOBAL_DB */

   if (qty_old = ship_line.abs_qty)
      and (old_qty <> l_abs_pick_qty)
   then do:

      {gprun.i ""soitalla.p""
               "(input ship_line.abs_order,
                 input ship_line.abs_line,
                 input ship_line.abs_item,
                 input old_site,
                 input old_loc,
                 input old_lot,
                 input old_ref,
                 input (l_abs_pick_qty - old_qty) *
                       decimal(ship_line.abs__qad03),
                 input (ship_line.abs_qty - old_qty) *
                       decimal(ship_line.abs__qad03),
                 output adj_qty,
                 output undotran)"}

   end. /* IF QTY_OLD = SHIP_LINE.ABS_QTY AND ... */
   else do:
      {gprun.i ""soitalld.p""
               "(input ship_line.abs_order,
                 input ship_line.abs_line,
                 input ship_line.abs_item,
                 input old_site,
                 input old_loc,
                 input old_lot,
                 input old_ref,
                 input (l_abs_pick_qty - old_qty )*
                       decimal(ship_line.abs__qad03),
                 input (ship_line.abs_qty - qty_old) *
                       decimal(ship_line.abs__qad03),
                 input qty_old * decimal(ship_line.abs__qad03),
                 input del_lad,
                 output adj_qty,
                 output undotran)"}

   end. /*  ELSE DO */

   /* SWITCH BACK TO THE SALES ORDER DOMAIN */
   if so_db <> global_db then do:

      /* UPDATE SALES ORDER DETAIL QTY ALL AND PICK */
      /* IN REMOTE DOMAIN                         */
      if not kit_comp then do:
         {gprun.i ""sosopka2.p""
                  "(input ship_line.abs_order,
                    input integer (ship_line.abs_line),
                    input adj_qty,
                    input l_delproc)"}

      end. /* IF NOT KIT_COMP */

      {gprun.i ""gpalias3.p"" "(input so_db, output errornum)"}

      if errornum <> 0 and errornum <> 9 then do:
         /* DOMAIN # IS NOT AVAILALBE */
         run p-pxmsg (input 6137,
                      input 4,
                      input l_msgar1[1]).
         undotran = yes.
         return.
      end. /* IF ERRORNUM <> 0 ... */
   end. /* IF SO_DB <> GLOBAL_DB */

   if undotran then
      return.

   /* UPDATE THE SALES ORDER QTY ALL, QTY PICK */
   if not kit_comp then
      {gprun.i ""sosopka2.p""
               "(input ship_line.abs_order,
                 input integer (ship_line.abs_line),
                 input adj_qty,
                 input l_delproc)"}

END PROCEDURE. /* P_UPDATE_ALLOC1 */

PROCEDURE ip-refresh:

   /* THIS PROCEDURE REFRESHES THE LOWER SCREEN WHEN ENDKEY  */
   /* IS PRESSED                                             */
   display
      ship_line.abs_order @ part_order
      ship_line.abs_line @ part_order_line
      qty_old @ ship_line.abs_qty
      old_qty @ l_abs_pick_qty
      l_twt_old @ l_abs_tare_wt
      ship_line.abs_wt_um @ l_twt_um
      ship_line.abs__qad02
      old_site @ ship_line.abs_site
      old_loc @ ship_line.abs_loc
      nwt_old @ ship_line.abs_nwt
      ship_line.abs_wt_um
      old_lot @ ship_line.abs_lot
      ship_line.abs_gwt
      ship_line.abs_wt_um @ gwt_um
      old_ref @ ship_line.abs_ref
      sod_det.sod_type when (available sod_det)
      "" when (not available sod_det) @ sod_type
      vol_old @ ship_line.abs_vol
      ship_line.abs_vol_um
      cnsm_req
      pt_mstr.pt_desc1 when (available pt_mstr)
      "" when (not available pt_mstr) @ pt_desc1
      sod_det.sod_contr_id when (available sod_det)
      "" when (not available sod_det) @ sod_contr_id
      cmmts
      cancel_bo
      ship_line.abs_fa_lot
      ship_line.abs__chr01 
      ship_line.abs__chr02 /*xp001*/
   with frame sample.
END PROCEDURE. /* PROCEDURE IP-REFRESH */

PROCEDURE maintain_sequences:
   define input parameter l_abs_id  like abs_id no-undo.
   define input parameter l_shipfrom like abs_shipfrom no-undo.

   for first abs_mstr
      where abs_mstr.abs_domain = global_domain
      and   abs_id = l_abs_id
      and   abs_shipfrom = l_shipfrom
   no-lock: end.

   if available (abs_mstr) then do:
      /* IS CUST. SEQ. SCHEDULES INSTALLED ? */
      if can-find (mfc_ctrl  where mfc_ctrl.mfc_domain = global_domain and
         mfc_field = "enable_sequence_schedules" and
         mfc_logical) and rcf_file_found then do:

         for first so_mstr
            where so_domain = global_domain
            and   so_nbr = abs_order
         no-lock:

            if so_seq_order then do:

               /* MAINTAIN SEQUENCES FOR abs_mstr */
               {gprunmo.i &program = ""rcabssup.p"" &module = "ASQ"
                          &param   = """(input l_abs_id,
                                         input l_shipfrom,
                                         input "yes")"""}

               /*PUT THE STATUS LINE BACK */
               status input stline[13].
            end. /* IF so_seq_order */
         end.  /* FOR FIRST so_mstr */
      end. /* if can-find */
   end. /* if available */
END PROCEDURE.  /* maintain_sequences */

PROCEDURE delete_sequences:
   define input parameter l_recid  as recid no-undo.

   for first abs_mstr
      where abs_mstr.abs_domain = global_domain
      and   recid(abs_mstr) = l_recid
   no-lock:
      /* IS CUST. SEQ. SCHEDULES INSTALLED ? */
      if can-find (mfc_ctrl
         where mfc_ctrl.mfc_domain = global_domain
         and   mfc_field = "enable_sequence_schedules"
         and   mfc_logical) and rcf_file_found
      then do:

         /* DELETE SEQUENCES */
         {gprunmo.i &program = ""rcabssdl.p"" &module = "ASQ"
                    &param   = """(input l_recid, input '')"""}
      end. /* if can-find */
   end. /* for first abs_mstr */
END PROCEDURE.  /* delete_sequences */

PROCEDURE check_tablename:
   define input parameter l_tablename as character no-undo.
   define output parameter l_file_found like mfc_logical  no-undo.

   /* VARIABLE DEFINITIONS FOR gpfile.i */
   {gpfilev.i}

   {gpfile.i &file_name = l_tablename}
   l_file_found = file_found.

END PROCEDURE.  /* check_tablename */

PROCEDURE p-pxmsg:
   define input parameter p_num     as integer   no-undo.
   define input parameter p_stat    as integer   no-undo.
   define input parameter p_msgarg1 as character no-undo.

   {pxmsg.i &MSGNUM  = p_num  &ERRORLEVEL = p_stat
            &MSGARG1 = p_msgarg1}

END PROCEDURE. /* PROCEDURE p-pxmsg */

PROCEDURE p-pxmsgconfirm:
   define input parameter p_num     as integer   no-undo.
   define input parameter p_stat    as integer   no-undo.
   define input-output parameter p_confirm like mfc_logical no-undo.

   {pxmsg.i &MSGNUM  = p_num  &ERRORLEVEL = p_stat
            &CONFIRM = p_confirm}

END PROCEDURE. /* PROCEDURE p-pxmsgconfirm */

PROCEDURE p-pxmsg1:
   define input parameter p_num     as integer   no-undo.
   define input parameter p_stat    as integer   no-undo.
   define input parameter p_msgarg1 as character no-undo.
   define input parameter p_msgarg2 as character no-undo.

   {pxmsg.i &MSGNUM  = p_num  &ERRORLEVEL = p_stat
            &MSGARG1 = p_msgarg1
            &MSGARG2 = p_msgarg2}

END PROCEDURE. /* PROCEDURE p-pxmsg1 */

PROCEDURE p-alloclad:
/* ACCUMULATE lad_qty_all FOR ALL SHIPPERS FOR PART */

   l_lad_qty_all = 0.
   for each lad_det
       fields (lad_domain lad_dataset lad_line lad_loc lad_lot lad_nbr
               lad_part lad_qty_all lad_qty_pick lad_ref lad_site)
       where   lad_domain = global_domain
       and     lad_site   = ship_line.abs_site
       and lad_loc        = ship_line.abs_loc
       and lad_part       = ship_line.abs_item
       and lad_lot        = ship_line.abs_lot
       and lad_ref        = ship_line.abs_ref
   no-lock:
       l_lad_qty_all     = l_lad_qty_all + lad_qty_all.
   end. /* FOR EACH lad_det */

END PROCEDURE. /* PROCEDURE p-alloclad */

PROCEDURE ValidateSalesOrderLine:
   define input parameter ipOrder like abs_order no-undo.
   define input parameter ipOrderLine like abs_line no-undo.
   define input parameter ipShipFrom like abs_shipfrom no-undo.
   define input parameter ipShipTo like abs_shipto no-undo.
   define output parameter opErrorOrder like mfc_logical no-undo.
   define output parameter opErrorOrderLine like mfc_logical no-undo.
   define output parameter opErrorNumber as integer no-undo.
   define output parameter opErrorSite like sod_site no-undo.

   for first so_mstr
      where so_domain = global_domain
      and   so_nbr = part_order
   no-lock: end.

   if not available so_mstr then
      assign
         opErrorOrder = yes
         opErrorNumber = 609. /*SALES ORDER DOESN'T EXIST*/
   else do:

      for first ad_mstr
         fields (ad_domain ad_addr)
         where ad_domain = global_domain
         and   ad_addr   = ipShipTo no-lock:
      end. /* FOR FIRST ad_mstr */

      for first ls_mstr
         fields (ls_domain ls_addr ls_type)
         where ls_domain = global_domain
         and   ls_addr   = ad_addr
         and  (ls_type   = "ship-to" or
               ls_type   = "customer") no-lock:
      end. /* FOR FIRST ls_mstr */

      do while not available ls_mstr
         and ad_ref > "":

         l_addr = ad_ref.

         for first ad_mstr
            fields (ad_domain ad_addr)
            where ad_domain = global_domain
            and   ad_addr   = l_addr no-lock:
         end. /* FOR FIRST ad_mstr */

         for first ls_mstr
            fields (ls_domain ls_addr ls_type)
            where ls_domain = global_domain
            and   ls_addr   = ad_addr
            and  (ls_type   = "ship-to" or
                  ls_type   = "customer") no-lock:
         end. /* FOR FIRST ls_mstr */
      end. /* DO WHILE NOT AVAIL ls_mstr */

      l_ship_id = ad_addr.

      if (so_ship <> ipShipTo) and
         (so_ship <> l_ship_id)
      then do:
         assign
            opErrorOrder = yes
            opErrorSite = so_ship
            opErrorNumber = 8229. /*INVALID ORDER SHIP-TO*/
         leave.
      end.

      for first sod_det
         where sod_domain = global_domain
         and   sod_nbr = so_nbr
         and   sod_line = integer(ipOrderLine)
      no-lock: end.

      if not available sod_det then do:
         assign
            opErrorOrderLine = yes
            opErrorNumber = 764. /*SALES ORDER LINE DOESNT EXIST*/
        leave.
      end.
      if sod_site <> ipShipFrom then do:
         assign
            opErrorOrder = yes
            opErrorSite = sod_site
            opErrorNumber = 8228. /*INVALID ORDER SHIPFROM SITE*/
         leave.
      end.
   end.

END PROCEDURE.

PROCEDURE delete_absl_absd_detail:
   define input parameter ipAbsRecID as recid no-undo.

   if can-find (first abs_mstr
      where abs_domain = global_domain
      and   recid(abs_mstr) = ipAbsRecID)
   then do:

      /* DELETE SHIPPER USER FIELDS AND LINE CHARGES */
      {gprunmo.i &program = "rcabsdd.p" &module = "ACL"
                 &param   = """(input ipAbsRecID)"""}
   end. /* IF CAN-FIND abs_mstr */

END PROCEDURE.

PROCEDURE getUserFieldData:
   define input parameter ipSpecificField like mfc_logical.
   define input parameter ipFieldName as character.
   define input parameter ipAbsID like abs_id.
   define input parameter ipShipfrom like abs_shipfrom.

   if can-find(first absd_det
      where absd_det.absd_domain = global_domain
      and   absd_abs_id = ipAbsID
      and   absd_shipfrom = ipShipfrom
      and   absd_abs_fld_name = (if ipSpecificField then
                                    ipFieldName else "")
      and absd_fld_prompt = yes)
   then do:

      {gprunmo.i &program = ""rcswbuf.p"" &module = "ACL"
                 &param  = """(input ipSpecificField,
                               input ipFieldName,
                               input ipAbsID,
                               input ipShipfrom)"""}
   end. /*IF CAN-FIND*/

END PROCEDURE. /*getUserFieldData*/

PROCEDURE getLineCharges:
   /* PARAMETERS
    * ipShipfrom - Site Address
    * ipAbsID - abs_id from ship_line
    * ipSoRecno - recid for so_mstr
    * ipSodRecno - recid for sod_det
    */
   define input parameter ipShipfrom like abs_shipfrom no-undo.
   define input parameter ipAbsID like abs_id no-undo.
   define input parameter ipSoRecno as recid no-undo.
   define input parameter ipSodRecno as recid no-undo.

   {gprunmo.i &program = "rcabslmt.p" &module = "ACL"
              &param   = """(input ipSoRecno,
                             input ipSodRecno,
                             input ipAbsID,
                             input ipShipfrom)"""}

END PROCEDURE.  /*getLineCharges*/

PROCEDURE maintain_shipment_reasons:
   define input parameter v_abs_id like abs_id no-undo.
   define input parameter v_shipfrom like abs_shipfrom no-undo.

   for first shpc_ctrl
      fields (shpc_domain shpc_shipper_reasons)
      where   shpc_domain = global_domain
   no-lock: end.

   if can-find (first abs_mstr
      where abs_domain = global_domain
      and   abs_id = v_abs_id
      and   abs_shipfrom = v_shipfrom)
   then do:

     /* IS SHIPMENT PERFORMANCE INSTALLED? */
     if can-find(mfc_ctrl
        where mfc_domain = global_domain
        and   mfc_field = "enable_shipment_perf"
        and   mfc_logical) and shpc_file_found
        and   shpc_shipper_reasons
     then do:

        {gprunmo.i &program = ""sorsnup.p"" &module = "ASR"
                   &param   = """(input v_abs_id,
                                  input v_shipfrom)"""}

      end. /* IF CAN-FIND mfc_ctrl */
   end. /* IF CAN-FIND (abs_mstr) */
END PROCEDURE.

PROCEDURE delete_shipment_reasons:
   define input parameter v_recid as recid no-undo.

   if can-find (first abs_mstr
      where abs_domain = global_domain
      and   recid(abs_mstr) = v_recid)
   then do:

      if can-find (mfc_ctrl
         where mfc_domain = global_domain
         and   mfc_field = "enable_shipment_perf"
         and   mfc_logical) and shpc_file_found
      then do:

         /* DELETE REASON CODES */
         {gprunmo.i &program = ""sorsndel.p"" &module = "ASR"
                    &param   = """(input v_recid)"""}

      end. /* IF CAN-FIND mfc_ctrl */
   end. /* IF CAN-FIND abs_mstr */
END PROCEDURE.

{rcinvcon.i}   /* INTERNAL PROCEDURE get_abs_parent INCLUDED IN THIS .i */

PROCEDURE validateSOFrTerms:
/*--------------------------------------------------------------------
 * Purpose:     Get the highest level parent (Shipper record)
 *              Get the first order attached to this shipper along with
 *                 the freight terms on this order.
 *              Compare the terms on this order to those on the order being
 *                attached and return op_FrTermsErr if they are different.
 * Parameters:
 * Notes:
 *----------------------------------------------------------------------*/
   define input parameter ip_AbsId        like   abs_id       no-undo.
   define input parameter ip_ShipFrom     like   abs_shipfrom no-undo.
   define input parameter ip_ParentRecId  as   recid    no-undo.
   define input parameter ip_Order        like so_nbr  no-undo.

   define output parameter op_FrTermsOnFirstOrder as character  no-undo.
   define output parameter op_FrTermsErr like mfc_logical  no-undo.

   define buffer b1_abs_mstr for abs_mstr.
   define buffer b2_abs_mstr for abs_mstr.
   define buffer b_so_mstr for so_mstr.

   define variable par_absid like abs_id no-undo.
   define variable par_shipfrom like abs_shipfrom no-undo.
   define variable l_FirstOrder like so_nbr no-undo.
   define variable l_OrderFrTerms like so_fr_terms no-undo.

   for first b_so_mstr
      fields (so_domain so_fr_terms)
      where b_so_mstr.so_domain = global_domain
      and   b_so_mstr.so_nbr = ip_Order
    no-lock: end.

   if not available b_so_mstr then
      return.
   else
     l_OrderFrTerms = b_so_mstr.so_fr_terms.

   /* MAKE SURE THAT THE PARENT_ID IS ACTUALLY THE HIGHEST LEVEL PARENT */
   for first b1_abs_mstr
      where recid(b1_abs_mstr) = ip_ParentRecId
   no-lock: end.

   if available b1_abs_mstr
      and b1_abs_mstr.abs_par_id = ""
   then
      assign
         par_absid = b1_abs_mstr.abs_id
         par_shipfrom = b1_abs_mstr.abs_shipfrom.
   else do:
      run get_abs_parent
         (input ip_AbsId,
          input ip_ShipFrom,
          output par_absid,
          output par_shipfrom).

   end. /* ELSE, NOT AVAILABLE b1_abs_mstr */

   if par_absid <> ?
   then do for b2_abs_mstr:
      for first b2_abs_mstr
         where b2_abs_mstr.abs_domain = global_domain
         and b2_abs_mstr.abs_id = par_absid
         and b2_abs_mstr.abs_shipfrom = par_shipfrom
      no-lock: end.

      if available b2_abs_mstr then do:
         {gprunmo.i  &module = "LA" &program = "lashex01.p"
                     &param  = """(buffer b2_abs_mstr,
                                   output l_FirstOrder,
                                   output op_FrTermsOnFirstOrder)"""}

         /* IF THERE IS AN ORDER ATTACHED TO THE PARENT ABS_MSTR,   */
         /* COMPARE THE FREIGHT TERMS ON THAT ORDER TO THOSE ON THE */
         /* ORDER BEING ATTACHED.                                   */
         if l_FirstOrder <> ""
            and op_FrTermsOnFirstOrder <> l_OrderFrTerms
         then do:
            op_FrTermsErr = true.
            return.
         end. /* IF l_FirstOrder <> "" AND... */

      end. /* IF AVAILABLE b2_abs_mstr */
   end. /* DO FOR ABS_BUFF6 */

END PROCEDURE. /* validateSOFrTerms */

PROCEDURE findSalesOrderDet:
 /*--------------------------------------------------------------------------
  * Purpose : Find sod_det record based on the available ship_line
  *           record.
  *------------------------------------------------------------------------*/
   if available ship_line then do:
      for first sod_det
         fields (sod_domain sod_cfg_type sod_contr_id sod_fa_nbr sod_line
                 sod_nbr sod_site
                 sod_part sod_pickdate sod_qty_all sod_qty_ord sod_qty_pick
                 sod_qty_ship sod_sched sod_type sod_um_conv sod__qadl01)
         where   sod_domain = global_domain
         and     sod_nbr    = ship_line.abs_order
         and     sod_line   = integer(abs_line)
      no-lock: end.
   end.
END PROCEDURE. /* FindSalesOrderDet */

PROCEDURE check-reserved-location:
/*--------------------------------------------------------------------
 * Purpose:    Check if Reserved Locations to be used is valid.
 *----------------------------------------------------------------------*/

   ret-flag = 2.

   /* BYPASS CHECKING SSM ORDERS */
   if so_mstr.so_fsm_type = "" then do:

      {gprun.i ""sorlchk.p""
               "(input so_ship,
                 input so_bill,
                 input so_cust,
                 input abs_child_buff.abs_site,
                 input abs_child_buff.abs_loc,
                 output ret-flag)"}

   end. /* IF so_mstr.so_fsm_type = "" */

END PROCEDURE. /* check-reserved-location */

PROCEDURE DisplayMessage:

   define input parameter ipMsgNum as integer no-undo.
   define input parameter ipLevel  as integer no-undo.
   define input parameter ipMsg1   as character no-undo.
   define input parameter ipMsg2   as character no-undo.

   {pxmsg.i &MSGNUM     = ipMsgNum
            &ERRORLEVEL = ipLevel
            &MSGARG1    = ipMsg1
            &MSGARG2    = ipMsg2}

END PROCEDURE. /* PROCEDURE DisplayMessage */

PROCEDURE p_chk_serial:

   /* EXPLODES THE SHIPPER INTO WORK2_ABS_MSTR AND CHECKS IF */
   /* CURRENT ITEM/SERIAL/REF NUMBER ALREADY EXISTS          */
   define input  parameter i_ship_from  as   character   no-undo.
   define input  parameter i_abs_recid  as   recid       no-undo.
   define input  parameter i_abs_item   as   character   no-undo.
   define input  parameter i_abs_lot    as   character   no-undo.
   define output parameter o_undo       like mfc_logical no-undo.

   define variable parent_id as   character   no-undo.
   define variable l_allowed like mfc_logical no-undo.
   define variable l_item    as   character   no-undo.
   define variable l_lot     as   character   no-undo.

   /* FIND THE SHIPPER ID */
   for first abs_parent_buff
      fields(abs_id)
      where recid(abs_parent_buff) = i_abs_recid
   no-lock:
   end. /* FOR FIRST abs_parent_buff */

   assign
      o_undo    = no
      parent_id = abs_parent_buff.abs_id
      l_allowed = yes.

   empty temp-table work2_abs_mstr.

   /* EXPLODE THE SHIPPER */
   {gprun.i ""rcabsexp.p"" "(input        i_ship_from,
                             input        parent_id,
                             input-output l_allowed,
                             input-output l_item,
                             input-output l_lot)"}

   if can-find(first work2_abs_mstr
                  where work2_abs_mstr.w_abs_shipfrom
                        = i_ship_from
                    and work2_abs_mstr.w_abs_id
                        begins "i"
                    and work2_abs_mstr.w_abs_item
                        = i_abs_item
                    and work2_abs_mstr.w_abs_lot
                        = i_abs_lot
                    use-index order)
   then do:

      /* SERIAL: # FOR PART: # ALREADY PICKED IN THIS SHIPMENT */
      run DisplayMessage(input 6592,
                         input 3,
                         input i_abs_lot,
                         input i_abs_item).
      empty temp-table work2_abs_mstr.
      o_undo = yes.

   end. /* IF CAN-FIND(FIRST work2_abs_mstr */

END PROCEDURE. /* PROCEDURE p_chk_serial */
