
/* 以下为版本历史 */
/* SS - 090511.1 By: Bill Jiang */

/*以下为发版说明 */
/* SS - 090511.1 - RNB
按零件号汇总输出的月度销售明细一览表
SS - 090511.1 - RNE */

{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{xxssdir1.i}

/* 客户 */
FIND FIRST ad_mstr 
   WHERE /* ad_domain = GLOBAL_domain
   AND */ ad_addr = cust
   NO-LOCK NO-ERROR.
IF AVAILABLE ad_mstr THEN DO:
   PUT UNFORMATTED ad_name.
END.
ELSE DO:
   PUT UNFORMATTED cust.
END.

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
char1[1] = char1[1] + STRING(MONTH(eff_dt1)) + '月度销售明细一览表'.
IF draw_pt <> '' THEN DO:
   char1[1] = char1[1] + "(" + draw_pt + ")".
END.
PUT UNFORMATTED ";" char1[1].

/* 客户确认 */
FIND FIRST cm_mstr 
   WHERE /* cm_domain = global_domain
   AND */cm_addr = cust
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
PUT UNFORMATTED ";;;".
PUT SKIP.

/* 标题行1 */
PUT UNFORMATTED "序;部番;色调;数".
PUT UNFORMATTED ";单;合计;税;税;含税" SKIP.

/* 标题行2 */
/* 先按零件 */
PUT UNFORMATTED "号;(部品名);单价;量".
PUT UNFORMATTED ";位;金额;率;额;金额" SKIP.

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
         PUT UNFORMATTED ";;;;;;" SKIP.
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
         PUT UNFORMATTED ";" tt2_qty ";" tt2_um ";" tt2_amt ";17%;" ROUND((tt2_amt * 0.17),2) ";" ROUND((tt2_amt * 1.17),2) SKIP.
      END. /* ELSE IF line1[2] = 2 THEN DO: */
      /* 明细行3 */
      ELSE IF line1[2] = 3 THEN DO:
         PUT UNFORMATTED "".
         /* TODO: 部番(部品名) */
         PUT UNFORMATTED ";".
         PUT UNFORMATTED ";".
         PUT UNFORMATTED ";;;;;;" SKIP.
      END. /* ELSE IF line1[2] = 3 THEN DO: */
   END. /* DO line1[2] = 1 TO 3: */
END. /* FOR EACH tt2 */

/* 合计 */
PUT UNFORMATTED "合计;;".
PUT UNFORMATTED ";;;" amt_tot[1] ";;" ROUND((amt_tot[1] * 0.17),2) ";" ROUND((amt_tot[1] * 1.17),2) SKIP.
