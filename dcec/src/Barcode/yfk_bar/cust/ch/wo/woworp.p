{mfdtitle.i}
{bcdeclre.i NEW}
/*{bcwin01.i}*/


DEFINE VARIABLE hExcel      AS COM-HANDLE       NO-UNDO.


DEFINE VARIABLE part LIKE pt_part LABEL "零件号".
DEFINE VARIABLE part1 LIKE pt_part  LABEL "至".
DEFINE VARIABLE wodate LIKE wo_date LABEL "生产日期" FORMAT "99/99/9999".
DEFINE VARIABLE wodate1 LIKE wo_date LABEL "至" FORMAT "99/99/9999".
DEFINE VARIABLE rcdate LIKE wo_date LABEL "入库日期" FORMAT "99/99/9999".
DEFINE VARIABLE rcdate1 LIKE wo_date LABEL "至" FORMAT "99/99/9999".
DEFINE VARIABLE irct AS LOGICAL LABEL "是否入库" INIT YES.
DEFINE VARIABLE ishp AS LOGICAL LABEL "是否发运" INIT YES.

DEFINE FRAME a
    SKIP(1)
    part COLON 15 part1 COLON 45
    wodate COLON 15 wodate1 COLON 45
    rcdate COLON 15 rcdate1 COLON 45
    irct COLON 30
    ishp COLON 30
    SKIP(1)
    WITH WIDTH 80 THREE-D TITLE "加工单报表"  SIDE-LABEL.

mainloop:
REPEAT:

    UPDATE part part1 wodate wodate1 rcdate rcdate1 irct ishp WITH FRAME a.
    IF  part1 = "" THEN part1 = hi_char.
    IF rcdate = ? THEN rcdate = 12/31/1900.
     IF rcdate1 = ? THEN rcdate1 = 01/01/3999.
      IF wodate = ? THEN wodate = 12/31/1900.
       IF wodate1 = ? THEN wodate1 = 01/01/3999.

    OUTPUT TO value("c:\trans.csv") NO-CONVERT.

    EXPORT DELIMITER "," 
         "零件号"  " 生产批号" "发运批号" "数量" "下线日期" "入库日期" "加工单日期" "加工单ID" "发运日期" "发运单".

    FOR EACH b_wod_det WHERE (b_wod_part >= part AND b_wod_part <= part1)
        AND (b_wod_date >= wodate AND b_wod_date <= wodate1)
        /*AND (b_wod_rct_date >= rcdate AND b_wod_rct_date <= rcdate1)*/
        AND ( b_wod_status = IF irct THEN "FINI-RCT" ELSE "")
        AND ( b_wod_status = IF ishp THEN "FINI-SHPPED" ELSE "")
        BREAK BY b_wod_part:
            ACCUMULATE b_wod_qty (TOTAL BY b_wod_part).
        IF FIRST-OF(b_wod_part) THEN DO:
              EXPORT DELIMITER ","
                  b_wod_part b_wod_batch "" (ACCUMU TOTAL BY b_wod_part b_wod_qty) b_wod_fin_date b_wod_rct_date b_wod_date b_wod_wonbr b_wod_shp_date b_wod_shipper.
        END.

        
    END.

  /*   EXPORT DELIMITER ","
                 "总计" "" "" "" gtot[1] gtot[2] gtot[3] gtot[4] gtot[5]
                 gtot[6] gtot[7] gtot[8] gtot[9] gtot[10] gtot[11] gtot[12] gtot[13] 
                 gtot[14] .*/


    OUTPUT CLOSE.
    CREATE "Excel.Application" hExcel.
    hExcel:VISIBLE = TRUE.                         
    hExcel:WorkBooks:OPEN( "c:\trans.csv"). 
    RELEASE OBJECT hExcel. 

END. /*repeat*/
