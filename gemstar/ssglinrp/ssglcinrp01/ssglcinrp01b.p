/* glcinrpb.p - GENERAL LEDGER COMPARATIVE INCOME STATEMENT REPORT (PART III) */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.22 $                                                      */
/*V8:ConvertMode=Report                                                       */
/*                          (Formerly glcinrpc.p)                             */
/* REVISION: 1.0      LAST MODIFIED: 12/03/86   BY: emb                       */
/*                                   06/18/87       jms                       */
/*                                   01/25/88       jms                       */
/*                                   02/02/88   by: jms  CSR 24912            */
/*                                   02/29/88   by: jms                       */
/* REVISION: 4.0      LAST MODIFIED: 02/29/88   BY: WUG *A175*                */
/*                                   04/11/88   BY: JMS                       */
/*                                   05/10/88   by: jms *A237*                */
/*                                   06/13/88   by: jms *A274* (no-undo)      */
/*                                   07/29/88   by: jms *A373*                */
/*                                   10/10/88   by: jms *A476*                */
/*                                   11/08/88   by: jms *A526*                */
/* REVISION: 5.0      LAST MODIFIED: 06/09/89   BY: JMS *B066*                */
/*                                   06/15/89   by: jms *B148*                */
/*                                   06/26/89   by: jms *B154*                */
/*                                   09/01/89   by: jms *B271*                */
/*                                   09/27/89   by: jms *B135*                */
/*                                   11/21/89   by: jms *B400*                */
/*                                   02/14/90   by: jms *B499*                */
/*                              SPLIT into glcinrpa.p and glcinrpb.p          */
/*                                   06/04/90   by: jms *B701*                */
/*                                   06/27/90   by: jms *B721*                */
/* REVISION: 6.0      LAST MODIFIED: 10/09/90   by: jms *D034*                */
/*                                   11/07/90   by: jms *D189*                */
/*                                   02/07/91   by: jms *D330*                */
/*                                   04/03/91   by: jms *D488*                */
/*                                   04/04/91   by: jms *D493*                */
/*                                   05/03/91   by: jms *D612*                */
/*                                   07/23/91   by: jms *D791*                */
/* REVISION: 7.0      LAST MODIFIED: 11/13/91   by: jms *F058*                */
/*                                   02/04/92   by: jms *F146*                */
/*                                   02/26/92   by: jms *F231*                */
/*                                   06/30/92   by: jms *F714*                */
/*                                   09/09/92   by: jms *F890*                */
/* REVISION: 7.3      LAST MODIFIED: 09/17/92   by: mpp *G030*                */
/*                                   09/18/92   by: jms *F915*                */
/*                                   04/20/93   by: skk *G993*                */
/*                                   03/03/94   by: pmf *FM62*                */
/*                                   11/08/94   by: srk *GO05*                */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   by: ays *K0TC*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 03/18/98   BY: *J242*   Sachin Shah      */
/* REVISION: 8.6E     LAST MODIFIED: 04/24/98   BY: LN/SVA *L00W*             */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01W* Brenda Milton      */
/* REVISION: 8.6E     LAST MODIFIED: 06/30/99   BY: *L0F6* Hemali Desai       */
/* REVISION: 8.6E     LAST MODIFIED: 10/07/99   BY: *L0JZ* Ranjit Jain        */
/* REVISION: 9.0      LAST MODIFIED: 02/08/00   BY: *J3P3* Ranjit Jain        */
/* REVISION: 9.1      LAST MODIFIED: 07/17/00   BY: *N0G5* Rajinder Kamra     */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/30/00   BY: *N0T4* Manish K.          */
/* Old ECO marker removed, but no ECO header exists *F993*                    */
/* REVISION: 9.1      LAST MODIFIED: 01/19/01   BY: *M104* Seema Tyagi        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.19        BY: Jean Miller         DATE: 01/04/02   ECO: *P03Y* */
/* Revision: 1.21        BY: Paul Donnelly (SB)  DATE: 06/26/03   ECO: *Q00D* */
/* $Revision: 1.22 $      BY: Bhavik Rathod      DATE: 03/07/05   ECO: *P3BQ*  */
/* $Revision: 1.22 $      BY: Bill Jiang      DATE: 08/16/07   ECO: *SS - 20070816.1*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i}
{wbrp02.i}

define shared variable glname like en_name no-undo.
define shared variable begdt like gltr_eff_dt extent 2 no-undo.
define shared variable enddt like gltr_eff_dt extent 2 no-undo.
define shared variable budget like mfc_logical extent 2 no-undo.
define shared variable zeroflag like mfc_logical
   label "Suppress Zero Amounts" no-undo.
define shared variable sub like sb_sub no-undo.
define shared variable sub1 like sb_sub no-undo.
define shared variable ctr like cc_ctr no-undo.
define shared variable ctr1 like cc_ctr no-undo.
define shared variable level as integer
   format ">9" initial 99 label "Level" no-undo.
define shared variable varflag like mfc_logical
   initial true label "Print Variances" no-undo.
define shared variable ccflag like mfc_logical
   label "Summarize Cost Centers" no-undo.
define shared variable subflag like mfc_logical
   label "Summarize Sub-Accounts" no-undo.
define shared variable fiscal_yr like glc_year extent 2 no-undo.
define shared variable per_end like glc_per extent 2 no-undo.
define shared variable per_beg like glc_per extent 2 no-undo.
define shared variable prtflag like mfc_logical initial yes
   label "Suppress Account Numbers" no-undo.
define shared variable entity like en_entity no-undo.
define shared variable entity1 like en_entity no-undo.
define shared variable cname like glname no-undo.
define shared variable hdrstring as character format "x(8)" no-undo.
define shared variable hdrstring1 as character format "x(8)" no-undo.
define shared variable yr_end as date extent 2 no-undo.
define shared variable ret like ac_code no-undo.
define shared variable rpt_curr like gltr_curr no-undo.
define shared variable budgetcode like bg_code extent 2 no-undo.
define shared variable prt1000 like mfc_logical
   label "Round to Nearest Thousand" no-undo.
define shared variable roundcnts like mfc_logical
   label "Round to Nearest Whole Unit" no-undo.
define shared variable prtfmt as character format "x(30)" no-undo.
define shared variable vprtfmt as character format "x(30)" no-undo.
define shared variable income like gltr_amt extent 2 no-undo.
define shared variable percent as decimal format "->>>>.9%"
   extent 2 no-undo.

define new shared variable i as integer no-undo.
define new shared variable ac_recno as recid no-undo.
define new shared variable fmbgflag like mfc_logical extent 2 no-undo.
define new shared variable fm_recno as recid no-undo.
define new shared variable balance as decimal extent 2 no-undo.
define new shared variable totflag like mfc_logical extent 100 no-undo.
define new shared variable tot as decimal extent 100 no-undo.
define new shared variable tot1 as decimal extent 100 no-undo.
define new shared variable xacc like ac_code no-undo.
define new shared variable cur_level as integer no-undo.

define variable record as recid extent 100 no-undo.
define variable fpos like fm_fpos no-undo.
define variable knt as integer no-undo.
define variable balance1 like balance extent 2 no-undo.
define variable crtot like balance extent 2 no-undo.
define variable variance as decimal no-undo.
define variable oldacc like ac_code no-undo.
define variable dt as date no-undo.
define variable pctchar as character no-undo.
define variable varpct as decimal no-undo.
define variable fmbgrecid as recid no-undo.
define variable prtcol like mfc_logical extent 2 no-undo.

/* DEFINE EURO TOOLKIT VARIABLES */
{etrpvar.i &new = " "}
{etvar.i   &new = " "}

define     shared variable et_income      like income     no-undo.
define new shared variable et_balance     like balance    no-undo.
define            variable et_balance1    like balance1   no-undo.
define new shared variable et_tot         like tot        no-undo.
define new shared variable et_tot1        like tot1       no-undo.
define            variable et_crtot       like crtot      no-undo.
define            variable et_variance    like variance   no-undo.

/* VARIABLES FOR CALCULATING CONVERSION DIFFERENCE */
define            variable et_conv_tot    like tot        no-undo.
define            variable et_conv_tot1   like tot1       no-undo.
define            variable et_conv_crtot  like crtot      no-undo.
define            variable et_conv_variance like variance no-undo.

/* CYCLE THROUGH FORMAT POSITION FILE */
assign
   cur_level   = 1
   fmbgflag    = no.

for first fm_mstr
fields( fm_domain fm_fpos fm_sums_into fm_dr_cr fm_total fm_type fm_desc
        fm_header fm_underln fm_skip fm_page_brk)
use-index fm_fpos  where fm_mstr.fm_domain = global_domain and  fm_type = "I"
                    and fm_sums_into = 0
no-lock: end.

loopa:
repeat:

   if not available fm_mstr then do:
      repeat:

         assign
            cur_level = cur_level - 1.

         if cur_level < 1 then leave.

         for first fm_mstr
         fields( fm_domain fm_fpos fm_sums_into fm_dr_cr fm_total fm_type
                 fm_desc fm_header fm_underln fm_skip fm_page_brk)
         no-lock where recid(fm_mstr) = record[cur_level]:
         end.

         assign
            fpos = fm_sums_into
            fm_recno = recid(fm_mstr).

         /* SS - 20070816.1 - B */
         /*
         {gprun.i ""glcinrpc.p""}
         */
         {gprun.i ""ssglcinrp01c.p""}
         /* SS - 20070816.1 - E */

         if keyfunction(lastkey) = "end-error" then
            undo, leave loopa.

         if fmbgflag[1] and budget[1]
         then do:

            {glfmbg.i &fpos=fm_fpos &yr=fiscal_yr[1]
               &per=per_beg[1] &per1=per_end[1] &budget=balance[1]
               &bcode=budgetcode[1]}

            if et_report_curr <> rpt_curr then do:
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input rpt_curr,
                    input et_report_curr,
                    input et_rate1,
                    input et_rate2,
                    input balance[1],
                    input true,    /* ROUND */
                    output et_balance[1],
                    output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.
            end.  /* if et_report_curr <> rpt_curr */
            else
               assign et_balance[1] = balance[1].

            /* SS - 20070816.1 - B */
            /*
            if prt1000 then
               assign
                  et_balance[1] = round((et_balance[1] / 1000),0).
            else if roundcnts
            then
               assign
                  et_balance[1] = round(et_balance[1],0).
            */
            if prt1000 then
               assign
                  et_balance[1] = round((et_balance[1] / 1000),2).
            else if roundcnts
            then
               assign
                  et_balance[1] = round(et_balance[1],2).
            /* SS - 20070816.1 - E */

            assign
               tot[cur_level] = balance[1]
               et_tot[cur_level] = et_balance[1].

         end.  /* IF fmgbflag[1] AND budget[1] */

         if fmbgflag[2] and budget[2]
         then do:

            {glfmbg.i &fpos=fm_fpos &yr=fiscal_yr[2]
               &per=per_beg[2] &per1=per_end[2] &budget=balance[2]
               &bcode=budgetcode[2]}

            if et_report_curr <> rpt_curr then do:
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input rpt_curr,
                    input et_report_curr,
                    input et_rate1,
                    input et_rate2,
                    input balance[2],
                    input true,    /* ROUND */
                    output et_balance[2],
                    output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.
            end.  /* if et_report_curr <> rpt_curr */
            else
               assign et_balance[2] = balance[2].

            /* SS - 20070816.1 - B */
            /*
            if prt1000 then
               assign
                  et_balance[2] = round((et_balance[2] / 1000), 0).
            else if roundcnts
            then
               assign
                  et_balance[2] = round(et_balance[2], 0).
            */
            if prt1000 then
               assign
                  et_balance[2] = round((et_balance[2] / 1000), 2).
            else if roundcnts
            then
               assign
                  et_balance[2] = round(et_balance[2], 2).
            /* SS - 20070816.1 - E */

            assign
               tot1[cur_level] = balance[2]
               et_tot1[cur_level] = et_balance[2].

         end.  /* IF fmbgflag[2] AND budget[2] */

         if cur_level > 1 then
         assign
            tot[cur_level - 1]  = tot[cur_level - 1]  + tot[cur_level]
            tot1[cur_level - 1] = tot1[cur_level - 1] + tot1[cur_level]
            et_tot[cur_level - 1]  = et_tot[cur_level - 1]  + et_tot[cur_level]
            et_tot1[cur_level - 1] = et_tot1[cur_level - 1] + et_tot1[cur_level].

         if level >= cur_level then do:

            if fm_total = no or level = cur_level then do:

               do i = 1 to 2:
                  assign
                     prtcol[i] = yes.

                  if fmbgflag[i]                 and
                     fmbgrecid <> recid(fm_mstr) and
                     budget[i]
                  then
                     assign
                        prtcol[i] = no.
               end.

               /* SS - 20070816.1 - B */
               /*
               if totflag[cur_level] then do:

                  if varflag and (prt1000 or roundcnts) then do:

                     if prtcol[1] then
                        put
                           "-----------------" to 68
                           "--------" to 77.

                     if prtcol[2] then
                        put
                           "-----------------" to 95
                           "--------" to 104.

                     if prtcol[1] and prtcol[2] then
                        put
                           "-----------------" to 122
                           "--------" to 131.

                  end.

                  else do:

                     if prtcol[1] then
                        put
                           "--------------------" to 71
                           "--------" at 73.

                     if prtcol[2] then
                        put
                           "--------------------" to 101
                           "--------" at 103.

                     if prtcol[1] and prtcol[2] and varflag then
                        put
                           "--------------------" at 112.

                  end.

                  if (prtcol[1] or prtcol[2]) then
                     put
                        {gplblfmt.i &FUNC=caps(getTermLabel(""TOTAL"",5))
                                    &CONCAT="' '"}
                           at min(7,cur_level * 2 - 1)
                        fm_desc.

               end. /* if totflag[cur_level] ... */

               else if fm_header then
                  put
                     fm_desc at min(7,cur_level * 2 - 1).
               */
               /* SS - 20070816.1 - E */

               if fm_dr_cr = false then do:

                  assign
                     crtot[1] = - tot[cur_level]
                     crtot[2] = - tot1[cur_level].

                  assign
                     variance    = crtot[1] - crtot[2]
                     et_crtot[1] = - et_tot[cur_level]
                     et_crtot[2] = - et_tot1[cur_level]
                     et_variance = et_crtot[1] - et_crtot[2].

                  if et_income[1] <> 0 then
                     assign percent[1] = et_crtot[1] / et_income[1] * 100.

                  if et_income[2] <> 0 then
                     assign percent[2] = et_crtot[2] / et_income[2] * 100.

                  if varflag and (prt1000 or roundcnts) then do:

                     if et_crtot[2] <> 0 then do:
                        assign
                           varpct = (et_variance / et_crtot[2]) * 100
                           pctchar = string(varpct, "->>>9.9%").
                     end.
                     else
                        assign pctchar = "     **".

                     /* SS - 20070816.1 - B */
                     /*
                     if prtcol[1] then
                        put
                           string(et_crtot[1], prtfmt) format "x(17)" to 68
                           percent[1] to 77.

                     if prtcol[2] then
                        put
                           string(et_crtot[2], prtfmt) format "x(17)" to 95
                           percent[2] to 104.

                     if prtcol[1] and prtcol[2] then
                        put
                           string(et_variance, vprtfmt) format "x(17)" to 122
                           pctchar to 131.
                     */
                     /* SS - 20070816.1 - E */

                  end.

                  else do:

                     /* SS - 20070816.1 - B */
                     /*
                     if prtcol[1] then
                        put
                           string(et_crtot[1], prtfmt) format "x(20)" to 71
                           percent[1] at 73.

                     if prtcol[2] then
                        put
                           string(et_crtot[2], prtfmt) format "x(20)" to 101
                           percent[2] at 103.

                     if prtcol[1] and prtcol[2] and varflag then
                        put
                           string(et_variance, vprtfmt) format "x(20)" at 112.
                     */
                     /* SS - 20070816.1 - E */

                     /* *** CALCULATE CONVERSION DIFFERENCE *** */
                     if cur_level <= 1 and
                        et_show_diff and
                        not prt1000  and
                        not roundcnts and
                        et_report_curr <> ""
                     then do:

                        /* CONVERT AMOUNTS */
                        if prtcol[1] then do:

                           if et_report_curr <> rpt_curr then do:
                              {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input rpt_curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input crtot[1],
                                   input true,    /* ROUND */
                                   output et_conv_crtot[1],
                                   output mc-error-number)"}
                              if mc-error-number <> 0 then do:
                                 {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                              end.
                           end.  /* if et_report_curr <> rpt_curr */
                           else
                              assign et_conv_crtot[1] = crtot[1].

                        end.

                        if prtcol[2] then do:

                           if et_report_curr <> rpt_curr then do:
                              {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input rpt_curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input crtot[2],
                                   input true,    /* ROUND */
                                   output et_conv_crtot[2],
                                   output mc-error-number)"}
                              if mc-error-number <> 0 then do:
                                 {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                              end.
                           end.  /* if et_report_curr <> rpt_curr */
                           else
                              assign et_conv_crtot[2] = crtot[2].

                        end.

                        if prtcol[1] and prtcol[2] then do:

                           if et_report_curr <> rpt_curr then do:
                              {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input rpt_curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input variance,
                                   input true,    /* ROUND */
                                   output et_conv_variance,
                                   output mc-error-number)"}
                              if mc-error-number <> 0 then do:
                                 {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                              end.
                           end.  /* if et_report_curr <> rpt_curr */
                           else
                              assign et_conv_variance = variance.

                        end.

                        /* SS - 20070816.1 - B */
                        /*
                        /* CHECK DIFFERENCES */
                        if (
                           ( (et_conv_crtot[1] - et_crtot[1] <> 0)
                           and prtcol[1] ) or
                           ( (et_conv_crtot[2] - et_crtot[2] <> 0)
                           and prtcol[2] ) or
                           ( (et_conv_variance - et_variance <> 0)
                           and prtcol[1] and prtcol[2]
                           and varflag)
                           )
                        then do: /* CONVERTED AMOUNTS DON'T MATCH */

                           /* DISPLAY DIFFERENCES */
                           put
                              "   " + et_diff_txt + ":" format "x(30)"
                                 at minimum(7,cur_level * 2 - 1).

                           if prtcol[1] then
                              put
                                 string(et_crtot[1] - et_conv_crtot[1], prtfmt)
                                 format "x(20)" to 71.

                           if prtcol[2] then
                              put
                                 string(et_crtot[2] - et_conv_crtot[2], prtfmt)
                                 format "x(20)" to 101.

                           if prtcol[1] and prtcol[2]
                              and varflag
                           then
                              put
                                 string(et_variance - et_conv_variance, vprtfmt)
                                 format "x(20)" at 112.

                           put skip (1).

                        end. /* CONVERTED AMOUNTS DON'T MATCH */
                        */
                        /* SS - 20070816.1 - E */

                     end. /* if et_show_diff then do: */

                  end.

               end.

               else do:

                  if et_income[1] <> 0 then
                     assign
                        percent[1] = et_tot[cur_level] / et_income[1] * 100.

                  if et_income[2] <> 0 then
                     assign
                        percent[2] = et_tot1[cur_level] / et_income[2]  * 100.

                  assign
                     variance = tot1[cur_level] - tot[cur_level]
                     et_variance = et_tot1[cur_level] - et_tot[cur_level].

                  if varflag and (prt1000 or roundcnts) then do:

                     if et_tot1[cur_level] <> 0 then do:
                        assign
                           varpct = (et_variance / et_tot1[cur_level]) * 100
                           pctchar = string(varpct, "->>>9.9%").
                     end.
                     else
                        assign pctchar = "     **".

                     /* SS - 20070816.1 - B */
                     /*
                     if prtcol[1] then
                        put
                           string(et_tot[cur_level], prtfmt)
                              format "x(17)" to 68
                           percent[1] to 77.

                     if prtcol[2] then
                        put
                           string(et_tot1[cur_level], prtfmt)
                              format "x(17)" to 95
                           percent[2] to 104.

                     if prtcol[1] and prtcol[2] then
                        put
                           string(et_variance, vprtfmt)
                              format "x(17)" to 122 pctchar to 131.
                     */
                     /* SS - 20070816.1 - E */

                     /* ** CALCULATE CONVERSION DIFFERENCE *** */
                     if et_show_diff and cur_level = 1 then do:

                        /* CONVERT AMOUNTS */
                        if prtcol[1] then do:
                           if et_report_curr <> rpt_curr then do:
                              {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input rpt_curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input tot[cur_level],
                                   input true,    /* ROUND */
                                   output et_conv_tot[cur_level],
                                   output mc-error-number)"}
                              if mc-error-number <> 0 then do:
                                 {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                              end.
                           end.  /* if et_report_curr <> rpt_curr */
                           else
                           assign
                              et_conv_tot[cur_level] = tot[cur_level].
                        end.

                        if prtcol[2] then do:
                           if et_report_curr <> rpt_curr then do:
                              {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input rpt_curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input tot1[cur_level],
                                   input true,    /* ROUND */
                                   output et_conv_tot1[cur_level],
                                   output mc-error-number)"}
                              if mc-error-number <> 0 then do:
                                 {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                              end.
                           end.  /* if et_report_curr <> rpt_curr */
                           else
                           assign
                              et_conv_tot1[cur_level] = tot1[cur_level].
                        end.

                        if prtcol[1] and prtcol[2] then do:
                           if et_report_curr <> rpt_curr then do:
                              {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input rpt_curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input variance,
                                   input true,    /* ROUND */
                                   output et_conv_variance,
                                   output mc-error-number)"}
                              if mc-error-number <> 0 then do:
                                 {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                              end.
                           end.  /* if et_report_curr <> rpt_curr */
                           else
                              assign et_conv_variance = variance.
                        end.

                        /* SS - 20070816.1 - B */
                        /*
                        /* CHECK DIFFERENCES */
                        if (
                           ( (et_conv_tot[cur_level] - et_tot[cur_level] <> 0)
                           and prtcol[1] ) or
                           ( (et_conv_tot1[cur_level] -
                           et_tot1[cur_level] <> 0)
                           and prtcol[2] ) or
                           ( (et_conv_variance - et_variance <> 0)
                           and prtcol[1] and prtcol[2])
                           )
                        then do:     /* CONVERTED AMOUNTS DON'T MATCH */

                           /* DISPLAY DIFFERENCES */
                           put
                              "   " + et_diff_txt + ":" format "x(30)"
                                 at minimum(7,cur_level * 2 - 1).

                           if prtcol[1] then
                              put
                                 string(et_tot[cur_level] -
                                        et_conv_tot[cur_level], prtfmt)
                                 format "x(17)" to 68.

                           if prtcol[2] then
                              put
                                 string(et_tot1[cur_level] -
                                        et_conv_tot1[cur_level], prtfmt)
                                 format "x(17)" to 95.

                           if prtcol[1] and prtcol[2] then
                              put
                                 string(et_variance -
                                        et_conv_variance, vprtfmt)
                                 format "x(17)" to 122.

                           put skip (1).

                        end. /* CONVERTED AMOUNTS DON'T MATCH */
                        */
                        /* SS - 20070816.1 - E */

                     end. /* if et_show_diff then do: */

                  end.

                  else do:

                     /* SS - 20070816.1 - B */
                     /*
                     if prtcol[1] then
                        put
                           string(et_tot[cur_level], prtfmt)
                           format "x(20)" to 71
                           percent[1] at 73.

                     if prtcol[2] then
                        put
                           string(et_tot1[cur_level], prtfmt)
                           format "x(20)" to 101
                           percent[2] at 103.

                     if prtcol[1] and prtcol[2] and varflag then
                        put
                           string(et_variance, vprtfmt)
                           format "x(20)" at 112.
                     */
                     /* SS - 20070816.1 - E */

                     /* ***    CALCULATE CONVERSION DIFFERENCE *** */
                     if et_show_diff then do:

                        /* CONVERT AMOUNTS */
                        if prtcol[1] then do:
                           if et_report_curr <> rpt_curr then do:
                              {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input rpt_curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input tot[cur_level],
                                   input true,    /* ROUND */
                                   output et_conv_tot[cur_level],
                                   output mc-error-number)"}
                              if mc-error-number <> 0 then do:
                                 {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                              end.
                           end.  /* if et_report_curr <> rpt_curr */
                           else
                           assign
                              et_conv_tot[cur_level] = tot[cur_level].
                        end.

                        if prtcol[2] then do:
                           if et_report_curr <> rpt_curr then do:
                              {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input rpt_curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input tot1[cur_level],
                                   input true,    /* ROUND */
                                   output et_conv_tot1[cur_level],
                                   output mc-error-number)"}
                              if mc-error-number <> 0 then do:
                                 {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                              end.
                           end.  /* if et_report_curr <> rpt_curr */
                           else
                           assign
                              et_conv_tot1[cur_level] = tot1[cur_level].
                        end.

                        if prtcol[1] and prtcol[2] and varflag
                        then do:
                           if et_report_curr <> rpt_curr then do:
                              {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input rpt_curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input variance,
                                   input true,    /* ROUND */
                                   output et_conv_variance,
                                   output mc-error-number)"}
                              if mc-error-number <> 0 then do:
                                 {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                              end.
                           end.  /* if et_report_curr <> rpt_curr */
                           else
                              assign et_conv_variance = variance.
                        end.

                        /* SS - 20070816.1 - B */
                        /*
                        /* CHECK DIFFERENCES */
                        if ( (et_conv_tot[cur_level] -
                           et_tot[cur_level] <> 0)
                           and prtcol[1] ) or
                           ( (et_conv_tot1[cur_level] -
                           et_tot1[cur_level] <> 0)
                           and prtcol[2] ) or
                           ( (et_conv_variance - et_variance <> 0)
                           and prtcol[1] and prtcol[2]
                           and varflag)
                        then do: /* CONVERTED AMOUNTS DON'T MATCH */

                           /*DISPLAY DIFFERENCES */
                           put
                              "   " + et_diff_txt + ":" format "x(30)"
                              at minimum(7,cur_level * 2 - 1).

                           if prtcol[1] then
                              put
                                 string(et_tot[cur_level] -
                                        et_conv_tot[cur_level], prtfmt)
                                 format "x(20)" to 71.

                           if prtcol[2] then
                              put
                                 string(et_tot1[cur_level] -
                                        et_conv_tot1[cur_level], prtfmt)
                                 format "x(20)" to 101.

                           if prtcol[1] and prtcol[2] and varflag
                           then
                              put
                                 string(et_variance - et_conv_variance, vprtfmt)
                                 format "x(20)" at 112.

                           put skip (1).

                        end. /* CONVERTED AMOUNTS DON'T MATCH */
                        */
                        /* SS - 20070816.1 - E */

                     end. /* if et_show_diff then do: */

                  end.  /* else do */

               end.

               /* SS - 20070816.1 - B */
               /*
               if fm_underln then do:

                  if varflag and (prt1000 or roundcnts) then do:

                     if prtcol[1] then
                        put
                           "=================" to 68
                           "========" to 77.

                     if prtcol[2] then
                        put
                           "=================" to 95
                           "========" to 104.

                     if prtcol[1] and prtcol[2] then
                        put
                           "=================" to 122
                           "========" to 131.
                  end.

                  else do:

                     if prtcol[1] then
                        put
                           "====================" to 71
                           "========" at 73.

                     if prtcol[2] then
                        put
                           "====================" to 101
                           "========" at 103.

                     if prtcol[1] and prtcol[2] and
                        varflag
                     then
                        put
                           "====================" at 112.

                  end.

               end.  /* if fm_underln */

               if (prtcol[1] or prtcol[2]) and
                  totflag[cur_level] and fm_skip then put skip(1).
               */
               /* SS - 20070816.1 - E */
            end.

            /* SS - 20070816.1 - B */
            /*
            if fm_page_brk then page.
            */
            /* SS - 20070816.1 - E */

            if cur_level > 1 then assign totflag[cur_level - 1] = yes.

         end.

         if fmbgrecid = recid(fm_mstr) then assign fmbgflag = no.

         find next fm_mstr use-index fm_fpos
             where fm_mstr.fm_domain = global_domain and  fm_type = "I"
              and fm_sums_into = fpos
         no-lock no-error.
         if available fm_mstr then leave.

      end.

   end.

   if cur_level < 1 then leave.

   /* SS - 20070816.1 - B */
   /*
   if fm_header = no and level >= cur_level then
      put
         fm_desc at min(7,cur_level * 2 - 1).
   */
   /* SS - 20070816.1 - E */

   assign
      record[cur_level] = recid(fm_mstr)
      tot[cur_level] = 0
      tot1[cur_level] = 0
      totflag[cur_level] = no
      et_tot[cur_level]  = 0
      et_tot1[cur_level] = 0.

   if budget[1] and
      can-find (first bg_mstr  where bg_mstr.bg_domain = global_domain and
                      bg_code = budgetcode[1] and
                      bg_entity >= entity and
                      bg_entity <= entity1 and
                      bg_acc = "" and bg_cc = "" and
                      bg_project = "" and
                      bg_fpos = fm_fpos)
   then
      assign
         fmbgflag[1] = yes
         fmbgrecid   = recid(fm_mstr).

   if budget[2] and
      can-find (first bg_mstr  where bg_mstr.bg_domain = global_domain and
                      bg_code = budgetcode[2] and
                      bg_entity >= entity and
                      bg_entity <= entity1 and
                      bg_acc = "" and bg_cc = "" and
                      bg_project = "" and
                      bg_fpos = fm_fpos)
   then
      assign
         fmbgflag[2] = yes
         fmbgrecid   = recid(fm_mstr).

   assign
      fpos = fm_fpos.

   for first fm_mstr
   fields( fm_domain fm_fpos fm_sums_into fm_dr_cr fm_total fm_type fm_desc
           fm_header fm_underln fm_skip fm_page_brk)
   use-index fm_fpos  where fm_mstr.fm_domain = global_domain and  fm_sums_into
   = fpos
                       and fm_type = "I"
   no-lock: end.

   if available fm_mstr and cur_level < 100 then
      assign
         cur_level = cur_level + 1.

   else do:

      for first fm_mstr
      fields( fm_domain fm_fpos fm_sums_into fm_dr_cr fm_total fm_type fm_desc
              fm_header fm_underln fm_skip fm_page_brk)
      where recid(fm_mstr) = record[cur_level]
      no-lock:  end.

      assign
         fpos = fm_sums_into
         fm_recno = recid(fm_mstr).

      /* SS - 20070816.1 - B */
      /*
      {gprun.i ""glcinrpc.p""}
      */
      {gprun.i ""ssglcinrp01c.p""}
      /* SS - 20070816.1 - E */

      if keyfunction(lastkey) = "end-error" then
         undo, leave loopa.

      if fmbgflag[1] and
         budget[1]
      then do:

         {glfmbg.i &fpos=fm_fpos &yr=fiscal_yr[1] &per=per_beg[1]
            &per1=per_end[1] &budget=balance[1] &bcode=budgetcode[1]}

         if et_report_curr <> rpt_curr then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input rpt_curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input balance[1],
                 input true,    /* ROUND */
                 output et_balance[1],
                 output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end.  /* if et_report_curr <> rpt_curr */
         else
            assign et_balance[1] = balance[1].

         /* SS - 20070816.1 - B */
         /*
         if prt1000 then
            et_balance[1] = round((et_balance[1] / 1000), 0).
         else if roundcnts then
            et_balance[1] = round(et_balance[1], 0).
         */
         if prt1000 then
            et_balance[1] = round((et_balance[1] / 1000), 2).
         else if roundcnts then
            et_balance[1] = round(et_balance[1], 2).
         /* SS - 20070816.1 - E */

         assign
            tot[cur_level] = balance[1]
            et_tot[cur_level] = et_balance[1].

      end.  /* IF fmbgflag[1] AND budget[1] */

      if fmbgflag[2] and
         budget[2]
      then do:

         {glfmbg.i &fpos=fm_fpos &yr=fiscal_yr[2] &per=per_beg[2]
            &per1=per_end[2] &budget=balance[2] &bcode=budgetcode[2]}

         if et_report_curr <> rpt_curr then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input rpt_curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input balance[2],
                 input true,    /* ROUND */
                 output et_balance[2],
                 output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end.  /* if et_report_curr <> rpt_curr */
         else
            assign et_balance[2] = balance[2].

         /* SS - 20070816.1 - B */
         /*
         if prt1000 then
            et_balance[2] = round((et_balance[2] / 1000), 0).
         else if roundcnts then
            et_balance[2] = round(et_balance[2], 0).
         */
         if prt1000 then
            et_balance[2] = round((et_balance[2] / 1000), 2).
         else if roundcnts then
            et_balance[2] = round(et_balance[2], 2).
         /* SS - 20070816.1 - E */

         assign
            tot1[cur_level] = balance[2]
            et_tot1[cur_level] = et_balance[2].

      end.  /* IF fmbgflag[2] AND budget[2] */

      if cur_level > 1 then do:
         assign
            tot[cur_level - 1] = tot[cur_level - 1] + tot[cur_level]
            tot1[cur_level - 1] = tot1[cur_level - 1] + tot1[cur_level]
            et_tot[cur_level - 1] = et_tot[cur_level - 1] +
            et_tot[cur_level]
            et_tot1[cur_level - 1] = et_tot1[cur_level - 1] +
            et_tot1[cur_level].
      end.

      if level >= cur_level then do:

         if fm_total = no or level = cur_level then do:

            do i = 1 to 2:
               assign prtcol[i] = yes.
               if fmbgflag[i]                 and
                  fmbgrecid <> recid(fm_mstr) and
                  budget[i]
               then
                  assign prtcol[i] = no.
            end.

            /* SS - 20070816.1 - B */
            /*
            if totflag[cur_level] then do:

               if varflag and (prt1000 or roundcnts) then do:

                  if prtcol[1] then
                     put
                        "-----------------" to 68
                        "--------" to 77.

                  if prtcol[2] then
                     put
                        "-----------------" to 95
                        "--------" to 104.

                  if prtcol[1] and prtcol[2] then
                     put
                        "-----------------" to 122
                        "--------" to 131.

               end.

               else do:

                  if prtcol[1] then
                     put
                        "--------------------" to 71
                        "--------" at 73.

                  if prtcol[2] then
                     put
                        "--------------------" to 101
                        "--------" at 103.

                  if prtcol[1] and prtcol[2] and varflag then
                     put
                        "--------------------" at 112.

               end.

               if (prtcol[1] or
                   prtcol[2])
               then do:
                  put
                     {gplblfmt.i &FUNC=caps(getTermLabel(""TOTAL"",5))
                                 &CONCAT="' '"} at min(7,cur_level * 2 - 1)
                     fm_desc.
               end.

            end.  /* if totflag[cur_level] */

            else if fm_header then
               put
                  fm_desc at min(7,cur_level * 2 - 1).
            */
            /* SS - 20070816.1 - E */

            if fm_dr_cr = false then do:

               assign
                  crtot[1] = - tot[cur_level]
                  et_crtot[1] = - et_tot[cur_level].

               assign
                  variance    = crtot[1] - crtot[2]
                  et_crtot[2] = - et_tot1[cur_level]
                  et_variance = et_crtot[1] - et_crtot[2].

               if et_income[1] <> 0 then
                  assign
                     percent[1] = et_crtot[1] / et_income[1] * 100.

               if et_income[2] <> 0 then
                  assign
                     percent[2] = et_crtot[2] / et_income[2] * 100.

               if varflag and (prt1000 or roundcnts) then do:

                  if et_crtot[2] <> 0 then do:
                     assign
                        varpct = (et_variance / et_crtot[2]) * 100
                        pctchar = string(varpct, "->>>9.9%").
                  end.
                  else
                     assign
                        pctchar = "     **".

                  /* SS - 20070816.1 - B */
                  /*
                  if prtcol[1] then
                     put
                        string(et_crtot[1], prtfmt) format "x(17)" to 68
                        percent[1] to 77.

                  if prtcol[2] then
                     put
                        string(et_crtot[2], prtfmt) format "x(17)" to 95
                        percent[2] to 104.

                  if prtcol[1] and prtcol[2] then
                     put
                        string(et_variance, vprtfmt) format "x(17)"
                        to 122 pctchar to 131.
                  */
                  /* SS - 20070816.1 - E */

               end.  /* if varflag */

               else do:

                  /* SS - 20070816.1 - B */
                  /*
                  if prtcol[1] then
                     put
                        string(et_crtot[1], prtfmt) format "x(20)" to 71
                        percent[1] at 73.

                  if prtcol[2] then
                     put
                        string(et_crtot[2], prtfmt) format "x(20)" to 101
                        percent[2] at 103.

                  if prtcol[1] and prtcol[2] and varflag then
                     put
                        string(et_variance, vprtfmt) format "x(20)" at 112.
                  */
                  /* SS - 20070816.1 - E */

                  if cur_level <= 1 and et_show_diff and
                     not prt1000 and not roundcnts and
                     et_report_curr <> ""
                  then do:

                     if et_report_curr <> rpt_curr then do:
                        {gprunp.i "mcpl" "p" "mc-curr-conv"
                           "(input rpt_curr,
                             input et_report_curr,
                             input et_rate1,
                             input et_rate2,
                             input crtot[1],
                             input true,    /* ROUND */
                             output et_conv_crtot[1],
                             output mc-error-number)"}
                        if mc-error-number <> 0 then do:
                           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                        end.
                     end.  /* if et_report_curr <> rpt_curr */
                     else
                        assign et_conv_crtot[1] = crtot[1].

                     if et_report_curr <> rpt_curr then do:
                        {gprunp.i "mcpl" "p" "mc-curr-conv"
                           "(input rpt_curr,
                             input et_report_curr,
                             input et_rate1,
                             input et_rate2,
                             input crtot[2],
                             input true,    /* ROUND */
                             output et_conv_crtot[2],
                             output mc-error-number)"}
                        if mc-error-number <> 0 then do:
                           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                        end.
                     end.  /* if et_report_curr <> rpt_curr */
                     else
                        assign et_conv_crtot[2] = crtot[2].

                     if et_report_curr <> rpt_curr then do:
                        {gprunp.i "mcpl" "p" "mc-curr-conv"
                           "(input rpt_curr,
                             input et_report_curr,
                             input et_rate1,
                             input et_rate2,
                             input variance,
                             input true,    /* ROUND */
                             output et_conv_variance,
                             output mc-error-number)"}
                        if mc-error-number <> 0 then do:
                           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                        end.
                     end.  /* if et_report_curr <> rpt_curr */
                     else
                        assign et_conv_variance = variance.

                     /* SS - 20070816.1 - B */
                     /*
                     if ( (et_conv_crtot[1] - et_crtot[1] <> 0)
                        and prtcol[1] ) or
                        ( (et_conv_crtot[2] - et_crtot[2] <> 0)
                        and prtcol[2] ) or
                        ( (et_conv_variance - et_variance <> 0)
                        and prtcol[1] and prtcol[2]
                        and varflag)
                     then do:

                        /* DISPLAY DIFFERENCES */
                        put et_diff_txt + ":" format "x(30)" at 4.

                        if prtcol[1] then
                        put
                           string(et_crtot[1] - et_conv_crtot[1], prtfmt)
                           format "x(20)" to 71.

                        if prtcol[2] then
                        put
                           string(et_crtot[2] - et_conv_crtot[2], prtfmt)
                           format "x(20)" to 101.

                        if prtcol[1] and prtcol[2]
                           and varflag then
                        put
                           string(et_variance - et_conv_variance, vprtfmt)
                           format "x(20)" at 112.

                        put skip (1).

                     end.
                     */
                     /* SS - 20070816.1 - E */
                  end.  /* if cur_level <= 1 and et_show_diff */

               end.  /* else do */

            end.  /* if fm_dr_cr = false */

            else do:

               assign
                  et_variance = et_tot1[cur_level] - et_tot[cur_level]
                  variance    = tot1[cur_level] - tot[cur_level].

               if et_income[1] <> 0 then
                  percent[1] = et_tot[cur_level] / et_income[1] * 100.
               if et_income[2] <> 0 then
                  percent[2] = et_tot1[cur_level] / et_income[2] * 100.

               if varflag and (prt1000 or roundcnts) then do:

                  if et_tot1[cur_level] <> 0 then do:
                     assign
                        varpct = (et_variance / et_tot1[cur_level])
                        pctchar = string(varpct, "->>>9.9%").
                  end.
                  else
                     assign pctchar = "     **".

                  /* SS - 20070816.1 - B */
                  /*
                  if prtcol[1] then
                     put
                        string(et_tot[cur_level], prtfmt) format "x(17)" to 68
                        percent[1] to 77.

                  if prtcol[2] then
                     put
                        string(et_tot1[cur_level], prtfmt) format "x(17)" to 95
                        percent[2] to 104.

                  if prtcol[1] and prtcol[2] then
                     put
                        string(et_variance, vprtfmt) format "x(17)" to 122
                        pctchar to 131.
                  */
                  /* SS - 20070816.1 - E */

               end.  /* if varflag */

               /* SS - 20070816.1 - B */
               /*
               else do:

                  if prtcol[1] then
                     put
                        string(et_tot[cur_level], prtfmt) format "x(20)" to 71
                     percent[1] at 73.

                  if prtcol[2] then
                     put
                        string(et_tot1[cur_level], prtfmt) format "x(20)" to 101
                        percent[2] at 103.

                  if prtcol[1] and prtcol[2] and varflag then
                     put
                        string(et_variance, vprtfmt) format "x(20)" at 112.

               end.  /* else do */
               */
               /* SS - 20070816.1 - E */

            end.  /* else do */

            /* SS - 20070816.1 - B */
            /*
            if fm_underln then do:

               if varflag and (prt1000 or roundcnts) then do:

                  if prtcol[1] then
                     put
                        "=================" to 68
                        "========" to 77.

                  if prtcol[2] then
                     put
                        "=================" to 95
                        "========" to 104.

                  if prtcol[1] and prtcol[2] then
                     put
                        "=================" to 122
                        "========" to 131.

               end.  /* if varflag */

               else do:

                  if prtcol[1] then
                     put
                        "====================" to 71
                        "========" at 73.

                  if prtcol[2] then
                     put
                        "====================" to 101
                        "========" at 103.

                  if prtcol[1] and prtcol[2] and
                     varflag
                  then
                     put
                        "====================" at 112.

               end.  /* else do */

            end.  /* if fm_underln */

            if (prtcol[1] or prtcol[2]) and
               totflag[cur_level] and fm_skip then put skip(1).
            */
            /* SS - 20070816.1 - E */

         end.  /* if fm_total = no */

         /* SS - 20070816.1 - B */
         /*
         if fm_page_brk then page.
         */
         /* SS - 20070816.1 - E */

         if cur_level > 1 then
            assign totflag[cur_level - 1] = yes.

      end.  /* if level >= cur_level */

      if fmbgrecid = recid(fm_mstr) then
         assign fmbgflag = no.

      find next fm_mstr use-index fm_fpos  where fm_mstr.fm_domain =
      global_domain and
                fm_sums_into = fpos
            and fm_type = "I"
      no-lock no-error.

   end.

   {mfrpchk.i}

end.

{wbrp04.i}
