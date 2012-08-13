
{mfdtitle.i}
{bcdeclre2.i NEW}
{bcini.i}




DEFINE VARIABLE site LIKE loc_site LABEL "地点".
DEFINE VARIABLE site1 LIKE loc_site  LABEL "地点".
DEFINE VARIABLE loc LIKE loc_loc LABEL "库位".
DEFINE VARIABLE loc1 LIKE loc_loc  LABEL "库位".
DEFINE VARIABLE part LIKE pt_part.
DEFINE VARIABLE part1 LIKE pt_part.

DEFINE VARIABLE rpttype AS CHARACTER FORMAT "X(3)" LABEL "MTC:匹配 NLD:无存货  NCO:无条码".

/*DEFINE VARIABLE hExcel      AS COM-HANDLE       NO-UNDO.*/

    DEFINE VARIABLE qty LIKE ld_qty_oh.
    DEFINE TEMP-TABLE tld_det
        FIELD tld_site LIKE ld_site
        FIELD tld_loc LIKE ld_loc
        FIELD tld_part LIKE ld_part
        FIELD tld_lot LIKE ld_lot
        FIELD tld_qty_oh LIKE ld_qty_oh
        FIELD tld_qty_code LIKE ld_qty_oh
        FIELD tld_type AS CHARACTER.

&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
         
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(2)  /*GUI*/
    site COLON 15
    site1 COLON 45
    loc COLON 15 
    loc1 COLON 45
    part LABEL "料件号" COLON 15
    part1 LABEL "至" COLON 45
    SKIP(1)
    rpttype  COLON 30


SKIP(2)  /*GUI*/
with frame a WIDTH 80  side-labels  attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

DEFINE FRAME b
    ld_part LABEL "零件" AT 1
    ld_site LABEL "地点" AT 19
    ld_loc LABEL "库位" AT 30
    ld_qty_oh LABEL "库存量" AT 40
    tld_qty_oh LABEL "条码量" AT 50
    tld_qty_code LABEL "条码数" AT 60
    /*tld_var LABEL "差异" AT 79*/
    WITH WIDTH 90 STREAM-IO.


REPEAT :
    IF site1 = hi_char THEN site1 = "".
    IF loc1 = hi_char THEN loc1 = "".
    IF part1 = hi_char THEN part1 = "".

    UPDATE site site1 loc loc1 part part1  rpttype WITH FRAME a.

    IF site1 = "" THEN site1= hi_char.
    IF loc1 = "" THEN loc1 = hi_char.
    IF part1 = "" THEN part1 =hi_char.

    IF rpttype = "" THEN DO:
        MESSAGE "你得选一个类型" VIEW-AS ALERT-BOX.
        NEXT.
    END.

    FOR EACH tld_det:
        DELETE tld_det.
    END.

    FOR EACH b_cnt_wkfl BREAK BY b_cnt_part
        BY b_cnt_site BY b_cnt_loc BY b_cnt_lot:
        ACCUMULATE b_cnt_qty_cnt (TOTAL BY b_cnt_lot).
        ACCUMULATE b_cnt_code( COUNT BY b_cnt_lot).
        IF LAST-OF(b_cnt_lot) THEN DO:
            CREATE tld_det.
            ASSIGN
                tld_site = b_cnt_site
                tld_loc = b_cnt_loc
                tld_part = b_cnt_part
                tld_lot = b_cnt_lot
                tld_qty_oh = ACCUMU TOTAL BY b_cnt_lot b_cnt_qty_cnt
                tld_qty_code = ACCUMU COUNT BY b_cnt_lot b_cnt_code
                tld_type = "EQ".
        END.
    END.

  {mfselprt.i "printer" 132 " " " " " " " " }

   CASE rpttype:
       WHEN "MTC" THEN DO:
              FOR EACH ld_det, EACH tld_det WHERE ld_part = tld_part
                  AND ld_site = tld_site AND ld_loc = tld_loc AND ld_lot = tld_lot
                   AND  (ld_site >= site AND ld_site <= site1)
                   AND (ld_loc >= loc AND ld_loc <= loc1) AND (ld_part >= part AND ld_part <= part1):
                  FIND FIRST pt_mstr NO-LOCK WHERE pt_part = ld_part NO-ERROR.
                  DISP ld_part LABEL "零件号"
                           pt_desc1 LABEL "描述"
                           ld_site LABEL "地点"
                           ld_loc LABEL "库位"
                           ld_lot LABEL "批号"
                           ld_qty_oh LABEL "库存数量"
                           tld_qty_oh LABEL "条码数量"
                           (ld_qty_oh - tld_qty_oh) LABEL "差异" 
                      WITH STREAM-IO WIDTH 120.
              END.
       END.

       WHEN "NLD" THEN DO:
              FOR EACH tld_det WHERE  (tld_site >= site AND tld_site <= site1)
                   AND (tld_loc >= loc AND tld_loc <= loc1) AND (tld_part >= part AND tld_part <= part1):
                  FIND FIRST pt_mstr NO-LOCK WHERE pt_part =tld_part NO-ERROR.
                  FIND FIRST ld_det NO-LOCK WHERE ld_part = tld_part
                                     AND ld_site = tld_site AND ld_loc = tld_loc AND ld_lot = tld_lot NO-ERROR.
                  IF NOT AVAILABLE ld_det THEN DO:
                        DISP tld_part @ ld_part  LABEL "零件号"
                                  pt_desc1 LABEL "描述"
                                  tld_site @ ld_site  LABEL "地点"
                                  tld_loc @ ld_loc  LABEL "库位"
                                  tld_lot @ ld_lot  LABEL "批号"
                                  "" @ ld_qty_oh  LABEL "库存数量"
                                 tld_qty_oh LABEL "条码数量"
                                  (0 - tld_qty_oh) LABEL "差异" 
                             WITH STREAM-IO WIDTH 120.
                  END.
              END.
       END.

       WHEN "NCO"  THEN DO:
           FOR EACH ld_det WHERE  (ld_site >= site AND ld_site <= site1)
                AND (ld_loc >= loc AND ld_loc <= loc1) AND (ld_part >= part AND ld_part <= part1):
               FIND FIRST pt_mstr NO-LOCK WHERE pt_part = ld_part NO-ERROR.
               FIND FIRST tld_det NO-LOCK WHERE ld_part = tld_part
                                  AND ld_site = tld_site AND ld_loc = tld_loc AND ld_lot = tld_lot NO-ERROR.
               IF NOT AVAILABLE tld_det THEN DO:
                     DISP  ld_part LABEL "零件号"
                               pt_desc1 LABEL "描述"
                               ld_site  LABEL "地点"
                               ld_loc  LABEL "库位"
                               ld_lot  LABEL "批号"
                               ld_qty_oh   LABEL "库存数量"
                               "" @ tld_qty_oh  LABEL "条码数量"
                              (ld_qty_oh - 0) LABEL "差异" 
                          WITH STREAM-IO WIDTH 120.
               END.
           END.
       END.
   END CASE.

 
    
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

END.


