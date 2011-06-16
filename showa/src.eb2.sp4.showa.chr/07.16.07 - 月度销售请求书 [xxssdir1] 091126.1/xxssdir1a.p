
/* 以下为版本历史 */
/* SS - 090511.1 By: Bill Jiang */

/*以下为发版说明 */
/* SS - 090511.1 - RNB
按零件号和日期汇总输出的月度销售请求书
SS - 090511.1 - RNE */

/* ss - 091125.1 by: jack */
/* ss - 091126.1 by: jack */

{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{xxssdir1.i}

    DEFINE VAR v_name LIKE ad_name .
    DEFINE VAR v_desc LIKE pt_desc1 .

    /* ss - 091125.1 -b */
    EXPORT DELIMITER ";" "客户代码" "客户名称" "ERP图号"  "客户图号" "机种名称"  "数量" "不含税开发票单价"  "不含税金额"  "税额" "含税金额" "币别" . 
    /* ss - 091125.1 -e */
/* 客户 */
FIND FIRST ad_mstr 
   WHERE /* ad_domain = GLOBAL_domain
   AND */ ad_addr = cust
   NO-LOCK NO-ERROR.
IF AVAILABLE ad_mstr THEN DO:
   v_name = ad_name.
END.
ELSE DO:
  v_name = "" .
END.

/* ss - 091125.1 -b */
IF summary_only THEN DO:
FOR EACH ttb BREAK BY month(ttb_effdate) BY ttb_part  :
    ACCUMULATE ttb_qty (TOTAL BY ttb_part) .
    ACCUMULATE ttb_inv_amt (TOTAL BY  ttb_part) .
    ACCUMULATE ttb_tax ( TOTAL BY  ttb_part) .
    ACCUMULATE ttb_tax_amt ( TOTAL BY  ttb_part ) .

    IF LAST-OF( ttb_part ) THEN DO:
        FIND FIRST pt_mstr WHERE pt_part = ttb_part NO-LOCK NO-ERROR .
        IF AVAILABLE pt_mstr THEN
            v_desc = pt_desc1 .
        ELSE 
            v_desc = "" .

      EXPORT DELIMITER ";" cust v_name ttb_part ttb_custpart   v_desc  ROUND ( ( ACCUMULATE TOTAL BY  ttb_part ttb_qty  )  , 2 )  ttb_list_price 
         ROUND (  ( ACCUMULATE TOTAL BY  ttb_part ttb_inv_amt ) , 2 ) ROUND (  ( ACCUMULATE TOTAL BY  ttb_part ttb_tax ) , 2 ) 
           ROUND (  ( ACCUMULATE TOTAL BY  ttb_part ttb_tax_amt  )  , 2 )  ttb_curr .
    END.

END.
END.
ELSE DO:
    FOR EACH ttb BREAK BY month(ttb_effdate) BY ttb_part  :
       FIND FIRST pt_mstr WHERE pt_part = ttb_part NO-LOCK NO-ERROR .
        IF AVAILABLE pt_mstr THEN
            v_desc = pt_desc1 .
        ELSE 
            v_desc = "" .

             EXPORT DELIMITER ";" cust v_name ttb_part ttb_custpart   v_desc   ttb_qty   ttb_list_price ttb_inv_amt  ttb_tax   ttb_tax_amt  ttb_curr .

    END.
END.
/* ss - 091125.1 -e */


/* ss - 091125.1 -b
/* 对象纳入月日 */
PUT UNFORMATTED ";对象纳入月日: " 
   + SUBSTRING(STRING(YEAR(eff_dt)),3,2) + "年"
   + SUBSTRING(STRING(MONTH(eff_dt) + 1000),3,2) + "月"
   + SUBSTRING(STRING(DAY(eff_dt) + 1000),3,2) + "日"
   + " - "
   + SUBSTRING(STRING(YEAR(eff_dt1)),3,2) + "年"
   + SUBSTRING(STRING(MONTH(eff_dt1) + 1000),3,2) + "月"
   + SUBSTRING(STRING(DAY(eff_dt1) + 1000),3,2) + "日"
   .

/* 銷 售 請 求 書 */
char1[1] = "".
IF part_type_pt <> "" THEN DO:
   char1[1] = char1[1] + "(" + part_type_pt + ")".
END.
char1[1] = char1[1] + STRING(MONTH(eff_dt1)) + '月度销售请求书'.
IF draw_pt <> '' THEN DO:
   char1[1] = char1[1] + "(" + draw_pt + ")".
END.
PUT UNFORMATTED ";" char1[1].

/* 客户确认 */
FIND FIRST cm_mstr 
   WHERE /* cm_domain = global_domain
   AND */ cm_addr = cust
   NO-LOCK NO-ERROR.
IF AVAILABLE cm_mstr THEN DO:
   PUT UNFORMATTED ";" cm_sort + "确认".
END.
ELSE DO:
   PUT UNFORMATTED ";" cust + "确认".
END.

/* 作成 */
FIND FIRST usr_mstr 
   WHERE usr_userid = GLOBAL_userid
   NO-LOCK NO-ERROR.
IF AVAILABLE usr_mstr THEN DO:
   PUT UNFORMATTED ";" usr_name.
END.
ELSE DO:
   PUT UNFORMATTED ";" GLOBAL_userid.
END.

/* 日期 */
PUT UNFORMATTED ";" 
   SUBSTRING(STRING(YEAR(TODAY)),3,2) + "年"
   + SUBSTRING(STRING(MONTH(TODAY) + 1000),3,2) + "月"
   + SUBSTRING(STRING(DAY(TODAY) + 1000),3,2) + "日"
   .

/* 与数据行保持相同的列 */
FOR EACH tt3:
   PUT UNFORMATTED ";".
END.
PUT SKIP.

/* 标题行1 */
PUT UNFORMATTED "序;部番;色调".
/* 再按日期 */
FOR EACH tt3
   BY tt3_effdate
   :
   PUT UNFORMATTED ";" + STRING(MONTH(tt3_effdate)) + "/" + STRING(DAY(tt3_effdate)).
END. /* FOR EACH tt3 */
PUT UNFORMATTED ";单;合计;合计" SKIP.

/* 标题行2 */
/* 先按零件 */
PUT UNFORMATTED "号;(部品名);单价".
/* 再按日期 */
FOR EACH tt3
   BY tt3_effdate
   :
   PUT UNFORMATTED ";数量".
END. /* FOR EACH tt3 */
PUT UNFORMATTED ";位;数量;金额" SKIP.

/* 明细 */
line1[1] = 0.
/* 先按零件 */
FOR EACH tt2 
   BREAK
   BY tt2_inv
   BY tt2_part
   :
   IF FIRST-OF(tt2_inv) THEN DO:
      line1[1] = 0.
   END.

   FIND pt_mstr 
      WHERE /* pt_domain = GLOBAL_domain
      AND */ pt_part = tt2_part
      NO-LOCK NO-ERROR.
   line1[1] = line1[1] + 1.
   DO line1[2] = 1 TO 3:
      /* 明细行1 */
      IF line1[2] = 1 THEN DO:
         PUT UNFORMATTED "".
         /* 客户零件优先 */
         IF tt2_custpart <> "" THEN DO:
            PUT UNFORMATTED ";" tt2_custpart.
         END.
         ELSE DO:
            PUT UNFORMATTED ";" tt2_part.
         END.
         /* 色调 */
         IF AVAILABLE pt_mstr THEN DO:
            PUT UNFORMATTED ";" pt_draw.
         END.
         ELSE DO:
            PUT UNFORMATTED ";".
         END.
         /* 再按日期 */
         FOR EACH tt3 BY tt3_effdate:
            PUT UNFORMATTED ";".
         END. /* FOR EACH tt3 */
         PUT UNFORMATTED ";;;" SKIP.
      END. /* IF line1[2] = 1 THEN DO: */
      /* 明细行2 */
      ELSE IF line1[2] = 2 THEN DO:
         /* 序号 */
         PUT UNFORMATTED "" tt2_inv + STRING(line1[1]).
         /* 部番(部品名) */
         FIND FIRST cp_mstr
            WHERE /* cp_domain = GLOBAL_domain
            AND */ cp_cust = cust
            AND cp_cust_part = tt2_custpart
            NO-LOCK NO-ERROR.
         IF AVAILABLE cp_mstr THEN DO:
            PUT UNFORMATTED ";" cp_cust_partd.
         END. /* IF AVAILABLE cp_mstr THEN DO: */
         ELSE DO:
            IF AVAILABLE pt_mstr THEN DO:
               PUT UNFORMATTED ";" pt_desc1 + pt_desc2.
            END.
            ELSE DO:
               PUT UNFORMATTED ";".
            END.
         END.
         /* 单价 */
         PUT UNFORMATTED ";" ROUND((tt2_amt / tt2_qty),2).
         /* 再按日期 */
         FOR EACH tt3 BY tt3_effdate:
            /* 最后明细 */
            FIND FIRST tt1
               WHERE tt1_part = tt2_part
               AND tt1_effdate = tt3_effdate
               NO-LOCK NO-ERROR.
            IF AVAILABLE tt1 THEN DO:
               PUT UNFORMATTED ";" tt1_qty.
            END.
            ELSE DO:
               PUT UNFORMATTED ";".
            END.
         END. /* FOR EACH tt3 */
         PUT UNFORMATTED ";" tt2_um ";" tt2_qty ";" tt2_amt SKIP.
      END. /* ELSE IF line1[2] = 2 THEN DO: */
      /* 明细行3 */
      ELSE IF line1[2] = 3 THEN DO:
         PUT UNFORMATTED "".
         /* TODO: 部番(部品名) */
         PUT UNFORMATTED ";".
         PUT UNFORMATTED ";".
         /* 再按日期 */
         FOR EACH tt3 BY tt3_effdate:
            PUT UNFORMATTED ";".
         END. /* FOR EACH tt3 */
         PUT UNFORMATTED ";;;" SKIP.
      END. /* ELSE IF line1[2] = 3 THEN DO: */
   END. /* DO line1[2] = 1 TO 3: */
END. /* FOR EACH tt2 */

/* 合计行1 */
PUT UNFORMATTED "合计金额;;".
/* 再按日期 */
FOR EACH tt3
   BY tt3_effdate
   :
   PUT UNFORMATTED ";".
END. /* FOR EACH tt3 */
PUT UNFORMATTED ";;;" amt_tot[1] SKIP.

/* 合计行2 */
PUT UNFORMATTED "17%增值税;;".
/* 再按日期 */
FOR EACH tt3
   BY tt3_effdate
   :
   PUT UNFORMATTED ";".
END. /* FOR EACH tt3 */
PUT UNFORMATTED ";;;" ROUND((amt_tot[1] * 0.17),2) SKIP.

/* 合计行3 */
PUT UNFORMATTED "壳上总金额合计;;".
/* 再按日期 */
FOR EACH tt3
   BY tt3_effdate
   :
   PUT UNFORMATTED ";".
END. /* FOR EACH tt3 */
PUT UNFORMATTED ";;;" ROUND((amt_tot[1] * 1.17),2) SKIP.
                        
ss - 091125.1 -e */
