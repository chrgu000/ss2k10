/* xxmrpporp0.i - vender mrp po report                                       */
/* revision: 110826.1   created on: 20110826   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

define variable d as date.
DEFINE VARIABLE k AS INTEGER. 

DO k = 0 TO  19 WITH FRAME a.
    RUN getOrdDay(INPUT "W2,4,6",INPUT TODAY + k,INPUT 1,OUTPUT d).
    DISPLAY TODAY + k d.
END.


procedure getOrdDay:
  define input parameter iRule as character.
  define input parameter iDate as date.
  define input parameter iWeek as integer.
  define output parameter oDate as Date.
  
  DEFINE VARIABLE vRule AS CHARACTER.
  define variable i as integer.
/*   DEFINE VARIABLE j AS INTEGER. */
  
  ASSIGN vrule = substring(iRule,2).

  DEFINE VARIABLE startDay AS DATE.

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
  
  if substring(iRule,1,1) = "W" then do: 
     IF idate < startDay THEN DO:
         ASSIGN odate = idate.
     END.
     ELSE DO:
        odate = idate.
       
        getodate:
        DO i = 6 TO 1: 
            MESSAGE i odate VIEW-AS ALERT-BOX.
            REPEAT WHILE index(vrule,",") > 0 :
                IF INTEGER(substring(vrule,1,INDEX(vrule,",") - 1)) = weekday(odate) - 1 THEN DO:
                   LEAVE getodate.
                END.
                ASSIGN vrule = SUBSTRING(vrule,INDEX(vrule,",",+1)).
                MESSAGE vrule VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
            IF INTEGER(vrule) = WEEKDAY(odate) - 1 THEN DO:
                LEAVE getodate.
            END.
            
            odate = odate - 1.
        END.
     END.
  end. /* if substring(iRule,1,1) = "W" then do: */
  else if substring(iRule,1,1) = "M" then do:

  end. /* if substring(iRule,1,1) = "M" then do: */

end procedure.
