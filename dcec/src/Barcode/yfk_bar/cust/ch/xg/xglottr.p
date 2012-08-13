/*************************************************
** Program: xglottr.p
** Author : Li Wei , AtosOrigin
** Date   : 2005-8-26
** Description: Pallet Maintenance
** Last modified: hou   2006.03.06    *H01*     
*************************************************/

{mfdtitle.i}

define variable new_type like xwck_type.
define variable cfm_yn as logical.
define variable lot like xwck_lot.
define variable fromloc as character.
define variable toloc as character.
define variable filename as character format "x(50)".
define variable errors as integer.

/*H01*/
{xglogdef.i "new"}

form
    xwck_lot    colon 35
    skip(1)
    xwck_pallet colon 35
    xwck_part   colon 35
    xwck_qty_chk colon 35
    xwck_stat   colon 35
    skip(1)
    new_type    colon 35
with frame a side-labels width 80 attr-space.

filename = string(month(today),"99") + string(day(today),"99") + ".cim".

mainloop:
repeat on error undo,retry:
    errors = 0.
    if search(filename) <> ? then os-delete value(filename).

    prompt-for xwck_lot with frame a editing:
        {mfnp01.i xwck_mstr xwck_lot xwck_lot xwck_lot xwck_lot xwck_lot }
        if recno <> ? then do:
            new_type = xwck_type .
            display 
            xwck_lot  
            xwck_pallet 
            xwck_part
            xwck_qty_chk
            xwck_stat 
            new_type
            with frame a. 
        end.
    end.

    if input xwck_lot <> "" then do:
        find first xwck_mstr where xwck_lot = input xwck_lot
                               and xwck_stat = "CK"
                               and xwck_shipper = ""
                               no-error.
        if not avail xwck_mstr then do:
            message "ERR:没有符合条件的批号,不能调整托盘信息".
            undo,retry.
        end.
        else do:
            new_type = xwck_type .
            display 
            xwck_pallet 
            xwck_part 
            xwck_stat
            xwck_qty_chk
            new_type
            with frame a.
        end.
    end.

    update 
    new_type validate(new_type = "1" or new_type = "2", "ERR:输入正确的类型")
    with frame a.


    if new_type <> xwck_type then do:
        cfm_yn = yes.
        message "INF:确认修改" update cfm_yn.
        if cfm_yn then do:
            xwck_type   = new_type.
            find first xgpl_ctrl no-lock where xgpl_lnr = xwck_lnr no-error.
            if avail xgpl_ctrl then do:
                if new_type = "2" then 
                    assign
                    fromloc = xgpl_loc
                    toloc   = xgpl_loc1.
                else 
                    assign
                    fromloc = xgpl_loc1
                    toloc   = xgpl_loc.

                    {gprun.i ""xgictrcm.p""
                    "(input filename,
                    input xwck_part,
                    input xwck_qty_chk,
                    input today,
                    input xwck_lot,
                    input xgpl_site,
                    input fromloc,
                    input '',
                    input '',
                    input xgpl_site,
                    input toloc)"}

                  {xgcmdef.i "new"}
                  {gprun.i ""xgcm001.p""
                  "(INPUT filename,
                  output errors)"}

                   if errors > 0 then do:
                       {mfselprt.i "terminal" 132}
                       for each cim_mstr break by cim_group:
                           disp cim_desc with width 200 stream-io.
                       end.
                       {mfreset.i}
                       undo , leave.
                   end.
                   else do:
                      message "INF:数据导入成功!".
                      pause 3.
                    
                   end.
            end.
            else do:
                message "ERR:先维护生产线控制文件".
                undo,retry.
            end.
        end.
    end. /*if new_type <> xwck_type*/

    if search(filename) <> ? then os-delete value(filename).

end. /*mainloop*/

/*H01*/
   {xgxlogdet.i}
