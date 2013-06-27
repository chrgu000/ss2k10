/* soivmt.p - INVOICE MAINTENANCE                                             */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* REVISION: 1.0      LAST MODIFIED: 08/31/86   BY: pml *17*                  */
/* REVISION: 6.0      LAST MODIFIED: 03/22/90   BY: ftb *D013*                */
/* REVISION: 6.0      LAST MODIFIED: 03/22/90   BY: ftb *D007*                */
/* REVISION: 6.0      LAST MODIFIED: 04/05/90   BY: ftb *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 06/29/90   BY: WUG *D043*                */
/* REVISION: 6.0      LAST MODIFIED: 08/16/90   BY: MLB *D055*                */
/* REVISION: 6.0      LAST MODIFIED: 10/17/90   BY: pml *D109*                */
/* REVISION: 6.0      LAST MODIFIED: 12/11/90   BY: MLB *D238*                */
/* REVISION: 6.0      LAST MODIFIED: 01/02/91   BY: dld *D259*                */
/* REVISION: 6.0      LAST MODIFIED: 01/19/91   BY: dld *D316*                */
/* REVISION: 6.0      LAST MODIFIED: 02/13/91   BY: afs *D348*(rev only)      */
/* REVISION: 6.0      LAST MODIFIED: 03/08/91   BY: dld *D409*                */
/* REVISION: 6.0      LAST MODIFIED: 03/18/91   BY: MLB *D443*                */
/* REVISION: 6.0      LAST MODIFIED: 06/18/91   BY: emb *D710*                */
/* REVISION: 6.0      LAST MODIFIED: 07/07/91   BY: afs *D747*(rev only)      */
/* REVISION: 6.0      LAST MODIFIED: 07/08/91   BY: afs *D751*(rev only)      */
/* REVISION: 6.0      LAST MODIFIED: 07/13/91   BY: afs *D767*                */
/* REVISION: 6.0      LAST MODIFIED: 08/14/91   BY: MLV *D825*                */
/* REVISION: 7.0      LAST MODIFIED: 09/17/91   BY: MLV *F015*                */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*                */
/* REVISION: 7.0      LAST MODIFIED: 10/29/91   BY: MLV *F029*                */
/* REVISION: 6.0      LAST MODIFIED: 11/14/91   BY: afs *D928*                */
/* REVISION: 7.0      LAST MODIFIED: 11/16/91   BY: pml *F048*                */
/* REVISION: 7.0      LAST MODIFIED: 01/16/92   BY: afs *F038*                */
/* REVISION: 7.0      LAST MODIFIED: 01/17/92   BY: afs *F039*                */
/* REVISION: 7.0      LAST MODIFIED: 01/18/92   BY: afs *F042*                */
/* REVISION: 7.0      LAST MODIFIED: 02/13/92   BY: tjs *F191*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 03/02/92   BY: tjs *F247*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 03/18/92   BY: tjs *F273*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 03/22/92   BY: TMD *F263*                */
/* REVISION: 7.0      LAST MODIFIED: 03/25/92   BY: dld *F297*                */
/* REVISION: 7.0      LAST MODIFIED: 03/31/92   BY: afs *F338*                */
/* REVISION: 7.0      LAST MODIFIED: 04/01/92   BY: afs *F344*                */
/* REVISION: 7.0      LAST MODIFIED: 04/02/92   BY: afs *F253*                */
/* REVISION: 7.0      LAST MODIFIED: 04/02/92   BY: dld *F349*                */
/* REVISION: 7.0      LAST MODIFIED: 04/08/92   BY: tmd *F367*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: dld *F358*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 04/10/92   BY: afs *F356*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 04/22/92   BY: tjs *F421*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 04/30/92   BY: tjs *F463*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 05/06/92   BY: tjs *F470*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 05/11/92   BY: afs *F471*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 05/22/92   BY: tjs *F444*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 06/05/92   BY: tjs *F504*                */
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: afs *F519*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 06/18/92   BY: tmd *F458*                */
/* REVISION: 7.0      LAST MODIFIED: 06/26/92   BY: afs *F676*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 06/26/92   BY: afs *F711*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 06/30/92   BY: tjs *F646*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 06/30/92   BY: tjs *F698*                */
/* REVISION: 7.0      LAST MODIFIED: 07/07/92   BY: tjs *F496*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 07/09/92   BY: tjs *F739*                */
/* REVISION: 7.0      LAST MODIFIED: 07/14/92   BY: tjs *F764*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 07/24/92   BY: tjs *F765*                */
/* REVISION: 7.0      LAST MODIFIED: 07/24/92   BY: tjs *F802*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 07/31/92   BY: tjs *F815*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 08/21/92   BY: afs *F862*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 08/24/92   BY: tjs *F859*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 08/24/92   BY: tjs *F835*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 09/04/92   BY: afs *G056*                */
/* REVISION: 7.3      LAST MODIFIED: 09/17/92   BY: tjs *G035*                */
/* REVISION: 7.3      LAST MODIFIED: 09/30/92   BY: tjs *G112*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 10/06/92   BY: tjs *G129*                */
/* REVISION: 7.3      LAST MODIFIED: 10/21/92   BY: afs *G219*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247*                */
/* REVISION: 7.3      LAST MODIFIED: 11/05/92   BY: afs *G244*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 11/16/92   BY: tjs *G318*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 01/04/92   BY: tjs *G456*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 12/01/92   BY: mpp *G484*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 01/07/93   BY: tjs *G507*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 01/13/93   BY: tjs *G530*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 01/15/93   BY: afs *G501*                */
/* REVISION: 7.3      LAST MODIFIED: 01/21/93   BY: tjs *G579*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 01/26/93   BY: bcm *G429*                */
/* REVISION: 7.3      LAST MODIFIED: 02/01/93   BY: tjs *G588*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 02/10/93   BY: bcm *G416*                */
/* REVISION: 7.3      LAST MODIFIED: 02/18/93   BY: afs *G692*                */
/* REVISION: 7.3      LAST MODIFIED: 02/25/93   BY: sas *G457*                */
/* REVISION: 7.3      LAST MODIFIED: 03/16/93   BY: bcm *G823*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 03/23/93   BY: tjs *G858*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 04/05/93   BY: bcm *G889*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 04/15/93   BY: tjs *G948*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 04/20/93   BY: afs *G970*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 05/20/93   BY: kgs *GA92*                */
/* REVISION: 7.3      LAST MODIFIED: 05/20/93   BY: kgs *GB18*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 05/20/93   BY: kgs *GA60*                */
/* REVISION: 7.3      LAST MODIFIED: 05/28/93   BY: kgs *GB31*                */
/* REVISION: 7.3      LAST MODIFIED: 06/14/93   BY: afs *GC26*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 06/18/93   BY: bcm *GC50*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 06/22/93   by: cdt *GC58*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 07/01/93   by: cdt *GC90*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 07/09/93   by: bcm *GA70*(rev only)      */
/* REVISION  7.4      LAST MODIFIED  06/07/93   BY: skk *H002*(soivtrl2)      */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*                */
/* REVISION: 7.4      LAST MODIFIED: 10/04/93   BY: dpm *H075*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 09/27/93   BY: cdt *H086*                */
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: bcm *H185*                */
/* REVISION: 7.4      LAST MODIFIED: 10/27/93   BY: dpm *H067*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184*                */
/* REVISION: 7.4      LAST MODIFIED: 11/22/93   BY: afs *H238*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 01/28/94   BY: afs *GI55*                */
/* REVISION: 7.4      LAST MODIFIED: 02/24/94   BY: cdt *H282*                */
/* REVISION: 7.4      LAST MODIFIED: 04/21/94   BY: dpm *GJ49*                */
/* REVISION: 7.4      LAST MODIFIED: 05/17/94   BY: dpm *FN83*                */
/* REVISION: 7.4      LAST MODIFIED: 05/23/94   BY: afs *FM85*                */
/* REVISION: 7.4      LAST MODIFIED: 05/26/94   BY: afs *GH40*                */
/* REVISION: 7.4      LAST MODIFIED: 09/10/94   BY: bcm *GM05*                */
/* REVISION: 7.4      LAST MODIFIED: 10/10/94   BY: ljm *GN23*                */
/* REVISION: 7.4      LAST MODIFIED: 10/21/94   BY: rmh *FQ08*                */
/* REVISION: 7.4      LAST MODIFIED: 10/29/94   BY: bcm *FT06*                */
/* REVISION: 8.5      LAST MODIFIED: 12/03/94   BY: mwd *J034*                */
/* REVISION: 7.4      LAST MODIFIED: 01/12/95   BY: ais *F0C7*                */
/* REVISION: 8.5      LAST MODIFIED: 02/10/95   BY: dpm *J044*                */
/* REVISION: 7.4      LAST MODIFIED: 02/15/95   BY: rxm *G0F4*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 7.4      LAST MODIFIED: 04/06/95   BY: rxm *G0K8*                */
/* REVISION: 8.5      LAST MODIFIED: 04/11/95   BY: DAH *J042*                */
/* REVISION: 8.5      LAST MODIFIED: 07/14/95   BY: taf *J053*                */
/* REVISION: 7.4      LAST MODIFIED: 02/05/96   BY: ais *G0NX*                */
/* REVISION: 8.5      LAST MODIFIED: 03/12/96   BY: GWM *J0F8*                */
/* REVISION: 8.5      LAST MODIFIED: 04/10/96   BY: DAH *J0HR*                */
/* REVISION: 8.5      LAST MODIFIED: 04/17/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 04/17/96   BY: *J04C* Markus Barone      */
/* REVISION: 8.5      LAST MODIFIED: 04/29/96   BY: *J0KJ* Dennis Hensen      */
/* REVISION: 8.5      LAST MODIFIED: 07/02/96   BY: *J0WF* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 08/01/96   BY: *J0ZZ* T. Farnsworth      */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: aal *K001*                */
/* REVISION: 8.5      LAST MODIFIED: 08/02/96   BY: *J12Q* Andy Wasilczuk     */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Elke Van Maele     */
/* REVISION: 8.6      LAST MODIFIED: 03/12/97   BY: *K07K* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 05/02/97   BY: *J1QH* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 06/03/97   BY: *K0DQ* Taek-Soo Chang     */
/* REVISION: 8.6      LAST MODIFIED: 08/06/97   BY: *J1YG* Seema Varma        */
/* REVISION: 8.6      LAST MODIFIED: 08/27/97   BY: *K0HN* Jean Miller        */
/* REVISION: 8.6      LAST MODIFIED: 11/18/97   BY: *J25B* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 11/18/97   BY: *K1BG* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 12/16/97   BY: *H1HF* Niranjan Ranka     */
/* REVISION: 8.6      LAST MODIFIED: 01/16/98   BY: *J25N* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 01/26/98   BY: *J29R* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 01/31/98   BY: *J2D7* Niranjan Ranka     */
/* REVISION: 8.6      LAST MODIFIED: 01/31/98   BY: *J2BC* Aruna Patil        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 04/27/98   BY: *L00L* Adam Harris        */
/* REVISION: 8.6E     LAST MODIFIED: 05/06/98   BY: *J2DD* Kawal Batra        */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 06/05/98   BY: *L01M* Jean Miller        */
/* REVISION: 8.6E     LAST MODIFIED: 06/24/98   BY: *L01G* Robin McCarthy     */
/* REVISION: 8.6E     LAST MODIFIED: 07/09/98   BY: *J2Q9* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 07/01/98   BY: *L024* Sami Kureishy      */
/* REVISION: 9.0      LAST MODIFIED: 11/17/98   BY: *H1LN* Poonam Bahl        */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* Sandy Brown        */
/* REVISION: 9.0      LAST MODIFIED: 12/15/98   BY: *J34F* Vijaya Pakala      */
/* REVISION: 9.0      LAST MODIFIED: 12/16/98   BY: *J2ZM* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 07/09/99   BY: *J3J0* G.Latha            */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney     */
/* REVISION: 9.1      LAST MODIFIED: 09/08/99   BY: *N02P* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 10/19/99   BY: *N04X* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 10/27/99   BY: *N03P* Mayse Lai          */
/* REVISION: 9.1      LAST MODIFIED: 11/02/99   BY: *N04P* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Luke Pokic         */
/* REVISION: 9.1      LAST MODIFIED: 02/16/00   BY: *N06R* Denis Tatarik      */
/* REVISION: 9.1      LAST MODIFIED: 04/21/00   BY: *N09J* Denis Tatarik      */
/* REVISION: 9.1      LAST MODIFIED: 05/07/00   BY: *N09G* Luke Pokic         */
/* REVISION: 9.1      LAST MODIFIED: 05/13/00   BY: *N0B4* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 06/05/00   BY: *N0CZ* John Pison         */
/* REVISION: 9.1      LAST MODIFIED: 06/14/00   BY: *L0Y4* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 07/01/00   BY: *N0DX* BalbeerS Rajput    */
/* REVISION: 9.1      LAST MODIFIED: 07/06/00   BY: *N0F0* Arul Victoria      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/03/00   BY: *L14Q* Abhijeet Thakur    */
/* REVISION: 9.1      LAST MODIFIED: 11/19/00   BY: *M0WC* Rajesh Thomas      */
/* REVISION: 9.1      LAST MODIFIED: 11/30/00   BY: *L15Z* Veena Lad          */
/* REVISION: 9.1      LAST MODIFIED: 12/18/00   BY: *M0TZ* Veena Lad          */
/* REVISION: 9.1      LAST MODIFIED: 10/09/00   BY: *N0WW* Mudit Mehta        */
/* Revision: 1.77          BY: Katie Hilbert      DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.78          BY: Ellen Borden       DATE: 07/06/01  ECO: *P007* */
/* Revision: 1.79          BY: Jean Miller        DATE: 07/06/01  ECO: *M11Z* */
/* Revision: 1.80          BY: Jeff Wootton       DATE: 09/21/01  ECO: *P01H* */
/* Revision: 1.81          BY: Vivek Dsilva       DATE: 02/05/02  ECO: *N18S* */
/* Revision: 1.82          BY: Santhosh Nair      DATE: 03/05/02  ECO: *M1H1* */
/* Revision: 1.83          BY: Rajesh Kini        DATE: 03/14/02  ECO: *M1WN* */
/* Revision: 1.84          BY: Ashish Maheshwari  DATE: 05/14/02  ECO: *P06M* */
/* Revision: 1.85          BY: Ashish Maheshwari  DATE: 05/20/02  ECO: *P04J* */
/* Revision: 1.87          BY: Dave Caveney       DATE: 05/30/02  ECO: *P042* */
/* Revision: 1.88          BY: Robin McCarthy     DATE: 07/03/02  ECO: *P08Q* */
/* Revision: 1.89          BY: Robin McCarthy     DATE: 07/15/02  ECO: *P0BJ* */
/* Revision: 1.90          BY: John Corda         DATE: 08/09/02  ECO: *N1QP* */
/* Revision: 1.91          BY: Dipesh Bector      DATE: 01/14/03  ECO: *M21Q* */
/* Revision: 1.92          BY: Katie Hilbert      DATE: 01/31/03  ECO: *P0MJ* */
/* Revision: 1.93          BY: Robin McCarthy     DATE: 02/28/03  ECO: *P0M9* */
/* Revision: 1.94          BY: Dorota Hohol       DATE: 03/06/03  ECO: *P0N6* */
/* Revision: 1.95          BY: Narathip W.        DATE: 05/08/03  ECO: *P0RL* */
/* Revision: 1.97          BY: Paul Donnelly (SB) DATE: 06/28/03  ECO: *Q00L* */
/* Revision: 1.98          BY: Kirti Desai        DATE: 10/14/03  ECO: *P165* */
/* Revision: 1.99          BY: Veena Lad          DATE: 10/22/03  ECO: *P160* */
/* Revision: 1.101         BY: Veena Lad          DATE: 02/03/04  ECO: *P1M6* */
/* Revision: 1.102         BY: Vinay Soman        DATE: 02/26/04  ECO: *P1QB* */
/* Revision: 1.103         BY: Veena Lad          DATE: 03/03/04  ECO: *Q064* */
/* Revision: 1.104         BY: Katie Hilbert      DATE: 03/09/04  ECO: *Q06B* */
/* Revision: 1.105         BY: Laxmikant Bondre   DATE: 05/10/04  ECO: *P20V* */
/* Revision: 1.106         BY: Shivanand H        DATE: 06/22/04  ECO: *P25X* */
/* Revision: 1.107         BY: SurenderSingh N.   DATE: 01/12/05  ECO: *P322* */
/* Revision: 1.107.1.1     BY: Gaurav Kerkar      DATE: 07/18/05  ECO: *P3T8* */
/* Revision: 1.107.1.2     BY: Jean Miller        DATE: 06/26/06  ECO: *Q066* */
/* Revision: 1.107.1.3     BY: Sanat Paul         DATE: 05/15/07  ECO: *P4LG* */
/* Revision: 1.107.1.4     BY: Antony LejoS       DATE: 06/11/07  ECO: *P5T1* */
/* $Revision: 1.107.1.5 $           BY: Anju Dubey         DATE: 08/13/07  ECO: *P64F* */
/*-Revision end---------------------------------------------------------------*/
/* SS - 130624.1 RNB
【 130624.1 】
 1.订单明细项的ENTITY与订单头的ENTITY不符不允许继续(用site确认)
【 130624.1 】
SS - 130624.1 - RNE */
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

/*V8:ConvertMode=Maintenance                                                  */

/* DISPLAY TITLE */
{mfdtitle.i "130624.1"}
{cxcustom.i "SOIVMT.P"}
{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */

{gldydef.i new}
{gldynrm.i new}

{etvar.i &new="new"}
{etdcrvar.i "new"}
{etrpvar.i &new="new"}

{&SOIVMT-P-TAG5}
define new shared variable rndmthd       like rnd_rnd_mthd.
define new shared variable oldcurr       like so_curr.
define new shared variable line          like sod_line.
define new shared variable del-yn        like mfc_logical.
define new shared variable qty_req       like in_qty_req.
define new shared variable qty_all       like in_qty_all.
define new shared variable prev_due      like sod_due_date.
define new shared variable prev_qty_ord  like sod_qty_ord.
define new shared variable trnbr         like tr_trnbr.
define new shared variable qty           as decimal.
define new shared variable part          as character format "x(18)".
define new shared variable eff_date      as date.
define new shared variable all_days      like soc_all_days.
define new shared variable all_avail     like soc_all_avl.
define new shared variable ln_fmt        like soc_ln_fmt.
define new shared variable ref           like glt_det.glt_ref.
define new shared variable so_recno      as recid.
define new shared variable comp          like ps_comp.
define new shared variable trlot         like tr_lot.
define new shared variable cmtindx       like cmt_indx.
define new shared variable sonbr         like so_nbr.
define new shared variable socmmts       like soc_hcmmts label "Comments".
define new shared variable perform_date  as date label "Perform Date".
define new shared variable base_amt      like ar_amt.
define new shared variable cm_recno      as recid.
define new shared variable new_order     like mfc_logical initial no.
define new shared variable sotax_trl     like tax_trl.
define new shared variable tax_in        like cm_tax_in.
define new shared variable exch_rate     like exr_rate.
define new shared variable exch_rate2    like exr_rate2.
define new shared variable exch_ratetype like exr_ratetype.
define new shared variable exch_exru_seq like exru_seq.
define new shared variable so_db         like dc_name.
define new shared variable inv_db        like dc_name.
define new shared variable mult_slspsn   like mfc_logical no-undo.
define new shared variable tax_recno     as recid.
define new shared variable ad_recno      as recid.
define new shared variable ship2_addr    like so_ship.
define new shared variable ship2_pst_id  like cm_pst_id.
define new shared variable ship2_lang    like cm_lang.
define new shared variable ship2_ref     like cm_addr.
define new shared variable undo_taxc     like mfc_logical.
define new shared variable undo_cust     like mfc_logical.
define new shared variable rebook_lines  like mfc_logical no-undo.
define new shared variable so_mstr_recid as recid.
define new shared variable freight_ok    like mfc_logical initial yes.
define new shared variable old_ft_type   like ft_type.
define new shared variable calc_fr       like mfc_logical
                                         label "Calculate Freight".
define new shared variable old_um        like fr_um.
define new shared variable undo_soivmtb  like mfc_logical.
define new shared variable undo_flag     like mfc_logical.
define new shared variable disp_fr       like mfc_logical
                                         label "Display Weights".
define new shared variable soc_pc_line   like mfc_logical initial yes.
define new shared variable socrt_int     like sod_crt_int.
define new shared variable picust        like cm_addr.
define new shared variable price_changed like mfc_logical.
define new shared variable reprice       like mfc_logical
                                         label "Reprice" initial no.
define new shared variable balance_fmt   as character.
define new shared variable limit_fmt     as character.
define new shared variable prepaid_fmt   as character no-undo.
define new shared variable line_pricing  like pic_so_linpri
                                         label "Line Pricing".
define new shared variable l_edittax     like mfc_logical
                                         initial no no-undo.
define new shared variable impexp        like mfc_logical no-undo.
define new shared variable lv_shipment_id  as character no-undo.
define new shared variable l_consume     like sod_consume no-undo.

define buffer bill_cm for cm_mstr.

define            variable comment_type    like so_lang.
define            variable sotrnbr         like so_nbr.
define            variable sotrcust        like so_cust.
define            variable counter         as integer no-undo.
define            variable msgref          as character format "x(20)".
define            variable impexp_edit     like mfc_logical no-undo.
define            variable upd_okay        like mfc_logical no-undo.
define            variable in_batch_proces as logical.
define            variable prepaid_old     as character no-undo.
define            variable l_old_shipto    like  so_ship no-undo.
define            variable l_undo_shipto   like mfc_logical no-undo.
define            variable l_retrobill     like mfc_logical no-undo.
define            variable errorNbr        as integer no-undo.
define            variable vSOToHold       like so_nbr no-undo.
define            variable emt-bu-lvl      like global_part no-undo.
define            variable save_part       like global_part no-undo.
define            variable use-log-acctg   as logical no-undo.
define            variable lv_nrm_seqid    like lac_soship_nrm_id no-undo.
define            variable lv_undo_flag    as logical no-undo.
define            variable lv_shipfrom     like so_site no-undo.
define            variable msg-arg         as character format "x(24)" no-undo.
define            variable l_vq_use_sold   like mfc_logical initial no no-undo.
define variable l_inv_mthd                 like so_inv_mthd no-undo.

{&SOIVMT-P-TAG13}
{&SOIVMT-P-TAG1}

define new shared frame a.
define new shared frame sold_to.
define new shared frame ship_to.
define new shared frame b.
define new shared frame b1.
define new shared frame sotot.
define new shared frame ship_to1.
define new shared frame ship_to2.

{&SOIVMT-P-TAG7}

{lafrttmp.i "new"}   /* FREIGHT ACCRUAL TEMP-TABLE DEFINITION */
{latrhtmp.i "new"}   /* FREIGHT ACCRUAL TEMP-TABLE FOR TR_HIST DATA */

/*THIS TEMP TABLE IS CREATED TO CALCULATE FREIGHT CHARGES  */
/*WHEN A NEW SALES ORDER LINE IS ADDED TO AN EXISTING ORDER*/
/*WHEN THE FREIGHT TYPE IS "INCLUDE".                      */
define new shared temp-table l_fr_table
       field l_fr_sonbr   like sod_nbr
       field l_fr_soline  like sod_line
       field l_fr_chrg    like sod_fr_chg
       field l_sodlist_pr like sod_list_pr
       index nbrline is primary l_fr_sonbr l_fr_soline.

/* External Logistics data stored in tables. */
/* This data will be used in place of terminal input from user */
{lgivdefs.i &new="new" &type="lg"}
{pppivar.i "new"}  /* Shared pricing variables */
{pppiwqty.i "new"} /* Workfile for accum qty for pricing routines */

{gptxcdec.i}    /* DECLARATIONS FOR gptxcval.i */

/* DUE TO THE SHARED USE OF SOSOMTCM.P WITH SALES ORDER MNT */
{sobtbvar.i "new"} /* BACK TO BACK SHARED WORKFILES AND VARIABLES */

{etsotrla.i "NEW"}
{soivmt01.i}

/* TEMP TABLE DEFINITIONS FOR APM/API */
{ifttcmdr.i "new"}
{ifttcmdv.i "new"}

define new shared temp-table tt_soddet no-undo like sod_det.

/* See if Logistics is running this procedure. */
/* If so, data will be read in from Logistics, not the terminal */
{gprun.i ""mgisact.p"" "(input 'lgarinv', output lgData)"}

run p-get-formats.

if execname = "rcrbrp01.p" then
   l_retrobill = yes.

{&SOIVMT-P-TAG2}

run new-proc-j2dd.

do transaction on error undo, retry:
   find first pic_ctrl  where pic_ctrl.pic_domain = global_domain no-lock
   no-error.
   if not available pic_ctrl then
       do: create pic_ctrl. pic_ctrl.pic_domain = global_domain. end.
end.

so_db = global_db.

/* INITIALIZING SR_WKFL */
for each sr_wkfl
   where sr_domain = global_domain
    and  sr_userid = mfguser
exclusive-lock:
   delete sr_wkfl.
end. /* FOR EACH SR_WKFL WHERE SR_USERID = MFGUSER */

/* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

/* Need to undo the mainloop and after that set a field */
upperloop:
repeat:

   mainloop:

   do on error undo mainloop, leave mainloop:
      hide all no-pause.
      {&SOIVMT-P-TAG8}

      do transaction on error undo, retry:

         find first gl_ctrl where gl_domain = global_domain no-lock.
         find first soc_ctrl where soc_domain = global_domain no-lock no-error.

         assign
            socmmts  = soc_hcmmts /* Set default comments */
            tax_edit = no.

         /* DISPLAY SELECTION FORM */

         {soivmt02.i}  /* Definitions for shared frames a & b & b1 */

         {mfadform.i "sold_to" 1 SOLD-TO}
         {mfadform.i "ship_to" 41 SHIP-TO}
         {mfadform.i "ship_to1" 41 SHIP-TO}
         {mfadform.i "ship_to2" 41 SHIP-TO}

         view frame dtitle.
         view frame a.
         view frame sold_to.
         view frame ship_to.
         view frame b.

         /* Do not read from the terminal if Logistics is running */
         if not lgData then do:
            prompt-for so_mstr.so_nbr with frame a
            editing:

               /* FIND NEXT/PREVIOUS  RECORD */
               {mfnp.i so_mstr so_nbr  " so_domain = global_domain and
               so_nbr "  so_nbr so_nbr so_nbr}

               if keyfunction(lastkey) = "RECALL" or lastkey = 307
               then
                  display sonbr @ so_nbr with frame a.

               if recno <> ? then do:
                  {mfaddisp.i so_cust sold_to}
                  {mfaddisp.i so_ship ship_to}
                  display
                     so_nbr
                     so_cust
                     so_bill
                     so_ship
                  with frame a.

                  perform_date = ?.

                  if so_slspsn[2] <> "" or
                     so_slspsn[3] <> "" or
                     so_slspsn[4] <> ""
                  then
                     mult_slspsn = true.
                  else
                     mult_slspsn = false.
                  if not new_order then socrt_int = so__qad02.

                  run p-disp-frameb.
               end. /* if recno <> ? then do */

            end. /* prompt-for with editing */

            if input so_nbr = "" then do:
               /* Get next sales order number with prefix */
               {mfnctrlc.i "soc_ctrl.soc_domain = global_domain"
               "soc_ctrl.soc_domain" "so_mstr.so_domain = global_domain"
               soc_ctrl soc_so_pre soc_so so_mstr so_nbr sonbr}
               {&SOIVMT-P-TAG9}
            end.
            else
               {&SOIVMT-P-TAG10}
               sonbr = input so_nbr.
               {&SOIVMT-P-TAG11}
         end. /* if not lgData */
         else do:
            /* Load the Invoice data from the Logistics Tables */
            /* For use in all later processing. */
            {gprunmo.i &module = "LG" &program = "lgivcp.p"}
            sonbr = lgSoNbr.
         end.
         {&SOIVMT-P-TAG3}

      end. /* do transaction */

      do transaction on error undo, retry:

         old_ft_type = "".
         find so_mstr
            where so_domain = global_domain
             and  so_nbr = sonbr
         exclusive-lock no-error.

         if not available so_mstr then do:

            /* Logistics requires the Order exists. */
            if lgData then do:
               {pxmsg.i &MSGNUM=621 &ERRORLEVEL=4}
               return.
            end.

            find first soc_ctrl
               where soc_domain = global_domain
            no-lock no-error.
            clear frame sold_to.
            clear frame ship_to.
            clear frame b.
            {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} /* ADDING NEW RECORD */

            /* READY TO INVOICE FLAG SHOULD BE SET     */
            /* TO YES INITIALLY WHEN ORDER IS CREATED  */

            {&SOIVMT-P-TAG12}
            create so_mstr.
            assign
               new_order    = yes
               so_domain    = global_domain
               so_nbr       = sonbr
               so_ord_date  = today
               so_due       = today
               so_ship_date = today
               so_to_inv    = yes
               so_invoiced  = no
               so_conf_date = today
               so_print_pl  = no
               socmmts      = soc_hcmmts
               so_fob       = soc_fob
               so_userid    = global_userid.

         end. /* if not available so_mstr */

         else do:

            /* IF LOGISTICS OWNS THE ORDER AND EXTERNAL INVOICING */
            /* IS ACTIVE, DO NOT ALLOW USER ACCESS. */
            if not lgData and so_app_owner > "" then do:
               /* See if External Invoicing is active */
               for first lgs_mstr
                  where lgs_domain = global_domain
                   and  lgs_app_id = so_app_owner
                   and  lgs_invc_imp = yes
               no-lock:
                  /* Cannot process. Document owned by application # */
                  {pxmsg.i &MSGNUM=2948 &ERRORLEVEL=3
                           &MSGARG1=so_app_owner}
                  if not batchrun then pause.
               end.
               /* THIS LINE IS HERE, NOT IN THE FOR STATMENT */
               /* BECAUSE AN 'F4' AT THE PAUSE LEAVES THE FOR WITHOUT */
               /* DOING THE UNDO. CATCH IT HERE. */
               if available lgs_mstr then undo mainloop, retry mainloop.
            end.
            /* Check for batch shipment record */
            in_batch_proces = no.
            {sosrchk.i so_nbr in_batch_proces}
            if in_batch_proces
            then
               undo mainloop, retry mainloop.

            /*Determine if this order will be processed with a credit card
             * and validate that the credit card info is valid and that the
             * authorized amount is enough to process the order.  Issue
             * warning if an error occurs*/
            {gprunp.i "soccval" "p" "preValidateCCProcessing"
               "(input so_nbr, output errorNbr)"}
            if errorNbr <> 0 then do:
               {pxmsg.i &MSGNUM=errorNbr &ERRORLEVEL=2}
               if not batchrun then pause.
            end.

            /* I.E. IF AVAIL SO_MSTR */
            if so_conf_date = ? then do:
               /* WARNING: SALES ORDER NOT CONFIRMED */
               {pxmsg.i &MSGNUM=621 &ERRORLEVEL=2}
            end.

            /* SO'S AND RMA'S ARE UPDATEABLE IN PENDING INV. MAINT., */
            /* ALTHOUGH THE USER WILL BE SOMEWHAT LIMITED AS TO WHAT */
            /* HE CAN SEE/MAINTAIN ON RMA'S.                         */
            if so_fsm_type <> ""
               and so_fsm_type <> "RMA"
            then do:
               if so_fsm_type = "SC"
               then
                  msgref = caps(getTermLabel("SERVICE_CONTRACT", 20)).
               else
               if so_fsm_type = "SEO"
               then
                  msgref = caps(getTermLabel("MATERIAL_ORDER", 20)).
               else
               if so_fsm_type = "PRM"
               then
                  msgref = getTermLabel("PRM_PENDING_INVOICE", 20).
               else
                  msgref = getTermLabel("SERVICE_INVOICE", 20).

               /* THIS IS A # CANNOT PROCESS */
               {pxmsg.i &MSGNUM=7326 &ERRORLEVEL=3 &MSGARG1=msgref}

               if not batchrun then pause.
               undo mainloop, retry mainloop.
            end.

            {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1}  /* MODIFYING EXISTING RECORD */

            {mfaddisp.i so_cust sold_to}
            if not available ad_mstr then do:
               hide message no-pause.
               {pxmsg.i &MSGNUM=3 &ERRORLEVEL=2}  /* NOT A VALID CUSTOMER */
            end.

            {mfaddisp.i so_ship ship_to}

            assign
               socrt_int = so__qad02
               socmmts   = so_cmtindx <> 0
               new_order = no.

            find ft_mstr
               where ft_domain = global_domain
                and  ft_terms  = so_fr_terms
            no-lock no-error.
            if available ft_mstr then old_ft_type = ft_type.

            {gprun.i ""gpsiver.p""
               "(input so_site, input ?, output return_int)"}

            if return_int = 0 then do:
               display so_site with frame b.
               /* USER DOES NOT HAVE ACCESS TO SITE */
               {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
               pause.
               undo mainloop, retry mainloop.
            end.

            if so_sched then
            /* ORDER WAS CREATED BY SCHEDULED ORDER MAINTENANCE */
            {pxmsg.i &MSGNUM=8210 &ERRORLEVEL=2}

         end. /* else do (available so_mstr) */

         assign
            recno    = recid(so_mstr)
            sotrnbr  = so_nbr
            sotrcust = so_cust.
         display
            so_nbr
            so_cust
            so_bill
            so_ship
         with frame a.

         if so_ship_date = ? then so_ship_date = today.

         perform_date = ?.

         if so_slspsn[2] <> "" or
            so_slspsn[3] <> "" or
            so_slspsn[4] <> ""
         then
            mult_slspsn = true.
         else
            mult_slspsn = false.

         run p-disp-frameb.   /* display frame b */

         /* Get sold-to, bill-to, and ship-to customer */
         /* SHIP-TO CHANGED; UPDATE TAX DATA ON CONFIRMATION. PREVIOUS */
         /* HEADER TAX ENVIRONMENT BLANKED OUT FOR RECALCULATION LATER */
         assign
            so_recno  = recid(so_mstr)
            undo_cust = true
            l_edittax = no.

         if so_fsm_type = "RMA" then
            find rma_mstr
               where rma_domain = global_domain
                and  rma_nbr = so_nbr
                and  rma_prefix = "C"
            no-lock.

         l_old_shipto = so_ship.

         if not lgData then do:
            /* SOSOMTCM.P INPUT PARMS INDICATE IF THIS IS RMA */
            {gprun.i ""sosomtcm.p""
               "(input     (available rma_mstr),
                 input     if available rma_mstr then recid(rma_mstr)
                           else ?,
                 input     no,
                 output    l_edittax)"}
            if undo_cust then undo mainloop, retry.

            /* THIS BLOCK OF CODE EXECUTED WHEN SHIP-TO IS CHANGED IN GTM */
            if l_old_shipto <> "" and l_old_shipto <> so_ship
            then do:
               l_undo_shipto = true.
               /* IF SHIP-TO IS CHANGED */
               run p-shipto-change
                  (input so_recno,
                  input-output l_undo_shipto).
               if l_undo_shipto then do:
                  display
                     l_old_shipto @ so_ship
                  with frame a.
                  undo mainloop, retry mainloop.
               end. /* IF L_UNDO_SHIPTO */
            end.  /* IF SHIP-TO IS CHANGED IN GTM */

         end.
         else do:
            /* Load the data from the tables. */
            run setLogistics.
         end.

         find cm_mstr
            where cm_mstr.cm_domain = global_domain
              and cm_mstr.cm_addr = so_cust no-lock.
         find bill_cm
            where bill_cm.cm_domain = global_domain
              and bill_cm.cm_addr = so_bill no-lock.
         find ad_mstr
            where ad_domain = global_domain
             and  ad_addr = so_bill no-lock.
         if ad_inv_mthd = "" then do:
            find ad_mstr
               where ad_domain = global_domain
                and  ad_addr = so_ship no-lock.
            if ad_inv_mthd = "" then
               find ad_mstr
                  where ad_domain = global_domain
                    and ad_addr = so_cust no-lock.
         end.

         /* SET CUSTOMER VARIABLE USED BY PRICING ROUTINE gppibx.p */
         picust = so_cust.
         if so_cust <> so_ship and
            can-find(cm_mstr where cm_mstr.cm_domain = global_domain and
                                   cm_mstr.cm_addr = so_ship)
         then
            picust = so_ship.

         order-header:
         do on error undo, retry with frame b:

            /* DO NOT ALLOW RMA'S TO BE DELETED IN PENDING INVOICE MAINT */
            if so_fsm_type = " " then
               ststatus = stline[2].
            else
               ststatus = stline[3].
            status input ststatus.
            del-yn = no.

            /* SET DEFAULTS WHEN CREATING A NEW ORDER - */
            /* USE SHIP-TO CUSTOMER INFO FOR DEFAULT IF */
            /* AVAILABLE ELSE USE SOLD-TO INFO          */
            if new so_mstr then
               run assign_new_so.

            /* LOAD DEFAULT TAX CLASS & USAGE */
            find ad_mstr
               where ad_domain = global_domain
                and  ad_addr = so_ship
            no-lock no-error.
            if not available ad_mstr then
               find ad_mstr
                  where ad_domain = global_domain
                    and ad_addr = so_cust
               no-lock no-error.
            if available(ad_mstr) then
               tax_in  = ad_tax_in.

            if not new so_mstr then socmmts = so_cmtindx <> 0.
            if not new so_mstr and so_invoiced = yes then do:
               /* INVOICE PRINTED BUT NOT POSTED,
                  PRESS ENTER TO CONTINUE.*/
               {pxmsg.i &MSGNUM=603 &ERRORLEVEL=2}
               if not batchrun then
                  pause.
            end.

            /* CHECK CREDIT LIMIT */
            if bill_cm.cm_cr_limit < bill_cm.cm_balance then do:
               /* CUSTOMER BALANCE */
               msg-arg = string(bill_cm.cm_balance,balance_fmt).
               {pxmsg.i &MSGNUM=615 &ERRORLEVEL=2 &MSGARG1=msg-arg}
               /* CREDIT LIMIT */
               msg-arg = string(bill_cm.cm_cr_limit,limit_fmt).
               {pxmsg.i  &MSGNUM=617 &ERRORLEVEL=1 &MSGARG1=msg-arg}
            end.

            /* CHECK CREDIT HOLD  */
            if bill_cm.cm_cr_hold  then do:
               /* CUSTOMER ON CREDIT HOLD */
               {pxmsg.i &MSGNUM=614 &ERRORLEVEL=2}
               if new so_mstr then so_stat = "HD".
            end.

            if not new_order then socrt_int = so__qad02.

            recno = recid(so_mstr).
            run p-disp-frameb.   /* display frame b */

            undo_flag = true.
            {gprun.i ""soivmtp.p""}

            /* Jump out if SO was (successfully) deleted */
            if not can-find(so_mstr where so_domain = global_domain
                                     and  so_nbr = input so_nbr)
            then next upperloop.
            if undo_flag then
               undo mainloop, next upperloop.

         end. /* order-header: do on error */

            cr_terms_changed = no.

            if (oldcurr <> so_curr) or (oldcurr = "") then do:
               /* SET CURRENCY DEPENDENT FORMATS */
               {socurfmt.i}
               oldcurr = so_curr.
               /* SET CURRENCY DEPENDENT FORMAT FOR PREPAID_FMT */
               prepaid_fmt = prepaid_old.
               {gprun.i ""gpcurfmt.p"" "(input-output prepaid_fmt,
                                         input rndmthd)"}
            end.

            if perform_date = ? then perform_date = so_mstr.so_due_date.
            if so_mstr.so_req_date = ? then
               so_mstr.so_req_date = so_mstr.so_due_date.

            if so_fsm_type <> "" and so_pricing_dt = ? then
               so_pricing_dt = so_ord_date.
            if so_pricing_dt    = ? then do:
               if pic_so_date   = "ord_date" then
                  so_pricing_dt = so_ord_date.
               else
               if pic_so_date   = "req_date" then
                  so_pricing_dt = so_req_date.
               else
               if pic_so_date   = "per_date" then
                  so_pricing_dt = perform_date.
               else
               if pic_so_date   = "due_date" then
                  so_pricing_dt = so_due_date.
               else
                  so_pricing_dt = today.
            end.

            /* COMMENTS */
            assign
               global_lang = so_mstr.so_lang
               global_type = "".

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

            if socmmts = yes and not lgData then do:
               assign
                  cmtindx     = so_mstr.so_cmtindx
                  global_ref  = so_mstr.so_cust
                  save_part   = global_part
                  global_part = emt-bu-lvl.
               {gprun.i ""gpcmmt01.p"" "(input ""so_mstr"")"}
               global_part = save_part.
               so_mstr.so_cmtindx = cmtindx.
            end.

            /* Assign next automatic number for new ship-to customer */
            if so_mstr.so_ship = "QADTEMP" + mfguser then
               run update-addr (input-output so_mstr.so_ship).

         end.  /* do transaction: SO Header updates */

         /* FIND LAST LINE */
         line = 0.

         for each sod_det
            where sod_domain = global_domain
            and   sod_nbr = so_mstr.so_nbr
         by sod_line descending:
            line = sod_line.
            leave.
         end.

         /* INITIALIZE ACCUM QTY WORKFILES USED BY PRICING ROUTINES */
         {gprun.i ""gppiqty1.p"" "(""1"",
                                   so_mstr.so_nbr,
                                   yes,
                                   yes)"}

         hide frame sold_to no-pause.
         hide frame ship_to no-pause.
         hide frame ship_to1 no-pause.
         hide frame ship_to2 no-pause.
         hide frame b1 no-pause.
         hide frame b no-pause.
         hide frame a no-pause.

         /* LINE ITEMS */
         hide frame a.
         {&SOIVMT-P-TAG14}
         {gprun.i ""xxsoivmta.p""}
         {&SOIVMT-P-TAG15}
         {&SOIVMT-P-TAG16}

         /* IF LOGISTICS ACCOUNTING IS ENABLED AND VALID FREIGHT TERMS/LIST   */
         /* IS ENTERED DISPLAY THE LOGISTICS CHARGE DETAIL FRAME WHICH        */
         /* DISPLAYS THE LOGISTICS SUPPLIER FOR THIS ORDER STORED IN THE      */
         /* lacd_det. IF THE USER CHANGES THIS SUPPLIER IT WILL NOT BE UPDATED*/
         /* IN lacd_det RECORD. IT WILL BE HOWEVER BE STORED IN THE PENDING   */
         /* VOUCHER RECORD CREATED FOR VOUCHERING THIS ACCRUAL.               */

         if use-log-acctg and
            so_fr_terms <> "" and
           (can-find(first sod_det where sod_domain = global_domain
                                    and  sod_nbr = so_nbr
                                    and  sod_fr_list <> ""))
         then do transaction on error undo, retry:

            /* FREIGHT TERMS MASTER ALREADY VALIDATED */
            for first ft_mstr
               where ft_domain = global_domain
                and  ft_terms = so_fr_terms
            no-lock:
            end.

            if available ft_mstr and
               (ft_accrual_level = {&LEVEL_Shipment}
                or ft_accrual_level = {&LEVEL_Line})
            then do:
               lv_shipfrom = "".

               for first sod_det fields (sod_domain sod_nbr sod_site)
                  where sod_domain = global_domain
                   and  sod_nbr = so_nbr
               no-lock:
                  lv_shipfrom = sod_site.
               end.

               if ft_accrual_level = {&LEVEL_Shipment} and so_site <> "" then
                  lv_shipfrom = so_site.

               view frame a.

               /* DISPLAY LOGISTICS CHARGE CODE DETAIL */
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
                                         input yes)"""}

               /* GET THE SO SHIPMENT SEQUENCE ID DEFINED IN LOGISTICS     */
               /* ACCOUNTING CONTROL FILE.                                 */
               lv_nrm_seqid = "".
               for first lac_ctrl
                  fields (lac_domain lac_soship_nrm_id)
                  where lac_domain = global_domain
               no-lock:
                  lv_nrm_seqid = lac_soship_nrm_id.
               end.

               /* ASSIGN SHIPMENT ID */
               {gprunmo.i  &module = "LA" &program = "lalgship.p"
                           &param  = """(input lv_nrm_seqid,
                                         output lv_shipment_id,
                                         input-output lv_undo_flag)"""}

               if lv_undo_flag and batchrun then
                  undo upperloop, leave upperloop.
               else if lv_undo_flag then
                  undo mainloop, retry mainloop.
            end.
         end.

         /* TEST FOR PRICING OR REPRICING REQUIREMENTS AND SUBSEQUENT */
         /* PROCESSING                                                */

         /* SKIPPING REPRICING AFTER LINE PROCESSING FOR RETROBILLED ITEMS */
         if not l_retrobill then
         {gprun.i ""sosoprc.p"" "(input so_recno,
                                  input reprice,
                                  input new_order,
                                  input line_pricing)" }

         view frame a.
         display so_mstr.so_ship with frame a.

         do transaction on error undo, retry:
            {gpgettrl.i &hdr_file="so" &ctrl_file="soc"}

            if new_order
               and soc_use_frt_trl_cd
            then do:
               for first fr_mstr
                  fields (fr_domain fr_curr fr_list fr_site fr_trl_cd)
                     where fr_domain = global_domain
                     and   fr_list = so_fr_list
                     and   fr_site = so_site
                     and   fr_curr = so_curr
               no-lock:
                  so_trl1_cd = fr_trl_cd.
               end. /* FOR FIRST fr_mstr */

            end. /* IF new-order and ... */

            if current_cr_terms <> "" and current_cr_terms <> so_cr_terms then
            assign
               so_cr_terms = current_cr_terms
               cr_terms_changed = yes.

            if current_fr_terms <> ""
               and so_manual_fr_terms  = no
            then
               so_fr_terms = current_fr_terms.

            assign
               current_cr_terms = ""
               current_fr_terms = "".

            /* CALCULATE FREIGHT */
            if calc_fr and so_fr_terms = "" then do:
               /* INVALID FRT TERMS */
               {pxmsg.i &MSGNUM=671 &ERRORLEVEL=2 &MSGARG1=so_fr_terms}
            end. /* if calc_fr and so_fr_terms */

            if calc_fr and so_mstr.so_fr_terms <> ""
            then do:
               so_mstr_recid = recid(so_mstr).
               {gprun.i ""sofrcali.p""}
            end.

         end.   /* do transaction */

         /* TRAILER */
         cm_recno = recid(bill_cm).
         {gprun.i ""soivmtc.p""}

         {gpdelp.i "soccval" "p"} /*Delete persistent procedure*/
         {&SOIVMT-P-TAG4}

         /* IMPORT EXPORT FLAG IS SET TO YES CALL THE IMPORT EXPORT DETAIL */
         /* LINE MAINTENANCE PROGRAM FOR USER TO UPDATE ied_det            */

         if not batchrun and impexp then do:
            impexp_edit = no.
            /* VIEW EDIT IMPORT EXPORT DATA ? */
            {pxmsg.i &MSGNUM=271 &ERRORLEVEL=1 &CONFIRM=impexp_edit}
            if impexp_edit then do:
               upd_okay = no.
               hide all no-pause.
               view frame dtitle.
               view frame a.
               {gprun.i ""iedmta.p"" "(input ""1"",
                                       input so_nbr,
                                       input-output upd_okay )" }
            end.
         end.

         /* SEE IF INTRASTAT IS ENABLED */
         for first iec_ctrl
            fields (iec_domain iec_use_instat iec_authority)
            where iec_domain     = global_domain
              and iec_use_instat = yes
         no-lock:

            for each sod_det
               fields (sod_domain sod_nbr sod_line sod_btb_type sod_btb_po
                       sod_part sod_um sod_price sod_um_conv sod_consignment
                       sod_qty_inv sod_site)
                where sod_domain = global_domain
                  and sod_nbr    = so_nbr
            no-lock:

               if sod_qty_inv = 0
               and not can-find(first ieh_hist
                                   where ieh_hist.ieh_domain = global_domain
                                     and ieh_authority       = iec_authority
                                     and ieh_type            = "1"
                                     and ieh_nbr             = sod_nbr
                                     and ieh_line            = sod_line
                                     and ieh_ref             = ""
                                     and ieh_voucher         = ""
                                     and ieh_reported        = false)
               then
                  next.

               /* CREATE IMPORT EXPORT HISTORY RECORD */
               /* ADDED THITD INPUT PARAMETER TO AVOID PARAMETER MISMATCH   */
               /* ADDED FOURTH INPUT PARAMETER TO AVOID PARAMETER MISMATCH  */
               {gprun.i ""iehistso.p"" "(buffer sod_det,
                                         input sod_qty_inv,
                                         input """",
                                         input 0,
                                         input today,
                                         input ""SHIP"")"}
            end. /* FOR FIRST sod_det */

         end. /* FOR FIRST iec_ctrl */

         global_type = comment_type.

         {&SOIVMT-P-TAG6}

         release so_mstr.

         if lgData then do:
            run deleteLogTables.
            leave mainloop.
         end.

      end. /*mainloop*/

      if lgData then leave upperloop.

   end. /*UPPERLOOP*/

   status input.


/****************** INTERNAL PROCEDURES **********************/

PROCEDURE p-get-formats:
   /* -----------------------------------------------------------
   Purpose:     assigns formats of various amount fields to
                variables for use with CDR.
   Parameters:  <none>
   Notes:       Moved out of main line of code to reduce compile
                size
   -------------------------------------------------------------*/

   /* ASSIGN ORIGINAL FORMAT TO _OLD VARIABLES */
   assign
      nontax_old      = nontaxable_amt:format in frame sotot
      taxable_old     = taxable_amt:format in frame sotot
      line_tot_old    = line_total:format in frame sotot
      disc_old        = disc_amt:format in frame sotot
      trl_amt_old     = so_trl1_amt:format in frame sotot
      tax_amt_old     = tax_amt:format in frame sotot
      ord_amt_old     = ord_amt:format in frame sotot
      prepaid_old     = so_prepaid:format in frame d
      container_old   = container_charge_total:format in frame sotot
      line_charge_old = line_charge_total:format in frame sotot.

   /* SET LIMIT_FMT AND BALANCE_FMT FOR USE IN PXMSG.I */
   assign
      oldcurr     = ""
      balance_fmt = "->>>>,>>>,>>9.99"
      limit_fmt   = "->>>>,>>>,>>9.99".

   /* SET LIMIT_FMT ACCORDING TO BASE CURR ROUND METHOD*/
   {gprun.i ""gpcurfmt.p"" "(input-output limit_fmt,
                             input gl_ctrl.gl_rnd_mthd)"}
   /* SET BALANCE_FMT ACCORDING TO BASE CURR ROUND METHOD*/
   {gprun.i ""gpcurfmt.p"" "(input-output balance_fmt,
                             input gl_ctrl.gl_rnd_mthd)"}

END PROCEDURE.

   PROCEDURE assign_new_so:
      /* -----------------------------------------------------------
      Purpose:     When this is a new Sales Order, assigns all of
                   the so_mstr header information
      Parameters:  <none>
      Notes:       Moved out of main line of code to reduce compile
      size
      -------------------------------------------------------------*/

      find first soc_ctrl where soc_domain = global_domain no-lock.
      find current so_mstr.
      find cm_mstr
         where cm_mstr.cm_domain = global_domain
           and cm_mstr.cm_addr = so_cust no-lock.
      find bill_cm
         where bill_cm.cm_domain = global_domain
           and bill_cm.cm_addr = so_bill no-lock.
      find ad_mstr
         where ad_domain = global_domain
          and  ad_addr = so_bill no-lock.

      if ad_inv_mthd = "" then do:
         find ad_mstr
            where ad_domain = global_domain
             and  ad_addr = so_ship  no-lock.
         if ad_inv_mthd = "" then
            find ad_mstr
               where ad_domain = global_domain
                and  ad_addr = so_cust  no-lock.
      end.

      l_inv_mthd = ad_inv_mthd.

      if so_cust <> so_ship
      then do:
         if can-find(cm_mstr where cm_mstr.cm_domain = global_domain and
                                   cm_mstr.cm_addr = so_ship)
         then do:
            for first cm_mstr
               fields (cm_domain cm_addr cm_ar_acct cm_ar_cc cm_ar_sub
                       cm_cr_hold cm_cr_limit cm_cr_terms cm_curr
                       cm_disc_pct cm_fix_pr cm_fr_list cm_fr_min_wt
                       cm_fr_terms cm_fst_id cm_lang cm_partial cm_pst
                       cm_rmks cm_shipvia cm_site cm_slspsn cm_taxable
                       cm_taxc cm_tax_in cm_balance)
                where cm_mstr.cm_domain = global_domain
                 and  cm_mstr.cm_addr = so_ship
            no-lock:
               so_lang = cm_mstr.cm_lang.
            end. /* FOR FIRST cm_mstr */
         end. /* IF CAN-FIND */
         else do:
            for first ad_mstr
               fields (ad_domain ad_addr ad_city ad_country ad_inv_mthd
                       ad_line1 ad_line2 ad_name ad_pst_id ad_state ad_lang
                       ad_taxable ad_taxc ad_tax_in ad_tax_usage ad_zip)
               where ad_domain = global_domain
                and  ad_addr = so_ship
            no-lock:
               so_lang = ad_lang.
            end. /* FOR FIRST ad_mstr */
         end. /* ELSE DO */
      end. /* IF so_cust <> so_ship */
      else
         so_lang = cm_mstr.cm_lang.

      /* SO_FIX_PR = YES FOR RETROBILLED ITEMS       */
      /* TO AVOID SALES ORDER REPRICING.             */
      /* NO CUSTOMER DISCOUNT FOR RETROBILLED ITEMS. */

      assign
         so_cr_terms  = bill_cm.cm_cr_terms
         so_curr      = bill_cm.cm_curr
         so_fix_pr    = if not l_retrobill then cm_mstr.cm_fix_pr else yes
         so_disc_pct  = if not l_retrobill then cm_mstr.cm_disc_pct else 0
         so_shipvia   = cm_mstr.cm_shipvia
         so_partial   = cm_mstr.cm_partial
         so_rmks      = cm_mstr.cm_rmks
         so_site      = cm_mstr.cm_site
         so_taxable   = cm_mstr.cm_taxable
         so_taxc      = cm_mstr.cm_taxc
         so_pst       = cm_mstr.cm_pst
         so_fst_id    = cm_mstr.cm_fst_id
         so_pst_id    = ad_pst_id
         so_fr_list   = cm_mstr.cm_fr_list
         so_fr_terms  = cm_mstr.cm_fr_terms
         so_fr_min_wt = cm_mstr.cm_fr_min_wt
         so_inv_mthd  = l_inv_mthd
         socmmts      = soc_hcmmts
         so_userid    = global_userid.

      {gprun.i ""gpsiver.p""
         "(input so_site, input ?, output return_int)"}

      if return_int = 0 then do:
         /* USER DOES NOT HAVE ACCESS TO DEFAULT SITE */
         {pxmsg.i &MSGNUM=2711 &ERRORLEVEL=2 &MSGARG1=so_site}
         so_site = "".
         display so_site with frame b.
      end.

      socrt_int = 0.

      if so_cr_terms <> "" then do:
         find ct_mstr
            where ct_domain = global_domain
             and  ct_code = so_cr_terms
         no-lock no-error.
         if available ct_mstr then socrt_int = ct_terms_int.
      end.

      if not l_vq_use_sold
      then do:

         find ad_mstr
            where ad_domain = global_domain
            and   ad_addr = so_ship
         no-lock no-error.
         if not available ad_mstr then
            find ad_mstr
               where ad_domain = global_domain
               and   ad_addr = so_cust
            no-lock no-error.
            if available ad_mstr
            then
               assign
                  so_taxable   = ad_taxable
                  so_tax_usage = ad_tax_usage
                  so_taxc      = ad_taxc.

      end. /* IF NOT l_vq_use_sold */
      else do:

         for first ad_mstr
            fields (ad_domain ad_addr ad_taxable ad_tax_usage ad_taxc)
            where ad_domain = global_domain
            and   ad_addr   = so_cust
         no-lock:
            assign
               so_taxable   = ad_taxable
               so_tax_usage = ad_tax_usage
               so_taxc      = ad_taxc.
         end. /* FOR FIRST ad_mstr */

         for first ad_mstr
            fields (ad_addr ad_city ad_country ad_domain ad_inv_mthd ad_lang
                    ad_line1 ad_line2 ad_name ad_pst_id ad_state ad_taxable
                    ad_taxc ad_tax_in ad_tax_usage ad_zip)
            where ad_domain = global_domain
            and   ad_addr   = so_ship
         no-lock:
            assign
               so_taxable   = ad_taxable
               so_taxc      = ad_taxc.
         end. /* FOR FIRST ad_mstr */

      end. /* IF l_vq_use_sold */

      do counter = 1 to 4:
         so_slspsn[counter] = cm_mstr.cm_slspsn[counter].

         if cm_mstr.cm_slspsn[counter] <> "" then do:

            find sp_mstr
               where sp_domain = global_domain
                and  sp_addr   = cm_mstr.cm_slspsn[counter]
            no-lock no-error.

            find spd_det
               where spd_domain  = global_domain
                and  spd_addr    = cm_mstr.cm_slspsn[counter]
                and  spd_prod_ln = ""
                and  spd_part    = ""
                and  spd_cust    = cm_mstr.cm_addr
            no-lock no-error.

            if available spd_det then
               so_comm_pct[counter] = spd_comm_pct.
            else
            if available sp_mstr then
               so_comm_pct[counter] = sp_comm_pct.

         end. /* if cm_mstr.cm_slspsn[counter] <> ""  */
      end. /* do counter  */

      if so_slspsn[2] <> "" or
         so_slspsn[3] <> "" or
         so_slspsn[4] <> ""
      then
         mult_slspsn = true.
      else
         mult_slspsn = false.

      if bill_cm.cm_ar_acct <> "" then
      assign
         so_ar_acct = bill_cm.cm_ar_acct
         so_ar_sub  = bill_cm.cm_ar_sub
         so_ar_cc   = bill_cm.cm_ar_cc.
      else do:
         find first gl_ctrl where gl_domain = global_domain
         no-lock no-error.
         if not available gl_ctrl then do:
            create gl_ctrl.
            gl_domain = global_domain.
         end.
         assign
            so_ar_acct = gl_ar_acct
            so_ar_sub  = gl_ar_sub
            so_ar_cc   = gl_ar_cc.
      end.

   END PROCEDURE. /* assign_new_so */

   PROCEDURE new-proc-j2dd:
      /* -----------------------------------------------------------
      Purpose:     Reads soc_ctrl and mfc_control and sets local
                   variables
      Parameters:  None
      Notes:       Moved out of main line of code to reduce compile
      size, new procedure in /*J2DD*/
      -------------------------------------------------------------*/

      do transaction on error undo, retry:
         find first soc_ctrl where soc_domain = global_domain no-lock
         no-error.
         if not available soc_ctrl then do:
            create soc_ctrl.
            soc_domain = global_domain.
         end.
         assign
            ln_fmt = soc_ln_fmt
            comment_type = global_type.
      end.

      do transaction on error undo, retry:
         /* SET UP PRICING BY LINE VALUES */
         find first mfc_ctrl
            where mfc_domain = global_domain
              and mfc_field = "soc_pc_line"
         no-lock no-error.
         if available mfc_ctrl then
            soc_pc_line = mfc_logical.
      end.

      do transaction on error undo, retry:
         for first mfc_ctrl
            fields (mfc_field mfc_logical)
            where mfc_domain = global_domain
              and mfc_field = "l_vqc_sold_usage"
         no-lock:
            l_vq_use_sold = mfc_logical.
         end. /* FOR FIRST mfc_ctrl */
      end. /* DO TRANSACTION */

   END PROCEDURE. /* new-proc-j2dd */

PROCEDURE p-disp-frameb:
   /* -----------------------------------------------------------
   Purpose:     Displays information in frame b
   Parameters:  None
   Notes:       Moved out of main line of code to reduce compile
                size, new procedure in /*L00L*/
   -------------------------------------------------------------*/

   find first soc_ctrl
      where soc_domain = global_domain
   no-lock no-error.

   /* THE FOLLOWING CODE WAS ADDED FROM soivmtdi.i */
   if new_order then
      socmmts = soc_hcmmts.
   else
      socmmts = (so_mstr.so_cmtindx <> 0).

   display
      so_ord_date
      so_ship_date
      so_req_date
      so_pr_list
      so_curr
      so_lang
      perform_date
      so_site
      so_taxable
      so_taxc
      so_tax_date
      so_due_date
      so_channel
      so_fix_pr
      so_pricing_dt
      so_project
      so_cr_terms
      so_po
      socrt_int
      so_rmks
      reprice
      so_userid
   with frame b.

END PROCEDURE.  /* p-disp-frameb */

   PROCEDURE p-shipto-change:
      /* -----------------------------------------------------------
      Purpose:     Check to see if valid to change ship-to and reassign
                   tax fields in so_mstr header record if valid
      Parameters:
      so_recno:   input parm   Contains recid of current SO
      l_undo_ship output parm  If no then don't change ship-tp
      Notes:
      -------------------------------------------------------------*/
      define input parameter so_recno as recid no-undo.
      define input-output parameter l_undo_shipto like mfc_logical no-undo.

      find so_mstr where recid(so_mstr) = so_recno exclusive-lock.

      /* SHIP-TO CANNOT BE CHANGED; QUANTITY TO INVOICE EXISTS */
      if l_old_shipto <> "" and l_old_shipto <> so_ship
      then do:
         if can-find(first sod_det where sod_domain = global_domain
                                    and  sod_nbr = so_nbr
                                    and  sod_qty_inv <> 0 )
         then do:
            l_undo_shipto = true.
            /* OUTSTANDING QTY TO INVOICE, SHIP-TO TAXES CANNOT BE UPDATED */
            {pxmsg.i &MSGNUM=2363 &ERRORLEVEL=4}
            if not batchrun then pause.
            leave.
         end. /* if can-find */
      end. /* if l_old_shipto */

      if not batchrun
         and l_old_shipto <> ""
         and l_old_shipto <> so_ship
         and not l_vq_use_sold
      then do:
         /* SHIP-TO CHANGED; UPDATE TAX DATA? */
         {pxmsg.i &MSGNUM=2351 &ERRORLEVEL=1 &CONFIRM=l_edittax}
         if l_edittax then do:
            /* LOAD DEFAULT TAX CLASS & USAGE */
               find ad_mstr
                  where ad_domain = global_domain
                  and   ad_addr = so_ship no-lock no-error.
               if not available ad_mstr then
                  find ad_mstr
                     where ad_domain = global_domain
                       and ad_addr = so_cust
                  no-lock no-error.
                  if available ad_mstr then
                  assign
                     so_taxable   = ad_taxable
                     so_tax_usage = ad_tax_usage
                     so_taxc      = ad_taxc
                     so_tax_env   = "".
         end.  /* if l_edittax is true */

      end. /* if ship-to changed in GTM and not batchrun */

      l_undo_shipto = false.

   END PROCEDURE.  /* p-shipto-change */

PROCEDURE update-addr:
   define input-output parameter ship_addr like so_ship no-undo.

   find ad_mstr
      where ad_domain = global_domain
       and  ad_addr = ship_addr
   exclusive-lock.
   {mfactrl.i "cmc_ctrl.cmc_domain = global_domain" "cmc_ctrl.cmc_domain"
   "ad_mstr.ad_domain = global_domain" cmc_ctrl cmc_nbr ad_mstr ad_addr
   ship_addr}
   create ls_mstr.
   assign
      ad_addr   = ship_addr
      ls_domain = global_domain
      ls_type   = "ship-to"
      ls_addr   = ship_addr.
   /* Ship-To record added: */
   {pxmsg.i &MSGNUM=638 &ERRORLEVEL=1 &MSGARG1=ship_addr}

END PROCEDURE.

PROCEDURE setLogistics:
   /* ----------------------------------------------------------- */
   /*Purpose:     SET THE EXTERNAL LOGISTICS DATA IN LIEU OF      */
   /*               USING THE TERMINAL INPUT.                     */
   /*  Parameters. None                                           */
   /*  Notes.. None                                               */
   /* ----------------------------------------------------------- */
   for first lgi_lgmstr no-lock:
      if lgi_so_bill <> "" then so_mstr.so_bill = lgi_so_bill.
      /* Commisions as well ... */
      if lgi_so_userid <> "" then so_userid = lgi_so_userid.
   end.
END PROCEDURE.

PROCEDURE deleteLogTables:
   /* ----------------------------------------------------------- */
   /*  Purpose:     Clean up the temp tables                      */
   /*  Parameters.  None                                           */
   /*  Notes.. Delete the tables created for external data entry. */
   /* ----------------------------------------------------------- */
   for each lgi_lgmstr exclusive-lock:
      delete lgi_lgmstr.
   end.

   for each lgil_lgdet exclusive-lock:
      delete lgil_lgdet.
   end.

   for each lgilx_lgdet exclusive-lock:
      delete lgilx_lgdet.
   end.

   for each lgit_lgdet exclusive-lock:
      delete lgit_lgdet.
   end.

   for each lgitx_lgdet exclusive-lock:
      delete lgitx_lgdet.
   end.
END PROCEDURE.
