/* GUI CONVERTED from sosomtu1.p (converter v1.69) Thu Apr 18 10:36:21 1996 */
/* sosomtu1.p - SALES ORDER MAINTENANCE INVENTORY UPDATE SUBROUTINE     */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040**/
/* REVISION: 7.3      LAST MODIFIED: 11/04/92   BY: afs *G262**/
/* REVISION: 7.2      LAST MODIFIED: 01/27/94   BY: afs *FL76**/
/* REVISION: 7.3      LAST MODIFIED: 01/13/95   BY: dpm *F0DR**/
/* REVISION: 8.5      LAST MODIFIED: 09/01/95   BY: *J04C* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 11/14/03   BY: *LB01* Long Bo         */

/******************************************************************
* This routine handles database manipulation required for
* centralized sales order processing, then calls so..u2 to
* perform the inventory and planning database updates.
*
* If the sales order is in a different database from the
* inventory for this line, this routine writes the sales order
* header and current line to shared (hidden) buffers and sets
* the alias to the inventory database.  The following routine
* (sosomtu2.p) reads the sales order information from the
* buffers and updates the inventory database.
******************************************************************/

{mfdeclre.i}


define shared variable all_days as integer.
define shared variable line like sod_line.
define shared variable sngl_ln like soc_ln_fmt.
define shared variable so_recno as recid.
define shared variable sod_recno as recid.
define shared variable sod-detail-all like soc_det_all.
define shared variable totallqty like sod_qty_all.
define new shared variable old_site like sod_site.
define new shared variable new_site like si_site.
define variable create_inmstr like mfc_logical.
define shared variable so_db like dc_name.
define shared variable inv_db like dc_name.
define new shared variable change_db like mfc_logical.
define new shared stream hs_so.
define new shared frame hf_so_mstr.
define new shared frame hf_sod_det.
/*J04C*/ define new shared frame hf_rma_mstr.
/*J04C*/ define new shared frame hf_rmd_det.
/*G262*/ define variable err-flag as integer.
/*F0DR*/ define shared variable  exch-rate like exd_ent_rate.

FORM /*GUI*/  so_mstr with frame hf_so_mstr THREE-D /*GUI*/.

FORM /*GUI*/  sod_det with frame hf_sod_det THREE-D /*GUI*/.

/*J04C*/ FORM /*GUI*/  rma_mstr with frame hf_rma_mstr THREE-D /*GUI*/.

/*J04C*/ FORM /*GUI*/  rmd_det with frame hf_rmd_det THREE-D /*GUI*/.


find so_mstr where recid(so_mstr) = so_recno.
find sod_det where recid(sod_det) = sod_recno.
find first soc_ctrl no-lock.
find first gl_ctrl no-lock.

/*J04C*/ if so_fsm_type begins "RMA" then do:
/*J04C*/    find rma_mstr where rma_nbr = so_nbr and
/*J04C*/        rma_prefix = "C" no-lock no-error.
/*J04C*/    find rmd_det where rmd_nbr = sod_nbr and
/*J04C*/        rmd_line = sod_line and rmd_prefix = "C" no-lock no-error.
/*J04C*/ end.

/* Find out if we need to change databases */
find si_mstr where si_site = sod_site no-lock.
change_db = (si_db <> so_db).

if change_db then do:

   /* Write the sales order to a hidden frame */
   do with frame hf_so_mstr on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

      {mfoutnul.i &stream_name="hs_so"}
      display stream hs_so so_mstr with frame hf_so_mstr.
      display stream hs_so sod_det with frame hf_sod_det.
/*J04C*/ if available rma_mstr then do:
/*J04C*/    display stream hs_so rma_mstr with frame hf_rma_mstr.
/*J04C*/    display stream hs_so rmd_det  with frame hf_rmd_det.
/*J04C*/ end.
   end.
/*GUI*/ if global-beam-me-up then undo, leave.


   /* Switch to the Inventory site */
   new_site = sod_site.
   {gprun.i ""gpalias.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


end.

/* Start a new routine which will use the inventory db alias,
   read in the sales order line from the hidden buffer,
   write it (temporarily) into the new database,
   and motor on as usual */
   
/*LB01*/
{gprun.i ""zzsosomtu2.p""}

/*GUI*/ if global-beam-me-up then undo, leave.


if change_db then do:

/*FL76*/ /* Read cost from remote database */
/*F0DR*/ /* convert the cost into so datbase base curr */
/*F0DR*  assign sod_std_cost.*/
/*F0DR*/ assign sod_std_cost = sod_std_cost * exch-rate .

   /* And finally, switch the database alias back to the sales order db */
/*G262** new_site = global_site.  **/
/*G262** {gprun.i ""gpalias.p""}  **/
/*G262*/ {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.


end.
