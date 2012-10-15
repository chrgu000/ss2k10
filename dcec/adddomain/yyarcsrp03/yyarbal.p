/**
 @File: yyarbal.p
 @Description: 扣除有效期外扣款
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: 扣除有效期外扣款
 @Todo: 
 @History: 
**/
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 08/20/12  ECO: *SS-20120820.1*   */


 /* *SS-20120820.1*   */ {mfdeclre.i}

DEF INPUT PARAMETER ref LIKE ard_ref .
DEF INPUT PARAMETER dt AS DATE .
DEF INPUT-OUTPUT PARAMETER a AS DEC .
        
FOR EACH ard_det NO-LOCK WHERE  /* *SS-20120820.1*   */ ard_det.ard_domain = global_domain and ard_ref = ref USE-INDEX ard_ref :
    FIND ar_mstr NO-LOCK WHERE  /* *SS-20120820.1*   */ ar_mstr.ar_domain = global_domain and ar_nbr = ard_nbr NO-ERROR .
    IF AVAILABLE ar_mstr AND ar_effdate > dt THEN a = a + (ard_amt / ar_ex_rate).
END.

FIND ar_mstr NO-LOCK WHERE /* *SS-20120820.1*   */ ar_mstr.ar_domain = global_domain and ar_nbr = ref NO-ERROR .
IF ar_type <> "P" THEN LEAVE .
FIND FIRST ard_det NO-LOCK WHERE /* *SS-20120820.1*   */ ard_det.ard_domain = global_domain and ard_nbr = ref AND ard_type = "u" NO-ERROR .
IF NOT AVAILABLE ard_det THEN LEAVE .
FOR EACH ar_mstr NO-LOCK WHERE /* *SS-20120820.1*   */ ar_mstr.ar_domain = global_domain and ar_check = SUBSTRING(ref,9) AND ar_type = "A" USE-INDEX ar_check :
    IF ar_effdate > dt THEN a = a - ar_base_applied .
END.

