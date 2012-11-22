/* GUI CONVERTED from mpscrad4.i (converter v1.69) Sat Mar 30 01:17:39 1996 */
/* mpscrad4.i - INCLUDE FILE FOR FULL SCREEN SCROLLING                  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*             -  USE F3 AS INSERT RECORD                               */
/* REVISION: 5.0     LAST MODIFIED: 05/01/90    BY: BJJ                 */
/* REVISION: 6.0     LAST MODIFIED: 08/01/91    BY: SMM                 */
/* REVISION: 7.0     LAST MODIFIED: 03/13/92    BY: RAM *F298*          */
/* REVISION: 7.0     LAST MODIFIED: 06/26/92    BY: emb *F703*          */
/* REVISION: 7.2     LAST MODIFIED: 09/01/94    BY: ais *FQ68*          */
/* REVISION: 7.3     LAST MODIFIED: 11/27/95    BY: rvw *G1DT*          */

/* Allows add (F3)                                          */
/* {1} = File-name (eg pt_mstr)                             */
/* {2} = Index to use (eg pt_part)                          */
/* {3} = Field to select records by (eg pt_part)            */
/* {4} = Fields to display from primary file (eg "pt_part pt_desc1") */
/* {5} = Field to highlight (eg pt_part)                    */
/* {6} = Frame name                                         */
/* {7} = Selection criteria; should be "yes" if no selection is used */
/* {8} = Message number for the status line                 */
/* {9} = Read with exclusive-lock (Y/N)                  */  /*G1DT*/
/* {10} =Field to select records by (eg pt_date)                     */  /*G1DT*/

         /* sw_key used to tell which record to highlight */
         define variable sw_key   as character  initial ? no-undo.
         /* slines used for number of lines down in scrolling screen,  */
         /* assign ? if max lines                                      */
         define variable slines   as integer    initial ?.
         define variable iscroll  as integer.
         /* recno24 used to store recid for each record on the screen. */
         define variable recno24  as integer    extent 24 no-undo.

         if sw_reset then do:
            sw_key  = ?.
            sw_reset = no.
            recno24 = 0.
         end.

         {yygpstat.i
            &stat={8}
            &type="default"
         }

         recno = ?.

         MAIN_SCROLL_LOOP:
         repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


/*G1DT*     form with frame {6} slines down attr-space.       */
/*G1DT*/    FORM /*GUI*/  with frame {6} width 80 slines down attr-space THREE-D /*GUI*/.


/*F703*/    display with frame {6}.
/*F703*/    pause 0.

            /* DISPLAY A SCREEN FULL OF RECORDS */
            if sw_key = ? then do:

               clear frame {6} all.
               release {1}.

               if recno24[1] = 0 then do:
                  find first {1} where {7} use-index {2} no-lock no-error.
               end.
               else do while not available {1}
               iscroll = frame-down({6}) to 1 by -1:
                  find {1} where recid({1}) = recno24[iscroll]
                  no-lock no-error.
               end.

               recno24 = 0.

               do while available {1} iscroll = 1 to 24:
                  if iscroll < 2 then sw_key = string({5}).
                  recno24[iscroll] = recid({1}).
                  display {4} with frame {6}.
                  if frame-line({6}) = frame-down({6}) then leave.
                  down 1 with frame {6}.
                  find next {1} where {7} use-index {2} no-lock no-error.
               end.

            end.  /* if sw_key = ? */

            INNER_SCROLL_LOOP:
            repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

               choose row {5} keys sw_key no-error with frame {6}.
               sw_key = ?.
               hide message no-pause.
               color display normal {5} with frame {6}.
               pause 0.

               /* SCROLL BACK ONE PAGE IF USER PRESSED PAGE-UP */
               if keyfunction(lastkey) = "page-up"
               or keyfunction(lastkey) = "recall"
               then do:
                  recno24 = recno24[1].
                  find {1} where recid({1}) = recno24[1] no-lock no-error.
                  do while available {1} iscroll = 1 to frame-down({6}) - 1:
                     find prev {1} where {7} use-index {2} no-lock no-error.
                     if available {1} then recno24 = recid({1}).
                  end.
                  leave.
               end.

               /* IF USER IS ON 1ST LINE AND PRESSES CURSOR-UP, SCROLL DOWN */
               if frame-line({6}) = 1
               and (keyfunction(lastkey) = "cursor-up"
               or   keyfunction(lastkey) = "new-line"
               or   keyfunction(lastkey) = "back-tab")
               then do:
                  release {1}.
                  do while not available {1}
                  iscroll = 1 to frame-down({6}) - 1:
                     find {1} where recid({1}) = recno24[iscroll]
                     no-lock no-error.
                  end.
                  find prev {1} where {7} use-index {2} no-lock no-error.
                  if available {1} then do:
                     scroll down with frame {6}.
                     display {4} with frame {6}.
                     do iscroll = frame-down({6}) - 1 to 1 by -1:
                        recno24[iscroll + 1] = recno24[iscroll].
                     end.
                     recno24[1] = recid({1}).
                  end.
                  else do:
                     {mfmsg.i 21 2}
                     /* BEGINNING OF FILE */
                  end.
                  next.
               end.  /* if frame-line({6}) = 1 and ... */
               else if keyfunction(lastkey) = "new-line" then do:
                  up 1 with frame {6}.
                  next.
               end.

               /* IF USER PRESSES F3, SCROLL DOWN FROM CURRENT LINE */
               /* USED TO ADD A RECORD TO THE FILE ON THE SCREEN    */
               if keyfunction(lastkey) = "insert-mode"
               or ((keyfunction(lastkey) = "return"
               or   keyfunction(lastkey) = "go")
               and (recno24[frame-line({6})] = 0
               or   recno24[frame-line({6})] = ?)) then do:
                  scroll from-current down with frame {6}.
                  do iscroll = frame-line({6}) to frame-down({6}) - 1:
                     recno24[iscroll + 1] = recno24[iscroll].
                  end.
               end.

               /* IF USER IS ON LAST LINE AND PRESSES CURSOR-DOWN, SCROLL UP */
               if frame-line({6}) = frame-down({6})
               and (keyfunction(lastkey) = "cursor-down"
/*FQ68*        or   keyfunction(lastkey) = "delete-line"                     */
               or   keyfunction(lastkey) = "tab"
               or   lastkey = keycode(" "))
               then do:
                  find {1} where recid({1}) = recno24[frame-down({6})]
                  no-lock no-error.
                  if available {1} then
                     find next {1} where {7} use-index {2} no-lock no-error.
                  if available {1} then do:
                     scroll up   with frame {6}.
                     display {4} with frame {6}.
                     do iscroll = 1 to frame-down({6}) - 1:
                        recno24[iscroll] = recno24[iscroll + 1].
                     end.
                     recno24[frame-down({6})] = recid({1}).
                  end.
                  else do:
                     {mfmsg.i 20 2}
                     /* END OF FILE */
                  end.
                  next.
               end.  /* if frame-line({6}) = frame-down({6}) and ... */
/*FQ68*        else if keyfunction(lastkey) = "delete-line" then do: */
/*FQ68*           down 1 with frame {6}.                             */
/*FQ68*           next.                                              */
/*FQ68*        end.                                                  */

               /* IF USER PRESSES PAGE-DOWN, RETURN, GO OR F4 THEN */
               /* LEAVE INNER_SCROLL                               */
               if keyfunction(lastkey) = "page-down"
               or keyfunction(lastkey) = "clear"
               or keyfunction(lastkey) = "go"
               or keyfunction(lastkey) = "return"
               or keyfunction(lastkey) = "end-error"
               or keyfunction(lastkey) = "insert-mode"
               then do:
                  leave.
               end.

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* INNER_SCROLL_LOOP */

            /* IF USER PRESSED PAGE-UP OR PAGE DOWN, CLEAR SCROLLING FRAME */
            if keyfunction(lastkey) = "page-down"
            or keyfunction(lastkey) = "page-up"
            or keyfunction(lastkey) = "clear"
            or keyfunction(lastkey) = "recall"
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
            or keyfunction(lastkey) = "go"
            then do:
/*G1DT*     CHECK IF FILE IS TO BE EXCLUSIVELY LOCKED (({9} = YES)         */
/*G1DT*/       if {9} then do:
                  find {1} where recid({1}) = recno24[frame-line({6})]
                  exclusive-lock no-wait no-error.
                  if available {1} then do:
                     recno = recid({1}).
                     sw_key = string({3}).
                  end.
                  else do:
                     if locked {1} then do:
                        {mfmsg.i 7006 2}
                        /* RECORD IS LOCKED.  PLEASE TRY AGAIN LATER */
/*G1DT*/             pause.
/*G1DT*/             leave main_scroll_loop.
                     end.
                     else
                     if not (recno24[frame-line({6})] = 0
                     or      recno24[frame-line({6})] = ?) then do:
                        {mfmsg.i 22 2}
                        /* RECORD DELETED */
                     end.
                     if not (recno24[frame-line({6})] = 0
                     or      recno24[frame-line({6})] = ?) then
                        next.
                  end.
/*G1DT*/       end.    /*  END IF {9} = YES    */
/*G1DT*        BEGIN NEW CODE FOR IF {9} NOT = YES       */
               else do:
                  find {1} where recid({1}) = recno24[frame-line({6})]
                     no-lock no-wait no-error.
                  if available {1} then do:
                     recno = recid({1}).
                     sw_key = string({3}).
                  end.
                  else do:
                     if not (recno24[frame-line({6})] = 0
                     or      recno24[frame-line({6})] = ?) then do:
                        {mfmsg.i 22 2}
                        /* RECORD DELETED */
                     end.
                     if not (recno24[frame-line({6})] = 0
                     or recno24[frame-line({6})] = ?) then
                         next.
                  end.  /* END IF NOT AVAILABLE   */
               end. /* END OF IF {9} NOT = YES */
/*G1DT*        END OF G1DT ADDITIONAL CODE     */
            end.  /* END IF RETURN OR GO */
            leave.

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* MAIN_SCROLL_LOOP */
         status default.
