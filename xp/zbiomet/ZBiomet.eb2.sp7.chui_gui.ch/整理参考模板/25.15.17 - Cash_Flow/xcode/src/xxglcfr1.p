/* BY: Bill Jiang DATE: 10/03/06 ECO: 20061003.1 */
/* SS - 081201.1 - By: Bill Jiang */

/* SS - 081201.1 - B */
/*
更新了BI报表的输出路径
*/
/* SS - 081201.1 - E */

/* SS - 20061003.1 - B */
/*
1. 重新计算错误的或没有计算过的记录
2. 使用了以下常量:
   031100 - 净利润
   031301 - 现金及现金等价物期初余额
   031302 - 现金及现金等价物期末余额 = 031301 - 现金及现金等价物期初余额 + 10
*/
/* SS - 20061003.1 - E */

/* DISPLAY TITLE */
{mfdtitle.i "081201.1"}

{xxglabrp0001.i "new"}

DEFINE TEMP-TABLE tt1
   FIELD tt1_c1 AS CHARACTER
   FIELD tt1_c2 AS CHARACTER
   FIELD tt1_d1 AS DECIMAL
   .

DEFINE VARIABLE netprofit LIKE gltr_amt.

define variable o1 as DECIMAL.
define variable o2 as DECIMAL.

DEFINE VARIABLE dc AS CHARACTER.

define new shared variable begdt like gltr_eff_dt  no-undo.
define new shared variable enddt like gltr_eff_dt  no-undo.
define new shared variable entity like gltr_entity  no-undo.

form
   entity   colon 25 
   begdt    colon 25 
   enddt   colon 50 label {t001.i}
   with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

assign
   entity = CURRENT_entity
   enddt = DATE(MONTH(TODAY),1,YEAR(TODAY)) - 1
   begdt = DATE(MONTH(enddt),1,YEAR(enddt))
   .

{wbrp01.i}

/* REPORT BLOCK */
mainloop:
repeat:

   display 
      entity 
      begdt
      enddt
      with frame a.

   if c-application-mode <> 'web':u then
      set 
      entity 
      begdt 
      enddt 
      with frame a.

   {wbrp06.i &command = set &fields = " 
      entity 
      begdt 
      enddt
      " &frm = "a"}

   if (c-application-mode <> 'web':u) OR (c-application-mode = 'web':u AND (c-web-request begins 'data':u)) then do:
      {mfquoter.i entity  }
      {mfquoter.i begdt   }
      {mfquoter.i enddt   }
   end.  /* if (c-application-mode <> 'web':u) ... */

   /* SELECT PRINTER */
   {mfselbpr.i "printer" 132}
   /*
   PUT UNFORMATTED "ExecutionFile" ";" "txt2xls2.exe" SKIP.
   PUT UNFORMATTED "ExcelFile" ";" "xxglcfr1" SKIP.
   PUT UNFORMATTED "SaveFile" ";" "现金流量表" SKIP.
   PUT UNFORMATTED "CenterHeader" ";" "现金流量表" SKIP.
   /*
   PUT UNFORMATTED "LeftHeader" ";" "统计期间: " + l-yrper + " 至 " + l-yrper1 SKIP.
   PUT UNFORMATTED "xlHAlignCenterAcrossSelection" ";" "1" SKIP.
   */
   
   PUT UNFORMATTED "PrintPreview" ";" "no" SKIP.
   PUT UNFORMATTED "ActiveSheet" ";" "3" SKIP.
   PUT UNFORMATTED "BeginRow" ";" "1" SKIP.
   PUT UNFORMATTED "Format" ";" "no" SKIP.
   */
   /*
   PUT UNFORMATTED "TextColumn".
   i = 0.
   REPEAT:
      i = i + 1.
      PUT UNFORMATTED ";" STRING(i).
      IF i = 10 THEN DO:
         LEAVE.
      END.
   END.
   i = 19.
   REPEAT:
      i = i + 1.
      PUT UNFORMATTED ";" STRING(i).
      IF i = 23 THEN DO:
         LEAVE.
      END.
   END.
   PUT SKIP.
   */
    /*    andy - 2007-03-15       */
      /* SS - 081201.1 - B */
      /*
    put unformatted "#def reportpath=$/Minth/xxglcfr1" skip.
    */
   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname, 1, LENGTH(execname) - 2) SKIP.
   /* SS - 081201.1 - E */
    put unformatted "#def :end" skip.

   PUT UNFORMATTED "Year" ";" YEAR(begdt) ";" 0 SKIP.
   PUT UNFORMATTED "Month" ";" MONTH(begdt) ";" 0 SKIP.

    /*    andy - 2007-03-15       */
   EMPTY TEMP-TABLE tt1.

   {xxglcfr1.i}

   for each tt1:
      EXPORT DELIMITER ";" tt1.
   end.

   {xxmfrtrail.i}
end.
{wbrp04.i &frame-spec = a}
