/* bmpkcc.p - SIMULATED PICKLIST COMPONENT AVAILABILITY CHECK           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/* REVISION: 1.0     LAST EDIT:     05/07/86   BY: EMB                  */
/* REVISION: 1.0     LAST EDIT:     01/29/87   BY: EMB *A19*            */
/* REVISION: 4.0     LAST EDIT:     12/30/87   BY: WUG *A137*           */
/* REVISION: 2.1     LAST EDIT:     01/07/88   BY: RL  *A132*           */
/* REVISION: 4.0     LAST EDIT:     08/03/88   BY: flm *A375*           */
/* REVISION: 4.0     LAST EDIT:     11/04/88   BY: flm *A520*           */
/* REVISION: 4.0     LAST EDIT:     11/15/88   BY: emb *A535*           */
/* REVISION: 4.0     LAST EDIT:     02/21/89   BY: emb *A654*           */
/* REVISION: 5.0     LAST EDIT:     05/03/89   BY: WUG *B098*           */
/* REVISION: 5.0     LAST MODIFIED: 06/23/89   BY: MLB *B159*           */
/* REVISION: 5.0     LAST MODIFIED: 07/27/89   BY: BJJ *B215*           */
/* REVISION: 6.0     LAST MODIFIED: 05/18/90   BY: WUG *D002*           */
/* REVISION: 6.0     LAST MODIFIED: 07/11/90   BY: WUG *D051*           */
/* REVISION: 7.0     LAST MODIFIED: 10/26/92   BY: emb *G234*           */
/* REVISION: 7.2     LAST MODIFIED: 11/02/92   BY: pma *G265*           */
/* REVISION: 8.6     LAST MODIFIED: 10/15/97   BY: mur *K119*           */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn              */

/*G265***********************************************************************/
/*                     MOVED ENTIRE EXISTING LOGIC                          */
/*                          TO BMPKCCB.P                                    */
/*                                                                          */
/*       (NOTE: THE REPORT PRODUCED IS IDENTICAL TO THE PREVIOUS ONE)       */
/*       (      SEE BMWUIQA.P FOR EXAMPLE OF HOW DISPLAYS CAN DIVERGE)      */
/*G265***********************************************************************/
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100531.1  By: Roger Xiao */  /*加计划员等*/



/*G265*/ {mfdeclre.i}
{gplabel.i &ClearReg=yes} /* EXTERNAL LABEL INCLUDE */
/*G265*/ define new shared variable transtype as character format "x(4)".

/*K119*/ {wbrp01.i}

/*G265*/ transtype = "BM".
/* SS - 100531.1 - B 
         {gprun.i ""bmpkccb.p""}
   SS - 100531.1 - E */
/* SS - 100531.1 - B */
         {gprun.i ""xxbmpkccb.p""}
/* SS - 100531.1 - E */

/*K119*/ {wbrp04.i}
