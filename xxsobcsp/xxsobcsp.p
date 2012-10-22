/*SS - 101021.1 BY Ken*/


{mfdtitle.i "121022.1"} 


DEFINE VARIABLE buyer LIKE pt_buyer INITIAL "4RSA".
DEFINE VARIABLE xbuyer LIKE pt_buyer .
DEFINE VARIABLE model AS CHARACTER.
DEFINE VARIABLE model_type AS CHARACTER.
DEFINE VARIABLE prt_color AS CHARACTER INITIAL "黄色".  
DEFINE VARIABLE cust LIKE so_cust.
DEFINE VARIABLE cust1 LIKE so_cust.
DEFINE VARIABLE part LIKE pt_part.
DEFINE VARIABLE part1 LIKE pt_part.
DEFINE VARIABLE v_due_date AS DATE .
DEFINE VARIABLE v_due_date1 AS DATE .
DEFINE VARIABLE v_time AS CHARACTER FORMAT "x(5)".
DEFINE VARIABLE v_time1 AS CHARACTER FORMAT "x(5)".
DEFINE VARIABLE option_list AS CHARACTER FORMAT "x(1)" INITIAL "1".
DEFINE VARIABLE i AS INTEGER.
DEFINE VARIABLE j AS INTEGER.
DEFINE VARIABLE n AS INTEGER.
DEFINE VARIABLE vqty like pt_ship_wt.


DEFINE TEMP-TABLE tt1 
    FIELD tt1_cust LIKE xxsod_cust
    FIELD tt1_addr LIKE xxsod_addr
    FIELD tt1_cust_part LIKE xxsod_part
    FIELD tt1_part LIKE xxsod_part
    FIELD tt1_plan LIKE xxsod_plan
    FIELD tt1_ship_date LIKE xxsod_due_date1
    FIELD tt1_ship_time LIKE xxsod_due_time1
    FIELD tt1_load_date LIKE xxsod_due_date1
    FIELD tt1_load_time LIKE xxsod_due_time1
    FIELD tt1_qty_ord LIKE xxsod_qty_ord
    FIELD tt1_model AS CHARACTER
    FIELD tt1_model_type AS CHARACTER
    FIELD tt1_color AS CHARACTER
    FIELD tt1_desc1 LIKE pt_desc1
    FIELD tt1_per_qty LIKE pt_ship_wt
    FIELD tt1_title AS CHARACTER
    FIELD tt1_model_zy AS CHARACTER
    FIELD tt1_sy AS CHARACTER
    INDEX index1 tt1_cust tt1_cust_part.


DEFINE TEMP-TABLE tt2 
    FIELD tt2_id   LIKE tr_trnbr
    FIELD tt2_part LIKE pt_part
    FIELD tt2_color LIKE xxsod_color
    FIELD tt2_title AS CHARACTER
    FIELD tt2_cust_part LIKE xxsod_part
    FIELD tt2_desc1 LIKE pt_desc1
    FIELD tt2_qty_ord LIKE xxsod_qty_ord
    FIELD tt2_addr LIKE xxsod_addr
    FIELD tt2_load_date LIKE xxsod_due_date1
    FIELD tt2_load_time LIKE xxsod_due_time1
    FIELD tt2_plan AS CHARACTER
    FIELD tt2_model_zy AS CHARACTER
    FIELD TT2_SY AS CHARACTER
    INDEX index1 tt2_id tt2_part.

v_due_date = TODAY.
v_due_date1 = TODAY + 2.

form
    SKIP(.2)
    buyer       COLON 15   SKIP 
    model       COLON 15   SKIP
    prt_color   COLON 15   SKIP
    cust        COLON 15    cust1     LABEL {t001.i} COLON 49 SKIP
    part        COLON 15    part1     LABEL {t001.i} COLON 49 SKIP
    v_due_date   COLON 15    v_due_date1 LABEL {t001.i} COLON 49 SKIP
    v_time     COLON 15    v_time1   LABEL {t001.i} COLON 49 SKIP
    option_list COLON 30   SKIP
      "1.黑白" COLON 35
      "2.彩色" COLON 35

skip(1) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    IF cust1 = hi_char THEN cust1 = "".
    IF part1 = hi_char THEN part1 = "".
    IF v_due_date = low_date THEN v_due_date = ? .
    IF v_due_date1 = hi_date THEN v_due_date1 = ?.
    IF v_time1 = hi_char THEN v_time1 = "" .

    update 
        buyer
        model
        prt_color
        cust
        cust1
        part
        part1
        v_due_date
        v_due_date1
        v_time
        v_time1
        option_list
    with frame a.

    ASSIGN
        buyer
        model
        prt_color
        cust
        cust1
        part
        part1
        v_due_date
        v_due_date1
        v_time
        v_time1
        option_list .


    IF buyer = "" THEN DO:
        MESSAGE "计划员不能为空".
        UNDO,RETRY.
    END.

    /*
    IF model = "" THEN DO:
        MESSAGE "车型不能为空".
        UNDO,RETRY.
    END.
    */

    IF prt_color = "" THEN DO:
        MESSAGE "颜色不能为空".
        UNDO,RETRY.
    END.


    IF cust1 = "" THEN cust1 = hi_char.
    IF part1 = "" THEN part1 = hi_char.
    IF v_due_date = ? THEN v_due_date = low_date.
    IF v_due_date1 = ? THEN v_due_date1 = hi_date .
    IF v_time1 = "" THEN v_time1 = hi_char.

    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = " "
                &stream = " "
                &appendToFile = " "
                &streamedOutputToTerminal = " "
                &withBatchOption = "yes"
                &displayStatementType = 1
                &withCancelMessage = "yes"
                &pageBottomMargin = 6
                &withEmail = "yes"
                &withWinprint = "yes"
                &defineVariables = "yes"}
mainloop: 
do on error undo, return error on endkey undo, return error:

    EMPTY TEMP-TABLE tt1.
    EMPTY TEMP-TABLE tt2.

    xbuyer = "*" + buyer + "*".
    FOR EACH xxsod_det NO-LOCK WHERE  xxsod_cust >= cust AND xxsod_cust <= cust1
        AND date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) >= v_due_date
        AND date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) <= v_due_date1
        AND xxsod_due_time >= v_time 
        AND xxsod_due_time <= v_time1
        ,EACH cp_mstr WHERE cp_cust = xxsod_cust AND cp_cust_part = xxsod_part 
         AND cp_user1 = prt_color
         NO-LOCK
        ,EACH pt_mstr WHERE pt_part = cp_part AND pt_buyer MATCHES  xbuyer 
              AND (pt_drwg_loc = model OR model = "") 
        AND 
           pt_part >= part
        AND   pt_part <= part1 
        NO-LOCK:
                 /*

                 DISP 

                     date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) v_due_date ">>"
                     date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) v_due_date1.
                */

                /*
                PUT UNFORMATTED xxsod_cust AT 6.
                PUT UNFORMATTED xxsod_addr AT 42 .
                PUT UNFORMATTED xxsod_part AT 52 .
                FIND FIRST cp_mstr WHERE cp_cust = xxsod_cust AND cp_cust_part = xxsod_part NO-LOCK NO-ERROR.
                IF AVAIL cp_mstr THEN DO:
                   PUT UNFORMATTED cp_part AT 73.
                END.
                ELSE DO:
                   PUT UNFORMATTED "没有维护客户零件" AT 73.
                END.

                PUT UNFORMATTED xxsod_plan AT 108 .
                PUT UNFORMATTED xxsod_due_date1 AT 118.
                PUT UNFORMATTED xxsod_due_time1 AT 129.
                PUT UNFORMATTED xxsod_qty_ord TO 154 .
                PUT SKIP.
                */

                FIND FIRST tt1 WHERE tt1_cust = xxsod_cust AND tt1_cust_part = xxsod_part AND tt1_ship_date = xxsod_due_date1 AND tt1_ship_time = xxsod_due_time1
                    NO-ERROR.
                IF NOT AVAIL tt1 THEN DO:
                    CREATE tt1.
                    ASSIGN
                        tt1_cust = xxsod_cust
                        tt1_addr = xxsod_addr
                        tt1_plan = xxsod_plan
                        tt1_cust_part = xxsod_part
                        tt1_part = cp_part
                        tt1_ship_date = xxsod_due_date1
                        tt1_ship_time = xxsod_due_time1
                        tt1_load_date = xxsod_due_date
                        tt1_load_time = xxsod_due_time
                        tt1_qty_ord = xxsod_qty_ord
                        tt1_model = pt_drwg_loc
                        tt1_model = SUBSTRING(cp_cust_part,6,3)
                        /*
                        tt1_desc1 = IF model = "4RPS" THEN pt_desc1 ELSE pt_desc2
                        */

                        tt1_per_qty = pt_ship_wt
                        tt1_title = pt__chr01
                        tt1_color = cp_user1.

                        IF pt_buyer MATCHES "*4RPS*" THEN DO:
                            tt1_desc1 = pt_desc1.
                        END.

                        IF pt_buyer MATCHES "*4RSA*" THEN DO:
                            tt1_desc1 = pt_desc2.
                        END.

                        IF cp_user1 = "白色" THEN DO:
                           tt1_color = "".
                        END.

                      IF pt_buyer = "4RPS" THEN DO:
                        tt1_model_zy = pt_drwg_loc.
                         IF xxsod_cust = "4H0001" THEN DO:
                             tt1_sy = SUBSTRING(cp_cust_part,6,3).
                         END.
                      END.

                      IF pt_buyer = "4RSA" THEN DO:
                          IF substring(pt_promo,7,1) = "R"  THEN DO:
                             tt1_model_zy = "右".
                          END.

                          IF substring(pt_promo,7,1) = "L" THEN DO:
                             tt1_model_zy = "左".
                          END.


                          IF substring(pt_promo,6,1) = "F" THEN DO:
                             tt1_sy = "前".
                          END.

                          IF substring(pt_promo,6,1) = "R" THEN DO:
                             tt1_sy = "后".
                          END.

                          IF tt1_sy = "后" AND tt1_model_zy = "" THEN
                                tt1_model_zy = "后".

                          IF tt1_model_zy = "" THEN
                                tt1_model_zy = pt_drwg_loc.
                         
                      END.




                END.
                ELSE DO:
                    tt1_qty_ord = tt1_qty_ord + xxsod_qty_ord.
                END.
                
            END. /*FOR EACH xxsod_det*/

/***
for each tt1 with frame x width 360:
		display tt1.
end.
****/

            i = 0.

            FOR EACH tt1 BY tt1_cust BY tt1_part BY tt1_ship_date BY tt1_ship_time:
                
                /*
                DISP tt1 WITH WIDTH 200 STREAM-IO.
                */


                IF tt1_per_qty = 0 OR tt1_qty_ord <= tt1_per_qty THEN DO:
                    i = i + 1.
                   CREATE tt2.
                   ASSIGN tt2_id = i
                       tt2_part = tt1_part
                       tt2_color = tt1_color
                       tt2_title = tt1_title
                       tt2_cust_part = tt1_cust_part
                       tt2_desc1 = tt1_desc1
                       tt2_qty_ord = tt1_qty_ord
                       tt2_addr = tt1_addr
                       tt2_load_date = tt1_load_date
                       tt2_load_time = tt1_load_time
                       tt2_plan = tt1_plan
                       tt2_model_zy = tt1_model_zy
                       tt2_sy = tt1_sy.
                END.
                ELSE DO:
                		assign vqty = tt1_qty_ord.
                		do while vqty > 0:
									     i = i + 1.
                       CREATE tt2.
                       ASSIGN tt2_id = i
                           tt2_part = tt1_part
                           tt2_color = tt1_color
                           tt2_title = tt1_title
                           tt2_cust_part = tt1_cust_part
                           tt2_desc1 = tt1_desc1
                           tt2_qty_ord = min(tt1_per_qty,vqty)
                           tt2_addr = tt1_addr
                           tt2_load_date = tt1_load_date
                           tt2_load_time = tt1_load_time
                           tt2_plan = tt1_plan
                           tt2_model_zy = tt1_model_zy
                           tt2_sy = tt1_sy.     
                    assign vqty = vqty - tt1_per_qty.
                	  end.
                END.
/********************************************                
                ELSE DO:
                   IF TRUNCATE(tt1_qty_ord / tt1_per_qty,0) < tt1_qty_ord / tt1_per_qty THEN DO:
                       n = TRUNCATE(tt1_qty_ord / tt1_per_qty,0) + 1.
                   END.
                   ELSE DO:
                       n = TRUNCATE(tt1_qty_ord / tt1_per_qty,0).
                   END.
                   DO j = 1 TO n:
                       i = i + 1.
                       IF j * tt1_per_qty <= tt1_qty_ord THEN DO:
                           CREATE tt2.
                           ASSIGN tt2_id = i
                               tt2_part = tt1_part
                               tt2_color = tt1_color
                               tt2_title = tt1_title
                               tt2_cust_part = tt1_cust_part
                               tt2_desc1 = tt1_desc1
                               tt2_qty_ord = tt1_per_qty
                               tt2_addr = tt1_addr
                               tt2_load_date = tt1_load_date
                               tt2_load_time = tt1_load_time
                               tt2_plan = tt1_plan
                               tt2_model_zy = tt1_model_zy
                               tt2_sy = tt1_sy.
                       END.
                       ELSE DO:
                           CREATE tt2.
                           ASSIGN tt2_id = i
                               tt2_part = tt1_part
                               tt2_color = tt1_color
                               tt2_title = tt1_title
                               tt2_cust_part = tt1_cust_part
                               tt2_desc1 = tt1_desc1
                               tt2_qty_ord = tt1_qty_ord - (j - 1) * tt1_per_qty
                               tt2_addr = tt1_addr
                               tt2_load_date = tt1_load_date
                               tt2_load_time = tt1_load_time
                               tt2_plan = tt1_plan
                               tt2_model_zy = tt1_model_zy
                               tt2_sy = tt1_sy.
                       END.
                   END.
                END.
******************************************************/                
            END.

            IF option_list = "1" THEN DO:
                
                PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname,1,LENGTH(execname) - 2) SKIP.
                PUT UNFORMATTED "#def :end" SKIP.
                FOR EACH tt2 BY tt2_id:
                    EXPORT DELIMITER ";" tt2.
                END.
            END.
            ELSE DO:
                PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname,1,LENGTH(execname) - 2) + "_" + upper(prt_color) SKIP.
                PUT UNFORMATTED "#def :end" SKIP.
                FOR EACH tt2 BY tt2_id:
                    EXPORT DELIMITER ";" tt2.
                END.
            END.
end. /* mainloop: */
{mfreset.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
                
