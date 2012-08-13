/* GUI CONVERTED from sosomtla.p (converter v1.75) Mon Jun  4 09:28:52 2001 */
/* sosomtla.p - SALES ORDER MAINTENANCE LINE PRICE/QTY SUBROUTINE            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                        */
/*V8:RunMode=Character,Windows                                                */
/* REVISION: 6.0      LAST MODIFIED: 03/21/90   BY: ftb *D011*               */
/* REVISION: 6.0      LAST MODIFIED: 04/06/90   BY: ftb *D002*               */
/* REVISION: 6.0      LAST MODIFIED: 04/10/90   BY: MLB *D021*               */
/* REVISION: 6.0      LAST MODIFIED: 08/30/90   BY: EMB *D040*               */
/* REVISION: 6.0      LAST MODIFIED: 08/09/90   BY: MLB *D055*               */
/* REVISION: 6.0      LAST MODIFIED: 12/19/90   BY: afs *D266*               */
/* REVISION: 6.0      LAST MODIFIED: 01/18/91   BY: emb *D307*               */
/* REVISION: 6.0      LAST MODIFIED: 01/31/91   BY: afs *D327*               */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*               */
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: pma *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 03/23/92   BY: dld *F297*               */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: afs *F356*               */
/* REVISION: 7.0      LAST MODIFIED: 04/16/92   BY: dld *F382*               */
/* REVISION: 7.0      LAST MODIFIED: 04/22/92   BY: afs *F420*               */
/* REVISION: 7.0      LAST MODIFIED: 04/30/92   BY: tjs *F463*               */
/* REVISION: 7.0      LAST MODIFIED: 05/06/92   BY: tjs *F470*               */
/* REVISION: 7.0      LAST MODIFIED: 06/11/92   BY: tjs *F504*               */
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: afs *F519*               */
/* REVISION: 7.0      LAST MODIFIED: 07/08/92   BY: tjs *F723*               */
/* REVISION: 7.0      LAST MODIFIED: 07/29/92   BY: tjs *F802*               */
/* REVISION: 7.0      LAST MODIFIED: 08/21/92   BY: afs *F862*               */
/* REVISION: 7.3      LAST MODIFIED: 09/15/92   BY: tjs *G035*               */
/* REVISION: 7.3      LAST MODIFIED: 10/28/92   BY: afs *G244*               */
/* REVISION: 7.3      LAST MODIFIED: 11/23/92   BY: tjs *G191*               */
/* REVISION: 7.3      LAST MODIFIED: 12/08/92   BY: tjs *G391*               */
/* REVISION: 7.3      LAST MODIFIED: 01/12/92   BY: tjs *G507*               */
/* REVISION: 7.3      LAST MODIFIED: 01/04/92   BY: afs *G501*               */
/* REVISION: 7.3      LAST MODIFIED: 02/08/92   BY: bcm *G415*               */
/* REVISION: 7.3      LAST MODIFIED: 02/18/93   BY: afs *G692*               */
/* REVISION: 7.3      LAST MODIFIED: 02/24/93   BY: sas *G457*               */
/* REVISION: 7.3      LAST MODIFIED: 04/10/93   BY: tjs *G830*               */
/* REVISION: 7.3      LAST MODIFIED: 04/27/93   BY: WUG *GA46*               */
/* REVISION: 7.3      LAST MODIFIED: 05/17/93   BY: afs *GB06*               */
/* REVISION: 7.3      LAST MODIFIED: 05/20/93   BY: kgs *GB18*               */
/* REVISION: 7.4      LAST MODIFIED: 06/21/93   BY: pcd *H008*               */
/* REVISION: 7.4      LAST MODIFIED: 08/06/93   BY: tjs *H059*               */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*               */
/* REVISION: 7.4      LAST MODIFIED: 09/29/93   BY: cdt *H086*               */
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184*               */
/* REVISION: 7.4      LAST MODIFIED: 11/22/93   BY: afs *H238*               */
/* REVISION: 7.4      LAST MODIFIED: 02/07/94   BY: afs *FL83*               */
/* REVISION: 7.4      LAST MODIFIED: 03/10/94   BY: cdt *H294*               */
/* REVISION: 7.4      LAST MODIFIED: 03/16/94   BY: afs *H295*               */
/* REVISION: 7.3      LAST MODIFIED: 04/25/94   BY: cdt *GJ56*               */
/* REVISION: 7.4      LAST MODIFIED: 05/27/94   BY: dpm *FO23*               */
/* REVISION: 7.4      LAST MODIFIED: 05/27/94   BY: qzl *H376*               */
/* REVISION: 7.4      LAST MODIFIED: 06/16/94   BY: qzl *H390*               */
/* REVISION: 7.3      LAST MODIFIED: 06/29/94   BY: cdt *GK52*               */
/* REVISION: 7.3      LAST MODIFIED: 06/15/94   BY: WUG *GK60*               */
/* REVISION: 7.3      LAST MODIFIED: 07/11/94   BY: dpm *FP33*               */
/* REVISION: 7.4      LAST MODIFIED: 07/18/94   BY: bcm *H443*               */
/* REVISION: 7.4      LAST MODIFIED: 07/21/94   BY: WUG *GK86*               */
/* REVISION: 7.4      LAST MODIFIED: 08/09/94   BY: bcm *H476*               */
/* REVISION: 7.4      LAST MODIFIED: 08/15/94   BY: WUG *FQ14*               */
/* REVISION: 7.4      LAST MODIFIED: 09/09/94   BY: afs *H510*               */
/* REVISION: 7.4      LAST MODIFIED: 09/26/94   BY: ljm *GM78*               */
/* REVISION: 7.4      LAST MODIFIED: 10/10/94   BY: bcm *H561*               */
/* REVISION: 7.4      LAST MODIFIED: 10/16/94   BY: dpm *FR95*               */
/* REVISION: 8.5      LAST MODIFIED: 10/18/94   BY: mwd *J034*               */
/* REVISION: 7.4      LAST MODIFIED: 11/02/94   BY: rxm *FT18*               */
/* REVISION: 7.4      LAST MODIFIED: 11/11/94   BY: qzl *FT43*               */
/* REVISION: 7.4      LAST MODIFIED: 12/13/94   BY: afs *FU56*               */
/* REVISION: 7.4      LAST MODIFIED: 01/13/95   BY: dpm *F0DR*               */
/* REVISION: 7.4      LAST MODIFIED: 01/25/95   BY: bcm *F0G8*               */
/* REVISION: 7.4      LAST MODIFIED: 02/10/95   BY: rxm *F0HM*               */
/* REVISION: 7.4      LAST MODIFIED: 03/03/95   BY: rxm *F0LM*               */
/* REVISION: 7.4      LAST MODIFIED: 03/14/95   BY: rxm *G0H7*               */
/* REVISION: 7.4      LAST MODIFIED: 03/21/95   BY: rxm *F0MV*               */
/* REVISION: 8.5      LAST MODIFIED: 03/07/95   BY: DAH *J042*               */
/* REVISION: 8.5      LAST MODIFIED: 07/11/95   BY: DAH *J05G*               */
/* REVISION: 8.5      LAST MODIFIED: 08/14/95   BY: DAH *J063*               */
/* REVISION: 8.5      LAST MODIFIED: 09/10/95   BY: DAH *J07R*               */
/* REVISION: 8.5      LAST MODIFIED: 10/04/95   BY: AME *J089*               */
/* REVISION: 7.4      LAST MODIFIED: 08/25/95   BY: jym *G0TW*               */
/* REVISION: 7.4      LAST MODIFIED: 09/06/95   BY: ais *G0WL*               */
/* REVISION: 7.4      LAST MODIFIED: 10/23/95   BY: rxm *G19G*               */
/* REVISION: 7.4      LAST MODIFIED: 11/13/95   BY: ais *H0GK*               */
/* REVISION: 7.4      LAST MODIFIED: 12/07/95   BY: rxm *H0FS*               */
/* REVISION: 8.5      LAST MODIFIED: 11/07/95   BY: taf *J053*               */
/* REVISION: 7.4      LAST MODIFIED: 12/19/95   BY: kjm *G1GV*               */
/* REVISION: 8.5      LAST MODIFIED: 04/03/96   BY: DAH *J0GT*               */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: *J04C* Sue Poland        */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: *J04C* Markus Barone     */
/* REVISION: 8.5      LAST MODIFIED: 04/17/96   BY: *J04C* Sue Poland        */
/* REVISION: 8.5      LAST MODIFIED: 04/30/96   BY: *J0KJ* Dennis Henson     */
/* REVISION: 8.5      LAST MODIFIED: 05/07/96   BY: *J0LL* Dennis Henson     */
/* REVISION: 8.5      LAST MODIFIED: 05/16/96   BY: *J0MY* Sue Poland        */
/* REVISION: 8.5      LAST MODIFIED: 05/20/96   BY: *J0N2* Dennis Henson     */
/* REVISION: 8.5      LAST MODIFIED: 06/10/96   BY: *J0VK* Markus Barone     */
/* REVISION: 8.5      LAST MODIFIED: 06/21/96   BY: *G1V1* Tony Patel        */
/* REVISION: 8.5      LAST MODIFIED: 07/02/96   BY: *J0XG* Dennis Henson     */
/* REVISION: 8.5      LAST MODIFIED: 07/04/96   BY: *J0XR* Dennis Henson     */
/* REVISION: 8.5      LAST MODIFIED: 07/12/96   BY: *J0Y5* Andy Wasilczuk    */
/* REVISION: 8.5      LAST MODIFIED: 07/11/96   BY: *J0YR* Kieu Nguyen       */
/* REVISION: 8.5      LAST MODIFIED: 07/16/96   BY: *J0Z6* Andy Wasilczuk    */
/* REVISION: 8.5      LAST MODIFIED: 07/23/96   BY: *J0R1* Andy Wasilczuk    */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: *J12Q* Andy Wasilczuk    */
/* REVISION: 8.5      LAST MODIFIED: 08/07/96   BY: *G29K* Markus Barone     */
/* REVISION: 8.5      LAST MODIFIED: 09/12/96   BY: *J152* Suresh Nayak      */
/* REVISION: 8.6      LAST MODIFIED: 10/10/96   BY: svs *K007*               */
/* REVISION: 8.6      LAST MODIFIED: 06/26/96   BY: *K004* Stephane Collard  */
/* REVISION: 8.6      LAST MODIFIED: 11/05/96   BY: *K01T* Stephane Collard  */
/* REVISION: 8.6      LAST MODIFIED: 11/12/96   BY: *G2H6* Suresh Nayak      */
/* REVISION: 8.6      LAST MODIFIED: 11/15/96   BY: *K01Y* Suresh Nayak      */
/* REVISION: 8.6      LAST MODIFIED: 11/26/96   BY: *K02G* Jean Miller       */
/* REVISION: 8.6      LAST MODIFIED: 11/08/96   BY: *J15C* Markus Barone     */
/* REVISION: 8.6      LAST MODIFIED: 12/19/96   BY: *K022* Dennis Henson     */
/* REVISION: 8.6      LAST MODIFIED: 01/01/97   BY: *K03Y* Dennis Henson     */
/* REVISION: 8.6      LAST MODIFIED: 12/23/96   BY: *J1CR* Sue Poland        */
/* REVISION: 8.6      LAST MODIFIED: 03/04/97   BY: *J1JV* Jim Williams      */
/* REVISION: 8.6      LAST MODIFIED: 04/08/97   BY: *K09W* Arul Victoria     */
/* REVISION: 8.6      LAST MODIFIED: 04/11/97   BY: *K09K* Arul Victoria     */
/* REVISION: 8.6      LAST MODIFIED: 04/08/97   BY: *J1N4* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 05/16/97   BY: *K0DB* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 06/30/97   BY: *K0FL* Taek-Soo Chang    */
/* REVISION: 8.6      LAST MODIFIED: 06/26/97   BY: *K0FM* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 07/15/97   BY: *K0GH* Jean Miller       */
/* REVISION: 8.6      LAST MODIFIED: 07/15/97   BY: *K0G6* Arul Victoria     */
/* REVISION: 8.6      LAST MODIFIED: 06/27/97   BY: *K0DH* Jim Williams      */
/* REVISION: 8.6      LAST MODIFIED: 08/06/96   BY: *J1YB* Sue Poland        */
/* REVISION: 8.6      LAST MODIFIED: 08/12/97   BY: *J1YL* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 07/22/97   BY: *H1B1* Suresh Nayak      */
/* REVISION: 8.6      LAST MODIFIED: 09/05/97   BY: *J1XW* Ajit Deodhar      */
/* REVISION: 8.6      LAST MODIFIED: 09/02/97   BY: *K0HQ* Jim Williams      */
/* REVISION: 8.6      LAST MODIFIED: 09/23/97   BY: *K0J9* Joe Gawel         */
/* REVISION: 8.6      LAST MODIFIED: 09/27/97   BY: *K0HB* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 10/01/97   BY: *K0KH* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 10/08/97   BY: *K0KJ* Joe Gawel         */
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   BY: *K0WG* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 10/21/97   BY: *J236* Manish K.         */
/* REVISION: 8.6      LAST MODIFIED: 10/23/97   BY: *J23M* Niranjan R.       */
/* REVISION: 8.6      LAST MODIFIED: 11/11/97   BY: *K19P* Jean Miller       */
/* REVISION: 8.6      LAST MODIFIED: 11/23/97   BY: *K15N* Jerry Zhou        */
/* REVISION: 8.6      LAST MODIFIED: 12/08/97   BY: *K1BN* Val Portugal      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 03/06/98   BY: *J2FH* D. Tunstall       */
/* REVISION: 8.6E     LAST MODIFIED: 03/16/98   BY: *K1K4* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 03/18/98   BY: *H1JV* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 03/23/98   BY: *H1HQ* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: *J2D8* Kawal Batra       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* Old ECO marker removed, but no ECO header exists *J0HR*                   */
/* REVISION: 8.6E     LAST MODIFIED: 06/03/98   BY: *J2JZ* A. Licha          */
/* REVISION: 8.6E     LAST MODIFIED: 06/06/98   BY: *J2JJ* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 07/09/98   BY: *J2Q9* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 07/12/98   BY: *L024* Sami Kureishy     */
/* REVISION: 8.6E     LAST MODIFIED: 08/05/98   BY: *J2VF* Seema Varma       */
/* REVISION: 8.6E     LAST MODIFIED: 08/11/98   BY: *J2VZ* Surekha Joshi     */
/* REVISION: 8.6E     LAST MODIFIED: 09/04/98   BY: *J2X8* Reetu Kapoor      */
/* REVISION: 9.0      LAST MODIFIED: 11/11/98   BY: *M00R* Sue Poland        */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* Luke Pokic        */
/* REVISION: 9.0      LAST MODIFIED: 12/29/98   BY: *K1YM* Reetu Kapoor      */
/* REVISION: 9.0      LAST MODIFIED: 01/13/99   BY: *J37J* Niranjan R.       */
/* REVISION: 9.0      LAST MODIFIED: 01/27/99   BY: *M06L* Luke Pokic        */
/* REVISION: 9.0      LAST MODIFIED: 02/16/99   BY: *L0DD* Surekha Joshi     */
/* REVISION: 9.0      LAST MODIFIED: 02/08/99   BY: *J39H* Anup Pereira      */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 03/23/99   BY: *J3BF* Anup Pereira      */
/* REVISION: 9.0      LAST MODIFIED: 04/23/99   BY: *K20M* Jyoti Thatte      */
/* REVISION: 9.0      LAST MODIFIED: 06/09/99   BY: *J3GV* Poonam Bahl       */
/* REVISION: 9.0      LAST MODIFIED: 08/10/99   BY: *J3K7* Surekha Joshi     */
/* REVISION: 9.0      LAST MODIFIED: 12/28/99   BY: *L0MP* Surekha Joshi     */
/* REVISION: 9.0      LAST MODIFIED: 04/15/00   BY: *M0LX* Manish K.         */
/* REVISION: 9.0      LAST MODIFIED: 06/22/00   BY: *L100* Abhijeet Thakur   */
/* REVISION: 9.0      LAST MODIFIED: 11/17/00   BY: *M0WD* Kaustubh K        */
/* REVISION: 9.0      LAST MODIFIED: 07/17/00   BY: *L124* Nikita Joshi      */
/* REVISION: 9.0      LAST MODIFIED: 12/12/00   BY: *M0X4* Seema Tyagi       */
/* REVISION: 9.0      LAST MODIFIED: 12/18/00   BY: *M0TZ* Veena Lad         */
/* REVISION: 9.0      LAST MODIFIED: 02/20/01   BY: *M11Y* Rajesh Thomas     */
/* REVISION: 9.0      LAST MODIFIED: 02/23/01   BY: *M11B* Ashwini G.        */
/* REVISION: 9.0      LAST MODIFIED: 03/12/01   BY: *L16Y* Nikita Joshi      */
/* REVISION: 9.0      LAST MODIFIED: 03/20/01   BY: *M11H* Deirdre O'Brien   */
/* REVISION: 9.0      LAST MODIFIED: 04/17/01   BY: *M11Z* Jean Miller       */
/* REVISION: 9.0      LAST MODIFIED: 05/07/01   BY: *M159* Sandeep  P.       */
/* REVISION: 9.0      LAST MODIFIED: 05/24/01   BY: *M17W* Jean Miller       */
/* REVISION: 9.0      LAST MODIFIED: 05/29/01   BY: *M12Q* Inna Lyubarsky    */

/*L024*/ /*  SOME CHANGES WERE MADE TO REDUCE ORACLE COMPILE SIZE */
/*J2VF*/ /* REMOVED UNNECESSARY DO/END BLOCKS & COMBINED SEVERAL  */
/*J2VF*/ /* ASSIGNMENTS TO REDUCE ACTION SEGMENT SIZE             */
/*J2VZ*/ /* REMOVED UNNECESSARY DO/END BLOCKS & COMBINED SEVERAL  */
/*J2VZ*/ /* ASSIGNMENTS TO REDUCE ACTION SEGMENT SIZE             */
/*J2X8*/ /* COMBINED ASSIGN STATEMENT TO REDUCE ACTION SEGMENT SIZE */

         /* NOTE:  Any changes made here may also be needed in fseomtla.p */
         /*!
            SOSOMTLA.P maintains line item information (fields site through
            price) for Sales Orders and RMA's.  It is called by SOSOMTA.P, and
            calls SOSOMTLB.P for user maintenance of other line item fields.
            If this SO/RMA line may update the Installed Base, then it also
            calls SOSOMISB.P.
          */

         /*!
            Input parameters are:

            this-is-rma: Will be yes in RMA Maintenance and no in
                         Sales Order Maintenance.
            rma-recno  : When processing an RMA, this is the rma_mstr
                         (the RMA header) recid.
            rma-issue-line:  When processing RMA's, this will be yes
                         when maintaining the issue (outgoing) lines, and
                         no when maintaining the receipt (incoming) lines.
                         In SO Maintenance, this will be yes.
            rmd-recno  : In RMA Maintenance, this will contain the recid
                         for rmd_det (the RMA line).  For SO Maintenance,
                         this will be ?.
          */

         /*!
            Applies v8.5 pricing to RMA issue lines.  The use of rma-issue-line
            will appear wherever a v8.5 pricing function will occur.  This
            supports both Sales Orders and RMA issue lines.  Where a coverage
            discount applies, it will be treated as a "manual" discount for the
            sake of price list history and any resultant calculation.

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

         {mfdeclre.i}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE sosomtla_p_1 "检查清单"
         /* MaxLen: Comment: */

         /*M00R*  &SCOPED-DEFINE sosomtla_p_2 "SO Returns Update ISB"    */
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtla_p_3 "供应商"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtla_p_4 " 企业物料转移数据 "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtla_p_5 "承诺日期"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtla_p_6 "生效日期"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtla_p_7 "零件无库存"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtla_p_8 "可备料量"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtla_p_9 "采购单号"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtla_p_10 "采购单序号"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtla_p_11 "说明"
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */

         define input parameter this-is-rma     as  logical.
         define input parameter rma-recno       as  recid.
         define input parameter rma-issue-line  as  logical.
         define input parameter rmd-recno       as  recid.

         define shared variable cfexists          like mfc_logical.
         define shared variable cf_rp_part        like mfc_logical  no-undo.
         define new shared variable cf_undo       like mfc_logical.
         define new shared variable cf_sod_rec      as recid.
         define new shared variable cf_config     like mfc_logical.
         define new shared variable cf_rm_old_bom like mfc_logical.
         define new shared variable cf_error_bom  like mfc_logical.
         define new shared variable pt_cf_model     as character format "x(40)".
/*M11Z*/ define new shared variable prev_price    like sod_price    no-undo.
         define shared variable cf_chr              as character.
         define shared variable cf_cfg_path       like mfc_char.
         define shared variable cf_cfg_suf        like mfc_char.
         define shared variable delete_line       like mfc_logical.
         define shared variable cf_cfg_strt_err like mfc_logical.
         define shared variable cf_endcfg like mfc_logical no-undo.
         define shared variable original_model as character format "x(40)".

         /* DEFINE RNDMTHD FOR CALL TO SOSOMTLB.P */
         define shared variable rndmthd like rnd_rnd_mthd.
         define shared variable line like sod_line.
         define shared variable del-yn like mfc_logical.
         define shared variable prev_due like sod_due_date.
         define shared variable prev_qty_ord like sod_qty_ord.
         define shared variable all_days as integer.
         define shared variable so_recno as recid.
         define shared variable sod_recno as recid.
         define new shared variable pcqty like sod_qty_ord.
         define new shared variable desc1 like pt_desc1.
         define new shared variable desc2 like pt_desc2.
         define new shared variable cmtindx like cmt_indx.
         define shared variable sodcmmts like soc_lcmmts label {&sosomtla_p_11}.
         define shared variable prev_abnormal like sod_abnormal.
         define variable modify_sob like mfc_logical initial no
            label {&sosomtla_p_1}.
         define shared variable prev_consume like sod_consume.
         define shared variable consume like sod_consume.
         define shared variable promise_date as date label {&sosomtla_p_5}.
         define shared variable base_amt like ar_amt.
         define shared variable undo_all like mfc_logical.
         define variable yn like mfc_logical.
         define new shared variable old_price like sod_price.
         define new shared variable old_list_pr like sod_list_pr.
         define new shared variable old_disc like sod_disc_pct.
         define shared variable sngl_ln like soc_ln_fmt.
         define shared variable clines as integer.
         define variable open_qty like mrp_qty.
         define  new shared  variable old_site like sod_site.
         define shared variable sod-detail-all like soc_det_all.
         define variable qty_allocatable like in_qty_avail
            label {&sosomtla_p_8}.
         define variable last_sod_price like sod_price.
         define new shared variable totallqty like sod_qty_all.
         define shared variable prev_type like sod_type.
         define shared variable prev_site like sod_site.
         define shared variable sodreldate like sod_due_date.
         define shared variable so_db like dc_name.
         define shared variable inv_db like dc_name.
         define new shared variable undo_all2 like mfc_logical.
         define new shared variable undo_bon  like mfc_logical.
         define shared variable mult_slspsn         like mfc_logical no-undo.
         define shared variable new_line            like mfc_logical.
         define new shared variable prev_confirm    like sod_confirm.
         define new shared variable err_stat        as integer.
         define new shared variable new_site        like sod_site.
         define new shared variable match_pt_um     like mfc_logical.
/*M00R*  define            variable soc_returns_isb like soc__qadl01    */
/*M00R*                             label {&sosomtla_p_2} no-undo.      */
         define            variable return-to-remove-isb as logical no-undo.
         define     shared variable solinerun       as character.
         define new shared variable old_sod_site    like sod_site no-undo.
         define     shared variable freight_ok      like mfc_logical.
         define     shared variable calc_fr         like mfc_logical.
         define     shared variable disp_fr         like mfc_logical.
         define            variable minprice        like pc_min_price.
         define            variable maxprice        like pc_min_price.
         define            variable warning         like mfc_logical initial no.
         define            variable warmess         like mfc_logical
                                                    initial yes.
/*J2VF*/ define            variable l_err_msg       as   character  no-undo.
         define            variable minmaxerr       like mfc_logical.
         define new shared variable lineffdate      like so_due_date.
         define     shared variable soc_pc_line     like mfc_logical.
         define            variable qty_avl         like sod_qty_all.
         define new shared variable prev_qty_ship   like sod_qty_ship.
         define            variable created_by_new_software
                                                    like mfc_logical.
         define new shared variable pm_code         as character.
         define            variable pc_recno        as recid.
         define new shared variable soc_pt_req      like mfc_logical.
         define shared frame c.
         define shared frame d.
         define variable disc_origin like sod_disc_pct.
         define variable chg-db  as logical.
         define variable remote-base-curr like gl_base_curr.
/*L024*  define new shared variable  exch-rate like exd_ent_rate.*/
/*L024* /*L00Y*/ define new shared variable  exch-rate2 like exd_ent_rate.*/
/*L024*/ define new shared variable  exch-rate like exr_rate.
/*L024*/ define new shared variable  exch-rate2 like exr_rate2.
         define variable old_um like sod_um.
         define            variable sobparent        like sob_parent.
         define            variable sobfeature       like sob_feature.
         define            variable sobpart          like sob_part.
         define     shared variable new_order        like mfc_logical.
         define new shared variable pics_type        like pi_cs_type
                                                     initial "9".
         define new shared variable part_type        like pi_part_type
                                                     initial "6".
         define     shared variable picust           like cm_addr.
         define new shared variable err_flag         as integer.

         define new shared variable err-flag        as integer.
         define     shared variable save_qty_ord     like sod_qty_ord.
         define            variable save_um          like sod_um.
         define            variable save_disc_pct    as decimal.
         define            variable new_disc_pct     as decimal.
         define            variable umconv           like sod_um_conv.
         define     shared variable discount         as decimal.
         define     shared variable line_pricing     like mfc_logical.
         define     shared variable reprice          like mfc_logical.
         define     shared variable reprice_dtl      like mfc_logical.
         define            variable minerr           like mfc_logical.
         define            variable maxerr           like mfc_logical.
         define            variable man_disc_pct     as decimal.
         define            variable sys_disc_fact    as decimal.
         define            variable rfact            as integer.
         define            variable minmax_occurred  like mfc_logical
                                                     initial no no-undo.
         define     shared variable save_parent_list like sod_list_pr.
         define            variable frametitle      as character format "x(20)".
         define            variable coverage-discount  like sod_disc_pct.
         define            variable restock-pct        like rma_rstk_pct.

         define  new shared variable s-btb-so        as   logical.
         define new shared variable s-sec-due       as   date.
         define new shared variable prev-btb-type   like sod_btb_type.
         define new shared variable prev-btb-vend   like sod_btb_vend.
         define            variable cfg like sod_cfg_type format "x(3)" no-undo.

         {sobtbvar.i }    /* BACK TO BACK SHARED WORKFILES AND VARIABLES */

         define            buffer   rtsbuff             for rmd_det.

         define            variable disc_min_max       like mfc_logical.
         define            variable disc_pct_err       as decimal
                                    format "->>>>,>>>,>>9.9<<<".
         define            variable last_list_price    like sod_list_pr.
         define new shared variable wk_bs_line  like pih_bonus_line no-undo.
         define new shared variable wk_bs_promo as character format "x(8)"
                                                no-undo.
         define new shared variable wk_bs_price as decimal format ">>>>>>9.99"
                no-undo.
         define new shared variable wk_bs_listid like pih_list_id no-undo.
         define new shared variable restock-amt        like rmd_restock.

         define     shared variable temp_sod_qty_ord like sod_qty_ord.
         define     shared variable temp_sod_qty_ship like sod_qty_ship.
         define     shared variable temp_sod_qty_all like sod_qty_all.
         define     shared variable temp_sod_qty_pick like sod_qty_pick.

         define variable shipper_found as integer no-undo.
         define variable save_abs like abs_par_id no-undo.

/*M11Z*  define            variable btb_ok            as logical no-undo. */
         define new shared variable prev-due-date   like sod_due_date.
         define            variable p-edi-rollback    as logical no-undo
                                                      initial no.

         define variable btb-type      like sod_btb_type format "x(8)" no-undo.
         define variable btb-type-desc like glt_desc                   no-undo.
         define shared variable po-ack-wait      as logical no-undo.
         define variable l_prev_um_conv like sod_um_conv no-undo.
         define variable this_is_edi like mfc_logical initial no.
/*M11Z*  define variable v_picked          like mfc_logical initial no. */
         define variable btb-um-conv like sod_det.sod_um_conv.
         define variable v_failed as logical no-undo.
/*L024*/ define variable sodstdcost like sod_std_cost no-undo.
/*L024*/ define variable mc-error-number like msg_nbr no-undo.
/*M017*/ define variable error_flag      like mfc_logical no-undo.
/*J39H*/ define variable l_undoln        like mfc_logical no-undo.
/*K20M*/ define variable undo_all3       like mfc_logical no-undo.
/*J3K7*/ define variable l_conf_ship     as   integer     no-undo.
/*J3K7*/ define variable l_conf_shid     like abs_par_id  no-undo.
/*J3K7*/ define variable l_undotran      like mfc_logical no-undo.
/*L124*/ define variable l_flag          like mfc_logical no-undo.
/*M11Z* /*M11B*/ define variable l_undo_all4     like mfc_logical no-undo. */
/*M11Z*/ define variable po-err-nbr      like msg_nbr     no-undo.
/*M11Z*/ define variable emt-bu-lvl    like global_part no-undo.
/*M11Z*/ define variable save_part     like global_part no-undo.

/*M12Q*/ define variable apoConnected             as logical no-undo.
/*M12Q*/ define variable apoCompErrorList         as character no-undo.
/*M12Q*/ define variable apoDemandId              as character no-undo.
/*M12Q*/ define variable apoEarliestDate          like sod_due_date no-undo.
/*M12Q*/ define variable apoError                 as logical no-undo.
/*M12Q*/ define variable apoMessageNumber         as integer no-undo.
/*M12Q*/ define variable apoQuantityOnRequestDate like sod_qty_ord no-undo.
/*M12Q*/ define variable apoSiteId                like sod_site no-undo.
/*M12Q*/ define variable completeOrderLine        as logical no-undo.
/*M12Q*/ define variable confirm_yn               like mfc_logical
                                                  initial yes no-undo.
/*M12Q*/ define variable errorResult              as character no-undo.
/*M12Q*/ define variable isConnected              as logical no-undo.
/*M12Q*/ define variable matchApoAtp              as character no-undo.
/*M12Q*/ define variable moduleGroup              as character no-undo.
/*M12Q*/ define variable useApoAtp                as logical no-undo.

         define new shared frame bom.

         FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
sod_sob_std colon 17
            sod_sob_rev colon 17 label {&sosomtla_p_6}
            sod_fa_nbr  colon 17
            space(2)
            sod_lot     colon 17
            cfg         colon 17
          SKIP(.4)  /*GUI*/
with frame bom overlay attr-space side-labels row 9 column 25 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-bom-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame bom = F-bom-title.
 RECT-FRAME-LABEL:HIDDEN in frame bom = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame bom =
  FRAME bom:HEIGHT-PIXELS - RECT-FRAME:Y in frame bom - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME bom = FRAME bom:WIDTH-CHARS - .5.  /*GUI*/


         {pppiwkpi.i "new"} /*Pricing workfile definition*/
         {pppivar.i}        /*Pricing variables*/
         {pppiwqty.i}       /*Reprice workfile definition*/

         {mfdatev.i}

         /*V8:HiddenDownFrame=c*/

         /*DEFINE FORMS*/
         {solinfrm.i}

         define new shared frame btb_data.

         FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
btb-type         colon 20
            sod_site         colon 60
            sod_btb_vend     colon 20  label {&sosomtla_p_3}
            pod_due_date     colon 60
            sod_btb_po       colon 20  label {&sosomtla_p_9}
            pod_need         colon 60
            sod_btb_pod_line colon 20  label {&sosomtla_p_10}
          SKIP(.4)  /*GUI*/
with frame btb_data
         
         side-labels width 80 attr-space overlay row 10 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-btb_data-title AS CHARACTER.
 F-btb_data-title = {&sosomtla_p_4}.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame btb_data = F-btb_data-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame btb_data =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame btb_data + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame btb_data =
  FRAME btb_data:HEIGHT-PIXELS - RECT-FRAME:Y in frame btb_data - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME btb_data = FRAME btb_data:WIDTH-CHARS - .5. /*GUI*/


/*K20M*/ assign
/*K20M*/    undo_all3 = yes
            undo_all  = yes.

         assign
            exclude_confg_disc = no
            select_confg_disc  = no
            found_confg_disc   = no.

loopc:
do on error undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


   view frame c.

   if sngl_ln then view frame d.

   find so_mstr where recid(so_mstr) = so_recno.
   find sod_det where recid(sod_det) = sod_recno.

/*M12Q Added Code */

   /* When an APO ATP request was processed with insufficient demand, */
   /* the user may choose to modify the order line to match the APO   */
   /* ATP results.  If the apoEarliestDate field is populated, this   */
   /* indicates that the user has chosen to override the original     */
   /* input with data returned from APO ATP.                          */
   /* Order line site, date and quantity are modified to the APO ATP  */
   /* site, date and quantity only for:                               */
   /* - multi line order entry or                                     */
   /* - single line order entry when quantity has changed or          */
   /* - site has changed                                              */

   run updateWithApoAtpData.

/*M12Q End Added Code */

         if this-is-rma then do:

            find rma_mstr where recid(rma_mstr) = rma-recno
                exclusive-lock no-error.

            restock-pct = rma_rstk_pct.
            find eu_mstr where eu_addr = rma_enduser no-lock no-error.
            {fssvsel.i rma_ctype """" eu_type}
            find rmd_det where recid(rmd_det) = rmd-recno
                 exclusive-lock no-error.
            if available rmd_det then
               restock-amt = rmd_restock.
            find first rmc_ctrl no-lock no-error.
         end.

         find first soc_ctrl no-lock.
/*M00R*  soc_returns_isb = soc__qadl01. */

/*M11Z*/ /* If EMT is in use, capture the existing sod_det */
/*M11Z*/ if soc_use_btb and not new_line then do:
/*M11Z*/    {gprunp.i "soemttrg" "p" "create-temp-sod-det"
               "(input so_nbr, input sod_line)"}
/*M11Z*/ end.

         find first gl_ctrl no-lock.
         find first svc_ctrl no-lock no-error.
         find first pic_ctrl no-lock.

/*J2JZ*/ /* THE FOLLOWING ASSIGNMENTS WERE MOVED TO A SINGLE ASSIGN STATEMENT */
/*J2JZ*/ /* DUE TO ACTION SEGMENT VIOLATION.                                  */

/*J2JZ** BEGIN DELETE **
 * /*J042*/ if pic_so_fact then
 * /*J042*/    rfact = pic_so_rfact.
 * /*J042*/ else
 * /*J042*/    rfact = pic_so_rfact + 2.
 *J2JZ** END DELETE  */

/*M12Q*/ run getPriceTableRequiredFlag.

/*M12Q* * * MOVE TO AN INTERNAL PROCEDURE *
 *         /* Read price table required flag from mfc_ctrl */
 *         find first mfc_ctrl where mfc_field = "soc_pt_req" no-lock no-error.
 *        if available mfc_ctrl then soc_pt_req = mfc_logical.
 *M12Q*/

/*J2JZ*/ assign
/*J2JZ*/    rfact            = if pic_so_fact then
/*J2JZ*/                          pic_so_rfact
/*J2JZ*/                       else
/*J2JZ*/                          pic_so_rfact + 2
            last_sod_price   = sod_price.

         status input.
/*J2FH** line = sod_line.         */
/*J2FH** desc1 = {&sosomtla_p_7}.*/

/*M12Q*/ run setOrderLineAndDesc.

/*M12Q* * BEGIN DELETE SECTION *
 * /*J2FH*/ assign
 * /*J2FH*/     line = sod_line
 * /*J2FH*/     desc1 = {&sosomtla_p_7}
 *          desc2 = "".
 *
 *          find pt_mstr where pt_part = sod_part no-lock no-error.
 *          if available pt_mstr then do:
 * /*J2FH*     desc1 = pt_desc1.    */
 * /*J2FH*/    assign
 * /*J2FH*/       desc1 = pt_desc1
 *                desc2 = pt_desc2.
 *                if sod_desc <> "" then
 *                   sod_desc = "".
 *          end.
 *             else if sod_desc <> "" then
 *               desc1 = sod_desc.
 *M12Q* * * END DELETE SECTION */

         /* SET GLOBAL PART VARIABLE */
         global_part = sod_part.

         /* Check the RMA Discount to see if complies with pic_ctrl */
         run p-disc-disp (input no).

         /* NOTE ABOUT QUANTITIES ON RMA'S:  THE QTY ORDERED IS STORED */
         /* IN BOTH SOD_DET AND RMD_DET.  IN RMD_DET, THE QUANTITY IS  */
         /* ALWAYS POSITIVE.  FOR RMA ISSUE LINES (REMEMBER, THESE ARE */
         /* REPAIRED/REPLACEMENT ITEMS WE'RE SENDING TO THE CUSTOMER), */
         /* SOD_QTY_ORD IS POSITIVE (IN FACT, WE DON'T WANT TO ALLOW   */
         /* NEGATIVES FOR RMA'S).  FOR RMA RECEIPT LINES, HOWEVER,     */
         /* (REMEMBER, THESE ARE FOR THE DEFECTIVE/BROKEN ITEMS THE    */
         /* CUSTOMER IS RETURNING) SOD_QTY_ORD IS NEGATIVE.            */
         /* FOR NEW RMA RECEIPT LINES, DON'T DISPLAY PRICE BECAUSE     */
         /* RESTOCKING CHARGES HAVEN'T BEEN CALCULATED YET.            */

         if this-is-rma and not rma-issue-line then
            display
               line
               sod_part
               (sod_qty_ord * -1) @ sod_qty_ord
               sod_um
               sod_list_pr  when (not new_line)
               discount
               sod_price when (not new_line)
            with frame c.
         else
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
               sod_qty_all sod_qty_pick sod_qty_ship sod_qty_inv
               sod_site sod_loc sod_serial
               sod_std_cost desc1 base_curr
               sod_req_date sod_per_date sod_due_date
               sod_pricing_dt
               sod_fr_list
               sod_acct sod_cc sod_dsc_acct sod_dsc_cc
               sod_project sod_confirm
               sod_type sod_um_conv sod_consume sod-detail-all
               sod_taxable sod_taxc
               (sod_cmtindx <> 0 or (new_line and soc_lcmmts)) @ sodcmmts
               sod_slspsn[1] mult_slspsn sod_comm_pct[1]
               sod_crt_int sod_fix_pr
            with frame d.

         /* REMEMBER, FOR RMA RECEIPT LINES, THE SOD_QTY'S ARE NEGATIVE */
         /* BUT THE USER WOULD PREFER SEEING POSITIVE NUMBERS...        */
         if sngl_ln and this-is-rma and not rma-issue-line then
               display
                  (sod_qty_ship * -1) @ sod_qty_ship
                  (sod_qty_inv * -1)  @ sod_qty_inv
            with frame d.

         /* CALL INTERNAL PROCEDURE p-btb-ok.                           */
         /* TEST FOR BTB ORDER LINE. IF FOUND AND PRIMARY S.O. WITH     */
         /* RELATED P.O. STATUS REFLECTING SOME PROCESSING AT THE       */
         /* SECONDARY S.O. OR THIS IS A SECONDARY S.O. AND THE LINE IS  */
         /* A CONFIGURED ITEM, THEN PREVENT ANY CHANGES.  UNDO LOOPC    */
         /* AND RETURN TO sosomta.p.                                    */
/*M11Z*     v_picked = no. */
            run p-btb-ok
/*M11Z*/       (output error_flag,
                output po-err-nbr).
/*M11Z*/    if error_flag then do:
/*M11Z*/       undo_all = yes.
/*M11Z*/       undo loopc, leave loopc.
/*M11Z*/    end.
/*M11Z*/    /* This logic is now handled in p-btb-ok and above lines *****
 *          if v_picked then do:
 *             {mfmsg.i 2023 3}  /* INVENTORY PICKED AT SUPPLIER */
 *             if not batchrun then pause.
 *             undo_all = yes.
 *             undo loopc, leave loopc.
 *          end.
 *
 *          if not btb_ok then do:
 *             {mfmsg.i 2859 3} /* CANNOT CHANGE BTB SALES ORDER LINE */
 *             if not batchrun then pause.
 *             undo_all = yes.  /* CAUSES sosomta.p TO UNDO MAINLOOP  */
 *             undo loopc, leave loopc.
 *          end.
 **********************/ /*M11Z*/

         assign
            prev_confirm  = sod_confirm
            prev_type     = sod_type
            prev_site     = sod_site
/*M11Z*/    prev_price     = sod_price
            prev_due      = sod_due_date
            prev_qty_ord  = sod_qty_ord * sod_um_conv
            prev_abnormal = sod_abnormal
            prev_consume  = sod_consume
            del-yn        = no.

         /*SAVE CURRENT QTY ORDERED,UM, AND PARENT LIST TO DETERMINE
          * DIFFERENCE IF QTY, UM, OR PARENT LIST CHANGED WHEN CALLING
          * THE PRICING ROUTINES*/

/*M12Q*/ run saveCurrentQtyPricingInfo.

/*M12Q *** BEGIN DELETE  - Moved to Internal Procedure section
 *         if rma-issue-line and (line_pricing or not new_order)
 *         then do:
 * /*J2FH*/ assign
 * /*J2FH*/    save_qty_ord = sod_qty_ord
 *             save_um      = sod_um.
 *             if can-find(first sob_det where sob_nbr  = sod_nbr and
 *                                             sob_line = sod_line) then do:
 *                find first pih_hist where pih_doc_type = 1        and
 *                                          pih_nbr      = sod_nbr  and
 *                                          pih_line     = sod_line and
 *                                          pih_parent   = ""       and
 *                                          pih_feature  = ""       and
 *                                          pih_option   = ""       and
 *                                          pih_amt_type = "1"
 *                                    no-lock no-error.
 *                if available pih_hist then
 *                   save_parent_list = pih_amt.
 *                else do:
 *                   save_parent_list = 0.
 *                   for each sob_det where
 *                               sob_nbr  = sod_nbr and
 *                               sob_line = sod_line
 *                      no-lock:
 *                      save_parent_list = save_parent_list + sob_tot_std.
 *                   end.
 *                   save_parent_list = sod_list_pr - save_parent_list.
 *                end.
 *             end.
 *             else
 *                save_parent_list = sod_list_pr.
 *             end. /* if rma-issue-line ... */
 *M12Q *** END DELETE */

         /* ORDER QUANTITY */
         if not sod_sched then do:

         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


/*J2X8*/ assign
            ststatus = stline[2]
/*J2X8*/    old_sod_site = sod_site.

            status input ststatus.
/*J2X8** old_sod_site = sod_site. */

         find pt_mstr no-lock where pt_part = sod_part no-error.
         if available pt_mstr then do:
            pm_code = pt_pm_code.

/*J2D8*/    run find-ptp-j2d8 (input pt_part, input sod_site).

          end.
/* After a line that was a Concinity 'end configuration' we need to reset it */
/* But, if cf_rp_part = yes, this is the replacement pass, so don't reset it */
                if cf_rp_part = no then assign cf_endcfg = no.

         /* Get ready for 'end item' and 'end configuration' from Calico */
                if cfexists then assign cf_rp_part = no.

/* BECAUSE OF THE CONVERTER PROGRAM POSSIBILITIES WE NEED TO USE THIS EXTERNAL*/
/* PROCEDURE TO REDUCE THE PROGRAM SIZE                                       */
/* BTB CHANGES TO PRIMARY SO - CHANGE PO - SITE MAINTENANCE                   */
/*J2FH*/ /*ADDED FOURTH OUTPUT PARAMETER UNDO_ALL                             */
/*K20M*/ /*REPLACED FOURTH OUTPUT PARAMETER TO undo_all3 FROM undo_all        */
         {gprun.i ""sobtbla2.p""
                   "(input this-is-rma,
                     input rma-issue-line,
                     input rmd-recno,
                     output undo_all3)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*K20M** /*J2FH*/ if undo_all then do :   */
/*K20M*/ if undo_all3 then do :
/*J2FH*/    undo loopc, leave loopc.
/*J2FH*/ end. /* IF UNDO_ALL3 */

         if keyfunction(lastkey) = "end-error" then undo loopc, leave loopc.
         if sngl_ln then
            display sod_site with frame d.

         /* Determine whether item is calico controlled*/
         /* If we have just replaced the item with the 'end configuration' item, */
         /* Then, skip running cfsocfg1.p */
         if cfexists and not cf_endcfg then do:
            cf_sod_rec = recid(sod_det).
            if recid(sod_det) = - 1 then.
            cf_undo = yes.
            {gprunmo.i
               &module  = "cf"
               &program = "cfsocfg1.p"
            }
            if cf_undo and not del-yn then undo loopc, leave.
         end. /*cfexists*/
         else
/*L024*     do:  */
         /* If we have just replaced the item with the 'end configuration' item, */
         /* Then, skip running cfsocfg1.p */
/*L024*     if cfexists and cf_endcfg then do: */
/*L024*/    if cfexists and cf_endcfg then
                   assign
                      cf_config = yes
                      cf_rm_old_bom = yes
                      pt_cf_model = original_model
                      cf_endcfg = no.
/*L024*     end.  */
/*L024*  end.     */
         if cf_config and cf_rm_old_bom then do:
            delete_line = yes.
            /* DELETE THE SALES ORDER BILL */
            {gprun.i ""sosomtk.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

            delete_line = no.
            {gprun.i ""gppihdel.p"" "(1, sod_nbr, sod_line)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            /* WE NEED TO MAKE SURE WE ALWAYS REPRICE, NO USER OPTION */
            reprice_dtl = yes.
         end.

         /* Del-yn = yes if configurator returns a replcement item   */
         /* and User wishes to use this item and delete any exisitng */
         /* line Information. cf_undo = yes if error occued in the   */
         /* program or  For example, the user tried to enter a sq    */
         /* line for a concinity Controlled item and they were on a  */
         /* unix platform etc.                                       */

         /* QUANTITY, ORDER UNIT OF MEASURE */
         if not del-yn then do:

/*J2X8*/   assign
             old_um = sod_um
             l_prev_um_conv = sod_um_conv.

                     /* Check for APM Item */
/*M017*/    if available pt_mstr and soc_apm then do:

/*M017*/       for first cm_mstr no-lock
/*M017*/          where cm_addr = so_cust: end.

/*M017*/       if available cm_mstr and cm_promo <> "" then do:
/*M017*/                  {gprun.i ""sosoapm2.p""
                             "(input cm_addr,
                 input sod_nbr,
                 input sod_line,
                             output error_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*M017*/          if error_flag then do:
/*M017*/             undo loopc, leave.
/*M017*/          end.
/*M017*/          /* REDISPLAY ITEM DESCRIPTION AND QUANTITY AVAILABLE */
/*M06L*/          pause 0.
/*M06L /*M017*/      if desc2 <> "" or not sngl_ln then message desc1 desc2. */
/*M06L*/          message desc1 desc2.
/*M017*/          {gprun.i ""gpavlsi3.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*M017*/          /* RESET STATUS LINE TO ORIGINAL VALUE */
/*M017*/          ststatus = stline[2].  /* ENABLE F5 CTRL-D */
/*M017*/          status input ststatus.
/*M017*/       end. /* IF AVAILABLE CM_MSTR AND CM_PROMO */

/*M017*/    end.  /* IF AVAILABLE PT_MSTR AND SOC_APM */

             /* Display Quantity Ordered, UOM */
             display
                sod_qty_ord
                sod_um
             with frame c.

            if this-is-rma and not rma-issue-line then
                        display
                           (sod_qty_ord * -1) @ sod_qty_ord
                with frame c.

            set1:
            do with frame c on error undo,
            retry on endkey undo, leave loopc:
/*GUI*/ if global-beam-me-up then undo, leave.


/*M12Q*/       run rollBackValues.

/*M12Q *** BEGIN DELETE  - Moved to Internal Procedure section
 *              s-cmdval = string(sod_qty_ord, "->,>>>,>>9.9<<<<<<<" ).
 *
 *              prev_qty_ord = sod_qty_ord * sod_um_conv.
 *
 *              /* GET ROLL-BACK VALUES WHEN RELEVANT */
 *              /* ADDED input parameter p-edi-rollback */
 *              {gprun.i ""sobtbrb.p""
 *                       "(input recid(so_mstr),
 *                         input sod_line,
 *                         input ""pod_det"",
 *                         input ""pod_qty_ord"",
 *                         input p-edi-rollback,
 *                         output return-msg)" }
 *M12Q *** END DELETE */

               /* DISPLAY ERROR MESSAGE RETURN FROM SOBTBRB.P */
               if return-msg <> 0 then do:
                  {mfmsg.i return-msg 3}
                  return-msg = 0.
                  if not batchrun then pause.
                  undo set1, leave.
               end.

               sod_qty_ord  = decimal(s-cmdval).

               display
                  sod_qty_ord
               with frame c.

               if this-is-rma and not rma-issue-line then
                  display (sod_qty_ord * -1) @ sod_qty_ord
                  with frame c.

               set
                  sod_qty_ord when (not po-ack-wait)
                   sod_um      when (not po-ack-wait)
               go-on ("F5" "CTRL-D") with frame c.
               if not new_line and available pt_mstr and pt_pm_code = "C"
               and input sod_um <> old_um then do:
                  {mfmsg.i 685 1} /* Unit of measure change not allowed */
                  next-prompt sod_um with frame c.
                  undo set1, retry.
               end.

               if available pt_mstr and pt_lot_ser = "s" and  pt_um <> sod_um
               then do:
                  /* UM MUST EQUAL TO STOCKING UM FOR SERIAL-CONTROLLED */
                  /* ITEM */
                  {mfmsg.i 367 3}
                  next-prompt sod_um with frame c.
                  undo set1,retry.
               end. /* IF AVAILABLE PT_MSTR */

               /* DON'T ALLOW NEGATIVE QUANTITY ORDERED ON BTB SO */
               if sod_qty_ord < 0 and s-btb-so then do:
                  {mfmsg.i 2854 3} /* Returns not allowed for BTB SO */
                  undo set1, retry set1.
               end.

               /* MULTI EMT DO NOT ALLOW QTY CHANGE AT THE SBU */
               if prev_qty_ord <> sod_qty_ord * sod_um_conv and
               not new_line and so_secondary and
               (sod_btb_type = "02" or sod_btb_type = "03") then do:
                  {mfmsg.i 2825 3} /* Change not allowed for BTB SO */
                  undo set1, retry set1.
               end.

               /* MULTI EMT DO NOT ALLOW QTY CHANGE AT THE SBU */
               if old_um <>  sod_um and
               not new_line and so_secondary and
               (sod_btb_type = "02" or sod_btb_type = "03") then do:
                  {mfmsg.i 2825 3} /* Change not allowed for BTB SO */
                  next-prompt sod_um with frame c.
                  undo set1, retry set1.
               end.

               /* VALIDATE MODIFICATION OF SOD_QTY_ORD IN CASE OF BTB */
               btb-um-conv = sod_um_conv.
               {mfumcnv.i sod_um sod_part btb-um-conv}

/*M159**       if prev_qty_ord <> sod_qty_ord * btb-um-conv */
/*M159**       and not new_line then do:                    */

/*M159*/       if (prev_qty_ord <> (sod_qty_ord * btb-um-conv)
/*M159*/           or old_um <> sod_um)
/*M159*/          and not new_line
/*M159*/       then do:

/*M11Z*/ /*** Moved logic to external procedure: soemttrg.p ****
 *                /* PRIMARY SO */
 *                if not so_secondary and soc_use_btb then do:
 *
 *                /* TRANSMIT CHANGES ON PRIM. SO TO PO AND SEC. SO */
 *                {gprun.i ""sosobtb1.p""
 *                       "(input recid(sod_det),
 *                         input no,
 *                         input ""?"",
 *                         input ""?"",
 *                         input sod_qty_ord,
 *                         input ?,
 *                         input ?,
 *                         input ""?"",
 *                         input no,
 *                         output return-msg)" }
 *
 *                    /* DISPLAY ERROR MESSAGE RETURN FROM SOSOBTB1.P */
 *                    if return-msg <> 0 then do:
 *                       {mfmsg.i return-msg 3}
 *                       return-msg = 0.
 *                       if not batchrun then pause.
 *                       undo set1, retry set1.
 *                    end.
 *
 *                 end. /* primary SO */
 **************************/ /*M11Z*/

                   /* SECONDARY SO - MUST BE LEVEL 3 */
                   /* LEVEL 2 NOT PERMITTED THIS FAR */
                  if so_secondary then do:

                      /* TRANSMIT CHANGES ON SECONDARY SO TO */
                      /* PRIMARY PO AND SO                  */
                     {gprun.i ""sosobtb2.p""
                              "(input recid(sod_det),
                                input ""sod_qty_ord"",
                                input string(prev_qty_ord),
                                output return-msg)" }
/*GUI*/ if global-beam-me-up then undo, leave.


                     /* DISPLAY ERROR MESSAGE RETURN FROM SOSOBTB2.P */
                     if return-msg <> 0 then do:
                        {mfmsg.i return-msg 3}
                        return-msg = 0.
                        if not batchrun then pause.
                        undo set1, retry set1.
                     end.

                  end. /* secundary SO */

               end. /* change of quantity ordered */

/*M11Z*/ /***************************************************
 * /*K1K4*/       if soc_use_btb and sod_btb_type <> "01" then do:
 *                 /* CHECK IF ORDER QTY CORRESPONDS TO ORDER MODIFIERS */
 *                 if sod_qty_ord > 0 then do:
 *
 *                    warning = no.
 *
 *                    /* CHECK ITEM/SITE DATA FIRST */
 *                    find ptp_det where ptp_part = sod_part
 *                    and ptp_site = sod_site no-lock no-error.
 *
 *                    if available ptp_det
 * /*M11Y*            and ((ptp_ord_max <> 0 and sod_qty_ord > ptp_ord_max) */
 * /*M11Y*/           then do:
 * /*M11Y*/              if ((ptp_ord_max <> 0 and sod_qty_ord > ptp_ord_max)
 *                       or (ptp_ord_min <> 0 and sod_qty_ord < ptp_ord_min)
 *                       or (ptp_ord_mult <> 0
 *                           and sod_qty_ord modulo ptp_ord_mult <> 0)
 *                                 )
 *                       then
 *                          warning = yes.
 * /*M11Y*/           end.
 *
 *                    /* CHECK ITEM MASTER */
 *                    else do:
 *                        find pt_mstr where pt_part = sod_part
 *                        no-lock no-error.
 *
 *                       if  available pt_mstr
 *                       and ( (pt_ord_max <> 0  and sod_qty_ord > pt_ord_max)
 *                          or (pt_ord_min <> 0  and sod_qty_ord < pt_ord_min)
 *                          or (pt_ord_mult <> 0
 *                                     and sod_qty_ord modulo pt_ord_mult <> 0) )
 *                       then warning = yes.
 *                    end.  /* check on pt_mstr */
 **************************/ /*M11Z*/

                  /* CHECK IF ORDER QTY CORRESPONDS TO ORDER MODIFIERS */
/*M11Z*/          warning = no.
/*M11Z*/          if soc_use_btb and sod_btb_type <> "01" and
/*M11Z*/                     sod_qty_ord > 0
/*M11Z*/          then do:
/*M11Z*/             run check-order-modifiers
/*M11Z*/                (output warning).

                     if warning = yes then do:
                        {mfmsg.i 2811 2}
                        /* Qty is not according to the Order Modifiers */
                        if not batchrun then pause.
                     end.

/*M11Z*/          end.

/*M11Z*           end. /* if soc_use_btb */ */

               /* FOR RMA'S, THE USER MAY NOT ENTER NEGATIVE ORDER QUANTITY */
               /* IF THIS IS A RECEIPT LINE, WE MUST REVERSE THE SIGN ON    */
               /* THE QUANTITY THEY DO ENTER - RECALL THAT FOR RECEIPTS,    */
               /* SOD_QTY_ORD IS NEGATIVE AND RMD_QTY_ORD IS POSITIVE...    */
               if this-is-rma then do:
                    if sod_qty_ord < 0 then do:
                        {mfmsg.i 234 3}  /* ORDER QTY CANNOT BE NEGATIVE */
                        next-prompt sod_qty_ord with frame c.
                        undo set1, retry.
                    end.
                    if not rma-issue-line then
                        assign sod_qty_ord = -1 *  sod_qty_ord.

                    /* FOR RMA RECEIPT LINES, WARN USER IF HE ENTERS AN ORDER */
                    /* QTY TOO SMALL FOR WHAT'S ALREADY BEEN RECEIVED.        */
                    /* (THIS WAS A WARNING IN FSRMAREC.P ALSO)                */
                    if not rma-issue-line and (sod_qty_chg + sod_qty_ship)
                        < sod_qty_ord then do:
                        {mfmsg.i 7201 2}
                        /* QTY TO RECEIVE + QTY RECEIVED > QTY EXPECTED */
                    end.
              end.  /* if this-is-rma */

              /* CONFIRM DELETE */
              if lastkey = keycode("F5")
              or lastkey = keycode("CTRL-D")
              then do:
                 /* IF THIS IS AN RMA LINE, CHECK FOR LINKED RTS    */
                 /* LINES.  IF ANY, WARN USER OF LINKAGE.           */
                 if this-is-rma then do:
/*L024*                 if rma-issue-line then do: */
/*L024*                 end.    /* if rma-issue-line */ */
/*L024*                 else do for rtsbuff: */
/*L024*/                if not rma-issue-line then do for rtsbuff:
                           find rtsbuff
                              where rtsbuff.rmd_nbr    = rmd_det.rmd_rma_nbr
                              and   rtsbuff.rmd_prefix = "V"
                              and   rtsbuff.rmd_line   = rmd_det.rmd_rma_line
                              no-lock no-error.
                           if available rtsbuff then do:
                              {mfmsg.i 1120 2}
                           /* THIS RMA LINE IS LINKED TO ONE OR MORE RTS LINES */
                           end.
                        end.    /* else, rma-receipt-line, do */
                 end.   /* if this-is-rma */
                 del-yn = yes.
                 {mfmsg01.i 11 1 del-yn}
                 if sod_qty_inv <> 0 and del-yn then do:
                    {mfmsg.i 604 3} /* Outstanding qty to inv, */
                    undo.           /* delete not allowed.     */
                 end.

/*M11H*/         /* Do not allow user delete of Sales Orders */
/*M11H*/         /* Which are owned by an external system. */
/*M11H*/         if so_app_owner > "" then do:
/*M11H*/            /* Cannot Process.  Document owned by application # */
/*M11H*/            undo.
/*M11H*/         end.

/*J3K7*/         l_undotran = no.

/*J3K7*/         /* CHECK FOR EXISTENCE OF CONFIRMED/UNCONFIRMED SHIPPER */
/*J3K7*/         run p-shipper-check.

/*J3K7*/         /* DO NOT ALLOW TO DELETE ORDER LINE, IF UNCONFIRMED */
/*J3K7*/         /* SHIPPER EXISTS                                    */
/*J3K7*/         if l_undotran then
/*J3K7*/            undo.

/*J3K7*/         /* COMMENTED BELOW CODE AND MOVED IT TO INTERNAL PROCEDURE */
/*J3K7*/         /* P-SHIPPER-CHECK, TO REDUCE ACTION SEGMENT SIZE          */

/*J3K7*** BEGIN DELETE ***
 *               shipper_found = 0.
 *               {gprun.i ""rcsddelb.p"" "(input sod_nbr, input sod_line,
 *               input sod_site, output shipper_found, output save_abs)"}
 *               if shipper_found > 0 then do:
 *                  {mfmsg03.i 1118 3 shipper_found save_abs """"}
 *                  /* # SHIPPERS/CONTAINERS EXISTS FOR ORDER, INCLUDING # */
 *                  undo.
 *               end.
 *J3K7*** END DELETE ***/

                 if del-yn then do:
                    /*DELETE COMMENTS*/
                    for each cmt_det where cmt_indx = sod_cmtindx
                       exclusive-lock:
                       delete cmt_det.
                    end.
                 end.
              end.

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* set1 */

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* del-yn do */

         end. /* do on error... */

   end. /* if not sod_sched */

         else do:
            pause 0.
            {mfmsg.i 6014 1} /* Schedule exists for this order line */
         end.

/*L024*  if del-yn then do: */
/*L024*/ if del-yn then
            assign
               prev_qty_ship     = sod_qty_ship * sod_um_conv
               temp_sod_qty_ord  = sod_qty_ord
               temp_sod_qty_ship = sod_qty_ship
               temp_sod_qty_all  = sod_qty_all
               temp_sod_qty_pick = sod_qty_pick
               sod_qty_ord       = 0
               sod_qty_ship      = 0
               sod_qty_all       = 0
               sod_qty_pick      = 0.
/*L024*  end. */
   else do:

      ststatus = stline[3].
      status input ststatus.

      /* CALCULATE UM CONVERSION */
        {mfumcnv.i sod_um sod_part sod_um_conv}

/*H1HQ*/ if new_line and not sngl_ln and calc_fr then
/*H1HQ*/    run p-calc-fr-wt.

      /* CALCULATE COST ACCORDING TO UM */
         if available pt_mstr then do:

/*H1JV*/    remote-base-curr = base_curr.

            /* Find out if we need to change databases */
/*M12Q*/    run checkWhetherToChangeDB.

/*M12Q *** BEGIN DELETE  - Moved to Internal Procedure section
 *           find si_mstr where si_site = sod_site no-lock.
 *           chg-db = (si_db <> so_db).
 *           if chg-db then do:
 *             /* Switch to the Inventory site */
 *             {gprun.i ""gpalias2.p"" "(sod_site,output err-flag)" }
 *
 *             if err-flag = 0 or err-flag = 9 then do:
 *                {gprun.i ""gpbascur.p"" "(output remote-base-curr)"}
 *             end.
 *
 *           end.
 *
 *           /* Find the Cost Set */
 *           {gprun.i ""gpsct05.p""
 *                   "(input sod_part,input sod_site,input 1,
 *                     output glxcst,output curcst)"}
 *M12Q *** END DELETE */

/*L024*     exch-rate = 1. */
/*L024*     if remote-base-curr <> base_curr then do: */

/*L024**    BEGIN DELETE **********
 *          {gpgtex8.i &ent_curr  = base_curr
 *                     &curr      = remote-base-curr
 *                     &date      = so_ord_date
 *                     &exch_from = exd_ent_rate
 *                     &exch_to   = exch-rate}
 *
 *L024**    END DELETE   **********/

 /*M0WD**    BEGIN DELETE *
  * /*L024*/    {gprunp.i "mcpl" "p" "mc-get-ex-rate"
  *               "(input  base_curr,
  *                 input  remote-base-curr,
  *                 input  """",
  *                 input  so_ord_date,
  *                 output exch-rate2,
  *                 output exch-rate,
  *                 output mc-error-number)" }
  * /*L024*/    if mc-error-number <> 0 then do:
  * /*L024*/       {mfmsg.i mc-error-number 2}
  *             end.
  *M0WD**     END DELETE */

/*M12Q *** BEGIN DELETE  - Moved to checkWhetherToChangeDB Internal Procedure *
 *           if chg-db then do:
 *              /* Switch the database alias back to the sales order db */
 *              {gprun.i ""gpalias3.p"" "(so_db,output err-flag)" }
 *           end.
 *M12Q *** END DELETE */

/*M0WD*/    {gprunp.i "mcpl" "p" "mc-get-ex-rate"
               "(input  base_curr,
                 input  remote-base-curr,
                 input  """",
                 input  so_ord_date,
                 output exch-rate2,
                 output exch-rate,
                 output mc-error-number)" }
/*M0WD*/    if mc-error-number <> 0 then
/*M0WD*/    do:
/*M0WD*/       {mfmsg.i mc-error-number 2}
/*M0WD*/    end. /* IF mc-error-number <> 0 */

            if new sod_det or (not new sod_det and pt_pm_code <> "C") then
               sod_std_cost = glxcst * sod_um_conv.

         end.

/*J2VF** if new sod_det and available pt_mstr then do: */
/*J2VF*/ if new sod_det and available pt_mstr then
/*H1HQ*/    assign
/*H1HQ*/       sod_price = sod_price * sod_um_conv
/*H1HQ*/       sod_list_pr = sod_list_pr * sod_um_conv.
/*J2VF** end. */

         /* POP-UP FOR REQUIRED ITEMS BEFORE PRICING */
         if sngl_ln and (rma-issue-line or (not reprice and not new_order))
         then do:
            if sod_sched then
               pause 2.

            update sod_pricing_dt when (rma-issue-line and soc_pc_line)
                   sod_crt_int    when (rma-issue-line and soc_pc_line)
                   reprice_dtl    when (not reprice_dtl and not new_order)
                   sod_pr_list    when (rma-issue-line)
            with frame line_pop.
            display sod_pricing_dt
                    sod_crt_int
            with frame d.
            hide frame line_pop no-pause.
            pause 0.
         end.

/*L024*  if sngl_ln and available pt_mstr then */
/* PROCEDURE sod-conv CREATED TO OVERCOME ORACLE COMPILE SIZE LIMITATION */
/*L024*/ if sngl_ln and available pt_mstr then do:
/*L024*/    /* Convert cost from remote to local base currency */
/*L024*/    run sod-conv (input sod_std_cost, output sodstdcost).
/*L024*     display sod_std_cost * exch-rate @ sod_std_cost */
/*L024*/    display sodstdcost @ sod_std_cost
                    sod_um_conv with frame d.
/*L024*/ end.  /* if sngl_ln and available pt_mstr */

         /* MOVED THE UPDATING OF pm_code FROM JUST ABOVE CALL TO */
         /* Sosomtf8.p TO HERE IN ORDER TO UPDATE THE             */
         /* Exclude_confg_disc VARIABLE WHICH gppibx.p FOR        */
         /* DISCOUNTS MUST TEST FOR.                              */
         pm_code = "".
         if available pt_mstr then pm_code = pt_pm_code.

/*J2D8*/ run find-ptp-j2d8 (input sod_part, input sod_site).

         if pm_code = "C" then
            exclude_confg_disc = yes.

/*M11Z*/ if pm_code = "C" and reprice_dtl and
/*M11Z*/    (po-err-nbr = 4619 or po-err-nbr = 4617)
/*M11Z*/ then do:
/*M11Z*/    /* Order in process at SBU. Cannot re-configure */
/*M11Z*/    {mfmsg.i 4638 4}
/*M11Z*/    reprice_dtl = no.
/*M11Z*/    if not batchrun then pause.
/*M11Z*/ end.

/*J2X8*/ if rma-issue-line then
/*J2X8*/    assign min_price = 0
/*J2X8*/           max_price = 0.

         /* INITIALIZE PRICING VARIABLES AND PRICING WORKFILE
            wkpi_wkfl FOR CURRENT sod_part*/
         if rma-issue-line and (line_pricing or reprice_dtl) then do:

/*H1HQ*/ /* THE FOLLOWING BLOCK OF CODE HAS BEEN MOVED TO A SINGLE */
/*H1HQ*/ /* ASSIGN STATEMENT DUE TO ACTION SEGMENT VIOLATION       */
/*H1HQ*/    assign
/*H1HQ*/       best_list_price = 0
/*H1HQ*/       best_net_price  = 0
/*J2X8** BEGIN DELETE **
 * /*H1HQ*/       min_price       = 0
 * /*H1HQ*/       max_price       = 0
 *J2X8** END DELETE **/
/*H1HQ*/       sobparent       = ""
/*H1HQ*/       sobfeature      = ""
/*H1HQ*/       sobpart         = ""
/*H1HQ*/       manual_list     = if sod_pr_list <> "" then
/*H1HQ*/                            sod_pr_list
/*H1HQ*/                         else
/*H1HQ*/                            so_pr_list.

            {gprun.i ""gppiwk01.p"" "(
                                      1,
                                      sod_nbr,
                                      sod_line
                                     )"}
/*GUI*/ if global-beam-me-up then undo, leave.

         /*GET BEST LIST TYPE PRICE LIST, SET MIN/MAX FIELDS*/
/*M017*/    run apm-pricing1 in THIS-PROCEDURE.

/*M017* **** BEGIN DELETED SECTION ****
 * /*L00Y*/ /* ADDED SECOND EXCHANGE RATE BELOW */
 * /*J2JJ*/ /* ADDED SOD_NBR, SOD_LINE TO PARAMETERS */
 *          {gprun.i ""gppibx.p"" "(
 *                                  pics_type,
 *                                  picust,
 *                                  part_type,
 *                                  sod_part,
 *                                  sobparent,
 *                                  sobfeature,
 *                                  sobpart,
 *                                  1,
 *                                  so_curr,
 *                                  sod_um,
 *                                  sod_pricing_dt,
 *                                  soc_pt_req,
 *                                  sod_site,
 *                                  so_ex_rate,
 *                                  so_ex_rate2,
 *                                  sod_nbr,
 *                                  sod_line,
 *                                  output err_flag
 *                                 )"}
 *M017* **** END DELETED SECTION ****/

            if soc_pt_req or best_list_price = 0 then do:

                  find first wkpi_wkfl where
                             wkpi_parent   = ""  and
                             wkpi_feature  = ""  and
                             wkpi_option   = ""  and
                             wkpi_amt_type = "1"
                  no-lock no-error.

/*J39H*/ /* COMMENTED BELOW CODE AND MOVED IT TO INTERNAL PROCEDURE */
/*J39H*/ /* p-itm-prlst-chk TO REDUCE ACTION SEGMENT SIZE           */
/*J39H*/ /* CHANGED LOGIC- CHECK PRICE LIST AVAILABILITY ONLY FOR   */
/*J39H*/ /* INVENTORY ITEMS                                         */

/*J39H** BEGIN DELETE **
 *              if soc_pt_req then do:
 *                 if (available wkpi_wkfl and wkpi_source = "1") or
 *                   not available wkpi_wkfl then do:
 *                    {mfmsg03.i 6231 4 sod_part sod_um """"}
 *                    /*Price table for sod_part in sod_um not found*/
 *                    if not batchrun then pause.
 *                    undo, return.
 *                 end.
 *              end.
 *J39H** END DELETE **/

/*J39H*/       l_undoln = no.
/*J39H*/       /* CHECK PRICE LIST AVAILABILITY */
/*J39H*/       run p-itm-prlst-chk.
/*J39H*/       if l_undoln then
/*J39H*/          undo, return.

               if best_list_price = 0 then do:

                  if not available wkpi_wkfl then do:

                     if available pt_mstr then do:

/*L024*                 best_list_price = pt_price * so_ex_rate * sod_um_conv.*/
/*L024*/                {gprunp.i "mcpl" "p" "mc-curr-conv"
                           "(input base_curr,
                             input so_curr,
                             input so_ex_rate2,
                             input so_ex_rate,
                             input (pt_price * sod_um_conv),
                             input false,
                             output best_list_price,
                             output mc-error-number)"}
/*L024*/                if mc-error-number <> 0 then do:
/*L024*/                   {mfmsg.i mc-error-number 2}
/*L024*/                end.

                        /*Create list type price list record in wkpi_wkfl*/
                        {gprun.i ""gppiwkad.p""
                           "(sod_um, sobparent, sobfeature, sobpart,
                             ""4"", ""1"", best_list_price, 0, no)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                        end. /* if available pt_mstr */

                     else do:

                        /*Create list type price list record in wkpi_wkfl
                          for memo type*/
                        best_list_price = sod_list_pr.

                        {gprun.i ""gppiwkad.p""
                           "(sod_um, sobparent, sobfeature, sobpart,
                             ""7"", ""1"", best_list_price, 0, no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     end. /* not available pt_mstr */

                     end. /* if not available wkpi_wkfl */
                  else
                     best_list_price = wkpi_amt.

               end. /* if best-list-price = 0 */

            end. /* if soc_pt_req or best-list-price = 0 */

/*H1HQ*/    assign
/*H1HQ*/       sod_list_pr = best_list_price
/*H1HQ*/       sod_price   = best_list_price.

            /*CALCULATE TERMS INTEREST*/

            if sod_crt_int <> 0 and (available pt_mstr or sod_type <> "")
            then do:

/*H1HQ*/       assign
/*H1HQ*/          sod_list_pr     = (100 + sod_crt_int) / 100 * sod_list_pr
/*H1HQ*/          sod_price       = sod_list_pr
/*H1HQ*/          best_list_price = sod_list_pr.

               /*Create credit terms interest wkpi_wkfl record*/
               {gprun.i ""gppiwkad.p""
                  "(sod_um, sobparent, sobfeature, sobpart,
                    ""5"", ""1"", sod_list_pr, 0, no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.

            parent_list_price = best_list_price. /*gppiwk02.p needs this*/

         end. /*line_pricing or reprice_dtl*/
         /*UPDATE QTY AND EXT LIST IN ACCUMULATED QTY WORKFILES*/

         if rma-issue-line and (line_pricing or not new_order) then do:
            if ((save_parent_list <> sod_list_pr) or
                (save_um <> sod_um)) and save_qty_ord <> 0 then do:
               {gprun.i ""gppiqty2.p"" "(
                                         sod_line,
                                         sod_part,
                                       - save_qty_ord,
                                       - (save_qty_ord * save_parent_list),
                                         save_um,
                                         yes,
                                         yes,
                                         yes
                                        )"}
/*GUI*/ if global-beam-me-up then undo, leave.

               {gprun.i ""gppiqty2.p"" "(
                                         sod_line,
                                         sod_part,
                                         sod_qty_ord,
                                         sod_qty_ord * sod_list_pr,
                                         sod_um,
                                         yes,
                                         yes,
                                         yes
                                        )"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.
            else do:
               {gprun.i ""gppiqty2.p"" "(
                                         sod_line,
                                         sod_part,
                                         sod_qty_ord - save_qty_ord,
                                         (sod_qty_ord - save_qty_ord) *
                                          sod_list_pr,
                                         sod_um,
                                         yes,
                                         yes,
                                         yes
                                        )"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.
         end. /*line_pricing or not new_order*/

         /*GET BEST DISCOUNT TYPE PRICE LISTS*/

/*J2JJ**    if rma-issue-line and sod_list_pr <> 0 and */
/*J2JJ*/    if rma-issue-line and
                           (line_pricing or reprice_dtl) then do:

/*M017*/       run apm-pricing2 in THIS-PROCEDURE.

/*M017* **** BEGIN DELETED SECTION ****
 * /*L00Y*/ /* ADDED SECOND EXCHANGE RATE BELOW */
 * /*J2JJ*/ /* ADDED SOD_NBR, SOD_LINE TO PARAMETERS */
 *           {gprun.i ""gppibx.p"" "(
 *                                   pics_type,
 *                                   picust,
 *                                   part_type,
 *                                   sod_part,
 *                                   sobparent,
 *                                   sobfeature,
 *                                   sobpart,
 *                                   2,
 *                                   so_curr,
 *                                   sod_um,
 *                                   sod_pricing_dt,
 *                                   no,
 *                                   sod_site,
 *                                   so_ex_rate,
 *                                   so_ex_rate2,
 *                                   sod_nbr,
 *                                   sod_line,
 *                                   output err_flag)"}
 *M017* **** END DELETED SECTION ****/

             /*CALCULATE BEST PRICE, EXCLUDING GLOBAL DISCOUNTS*/

             {gprun.i ""gppibx04.p"" "(
                                       sobparent,
                                       sobfeature,
                                       sobpart,
                                       no,
                                       rfact
                                      )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J2JZ*/ /* THE FOLLOWING ASSIGNMENTS WERE MOVED TO A SINGLE ASSIGN STATEMENT */
/*J2JZ*/ /* DUE TO ACTION SEGMENT VIOLATION.                                  */

/*J2JZ** BEGIN DELETE **
 *           sod_price = best_net_price.
 *           if sod_list_pr <> 0 then
 *              sod_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.
 *           else
 *              sod_disc_pct = 0.
 *J2JZ** END DELETE  */

/*J2JZ*/     assign
/*J2JZ*/       sod_price    = best_net_price
/*J2JZ*/       sod_disc_pct = if sod_list_pr <> 0 then
/*J2JZ*/                         (1 - (sod_price / sod_list_pr)) * 100
/*J2JZ*/                      else
/*J2JZ*/                         0.

             /*DETERMINE DISCOUNT DISPLAY FORMAT*/
             run p-disc-disp (input no).
             display sod_list_pr discount
                     sod_price with frame c.

         end. /*line_pricing or reprice_dtl*/

         /* Moved price conversion to line um up before all price table */
         /* and disc table calls. Because table routines now handle the */
         /* um conversion themselves.                                   */

         /* HERE'S WHERE WE PRICE A RMA RECEIPT LINE */
         if this-is-rma and not rma-issue-line and (new_line or reprice_dtl)
         then do:
            sod_price = 0.
            if so_crprlist <> "" and available pt_mstr then do:
               assign
                  pt_recno = recid(pt_mstr)
                  pcqty    = sod_qty_ord
               .
               {gprun.i ""sopccal.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.
            /* LIST PRICE FOR RECEIPT WILL ALWAYS BE CREDIT PRICE */
            sod_list_pr = sod_price.
            run p-sync-restock (input "default").
          end.   /* if this-is-rma and... */

      /* CONFIGURATIONS */
      if pm_code = "C" then do:

         assign
            old_price = sod_price
            old_list_pr = sod_list_pr
            old_disc = sod_disc_pct.

            /* IF THIS IS AN RMA RECEIPT FOR A CONFIGURED ITEM,    */
            /* THE USER DOES NOT GET TO INPUT OPTIONS AND CREATE   */
            /* SOB_DET'S.                                          */
            if this-is-rma and not rma-issue-line then .
            else do:
                undo_all2 = true.
                {gprun.i ""sosomtf8.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

                hide frame bom.
                if undo_all2 then undo loopc, retry.

/*M0X4*/        /* DISPLAY WARNING MESSAGE# 420 WHEN TRYING TO MODIFY */
/*M0X4*/        /* ORDER QTY OF SO LINE ALREADY RELEASED TO WO        */
/*M0X4*/        if (sod_fa_nbr > "" or sod_lot > "" )
/*M0X4*/           and ((prev_qty_ord <> sod_qty_ord * sod_um_conv)
/*M0X4*/           and   prev_qty_ord <> 0)
/*M11Z* /*M0X4*/  or   modify_sob ) */
/*M0X4*/        then do:
/*M0X4*/            /* LINE ITEM ALREADY RELEASED TO FAS */
/*M0X4*/            {mfmsg.i 420 2}
/*M0X4*/            pause.
/*M0X4*/        end. /* IF sod_fa_nbr > "" .. */

                  /* Check sob_det records at Inventory Database */
                v_failed = no.
                {gprun.i ""sosobchk.p"" "(sod_nbr, sod_line, chg-db, so_db,
                                          output v_failed)" }
/*GUI*/ if global-beam-me-up then undo, leave.

                if v_failed then do:
                   undo_all = yes.  /* CAUSES sosomta.p TO UNDO MAINLOOP  */
                   undo loopc, leave loopc.
                end.

            end.   /* if this-is-rma... */

      end.  /* if pm_code = "C" */

         /*CALCULATE BEST PRICE BASED ON GLOBAL DISCOUNTS*/

         if rma-issue-line and (line_pricing or reprice_dtl) then do:
/*H1HQ*/    assign
/*H1HQ*/       sobparent       = ""
/*H1HQ*/       sobfeature      = ""
/*H1HQ*/       sobpart         = ""
/*H1HQ*/       best_list_price = sod_list_pr.

/*J3GV*/        if soc_pt_req then
/*J3GV*/        do :
/*J3GV*/           /* CHECK FOR PRICE LIST AVAILABILITY FOR COMPONENTS OF */
/*J3GV*/           /* THE CONFIGURED PRODUCT                              */
/*J3GV*/           l_undoln = no.
/*J3GV*/           run chk-pl-exist.
/*J3GV*/           if l_undoln then
/*J3GV*/              undo, return.
/*J3GV*/        end. /* IF SOC_PT_REQ */

            /*IF CONFIGURED PRODUCT AND DISCOUNTS WERE FOUND WHERE
              pi_confg_disc = YES, THEN CALL gppibx.p FOR DISCOUNTS
              AND PROCESS THE DISCOUNTS WHERE pi_confg_disc = YES.
              WHEN PROCESSING THESE DISCOUNTS, THE USE OF LIST PRICE
              IS REQUIRED FOR ALL BUT DISCOUNT PERCENT TYPE DISCOUNTS.
              SINCE best_list_price NOW CONTAINS THE LIST PRICE OF
              THE ENTIRE CONFIGURATION THE DISCOUNTS THAT APPLY
              ACROSS THE ENTIRE CONFIGURATION CAN NOW BE TESTED.
            */

/*J2JJ**    if sod_list_pr <> 0 and exclude_confg_disc and found_confg_disc */
/*J2JJ*/    if exclude_confg_disc and found_confg_disc
            then do:
               assign
                  exclude_confg_disc = no
                  select_confg_disc  = yes
               .

/*M017*/    run apm-pricing2 in THIS-PROCEDURE.

/*M017* **** BEGIN DELETED SECTION ****
 * /*L00Y*/    /* ADDED SECOND EXCHANGE RATE BELOW */
 * /*J2JJ*/    /* ADDED SOD_NBR, SOD_LINE TO PARAMETERS */
 *             {gprun.i ""gppibx.p"" "(
 *                                     pics_type,
 *                                     picust,
 *                                     part_type,
 *                                     sod_part,
 *                                     sobparent,
 *                                     sobfeature,
 *                                     sobpart,
 *                                     2,
 *                                     so_curr,
 *                                     sod_um,
 *                                     sod_pricing_dt,
 *                                     no,
 *                                     sod_site,
 *                                     so_ex_rate,
 *                                     so_ex_rate2,
 *                                     sod_nbr,
 *                                     sod_line,
 *                                     output err_flag)"}
 *M017* **** END DELETED SECTION ****/

               /*READ THE CONFIGURATION AND SELECT COMPONENT LEVEL
                 DISCOUNTS.
               */
               {gprun.i ""sopicnfg.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.

/*J2JJ**    if sod_list_pr <> 0 then do: */
                {gprun.i ""gppibx04.p"" "(
                                      sobparent,
                                      sobfeature,
                                      sobpart,
                                      yes,
                                      rfact
                                     )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J2JJ**    end. */

            /*TEST FOR BEST OVERALL PRICE EITHER BASED ON INDIVIDUAL
              DISCOUNTS ADDED UP OR GLOBAL DISCOUNTS INDEPENDENT OF
              COMPONENTS (IF ANY).  UPON DETERMINING THE WINNER, DELETE
              LOSERS FROM wkpi_wkfl*/

            /*NOT ONLY MUST THE BEST PRICE WIN, BUT THERE MUST BE FOUND
              SUPPORTING DISCOUNT RECORDS.*/

            if best_net_price <= sod_price
               and can-find(first wkpi_wkfl where
                           lookup(wkpi_amt_type, "2,3,4,9") <> 0
                              and wkpi_confg_disc = yes
                              and wkpi_source     = "0") then do:
               sod_price = best_net_price.

/*L0DD*/       /* REINSTATE THE ORIGINAL LOGIC OF DELETING WKPI_WKFL */
/*L0DD** /*J2D8*/ run del-wkpi (input no, input no). */
/*L0DD*/       run del-wkpi-wkfl-no.

            end.
            else do:

               if can-find(first wkpi_wkfl
                           where lookup(wkpi_amt_type, "2,3,4,9") <> 0
                             and wkpi_confg_disc = no) then do:

/*L0DD*/       /* REINSTATE THE ORIGINAL LOGIC OF DELETING WKPI_WKFL */
/*L0DD** /*J2D8*/ run del-wkpi (input no, input no). */
/*L0DD*/          run del-wkpi-wkfl-yn.

               end.     /* if can-find(first wkpi_wkfl.... */
               else
                  sod_price = best_net_price.
            end.    /* else do */

            if sod_list_pr <> 0 then
               sod_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.
            else
               sod_disc_pct = 0.

            /* JUST IN CASE SYSTEM DISCOUNTS CHANGED SINCE THE LAST PRICING  */
            /* AND THE USER MANUALLY ENTERED THE PRICE (OR DISCOUNT), RETAIN */
            /* THE PREVIOUS sod_price (THAT'S WHAT THE USER WANTS) AND REVISE*/
            /* THE MANUAL DISCOUNT ADJUSTMENT TO COMPENSATE.                 */

/*M12Q*/       run reviseManualDiscountAdjustment.

/*M12Q *** BEGIN DELETE  - Moved to Internal Procedure section
 *             find first wkpi_wkfl where wkpi_parent   = sobparent  and
 *                                        wkpi_feature  = sobfeature and
 *                                        wkpi_option   = sobpart    and
 *                                        wkpi_amt_type = "2"        and
 *                                        wkpi_source   = "1"
 *                                  no-lock no-error.
 *
 *             if available wkpi_wkfl
 *             then do:
 * /*L024*/       assign
 *                   save_disc_pct = if sod_list_pr <> 0 then
 *                                      (1 - (sod_price / sod_list_pr)) * 100
 *                                   else
 *                                       0
 *                   sod_price     = last_sod_price
 * /*L024*/          new_disc_pct  = save_disc_pct
 * /*L024*/          sod_disc_pct  = new_disc_pct.
 *
 * /*L024*        if sod_list_pr <> 0 then
 *  *L024*           new_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.
 *  *L024*        else
 *  *L024*           new_disc_pct = 0.
 *  *L024*        sod_disc_pct = new_disc_pct.
 *  *L024*/
 *
 *                if pic_disc_comb = "1" then do:      /*cascading discount*/
 *                   if available wkpi_wkfl then
 * /*J2JZ*/          do:
 *
 * /*J2JZ** BEGIN DELETE **
 *  *                      sys_disc_fact = if not found_100_disc then
 *  *                                         ((100 - save_disc_pct) / 100) /
 *  *                                         ((100 - wkpi_amt)      / 100)
 *  *                                      else
 *  *                                         0.
 *  *J2JZ** END DELETE   */
 *
 * /*J2JZ*/             if not found_100_disc then
 * /*J2JZ*/                sys_disc_fact = if wkpi_amt = 100 then
 * /*J2JZ*/                                   1
 * /*J2JZ*/                                else
 * /*J2JZ*/                                   ((100 - save_disc_pct) / 100) /
 * /*J2JZ*/                                   ((100 - wkpi_amt)      / 100) .
 * /*J2JZ*/             else
 * /*J2JZ*/                sys_disc_fact = 0 .
 * /*J2JZ*/          end. /* IF AVAILABLE WKPI_WKFL */
 *                   else
 *                      sys_disc_fact =  (100 - save_disc_pct) / 100.
 *                   if sys_disc_fact = 1 then
 *                      man_disc_pct  = new_disc_pct.
 *                   else do:
 *                      if sys_disc_fact <> 0 then do:
 *                         discount      = (100 - new_disc_pct) / 100.
 *                         man_disc_pct  = (1 - (discount / sys_disc_fact)) * 100.
 *                      end.
 *                      else do:
 *                         if available wkpi_wkfl then
 *                            man_disc_pct = new_disc_pct -
 *                                           (save_disc_pct - wkpi_amt).
 *                         else
 *                            man_disc_pct  = new_disc_pct - 100.
 *                      end.
 *                   end.
 *                end.
 *                else do:
 *                   if available wkpi_wkfl then
 *                      man_disc_pct = new_disc_pct -
 *                                     (save_disc_pct - wkpi_amt).
 *                   else
 *                      man_disc_pct = new_disc_pct - save_disc_pct.
 *                end.
 *
 *                {gprun.i ""gppiwkad.p"" "(sod_um,
 *                                          sobparent,
 *                                          sobfeature,
 *                                          sobpart,                                        ""1"",
 *                                          ""2"",
 *                                          0,
 *                                          man_disc_pct,
 *                                          yes)"}
 *             end. /* last_sod_price <> sod_price */
 *M12Q *** END DELETE */

         end. /*line_pricing or reprice_dtl*/

         /* RMA ISSUE LINES MAY ALSO HAVE A DISCOUNT FROM THE SERVICE    */
         /* TYPE. CALCULATE LINE DISCOUNT AS THE 'NORMAL SALES ORDER'    */
         /* DISCOUNT AMOUNT, AND ADD TO THAT THE DISCOUNT DUE TO THE     */
         /* SERVICE TYPE COVERAGE.                                       */
         if this-is-rma
         then do:
            if rma-issue-line and (new_order or reprice_dtl) then do:
                  /* FOR ISSUE LINES, CHECK FOR ADDITIONAL SERVICE TYPE */
                  /* DISCOUNT.                                          */
                  {gprun.i ""fsrmadsc.p""
                        "(input        rma_contract,
                          input        if available pt_mstr
                                          then pt_fsc_code
                                          else """",
                          input        sod_due_date,
                          input        sod_qty_ship,
                          input        rma-recno,
                          input        rmd-recno,
                          input        new_line,
                          input-output rmd_sv_code,
                          input-output rmd_chg_type,
                          output       coverage-discount,
                          output       sod_contr_id)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  if sod_list_pr <> 0 then
                     sod_covered_amt = sod_list_pr * (coverage-discount / 100).
/*J2VF**          else do: */
/*J2VF*/          else
/*J2VF*/             assign
                        sod_covered_amt = 0
                        sod__qadd01     = 0.
/*J2VF**          end. */

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
            /*        sod_covered_amt WILL ALWAYS MAINTAIN THE EQUIVALENT OF */
            /*        THE COVERAGE DISCOUNT.  THIS IS REQUIRED IN ORDER TO   */
            /*        ADJUST THE MINIMUM AND MAXIMUM THRESHOLD VALUES WHEN   */
            /*        TESTING THE NET PRICE AGAINST THESE THRESHOLDS.        */

/*J2JJ**       if sod_list_pr <> 0 and (line_pricing or reprice_dtl) then do:*/
/*J2JJ*/       if (line_pricing or reprice_dtl)  then do:
/*M12Q*/          run adjustManualDiscountPercent.

/*M12Q *** BEGIN DELETE  - Moved to Internal Procedure section
 *                   find first wkpi_wkfl where wkpi_parent   = sobparent  and
 *                                              wkpi_feature  = sobfeature and
 *                                              wkpi_option   = sobpart    and
 *                                              wkpi_amt_type = "2"        and
 *                                              wkpi_source   = "1"
 *                                         no-lock no-error.
 *
 *                   if not available wkpi_wkfl
 *                   then do:
 *                      assign
 *                         save_disc_pct = if sod_list_pr <> 0 then
 *                                       (1 - (sod_price / sod_list_pr)) * 100
 *                                         else
 *                                             0.
 *                      if sod_price - sod_covered_amt > 0 then
 *                         sod_price       = sod_price - sod_covered_amt.
 * /*J2VF**             else do: */
 * /*J2VF*/             else
 *                         sod_price       = 0.
 * /*J2VF**             end.     */
 * /*J2JJ**             new_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.*/
 * /*J2JJ*/             assign
 * /*J2JJ*/                new_disc_pct = if sod_list_pr <> 0 then
 * /*J2JJ*/                              (1 - (sod_price / sod_list_pr)) * 100
 * /*J2JJ*/                               else
 * /*J2JJ*/                                  0.
 *
 *                      sod_disc_pct       = new_disc_pct.
 *
 *                      if pic_disc_comb = "1" then do:  /*cascading discount*/
 *                                sys_disc_fact =  (100 - save_disc_pct) / 100.
 *                         if sys_disc_fact = 1 then
 *                            man_disc_pct  = new_disc_pct.
 *                         else do:
 * /*J2VF**                   if sys_disc_fact <> 0 then do: */
 * /*J2VF*/                   if sys_disc_fact <> 0 then
 * /*J2VF*/                      assign
 *                                 discount      = (100 - new_disc_pct) / 100
 *                             man_disc_pct  = (1 - (discount / sys_disc_fact))
 *                                                * 100.
 * /*J2VF**                   end. */
 *                            else
 *                               man_disc_pct  = new_disc_pct - 100.
 *                         end.
 *                      end.
 *                      else do:                         /*additive discount*/
 *                               man_disc_pct = new_disc_pct - save_disc_pct.
 *                      end.
 *
 * /*J2VZ*/           /* DO NOT CREATE MANUAL OVERRIDE DISCOUNT IN WKPI_WKFL */
 * /*J2VZ*/           /* FOR ZERO COVERAGE DISCOUNT                          */
 * /*J2VZ*/             if man_disc_pct <> 0 then do:
 *                      {gprun.i ""gppiwkad.p"" "(
 *                                                sod_um,
 *                                                sobparent,
 *                                                sobfeature,
 *                                                sobpart,
 *                                                ""1"",
 *                                                ""2"",
 *                                                0,
 *                                                man_disc_pct,
 *                                                yes
 *                                               )"}
 * /*J2VZ*/             end. /* IF MAN_DISC_PCT <> 0 */
 *
 *                      sod__qadd01 = man_disc_pct.
 *                   end.
 * /*J2VF**          else do: */
 * /*J2VF*/          else
 *                      sod__qadd01 = 0.
 * /*J2VF**          end.     */
 *M12Q *** END DELETE */
               end. /* line_pricing or reprice_dtl */
            end.    /* if rma-issue-line ... */
            else do:
               /* ELSE, IF THIS IS A RECEIPT LINE, THE USER MAY SEE */
               /* SOME 'DISCOUNT' AS A RESULT OF THE RESTOCK CHARGE */
               /* IN THIS CASE, GIVE HIM A MESSAGE TO CLARIFY.      */
               if not rma-issue-line and restock-pct <> 0 then do:
                  {mfmsg.i 1186 1}
                  /* RESTOCKING CHARGE APPLIES TO THIS LINE ITEM */
               end.
            end.    /* else, rma-receipt-line, do */
         end.   /* if this-is-rma */

         assign
            old_price = sod_price
            old_list_pr = sod_list_pr
            old_disc = sod_disc_pct.

         if rma-issue-line then
         do:
            if sod_list_pr <> 0 then
               sod_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.
            else
               sod_disc_pct = 0.

         /*DETERMINE DISCOUNT DISPLAY FORMAT*/

         /* TEST FOR DISCOUNT RANGE VIOLATION.  IF FOUND, CREATE/MAINTAIN */
         /* MANUAL DISCOUNT TO RECONCILE THE DIFFERENCE BETWEEN THE SYSTEM*/
         /* DISCOUNT AND THE MIN OR MAX ALLOWABLE DISCOUNT, DEPENDING ON  */
         /* THE VIOLATION.                                                */

            run p-disc-disp (input yes).
            if disc_min_max then do:     /* found a discount range violation */
/*J2JZ*/ /* THE FOLLOWING ASSIGNMENTS WERE MOVED TO A SINGLE ASSIGN STATEMENT */
/*J2JZ*/ /* DUE TO ACTION SEGMENT VIOLATION.                                  */

/*J2JZ***      save_disc_pct = disc_pct_err.    */
/*J2JZ*/       assign save_disc_pct = disc_pct_err
               new_disc_pct  = if pic_so_fact then
                                  (1 - discount) * 100
                               else
/*J2JZ***                               discount. */
/*J2JZ*/                                discount
               sod_disc_pct = new_disc_pct.
               find first wkpi_wkfl where wkpi_parent   = sobparent  and
                                          wkpi_feature  = sobfeature and
                                          wkpi_option   = sobpart    and
                                          wkpi_amt_type = "2"        and
                                          wkpi_source   = "1"
                                    no-lock no-error.

               if pic_disc_comb = "1" then do:     /*cascading discount*/
                  if available wkpi_wkfl then
/*J2JZ***            sys_disc_fact = ((100 - save_disc_pct) / 100) /  */
/*J2JZ***                            ((100 - wkpi_amt)      / 100). */

/*J2JZ*/             sys_disc_fact = if wkpi_amt = 100 then
/*J2JZ*/                                1
/*J2JZ*/                             else
/*J2JZ*/                               ((100 - save_disc_pct) / 100) /
/*J2JZ*/                               ((100 - wkpi_amt)      / 100).
                  else
                     sys_disc_fact =  (100 - save_disc_pct) / 100.
                  if sys_disc_fact = 1 then
                     man_disc_pct  = new_disc_pct.
                  else do:
/*J2VZ**             if sys_disc_fact <> 0 then do: */
/*J2VZ*/             if sys_disc_fact <> 0 then
/*J2VZ*/                assign
                        discount      = (100 - new_disc_pct) / 100
                        man_disc_pct  = (1 - (discount / sys_disc_fact))
                                        * 100.
/*J2VZ**             end. */
                     else
                        man_disc_pct  = new_disc_pct - 100.
                  end.
               end.
               else do:                            /*additive discount*/
                  if available wkpi_wkfl then
                       man_disc_pct = new_disc_pct -
                                    (save_disc_pct - wkpi_amt).
                  else
                     man_disc_pct = new_disc_pct - save_disc_pct.
               end.

               {gprun.i ""gppiwkad.p"" "(
                                         sod_um,
                                         sobparent,
                                         sobfeature,
                                         sobpart,
                                         ""1"",
                                         ""2"",
                                         0,
                                         man_disc_pct,
                                         yes
                                        )"}
/*GUI*/ if global-beam-me-up then undo, leave.


               sod_price = sod_list_pr * (1 - (new_disc_pct / 100)).

            end.  /* if disc_min_max */

         end.  /* if rma-issue-line */
         else do:
/*J2VF**    if disc_min_max then do: */
/*J2VF*/    if disc_min_max then
/*J2VF*/       assign
                  sod_disc_pct = if pic_so_fact then
                                    (1 - discount) * 100
                                 else
                                     discount
                  sod_price = sod_list_pr * (1 - (sod_disc_pct / 100)).
/*J2VF**    end. */
         end.

         run p-disc-disp (input no).
         display sod_list_pr discount sod_price with frame c.

         save_disc_pct = if sod_list_pr <> 0 then
                            (1 - (sod_price / sod_list_pr)) * 100
                         else
                             0.
         last_list_price = sod_list_pr.

         /* FOR RMA RECEIPT LINES, DISCOUNT PERCENT PROBABLY WON'T APPLY    */
         /* BUT, LET USER ENTER ONE - EXCEPT IN THOSE CASES WHERE A         */
         /* RESTOCKING CHARGE APPLIES.  RESTOCKING CHARGES AND DISCOUNTS    */
         /* CANNOT BE USED IN CONJUNCTION.                                  */
         /* IF THE USER CHANGES THE HEADER SVC TYPE, WE NEED TO ALLOW       */
         /* HIM TO UPDATE THE DISCOUNT BECAUSE WE NO LONGER KNOW IF THE     */
         /* OLD SVC TYPE HAD A RESTOCKING CHARGE.  IF THE USER DOESN'T      */
         /* CHANGE ANYTHING, THE OLD RESTOCKING CHARGE OR DISCOUNT APPLIES. */
         /* IF SOMETHING CHANGES, THE NEW DISCOUNT WILL APPLY, UNLESS THE   */
         /* THE NEW SVC TYPE HAS A RESTOCKING CHARGE, IN WHICH CASE THAT    */
         /* PERCENT WILL OVERRIDE THE ENTERED DISCOUNT.                     */

         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


/*J2VF*/    run p-assign-msg (output l_err_msg).

            if new_order or reprice_dtl then
               update sod_list_pr
                      discount
                         /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
                         when (rma-issue-line or restock-pct = 0 or
                               rmd_sv_code <> rma_ctype)
/*J2VF*/                 validate({gppswd1.v
                                   &field=""sod_disc_pct""
                                   &field1="discount"}, l_err_msg)
               with frame c.

            /*CHECK MIN/MAX FOR LIST PRICE VIOLATIONS
              CREATE wkpi_wkfl IF MIN OR MAX ERROR OCCURS*/

            if rma-issue-line then do:

               {gprun.i ""gpmnmx01.p"" "(
                                         yes,
                                         yes,
                                         min_price,
                                         max_price,
                                         1,
                                         no,
                                         sod_nbr,
                                         sod_line,
                                         yes,
                                         output minmaxerr,
                                         output minerr,
                                         output maxerr,
                                         input-output sod_list_pr,
                                         input-output sod_price
                                        )"}
/*GUI*/ if global-beam-me-up then undo, leave.


               if minerr then do:      /*list price below min. allowed*/
                  {gprun.i ""gppiwkad.p"" "(
                                            sod_um,
                                            sobparent,
                                            sobfeature,
                                            sobpart,
                                            ""2"",
                                            ""1"",
                                            sod_list_pr,
                                            0,
                                            yes
                                           )"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.
               if maxerr then do:     /*list price above max. allowed*/
                  {gprun.i ""gppiwkad.p"" "(
                                            sod_um,
                                            sobparent,
                                            sobfeature,
                                            sobpart,
                                            ""3"",
                                            ""1"",
                                            sod_list_pr,
                                            0,
                                            yes
                                           )"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.
               if minerr or maxerr then do:

/*J2JZ*/ /* THE FOLLOWING ASSIGNMENTS WERE MOVED TO A SINGLE ASSIGN STATEMENT */
/*J2JZ*/ /* DUE TO ACTION SEGMENT VIOLATION.                                  */

/*J2JZ** BEGIN DELETE **
 *                   sod_disc_pct      = 0.
 *                   sod__qadd01       = 0.
 *                   discount          = if pic_so_fact then 1 else 0.
 *J2JZ** END DELETE   */

/*J2JZ*/          assign
/*J2JZ*/             sod_disc_pct      = 0
/*J2JZ*/             sod__qadd01       = 0
/*J2JZ*/             discount          = if pic_so_fact then 1 else 0
                  parent_list_price = sod_list_pr.  /*gppiwk02.p needs this*/
                  display sod_list_pr discount sod_price with frame c.

                  /*IF ANY EXISTING DISCOUNTS, CREATE/MAINTAIN "MANUAL" DISCOUNT
                    TO NEGATE DISCOUNT AND MAINTAIN PRICING HISTORY*/

                  find first wkpi_wkfl where wkpi_parent   = sobparent  and
                                             wkpi_feature  = sobfeature and
                                             wkpi_option   = sobpart    and
                                             wkpi_amt_type = "2"        and
                                             wkpi_source   = "1"
                                       no-lock no-error.
                  if pic_disc_comb = "1" then do:       /*cascading*/
                     if available wkpi_wkfl then
/*J2JZ*/             do:

/*J2JZ** BEGIN DELETE **
 *                         sys_disc_fact = if not found_100_disc then
 *                                            ((100 - save_disc_pct) / 100) /
 *                                            ((100 - wkpi_amt)      / 100)
 *                                         else
 *                                            0.
 *J2JZ** END DELETE   */

/*J2JZ*/                if not found_100_disc then
/*J2JZ*/                   sys_disc_fact = if wkpi_amt = 100 then
/*J2JZ*/                                      1
/*J2JZ*/                                   else
/*J2JZ*/                                      ((100 - save_disc_pct) / 100) /
/*J2JZ*/                                      ((100 - wkpi_amt)      / 100) .
/*J2JZ*/                else
/*J2JZ*/                   sys_disc_fact = 0 .
/*J2JZ*/             end. /* IF AVAILABLE WKPI_WKFL */
                     else
                        sys_disc_fact =  (100 - save_disc_pct) / 100.
                     if sys_disc_fact <> 1 or available wkpi_wkfl then do:
                        if sys_disc_fact <> 0 then
                           man_disc_pct  = (1 - (1 / sys_disc_fact)) * 100.
                        else
                           man_disc_pct  = -100.

                        {gprun.i ""gppiwkad.p"" "(
                                                  sod_um,
                                                  sobparent,
                                                  sobfeature,
                                                  sobpart,
                                                  ""1"",
                                                  ""2"",
                                                  0,
                                                  man_disc_pct,
                                                  yes
                                                 )"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     end.
                  end.
                  else do:                              /*additive*/
                     if available wkpi_wkfl then
                        man_disc_pct = - (save_disc_pct - wkpi_amt).
                     else
                        man_disc_pct = - save_disc_pct.
                     if save_disc_pct <> 0 or available wkpi_wkfl then do:

                        {gprun.i ""gppiwkad.p"" "(
                                                  sod_um,
                                                  sobparent,
                                                  sobfeature,
                                                  sobpart,
                                                  ""1"",
                                                  ""2"",
                                                  0,
                                                  man_disc_pct,
                                                  yes
                                                 )"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     end.
                  end.
               end.
               else do:

                  /*TEST TO SEE IF LIST PRICE AND/OR DISCOUNT ARE MANUALLY
                    ENTERED.  IF SO UPDATE PRICING WORKFILE TO REFLECT THE
                    CHANGE.*/

                  if sod_list_pr entered or discount entered then do:
                     if sod_list_pr entered then do:
/*L124*/                l_flag = yes.
                        {gprun.i ""gppiwkad.p"" "(
                                                  sod_um,
                                                  sobparent,
                                                  sobfeature,
                                                  sobpart,
                                                  ""1"",
                                                  ""1"",
                                                  sod_list_pr,
                                                  0,
                                                  yes
                                                 )"}
/*GUI*/ if global-beam-me-up then undo, leave.

                        parent_list_price = sod_list_pr. /*for gppiwk02.p*/

                        /*Tag as a repricing candidate since net price could
                          be affected by change in list price.  Also, update
                          extended list amount accumulation used by best
                          pricing.*/

                        if line_pricing or not new_order then do:

                           find first wrep_wkfl where wrep_parent
                                                  and wrep_line = sod_line
/*L124**                                          exclusive-lock. */
/*L124*/                                          exclusive-lock no-error.

                           if available wrep_wkfl then
                              wrep_rep = yes.

                           {gprun.i ""gppiqty2.p"" "(
                                                     sod_line,
                                                     sod_part,
                                                     0,
                                                     sod_qty_ord *
                                                    (sod_list_pr -
                                                     last_list_price),
                                                     sod_um,
                                                     yes,
                                                     yes,
                                                     yes
                                                    )"}
/*GUI*/ if global-beam-me-up then undo, leave.


                        end.

/*J2VZ*/                /* RE-APPLY THE BEST PRICING */
/*J2VZ*/                if (reprice_dtl or new_order) then do:
/*J2VZ*/                   run p-bestprice.
/*J2VZ*/                end. /* REPRICE_DTL */

                        if rma-issue-line then
                           sod_covered_amt = sod_list_pr *
                                             (coverage-discount / 100).
                     end.
/*J2VZ**             if discount entered then do:  */
                        sod__qadd01     = 0.
                        if pic_so_fact then
                           new_disc_pct = (1 - discount) * 100.
                        else
                           new_disc_pct = discount.
                        sod_disc_pct = new_disc_pct.

                        run p-disc-disp (input yes).
                        if disc_min_max then
                           undo, retry.

                        find first wkpi_wkfl where wkpi_parent = sobparent and
                                                wkpi_feature  = sobfeature and
                                                wkpi_option   = sobpart    and
                                                wkpi_amt_type = "2"        and
                                                wkpi_source   = "1"
                                             no-lock no-error.
/*J2VZ*/                if available wkpi_wkfl or discount entered  then do:

                        if pic_disc_comb = "1" then do:  /*cascading discount*/
                           if available wkpi_wkfl then
/*J2JZ*/                   do:

/*J2JZ** BEGIN DELETE **
 *                             sys_disc_fact = if not found_100_disc then
 *                                               ((100 - save_disc_pct) / 100) /
 *                                               ((100 - wkpi_amt)      / 100)
 *                                            else
 *                                               0.
 *J2JZ** END DELETE   */

/*J2JZ*/                      if not found_100_disc then
/*J2JZ*/                         sys_disc_fact = if wkpi_amt = 100 then
/*J2JZ*/                                            1
/*J2JZ*/                                         else
/*J2JZ*/                                           ((100 - save_disc_pct) / 100)
/*J2JZ*/                                          / ((100 - wkpi_amt)    / 100).
/*J2JZ*/                      else
/*J2JZ*/                         sys_disc_fact = 0 .
/*J2JZ*/                   end. /* IF AVAILABLE WKPI_WKFL */
                           else
                                sys_disc_fact =  (100 - save_disc_pct) / 100.
                           if sys_disc_fact = 1 then
                              man_disc_pct  = new_disc_pct.
                           else do:
/*J2VZ**                      if sys_disc_fact <> 0 then do: */
/*J2VZ*/                      if sys_disc_fact <> 0 then
/*J2VZ*/                         assign
                                 discount     = (100 - new_disc_pct) / 100
                                 man_disc_pct = (1 - (discount / sys_disc_fact))
                                                * 100.
/*J2VZ**                      end. */
                              else do:
                                 if available wkpi_wkfl then
                                    man_disc_pct = new_disc_pct -
                                                   (save_disc_pct - wkpi_amt).
                                 else
                                    man_disc_pct  = new_disc_pct - 100.
                              end.
                           end.
                        end.
                        else do:                         /*additive discount*/
                           if available wkpi_wkfl then
                               man_disc_pct = new_disc_pct -
                                             (save_disc_pct - wkpi_amt).
                           else
                               man_disc_pct = new_disc_pct - save_disc_pct.
                        end.

                        {gprun.i ""gppiwkad.p"" "(
                                                  sod_um,
                                                  sobparent,
                                                  sobfeature,
                                                  sobpart,
                                                  ""1"",
                                                  ""2"",
                                                  0,
                                                  man_disc_pct,
                                                  yes
                                                 )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J2VZ**             end.*/
                        sod_price = sod_list_pr * (1 - (new_disc_pct / 100)).
/*J2VZ*/                end. /* IF AVAIL WKPI_WKFL OR DISCOUNT ENTERED */
/*J2VZ*/                assign
/*J2VZ*/                   discount = if sod_list_pr <> 0 then
/*J2VZ*/                                 100 * (sod_list_pr - sod_price)
/*J2VZ*/                                     / sod_list_pr
/*J2VZ*/                              else 0
/*J2VZ*/                   sod_disc_pct = discount.
/*J2VZ**                display sod_price with frame c. */
/*J2VZ*/                display discount sod_price with frame c.
                  end. /*sod_list_pr entered or discount entered*/
               end. /*not minerr and not maxerr*/
            end. /*rma-issue-line*/

            if this-is-rma and not rma-issue-line
               and (sod_list_pr entered or discount entered)
            then
            do:
               run p-sync-restock (input "discount").
               if disc_min_max  and
                  restock-pct = 0
               then
                  undo, retry.
               display discount with frame c.
            end.  /* if RMA receipt & list or disc changed */

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* do on error undo, retry (for update of sod_list_pr) */

         display sod_price with frame c.

         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

            save_disc_pct = if sod_list_pr <> 0 then
                               (1 - (sod_price / sod_list_pr)) * 100
                            else
                                0.
            old_price = sod_price.
            /* IF THE USER IS MAINTAINING AN RMA RECEIPT LINE, AND HAS */
            /* A 100% RESTOCKING CHARGE, THEN THE NET PRICE WILL       */
            /* ALWAYS BE ZERO, AND THE USER CANNOT OVERRIDE IT.  SO,   */
            /* LET HIM UPDATE PRICE UNDER ALL OTHER CIRCUMSTANCES.     */
            if (new_order or reprice_dtl) and (rma-issue-line
            or (not rma-issue-line and restock-pct <> 100)) then
               set sod_price with frame c.

            /* Disallow price change if uninvoiced shipment exists */
            if sod_price <> last_sod_price and sod_qty_inv <> 0 then do:
               {mfmsg.i 546 3} /*"Invoice qty pending, use inv maint"*/
               undo, retry.
            end.

/*M11Z*/    /* VALIDATE MODIFICATION OF SOD_PRICE IN CASE OF EMT */
/*M11Z*/    if prev_price <> sod_price and not new_line
/*M11Z*/       and sod_btb_type = "03"
/*M11Z*/    then do:

/*M11Z*/       find vd_mstr where vd_addr = sod_btb_vend
/*M11Z*/       no-lock no-error.

/*M11Z*/       /* VALIDATE "SEND SO PRICE" FROM VENDOR */
/*M11Z*/       if available vd_mstr and vd_tp_use_pct = true then do:

/*M11Z*/          if so_secondary = true and soc_use_btb = true then do:
/*M11Z*/             /* TRANSMIT CHANGES ON SBU SO TO PRIMARY PO AND SO */
/*M11Z*/             {gprun.i ""sosobtb2.p""
/*M11Z*/                      "(input recid(sod_det),
/*M11Z*/                        input ""sod_list_pr"",
/*M11Z*/                        input string(prev_price),
/*M11Z*/                        output return-msg)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*M11Z*/             /* DISPLAY ERROR MESSAGE RETURN FROM SOSOBTB2.P */
/*M11Z*/             if return-msg <> 0 then do:
/*M11Z*/                 {mfmsg.i return-msg 3}
/*M11Z*/                 return-msg = 0.
/*M11Z*/                 if not batchrun then pause.
/*M11Z*/                undo, retry.
/*M11Z*/             end.
/*M11Z*/          end. /* if so_secondary */

/*M11Z*/       end. /* if available vd_mstr */

/*M11Z*/    end. /* if prev_price <> sod_price */

/*M017*     if soc_apm and not this-is-rma and */
/*M017*/      if available cm_mstr
/*M017*/         and cm_promo <> ""
/*M017*/         and soc_apm
/*M017*/         and not this-is-rma
/*M017*/         and available pt_mstr and
                  (new_order or reprice_dtl) then do:
                  undo_bon = true.
                  {gprun.i ""sobonli.p"" "(input sod_nbr, input sod_line)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  if undo_bon then undo loopc, leave.
                  if sod_bonus then do:
                     display sod_price with frame c.
                  end.
               end.

            /* PRICE TABLE MIN/MAX ERROR */

            /*IF RMA ISSUE LINE AND DISCOUNT COVERAGE EXISTS, EXCLUDE
              COVERAGE AMOUNT FROM THE NET PRICE BY ADJUSTING THE MIN
              AND MAX AMOUNTS RELATIVE TO THE COVERAGE AMOUNT*/
            if rma-issue-line then do:

               if this-is-rma then do:

                  if min_price <> 0 then
                     min_price = min_price - sod_covered_amt.
                  if max_price <> 0 then
                     max_price = max_price - sod_covered_amt.
               end.

               {gprun.i ""gpmnmx01.p"" "(
                                         no,
                                         yes,
                                         min_price,
                                         max_price,
                                         1,
                                         no,
                                         sod_nbr,
                                         sod_line,
                                         yes,
                                         output minmaxerr,
                                         output minerr,
                                         output maxerr,
                                         input-output sod_list_pr,
                                         input-output sod_price
                                        )"}
/*GUI*/ if global-beam-me-up then undo, leave.

               if minmaxerr then do:
                  minmax_occurred = yes.
                  if sod_price > max_price and max_price <> 0 then
                     display max_price @ sod_price with frame c.
                  else
                     display min_price @ sod_price with frame c.
                  undo, retry.
               end.

            end.

         if sod_list_pr = 0 and sod_price <> 0 then do:

/*J37J*/    /* INTERNAL PROCEDURE p-bestprice-zero HANDLES                    */
/*J37J*/    /* IF BEST LIST PRICE IS ZERO AND IF MARKUP OR NET PRICE          */
/*J37J*/    /* IS SELECTED ALONG WITH DISCOUNT PRICE LIST THEN DISCOUNT AND   */
/*J37J*/    /* LIST PRICE IS CALCULATED ACCORDINGLY                           */
/*J37J*/    run p-bestprice-zero.

/*J37J*/ /* COMMENTED BELOW CODE AND MOVED IT TO INTERNAL PROCEDURE */
/*J37J*/ /* p-bestprice-zero TO REDUCE ACTION SEGMENT SIZE          */

/*J37J** BEGIN DELETE **
 *            sod_list_pr = sod_price.
 *            display sod_list_pr with frame c.
 *          {gprun.i ""gppiwkad.p"" "(
 *                                   sod_um,
 *                                   sobparent,
 *                                   sobfeature,
 *                                   sobpart,
 *                                   ""1"",
 *                                   ""1"",
 *                                   sod_list_pr,
 *                                   sod_disc_pct,
 *                                   no
 *                                  )"}
 *J37J** END DELETE **/

         end. /*  IF SOD_LIST_PR = 0 AND SOD_PRICE <> 0 */

            /* FOR RMA RECEIPT LINES THE DISCOUNT PERCENT MUST BE */
            /* HELD CONSTANT.  SO, IF THE USER CHANGED LIST PRICE,*/
            /* NET PRICE WAS RECALCULATED BEFORE HE HAD THE CHANCE*/
            /* TO UPDATE IT.  IF THE USER HAS NOW CHANGED THE NET */
            /* PRICE, RECALCULATE THE LIST PRICE ACCORDING TO THE */
            /* FIXED DISCOUNT PERCENT (WHICH, FOR RMA RECEIPT     */
            /* LINES, IS A RESTOCKING CHARGE )                    */
            if this-is-rma and not rma-issue-line
               and old_price <> sod_price
            then do:
               run p-sync-restock (input "price").
               if disc_min_max  and
                  restock-pct = 0
               then
                  undo, retry.
               display
                  sod_list_pr
                  discount
               with frame c.
            end.  /* if RMA receipt & net price changed */

            /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
            if  rma-issue-line   and
               (sod_list_pr <> 0 or
                sod_bonus)
            then do:
               new_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.
               sod_disc_pct = new_disc_pct.
               /*DETERMINE DISCOUNT DISPLAY FORMAT*/
               run p-disc-disp (input yes).
               if disc_min_max then
                  undo, retry.

               display discount with frame c.
            end.

            /*TEST TO SEE IF NET PRICE HAS BEEN ENTERED, IF SO CREATE A
              DISCOUNT TYPE MANUAL RECORD TO wkpi_wkfl*/

/*J2JJ**    if rma-issue-line and sod_list_pr <> 0 and (sod_price entered or */
/*J2JJ*/    if rma-issue-line and (sod_price entered or
                                                        sod_bonus or
                                                   minmax_occurred) then do:
               sod__qadd01     = 0.
               minmax_occurred = no.
               find first wkpi_wkfl where wkpi_parent   = sobparent  and
                                          wkpi_feature  = sobfeature and
                                          wkpi_option   = sobpart    and
                                          wkpi_amt_type = "2"        and
                                          wkpi_source   = "1"
                                    no-lock no-error.

               if pic_disc_comb = "1" then do:          /*cascading discount*/
                  if available wkpi_wkfl then
/*J2JZ*/          do:

 /*J2JZ** BEGIN DELETE **
 *                      sys_disc_fact = if not found_100_disc then
 *                                         ((100 - save_disc_pct) / 100) /
 *                                         ((100 - wkpi_amt)      / 100)
 *                                      else
 *                                         0.
 *J2JZ** END DELETE   */

/*J2JZ*/             if not found_100_disc then
/*J2JZ*/                sys_disc_fact = if wkpi_amt = 100 then
/*J2JZ*/                                   1
/*J2JZ*/                                else
/*J2JZ*/                                   ((100 - save_disc_pct) / 100) /
/*J2JZ*/                                   ((100 - wkpi_amt)      / 100) .
/*J2JZ*/             else
/*J2JZ*/                sys_disc_fact = 0 .
/*J2JZ*/          end. /* IF AVAILABLE WKPI_WKFL */
                  else
                     sys_disc_fact =  (100 - save_disc_pct) / 100.
                  if sys_disc_fact = 1 then
                     man_disc_pct  = new_disc_pct.
                  else do:
/*J2VZ**             if sys_disc_fact <> 0 then do: */
/*J2VZ*/             if sys_disc_fact <> 0 then
/*J2VZ*/                assign
                        discount      = (100 - new_disc_pct) / 100
                        man_disc_pct  = (1 - (discount / sys_disc_fact)) * 100.
/*J2VZ**             end. */
                     else do:
                        if available wkpi_wkfl then
                           man_disc_pct = new_disc_pct -
                                          (save_disc_pct - wkpi_amt).
                        else
                           man_disc_pct  = new_disc_pct - 100.
                     end.
                  end.
               end.
               else do:                                 /*additive discount*/
                  if available wkpi_wkfl then
                     man_disc_pct = new_disc_pct -
                                    (save_disc_pct - wkpi_amt).
                  else
                     man_disc_pct = new_disc_pct - save_disc_pct.
               end.

               {gprun.i ""gppiwkad.p"" "(
                                         sod_um,
                                         sobparent,
                                         sobfeature,
                                         sobpart,
                                         ""1"",
                                         ""2"",
                                         0,
                                         man_disc_pct,
                                         yes
                                        )"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.  /*sod_price entered or minmax_occurred*/

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do on error undo, retry (for set sod_price) */
         /*SET DETAIL FREIGHT LIST, IF ANY.  DETERMINED THRU PRICING
           ROUTINES*/

/*M0TZ** if current_fr_list <> "" then */
/*M0TZ*/ if current_fr_list <> ""
/*M0TZ*/    and sod_fr_list =  ""
/*M0TZ*/ then
            sod_fr_list = current_fr_list.

         /* Set the default allocation quantity */
         if new_line
            and not s-btb-so    /* allocations are no allowed for btb lines */
            and sod_confirm
            and sod_qty_ord > 0
            and all_days <> 0
            and (sod_due_date - (today + 1) < all_days)
            then do:
            if sod_type = "" then do:
               new_site = sod_site.
               {gprun.i ""gpalias2.p"" "(new_site, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

               {gprun.i ""soqtyavl.p"" "(sod_part, sod_site, output qty_avl)" }
/*GUI*/ if global-beam-me-up then undo, leave.

               {gprun.i ""gpalias3.p"" "(so_db, output err-flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               qty_avl = qty_avl / sod_um_conv.
               /* (Note: qty pick and ship must be zero since line is new) */
               if soc_all_avl = no then sod_qty_all = max(sod_qty_ord,0).
               else sod_qty_all = max( min(sod_qty_ord, qty_avl) , 0).
            end.
            else
               sod_qty_all = max( sod_qty_ord, 0 ).
         end.

         /* FOR RMA'S, ALLOW USER TO OVERRIDE THE DEFAULT PRODUCT LINE */
         /* UP TO THE POINT IN TIME WHERE THEY'VE SHIPPED/INVOICED     */
         if this-is-rma and sngl_ln and sod_qty_ship = 0
         and sod_qty_inv = 0 then do:
            {gprun.i ""fsrmapl.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

            display
                      sod_acct sod_cc sod_dsc_acct sod_dsc_cc
            with frame d.
         end.

         /* Update other sales order line information */
         undo_all2 = true.

/*M12Q Added Code */
         loopdet:
         do on error undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


         /* When an APO ATP request was processed with insufficient demand, */
         /* the user may choose to modify the order line to match the APO   */
         /* ATP results.  If the apoEarliestDate field is populated, this   */
         /* indicates that the user has chosen to override the original     */
         /* input with data returned from APO ATP.                          */
         /* Order line date is modified to the APO ATP date only for:       */
         /* - multi line order entry or                                     */
         /* - single line order entry when quantity has not changed         */

            run updateWithApoAtpData.

/*M12Q End Added Code */

         /* SOSOMTLB.P WILL, FOR RMA'S, CREATE/MODIFY THE RMD_DET */
            {gprun.i ""sosomtlb.p""
                   "(input this-is-rma,
                     input rma-recno,
                     input rma-issue-line,
                     input rmd-recno,
                     input l_prev_um_conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            if undo_all2 then do:
               hide message.
               undo loopc, leave.
            end.

/*M12Q* Added Code*/

         /* After a new order line has been entered or an existing line      */
         /* is modified where the consume forecast is changed from no to yes */
         /* then validate order line based on Apo Atp.                       */
         /* Initialize Apo data to the order line data                       */
         /* The user can choose to modify the Apo site id in giaposo.p       */

            assign apoSiteId = sod_site
               apoQuantityOnRequestDate = sod_qty_ord
               apoEarliestDate = sod_due_date.

            if (new_line and sod_confirm = yes) or
               (prev_confirm = no and sod_confirm = yes) then do:

               loopvalidate:
               do on error undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


                  /* Determine what module is being processed */
                  if this-is-rma then moduleGroup = "RMA":U.
                  else moduleGroup = "SO":U.

                  {gprunp.i "giapopl" "p" "validateApoAtp"
                     "(input moduleGroup,
                       input rowid(sod_det),
                       input this-is-rma,
                       input-output apoSiteId,
                       input-output apoQuantityOnRequestDate,
                       input-output apoEarliestDate,
                       output useApoAtp,
                       output apoConnected,
                       output apoError,
                       output apoCompErrorList,
                       output apoDemandId)"}

                  /* If there was a connection problem to the APO ATP model  */
                  /* user can attempt to connect again.                      */
                  if not batchrun then do:
                     if not apoConnected and useApoAtp then do:
                        /* Continue with procedure? */
                        confirm_yn = yes.
                        {mfmsg01.i 3140 1 confirm_yn}
                        if not confirm_yn then
                           undo loopdet, retry.
                     end.
                  end.

                  if apoCompErrorList <> "" then
                     /* These components did not exist in the APO ATP Model */
                     {mfmsg02.i 4623 2 "substring(apoCompErrorList,2)"}

                  /* Demand insufficient */
                  if apoError and apoConnected then do:
                     hide frame c.
                     hide frame d.

                     {gprunp.i "giapopl" "p" "processApoInsufficient"
                        "(buffer sod_det,
                          input-output apoSiteId,
                          input-output apoQuantityOnRequestDate,
                          input-output apoEarliestDate,
                          output completeOrderLine,
                          output matchApoAtp,
                          output apoMessageNumber)"}

                     view frame c.
                     if sngl_ln then
                        view frame d.

                     if keyfunction(lastkey) = "end-error":U then do:
                        {gprunp.i "giapopl" "p" "deleteDemandRecord"
                           "(input apoDemandId,
                             input rowid(sod_det))"}
                        if not sngl_ln then do:
                           assign errorResult = "1"
                           apoQuantityOnRequestDate = sod_qty_ord.
                           undo loopc, retry.
                        end.
                        undo loopdet, retry.
                     end.

                     {gprunp.i "giapopl" "p" "processResultsFromApoInsufficient"
                        "(buffer sod_det,
                          input rowid(sod_det),
                          input sngl_ln,
                          input completeOrderLine,
                          input matchApoAtp,
                          input apoMessageNumber,
                          input apoDemandId,
                          input-output apoSiteId,
                          input-output apoQuantityOnRequestDate,
                          input-output apoEarliestDate,
                          output isConnected,
                          output errorResult)"}

                     /* Correct connection error when searching all sites.  */
                     if not isConnected then do:
                        if errorResult = "0" then
                           undo loopvalidate, retry.
                        else if errorResult = "1" then
                           undo loopdet, retry.
                     end.

                     if sngl_ln then do:
                        if errorResult = "1" then
                           undo loopdet, retry.
                        if errorResult = "2" or errorResult = "3" then
                           undo loopc, retry.
                     end.
                     else if not sngl_ln and errorResult <> "0" then
                        undo loopc, retry.

                  end.  /* Demand insufficient */
               end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* loopvalidate */

            end.  /* new_line or prev_confirm = no and sod_confirm = yes */
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* loopdet*/

/*M12Q* End Added Code*/

      if sod_per_date = ? then sod_per_date = sod_due_date.
      if sod_req_date = ? then sod_req_date = sod_due_date.

/* BECAUSE OF THE CONVERTER PROGRAM POSSIBILITIES WE NEED TO USE THIS EXTERNAL */
/* PROCEDURE TO REDUCE THE PROGRAM SIZE                                       */
/* BTB CHANGES TO PRIMARY SO - CHANGE PO - DIRECT ALLOCATION                  */

         /* LOAD SOD_CONTR_ID FROM SO_PO FOR SO_SHIPPER MAINT */
/*J2Q9** if not this-is-rma then */
/*J2Q9*/ if not this-is-rma and not so_sched then
            sod_contr_id = so_po.

      if not available pt_mstr then do:
         update desc1 with frame d.
         sod_desc = desc1.
      end.

         /*DELETE OLD PRICE LIST HISTORY, CREATE NEW PRICE LIST HISTORY,
           MAINTAIN LAST PRICED DATE IN so_mstr (so_priced_dt)*/
         if rma-issue-line and (new_order or reprice_dtl) then do:
            best_net_price = sod_price. /*for "accrual" type price lists*/
            run p-call-apm
              (input sod_nbr,
               input sod_line,
               input new_order,
               input-output wk_bs_line,
               input-output wk_bs_promo).
            {gprun.i ""gppiwk02.p"" "(
                                      1,
                                      sod_nbr,
                                      sod_line,
                                      sod_dsc_acct,
                                      sod_dsc_cc,
                                      sod_project,
                                      wk_bs_line,
                                      wk_bs_promo
                                     )"}
/*GUI*/ if global-beam-me-up then undo, leave.

            so_priced_dt = today.
         end.
         /* Call sosomisb.p to set default installed base info */
         /* If shipping to installed base (svc_ship_isb) and   */
         /* Part is set up for the isb (pt_isb).               */
         /* If soc_isb_window    and                           */
         /* Conditionally test if available svc_trl. */

         /* FOR RMA'S, RMD_EDIT_ISB CONTROLS THE ISB DEFAULTS POPUP. */
         /* FOR SALES ORDERS, BASE POPUP ON SVC_SHIP_ISB AND PT_ISB. */
         if this-is-rma then do:
            if available svc_ctrl then
                if svc_ship_isb and rmd_edit_isb
                and ( available pt_mstr or not svc_pt_mstr )
                then do:
                    {gprun.i ""sosomisb.p""
                        "(input so_recno,
                          input sod_recno,
                          input new_line,
                          input rmd_edit_isb,
              input this_is_edi)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                end.  /* if svc_ship_isb and... */
         end.   /* if this-is-rma */
         else do:
            /* FOR RETURNS, DISPLAY "EDIT ISB DEFAULTS" FRAME IF USER IS
               UPDATING ISB WITH RETURNS AND THIS PART EXISTS SOMEWHERE
               IN THE INSTALLED BASE.  FOR REGULAR SO'S, DISPLAY THIS
               FRAME ONLY IF SHIPPING TO ISB AND PART IS FLAGGED FOR ISB */
            if (sod_qty_ord < 0 and available svc_ctrl and svc_ship_isb and soc_returns_isb
                 and can-find (first isb_mstr where isb_part = sod_part))
            or (sod_qty_ord >= 0 and available svc_ctrl and svc_ship_isb and
                available pt_mstr  and pt_isb)
            then do:
                {gprun.i ""sosomisb.p""
                    "(input so_recno,
                      input sod_recno,
                      input new_line,
                      input if sod_qty_ord < 0 then
                                soc_returns_isb
                            else soc_edit_isb,
              input this_is_edi
                      )"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.
         end.   /* else (this isn't an rma) do: */

         if solinerun <> "" then do:
                    {gprun.i solinerun
                        "(input so_recno, input sod_recno)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.

/*M11Z*/ /* If EMT, determine the Comment Type */
/*M11Z*/ emt-bu-lvl = "".
/*M11Z*/ if soc_use_btb then do:
/*M11Z*/    if so_primary and not so_secondary then
/*M11Z*/       emt-bu-lvl = "PBU".
/*M11Z*/    else if so_primary and so_secondary then
/*M11Z*/       emt-bu-lvl = "MBU".
/*M11Z*/    else if so_secondary then
/*M11Z*/       emt-bu-lvl = "SBU".
/*M11Z*/ end.

      /* LINE COMMENTS */
      if sodcmmts = yes then do:
/*J2VZ*/ assign
            cmtindx = sod_cmtindx
            global_ref = sod_part
/*M11Z*/    save_part  = global_part
/*M11Z*/    global_part = emt-bu-lvl.
         {gprun.i ""gpcmmt01.p"" "(input ""sod_det"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

         sod_cmtindx = cmtindx.
/*M11Z*/ global_part = save_part.
      end.

/*M11Z* /*M11B*/  l_undo_all4 = no. */
         /* Direct Allocations - EMT Orders */
/*M11B*/ /* INTRODUCED THE OUTPUT PARAMETER l_undo_all4 */
         {gprun.i ""sobtbla3.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*M11Z*             "(output l_undo_all4)"} */

/*M11Z* /*M11B*/ if l_undo_all4 = yes  */
/*M11Z* /*M11B*/ then                  */
/*M11Z* /*M11B*/    undo loopc, leave. */

         /* Update Purchase Order if EMT and values have changed */
/*M11Z*/ if s-btb-so and sod_confirm and so_primary
/*M11Z*/ then do:
/*M11Z*/    {gprunp.i "soemttrg" "p" "process-order-detail"
                 "(input new_line,
                   input so_nbr,
                   input sod_line,
                   output return-msg)"}
/*M11Z*/    if return-msg <> 0 then do:
/*M11Z*/       {mfmsg.i return-msg 4}
/*M11Z*/       return-msg = 0.
/*M11Z*/       if not batchrun then pause.
/*M11Z*/       undo loopc, leave.
/*M11Z*/    end. /* if return-msg <> 0 */
/*M11Z*/ end.

           if s-btb-so and so_primary then do on endkey undo loopc, leave:
            hide frame d no-pause.

           /*GET BTB MNEUMONIC FROM lng_det */
           {gplngn2a.i &file = ""emt""
                     &field = ""btb-type""
                     &code = sod_btb_type
                     &mnemonic = btb-type
                     &label = btb-type-desc}

            find pod_det where pod_nbr = sod_btb_po
            and pod_line = sod_btb_pod_line no-lock no-error.
            if available pod_det then
            display btb-type sod_site sod_btb_vend
                   pod_due_date sod_btb_po
                   pod_need
                   sod_btb_pod_line with frame btb_data.
            hide frame btb_data.
         end.

/*M11Z*/ /******* This isn't needed any more since the create of the
 *                PO was moved after the entry of the line item comments
 *
 *          /* BACK TO BACK PO LINE-ITEM COMMENT */
 *           if sod_cmtindx <> 0 then do:
 * /*L100**       find po_mstr where po_so_nbr = sod_nbr and po_is_btb */
 * /*L100**       no-lock no-error.                                    */
 * /*L100**       if avail po_mstr then do:                            */
 * /*K1YM**          find pod_det where pod_nbr = po_nbr and pod_line = sod_line */
 * /*L100** /*K1YM*/ find pod_det where pod_nbr  = po_nbr              */
 * /*L100*/       find pod_det
 * /*L100*/          where pod_nbr  = sod_btb_po
 * /*K1YM*/          and   pod_line = sod_btb_pod_line
 *                 exclusive-lock no-error.
 * /*K1YM*/       if available pod_det then
 *                 pod_cmtindx = sod_cmtindx.
 * /*L100**       end.                                                 */
 *            end.
 **********/

         end.

/*J3BF*/ if sodcmmts = yes then
/*J3BF*/    sod_cmtindx = 0.

         /* UPDATE THE INVENTORY DATABASE FILES */
         if sod_confirm then do:
            {gprun.i  ""sosomtu1.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*M12Q*/    run confirmApoAtpDemand.
         end.
         else do:  /* UPDATE sob_det ONLY */
            if available pt_mstr and pt_pm_code = "C" then do:
               {gprun.i ""sosomti.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.
         end.

/*J3BF*/ /* ASSIGN SOD_CMTINDX AFTER UPDATING INVENTORY DATABASE FILES */
/*J3BF*/ if sodcmmts = yes then
/*J3BF*/    sod_cmtindx = cmtindx.

   undo_all = no.

end. /*do*/

            if cfexists and cf_rm_old_bom and not undo_all then do:
               /* If the user chose to remove the old bom (as they modified the*/
               /* File) then we need to issue a save to save the config. and   */
               /* Write the filename and model and config.status to the qad    */
               /* User fields.                                                */
               if search(cf_cfg_path + cf_chr + sod__qadc01) <> ? then
                  os-delete value(cf_cfg_path + cf_chr + sod__qadc01).
               /* Write sod_det fields */
               sod__qadc01 =
                  lc(sod_nbr) + "_" + string(sod_line) + "." + lc(cf_cfg_suf).
               sod__qadc02 = pt_cf_model.
               sod__qadc03 = "".
               /* ISSUE SAVE TO CALICO */
                    
               {gprunmo.i
                  &module  = "cf"
                  &program = "cfcfsave.p"
                  &param   = """(string(cf_cfg_path + cf_chr + sod__qadc01))"""
               }
                 
            end.

            if cfexists and not undo_all and not cf_rp_part then do:
               /* On a configured product, if the user selects qty ord = 0 std.  */
               /* Functionality will delete the items bom. the functionality must*/
               /* Also extend to deleting the created concinity qad_fields and   */
               /* Associated files.                                              */
               if available sod_det and sod_qty_ord = 0 then do:
                  os-delete value(cf_cfg_path + cf_chr + sod__qadc01).
                  assign
                     sod__qadc01 = ""
                     sod__qadc02 = ""
                     sod__qadc03 = "".
               end.
            end.

            /* if processing 'end configuration', do not reset configuration */
            if cfexists and not cf_cfg_strt_err and not cf_endcfg then do:
            /* CLOSE CONFIGURATIONS */
                 
            {gprunmo.i
               &module  = "cf"
               &program = "cfcfclos.p"
               &param   = """(input cf_cfg_path, input cf_chr,
                              cf_cfg_suf) """
            }
              
         end.

         hide frame line_pop no-pause.
         pause 0.

         /* END OF MAIN PROCEDURE */

/* ======================================================================= */
/* ************************ INTERNAL PROCEDURES ************************** */
/* ======================================================================= */

         /* BECAUSE OF THE ORACLE PROGRAM SIZE RESTRICTION WE NEED TO USE */
         /* THIS INTERNAL PROCEDURE TO REDUCE THE PROGRAM SIZE            */

/*M12Q*/ /* BEGIN ADD SECTION  */

         PROCEDURE getPriceTableRequiredFlag:

            /* Read price table required flag from mfc_ctrl */
            find first mfc_ctrl where mfc_field = "soc_pt_req" no-lock no-error.
            if available mfc_ctrl then soc_pt_req = mfc_logical.

         END PROCEDURE. /* getPriceTableRequiredFlag */

         PROCEDURE setOrderLineAndDesc:

            assign
                line = sod_det.sod_line
                desc1 = {&sosomtla_p_7}
            desc2 = "".

            find pt_mstr where pt_part = sod_part no-lock no-error.
            if available pt_mstr then do:
               assign
                  desc1 = pt_desc1
                  desc2 = pt_desc2.
                  if sod_desc <> "" then
                     sod_desc = "".
            end.
               else if sod_desc <> "" then
                  desc1 = sod_desc.

         END PROCEDURE. /* setOrderLineAndDesc */

         PROCEDURE saveCurrentQtyPricingInfo:

            if rma-issue-line and (line_pricing or not new_order)
            then do:
               assign
                  save_qty_ord = sod_det.sod_qty_ord
                  save_um      = sod_um.
               if can-find(first sob_det where sob_nbr  = sod_nbr and
                                                sob_line = sod_line) then do:
                   find first pih_hist where pih_doc_type = 1        and
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
                         for each sob_det where
                                  sob_nbr  = sod_nbr and
                                  sob_line = sod_line
                         no-lock:
                         save_parent_list = save_parent_list + sob_tot_std.
                      end.
                      save_parent_list = sod_list_pr - save_parent_list.
                   end.
                end.
                else
                   save_parent_list = sod_list_pr.
                end. /* if rma-issue-line ... */

         END PROCEDURE. /* saveCurrentQtyPricingInfo */

         PROCEDURE rollBackValues:

            s-cmdval = string(sod_det.sod_qty_ord, "->,>>>,>>9.9<<<<<<<" ).

            prev_qty_ord = sod_qty_ord * sod_um_conv.

            /* GET ROLL-BACK VALUES WHEN RELEVANT */
            /* ADDED input parameter p-edi-rollback */
            {gprun.i ""sobtbrb.p""
                     "(input recid(so_mstr),
                       input sod_line,
                       input ""pod_det"",
                       input ""pod_qty_ord"",
                       input p-edi-rollback,
                       output return-msg)" }
/*GUI*/ if global-beam-me-up then undo, leave.


         END PROCEDURE.  /* rollBackValues */

         PROCEDURE checkWhetherToChangeDB:

            find si_mstr where si_site = sod_det.sod_site no-lock.
            chg-db = (si_db <> so_db).
            if chg-db then do:
              /* Switch to the Inventory site */
              {gprun.i ""gpalias2.p"" "(sod_site,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.


              if err-flag = 0 or err-flag = 9 then do:
                 {gprun.i ""gpbascur.p"" "(output remote-base-curr)"}
/*GUI*/ if global-beam-me-up then undo, leave.

              end.

            end.

            /* Find the Cost Set */
            {gprun.i ""gpsct05.p""
                 "(input sod_part,input sod_site,input 1,
                   output glxcst,output curcst)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            if chg-db then do:
               /* Switch the database alias back to the sales order db */
               {gprun.i ""gpalias3.p"" "(so_db,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

            end.

         END PROCEDURE.  /* checkWhetherToChangeDB */

         PROCEDURE reviseManualDiscountAdjustment:

            find first wkpi_wkfl where wkpi_parent   = sobparent  and
                                       wkpi_feature  = sobfeature and
                                       wkpi_option   = sobpart    and
                                       wkpi_amt_type = "2"        and
                                       wkpi_source   = "1"
                                 no-lock no-error.

            if available wkpi_wkfl
            then do:
                  assign
                  save_disc_pct = if sod_det.sod_list_pr <> 0 then
                                     (1 - (sod_price / sod_list_pr)) * 100
                                  else
                                      0
                  sod_price     = last_sod_price
                     new_disc_pct  = save_disc_pct
                     sod_disc_pct  = new_disc_pct.

               if pic_ctrl.pic_disc_comb = "1" then do:
                  /*cascading discount*/
                  if available wkpi_wkfl then
                     do:

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
                     man_disc_pct = new_disc_pct -
                                    (save_disc_pct - wkpi_amt).
                  else
                     man_disc_pct = new_disc_pct - save_disc_pct.
               end.

               {gprun.i ""gppiwkad.p"" "(sod_um,
                                         sobparent,
                                         sobfeature,
                                         sobpart,
                                         ""1"",
                                         ""2"",
                                         0,
                                         man_disc_pct,
                                         yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* last_sod_price <> sod_price */

         END PROCEDURE.  /* reviseManualDiscountAdjustment */

         PROCEDURE adjustManualDiscountPercent:

            find first wkpi_wkfl where wkpi_parent   = sobparent  and
                                       wkpi_feature  = sobfeature and
                                       wkpi_option   = sobpart    and
                                       wkpi_amt_type = "2"        and
                                       wkpi_source   = "1"
                                  no-lock no-error.

            if not available wkpi_wkfl
            then do:
               assign
                  save_disc_pct = if sod_det.sod_list_pr <> 0 then
                                     (1 - (sod_price / sod_list_pr)) * 100
                                  else
                                      0.
               if sod_price - sod_covered_amt > 0 then
                  sod_price       = sod_price - sod_covered_amt.
               else
                  sod_price       = 0.
               assign
                  new_disc_pct = if sod_list_pr <> 0 then
                                    (1 - (sod_price / sod_list_pr)) * 100
                                 else
                                     0.

               sod_disc_pct       = new_disc_pct.

               if pic_ctrl.pic_disc_comb = "1" then do:
                  /*cascading discount*/
                  sys_disc_fact =  (100 - save_disc_pct) / 100.
                  if sys_disc_fact = 1 then
                     man_disc_pct  = new_disc_pct.
                  else do:
                     if sys_disc_fact <> 0 then
                        assign
                           discount      = (100 - new_disc_pct) / 100
                           man_disc_pct  = (1 - (discount / sys_disc_fact))
                                         * 100.
                     else
                        man_disc_pct  = new_disc_pct - 100.
                  end.
               end.
               else do:                            /*additive discount*/
                  man_disc_pct = new_disc_pct - save_disc_pct.
               end.

               /* DO NOT CREATE MANUAL OVERRIDE DISCOUNT IN WKPI_WKFL */
               /* FOR ZERO COVERAGE DISCOUNT                          */
               if man_disc_pct <> 0 then do:
                  {gprun.i ""gppiwkad.p"" "(
                                         sod_um,
                                         sobparent,
                                         sobfeature,
                                         sobpart,
                                         ""1"",
                                         ""2"",
                                         0,
                                         man_disc_pct,
                                         yes
                                        )"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end. /* IF MAN_DISC_PCT <> 0 */

               sod__qadd01 = man_disc_pct.
            end.
            else
               sod__qadd01 = 0.

         END PROCEDURE.  /* adjustManualDiscountPercent */

/*M12Q*/ /* END ADD SECTION */

         PROCEDURE p-call-apm:

            /* -----------------------------------------------------------
              Purpose:     Setup the trigger line number and Promotional
                           group for updating pricing history fields
              Parameters:
                     input:  sales_nbr   Sales order Number
                     input:  line_nbr    Sales order Line Number
                     input:  new_order   Determines whether it is a new line
                                         or existing
              input-output:  wk_bs_line  Trigger line number
              input-output:  wk_bs_promo Promotion Group

              Notes:       Because of the oracle compile size we have to
                           use this internal procedure to call APM
            -------------------------------------------------------------*/

            define input        parameter sales_nbr   like sod_nbr.
            define input        parameter line_nbr    like sod_line.
            define input        parameter new_order   like mfc_logical.
            define input-output parameter wk_bs_line  like pih_bonus_line.
            define input-output parameter wk_bs_promo like pih_promo1.

            find sod_det where sod_nbr  = sales_nbr and sod_line = line_nbr no-lock.
            if not sod_bonus then do:
               assign
                  wk_bs_line  = 0
                  wk_bs_promo = "".
            end.
            else if not new_order then do:
               if wk_bs_line = 0 and wk_bs_promo = "" then do:
                  find first pih_hist where pih_nbr = sod_nbr
                                      and   pih_line = sod_line
                                      and   pih_doc_type = 1  /**Sales Order**/
                                      and   pih_source = "1"
                                      and   pih_amt_type = "2"
                  no-lock no-error.
/*L024*           if available pih_hist and pih_bonus_line <> 0 then do: */
/*L024*/          if available pih_hist and pih_bonus_line <> 0 then
                     assign wk_bs_line  = pih_bonus_line
                            wk_bs_promo = pih_promo1.
/*L024*           end. */
               end.
            end.
         end PROCEDURE. /* END PROCEDURE*/


         PROCEDURE p-sync-restock:

            /*****************************************************************/
            /* THIS PROCEDURE RE-APPLIES A RESTOCKING CHARGE TO AN RMA       */
            /* RECEIPT LINE IF A PERCENT EXISTS AND KEEPS NECESSARY FIELDS   */
            /* IN SYNC.  IT TAKES ONE INPUT AS FOLLOWS.                      */
            /* MODE - IF "default", INITIAL SETUP FOR DEFAULT PRICING        */
            /*        IF "discount", DISCOUNT OR LIST PRICE WAS UPDATED      */
            /*        IF "price", NET PRICE WAS UPDATED                      */
            /*****************************************************************/
            define input parameter mode as character.

            if not available sod_det  or
               not available rmd_det  or
               not available rma_mstr or
               not available pic_ctrl
            then
               leave.

            if restock-pct <> 0 then do:
               if mode = "default"  or
                  mode = "discount"
               then
                  sod_price       = sod_list_pr * (1 - restock-pct / 100).
               else if mode = "price" then
                  sod_list_pr     = if restock-pct <> 100
                                       then sod_price / (1 - restock-pct / 100)
                                       else sod_list_pr.

               assign
                  restock-amt     = sod_list_pr - sod_price
                  /* SOD_DISC_PCT HOLDS RESTOCK CHARGE PERCENTAGE */
                  sod_disc_pct    = restock-pct
                  /* SOD_COVERED_AMT HOLDS RESTOCK CHARGE AMOUNT  */
                  sod_covered_amt = restock-amt.

            end.  /* if restock-pct <> 0 */

            else do:
               if mode = "default" or
                  mode = "price"
               then
                  sod_disc_pct    = if sod_list_pr <> 0
                                       then (1 - (sod_price / sod_list_pr)) * 100
                                       else 0.
               else if mode = "discount" then
                  assign
                     sod_disc_pct = if pic_so_fact
                                       then (1 - discount) * 100
                                       else discount
                     sod_price    = sod_list_pr -
                                       (sod_disc_pct * sod_list_pr * 0.01).

               assign
                  restock-amt     = 0
                  sod_covered_amt = 0.

            end.  /* else do */

            assign
               rmd_sv_code  = rma_ctype
               /* SOD_CONTR_ID HOLDS CONTRACT # IF CONTRACT SVC TYPE USED */
               sod_contr_id = if not available sv_mstr  or
                                 sv_mstr.sv_svc_type = "W"
                                 then ""
                                 else rma_contract.

            run p-disc-disp (input yes).
         END PROCEDURE.  /* p-sync-restock */


         PROCEDURE p-disc-disp:

            /*****************************************************************/
            /* THIS PROCEDURE WILL CHECK THE SO OR RMA LINE'S DISCOUNT FIELD */
            /* TO INSURE THAT IT COMPLIES WITH THE PRICING CONTROL FILE      */
            /* FORMAT.  IT TAKES ONE INPUT AS FOLLOWS.                       */
            /* WARN - IF YES, A MESSAGE WILL BE DISPLAYED WITH A PAUSE       */
            /*****************************************************************/
            define input parameter warn as logical.

            if not available sod_det or not available pic_ctrl then leave.

            disc_min_max = no.
            {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}
            if disc_min_max and warn then do:
               {mfmsg03.i 6932 3 disc_pct_err """" """"}
               /* DISCOUNT # VIOLATES THE MIN OR MAX ALLOWABLE */
               if not batchrun then pause.
            end.  /* if disc_min_max */
         END PROCEDURE.  /* p-disc-disp */

/*J39H*/ PROCEDURE p-itm-prlst-chk :
/*J39H*/    /* CHECK PRICE LIST AVAILABILITY */

/*J39H*/    if soc_pt_req
/*J39H*/    then do:
/*J39H*/       if (available wkpi_wkfl
/*L0MP** /*J39H*/ and wkpi_wkfl.wkpi_source = "1")  */
/*L0MP*/          and wkpi_wkfl.wkpi_list   = "" )
/*J39H*/          or not available wkpi_wkfl
/*J39H*/       then do:
/*J39H*/          /* CHECK PRICE LIST AVAILABILITY FOR INVENTORY ITEMS */
/*J39H*/          if right-trim(sod_det.sod_type) = ""
/*J39H*/             or (right-trim(sod_det.sod_type) <> ""
/*J39H*/             and available pt_mstr)
/*J39H*/          then do:
/*J39H*/             /* REQUIRED PRICE TABLE FOR ITEM # IN UM # NOT FOUND */
/*J39H*/             {mfmsg03.i 6231 4 sod_det.sod_part sod_det.sod_um """"}
/*L0MP*/             l_undoln = yes.
/*J39H*/             if not batchrun then
/*J39H*/                   pause.
/*L0MP** /*J39H*/    l_undoln = yes.               */
/*J39H*/          end. /* IF RIGHT-TRIM(SOD_DET.SOD_TYPE) = "" OR ... */
/*J39H*/          else
/*J39H*/             /* CHECK PRICE LIST AVAILABILITY FOR NON-INVENTORY ITEMS */
/*J39H*/             if right-trim(sod_det.sod_type) <> ""
/*J39H*/                and not available pt_mstr
/*J39H*/             then do:
/*J39H*/                /* REQUIRED PRICE TABLE FOR ITEM # IN UM # NOT FOUND */
/*J39H*/                {mfmsg03.i 6231 2 sod_det.sod_part sod_det.sod_um """"}
/*J39H*/                if not batchrun then
/*J39H*/                   pause.
/*J39H*/             end. /*IF RIGHT-TRIM(SOD_DET.SOD_TYPE) <> "" AND ...*/
/*J39H*/       end. /* IF AVAILABLE WKPI_WKFL ... */
/*J39H*/    end. /* IF SOC_PT_REQ THEN DO */
/*J39H*/ END PROCEDURE. /* p-itm-prlst-chk */

         PROCEDURE p-btb-ok:
        /* -----------------------------------------------------------
            Purpose:     Tests for an EMT Order Line.  If found and this
                         is the primary SO with related PO status reflecting
                         some processing at the Secondary SO or this is a
                         Secondary SO and the line is a configured item,
                         then prevent any changes.  Undo the logic and
                         return to sosomta.p
                         type 02 or 03
            Parameters:  l-error   when set to yes, undo will occur
                                   upon return to the main procedure
            Notes:
         -------------------------------------------------------------*/

/*M11Z*/ define output parameter p-error  like mfc_logical initial no no-undo.
/*M11Z*/ define output parameter p-errnum like msg_nbr                no-undo.

/*M11Z*/ define variable l-errsev   as   integer initial 3 no-undo.

            find so_mstr where recid(so_mstr) = so_recno no-lock no-error.
            find sod_det where recid(sod_det) = sod_recno no-lock no-error.

/*M11Z*     btb_ok = yes. */
/*M11Z*/    assign
/*M11Z*/       l-errsev = 3
/*M11Z*/       p-errnum = 0
/*M17W* /*M11Z*/ p-error  = no. */
/*M17W*/       p-error  = yes.

            if so_primary then do:

               find pod_det where pod_nbr  = sod_btb_po
                              and pod_line = sod_btb_pod_line
               no-lock no-error.

/*M11Z*/       find po_mstr where po_nbr = sod_btb_po no-lock no-error.

/*M11Z*/       if (available po_mstr and (po_stat = "C" or po_stat = "X")) or
/*M11Z*/          (available pod_det and (pod_status = "C" or pod_status = "X"))
/*M11Z*/       then do:
/*M11Z*/          assign
/*M11Z*/             l-errsev = 2
/*M11Z*/             /* PO Order/Line is closed or cancelled. Continue? */
/*M11Z*/             p-errnum = 4639.
/*M11Z*/       end.

               else if available pod_det and pod_so_status <> "" then do:
/*M11Z*           if pod_so_status = "P" then v_picked = yes. */
/*M11Z*           else btb_ok = no.                           */

/*M11Z*/          /* Secondary BU Order has been picked */
/*M11Z*/          if pod_so_status = "P" then do:
/*M11Z*/             if can-find (mfc_ctrl
                           where mfc_field  = "soc_emt_pick"
                             and mfc_logical)
/*M11Z*/             then
/*M11Z*/                assign
/*M11Z*/                   l-errsev = 2
/*M11Z*/                   /* Inventory Picked at Supplier, Continue? */
/*M11Z*/                   p-errnum = 4615.
/*M11Z*/             else
/*M11Z*/                assign
/*M11Z*/                   /* Inventory Picked at Supplier, change not allowed */
/*M11Z*/                   p-errnum = 2023.
/*M11Z*/          end. /* if status = "P" */

/*M11Z*/          /* Secondary BU Order has been Released to WO */
/*M11Z*/          else if pod_so_status = "W" then do:
/*M11Z*/             if can-find (mfc_ctrl
                           where mfc_field  = "soc_emt_rel"
                             and mfc_logical)
/*M11Z*/             then
/*M11Z*/                assign
/*M11Z*/                   l-errsev = 2
/*M11Z*/                   /* Released to WO at supplier.  Continue? */
/*M11Z*/                   p-errnum = 4619.
/*M11Z*/             else
/*M11Z*/                assign
/*M11Z*/                   /* Released to WO at supplier. Change not allowed */
/*M11Z*/                   p-errnum = 4618.
/*M11Z*/          end. /* if status = "W" */

/*M11Z*/          /* Secondary BU Order has been shipped */
/*M11Z*/          else if pod_so_status = "S" then do:
/*M11Z*/             if can-find (mfc_ctrl
                           where mfc_field  = "soc_emt_ship"
                             and mfc_logical)
/*M11Z*/             then
/*M11Z*/                assign
/*M11Z*/                   l-errsev = 2
/*M11Z*/                   /* Quantity shipped at supplier.  Continue ? */
/*M11Z*/                   p-errnum = 4617.
/*M11Z*/             else
/*M11Z*/                assign
/*M11Z*/                   /* Change not allowed. Lines already shipped */
/*M11Z*/                   p-errnum = 2864.
/*M11Z*/          end. /* if status = "S" */

/*M11Z*/          /* Unknown Status */
/*M11Z*/          else
/*M11Z*/             assign
/*M11Z*/                l-errsev = 3
/*M11Z*/                p-errnum = 2825.

/*M11Z*/       end. /* if available pod_det and pod_so_status <> "" */

            end.
            /* Do not allow modifcation of SBU Lines with configured items */
            /* If this is a secondary Order                                */
            else
            if can-find(first sob_det where sob_nbr  = sod_nbr
                                        and sob_line = sod_line) then
/*M11Z*        btb_ok = no. */
/*M11Z*/       assign
/*M11Z*/          l-errsev = 3
/*M11Z*/          p-errnum = 2859.

/*M11Z*/     if l-errsev = 3 and p-errnum <> 0 then do:
/*M11Z*/        hide message no-pause.
/*M11Z*/        {mfmsg.i p-errnum l-errsev}
/*M11Z*/        if not batchrun then pause.
/*M11Z*/        p-error = yes.
/*M11Z*/     end.

/*M11Z*/     else if l-errsev = 2 and p-errnum <> 0 then do:
/*M11Z*/        hide message no-pause.
/*M11Z*/        {mfmsg01.i p-errnum l-errsev yn}
/*M17W*/        if yn then
/*M17W*/           p-error = no.
/*M17W* /*M11Z*/  if not yn then    */
/*M17W* /*M11Z*/     p-error = yes. */
/*M11Z*/     end.

/*M11Z*/     else
/*M11Z*/        p-error = no.

         END PROCEDURE.


/*H1HQ*/ PROCEDURE p-calc-fr-wt :

/*H1HQ*/    /***************************************************************/
/*H1HQ*/    /* THIS PROCEDURE IS CALLED TO CALCULATE FREIGHT WEIGHT IN     */
/*H1HQ*/    /* MULTI ENTRY MODE FOR INVENTORY ITEMS WITH CALCULATE FREIGHT */
/*H1HQ*/    /* SET TO YES AS NEW SALES ORDER LINE IS CREATED.              */
/*H1HQ*/    /***************************************************************/

/*H1HQ*/    define variable l_um_conv     like sod_um_conv no-undo.
/*H1HQ*/    define variable l_frc_returns like mfc_char    no-undo.

/*H1HQ*/    if not available sod_det or not available pt_mstr then leave.

/*H1HQ*/    if sod_type = "" then do :

/*H1HQ*/       if sod_um <> pt_um then do :
/*H1HQ*/          {gprun.i ""gpumcnv.p"" "(input sod_um,
                                   input pt_um,
                               input sod_part,
                               output l_um_conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*H1HQ*/          if l_um_conv = ? then do :
/*H1HQ*/             /* FREIGHT ERROR DETECTED - CHARGES MAY BE INCOMPLETE */
/*H1HQ*/             {mfmsg.i 669 2}
/*H1HQ*/             if not batchrun then pause.
/*H1HQ*/             l_um_conv = 1.
/*H1HQ*/          end. /* IF L_UM_CONV = ? */

/*H1HQ*/       end. /* SOD_UM <> PT_UM */
/*H1HQ*/       else l_um_conv = 1.

/*H1HQ*/       find mfc_ctrl where mfc_field = "frc_returns" no-lock no-error.
/*H1HQ*/       l_frc_returns = mfc_char.
/*H1HQ*/       if sod_qty_ord < 0 and l_frc_returns = "z" then sod_fr_wt = 0.
/*H1HQ*/       else sod_fr_wt = pt_ship_wt * l_um_conv.

/*H1HQ*/       sod_fr_wt_um = pt_ship_wt_um.
/*H1HQ*/    end. /* IF SOD_TYPE = "" */

/*H1HQ*/ END PROCEDURE. /* p-calc-fr-wt */


/*J2D8** ADDED INTERNAL PROCEDURE ******************/

         procedure find-ptp-j2d8:

            define input parameter inpar_part like pt_part.
            define input parameter inpar_site like si_site.

            find ptp_det where ptp_part = inpar_part and ptp_site = inpar_site
               no-lock no-error.
            if available ptp_det then pm_code = ptp_pm_code.
         end procedure.

/*J2D8** END PROCEDURE ******************************/


/*L0DD*/ /* REPLACE DEL-WKPI WITH DEL-WKPI-WKFL-NO AND DEL-WKPI-WKFL-YN */

/*L0DD***BEGIN DELETE***
 * /*J2D8** ADDED INTERNAL PROCEDURE ******************/

 *       procedure del-wkpi:

 *          define input parameter confg-disc as logical.
 *          define input parameter wsource as logical.

 *          for each wkpi_wkfl where
 *             lookup(wkpi_amt_type, "2,3,4,9") <> 0 and
 *             wkpi_confg_disc = confg-disc exclusive-lock:
 *             if not wsource then delete wkpi_wkfl.
 *             if wsource then do:
 *                if wkpi_source = "0" then delete wkpi_wkfl.
 *             end.
 *          end.
 *       end procedure.

 * /*J2D8** END PROCEDURE ******************************/
 *L0DD***END DELETE**/

/*L0DD*/ PROCEDURE del-wkpi-wkfl-no:

/*L0DD*/    for each wkpi_wkfl where lookup(wkpi_amt_type, "2,3,4,9") <> 0 and
/*L0DD*/                             wkpi_confg_disc = no exclusive-lock:
/*L0DD*/       delete wkpi_wkfl.
/*L0DD*/    end.
/*L0DD*/ END PROCEDURE. /* DEL-WKPI-WKFL-NO */

/*L0DD*/ PROCEDURE del-wkpi-wkfl-yn:

/*L0DD*/    for each wkpi_wkfl where lookup(wkpi_amt_type, "2,3,4,9") <> 0 and
/*L0DD*/                             wkpi_source     = "0"                 and
/*L0DD*/                             wkpi_confg_disc = yes exclusive-lock:
/*L0DD*/       delete wkpi_wkfl.
/*L0DD*/    end.
/*L0DD*/ END PROCEDURE. /* DEL-WKPI-WKFL-YN */

/*L024*/ procedure sod-conv:

/*L024*/    define input  parameter insodstdcost  like sod_std_cost no-undo.
/*L024*/    define output parameter outsodstdcost like sod_std_cost no-undo.

/*L024*/    {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input  remote-base-curr,
                 input  base_curr,
                 input  exch-rate,
                 input  exch-rate2,
                 input  insodstdcost,
                 input  false,
                 output outsodstdcost,
                 output mc-error-number)"}.
/*L024*/    if mc-error-number <> 0 then do:
/*L024*/       {mfmsg.i mc-error-number 2}
/*L024*/    end.

/*L024*/ end procedure.  /* sod-conv */

/*J2VF*/ PROCEDURE p-assign-msg:
/*J2VF*/    define output parameter l_err_msg as character no-undo.

/*J2VF*/    /* USER DOES NOT HAVE ACCESS TO THIS FIELD */
/*J2VF*/    {mfmsg10.i 4072 4 l_err_msg """" """" """" }

/*J2VF*/ END PROCEDURE.  /* P-ASSIGN-MSG */

/*J2VZ*/ PROCEDURE p-bestprice:

/*J2VZ*/       /* BEFORE RE-PRICING DELETE PREVIOUSLY SELECTED PRICE LIST */
/*J2VZ*/       /* RECORDS EXCEPT LIST PRICE. RETAIN ALL MANUAL OVERRIDE   */
/*J2VZ*/       /* RECORDS.                                                */
/*J2VZ*/       for each wkpi_wkfl
/*J2VZ*/           where wkpi_amt_type <> "1" and
/*J2VZ*/                 wkpi_source = "0" exclusive-lock:
/*J2VZ*/           delete wkpi_wkfl.
/*J2VZ*/       end.

/*J2VZ*/       /* GET BEST DISCOUNT TYPE PRICE LISTS */
/*M017* IF APM IS IN USE AND CUSTOMER AND ITEM ARE USED BY APM
 *M017* THEN CALL THE APM PRICE LIST SELECTION ROUTINE        */
/*M017*/    if soc_ctrl.soc_apm
/*M017*/       and available cm_mstr
/*M017*/       and cm_mstr.cm_promo <> ""
/*M017*/       and pt_mstr.pt_promo <> "" then do:
/*M017*/       {gprun.i ""gppiapm1.p"" "(
                  pics_type,
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

/*M017*/    end. /* IF SOC_APM */
/*M017*/    else do: /* IF NOT SOC_APM */
/*J2VZ*/       {gprun.i ""gppibx.p"" "(
                                       pics_type,
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

/*M017*/    end. /* IF NOT SOC_APM */

/*J2VZ*/       /* CALCULATE BEST PRICE, FOR NON GLOBAL DISCOUNTS */
/*J2VZ*/       {gprun.i ""gppibx04.p"" "(
                                         sobparent,
                                         sobfeature,
                                         sobpart,
                                         no,
                                         rfact)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J2VZ*/       /* CALCULATE BEST PRICE, FOR GLOBAL DISCOUNTS */
/*J2VZ*/       {gprun.i ""gppibx04.p"" "(
                                         sobparent,
                                         sobfeature,
                                         sobpart,
                                         yes,
                                         rfact)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J2VZ*/       assign
/*J2VZ*/          sod_det.sod_price = best_net_price
/*J2VZ*/          save_disc_pct =
/*J2VZ*/             if sod_det.sod_list_pr <> 0 then
/*J2VZ*/                (1 - (sod_det.sod_price / sod_det.sod_list_pr)) * 100
/*J2VZ*/             else
/*J2VZ*/                0.

/*J2VZ*/ END PROCEDURE.  /* P-BESTPRICE */

/*M017*/ /**** BEGIN NEW SECTION ****/

         PROCEDURE apm-pricing1:
            /* -----------------------------------------------------------
            Purpose:     Runs the pricing routines for either APM or
                         standard pricing. Is used to reduce action
                         segment size.
            Parameters:  <None>
            Notes:
            -------------------------------------------------------------*/

            /* IF APM IS IN USE AND CUSTOMER AND ITEM ARE USED BY APM */
            /* THEN CALL THE APM PRICE LIST SELECTION ROUTINE         */
            if soc_ctrl.soc_apm
               and available cm_mstr
               and cm_mstr.cm_promo <> ""
               and pt_mstr.pt_promo <> "" then do:
/*J3GV*/       /* CHANGED 12th INPUT PARAMETER TO SOC_PT_REQ  */
/*J3GV*/       /* FROM SOC_CTRL.SOC_PT_REQ                    */
               {gprun.i ""gppiapm1.p"" "(
                  pics_type,
                  picust,
                  part_type,
                  sod_det.sod_part,
                  sobparent,
                  sobfeature,
                  sobpart,
                  1,
                  so_mstr.so_curr,
                  sod_det.sod_um,
                  sod_det.sod_pricing_dt,
                  soc_pt_req,
                  sod_det.sod_site,
                  so_mstr.so_ex_rate,
                  so_mstr.so_ex_rate2,
                  sod_det.sod_nbr,
                  sod_det.sod_line,
                  sod_det.sod_div,
                  output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* IF SOC_APM */
            else do: /* IF NOT SOC_APM */
/*J3GV*/       /* CHANGED 12th INPUT PARAMETER TO SOC_PT_REQ  */
/*J3GV*/       /* FROM SOC_CTRL.SOC_PT_REQ                    */
               {gprun.i ""gppibx.p"" "(
                  pics_type,
                  picust,
                  part_type,
                  sod_det.sod_part,
                  sobparent,
                  sobfeature,
                  sobpart,
                  1,
                  so_mstr.so_curr,
                  sod_det.sod_um,
                  sod_det.sod_pricing_dt,
                  soc_pt_req,
                  sod_det.sod_site,
                  so_mstr.so_ex_rate,
                  so_mstr.so_ex_rate2,
                  sod_det.sod_nbr,
                  sod_det.sod_line,
                  output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* IF NOT SOC_APM */
         END PROCEDURE. /* APM-PRICING1 */


         PROCEDURE apm-pricing2:
            /* -----------------------------------------------------------
            Purpose:     Runs the 2nd pricing routine for either APM or
                         standard pricing. Is used to reduce action
                         segment size.
            Parameters:  <None>
            Notes:
            -------------------------------------------------------------*/
            /* IF APM IS IN USE AND CUSTOMER AND ITEM ARE USED BY APM */
            /* THEN CALL THE APM PRICE LIST SELECTION ROUTINE         */
            if soc_ctrl.soc_apm
               and available cm_mstr
               and cm_mstr.cm_promo <> ""
               and pt_mstr.pt_promo <> "" then do:
               {gprun.i ""gppiapm1.p"" "(
                  pics_type,
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

            end.  /* IF SOC_APM  */
            else do:  /* IF NOT SOC_APM */
               {gprun.i ""gppibx.p"" "(
                  pics_type,
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

            end. /* IF NOT SOC_APM */
         END PROCEDURE. /* APM-PRICING2 */

/*M017*/ /**** END NEW SECTION ****/

/*J37J*/ PROCEDURE p-bestprice-zero:

/*J37J*/    /* IF BEST LIST PRICE IS ZERO AND IF MARKUP OR NET PRICE          */
/*J37J*/    /* IS SELECTED ALONG WITH DISCOUNT PRICE LIST THEN DISCOUNT AND   */
/*J37J*/    /* LIST PRICE IS CALCULATED ACCORDINGLY                           */

/*L124*/    define variable l_list_id like wkpi_list_id no-undo.
/*L124*/    define variable l_list    like wkpi_list    no-undo.
/*L124*/    define variable l_source  like wkpi_source  no-undo.
/*L16Y*/    define variable l_part    like wkpi_option  no-undo.

/*L16Y*/    /* REPLACED FIND FIRST WITH FOR EACH wkpi_wkfl FOR */
/*L16Y*/    /* CONFIGURED ITEMS                                */

/*L16Y** BEGIN DELETE **
 * /*J37J*/ find first wkpi_wkfl where wkpi_amt_type = "3" or
 * /*J37J*/                            wkpi_amt_type = "4" no-lock no-error.
 * /*J37J*/ if available wkpi_wkfl then do:
 *L16Y** END DELETE */

/*L16Y*/    for each wkpi_wkfl
/*L16Y*/       where wkpi_amt_type = "3"
/*L16Y*/       or    wkpi_amt_type = "4" no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


/*L124*/       assign
/*L124*/          l_list_id = wkpi_list_id
/*L124*/          l_list    = wkpi_list
/*L124*/          l_source  = wkpi_source.

/*J37J*/       if wkpi_amt_type = "3" then do:
/*J37J*/          if available pt_mstr then do:

/*L16Y*/             l_part = (if wkpi_option = ""
/*L16Y*/                       then
/*L16Y*/                          pt_part
/*L16Y*/                       else
/*L16Y*/                          wkpi_option).

/*J37J*/             find pi_mstr where pi_list_id = wkpi_list_id no-lock.
/*J37J*/                if pi_cost_set = "" then do:

/*L16Y*/                   /* REPLACED 1st PARAMETER FROM pt_part TO l_part */
/*J37J*/                   {gprun.i ""gpsct05x.p"" "(l_part,
                                                     sod_det.sod_site,
                                                     1,
                                                     output glxcst,
                                                     output curcst)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*J37J*/                end. /* IF PI_COST_SET = "" */
/*J37J*/                else do:

/*L16Y*/                   /* REPLACED 1st PARAMETER FROM pt_part TO l_part */
/*J37J*/                   {gprun.i ""gpsct07x.p"" "(l_part,
                                                     sod_det.sod_site,
                                                     pi_cost_set,
                                                     1,
                                                     output glxcst)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*J37J*/                end. /* IF PI_COST_SET <> "" */
/*L124** /*J37J*/       item_cost = glxcst * so_mstr.so_ex_rate * */
/*L124** /*J37J*/                            sod_det.sod_um_conv. */

/*L124*/                {gprunp.i "mcpl" "p" "mc-curr-conv"
                           "(input base_curr,
                             input so_mstr.so_curr,
                             input so_mstr.so_ex_rate2,
                             input so_mstr.so_ex_rate,
                             input glxcst * sod_det.sod_um_conv,
                             input false,
                             output item_cost,
                             output mc-error-number)"}.
/*L124*/                if mc-error-number <> 0
/*L124*/                   then {mfmsg.i mc-error-number 2}.

/*J37J*/          end. /* IF AVAILABLE PT_MSTR */

/*L16Y** /*J37J*/ sod_list_pr = item_cost * (1 + wkpi_amt / 100). */
/*L16Y*/          sod_list_pr = sod_list_pr +
/*L16Y*/                        item_cost   * (1 + wkpi_amt / 100).

/*J37J*/       end. /* IF WKPI_AMT_TYPE = "3" */
/*J37J*/       else
/*L16Y** /*J37J*/ sod_det.sod_list_pr = wkpi_amt. */
/*L16Y*/          sod_det.sod_list_pr = sod_det.sod_list_pr + wkpi_amt.
/*L16Y*/    end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH wkpi_wkfl */

/*J37J*/       if sod_det.sod_list_pr <> 0 then
/*J37J*/          sod_det.sod_disc_pct = (1 - (sod_det.sod_price /
/*J37J*/                                       sod_det.sod_list_pr)) * 100.
/*J37J*/       else
/*M0LX*/          assign
/*M0LX*/             sod_det.sod_list_pr  = sod_det.sod_price
/*J37J*/             sod_det.sod_disc_pct = 0.

/*L16Y** /*J37J*/    end. /* IF AVAILABLE WKPI_WKFL */ */
/*L16Y** /*J37J*/    else */
/*L16Y*/        if l_list_id = ""
/*L16Y*/        then

/*J37J*/    /* IF BEST LIST PRICE SELECTED IS ZERO AND IF NO PRICE LIST EXIST */
/*J37J*/      assign
/*J37J*/         sod_det.sod_disc_pct = 0
/*L124*/         l_source = "4"
/*J37J*/         sod_det.sod_list_pr = sod_det.sod_price.

/*L124*/      if l_flag
/*L124*/         then l_source = "1".

/*J37J*/      display sod_det.sod_list_pr sod_det.sod_disc_pct @ discount
/*J37J*/                 with frame c.

/*L124*/    /* CHANGED FIFTH PARAMETER FROM "1" TO l_source */
/*J37J*/    {gprun.i ""gppiwkad.p"" "(sod_um,
                                      sobparent,
                                      sobfeature,
                                      sobpart,
                                      l_source,
                                      ""1"",
                                      sod_det.sod_list_pr,
                                      sod_det.sod_disc_pct,
                                      no )"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*L124*/     if not l_flag
/*L124*/     then do:
/*L124*/        find first wkpi_wkfl
/*L124*/           where wkpi_parent   = sobparent
/*L124*/           and   wkpi_feature  = sobfeature
/*L124*/           and   wkpi_option   = sobpart
/*L124*/           and   wkpi_amt_type = "1"
/*L124*/        exclusive-lock no-error.

/*L124*/        if available wkpi_wkfl
/*L124*/           then assign
/*L124*/              wkpi_list_id = l_list_id
/*L124*/              wkpi_list    = l_list.
/*L124*/     end. /* IF NOT l_flag */

/*J37J*/ END PROCEDURE.  /* P-BESTPRICE-ZERO */

/*J3GV*/ PROCEDURE chk-pl-exist :

/*J3GV*/ /* THIS PROCEDURE GIVES AN ERROR WHEN SOC_PT_REQ = YES AND NO     */
/*J3GV*/ /* PRICE LIST WAS FOUND FOR ANY MANDATORY/NON-MANDATORY COMPONENT */
/*J3GV*/ /* OF A CONFIGURED PRODUCT                                        */

/*J3GV*/    for each sob_det
/*J3GV*/       fields (sob_feature sob_line sob_nbr sob_parent
/*J3GV*/               sob_part sob_tot_std) where
/*J3GV*/       sob_nbr = sod_det.sod_nbr and
/*J3GV*/       sob_line = sod_det.sod_line no-lock :
/*GUI*/ if global-beam-me-up then undo, leave.


/*J3GV*/       find first wkpi_wkfl where
/*J3GV*/          wkpi_parent  = sob_parent  and
/*J3GV*/          wkpi_feature = sob_feature and
/*J3GV*/          wkpi_option  = sob_part    and
/*J3GV*/          wkpi_amt_type = "1" no-lock no-error.

/*J3GV*/       /* GIVING ERROR WHEN NO PRICE LIST WAS FOUND AND THE PRICE     */
/*J3GV*/       /* WAS MANUALLY ENTERED OR WHEN THE PRICE WAS FROM ITEM MASTER */
/*J3GV*/       if (available wkpi_wkfl and
/*J3GV*/           ( (wkpi_source = "1" and wkpi_list = "") or
/*J3GV*/             wkpi_source = "4")) or
/*J3GV*/           not available wkpi_wkfl then
/*J3GV*/       do :
/*J3GV*/          /* ERROR: REQUIRED PRICE TABLE FOR ITEM # IN UM # NOT FOUND */
/*J3GV*/          {mfmsg03.i 6231 4 sob_part sod_um """"}
/*J3GV*/          l_undoln = yes.
/*J3GV*/          if not batchrun then
/*J3GV*/             pause.
/*J3GV*/          return.
/*J3GV*/       end. /* IF AVAILABLE WKPI_WKFL AND ... */

/*J3GV*/    end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH SOB_DET */

/*J3GV*/ end. /* PROCEDURE CHK-PL-EXIST */


/*J3K7*/ PROCEDURE p-shipper-check:

/*J3K7*/    /* CHECK FOR EXISTENCE OF CONFIRMED/UNCONFIRMED SHIPPER */

/*J3K7*/    assign
/*J3K7*/       l_conf_ship   = 0
/*J3K7*/       shipper_found = 0.

/*J3K7*/    /* ADDED TWO OUTPUT PARAMETERS L_CONF_SHIP, L_CONF_SHID */
/*J3K7*/    {gprun.i ""rcsddelb.p"" "(input sod_det.sod_nbr,
                                      input sod_det.sod_line,
                                      input sod_det.sod_site,
                                      output shipper_found,
                                      output save_abs,
                                      output l_conf_ship,
                                      output l_conf_shid)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J3K7*/    if shipper_found > 0 then do:
/*J3K7*/       assign
/*J3K7*/          l_undotran = yes
/*J3K7*/          save_abs   = substring(save_abs,2,20).

/*J3K7*/       /* # SHIPPERS/CONTAINERS EXISTS FOR ORDER, INCLUDING # */
/*J3K7*/       {mfmsg03.i 1118 3 shipper_found save_abs """"}
/*J3K7*/    end. /* IF SHIPPER_FOUND > 0 */

/*J3K7*/    /* IF ALL THE SHIPPERS FOR THE ORDER HAVE BEEN CONFIRMED      */
/*J3K7*/    /* & INVOICE POSTED DISPLAY WARNING AND ALLOW TO DELETE ORDER */

/*J3K7*/    else if l_conf_ship > 0 then
/*J3K7*/    do:
/*J3K7*/       l_conf_shid = substring(l_conf_shid,2,20).
/*J3K7*/       /* # CONFIRMED SHIPPERS EXIST FOR ORDER, INCLUDING # */
/*J3K7*/       {mfmsg03.i 3314 2 l_conf_ship l_conf_shid """"}

/*J3K7*/       /* PAUSING FOR USER TO SEE THE MESSAGE */
/*J3K7*/       if not batchrun then
/*J3K7*/          pause.
/*J3K7*/    end. /* IF L_CONF_SHIP > 0 */

/*J3K7*/ END PROCEDURE. /* P-SHIPPER-CHECK */

         PROCEDURE check-order-modifiers:
         /* -----------------------------------------------------------
            Purpose:     Checks the order modifiers for btb orders of
                         type 02 or 03
            Parameters:  warning
            Notes:       Added with ECO *M11Z*
         -------------------------------------------------------------*/
         define output parameter l-warning like mfc_logical initial no no-undo.

         /* CHECK ITEM/SITE DATA FIRST */
         for first ptp_det
         fields(ptp_ord_max ptp_ord_min ptp_ord_mult
                ptp_part ptp_pm_code ptp_site)
         where ptp_part = sod_det.sod_part
           and ptp_site = sod_det.sod_site
         no-lock:
             if ((ptp_ord_max <> 0 and sod_det.sod_qty_ord > ptp_ord_max)
             or (ptp_ord_min <> 0 and sod_det.sod_qty_ord < ptp_ord_min)
             or (ptp_ord_mult <> 0
             and sod_det.sod_qty_ord modulo ptp_ord_mult <> 0))
            then
               l-warning = yes.
         end. /* FOR FIRST PTP_DET */

         if not available ptp_det then
         for first pt_mstr
         fields(pt_ord_max pt_ord_min pt_ord_mult
                pt_part pt_pm_code pt_price)
         where pt_part = sod_det.sod_part no-lock:
            if  ( (pt_ord_max <> 0  and sod_det.sod_qty_ord > pt_ord_max)
               or (pt_ord_min <> 0  and sod_det.sod_qty_ord < pt_ord_min)
               or (pt_ord_mult <> 0
            and sod_det.sod_qty_ord modulo pt_ord_mult <> 0) )
            then
               l-warning = yes.
         end. /* FOR FIRST PT_MSTR */

         END PROCEDURE.

/*M12Q Added Code ********************************************************* */

         PROCEDURE updateWithApoAtpData:
/* ---------------------------------------------------------------------------
Purpose:       This procedure calls the routine that confirms
               APO ATP demand for order entry.
Exceptions:    None
Conditions:
Pre:
Post:
Notes:
History:

Inputs/Outputs:
None
----------------------------------------------------------------------------*/

            /* When apoEarliestDate = ?  then   */
            /* no changes were made by APO ATP  */
            if apoEarliestDate <> ? then do:
               if not sngl_ln or (errorResult = "2" or errorResult = "3") then
                  assign
                     sod_det.sod_site     = apoSiteId
                     sod_det.sod_due_date = apoEarliestDate
                     sod_det.sod_qty_ord  = apoQuantityOnRequestDate.
               else if errorResult = "1" then
                  assign
                     sod_det.sod_site     = apoSiteId
                     sod_det.sod_due_date = apoEarliestDate.
            end.

         END PROCEDURE. /* updateWithApoAtpData */

         PROCEDURE confirmApoAtpDemand:
/* ---------------------------------------------------------------------------
Purpose:       This procedure updates the order line fields with
               APO ATP data returned.
Exceptions:    None
Conditions:
Pre:
Post:
Notes:
History:

Inputs/Outputs:
None
----------------------------------------------------------------------------*/

            if useApoAtp and apoConnected then do:
               {gprunmo.i
                  &program= "giapoco.p"
                  &module= "GI1"
                  &param="""(input so_mstr.so_nbr,
                           input sod_det.sod_line,
                           input sod_site,
                           input sod_part,
                           output apoDemandId,
                           output apoMessageNumber,
                           output apoError)"""}

               if apoError then
                  {mfmsg.i apoMessageNumber 2}
            end.

         END PROCEDURE. /* confirmApoAtpDemand */

/*M12Q End Added Code */
