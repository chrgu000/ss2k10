/* xxkbmtmt.p - mfg part kb detail MAINTENANCE                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao    */
/*-Revision end------------------------------------------------------------ */



/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */

define var part  like xkb_part .
define var site  like xkb_site .
define var desc1 like pt_desc1.
define var desc2 like pt_desc2 .
define var v_id  like xkb_kb_id .
define var v_type  like xkb_type .
define var v_yn  like mfc_logical initial yes.
/* define var recno  as recid . */

define var stat_from like xkb_status .
define var raim_qty  like xkb_kb_raim_qty .
define var loc_from  like loc_loc .
define variable v_fqty    like xmpt_kb_fqty .
define var v_qty_firm as logical init no.

define var trnbr like tr_trnbr.
define var v_trnbr like tr_trnbr.
define buffer xkbhhist for xkbh_hist.


define  frame a.
define  frame b.

/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
    site                     colon 18
    v_type                   colon 18 validate(can-find(first xkb_mstr where xkb_domain = global_domain and xkb_type = input v_type no-lock ) ,"无此看板类别")
    part                     colon 18 
    desc1                    colon 52
    v_id                     colon 18 
    desc2                    colon 52 no-label
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

form
    xkb_nbr              colon 18
    xkb_line             colon 52
    xkb_wo_lot           colon 18
    xkb_status           colon 52
    xkb_kb_raim          colon 18
    xkb_kb_raim_qty      colon 52
    xkb_location         colon 18
    xkb_print            colon 52
    xkb_crt_date         colon 18
    xkb_upt_date         colon 52
    xkb_loc              colon 18
    xkb_lot              colon 52
    xkb_ref              colon 18
    xkb_vend             colon 52
    xkb_kb_loc           colon 18
    xkb_prod_line        colon 52  label "生产线"



with frame b title color normal (getFrameTitle("ITEM_DATA",23)) side-labels width 80 attr-space.         

/* SET EXTERNAL LABELS  */
setFrameLabels(frame b:handle).

/* DISPLAY */
view frame a.
view frame b.

mainloop:
repeat with frame a:
    site = "" .
    v_type = "" .
    desc1 = "" .
    desc2 = "" .
    part = "" .
    v_id = 0  .

    clear frame a no-pause .
    clear frame b no-pause .

    find icc_ctrl where icc_domain = global_domain no-lock no-error.
    site = if avail icc_ctrl then icc_site else "" .
    disp site with frame a .


    ststatus = stline[1].
    status input ststatus.

    update site v_type with frame a .
    if input site <> "" and ( not can-find(si_mstr where si_domain = global_domain and si_site = input site ) ) then do:
        message "地点不存在" view-as alert-box .
        undo mainloop, retry mainloop.
    end.

    find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = site) no-lock no-error .
    if not avail xkbc_ctrl then do:
        find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = "" ) no-lock no-error .
        if not avail xkbc_ctrl then do:
            /* {pxmsg.i &MSGNUM=???? &ERRORLEVEL=3} */
            message "看板模块没有开启" view-as alert-box .
            undo mainloop , retry mainloop .
        end.
    end.

    prompt-for part v_id with frame a editing:
        if frame-field = "part" then do:
                /* FIND NEXT/PREVIOUS RECORD */
                {mfnp.i xkb_mstr part  "xkb_domain = global_domain and xkb_site = site and xkb_type = v_type and xkb_part "  part xkb_part xkb_kb_type}
                
                if recno <> ? then do:
                    find pt_mstr where pt_domain = global_domain and pt_part = input part no-lock no-error .
                    desc1 = if avail pt_mstr then pt_desc1 else "" .
                    desc2 = if avail pt_mstr then pt_desc2 else "" .
        
                    disp xkb_part @ part desc1 desc2 v_type site xkb_kb_id @ v_id  with frame a .
                    disp xkb_nbr  xkb_line xkb_wo_lot xkb_status xkb_kb_raim xkb_kb_raim_qty xkb_location xkb_print 
                         xkb_crt_date xkb_upt_date xkb_loc xkb_lot xkb_ref xkb_vend xkb_kb_loc xkb_prod_line with frame b .
                end . /* if recno <> ? then  do: */
        end.
        else if frame-field = "v_id" then do: 
                {mfnp.i xkb_mstr v_id  "xkb_domain = global_domain and xkb_site = site and xkb_type = v_type and xkb_part = input part and xkb_kb_id"  v_id xkb_kb_id  xkb_kb_type }
                
                if recno <> ? then do:
                    find pt_mstr where pt_domain = global_domain and pt_part = input part no-lock no-error .
                    desc1 = if avail pt_mstr then pt_desc1 else "" .
                    desc2 = if avail pt_mstr then pt_desc2 else "" .
        
                    disp xkb_part @ part desc1 desc2 v_type site xkb_kb_id @ v_id  with frame a .
                    disp xkb_nbr  xkb_line xkb_wo_lot xkb_status xkb_kb_raim xkb_kb_raim_qty xkb_location xkb_print 
                         xkb_crt_date xkb_upt_date xkb_loc xkb_lot xkb_ref xkb_vend xkb_kb_loc xkb_prod_line  with frame b .
                end . /* if recno <> ? then  do: */
        end.
        else do :
                status input ststatus.
                readkey.
                apply lastkey.
        end.
        

    end. /* PROMPT-FOR...EDITING */
    assign site v_type part v_id .
    

    find pt_mstr where pt_domain = global_domain and pt_part = part no-lock no-error .
    desc1 = if avail pt_mstr then pt_desc1 else "" .
    desc2 = if avail pt_mstr then pt_desc2 else "" .
    find xkb_mstr where xkb_domain = global_domain and xkb_type = v_type and xkb_site = site and xkb_part = part and xkb_kb_id = v_id no-lock no-error .
    recno = if avail xkb_mstr then recid(xkb_mstr) else ? .
    if avail xkb_mstr then display xkb_part @ part desc1 desc2 v_type site xkb_kb_id @ v_id  with frame a .
    else do :
        disp site v_type part  desc1 desc2 v_id with frame a .
        message "无对应看板记录,请重新输入" view-as alert-box .
        undo mainloop , retry mainloop .
    end.

    setloop:
    do on error undo ,retry :
        find  xkb_mstr where  recid(xkb_mstr) = recno exclusive-lock no-error .
        stat_from = xkb_status .
        raim_qty = xkb_kb_raim_qty .


        update xkb_nbr  xkb_line xkb_wo_lot xkb_status xkb_kb_raim xkb_kb_raim_qty xkb_location xkb_print 
               xkb_crt_date xkb_upt_date xkb_loc xkb_lot xkb_ref xkb_vend xkb_kb_loc xkb_prod_line  with frame b editing :
            readkey.
            apply lastkey.
        end. /* update ...EDITING */
        
        find first loc_mstr where loc_domain = global_domain and loc_loc = xkb_loc no-lock no-error .
        if not avail loc_mstr then do:
              message "库位不存在,请重新输入."  view-as alert-box .
              undo setloop,retry .
        end.
        if xkb_crt_date = ?  then do:
              message "日期不可为空,请重新输入."  view-as alert-box .
              undo setloop,retry .            
        end.

        if  xkb_upt_date = ? then xkb_upt_date = today.

        if raim_qty <> 0 and xkb_status <> stat_from  then do:
              message "看板绑定库存,不允许修改状态."  view-as alert-box .
              undo setloop,retry .  
        end.
        if xkb_kb_raim_qty <> 0 and xkb_status <> "U"  then do:
              message "看板绑定库存,状态必须为U ."  view-as alert-box .
              undo setloop,retry .  
        end.
        if xkb_kb_raim_qty <> raim_qty then do:

                    if xkb_kb_id <> 000  and xkb_kb_id <> 999  then do:                                    
                        if v_type = "M" then do:
                            find xmpt_mstr where xmpt_domain = global_domain and xmpt_site = xkb_site and xmpt_part = xkb_part no-lock no-error .
                            v_fqty = if avail xmpt_mstr then xmpt_kb_fqty else 0  .
                            v_qty_firm = if avail xmpt_mstr then xmpt_qty_firm else no .
                        end.
                        if v_type = "P" then do:
                            find xppt_mstr where xppt_domain = global_domain and xppt_site = xkb_site and xppt_part = xkb_part no-lock no-error .
                            v_fqty = if avail xppt_mstr then xppt_kb_fqty else 0  .
                            v_qty_firm = if avail xppt_mstr then xppt_qty_firm else no .
                                         
                        end.

                        if (xkb_kb_raim_qty ) > xkb_kb_qty then do:
                            message "看板余量超过看板容量" view-as alert-box .
                            if v_qty_firm then undo setloop , retry.
                        end.
                    end.  
        end.

        if xkb_status <> stat_from then do:
            if xkb_status = "" or index("ARUPD",xkb_status) = 0 then do:
                message "状态不可为空,且仅限系统设定的状态" view-as alert-box .
                undo setloop ,retry  .
            end.
            if stat_from = "A" and xkb_status = "R" then do:
                message "状态(AtoR)请使用看板刷读下达程式." view-as alert-box .
                undo setloop ,retry  .
            end.
            if stat_from = "D" and xkb_status <> "A" then do:
                message "状态D只能变更为状态A." view-as alert-box .
                undo setloop ,retry .
            end.       

            if xkb_kb_id <> 000  and xkb_kb_id <> 999  then do:
                        if v_type = "M" then do:
                            find xmpt_mstr where xmpt_domain = global_domain and xmpt_site = xkb_site and xmpt_part = xkb_part exclusive-lock no-error .
                            if xkb_stat = "D" then do:
                                 xmpt_kb_avail = max(xmpt_kb_avail - 1,0) .
                            end.
                            if stat_from = "D" then do:
                                 xmpt_kb_avail = xmpt_kb_avail + 1 .
                            end.
                        end.
                        if v_type = "P" then do:
                            find xppt_mstr where xppt_domain = global_domain and xppt_site = xkb_site and xppt_part = xkb_part exclusive-lock no-error .
                            if xkb_stat = "D" then do:
                                 xppt_kb_avail = max(xppt_kb_avail - 1 ,0).
                            end.
                            if stat_from = "D" then do:
                                 xppt_kb_avail = xppt_kb_avail + 1 .
                            end.
                        end.
            end.

  
        end.

        message "以上信息全部正确?" view-as alert-box question buttons yes-no title "" update choice as logical.
        if not choice then do :
            undo setloop, retry .
        end.

        if xkb_status <> stat_from or xkb_kb_raim_qty <> raim_qty  then do:
             {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                        &kb_id="xkb_kb_id"    &effdate=today        &program="'mhjit037.p'"
                        &qty="xkb_kb_qty"     &ori_qty="raim_qty" &tr_trnbr=0
                        &b_status="stat_from"       &c_status="xkb_status"
                        &rain_qty="xkb_kb_raim_qty"}   
        end.


    end. /*  setloop: */
end.   /*  mainloop: */

status input.
