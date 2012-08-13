/**
 @File: yyexpdu1.p
 @Description: 费用报表输出excel
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: 费用报表输出excel
 @Todo: 
 @History: 
**/

DEF INPUT PARAMETER outfile AS CHAR .

{mfdeclre.i}
{yyburdef.i}

DEF VAR i AS INTEGER .
DEF VAR t AS INTEGER .
DEF VAR rate AS DEC .
DEF VAR tot AS DEC .
DEF VAR totb1 AS DEC .
DEF VAR totc1 AS DEC .
DEF VAR totb0 AS DEC .
DEF VAR totc0 AS DEC .
DEF VAR totb AS DEC .
DEF VAR totc AS DEC .
DEF VAR tot0 AS DEC .

DEF TEMP-TABLE datasum
    FIELD s_line AS INT
    FIELD s_acc LIKE acd_acc
    FIELD s_tot LIKE acd_amt
    FIELD s_totb1 LIKE acd_amt
    FIELD s_totc1 LIKE acd_amt
    FIELD s_tot0 LIKE acd_amt
    FIELD s_totb0 LIKE acd_amt
    FIELD s_totc0 LIKE acd_amt
    FIELD s_totb LIKE acd_amt
    FIELD s_totc LIKE acd_amt .

DEF TEMP-TABLE head
    FIELD head_t AS INTEGER 
    FIELD head_sub LIKE acd_sub 
    FIELD head_cc LIKE acd_cc 
    FIELD head_amt LIKE acd_amt .

define variable excelapp as com-handle.
define variable excelworkbook as com-handle.
define variable excelsheetmain as com-handle.

create "Excel.Application" excelapp.
excelworkbook = excelapp:workbooks:add().
excelsheetmain = excelapp:sheets:item(1).

i = 1 .

IF expense THEN DO :
    rate = (bsales + bdiscount) / (bsales + csales + bdiscount + cdiscount) .
    excelsheetmain:cells(1,1) = "年月" .
    excelsheetmain:cells(2,2) = "产品销售收入" .
    excelsheetmain:cells(3,2) = "产品销售折扣与折让" .
    excelsheetmain:cells(4,2) = "产品销售收入净额" .
    excelsheetmain:cells(5,2) = "分摊比例" .
    excelsheetmain:cells(1,3) = "Total" .
    excelsheetmain:cells(1,4) = "B" .
    excelsheetmain:cells(1,5) = "C" .
    excelsheetmain:cells(2,3) = - (bsales + csales) .
    excelsheetmain:cells(2,4) = - bsales .
    excelsheetmain:cells(2,5) = - csales .
    excelsheetmain:cells(3,3) = bdiscount + cdiscount .
    excelsheetmain:cells(3,4) = bdiscount .
    excelsheetmain:cells(3,5) = cdiscount .
    excelsheetmain:cells(4,3) = - (bsales + csales + bdiscount + cdiscount) .
    excelsheetmain:cells(4,4) = - (bsales + bdiscount) .
    excelsheetmain:cells(4,5) = - (csales + cdiscount) .
    excelsheetmain:cells(5,3) = 1 .
    excelsheetmain:cells(5,4) = rate .
    excelsheetmain:cells(5,5) = 1 - rate .
    i = 7 .
END.

excelsheetmain:cells(i,1) = "创建时间：" + STRING(TODAY,"99/99/99") + "-" + STRING(TIME,"hh:mm:ss") .
i = i + 1 .

FOR EACH head :
    DELETE head .
END.

FOR EACH data NO-LOCK :
    FIND head WHERE head_sub = data_sub
                AND head_cc = data_cc NO-ERROR .
    IF NOT AVAILABLE head THEN DO :
        CREATE head .
        head_sub = data_sub .
        head_cc = data_cc .
    END.
END.

t = 2 .
FOR EACH head BY head_sub DESCENDING BY head_cc :
    t = t + 1 .
    head_t = t .
END.

FOR EACH head NO-LOCK BY head_t :
    IF head_sub = "2" THEN excelsheetmain:cells(i,head_t) = "C区" .
    IF head_sub = "1" THEN excelsheetmain:cells(i,head_t) = "B区" .
    IF head_sub = "0" THEN excelsheetmain:cells(i,head_t) = "公共" .
    IF head_sub <> "2" AND head_sub <> "1" AND head_sub <> "0" THEN excelsheetmain:cells(i,head_t) = head_sub .
END.

i = i + 1 .
excelsheetmain:cells(i,1) = "code" .
excelsheetmain:cells(i,2) = "Expense Item" .
FOR EACH head NO-LOCK BY head_t :
    FIND FIRST cc_mstr NO-LOCK WHERE cc_ctr = head_cc NO-ERROR .
    excelsheetmain:cells(i,head_t) = head_cc + SUBSTRING(cc_desc,R-INDEX(cc_desc,"-") + 1) . 
END.
excelsheetmain:cells(i,t + 1) = "费用合计" .
excelsheetmain:cells(i,t + 2) = "B确定数" .
excelsheetmain:cells(i,t + 3) = "C确定数" .
IF expense THEN DO :
    excelsheetmain:cells(i,t + 4) = "B分摊数" .
    excelsheetmain:cells(i,t + 5) = "C分摊数" .
    excelsheetmain:cells(i,t + 6) = "B总计" .
    excelsheetmain:cells(i,t + 7) = "C总计" .
END.
ELSE DO :
    excelsheetmain:cells(i,t + 4) = "公共数" .
END.


FOR EACH datasum :
    DELETE datasum .
END.

FOR EACH data NO-LOCK :
    FIND datasum WHERE s_acc = data_acc NO-ERROR .
    IF NOT AVAILABLE datasum THEN DO :
        CREATE datasum .
        s_acc = data_acc .
    END.
    s_tot = s_tot + data_amt .
    IF data_sub = "1" THEN s_totb1 = s_totb1 + data_amt .
    IF data_sub = "2" THEN s_totc1 = s_totc1 + data_amt .
    IF data_sub = "0" THEN s_tot0 = s_tot0 + data_amt .
END.

FOR EACH datasum BY s_acc :
    i = i + 1 .
    s_line = i .
    s_totb0 = s_tot0 * rate .
    s_totc0 = s_tot0 - s_totb0 .
    s_totb = s_totb1 + s_totb0 .
    s_totc = s_totc1 + s_totc0 .
END.

tot = 0 .
totb1 = 0 .
totc1 = 0 .
totb0 = 0 .
totc0 = 0 .
totb = 0 .
totc = 0 .
FOR EACH datasum NO-LOCK :
    excelsheetmain:cells(s_line,1) = "'" + s_acc .
    FIND ac_mstr NO-LOCK WHERE ac_code = s_acc NO-ERROR .
    excelsheetmain:cells(s_line,2) = ac_desc .
    FOR EACH data NO-LOCK WHERE data_acc = s_acc :
        FIND head NO-LOCK WHERE head_sub = data_sub
            AND head_cc = data_cc .
        excelsheetmain:cells(s_line,head_t) = data_amt .
    END.
    excelsheetmain:cells(s_line,t + 1) = s_tot .
    excelsheetmain:cells(s_line,t + 2) = s_totb1 .
    excelsheetmain:cells(s_line,t + 3) = s_totc1 .
    IF expense THEN DO :
        excelsheetmain:cells(s_line,t + 4) = s_totb0 .
        excelsheetmain:cells(s_line,t + 5) = s_totc0 .
        excelsheetmain:cells(s_line,t + 6) = s_totb .
        excelsheetmain:cells(s_line,t + 7) = s_totc .
    END.
    ELSE DO :
        excelsheetmain:cells(s_line,t + 4) = s_tot0 .
    END.

    tot = s_tot + tot .
    totb1 = s_totb1 + totb1 .
    totc1 = s_totc1 + totc1 .
    totb0 = s_totb0 + totb0 .
    totc0 = s_totc0 + totc0 .
    tot0 = s_tot0 + tot0 .
    totb = s_totb + totb .
    totc = s_totc + totc .
END.

excelsheetmain:cells(i + 1,2) = "合计" .

FOR EACH head BY head_t :
    FOR EACH data NO-LOCK WHERE data_sub = head_sub
        AND data_cc = head_cc :
        head_amt = head_amt + data_amt .
    END.
    excelsheetmain:cells(i + 1,head_t) = head_amt .
END.
excelsheetmain:cells(i + 1,t + 1) = tot .
excelsheetmain:cells(i + 1,t + 2) = totb1 .
excelsheetmain:cells(i + 1,t + 3) = totc1 .
IF expense THEN DO :
    excelsheetmain:cells(i + 1,t + 4) = totb0 .
    excelsheetmain:cells(i + 1,t + 5) = totc0 .
    excelsheetmain:cells(i + 1,t + 6) = totb .
    excelsheetmain:cells(i + 1,t + 7) = totc .
END.
ELSE DO :
    excelsheetmain:cells(i + 1,t + 4) = tot0 .
END.

excelworkbook:SaveAs(outfile,,,,,,1).
excelworkbook:close(FALSE).
excelapp:quit. 

release object excelapp.
release object excelworkbook.
release object excelsheetmain.
