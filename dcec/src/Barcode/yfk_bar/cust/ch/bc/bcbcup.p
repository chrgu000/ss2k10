{mfdtitle.i}
{bcdeclre.i NEW}
{bcini.i}
/*{bcwin01.i}*/

DEFINE VARIABLE afile AS CHARACTER FORMAT "X(256)":U VIEW-AS
     FILL-IN SIZE 38.5 BY 1 LABEL "文件" NO-UNDO.
DEFINE BUTTON btn_file LABEL "打开" SIZE 4 BY 1.

DEFINE BUTTON btn_load LABEL "导入".
DEFINE BUTTON btn_cancel LABEL "取消".
DEFINE BUTTON btn_save LABEL "保存".
DEFINE BUTTON btn_bccr LABEL "产生条码".

DEFINE TEMP-TABLE ttpt_mstr
    FIELD ttpt_part LIKE ld_part
    FIELD ttpt_site LIKE ld_site
    FIELD ttpt_loc LIKE ld_loc.

DEFINE TEMP-TABLE ttco_mstr
    FIELD  ttco_part LIKE t_co_part
    FIELD  ttco_code LIKE t_co_code
    FIELD  ttco_qty  LIKE t_co_qty_cur
    FIELD  ttco_site LIKE t_co_site
    FIELD  ttco_loc  LIKE t_co_loc
    FIELD  ttco_lot  LIKE t_co_lot.

DEFINE QUERY q_ttco FOR ttco_mstr.
DEFINE BROWSE b_ttco QUERY q_ttco
    DISP 
    ttco_part LABEL "零件"
    ttco_code LABEL "条码"
    ttco_qty  LABEL "条码数量"
    ttco_site  LABEL "地点"
    ttco_loc  LABEL "库位"
    ttco_lot  LABEL "批号"
    WITH 6  DOWN WIDTH 79
    TITLE "条码清单".

DEFINE QUERY q_co FOR t_co_mstr.
DEFINE BROWSE b_co QUERY q_co
    DISP 
    t_co_part LABEL "零件"
    t_co_code LABEL "条码"
    t_co_qty_cur  LABEL "条码数量"
    t_co_site  LABEL "地点"
    t_co_loc  LABEL "库位"
    t_co_lot  LABEL "批号"
    WITH 8  DOWN WIDTH 79
    TITLE "条码清单".

DEFINE FRAME a
    afile  btn_file SKIP(.1)
    b_ttco SKIP(.1)
    b_co SKIP(1)
    btn_load btn_cancel btn_save btn_bccr
    WITH WIDTH 80 THREE-D SIDE-LABEL.

ON 'choose':U OF btn_file
DO:
    SYSTEM-DIALOG GET-FILE aFile
           FILTERS "????(*.txt)" "*.txt"
                 INITIAL-DIR "c:\"
                         RETURN-TO-START-DIR
                              TITLE "GTI ????" 
                                 SAVE-AS
                                    USE-FILENAME
                                      DEFAULT-EXTENSION ".txt".
     display afile with frame a .
    RETURN.
END.

ON 'choose':U OF btn_bccr
DO:
    RUN bccr.
    RETURN.
END.

ON 'choose':U OF btn_save 
DO:
    RUN bcsave.
    RETURN.
END.



REPEAT :
    FOR EACH ttpt_mstr:
        DELETE ttpt_mstr.
    END.
    FOR EACH ttco_mstr:
        DELETE ttco_mstr.
    END.
    FOR EACH t_co_mstr:
        DELETE t_co_mstr.
    END.

    UPDATE afile btn_file WITH FRAME a.
        DEFINE VARIABLE part LIKE ld_part.
        DEFINE VARIABLE site LIKE ld_site.
        DEFINE VARIABLE loc LIKE ld_loc.
        INPUT FROM VALUE(afile).
        DO WHILE TRUE:
           IMPORT DELIMITER "    "  part site loc.
 
               FIND FIRST ttpt_mstr NO-LOCK WHERE ttpt_part = TRIM(part) AND ttpt_site = TRIM(site)
                    AND ttpt_loc = TRIM(loc).
               IF AVAILABLE ttpt_mstr THEN DO:
                    MESSAGE "不要重复导入资料" VIEW-AS ALERT-BOX.
                    LEAVE.
              END.

        FOR EACH ld_det NO-LOCK WHERE ld_part = part AND ld_site = site AND ld_loc = loc:
            FOR EACH b_co_mstr WHERE b_co_part = ld_part AND b_co_site = ld_site
                AND b_co_loc = ld_loc AND b_co_lot = ld_lot AND b_co_status NE "DISABLE":
                CREATE ttco_mstr.
                ASSIGN 
                    ttco_part = b_co_part
                    ttco_code = b_co_code
                    ttco_site = b_co_site
                    ttco_loc = b_co_loc
                    ttco_lot = b_co_lot
                    ttco_qty = b_co_qty_cur.
            END.
        END.
       
      END.
      INPUT CLOSE.
      OPEN QUERY q_ttco FOR EACH ttco_mstr.

    REPEAT:
        UPDATE b_ttco b_co btn_load btn_cancel btn_save btn_bccr WITH FRAME a.
    END.
END.


PROCEDURE bccr:
    FOR EACH t_co_mstr:
        DELETE t_co_mstr.
    END.
    FOR EACH ttpt_mstr:
        FOR EACH ld_det NO-LOCK WHERE ld_part = ttpt_part AND ld_site = ttpt_site 
            AND ld_loc = ttpt_loc:
           {gprun.i ""bccocr.p"" "(input ttpt_part, INPUT today,
                                  input ld_qty_oh, INPUT ""vend"", input ""0"",
                                  INPUT ld_site, INPUT ld_loc)"}
        END.
    END.
    OPEN QUERY q_co FOR EACH t_co_mstr.
END.

PROCEDURE bcsave:
    DO ON ERROR UNDO:
        FOR EACH ttco_mstr:
            FIND FIRST b_co_mstr EXCLUSIVE-LOCK WHERE b_co_code = ttco_code NO-ERROR.
            IF AVAILABLE b_co_mstr THEN DO:
                ASSIGN b_co_status = "DISABLE".
            END.
        END.

        FOR EACH t_co_mstr:
            CREATE b_co_mstr.
            ASSIGN
                 b_co_code = t_co_code
                 b_co_part = t_co_part 
                 b_co_um = t_co_um
                 b_co_lot = lotnbr
                 b_co_status = "MAT-STOCK"
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
    END.
END.
