/* xxqmadmt04.p 海关监管方式维护                                            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 01/22/2008   BY: Softspeed tommy xie         */


         /* DISPLAY TITLE */
          {mfdtitle.i "1.0 "}

         define variable del-yn like mfc_logical initial no.

         form
            xxctra_code  colon 20 label "监管方式"
            xxctra_desc1 colon 20 label "监管方式简称"
            xxctra_desc2 colon 20 label "监管方式全称"
         with frame a side-labels attr-space width 80.

         transloop:
         repeat with frame a:
            do on error undo, retry with frame a:
               prompt-for xxctra_code with frame a editing:
                  if frame-field="xxctra_code" then do:
                     {mfnp01.i xxctra_mstr xxctra_code xxctra_code global_domain xxctra_domain xxctra_code}

                     if recno <> ? then do:
                        display xxctra_code xxctra_desc1 xxctra_desc2 with frame a.
                     end.
                  end.
                  else do:
                     status input ststatus.
                     readkey.
                     apply lastkey.
                  end.
               end.
             
               find first xxctra_mstr where xxctra_code = input xxctra_code 
                      and xxctra_domain = global_domain exclusive-lock no-error.
               if not available xxctra_mstr then do:
                  {mfmsg.i 1 1} /*ADDING NEW RECORD */
                  create xxctra_mstr.
                  assign xxctra_code = input xxctra_code
                         xxctra_domain = global_domain.
               end.
               else do:
                  {mfmsg.i 10 1}
               end.

               display xxctra_desc1 xxctra_desc2 with frame a.

               set xxctra_desc1 xxctra_desc2 go-on("F5" "CTRL-D").

               if lastkey = keycode("F5")
                  or lastkey = keycode("CTRL-D")
               then do:
                  del-yn = no.            
                  {mfmsg01.i 11 1 del-yn}

                  if not del-yn then undo, retry.

                  if del-yn then do:
                     delete xxctra_mstr.
                     clear frame a.
                     del-yn = no.
                     next.
                  end.
               end.
            end.
         end.