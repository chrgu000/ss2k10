/* $Revision: eb2.1sp5    BY: Bill Jiang     DATE: 06/06/08   ECO: *SS - 20080606.1*      */
/* $Revision: eb2.1sp5    BY: Bill Jiang     DATE: 07/19/08   ECO: *SS - 20080719.1*      */
/* SS - 20130101.1 By: Randy Li */
/* SS - 20130101.1 RNB
【 20130101.1 】
1.显示会计单位名称为ad_name + ad_line.
【 20130101.1 】
SS - 20130101.1 - RNE */
                                                         
/* DISPLAY TITLE */
/* SS - 20080719.1 - B */
/*
{mfdtitle.i "2+ "}

{mfdtitle.i "20080719.1"} */
/* SS - 20080719.1 - E */

/* SS - 20130101.1 - B */
{mfdtitle.i "20130101.1"}
/* SS - 20130101.1 - E */
{cxcustom.i "GLUTRRP.P"}

{ssbigl05a.i "new"}

DEF VAR posted_only AS LOGICAL INIT YES .

define variable glname            like en_name     no-undo.

/* GET NAME OF CURRENT ENTITY */
find en_mstr where 
   en_domain = GLOBAL_domain AND
   en_entity = current_entity 
   no-lock no-error.
if not available en_mstr then do:
   {pxmsg.i &MSGNUM=3059 &ERRORLEVEL=3} /* NO PRIMARY ENTITY DEFINED */
   if c-application-mode <> 'web' THEN DO:
      pause.
   END.
   leave.
end.
else do:
   glname = en_name.
   release en_mstr.
end.
assign
   entity  = current_entity
   entity1 = entity.

/* 报表名称 */
/* SS - 20130101.1 - B */
/*
find first en_mstr where en_domain = global_domain and  en_entity = 
FIND FIRST ad_mstr 
   WHERE 
   ad_domain = GLOBAL_domain AND 
   ad_addr = "~~reports" 
   NO-LOCK 
   NO-ERROR
   .
IF AVAILABLE ad_mstr THEN DO:
    ASSIGN
       NAME_reports = ad_name
       .
END.
ELSE DO:
   ASSIGN
      NAME_reports = ""
      .
END.
*/
/* SS - 20130101.1 - E */
/* 用户名称 */
FIND FIRST usr_mstr WHERE usr_userid = global_userid NO-LOCK NO-ERROR.
IF AVAIL USr_mstr THEN DO:
   ASSIGN 
      NAME_usr = usr_name
      .
END.
ELSE DO:
   ASSIGN 
      NAME_usr = ""
      .
END.

/* SELECT FORM */
form
   entity   colon 25    entity1 colon 50 label {t001.i}
   ref      colon 25    ref1    colon 50 label {t001.i}
   dt       colon 25    dt1     colon 50 label {t001.i}
   effdt    colon 25    effdt1  colon 50 label {t001.i}
   batch     colon 25    batch1   COLON 50 LABEL {t001.i}
   type     colon 25    type1   COLON 50 LABEL {t001.i}
   user-id   COLON 25
   unb      colon 25
   posted_only   COLON 25
   with frame a side-labels attr-space width 80
   title color normal glname.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */
{wbrp01.i}

repeat:
   if entity1 = hi_char then entity1 = "".
   if ref1 = hi_char then ref1 = "".
   if dt =  low_date then dt = ?.
   if dt1 = hi_date then dt1 = ?.
   if effdt = low_date then effdt = ?.
   if effdt1 = hi_date then effdt1 = ?.
   IF batch1 = hi_char   THEN batch1 = "" .
   IF type1 = hi_char   THEN type1 = "" .

   if c-application-mode <> 'web' THEN DO:
      update
         entity entity1
         ref ref1
         dt dt1
         effdt effdt1
         batch  batch1
         TYPE type1
         user-id
         unb
         posted_only
         with frame a.
   END.

   {wbrp06.i 
      &command = update 
      &fields = "entity entity1 ref ref1 dt dt1 effdt effdt1 batch batch1 TYPE type1 user-id unb posted_only" 
      &frm = "a"
      }

   {&GLUTRRP-P-TAG19}
   if (c-application-mode <> 'web') or (c-application-mode = 'web' and (c-web-request begins 'data')) then do:
      /* CREATE BATCH INPUT STRING */
      bcdparm = "".
      {&GLUTRRP-P-TAG20}
      {mfquoter.i entity  }
      {mfquoter.i entity1 }
      {mfquoter.i ref     }
      {mfquoter.i ref1    }
      {mfquoter.i dt      }
      {mfquoter.i dt1     }
      {mfquoter.i effdt   }
      {mfquoter.i effdt1  }
      {mfquoter.i batch    }
      {mfquoter.i batch1   }
      {mfquoter.i TYPE    }
      {mfquoter.i type1   }
      {mfquoter.i user-id  }
      {mfquoter.i unb     }
      {mfquoter.i posted_only  }

      if entity1 = "" then entity1 = hi_char.
      if ref1 = "" then ref1 = hi_char.
      if dt = ?  then dt = low_date.
      if dt1 = ? then dt1 = hi_date.
      if effdt = ? then effdt = low_date.
      if effdt1 = ? then effdt1 = hi_date.
      IF batch1 = ""   THEN batch1 = hi_char .
      IF type1 = ""   THEN type1 = hi_char .
   end.

/* SS - 20130101.1 - B */
find first en_mstr where en_domain = global_domain and  en_entity = entity no-lock no-error.
FIND FIRST ad_mstr WHERE ad_domain = GLOBAL_domain AND  ad_addr = en_entity no-lock NO-ERROR .
IF AVAILABLE ad_mstr THEN DO:
    ASSIGN
       NAME_reports = trim(ad_name) + trim(ad_line1)
       .
END.
ELSE DO:
   ASSIGN
      NAME_reports = ""
      .
END.
/* SS - 20130101.1 - E */  
   
   
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
      &printWidth = 132
      &pagedFlag = " "
      &stream = " "
      &appendToFile = " "
      &streamedOutputToTerminal = " "
      &withBatchOption = "yes"
      &displayStatementType = 1
      &withCancelMessage = "yes"
      &pageBottomMargin = 6
      &withEmail = "yes"
      &withWinprint = "yes"
      &defineVariables = "yes"}
               
   {ssbigl05.i}  

   EMPTY TEMP-TABLE tt1.
   EMPTY TEMP-TABLE tt2.

   {gprun.i ""ssbigl05gltr.p""}

   IF posted_only = NO THEN DO:
      {gprun.i ""ssbigl05glt.p""}
   END. /* posted_only = no */

   /* 输出到BI */
   /*
   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname, 1, LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.
   */

   PUT unformatted     "ExcelFile;ssbigl05" SKIP.
   PUT unformatted     "SaveFile;" + "ssbigl05" + "-" + string(today, "99999999") + "-" + replace(string(time, "HH:MM:SS"), ":", "")  SKIP.
   PUT unformatted     "exclemacro;PrintPreview1"  SKIP.
   PUT unformatted     "BeginRow;2"  SKIP.

   FOR EACH tt2:

       EXPORT DELIMITER ";" 
          tt2_ref 
          tt2_line 
          tt2_desc 
          tt2_ascp 
          tt2_as_desc 
          tt2_ex_rate 
          tt2_char1 
          tt2_user2 
          tt2_effdate 
          tt2_dr_amt 
          tt2_cr_amt 
          tt2_decimal1 
          tt2_curramt 
          tt2_cp_desc 
          ""
          tt2_batch
          .
       FOR EACH tt1 WHERE tt1_ref = tt2_ref:
          EXPORT DELIMITER ";" 
             tt1_ref 
             tt1_line 
             tt1_desc 
             tt1_ascp 
             tt1_as_desc 
             tt1_ex_rate 
             tt1_char1 
             tt1_user2 
             tt1_effdate 
             tt1_dr_amt 
             tt1_cr_amt 
             tt1_decimal1 
             tt1_curramt 
             ("P_" + STRING(tt1_page) + "/" + STRING(tt2_page))
             tt1_cp_desc 
             tt1_batch
             .
       END.
   END.

   /* REPORT TRAILER  */
   {a6mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
