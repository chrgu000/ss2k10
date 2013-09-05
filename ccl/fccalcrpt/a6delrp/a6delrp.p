/*a6delrp.p 客戶交期推演報表资料删除..*/

/* DISPLAY TITLE */
{mfdtitle.i "130904.1"}

DEFINE VARIABLE site       LIKE wo_site .
DEFINE VARIABLE site1      LIKE wo_site .
DEFINE VARIABLE cust       LIKE a6rq_cust.
DEFINE VARIABLE cust1      LIKE a6rq_cust .
DEFINE VARIABLE custpono   LIKE a6rq_custpono .
DEFINE VARIABLE custpoln   LIKE a6rq_custpoln INIT 0  .
DEFINE VARIABLE creatdate  LIKE a6rq_crea_date .
DEFINE VARIABLE creatdate1 LIKE a6rq_crea_date .
DEFINE VARIABLE qty_oh     LIKE a6rqd_rq_qty .
DEFINE VARIABLE ln         LIKE mrp_line .
DEFINE VARIABLE nbr        LIKE mrp_nbr .
DEFINE VARIABLE desc1      LIKE pt_desc1 .
DEFINE VARIABLE yn         AS LOGICAL INIT NO .

FORM
    site  COLON 20
    site1 LABEL {t001.i} COLON  38 SKIP
    cust  COLON 20
    cust1 LABEL {t001.i} COLON  38 SKIP
    creatdate   COLON 20
    creatdate1  LABEL  {t001.i} COLON  38 SKIP
    custpono  COLON 20
    custpoln  COLON 20  SKIP
    yn        COLON 20
WITH  FRAME  a SIDE-LABELS  WIDTH  80 ATTR-SPACE .
/* SET EXTERNAL LABELS */
setFrameLabels(FRAME  a:HANDLE ).

FORM
     a6rq_site
     a6rq_cust
     a6rq_custpono
     a6rq_custpoln
     a6rq_part
     desc1
     a6rq_due_date
WITH FRAME b .
setFrameLabels(FRAME  b:HANDLE ).

{wbrp01.i}
REPEAT WITH FRAME b WIDTH 200 :

    IF  site1        =  hi_char     THEN   site1        =  ''  .
    IF  cust1        =  hi_char     THEN   cust1        =  ''  .
    IF  creatdate1   =  hi_date     THEN   creatdate1   =  ?  .

   IF  c-application-mode <> 'web' THEN UPDATE  site site1 cust cust1 creatdate creatdate1 custpono custpoln  yn  WITH  FRAME  a .

   {wbrp06.i &COMMAND  = UPDATE  &FIELDS  = "  site site1 cust cust1 creatdate creatdate1 custpono custpoln yn  " &frm = "a"}

   IF  (c-application-mode <> 'web') OR (c-application-mode = 'web' AND (c-web-request BEGINS  'data')) THEN  DO :
          IF  site1        =  ''     THEN   site1        = hi_char  .
          IF  cust1        =  ''     THEN   cust1        = hi_char  .
          IF  creatdate1   =  ?      THEN   creatdate1   = hi_date  .
   END .

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 200
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   {mfphead.i}

    FOR EACH a6rq_mstr WHERE (a6rq_site >= site  OR site  = '' ) AND  ( a6rq_site <= site1 OR site1  = '' )
                         AND ( a6rq_cust >= cust OR cust = '' )  AND ( a6rq_cust <= cust1 OR cust1 = '' )
                         AND ( a6rq_custpono = custpono  OR custpono = '' )  AND ( a6rq_custpoln = custpoln OR custpoln = 0 )
                         AND  (a6rq_crea_date >= creatdate  OR creatdate = ? ) AND ( a6rq_crea_date <= creatdate1 OR creatdate1 = ?)
                      NO-LOCK  BY a6rq_due_date  BY a6rq_part  :
        FIND pt_mstr WHERE pt_part = a6rq_part NO-LOCK NO-ERROR .
        IF AVAILABLE pt_mstr THEN  ASSIGN desc1 = pt_desc1 .
        ELSE desc1 = '' .
        DISP a6rq_site a6rq_cust a6rq_custpono  a6rq_custpoln a6rq_part  desc1 a6rq_due_date .
        DOWN .
    END.
    IF yn THEN DO:
        FOR EACH a6rq_mstr WHERE (a6rq_site >= site  OR site  = '' ) AND  ( a6rq_site <= site1 OR site1  = '' )
                             AND ( a6rq_cust >= cust OR cust = '' )  AND ( a6rq_cust <= cust1 OR cust1 = '' )
                             AND ( a6rq_custpono = custpono  OR custpono = '' )  AND ( a6rq_custpoln = custpoln OR custpoln = 0 )
                             AND  (a6rq_crea_date >= creatdate  OR creatdate = ? ) AND ( a6rq_crea_date <= creatdate1 OR creatdate1 = ?)
                             BY a6rq_due_date  BY a6rq_part  :
               FOR EACH a6rqd_det WHERE a6rqd_site = site AND a6rqd_cust = a6rq_cust AND a6rqd_custpono = a6rq_custpono
                         AND a6rqd_custpoln = a6rq_custpoln :
                   DELETE a6rqd_det .
               END.
               FOR EACH a6rrd_det WHERE a6rrd_site = site AND a6rrd_cust = a6rq_cust AND a6rrd_custpono = a6rq_custpono
                        AND a6rrd_custpoln = a6rq_custpoln :
                   DELETE a6rrd_det .
               END.
               DELETE a6rq_mstr .
        END.
        PUT '以上內容已經全部刪除...!'.
    END.

    {mfreset.i}
end.

{wbrp04.i &frame-spec = a}
