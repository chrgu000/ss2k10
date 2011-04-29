/* windo1u1.i - SCROLLING WINDOW INCLUDE FILE                           */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* REVISION: 7.3      LAST MODIFIED: 06/15/94   BY: WUG *GK60*          */
/* REVISION: 7.3      LAST MODIFIED: 02/20/94   BY: dxk *F0JN*          */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb          */
/* REVISION: 9.1      LAST MODIFIED: 12/05/02   BY: *YB012-2B* Apple Tam */


/*USED IN CONJUNCTION WITH window1u.i*/


         end.
/*F0JN*/     {2}
         prompt-for {1} with frame dw editing:
            do i = 1 to partial_ixlen:
               apply keycode("CURSOR-RIGHT").
            end.
               apply keycode("CTRL-D").

            readkey.
            leave.
         end.	   

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

	 assign wtemp3 = string(input {1}).
      end.

      pause before-hide.
