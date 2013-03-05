{mfdtitle.i "++ "}
DEFINE VAR effbdate LIKE tr_effdate.
DEFINE VAR effedate LIKE tr_effdate.
DEFINE VAR manual AS LOGICAL INITIAL YES.
DEFINE VAR detail AS LOGICAL INITIAL YES.
DEFINE VAR site11 LIKE tr_site.
DEFINE VAR site12 LIKE tr_site.

DEFINE VAR urid LIKE tr_userid.
DEFINE VAR urid1 LIKE tr_userid.

DEFINE VAR qtysum LIKE tr_qty_loc.


DEFINE WORKFILE xxwkpt
       FIELD partpt LIKE tr_part
       FIELD qty LIKE tr_qty_loc
       FIELD site LIKE tr_site
       FIELD usid LIKE tr_userid
       FIELD effdate LIKE tr_effdate
       FIELD program LIKE  tr_program
       FIELD nbr LIKE tr_trnbr
       FIELD lot LIKE tr_lot. /*so */
       


FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 site11 LABEL "地点" COLON 18  site12 LABEL {t001.i} COLON 49 SKIP
 effbdate LABEL "开始日期" COLON 18 effedate LABEL "结束日期" COLON 49 SKIP
 urid LABEL "用户ID" COLON 18 urid1 LABEL "至" COLON 49 SKIP
 manual LABEL "人工调整"   COLON 18 SKIP
 detail LABEL "详细记录"   COLON 18 
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
setframelabels(frame a:handle).

/* 按事务号检查发动机回冲的数量*/


REPEAT:


	     if site11 = hi_char then site11 = "".   
	     if effbdate = low_date then effbdate = ?.
	     if effedate = hi_date then effedate = ?.

         IF urid = hi_char THEN urid = "".
         IF urid1 = "" THEN urid1 = hi_char.

	     	     
	     if  site12 = "" then site12 = hi_char.
	     /*if  effbdate = ? then effbdate = low_date.
	     if  effedate = ? then effedate = hi_date. */

    
     UPDATE site11 site12 effbdate effedate urid urid1 manual detail with frame a.
    {mfquoter.i site11}
    {mfquoter.i site12}
    {mfquoter.i effbdate}
    {mfquoter.i effedate}
    {mfquoter.i urid}
    {mfquoter.i urid1}
    {mfquoter.i manual}
    {mfquoter.i detail}
    {mfselbpr.i "printer" 132}

    FOR EACH xxwkpt.
        DELETE xxwkpt.
    END.

    FOR EACH tr_hist WHERE tr_domain = "DCEC" AND tr_effdate >= effbdate AND tr_effdate <= effedate AND tr_site >= site11 AND tr_site <= site12 AND tr_type = "ISS-WO"
         AND tr_userid >= urid AND tr_userid <= urid1.
        CREATE xxwkpt.
        ASSIGN xxwkpt.part = tr_part
               xxwkpt.qty = tr_qty_loc
               xxwkpt.site = tr_site
               xxwkpt.usid = tr_userid
               xxwkpt.effdate = tr_effdate
               xxwkpt.program = tr_program
               xxwkpt.lot = tr_lot
               xxwkpt.nbr =tr_trnbr.
    END.
   PUT SPACE(20)"手动调整回冲报表" SKIP.
   PUT "零件号                  调整数量       地点        用户ID   生效日期      程序名称      工单号       工单零件       事务处理号 " SKIP.
   PUT "-------------------------------------------------------------------------------------------------------------------------------" SKIP.

   
   IF manual = YES AND detail = YES THEN DO:
        FOR EACH xxwkpt WHERE usid <> "admin" AND usid <> "mfg" AND usid <> "qaduser".
            FIND FIRST tr_hist WHERE  tr_lot = lot AND tr_type = "RCT-WO" NO-LOCK NO-ERROR.
            IF AVAIL tr_hist THEN put part space(3) qty space(3) site space(3) usid space(3) effdate space(3) program space(3) lot space(3) tr_part space(3) nbr space(2) usid skip.
        END.
    END.

    IF manual = YES AND detail = NO THEN DO:
        FOR EACH xxwkpt WHERE usid <> "admin" AND usid <> "mfg" AND usid <> "qaduser" BREAK BY part.
            IF FIRST-OF(part) THEN qtysum = qty.
            qtysum = qtysum + qty.
            IF LAST-OF(part) THEN DO:
               FIND FIRST tr_hist WHERE  tr_lot = lot AND tr_type = "RCT-WO" NO-LOCK NO-ERROR.
               IF AVAIL tr_hist THEN put part space(3) qtysum space(3) site space(3) usid space(3) effdate space(3) program space(3) lot space(3) tr_part space(3) nbr space(2) usid skip.
            END.
        END.
    END.

    IF manual = NO AND detail = YES THEN DO:
        FOR EACH xxwkpt WHERE usid <> "admin" AND usid <> "mfg" AND usid <> "qaduser" NO-LOCK.
            FIND FIRST tr_hist WHERE  tr_lot = lot AND tr_type = "RCT-WO" NO-LOCK NO-ERROR.
            IF AVAIL tr_hist THEN put part space(3) qty space(3) site space(3) usid space(3) effdate space(3) program space(3) lot space(3) tr_part space(3) nbr space(2) usid skip.
        END.
    END.

    IF manual = NO AND detail = NO THEN DO:
        FOR EACH xxwkpt WHERE usid <> "admin" AND usid <> "mfg" AND usid <> "qaduser" BREAK BY part.
            IF FIRST-OF(part) THEN qtysum = qty.
            qtysum = qtysum + qty.
            IF LAST-OF(part) THEN DO:
               FIND FIRST tr_hist WHERE  tr_lot = lot AND tr_type = "RCT-WO" NO-LOCK NO-ERROR.
               IF AVAIL tr_hist THEN put part space(3) qtysum space(3) site space(3) usid space(3) effdate space(3) program space(3) lot space(3) tr_part space(3) nbr space(2) usid skip.
            END.
        END.
    END.
    PUT "-------------------------------------------------------------------------------------------------------------" SKIP.
    PUT "保管员               材料经理                  材料部长               财务部长" SKIP.

    {mfguitrl.i} 
    {mfreset.i}  
    {mfgrptrm.i} 
END.


