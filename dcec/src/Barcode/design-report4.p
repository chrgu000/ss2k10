DEFINE VAR num AS INT.
DEFINE VAR num1 AS INT.
DEFINE VAR cust AS CHAR FORMAT "x(20)".
DEFINE VAR cust1 AS CHAR FORMAT "x(20)".

FORM
    SKIP(2)
    num COLON 15 LABEL "客户编号"
    num1 COLON 45 LABEL "至"
    SKIP(1)
    cust COLON 15 LABEL "客户名"
    cust1 COLON 45 LABEL "至"
    SKIP(2)
    WITH FRAME a WIDTH 80 THREE-D TITLE "客户信息" SIDE-LABEL.

FORM HEADER
    "customer report" AT 30
    SKIP(2)
    PAGE-NUMBER AT 10
    TODAY AT 40
    WITH PAGE-TOP FRAME phead WIDTH 80 NO-BOX SIDE-LABEL.

DEFINE FRAME pbody
    cust.cust-num
    NAME
    cust.country
    WITH WIDTH 80 NO-BOX DOWN USE-TEXT STREAM-IO.

FORM HEADER
    "approve:_____" AT 1
    "check:______" AT 30
    "user:______" AT 60
    WITH PAGE-BOTTOM FRAME pbottom WIDTH 80 NO-BOX.

REPEAT :

DISPLAY cust cust1 WITH FRAME a.
ENABLE ALL WITH FRAME a.
WAIT-FOR GO OF FRAME a.

ASSIGN
    num
    num1
    cust
    cust1.

IF cust1 = ""  THEN cust1 = "zzzzzz".
IF num1 = 0  THEN num1 = 9999999.
 
OUTPUT TO TERMINAL PAGE-SIZE 30 PAGED.
VIEW FRAME phead.
VIEW FRAME pbottom.
FOR EACH customer WHERE
    (cust-num >= num AND cust-num <= num1)AND(NAME >= cust AND NAME <= cust1):
    DISPLAY 
        cust.cust-num
        NAME
        cust.country
        WITH FRAME pbody.
END.
VIEW FRAME pbottom.
OUTPUT CLOSE.
END.
WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW.
