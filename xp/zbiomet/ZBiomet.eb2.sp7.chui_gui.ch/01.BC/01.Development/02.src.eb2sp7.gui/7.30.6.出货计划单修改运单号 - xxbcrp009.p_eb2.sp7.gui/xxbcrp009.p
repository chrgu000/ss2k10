/* xxbcrp009.p 修改出货计划单的UPS运单号                                   */
/* REVISION: 1.0         Last Modified: 2008/10/27   By: Roger   NO ECO    */ 
/*-Revision end------------------------------------------------------------*/


{mfdtitle.i "2+ "}

define var v_shipnbr     like xpkd_shipnbr .
define var v_airnbr      like xpkd_airnbr .
define var v_airnbr_new  like xpkd_airnbr .
define var ship_to       as char format "x(8)"  .



/*GUI preprocessor Frame A define A*/
&SCOPED-DEFINE PP_FRAME_NAME 

FORM  
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  
    v_shipnbr       colon 18 label "装箱单"
    skip(.5)
    ship_to         colon 18 label "交运地"
    v_airnbr        colon 18 label "旧运单号" format "x(18)"
    skip(.5)
    v_airnbr_new    colon 18 label "新运单号" format "x(18)"
    SKIP(4)  
with frame a side-labels width 80 NO-BOX THREE-D .

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = "".
RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
RECT-FRAME:HEIGHT-PIXELS in frame a =
FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. 

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/*setFrameLabels(frame a:handle).*/

v_shipnbr    = "" .
v_airnbr     = "" .
v_airnbr_new = "" .
ship_to      = "" .


mainloop:
repeat: 
    v_airnbr_new = "" .
    update v_shipnbr with frame a editing:
        {mfnp11.i xpkd_det xpkd_shipnbr  xpkd_shipnbr "input v_shipnbr" }
        IF recno <> ?  THEN DO:
            v_shipnbr    = xpkd_shipnbr .
            v_airnbr     = xpkd_airnbr  .
            ship_to      = xpkd_shipto .

            DISP  v_shipnbr ship_to v_airnbr      with frame a.
        END.  /*if recno<> ?*/
    end.
    assign v_shipnbr v_airnbr ship_to .
    if v_shipnbr <> "" then do:
            find first xpkd_det use-index  xpkd_shipnbr where xpkd_shipnbr = v_shipnbr no-lock no-error .
            if not avail xpkd_det then do:
                message "无效装箱单号,请重新输入" view-as alert-box.
                undo,retry.
            end.

            v_shipnbr    = xpkd_shipnbr .
            v_airnbr     = xpkd_airnbr  .
            ship_to      = xpkd_shipto .

            DISP  v_shipnbr ship_to v_airnbr      with frame a.
            v_airnbr_new = "" .
            do on error undo,retry :
                update v_airnbr_new with frame a .
                if v_airnbr_new = "" then do:
                    message "无效运单号,请重新输入" view-as alert-box.
                    undo,retry.
                end.
            end.


            for each xpkd_det 
                use-index  xpkd_shipnbr
                where xpkd_shipnbr = v_shipnbr
                and   xpkd_airnbr  = v_airnbr :
                
                for each tr_hist 
                    where tr_nbr  = xpkd_sonbr 
                    and tr_line   = xpkd_soline 
                    and tr__chr15 = xpkd_nbr 
                    and tr__chr14 = xpkd_airnbr: 

                    tr__chr14 = v_airnbr_new . 
                end. 

                    xpkd_airnbr = v_airnbr_new .
            end. /*for each xpkd_det*/
            message "运单号已变更." .

    end. /*if v_shipnbr <> "" */
    else do:   /*if v_shipnbr = "" */
        message "无效装箱单号,请重新输入." .
        undo,retry .
    end.   /*if v_shipnbr = "" */
    

end. /* mainloop */
