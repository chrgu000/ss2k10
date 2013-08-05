/* sccsru01.p - BOM COST ROLL-UP FOR SIMULATION SETS                    */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 7.0     LAST MODIFIED: 01/18/92    BY: pma *F206*          */
/* REVISION: 7.2     LAST MODIFIED: 11/09/92    BY: emb *G294*          */
/* REVISION: 7.3     LAST MODIFIED: 02/18/93    BY: emb *G700*          */
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KN* myb              */


     {mfdeclre.i}

     define new shared variable transtype as character format "x(7)".

     {gplabel.i &ClearReg=yes} /* EXTERNAL LABEL INCLUDE */

     transtype = "SC".
     {gprun.i ""xxbmcsru.p""}
