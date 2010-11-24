/* SS - 090410.1 By: Neil Gao */
/* SS - 091112.1 By: Neil Gao */
/* SS - 100622.1 By: Kaine Zhang */
/* SS - 100629.1 By: Kaine Zhang */

/* SS - 100622.1 - RNB
[100629.1]
检查前期未挂账数据.如果某供应商物料有未挂账数据,且本期无协议价,则需维护其暂估价格.
[100629.1]
[100622.1]
获取"历史上暂估未处理的",本期有协议价格的资料.
将这部分数据,存入xxzgp_det.
[100622.1]
SS - 100622.1 - RNE */

{mfdtitle.i "100629.4"}

define var yr like glc_year.
define var per like glc_per.
define var vend like po_vend.
define var part like pt_part.
define var tt_recid as recid.
define var first-recid as recid.
define var update-yn as logical.
define var tqty01 like ld_qty_oh.

define temp-table tt1
  field tt1_f1 like po_vend
  field tt1_f2 like pod_part
  field tt1_f3 like pt_desc1
  field tt1_f4 like pt_desc2
  field tt1_f5 like ld_qty_oh
  field tt1_f6 like po_curr
  field tt1_f7 like pt_price
  field tt1_f8 as char
  .

form
    yr colon 25
    per colon 25
    skip(1)
with frame a side-labels width 80 attr-space.

setframelabels(frame a:handle).
    
form
    tt1_f1 column-label "供应商"
  tt1_f2 column-label "物料号"
    tt1_f3 column-label "名称"
    tt1_f5 column-label "入库数量" format "->>>>>>9"
    tt1_f7 column-label "价格"
with frame b width 80 5 down scroll 1.

mainloop:   
repeat:
    
    hide frame b no-pause.
    update yr per with frame a .
    
  find first glc_cal where glc_domain = global_domain and glc_year = yr and glc_per = per no-lock no-error.
    if not avail glc_cal then do:
        message "期间不存在".
        next.
    end.
    if glc_user1 <> "" then do:
        message "挂账已经关闭".
        next.
    end.
    
    empty temp-table tt1.
    
    /* SS - 100622.1 - B */
    /*
     *  20100624.kaine
     *  for each xxld_det where xxld_domain = global_domain and not ( xxld_year = yr and xxld_per   = per )
     *      and xxld_type = "暂估" and xxld_zg_qty <> 0 no-lock:
     *      find last xxpc_mstr 
     *          no-lock
     *          where xxpc_domain = global_domain 
     *              and xxpc_nbr <> "" 
     *              and xxpc_approve_userid <> "" 
     *              and xxpc_list = xxld_vend
     *              and xxpc_part = xxld_part
     *              and (xxpc_start <= today or xxpc_start = ? ) 
     *              and ( xxpc_expire >= today or xxpc_expire  = ? ) 
     *          no-error.
     *      if available(xxpc_mstr) then do:
     *          find first xxzgp_det where xxzgp_domain = global_domain and xxzgp_year = yr and xxzgp_per = per
     *              and xxzgp_vend = xxld_vend and xxzgp_part = xxld_part no-error.
     *          if not(available(xxzgp_det)) then do:
     *              create xxzgp_det.
     *              assign
     *                  xxzgp_domain = global_domain
     *                  xxzgp_year = yr
     *                  xxzgp_per = per
     *                  xxzgp_part = xxld_part
     *                  xxzgp_vend = xxld_vend
     *                  xxzgp_type = "正常"
     *                  xxzgp_price = xxpc_amt[1]
     *                  xxzgp_curr  = "RMB"
     *                  .
     *          end.
     *      end.
     *  end.
     */
    
    for each xxpc_mstr 
        no-lock
        where xxpc_domain = global_domain 
            and xxpc_nbr <> "" 
            and xxpc_approve_userid <> "" 
            and (xxpc_start <= today or xxpc_start = ? ) 
            and ( xxpc_expire >= today or xxpc_expire  = ? ) 
        break
        by xxpc_list
        by xxpc_part
    :
        if last-of(xxpc_part) then do:
            find first xxzgp_det 
                where xxzgp_domain = global_domain 
                    and xxzgp_year = yr 
                    and xxzgp_per = per
                    and xxzgp_vend = xxpc_list 
                    and xxzgp_part = xxpc_part 
                no-error.
            if not(available(xxzgp_det)) then do:
                create xxzgp_det.
                assign
                    xxzgp_domain = global_domain
                    xxzgp_year = yr
                    xxzgp_per = per
                    xxzgp_part = xxpc_part
                    xxzgp_vend = xxpc_list
                    xxzgp_curr  = "RMB"
                    .
            end.
            assign
                xxzgp_type = "正常"
                xxzgp_price = xxpc_amt[1]
                .
        end.
    end.
    /* SS - 100622.1 - E */
    
/* SS 090514.1 - B */
/*
    for each xxld_det where xxld_domain = global_domain and xxld_qty <> 0 and xxld_price = 0 and xxld_zg_price = 0 :
*/
 /* SS 090514.1 - E */
    for each tr_hist use-index tr_part_eff where tr_domain = global_domain and tr_qty_loc <> 0 and tr_part < "A"
        and tr_effdate >= glc_start and tr_effdate <= glc_end and tr_loc <> "ic01" no-lock
        break by tr_part by substring(tr_serial,7):
            
        if (tr_type = "rct-tr" and tr_program = "xxtrchmt.p" )
                or tr_type = "RCT-PO" or tr_type = "rct-unp" or tr_type = "iss-prv" 
                or tr_type = "rct-wo" then tqty01 = tqty01 + tr_qty_loc.
        
        if last-of( substring(tr_serial,7) ) then do: 
            find first xxzgp_det where xxzgp_domain = global_domain and xxzgp_year = yr and xxzgp_per = per 
                and xxzgp_vend = substring(tr_serial,7) and xxzgp_part = tr_part no-lock no-error.
            if avail xxzgp_det then next.
            find last xxpc_mstr where xxpc_domain = global_domain and xxpc_nbr <> "" and xxpc_approve_userid <> "" 
                and xxpc_list = substring(tr_serial,7) and xxpc_part = tr_part
                and (xxpc_start <= today or xxpc_start = ? ) and ( xxpc_expire >= today or xxpc_expire  = ? ) no-lock no-error.
            if not avail xxpc_mstr then do:
                create tt1.
                assign tt1_f1 = substring(tr_serial,7)
                             tt1_f2 = tr_part
                             tt1_f6 = "RMB"
                             tt1_f8 = "暂估"
                             tt1_f5 = tqty01
                             .
                find first pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock no-error.
                if avail pt_mstr then do:
                    tt1_f3 = pt_desc1.
                    tt1_f4 = pt_desc2.
                end.
                find last xxzgp_det where xxzgp_domain = global_domain  
                    and xxzgp_vend = substring(tr_serial,7) and xxzgp_part = tr_part no-lock no-error.
                if avail xxzgp_det then do:
                    tt1_f7 = xxzgp_price.
                end.
            end.
            else do:
                create xxzgp_det.
        assign xxzgp_domain = global_domain
                     xxzgp_year = yr
                     xxzgp_per = per
                     xxzgp_part = tr_part
                     xxzgp_vend = substring(tr_serial,7)
                     xxzgp_type = "正常"
                     xxzgp_price = xxpc_amt[1]
                     xxzgp_curr  = "RMB"
                     .
            end.
            tqty01 = 0.
        end. /* if last-of( tr_part) then do */
    end. /* for each */
    
    
    /* SS - 100629.1 - B */
    for each xxgzd_det
        no-lock
        where xxgzd_domain = global_domain
            and not(xxgzd_is_confirm)
            and not(xxgzd_year = yr and xxgzd_per = per)
        use-index xxgzd_is_confirm
    :
        find first xxzgp_det 
            where xxzgp_domain = global_domain 
                and xxzgp_year = yr 
                and xxzgp_per = per
                and xxzgp_vend = xxgzd_vend
                and xxzgp_part = xxgzd_part 
            no-error.
        if not(available(xxzgp_det)) then do:
            find first tt1
                where tt1_f1 = xxgzd_vend
                    and tt1_f2 = xxgzd_part
                no-error.
            if not(available(tt1)) then do:
                create tt1.
                assign 
                    tt1_f1 = xxgzd_vend
                    tt1_f2 = xxgzd_part
                    tt1_f6 = "RMB"
                    tt1_f8 = "暂估"
                    .
                find first pt_mstr where pt_domain = global_domain and pt_part = tt1_f2 no-lock no-error.
                if avail pt_mstr then do:
                    tt1_f3 = pt_desc1.
                    tt1_f4 = pt_desc2.
                end.
            end.
            tt1_f5 = tt1_f5 + xxgzd_qty.
            find last xxzgp_det where xxzgp_domain = global_domain
                and xxzgp_vend = tt1_f1 and xxzgp_part = tt1_f2 no-lock no-error.
            if avail xxzgp_det then do:
                tt1_f7 = xxzgp_price.
            end.
        end.
    end.
    /* SS - 100629.1 - E */
    
    
    find first tt1 no-lock no-error.
    if not avail tt1 then do:
        message "无记录".
        next.
    end.
    
    loop1:
    repeat on error undo, leave:
        {xuview.i
             &buffer = tt1
             &scroll-field = tt1_f1
             &framename = "b"
             &framesize = 5
             &display1     = tt1_f1
             &display2     = tt1_f2
             &display3     = tt1_f3
             &display4     = tt1_f5
             &display6     = tt1_f7
             &searchkey    = true
             &logical1     = false
             &first-recid  = first-recid
             &exitlabel = loop1
             &exit-flag = true
             &record-id = tt_recid
             &cursordown = "    
                                            if avail tt1 then run dispcmmt (input tt1_f2).
                         "
             &cursorup   = " 
                                            if avail tt1 then run dispcmmt (input tt1_f2).  
                         "
             }
    
        if keyfunction(lastkey) = "end-error" then do:
            update-yn = no.
      {pxmsg.i &MSGNUM=36 &ERRORLEVEL=1 &CONFIRM=update-yn}
       if update-yn = yes then next mainloop.
       else next loop1.
        end.
        
        if keyfunction(lastkey) = "return" then 
        do on error undo,retry :
            disp tt1_f7 with frame b.
            prompt-for tt1_f7 with frame b.
            if input tt1_f7 <= 0 then do:
                message "错误: 价格不能等于或小于零".
                undo,retry.
            end.
            tt1_f7 = input tt1_f7.
        end.
        
        if keyfunction(lastkey) = "go" then do:
            update-yn = yes.
      {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=update-yn}
      if update-yn = no then next loop1.
      for each tt1 no-lock where tt1_f7 > 0:
        find first xxzgp_det where xxzgp_domain = global_domain and xxzgp_year = yr and xxzgp_per = per
            and xxzgp_vend = tt1_f1 and xxzgp_part = tt1_f2 no-error.
        if not avail xxzgp_det then do:
            create xxzgp_det.
            assign xxzgp_domain = global_domain
                         xxzgp_year = yr
                         xxzgp_per = per
                         xxzgp_part = tt1_f2
                         xxzgp_vend = tt1_f1
                         xxzgp_type = "暂估"
                         xxzgp_price = tt1_f7
                         xxzgp_curr  = "RMB"
                         .
        end. /* if not avail xxzgp_det */
            end.
            next mainloop.
        end.
    end. /* loop1 */
end. /* mainloop */

procedure dispcmmt:
    define input parameter iptf1 like pt_part.
    pause 0.
    {gprun.i ""xxdpcmmt.p"" "(input iptf1)"}
    pause 0.
end.
