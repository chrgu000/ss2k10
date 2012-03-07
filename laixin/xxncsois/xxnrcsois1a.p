/* rcsois1a.p - Customer Schedules - Confirm Shipper Invoicing Sub-Program    */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.128.1.7 $                                                               */
/* REVISION: 7.4      LAST MODIFIED: 12/19/94   BY: bcm *H09G*                */
/* REVISION: 7.4      LAST MODIFIED: 12/21/94   BY: jxz *GO77*                */
/* REVISION: 7.3      LAST MODIFIED: 01/26/95   BY: WUG *G0BY*                */
/* REVISION: 7.4      LAST MODIFIED: 03/20/95   BY: bcm *G0HR*                */
/* REVISION: 7.4      LAST MODIFIED: 03/23/95   BY: jxz *F0M3*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 7.4      LAST MODIFIED: 04/18/95   BY: srk *H0DD*                */
/* REVISION: 7.4      LAST MODIFIED: 08/01/95   BY: vrn *G0T8*                */
/* REVISION: 7.4      LAST MODIFIED: 09/09/95   BY: vrn *H0FT*                */
/* REVISION: 7.4      LAST MODIFIED: 09/25/95   BY: vrn *H0G2*                */
/* REVISION: 7.4      LAST MODIFIED: 12/15/95   BY: rwl *F0WR*                */
/* REVISION: 7.4      LAST MODIFIED: 01/24/96   BY: vrn *H0JD*                */
/* REVISION: 8.5      LAST MODIFIED: 08/01/95   BY: taf *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 05/28/96   BY: pfh *G1WD*                */
/* REVISION: 8.5      LAST MODIFIED: 07/22/96   BY: *J0Y3* Robert Wachowicz   */
/* REVISION: 8.6      LAST MODIFIED: 08/09/96   BY: *K003* Vinay Nayak-Sujir  */
/* REVISION: 8.5      LAST MODIFIED: 08/16/96   BY: *H0MD* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 09/20/96   BY: TSI *K005*                */
/* REVISION: 8.6      LAST MODIFIED: 10/17/96   BY: *K003* Forrest mori       */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Kurt De Wit        */
/* REVISION: 8.6      LAST MODIFIED: 12/06/96   BY: *K030* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 02/28/97   BY: *H0S3* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 06/13/97   BY: *J1T4* Seema Varma        */
/* REVISION: 8.6      LAST MODIFIED: 09/20/97   BY: *H1F5* Niranjan Ranka     */
/* REVISION: 8.6      LAST MODIFIED: 10/22/97   BY: *H1G6* Seema Varma        */
/* REVISION: 8.6      LAST MODIFIED: 11/16/97   BY: *K18W* Taek-Soo Chang     */
/* REVISION: 8.6      LAST MODIFIED: 12/13/97   BY: *J20Q* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 12/30/97   BY: *J27M* Seema Varma        */
/* REVISION: 8.6      LAST MODIFIED: 11/24/97   BY: *K15N* Jim Williams       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 03/07/98   BY: *K1J8* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 03/20/98   BY: *J2F2* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 06/01/98   BY: *K1NF* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 06/08/98   BY: *J2MH* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 24 JUN 98  BY: *L00X* Ed van de Gevel    */
/* REVISION: 8.6E     LAST MODIFIED: 07/15/98   BY: *L024* Bill Reckard       */
/* REVISION: 8.6E     LAST MODIFIED: 08/18/98   BY: *K1DQ* Suresh Nayak       */
/* REVISION: 8.6E     LAST MODIFIED: 09/10/98   BY: *J2ZD* Surekha Joshi      */
/* REVISION: 8.6E     LAST MODIFIED: 09/17/98   BY: *J29B* Ajit Deodhar       */
/* REVISION: 8.6E     LAST MODIFIED: 10/23/98   BY: *L0CD* Steve Goeke        */
/* REVISION: 8.6E     LAST MODIFIED: 12/14/98   BY: *L0CV* Steve Goeke        */
/* REVISION: 8.6E     LAST MODIFIED: 04/08/99   BY: *J3D8* Ranjit Jain        */
/* REVISION: 9.0      LAST MODIFIED: 04/14/99   BY: *J3BM* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 07/09/99   BY: *J3HZ* Poonam Bahl        */
/* REVISION: 9.0      LAST MODIFIED: 07/27/99   BY: *K21K* Jose Alex          */
/* REVISION: 9.0      LAST MODIFIED: 08/12/99   BY: *J3KJ* Bengt Johansson    */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Vijaya Pakala      */
/* REVISION: 9.1      LAST MODIFIED: 10/20/99   BY: *N04X* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 10/29/99   BY: *N04P* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 11/23/99   BY: *L0LS* Manish Kulkarni    */
/* REVISION: 9.1      LAST MODIFIED: 01/11/00   BY: *J3N7* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 03/28/00   BY: *K25V* Surekha Joshi      */
/* REVISION: 9.1      LAST MODIFIED: 04/24/00   BY: *L0PR* Kedar Deherkar     */
/* REVISION: 9.1      LAST MODIFIED: 06/30/00   BY: *L10R* Kaustubh Kulkarni  */
/* REVISION: 9.1      LAST MODIFIED: 07/20/00   BY: *N0B5* Vinay Nayak-Sujir  */
/* REVISION: 9.1      LAST MODIFIED: 07/28/00   BY: *L0QV* Manish Kulkarni    */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *N0RF* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/04/00   BY: *L0TS* Manish Kulkarni    */
/* REVISION: 9.1      LAST MODIFIED: 12/20/00   BY: *L155* Abhijeet Thakur    */
/* REVISION: 9.1      LAST MODIFIED: 10/18/00   BY: *N0WD* BalbeerS Rajput    */
/* REVISION: 9.1      LAST MODIFIED: 02/13/01   BY: *N0WV* Sandeep Parab      */
/* Revision: 1.76     BY: Jean Miller              DATE: 03/22/01 ECO: *P008* */
/* Revision: 1.76     BY: Rajaneesh Sarangi        DATE: 06/29/01 ECO: *M1CP* */
/* Revision: 1.78     BY: Dan Herman               DATE: 07/09/01 ECO: *P007* */
/* Revision: 1.79     BY: Niranjan Ranka           DATE: 07/23/01 ECO: *P00L* */
/* Revision: 1.80     BY: Kaustubh Kulkarni        DATE: 08/30/01 ECO: *M13W* */
/* Revision: 1.81     BY: Steve Nugent             DATE: 10/15/01 ECO: *P004* */
/* Revision: 1.82     BY: Rajiv Ramaiah            DATE: 10/31/01 ECO: *M1LM* */
/* Revision: 1.85     BY: Ashwini Ghaisas          DATE: 12/15/01 ECO: *M1LD* */
/* Revision: 1.87     BY: Hareesh V.               DATE: 02/04/02 ECO: *M1S2* */
/* Revision: 1.88     BY: Patrick Rowan            DATE: 04/24/01 ECO: *P00G* */
/* Revision: 1.89     BY: Mercy C.                 DATE: 04/02/02 ECO: *N1D2* */
/* Revision: 1.90     BY: Robin McCarthy           DATE: 04/05/02 ECO: *P000* */
/* Revision: 1.91     BY: Sandeep Parab            DATE: 06/04/02 ECO: *M1XH* */
/* Revision: 1.92     BY: Ed van de Gevel          DATE: 07/04/02 ECO: *P0B4* */
/* Revision: 1.93     BY: Manisha Sawant           DATE: 09/23/02 ECO: *N1QH* */
/* Revision: 1.96     BY: Ashish Maheshwari        DATE: 11/25/02 ECO: *N20H* */
/* Revision: 1.97     BY: Dorota Hohol             DATE: 03/14/03 ECO: *P0N6* */
/* Revision: 1.98     BY: Seema Tyagi              DATE: 03/25/03 ECO: *N29M* */
/* Revision: 1.99     BY: Seema Tyagi              DATE: 03/28/03 ECO: *N2BB* */
/* Revision: 1.100    BY: Rajaneesh Sarangi        DATE: 05/14/03 ECO: *N2FH* */
/* Revision: 1.102    BY: Paul Donnelly (SB)       DATE: 06/28/03 ECO: *Q00K* */
/* Revision: 1.103    BY: Rajinder Kamra           DATE: 05/05/03 ECO: *Q003* */
/* Revision: 1.105    BY: Rajinder Kamra           DATE: 07/16/03 ECO: *Q013* */
/* Revision: 1.108    BY: Subramanian Iyer         DATE: 09/23/03 ECO: *P12N* */
/* Revision: 1.109    BY: Orawan Songmoungsuk      DATE: 10/08/03 ECO: *P14K* */
/* Revision: 1.110    BY: Veena Lad                DATE: 10/28/03 ECO: *P17K* */
/* Revision: 1.112    BY: Kirti Desai              DATE: 11/12/03 ECO: *P195* */
/* Revision: 1.113    BY: Ed van de Gevel          DATE: 12/02/03 ECO: *P1BX* */
/* Revision: 1.114    BY: Karan Motwani            DATE: 01/13/04 ECO: *P1HP* */
/* Revision: 1.115    BY: Vinay Soman              DATE: 01/23/04 ECO: *P1JP* */
/* Revision: 1.116    BY: Vinay Soman              DATE: 01/30/04 ECO: *P1LR* */
/* Revision: 1.117    BY: Salil Pradhan            DATE: 03/09/04 ECO: *P1GM* */
/* Revision: 1.118    BY: Vinay Soman              DATE: 03/18/04 ECO: *P1TW* */
/* Revision: 1.119    BY: Vinay Soman              DATE: 04/12/04 ECO: *P1WK* */
/* Revision: 1.120    BY: Robin McCarthy           DATE: 04/19/04 ECO: *P15V* */
/* Revision: 1.121    BY: Prashant Parab           DATE: 05/21/04 ECO: *Q07X* */
/* Revision: 1.122    BY: Sunil Fegade             DATE: 06/25/04 ECO: *P27K* */
/* Revision: 1.123    BY: Shivganesh Hegde         DATE: 08/03/04 ECO: *P26L* */
/* Revision: 1.124    BY: Jean Miller              DATE: 09/02/04 ECO: *Q0CP* */
/* Revision: 1.125    BY: Manish Dani              DATE: 10/28/04 ECO: *P2RT* */
/* Revision: 1.126    BY: Reena Ambavi             DATE: 11/15/04 ECO: *P2T1* */
/* Revision: 1.127    BY: Jignesh Rachh            DATE: 12/01/04 ECO: *P2XJ* */
/* Revision: 1.128    BY: Binoy John               DATE: 01/27/05 ECO: *P35M* */
/* Revision: 1.128.1.1  BY: Preeti Sattur          DATE: 03/15/05 ECO: *P3CL* */
/* Revision: 1.128.1.2  BY: Preeti Sattur          DATE: 03/28/05 ECO: *P3DD* */
/* Revision: 1.128.1.3  BY: Somesh Jeswani         DATE: 03/29/05 ECO: *Q0HJ* */
/* Revision: 1.128.1.5  BY: Jignesh Rachh          DATE: 03/30/05 ECO: *P3DG* */
/* Revision: 1.128.1.5  BY: Bhagyashri Shinde      DATE: 07/20/04 ECO: *P2CR* */
/* Revision: 1.128.1.6  BY: Shivganesh Hegde       DATE: 05/13/05 ECO: *P3LK* */
/* $Revision: 1.128.1.7 $         BY: Priya Idnani           DATE: 07/05/05 ECO: *P3N3* */
/* $Revision: 1.100.1.26 $              BY: Bill Jiang      DATE: 03/06/06 ECO: *SS - 20060306* */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* THIS PROGRAM IS CALLED BY: RCSOIS1.P & RCSOIS01.P */
/* ALL CHANGES MADE TO THIS PROGRAM SHOULD BE MADE TO rcsois2a.p AS WELL*/

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{gplabel.i}
{cxcustom.i "RCSOIS1A.P"}

define temp-table tt_somstr no-undo
   field tt_sonbr   like so_nbr
   field tt_sotoinv like mfc_logical initial no
   index sonbr is primary unique
   tt_sonbr.

/* PARAMETERS */
define input  parameter calling_function as character no-undo.
define input parameter consignment as logical no-undo.
define input parameter  table            for tt_somstr.
define output parameter o_undo like mfc_logical no-undo initial true.

/* SHARED VARIABLES */
define new shared variable qty_iss_rcv like tr_qty_loc.
define new shared variable copyusr like mfc_logical.
define new shared variable fas_so_rec as character.
define new shared variable issrct as character format "x(3)".
define new shared variable lotserial_qty like sr_qty no-undo.
define new shared variable open_ref like sod_qty_ord.
define new shared variable orderline like tr_line.
define new shared variable ordernbr like tr_nbr.
define new shared variable prev_consume like sod_consume.
define new shared variable prev_qty_ord like sod_qty_ord.
define new shared variable prev_due like sod_due_date.
define new shared variable prev_site like sod_site.
define new shared variable prev_type like sod_type.
define new shared variable addr like tr_addr.
define new shared variable conv like um_conv label "Conversion" no-undo.
define new shared variable next_inv_nbr like soc_inv.
define new shared variable next_inv_pre like soc_inv_pre.
define new shared variable inv_date     like ar_date.
define new shared variable comb_inv_nbr like so_inv_nbr.
define new shared variable undo-select like mfc_logical no-undo.
{&RCSOIS1A-P-TAG1}
define new shared variable l_unconfm_shp   like mfc_logical  no-undo.
define new shared variable l_multi_ln_item like mfc_logical  no-undo.
define new shared variable conso like mfc_logical.
{&RCSOIS1A-P-TAG10}

define shared variable rndmthd like rnd_rnd_mthd.
define shared variable abs_carr_ref as character.
define shared variable abs_fob like so_fob.
define shared variable abs_recid as recid.
define shared variable abs_shipvia like so_shipvia.
define shared variable accum_wip   like tr_gl_amt.
define shared variable already_posted like glt_amt.
define shared variable auto_post like mfc_logical label "Post Invoice".
define shared variable base_amt    like ar_amt.
define shared variable batch       like ar_batch.
define shared variable batch_tot   like glt_amt.
define shared variable bill        like so_bill.
define shared variable bill1       like so_bill.
define shared variable change_db   like mfc_logical.
define shared variable consolidate like mfc_logical
                                   label "Consolidate Invoices".
define shared variable cr_acct  like trgl_cr_acct.
define shared variable cr_sub   like trgl_cr_sub.
define shared variable cr_amt   as decimal format "->>>,>>>,>>>.99"
                                label "Credit".
define shared variable cr_cc    like trgl_cr_cc.
define shared variable cr_proj  like trgl_cr_proj.
define shared variable curr_amt like glt_amt.
define shared variable cust     like so_cust.
define shared variable cust1    like so_cust.
define shared variable desc1    like pt_desc1 format "x(49)".
define shared variable dr_acct  like trgl_dr_acct.
define shared variable dr_sub   like trgl_dr_sub.
define shared variable dr_amt   as decimal format "->>>,>>>,>>>.99"
                                label "Debit".
define shared variable dr_cc    like trgl_dr_cc.
define shared variable eff_date like glt_effdate label  "Effective".
define shared variable exch_rate like exr_rate.
define shared variable exch_rate2 like exr_rate2.
define shared variable exch_ratetype like exr_ratetype.
define shared variable exch_exru_seq like exru_seq.
define shared variable ext_cost   like sod_price.
define shared variable ext_disc   as decimal decimals 2.
define shared variable ext_list   like sod_list_pr decimals 2.
define shared variable ext_price  as decimal label "Ext Price"
                                  decimals 2 format "->>>>,>>>,>>9.99".
define shared variable freight_ok like mfc_logical.
define shared variable gl_amt     like sod_fr_chg.
define shared variable gl_sum     like mfc_logical format "Consolidated/Detail"
                                  initial yes.
define shared variable gr_margin  like sod_price label "Unit Margin"
                                  format "->>>>,>>9.99".
define shared variable ext_gr_margin like gr_margin label "Ext Margin".
define shared variable base_price    like ext_price.
define shared variable base_margin   like ext_gr_margin.
define shared variable global_recid  as recid.
define shared variable inv_only      like mfc_logical initial yes.
define shared variable inv           like ar_nbr label  "Invoice".
define shared variable inv1          like ar_nbr label {t001.i}.
define shared variable loc like pt_loc.
define shared variable lotserial_total like tr_qty_chg.
define shared variable name    like ad_name.
define shared variable nbr like tr_nbr.
define shared variable net_list   like sod_list_pr.
define shared variable net_price  like sod_price.
define shared variable old_ft_type as character.
define shared variable order_nbrs as character extent 30.
define shared variable order_nbr_list as character no-undo.
define shared variable order_ct as integer.
define shared variable part as character format "x(18)".
define shared variable post    like mfc_logical.
define shared variable post_entity  like ar_entity.
define shared variable print_lotserials like mfc_logical
                                       label "Print Lot/Serial Numbers Shipped".
define shared variable project like wo_proj.
define shared variable que-doc  as logical.
define shared variable qty      as decimal.
define shared variable qty_all  like sod_qty_all.
define shared variable qty_pick like sod_qty_pick.
define shared variable qty_bo   like sod_bo_chg.
define shared variable qty_cum_ship like sod_qty_ship.
define shared variable qty_chg  like sod_qty_chg.
define shared variable qty_inv  like sod_qty_inv.
define shared variable qty_left like tr_qty_chg.
define shared variable qty_open like sod_qty_ord.
define shared variable qty_ord  like sod_qty_ord.
define shared variable qty_req  like in_qty_req.
define shared variable qty_ship like sod_qty_ship.
define shared variable ref like glt_ref.
define shared variable rmks like tr_rmks.
define shared variable sct_recid as recid.
define shared variable sct_recno as recid.
define shared variable ship_db like global_db.
define shared variable ship_dt like so_ship_date.
define shared variable ship_line like sod_line.
define shared variable ship_site as character.
define shared variable ship_so like so_nbr.
define shared variable should_be_posted like glt_amt.
define shared variable so_db like global_db.
define shared variable so_hist like soc_so_hist.
define shared variable so_job like tr_so_job.
define shared variable so_mstr_recid as recid.
define shared variable so_recno   as recid.
define shared variable sod_entity like en_entity.
define shared variable sod_recno as recid.
define shared variable std_cost like sod_std_cost.
define shared variable tax_recno  as recid.
define shared variable tot_curr_amt  like glt_amt.
define shared variable tot_ext_cost  like sod_price.
define shared variable tot_line_disc as decimal decimals 2.
define shared variable tr_recno as recid.
define shared variable transtype as character format "x(7)".
define shared variable trgl_recno as recid.
define shared variable trlot like tr_lot.
define shared variable trqty like tr_qty_chg.
define shared variable undo_all   like mfc_logical no-undo.
define shared variable unit_cost    like tr_price label "Unit Cost".
define shared variable use_shipper  like mfc_logical
                                    label "Use Shipper Nbr for Inv Nbr".
define shared variable wip_entity   like si_entity.
define shared variable yn           like mfc_logical.
define shared variable confirm_mode like mfc_logical no-undo.
define shared variable rejected     like mfc_logical no-undo.
define shared variable auto_inv     like mfc_logical.
define shared variable l_undo       like mfc_logical no-undo.

/* LOCAL VARIABLES */
define variable doc-type as character.
define variable doc-ref  as character.
define variable add-ref  as character.
define variable msg-type as character.
define variable trq-id   like trq_id.
define variable i        as integer.
define variable inv_ct   as integer.
define variable inv_nbrs    as character extent 30.
define variable new_inv_nbr as character.
define variable temp_fob like so_fob extent 30.
define variable temp_shipvia like so_shipvia extent 30.
define variable temp_fob_list as character no-undo.
define variable temp_shipvia_list as character no-undo.
define variable inv_nbr_list as character no-undo.
define variable order_num as character no-undo.
define variable err_flag  as integer no-undo.
define variable l_abs_pick_qty like sod_qty_pick no-undo.
define variable return_status  as   integer      no-undo.
define variable l_shipto       like abs_shipto   no-undo.
define variable undo_stat      like mfc_logical  no-undo.
define variable temp_so_ship   like so_ship      no-undo.
define variable temp_so_qadc01 like so__qadc01 no-undo.
define variable tmp_issueqty   like abs_qty no-undo.
define variable tmp_shipqty    like abs_qty no-undo.
define variable tmp_pickqty    like abs_qty no-undo.
define variable sum_tr_item    like mfc_logical no-undo.
define variable sum_tr_cont    like mfc_logical no-undo.
define variable l_recalc as logical initial no no-undo.
define variable l_absid             like abs_id            no-undo.
define variable prev_qty_all        like sod_qty_all       no-undo.
define variable l_multi_ln_shpr     like mfc_logical       no-undo.
define variable l_save_db           like global_db         no-undo.
define variable l_err-flag          as   integer           no-undo.
define variable l_accum_shpqty      as   decimal           no-undo.
define variable l_umconv            like sod_um_conv       no-undo.
define variable l_um                like sod_um            no-undo.
define variable using_shipment_perf like mfc_logical       no-undo.
define variable perf_ship_qty       like sod_qty_ship      no-undo.
define variable total_sp_qty        like sod_qty_ship      no-undo.
define variable shipperid           like abs_id            no-undo.
define variable l_increment         like mfc_logical       no-undo.
define variable l_cur_tax_amt       like tx2d_cur_tax_amt  no-undo.
define variable l_po_schd_nbr       like sod_contr_id      no-undo.
define variable l_remote-base-curr  like gl_base_curr      no-undo.
define variable l_exch-rate         like exr_rate          no-undo.
define variable l_exch-rate2        like exr_rate2         no-undo.
define variable l_ret_flag          like mfc_logical       no-undo initial no.
/* CONSIGNMENT VARIABLES */
{socnvars.i}
using_cust_consignment = consignment.

/* DEFINE BUFFERS */
define buffer abs_work for abs_mstr.
define buffer abs_comp for abs_mstr.
define buffer seoc_buf for seoc_ctrl.

/* USE OF abs_mstr BUFFERS                                          */
/*  abs_mstr buffer for pre-shipper/shipper header                  */
/*  abs_work buffer for containers/items nested within a shipper    */
/*  abs_comp buffer to check for kit components within an item      */

/* DEFINE WORKFILE DEFINITIONS */
define shared workfile work_sr_wkfl like sr_wkfl.

{rcwabsdf.i}
define buffer work_abs_buff for work_abs_mstr.

/* THE TEMP-TABLE WORK_TRNBR STORES THE VALUES OF FIRST AND LAST  */
/* TRANSACTION NUMBER WHICH IS USED WHEN INVOICE IS POSTED VIA    */
/* SHIPPER CONFIRM, FOR ASSIGNING THE TR_RMRKS AND TR_GL_DATE     */
/* FIELDS. PREVIOUSLY, THIS WAS BEING DONE IN RCSOISB1.P PRIOR TO */
/* INVOICE POST.                                                  */

define new shared temp-table work_trnbr no-undo
   field work_sod_nbr  like sod_nbr
   field work_sod_line like sod_line
   field work_tr_recid  like tr_trnbr
index work_sod_nbr work_sod_nbr ascending.

/* SHARED TEMP-TABLE TO COMPUTE THE QUANTITY IN rcinvchk.p */
/* TO CHECK AGAINST THE INVENTORY AVAILABLE FOR THAT ITEM  */
define new shared temp-table compute_ldd               no-undo
   field compute_site   like work_abs_mstr.abs_site
   field compute_loc    like work_abs_mstr.abs_loc
   field compute_lot    like work_abs_mstr.abs_lotser
   field compute_item   like work_abs_mstr.abs_item
   field compute_ref    like work_abs_mstr.abs_ref
   field compute_qty    like work_abs_mstr.abs_qty
   field compute_lineid like work_abs_mstr.abs_id
   index compute_index compute_site compute_item
         compute_loc   compute_lot  compute_ref.

define temp-table temp_somstr
   field temp_so_nbr like so_nbr
   field temp_so_inv_nbr like so_inv_nbr
   field temp_so_inv_date like so_inv_date
index temp_so_nbr temp_so_nbr ascending.

define shared temp-table work_ldd no-undo
   field work_ldd_id  like abs_mstr.abs_id
   index work_ldd_id  work_ldd_id.

empty temp-table compute_ldd no-error.

/* Euro Tool Kit definitions */
{etvar.i}
{etdcrvar.i}
{etrpvar.i}

{socurvar.i}
{fsdeclr.i}

{gpglefdf.i}
{gpfilev.i} /* VARIABLE DEFINITIONS FOR gpfile.i */

/* DETERMINE IF SHIPMENT PERFORMANCE IS INSTALLED */
for first mfc_ctrl
   where mfc_domain = global_domain
   and   mfc_field = "enable_shipment_perf"
   and   mfc_module = "ADG"
   and   mfc_logical = yes
no-lock:
   using_shipment_perf = yes.
end.

{cclc.i} /* CHECK FOR ENABLEMENT OF CONTAINER AND LINE CHARGES */

l_multi_ln_shpr = no.

for first soc_ctrl
   fields (soc_domain soc_inv soc_inv_pre soc_so_hist)
   where   soc_domain = global_domain
no-lock: end.

run p_init_proc (output sum_tr_item,
                 output sum_tr_cont).

if calling_function = "po_shipper_confirm"
then
   assign
      auto_inv = no
      auto_post = no
      confirm_mode = yes.

{&RCSOIS1A-P-TAG11}

{&RCSOIS1A-P-TAG15}

for first abs_mstr
   fields (abs_domain abs_eff_date abs_fa_lot abs_format abs_id abs_inv_mov
           abs_item abs_line abs_loc abs_lotser abs_order abs_par_id
           abs_qty abs_ref abs_shipfrom abs_shipto abs_ship_qty
           abs_shp_date abs_site abs_status abs__qad03 abs__qad10)
   where recid(abs_mstr) = abs_recid
no-lock: end.

l_shipto = abs_shipto.

{gprun.i ""socrshc.p""}

find first shc_ctrl
   where shc_domain = global_domain
no-lock.

progloop:
do on error undo, leave:

   /* GO THRU WORKFILE AND PERFORM SO ISSUES, CONTAINER ITEM ISSUES,
    * OR LOCATION TRANSFERS */
   do i = 1 to order_ct transaction:

      order_num = if (i <= 30) then
                     order_nbrs[i]
                  else
                     entry(i - 30,order_nbr_list).

      find so_mstr
         where so_domain = global_domain
         and  so_nbr = order_num
      exclusive-lock.

      if available so_mstr
         and so_inv_nbr <> ""
      then do:
         create temp_somstr.
         assign
            temp_so_nbr      = so_nbr
            temp_so_inv_nbr  = so_inv_nbr
            temp_so_inv_date = so_inv_date.
      end.  /* IF AVAILABLE SO_MSTR  AND SO_INV_NBR <> "" */

      if ( i <= 30 ) then
         assign
            temp_fob[i] = so_fob
            temp_shipvia[i] = so_shipvia.
      else
         assign
            temp_fob_list = temp_fob_list + so_fob + ","
            temp_shipvia_list = temp_shipvia_list + so_shipvia + ",".

      assign
         so_bol = abs_carr_ref
         so_fob = abs_fob
         temp_so_qadc01 = so__qadc01
         temp_so_ship = so_ship
         so_shipvia = abs_shipvia
         so__qadc01 = so_ship when (so__qadc01 = " ").
   end.


   /* MOVED CLOSER TO ACTUAL INVOICE PRINT SO THAT INVOICE NUMBER */
   /* IS DETERMINED IN THE SAME TRANSACTION AS IT IS PRINTED      */
   issue_inventory_loop:
   do transaction:
      {&RCSOIS1A-P-TAG8}

      for each work_abs_mstr no-lock
         where ((work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty)
         or      work_abs_mstr.abs_qty = 0),
      each abs_work exclusive-lock
         where abs_work.abs_domain = global_domain
         and   abs_work.abs_shipfrom = work_abs_mstr.abs_shipfrom
         and   abs_work.abs_id = work_abs_mstr.abs_id
         break by work_abs_mstr.abs_order
               by work_abs_mstr.abs_line
               by work_abs_mstr.abs_item
               by work_abs_mstr.abs_site
               by work_abs_mstr.abs_loc
               by work_abs_mstr.abs_lotser
               by work_abs_mstr.abs_ref:

         /* CHECK FOR THE PRESENCE OF LOT/SERIAL NUMBER FOR */
         /* LOT/SERIAL CONTROLLED KIT PARENT AND COMPONENTS */
         run p_lot_serial_validate
            (input work_abs_mstr.abs_order,
             input work_abs_mstr.abs_line,
             input work_abs_mstr.abs_site,
             input work_abs_mstr.abs_loc,
             input work_abs_mstr.abs_item,
             input work_abs_mstr.abs_lotser,
             input work_abs_mstr.abs_ref,
             input (if confirm_mode = yes then 1
                    else -1) * work_abs_mstr.abs_qty,
             input work_abs_mstr.abs__qad02,
             output rejected).

         if rejected then
            leave progloop.

         find sod_det
            where sod_domain = global_domain
            and   sod_nbr = abs_work.abs_order
            and   sod_line = integer(abs_work.abs_line)
         exclusive-lock no-error.

         assign
            sod_recno = recid(sod_det).

         for first si_mstr
            where si_domain = global_domain
            and   si_site = work_abs_mstr.abs_site
         no-lock: end.

         accumulate abs_work.abs_qty
            (total by work_abs_mstr.abs_item).
         accumulate abs_work.abs_ship_qty
            (total by work_abs_mstr.abs_item).
         accumulate abs_work.abs_qty
            (total by work_abs_mstr.abs_ref).
         accumulate abs_work.abs_ship_qty
            (total by work_abs_mstr.abs_ref).

         {absupack.i  "abs_work" 3 22 "l_abs_pick_qty"}

         accumulate l_abs_pick_qty
            (total by work_abs_mstr.abs_ref).

         /* Pick up accumulated value or the record value depending */
         /* on the setting of the consolidation flags */
         /* Items */
         if abs_work.abs_id begins "I"
         then do:
            if sum_tr_item then
               assign
                  tmp_issueqty = accum total by work_abs_mstr.abs_ref
                     abs_work.abs_qty
                  tmp_shipqty  = accum total by work_abs_mstr.abs_ref
                     abs_work.abs_ship_qty
                  tmp_pickqty  = accum total by work_abs_mstr.abs_ref
                     l_abs_pick_qty.
            else
               assign
                  tmp_issueqty = abs_work.abs_qty
                  qty_chg      = abs_work.abs_qty
                  tmp_shipqty  = abs_work.abs_ship_qty
                  tmp_pickqty  = l_abs_pick_qty.
         end. /* if abs_work.abs_id begins "I"  */

         /* Containers */
         if not abs_work.abs_id begins "I"
         then do:
            if sum_tr_cont then
               assign
                  tmp_issueqty = accum total by work_abs_mstr.abs_ref
                     abs_work.abs_qty
                  tmp_shipqty  = accum total by work_abs_mstr.abs_ref
                     abs_work.abs_ship_qty
                  tmp_pickqty  = accum total by work_abs_mstr.abs_ref
                    l_abs_pick_qty.
            else
               assign
                  tmp_issueqty = abs_work.abs_qty
                  tmp_shipqty  = abs_work.abs_ship_qty
                  tmp_pickqty  = l_abs_pick_qty.
         end. /* if not abs_work.abs_id begins "I"  */

         /* SAVE OFF THE SHIPPER NUMBER FOR SHIPMENT PERFORMANCE */
         if using_shipment_perf
            and abs_work.abs_id begins "s"
         then
            shipperid = substring(abs_work.abs_id,2,20).

         if abs_work.abs_id begins "s" then
            /* SET THE INVOICE NUMBER ON THE abs_mstr TO REFLECT    */
            /* WHETHER THE abs_mstr IS BEING CONFIRMED OR           */
            /* UNCONFIRMED. THIS WILL BE USED LATER WHEN PRINTING   */
            /* THE INVOICE. BY SETTING THE INVOICE NUMBER, THE      */
            /* PRINT PROGRAM CAN RELIABLY FIND THE abs_mstr RECORDS */
            /* THAT HAVE BEEN PROCESSED AND NEED TO BE INVOICED.    */

            abs_work.abs_inv_nbr = if confirm_mode then "conf"
                                   else "unconf".

         /* IF USING LINE CHARGES THEN STORE IN TEMP TABLE */
         /* INFORMATION TO BE USED DURING INVOICE PRINT    */
         /* AND INVOICE POST.                              */
         if using_line_charges
            and abs_work.abs_id begins "i"
         then do:
            /* ADDED 7TH INPUT PARAMETER FOR CALCULATING THE CORRECT   */
            /* VALUE OF vLineUnitCharge                                */
            /*  Update Shipment Detail Line Charges with the extended price.*/
            {gprunmo.i &program = ""rcsois1b.p""  &module = "ACL"
                       &param   = """(input abs_work.abs_id,
                                      input abs_work.abs_shipfrom,
                                      input abs_work.abs_order,
                                      input integer(abs_work.abs_line),
                                      input recid(abs_work),
                                      input confirm_mode,
                                      input no,
                                      input no)"""}

            /* CREATE SELF-BILLING RECORDS FOR EACH LINE CHARGE */
            /* SO THAT BILLING CAN BE DONE BY INDIVIDUAL LINE   */
            /* CHARGE TRAILER CODE.                             */
            if can-find (first sbic_ctl no-lock
               where sbic_domain = global_domain
               and   sbic_active = yes)
            then do:

               {gprunmo.i &program = ""rcsois1c.p""  &module = "ACL"
                          &param   = """(input abs_work.abs_id,
                                         input abs_work.abs_shipfrom,
                                         input abs_work.abs_order,
                                         input integer(abs_work.abs_line),
                                         input recid(abs_work))"""}
            end.
         end. /* IF USING_LINE_CHARGES */

         /* Handle any ATO or KIT line items. Process the last
          * abs-record for a sales order line */
         if ( (last-of(work_abs_mstr.abs_ref))
            or ( (sum_tr_item = no)
            and (abs_work.abs_fa_lot <> "")))
            and available sod_det
            and sod_part = abs_work.abs_item
         then do:
            /* RECEIVE ASSEMBLE-TO-ORDER ITEM WITH FINAL ASSEMBLY ORDER */
            if abs_work.abs_fa_lot <> "" then do:
               if change_db then do:
                  run p_gp_alias (input ship_db, output err_flag).
                  if err_flag = 2
                     or err_flag = 3
                  then
                     undo progloop, leave progloop.
               end.
               else
                  sod_recno = recid(sod_det).

               /* STORING THE QTY_CHG IN INVENTORY UM AND        */
               /* PASSING IT AS +VE QTY SO THAT SR_QTY AND       */
               /* SOD_QTY_CHG GET UPDATED CORRECTLY IN RCSOISJ.P */
               if sum_tr_item then do:
                  if confirm_mode then
                     qty_chg = (accum total by work_abs_mstr.abs_ref
                                abs_work.abs_qty) -
                               (accum total by work_abs_mstr.abs_ref
                                abs_work.abs_ship_qty).
                  else
                     qty_chg = (accum total by work_abs_mstr.abs_ref
                                abs_work.abs_qty).
               end. /* IF sum_tr_item */

               {gprun.i ""rcsoisj.p""
                        "(input sod_nbr,
                          input sod_line,
                          input abs_work.abs_line,
                          input abs_work.abs_fa_lot,
                          input abs_work.abs_site,
                          input abs_work.abs_loc,
                          input abs_work.abs_lotser,
                          input abs_work.abs_ref,
                          input qty_chg,
                          input confirm_mode,
                          output sod_qty_chg)"}.

               /* SWITCH BACK TO SALES ORDER DOMAIN IF NECESSARY */
               if change_db then do:
                  run p_gp_alias (input so_db, output err_flag).
                  if err_flag = 2
                     or err_flag = 3
                  then
                     undo progloop, leave progloop.
               end.

            end. /* if abs_work.abs_fa_lot <> "" then do: */

            if can-find (first pt_mstr
               where pt_domain = global_domain
               and   pt_part = work_abs_mstr.abs_item
               and   pt_pm_code  = "C"
               and   pt_cfg_type = "1")
            then do:

               /* SWITCH TO INVENTORY DOMAIN IF NECESSARY */
               if change_db then do:
                  run p_gp_alias (input ship_db, output err_flag).
                  if err_flag = 2
                     or err_flag = 3
                  then
                     undo progloop, leave progloop.
               end. /* IF change_db */

               if first-of(work_abs_mstr.abs_ref)
                  or ((sum_tr_item         =  no)
                  and (abs_work.abs_fa_lot <> ""))
               then
                  l_accum_shpqty = 0.

               if first-of(work_abs_mstr.abs_item)
                  and work_abs_mstr.abs_item = sod_part
               then
                  assign
                     l_um     = work_abs_mstr.abs__qad02
                     l_umconv = decimal(work_abs_mstr.abs__qad03).

               if sod_type = "" then
                  if confirm_mode then
                     l_accum_shpqty = l_accum_shpqty +
                                    + work_abs_mstr.abs_qty
                                    - work_abs_mstr.abs_ship_qty.
                  else
                     l_accum_shpqty = -1 * (l_accum_shpqty
                                    + work_abs_mstr.abs_qty).

               if work_abs_mstr.abs_id begins "I"
                  and not (can-find (first abs_mstr
                  where abs_mstr.abs_domain   = global_domain
                  and   abs_mstr.abs_shipfrom = work_abs_mstr.abs_shipfrom
                  and   abs_mstr.abs_par_id   = work_abs_mstr.abs_id))
               then do:
                  {gprun.i ""icedit2.p""
                           "(input ""ISS-SO"",
                             input work_abs_mstr.abs_site,
                             input work_abs_mstr.abs_loc,
                             input work_abs_mstr.abs_item,
                             input work_abs_mstr.abs_lotser,
                             input work_abs_mstr.abs_ref,
                             input l_accum_shpqty * l_umconv,
                             input l_um,
                             input """",
                             input """",
                             output rejected)"}
               end. /* IF abs_id BEGINS "I" ... */

               /* SWITCH BACK TO SALES ORDER DOMAIN IF NECESSARY */
               if change_db then do:
                  run p_gp_alias (input so_db, output err_flag).
                  if err_flag = 2
                     or err_flag = 3
                  then
                     undo progloop, leave progloop.
               end. /* IF change_db */

               if rejected
               then do:
                  /* UNABLE TO ISSUE OR RECEIVE FOR ITEM # */
                  run DisplayMessage (input 161,
                                      input 3,
                                      input work_abs_mstr.abs_item).

                  pause.
                  undo_stat = yes.
                  leave progloop.
               end. /* IF REJECTED */

            end. /* IF CAN FIND PT_MSTR */

         end. /* IF LAST-OF(abs_ref) AND AVAILABLE sod_det.. */

         /* CHECK FOR KIT COMPONENTS IN abs_mstr*/
         if available sod_det
            and sod_part = abs_work.abs_item
         then do:

            for first abs_comp
               where abs_comp.abs_domain   = global_domain
               and   abs_comp.abs_shipfrom = abs_work.abs_shipfrom
               and   abs_comp.abs_id begins "I"
               and   abs_comp.abs_par_id   = abs_work.abs_id
            no-lock:

               /* PROCEDURE TO CHECK THE INVENTORY STATUS FOR KIT */
               run p-kitinvchk (output l_undo).
               if l_undo then
                  undo progloop, leave progloop.

            end. /* FOR FIRST abs_comp */

         end. /* IF AVAILABLE sod_det */

         /* PROCESS KIT PARENT AND ITS COMPONENTS */
         if (available abs_comp
             or (not available abs_comp
                 and can-find(first sod_det
                              where sod_det.sod_domain = global_domain
                              and   sod_nbr            = abs_work.abs_order
                              and   string(sod_line)   = abs_work.abs_line
                              and   sod_part           = abs_work.abs_item
                              and   sod_cfg_type       = "2")))
            and abs_work.abs_id begins "I"
         then do:

            sod_recno = recid(sod_det).
            /* PASSING ABS_QTY IN INVENTORY UM */
            {gprun.i ""rcsoisk.p""
               "(input recid(abs_work),
                 input confirm_mode,
                 input ((accum total by work_abs_mstr.abs_item
                       abs_work.abs_qty) * decimal (abs_work.abs__qad03)))"}.
         end.

         /*HANDLE ISSUE/TRANSFER OF PRODUCT ITEMS*/
         if (last-of(work_abs_mstr.abs_ref) or
            not sum_tr_item) and
            available sod_det and
            sod_part = abs_work.abs_item and
            abs_work.abs_id begins "I"
         then do:

            for first so_mstr
               fields (so_domain so_app_owner so_bill so_bol so_ca_nbr
                       so_cum_acct so_curr so_cust so_exru_seq
                       so_ex_rate so_ex_rate2 so_ex_ratetype
                       so_fix_rate so_fob so_fsm_type so_invoiced
                       so_inv_date so_inv_nbr so_nbr so_print_bl
                       so_rev so_ship so_shipvia so_ship_date
                       so_slspsn so_tax_date so_to_inv so_trl1_amt
                       so_trl2_amt so_trl3_amt so__qadc01)
               where   so_domain = global_domain
               and     so_nbr = sod_nbr
            no-lock: end.

            if so_fix_rate then
               assign
                  exch_rate     = so_ex_rate
                  exch_rate2    = so_ex_rate2
                  exch_ratetype = so_ex_ratetype
                  exch_exru_seq = so_exru_seq.
            else do:
               /* GET EXCHANGE RATE FOR BASE TO ACCOUNT CURRENCY */
               {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                         "(input  so_curr,
                           input  base_curr,
                           input  so_ex_ratetype,
                           input  eff_date,
                           output exch_rate,
                           output exch_rate2,
                           output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  run p_display_message (input mc-error-number,
                                         input 3).
                  undo progloop, leave progloop.
               end.

               assign
                  exch_ratetype = so_ex_ratetype
                  exch_exru_seq = 0.

            end.  /* else */

            /* ABS_QTY IN SHIP UM NEEDS TO BE CONVERTED TO INVENTORY UM */
            /* FOR INVENTORY IMPACTS OR SOD_UM FOR SOD_DET UPDATE              */
            create work_sr_wkfl.
            assign
               work_sr_wkfl.sr_domain = global_domain
               work_sr_wkfl.sr_userid = mfguser
               work_sr_wkfl.sr_lineid = abs_work.abs_line
               work_sr_wkfl.sr_site = abs_work.abs_site
               work_sr_wkfl.sr_loc = abs_work.abs_loc
               work_sr_wkfl.sr_lotser = abs_work.abs_lotser
               work_sr_wkfl.sr_ref = abs_work.abs_ref
               ship_so = so_nbr
               ship_line = sod_line.

            {absupack.i  "abs_work" 3 22 "l_abs_pick_qty"}

            /* CONVERTING SHIPPED QTY TO SOD_UM TO UPDATE SOD_DET LATER */
            if decimal(abs_work.abs__qad03) = 0 then
               assign
                  abs_work.abs__qad03 = "1".

            /* STORING THE QUANTITY IN INVENTORY UM TO     */
            /* AVOID ROUNDING ERRORS IN LD_DET AND TR_HIST */
            if confirm_mode then
               assign
                  work_sr_wkfl.sr_qty = (tmp_issueqty - tmp_shipqty)
                                      * decimal(abs_work.abs__qad03)
                                      / sod_um_conv
                  work_sr_wkfl.sr__qadc01 = string(
                                            round((tmp_issueqty - tmp_shipqty)
                                            * decimal(abs_work.abs__qad03),9))
                  qty_pick = tmp_pickqty * decimal(abs_work.abs__qad03)
                           / sod_um_conv
                  qty_chg  = work_sr_wkfl.sr_qty.

            else /* unconfirm, so reverse signs */
            /* Since abs_ship_qty does not seem to play any role
             * in the system it is being dropped from the calculation */
            assign
                  work_sr_wkfl.sr_qty = (-1 * tmp_issueqty
                                      * decimal(abs_work.abs__qad03))
                                      / sod_um_conv
                  work_sr_wkfl.sr__qadc01 = string(-1 *
                                            round(tmp_issueqty
                                            * decimal(abs_work.abs__qad03),9))
                  qty_pick = -1 * tmp_pickqty
                           * decimal(abs_work.abs__qad03) / sod_um_conv
                  qty_chg = work_sr_wkfl.sr_qty.

            if sod_type <> "" then do:
               if confirm_mode then
                  qty_pick = abs_work.abs_qty.
               else
                  qty_pick = (-1) * abs_work.abs_qty.
            end. /* if sod_type <> "" */

            if recid(work_sr_wkfl) = -1 then.

            for first si_mstr
               fields (si_domain si_db si_entity si_site)
               where   si_domain = global_domain
               and     si_site = sod_site
            no-lock: end.

            assign
               sod_entity = si_entity
               l_unconfm_shp   = no
               l_multi_ln_item = no.

            if sod__qadl01
               and confirm_mode
            then do:

               /* CHECK FOR UNCONFIRMED SHIPPERS */
               for each abs_comp
                  fields (abs_domain abs_eff_date abs_fa_lot abs_format
                          abs_id abs_inv_mov abs_item abs_line
                          abs_loc abs_lotser abs_order abs_qty
                          abs_par_id abs_ref abs_shipfrom
                          abs_shipto abs_ship_qty abs_shp_date
                          abs_site abs_status abs__qad03
                          abs__qad10)
                  where abs_comp.abs_domain   = global_domain
                  and   abs_comp.abs_order    = sod_nbr
                  and   abs_comp.abs_line     = string(sod_line)
                  and   abs_comp.abs_ship_qty <> abs_comp.abs_qty
               no-lock:

                  run p-get-parent-id
                     (input  recid(abs_comp),
                      output l_absid).

                  if l_absid <> abs_mstr.abs_id then do:
                     l_unconfm_shp = yes.
                     leave.
                  end. /* IF L_ABSID,2 <> ... */

               end. /* FOR EACH ABS_COMP */

               /* CANCEL BACKORDERS ONLY IF THERE EXISTS NO */
               /* UNCONFIRMED SHIPPERS FOR SAME SO LINE     */
               if not l_unconfm_shp then do:

                  /* CHECK FOR MULTIPLE SHIPPER LINES WITHIN THE SAME        */
                  /* SHIPPER FOR A SALES ORDER LINE. CANCEL BACKORDER        */
                  /* QUANTITY ONLY FOR THE LAST SHIPPER LINE OF THAT SO LINE */
                  if can-find (first abs_comp
                     where abs_comp.abs_domain = global_domain
                     and   abs_comp.abs_order    =  sod_nbr
                     and   abs_comp.abs_line     =  string(sod_line)
                     and   abs_comp.abs_item     =  abs_work.abs_item
                     and   abs_comp.abs_ship_qty <> abs_comp.abs_qty
                     and   abs_comp.abs_id       <> abs_work.abs_id)
                  then
                     assign
                        l_multi_ln_item = yes
                        l_multi_ln_shpr = yes
                        qty_bo          = if sod_qty_ord > 0 then
                                            sod_qty_ord - sod_qty_ship - qty_chg
                                          else 0.

                  else do:

                     if (sod_qty_ord  * (sod_qty_ord -
                        (sod_qty_ship + qty_chg )) < 0)
                     then
                        sod_bo_chg = sod_qty_ord - sod_qty_ship - qty_chg.

                     /* MFSOTR.I EXPECTS QTY_ALL TO HAVE BEEN */
                     /* CONVERTED TO THE SKU UNIT OF MEASURE. */
                     assign
                        prev_qty_all = qty_all
                        qty_all      = qty_all * sod_um_conv.

                     {mfsotr.i "QTYCHG"}

                     l_save_db = global_db.

                     if global_db <> "" and
                        si_db     <> global_db
                     then do:
                        run p_gp_alias (input si_db, output l_err-flag).
                     end. /* IF GLOBAL_DB <> "" */

                     /* BACKOUT CHANGES MADE TO IN_QTY_ALL IN MFSOTR.I */
                     {gprun.i ""rcinupd.p""
                              "(input        sod_part,
                                input        sod_site,
                                input-output l_multi_ln_shpr)"}

                     if global_db <> l_save_db then do:
                        run p_gp_alias (input l_save_db, output l_err-flag).
                     end.

                     /* CANCELLING BACKORDER QUANTITY */
                     assign
                        qty_all = prev_qty_all
                        qty_bo  = 0.

                  end. /* ELSE DO */

               end. /* IF NOT L_UNCONFM_SHP */
               else
                  qty_bo = if sod_qty_ord > 0 then
                              sod_qty_ord - sod_qty_ship - qty_chg
                           else 0.

            end. /* IF SOD__QADl01 AND CONFIRM_MODE THEN */
            else
               qty_bo = if sod_qty_ord > 0 then
                           sod_qty_ord - sod_qty_ship - qty_chg
                        else 0.

            /* SAVE sod_qty_ship BEFORE THE SO ISSUE UPDATES       */
            /* IT WITH THE QTY TO BE SHIPPED. SHIPMENT PERFORMANCE */
            /* NEEDS THIS VALUE IN ORDER TO PROCESS DISCRETE       */
            /* SALES ORDERS CORRECTLY.                             */
            if first-of(work_abs_mstr.abs_item) then
               perf_ship_qty = sod_qty_ship.

            /* SWITCH TO INVENTORY DOMAIN IF NECESSARY */
            if change_db then do:
               run p_gp_alias (input ship_db, output err_flag).

               if err_flag = 2
                  or err_flag = 3
               then
                  undo progloop, leave progloop.
            end. /* IF change_db */

            /* CREATING pk_det RECORD FOR FAMILY PLANNING ITEMS. */
            if sod_sched then do:
               {mfdel.i pk_det "where pk_domain = global_domain
                                and   pk_user = mfguser"}
               part = sod_part.
               {gprun.i ""sopbex.p""}
            end. /* IF sod_sched */

            /* GET THE BASE CURRENCY OF THE REMOTE DATABASE */
            {gprun.i ""gpbascur.p"" "(output l_remote-base-curr)"}

            /* SWITCH BACK TO SALES ORDER DOMAIN IF NECESSARY */
            if change_db then do:
               run p_gp_alias (input so_db, output err_flag).

               if err_flag = 2
                  or err_flag = 3
               then
                  undo progloop, leave progloop.
            end. /* IF change_db */

            /* SS - 20060306 - B */
            /*
            /*DO A SO ISSUE*/
            {gprun.i ""rcsoisb.p""
                     "(input recid(sod_det),
                       input auto_post,
                       input so_inv_nbr,
                       input abs_mstr.abs_id,
                       input ship_dt,
                       input abs_mstr.abs_inv_mov,
                       input abs_work.abs_id)"}
                */
            /*DO A SO ISSUE*/
            {gprun.i ""xxnrcsoisb.p""
               "(input recid(sod_det),
                 input auto_post,
                 input so_inv_nbr,
                 input abs_mstr.abs_id,
                 input ship_dt,
                 input abs_mstr.abs_inv_mov,
                 input abs_work.abs_id)"}
                /* SS - 20060306 - E */

            if l_undo then
               undo progloop, leave progloop.

            /* Store cum shipped in prior cum shipped before overwriting
             * cum shipped with new value below. This section was copied
             * from sosoisu3.p where it's used to update the remote
             * domain records. Here it's used to update the central
             * domain. */

            if sod_cum_date[2] = ? then do:
               sod_cum_date[2] = eff_date - 1.
            end.
            else if sod_cum_date[2] < eff_date - 1 then do:
               assign
                  sod_cum_date[2] = eff_date - 1
                  sod_cum_qty[2] = sod_cum_qty[1].
            end.

            /* UPDATE QTY INVOICED */
            if using_cust_consignment = no
               or (using_cust_consignment and abs_consign_flag = no)
            then
               sod_qty_inv  = qty_inv.

            /* SET THE FOLLOWING IN THE CURRENT DOMAIN*/
            assign
               sod_qty_chg = 0
               sod_bo_chg  = 0
               sod_qty_ord  = qty_ord
               sod_qty_ship = qty_ship
               sod_cum_qty[1] = qty_cum_ship
               sod_pickdate = ?
               sod_qty_all  = qty_all
               sod_qty_pick = qty_pick
               sod_std_cost = std_cost.

            {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                "(input  base_curr,
                  input  l_remote-base-curr,
                  input  """",
                  input  eff_date,
                  output l_exch-rate2,
                  output l_exch-rate,
                  output mc-error-number)"}
            if mc-error-number <> 0
            then do:
              {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end. /* IF mc-error-number */

            {gprunp.i "mcpl" "p" "mc-curr-conv"
                "(input  l_remote-base-curr,
                  input  so_curr,
                  input  l_exch-rate,
                  input  l_exch-rate2,
                  input  std_cost,
                  input  false,
                  output sod_std_cost,
                  output mc-error-number)"}
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end. /*  IF mc-error-number <> 0 */

            if using_cust_consignment = no
               or
               (using_cust_consignment and abs_consign_flag = no)
               or
               (using_cust_consignment = yes and abs_consign_flag = yes
               and qty_chg < 0
               and abs_work.abs__qadc01 = "") /* NOT CONSIGNMENT RETURN */
            then

               /* The flag on control file sbic_ctrl and mfc_ctrl would always
                * be maintained in sync. So we test value of mfc_ctrl flag */
               if can-find (first mfc_ctrl
                  where mfc_domain = global_domain
                  and   mfc_field = "enable_self_bill"
                  and   mfc_seq = 2
                  and mfc_module = "ADG"
                  and mfc_logical = yes)
                  and can-find (_file where _file-name = "sbic_ctl")
                  and can-find (cm_mstr where cm_domain = global_domain
                  and cm_addr = so_bill
                  and cm__qad06 = yes)
               then do:
                  /* Create Self-Bill X-Ref Records */
                  {gprunmo.i &program = "arsixcr1.p" &module="ASB"
                             &param="""(input  abs_work.abs_id,
                                        input  abs_work.abs_shipfrom,
                                        input  substring(abs_mstr.abs_id,2),
                                        input  confirm_mode,
                                        output return_status)"""}
            end.

            /* ALWAYS ACCUMULATE QUANTITIES FOR SHIPMENT PERFORMANCE */
            if using_shipment_perf then
               total_sp_qty = (accumulate total by
                               work_abs_mstr.abs_item
                               abs_work.abs_qty) -
                              (accumulate total by
                               work_abs_mstr.abs_item
                               abs_work.abs_ship_qty) /
                               sod_um_conv.

            /* COLLECT SHIPMENT PERFORMANCE INFORMATION IF  */
            if using_shipment_perf
               and last-of(work_abs_mstr.abs_item)
            then
               run collect_ship_perf_info
                  (input  recid(sod_det),
                   input  abs_work.abs_id,
                   input  abs_work.abs_shipfrom,
                   input  shipperid,
                   input  yes,
                   input  perf_ship_qty,
                   input  confirm_mode,
                   input  total_sp_qty,
                   input  no).

         end. /* if (last-of(work_abs_mstr.abs_ref)... */

         /*HANDLE ISSUE/TRANSFER OF CONTAINER ITEMS*/
         if (last-of(work_abs_mstr.abs_ref)
            or not sum_tr_cont)
            and not work_abs_mstr.abs_id begins "I"
         then
         CONTAINERS:
         do:

            for first pt_mstr
               fields (pt_domain pt_iss_pol pt_part pt_prod_line pt_site pt_um)
               where pt_domain = global_domain
               and   pt_part = abs_work.abs_item
            no-lock: end.

            if available pt_mstr then do:

               for first in_mstr
                  fields (in_domain in_cur_set in_gl_set in_iss_date in_part
                          in_qty_all in_qty_oh in_qty_req in_rec_date
                          in_site in_gl_cost_site)
                  where   in_domain = global_domain
                  and     in_site = pt_site
                  and     in_part = pt_part
               no-lock: end.

               for first pl_mstr
                  fields (pl_domain pl_cop_acct pl_cop_cc pl_flr_acct
                          pl_cop_sub pl_flr_sub
                          pl_flr_cc pl_prod_line)
                  where   pl_domain = global_domain
                  and     pl_prod_line = pt_prod_line
               no-lock: end.

               {gpsct03.i &cost=sct_cst_tot}

               /* ASSIGN SHIP-TO OF THE PARENT RECORD (L_SHIPTO) TO */
               /* CONTAINER (ADDR)                                  */
               assign
                  global_part = abs_work.abs_item
                  part        = abs_work.abs_item
                  unit_cost   = glxcst
                  so_job      = ""
                  addr        = l_shipto
                  rmks        = getTermLabel("CONTAINER_ISSUE", 15)
                  cr_acct     = ""
                  cr_sub      = ""
                  cr_cc       = ""
                  project     = ""
                  issrct      = "ISS"
                  conv         = 1.

               if not pt_iss_pol then do:
                  {gprun.i ""glactdft.p""
                           "(input ""WO_FLR_ACCT"",
                             input pl_prod_line,
                             input pt_site,
                             input """",
                             input """",
                             input no,
                             output dr_acct,
                             output dr_sub,
                             output dr_cc)"}
               end. /* IF NOT PT_ISS_POL */
               else do:
                  {gprun.i ""glactdft.p""
                           "(input ""WO_COP_ACCT"",
                             input pl_prod_line,
                             input pt_site,
                             input """",
                             input """",
                             input no,
                             output dr_acct,
                             output dr_sub,
                             output dr_cc)"}
               end.

               create work_sr_wkfl.
               assign
                  work_sr_wkfl.sr_domain = global_domain
                  work_sr_wkfl.sr_userid = mfguser
                  work_sr_wkfl.sr_lineid = abs_work.abs_line
                  work_sr_wkfl.sr_site = abs_work.abs_site
                  work_sr_wkfl.sr_loc = abs_work.abs_loc
                  work_sr_wkfl.sr_lotser = abs_work.abs_lotser
                  work_sr_wkfl.sr_ref = abs_work.abs_ref.

               if confirm_mode then
                  assign
                     work_sr_wkfl.sr_qty = tmp_issueqty - tmp_shipqty.
               else
                  assign
                     work_sr_wkfl.sr_qty = (-1) * tmp_issueqty.

               transtype = "ISS-UNP".

               if recid(work_sr_wkfl) = -1 then.

               {gprun.i ""rcsoisc.p""
                        "(input abs_work.abs_shipfrom)"}

            end.

         end. /* CONTAINERS:  */

         /* SKIP KIT COMPONENTS HERE */
         if not (available sod_det
            and sod_part <> abs_work.abs_item
            and abs_work.abs_id begins "i")
         then do:
            if confirm_mode then
               abs_work.abs_ship_qty = abs_work.abs_qty.
            else
               abs_work.abs_ship_qty = 0.

            abs_work.abs_shp_date = ship_dt.
         end. /*  if not (available sod_det ... */

         /* For orders which are owned and invoiced by an */
         /* External system, shipment does not mean invoice. */
         /* The external system will send an invoice, MFG/PRO */
         /* Will not update sod_qty_inv or invoice the trailer */
         /* Charges.  Should additonal charges be added during */
         /* Shipment, the charges will be exported to the external */
         /* System via calls to the Logistics API. */
         if last-of(work_abs_mstr.abs_line) and
            available (sod_det)
         then do:
            if sod_nbr = work_abs_mstr.abs_order then do:
               if so_app_owner > "" then do:
                  if can-find(first lgs_mstr
                     where lgs_domain = global_domain
                     and   lgs_app_id = so_app_owner
                     and   lgs_invc_imp = yes)
                  then do:
                     /* External Invoicing is active */
                     /* Taxes need to be recalculated since */
                     /* They include what was shipped. */
                     l_recalc = yes.
                  end.
               end.
            end.
         end.

         /* Recompute taxes if any line resulted in a qty change */
         /* Export trailer charges if any present */
         if last-of(work_abs_mstr.abs_order) and
            available (sod_det)
         then do:
            if sod_nbr = work_abs_mstr.abs_order then do:
               if so_app_owner > "" then do:

                  if can-find (lgs_mstr
                     where lgs_domain = global_domain
                     and   lgs_app_id = so_app_owner
                     and   lgs_invc_imp = yes no-lock)
                  then do:

                     /* External Invoicing is active */
                     if l_recalc = yes then do:
                        /* Update the taxes */
                        {gprun.i ""txcalc.p""
                                 "(input '13',
                                   input sod_nbr,
                                   input '',
                                   input 0,
                                   input no,
                                   output return_status)"}
                        l_recalc = no.
                     end.

                     /* Are any trailer charges still outstanding? */
                     /* MFG/PRO is not doing the billing.  Inform */
                     /* The external system which is handling the */
                     /* Billing of the trailers charges MFG/PRO */
                     /* Has applied. */
                     if so_trl1_amt <> 0 or
                        so_trl2_amt <> 0 or
                        so_trl3_amt <> 0
                     then do:
                        /* Inform the External System */
                        {gprunmo.i &module = "LG" &program = "lgtrlex.p"
                                   &param = """(input so_nbr)"""}
                     end.
                  end. /* if can-find lgs */
               end.
            end.
         end.
      end. /* for each work_abs_mstr */
   end. /* issue_inventory_loop: do transaction: */

   {&RCSOIS1A-P-TAG9}

    /* MARK SHIPPER CONFIRMED */
   for first abs_mstr fields (abs_domain abs_mstr.abs_status)
      where abs_mstr.abs_domain = global_domain
      and recid(abs_mstr) = abs_recid
   exclusive-lock: end.

   if available abs_mstr then do transaction:
      if confirm_mode then
         substring(abs_mstr.abs_status,2,1) = "y".
      else
         substring(abs_mstr.abs_status,2,1) = "".
   end. /* IF AVAILABLE abs_mstr DO TRANSACTION */

   if not auto_post and auto_inv then do:
      /* POST BEFORE NEXT SHIPMENT TO AVOID INVOICE CONSOLIDATION */
       run p_display_message (input 8307,
                             input 2).
   end.

   /* PRINT INVOICES IF WE NEED TO.  THIS SECTION  WAS  ADDED
    * FOR BRAZILIAN REQUIREMENTS.  */
   subloop:
   do transaction on error undo, leave:

      if auto_post or auto_inv then do:

         inv_ct = 0.

         /*FIRST ASSIGN INVOICE NUMBERS*/
         {&RCSOIS1A-P-TAG12}
         do i = 1 to order_ct:

            order_num = if (i <= 30) then
                           order_nbrs[i]
                        else
                           entry(i - 30,order_nbr_list).

            find so_mstr
               where so_mstr.so_domain = global_domain
               and   so_nbr = order_num
            exclusive-lock.

            if use_shipper then
               assign
                  new_inv_nbr = substring(abs_mstr.abs_id,2,50)
                  inv_ct = 1.
            else
            if (consolidate and i = 1)
               or not consolidate
            then do:

               /* LOCK AND HOLD THE qad_wkfl SO THAT ONLY ONE PROGRAM */
               /* CAN CREATE INVOICE NUMBERS AT A TIME                */
               {gprun.i ""sorp10a.p""}

               assign
                  so_recno = recid(so_mstr)
                  next_inv_pre = soc_inv_pre
                  {&RCSOIS1A-P-TAG2}
                  next_inv_nbr = soc_inv - 1.
              
               {gprun.i ""sosoina.p"" "(output l_ret_flag)"}
               if l_ret_flag
               then
                  undo progloop,leave progloop.
              

               {&RCSOIS1A-P-TAG13}

               assign
                  new_inv_nbr = so_inv_nbr
                  inv_ct = inv_ct + 1.

               if auto_post and not auto_inv then do:
                  {gprun.i ""sorp10b.p""}
               end. /* IF AUTO_POST AND NOT AUTO_INV */

            end. /* IF (CONSOLIDATE AND I = 1) OR NOT CONSOLIDATE */

            if inv_ct <= 30 then
               inv_nbrs[inv_ct] = new_inv_nbr.
            else
               inv_nbr_list = inv_nbr_list + new_inv_nbr + ",".

            if (so_inv_nbr <> " ")
               and (so_inv_nbr <> new_inv_nbr)
            then
               if auto_inv   = yes
                  and auto_post = no
               then do:
                  {gprun.i ""txdelete.p""
                           "(input '16',
                             input so_inv_nbr,
                             input so_nbr)"}
               end. /* IF auto_inv = yes ... */

            assign
               so_inv_nbr = new_inv_nbr
               so_ship = abs_mstr.abs_shipto
               so_to_inv = no
               so_invoiced = yes
               so_ship_date = ship_dt
               so_tax_date = ship_dt
               so_print_bl = no.

            {&RCSOIS1A-P-TAG16}
            so_inv_date = eff_date.
            {&RCSOIS1A-P-TAG17}

            /* For orders which are invoiced by an external system */
            /* We need to disable the invoice if any charges */
            if can-find (lgs_mstr
               where lgs_domain = global_domain
               and   lgs_app_id = so_app_owner
               and   lgs_invc_imp = yes no-lock)
            then do:
               /* External Invoicing is active */
               /* Are any trailer charges still outstanding? */
               if so_trl1_amt <> 0 or
                  so_trl2_amt <> 0 or
                  so_trl3_amt <> 0
               then do:
                  /* MFG/PRO is not doing the billing. */
                  /* Turn off invoicing */
                  assign
                     so_to_inv = no
                     so_invoiced = no.
               end.
            end.

         end. /* DO I = 1 TO ORDER_CT */

      end. /* IF AUTO_POST OR AUTO_INV THEN DO: */

      do on error undo, retry:

         if inv_ct >  0 then do:
            if auto_inv then do:
               {&RCSOIS1A-P-TAG6}

               {&RCSOIS1A-P-TAG7}
               conso = consolidate.

               {&RCSOIS1A-P-TAG4}
               {gprun.i ""rcsorp10.p""
                  "(input  table tt_somstr,
                    output undo_stat)"}
               {&RCSOIS1A-P-TAG5}

               if undo_stat then do:

                  {&RCSOIS1A-P-TAG3}

                  /*RESET INVOICE NUMBERS SO WE CAN DO IT AGAIN IF NEEDED*/
                  do i = 1 to order_ct:
                     order_num = if (i <= 30) then
                                    order_nbrs[i]
                                 else
                                    entry(i - 30,order_nbr_list).

                     find so_mstr
                        where so_domain = global_domain
                        and   so_nbr = order_num
                     exclusive-lock.

                     find temp_somstr
                        where temp_so_nbr = order_num
                     no-lock no-error.

                     if available temp_somstr then
                        assign
                           so_inv_nbr = temp_so_inv_nbr
                           so_inv_date = temp_so_inv_date.
                     else
                        assign
                           so_inv_nbr = ""
                           so_inv_date = ?.

                     assign
                        so_to_inv  = yes
                        so_invoiced = no
                        so_ship = temp_so_ship
                        so__qadc01 = temp_so_qadc01.

                     for first tt_somstr
                        where tt_sonbr = so_nbr
                     no-lock :
                     end.
                     if available tt_somstr
                     then
                        so_to_inv = tt_sotoinv.

                  end. /* do i = 1 to order_ct */

                  /* IF UNDO_STAT IS YES, DON'T POST THE INVOICE.  BUT */
                  /* UPDATE THE SHIPPER STATUS                         */
                  assign
                     auto_post = no
                     inv_ct    = 0.

                  release qad_wkfl.
                  leave subloop.

               end.
               else do:
                  {gprun.i ""sorp10b.p""}
               end. /* IF NOT UNDO_NOTA */

            end. /* if auto_inv */
         end.

         release soc_ctrl.
         release qad_wkfl.

      end. /* DO ON ERROR UNDO RETRY */

   end. /* SUBLOOP */

   if auto_post
   then do transaction:

      run p-update-for-invoicing (input auto_inv).

      /* Posting Invoice */
      run p_display_message (input 8235,
                             input 1).

      do i = 1 to inv_ct:

         assign
            cust1 = hi_char
            bill1 = hi_char
            inv = if (i <= 30) then
                     inv_nbrs[i]
                  else
                     entry(i - 30,inv_nbr_list)
            inv1 = inv
            post = yes
            gl_sum = yes
            print_lotserials = no
            undo_all = no
            insbase = no.

         for first svc_ctrl
            fields (svc_domain svc_isb_bom svc_pt_mstr svc_ship_isb)
            where   svc_domain = global_domain
         no-lock: end.

         if available svc_ctrl then
            assign
               serialsp = "S"
               nsusebom = no
               usebom   = svc_isb_bom
               needitem = svc_pt_mstr
               insbase  = svc_ship_isb.

         if insbase then do:
            {gpfildel.i &filename=""ISBPST.prn""}
            output stream prt2  to "ISBPST.prn".
         end. /* IF INSBASE */

         assign
            expcount = 999
            pageno = 0.

         if opsys = "unix" then
            output to "/dev/null".
         else
         if opsys = "msdos" or opsys = "win32" then
            output to "nul".

         l_increment = no.

         so_mstr-loop:
         for each so_mstr
            fields (so_domain so_app_owner so_bill so_bol so_ca_nbr
                    so_cum_acct so_curr so_cust so_exru_seq so_sched
                    so_ex_rate so_ex_rate2 so_ex_ratetype
                    so_fix_rate so_fob so_fsm_type so_invoiced
                    so_inv_date so_inv_nbr so_nbr so_print_bl
                    so_rev so_ship so_shipvia so_ship_date
                    so_slspsn so_tax_date so_to_inv so_trl1_amt
                    so_trl2_amt so_trl3_amt so__qadc01)
            where   so_domain = global_domain
            and     so_inv_nbr  = inv
            and     so_invoiced   = yes
            and     so_to_inv     = no
         no-lock
         use-index so_invoice:
            for each sod_det
               fields (sod_domain sod_bo_chg sod_cum_date sod_cum_qty
                       sod_fsm_type sod_line sod_list_pr sod_lot
                       sod_nbr sod_part sod_per_date sod_pickdate
                       sod_price sod_prodline sod_qty_all
                       sod_qty_chg sod_qty_inv sod_qty_ord
                       sod_qty_pick sod_qty_ship sod_sched
                       sod_serial sod_site sod_std_cost sod_type
                       sod_um sod_um_conv sod__qadl01
                       sod_disc_pct sod_promise_date sod_contr_id)
               where sod_domain = global_domain
               and   sod_nbr = so_nbr
            no-lock:

               l_po_schd_nbr = if so_sched then
                                  sod_contr_id
                               else
                                  "".

               if (sod_price * sod_qty_inv) <> 0
                  or sod_disc_pct           <> 0
               then do:
                  l_increment = yes.
                  leave so_mstr-loop.
               end. /* IF (sod_list_pr * sod_qty_inv) OR ...*/

               run p-check(input so_nbr,
                           input so_inv_nbr,
                           output l_increment).

               if l_increment = yes
               then
                 leave so_mstr-loop.


            end. /* FOR EACH sod_det */

            /* TO ACCUMULATE TAX AMOUNTS OF SHIPPED SO ONLY ('13'/ '14' type) */
            for each tx2d_det
/*               fields (tx2d_domain tx2d_cur_tax_amt tx2d_ref tx2d_tr_type   */
/*               				 tx2d_tax_code)                                       */
               where   tx2d_domain  = global_domain
               and    (tx2d_ref     = so_nbr
               and    (tx2d_tr_type = '13'
               or      tx2d_tr_type = '14'))
            no-lock:
               l_cur_tax_amt = l_cur_tax_amt + absolute(tx2d_cur_tax_amt).
            end.

            if (absolute(so_trl1_amt) + absolute(so_trl2_amt) +
                absolute(so_trl3_amt) + l_cur_tax_amt) <> 0
            then do:
               l_increment = yes.
               leave so_mstr-loop.
            end. /* IF ABSOLUTE(so_trl1_amt) + ... */

         end. /* FOR EACH SO_MSTR */

         if l_increment
         then do:
            /* CREATE JOURNAL REFERENCE */
            {gprun.i ""sonsogl.p"" "(input eff_date)"}
         end.
         else do:
            run p_getbatch.
            ref   = "".
         end. /* ELSE DO */

         /* GL TRANSACTIONS FOR FREIGHT ACCOUNTS GET CREATED         */
         /* PRIOR TO INVOICE POST, FOR CONSISTENCY WITH SO SHIPMENTS */
         undo_all = no.
         /*V8! if key-function(last-key) = "END-ERROR" then
            readkey pause 0. */

         {&RCSOIS1A-P-TAG14}

         {gprun.i ""soivpst1.p""
                  "(input abs_recid,
                    input l_po_schd_nbr)"}

         if undo_all then do:
            o_undo = false.
            undo progloop, leave progloop.
         end.

         /* RESET PRINT FILE FOR INSTALLED BASE UPDATE */
         if insbase then do:
            put stream prt2 " ".
            output stream prt2 close.
         end. /* IF INSBASE */

         output close.

         if undo_all then do:
            run p_display_message (input 8236,
                                   input 3).
            run p_display_message (input 8237,
                                   input 1).
            pause.
            undo progloop, leave.
         end.

         else do:

            find ba_mstr
               where ba_domain = global_domain
               and   ba_batch  = batch
               and   ba_module = "SO"
            exclusive-lock no-error.

            if available ba_mstr then
               assign
                  ba_total  = ba_total + batch_tot
                  ba_ctrl   = ba_total
                  ba_userid = global_userid
                  ba_date   = today
                  batch_tot = 0
                  ba_status = "".

            release ba_mstr.

            /* ZERO SOD_QTY_INV IN REMOTE DOMAIN SOD RECORDS IF THERE ARE*/
            if available so_mstr then do:
               {gprun.i ""rcsoisd.p"" "(input so_nbr, input no)"}
            end.
         end.
      end.

      /*RESTORE SHIP-TO'S AND INVOICE METHOD*/
      do i = 1 to order_ct:

         order_num = if (i <= 30) then
                        order_nbrs[i]
                     else
                        entry(i - 30,order_nbr_list).

         find so_mstr
            where so_domain = global_domain
            and   so_nbr = order_num
         exclusive-lock no-error.

         if available so_mstr then
            if (i <= 30) then
               assign
                  so_ship = so__qadc01 when ( so__qadc01 <> "" )
                  so__qadc01 = ""
                  so_fob = temp_fob[i]
                  so_shipvia = temp_shipvia[i].
            else
               assign
                  so_ship = so__qadc01 when ( so__qadc01 <> "" )
                  so__qadc01 = ""
                  so_fob = entry(i - 30, temp_fob_list)
                  so_shipvia = entry(i - 30, temp_shipvia_list).

      end.

      if {gpiswrap.i} then
         /* POSTING COMPLETE */
         run p_display_message (input 4276,
                                input 1).
      hide message no-pause.

   end.

   /* MARK SHIPPER CONFIRMED */
   do transaction:

      find abs_mstr where recid(abs_mstr) = abs_recid exclusive-lock.

      if que-doc then do:

         for first ad_mstr
            fields (ad_domain ad_addr ad_edi_ctrl)
            where   ad_domain = global_domain
            and     ad_addr = abs_shipto
         no-lock: end.

         if available ad_mstr
            and ad_edi_ctrl[1] ="e"
         then do:

            assign
               doc-type = "ASN"
               doc-ref  = abs_shipfrom
               add-ref  = abs_id
               msg-type = "ASN".

            /* QUEUE DOCUMENT FOR TRANSMISSION - BTB */
            if confirm_mode then
               {gprun.i ""gpquedoc.p""
                        "(input-output doc-type,
                          input-output doc-ref,
                          input-output add-ref,
                          input-output msg-type,
                          input-output trq-id,
                          input yes)"}.

         end. /* ad_edi_ctrl[1] = "e" */

      end. /* QUEUE DOCUMENT FOR TRANSMISSION */

      assign
         abs_mstr.abs_eff_date = eff_date
         abs_mstr.abs_shp_date = ship_dt.

   end. /* do transaction */

   /* CONFIRM PEGGED SHIPPER LINES */
   {gprun.i ""rcsois3a.p"" "(input abs_recid)"}

   for each work_abs_mstr
      where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty
   no-lock:

      for first sod_det
         fields (sod_domain sod_bo_chg sod_cum_date sod_cum_qty sod_fsm_type
                 sod_line sod_list_pr sod_lot sod_nbr sod_part
                 sod_per_date sod_pickdate sod_price sod_prodline
                 sod_qty_all sod_qty_chg sod_qty_inv sod_qty_ord
                 sod_qty_pick sod_qty_ship sod_sched sod_serial
                 sod_site sod_std_cost sod_type sod_um sod_um_conv
                 sod__qadl01)
          where  sod_domain = global_domain
          and    sod_nbr  = work_abs_mstr.abs_order
          and    sod_line = integer(work_abs_mstr.abs_line)
      no-lock:

         if sod_sched then do:

         for first so_mstr
            fields (so_domain so_app_owner so_bill so_bol so_ca_nbr so_cum_acct
                    so_curr so_cust so_exru_seq so_ex_rate so_ex_rate2
                    so_ex_ratetype so_fix_rate so_fob so_fsm_type
                    so_invoiced so_inv_date so_inv_nbr so_nbr
                    so_print_bl so_rev so_ship so_shipvia so_ship_date
                    so_slspsn so_tax_date so_to_inv so_trl1_amt
                    so_trl2_amt so_trl3_amt so__qadc01)
            where so_domain = global_domain
            and   so_nbr = sod_nbr
         no-lock: end.

         /* FOR NON-CUM ORDERS RELIEVE MRP REQUIREMENTS */
         if not so_cum_acct then do:
            {gprun.i ""rcmrw.p""
               "(input sod_nbr,
                 input sod_line,
                 input no)"}
         end. /* IF NOT SO_CUM_ACCT */

         end. /* IF SOD_SCHED */

         /* ss - 111117.1 -b */
         for each tx2d_det
 /*             fields (tx2d_domain tx2d_cur_tax_amt tx2d_ref tx2d_tr_type    */
 /*             				tx2d_line tx2d_tax_code)                              */
              where   tx2d_domain  = global_domain
              and    tx2d_ref     = sod_nbr
              and    (tx2d_tr_type = '13')
                      AND tx2d_line = sod_line : 
           
               DELETE tx2d_det .
           end.

        /* ss - 111117.1 -e */

      end. /* FOR FIRST SOD_DET */

   end. /* FOR EACH WORK_ABS_MSTR */

   o_undo = false.

end. /* progloop */

PROCEDURE p-get-parent-id:
/*--------------------------------------------------------------------
 * Purpose:    Get Shipper ID for a shipper line
 *----------------------------------------------------------------------*/
   define input  parameter l_recid      as   recid           no-undo.
   define output parameter l_absid      like abs_id          no-undo.

   define variable l_par_recid as  recid no-undo.
   define buffer   b_abs_mstr  for abs_mstr.

   /* FIND TOP-LEVEL PARENT SHIPPER OR PRESHIPPER */
   {gprun.i ""gpabspar.p""
            "(input l_recid,
              input 'PS',
              input false,
              output l_par_recid)"}

   for first b_abs_mstr
      fields (abs_domain abs_eff_date abs_fa_lot abs_format
              abs_id abs_inv_mov abs_item abs_line
              abs_loc abs_lotser abs_order abs_qty
              abs_par_id abs_ref abs_shipfrom
              abs_shipto abs_ship_qty abs_shp_date
              abs_site abs_status abs__qad03
              abs__qad10)
      where recid(b_abs_mstr) = l_par_recid
   no-lock:
      l_absid   = b_abs_mstr.abs_id.
   end.

END PROCEDURE.

PROCEDURE collect_ship_perf_info:
   define input parameter ip_sodrecid as recid no-undo.
   define input parameter ip_abs_id like abs_mstr.abs_id no-undo.
   define input parameter ip_shipfrom like abs_mstr.abs_shipfrom no-undo.
   define input parameter ip_shipperid like abs_mstr.abs_id no-undo.
   define input parameter ip_logical like mfc_logical no-undo.
   define input parameter ip_perf_ship_qty like abs_mstr.abs_qty no-undo.
   define input parameter ip_confirm_mode like mfc_logical no-undo.
   define input parameter ip_total_sp_qty like abs_mstr.abs_qty no-undo.
   define input parameter ip_logical2 like mfc_logical no-undo.

   {gprunmo.i &program = ""soshpso.p"" &module = "ASR"
              &param   = """(input  ip_sodrecid,
                             input  ip_abs_id,
                             input  ip_shipfrom,
                             input  ip_shipperid,
                             input  ip_logical /*YES*/,
                             input  ip_perf_ship_qty,
                             input  ip_confirm_mode,
                             input  ip_total_sp_qty,
                             input  ip_logical2 /*no*/)"""}
END PROCEDURE.

PROCEDURE p_gp_alias:
/*-----------------------------------------------------------------------
 * Purpose:      To Establish an Alias for a particular db
 *
 * Parameters:   i_db          Name of the database
 *               o_err_flag    If true, then database alias not established
 *
 * Note:         Procedure created to remove Error "Action Segment has exceeded
 *               its limit of 63488 bytes".
 *-------------------------------------------------------------------------*/

   define input  parameter l_db       like global_db   no-undo.
   define output parameter l_err_flag like mfc_logical no-undo.

   define variable         l_err_num  as   integer     no-undo.

   {gprun.i ""gpalias3.p"" "(input l_db, output l_err_num)"}

   l_err_flag = l_err_num = 2 or l_err_num = 3.

   if l_err_flag then do:
      /* DOMAIN # IS NOT AVAILABLE */
      {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4 &MSGARG1=l_db}
   end. /* IF l_err_flag */

END PROCEDURE.  /* p_gp_alias */

PROCEDURE p-kitinvchk:
/*-----------------------------------------------------------------------
 * Purpose:      To check the inventory for Overissue Status fo kit
 *               components
 * Parameters:   l_undo        logical field to undo
 *-------------------------------------------------------------------------*/

   define output parameter l_undo like mfc_logical no-undo.

   define variable trans_conv like sod_um_conv.
   define variable l_db       like global_db no-undo.

   define buffer   work_abs_buff for work_abs_buff.
   define buffer   pt_mstr       for pt_mstr.
   define buffer   si_mstr       for si_mstr.

   for each work_abs_buff
      fields (abs_id abs_item abs_line abs_order abs_qty
              abs_shipfrom abs_ship_qty abs_site abs__qad03
              abs__qad06 abs__qad07)
      where   work_abs_buff.abs_order <> ""
      and     work_abs_buff.abs_item  <> ""
      and     work_abs_buff.abs_id  begins "i"
      and     work_abs_buff.abs_par_id begins "i"
   no-lock:
      trans_conv = 1.
      if can-find (first work_ldd
         where work_ldd_id = work_abs_buff.abs_id )
      then
         next.

      if (confirm_mode = yes and work_abs_buff.abs_qty > 0 )
         or
         (confirm_mode = no and work_abs_buff.abs_qty < 0 )
      then do:

         /* GET THE CORRECT UM */
         for first pt_mstr
            fields (pt_domain pt_part pt_um)
            where   pt_domain = global_domain
            and     pt_part = work_abs_buff.abs_item
         no-lock:
            if work_abs_buff.abs__qad02 <> pt_um
            then do:
               {gprun.i ""gpumcnv.p""
                        "(input work_abs_buff.abs__qad02,
                          input pt_um, input pt_part,
                          output trans_conv)"}
            end. /* IF work_abs_buff .. */
         end. /* FOR FIRST pt_mstr */

         l_db = global_db.
         for first si_mstr
            fields (si_domain si_db si_site)
            where   si_domain = global_domain
            and     si_site = work_abs_buff.abs_site
         no-lock:
            if si_db <> global_db then do:
               {gprun.i ""gpalias3.p"" "(input si_db, output err_flag)"}
            end.
         end. /* FOR FIRST si_mstr */

         {gprun.i ""rcinvchk.p""
                  "(input  work_abs_buff.abs_item,
                    input  work_abs_buff.abs_site,
                    input  work_abs_buff.abs_loc,
                    input  work_abs_buff.abs_lot,
                    input  work_abs_buff.abs_ref,
                    input  work_abs_buff.abs_qty * trans_conv,
                    input  work_abs_buff.abs_id,
                    input  no,
                    output l_undo)"}

         if l_db <> global_db then do:
            {gprun.i ""gpalias3.p"" "(input l_db, output err_flag)"}
         end.

         if l_undo then
            return.

      end. /* IF confirm_mode ... */
   end. /* FOR EACH work_abs_buff.. */

   empty temp-table compute_ldd no-error.

END PROCEDURE.

PROCEDURE p_display_message:
/*-------------------------------------------------------------------------
 * Purpose:      To display message using pxmsg.i
 *
 * Parameters:   i_msg_nbr      Message number
 *               i_err_level    Error Level
 *
 * Note:         Procedure created to remove Error "Action Segment has
 *               exceeded its limit of 63488 bytes".
 *-------------------------------------------------------------------------*/

   define input  parameter i_msg_nbr      as integer     no-undo.
   define input  parameter i_err_level    as integer     no-undo.

   {pxmsg.i &MSGNUM=i_msg_nbr &ERRORLEVEL=i_err_level}


END PROCEDURE.  /* p_display_message */

PROCEDURE p_init_proc:
/*--------------------------------------------------------------------------
 * Purpose:      Clean up temp tables and assign sum_tr_cont and sum_tr_item
 *
 * Parameters:   sum_tr_item    Setting of shc_sum_tr_item from mfc_ctrl
 *               sum_tr_cont    Setting of shc_sum_tr_cont from mfc_ctrl
 *
 * Note:         Procedure created to remove Error "Action Segment has
 *               exceeded its limit of 63488 bytes".
 *--------------------------------------------------------------------------*/

   define output parameter sum_tr_item like sum_tr_item no-undo.
   define output parameter sum_tr_cont like sum_tr_cont no-undo.

   /* INITIALIZE WORKFILE */
   for each work_trnbr exclusive-lock:
      delete work_trnbr.
   end.

   for each temp_somstr exclusive-lock:
      delete temp_somstr.
   end.

   for first mfc_ctrl
      fields (mfc_domain mfc_field mfc_logical mfc_module mfc_seq)
      where   mfc_domain = global_domain
      and     mfc_field = "shc_sum_tr_item"
   no-lock:
      sum_tr_item = mfc_logical.
   end.

   if not available mfc_ctrl then
      sum_tr_item = false.

   for first mfc_ctrl
      fields (mfc_domain mfc_field mfc_logical mfc_module mfc_seq)
      where   mfc_domain = global_domain
      and     mfc_field = "shc_sum_tr_cont"
   no-lock:
      sum_tr_cont = mfc_logical.
   end.

   if not available mfc_ctrl then
      sum_tr_cont = false.

END PROCEDURE.  /* p_init_proc */

PROCEDURE p_lot_serial_validate:
/*-------------------------------------------------------------------------
 * Purpose:      check for the presence of lot/serial number for lot/serial
 *               controlled kit parent and components
 *
 * Parameters:   order    Setting of order  from work_abs_mstr.abs_order
 *               line     Setting of line   from work_abs_mstr.abs_line
 *               site     Setting of site   from work_abs_mstr.abs_site
 *               loc      Setting of loc    from work_abs_mstr.abs_loc
 *               item     Setting of item   from work_abs_mstr.abs_item
 *               lotser   Setting of lotser from work_abs_mstr.abs_lotser
 *               ref      Setting of ref    from work_abs_mstr.abs_ref
 *               qty      Setting of qty    from work_abs_mstr.abs_qty
 *               qad02    Setting of qad02  from work_abs_mstr.abs__qad02
 *               rejected Setting of the rejected flag
 *
 * Note:         Procedure created to remove Error "Action Segment has
 *               exceeded its limit of 63488 bytes".
 *-------------------------------------------------------------------------*/

   define input parameter order  like abs_order      no-undo.
   define input parameter line   like abs_line       no-undo.
   define input parameter site   like abs_site       no-undo.
   define input parameter loc    like abs_loc        no-undo.
   define input parameter item   like abs_item       no-undo.
   define input parameter lotser like abs_lotser     no-undo.
   define input parameter ref    like abs_ref        no-undo.
   define input parameter qty    like abs_qty        no-undo.
   define input parameter qad02  like abs__qad02     no-undo.
   define output parameter rejected like mfc_logical no-undo.
   if item <> ""
      and not can-find(first pt_mstr
      where pt_domain   = global_domain
      and   pt_part     = item
      and   pt_pm_code  = "C"
      and   pt_cfg_type = "2")
   then do:
      if can-find (first sod_det
         where sod_domain      = global_domain
         and   sod_nbr         = order
         and   string(sod_line)= line
         and   sod_cfg_type    = "2")
      then do:
         /* SWITCH TO INVENTORY DOMAIN IF NECESSARY */
         if change_db
         then do:
            run p_gp_alias (input ship_db, output err_flag).
            if err_flag = 2
               or err_flag = 3
            then do:
               assign
                  rejected = yes
                  undo_stat = yes.
                  return.
            end. /*  if err_flag = 2 or or err_flag = 3 */
         end. /* IF change_db */

         {gprun.i ""icedit.p""
                 "(input ""ISS-SO"",
                   input site,
                   input loc,
                   input item,
                   input lotser,
                   input ref,
                   input qty,
                   input qad02,
                   input """",
                   input """",
                   output rejected)"}
      end. /* IF NOT CAN-FIND ... */

      if rejected then do:
         /* UNABLE TO ISSUE OR RECEIVE FOR ITEM # */
         {pxmsg.i &MSGNUM=161 &ERRORLEVEL=3
                  &MSGARG1=item}
         undo_stat = yes.
      end. /* IF rejected */
      /* SWITCH BACK TO SALES ORDER DOMAIN IF NECESSARY */
      if change_db
      then do:
         run p_gp_alias (input so_db, output err_flag).
         if err_flag = 2
            or err_flag = 3
         then do:
            assign
               rejected = yes
               undo_stat = yes.
               return.
         end. /*  if err_flag = 2 or or err_flag = 3 */
      end. /* IF change_db */
   end. /* IF item <> "" */

END PROCEDURE. /* p_lot_serial_validate */

PROCEDURE DisplayMessage:
   define input parameter pMsgNum as integer no-undo.
   define input parameter pLevel  as integer no-undo.
   define input parameter pMsg1   as character no-undo.

   {pxmsg.i &MSGNUM     = pMsgNum
            &ERRORLEVEL = pLevel
            &MSGARG1    = pMsg1}
END PROCEDURE.

PROCEDURE p_getbatch:
/*--------------------------------------------------------------------
  Purpose: Get next AR batch number
---------------------------------------------------------------------*/

   if can-find(first soc_ctrl
      where soc_domain = global_domain
      and   soc_ar     = yes)
   then do:

      {mfnctrl.i "arc_ctrl.arc_domain = global_domain"
                 "arc_ctrl.arc_domain"
                 "ar_mstr.ar_domain = global_domain"
                 arc_ctrl
                 arc_batch
                 ar_mstr
                 ar_batch
                 batch}

      if not can-find(first ba_mstr
         where ba_domain = global_domain
         and   ba_batch  = batch
         and   ba_module = "SO")
      then do:

         create ba_mstr.
         assign
            ba_domain   = global_domain
            ba_batch    = batch
            ba_module   = "SO"
            ba_doc_type = "I"
            ba_status   = "NU" /* NOT USED */.

      end. /* IF NOT CAN-FIND(FIRST ba_mstr... */

   end. /* IF CAN-FIND(FIRST soc_ctrl.. */

END PROCEDURE. /* PROCEDURE p_getbatch */

PROCEDURE p-check:

define input  parameter ip_sod_nbr    like tt_sonbr    no-undo.
define input  parameter ip_so_inv_nbr like so_inv_nbr  no-undo.
define output parameter op_lupdate    like l_increment no-undo.

for each work_abs_mstr
   where work_abs_mstr.abs_order = ip_sod_nbr
no-lock :

   if    ((can-find (first absl_det
                   where absl_det.absl_domain  = global_domain
                   and   absl_abs_id           = work_abs_mstr.abs_id
                   and   absl_order            = work_abs_mstr.abs_order
                   and   string(absl_ord_line) = string (work_abs_mstr.abs_line)
                   and   absl_abs_shipfrom     = work_abs_mstr.abs_shipfrom
                   and   absl_confirmed        = yes
                   and   absl_inv_post         = no
                   and   absl_lc_amt           <> 0 ))
      or
         (can-find(first absl_det
                   where absl_det.absl_domain  = global_domain
                   and   absl_order            = work_abs_mstr.abs_order
                   and   string(absl_ord_line) = string (work_abs_mstr.abs_line)
                   and   absl_abs_shipfrom     = work_abs_mstr.abs_shipfrom
                   and   absl_confirmed        = yes
                   and   absl_inv_nbr          = ip_so_inv_nbr
                   and   absl_inv_post         = no
                   and   absl_lc_amt           <> 0 )))

      or ((can-find (first abscc_det
                    where abscc_det.abscc_domain = global_domain
                    and   abscc_abs_id          = work_abs_mstr.abs_id
                    and   abscc_order           = work_abs_mstr.abs_order
                    and  string(abscc_ord_line) = work_abs_mstr.abs_line
                    and   abscc_abs_shipfrom    = work_abs_mstr.abs_shipfrom
                    and   abscc_confirmed       = yes
                    and   abscc_inv_post        = no
                    and   abscc_cont_price      <> 0))
         or
         (can-find(first abscc_det
                    where abscc_det.abscc_domain = global_domain
                    and   abscc_order           = work_abs_mstr.abs_order
                    and  string(abscc_ord_line) = work_abs_mstr.abs_line
                    and   abscc_abs_shipfrom = work_abs_mstr.abs_shipfrom
                    and   abscc_confirmed    = yes
                    and   abscc_inv_nbr      = ip_so_inv_nbr
                    and   abscc_inv_post     = no
                    and   abscc_cont_price   <> 0)))
   then do:
      op_lupdate = yes .
      leave .
   end. /* IF CAN-FIND (FIRST absl_det ... */
end. /* FOR EACH work_abs_mstr */

END PROCEDURE.

PROCEDURE p-update-for-invoicing:

define input parameter l_auto_inv like auto_inv no-undo.

if not l_auto_inv
then do:

   for each tt_somstr
   no-lock:

      find first so_mstr
         where so_domain = global_domain
         and   so_nbr    = tt_sonbr
      exclusive-lock no-wait no-error.

      if available so_mstr
      then
         so_invoiced = tt_sotoinv.

     /* DOWNGRADING so_mstr LOCK TO NO-LOCK */
     /* TO AVOID ORACLE LOCKING ISSUES */

      for first so_mstr
         where so_domain = global_domain
         and   so_nbr    = tt_sonbr
      no-lock:
      end. /* FOR FIRST so_mstr */

   end. /* FOR EACH tt_somstr */
end. /* IF NOT l_auto_inv */

END PROCEDURE. /* p-update-for-invoicing */
