/* ckbmpkrp3.p - PICK LIST FOR POU                                      */   
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert bmpkrp.p (converter v1.00) Fri Sep 12 08:44:09 1997 */
/* web tag in bmpkrp.p (converter v1.00) Mon Jul 14 17:24:59 1997 */
/*F0PN*/ /*K112*/ /*V8#ConvertMode=WebReport                             */
/*V8:ConvertMode=Report                                        */
/* REVISION: 1.0       LAST MODIFIED: 05/12/86      BY: EMB             */
/* REVISION: 1.0       LAST MODIFIED: 08/29/86      BY: EMB *12 *       */
/* REVISION: 1.0       LAST MODIFIED: 01/29/87      BY: EMB *A19*       */
/* REVISION: 2.1       LAST MODIFIED: 09/02/87      BY: WUG *A94*       */
/* REVISION: 4.0       LAST MODIFIED: 02/24/88      BY: WUG *A175*      */
/* REVISION: 4.0       LAST MODIFIED: 04/06/88      BY: FLM *A193*      */
/* REVISION: 4.0       LAST MODIFIED: 07/11/88      BY: flm *A318*      */
/* REVISION: 4.0       LAST MODIFIED: 08/03/88      BY: flm *A375*      */
/* REVISION: 4.0       LAST MODIFIED: 11/04/88      BY: flm *A520*      */
/* REVISION: 4.0       LAST MODIFIED: 11/15/88      BY: emb *A535*      */
/* REVISION: 4.0       LAST MODIFIED: 02/21/89      BY: emb *A654*      */
/* REVISION: 5.0       LAST MODIFIED: 06/23/89      BY: MLB *B159*      */
/* REVISION: 6.0       LAST MODIFIED: 07/11/90      BY: WUG *D051*      */
/* REVISION: 6.0       LAST MODIFIED: 10/31/90      BY: emb *D145*      */
/* REVISION: 6.0       LAST MODIFIED: 02/26/91      BY: emb *D376*      */
/* REVISION: 6.0       LAST MODIFIED: 08/02/91      BY: bjb *D811*      */
/* REVISION: 7.2       LAST MODIFIED: 10/26/92      BY: emb *G234*      */
/* REVISION: 7.2       LAST MODIFIED: 11/02/92      BY: pma *G265*      */
/* REVISION: 8.6       LAST MODIFIED: 09/27/97      BY: mzv *K0J *      */
/* REVISION: 8.6       LAST MODIFIED: 10/15/97      BY: mur *K112*      */
/*G265***********************************************************************/
/*                     MOVED ENTIRE EXISTING LOGIC                          */
/*                          TO BMPKRPA.P                                    */
/*                                                                          */
/*       (NOTE: THE REPORT PRODUCED IS IDENTICAL TO THE PREVIOUS ONE)       */
/*       (      SEE BMWURPA.P FOR EXAMPLE OF HOW DISPLAYS CAN DIVERGE)      */
/*G265***********************************************************************/

/*G265*/ {mfdeclre.i}
/*G265*/ define new shared variable transtype as character format "x(4)".
/*K112*/ {wbrp01.i}

/*G265*/ transtype = "BM".
/*G265*/ {gprun.i ""xxbmpkrp3a.p""}
/*K112*/ {wbrp04.i}
