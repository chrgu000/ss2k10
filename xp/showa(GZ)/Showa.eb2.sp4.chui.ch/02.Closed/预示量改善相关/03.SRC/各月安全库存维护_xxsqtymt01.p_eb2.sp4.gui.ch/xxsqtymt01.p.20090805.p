/* xxsqtymt01.p 全年安全库存维护                */
/* REVISION: 090717.1      Create Date: 20090717  BY: Softspeed roger xiao    */
/* REVISION: 090805.1      Create Date: 20090805  BY: Softspeed roger xiao    */ /*转GUI界面，改成固定地点，加宽数量格式*/
/*-Revision end---------------------------------------------------------------*/

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/* DISPLAY TITLE */
{mfdtitle.i "090805.1"}

define var part    like xsqty_part .
define var site    like xsqty_site .
define var desc1   like pt_desc1.
define var desc2   like pt_desc2 .
define var del-yn  like mfc_logical initial yes.
define var v_i     as integer.
define var v_sqty  as decimal extent 12 no-undo format ">>>,>>>,>>>,>>9.9<<".


/*GUI preprocessor Frame A define*/ 
&SCOPED-DEFINE PP_FRAME_NAME A

form
    RECT-FRAME       AT ROW 1 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
    SKIP(.1)  /*GUI*/
    skip(.2)
    part                     colon 18 
    desc1                    colon 52
    site                     colon 18
    desc2                    colon 52 no-label
    skip(.2)
with frame a  side-labels width 80 attr-space  THREE-D /*GUI*/.

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
    skip(1)

    xsqty_date  colon 15 label "导入日期"
    v_sqty[01] colon 15 label "01月"   v_sqty[07] colon 52 label "07月" 
    v_sqty[02] colon 15 label "02月"   v_sqty[08] colon 52 label "08月" 
    v_sqty[03] colon 15 label "03月"   v_sqty[09] colon 52 label "09月" 
    v_sqty[04] colon 15 label "04月"   v_sqty[10] colon 52 label "10月" 
    v_sqty[05] colon 15 label "05月"   v_sqty[11] colon 52 label "11月" 
    v_sqty[06] colon 15 label "06月"   v_sqty[12] colon 52 label "12月" 
    skip(3)
    "备注:" colon 10
    "1.地点:留空为所有地点的安全库存,否则仅为指定地点的安全库存"  colon 10
    "2.月份:从导入日期开始滚动输入.  例:假如导入日期为2009/8/1," colon 10
    "       则08月-12月为本年的月份,01月-07月为次年的月份"  colon 10
    
with frame b  side-labels width 80 attr-space THREE-D /*GUI*/.         

DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
RECT-FRAME-LABEL:HIDDEN in frame b = yes.
RECT-FRAME:HEIGHT-PIXELS in frame b =
FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/

setFrameLabels(frame b:handle).

/* DISPLAY */
view frame a.
view frame b.

/*
find first icc_ctrl no-lock no-error.
site = if avail icc_ctrl then icc_site else "" .
*/
site = "GSA01" .

mainloop:
repeat with frame a:
    clear frame a no-pause .
    clear frame b no-pause .
    disp site with frame a .


    ststatus = stline[1].
    status input ststatus.

    update part with frame a editing:
         if frame-field = "part" then do:
             {mfnp.i pt_mstr part  pt_part  part pt_part pt_part}
             if recno <> ? then do:
                    display pt_part @ part pt_desc1 @ desc1 pt_desc2 @ desc2 site with frame a .
             end . /* if recno <> ? then  do: */
         end.
         else  if frame-field = "site" then do:
             {mfnp01.i xsqty_mstr  site xsqty_site  part  xsqty_part  xsqty_part}
             if recno <> ? then do:
                    find pt_mstr where pt_part = xsqty_part no-lock no-error .
                    desc1 = if avail pt_mstr then pt_desc1 else "" .
                    desc2 = if avail pt_mstr then pt_desc2 else "" .
                    disp xsqty_part @ part desc1 desc2 xsqty_site @ site with frame a .
                    disp xsqty_date 
                         xsqty_sqty[01] @ v_sqty[01]
                         xsqty_sqty[02] @ v_sqty[02]
                         xsqty_sqty[03] @ v_sqty[03]
                         xsqty_sqty[04] @ v_sqty[04]
                         xsqty_sqty[05] @ v_sqty[05]
                         xsqty_sqty[06] @ v_sqty[06]
                         xsqty_sqty[07] @ v_sqty[07]
                         xsqty_sqty[08] @ v_sqty[08]
                         xsqty_sqty[09] @ v_sqty[09]
                         xsqty_sqty[10] @ v_sqty[10]
                         xsqty_sqty[11] @ v_sqty[11]
                         xsqty_sqty[12] @ v_sqty[12]
                    with frame b.
             end . /* if recno <> ? then  do: */
         end.
         else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end.
    end. /* update...EDITING */

    find first pt_mstr where pt_part = part no-lock no-error.
    if not avail pt_mstr  then do :
        message "错误:料件不存在" .
        undo mainloop, retry mainloop.
    end.
    
    if site <> "" and ( not can-find(si_mstr where si_site = site ) ) then do:
        message "错误:地点不存在"  .
        undo mainloop, retry mainloop.
    end.
    

    find pt_mstr where pt_part = part no-lock no-error .
    desc1 = if avail pt_mstr then pt_desc1 else "" .
    desc2 = if avail pt_mstr then pt_desc2 else "" .
    disp part desc1 desc2 site with frame a .

    find  xsqty_mstr where  xsqty_part = part and xsqty_site = site exclusive-lock no-error .
    if not avail xsqty_mstr then do :
            {mfmsg.i 1 1 } 
            create xsqty_mstr .
            assign xsqty_part =  part
                   xsqty_site =  site 
                   xsqty_user =  global_userid 
                   xsqty_date =  today .
                   
    end.


    v_i = 0 .
    do v_i = 1 to 12 :
        assign v_sqty[v_i] = xsqty_sqty[v_i] .
    end.
    
    disp  
            v_sqty[1]  
            v_sqty[2]  
            v_sqty[3]  
            v_sqty[4]  
            v_sqty[5]  
            v_sqty[6]  
            v_sqty[07]
            v_sqty[08]
            v_sqty[09]
            v_sqty[10]
            v_sqty[11]
            v_sqty[12]
    with frame b .
    disp xsqty_date with frame b.



    setloop:
    do on error undo ,retry :


        update 
                v_sqty[1]  
                v_sqty[2]  
                v_sqty[3]  
                v_sqty[4]  
                v_sqty[5]  
                v_sqty[6]  
                v_sqty[07]
                v_sqty[08]
                v_sqty[09]
                v_sqty[10]
                v_sqty[11]
                v_sqty[12]
        go-on ("f5" "ctrl-d") 
        with frame b editing :
                readkey.
                if ( lastkey = keycode("f5") or lastkey = keycode("ctrl-d") ) then do:
                    {mfmsg01.i 11 1 del-yn }  
                    /*message "确认删除?" view-as alert-box question buttons yes-no title "" update choice as logical.
                    if choice then do :*/
                    if del-yn then do :
                            delete xsqty_mstr .
                            next mainloop .
                    end.
                end. /*   "f5" "ctrl-d" */
                else apply lastkey.
        end. /* update ...editing */

        v_i = 0 .
        do v_i = 1 to 12 :
            if v_sqty[v_i] < 0 or v_sqty[v_i] = ?   then do:
                message "错误:安全库存数不允许为负数.请重新输入" .
                next-prompt v_sqty[v_i] with frame b .
                undo,retry .
            end.
        end.
        
        v_i = 0 .
        do v_i = 1 to 12 :
            assign xsqty_sqty[v_i] = v_sqty[v_i].
        end.
        assign 
            xsqty_user = global_userid 
            xsqty_date = today .
    end. /*  setloop: */
end.   /*  mainloop: */

status input.
