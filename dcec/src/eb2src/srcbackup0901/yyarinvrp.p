/**
 @File: yyarinvrp.p
 @Description: 财务发票明细报表
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: 财务发票明细报表
 @Todo: 
 @History: 
**/

{mfdtitle.i}

DEF VAR cust LIKE ar_bill .
DEF VAR cust1 LIKE ar_bill .
DEF VAR inv LIKE ar_nbr .
DEF VAR inv1 LIKE ar_nbr .
DEF VAR dt LIKE ar_date .
DEF VAR dt1 LIKE ar_date .
DEF VAR efdt LIKE ar_effdate .
DEF VAR efdt1 LIKE ar_effdate .
DEF VAR entity LIKE ar_entity .
DEF VAR entity1 LIKE ar_entity .
DEF VAR prodline LIKE pt_prod_line .
DEF VAR prodline1 LIKE pt_prod_line .
DEF VAR i AS INT .
DEF VAR mtax AS DEC .
DEF VAR k AS INT .
DEF VAR s AS LOG LABEL "汇总/明细" .

define variable excelapp as com-handle.
define variable excelworkbook as com-handle.
define variable excelsheetmain as com-handle.

FORM
    cust COLON 20 cust1 LABEL {t001.i} COLON 50
    inv COLON 20 inv1 LABEL {t001.i} COLON 50
    dt COLON 20 dt1 LABEL {t001.i} COLON 50
    efdt COLON 20 efdt1 LABEL {t001.i} COLON 50
    entity COLON 20 entity1 LABEL {t001.i} COLON 50
    prodline COLON 20 prodline1 LABEL {t001.i} COLON 50
    s COLON 20
    SKIP(0.4)
WITH FRAME a SIDE-LABELS THREE-D WIDTH 80 .
setFrameLabels(frame a:handle).

REPEAT ON ERROR UNDO, LEAVE :

    IF cust1 = hi_char THEN cust1 = "" .
    IF inv1 = hi_char THEN inv1 = "" .
    IF dt = low_date THEN dt = ? .
    IF dt1 = hi_date THEN dt1 = ? .
    IF efdt = low_date THEN efdt = ? .
    IF efdt1 = hi_date THEN efdt1 = ? .
    IF entity1 = hi_char THEN entity1 = "" .
    IF prodline1 = hi_char THEN prodline1 = "" .

    UPDATE cust cust1 inv inv1 dt dt1 efdt efdt1 entity entity1 prodline prodline1 s
        WITH FRAME a .

    IF cust1 = "" THEN cust1 = hi_char .
    IF inv1 = "" THEN inv1 = hi_char .
    IF dt = ? THEN dt = low_date .
    IF dt1 = ? THEN dt1 = hi_date .
    IF efdt = ? THEN efdt = low_date .
    IF efdt1 = ? THEN efdt1 = hi_date .
    IF entity1 = "" THEN entity1 = hi_char .
    IF prodline1 = "" THEN prodline1 = hi_char .

    STATUS DEFAULT "处理数据……" .

    create "Excel.Application" excelapp.
    excelworkbook = excelapp:workbooks:add().
    excelsheetmain = excelapp:sheets:item(1).

    excelsheetmain:cells(1,1) = "客户" .
    excelsheetmain:cells(1,2) = "客户名称" .
    excelsheetmain:cells(1,3) = "发票号" .
    excelsheetmain:cells(1,4) = "发票日期" .
    excelsheetmain:cells(1,5) = "总帐参考号" .
    excelsheetmain:cells(1,6) = "税" .
    excelsheetmain:cells(1,7) = "收入" .
    excelsheetmain:cells(1,8) = "销售订单" .
    IF s = NO THEN DO :
        excelsheetmain:cells(1,9) = "零件号" .
        excelsheetmain:cells(1,10) = "地点" .
        excelsheetmain:cells(1,11) = "金额" .
        excelsheetmain:cells(1,12) = "数量" .
        excelsheetmain:cells(1,13) = "单价" .
        excelsheetmain:cells(1,14) = "产品类" .
    END.

    i = 2 .
    FOR EACH ar_mstr NO-LOCK WHERE ar_bill >= cust AND ar_bill <= cust1
        AND ar_nbr >= inv AND ar_nbr <= inv1
        AND ar_date >= dt AND ar_date <= dt1
        AND ar_effdate >= efdt AND ar_effdate <= efdt1
        AND ar_entity >= entity AND ar_entity <= entity1 
        AND (ar_type = "I" /*OR ar_type = "M"*/) BREAK BY ar_bill :

        /*IF ar_type = "M" THEN DO :
            FIND FIRST ard_det NO-LOCK WHERE ard_nbr = ar_nbr 
                AND (ard_cc BEGINS "7" OR ard_cc BEGINS "2") NO-ERROR .
            IF NOT AVAILABLE ard_det THEN NEXT .
        END.*/

        excelsheetmain:cells(i,1) = "'" + ar_bill .

        FIND ad_mstr NO-LOCK WHERE ad_addr = ar_bill NO-ERROR .
        IF AVAILABLE ad_mstr THEN excelsheetmain:cells(i,2) = ad_name .

        excelsheetmain:cells(i,3) = "'" + ar_nbr .
        excelsheetmain:cells(i,4) = ar_date .

        FIND FIRST glt_det NO-LOCK WHERE glt_batch = ar_batch
            AND glt_doc = ar_nbr
            AND glt_doc_type = ar_type
            USE-INDEX glt_batch NO-ERROR .
        IF AVAILABLE glt_det THEN excelsheetmain:cells(i,5) = glt_ref .
        ELSE DO :
            FIND FIRST gltr_hist NO-LOCK WHERE gltr_batch = ar_batch
                AND gltr_doc = ar_nbr
                AND gltr_doc_typ = ar_type 
                AND gltr_eff_dt = ar_effdate
                USE-INDEX gltr_doctype NO-ERROR .
            IF AVAILABLE gltr_hist THEN excelsheetmain:cells(i,5) = gltr_ref .
        END.

        mtax = 0 .
        FOR EACH ard_det NO-LOCK WHERE ard_nbr = ar_nbr AND ard_acc = "2171005" :
            mtax = mtax + ard_amt / ar_ex_rate .
        END.
        IF mtax <> 0 THEN excelsheetmain:cells(i,6) = mtax .

        excelsheetmain:cells(i,7) = ar_base_amt - mtax .

        k = i .

        IF ar_type = "I" THEN DO :
            FIND FIRST idh_hist NO-LOCK WHERE idh_inv_nbr = ar_nbr NO-ERROR .
            IF AVAILABLE idh_hist THEN excelsheetmain:cells(i,8) = idh_nbr .

            IF s = NO THEN DO :
                FOR EACH idh_hist NO-LOCK WHERE idh_inv_nbr = ar_nbr :
                    FIND pt_mstr NO-LOCK WHERE pt_part = idh_part NO-ERROR .
                    IF AVAILABLE pt_mstr AND pt_prod_line >= prodline AND pt_prod_line <= prodline1 THEN DO :
                        excelsheetmain:cells(i,9) = idh_part .
                        excelsheetmain:cells(i,10) = idh_site .
                        excelsheetmain:cells(i,11) = idh_qty_inv * (idh_price / ar_ex_rate) .
                        excelsheetmain:cells(i,12) = idh_qty_inv .
                        excelsheetmain:cells(i,13) = idh_price / ar_ex_rate .
                        excelsheetmain:cells(i,14) = pt_prod_line .
                        i = i + 1 .
                    END .
                END. /*for each idh_hist*/
            END. /*display detail*/

        END. /*if ar_type = "I"*/

        IF k = i THEN i = i + 1 .

    END. /*for each ar_mstr*/

    excelapp:visible = TRUE .
    
    release object excelapp.
    release object excelworkbook.
    release object excelsheetmain.

END. /*repeat*/


