/* xxmrpporp0.i - vender mrp po report                                       */
/* revision: 110826.1   created on: 20110826   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

DEFINE TEMP-TABLE tmp_int
    FIELDS ti_bk AS CHARACTER
    FIELDS ti_int AS INTEGER
    INDEX ti_bi ti_bk ti_int.

DEFINE TEMP-TABLE tmp_date
    FIELDS td_start AS DATE
    FIELDS td_end AS DATE
    INDEX td_start td_start.

procedure getOrdDay:
/*------------------------------------------------------------------------------
    Purpose: 获取送货日期
      Notes: 如果计算出的日期为非工作日则提前到第一个非工作日.
------------------------------------------------------------------------------*/
  define input parameter isite like si_site.
  define input parameter iRule as character.
  define input parameter iDate as date.
  define input parameter iWeek as integer.
  define output parameter oDate as Date.

  define variable startday as date.
  define variable vrule as character.
  DEFINE VARIABLE i AS INTEGER.
  DEFINE VARIABLE j AS INTEGER.
/*   define variable i as integer. */
/*   DEFINE VARIABLE j AS INTEGER. */

  ASSIGN vrule = substring(iRule,2).


  if substring(iRule,1,1) = "W" then do:
      IF WEEKDAY(TODAY) = 2 THEN DO:
          ASSIGN startDay = TODAY + 7.
      END.
      ELSE DO:
          startDay = TODAY.
          REPEAT:
              IF weekday(startDay) = 2 THEN DO:
                  LEAVE .
              END.
              startDay = startDay + 1.
          END.
      END.
      startDay = startDay + integer(ENTRY(1 , vrule , ",")) - 1.

     IF idate <= startDay THEN DO:
         ASSIGN odate = idate.
     END.
     ELSE DO:
        odate = idate.
        repeat-label01:
        REPEAT:
            ASSIGN vrule = substring(iRule,2).
            REPEAT:
                IF INTEGER(substring(vrule,1,INDEX(vrule,",") - 1)) =
                   weekday(odate) - 1 THEN DO:
                   LEAVE repeat-label01.
                END.
                ASSIGN vrule = SUBSTRING(vrule,INDEX(vrule,",") + 1).
                IF INDEX(vrule,",") = 0 THEN LEAVE.
            END.
            IF INTEGER(vRule) = WEEKDAY(odate) - 1 THEN LEAVE.
            odate = odate - 1.
        END.
     END.
  end.  /* if substring(iRule,1,1) = "W" then do: */
  else if substring(iRule,1,1) = "M" then do:
      EMPTY TEMP-TABLE tmp_int NO-ERROR.
      EMPTY TEMP-TABLE tmp_date NO-ERROR.

      REPEAT:
          ASSIGN i = integer(SUBSTRING(vrule,1,INDEX(vrule,",") - 1)).
          CREATE tmp_int.
          ASSIGN ti_bk = "A"
                 ti_int = i.

          vrule = SUBSTRING(vrule,INDEX(vrule,",") + 1).
          IF INDEX(vrule,",") = 0 THEN DO:
              ASSIGN i = integer(SUBSTRING(vrule,1,INDEX(vrule,",") - 1)) .
              CREATE tmp_int.
              ASSIGN ti_bk = "A"
                     ti_int = i.
              LEAVE.
          END.
      END.

      FOR EACH tmp_int BREAK BY ti_bk BY ti_int:
          IF FIRST-OF(ti_bk) THEN DO:
              CREATE tmp_date.
              ASSIGN td_end = DATE(MONTH(idate), ti_int,YEAR(idate)).
          END.
          CREATE tmp_date.
          ASSIGN td_start = DATE(MONTH(idate), ti_int,YEAR(idate)).

      END.
      FOR EACH tmp_date EXCLUSIVE-LOCK:
          FIND FIRST tmp_int WHERE ti_int > DAY(td_start) NO-ERROR.
          IF AVAILABLE(tmp_int) THEN DO:
              ASSIGN td_end = DATE(MONTH(td_start),ti_int,YEAR(td_start)).
          END.
      END.
      FOR EACH tmp_date EXCLUSIVE-LOCK WHERE td_start = ?:
          FIND LAST tmp_int NO-ERROR.
          IF AVAILABLE tmp_int THEN DO:
             ASSIGN td_start = date(month(td_end - DAY(td_end)), ti_int,
                               YEAR(td_end - DAY(td_end))).
          END.
      END.
      FOR EACH tmp_date EXCLUSIVE-LOCK WHERE td_end = ?:
          FIND FIRST tmp_int NO-ERROR.
          IF AVAILABLE tmp_int THEN DO:
             ASSIGN td_end = date(MONTH(td_start),28,YEAR(td_start)).
             ASSIGN td_end = DATE(MONTH(td_end + 5),ti_int,YEAR(td_end + 5)).
          END.
      END.
      FOR EACH tmp_date EXCLUSIVE-LOCK:
          ASSIGN td_end = td_end - 1.
      END.
      FIND FIRST tmp_date WHERE idate >= td_start AND idate <= td_end NO-ERROR.
      IF AVAILABLE tmp_date THEN DO:
          ASSIGN odate = td_start.
      END.

  end.  /* if substring(iRule,1,1) = "M" then do: */

  /* 如果送货日期为节假日则推到上一个工作日 */
  REPEAT: /*假日*/
     IF CAN-FIND(FIRST hd_mstr NO-LOCK WHERE
                       hd_site = isite AND hd_date = odate) THEN DO:
        ASSIGN odate = odate - 1.
     END.
     ELSE DO:
         LEAVE.
     END.
  END. /* REPEAT: 假日*/
end procedure.
