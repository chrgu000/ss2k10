/* ardrrp.p - AR DETAIL DR/CR MEMO AUDIT REPORT                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.11.1.26 $                                               */
/* REVISION: 1.0      LAST MODIFIED: 07/16/86   BY: PML                 */
/* REVISION: 6.0      LAST MODIFIED: 08/27/90   BY: afs *D062*          */
/*                                   10/29/90   BY: MLB *D153*          */
/*                                   01/02/91   BY: afs *D283*          */
/*                                   02/28/91   BY: afs *D387*          */
/*                                   03/06/91   BY: bjb *D865*          */
/*                                   04/10/91   BY: bjb *D515*          */
/*                                   09/26/91   BY: WUG *D878*          */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: jms *F201*          */
/*                                   03/04/92   BY: jms *F237*          */
/* REVISION: 7.0      LAST MODIFIED: 03/17/92   BY: TMD *F258*          */
/* REVISION: 7.0      LAST MODIFIED: 03/22/92   BY: TMD *F302*          */
/* REVISION: 7.0      LAST MODIFIED: 04/11/92   BY: afs *F356*          */
/* REVISION: 7.0      LAST MODIFIED: 05/29/92   BY: jjs *F559*          */
/* REVISION: 7.3      LAST MODIFIED: 08/03/92   BY: jms *G024*          */
/*                                   10/14/92   BY: jms *G177*          */
/*                                   09/27/93   BY: jcd *G247*          */
/*                                   05/13/93   BY: pcd *GA88*          */
/* REVISION: 7.4      LAST MODIFIED: 08/05/93   BY: bcm *H056*          */
/*                                   09/02/93   BY: wep *H102*          */
/*                                   09/02/93   BY: rxm *GL40*          */
/* REVISION: 7.4      LAST MODIFIED: 09/11/94   by: slm *GM15*          */
/* REVISION: 7.4      LAST MODIFIED: 11/08/94   by: jzs *GN61*          */
/* REVISION: 8.5      LAST MODIFIED: 12/12/95   by: taf & mwd *J053*    */
/*                                   04/08/96   by: jzw *G1T9*          */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: taf *J101*          */
/* REVISION: 8.5      LAST MODIFIED: 12/20/96   BY: rxm *G2JR*          */
/* REVISION: 8.6      LAST MODIFIED: 02/18/97   BY: *K06Z* M. Madison   */
/* REVISION: 8.6      LAST MODIFIED: 10/10/97   BY: bvm *K0QC*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 06/26/98   BY: *L01K* Jaydeep Parikh */
/* REVISION: 8.6E     LAST MODIFIED: 09/16/98   BY: *L098* G.Latha        */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton      */
/* REVISION: 9.1      LAST MODIFIED: 10/13/99   BY: *L0K5* Hemali Desai      */
/* REVISION: 9.1      LAST MODIFIED: 02/11/00   BY: *N07Z* Vijaya Pakala     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 06/22/00   BY: *N0CL* Arul Victoria     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 10/25/00   BY: *N0T7* Jean Miller       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.11.1.12    BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002* */
/* Revision: 1.11.1.13    BY: Mercy C.       DATE: 03/18/02 ECO: *M1WF* */
/* Revision: 1.11.1.14    BY: Paul Donnelly  DATE: 12/17/01 ECO: *N16J* */
/* Revision: 1.11.1.15    BY: Hareesh V.     DATE: 06/21/02 ECO: *N1HY* */
/* Revision: 1.11.1.16    BY: Rajiv Ramaiah  DATE: 03/17/03 ECO: *N28K* */
/* Revision: 1.11.1.19    BY: Dorota Hohol   DATE: 03/26/03 ECO: *P0NR* */
/* Revision: 1.11.1.20    BY: Geeta Kotian    DATE: 05/12/03  ECO: *P0RV* */
/* Revision: 1.11.1.21  BY: Narathip W. DATE: 05/21/03 ECO: *P0SH* */
/* Revision: 1.11.1.23  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* Revision: 1.11.1.24  BY: Rajinder Kamra  DATE: 07/11/03 ECO: *Q00Q* */
/* Revision: 1.11.1.25  BY: Patrick de Jong DATE: 07/22/03 ECO: *Q019* */
/* $Revision: 1.11.1.26 $ BY: Manish Dani        DATE: 09/01/03 ECO: *P0VZ* */
/* $Revision: 1.11.1.26 $ BY: Bill Jiang        DATE: 07/17/08 ECO: *SS - 20080717.1* */
/*SS - 101109.1 BY KEN */
/* SS - 20130101.1 By: Randy Li */
/* SS - 20130101.1 RNB
�� 20130101.1 ��
1.����Ƶ�λ��ʾΪad_name + ad_line.
�� 20130101.1 ��
SS - 20130101.1 - RNE */
/*-Revision end---------------------------------------------------------------*/


/*V8:ConvertMode=FullGUIReport                                          */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20080717.1 - B */
{ssardrrp0001.i "new"}

{ssbiar06a.i "new"}

define NEW shared variable ttssardrrp0001_recno  as recid         no-undo.
define NEW shared variable line_tt1  as INTEGER         no-undo.

DEFINE VARIABLE tot_dr_amt AS DECIMAL.
/* SS - 20080717.1 - E */

/* SS - 20080717.1 - B */
/*
{mfdtitle.i "1+ "}

{mfdtitle.i "101109.1"} */
/* SS - 20080717.1 - E */

/* SS - 20130101.1 - B */
{mfdtitle.i "20130101.1"}
/* SS - 20130101.1 - E */
{cxcustom.i "ARDRRP.P"}

/* DEFINE NEW SHARED WORKFILE AP_WKFL FOR CURRENCY SUMMARY */
{gpacctp.i "new"}

define new shared variable rndmthd like rnd_rnd_mthd.
/* OLD_CURR IS USED BY GPACCTP.P */
define new shared variable old_curr like ar_curr.
define variable oldsession   as character.
define variable c_session   as character.
define variable oldcurr      like ar_curr.
define variable cust         like ar_bill.
define variable cust1        like ar_bill.
define variable nbr          like ar_nbr.
define variable nbr1         like ar_nbr.
define variable batch        like ar_batch.
define variable batch1       like ar_batch.
define variable entity       like ar_entity.
define variable entity1      like ar_entity.
define variable ardate       like ar_date.
define variable ardate1      like ar_date.
define variable effdate      like ar_effdate.
define variable effdate1     like ar_effdate.
define variable name         like ad_name format "x(35)".
define variable type         like ar_type format "X(4)"
   label "Type".
define variable select_type  like ar_type
   label "Reference Type" initial " ".
define variable gltrans      like mfc_logical initial no
   label "Print GL Detail".
define variable summary      like mfc_logical format "Summary/Detail"
   initial no label "Summary/Detail".

define new shared variable base_rpt like ar_curr no-undo.

define variable mixed_rpt    like mfc_logical initial no
   label "Mixed Currencies".
define variable base_damt    like ard_amt
   format "->,>>>,>>>,>>9.99".
define variable base_amt     like ar_amt
   format "->,>>>,>>>,>>9.99".
define variable base_applied like ar_applied
   format "->,>>>,>>>,>>9.99".
define variable disp_curr    as character format "x(1)" label "C".
define variable batch_title  as character format "x(30)".
define new shared variable undo_txdetrp like mfc_logical.
define variable tax_tr_type  like tx2d_tr_type initial "18".
define variable tax_nbr      like tx2d_nbr initial "".
define variable page_break   as integer initial 0.
define variable col-80       as logical initial false.
define variable disp_amt     like base_amt.
define variable disp_applied like base_applied.
{&ARDRRP-P-TAG2}
define variable base_amt_fmt as character.
define variable curr_amt_fmt as character.
define variable curr_amt_old as character.
define variable mc-error-number like msg_nbr no-undo.
define variable ex_rate_relation1 as character format "x(40)" no-undo.
define variable ex_rate_relation2 as character format "x(40)" no-undo.
define variable l_tot_base_damt   like ar_amt                 no-undo.
define variable l_cnv_rnd_msg     like mfc_logical initial no no-undo.
define variable round_acct        like acdf_acct              no-undo.
define variable round_sub         like acdf_sub               no-undo.
define variable round_cc          like acdf_cc                no-undo.
define variable round_proj        like glt_project            no-undo.
define variable round_desc        like ac_desc                no-undo.

/* MUST INCLUDE gprunpdf.i IN THE MAIN BLOCK OF THE PROGRAM SO THAT */
/* CALLS TO gprunp.i FROM ANY OF THE INTERNAL PROCEDURES SKIPS  */
/* DEFINITION OF SHARED VARS OF gprunpdf.i */
/* FOR FURTHER INFO REFER TO HEADER COMMENTS IN gprunp.i */
{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "mcui" "p"}
{gprunpdf.i "mcrndpl" "p"}

/* FOLLOWING REQUIRED FOR INTER-COMPANY */
{pxpgmmgr.i}
define variable ico_acct as character no-undo.
define variable ico_sub as character no-undo.
define variable ico_cc as character no-undo.

/* SS - 20080717.1 - B */
/* �������� */
/* SS - 20130101.1 - B */
/*
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
/* �û����� */
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
/* SS - 20080717.1 - E */

{txcurvar.i "NEW"}
form
   batch        colon 18 batch1   colon 49 label {t001.i}
   nbr          colon 18 nbr1     colon 49 label {t001.i}
   cust         colon 18 cust1    colon 49 label {t001.i}
   entity       colon 18 entity1  colon 49 label {t001.i}
   ardate       colon 18 ardate1  colon 49 label {t001.i}
   effdate      colon 18 effdate1 colon 49 label {t001.i}
   select_type  colon 18 skip (1)
   /* SS - 20080717.1 - B */
   /*
   summary      colon 25
   gltrans      colon 25
   base_rpt     colon 25
   mixed_rpt    colon 25
   {&ARDRRP-P-TAG3}
   */
   /* SS - 20080717.1 - E */
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   ar_nbr format "X(8)"
   type column-label "Type"
   ar_bill column-label "Bill-To!Sold-To"
   name column-label "Name!Exch Rate!PO"
   ar_date column-label "Date!Eff Date"
   ar_contested column-label "Contest!Tax Date"
   ar_acct
   column-label "Enty!Account" /* Enty & Account */
   ar_sub
   ar_cc
   ar_cr_terms
   column-label "Cr Terms!Dn Lv"   /* added Dunning Level */
   ar_curr column-label "Cur!C"
   base_amt column-label  "Amount!Applied Amt"
with frame c width 132 down
   no-box. /* Gives 2 more printable columns */

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

form
   space(10)
   ard_entity
   ard_acct
   ard_sub
   ard_cc
   ard_project
   base_damt
   ard_desc
with frame d width 132 down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

form
   batch_title  to 108  no-label
   ar_amt       colon 110
   ar_applied   colon 110
with frame e side-labels  width 132 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame e:handle).
{&ARDRRP-P-TAG4}

/* CREATED INTERNAL PROCEDURES p-acct-disp AND p-drcrgltrans     */
/* BEFORE REPEAT BLOCK TO MAKE THE REPORT RUN IN FULLGUI REPORT. */

PROCEDURE p-acct-disp:

   /* DISPLAYS ACCOUNT DETAILS WHEN DETAIL REPORT IS SELECTED    */
   /* IN REPORT CRITERIA.                                        */

   define input parameter l_entity    like ard_entity  no-undo.
   define input parameter l_acct      like ard_acct    no-undo.
   define input parameter l_sub       like ard_sub     no-undo.
   define input parameter l_cc        like ard_cc      no-undo.
   define input parameter l_project   like ard_project no-undo.
   define input parameter l_desc      like ard_desc    no-undo.
   define input parameter l_amt       like ard_amt     no-undo.
   define input parameter l_base_damt like ard_amt     no-undo.
   define input parameter l_curr      like ar_curr     no-undo.

   display
      l_entity  @ ard_entity
      l_acct    @ ard_acct
      l_sub     @ ard_sub
      l_cc      @ ard_cc
      l_project @ ard_project
   with frame d.

   if (base_rpt = "" and
       mixed_rpt)
   or base_rpt = l_curr
   then do:

      base_damt:format in frame d = curr_amt_fmt.

      display
         l_amt  @ base_damt
         l_desc @ ard_desc
         with frame d.

   end. /* IF base_rpt = " " ... */
   else do:

      base_damt:format in frame d = base_amt_fmt.

      display
         l_base_damt @ base_damt
         l_desc      @ ard_desc
         with frame d.

   end. /* ELSE DO */

   down with frame d.

   if  not l_cnv_rnd_msg
   and base_rpt  =  " "
   and base_curr <> l_curr
   then
      l_cnv_rnd_msg = true.

END PROCEDURE. /* p-acct-disp */

PROCEDURE p-drcrgltrans:

   /* CREATES gltw_wkfl RECORDS WHEN PRINT GL DETAIL IS SET */
   /* TO YES IN REPORT CRITERIA.                            */

   define input parameter l_entity    like ard_entity  no-undo.
   define input parameter l_acct      like ard_acct    no-undo.
   define input parameter l_sub       like ard_sub     no-undo.
   define input parameter l_cc        like ard_cc      no-undo.
   define input parameter l_project   like ard_project no-undo.
   define input parameter l_base_damt like ard_amt     no-undo.
   define input parameter l_date      like ar_date     no-undo.
   define input parameter l_bill      like ar_bill     no-undo.
   define input parameter l_effdate   like ar_effdate  no-undo.
   define input parameter l_batch     like ar_batch    no-undo.
   define input parameter l_type      like ar_type     no-undo.
   {&ARDRRP-P-TAG22}
   define input parameter l_nbr       like ar_nbr      no-undo.

   {gpnextln.i &ref=l_bill &line=return_int}

   create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
   assign
      gltw_ref     = l_bill
      gltw_line    = return_int
      gltw_entity  = l_entity
      gltw_acct    = l_acct
      gltw_sub     = l_sub
      gltw_cc      = l_cc
      gltw_project = l_project
      gltw_date    = l_date
      gltw_effdate = l_effdate
      gltw_userid  = mfguser
      gltw_desc    = l_batch + " " + l_type + " " +
                     l_nbr   + " " + l_bill
      {&ARDRRP-P-TAG23}
      gltw_amt     = l_base_damt.

   if recid(gltw_wkfl) = -1
   then
      .
   recno = recid(gltw_wkfl).
   {&ARDRRP-P-TAG1}

END PROCEDURE. /* p-drcrgltrans */

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

base_amt_fmt = base_amt:format in frame c.
{gprun.i ""gpcurfmt.p"" "(input-output base_amt_fmt,
                                    input gl_rnd_mthd)"}
curr_amt_old = base_amt:format in frame c.
oldcurr = "".
oldsession = SESSION:numeric-format.

{wbrp01.i}
/* SS - 20130101.1 - B */
entity = current_entity.
entity1 = current_entity.
/* SS - 20130101.1 - E */
repeat:

   find first ap_wkfl no-error.
   if available ap_wkfl then
   for each ap_wkfl exclusive-lock:
      delete ap_wkfl.
   end.

   if batch1 = hi_char then batch1 = "".
   if nbr1 = hi_char then nbr1 = "".
   if cust1 = hi_char then cust1 = "".
   if entity1 = hi_char then entity1 = "".
   if ardate = low_date then ardate = ?.
   if ardate1 = hi_date then ardate1 = ?.
   if effdate = low_date then effdate = ?.
   if effdate1 = hi_date then effdate1 = ?.

   if c-application-mode <> 'web' then
   update batch batch1 nbr nbr1 cust cust1 entity entity1
      ardate ardate1 effdate effdate1 select_type
      /* SS - 20080717.1 - B */
      /*
      summary gltrans base_rpt
      mixed_rpt
      {&ARDRRP-P-TAG5}
      */
      /* SS - 20080717.1 - E */
   with frame a.

   {&ARDRRP-P-TAG6}
   {wbrp06.i &command = update
      &fields = "  batch batch1
                                nbr nbr1
                                cust cust1
                                entity entity1
                                ardate ardate1
                                effdate effdate1
                                select_type 
      /* SS - 20080717.1 - B */
      /*
      summary
                                gltrans base_rpt
                                mixed_rpt
                                */
      /* SS - 20080717.1 - E */
                                "
      &frm = "a"}
   {&ARDRRP-P-TAG7}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:
      {&ARDRRP-P-TAG8}

      bcdparm = "".
      {mfquoter.i batch    }
      {mfquoter.i batch1   }
      {mfquoter.i nbr      }
      {mfquoter.i nbr1     }
      {mfquoter.i cust     }
      {mfquoter.i cust1    }
      {mfquoter.i entity   }
      {mfquoter.i entity1  }
      {mfquoter.i ardate   }
      {mfquoter.i ardate1  }
      {mfquoter.i effdate  }
      {mfquoter.i effdate1 }
      {mfquoter.i select_type}
      {mfquoter.i summary  }
      {mfquoter.i gltrans  }
      {mfquoter.i base_rpt}
      {mfquoter.i mixed_rpt}
      {&ARDRRP-P-TAG9}

      if batch1 = "" then batch1 = hi_char.
      if nbr1 = "" then nbr1 = hi_char.
      if cust1 = "" then cust1 = hi_char.
      if entity1 = "" then entity1 = entity.
      if ardate = ? then ardate = low_date.
      if ardate1 = ? then ardate1 = hi_date.
      if effdate = ? then effdate = low_date.
      if effdate1 = ? then effdate1 = hi_date.
      /* VALIDATE SELECT TYPE */
      if select_type <> "" and (lookup(select_type,"M,I,F") = 0) then do:
         {pxmsg.i &MSGNUM=1172 &ERRORLEVEL=3}
         if c-application-mode = 'web' then return.
         else next-prompt select_type with frame a.
         undo, retry.
      end.

   end.

   /* SELECT OUTPUT */
/* SS - 20130101.1 - B */

FIND FIRST ad_mstr 
   WHERE 
   ad_domain = GLOBAL_domain AND 
   ad_addr = entity 
   NO-LOCK 
   NO-ERROR
   .
IF AVAILABLE ad_mstr THEN DO:
    ASSIGN
       NAME_reports = ad_name + ad_line1
       .
END.
ELSE DO:
   ASSIGN
      NAME_reports = ""
      .
END.

/* SS - 20130101.1 - E */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToFile = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinPrint = "yes"
               &defineVariables = "yes" }

   {&ARDRRP-P-TAG10}
   /* SS - 20080717.1 - B */
   /*
   {mfphead.i}
   {&ARDRRP-P-TAG11}

   form header
      skip(1)
   with frame a1 page-top width 132.
   view frame a1.

   /* DELETE GL WORKFILE ENTRIES */
   if gltrans = yes then do:
      for each gltw_wkfl  where gltw_wkfl.gltw_domain = global_domain and
      gltw_userid = mfguser exclusive-lock:
         {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
            "(input gltw_wkfl.gltw_exru_seq)" }
         delete gltw_wkfl.
      end.
   end.

   l_cnv_rnd_msg = no.

   for each ar_mstr  where ar_mstr.ar_domain = global_domain and (  (ar_batch
   >= batch) and
         (ar_batch <= batch1) and
         (ar_nbr  >= nbr) and (ar_nbr <= nbr1) and
         (ar_bill >= cust) and (ar_bill <= cust1) and
         (ar_entity >= entity) and
         (ar_entity <= entity1) and
         (ar_date >= ardate) and
         (ar_date <= ardate1) and
         (ar_effdate >= effdate) and
         (ar_effdate <= effdate1) and
         (ar_type <> "P") and
         (ar_type <> "D") and
         (ar_type <> "A") and
         (select_type = "" or ar_type = select_type)
         and (ar_curr = base_rpt or
         base_rpt = "")
         ) no-lock break by ar_batch by ar_nbr
         {&ARDRRP-P-TAG12}
      with frame c width 132 down:
      {&ARDRRP-P-TAG13}

      {mfrpchk.i}

      if (oldcurr <> ar_curr) or (oldcurr = "") then do:

         if ar_curr = gl_base_curr then
            rndmthd = gl_rnd_mthd.
         else do:
            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input ar_curr,
                         output rndmthd,
                         output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               if c-application-mode <> "WEB" then
                  next.
               pause.
            end.
         end.

         /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN       */
         find rnd_mstr  where rnd_mstr.rnd_domain = global_domain and
         rnd_rnd_mthd = rndmthd no-lock no-error.
         if not available rnd_mstr then do:
            {pxmsg.i &MSGNUM=863 &ERRORLEVEL=2}
            /* ROUND METHOD RECORD NOT FOUND */
            if c-application-mode = 'web' then return.
            next.
         end.
         /* ASSUME START UP SESSION IS FOR BASE CURR */
         if not (base_rpt = "" and not mixed_rpt)
         then do:
            /* IF RND_DEC_PT = COMMA FOR DECIMAL POINT */
            /* THIS IS A EUROPEAN STYLE CURRENCY */
            if (rnd_dec_pt = "," ) then
            assign
               c_session = "European"
               SESSION:numeric-format = "European".
            else
            assign
               c_session = "American"
               SESSION:numeric-format = "American".
         end.

         oldcurr = ar_curr.
         curr_amt_fmt = curr_amt_old.
         {gprun.i ""gpcurfmt.p"" "(input-output curr_amt_fmt,
                                             input rndmthd)" }
      end.

      /* CONVERT CURRENCY TO BASE IF APPROPRIATE */
      if base_curr = ar_curr or base_rpt = ar_curr then
      assign
         /* NO CONVERSION */
         base_amt = ar_amt
         base_applied = ar_applied
         disp_curr = " ".
      else
      assign
         /* CONVERSION */
         base_amt = ar_base_amt
         base_applied = ar_base_applied
         disp_curr = getTermLabel("YES",1).

      if base_rpt = "" and mixed_rpt then disp_curr = "".

      /* BLOCK MOVED FROM BELOW */
      /* STORE TOTALS, BY CURRENCY, IN WORK FILE. */
      if base_rpt = "" and mixed_rpt
      then do:
         find first ap_wkfl where ar_curr = apwk_curr no-error.
         /* IF RECORD FOR THIS CURRENCY NON-EXISTENT, CREATE ONE */
         if not available ap_wkfl then do:
            create ap_wkfl.
            apwk_curr = ar_curr.
         end.

         /* ACCUMULATE INDIVIDUAL CURRENCY TOTALS IN WORK FILE */
         apwk_for = apwk_for + ar_amt.
         if base_curr <> ar_curr then
            apwk_base = apwk_base + base_amt.
         else apwk_base = apwk_for.
      end.
      /* END BLOCK MOVE */

      accumulate base_amt (total by ar_batch).
      accumulate base_applied (total by ar_batch).

      if first-of(ar_batch) then do with frame b:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).

         display ar_batch with frame b side-labels.
      end. /* if first-of(ar_batch) */
      find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
      ar_bill no-lock no-wait no-error.
      if available ad_mstr then name = ad_name.
      else name = "".

      if ar_type = "M" then
         type = getTermLabel("MEMO",4).
      else
      if ar_type = "I" then
         type = getTermLabel("INVOICE",4).
      else
      if ar_type = "F" then
         type = getTermLabel("FINANCE",4).
      else type = "".

      find cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr =
      ar_bill no-lock no-error.
      display
         ar_nbr
         type
         ar_bill
         name
         ar_date
         ar_contested
         ar_entity @ ar_acct
         ar_cr_terms
         ar_curr
      with frame c.

      /* IF BASE_RPT IS BLANK, AMOUNTS DISPLAYED IN ORIGINAL CURR   */
      /* ADDED DISP_BASE & DISP_APPLIED SO THAT THESE FIELDS COULD  */
      /* DISPLAY THE APPROPRIATE AMOUNTS WITHOUT OVERRIDING BASE_AMT*/
      /* AND BASE_APPLIED                                           */

      if (base_rpt = "" and mixed_rpt) or
         base_rpt = ar_mstr.ar_curr
      then
      assign
         base_amt:format in frame c = curr_amt_fmt
         disp_amt = ar_amt
         disp_applied = ar_applied.
      else
      assign
         base_amt:format in frame c = base_amt_fmt
         disp_amt = base_amt
         disp_applied = base_applied.

      display
         disp_amt @ base_amt
      with frame c.
      {&ARDRRP-P-TAG14}
      down 1 with frame c.

      {gprunp.i "mcui" "p" "mc-ex-rate-output"
         "(input ar_curr,
                      input base_curr,
                      input ar_ex_rate,
                      input ar_ex_rate2,
                      input ar_exru_seq,
                      output ex_rate_relation1,
                      output ex_rate_relation2)"}

      display ex_rate_relation1 @ name
         ar_effdate @ ar_date
         ar_cust @ ar_bill
         ar_tax_date @ ar_contested
         ar_acct
         ar_sub
         ar_cc
         string(ar_dun_level) @ ar_cr_terms
         disp_curr @ ar_curr
         disp_applied @ base_amt
      with frame c.
      down 1 with frame c.

      if ex_rate_relation2 <> "" then
      do:
         display ex_rate_relation2 @ name with frame c.
         down 1 with frame c.
      end.

      if ar_po <>  "" then
      do:
         display ar_po @ name with frame c.
         down 1 with frame c.
      end.

      if gltrans
      then do:
         run p-drcrgltrans (input ar_entity,
                            input ar_acct,
                            input ar_sub,
                            input ar_cc,
                            input " ",
                            input base_amt,
                            input ar_date,
                            input ar_bill,
                            input ar_effdate,
                            input ar_batch,
                            input ar_type,
                            {&ARDRRP-P-TAG15}
                            input ar_nbr).
      end. /* IF gltrans */

      l_tot_base_damt = 0.

      /* GET AR DETAIL  */
      for each ard_det  where ard_det.ard_domain = global_domain and  ard_nbr =
      ar_nbr and
            ard_ref = "" no-lock
            by ard_acct
            by ard_sub
            by ard_cc
            by ard_project
         with frame d width 132:

         if ar_curr = base_curr or ar_curr = base_rpt then
         assign
            base_damt:format in frame d = curr_amt_fmt
            base_damt = ard_amt.
         else do:

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input ar_curr,
                         input base_curr,
                         input ar_ex_rate,
                         input ar_ex_rate2,
                         input ard_amt,
                         input true, /* ROUND */
                         output base_damt,
                         output mc-error-number)"}.
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}.
            end.

            base_damt:format in frame d = base_amt_fmt.
         end.

         /* l_tot_base_damt = TOTAL DISTRIBUTION LINE AMOUNTS. */

         l_tot_base_damt = l_tot_base_damt + base_damt.

         if not summary
         then
            run p-acct-disp (input ard_entity,
                             input ard_acct,
                             input ard_sub,
                             input ard_cc,
                             input ard_project,
                             input ard_desc,
                             input ard_amt,
                             input base_damt,
                             input ar_curr).
         else
            if  not l_cnv_rnd_msg
            and base_curr <> ar_curr
            and base_rpt  =  " "
            and (mixed_rpt or
                 gltrans)
            then
               l_cnv_rnd_msg = true.


         if gltrans
         then do:
            run p-drcrgltrans (input ard_entity,
                               input ard_acct,
                               input ard_sub,
                               input ard_cc,
                               input ard_project,
                               input - base_damt,
                               input ar_date,
                               input ar_bill,
                               input ar_effdate,
                               input ar_batch,
                               input ar_type,
                               {&ARDRRP-P-TAG16}
                               input ar_nbr).

            /* FOLLOWING GLTW LINES ARE FOR INTER-COMPANY */
            {glenacex.i &entity=ar_entity
                     &type='"DR"'
                     &module='"AR"'
                     &acct=ico_acct
                     &sub=ico_sub
                     &cc=ico_cc }

            if (ar_entity <> ard_entity)
            then do:
                /*DEBIT DETAIL ENTITY*/
                run p-drcrgltrans (input ard_entity,
                                   input ico_acct,
                                   input ico_sub,
                                   input ico_cc,
                                   input " ",
                                   input base_damt,
                                   input ar_date,
                                   input ar_bill,
                                   input ar_effdate,
                                   input ar_batch,
                                   input ar_type,
                                   {&ARDRRP-P-TAG17}
                                   input ar_nbr).

                /*CREDIT HEADER ENTITY*/
                {glenacex.i &entity=ard_entity
                            &type='"CR"'
                            &module='"AR"'
                            &acct=ico_acct
                            &sub=ico_sub
                            &cc=ico_cc }

                run p-drcrgltrans (input ar_entity,
                                   input ico_acct,
                                   input ico_sub,
                                   input ico_cc,
                                   input " ",
                                   input - base_damt,
                                   input ar_date,
                                   input ar_bill,
                                   input ar_effdate,
                                   input ar_batch,
                                   input ar_type,
                                   {&ARDRRP-P-TAG18}
                                   input ar_nbr).

            end. /* INTER-COMPANY */

         end. /* IF gl_trans */

      end. /* FOR EACH ard_det */

      {&ARDRRP-P-TAG19}
      /* DISPLAYS VIRTUAL ROUNDING ACCOUNT FOR ROUNDING DIFFERENCE */
      /* ONLY FOR MEMOS.                                           */

      if  ar_type                         = "M"
      and base_rpt                        = " "
      and (ar_base_amt - l_tot_base_damt) <> 0
      then do:
         {gprunp.i "mcrndpl" "p" "mc-ex-rounding-det"
            " (input ar_curr,
               output round_acct,
               output round_sub,
               output round_cc,
               output round_proj,
               output round_desc)"}

         if  not mixed_rpt
         and not summary
         and base_rpt <> ar_mstr.ar_curr
         then
            run p-acct-disp (input ar_entity,
                             input round_acct,
                             input round_sub,
                             input round_cc,
                             input " ",
                             input round_desc,
                             input 0,
                             input (ar_base_amt - l_tot_base_damt),
                             input ar_curr).
         if gltrans
         then do:
            run p-drcrgltrans (input ar_entity,
                               input round_acct,
                               input round_sub,
                               input round_cc,
                               input " ",
                               input - (ar_base_amt - l_tot_base_damt),
                               input ar_date,
                               input ar_bill,
                               input ar_effdate,
                               input ar_batch,
                               input ar_type,
                               {&ARDRRP-P-TAG20}
                               input ar_nbr).
         end. /* IF gltrans */
      end. /* IF ar_type = "M" ... */

      undo_txdetrp = true.

      /* ADDED SIXTH INPUT PARAMETER base_rpt AND SEVENTH INPUT     */
      /* PARAMETER mixed_rpt TO ACCOMMODATE THE LOGIC INTRODUCED IN */
      /* txdetrpa.i FOR DISPLAYING THE APPROPRIATE CURRENCY AMOUNT. */

      {gprun.i  ""txdetrp.p"" "(input tax_tr_type,
                                input ar_nbr,
                                input tax_nbr,
                                input col-80,
                                input page_break,
                                input base_rpt,
                                input mixed_rpt)" }
      if undo_txdetrp = true then undo, leave.
      {&ARDRRP-P-TAG21}

      if last-of(ar_batch) then do:
         /* RESET SESSION TO BASE */
         SESSION:numeric-format = oldsession.
         /* DISPLAY BATCH TOTAL. */
         if base_rpt = "" then
         assign
            ar_amt:format in frame e     = base_amt_fmt
            ar_applied:format in frame e = base_amt_fmt.
         else
         assign
            ar_amt:format in frame e     = curr_amt_fmt
            ar_applied:format in frame e = curr_amt_fmt.

         if page-size - line-counter < 3 then page.

         display
            (if base_rpt = ""
            then getTermLabel("BASE",4)
            else base_rpt)
            + getTermLabelCentered("BATCH",7)
            + ar_batch
            + getTermLabelRt("TOTAL",6)
            @ batch_title
            accum total by ar_batch (base_amt) @ ar_amt
            accum total by ar_batch (base_applied) @ ar_applied
         with frame e.

      end.

      {mfrpexit.i}

      /* DISPLAY REPORT TOTAL */
      if last(ar_nbr) then do:
         /* RESET SESSION TO BASE */
         SESSION:numeric-format = oldsession.
         down with frame e.
         if page-size - line-counter < 2 then page.

         display
            (if base_rpt = ""
            then getTermLabel("BASE_REPORT_TOTAL",17)
            else base_rpt + getTermLabelRt("REPORT_TOTAL",14))
            @ batch_title
            accum total (base_amt) @ ar_amt
            accum total (base_applied) @ ar_applied
         with frame e.

      end.
      if (base_rpt <> "") then
         SESSION:numeric-format = c_session.
   end. /* FOR EACH AR_MSTR */

   /* PRINT GL DISTRIBUTION */
   if gltrans then do:
      page.
      SESSION:numeric-format = oldsession.

      /* CHANGED GPGLRP.P TO GPGLRP1.P WHICH PRINTS GL DISTRIBUTION */
      /* TAKING INTO CONSIDERATION THE ROUNDING METHOD OF THE       */
      /* SPECIFIED IN SELECTION CRITERIA.                           */

      {gprun.i ""gpglrp1.p""}
   end.

   /* IF ALL CURRENCIES, PRINT A SUMMARY REPORT BROKEN BY CURRENCY. */
   if base_rpt = "" and mixed_rpt then
   do:
      SESSION:numeric-format = oldsession.
      {gprun.i ""gpacctp.p""}.
   end.

   /* AMOUNTS MAY MISMATCH DUE TO CURRENCY CONVERSION ROUNDING ERRORS. */
   if l_cnv_rnd_msg
   then do:
      {pxmsg.i &MSGNUM=6031 &ERRORLEVEL=2}
   end. /* IF l_cnv_rnd_msg */

   /* REPORT TRAILER */

   {mfrtrail.i}
   */
   /* �����BI */
   /*
   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname, 1, LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.
   */

   PUT unformatted     "ExcelFile;ssbiar06" SKIP.
   PUT unformatted     "SaveFile;" + "ssbiar06" + "-" + string(today, "99999999") + "-" + replace(string(time, "HH:MM:SS"), ":", "")  SKIP.
   PUT unformatted     "exclemacro;PrintPreview1"  SKIP.
   PUT unformatted     "BeginRow;2"  SKIP.

   EMPTY TEMP-TABLE ttssardrrp0001.

   {gprun.i ""ssardrrp0001.p"" "(
      input batch,
      input batch1,
      input nbr,
      input nbr1,
      input cust,
      input cust1,
      input entity,
      input entity1,
      input ardate,
      input ardate1,
      input effdate,
      input effdate1,
      input select_type
      )"}

   tot_dr_amt = 0.
   EMPTY TEMP-TABLE tt1.
   EMPTY TEMP-TABLE tt2.
   FOR EACH ttssardrrp0001
      ,EACH ac_mstr NO-LOCK
      WHERE ac_domain = global_domain
      AND ac_code = ttssardrrp0001_ard_acct
      AND INDEX("ALIE",ac_type) > 0
      ,EACH sb_mstr NO-LOCK
      WHERE sb_domain = global_domain
      AND sb_sub = ttssardrrp0001_ard_sub
      ,EACH cc_mstr NO-LOCK
      WHERE cc_domain = global_domain
      AND cc_ctr = ttssardrrp0001_ard_cc
      ,EACH pj_mstr NO-LOCK
      WHERE pj_domain = global_domain
      AND pj_proj = ttssardrrp0001_ard_project
      BREAK BY ttssardrrp0001_ar_nbr 
      :
      ACCUMULATE ttssardrrp0001_ar_nbr (COUNT BY ttssardrrp0001_ar_nbr).

      /* line */
      CREATE tt1.
      ASSIGN
         tt1_ref = ttssardrrp0001_ar_nbr 
         tt1_line = (ACCUMULATE COUNT BY ttssardrrp0001_ar_nbr ttssardrrp0001_ar_nbr)
         tt1_effdate = STRING(YEAR(ttssardrrp0001_ar_effdate)) + "." +  STRING(MONTH(ttssardrrp0001_ar_effdate)) + "." +  STRING(DAY(ttssardrrp0001_ar_effdate))
         tt1_desc = ttssardrrp0001_ard_desc 
         tt1_ascp  = ac_code
         tt1_as_desc = ac_desc
         /*
         /* 8 - ��ֹ���� */
         tt2_user2 = "��ֹ����: " + ttssardrrp0001_ar_due_date + "        ��Ʊ: " + ttssardrrp0001_vo_invoice
         */
         .
                                              
      {gprun.i ""ssGetInt"" "(
         INPUT tt1_line,
         INPUT 4,
         OUTPUT tt1_page
         )"}

      IF sb_sub <> "" THEN DO:
         ASSIGN
            tt1_ascp = tt1_ascp + "-" + sb_sub
            tt1_as_desc = tt1_as_desc + "-" + sb_desc
            .
      END.

      IF cc_ctr <> "" THEN DO:
         ASSIGN
            tt1_ascp = tt1_ascp + "-" + cc_ctr
            tt1_cp_desc = cc_desc
            .
      END.

      IF pj_project <> "" THEN DO:
         ASSIGN 
            tt1_ascp = tt1_ascp + "-" + pj_project
            .
         IF tt1_cp_desc = "" THEN DO:
            ASSIGN 
               tt1_cp_desc = pj_desc
               .
         END.
         ELSE DO:
            ASSIGN 
               tt1_cp_desc = tt1_cp_desc + "-" + pj_desc 
               .
         END.
      END.
       
      assign 
         tt1_cr_amt = ttssardrrp0001_ard_base_amt
         .
      tot_dr_amt = tot_dr_amt + tt1_cr_amt.
            
      IF ac_curr <> base_curr THEN DO:
         ASSIGN
            tt1_curramt = ABS(ttssardrrp0001_ard_amt)
            tt1_ex_rate = ac_curr + "��" + STRING(ttssardrrp0001_ar_ex_rate2 / ttssardrrp0001_ar_ex_rate ) 
            .
      END.



      /* ref */
      IF LAST-OF(ttssardrrp0001_ar_nbr) THEN DO:
         ttssardrrp0001_recno = RECID(ttssardrrp0001).
         LINE_tt1 = tt1_line + 1.
         {gprun.i ""ssbiar06a.p""}

         CREATE tt2.
         ASSIGN 
            tt2_ref = ttssardrrp0001_ar_nbr 
            /* 8 - ��ֹ���� */
            tt2_user2 = "��ֹ����: " + string(ttssardrrp0001_ar_due_date)
            tt2_decimal1 = ABS(tot_dr_amt)
            tt2_effdate = STRING(YEAR(ttssardrrp0001_ar_effdate)) + "." +  STRING(MONTH(ttssardrrp0001_ar_effdate)) + "." +  STRING(DAY(ttssardrrp0001_ar_effdate))
            tt2_cp_desc = NAME_reports
            tt2_as_desc = "�� " + name_usr + " ��ӡ " + "(����: " + string(year(today)) + "." + string(month(today)) + "." + string(day(today)) + ", " + "ʱ��: " + STRING(TIME,"HH:MM:SS") + ")" 
            /* 6 - �ͻ� */
            tt2_ex_rate = "�ͻ�: " + ttssardrrp0001_ar_cust + " " + ttssardrrp0001_name
            /* 7 - ������ */
            tt2_char1 = "������: " + ttssardrrp0001_ar_batch
            .

         {gprun.i ""ssGetInt"" "(
            INPUT line_tt1,
            INPUT 4,
            OUTPUT tt2_page
            )"}

         {gprun.i ""ssGetCN"" "(
            INPUT tot_dr_amt,
            OUTPUT tt2_desc
            )"}

         ASSIGN 
            tt2_ascp = "���:                              ����:                              �Ƶ�: " +  name_usr
            .

         tot_dr_amt = 0.
      END. /* IF LAST-OF(ttssardrrp0001_ar_nbr) THEN DO: */
   END. /* for each vo_hist */

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
             .
       END.
   END.

   {ssmfrtrail.i}
   /* SS - 20080717.1 - E */

   SESSION:numeric-format = oldsession.
end.

{wbrp04.i &frame-spec = a}