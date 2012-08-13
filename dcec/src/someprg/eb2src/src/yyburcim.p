/**
 @File: yyburcim.p
 @Description: 生成制造费用结转cimload格式文件
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: 生成制造费用结转cimload格式文件
 @Todo: 
 @History: 
**/

DEF INPUT PARAMETER cimf AS CHAR .
DEF INPUT PARAMETER effdate LIKE glt_effdate .
DEF OUTPUT PARAMETER rok1 AS LOG .

{mfdeclre.i}
{yyburdef.i}

DEF VAR curr LIKE gl_base_curr .
DEF VAR rate AS DEC .
DEF VAR rok2 AS LOG .
DEF VAR buracc LIKE acd_acc .
DEF VAR burcccr LIKE acd_cc .
DEF VAR burccdr LIKE acd_cc .
DEF VAR amt1 AS DEC .
DEF VAR amt2 AS DEC .
DEF VAR codecc AS CHAR .

DEF TEMP-TABLE data0
    FIELD data0_acc LIKE acd_acc
    FIELD data0_cc LIKE acd_cc
    FIELD data0_entity LIKE acd_entity 
    FIELD data0_amt LIKE acd_amt .

DEF SHARED TEMP-TABLE xxgl
    FIELD xxgl_acct LIKE glt_acct
    FIELD xxgl_sub LIKE glt_sub
    FIELD xxgl_cc LIKE glt_cc
    FIELD xxgl_entity LIKE glt_entity 
    FIELD xxgl_amt LIKE glt_amt .

DEF TEMP-TABLE err
    FIELD err_cc AS CHAR FORMAT "x(6)" LABEL "成本中心" .

rok1 = NO .
FIND FIRST gl_ctrl NO-LOCK NO-ERROR .
curr = gl_base_curr .

rate = (bsales + bdiscount) / (bsales + csales + bdiscount + cdiscount) .

FOR EACH xxgl :
    DELETE xxgl .
END.

FOR EACH err :
    DELETE err .
END.

FOR EACH data0 :
    DELETE data0 .
END.

rok2 = YES .
FIND FIRST CODE_mstr NO-LOCK WHERE CODE_fldname = "allbur" NO-ERROR .
IF NOT AVAILABLE CODE_mstr THEN rok2 = NO .
ELSE DO :
    FIND ac_mstr NO-LOCK WHERE ac_code = CODE_value NO-ERROR .
    IF NOT AVAILABLE ac_mstr THEN rok2 = NO .
    FIND cc_mstr NO-LOCK WHERE cc_ctr = CODE_cmmt
        AND cc_active = YES NO-ERROR .
    IF NOT AVAILABLE cc_mstr THEN rok2 = NO .
END.
IF rok2 = NO THEN DO :
    MESSAGE "检查制造费用结转设置！" VIEW-AS ALERT-BOX ERROR .
    LEAVE .
END.
ELSE DO :
    buracc = CODE_value .
    burcccr = CODE_cmmt .
END.

FIND FIRST data NO-LOCK WHERE data_sub <> "0" AND data_sub <> "1" AND data_sub <> "2" NO-ERROR .
IF AVAILABLE data THEN DO :
    MESSAGE "检查制造费用分账户！" VIEW-AS ALERT-BOX ERROR .
    LEAVE .
END.

FOR EACH data WHERE data_sub = "0" :
    CREATE data0 .
    data0_acc = data_acc .
    data0_cc = data_cc .
    data0_entity = data_entity .
    data0_amt = data_amt .
    DELETE data .
END.

FOR EACH data0 NO-LOCK :
    CREATE data .
    data_acc = data0_acc .
    data_sub = "1" .
    data_cc = data0_cc .
    data_entity = data0_entity .
    data_amt = data0_amt * rate .

    CREATE data .
    data_acc = data0_acc .
    data_sub = "2" .
    data_cc = data0_cc .
    data_entity = data0_entity .
    data_amt = data0_amt - data0_amt * rate .
END.

/*create xxgl*/
FOR EACH data NO-LOCK BREAK BY data_sub BY data_cc :
    IF FIRST-OF(data_cc) THEN DO :
        rok2 = YES .
        IF data_sub = "1" THEN codecc = "all-b" .
        ELSE codecc = "all-c" .

        FIND CODE_mstr NO-LOCK WHERE CODE_fldname = codecc
            AND CODE_value = data_cc NO-ERROR .
        IF NOT AVAILABLE CODE_mstr THEN DO :
            FIND CODE_mstr NO-LOCK WHERE CODE_fldname = codecc
                AND CODE_value = "xxxx" NO-ERROR .
        END.

        IF NOT AVAILABLE CODE_mstr THEN DO :
            CREATE err .
            err_cc = data_sub + "-" + data_cc .
            rok2 = NO .
        END.
        ELSE DO :
            FIND cc_mstr NO-LOCK WHERE cc_ctr = CODE_cmmt
                AND cc_active = YES NO-ERROR .
            IF NOT AVAILABLE cc_mstr THEN DO :
                CREATE err .
                err_cc = data_sub + "-" + data_cc .
                rok2 = NO .
            END.
            ELSE burccdr = CODE_cmmt .
        END.
    END.
    IF rok2 = NO THEN NEXT .

    data_amt = ROUND(data_amt,2) .

    {yyburtur.i
        &acc = "buracc"
        &sub = "data_sub"
        &cc = "burccdr"
        &amt = "data_amt"
     }
    {yyburtur.i
        &acc = "data_acc"
        &sub = "data_sub"
        &cc = "burcccr"
        &amt = "- data_amt"
     }

END. /*for each data - create xxgl*/

FIND FIRST err NO-LOCK NO-ERROR .
IF AVAILABLE err THEN DO :
    OUTPUT TO "cc-err.prn" .
    FOR EACH err :
        DISPLAY err_cc .
    END.
    OUTPUT CLOSE .
    MESSAGE "检查制造费用成本中心设置！cc-err.prn" VIEW-AS ALERT-BOX ERROR .
    LEAVE .
END.

OUTPUT TO VALUE(cimf) .

PUT UNFORMATTED
    "@@batchload gltrmt.p" SKIP
    "-" SKIP
    effdate SKIP(1) .

FOR EACH xxgl WHERE xxgl_amt <> 0 :
    PUT UNFORMATTED 
        "-" SKIP
        "~"" xxgl_acct "~" ~"" xxgl_sub "~" ~"" xxgl_cc "~"" SKIP
        "~"" xxgl_entity "~"" SKIP(1)
        "~"" curr "~"" SKIP
        xxgl_amt FORMAT "->>,>>>,>>>,>>9.99" SKIP .
END.

PUT UNFORMATTED
    "." SKIP
    "." SKIP
    "@@end" SKIP .

OUTPUT CLOSE .

rok1 = YES .

