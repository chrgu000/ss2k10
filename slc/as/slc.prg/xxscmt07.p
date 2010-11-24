/*销售审核模块 审核步骤维护 sc 是so  confirm 的简写
  xxscmt07.p
*/
/* ss-20071128 base ken */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "a+ "}

DEFINE VARIABLE sc_nbr  AS CHARACTER FORMAT "x(8)"  LABEL "审核代码" COLUMN-LABEL "审核代码".
define variable sc_desc as character format "x(60)" label "审核说明" column-label "审核说明".
define variable del-yn   as logic init no.

form
        sc_nbr  colon 10
	skip(1)
        sc_desc colon 10
 with frame a attr-space side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
	

mainloop:	
repeat with frame a:

    view frame a.
    prompt-for sc_nbr 
    editing:
        if frame-field = "sc_nbr" then 
	do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp01.i xxcf_mstr sc_nbr xxcf_nbr
            sc_nbr sc_nbr xxcf_nbr }
        end.
        else 
	do:
            readkey.
      	    apply lastkey.
        end.
    	if recno <> ? then 
	do:
            find first xxcf_mstr where recid(xxcf_mstr) = recno no-lock no-error.
            if avail xxcf_mstr then 
	    do:
                 disp 	
		     xxcf_nbr @ sc_nbr
                     xxcf_desc @ sc_desc
                     with frame a.
            end.
    	end.
    end. /* prompt-for */
      
    /* 审核代码不能为空 */

    if input sc_nbr = "" then 
    do:
        message("审核代码不能为空").
        next-prompt sc_nbr.
        undo mainloop,retry mainloop.
    end. /* if input sc_nbr = "" */
	 
    ASSIGN sc_nbr.  /*把屏幕输入的值赋给sc_nbr*/

    loop:
    do transaction on error undo, next mainloop:
      
	  find first xxcf_mstr 
              where xxcf_nbr = input sc_nbr  no-error.
         if avail xxcf_mstr then
	 do:

            DISP
	        xxcf_nbr @ sc_nbr
                xxcf_desc @ sc_desc
	    WITH FRAME a.
         end.
         else
	 do:
	     create xxcf_mstr.
             DISP

                "" @ sc_desc
	     WITH FRAME a.
	 end.

         set 
             sc_desc
         go-on (F5 CTRL-D) with frame a
         editing:

                 readkey.
                 apply lastkey.
      
         end. /* editing */
	 /*update 资料 */

	 if lastkey = keycode("F5") or
             lastkey = keycode("CTRL-D") then 
	 do:
             del-yn = yes.
             {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         end.

	 if del-yn then 
	 do:
	      find first xxcf_mstr 
              where xxcf_nbr = input sc_nbr exclusive-lock.
	      if avail xxcf_mstr then
	      do:
                  delete xxcf_mstr.
	      
	         clear frame a all no-pause.
                 del-yn = no.
                 next mainloop.
	     end.
         end.

         assign xxcf_nbr =  input sc_nbr
	        xxcf_desc = input sc_desc
		xxcf_date = today
		xxcf_time = time
		xxcf_user = global_userid.
	 
	 release xxcf_mstr.

    
  end. /* do transaction on error undo, next mainloop: */
end. /* repeat */
    
PROCEDURE p-message-question:
   define input        parameter l_num  as   integer     no-undo.
   define input        parameter l_stat as   integer     no-undo.
   define input-output parameter l_yn   like mfc_logical no-undo.

   {pxmsg.i &MSGNUM=l_num &ERRORLEVEL=l_stat &CONFIRM=l_yn}
END PROCEDURE.
