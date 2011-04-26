/* xxlbldmt.p - Label Detail Maintenance                                      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* This is the maintenance program for the lbld_det table                     */
/*                                                                            */
/* Revision: 9.1   BY: Dennis Taylor       DATE:01/31/00         *N08T*       */
/* Revision: 9.1   By: Jean Miller         DATE:05/27/00         *N0CK*       */
/* REVISION: 9.1   LAST MODIFIED: 08/14/00 BY: *N0L1* Mark Brown              */
/* Revision: 1.8   BY: Katie Hilbert       DATE: 11/13/01   ECO: *P00B*       */
/* $Revision: 1.9  BY: zhangyun      DATE: 04/26/11  remove must run in menu  */
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */
/*V8:RunMode=Character,Windows                                                */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE  */
{mfdtitle.i "14YQ"}

/* LOGICALS  */
define variable del-yn like mfc_logical initial no no-undo.

/* DISPLAY SELECTION FORM */
form
   lbld_fieldname colon 25 format "x(35)"
   lbld_execname  colon 25 format "x(14)"
   skip(1)
   lbld_term      colon 25 skip
   lbl_long       colon 25
   lbl_medium     colon 25
   lbl_short      colon 25
   lbl_stacked    colon 25
with frame a side-labels width 80 attr-space.

/* EXTERNALIZED LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:

   ststatus = stline[3].
   status input ststatus.

   prompt-for
      lbld_fieldname
      lbld_execname
   editing:
      if frame-field = "lbld_fieldname" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i
            lbld_det
            lbld_fieldname
            lbld_fieldname
            lbld_execname
            lbld_execname
            lbld_fieldname}
      end.
      if frame-field = "lbld_execname" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp01.i
            lbld_det
            lbld_execname
            lbld_execname
            lbld_fieldname
            "input lbld_fieldname"
            lbld_fieldname}
      end.

      if recno <> ? then do:

         find lbl_mstr where lbl_lang = global_user_lang and
                             lbl_term = lbld_term
         no-lock no-error.

         display
            lbld_fieldname
            lbld_execname
            lbld_term
            lbl_long    when (available lbl_mstr)
            lbl_medium  when (available lbl_mstr)
            lbl_short   when (available lbl_mstr)
            lbl_stacked when (available lbl_mstr).

         if not available lbl_mstr then
         display
            "" @ lbl_long
            "" @ lbl_medium
            "" @ lbl_short
            "" @ lbl_stacked.

      end. /* if recno <> ? then do: */
   end. /* prompt-for editing: */

   if input lbld_fieldname = "" then do:
      /* BLANK NOT ALLOWED  */
      {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
      undo mainloop, retry.
   end.

   /* First check to make sure the user isn't trying to create/modify/delete  */
   /* a label detail record for a browse or lookup.  This isn't allowed since */
   /* the browse needs to be regenerated when the labels change.              */
   /* Label detail records needed for browse programs are automatically       */
   /* created, when necessary, by Browse Maint in the 92 Release and above.   */
   if length(lbld_execname:screen-value) = 9
      and (substring(lbld_execname:screen-value,3,2) = "br"
      or substring(lbld_execname:screen-value,3,2) = "lu")
   then do:
      /* Labels for Browse fields can only be modified through Browse Maint. */
      {pxmsg.i &MSGNUM=2000 &ERRORLEVEL=3}
      undo mainloop, retry.
   end.  /* then do: */
/*****
   if input lbld_execname <> "" and
      not can-find(first mnd_det where mnd_exec = input lbld_execname) and
      not can-find(first mnds_det where mnds_exec_sub = input lbld_execname) and
      not can-find(first flh_mstr where flh_exec = input lbld_execname) and
      not can-find(first drl_mstr where drl_exec = input lbld_execname)
   then do:
      /* INVALID PROGRAM. ONLY MENU LEVEL PGMS CAN BE ACCESSED */
      {pxmsg.i &MSGNUM=2291 &ERRORLEVEL=3}
      next-prompt lbld_execname with frame a.
      undo mainloop, retry.
   end.  /* then do: */
*****/
   /* ADD/MOD/DELETE  */
   find first lbld_det where
      lbld_fieldname = input lbld_fieldname and
      lbld_execname = input lbld_execname
      exclusive-lock no-error.

   if not available lbld_det then do:
      /* ADDING NEW RECORD  */
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create lbld_det.
      assign
         lbld_fieldname
         lbld_execname.
   end. /* if not available lbld_det then do: */

   /* STORE MODIFY DATE AND USERID */
   assign
      lbld_mod_date = today
      lbld_mod_userid = global_userid.

   find lbl_mstr where
      lbl_lang = global_user_lang and
      lbl_term = lbld_term no-lock no-error.
   if not available lbl_mstr then
   display
      "" @ lbl_long
      "" @ lbl_medium
      "" @ lbl_short
      "" @ lbl_stacked.

   display
      lbld_fieldname
      lbld_execname
      lbld_term
      lbl_long    when (available lbl_mstr)
      lbl_medium  when (available lbl_mstr)
      lbl_short   when (available lbl_mstr)
      lbl_stacked when (available lbl_mstr).

   recno = recid(lbld_det).

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   seta:
   do on error undo, retry:
      set
         lbld_term
      go-on("F5" "DELETE")with frame a editing:

         /* CUSTOM NEXT/PREV DOES NOT RESET STATUS LINE */
         /* WHICH ALLOWS DELETION OF RECORDS.           */
         readkey.
         hide message no-pause.

         /* FIND NEXT RECORD */
         if lastkey = keycode("F10")
          or keyfunction(lastkey) = "CURSOR-DOWN"
         then do:
            if recno = ? then
            find first lbl_mstr where lbl_term >=  input lbld_term
             and lbl_lang = global_user_lang use-index lbl_term
            no-lock no-error.
            else find next lbl_mstr use-index lbl_term no-lock no-error.
            if not available lbl_mstr then do:
               /* END OF FILE */
               {pxmsg.i &MSGNUM=20 &ERRORLEVEL=2}
               if recno = ? then
                  find last lbl_mstr where lbl_term <= input lbld_term
                  and lbl_lang  = global_user_lang use-index lbl_term
                  no-lock no-error.
               else if recno <> ? then
                  find lbl_mstr where recno = recid(lbl_mstr) no-lock no-error.
               input clear.
            end.
            recno = recid(lbl_mstr).
         end.

         /* FIND PREVIOUS RECORD  */
         else
         if lastkey = keycode("F9")
          or keyfunction(lastkey) = "CURSOR-UP"
         then do:
            if recno = ? then
             find last lbl_mstr where lbl_term <= input lbld_term
              and lbl_lang = global_user_lang
             use-index lbl_term no-lock no-error.
            else find prev lbl_mstr use-index lbl_term no-lock no-error.
            if not available lbl_mstr then do:
               /* Beginning of file */
               {pxmsg.i &MSGNUM=21 &ERRORLEVEL=2}
               if recno = ? then
                  find first lbl_mstr where lbl_term >= input lbld_term
                  and lbl_lang = global_user_lang use-index lbl_term
                  no-lock no-error.
               else if recno <> ? then
                  find lbl_mstr where recno = recid(lbl_mstr) no-lock no-error.
               input clear.
            end.
            recno = recid(lbl_mstr).
         end.

         /* DELETE */
         else
         if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
         then do:
            del-yn = yes.
            /* PLEASE CONFIRM DELETE */
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
            if not del-yn then undo seta.
            else do:
               delete lbld_det.
               clear frame a.
               del-yn = no.
               next mainloop.
            end. /* if del-yn then do: */
         end.

         /* INPUT PROMPT FIELD */
         else do:
            recno = ?.
            if keyfunction(lastkey) = "end-error" then do:
               ststatus = stline[3].
               status input ststatus.
            end.
            apply lastkey.
         end.

         if recno <> ? then do:
            display
               lbl_term @ lbld_term
               lbl_long
               lbl_medium
               lbl_short
               lbl_stacked
            with frame a.
         end.

      end. /* set lbld_term with frame a editing. */

      /* VALIDATE TERM EXISTS */
      find lbl_mstr where lbl_term = lbld_term
         and lbl_lang = global_user_lang no-lock no-error.
      if not available lbl_mstr then do:
         /* LABEL TERM DOES NOT EXIST */
         {pxmsg.i &MSGNUM=3459 &ERRORLEVEL=3}
         undo seta, retry.
      end. /* if not available lbl_mstr then do: */
      else do:
         lbld_term = lbl_term.
         display
            lbld_term
            lbl_long
            lbl_medium
            lbl_short
            lbl_stacked.
      end. /* else do: */

   end. /* do on error undo, retry: */

end. /* repeat with frame a: */

status input.
