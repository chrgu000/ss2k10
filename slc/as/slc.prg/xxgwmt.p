/*By: Neil Gao 08/09/05 ECO: *SS 20080905* */

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

define variable del-yn   like mfc_logical initial no.
define variable fldname  like xxcode_fldname initial "xxgw".
define variable codedesc  like code_cmmt.

/* DISPLAY SELECTION FORM */
form
	 xxcode_nbr   label "工序" colon 25
	 codedesc 		colon 25 no-label
   xxcode_value label "工位/调试员" colon 25 format "x(16)"
   skip(1)
   xxcode_cmmt  label "名称"                 colon 25
with frame a side-labels width 80  attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */

view frame a.

mainloop:
repeat with frame a:

   prompt-for xxcode_nbr with frame a
   editing:
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp01.i xxcode_mstr xxcode_nbr xxcode_nbr
         fldname  " xxcode_mstr.xxcode_domain = global_domain and xxcode_fldname "
         xxcode_fldval}
      if recno <> ? then do:
         	display xxcode_nbr xxcode_value xxcode_cmmt.
         	find first code_mstr where code_domain = global_domain and code_fldname = "xxgx" and code_value = input xxcode_nbr no-lock no-error.
					if avail code_mstr then disp code_cmmt @ codedesc with frame a.
      end.
   end.

   /* VALIDATE TAX TYPE NOT BLANK */
   if not input xxcode_nbr > "" then do:
      /* Blank tax type not allowed */
      {pxmsg.i &MSGNUM=945 &ERRORLEVEL=3}
      undo mainloop, retry.
   end.
		
/*SS 20080905 - B*/
		find first code_mstr where code_domain = global_domain and code_fldname = "xxgx" and code_value = input xxcode_nbr no-lock no-error.
		if avail code_mstr then disp code_cmmt @ codedesc with frame a.
		else do:
			message "工序不存在".
			undo,retry.
		end.
/*SS 20080905 - E*/		
		
   prompt-for xxcode_value with frame a
   editing:
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp01.i xxcode_mstr xxcode_nbr xxcode_nbr
         fldname  " xxcode_mstr.xxcode_domain = global_domain and xxcode_mstr.xxcode_nbr = input xxcode_nbr and xxcode_fldname  "
         xxcode_fldval}
      if recno <> ? then
         display xxcode_nbr xxcode_value xxcode_cmmt.
   end.

   /* VALIDATE TAX TYPE NOT BLANK */
   if not input xxcode_value > "" then do:
      /* Blank tax type not allowed */
      {pxmsg.i &MSGNUM=945 &ERRORLEVEL=3}
      undo mainloop, retry.
   end.
   
   /* ADD/MOD/DELETE  */
   find xxcode_mstr  where xxcode_mstr.xxcode_domain = global_domain and
   xxcode_fldname = fldname and xxcode_nbr = input xxcode_nbr
   and xxcode_value = input xxcode_value
   exclusive-lock no-error.

   if not available xxcode_mstr then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create xxcode_mstr. xxcode_mstr.xxcode_domain = global_domain.
      assign
         xxcode_nbr
         xxcode_value.
      xxcode_fldname = fldname.
   end.

   display xxcode_value xxcode_cmmt.

   ststatus  =  stline[2].
   status input ststatus.
   del-yn = no.

   seta:
   do on error undo, retry:

      set xxcode_cmmt go-on (F5 CTRL-D).

      /* DELETE */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      then do:

         del-yn = yes.
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn = no then undo, retry.

         delete xxcode_mstr.
         clear frame a.
         next mainloop.

      end.

   end.    /* seta: */

   release xxcode_mstr.

end.    /* mainloop: */
