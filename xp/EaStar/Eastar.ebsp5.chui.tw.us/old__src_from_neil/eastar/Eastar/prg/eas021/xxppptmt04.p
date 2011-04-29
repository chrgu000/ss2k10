/* ppptmt04.p - PART ENGINEERING MAINTENANCE                            */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* REVISION: 6.0      LAST MODIFIED: 08/08/90   BY: emb  *D001*/
/*           7.2                     03/22/95   by: srk *F0NN**/
/*           8.6                     05/20/98   by: *K1Q4* Alfred Tan   */
/*           9.1                     08/13/00   by: *N0KQ* myb          */
/* REVISION: EB       LAST MODIFIED: 01/20/03   BY: *EAS003* Leemy Lee        */



/*F0NN*   {mfdeclre.i} */
/*F0NN*/  {mfdtitle.i "b+ "}


          define new shared variable ppform as char.

          ppform = "a".
/*EAS021*            {gprun.i ""ppptmta.p""}*/
          {gprun.i ""xxppptmta.p""}
