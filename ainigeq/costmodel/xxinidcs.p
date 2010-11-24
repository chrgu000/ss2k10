/* initial set xxdcs_element applay to sct_sim */
FOR EACH CODE_mstr EXCLUSIVE-LOCK WHERE CODE_fldname = "xxdcs_element":
    if code_value = "material" then assign code_user1 = "1".
    IF CODE_value = "labor" THEN ASSIGN CODE_user1 = "2".
    IF CODE_value = "Burden" THEN ASSIGN CODE_user1  = "3".
    IF CODE_value = "overhead" THEN ASSIGN CODE_user1  = "4" code__qadc01 = 'x'.
    IF CODE_value = "subcontr" THEN ASSIGN CODE_user1  = "5" code__qadc01 = 'x'.
    DISPLAY CODE_value CODE_cmmt CODE__qadc01 CODE_user1.
END.
