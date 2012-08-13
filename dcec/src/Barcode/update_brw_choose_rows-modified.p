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
 DEFINE VAR standard AS LOGICAL VIEW-AS FILL-IN SIZE 5 BY 1 FORMAT "Yes/No" LABEL "±ê×¼".

DEFINE FRAME fr-brws
       brw SKIP (1)
       b-done AT COLUMN 35 ROW 10.5 SKIP (1)
       WITH SIZE-CHARS 80 BY 13.
DEFINE FRAME test
customer.cust-num COLON 20
    customer.NAME COLON 40
    SKIP(1)
    customer.contact COLON 20
    customer.phone COLON 40
    SKIP(1)
    standard COLON 20 
    WITH WIDTH 80 THREE-D SIDE-LABEL.
REPEAT:
    OPEN QUERY qry1 FOR EACH customer.
ENABLE ALL WITH FRAME fr-brws.
  
ON 'choose':U OF b-done
DO:
    DISABLE ALL WITH FRAME fr-brws.
     i = brw:NUM-SELECTED-ROWS.
        brw:FETCH-SELECTED-ROW(i).        
    DISPLAY customer.cust-num customer.NAME customer.contact customer.phone WITH FRAME test.
   UPDATE standard WITH FRAME test.
END.

  WAIT-FOR CHOOSE OF b-done.


END.
