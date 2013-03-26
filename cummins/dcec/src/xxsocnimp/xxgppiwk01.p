/* gppiwk01.p - CREATE PRICING WORKFILE FROM pih_hist                   */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.4.1.4 $                                                         */
/* REVISION: 8.5      LAST MODIFIED: 02/22/95   BY: afs *J042**/
/* REVISION: 8.5      LAST MODIFIED: 07/11/95   BY: DAH *J05C**/
/* REVISION: 8.5      LAST MODIFIED: 09/11/95   BY: DAH *J07S**/
/* REVISION: 8.5      LAST MODIFIED: 05/07/96   BY: DAH *J0LL**/
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6      LAST MODIFIED: 08/11/98   BY: *J2VZ* Surekha Joshi*/
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb          */
/* Revision: 1.4.1.3    BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00F* */
/* $Revision: 1.4.1.4 $    BY: Prajakta Patil        DATE: 11/27/07  ECO: *P6F0*  */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* This routine creates wkpi_wkfl records for a sales order line from
   existing entries for manual price overrides in Pricing History (pih_hist).
   (Only manual overrides are needed because all other records will
   be regenerated as price is recalculated).

   This routine does not affect the pih_hist records.

   INPUTS:

   Price List workfile
   doc type (1 = so
         2 = qo
         3 = po
         4 = fsm thingie)
   order number

   OUTPUT:

   No returned variables.
   wkpi_wkfl records are created.

   A TYPICAL CALL:

      {gprun.i ""gppiwk01.p"" "(1,
                so_nbr,
                so_line,
)" }

*/
/*V8:ConvertMode=Maintenance                                            */
{mfdeclre.i}

define input parameter doc_type like pih_doc_type.
define input parameter ord_nbr  like pih_nbr.
define input parameter line_nbr like pih_line.

{pppiwkpi.i}  /* Shared workfile for Price Lists used */

define variable list_price like sod_list_pr.

/* Make sure workfile is empty */
/* (This probably isn't necessary, but at least null loops are fast) */

for each wkpi_wkfl
exclusive-lock:
   delete wkpi_wkfl.
end. /* FOR EACH wkpi_wkfl */

/* Delete manual discount from pih_hist if it is due to the coverage */

/* NOTE: sod__qadd01 contains the coverage discount percent.         */

if doc_type = 1
then do:
   find first pih_hist
      where pih_hist.pih_domain = global_domain
      and   pih_doc_type        = doc_type
      and   pih_nbr             = ord_nbr
      and   pih_line            = line_nbr
      and   pih_parent          = ""
      and   pih_feature         = ""
      and   pih_option          = ""
      and   pih_amt_type        = "2"
      and   pih_source          = "1"
   no-lock no-error.
   if available pih_hist
   then do:
      find sod_det
         where sod_det.sod_domain = global_domain
         and   sod_nbr            = ord_nbr
         and   sod_line           = line_nbr
      no-lock no-error.

   /* DO NOT DELETE MANUAL OVERRIDE DISCOUNT WHERE USER     */
   /* HAS MANUALLY ENTERED THE ZERO VALUE IN DISCOUNT FIELD */

      if  sod_fsm_type = "RMA-ISS"
      and pih_amt      = sod__qadd01
      and sod__qadd01  <> 0
      then
         delete pih_hist.
   end. /* IF AVAILABLE pih_hist */
end. /* IF doc_type = 1 */
/* Create workfile from pih_hist */
for each pih_hist
   where pih_hist.pih_domain = global_domain
   and   pih_doc_type        = doc_type
   and   pih_nbr             = ord_nbr
   and   pih_line            = line_nbr
/*326   and   pih_source          = "1"       Manual Overrides */
no-lock:
   find first wkpi_wkfl
       where wkpi_amt_type   = pih_amt_type
       and   wkpi_feature    = pih_feature
       and   wkpi_list_id    = pih_list_id
       and   wkpi_option     = pih_option
       and   wkpi_parent     = pih_parent
       and   wkpi_source     = pih_source
       and   wkpi_confg_disc = pih_confg_disc
   exclusive-lock no-error.
   if not available wkpi_wkfl
   then do:
      create wkpi_wkfl.
      assign
         wkpi_amt_type    = pih_amt_type
         wkpi_confg_disc  = pih_confg_disc
         wkpi_feature     = pih_feature
         wkpi_list_id     = pih_list_id
         wkpi_option      = pih_option
         wkpi_parent      = pih_parent
         wkpi_source      = pih_source
         .
   end. /* IF NOT AVAILABLE wkpi_wkfl */
   assign
      wkpi_amt         = pih_amt
      wkpi_break_cat   = pih_break_cat
      wkpi_comb_type   = pih_comb_type
      wkpi_disc_seq    = pih_disc_seq
      wkpi_feature     = pih_feature
      wkpi_list        = pih_list
      wkpi_min_net     = pih_min_net
      wkpi_qty         = pih_qty
      wkpi_pid_qty     = pih_pid_qty
      wkpi_qty_type    = pih_qty_type
      wkpi_um          = pih_um
      .

   /* Manual List Override */
   if pih_amt_type = "1"
   then do:
      assign
         wkpi_srch_type = 1
         wkpi_factor    = 0.
   end. /* IF pih_amt_type = "1" */
   /* Discount Override */
   else do:
      wkpi_srch_type = 2.

      /* Calculate discount factor */
      /* >>> Maybe this should be stored in pih_hist? */
      /* >>> Or it could be passed in.                */

      wkpi_factor = 1 - (pih_amt / 100).

   end. /* IF pih_amt_type <> "1" */

end. /* FOR EACH pih_hist */
