/* xxsoivmtea.p - PENDING INVOICE MAINTENANCE                                   */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.93.3.3 $                                                        */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED: 03/14/90   BY: emb *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 03/21/90   BY: ftb *D011*                */
/* REVISION: 6.0      LAST MODIFIED: 04/05/90   BY: ftb *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 05/02/90   BY: MLB *D021*                */
/* REVISION: 6.0      LAST MODIFIED: 08/09/90   BY: MLB *D055*                */
/* REVISION: 6.0      LAST MODIFIED: 11/01/90   BY: MLB *D148*                */
/* REVISION: 6.0      LAST MODIFIED: 12/28/90   BY: afs *D277*                */
/* REVISION: 6.0      LAST MODIFIED: 02/13/91   BY: afs *D348*                */
/* REVISION: 6.0      LAST MODIFIED: 02/20/91   BY: afs *D356*                */
/* REVISION: 6.0      LAST MODIFIED: 07/07/91   BY: afs *D747*                */
/* REVISION: 6.0      LAST MODIFIED: 07/08/91   BY: afs *D751*                */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*                */
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 01/13/92   BY: afs *F042*                */
/* REVISION: 7.0      LAST MODIFIED: 02/26/92   BY: afs *F240*                */
/* REVISION: 7.0      LAST MODIFIED: 03/24/92   BY: dld *F297*                */
/* REVISION: 7.0      LAST MODIFIED: 04/01/92   BY: afs *F344*                */
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: afs *F356*                */
/* REVISION: 7.0      LAST MODIFIED: 04/30/92   BY: tjs *F463*                */
/* REVISION: 7.0      LAST MODIFIED: 05/06/92   BY: tjs *F470*                */
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: afs *F519*                */
/* REVISION: 7.0      LAST MODIFIED: 06/26/92   BY: afs *F711*                */
/* REVISION: 7.0      LAST MODIFIED: 07/09/92   BY: tjs *F739*                */
/* REVISION: 7.0      LAST MODIFIED: 07/27/92   BY: tjs *F765*                */
/* REVISION: 7.0      LAST MODIFIED: 07/29/92   BY: tjs *F802*                */
/* REVISION: 7.3      LAST MODIFIED: 09/17/92   BY: tjs *G035*                */
/* REVISION: 7.3      LAST MODIFIED: 09/30/92   BY: tjs *G112*                */
/* REVISION: 7.3      LAST MODIFIED: 10/28/92   BY: afs *G244*                */
/* REVISION: 7.3      LAST MODIFIED: 01/13/93   BY: tjs *G507*                */
/* REVISION: 7.3      LAST MODIFIED: 01/13/93   BY: tjs *G530*                */
/* REVISION: 7.3      LAST MODIFIED: 01/15/93   BY: afs *G501*                */
/* REVISION: 7.3      LAST MODIFIED: 01/26/93   BY: bcm *G429*                */
/* REVISION: 7.3      LAST MODIFIED: 02/11/93   BY: bcm *G416*                */
/* REVISION: 7.3      LAST MODIFIED: 02/18/93   BY: afs *G692*                */
/* REVISION: 7.3      LAST MODIFIED: 04/05/93   BY: bcm *G889*                */
/* REVISION: 7.3      LAST MODIFIED: 04/23/93   BY: wug *GA26*                */
/* REVISION: 7.3      LAST MODIFIED: 05/14/93   BY: wug *GB10*                */
/* REVISION: 7.3      LAST MODIFIED: 05/20/93   BY: kgs *GB18*                */
/* REVISION: 7.4      LAST MODIFIED: 06/16/93   BY: bcm *H002*                */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*                */
/* REVISION: 7.4      LAST MODIFIED: 09/29/93   BY: cdt *H086*                */
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184*                */
/* REVISION: 7.4      LAST MODIFIED: 01/13/94   BY: dpm *GI47*                */
/* REVISION: 7.4      LAST MODIFIED: 02/18/94   BY: afs *FL81*                */
/* REVISION: 7.4      LAST MODIFIED: 03/10/94   BY: cdt *H294*                */
/* REVISION: 7.4      LAST MODIFIED: 03/16/94   BY: afs *H295*                */
/* REVISION: 7.4      LAST MODIFIED: 05/19/94   BY: afs *GJ90*                */
/* REVISION: 7.4      LAST MODIFIED: 07/18/94   BY: bcm *H443*                */
/* REVISION: 7.4      LAST MODIFIED: 07/22/94   BY: bcm *H451*                */
/* REVISION: 7.4      LAST MODIFIED: 08/09/94   BY: bcm *H476*                */
/* REVISION: 7.4      LAST MODIFIED: 08/29/94   BY: bcm *H494*                */
/* REVISION: 7.4      LAST MODIFIED: 09/09/94   BY: afs *H510*                */
/* REVISION: 7.4      LAST MODIFIED: 09/26/94   BY: rxm *FR48*                */
/* REVISION: 7.4      LAST MODIFIED: 10/06/94   BY: dpm *FR89*                */
/* REVISION: 7.4      LAST MODIFIED: 10/16/94   BY: dpm *FR95*                */
/* REVISION: 7.4      LAST MODIFIED: 10/21/94   BY: rmh *FQ08*                */
/* REVISION: 7.4      LAST MODIFIED: 11/02/94   BY: rxm *FT18*                */
/* REVISION: 7.4      LAST MODIFIED: 11/07/94   BY: ljm *GO33*                */
/* REVISION: 8.5      LAST MODIFIED: 12/04/94   BY: mwd *J034*                */
/* REVISION: 8.5      LAST MODIFIED: 12/12/94   BY: dpm *FT84*                */
/* REVISION: 8.5      LAST MODIFIED: 01/14/95   BY: dpm *F0DR*                */
/* REVISION: 8.5      LAST MODIFIED: 03/14/95   BY: rxm *G0H7*                */
/* REVISION: 8.5      LAST MODIFIED: 04/20/95   BY: dah *J042*                */
/* REVISION: 8.5      LAST MODIFIED: 07/11/95   BY: dah *J05G*                */
/* REVISION: 8.5      LAST MODIFIED: 08/14/95   BY: dah *J063*                */
/* REVISION: 8.5      LAST MODIFIED: 09/10/95   BY: dah *J07R*                */
/* REVISION: 8.5      LAST MODIFIED: 10/06/95   BY: dah *J08H*                */
/* REVISION: 8.5      LAST MODIFIED: 05/31/95   BY: kjm *G0NP*                */
/* REVISION: 8.5      LAST MODIFIED: 08/24/95   BY: jym *G0TW*                */
/* REVISION: 8.5      LAST MODIFIED: 08/30/95   BY: jym *G0VQ*                */
/* REVISION: 8.5      LAST MODIFIED: 11/13/95   BY: ais *H0GK*                */
/* REVISION: 8.5      LAST MODIFIED: 12/07/95   BY: rxm *H0FS*                */
/* REVISION: 8.5      LAST MODIFIED: 11/22/95   BY: ais *H0H2*                */
/* REVISION: 8.5      LAST MODIFIED: 11/07/95   BY: taf *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 03/11/96   BY: wjk *J0DV*                */
/* REVISION: 8.5      LAST MODIFIED: 04/03/96   BY: DAH *J0GT*                */
/* REVISION: 8.5      LAST MODIFIED: 04/12/96   BY: DAH *J0HR*                */
/* REVISION: 8.5      LAST MODIFIED: 04/17/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 04/17/96   BY: *J04C* Markus Barone      */
/* REVISION: 8.5      LAST MODIFIED: 05/02/96   BY: *J0KJ* Dennis Henson      */
/* REVISION: 8.5      LAST MODIFIED: 05/07/96   BY: *J0LL* Dennis Henson      */
/* REVISION: 8.5      LAST MODIFIED: 05/31/96   BY: *J0N2* Dennis Henson      */
/* REVISION: 8.5      LAST MODIFIED: 06/21/96   BY: *G1V1* Tony Patel         */
/* REVISION: 8.5      LAST MODIFIED: 07/02/96   BY: *J0XG* Dennis Henson      */
/* REVISION: 8.5      LAST MODIFIED: 07/04/96   BY: *J0XR* Dennis Henson      */
/* REVISION: 8.5      LAST MODIFIED: 07/12/96   BY: ajw *J0Y5*                */
/* REVISION: 8.5      LAST MODIFIED: 07/16/96   BY: ajw *J0Z6*                */
/* REVISION: 8.5      LAST MODIFIED: 07/24/96   BY: *H0M4* Suresh Nayak       */
/* REVISION: 8.5      LAST MODIFIED: 08/01/96   BY: *J12Q* Andy Wasilczuk     */
/* REVISION: 8.6      LAST MODIFIED: 10/01/96   BY: svs *K007*                */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Kurt De Wit        */
/* REVISION: 8.6      LAST MODIFIED: 11/07/96   BY: *K01W* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 12/30/96   BY: *K03Y* Jean Miller        */
/* REVISION: 8.6      LAST MODIFIED: 01/08/97   BY: *J1CR* Sue Poland         */
/* REVISION: 8.6      LAST MODIFIED: 02/07/97   BY: *J1DV* Sue Poland         */
/* REVISION: 8.6      LAST MODIFIED: 03/04/97   BY: *J1JV* Jim Williams       */
/* REVISION: 8.6      LAST MODIFIED: 04/08/97   BY: *J1N4* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 05/15/97   BY: *H0Z4* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 06/30/97   BY: *K0FL* Taek-Soo Chang     */
/* REVISION: 8.6      LAST MODIFIED: 07/07/97   BY: *K0DT* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 07/13/97   BY: *K0DH* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 07/21/97   BY: *H0ZJ* Samir Bavkar       */
/* REVISION: 8.6      LAST MODIFIED: 07/27/97   BY: *J1WN* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 08/06/97   BY: *J1YG* Seema Varma        */
/* REVISION: 8.6      LAST MODIFIED: 08/12/97   BY: *J1YL* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 09/05/97   BY: *J1XW* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 09/02/97   BY: *K0HQ* Jim Williams       */
/* REVISION: 8.6      LAST MODIFIED: 09/24/97   BY: *K0JL* Jean Miller        */
/* REVISION: 8.6      LAST MODIFIED: 10/06/97   BY: *K0KJ* Joe Gawel          */
/* REVISION: 8.6      LAST MODIFIED: 10/21/97   BY: *J236* Manish K.          */
/* REVISION: 8.6      LAST MODIFIED: 10/23/97   BY: *J23M* Niranjan R.        */
/* REVISION: 8.6      LAST MODIFIED: 11/12/97   BY: *H1FB* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 11/12/97   BY: *H1GC* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 11/18/97   BY: *J25B* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 01/14/98   BY: *J29X* Seema Varma        */
/* REVISION: 8.6      LAST MODIFIED: 01/16/98   BY: *J25N* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 01/29/98   BY: *K1FT* Jim Williams       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 03/23/98   BY: *H1HQ* Niranjan R.        */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 06/03/98   BY: *J2JZ* A. Licha           */
/* REVISION: 8.6E     LAST MODIFIED: 06/06/98   BY: *J2JJ* Niranjan R.        */
/* REVISION: 8.6E     LAST MODIFIED: 07/07/98   BY: *L024* Sami Kureishy      */
/* REVISION: 8.6E     LAST MODIFIED: 08/05/98   BY: *J2VF* Seema Varma        */
/* REVISION: 8.6E     LAST MODIFIED: 08/20/98   BY: *L06M* Russ Witt          */
/* REVISION: 8.6E     LAST MODIFIED: 09/04/98   BY: *J2X8* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 11/11/98   BY: *M00R* Sue Poland         */
/* REVISION: 9.0      LAST MODIFIED: 11/17/98   BY: *H1LN* Poonam Bahl        */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* Luke Pokic         */
/* REVISION: 9.0      LAST MODIFIED: 01/13/99   BY: *J37J* Niranjan R.        */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 07/22/99   BY: *J3JM* Kedar Deherkar     */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney     */
/* REVISION: 9.1      LAST MODIFIED: 08/06/99   BY: *K21Z* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 08/10/99   BY: *J3K7* Surekha Joshi      */
/* REVISION: 9.1      LAST MODIFIED: 08/27/99   BY: *J3KT* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 09/08/99   BY: *N02P* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 10/19/99   BY: *N049* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 12/28/99   BY: *L0MP* Surekha joshi      */
/* REVISION: 9.1      LAST MODIFIED: 03/17/00   BY: *N08S* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *N0RF* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/13/00   BY: *L119* Kaustubh K.        */
/* REVISION: 9.1      LAST MODIFIED: 07/17/00   BY: *L124* Nikita Joshi       */
/* REVISION: 9.1      LAST MODIFIED: 12/18/00   BY: *M0TZ* Veena Lad          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.72       BY: Russ Witt         DATE: 06/01/01  ECO: *P00J*     */
/* Revision: 1.73       BY: Jean Miller       DATE: 08/08/01  ECO: *M11Z*     */
/* Revision: 1.74       BY: Nikita Joshi      DATE: 08/20/01  ECO: *L16Z*     */
/* Revision: 1.75       BY: Russ Witt         DATE: 10/17/01  ECO: *P021*     */
/* Revision: 1.76       BY: Steve Nugent      DATE: 10/22/01  ECO: *P004*     */
/* Revision: 1.77       BY: Vivek Dsilva      DATE: 12/18/01  ECO: *M1RY*     */
/* Revision: 1.78       BY: Rajiv Ramaiah     DATE: 01/04/02  ECO: *M1SX*     */
/* Revision: 1.79       BY: Vandna Rohira     DATE: 02/28/02  ECO: *M1W6*     */
/* Revision: 1.81       BY: Santhosh Nair     DATE: 03/06/02  ECO: *M1H1*     */
/* Revision: 1.85       BY: Ellen Borden      DATE: 11/02/01  ECO: *P00G*     */
/* Revision: 1.86       BY: Anitha Gopal      DATE: 03/15/02  ECO: *M1WM*     */
/* Revision: 1.87       BY: Ashish M.         DATE: 05/20/02  ECO: *P04J*     */
/* Revision: 1.88       BY: Ashish K.         DATE: 05/24/02  ECO: *N1JR*     */
/* Revision: 1.89       BY: Manisha Sawant    DATE: 06/17/02  ECO: *N1LB*     */
/* Revision: 1.90       BY: Ashwini G.        DATE: 06/18/02  ECO: *M1ZF*     */
/* Revision: 1.91       BY: Veena Lad         DATE: 06/26/02  ECO: *N1M4*     */
/* Revision: 1.92       BY: Russ Witt    DATE: 07/29/02  ECO: *P0CF*     */
/* Revision: 1.93       BY: Wojciech Palczynski DATE: 12/17/02 ECO: *P0LB*    */
/* Revision: 1.93.3.1   BY: Mercy Chittilapilly DATE: 06/05/03 ECO: *N2DJ*    */
/* Revision: 1.93.3.2   BY: Santosh Rao         DATE: 06/25/03 ECO: *N2HN* */
/* $Revision: 1.93.3.3 $   BY: Dorota Hohol      DATE: 09/03/03 ECO: *P0ZL* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
    *J0KJ* Applies v8.5 pricing to RMA issue lines.  The use of sod_fsm_type
           <> "RMA-RCT" will appear wherever a v8.5 pricing function will occur.
           This supports both Sales Orders and RMA issue lines.  Where a
           coverage discount applies, it will be treated as a "manual" discount
           for the sake of price list history and any resultant calculation.

           RMA receipt lines will use pre v8.5 pricing functions.  A credit
           price list will be used to determine pricing along with any
           applicable restocking charge.  No price list history will be
           created. Any discount information required by the G/L posting
           routine sosoglb.p will be derived from the sales order line.

           SPECIAL NOTE: QAD FIELD sod__qadd01 IS BEING USED TO CONTAIN
                         THE COVERAGE DISCOUNT WHEN A RMA ISSUE LINE IS
                         INVOLVED.  IT WILL CONTAIN A VALUE ONLY WHEN
                         THE "MANUAL" DISCOUNT IS DUE TO THE COVERAGE
                         DISCOUNT, OTHERWISE IT WILL BE 0.
*/

/* ********** Begin Translatable Strings Definitions ********* */

{mfdeclre.i} /*GUI moved to top.*/
&SCOPED-DEFINE soivmtea_p_1 "Qty Allocatable"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmtea_p_2 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmtea_p_4 "Line Pricing"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmtea_p_6 "Salesperson 2"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmtea_p_7 "Salesperson 3"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmtea_p_8 "Salesperson 1"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmtea_p_9 "Salesperson 4"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* ROUTINES FOR PRICE TABLE LOOKUP, MIN/MAX PRICE VIOLATION  */
/* CHECKS AND PRICING HISTORY CREATION ARE SKIPPED FOR       */
/* RETROBILLED ITEMS                                         */

/*DEFINE GLOBAL VARIABLES*/

/*GUI moved mfdeclre/mfdtitle.*/

{cxcustom.i "SOIVMTEA.P"}

{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* DEFINE RNDMTHD FOR CALL TO GPFRLWT.P */
define shared variable rndmthd like rnd_rnd_mthd.
define shared variable line like sod_line.
define shared variable del-yn like mfc_logical.
define shared variable prev_due like sod_due_date.
define shared variable prev_qty_ord like sod_qty_ord.
define shared variable prev_consume like sod_consume.
define new shared variable desc1 like pt_desc1.
define new shared variable sod-detail-all like soc_det_all.
define shared variable pcqty like sod_qty_ord.
define new shared variable cmtindx like cmt_indx.
define shared variable sodcmmts like soc_lcmmts label {&soivmtea_p_2}.
define shared variable amd as character.
define shared variable undo_all like mfc_logical initial no.
define shared variable so_recno as recid.
define shared variable sod_recno as recid.
define shared frame c.
define shared frame d.
define variable old_list_pr like sod_list_pr.
define variable old_disc like sod_disc_pct.
define shared variable clines as integer.
define shared variable ln_fmt like soc_ln_fmt.
define variable qty_allocatable like in_qty_avail label
   {&soivmtea_p_1}.
define new shared variable undo_all2 like mfc_logical.
define new shared variable undo_bon  like mfc_logical.
define shared variable mult_slspsn like mfc_logical no-undo.
define variable sort as character format "x(28)" extent 4 no-undo.
define variable counter as integer no-undo.
define new shared variable prev_qty_chg like sod_qty_chg.
define new shared variable prev_price  like sod_price no-undo.
define new shared variable prev_listpr like sod_list_pr no-undo.
define shared variable new_line like mfc_logical.
define new shared variable tax_date like tax_effdate no-undo.
define new shared variable err_stat as integer.
define new shared variable new_site like sod_site.
define variable yn like mfc_logical.
define new shared variable old_site        like sod_site.
define variable zone_to                    like txz_tax_zone.
define variable zone_from                  like txz_tax_zone.
define variable tax_usage                  like so_tax_usage no-undo.
define variable tax_env                    like so_tax_env no-undo.
define new shared variable old_sod_site    like sod_site no-undo.
define new shared variable match_pt_um     like mfc_logical.
define            variable vtclass         as character extent 3.
define            buffer   sod_buff        for sod_det.
define            variable j               as integer.
define new shared variable undo_mta2       as logical.
define new shared variable inv_data_changed like mfc_logical.
define     shared variable freight_ok      like mfc_logical.
define     shared variable old_ft_type     like ft_type.
define     shared variable calc_fr         like mfc_logical.
define     shared variable disp_fr         like mfc_logical.
define            variable detqty          like sod_qty_ord.
define            variable minprice        like pc_min_price.
define            variable maxprice        like pc_min_price.
define            variable lineffdate      like so_due_date.
define            variable warning         like mfc_logical initial no.
define            variable warmess         like mfc_logical initial yes.
define            variable minmaxerr       like mfc_logical.
define     shared variable soc_pc_line     like mfc_logical.
define            variable pc_recno        as recid.
define new shared variable soc_pt_req      like mfc_logical.
define            variable old_db   like dc_name.
define            variable new_db   like dc_name.
define shared variable so_db like dc_name.
define shared variable lotser like sod_serial.
define shared variable lotrf like sr_ref.
define variable chg-db  as logical.
define variable err-flag as integer.
define variable l_err_msg as  character  no-undo.
define variable l_retrobill like mfc_logical no-undo.
define new shared variable remote-base-curr like gl_base_curr.
define shared variable  exch-rate like exr_rate.
define shared variable  exch-rate2 like exr_rate2.
define            variable restock-pct like rma_rstk_pct no-undo.
define            variable old_price   like sod_price no-undo.
define     shared variable trtotqty like tr_qty_chg no-undo.
define     shared variable noentries as integer no-undo.
define            variable sobparent        like sob_parent.
define            variable sobfeature       like sob_feature.
define            variable sobpart          like sob_part.
define     shared variable new_order        like mfc_logical.
define new shared variable pics_type        like pi_cs_type  initial "9".
define new shared variable part_type        like pi_part_type initial "6".
define     shared variable picust           like cm_addr.
define            variable err_flag         as integer.
define            variable save_qty_ord     like sod_qty_ord.
define            variable save_um          like sod_um.
define            variable save_disc_pct    as decimal.
define            variable new_disc_pct     as decimal.
define            variable umconv           like sod_um_conv.
define     shared variable discount         as decimal.
define     shared variable reprice          like mfc_logical.
define     shared variable reprice_dtl      like mfc_logical.
define            variable minerr           like mfc_logical.
define            variable maxerr           like mfc_logical.
define            variable man_disc_pct     as decimal.
define            variable sys_disc_fact    as decimal.
define            variable rfact            as integer.
define            variable minmax_occurred  like mfc_logical initial no no-undo.
define     shared variable save_parent_list like sod_list_pr.
define            variable last_sod_price   like sod_price.
define            variable coverage-discount like sod_disc_pct.
define            variable rma-recno        as recid.
define            variable rmd-recno        as recid.
define            variable disc_min_max     like mfc_logical.
define            variable disc_pct_err     as decimal format "->>>>,>>>,>>9.9<<<".
define            variable pm_code like pt_pm_code.
define new shared variable wk_bs_line  like pih_bonus_line no-undo.
define new shared variable wk_bs_promo as character format "x(8)" no-undo.
define new shared variable wk_bs_price as decimal format ">>>>>>9.99" no-undo.
define new shared variable wk_bs_listid like pih_list_id no-undo.
define            variable prev_bo_chg      like sod_bo_chg.
define            variable p-so-nbr         like sod_nbr.
define            variable p-sod-line       like sod_line.
define            variable p-po-nbr         like sod_btb_po.
define            variable p-pod-line       like sod_btb_pod_line.

define            variable return-to-remove-isb as logical no-undo.
define            variable this_is_edi like mfc_logical initial no.
define     shared variable line_pricing like pic_so_linpri label {&soivmtea_p_4}.
define            variable last_list_price    like sod_list_pr no-undo.

define variable shipper_found as integer no-undo.
define variable save_abs like abs_par_id no-undo.
define output parameter return-msg  like msg_nbr initial 0 no-undo.
define variable sodstdcost like sod_std_cost no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable error_flag as logical no-undo.
define variable l_prev_um_conv like sod_um_conv no-undo.
define variable l_prev_um      like sod_um      no-undo.
define variable l_conf_ship    as   integer     no-undo.
define variable l_conf_shid    like abs_par_id  no-undo.
define variable l_undotran     like mfc_logical no-undo.
define variable l_undoln       like mfc_logical no-undo.
define variable l_flag         like mfc_logical no-undo.
define new shared variable resv-loc-ordtype as character   no-undo.
define new shared variable resv-loc-ordnbr  like so_nbr    no-undo.
define new shared variable resv-loc-ship   like so_ship     no-undo.
define new shared variable resv-loc-bill   like so_bill     no-undo.
define new shared variable resv-loc-cust   like so_cust     no-undo.
define new shared variable resv-loc-fsm-type like so_fsm_type no-undo.
define variable cust-resv-loc   like locc_loc              no-undo.
define variable useloc          like mfc_logical           no-undo.
define variable emt-bu-lvl    like global_part no-undo.
define variable save_part     like global_part no-undo.
define variable l_sod_list_pr like sod_list_pr no-undo.
define variable l_sod_price   like sod_price   no-undo.
define variable l_code        like qad_key1    no-undo.

/*xx*/  DEFINE VARIABLE copper_rate LIKE sod_price .

define stream listprice.

/*THIS TEMP TABLE IS CREATED TO CALCULATE FREIGHT CHARGES  */
/*WHEN A NEW SALES ORDER LINE IS ADDED TO AN EXISTING ORDER*/
/*WHEN THE FREIGHT TYPE IS "INCLUDE".                      */
define shared temp-table  l_fr_table
       field l_fr_sonbr   like sod_nbr
       field l_fr_soline  like sod_line
       field l_fr_chrg    like sod_fr_chg
       field l_sodlist_pr like sod_list_pr
       index nbrline is primary l_fr_sonbr l_fr_soline.

/* Logistics Table definitions */
{lgivdefs.i &type="lg"}

{pppiwkpi.i "new"} /*Shared pricing workfile*/
{pppivar.i}        /*Shared pricing variables*/
{pppiwqty.i}       /*REPRICE WORKFILE DEFINITION*/

/* DEFINE VARIABLES USED IN GPGLEF1.P (GL CALENDAR VALIDATION) */
{gpglefv.i}

{gptxcdec.i}    /* DECLARATIONS FOR gptxcval.i */

/*DEFINE FORMS C AND D*/
/*V8:HiddenDownFrame=c*/
{xxsoivlnfm.i}

/* CONSIGNMENT VARIABLES */
define variable l_consigned_line_item like mfc_logical no-undo.
{socnvars.i}

{&SOIVMTEA-P-TAG1}

/* CONSIGNMENT MESSAGING PROGRAM */
{gpcnmsg.i}

/* CHECK TO SEE IF CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_CUSTOMER_CONSIGNMENT,
     input 10,
     input ADG,
     input CUST_CONSIGN_CTRL_TABLE,
     output using_cust_consignment)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      hide frame d no-pause.   

if execname = "rcrbrp01.p" then
   l_retrobill = yes.

find first gl_ctrl no-lock.

/* Read price table required flag from mfc_ctrl */
find first mfc_ctrl where mfc_field = "soc_pt_req" no-lock no-error.
if available mfc_ctrl then soc_pt_req = mfc_logical.

undo_all = yes.

loopc:
do on error undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


   view frame c.
   if ln_fmt then view frame d.

   find so_mstr where recid(so_mstr) = so_recno.
   find sod_det where recid(sod_det) = sod_recno.
   find first soc_ctrl no-lock.

   find first pic_ctrl no-lock.
   if pic_so_fact then
      rfact = pic_so_rfact.
   else
      rfact = pic_so_rfact + 2.

   /* IF RMA, RETRIEVE THE RELATED rma_mstr AND rmd_det RECORDS FOR*/
   /* POSSIBLE REPRICE REQUIREMENTS AND DATA SYNCHRONIZATION.      */
   if so_fsm_type = "RMA" then do:
      find rma_mstr where rma_nbr = so_nbr and rma_prefix = "C"
      no-lock no-error.
      rma-recno = recid(rma_mstr).
      find rmd_det where rmd_nbr  = so_nbr and
                         rmd_prefix = "C" and
                         rmd_line = sod_line
      exclusive-lock no-error. /*may update rmd_chg_type*/
      rmd-recno = recid(rmd_det).
      if sod_fsm_type = "RMA-RCT" then
         restock-pct = rma_rstk_pct.
      else
         restock-pct = 0.
   end.

   status  input.
   line = sod_line.

   find pt_mstr where pt_part = sod_part no-lock no-error.
   /* IF PART NOW IS IN ITEM MASTER, BLANK MEMO ITEM DESCRIPTION */
   if available pt_mstr then do:
      desc1 = pt_desc1.
      if sod_desc <> "" then sod_desc = "".
   end.
   else if sod_desc <> "" then
      desc1 = sod_desc.
   else
      desc1 = getTermLabel("ITEM_NOT_IN_INVENTORY",24).

   assign
      global_part = sod_part
      last_sod_price = sod_price.

   /*DETERMINE DISCOUNT DISPLAY FORMAT*/
   {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}

   /* REMEMBER, FOR RMA RECEIPT LINES, QTYS ARE STORED IN SOD_DET */
   /* AS NEGATIVE VALUES, BUT MUST BE DISPLAYED POSITIVE...       */
   display
      line
      sod_part
      sod_qty_chg        when (sod_fsm_type <> "RMA-RCT")
      (sod_qty_chg * -1) when (sod_fsm_type = "RMA-RCT") @ sod_qty_chg
      sod_um
      sod_list_pr
      discount
      sod_price
/*xx*/      sod__dec02   
     with frame c.

   /* SET SLS, DISC ACCTS BASED ON PROD LINE, SITE, CUST TYPE, CHANNEL */
   find pt_mstr where pt_part = sod_part no-lock no-error.
   pt_recno = recid(pt_mstr).

   /* Display line detail if in single line mode */
   if ln_fmt then
   display
      desc1
      sod_site
      sod_loc
      sod_serial
      sod_qty_all
      sod_qty_inv        when (sod_fsm_type <> "RMA-RCT")
      (sod_qty_inv * -1) when (sod_fsm_type = "RMA-RCT")  @ sod_qty_inv
      sod_qty_pick
      sod_bo_chg         when (sod_fsm_type <> "RMA-RCT")
      (sod_bo_chg * -1)  when (sod_fsm_type = "RMA-RCT")  @ sod_qty_inv
      sod_std_cost
      sod_acct
      sod_sub
      sod_cc
      sod_project
      sod_dsc_acct
      sod_dsc_sub
      sod_dsc_cc
      sod_dsc_project
      sod_confirm
      sod_req_date
      sod_per_date
      sod_due_date
      sod_pricing_dt
      sod_fr_list
      sod_type
      sod_um_conv
      sod_taxable
      sod_taxc
      sod_slspsn[1]
      mult_slspsn
      sod_comm_pct[1]
      (sod_cmtindx <> 0 or (new_line and soc_lcmmts)) @ sodcmmts
      sod_order_category
   with frame d.
   else if sod_serial <> "" then do:
      /* Lot/serial number _____ */
      {pxmsg.i &MSGNUM=388 &ERRORLEVEL=1 &MSGARG1=sod_serial}
   end.

   assign
      prev_due       = sod_due_date
      prev_qty_ord   = sod_qty_ord * sod_um_conv
      prev_consume   = sod_consume
      prev_qty_chg   = sod_qty_chg
      prev_price     = sod_price
      prev_listpr    = sod_list_pr
      l_prev_um      = sod_um
      l_prev_um_conv = sod_um_conv
      prev_bo_chg    = sod_bo_chg.

   /* SAVE CURRENT QTY ORDERED, UM, AND PARENT LIST TO DETERMINE   */
   /* DIFFERENCE IF QTY, UM, OR PARENT LIST CHANGED WHEN CALLING   */
   /* THE PRICING ROUTINES*/
   if sod_fsm_type <> "RMA-RCT" and (line_pricing or not new_order)
      and not l_retrobill
   then do:

      assign
         save_qty_ord = sod_qty_ord
         save_um      = sod_um.

      if can-find(first sob_det where sob_nbr  = sod_nbr and
                                      sob_line = sod_line)
      then do:
         find first pih_hist where
            pih_doc_type = 1        and
            pih_nbr      = sod_nbr  and
            pih_line     = sod_line and
            pih_parent   = ""       and
            pih_feature  = ""       and
            pih_option   = ""       and
            pih_amt_type = "1"
         no-lock no-error.
         if available pih_hist then
               save_parent_list = pih_amt.
         else do:
            save_parent_list = 0.
            for each sob_det where sob_nbr  = sod_nbr and
                                   sob_line = sod_line
            no-lock:
               save_parent_list = save_parent_list + sob_tot_std.
            end.
            save_parent_list = sod_list_pr - save_parent_list.
         end.

      end. /* if can-find(sob_det */

      else
         save_parent_list = sod_list_pr.

   end.

   del-yn = no.

   loopc1:
   do on error undo, leave loopc:
/*GUI*/ if global-beam-me-up then undo, leave.


      /* RMA LINES MAY NOT BE DELETED HERE */
      if so_fsm_type = " " then
         ststatus = stline[2].
      else
         ststatus = stline[3].
      status input ststatus.

      assign
         resv-loc-ordnbr = so_nbr
         resv-loc-ordtype = "S"
         resv-loc-ship    = so_ship
         resv-loc-bill    = so_bill
         resv-loc-cust    = so_cust
         resv-loc-fsm-type = so_fsm_type
         inv_data_changed = no
         old_sod_site = sod_site.

      pause 0.

      /* CHECK TO SEE IF LINE IS CONSIGNED. IF SO, THEN DISPLAY */
      /* A WARNING.                                             */
      if using_cust_consignment then do:
         l_consigned_line_item = no.
         {gprunmo.i
            &program = "socnsod1.p"
            &module = "ACN"
            &param = """(input so_nbr,
              input sod_line,
              output l_consigned_line_item,
              output consign_loc,
              output intrans_loc,
              output max_aging_days,
              output auto_replenish)"""}

         if l_consigned_line_item then do:
            /* THIS IS A CONSIGNED LINE ITEM */
            run displayMessage
               (input 4925,
               input 2).

            /* CHANGING INVOICE QTY WILL NOT AFFECT */
            /* CONSIGNED INVENTORY DATA */
            run displayMessage
               (input 4926,
               input 2).
         end.  /* if l_consigned_line_item */
      end.  /* if using_cust_consignment */

      /* IF MULTI ALLOCATIONS EXISTS FOR THIS DETAIL LINE, THEN
      * DO NOT ALLOW THE USER TO MODIFY THE SITE
      * IF NOENTRIES = 0, THEN THIS LINE WAS ADDED
      * IF NOENTRIES = 1, THEN ONLY ONE LOCATION WAS SHIPPED
      * IF NOENTRIES > 1, THEN MULTIPLE LOCATIONS WERE SHIPPED
      */
/***xx***/
      if noentries < 2 then do:
         run set-site.
         if return_int = 0 then undo loopc, leave loopc.
         global_site = sod_site.
      end. /* IF NOENTRIES < 2 */
/****xx*****/
      /* VALIDATE GL PERIOD FOR ENTITY AND DATABASE    */
      /* IN THESE CASES:                               */
      /* 1) MULTI-LINE MODE                            */
      /* 2) DELETING EXISTING LINE ITEM                */
      /* (PUT ANOTHER WAY, WE SKIP THIS VALIDATION IF  */
      /* THIS IS A NEW LINE BEING DELETED)             */
      if not ln_fmt or              /* MULTI-LINE */
         (del-yn and not new_line)  /* DELETING EXISTING LINE */
      then do:
         find si_mstr where si_site = sod_site no-lock.
         {gpglef4.i &module  = ""IC""
            &from_db = so_db
            &to_db   = si_db
            &entity  = si_entity
            &date    = so_ship_date}
         if gpglef_result > 0 then undo loopc, leave loopc.
      end.

      /* PROMPT USER FOR APM DETAIL RELATIONSHIP DATA */
      if soc_apm and not del-yn and available pt_mstr then do:
         for first cm_mstr where cm_addr = so_cust
         no-lock: end.
         if available cm_mstr and cm_promo <> "" then do:
            {gprun.i ""sosoapm2.p""
               "(input cm_addr,
                 input sod_nbr,
                 input sod_line,
                 output error_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            /* RESTORE F5=DELETE TO STATUS LINE */
            ststatus = stline[2].
            status input ststatus.
            if error_flag then
               undo loopc, leave.
         end. /* AVAILABLE CM_MSTR AND CM_PROMO <> "" */
      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* NOT DEL-YN AND SOC_APM AND AVAILABLE PT_MSTR */

      /* QUANTITY, ORDER UNIT OF MEASURE */
      if not del-yn then
      set1:
      do with frame c on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


         /*  (MOVED HERE FROM ABOVE SO ONLY GETS EXECUTED    */
         /*  AFTER VALIDATIONS ARE COMPLETED)                */
         /* DISPLAY PART DESCRIPTION AND AVAILABILITY IF     */
         /* NOENTRIES < 2 (IF NOENTRIES >= 2 THEN NO CHANGES */
         /* ARE ALLOWED SO THERE'S NO NEED TO DISPLAY THIS   */
         /* INFORMATION)                                     */
         if noentries < 2 then do:
            if available pt_mstr and
            (pt_desc2 <> ""
             or (not ln_fmt     and
                 pt_desc2 <> ""      ))
            then
               message pt_desc1 pt_desc2.
            /* DISPLAY AVAILABLE QUANTITY AT SELECTED SITE */
            new_site = sod_site.
            if sod_type = "" then
            {gprun.i ""gpavlsi3.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.

         display
            sod_qty_chg
         with frame c.

         /* If Logistics order, do not update from screen */
         if not lgData then do:

            /* PREVENT USER FROM UPDATING QUANTITY ON RMA LINES */
            set
               sod_qty_chg when (noentries < 2 and sod_fsm_type = " ")
               /* RESTRICT ACCESS TO UM WHEN MULTI ENTRY SHIPMENT EXIST */
               /* AND ALWAYS RESTRICT ACCESS TO UM FOR SERIAL CONTROLLED ITEM. */
               sod_um      when(not((noentries > 1) or
                               (available pt_mstr and pt_lot_ser = "S")))
            with frame c editing:

               readkey.

               /* DO NOT ALLOW USER TO UPDATE THE sod_qty_chg */
               /* FIELD WITH '?'                              */
               if input sod_qty_chg = ?
               then do:
                  /* NOT A VALID VALUE */
                  {mfmsg.i 4291 3}
                  if batchrun
                  then
                     undo, leave.
                  undo set1, retry.
               end. /* IF INPUT sod_qty_chg = ? */

               if noentries > 1 and input sod_um <> sod_um then do:
                  /* Unit of measure change not allowed */
                  {pxmsg.i &MSGNUM=685 &ERRORLEVEL=4}
                  if batchrun then undo, leave.
                  undo set1, retry.
               end.

               if not new_line and available pt_mstr and pt_pm_code = "C"
                  and input sod_um <> sod_um then do:
                  /* Unit of measure change not allowed */
                  {pxmsg.i &MSGNUM=685 &ERRORLEVEL=4}
                  if batchrun then undo, leave.
                  undo set1, retry.
               end.

               /* CONFIRM DELETE */
               if so_fsm_type = " " then
                  if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
                  then do:
                     del-yn = yes.
                     /* Please confirm delete */
                     {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
                     if del-yn then leave.
                  end.
                  else apply lastkey.
               else apply lastkey.
            end.  /* set editing: */
         end. /* if not lgData */

         else do:
            /* Get the quantity from the table. */
            for first lgil_lgdet where lgil_sod_line = sod_line
            no-lock:

               sod_qty_chg = lgil_sod_qty.

               if lgil_sod_um <> "" then
                  sod_um = lgil_sod_um.

               display
                  sod_qty_chg
                  sod_um
               with frame c.

               /* What was entered was line total. */
               /* Get price from it. */
               if sod_qty_chg <> 0 then
                  sod_price = (lgil_sod_price / sod_qty_chg).
               else
                  sod_price = lgil_sod_price .

               /* Set list price and discount, if given */
               if lgil_sod_list_pr <> 0 then
                  assign
                     sod_list_pr = lgil_sod_list_pr
                     discount = 100 * (1 - (sod_price / lgil_sod_list_pr)).
               else
                  assign
                     sod_list_pr = sod_price
                     discount = 0.
                     sod_disc_pct = discount.
            end.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.

         if available pt_mstr and pt_lot_ser = "s" and pt_um <> sod_um
         then do:
            /* UM MUST BE EQUAL TO STOCKING UM FOR */
            /* SERIAL-CONTROLLED ITEM */
            {pxmsg.i &MSGNUM=367 &ERRORLEVEL=3}
            if batchrun then undo, leave.
            next-prompt sod_um with frame c.
            undo set1,retry.
         end. /* IF AVAILABLE PT_MSTR */

         if (sod_btb_type = "02" or sod_btb_type = "03") and
            sod_qty_chg entered
         then do:
            /* NO CHANGE IS ALLOWED FOR EMT SO */
            {pxmsg.i &MSGNUM=2825 &ERRORLEVEL=3}
            if batchrun then undo, leave.
            undo set1, retry set1.
         end.

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* set1 */

   end.

   /* DO NOT ALLOW DELETION OF ORDER LINE WITH INVOICED     */
   /* QUANTITY.                                             */
   if del-yn and sod_qty_inv <> 0 then do:
      /* OUTSTANDING QUANTITY TO INVOICE, DELETE NOT ALLOWED */
      {pxmsg.i &MSGNUM=604 &ERRORLEVEL=3}
      del-yn = no.
      undo, leave.
   end. /*IF DEL-YN AND SOD_QTY_INV <> 0 */

   /* DON'T ALLOW DELETE OF ORDER LINE IF SHIPPER EXISTS */
   if del-yn then do:

      l_undotran = no.

      /* CHECK FOR EXISTENCE OF CONFIRMED/UNCONFIRMED SHIPPER */
      run p-shipper-check.

      /* DO NOT ALLOW TO DELETE ORDER LINE, IF UNCONFIRMED */
      /* SHIPPER EXISTS                                    */
      if l_undotran then
         undo , leave.

   end. /* IF DEL-YN */

   /* Do not allow a delete or update of the line that will cause */
   /* The return of lot or serial controlled items to inventory   */
   /* UNLESS the quantity moved is exactly one, in which case */
   /* We can use sod_serial (which may not be right, but it   */
   /* Can be made to work, and users have historically been   */
   /* Able to do it this way).                                */
   /* Logistics orders bill only and do not move inventory */
   /* It is Ok to process serial controlled items. */
   if del-yn then
      sod_qty_chg = 0.

   if sod_type = ""
      and (available pt_mstr and pt_lot_ser = "S")
      and not lgData
      and noentries < 2
      and (sod_qty_chg - prev_qty_chg >  1
      or sod_qty_chg - prev_qty_chg < -1
      or sod_qty_chg >  1
      or sod_qty_chg < -1)
   then do:
      /* Multiple serial numbers required */
      {pxmsg.i &MSGNUM=665 &ERRORLEVEL=4}
      if not batchrun then pause.
      else undo, leave.
      undo, retry.     /* - use Sales Order Shipments       */
   end.

   if del-yn then do:
      /* COMBINED INTO ONE ASSIGN STATEMENT */
      assign
         amd = "DELETE"
         sod_qty_chg = 0
         sod_bo_chg  = 0.
   end.

   else do:  /*ADD OR MODIFY*/

      ststatus = stline[3].
      status input ststatus.

      /*Calculate (default) remaining backordered quantity */
      if sod_qty_ord >= 0 then
         sod_bo_chg = max(sod_qty_ord - sod_qty_ship -
                          (sod_qty_chg - sod_qty_inv),0).
      else
         sod_bo_chg = min(sod_qty_ord - sod_qty_ship -
                         (sod_qty_chg - sod_qty_inv),0).
      if ((sod_qty_ord - sod_qty_ship) = 0 and
          (sod_qty_chg - sod_qty_inv) = 0)
         or sod_qty_ord = 0
      then
         sod_bo_chg = 0.

      /* CALCULATE UM CONVERSION */
      {mfumcnv.i sod_um sod_part sod_um_conv}

      if new_line and not ln_fmt and calc_fr then
         run p-calc-fr-wt.

      /* CALCULATE COST ACCORDING TO UM */
      if available pt_mstr then do:
         run p-calc-cost.
      end.

      /* Moved price conversion to line um up before all price table */
      /* and disc table calls. Because table routines now handle the */
      /* um conversion themselves.                                   */
      if new sod_det and available pt_mstr then
         assign
            sod_price = sod_price * sod_um_conv
            sod_list_pr = sod_list_pr * sod_um_conv.

      if not ln_fmt then
         pause 0.

      if not lgData then do:

         set2:
         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


/**xx**/  reprice_dtl = NO . 
            
            if ln_fmt then do:

               update
                  sod_pricing_dt when (soc_pc_line and sod_fsm_type <> "RMA-RCT")
                  sod_crt_int    when (soc_pc_line and sod_fsm_type <> "RMA-RCT")
/*xx**         reprice_dtl    when (not reprice_dtl and not new_order)  ***/
                  reprice_dtl    when ( not new_order)
                  sod_bo_chg     when (sod_fsm_type <> "RMA-RCT")
                  sod_pr_list    when (sod_fsm_type <> "RMA-RCT")
               with frame line_pop.

               pause 0.

               if ln_fmt and available pt_mstr then do:
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input remote-base-curr,
                       input base_curr,
                       input exch-rate,
                       input exch-rate2,
                       input sod_std_cost,
                       input false,
                       output sodstdcost,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.
                  display
                     sodstdcost @ sod_std_cost
                     sod_um_conv
                  with frame d.
               end.

               if (sod_btb_type = "02" or sod_btb_type = "03") and
                  sod_bo_chg <> prev_bo_chg
               then do:

                  if sod_qty_ship = 0 then do:
                     /* QTY CAN NOT BE MODIFIED */
                     {pxmsg.i &MSGNUM=2823 &ERRORLEVEL=3}
                     if batchrun then undo, leave.
                     undo set2, retry set2.
                  end.

                  if sod_qty_ship <> 0 and sod_bo_chg = 0 then do:

                     if not so_secondary then do:

                        /*CANCEL LINE FOR BTB PO */
                        assign
                           p-so-nbr   = sod_nbr
                           p-sod-line = sod_line
                           p-po-nbr   = sod_btb_po
                           p-pod-line = sod_btb_pod_line.

                        find po_mstr where po_nbr     = sod_btb_po
                                       and po_so_nbr  = sod_nbr
                                       and po_is_btb  = yes
                        no-lock no-error.

                        if not available po_mstr then do:
                           /* PURCHASE ORDER DOES NOT EXIST */
                           {pxmsg.i &MSGNUM=343 &ERRORLEVEL=3}
                           if batchrun then undo, leave.
                           undo set2, retry set2.
                        end.

                        find pod_det where pod_nbr     = po_nbr
                                       and pod_line    = sod_btb_pod_line
                                       and pod_qty_ord > 0
                        no-lock no-error.

                        if not available pod_det then do:
                           /* PO LINE DOES NOT EXIST */
                           {pxmsg.i &MSGNUM=2890 &ERRORLEVEL=3}
                           if batchrun then undo, leave.
                           undo set2, retry set2.
                        end.

                        if pod_stat = "" then do:
                           /* SUPPLIER MUST BE NOTIFIED OF CHANGE */
                           {pxmsg.i &MSGNUM=2824 &ERRORLEVEL=2}
                           if not batchrun then pause.
                           /* CANCEL BTB PO LINE */

                           /* ADDED FOURTEENTH INPUT PARAMERER AS YES */
                           {gprun.i ""socram01.p""
                              "(input p-so-nbr,
                                input p-sod-line,
                                input-output p-po-nbr,
                                input-output p-pod-line,
                                input no,
                                input yes,
                                input ?,
                                input ?,
                                input ?,
                                input ?,
                                input ?,
                                input ?,
                                input no,
                                input yes,
                                output return-msg)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                           if return-msg <> 0 and return-msg <> 343
                           then do:
                             {pxmsg.i &MSGNUM=return-msg &ERRORLEVEL=3}
                             if batchrun then undo, leave.
                                undo set2, retry set2.
                           end.
                        end.

                     end. /* if so_primary */

                     else do:
                        /* SALES OFFICE MUST BE NOTIFIED */
                        {pxmsg.i &MSGNUM=2833 &ERRORLEVEL=2}
                        if not batchrun then pause.
                     end.

                  end. /* if sod_qty_ship <> 0 and sod_bo_chg = 0 */

               end. /* sod_bo_chg <> prev_bo_chg and SO is BTB */

               hide frame line_pop no-pause.

               display
                  sod_pricing_dt
                  sod_crt_int
                  sod_bo_chg
               with frame d no-hide.
            end.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* set2 */

         /* CALL INTERNAL PRICING ROUTINE.  UPON COMPLETION PRESENT USER */
         /* WITH THE SYSTEM CALCULATED PRICES, ALLOWING FOR USER INPUT.  */
         {&SOIVMTEA-P-TAG4}
         if not l_retrobill then
            run p-pricing.

         if l_undoln then
            undo, return.

         /* DETERMINE DISCOUNT DISPLAY FORMAT */
         {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}

         display
            sod_list_pr
            discount
            sod_price
/*xx*/  sod__dec02 
         with frame c.

         save_disc_pct = if sod_list_pr <> 0 then
                            (1 - (sod_price / sod_list_pr)) * 100
                         else
                            0.

         last_list_price = sod_list_pr.

         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


            /* USER DOES NOT HAVE ACCESS TO THIS FIELD */
            {pxmsg.i &MSGNUM=4072 &ERRORLEVEL=4 &MSGBUFFER=l_err_msg}

/**xx**/  reprice_dtl = YES . 

            if new_order or reprice_dtl then
            {&SOIVMTEA-P-TAG2}
            update
               sod_list_pr
               discount     when (restock-pct = 0)
               validate({gppswd1.v
                            &field=""sod_disc_pct""
                            &field1="discount"}, l_err_msg)
            with frame c.

            {&SOIVMTEA-P-TAG3}
            /* CHECK MIN/MAX FOR LIST PRICE VIOLATIONS  */
            /* CREATE wkpi_wkfl IF MIN OR MAX ERROR OCCURS */
            if sod_fsm_type <> "RMA-RCT" and not l_retrobill
            then do:

               {gprun.i ""gpmnmx01.p""
                  "(yes, yes, min_price, max_price, 1, no,
                    sod_nbr, sod_line, yes,
                    output minmaxerr,
                    output minerr,
                    output maxerr,
                    input-output sod_list_pr,
                    input-output sod_price)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               if minerr then do:    /*List price below min. allowed*/
                  {gprun.i ""gppiwkad.p""
                     "(sod_um, sobparent, sobfeature, sobpart,
                       ""2"", ""1"", sod_list_pr, 0, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.

               if maxerr then do:   /*List price above max. allowed*/
                  {gprun.i ""gppiwkad.p""
                     "(sod_um, sobparent, sobfeature, sobpart,
                       ""3"", ""1"", sod_list_pr, 0, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.

               if minerr or maxerr then do:

                  sod__qadd01       = 0.
                  sod_disc_pct      = 0.
                  discount          = if pic_so_fact then 1 else 0.
                  parent_list_price = sod_list_pr.  /*gppiwk02.p needs this*/

                  display
                     sod_list_pr
                     discount
                     sod_price
/**xx**/         sod__dec02 
                  with frame c.

                  /* IF ANY EXISTING DISCOUNTS,                      */
                  /* CREATE/MAINTAIN "MANUAL" DISCOUNT               */
                  /* TO NEGATE DISCOUNT AND MAINTAIN PRICING HISTORY */
                  find first wkpi_wkfl where
                     wkpi_parent   = sobparent  and
                     wkpi_feature  = sobfeature and
                     wkpi_option   = sobpart    and
                     wkpi_amt_type = "2"        and
                     wkpi_source   = "1"
                  no-lock no-error.

                  /* Cascading */
                  if pic_disc_comb = "1" then do:

                     if available wkpi_wkfl then do:
                        if not found_100_disc then
                           sys_disc_fact = if wkpi_amt = 100 then
                                              1
                                           else
                                              ((100 - save_disc_pct) / 100) /
                                              ((100 - wkpi_amt)      / 100) .
                        else
                           sys_disc_fact = 0 .
                     end. /* IF AVAILABLE WKPI_WKFL */
                     else
                        sys_disc_fact =  (100 - save_disc_pct) / 100.

                     if sys_disc_fact <> 1 or available wkpi_wkfl then do:
                        if sys_disc_fact <> 0 then
                           man_disc_pct  = (1 - (1 / sys_disc_fact)) * 100.
                        else
                           man_disc_pct  = -100.

                        {gprun.i ""gppiwkad.p""
                           "(sod_um, sobparent, sobfeature, sobpart,
                             ""1"", ""2"", 0, man_disc_pct, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     end.

                  end. /* Cascading */

                  /* Additive */
                  else do:

                     if available wkpi_wkfl then
                        man_disc_pct = - (save_disc_pct - wkpi_amt).
                     else
                        man_disc_pct = - save_disc_pct.

                     if save_disc_pct <> 0 or available wkpi_wkfl then do:
                        {gprun.i ""gppiwkad.p""
                           "(sod_um, sobparent, sobfeature, sobpart,
                             ""1"", ""2"", 0, man_disc_pct, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     end.

                  end.

               end.

               else do:

                  /* TEST TO SEE IF LIST PRICE AND/OR DISCOUNT ARE MANUALLY */
                  /* ENTERED. IF SO UPDATE PRICING WORKFILE TO REFLECT CHANGE */
                  if sod_list_pr entered or discount entered then do:

                     if sod_list_pr entered then do:
                        l_flag = yes.

                        {gprun.i ""gppiwkad.p""
                           "(sod_um, sobparent, sobfeature, sobpart,
                             ""1"", ""1"", sod_list_pr, 0, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                        parent_list_price = sod_list_pr. /*used by gppiwk02.p*/

                        /* TAG AS A REPRICING CANDIDATE SINCE NET PRICE COULD */
                        /* BE AFFECTED BY CHANGE IN LIST PRICE.  ALSO, UPDATE */
                        /* EXTENDED LIST AMOUNT ACCUMULATION USED BY BEST     */
                        /* PRICING.*/
                        if line_pricing or not new_order then do:

                           find first wrep_wkfl where wrep_parent
                                                  and wrep_line = sod_line
                           exclusive-lock no-error.

                           if available wrep_wkfl then
                              wrep_rep = yes.

                           {gprun.i ""gppiqty2.p""
                              "(sod_line, sod_part, 0,
                                sod_qty_ord * (sod_list_pr - last_list_price),
                                sod_um, yes, yes, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                        end. /* IF LINE_PRICING OR NOT NEW_ORDER */

                        /* RE-APPLY THE BEST PRICING */
                        if (reprice_dtl or new_order) then do:
                           run p-bestprice.
                        end. /* IF reprice_dtl ... */

                        if sod_fsm_type = "RMA-ISS" then
                           sod_covered_amt = sod_list_pr *
                                             (coverage-discount / 100).
                     end.

                     sod__qadd01 = 0.

                     if pic_so_fact then
                        new_disc_pct = (1 - discount) * 100.
                     else
                        new_disc_pct = discount.

                     sod_disc_pct = new_disc_pct.

                     disc_min_max = no.

                     {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}

                     if disc_min_max then do:
                        /* Discount # violates the min or max allowable */
                        {pxmsg.i &MSGNUM=6932 &ERRORLEVEL=3
                                 &MSGARG1=disc_pct_err}
                        if not batchrun then
                           pause.
                        else undo, leave.
                        undo, retry.
                     end.

                     find first wkpi_wkfl where
                        wkpi_parent  = sobparent  and
                        wkpi_feature  = sobfeature and
                        wkpi_option   = sobpart    and
                        wkpi_amt_type = "2"        and
                        wkpi_source   = "1"
                     no-lock no-error.

                     if available wkpi_wkfl or discount entered then
                     do:

                        /* Cascading Discount */
                        if pic_disc_comb = "1" then do:

                           if available wkpi_wkfl then do:

                              if not found_100_disc then
                                 sys_disc_fact = if wkpi_amt = 100 then
                                                    1
                                                 else
                                                   ((100 - save_disc_pct) / 100)
                                                    / ((100 - wkpi_amt)  / 100).
                              else
                                 sys_disc_fact = 0 .
                           end. /* IF AVAILABLE WKPI_WKFL */
                           else
                              sys_disc_fact = (100 - save_disc_pct) / 100.

                           if sys_disc_fact = 1 then
                              man_disc_pct  = new_disc_pct.
                           else do:

                              if sys_disc_fact <> 0 then do:
                                 discount      = (100 - new_disc_pct) / 100.
                                 man_disc_pct  = (1 -
                                                 (discount / sys_disc_fact))
                                                  * 100.
                              end.
                              else do:
                                 if available wkpi_wkfl then
                                    man_disc_pct = new_disc_pct -
                                                   (save_disc_pct - wkpi_amt).
                                 else
                                    man_disc_pct  = new_disc_pct - 100.
                              end.

                           end.

                        end.

                        else do:
                           if available wkpi_wkfl then
                              man_disc_pct  = new_disc_pct -
                                                 (save_disc_pct - wkpi_amt).
                           else
                              man_disc_pct  = new_disc_pct - save_disc_pct.
                        end.

                        {gprun.i ""gppiwkad.p""
                           "(sod_um, sobparent, sobfeature, sobpart,
                             ""1"", ""2"", 0, man_disc_pct, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                        sod_price = sod_list_pr * (1 - (new_disc_pct / 100)).

                     end. /* IF AVAIL wkpi_wkfl ... */

                     assign
                        discount     = if sod_list_pr <> 0 then
                                          100 * (sod_list_pr - sod_price)
                                          / sod_list_pr
                                       else 0
                        sod_disc_pct = discount.

                     display
                        discount
                        sod_price
/**xx**/            sod__dec02                     
                     with frame c.

                  end. /*sod_list_pr entered or discount entered*/

               end. /*minerr or maxerr*/

            end. /*sod_fsm_type <> "RMA-RCT"*/

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do on error undo, retry (update sod_list_pr) */

         if sod_fsm_type = "RMA-RCT" then

            if restock-pct <> 0 then
               sod_price    = sod_list_pr - (restock-pct * sod_list_pr * 0.01).
            else do:
               sod_disc_pct = if pic_so_fact then
                                 (1 - discount) * 100
                              else
                                 discount.
               sod_price    = sod_list_pr -
                              (sod_disc_pct * sod_list_pr * 0.01).
            end.

            display
               sod_price
/**xx**/   sod__dec02
            with frame c.

         old_price = sod_price.

         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

            save_disc_pct = if sod_list_pr <> 0 then
                               (1 - (sod_price / sod_list_pr)) * 100
                            else
                               0.
            if new_order
            or reprice_dtl
            then do:

               l_code =  getTermLabel("ANALYSIS",8).
               /* ISSUING A WARNING WHEN USER IS CREATING AN ORDER LINE */
               /* AND ANALYSIS CODES ARE BEING BUILT AT THE SAME TIME   */
               for first qad_wkfl
                  fields(qad_key1 qad_key2)
                  where qad_key1 = l_code
                  and   qad_key2 = l_code
                  no-lock:
                  /* ANALYSIS CODES ARE BEING BUILT, */
                  /* PRICE MAY NOT BE CORRECT        */
                  {pxmsg.i &MSGNUM=5571 &ERRORLEVEL=2}
               end. /* FOR FIRST qad_wkfl */

               update
                  sod_price
/**xx*/       sod__dec02 WHEN  substring(so__chr01,1,1)  <> "F"   
               with frame c.

 /*xx*/  copper_rate = sod__dec02 .
/*xx*/  FIND FIRST pt_mstr WHERE pt_part = sod_part NO-LOCK NO-ERROR.
            IF AVAILABLE pt_mstr  AND pt__dec01 = 0  AND sod__dec02 <> 0  THEN DO:
                BELL.
                MESSAGE "The item has not include the Copper ! "  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                next-prompt sod__dec02.
                UNDO, RETRY  . 
           END.
           IF  substring(so__chr01,1,1)  <> "F"   THEN DO:
              IF AVAILABLE pt_mstr  AND pt__dec01 <> 0  AND sod__dec02 = 0  THEN DO:
                  BELL.
                  MESSAGE "The Copper Rate is not equal 0 ! "  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                  next-prompt sod__dec02.
                  UNDO, RETRY  . 
              END.
          END.


            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF new_order ... */

            if available cm_mstr
               and cm_promo <> ""
               and soc_apm
               and available pt_mstr
               and (new_order or reprice_dtl)
               and not l_retrobill
            then do:
               undo_bon = true.
               {gprun.i ""sobonli.p"" "(input sod_nbr, input sod_line)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               if undo_bon then undo loopc, leave.
               if sod_bonus then do:
                  display sod_price with frame c.
               end.
            end.

            if sod_fsm_type <> "RMA-RCT" and not l_retrobill then do:

               if sod_fsm_type = "RMA-ISS"
               then do:

                  if min_price <> 0 then
                     min_price = min_price - sod_covered_amt.
                  if max_price <> 0 then
                     max_price = max_price - sod_covered_amt.
               end.

               /*CHECK FOR NET PRICE MIN/MAX ERROR*/
               {gprun.i ""gpmnmx01.p""
                  "(no, yes, min_price, max_price,
                    1, no, sod_nbr, sod_line, yes,
                    output minmaxerr,
                    output minerr,
                    output maxerr,
                    input-output sod_list_pr,
                    input-output sod_price)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               if minmaxerr then do:

                  minmax_occurred = yes.
                  if sod_price > max_price and max_price <> 0 then
                     display max_price @ sod_price with frame c.
                  else
                     display min_Price @ sod_price with frame c.
                  if batchrun then undo, leave.
                  undo, retry.
               end.

            end. /*sod_fsm_type <> "RMA-RCT"*/

            if sod_list_pr = 0 and sod_price <> 0 and not l_retrobill
            then do:

               l_sod_price = sod_price.

               /* INTERNAL PROCEDURE p-bestprice-zero HANDLES                    */
               /* IF BEST LIST PRICE IS ZERO AND IF MARKUP OR NET PRICE          */
               /* IS SELECTED ALONG WITH DISCOUNT PRICE LIST THEN DISCOUNT AND   */
               /* LIST PRICE IS CALCULATED ACCORDINGLY                           */
               run p-bestprice-zero.

            end. /* IF SOD_LIST_PR = 0 AND SOD_PRICE <> 0 */

            /* FOR RMA RECEIPT LINES WHERE THERE'S A RESTOCKING CHARGE, */
            /* THE PERCENT ATTRIBUTABLE TO THAT RESTOCKING CHARGE MUST  */
            /* REMAIN CONSTANT.  SO, DON'T RECALCULATE THE DISCOUNT IF  */
            /* THE USER'S ENTERED A NET PRICE, RECALCULATE THE 'LIST'   */
            /* PRICE.                                                   */
            if restock-pct = 0 then
            if sod_list_pr <> 0
               or sod_bonus
            then do:
               new_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.
               sod_disc_pct = new_disc_pct.
               /*DETERMINE DISCOUNT DISPLAY FORMAT*/
               disc_min_max = no.
               {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}
               if disc_min_max then do:
                  /* Discount # violates the min or max allowable */
                  {pxmsg.i &MSGNUM=6932 &ERRORLEVEL=3 &MSGARG1=disc_pct_err}
                  if not batchrun then
                     pause.
                  else undo, leave.
                  undo, retry.
               end.
               display discount with frame c.
            end.
            else /* ELSE NO PRICE CHANGE, NO MATTER */ .
            else if sod_price <> old_price then do:
               sod_list_pr = sod_price / (1 - .01 * restock-pct).
               display sod_list_pr with frame c.
            end.

            /* TEST TO SEE IF NET PRICE HAS BEEN ENTERED, IF SO CREATE A */
            /* DISCOUNT TYPE MANUAL RECORD TO wkpi_wkfl                  */

            if (sod_price entered or minmax_occurred or sod_bonus) and
               sod_list_pr <> 0     and
               not l_retrobill
            then do:

               sod__qadd01     = 0.
               minmax_occurred = no.

               find first wkpi_wkfl where
                  wkpi_parent   = sobparent   and
                  wkpi_feature  = sobfeature  and
                  wkpi_option   = sobpart     and
                  wkpi_amt_type = "2"         and
                  wkpi_source   = "1"
               no-lock no-error.

               /* Cascading Discount */
               if pic_disc_comb = "1" then do:

                  if available wkpi_wkfl then do:

                     if not found_100_disc then
                        sys_disc_fact = if wkpi_amt = 100 then
                        1
                        else
                        ((100 - save_disc_pct) / 100) /
                        ((100 - wkpi_amt)      / 100) .
                     else
                           sys_disc_fact = 0 .
                  end. /* IF AVAILABLE WKPI_WKFL */
                  else
                     sys_disc_fact = (100 - save_disc_pct) / 100.
                  if sys_disc_fact = 1 then
                     man_disc_pct  = new_disc_pct.
                  else do:
                     if sys_disc_fact <> 0 then do:
                        discount      = (100 - new_disc_pct) / 100.
                        man_disc_pct  = (1 - (discount / sys_disc_fact))
                        * 100.
                     end.
                     else do:
                        if available wkpi_wkfl then
                           man_disc_pct = new_disc_pct -
                                             (save_disc_pct - wkpi_amt).
                        else
                           man_disc_pct  = new_disc_pct - 100.
                     end.
                  end.
               end.
               else do:
                  if available wkpi_wkfl then
                     man_disc_pct  = new_disc_pct - (save_disc_pct - wkpi_amt).
                  else
                     man_disc_pct  = new_disc_pct - save_disc_pct.
               end.

               {gprun.i ""gppiwkad.p""
                  "(sod_um, sobparent, sobfeature, sobpart,
                    ""1"", ""2"", 0, man_disc_pct, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            end. /*sod_price entered*/

         end. /* do on error undo, retry (set sod_price) */

      end. /* if not lgData */

      /* SET DETAIL FREIGHT LIST, IF ANY, SET THRU PRICING ROUTINES */
      if current_fr_list <> ""
         and sod_manual_fr_list = no
      then
         sod_fr_list = current_fr_list.

      /* UPDATE LINE DETAIL, INVENTORY DATA */
      seta:
      do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


         if ln_fmt and not available pt_mstr and not lgData then do:
            update desc1 with frame d.
            sod_desc = desc1.
         end.

         /* SET SLS, DISC ACCTS BASED ON PROD LINE, SITE, CUST TYPE, CHANNEL */
         if new_line then do:
            {gprun.i ""soplsd.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.

         remote-base-curr = base_curr.

         /* Find out if we need to change databases */
         find si_mstr where si_site = sod_site no-lock.
         chg-db = (si_db <> so_db).
         if chg-db then do:
            /* Switch to the Inventory site */
            {gprun.i ""gpalias2.p"" "(sod_site,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

            /* get the base currency of the remote database */
            {gprun.i ""gpbascur.p"" "(output remote-base-curr)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.

         {gprun.i ""gpsct05.p""
            "(sod_part, sod_site, 1, output glxcst, output curcst)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         if chg-db then do:
            {gprun.i ""gpalias3.p"" "(so_db,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

         end.

         {gprunp.i "mcpl" "p" "mc-get-ex-rate"
            "(input base_curr,
              input remote-base-curr,
              input """",
              input tax_date,
              output exch-rate2,
              output exch-rate,
              output mc-error-number)"}.
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

         if available pt_mstr then
            sod_std_cost = glxcst * sod_um_conv.

         if so_tax_date <> ? then
            tax_date = so_tax_date.
         else if so_ship_date <> ? then
            tax_date = so_ship_date.
         else if so_due_date <> ? then
            tax_date = so_due_date.
         else
            tax_date = so_ord_date.

         /* EDIT LINE DETAIL */
         undo_mta2 = true.

         /* ADDED INPUT PARAMETERS L_PREV_UM_CONV AND */
         /* L_PREV_UM TO SOIVMTA2.P                   */
         {gprun.i ""xxsoivmta2.p"" "(input l_prev_um_conv,
                                   input l_prev_um)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         if undo_mta2 then undo loopc, leave.

         /* DELETE OLD PRICE LIST HISTORY, CREATE NEW PRICE LIST         */
         /* HISTORY, MAINTAIN LAST PRICED DATE IN so_mstr (so_priced_dt) */
         if sod_fsm_type <> "RMA-RCT" and (new_order or reprice_dtl)
            and not l_retrobill
         then do:
            best_net_price = sod_price. /*accrual type price lists*/

            if not sod_bonus then do:
               assign wk_bs_line  = 0
                  wk_bs_promo = "".
            end.
            else
               if not new_order then do:
               if wk_bs_line = 0 and wk_bs_promo = "" then do:
                  find first pih_hist where pih_nbr = sod_nbr
                     and   pih_line = sod_line
                     and   pih_doc_type = 1  /*SO */
                     and   pih_source = "1"
                     and   pih_amt_type = "2"
                  no-lock no-error.
                  if available pih_hist and
                     pih_bonus_line <> 0
                  then do:
                     assign
                        wk_bs_line  = pih_bonus_line
                        wk_bs_promo = pih_promo1.
                  end.
               end.
            end.

            if parent_list_price = 0
            then
               parent_list_price = best_list_price.

            {gprun.i ""gppiwk02.p""
               "(1, sod_nbr, sod_line, sod_dsc_acct,
                 sod_dsc_sub, sod_dsc_cc, sod_dsc_project,
                 wk_bs_line, wk_bs_promo)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            so_priced_dt = today.

         end.

         if sod_per_date = ? then sod_per_date = sod_due_date.
         if sod_req_date = ? then sod_req_date = sod_due_date.

         if not available pt_mstr then do:
            if not lgData then do:
               if not ln_fmt then update desc1 with frame d.
               sod_desc = desc1.
            end.
         end.

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*seta*/

      /* UPDATE COMMISSION PERCENTAGES IF THERE ARE MULTIPLE SALESPERSONS. */
      if mult_slspsn
         and ln_fmt then
      set_comm:
      do on error undo, retry on endkey undo, leave loopc:
/*GUI*/ if global-beam-me-up then undo, leave.

         FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
sod_slspsn[1]     colon 15 label {&soivmtea_p_8}
            sod_comm_pct[1]   colon 26 no-label
            sort[1]           colon 35 no-label
            sod_slspsn[2]     colon 15 label {&soivmtea_p_6}
            sod_comm_pct[2]   colon 26 no-label
            sort[2]           colon 35 no-label
            sod_slspsn[3]     colon 15 label {&soivmtea_p_7}
            sod_comm_pct[3]   colon 26 no-label
            sort[3]           colon 35 no-label
            sod_slspsn[4]     colon 15 label {&soivmtea_p_9}
            sod_comm_pct[4]   colon 26 no-label
            sort[4]           colon 35 no-label
          SKIP(.4)  /*GUI*/
with frame set_comm overlay side-labels
         centered row 16 width 66 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-set_comm-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame set_comm = F-set_comm-title.
 RECT-FRAME-LABEL:HIDDEN in frame set_comm = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame set_comm =
  FRAME set_comm:HEIGHT-PIXELS - RECT-FRAME:Y in frame set_comm - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME set_comm = FRAME set_comm:WIDTH-CHARS - .5.  /*GUI*/


         /* SET EXTERNAL LABELS */
         setFrameLabels(frame set_comm:handle).

         sort = "".
         do counter = 1 to 4:
            find sp_mstr where sp_addr = sod_slspsn[counter]
               no-lock no-error.
            if available sp_mstr then
               sort[counter] = sp_sort.
         end.

         display
            sod_slspsn
            sod_comm_pct
            sort
         with frame set_comm.

         if not lgData then do:
            update sod_comm_pct with frame set_comm.
         end.
         hide frame set_comm no-pause.
      end.
/*GUI*/ if global-beam-me-up then undo, leave.


      /* FREIGHT WEIGHTS */
      if sod_fr_list <> "" then do:
         set_wt:
         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

            freight_ok = yes.
            if ln_fmt and (calc_fr or disp_fr) then do:
               detqty = sod_qty_chg.

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
                     and   l_fr_soline = sod_line
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

               /* ADDED INPUT PARAMETERS sod_nbr, sod_line AND sod_sob_std */
               {gprun.i ""gpfrlwt.p""
                  "(input so_curr,
                    input so_ex_rate,
                    input so_ex_rate2,
                    input so_fr_min_wt, input so_fr_terms,
                    input so_ship, input so_ship_date,
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
/*GUI*/ if global-beam-me-up then undo, leave.

            end.
/*GUI*/ if global-beam-me-up then undo, leave.


            if not freight_ok then do:
               /* Freight error detected - charges may be incomplete */
               {pxmsg.i &MSGNUM=669 &ERRORLEVEL=2}
               pause.
               undo set_wt, leave set_wt.
            end.
         end.
      end.

      /* IF THIS IS A S.O. RETURN LINE, S.O. RETURNS SHOULD UPDATE THE ISB */
      /* AND THIS PART CAN BE FOUND SOMEWHERE IN THE ISB (I.E., THIS       */
      /* RETURN COULD BE REASONABLE FOR ISB REMOVAL), OR,                  */
      /* THIS IS A REGULAR ORDER LINE (ORDER QTY IS GREATER THAN ZERO) and */
      /* THIS PART IS FLAGGED FOR THE ISB  (PT_ISB) AND SHIP TO INSTALLED  */
      /* BASE (SVC_SHIP_ISB) IS YES, THEN CALL SOSOMISB.P TO SET UP        */
      /* INSTALLED BASE INFO AND GIVE USER A CHANCE TO OVERRIDE            */
      find first svc_ctrl no-lock no-error.

      if (so_fsm_type = " " and soc_returns_isb and
         ((new_line and sod_qty_chg < 0) or
          (not new_line and sod_qty_ord < 0) ) and
         available svc_ctrl and svc_ship_isb and
         can-find (first isb_mstr where isb_part = sod_part))
      then
         return-to-remove-isb = yes.
      else
         return-to-remove-isb = no.

      if (soc_pim_isb
         or return-to-remove-isb)
         and not lgData
      then do:
         if available svc_ctrl and available pt_mstr then
         if svc_ship_isb and pt_isb
         then do:
            /* MAKE THESE WARNINGS CONTINGENT ON NEW_LINE... */
            if pt_pm_code = "C" and svc_isb_bom
               and new_line
            then do:
               /* ISB will update with std bill */
               {pxmsg.i &MSGNUM=473 &ERRORLEVEL=2}
            end.
            else do:
               if pt_pm_code = "C" and
                  new_line and
                  not svc_isb_bom then do:
                  /* ISB update with top-level item */
                  {pxmsg.i &MSGNUM=474 &ERRORLEVEL=2}
               end.
            end.
            {gprun.i ""sosomisb.p""
               "(input so_recno,
                 input sod_recno,
                 input new_line,
                 input soc_pim_isb,
                 input this_is_edi)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            hide message no-pause.
         end.
      end.

      /* If EMT, determine the Comment Type */
      emt-bu-lvl = "".
      if soc_use_btb then do:
         if so_primary and not so_secondary then
            emt-bu-lvl = "PBU".
         else if so_primary and so_secondary then
            emt-bu-lvl = "MBU".
         else if so_secondary then
            emt-bu-lvl = "SBU".
       end.

      /* LINE COMMENTS */
      if sodcmmts = yes and not lgData then do:
         cmtindx = sod_cmtindx.
         global_ref = sod_part.
         save_part  = global_part.
         global_part = emt-bu-lvl.
         {gprun.i ""gpcmmt01.p"" "(input ""sod_det"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

          global_part = save_part.
         sod_cmtindx = cmtindx.
      end.

      /* FOR RMA'S, SOME SOD_DET FIELDS ARE REPLICATED ON RMD_DET */
      /* THESE RECORDS MUST BE KEPT IN SYNC, JUST AS FSRMALIN.P   */
      /* DOES IN RMA MAINTENANCE.                                 */
      if so_fsm_type = "RMA" then do:
         assign
            rmd_cmtindx  = sod_cmtindx
            rmd_covered  = sod_list_pr - sod_price
            rmd_desc     = sod_desc
            rmd_exp_date = sod_due_date
            rmd_loc      = sod_loc
            rmd_part     = sod_part
            rmd_price    = sod_price
            rmd_prodline = sod_prodline
            rmd_qty_ord  = sod_qty_ord
            rmd_ser      = sod_serial
            rmd_site     = sod_site
            rmd_status   = sod_status
            rmd_um       = sod_um
            rmd_um_conv  = sod_um_conv.
         /* FOR RMA RETURN LINES, QTY MUST BE POSITIVE - REMEMBER */
         /* ON THE SOD_DET, THE QTY IS ALWAYS NEGATIVE.           */
         /* FOR RMD_TYPE (AND SOD_RMA_TYPE), "I" MEANS INCOMING.  */
         if rmd_type = "I" then
            rmd_qty_ord = sod_qty_ord * -1.
      end.     /* if so_fsm_type = "RMA" */

   end.  /*ADD OR MODIFY*/

   undo_all = no.

end.
{&SOIVMTEA-P-TAG5}
hide frame c_site no-pause.
hide frame set_comm no-pause.
hide frame line_pop no-pause.


/**********************INTERNAL PROCEDURES SECTION *********************/

PROCEDURE p-pricing:
/*-------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
--------------------------------------------------------------------------*/

   /* RE-READ REQUIRED RECORD BUFFERS FOR THIS PROCEDURE */
   find first pic_ctrl no-lock.
   find so_mstr where recid(so_mstr) = so_recno.
   find sod_det where recid(sod_det) = sod_recno.
   if so_fsm_type = "RMA" then do:
      find rma_mstr where recid(rma_mstr) = rma-recno.
      find rmd_det where recid(rmd_det) = rmd-recno.
   end.
   find pt_mstr where pt_part = sod_part no-lock no-error.

   assign
      min_price = 0
      max_price = 0.

   /* INITIALIZE PRICING VARIABLES AND PRICING WORKFILE FOR CURRENT sod_det */
   if sod_fsm_type <> "RMA-RCT" and (line_pricing or reprice_dtl)
   then do:

      assign
         best_list_price = 0
         best_net_price  = 0
         sobparent       = ""
         sobfeature      = ""
         sobpart         = ""
         manual_list     = sod_pr_list.

      {gprun.i ""gppiwk01.p""
         "(1, sod_nbr, sod_line)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      /* GET BEST LIST TYPE PRICE LIST, SET MIN/MAX FIELDS */
      if not available cm_mstr then
         for first cm_mstr no-lock where cm_addr = so_cust: end.

      if soc_ctrl.soc_apm and
         available pt_mstr and
         available cm_mstr and
         pt_promo <> "" and cm_promo <> ""
      then do:
         {gprun.i ""gppiapm1.p""
            "(pics_type,
              picust,
              part_type,
              sod_part,
              sobparent,
              sobfeature,
              sobpart,
              1,
              so_curr,
              sod_um,
              sod_pricing_dt,
              soc_pt_req,
              sod_site,
              so_ex_rate,
              so_ex_rate2,
              sod_nbr,
              sod_line,
              sod_div,
              output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

      end. /* IF SOC_APM  */
      else do: /* IF NOT SOC_APM */
         {gprun.i ""gppibx.p""
            "(pics_type,
              picust,
              part_type,
              sod_part,
              sobparent,
              sobfeature,
              sobpart,
              1,
              so_curr,
              sod_um,
              sod_pricing_dt,
              soc_pt_req,
              sod_site,
              so_ex_rate,
              so_ex_rate2,
              sod_nbr,
              sod_line,
              output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

      end. /* IF NOT SOC_APM */

      if soc_pt_req or best_list_price = 0 then do:

         find first wkpi_wkfl where
            wkpi_parent   = "" and
            wkpi_feature  = "" and
            wkpi_option   = "" and
            wkpi_amt_type = "1"
         no-lock no-error.

         l_undoln = no.

         if soc_pt_req then do:

            if not available wkpi_wkfl
            then do:

               /* CHECK PRICE LIST AVAILABILITY FOR INVENTORY ITEMS */
               if right-trim(sod_type) = ""
               or (right-trim(sod_type) <> "" and available pt_mstr)
               then do:
                  /* REQUIRED PRICE TABLE FOR ITEM # IN UM # NOT FOUND */
                  {pxmsg.i &MSGNUM=6231 &ERRORLEVEL=4
                           &MSGARG1=sod_part
                           &MSGARG2=sod_um}
                  if not batchrun then
                     pause.
                  l_undoln = yes.
               end. /* IF RIGHT-TRIM(SOD_TYPE) = "" OR ... */

               /* CHECK PRICE LIST AVAILABILITY FOR NON-INVENTORY ITEMS */
               else if right-trim(sod_type) <> ""
                  and not available pt_mstr
               then do:
                  /* REQUIRED PRICE TABLE FOR ITEM # IN UM # NOT FOUND */
                  {pxmsg.i &MSGNUM=6231 &ERRORLEVEL=2
                           &MSGARG1=sod_part
                           &MSGARG2=sod_um}
                  if not batchrun then
                     pause.
               end. /* IF RIGHT-TRIM(SOD_TYPE) <> "" AND ... */

            end. /* IF AVAILABLE WKPI_WKFL AND .. */

         end. /* IF SOC_PT_REQ THEN .. */

         if best_list_price = 0 then do:

            if not available wkpi_wkfl then do:

               if available pt_mstr then do:
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input base_curr,
                       input so_curr,
                       input so_ex_rate2,
                       input so_ex_rate,
                       input pt_price * sod_um_conv,
                       input false,
                       output best_list_price,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.

                  /*Create list type price list record in wkpi_wkfl*/
                  {gprun.i ""gppiwkad.p""
                     "(sod_um, sobparent, sobfeature, sobpart,
                       ""4"", ""1"", best_list_price, 0, no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.

               /* Create List Type Price List record in wkpi_wkfl for memo */
               else do:
                  best_list_price = sod_list_pr.
                  {gprun.i ""gppiwkad.p""
                     "(sod_um, sobparent, sobfeature, sobpart,
                       ""7"", ""1"", best_list_price, 0, no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.

            end.

            else
               best_list_price = wkpi_amt.
         end.
      end.

      sod_list_pr = best_list_price.
      sod_price   = best_list_price.

      /* CALCULATE TERMS INTEREST */
      if sod_crt_int <> 0 and (available pt_mstr or sod_type <> "")
      then do:
         sod_list_pr     = (100 + sod_crt_int) / 100 * sod_list_pr.
         sod_price       = sod_list_pr.
         best_list_price = sod_list_pr.
         /*Create credit terms interest wkpi_wkfl record*/
         {gprun.i ""gppiwkad.p""
            "(sod_um, sobparent, sobfeature, sobpart,
              ""5"", ""1"", sod_list_pr, 0, no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

      end.

      parent_list_price = best_list_price. /*gppiwk02.p needs this*/

   end. /*new_line or reprice_dtl*/

   /* UPDATE QTY AND EXT LIST IN ACCUMULATED QTY WORKFILES */
   if ((save_parent_list <> sod_list_pr) or
       (save_um <> sod_um)) and save_qty_ord <> 0
      and sod_fsm_type <> "RMA-RCT" and (line_pricing or not new_order)
   then do:
      {gprun.i ""gppiqty2.p""
         "(sod_line, sod_part, - save_qty_ord,
           - (save_qty_ord * save_parent_list),
           save_um, yes, yes, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      {gprun.i ""gppiqty2.p""
         "(sod_line, sod_part, (sod_qty_chg + sod_bo_chg),
           (sod_qty_chg + sod_bo_chg) * sod_list_pr,
           sod_um, yes, yes, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end.
   else do:
      {gprun.i ""gppiqty2.p""
         "(sod_line, sod_part, (sod_qty_chg + sod_bo_chg) - save_qty_ord,
           ((sod_qty_chg + sod_bo_chg) - save_qty_ord) * sod_list_pr,
           sod_um, yes, yes, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end.

   /* GET BEST DISCOUNT TYPE PRICE LISTS */
   if sod_fsm_type <> "RMA-RCT" and
      (line_pricing or reprice_dtl)
   then do:

      if not available cm_mstr then
         for first cm_mstr no-lock
         where cm_addr = so_cust: end.

      if soc_apm
         and available pt_mstr and available cm_mstr
         and pt_promo <> "" and cm_promo <> ""
      then do:

         {gprun.i ""gppiapm1.p""
            "(pics_type,
              picust,
              part_type,
              sod_part,
              sobparent,
              sobfeature,
              sobpart,
              2,
              so_curr,
              sod_um,
              sod_pricing_dt,
              no,
              sod_site,
              so_ex_rate,
              so_ex_rate2,
              sod_nbr,
              sod_line,
              sod_div,
              output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

      end. /* IF SOC_APM */
      else do: /* IF NOT SOC_APM */
         {gprun.i ""gppibx.p""
            "(pics_type,
              picust,
              part_type,
              sod_part,
              sobparent,
              sobfeature,
              sobpart,
              2,
              so_curr,
              sod_um,
              sod_pricing_dt,
              no,
              sod_site,
              so_ex_rate,
              so_ex_rate2,
              sod_nbr,
              sod_line,
              output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

      end. /* IF NOT SOC_APM */

      /* CALCULATE BEST PRICE, EXCLUDING GLOBAL DISCOUNTS */
      {gprun.i ""gppibx04.p""
         "(sobparent, sobfeature, sobpart, no, rfact)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      sod_price = best_net_price.

      /* CALCULATE BEST PRICE BASED ON GLOBAL DISCOUNTS */
      {gprun.i ""gppibx04.p""
         "(sobparent, sobfeature, sobpart, yes, rfact)"}
/*GUI*/ if global-beam-me-up then undo, leave.



      /* TEST FOR BEST OVERALL PRICE EITHER BASED ON NON-GLOBAL */
      /* DISCOUNTS OR GLOBAL DISCOUNTS.  UPON DETERMINING THE   */
      /* WINNER, DELETE THE LOSERS FROM wkpi_wkfl               */

      /* NOT ONLY MUST THE BEST PRICE WIN, BUT THERE MUST BE */
      /* FOUND SUPPORTING DISCOUNT RECORDS.*/

      if best_net_price <= sod_price and
         can-find(first wkpi_wkfl where
                  lookup(wkpi_amt_type, "2,3,4,9") <> 0
                  and wkpi_confg_disc = yes
                  and wkpi_source     = "0")
      then do:
         sod_price = best_net_price.
         for each wkpi_wkfl where
            lookup(wkpi_amt_type, "2,3,4,9") <> 0 /*and wkpi_source = "0"*/
            and wkpi_confg_disc = no
         exclusive-lock:
            delete wkpi_wkfl.
         end.
      end.

      else do:

         if can-find(first wkpi_wkfl
                     where lookup(wkpi_amt_type, "2,3,4,9") <> 0
                     and wkpi_confg_disc = no)
         then do:
            for each wkpi_wkfl
               where lookup(wkpi_amt_type, "2,3,4,9") <> 0 and
               wkpi_source     = "0" and
               wkpi_confg_disc = yes
            exclusive-lock:
               delete wkpi_wkfl.
            end.
         end.
         else
            sod_price = best_net_price.
      end.

      if sod_list_pr <> 0 then
         sod_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.
      else
         sod_disc_pct = 0.

      /* JUST IN CASE SYSTEM DISCOUNTS CHANGED SINCE THE LAST PRICING  */
      /* AND THE USER MANUALLY ENTERED THE PRICE (OR DISCOUNT), RETAIN */
      /* THE PREVIOUS sod_price (THAT'S WHAT THE USER WANTS) AND REVISE*/
      /* THE MANUAL DISCOUNT ADJUSTMENT TO COMPENSATE.                 */
      find first wkpi_wkfl where
         wkpi_parent   = sobparent  and
         wkpi_feature  = sobfeature and
         wkpi_option   = sobpart    and
         wkpi_amt_type = "2"        and
         wkpi_source   = "1"
      no-lock no-error.

      if available wkpi_wkfl
      then do:
         save_disc_pct = if sod_list_pr <> 0 then
                            (1 - (sod_price / sod_list_pr)) * 100
                         else
                            0.
         sod_price     = last_sod_price.
         if sod_list_pr <> 0 then
            new_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.
         else
            new_disc_pct = 0.
         sod_disc_pct = new_disc_pct.

         if pic_disc_comb = "1" then do:      /*cascading discount*/

            if available wkpi_wkfl then do:
               if not found_100_disc then
                  sys_disc_fact = if wkpi_amt = 100 then
                                     1
                                  else
                                     ((100 - save_disc_pct) / 100) /
                                      ((100 - wkpi_amt)      / 100) .
               else
                  sys_disc_fact = 0 .
            end. /* IF AVAILABLE WKPI_WKFL */

            else
               sys_disc_fact =  (100 - save_disc_pct) / 100.
            if sys_disc_fact = 1 then
               man_disc_pct  = new_disc_pct.
            else do:
               if sys_disc_fact <> 0 then do:
                  discount      = (100 - new_disc_pct) / 100.
                  man_disc_pct  = (1 - (discount / sys_disc_fact)) * 100.
               end.
               else do:
                  if available wkpi_wkfl then
                     man_disc_pct = new_disc_pct -
                                    (save_disc_pct - wkpi_amt).
                  else
                     man_disc_pct  = new_disc_pct - 100.
               end.
            end.
         end.
         else do:
            if available wkpi_wkfl then
               man_disc_pct = new_disc_pct - (save_disc_pct - wkpi_amt).
            else
               man_disc_pct = new_disc_pct - save_disc_pct.
         end.

         {gprun.i ""gppiwkad.p""
            "(sod_um, sobparent, sobfeature,
              sobpart, ""1"", ""2"", 0, man_disc_pct, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      end. /* last_sod_price <> sod_price */

   end. /*new_line or reprice_dtl*/

   /* RMA ISSUE LINES MAY ALSO HAVE A DISCOUNT FROM THE SERVICE    */
   /* TYPE. CALCULATE LINE DISCOUNT AS THE 'NORMAL SALES ORDER'    */
   /* DISCOUNT AMOUNT, AND ADD TO THAT THE DISCOUNT DUE TO THE     */
   /* SERVICE TYPE COVERAGE.                                       */
   if so_fsm_type = "RMA" then do:
      if sod_fsm_type = "RMA-ISS" and reprice_dtl then do:

         /* CAN'T CALL fsrmadsc.p SINCE IT ONLY APPLIES WHEN A NEW */
         /* LINE IS CREATED.  IN THIS PROCEDURE ONLY EXISTING RMA  */
         /* CAN BE REFERENCED.                                     */

         /* REINSTATE THE CALL TO fsrmadsc.p WHENEVER REPRICING.   */
         /* SORRY FOR ALL THIS CONFUSION.                          */

         /* FOR ISSUE LINES, CHECK FOR ADDITIONAL SERVICE TYPE */
         /* DISCOUNT.                                          */

         /* RMA_CTYPE WAS CHANGED TO RMD_SV_CODE AND MADE      */
         /* INPUT-OUTPUT; SOD_QTY_SHIP WAS ADDED               */

         {gprun.i ""fsrmadsc.p""
            "(input  rma_contract,
              input  if available pt_mstr then pt_fsc_code
                     else """",
              input  sod_due_date,
              input  sod_qty_ship,
              input  rma-recno,
              input  rmd-recno,
              input  new_line,
              input-output rmd_sv_code,
              input-output rmd_chg_type,
              output coverage-discount,
              output sod_contr_id)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         if sod_list_pr <> 0 then
            sod_covered_amt = sod_list_pr * (coverage-discount / 100).
         else do:
            sod_covered_amt = 0.
            sod__qadd01     = 0.
         end.

         /* NOTE:  sod__qadd01 IS USED TO CONTAIN THE ACTUAL DISCOUNT     */
         /*        PERCENT THAT IS THE EQUIVALENT OF THE COVERAGE AMOUNT  */
         /*        (UNLESS APPLYING THE COVERAGE AMOUNT REDUCES sod_price */
         /*        BELOW 0, THEN IT WILL REPRESENT sod_price PRIOR TO     */
         /*        APPLYING THE COVERAGE AMOUNT).                         */
         /*        SINCE MULTIPLE DISCOUNTS CAN BE APPLIED IN A CASCADING */
         /*        MANNER, THE COVERAGE DISCOUNT AND sod__qadd01 MAY NOT  */
         /*        BE THE SAME, ALTHOUGH THEY WILL REPRESENT THE SAME     */
         /*        AMOUNT. sod__qadd01 WILL ONLY CONTAIN A VALUE WHEN THE */
         /*        MANUAL DISCOUNT IS DUE TO THE COVERAGE DISCOUNT, ELSE  */
         /*        IT WILL CONTAIN 0.                                     */
         /*                                                               */
         /*        SOD_COVERED_AMT WILL ALWAYS MAINTAIN THE EQUIVALENT OF */
         /*        THE COVERAGE DISCOUNT.  THIS IS REQUIRED IN ORDER TO   */
         /*        ADJUST THE MINIMUM AND MAXIMUM THRESHOLD VALUES WHEN   */
         /*        TESTING THE NET PRICE AGAINST THESE THRESHOLDS.        */
         if (line_pricing or reprice_dtl) then do:

            find first wkpi_wkfl where
               wkpi_parent   = sobparent  and
               wkpi_feature  = sobfeature and
               wkpi_option   = sobpart    and
               wkpi_amt_type = "2"        and
               wkpi_source   = "1"
            no-lock no-error.

            if not available wkpi_wkfl then do:
               assign
                  save_disc_pct = if sod_list_pr <> 0 then
                                     (1 - (sod_price / sod_list_pr)) * 100
                                  else
                                     0.
               if sod_price - sod_covered_amt > 0 then
                  sod_price       = sod_price - sod_covered_amt.
               else
                  sod_price       = 0.

               new_disc_pct       = (1 - (sod_price / sod_list_pr)) * 100.
               sod_disc_pct       = new_disc_pct.

               if pic_disc_comb = "1" then do:     /*cascading discount*/
                  sys_disc_fact =  (100 - save_disc_pct) / 100.
                  if sys_disc_fact = 1 then
                     man_disc_pct  = new_disc_pct.
                  else do:
                     if sys_disc_fact <> 0 then do:
                        discount      = (100 - new_disc_pct) / 100.
                        man_disc_pct  = (1 - (discount / sys_disc_fact))
                        * 100.
                     end.
                     else
                        man_disc_pct  = new_disc_pct - 100.
                  end.
               end.
               else do:                            /*additive discount*/
                  man_disc_pct = new_disc_pct - save_disc_pct.
               end.

               {gprun.i ""gppiwkad.p""
                  "(sod_um, sobparent, sobfeature, sobpart,
                    ""1"", ""2"", 0, man_disc_pct, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               sod__qadd01 = man_disc_pct.

            end.
            else do:
               sod__qadd01     = 0.
            end.

         end. /* sod_list_pr <> 0 */

      end.    /* sod_fsm_type = "RMA-ISS" */

      else do:
         /* ELSE, IF THIS IS A RECEIPT LINE, THE USER MAY SEE */
         /* SOME 'DISCOUNT' AS A RESULT OF THE RESTOCK CHARGE */
         /* IN THIS CASE, GIVE HIM A MESSAGE TO CLARIFY.      */
         if sod_fsm_type = "RMA-RCT" and restock-pct <> 0 then do:
            /* RESTOCKING CHARGE APPLIES TO THIS LINE ITEM */
            {pxmsg.i &MSGNUM=1186 &ERRORLEVEL=1}
         end.
      end.    /* if sod_fsm_type = "RMA-ISS" */

   end.   /* if so_fsm_type = "RMA" */

   /* HERE'S WHERE WE PRICE A RMA RECEIPT LINE */

   if sod_fsm_type = "RMA-RCT" and reprice_dtl
   then do:
      if so_crprlist <> "" and available pt_mstr then do:
         assign
            pt_recno = recid(pt_mstr)
            pcqty    = sod_qty_ord.
         {gprun.i ""sopccal.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

      end.
      if restock-pct <> 0 then
      assign
         sod_list_pr  = sod_price
         sod_disc_pct = restock-pct
         sod_price    = sod_list_pr - (restock-pct * sod_list_pr * 0.01).
   end.   /* if this-is-rma and... */

   if sod_fsm_type <> "RMA-RCT" then
      if sod_list_pr <> 0 then
      sod_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.
   else
      sod_disc_pct = 0.

   /* TEST FOR DISCOUNT RANGE VIOLATION.  IF FOUND, CREATE/MAINTAIN */
   /* MANUAL DISCOUNT TO RECONCILE THE DIFFERENCE BETWEEN THE SYSTEM*/
   /* DISCOUNT AND THE MIN OR MAX ALLOWABLE DISCOUNT, DEPENDING ON  */
   /* THE VIOLATION.                                                */
   disc_min_max = no.

   {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}

   /* Found a discount range violation */
   if disc_min_max then do:

      /* Discount # is out of range, set to nearest allowable value */
      {pxmsg.i &MSGNUM=6931 &ERRORLEVEL=2 &MSGARG1=disc_pct_err}

      if not batchrun then
         pause.

      if sod_fsm_type <> "RMA-RCT" then do:

         save_disc_pct = disc_pct_err.
         new_disc_pct  = if pic_so_fact then
                            (1 - discount) * 100
                         else
                            discount.
         sod_disc_pct  = new_disc_pct.

         find first wkpi_wkfl where
            wkpi_parent   = sobparent  and
            wkpi_feature  = sobfeature and
            wkpi_option   = sobpart    and
            wkpi_amt_type = "2"        and
            wkpi_source   = "1"
         no-lock no-error.

         /* Cascading Discount */
         if pic_disc_comb = "1" then do:

            if available wkpi_wkfl then
               sys_disc_fact = if wkpi_amt = 100 then 1
                               else
                                  ((100 - save_disc_pct) / 100) /
                                   ((100 - wkpi_amt)      / 100).
            else
               sys_disc_fact =  (100 - save_disc_pct) / 100.

            if sys_disc_fact = 1 then
               man_disc_pct  = new_disc_pct.
            else do:
               if sys_disc_fact <> 0 then do:
                  discount      = (100 - new_disc_pct) / 100.
                  man_disc_pct  = (1 - (discount / sys_disc_fact)) * 100.
               end.
               else
                  man_disc_pct  = new_disc_pct - 100.
            end.

         end.

         /* Additive Discount */
         else do:
            if available wkpi_wkfl then
               man_disc_pct = new_disc_pct - (save_disc_pct - wkpi_amt).
            else
               man_disc_pct = new_disc_pct - save_disc_pct.
         end.

         {gprun.i ""gppiwkad.p""
            "(sod_um, sobparent, sobfeature, sobpart,
              ""1"", ""2"", 0, man_disc_pct, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      end. /* if sod_fsm_type <> "RMA-RCT" */

      sod_price = sod_list_pr * (1 - (new_disc_pct / 100)).

   end.    /* if disc_min_max */

END PROCEDURE. /* p-pricing */

PROCEDURE p-calc-cost:
/*-------------------------------------------------------------------------
  Purpose: Calculate the cost according to the UM
  Parameters:
  Notes:   Added this procedure with patch /*K0JL*/
--------------------------------------------------------------------------*/

   remote-base-curr = base_curr.

   /* Find out if we need to change databases */
   find si_mstr where si_site = sod_det.sod_site no-lock.

   chg-db = (si_db <> so_db).

   if chg-db then do:
      /* Switch to the Inventory site */
      {gprun.i ""gpalias2.p"" "(sod_det.sod_site,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

      {gprun.i ""gpbascur.p"" "(output remote-base-curr)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end.

   {gprun.i ""gpsct05.p""
      "(input sod_det.sod_part,
        input sod_det.sod_site,
        input 1,
        output glxcst,
        output curcst)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   if chg-db then do:
      {gprun.i ""gpalias3.p"" "(so_db,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

   end.

   assign
      sod_det.sod_std_cost = glxcst * sod_det.sod_um_conv.

   {gprunp.i "mcpl" "p" "mc-get-ex-rate"
      "(input base_curr,
        input remote-base-curr,
        input """",
        input tax_date,
        output exch-rate2,
        output exch-rate,
        output mc-error-number)"}.
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

END PROCEDURE.

PROCEDURE set-site:
/*-------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
--------------------------------------------------------------------------*/
    {&SOIVMTEA-P-TAG6}
   FORM /*GUI*/ 
      space(1)  sod_site  space(1)
   with frame c_site overlay row frame-row(c) column 16 THREE-D /*GUI*/.


   setFrameLabels(frame c_site:handle).

   /* SITE - Allow site input through pop-up */
   setsite:
   do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

      {&SOIVMTEA-P-TAG7}
      if sod_det.sod_site <> "" then do:
         {gprun.i ""gpsiver.p""
            "(input sod_site, input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         if return_int = 0 then do:
            /* USER DOES NOT HAVE ACCESS TO THIS SITE */
            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=4}
            if not batchrun then do:
               pause.
               clear frame c.
            end.
            return.
         end.
      end.
      {&SOIVMTEA-P-TAG8}
      if ln_fmt then do on endkey undo, return error:

         find pt_mstr no-lock where pt_part = sod_part no-error.

         if available pt_mstr then do:
            pm_code = pt_pm_code.
            find ptp_det where ptp_part = pt_part
                           and ptp_site = sod_site
            no-lock no-error.
            if available ptp_det then pm_code = ptp_pm_code.
         end.

         if (new sod_det and pm_code = "C") or pm_code <> "C"
         then do:
            {&SOIVMTEA-P-TAG9}
            if not lgData then do:

               update sod_site
                  with frame c_site
               editing:

                  readkey.

                  /* DELETE */
                  /* Delete logic repeated so delete on quantity is */
                  /* Valid for multi-line mode.                     */
                  if so_mstr.so_fsm_type = " " then
                     if lastkey = keycode("F5")
                     or lastkey = keycode("CTRL-D")
                     then do:
                        del-yn = yes.
                        /* Please confirm Delete */
                        {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
                        if del-yn then leave setsite.
                     end.
                     else
                        apply lastkey.
                  else
                     apply lastkey.

               end. /* editing: */
               {&SOIVMTEA-P-TAG10}

            end. /* if not lgData */

         end. /* if new sod_det */

         if sod_site <> old_sod_site then
            inv_data_changed = yes.
         else
            inv_data_changed = no.

         if sod_site <> old_sod_site and new_line = no
         then do:
            find si_mstr where si_site = sod_site no-lock no-error.
            new_db = si_db.
            find si_mstr where si_site = old_sod_site
            no-lock no-error.
            old_db = si_db .
            if new_db <> old_db  then do:
               /*Site is not in the same database*/
               {pxmsg.i &MSGNUM=2516 &ERRORLEVEL=3}
               if not batchrun then pause.
               else undo, leave.
               undo setsite, retry.
            end.
         end.

         /* VALIDATE GL PERIOD FOR ENTITY/DATABASE */
         find si_mstr where si_site = sod_site no-lock.
         {gpglef3.i &module  = ""IC""
            &from_db = so_db
            &to_db   = si_db
            &entity  = si_entity
            &date    = so_ship_date
            &prompt  = "sod_site"
            &frame   = "c_site"
            &loop    = "setsite"}

      end. /* IF LN_FMT */

      {gprun.i ""gpsiver.p""
         "(input sod_site, input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      if return_int = 0 then do:
         {&SOIVMTEA-P-TAG11}
         if ln_fmt then do:
            {&SOIVMTEA-P-TAG12}
            /* USER DOES NOT HAVE ACCESS TO THIS SITE */
            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
            if batchrun then undo, leave.
            next-prompt sod_site with frame c_site.
            undo setsite, retry.
         end.
         else do:
            /* USER DOES NOT HAVE ACCESS TO THIS SITE */
            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=4}
            if not batchrun then pause.
            return.
         end.
      end.

      /* Validate the part/site combination */
      if sod_type = "" then do:

         new_site = sod_site.
         {gprun.i ""gpptsi01.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

         if err_stat <> 0 then do:

            /* Changed validation to remove option to create in_mstr. */
            if not ln_fmt then do:
               /* Try to use default site in item master */
               find pt_mstr where pt_part = sod_part no-lock.
               if pt_site <> sod_site then do:
                  new_site = pt_site.
                  {gprun.i ""gpptsi01.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.
            end.
            if err_stat <> 0 then do:
               /* Item does not exist at site */
               {pxmsg.i &MSGNUM=715 &ERRORLEVEL=3}
               if batchrun then undo, leave.
               undo setsite, retry.
            end.

         end.

      end. /* VALIDATE PART/SITE (IF SOD_TYPE = "") */

      if ln_fmt then do:

         /* Determine if new default location needed  */
         if new sod_det and old_sod_site <> sod_site then do:

            /*  SEE IF THERE IS A DEFAULT LOCATION FOR A  */
            /*  CUSTOMER RESERVED LOCATION                */
            {gprun.i ""sorldft.p""
               "(input so_ship,
                input so_bill,
                input so_cust,
                input sod_site,
                output cust-resv-loc,
                output useloc)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            if useloc = yes then
               sod_loc = cust-resv-loc.
            else do:
               if available pt_mstr then
               sod_loc  = pt_loc.
            end.

            display
               sod_loc
            with frame d.
         end.

         display sod_site with frame d.
         {&SOIVMTEA-P-TAG13}
         hide frame c_site no-pause.
         {&SOIVMTEA-P-TAG14}

      end.
      {&SOIVMTEA-P-TAG15}

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* SETSITE: DO ON ERROR UNDO, RETRY */

END PROCEDURE.

PROCEDURE p-calc-fr-wt:
/*-------------------------------------------------------------------------
  Purpose:    Called to calculate freight weight in multi-entry mode for
              Inventory items with calculate freight set to yes when
              new sales order line is created.
  Parameters:
  Notes:
--------------------------------------------------------------------------*/

   define variable  l_um_conv     like sod_um_conv no-undo.
   define variable  l_frc_returns like mfc_char no-undo.

   if not available sod_det or
      not available pt_mstr
   then
      leave.

   if sod_type = "" then do:

      if sod_um <> pt_um then do:
         {gprun.i ""gpumcnv.p""
            "(input sod_um,
              input pt_um,
              input sod_part,
              output l_um_conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         if l_um_conv = ? then do:
            /* FREIGHT ERROR DETECTED - CHARGES MAY BE INCOMPLETE */
            {pxmsg.i &MSGNUM=669 &ERRORLEVEL=2}
            if not batchrun then pause.
            l_um_conv = 1.
         end. /* IF L_UM_CONV = ? */

      end. /* SOD_UM <> PT_UM */
      else
         l_um_conv = 1.

      find mfc_ctrl where mfc_field = "frc_returns" no-lock no-error.
      l_frc_returns = mfc_char.
      if sod_qty_chg < 0 and l_frc_returns = "z" then
         sod_fr_wt = 0.
      else
         sod_fr_wt    = pt_ship_wt * l_um_conv.

      sod_fr_wt_um = pt_ship_wt_um.

   end. /* IF SOD_TYPE = "" */

END PROCEDURE. /* p-calc-fr-wt */

PROCEDURE p-bestprice-zero:
/*-------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:       If best list price is zero and if markup or net price is
               selected along with discount price list then discount and
               list price is calculated accordingly
--------------------------------------------------------------------------*/

   define variable l_list_id like wkpi_list_id no-undo.
   define variable l_list    like wkpi_list    no-undo.
   define variable l_source  like wkpi_source  no-undo.
   define variable l_part    like wkpi_option  no-undo.

   for each wkpi_wkfl
      where wkpi_amt_type = "3"
      or    wkpi_amt_type = "4"
      no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


      assign
         l_list_id = wkpi_list_id
         l_list    = wkpi_list
         l_source  = wkpi_source.

      if wkpi_amt_type = "3" then do:
         if available pt_mstr then do:

            l_part = (if wkpi_option = ""
                      then
                         pt_part
                      else
                         wkpi_option).

            find pi_mstr where pi_list_id = wkpi_list_id no-lock.
            if pi_cost_set = "" then do:
               {gprun.i ""gpsct05x.p""
                  "(input l_part,
                    input sod_det.sod_site,
                    input 1,
                    output glxcst,
                    output curcst)" }
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* IF PI_COST_SET = "" */
            else do:
               {gprun.i ""gpsct07x.p""
                  "(input l_part,
                    input sod_det.sod_site,
                    input pi_cost_set,
                    input 1,
                    output glxcst)" }
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* IF PI_COST_SET <> "" */

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input base_curr,
                 input so_mstr.so_curr,
                 input so_mstr.so_ex_rate2,
                 input so_mstr.so_ex_rate,
                 input glxcst * sod_det.sod_um_conv,
                 input false,
                 output item_cost,
                 output mc-error-number)"}.
            if mc-error-number <> 0
               then {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.

         end. /* IF AVAILABLE PT_MSTR */
         sod_list_pr = sod_list_pr +
                       item_cost   * (1 + wkpi_amt / 100).

      end. /* IF WKPI_AMT_TYPE = "3" */
      else
         sod_det.sod_list_pr = sod_det.sod_list_pr + wkpi_amt.
   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH wkpi_wkfl */

   /* DISPLAYING sod_list_pr AND RE-ASSIGNING THE SCREEN VALUE */
   /* TO AVOID ROUNDING ERRORS                                 */
   l_sod_list_pr = sod_det.sod_list_pr.

   output stream listprice to value(mfguser + "l.out").
   put stream listprice sod_det.sod_list_pr skip.
   output stream listprice close.

   input stream listprice from value(mfguser + "l.out").
   import stream listprice sod_det.sod_list_pr.
   input stream listprice close.

   if sod_det.sod_list_pr <> sod_det.sod_price
   then
   sod_det.sod_list_pr = l_sod_list_pr.

   if  sod_det.sod_list_pr <> 0
   and sod_det.sod_list_pr <> l_sod_price
   then
      sod_det.sod_disc_pct = (1 - (sod_det.sod_price / sod_det.sod_list_pr))
                             * 100.
   else
      assign
         sod_det.sod_list_pr  = sod_det.sod_price
         sod_det.sod_disc_pct = 0.

   if l_list_id = ""
   then

   /* IF BEST LIST PRICE SELECTED IS ZERO AND IF NO PRICE LIST EXIST */
      assign
         sod_det.sod_disc_pct = 0
         l_source             = "4"
         sod_det.sod_list_pr = sod_det.sod_price.

   display
      sod_det.sod_list_pr
      sod_det.sod_disc_pct @ discount
   with frame c.

   if l_flag
      then l_source = "1".

   /* CHANGED FIFTH PARAMETER FROM "1" TO l_source */
   {gprun.i ""gppiwkad.p""
      "(sod_um, sobparent, sobfeature, sobpart,
        l_source, ""1"", sod_det.sod_list_pr, sod_det.sod_disc_pct, no )"}
/*GUI*/ if global-beam-me-up then undo, leave.


   if not l_flag
   then do:
      find first wkpi_wkfl
         where wkpi_parent   = sobparent
         and   wkpi_feature  = sobfeature
         and   wkpi_option   = sobpart
         and   wkpi_amt_type = "1"
         exclusive-lock no-error.

      if available wkpi_wkfl
         then
      assign
         wkpi_list_id = l_list_id
         wkpi_list    = l_list.
   end. /* IF NOT l_flag */

END PROCEDURE.  /* P-BESTPRICE-ZERO */

PROCEDURE p-shipper-check:
/*-------------------------------------------------------------------------
  Purpose:    Check for existence of confirmed/unconfirmed shipper
  Parameters:
  Notes:
--------------------------------------------------------------------------*/

   assign
      l_conf_ship   = 0
      shipper_found = 0.

   {gprun.i ""rcsddelb.p""
      "(input sod_det.sod_nbr,
        input sod_det.sod_line,
        input sod_det.sod_site,
        output shipper_found,
        output save_abs,
        output l_conf_ship,
        output l_conf_shid)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   if shipper_found > 0 then do:

      assign
         l_undotran = yes
         del-yn     = no
         save_abs   = substring(save_abs,2,20).
      /* # Shippers/containers exist for order, including # */
      {pxmsg.i &MSGNUM=1118 &ERRORLEVEL=4
               &MSGARG1=shipper_found
               &MSGARG2=save_abs}

   end. /* IF SHIPPER FOUND > 0 */

   /* IF ALL THE SHIPPERS FOR THE ORDER HAVE BEEN CONFIRMED      */

   else if l_conf_ship > 0 then do:

      l_conf_shid = substring(l_conf_shid,2,20).
      /* # Confirmed Shippers/containers exist for order, including # */
      {pxmsg.i &MSGNUM=3314 &ERRORLEVEL=2
               &MSGARG1=l_conf_ship
               &MSGARG2=l_conf_shid}

      /* PAUSING FOR USER TO SEE THE MESSAGE */
      if not batchrun then
         pause.

   end. /* IF L_CONF_SHIP > 0 */

END PROCEDURE. /* P-SHIPPER-CHECK */

PROCEDURE p-bestprice:
/*-------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
--------------------------------------------------------------------------*/

   /* BEFORE RE-PRICING DELETE PREVIOUSLY SELECTED PRICE LIST */
   /* RECORDS EXCEPT LIST PRICE. RETAIN ALL MANUAL OVERRIDE   */
   /* RECORDS.                                                */
   for each wkpi_wkfl
         where wkpi_amt_type <> "1" and
         wkpi_source    = "0"
   exclusive-lock:
      delete wkpi_wkfl.
   end. /* FOR EACH wkpi_wkfl */

   /* GET BEST DISCOUNT TYPE PRICE LISTS */
   /* IF APM IS IN USE AND CUSTOMER AND ITEM ARE USED BY APM */
   /* THEN CALL THE APM PRICE LIST SELECTION ROUTINE         */
   if soc_ctrl.soc_apm
      and available cm_mstr
      and cm_mstr.cm_promo <> ""
      and pt_mstr.pt_promo <> ""
   then do:
      {gprun.i ""gppiapm1.p""
         "(pics_type,
           picust,
           part_type,
           sod_det.sod_part,
           sobparent,
           sobfeature,
           sobpart,
           2,
           so_mstr.so_curr,
           sod_det.sod_um,
           sod_det.sod_pricing_dt,
           no,
           sod_det.sod_site,
           so_mstr.so_ex_rate,
           so_mstr.so_ex_rate2,
           sod_det.sod_nbr,
           sod_det.sod_line,
           sod_det.sod_div,
           output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end. /* IF soc_ctrl.soc_apm ... */
   else do:
      {gprun.i ""gppibx.p""
         "(pics_type,
           picust,
           part_type,
           sod_det.sod_part,
           sobparent,
           sobfeature,
           sobpart,
           2,
           so_mstr.so_curr,
           sod_det.sod_um,
           sod_det.sod_pricing_dt,
           no,
           sod_det.sod_site,
           so_mstr.so_ex_rate,
           so_mstr.so_ex_rate2,
           sod_det.sod_nbr,
           sod_det.sod_line,
           output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end. /* IF NOT soc_ctrl.soc_apm */

   /* CALCULATE BEST PRICE, FOR NON GLOBAL DISCOUNTS */
   {gprun.i ""gppibx04.p""
      "(sobparent, sobfeature, sobpart, no, rfact)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   /* CALCULATE BEST PRICE, FOR GLOBAL DISCOUNTS */
   {gprun.i ""gppibx04.p""
      "(sobparent, sobfeature, sobpart, yes, rfact)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   assign
      sod_det.sod_price = best_net_price
      save_disc_pct     = if sod_det.sod_list_pr <> 0 then
                             (1 - (sod_det.sod_price / sod_det.sod_list_pr))
                             * 100
                          else
                             0.

END PROCEDURE.  /* P-BESTPRICE */
{&SOIVMTEA-P-TAG16}
