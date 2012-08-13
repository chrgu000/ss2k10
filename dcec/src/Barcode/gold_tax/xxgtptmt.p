/* xxgtptmt.p - PART ENGINEERING MAINTENANCE for Golden Tax                  */
/* COPYRIGHT infopower.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.*/
/* REVISION: 1.0     LAST MODIFIED: 09/20/2000   BY: *ifp007* Frankie Xu     */

/*F0NN*/  {mfdtitle.i "a+ "}

          define new shared variable ppform as char.

          ppform = "a".
          {gprun.i ""xxgtptmta.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

