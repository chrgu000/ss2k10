/* GUI CONVERTED from sosomt.p (converter v1.78) Fri Oct 29 14:38:08 2004 */
/* sosomt.p   - SALES ORDER MAINTENANCE                                 */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.13 $                                                */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 1.0      LAST MODIFIED: 03/20/86   BY: pml                 */
/* REVISION: 6.0      LAST MODIFIED: 06/29/90   BY: WUG *D043*          */
/* REVISION: 6.0      LAST MODIFIED: 03/20/90   BY: ftb *D007*          */
/* REVISION: 6.0      LAST MODIFIED: 03/21/90   BY: ftb *D011*          */
/* REVISION: 6.0      LAST MODIFIED: 03/22/90   BY: ftb *D013*          */
/* REVISION: 6.0      LAST MODIFIED: 04/16/90   BY: MLB *D021*          */
/* REVISION: 6.0      LAST MODIFIED: 08/09/90   BY: MLB *D055*          */
/* REVISION: 6.0      LAST MODIFIED: 10/19/90   BY: pml *D109*          */
/* REVISION: 6.0      LAST MODIFIED: 11/14/90   BY: MLB *D208*          */
/* REVISION: 6.0      LAST MODIFIED: 12/06/90   BY: MLB *D238*          */
/* REVISION: 6.0      LAST MODIFIED: 01/02/91   BY: dld *D259*          */
/* REVISION: 6.0      LAST MODIFIED: 01/02/91   BY: afs *D308*(rev only)*/
/* REVISION: 6.0      LAST MODIFIED: 03/04/91   BY: afs *D396*(rev only)*/
/* REVISION: 6.0      LAST MODIFIED: 03/08/91   BY: dld *D409*          */
/* REVISION: 6.0      LAST MODIFIED: 04/18/91   BY: afs *D541*          */
/* REVISION: 7.0      LAST MODIFIED: 09/17/91   BY: MLV *F015*          */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*          */
/* REVISION: 6.0      LAST MODIFIED: 10/01/91   BY: afs *D884*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 10/29/91   BY: MLV *F029*          */
/* REVISION: 7.0      LAST MODIFIED: 11/13/91   BY: afs *F038*          */
/* REVISION: 7.0      LAST MODIFIED: 11/14/61   BY: afs *F042*          */
/* REVISION: 6.0      LAST MODIFIED: 11/18/91   BY: afs *D934*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 12/01/91   BY: afs *F039*          */
/* REVISION: 7.0      LAST MODIFIED: 02/04/92   BY: MLV *F150*          */
/* REVISION: 7.0      LAST MODIFIED: 02/21/92   BY: afs *F223*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 03/04/92   BY: tjs *F247*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 03/17/92   BY: tjs *F273*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 03/25/92   BY: tmd *F263*          */
/* REVISION: 7.0      LAST MODIFIED: 03/24/92   BY: dld *F297*          */
/* REVISION: 7.0      LAST MODIFIED: 03/31/92   BY: afs *F338*          */
/* REVISION: 7.0      LAST MODIFIED: 04/02/92   BY: afs *F253*          */
/* REVISION: 7.0      LAST MODIFIED: 04/02/92   BY: dld *F349*          */
/* REVISION: 7.0      LAST MODIFIED: 04/08/92   BY: tmd *F367*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: dld *F358*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 04/10/92   BY: afs *F356*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 04/16/92   BY: dld *F382*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 04/22/92   BY: afs *F420*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 04/22/92   BY: tjs *F421*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 04/30/92   BY: tjs *F463*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 05/06/92   BY: tjs *F470*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 05/11/92   BY: tjs *F444*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 05/29/92   BY: tjs *F504*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: afs *F519*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 06/18/92   BY: tmd *F458*          */
/* REVISION: 7.0      LAST MODIFIED: 06/23/92   BY: afs *F678*          */
/* REVISION: 7.0      LAST MODIFIED: 06/26/92   BY: afs *F676*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 06/26/92   BY: afs *F711*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 06/30/92   BY: tjs *F698*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 07/07/92   BY: tjs *F496*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 07/08/92   BY: tjs *F723*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 07/13/92   BY: tjs *F764*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 07/24/92   BY: tjs *F765*          */
/* REVISION: 7.0      LAST MODIFIED: 07/24/92   BY: tjs *F802*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 07/31/92   BY: tjs *F815*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 07/29/92   BY: emb *F817*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 08/21/92   BY: afs *F862*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 08/24/92   BY: tjs *F835*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 09/17/92   BY: tjs *G035*          */
/* REVISION: 7.3      LAST MODIFIED: 10/06/92   BY: tjs *G129*          */
/* REVISION: 7.3      LAST MODIFIED: 10/07/92   BY: mpp *G013*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247*          */
/* REVISION: 7.3      LAST MODIFIED: 11/03/92   BY: sas *G242*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 11/05/92   BY: afs *G262*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 11/05/92   BY: afs *G244*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 11/18/92   BY: tjs *G191*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 12/08/92   BY: tjs *G391*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 12/17/92   BY: tjs *G454*          */
/* REVISION: 7.3      LAST MODIFIED: 12/21/92   BY: tjs *G456*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 12/31/92   BY: mpp *G484*          */
/* REVISION: 7.3      LAST MODIFIED: 01/12/93   BY: tjs *G507*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 01/13/93   BY: tjs *G522*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 01/15/93   BY: afs *G501*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 01/18/93   BY: tjs *G557*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 01/21/93   BY: tjs *G579*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 01/26/93   BY: bcm *G429*          */
/* REVISION: 7.3      LAST MODIFIED: 01/27/93   BY: tjs *G599*          */
/* REVISION: 7.3      LAST MODIFIED: 02/04/93   BY: bcm *G415*          */
/* REVISION: 7.3      LAST MODIFIED: 02/09/93   BY: tjs *G588*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 02/18/93   BY: afs *G692*          */
/* REVISION: 7.3      LAST MODIFIED: 12/18/92   BY: sas *G457*          */
/* REVISION: 7.3      LAST MODIFIED: 03/09/93   BY: tjs *G789*          */
/* REVISION: 7.3      LAST MODIFIED: 03/16/93   BY: bcm *G823*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 03/23/93   BY: tjs *G858*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 04/05/93   BY: bcm *G889*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 04/08/93   BY: tjs *G830*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 04/16/93   BY: tjs *G911*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 04/19/93   BY: tjs *G948*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 04/20/93   BY: afs *G970*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 04/26/93   BY: bcm *GA36*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 05/17/93   BY: afs *GB06*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 05/20/93   BY: kgs *GA92*          */
/* REVISION: 7.3      LAST MODIFIED: 05/20/93   BY: kgs *GB18*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 05/20/93   BY: kgs *GA60*          */
/* REVISION: 7.3      LAST MODIFIED: 05/21/93   BY: tjs *GA70*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 05/21/93   BY: tjs *G962*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 05/25/93   BY: afs *GB31*          */
/* REVISION: 7.3      LAST MODIFIED: 06/07/93   BY: tjs *GA64*(rev only)*/
/* REVISION: 7.4      LAST MODIFIED: 06/21/93   BY: pcd *H008*          */
/* REVISION: 7.4      LAST MODIFIED: 07/30/93   BY: cdt *H048*          */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*          */
/* REVISION: 7.4      LAST MODIFIED: 09/29/93   BY: tjs *H082*          */
/* REVISION: 7.4      LAST MODIFIED: 09/22/93   BY: cdt *H086*          */
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: bcm *H185*          */
/* REVISION: 7.4      LAST MODIFIED: 10/28/93   BY: dpm *H067*(rev only)*/
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184*          */
/* REVISION: 7.4      LAST MODIFIED: 11/22/93   BY: afs *H238*(rev only)*/
/* REVISION: 7.4      LAST MODIFIED: 01/28/94   BY: afs *GI55*          */
/* REVISION: 7.4      LAST MODIFIED: 04/19/94   BY: WUG *FN46*          */
/* REVISION: 7.4      LAST MODIFIED: 04/21/94   BY: dpm *GJ49*          */
/* REVISION: 7.4      LAST MODIFIED: 05/23/94   BY: afs *FM85*          */
/* REVISION: 7.4      LAST MODIFIED: 05/26/94   BY: afs *GH40*          */
/* REVISION: 7.4      LAST MODIFIED: 06/21/94   BY: qzl *H397*          */
/* REVISION: 7.4      LAST MODIFIED: 07/19/94   BY: qzl *H446*          */
/* REVISION: 7.4      LAST MODIFIED: 08/17/94   BY: dpm *FQ25*          */
/* REVISION: 7.4      LAST MODIFIED: 09/10/94   BY: bcm *GM05*          */
/* REVISION: 7.4      LAST MODIFIED: 09/22/94   BY: jpm *GM78*          */
/* REVISION: 7.4      LAST MODIFIED: 10/20/94   BY: rmh *FQ08*          */
/* REVISION: 7.4      LAST MODIFIED: 10/29/94   BY: bcm *FT06*          */
/* REVISION: 8.5      LAST MODIFIED: 11/28/94   BY: mwd *J034*          */
/* REVISION: 7.4      LAST MODIFIED: 01/12/95   BY: ais *F0C7*          */
/* REVISION: 8.5      LAST MODIFIED: 02/23/95   BY: dpm *J044*          */
/* REVISION: 8.5      LAST MODIFIED: 03/02/95   BY: DAH *J042*          */
/* REVISION: 8.5      LAST MODIFIED: 03/13/95   BY: jlf *J042*          */
/* REVISION: 7.4      LAST MODIFIED: 03/15/95   BY: WUG *G0CW*          */
/* REVISION: 7.4      LAST MODIFIED: 04/06/95   BY: rxm *G0K8*          */
/* REVISION: 7.4      LAST MODIFIED: 05/01/95   BY: vrn *F0R2*          */
/* REVISION: 7.4      LAST MODIFIED: 05/02/95   BY: jxz *G0LS*          */
/* REVISION: 7.4      LAST MODIFIED: 10/23/95   BY: ais *G19P*          */
/* REVISION: 7.4      LAST MODIFIED: 12/07/95   BY: rxm *H0FS*          */
/* REVISION: 7.4      LAST MODIFIED: 02/05/96   BY: ais *G0NX*          */
/* REVISION: 8.5      LAST MODIFIED: 02/21/96   BY: taf *J053*          */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: *J04C* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: *J0HR* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: *J12Q* Andy Wasilczuk*/
/* REVISION: 8.6      LAST MODIFIED: 06/03/97   BY: *K0DQ* Taek-Soo Chang */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00L* EvdGevel REV ONLY */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 12/14/99   BY: *N05D* Steve Nugent      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* $Revision: 1.13 $    BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002*  */
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 09/27/12  ECO: *SS-20120927.1*   */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* DISPLAY TITLE */
{mfdtitle.i "120927.1"}

/* CHANGES MADE TO THIS PROGRAM MAY ALSO NEED TO BE */
/* MADE TO PROGRAM fseomt.p.                        */

{etdcrvar.i "new"}
{etvar.i &new="new"}
{etrpvar.i &new="new"}

/*!

With J04C, Sales Orders and RMAs are maintained in common code.  Sosomt.p
and fsrmamt.p both call sosomt1.p for their processing.  The one input
parameter to sosomt1.p tells it whether RMA's or SO's are being maintained.

*/

pause 0.

/* THE INPUT PARAMETER TO SOSOMT1.P, NO, MEANS, "NO, THIS IS    */
/* NOT AN RMA" TO THAT PROGRAM.                                 */

/* *SS-20120927.1*    {gprun.i  ""sosomt1.p""  
   "(input no)"}    */ 

/* *SS-20120927.1*  */  {gprun.i  ""yysosomt1.p""  
   "(input no)"}    

/*GUI*/ if global-beam-me-up then undo, leave.

