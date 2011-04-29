/* BY: Bill Jiang DATE: 10/03/06 ECO: 20061003.1 */
/* BY: Andy Zhang DATE: 03/15/07 ECO: 20070315 */
/* SS - 081201.1 - By: Bill Jiang */

/* SS - 081201.1 - B */
/*
更新了BI报表的输出路径
*/
/* SS - 081201.1 - E */

/* SS - 20061003.1 - B */
/*
1. 重新计算错误的或没有计算过的记录
*/
/* SS - 20061003.1 - E */

/* DISPLAY TITLE */
{mfdtitle.i "081201.1"}

define new shared variable begdt like gltr_eff_dt  no-undo.
define new shared variable enddt like gltr_eff_dt  no-undo.
define new shared variable entity like gltr_entity  no-undo.
DEFINE VARIABLE sums LIKE glrd_sums.
DEFINE VARIABLE sums1 LIKE glrd_sums.

form
   entity   colon 25 
   begdt    colon 25 
   enddt   colon 50 label {t001.i}
   sums    colon 25 
   sums1   colon 50 label {t001.i}
   with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

assign
   entity = CURRENT_entity
   enddt = DATE(MONTH(TODAY),1,YEAR(TODAY)) - 1
   begdt = DATE(MONTH(enddt),1,YEAR(enddt))
	sums1 = 999999
   .

{wbrp01.i}

/* REPORT BLOCK */
mainloop:
repeat:

   display 
      entity 
      begdt
      enddt
      sums
      sums1
      with frame a.

   if c-application-mode <> 'web':u then
      set 
      entity 
      begdt 
      enddt 
      sums
      sums1
      with frame a.

   {wbrp06.i &command = set &fields = " 
      entity 
      begdt 
      enddt
      sums
      sums1
      " &frm = "a"}

   if (c-application-mode <> 'web':u) OR (c-application-mode = 'web':u AND (c-web-request begins 'data':u)) then do:
      {mfquoter.i entity  }
      {mfquoter.i begdt   }
      {mfquoter.i enddt   }
      {mfquoter.i sums   }
      {mfquoter.i sums1   }
   end.  /* if (c-application-mode <> 'web':u) ... */

   /* SELECT PRINTER */
   {mfselbpr.i "printer" 132}

           /*    SS - 20070315 B     */

     /*
   PUT UNFORMATTED "ExecutionFile" ";" "txt2xls2.exe" SKIP.
   PUT UNFORMATTED "ExcelFile" ";" "xxglcfr2" SKIP.
   PUT UNFORMATTED "SaveFile" ";" "现金流量明细表" SKIP.
   PUT UNFORMATTED "CenterHeader" ";" "现金流量明细表" SKIP.
   /*
   PUT UNFORMATTED "LeftHeader" ";" "统计期间: " + l-yrper + " 至 " + l-yrper1 SKIP.
   PUT UNFORMATTED "xlHAlignCenterAcrossSelection" ";" "1" SKIP.
   */
   PUT UNFORMATTED "PrintPreview" ";" "no" SKIP.
   PUT UNFORMATTED "ActiveSheet" ";" "1" SKIP.
   PUT UNFORMATTED "BeginRow" ";" "1" SKIP.
   PUT UNFORMATTED "Format" ";" "no" SKIP.
   
   */
       /*    SS - 20070315 E      */

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


       /*    SS - 20070315 B     */


      /* SS - 081201.1 - B */
      /*
    put unformatted "#def reportpath=$/Minth/xxglcfr2" skip.
    */
   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname, 1, LENGTH(execname) - 2) SKIP.
   /* SS - 081201.1 - E */
    put unformatted "#def :end" skip.

       /*    SS - 20070315 E     */

       /*    SS - 20070315 B     */

      /*
   PUT UNFORMATTED "Year" ";" YEAR(begdt) ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP.
   PUT UNFORMATTED "Month" ";" MONTH(begdt) ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP.
    */
    /*    SS - 20070315 E     */


   {xxglcfr2.i}

   {xxmfrtrail.i}
end.
{wbrp04.i &frame-spec = a}
