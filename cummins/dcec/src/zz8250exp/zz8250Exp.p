DEFINE VARIABLE fPath as character initial "F:\appeb2\batch\outbox\".
find first usrw_wkfl no-lock where usrw_domain = "dcec"
	   and usrw_key1 = "ZZ8250EXP.P-CTRL" and usrw_key2 = "ZZ8250EXP.P-CTRL" NO-ERROR.
IF AVAILABLE USRW_WKFL THEN DO:
    ASSIGN fpath = usrw_key3.
END.
OUTPUT TO value(fPath + "8250Expense.txt").
FOR EACH gltr_hist WHERE gltr_domain = "dcec" and gltr_ctr = "8250"
		 AND gltr_eff_dt >= TODAY - 32  AND gltr_eff_dt <= TODAY - 1 AND
     (gltr_acc <> "5502079" AND gltr_acc <> "5502102" AND gltr_acc <> "5502102" AND gltr_acc <> "5502110"
       AND gltr_acc <> "5502105" AND gltr_acc <> "5502104" AND gltr_acc <> "5502107" AND gltr_acc <> "5502108" AND gltr_acc <> "5502106" ) NO-LOCK.
    FIND FIRST ac_mstr WHERE ac_code = gltr_acc NO-LOCK NO-ERROR.
    DISP gltr_acc ac_desc gltr_sub gltr_ctr gltr_project gltr_eff_dt gltr_ecur_amt gltr_desc WITH WIDTH 300 STREAM-IO.
END.
output close.
quit.
