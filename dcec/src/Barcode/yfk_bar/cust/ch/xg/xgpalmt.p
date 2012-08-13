/*************************************************
** Program: xgpalmt.p
** Author : Li Wei , AtosOrigin
** Date   : 2005-8-19
** Description: Pallet Maintenance
*************************************************/

{mfdtitle.i}

define variable new_pal like xwck_pallet.
define variable cfm_yn as logical.
define variable lot like xwck_lot.
define buffer buf_xwck for xwck_mstr.

form
    xwck_mstr.xwck_lot colon 35
    skip(1)
    xwck_mstr.xwck_pallet colon 35
    xwck_mstr.xwck_part   colon 35
    xwck_mstr.xwck_stat   colon 35
    skip(1)
    new_pal     colon 35 label "新托盘"
with frame a side-labels width 80 attr-space.


mainloop:
repeat:
    new_pal = "".
    prompt-for xwck_mstr.xwck_lot with frame a editing:
        {mfnp01.i xwck_mstr xwck_lot xwck_lot xwck_lot xwck_lot xwck_lot }
        if recno <> ? then do:
            display 
            xwck_mstr.xwck_lot  
            xwck_mstr.xwck_pallet 
            xwck_mstr.xwck_part 
            xwck_mstr.xwck_stat with frame a. 
        end.
    end.

    if input xwck_mstr.xwck_lot <> "" then do:
        find first xwck_mstr where xwck_mstr.xwck_lot = input xwck_lot
                               and xwck_mstr.xwck_stat = "CK"
                               /*and xwck_blkflh = no*/
                               and xwck_mstr.xwck_shipper = ""
                               no-error.
        if not avail xwck_mstr then do:
            message "ERR:没有符合条件的批号,不能调整托盘信息".
            undo,retry.
        end.
        else do:
            display 
            xwck_mstr.xwck_pallet 
            xwck_mstr.xwck_part 
            xwck_mstr.xwck_stat 
            with frame a.
        end.
    end.

    update new_pal with frame a.

    find first buf_xwck no-lock where buf_xwck.xwck_pallet = new_pal
                                            and buf_xwck.xwck_shipper = ""
                                          no-error.
    if avail buf_xwck then do:
        message "ERR:确认托盘调整" update cfm_yn.
        if cfm_yn then do:
            cfm_yn = no.
            assign xwck_mstr.xwck_pallet = new_pal.

            display 
            xwck_mstr.xwck_pallet 
            with frame a.
        end.
    end.
    else do:
        message  "ERR:新托盘号不存在或已发运".
        undo,retry.
    end.
end. /*mainloop*/