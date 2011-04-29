/* xxqmbkmtc.p                                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* REVISION: 1.0      LAST MODIFIED: 11/10/03    Create by: txie            */

         {mfdeclre.i}
         {gplabel.i}

         define input parameter bk_nbr like xxcbkd_bk_nbr.

         define variable knt as integer.
         define variable par_ln like xxcbkd_bk_ln.
         define variable line as integer format ">>9" label "序".
         define variable new_bom like mfc_logical.
         define variable pre-page like mfc_logical.

         define buffer x1 for xxcbkd_det.


         form
            xxcbkd_bk_ln       column-label "序"
            xxcbkd_cu_ln       column-label "商品序"
            xxcbkd_cu_part     column-label "商品编号"
            xxcbkd_qty_ord     column-label "数量"
            xxcbkd_um
            xxcbkd_tax         format "Y 征/N 免" column-label "征免"            
         with 3 down frame a row 2 width 80 title color normal "出口成品".


         form
            xxcbkd_bk_nbr  column-label "手册编号"
            xxcbkd_bk_ln   column-label "序"
            xxcbkd_cu_ln   column-label "商品序"
            xxcbkd_cu_part column-label "商品编号"
            
         with frame b row 9 width 80
            title color normal "手册信息".

         form
            line
            xxcbkps_cu_ln_comp column-label "商品序"
            xxcbkps_cu_comp column-label "商品编号"
            xxcpt_ctry_code column-label "产地"
            xxcbkps_qty_per column-label "单耗"
            xxcpt_um        column-label "UM"
            xxcbkps_scrap   column-label "损耗"
         with 4 down frame c row 14 width 80
            title color normal "进口料件".

/*debug

         run add_bom_mtl(bk_nbr).
debug*/

         view frame a.
         view frame b.
         view frame c.

         mainloop:
         repeat:
            ststatus = stline[3].
            status input ststatus.

            pre-page = no.   knt = 0.
            find first xxcbkd_det where xxcbkd_domain = global_domain
                   and xxcbkd_bk_nbr = bk_nbr
                   and xxcbkd_bk_type = "out" no-lock no-error.

            repeat:
               if available xxcbkd_det then do:
                  find first xxcpt_mstr where xxcpt_domain = global_domain
                         and xxcpt_ln = xxcbkd_cu_ln no-lock no-error.

                  knt = knt + 1.

                  display
                     xxcbkd_bk_ln
                     xxcbkd_cu_ln
                     xxcbkd_cu_part
                     
                     xxcbkd_qty_ord
                     xxcbkd_um
                     xxcbkd_tax
                  with frame a.
                  down with frame a.
                  if avail xxcpt_mstr then message "品名: " xxcpt_desc .

                  for each xxcbkps_mstr no-lock
                     where xxcbkps_domain = global_domain
                       and xxcbkps_bk_nbr = bk_nbr
                       and xxcbkps_ln_par = xxcbkd_bk_ln:
                     
                     find first xxcpt_mstr where xxcpt_domain = global_domain
                         and xxcpt_ln = xxcbkd_cu_ln no-lock no-error.

                                        display
                                        xxcbkps_ln_comp @ line 
                                        xxcbkps_cu_comp
                                        xxcbkps_cu_ln_comp
                                        xxcpt_ctry_code when available xxcpt_mstr
                                        xxcbkps_scrap
                                        xxcpt_um 
                                        xxcbkps_qty_per
                     with down frame c.
                     
                  end.
               end.
               if knt > 2 then leave.

               find next xxcbkd_det where xxcbkd_domain = global_domain
                  and xxcbkd_bk_nbr = bk_nbr
                  and xxcbkd_bk_type = "out" no-lock no-error.

               if not available xxcbkd_det then leave.
            end.

            up knt with frame a.

            repeat:
               clear frame b all no-pause.
               clear frame c all no-pause.

               choose row xxcbkd_bk_ln no-error with frame a.

               if lastkey = keycode("CURSOR-UP") then do:
                  pre-page = yes.
                  leave.
               end.

               if lastkey <> keycode("CURSOR-UP") and
                  keyfunction (lastkey) <> "CURSOR-DOWN" and
                  lastkey <> keycode("RETURN") and
                  lastkey <> keycode("PAGE-UP") and
                  keyfunction (lastkey) <> "PAGE-DOWN" and
                  keyfunction (lastkey) <> "GO"
               then next.

               if (lastkey = keycode("CURSOR-UP") or
                   lastkey = keycode("PAGE-UP")) and frame-line = 0
               then next.

               if keyfunction (lastkey) = "CURSOR-DOWN" or
                  keyfunction (lastkey) = "PAGE-DOWN"
               then do:
                  if available xxcbkd_det then do:
                     knt = 0.
                     clear frame a all no-pause.

                     repeat:
                        if available xxcbkd_det then do:
                           find first xxcpt_mstr where xxcpt_domain = global_domain
                                  and xxcpt_ln = xxcbkd_cu_ln no-lock no-error.

                           knt = knt + 1.

                           display
                              xxcbkd_bk_ln
                              xxcbkd_cu_ln
                              xxcbkd_cu_part
                              xxcbkd_qty_ord
                              xxcbkd_um
                              xxcbkd_tax
                           with frame a.
                           down with frame a.
                           if avail xxcpt_mstr then message "品名: "  xxcpt_desc .

                           for each xxcbkps_mstr no-lock
                              where xxcbkps_domain = global_domain
                                and xxcbkps_bk_nbr = bk_nbr
                                and xxcbkps_ln_par = xxcbkd_bk_ln:
                     
                              find first xxcpt_mstr where xxcpt_domain = global_domain
                                     and xxcpt_ln = xxcbkd_cu_ln no-lock no-error.

                              display
                                 xxcbkps_ln_comp @ line 
                                 xxcbkps_cu_comp
                                 xxcbkps_cu_ln_comp
                                 xxcpt_ctry_code when available xxcpt_mstr
                                 xxcbkps_scrap
                                 xxcpt_um 
                                 xxcbkps_qty_per
                              with down frame c.
                              
                           end.
                        end.
                        if knt > 2 then leave.

                        find next xxcbkd_det where xxcbkd_domain = global_domain
                            and xxcbkd_bk_nbr = bk_nbr
                            and xxcbkd_bk_type = "out" no-lock no-error.
                        if not available xxcbkd then leave.
                     end.
                     up knt with frame a.
                  end.
                  next.
               end.

               if frame-value = "" then next.
               else do with frame b:
                  find first xxcbkd_det
                     where xxcbkd_domain = global_domain
                       and xxcbkd_bk_ln = integer(frame-value)
                       and xxcbkd_bk_nbr = bk_nbr
                       and xxcbkd_bk_type = "out" no-lock.
       
                  find first xxcpt_mstr where xxcpt_domain = global_domain
                         and xxcpt_ln = xxcbkd_cu_ln no-lock no-error.
                  
                  display
                     xxcbkd_bk_nbr  column-label "手册编号"
                     xxcbkd_bk_ln   column-label "序"
                     xxcbkd_cu_ln   column-label "商品序"
                     xxcbkd_cu_part column-label "商品编号"
                     
                  with frame b row 9 width 80 title color normal "手册信息".
                  if avail xxcpt_mstr then message "品名: "  xxcpt_desc .
               end.

               find first xxcbkps_mstr where xxcbkps_domain = global_domain
                  and xxcbkps_bk_nbr = bk_nbr
                  and xxcbkps_ln_par = xxcbkd_bk_ln
                  use-index xxcbkps_bk_nbr no-lock no-error.
               
               if available xxcbkps_mstr then
                  assign line = xxcbkps_ln_comp  new_bom = no.
               par_ln = xxcbkd_bk_ln.

               subloop:
               repeat on endkey undo, leave:
                  if line < 999 and new_bom then line = xxcbkps_ln_comp + 1.
                  else if line = 999 then do:
                     {mfmsg.i 7418 2}
                  end.

                  new_bom = yes.
                  display line with frame c.

                  /* FIND NEXT/PREVIOUS RECORD */
                  set line
                  with 4 down frame c row 14 width 80
                  title color normal "进口料件"
                  editing:
                     {mfnp07.i xxcbkps_mstr line xxcbkps_ln_comp
                           bk_nbr xxcbkps_bk_nbr par_ln xxcbkps_ln_par
                           global_domain xxcbkps_domain xxcbkps_bk_nbr}

                     if recno <> ? then do:
                        find first x1 where x1.xxcbkd_domain = global_domain
                             and x1.xxcbkd_bk_nbr = bk_nbr
                             and x1.xxcbkd_bk_ln = xxcbkps_ln_comp
                             and x1.xxcbkd_bk_type = "imp" no-lock no-error.

                        find first xxcpt_mstr where xxcpt_domain = global_domain
                               and xxcpt_ln = xxcbkd_cu_ln no-lock no-error.                  

                        display
                           xxcbkps_ln_comp @ line
                           xxcbkps_cu_comp label  "商品编号"
                           xxcbkps_cu_ln_comp
                           x1.xxcbkd_ctry_code when available x1 @ xxcpt_ctry_code 
                           xxcbkps_qty_per  label "单耗"
                                                   xxcpt_um
                           xxcbkps_scrap    label "损耗"
                        with frame c.
                        if avail xxcpt_mstr then message "品名: "  xxcpt_desc .
                     end.
                  end.

                  assign line.

                  find first xxcbkps_mstr where xxcbkps_domain = global_domain 
                       and xxcbkps_bk_nbr = bk_nbr
                       and xxcbkps_ln_par = par_ln
                       and xxcbkps_ln_comp = input line
                       exclusive-lock no-error .

                  if not available xxcbkps_mstr then do:
                     {mfmsg03.i 902 3 """序""" """" """"}
                     if c-application-mode = 'web':u then return.
                     else next-prompt line.
                     undo, retry.
                  end.
                  else do:
                     find first x1 where x1.xxcbkd_domain = global_domain
                            and x1.xxcbkd_bk_nbr = bk_nbr
                            and x1.xxcbkd_bk_ln = xxcbkps_ln_comp
                            and x1.xxcbkd_bk_type = "imp" no-lock no-error .


                     find first xxcpt_mstr where xxcpt_domain = global_domain
                            and xxcpt_ln = xxcbkd_cu_ln no-lock no-error.                  

                     display
                        xxcbkps_ln_comp @ line
                        xxcbkps_cu_comp
                        xxcbkps_cu_ln_comp
                        x1.xxcbkd_ctry_code when available x1 @ xxcpt_ctry_code
                        xxcbkps_qty_per
                                                xxcpt_um
                        xxcbkps_scrap
                     with frame c.
                  end.

                  set xxcbkps_qty_per
                      xxcbkps_scrap
                  with frame c.
                  down with frame c.
               end.

               if pre-page = yes then next mainloop.
            end.
            if keyfunction(lastkey) = "end-error" then leave .
         end.
         hide frame a.
         hide frame b.
         hide frame c.

         procedure add_bom_mtl:
            define input parameter bk_nbr like xxcbkps_bk_nbr.
/*debug
                        for each xxcbkd_det no-lock
                                        where xxcbkd_det.xxcbkd_domain = global_domain
                                        and xxcbkd_det.xxcbkd_bk_nbr = bk_nbr
                                        and xxcbkd_det.xxcbkd_bk_type = "imp",
                                each x1 no-lock
                                        where x1.xxcbkd_domain = global_domain
                                        and x1.xxcbkd_bk_nbr = xxcbkd_det.xxcbkd_bk_nbr
                                        and x1.xxcbkd_bk_type = "out":

                                find first xxcbkps_mstr
                                        where xxcbkps_bk_nbr  = bk_nbr
                                        and xxcbkps_ln_par  = xxcbkd_det.xxcbkd_bk_ln
                                        and xxcbkps_ln_comp = x1.xxcbkd_bk_ln
                                no-lock no-error.

                                if not available xxcbkps_mstr then do:
                                        create xxcbkps_mstr.
                                        assign xxcbkps_bk_nbr   = bk_nbr
                                                xxcbkps_par      = xxcbkd_det.xxcbkd_cu_part
                                                xxcbkps_par_sub  = xxcbkd_det.xxcbkd_cu_sub
                                                xxcbkps_ln_par   = xxcbkd_det.xxcbkd_bk_ln
                                                xxcbkps_comp     = x1.xxcbkd_cu_part
                                                xxcbkps_comp_sub = x1.xxcbkd_cu_sub
                                                xxcbkps_ln_comp  = x1.xxcbkd_bk_ln.
                                end.
                        end.

            for each xxcbkd_det no-lock
               where xxcbkd_det.xxcbkd_domain = global_domain
                 and xxcbkd_det.xxcbkd_bk_nbr = bk_nbr
                 and xxcbkd_det.xxcbkd_bk_type = "out"
              , each xxcps_mstr no-lock
               where xxcps_domain = global_domain
                 and xxcps_cu_par = xxcbkd_det.xxcbkd_cu_part
            break by xxcps_cu_par by xxcps_cu_comp:
               if last-of(xxcps_cu_comp) then do: 
                  create xxcbkps_mstr
                  assign
                     xxcbkps_domain = global_domain
                     xxcbkps_bk_nbr = 
                     xxcbkps_cu_par
                     xxcbkps_cu_comp
                     xxcbkps_cu_ln_par
                     xxcbkps_cu_ln_comp
                     xxcbkps_ln_par
                     xxcbkps_ln_comp
                     xxcbkps_qty_per
                     xxcbkps_scrap
               end.
            end.
debug*/            
         end.
