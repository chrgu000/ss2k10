/* xxscrapmt001.p - 次品返修报废-返修成新零件                                                        */
/* REVISION: 1.0      Created : 20090903   BY: Roger Xiao  ECO:*090903.1*   */

/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090903.1  By: Roger Xiao */
/* SS - 100327.1  By: Roger Xiao */  /*返修原因的代码类型改为(QC, and reject) */

/*
1.数据源xlkh_hist,所以:如果某天没有次品,则xlkh_hist无记录,则无生产数量记录显示
2.界面上的生产日期实际为生产完成的回报日期,不是生效日期.
*/


{mfdtitle.i "100327.1"}


define var date      as date .
define var date1     as date .
define var line      like ln_line.
define var line1     like ln_line.
define var part      like pt_part .
define var part1     like pt_part .
define var rsncode   as char .
define var rsncode1  as char .
define var v_time      as integer format ">>".
define var v_time1     as integer format ">>" .
define var site       like pt_site .
define var v_qc_loc   like pt_loc  .
define var v_qty_oh   like tr_qty_loc .
define var v_qty_prd  like tr_qty_loc .
define var v_rsncode  as char .
define var v_rsndesc  like rsn_desc .
define var v_qc_type as char .  
define var v_scrap_type as char . 
/* SS - 100327.1 - B 
v_qc_type = "reject" .
v_scrap_type = "reject" .
   SS - 100327.1 - E */
/* SS - 100327.1 - B */
v_qc_type = "QC" .
v_scrap_type = "QC" .
/* SS - 100327.1 - E */


define var ok_or_not  like mfc_logical no-undo. /*yes:ok,no:have errors*/
define var v_effdate  like tr_effdate no-undo.
define var v_hrs      as decimal no-undo .
define var v_prdline  as char no-undo.

define temp-table temp1 
    field t1_line          as char format "x(4)"
    field t1_trnbr         as integer 
    field t1_prdline       like ln_line
    field t1_part          like pt_part
    field t1_qty_qc        as decimal format ">>>>>>9.9"
    field t1_rsn_qc        like rsn_code
    field t1_date          like tr_date
    field t1_qty_scrap     as decimal format ">>>>>>9.9"
    field t1_rsn_scrap     like rsn_code
    field t1_scrap         as logical format "Yes/No".

define temp-table temp2 
    /*field t2_prdline       like ln_line*/
    field t2_part          like pt_part 
    field t2_qty_qc        like tr_qty_loc
    field t2_qty_scrap     like tr_qty_loc
    field t2_qty_ok        like tr_qty_loc 
    .

define temp-table tt field tt_rec as recid .
define var v_wolot like wo_lot no-undo .

define var v_ii as integer .
define var v_all_scrap   as logical .
define var v_yn1         as logical .
define var v_counter  as integer .
define var choice  as logical initial no.


define var vv_recid as recid .
define var vv_first_recid as recid .
define var v_framesize as integer .
vv_recid       = ? .
vv_first_recid = ? .
v_framesize    = 16 .


define frame zzz1.
form
 t1_line            column-label "项"
 t1_prdline         column-label "生产线"
 t1_part            column-label "零件号"
 t1_qty_qc          column-label "次品数量"
 t1_rsn_qc          column-label "次品!原因"  
 t1_qty_scrap       column-label "报废数量"
 t1_rsn_scrap       column-label "报废!原因"   
 t1_scrap           column-label "是否!报废"
with frame zzz1 width 80 v_framesize down 
title color normal  "待处理次品清单".  



form 

with frame d side-labels overlay 
ROW 10 centered width 60 .


define frame a .
form
    SKIP(.2)
    date                colon 18  label "生产日期" 
    date1               colon 53  label "至"        
    line                colon 18  label "生产线"   
    line1               colon 53  label "至"       
    part                colon 18  label "零件编号" 
    part1               colon 53  label "至"       
    rsncode             colon 18  label "原因代码" 
    rsncode1            colon 53  label "至"       
    v_time              colon 18  label "反馈时间" 
    v_time1             colon 53  label "至"        
    skip(1)
    v_all_scrap         colon 18  label "全部报废"

        
skip(2) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
rploop:
repeat:
    find first icc_ctrl where icc_domain = global_domain no-lock no-error.
    site = (if available icc_ctrl then icc_site else global_domain).

    
    for each temp1 : delete temp1 .  end.
    for each temp2 : delete temp2 .  end.
    for each tt :    delete tt  .    end. 

    if date     = low_date then date  = ? .
    if date1    = hi_date  then date1 = ? .
    if line1    = hi_char  then line1 = "" .
    if part1    = hi_char  then part1 = "" .
    if rsncode1 = hi_char  then rsncode1 = "" .
    if v_time1  = 24       then v_time1 = 0 .
    
    update 
        date     
        date1    
        line     
        line1    
        part     
        part1    
        rsncode  
        rsncode1 
        v_time     
        v_time1    
        v_all_scrap
    with frame a.

    if date     = ?  then date      =  low_date.
    if date1    = ?  then date1     =  hi_date .
    if line1    = "" then line1     =  hi_char .
    if part1    = "" then part1     =  hi_char .
    if rsncode1 = "" then rsncode1  =  hi_char .
    if v_time1  = 0  then v_time1   =  24      .

    /*限制条件:地点安全    另,是否开账,放在子程式中检查*/
    find si_mstr  where si_mstr.si_domain = global_domain and  si_site = site no-lock no-error.
    if not available si_mstr then do:
        {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
        undo , retry.    
    end.
    {gprun.i ""gpsiver.p"" "(input site, input recid(si_mstr),    output return_int)"    }
    if return_int = 0 then do:
        {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
        undo, retry.
    end.



    /*限制条件:次品库存要和回报数据相同*/
    v_qc_loc = "" .
    find first xkbc_ctrl where xkbc_domain = global_domain no-lock no-error.
    if not avail xkbc_ctrl then do:
        find first loc_mstr where loc_domain = global_domain and loc_site = site and index(loc_desc,"线边不良品仓" ) <> 0 no-lock no-error .
        if avail loc_mstr then do:
            v_qc_loc = loc_loc .
        end.
    end.
    else do:
        v_qc_loc = xkbc_qc_loc .
    end.

    message "正在检查实际次品库存数" .
    for each xlkh_hist 
        where xlkh_domain = global_domain 
        and ((xlkh_date >= date and xlkh_date <= date1 ) or xlkh_date = ?)
        and xlkh_line >= line and xlkh_line <= line1 
        and xlkh_part >= part and xlkh_part <= part1 
        and (if index(xlkh_barcode,"qc") <> 0 
                 then (xlkh_barcode >= "x" + xlkh_line + "qc" + rsncode and xlkh_barcode <= "x" + xlkh_line + "qc" + rsncode1) 
                 else  (xlkh_barcode >= "x" + xlkh_line + rsncode and xlkh_barcode <= "x" + xlkh_line + rsncode1)
            )
        and xlkh_time >= v_time * 3600 and xlkh_time <= v_time1 * 3600
        and xlkh_scrap_date = ?  /*未做返修的记录*/
        no-lock break by xlkh_site by xlkh_part:
        if first-of(xlkh_part) then do:
            v_qty_prd = 0 .
        end.
        v_qty_prd = v_qty_prd + xlkh_qc_qty .
        if last-of(xlkh_part) then do:
            v_qty_oh = 0 .
            for each ld_det where ld_domain = global_domain and ld_site = site and ld_part = xlkh_part and ld_loc = v_qc_loc no-lock:
                v_qty_oh = v_qty_oh + ld_qty_oh .
            end.

            if v_qty_oh < v_qty_prd then do:
                message "零件号:" xlkh_part skip "次品库存(" v_qty_oh ")小于次品回报数(" v_qty_prd ")" view-as alert-box  title "" .
                undo rploop, retry rploop.
            end.
        end.
    end.  /*for each xlkh_hist*/  

v_ii = 0 .
for each xlkh_hist 
    where xlkh_domain = global_domain 
    and ((xlkh_date >= date and xlkh_date <= date1 ) or xlkh_date = ?)
    and xlkh_line >= line and xlkh_line <= line1 
    and xlkh_part >= part and xlkh_part <= part1 
    and (if index(xlkh_barcode,"qc") <> 0 
             then (xlkh_barcode >= "x" + xlkh_line + "qc" + rsncode and xlkh_barcode <= "x" + xlkh_line + "qc" + rsncode1) 
             else  (xlkh_barcode >= "x" + xlkh_line + rsncode and xlkh_barcode <= "x" + xlkh_line + rsncode1)
        )
    and xlkh_time >= v_time * 3600 and xlkh_time <= v_time1 * 3600
    and xlkh_qc_qty > 0 
    and xlkh_scrap_date = ?
    no-lock
    with frame x width 300:

    find first pt_mstr where pt_domain = global_domain and pt_part = xlkh_part no-lock no-error.

    v_rsncode = if index(xlkh_barcode,"qc") <> 0 
                then substring(xlkh_barcode ,length("x" + xlkh_line + "qc") + 1 )
                else substring(xlkh_barcode ,length("x" + xlkh_line ) + 1 ) .
    find first rsn_ref where rsn_domain = global_domain and rsn_type = v_qc_type and rsn_code = v_rsncode no-lock no-error.
    v_rsndesc = if avail rsn_ref  then rsn_desc else "" .

    v_ii = v_ii + 1 .
    create  temp1 .
    assign  
            t1_line       = string(v_ii)
            t1_trnbr      = xlkh_trnbr
            t1_prdline    = xlkh_line 
            t1_part       = xlkh_part
            t1_qty_qc     = xlkh_qc_qty
            t1_rsn_qc     = v_rsncode
            t1_date       = xlkh_date 
            t1_qty_scrap  = xlkh_qc_qty
            t1_rsn_scrap  = v_rsncode
            t1_scrap      = v_all_scrap.


end. /*for each xlkh_hist*/



v_counter = 0 .
for each temp1 :
    v_counter = v_counter + 1 .
end.
if v_counter = 0  then  do:
    message "无符合条件的记录." .
    undo, retry .
end.

hide all no-pause.
view frame zzz1 .
if v_counter >= v_framesize + 1 then message "超过一屏,请移动光标查看" .
choice = no .

message "请移动光标选择" .
sw_block:
repeat :
        scroll_loop:
        do with frame zzz1:
            {swview.i 
                &domain       = "true and "
                &buffer       = temp1
                &scroll-field = t1_line
                &searchkey    = "true"
                &framename    = "zzz1"
                &framesize    = v_framesize
                &display1     = t1_line
                &display2     = t1_prdline
                &display3     = t1_part       
                &display4     = t1_qty_qc       
                &display5     = t1_rsn_qc        
                &display6     = t1_scrap       
                &display7     = t1_qty_scrap     
                &display8     = t1_rsn_scrap         
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
                {mfmsg01.i 36 1 choice} /*是否退出?*/
                if choice = yes then do :
                    for each temp1 exclusive-lock:
                        delete temp1 .
                    end.
                    clear frame zzz1 all no-pause .
                    clear frame b no-pause .
                    choice = no .
                    leave .
                end.
        end.  /*if keyfunction(lastkey)*/  
        
        if keyfunction(lastkey) = "go"
        then do:
            v_yn1 = no . /*v_yn1 = yes 则不可以退出 */
            vv_recid = ? . /*退出前清空vv_recid*/
            if v_yn1 = no then do :
                choice = yes .
                {mfmsg01.i 12 1 choice }  /*是否正确?*/
                if choice then     leave .
            end. 

        end.  /*if keyfunction(lastkey)*/  

        if vv_recid <> ? then do:
            find first temp1 where recid(temp1) = vv_recid no-error .
            if avail temp1 then do:
                    update t1_scrap with frame zzz1 .
                    if t1_scrap = yes then do on error undo,retry :
                        update t1_qty_scrap t1_rsn_scrap with frame zzz1 editing :
                            if frame-field = "t1_rsn_scrap" then do:
                                {mfnp01.i rsn_ref  t1_rsn_scrap rsn_code v_scrap_type "rsn_domain = global_domain and rsn_type"  rsn_type}
                                 if recno <> ? then do:
                                        display rsn_code @ t1_rsn_scrap with frame zzz1 .
                                 end . /* if recno <> ? then  do: */
                            end.
                            else do:
                                status input ststatus.
                                readkey.
                                apply lastkey.
                            end.
                        end.

                        if t1_qty_scrap < 0 or t1_qty_scrap > t1_qty_qc then do:
                                message "错误:报废数量超限,请重新输入." .
                                undo,retry .
                        end.

                        if t1_rsn_scrap <> "" then do:
                            find first rsn_ref where rsn_domain = global_domain and  ( rsn_type = v_scrap_type or rsn_type = "Reject") and rsn_code = t1_rsn_scrap no-lock no-error.
                            if not avail rsn_ref then do:
                                message "错误:无效原因代码,请重新输入." .
                                undo,retry .
                            end.
                        end.
                    end.
            end.
        end. /*if vv_recid <> ?*/

end. /*sw_block:*/


find first temp1 /*where t1_ok = yes*/ no-error.
if not avail temp1 then do:
    message "未作任何处理,退出." .
    choice = no.
end.

if choice then do :
    for each temp2 : delete temp2 . end.
    for each temp1 break by t1_part :
        if first-of(t1_part) then do:
            v_qty_oh  = 0 .
            v_qty_prd = 0 .
        end.
        v_qty_oh  = v_qty_oh  + t1_qty_qc .
        v_qty_prd = v_qty_prd + if t1_scrap = yes then t1_qty_scrap else 0 . 
        if last-of(t1_part) then do:
            find first temp2 where t2_part = t1_part no-error.
            if not avail temp2 then do:
                create temp2 .
                assign 
                       t2_part      = t1_part 
                       t2_qty_qc    = v_qty_oh 
                       t2_qty_scrap = v_qty_prd 
                       t2_qty_ok    = v_qty_oh - v_qty_prd . 
            end.
        end.
    end. /*for each temp1*/
    
    message "显示汇总记录?" update choice .
    if choice then do:
        form with frame e 15 down no-attr-space width 80 .
        clear frame e all no-pause.
        v_ii = 0 .
        for each temp2 break by t2_part with frame e:
            v_ii = v_ii + 1 .
                    display 
                        v_ii     format ">>9" label "行"
                        /*t2_prdline            label "生产线"*/              
                        t2_part               label "零件号"
                        t2_qty_qc             label "次品数"
                        t2_qty_scrap          label "报废数"
                        t2_qty_ok             label "合格数"
                    with frame e.
                    down 1 with frame e.            
        end. /*for each temp2*/        
    end. /*显示汇总记录*/

    message "以上全部正确?" update choice .
    if choice then do :
        for each temp2 break by t2_part :
            /*用transaction保证每个part独立,避免全部被撤销*/
            define var v_newpart like pt_part .
            do transaction:
                /*取得tr_hist记录ID*/
                on create of tr_hist do:
                    find first tt where tt_rec = recid(tr_hist) no-lock no-error.
                    if not available tt then do:
                        create tt. tt_rec = recid(tr_hist).
                    end.
                end.


                {gprun.i ""xxrescrap012.p"" 
                         "(input v_qc_loc, 
                           input t2_part, 
                           input t2_qty_qc, 
                           input t2_qty_scrap, 
                           input t2_qty_ok, 
                           output ok_or_not,
                           output v_effdate,
                           output v_hrs,
                           output v_prdline,
                           output v_newpart)" 
                }

                v_wolot = "" .
                for each tt:
                    find tr_hist where recid(tr_hist) = tt_rec and tr_type = "iss-wo" no-error .
                    if avail tr_hist then do:
                        v_wolot = tr_lot .
                    end.
                    if v_wolot <> "" then leave . 
                end.   
                
                for each tt : delete tt  . end. 

                if ok_or_not = yes then do:
                    for each temp1 where t1_part = t2_part :
                        find first xlkh_hist where xlkh_domain = global_domain and xlkh_trnbr = t1_trnbr no-error .
                        if avail xlkh_hist then do:
                            assign  xlkh_scrap_qty     = if t1_scrap = yes then t1_qty_scrap else 0 
                                    xlkh_ok_qty        = xlkh_qc_qty - xlkh_scrap_qty
                                    xlkh_newpart       = v_newpart 
                                    xlkh_scrap_rsn     = if t1_scrap = yes then t1_rsn_scrap else ""  
                                    xlkh_scrap_user    = global_userid 
                                    xlkh_scrap_date    = today
                                    xlkh_scrap_time    = time 
                                    xlkh_scrap_effdate = v_effdate
                                    xlkh_scrap_hrs     = if t2_qty_qc <> 0 and t2_qty_qc <> ? then v_hrs * (t1_qty_qc / t2_qty_qc ) else 0  
                                    xlkh_scrap_line    = v_prdline  
                                    xlkh_total_qty     = t2_qty_qc  /*for:查询tr_hist材料明细*/
                                    xlkh_scrap_wolot   = v_wolot    /*for:查询tr_hist材料明细*/
                                    .
                                    
                        end.
                    end.
                end.
            end.
        end. /*for each temp2*/        
        message "执行完成." .

        for each temp1 exclusive-lock:
            delete temp1.
        end.
        clear frame zzz1 all no-pause .

    end.  /*if choice then*/
    else do:  /*if not choice then*/
        for each temp1 exclusive-lock:
            delete temp1.
        end.
        clear frame zzz1 all no-pause .
        hide frame zzz1 no-pause .

    end. /*if not choice then*/
end.  /*if choice then*/

end.  /* REPEAT */









