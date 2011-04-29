/* xxqmadmt01.p 产终地维护                                                  */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 01/16/2008   BY: Softspeed tommy xie         */


         /* DISPLAY TITLE */
          {mfdtitle.i "1.0 "}

         define variable del-yn like mfc_logical initial no.

         form
            xxctry_code colon 20 label "产终地"
            xxctry_name colon 20 label "产终地名称"
         with frame a side-labels attr-space width 80.

         transloop:
         repeat with frame a:
            do on error undo, retry with frame a:
               prompt-for xxctry_code with frame a editing:
                  if frame-field="xxctry_code" then do:
                     {mfnp01.i xxctry_mstr xxctry_code xxctry_code global_domain xxctry_domain xxctry_code}

                     if recno <> ? then do:
                        display xxctry_code xxctry_name with frame a.
                     end.
                  end.
                  else do:
                     status input ststatus.
                     readkey.
                     apply lastkey.
                  end.
               end.
             
               find first xxctry_mstr where xxctry_code = input xxctry_code 
                      and xxctry_domain = global_domain exclusive-lock no-error.
               if not available xxctry_mstr then do:
                  {mfmsg.i 1 1} /*ADDING NEW RECORD */
                  create xxctry_mstr.
                  assign xxctry_code = input xxctry_code
                         xxctry_domain = global_domain.
               end.
               else do:
                  {mfmsg.i 10 1}
               end.

               display xxctry_name with frame a.

               set xxctry_name go-on("F5" "CTRL-D").

               if lastkey = keycode("F5")
                  or lastkey = keycode("CTRL-D")
               then do:
                  del-yn = no.            
                  {mfmsg01.i 11 1 del-yn}

                  if not del-yn then undo, retry.

                  if del-yn then do:
                     delete xxctry_mstr.
                     clear frame a.
                     del-yn = no.
                     next.
                  end.
               end.
            end.
         end.