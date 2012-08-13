DEFINE BUTTON b-done LABEL "Done" SIZE 12 BY 1.5.
DEFINE QUERY qry1 FOR customer.
DEFINE VAR i AS INT INITIAL 0.
DEFINE BROWSE brw QUERY qry1
    DISPLAY customer.cust-num
            customer.NAME
            customer.contact
            customer.phone
    ENABLE customer.NAME customer.contact customer.phone
    WITH 9 DOWN WIDTH 77 TITLE "Customers Contacts" LABEL-FGCOLOR 15 LABEL-BGCOLOR 9 MULTIPLE SEPARATORS.

DEFINE FRAME fr-brws
       brw SKIP (1)
       b-done AT COLUMN 35 ROW 10.5 SKIP (1)
       WITH SIZE-CHARS 80 BY 13.

ON 'choose':U OF b-done
DO:
    REPEAT i = brw:NUM-SELECTED-ROWS TO 1 BY -1:
        brw:FETCH-SELECTED-ROW(i).
            DISPLAY customer.cust-num customer.NAME customer.contact customer.phone.
    END.
END.

OPEN QUERY qry1 FOR EACH customer.
ENABLE ALL WITH FRAME fr-brws.
WAIT-FOR CHOOSE OF b-done.
