/* xxqmadmt02.p 海关口岸维护                                                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 01/21/2008   BY: Softspeed tommy xie         */


         /* DISPLAY TITLE */
          {mfdtitle.i "1.0 "}

         define variable del-yn like mfc_logical initial no.

         form
            xxdept_code colon 20 label "海关口岸"
            xxdept_desc colon 20 label "口岸名称"
         with frame a side-labels attr-space width 80.

         transloop:
         repeat with frame a:
            do on error undo, retry with frame a:
               prompt-for xxdept_code with frame a editing:
                  if frame-field="xxdept_code" then do:
                     {mfnp01.i xxdept_mstr xxdept_code xxdept_code global_domain xxdept_domain xxdept_code}

                     if recno <> ? then do:
                        display xxdept_code xxdept_desc with frame a.
                     end.
                  end.
                  else do:
                     status input ststatus.
                     readkey.
                     apply lastkey.
                  end.
               end.
             
               find first xxdept_mstr where xxdept_code = input xxdept_code 
                      and xxdept_domain = global_domain exclusive-lock no-error.
               if not available xxdept_mstr then do:
                  {mfmsg.i 1 1} /*ADDING NEW RECORD */
                  create xxdept_mstr.
                  assign xxdept_code = input xxdept_code
                         xxdept_domain = global_domain.
               end.
               else do:
                  {mfmsg.i 10 1}
               end.

               display xxdept_desc with frame a.

               set xxdept_desc go-on("F5" "CTRL-D").

               if lastkey = keycode("F5")
                  or lastkey = keycode("CTRL-D")
               then do:
                  del-yn = no.            
                  {mfmsg01.i 11 1 del-yn}

                  if not del-yn then undo, retry.

                  if del-yn then do:
                     delete xxdept_mstr.
                     clear frame a.
                     del-yn = no.
                     next.
                  end.
               end.
            end.
         end.