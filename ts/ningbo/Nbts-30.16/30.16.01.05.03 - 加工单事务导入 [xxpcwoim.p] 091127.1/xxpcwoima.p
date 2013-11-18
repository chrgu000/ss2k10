/* SS - 091127.1 By: Bill Jiang */

{mfdeclre.i}

{xxcimimp.i}

DEFINE VARIABLE i1 AS INTEGER.
DEFINE VARIABLE LONG_lbl LIKE lbl_long.
define variable recount       as integer format ">>>>>>>>9"
   label "Records Loaded".
define variable errcount      as integer format ">>>>>>>>9"
   label "Errors".

/************************************   TODO   ************************************/
DEFINE VARIABLE qty_end_xxpcwo LIKE xxpcwo_qty_end.
/************************************   TODO   ************************************/

i1 = 0.
recount = 0.
errcount = 0.

loop1:
FOR EACH tt1
   ,EACH tt0
   WHERE tt0_line = tt1_line
   :
   IF tt0_c1 = "" OR tt0_c1 = "-" THEN LEAVE.

   i1 = i1 + 1.
   IF include_header = "Y" THEN DO:
      IF i1 = 1 THEN NEXT.
   END.

   /************************************   TODO   ************************************/
   FIND FIRST xxpcwo_mstr 
      WHERE xxpcwo_domain = GLOBAL_domain
      AND xxpcwo_site = tt1_c1[1]
      AND xxpcwo_year = INTEGER(tt1_c1[2])
      AND xxpcwo_per = INTEGER(tt1_c1[3])
      AND xxpcwo_part = tt1_c1[4]
      AND xxpcwo_lot = tt1_c1[5]
      EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAILABLE xxpcwo_mstr THEN DO:
      ASSIGN tt0_error = "记录不存在".
      {xxpcwoima.i}
   END.

   IF tt1_c1[6] = "-" THEN DO:
      NEXT.
   END.

   ASSIGN qty_end_xxpcwo = DECIMAL(tt1_c1[6]) NO-ERROR.
   IF ERROR-STATUS:ERROR THEN DO:
      ASSIGN tt0_error = "期末数量的数据类型非法".
      {xxpcwoima.i}
   END.

   IF qty_end_xxpcwo < 0 THEN DO:
      ASSIGN tt0_error = "期末数量不可以小于零".
      {xxpcwoima.i}
   END.

   FOR FIRST si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_site = xxpcwo_site
      ,FIRST glcd_det NO-LOCK
      WHERE glcd_domain = GLOBAL_domain
      AND glcd_year = xxpcwo_year
      AND glcd_per = xxpcwo_per
      AND glcd_entity = si_entity
      AND glcd_gl_clsd = YES
      :
   END.
   IF AVAILABLE glcd_det THEN DO:
      ASSIGN tt0_error = "期间已经关闭".
      {xxpcwoima.i}
   END.

   IF CAN-FIND(
      FIRST xxpcc_det
      WHERE xxpcc_domain = GLOBAL_domain
      AND xxpcc_site = xxpcwo_site
      AND xxpcc_year = xxpcwo_year
      AND xxpcc_per = xxpcwo_per
      AND xxpcc_closed = YES
      ) THEN DO:
      ASSIGN tt0_error = "成本结算记录已经存在".
      {xxpcwoima.i}
   END.

   IF xxpcwo_qty_end <> qty_end_xxpcwo THEN DO:
      ASSIGN
         xxpcwo_qty_ord = xxpcwo_qty_ord - xxpcwo_qty_end + qty_end_xxpcwo
         xxpcwo_qty_end = xxpcwo_qty_end - xxpcwo_qty_end + qty_end_xxpcwo
         recount = recount + 1
         .
   END.
   /************************************   TODO   ************************************/
END. /* FOR EACH tt1: */

/* 输出执行结果 */
{gprun.i ""xxcimterm.p"" "(
   INPUT 'RECORDS_LOADED',
   OUTPUT LONG_lbl
   )"}
PUT UNFORMATTED LONG_lbl + ": " + STRING(recount) SKIP.
{gprun.i ""xxcimterm.p"" "(
   INPUT 'ERRORS',
   OUTPUT LONG_lbl
   )"}
PUT UNFORMATTED LONG_lbl + " [" + STRING(errcount) + "]: " SKIP.
FOR EACH tt0 WHERE tt0_error <> "":
   PUT tt0_line tt0_error.
   PUT UNFORMATTED " " tt0_c1 SKIP.
END.
