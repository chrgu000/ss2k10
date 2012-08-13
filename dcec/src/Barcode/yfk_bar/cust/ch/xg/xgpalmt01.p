/*************************************************
** Program: xgpalmt01.p
** Author : Li Wei , AtosOrigin
** Date   : 2006-2-21
** Description: Finish Goods pallet Maintenance
*************************************************/

define variable pallet like xwck_pallet.
define variable origin_to  as character.
define variable origin_loc as character.
define variable origin_to1  as character.
define variable origin_loc1 as character.

define variable confirm as logical.



form
    pallet     colon  20 
    origin_to  colon  20 label "客户"
    origin_loc  colon 60 label "库位"
    origin_to1  colon 20 label "至客户"     
    origin_loc1 colon 60 label "至To Locatione"
with frame a side-labels width 80 attr-space.

mainloop:
repeat:

    origin_to = "".
    origin_loc = "".
    origin_to1 = "".
    origin_loc1 = "".

    pallet = "".
    confirm = yes.
    
    update pallet with frame a.
    
    find first xwck_mstr no-lock where xwck_pallet = pallet
                                 and xwck_type = "1"
                                 and xwck_stat = "CK"
                                 and xwck_shipper = ""
                                 no-error.
    if avail xwck_mstr then do:
        assign
        origin_to = xwck_cust
        origin_loc = xwck_loc_des.
        display origin_to origin_loc with frame a.
        
        set origin_to1 origin_loc1 with frame a.

        if not can-find(cm_mstr where cm_addr = origin_to1) then do:
            message "ERR:错误的客户".
            undo mainloop,retry.
        end.
        
        if not can-find(loc_mstr where loc_loc = origin_loc1) then do:
            message "ERR:库位错误".
            undo mainloop, retry.
        end.


        message "INF:确认对托盘的修改" update confirm .

    end.
    else do:
        message "ERR:无效的托盘号".
        undo mainloop,retry.
    end.

    if confirm then do: 
        for each xwck_mstr where xwck_pallet = pallet
                            and xwck_type = "1"
                            and xwck_stat = "CK"
                            and xwck_shipper = ""
                            USE-INDEX xwck_pal
                            break by xwck_part
                            by xwck_pallet:
            assign
            xwck_cust = origin_to1
            xwck_loc_des =  origin_loc1.
            display
            xwck_pallet
            xwck_cust
            xwck_loc_des
            xwck_part.
        end.
    end.
end.