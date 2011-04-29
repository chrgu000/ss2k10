/* windo1u.i - SCROLLING WINDOW INCLUDE FILE                            */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3    LAST MODIFIED: 06/20/94     BY: WUG *GK60* */
/* REVISION: 7.3    LAST MODIFIED: 06/20/94     BY: WUG *GK86* */
/* REVISION: 7.3    LAST MODIFIED: 12/28/94     BY: jpm *G0B1* */
/* REVISION: 7.3    LAST MODIFIED: 01/11/95     BY: qzl *F0DH* */
/* REVISION: 7.3    LAST MODIFIED: 02/20/95     BY: dxk *F0JN**/
/* REVISION: 7.0    LAST MODIFIED: 03/07/95     BY: aed *F0LY* */
/* REVISION: 7.0    LAST MODIFIED: 03/28/95     BY: jpm *F0PG* */
/* REVISION: 7.0    LAST MODIFIED: 07/07/95     BY: jym *G0RZ* */
/* REVISION: 7.0    LAST MODIFIED: 07/07/95     BY: jym *G0S4* */
/* REVISION: 7.3    LAST MODIFIED: 03/20/96     BY: pcb *G1R1* */
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98     BY: *L007* A. Rahane */
/* REVISION: 8.6E   LAST MODIFIED: 04/20/98     BY: *K1NN* Suresh Nayak  */
/* REVISION: 8.6E   LAST MODIFIED: 10/04/98     BY: *J314* Alfred Tan    */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00     BY: *N0KC* myb           */
/* REVISION: 9.1    LAST MODIFIED: 09/28/01     BY: *N132* Murali Ayyagari */
/* REVISION: 9.1    LAST MODIFIED: 12/02/02     BY: *YB012-2B* Apple Tam */
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
/*F0JN*/  {6} = command(s) to execute when highlighting a line
/*K1NN*/  {7} = command(s) to execute when the cursor is repositioned
                to a different line in the frame.
*/
/*!
Assumptions:
   1.  Indexed field is the highest order variant field,
       that is it is either the highest order index field
       or all higher order index fields will not vary
       due to the additional search criteria
*/

/* ********** Begin Translatable Strings Definitions ********* */
/*N132* BEGIN DELETE*
 * &SCOPED-DEFINE windo1u_i_1 "F1=Go F2=Help F4=End F7=PgUp F8=PgDn F9=LnUp F10=LnDn"
 * /* MaxLen: Comment: */

 * &SCOPED-DEFINE windo1u_i_2 "Press space bar to continue."
 * /* MaxLen: Comment: */

 * &SCOPED-DEFINE windo1u_i_3 "There are no records in file {1}"
 * /* MaxLen: Comment: */
 *N132* END DELETE*/

/* ********** End Translatable Strings Definitions ********* */

/*N132*/ {pxgblmgr.i}
          define shared variable window_row as integer.
          define shared variable window_down as integer.
          define shared variable global_recid as recid.
          define variable partial_ixval as character no-undo.
          define variable partial_ixlen as integer no-undo.
          define variable ix1array as character extent 25 no-undo.
          define variable recidarray as recid extent 25 no-undo.
          define variable ixlastline as integer no-undo.
          define variable i as integer no-undo.
          define variable wtemp3 as character no-undo.
          define variable spcs as character
          init "                                                   ".
/*N132*   BEGIN DELETE*
 *         /*G1R1*/ /*V8!
 *         /*G1R1*/ define shared variable stline as character format "x(78)"
                                                                   extent 13.
 *  /*G1R1*/ define shared variable ststatus as character format "x(78)". */
 *N132*   END DELETE*/
/*N132*/ define shared variable stline as character format "x(78)" extent 13.
/*N132*/ define shared variable ststatus as character format "x(78)".
/*N132*/ define variable c-spbar-msg as character format "x(78)" no-undo.

/*N132* BEGIN ADD*/
          {pxmsg.i &MSGNUM=8809 &ERRORLEVEL=1
                   &MSGBUFFER=c-spbar-msg}
/*N132* END ADD*/
          hide message no-pause.
          /*G1R1* status input off. */
          /*G0B1*/ /*V8-*/
          /*G1R1*/ status input off.
          status default
/*N132*          {&windo1u_i_1}. */
/*N132*/  stline[4].

          /*G1R1**
          /*G0B1*/ /*V8!
          status default
          "F1-Help F2-Go Esc-End F7-PgUp F8-PgDn F9-LnUp F10-LnDn". */
          **G1R1*/

          /*G1R1*/  /*V8+*/
          /*G1R1*/  /*V8!
          /*G1R1*/  ststatus = stline[4].
          /*G1R1*/  status input ststatus.  */

          find first {1} where {5} no-lock no-error.

          if not available {1} then do:
/*N132*             message {&windo1u_i_3}. */
/*N132*             status default {&windo1u_i_2}. */
/*N132* BEGIN ADD*/
         {pxmsg.i &MSGNUM=2767 &ERRORLEVEL=1
                      &MSGARG1=""{1}""}
             status default c-spbar-msg.
/*N132* END ADD*/
             readkey.
             return.
          end.

          do with frame dw:
             clear frame dw all no-pause.
             ixlastline = 0.
             find first {1} where {5} {4} no-lock no-error.

/*F0LY*/     do while available {1} with frame dw:
                 ixlastline = ixlastline + 1.
                 ix1array[ixlastline] = {3}.
                 recidarray[ixlastline] = recid({1}).
/*F0PG*/        /*V8-*/ display  {2}. /*V8+*/
/*F0PG*/        /*V8!   display space(1) {2} space(1). */

                 if frame-line = frame-down then leave.
                 find next {1} where {5} {4} no-lock no-error.

                 if available {1} then down 1.
             end. /* DO WHILE AVAILABLE {1} WITH FRAME w */

             partial_ixval = substr(ix1array[1] + spcs,1,partial_ixlen).
             up ixlastline - 1.
             color prompt messages {3}.
/*F0JN*/     {6}
          end.  /* DO WITH FRAME w */
/*K1NN*/  {7}

          prompt-for {3} with frame dw editing:
             do i = 1 to partial_ixlen:
                apply keycode("CURSOR-RIGHT").
             end.
               apply keycode("CTRL-D").

             readkey.
/*
/*G0RZ*/   if keyfunction(lastkey) = "HELP" or
/*G0RZ*/      lastkey = keycode("F6") then apply lastkey.
/*G0RZ*/   else
*/
             leave.
          end.  /* END OF {3} WITH FRAME w EDITING */

      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
	 message "Confirm delete." update yn3.
	 do on error undo, retry:
                if yn3 = yes then do:
                   for each shad_det where shad_sanbr = sanbr:
		       delete shad_det.
		   end.
		   for each shah_hdr where shah_sanbr = sanbr:
		       delete shah_hdr.
		   end.
		   for each snd_ctn_det where snd_sanbr = sanbr:
		       snd_sanbr = "".
		   end.
	           leave.
                end.
         end. /* do on error undo, retry */
         view frame aa.
      end.


/*F0LY*/  do while lastkey = 8 or (lastkey >= 32 and lastkey <= 256)
          or lastkey = keycode("CURSOR-UP") or lastkey = keycode("CURSOR-DOWN")
          or lastkey = keycode("F9") or lastkey = keycode("F10")
          or lastkey = keycode("CURSOR-LEFT")
          or lastkey = keycode("CURSOR-RIGHT")
          or lastkey = keycode("F7") or lastkey = keycode("F8")
          or lastkey = 18 or lastkey = 26
          or keyfunction(lastkey) = "GO" or keyfunction(lastkey) = "RETURN"
/*F0DH*   or lastkey = keycode("ESC-A") or lastkey = keycode("CTRL-A") */
/*F0DH*/  or keyfunction(lastkey) = "HELP" 
          with frame dw:

             if lastkey = 8 or lastkey = keycode("CURSOR-LEFT") then do:
                if partial_ixlen > 0 then partial_ixlen = partial_ixlen - 1.
                partial_ixval = substr(partial_ixval + spcs,1,partial_ixlen).
             end.  /* END OF IF LASTKEY = 8 */
             else
             if lastkey = keycode("CURSOR-RIGHT") then do:
                if length(ix1array[frame-line]) > partial_ixlen then do:
                   partial_ixlen = partial_ixlen + 1.
                   partial_ixval = substr(ix1array[frame-line]
                                              + spcs,1,partial_ixlen).
                end.
             end. /* END OF IF LASTKEY = KEYCODE("CURSOR-RIGHT") */
             else
             if lastkey >= 32 and lastkey <= 256 then do:
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
                          partial_ixval = substr(ix1array[1]
                                                 + spcs,1,partial_ixlen).
                       end.
                       else do:
                          clear frame dw all no-pause.
                          ixlastline = 0.

                          find first {1} where {3} >= partial_ixval
                          and {5} {4} no-lock no-error.

/*F0LY*/                  do while available {1} with frame dw:
                             ixlastline = ixlastline + 1.
                             ix1array[ixlastline] = {3}.
                             recidarray[ixlastline] = recid({1}).

/*F0PG*/                     /*V8-*/ display  {2}. /*V8+*/
/*F0PG*/                     /*V8!   display space(1) {2} space(1). */
                             if frame-line = frame-down then leave.
                             find next {1} where {5} {4} no-lock no-error.
                             if available {1} then down 1.
                          end.  /* DO WHILE AVAILABLE {1} WITH FRAME w */

                           partial_ixval = substr(ix1array[1]
                                                   + spcs,1,partial_ixlen).
                           up ixlastline - 1.
                           color prompt messages {3}.
                       end. /* END OF ELSE DO */
                    end. /* END OF IF AVAILABLE {1} */
                    else do:
                       if partial_ixlen > 1 then
                          partial_ixlen = partial_ixlen - 1.

                       partial_ixval = substr(partial_ixval
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
                   partial_ixval = substr(ix1array[i] + spcs,1,partial_ixlen).
                end. /* END OF ELSE DO */
/*K1NN*/        {7}
             end. /* END OF IF LASTKEY >= 32 AND LASTKEY <= 256  */
             else
             if lastkey = keycode("CURSOR-UP") or lastkey = keycode("F9")
             then do:
                 if frame-line = 1 then do:
                    find {1} where recid({1}) = recidarray[1] no-lock no-error.
                    find prev {1} where {5} {4} no-lock no-error.

                    if available {1} then do:
                       clear frame dw all no-pause.
                       ixlastline = 0.

/*F0LY*/               do while available {1} with frame dw:
                           ixlastline = ixlastline + 1.
                           ix1array[ixlastline] = {3}.
                           recidarray[ixlastline] = recid({1}).

/*F0PG*/                  /*V8-*/ display  {2}. /*V8+*/
/*F0PG*/                  /*V8!   display space(1) {2} space(1). */
                          if frame-line = frame-down then leave.
                          find next {1} where {5} {4} no-lock no-error.
                          if available {1} then down 1.
                       end. /* END OF DO WHILE AVAILABLE {1}  */

                       partial_ixval = substr(ix1array[1]
                                               + spcs,1,partial_ixlen).
                       up ixlastline - 1.
                       color prompt messages {3}.
                    end. /* END OF IF AVAILABLE {1}  WITH FRAME w */
                 end. /* END OF IF FRAME-LINE = 1 */
                 else do:
                     up 1.
                     color prompt messages {3}.
                     partial_ixval = substr(ix1array[frame-line]
                                                    + spcs,1,partial_ixlen).
                 end. /* END OF ELSE DO */
/*K1NN*/         {7}
             end. /* END OF IF LASTKEY = KEYCODE("CURSOR-UP") */
             else
             if lastkey = keycode("CURSOR-DOWN") or lastkey = keycode("F10")
             then do:
                 if frame-line = ixlastline then do:
                     find {1} where recid({1}) = recidarray[ixlastline]
                     no-lock no-error.
                     find next {1} where {5} {4} no-lock no-error.

                     if available {1} then do:
                         down 1.

/*F0PG*/                 /*V8-*/ display  {2}. /*V8+*/
/*F0PG*/                 /*V8!   display space(1) {2} space(1). */
                         color prompt messages {3}.

                         do i = 1 to ixlastline:
                            ix1array[i] = ix1array[i + 1].
                            recidarray[i] = recidarray[i + 1].
                         end.

                         ix1array[ixlastline] = {3}.
                         recidarray[ixlastline] = recid({1}).
                         partial_ixval = substr(ix1array[ixlastline]
                                             + spcs,1,partial_ixlen).
                     end. /* END OF IF AVAILABLE {1} */
                 end. /* END OF IF FRAME-LINE = ixlastline */
                 else do:
                     down 1.
                     color prompt messages {3}.
                     partial_ixval = substr(ix1array[frame-line]
                                        + spcs,1,partial_ixlen).
                 end. /* END OF ELSE DO */
/*K1NN*/         {7}
             end. /* END OF IF LASTKEY = KEYCODE("CURSOR-DOWN") */
             else
             if lastkey = keycode("F7") or lastkey = 18 then do:
                 find {1} where recid({1}) = recidarray[1] no-lock no-error.
                 find prev {1} where {5} {4} no-lock no-error.

                 if available {1} then do:
                     do i = 1 to frame-down - 2 while available {1}:
                         find prev {1} where {5} {4} no-lock no-error.
                     end.

                     if not available {1} then find first {1} where {5} {4}
                     no-lock no-error.

                     clear frame dw all no-pause.
                     ixlastline = 0.

/*F0LY*/             do while available {1} with frame dw:
                        ixlastline = ixlastline + 1.
                        ix1array[ixlastline] = {3}.
                        recidarray[ixlastline] = recid({1}).

/*F0PG*/                /*V8-*/ display  {2}. /*V8+*/
/*F0PG*/                /*V8!   display space(1) {2} space(1). */
                         if frame-line = frame-down then leave.
                         find next {1} where {5} {4} no-lock no-error.
                         if available {1} then down 1.
                     end. /* END OF DO WHILE AVAILABLE {1}  */

                     partial_ixval = substr(ix1array[1] + spcs,1,partial_ixlen).
                     up (ixlastline - 1) / 2.
                     color prompt messages {3}.
                 end. /* END OF IF AVAILABLE {1} */
/*K1NN*/         {7}
             end.  /* END OF IF LASTKEY = KEYCODE("F7") */
             else
             if lastkey = keycode("F8") or lastkey = 26 then do:
                 find {1} where recid({1}) = recidarray[ixlastline]
                 no-lock no-error.
                 clear frame dw all no-pause.
                 ixlastline = 0.
/*F0LY*/         do while available {1} with frame dw:
                     ixlastline = ixlastline + 1.
                     ix1array[ixlastline] = {3}.
                     recidarray[ixlastline] = recid({1}).

/*F0PG*/             /*V8-*/ display  {2}. /*V8+*/
/*F0PG*/             /*V8!   display space(1) {2} space(1). */
                     if frame-line = frame-down then leave.
                     find next {1} where {5} {4} no-lock no-error.
                     if available {1} then down 1.

                 end. /* END OF DO WHILE AVAILABLE {1} WITH FRAME w */

             partial_ixval = substr(ix1array[1] + spcs,1,partial_ixlen).
             up (ixlastline - 1) / 2.
             color prompt messages {3}.

/*K1NN*/     {7}
          end.  /* END OF IF LASTKEY = KEYCODE("F8") */
          else do:
