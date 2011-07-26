/* glcinrp.p - GENERAL LEDGER COMPARATIVE INCOME STATEMENT REPORT         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/* $Revision: 1.28 $                                                       */
/*V8:ConvertMode=Report                                                   */
/* REVISION: 1.0      LAST MODIFIED: 12/03/86   BY: emb                   */
/*                                   06/18/87       jms                   */
/*                                   01/25/88       jms                   */
/*                                   02/02/88   by: jms  CSR 24912        */
/* REVISION: 4.0      LAST MODIFIED: 02/29/88   by: jms                   */
/*                                   02/29/88   BY: WUG *A175*            */
/*                                   03/14/88   by: jms                   */
/*                                   06/13/88   by: jms *A274* (no-undo   */
/*                                   07/29/88   by: jms *A373*            */
/*                                   10/10/88   by: jms *A476*            */
/*                                   11/08/88   by: jms *A526*            */
/* REVISION: 5.0      LAST MODIFIED: 04/25/89   by: jms *B066*            */
/*                                   09/01/89   by: jms *B271* (rev only) */
/*                                   09/19/89   by: jms *B135*            */
/*                                   11/21/89   by: jms *B400* (rev only) */
/*                                   02/02/90   by: jms *B499* (rev only) */
/*                                   06/04/90   by: jms *B701* (rev only) */
/*                                   06/27/90   by: jms *B721* (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 10/09/90   by: jms *D034*            */
/*                                   11/07/90   by: jms *D189*            */
/*                                   01/31/91   by: jms *D325*            */
/*                                   02/07/91   by: jms *D330*            */
/*                                   02/20/91   by: jms *D366*            */
/*                                   04/03/91   by: jms *D488* (rev only) */
/*                                   04/04/91   by: jms *D493* (rev only) */
/*                                   04/23/91   by: jms *D577* (rev only) */
/*                                   05/03/91   by: jms *D612*            */
/*                                   07/07/91   by: jms *D756*            */
/*                                   07/23/91   by: jms *D791* (rev only) */
/*                                   09/05/91   by: jms *D849* (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 11/13/91   by: jms *F058*            */
/*                                   02/04/92   by: jms *F146*            */
/*                                   02/25/92   by: jms *F231*            */
/*                                   06/24/92   by: jms *F702*            */
/*                                   06/29/92   by: jms *F712*            */
/*                                   06/30/92   by: jms *F714*            */
/*                                   09/01/92   by: jms *F890* (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 09/16/92   by: mpp *G030* (rev only) */
/*                                   09/18/92   by: jms *F915* (rev only) */
/*                                   04/20/93   by: skk *G993* (rev only) */
/*                                   09/03/94   by: srk *FQ80*            */
/*                                   04/19/95   by: srk *G0L1*            */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   by: ays *K0TC*            */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 03/18/98   BY: *J242*   Sachin Shah  */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: LN/SVA *L00W*         */
/* REVISION: 8.6E     LAST MODIFIED: 06/04/98   BY: Mohan CK *K1RK*       */
/* REVISION: 8.6E     LAST MODIFIED: 06/23/98   BY: *L01G* Robin McCarthy */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01W* Brenda Milton  */
/* REVISION: 8.6E     LAST MODIFIED: 08/04/98   BY: *L05G* Brenda Milton  */
/* REVISION: 8.6E     LAST MODIFIED: 08/12/98   BY: *H1M0* Prashanth Narayan */
/* REVISION: 8.6E     LAST MODIFIED: 08/13/98   BY: *H1MY* Prashanth Narayan */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt         */
/* REVISION: 8.6E     LAST MODIFIED: 10/07/99   BY: *L0JZ* Ranjit Jain       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown        */
/* REVISION: 9.1      LAST MODIFIED: 09/01/00   BY: *N0QH* Mudit Mehta       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.26  BY: Jean Miller DATE: 04/25/02 ECO: *P06H* */
/* $Revision: 1.28 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* $Revision: 1.28 $ BY: Bill Jiang DATE: 08/16/07 ECO: *SS - 20070816.1* */
/* $Revision: 1.20 $ BY: Bill Jiang DATE: 02/18/08 ECO: *SS - 20080218.1* */

/* SS - 20080218.1 - B */
/*
1. 增加了日期输出格式的处理
*/
/* SS - 20080218.1 - E */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20080218.1 - B */
{ssDate.i}
/* SS - 20080218.1 - E */
 
/* SS - 20070816.1 - B */
{ssglcinrp01.i "new"}
/* SS - 20070816.1 - E */

{mfdtitle.i "2+ "}

define new shared variable glname     like en_name no-undo.
define new shared variable begdt      like gltr_eff_dt extent 2 no-undo.
define new shared variable enddt      like gltr_eff_dt extent 2 no-undo.
define new shared variable budget     like mfc_logical extent 2 no-undo.
define new shared variable zeroflag   like mfc_logical
                                      label "Suppress Zero Amounts" no-undo.
define new shared variable sub        like sb_sub no-undo.
define new shared variable sub1       like sb_sub no-undo.
define new shared variable ctr        like cc_ctr no-undo.
define new shared variable ctr1       like cc_ctr no-undo.
define new shared variable level      as integer format ">9" initial 99
                                      label "Level" no-undo.
define new shared variable varflag    like mfc_logical initial true
                                      label "Print Variances" no-undo.
define new shared variable ccflag     like mfc_logical no-undo
                                      label "Summarize Cost Centers".
define new shared variable subflag    like mfc_logical no-undo
                                      label "Summarize Sub-Accounts".
define new shared variable fiscal_yr  like glc_year extent 2 no-undo.
define new shared variable peryr      as character format "x(8)" no-undo.
define new shared variable per_end    like glc_per extent 2 no-undo.
define new shared variable per_beg    like glc_per extent 2 no-undo.
define new shared variable prtflag    like mfc_logical initial yes no-undo
                                      label "Suppress Account Numbers".
define new shared variable entity     like en_entity no-undo.
define new shared variable entity1    like en_entity no-undo.
define new shared variable cname      like glname no-undo.
define new shared variable hdrstring  as character format "x(8)" no-undo.
define new shared variable hdrstring1 as character format "x(8)" no-undo.
define new shared variable yr_end     as date extent 2 no-undo.
define new shared variable ret        like ac_code no-undo.
define new shared variable rpt_curr   like gltr_curr no-undo.
define new shared variable budgetcode like bg_code extent 2 no-undo.
define new shared variable prt1000    like mfc_logical no-undo
                                      label "Round to Nearest Thousand".
define new shared variable roundcnts  like mfc_logical no-undo
                                      label "Round to Nearest Whole Unit".
define new shared variable prtfmt     as character format "x(30)" no-undo.
define new shared variable vprtfmt    as character format "x(30)" no-undo.
define new shared variable income     like gltr_amt extent 2 no-undo.
define new shared variable percent    as decimal format "->>>>.9%"
                                      extent 2 no-undo.
define new shared variable et_income  like income     no-undo.

define variable msg1000   as character format "x(16)" no-undo.
define variable i         as integer no-undo.
define variable balance   like gltr_amt no-undo.
define variable knt       as integer no-undo.
define variable dt        as date no-undo.
define variable cmmt-yn   like mfc_logical label "Print Comments" no-undo.
define variable cmmt_ref  like cd_ref label "Master Comment Reference" no-undo.
define variable cmmt_type like cd_type label "Comment Type" no-undo.
define variable use_cc    like co_use_cc no-undo.
define variable use_sub   like co_use_sub no-undo.

/* The following are necessary since the mc PROCEDUREs are called*/
/* From within internal PROCEDUREs in this program */
{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "mcui" "p"}

/* ***** DECLARATION COMMON EURO TOOLKIT VARIABLES ***** */
{etrpvar.i &new = "new"}
{etvar.i   &new = "new"}

/*        ***** GET EURO INFORMATION ***** */
{eteuro.i}


/* SELECT FORM */
form
   entity         colon 30 entity1   colon 58 label {t001.i}
   cname          colon 30
   begdt[1]       colon 30 label "Column 1 -- Date"
   enddt[1]       colon 58 label {t001.i}
   budget[1]      colon 30 label "Use Budgets"
   budgetcode[1]  colon 58 label "Budget Code"
   begdt[2]       colon 30 label "Column 2 -- Date"
   enddt[2]       colon 58 label {t001.i}
   budget[2]      colon 30 label "Use Budgets"
   budgetcode[2]  colon 58 label "Budget Code" skip(1)
   /* SS - 20070816.1 - B */
   /*
   sub            colon 30 sub1      colon 58 label {t001.i}
   ctr            colon 30 ctr1      colon 58 label {t001.i}
   level          colon 30
   zeroflag       colon 30 varflag       colon 65
   subflag        colon 30 prtflag       colon 65
   ccflag         colon 30
   prt1000        colon 30 roundcnts     colon 65
   cmmt-yn        colon 30 cmmt_type     colon 65
   cmmt_ref       colon 30
   */
   /* SS - 20070816.1 - E */
   et_report_curr colon 30
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* GET NAME OF CURRENT ENTITY */

for first en_mstr fields( en_domain en_name en_entity) no-lock
    where en_mstr.en_domain = global_domain and  en_entity = current_entity:
end.
if not available en_mstr then do:
   {pxmsg.i &MSGNUM=3059 &ERRORLEVEL=3} /* NO PRIMARY ENTITY DEFINED */
   if c-application-mode <> 'web' then
      pause.
   leave.
end.
else do:
   glname = en_name.
   release en_mstr.
end.

assign
   entity  = current_entity
   entity1 = current_entity
   cname   = glname.

/* GET RETAINED EARNINGS CODE FROM CONTROL FILE */

for first co_ctrl fields( co_domain co_ret co_use_cc co_use_sub)  where
co_ctrl.co_domain = global_domain no-lock:
end.
if not available co_ctrl then do:
   /* CONTROL FILE MUST BE DEFINED BEFORE RUNNING REPORT */
   {pxmsg.i &MSGNUM=3032 &ERRORLEVEL=3}
   if c-application-mode <> 'web' then
      pause.
   leave.
end.

assign
   ret      = co_ret
   use_cc   = co_use_cc
   use_sub  = co_use_sub
   rpt_curr = base_curr.

/* DEFINE HEADERS */
form header
   cname         at 1 space(2)
   msg1000
   mc-curr-label at 60
   et_report_curr skip
   mc-exch-label at 60 mc-exch-line1 skip
   mc-exch-line2 at 82 skip(1)
   skip
   hdrstring at 61  hdrstring1 at 91
   begdt[1] at 60 " " + getTermLabel("TO",2) format "x(3)"
   getTermLabel("%_OF",10) at 76 format "x(10)"
   begdt[2] at 90 {t001.i}
   getTermLabel("%_OF",10) at 106 format "x(10)"
   enddt[1] at 61
   getTermLabel("INCOME",10) at 75 format "x(10)"
   enddt[2] at 91
   getTermLabel("INCOME",10) at 105 format "x(10)"
   getTermLabelRt("VARIANCE",10) to 130 format "x(10)"
   "--------------------" to 71 "--------" at 73
   "--------------------" to 101
   "--------" at 103 "--------------------" at 112
   skip(1)
with frame phead1 page-top width 132 no-box.

form header
   cname at 1 space(2)
   msg1000
   mc-curr-label et_report_curr skip
   mc-exch-label at 60 mc-exch-line1 skip
   mc-exch-line2 at 82 skip(1)
   skip
   hdrstring at 61  hdrstring1 at 91
   begdt[1] at 60 " " + getTermLabel("TO",2) format "x(3)"
   getTermLabel("%_OF",10) at 76  format "x(10)"
   begdt[2] at 90 " " + getTermLabel("TO",2) format "x(3)"
   getTermLabel("%_OF",10) at 106 format "x(10)"
   enddt[1] at 61
   getTermLabel("INCOME",10) at 75 format "x(10)"
   enddt[2] at 91
   getTermLabel("INCOME",10) at 105 format "x(10)"
   "--------------------" to 71 "--------" at 73
   "--------------------" to 101 "--------" at 103
   skip(1)
with frame phead2 page-top width 132 no-box.

form header
   cname at 1 space(2) msg1000 skip
   hdrstring at 58  hdrstring1 at 85
   begdt[1] at 57 " " + getTermLabel("TO",2) format "x(3)"
   getTermLabel("%_OF",10) at 73 format "x(10)"
   begdt[2] at 84 {t001.i}
   getTermLabel("%_OF",10) at 100 format "x(10)"
   getTermLabelRt("PERCENT",3) + "  " to 131 format "x(5)"
   enddt[1] at 58
   getTermLabel("INCOME",10) at 72 format "x(10)"
   enddt[2] at 85
   getTermLabel("INCOME",10) at 99 format "x(10)"
   getTermLabelRt("VARIANCE",10) to 121 format "x(10)"
   getTermLabelRt("INC/DEC",9) to 131 format "x(9)"
   "-----------------" to 68 "--------" at 70
   "-----------------" to 95
   "--------" at 97 "-----------------" at 106 "--------" to 131
   skip(1)
with frame pcthead page-top width 132 no-box.

/* USED IF REPORT DOESN'T START AT PAGE TOP */
form header
   hdrstring at 61  hdrstring1 at 91
   begdt[1] at 60 " " + getTermLabel("TO",2) format "x(3)"
   getTermLabel("%_OF",10) at 76 format "x(10)"
   begdt[2] at 90 {t001.i}
   getTermLabel("%_OF",10) at 106 format "x(10)"
   enddt[1] at 61
   getTermLabel("INCOME",10) at 75 format "x(10)"
   enddt[2] at 91
   getTermLabel("INCOME",10) at 105 format "x(10)"
   getTermLabelRt("VARIANCE",10) to 130
   "--------------------" to 71 "--------" at 73
   "--------------------" to 101
   "--------" at 103 "--------------------" at 112
   skip(1)
with frame cmmthead1 width 132 no-box.

form header
   hdrstring at 61  hdrstring1 at 91
   begdt[1] at 60 " " + getTermLabel("TO",2) format "x(3)"
   getTermLabel("%_OF",10) at 76   format "x(10)"
   begdt[2] at 90 " " + getTermLabel("TO",2) format "x(3)"
   getTermLabel("%_OF",10) at 106  format "x(10)"
   enddt[1] at 61
   getTermLabel("INCOME",10) at 75 format "x(10)"
   enddt[2] at 91
   getTermLabel("INCOME",10) at 105 format "x(10)"
   "--------------------" to 71 "--------" at 73
   "--------------------" to 101 "--------" at 103
   skip(1)
with frame cmmthead2 width 132 no-box.

/* USED IF REPORT DOESN'T START AT PAGE TOP */
form header
   hdrstring at 58  hdrstring1 at 85
   begdt[1] at 57 " " + getTermLabel("TO",2) format "x(3)"
   getTermLabel("%_OF",10) at 73 format "x(10)"
   begdt[2] at 84 {t001.i}
   getTermLabel("%_OF",10) at 100 format "x(10)"
   getTermLabelRt("PERCENT",3) + "  " to 131 format "x(5)"
   enddt[1] at 58
   getTermLabel("INCOME",10) at 72 format "x(12)"
   enddt[2] at 85
   getTermLabel("INCOME",10) at 99 format "x(10)"
   getTermLabelRt("VARIANCE",10) to 121 format "x(10)"
   getTermLabelRt("INC/DEC",8) to 131 format "x(8)"
   "-----------------" to 68 "--------" at 70
   "-----------------" to 95
   "--------" at 97 "-----------------" at 106 "-------" to 131
   skip(1)
with frame cmmthead3 width 132 no-box.

{wbrp01.i}

/* REPORT BLOCK */
mainloop:
repeat:
   /* SS - 20070816.1 - B */
   hide all no-pause .
   view frame dtitle .
   /* SS - 20070816.1 - E */

   /* INPUT OPTIONS */
   if sub1 = hi_char then assign sub1 = "".
   if ctr1 = hi_char then assign ctr1 = "".
   if entity1 = hi_char then assign entity1 = "".

   if c-application-mode <> 'web' then
      update
         entity
         entity1
         cname
         begdt[1]
         enddt[1]
         budget[1]
         budgetcode[1]
         begdt[2]
         enddt[2]
         budget[2]
         budgetcode[2]
         /* SS - 20070816.1 - B */
         /*
         sub     when (use_sub)
         sub1    when (use_sub)
         ctr     when (use_cc)
         ctr1    when (use_cc)
         level
         zeroflag
         varflag
         subflag when (use_sub)
         prtflag
         ccflag  when (use_cc)
         prt1000
         roundcnts
         cmmt-yn
         cmmt_type
         cmmt_ref
         */
         /* SS - 20070816.1 - E */
         et_report_curr
      with frame a.

   {wbrp06.i &command = update &fields = "  entity entity1 cname
        begdt [ 1 ] enddt [ 1 ] budget [ 1 ] budgetcode [ 1 ] begdt [ 2 ]
        enddt [ 2 ] budget [ 2 ] budgetcode [ 2 ]  
      /* SS - 20070816.1 - B */
      /*
      sub when
        (use_sub) sub1 when (use_sub) ctr when (use_cc)  ctr1
        when (use_cc) level zeroflag varflag subflag
        when (use_sub)  prtflag ccflag when (use_cc) prt1000 roundcnts
        cmmt-yn cmmt_type cmmt_ref
        */
      /* SS - 20070816.1 - E */
        et_report_curr
        " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      /* CREATE BATCH INPUT STRING */
      assign bcdparm = "".

      run set-vars.

      if entity1 = "" then assign entity1 = hi_char.
      if sub1 = "" then assign sub1 = hi_char.
      if ctr1 = "" then assign ctr1 = hi_char.

      do i = 1 to 2:

         /* CHECK FOR VALID REPORT DATE */
         if enddt[i] = ? then assign enddt[i] = today.
         display enddt[i] with frame a.
         {glper1.i enddt[i] peryr}  /*GET PERIOD/YEAR*/
         if peryr = "" then do:
            /* DATE NOT WITHIN A VALID PERIOD */
            {pxmsg.i &MSGNUM=3018 &ERRORLEVEL=3}
            if c-application-mode = 'web' then return.
            else next-prompt enddt[i] with frame a.
            undo mainloop.
         end.

         /* VALIDATE DATES AND DETERMINE PERIODS */
         assign
            fiscal_yr[i] = glc_year
            per_end[i] = glc_per.

         for first glc_cal fields( glc_domain glc_end glc_per glc_start
         glc_year)
             where glc_cal.glc_domain = global_domain and  glc_year =
             fiscal_yr[i] and glc_per = 1 no-lock:
         end.
         if not available glc_cal then do:
            /* NO FIRST PERIOD DEFINED FOR THIS FISCAL YEAR. */
            {pxmsg.i &MSGNUM=3033 &ERRORLEVEL=3}
            if c-application-mode = 'web' then return.
            else next-prompt begdt[i] with frame a.
            undo mainloop.
         end.
         if begdt[i] = ? then assign begdt[i] = glc_start.
         display begdt[i] with frame a.
         if begdt[i] < glc_start then do:
            /*REPORT CANNOT SPAN FISCAL YEARS*/
            {pxmsg.i &MSGNUM=3031 &ERRORLEVEL=3}
            if c-application-mode = 'web' then return.
            else next-prompt begdt[i] with frame a.
            undo mainloop.
         end.

         if begdt[i] > enddt[i] then do:
            {pxmsg.i &MSGNUM=27 &ERRORLEVEL=3} /* INVALID DATE */
            if c-application-mode = 'web' then return.
            else next-prompt begdt[i] with frame a.
            undo mainloop.
         end.

         {glper1.i begdt[i] peryr} /* GET PERIOD/YEAR */
         if peryr = "" then do:
            /* DATE NOT WITHIN A VALID PERIOD */
            {pxmsg.i &MSGNUM=3018 &ERRORLEVEL=3}
            if c-application-mode = 'web' then return.
            else next-prompt begdt[i] with frame a.
            undo mainloop.
         end.
         assign per_beg[i] = glc_per.

         find last glc_cal  where glc_cal.glc_domain = global_domain and
         glc_year = fiscal_yr[i]
         no-lock no-error.
         assign yr_end[i] = glc_end.

      end.  /* do i = 1 to 2 */

      /*  CHECK FOR VALID LEVEL */
      if level < 1 or level > 99 then do:
         {pxmsg.i &MSGNUM=3015 &ERRORLEVEL=3}   /*INVALID LEVEL*/
         if c-application-mode = 'web' then return.
         /* SS - 20070816.1 - B */
         /*
         else next-prompt level with frame a.
         */
         /* SS - 20070816.1 - E */
         undo mainloop.
      end.

   end.  /* if (c-application-mode <> 'web') ... */

   /* THIS SECTION WAS MOVED ABOVE FROM AN INTERNAL */
   /* PROCEDURE SINCE THE UNDO, RETRY ETC. WAS NOT  */
   /* BEING EXECUTED CORRECTLY THERE.               */
   if et_report_curr <> "" then do:
      {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
         "(input et_report_curr,
           output mc-error-number)"}

      if mc-error-number = 0
         and et_report_curr <> rpt_curr then do:

         {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
            "(input et_report_curr,
              input rpt_curr,
              input "" "",
              input et_eff_date,
              output et_rate2,
              output et_rate1,
              output mc-seq,
              output mc-error-number)"}
      end.  /* if mc-error-number = 0 */

      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
         if c-application-mode = 'web' then return.
         else next-prompt et_report_curr with frame a.
         undo, retry.
      end.  /* if mc-error-number <> 0 */
      else if et_report_curr <> rpt_curr then do:

         {gprunp.i "mcui" "p" "mc-ex-rate-output"
            "(input et_report_curr,
              input rpt_curr,
              input et_rate2,
              input et_rate1,
              input mc-seq,
              output mc-exch-line1,
              output mc-exch-line2)"}
         {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
            "(input mc-seq)"}
      end.  /* else do */
   end.  /* if et_report_curr <> "" */
   if et_report_curr = "" or et_report_curr = rpt_curr then
      assign
         mc-exch-line1 = ""
         mc-exch-line2 = ""
         et_report_curr = rpt_curr.

   run init-et-var.

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
   /* SS - 20070816.1 - B */
   /*
   {mfphead.i}
   */

   EMPTY TEMP-TABLE ttssglcinrp01.
   /* SS - 20070816.1 - E */

   run print-report.

   /* SS - 20070816.1 - B */
   /*
   if varflag then hide frame phead1.
   else hide frame phead2.

   /* REPORT TRAILER */
   {mfrtrail.i}
   */
   PUT UNFORMATTED "#def REPORTPATH=$/Motor/" + SUBSTRING(execname,1,LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   /* SS - 20080218.1 - B */
   FIND FIRST mfc_ctrl WHERE mfc_domain = GLOBAL_domain AND mfc_field = "ssbi_date_format" NO-LOCK NO-ERROR.
   /* SS - 20080218.1 - E */

   FOR EACH ttssglcinrp01
      ,EACH ac_mstr NO-LOCK
      WHERE ac_domain = GLOBAL_domain
      AND ac_code = ttssglcinrp01_ac_code
      ,EACH fm_mstr NO-LOCK
      WHERE fm_domain = GLOBAL_domain
      AND fm_fpos = ac_fpos
      :
      /* SS - 20080218.1 - B */
      /*
       EXPORT DELIMITER ";" 
          cname
          begdt[1]
          enddt[1]
          begdt[2]
          enddt[2]
          fm_fpos
          fm_desc
          ac_code
          ac_desc
          ttssglcinrp01_et_balance[1]
          ttssglcinrp01_et_balance[2]
          .
      */
      IF AVAILABLE mfc_ctrl THEN DO:
         EXPORT DELIMITER ";" 
            cname
            ssDate(begdt[1],mfc_char)
            ssDate(enddt[1],mfc_char)
            ssDate(begdt[2],mfc_char)
            ssDate(enddt[2],mfc_char)
            fm_fpos
            fm_desc
            ac_code
            ac_desc
            ttssglcinrp01_et_balance[1]
            ttssglcinrp01_et_balance[2]
            .
      END.
      ELSE DO:
         EXPORT DELIMITER ";" 
            cname
            begdt[1]
            enddt[1]
            begdt[2]
            enddt[2]
            fm_fpos
            fm_desc
            ac_code
            ac_desc
            ttssglcinrp01_et_balance[1]
            ttssglcinrp01_et_balance[2]
            .
      END.
      /* SS - 20080218.1 - E */
   END.
   
   /* REPORT TRAILER */
   {a6mfrtrail.i}
   /* SS - 20070816.1 - E */

end.  /* repeat */

{wbrp04.i &frame-spec = a}

PROCEDURE set-format:

   /* SET FORMAT FOR AMOUNTS*/
   if roundcnts or prt1000 then do:
      if varflag then
         assign
            prtfmt  = "(>>>,>>>,>>>,>>9)"
            vprtfmt = "->>>,>>>,>>>,>>9".
      else
         assign
            prtfmt  = "(>>,>>>,>>>,>>>,>>9)"
            vprtfmt = "->>,>>>,>>>,>>>,>>9".
   end.
   else
      assign
         prtfmt  = "(>>>,>>>,>>>,>>9.99)"
         vprtfmt = "->>>,>>>,>>>,>>9.99".

END PROCEDURE.

PROCEDURE init-et-var:

   /* PERCENT VARIABLE INITIALISED TO ZERO FOR SUBSEQUENT RUN OF  */
   /* THE REPORT                                                  */

   assign
      percent = 0
      msg1000 = "".

   if prt1000 then
      assign
         msg1000 = "(" + getTermLabel("IN_1000'S",10)
                 + " " + et_report_curr + ")".

END PROCEDURE.

PROCEDURE display-header:

   /* DEFINE HEADERS */

   assign
      hdrstring = getTermLabel("ACTIVITY",8)
      hdrstring1 = getTermLabel("ACTIVITY",8).
   if budget[1] then
      hdrstring = getTermLabel("BUDGET",8).
   if budget[2] then
      hdrstring1 = getTermLabel("BUDGET",8).
   if cmmt-yn and line-counter > 4 then do:
      if varflag and (roundcnts or prt1000) then do:
         view frame cmmthead3.
         display "".
      end.
      else do:
         if varflag then do:
            view frame cmmthead1.
            display "".
         end.
         else do:
            view frame cmmthead2.
            display "".
         end.
      end.
   end.
   if varflag and (roundcnts or prt1000) then
      view frame pcthead.
   else do:
      if varflag then
         view frame phead1.
      else
         view frame phead2.
   end.

END PROCEDURE.

PROCEDURE print-comments:

   if cmmt-yn then do:

      put cname at 1 skip.

      for each cd_det fields( cd_domain cd_cmmt cd_ref cd_type)
          where cd_det.cd_domain = global_domain and  cd_ref = cmmt_ref and
          cd_type = cmmt_type no-lock:

         do i = 1 to 15:
            if cd_cmmt[i] <> "" then do:
               if line-counter > page-size then page.
               put cd_cmmt[i] at 14 skip.
            end.
         end.

         put skip.

      end.
   end.

END PROCEDURE.

PROCEDURE print-report:

   /* SS - 20070816.1 - B */
   /*
   run print-comments.
   run display-header.
   */
   /* SS - 20070816.1 - E */

   /* CHECK FOR UNPOSTED TRANSACTIONS */
   do i = 1 to 2:
      if not budget[i] then do:
         if can-find (first glt_det  where glt_det.glt_domain = global_domain
         and
            glt_entity >= entity and
            glt_entity <= entity1 and
            glt_sub >= sub and
            glt_sub <= sub1 and
            glt_cc >= ctr and glt_cc <= ctr1 and
            glt_effdate >= begdt[i] and
            glt_effdate <= enddt[i])
         then do:
            /* SS - 20070816.1 - B */
            /*
            /* UNPOSTED TRANSACTIONS EXIST FOR RANGES ON THIS REPORT */
            {pxmsg.i &MSGNUM=3151 &ERRORLEVEL=2}
            */
            /* SS - 20070816.1 - E */
            leave.
         end.
      end.
   end.

   /* SS - 20070816.1 - B */
   /*
   /* CALCULATE TOTAL AMOUNT OF INCOME OF PERIODS */
   {gprun.i ""glcinrpa.p""}
   run set-format.

   /* PRINT REPORT */
   {gprun.i ""glcinrpb.p""}
   */
   {gprun.i ""ssglcinrp01.p"" "(
      INPUT entity,
      INPUT entity1,
      INPUT begdt[1],
      INPUT begdt[2],
      INPUT enddt[1],
      INPUT enddt[2],
      INPUT budget[1],
      INPUT budget[2],
      INPUT budgetcode[1],
      INPUT budgetcode[2],
      INPUT et_report_curr
      )"}
   /* SS - 20070816.1 - E */

END PROCEDURE.

PROCEDURE set-vars:

   {gprun.i ""gpquote.p""
      "(input-output bcdparm,
        11,
        entity,
        entity1,
        cname,
        string(begdt[1]),
        string(enddt[1]),
        string(budget[1]),
        string(budgetcode[1]),
        string(begdt[2]),
        string(enddt[2]),
        string(budget[2]),
        string(budgetcode[2]),
        null_char,
        null_char,
        null_char,
        null_char,
        null_char,
        null_char,
        null_char,
        null_char,
        null_char)"}
   if use_sub then do:
      {mfquoter.i sub       }
      {mfquoter.i sub1      }
   end.
   if use_cc then do:
      {mfquoter.i ctr       }
      {mfquoter.i ctr1      }
   end.

   {mfquoter.i level        }
   {mfquoter.i zeroflag     }
   {mfquoter.i varflag      }

   if use_sub then do:
      {mfquoter.i subflag   }
   end.

   {mfquoter.i prtflag      }

   if use_cc then do:
      {mfquoter.i ccflag    }
   end.

   {mfquoter.i prt1000      }
   {mfquoter.i roundcnts    }
   {mfquoter.i cmmt-yn      }
   {mfquoter.i cmmt_type    }
   {mfquoter.i cmmt_ref     }
   {mfquoter.i et_report_curr}

END PROCEDURE.
