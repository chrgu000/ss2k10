/*Cai last modified by 05/20/2004*/
UpdBlock:
DO ON ENDKEY UNDO, LEAVE
    ON ERROR UNDO, LEAVE :

    FIND usrw_wkfl WHERE RECID(usrw_wkfl) = w-rid[FRAME-LINE(f-errs)] NO-ERROR .
    IF NOT AVAILABLE usrw_wkfl THEN LEAVE UpdBlock .
    DISPLAY usrw_charfld[11]
            usrw_intfld[2]
	        usrw_key2
            usrw_charfld[1]
            usrw_decfld[2]
	        usrw_charfld[12]
            usrw_logfld[1] WITH FRAME f-errs .



    UPDATE usrw_logfld[1] WITH FRAME f-errs .

END.
