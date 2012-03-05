/* dsdomt02.p - DISTRIBUTION ORDER PROCESSING                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.11 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* $Revision: 1.11 $    BY: Samir Bavkar       DATE: 07/31/01 ECO: *P009*     */

/* DISPLAY TITLE */
{mfdtitle.i "b+ "}

define variable order_nbr    like dss_nbr                     no-undo.
define variable ship_site    like dss_shipsite                no-undo.
define variable rec_site     like dss_rec_site                no-undo.
define variable do_maint     like mfc_logical  initial yes    no-undo.
define variable do_ship      like mfc_logical  initial yes    no-undo.
define variable got_dss_mstr as   logical                     no-undo.
define variable l_ordnbr     like dss_nbr                     no-undo.
define variable l_shipsite   like dss_shipsite                no-undo.
define variable l_recsite    like dss_shipsite                no-undo.

/* INPUT FORM */
form
   order_nbr colon 20
   ship_site label "Ship-From"
   rec_site
   skip(1)
   do_maint  colon 45 label "Maintain Distribution Orders"
   do_ship   colon 45 label "Ship Distribution Orders"
   skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

mainloop:
repeat:

   do transaction on error undo, retry:
      display
         do_maint
         do_ship
      with frame a.

      prompt-for
         order_nbr
         ship_site
      with frame a
      editing:

         if frame-field = "order_nbr" then do:
            /* FIND NEXT/PREVIOUS  RECORD */
            {mfnp.i dss_mstr order_nbr dss_nbr order_nbr dss_nbr dss_nbr}

            if recno <> ? then
               display
                 dss_nbr        @ order_nbr
                 dss_shipsite   @ ship_site
                 dss_rec_site   @ rec_site
               with frame a.

         end.
         else
         /* PREVENT THE USER FROM EXITING THE ORDER NUMBER FIELD WHILE IT  */
         /* IS BLANK AND AUTO NUMBER IS NO IN THE DRP CONTROL FILE.        */
         if frame-field = "ship_site" and input order_nbr = "" then do:
            find first drp_ctrl no-lock no-error.
            if not available drp_ctrl or not drp_auto_nbr then do:
               {pxmsg.i &MSGNUM = 40 &ERRORLEVEL = 3} /* BLANK NOT ALLOWED */
               next-prompt order_nbr with frame a.
               undo, retry.
            end.

            run getNextDO (input-output order_nbr).

         end.
         else if frame-field = "ship_site" then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp01.i dss_mstr ship_site dss_shipsite order_nbr
               dss_nbr dss_nbr}

            if recno <> ? then
               display
                  dss_shipsite @ ship_site
               with frame a.
         end.
         else do:
            readkey.
            apply lastkey.
         end.

      end. /* PROMPT-FOR EDITING BLOCK */

      /* VALIDATE ORDER AND SHIP-SITE */
      if input order_nbr = "" then do:
         find first drp_ctrl no-lock no-error.
         if not available drp_ctrl or not drp_auto_nbr then do:
            {pxmsg.i &MSGNUM = 40 &ERRORLEVEL = 3} /* BLANK NOT ALLOWED */
            undo, retry.
         end.

         run getNextDO (input-output order_nbr).
      end.

      find si_mstr no-lock where si_site = input ship_site no-error.
      if not available si_mstr then do:

         if input ship_site = "" then
            display global_site @ ship_site with frame a.

         find si_mstr no-lock where si_site = global_site no-error.
         if not available si_mstr then do:
            {pxmsg.i &MSGNUM = 708 &ERRORLEVEL = 3} /* SITE DOES NOT EXIST */
            next-prompt ship_site with frame a.
            undo, retry.
         end.
      end.

      /* CHECK SITE SECURITY */
      if available si_mstr then do:
         {gprun.i ""gpsiver.p""
            "(input si_site, input recid(si_mstr), output return_int)"}
      end.
      else do:
         {gprun.i ""gpsiver.p""
            "(input (input ship_site), input ?, output return_int)"}
      end.

      if return_int = 0 then do:
         /*USER DOES NOT HAVE ACCESS TO THIS SITE */
         {pxmsg.i &MSGNUM = 725 &ERRORLEVEL = 3}
         next-prompt ship_site with frame a.
         undo mainloop, retry.
      end.

      assign
         l_ordnbr = input order_nbr
         l_shipsite = input ship_site.

   end. /* TRANSACTION */

   run find_dss_mstr
      (input l_ordnbr,
       input l_shipsite,
       output got_dss_mstr).

   if not got_dss_mstr then do:
      /* SHIP-TO SITE */
      do on error undo, retry:
         prompt-for rec_site with frame a
         editing:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i si_mstr rec_site si_site
               rec_site si_site si_site}

            if recno <> ? then display rec_site with frame a.
         end.

         l_recsite = input rec_site.

         find si_mstr no-lock where si_site = input rec_site no-error.
         if not available si_mstr then do:
            {pxmsg.i &MSGNUM = 708 &ERRORLEVEL = 3} /* SITE DOES NOT EXIST */
            undo, retry.
         end.

      end.  /* ship-to input */

   end. /* IF NOT got_dss_mstr */
   else do:
      display
         dss_rec_site @ rec_site
      with frame a.

      l_recsite = dss_rec_site.
   end.

   assign
      do_maint = true
      do_ship  = true.

   update
      do_maint
      do_ship
   with frame a.

   if do_maint then do:
      hide frame a no-pause.

      /* INVOKE DISTRIBUTION ORDER MAINTENANCE SCREEN */
      {gprun.i ""dsdomt2a.p""
               "(input true,           /* Auto DO Processing active */
                 input l_ordnbr,       /* DO Order Number */
                 input l_shipsite,     /* DO Ship Site */
                 input l_recsite)"}    /* DO Receipt Site */

      hide all no-pause.
      view frame dtitle.
   end.

   if do_ship then do:
      run find_dss_mstr
         (input l_ordnbr,
          input l_shipsite,
          output got_dss_mstr).

      if not got_dss_mstr then do:
         if not do_maint then do:
            /* DIST. ORDER DOES NOT EXIST. */
            {pxmsg.i &MSGNUM = 1600 &ERRORLEVEL = 3}
            undo, retry.
         end. /* if not do_maint */
         /* IF A DO WAS DELETED OR A NEW ONE WAS NOT COMPLETED IN DO         */
         /* MAINTENANCE, THEN WE CANNOT PROCEED TO DO SHIPMENTS BECAUSE      */
         /* THERE IS NO DISTRIBUTION ORDER TO PROCESS.                       */
         else
            next mainloop.
      end. /* IF NOT GOT_DSS_MSTR and NOT DO_MAINT */

      hide frame a no-pause.

      /* INVOKE DISTRIBUTION ORDER SHIPMENT SCREEN */
      {gprun.i ""dsdois01.p""
               "(input true,           /* Auto DO Processing active */
                 input l_ordnbr,       /* DO Order Number */
                 input l_shipsite,     /* DO Ship Site */
                 input l_recsite)"}    /* DO Receipt Site */

      hide all no-pause.
      view frame dtitle.
   end.

end.

/***************** INTERNAL PROCEDURES *********************/

PROCEDURE getNextDO:
   /* -------------------------------------------------------------
   Purpose: This internal procedure gets the next Distribution
   Order number from  the control file.
   ----------------------------------------------------------------*/

   define input-output parameter ord_nbr like dss_nbr no-undo.

   {mfnctrl.i drp_ctrl drp_nbr dss_mstr dss_nbr ord_nbr}

   display
      ord_nbr @ order_nbr
   with frame a.
END PROCEDURE. /* getNextDO */

PROCEDURE find_dss_mstr:
   /* -------------------------------------------------------------
   Purpose: This internal procedure finds dss_mstr record and
   returns the available status.
   ----------------------------------------------------------------*/

   define input parameter p_nbr like dss_nbr no-undo.
   define input parameter p_shipsite like dss_shipsite no-undo.
   define output parameter got_dss_mstr as logical no-undo.

   got_dss_mstr = false.

   find dss_mstr where dss_nbr  = p_nbr and
      dss_shipsite  = p_shipsite
      no-lock no-error.

   if available dss_mstr then
      got_dss_mstr = true.
END PROCEDURE. /* find_dss_mstr */
