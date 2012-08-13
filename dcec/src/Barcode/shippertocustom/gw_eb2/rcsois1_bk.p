/* GUI CONVERTED from rcsois1.p (converter v1.78) Fri Oct 29 14:33:59 2004 */
/* rcsois1.p - Customer Schedules Confirm Shipper                             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.129.1.30 $                                             */
/* REVISION: 7.3      LAST MODIFIED: 10/12/92   BY: WUG *G462*                */
/* REVISION: 7.3      LAST MODIFIED: 04/22/93   BY: WUG *GA12*                */
/* REVISION: 7.3      LAST MODIFIED: 06/01/93   BY: WUG *GB46*                */
/* REVISION: 7.3      LAST MODIFIED: 07/26/93   BY: WUG *GD70*                */
/* REVISION: 7.3      LAST MODIFIED: 08/13/93   BY: WUG *GE19*                */
/* REVISION: 7.3      LAST MODIFIED: 08/27/93   BY: WUG *GE58*                */
/* REVISION: 7.3      LAST MODIFIED: 09/03/93   BY: WUG *GE79*                */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*                */
/* REVISION: 7.4      LAST MODIFIED: 09/21/93   BY: WUG *H130*                */
/* REVISION: 7.4      LAST MODIFIED: 09/28/93   BY: WUG *H140*                */
/* REVISION: 7.4      LAST MODIFIED: 09/30/93   BY: WUG *H146*                */
/* REVISION: 7.4      LAST MODIFIED: 10/13/93   BY: WUG *H172*                */
/* REVISION: 7.4      LAST MODIFIED: 10/15/93   BY: WUG *H180*                */
/* REVISION: 7.4      LAST MODIFIED: 12/01/93   BY: WUG *H257*                */
/* REVISION: 7.4      LAST MODIFIED: 12/21/93   BY: WUG *GI20*                */
/* REVISION: 7.4      LAST MODIFIED: 12/22/93   BY: WUG *H268*                */
/* REVISION: 7.4      LAST MODIFIED: 01/04/93   BY: tjs *H166*                */
/* REVISION: 7.4      LAST MODIFIED: 03/24/94   BY: pcd *H304*                */
/* REVISION: 7.4      LAST MODIFIED: 03/24/94   BY: dpm *H074*                */
/* REVISION: 7.4      LAST MODIFIED: 04/14/94   BY: dpm *H347*                */
/* REVISION: 7.4      LAST MODIFIED: 07/20/94   BY: bcm *H447*                */
/* REVISION: 7.4      LAST MODIFIED: 08/09/94   BY: dpm *GL13*                */
/* REVISION: 7.4      LAST MODIFIED: 09/07/94   BY: bcm *H507*                */
/* REVISION: 7.4      LAST MODIFIED: 09/08/94   BY: bcm *H509*                */
/* REVISION: 7.4      LAST MODIFIED: 11/02/94   BY: mmp *H579*                */
/* REVISION: 7.4      LAST MODIFIED: 11/19/94   BY: GWM *H604*                */
/* REVISION: 7.4      LAST MODIFIED: 11/30/94   BY: afs *H611*                */
/* REVISION: 7.4      LAST MODIFIED: 12/07/94   BY: bcm *H617*                */
/* REVISION: 7.4      LAST MODIFIED: 12/08/94   BY: jxz *GO77*                */
/* REVISION: 7.4      LAST MODIFIED: 12/09/94   BY: jxz *GO83*                */
/* REVISION: 7.4      LAST MODIFIED: 12/15/94   BY: str *G09F*                */
/* REVISION: 7.4      LAST MODIFIED: 12/15/94   BY: rxm *GN16*                */
/* REVISION: 7.4      LAST MODIFIED: 12/19/94   BY: bcm *H09G*                */
/* REVISION: 7.4      LAST MODIFIED: 01/06/94   BY: aep *G0BK*                */
/* REVISION: 8.5      LAST MODIFIED: 12/13/94   BY: mwd *J034*                */
/* REVISION: 7.4      LAST MODIFIED: 01/20/95   BY: rxm *G0CX*                */
/* REVISION: 7.4      LAST MODIFIED: 03/13/95   BY: jxz *F0M3*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 7.4      LAST MODIFIED: 04/06/95   BY: ame *H0CF*                */
/* REVISION: 7.4      LAST MODIFIED: 05/09/95   BY: dxk *G0MC*                */
/* REVISION: 7.4      LAST MODIFIED: 06/14/95   BY: bcm *F0SR*                */
/* REVISION: 8.5      LAST MODIFIED: 06/16/95   BY: rmh *J04R*                */
/* REVISION: 7.4      LAST MODIFIED: 07/20/95   BY: jym *H0F7*                */
/* REVISION: 7.4      LAST MODIFIED: 08/15/95   BY: vrn *G0V3*                */
/* REVISION: 7.4      LAST MODIFIED: 08/28/95   BY: vrn *G0VP*                */
/* REVISION: 7.4      LAST MODIFIED: 09/25/95   BY: vrn *H0G2*                */
/* REVISION: 7.4      LAST MODIFIED: 10/05/95   BY: vrn *G0X3*                */
/* REVISION: 8.5      LAST MODIFIED: 08/01/95   BY: taf *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 07/13/95   BY: gwm *J0JL*                */
/* REVISION: 8.5      LAST MODIFIED: 04/18/96   BY: mzh *J0JL*                */
/* REVISION: 8.5      LAST MODIFIED: 04/24/96   BY: GWM *J0K9*                */
/* REVISION: 8.5      LAST MODIFIED: 05/14/96   BY: vrn *G1LV*                */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: ejh *K001*                */
/* REVISION: 8.5      LAST MODIFIED: 06/19/96   BY: rvw *G1XY*                */
/* REVISION: 8.5      LAST MODIFIED: 07/18/96   BY: taf *J0ZS*                */
/* REVISION: 8.5      LAST MODIFIED: 07/30/96   BY: gwm *J12V*                */
/* REVISION: 8.6      LAST MODIFIED: 08/09/96   BY: *K02H* Vinay Nayak-Sujir  */
/* REVISION: 8.5      LAST MODIFIED: 08/16/96   BY: *H0MD* Suresh Nayak       */
/* REVISION: 8.5      LAST MODIFIED: 08/26/96   BY: *G2CR* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 09/20/96   BY: TSI *K005*                */
/* REVISION: 8.6      LAST MODIFIED: 10/04/96   BY: *K02H* forrest mori       */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Kurt De Wit        */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K01T* Kurt De Wit        */
/* REVISION: 8.6      LAST MODIFIED: 12/06/96   BY: *K030* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 12/10/96   BY: *K039* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 12/30/96   BY: *K03V* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 01/26/96   BY: *K03J* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 02/04/97   BY: *K05V* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 04/02/97   BY: *K09H* Vinay Nayak-Sujir  */
/* REVISION: 8.5      LAST MODIFIED: 04/07/97   BY: *J1M3* Jean Miller        */
/* REVISION: 8.6      LAST MODIFIED: 04/15/97   BY: *H0W3* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 05/13/97   BY: *J1MP* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 07/10/97   BY: *K0G6* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 07/12/97   BY: *K0DH* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 08/06/97   BY: *J1YG* Seema Varma        */
/* REVISION: 8.6      LAST MODIFIED: 09/20/97   BY: *H1F5* Niranjan Ranka     */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   BY: *K0JV* Surendra Kumar     */
/* REVISION: 8.6      LAST MODIFIED: 11/03/97   BY: *J22N* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 11/18/97   BY: *K18W* Taek-Soo Chang     */
/* REVISION: 8.6      LAST MODIFIED: 11/06/97   BY: *H1GD* Seema Varma        */
/* REVISION: 8.6      LAST MODIFIED: 11/19/97   BY: *H1GL* Nirav Parikh       */
/* REVISION: 8.6      LAST MODIFIED: 11/28/97   BY: *H1GZ* Seema Varma        */
/* REVISION: 8.6      LAST MODIFIED: 12/13/97   BY: *J20Q* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 12/30/97   BY: *J281* Manish Kulkarni    */
/* REVISION: 8.6      LAST MODIFIED: 12/02/97   BY: *K15N* Jim Williams       */
/* REVISION: 8.6      LAST MODIFIED: 01/22/98   BY: *H1J7* Nirav Parikh       */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: *J2DD* Kawal Batra        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 05/29/98   BY: *K1JN* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 06/18/98   BY: *J2KY* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 06/26/98   BY: *J2MG* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 06/29/98   BY: *J2PB* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 07/07/98   BY: *L03Q* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 07/15/98   BY: *L024* Bill Reckard       */
/* REVISION: 8.6E     LAST MODIFIED: 08/27/98   BY: *K1WQ* Irine D'mello      */
/* REVISION: 8.6E     LAST MODIFIED: 09/02/98   BY: *H1LZ* Manish Kulkarni    */
/* REVISION: 8.6E     LAST MODIFIED: 10/23/98   BY: *L0CD* Steve Goeke        */
/* REVISION: 9.0      LAST MODIFIED: 12/16/98   BY: *J371* Niranjan Ranka     */
/* REVISION: 9.0      LAST MODIFIED: 12/17/98   BY: *K1YG* Seema Varma        */
/* REVISION: 9.0      LAST MODIFIED: 01/19/99   BY: *M05Q* Seema Varma        */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/23/99   BY: *H1NP* Poonam Bahl        */
/* REVISION: 9.0      LAST MODIFIED: 03/30/99   BY: *K1ZH* Santosh Rao        */
/* REVISION: 9.0      LAST MODIFIED: 04/27/99   BY: *H1NW* Santosh Rao        */
/* REVISION: 9.0      LAST MODIFIED: 04/28/99   BY: *J3BM* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 05/26/99   BY: *J3G7* Poonam Bahl        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Vijaya Pakala      */
/* REVISION: 9.1      LAST MODIFIED: 06/22/99   BY: *K20Q* Poonam Bahl        */
/* REVISION: 9.1      LAST MODIFIED: 06/22/99   BY: *K21B* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 07/09/99   BY: *J3HZ* Poonam Bahl        */
/* REVISION: 9.1      LAST MODIFIED: 08/06/99   BY: *N01G* Kedar Deherkar     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/99   BY: *K224* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 08/12/99   BY: *J3KJ* Bengt Johansson    */
/* REVISION: 9.1      LAST MODIFIED: 10/27/99   BY: *K240* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 01/11/00   BY: *J3N6* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 02/18/00   BY: *N06R* Brian Henderson    */
/* REVISION: 9.1      LAST MODIFIED: 04/21/00   BY: *N09J* Denis Tatarik      */
/* REVISION: 9.1      LAST MODIFIED: 05/17/00   BY: *L0XV* Kedar Deherkar     */
/* REVISION: 9.1      LAST MODIFIED: 06/06/00   BY: *N0CZ* John Pison         */
/* REVISION: 9.1      LAST MODIFIED: 07/14/00   BY: *N0F2* John Pison         */
/* REVISION: 9.1      LAST MODIFIED: 07/20/00   BY: *L0QV* Manish Kulkarni    */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 08/25/00   BY: *L12D* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 12/14/00   BY: *M0Y0* Ashwini Ghaisas    */
/* REVISION: 9.1      LAST MODIFIED: 12/20/00   BY: *L155* Abhijeet Thakur    */
/* REVISION: 9.1      LAST MODIFIED: 09/23/00   BY: *N0WD* BalbeerS Rajput    */
/* Revision: 1.93      BY: Katie Hilbert           DATE: 04/01/01 ECO: *P002* */
/* Revision: 1.96      BY: Rajaneesh Sarangi       DATE: 06/29/01 ECO: *M1CP* */
/* Revision: 1.97      BY: Dan Herman              DATE: 07/09/01 ECO: *P007* */
/* Revision: 1.98      BY: Jean Miller             DATE: 08/07/01 ECO: *M11Z* */
/* Revision: 1.100     BY: Dan Herman              DATE: 08/15/01 ECO: *P01L* */
/* Revision: 1.102     BY: Ashwini Ghaisas         DATE: 12/15/01 ECO: *M1LD* */
/* Revision: 1.103     BY: Mark Christian          DATE: 02/07/02 ECO: *N18X* */
/* Revision: 1.106     BY: Patrick Rowan           DATE: 04/24/01 ECO: *P00G* */
/* Revision: 1.107     BY: Jean Miller             DATE: 04/03/02 ECO: *P053* */
/* Revision: 1.108     BY: Ed van de Gevel         DATE: 04/17/02 ECO: *N1GR* */
/* Revision: 1.109     BY: Vandna Rohira           DATE: 04/29/02 ECO: *M1Y2* */
/* Revision: 1.110     BY: Mercy Chittilapilly     DATE: 05/29/02 ECO: *N1K8* */
/* Revision: 1.111     BY: Sandeep Parab           DATE: 06/04/02 ECO: *M1XH* */
/* Revision: 1.114     BY: Robin McCarthy          DATE: 07/02/02 ECO: *P0B2* */
/* Revision: 1.115     BY: R.Satya Narayan         DATE: 06/25/02 ECO: *P086* */
/* Revision: 1.116     BY: Samir Bavkar            DATE: 07/07/02 ECO: *P0B0* */
/* Revision: 1.117     BY: Robin McCarthy          DATE: 07/15/02 ECO: *P0BJ* */
/* Revision: 1.119     BY: Samir Bavkar            DATE: 08/15/02 ECO: *P09K* */
/* Revision: 1.120     BY: Samir Bavkar            DATE: 08/18/02 ECO: *P0FS* */
/* Revision: 1.121     BY: Manjusha Inglay         DATE: 08/27/02 ECO: *N1S3* */
/* Revision: 1.122     BY: Ed van de Gevel         DATE: 09/05/02 ECO: *P0HQ* */
/* Revision: 1.123     BY: Rajiv Ramaiah           DATE: 01/13/03 ECO: *N23Z* */
/* Revision: 1.124     BY: Amit Chaturvedi         DATE: 01/20/03 ECO: *N20Y* */
/* Revision: 1.128     BY: Robin McCarthy          DATE: 02/28/03 ECO: *P0M9* */
/* Revision: 1.129     BY: Narathip W.             DATE: 05/08/03 ECO: *P0RL* */
/* Revision: 1.129.1.2 BY: Katie Hilbert           DATE: 06/03/03 ECO: *P0TV* */
/* Revision: 1.129.1.3 BY: Geeta Kotian            DATE: 06/11/03 ECO: *P0V3* */
/* Revision: 1.129.1.4 BY: Deepak Rao              DATE: 08/14/03 ECO: *N2K3* */
/* Revision: 1.129.1.5 BY: Deepak Rao              DATE: 09/04/03 ECO: *N2KM* */
/* Revision: 1.129.1.7 BY: Vinay Soman             DATE: 10/15/03 ECO: *N2M1* */
/* Revision: 1.129.1.8 BY: Vinay Soman             DATE: 10/21/03 ECO: *N2M8* */
/* Revision: 1.129.1.9 BY: Veena Lad               DATE: 12/23/03 ECO: *P1H3* */
/* Revision: 1.129.1.10   BY: Sushant Pradhan      DATE: 03/10/04 ECO: *P1SR* */
/* Revision: 1.129.1.11   BY: Manish Dani          DATE: 04/23/04 ECO: *P1YP* */
/* Revision: 1.129.1.13   BY: Vandna Rohira        DATE: 05/31/04 ECO: *P1Z0* */
/* Revision: 1.129.1.16   BY: Mercy Chittilapilly  DATE: 06/18/04 ECO: *P26B* */
/* Revision: 1.129.1.20   BY: Vandna Rohira        DATE: 06/22/04 ECO: *P277* */
/* Revision: 1.129.1.24   BY: Abhishek Jha         DATE: 07/23/04 ECO: *P2B9* */
/* Revision: 1.129.1.26   BY: Shivganesh Hegde     DATE: 08/03/04 ECO: *P26L* */
/* $Revision: 1.129.1.30 $ BY: Shivganesh Hegde  DATE: 09/22/04 ECO: *P2LM* */


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* CHANGES MADE TO THIS PROGRAM NEED TO BE MADE TO RCSOIS2.P, AS WELL */

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{cxcustom.i "RCSOIS1.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{gldydef.i new}
{gldynrm.i new}

{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */

/* NEW SHARED VARIABLES, BUFFERS AND FRAMES */
define new shared variable rndmthd        like rnd_rnd_mthd.
define new shared variable abs_carr_ref     as character.
define new shared variable abs_fob        like so_fob.
define new shared variable abs_recid        as recid.
define new shared variable abs_shipvia    like so_shipvia.
define new shared variable accum_wip      like tr_gl_amt.
define new shared variable already_posted like glt_amt.
define new shared variable auto_post      like mfc_logical label "Post Invoice".
define new shared variable base_amt       like ar_amt.
define new shared variable batch          like ar_batch.
define new shared variable batch_tot      like glt_amt.
define new shared variable bill           like so_bill.
define new shared variable bill1          like so_bill.
define new shared variable change_db      like mfc_logical.
define new shared variable consolidate    like mfc_logical
   label "Consolidate Invoices".
define new shared variable cr_acct        like trgl_cr_acct.
define new shared variable cr_sub         like trgl_cr_sub.
define new shared variable cr_amt           as decimal
   format "->>>,>>>,>>>.99" label "Credit Amount".
define new shared variable cr_cc          like trgl_cr_cc.
define new shared variable cr_proj        like trgl_cr_proj.
define new shared variable curr_amt       like glt_amt.
define new shared variable cust           like so_cust.
define new shared variable cust1          like so_cust.
define new shared variable desc1          like pt_desc1 format "x(49)".
define new shared variable dr_acct        like trgl_dr_acct.
define new shared variable dr_sub         like trgl_dr_sub.
define new shared variable dr_amt           as decimal
   format "->>>,>>>,>>>.99" label "Debit Amount".
define new shared variable dr_cc          like trgl_dr_cc.
define new shared variable eff_date       like glt_effdate label "Effective".
define new shared variable exch_rate      like exr_rate.
define new shared variable exch_rate2     like exr_rate2.
define new shared variable exch_ratetype  like exr_ratetype.
define new shared variable exch_exru_seq  like exru_seq.
define new shared variable ext_cost       like sod_price.
define new shared variable ext_disc         as decimal decimals 2.
define new shared variable gr_margin      like sod_price
   label "Unit Margin" format "->>>>,>>9.99".
define new shared variable ext_gr_margin  like gr_margin label "Ext Margin".
define new shared variable base_margin    like ext_gr_margin.
define new shared variable ext_list       like sod_list_pr decimals 2.
define new shared variable ext_price        as decimal
   label "Ext Price" decimals 2 format "->>>>,>>>,>>9.99".
define new shared variable base_price     like ext_price.
define new shared variable freight_ok     like mfc_logical.
define new shared variable gl_amt         like sod_fr_chg.
define new shared variable gl_sum         like mfc_logical
   format "Consolidated/Detail" initial yes.
define new shared variable inv            like ar_nbr label "Invoice".
define new shared variable inv1           like ar_nbr label {t001.i}.
define new shared variable inv_only       like mfc_logical initial yes.
define new shared variable loc like pt_loc.
define new shared variable lotserial_total like tr_qty_chg.
define new shared variable name           like ad_name.
define new shared variable nbr like tr_nbr.
define new shared variable net_price      like sod_price.
define new shared variable net_list       like sod_list_pr.
define new shared variable old_ft_type      as character.
define new shared variable ord-db-cmtype  like cm_type no-undo.
define new shared variable order_ct         as integer.
define new shared variable order_nbrs       as character extent 30.
define new shared variable order_nbr_list   as character no-undo.
define new shared variable part             as character format "x(18)".
define new shared variable post           like mfc_logical.
define new shared variable post_entity    like ar_entity.
define new shared variable print_lotserials like mfc_logical
   label "Print Lot/Serial Numbers Shipped".
define new shared variable project        like wo_project.
define new shared variable que-doc          as logical.
define new shared variable qty              as decimal.
define new shared variable qty_all        like sod_qty_all.
define new shared variable qty_pick       like sod_qty_pick.
define new shared variable qty_bo         like sod_bo_chg.
define new shared variable qty_chg        like sod_qty_chg.
define new shared variable qty_cum_ship   like sod_qty_ship.
define new shared variable qty_inv        like sod_qty_inv.
define new shared variable qty_iss_rcv    like tr_qty_loc.
define new shared variable qty_left       like tr_qty_chg.
define new shared variable qty_open       like sod_qty_ord.
define new shared variable qty_ord        like sod_qty_ord.
define new shared variable qty_req        like in_qty_req.
define new shared variable qty_ship       like sod_qty_ship.
define new shared variable ref            like glt_ref.
define new shared variable rejected       like mfc_logical no-undo.
define new shared variable rmks           like tr_rmks.
define new shared variable sct_recid        as recid.
define new shared variable sct_recno        as recid.
define new shared variable ship_db        like global_db.
define new shared variable ship_dt        like so_ship_date.
define new shared variable ship_line      like sod_line.
define new shared variable ship_site        as character.
define new shared variable ship_so        like so_nbr.
define new shared variable should_be_posted like glt_amt.
define new shared variable so_db          like global_db.
define new shared variable so_job         like tr_so_job.
define new shared variable so_hist        like soc_so_hist.
define new shared variable so_mstr_recid    as recid.
define new shared variable so_recno         as recid.
define new shared variable sod_entity     like en_entity.
define new shared variable sod_recno        as recid.
define new shared variable std_cost       like sod_std_cost.
define new shared variable tax_recno        as recid.
define new shared variable tot_curr_amt   like glt_amt.
define new shared variable tot_ext_cost   like sod_price.
define new shared variable tot_line_disc    as decimal decimals 2.
define new shared variable tr_recno         as recid.
define new shared variable transtype        as character format "x(7)".
define new shared variable trgl_recno       as recid.
define new shared variable trlot          like tr_lot.
define new shared variable trqty          like tr_qty_chg.
define new shared variable unit_cost      like tr_price label "Unit Cost".
define new shared variable undo_all       like mfc_logical no-undo.
define new shared variable use_shipper    like mfc_logical
   label "Use Shipper Nbr for Inv Nbr".
define new shared variable wip_entity     like si_entity.
define new shared workfile work_sr_wkfl   like sr_wkfl.
define new shared variable yn             like mfc_logical.
define new shared variable critical-part  like wod_part    no-undo.
define new shared variable prog_name        as character
   initial "rcsois.p" no-undo.
define new shared variable auto_inv       like mfc_logical
   label "Print Invoice".
define new shared variable l_undo         like mfc_logical no-undo.

/* SHARED VARIABLES, BUFFERS AND FRAMES */
define shared variable confirm_mode like mfc_logical       no-undo.
define shared variable global_recid as recid.
DEF VAR misinv AS LOGICAL.
/* LOCAL VARIABLES, BUFFERS AND FRAMES */
define variable abs_trans_mode    as   character     no-undo.
define variable abs_veh_ref       as   character     no-undo.
define variable disp_abs_id       like abs_mstr.abs_id no-undo.
define variable first_so_bill     like so_bill       no-undo.
define variable first_so_cust     like so_cust       no-undo.
define variable first_so_curr     like so_curr       no-undo.
define variable first_so_cr_terms like so_cr_terms   no-undo.
define variable first_so_slspsn   like so_slspsn     no-undo.
define variable first_so_trl1_cd  like so_trl1_cd    no-undo.
define variable first_so_trl2_cd  like so_trl2_cd    no-undo.
define variable first_so_trl3_cd  like so_trl3_cd    no-undo.
define variable first_so_entity   like si_entity     no-undo.
define variable msg_text          as   character     no-undo.
define variable shipqty           as   decimal       no-undo.
define variable txcalcref         as   character     no-undo.
define variable conf_type         as   logical
   format "Pre-Shipper/Shipper"        initial true  no-undo.
define variable l_first_so_nbr    like so_nbr        no-undo.
define variable l_consolidate_ok  as   logical       no-undo.
define variable oldcurr           like so_curr       no-undo.
define variable id_length         as   integer       no-undo.
define variable shipgrp           like sg_grp        no-undo.
define variable shipnbr           like abs_mstr.abs_id no-undo.
define variable nrseq             like shc_ship_nr_id  no-undo.
define variable errorst           as   logical       no-undo.
define variable errornum          as   integer       no-undo.
define variable is_valid          as   logical       no-undo.
define variable is_internal       as   logical       no-undo.
{&RCSOIS1-P-TAG9}

define buffer abs_temp for abs_mstr.

define variable l_disc_pct1       as   decimal       no-undo.
define variable l_net_price       as   decimal       no-undo.
define variable l_list_price      as   decimal       no-undo.
define variable l_rec_no          as   recid         no-undo.
define variable change-queued     as   logical       no-undo.
define variable l_flag            like mfc_logical   no-undo.
define variable undo_stat         like mfc_logical   no-undo.
define variable l_tr_type         like tx2d_tr_type  initial "13" no-undo.
define variable l_nbr             like tx2d_nbr      initial ""   no-undo.
define variable l_line            like tx2d_line     initial 0    no-undo.
define variable l_calc_freight    like mfc_logical   initial yes
   label "Calculate Freight"                         no-undo.
define variable errorNbr          as   integer       no-undo.
define variable vSOToHold         like so_nbr        no-undo.
define variable creditCardOrder   as   logical       no-undo.
define variable l_undoflg         like mfc_logical   no-undo.
define variable l_flag1           like mfc_logical   no-undo.
define variable use-log-acctg     as   logical       no-undo.
define variable first_so_site     like so_site       no-undo.
define variable first_so_ex_rate  like so_ex_rate    no-undo.
define variable first_so_ex_rate2 like so_ex_rate2   no-undo.
define variable first_so_exru_seq like so_exru_seq   no-undo.

define variable tot_freight_gl_amt    like sod_fr_chg. /* NOT NO-UNDO */
DEFINE NEW SHARED VAR xxinv_nbr LIKE so_inv_nbr.
define temp-table tt_sod_det no-undo
   field tt_sod_nbr  like sod_nbr
   field tt_sod_line like sod_line
   field tt_pr_found as logical
   index i_sodnbr tt_sod_nbr.

define new shared temp-table work_ldd no-undo
   field work_ldd_id like abs_id
   index work_ldd_id work_ldd_id.

define variable l_consigned_line_item like mfc_logical      no-undo.

define temp-table tt_consign_rec no-undo
   field tt_consign_order   like so_nbr
   field tt_consign_line    like sod_line
   field tt_consign_qty_chg like sod_qty_chg
   index tt_consign_rec_idx tt_consign_order tt_consign_line.

define variable msgnbr         as integer no-undo.
define variable dummy-length   as character format "999:99" no-undo.
define variable shp_time       as character format "xx:xx"  no-undo.
define variable arr_date       like abs_arr_date            no-undo.
define variable arr_time       as character format "xx:xx"  no-undo.
define variable l_so_to_inv    like so_to_inv               no-undo.
DEF VAR contract AS CHAR.
define variable l_wo_reject    like mfc_logical             no-undo.
define variable return_status  as   integer                 no-undo.
DEF VAR xxsoid AS RECID.
define temp-table tt_so_mstr no-undo
   field tt_so_nbr       like so_nbr
   field tt_so_to_inv    like so_to_inv
   field tt_so_invoiced  like so_invoiced
   field tt_so_ship_date like so_ship_date
   field tt_so_tax_date  like so_tax_date
   field tt_so_bol       like so_bol
   field tt_so__qadc01   like so__qadc01
   index i_sonbr tt_so_nbr.

define temp-table tt_somstr no-undo
   field tt_sonbr   like so_nbr
   field tt_sotoinv like mfc_logical initial no
   index sonbr is primary unique
   tt_sonbr.

{&RCSOIS1-P-TAG14}

/* EURO TOOL KIT DEFINITIONS */
{etvar.i &new="new"}
{etdcrvar.i "new"}
{etrpvar.i &new="new"}
{etsotrla.i "new"}

{fsdeclr.i new}

{gpglefdf.i}
{txcalvar.i}
{rcwabsdf.i new}
{gpfilev.i}   /* VARIABLE DEFINITIONS FOR gpfile.i */

/* CONSIGNMENT VARIABLES */
{socnvars.i}
{pxsevcon.i}

/* FREIGHT ACCRUAL TEMP TABLE DEFINITION */
{lafrttmp.i "new"}

{&RCSOIS1-P-TAG15}

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
abs_mstr.abs_shipfrom colon 35 label "Ship-From"
   si_desc               at 47    no-label
   conf_type             colon 35 label "Pre-Shipper/Shipper"
   abs_mstr.abs_id       colon 35 label "Number"
   skip(1)
   abs_mstr.abs_shipto   colon 35 label "Ship-To/Dock"
   ad_name               at 47    no-label
   ad_line1              at 47    no-label
   ship_dt               colon 35
   eff_date              colon 35
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


{&RCSOIS1-P-TAG16}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
abs_veh_ref colon 35 label "Vehicle ID"    format "x(20)"
   shp_time    colon 35 label "Shipping Time"
   arr_date    colon 35 label "Arrive Date"
   arr_time    colon 35 label "Arrival Time"
 SKIP(.4)  /*GUI*/
with frame ab side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-ab-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame ab = F-ab-title.
 RECT-FRAME-LABEL:HIDDEN in frame ab = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame ab =
  FRAME ab:HEIGHT-PIXELS - RECT-FRAME:Y in frame ab - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME ab = FRAME ab:WIDTH-CHARS - .5.  /*GUI*/


setFrameLabels(frame ab:handle).
/* "Print Invoice " WILL NOW APPEAR IN THE FRAME BELOW AND WILL NO  */
/* LONGER APPEAR AFTER THE PROMPT "Is all the information correct"  */
FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
auto_inv              colon 35 xxinv_nbr COLON 55
   {&RCSOIS1-P-TAG10}
   auto_post             colon 35
   use_shipper           colon 35
   consolidate           colon 35
   l_calc_freight        colon 35
 SKIP(.4)  /*GUI*/
with frame b side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
space(1)
   shipnbr label "Shipper Number"
 SKIP(.4)  /*GUI*/
with frame convfrm centered side-labels attr-space

overlay width 45 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-convfrm-title AS CHARACTER.
 F-convfrm-title = (getFrameTitle("CONVERT_PRE-SHIPPER_TO_SHIPPER",42)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame convfrm = F-convfrm-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame convfrm =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame convfrm + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame convfrm =
  FRAME convfrm:HEIGHT-PIXELS - RECT-FRAME:Y in frame convfrm - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME convfrm = FRAME convfrm:WIDTH-CHARS - .5. /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame convfrm:handle).

run getControlFiles
   (buffer gl_ctrl,
    buffer shc_ctrl,
    input enable_customer_consignment,
    input adg,
    input cust_consign_ctrl_table,
    output use-log-acctg,
    output using_cust_consignment,
    output auto_post,
    output use_shipper,
    output consolidate).

{cclc.i} /*CHECK FOR ENABLEMENT OF CONTAINER AND LINE CHARGES*/

for first abs_mstr
   fields (abs_canceled abs_eff_date abs_format abs_id
           abs_inv_mov abs_nr_id abs_preship_id abs_preship_nr_id
           abs_shipfrom abs_shipto abs_shp_date abs_status
           abs_type abs__qad01)
   where recid(abs_mstr) = global_recid
   no-lock:
end.

if available abs_mstr
   and abs_type = "S"
   and (abs_id begins "P"
    or  abs_id begins "S")
then do:

   for first si_mstr
      fields (si_db si_desc si_entity si_site)
      where si_site = abs_shipfrom
      no-lock:
   end.

   conf_type = abs_id begins "p".

   display
      abs_shipfrom
      si_desc
      conf_type
      substring(abs_id,2,50) @ abs_id
   with frame a.

end.

assign
   ship_dt  = today
   eff_date = if confirm_mode
                 or not available abs_mstr
              then
                 today
              else
                 abs_eff_date
   oldcurr  = "".

display
   ship_dt
   eff_date
   conf_type
with frame a.

mainloop:
repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


   /* INITIALIZE work_ldd */
   run p_InitializeTempTableWorkLdd.

   /* Inserting a block so that orders can be placed on hold      */
   /* if the credit card validations fail even if the user enters */
   /* F4 or answers no to "Is all information correct?".          */
   CK-CC-HOLD:
   do on error undo CK-CC-HOLD, leave CK-CC-HOLD:
/*GUI*/ if global-beam-me-up then undo, leave.


      assign
         vSOToHold = ""
         oldcurr   = "".

      run del-qad-wkfl.

      do with frame a:

         prompt-for
            abs_shipfrom
            conf_type
            abs_id
         editing:

            global_site = input abs_shipfrom.

            if frame-field = "abs_shipfrom"
            then do:

               {mfnp05.i abs_mstr abs_id
                  "abs_id begins 's'
                  or abs_id begins 'p'"
                  abs_shipfrom
                  "input abs_shipfrom"}

               if recno <> ?
               then do:

                  for first si_mstr
                     fields (si_db si_desc si_entity si_site)
                     where si_site = abs_shipfrom
                     no-lock:
                  end.

                  assign
                     global_site = abs_shipfrom
                     global_lot  = abs_id
                     conf_type   = abs_id begins "p"
                     disp_abs_id = substring(abs_id,2,50).

                  display
                     abs_shipfrom
                     si_desc  when (available si_mstr)
                     ""       when (not available si_mstr) @ si_desc
                     conf_type
                     disp_abs_id @ abs_id.

               end. /* if recno <> ? */

            end. /* if frame-field "abs_shipfrom" */

            else if frame-field = "abs_id"
            then do:

               /* HANDLE SHIPPERS */
               if not input conf_type
               then do:

                  {mfnp05.i abs_mstr abs_id
                     "abs_shipfrom = input abs_shipfrom
                      and abs_id begins ""s""
                      and abs_type    = ""s"""
                      abs_id " ""s"" + input abs_id"}
               end. /* if not input conf_type */

               else do:
                  {mfnp05.i abs_mstr abs_id
                     "abs_shipfrom = input abs_shipfrom
                      and abs_id begins
                      ""p"" " abs_id " ""p"" + input abs_id"}

               end. /* else */

               if recno <> ?
               then do:

                  for first si_mstr
                     fields (si_db si_desc si_entity si_site)
                     where si_site = abs_shipfrom
                     no-lock:
                  end.

                  assign
                     global_site = abs_shipfrom
                     global_lot  = abs_id
                     conf_type   = abs_id begins "p"
                     disp_abs_id = substring(abs_id,2,50).

                  display
                     abs_shipfrom
                     si_desc  when (available si_mstr)
                     ""       when (not available si_mstr) @ si_desc
                     conf_type
                     disp_abs_id @ abs_id.

               end. /* if recno <> ? */

                  
            end. /* if frame-field = "abs_id" */

            else do:
               status input.
               readkey.
               apply lastkey.
            end.

         end.
          
/*GUI*/ if global-beam-me-up then undo, leave.
 /* prompt-for */

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do with frame a */
 
 /* FOR EACH abs_mstr WHERE substring(ABS_mstr.ABS_par_id,2,50) = INPUT ABS_id NO-LOCK:
                FIND sod_det WHERE sod_det.sod_nbr = ABS_mstr.ABS_ord AND string(sod_det.sod_line) = ABS_mstr.ABS_line NO-LOCK NO-ERROR.
                  IF AVAILABLE sod_det AND sod_det.sod_qty_inv <> 0 THEN DO:
                    
                       MESSAGE "Pending invoice is existed,please post it first!" VIEW-AS ALERT-BOX BUTTON OK. 

                       UNDO,RETRY.
                       NEXT-PROMPT ABS_id WITH FRAME a.
                       
                       END.
                    
                   END.*/
      so_db = global_db.

      for first si_mstr
         fields (si_db si_desc si_entity si_site)
         where si_site = input abs_shipfrom
         no-lock:
      end.

      if not available si_mstr
      then do:

         /* Site does not exist */
         run DisplayMessage (input 708,
                             input 3,
                             input '').
         next-prompt abs_shipfrom with frame a.
         undo, retry.
      end.

      display
         si_desc
      with frame a.

      /* Making sure db is connected */
      if si_db <> global_db
         and not connected(si_db)
      then do:

         /* Database: # not available */
         run DisplayMessage (input 2510,
                             input 3,
                             input si_db).
         next-prompt abs_shipfrom with frame a.
         undo, retry.
      end.

      assign
         ship_db   = si_db
         change_db = ship_db <> global_db.
 FIND FIRST abs_mstr WHERE substr(abs_mstr.ABS_id,2,50) = INPUT ABS_id AND ABS_mstr.ABS__qad10 <> '' NO-LOCK NO-ERROR.
IF NOT AVAILABLE ABS_mstr THEN DO:
      MESSAGE "The shipper dosen't contain contract!" VIEW-AS ALERT-BOX BUTTON OK. 
        UNDO,RETRY.
                       NEXT-PROMPT ABS_id WITH FRAME a.
    END.
 FIND FIRST ad_mstr WHERE ad_addr = ABS_mstr.ABS_shipto  NO-LOCK NO-ERROR.
FIND last so_mstr WHERE  (IF ad_ref =  '' THEN so_cust = ad_addr  ELSE so_cust = ad_ref )  AND so_inv_nbr <> '' AND so_bol <> '' NO-LOCK NO-ERROR.
     IF AVAILABLE so_mstr THEN DO:
       xxinv_nbr = so_inv_nbr.
      
         FIND FIRST abs_mstr WHERE substr(abs_mstr.ABS_id,2,50) = so_mstr.so_bol NO-LOCK NO-ERROR.
         IF AVAILABLE abs_mstr THEN  contract = abs_mstr.ABS__qad10.
     FIND FIRST abs_mstr WHERE substr(abs_mstr.ABS_id,2,50) = INPUT ABS_id NO-LOCK NO-ERROR.
   
         IF abs_mstr.ABS__qad10 <> contract THEN DO:
         
            MESSAGE "The contract for pending invocie is not the same as current contract!" VIEW-AS ALERT-BOX BUTTON OK. 
        UNDO,RETRY.
                       NEXT-PROMPT ABS_id WITH FRAME a.
             
             END.
      
         END.
      
         for first abs_mstr
         fields (abs_canceled abs_eff_date abs_format abs_id
                 abs_inv_mov abs_nr_id abs_preship_id abs_preship_nr_id
                 abs_shipfrom abs_shipto abs_shp_date abs_status
                 abs_type abs__qad01)
         where abs_shipfrom = input abs_shipfrom
           and abs_id       = (if input conf_type
                               then
                                  "P"
                               else
                                  "S")
                             + input abs_id
           and abs_type     = "S"
         no-lock:
      end.

      if not available abs_mstr
      then do:

         /* Picklist/Shipper does not exist */
         run DisplayMessage (input 8145,
                             input 3,
                             input '').
         next-prompt abs_id with frame a.
         undo, retry.
      end.

      {gprun.i ""gpsiver.p""
         "(input (input abs_shipfrom), input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      if return_int = 0
      then do:

         /* User does not have access to site */
         run DisplayMessage (input 725,
                             input 3,
                             input '').
         undo, retry.
      end.

      /* Changed "authorized" to "l_flag" below */
      {gprun.i ""gpsimver.p""
         "(input abs_shipfrom,
           input abs_inv_mov,
           output l_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

      if not l_flag
      then do:

         /* USER DOES NOT HAVE ACCESS TO THIS SITE/INVENTORY MOVEMENT CODE */
         run DisplayMessage (input 5990,
                             input 4,
                             input '').
         undo, retry.
      end.

      if abs_canceled
      then do:

         /* SHIPPER CANCELED */
         run DisplayMessage (input 5885,
                             input 3,
                             input '').
         undo, retry.
      end.

      if (substring(abs_status,2,1) = "y") = confirm_mode
      then do:

         if confirm_mode
         then do:

            /* Shipper previously confirmed */
            run DisplayMessage (input 8146,
                                input 3,
                                input '').
         end.
         else do:

            /* Shipper previously not confirmed */
            run DisplayMessage (input 8140,
                                input 3,
                                input '').
         end.
         undo, retry.
      end.

      {&RCSOIS1-P-TAG1}

      if abs_inv_mov <> ""
         and not can-find(first im_mstr
         where im_inv_mov = abs_inv_mov
         and   im_tr_type = "ISS-SO")
      then do:

         {&RCSOIS1-P-TAG2}
         /* Not a Sales Order Shipper */
         run DisplayMessage (input 5802,
                             input 3,
                             input '').
         undo, retry.
      end.  /* if abs_inv_mov */

      if not confirm_mode
      then do:

         yn = no.

         /* Continue with Unconfirm ? */
         run DisplayMessage1(input 5987,
                             input 1,
                             input-output yn).
         if not yn
         then
            undo CK-CC-HOLD, leave CK-CC-HOLD.

         assign
            eff_date = abs_eff_date
            ship_dt  = abs_shp_date.

         display
            eff_date
            ship_dt
         with frame a.

      end.

      /* Get length of shipper # */
      if abs_id begins "P"
      then do:

         {gprun.i ""gpgetgrp.p""
            "(input  abs_shipfrom,
              input  abs_shipto,
              output shipgrp)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         nrseq = shc_ship_nr_id.

         if shipgrp <> ?
         then do:

            for first sgid_det
               fields (sgid_grp sgid_inv_mov sgid_ship_nr_id)
               where sgid_grp = shipgrp
                 and sgid_inv_mov = abs_inv_mov
               no-lock:
               nrseq = sgid_ship_nr_id.
            end.
         end. /* if shipgrp <> ? */

         run get_nr_length
            (input nrseq,
             output id_length,
             output errorst,
             output errornum).
         if errorst
         then do:

            run DisplayMessage (input errornum,
                                input 3,
                                input '').
            undo, retry.
         end.

      end. /* if abs_id begins "p" */

      else
         id_length = length(substring(abs_id,2)).

      /* Since invoice# can be 8 char or less, we cannot process this */
      /* preshipper to create a combined shipper-invoice              */
      if abs_id begins "P"
         and can-find (first df_mstr
         where df_type = "1"
         and df_format = abs_format
         and df_inv)
         and id_length > 8
      then do:

         /* INVALID DOCUMENT FORMAT, CANNOT ASSIGN SHIPPER NUMBER */
         run DisplayMessage (input 5887,
                             input 4,
                             input '').
         undo, retry.
      end. /* if abs_id begins "p" */

      if confirm_mode
         and substring(abs_status,1,1) <> "y"
      then do:

         /* Shipper not printed */
         run DisplayMessage (input 8147,
                             input 2,
                             input '').
      end.

      /* ASSIGN global_recid FOR USE IN THE TAX CALCULATION ROUTINE */
      assign
         abs_recid    = recid(abs_mstr)
         global_recid = abs_recid.

      for each work_abs_mstr
         exclusive-lock:
         delete work_abs_mstr.
      end.

      empty temp-table tt_so_mstr.

      /* EXPLODE SHIPPER TO GET ORDER DETAIL */
      {gprun.i ""rcsoisa.p"" "(input recid(abs_mstr))"}
/*GUI*/ if global-beam-me-up then undo, leave.


      /* ADD CONSIGNMENT DATA TO work_abs_mstr */
      if using_cust_consignment
      then do:

         {gprunmo.i &module = "ACN" &program = "rcsoisa2.p"}
      end.  /* if using_cust_consignment */

      /* USE THE qad_wkfl TO KEEP TRACK OF THE SALES ORDERS BEING     */
      /* CONFIRMED SO THAT SHIPPERS RELATED TO THE SAME ORDER ARE NOT */
      /* SIMULTANEOUSLY CONFIRMED.                                    */
      do transaction:
         run p-qadwkfl.
         if l_undoflg = yes
         then
            undo CK-CC-HOLD, leave CK-CC-HOLD.
      end.  /* DO TRANSACTION */

      assign
         l_undoflg = no
         /* EXIT IF THERE IS ANY PENDING CHANGE FOR EMT ORDER */
         que-doc = no.

      for each work_abs_mstr
         where abs_order > ""
         no-lock
      break by work_abs_mstr.abs_order
      on endkey undo CK-CC-HOLD, leave CK-CC-HOLD:

         if first-of (work_abs_mstr.abs_order)
         then do:

            assign l_wo_reject = no
                   l_undoflg   = no.

            run CheckWOAndCMF (input work_abs_mstr.abs_order,
                               input work_abs_mstr.abs_line,
                               output l_wo_reject,
                               output l_undoflg,
                               input-output que-doc) no-error.

            if l_wo_reject = yes
            then
               undo mainloop, retry mainloop.

            if l_undoflg = yes
            then
               undo, retry.

         end. /* if first-of(abs_order) */

      end. /* for each work_abs_mstr */

      assign
         shp_time = substring(string(abs_shp_time,"hh:mm"),1,2)
                  + substring(string(abs_shp_time,"hh:mm"),4,2)
         arr_date = abs_arr_date
         arr_time = substring( string(abs_arr_time,"hh:mm"),1,2)
                  + substring( string(abs_arr_time,"hh:mm"),4,2)
         abs_shipvia    = substring(abs__qad01,1,20)
         abs_fob        = substring(abs__qad01,21,20)
         abs_carr_ref   = substring(abs__qad01,41,20)
         abs_trans_mode = substring(abs__qad01,61,20)
         abs_veh_ref    = substring(abs__qad01,81,20).

      for first work_abs_mstr
         where work_abs_mstr.abs_id begins "I"
         no-lock:

         {&RCSOIS1-P-TAG3}
         if work_abs_mstr.abs_order <> ""
         then do:

            {&RCSOIS1-P-TAG4}
            for first scx_ref
               fields (scx_order scx_shipfrom scx_shipto scx_type)
               where scx_type  = 1
                 and scx_order = abs_order
               no-lock:
            end. /* FOR FIRST scx_ref */
         end. /* IF ABS_ORDER <> "" */

         else do:

            for first scx_ref
               fields (scx_order scx_shipfrom scx_shipto scx_type)
               where scx_type     = 1
                 and scx_shipfrom = abs_shipfrom
                 and scx_shipto   = abs_shipto
               no-lock:
            end. /* FOR FIRST scx_ref */
         end. /* ELSE */
      end. /* FOR FIRST work_abs_mstr */

      if available scx_ref
      then do:

         for first so_mstr
            fields (so_bill so_cr_terms so_curr so_cust so_disc_pct
                    so_exru_seq so_ex_rate so_ex_rate2 so_ex_ratetype
                    so_fix_rate so_fr_terms so_invoiced so_inv_mthd
                    so_inv_nbr so_nbr so_pst_pct so_quote so_secondary
                    so_ship_date so_site so_slspsn so_stat so_tax_date
                    so_tax_pct so_to_inv so_trl1_amt so_trl1_cd
                    so_trl2_amt so_trl2_cd so_trl3_amt so_trl3_cd
                    so_bol so__qadc01)
            where so_nbr = scx_order
            no-lock:
      end.

         auto_post  = substring(so_inv_mthd,2,1) = "y".

      end.

      for first ad_mstr
         fields (ad_addr ad_line1 ad_name)
         where ad_addr = abs_mstr.abs_shipto
         no-lock: end.

      display
         si_desc
         abs_mstr.abs_shipto
         ad_name
         ad_line1
      with frame a.

      if confirm_mode
      then
         update
            ship_dt
            eff_date
         with frame a.
      {&RCSOIS1-P-TAG17}

      /* VERIFY OPEN GL PERIOD FOR LINE ITEM SITE/ENTITY, */
      /* NOT PRIMARY ENTITY                               */
      run p_glcalval
         (output l_flag).
      if l_flag
      then do:

         next-prompt abs_mstr.abs_shipfrom with frame a.
         undo CK-CC-HOLD, leave CK-CC-HOLD.
      end.  /* IF L_FLAG */

      display
         abs_veh_ref shp_time arr_date arr_time
      with frame ab.

      do with frame ab on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

         set
            abs_veh_ref
            shp_time
            arr_date
            arr_time with frame ab.
         /* EDIT USER INPUT TIME FIELDS */
         {gprun.i ""fstimchk.p""
          "(input         ""T"",
            input         shp_time,
            input         """",
            output        shp_time,
            output        dummy-length,
            output        msgnbr)"}
/*GUI*/ if global-beam-me-up then undo, leave.


          /* FSTIMCHK WILL RETURN ONE OF TWO POTENTIAL  */
          /* ERRORS.  #30 IS FOR MINUTES > 59.  #69     */
          /* INDICATES NON-NUMERIC INPUT, IN WHICH CASE */
          /* WE WANT TO PRESERVE AND REDISPLAY THE USER */
          /* INPUT.                                     */
         if msgnbr <> 0
         then do:

             run DisplayMessage (input msgnbr,
                                 input 3,
                                 input '').
             next-prompt shp_time with frame ab.
             undo,retry.
         end.

         /* EDIT USER INPUT TIME FIELDS */
         {gprun.i ""fstimchk.p""
           "(input         ""T"",
           input         arr_time,
           input         """",
           output        arr_time,
           output        dummy-length,
           output        msgnbr)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         /* FSTIMCHK WILL RETURN ONE OF TWO POTENTIAL  */
         /* ERRORS.  #30 IS FOR MINUTES > 59.  #69     */
         /* INDICATES NON-NUMERIC INPUT, IN WHICH CASE */
         /* WE WANT TO PRESERVE AND REDISPLAY THE USER */
         /* INPUT.                                     */

         if msgnbr <> 0
         then do:

             run DisplayMessage (input msgnbr,
                                 input 3,
                                 input '').
             next-prompt arr_time with frame ab.
             undo,retry.
         end.
         find abs_mstr
            where recid(abs_mstr) = abs_recid
            exclusive-lock
            no-error.
         assign
            abs_shp_time = ((integer(substring(shp_time,1,2)) * 60)
                           + integer(substring(shp_time,3,2))) * 60
            abs_arr_date = arr_date
            abs_arr_time = ((integer(substring(arr_time,1,2)) * 60)
                           + integer(substring(arr_time,3,2))) * 60
            overlay(abs__qad01,81,20) = string(abs_veh_ref,"x(20)").
      end.
/*GUI*/ if global-beam-me-up then undo, leave.

      /* Warn if there is any sales orders on the shipper */
      /* that has its action status non-blank             */
      for each work_abs_mstr
         no-lock
         where abs_order > ""
      break by abs_order
      on endkey undo CK-CC-HOLD, leave CK-CC-HOLD:

         if first-of (abs_order)
         then do:

            for first so_mstr
               fields (so_bill so_cr_terms so_curr so_cust so_disc_pct
                       so_exru_seq so_ex_rate so_ex_rate2 so_ex_ratetype
                       so_fix_rate so_fr_terms so_invoiced so_inv_mthd
                       so_inv_nbr so_nbr so_pst_pct so_quote
                       so_secondary so_ship_date so_site so_slspsn
                       so_stat so_tax_date so_tax_pct so_to_inv
                       so_trl1_amt so_trl1_cd so_trl2_amt so_trl2_cd
                       so_trl3_amt so_trl3_cd so_bol so__qadc01)
               where so_nbr = abs_order
               no-lock: 
                xxsoid = RECID(so_mstr).
            end.

            if available so_mstr
            then do:

               for first cm_mstr
                  fields (cm_addr cm_cr_hold)
                  where cm_addr = so_bill
                  no-lock:
               end.

               if available cm_mstr
                  and cm_cr_hold
               then do:

                  /* CUSTOMER ON CREDIT HOLD */
                  run DisplayMessage (input 614,
                                      input 2,
                                      input '').
                  leave.
               end. /* IF AVAILABLE CM_MSTR */

               if so_stat <> ""
               then do:

                  /* SALES ORDER STATUS NOT BLANK */
                  run DisplayMessage (input 623,
                                      input 2,
                                      input '').
                  leave.
               end.

               if not can-find (first tt_so_mstr
                                   where tt_so_mstr.tt_so_nbr = so_nbr)
               then do:
                  create tt_so_mstr.
                  assign
                     tt_so_mstr.tt_so_nbr       = so_nbr
                     tt_so_mstr.tt_so_to_inv    = so_to_inv
                     tt_so_mstr.tt_so_invoiced  = so_invoiced
                     tt_so_mstr.tt_so_ship_date = so_ship_date
                     tt_so_mstr.tt_so_tax_date  = so_tax_date
                     tt_so_mstr.tt_so_bol       = so_bol
                     tt_so_mstr.tt_so__qadc01   = so__qadc01.
               end. /* IF NOT CAN-FIND (FIRST tt_so_mstr */

            end. /* IF AVAILABLE SO_MSTR */

            else if not available so_mstr
            then do:

               /* SALES ORDER DOES NOT EXIST  */
               run DisplayMessage (input 609,
                                   input 3,
                                   input '').
               undo CK-CC-HOLD, leave CK-CC-HOLD.
               leave.
            end.

         end. /* if first-of  abs_order */

         if not can-find(sod_det
            where sod_nbr  = abs_order
              and sod_line = integer(abs_line))
              and abs_qty <> abs_ship_qty
         then do:

            /* SALES ORDER LINE DOES NOT EXIST  */
            run DisplayMessage (input 764,
                                input 3,
                                input '').
            undo CK-CC-HOLD, leave CK-CC-HOLD.
         end.

      end. /* for each work_abs_mstr */

      do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


         /* If the structure is a "pre-shipper" then convert it into */
         /* a "shipper" first. For that, generate the shipper#       */
         if abs_mstr.abs_id begins "p"
         then do:

            {gprun.i ""gpgetgrp.p""
               "(input  abs_mstr.abs_shipfrom,
                 input  abs_mstr.abs_shipto,
                 output shipgrp)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            nrseq = shc_ship_nr_id.

            if shipgrp <> ?
            then do:

               for first sgid_det
                  fields (sgid_grp sgid_inv_mov sgid_ship_nr_id)
                  where sgid_grp = shipgrp
                    and sgid_inv_mov = abs_inv_mov
                  no-lock:
                  nrseq = sgid_ship_nr_id.
               end. /* FOR FIRST SGID_DET */

            end.

            run chk_internal
               (input nrseq,
                output is_internal,
                output errorst,
                output errornum).

            if errorst
            then do:

               run DisplayMessage (input errornum,
                                   input 3,
                                   input '').
               undo CK-CC-HOLD, leave CK-CC-HOLD.
            end.

            if is_internal
            then do:

               run getnbr
                  (input nrseq,
                   input today,
                   output shipnbr,
                   output errorst,
                   output errornum).

               if errorst
               then do:

                  run DisplayMessage (input errornum,
                                      input 3,
                                      input '').
                  undo CK-CC-HOLD, leave CK-CC-HOLD.
               end.

               display
                  shipnbr
               with frame convfrm.

               if not batchrun
               then
                  pause.

            end.

            else do: /* external sequence */

               updnbr:
               do on endkey undo updnbr, leave updnbr:

                  update
                     shipnbr
                  with frame convfrm.

                  if can-find (first abs_temp
                     where abs_temp.abs_shipfrom = abs_mstr.abs_shipfrom
                       and abs_temp.abs_id = "S" + shipnbr)
                  then do:

                     /* SHIPPER ALREADY EXISTS */
                     run DisplayMessage (input 8278,
                                         input 3,
                                         input '').
                     undo updnbr, retry updnbr.
                  end.

                  run valnbr
                     (input nrseq,
                      input today,
                      input shipnbr,
                      output is_valid,
                      output errorst,
                      output errornum).

                  if errorst
                  then do:

                     run DisplayMessage (input errornum,
                                         input 3,
                                         input '').
                     undo updnbr, retry updnbr.
                  end.

                  else if not is_valid
                  then do:

                     /* INVALID PRE-SHIPPER/SHIPPER NUMBER FORMAT */
                     run DisplayMessage (input 5950,
                                         input 3,
                                         input '').
                     undo updnbr, retry updnbr.
                  end.

               end. /* updnbr */

               if keyfunction(lastkey) = "end-error"
               then do:

                  hide frame convfrm no-pause.
                  undo CK-CC-HOLD, leave CK-CC-HOLD.
               end.

            end. /* external sequence */

            hide frame convfrm no-pause.

            shipnbr = "S" + shipnbr.

            find abs_mstr
               where recid(abs_mstr) = abs_recid
               exclusive-lock
               no-error.

            /* Save the preshipper# and overwrite abs_id with shipper# */
            assign
               abs_mstr.abs_preship_id    = abs_mstr.abs_id
               abs_mstr.abs_preship_nr_id = abs_mstr.abs_nr_id
               abs_mstr.abs_nr_id         = nrseq.

            /* CHANGE THE SHIPPER NUMBER IN THE WORK_ABS_MSTR */
            {gprun.i ""rcsoisa1.p""
               "(abs_mstr.abs_shipfrom,
                 abs_mstr.abs_id,
                 shipnbr)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            /* CHANGE THE SHIPPER NUMBER FOR ENTIRE SHIPPER STRUCTURE */
            {gprun.i ""icshchg.p"" "(recid(abs_mstr), shipnbr)" }
/*GUI*/ if global-beam-me-up then undo, leave.


            /* ASSIGN SHIPPER NUMBER TO CARRIER REF IF CARRIER REF IS */
            /* PRE_SHIPPER NUMBER */
            if right-trim(substring(abs_mstr.abs_preship_id,2,20)) =
               right-trim(substring(abs_mstr.abs__qad01,41,20))
            then
               assign
                  overlay(abs_mstr.abs__qad01,41,20) =
                     substring(abs_mstr.abs_id,2,20)
                  abs_carr_ref = substring(abs_mstr.abs__qad01,41,20).

         if use-log-acctg
         then do:

            run changeShipperNumberInLogAcctDetail
                   (input {&TYPE_SOPreShipper},
                    input substring(abs_mstr.abs_preship_id,2),
                    input abs_mstr.abs_shipfrom,
                    input {&TYPE_SOShipper},
                    input substring(abs_mstr.abs_id,2),
                    input abs_mstr.abs_shipfrom).
         end. /* IF USE-LOG-ACCTG */

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF ABS_MSTR.ABS_ID BEGINS "P"  */
      end. /* DO TRANSACTION */

      /* CHECK FOR UNPEGGED SHIPPER LINES */
      {gprun.i ""rcsois4a.p""
         "(input abs_recid, output yn)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      if yn
      then
         undo CK-CC-HOLD, leave CK-CC-HOLD.

      for first df_mstr
         fields (df_format df_inv df_type)
         where  df_type = "1"
           and  df_format = abs_format
         no-lock:
      end.

      if available df_mstr
         and df_inv
      then
         assign
            auto_post   = yes
            use_shipper = yes
            consolidate = yes
            auto_inv    = no.

      else
      if not available df_mstr
         or (available df_mstr
         and not df_inv)
      then do:

         auto_inv = auto_post.

         if auto_post
         then
            for first mfc_ctrl
               fields (mfc_field mfc_logical )
               where mfc_field = "rcc_auto_inv"
               no-lock:
               auto_inv = mfc_logical.
            end. /* FOR FIRST mfc_ctrl */

      end. /* ELSE IF NOT AVAILABLE df_mstr .. */

      if id_length > 8
      then
         use_shipper = no.
      {&RCSOIS1-P-TAG5}

      if available so_mstr
      then do:

         {gprunp.i "gpccpl" "p" "isCCOrder"
            "(input so_nbr, output creditCardOrder)"}
      end. /* IF AVAILABLE so_mstr */

      {&RCSOIS1-P-TAG6}
      if creditCardOrder
      then do:

         assign
            use_shipper = no
            consolidate = no.
         display use_shipper consolidate with frame b.
      end. /*if creditCardOrder then do:*/

      {&RCSOIS1-P-TAG11}
          auto_inv = YES.
      auto_post = YES.
      use_shipper = NO.
       consolidate = YES.
    /*  FIND FIRST abs_mstr WHERE substring(abs_mstr.ABS_par_id,2,50) = INPUT ABS_id NO-LOCK.
                FIND FIRST xxsomstr WHERE xxsomstr.so_nbr = abs_mstr.ABS_ord  AND xxsomstr.so_inv_nbr <> '' NO-LOCK NO-ERROR.
                  
      
          IF AVAILABLE xxsomstr THEN do:
              xxinv_nbr = xxsomstr.so_inv_nbr.
              DISP xxinv_nbr WITH FRAME b.
          END.*/
       misinv = NO.
        DISP /*auto_inv auto_post*/ use_shipper  consolidate WITH FRAME b.
       IF xxinv_nbr <> '' THEN DO:
         
           
           misinv = YES.
           DISP xxinv_nbr WITH FRAME b.
           END.
       update
         auto_inv
         auto_post
        /* use_shipper when (not creditCardOrder)*/
        /* consolidate when (not creditCardOrder)*/
              xxinv_nbr WHEN (NOT misinv)
              l_calc_freight
      with frame b.
                         FIND FIRST ih_hist WHERE ih_inv_nbr = xxinv_nbr NO-LOCK NO-ERROR.
                         IF AVAILABLE ih_hist  THEN   DO:
                                        MESSAGE "Invoice number has been posted!" VIEW-AS ALERT-BOX BUTTON OK. 
                             UNDO,RETRY.
                         NEXT-PROMPT xxinv_nbr.
                             
                             
                             END.
                             FIND last so_mstr WHERE  (IF ad_ref =  '' THEN so_cust <> ad_addr  ELSE so_cust <> ad_ref )  AND so_inv_nbr = xxinv_nbr NO-LOCK NO-ERROR.
                           IF AVAILABLE so_mstr THEN  DO:
                            MESSAGE "Invoice number has been used by another custom!" VIEW-AS ALERT-BOX BUTTON OK. 
                             UNDO,RETRY.
                               
                               
                               END.
                                for first so_mstr
               fields (so_bill so_cr_terms so_curr so_cust so_disc_pct
                       so_exru_seq so_ex_rate so_ex_rate2 so_ex_ratetype
                       so_fix_rate so_fr_terms so_invoiced so_inv_mthd
                       so_inv_nbr so_nbr so_pst_pct so_quote
                       so_secondary so_ship_date so_site so_slspsn
                       so_stat so_tax_date so_tax_pct so_to_inv
                       so_trl1_amt so_trl1_cd so_trl2_amt so_trl2_cd
                       so_trl3_amt so_trl3_cd so_bol so__qadc01)
               where RECID(so_mstr) = xxsoid
               no-lock:
            end.
                         {&RCSOIS1-P-TAG12}

      errornum = if use_shipper
                    and id_length > 8
                 then
                    /* Shipper number too long, use shipper document as inv */
                    5982
                 else if use_shipper
                    and not consolidate
                 then
                    /* Consolidating mandatory when using shipper nbr as inv */
                    5984
                 else
                    0.

      if errornum <> 0
      then do:

         run DisplayMessage (input errornum,
                             input 3,
                             input '').
         next-prompt use_shipper with frame b.
         undo, retry.
      end.

      if available df_mstr
         and df_inv
         and not use_shipper
      then do:

         /* DOCUMENT FORMAT REQUIRES SHIPPER NUMBER TO BE USED FOR INVOICE */
         run DisplayMessage (input 5992,
                             input 2,
                             input '').
      end.

      /* VALIDATES THAT THERE IS ADEQUATE INVENTORY AVAILABLE TO SHIP ALL */
      /* LINES WITH SAME SITE, LOC & PART IF OVER-ISSUE NOT ALLOWED */
      /* VALIDATE WHEN CONFIRMING, SKIP WHEN UN-CONFIRMING. */
      /* THIS ALLOWS SERIAL NUMBERS TO BE RETURNED FROM CONSIGNMENT */
      /* LOCATIONS. */

      if confirm_mode
      then do:

         {gprun.i ""rcsoisg.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

         if rejected
         then
            undo CK-CC-HOLD, leave CK-CC-HOLD.
      end.  /* if confirm_mode */

      /* GO THRU WORKFILE FOR  VALIDATION,  UPDATE  STD  COSTS,      */
      /* SET PRICES,  SET  INVOICING  FLAGS, UPDATE FREIGHT CHARGES, */
      /* MANUAL UPDATE OF TRAILER CHARGES,                           */
      /* AND ORDER  THE  SECRETARY  FLOWERS                          */

      assign
         tot_freight_gl_amt = 0
         order_ct = 0.

      do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


         for each work_abs_mstr
            where abs_order > ""
            no-lock,
            each sod_det
            exclusive-lock
            where sod_nbr = abs_order
              and sod_line = integer(abs_line)
         break by abs_order by abs_line:
/*GUI*/ if global-beam-me-up then undo, leave.


            if (oldcurr <> so_curr)
               or (oldcurr = "")
            then do:

               /* GET ROUNDING METHOD FROM CURRENCY MASTER */
               {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                  "(input so_curr,
                    output rndmthd,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:

                  run DisplayMessage (input mc-error-number,
                                      input 3,
                                      input '').
                  undo CK-CC-HOLD, leave CK-CC-HOLD.
               end.  /* mc-error-number <> 0 */

               oldcurr = so_curr.

            end.

            if first(abs_order)
            then do:

               find so_mstr
                  where so_nbr = sod_nbr
                  exclusive-lock.

               assign
                  l_first_so_nbr     = so_nbr
                  first_so_bill      = so_bill
                  first_so_cust      = so_cust
                  first_so_curr      = so_curr
                  first_so_cr_terms  = so_cr_terms
                  first_so_trl1_cd   = so_trl1_cd
                  first_so_trl2_cd   = so_trl2_cd
                  first_so_trl3_cd   = so_trl3_cd
                  first_so_slspsn[1] = so_slspsn[1]
                  first_so_slspsn[2] = so_slspsn[2]
                  first_so_slspsn[3] = so_slspsn[3]
                  first_so_slspsn[4] = so_slspsn[4]
                  first_so_entity    = ""
                  first_so_site      = so_site
                  first_so_ex_rate   = so_ex_rate
                  first_so_ex_rate2  = so_ex_rate2
                  first_so_exru_seq  = so_exru_seq.

               for first si_mstr
                  fields (si_db si_desc si_entity si_site)
                  where si_site = so_site
               no-lock:
                  first_so_entity = si_entity.
               end.

               /* MULTI-DB: USE SHIP-TO CUSTOMER TYPE FOR DEFAULT */
               /* IF AVAILABLE ELSE USE BILL-TO TYPE USED TO      */
               /* FIND COGS ACCOUNT IN SOCOST02.p                 */
               {gprun.i ""gpcust.p""
                  "(input  so_nbr, output ord-db-cmtype)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            end.
/*GUI*/ if global-beam-me-up then undo, leave.


            /* CONVERTING SHIPQTY TO INVENTORY UM FROM SHIP UM */
            shipqty = (if confirm_mode
                       then
                          (work_abs_mstr.abs_qty - work_abs_mstr.abs_ship_qty)
                      /* CORRECTED THE SHIPQTY DURING UNCONFIRM MODE  */
                       else
                          (-1 * work_abs_mstr.abs_qty)) *
                         decimal(work_abs_mstr.abs__qad03).

            if abs_item = sod_part
            then
               accumulate shipqty (sub-total by abs_line).

            if first-of(abs_order)
            then do:
               l_so_to_inv = no.

               order_ct = order_ct + 1.

               if order_ct <= 30
               then
                  order_nbrs[order_ct] = sod_nbr.
               else
                  order_nbr_list = order_nbr_list + sod_nbr + ",".

               for first so_mstr
                  fields (so_bill so_cr_terms so_curr so_cust so_disc_pct
                          so_exru_seq so_ex_rate so_ex_rate2 so_ex_ratetype
                          so_fix_rate so_fr_terms so_invoiced so_inv_mthd
                          so_inv_nbr so_nbr so_pst_pct so_quote
                          so_secondary so_ship_date so_site so_slspsn
                          so_stat so_tax_date so_tax_pct so_to_inv
                          so_trl1_amt so_trl1_cd so_trl2_amt so_trl2_cd
                          so_trl3_amt so_trl3_cd so_bol so__qadc01)
                  where so_nbr = sod_nbr
                  no-lock:
               end.

               /* CHECK FOR USE SHIPPER AS INVOICE NUMBER */
              
               if use_shipper
               then do:

                  if can-find(first so_mstr
                     where so_inv_nbr = substring(abs_mstr.abs_id,2,50))
                        or can-find(ar_mstr
                     where ar_nbr = substring(abs_mstr.abs_id,2,50))
                        or can-find(first ih_hist
                     where ih_inv_nbr = substring(abs_mstr.abs_id,2,50))
                  then do:

                     /* Cannot auto invoice.                  */
                     /* Shipper already used by invoice/order */
                     run DisplayMessage (input 8150,
                                         input 3,
                                         input '').
                     undo CK-CC-HOLD, leave CK-CC-HOLD.
                  end.
               end.

               /*CHECK CONSISTENCY OF SALES ORDERS*/
               if consolidate
               then do:

                  msg_text = "".

                  /* PROCEDURE FOR CONSOLIDATION RULES */
                  {gprun.i ""soconso.p""
                     "(input 2,
                       input  l_first_so_nbr ,
                       input  so_nbr ,
                       output l_consolidate_ok,
                       output msg_text)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  if msg_text > ""
                  then do:

                     /* MISMATCH WITH PENDING INVOICE - CAN'T CONSOLIDATE. */
                     run DisplayMessage (input 1046,
                                         input 3,
                                         input msg_text).
                     undo CK-CC-HOLD, leave CK-CC-HOLD.
                  end.

               end. /* IF CONSOLIDATE */

               if use-log-acctg
                  and l_calc_freight
               then do:

                  msg_text = "".

                  run validateSOForLogisticsAccounting
                         (input l_first_so_nbr,
                          input so_nbr,
                          output msg_text).

                  if msg_text > ""
                  then do:

                     /* ALL ATTACHED ORDERS MUST HAVE SAME # */
                     run DisplayMessage (input 5588,
                                         input 3,
                                         input msg_text).
                     undo CK-CC-HOLD, leave CK-CC-HOLD.
                  end.

               end. /* IF USE-LOG-ACCTG AND l_CALC_FREIGHT */

               if so_fix_rate
               then
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
                             output mc-error-number)" }
                  if mc-error-number <> 0
                  then do:

                     run DisplayMessage (input mc-error-number,
                                         input 3,
                                         input '').
                     undo CK-CC-HOLD, leave CK-CC-HOLD.
                  end.
                  assign
                     exch_ratetype = so_ex_ratetype
                     exch_exru_seq = 0.

               end.  /* else */

               find so_mstr
                  where so_nbr = sod_nbr
                  exclusive-lock.

               if available so_mstr
               then
                  assign
                     so_ship_date = ship_dt
                     so_invoiced  = no
                     so_tax_date  = ship_dt.

               /* TO DOWNGRADE THE LOCK TO NO-LOCK AS THE FIELDS */
               /* OF THE so_mstr ARE ACCESSED BELOW              */
               for first so_mstr
                  where so_nbr = sod_nbr
                  no-lock:

               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR FIRST so_mstr */

            end. /* IF FIRST-OF(ABS_ORDER) */

            if last-of(abs_line)
            then do:

               /* SET STANDARD COST */

               /* SWITCH TO INVENTORY DATABASE IF NECESSARY */
               if change_db
               then do:

                  run ip_alias
                     (input ship_db,
                      output l_flag).
                  if l_flag
                  then
                     undo CK-CC-HOLD, leave CK-CC-HOLD.
               end.

               /* SET STANDARD COST FROM INVENTORY DATABASE */
               {gprun.i ""gpsct05.p""
                  "(input sod_part,
                    input sod_site,
                    input 1,
                    output glxcst,
                    output curcst)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               /* SWITCH BACK TO SALES ORDER DATABASE IF NECESSARY */
               if change_db
               then do:

                  run ip_alias
                     (input so_db,
                      output l_flag).
                  if l_flag
                  then
                     undo CK-CC-HOLD, leave CK-CC-HOLD.
               end.

               if sod_type <> "M"
               then
                  sod_std_cost = glxcst * sod_um_conv.

               /* If Scheduled Order */
               if sod_sched
               then do:

                  if sod_cum_qty[3] > 0
                     and sod_cum_qty[1]
                     + ((accum sub-total by abs_line shipqty)
                     /   sod_um_conv) >= sod_cum_qty[3]
                  then do on endkey undo CK-CC-HOLD, leave CK-CC-HOLD:

                     hide message no-pause.

                     /* CUM SHIPPED QTY >= MAX ORDER QTY FOR ORDER SELECTED*/
                     run DisplayMessage (input 8220,
                                         input 2,
                                         input '').
                     /* Order # Line # */
                     {pxmsg.i &MSGNUM=8310 &ERRORLEVEL=1
                              &MSGARG1=sod_nbr
                              &MSGARG2=sod_line}
                     if not batchrun
                     then
                        pause.
                  end.

                  /* SET CURRENT PRICE */
                  for first pt_mstr
                     fields (pt_part pt_price)
                     where pt_part = sod_part
                     no-lock:
                  end.

                  /* FOLLOWING SECTION IS ADDED TO REPLACE rcpccal.p */
                  /* WITH gppccal.p TO TAKE CARE OF PRICE LIST TYPES */
                  /* "M" AND "D" IN ADDITION TO "P"                  */
                  for first soc_ctrl
                     fields (soc_pl_req)
                     no-lock:
                  end.

                  assign
                     l_disc_pct1  = 0
                     l_net_price  = ?
                     l_rec_no     = ?
                     l_list_price = 0.

                  /* SCHEDULED ORDERS CAN BE CREATED ONLY IN STOCKING */
                  /* UM MULTIPLYING BY sod_um_conv JUST FOR SAFETY    */
                  if available pt_mstr
                  then do:

                     /* CONVERT FROM BASE TO ACCOUNT CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                              "(input  base_curr,
                                input  so_curr,
                                input  exch_rate2,
                                input  exch_rate,
                                input  pt_price * sod_um_conv,
                                input  false,   /* DO NOT ROUND */
                                output l_list_price,
                                output mc-error-number)"}.
                     if mc-error-number <> 0
                     then do:

                        run DisplayMessage (input mc-error-number,
                                            input 3,
                                            input '').
                        undo CK-CC-HOLD, leave CK-CC-HOLD.
                     end.

                  end.  /* if available */

                  /* Calculate Price */
                  {gprun.i ""gppccal.p""
                     "(input  sod_part,
                       input (accum sub-total by abs_line shipqty) / sod_um_conv,
                       input sod_um,
                       input sod_um_conv,
                       input so_curr,
                       input sod_pr_list ,
                       input eff_date,
                       input sod_std_cost,
                       input soc_pl_req,
                       0.0,
                       input-output  l_list_price,
                       output        l_disc_pct1,
                       input-output  l_net_price,
                       output        l_rec_no)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  create tt_sod_det.

                  assign
                     tt_sod_nbr  = sod_nbr
                     tt_sod_line = sod_line
                     tt_pr_found = if l_rec_no = 0
                                   then
                                      false
                                   else
                                      true.

                  if recid(tt_sod_det) = -1
                  then
                     .

                  if l_net_price <> ?
                  then
                     sod_price = l_net_price.

                  /* UPDATE SOD_LIST_PRICE FOR SCHEDULE ORDER WHEN   */
                  /* SOD_LIST_PRICE IS ZERO OR                       */
                  /* LIST PRICE IN ITEM MASTER IS ZERO SO THAT SALES */
                  /* AMOUNT SHOULD BE POSTED TO PROPER ACCOUNT       */
                  if pt_price    = 0 or
                     sod_list_pr = 0
                  then
                     sod_list_pr = sod_price.

                  /* SWITCHING TO INVENTORY DATABASE */
                  if change_db
                  then do:

                     run ip_alias
                        (input ship_db,
                         output l_flag).
                     if l_flag
                     then
                        undo CK-CC-HOLD, leave CK-CC-HOLD.
                  end. /* IF CHANGE_DB */

                  /* UPDATE NET PRICE, LIST PRICE, CUMULATIVE QTY IN */
                  /* INVENTORY DATABASE                              */
                  {gprun.i ""sosoisu6.p""
                     "(input sod_nbr,
                       input sod_line,
                       input sod_price,
                       input l_list_price,
                       input sod_cum_qty[1],
                       input sod_cum_qty[2],
                       input sod_cum_qty[3])"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  /* SWITCHING BACK TO CENTRAL DATABASE */
                  if change_db
                  then do:

                     run ip_alias (input so_db, output l_flag).
                     if l_flag
                     then
                        undo CK-CC-HOLD, leave CK-CC-HOLD.
                  end. /* IF CHANGE_DB */

               end.

               /* SOD_QTY_CHG IS FOR EVERY SALES ORDER LINE AND THE */
               /* QUANTITY SHOULD BE ACCUMULATED FOR EACH LOTSERIAL */
               /* LINE ENTERED VIA MULTI-ENTRY MODE                 */
               sod_qty_chg =
                  (accum sub-total by abs_line shipqty) / sod_um_conv.

               /* CREATE IMPORT EXPORT HISTORY RECORD */
               run createImpExpHist
                   (buffer sod_det,
                    input sod_qty_chg,
                    input eff_date).

            end. /* if last-of abs_line */

            if last-of(abs_order)
            then do:

               gl_amt = 0.

               if so_fr_terms <> ""
                  and l_calc_freight
               then do:

                  run get_freight_type
                     (input  so_fr_terms,
                      output old_ft_type).

                  so_mstr_recid = recid(so_mstr).

                  /* FREIGHT CHARGE AND WEIGHT CALC FOR SHIPMENTS */

                  {gprun.i ""sofrcals.p""
                     "(input table tt_sod_det)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  for each tt_sod_det
                  exclusive-lock:

                     delete tt_sod_det.

                  end. /* FOR EACH tt_sod_det */

                  if not freight_ok
                  then do:

                     /* Freight error detected - */
                     run DisplayMessage (input 669,
                                         input 2,
                                         input '').
                     pause.
                  end.

               end. /* IF SO_FR_TERMS <> "" AND L_CALC_FREIGHT */

               if rndmthd = ""
               then do:

                  /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                  {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                     "(input so_curr,
                       output rndmthd,
                       output mc-error-number)"}
                  if mc-error-number <> 0
                  then do:

                     run DisplayMessage (input mc-error-number,
                                         input 3,
                                         input '').
                     undo CK-CC-HOLD, leave CK-CC-HOLD.
                  end.  /* IF mc-error-number <> 0 */

               end. /* IF rndmthd = "" */

               /* MANUAL UPDATE OF TRAILER DATA */
               {gprun.i ""rcsoistr.p""
                  "(input sod_nbr,
                    output undo_stat)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               /* WHEN POSTING FREIGHT WITH LOGISTICS ACCOUNTING WE NEED THE  */
               /* TRANSACTION NUMBER(tr_trnbr)FOR THE "ISS-SO" TRANSACTION.   */
               /* THIS NUMBER IS USED TO RELATE THE TRGL_DET RECORDS CREATED  */
               /* IN LAFRPST.P TO "ISS-SO" TRANSACTION(TR_HIST) RECORD.       */
               /* THERFORE THE FREIGHT ACCRUAL POSTING FOR LOGISTICS ACCTNG   */
               /* IS DONE AFTER SHIPMENTS ARE PROCESSED (I.E.AFTER RCSOIS1A.P */
               /* IS CALLED).                                                 */

               /* POST FREIGHT ACCRUALS - WHEN LOG ACCTG IS NOT ENABLED */
               if gl_amt <> 0
                  and (not use-log-acctg)
               then do:

                  so_mstr_recid = recid(so_mstr).
                  {gprun.i ""sofrpst.p"" "(input eff_date)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end. /* IF GL_AMT <> 0 */

               tot_freight_gl_amt = tot_freight_gl_amt + gl_amt.

               if undo_stat
               then
                  undo CK-CC-HOLD, leave CK-CC-HOLD.

            end. /* if last-of(abs_order) */
            /* CHECK FOR SALES ORDER HAVING ALL CONSIGNED LINES AND NO       */
            /* TRAILER AMOUNTS AND SET so_to_inv = NO FOR SUCH SALES ORDERS. */
            run  p_set-so-to-invoice (input work_abs_mstr.abs_order,
                                      input work_abs_mstr.abs_line,
                                      input-output l_so_to_inv,
                                      input work_abs_mstr.abs_qty,
                                      input work_abs_mstr.abs__qadc01).

         end. /* for each work_abs_mstr */

         /* For Pre-shipper/shipper confirm determines if this order
          * will be processed with a credit card and validate that
          * the credit card info is valid and that the authorized
          * amount is enough to process the order.*/
         if confirm_mode = yes
            and available so_mstr
         then do:

            {&RCSOIS1-P-TAG7}
            {gprunp.i "soccval" "p" "preValidateCCProcessing"
               "(input so_nbr, output errorNbr)"}
            if errorNbr <> 0
            then do:

               run DisplayMessage (input errorNbr,
                                   input 2,
                                   input '').
               /*ORDER PLACED ON HOLD*/
               run DisplayMessage (input 3468,
                                   input 2,
                                   input '').
               vSOToHold = so_nbr.
            end.
            {&RCSOIS1-P-TAG8}
         end. /* IF confirm_mode = YES AND ... */

         /* WHILE UNCONFIRMING THE SHIPPER, trq_mstr GETS DELETED  */
         /* IF ASN HAS BEEN EXPORTED OTHERWISE DISPLAY THE WARNING */
         if can-find(btb_det
            where  btb_so       = sod_nbr
            and btb_sod_line = sod_line)
            and not confirm_mode
         then do:

            run p-del-trq_mstr.
            if l_flag1 = yes
            then
               undo CK-CC-HOLD, leave CK-CC-HOLD.
         end. /* IF CAN-FIND(btb_det) */

         if using_container_charges
         then do:

            /* CREATE THE SALES ORDER DETAIL CONTAINER CHARGE RECORDS */
            {gprunmo.i &module = "ACL" &program = ""rcsoiscd.p""
               &param   = """(input abs_shipfrom,
                              input abs_shipto,
                              input ship_dt,
                              input eff_date,
                              input abs_recid,
                              input confirm_mode,
                              input auto_post,
                              input no)"""}
         end.

         if using_line_charges
         then do:

            /* EXPLODE SHIPPER TO GET ORDER ADDITIONAL CHARGES DETAIL */
            {gprunmo.i &module = "ACL" &program = ""rcsoiscf.p""
               &param   = """(input recid(abs_mstr),
                              input confirm_mode,
                              input no)"""}
         end.

         txcalcref = string(abs_mstr.abs_shipfrom,"x(8)") +
                            abs_mstr.abs_id.

         /* THE POST FLAG IS SET TO 'NO' BECAUSE WE ARE NOT CREATING
          * QUANTUM REGISTER RECORDS FROM THIS CALL TO TXCALC.P */
         run p_taxcal.

         yn = yes.
         /* Is all information correct ? */
         {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn}

         if not yn
         then
            undo CK-CC-HOLD, leave CK-CC-HOLD.

      end. /* do transaction */

      do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


         /* SWITCH TO INVENTORY DATABASE IF NECESSARY */
         if change_db
         then do:

            run ip_alias
               (input ship_db,
                output l_flag).

            if l_flag
            then
               undo CK-CC-HOLD, leave CK-CC-HOLD.

         end.

         {gprun.i ""gpnxtsq.p"" "(output trlot)" }
/*GUI*/ if global-beam-me-up then undo, leave.


         /* SWITCH BACK TO SALES ORDER DATABASE IF NECESSARY */
         if change_db
         then do:

            run ip_alias (input so_db, output l_flag).
            if l_flag
            then
               undo CK-CC-HOLD, leave CK-CC-HOLD.

         end.

      end.
/*GUI*/ if global-beam-me-up then undo, leave.


      {&RCSOIS1-P-TAG13}

/* Added input using_cust_consignment    */
      {gprun.i ""rcsois1a.p""
         "(input ""so_shipper_confirm"",
           input using_cust_consignment,
           input table tt_somstr,
           output undo_stat)" }
/*GUI*/ if global-beam-me-up then undo, leave.


      for each tt_somstr exclusive-lock:
         delete tt_somstr.
      end. /* FOR EACH tt_somstr */

      /* PROCEDURE CREATED TO AVOID ACTION SEGMENT ERROR   */
      run p-undo.

      if undo_stat
      then do transaction:

         /* RESET THE tx2d_det, so_mstr AND sod_det TO PRIOR STATUS */
         /* IN CASE OF AN ERROR                                     */
         run p_undo_records
            (buffer tt_so_mstr,
             input txcalcref).

      end. /* IF undo_stat */

      if l_undo
      then
         undo mainloop, retry mainloop.

      if undo_stat
      then
         undo CK-CC-HOLD, leave CK-CC-HOLD.


      /* FREIGHT POSTING WITH LOGISTICS ACCOUNTING DISABLED ARE HANDLED */
      /* ABOVE BY SOFRPST.P                                             */

      /* POST FREIGHT ACCRUALS WITH LOGISTICS ACCOUNTING ENABLED    */
      run p_PostFreightForLogAcctg.

      if available so_mstr
      then
         if not so_sched
         then
            run p_wrk_so_calc.

      global_recid = abs_recid.
      release sod_det.
   end. /* CK-CC-HOLD */

   /* IF CREDIT CARD VALIDATIONS FAILED, PUT THE ORDER ON HOLD */
   /* BEFORE REPEATING THE MAINLOOP.                           */
   if vSOToHold <> ""
   then do transaction:

      run updateSOStatus
         (input vSOToHold).
   end.


end. /* mainloop (repeat) */

{gpdelp.i "soccval" "p"} /*Delete persistent procedure*/

{gpnbrgen.i}
{gpnrseq.i}

{rctxcal.i}

run del-qad-wkfl.

PROCEDURE del-qad-wkfl:
/*-----------------------------------------------------------------------
  Purpose:      Clean up qad_wkfl records used for rcsois.p
  Parameters:
  Notes:        Internal procedure created to reduce compile size
 -------------------------------------------------------------------------*/

   define buffer qad_wkfl for qad_wkfl.

   for each qad_wkfl
      where qad_key3 = "rcsois.p"
        and qad_key4 = mfguser
      exclusive-lock:
      delete qad_wkfl.
   end.

END PROCEDURE.  /* del-qad-wkfl */

PROCEDURE p_glcalval:
/*-----------------------------------------------------------------------
  Purpose:      Verifies open GL Period for each site/entity of
                each line item

  Parameters:   l_flag

  Notes:
 -------------------------------------------------------------------------*/
   define output parameter l_flag like mfc_logical no-undo.

   define buffer work_abs_mstr for work_abs_mstr.
   define buffer si_mstr       for si_mstr.

   for each work_abs_mstr
      where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty
        and (work_abs_mstr.abs_id begins "I" or
            work_abs_mstr.abs_id begins "C")
      no-lock:

      for first si_mstr
         fields (si_db si_desc si_entity si_site )
         where si_site = work_abs_mstr.abs_site
         no-lock:
      end.

      if available si_mstr
      then do:

         /* CHECK GL EFFECTIVE DATE */
         {gpglef01.i ""IC"" si_entity eff_date}

         if gpglef > 0
         then do:

            run DisplayMessage (input gpglef,
                                input 4,
                                input si_entity).
            l_flag = yes.
            return.
         end. /* IF GPGLEF > 0 */

         else do:

            /* CHECK GL EFFECTIVE DATE */
            {gpglef01.i ""SO"" si_entity eff_date}

            if gpglef > 0
            then do:

               run DisplayMessage (input gpglef,
                                   input 4,
                                   input si_entity).
               l_flag = yes.
               return.
            end. /* IF GPGLEF > 0 */

         end. /* ELSE IF GPGLEF = 0 */

      end. /* IF AVAILABLE SI_MSTR */

   end. /* FOR EACH WORK_ABS_MSTR */

END PROCEDURE.  /* p_glcalval */

PROCEDURE ip_alias:
/*-----------------------------------------------------------------------
  Purpose:      Establish an Alias for a particular db

  Parameters:   i_db          Name of the database
                o_err_flag    If true, then database alias not established
  Notes:
 -------------------------------------------------------------------------*/

   define input  parameter i_db       like global_db no-undo.
   define output parameter o_err_flag as   logical   no-undo.
   define variable         v_err_num  as   integer   no-undo.

   {gprun.i ""gpalias3.p"" "(i_db, output v_err_num)" }
/*GUI*/ if global-beam-me-up then undo, leave.


   o_err_flag = v_err_num = 2 or v_err_num = 3.

   if o_err_flag
   then do:

      /* Database # not available */
      run DisplayMessage (input 2510,
                          input 4,
                          input i_db).
   end.

END PROCEDURE.  /* ip_alias */


PROCEDURE updateSOStatus:
/*-----------------------------------------------------------------------
  Purpose:      Set the so_stat field of a Sales Order to the value of
                ccc_cc_hold_status

  Parameters:   pSONbr - Sales Order Number

  Notes:        added by N06R for Net.Commerce
 -------------------------------------------------------------------------*/
   define input parameter pSONbr as character no-undo.

   define buffer ccc_ctrl for ccc_ctrl.
   define buffer so_mstr  for so_mstr.

   for first ccc_ctrl
      fields (ccc_cc_hold_status)
      no-lock:

      for first so_mstr
         exclusive-lock
         where so_nbr = pSONbr:
         so_stat = ccc_cc_hold_status.
      end.

      release so_mstr.

   end.

END PROCEDURE.


PROCEDURE p-qadwkfl:
/*-----------------------------------------------------------------------
  Purpose:
  Parameters:   <None>
  Notes:
 -------------------------------------------------------------------------*/

   define buffer work_abs_mstr for work_abs_mstr.
   define buffer qad_wkfl      for qad_wkfl.

   for each work_abs_mstr
      exclusive-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


      if work_abs_mstr.abs_order <> ""
      then do:

         for first qad_wkfl
            fields (qad_charfld qad_datefld qad_key1 qad_key2 qad_key3 qad_key4)
            where qad_key1 = "rcsois.p"
              and qad_key2 = work_abs_mstr.abs_order
            no-lock:
         end.

         if available qad_wkfl
            and qad_wkfl.qad_key4 <> mfguser
         then do:

            /* SALES ORDER # IS BEING CONFIRMED BY USER # */
            {pxmsg.i &MSGNUM=2262 &ERRORLEVEL=3
                     &MSGARG1=qad_key2
                     &MSGARG2=qad_charfld[1]}
            l_undoflg = yes.
         end.  /* IF AVAILABLE qad_wkfl */

         else
         if not available qad_wkfl
         then do:

            create qad_wkfl.
            assign
               qad_key1       = "rcsois.p"
               qad_key2       = work_abs_mstr.abs_order
               qad_key3       = "rcsois.p"
               qad_key4       = mfguser
               qad_charfld[1] = global_userid
               qad_charfld[2] = work_abs_mstr.abs_par_id
               qad_charfld[3] = work_abs_mstr.abs_shipfrom
               qad_date[1]    = today
               qad_charfld[5] = string(time, "hh:mm:ss").

            if recid(qad_wkfl) = -1
            then
               .

         end.  /* IF NOT AVAILABLE qad_wkfl */

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF abs_order <> "" */

      work_abs_mstr.abs_ship_qty = 0.

   end.  /* FOR EACH work_abs_mstr */

END PROCEDURE.

PROCEDURE p-del-trq_mstr:
   define buffer trq_mstr for trq_mstr.

   find first trq_mstr
      where trq_doc_type = "ASN"                  and
            trq_doc_ref  =  abs_mstr.abs_shipfrom and
            trq_add_ref  =  trim("s" +
                            substring(abs_mstr.abs__qad01,41,20))
   exclusive-lock no-error.
   if available trq_mstr
   then
      delete trq_mstr.
   else do:
      yn = no.
      /* This is an EMT Shipper. The ASN is already transmitted. */

      {pxmsg.i &MSGNUM=4391 &ERRORLEVEL=1}

      /* Continue with Unconfirm ? */
      {pxmsg.i &MSGNUM=5987 &ERRORLEVEL=1 &CONFIRM=yn}

      if yn = no
      then
         l_flag1 = yes.
      else
         l_flag1 = no.
   end. /* ELSE DO */

END PROCEDURE. /*PROCEDURE p-del-trq_mstr */

PROCEDURE p-undo :
/*-----------------------------------------------------------------------
  Purpose: To avoid Action segment error .
  Parameters:   <None>
  Notes:
 -------------------------------------------------------------------------*/
   if l_undo
   then do:

      if not batchrun
      then
         pause.

   end. /* IF l_undo */
END PROCEDURE.

/* INTERNAL PROCEDURES changeShipperNumberInLogAcctDetail AND          */
/*   validateSOForLogisticsAccounting ARE DEFINED IN larcsois.i        */
{rcsoisla.i}

PROCEDURE DisplayMessage:
   define input parameter ipMsgNum as integer no-undo.
   define input parameter ipLevel  as integer no-undo.
   define input parameter ipMsg1   as character no-undo.

   {pxmsg.i &MSGNUM = ipMsgNum
            &ERRORLEVEL = ipLevel
            &MSGARG1    = ipMsg1}
END PROCEDURE.

PROCEDURE p_InitializeTempTableWorkLdd:
   for each work_ldd
      exclusive-lock:
      delete work_ldd.
   end. /* FOR EACH work_ldd */
END PROCEDURE. /* p_InitializeTempTableWorkLdd */


PROCEDURE p_PostFreightForLogAcctg:

   if use-log-acctg
      and l_calc_freight
      and tot_freight_gl_amt <> 0
   then do:

      /* IF LOGISTICS ACCOUNTING IS ENABLED THEN CREATE PENDING VOUCHER */
      /* MASTER AND DETAIL RECORDS AND POST THE FREIGHT TO THE GL.      */
      {gprunmo.i &module  = "LA" &program = "lafrpst.p"
                 &param   = """(input '{&TYPE_SOShipper}',
                                input substring(abs_mstr.abs_id,2),
                                input substring(abs__qad01,41,20), /*EXT-RF*/
                                input abs_mstr.abs_shp_date,
                                input eff_date,
                                input abs_mstr.abs_shipto,   /* SHIP-TO */
                                input '{&TYPE_SO}',
                                input first_so_curr,
                                input first_so_ex_rate,
                                input first_so_ex_rate2,
                                input ' ',  /* BLANK PVO_EX_RATETYPE */
                                input first_so_exru_seq)"""}

   end. /* IF USE-LOG-ACCTG AND ... */
END PROCEDURE. /*    p_PostFreightForLogAcctg */

PROCEDURE getControlFiles:

   define        parameter buffer gl_ctrl              for gl_ctrl.
   define        parameter buffer shc_ctrl             for shc_ctrl.
   define input  parameter enable_customer_consignment as character no-undo.
   define input  parameter adg                         as character no-undo.
   define input  parameter cust_consign_ctrl_table     as character no-undo.
   define output parameter use-log-acctg               as logical   no-undo.
   define output parameter using_cust_consignment      as logical   no-undo.
   define output parameter auto_post                   as logical   no-undo.
   define output parameter use_shipper                 as logical   no-undo.
   define output parameter consolidate                 as logical   no-undo.

   /* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
   {gprun.i ""lactrl.p"" "(output use-log-acctg)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   for first gl_ctrl
      fields (gl_base_curr gl_rnd_mthd)
   no-lock: end.

   /* CREATE SHIPPER CONTROL IF NOT FOUND */
   {gprun.i ""socrshc.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


   for first shc_ctrl
      fields (shc_ship_nr_id shc_trl_amts)
   no-lock: end.

   /* CREATE rcc_ctrl FILE RECORDS IF NECESSARY */
   {gprun.i ""rcpma.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


   /* DETERMINE IF CUSTOMER CONSIGNMENT IS ACTIVE */
   {gprun.i ""gpmfc01.p""
      "(input ENABLE_CUSTOMER_CONSIGNMENT,
        input 10,
        input ADG,
        input CUST_CONSIGN_CTRL_TABLE,
        output using_cust_consignment)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   /* FIND mfc_ctrl RECORDS FOR rcc_variables */
   for first mfc_ctrl
      fields (mfc_field mfc_logical)
      where mfc_field = "rcc_auto_post"
   no-lock:
      auto_post = mfc_logical.
   end. /* FOR FIRST MFC_CTRL */

   for first mfc_ctrl
      fields (mfc_field mfc_logical)
      where mfc_field = "rcc_use_shipper"
   no-lock:
      use_shipper = mfc_logical.
   end. /* FOR FIRST MFC_CTRL */

   for first mfc_ctrl
      fields (mfc_field mfc_logical)
      where mfc_field = "rcc_consolidate"
   no-lock:
      consolidate = mfc_logical.
   end. /* FOR FIRST MFC_CTRL */

END PROCEDURE.   /* getControlFiles */

PROCEDURE createImpExpHist:

   define parameter buffer sod_det for sod_det.
   define input parameter sod_qty_chg like sod_qty_chg no-undo.
   define input parameter eff_date as date no-undo.

   if can-find(iec_ctrl where iec_use_instat = yes) then do:

      /* CREATE IMPORT EXPORT HISTORY RECORD */
      {gprun.i ""iehistso.p"" "(buffer sod_det,
                                input sod_qty_chg,
                                input eff_date,
                                input ""SHIP"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end.

END PROCEDURE.   /* createImpExpHist */

PROCEDURE woValidate:

   define input  parameter ip_sod_lot    like sod_lot     no-undo.
   define input  parameter ip_sod_fa_nbr like sod_fa_nbr  no-undo.
   define output parameter op_wo_reject  like mfc_logical no-undo.

   op_wo_reject = no.

   if ip_sod_lot <> ""
   then do:

      for first wo_mstr
         fields (wo_nbr wo_lot wo_status)
         where wo_lot = ip_sod_lot
         no-lock:
      end. /* FOR FIRST wo_mstr */

      if available wo_mstr
         and lookup(wo_status, "A,R,C") = 0
      then
         op_wo_reject = yes.

   end. /* IF ip_sod_lot <> "" */

   else do:

      if ip_sod_fa_nbr <> ""
      then do:

         for first wo_mstr
            fields (wo_nbr wo_status)
            where wo_nbr                   = ip_sod_fa_nbr
            and lookup(wo_status, "A,R,C") = 0
         no-lock:
         end. /* FOR FIRST wo_mstr */

         if available wo_mstr
         then
            op_wo_reject = yes.

      end. /* IF ip_sod_fa_nbr <> "" */

   end. /* ELSE */

   if op_wo_reject = yes
   then do:

      /* WORK ORDER ID IS CLOSED, PLANNED OR */
      /* FIRM PLANNED                        */
      run DisplayMessage (input 523,
                          input 4,
                          input ":" + wo_nbr).

      /* CURRENT WORK ORDER STATUS: */
      run DisplayMessage (input 525,
                          input 1,
                          input wo_status).

   end. /* IF op_wo_reject = yes */

END PROCEDURE.   /* woReject */

PROCEDURE CheckWOAndCMF:

   define input        parameter ip_abs_order like abs_order   no-undo.
   define input        parameter ip_abs_line  like abs_line    no-undo.
   define output       parameter op_wo_reject like mfc_logical no-undo.
   define output       parameter op_undo_var  like mfc_logical no-undo.
   define input-output parameter io_que-doc   like mfc_logical no-undo.

   define variable               l_woreject   like mfc_logical no-undo.

   assign op_wo_reject = no
          op_undo_var  = no.

   for first so_mstr
      fields (so_bill so_cr_terms so_curr so_cust so_disc_pct
              so_exru_seq so_ex_rate so_ex_rate2 so_ex_ratetype
              so_fix_rate so_fr_terms so_invoiced so_inv_mthd
              so_inv_nbr so_nbr so_pst_pct so_quote
              so_secondary so_ship_date so_site so_slspsn
              so_stat so_tax_date so_tax_pct so_to_inv
              so_trl1_amt so_trl1_cd so_trl2_amt so_trl2_cd
              so_trl3_amt so_trl3_cd so_bol so__qadc01)
      where so_nbr   = ip_abs_order
      no-lock:
   end. /* FOR FIRST so_mstr */

   for first sod_det
      fields (sod_btb_po sod_cum_qty sod_fsm_type sod_line
              sod_list_pr sod_nbr sod_part sod_price sod_pr_list
              sod_qty_chg sod_sched sod_site sod_std_cost
              sod_taxc sod_um sod_um_conv sod_lot sod_fa_nbr)
      where sod_nbr  = ip_abs_order
        and sod_line = integer(ip_abs_line)
      no-lock:
   end. /* FOR FIRST sod_det */

   /* CHECK IF WORK ORDER IS RELEASED OR ALLOCATED */
   /* FOR ATO CONFIGURED ITEMS                     */

   if available sod_det
   then do:

      /* CHECK WO STATUS */
      run woValidate (input sod_lot,
                      input sod_fa_nbr,
                      output l_woreject).

      if l_woreject = yes
      then do:
         op_wo_reject = yes.
         return.
      end. /* IF l_woreject = yes */

   end. /* IF AVAILABLE sod_det */

   if available so_mstr
      and available sod_det
   then
      if not so_secondary
   then
      for first cmf_mstr
         fields (cmf_doc_ref cmf_doc_type cmf_status cmf_trans_nbr)
         where cmf_doc_type = "PO"
           and cmf_doc_ref  = sod_btb_po
           and (cmf_status   = "1" or
                cmf_status   = "2" or
                cmf_status   = "3"   )
         no-lock:
      end. /* FOR FIRST cmf_mstr */

   else do:

      for first cmf_mstr
         fields (cmf_doc_ref cmf_doc_type cmf_status cmf_trans_nbr)
         where cmf_doc_type = "SO"
           and cmf_doc_ref  = so_nbr
           and cmf_status   = "1"
         no-lock:

         for first cmd_det
            fields (cmd_field cmd_key_val cmd_trans_nbr)
            where cmd_trans_nbr = cmf_trans_nbr
              and cmd_key_val   = so_nbr + "," + string(sod_line)
              and (cmd_field    = "sod_due_date" or
                   cmd_field    = "sod_qty_ord" )
            no-lock:
            change-queued = yes.
         end. /* FOR FIRST cmd_det */

      end. /* FOR FIRST cmf_mstr */

   end. /* ELSE */

   if available so_mstr
      and ((not so_secondary
      and available cmf_mstr ) or
      (so_secondary and change-queued ))
   then do:

      /* CHANGE ON EMT SO WITH PENDING CHANGE IS NOT ALLOWED */
      run DisplayMessage (input 2834,
                          input 3,
                          input '').
      op_undo_var  = yes.
      return.

   end. /* IF AVAILABLE so_mstr */

   /* THIS IS THE NORMAL SHIPMENT OF A SALES ORDER THUS */
   /* WE ONLY QUEUE A DOCUMENT IF THIS IS THE SECONDARY */
   /* SO BECAUSE FOR THE PRIMARY SO THIS CORRESPONDS TO */
   /* THE SHIPMENT OF A NORMAL SO AND NO DOCUMENT WILL  */
   /* BE QUEUED.                                        */

   /* THIS IS DIFFERENT IN THE PROGRAM rcsois2.p !!!!!!! */
   if available so_mstr
      and so_secondary
      and not io_que-doc
   then
      io_que-doc = yes.

END PROCEDURE. /* CheckWOAndCMF */

/* TO GET FREIGHT TYPE */
PROCEDURE get_freight_type:
   define input  parameter p_fr_terms     like so_fr_terms.
   define output parameter p_old_ft_type  as   character.

   /*CALCULATE FREIGHT CHARGES*/
   for first ft_mstr
      fields (ft_terms ft_type)
      where ft_terms = p_fr_terms
      no-lock:
      p_old_ft_type = ft_type.
   end. /* FOR FIRST FT_MSTR */
END PROCEDURE. /* PROCEDURE getfrtype */

PROCEDURE p_undo_records:
   define parameter buffer tt_so_mstr   for tt_so_mstr.
   define input  parameter p_txcalcref  like tx2d_ref no-undo.

   /* DELETE THE tx2d_det RECORDS IN CASE OF AN ERROR  WHEN THE TYPE */
   /* IS SO SHIPPER MAINTENANCE AND RESET sod_qty_chg TO ZERO        */

   for each tx2d_det exclusive-lock
      where tx2d_ref     = p_txcalcref
      and   tx2d_tr_type = "14":

      /* RESET THE so_mstr FIELDS IN CASE OF AN ERROR */
      find first so_mstr
         where so_nbr = tx2d_nbr
         exclusive-lock.
      if available so_mstr
      then do:

         for first tt_so_mstr
            where tt_so_mstr.tt_so_nbr = so_nbr no-lock:
            assign
               so_to_inv    = tt_so_mstr.tt_so_to_inv
               so_invoiced  = tt_so_mstr.tt_so_invoiced
               so_ship_date = tt_so_mstr.tt_so_ship_date
               so_tax_date  = tt_so_mstr.tt_so_tax_date
               so_bol       = tt_so_mstr.tt_so_bol
               so__qadc01   = tt_so_mstr.tt_so__qadc01.
         end. /* for first tt_so_mstr */

      end. /* if available so_mstr */
      release so_mstr.

      for each sod_det exclusive-lock
         where sod_nbr = tx2d_nbr
         and  (sod_line   = tx2d_line
         or    tx2d_line  = 0):
/*GUI*/ if global-beam-me-up then undo, leave.


         sod_qty_chg = 0.

         {gprun.i ""txcalc.p""
            "(input  '13',
              input  sod_nbr,
              input  '',
              input  if tx2d_line = 0
                     then
                        0
                     else
                        sod_line,
              input  no,
              output return_status)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH sod_det */

      delete tx2d_det.

   end. /* FOR EACH tx2d_det */

END PROCEDURE. /* PROCEDURE p_undo_records */

{sotoinv.i}

PROCEDURE DisplayMessage1:
   define input        parameter pMsgNum   as   integer     no-undo.
   define input        parameter pLevel    as   integer     no-undo.
   define input-output parameter pconfirm  like mfc_logical no-undo.

   {pxmsg.i &MSGNUM=pmsgnum
            &ERRORLEVEL=plevel
            &CONFIRM=pconfirm}
END PROCEDURE.
