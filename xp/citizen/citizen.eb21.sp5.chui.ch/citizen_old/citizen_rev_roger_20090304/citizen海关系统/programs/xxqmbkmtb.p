/* xxqmbkmta.p - Custom HB Export Book Entry                                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/*V8:RunMode=Character,Windows                                              */

/* REVISION: 1.0      Create : 02/25/2008   BY: Softspeed tommy xie         */

  
         {mfdeclre.i}
         {gplabel.i} /* EXTERNAL LABEL INCLUDE */

         define shared variable l-key as character format "x(12)" no-undo.
         
         define variable line as integer format ">>9" label "序".
         define variable ext_cost as decimal format ">>>,>>>,>>9.99".  
         define variable new_add as logical.
         define variable del-yn  like mfc_logical initial no.

         {xxqmbkmt01.i }

         form
            line               column-label "序"
            xxcbkd_cu_ln       column-label "商品序"
            xxcbkd_cu_part     column-label "商品编号"
            xxcbkd_qty_ord     column-label "数量"
            xxcbkd_um
            xxcbkd_price       column-label "单价" format ">>,>>9.9<<<<"
            ext_cost           column-label "总值"
            xxcbkd_ctry_code   column-label "产地"
            xxcbkd_tax         format "Y 征/N 免" column-label "征免"            
            xxcbkd_stat        column-label "状"
         with frame b three-d overlay 9 down row 9 title color normal "进口成品" scroll 1 width 80.

         line = 0.
         find last xxcbkd_det where xxcbkd_domain = global_domain
               and xxcbkd_bk_nbr = l-key and xxcbkd_bk_type = "imp" no-lock no-error.
         if available xxcbkd_det then line = xxcbkd_bk_ln.

         lineloop:
         repeat on endkey undo, leave:
            clear frame b all no-pause.

            if line < 999 then line = line + 1.
            else if line = 999 then do:
               /* Line number cannot exceed 999 */
               {mfmsg.i 7418 2}
            end.
            display line with frame b.

            for each xxcbkd_det no-lock
               where xxcbkd_domain = global_domain
                 and xxcbkd_bk_nbr = l-key and xxcbkd_bk_type = "imp"
            break by xxcbkd_bk_ln :                  
               ext_cost = xxcbkd_price * xxcbkd_qty_ord.
               
               display
                  xxcbkd_bk_ln @ line
                  xxcbkd_cu_ln
                  xxcbkd_cu_part
                  xxcbkd_ctry_code
                  xxcbkd_qty_ord
                  xxcbkd_um
                  xxcbkd_price
                  ext_cost
                  xxcbkd_tax
                  xxcbkd_stat
               with down frame b.                     
             
               if frame-line(b) = frame-down(b) then leave.
               down 1 with frame b.
            end.  /* FOR EACH POD_DET */

            update line with frame b
            editing:
               {mfnp01.i xxcbkd_det line xxcbkd_bk_ln l-key "xxcbkd_domain = global_domain and xxcbkd_bk_type = 'imp' and xxcbkd_bk_nbr" xxcbkd_bk_nbr}
                  
               if recno <> ? then do:
                  ext_cost = xxcbkd_price * xxcbkd_qty_ord.
               
                  display
                     xxcbkd_bk_ln @ line
                     xxcbkd_cu_ln
                     xxcbkd_cu_part
                     xxcbkd_ctry_code
                     xxcbkd_qty_ord
                     xxcbkd_um
                     xxcbkd_price
                     ext_cost
                     xxcbkd_tax
                     xxcbkd_stat
                  with down frame b.                     
               end.
            end.
            
            if line = 0 then leave .

            find first xxcbkd_det where xxcbkd_domain = global_domain
                    and xxcbkd_bk_nbr = l-key and xxcbkd_bk_type = "imp"
                    and xxcbkd_bk_ln = input line exclusive-lock no-error.

            /* add a new line for Pur */
            new_add = no.
            if not available xxcbkd_det then do:
               create xxcbkd_det.
               assign
                  xxcbkd_domain = global_domain
                  xxcbkd_bk_nbr = l-key
                  xxcbkd_bk_type = "imp"
                  xxcbkd_bk_ln = input line
                  new_add = yes.

               display 
                  line 
               with frame b.

               {mfmsg.i 1 1}
            end.
            else do:               
               {mfmsg.i 10 1}
               
               ext_cost = xxcbkd_price * xxcbkd_qty_ord.
               
               display
                  xxcbkd_bk_ln @ line
                  xxcbkd_cu_ln
                  xxcbkd_cu_part
                  xxcbkd_ctry_code
                  xxcbkd_qty_ord
                  xxcbkd_um
                  xxcbkd_price
                  ext_cost
                  xxcbkd_tax
                  xxcbkd_stat
               with down frame b.                     
            end.

            sub1loop:
            do on error undo, retry with frame b:            
               if new_add then
               do on error undo, retry with frame b:
                  set xxcbkd_cu_ln 
                  with frame b editing:
                     if frame-field = "xxcbkd_cu_ln" then do:
                        {mfnp01.i xxcpt_mstr xxcbkd_cu_ln xxcpt_ln global_domain xxcpt_domain xxcpt_ln}

                        if recno <> ? then do:
                           display
                              xxcpt_ln        @ xxcbkd_cu_ln
                              xxcpt_cu_part   @ xxcbkd_cu_part
                              xxcpt_ctry_code @ xxcbkd_ctry_code
                              xxcpt_um        @ xxcbkd_um
                              xxcpt_price     @ xxcbkd_price
                              0               @ xxcbkd_qty_ord
                              xxcpt_tax       @ xxcbkd_tax
                              "N 免"          @ xxcbkd_tax
                           with frame b.

                           hide message no-pause.
                           message xxcpt_desc.
                        end.
                     end.
                     else do:
                        status input ststatus.
                        readkey.
                        apply lastkey.
                     end.
                  end.

                  find first xxcpt_mstr no-lock where xxcpt_domain = global_domain
                      and xxcpt_ln = input xxcbkd_cu_ln no-error.

                  if not available xxcpt_mstr then do:
                     {mfmsg03.i 902 3 """商品序""" """" """"}
                     next-prompt xxcbkd_cu_ln with frame b.
                     undo,retry.
                  end.
                  else do:
                     display
                        xxcpt_price @ xxcbkd_price
                        xxcpt_um @ xxcbkd_um
                        0 @ xxcbkd_qty_ord
                        xxcpt_ctry_code @ xxcbkd_ctry_code
                        "N 免" @ xxcbkd_tax
                     with frame b.

                     hide message no-pause.
                     message xxcpt_desc.                     
                  end.
               end.

               set xxcbkd_qty_ord
                   xxcbkd_um
                   xxcbkd_price
                   xxcbkd_ctry_code
                   xxcbkd_tax
                   xxcbkd_stat
                   go-on (F5 CTRL-D)
               with frame b editing:
                  if frame-field = "xxcbkd_ctry_code" then do:
                     {mfnp01.i xxctry_mstr xxcbkd_ctry_code xxctry_code global_domain xxctry_domain xxctry_code}

                     if recno <> ? then do:
                        display
                           xxctry_code @ xxcbkd_ctry_code
                        with frame b.
                     end.
                     
                     if input xxcbkd_ctry_code <> "" then do:
                        find first xxctry_mstr no-lock where xxctry_domain = global_domain
                               and xxctry_code = input xxcbkd_ctry_code no-error .
                        if available xxctry_mstr then do:
                           hide message no-pause.
                           message xxctry_name.
                        end.
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
                     ext_cost = xxcbkd_price * xxcbkd_qty_ord.
            
                     find first xxcbk_mstr where xxcbk_domain = global_domain and xxcbk_bk_nbr = l-key no-error .
                     if available xxcbk_mstr then xxcbk_imp_amt = xxcbk_imp_amt - ext_cost.

                     delete xxcbkd_det.
 /*
                      display xxcbk_imp_amt with frame f-1.
*/
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

               if not can-find(first xxctry_mstr no-lock where xxctry_domain = global_domain 
                  and xxctry_code = input xxcbkd_ctry_code) 
               then do:
                  {mfmsg03.i 902 3 """产地""" """" """"}
                  next-prompt xxcbkd_ctry_code with frame b.
                  undo,retry.
               end.
                  
               if not can-find(first code_mstr no-lock where code_domain = global_domain
                  and code_fldname = "pt_um" and code_value = input xxcbkd_um )
               then do:
                  {mfmsg03.i 902 3 """单位""" """" """"}
                  next-prompt xxcbkd_um with frame b.
                  undo,retry.
               end.

               if xxcbkd_qty_ord = 0 then do:
                  message "错误：数量不允许为 0, 请重新输入！".
                  next-prompt xxcbkd_qty_ord with frame b.
                  undo, retry.                                 
               end.
            end.

            xxcbkd_cu_part = input xxcbkd_cu_part.

            down 1 with frame b.

            ext_cost = 0.
            for each xxcbkd_det no-lock 
               where xxcbkd_domain = global_domain
                 and xxcbkd_bk_nbr = l-key 
                 and xxcbkd_bk_type = "imp" :
               ext_cost = ext_cost + xxcbkd_price * xxcbkd_qty_ord.
            end.
            
            find first xxcbk_mstr where xxcbk_domain = global_domain and xxcbk_bk_nbr = l-key no-error .
            if available xxcbk_mstr then xxcbk_imp_amt = ext_cost.
/*
            display xxcbk_imp_amt with frame f-1.
*/
         end.
         