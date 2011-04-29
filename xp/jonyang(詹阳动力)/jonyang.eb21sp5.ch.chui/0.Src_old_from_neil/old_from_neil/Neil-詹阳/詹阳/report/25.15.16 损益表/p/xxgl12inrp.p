/* gl12inrp.p - GENERAL LEDGER 12-COLUMN INCOME STATEMENT                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.25 $                                                          */
/*V8:ConvertMode=Report                                                      */
/* REVISION 7.0       LAST MODIFIED: 04/03/92   by: jms  *F340*              */
/*                                   06/24/92   by: jms  *F702*              */
/*                                   08/03/92   by: jms  *F832*              */
/*                                   09/01/92   by: jms  *F890* (rev only)   */
/* REVISION 7.3       LAST MODIFIED: 01/07/93   by: mpp  *G479*              */
/*                                   04/14/93   by: skk  *G945*              */
/*                                   10/21/93   by: jms  *GG57*              */
/*                                   09/16/94   by: ljm  *GM66*              */
/*                                   12/30/94   by: str  *F0C4*              */
/* REVISION: 8.6      LAST MODIFIED: 12/15/97   by: bvm  *K1DS*              */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 03/12/98   By: *J23W* Sachin Shah       */
/* REVISION: 8.6E     LAST MODIFIED: 04/24/98   BY: *L00S* D. Sidel          */
/* REVISION: 8.6E     LAST MODIFIED: 05/14/98   BY: *L010* AWe               */
/* REVISION: 8.6E     LAST MODIFIED: 06/08/98   BY: *K1RZ* Ashok Swaminathan */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01W* Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 08/26/98   BY: *L07R* Steve Goeke       */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 07/31/00   BY: *N0GV* Mudit Mehta       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.23  BY: Jean Miller DATE: 04/25/02 ECO: *P06H* */
/* $Revision: 1.25 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* SS - 090715.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

define new shared variable glname   like en_name no-undo.
define new shared variable begdt    as date extent 12 no-undo
                                    /*V8! view-as fill-in size 8.5 by 1 */ .
define new shared variable enddt    as date extent 12 no-undo
                                    /*V8! view-as fill-in size 8.5 by 1 */ .
define new shared variable actual   like mfc_logical extent 12 no-undo
                                    /*V8! view-as fill-in size 3.5 by 1 */ .
define new shared variable budget   like mfc_logical extent 12 no-undo
                                    /*V8! view-as fill-in size 3.5 by 1 */ .
define new shared variable bcode    as character format "x(8)" extent 12 no-undo
                                    /*V8! view-as fill-in size 8.5 by 1 */ .
define new shared variable variance like mfc_logical extent 12 no-undo
                                    /*V8! view-as fill-in size 8.5 by 1 */ .
define new shared variable varpct   like mfc_logical extent 12 no-undo
                                    /*V8! view-as fill-in size 3.5 by 1 */ .
define new shared variable incpct   like mfc_logical extent 12 no-undo
                                    /*V8! view-as fill-in size 3.5 by 1 */ .
define new shared variable zeroflag like mfc_logical initial no
                                    label "Suppress Zero Amounts" no-undo.
define new shared variable ctr      like cc_ctr no-undo.
define new shared variable ctr1     like cc_ctr no-undo.
define new shared variable sub      like sb_sub no-undo.
define new shared variable sub1     like sb_sub no-undo.
define new shared variable level    as integer format ">9" initial 99
                                    label "Level" no-undo.
define new shared variable ccflag   like mfc_logical
                                    label "Summarize Cost Centers" no-undo.
define new shared variable subflag  like mfc_logical
                                    label "Summarize Sub-Accounts" no-undo.
define new shared variable entity   like en_entity no-undo.
define new shared variable entity1  like en_entity no-undo.
define new shared variable cname    like glname no-undo.
define new shared variable fiscal_yr like glc_year extent 12 no-undo.
define new shared variable per_beg  like glc_per extent 12 no-undo.
define new shared variable per_end  like glc_per extent 12 no-undo.
define new shared variable ret      like ac_code no-undo.
define new shared variable yr_end   as date extent 12 no-undo.
define new shared variable income   as decimal extent 12 no-undo.
define new shared variable rpt_curr like gltr_curr no-undo.

define new shared variable prt1000  like mfc_logical
                                    label "Round to Nearest Thousand" no-undo.
define new shared variable label1   as character format "x(12)"
                                    extent 12 no-undo.
define new shared variable label2   as character format "x(12)"
                                    extent 12 no-undo.
define new shared variable label3   as character format "x(12)"
                                    extent 12 no-undo.
define new shared variable label4   as character format "x(12)"
                                    extent 12 no-undo.
define new shared variable et_income like income.

define variable peryr          as character format "x(8)" no-undo.
define variable msg1000        as character format "x(16)" no-undo.
define variable i              as integer no-undo.
define variable use_cc         like co_use_cc no-undo.
define variable use_sub        like co_use_sub no-undo.
define variable l-return-value as logical.

define variable disp-column   as character no-undo format "x(6)".
define variable disp-beg-date as character no-undo format "x(8)".
define variable disp-end-date as character no-undo format "x(8)".
define variable disp-actual   as character no-undo format "x(6)".
define variable disp-budget   as character no-undo format "x(6)".
define variable disp-code     as character no-undo format "x(5)".
define variable disp-variance as character no-undo format "x(8)".
define variable disp-var-pct  as character no-undo format "x(7)".
define variable disp-inc-pct  as character no-undo format "x(7)".

/* ***** COMMON REPORT VARIABLES FOR EURO TOOLKIT ***** */
{etvar.i   &new = "new"}
{etrpvar.i &new = "new"}
{eteuro.i}

assign
   disp-column   = getTermLabel("COLUMN",6)
   disp-beg-date = getTermLabel("BEGIN_DATE",8)
   disp-end-date = getTermLabel("END_DATE",8)
   disp-actual   = getTermLabel("ACTUAL",6)
   disp-budget   = getTermLabel("BUDGET",6)
   disp-code     = getTermLabel("CODE",5)
   disp-variance = getTermLabel("VARIANCE",8)
   disp-var-pct  = getTermLabel("VARIANCE_PERCENTAGE",7)
   disp-inc-pct  = getTermLabel("INCOME_PERCENTAGE",7).

/* SELECT FORM */
form

   entity colon 15 entity1 colon 25 label {t001.i} cname colon 50 skip
   disp-column    at 2  no-label
   disp-beg-date  at 10 no-label
   disp-end-date  at 20 no-label
   disp-actual    at 30 no-label
   disp-budget    at 38 no-label
   disp-code      at 46 no-label
   disp-variance  at 53 no-label
   disp-var-pct   at 63 no-label
   disp-inc-pct   at 72 no-label
   skip

   "   1"     at 2
   begdt[1]   at 10 no-label   enddt[1]     at 20 no-label
   actual[1]  at 31 no-label   budget[1]    at 38 no-label
   bcode[1]   at 44 no-label   variance[1]  at 54 no-label
   varpct[1]  at 65 no-label   incpct[1]    at 73 no-label skip

   "   2"     at 2
   begdt[2]   at 10 no-label   enddt[2]     at 20 no-label
   actual[2]  at 31 no-label   budget[2]    at 38 no-label
   bcode[2]   at 44 no-label   variance[2]  at 54 no-label
   varpct[2]  at 65 no-label   incpct[2]    at 73 no-label skip

   "   3"     at 2
   begdt[3]   at 10 no-label   enddt[3]     at 20 no-label
   actual[3]  at 31 no-label   budget[3]    at 38 no-label
   bcode[3]   at 44 no-label   variance[3]  at 54 no-label
   varpct[3]  at 65 no-label   incpct[3]    at 73 no-label skip

   "   4"     at 2
   begdt[4]   at 10 no-label   enddt[4]     at 20 no-label
   actual[4]  at 31 no-label   budget[4]    at 38 no-label
   bcode[4]   at 44 no-label   variance[4]  at 54 no-label
   varpct[4]  at 65 no-label   incpct[4]    at 73 no-label skip

   "   5"     at 2
   begdt[5]   at 10 no-label   enddt[5]     at 20 no-label
   actual[5]  at 31 no-label   budget[5]    at 38 no-label
   bcode[5]   at 44 no-label   variance[5]  at 54 no-label
   varpct[5]  at 65 no-label   incpct[5]    at 73 no-label skip

   "   6"     at 2
   begdt[6]   at 10 no-label   enddt[6]     at 20 no-label
   actual[6]  at 31 no-label   budget[6]    at 38 no-label
   bcode[6]   at 44 no-label   variance[6]  at 54 no-label
   varpct[6]  at 65 no-label   incpct[6]    at 73 no-label skip

with frame a width 80 side-labels.

form  /* frame a, continued */

   "   7"     at 2
   begdt[7]   at 10 no-label   enddt[7]     at 20 no-label
   actual[7]  at 31 no-label   budget[7]    at 38 no-label
   bcode[7]   at 44 no-label   variance[7]  at 54 no-label
   varpct[7]  at 65 no-label   incpct[7]    at 73 no-label skip

   "   8"     at 2
   begdt[8]   at 10 no-label   enddt[8]     at 20 no-label
   actual[8]  at 31 no-label   budget[8]    at 38 no-label
   bcode[8]   at 44 no-label   variance[8]  at 54 no-label
   varpct[8]  at 65 no-label   incpct[8]    at 73 no-label skip

   "   9"     at 2
   begdt[9]   at 10 no-label   enddt[9]     at 20 no-label
   actual[9]  at 31 no-label   budget[9]    at 38 no-label
   bcode[9]   at 44 no-label   variance[9]  at 54 no-label
   varpct[9]  at 65 no-label   incpct[9]    at 73 no-label skip

   "  10"     at 2
   begdt[10]  at 10 no-label   enddt[10]    at 20 no-label
   actual[10] at 31 no-label   budget[10]   at 38 no-label
   bcode[10]  at 44 no-label   variance[10] at 54 no-label
   varpct[10] at 65 no-label   incpct[10]   at 73 no-label skip

   "  11"     at 2
   begdt[11]  at 10 no-label   enddt[11]    at 20 no-label
   actual[11] at 31 no-label   budget[11]   at 38 no-label
   bcode[11]  at 44 no-label   variance[11] at 54 no-label
   varpct[11] at 65 no-label   incpct[11]   at 73 no-label skip

   "  12"     at 2
   begdt[12]  at 10 no-label   enddt[12]    at 20 no-label
   actual[12] at 31 no-label   budget[12]   at 38 no-label
   bcode[12]  at 44 no-label   variance[12] at 54 no-label
   varpct[12] at 65 no-label   incpct[12]   at 73 no-label skip

   sub   colon 13  sub1     colon 30 label {t001.i}  subflag colon 72
   ctr   colon 13  ctr1     colon 30 label {t001.i}  ccflag  colon 72
   level colon 13  zeroflag colon 40                 prt1000 colon 72

   et_report_curr colon 26

with frame a.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* GET NAME OF CURRENT ENTITY */
run get-current-entity ( output l-return-value ).
if not l-return-value then leave.

assign
   entity   = current_entity
   entity1  = current_entity
   cname    = glname
   rpt_curr = base_curr.

/* GET RETAINED EARNINGS CODE FROM CONTROL FILE */
run get-retained-earnings ( output l-return-value ).
if not l-return-value then leave.

/* DEFINE HEADERS */
form header
   cname at 1 space(2) msg1000

   mc-curr-label at 60 et_report_curr skip
   mc-exch-label at 60 mc-exch-line1 at 82 skip
   mc-exch-line2 at 82 skip(1)
   skip
   label1[1]  to 50  label1[2]  to 67  label1[3]  to 84
   label1[4]  to 101 label1[5]  to 118 label1[6]  to 135
   label1[7]  to 152 label1[8]  to 169 label1[9]  to 186
   label1[10] to 203 label1[11] to 220 label1[12] to 237
   label2[1]  to 50  label2[2]  to 67  label2[3]  to 84
   label2[4]  to 101 label2[5]  to 118 label2[6]  to 135
   label2[7]  to 152 label2[8]  to 169 label2[9]  to 186
   label2[10] to 203 label2[11] to 220 label2[12] to 237
   label3[1]  to 50  label3[2]  to 67  label3[3]  to 84
   label3[4]  to 101 label3[5]  to 118 label3[6]  to 135
   label3[7]  to 152 label3[8]  to 169 label3[9]  to 186
   label3[10] to 203 label3[11] to 220 label3[12] to 237
   label4[1]  to 50  label4[2]  to 67  label4[3]  to 84
   label4[4]  to 101 label4[5]  to 118 label4[6]  to 135
   label4[7]  to 152 label4[8]  to 169 label4[9]  to 186
   label4[10] to 203 label4[11] to 220 label4[12] to 237
   skip(1)
with frame phead1 page-top no-box width 238.

{wbrp01.i}

/* REPORT BLOCK */
mainloop:
repeat:

   /* INPUT OPTIONS */
   if ctr1    = hi_char then ctr1 = "".
   if sub1    = hi_char then sub1 = "".
   if entity1 = hi_char then entity1 = "".

   if c-application-mode <> 'web'
   then do:
      display
         disp-column   disp-beg-date disp-end-date
         disp-actual   disp-budget   disp-code
         disp-variance disp-var-pct  disp-inc-pct
      with frame a.
      update
         entity entity1 cname
         begdt[1] enddt[1] actual[1] budget[1] bcode[1] variance[1]
         varpct[1] incpct[1]
         begdt[2] enddt[2] actual[2] budget[2] bcode[2] variance[2]
         varpct[2] incpct[2]
         begdt[3] enddt[3] actual[3] budget[3] bcode[3] variance[3]
         varpct[3] incpct[3]
         begdt[4] enddt[4] actual[4] budget[4] bcode[4] variance[4]
         varpct[4] incpct[4]
         begdt[5] enddt[5] actual[5] budget[5] bcode[5] variance[5]
         varpct[5] incpct[5]
         begdt[6] enddt[6] actual[6] budget[6] bcode[6] variance[6]
         varpct[6] incpct[6]
         begdt[7] enddt[7] actual[7] budget[7] bcode[7] variance[7]
         varpct[7] incpct[7]
         begdt[8] enddt[8] actual[8] budget[8] bcode[8] variance[8]
         varpct[8] incpct[8]
         begdt[9] enddt[9] actual[9] budget[9] bcode[9] variance[9]
         varpct[9] incpct[9]
         begdt[10] enddt[10] actual[10] budget[10] bcode[10]
         variance[10] varpct[10] incpct[10]
         begdt[11] enddt[11] actual[11] budget[11] bcode[11]
         variance[11] varpct[11] incpct[11]
         begdt[12] enddt[12] actual[12] budget[12] bcode[12]
         variance[12] varpct[12] incpct[12]
         sub when (use_sub) sub1 when (use_sub) subflag when
         (use_sub)
         ctr when (use_cc) ctr1 when (use_cc) ccflag when (use_cc)
         level zeroflag prt1000
         et_report_curr

      with frame a.
   end.

   {wbrp06.i &command = update &fields = "
        entity entity1 cname
        begdt [1] enddt [1] actual [1] budget [1] bcode [1]
        variance [1] varpct [1] incpct [1]
        begdt [2] enddt [2] actual [2] budget [2] bcode [2]
        variance [2] varpct [2] incpct [2]
        begdt [3] enddt [3] actual [3] budget [3] bcode [3]
        variance [3] varpct [3] incpct [3]
        begdt [4] enddt [4] actual [4] budget [4] bcode [4]
        variance [4] varpct [4] incpct [4]
        begdt [5] enddt [5] actual [5] budget [5] bcode [5]
        variance [5] varpct [5] incpct [5]
        begdt [6] enddt [6] actual [6] budget [6] bcode [6]
        variance [6] varpct [6] incpct [6]
        begdt [7] enddt [7] actual [7] budget [7] bcode [7]
        variance [7] varpct [7] incpct [7]
        begdt [8] enddt [8] actual [8] budget [8] bcode [8]
        variance [8] varpct [8] incpct [8]
        begdt [9] enddt [9] actual [9] budget [9] bcode [9]
        variance [9] varpct [9] incpct [9]
        begdt [10] enddt [10] actual [10] budget [10] bcode [10]
        variance [10] varpct [10] incpct [10]
        begdt [11] enddt [11] actual [11] budget [11] bcode [11]
        variance [11] varpct [11] incpct [11]
        begdt [12] enddt [12] actual [12] budget [12] bcode [12]
        variance [12] varpct [12] incpct [12]
        sub when use_sub sub1 when use_sub subflag when use_sub
        ctr when use_cc ctr1 when use_cc ccflag when use_cc
        level zeroflag prt1000
        et_report_curr
        " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      if entity1 = "" then entity1 = hi_char.
      if ctr1    = "" then ctr1    = hi_char.
      if sub1    = "" then sub1    = hi_char.

      /* CHECK FOR VALID OPTIONS */
      do i = 1 to 12:

         if ((if actual[i]   then 1 else 0) +
            (if budget[i]   then 1 else 0) +
            (if variance[i] then 1 else 0) +
            (if varpct[i]   then 1 else 0) +
            (if incpct[i]   then 1 else 0)) > 1
         then do:
            /* ONLY ONE OPTION PER COLUMN ALLOWED */
            {pxmsg.i &MSGNUM=3154 &ERRORLEVEL=3}
            if c-application-mode = 'web' then return.
            else next-prompt actual[i] with frame a.
            undo mainloop.
         end.

      end.  /* do i = 1 to 12 */

      /* CHECK FOR INVALID BUDGET CODE */
      do i = 1 to 12:
         if budget[i] then do:

            if not can-find (first bg_mstr  where bg_mstr.bg_domain =
            global_domain and
               bg_code = bcode[i])
            then do:
               {pxmsg.i &MSGNUM=3107 &ERRORLEVEL=3} /* INVALID BUDGET CODE */
               if c-application-mode = 'web' then return.
               else next-prompt bcode[i] with frame a.
               undo mainloop.
            end.
         end.  /* if budget[i] */
      end.  /* do i = 1 to 12 */

      /* CHECK FOR VALID REPORT DATES */
      do i = 1 to 12:
         if actual[i] or budget[i] then do:
            if enddt[i] = ? then enddt[i] = today.
            display enddt[i] with frame a.
            {glper1.i enddt[i] peryr}  /*GET PERIOD/YEAR*/
            if peryr = "" then do:
               /* DATE NOT WITHIN A VALID PERIOD */
               {pxmsg.i &MSGNUM=3018 &ERRORLEVEL=3}
               if c-application-mode = 'web' then return.
               else next-prompt enddt[i] with frame a.
               undo mainloop.
            end.

            assign
               fiscal_yr[i] = glc_year
               per_end[i]   = glc_per.

            for first glc_cal
               fields( glc_domain glc_end glc_per glc_start glc_year)
            no-lock  where glc_cal.glc_domain = global_domain and  glc_year =
            fiscal_yr[i]
               and glc_per = 1:
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
            assign
               per_beg[i] = glc_per.
            find last glc_cal  where glc_cal.glc_domain = global_domain and
            glc_year = fiscal_yr[i]
            no-lock no-error.
            assign
               yr_end[i] = glc_end.
         end.  /* if actual[i] or budget[i] */
      end.  /* do i = 1 to 12 */

      /*  CHECK FOR VALID LEVEL */
      if level < 1 or level > 99 then do:
         {pxmsg.i &MSGNUM=3015 &ERRORLEVEL=3}   /*INVALID LEVEL*/
         if c-application-mode = 'web' then return.
         else next-prompt level with frame a.
         undo mainloop.
      end.

      if et_report_curr <> "" then do:
         {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
            "(input  et_report_curr,
              output mc-error-number)"}
         if mc-error-number = 0
            and et_report_curr <> rpt_curr then do:

            {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
               "(input  et_report_curr,
                 input  rpt_curr,
                 input  "" "",
                 input  et_eff_date,
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
               "(input  et_report_curr,
                 input  rpt_curr,
                 input  et_rate2,
                 input  et_rate1,
                 input  mc-seq,
                 output mc-exch-line1,
                 output mc-exch-line2)"}
            {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
               "(input mc-seq)"}
         end.  /* else do */
      end.  /* if et_report_curr <> "" */
      if et_report_curr = "" or et_report_curr = rpt_curr then
         assign
            mc-exch-line1  = ""
            mc-exch-line2  = ""
            et_report_curr = rpt_curr.

   end.  /* if (c-application-mode <> 'web') ... */

   /***** REPORTING CURRENCY VALIDATION CHECK *****/

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
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

   /* SET UP HEADERS */
   run set-up-headers.

   if prt1000
   then
      msg1000 = "(" + getTermLabel("IN_1000'S",10) +
                " " + et_report_curr + ")".

   view frame phead1.

   /* CHECK FOR UNPOSTED TRANSACTONS */
   do i = 1 to 12:

      if actual[i] and
         can-find (first glt_det  where glt_det.glt_domain = global_domain and
         glt_entity >= entity and
         glt_entity <= entity1 and
         glt_sub >= sub and
         glt_sub <= sub1 and
         glt_cc >= ctr and glt_cc <= ctr1 and
         glt_effdate >= begdt[i] and
         glt_effdate <= enddt[i])
      then do:
         /* UNPOSTED TRANSACTIONS EXIST FOR RANGES ON THIS REPORT */
         {pxmsg.i &MSGNUM=3151 &ERRORLEVEL=2}
         leave.

      end.  /* if actual[i] and can-find... */
   end.  /* do i = 1 to 12 */

   /* CALCULATE TOTAL AMOUNT OF INCOME FOR COLUMNS */
   {gprun.i ""gl12inra.p""}

   /* CALL SUBPROGRAM TO CALCULATE AND PRINT REPORT */
/* SS 090715.1 - B */
/*
   {gprun.i ""gl12inrb.p""}
*/
   {gprun.i ""xxgl12inrb.p""}
/* SS 090715.1 - E */

   /* REPORT TRAILER */
   {mfrtrail.i}

end.  /* repeat */

{wbrp04.i &frame-spec = a}

PROCEDURE get-current-entity:
   define output parameter l-return-value as logical initial false.

   for first en_mstr fields( en_domain en_name en_entity)
       where en_mstr.en_domain = global_domain and  en_entity = current_entity
       no-lock:
   assign
      l-return-value = true
      glname         = en_name.
   end.
   if not available en_mstr then do:
      {pxmsg.i &MSGNUM=3059 &ERRORLEVEL=3} /* NO PRIMARY ENTITY DEFINED */
      if c-application-mode <> 'web' then pause.
      return.
   end.
END PROCEDURE. /* get-current-entity */

PROCEDURE get-retained-earnings:
   define output parameter l-return-value as logical initial false.

   for first co_ctrl fields( co_domain co_ret co_use_cc co_use_sub)  where
   co_ctrl.co_domain = global_domain no-lock:
   assign
      l-return-value = true
      ret            = co_ret
      use_cc         = co_use_cc
      use_sub        = co_use_sub.
   end.
   if not available co_ctrl then do:
      /* CONTROL FILE MUST BE DEFINED BEFORE RUNNING REPORT*/
      {pxmsg.i &MSGNUM=3032 &ERRORLEVEL=3}
      if c-application-mode <> 'web' then pause.
      return.
   end.

END PROCEDURE. /* get-retained-earnings */

PROCEDURE set-up-headers:
   do i = 1 to 12:
      assign
         label1[i] = if actual[i] then
                        getTermLabelRt("ACTUAL",9)
                     else if budget[i] then
                        getTermLabelRt("BUDGET",9)
                     else ""
         label2[i] = if actual[i] or budget[i] then
                        " " + string(begdt[i]) + " " + getTermLabel("TO",2)
                     else if varpct[i] or incpct[i] then
                        getTermLabelRt("PERCENTAGE",12)
                     else ""
         label3[i] = if actual[i] or budget[i] then
                        "  " + string(enddt[i])
                     else if varpct[i] then
                        getTermLabelRt("OF_VARIANCE",12)
                     else if incpct[i] then
                        getTermLabelRt("OF_INCOME",12)
                     else if variance[i] then
                        getTermLabelRt("VARIANCE",12)
                     else ""
         label4[i] = if actual[i] or budget[i] or variance[i] or
                        incpct[i] or varpct[i] then
                        "------------"
                     else "".
   end.  /* do i = 1 to 12 */
   msg1000 = "".
END PROCEDURE. /* set-up-headers */
