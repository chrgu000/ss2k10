/* xxkbvmmt.p - kb part vender MAINTENANCE                                     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */

define var vend   like vd_addr .
define var vdname like ad_name .
define var part  like xmpt_part .
define var desc1 like pt_desc1.
define var desc2 like pt_desc2 .

define var site  like xmpt_site .
define var del-yn  like mfc_logical initial yes.
define var i as integer .

define  frame a.

/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
    vend                     colon 15 space (20)
    vdname                            no-label
    part                     colon 15 label "零件号"
    desc1                    colon 52 
    desc2                    colon 52 no-label 
    xvm_safe_ldtime          colon 15 label "安全时数"
    xvm_rls_ld               colon 15 label "下达提前期"
    skip(.5)
  "交货方式           交货时间段     交货方式         交货时间段" colon 9
    xvm_type[1]              colon 15 no-label format "x(2)"
    xvm_deli_time[1]         colon 30 no-label format "x(8)"
    xvm_type[13]              colon 49 no-label format "x(2)"
    xvm_deli_time[13]         colon 62 no-label format "x(8)"
    xvm_type[2]              colon 15 no-label format "x(2)"
    xvm_deli_time[2]         colon 30 no-label format "x(8)"
    xvm_type[14]              colon 49 no-label format "x(2)"
    xvm_deli_time[14]         colon 62 no-label format "x(8)"
    xvm_type[3]              colon 15 no-label format "x(2)"
    xvm_deli_time[3]         colon 30 no-label format "x(8)"
    xvm_type[15]              colon 49 no-label format "x(2)"
    xvm_deli_time[15]         colon 62 no-label format "x(8)"
    xvm_type[4]              colon 15 no-label format "x(2)"
    xvm_deli_time[4]         colon 30 no-label format "x(8)"
    xvm_type[16]              colon 49 no-label format "x(2)"
    xvm_deli_time[16]         colon 62 no-label format "x(8)"
    xvm_type[5]              colon 15 no-label format "x(2)"
    xvm_deli_time[5]         colon 30 no-label format "x(8)"
    xvm_type[17]              colon 49 no-label format "x(2)"
    xvm_deli_time[17]         colon 62 no-label format "x(8)"
    
    xvm_type[6]              colon 15 no-label format "x(2)"
    xvm_deli_time[6]         colon 30 no-label format "x(8)"
    xvm_type[18]              colon 49 no-label format "x(2)"
    xvm_deli_time[18]         colon 62 no-label format "x(8)"
    xvm_type[7]              colon 15 no-label format "x(2)"
    xvm_deli_time[7]         colon 30 no-label format "x(8)"
    xvm_type[19]              colon 49 no-label format "x(2)"
    xvm_deli_time[19]         colon 62 no-label format "x(8)"
    xvm_type[8]              colon 15 no-label format "x(2)"
    xvm_deli_time[8]         colon 30 no-label format "x(8)"
    xvm_type[20]              colon 49 no-label format "x(2)"
    xvm_deli_time[20]         colon 62 no-label format "x(8)"
    xvm_type[9]              colon 15 no-label format "x(2)"
    xvm_deli_time[9]         colon 30 no-label format "x(8)"
    xvm_type[21]              colon 49 no-label format "x(2)"
    xvm_deli_time[21]         colon 62 no-label format "x(8)"
    xvm_type[10]              colon 15 no-label format "x(2)"
    xvm_deli_time[10]         colon 30 no-label format "x(8)"
    xvm_type[22]              colon 49 no-label format "x(2)"
    xvm_deli_time[22]         colon 62 no-label format "x(8)"
    
    xvm_type[11]              colon 15 no-label format "x(2)"
    xvm_deli_time[11]         colon 30 no-label format "x(8)"
    xvm_type[23]              colon 49 no-label format "x(2)"
    xvm_deli_time[23]         colon 62 no-label format "x(8)"
    xvm_type[12]              colon 15 no-label format "x(2)"
    xvm_deli_time[12]         colon 30 no-label format "x(8)"
    xvm_type[24]              colon 49 no-label format "x(2)"
    xvm_deli_time[24]         colon 62 no-label format "x(8)"
  

with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:
    clear frame a no-pause .

    find icc_ctrl where icc_domain = global_domain no-lock no-error.
    site = if avail icc_ctrl then icc_site else global_site .

    find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = site) no-lock no-error .
    if not avail xkbc_ctrl then do:
        find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = "" ) no-lock no-error .
        if not avail xkbc_ctrl then do:
            /* {pxmsg.i &MSGNUM=???? &ERRORLEVEL=3} */
            message "看板模块没有开启" view-as alert-box .
            undo mainloop , retry mainloop .
        end.
    end.

    ststatus = stline[1].
    status input ststatus.

    prompt-for vend  part with frame a editing:
        if frame-field = "vend" then do:
             /* FIND NEXT/PREVIOUS RECORD */
             {mfnp.i xvm_mstr vend  "xvm_domain = global_domain and xvm_vend "  vend xvm_vend xvm_vend }

             if recno <> ? then do:
                    find ad_mstr where ad_domain = global_domain and ad_addr = xvm_vend no-lock no-error .
                    vdname = if avail ad_mstr then ad_name else "" .
                    find pt_mstr where pt_domain = global_domain and pt_part = xvm_part no-lock no-error .
                    desc1 = if avail pt_mstr then pt_desc1 else "" .
                    desc2 = if avail pt_mstr then pt_desc2 else "" .
                    part =  xvm_part .
                    vend = xvm_vend .
                    display vend vdname part desc1 desc2 xvm_type xvm_deli_time xvm_safe_ldtime  xvm_rls_ld   with frame a .
             end . /* if recno <> ? then  do: */
        end.
        else if frame-field = "part"  then do:
             /* FIND NEXT/PREVIOUS RECORD */
             {mfnp.i xvm_mstr part  "xvm_domain = global_domain and xvm_part "  vend xvm_vend xvm_vend }

             if recno <> ? then do:
                    find ad_mstr where ad_domain = global_domain and ad_addr = input vend no-lock no-error .
                    vdname = if avail ad_mstr then ad_name else "" .
                    find pt_mstr where pt_domain = global_domain and pt_part = xvm_part no-lock no-error .
                    desc1 = if avail pt_mstr then pt_desc1 else "" .
                    desc2 = if avail pt_mstr then pt_desc2 else "" .
                    part = xvm_part .
                    display vend vdname  part desc1 desc2 xvm_type xvm_deli_time xvm_safe_ldtime  xvm_rls_ld   with frame a .
             end . /* if recno <> ? then  do: */
        end.
        else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
        end.

    end. /* PROMPT-FOR...EDITING */
    assign vend part .


    find first vd_mstr where vd_domain = global_domain and vd_addr = vend no-lock no-error.
    if not avail vd_mstr  then do :
        /* {pxmsg.i &MSGNUM=???? &ERRORLEVEL=3} */
        message "供应商不存在,请重新输入" view-as alert-box .
        undo mainloop, retry mainloop.
    end.

    find ad_mstr where ad_domain = global_domain and ad_addr = vend no-lock no-error .
    vdname = if avail ad_mstr then ad_name else "" .
    display vend vdname  with frame a .
    find pt_mstr where pt_domain = global_domain and pt_part = part no-lock no-error .
    desc1 = if avail pt_mstr then pt_desc1 else "" .
    desc2 = if avail pt_mstr then pt_desc2 else "" .
    display  part desc1 desc2  with frame a . 

    find xvm_mstr where xvm_domain = global_domain and xvm_vend = vend and xvm_part = part no-lock no-error .  
    recno = if avail xvm_mstr then recid(xvm_mstr) else ? .
    if avail xvm_mstr then do: 
        display  xvm_type xvm_deli_time xvm_safe_ldtime  xvm_rls_ld  with frame a . 
    end.

    setloop:
    do on error undo ,retry :
        find  xvm_mstr where  recid(xvm_mstr) = recno exclusive-lock no-error .
        if not avail xvm_mstr then do :
                {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} 
                create xvm_mstr .
                assign xvm_domain  = global_domain 
                       xvm_vend = vend 
                       xvm_part = part .
        end.
        
        update xvm_safe_ldtime  xvm_rls_ld go-on ("F5" "CTRL-D") with frame a editing :
                readkey.
                if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                    /* {pxmsg.i &MSGNUM     = 11 &ERRORLEVEL = {&INFORMATION-RESULT}  &CONFIRM = del-yn } */  
                    message "确认删除?" view-as alert-box question buttons yes-no title "" update choice as logical.
                    if choice then do :

                        find first xkb_mstr where xkb_domain = global_domain and xkb_type = "o" and xkb_part = xvm_part no-lock no-error.
                        if not avail xkb_mstr  then do:
                            delete xvm_mstr .
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




        looptime:
        do on error undo ,retry :
            update 
                xvm_type[1] xvm_deli_time[1] 
                xvm_type[2] xvm_deli_time[2]
                xvm_type[3] xvm_deli_time[3]
                xvm_type[4] xvm_deli_time[4]
                xvm_type[5] xvm_deli_time[5]
                xvm_type[6] xvm_deli_time[6]
                xvm_type[7] xvm_deli_time[7]
                xvm_type[8] xvm_deli_time[8]
                xvm_type[9] xvm_deli_time[9]
                xvm_type[10] xvm_deli_time[10]
                xvm_type[11] xvm_deli_time[11]
                xvm_type[12] xvm_deli_time[12]
                xvm_type[13] xvm_deli_time[13]
                xvm_type[14] xvm_deli_time[14]
                xvm_type[15] xvm_deli_time[15]
                xvm_type[16] xvm_deli_time[16]
                xvm_type[17] xvm_deli_time[17]
                xvm_type[18] xvm_deli_time[18]
                xvm_type[19] xvm_deli_time[19]
                xvm_type[20] xvm_deli_time[20]
                xvm_type[21] xvm_deli_time[21]
                xvm_type[22] xvm_deli_time[22]
                xvm_type[23] xvm_deli_time[23]
                xvm_type[24] xvm_deli_time[24]
            with frame a  editing:
                        readkey .
                        apply lastkey.
            end.

            do i = 1 to 24 :                
                if  xvm_type[i] <> "" then do:
                    if xvm_deli_time[i] = "" or length(xvm_deli_time[i]) < 8  then do:
                            message "时间段固定宽度为8位,请重新输入第" +  string(i) + "项" view-as alert-box .
                            undo looptime, retry .
                    end.
                    if ( integer(substring(xvm_deli_time[i],1,2)) < 0 or integer(substring(xvm_deli_time[i],1,2)) > 24 )
                       or
                       ( integer(substring(xvm_deli_time[i],5,2)) < 0 or integer(substring(xvm_deli_time[i],5,2)) > 24 )
                       or
                       ( integer(substring(xvm_deli_time[i],3,2)) < 0 or integer(substring(xvm_deli_time[i],3,2)) > 60 )
                       or
                       ( integer(substring(xvm_deli_time[i],7,2)) < 0 or integer(substring(xvm_deli_time[i],8,2)) > 60 )   then do:
                                message "输入的时间超出范围,请重新输入第" +  string(i) + "项"  view-as alert-box .
                                undo looptime, retry .
                    end.
                    if i >= 2 then do: 
                        if xvm_deli_time[i - 1] = "" or length(xvm_deli_time[i - 1]) < 8  then do:
                                message "请先正确维护第" + string(i - 1) + "项,才可维护第" +  string(i) + "项" view-as alert-box .
                                undo looptime, retry .
                        end.
                        if ( integer(substring(xvm_deli_time[i],1,4)) <  integer(substring(xvm_deli_time[i - 1 ],5,4)) ) then do:
                                message "输入的起始时间应大于前段截止时间,请重新输入第" +  string(i) + "项" view-as alert-box .
                                undo looptime, retry .
                        end.
                    end.
                end.
            end.   /* do i = 1 to 24 */                
        end. . /*  looptime */





/*         do i = 1 to 24 :                                                                                                                 */
/*             looptime:                                                                                                                    */
/*             do on error undo ,retry :                                                                                                    */
/*                 update xvm_type[i] xvm_deli_time[i] with frame a  editing:                                                               */
/*                             readkey .                                                                                                    */
/*                             apply lastkey.                                                                                               */
/*                 end.                                                                                                                     */
/*                                                                                                                                          */
/*                 if  xvm_type[i] <> "" then do:                                                                                           */
/*                     if xvm_deli_time[i] = "" or length(xvm_deli_time[i]) < 8  then do:                                                   */
/*                             message "固定宽度为8位,请重新输入." view-as alert-box .                                                      */
/*                             undo looptime, retry .                                                                                       */
/*                     end.                                                                                                                 */
/*                     if ( integer(substring(xvm_deli_time[i],1,2)) < 0 or integer(substring(xvm_deli_time[i],1,2)) > 24 )                 */
/*                        or                                                                                                                */
/*                        ( integer(substring(xvm_deli_time[i],5,2)) < 0 or integer(substring(xvm_deli_time[i],5,2)) > 24 )                 */
/*                        or                                                                                                                */
/*                        ( integer(substring(xvm_deli_time[i],3,2)) < 0 or integer(substring(xvm_deli_time[i],3,2)) > 60 )                 */
/*                        or                                                                                                                */
/*                        ( integer(substring(xvm_deli_time[i],7,2)) < 0 or integer(substring(xvm_deli_time[i],8,2)) > 60 )   then do:      */
/*                                 message "输入的时间超出范围,请重新输入." view-as alert-box .                                             */
/*                                 undo looptime, retry .                                                                                   */
/*                     end.                                                                                                                 */
/*                     if i >= 2 and ( integer(substring(xvm_deli_time[i],1,4)) <  integer(substring(xvm_deli_time[i - 1 ],5,4)) ) then do: */
/*                                 message "输入的起始时间应大于前段截止时间,请重新输入." view-as alert-box .                               */
/*                                 undo looptime, retry .                                                                                   */
/*                     end.                                                                                                                 */
/*                 end.                                                                                                                     */
/*                                                                                                                                          */
/*             end. . /*  looptime */                                                                                                       */
/*         end.   /* do i = 1 to 24 */                                                                                                      */
    end. /*  setloop: */

end.   /*  mainloop: */

status input.
