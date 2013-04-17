/* GUI CONVERTED from rcshgwa1.p (converter v1.76) Tue Aug  6 23:16:34 2002 */
/* rcshgwa1.p - Shipper Gateway Container Create                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.9.2.4 $                                                       */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.5      LAST MODIFIED: 03/21/95           BY: GWM *J049*        */
/* REVISION: 8.6      LAST MODIFIED: 09/20/96           BY: TSI *K005*        */
/* REVISION: 8.6      LAST MODIFIED: 10/31/96   BY: *K003* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 12/02/97   BY: *J277* Manish K.          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 11/24/98   BY: *J35C* Surekha Joshi      */
/* REVISION: 8.6E     LAST MODIFIED: 12/23/98   BY: *J375* Surekha Joshi      */
/* REVISION: 9.1      LAST MODIFIED: 07/19/00   BY: *N0GF* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown         */
/* Revision: 1.9.2.3  BY: Jean Miller        DATE: 05/10/02  ECO: *P05V*  */
/* $Revision: 1.9.2.4 $   BY: Seema Tyagi    DATE: 08/05/02  ECO: *N1P1*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* LOCAL VARIABLES */
define variable wt_conv as decimal no-undo.
define variable vol_conv as decimal no-undo.
define variable conv_message as character no-undo.
define variable l_recid  as recid     no-undo.
define variable l_abs_recid   as   recid   no-undo.
define variable l_abs_tare_wt like abs_nwt no-undo.

define variable v_par_recid as   recid       no-undo.
define variable v_inv_mov   like abs_inv_mov no-undo.
define variable v_shipgrp   like sg_grp      no-undo.

/* SHARED VARIABLES */
{rcshgw.i}

/* BUFFERS */
define buffer ship_record for abs_mstr.
define buffer anc_abs_mstr for abs_mstr.

/* Find top-level parent shipper or preshipper */
{gprun.i ""gpabspar.p""
   "(abs_recno, 'PSR', false, output v_par_recid)" }

/* Get the shipper or preshipper */
find ship_record where recid(ship_record) = v_par_recid
no-lock no-error.

v_inv_mov = if available ship_record then ship_record.abs_inv_mov else "".

/* Now find the direct parent */
find ship_record where recid(ship_record) = abs_recno
no-lock no-error.

/* CONTAINERS */
CHECK_CONT:
do:

   find abs_mstr where abs_mstr.abs_domain = global_domain and abs_mstr.abs_shipfrom = ship_from
                   and abs_mstr.abs_id = "C" + ship_id
   no-lock no-error.

   /* VERIFY ONLY */
   if verify_only then do:

      if available abs_mstr then do:
         /* THE CONTAINER IS ON THE SHIPPER: */
         {pxmsg.i &MSGNUM=8294 &ERRORLEVEL=1 &MSGARG1=ship_id}
      end.
      else do:
         /* THE CONTAINER WAS NOT FOUND */
         {pxmsg.i &MSGNUM=8295 &ERRORLEVEL=1 &MSGARG1=ship_id}
      end.

      leave CHECK_CONT.
   end. /* IF VERIFY_ONLY */

   if available abs_mstr then do:
      /* THIS CONTAINER ALREADY EXISTS: */
      {pxmsg.i &MSGNUM=8293 &ERRORLEVEL=4 &MSGARG1=ship_id}
      error_msg = error_msg + 1.
   end.

   find pt_mstr where pt_domain = global_domain and pt_part = ship_part no-lock no-error.

   if not available pt_mstr or ship_part = "" then do:
      /* BAD PART NUMBER IN THE INPUT DATA */
      {pxmsg.i &MSGNUM=8282 &ERRORLEVEL=4}
      error_msg = error_msg + 1.
   end.

   /* ASSIGN ITEM DEFAULTS */

   else do:
      if ship_site    = "" then ship_site    = pt_site.
      if ship_loc     = "" then ship_loc     = pt_loc.
      if ship_wght_um = "" then ship_wght_um = pt_net_wt_um.
      if ship_vol_um  = "" then ship_vol_um  = pt_size_um.
   end.

   /* VALIDATE THE SITE */
   if ship_site <> "" then do:

      find si_mstr where si_domain = global_domain and si_site = ship_site no-lock no-error.
      if not available si_mstr then do:

         /* SITE DOES NOT EXIST */
         {pxmsg.i &MSGNUM=8273 &ERRORLEVEL=4}
         error_msg = error_msg + 1.
      end.

      /* VALIDATE WHETHER AUTO TRANSFER IS ALLOWED */

      if v_inv_mov <> "" and ship_from <> ship_site then do:

         {gprun.i
            ""gpgetgrp.p""
            "(ship_site, ship_from, output v_shipgrp)"}

         if can-find(sg_mstr where sg_domain = global_domain and sg_grp = v_shipgrp and sg_auto_tr = false)
         then do:
            /* AUTOMATIC TRANSFER FROM SITE # TO SITE # PROHIBITED */
            {pxmsg.i &MSGNUM=5845 &ERRORLEVEL=4
                     &MSGARG1=ship_site
                     &MSGARG2=ship_from}
            error_msg = error_msg + 1.
         end.  /* if can-find */
      end.  /* if v_inv_mov */

   end.

   /* VALIDATE THE LOCATION */
   if ship_loc <> "" then do:

      find loc_mstr where loc_domain = global_domain and loc_site = ship_site
                      and loc_loc = ship_loc
      no-lock no-error.

      if not available loc_mstr then do:
         /* LOCATION DOES NOT EXIST AT THIS SITE */
         {pxmsg.i &MSGNUM=8292 &ERRORLEVEL=4}
         error_msg = error_msg + 1.
      end.

   end.

   if ship_to = "" and ship_parent <> ""
                   and available ship_record
   then
      ship_to = ship_record.abs_shipto.

   /* NO ERRORS */
   if error_msg = 0 then do:

      /* UPDATE ABS_SHP_DATE WITH SYSTEM DATE. THIS WILL CREATE TAX */
      /* DETAIL RECORDS (TX2D_DET) DURING SHIPPER CONFIRM.          */
      create abs_mstr.
      assign
         abs_mstr.abs_shipfrom = ship_from
         abs_mstr.abs_id = "c" + ship_id
         abs_mstr.abs_par_id = ship_parent
         abs_mstr.abs_item = ship_part
         abs_mstr.abs_site = ship_site
         abs_mstr.abs_loc = ship_loc
         abs_mstr.abs_lot = ship_lot
         abs_mstr.abs_ref = ship_ref
         abs_mstr.abs_qty = 1
         abs_mstr.abs__qad02 = "EA"
         abs_mstr.abs_shipto = ship_to
         abs_mstr.abs__qad04 = ship_kanban
         abs_mstr.abs_wt_um = ship_wght_um
         abs_mstr.abs_vol_um = ship_vol_um
         abs_mstr.abs_vol = decimal(ship_vol)
         abs_mstr.abs_shp_date = today
         abs_mstr.abs_type = ship_type.
/*james*/ ASSIGN ABS_mstr.ABS_user1 = ship_via.

      if recid(abs_mstr) = -1 then.

      l_abs_recid = recid(abs_mstr).

      /* FIND TOP-LEVEL PARENT SHIPPER */
      {gprun.i ""gpabspar.p""
         "(abs_recno,
           'S' ,
           false ,
           output l_recid)" }

      /* TYPE IS SET TO "S" IF NO PARENT RECORD FOUND                   */
      /* TYPE OF CHILD RECORD IS SET ACCORDINGLY IF PARENT RECORD FOUND */
      if l_recid = ? then
         abs_mstr.abs_type = "S".
      else do:
         find anc_abs_mstr where recid(anc_abs_mstr) = l_recid
         exclusive-lock no-error.
         if anc_abs_mstr.abs_type = "R" then
            abs_mstr.abs_type = "R" .
         else
            abs_mstr.abs_type = "S".
      end. /* L_RECID <> ? */

      /* DETERMINE WEIGHT, VOLUME CONVERSION */
      wt_conv = 1.

      if pt_ship_wt_um <> abs_mstr.abs_wt_um then do:
         {gprun.i ""gpumcnv.p""
            "(input pt_ship_wt_um, input abs_mstr.abs_wt_um,
              input abs_mstr.abs_item, output wt_conv)"}
         if wt_conv = ? then wt_conv = 1.
      end.

      vol_conv = 1.

      if pt_size_um <> abs_mstr.abs_vol_um then do:
         {gprun.i ""gpumcnv.p""
            "(input pt_size_um, input abs_mstr.abs_vol_um,
              input abs_mstr.abs_item, output vol_conv)"}
         if vol_conv = ? then vol_conv = 1.
      end.

      if ship_tare_wt = "" then
         l_abs_tare_wt = pt_ship_wt * wt_conv.
      else
         l_abs_tare_wt = decimal(ship_tare_wt).

      {abspack.i "abs_mstr" 26 22 "l_abs_tare_wt"}

      if ship_vol = "" then
         abs_mstr.abs_vol = pt_size * vol_conv.

      find ship_record where ship_record.abs_domain = global_domain
                         and ship_record.abs_shipfrom = ship_from
                         and ship_record.abs_id = ship_parent
      exclusive-lock no-error.

      /* ROLL UP THE WEIGHTS, VOLUME */
      WEIGHTS:
      repeat while available ship_record:

         if ship_record.abs_vol_um = "" then
            ship_record.abs_vol_um = abs_mstr.abs_vol_um.

         /* DETERMINE VOLUME UM CONVERSION */
         vol_conv = 1.

         if ship_record.abs_vol_um <> abs_mstr.abs_vol_um then do:
            {gprun.i ""gpumcnv.p""
               "(input abs_mstr.abs_vol_um, input ship_record.abs_vol_um,
                 """",output vol_conv)"}

            if vol_conv = ? then vol_conv = 1.
         end.

         /* ADD TO CURRENT WEIGHTS */
         assign
            ship_record.abs_vol =
            ship_record.abs_vol + abs_mstr.abs_vol * vol_conv.

         if ship_record.abs_par_id <> "" then do:

            find abs_mstr where recid(abs_mstr) = recid(ship_record)
            no-lock.

            find ship_record
               where ship_record.abs_domain = global_domain
                 and ship_record.abs_shipfrom = abs_mstr.abs_shipfrom
                 and ship_record.abs_id = abs_mstr.abs_par_id
            exclusive-lock no-error.

         end.

         else leave WEIGHTS.

      end. /* WEIGHTS */

      for first abs_mstr
         fields (abs_id abs_inv_mov abs_item abs_loc abs_lotser abs_par_id
                 abs_qty abs_ref abs_shipfrom abs_shipto abs_shp_date
                 abs_site abs_type abs_vol abs_vol_um abs_wt_um abs__qad02
                 abs__qad04 abs__qad10)
         where recid(abs_mstr) = l_abs_recid
      no-lock: end.

      if available abs_mstr then do:
         /* ROLL-UP TARE WT TO GROSS WT. ONLY */
         {gprun.i ""icshnwt.p"" "(input recid(abs_mstr),
              input l_abs_tare_wt,
              input no,
              input abs_mstr.abs_wt_um)"}
      end. /* IF AVAILABLE ABS_MSTR */

      /* CONTAINER ADDED: */
      {pxmsg.i &MSGNUM=8296 &ERRORLEVEL=1 &MSGARG1=ship_id}

   end. /* IF ERROR_MSG = 0 */

   else do:
      /* # ERRORS OCCURRED # NOT ADDED */
      {pxmsg.i &MSGNUM=766 &ERRORLEVEL=4
               &MSGARG1 = string(error_msg)
               &MSGARG2 = getTermLabel(""CONTAINER"",20)}
   end.

end. /* CHECK_CONT */
