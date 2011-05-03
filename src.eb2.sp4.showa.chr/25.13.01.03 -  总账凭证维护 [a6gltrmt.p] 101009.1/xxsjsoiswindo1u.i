/* windo1u.i - SCROLLING WINDOW INCLUDE FILE                                  */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8.1.8 $                                                       */
/* REVISION: 7.3    LAST MODIFIED: 06/20/94     BY: WUG *GK60*                */
/* REVISION: 7.3    LAST MODIFIED: 06/20/94     BY: WUG *GK86*                */
/* REVISION: 7.3    LAST MODIFIED: 12/28/94     BY: jpm *G0B1*                */
/* REVISION: 7.3    LAST MODIFIED: 01/11/95     BY: qzl *F0DH*                */
/* REVISION: 7.3    LAST MODIFIED: 02/20/95     BY: dxk *F0JN*                */
/* REVISION: 7.0    LAST MODIFIED: 03/07/95     BY: aed *F0LY*                */
/* REVISION: 7.0    LAST MODIFIED: 03/28/95     BY: jpm *F0PG*                */
/* REVISION: 7.0    LAST MODIFIED: 07/07/95     BY: jym *G0RZ*                */
/* REVISION: 7.0    LAST MODIFIED: 07/07/95     BY: jym *G0S4*                */
/* REVISION: 7.3    LAST MODIFIED: 03/20/96     BY: pcb *G1R1*                */
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98     BY: *L007* A. Rahane          */
/* REVISION: 8.6E   LAST MODIFIED: 04/20/98     BY: *K1NN* Suresh Nayak       */
/* REVISION: 8.6E   LAST MODIFIED: 10/04/98     BY: *J314* Alfred Tan         */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00     BY: *N0KC* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.8.1.2   BY: Murali Ayyagari       DATE: 10/01/01  ECO: *N132*  */
/* Revision: 1.8.1.4   BY: John Pison       DATE: 02/08/02  ECO: *N18V*  */
/* Revision: 1.8.1.7   BY: Inna Fox         DATE: 08/28/02  ECO: *P0H2*  */
/* $Revision: 1.8.1.8 $  BY: Robert Jensen    DATE: 02/10/2004  ECO: *N2PP*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */
/*!
SCROLLS ON A SINGLE INDEX.

THIS VERSION IS INTENDED TO BE RUN WITHIN AN APPLICATION PROGRAM
NOT AS AN F2 POPUP.  THUS IT EXITS ONLY WHEN THE USER PRESSES F4.
THIS REQUIRES windo1u1.i TO FOLLOW IT.  IN BETWEEN windo1u.i AND
windo1u1.i YOU SANDWICH THE CODE TO EXECUTE WHEN THE USER SELECTS
A RECORD.
*/
/*!
      {1} = file name
      {2} = list of fields to display in frame. Must include
            indexed field #1
      {3} = indexed field #1 name
      {4} = indexed field #1 use-index e.g. "use-index pt_part"
      {5} = additional search criteria or "yes" if no
            additional search criteria
      {6} = command(s) to execute when highlighting a line
      {7} = command(s) to execute when the cursor is repositioned
                to a different line in the frame.
*/
/*!
Assumptions:
   1.  Indexed field is the highest order variant field,
       that is it is either the highest order index field
       or all higher order index fields will not vary
       due to the additional search criteria
*/

{pxgblmgr.i}
    /*
define shared variable window_row as integer.
define shared variable window_down as integer.  
define shared variable global_recid as recid.
*/
define variable partial_ixval as character no-undo.
define variable partial_ixlen as integer no-undo.
define variable ix1array as character extent 25 no-undo.
define variable recidarray as recid extent 25 no-undo.
define variable ixlastline as integer no-undo.
define variable i as integer no-undo.
define variable wtemp3 as character no-undo.
define variable spcs as character
   initial "                                                   ".

/*
define shared variable stline as character format "x(78)" extent 13.
define shared variable ststatus as character format "x(78)".
*/
define variable c-spbar-msg as character format "x(78)" no-undo.
define variable savedStatus     as character no-undo.

{pxmsg.i &MSGNUM=8809 &ERRORLEVEL=1
         &MSGBUFFER=c-spbar-msg}
hide message no-pause.
/*V8-*/
status input off.
status default stline[4].

/*V8+*/
/*V8!
ststatus = stline[4].
status input ststatus.  */

if {gpiswrap.i} then
   assign
      savedStatus = ststatus
      ststatus = stline[1].

find first {1} where {5} no-lock no-error.

if not available {1} then do:
   {pxmsg.i &MSGNUM=2767 &ERRORLEVEL=1
            &MSGARG1=""{1}""}
   status default c-spbar-msg.
   readkey.
   return.
end.

do with frame w:
   clear frame w all no-pause.
   ixlastline = 0.
   find first {1} where {5} {4} no-lock no-error.

   do while available {1} with frame w:
      ixlastline = ixlastline + 1.
      ix1array[ixlastline] = {3}.
      recidarray[ixlastline] = recid({1}).
      /*V8-*/ display  {2}. /*V8+*/
      /*V8!   display space(1) {2} space(1). */

      if frame-line = frame-down then leave.
      find next {1} where {5} {4} no-lock no-error.

      if available {1} then down 1.
   end. /* DO WHILE AVAILABLE {1} WITH FRAME w */

   partial_ixval = substring(ix1array[1] + spcs,1,partial_ixlen).
   up ixlastline - 1.
   color prompt messages {3}.
   {6}
end.  /* DO WITH FRAME w */
{7}

prompt-for {3} with frame w
editing:
   do i = 1 to partial_ixlen:
      apply keycode("CURSOR-RIGHT").
   end.

   readkey.
   leave.
end.  /* END OF {3} WITH FRAME w EDITING */

do while lastkey = 8 or (lastkey >= 32 and lastkey <= 256)
      or lastkey = keycode("CURSOR-UP") or lastkey = keycode("CURSOR-DOWN")
      or lastkey = keycode("F9") or lastkey = keycode("F10")
      or lastkey = keycode("CURSOR-LEFT")
      or lastkey = keycode("CURSOR-RIGHT")
      or lastkey = keycode("F7") or lastkey = keycode("F8")
      or lastkey = 18 or lastkey = 26
      or keyfunction(lastkey) = "GO" or keyfunction(lastkey) = "RETURN"
      or keyfunction(lastkey) = "HELP"
      or keyfunction(lastkey) = "INSERT-MODE"
   with frame w:
   
   if {gpiswrap.i} and  keyfunction(lastkey) = "HELP"
   then
      apply lastkey.
   else
   if lastkey = 8 or lastkey = keycode("CURSOR-LEFT") then do:
      if partial_ixlen > 0 then partial_ixlen = partial_ixlen - 1.
      partial_ixval = substring(partial_ixval + spcs,1,partial_ixlen).
   end.  /* END OF IF LASTKEY = 8 */
   else if lastkey = keycode("CURSOR-RIGHT") then do:
      if length(ix1array[frame-line]) > partial_ixlen then do:
         partial_ixlen = partial_ixlen + 1.
         partial_ixval = substring(ix1array[frame-line]
                                   + spcs,1,partial_ixlen).
      end.
   end. /* END OF IF LASTKEY = KEYCODE("CURSOR-RIGHT") */
   else if lastkey >= 32 and lastkey <= 256 then do:
      partial_ixval = partial_ixval + chr(lastkey).
      partial_ixlen = partial_ixlen + 1.

      if partial_ixval > ix1array[ixlastline]
         or partial_ixval < ix1array[1]
      then do:
         find first {1} where {3} >= partial_ixval and {5} {4}
         no-lock no-error.

         if available {1} then do:
            if {3} = ix1array[1] then do:
               up frame-line - 1.
               color prompt messages {3}.
               partial_ixval = substring(ix1array[1]
                                         + spcs,1,partial_ixlen).
            end.
            else do:
               clear frame w all no-pause.
               ixlastline = 0.

               find first {1} where {3} >= partial_ixval
                  and {5} {4} no-lock no-error.

               do while available {1} with frame w:
                  ixlastline = ixlastline + 1.
                  ix1array[ixlastline] = {3}.
                  recidarray[ixlastline] = recid({1}).

                  /*V8-*/ display  {2}. /*V8+*/
                  /*V8!   display space(1) {2} space(1). */
                  if frame-line = frame-down then leave.
                  find next {1} where {5} {4} no-lock no-error.
                  if available {1} then down 1.
               end.  /* DO WHILE AVAILABLE {1} WITH FRAME w */

               partial_ixval = substring(ix1array[1]
                                         + spcs,1,partial_ixlen).
               up ixlastline - 1.
               color prompt messages {3}.
            end. /* END OF ELSE DO */
         end. /* END OF IF AVAILABLE {1} */
         else do:
            if partial_ixlen > 1 then
               partial_ixlen = partial_ixlen - 1.

            partial_ixval = substring(partial_ixval
                                      + spcs,1,partial_ixlen).
         end. /* END OF ELSE DO */
      end. /* END OF IF partial_ixval > ix1array[ixlastline] */
      else do:
         i = 1.

         do while ix1array[i] < partial_ixval:
            i = i + 1.
         end.
         up frame-line - i.
         color prompt messages {3}.
         partial_ixval = substring(ix1array[i] + spcs,1,partial_ixlen).
      end. /* END OF ELSE DO */
      {7}
   end. /* END OF IF LASTKEY >= 32 AND LASTKEY <= 256  */
   else if lastkey = keycode("CURSOR-UP") or lastkey = keycode("F9")
   then do:
      if frame-line = 1 then do:
         find {1} where recid({1}) = recidarray[1] no-lock no-error.
         find prev {1} where {5} {4} no-lock no-error.
	
         if available {1} then do:
            clear frame w all no-pause.
            ixlastline = 0.
             do while available {1} with frame w:
               ixlastline = ixlastline + 1.
               ix1array[ixlastline] = {3}.
               recidarray[ixlastline] = recid({1}).

               /*V8-*/ display  {2}. /*V8+*/
	        
               /*V8!   display space(1) {2} space(1). */
               if frame-line = frame-down then leave.
               find next {1} where {5} {4} no-lock no-error.
               if available {1} then down 1.
            end. /* END OF DO WHILE AVAILABLE {1}  */

            partial_ixval = substring(ix1array[1]
                                      + spcs,1,partial_ixlen).
            up ixlastline - 1.
            color prompt messages {3}.
         end. /* END OF IF AVAILABLE {1}  WITH FRAME w */
      end. /* END OF IF FRAME-LINE = 1 */
      else do:
         up 1.
         color prompt messages {3}.
         partial_ixval = substring(ix1array[frame-line]
                                   + spcs,1,partial_ixlen).
				 {8}	/*---Add by davild 20071228.1*/
       end. /* END OF ELSE DO */
      {7}
   end. /* END OF IF LASTKEY = KEYCODE("CURSOR-UP") */
   else if lastkey = keycode("CURSOR-DOWN") or lastkey = keycode("F10")
   then do:
      if frame-line = ixlastline then do:
         find {1} where recid({1}) = recidarray[ixlastline]
         no-lock no-error.
         find next {1} where {5} {4} no-lock no-error.
	
         /* There is another record, redraw. */
         if available {1} then do:
            clear frame w all no-pause.
            ixlastline = 0.
             /* Redraw screen from the 2nd row down. */
            find {1} where recid({1}) = recidarray[1] no-lock no-error.

            find next {1} where {5} {4} no-lock no-error.
            do while available {1} with frame w:
               ixlastline = ixlastline + 1.
               ix1array[ixlastline] = {3}.
               recidarray[ixlastline] = recid({1}).

               /*V8-*/ display  {2}. /*V8+*/
                /*V8!   display space(1) {2} space(1). */
               if frame-line = frame-down then leave.
               find next {1} where {5} {4} no-lock no-error.
               if available {1} then down 1.
            end. /* END OF DO WHILE AVAILABLE {1}  */

            partial_ixval = substring(ix1array[1]
                                      + spcs,1,partial_ixlen).
            /* Desktop requires focus at first line when */
            /* the frame has been scrolled */
            if {gpiswrap.i} then up ixlastline - 1.
            color prompt messages {3}.
         end. /* END OF IF AVAILABLE {1} */
      end. /* END OF IF FRAME-LINE = ixlastline */
      else do:
         down 1.
         color prompt messages {3}.
         partial_ixval = substring(ix1array[frame-line]
                                   + spcs,1,partial_ixlen).

				   {8}  /*---Add by davild 20071228.1*/
      end. /* END OF ELSE DO */
      {7}
   end. /* END OF IF LASTKEY = KEYCODE("CURSOR-DOWN") */
   else if lastkey = keycode("F7") or lastkey = 18 then do:
      find {1} where recid({1}) = recidarray[1] no-lock no-error.
      find prev {1} where {5} {4} no-lock no-error.

      if available {1} then do:
         do i = 1 to frame-down - 2 while available {1}:
            find prev {1} where {5} {4} no-lock no-error.
         end.

         if not available {1} then
         find first {1} where {5} {4} no-lock no-error.

         clear frame w all no-pause.
         ixlastline = 0.

         do while available {1} with frame w:
            ixlastline = ixlastline + 1.
            ix1array[ixlastline] = {3}.
            recidarray[ixlastline] = recid({1}).

            /*V8-*/ display  {2}. /*V8+*/
	    {8}		/*---Add by davild 20071228.1*/
            /*V8!   display space(1) {2} space(1). */
            if frame-line = frame-down then leave.
            find next {1} where {5} {4} no-lock no-error.
            if available {1} then down 1.
         end. /* END OF DO WHILE AVAILABLE {1}  */

         partial_ixval = substring(ix1array[1] + spcs,1,partial_ixlen).

         if {gpiswrap.i} then
            up (ixlastline - 1).
         else
            up (ixlastline - 1) / 2.

         color prompt messages {3}.
      end. /* END OF IF AVAILABLE {1} */
      {7}
   end.  /* END OF IF LASTKEY = KEYCODE("F7") */
   else if lastkey = keycode("F8") or lastkey = 26 then do:
      find {1} where recid({1}) = recidarray[ixlastline]
      no-lock no-error.
      clear frame w all no-pause.
      ixlastline = 0.
      do while available {1} with frame w:
         ixlastline = ixlastline + 1.
         ix1array[ixlastline] = {3}.
         recidarray[ixlastline] = recid({1}).

         /*V8-*/ display  {2}. /*V8+*/
         /*V8!   display space(1) {2} space(1). */
         if frame-line = frame-down then leave.
         find next {1} where {5} {4} no-lock no-error.
         if available {1} then down 1.

      end. /* END OF DO WHILE AVAILABLE {1} WITH FRAME w */

      partial_ixval = substring(ix1array[1] + spcs,1,partial_ixlen).
      /* Desktop requires focus on first line */
      if {gpiswrap.i} then
         up (ixlastline - 1).
      else
         up (ixlastline - 1) / 2.
      color prompt messages {3}.

      {7}
   end.  /* END OF IF LASTKEY = KEYCODE("F8") */
   else do:
