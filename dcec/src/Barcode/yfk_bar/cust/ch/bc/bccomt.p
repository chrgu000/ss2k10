{bcdeclre.i}
{bcini.i}
{bcwin01.i}

DEFINE VARIABLE bccode LIKE b_co_code LABEL "条码号".

DEFINE VARIABLE bcqty LIKE b_co_qty_cur LABEL "数量".
DEFINE VARIABLE bclot LIKE b_co_lot LABEL "批次号".


DEFINE VARIABLE recno AS RECID.



DEFINE QUERY q_co FOR t_co_mstr.
DEFINE BROWSE b_co QUERY q_co
    DISPLAY
    t_co_code LABEL "条码"
    t_co_part LABEL "零件"
    t_co_qty_cur LABEL "数量"
    t_co_lot LABEL "批号"
    WITH 8 DOWN WIDTH 79
    TITLE "条码清单".

DEFINE BUTTON btn_save LABEL "保存".
DEFINE BUTTON btn_prt LABEL "打印".
DEFINE BUTTON btn_quit LABEL "退出".

DEFINE FRAME a
    SKIP(.5)
    pt_part COLON 8 LABEL "零件号"
    pt_desc1 COLON 8  LABEL "零件描述" 
    bcqty COLON 8 
    SKIP(1)
    b_co
    SKIP(2)
    SPACE(60) btn_save SPACE(2) btn_prt SPACE(2) btn_quit
    WITH WIDTH 80 TITLE "条码产生打印"  SIDE-LABELS  NO-UNDERLINE THREE-D.


ON 'enter':U OF bcqty 
DO:
    FOR EACH t_co_mstr:
        DELETE t_co_mstr.
    END.
    {bcrun.i ""bcbccocr.p"" "(input pt_part:screen-value, input today,
                              input bcqty:screen-value, input ""YFK"", INPUT """")"}
    OPEN QUERY q_co FOR EACH t_co_mstr.
    RETURN.
END.

ON 'choose':U OF btn_save 
DO:
    FOR EACH t_co_mstr:
        CREATE b_co_mstr.
        ASSIGN
             b_co_code = t_co_code
             b_co_part = t_co_part 
             b_co_um = t_co_um
             b_co_lot = t_co_lot
             b_co_status = t_co_status 
             b_co_desc1 = t_co_desc1 
             b_co_desc2 =  t_co_desc2
             b_co_qty_ini =  t_co_qty_ini 
             b_co_qty_cur =  t_co_qty_cur 
             b_co_qty_std  =  t_co_qty_std
             b_co_ser =  t_co_ser
             b_co_ref =  t_co_ref
             b_co_format = t_co_format
             b_co_vcode = t_co_vcode.
    END.
    RETURN.
END.

ON 'choose':U OF btn_prt 
DO:
    FOR EACH t_co_mstr:
        {bcrun.i ""bcbccopr.p"" "(input t_co_code, input ""IPL"",input no)"}
    END.
    RETURN.
END.

PROMPT-FOR pt_part WITH FRAME a EDITING:
        {bcnp.i "pt_mstr" "pt_part"}
         IF recno <> ? THEN DO:
             display
              pt_part pt_desc1             WITH FRAME a.
         END.

         IF LASTKEY = KEYCODE("ENTER") THEN
         DO:
             FIND FIRST pt_mstr NO-LOCK USING pt_part NO-ERROR.
             IF AVAILABLE pt_mstr THEN 
                  DISP pt_desc1 WITH FRAME a.
             ELSE DO: 
                  MESSAGE "零件错误" VIEW-AS ALERT-BOX.
                  NEXT.
         END.    
         END.
 END. /*promtp-for*/



ENABLE bcqty b_co btn_save btn_prt btn_quit WITH FRAME a.
{bctrail.i}
