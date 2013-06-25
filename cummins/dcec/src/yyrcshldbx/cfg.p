
FOR EACH CODE_mstr EXCLUSIVE-LOCK WHERE CODE_domain = "DCEC"
    AND CODE_fldname = "xx-box-data" AND CODE_value = "0001":
    DISPLAY CODE_fldname code_value CODE_desc CODE_user2.
    ASSIGN code_cmmt = "BOX data"
           CODE_desc = "woodbox"
           code_user1 = "CTN71"
           CODE_user2 = "temp".
END.