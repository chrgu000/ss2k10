/* xxqmadmt03.p 海关征免性质维护                                            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 01/22/2008   BY: Softspeed tommy xie         */


         /* DISPLAY TITLE */
          {mfdtitle.i "1.0 "}

         define variable del-yn like mfc_logical initial no.

         form
            xxctax_code  colon 20 label "征免性质"
            xxctax_desc1 colon 20 label "征免性质简称"
            xxctax_desc2 colon 20 label "征免性质全称"
         with frame a side-labels attr-space width 80.

         transloop:
         repeat with frame a:
            do on error undo, retry with frame a:
               prompt-for xxctax_code with frame a editing:
                  if frame-field="xxctax_code" then do:
                     {mfnp01.i xxctax_mstr xxctax_code xxctax_code global_domain xxctax_domain xxctax_code}

                     if recno <> ? then do:
                        display xxctax_code xxctax_desc1 xxctax_desc2 with frame a.
                     end.
                  end.
                  else do:
                     status input ststatus.
                     readkey.
                     apply lastkey.
                  end.
               end.
             
               find first xxctax_mstr where xxctax_code = input xxctax_code
                      and xxctax_domain = global_domain exclusive-lock no-error.
               if not available xxctax_mstr then do:
                  {mfmsg.i 1 1} /*ADDING NEW RECORD */
                  create xxctax_mstr.
                  assign xxctax_code = input xxctax_code
                         xxctax_domain = global_domain.
               end.
               else do:
                  {mfmsg.i 10 1}
               end.

               display xxctax_desc1 xxctax_desc2 with frame a.

               set xxctax_desc1 xxctax_desc2 go-on("F5" "CTRL-D").

               if lastkey = keycode("F5")
                  or lastkey = keycode("CTRL-D")
               then do:
                  del-yn = no.            
                  {mfmsg01.i 11 1 del-yn}

                  if not del-yn then undo, retry.

                  if del-yn then do:
                     delete xxctax_mstr.
                     clear frame a.
                     del-yn = no.
                     next.
                  end.
               end.
            end.
         end.