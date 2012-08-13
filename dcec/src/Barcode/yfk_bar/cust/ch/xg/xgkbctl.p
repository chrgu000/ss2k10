/* xwkbctl.p    看板零件的异常消耗控制文件 by Atos Origin :SunnyZhou      */


/* DISPLAY TITLE */
{mfdtitle.i "4+ "}

define variable xwyn like mfc_logical.

FORM  
   	skip(1)
	xwyn colon 30 label "异常消耗需要校验事务号"
	skip(1)
with frame a width 80 side-labels attr-space.

/* Set External Labels */
setFrameLabels(frame a:handle).

do transaction:

   find first usrw_wkfl where usrw_key1 = "XW-KBCTRL" exclusive-lock no-error.
   if not available usrw_wkfl then do:
	create usrw_wkfl.
	assign  usrw_key1 = "XW-KBCTRL" 
		usrw_logfld[1] = no.
   end.
   xwyn = usrw_logfld[1].

end.

/* DISPLAY */
repeat:
   	view frame a.

	display
		xwyn	 
   	with frame a.
        set xwyn with frame a.
	usrw_logfld[1] = xwyn.

end.

status input.
