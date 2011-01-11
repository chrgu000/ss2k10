/* swselect.i - SCROLLING WINDOW WITH SELECTION TOGGLE INCLUDE FILE           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.4.1.2 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.4    LAST MODIFIED: 08/11/93     by: wep *H105*                */
/*                                 06/14/94     by: wep *GK29*                */
/*                                 08/29/94     by: wep *GL86*                */
/*                                 12/29/95     by: jzs *G1GT*                */
/*                                 03/11/96     by: jzw *G1Q2*                */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98     by: *K1Q4* Alfred Tan         */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00     by: *N0KC* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.4.1.2 $  BY: Jean Miller         DATE: 12/03/01  ECO: *P036*  */
/* By: Neil Gao Date: 07/12/16 ECO: * ss 20071216 *                           */
/* By: zy       Date: 10/11/11 ECO: * ss 20101111 *                *b7*       */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/******************************************************************************
   Usage:
   This include file was copied from swindar.i, only difference being
   that the user can "toggle" to select a record for processing in a
   subsequent module.  The "toggle" feature is activated by the "RETURN"
   and "SPACE-BAR" keys.  The detail file can be updated by adding a
   referenced include file for the special selection processing.

   This include block should be used for display and selection from
   a full-screen-width scrolling region when display information
   is needed from only 1 file.
   This block does not currently allow the user to partially select
   entries in the scrolling region, although the bulk of that code is
   in place (and commented out - look for sw-input).

   Parameters:
     detfile   -    detail file buffer
                    ret: selected record (if any)
     detkey    -    key field in detail file  (include "where" and operator)
     display1  -    reserved for "selection flag" (value that is to be
                    toggled)
     display[2-9] - values displayed in the scrolling region. (optional)
                    NOTE: Master file fields are not displayed condition-
                    ally if it is possible that an associated master file
                    will not exist (as for unapplied cash), the display
                    variable should include a 'when available' clause.
     sel-on    -    value for selection on (e.g. 'yes', "*", etc.
     sel-off   -    value for selection off (e.g. 'no', " ", etc.

     exit-flag -    logical to indicate whether loop should exit if zero
                    or one records are found.
     exitlabel -    label of the loop to leave on endkey (optional)
     framename -    frame for display of scrolling region
     framesize -    number of lines in scrolling region (max 24) (optional)
     index-phrase - index for scrolling region
                    (format "use-index indexname") (optional)
     other-search - additional search criteria (beyond key match)
                    used for detail record selection (optional)
                    record-id - pass: recid of first record to display
                    ret: recid of selected record
     searchkey -    value to match in detail file
     include1  -    include file if special processing is desired on
                    "de-selection" (sel-off) of a record.
     include2  -    include file if special processing is desired on
                    "selection" (sel-on) of a record.
     include3  -    include file if special processing is desired on
                    initial positioning of the cursor on a line.  Useful for
                    things such as displaying info pertaining to a highlighted
                    document, etc.
*b7* noallow   -    not allow edit.
*b7* errmsgnbr -    error message nbr.
     CURSORUP
     CURSORDOWN
****************************************************************************/

define variable sym              as character.
define variable sw_new           as character.
define variable sw_i             as integer.
define variable sw_first_display as logical.
define variable sw_found_recs    as logical.
define variable sw_recid         as recid.
define variable sw_temp_recid    as recid.
define variable sw_frame_recid   as recid extent 25.
define variable sw_temp_new      like sw_new.
define variable ifui as logical.

status default stline[4]. /* Replace old way of doing status-line */

sw_first_display = true.
ifui = {gpiswrap.i}.

/* find the first record to display */
if {&record-id} = ? then
find first {&detfile} {&detkey} {&searchkey}
   {&other-search} {&index-phrase}  no-lock no-error.
else
   find {&detfile} no-lock where recid({&detfile}) = {&record-id} no-error.

if available {&detfile} then do:
   sw_new   = {&scroll-field}.
   sw_recid = recid({&detfile}).
end.

form with frame {&framename} {&framesize} down scroll 1 width 80.

sw-main-loop:
repeat with frame {&framename}:

   clear frame {&framename} all no-pause.
   sw_frame_recid = ?.

   if sw_recid <> ? then
      find {&detfile} where recid({&detfile}) = sw_recid  no-lock no-error.
   else
      find first {&detfile} where {&scroll-field} >= sw_new no-lock no-error.

   sw_found_recs = available({&detfile}).

   if available {&detfile} then do:

      repeat with frame {&framename}:

         if frame-line = 1 then do:
            {&include3}  /*special processing on each record*/
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

         sw_frame_recid[frame-line] = recid({&detfile}).

         if frame-line = frame-down then leave.

         find next {&detfile} {&detkey} {&searchkey}
            {&other-search} {&index-phrase} no-lock no-error.

         if not available {&detfile} then leave.

         down 1.

      end.

   end.

   if not sw_found_recs  and  {&exit-flag}  and sw_first_display
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

      color display messages {&display1} with frame {&framename}.

      find {&detfile} where recid({&detfile}) = sw_frame_recid[frame-line]
      exclusive-lock no-error.

      if available {&detfile} then do:
         {&include3}   /*special processing for each detail line*/
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

      readkey.

      /* Test for Endkey */
      if keyfunction(lastkey) = "end-error" then
         undo sw-scroll-loop, leave sw-main-loop.
      else
         apply lastkey.

      pause 0.

      /* CURSOR DOWN */

      /* NON-STANDARD KEY, NOT IN PROTERMCAP, MUST SPECIFY VALID KEYS */
      if lastkey = keycode("CURSOR-DOWN")
      or lastkey = keycode("F10")    /* F10 NORMALLY MEANS "NEXT" */
      or lastkey = keycode("PF10")   /* ALTERNATE KEY FOR F10 */
      or lastkey = keycode("CTRL-J") /* ALTERNATE KEY FOR F10 */
      then do with frame {&framename}:

         if frame-line <> frame-down then do:
            color display normal {&display1} with frame {&framename}.
            down.
            /*Test to see if at eof*/
            if sw_frame_recid[frame-line] = ? then do:
               up.
               {pxmsg.i &MSGNUM=20 &ERRORLEVEL=2}  /*"End of File"*/
               /*{&cursordown}*/
               if not ifui then input clear.    /*CLEAR TYPEAHEAD*/
               next.
            end.
/*SS 20080522 - B*/
            find {&detfile} where recid({&detfile}) = sw_frame_recid[frame-line]
            exclusive-lock no-error.
            if avail {&detfile} then do:
/*SS 20080522 - E*/
              {&cursordown}
            end.
            next.
         end.

         find {&detfile} where recid({&detfile}) = sw_frame_recid[frame-down]
         no-lock no-error.

         find next {&detfile} {&detkey} {&searchkey}
            {&other-search} {&index-phrase} no-lock no-error.

         if available {&detfile} then do:

            color display normal {&display1} with frame {&framename}.
            pause 0.
            scroll up.

            sw_new = {&scroll-field}.
            sw_recid = recid({&detfile}).

            do sw_i = 1 to frame-down - 1:
               sw_frame_recid[sw_i] = sw_frame_recid[sw_i + 1].
            end.

            sw_frame_recid[frame-down] = sw_recid.

         end.

         else do:
            {pxmsg.i &MSGNUM=20 &ERRORLEVEL=2}  /*"End of File"*/
            if not ifui then input clear.    /*CLEAR TYPEAHEAD*/
         end.
/*SS 20080522*/ if avail {&detfile} then do:
         {&cursordown}
        end.
         next.

      end. /* CURSOR DOWN */

      /* CURSOR UP */

      /* NON-STANDARD KEY, NOT IN PROTERMCAP, MUST SPECIFY VALID KEYS */
      if lastkey = keycode("CURSOR-UP")
      or lastkey = keycode("F9")     /* F9 NORMALLY MEANS "PREVIOUS" */
      or lastkey = keycode("PF9")    /* ALTERNATE KEY FOR F9 */
      or lastkey = keycode("CTRL-K") /* ALTERNATE KEY FOR F9 */
      then do with frame {&framename}:

         if frame-line <> 1 then do:
            color display normal {&display1} with frame {&framename}.
            up.
/*SS 20080522 - B*/
            find {&detfile} where recid({&detfile}) = sw_frame_recid[frame-line]
            exclusive-lock no-error.
            if avail {&detfile} then do:
/*SS 20080522 - E*/
            {&cursorup}
            end.
            next.
         end.

         find {&detfile} where recid({&detfile}) = sw_frame_recid[1]
         no-lock no-error.

         find prev {&detfile} {&detkey} {&searchkey}
            {&other-search} {&index-phrase} no-lock no-error.

         if available {&detfile} then do:
            color display normal {&display1} with frame {&framename}.

            pause 0.
            scroll down.

            sw_new = {&scroll-field}.
            sw_recid = recid({&detfile}).

            do sw_i = frame-down to 2 by -1:
               sw_frame_recid[sw_i] = sw_frame_recid[sw_i - 1].
            end.

            sw_frame_recid[1] = sw_recid.

         end.

         else do:
            {pxmsg.i &MSGNUM=21 &ERRORLEVEL=2} /*"Beginning of file"*/
            if not ifui then input clear.    /*CLEAR TYPEAHEAD*/
         end.
/*SS 20080522*/ if avail {&detfile} then do:
         {&cursorup}
          end.
         next.

      end. /* CURSOR UP */

      /* PAGE DOWN */

      /* NON-STANDARD KEY, NOT IN PROTERMCAP, MUST SPECIFY VALID KEYS */
      if lastkey = keycode("PAGE-DOWN")
      or lastkey = keycode("F8")     /* F8 NORMALLY MEANS "CLEAR" */
      or lastkey = keycode("PF8")    /* ALTERNATE KEY FOR F8 */
      or lastkey = keycode("CTRL-Z") /* ALTERNATE KEY FOR F8 */
      then do with frame {&framename}:

         /* find the next detail (if any exist) */
         if sw_frame_recid[frame-down] <> ? then do:
            find {&detfile} where recid({&detfile}) = sw_frame_recid[frame-down]
            no-lock no-error.
            find next {&detfile} {&detkey} {&searchkey}
               {&other-search} {&index-phrase} no-lock no-error.

            if available {&detfile} then do:
               sw_new = {&scroll-field}.
               sw_recid = recid({&detfile}).
               leave.
            end.
         end.

         {pxmsg.i &MSGNUM=20 &ERRORLEVEL=2}  /*"End of File"*/

         if not ifui then input clear.    /*CLEAR TYPEAHEAD*/

         next.

      end. /* PAGE DOWN */

      /* PAGE UP */
      /* NON-STANDARD KEY, NOT IN PROTERMCAP, MUST SPECIFY VALID KEYS */
      if lastkey = keycode("PAGE-UP")
      or lastkey = keycode("F7")     /* F7 NORMALLY MEANS "RECALL" */
      or lastkey = keycode("PF7")    /* ALTERNATE KEY FOR F7 */
      or lastkey = keycode("CTRL-R") /* ALTERNATE KEY FOR F7 */
      then do with frame {&framename}:

         find {&detfile} where
            recid({&detfile}) = sw_frame_recid[1] no-lock no-error.

         /* count backward a screenful of records */
         do sw_i = 1 to frame-down:

            /* save the old recid in case the find prev doesn't work */
            sw_temp_new = {&scroll-field}.
            sw_temp_recid = recid({&detfile}).

            find prev {&detfile} {&detkey} {&searchkey}
               {&other-search} {&index-phrase} no-lock no-error.

            if not available {&detfile} then do:
               /* if no previous records exist, no scroll */
               if sw_i = 1 then do:
                  {pxmsg.i &MSGNUM=21 &ERRORLEVEL=2}  /*"Beginning of file"*/
                  if not ifui then input clear.    /*CLEAR TYPEAHEAD*/
                  next sw-scroll-loop.
               end.
               /* store the info for the last record found */
               sw_new   = sw_temp_new.
               sw_recid = sw_temp_recid.

               next sw-main-loop.
            end.

         end.

         sw_new   = {&scroll-field}.
         sw_recid = recid({&detfile}).

         leave.

      end. /* PAGE UP */

      /*RETURN or SPACE will toggle "Selected Flag", RETURN will also  */
      /*scroll down                                                    */

      if keyfunction(lastkey) = "return" or
         keyfunction(lastkey) = " "
      then do:
          if {&display1} = {&sel_on} then do:
            {&display1} = {&sel_off}.
            display {&display1}.
            {&include1}
         end.
         else do:
            {&display1} = {&sel_on}.
            display {&display1}.
            {&include2}
/*b7*/      if {&noallow} then do:
/*b7*/         {pxmsg.i &msgnum = {&errmsgnbr} &errorlevel = 3}
/*b7*/         undo,retry.
/*b7*/      end.
         end.

         /*NOW, SCROLL DOWN IF RETURN WAS PRESSED*/
         if keyfunction(lastkey) = "return" or ifui
         then do with frame {&framename}:
            if frame-line <> frame-down then do:
               color display normal {&display1} with frame {&framename}.
               down.
               /*Test to see if at eof*/
               if sw_frame_recid[frame-line] = ? then do:
                  up.
                  {pxmsg.i &MSGNUM=20 &ERRORLEVEL=2}  /*"End of File"*/
                  if not ifui then input clear.    /*CLEAR TYPEAHEAD*/
                  next.
               end.
/*SS 20080925 - B*/
                find {&detfile} where recid({&detfile})
                                    = sw_frame_recid[frame-line]
                no-lock no-error.
                {&CURSORDOWN}
/*SS 20080925 - E*/
               next.
            end.
            find {&detfile} where recid({&detfile})
                                = sw_frame_recid[frame-down]
            no-lock no-error.
            find next {&detfile} {&detkey} {&searchkey}
               {&other-search} {&index-phrase} no-lock no-error.

            if available {&detfile} then do:

               color display normal {&display1} with frame {&framename}.

               pause 0.
               scroll up.

               sw_new = {&scroll-field}.
               sw_recid = recid({&detfile}).

               do sw_i = 1 to frame-down - 1:
                  sw_frame_recid[sw_i] = sw_frame_recid[sw_i + 1].
               end.

               sw_frame_recid[frame-down] = sw_recid.

            end.
            else do:
               {pxmsg.i &MSGNUM=20 &ERRORLEVEL=2}  /*"End of File"*/
               if not ifui then input clear.    /*CLEAR TYPEAHEAD*/
            end.

/*SS 20080925 - B*/
                {&CURSORDOWN}
/*SS 20080925 - E*/
            next.
         end.
      end.

      /* GO - exit scrolling window */
      if keyfunction(lastkey) = "go" then
         leave sw-main-loop.

   end.  /* sw-scroll-loop */

end.  /* sw-main-loop */

status default.
