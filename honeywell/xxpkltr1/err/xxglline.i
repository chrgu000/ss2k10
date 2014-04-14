/* $Revision: eB2.1SP5 LAST MODIFIED: 02/14/12 BY: Apple Tam *SS - 20120214.1* */


   CLEAR   frame c all no-pause.
   CLEAR   frame d all no-pause.
   view frame c .

   view frame d .
   choice = no .

line_loop:
repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

   line_loop_1:
   repeat :
          
/*GUI*/ if global-beam-me-up then undo, leave.

           vv_recid       = ? .
           vv_first_recid = ? .
           v_framesize    = 8 .

          CLEAR   frame c all no-pause.

         if not can-find(first tt1) then leave.

           scroll_loop:
           do with frame c:
               {xxglview.i 
                   &domain       = "true and "
                   &buffer       = tt1
                   &scroll-field = tt1_part
                   &searchkey    = "true"
                   &framename    = "c"
                   &framesize    = 8
                   &display1     = tt1_seq
                   &display2     = tt1_part
                   &display3     = tt1_loc_from   
                   &display4     = tt1_loc_to
                   &display5     = tt1_qty_req
                   &display6     = tt1_qty_iss   
                   &exitlabel    = scroll_loop
                   &exit-flag    = "true"
                   &record-id    = vv_recid
                   &first-recid  = vv_first_recid
                   &logical1     = true 
            }

         
        end. /*scroll_loop*/

        if keyfunction(lastkey) = "end-error"
            or lastkey = keycode("F4")
            or lastkey = keycode("ESC")
        then do:
                {mfmsg01.i 4841 1 choice} /*是否退出?*/ 
                if choice = yes then do :
                  /* 保存录入的qty—tmp*/
		  for each tt1 :
		      for first xxpkld_det where xxpkld_nbr = xxpklm_nbr and xxpkld_line = tt1_seq :
                           xxpkld_qty_tmp = tt1_qty_iss.
		      end.

		  end.

                    undo mainloop ,RETRY .
                end.
        end.  /*if keyfunction(lastkey)*/  
        
        if   keyfunction(lastkey)  = "F1"   or keyfunction(lastkey)  = "go" /*F1 提示是否转仓*/
        then do:


               for each  tt1 where tt1_qty_iss <> 0 no-lock :
   		   find first ld_det where  ld_site = tt1_site and ld_loc = tt1_loc_from and ld_part = tt1_part no-lock no-error.
   			if not avail ld_det or ld_qty_oh < tt1_qty_iss then do:
   				message "库存不够" tt1_part.
   				next line_loop_1.
   			end. /* if not avail ld_det  */
               end.  /*  for each  tt1 */
            v_yn1 = no . /*v_yn1 = yes 玥ぃ癶 */
            {mfmsg01.i 12 1 v_yn1} 
            if v_yn1 = yes then do :
               /*转仓       */
		   leave line_loop .

            end. 

        end.  /*if keyfunction(lastkey)*/  

        if  keyfunction(lastkey)  = "return"  /* 回车,修改发货数量. */
        then do:

               /*   vv_recid    */
              leave line_loop_1 .


        end.  /*if keyfunction(lastkey)*/  

   END. /* line_loop_1:*/

  
   view frame d .
      find tt1 where recid(tt1) = vv_recid no-lock no-error.
      if available  tt1 then
       v_seq = tt1_seq .

   line_loop_2:
   repeat with frame d :


      update v_seq  with frame d .
      find tt1 where tt1_seq = v_seq no-error.
      if not available  tt1 then do:
          message "项次不存在!".
	  next line_loop_2 .
      end. /*  if not available  tt1 */
      display 
      tt1_seq        @ v_seq     
      tt1_part       @ v_part
      tt1_loc_from   @ v_loc_from
      tt1_loc_to     @ v_loc_to
      tt1_qty_req    @ v_qty_req
      tt1_qty_iss    @ v_qty_iss with frame d .


      v_qty_iss = tt1_qty_iss .
      update  v_qty_iss with frame d .
      tt1_qty_iss = v_qty_iss.

         down frame-down(c) - frame-line(c) + 1  with frame c .
         display tt1_seq tt1_part  tt1_loc_from tt1_loc_to tt1_qty_req tt1_qty_iss with frame c .

   end. /* line_loop_2:*/

end. /*line_loop*/

