/* GUI CONVERTED from ppptmt04.p (converter v1.69) Sat Mar 30 01:19:31 1996 */
/* ppptmt04.p - PART ENGINEERING MAINTENANCE                            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 08/08/90   BY: emb  *D001*/
/*           7.2                     03/22/95   by: srk *F0NN**/


/*F0NN*   {mfdeclre.i} */
/*F0NN*/  {mfdtitle.i "f "}


          define new shared variable ppform as char.

          ppform = "a".
          {gprun.i ""zzppptmta.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

