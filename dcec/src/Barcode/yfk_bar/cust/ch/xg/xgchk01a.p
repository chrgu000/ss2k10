/*************************************************
** Program: xgchk01a.p
** Author : Li Wei , AtosOrigin
** Date   : 2005-8-18
** Description: Generate Pallet number
*************************************************/

define input parameter I_part like pt_part.
define output parameter O_pallet_nbr like xwck_pallet.
define variable moncd as character.

find first xpal_ctrl where xpal_part = I_part no-error.
if not avail xpal_ctrl then do:
    message "ERR:请先维护托盘控制文件".
    undo,retry.
end.
else do:
    if xpal_date <> today then do:
        /*reset number everyday*/
        xpal_date = today.  
        xpal_next_nbr = 1. 
    end.

    find first xwycd_mstr where xwycd_yr = year(xpal_date) no-error.
    if not avail xwycd_mstr then do:
        message "ERR:请先维护年份代码对照表".
        undo,retry.
    end.

    if month(today) = 10 then moncd = "A".
    else if month(today) = 11 then moncd = "B".
    else if month(today) = 12 then moncd = "C".
    else moncd = string(month(today),"9").
    

    O_pallet_nbr = string(xpal_line,"999") +
                   string(xpal_code,"9") +
                   string(xwycd_cd,"9") +
                   string(moncd,"9") +
                   string(day(today),"99") +
                   string(xpal_next_nbr,"999").

   xpal_next_nbr = xpal_next_nbr + 1. 
end.
