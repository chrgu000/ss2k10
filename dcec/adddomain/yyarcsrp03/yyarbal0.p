/**
 @File: yyarbal0.p
 @Description: 计算指定日期客户应收帐款余额
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: 计算指定日期客户应收帐款余额
 @Todo: 
 @History: 
**/
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 08/20/12  ECO: *SS-20120820.1*   */

DEF INPUT PARAMETER cust AS CHAR .
DEF INPUT PARAMETER dt AS DATE .
DEF OUTPUT PARAMETER amt AS DEC .

{mfdeclre.i}

amt = 0 .
FOR EACH ar_mstr NO-LOCK WHERE  /* *SS-20120820.1*   */ ar_mstr.ar_domain = global_domain and ar_bill = cust AND ar_effdate <= dt AND ar_type <> "d" :

    if ar_type = "D" and not ar_draft then next.

    amt = amt + ar_base_amt - ar_base_applied .

    {gprun.i ""yyarbal.p"" "(input ar_nbr,
        INPUT dt,
        INPUT-OUTPUT amt)"
    }

END.
