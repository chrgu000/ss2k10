/* xxqmbkpm.p - Fixed Assets Control File                                   */
/* COPYRIGHT Elec & Eltek.inc.ALL RIGHTS RESERVED.THIS IS AN UNPUBLISHED WORK.*/
/* REVISION: 1.0            Last modified: 12/09/03     Created by: txie      */

         /* DISPLAY TITLE */
         {mfdtitle.i "1.0"}

         define variable desc1 like xxctry_name.

         form
            /*xxcbkc_comp      colon 16 label "经营单位"
            xxcbkc_prh_pre   colon 64 label "付运单号前辍"
            xxcbkc_name      colon 16 label "经营单位名称"
            xxcbkc_prh_seq   colon 64 label "下一个付运单号"
            xxcbkc_dept      colon 16 label "进出口岸"
            xxdept_desc      no-label
            xxcbkc_im_pre    colon 64 label "进口单号前辍"
            xxcbkc_frm_loc   colon 16 label "起抵地" format "x(5)"
            space(0) desc1   no-label
            xxcbkc_im_seq    colon 64 label "下一个进口单号"
            xxcbkc_to_loc    colon 16 label "运抵国" space(0)
            xxctry_name      no-label
            xxcbkc_ex_pre    colon 64 label "出口单号前辍"
            xxcbkc_imp       colon 16 label "装货港"
            xxcbkc_ex_seq    colon 64 label "下一个出口单号"
            xxcbkc_user1     colon 56 label "报关员1"
            xxcbkc_tel1      colon 56 label "电话"
            xxcbkc_user2     colon 56 label "报关员2"
            xxcbkc_tel2      colon 56 label "电话"
            xxcbkc_bl_nbr   colon 16 label "提货单号"
            */
            
            
            
            
            
            
            
            
            
            

            xxcbkc_comp      colon 16 label "经营单位代码"
            xxcbkc_name      colon 16 label "经营单位名称"
            xxcbkc_addr      colon 16 label "收发货单位代码"
            xxcbkc_addr_name colon 16 label "收发货单位名称"
            xxcbkc_dept      colon 16 label "进出口口岸"                     xxdept_desc      no-label
            xxcbkc_frm_loc   colon 16 label "进口起抵地" format "x(5)"     desc1   no-label
            xxcbkc_to_loc    colon 16 label "出口运抵国"                   xxctry_name      no-label
            xxcbkc_loc       colon 16 label "境内目的/货源地"              xxloc_desc       no-label  format "x(24)"
            xxcbkc_imp       colon 16 label "进口装货港"
            xxcbkc_exp       colon 16 label "出口指运港"
            
            xxcbkc_trade     colon 16 label "贸易/监管方式"               xxctra_desc1     no-label 
            xxcbkc_ship_via   colon 16 label "运输方式"                   xxcbkc_ship_tool label "运输工具名称"
            
                     
            xxcbkc_tax_mtd   colon 16 label "征免性质"                    xxctax_desc1     no-label      xxcbkc_tax_ratio label "征免比例"
            xxcbkc_fob       colon 16 label "成交方式"                    xxcbkc_box_type     label "包装种类"

            xxcbkc_rating1   colon 16  label "额度PCS" 
            xxcbkc_rating2   label "额度KG"


         with side-labels frame a width 80 attr-space.

         mainloop:
         repeat:
            find first xxcbkc_ctrl where xxcbkc_domain = global_domain no-error.
            if not available xxcbkc_ctrl
            then do:
                create xxcbkc_ctrl.
                assign xxcbkc_domain = global_domain.
            end.

            find first xxctry_mstr where xxctry_domain = global_domain 
               and xxctry_code = xxcbkc_frm_loc no-lock no-error.
            desc1 = (if available xxctry_mstr then xxctry_name else "").

            find first xxdept_mstr where xxdept_domain = global_domain 
               and xxdept_code = xxcbkc_dept no-lock no-error.

            find first xxctry_mstr where xxctry_domain = global_domain
               and xxctry_code = xxcbkc_to_loc no-lock no-error.

            find first xxloc_mstr where xxloc_domain = global_domain
               and xxloc_code = xxcbkc_loc no-lock no-error.

            find first xxctax_mstr where xxctax_domain = global_domain
               and xxctax_code = xxcbkc_tax_mtd no-lock no-error.
            find first xxctra_mstr where xxctra_domain = global_domain
               and xxctra_code = xxcbkc_trade no-lock no-error.

            display
               xxcbkc_comp      xxcbkc_name 
               xxcbkc_addr xxcbkc_addr_name
               xxcbkc_dept      xxcbkc_frm_loc
               xxcbkc_to_loc    xxcbkc_imp
               xxcbkc_exp       xxcbkc_loc
               xxcbkc_trade     
               
               xxcbkc_ship_via
               xxcbkc_ship_tool  
               xxcbkc_tax_mtd   xxcbkc_tax_ratio
               xxcbkc_fob       xxcbkc_box_type
               xxcbkc_rating1  xxcbkc_rating2
               desc1            
               xxctra_desc1    when available xxctra_mstr
               xxdept_desc      when available xxdept_mstr
               xxctry_name      when available xxctry_mstr
               xxloc_desc       when available xxloc_mstr
               xxctax_desc1     when available xxctax_mstr
            with frame a.

            do on error undo, retry with frame a:
               ststatus = stline[3].
               status input ststatus.

               set xxcbkc_comp         
                   xxcbkc_name        
                   xxcbkc_addr 
                   xxcbkc_addr_name
                   xxcbkc_dept        
                   xxcbkc_frm_loc      
                   xxcbkc_to_loc   
                   xxcbkc_loc   
                   xxcbkc_imp      
                   xxcbkc_exp            
                              
                   xxcbkc_trade       xxcbkc_ship_via  
                   xxcbkc_ship_tool     
                   xxcbkc_tax_mtd     xxcbkc_tax_ratio
                   xxcbkc_fob         xxcbkc_box_type 
                   xxcbkc_rating1  xxcbkc_rating2

               with frame a editing:
                   if frame-field = "xxcbkc_dept" then do:
                      {mfnp01.i xxdept_mstr xxcbkc_dept xxdept_code global_domain xxdept_domain xxdept_code}

                      if recno <> ? then do:
                         display
                            xxdept_code @ xxcbkc_dept
                            xxdept_desc 
                         with frame a.                         
                      end.
                   end.
                   else if frame-field = "xxcbkc_frm_loc" then do:
                      {mfnp01.i xxctry_mstr xxcbkc_frm_loc xxctry_code global_domain xxctry_domain xxctry_code}

                      if recno <> ? then do:
                         display
                            xxctry_code @ xxcbkc_frm_loc
                            xxctry_name @ desc1
                         with frame a.
                      end.
                   end.
                   else if frame-field = "xxcbkc_to_loc" then do:
                      {mfnp01.i xxctry_mstr xxcbkc_to_loc xxctry_code global_domain xxctry_domain xxctry_code}

                      if recno <> ? then do:
                         display
                            xxctry_code @ xxcbkc_to_loc
                            xxctry_name
                         with frame a.
                      end.
                   end.
                   else if frame-field = "xxcbkc_loc" then do:
                      {mfnp01.i xxloc_mstr xxcbkc_loc xxloc_code global_domain xxloc_domain xxloc_code}

                      if recno <> ? then do:
                         display
                            xxloc_code @ xxcbkc_loc
                            xxloc_desc
                         with frame a.
                      end.
                   end.
                   else if frame-field = "xxcbkc_tax_mtd" then do:
                      {mfnp01.i xxctax_mstr xxcbkc_tax_mtd xxctax_code global_domain xxctax_domain xxctax_code}

                      if recno <> ? then do:
                         display
                            xxctax_code @ xxcbkc_tax_mtd
                            xxctax_desc1
                         with frame a.
                      end.
                   end.
                   else if frame-field = "xxcbkc_trade" then do:
                      {mfnp01.i xxctra_mstr xxcbkc_trade xxctra_code global_domain xxctra_domain xxctra_code}

                      if recno <> ? then do:
                         display
                            xxctra_code @ xxcbkc_trade
                            xxctra_desc1
                         with frame a.
                      end.
                   end.
                   else do:
                     status input ststatus.
                      readkey.
                      apply lastkey.
                   end.
               end.

               if not can-find(first xxdept_mstr where xxdept_domain = global_domain
                                 and xxdept_code = xxcbkc_dept)
               then do:
                  message "错误: 海关口岸代码不存在, 请重新输入!".
                  next-prompt xxcbkc_dept with frame a.
                  undo, retry.
               end.

               if not can-find(first xxctry_mstr where xxctry_domain = global_domain
                                 and xxctry_code = xxcbkc_frm_loc)
               then do:
                  message "错误: 产终地代码不存在, 请重新输入!".
                  next-prompt xxcbkc_frm_loc with frame a.
                  undo, retry.
               end.

               if not can-find(first xxctry_mstr where xxctry_domain = global_domain
                                 and xxctry_code = xxcbkc_to_loc)
               then do:
                  message "错误: 产终地代码不存在, 请重新输入!".
                  next-prompt xxcbkc_to_loc with frame a.
                  undo, retry.
               end.

               if not can-find(first xxloc_mstr where  xxloc_domain = global_domain
                                 and xxloc_code = xxcbkc_loc)
               then do:
                  message "错误: 地区代码不存在, 请重新输入!".
                  next-prompt xxcbkc_loc with frame a.
                  undo, retry.
               end.

               if not can-find(first xxctax_mstr where xxctax_domain = global_domain
                                 and xxctax_code = xxcbkc_tax_mtd)
               then do:
                  message "错误: 征免性质代码不存在, 请重新输入!".
                  next-prompt xxcbkc_tax_mtd with frame a.
                  undo, retry.
               end.

               if not can-find(first xxctra_mstr where xxctra_domain = global_domain
                                 and xxctra_code = xxcbkc_trade)
               then do:
                  message "错误: 征免性质代码不存在, 请重新输入!".
                  next-prompt xxcbkc_trade with frame a.
                  undo, retry.
               end.
            end.
         end.
         status input.