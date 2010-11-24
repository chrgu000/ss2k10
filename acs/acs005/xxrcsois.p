/* xxrcsois.p - Release Management Customer Schedules - Confirm Shipper      */
/* REVISION: 1.0      LAST MODIFIED: 09/25/10   BY: zy                       */
/*-Revision end--------------------------------------------------------------*/

{mfdtitle.i "100921.1"}

define new shared variable confirm_mode like mfc_logical no-undo.

confirm_mode = yes.

{gprun.i ""xxrcsois1.p""}
