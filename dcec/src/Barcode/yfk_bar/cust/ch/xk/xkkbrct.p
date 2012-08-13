/* xkkbrct.p                  扫描看板要货单号收货                           */
/* Copy from YFV-xkkbrct.p    by hou   2005.12.23                            */
/*change xwosd_qty Modify by xwh on 2006.1.17 */

         {mfdtitle.i "xw+ "}
         {kbconst.i}
         {gplabel.i}
         {xxcimload.i NEW}
         
         &SCOPED-DEFINE popomtf_p_2 "采购单" 
         
         define variable yn          as   logical .
         define variable po          as   logical .
         define variable kb          as   logical .
         define variable kanbanid    as   character .
         define variable kanbanid1   as   character .
         define variable des         as   character .
         define variable xwkblist    as   character.
         define variable sloc        as   char format "x(8)".
         define variable ssite       as   char format "x(8)".
         define variable dloc        as   char format "x(8)".
         define variable dsite       as   char format "x(8)".
         define variable cimf        as   character .
         define variable tr          like tr_trnbr .
         define variable kbtr        like kbtr_trans_nbr .
         define variable tempkbid    like knbd_id .
         define variable sta1        like ld_status .
         define variable sta2        like ld_status .
         DEFINE VARIABLE err AS INTEGER .
         DEFINE VARIABLE introk AS LOGICAL INITIAL YES.
         define variable v_sum       as   decimal label "总量".
         define variable v_part_list as   char.
         define variable   v_tip     as    char.

         define new shared variable pnbr     like po_nbr .
         define new shared variable effdate  as date .
         define new shared variable rctnbr   as character .
         define new shared variable po_recno as recid .
         define new shared variable pod_recno as recid .
         define new shared variable qty_ord  as decimal .
         define new shared variable del-yn   as logical.
         define new shared variable traceyes as logical .
         define new shared variable xPrtRn   as logic initial YES label "打印收货单".
         define new shared variable xPrtKb   as logic initial NO label "打印看板".
         
         define new shared temp-table rctkb
             field seq11 as   integer format "9999"
             field kbid  like knbd_id
             field part  like pt_part
             field qty   as   decimal label "收货数量" 
             field rct   as   logical initial yes
             index kbid seq11 part kbid .
             
         define new shared temp-table xkprhhist
             field xkprhnbr      as char format "x(8)"
             field xkprhponbr    as char format "x(8)"
             field xkprhline     as integer format ">,>>>,>>9"
             field xkprhpart     as char format "x(18)"
             field xkprhrctdate  as date format "99/99/99"
             field xkprheffdate  as date format "99/99/99"
             field xkprhqty      as decimal format ">>,>>9.99"
             field xkprhvend     as char format "x(8)"
             field xkprhdsite    as char format "x(8)"
             field xkprhdloc     as char format "x(18)"
             field xkprhssite    as char format "x(18)"
             field xkprhssloc    as char format "x(18)"       
             field xkprhinrcvd   as logical 
             field xkprhregion   as char format "x(8)"
             field xkprhkbid     as char format "x(20)"
             index  xkprhinrcvd xkprhinrcvd xkprhponbr xkprheffdate.

         /*H01* *work-table xkrodet define move from xkiclotr02.p */
      	define new shared work-table xkrodet
      		field xkrodnbr like xkrod_det.xkrod_nbr
      		field xkrodline like xkrod_line
      		field xkrodpart like pt_part
      		field xkrodqtyord as decimal format "->,>>>,>>9.9<<<<<<<<" label "订量"
      		field xkrodqtyopen as decimal format "->,>>>,>>9.9<<<<<<<<" label "待转移量"
       		field xkrodqtyrcvd as decimal format "->,>>>,>>9.9<<<<<<<<" label "已转移量".
         
         define buffer fetchKnbd     for knbd_det .
         define buffer processKnbd   for knbd_det .
         define buffer fetchXkro     for xkro_mstr .
         define buffer processXkro   for xkro_mstr .
         define buffer fetchXkrod    for xkrod_det .
         define buffer processXkrod  for xkrod_det .
         
/*est*/     DEFINE NEW SHARED TEMP-TABLE co_list
/*est*/             FIELD co_part LIKE pt_part
/*est*/             FIELD co_qty_req AS DECIMAL
/*est*/             FIELD co_qty_iss AS DECIMAL
/*est*/             FIELD co_qty_bo AS DECIMAL
/*est*/             FIELD co_site LIKE pt_site
/*est*/             FIELD co_loc LIKE loc_loc.
/*est*/          DEFINE NEW SHARED TEMP-TABLE cot_tmp
/*est*/            FIELD cot_code LIKE b_co_code
/*est*/            FIELD cot_part LIKE b_co_part
                       FIELD cot_lot LIKE b_co_lot.
/*est*/    {bcdeclre.i "new"}
                {bcini.i}

/*est         FORM 
         
             SKIP(0.3)
             effDate     colon 26 label "有效日"
             pnbr        colon 26 label "订单号"
             xPrtRn	 colon 26 
             xPrtKb	 colon 26 
             SKIP(0.3)
         with frame a SIDE-labelS width 80 THREE-D .
*/
/*est*/  FORM 
         
             SKIP(0.3)
             effDate     colon 8 /*16*/ label "有效日"
             pnbr        colon  8 /*16*/ label "订单号"
             xPrtRn	 colon  8 /*16*/ 
             xPrtKb	 colon  8 /*16*/ 
             SKIP(0.3)
         with frame a SIDE-labelS width 80 THREE-D .


         FORM
/*est*/             part    label "零件号"    FORMAT "x(18)"
/*est*/             qty     label "收货数量"
/*est*/             rct     label "收货"
             seq11   label "序列"
             kbid    label "看板号"
/*est*/    /*         part    label "零件号"    FORMAT "x(18)"
/*est*/             qty     label "收货数量"
/*est*/             rct     label "收货"*/
         with centered overlay 18 DOWN frame f-errs width 80 THREE-D .
         
         FORM 
             SKIP(2)
             xkro_nbr    COLON 20    xkro_supplier COLON 50
             xkro_user   COLON 20    xkro_ord_date COLON 50
             xkro_site   COLON 20    xkro_loc      COLON 50
             xkro_dsite  COLON 20    xkro_dloc     COLON 50
             xkro_urgent COLON 20    xkro_status   COLON 50
             SKIP(1)
         
         WITH FRAME bb WIDTH 80 SIDE-labelS ATTR-SPACE .
         
/*est*/    {bcwin.i}

         
         mainloop:
         
         repeat 
         on error undo, leave 
         on endkey undo, leave:
         
           do transaction:
             
             hide all no-pause .
             view frame dtitle.
             view frame a .
             find last tr_hist no-lock no-error .
             if available tr_hist then tr = tr_trnbr .
             else tr = 0 .
             
             find last kbtr_hist no-lock no-error .
             if available kbtr_hist then kbtr = kbtr_trans_nbr .
             else kbtr = 0 .
             
             for each rctkb :
               delete rctkb .
             end.
             
             pnbr = "" .
             effdate = today .
             display effdate with frame a .
             
             update  pnbr effdate xprtrn xprtkb   
             with frame a. 
             
             if traceyes then do :
                output to trace.prn append .
                put unformatted pnbr " " global_userid  " " string(today) " " string(time,"hh:mm:ss") " 启动 "  skip .
                output close .
             end.
         
             if pnbr = "" then do:
                message "请输入要货单号。" .
                undo mainloop , retry mainloop.
             end.
         
             {gpchkqsi.i &fld=effdate     &frame-name=effdate} 
             
             find po_mstr no-lock 
             where po_nbr = pnbr and po_stat <> "c" and po_stat <> "x" no-error .
             
             if available po_mstr then do:
                po = yes .
                find first knbd_det no-lock 
                where knbd_user1 = pnbr and knbd_active no-error .
                if not available knbd_det then do:
                   kb = no .
                   for each rctkb:
                      delete rctkb.
                   end.

                   for each pod_det no-lock where pod_nbr = pnbr:
                      create rctkb.
                      assign
                         kbid = pod_line
                         part = pod_part
                         qty = pod_qty_rcvd.
                   end.
                   hide all no-pause.	

                   {gprun.i ""xkpoporc.p"" "(pnbr,effdate)"} 
         
                   hide all no-pause.	
         
                   for each pod_det no-lock where pod_nbr = pnbr:
                      find rctkb where kbid = pod_line.
                      qty = pod_qty_rcvd - qty.
                   end.

                end.
                else do: /*available knbd_det */
                   kb = yes .
                   for each knbd_det no-lock 
                      where knbd_user1 = pnbr and knbd_active :
                      
                      create rctkb .
                      
                      find knbl_det where knbl_keyid = knbd_knbl_keyid no-lock.
                      find knb_mstr where knb_keyid = knbl_knb_keyid no-lock.
                      find knbi_mstr where knbi_keyid = knb_knbi_keyid no-lock .
                      find knbsm_mstr where knbsm_keyid = knb_knbsm_keyid no-lock .
                      find first xkgpd_det where xkgpd_site = knbsm_site 
                      and knbsm_supermarket_id = xkgpd_sup and xkgpd_part = knbi_part 
                      no-lock no-error .
                      
                      assign kbid  = knbd_id 
                             part  = knbi_part
                             qty   = knbd_kanban_quantity 
                             seq11 = if available xkgpd_det then xkgpd_line else 0 .
                   end.
         
                end. /*available knbd_det */
                   
             end. /*available po_mstr*/
             else do:       
                find xkro_mstr where xkro_nbr = pnbr and xkro_status <> "c" 
                and xkro_status <> "x" no-lock no-error .
                if not available xkro_mstr then do:
                   message "错误:找不到相应订单,或已关闭:" + pnbr .
                   pause 10.
                   undo mainloop , retry mainloop .
                end.
                else do: /*available xkro_mstr*/           
                   po = no .
                   find first knbd_det where knbd_user1 = pnbr and knbd_active no-lock no-error .
                   if not available knbd_det then do:
                      kb = no .
                      {gprun.i ""xkiclotr02.p"" "(pnbr,effdate)"} 
                      
                      if xkro_type = "J" then do:
                         for each xkrodet where xkrodnbr = xkro_nbr:
                            create xwosd_det.
                            ASSIGN xwosd_lnr = xkro_loc
                                   xwosd_date = today
                                   xwosd_fg_lot = ""
                                   xwosd_site = xkro_site
                                   xwosd_loc = xkro_loc
                                   xwosd_part = xkrodpart
                                   xwosd_qty  =  xkrodqtyopen
                                   xwosd_bkflh = yes
                                   xwosd_used = yes
                                   xwosd_use_dt = today
                                   xwosd_use_tm = time.
                         end.
                      end.
                   end.
                   else do:
                      kb = yes .
                      for each knbd_det where knbd_user1 = pnbr and knbd_active no-lock :
                         create rctkb .
                         find knbl_det where knbl_keyid = knbd_knbl_keyid no-lock.
                         find knb_mstr where knb_keyid = knbl_knb_keyid no-lock.
                         find knbi_mstr where knbi_keyid = knb_knbi_keyid no-lock .
                         find knbsm_mstr where knbsm_keyid = knb_knbsm_keyid no-lock .
                         find first xkgpd_det where xkgpd_site = knbsm_site 
                         and knbsm_supermarket_id = xkgpd_sup and xkgpd_part = knbi_part 
                         no-lock no-error .
                         assign 
                             kbid  = knbd_id 
                             part  = knbi_part
                             qty   = knbd_kanban_quantity 
                             seq11 = if available xkgpd_det then xkgpd_line else 0 .
                      end. /*for each knbd_det*/
                   end. /*not available knbd_det*/
                end. /* available xkro_mstr */
             end. /* not avail po_mstr */
         
             if traceyes then do :
                output to trace.prn append .
                put unformatted pnbr " " global_userid  " " string(today) " " string(time,"hh:mm:ss") " 看板选择开始 "  skip .
                output close .
             end.
             
             if kb then do:
                
                for each rctkb break by part:
                   accumulate qty (sub-total by part) .
                   if last-of(part) then do:
                      disp part label "零件号" 
                           accum sub-total by part qty label "数量"
                      with frame ft down.
                   end.
                end.
                pause.
                hide frame ft no-pause.
                
                for each rctkb :
                   display
                           part      label "零件号" 
                           qty       label "收货数量" 
                           seq11     label "序列" 
                           kbid      label "看板号" 
/*est*//*            part      label "零件号" 
                           qty       label "收货数量" 
         */               rct       label "确认收货" 
                   with frame d down .
                end.
                yn = yes .
                message "确认收入这些看板? " 
                view-as alert-box question button yes-no-cancel
                update yn.
                      
                if yn = ? then undo mainloop, retry mainloop.
                
                if not yn then do :
                   v_tip = "[回车]-更改 [方向键]-上/下 [F4]-退出".
                   
                   mainblock:
                   do on error undo,leave on endkey undo mainloop, retry mainloop:
                      clear frame f-errs all.
                      hide frame d .
                      hide frame e .
                   
                      { xkut001.i
                      &file = "rctkb"
                      &frame = "f-errs"
                      &fieldlist = "seq11
                                    kbid
                                    part
                                    qty
                                    rct
                                  "
                      &prompt     = "seq11"
                      &pgupkey    = "ctrl-u"
                      &pgdnkey    = "ctrl-d"
                      &midchoose  = "color mesages"
                      &prechoose  = "~hide message no-pause. message v_tip.~ "
                      &updkey     = "ENTER,RETURN"
                      &updcode    = "~{xkkbrctb.i~}"
                   
                      }              
                   
                      hide frame f-errs no-pause .
                      for each rctkb where rct :
                         display 
                                 part    label "零件号" 
                                 qty     label "收货数量" 
                                 seq11   label "序列" 
                                 kbid    label "看板号" 
/*est*//*                  part    label "零件号" 
                                 qty     label "收货数量" 
           */                   rct     label "确认收货" 
                         with frame e DOWN .
                      end.
                   
                      yn = yes .
                      message "确认收入这些看板? " 
                      view-as alert-box question button yes-no-cancel
                      update yn.
                      
                      if yn = ? then undo mainloop, retry mainloop.
                      if not yn then undo mainblock, retry mainblock .
                      
                   end.        
                   hide message no-pause.

                end. /* not yn */         

                v_part_list = "".
                for each rctkb where rct break by part :
                   
                   accumulate qty (sub-total by part) .    

                   if last-of(part) then do:               
                      assign ssite = ""  
                             dsite = ""
                             sloc = ""   
                             dloc = "".
                      find first knbd_det where knbd_id = kbid no-lock no-error.
                      if available knbd_det then do:
                         ssite = knbd_ref1.
                         find first knbsm_mstr where knbsm_supermarket_id = knbd_ref2 no-lock no-error.
                         if available knbsm_mstr then 
                            sloc = knbsm_inv_loc.                                                                
                         find first knbl_det where knbl_keyid = knbd_knbl_keyid no-lock no-error.
                         if available knbl_det then do:
                            find first knb_mstr where knb_keyid = knbl_knb_keyid no-lock no-error.
                            if available knb_mstr then do:
                               find first knbsm_mstr where knbsm_keyid = knb_knbsm_keyid no-lock no-error.
                               if available knbsm_mstr then 
                                  assign dloc = knbsm_inv_loc
                                         dsite = knbsm_site.
                            end.
                         end.
                      end.

                      if kb then do:
                        find first loc_mstr where loc_site = ssite and loc_loc = sloc no-lock no-error.
                        find first is_mstr where is_status = loc_status no-lock no-error.
                        if not is_overissue then do:
                           find first ld_det where ld_site = ssite and ld_loc = sloc and ld_part = part
                           no-lock no-error.
                           if not avail ld_det or (ld_qty_oh - accum sub-total by part qty) < 0 then do:
                              message "库存量:" + string(if avail ld_det then ld_qty_oh else 0) 
                                      + "需求量:" + string(accum sub-total by part qty) skip
                                      "地点" + ssite + "库位" + sloc + "零件号" + part skip
                                      "忽略此零件继续吗?"
                              view-as alert-box question buttons yes-no
                              title "错误:库存不足" 
                              update yn.
                              if yn then v_part_list = v_part_list + part + "," .
                              else undo mainloop, retry mainloop.
                           end.
                        end. 
                      end.
                   end.
                end.
             
                if v_part_list <> "" then do:
                   v_part_list = substr(v_part_list,1,length(v_part_list) - 1).
                   for each rctkb where lookup(part,v_part_list) <> 0 :
                      rct = no.
                   end.
                   message "下列零件将不进行收货:" skip
                           v_part_list skip
                   view-as alert-box warning.
                end.
                
                if yn = yes then do : 
                   if traceyes then do :
                      output to trace.prn append .
                      put unformatted pnbr " " global_userid  " " string(today) " " string(TIME,"hh:mm:ss") " 看板选择结束，进入看板填充 " SKIP .
                      output close .
                   end.
         
                   do on error undo, retry :
                      {gprun.i ""xkkbfill.p""}
         
                      for each rctkb where rct :
                         find first kbtr_hist where kbtr_trans_nbr > kbtr and kbtr_id = kbid 
                         and kbtr_transaction_event = {&kb-cardevent-fill}  no-lock no-error .	
                         if not available kbtr_hist then rct = no .
                      end.
                      
                      pause 0 .
                   end. /* do on error undo, retry */
                end. /*yn = yes */
             end. /*end for if kb then */
             
             if traceyes then do :
                output to trace.prn append .
                put unformatted pnbr " " global_userid  " " string(today) " " string(time,"hh:mm:ss") " 看板填充结束，开始建立xkprh,更新xkrod，填写knbd_user1 "  SKIP .
                output close .
             end.
         
             repeat:    
                find first code_mstr where code_fldname = "recnbr" exclusive-lock no-error .
                if not available code_mstr then do:
                   create code_mstr .
                   assign code_fldname = "recnbr"
                   code_value = "r"
                   code_cmmt = "1" .
                end.
                rctnbr = trim(code_value) + string(integer(code_cmmt),"9999999").
                find first xkprh_hist where xkprh_nbr = rctnbr no-lock no-error.
                if not available xkprh_hist then do:
         	  release code_mstr.
          	  leave.
                end.
                else do:
                   code_cmmt = string(integer(code_cmmt) + 1).
                   release code_mstr.
                end.
             end. /* repeat */
             
             if not po then do:
                find xkro_mstr where xkro_nbr = pnbr 
                no-lock no-error.

                for each rctkb where rct break by part :
                   if first-of(part) then xwkblist = "" .
                   else xwkblist = xwkblist + ",".
                   
                   xwkblist = xwkblist + string(kbid).
                   
                   if kb then do:
                      find first knbd_det where knbd_id = kbid 
                      exclusive-lock no-error. 
                      if available knbd_det then do:
                         knbd_user1 = "" .
                         release knbd_det .
                      end .
                   end.
                   
                   accumulate qty (sub-total by part) .    

                   if last-of(part) then do:               
                      assign ssite = ""  
                             dsite = ""
                             sloc = ""   
                             dloc = "".
                      find first knbd_det where knbd_id = kbid no-lock no-error.
                      if available knbd_det then do:
                         ssite = knbd_ref1.
                         find first knbsm_mstr where knbsm_supermarket_id = knbd_ref2 no-lock no-error.
                         if available knbsm_mstr then 
                            sloc = knbsm_inv_loc.                                                                
                         find first knbl_det where knbl_keyid = knbd_knbl_keyid no-lock no-error.
                         if available knbl_det then do:
                            find first knb_mstr where knb_keyid = knbl_knb_keyid no-lock no-error.
                            if available knb_mstr then do:
                               find first knbsm_mstr where knbsm_keyid = knb_knbsm_keyid no-lock no-error.
                               if available knbsm_mstr then 
                                  assign dloc = knbsm_inv_loc
                                         dsite = knbsm_site.
                            end.
                         end.
                      end.
                      
                      if kb then do:
                         create xwosd_det.
                         ASSIGN xwosd_lnr = sloc
                                xwosd_date = today
                                xwosd_fg_lot = ""
                                xwosd_site = ssite
                                xwosd_loc = sloc
                                xwosd_part = part
/* xwh0117                               xwosd_qty  = - (accum sub-total by part qty)   */
                                xwosd_qty  =  accum sub-total by part qty
                                xwosd_bkflh = yes
                                xwosd_used = yes
                                xwosd_use_dt = today
                                xwosd_use_tm = time.
                      end.

                      find first xkrod_det where xkrod_part = part and xkrod_nbr = pnbr
                      exclusive-lock no-error.
                      if available xkrod_det then do:
                         xkrod_rct_date = today .
                         xkrod_rcd_time = TIME.
                         xkrod_qty_rcvd = xkrod_qty_rcvd + (accum sub-total by part qty) .
                         if xkrod_qty_ord <= xkrod_qty_rcvd then xkrod_status = "c" .
         
                         create xkprh_hist .
                         assign xkprh_nbr = rctnbr 
                                xkprh_po_nbr = pnbr 
                                xkprh_line = xkrod_line 
                                xkprh_part = xkrod_part 
                                xkprh_rct_date = today 
                                xkprh_eff_date = effdate 
                                xkprh_eff_time = time
                                xkprh_qty = (accum sub-total by part qty)
                                xkprh_vend = xkro_supplier 
                                xkprh_dsite = dsite 
                                xkprh_dloc = dloc .
                                
                         create xkprhhist .
                         assign xkprhnbr = rctnbr 
                                xkprhponbr = pnbr 
                                xkprhline = xkrod_line 
                                xkprhpart = xkrod_part 
                                xkprhrctdate = today 
                                xkprheffdate = effdate 
                                xkprhqty = (accum sub-total by part qty)
                                xkprhvend = xkro_supplier 
                                xkprhdsite = dsite 
                                xkprhdloc = dloc 
                                xkprhssite = ssite
                                xkprhssloc = sloc .
                                xkprhinrcvd = if kb then no else yes .
                                
                         if kb then assign xkprhkbid = xwkblist
                                           xkprh_kbid = xwkblist.
                         release xkprh_hist.
         
                      end. /* available xkrod_det*/
                   end. /*last-of(part)*/
                end. /*for each xkro_mstr*/
             end. /*not po*/
             else do:
                find po_mstr where po_nbr = pnbr
                no-lock no-error.

                for each rctkb where rct break by part: 
  
                   if first-of(part) then xwkblist = "".
                   else xwkblist = xwkblist + ",".
                   
                   xwkblist = xwkblist + string(kbid).
                   if kb then do:
                      find knbd_det where knbd_id = kbid exclusive-lock no-error.
                      if available knbd_det then do:
                         knbd_user1 = "" .
                         release knbd_det .
                      end .
                   end.
                   accumulate qty (sub-total by part) .       
                   if last-of(part) then do:                  
     
                      find first xkrod_det where xkrod_part = part and xkrod_nbr = pnbr 
                      exclusive-lock no-error.
                      if available xkrod_det then do:
                         xkrod_rct_date = today .
                         xkrod_rcd_time = TIME.
                         xkrod_qty_rcvd = xkrod_qty_rcvd + (accum sub-total by part qty).
                         if xkrod_qty_ord <= xkrod_qty_rcvd then xkrod_status = "c" .
                      end.
                      
                      find first pod_det where pod_part = part and pod_nbr = pnbr
                      no-lock no-error.
                      create xkprh_hist .
                      assign xkprh_nbr = rctnbr 
                             xkprh_po_nbr = pnbr 
                             xkprh_line = if available pod_det then pod_line else 0
                             xkprh_part = if available pod_det then pod_part else ""
                             xkprh_rct_date = today 
                             xkprh_eff_date = effdate
                             xkprh_eff_time = time 
                             xkprh_qty = (accum sub-total by part qty) 
                             xkprh_vend = if available po_mstr then po_vend else ""
                             xkprh_dsite = if available pod_det then pod_site else ""
                             xkprh_dloc = if available pod_det then pod_loc else "" .
                      
                      create xkprhhist .
                      assign xkprhnbr = rctnbr 
                             xkprhponbr = pnbr 
                             xkprhline = if available pod_det then pod_line else 0
                             xkprhpart = if available pod_det then pod_part else ""
                             xkprhrctdate = today 
                             xkprheffdate = effdate 
                             xkprhqty = (accum sub-total by part qty)
                             xkprhvend = if available po_mstr then po_vend else ""
                             xkprhdsite = if available pod_det then pod_site else ""
                             xkprhdloc = if available pod_det then pod_loc else "" .
                             xkprhinrcvd = if kb then no else yes.
                      
                      if kb then assign xkprhkbid = xwkblist
                                       xkprh_kbid = xwkblist.
                   end. /* last-of(part) */
                end. /* for each rctkb */
             end. /* else do */
             
             if traceyes then do :
                output to trace.prn append .
                put unformatted pnbr " " global_userid " " string(today) " " string(time,"hh:mm:ss") "开始关闭订单 "  skip .
                output close .
             end.
         
             find first xkprh_hist where xkprh_nbr = rctnbr no-lock no-error .
             if available xkprh_hist then do:
                find first code_mstr where code_fldname = "recnbr" exclusive-lock no-error .
                if available code_mstr then code_cmmt = string(integer(code_cmmt) + 1) .
                release code_mstr.
             end. /*available xkprh_hist*/
         
             if traceyes then do :
                output to trace.prn append .
                put unformatted pnbr " " global_userid  " " string(today) " " string(time,"hh:mm:ss") "开始打印 "  skip .
                output close .
             end.

/*est*/  DEFINE VARIABLE sucess AS LOGICAL INITIAL FALSE.
/*est*/  IF po THEN DO:
                     STATUS INPUT "外部要货单" .
/*est*/          {gprun.i ""kbrct01.p"" "(input ""EXTERNAL"", output sucess)"}
                     IF NOT sucess THEN
                       UNDO mainloop, RETRY mainloop.
             END.
             ELSE DO:
                      STATUS INPUT "内部要货单" .
/*est*/           {gprun.i ""kbrct01.p"" "(input ""INTERNAL"", output sucess)"}     
                      IF NOT sucess THEN
                        UNDO mainloop, RETRY mainloop.
/*est*/  END.
         
             if kb then do :
                cimf = "tttttt.cim" .
/*est*/                {xkictran.i}
             end . /*if kb*/

             {xkbcls.i}
         
           end. /*do transaction*/
         
           if xprtrn or xprtkb then do:
              {mfselbpr.i "printer" 132}
              {gprun.i ""xkrnprt.p"" "(input rctnbr)"} 
              {mfreset.i}
           end . 

             if traceyes then do :
                output to trace.prn append .
                put unformatted pnbr " " global_userid  " " string(today) " " string(time,"hh:mm:ss") "打印结束 "  skip(2) .
                output close .
             end.
         
/*est*/           FOR EACH xkprhhist:
/*est*/                   DELETE xkprhhist.
/*est*/           END.
         end. /*repeat*/

