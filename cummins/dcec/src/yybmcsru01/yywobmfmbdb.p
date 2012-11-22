{mfdeclre.i}


DEFINE INPUT  PARAMETER inp-part AS CHAR.
DEFINE INPUT  PARAMETER inp-bomcode AS CHAR.
DEFINE INPUT  PARAMETER inp-site AS CHAR.
DEFINE INPUT  PARAMETER inp-date AS DATE.
DEFINE OUTPUT PARAMETER inp-results AS CHAR.



{gpxpld01.i "new shared"}

DEFINE NEW SHARED TEMP-TABLE ttx1
    FIELDS ttx1_woid LIKE wo_lot
    FIELDS ttx1_part AS CHAR.


RUN xxpro-initial.
RUN xxpro-chk-cwo (INPUT inp-part, INPUT inp-site, INPUT inp-date).
RUN xxpro-report.



/*-----------------------------------------------------*/
PROCEDURE xxpro-initial:
    FOR EACH ttx1:
        DELETE ttx1.
    END.
END PROCEDURE.
/*-----------------------------------------------------*/
PROCEDURE xxpro-report:
    inp-results = "".
    FOR EACH ttx1 NO-LOCK:
        inp-results = inp-results + (IF inp-results = "" THEN "" ELSE ",") + ttx1_woid.
    END.
END PROCEDURE.

/*-----------------------------------------------------*/
PROCEDURE xxpro-chk-cwo:
    DEFINE INPUT PARAMETER p_part AS CHAR.
    DEFINE INPUT PARAMETER p_site AS CHAR.
    DEFINE INPUT PARAMETER p_date AS DATE.

    FOR EACH wo_mstr 
        WHERE wo_domain = global_domain 
        and   wo_type = "C"
        AND   wo_part = p_part
        AND   wo_nbr  = ""
        AND   wo_lot  <> ""
        and   wo_status <> "C" 
        AND   wo_site = p_site
        /*AND   wo_due_date <=  p_date*/

        NO-LOCK 
        USE-INDEX wo_type_part:

        CREATE ttx1.
        ASSIGN ttx1_woid = wo_lot
               ttx1_part = p_part.
    END.

    /*need to add check case as: cwo is not create by backflush*/
    /*...*/
END PROCEDURE.


