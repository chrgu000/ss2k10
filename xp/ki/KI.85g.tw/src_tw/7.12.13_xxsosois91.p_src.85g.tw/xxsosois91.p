/* sosois.p - SALES ORDER SHIPMENT WITH SERIAL NUMBERS                  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 03/14/90   BY: emb *D002**/
/* REVISION: 6.0      LAST MODIFIED: 03/14/90   BY: WUG *D002**/
/* REVISION: 6.0      LAST MODIFIED: 04/30/90   BY: MLB *D021**/
/* REVISION: 6.0      LAST MODIFIED: 12/17/90   BY: WUG *D447**/
/* REVISION: 6.0      LAST MODIFIED: 01/14/91   BY: emb *D313**/
/* REVISION: 6.0      LAST MODIFIED: 02/18/91   BY: afs *D354**/
/* REVISION: 6.0      LAST MODIFIED: 03/18/91   BY: MLB *D443**/
/* REVISION: 6.0      LAST MODIFIED: 04/03/91   BY: afs *D477*   (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 04/08/91   BY: afs *D497**/
/* REVISION: 6.0      LAST MODIFIED: 04/09/91   BY: afs *D510**/
/* REVISION: 6.0      LAST MODIFIED: 05/09/91   BY: emb *D643**/
/* REVISION: 6.0      LAST MODIFIED: 05/28/91   BY: emb *D661**/
/* REVISION: 6.0      LAST MODIFIED: 06/04/91   BY: emb *D673**/
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040**/
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: MLV *F029**/
/* REVISION: 7.0      LAST MODIFIED: 11/13/91   BY: WUG *D887**/
/* REVISION: 7.0      LAST MODIFIED: 11/18/91   BY: WUG *D858**/
/* REVISION: 7.0      LAST MODIFIED: 11/18/91   BY: WUG *D953**/
/* REVISION: 7.0      LAST MODIFIED: 11/25/91   BY: SAS *F017**/
/* REVISION: 7.0      LAST MODIFIED: 02/19/91   BY: afs *F209*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 02/26/92   BY: afs *F240*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 03/05/92   BY: afs *F247*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 03/18/92   BY: TMD *F263*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 03/26/92   BY: dld *F297*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 04/08/92   BY: tmd *F367*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 04/16/92   BY: tjs *F405*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 05/01/92   BY: afs *F459*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 06/04/92   BY: tjs *F504*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 06/19/92   BY: tmd *F458*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 06/25/92   BY: sas *F595*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 06/29/92   BY: afs *F674*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 06/30/92   BY: tjs *F646*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 07/06/92   BY: tjs *F726*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 07/06/92   BY: tjs *F732*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 07/23/92   BY: tjs *F805*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 07/29/92   BY: emb *F817*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 08/24/92   BY: tjs *F859*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 09/12/92   BY: tjs *G035*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 09/25/92   BY: tjs *G087*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 10/21/92   BY: afs *G218*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 10/21/92   BY: afs *G219*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 11/09/92   BY: emb *G292*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 11/09/92   BY: afs *G302*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 11/16/92   BY: tjs *G318*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 01/12/92   BY: tjs *G536*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 01/26/93   BY: afs *G595*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 02/09/93   BY: bcm *G424*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 02/19/93   BY: tjs *G702*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 03/12/93   BY: tjs *G451*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 03/18/93   BY: afs *G818*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 04/12/93   BY: tjs *G935*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 04/13/93   BY: tjs *G946*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 04/26/93   BY: WUG *GA39*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 05/05/93   BY: afs *GA57*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 05/19/93   BY: kgs *GB22*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 05/19/93   BY: kgs *GB24*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 06/09/93   BY: sas *GB82*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 07/01/93   BY: cdt *GC90*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 07/02/93   BY: jjs *GC96*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 07/02/93   BY: jjs *H019*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 07/03/93   BY: bcm *H002*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 08/13/93   BY: dpm *H069*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 10/4/93    BY: dpm *H075*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 10/28/93   BY: dpm *H067*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 11/14/93   BY: afs *H222*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 11/22/93   BY: tjs *H237*   (rev only) */
/* REVISION: 8.5      LAST MODIFIED: 06/13/96   BY: *G1Y6* Sue Poland       */

/*
{mfdtitle.i "c+ "}  /*H237*/
*/

/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090707.1 By: Roger Xiao */


/*----rev description-------------------------------------------------------------------------------------*/

/* SS - 090707.1 - RNB
    sosoisc2.p : �O�_�o�XINVOICE? 
    sosois.p  --> sosoism.p  --> sosoisc.p  --> sosoisc2.p 
SS - 090707.1 - RNE */





{mfdtitle.i "090707.1"}





{sosois1.i new}

/*G1Y6*/ /* PREVIOUSLY, THE USER COULD SHIP SO'S OR RMA'S WITH SOSOIS.P.   */
         /* NOW, ONLY SO'S MAY BE SHIPPED WITH SOSOIS.P.  RMA'S ARE        */
         /* SHIPPED IN FSRMASH.P.                                          */
/*G1Y6* /*F017*/ sorec = fssormaship.   */
/*G1Y6*/ sorec = fssoship.

/* SS - 090707.1 - B 
/*F017*/ {gprun.i ""sosoism.p""}
   SS - 090707.1 - E */
/* SS - 090707.1 - B */
        {gprun.i ""xxsosoism91.p""}
/* SS - 090707.1 - E */