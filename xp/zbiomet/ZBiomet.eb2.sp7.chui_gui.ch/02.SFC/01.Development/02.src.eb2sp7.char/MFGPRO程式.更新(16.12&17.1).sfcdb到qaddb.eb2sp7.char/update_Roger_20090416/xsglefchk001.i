/*just like gpglef1.i */


/*1.类型*/
if {&module} <> "" then do:
    gpglef_tr_type = {&module} .
end.
else gpglef_tr_type = "ic". 
if gpglef_tr_type = "" then gpglef_tr_type = "ic".


/*2.日期*/
if {&date} <> ? then do:
    gpglef_effdate = {&date} .
end.
else gpglef_effdate = today. 
if gpglef_effdate = ? then gpglef_effdate = today .


/*3.会计单位*/
if {&entity} <> "" then do:
    gpglef_entity = {&entity} . 
end.
else gpglef_entity = "" .
if gpglef_entity = "" then do:
    find first icc_ctrl no-lock no-error.
    gpglef_entity = if avail icc_ctrl then icc_site else "" .
    find si_mstr where si_site   = gpglef_entity no-lock no-error .
    gpglef_entity = if avail si_mstr then si_entity else gpglef_entity .
end.


/*
message gpglef_entity month(gpglef_effdate) day(gpglef_effdate) year(gpglef_effdate) view-as alert-box .
*/


/*4.判断*/
{gprun.i ""gpglef1.p""
         "( input  gpglef_tr_type,
            input  gpglef_entity,
            input  gpglef_effdate,
            output gpglef_result,
            output gpglef_msg_nbr
         )"
}

/*5.结果返回*/
if gpglef_result > 0 then do:
    if gpglef_result = 1 then 
        message "警告:无效期间/年份" gpglef_effdate view-as alert-box title "" .
    else if gpglef_result = 2 then
        message "警告:会计单位的期间已经结束" gpglef_entity view-as alert-box title "" .
    else do:
        {pxmsg.i &MSGNUM=gpglef_msg_nbr &ERRORLEVEL=4} 
    end.

    undo,leave .
end. 
