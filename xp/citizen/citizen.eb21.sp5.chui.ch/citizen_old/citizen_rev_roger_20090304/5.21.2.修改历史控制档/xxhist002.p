/*                                                                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 2008/01/12   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */


define  frame a.


/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
    "历史记录保存控制"       colon 30 
	skip(1)
    xrevc_yn                 colon 30 label "开启模块"
	xrevc_release            colon 30 label "只记录已发行版本"

with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).


/* DISPLAY */
view frame a.


mainloop:
repeat with frame a:
    clear frame a no-pause .


    ststatus = stline[1].
    status input ststatus.

	find first xrevc_ctrl where xrevc_domain = global_domain exclusive-lock no-error .
	if not avail xrevc_ctrl then do :
		create xrevc_ctrl . 
		xrevc_ctrl.xrevc_domain = global_domain .
		release xrevc_ctrl . 
	end.

	find first xrevc_ctrl where xrevc_domain = global_domain exclusive-lock no-error .
	if avail xrevc_ctrl then do :
		disp xrevc_yn 	xrevc_release with frame a.
		update  xrevc_yn 	xrevc_release with frame a.
	end.

end.   /*  mainloop: */

status input.

