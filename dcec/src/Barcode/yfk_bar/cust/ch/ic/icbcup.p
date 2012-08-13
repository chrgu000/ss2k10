{mfdtitle.i}
{bcdeclre.i NEW}
{bcini.i}
/*{bcwin01.i}*/

DEFINE VARIABLE bccode LIKE b_co_code LABEL "条码号".
DEFINE VARIABLE bcpart LIKE b_co_part.
DEFINE VARIABLE bcsite LIKE b_co_part LABEL "地点".
DEFINE VARIABLE bcloc LIKE b_co_loc LABEL "库位".
DEFINE VARIABLE bcqty LIKE b_co_qty_cur LABEL "数量".
DEFINE VARIABLE bclot LIKE b_co_lot LABEL "批次号".

DEFINE VARIABLE bfid AS INTEGER.  /*indicate the buffer id*/
DEFINE VARIABLE succeed AS LOGICAL.


DEFINE QUERY q_co FOR t_co_mstr.
DEFINE BROWSE b_co QUERY q_co
    DISPLAY
    t_co_code LABEL "条码"
    t_co_part LABEL "零件"
    t_co_qty_cur LABEL "数量"
    t_co_lot LABEL "批号"
    WITH 9 DOWN WIDTH 79
    TITLE "条码清单".

DEFINE BUTTON btn_save LABEL "保存".
DEFINE BUTTON btn_prt1 LABEL "打印小条码".
DEFINE BUTTON btn_prt2 LABEL "打印双条码".
DEFINE BUTTON btn_prt3 LABEL "打印大条码".
DEFINE BUTTON btn_quit LABEL "退出".

DEFINE FRAME a
    SKIP(.5)
    pt_part COLON 8 LABEL "零件号"
    pt_desc1 COLON 8  LABEL "零件描述" 
    bcsite COLON 8 bcloc COLON 30 bclot COLON 55
    bcqty COLON 8 
    SKIP(1)
    b_co
    SKIP(2)
    SPACE(40) btn_save SPACE(1) btn_prt1 SPACE(1)  btn_prt2 SPACE(1)  btn_prt3 SPACE(1)
    WITH WIDTH 80 TITLE "条码产生打印"  SIDE-LABELS  NO-UNDERLINE THREE-D.

ON 'leave':U OF bcsite
DO:
    ASSIGN bcsite.
    IF bcsite = "" THEN DO:
        STATUS INPUT  "空地点不允许，退出".
        RETURN.
    END.
    RETURN.
END.

ON 'leave':U OF bclot
DO:
    ASSIGN bcsite bcloc bclot.
    ASSIGN bcpart = pt_part:SCREEN-VALUE.
    FIND FIRST ld_det NO-LOCK WHERE ld_part = pt_part:SCREEN-VALUE AND ld_site = bcsite AND ld_loc = bcloc
           AND ld_lot = bclot NO-ERROR.
    IF AVAILABLE ld_det THEN DO:
        bcqty = ld_qty_oh.
        DISP bcqty WITH FRAME a.
    END.
    ELSE DO:
        STATUS INPUT "找不到库存，退出".
        RETURN.
    END.
    RETURN.
END.

ON 'enter':U OF bcqty 
DO:
    ASSIGN bcqty.
    FOR EACH t_co_mstr:
        DELETE t_co_mstr.
    END.
    {gprun.i ""bccocr.p"" "(input pt_part:screen-value, INPUT today,
                              input bcqty:screen-value, INPUT ""vend"", input ""0"",
                              INPUT bcsite, INPUT bcloc)"}
    OPEN QUERY q_co FOR EACH t_co_mstr.
    RETURN.
END.

ON 'choose':U OF btn_save 
DO:
    /*{bcrun.i ""bciccomt01.p""}.*/
    RUN exec.
    RETURN.
END.

ON 'choose':U OF btn_prt1 
DO:
    {bcgetprt.i}
    FOR EACH t_co_mstr:
        {gprun.i ""bccopr.p"" "(input t_co_code, input ""SIN"", input pname, input no)"}
    END.
    RETURN.
END.

ON 'choose':U OF btn_prt2 
DO:
    {bcgetprt.i}
    FOR EACH t_co_mstr:
        {gprun.i ""bccopr.p"" "(input t_co_code, input ""DOU"", input pname, input no)"}
    END.
    RETURN.
END.

ON 'choose':U OF btn_prt3 
DO:
    {bcgetprt.i}
    FOR EACH t_co_mstr:
        {gprun.i ""bccopr.p"" "(input t_co_code, input ""FUL"", input pname, input no)"}
    END.
    RETURN.
END.

REPEAT:

PROMPT-FOR pt_part WITH FRAME a EDITING:
        {bcnp.i "pt_mstr" "pt_part"}
         IF recno <> ? THEN DO:
             display
              pt_part pt_desc1             WITH FRAME a.
         END.
 END. /*promtp-for*/
 
 
     UPDATE bcsite bcloc bclot bcqty b_co btn_save btn_prt1 btn_prt2 btn_prt3  WITH FRAME a.
 END.


PROCEDURE exec:

    mainloop:
    DO ON ERROR UNDO,LEAVE:

        FOR EACH b_co_mstr WHERE b_co_part = bcpart AND b_co_lot = bclot
            AND b_co_site = bcsite AND b_co_loc = bcloc:
            DELETE b_co_mstr.
        END.

        FOR EACH t_co_mstr:
            CREATE b_co_mstr.
            ASSIGN
                 b_co_code = t_co_code
                 b_co_part = t_co_part 
                 b_co_um = t_co_um
                 b_co_lot = bclot
                 b_co_desc1 = t_co_desc1 
                 b_co_desc2 =  t_co_desc2
                 b_co_qty_ini =  t_co_qty_ini 
                 b_co_qty_cur =  t_co_qty_cur 
                 b_co_qty_std  =  t_co_qty_std
                 b_co_ser =  t_co_ser
                 b_co_ref =  t_co_ref
                 b_co_site = bcsite
                 b_co_loc = bcloc
                 b_co_format = t_co_format.
             IF bcloc = "s001a" THEN b_co_status = "FINI-GOOD". ELSE b_co_status = "MAT-STOCK".
            CREATE b_cot_det.
            ASSIGN 
                b_cot_code = t_co_code
                b_cot_status = "MAT-CRE"
                b_cot_date = TODAY
                b_cot_time = TIME.
        END.

    END. /*do*/
END.  /*procedure*/


