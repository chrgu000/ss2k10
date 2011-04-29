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
    "是否需要检验:"          colon 4  pt__log01 no-label 
        "检验类别:"          colon 8  pt__chr03 no-label format "x(1)"

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

    prompt-for  part with frame a editing:

         if frame-field = "part" then do:
            {mfnp.i pt_mstr part  " pt_domain = global_domain and pt_part "  part pt_part  pt_part}
             if recno <> ? then do:
		
                    desc1 = if avail pt_mstr then pt_desc1 else "" .
                    desc2 = if avail pt_mstr then pt_desc2 else "" .
		display  pt_part @ part desc1 desc2  pt__log01  pt__chr03 with frame a .                 
             end . /* if recno <> ? then  do: */		
         end.
         else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end.
    end. /* PROMPT-FOR...EDITING */
    assign part .


find first pt_mstr where  pt_domain = global_domain and pt_part = part no-lock no-error .
if not avail pt_mstr then do :
	message "料件不存在" view-as alert-box .
	undo mainloop, retry mainloop.
end.
else do:

	desc1 = if avail pt_mstr then pt_desc1 else "" .
	desc2 = if avail pt_mstr then pt_desc2 else "" .
	disp part desc1 desc2 pt__log01  pt__chr03 with frame a .
end.


    setloop:
    do on error undo ,retry :
        find first pt_mstr where  pt_domain = global_domain and pt_part = part  exclusive-lock no-error.
        if avail pt_mstr then do :
		update pt__log01 pt__chr03 with frame a .
	end.

	if not 
	(not can-find(first code_mstr where code_mstr.code_domain = global_domain and  code_fldname = "pt__chr03" )
	 or  can-find (code_mstr  where code_mstr.code_domain = global_domain 
				  and code_fldname = "pt__chr03" 
				  and code_value   =  pt__chr03 )
	) then do:
	  message "检验类别无效。" view-as alert-box .
	  next-prompt pt__chr03 with frame a .
	  undo,retry .
	end.  
    end. /*  setloop: */

end.   /*  mainloop: */

status input.


/***************************************************************************************************************
 /*地点功能暂不添加*/
define var site  like ptp_site .
define var part  like pt_part .
define var desc1 like pt_desc1.
define var desc2 like pt_desc2 .

define  frame a.


/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
    
    part                     colon 18 
    desc1                    colon 52
    site                     colon 18
    desc2                    colon 52 no-label
    skip(1)
    "是否需要检验:"          colon 4  ptp__log01 no-label 
        "检验类别:"          colon 8  ptp__chr01 no-label format "x(1)"

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

    prompt-for  part site with frame a editing:

         if frame-field = "part" then do:
            {mfnp.i ptp_det part  " ptp_domain = global_domain and ptp_part "  site ptp_site ptp_part}
             if recno <> ? then do:
		find first pt_mstr where  pt_domain = global_domain and pt_part = ptp_part no-lock no-error .
                    desc1 = if avail pt_mstr then pt_desc1 else "" .
                    desc2 = if avail pt_mstr then pt_desc2 else "" .
		display ptp_site @ site pt_part @ part desc1 desc2  ptp__log01  ptp__chr01 with frame a .                 
             end . /* if recno <> ? then  do: */		
         end.
         else if frame-field = "site" then do:
            {mfnp01.i ptp_det site ptp_site ptp_part " ptp_domain = global_domain and input part" ptp_part}
             if recno <> ? then do:
		find first pt_mstr where  pt_domain = global_domain and pt_part = ptp_part no-lock no-error .
                    desc1 = if avail pt_mstr then pt_desc1 else "" .
                    desc2 = if avail pt_mstr then pt_desc2 else "" .
		display  ptp_site @ site pt_part @ part desc1 desc2  ptp__log01  ptp__chr01 with frame a .                 
             end . /* if recno <> ? then  do: */
         end.
         else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end.
    end. /* PROMPT-FOR...EDITING */
    assign site part .


find  ptp_det where ptp_domain = global_domain and ptp_site = site and ptp_part = part  no-lock no-error.
if not avail ptp_det then do :
	message "地点/料件不存在" view-as alert-box .
	undo mainloop, retry mainloop.
end.
else do:
	find first pt_mstr where  pt_domain = global_domain and pt_part = ptp_part no-lock no-error .
	desc1 = if avail pt_mstr then pt_desc1 else "" .
	desc2 = if avail pt_mstr then pt_desc2 else "" .
	disp site part desc1 desc2 ptp__log01  ptp__chr01 with frame a .
end.


    setloop:
    do on error undo ,retry :
        find  ptp_det where ptp_domain = global_domain and ptp_site = site and ptp_part = part  exclusive-lock no-error.
        if avail ptp_det then do :
		update ptp__log01 ptp__chr01 with frame a .
	end.

	if not 
	(not can-find(first code_mstr where code_mstr.code_domain = global_domain and  code_fldname = "ptp__chr01" )
	 or  can-find (code_mstr  where code_mstr.code_domain = global_domain 
				  and code_fldname = "ptp__chr01" 
				  and code_value   =  ptp__chr01 )
	) then do:
	  message "检验类别无效。" view-as alert-box .
	  next-prompt ptp__chr01 with frame a .
	  undo,retry .
	end.  
    end. /*  setloop: */

end.   /*  mainloop: */

status input.

******************************************************************/