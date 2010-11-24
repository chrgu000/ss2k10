/* Creation: eB21SP3 Chui Last Modified: 20071214 By: Davild Xu *ss-20071214.1*/
/* DISPLAY TITLE */

{mfdtitle.i "2+ "}

find first code_mstr where code_domain = global_domain 
       and code_fldname = "barcode_use_user_management"
       and code_value = "softspeed"
       no-lock no-error.
if not avail code_mstr then do: 
message "您未启用用户管理功能!" view-as alert-box.
leave .
end.

DEFINE VARIABLE del-yn as logi .

	FORM
		SKIP(1)  /*GUI*/
		code_value           COLON 28 label "用户名" format "x(8)" skip (1)
		code_cmmt           COLON 28  label "说  明" format "x(20)" skip (.5)
		code_user1           COLON 28  label "密  码" format "x(20)"
		SKIP(1)  /*GUI*/
	WITH FRAME a SIDE-LABELS WIDTH 80 attr-space  THREE-D.
	/*setFrameLabels(frame a:handle).*/

/* DISPLAY */
view frame a.

mainloop:
repeat  with frame a:
	
   do on error undo, retry:
      prompt-for
         code_value
      editing :

         {mfnp05.i code_mstr code_fldval
            " code_mstr.code_domain = global_domain and code_fldname  = 'barcode_user' " 
	    code_value
            "input code_value"}

         if recno <> ? then
            display  code_value code_cmmt with frame a.

      end. /* editing: */   
      
   end. /* do on error undo, retry: */

   /* ADD/MOD/DELETE  */

   find code_mstr  where code_mstr.code_domain = global_domain 
		    and code_fldname = "barcode_user"
                    and code_value = input code_value
		    no-error.

   if not available code_mstr then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create code_mstr. code_mstr.code_domain = global_domain.
      assign
         code_fldname = 'barcode_user' 
	 code_value .
   end. /* if not available code_mstr then do: */

   status input ststatus.
	do on error undo, retry:
	   update
	      code_cmmt
	      code_user1
	   go-on(F5 CTRL-D) .

	   /* Delete to be executed if batchdelete is set or
	    * F5 or CTRL-D pressed */
	   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")      
	   then do:

	      del-yn = yes.

	      /* Please confirm delete */
	      {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

	      if del-yn then do:
		 delete code_mstr.
		 clear frame a.
	      end. /* if del-yn then do: */

	   end. /* then do: */
	   assign code_user1 = encode(code_user1) .
	end.
	
	
end.
status input.