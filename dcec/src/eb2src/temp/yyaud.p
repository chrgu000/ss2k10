DEF INPUT PARAMETER tbname AS CHAR .
DEF INPUT PARAMETER fdname AS CHAR .
DEF INPUT PARAMETER keyval AS CHAR .
DEF INPUT PARAMETER olddata AS CHAR .
DEF INPUT PARAMETER newdata AS CHAR .

DEF VAR oldentry LIKE aud_entry .
DEF VAR oldseq AS INTEGER .

{mfdeclre.i}

DO TRANSACTION ON ERROR UNDO, LEAVE :

    FIND LAST aud_det NO-LOCK NO-ERROR .
    IF AVAILABLE aud_det THEN oldentry = aud_entry .
    ELSE oldentry = 0 .

    FIND LAST aud_det WHERE aud_dataset = tbname
        AND aud_key1 = keyval USE-INDEX aud_dataset NO-LOCK NO-ERROR .
    IF AVAILABLE aud_det THEN oldseq = INTEGER(aud_key2) .
    ELSE oldseq = 0 .

    CREATE aud_det .
    aud_entry = oldentry + 1 .
    aud_dataset = tbname .
    aud_userid = global_userid .
    aud_date = TODAY .
    aud_time = STRING(TIME,"hh:mm:ss") .
    aud_key1 = keyval .
    aud_key2 = STRING(oldseq + 1,"99999999") .
    aud_field = fdname .
    aud_old_data[1] = olddata .
    aud_new_data[1] = newdata .

END.



        
            
            
