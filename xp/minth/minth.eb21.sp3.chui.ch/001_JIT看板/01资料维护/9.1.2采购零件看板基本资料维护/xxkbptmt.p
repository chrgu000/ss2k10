/* xxkbptmt.p - pur part kb MAINTENANCE                                     */
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
    xppt_kb_rolume           colon 18 validate( input xppt_kb_rolume > 0 , "最小值为 1 ")
    xppt_box_type            colon 54 validate(can-find(code_mstr where code_domain = global_domain and  code_fldname = "xppt_box_type" and code_value = input xppt_box_type no-lock ) 
                                               or (not can-find(first code_mstr where code_domain = global_domain and  code_fldname = "xppt_box_type" no-lock ))  ,"该值必须在通用代码中存在.  请重新输入。" )
    xppt_type                colon 18 validate(can-find(code_mstr where code_domain = global_domain and  code_fldname = "xppt_type" and code_value = input xppt_type no-lock ) 
                                               or (not can-find(first code_mstr where code_domain = global_domain and  code_fldname = "xppt_box_type" no-lock ))  ,"该值必须在通用代码中存在.  请重新输入。" )
    xppt_vend                 colon 54 
    xppt_ship_type           colon 22 format "Yes-时间/No-批量"
    xppt_lot_qty             colon 54 validate( input xppt_ship_type = no and input xppt_lot_qty <> 0 ,"交货方式为批量时必须维护批量" )
    xppt_b_site              colon 18
    xppt_a_site              colon 54
    xppt_wkctr               colon 18
    xppt_op                  colon 54 validate(can-find(code_mstr where code_domain = global_domain and code_fldname = "xppt_op" and code_value = input xppt_op no-lock ) 
                                               or (not can-find(first code_mstr where  code_domain = global_domain and code_fldname = "xppt_op" no-lock ))  ,"该值必须在通用代码中存在.  请重新输入。" )
    xppt_loc                 colon 18
    xppt_line_loc            colon 54 
    xppt_lead_date           colon 18
    xppt_del_number          colon 54
    xppt_del_st              colon 18
    xppt_demand_day          colon 54
    xppt_rel_day             colon 18
    xppt_kb_number           colon 54
    xppt_kb_avail            colon 18
    xppt_kb_suggest          colon 54  
    xppt_kb_fqty             colon 18   
    xppt_kb_min              colon 54  
    xppt_epei                colon 18  
    xppt_rls_lead            colon 54
    xppt_me_qty              colon 18  validate( input xppt_me_qty > 0  , "最小值为 1 ")
    xppt_safety_facter       colon 54   validate( input  xppt_safety_facter > 0  , "最小值为 1 ")
    xppt_me_int              colon 18
    xppt_comb                colon 40 
    xppt_qty_firm            colon 65

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
             {mfnp.i xppt_mstr part  "xppt_domain = global_domain and xppt_part "  part xppt_part xppt_part}

             if recno <> ? then do:
                    find pt_mstr where pt_domain = global_domain and pt_part = xppt_part no-lock no-error .
                    desc1 = if avail pt_mstr then pt_desc1 else "" .
                    desc2 = if avail pt_mstr then pt_desc2 else "" .
                    display xppt_part @ part desc1 desc2 xppt_site @ site with frame a .
                    disp    xppt_kb_rolume  xppt_box_type  xppt_vend  xppt_type xppt_ship_type xppt_lot_qty xppt_b_site xppt_a_site xppt_wkctr xppt_op 
                            xppt_loc xppt_line_loc xppt_lead_date xppt_del_number  xppt_del_st xppt_demand_day xppt_rel_day 
                            xppt_kb_number xppt_kb_avail  xppt_kb_suggest xppt_kb_fqty xppt_kb_min   xppt_kb_fqty xppt_rls_lead  xppt_me_qty xppt_epei   
                            xppt_safety_facter xppt_me_int xppt_comb xppt_qty_firm with frame b .
             end . /* if recno <> ? then  do: */

         end.
         else  if frame-field = "site" then do:
             /* FIND NEXT/PREVIOUS RECORD */
             {mfnp01.i xppt_mstr  site xppt_site  part  "xppt_domain = global_domain and xppt_part " xppt_part}

             if recno <> ? then do:
                    find pt_mstr where pt_domain = global_domain and pt_part = xppt_part no-lock no-error .
                    desc1 = if avail pt_mstr then pt_desc1 else "" .
                    desc2 = if avail pt_mstr then pt_desc2 else "" .
                    display xppt_part @ part desc1 desc2 xppt_site @ site with frame a .
                    disp    xppt_kb_rolume  xppt_box_type  xppt_type  xppt_vend xppt_ship_type xppt_lot_qty xppt_b_site xppt_a_site xppt_wkctr xppt_op 
                            xppt_loc xppt_line_loc xppt_lead_date xppt_del_number  xppt_del_st xppt_demand_day xppt_rel_day xppt_kb_number xppt_kb_avail 
                            xppt_kb_suggest xppt_kb_fqty xppt_kb_min   xppt_kb_fqty xppt_rls_lead  xppt_me_qty  xppt_epei  
                            xppt_safety_facter xppt_me_int xppt_comb xppt_qty_firm with frame b .
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

    find first pt_mstr where pt_domain = global_domain and pt_part = input part and ( pt_pm_code = "p" or pt_pm_code = "" ) no-lock no-error.
    if not avail pt_mstr  then do :
        /* {pxmsg.i &MSGNUM=???? &ERRORLEVEL=3} */
        message "料件不存在或者非采购零件" view-as alert-box .
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
    find xppt_mstr where xppt_domain = global_domain and xppt_part = part and xppt_site = site no-lock no-error .  
    recno = if avail xppt_mstr then recid(xppt_mstr) else ? .
    if avail xppt_mstr then display part desc1 desc2 xppt_site @ site with frame a . 
    else disp part desc1 desc2 site with frame a .

    setloop:
    do on error undo ,retry :
        find  xppt_mstr where  recid(xppt_mstr) = recno exclusive-lock no-error .
        if not avail xppt_mstr then do :
                {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
                create xppt_mstr .
                assign xppt_domain  = global_domain 
                       xppt_part = input part
                       xppt_site = input site 
                       xppt_safety_facter = 1 
                       xppt_epei = 1  .

                find first ptp_det where ptp_domain = global_domain and ptp_site = input site and ptp_part = input part no-lock no-error .
                if avail ptp_det then do:
                    xppt_kb_rolume = ptp_ord_min .
                    xppt_me_qty = ptp_ord_mult .
                end.
                else do:
                    find first pt_mstr where pt_domain = global_domain and pt_part = input part no-lock no-error .
                    if avail pt_mstr  then do:
                        xppt_kb_rolume = pt_ord_min .
                        xppt_me_qty = pt_ord_mult .                        
                    end.
                    else do:
                        xppt_kb_rolume = 1 .
                        xppt_me_qty = 1 .
                    end.

                end.

                find ptp_det where ptp_domain = global_domain and ptp_site = xppt_site and ptp_part = xppt_part no-lock no-error .
                if avail ptp_det  then xppt_vend  = ptp_vend .
                else do:
                    find pt_mstr where pt_domain = global_domain and pt_part = xppt_part no-lock no-error .
                    xppt_vend  = if avail pt_mstr then pt_vend else "" .
                end.
                
        end.
        disp  xppt_kb_rolume  xppt_box_type  xppt_type  xppt_vend xppt_ship_type xppt_lot_qty xppt_b_site xppt_a_site xppt_wkctr xppt_op 
              xppt_loc xppt_line_loc xppt_lead_date xppt_del_number  xppt_del_st xppt_demand_day xppt_rel_day xppt_kb_number xppt_kb_avail  
              xppt_kb_suggest xppt_kb_fqty xppt_kb_min   xppt_kb_fqty xppt_rls_lead  xppt_me_qty xppt_epei 
              xppt_safety_facter xppt_me_int xppt_comb xppt_qty_firm with frame b .


        update xppt_kb_rolume  xppt_box_type  xppt_type  xppt_vend  xppt_ship_type xppt_b_site xppt_a_site xppt_wkctr xppt_op 
               xppt_loc xppt_line_loc xppt_lead_date xppt_del_number  xppt_del_st xppt_demand_day xppt_rel_day /*xppt_kb_number xppt_kb_avail*/ 
               xppt_kb_suggest xppt_kb_fqty xppt_kb_min   xppt_kb_fqty xppt_rls_lead  xppt_epei xppt_me_qty 
               xppt_safety_facter xppt_me_int xppt_comb xppt_qty_firm
        go-on ("F5" "CTRL-D") with frame b editing :
                readkey.
                if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                    /* {pxmsg.i &MSGNUM     = 11 &ERRORLEVEL = {&INFORMATION-RESULT}  &CONFIRM = del-yn } */  
                    message "确认删除?" view-as alert-box question buttons yes-no title "" update choice as logical.
                    if choice then do :

                        find first xkb_mstr where xkb_domain = global_domain and (xppt_site = "" or (xppt_site <> "" and xkb_site = xppt_site )) and xkb_type = "p" and xkb_part = xppt_part no-lock no-error.
                        if not avail xkb_mstr  then do:
                            delete xppt_mstr .
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
         if xppt_ship_type = no then update xppt_lot_qty with frame b. 
    end. /*  setloop: */

end.   /*  mainloop: */

status input.
