/* xxqmplan.p 海关进口计划维护                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 01/25/2008   BY: Softspeed tommy xie         */


         /* DISPLAY TITLE */
         {mfdtitle.i "1.0 "}

         define variable li_line as integer.
         define variable line as integer format ">>9".
         define variable cu_part like xxcpt_cu_part.
         define variable cu_um   like xxcpt_um.
         define variable cu_desc like xxcpt_desc.
         define variable cu_qty  like xxepld_cu_qty.
         define variable pm_code like pt_pm_code.
         define variable del-yn  like mfc_logical initial no.

         
         form
            xxepl_nbr   colon 14 label "计划出口单号"
            xxepl_start colon 38 label "出口期间"
            xxepl_end   colon 52 label "至"
            xxepl_rmk   colon 14 label "备注"
         with frame a side-labels attr-space width 80.

         form 
            line          label "行"
            xxepld_part   label "零件号"
            xxepld_edate  label "出口日期"
            xxepld_qty    label "数量"  format ">,>>>,>>9.99"
            pt_um         label "单位"
            xxcpt_cu_part label "商品编号"
            xxcpt_um      label "单位"
            xxepld_cu_qty label "海关数量"  format ">>>,>>9.99"
         with frame b three-d overlay 12 down scroll 1 width 80.


         mainloop:
         repeat with frame a:         
            view frame a.
            view frame b.

            do transaction with frame a on endkey undo, leave mainloop:
               prompt-for xxepl_nbr with frame a editing:
                  if frame-field = "xxepl_nbr" then do:
                     {mfnp01.i xxepl_mstr xxepl_nbr xxepl_nbr global_domain xxepl_domain xxepl_nbr}

                     if recno <> ? then do:
                        display xxepl_nbr xxepl_start xxepl_end xxepl_rmk with frame a.
                     end.
                  end.
                  else do:
                     status input ststatus.
                     readkey.
                     apply lastkey.
                  end.
               end.

               if input xxepl_nbr = "" then do:
                  {mfmsg.i 40 3}
                  next-prompt xxepl_nbr with frame a.
                  undo, retry.               
               end.

               find first xxepl_mstr where xxepl_domain = global_domain 
                  and xxepl_nbr = input xxepl_nbr exclusive-lock no-error.

               if not available xxepl_mstr then do:
                  create xxepl_mstr.
                  assign 
                     xxepl_domain  = global_domain
                     xxepl_nbr     = input xxepl_nbr
                     xxepl_cr_date = today
                     xxepl_userid  = global_domain.
               end.

               display xxepl_nbr xxepl_start xxepl_end xxepl_rmk with frame a.

               do on error undo , retry with frame a:
                  set xxepl_start xxepl_end xxepl_rmk
                      go-on (F5 CTRL-D)
                  with frame a.

                  if (lastkey = keycode("F5") or
                      lastkey = keycode("CTRL-D"))
                  then do:
                     del-yn = yes.
                     /* Please confirm delete */
                     {mfmsg01.i 11 1 del-yn}

                     if del-yn then do:
                        li_line = 0.
                        for each xxepld_det where xxepld_domain = global_domain
                             and xxepld_nbr = input xxepl_nbr exclusive-lock:
                           li_line = li_line + 1.
                           delete xxepld_det.
                        end.
                        delete xxepl_mstr.

                        /* Line item record(s) deleted*/
                        {pxmsg.i
                            &MSGNUM=24
                            &ERRORLEVEL=3
                            &MSGARG1=li_line}
                        hide message.

                        clear frame a all no-pause.
                        clear frame b all no-pause.
                        next mainloop.
                     end.
                     else undo, retry.
                  end.

                  if xxepl_start = ? then do:
                     {mfmsg.i 27 3}
                     next-prompt xxepl_start with frame a.
                     undo, retry.               
                  end.

                  if xxepl_end = ? then do:
                     {mfmsg.i 27 3}
                     next-prompt xxepl_end with frame a.
                     undo, retry.               
                  end.
               end.
            end.

            line = 1.
            find last xxepld_det where xxepld_domain = global_domain
                  and xxepld_nbr = input xxepl_nbr no-lock no-error.
            if available xxepld_det then line = xxepld_ln + 1.

            lineloop:
            repeat on endkey undo, leave:
               clear frame b all no-pause.

               for each xxepld_det where xxepld_domain = global_domain
                    and xxepld_nbr = input xxepl_nbr no-lock
               break by xxepld_ln :
                  cu_part = "".
                  cu_um   = "".                   
                  
                  find first xxccpt_mstr where xxccpt_domain = global_domain
                         and xxccpt_part = xxepld_part no-lock no-error.
             
                  if available xxccpt_mstr then do:
                     find first xxcpt_mstr where xxcpt_domain = global_domain
                            and xxcpt_ln = xxccpt_ln no-lock no-error.

                     if available xxcpt_mstr then do:
                        cu_part = xxcpt_cu_part.
                        cu_um   = xxcpt_um.                   
                     end.
                  end.

                  find first pt_mstr where pt_domain = global_domain
                         and pt_part = xxepld_part no-lock no-error.
                  
                  display
                     xxepld_ln @ line
                     xxepld_part
                     xxepld_edate
                     xxepld_qty
                     pt_um when available pt_mstr
                     cu_part @ xxcpt_cu_part 
                     cu_um @ xxcpt_um
                     xxepld_cu_qty 
                  with down frame b.                     

                  if frame-line(b) = frame-down(b) then leave.
                  down 1 with frame b.
               end.  /* FOR EACH POD_DET */

               update line with frame b
               editing:
                  {mfnp01.i xxepld_det line xxepld_ln "input xxepl_nbr and xxepld_domain = global_domain" 
                            xxepld_nbr xxepld_nbr}
                  
                  if recno <> ? then do:
                     cu_part = "".
                     cu_um   = "".                   
                  
                     find first xxccpt_mstr where xxccpt_domain = global_domain
                         and xxccpt_part = xxepld_part no-lock no-error.
             
                     if available xxccpt_mstr then do:
                        find first xxcpt_mstr where xxcpt_domain = global_domain
                            and xxcpt_ln = xxccpt_ln no-lock no-error.

                        if available xxcpt_mstr then do:
                           cu_part = xxcpt_cu_part.
                           cu_um   = xxcpt_um. 
                        end.
                     end.
                      
                     find first pt_mstr where pt_domain = global_domain
                         and pt_part = xxepld_part no-lock no-error.
                  
                     display
                        xxepld_ln @ line
                        xxepld_part
                        xxepld_edate
                        xxepld_qty
                        pt_um when available pt_mstr
                        cu_part @ xxcpt_cu_part 
                        cu_um @ xxcpt_um
                        xxepld_cu_qty 
                     with down frame b.                     
                  end.
               end.
               
               if line = 0 then leave .

               find first xxepld_det where xxepld_domain = global_domain
                    and xxepld_nbr = input xxepl_nbr
                    and xxepld_ln = input line exclusive-lock no-error.

               /* add a new line for Pur */
               if not available xxepld_det then do:
                  create xxepld_det.
                  assign
                     xxepld_domain = global_domain
                     xxepld_nbr = input xxepl_nbr
                     xxepld_ln = input line
                     xxepld_edate = input xxepl_start.
               end.
               
               cu_part = "".
               cu_um   = "".                   
                  
               find first xxccpt_mstr where xxccpt_domain = global_domain
                      and xxccpt_part = xxepld_part no-lock no-error.
             
               if available xxccpt_mstr then do:
                  find first xxcpt_mstr where xxcpt_domain = global_domain
                         and xxcpt_ln = xxccpt_ln no-lock no-error.

                  if available xxcpt_mstr then do:
                     cu_part = xxcpt_cu_part.
                     cu_um   = xxcpt_um.                   
                  end.
               end.
             
               find first pt_mstr where pt_domain = global_domain
                      and pt_part = xxepld_part no-lock no-error.
                  
               display
                  xxepld_ln @ line
                  xxepld_part
                  xxepld_edate
                  xxepld_qty
                  pt_um when available pt_mstr
                  cu_part @ xxcpt_cu_part 
                  cu_um @ xxcpt_um
                  xxepld_cu_qty 
               with down frame b.                     

               sub1loop:
               do on error undo, retry with frame b:
                  set xxepld_part
                      xxepld_edate
                      xxepld_qty
                      go-on (F5 CTRL-D)
                  with frame b editing:
                     if frame-field = "xxepld_part" then do:
                        {mfnp01.i pt_mstr xxepld_part pt_part global_domain pt_domain pt_part}
                        
                        if recno <> ? then do:                           
                           cu_part = "".
                           cu_um   = "".                   
                           cu_desc = "".
                           find first xxccpt_mstr where xxccpt_domain = global_domain
                                  and xxccpt_part = pt_part no-lock no-error.
             
                           if available xxccpt_mstr then do:
                              find first xxcpt_mstr where xxcpt_domain = global_domain
                                     and xxcpt_ln = xxccpt_ln no-lock no-error.

                              if available xxcpt_mstr then do:
                                 cu_part = xxcpt_cu_part.
                                 cu_desc = xxcpt_desc.
                                 cu_um   = xxcpt_um.                   
                              end.
                           end.

                           display
                              pt_part @ xxepld_part
                              pt_um 
                              cu_part @ xxcpt_cu_part 
                              cu_um @ xxcpt_um.

                           message "零件:" + pt_part + "  " + pt_desc1 + ", 商品:" + cu_part + " " + cu_desc.
                        end.
                     end.
                     else do:
                        status input ststatus.
                        readkey.
                        apply lastkey.
                     end.
                  end.

                  if (lastkey = keycode("F5") or
                      lastkey = keycode("CTRL-D"))
                  then do:
                     del-yn = yes.
                     /* Please confirm delete */
                     {mfmsg01.i 11 1 del-yn}

                     if del-yn then do:
                        delete xxepld_det.

                        /* Line item record(s) deleted*/
                        {pxmsg.i
                            &MSGNUM=24
                            &ERRORLEVEL=1
                            &MSGARG1=1}
                        hide message.

                        clear frame b all no-pause.
                        next lineloop.
                     end.
                     else undo, retry.
                  end.

                  find first pt_mstr where pt_domain = global_domain
                         and pt_part = input xxepld_part no-lock no-error.
                  if not available pt_mstr then do:
                     message "错误：零件编号不存在，请重新输入！".
                     next-prompt xxepld_part with frame b.
                     undo, retry.                  
                  end.
                  pm_code = pt_pm_code.
                 
                  cu_part = "".
                  cu_um   = "".                   
                  cu_desc = "".
                  find first xxccpt_mstr where xxccpt_domain = global_domain
                         and xxccpt_part = input xxepld_part no-lock no-error.
             
                  if available xxccpt_mstr then do:
                     find first xxcpt_mstr where xxcpt_domain = global_domain
                            and xxcpt_ln = xxccpt_ln no-lock no-error.

                     if available xxcpt_mstr then do:
                        cu_part = xxcpt_cu_part.
                        cu_desc = xxcpt_desc.
                        cu_um   = xxcpt_um.                   
                     end.

                     if not available xxcpt_mstr then do:
                        message "错误：海关商品编号维护没有维护, 请重新输入！".
                        next-prompt xxepld_part with frame b.
                        undo, retry.                                 
                     end.
                  end.

                  if not available xxccpt_mstr then do:
                     message "错误：海关零件维护没有维护, 请重新输入！".
                     next-prompt xxepld_part with frame b.
                     undo, retry.                                 
                  end.

                  display
                     pt_part @ xxepld_part
                     pt_um 
                     cu_part @ xxcpt_cu_part 
                     cu_um @ xxcpt_um
                  with frame b.

                  if xxepld_edate = ? then do:
                     {mfmsg.i 27 3}
                     next-prompt xxepld_edate with frame b.
                     undo, retry.               
                  end.

                  if not (xxepld_edate >= xxepl_start and xxepld_edate <= xxepl_end) then do:
                     message "错误：出口日期必须在出口期间范围内，请重新输入!".
                     next-prompt xxepld_edate with frame b.
                     undo, retry.                                 
                  end.

                  if xxepld_qty = 0 then do:
                     message "错误：数量不允许为 0, 请重新输入！".
                     next-prompt xxepld_qty with frame b.
                     undo, retry.                                 
                  end.
               end.
               cu_qty = xxepld_qty * xxccpt_um_conv.
               
               display cu_qty @ xxepld_cu_qty with frame b.

               message "零件:" + pt_part + "  " + pt_desc1 + ", 商品:" + cu_part + " " + cu_desc.

               do on error undo, retry with frame b:
                  set xxepld_cu_qty.

                  if xxepld_cu_qty = 0 then do:
                     message "错误：数量不允许为 0, 请重新输入！".
                     next-prompt xxepld_cu_qty with frame b.
                     undo, retry.                                 
                  end.
               end.
               line = line + 1.

               down 1 with frame b.
            end.
         end.
