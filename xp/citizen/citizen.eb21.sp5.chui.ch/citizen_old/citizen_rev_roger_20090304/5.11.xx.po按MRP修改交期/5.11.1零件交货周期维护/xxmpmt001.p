/*                                                                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 2007/10/20   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */

define var part  like pt_part .
define var desc1 like pt_desc1.
define var desc2 like pt_desc2 .

define  frame a.


/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
    part                     colon 18 
    desc1                    colon 52
    desc2                    colon 52 no-label
	skip(1)
	pt_vend      colon 18
	"交货周期:"  colon 8
	pt__chr02  colon 18 no-label format "X(1)"
	skip(2)
	"说明:"  colon 12 
	"空: 每一周交货1次,订在周一交货"  colon 14 
	"C : 每一周交货1次,订在周二交货"  colon 14
	"A : 每一周交货1次,订在周三交货"  colon 14	 
	"B : 每一周交货2次,订在周一,三交货"  colon 14 	
	"D : 每一周交货3次,订在周一,三,五交货"  colon 14 
	"E : 每二周交货1次,订在周一交货"  colon 14 
	"F : 每四周交货1次,订在周一交货"  colon 14 

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

    prompt-for part with frame a editing:
         if frame-field = "part" then do:
             /* FIND NEXT/PREVIOUS RECORD */
             {mfnp.i pt_mstr part  "pt_domain = global_domain and pt_part "   part pt_part pt_part}

             if recno <> ? then do:
                    desc1 = if avail pt_mstr then pt_desc1 else "" .
                    desc2 = if avail pt_mstr then pt_desc2 else "" .
					display pt_part @ part desc1 desc2 pt__chr02 pt_vend with frame a .                 
             end . /* if recno <> ? then  do: */

         end.
         else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end.
    end. /* PROMPT-FOR...EDITING */
    assign part .


    find  pt_mstr where pt_domain = global_domain and pt_part = part  no-lock no-error.
    if not avail pt_mstr  then do :
        message "料件不存在" view-as alert-box .
        undo mainloop, retry mainloop.
    end.
	else do:
		desc1 = pt_desc1  .
		desc2 =  pt_desc2  .
		disp part desc1 desc2 pt__chr02  pt_vend with frame a .
	end.


    setloop:
    do on error undo ,retry :
        find pt_mstr where pt_domain = global_domain and pt_part = part exclusive-lock no-error .
        if avail pt_mstr then do :
			update pt__chr02 with frame a .
			if pt__chr02 <> ""  then do :
				if index("ABCDEF",pt__chr02) = 0 then do:
					message "仅限输入:空,A,B,C,D,E,F" view-as alert-box .
					undo ,retry .
				end.
			end.
		end.
    end. /*  setloop: */

end.   /*  mainloop: */

status input.
