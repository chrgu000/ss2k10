/*By: Neil Gao 08/09/11 ECO: *SS 20080911* */

{mfdtitle.i "N+ "}


DEFINE VARIABLE fw_key AS CHARACTER FORMAT "x(8)" LABEL "模块" COLUMN-LABEL "模块". 
define variable fw_desc as character format "x(18)" label "说明" COLUMN-LABEL "说明".
DEFINE VARIABLE fw_nbr AS CHARACTER FORMAT "x(8)" LABEL "阶段代码" COLUMN-LABEL "阶段代码".     
DEFINE VARIABLE fw_cf_nbr AS CHARACTER FORMAT "x(8)" LABEL "审核" COLUMN-LABEL "审核". /*usrw_charfld[8]*/
DEFINE VARIABLE fw_cf_desc AS CHARACTER FORMAT "x(40)" LABEL "审核说明" COLUMN-LABEL "审核说明".
define variable fw_parent as character format "x(18)" label "下一步骤" column-label "下一步骤".
define variable fw_on_id as character format "x(18)" LABEL "审核人" COLUMN-LABEL "审核人".

define variable del-yn   as logic init no.
define var clines as integer initial ? no-undo.
define var entry_num as int.

form
	fw_key           colon 10 /*合同号*/
	skip(1)
 with frame a attr-space side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
	
form 
	fw_cf_nbr
	fw_desc
	fw_nbr
	fw_parent
	fw_on_id
with frame b clines down width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

mainloop:	
repeat with frame a:

    view frame a.
    hide frame b no-pause.

    prompt-for fw_key editing:
      if frame-field = "fw_key" then 	do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp01.i xxfw_mstr fw_key xxfw_key1
            fw_key fw_key xxfw_cf_nbr }
      end.
      else do:
            readkey.
      	    apply lastkey.
      end.
    	if recno <> ? then 	do:
            find first xxfw_mstr where recid(xxfw_mstr) = recno no-lock no-error.
            if avail xxfw_mstr then  do:
                 disp xxfw_key1 @ fw_key with frame a.
            end.
    	end.
    end. /* prompt-for */
      
    /* 合同号不能为空 */
    if input fw_key = "" then do:
    	message("模块不能为空").
			next-prompt fw_key.
      undo mainloop,retry mainloop.
    end. /* if input fw_key = "" */
	 
    ASSIGN fw_key.  /*把屏幕输入的值赋给fw_key*/
  	clear frame b all no-pause.
  		
  		lineloop:
      repeat with frame b:
      	   	
      	prompt-for fw_cf_nbr editing:
          if frame-field = "fw_cf_nbr" then do:
              {mfnp05.i xxfw_mstr xxfw_cf_nbr
               "xxfw_key1 =  input fw_key"
                xxfw_cf_nbr "input fw_cf_nbr"
	     				}
          end.
          else do:
    	      readkey.
      	    apply lastkey.
    	  	end.
    	  	if recno <> ? then  do:
    	      find first xxfw_mstr where recid(xxfw_mstr) = recno no-lock no-error.
    	      if avail xxfw_mstr then  do:
                  disp 	xxfw_cf_nbr @ fw_cf_nbr 
                      	xxfw_on_id @ fw_on_id
                      	xxfw_nbr @ fw_nbr
		      							xxfw_parent @ fw_parent
                  with frame b.
                 	find first xxcf_mstr where xxcf_nbr = input fw_cf_nbr no-lock no-error.
                 	if avail xxcf_mstr then disp xxcf_desc @ fw_desc with frame b.
            end.
    	  	end. /* if recno <> ? */
      	end. /* prompt-for fw_cf_nbr */
      
      	if input fw_cf_nbr = "" then do:
          message("审核步骤不能为空").
	   			undo,retry.
      	end.
 				
 				find first xxcf_mstr where xxcf_nbr = input fw_cf_nbr no-lock no-error.
        if avail xxcf_mstr then disp xxcf_desc @ fw_desc with frame b.
 				else do:
 					message "审核步骤不存在".
 					undo,retry.
 				end.
      	
      	find first xxfw_mstr where xxfw_key1 = fw_key and xxfw_cf_nbr = input fw_cf_nbr no-error.
      	if avail xxfw_mstr then do:
        	 disp		xxfw_cf_nbr @ fw_cf_nbr
        	 				xxfw_nbr @ fw_nbr
		      				xxfw_parent @ fw_parent
                  xxfw_on_id @ fw_on_id
           with frame b.
      	end.	
      	else do on error undo, next lineloop:
      			fw_nbr = "".
      			update fw_nbr .
      			if fw_nbr <> "1" and fw_nbr <> "2" and fw_nbr <> "3" then do:
      				message "因输入1,2,3".
      				undo,retry.
      			end.
      	end.
      	
      	do transaction on error undo,leave:
          
	  			find first xxfw_mstr where xxfw_key1 = fw_key 
	      	and xxfw_cf_nbr = input fw_cf_nbr  no-error.

          if not avail xxfw_mstr then  do:
   	      	create xxfw_mstr.
   	      	assign xxfw_nbr = fw_nbr
   	      				 xxfw_key1 = fw_key
   	      				 xxfw_cf_nbr = input fw_cf_nbr.
            disp	"" @ fw_parent
                  "" @ fw_on_id 
            with frame b.
   	  		end.
          else DO:
              disp  xxfw_parent @ fw_parent
                  	xxfw_on_id @ fw_on_id 
              with frame b.
          END.

          do on error undo,retry:
              
              set	fw_parent when ( fw_nbr <> "3")
		  						fw_on_id
              go-on(CTRL-D F5) with frame b.	
              if lastkey = keycode("f5") or lastkey = keycode("ctrl-d")  then do:
                  del-yn = true.
                  /* PLEASE CONFIRM DELETE */
                  run p-message-question
                  (input 11,
                   input 1,
                   input-output del-yn
		 							 ).
   
                  if del-yn then  do:
               	      clear frame b all no-pause.
		      						delete xxfw_mstr.
               	      next lineloop.
                  end.
              end. /* if lastkey = keycode("f5")*/
              
              DO entry_num = 1 to num-entries(fw_parent) :
              	find first xxcf_mstr where xxcf_nbr = entry(entry_num,fw_parent) no-lock no-error.
              	if not avail xxcf_mstr then do:
              		message entry(entry_num,fw_parent) "不是审批步骤".
              		undo,retry.
              	end.
              end.
              DO entry_num = 1 to num-entries(fw_on_id) :
              	find first usr_mstr where usr_userid = entry(entry_num,fw_on_id) no-lock no-error.
              	if not avail usr_mstr then do:
              		message entry(entry_num,fw_on_id) "不是审批步骤".
              		undo,retry.
              	end.
              end.
              
          end. /* do on error undo,retry */

       		assign
	   	 			xxfw_parent = input fw_parent
	    			xxfw_on_id = input fw_on_id
	    			xxfw_date = today
            xxfw_time = time
            xxfw_user = global_userid.

      end. /* do transaction on error */
   
      down 1 with frame b.
      
  end. /* lineloop */
end. /* repeat */
    
PROCEDURE p-message-question:
   define input        parameter l_num  as   integer     no-undo.
   define input        parameter l_stat as   integer     no-undo.
   define input-output parameter l_yn   like mfc_logical no-undo.

   {pxmsg.i &MSGNUM=l_num &ERRORLEVEL=l_stat &CONFIRM=l_yn}
END PROCEDURE.
