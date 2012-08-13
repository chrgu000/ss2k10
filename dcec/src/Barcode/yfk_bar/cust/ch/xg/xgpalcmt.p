/*****************************************************
** Program: xgpalcmt.p
** Author : hou
** Date   : 2005/12/13
** Description: Generate Pallet number
** Copy from xgpalcmt created by Li Wei
**
** Last Modified :    YYYY/MM/DD      BY   XXXX  *XXX*
** 
*****************************************************/

        {mfdtitle.i "ao"}
        
        define var desc1  like pt_desc1.
        define var del-yn as   logical.
        
        
        FORM
          RECT-FRAME       AT ROW 1 COLUMN 1.25
          RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
          SKIP(.1)
           xpal_part        colon 30 
           desc1            at    50 NO-LABEL 
           xpal_code        colon 30
           xpal_line        colon 30
           xgpl_desc        at    50 no-label format "x(24)"
           xpal_next_nbr    colon 30
           xpal_qty_def     colon 30
           xpal_full_qty    colon 30
           xpal_sub_qty     colon 30
           xpal_cust_def    colon 30
           xpal_dloc_def    colon 30  
          skip(.4)
        WITH frame a side-labels width 80 attr-space THREE-D .

        mainloop:
        repeat on error undo,retry :
             
           VIEW FRAME a.

             prompt-for xpal_part xpal_code xpal_line WITH FRAME a editing:
               
                  {mfnp.i xpal_ctrl xpal_part xpal_part xpal_code xpal_code  xpal_code}
                  if recno <> ? then do:
                     FIND FIRST pt_mstr WHERE pt_part = INPUT xpal_part NO-LOCK NO-ERROR.
                     if avail pt_mstr then desc1 = pt_desc1.
                     else desc1 = "".
                     find first xgpl_ctrl where xgpl_lnr = xpal_line no-lock no-error.
                     DISP xpal_part 
                          desc1 
                          xpal_code
                          xpal_line
                          xgpl_desc
                          xpal_next_nbr
                          xpal_qty_def 
                          xpal_full_qty
                          xpal_sub_qty
                          xpal_cust_def
                          xpal_dloc_def
                     with frame a.
                  end.
               
               
             end.

/******************           
             prompt-for xpal_part xpal_code xpal_line WITH FRAME a editing:
                  {mfnp.i xpal_ctrl xpal_part xpal_part xpal_code xpal_code  xpal_code}
                  if recno <> ? then do:
                     DISP xpal_part 
                          xpal_code
                          xpal_line
                          xpal_next_nbr
                          xpal_qty_def 
                          xpal_cust_def
                          xpal_dloc_def
                     with frame a.
                  end.
               
             end.
             
***************/             

             find first xgpl_ctrl where xgpl_lnr = input xpal_line no-lock no-error.
             if not avail xgpl_ctrl then do:
                {mfmsg.i 8524 1 }
                next-prompt xpal_line with frame a.
                undo,retry.
             end.  
             disp xgpl_desc with frame a.
             
             find first pt_mstr where pt_part = input xpal_part no-lock no-error.
             if not avail pt_mstr then do:
                 {mfmsg.i 16 3}
                 undo,retry.
             end.
             desc1 = pt_desc1.
             disp desc1 with frame a.
             
             find first xpal_ctrl where xpal_part = input xpal_part and xpal_code = input xpal_code
             and xpal_line = input xpal_line exclusive-lock no-error.
             if not available xpal_ctrl then do:
                {mfmsg.i 1 1}
                create xpal_ctrl.
                assign xpal_part 
                       xpal_code 
                       xpal_line .
             end.
             disp xpal_next_nbr xpal_qty_def xpal_full_qty
                  xpal_sub_qty xpal_cust_def xpal_dloc_def 
             with frame a.         
             
             ststatus = stline[2].
             status input ststatus.
             del-yn = no.
 
             set1:
             do on error undo, retry:
                set xpal_next_nbr 
                    xpal_qty_def
                    xpal_full_qty
                    xpal_sub_qty
                    xpal_cust_def
                    xpal_dloc_def             
                go-on ("CTRL-D" "F5") 
                with frame a.
        
                if input xpal_next_nbr <= 0 then do:
                   message "序号必须大于零" VIEW-AS ALERT-BOX error.
                   undo,retry.
                end.
           
                if input xpal_full_qty = 0 or input xpal_sub_qty = 0 then do:
                   message "包装数量不可为零" VIEW-AS ALERT-BOX error.
                   undo, retry.
                end.
                
                if (input xpal_full_qty mod input xpal_sub_qty) <> 0 then do:
                   message "整包装量必须是分包装量的整数倍" VIEW-AS ALERT-BOX error.
                   undo, retry.
                end.
                
                if not can-find(first cm_mstr where cm_addr = input xpal_cust_def) then do:
                   {mfmsg.i 3 3}
                   undo, retry.
                end.
                
                if not can-find(first loc_mstr where loc_loc = input xpal_dloc_def) then do:
                   {mfmsg.i 709 3}
                   undo, retry.
                end.
                   
                if lastkey = keycode("CTRL-D") or
                   lastkey = keycode("F5") then do:
                      del-yn = no.
                      {mfmsg01.i 11 1 del-yn}
                      if del-yn = no then undo, retry.
                      else do :
                           delete xpal_ctrl.
                           clear frame a.
                           next mainloop.
                      end.
                end.
                
                assign xpal_next_nbr
                       xpal_qty_def
                       xpal_full_qty
                       xpal_sub_qty
                       xpal_cust_def
                       xpal_dloc_def.
              
             END. 
        end. /* mainloop */
        
        
        
        
        
        
        
        
        
        
        
        
        
