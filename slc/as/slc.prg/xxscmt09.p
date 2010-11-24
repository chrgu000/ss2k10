/*By: Neil Gao 08/07/29 ECO: *SS 20080729* */

/* By: Neil Gao Date: 08/02/14 ECO: * SS 20080214 * */

/* 20080214 - B */
/*
增加显示修改日期
修改记录才更新时间记录
*/
/* 20080214 - e */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "a+ "}


DEFINE VARIABLE vbom_nbr AS  CHARACTER FORMAT "x(8)" LABEL "指定表" COLUMN-LABEL "指定表". 
define variable vbom_cust as character format "x(8)" label "客户代码" COLUMN-LABEL "客户代码".
DEFINE VARIABLE vbom_parent  AS CHARACTER FORMAT "x(18)" LABEL "产品" COLUMN-LABEL "产品".     
DEFINE VARIABLE vbom_part    AS CHARACTER FORMAT "x(18)" LABEL "料号" COLUMN-LABEL "料号".  /*usrw_charfld[8]*/
DEFINE VARIABLE vbom_vend    AS CHARACTER FORMAT "x(8)" LABEL "供应商" COLUMN-LABEL "供应商".
define variable vbom_vend_desc as character format "x(40)".
define variable vbom_cust_desc as character format "x(40)".
define variable vbom_parent_desc as character format "x(40)".
define variable vbom_part_desc as character format "x(40)".

define variable del-yn   as logic init no.
define var clines as integer initial ? no-undo.

form
	vbom_cust           colon 10  /*so1号*/
	vbom_cust_desc  no-label
	vbom_parent   colon 10
	vbom_parent_desc no-label
        vbom_nbr           colon 10 /*合同号*/
 with frame a attr-space side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
	
form 
	vbom_part  
	vbom_vend
/* ss 20080214 - b */
	xxvbomd_date label "日期"
/* ss 20080214 - e */ 
  vbom_part_desc no-label
	vbom_vend_desc no-label
with frame b clines down width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

mainloop:	
repeat with frame a:

    view frame a.
    hide frame b no-pause.

    prompt-for  vbom_cust vbom_parent 
    editing:
        if frame-field = "vbom_cust" then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp01.i xxvbom_mstr vbom_cust "xxvbom_domain = global_domain and xxvbom_cust"
            vbom_cust vbom_cust xxvbom_nbr }
        end.
        else 	do:
            readkey.
      	    apply lastkey.
        end.
    	if recno <> ? then 	do:
            find first xxvbom_mstr where recid(xxvbom_mstr) = recno no-lock no-error.
            if avail xxvbom_mstr then  do:
                disp 	xxvbom_nbr @ vbom_nbr
                    	xxvbom_cust @ vbom_cust
		    							xxvbom_parent @ vbom_parent
		    				with frame a.
								find first ad_mstr where ad_domain= global_domain and ad_addr = input vbom_cust no-lock no-error.
								disp ad_name @ vbom_cust_desc with frame a.
								find first pt_mstr where pt_domain = global_domain and pt_part = input vbom_parent no-lock no-error.
								disp pt_desc1 @ vbom_parent_desc with frame a.
            end.
    	end.
    end. /* prompt-for */
      
     
    find first xxvbom_mstr where xxvbom_domain = global_domain and xxvbom_cust = input vbom_cust and xxvbom_parent = input vbom_parent 
    	and xxvbom_nbr = input vbom_nbr no-lock no-error.
    if avail xxvbom_mstr then  do:
    	disp 	xxvbom_nbr @ vbom_nbr
           	xxvbom_cust @ vbom_cust
		    		xxvbom_parent @ vbom_parent
		  with frame a.
			find first ad_mstr where ad_domain = global_domain and ad_addr = input vbom_cust no-lock no-error.
			disp ad_name @ vbom_cust_desc with frame a.
			find first pt_mstr where pt_domain = global_domain and pt_part = input vbom_parent no-lock no-error.
			disp pt_desc1 @ vbom_parent_desc with frame a.
    end.
    else do:
    	find first ad_mstr where ad_domain = global_domain and ad_addr = input vbom_cust no-lock no-error.
			if not avail ad_mstr then	do:
	     	message("客户不存在").
	     	next-prompt vbom_cust.
	     	undo mainloop,retry mainloop.
			end.

    	find first pt_mstr where pt_domain = global_domain and pt_part = input vbom_parent no-lock no-error.
			if not avail pt_mstr then	do:
	     	message("料号不存在").
	     	next-prompt vbom_parent.
	     	undo mainloop,retry mainloop.
			end.
			find first ad_mstr where ad_domain = global_domain and ad_addr = input vbom_cust no-lock no-error.
			disp ad_name @ vbom_cust_desc with frame a.
			find first pt_mstr where pt_domain = global_domain and pt_part = input vbom_parent no-lock no-error.
			disp pt_desc1 @ vbom_parent_desc with frame a.

    end.

   loop:
    do transaction on error undo, next mainloop:
          set vbom_nbr
	  			go-on (F5 CTRL-D) with frame a
         	editing:
          	if frame-field = "vbom_nbr" then  do:
              {mfnp05.i xxvbom_mstr xxvbom_nbr
               "xxvbom_domain = global_domain and xxvbom_cust =  input vbom_cust and xxvbom_parent = input vbom_parent"
                xxvbom_nbr "input vbom_nbr" }
          	end.
          	else do:
    	      	readkey.
      	      apply lastkey.
    	  		end.
    	  		if recno <> ? then  do:
    	      	find first xxvbom_mstr where recid(xxvbom_mstr) = recno no-lock no-error.
    	      	if avail xxvbom_mstr then  do:
                  disp xxvbom_nbr @ vbom_nbr with frame a.
              end.
    	  		end. /* if recno <> ? */
         	end. /* editing */
/*SS 20080729 - B*/
					if vbom_nbr = "" then do:
						message "指定表不能为空".
						undo,retry.
					end.
/*SS 20080729 - E*/
         	if lastkey = keycode("F5") or
             lastkey = keycode("CTRL-D") then  do:
             del-yn = yes.
             {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         	
	 						if del-yn then  do:
             		for each xxvbom_mstr where xxvbom_domain = global_domain and xxvbom_cust = input vbom_cust AND xxvbom_parent = input vbom_parent and xxvbom_nbr = input vbom_nbr :
                 	delete xxvbom_mstr.
             		end.

             		for each xxvbomd_det where xxvbomd_domain = global_domain and xxvbomd_cust = input vbom_cust AND xxvbomd_parent = input vbom_parent and xxvbomd_nbr = input vbom_nbr :
                 	delete xxvbomd_det.
             		end.

             		clear frame a all no-pause.
             		del-yn = no.
             		next mainloop.
         			end.
         	end.
         	
         	find first xxvbom_mstr where xxvbom_domain = global_domain and xxvbom_cust = input vbom_cust AND xxvbom_parent = input vbom_parent 
    			and xxvbom_nbr = vbom_nbr no-lock no-error.
	 				if not avail xxvbom_mstr then do:
	    			create xxvbom_mstr .
	      		assign  xxvbom_nbr = vbom_nbr
		    				xxvbom_domain = global_domain
		    				xxvbom_parent = input vbom_parent
	            	xxvbom_cust  = input vbom_cust
	            	xxvbom_date = today
                xxvbom_time = time
                xxvbom_user = global_userid
                .
	  			end.
             
  end. /* do transaction on error undo, next mainloop: */

  clear frame b all no-pause.
  lineloop:
      repeat with frame b:   	
      prompt-for vbom_part  editing:
          if frame-field = "vbom_part" then  do:
              {mfnp05.i xxvbomd_det xxvbomd_nbr
               "xxvbomd_domain = global_domain and xxvbomd_cust = input vbom_cust and xxvbomd_parent = input vbom_parent and xxvbomd_nbr =  input vbom_nbr"
                xxvbomd_part "input vbom_part"
	      			}
          end.
          else do:
    	      readkey.
      	    apply lastkey.
    	  	end.
    	  	if recno <> ? then  do:
    	      find first xxvbomd_det where recid(xxvbomd_det) = recno no-lock no-error.
    	      if avail xxvbomd_det then do:
            	disp xxvbomd_part @ vbom_part 
		      			xxvbomd_vend @ vbom_vend
/* ss 20080214 */ xxvbomd_date
            	with frame b.
		  				find first pt_mstr where pt_domain = global_domain and pt_part = input vbom_part no-lock no-error.
		  				disp pt_desc1 @ vbom_part_desc with frame b.
		  				find first ad_mstr where ad_domain = global_domain and ad_addr = input vbom_vend no-lock no-error.
		  				disp ad_name @ vbom_vend_desc with frame b.
          	end.
    	  	end. /* if recno <> ? */
      end. /* prompt-for line */
      
      if input vbom_part = "" then do:
        message("零件不能为空").
	   		undo,retry.
      end.
 			
 			find first pt_mstr where pt_domain = global_domain and pt_part = input vbom_part no-lock no-error.
      if not avail pt_mstr then do:
        message("零件不存在").
	  		undo,retry.
      end.
 			disp pt_desc1 @ vbom_part_desc with frame b.
 			
      if avail pt_mstr then do:
      	del-yn = yes.
    		for each ps_mstr where ps_domain = global_domain and ps_par begins input vbom_parent no-lock:
    			if del-yn = no then leave.
    			if ps_comp = (input vbom_part) then do:
    				del-yn = no.
    				leave.
    			end.
    			find first pt_mstr where pt_domain = global_domain and pt_part = ps_comp and pt_pm_code = "M" no-lock no-error.
    			if avail pt_mstr then do:
    				run if-seach-comp( input pt_part,input (input vbom_part),input-output del-yn ).
    			end.
    			
    		end.
    		if del-yn then do:
    			message "警告:物料不在开发令状态下".
    			undo,retry.
    		end.
    	end.
      
      
      
      find first xxvbomd_det where 
      	xxvbomd_domain = global_domain 
      	and xxvbomd_nbr = xxvbom_nbr
      	and xxvbomd_parent = xxvbom_parent 
      	and xxvbomd_cust = xxvbom_cust
	      and xxvbomd_part = input vbom_part no-error.
      if avail xxvbomd_det then do:
       	disp xxvbomd_part @ vbom_part 
		      	xxvbomd_vend @ vbom_vend
/* ss 20080214 */ xxvbomd_date
       	with frame b.
      	find first ad_mstr where ad_addr = input vbom_vend no-lock no-error.
		  	disp ad_name @ vbom_vend_desc with frame b.
      end.

      do transaction on error undo,leave:
          
          if not avail xxvbomd_det then do:
   	      	create xxvbomd_det.
   	      	assign xxvbomd_domain = global_domain.
      			 disp     "" @ vbom_vend  
/* ss 20080214 */ today @ xxvbomd_date
      			 with frame b.
   	  		end.


/* ss 20071227 - b */
					global_part = input vbom_part.
/* ss 20071227 - e */


          do on error undo,retry:
              set	vbom_vend
              go-on(CTRL-D F5) with frame b.	
              if lastkey = keycode("f5") or lastkey = keycode("ctrl-d")  then  do:
                  del-yn = true.
                  /* PLEASE CONFIRM DELETE */
                  run p-message-question
                  (input 11,
                   input 1,
                   input-output del-yn
		 							 ).
                  if del-yn then  do:
               	      clear frame b all no-pause.
		      						delete xxvbomd_det.
               	      del-yn = no.
               	      next lineloop.
                  end. 
                  
              end. /* if lastkey = keycode("f5")*/
	      			find first ad_mstr where ad_addr = input vbom_vend no-lock no-error.
	      			if not avail ad_mstr then do:
	          		message("供应商不存在").
		  					undo,retry.
	      			end.
	      			else do:
	          		disp ad_name @ vbom_vend_desc with frame b.
	      			end.
	      			find first vp_mstr where vp_domain = global_domain and vp_part = input vbom_part 
	      				and vp_vend = vbom_vend no-lock no-error.
	      			if not avail vp_mstr then do:
	      				message "错误:供应商无此物料".
	      				undo,retry.
	      			end.
          end. /* do on error undo,retry */
					
					if vbom_vend entered then 
       			assign 	xxvbomd_nbr = xxvbom_nbr
	    							xxvbomd_parent = xxvbom_parent
	    							xxvbomd_cust  = xxvbom_cust
	    							xxvbomd_part = input vbom_part
	    							xxvbomd_vend = vbom_vend
	    							xxvbomd_date = today
            				xxvbomd_time = time
            				xxvbomd_user = global_userid.
         
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

procedure if-seach-comp:
	define input parameter iptpar like ps_par.
	define input parameter iptcomp like ps_comp.
	define input-output parameter iptyn as logical.
	
	if iptyn = no then return.
	for each ps_mstr where ps_domain = global_domain and ps_par = iptpar no-lock:
		if ps_comp = iptcomp then do:
			iptyn = no.
			return.
		end.
    find first pt_mstr where pt_domain = global_domain and pt_part = ps_comp and pt_pm_code = "M" no-lock no-error.
    if avail pt_mstr then do:
    	run if-seach-comp( input pt_part,input iptcomp,input-output iptyn ).
    end.
	end.
end procedure.