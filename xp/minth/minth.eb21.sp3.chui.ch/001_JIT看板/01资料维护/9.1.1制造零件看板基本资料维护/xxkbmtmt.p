/* xxkbmtmt.p - mfg part kb MAINTENANCE                                     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */

define var part  like xmpt_part .
define var site  like xmpt_site .
define var desc1 like pt_desc1.
define var desc2 like pt_desc2 .
define var del-yn  like mfc_logical initial yes.
/* define var recno  as integer . */



define  frame a.
define  frame b.

/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
    part                     colon 18 
    desc1                    colon 52
    site                     colon 18
    desc2                    colon 52 no-label
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

form
    xmpt_kb_rolume           colon 18 validate( input xmpt_kb_rolume > 0 , "最小值为 1 " )
    xmpt_box_type            colon 54 validate(can-find(code_mstr where code_domain = global_domain and  code_fldname = "xmpt_box_type" and code_value = input xmpt_box_type no-lock ) 
                                               or (not can-find(first code_mstr where code_domain = global_domain and code_fldname = "xmpt_box_type" no-lock )) ,"该值必须在通用代码中存在.  请重新输入。" )
    xmpt_type                colon 18 validate(can-find(code_mstr where code_domain = global_domain and  code_fldname = "xmpt_type" and code_value = input xmpt_type no-lock ) 
                                               or (not can-find(first code_mstr where code_domain = global_domain and code_fldname = "xmpt_type" no-lock )),"该值必须在通用代码中存在.  请重新输入。" )
    xmpt_ship_type           colon 54 format "Yes-时间/No-批量"
    xmpt_lot_qty             colon 18 validate( input xmpt_ship_type = no and input xmpt_lot_qty <> 0 ,"交货方式为批量时必须维护批量" )
    xmpt_b_op                colon 18
    xmpt_a_op                colon 54
    xmpt_wkctr               colon 18
    xmpt_op                  colon 54
    xmpt_loc                 colon 18
    xmpt_line_loc            colon 54 
    xmpt_demand_day          colon 18
    xmpt_rel_day             colon 18
    xmpt_set_up              colon 54
    xmpt_epei                colon 18
    xmpt_kb_number           colon 54
    xmpt_kb_avail            colon 18
    xmpt_kb_suggest          colon 54  
    xmpt_kb_fqty             colon 18   
    xmpt_kb_min              colon 54  
    xmpt_me_int              colon 18  
    xmpt_me_qty              colon 54
    xmpt_safety_facter       colon 18 validate( input  xmpt_safety_facter > 0 , "最小值为 1 "  )
    xmpt_comb                colon 54 
    xmpt_qty_firm            colon 18
with frame b title color normal (getFrameTitle("ITEM_DATA",23)) side-labels width 80 attr-space.         

/* SET EXTERNAL LABELS  */
setFrameLabels(frame b:handle).

/* DISPLAY */
view frame a.
view frame b.

mainloop:
repeat with frame a:
    clear frame a no-pause .
    clear frame b no-pause .

    find icc_ctrl where icc_domain = global_domain no-lock no-error.
    site = if avail icc_ctrl then icc_site else "" .
    disp site with frame a .


    ststatus = stline[1].
    status input ststatus.

    prompt-for part site with frame a editing:
         if frame-field = "part" then do:
             /* FIND NEXT/PREVIOUS RECORD */
             {mfnp.i xmpt_mstr part  "xmpt_domain = global_domain and xmpt_part "  part xmpt_part xmpt_part}

             if recno <> ? then do:
                    find pt_mstr where pt_domain = global_domain and pt_part = xmpt_part no-lock no-error .
                    desc1 = if avail pt_mstr then pt_desc1 else "" .
                    desc2 = if avail pt_mstr then pt_desc2 else "" .
                    display xmpt_part @ part desc1 desc2 xmpt_site @ site with frame a .
                    disp xmpt_kb_rolume xmpt_box_type xmpt_type xmpt_ship_type xmpt_lot_qty xmpt_b_op xmpt_a_op 
                         xmpt_wkctr xmpt_op xmpt_loc xmpt_line_loc xmpt_demand_day xmpt_rel_day xmpt_set_up xmpt_epei 
                         xmpt_kb_number xmpt_kb_avail xmpt_kb_suggest xmpt_kb_fqty xmpt_kb_min xmpt_me_int 
                         xmpt_me_qty xmpt_safety_facter   xmpt_comb xmpt_qty_firm with frame b .
             end . /* if recno <> ? then  do: */

         end.
         else  if frame-field = "site" then do:
             /* FIND NEXT/PREVIOUS RECORD */
             {mfnp01.i xmpt_mstr  site xmpt_site  part  "xmpt_domain = global_domain and xmpt_part " xmpt_pt_site}

             if recno <> ? then do:
                    find pt_mstr where pt_domain = global_domain and pt_part = xmpt_part no-lock no-error .
                    desc1 = if avail pt_mstr then pt_desc1 else "" .
                    desc2 = if avail pt_mstr then pt_desc2 else "" .
                    display xmpt_part @ part desc1 desc2 xmpt_site @ site with frame a .
                    disp xmpt_kb_rolume xmpt_box_type xmpt_type xmpt_ship_type xmpt_lot_qty xmpt_b_op xmpt_a_op 
                         xmpt_wkctr xmpt_op xmpt_loc xmpt_line_loc xmpt_demand_day xmpt_rel_day xmpt_set_up xmpt_epei 
                         xmpt_kb_number xmpt_kb_avail xmpt_kb_suggest xmpt_kb_fqty xmpt_kb_min xmpt_me_int xmpt_me_qty  
                         xmpt_safety_facter   xmpt_comb xmpt_qty_firm with frame b .
             end . /* if recno <> ? then  do: */
         end.
         else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end.
    end. /* PROMPT-FOR...EDITING */
    assign part site .

    find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = input site) no-lock no-error .
    if not avail xkbc_ctrl then do:
        find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = "" ) no-lock no-error .
        if not avail xkbc_ctrl then do:
            /* {pxmsg.i &MSGNUM=???? &ERRORLEVEL=3} */
            message "看板模块没有开启" view-as alert-box .
            undo mainloop , retry mainloop .
        end.
    end.

    find first pt_mstr where pt_domain = global_domain and pt_part = input part and ( pt_pm_code = "m" or pt_pm_code = "" or pt_pm_code = "L" ) no-lock no-error.
    if not avail pt_mstr  then do :
        /* {pxmsg.i &MSGNUM=???? &ERRORLEVEL=3} */
        message "料件不存在或者非制造零件" view-as alert-box .
        undo mainloop, retry mainloop.
    end.
    
    if input site <> "" and ( not can-find(si_mstr where si_domain = global_domain and si_site = input site ) ) then do:
        /* {pxmsg.i &MSGNUM=???? &ERRORLEVEL=3} */
        message "地点不存在" view-as alert-box .
        undo mainloop, retry mainloop.
    end.
    

    find pt_mstr where pt_domain = global_domain and pt_part = part no-lock no-error .
    desc1 = if avail pt_mstr then pt_desc1 else "" .
    desc2 = if avail pt_mstr then pt_desc2 else "" .
    find xmpt_mstr where xmpt_domain = global_domain and xmpt_part = part and xmpt_site = site no-lock no-error .  
    recno = if avail xmpt_mstr then recid(xmpt_mstr) else ? .
    if avail xmpt_mstr then display part desc1 desc2 xmpt_site @ site with frame a . 
    else disp part desc1 desc2 site with frame a .

    setloop:
    do on error undo ,retry :
        find  xmpt_mstr where  recid(xmpt_mstr) = recno exclusive-lock no-error .
        if not avail xmpt_mstr then do :
                {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} 
                create xmpt_mstr .
                assign xmpt_domain  = global_domain 
                       xmpt_part = input part
                       xmpt_site = input site 
                       xmpt_safety_facter = 1 
                       xmpt_epei = 1.

                find first ptp_det where ptp_domain = global_domain and ptp_site = input site and ptp_part = input part no-lock no-error .
                if avail ptp_det  then do:
                    xmpt_kb_rolume = ptp_ord_min .
                    xmpt_me_qty = ptp_ord_mult .
                end.
                else do:
                    find first pt_mstr where pt_domain = global_domain and pt_part = input part no-lock no-error .
                    if avail pt_mstr  then do:
                        xmpt_kb_rolume = pt_ord_min .
                        xmpt_me_qty = pt_ord_mult .                        
                    end.
                    else do:
                        xmpt_kb_rolume = 1 .
                        xmpt_me_qty = 1 .
                    end.

                end.

                find first ro_det where ro_det.ro_domain = global_domain and (  ro_routing = xmpt_part 
                            and (ro_start = ? or ro_start <= today ) and (ro_end   = ? or ro_end >= today )) no-lock  no-error .
                assign xmpt_set_up = if avail ro_det then ro_setup else 0 .
        end.
        disp xmpt_kb_rolume xmpt_box_type xmpt_type xmpt_ship_type xmpt_lot_qty xmpt_b_op xmpt_a_op 
             xmpt_wkctr xmpt_op xmpt_loc xmpt_line_loc xmpt_demand_day xmpt_rel_day xmpt_set_up xmpt_epei 
             xmpt_kb_number xmpt_kb_avail xmpt_kb_suggest xmpt_kb_fqty xmpt_kb_min xmpt_me_int xmpt_me_qty  
             xmpt_safety_facter   xmpt_comb xmpt_qty_firm with frame b .


        update xmpt_kb_rolume xmpt_box_type xmpt_type xmpt_ship_type xmpt_b_op xmpt_a_op 
               xmpt_wkctr xmpt_op xmpt_loc xmpt_line_loc xmpt_demand_day xmpt_rel_day xmpt_set_up xmpt_epei 
               /* xmpt_kb_number xmpt_kb_avail */ xmpt_kb_suggest xmpt_kb_fqty xmpt_kb_min xmpt_me_int xmpt_me_qty  
               xmpt_safety_facter   xmpt_comb xmpt_qty_firm
        go-on ("F5" "CTRL-D") with frame b editing :
                readkey.
                if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                    /* {pxmsg.i &MSGNUM     = 11 &ERRORLEVEL = {&INFORMATION-RESULT}  &CONFIRM = del-yn } */  
                    message "确认删除?" view-as alert-box question buttons yes-no title "" update choice as logical.
                    if choice then do :

                        find first xkb_mstr where xkb_domain = global_domain and ( xmpt_site = "" or ( xmpt_site <> "" and xkb_site = xmpt_site ) ) and xkb_type = "m" and xkb_part = xmpt_part no-lock no-error.
                        if not avail xkb_mstr  then do:
                            delete xmpt_mstr .
                            next mainloop .
                        end.
                        else do:
                            message "存在看板记录,不允许删除" view-as alert-box .
                            undo setloop,retry setloop .
                        end.

                    end.
                end. /*   "F5" "CTRL-D" */
                else apply lastkey.
        end. /* update ...EDITING */
        if xmpt_ship_type = no then update xmpt_lot_qty with frame b. 
    end. /*  setloop: */

end.   /*  mainloop: */

status input.
