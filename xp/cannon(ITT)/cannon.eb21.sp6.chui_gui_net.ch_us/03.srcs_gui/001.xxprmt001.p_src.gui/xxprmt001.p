/*xxprmt001.p 物料号的请购限额维护*/

/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090831.1  Created By: Roger Xiao */ 


/*----rev description---------------------------------------------------------------------------------*/

/* SS - 090831.1 - RNB
SS - 090831.1 - RNE */


{mfdtitle.i "090831.1"}

/* Variable added to perform delete during CIM.
 * Record is deleted only when the value of this variable
 * Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo. /*v_start ,v_qty处至此batchdelete, vend处不支持,因为要求100%才可退出*/


define var del-yn   like mfc_logical initial yes.
define var part     like pt_part no-undo.
define var v_start  as date no-undo.
define var v_expire as date .
define var v_qty    as decimal format "->>,>>>,>>>,>>9.99<<<".
define var v_i      as integer .
define var new_qt   like mfc_logical initial No .
define var v_vend   like po_vend.
define var v_pct    like xxqtd_pct .
define var cmts   as char format "x(66)" extent 10.


define var vv_user as char format "x(12)" .   /*for xxlock.i*/
define var vv_recid as integer .              /*for xxlock.i*/


define temp-table temp1 
    field t1_qty   as decimal format "->>,>>>,>>>,>>9.99<<<"
    field t1_line  as integer format ">>9" label "old_line"
    field t1_line2 as integer format ">>9" label "new_line"
    index t1_qty   is unique primary t1_qty ascending 
    .

define temp-table temp2 
    field t2_line  as integer format ">>9" label "old_line" 
    field t2_line2 as integer format ">>9" label "new_line" 
    field t2_qty   as decimal format "->>,>>>,>>>,>>9.99<<<"
    field t2_vend  like po_vend 
    field t2_pct   as integer format ">>9"
    index t2_qty  is unique primary t2_qty ascending t2_vend ascending
    .

/*GUI preprocessor Frame A define*/ 
&SCOPED-DEFINE PP_FRAME_NAME A

form
    RECT-FRAME       AT ROW 1 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
    SKIP(.1)  /*GUI*/

    part                      colon 18 
    pt_desc1                  colon 52
    pt_um                     colon 18
    pt_desc2                  colon 52 no-label
    v_start                   colon 18
    v_expire                  colon 52

    skip(.2) /*GUI*/
with frame a  side-labels width 80 attr-space 
NO-BOX THREE-D /*GUI*/.

DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
RECT-FRAME-LABEL:HIDDEN in frame a = yes.
RECT-FRAME:HEIGHT-PIXELS in frame a =
FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/


/*GUI preprocessor Frame A undefine*/ 
&UNDEFINE PP_FRAME_NAME

setFrameLabels(frame a:handle).


form
    RECT-FRAME       AT ROW 1 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
    SKIP(.1)  /*GUI*/

    cmts[01]  colon 10    
    cmts[02]  colon 10    
    cmts[03]  colon 10    
    cmts[04]  colon 10    
    cmts[05]  colon 10    
    cmts[06]  colon 10    
    cmts[07]  colon 10    
    cmts[08]  colon 10    
    cmts[09]  colon 10    
    cmts[10]  colon 10    
    skip(.4) /*GUI*/
with frame b side-labels width 80 attr-space     NO-BOX THREE-D  /*GUI*/.

DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
RECT-FRAME-LABEL:HIDDEN in frame b = yes.
RECT-FRAME:HEIGHT-PIXELS in frame b =
frame b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
RECT-FRAME:WIDTH-CHARS IN frame b = frame b:WIDTH-CHARS - .5.  /*GUI*/

setFrameLabels(frame b:handle).


form
    RECT-FRAME       AT ROW 1 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
    SKIP(.1)  /*GUI*/

    v_qty                     colon 10

    skip(.2) /*GUI*/
with frame c side-labels width 80 attr-space   NO-BOX THREE-D  /*GUI*/.

DEFINE VARIABLE F-c-title AS CHARACTER INITIAL "".
RECT-FRAME-LABEL:SCREEN-VALUE in frame c = F-c-title.
RECT-FRAME-LABEL:HIDDEN in frame c = yes.
RECT-FRAME:HEIGHT-PIXELS in frame c =
frame c:HEIGHT-PIXELS - RECT-FRAME:Y in frame c - 2.
RECT-FRAME:WIDTH-CHARS IN frame c = frame c:WIDTH-CHARS - .5.  /*GUI*/
         
setFrameLabels(frame c:handle).


form 
    RECT-FRAME       AT ROW 1 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
    SKIP(.1)  /*GUI*/

    v_vend    colon 10  ad_name   no-label 
    v_pct     colon 10

    skip(.4) /*GUI*/
with frame d side-labels overlay ROW 15 centered width 60   NO-BOX THREE-D  /*GUI*/.

DEFINE VARIABLE F-d-title AS CHARACTER INITIAL "".
RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.
RECT-FRAME-LABEL:HIDDEN in frame d = yes.
RECT-FRAME:HEIGHT-PIXELS in frame d =
frame d:HEIGHT-PIXELS - RECT-FRAME:Y in frame d - 2.
RECT-FRAME:WIDTH-CHARS IN frame d = frame d:WIDTH-CHARS - .5.  /*GUI*/

setFrameLabels(frame d:handle).

view frame a.
view frame b.
view frame c.
clear frame a no-pause .
    v_start   = ?  . 

mainloop:
repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.
    clear frame b no-pause .
    clear frame c no-pause .
    clear frame d no-pause .

    ststatus = stline[1].
    status input ststatus.

    v_expire  = ?  .
    v_qty     = 0  .
    cmts    = "" .
    
    batchdelete = "". 
    
    for each temp1 : delete temp1 .  end .
    for each temp2 : delete temp2 .  end .

    update part v_start 
           batchdelete no-label when (batchrun)
    with frame a editing:
         if frame-field = "part" then do:
             {mfnp.i xxqt_mstr part xxqt_part part "xxqt_domain = global_domain and xxqt_part"  xxqt_part}
             if recno <> ? then do:
                    find first pt_mstr where pt_domain = global_domain and pt_part = xxqt_part no-lock no-error .
                    if avail pt_mstr then display pt_part @ part pt_desc1 pt_desc2 pt_um with frame a .

                    display 
                        xxqt_start  @ v_start 
                        xxqt_expire @ v_expire
                    with frame a .
                    clear frame b no-pause.
                    v_i = 0 .
                    do v_i = 1 to 10  :
                        if xxqt_qty[v_i] <> 0 then do:
                            cmts[v_i] = trim(string(xxqt_qty[v_i])) + ": ".
                            for each xxqtd_Det 
                                    where xxqtd_domain = global_domain 
                                    and xxqtd_part = xxqt_part 
                                    and xxqtd_start = xxqt_start 
                                    and xxqtd_period = v_i 
                                no-lock  break by xxqtd_pct desc :
                                cmts[v_i] = cmts[v_i] + xxqtd_vend + "-" + string(xxqtd_pct) + "%;" .
                            end.
                            disp cmts[v_i] with frame b .
                        end.
                    end.                        

             end . /* if recno <> ? then  do: */

         end.
         else if frame-field = "v_start" then do:
                 {mfnp01.i xxqt_mstr v_start xxqt_start "input part" "xxqt_domain = global_domain and xxqt_part "  xxqt_part}
                 if recno <> ? then do:
                        display 
                            xxqt_start  @ v_start 
                            xxqt_expire @ v_expire
                        with frame a .
                        clear frame b no-pause.
                        v_i = 0 .
                        do v_i = 1 to 10  :
                            if xxqt_qty[v_i] <> 0 then do:
                                cmts[v_i] = trim(string(xxqt_qty[v_i])) + ": ".
                                for each xxqtd_Det 
                                        where xxqtd_domain = global_domain 
                                        and xxqtd_part = xxqt_part 
                                        and xxqtd_start = xxqt_start 
                                        and xxqtd_period = v_i 
                                    no-lock  break by xxqtd_pct desc :
                                    cmts[v_i] = cmts[v_i] + xxqtd_vend + "-" + string(xxqtd_pct) + "%;" .
                                end.
                                disp cmts[v_i] with frame b .
                            end.
                        end.                        
                 end . /* if recno <> ? then  do: */

         end.
         else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end.
    end. /*update...EDITING */
    assign part v_start.


        find first pt_mstr where pt_domain = global_domain and pt_part = part no-lock no-error .
        if not avail pt_mstr then do:
            {mfmsg.i 16 3}
            next-prompt part .
            undo, retry .
        end.
        disp pt_part @ part pt_desc1 pt_desc2 pt_um with frame a .


        clear frame b no-pause.

        if v_start = ? then do:
            {mfmsg.i 2930 1} /*必须指定生效日期*/
            next-prompt v_start .
            undo,retry .
        end.

        find first xxqt_mstr 
            where xxqt_domain = global_domain 
            and xxqt_part   = part
            and xxqt_start  = v_start 
        no-lock no-error .
        if not avail xxqt_mstr then do:

            /*新生效日期大于任意一笔失效日期(空失效日期的不管)*/
            find last xxqt_mstr 
                where xxqt_domain = global_domain 
                and xxqt_part     = part
                and xxqt_expire  >= v_start 
            no-lock no-error .
            if avail xxqt_mstr then do:
                if global_user_lang = "CH" then message "生效日期应大于日期:" xxqt_expire.
                if global_user_lang = "US" then message "Effective Date must be greater than" xxqt_expire.
                next-prompt v_start .
                undo,retry .
            end.

            /*新生效日期大于任意一笔生效日期*/
            find last xxqt_mstr 
                where xxqt_domain = global_domain 
                and xxqt_part     = part
                and xxqt_start   >= v_start 
            no-lock no-error .
            if avail xxqt_mstr then do:
                if global_user_lang = "CH" then message "生效日期应大于日期," xxqt_start.
                if global_user_lang = "US" then message "Effective Date must be greater than" xxqt_start.
                next-prompt v_start .
                undo,retry .
            end.


            {mfmsg.i 1 1}
            create xxqt_mstr.
            assign 
                   xxqt_domain = global_domain 
                   xxqt_part   = part 
                   xxqt_start  = v_start 
                   new_qt      = yes 
                   v_expire    = ? 
                   .
        end.
        else do:
            {mfmsg.i 10 1} /*修改存在的记录*/
            new_qt    = no.
            v_expire  = xxqt_expire .
            v_qty     = xxqt_qty[1] .
            
            v_i = 0 .
            do v_i = 1 to 10 :
                if xxqt_qty[v_i] <> 0 then do:
                        create temp1 .
                        assign t1_line = v_i 
                               t1_qty  = xxqt_qty[v_i]
                               .
                end.
            end.

        end.



        display 
            xxqt_start  @ v_start 
            xxqt_expire @ v_expire
        with frame a .
        v_i = 0 .
        do v_i = 1 to 10  :
            if xxqt_qty[v_i] <> 0 then do:
                cmts[v_i] = trim(string(xxqt_qty[v_i])) + ": ".
                for each xxqtd_Det 
                        where xxqtd_domain = global_domain 
                        and xxqtd_part = xxqt_part 
                        and xxqtd_start = xxqt_start 
                        and xxqtd_period = v_i 
                    no-lock  break by xxqtd_pct desc :
                    cmts[v_i] = cmts[v_i] + xxqtd_vend + "-" + string(xxqtd_pct) + "%;" .
                end.
                disp cmts[v_i] with frame b .
           end.
        end.      


        {xxlock01.i  
            &file-name      = xxqt_mstr use-index xxqt_part 
            &group-criteria = "xxqt_domain = global_domain and xxqt_part = part and xxqt_start = v_start "
            &undo-block     = "mainloop"
            &retry          = "retry mainloop"
        } 

        {xxlock01.i  
            &file-name      = xxqtd_det use-index xxqtd_part 
            &group-criteria = "xxqtd_domain = global_domain and xxqtd_part = part and xxqtd_start = v_start"
            &undo-block     = "mainloop"
            &retry          = "retry mainloop"
        } 


        for each xxqtd_det where xxqtd_domain = global_domain and xxqtd_part = part and xxqtd_start = v_start :
            create temp2 .
            assign t2_line = xxqtd_period 
                   t2_vend = xxqtd_vend 
                   t2_pct  = xxqtd_pct 
                   t2_qty  = xxqt_qty[xxqtd_period]
                   .
        end.

        ststatus = stline[2].
        status input ststatus.

        expiredate:
        do on error undo, retry :
            /*GUI*/ if global-beam-me-up then undo, leave.
            update v_expire 
            go-on ("F5" "CTRL-D")
            with frame a editing:
                readkey.
                if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") or input batchdelete = "x":U) then do:
                    hide message no-pause.
                    {mfmsg01.i 11 1 del-yn }
                    if del-yn then do:
                        find first xxqt_mstr where xxqt_domain = global_domain and xxqt_part = part and xxqt_start = v_start  exclusive-lock no-error.

                        for each xxqtd_det where xxqtd_domain = global_domain and xxqtd_part = xxqt_part and xxqtd_start = xxqt_start  :
                            delete xxqtd_det .
                        end.
                        delete xxqt_mstr .
                        next mainloop.
                    end.
                end.
                else apply lastkey.
            end.

            if v_expire <> ? and v_expire < v_start then do:
                {mfmsg.i 4 1} 
                undo,retry .
            end.
            
            assign xxqt_expire = v_expire .

        end. /*expiredate:*/

        /*-----------------以下维护只针对临时表temp1,temp2,----------------------------------*/

        detloop: /*数量区间维护*/
        repeat:
            qtyloop:
            do on error undo, retry :

                ststatus = stline[2].
                status input ststatus.                

                update v_qty 
                       batchdelete no-label when (batchrun)
                go-on ("F5" "CTRL-D")
                with frame c editing :
                    readkey.
                    if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") or input batchdelete = "x":U) then do:
                        find first temp1 where t1_qty = input v_qty no-error.
                        if not avail temp1 then do:
                            if global_user_lang = "CH" then message "错误:记录不存在,无法删除" .
                            if global_user_lang = "US" then message "Error: Records does not exist,Cannot delete." .
                            undo,retry .
                        end.
                        else do:
                            hide message no-pause.
                            {mfmsg01.i 11 1 del-yn }
                            if del-yn then do:
                                for each temp2 where t2_qty = t1_qty : delete temp2. end.                                
                                delete temp1 .

                                clear frame b no-pause.
                                clear frame c no-pause.
                                v_qty = 0 .
                                
                                v_i = 0 .
                                for each temp1 break by t1_qty :
                                    v_i      = v_i + 1 .
                                    t1_line2 = v_i .
                                end.
                                for each temp1 break by t1_qty :
                                    for each temp2 where t2_qty = t1_qty :
                                        t2_line2 = t1_line2.
                                    end.                                    
                                end.
    

                                v_i = 0 .
                                do v_i = 1 to 10:
                                    find first temp1 where t1_line2 = v_i no-lock no-error .
                                    if avail temp1 then do:
                                        cmts[v_i] = string(t1_qty) + ": " .
                                        for each temp2 where t2_qty = t1_qty  break by t2_pct desc:
                                            cmts[v_i] = cmts[v_i] + t2_vend + "-" + string(t2_pct) + "%;" .
                                        end.
                                        disp cmts[v_i] with frame b .
                                    end.
                                end.
                                leave qtyloop.
                            end.
                        end.
                    end. /*delete*/
                    else do:
                         {xxmfnp.i temp1 v_qty t1_qty v_qty t1_qty t1_qty}
                         if recno <> ? then do:
                                display 
                                    t1_qty @ v_qty 
                                with frame c .
                         end . /* if recno <> ? then  do: */
                    end.
                end. /*update*/

                if v_qty = 0 then do:
                    /*{mfmsg.i 317 3}
                    undo,retry .*/
                    v_qty = 99999999999.
                    disp v_qty with frame c .
                end.
                if v_qty < 0 then do:
                    {mfmsg.i 5619 3}
                    undo,retry .
                end.

                find first temp1 where t1_qty = v_qty no-lock no-error .
                if not avail temp1 then do:
                    v_i = 0 .
                    for each temp1 break by t1_qty :
                        v_i      = v_i + 1 .
                    end.
                    if v_i >= 10 then do:
                        {mfmsg.i 1783 3 }
                        undo,retry .
                    end.
                    else do:
                        create temp1 .
                        assign t1_qty = v_qty .
                    end.
                end. /*if not avail temp1*/

                v_i = 0 .
                for each temp1 break by t1_qty :
                    v_i      = v_i + 1 .
                    t1_line2 = v_i .
                end.
                for each temp1 break by t1_qty :
                    for each temp2 where t2_qty = t1_qty :
                        t2_line2 = t1_line2.
                    end.                                    
                end.

              
                pause 0 .
                clear frame d no-pause .
                view frame d .
                vendloop:
                repeat:
                        repeat :
                            update v_vend 
                            with frame d editing :
                                    /*{mfnp.i vd_mstr v_vend "vd_domain = global_domain and vd_addr" v_vend vd_addr vd_addr}
                                    if recno <> ? then do:
                                        find first ad_mstr where ad_domain = global_domain and ad_addr = vd_addr no-lock no-error.
                                        if avail ad_mstr then display ad_addr @ v_vend ad_name with frame d .
                                        find first temp2 where t2_qty = v_qty and t2_vend = vd_addr no-lock no-error.
                                        if avail temp2 then disp t2_pct @ v_pct with frame d .
                                        else disp "" @ v_pct with frame d . 
                                    end . */
                                    {mfnp01.i temp2 v_vend t2_vend v_qty t2_qty t2_qty}
                                    if recno <> ? then do:
                                        find first ad_mstr where ad_domain = global_domain and ad_addr = t2_vend no-lock no-error.
                                        if avail ad_mstr then display ad_addr @ v_vend ad_name  t2_pct @ v_pct with frame d .
                                        else disp "" @ v_pct with frame d . 
                                    end . 
                            end. /*update v_vend*/

                            find first vd_mstr where vd_domain = global_domain and vd_addr = v_vend no-lock no-error.
                            if not avail vd_mstr then do:
                                {mfmsg.i 2 3}
                                undo,retry.
                            end.
                            find first ad_mstr where ad_domain = global_domain and ad_addr = vd_addr no-lock no-error.
                            if avail ad_mstr then display v_vend ad_name with frame d .

                            find first temp2 where t2_qty = v_qty and t2_vend = v_vend no-error.
                            if not avail temp2 then do:
                                create temp2 .
                                assign t2_qty  = v_qty 
                                       t2_vend = v_vend 
                                       v_pct   = 0 
                                       .
                            end.
                            else do:
                                v_pct = t2_pct .
                            end.

                            ststatus = stline[2].
                            status input ststatus.                
                            
                            do on error undo ,retry:
                                update v_pct go-on ("F5" "CTRL-D")
                                with frame d editing :
                                    readkey.
                                    if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D")) then do:
                                        hide message no-pause.
                                        {mfmsg01.i 11 1 del-yn }
                                        if del-yn then do:
                                            find first temp2 where t2_qty = v_qty and t2_vend = v_vend no-error.
                                            if avail temp2 then do:
                                                delete temp2.
                                                clear frame d no-pause.
                                                next vendloop.
                                            end.
                                        end.
                                    end.
                                    else apply lastkey.
                                end. /*update v_vend*/


                                if v_pct = 0 then do:
                                    {mfmsg.i 317 3}
                                    undo,retry .
                                end.

                                if v_pct < 0 then do:
                                    {mfmsg.i 5619 3}
                                    undo,retry .
                                end.

                                v_i = 0 .
                                for each temp2 where t2_qty = v_qty and t2_vend <> v_vend :
                                    v_i = v_i + t2_pct .
                                end.

                                /*if v_i + v_pct > 100 then do:
                                    message "区间累计不可超过一百" .
                                    undo,retry.
                                end.*/

                                find first temp2 where t2_qty = v_qty and t2_vend = v_vend no-error.
                                assign t2_pct = v_pct . 
                                if global_user_lang = "CH" then message "已累计分配:" v_i + v_pct "%" .
                                if global_user_lang = "US" then message "Accumulative total:" v_i + v_pct "%" .

                                /*if v_i + v_pct = 100 then leave vendloop. */

                            end.
                        end. /*repeat*/
                        v_i = 0 .
                        for each temp2 where t2_qty = v_qty :
                            v_i = v_i + t2_pct .
                        end.
                        if v_i <> 100 then do:
                                 if global_user_lang = "CH" then message  "区间累计不等于100%" .
                                 if global_user_lang = "US" then message  "Accumulative total not equal 100%" .
                        end.
                        else leave vendloop.

                end. /*vendloop:*/
                hide frame d no-pause.
                v_pct  = 0 .
                v_vend = "" .

                v_i = 0 .
                for each temp1 break by t1_qty :
                    v_i      = v_i + 1 .
                    t1_line2 = v_i .
                end.
                for each temp1 break by t1_qty :
                    for each temp2 where t2_qty = t1_qty :
                        t2_line2 = t1_line2.
                    end.                                    
                end.

                v_i = 0 .
                do v_i = 1 to 10:
                    find first temp1 where t1_line2 = v_i no-lock no-error .
                    if avail temp1 then do:
                        cmts[v_i] = string(t1_qty) + ": " .
                        for each temp2 where t2_qty = t1_qty break by t2_pct desc :
                            cmts[v_i] = cmts[v_i] + t2_vend + "-" + string(t2_pct) + "%;" .
                        end.
                        disp cmts[v_i] with frame b .
                    end.
                end.

            end. /*qtyloop*/            
        end. /*detloop: 数量区间维护*/

        /*----------------以下部分:在退出时,由临时表写入到db表-------------------------------------------------------*/
        v_i = 0 .
        for each temp1 break by t1_qty :
            v_i      = v_i + 1 .
            t1_line2 = v_i .
        end.
        for each temp1 break by t1_qty :
            for each temp2 where t2_qty = t1_qty :
                t2_line2 = t1_line2.
            end.                                    
        end.

        find first temp1 no-error.
        if not avail temp1 then do:
            for each temp2 : delete temp2 . end.
            for each xxqtd_det where xxqtd_domain = global_domain and xxqtd_part = part and xxqtd_start = v_start exclusive-lock:
                delete xxqtd_det .
            end.
            for each xxqt_mstr where xxqt_domain = global_domain and xxqt_part = part and xxqt_start = v_start exclusive-lock:
                delete xxqt_mstr .
            end.
        end. /*临时表删除,则db删除*/

        /*不管是否修改,删掉db表*/
        for each xxqtd_det where xxqtd_domain = global_domain and xxqtd_part = part and xxqtd_start = v_start exclusive-lock:
            delete xxqtd_det .
        end.

        /*重新照临时表新增回去*/
        find first xxqt_mstr where xxqt_domain = global_domain and xxqt_part = part and xxqt_start = v_start exclusive-lock no-error.
        if avail xxqt_mstr then do:
            v_i = 0.
            do v_i = 1 to 10 :
                find first temp1 where t1_line2 = v_i no-lock no-error.
                xxqt_qty[v_i] = if avail temp1 then t1_qty else 0 . 
            end.
            for each temp2 :
                create xxqtd_det .
                assign xxqtd_domain = global_domain 
                       xxqtd_part   = part
                       xxqtd_start  = v_start 
                       xxqtd_period = t2_line2
                       xxqtd_vend   = t2_vend
                       xxqtd_pct    = t2_pct 
                       .
            end.
        end. /*if avail xxqt_mstr*/

end.   /*  mainloop: */

status input.



