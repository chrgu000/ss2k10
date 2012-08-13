{mfdtitle.i}

DEFINE OUTPUT PARAMETER sucess AS LOGICAL INITIAL FALSE.

DEFINE VARIABLE bcode AS CHARACTER label "条码".
DEFINE TEMP-TABLE co_list
    FIELD co_part AS CHARACTER
    FIELD co_qty_req AS DECIMAL
    FIELD co_qty_iss AS DECIMAL
    FIELD co_qty_bo AS DECIMAL
    FIELD co_site AS CHARACTER
    FIELD co_loc AS CHARACTER.
DEFINE TEMP-TABLE cot_tmp
    FIELD cot_code LIKE b_co_code
    FIELD cot_part LIKE b_co_part.

DEFINE shared temp-table xkprhhist
             field xkprhnbr      as char format "x(8)"
             field xkprhponbr    as char format "x(8)"
             field xkprhline     as integer format ">,>>>,>>9"
             field xkprhpart     as char format "x(18)"
             field xkprhrctdate  as date format "99/99/99"
             field xkprheffdate  as date format "99/99/99"
             field xkprhqty      as decimal format ">>,>>9.99"
             field xkprhvend     as char format "x(8)"
             field xkprhdsite    as char format "x(8)"
             field xkprhdloc     as char format "x(18)"
             field xkprhssite    as char format "x(18)"
             field xkprhssloc    as char format "x(18)"       
             field xkprhinrcvd   as logical 
             field xkprhregion   as char format "x(8)"
             field xkprhkbid     as char format "x(20)"
             index  xkprhinrcvd xkprhinrcvd xkprhponbr xkprheffdate.

DEFINE QUERY q_prh FOR xkprhhist.
DEFINE QUERY q_co FOR co_list.
DEFINE BROWSE b_co QUERY q_co 
    DISP co_part   LABEL "零件"
             co_qty_req LABEL "需求量"
             co_qty_iss LABEL "发放量"
             co_qty_bo LABEL "B/O"
             co_site LABEL "地点"
             co_loc LABEL "库位"
    WITH 10 DOWN SEPARATORS /*MULTIPLE*/ SIZE 60 BY 20 TITLE "零件明细" THREE-D EXPANDABLE.
DEFINE BUTTON btn_conf LABEL "确认".

FORM
    bcode  SKIP
    b_co SKIP
    btn_conf
WITH FRAME a SIDE-LABEL THREE-D WIDTH 80.

FOR EACH xkprhhist:
     CREATE co_list.
        co_part = xkprhpart.
        co_qty_req = xkprhqty.
        co_qty_iss = 0.
        co_qty_bo = xkprhqty.
        co_site = xkprhdsite.
        co_loc = xkprhdloc.
END.

/*CREATE co_list.
co_part = "a".
co_qty_req = 100.*/

 OPEN QUERY q_co  FOR EACH co_list.

main-loop:
REPEAT ON ERROR UNDO, LEAVE
              ON ENDKEY UNDO, LEAVE: 
           
    REPEAT:
      UPDATE bcode b_co  WITH FRAME a.

      FIND FIRST b_co_mstr NO-LOCK WHERE b_co_code = bcode:SCREEN-VALUE NO-ERROR.
      IF AVAILABLE b_co_mstr THEN DO:
        FIND FIRST co_list EXCLUSIVE-LOCK WHERE co_part = b_co_part NO-ERROR.
        IF AVAILABLE co_list THEN DO:
             co_qty_iss = co_qty_iss + b_co_qty_cur.
             co_qty_bo = co_qty_req - co_qty_iss.
             CREATE cot_tmp.
               cot_code = b_co_code.
               cot_part = co_part.
        END.
        ELSE DO:
            LEAVE main-loop.
        END.
     END.
     ELSE DO:
        MESSAGE "条码无效" VIEW-AS ALERT-BOX.
        LEAVE main-loop.
     END.

     OPEN QUERY q_co FOR EACH co_list.
    END.  /*repeat*/
    
    DEFINE VARIABLE yn AS LOGICAL.
    MESSAGE "确认完成扫描？" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE yn.
    IF yn = YES THEN DO:
    
      FOR EACH co_list NO-LOCK:
         IF co_qty_bo <> 0 THEN DO:
            MESSAGE "条码数和收货数不匹配！".
            NEXT main-loop.
         END.
         ELSE DO:
           /*更改条码状态及移库*/
             FOR EACH cot_tmp, EACH b_co_mstr   WHERE co_part = cot_part AND  cot_code = b_co_code,
                 EACH b_ld_det WHERE b_ld_code = b_co_code:
                        {bcrun.i ""bcmgwrbf.p""   "(INPUT """",
                                      INPUT 0,
                                      INPUT b_co_code,
                                      INPUT b_co_part,
                                      INPUT b_co_lot,
                                      INPUT b_co_ser,
                                      INPUT b_co_ref,
                                      INPUT b_co_qty_cur,
                                      INPUT b_co_um,
                                      INPUT TODAY,
                                      INPUT ?,
                                      INPUT ?,
                                      INPUT """",
                                      INPUT 0,
                                      INPUT b_ld_loc,
                                      INPUT b_ld_site,
                                      INPUT ""iclotr02.p"",
                                      INPUT co_site,
                                      INPUT co_loc,
                                      INPUT """",
                                      INPUT """",
                                      INPUT """",
                                      INPUT """",
                                      INPUT """",
                                      INPUT """",
                                      INPUT """",
                                      INPUT """",
                                      INPUT """"
                                     /* OUTPUT bid*/ )"}
                          {bcrun.i ""bcmgwrfl.p"" "(INPUT ""iclotr02""  /*,input bid*/ )"}
             END.
           sucess = TRUE.
           LEAVE main-loop. 
         END.  /*更改条码状态*/

      END.  /*for each co_list*/
    END.

    ELSE IF yn = NO THEN DO:
       NEXT  main-loop.
    END.

    ELSE IF yn = ? THEN DO:
       LEAVE main-loop.
    END. /*是否完成条码扫描*/
END. /*repeat*/

