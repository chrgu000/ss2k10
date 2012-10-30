    DEF VAR del-yn AS INTE INIT 0.
    FOR EACH xxppif_log WHERE xxppif__chr01 > "0".
 
        .
    IF del-yn = 0  THEN
        DISP xxppif_log 
        WITH WIDTH 320 STREAM-IO.
        
        IF del-yn = 1  THEN do:
           DELETE xxppif_log.
            PAUSE 0.
        END.
END.
