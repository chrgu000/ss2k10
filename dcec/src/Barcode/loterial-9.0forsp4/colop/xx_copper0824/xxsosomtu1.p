/* xxsosomtu1.p - SALES ORDER MAINTENANCE INVENTORY UPDATE SUBROUTINE          */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.14.2.6 $                                                     */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*               */
/* REVISION: 7.3      LAST MODIFIED: 11/04/92   BY: afs *G262*               */
/* REVISION: 7.2      LAST MODIFIED: 01/27/94   BY: afs *FL76*               */
/* REVISION: 7.3      LAST MODIFIED: 01/13/95   BY: dpm *F0DR*               */
/* REVISION: 8.5      LAST MODIFIED: 09/01/95   BY: *J04C* Sue Poland        */
/* REVISION: 8.6      LAST MODIFIED: 11/01/97   BY: *K15N* Jerry Zhou        */
/* REVISION: 8.6      LAST MODIFIED: 02/04/98   BY: *K1FW* Jim Williams      */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* REVISION: 8.6E     LAST MODIFIED: 07/15/98   BY: *L024* Sami Kureishy     */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *N0CG* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision:  1.14.2.5      BY: Ellen Borden  DATE: 10/15/01  ECO: *P004*    */
/* $Revision: 1.14.2.6 $    BY: Katie Hilbert DATE: 01/06/03  ECO: *P0LN*    */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

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

define input parameter reason-code like rsn_code.
define input parameter tr-cmtindx  like tr_fldchg_cmtindx.

define new shared variable old_site       like sod_site.
define new shared variable new_site       like si_site.
define new shared variable change_db      as logical.
define     shared variable all_days       as integer.
define     shared variable line           like sod_line.
define     shared variable sngl_ln        like soc_ln_fmt.
define     shared variable so_recno       as recid.
define     shared variable sod_recno      as recid.
define     shared variable sod-detail-all like soc_det_all.
define     shared variable totallqty      like sod_qty_all.
define     shared variable so_db          like dc_name.
define     shared variable inv_db         like dc_name.
define     shared variable exch-rate      like exr_rate.
define     shared variable exch-rate2     like exr_rate2.

define variable err-flag        as integer.
define variable sodnbr          like sod_nbr  no-undo.
define variable sodline         like sod_line no-undo.
define variable mc-error-number like msg_nbr  no-undo.

define new shared stream hs_so.
define new shared frame hf_so_mstr.
define new shared frame hf_sod_det.
define new shared frame hf_rma_mstr.
define new shared frame hf_rmd_det.
define new shared temp-table tt_exru_usage like exru_usage.

{sosobdef.i "new" }

FORM /*GUI*/  so_mstr  with overlay frame hf_so_mstr THREE-D /*GUI*/.

FORM /*GUI*/  sod_det  with overlay frame hf_sod_det THREE-D /*GUI*/.

FORM /*GUI*/  rma_mstr with overlay frame hf_rma_mstr THREE-D /*GUI*/.

FORM /*GUI*/  rmd_det  with overlay frame hf_rmd_det THREE-D /*GUI*/.


for first so_mstr
   where recid(so_mstr) = so_recno no-lock:
end. /* FOR FIRST SO_MSTR */

find sod_det
   where recid(sod_det) = sod_recno
exclusive-lock no-error.

assign
   sodnbr  = sod_nbr
   sodline = sod_line.

if so_fsm_type begins "RMA" then do:

   for first rma_mstr
      where rma_nbr    = so_nbr
      and   rma_prefix = "C" no-lock:
   end. /* FOR FIRST RMA_MSTR */

   for first rmd_det
      where rmd_nbr    = sod_nbr
      and   rmd_line   = sod_line
      and   rmd_prefix = "C" no-lock:
   end. /* FOR FIRST RMD_DET */

end.

/* Create a temp-table to hold order bill information */
for each temp_sob exclusive-lock:
   delete temp_sob.
end.

for each sob_det
   where   sob_nbr = sod_nbr
   and     sob_line = sod_line
no-lock:

   create temp_sob.
   assign
      temp_nbr      = sob_nbr
      temp_line     = sob_line
      temp_part     = sob_part
      temp_site     = sob_site
      temp_qty_req  = sob_qty_req
      temp_feature  = sob_feature
      temp_serial   = sob_serial
      temp_bo_chg   = sob_bo_chg
      temp_cmtindx  = sob_cmtindx
      temp_iss_date = sob_iss_date
      temp_loc      = sob_loc
      temp_parent   = sob_parent
      temp_price    = sob_price
      temp_qty_all  = sob_qty_all
      temp_qty_chg  = sob_qty_chg
      temp_qty_pick = sob_qty_pick
      temp_scrp_pct = sob_scrp_pct
      temp_tot_std  = sob_tot_std
      temp_user1    = sob_user1
      temp_user2    = sob_user2
      temp_valid    = no.
end. /* for each sob_det */

/* Find out if we need to change databases */

for first si_mstr
   fields(si_db si_site)
   where si_site = sod_site no-lock:
end. /* FOR FIRST SI_MSTR */

change_db = (si_db <> so_db).

/* Need to copy usage records, but mc-copy-ex-rate-usage doesn't */
/* work across databases, so the following is necessary.         */
/* Clean out temp table and copy all exru_usage to it, for use   */
/* later in sosomtu2.p */
for each tt_exru_usage exclusive-lock:
   delete tt_exru_usage.
end. /* for each tt_exru_usage */
for each exru_usage
   where exru_usage.exru_seq = so_exru_seq
no-lock:
   buffer-copy exru_usage to tt_exru_usage.
end. /* for each exru_usage */

if change_db then do:

   /* Write the sales order to a hidden frame */
   do with frame hf_so_mstr on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

      {mfoutnul.i &stream_name="hs_so"}
      display stream hs_so so_mstr with frame hf_so_mstr.
      display stream hs_so sod_det with frame hf_sod_det.
      if available rma_mstr then do:
         display stream hs_so rma_mstr with frame hf_rma_mstr.
         display stream hs_so rmd_det  with frame hf_rmd_det.
      end.
   end.
/*GUI*/ if global-beam-me-up then undo, leave.


   /* Switch to the Inventory site */
   new_site = sod_site.
   {gprun.i ""gpalias.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


end.

/* Using the temp-table to create sob_det records in remote db */
{gprun.i ""sosobdet.p"" "(sodnbr, sodline)" }
/*GUI*/ if global-beam-me-up then undo, leave.


/* Start a new routine which will use the inventory db alias,
   read in the sales order line from the hidden buffer,
   write it (temporarily) into the new database,
   and motor on as usual */
{gprun.i ""xxsosomtu2.p""
   "(input reason-code,
     input tr-cmtindx)"}
/*GUI*/ if global-beam-me-up then undo, leave.


if change_db then do:

   /* Read cost from remote database */
   /* Convert the cost into so database base curr */

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input  """",
        input  base_curr,
        input  exch-rate,
        input  exch-rate2,
        input  sod_std_cost,
        input  false,
        output sod_std_cost,
        output mc-error-number)"}.
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   /* And finally, switch the database alias back to the sales order db */
   {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.


end.
