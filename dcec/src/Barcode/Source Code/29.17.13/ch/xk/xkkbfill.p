DEFINE SHARED VARIABLE traceyes AS LOGICAL INITIAL YES .
{mfdeclre.i}

{kbconst.i}

DEFINE SHARED TEMP-TABLE rctkb
    FIELD seq11 AS INTEGER FORMAT "9999"
    FIELD kbid LIKE knbd_id
    FIELD part LIKE pt_part
    FIELD qty LIKE knbd_kanban_quantity 
    FIELD rct AS LOGICAL INITIAL YES
    INDEX kbid seq11 part kbid .

DEFINE VARIABLE a AS CHAR .
DEFINE VARIABLE b AS INTE .
DEFINE VARIABLE n AS INTE .

DEFINE SHARED VARIABLE effdate AS DATE .
DEFINE SHARED VARIABLE pnbr LIKE po_nbr .

FOR EACH rctkb WHERE rct :
    FIND LAST tr_hist no-lock NO-ERROR .
    IF NOT AVAILABLE tr_hist THEN 
       n = 0 .
    ELSE 
       n = tr_trnbr .

    IF traceyes THEN DO :
        OUTPUT TO trace.prn APPEND .
        PUT UNFORMATTED pnbr " " GLOBAL_userid  " " STRING(today) " " STRING(TIME,"hh:mm:ss") " " kbid " 看板交易开始 "  SKIP .
        OUTPUT CLOSE .
    END.

    {gprun.i ""xkkbtr.p""
             "({&KB-CARDEVENT-FILL}, kbid, effdate)"}
             pause 0 .

    IF traceyes THEN DO :
        OUTPUT TO trace.prn APPEND .
        PUT UNFORMATTED pnbr " " GLOBAL_userid " " STRING(today) " " STRING(TIME,"hh:mm:ss") " " kbid " 看板交易结束，开始填看板号进tr_hist "  SKIP .
        OUTPUT CLOSE .
    END.

    find first tr_hist where tr_trnbr > n and tr_userid = Global_userid 
                and tr_so_job = "" exclusive-lock no-error.
    if available tr_hist then do:        
                tr_nbr = pnbr .
                tr_so_job = string(kbid) .
                tr__dec01 = kbid.
    end .

    IF traceyes THEN DO :
        OUTPUT TO trace.prn APPEND .
        PUT UNFORMATTED pnbr " " GLOBAL_userid  " " STRING(today) " " STRING(TIME,"hh:mm:ss") " " kbid " 填看板号进tr_hist结束 "  SKIP .
        OUTPUT CLOSE .
    END.

END.

