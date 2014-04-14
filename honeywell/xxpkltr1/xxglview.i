/* xxglview.i - SCROLLING WINDOW OF DATABASE VIEW                           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/* $Revision: 1.3.2.14 $    */
/*V8:ConvertMode=Maintenance                                              */

/* $Revision: eB2.1SP5 LAST MODIFIED: 02/14/12 BY: Apple Tam *SS - 20120214.1* */
/* $Revision: eB2.1SP5 LAST MODIFIED: 07/12/12 BY: Jordan Lin *SS - 20120712.1* */

 /*內文無ECO標志*/
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


define variable sym              as character.
define variable sw_new  like {&scroll-field}.
define variable sw_input         as character.
define variable sw_i             as integer.
define variable sw_first_display as logical.
define variable sw_recid         as recid.
define variable sw_frame_recid   as recid extent 25.
define variable sw_temp_new      like sw_new.
define variable sw_temp_recid    like sw_recid.
define variable sw_found_recs    as logical.

status default stline[4].

sw_first_display = true.

/* find the first record to display */
if {&record-id} = ? then
find first {&buffer} where {&domain} {&searchkey} {&index-phrase}
   no-lock no-error.
else
find {&buffer} where recid({&buffer}) = {&record-id}
   no-lock no-error.

if available {&buffer} then do:
   sw_new   = {&scroll-field}.
   sw_recid = recid({&buffer}).
end.

form with frame {&framename} {&framesize} down scroll 1.

sw-main-loop:
repeat with frame {&framename}:
   clear frame {&framename} all no-pause.
   sw_frame_recid = ?.

   if sw_recid <> ? then
      find {&buffer} where recid({&buffer}) = sw_recid  no-lock no-error.
   else
   find first {&buffer} where {&scroll-field} >= sw_new and
      {&domain} {&searchkey} no-lock no-error.

   sw_found_recs = available ({&buffer}).

   /* fill the screen with detail */
   if available {&buffer} then do:
      repeat with frame {&framename}:
         /* Special processing on each rec */
         /* Perform only for the first record upon screen init*/

         if frame-line = 1 or {&logical1} = true then do:
            {&exec_cursor}
         end.

         display
            {&display1}
            {&display2}
            {&display3}
            {&display4}
            {&display5}
            {&display6}
            {&display7}
            {&display8}
            {&display9}.

         sw_frame_recid[frame-line] = recid({&buffer}).
         if frame-line = frame-down then leave.
         find next {&buffer} where {&domain} {&searchkey}
            {&index-phrase} no-lock no-error.

         if not available {&buffer} then leave.
         down 1.
      end.
   end. /* available {&buffer} */

   /* exit loop if display-only flag is set */
&IF DEFINED(display-only) <> 0 &THEN
   if {&display-only} then leave sw-main-loop.
&ENDIF

   if not sw_found_recs and {&exit-flag} and sw_first_display
      then leave sw-main-loop.
   sw_first_display = false.

   do sw_i = frame-line to frame-down - 1 with frame {&framename}:
      down 1.
   end.
   up frame-line - 1.

   sw_new = ?.

   sw-scroll-loop:  /* allow the user to scroll through the frame */
   repeat on endkey undo, leave {&exitlabel} with frame {&framename}:
      {&record-id} = ?.
      sw_recid = ?.
      /*color display input {&display1} with frame {&framename}.*/
      /*color display normal {&display1} with frame {&framename}.*/
      color display message {&display1} with frame {&framename}.

      /*READ THE FILE FOR PROCESSING THE ACTIVE RECORD*/
      find {&buffer} where recid({&buffer}) = sw_frame_recid[frame-line]
         no-lock no-error.
      if available {&buffer} then do:
         {&exec_cursor}

         display
            {&display1}
            {&display2}
            {&display3}
            {&display4}
            {&display5}
            {&display6}
            {&display7}
            {&display8}
            {&display9}.

      end. /* IF AVAILABLE {&buffer} */

      readkey.

      /* Test for Endkey */
      if keyfunction(lastkey) = "end-error" then
         undo sw-scroll-loop, leave {&exitlabel}.
      else
         apply lastkey.

      pause 0.

      /* CURSOR DOWN */
      if keyfunction(lastkey) = "cursor-down"
         or lastkey = keycode("F10")
         then do with frame {&framename}:
         if frame-line <> frame-down then do:
            color display normal {&display1} with frame {&framename}.
            down.
            /*Test to see if at eof*/
            if sw_frame_recid[frame-line] = ? then do:
               up.
               {mfmsg.i 20 2}  /*"End of File"*/
               input clear.    /*CLEAR TYPEAHEAD*/
               next.
            end.
            next.
         end.
         find {&buffer} where recid({&buffer}) = sw_frame_recid[frame-down]
            no-lock no-error.
         find next {&buffer} where {&domain} {&searchkey}
            {&index-phrase} no-lock no-error.

         if available {&buffer} then do:
            color display normal {&display1} with frame {&framename}.
            pause 0.
            scroll up.

            sw_new = {&scroll-field}.
            sw_recid = recid({&buffer}).

            do sw_i = 1 to frame-down - 1:
               sw_frame_recid[sw_i] = sw_frame_recid[sw_i + 1].
            end.
            sw_frame_recid[frame-down] = sw_recid.
         end.
         else do:
            {mfmsg.i 20 2}  /*"End of File"*/
            input clear.    /*CLEAR TYPEAHEAD*/
         end.
         next.
      end.

      /* CURSOR UP */
      if keyfunction(lastkey) = "cursor-up"
         or lastkey = keycode("F9")
         then do with frame {&framename}:
         if frame-line <> 1 then do:
            color display normal {&display1} with frame {&framename}.
            up.
            next.
         end.
         find {&buffer} where recid({&buffer}) = sw_frame_recid[1]
            no-lock no-error.
         find prev {&buffer} where {&domain} {&searchkey} {&index-phrase}
            no-lock no-error.
         if available {&buffer} then do:
            color display normal {&display1} with frame {&framename}.
            pause 0.
            scroll down.

            sw_new = {&scroll-field}.
            sw_recid = recid({&buffer}).
            /* sw_input = ?. */

            do sw_i = frame-down to 2 by -1:
               sw_frame_recid[sw_i] = sw_frame_recid[sw_i - 1].
            end.
            sw_frame_recid[1] = sw_recid.
         end.
         else do:
            {mfmsg.i 21 2} /*"Beginning of file"*/
            input clear.    /*CLEAR TYPEAHEAD*/
         end.
         next.
      end.

      /* PAGE DOWN */
      if keyfunction(lastkey) = "page-down"
         or lastkey = keycode("F8")
         then do with frame {&framename}:
         /* find the next detail (if any exist) */
         if sw_frame_recid[frame-down] <> ? then do:
            find {&buffer} where recid({&buffer}) = sw_frame_recid[frame-down]
               no-lock no-error.
            find next {&buffer} where {&domain} {&searchkey}
               {&index-phrase} no-lock no-error.

            if available {&buffer} then do:
               sw_new = {&scroll-field}.
               sw_recid = recid({&buffer}).
               leave.
            end.
         end.
         {mfmsg.i 20 2}  /*"End of File"*/
         input clear.    /*CLEAR TYPEAHEAD*/
         next.
      end.

      /* PAGE UP */
      if keyfunction(lastkey) = "page-up"
         or lastkey = keycode("F7")
         then do with frame {&framename}:
         /* sw_input = ?. */
         find {&buffer} where
            recid({&buffer}) = sw_frame_recid[1] no-lock no-error.
         /* count backward a screenful of records */
         do sw_i = 1 to frame-down:
            /* save the old recid in case the find prev doesn't work */
            sw_temp_new = {&scroll-field}.
            sw_temp_recid = recid({&buffer}).
            find prev {&buffer} where {&domain} {&searchkey}
               {&index-phrase} no-lock no-error.

            if not available {&buffer} then do:
               /* if no previous records exist, no scroll */
               if sw_i = 1 then do:
                  {mfmsg.i 21 2} /*"Beginning of file"*/
                  input clear.    /*CLEAR TYPEAHEAD*/
                  next sw-scroll-loop.
               end.
               /* store the info for the last record found */
               sw_new   = sw_temp_new.
               sw_recid = sw_temp_recid.
               next sw-main-loop.
            end.
         end.
         sw_new   = {&scroll-field}.
         sw_recid = recid({&buffer}).
         leave.
      end.

      /* GO - exit scrolling window */
      if keyfunction(lastkey) = "go"  or  keyfunction(lastkey) = "return" or keyfunction(lastkey) = "F1"  /*F1*/
 /*SS - 20120712.1  */
 /*
  *       or keyfunction(lastkey) = "return" /*enter*/
  *       or keyfunction(lastkey) = " "  /*space*/
*/
      then do:

         /* set the record id and buffer to the selected */
         /* record (if any) */
         if sw_frame_recid[frame-line] <> ? then do:
            color display normal {&display1} with frame {&framename}.
            {&record-id} = sw_frame_recid[frame-line].
            {&first-recid} = sw_frame_recid[1].
            find {&buffer} where recid({&buffer}) = {&record-id} no-lock no-error.

         end.
          leave sw-main-loop. 
      end.
      /* ANY other key - perform alpha-search */

   end.  /* sw-scroll-loop */
end.  /* sw-main-loop */

status default.
/* end of swview */
