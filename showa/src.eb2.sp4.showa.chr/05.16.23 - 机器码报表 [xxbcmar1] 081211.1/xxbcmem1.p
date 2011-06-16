/* mgmemt.p - MENU MAINTENANCE                                                */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.2.6 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 1.0      LAST MODIFIED: 01/03/86   BY: EMB                       */
/* REVISION: 2.0      LAST MODIFIED: 03/12/87   BY: EMB *A41*                 */
/* REVISION: 4.0     LAST EDIT: 12/30/87    BY: WUG *A138* */
/* REVISION: 4.0     LAST EDIT: 03/17/89    BY: WUG *B070* */
/* REVISION: 6.0     LAST EDIT: 08/22/90    BY: WUG *D054* */
/* REVISION: 6.0     LAST EDIT: 06/03/91    BY: WUG *D675* */
/* REVISION: 7.0     LAST EDIT: 10/09/91    BY: WUG *7.0** */
/* REVISION: 7.0     LAST EDIT: 09/19/94    BY: ljm *FR42* */
/* REVISION: 7.3     LAST EDIT: 08/08/95    BY: str *G0TQ* */
/* REVISION: 8.5     LAST EDIT: 11/22/95    BY: *J094* Tom Vogten             */
/* REVISION: 8.5     LAST EDIT: 04/10/97    BY: *J1NV* Jean Miller            */
/* REVISION: 8.6     LAST EDIT: 05/20/98    BY: *K1Q4* Alfred Tan             */
/* REVISION: 9.1     LAST EDIT: 02/25/00    BY: *M0K8* Pat Pigatti            */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00  BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00  BY: *N0KR* Mark Brown          */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00  BY: *N0W9* Mudit Mehta         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.5.2.6 $   BY: Jean Miller        DATE: 05/10/02  ECO: *P05V*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 081210.1 By: Bill Jiang */

/* DISPLAY TITLE */
/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "081210.1"}
{cxcustom.i "MGMEMT.P"}

define variable del-yn like mfc_logical initial no.
define variable newrec like mfc_logical.

define buffer mnddet for mnd_det.
define variable mndnbr like mnd_nbr.

{&MGMEMT-P-TAG1}

form
   lng_lang          colon 20
   /*V8-*/   lng_desc          at 35 no-label /*V8+*/
   /*V8!     lng_desc          at 40 no-label view-as fill-in size 35 by 1 */
   mnd_nbr           colon 20
   /*V8-*/   mnt_label         at 35 no-label format "x(40)" /*V8+*/
   /*V8!     mnt_label         at 40 no-label format "x(40)"
   view-as fill-in size 35 by 1 */
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{&MGMEMT-P-TAG2}

display
   global_user_lang @ lng_lang
with frame a.

repeat:

   prompt-for lng_lang with frame a
   editing:
      {mfnp05.i lng_mstr lng_lang yes lng_lang "input lng_lang"}
      if recno <> ? then do:
         display lng_lang lng_desc with frame a.
      end.
   end.

   find lng_mstr using lng_lang no-lock.

   display
      lng_lang
      lng_desc
   with frame a.

   repeat:

      if mndnbr <> "" then
         find first mnd_det where mnd_exec = mndnbr no-lock no-error.

      prompt-for mnd_nbr with frame a
      editing:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp05.i mnd_det mnd_exec yes mnd_exec "input mnd_nbr"}

         if recno <> ? then do:
            display mnd_exec @ mnd_nbr with frame a.

            find mnt_det where mnt_nbr = mnd_nbr and mnt_select = mnd_select
               and mnt_lang = lng_lang no-lock no-error.
            if available mnt_det then
               display mnt_label with frame a.
            else
               display "" @ mnt_label with frame a.

         end.
      end.

      mndnbr = input mnd_nbr.

      find first mnd_det where mnd_exec = mndnbr no-lock no-error.
      if available mnd_det then do:

         find mnt_det where mnt_nbr = mnd_nbr and
                            mnt_select = mnd_select
                        and mnt_lang = lng_lang
         no-lock no-error.
         if available mnt_det then
            display mnt_label with frame a.
         else
            display "" @ mnt_label with frame a.
      end.

      else
         display "" @ mnt_label with frame a.

      /* SS - 081210.1 - B */
      FIND FIRST mfc_ctrl WHERE mfc_domain = GLOBAL_domain AND mfc_field = "SoftspeedBarcode_Menu" NO-LOCK NO-ERROR.
      IF NOT AVAILABLE mfc_ctrl THEN DO:
         /* No control table record found for */
         {pxmsg.i &MSGNUM=291 &ERRORLEVEL=3}
         UNDO,RETRY.
      END.

      IF NOT mndnbr BEGINS mfc_char THEN DO:
         /* Invalid entry */
         {pxmsg.i &MSGNUM=4509 &ERRORLEVEL=3}
         UNDO,RETRY.
      END.
      /* SS - 081210.1 - E */

      ststatus = stline[2].
      status input ststatus.

      del-yn = no.

      repeat with frame b:

         form
            mnd_select
            mnt_label
            mnd_name
            mnd_exec
            mnd_help
         with frame b width 80 attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).

         prompt-for mnd_select
         editing:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i mnd_det mnd_nbr
               "mnd_nbr = mndnbr" mnd_select "input mnd_select"}

            if recno <> ? then do:
               display mnd_select mnd_name mnd_exec mnd_help.

               find mnt_det where mnt_nbr = mndnbr
                  and mnt_select = input mnd_select
                  and mnt_lang = lng_lang no-lock no-error.
               if available mnt_det then
                  display mnt_label.
               else
                  display "" @ mnt_label.
            end.
         end.

         /* ADD/MOD/DELETE  */
         find mnd_det where mnd_nbr = mndnbr and
                            mnd_select = input mnd_select
         no-error.
         newrec = no.
         if not available mnd_det then do:
            create mnd_det.
            assign mnd_nbr = mndnbr.
            assign mnd_select.
            {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
            newrec = yes.
         end.

         recno = recid(mnd_det).
         del-yn = no.

         ststatus = stline[2].
         status input ststatus.

         display
            mnd_select
            mnd_name
            mnd_exec
            mnd_help.

         find mnt_det where mnt_nbr = mndnbr and
                            mnt_select = input mnd_select
                        and mnt_lang = lng_lang
         no-lock no-error.

         if available mnt_det then
            {&MGMEMT-P-TAG3}
            display mnt_label.
            {&MGMEMT-P-TAG4}
         else
            display "" @ mnt_label.

         do on error undo, retry:

            prompt-for
               mnt_label mnd_name mnd_exec mnd_help
            go-on(F5 CTRL-D).

            if index(input mnt_label,",") > 0 then do:
               /* Commas are not allowed in Menu Labels */
               {pxmsg.i &MSGNUM=1773 &ERRORLEVEL=3}
               next-prompt mnt_label.
               undo, retry.
            end.

            if newrec and can-find(mnd_det using mnd_name) then do:
               {pxmsg.i &MSGNUM=60 &ERRORLEVEL=3}
               next-prompt mnd_name.
               undo, retry.
            end.

            /* DELETE */
            if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
            then do:
               del-yn = yes.
               /* Please confirm delete */
               {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
               if del-yn then do:
                  for each mnt_det
                     where mnt_nbr = mnd_nbr
                       and mnt_select = mnd_select
                  exclusive-lock:
                     delete mnt_det.
                  end.
                  delete mnd_det.
                  clear frame b.
                  del-yn = no.
                  next.
               end.
            end.

            {&MGMEMT-P-TAG5}
            assign mnd_name mnd_exec mnd_help mnd_select.

            find mnt_det where mnt_nbr = mnd_nbr
                           and mnt_select = mnd_select
                           and mnt_lang = lng_lang
            exclusive-lock no-error.

            if not available mnt_det then do:
               create mnt_det.
               assign
                  mnt_nbr = mnd_nbr
                  mnt_select = mnd_select
                  mnt_lang = lng_lang.
            end.

            mnt_label = input mnt_label.

            {&MGMEMT-P-TAG6}
            if mnd_name <> "" then do:
               define variable mndsel as character format "x(10)".
               for each mnddet no-lock where
                        mnddet.mnd_name = mnd_det.mnd_name
                   and (mnddet.mnd_nbr <> mnd_det.mnd_nbr
                     or mnddet.mnd_select <> mnd_det.mnd_select)
               use-index mnd_name:
                  mndsel = mnd_nbr + "." + string(mnd_select).
                  /* Name is also used in menu selection */
                  {pxmsg.i &MSGNUM=290 &ERRORLEVEL=2 &MSGARG1=mndsel}
                  pause.
               end.
            end.

         end.

      end.

   end.

end.

status input.
