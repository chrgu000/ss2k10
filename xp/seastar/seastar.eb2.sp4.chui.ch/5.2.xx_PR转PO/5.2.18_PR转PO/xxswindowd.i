/* swindowd.i - Scrolling Window include file with update                     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.1.3 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION 8.5       LAST MODIFIED: 04/15/97  BY: *J1Q2* Patrick Rowan       */
/* REVISION 8.5       LAST MODIFIED: 10/27/97  BY: *J243* Patrick Rowan       */
/* REVISION 8.6       LAST MODIFIED: 05/20/98  BY: *K1Q4* Alfred Tan          */
/* REVISION 8.6E      LAST MODIFIED: 08/24/98  BY: *L07B* Jean Miller         */
/* REVISION 8.5       LAST MODIFIED: 09/02/98  BY: *J2YD* Patrick Rowan       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00  BY: *N08T* Annasaheb Rahane    */
/* Old ECO marker removed, but no ECO header exists *D663*                    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *F0PX*                    */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00  BY: *N0KN* Mark Brown          */
/* $Revision: 1.5.1.3 $    BY: Jean Miller           DATE: 12/03/01  ECO: *P036*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/******************************************************************************
 * DESCRIPTION: ADDS/MODS/DELETES horizontal requisition approvers.
 * Supports the multi-line Purchase Requisition Module of MFG/PRO.
 *
 * Notes:
 * 1) Input parameters
 * {1} file name    {2} frame name  {3} equality field   {4} equality value
 * {5} scrolling field name {6} field to update  {7}...{14} display fields
 *
 *****************************************************************************/

define variable sw_new          like {5} no-undo.
define variable sw_key1         like {3} no-undo.
define variable sw_key2         like {4} no-undo.
define variable sw_input        as character no-undo.
define variable lines           as integer no-undo.
define variable line_cntr       as integer no-undo.

sw_input = "".

find first {1} no-lock no-error.

if available {1} then
assign
   sw_key1 = {3}
   sw_key2 = {4}
   sw_new = {5}.

/*V8:EditableDownFrame={2}*/
form
   {7}
   {8}
   {9}
   {10}
   {11}
   {12}
   {13}
   {14}
with frame {2} down scroll 1 width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame {2}:handle).

Main-loop:
repeat with frame {2}:

   clear frame {2} all no-pause.

   find first {1} where
      {3} >= sw_key1 and
      {4} >= sw_key2
   no-lock no-error.

   repeat with frame {2}:

      if sw_input = "" then sw_input = trim({5}).

      display
         {7}
         {8}
         {9}
         {10}
         {11}
         {12}
         {13}
         {14}.

      if frame-line = frame-down then leave.

      find next {1} no-lock no-error.

      if not available {1} then leave.

      down 1.

   end.

   assign
      sw_key1 = ?
      sw_key2 = ?
      sw_new = ?.

   repeat on endkey undo, leave Main-loop with frame {2}:

      ststatus = stline[4].
      status default ststatus.

      choose row {5} keys sw_input no-error with frame {2}.

      color display normal {5}.
      pause 0.

      if input {3} <> sw_key1 or
         input {4} <> sw_key2
      then do:
         assign
            sw_key1 = input {3}
            sw_key2 = input {4}
            sw_new = frame-value.
         for first {1} where
            {3} = sw_key1 and
            {4} = sw_key2 no-lock:
         end.
      end.

      if lastkey = keycode("cursor-down") or
         lastkey = keycode("F10")
      then do with frame {2}:
         if sw_new = "" then
            next.
         find next {1} no-lock no-error.
         if not available {1} or sw_new = "" then do:
            find last {1} no-lock no-error.
            next.
         end.
         down 1.
         display
            {7}
            {8}
            {9}
            {10}
            {11}
            {12}
            {13}
            {14}.
         assign
            sw_key1 = {3}
            sw_key2 = {4}
            sw_new = {5}.
         next.
      end.

      if lastkey = keycode("cursor-up") or
         lastkey = keycode("F9")
      then do with frame {2}:

         find prev {1} no-lock no-error.

         if not available {1} then do with frame {2}:
            find first {1} no-lock no-error.
            next.
         end.

         assign
            sw_key1 = {3}
            sw_key2 = {4}
            sw_new = {5}.

         sw_input = "".

         leave.

         up 1.

         display
            {7}
            {8}
            {9}
            {10}
            {11}
            {12}
            {13}
            {14}.

         sw_new = {5}.
         next.

      end.

      if lastkey = keycode("PAGE-DOWN")
      or lastkey = keycode("CTRL-N")
      or lastkey = keycode("CTRL-Z")
      or lastkey = keycode("F8")
      then do with frame {2}:

         sw_input = "".

         do line_cntr = frame-line to frame-down:
            find next {1} no-lock no-error.
            if not available {1} then leave.
            if line_cntr < frame-down then down 1.
         end.

         if not available {1} then do:
            find last {1} no-lock no-error.
            assign
               sw_key1 = {3}
               sw_key2 = {4}
               sw_new = {5}.
            leave.
            next.
         end.

         assign
            sw_key1 = {3}
            sw_key2 = {4}
            sw_new = {5}.

         leave.

      end.

      if lastkey = keycode("PAGE-UP")
      or lastkey = keycode("CTRL-P")
      or lastkey = keycode("CTRL-R")
      or lastkey = keycode("F7")
      then do with frame {2}:

         sw_input = "".

         do line_cntr = frame-line - 1 + frame-down to 1 by -1:
            find prev {1} no-lock no-error.
            if not available {1} then leave.
            if line_cntr > frame-down + 1 then up 1.
         end.

         if not available {1} then do:
            find first {1} no-lock no-error.
            assign
               sw_key1 = {3}
               sw_key2 = {4}
               sw_new = {5}.
            leave.
            next.
         end.

         assign
            sw_key1 = {3}
            sw_key2 = {4}
            sw_new = {5}.

         leave.

      end.

      if keyfunction(lastkey) = "go" then
         leave Main-loop.

      if keyfunction(lastkey) = "return" and
         frame-value = ""
      then
         leave Main-loop.

     /* if keyfunction(lastkey) = "return" and
         frame-value > ""
      then do:
         update {6}.
         next.
      end. */

      if sw_input <> "" then do:

         find first {1} where trim({5}) begins sw_input no-lock no-error.
         if available {1} then do:
            frame-value = {5}.
            assign
               sw_key1 = {3}
               sw_key2 = {4}
               sw_new = {5}.
            leave.
         end.

         if length(sw_input) > 1 then do:
            sw_input = substring(sw_input,length(sw_input)).
            find first {1} where trim({5}) begins sw_input no-lock no-error.
            if available {1} then do:
               frame-value = {5}.
               assign
                  sw_key1 = {3}
                  sw_key2 = {4}
                  sw_new = {5}.
               leave.
            end.
         end.

         sw_input = "".

         /* Input data matches no record */
         {pxmsg.i &MSGNUM=73 &ERRORLEVEL=2}

         input clear.

         find first {1} where
            {3} = sw_key1 and
            {4} = sw_key2
         no-lock no-error.

         if available {1} then sw_input = trim({5}).

      end.

   end.

end.
