  
    FOR EACH {1} WHERE {4} = mfguser EXCLUSIVE-LOCK:
        FIND FIRST CODE_mstr WHERE CODE_fldname = 'pt_part' AND CODE_cmmt = {2} NO-LOCK NO-ERROR.
        IF AVAILABLE CODE_mstr THEN 
        {2} = CODE_value.
      ELSE DO:
       FIND FIRST code_mstr WHERE code_fldname = 'part_prefix' AND code_value = SUBSTR({2},1,3) NO-LOCK NO-ERROR.
    IF AVAILABLE code_mstr THEN {2} = SUBSTR({2},1,3) + STRING(TIME) + SUBstr(STRING(ETIME),LENGTH(STRING(ETIME)) - 3) + SUBSTR({2}, LENGTH({2}) - 3).
          END.
        IF {3} <> '' THEN DO:
           FIND FIRST CODE_mstr WHERE CODE_fldname = 'pt_part' AND CODE_cmmt = {3} NO-LOCK NO-ERROR.
             IF AVAILABLE CODE_mstr THEN {3} = CODE_value.
           ELSE DO:
          FIND FIRST code_mstr WHERE code_fldname = 'part_prefix' AND code_value = SUBSTR({3},1,3) NO-LOCK NO-ERROR.
      IF AVAILABLE code_mstr THEN {3} = SUBSTR({3},1,3) + STRING(TIME) + SUBstr(STRING(ETIME),LENGTH(STRING(ETIME)) - 3)  + SUBSTR({3}, LENGTH({3}) - 3).
           END.
   
        END.
END.
