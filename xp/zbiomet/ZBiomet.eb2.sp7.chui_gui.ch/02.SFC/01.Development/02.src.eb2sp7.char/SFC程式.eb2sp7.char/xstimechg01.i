do on error undo,retry :

    update  v_date_start 
            v_date_end  
            v_hs   v_ms 
            v_he   v_me 
              
            

    with frame  {1} .


    {xserr001.i "v_hs" } /*检查数量栏位是否输入了问号*/
    {xserr001.i "v_he" } /*检查数量栏位是否输入了问号*/
    {xserr001.i "v_ms" } /*检查数量栏位是否输入了问号*/
    {xserr001.i "v_me" } /*检查数量栏位是否输入了问号*/
    
    if v_date_start = ? then do:
            message "日期不允许为空" view-as alert-box title "" .
            next-prompt v_date_start with frame {1}.
            undo,retry .
    end.

    if v_date_end = ? then do:
            message "日期不允许为空" view-as alert-box title "" .
            next-prompt v_date_end with frame {1}.
            undo,retry .
    end.

    if v_date_start > today then do:
            message "日期不允许迟过今天" view-as alert-box title "" .
            next-prompt v_date_start with frame {1}.
            undo,retry .
    end.

    if v_date_end > today  then do:
            message "日期不允许迟过今天" view-as alert-box title "" .
            next-prompt v_date_end with frame {1}.
            undo,retry .
    end.

    if v_hs >= 24 then do:
        message "时间格式有误" .
        next-prompt v_hs with frame {1}.
        undo,retry .
    end.

    if v_he >= 24 then do:
        message "时间格式有误" .
        next-prompt v_he with frame {1}.
        undo,retry .
    end.

    if v_ms >= 60 then do:
        message "时间格式有误" .
        next-prompt v_ms with frame {1}.
        undo,retry .
    end.

    if v_me >= 60 then do:
        message "时间格式有误" .
        next-prompt v_me with frame {1}.
        undo,retry .
    end.


    v_date        = today .
    v_time        = time  .
    v_msgtxt      = "" .   /*提示信息*/

    v_time_start  = v_hs * 60 * 60 + v_ms * 60  . 
    v_time_end    = v_he * 60 * 60 + v_me * 60  .
    if (integer(v_date_start) + v_time_start / 86400 ) > (integer(v_date) + (v_time - (v_time mod 60)) / 86400 ) then do:
        message "开始时间不可迟于现在(" v_date "" string(v_time,"hh:mm") ")." .
        undo,retry .
    end.
    if (integer(v_date_end) + v_time_end / 86400 ) > (integer(v_date) + (v_time - (v_time mod 60)) / 86400 ) then do:
        message "结束时间不可迟于现在(" v_date "" string(v_time,"hh:mm") ")." .
        undo,retry .
    end.
    if (integer(v_date_start) + v_time_start / 86400 ) > (integer(v_date_end) + v_time_end / 86400 ) then do:
        message "结束时间不可早于开始时间" .
        undo,retry .
    end.
end. /*updatetime*/     