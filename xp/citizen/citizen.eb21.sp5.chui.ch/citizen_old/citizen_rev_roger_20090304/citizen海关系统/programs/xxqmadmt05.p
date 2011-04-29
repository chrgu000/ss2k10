/* xxqmadmt05.p 地区代码维护                                                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 01/21/2008   BY: Softspeed tommy xie         */


         /* DISPLAY TITLE */
          {mfdtitle.i "1.0 "}

         define variable del-yn like mfc_logical initial no.

         form
            xxloc_code colon 20 label "地区代码"
            xxloc_desc colon 20 label "地区代码名称"
         with frame a side-labels attr-space width 80.

         transloop:
         repeat with frame a:
            do on error undo, retry with frame a:
               prompt-for xxloc_code with frame a editing:
                  if frame-field="xxloc_code" then do:
                     {mfnp01.i xxloc_mstr xxloc_code xxloc_code global_domain xxloc_domain xxloc_code}

                     if recno <> ? then do:
                        display xxloc_code xxloc_desc with frame a.
                     end.
                  end.
                  else do:
                     status input ststatus.
                     readkey.
                     apply lastkey.
                  end.
               end.
             
               find first xxloc_mstr where xxloc_code = input xxloc_code
                      and xxloc_domain = global_domain exclusive-lock no-error.
               if not available xxloc_mstr then do:
                  {mfmsg.i 1 1} /*ADDING NEW RECORD */
                  create xxloc_mstr.
                  assign xxloc_code = input xxloc_code.
                         xxloc_domain = global_domain.
               end.
               else do:
                  {mfmsg.i 10 1}
               end.

               display xxloc_desc with frame a.

               set xxloc_desc go-on("F5" "CTRL-D").

               if lastkey = keycode("F5")
                  or lastkey = keycode("CTRL-D")
               then do:
                  del-yn = no.            
                  {mfmsg01.i 11 1 del-yn}

                  if not del-yn then undo, retry.

                  if del-yn then do:
                     delete xxloc_mstr.
                     clear frame a.
                     del-yn = no.
                     next.
                  end.
               end.
            end.
         end.