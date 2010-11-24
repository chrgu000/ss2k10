/* rescrad.i - Include file for full screen scrolling mfscrll3.i              */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.4.1.7 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0    LAST MODIFIED: 04/06/92     BY: smm *F364*                */
/* REVISION: 7.3    LAST MODIFIED: 12/16/92     BY: emb *G468*                */
/* REVISION: 7.2    LAST MODIFIED: 09/01/94     BY: ais *FQ68*                */
/* REVISION: 7.2    LAST MODIFIED: 09/21/94     BY: ljm *GM77*                */
/* REVISION: 7.2    LAST MODIFIED: 04/10/95     BY: ais *F0Q2*                */
/*                                 11/22/95     BY: dzn *G1F0*                */
/* REVISION: 7.3    LAST MODIFIED: 09/05/96     BY: *G2DM* Julie Milligan     */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98     BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00     BY: *N0KP* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.4.1.6    BY: Jean Miller        DATE: 04/09/02  ECO: *P058*  */
/* $Revision: 1.4.1.7 $   BY: Matthew Lee  DATE: 11/06/05  ECO: *P47D*  */
/* by: Neil Gao Date: 07/11/30 ECO: * ss 20071130 * */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* Displays data from primary file and one secondary file    */
/* Allows add (CTRL-A) / insert-mode                         */
/* {1} = file-name eg pt_mstr                                */
/* {2} = use-index or " " */
/* {3} = field to select records by eg pt_part               */
/* {4} = fields to display from rpimary file eg "pt_part pt_desc1 pt_price" */
/* {5} = field to hi-light eg pt_part                        */
/* {6} = frame name                                          */
/* {7} = Selection criteria should be "yes" if no selection  is used */
/* {8}  "ctrl + Z" */
/* {9}  "cursor-right" */
/* {10} "cursor-left" */


/* Used to tell which record to hi-lite */
define variable sw_key as character initial ? no-undo.

/* Used for number of lines down in scrolling */
/* screen, assign ? if max lines */
define variable slines as integer initial ?.
define variable iscroll as integer.

/* Used to store recid for each record on the screen. */
define variable recno24 as integer extent 24 no-undo.
define variable statusline as character.

if sw_reset then do:
   sw_key  = ?.
   sw_reset = no.
   recno24 = 0.
end.

if {gpiswrap.i} then
   statusline = stline[10].
else
   statusline = stline[2].
status default statusline.

recno = ?.

MAIN_SCROLL_LOOP:
repeat:

   form
   with frame {6} slines down
   scroll 1 no-attr-space.

   /* DISPLAY A SCREEN FULL OF RECORDS */
   if sw_key = ? then do:

      clear frame {6} all.

      release {1}.

      if recno24[1] = 0
      then do:
         find first {1} where {7} {2} no-lock no-error.
      end.

      else do while not available {1}
      iscroll = frame-down({6}) to 1 by -1:
         find {1} where recid({1}) = recno24[iscroll] no-lock no-error.
      end.

      recno24 = 0.

      do while available {1} iscroll = 1 to 24:
         if iscroll < 2 then sw_key = string({5}).
         recno24[iscroll] = recid({1}).
         display {4} with frame {6}.
         if frame-line({6}) = frame-down({6}) then leave.
         down 1 with frame {6}.
         find next {1} where {7}  {2} no-lock no-error.
      end.

   end. /*DISPLAY A SCREENFUL OF RECORDS */

   INNER_SCROLL_LOOP:
   repeat:

      choose row {5} keys sw_key go-on("F6") no-error with frame {6}.
      sw_key = ?.
      /*
      hide message no-pause.
      */
      /*V8-*/
      color display normal {5} with frame {6}.
      /*V8+*/
      pause 0.

			if lastkey = keycode("CTRL-Z") then do:
			  find first {1} where recid({1}) = recno24[frame-line({6})] no-lock no-error.
			  if avail {1} then do:
			  	{8}
			  end.
			  next.
			end.
			
			if lastkey = keycode("cursor-right") then do:
			  find first {1} where recid({1}) = recno24[frame-line({6})] no-lock no-error.
			  if avail {1} then do:
			  	{9}
			  end.
			  next.
			end.
			
			if lastkey = keycode("cursor-left") then do:
			  find first {1} where recid({1}) = recno24[frame-line({6})] no-lock no-error.
			  if avail {1} then do:
			  	{10}
			  end.
			  next.
			end.
			
      /* SCROLL BACK ONE PAGE IF USER PRESSED PAGE-UP */
      if lastkey = keycode("F9")
      or keyfunction(lastkey) = "page-up"
      or keyfunction(lastkey) = "new-line"
      or ({gpiswrap.i} and lastkey = keycode("F7")) /* DT UI */
      then do:

         recno24 = recno24[1].

         find {1} where recid({1}) = recno24[1] no-lock no-error.

         do while available {1} iscroll = 1 to frame-down({6}):
            find prev {1} where {7}  {2} no-lock no-error.
         end.

         if available {1} then recno24 = recid({1}).
         else do:
            find first {1} where {7} {2} no-lock no-error.
            if recno24[1] = integer(recid({1})) then do:
               {pxmsg.i &MSGNUM=21 &ERRORLEVEL=2} /* "Beginning of file"*/
            end.
         end.

         if available {1} then recno24 = recid({1}).
         leave.

      end.

      /* SCROLL DOWN ONE PAGE IF USER PRESSED PAGE-DOWN */
      if keyfunction(lastkey) = "page-down"
      or lastkey = keycode("F10")
      or ({gpiswrap.i} and lastkey = keycode("F8")) /* DT UI */
      then do:

         recno24 = recno24[1].
         find {1} where recid({1}) = recno24[1] no-lock no-error.

         do while available {1} iscroll = 1 to frame-down({6}):
            find next {1} where {7} {2} no-lock no-error.
         end.

         if available {1} then recno24 = recid({1}).
         else do.
            {pxmsg.i &MSGNUM=20 &ERRORLEVEL=2} /*"End of file"*/
         end.

         leave.

      end.

      /* IF THE USER IS ON THE FIRST LINE AND PRESSES CURSOR-UP,SCROLL DOWN */
      if (frame-line({6}) = 1 and lastkey = keycode("cursor-up"))
      or keyfunction(lastkey) = "cursor-up"
      then do:

         release {1}.

         do while not available {1} iscroll = 1 to frame-down({6}) - 1:
            find {1} where recid({1}) = recno24[iscroll]
            no-lock no-error.
         end.

         find prev {1} where {7}  {2} no-lock no-error.
         if available {1} then do:
            scroll down with frame {6}.
            display {4} with frame {6}.
            do iscroll = frame-down({6}) - 1 to 1 by -1:
               recno24[iscroll + 1] = recno24[iscroll].
            end.
            recno24[1] = recid({1}).
         end.

         else do.
            {pxmsg.i &MSGNUM=21 &ERRORLEVEL=2} /* "Beginning of file"*/
         end.
				 
         next.

      end.

      /* IF THE USER PRESSES INSERT SCROLL DOWN FROM CURRENT LINE */
      /* USED TO ADD A RECORD TO THE FILE ON THE SCREEN           */
      if keyfunction(lastkey) = "insert-mode"
      or lastkey = keycode("CTRL-A")
      then do:
         scroll from-current down with frame {6}.
         do iscroll = frame-line({6}) to frame-down({6}) - 1:
            recno24[iscroll + 1] = recno24[iscroll].
         end.
      end.

      /* IF THE USER IS ON THE LAST LINE AND PRESSES CURSOR-DOWN, SCROLL UP */
      if (frame-line({6}) = frame-down({6}) and
         (lastkey = keycode("cursor-down") or
          lastkey = keycode(" ") or
         keyfunction(lastkey) = "cursor-down"))
      then do:
         find {1} where recid({1}) = recno24[frame-down({6})]
         no-lock no-error.
         if available {1} then
            find next {1} where {7} {2} no-lock no-error.
         if available {1} then do:
            scroll up with frame {6}.
            display {4} with frame {6}.
            do iscroll = 1 to frame-down({6}) - 1:
               recno24[iscroll] = recno24[iscroll + 1].
            end.
            recno24[frame-down({6})] = recid({1}).
         end.
         else do.
            {pxmsg.i &MSGNUM=20 &ERRORLEVEL=2} /*"End of file"*/
         end.
         
         next.
      end.

      /* IF THE USER PRESSES PAGE-DOWN, RETURN, GO OR F4 LEAVE INNER_SCROLL */
      if lastkey = keycode("F10")
      or keyfunction(lastkey) = "CURSOR-DOWN"
      or keyfunction(lastkey) = "go"
      or keyfunction(lastkey) = "return"
      or keyfunction(lastkey) = "end-error"
      or keyfunction(lastkey) = "insert-mode"
      /*V8-*/
      or keyfunction(lastkey) = "get"
      or lastkey = keycode("CTRL-D")
      /*V8+*/
      /*V8!
      or keyfunction(lastkey) = "delete-character" */
      then do:
         leave.
      end.

   end. /* INNER_SCROLL_LOOP: */

   /* IF USER PRESSED PAGE-UP OR PAGE-DOWN CLEAR SCROLLING FRAME */
   if keyfunction(lastkey) = "page-down"
   or keyfunction(lastkey) = "page-up"
   or keyfunction(lastkey) = "new-line"
   or lastkey = keycode("F9")
   or keyfunction(lastkey) = "CURSOR-UP"
   or lastkey = keycode("F10")
   or keyfunction(lastkey) = "CURSOR-DOWN"
   then do:
      clear frame {6} all.
      next.
   end.

   /* IF USER PRESSED F4, CLEAR SCROLLING FRAME */
   if keyfunction(lastkey) = "end-error"
   then do:
      clear frame {6} all.
      leave.
   end.

   if keyfunction(lastkey) = "return"
      and frame-value = "" then leave.

   if keyfunction(lastkey) = "return"
   /*V8-*/
   or keyfunction(lastkey) = "get"
   or lastkey = keycode("CTRL-D")
   /*V8+*/
   /*V8!
   or keyfunction(lastkey) = "delete-character" */
   or keyfunction(lastkey) = "go"
   then do:

      find {1} where recid({1}) = recno24[frame-line({6})]
      exclusive-lock no-wait no-error.

      if available {1} then do:
         recno = recid({1}).
         sw_key = string({3}).
      end.

      else do:
         if locked {1} then do:
            /* "Warning: The record is locked, try later. */
            {pxmsg.i &MSGNUM=7006 &ERRORLEVEL=2}
         end.
         else
         if not (recno24[frame-line({6})] = 0 or
            recno24[frame-line({6})] = ?)
         then do:
            /* Record has been deleted by another session */
            {pxmsg.i &MSGNUM=5629 &ERRORLEVEL=2}
         end.
         next.
      end.

   end.

   leave.

end. /* MAIN_SCROLL_LOOP */
status default.
