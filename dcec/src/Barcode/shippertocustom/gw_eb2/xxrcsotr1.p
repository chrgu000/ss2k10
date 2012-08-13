/* xxrcsotr.p - Shipper Transfer to Customer In Transaction Location */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* REVISION: 9.0    LAST MODIFIED: 06/09/04 BY: *K003* Vinay Nayak-Sujir  */
/* REVISION: 9.0    LAST MODIFIED: 06/20/04 BY: *K1Q4* Alfred Tan         */

     /* SHIPPER TRANSFER TO CONSIGNMENT LOCATION */

     {mfdtitle.i "a+ "}
     define new shared variable transfer_mode like mfc_logical no-undo.

     transfer_mode = yes.

     {gprun.i ""xxrcsotru1.p""}

/*GUI*/ if global-beam-me-up then undo, leave.


