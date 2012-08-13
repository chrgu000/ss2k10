/**
 @File: yyarpay.p
 @Description: 计算支票支付凭证金额
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: 计算支票支付凭证金额
 @Todo: 
 @History: 
**/

DEF INPUT PARAMETER nbr LIKE ard_nbr .
DEF OUTPUT PARAMETER amt LIKE ar_amt .
DEF OUTPUT PARAMETER baseamt LIKE ar_base_amt .

DEF VAR amt0 AS DEC .
DEF VAR curr AS CHAR .

FIND ar_mstr NO-LOCK WHERE ar_nbr = nbr NO-ERROR .
curr = ar_curr .

amt = 0 .
baseamt = 0 .

FOR EACH ard_det NO-LOCK WHERE ard_nbr = nbr AND ard_type <> "N" AND ard_type <> "D" :
    FIND ar_mstr NO-LOCK WHERE ar_nbr = ard_ref NO-ERROR .
    IF NOT AVAILABLE ar_mstr THEN NEXT .
    IF ard_amt = 0 THEN amt0 = 0 .
    ELSE DO :
        IF curr <> ar_curr THEN amt0 = ard_cur_amt .
        ELSE amt0 = ard_amt .
    END.
    amt = amt - amt0 .
    baseamt = baseamt - amt0 * ar_ex_rate2 / ar_ex_rate .
END.
