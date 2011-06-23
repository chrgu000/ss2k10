/* swindowb.i - Scrolling Window Include File With Update                     */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6.1.13 $                                                       */
/* REVISION: 5.0    LAST MODIFIED: 03/21/90     BY: EMB                       */
/* REVISION: 5.0    LAST MODIFIED: 08/27/90     BY: EMB                       */
/* REVISION: 6.0    LAST MODIFIED: 11/11/91     BY: emb *D920*                */
/* REVISION: 7.0    LAST MODIFIED: 06/01/92     BY: emb *F611*                */
/* REVISION: 7.3    LAST MODIFIED: 09/16/94     BY: pxd *FR47*                */
/* REVISION: 7.3    LAST MODIFIED: 02/22/95     BY: smp *F0JW*                */
/* REVISION: 7.3    LAST MODIFIED: 03/17/95     BY: JPM *G0GY*                */
/* REVISION: 7.3    LAST MODIFIED: 03/24/95     BY: aed *G0J9*                */
/* REVISION: 7.3    LAST MODIFIED: 04/10/96     BY: dxb *G1Q3*                */
/* REVISION: 8.5    LAST MODIFIED: 11/08/97     BY: *J25R* Thomas Fernandes   */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98     BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E   LAST MODIFIED: 08/24/98     BY: *L07B* Jean Miller        */
/* REVISION: 9.1    LAST MODIFIED: 09/05/00     BY: *N0RF* Mark Brown         */
/* REVISION: 9.1    LAST MODIFIED: 08/11/00     BY: *N0K2* Phil DeRogatis     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.6.1.5     BY: Jean Miller         DATE: 12/03/01  ECO: *P036*  */
/* Revision: 1.6.1.8     BY:John Pison           DATE: 03/31/03  ECO: *N2C3*  */
/* Revision: 1.6.1.11    BY: Ed van de Gevel     DATE: 03/27/03 ECO: *Q005*   */
/* Revision: 1.6.1.12    BY: Ken Casey           DATE: 02/19/04 ECO: *N2GM*   */
/* $Revision: 1.6.1.13 $     BY:John Pison      DATE: 01/06/05  ECO: *P32S*  */
/*-Revision end---------------------------------------------------------------*/

/*V8:ConvertMode=Maintenance                                                  */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

define variable sw_constant as character.
define variable sw_new      as character.
define variable sw_input    as character.
define variable sw_save     as character.
define variable sw_recid    as recid.
define variable lines       as integer no-undo.
define variable iii         as integer.
define variable record_ids  as recid extent 25.
define variable desktopInsertMode as logical no-undo.

/* SS - 20080905.1 - B */
DEF VAR v_display5 LIKE ld_qty_oh .
/* SS - 20080905.1 - E */

status default
stline[4].

assign
   sw_input = ?
   sw_save = {&equality}
   sw_constant = {&equality}.

if {&record-id} <> ? then
   find {&file} no-lock where recid({&file}) = {&record-id} no-error.
else
   find first {&file} {&use-index} no-lock
   where {&domain} {&search} = sw_constant {&other-search} no-error.

if available {&file} then sw_new = {&scroll-field}.
if available {&file} then sw_recid = recid({&file}).

/*V8:EditableDownFrame={&framename}*/
form with frame {&framename} {&downline} down scroll 1 {&frame-attr}.
setFrameLabels(frame {&framename}:handle).

main-loop:
repeat with frame {&framename}:

   clear frame {&framename} all no-pause.
   record_ids = ?.

   if sw_recid <> ? then
      find {&file} where recid({&file}) = sw_recid no-lock no-error.
   else
      find first {&file} {&use-index}
         where {&domain} {&search} = sw_constant {&other-search}
         and {&scroll-field} >= sw_new
      no-lock no-error.

   if available {&file} then
   repeat with frame {&framename}:

      /* SS - 20080905.1 - B */
      v_display5 = - {&display5}.
      /* SS - 20080905.1 - E */

      display
         /*V8! space(1) */
         {&display1} /*V8! {&spc1} */
         {&display2} /*V8! {&spc2} */
         {&display3} /*V8! {&spc3} */
         {&display4} /*V8! {&spc4} */
         /* SS - 20080905.1 - B */
         v_display5 @ {&display5} /*V8! {&spc5} */
         /* SS - 20080905.1 - E */
         {&display6} /*V8! {&spc6} */
         {&display7} /*V8! {&spc7} */
         {&display8} /*V8! {&spc8} */
         {&display9} /*V8! {&spc9} */
         /*V8! space(1) */ .

      record_ids[frame-line] = recid({&file}).

      if frame-line = frame-down then leave.

      find next {&file} {&use-index}
         where {&domain} {&search} = sw_constant {&other-search} no-lock no-error.

      if not available {&file} then leave.

      down 1.

   end. /* if available {&file} */

   else
      display with frame {&framename}.

   do iii = frame-line to frame-down - 1 with frame {&framename}:
      down 1.
   end.

   do iii = 1 to frame-down - 1 with frame {&framename}:
      if {&record-id} <> ? and frame-line = 2 then leave.
      up 1.
   end.

   sw_new = ?.

   repeat on endkey undo, leave main-loop with frame {&framename}:

      {&record-id} = ?.
      sw_recid = ?.

      /* For Desktop reposition the cursor to top line */
      if {gpiswrap.i} then
         up frame-line - 1.

      /* Identify context for QXtend */
      {gpcontxt.i
         &STACKFRAG = 'iclad01,woisrc01,wowoisrc'
         &FRAME = '{&framename}' &CONTEXT = 'CHOOSE'}

      choose row {&scroll-field} keys sw_input no-error
      with frame {&framename}.

      /* Clear context for QXtend */
      {gpcontxt.i
         &STACKFRAG = 'iclad01,woisrc01,wowoisrc'
         &FRAME = '{&framename}'}

      color display normal {&scroll-field}
      with frame {&framename}.

      find {&file} where recid({&file}) = record_ids[frame-line]
      no-lock no-error.

      pause 0.

      /* CURSOR DOWN */
      if lastkey = keycode("CURSOR-DOWN")
      or lastkey = keycode("F10")
      then do with frame {&framename}:

         if frame-line < frame-down then do with frame {&framename}:
            sw_input = "".
            down 1.
            next.
         end.

         if record_ids[frame-down] = ? then next.

         find {&file} no-lock
            where recid({&file}) = record_ids[frame-down] no-error.

         find next {&file} {&use-index}
            where {&domain} {&search} = sw_constant {&other-search}
         no-lock no-error.

         if not available {&file} then do with frame {&framename}:
            find last {&file} {&use-index}
               where {&domain} {&search} = sw_constant {&other-search}
            no-lock no-error.
            down 1.
            do iii = 1 to frame-down - 1:
               record_ids[iii] = record_ids[iii + 1].
            end.
            record_ids[iii] = ?.
            next.
         end.

         down 1.

         /* SS - 20080905.1 - B */
         v_display5 = - {&display5}.
         /* SS - 20080905.1 - E */
   
         display
            /*V8! space(1) */
            {&display1} /*V8! {&spc1} */
            {&display2} /*V8! {&spc2} */
            {&display3} /*V8! {&spc3} */
            {&display4} /*V8! {&spc4} */
            /* SS - 20080905.1 - B */
            v_display5 @ {&display5} /*V8! {&spc5} */
            /* SS - 20080905.1 - E */
            {&display6} /*V8! {&spc6} */
            {&display7} /*V8! {&spc7} */
            {&display8} /*V8! {&spc8} */
            {&display9} /*V8! {&spc9} */
            /*V8! space(1) */ .

         sw_new = {&scroll-field}.
         sw_recid = recid({&file}).

         do iii = 1 to frame-down - 1:
            record_ids[iii] = record_ids[iii + 1].
         end.

         record_ids[frame-line] = sw_recid.

         next.

      end. /* CURSOR-DOWN */

      /* CURSOR - UP */
      if lastkey = keycode("CURSOR-UP")
      or lastkey = keycode("F9")
      then do with frame {&framename}:

         sw_input = "".

         if frame-line > 1 then do with frame {&framename}:
            up 1.
            next.
         end.

         if not available {&file} then next.

         find prev {&file} {&use-index}
            where {&domain} {&search} = sw_constant {&other-search}
         no-lock no-error.

         if not available {&file} then do with frame {&framename}:
            if {&create-rec} = no then next.
            do iii = frame-down to 2 by -1:
               record_ids[iii] = record_ids[iii - 1].
            end.
            record_ids[1] = ?.
            up 1.
            next.
         end.

         sw_new = {&scroll-field}.
         sw_recid = recid({&file}).
         sw_input = sw_new.

         leave.
         up 1.

         /* SS - 20080905.1 - B */
         v_display5 = - {&display5} .
         /* SS - 20080905.1 - E */
            
         display
            /*V8! space(1) */
            {&display1} /*V8! {&spc1} */
            {&display2} /*V8! {&spc2} */
            {&display3} /*V8! {&spc3} */
            {&display4} /*V8! {&spc4} */
            /* SS - 20080905.1 - B */
            v_display5 @ {&display5} /*V8! {&spc5} */
            /* SS - 20080905.1 - E */
            {&display6} /*V8! {&spc6} */
            {&display7} /*V8! {&spc7} */
            {&display8} /*V8! {&spc8} */
            {&display9} /*V8! {&spc9} */
            /*V8! space(1) */ .

         sw_new = {&scroll-field}.
         next.

      end. /* CURSOR-UP */

      /* PAGE-DOWN */
      if lastkey = keycode("PAGE-DOWN")
      or lastkey = keycode("CTRL-Z")
      or lastkey = keycode("F8")
      then do with frame {&framename}:

         if record_ids[frame-down] = ? then next.

         sw_input = ?.

         do iii = frame-line to frame-down:
            find next {&file} {&use-index}
               where {&domain} {&search} = sw_constant {&other-search}
            no-lock no-error.
            if not available {&file} then leave.
            if iii < frame-down then down 1.
         end.

         if not available {&file} then do:
            find last {&file} {&use-index}
               where {&domain} {&search} = sw_constant {&other-search}
            no-lock no-error.
            if not available {&file} then leave.
            sw_new = {&scroll-field}.
            sw_recid = recid({&file}).
            leave.
            next.
         end.

         sw_new = {&scroll-field}.
         sw_recid = recid({&file}).

         leave.

      end. /* PAGE-DOWN */

      /* PAGE - UP */
      if lastkey = keycode("PAGE-UP")
      or lastkey = keycode("CTRL-R")
      or lastkey = keycode("F7")
      then do with frame {&framename}:

         sw_input = ?.

         do iii = frame-line - 1 + frame-down to 1 by -1:
            find prev {&file} {&use-index}
               where {&domain} {&search} = sw_constant {&other-search}
            no-lock no-error.
            if not available {&file} then leave.
            if iii > frame-down + 1 then up 1.
         end.

         if not available {&file} then do:
            find first {&file} {&use-index}
               where {&domain} {&search} = sw_constant {&other-search}
            no-lock no-error.
            if not available {&file} then leave.
            sw_new = {&scroll-field}.
            sw_recid = recid({&file}).
            leave.
            next.
         end.

         sw_new = {&scroll-field}.
         sw_recid = recid({&file}).

         leave.

      end. /* PAGE-UP */

      if record_ids[frame-line] <> ?
         and record_ids[frame-line] <> sw_recid
      then do:
         find {&file} where recid({&file}) = record_ids[frame-line]
         no-lock no-error.
      end.

      else if frame-value <> sw_new then do:
         sw_new = frame-value.
         find first {&file} {&use-index}
            where {&domain} {&scroll-field} = sw_new
            and {&search} = sw_constant {&other-search}
         no-lock no-error.
      end.

      /* Modify to allow batch to drive this screen       */
      if keyfunction(lastkey) = "GO" then leave main-loop.

      if keyfunction(lastkey) = "RETURN"
         and record_ids[frame-line] = ?
         and not {&create-rec} then leave main-loop.

      /* Determine if user used INSERT function in Desktop */
      desktopInsertMode =
         ({gpiswrap.i} and keyfunction(lastkey) = "INSERT-MODE").

      if keyfunction(lastkey) = "GO"
      or keyfunction(lastkey) = "RETURN"
      or desktopInsertMode = true
      then do:

         if (record_ids[frame-line] = ? or desktopInsertMode = true) and
            {&create-rec} then do:

            /* For Desktop HMTL open up a blank line for INSERT */
            if desktopInsertMode then
               scroll from-current down.

            if "{&prompt-for1}" > "" or "{&prompt-for2}" > ""
            or "{&prompt-for3}" > "" or "{&prompt-for4}" > ""
            or "{&prompt-for5}" > "" or "{&prompt-for6}" > ""
            or "{&prompt-for7}" > "" or "{&prompt-for8}" > ""
            or "{&prompt-for9}" > ""
            then
               prompt-for
                  {&prompt-for1}
                  {&prompt-for2}
                  {&prompt-for3}
                  {&prompt-for4}
                  {&prompt-for5}
                  {&prompt-for6}
                  {&prompt-for7}
                  {&prompt-for8}
                  {&prompt-for9}
               with frame {&framename}
               editing:
                  assign
                     {&global_exp1}
                     {&global_exp2}
                     {&global_exp3}
                     {&global_exp4}
                     {&global_exp5}
                     {&global_exp6}
                     {&global_exp7}
                     {&global_exp8}
                     {&global_exp9}.
                  readkey.
                  apply lastkey.
               end. /* prompt-for */

            find first {&file} {&use-index} {&s0}
            using {&prompt-for1} {&s1} and {&prompt-for2} {&s2}
              and {&prompt-for3} {&s3} and {&prompt-for4} {&s4}
              and {&prompt-for5} {&s5} and {&prompt-for6} {&s6}
              and {&prompt-for7} {&s7} and {&prompt-for8} {&s8}
              and {&prompt-for9} {&s9} */
            where {&domain} {&search} = {&equality} {&other-search}
            no-error.

            if not available {&file} then do:
               create {&file}.
               assign
                  {&assign}
                  {&prompt-for1}
                  {&prompt-for2}
                  {&prompt-for3}
                  {&prompt-for4}
                  {&prompt-for5}
                  {&prompt-for6}
                  {&prompt-for7}
                  {&prompt-for8}
                  {&prompt-for9}.
            end.

            {&record-id} = recid({&file}).
            record_ids[frame-line] = recid({&file}).

         end. /* if record_ids */

         if record_ids[frame-line] <> ? then do:

            {&record-id} = record_ids[frame-line].

            find {&file} where recid({&file}) = {&record-id}.

            sw_input = trim({&scroll-field}).

            update
               {&update1}
               {&update2}
               {&update3}
               {&update4}
               {&update5}
               {&update6}
               {&update7}
               {&update8}
               {&update9}.

            set
               {&set1}
               {&set2}
               {&set3}
               {&set4}
               {&set5}
               {&set6}
               {&set7}
               {&set8}
               {&set9}.

            /* For Desktop redisplay the selection list */
            if desktopInsertMode then do:
               sw_recid=?.
               next main-loop.
            end.

            if {&update-leave} then
               leave main-loop.
            else
               next.

         end.

      end. /* if "GO" or "RETURN" */

      if sw_input <> "" then do:
         find first {&file} {&use-index}
            where {&domain} trim({&scroll-field}) begins sw_input
            and {&search} = sw_constant
            {&other-search}
         no-lock no-error.
         if available {&file} then do:
            frame-value = {&scroll-field}.
            sw_new = {&scroll-field}.
            sw_recid = recid({&file}).
            sw_input = sw_new.
            leave.
         end.
         if length(sw_input) > 1 then do:
            sw_input = substring(sw_input,length(sw_input)).
            find first {&file} {&use-index}
               where {&domain} trim({&scroll-field}) begins sw_input
               and {&search} = sw_constant
               {&other-search}
            no-lock no-error.
            if available {&file} then do:
               frame-value = {&scroll-field}.
               sw_new = {&scroll-field}.
               sw_recid = recid({&file}).
               sw_input = sw_new.
               leave.
            end.
         end.

         sw_input = ?.

         /* Input data matches no record */
         {pxmsg.i &MSGNUM=73 &ERRORLEVEL=2}

         input clear.

         find first {&file} {&use-index}
            where {&domain} {&search} = sw_constant
            and {&scroll-field} = sw_new
            {&other-search}
         no-lock no-error.

         if available {&file} then
            sw_input = trim({&scroll-field}).

         if available {&file} then
            sw_recid = recid({&file}).

      end. /* if sw_input <> "" */

   end. /* repeat on endkey */

end. /* main-loop: repeat */

/* Clear context for QXtend */
{gpcontxt.i
   &STACKFRAG = 'iclad01,woisrc01,wowoisrc'
   &FRAME = '{&framename}'}

pause 0.
if program-name(1) <> "fssrup.p" then
   status default.

color display normal {&scroll-field} with frame {&framename}.
hide message no-pause.
