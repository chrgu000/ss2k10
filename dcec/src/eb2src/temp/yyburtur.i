FIND FIRST xxgl WHERE xxgl_acct = {&acc}
    AND xxgl_sub = {&sub} 
    AND xxgl_cc = {&cc} 
    AND xxgl_entity = data_entity NO-ERROR .
IF NOT AVAILABLE xxgl THEN DO :
    CREATE xxgl .
    xxgl_acct = {&acc} .
    xxgl_sub = {&sub} .
    xxgl_cc = {&cc} .
    xxgl_entity = data_entity .
END.
xxgl_amt = xxgl_amt + {&amt} .
