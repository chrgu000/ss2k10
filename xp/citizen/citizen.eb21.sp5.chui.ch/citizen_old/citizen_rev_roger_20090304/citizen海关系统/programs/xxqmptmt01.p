/* xxqmptmt01.p 海关商品编码维护                                            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 01/22/2008   BY: Softspeed tommy xie         */


         /* DISPLAY TITLE */
          {mfdtitle.i "1.0 "}

         define variable xxcpt_recid as recid.
         define variable new_add as logical.
         define variable l_type as integer.
         define variable del-yn like mfc_logical initial no.
         define variable ctry_desc like xxctry_name.
         define buffer xxcptmstr for xxcpt_mstr.


         form
            xxcpt_ln        colon 20 label "商品序号"
            xxcpt_cu_part   colon 20 label "海关商品编码"
            xxcpt_desc      colon 16 label "海关品名"
            xxcpt_um        colon 20 label "海关单位"
            xxcpt_wt_conv   colon 20 label "海关单重"
            xxcpt_price     colon 20 label "海关单价"
            /*xxcpt_ctry_code colon 20 label "产终地" ctry_desc no-label */
            xxcpt_tax     colon 20 label "征免" space(0) "(Y=全免, N=照章)"
         with frame a side-labels attr-space width 80.

         transloop:
         repeat with frame a:
            do on error undo, retry with frame a:
               prompt-for xxcpt_ln with frame a editing:
                  if frame-field="xxcpt_ln" then do:
                     {mfnp01.i xxcpt_mstr xxcpt_ln xxcpt_ln global_domain xxcpt_domain xxcpt_ln}

                     if recno <> ? then do:
                        /*find first xxctry_mstr no-lock where xxctry_domain = global_domain
                               and xxctry_code = xxcpt_ctry_code no-error .
                        
                        ctry_desc = (if available xxctry_mstr then xxctry_name else "").*/

                        display xxcpt_ln xxcpt_cu_part xxcpt_desc
                                xxcpt_um xxcpt_wt_conv xxcpt_price
                                /*xxcpt_ctry_code
                                ctry_desc*/
                                xxcpt_tax                        
                        with frame a.
                     end.
                  end.
                  else do:
                     status input ststatus.
                     readkey.
                     apply lastkey.
                  end.
               end.
             
               find first xxcpt_mstr where xxcpt_ln = input xxcpt_ln
                      and xxcpt_domain = global_domain exclusive-lock no-error.
               if not available xxcpt_mstr then do:
                  {mfmsg.i 1 1} /*ADDING NEW RECORD */
                  create xxcpt_mstr.
                  assign xxcpt_ln = input xxcpt_ln
                         xxcpt_domain = global_domain
                         xxcpt_um = "KG"
                         xxcpt_wt_conv = 1 
                         xxcpt_tax = "Y"
                         xxcpt_cr_date = today
                         new_add = yes.
                         xxcpt_recid = recid(xxcpt_mstr).
               end.
               else do:
                  new_add = no.
                  {mfmsg.i 10 1}
               end.

               /*find first xxctry_mstr no-lock where xxctry_domain = global_domain
                      and xxctry_code = xxcpt_ctry_code no-error .
                        
               ctry_desc = (if available xxctry_mstr then xxctry_name else "").*/

               display xxcpt_ln xxcpt_cu_part xxcpt_desc
                       xxcpt_um xxcpt_wt_conv xxcpt_price
                       /*xxcpt_ctry_code ctry_desc*/
                       xxcpt_tax                        
               with frame a.

               do on error undo , retry with frame a:
                  set xxcpt_cu_part when new_add
                      xxcpt_desc
                      xxcpt_um 
                      xxcpt_wt_conv 
                      xxcpt_price
                      /*xxcpt_ctry_code*/ 
                      xxcpt_tax                                              
                      go-on("F5" "CTRL-D")
                   with frame a . /*editing:
                      if frame-field = "xxcpt_ctry_code" then do:
                        {mfnp01.i xxctry_mstr xxcpt_ctry_code xxctry_code global_domain xxctry_domain xxctry_code}
                        
                        if recno <> ? then do:
                           ctry_desc = xxctry_name.

                           display xxctry_code @ xxcpt_ctry_code ctry_desc with frame a.
                        end.
                      end.
                      else do:
                         status input ststatus.
                         readkey.
                         apply lastkey.
                      end.
                   end.

                   find first xxctry_mstr where xxctry_domain = global_domain
                         and xxctry_code = xxcpt_ctry_code no-lock no-error.

                   if not available xxctry_mstr then do:
                      message "错误：产终地不存在,请重新输入".
                      next-prompt xxcpt_ctry_code with frame a.
                      undo, retry.                     
                   end.
                   else display xxctry_name @ ctry_desc with frame a.*/

                  if lastkey = keycode("F5")
                     or lastkey = keycode("CTRL-D")
                  then do:
                     del-yn = no.            
                     {mfmsg01.i 11 1 del-yn}

                     if not del-yn then undo, retry.

                     if del-yn then do:
                        delete xxcpt_mstr.
                        clear frame a.
                        del-yn = no.
                        next.
                     end.
                  end.

                  if xxcpt_cu_part = "" then do:
                     message "错误：商品编码不允许为空，请重新输入！".
                     next-prompt xxcpt_cu_part with frame a.
                     undo, retry.                  
                  end.

                  if xxcpt_desc = "" then do:
                     message "错误：品名不允许为空，请重新输入！".
                     next-prompt xxcpt_desc with frame a.
                     undo, retry.                  
                  end.

                  if xxcpt_um = ""  then do:
                     message "错误：海关单位不允许为空，请重新输入！".
                     next-prompt xxcpt_um with frame a.
                     undo, retry.                  
                  end.

                  if  not (  {gpcode.v  xxcpt_um pt_um } ) then do :
                     message "错误：计量单位不存在，请重新输入！".
                     next-prompt xxcpt_um with frame a.
                     undo, retry.  
                  end.

                  if xxcpt_wt_conv = 0  then do:
                     message "错误：海关单重不允许为零，请重新输入！".
                     next-prompt xxcpt_wt_conv with frame a.
                     undo, retry.                  
                  end.

                  if xxcpt_um = "KG" and xxcpt_wt_conv <> 1   then do:
                     message "错误：海关单位KG,单重不为1，请重新输入！".
                     next-prompt xxcpt_wt_conv with frame a.
                     undo, retry.                  
                  end.

                  if xxcpt_tax = "" then do:
                     message "错误：不允许为空，请重新输入！".
                     next-prompt xxcpt_tax with frame a.
                     undo, retry.                  
                  end.
                  
                  if lookup(xxcpt_tax,"Y,N") = 0 then do:
                     message "错误：必须是'Y'或'N'，请重新输入！".
                     next-prompt xxcpt_tax with frame a.
                     undo, retry.                  
                  end.
                  
                  /*xxcpt_type 需要这样用吗? 是否用来放是否成品*************
                  if new_add then do:
                     l_type = 0.  
                    
                     find first xxcptmstr where xxcptmstr.xxcpt_domain = global_domain 
                        and xxcptmstr.xxcpt_cu_part = input xxcpt_mstr.xxcpt_cu_part
                        and recid(xxcptmstr) <> xxcpt_recid no-lock no-error.
                     
                     if available xxcptmstr then l_type = integer(xxcptmstr.xxcpt_type).

                     if not available xxcptmstr then do:
                        for each xxcptmstr no-lock
                           where xxcptmstr.xxcpt_domain = global_domain 
                             and recid(xxcptmstr) <> xxcpt_recid
                        break by xxcptmstr.xxcpt_type:                        
                           l_type = integer(xxcptmstr.xxcpt_type).
                        end.
                        l_type = l_type + 1.
                     end.
                     
                     if l_type = 0 then l_type = 1.

                     xxcpt_mstr.xxcpt_type = string(l_type,"999").
                  end.*/
               end.
            end.
         end.