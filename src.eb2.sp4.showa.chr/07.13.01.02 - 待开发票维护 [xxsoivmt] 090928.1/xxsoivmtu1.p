/* soivmtu1.p - SALES ORDER MAINTENANCE INVENTORY UPDATE SUBROUTINE     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*V8:WebEnabled=No*/
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*          */
/* REVISION: 7.0      LAST MODIFIED: 04/15/92   BY: afs *F398*          */
/* REVISION: 7.2      LAST MODIFIED: 01/21/94   BY: afs *FL51*          */
/* REVISION: 7.2      LAST MODIFIED: 01/27/94   BY: afs *FL76*          */
/* REVISION: 7.3      LAST MODIFIED: 01/13/94   BY: dpm *F0DR*          */
/* REVISION: 7.3      LAST MODIFIED: 06/14/95   BY: bcm *F0SR*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton */
/* REVISION: 8.6E     LAST MODIFIED: 07/09/98   BY: *L024* Bill Reckard */
/* REVISION: 8.6E     LAST MODIFIED: 08/25/98   BY: *L06M* Russ Witt    */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb          */

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
/* SS - 090928.1 By: Bill Jiang */
         {mfdeclre.i}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE soivmtu1_p_1 "Comments"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmtu1_p_2 "Qty Allocatable"
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */

         define shared variable line like sod_line.
         define shared variable del-yn like mfc_logical.
         define shared variable prev_due like sod_due_date.
         define shared variable prev_qty_ord like sod_qty_ord.
         define shared variable prev_consume like sod_consume.
         define variable desc1 like pt_desc1.
         define shared variable pcqty like sod_qty_ord.
         define new shared variable cmtindx like cmt_indx.
         define shared variable sodcmmts like soc_lcmmts label {&soivmtu1_p_1}.
         define shared variable amd as character.
         define shared variable undo_all like mfc_logical initial no.
         define shared variable so_recno as recid.
         define shared variable sod_recno as recid.
         define variable old_list_pr like sod_list_pr.
         define variable old_disc like sod_disc_pct.
         define shared variable clines as integer.
         define shared variable ln_fmt like soc_ln_fmt.
         define variable qty_allocatable like in_qty_avail label
          {&soivmtu1_p_2}.
         define new shared variable old_site like sod_site.
         define shared variable so_db like dc_name.
         define shared variable inv_db like dc_name.
         define new shared variable change_db as logical.
         define variable err-flag as integer.
         define new shared stream hs_so.
         define new shared frame hf_so_mstr.
         define new shared frame hf_sod_det.
         define shared variable  exch-rate like exr_rate.
/*L00Y*/ define shared variable  exch-rate2 like exr_rate.
         define new shared variable ord-db-cmtype like cm_type no-undo.
/*L024*/ define variable mc-error-number like msg_nbr no-undo.

/*L024*/ define new shared temp-table tt_exru_usage like exru_usage.

         form so_mstr with overlay frame hf_so_mstr.
         form sod_det with overlay frame hf_sod_det.

         find so_mstr where recid(so_mstr) = so_recno.
         find sod_det where recid(sod_det) = sod_recno.
         find first soc_ctrl no-lock.
         find first gl_ctrl no-lock.

/* Find out if we need to change databases */
find si_mstr where si_site = sod_site no-lock.
change_db = (si_db <> so_db).

         /*! MULTI-DB: USE SHIP-TO CUSTOMER TYPE FOR DEFAULT
         IF AVAILABLE ELSE USE BILL-TO TYPE USED TO
         FIND COGS ACCOUNT IN SOCOST02.p */
         {gprun.i ""gpcust.p"" "( input  so_nbr,
                  output ord-db-cmtype)"}

if change_db then do:

   /* Write the sales order to a hidden frame */
   do with frame hf_so_mstr on error undo, retry:
      {mfoutnul.i &stream_name="hs_so"}
      display stream hs_so so_mstr with frame hf_so_mstr.
      display stream hs_so sod_det with frame hf_sod_det.
   end.

/*L024*/    for each tt_exru_usage exclusive-lock:
/*L024*/       delete tt_exru_usage.
/*L024*/    end. /* for each tt_exru_usage */
/*L024*/    for each exru_usage no-lock
/*L024*/       where exru_usage.exru_seq = so_exru_seq:
/*L024*/       buffer-copy exru_usage to tt_exru_usage.
/*L024*/       if recid(tt_exru_usage) = -1 then.
/*L024*/    end. /* for each exru_usage */

   /* Switch to the Inventory site */
   {gprun.i ""gpalias2.p"" "(sod_site,output err-flag)" }

end.

/* Start a new routine which will use the inventory db alias,
   read in the sales order line from the hidden buffer,
   write it into the new database,
   and motor on as usual */
/* SS - 090928.1 - B
{gprun.i ""soivmtu2.p""}
SS - 090928.1 - E */
/* SS - 090928.1 - B */
{gprun.i ""xxsoivmtu2.p""}
/* SS - 090928.1 - E */
if change_db then do:

         /* Update quantity fields in the SO database */
         /* Convert the cost from inv database base_curr to so database */
         /* Base currency                                               */
         assign
            sod_qty_all
            sod_qty_inv
            sod_qty_ord
            sod_qty_pick
            sod_qty_ship
/*L024*     sod_std_cost = sod_std_cost * exch-rate  */
            sod_qty_chg = 0
            sod_bo_chg  = 0
            .
/*L06M*   BEGIN CODE DELETION...
./*L024*/ {gprunp.i "mcpl" "p" "mc-curr-conv"
.                "(input  base_curr,
.                input  so_curr,
.                input  exch-rate2,
.                input  exch-rate,
.                input  sod_std_cost,
.                input  false,  /* DO NOT ROUND */
.                output sod_std_cost,
.                output mc-error-number)" }
.*L06M*   END CODE DELETION    */
/*L06M*   CONVERT FROM REMOTE BASE CURRENCY TO SO BASE CURRENCY  */
/*L06M*/  {gprunp.i "mcpl" "p" "mc-curr-conv"
              "(input  """",
                input  base_curr,
                input  exch-rate,
                input  exch-rate2,
                input  sod_std_cost,
                input  false,  /* DO NOT ROUND */
                output sod_std_cost,
                output mc-error-number)" }
/*L024*/  if mc-error-number <> 0 then do:
/*L024*/    {mfmsg.i mc-error-number 2}
/*L024*/  end.

   /* And finally, switch the database alias back to the sales order db */
   {gprun.i ""gpalias3.p"" "(so_db,output err-flag)" }

end.
