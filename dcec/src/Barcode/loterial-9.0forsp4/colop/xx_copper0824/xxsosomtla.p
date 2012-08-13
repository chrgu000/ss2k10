/* xxsosomtla.p - SALES ORDER MAINTENANCE LINE PRICE/QTY SUBROUTINE             */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.138.1.4 $                                                      */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED: 03/21/90   BY: ftb *D011*                */
/* REVISION: 6.0      LAST MODIFIED: 04/06/90   BY: ftb *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 04/10/90   BY: MLB *D021*                */
/* REVISION: 6.0      LAST MODIFIED: 08/30/90   BY: EMB *D040*                */
/* REVISION: 6.0      LAST MODIFIED: 08/09/90   BY: MLB *D055*                */
/* REVISION: 6.0      LAST MODIFIED: 12/19/90   BY: afs *D266*                */
/* REVISION: 6.0      LAST MODIFIED: 01/18/91   BY: emb *D307*                */
/* REVISION: 6.0      LAST MODIFIED: 01/31/91   BY: afs *D327*                */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*                */
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 03/23/92   BY: dld *F297*                */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: afs *F356*                */
/* REVISION: 7.0      LAST MODIFIED: 04/16/92   BY: dld *F382*                */
/* REVISION: 7.0      LAST MODIFIED: 04/22/92   BY: afs *F420*                */
/* REVISION: 7.0      LAST MODIFIED: 04/30/92   BY: tjs *F463*                */
/* REVISION: 7.0      LAST MODIFIED: 05/06/92   BY: tjs *F470*                */
/* REVISION: 7.0      LAST MODIFIED: 06/11/92   BY: tjs *F504*                */
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: afs *F519*                */
/* REVISION: 7.0      LAST MODIFIED: 07/08/92   BY: tjs *F723*                */
/* REVISION: 7.0      LAST MODIFIED: 07/29/92   BY: tjs *F802*                */
/* REVISION: 7.0      LAST MODIFIED: 08/21/92   BY: afs *F862*                */
/* REVISION: 7.3      LAST MODIFIED: 09/15/92   BY: tjs *G035*                */
/* REVISION: 7.3      LAST MODIFIED: 10/28/92   BY: afs *G244*                */
/* REVISION: 7.3      LAST MODIFIED: 11/23/92   BY: tjs *G191*                */
/* REVISION: 7.3      LAST MODIFIED: 12/08/92   BY: tjs *G391*                */
/* REVISION: 7.3      LAST MODIFIED: 01/12/92   BY: tjs *G507*                */
/* REVISION: 7.3      LAST MODIFIED: 01/04/92   BY: afs *G501*                */
/* REVISION: 7.3      LAST MODIFIED: 02/08/92   BY: bcm *G415*                */
/* REVISION: 7.3      LAST MODIFIED: 02/18/93   BY: afs *G692*                */
/* REVISION: 7.3      LAST MODIFIED: 02/24/93   BY: sas *G457*                */
/* REVISION: 7.3      LAST MODIFIED: 04/10/93   BY: tjs *G830*                */
/* REVISION: 7.3      LAST MODIFIED: 04/27/93   BY: WUG *GA46*                */
/* REVISION: 7.3      LAST MODIFIED: 05/17/93   BY: afs *GB06*                */
/* REVISION: 7.3      LAST MODIFIED: 05/20/93   BY: kgs *GB18*                */
/* REVISION: 7.4      LAST MODIFIED: 06/21/93   BY: pcd *H008*                */
/* REVISION: 7.4      LAST MODIFIED: 08/06/93   BY: tjs *H059*                */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*                */
/* REVISION: 7.4      LAST MODIFIED: 09/29/93   BY: cdt *H086*                */
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184*                */
/* REVISION: 7.4      LAST MODIFIED: 11/22/93   BY: afs *H238*                */
/* REVISION: 7.4      LAST MODIFIED: 02/07/94   BY: afs *FL83*                */
/* REVISION: 7.4      LAST MODIFIED: 03/10/94   BY: cdt *H294*                */
/* REVISION: 7.4      LAST MODIFIED: 03/16/94   BY: afs *H295*                */
/* REVISION: 7.3      LAST MODIFIED: 04/25/94   BY: cdt *GJ56*                */
/* REVISION: 7.4      LAST MODIFIED: 05/27/94   BY: dpm *FO23*                */
/* REVISION: 7.4      LAST MODIFIED: 05/27/94   BY: qzl *H376*                */
/* REVISION: 7.4      LAST MODIFIED: 06/16/94   BY: qzl *H390*                */
/* REVISION: 7.3      LAST MODIFIED: 06/29/94   BY: cdt *GK52*                */
/* REVISION: 7.3      LAST MODIFIED: 06/15/94   BY: WUG *GK60*                */
/* REVISION: 7.3      LAST MODIFIED: 07/11/94   BY: dpm *FP33*                */
/* REVISION: 7.4      LAST MODIFIED: 07/18/94   BY: bcm *H443*                */
/* REVISION: 7.4      LAST MODIFIED: 07/21/94   BY: WUG *GK86*                */
/* REVISION: 7.4      LAST MODIFIED: 08/09/94   BY: bcm *H476*                */
/* REVISION: 7.4      LAST MODIFIED: 08/15/94   BY: WUG *FQ14*                */
/* REVISION: 7.4      LAST MODIFIED: 09/09/94   BY: afs *H510*                */
/* REVISION: 7.4      LAST MODIFIED: 09/26/94   BY: ljm *GM78*                */
/* REVISION: 7.4      LAST MODIFIED: 10/10/94   BY: bcm *H561*                */
/* REVISION: 7.4      LAST MODIFIED: 10/16/94   BY: dpm *FR95*                */
/* REVISION: 8.5      LAST MODIFIED: 10/18/94   BY: mwd *J034*                */
/* REVISION: 7.4      LAST MODIFIED: 11/02/94   BY: rxm *FT18*                */
/* REVISION: 7.4      LAST MODIFIED: 11/11/94   BY: qzl *FT43*                */
/* REVISION: 7.4      LAST MODIFIED: 12/13/94   BY: afs *FU56*                */
/* REVISION: 7.4      LAST MODIFIED: 01/13/95   BY: dpm *F0DR*                */
/* REVISION: 7.4      LAST MODIFIED: 01/25/95   BY: bcm *F0G8*                */
/* REVISION: 7.4      LAST MODIFIED: 02/10/95   BY: rxm *F0HM*                */
/* REVISION: 7.4      LAST MODIFIED: 03/03/95   BY: rxm *F0LM*                */
/* REVISION: 7.4      LAST MODIFIED: 03/14/95   BY: rxm *G0H7*                */
/* REVISION: 7.4      LAST MODIFIED: 03/21/95   BY: rxm *F0MV*                */
/* REVISION: 8.5      LAST MODIFIED: 03/07/95   BY: DAH *J042*                */
/* REVISION: 8.5      LAST MODIFIED: 07/11/95   BY: DAH *J05G*                */
/* REVISION: 8.5      LAST MODIFIED: 08/14/95   BY: DAH *J063*                */
/* REVISION: 8.5      LAST MODIFIED: 09/10/95   BY: DAH *J07R*                */
/* REVISION: 8.5      LAST MODIFIED: 10/04/95   BY: AME *J089*                */
/* REVISION: 7.4      LAST MODIFIED: 08/25/95   BY: jym *G0TW*                */
/* REVISION: 7.4      LAST MODIFIED: 09/06/95   BY: ais *G0WL*                */
/* REVISION: 7.4      LAST MODIFIED: 10/23/95   BY: rxm *G19G*                */
/* REVISION: 7.4      LAST MODIFIED: 11/13/95   BY: ais *H0GK*                */
/* REVISION: 7.4      LAST MODIFIED: 12/07/95   BY: rxm *H0FS*                */
/* REVISION: 8.5      LAST MODIFIED: 11/07/95   BY: taf *J053*                */
/* REVISION: 7.4      LAST MODIFIED: 12/19/95   BY: kjm *G1GV*                */
/* REVISION: 8.5      LAST MODIFIED: 04/03/96   BY: DAH *J0GT*                */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: *J04C* Markus Barone      */
/* REVISION: 8.5      LAST MODIFIED: 04/17/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 04/30/96   BY: *J0KJ* Dennis Henson      */
/* REVISION: 8.5      LAST MODIFIED: 05/07/96   BY: *J0LL* Dennis Henson      */
/* REVISION: 8.5      LAST MODIFIED: 05/16/96   BY: *J0MY* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 05/20/96   BY: *J0N2* Dennis Henson      */
/* REVISION: 8.5      LAST MODIFIED: 06/10/96   BY: *J0VK* Markus Barone      */
/* REVISION: 8.5      LAST MODIFIED: 06/21/96   BY: *G1V1* Tony Patel         */
/* REVISION: 8.5      LAST MODIFIED: 07/02/96   BY: *J0XG* Dennis Henson      */
/* REVISION: 8.5      LAST MODIFIED: 07/04/96   BY: *J0XR* Dennis Henson      */
/* REVISION: 8.5      LAST MODIFIED: 07/12/96   BY: *J0Y5* Andy Wasilczuk     */
/* REVISION: 8.5      LAST MODIFIED: 07/11/96   BY: *J0YR* Kieu Nguyen        */
/* REVISION: 8.5      LAST MODIFIED: 07/16/96   BY: *J0Z6* Andy Wasilczuk     */
/* REVISION: 8.5      LAST MODIFIED: 07/23/96   BY: *J0R1* Andy Wasilczuk     */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: *J12Q* Andy Wasilczuk     */
/* REVISION: 8.5      LAST MODIFIED: 08/07/96   BY: *G29K* Markus Barone      */
/* REVISION: 8.5      LAST MODIFIED: 09/12/96   BY: *J152* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 10/10/96   BY: svs *K007*                */
/* REVISION: 8.6      LAST MODIFIED: 06/26/96   BY: *K004* Stephane Collard   */
/* REVISION: 8.6      LAST MODIFIED: 11/05/96   BY: *K01T* Stephane Collard   */
/* REVISION: 8.6      LAST MODIFIED: 11/12/96   BY: *G2H6* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 11/15/96   BY: *K01Y* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 11/26/96   BY: *K02G* Jean Miller        */
/* REVISION: 8.6      LAST MODIFIED: 11/08/96   BY: *J15C* Markus Barone      */
/* REVISION: 8.6      LAST MODIFIED: 12/19/96   BY: *K022* Dennis Henson      */
/* REVISION: 8.6      LAST MODIFIED: 01/01/97   BY: *K03Y* Dennis Henson      */
/* REVISION: 8.6      LAST MODIFIED: 12/23/96   BY: *J1CR* Sue Poland         */
/* REVISION: 8.6      LAST MODIFIED: 03/04/97   BY: *J1JV* Jim Williams       */
/* REVISION: 8.6      LAST MODIFIED: 04/08/97   BY: *K09W* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 04/11/97   BY: *K09K* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 04/08/97   BY: *J1N4* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 05/16/97   BY: *K0DB* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 06/30/97   BY: *K0FL* Taek-Soo Chang     */
/* REVISION: 8.6      LAST MODIFIED: 06/26/97   BY: *K0FM* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 07/15/97   BY: *K0GH* Jean Miller        */
/* REVISION: 8.6      LAST MODIFIED: 07/15/97   BY: *K0G6* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 06/27/97   BY: *K0DH* Jim Williams       */
/* REVISION: 8.6      LAST MODIFIED: 08/06/96   BY: *J1YB* Sue Poland         */
/* REVISION: 8.6      LAST MODIFIED: 08/12/97   BY: *J1YL* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 07/22/97   BY: *H1B1* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 09/05/97   BY: *J1XW* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 09/02/97   BY: *K0HQ* Jim Williams       */
/* REVISION: 8.6      LAST MODIFIED: 09/23/97   BY: *K0J9* Joe Gawel          */
/* REVISION: 8.6      LAST MODIFIED: 09/27/97   BY: *K0HB* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 10/01/97   BY: *K0KH* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 10/08/97   BY: *K0KJ* Joe Gawel          */
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   BY: *K0WG* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 10/21/97   BY: *J236* Manish K.          */
/* REVISION: 8.6      LAST MODIFIED: 10/23/97   BY: *J23M* Niranjan R.        */
/* REVISION: 8.6      LAST MODIFIED: 11/11/97   BY: *K19P* Jean Miller        */
/* REVISION: 8.6      LAST MODIFIED: 11/23/97   BY: *K15N* Jerry Zhou         */
/* REVISION: 8.6      LAST MODIFIED: 12/08/97   BY: *K1BN* Val Portugal       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 03/06/98   BY: *J2FH* D. Tunstall        */
/* REVISION: 8.6E     LAST MODIFIED: 03/16/98   BY: *K1K4* Niranjan R.        */
/* REVISION: 8.6E     LAST MODIFIED: 03/18/98   BY: *H1JV* Niranjan R.        */
/* REVISION: 8.6E     LAST MODIFIED: 03/23/98   BY: *H1HQ* Niranjan R.        */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: *J2D8* Kawal Batra        */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* Old ECO marker removed, but no ECO header exists *J0HR*                    */
/* REVISION: 8.6E     LAST MODIFIED: 06/03/98   BY: *J2JZ* A. Licha           */
/* REVISION: 8.6E     LAST MODIFIED: 06/06/98   BY: *J2JJ* Niranjan R.        */
/* REVISION: 8.6E     LAST MODIFIED: 07/09/98   BY: *J2Q9* Niranjan R.        */
/* REVISION: 8.6E     LAST MODIFIED: 07/12/98   BY: *L024* Sami Kureishy      */
/* REVISION: 8.6E     LAST MODIFIED: 08/05/98   BY: *J2VF* Seema Varma        */
/* REVISION: 8.6E     LAST MODIFIED: 08/11/98   BY: *J2VZ* Surekha Joshi      */
/* REVISION: 8.6E     LAST MODIFIED: 09/04/98   BY: *J2X8* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 11/11/98   BY: *M00R* Sue Poland         */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* Luke Pokic         */
/* REVISION: 9.0      LAST MODIFIED: 12/29/98   BY: *K1YM* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 01/13/99   BY: *J37J* Niranjan R.        */
/* REVISION: 9.0      LAST MODIFIED: 01/27/99   BY: *M06L* Luke Pokic         */
/* REVISION: 9.0      LAST MODIFIED: 02/16/99   BY: *L0DD* Surekha Joshi      */
/* REVISION: 9.0      LAST MODIFIED: 02/08/99   BY: *J39H* Anup Pereira       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/23/99   BY: *J3BF* Anup Pereira       */
/* REVISION: 9.0      LAST MODIFIED: 04/23/99   BY: *K20M* Jyoti Thatte       */
/* REVISION: 9.0      LAST MODIFIED: 06/09/99   BY: *J3GV* Poonam Bahl        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney     */
/* REVISION: 9.1      LAST MODIFIED: 06/30/99   BY: *K20S* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 08/06/99   BY: *K21Z* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 08/10/99   BY: *J3K7* Surekha Joshi      */
/* REVISION: 9.1      LAST MODIFIED: 09/24/99   BY: *K234* Sachin Shinde      */
/* REVISION: 9.1      LAST MODIFIED: 11/01/99   BY: *N049* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 12/20/99   BY: *N05D* Steve Nugent       */
/* REVISION: 9.1      LAST MODIFIED: 12/28/99   BY: *L0MP* Surekha Joshi      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *M0LX* Manish K.          */
/* REVISION: 9.1      LAST MODIFIED: 04/28/00   BY: *N0CG* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 06/29/00   BY: *N0DX* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *N0RF* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 11/17/00   BY: *M0WD* Kaustubh K         */
/* REVISION: 9.1      LAST MODIFIED: 07/17/00   BY: *L124* Nikita Joshi       */
/* Revision: 1.96        BY: Seema Tyagi        DATE: 12/12/00   ECO: *M0X4*  */
/* Revision: 1.97        BY: Veena Lad          DATE: 12/18/00   ECO: *M0TZ*  */
/* Revision: 1.98        BY: Rajesh Thomas      DATE: 02/20/01   ECO: *M11Y*  */
/* Revision: 1.99        BY: Ashwini G.         DATE: 02/23/01   ECO: *M11B*  */
/* Revision: 1.100       BY: Nikita Joshi       DATE: 03/12/01   ECO: *L16Y*  */
/* Revision: 1.104       BY: Mudit Mehta        DATE: 10/20/00   ECO: *L18P*  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.105       BY: Sandeep P.         DATE: 05/07/01   ECO: *M159*  */
/* Revision: 1.106       BY: Russ Witt          DATE: 06/01/01   ECO: *P00J*  */
/* Revision: 1.107       BY: Jean Miller        DATE: 08/01/01   ECO: *M11Z*  */
/* Revision: 1.108       BY: Nikita Joshi       DATE: 08/20/01   ECO: *L16Z*  */
/* Revision: 1.109       BY: Russ Witt          DATE: 09/21/01   ECO: *P01H*  */
/* Revision: 1.112       BY: Russ Witt          DATE: 10/17/01   ECO: *P021*  */
/* Revision: 1.113       BY: Steven Nugent      DATE: 10/22/01   ECO: *P004*  */
/* Revision: 1.114       BY: Ed van de Gevel    DATE: 12/03/01   ECO: *N16R*  */
/* Revision: 1.115       BY: Ed van de Gevel    DATE: 12/06/01   ECO: *N16Z*  */
/* Revision: 1.117       BY: Vivek Dsilva       DATE: 12/10/01   ECO: *M1RY*  */
/* Revision: 1.118       BY: Rajiv Ramaiah      DATE: 04/01/02   ECO: *M1SX*  */
/* Revision: 1.121       BY: Inna Fox           DATE: 03/13/02   ECO: *M12Q*  */
/* Revision: 1.122       BY: Patrick Rowan      DATE: 03/24/02   ECO: *P00G*  */
/* Revision: 1.123       BY: Anitha Gopal       DATE: 03/15/02   ECO: *M1WM*  */
/* Revision: 1.124       BY: Inna Fox           DATE: 04/17/02   ECO: *P05J*  */
/* Revision: 1.125       BY: Ashish M.          DATE: 05/20/02   ECO: *P04J*  */
/* Revision: 1.126       BY: Manisha Sawant     DATE: 06/17/02   ECO: *N1LB*  */
/* Revision: 1.127       BY: Reetu Kapoor       DATE: 07/22/02   ECO: *P0BW*  */
/* Revision: 1.128       BY: Reetu Kapoor       DATE: 07/29/02   ECO: *P0CG*  */
/* Revision: 1.130       BY: Inna Fox           DATE: 09/10/02   ECO: *N1TD*  */
/* Revision: 1.131       BY: Kirti Desai        DATE: 09/12/02   ECO: *N1MV*  */
/* Revision: 1.133       BY: Geeta Kotian       DATE: 10/23/02   ECO: *N1XV*  */
/* Revision: 1.134       BY: Ed van de Gevel    DATE: 12/03/02   ECO: *N1XD*  */
/* Revision: 1.136       BY: Wojciech Palczynski DATE: 12/17/02  ECO: *P0LB*  */
/* Revision: 1.137       BY: K Paneesh           DATE: 02/06/03  ECO: *N266*  */
/* Revision: 1.138       BY: Shoma Salgaonkar    DATE: 05/06/03  ECO: *P0RC*  */
/* Revision: 1.138.1.2   BY: Dorota Hohol       DATE: 08/25/03 ECO: *P0ZL* */
/* Revision: 1.138.1.3  BY: Ashish Maheshwari DATE: 11/28/03 ECO: *P1CN* */
/* $Revision: 1.138.1.4 $ BY: Ed van de Gevel DATE: 12/03/03 ECO: *P1D6* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

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
            tt_field_recs:
          */

         /*!
            Output parameters are:

            confirmApoAtpOrderLine: Will be set to yes when an order line
                         should be confirmed for Apo Atp.
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
{cxcustom.i "SOSOMTLA.P"}
{gplabel.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sosomtla_p_1 "Review Bill"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomtla_p_3 "Supplier"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomtla_p_5 "Promise Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomtla_p_6 "Effective"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomtla_p_8 "Qty Allocatable"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomtla_p_9 "PO Number"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomtla_p_10 "PO Line Number"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomtla_p_11 "Comments"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define temp-table tt_field_recs no-undo
   field tt_field_name          like tblcd_fld_name
   field tt_field_value as character format "x(30)" extent 5
   index tt_field_ix is unique primary
         tt_field_name.

define input parameter this-is-rma     as  logical.
define input parameter rma-recno       as  recid.
define input parameter rma-issue-line  as  logical.
define input parameter rmd-recno       as  recid.
define input parameter table for tt_field_recs.
define input parameter using_consignment like mfc_logical no-undo.
define output parameter confirmApoAtpOrderLine as logical
                                       initial no no-undo.

define new shared variable cf_undo       like mfc_logical.
define new shared variable cf_sod_rec    as recid.
define new shared variable cf_config     like mfc_logical.
define new shared variable cf_rm_old_bom like mfc_logical.
define new shared variable cf_error_bom  like mfc_logical.
define new shared variable pt_cf_model   as character format "x(40)".
define new shared variable prev_price    like sod_price    no-undo.

define new shared variable pcqty like sod_qty_ord.
define new shared variable desc1 like pt_desc1.
define new shared variable desc2 like pt_desc2.
define new shared variable cmtindx like cmt_indx.
define new shared variable old_price like sod_price.
define new shared variable old_list_pr like sod_list_pr.
define new shared variable old_disc like sod_disc_pct.
define new shared variable old_site like sod_site.
define new shared variable prev_confirm    like sod_confirm.
define new shared variable err_stat        as integer.
define new shared variable new_site        like sod_site.
define new shared variable match_pt_um     like mfc_logical.
define new shared variable undo_all2 like mfc_logical.
define new shared variable undo_bon  like mfc_logical.
define new shared variable totallqty like sod_qty_all.
define new shared variable old_sod_site    like sod_site no-undo.
define new shared variable pm_code         as character.
define new shared variable soc_pt_req      like mfc_logical.
define new shared variable exch-rate       like exr_rate.
define new shared variable exch-rate2      like exr_rate2.
define new shared variable lineffdate      like so_due_date.
define new shared variable prev_qty_ship   like sod_qty_ship.
define new shared variable err_flag        as integer.
define new shared variable err-flag        as integer.
define new shared variable pics_type       like pi_cs_type   initial "9".
define new shared variable part_type       like pi_part_type initial "6".
define new shared variable s-btb-so        as   logical.
define new shared variable s-sec-due       as   date.
define new shared variable prev-btb-type   like sod_btb_type.
define new shared variable prev-btb-vend   like sod_btb_vend.
define new shared variable wk_bs_line      like pih_bonus_line no-undo.
define new shared variable wk_bs_promo as character format "x(8)" no-undo.
define new shared variable wk_bs_price as decimal format ">>>>>>9.99" no-undo.
define new shared variable wk_bs_listid    like pih_list_id no-undo.
define new shared variable restock-amt     like rmd_restock.
define new shared variable prev-due-date   like sod_due_date.

define new shared variable resv-loc-ordnbr  like so_nbr    no-undo.
define new shared variable resv-loc-ordtype as character   no-undo.
define new shared variable resv-loc-ship    like so_ship   no-undo.
define new shared variable resv-loc-bill    like so_bill   no-undo.
define new shared variable resv-loc-cust    like so_cust   no-undo.
define new shared variable resv-loc-fsm-type like so_fsm_type no-undo.

define shared variable solinerun         as character.
define shared variable freight_ok        like mfc_logical.
define shared variable calc_fr           like mfc_logical.
define shared variable disp_fr           like mfc_logical.
define shared variable soc_pc_line       like mfc_logical.
define shared variable discount          as decimal.
define shared variable line_pricing      like mfc_logical.
define shared variable reprice           like mfc_logical.
define shared variable reprice_dtl       like mfc_logical.
define shared variable save_parent_list  like sod_list_pr.
define shared variable new_order         like mfc_logical.
define shared variable picust            like cm_addr.
define shared variable save_qty_ord      like sod_qty_ord.
define shared variable temp_sod_qty_ord  like sod_qty_ord.
define shared variable temp_sod_qty_ship like sod_qty_ship.
define shared variable temp_sod_qty_all  like sod_qty_all.
define shared variable temp_sod_qty_pick like sod_qty_pick.

define shared variable cfexists          like mfc_logical.
define shared variable cf_rp_part        like mfc_logical  no-undo.
define shared variable cf_chr            as character.
define shared variable cf_cfg_path       like mfc_char.
define shared variable cf_cfg_suf        like mfc_char.
define shared variable delete_line       like mfc_logical.
define shared variable cf_cfg_strt_err   like mfc_logical.
define shared variable cf_endcfg         like mfc_logical no-undo.
define shared variable original_model    as character format "x(40)".
define shared variable mult_slspsn       like mfc_logical no-undo.
define shared variable new_line          like mfc_logical.
define shared variable po-ack-wait       as logical no-undo.

/* DEFINE RNDMTHD FOR CALL TO SOSOMTLB.P */
define shared variable rndmthd like rnd_rnd_mthd.
define shared variable line like sod_line.
define shared variable del-yn like mfc_logical.
define shared variable prev_due like sod_due_date.
define shared variable prev_qty_ord like sod_qty_ord.
define shared variable all_days as integer.
define shared variable so_recno as recid.
define shared variable sod_recno as recid.
define shared variable sodcmmts like soc_lcmmts label {&sosomtla_p_11}.
define shared variable prev_abnormal like sod_abnormal.
define shared variable prev_consume like sod_consume.
define shared variable consume like sod_consume.
define shared variable promise_date as date label {&sosomtla_p_5}.
define shared variable base_amt like ar_amt.
define shared variable undo_all like mfc_logical.
define shared variable sngl_ln like soc_ln_fmt.
define shared variable clines as integer.
define shared variable sod-detail-all like soc_det_all.
define shared variable prev_type like sod_type.
define shared variable prev_site like sod_site.
define shared variable sodreldate like sod_due_date.
define shared variable so_db like dc_name.
define shared variable inv_db like dc_name.

define variable warning            like mfc_logical initial no.
define variable warmess            like mfc_logical initial yes.
define variable l_err_msg          as   character  no-undo.
define variable minmaxerr          like mfc_logical.
define variable qty_avl            like sod_qty_all.
define variable created_by_new_software like mfc_logical.
define variable sobparent          like sob_parent.
define variable sobfeature         like sob_feature.
define variable sobpart            like sob_part.
define variable save_um            like sod_um.
define variable save_disc_pct      as   decimal.
define variable new_disc_pct       as   decimal.
define variable umconv             like sod_um_conv.
define variable minerr             like mfc_logical.
define variable maxerr             like mfc_logical.
define variable man_disc_pct       as   decimal.
define variable sys_disc_fact      as   decimal.
define variable rfact              as   integer.
define variable minmax_occurred    like mfc_logical initial no no-undo.
define variable frametitle         as   character format "x(20)".
define variable coverage-discount  like sod_disc_pct.
define variable restock-pct        like rma_rstk_pct.
define variable cfg like sod_cfg_type format "x(3)" no-undo.
define variable disc_min_max       like mfc_logical.
define variable disc_pct_err       as   decimal format "->>>>,>>>,>>9.9<<<".
define variable last_list_price    like sod_list_pr.
define variable p-edi-rollback     as logical no-undo initial no.
define variable btb_ok            as logical no-undo.
define variable btb-type      like sod_btb_type format "x(8)" no-undo.
define variable btb-type-desc like glt_desc                   no-undo.
define variable l_prev_um_conv like sod_um_conv no-undo.
define variable this_is_edi like mfc_logical initial no.
define variable btb-um-conv like sod_det.sod_um_conv.
define variable v_failed as logical no-undo.
define variable sodstdcost like sod_std_cost no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable error_flag      like mfc_logical no-undo.
define variable l_undoln        like mfc_logical no-undo.
{&SOSOMTLA-P-TAG1}
define variable undo_all3       like mfc_logical no-undo.
define variable l_conf_ship     as   integer     no-undo.
define variable l_conf_shid     like abs_par_id  no-undo.
define variable l_undotran      like mfc_logical no-undo.
define variable l_flag          like mfc_logical no-undo.
define variable po-err-nbr      like msg_nbr     no-undo.
define variable emt-bu-lvl    like global_part no-undo.
define variable save_part     like global_part no-undo.
define variable undo_all5       like mfc_logical no-undo.
define variable reason-comment  like mfc_logical no-undo.
define variable tr-cmtindx      like tr_fldchg_cmtindx  no-undo.
define variable reason-code     like rsn_code no-undo.

define variable qty_allocatable  like in_qty_avail label {&sosomtla_p_8}.
define variable last_sod_price   like sod_price.
define variable open_qty         like mrp_qty.
define variable yn               like mfc_logical.
define variable modify_sob       like mfc_logical initial no
                                 label {&sosomtla_p_1}.
define variable disc_origin      like sod_disc_pct.
define variable chg-db           as   logical.
define variable remote-base-curr like gl_base_curr.
define variable old_um           like sod_um.
define variable shipper_found    as   integer     no-undo.
define variable save_abs         like abs_par_id  no-undo.
define variable resv-loc-avail   like ld_qty_all  no-undo.
define variable resv-loc-oh      like ld_qty_oh   no-undo.
define variable l_sod_price      like sod_price   no-undo.
define variable l_sod_list_pr    like sod_list_pr no-undo.
define variable atp-ok           as logical       no-undo.
define variable atp-due-date     like sod_due_date no-undo.
define variable atp-cum-qty      like  sod_qty_ord no-undo.
define variable auto-prom-date   like sod_promise_date no-undo.
define variable l_sodqtyord      like  sod_qty_ord no-undo.

define variable moduleGroup            as character  no-undo.
define variable checkAtp               as logical    no-undo.
define variable useApoAtp              as logical    no-undo.
define variable apoAtpDelAvail         as logical    no-undo
   initial yes.
define variable apoAtpDelAvailMsg      as integer    no-undo.
define variable errorResult            as character  no-undo.
define variable atp-site               like sod_site no-undo.
define variable continue               like mfc_logical no-undo.
define variable atp-qty-site-changed   as logical    no-undo
   initial no.
define variable stdAtpUsed             as logical    no-undo.
define variable l_code                 like qad_key1 no-undo.
define variable l_prev_sod_btb_type    like sod_btb_type no-undo.
define variable l_undo_all             like mfc_logical initial no no-undo.
define variable l_knt                  as   integer                no-undo.

/*xx*/  DEFINE VARIABLE copper_rate LIKE sod_price  .

define shared stream apoAtpStream.

define stream listprice.

{pxmaint.i}
/* Define Handles for the programs. */
{pxphdef.i sosoxr1}
{pxphdef.i giapoxr}
{pxphdef.i sosoxr} /* DEFINES HANDLE FOR SO HEADER ROP */
/* End Define Handles for the programs. */

/* APO ATP Global Defines */
{giapoatp.i}

{sobtbvar.i }    /* EMT SHARED WORKFILES AND VARIABLES */

define frame rsn.

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
reason-code    colon 17 label "Reason Code"
   reason-comment colon 17 label "Comments"
 SKIP(.4)  /*GUI*/
with frame rsn overlay side-labels  width 29 row 11 column 25 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-rsn-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame rsn = F-rsn-title.
 RECT-FRAME-LABEL:HIDDEN in frame rsn = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame rsn =
  FRAME rsn:HEIGHT-PIXELS - RECT-FRAME:Y in frame rsn - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME rsn = FRAME rsn:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame rsn:handle).

define variable so_fld as handle.
define variable so_fldname as handle.

define buffer rtsbuff for rmd_det.

define shared frame a.
define shared frame c.
define shared frame d.
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


/* SET EXTERNAL LABELS */
setFrameLabels(frame bom:handle).

{pppiwkpi.i "new"} /*Pricing workfile definition*/
{pppivar.i}        /*Pricing variables*/
{pppiwqty.i}       /*Reprice workfile definition*/

{mfdatev.i}

/*V8:HiddenDownFrame=c*/

/*DEFINE FORMS*/
{xxsolinfrm.i}

{&SOSOMTLA-P-TAG33}

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
space(1)
   so_nbr
   so_cust
   sngl_ln
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


{&SOSOMTLA-P-TAG34}

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
 F-btb_data-title = (getFrameTitle("ENTERPRISE_MATERIAL_TRANSFER_DATA",46)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame btb_data = F-btb_data-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame btb_data =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame btb_data + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame btb_data =
  FRAME btb_data:HEIGHT-PIXELS - RECT-FRAME:Y in frame btb_data - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME btb_data = FRAME btb_data:WIDTH-CHARS - .5. /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame btb_data:handle).

assign
   undo_all3          = yes
   undo_all           = yes
   exclude_confg_disc = no
   select_confg_disc  = no
   found_confg_disc   = no.

loopc:
do on error undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


   /* Initialize to no so that if could not connect to APO ATP   */
   /* and user starts all over, that APO ATP processing will be  */
   /* attempted again.                                           */
   stdAtpUsed = no.

   view frame c.

   {&SOSOMTLA-P-TAG2}
   if sngl_ln then view frame d.

   find first so_mstr where recid(so_mstr) = so_recno exclusive-lock no-error.

   find first sod_det where recid(sod_det) = sod_recno exclusive-lock no-error.

   run updateWithApoAtpData.

   if this-is-rma then do:

      find rma_mstr where recid(rma_mstr) = rma-recno
      exclusive-lock no-error.

      restock-pct = rma_rstk_pct.

      for first eu_mstr
         fields(eu_addr eu_type)
         where eu_addr = rma_enduser no-lock:
      end. /* FOR FIRST eu_mstr */

      {fssvsel.i rma_ctype """" eu_type}

      find rmd_det where recid(rmd_det) = rmd-recno
      exclusive-lock no-error.

      if available rmd_det then
         restock-amt = rmd_restock.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF this-is-rma THEN DO: */

   for first soc_ctrl
      fields(soc_all_avl
             soc_apm
             soc_edit_isb
             soc_lcmmts
             soc_returns_isb
             soc_atp_enabled
             soc_horizon
             soc_shp_lead
             soc_use_btb)
      no-lock:
   end. /* FOR FIRST soc_ctrl */

   /* If EMT is in use, capture the existing sod_det */
   if soc_use_btb and not new_line then do:

      l_prev_sod_btb_type = sod_btb_type.

      {gprunp.i "soemttrg" "p" "create-temp-sod-det"
         "(input so_nbr, input sod_line)"}
   end.

   for first svc_ctrl
      fields(svc_pt_mstr svc_ship_isb) no-lock:
   end. /* FOR FIRST svc_ctrl */

   for first pic_ctrl
      fields(pic_disc_comb pic_so_fact pic_so_rfact) no-lock:
   end. /* FOR FIRST pic_ctrl */

   {&SOSOMTLA-P-TAG3}

   run getPriceTableRequiredFlag.

   assign
      rfact = if pic_so_fact then
                 pic_so_rfact
              else
                 pic_so_rfact + 2
      last_sod_price = sod_price.

   status input.

   run setOrderLineAndDesc.

   assign
      resv-loc-ordnbr = so_nbr
      resv-loc-ordtype = "S"
      resv-loc-ship    = so_ship
      resv-loc-bill    = so_bill
      resv-loc-cust    = so_cust
      resv-loc-fsm-type = so_fsm_type
      /* SET GLOBAL PART VARIABLE */
      global_part = sod_part.

   /* Check the RMA Discount to see if complies with pic_ctrl */
   run p-disc-disp
      (input no).

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
         sod_price    when (not new_line)
         sod__dec01 FORMAT "->>>,>>9.99<<<<<"
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
          sod__dec01  FORMAT "->>>,>>9.99<<<<<"
    with frame c.

   {&SOSOMTLA-P-TAG4}
   if sngl_ln then
      display
         sod_qty_all sod_qty_pick sod_qty_ship sod_qty_inv
         sod_site sod_loc sod_serial
         sod_std_cost desc1 base_curr
         sod_req_date sod_per_date sod_due_date
         sod_promise_date
         sod_pricing_dt
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
         sod_taxable sod_taxc
         (sod_cmtindx <> 0 or (new_line and soc_lcmmts)) @ sodcmmts
         sod_slspsn[1] mult_slspsn sod_comm_pct[1]
         sod_crt_int sod_fix_pr
         sod_order_category
      with frame d.
   {&SOSOMTLA-P-TAG5}

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
   run p-btb-ok
      (output error_flag,
       output po-err-nbr).
   if error_flag then do:
      undo_all = yes.
      undo loopc, leave loopc.
   end.

   assign
      prev_confirm  = sod_confirm
      prev_type     = sod_type
      prev_site     = sod_site
      prev_price     = sod_price
      prev_due      = sod_due_date
      prev_qty_ord  = sod_qty_ord * sod_um_conv
      prev_abnormal = sod_abnormal
      prev_consume  = sod_consume
      del-yn        = no.

   /* SAVE CURRENT QTY ORDERED,UM, AND PARENT LIST TO DETERMINE  */
   /* DIFFERENCE IF QTY, UM, OR PARENT LIST CHANGED WHEN CALLING */
   /* THE PRICING ROUTINES                                       */
   run saveCurrentQtyPricingInfo.

   /* ORDER QUANTITY */
   if not sod_sched then do:

      do on error undo, retry:

         assign
            ststatus = stline[2]
            old_sod_site = sod_site.

         status input ststatus.

         for first pt_mstr
            fields(pt_desc1 pt_desc2 pt_fsc_code pt_isb pt_lot_ser
                   pt_ord_max pt_ord_min pt_ord_mult pt_part pt_pm_code
                   pt_price pt_promo pt_ship_wt pt_ship_wt_um pt_um)
            where pt_part = sod_part no-lock:
         end. /* FOR FIRST PT_MSTR */

         if available pt_mstr then do:
            pm_code = pt_pm_code.
            run find-ptp-j2d8
               (input pt_part,
                input sod_site).
         end. /* IF AVAILABLE pt_mstr THEN DO: */

         /* AFTER A LINE THAT WAS A CONCINITY 'END CONFIGURATION' WE NEED */
         /* TO RESET IT BUT, IF cf_rp_part = yes, THIS IS THE REPLACEMENT */
         /* PASS, SO DON'T RESET IT                                       */
         if cf_rp_part = no then
            assign
               cf_endcfg = no.

         /* GET READY FOR 'END ITEM' AND 'END CONFIGURATION' FROM CALICO */
         if cfexists then
            assign
               cf_rp_part = no.

         /* EMT CHANGES TO PRIMARY SO - CHANGE PO - SITE MAINTENANCE      */
         {gprun.i ""sobtbla2.p""
            "(input this-is-rma,
              input rma-issue-line,
              input rmd-recno,
              output undo_all3,
              output undo_all5,
              output reason-code,
              output tr-cmtindx)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         if undo_all3 then do:
            undo loopc, leave loopc.
         end. /* IF undo_all3 */

         if keyfunction(lastkey) = "end-error" and not undo_all5
         then undo loopc, leave loopc.

         {&SOSOMTLA-P-TAG6}

         if sngl_ln then
            display
               sod_site
               sod_loc
            with frame d.

         /* Determine promise date and due date defaulting  */
         if sod_confirm = yes
         and ((not this-is-rma) or rma-issue-line)
         and soc_calc_promise_date = yes
         /* DO FOR RMA ISSUE LINES, NOT RECEIPT LINES */
         and not (s-btb-so = yes and sod_btb_type > "01")
         and (new_line = yes or sod_site <> prev_site) then do:
            run p-calc-date-defaults (input so_ship,
                                     input sod_site,
                                     input sod_req_date,
                                     input-output sod_promise_date,
                                     input-output sod_due_date).
           if sngl_ln
           then display
              sod_promise_date
              sod_due_date
           with frame d.
         end.  /* sod_confirm = yes...  */

         /* DETERMINE THE TRANSPORT LEAD-TIME DAYS */
         if  not (s-btb-so = yes and sod_btb_type > "01") and
                 (new_line = yes or sod_site <> prev_site) then
            run p-calc-translt-days (input so_ship,
                                     input sod_site,
                                     output sod_translt_days).

         /* DETERMINE WHETHER ITEM IS CALICO CONTROLLED                    */
         /* IF WE HAVE JUST REPLACED THE ITEM WITH THE 'END CONFIGURATION' */
         /* ITEM, THEN, SKIP RUNNING cfsocfg1.p                            */
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
         /* IF WE HAVE JUST REPLACED THE ITEM WITH THE 'END CONFIGURATION' */
         /* ITEM, THEN, SKIP RUNNING cfsocfg1.p                            */
         if cfexists and cf_endcfg then
            assign
               cf_config = yes
               cf_rm_old_bom = yes
               pt_cf_model = original_model
               cf_endcfg = no.

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
         end. /* IF cf_config AND cf_rm_old_bom THEN DO: */

         /* Del-yn = yes IF CONFIGURATOR RETURNS A REPLCEMENT ITEM AND    */
         /* USER WISHES TO USE THIS ITEM AND DELETE ANY EXISITNG LINE     */
         /* INFORMATION. cf_undo = yes IF ERROR OCCUED IN THE PROGRAM OR  */
         /* FOR EXAMPLE, THE USER TRIED TO ENTER A SQ LINE FOR A CONCINITY*/
         /* CONTROLLED ITEM AND THEY WERE ON A UNIX PLATFORM ETC.         */

         /* QUANTITY, ORDER UNIT OF MEASURE */
         if not del-yn then do:

            assign
               old_um = sod_um
               l_prev_um_conv = sod_um_conv.

            if available pt_mstr and soc_apm then do:

               for first cm_mstr where cm_addr = so_cust
               no-lock: end.

               if available cm_mstr and cm_promo <> "" then do:

                  {gprun.i ""sosoapm2.p""
                     "(input cm_addr,
                       input sod_nbr,
                       input sod_line,
                       output error_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  if error_flag then do:
                     undo loopc, leave.
                  end. /* IF error_flag THEN DO: */

                  /* REDISPLAY ITEM DESCRIPTION AND QUANTITY AVAILABLE */
                  pause 0.
                  message desc1 desc2.

                  {gprun.i ""gpavlsi3.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


                  /* RESET STATUS LINE TO ORIGINAL VALUE */
                  ststatus = stline[2].  /* ENABLE F5 CTRL-D */
                  status input ststatus.

               end. /* IF AVAILABLE CM_MSTR AND CM_PROMO */

            end.  /* IF AVAILABLE PT_MSTR AND SOC_APM */

            display
               sod_qty_ord
               sod_um
            with frame c.

            if this-is-rma and not rma-issue-line then
               display
                  (sod_qty_ord * -1) @ sod_qty_ord
               with frame c.

            set1:
            do with frame c on error undo, retry on endkey undo, leave loopc:
/*GUI*/ if global-beam-me-up then undo, leave.


               run rollBackValues.

               /* DISPLAY ERROR MESSAGE RETURN FROM SOBTBRB.P */
               if return-msg <> 0 then do:
                  run p-mfmsg (input return-msg, input 3).
                  assign
                     s-rb-init = no
                     return-msg = 0.
                  if not batchrun then pause.
                  undo set1, return.

               end. /* IF return-msg <> 0 THEN DO: */

               sod_qty_ord  = decimal(s-cmdval).

               display
                  sod_qty_ord
               with frame c.

               if this-is-rma and not rma-issue-line then
                  display
                     (sod_qty_ord * -1) @ sod_qty_ord
                  with frame c.

               l_sodqtyord = sod_qty_ord.

               set
                  sod_qty_ord when (not po-ack-wait)
                  sod_um      when (not po-ack-wait)
               go-on ("F5" "CTRL-D") with frame c.

               if not new_line and
                  available pt_mstr and
                  pt_pm_code = "C"  and
                  input sod_um <> old_um
               then do:
                  /* UNIT OF MEASURE CHANGE NOT ALLOWED */
                  run p-mfmsg (input 685, input 1).
                  next-prompt sod_um with frame c.
                  undo set1, retry.
               end. /* AND input sod_um <> old_um THEN DO: */

               if available pt_mstr and pt_lot_ser = "s" and  pt_um <> sod_um
               then do:
                  /* UM MUST EQUAL TO STOCKING UM FOR SERIAL-CONTROLLED */
                  /* ITEM */
                  run p-mfmsg (input 367, input 3).
                  next-prompt sod_um with frame c.
                  undo set1,retry.
               end. /* IF AVAILABLE pt_mstr */

               /* DON'T ALLOW NEGATIVE QUANTITY ORDERED ON BTB SO */
               if sod_qty_ord < 0 and s-btb-so then do:
                  /* RETURNS NOT ALLOWED FOR BTB SO */
                  run p-mfmsg (input 2854, input 3).
                  undo set1, retry set1.
               end. /* IF sod_qty_ord < 0 AND s-btb-so THEN DO: */

               /* MULTI EMT DO NOT ALLOW QTY CHANGE AT THE SBU */
               if (prev_qty_ord <> sod_qty_ord * sod_um_conv) and
                  not new_line and
                  so_secondary and
                  (sod_btb_type = "02" or sod_btb_type = "03")
               then do:
                  /* CHANGE NOT ALLOWED FOR EMT SO */
                  run p-mfmsg (input 2825, input 3).
                  undo set1, retry set1.
               end. /* (sod_btb_type = "02" OR sod_btb_type = "03") THEN DO: */

               /* MULTI EMT DO NOT ALLOW QTY CHANGE AT THE SBU */
               if old_um <> sod_um and
                  not new_line and
                  so_secondary and
                  (sod_btb_type = "02" or sod_btb_type = "03")
               then do:
                  /* CHANGE NOT ALLOWED FOR EMT SO */
                  run p-mfmsg (input 2825, input 3).
                  next-prompt sod_um with frame c.
                  undo set1, retry set1.
               end. /* (sod_btb_type = "02" OR sod_btb_type = "03") THEN DO: */

               /* VALIDATE MODIFICATION OF SOD_QTY_ORD IN CASE OF BTB */
               btb-um-conv = sod_um_conv.
               {mfumcnv.i sod_um sod_part btb-um-conv}
               if (prev_qty_ord <> (sod_qty_ord * btb-um-conv) or
                   old_um <> sod_um)
                  and not new_line
               then do:

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
                        run p-mfmsg (input return-msg, input 3).
                        return-msg = 0.
                        if not batchrun then pause.
                        undo set1, retry set1.
                     end. /* IF return-msg <> 0 THEN DO: */

                  end. /* SECONDARY SO */

               end. /* CHANGE OF QUANTITY ORDERED */

               /* CHECK IF ORDER QTY CORRESPONDS TO ORDER MODIFIERS */
               warning = no.

               if soc_use_btb and sod_btb_type <> "01" and
                  sod_qty_ord > 0
               then do:
                  run check-order-modifiers
                     (output warning).
                  if warning = yes then do:
                     /* QTY IS NOT ACCORDING TO THE ORDER MODIFIERS */
                     run p-mfmsg (input 2811, input 2).
                     if not batchrun then pause.
                  end. /* IF warning = yes THEN DO: */
               end. /* sod_qty_ord > 0 THEN DO: */

               /* FOR RMA'S, THE USER MAY NOT ENTER NEGATIVE ORDER QUANTITY */
               /* IF THIS IS A RECEIPT LINE, WE MUST REVERSE THE SIGN ON    */
               /* THE QUANTITY THEY DO ENTER - RECALL THAT FOR RECEIPTS,    */
               /* SOD_QTY_ORD IS NEGATIVE AND RMD_QTY_ORD IS POSITIVE...    */
               if this-is-rma then do:
                  if sod_qty_ord < 0 then do:
                     /* ORDER QTY CANNOT BE NEGATIVE */
                     run p-mfmsg (input 234, input 3).
                     next-prompt sod_qty_ord with frame c.
                     undo set1, retry.
                  end. /* IF sod_qty_ord < 0 THEN DO: */
                  if not rma-issue-line then
                     assign sod_qty_ord = -1 *  sod_qty_ord.

                  /* FOR RMA RECEIPT LINES, WARN USER IF HE ENTERS AN ORDER */
                  /* QTY TOO SMALL FOR WHAT'S ALREADY BEEN RECEIVED.        */
                  /* (THIS WAS A WARNING IN FSRMAREC.P ALSO)                */
                  if not rma-issue-line and
                     (sod_qty_chg + sod_qty_ship) < sod_qty_ord
                  then
                     /* QTY TO RECEIVE + QTY RECEIVED > QTY EXPECTED */
                     run p-mfmsg (input 7201, input 2).
               end.  /* if this-is-rma */

               {&SOSOMTLA-P-TAG7}

               /* CONFIRM DELETE */
               if lastkey = keycode("F5")
               or lastkey = keycode("CTRL-D")
               then do:

                  /* IF THIS IS AN RMA LINE, CHECK FOR LINKED RTS    */
                  /* LINES.  IF ANY, WARN USER OF LINKAGE.           */
                  if this-is-rma then do:
                     if not rma-issue-line then do for rtsbuff:
                        for first rtsbuff
                           fields(rmd_chg_type rmd_edit_isb rmd_line rmd_nbr
                                  rmd_prefix rmd_restock rmd_rma_line
                                  rmd_rma_nbr rmd_sv_code)
                           where rtsbuff.rmd_nbr    = rmd_det.rmd_rma_nbr
                           and   rtsbuff.rmd_prefix = "V"
                           and   rtsbuff.rmd_line   = rmd_det.rmd_rma_line
                        no-lock:
                           /* THIS RMA LINE IS LINKED TO ONE OR MORE RTS LINES */
                           run p-mfmsg (input 1120, input 2).
                        end. /* FOR FIRST rtsbuff */
                     end.    /* ELSE, rma-receipt-line, DO */
                  end.   /* IF this-is-rma */

                  del-yn = yes.

                  /* Please confirm Delete */
                  {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

                  if del-yn
                  then do:
                     if  sod_consignment
                     and can-find (first cncix_mstr
                                   where cncix_so_nbr   = sod_nbr
                                     and cncix_sod_line = sod_line)
                     then do:
                        /* NON-INVOICED CONSIGNED SHIPMENTS EXIST */
                        run p-mfmsg (input 4919, input 3).
                        undo.
                     end. /* IF sod_consignment AND ... */

                     if sod_qty_inv <> 0
                     then do:
                        /* DELETE NOT ALLOWED */
                        run p-mfmsg (input 604, input 3).
                        undo.
                     end. /* IF sod_qty_inv <> 0 AND del-yn THEN DO: */

                  end. /* IF del-yn THEN DO */

                  /* Do NOT ALLOW USER DELETE OF SALES ORDERS */
                  /* WHICH ARE OWNED BY AN EXTERNAL SYSTEM.   */
                  if so_app_owner > "" then do:
                     /* CANNOT PROCESS.  DOCUMENT OWNED BY APPLICATION # */
                     {pxmsg.i &MSGNUM=2948 &ERRORLEVEL=4 &MSGARG1=so_app_owner}
                     undo.
                  end. /* IF so_app_owner > "" THEN DO: */

                  l_undotran = no.

                  /* CHECK FOR EXISTENCE OF CONFIRMED/UNCONFIRMED SHIPPER */
                  run p-shipper-check(output l_undo_all).
                  if l_undo_all = yes
                  then
                     undo loopc, leave loopc.


                  /* DO NOT ALLOW TO DELETE ORDER LINE, IF UNCONFIRMED */
                  /* SHIPPER EXISTS                                    */
                  if l_undotran then
                     undo.

                  if del-yn then
                     run p-delete-cmt-det.
               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* THEN DO: */

               {&SOSOMTLA-P-TAG8}

            end. /* set1 */

         end. /* del-yn DO */

      end. /* DO ON ERROR... */

   end. /* IF NOT sod_sched */

   else do:
      pause 0.
      /* SCHEDULE EXISTS FOR THIS ORDER LINE */
      run p-mfmsg (input 6014, input 1).
   end. /* ELSE DO: */

   if del-yn then
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

         if del-yn and not undo_all5 then do on endkey undo,
         leave on error undo, retry:

            for first soc_ctrl no-lock:
            end.

            if not this-is-rma and soc_so_hist then

         /* PROMPT FOR A REASON CODE IF ANY SOD FIELDS NEED TO BE TRACKED */
         /* UPON DELETE REASON CODES WITH A TYPE OF ORD_CHG MUST EXIST IN */
         /* ORDER FOR A REASON CODE AND COMMENT TO BE ENTERED.            */

            for first tblc_mstr no-lock where
               tblc_table = "sod_det"  and
               tblc_delete:
               assign
                  global_type = " "
                  global_ref = so_nbr
                  .
               run p-reason-code.
            end. /* FOR FIRST tblc_mstr */

          end. /* IF DEL-YN*/
       if del-yn then hide frame rsn.

   else do:

      ststatus = stline[3].
      status input ststatus.

      /* CALCULATE UM CONVERSION */
      {mfumcnv.i sod_um sod_part sod_um_conv}

      if new_line and not sngl_ln and calc_fr then
         run p-calc-fr-wt.

      /* CALCULATE COST ACCORDING TO UM */
      if available pt_mstr then do:

         remote-base-curr = base_curr.

         /* FIND OUT IF WE NEED TO CHANGE DATABASES */
         run checkWhetherToChangeDB.

         {gprunp.i "mcpl" "p" "mc-get-ex-rate"
            "(input  base_curr,
              input  remote-base-curr,
              input  """",
              input  so_ord_date,
              output exch-rate2,
              output exch-rate,
              output mc-error-number)" }

         if mc-error-number <> 0 then
            run p-mfmsg (input mc-error-number, input 2).

         {&SOSOMTLA-P-TAG23}
         if new sod_det or (not new sod_det and pt_pm_code <> "C") then
         {&SOSOMTLA-P-TAG24}
            sod_std_cost = glxcst * sod_um_conv.

      end. /* IF AVAILABLE pt_mstr THEN DO: */

      if new sod_det and available pt_mstr then
         assign
            sod_price = sod_price * sod_um_conv
            sod_list_pr = sod_list_pr * sod_um_conv.
      /*
/**xx**/ reprice_dtl  = YES. 
        */
      /* POP-UP FOR REQUIRED ITEMS BEFORE PRICING */
      if sngl_ln and (rma-issue-line or (not reprice and not new_order))
      then do:

         if sod_sched then
            pause 2.

         update
            sod_pricing_dt when (rma-issue-line and soc_pc_line)
            sod_crt_int    when (rma-issue-line and soc_pc_line)
            reprice_dtl    when (not reprice_dtl and not new_order)
            sod_pr_list    when (rma-issue-line)
         with frame line_pop.

         {&SOSOMTLA-P-TAG9}

         display
            sod_pricing_dt
            sod_crt_int
         with frame d.

         hide frame line_pop no-pause.
         pause 0.

      end. /* THEN DO: */

      if sngl_ln and available pt_mstr then do:

         /* CONVERT COST FROM REMOTE TO LOCAL BASE CURRENCY */
         run sod-conv (input sod_std_cost, output sodstdcost).

         {&SOSOMTLA-P-TAG10}

         display
            sodstdcost @ sod_std_cost
            sod_um_conv
         with frame d.

      end.  /* IF sngl_ln AND AVAILABLE pt_mstr */

      /* MOVED THE UPDATING OF pm_code FROM JUST ABOVE CALL TO */
      /* Sosomtf8.p TO HERE IN ORDER TO UPDATE THE             */
      /* Exclude_confg_disc VARIABLE WHICH gppibx.p FOR        */
      /* DISCOUNTS MUST TEST FOR.                              */

      pm_code = "".
      if available pt_mstr then
         pm_code = pt_pm_code.

      run find-ptp-j2d8
         (input sod_part,
          input sod_site).

      if pm_code = "C" then
         exclude_confg_disc = yes.

      if pm_code = "C" and reprice_dtl and
         (po-err-nbr = 4619 or po-err-nbr = 4617)
      then do:
         /* Order in process at SBU. Cannot re-configure */
         run p-mfmsg (input 4638, input 4).
         reprice_dtl = no.
         if not batchrun then pause.
      end.

      if rma-issue-line then
         assign
            min_price = 0
            max_price = 0.

      /* INITIALIZE PRICING VARIABLES AND PRICING WORKFILE
      wkpi_wkfl FOR CURRENT sod_part*/
      if rma-issue-line and (line_pricing or reprice_dtl) then do:

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


         /*GET BEST LIST TYPE PRICE LIST, SET MIN/MAX FIELDS*/
         run apm-pricing1.

         if soc_pt_req or best_list_price = 0 then do:

            find first wkpi_wkfl where wkpi_parent   = ""  and
               wkpi_feature  = ""  and
               wkpi_option   = ""  and
               wkpi_amt_type = "1"
            no-lock no-error.

            l_undoln = no.

            /* CHECK PRICE LIST AVAILABILITY */
            run p-itm-prlst-chk.

            if l_undoln then
               undo, return.

            run getBestListPrice.

         end. /* if soc_pt_req or best-list-price = 0 */

         assign
            sod_list_pr = best_list_price
            sod_price   = best_list_price.

         /*CALCULATE TERMS INTEREST*/
         if sod_crt_int <> 0 and (available pt_mstr or sod_type <> "")
         then do:

            assign
               sod_list_pr     = (100 + sod_crt_int) / 100 * sod_list_pr
               sod_price       = sod_list_pr
               best_list_price = sod_list_pr.

            /*CREATE CREDIT TERMS INTEREST wkpi_wkfl RECORD*/
            {gprun.i ""gppiwkad.p""
               "(sod_um, sobparent, sobfeature, sobpart,
                 ""5"", ""1"", sod_list_pr, 0, no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.

         parent_list_price = best_list_price. /*gppiwk02.p NEEDS THIS*/

      end. /*line_pricing or reprice_dtl*/

      /*UPDATE QTY AND EXT LIST IN ACCUMULATED QTY WORKFILES*/
      if rma-issue-line and (line_pricing or not new_order) then do:
         run updateRMAWorkfile.
      end. /*line_pricing or not new_order*/

      /*GET BEST DISCOUNT TYPE PRICE LISTS*/
      if rma-issue-line and
         (line_pricing or reprice_dtl)
      then do:

         run apm-pricing2.

         /*CALCULATE BEST PRICE, EXCLUDING GLOBAL DISCOUNTS*/
         {gprun.i ""gppibx04.p""
            "(sobparent, sobfeature, sobpart, no, rfact)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         assign
            sod_price    = best_net_price
            sod_list_pr  = best_list_price
            sod_disc_pct = if sod_list_pr <> 0 then
                              (1 - (sod_price / sod_list_pr)) * 100
                           else
                              0.

         /*DETERMINE DISCOUNT DISPLAY FORMAT*/
         run p-disc-disp (input no).

         display
            sod_list_pr
            discount
            sod_price
         with frame c.

      end. /*line_pricing or reprice_dtl*/

      /* MOVED PRICE CONVERSION TO LINE UM UP BEFORE ALL PRICE TABLE */
      /* AND DISC TABLE CALLS. BECAUSE TABLE ROUTINES NOW HANDLE THE */
      /* UM CONVERSION THEMSELVES.                                   */

      /* HERE'S WHERE WE PRICE A RMA RECEIPT LINE */
      if this-is-rma and not rma-issue-line and (new_line or reprice_dtl)
      then do:

         sod_price = 0.

         if so_crprlist <> "" and available pt_mstr then do:
            assign
               pt_recno = recid(pt_mstr)
               pcqty    = sod_qty_ord.
            {gprun.i ""sopccal.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

         end. /* IF so_crprlist <> "" AND AVAILABLE pt_mstr THEN DO: */

         /* LIST PRICE FOR RECEIPT WILL ALWAYS BE CREDIT PRICE */
         sod_list_pr = sod_price.
         run p-sync-restock
            (input "default").

      end.   /* if this-is-rma AND... */

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
         else
        {&SOSOMTLA-P-TAG25}
     do:

            undo_all2 = true.
            {gprun.i ""sosomtf8.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

            hide frame bom.
            if undo_all2 then undo loopc, retry.

            /* DISPLAY WARNING MESSAGE# 420 WHEN TRYING TO MODIFY */
            /* ORDER QTY OF SO LINE ALREADY RELEASED TO WO        */
            if (sod_fa_nbr > "" or sod_lot > "" )
               and ((prev_qty_ord <> sod_qty_ord * sod_um_conv)
               and   prev_qty_ord <> 0)
            then do:
               /* LINE ITEM ALREADY RELEASED TO FAS */
               {pxmsg.i &MSGNUM=420 &ERRORLEVEL=2}
               pause.
            end. /* IF sod_fa_nbr > "" .. */

            v_failed = no.
            {gprun.i ""sosobchk.p""
               "(sod_nbr, sod_line, chg-db, so_db,
                 output v_failed)" }
/*GUI*/ if global-beam-me-up then undo, leave.

            if v_failed then do:
               undo_all = yes.  /* CAUSES sosomta.p TO UNDO MAINLOOP  */
               undo loopc, leave loopc.
            end. /* IF v_failed THEN DO: */

         end.   /* IF this-is-rma... */

      end.  /* IF pm_code = "C" */

      /* CHECK FOR ATP ENFORCEMENT IF MULTI LINE MODE   */
      if not sngl_ln
      and ((not this-is-rma)
         or rma-issue-line) /* DO FOR RMA ISSUE LINES, NOT RECEIPT LINES */
      then do:

         /* DETERMINE IF TO USE APO ATP FOR MODULE */
         run setUpForApoAtp.

         if checkAtp then
         run p-check-atp.

         if checkAtp and useApoAtp then do:
            if keyfunction(lastkey) = "end-error" then do:
               atp-cum-qty = sod_qty_ord.
               undo loopc, retry.
            end.

            if not continue then do:
               next-prompt sod_qty_ord with frame c.
               undo, retry.
            end.

            run updateWithApoAtpData.

            if errorResult = "0" then
               confirmApoAtpOrderLine = yes.

            if errorResult <> "0" then do:
               display sod_qty_ord with frame c.
               undo loopc, retry.
            end.
         end. /* checkAtp and useApoAtp */

         if checkAtp and useApoAtp = no then do:

         /* RESET DUE DATE IF NEEDED */

         if atp-due-date <> ? then sod_due_date = atp-due-date.

         if atp-ok = no then do:
               {pxmsg.i &MSGNUM=4099 &ERRORLEVEL=3 &MSGARG1=sod_due_date}
           /*  ATP Enforcement Error, Qty Ordered not allowed  */
           /*  For Due Date xxxxxxxx                          */
           if not batchrun then pause.
           next-prompt sod_qty_ord with frame c.
           undo loopc, retry.
         end.  /* if atp-ok = no */

         /* RESET PROMISE DATE IF NEEDED */
         if sod_due_date <> prev_due
         and sod_confirm = yes
         and sod_due_date <> ?
         and not (s-btb-so = yes and sod_btb_type > "01")
         then do:
           auto-prom-date = ?.
           run p-calc-default-date (input so_ship,
                                    input sod_site,
                                    input-output sod_due_date,
                                    input-output auto-prom-date).
           if auto-prom-date <> ? then do:
              sod_promise_date = auto-prom-date.
           end.
         end.   /* sod_due_date <> prev_due */
         end.   /* checkAtp and useApoAtp = no */
      end.  /* if not sngl_ln */

      /*CALCULATE BEST PRICE BASED ON GLOBAL DISCOUNTS*/
      if rma-issue-line and (line_pricing or reprice_dtl)
      then do:

         assign
            sobparent       = ""
            sobfeature      = ""
            sobpart         = ""
            best_list_price = sod_list_pr.

         if soc_pt_req then do:
            /* CHECK FOR PRICE LIST AVAILABILITY FOR COMPONENTS OF */
            /* THE CONFIGURED PRODUCT                              */
            l_undoln = no.
            run chk-pl-exist.
            if l_undoln then
               undo, return.
         end. /* IF SOC_PT_REQ */

         /* IF CONFIGURED PRODUCT AND DISCOUNTS WERE FOUND WHERE
          * pi_confg_disc = YES, THEN CALL gppibx.p FOR DISCOUNTS
          * AND PROCESS THE DISCOUNTS WHERE pi_confg_disc = YES.
          * WHEN PROCESSING THESE DISCOUNTS, THE USE OF LIST PRICE
          * IS REQUIRED FOR ALL BUT DISCOUNT PERCENT TYPE DISCOUNTS.
          * SINCE best_list_price NOW CONTAINS THE LIST PRICE OF
          * THE ENTIRE CONFIGURATION THE DISCOUNTS THAT APPLY
          * ACROSS THE ENTIRE CONFIGURATION CAN NOW BE TESTED.
         */
         if exclude_confg_disc and found_confg_disc
         then do:
            assign
               exclude_confg_disc = no
               select_confg_disc  = yes.
            run apm-pricing2.
            /* READ THE CONFIGURATION AND SELECT COMPONENT LEVEL DISCOUNTS */
            {gprun.i ""sopicnfg.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

         end. /* THEN DO: */

         {gprun.i ""gppibx04.p""
            "(sobparent, sobfeature, sobpart, yes, rfact)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         /* TEST FOR BEST OVERALL PRICE EITHER BASED ON INDIVIDUAL
          * DISCOUNTS ADDED UP OR GLOBAL DISCOUNTS INDEPENDENT OF
          * COMPONENTS (IF ANY).  UPON DETERMINING THE WINNER, DELETE
          * LOSERS FROM wkpi_wkfl*/

         /* NOT ONLY MUST THE BEST PRICE WIN, BUT THERE MUST BE FOUND
          * SUPPORTING DISCOUNT RECORDS.*/
         if best_net_price <= sod_price
            and can-find(first wkpi_wkfl where
                        lookup(wkpi_amt_type, "2,3,4,9") <> 0
                           and wkpi_confg_disc = yes
                           and wkpi_source     = "0")
         then do:
            sod_price = best_net_price.
            run del-wkpi-wkfl-no.
         end. /* AND wkpi_source     = "0") THEN DO: */

         else do:
            if can-find(first wkpi_wkfl where
                       lookup(wkpi_amt_type, "2,3,4,9") <> 0
                          and wkpi_confg_disc = no)
            then
               run del-wkpi-wkfl-yn.
            else
               sod_price = best_net_price.
         end.    /* ELSE DO */

         if sod_list_pr <> 0 then
            sod_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.
         else
            sod_disc_pct = 0.

         /* JUST IN CASE SYSTEM DISCOUNTS CHANGED SINCE THE LAST PRICING  */
         /* AND THE USER MANUALLY ENTERED THE PRICE (OR DISCOUNT), RETAIN */
         /* THE PREVIOUS sod_price (THAT'S WHAT THE USER WANTS) AND REVISE*/
         /* THE MANUAL DISCOUNT ADJUSTMENT TO COMPENSATE.                 */
         run reviseManualDiscountAdjustment.

      end. /*line_pricing or reprice_dtl*/

      /* RMA ISSUE LINES MAY ALSO HAVE A DISCOUNT FROM THE SERVICE    */
      /* TYPE. CALCULATE LINE DISCOUNT AS THE 'NORMAL SALES ORDER'    */
      /* DISCOUNT AMOUNT, AND ADD TO THAT THE DISCOUNT DUE TO THE     */
      /* SERVICE TYPE COVERAGE.                                       */
      if this-is-rma then do:

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
            else
            if sod_list_pr = 0 and sod_price <> 0 then
               sod_covered_amt = sod_price * (coverage-discount / 100).
            else
               assign
                  sod_covered_amt = 0
                  sod__qadd01     = 0.

            /* NOTE:  sod__qadd01 IS USED TO CONTAIN THE ACTUAL DISCOUNT */
            /*  PERCENT THAT IS THE EQUIVALENT OF THE COVERAGE AMOUNT    */
            /*  (UNLESS APPLYING THE COVERAGE AMOUNT REDUCES sod_price   */
            /*  BELOW 0, THEN IT WILL REPRESENT sod_price PRIOR TO       */
            /*  APPLYING THE COVERAGE AMOUNT).                           */
            /*  SINCE MULTIPLE DISCOUNTS CAN BE APPLIED IN A CASCADING   */
            /*  MANNER, THE COVERAGE DISCOUNT AND sod__qadd01 MAY NOT    */
            /*  BE THE SAME, ALTHOUGH THEY WILL REPRESENT THE SAME       */
            /*  AMOUNT. sod__qadd01 WILL ONLY CONTAIN A VALUE WHEN THE   */
            /*  MANUAL DISCOUNT IS DUE TO THE COVERAGE DISCOUNT, ELSE    */
            /*  IT WILL CONTAIN 0.                                       */
            /*                                                           */
            /*  sod_covered_amt WILL ALWAYS MAINTAIN THE EQUIVALENT OF   */
            /*  THE COVERAGE DISCOUNT.  THIS IS REQUIRED IN ORDER TO     */
            /*  ADJUST THE MINIMUM AND MAXIMUM THRESHOLD VALUES WHEN     */
            /*  TESTING THE NET PRICE AGAINST THESE THRESHOLDS.          */
            if (line_pricing or reprice_dtl) then
               run adjustManualDiscountPercent.

         end.    /* IF rma-issue-line ... */

         else do:
            /* ELSE, IF THIS IS A RECEIPT LINE, THE USER MAY SEE */
            /* SOME 'DISCOUNT' AS A RESULT OF THE RESTOCK CHARGE */
            /* IN THIS CASE, GIVE HIM A MESSAGE TO CLARIFY.      */
            if not rma-issue-line and restock-pct <> 0 then
               /* RESTOCKING CHARGE APPLIES TO THIS LINE ITEM */
               run p-mfmsg (input 1186, input 1).
         end.    /* ELSE, rma-receipt-line, DO */

      end.   /* IF this-is-rma */

      assign
         old_price = sod_price
         old_list_pr = sod_list_pr
         old_disc = sod_disc_pct.

      if rma-issue-line then do:
         if sod_list_pr <> 0 then
            sod_disc_pct = (1 - (sod_price / sod_list_pr)) * 100.
         else
            sod_disc_pct = 0.

         /*DETERMINE DISCOUNT DISPLAY FORMAT*/
         /* TEST FOR DISCOUNT RANGE VIOLATION.  IF FOUND, CREATE/MAINTAIN */
         /* MANUAL DISCOUNT TO RECONCILE THE DIFFERENCE BETWEEN THE SYSTEM*/
         /* DISCOUNT AND THE MIN OR MAX ALLOWABLE DISCOUNT, DEPENDING ON  */
         /* THE VIOLATION.                                                */
         run p-disc-disp
            (input yes).

         if disc_min_max then do:     /* FOUND A DISCOUNT RANGE VIOLATION */

            assign
               save_disc_pct = disc_pct_err
               new_disc_pct  = if pic_so_fact then
                                  (1 - discount) * 100
                               else
                                  discount
               sod_disc_pct = new_disc_pct.

            find first wkpi_wkfl where wkpi_parent   = sobparent  and
                                       wkpi_feature  = sobfeature and
                                       wkpi_option   = sobpart    and
                                       wkpi_amt_type = "2"        and
                                       wkpi_source   = "1"
            no-lock no-error.

            /* Cascading Discount */
            if pic_disc_comb = "1" then do:

               if available wkpi_wkfl then
                  sys_disc_fact = if wkpi_amt = 100 then
                                     1
                                  else
                                     ((100 - save_disc_pct) / 100) /
                                     ((100 - wkpi_amt)      / 100).
               else
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
               end. /* ELSE DO: */

            end. /* IF pic_disc_comb = "1" THEN DO: */

            /* Additive Discount */
            else do:
               if available wkpi_wkfl then
                  man_disc_pct = new_disc_pct - (save_disc_pct - wkpi_amt).
               else
                  man_disc_pct = new_disc_pct - save_disc_pct.
            end. /* ELSE DO: */

            run p-gppiwkad.

            sod_price = sod_list_pr * (1 - (new_disc_pct / 100)).

         end.  /* IF disc_min_max */

      end.  /* IF rma-issue-line */

      else do:
         if disc_min_max then
            assign
               sod_disc_pct = if pic_so_fact then
                                 (1 - discount) * 100
                              else
                                 discount
               sod_price = sod_list_pr * (1 - (sod_disc_pct / 100)).
      end. /* ELSE DO: */

      run p-disc-disp
         (input no).

      display
         sod_list_pr
         discount
         sod_price
      with frame c.

      assign
         save_disc_pct = if sod_list_pr <> 0 then
                           (1 - (sod_price / sod_list_pr)) * 100
                         else
                            0
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


         {pxmsg.i &MSGNUM=4072 &ERRORLEVEL=4 &MSGBUFFER=l_err_msg}

         {&SOSOMTLA-P-TAG11}

/*xx*/   ASSIGN reprice_dtl = YES.

         if new_order or reprice_dtl    then
            update
               sod_list_pr
               discount
                  /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
                  when (rma-issue-line or restock-pct = 0 or
                        rmd_sv_code <> rma_ctype)
                  validate({gppswd1.v &field=""sod_disc_pct""
                                      &field1="discount"}, l_err_msg)
            with frame c.

         /*CHECK MIN/MAX FOR LIST PRICE VIOLATIONS
           CREATE wkpi_wkfl IF MIN OR MAX ERROR OCCURS*/
         if rma-issue-line then do:

            run p-gpmnmx01
               (input yes).

            /* List Price below Minimum allowed */
            if minerr then do:
               {gprun.i ""gppiwkad.p""
                  "(sod_um,
                    sobparent,
                    sobfeature,
                    sobpart,
                    ""2"",
                    ""1"",
                    sod_list_pr,
                    0,
                    yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* IF minerr THEN DO: */

            /* List Price above Maximum Allowed */
            if maxerr then do:
               {gprun.i ""gppiwkad.p""
                  "(sod_um,
                    sobparent,
                    sobfeature,
                    sobpart,
                    ""3"",
                    ""1"",
                    sod_list_pr,
                    0,
                    yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* IF maxerr THEN DO: */

            if minerr or maxerr then do:

               assign
                  sod_disc_pct      = 0
                  sod__qadd01       = 0
                  discount          = if pic_so_fact then 1 else 0
                  parent_list_price = sod_list_pr.  /*gppiwk02.p NEEDS THIS*/

               display
                  sod_list_pr
                  discount
                  sod_price
               with frame c.

               /* IF ANY EXISTING DISCOUNTS, CREATE/MAINTAIN "MANUAL" DISC */
               /* TO NEGATE DISCOUNT AND MAINTAIN PRICING HISTORY          */
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
                  end. /* IF AVAILABLE wkpi_wkfl */
                  else
                     sys_disc_fact =  (100 - save_disc_pct) / 100.

                  if sys_disc_fact <> 1 or available wkpi_wkfl then do:
                     if sys_disc_fact <> 0 then
                        man_disc_pct  = (1 - (1 / sys_disc_fact)) * 100.
                     else
                        man_disc_pct  = -100.
                     run p-gppiwkad.
                  end. /* IF sys_disc_fact <> 1 */

               end. /* IF pic_disc_comb = "1" THEN DO: */

               /* Additive */
               else do:
                  if available wkpi_wkfl then
                     man_disc_pct = - (save_disc_pct - wkpi_amt).
                  else
                     man_disc_pct = - save_disc_pct.
                  if save_disc_pct <> 0 or available wkpi_wkfl then
                     run p-gppiwkad.
               end. /* ELSE DO: */

            end. /* IF minerr OR maxerr THEN DO: */

            else do:

               /* TEST TO SEE IF LIST PRICE AND/OR DISCOUNT ARE MANUALLY */
               /* ENTERED.  IF SO UPDATE PRICING WORKFILE TO REFLECT THE */
               /* CHANGE.                                                */
               {&SOSOMTLA-P-TAG12}

               if sod_list_pr entered or discount entered then do:

                  if sod_list_pr entered then do:

                     l_flag = yes.

                     {&SOSOMTLA-P-TAG13}

                     {gprun.i ""gppiwkad.p""
                        "(sod_um, sobparent, sobfeature, sobpart,
                          ""1"", ""1"", sod_list_pr, 0, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                     parent_list_price = sod_list_pr. /*FOR gppiwk02.p*/

                     /* TAG AS A REPRICING CANDIDATE SINCE NET PRICE COULD */
                     /* BE AFFECTED BY CHANGE IN LIST PRICE.  ALSO, UPDATE */
                     /* EXTENDED LIST AMOUNT ACCUMULATION USED BY BEST     */
                     /* PRICING.                                           */
                     if line_pricing or not new_order then do:

                        find first wrep_wkfl where wrep_parent
                                               and wrep_line = sod_line
                        exclusive-lock no-error.

                        if available wrep_wkfl then
                           wrep_rep = yes.

                        {gprun.i ""gppiqty2.p""
                           "(sod_line,
                             sod_part,
                             0,
                             sod_qty_ord * (sod_list_pr - last_list_price),
                             sod_um,
                             yes,
                             yes,
                             yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                     end. /* IF line_pricing OR NOT new_order THEN DO: */

                     /* RE-APPLY THE BEST PRICING */
                     if (reprice_dtl or new_order) then
                        run p-bestprice.

                     if rma-issue-line then
                        sod_covered_amt =
                           sod_list_pr * (coverage-discount / 100).
                  end. /* IF sod_list_pr ENTERED THEN DO: */

                  sod__qadd01     = 0.
                  if pic_so_fact then
                     new_disc_pct = (1 - discount) * 100.
                  else
                     new_disc_pct = discount.
                  sod_disc_pct = new_disc_pct.

                  run p-disc-disp
                     (input yes).

                  if disc_min_max then
                     undo, retry.

                  find first wkpi_wkfl where
                     wkpi_parent = sobparent and
                     wkpi_feature  = sobfeature and
                     wkpi_option   = sobpart    and
                     wkpi_amt_type = "2"        and
                     wkpi_source   = "1"
                  no-lock no-error.

                  {&SOSOMTLA-P-TAG14}

                  if available wkpi_wkfl or discount entered  then do:

                     {&SOSOMTLA-P-TAG15}

                     if pic_disc_comb = "1" then do:  /*CASCADING DISCOUNT*/

                        if available wkpi_wkfl then do:
                           if not found_100_disc then
                              sys_disc_fact = if wkpi_amt = 100 then
                                                 1
                                              else
                                                 ((100 - save_disc_pct) / 100)
                                                 / ((100 - wkpi_amt)    / 100).
                           else
                              sys_disc_fact = 0 .
                        end. /* IF AVAILABLE WKPI_WKFL */
                        else
                           sys_disc_fact =  (100 - save_disc_pct) / 100.

                        if sys_disc_fact = 1 then
                           man_disc_pct  = new_disc_pct.
                        else do:
                           if sys_disc_fact <> 0 then
                              assign
                                 discount     = (100 - new_disc_pct) / 100
                                 man_disc_pct = (1 - (discount / sys_disc_fact))
                                               * 100.
                           else do:
                              if available wkpi_wkfl then
                                 man_disc_pct = new_disc_pct -
                                               (save_disc_pct - wkpi_amt).
                              else
                                    man_disc_pct  = new_disc_pct - 100.
                           end. /* ELSE DO: */
                        end. /* ELSE DO: */

                     end. /* IF pic_disc_comb = "1" THEN DO: */

                     /* Additive Discount */
                     else do:
                        if available wkpi_wkfl then
                           man_disc_pct =
                              new_disc_pct - (save_disc_pct - wkpi_amt).
                        else
                           man_disc_pct = new_disc_pct - save_disc_pct.
                     end. /* ELSE DO: */

                     run p-gppiwkad.

                     sod_price = sod_list_pr * (1 - (new_disc_pct / 100)).

                  end. /* IF AVAIL WKPI_WKFL OR DISCOUNT ENTERED */

                  assign
                     discount = if sod_list_pr <> 0 then
                                   100 * (sod_list_pr - sod_price)
                                   / sod_list_pr
                                else 0
                     sod_disc_pct = discount.

                  display
                     discount
                     sod_price
                  with frame c.

               end. /*sod_list_pr ENTERED OR discount ENTERED*/

            end. /*NOT minerr AND NOT maxerr*/

         end. /*rma-issue-line*/

         if this-is-rma and not rma-issue-line
            and (sod_list_pr entered or discount entered)
         then do:
            run p-sync-restock
               (input "discount").
            if disc_min_max  and
               restock-pct = 0
            then
               undo, retry.
            display
               discount
            with frame c.
         end.  /* IF RMA receipt & list OR disc changed */

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* DO ON ERROR UNDO, RETRY (FOR UPDATE OF sod_list_pr) */

      {&SOSOMTLA-P-TAG28}

      display
         sod_price
      with frame c.

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
         if  (new_order or reprice_dtl)
         and (rma-issue-line or
             (not rma-issue-line and
             restock-pct <> 100))
         then do:

            l_code =  getTermLabel("ANALYSIS",8).
            /* ISSUING A WARNING WHEN USER IS CREATING AN ORDER LINE */
            /* AND ANALYSIS CODES ARE BEING BUILT AT THE SAME TIME   */
            for first qad_wkfl
               fields(qad_key1 qad_key2)
               where qad_key1 = l_code
               and   qad_key2 = l_code
               no-lock:
               /* ANALYSIS CODES ARE BEING BUILT, PRICE MAY NOT BE CORRECT */
               run p-mfmsg (input 5571, input 2).
            end. /* FOR FIRST qad_wkfl */

            {&SOSOMTLA-P-TAG16}

            update
               sod_price
/*xx*/      sod__dec01 WHEN  substring(so__chr01,1,1)  <> "F"  
            with frame c.

/*xx*/  copper_rate = sod__dec01 .
/*xx*/  FIND FIRST pt_mstr WHERE pt_part = sod_part NO-LOCK NO-ERROR.
            IF AVAILABLE pt_mstr  AND pt__dec01 = 0  AND sod__dec01 <> 0  THEN DO:
                BELL.
                MESSAGE "The item has not include the Copper ! "  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                next-prompt sod__dec01.
                UNDO, RETRY  . 
           END.
           IF  substring(so__chr01,1,1)  <> "F"   THEN DO:
              IF AVAILABLE pt_mstr  AND pt__dec01 <> 0  AND sod__dec01 = 0  THEN DO:
                  BELL.
                  MESSAGE "The Copper Rate is not equal 0 ! "  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                  next-prompt sod__dec01.
                  UNDO, RETRY  . 
              END.
          END.
          ASSIGN sod__dec02 = sod__dec01 .


            {&SOSOMTLA-P-TAG17}

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF  (new_order OR reprice_dtl)... */

         /* DISALLOW PRICE CHANGE IF UNINVOICED SHIPMENT EXISTS */
         if sod_price <> last_sod_price and sod_qty_inv <> 0 then do:
            /* Invoice Quantity Pending, use Invoice Maintenance */
            run p-mfmsg (input 546, input 3).
            undo, retry.
         end. /* IF sod_price <> last_sod_price */

         {&SOSOMTLA-P-TAG18}

         /* VALIDATE MODIFICATION OF SOD_PRICE IN CASE OF EMT */
         if prev_price <> sod_price and not new_line
            and sod_btb_type = "03"
         then do:

            find vd_mstr where vd_addr = sod_btb_vend
            no-lock no-error.

            /* VALIDATE "SEND SO PRICE" FROM VENDOR */
            if available vd_mstr and vd_tp_use_pct = true then do:

               if so_secondary = true and soc_use_btb = true then do:
                  /* TRANSMIT CHANGES ON SBU SO TO PRIMARY PO AND SO */
                  {gprun.i ""sosobtb2.p""
                      "(input recid(sod_det),
                        input ""sod_list_pr"",
                        input string(prev_price),
                        output return-msg)" }
/*GUI*/ if global-beam-me-up then undo, leave.

                  /* DISPLAY ERROR MESSAGE RETURN FROM SOSOBTB2.P */
                  if return-msg <> 0 then do:
                     run p-mfmsg (input return-msg, input 3).
                      return-msg = 0.
                      if not batchrun then pause.
                     undo, retry.
                  end.
               end. /* if so_secondary */

            end. /* if available vd_mstr */

         end. /* if prev_price <> sod_price */

         if available cm_mstr
            and cm_promo <> ""
            and soc_apm
            and not this-is-rma
            and available pt_mstr and
            (new_order or reprice_dtl)
         then do:
            undo_bon = true.
            {gprun.i ""sobonli.p"" "(input sod_nbr, input sod_line)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            if undo_bon then undo loopc, leave.
            if sod_bonus then
               display sod_price with frame c.
         end. /* (new_order OR reprice_dtl) THEN DO: */

         /* PRICE TABLE MIN/MAX ERROR */

         /* IF RMA ISSUE LINE AND DISCOUNT COVERAGE EXISTS, EXCLUDE
          * COVERAGE AMOUNT FROM THE NET PRICE BY ADJUSTING THE MIN
          * AND MAX AMOUNTS RELATIVE TO THE COVERAGE AMOUNT*/
         if rma-issue-line then do:

            if this-is-rma then do:
               if min_price <> 0 then
                  min_price = min_price - sod_covered_amt.
               if max_price <> 0 then
                  max_price = max_price - sod_covered_amt.
            end. /* IF this-is-rma THEN DO: */

            run p-gpmnmx01
               (input no).

            if minmaxerr then do:
               minmax_occurred = yes.
               if sod_price > max_price and max_price <> 0 then
                  display max_price @ sod_price with frame c.
               else
                  display min_price @ sod_price with frame c.
               undo, retry.
            end. /* IF minmaxerr THEN DO: */

         end. /* IF rma-issue-line THEN DO: */

         l_sod_price = sod_price.

         if sod_list_pr = 0 and sod_price <> 0 then
            /* INTERNAL PROCEDURE p-bestprice-zero HANDLES              */
            /* IF BEST LIST PRICE IS ZERO AND IF MARKUP OR NET PRICE    */
            /* IS SELECTED ALONG WITH DISCOUNT PRICE LIST THEN DISCOUNT */
            /* AND LIST PRICE IS CALCULATED ACCORDINGLY                 */
            run p-bestprice-zero.

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
            run p-sync-restock
               (input "price").
            if disc_min_max  and
               restock-pct = 0
            then
               undo, retry.
            display
               sod_list_pr
               discount
            with frame c.
         end.  /* IF RMA RECEIPT & NET PRICE CHANGED */

         /* RMA-ISSUE-LINE APPLIES TO BOTH RMAs AND SOs HERE */
         if  rma-issue-line   and
            (sod_list_pr <> 0 or sod_bonus)
         then do:
            if  (sod_list_pr <> 0
            and  sod_list_pr <> l_sod_price)
            or   sod_bonus
            then
               assign
                   new_disc_pct = (1 - (sod_price / sod_list_pr)) * 100
                   sod_disc_pct = new_disc_pct.
            /*DETERMINE DISCOUNT DISPLAY FORMAT*/
            run p-disc-disp
               (input yes).
            if disc_min_max then
               undo, retry.
            display discount with frame c.
         end. /* THEN DO: */

         /* TEST TO SEE IF NET PRICE HAS BEEN ENTERED, IF SO CREATE A
          * DISCOUNT TYPE MANUAL RECORD TO wkpi_wkfl*/
         if rma-issue-line and
            (sod_price entered or sod_bonus or minmax_occurred)
         then do:

            sod__qadd01     = 0.
            minmax_occurred = no.

            find first wkpi_wkfl where
               wkpi_parent   = sobparent  and
               wkpi_feature  = sobfeature and
               wkpi_option   = sobpart    and
               wkpi_amt_type = "2"        and
               wkpi_source   = "1"
            no-lock no-error.

            if pic_disc_comb = "1" then do:          /*CASCADING DISCOUNT*/

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
                  if sys_disc_fact <> 0 then
                     assign
                        discount      = (100 - new_disc_pct) / 100
                        man_disc_pct  = (1 - (discount / sys_disc_fact)) * 100.
                  else do:
                     if available wkpi_wkfl then
                        man_disc_pct =
                           new_disc_pct - (save_disc_pct - wkpi_amt).
                     else
                        man_disc_pct  = new_disc_pct - 100.
                  end. /* ELSE DO: */
               end. /* ELSE DO: */

            end. /* IF pic_disc_comb = "1" THEN DO: */

            /* Additive Discount */
            else do:
               if available wkpi_wkfl then
                  man_disc_pct = new_disc_pct - (save_disc_pct - wkpi_amt).
               else
                  man_disc_pct = new_disc_pct - save_disc_pct.
            end. /* ELSE DO: */

            run p-gppiwkad.

         end.  /*sod_price ENTERED OR minmax_occurred*/

      end. /* DO ON ERROR UNDO, RETRY (FOR SET SOD_PRICE) */

      {&SOSOMTLA-P-TAG31}

      /*SET DETAIL FREIGHT LIST, IF ANY.  DETERMINED THRU PRICING ROUTINES*/
      if current_fr_list <> ""
         and sod_manual_fr_list = no
      then
         sod_fr_list = current_fr_list.

      /* SET THE DEFAULT ALLOCATION QUANTITY */
      {&SOSOMTLA-P-TAG26}
      if new_line
         and not s-btb-so    /* ALLOCATIONS ARE NO ALLOWED FOR BTB LINES */
         and sod_confirm
         and sod_qty_ord > 0
         and all_days <> 0
         and (sod_due_date - (today + 1) < all_days)
      then do:
      {&SOSOMTLA-P-TAG27}
         if sod_type = "" then do:

            new_site = sod_site.

            {gprun.i ""gpalias2.p"" "(new_site, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.


            {gprun.i ""soqtyavl.p"" "(sod_part, sod_site, output qty_avl)" }
/*GUI*/ if global-beam-me-up then undo, leave.


            run pGetReservedLocationInventory.

            {gprun.i ""gpalias3.p"" "(so_db, output err-flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            qty_avl = qty_avl / sod_um_conv.

            {&SOSOMTLA-P-TAG19}

            /* NOTE: QTY PICK AND SHIP MUST BE ZERO SINCE LINE IS NEW */
            if soc_all_avl = no then
               sod_qty_all = max(sod_qty_ord,0).
            else
               sod_qty_all = max( min(sod_qty_ord, qty_avl) , 0).

         end. /* IF sod_type = "" THEN DO: */
         else
            sod_qty_all = max( sod_qty_ord, 0 ).

      end. /* THEN DO: */

      /* FOR RMA'S, ALLOW USER TO OVERRIDE THE DEFAULT PRODUCT LINE */
      /* UP TO THE POINT IN TIME WHERE THEY'VE SHIPPED/INVOICED     */
      if this-is-rma and sngl_ln and sod_qty_ship = 0
         and sod_qty_inv = 0
      then do:
         {gprun.i ""fsrmapl.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

         display
            sod_acct
            sod_sub
            sod_cc
            sod_project
            sod_dsc_acct
            sod_dsc_sub
            sod_dsc_cc
            sod_dsc_project
         with frame d.
      end. /* AND sod_qty_inv = 0 THEN DO: */

      /* UPDATE OTHER SALES ORDER LINE INFORMATION */
      undo_all2 = true.

      /* SOSOMTLB.P WILL, FOR RMA'S, CREATE/MODIFY THE RMD_DET */
      {&SOSOMTLA-P-TAG20}
      /* ADDED using_consignment VARIABLES TO  */
      /* THE CALL TO sosomtlb.p.               */
      {gprun.i ""xxsosomtlb.p""
         "(input this-is-rma,
           input rma-recno,
           input rma-issue-line,
           input rmd-recno,
           input l_prev_um_conv,
           input using_consignment,
           input l_sodqtyord,
           input-output confirmApoAtpOrderLine,
           output atp-site,
           output atp-cum-qty,
           output atp-qty-site-changed)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      if not this-is-rma and soc_so_hist then
         /* COMPARE BEFORE AND AFTER SOD_DET DATA TO DETERMINE WHETHER */
         /* A CHANGE HAS OCCURRED AND A COMMENT NEEDS TO BE CAPTURED   */
         /* FOR BOOKING HISTORY PROMPT FOR A REASON CODE IF ANY SOD    */
         /* FIELDS NEED TO BE TRACKED REASON CODES WITH A TYPE OF      */
         /* ORD_CHG MUST EXIST IN ORDER FOR A REASON CODE AND COMMENT  */
         /* TO BE ENTERED.                                             */

        for each tt_field_recs:
           create buffer so_fldname for table "sod_det".
           so_fld = buffer sod_det:buffer-field(tt_field_name).

           /* CHANGED tt_field_value TO ARRAY OF LENGTH 5        */
           /* AND CONDITIONALLY ASSIGNING BUFFER-VALUE OF so_fld */
           if so_fld:EXTENT <> 0
           then do l_knt = 1 to so_fld:EXTENT:
              if string(tt_field_value[l_knt]) <>
                 string(so_fld:BUFFER-VALUE[l_knt])
              then do:
                 global_type = " ".
                 global_ref = so_nbr.
                 run p-reason-code.
                 leave.
              end. /* IF string... */
           end. /* IF so_fld:EXTENT <> 0 */
           else
              if string(tt_field_value[1]) <> string(so_fld:BUFFER-VALUE)
              then do:
                 global_type = " ".
                 global_ref = so_nbr.
                 run p-reason-code.
              end. /* IF string... */
        end. /* FOR EACH TT_FIELD_RECS */

      hide frame rsn.


      if undo_all2 then do:
         hide message.
         undo loopc, leave.
      end. /* IF undo_all2 THEN DO: */
      {&SOSOMTLA-P-TAG21}

      if sod_per_date = ? then
         sod_per_date = sod_due_date.
      if sod_req_date = ? then
         sod_req_date = sod_due_date.

      if atp-qty-site-changed then
         undo loopc, retry.

      /* LOAD SOD_CONTR_ID FROM SO_PO FOR SO_SHIPPER MAINT */
      if not this-is-rma and not so_sched then
         sod_contr_id = so_po.

      if not available pt_mstr then do:
         update desc1 with frame d.
         sod_desc = desc1.
      end. /* IF NOT AVAILABLE pt_mstr THEN DO: */

      /* DELETE OLD PRICE LIST HISTORY, CREATE NEW PRICE LIST HISTORY, */
      /* MAINTAIN LAST PRICED DATE IN so_mstr (so_priced_dt)           */
      if rma-issue-line and (new_order or reprice_dtl)
      then do:

         best_net_price = sod_price. /*for "accrual" type price lists*/

         run p-call-apm
            (input sod_nbr,
             input sod_line,
             input new_order,
             input-output wk_bs_line,
             input-output wk_bs_promo).

         if parent_list_price = 0
         then
            parent_list_price = best_list_price.

         {gprun.i ""gppiwk02.p""
            "(1, sod_nbr, sod_line,
              sod_dsc_acct, sod_dsc_sub, sod_dsc_cc, sod_dsc_project,
              wk_bs_line, wk_bs_promo)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         so_priced_dt = today.

      end. /* IF rma-issue-line */

      /* CALL sosomisb.p TO SET DEFAULT INSTALLED BASE INFO */
      /* IF SHIPPING TO INSTALLED BASE (svc_ship_isb) AND   */
      /* PART IS SET UP FOR THE ISB (pt_isb).               */
      /* IF soc_isb_window    AND                           */
      /* CONDITIONALLY TEST IF AVAILABLE svc_trl.           */

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

         end.  /* IF svc_ship_isb AND... */
      end.   /* IF this-is-rma */

      else do:
         /* FOR RETURNS, DISPLAY "EDIT ISB DEFAULTS" FRAME IF USER IS
          * UPDATING ISB WITH RETURNS AND THIS PART EXISTS SOMEWHERE
          * IN THE INSTALLED BASE.  FOR REGULAR SO'S, DISPLAY THIS
          * FRAME ONLY IF SHIPPING TO ISB AND PART IS FLAGGED FOR ISB */
          if (sod_qty_ord < 0 and
            available svc_ctrl and svc_ship_isb and soc_returns_isb
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
                  input this_is_edi)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end. /* THEN DO: */

      end.   /* ELSE (this isn't an rma) DO: */

      if solinerun <> "" then do:
         {gprun.i solinerun
            "(input so_recno, input sod_recno)"}
/*GUI*/ if global-beam-me-up then undo, leave.

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
      if sodcmmts = yes then do:
         assign
            cmtindx = sod_cmtindx
            global_ref = sod_part
            save_part  = global_part
            global_part = emt-bu-lvl.
         {gprun.i ""gpcmmt01.p"" "(input ""sod_det"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

         sod_cmtindx = cmtindx.
         global_part = save_part.
      end.

      /* Direct Allocations - EMT Orders */
      {gprun.i ""sobtbla3.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


      /* Update Purchase Order if EMT and values have changed */
      if (s-btb-so
      or l_prev_sod_btb_type <> "01")
      and sod_confirm
      and so_primary
      then do:
         {gprunp.i "soemttrg" "p" "process-order-detail"
            "(input new_line,
              input so_nbr,
              input sod_line,
              output return-msg)"}
         if return-msg <> 0 then do:
            run p-mfmsg (input return-msg, input 4).
            return-msg = 0.
            if not batchrun then pause.
            undo loopc, leave.
         end. /* if return-msg <> 0 */

         if sod_btb_type = "01"
         and sod_btb_po  <> ""
         then
            assign
               sod_btb_po       = ""
               sod_btb_pod_line = 0.

         if  sod_btb_type <> "01"
         and not new_line
         then do:

            /* STORE THE RECENT VALUE CHANGES IN WORKFILE */
            {gprunp.i "soemttrg" "p" "modify-workfile"
               "(buffer sod_det)"}

         end. /* IF sod_btb_type <> "01" */

      end.

      if s-btb-so and so_primary then do on endkey undo loopc, leave:
         hide frame d no-pause.

         /*GET EMT MNEUMONIC FROM lng_det */
         {gplngn2a.i &file = ""emt""
                     &field = ""btb-type""
                     &code = sod_btb_type
                     &mnemonic = btb-type
                     &label = btb-type-desc}

         for first pod_det
            fields(pod_cmtindx pod_due_date pod_line pod_nbr
                   pod_need pod_so_status)
            where pod_nbr = sod_btb_po
              and pod_line = sod_btb_pod_line
         no-lock:
         end. /* FOR FIRST POD_DET */

         if available pod_det then
            display
               btb-type
               sod_site
               sod_btb_vend
               pod_due_date
               sod_btb_po
               pod_need
               sod_btb_pod_line
            with frame btb_data.
         {gpwait.i}
         hide frame btb_data.
      end. /* IF s-btb-so and so_primary THEN DO: */

   end. /* ELSE DO: */

   if sodcmmts = yes then
      sod_cmtindx = 0.

   /* UPDATE THE INVENTORY DATABASE FILES */
   if sod_confirm then do:   
        run confirmOrder.
   end. /* IF sod_confirm THEN DO: */
   else do:  /* UPDATE sob_det ONLY */
      if available pt_mstr and pt_pm_code = "C" then do:
         {gprun.i ""sosomti.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

      end. /* IF AVAILABLE pt_mstr */
   end. /* ELSE DO: */

   /* ASSIGN sod_cmtindx AFTER UPDATING INVENTORY DATABASE FILES */
   if sodcmmts = yes then
      sod_cmtindx = cmtindx.

   undo_all = no.
end. /*DO*/

if cfexists and cf_rm_old_bom and not undo_all then do:
   /* IF THE USER CHOSE TO REMOVE THE OLD BOM (AS THEY MODIFIED THE*/
   /* FILE) THEN WE NEED TO ISSUE A SAVE TO SAVE THE CONFIG. AND   */
   /* WRITE THE FILENAME AND MODEL AND CONFIG.STATUS TO THE QAD    */
   /* USER FIELDS.                                                */
   if search(cf_cfg_path + cf_chr + sod__qadc01) <> ? then
      os-delete value(cf_cfg_path + cf_chr + sod__qadc01).
   /* WRITE sod_det FIELDS */
   assign
      sod__qadc01 =
         lc(sod_nbr) + "_" + string(sod_line) + "." + lc(cf_cfg_suf)
      sod__qadc02 = pt_cf_model
      sod__qadc03 = "".
   /* ISSUE SAVE TO CALICO */
        
   {gprunmo.i
      &module  = "cf"
      &program = "cfcfsave.p"
      &param   = """(string(cf_cfg_path + cf_chr + sod__qadc01))"""
   }
     
end. /* IF cfexists AND cf_rm_old_bom AND NOT undo_all THEN DO: */

if cfexists and not undo_all and not cf_rp_part then do:
   /* ON A CONFIGURED PRODUCT, IF THE USER SELECTS qty ord = 0 STD.  */
   /* FUNCTIONALITY WILL DELETE THE ITEMS BOM. THE FUNCTIONALITY MUST*/
   /* ALSO EXTEND TO DELETING THE CREATED CONCINITY qad_fields AND   */
   /* ASSOCIATED FILES.                                              */
   if available sod_det and sod_qty_ord = 0 then do:
      os-delete value(cf_cfg_path + cf_chr + sod__qadc01).
      assign
         sod__qadc01 = ""
         sod__qadc02 = ""
         sod__qadc03 = "".
   end. /* IF AVAILABLE sod_det AND sod_qty_ord = 0 THEN DO: */
end. /* IF cfexists AND NOT UNDO_ALL AND NOT cf_rp_part THEN DO: */

/* IF PROCESSING 'END CONFIGURATION', DO NOT RESET CONFIGURATION */
if cfexists and not cf_cfg_strt_err and not cf_endcfg then do:
   /* CLOSE CONFIGURATIONS */
        
   {gprunmo.i
      &module  = "cf"
      &program = "cfcfclos.p"
      &param   = """(input cf_cfg_path, input cf_chr,
                     cf_cfg_suf) """
   }
     
end. /* IF cfexists AND NOT cf_cfg_strt_err AND NOT cf_endcfg THEN DO: */

hide frame line_pop no-pause.
pause 0.

/* END OF MAIN PROCEDURE */

PROCEDURE getPriceTableRequiredFlag:
/* ----------------------------------------------------------------
  Purpose:      Read price table required flag from mfc_ctrl
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

   find first mfc_ctrl where mfc_field = "soc_pt_req" no-lock no-error.

   if available mfc_ctrl then
      soc_pt_req = mfc_logical.

END PROCEDURE. /* getPriceTableRequiredFlag */

PROCEDURE setOrderLineAndDesc:
/* ----------------------------------------------------------------
  Purpose:      Set Order Line Description and Line Number
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

   assign
       desc1 = getTermLabel("ITEM_NOT_IN_INVENTORY",24)
       desc2 = ""
       line = sod_det.sod_line.

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
/* ----------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

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
/* ----------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

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
/* ----------------------------------------------------------------
  Purpose:      Set Order Line Description
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

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
/* ----------------------------------------------------------------
  Purpose:      Set Order Line Description
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

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

         /* Cascading discount */
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
            man_disc_pct = new_disc_pct -
                           (save_disc_pct - wkpi_amt).
         else
            man_disc_pct = new_disc_pct - save_disc_pct.
      end.

      {gprun.i ""gppiwkad.p""
         "(sod_um, sobparent, sobfeature, sobpart,
           ""1"", ""2"", 0, man_disc_pct, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   end. /* last_sod_price <> sod_price */

END PROCEDURE.  /* reviseManualDiscountAdjustment */

PROCEDURE adjustManualDiscountPercent:
/* ----------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

   find first wkpi_wkfl where wkpi_parent   = sobparent  and
                              wkpi_feature  = sobfeature and
                              wkpi_option   = sobpart    and
                              wkpi_amt_type = "2"        and
                              wkpi_source   = "1"
   no-lock no-error.

   if not available wkpi_wkfl then do:

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

         /* Cascading discount*/
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

      /* Additive Discount */
      else do:
         man_disc_pct = new_disc_pct - save_disc_pct.
      end.

      /* DO NOT CREATE MANUAL OVERRIDE DISCOUNT IN WKPI_WKFL */
      /* FOR ZERO COVERAGE DISCOUNT                          */
      if man_disc_pct <> 0 then do:
         {gprun.i ""gppiwkad.p""
            "(sod_um, sobparent, sobfeature, sobpart,
              ""1"", ""2"", 0, man_disc_pct, yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

      end. /* IF MAN_DISC_PCT <> 0 */

      sod__qadd01 = man_disc_pct.

   end.
   else
      sod__qadd01 = 0.

END PROCEDURE.  /* adjustManualDiscountPercent */


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

   for first sod_det
      where sod_nbr = sales_nbr
      and sod_line = line_nbr no-lock:
   end. /* FOR FIRST SOD_DEET */

   if not sod_bonus then
      assign
         wk_bs_line  = 0
         wk_bs_promo = "".

   else if not new_order then do:

      if wk_bs_line = 0 and wk_bs_promo = "" then do:

         for first pih_hist
            fields(pih_amt pih_amt_type pih_bonus_line
                   pih_doc_type pih_feature pih_line pih_nbr
                   pih_option pih_parent pih_promo1 pih_source)
            where pih_doc_type = 1         and
                  pih_nbr      = sod_nbr   and
                  pih_line     = sod_line  and
                  pih_source   = "1"       and
                  pih_amt_type = "2" no-lock:
         end. /* FOR FIRST PIH_HIST */

         if available pih_hist and pih_bonus_line <> 0 then
            assign
               wk_bs_line  = pih_bonus_line
               wk_bs_promo = pih_promo1.

      end. /* IF wk_bs_line = 0 AND wk_bs_promo = "" THEN DO: */

   end. /* ELSE IF NOT new_order THEN DO: */

END PROCEDURE. /* END PROCEDURE*/

PROCEDURE p-sync-restock:
/* -------------------------------------------------------------------
  Purpose:      Re-applies a restocking charge to an RMA Receipt Line
                if a percent exists and keeps necessary fields in
                sync.  It takes one input parameter
  Parameters:   mode
                   IF "default", INITIAL SETUP FOR DEFAULT PRICING
                   IF "discount", DISCOUNT OR LIST PRICE WAS UPDATED
                   IF "price", NET PRICE WAS UPDATED
  Notes:
 ---------------------------------------------------------------------*/
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
                           then
                              (1 - (sod_price / sod_list_pr)) * 100
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

   end.  /* ELSE DO */

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
/* -------------------------------------------------------------------
  Purpose:      Checks the SO or RMA Line's discount field to insure
                that it complies with the pricing control file format
                It takes on input
  Parameters:   warn - if yes, a message will be displayed with a pause
  Notes:
 ------------------------------------------------------------------*/

   define input parameter warn as logical.

   if not available sod_det or not available pic_ctrl then leave.

   disc_min_max = no.

   {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}

   if disc_min_max and warn then do:

      /* DISCOUNT # VIOLATES THE MIN OR MAX ALLOWABLE */
      {pxmsg.i &MSGNUM=6932 &ERRORLEVEL=3 &MSGARG1=disc_pct_err}
      if not batchrun then pause.

   end.  /* IF disc_min_max */

END PROCEDURE.  /* p-disc-disp */

PROCEDURE p-itm-prlst-chk:
/* ----------------------------------------------------------------
  Purpose:      Check Price List availability
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

   if soc_pt_req then do:

      if not available wkpi_wkfl
      then do:

         /* CHECK PRICE LIST AVAILABILITY FOR INVENTORY ITEMS */
         if right-trim(sod_det.sod_type) = ""
            or (right-trim(sod_det.sod_type) <> ""
            and available pt_mstr)
         then do:
            /* REQUIRED PRICE TABLE FOR ITEM # IN UM # NOT FOUND */
            {pxmsg.i &MSGNUM=6231 &ERRORLEVEL=4
                     &MSGARG1=sod_det.sod_part
                     &MSGARG2=sod_det.sod_um}
            l_undoln = yes.
            if not batchrun then
               pause.
         end. /* IF RIGHT-TRIM(SOD_DET.SOD_TYPE) = "" OR ... */

         else
         /* CHECK PRICE LIST AVAILABILITY FOR NON-INVENTORY ITEMS */
         if right-trim(sod_det.sod_type) <> ""
            and not available pt_mstr
         then do:
            /* REQUIRED PRICE TABLE FOR ITEM # IN UM # NOT FOUND */
            {pxmsg.i &MSGNUM=6231 &ERRORLEVEL=2
                     &MSGARG1=sod_det.sod_part
                     &MSGARG2=sod_det.sod_um}
            if not batchrun then
               pause.
         end. /*IF RIGHT-TRIM(SOD_DET.SOD_TYPE) <> "" AND ...*/

      end. /* IF AVAILABLE WKPI_WKFL ... */

   end. /* IF SOC_PT_REQ THEN DO */

END PROCEDURE.

PROCEDURE p-btb-ok:
/* ----------------------------------------------------------------
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
------------------------------------------------------------------*/

   define output parameter p-error  like mfc_logical initial no no-undo.
   define output parameter p-errnum like msg_nbr                no-undo.

   define variable l-errsev   as   integer initial 3 no-undo.

   assign
      l-errsev = 3
      p-errnum = 0
      p-error  = yes.

   if so_mstr.so_primary then do:

      for first pod_det
         fields(pod_cmtindx pod_due_date pod_line pod_nbr pod_need
                pod_status pod_so_status)
         where pod_nbr  = sod_det.sod_btb_po
           and pod_line = sod_det.sod_btb_pod_line no-lock:
      end. /* FOR FIRST POD_DET */

      find po_mstr where po_nbr = sod_det.sod_btb_po no-lock no-error.

      if (available po_mstr and (po_stat = "C" or po_stat = "X")) or
         (available pod_det and (pod_status = "C" or pod_status = "X"))
      then do:
         assign
            l-errsev = 2
            /* PO Order/Line is closed or cancelled. Continue? */
            p-errnum = 4639.
      end.

      else if available pod_det and pod_so_status <> "" then do:

         /* Secondary BU Order has been picked */
         if pod_so_status = "P" then do:
            if can-find (mfc_ctrl where
                         mfc_field  = "soc_emt_pick" and
                         mfc_logical)
            then
               assign
                  l-errsev = 2
                  /* Inventory Picked at Supplier, Continue? */
                  p-errnum = 4615.
            else
               assign
                  /* Inventory Picked at Supplier, change not allowed */
                  p-errnum = 2023.
         end. /* if status = "P" */

         /* Secondary BU Order has been Released to WO */
         else if pod_so_status = "W" then do:
            if can-find (mfc_ctrl where
                         mfc_field  = "soc_emt_rel" and
                         mfc_logical)
            then
               assign
                  l-errsev = 2
                  /* Released to WO at supplier.  Continue? */
                  p-errnum = 4619.
            else
               assign
                  /* Released to WO at supplier. Change not allowed */
                  p-errnum = 4618.
         end. /* if status = "W" */

         /* Secondary BU Order has been shipped */
         else if pod_so_status = "S" then do:
            if can-find (mfc_ctrl where
                         mfc_field  = "soc_emt_ship" and
                         mfc_logical)
            then
               assign
                  l-errsev = 2
                  /* Quantity shipped at supplier.  Continue ? */
                  p-errnum = 4617.
            else
               assign
                  /* Change not allowed. Lines already shipped */
                  p-errnum = 2864.
         end. /* if status = "S" */

         /* Unknown Status */
         else
            assign
               l-errsev = 3
               p-errnum = 2825.

      end. /* if available pod_det and pod_so_status <> "" */

   end.

   /* Do not allow modifcation of SBU Lines with configured items */
   /* If this is a secondary Order                                */
   else
   if can-find(first sob_det where sob_nbr  = sod_det.sod_nbr
                               and sob_line = sod_det.sod_line)
   then
      assign
         l-errsev = 3
         p-errnum = 2859.

    if l-errsev = 3 and p-errnum <> 0 then do:
       hide message no-pause.
       run p-mfmsg (input p-errnum, input l-errsev).
       if not batchrun then pause.
       p-error = yes.
    end.

    else if l-errsev = 2 and p-errnum <> 0 then do:
       hide message no-pause.
       {pxmsg.i &MSGNUM=p-errnum &ERRORLEVEL=l-errsev &CONFIRM=yn}
       if yn then
          p-error = no.
    end.

    else
       p-error = no.

END PROCEDURE.

PROCEDURE p-calc-fr-wt:
/* ----------------------------------------------------------------
  Purpose:      Calculate freight weight in multi-entry mode for
                inventory items with calculate freight set to yes
                as a new sales order line is created.
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

   define variable l_um_conv     like sod_um_conv no-undo.
   define variable l_frc_returns like mfc_char    no-undo.

   if not available sod_det or not available pt_mstr then leave.

   if sod_type = "" then do:

      if sod_um <> pt_um then do:

         {gprun.i ""gpumcnv.p"" "(input sod_um,
                                  input pt_um,
                                  input sod_part,
                                  output l_um_conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         if l_um_conv = ? then do:
            /* FREIGHT ERROR DETECTED - CHARGES MAY BE INCOMPLETE */
            run p-mfmsg (input 669, input 2).
            if not batchrun then pause.
            l_um_conv = 1.
         end. /* IF L_UM_CONV = ? */

      end. /* SOD_UM <> PT_UM */
      else
         l_um_conv = 1.

      for first mfc_ctrl
         fields(mfc_char mfc_field mfc_logical)
         where mfc_field = "frc_returns" no-lock:
      end. /* FOR FIRST MFC_CTRL */

      l_frc_returns = mfc_char.

      if sod_qty_ord < 0 and l_frc_returns = "z" then
         sod_fr_wt = 0.
      else
         sod_fr_wt = pt_ship_wt * l_um_conv.

      sod_fr_wt_um = pt_ship_wt_um.

   end. /* IF SOD_TYPE = "" */

END PROCEDURE. /* p-calc-fr-wt */

PROCEDURE find-ptp-j2d8:
/* ----------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

   define input parameter inpar_part like pt_part.
   define input parameter inpar_site like si_site.

   for first ptp_det
      fields(ptp_ord_max ptp_ord_min ptp_ord_mult ptp_part
             ptp_pm_code ptp_site)
      where ptp_part = inpar_part
      and ptp_site = inpar_site no-lock:
   end. /* FOR FIRST PTP_DET */

   if available ptp_det then
      pm_code = ptp_pm_code.

END PROCEDURE. /* find-ptp-j2d8 */

PROCEDURE del-wkpi-wkfl-no:
/* ----------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

   for each wkpi_wkfl where
      lookup(wkpi_amt_type, "2,3,4,9") <> 0 and
             wkpi_confg_disc = no
   exclusive-lock:
         delete wkpi_wkfl.
   end. /* FOR EACH wkpi_wkfl */

END PROCEDURE. /* DEL-WKPI-WKFL-NO */

PROCEDURE del-wkpi-wkfl-yn:
/* ----------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

   for each wkpi_wkfl where
      lookup(wkpi_amt_type, "2,3,4,9") <> 0 and
             wkpi_source     = "0"                 and
             wkpi_confg_disc = yes
   exclusive-lock:
         delete wkpi_wkfl.
   end. /* FOR EACH wkpi_wkfl */

END PROCEDURE. /* DEL-WKPI-WKFL-YN */

PROCEDURE sod-conv:
/* ----------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

   define input  parameter insodstdcost  like sod_std_cost no-undo.
   define output parameter outsodstdcost like sod_std_cost no-undo.

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input  remote-base-curr,
        input  base_curr,
        input  exch-rate,
        input  exch-rate2,
        input  insodstdcost,
        input  false,
        output outsodstdcost,
        output mc-error-number)"}.
   if mc-error-number <> 0 then do:
      run p-mfmsg (input mc-error-number, input 2).
   end. /* IF mc-error-number <> 0 THEN DO: */

END PROCEDURE.  /* sod-conv */

PROCEDURE p-bestprice:
/* ----------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

   /* BEFORE RE-PRICING DELETE PREVIOUSLY SELECTED PRICE LIST */
   /* RECORDS EXCEPT LIST PRICE. RETAIN ALL MANUAL OVERRIDE   */
   /* RECORDS.                                                */
   for each wkpi_wkfl where
            wkpi_amt_type <> "1" and
            wkpi_source = "0"
   exclusive-lock:
       delete wkpi_wkfl.
   end. /* FOR EACH wkpi_wkfl */

   /* GET BEST DISCOUNT TYPE PRICE LISTS                     */
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

   end. /* IF SOC_APM */

   else do: /* IF NOT SOC_APM */
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

   end. /* IF NOT SOC_APM */

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
      save_disc_pct =
         if sod_det.sod_list_pr <> 0 then
            (1 - (sod_det.sod_price / sod_det.sod_list_pr)) * 100
         else
            0.

END PROCEDURE.  /* P-BESTPRICE */

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
      {gprun.i ""gppibx.p""
         "(pics_type,
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

   end.  /* IF SOC_APM  */

   else do:  /* IF NOT SOC_APM */
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

   end. /* IF NOT SOC_APM */

END PROCEDURE. /* APM-PRICING2 */

PROCEDURE p-bestprice-zero:
/* ----------------------------------------------------------------
  Purpose:     If best list price is zero and if markup or net
               price is selected along with discount price list
               then disount and list price is calculated
               accordingly.
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

   define variable l_list_id like wkpi_list_id no-undo.
   define variable l_list    like wkpi_list    no-undo.
   define variable l_source  like wkpi_source  no-undo.
   define variable l_part    like wkpi_option  no-undo.

   /* REPLACED FIND FIRST WITH FOR EACH wkpi_wkfl FOR */
   /* CONFIGURED ITEMS                                */
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

            for first pi_mstr
               fields(pi_cost_set pi_list_id)
               where pi_list_id = wkpi_list_id no-lock:
            end. /* FOR FIRST PI_MSTR */

            if pi_cost_set = "" then do:
               {gprun.i ""gpsct05x.p"" "(l_part,
                                         sod_det.sod_site,
                                         1,
                                         output glxcst,
                                         output curcst)" }
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* IF PI_COST_SET = "" */
            else do:
               {gprun.i ""gpsct07x.p"" "(l_part,
                                         sod_det.sod_site,
                                         pi_cost_set,
                                         1,
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

   end. /* FOR EACH wkpi_wkfl */

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
      sod_det.sod_disc_pct = (1 - (sod_det.sod_price /
                              sod_det.sod_list_pr)) * 100.
   else
      assign
         sod_det.sod_list_pr = sod_det.sod_price
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

   {gprun.i ""gppiwkad.p""
      "(sod_um, sobparent, sobfeature, sobpart,
        l_source, ""1"", sod_det.sod_list_pr, sod_det.sod_disc_pct, no )"}
/*GUI*/ if global-beam-me-up then undo, leave.


   if not l_flag then do:

      find first wkpi_wkfl where
            wkpi_parent   = sobparent
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

{&SOSOMTLA-P-TAG22}

PROCEDURE chk-pl-exist:
/* ----------------------------------------------------------------
  Purpose:     Gives an error when soc_pt_req = yes and no price
               list was found for any mandatory/no-mandatory
               component of a configured product.
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

   for each sob_det
      fields (sob_feature sob_line sob_nbr sob_parent
              sob_part sob_tot_std)
      where sob_nbr = sod_det.sod_nbr and
            sob_line = sod_det.sod_line
   no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


      find first wkpi_wkfl where
        wkpi_parent  = sob_parent  and
        wkpi_feature = sob_feature and
        wkpi_option  = sob_part    and
        wkpi_amt_type = "1"
      no-lock no-error.

      /* GIVING ERROR WHEN NO PRICE LIST WAS FOUND AND THE PRICE     */
      /* WAS MANUALLY ENTERED OR WHEN THE PRICE WAS FROM ITEM MASTER */
      if (available wkpi_wkfl
         and wkpi_source = "4")
         or not available wkpi_wkfl
      then do:
         /* ERROR: REQUIRED PRICE TABLE FOR ITEM # IN UM # NOT FOUND */
         {pxmsg.i &MSGNUM=6231 &ERRORLEVEL=4
                  &MSGARG1=sob_part
                  &MSGARG2=sod_um}
         l_undoln = yes.
         if not batchrun then
            pause.
         return.
      end. /* IF AVAILABLE WKPI_WKFL AND ... */

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH SOB_DET */

END PROCEDURE. /* PROCEDURE CHK-PL-EXIST */

PROCEDURE p-shipper-check:
/* ----------------------------------------------------------------
  Purpose:      Check for the existence of a confirmed/unconfirmed
                shipper
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

   define output parameter p_undo_all like mfc_logical initial no no-undo.

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
         save_abs   = substring(save_abs,2,20).

      {pxmsg.i &MSGNUM=1118 &ERRORLEVEL=3
               &MSGARG1=shipper_found
               &MSGARG2=save_abs}
   end. /* IF SHIPPER_FOUND > 0 */

   /* IF ALL THE SHIPPERS FOR THE ORDER HAVE BEEN CONFIRMED      */
   else if l_conf_ship > 0 then do:

         l_conf_shid = substring(l_conf_shid,2,20).

         {pxmsg.i &MSGNUM=3314 &ERRORLEVEL=2
                  &MSGARG1=l_conf_ship
                  &MSGARG2=l_conf_shid}

         /* IF END-ERROR IS PRESSED, UNDO */
         if not batchrun
         then do:
            readkey.
            if keyfunction(lastkey) = "END-ERROR"
            then do:
               p_undo_all = yes.
            end. /* IF KEYFUNCTION(lastkey) */
         end. /* IF NOT batchrun THEN DO */

      end. /* IF l_conf_ship > 0 */

END PROCEDURE. /* P-SHIPPER-CHECK */

PROCEDURE p-mfmsg:
/* ----------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

   define input parameter l_num  as integer no-undo.
   define input parameter l_stat as integer no-undo.

   {pxmsg.i &MSGNUM=l_num &ERRORLEVEL=l_stat}

END PROCEDURE.  /* PROCEDURE P-MFMSG */

PROCEDURE p-gppiwkad:
/* ----------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

   {gprun.i ""gppiwkad.p"" "(sod_det.sod_um,
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

END PROCEDURE. /* PROCEDURE P-GPPIWKAD */

PROCEDURE p-delete-cmt-det:
/* ----------------------------------------------------------------
  Purpose:      Delete Comments
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

   for each cmt_det
      where cmt_indx = sod_det.sod_cmtindx
   exclusive-lock:
         delete cmt_det.
   end. /* FOR EACH CMT_DET */

END PROCEDURE.

PROCEDURE p-gpmnmx01:
/* ----------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
 ------------------------------------------------------------------*/
   define input parameter l_warning like mfc_logical no-undo.

   {gprun.i ""gpmnmx01.p""
      "(l_warning,
        yes,
        min_price,
        max_price,
        1,
        no,
        sod_det.sod_nbr,
        sod_det.sod_line,
        yes,
        output minmaxerr,
        output minerr,
        output maxerr,
        input-output sod_det.sod_list_pr,
        input-output sod_det.sod_price)"}
/*GUI*/ if global-beam-me-up then undo, leave.


END PROCEDURE.

PROCEDURE check-order-modifiers:
/* ----------------------------------------------------------------
   Purpose:     Checks the order modifiers for EMT orders of
   type 02 or 03
   Parameters:  warning
   Notes:       Added with ECO *L18P* for compile size
 ----------------------------------------------------------------*/
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
         fields(pt_desc1 pt_desc2 pt_fsc_code pt_isb
                pt_lot_ser pt_ord_max pt_ord_min
                pt_ord_mult pt_part pt_pm_code pt_price
                pt_promo pt_ship_wt pt_ship_wt_um pt_um)
         where pt_part = sod_det.sod_part no-lock:
            if  ( (pt_ord_max <> 0  and sod_det.sod_qty_ord > pt_ord_max)
               or (pt_ord_min <> 0  and sod_det.sod_qty_ord < pt_ord_min)
               or (pt_ord_mult <> 0
               and sod_det.sod_qty_ord modulo pt_ord_mult <> 0) )
            then
               l-warning = yes.
      end. /* FOR FIRST pt_mstr */

END PROCEDURE. /* check-order-modifiers */

PROCEDURE pGetReservedLocationInventory:
/* ----------------------------------------------------------------
  Purpose:     Determine if there is any reserved location inventory
  Parameters:
  Notes:
 ------------------------------------------------------------------*/

   if so_mstr.so_fsm_type = "" then do:
      {gprun.i ""sorlavla.p"" "(input sod_det.sod_site,
                                input sod_part,
                                input so_ship,
                                input so_bill,
                                input so_cust,
                                output resv-loc-avail,
                                output resv-loc-oh)" }
/*GUI*/ if global-beam-me-up then undo, leave.

      qty_avl = qty_avl + resv-loc-avail.
   end.  /* so_fsm_type = "" */

END PROCEDURE. /* PROCEDURE pGetReservedLocationInventory */

PROCEDURE p-check-atp:
/* Check for ATP Enforcement */

   assign
     atp-ok = yes
     atp-due-date = ?.

   /* Switch to the Inventory site's database  */
   {gprun.i ""gpalias2.p"" "(sod_det.sod_site,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.


   /* Validate ATP  */
   if sod_qty_ord - sod_qty_ship > 0
   and not sod_sched
   and not (s-btb-so = yes and sod_btb_type > "01")
   then do:
      hide frame c no-pause.
      hide frame a no-pause.

      {gprun.i ""soatpck.p""
               "(input so_mstr.so_cust,
                 input so_ship,
                 input so_bill,
                 input sod_nbr,
                 input sod_line,
                 input sod_site,
                 input sod_part,
                 input sod_due_date,
                 input sod_um_conv,
                 input sod_um,
                 input (sod_qty_ord - sod_qty_ship),
                 input sod_btb_type,
                 input sod_confirm,
                 input no,
                 input soc_ctrl.soc_atp_enabled,
                 input soc_horizon,
                 input sod_type,
                 input sod_consume,
                 input sngl_ln,
                 input useApoAtp,
                 input moduleGroup,
                 input apoAtpDelAvail,
                 input apoAtpDelAvailMsg,
                 output atp-ok,
                 output atp-due-date,
                 output atp-cum-qty,
                 output atp-site,
                 output errorResult,
                 output continue,
                 output stdAtpUsed)"}
/*GUI*/ if global-beam-me-up then undo, leave.


       /* If Standard Atp enforcement was used,  */
       /* No Apo Atp checks should be done.      */
       if stdAtpUsed then useApoAtp = no.

       view frame a.
       view frame c.

   end.  /* if sod_qty_ord > 0... */

   /* Switch back to the sales order db */
   {gprun.i ""gpalias3.p"" "(so_db,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.


   /* Change due date if date returned */
   if atp-due-date <> ? then do:
      sod_due_date = atp-due-date.
   end.

END PROCEDURE. /* P-check-atp  */

/*  Calculate promise or due date  */
PROCEDURE p-calc-default-date:

   define input parameter p-cust like cm_addr     no-undo.
   define input parameter p-site like pt_site     no-undo.
   define input-output parameter p-due-date
                           like sod_due_date      no-undo.
   define input-output parameter p-promise-date
                           like sod_promise_date  no-undo.

   /* Attempt to calculate promise date now... */
   /* Retrieve address record of ship-to customer */
   for first ad_mstr
      fields (ad_addr
              ad_ctry
              ad_state
              ad_city)
   where ad_addr = p-cust no-lock:

      for first si_mstr
         fields(si_site si_db)
      where si_site = p-site
      no-lock:
         /* Switch to the Inventory site */
         {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.



         {gprun.i ""sopromdt.p""
                  "(input p-site,
                    input ad_ctry,
                    input ad_state,
                    input ad_city,
                    input """",
                    input-output p-due-date,
                    input-output p-promise-date)" }
/*GUI*/ if global-beam-me-up then undo, leave.


         /* Switch back to the sales order site */
         {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.


      end. /* FOR FIRST si_mstr */
   end. /* For first ad_mstr */

END PROCEDURE.   /* p-calc-default-date */

/* Calculate promise and due date defaults for new line */
PROCEDURE p-calc-date-defaults:

   define input parameter p-cust like cm_addr     no-undo.
   define input parameter p-site like pt_site     no-undo.
   define input parameter p-required-date
                          like sod_req_date  no-undo.
   define input-output parameter p-promise-date
                           like sod_promise_date  no-undo.
   define input-output parameter p-due-date
                           like sod_due_date      no-undo.
   /* See if due date qualifies to be recalculated.     */
   /* Recalc if:                                        */
   /*  p-due-date <> ? and                              */
   /*  p-due-date = today + soc_shp_lead (assume this   */
   /*                       was defaulted from header)  */
   if p-due-date <> ? then do:
      if p-due-date = today + soc_ctrl.soc_shp_lead
         then p-due-date = ?.
   end.

   /* If promise <> ? and due <> ? the no defaulting */
   if p-due-date <> ? and p-promise-date <> ? then leave.

   /* If promise = ? and due <> ? then               */
   /*  calc promise date from due date now...        */
   if p-promise-date = ? and p-due-date <> ? then do:
      run p-calc-default-date (input p-cust,
                               input p-site,
                               input-output p-due-date,
                               input-output p-promise-date).
      leave.
   end. /* calculate promise date... */

   /* If promise = <> ? and due = ? then               */
   /*  calc due date from promise date now...          */
   if p-promise-date <> ? and p-due-date = ? then do:
      run p-calc-default-date (input p-cust,
                               input p-site,
                               input-output p-due-date,
                               input-output p-promise-date).
      leave.
   end. /* calculate due date... */

   /* If promise = ? and due = ?              */
   if p-promise-date = ? and p-due-date = ? then do:

      /* if required date present,  then... */
      if p-required-date <> ? then do:
         /* 1. Default Promise date from Required date */
         p-promise-date = p-required-date.

         /* 2. Attempt to calculate due date from promise date now */
         run p-calc-default-date (input p-cust,
                                  input p-site,
                                  input-output p-due-date,
                                  input-output p-promise-date).
         /* 3. if due not calculated, default to required date */
         if p-due-date = ? then p-due-date = p-required-date.
         leave.
      end. /* p-required-date <> ? */
      /* p-required-date = ? */
      else do:
         /* 1. due date = today + shipping lead time        */
         p-due-date = today + soc_ctrl.soc_shp_lead.
         /* 2. calc promise date from due date now...        */
         run p-calc-default-date (input p-cust,
                                  input p-site,
                                  input-output p-due-date,
                                  input-output p-promise-date).
         leave.
      end. /* p-required-date = ? */
   end. /* promise = ? and due = ?   */
END PROCEDURE.   /* P-calc-date-defaults */


PROCEDURE getBestListPrice:
   if best_list_price = 0 then do:

      if not available wkpi_wkfl then do:

         if available pt_mstr then do:

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input base_curr,
                 input so_mstr.so_curr,
                 input so_ex_rate2,
                 input so_ex_rate,
                 input (pt_price * sod_det.sod_um_conv),
                 input false,
                 output best_list_price,
                 output mc-error-number)"}

            if mc-error-number <> 0 then
               run p-mfmsg (input mc-error-number, input 2).

            /*CREATE LIST TYPE PRICE LIST RECORD IN wkpi_wkfl*/
            {gprun.i ""gppiwkad.p""
               "(sod_um, sobparent, sobfeature, sobpart,
                 ""4"", ""1"", best_list_price, 0, no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end. /* if available pt_mstr */
         else do:
            /*CREATE LIST TYPE PRICE LIST RECORD IN wkpi_wkfl
            FOR MEMO TYPE*/
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
END PROCEDURE.   /* getBestListPrice */



PROCEDURE updateRMAWorkfile:
   if ((save_parent_list <> sod_det.sod_list_pr) or
       (save_um <> sod_um)) and save_qty_ord <> 0
   then do:

      {gprun.i ""gppiqty2.p""
         "(sod_line,
           sod_part,
           - save_qty_ord,
           - (save_qty_ord * save_parent_list),
           save_um,
           yes,
           yes,
           yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      {gprun.i ""gppiqty2.p""
         "(sod_line,
           sod_part,
           sod_qty_ord,
           sod_qty_ord * sod_list_pr,
           sod_um,
           yes,
           yes,
           yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   end. /* (save_um <> sod_um)) AND save_qty_ord <> 0 THEN DO: */
   else do:
      {gprun.i ""gppiqty2.p""
         "(sod_line,
           sod_part,
           sod_qty_ord - save_qty_ord,
           (sod_qty_ord - save_qty_ord) * sod_list_pr,
           sod_um,
           yes,
           yes,
           yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end. /* ELSE DO: */

END PROCEDURE.   /* updateRMAWorkfile */

PROCEDURE p-reason-code:
/* PROMPT FOR A REASON CODE IF ANY SOD FIELDS NEED TO BE */
/* TRACKED UPON DELETE REASON CODES WITH A TYPE OF       */
/* ORD_CHG MUST EXIST IN ORDER FOR A REASON CODE AND     */
/* COMMENT TO BE ENTERED.                                */

   if can-find(first rsn_ref where rsn_type = "ord_chg") then do:
      update reason-code reason-comment with frame rsn.
      if reason-code <> "" or reason-comment then do:
         if not can-find(first rsn_ref where
            rsn_code = reason-code and rsn_type = "ord_chg") then do:
            /* Invalid Reason Code */
            {pxmsg.i &MSGNUM=655 &ERRORLEVEL=3 &MSGARG1=reason-code}
            next-prompt reason-code with frame rsn.
            undo, retry.
         end. /* IF NOT CAN-FIND FIRST rsn_ref */

         if reason-comment then do:
            hide frame line_pop no-pause.
            hide frame bom.
            hide frame c no-pause.
            hide frame d no-pause.
            hide frame rsn no-pause.
            global_type = " ".
            global_ref = so_mstr.so_nbr.
            assign cmtindx = tr-cmtindx.

            {gprun.i ""gpcmmt01.p"" "(input """")"}
/*GUI*/ if global-beam-me-up then undo, leave.

            assign tr-cmtindx = cmtindx.

            view frame c.
            view frame d.
         end. /* IF REASN-COMMENT */
         else
            hide frame rsn.

       end. /* IF RSN_CODE <> "" */
       else
          hide frame rsn.

   end. /* IF CAN-FIND FIRST RSN_REF*/
END PROCEDURE.  /*P-REASON-CODE */

PROCEDURE confirmOrder:
/* ---------------------------------------------------------------------------
Purpose:       This procedure runs the logic for confirmed order lines.
Exceptions:    None
Conditions:
Pre:
Post:
Notes:
History:
----------------------------------------------------------------------------*/

   define variable apoMessageNumber as integer no-undo.
   define variable pApoDemandId      as character no-undo.

   {gprun.i  ""xxsosomtu1.p""
         "(input reason-code,
           input tr-cmtindx)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   if confirmApoAtpOrderLine then do:
      {pxrun.i &proc='buildDemandId' &program='giapoxr.p'
         &handle=ph_giapoxr
         &param=("input so_mstr.so_nbr,
                  input sod_det.sod_line,
                  input sod_det.sod_site,
                  output pApoDemandId")
         &module='GI1'}
      {pxrun.i &proc='confirmDemandRecord' &program='giapoxr.p'
         &handle=ph_giapoxr
         &param=("input sod_det.sod_site,
                  input sod_det.sod_part,
                  input pApoDemandId,
                  output apoMessageNumber")
         &catcherror=TRUE
         &noapperror=TRUE
         &module='GI1'}
      if return-value <> {&SUCCESS-RESULT} then do:
        {pxmsg.i &MSGNUM=apoMessageNumber &MSGARG1=pApoDemandId
                 &ERRORLEVEL={&WARNING-RESULT}}
      end.
      confirmApoAtpOrderLine = yes.
   end.
END PROCEDURE. /*confirmOrder*/

PROCEDURE updateWithApoAtpData:
/* ---------------------------------------------------------------------------
Purpose:       This procedure updates site, date and quantity
               returned from apo atp.
               This is for multi line processing only.
Exceptions:    None
Conditions:
Pre:
Post:
Notes:
History:
----------------------------------------------------------------------------*/

   if atp-qty-site-changed then do:
      assign
         sod_det.sod_site     = atp-site
         sod_det.sod_qty_ord  = atp-cum-qty.
   end.

   /* When errorResult = ""  then      */
   /* no changes were made by APO ATP  */

   if stdAtpUsed = no and errorResult <> "" then do:
      assign
         sod_site     = atp-site
         sod_due_date = atp-due-date
         sod_qty_ord  = atp-cum-qty.
   end. /* stdAtpUsed = no and errorResult <> "" */

END PROCEDURE. /* updateWithApoAtpData */

PROCEDURE setUpForApoAtp:
/* ---------------------------------------------------------------------------
Purpose:       This procedure determines APO ATP should be used.
               If it is in use then open io stream used for APO ATP.
Exceptions:    None
Conditions:
Pre:
Post:
Notes:
History:
----------------------------------------------------------------------------*/

   if this-is-rma then moduleGroup = "RMA".
   else moduleGroup = "SO".

   /* Get Apo Atp setup only if standard Atp is not used. */
   /* If standard Atp is used and the setup is run,       */
   /* useApoAtp will be set incorrectly.                  */
   if stdAtpUsed =no then do:
   /* Determine if Apo Atp is in Use */
      {pxrun.i &proc='getApoAtpSetup' &program='sosoxr1.p'
            &handle=ph_sosoxr1
            &param="(input sod_det.sod_site,
                     input sod_part,
                     input sod_confirm,
                     input sod_type,
                     input sod_btb_type,
                     input sod_due_date,
                     input sod_qty_ord,
                     input sod_um_conv,
                     input moduleGroup,
                     input new_line,
                     input prev_confirm,
                     output checkAtp,
                     output useApoAtp,
                     output apoAtpDelAvail,
                     output apoAtpDelAvailMsg)"}
   end.

   if checkAtp and useApoAtp then do:
   /* After a new order line has been entered or an existing line      */
   /* is modified where the confirm flag is changed from no to yes     */
   /* then initialize Apo Atp values based on order line.              */

      assign atp-site = sod_det.sod_site
         atp-cum-qty = sod_qty_ord
         atp-due-date = sod_due_date.

      if apoAtpDelAvail then do:
      /* A Shared Stream cannot be used with app server logic */
      /* Open the apoAtpStream */
         {pxrun.i &proc='openApoAtpIOStream' &program='giapoxr.p'
                  &handle=ph_giapoxr
                  &catcherror=TRUE
                  &noapperror=TRUE
                  &module='GI1'}
      end.
   end.  /* checkAtp and useApoAtp */

END PROCEDURE. /* setUpForApoAtp */
PROCEDURE p-calc-translt-days:
   define input parameter p-cust like cm_addr     no-undo.
   define input parameter p-site like pt_site     no-undo.
   define output parameter p-translt-days
                           like sod_translt_days  no-undo.

   /* RETRIEVE ADDRESS RECORD OF SHIP-TO CUSTOMER */
   for first ad_mstr
      fields (ad_addr
              ad_ctry
              ad_state
              ad_city)
   where ad_addr = p-cust no-lock:

      for first si_mstr
         fields(si_site si_db)
      where si_site = p-site
      no-lock:
         /* SWITCH TO THE INVENTORY SITE */
         {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.



         /* INITIALIZE TRANSPORT DAYS FROM          */
         /* DELIVERY TRANSIT LEAD-TIME (2.16.1).    */

         {pxrun.i &PROC='getDefaultTransitLTDays'
                  &PROGRAM='sosoxr.p'
                  &HANDLE=ph_sosoxr
                  &PARAM="(input p-site,
                           input ad_ctry,
                           input ad_state,
                           input ad_city,
                           input """",
                           output p-translt-days)" }

         /* SWITCH BACK TO THE SALES ORDER SITE */
         {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.


      end. /* for first si_mstr */
   end. /* For first ad_mstr */

END PROCEDURE.   /* p-calc-translt-days */
{&SOSOMTLA-P-TAG32}
