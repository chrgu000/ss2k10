{mfdeclre.i}
DEFINE WORKFILE xxwk
    FIELD xx_part LIKE idh_part LABEL "零件号"
    FIELD xx_desc1 LIKE pt_desc1 LABEL  "描述"
    FIELD xx_desc2 LIKE pt_desc2 LABEL  "描述"
    FIELD xx_line LIKE pt_prod_line LABEL  "产品类"
    FIELD xx_serial LIKE pt_desc1 LABEL  "系列"
    FIELD xx_eng_type LIKE ps_par LABEL  "发动机类型"
    FIELD xx_power LIKE pt_desc1 LABEL  "马力段"
    FIELD xx_marketing LIKE pt_drwg_loc /*marketing 市场*/
    FIELD xx_sub_mks LIKE CODE_cmmt  LABEL "细分市场"
    FIELD xx_cus_id LIKE ih_curr  LABEL "客户代码"
    FIELD xx_cus_name LIKE ad_name  LABEL "客户名称"
    FIELD xx_OEM_ID LIKE pt_draw /*OEM ID*/
    FIELD xx_OEM_name LIKE CODE_cmmt  LABEL  "OEM名称"
    FIELD xx_type LIKE cm_type LABEL  "客户类型"
    FIELD xx_region LIKE cm_region  LABEL "区域"
    FIELD xx_slspsn LIKE idh_slspsn[1]  LABEL "销售员代码"
    FIELD xx_curr LIKE ih_curr  LABEL "币种"
    FIELD xx_price LIKE idh_price  LABEL "单价"
    FIELD xx_qty LIKE idh_qty_inv  LABEL "数量"
    FIELD xx_amount LIKE idh_price FORMAT "->>>,>>>,>>>,>>9.99" INITIAL 0  LABEL "金额"
    FIELD xx_inv_nbr LIKE idh_inv_nbr  LABEL "发票号"
    FIELD xx_inv_date LIKE ih_inv_date  LABEL "发票日期"
    FIELD xx_rate LIKE ih_ex_rate2 INITIAL 1 LABEL  "汇率"
    FIELD xx_eng_part LIKE pt_desc1 LABEL "发动机和销售备件分类"
    FIELD xx_dep LIKE pt_desc1 LABEL "事业部"
    FIELD xx_site LIKE ih_site LABEL "生产区域".



DEFINE VAR mpath AS CHAR.
DEFINE VAR v_inv_date AS CHAR.
DEFINE VAR v_marketing AS CHAR.




FOR EACH xxwk.
    DELETE xxwk.
END.


FOR EACH ih_hist WHERE ih_domain = global_domain and ih_inv_date >= TODAY - 1 AND ih_inv_date <= TODAY - 1 NO-LOCK.
    FOR EACH idh_hist WHERE idh_domain = global_domain and idh_inv_nbr = ih_inv_nbr.
        FIND FIRST pt_mstr WHERE pt_domain = global_domain and pt_part = idh_part NO-LOCK NO-ERROR.
        FIND FIRST ad_mstr WHERE ad_domain = global_domain and ad_addr = ih_cust NO-LOCK NO-ERROR.
        FIND FIRST cm_mstr WHERE cm_domain = global_domain and cm_addr = ih_cust NO-LOCK NO-ERROR.
        IF AVAIL pt_mstr AND AVAIL ad_mstr AND AVAIL cm_mstr THEN DO:

            CREATE xxwk.
            ASSIGN xx_part = idh_part.
            xx_site = ih_site.
            xx_desc1 = pt_desc1.
            xx_desc2 = pt_desc2.
            xx_line = pt_prod_line.
            xx_marketing = pt_drwg_loc.
            xx_OEM_ID = pt_draw.
            xx_cus_id = ih_cust.
            xx_cus_name = ad_name.
            xx_type = cm_type.
            xx_region = cm_region.
            xx_slspsn = idh_slspsn[1].
            xx_curr = ih_curr.
            xx_price = idh_price.
            xx_qty = idh_qty_inv.
            xx_amount = idh_price * idh_qty_inv.
            xx_rate = ih_ex_rate2. 
            xx_inv_nbr = idh_inv_nbr.
            xx_inv_date = ih_inv_date.
         END.
    END.
END.

FOR EACH xxwk WHERE (xxwk.xx_line >= "7000" AND xxwk.xx_line <= "8ZZZ") OR (xxwk.xx_line >= "2000" AND xxwk.xx_line <= "2ZZZ").
    FIND FIRST CODE_mstr WHERE code_domain = global_domain and CODE_fldname = "pt_drwg_loc" AND code_value = xx_marketing NO-LOCK NO-ERROR.
    IF AVAIL CODE_mstr THEN xxwk.xx_sub_mks = CODE_cmmt.
    ELSE xxwk.xx_sub_mks = "".

    FIND FIRST CODE_mstr WHERE code_domain = global_domain and CODE_fldname = "pt_draw" AND code_value = xx_OEM_ID NO-LOCK NO-ERROR.
    IF AVAIL CODE_mstr THEN xxwk.xx_OEM_name = CODE_cmmt.
    ELSE xxwk.xx_OEM_name = "".

    FIND FIRST ps_mstr WHERE ps_domain = global_domain and ps_comp = xxwk.xx_part OR SUBSTRING(ps_comp, 1, LENGTH(ps_comp) - 2) = xxwk.xx_part NO-LOCK NO-ERROR.
    IF AVAIL ps_mstr THEN DO:
        IF SUBSTRING(ps_par, LENGTH(ps_par) - 1, 2 ) = "ZZ" THEN xxwk.xx_eng_type = SUBSTRING(ps_par, 1, LENGTH(ps_par) - 2).
        ELSE xxwk.xx_eng_type = ps_par.
    END.
    ELSE xxwk.xx_eng_type = "Nofound".


    IF xxwk.xx_line >= "7000" AND xxwk.xx_line <= "70ZZ" OR xxwk.xx_line = "7ZZX" OR xxwk.xx_line >= "2000" AND xxwk.xx_line <= "20ZZ" THEN xxwk.xx_serial = "4B-SKD".
    ELSE IF xxwk.xx_line >= "7100" AND xxwk.xx_line <= "71ZZ" THEN xxwk.xx_serial = "4B-CKD".
    ELSE IF xxwk.xx_line >= "7200" AND xxwk.xx_line <= "72ZZ" OR xxwk.xx_line >= "2100" AND xxwk.xx_line <= "21ZZ" THEN xxwk.xx_serial = "6B-SKD".
    ELSE IF xxwk.xx_line >= "7300" AND xxwk.xx_line <= "73ZZ" THEN xxwk.xx_serial = "6B-CKD".
    ELSE IF xxwk.xx_line >= "7ZZX" THEN xxwk.xx_serial = "B系列基础机".
    ELSE IF xxwk.xx_line >= "7400" AND xxwk.xx_line <= "74ZZ" OR xxwk.xx_line >= "2200" AND xxwk.xx_line <= "22ZZ" THEN xxwk.xx_serial = "6C-SKD".
    ELSE IF xxwk.xx_line >= "7500" AND xxwk.xx_line <= "75ZZ" THEN xxwk.xx_serial = "6C-CKD".
    ELSE IF xxwk.xx_line >= "7ZZX" THEN xxwk.xx_serial = "C系列基础机".

    ELSE IF xxwk.xx_line >= "7G00" AND xxwk.xx_line <= "7GZZ" OR xxwk.xx_line >= "2800" AND xxwk.xx_line <= "28ZZ" THEN xxwk.xx_serial = "L-SKD".
    ELSE IF xxwk.xx_line >= "7H00" AND xxwk.xx_line <= "7HZZ" THEN xxwk.xx_serial = "L-CKD".
    ELSE IF xxwk.xx_line >= "7ZZZ" THEN xxwk.xx_serial = "L系列基础机".

    ELSE IF xxwk.xx_line >= "7I00" AND xxwk.xx_line <= "7IZZ" OR xxwk.xx_line >= "2300" AND xxwk.xx_line <= "23ZZ" THEN xxwk.xx_serial = "ISB4-SKD".
    ELSE IF xxwk.xx_line >= "7J00" AND xxwk.xx_line <= "7JZZ" THEN xxwk.xx_serial = "ISB4-CKD".
    ELSE IF xxwk.xx_line >= "7600" AND xxwk.xx_line <= "76ZZ" THEN xxwk.xx_serial = "ISB6-SKD".
    ELSE IF xxwk.xx_line >= "7700" AND xxwk.xx_line <= "77ZZ" THEN xxwk.xx_serial = "ISB6-CKD".
    ELSE IF xxwk.xx_line >= "7M00" AND xxwk.xx_line <= "7MZZ" THEN xxwk.xx_serial = "ISD4-SKD".
    ELSE IF xxwk.xx_line >= "7N00" AND xxwk.xx_line <= "7NZZ" THEN xxwk.xx_serial = "ISD4-CKD".
    ELSE IF xxwk.xx_line >= "7K00" AND xxwk.xx_line <= "7KZZ" THEN xxwk.xx_serial = "ISD6-SKD".
    ELSE IF xxwk.xx_line >= "7L00" AND xxwk.xx_line <= "7LZZ" THEN xxwk.xx_serial = "ISD6-CKD".
    ELSE IF xxwk.xx_line >= "7WWX" THEN xxwk.xx_serial = "ISD系列基础机".

    ELSE IF xxwk.xx_line >= "7A00" AND xxwk.xx_line <= "7AZZ" OR xxwk.xx_line >= "2500" AND xxwk.xx_line <= "25ZZ" THEN xxwk.xx_serial = "ISL-SKD".
    ELSE IF xxwk.xx_line >= "7B00" AND xxwk.xx_line <= "7BZZ" THEN xxwk.xx_serial = "ISL-CKD".
    ELSE IF xxwk.xx_line >= "7WWZ" THEN xxwk.xx_serial = "ISL系列基础机".

    ELSE IF xxwk.xx_line >= "7800" AND xxwk.xx_line <= "78ZZ" OR xxwk.xx_line >= "2400" AND xxwk.xx_line <= "24ZZ" THEN xxwk.xx_serial = "ISC-SKD".
    ELSE IF xxwk.xx_line >= "7900" AND xxwk.xx_line <= "79ZZ" THEN xxwk.xx_serial = "ISC-CKD".
    ELSE IF xxwk.xx_line >= "7E00" AND xxwk.xx_line <= "7EZZ" OR xxwk.xx_line >= "2700" AND xxwk.xx_line <= "27ZZ" THEN xxwk.xx_serial = "CNGC-SKD".
    ELSE IF xxwk.xx_line >= "7F00" AND xxwk.xx_line <= "7FZZ" THEN xxwk.xx_serial = "CNGC-CKD".
    ELSE IF xxwk.xx_line >= "7C00" AND xxwk.xx_line <= "7CZZ" OR xxwk.xx_line >= "2600" AND xxwk.xx_line <= "26ZZ" THEN xxwk.xx_serial = "CNGB-SKD".
    ELSE IF xxwk.xx_line >= "7D00" AND xxwk.xx_line <= "7DZZ" THEN xxwk.xx_serial = "CNGB-CKD".

    ELSE IF xxwk.xx_line >= "2900" AND xxwk.xx_line <= "29ZZ" THEN xxwk.xx_serial = "ISM".
    ELSE IF xxwk.xx_line >= "2D00" AND xxwk.xx_line <= "2DZZ" THEN xxwk.xx_serial = "QSC".
    ELSE IF xxwk.xx_line >= "2B00" AND xxwk.xx_line <= "2BZZ" THEN xxwk.xx_serial = "QSL".
    ELSE IF xxwk.xx_line >= "2C00" AND xxwk.xx_line <= "2CZZ" THEN xxwk.xx_serial = "QSM".
    ELSE IF xxwk.xx_line >= "7O00" AND xxwk.xx_line <= "7OZZ" OR xxwk.xx_line >= "2A00" AND xxwk.xx_line <= "2AZZ" THEN xxwk.xx_serial = "QSB".
    ELSE IF xxwk.xx_line >= "7P00" AND xxwk.xx_line <= "7PZZ" THEN xxwk.xx_serial = "UPB 4B".
    ELSE IF xxwk.xx_line >= "7Q00" AND xxwk.xx_line <= "7QZZ" THEN xxwk.xx_serial = "UPB 6B".
    ELSE IF xxwk.xx_line >= "7R00" AND xxwk.xx_line <= "7RZZ" THEN xxwk.xx_serial = "UPC".
    ELSE IF xxwk.xx_line >= "7S00" AND xxwk.xx_line <= "7SZZ" THEN xxwk.xx_serial = "UPL".
    ELSE IF xxwk.xx_line >= "8000" AND xxwk.xx_line <= "82ZZ" THEN xxwk.xx_serial = "ISZ".
    ELSE xxwk.xx_serial = "Others".

END.



FIND FIRST code_mstr where code_domain = global_domain and code_fldname = "BCTOCRM" no-lock no-error.
IF AVAIL code_mstr THEN mpath = code_value.

mpath = mpath + "QAD_CRM_salesdetail" + STRING(YEAR(TODAY),'9999') + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99') + ".TXT".

OUTPUT TO VALUE(mpath).


    PUT UNFORMATTED "发动机/销售备件|".
    PUT UNFORMATTED "事业部|".
    PUT UNFORMATTED "发动机类型|".
    PUT UNFORMATTED "生产区域|".
    PUT UNFORMATTED "零件号|".
    PUT UNFORMATTED "描述1|".
    PUT UNFORMATTED "描述2|".
    PUT UNFORMATTED "产品类|".
    PUT UNFORMATTED "发动机系列|".
    PUT UNFORMATTED "马力段|".
    PUT UNFORMATTED "应用市场|".
    PUT UNFORMATTED "细分应用市场|".
    PUT UNFORMATTED "客户代码|".
    PUT UNFORMATTED "客户名称|".
    PUT UNFORMATTED "OEM代码|".
    PUT UNFORMATTED "OEM名称|".
    PUT UNFORMATTED "客户类别|".
    PUT UNFORMATTED "区域|".
    PUT UNFORMATTED "销售员|".
    PUT UNFORMATTED "币种|".
    PUT UNFORMATTED "单价|".
    PUT UNFORMATTED "数量|".
    PUT UNFORMATTED "总价|".
    PUT UNFORMATTED "发票号|". 
    PUT UNFORMATTED "发票日期|". 
    PUT UNFORMATTED "汇率" SKIP.


FOR EACH xxwk NO-LOCK.
    v_inv_date = STRING(YEAR(xxwk.xx_inv_date),"9999") + "-" + STRING(MONTH(xxwk.xx_inv_date),"99") + "-" +  STRING(DAY(xxwk.xx_inv_date),"99").
    IF xx_marketing >= "船用01"  AND  xx_marketing <= "船用02"  THEN v_marketing = "船用".
    ELSE IF xx_marketing >= "工程01"  AND  xx_marketing <= "工程16" THEN v_marketing = "工程".
    ELSE IF xx_marketing >= "卡车01"  AND  xx_marketing <= "卡车09"  THEN v_marketing = "卡车".
    ELSE IF xx_marketing >= "客车01"  AND  xx_marketing <= "客车03"  THEN v_marketing = "客车".
    ELSE v_marketing = xx_marketing.


    FIND FIRST ad_mstr WHERE ad_domain = global_domain and ad_addr = xx_slspsn  AND ad_type = "SLSPRSN" NO-LOCK NO-ERROR.
    IF AVAIL ad_mstr THEN xx_dep = ad_line1.
    ELSE xx_dep = "".



    IF (xxwk.xx_line >= "7000" AND xxwk.xx_line <= "8ZZZ") OR (xxwk.xx_line >= "2000" AND xxwk.xx_line <= "2ZZZ") THEN xx_eng_part = "发动机".
    ELSE xx_eng_part = "销售备件".
    
    PUT UNFORMATTED xx_eng_part "|".
    PUT UNFORMATTED xx_dep "|".
    PUT UNFORMATTED xx_eng_type "|".
    PUT UNFORMATTED xx_site "|".
    PUT UNFORMATTED xx_part "|".
    PUT UNFORMATTED xx_desc1 "|".
    PUT UNFORMATTED xx_desc2 "|".
    PUT UNFORMATTED xx_line "|".
    PUT UNFORMATTED xx_serial "|".
    PUT UNFORMATTED xx_power "|".
    PUT UNFORMATTED v_marketing "|".
    PUT UNFORMATTED xx_sub_mks "|".
    PUT UNFORMATTED xx_cus_id "|".
    PUT UNFORMATTED xx_cus_name "|".
    PUT UNFORMATTED xx_OEM_ID "|".
    PUT UNFORMATTED xx_OEM_name "|".
    PUT UNFORMATTED xx_type "|".
    PUT UNFORMATTED xx_region "|".
    PUT UNFORMATTED xx_slspsn "|".
    PUT UNFORMATTED xx_curr "|".
    PUT UNFORMATTED xx_price "|".
    PUT UNFORMATTED xx_qty "|".
    PUT UNFORMATTED xx_amount "|".
    PUT UNFORMATTED xx_inv_nbr "|". 
    PUT UNFORMATTED v_inv_date "|". 
    PUT UNFORMATTED xx_rate SKIP.
END.

OUTPUT TO VALUE ("\\qadtemp\ftp\QADtoCRM.logfile") APPEND.
DISP mpath FORMAT "X(100)" TODAY TIME WITH WIDTH 180 STREAM-IO.

OUTPUT CLOSE.
