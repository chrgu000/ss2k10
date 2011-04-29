/* glcbsrpa.p - GENERAL LEDGER COMPARATIVE BAL SHT REPORT (PART II)        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.18 $                                                        */
/*V8:ConvertMode=Report                                                    */
/* REVISION: 1.0      LAST MODIFIED: 12/03/86   by: emb                    */
/*                                   06/18/87   by  jms                    */
/*                                   01/25/88   by  jms                    */
/*                                   02/02/88   by: jms  CSR 24912         */
/* REVISION: 4.0      LAST MODIFIED: 02/26/88   by: jms                    */
/*                                   02/29/88   by: wug *A175*             */
/*                                   03/11/88   by: jms                    */
/*                                   03/24/88   by: wug *A187*             */
/*                                   04/11/88   by: jms                    */
/*                                   06/13/88   by: jms *A274* (no-undo)   */
/*                                   07/29/88   by: jms *A373*             */
/*                                   08/23/88   by: jms *A402*             */
/*                                   08/31/88   by: rl  *C028*             */
/*                                   11/08/88   by: jms *A526*             */
/* REVISION: 5.0      LAST MODIFIED: 04/24/89   by: jms *B066*             */
/*                                   05/16/89   by: mlb *B118*             */
/*                                   06/15/89   by: jms *B148*             */
/*                                   06/16/89   by: jms *B154*             */
/*                                   09/27/89   by: jms *B135*             */
/*                                   10/25/89   by: jms *B358*             */
/*                                   11/21/89   by: jms *B400*             */
/*                                   02/14/90   by: jms *B499*             */
/*                                   06/08/90   by: jms *B704*             */
/*                                   06/27/90   by: jms *B721*             */
/* REVISION: 6.0      LAST MODIFIED: 10/09/90   by: jms *D034*             */
/*                                   11/07/90   by: jms *D189*             */
/*                                   11/30/90   by: jms *D251*             */
/*                                   01/22/91   by: jms *D330*             */
/*                                   04/04/91   by: jms *D493*             */
/*                                   05/03/91   by: jms *D612*             */
/*                                   07/23/91   by: jms *D791*             */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   by: jms *F058*             */
/*                                   01/31/92   by: jms *F119*             */
/*                                   02/26/92   by: jms *F231*             */
/*                                   06/29/92   by: jms *F714*             */
/* REVISION: 7.3      LAST MODIFIED: 08/26/92   by: mpp *G030*             */
/*                                   09/14/92   by: jms *F890*             */
/*                                   11/08/94   by: srk *GO05*             */
/*                                   05/30/95   by: wjk *F0SH*             */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   BY: ays  *K0TV*            */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane       */
/* REVISION: 8.6E     LAST MODIFIED: 03/24/98   BY: *J241* Jagdish Suvarna */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   by: LN/SVA *L00M*          */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01W* Brenda Milton   */
/* REVISION: 8.6E     LAST MODIFIED: 08/06/98   BY: *L05G* Brenda Milton   */
/* REVISION: 9.1      LAST MODIFIED: 09/10/99   BY: *N02V* Arul Victoria   */
/* REVISION: 9.1      LAST MODIFIED: 09/27/99   BY: *M0F1* Annasaheb Rahane*/
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown      */
/* REVISION: 9.1      LAST MODIFIED: 09/01/00   BY: *N0QH* Mudit Mehta     */
/* REVISION: 9.1      LAST MODIFIED: 10/30/00   BY: *N0T4* Jyoti Thatte    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.18 $    BY: Jean Miller           DATE: 04/25/02  ECO: *P06H*  */
/* $Revision: 1.18 $    BY: Bill Jiang           DATE: 09/12/05  ECO: *SS - 20050912*  */

/* SS - 091214.1  By: Roger Xiao */  /*add percentage format */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20050912 - B */
{a6glcbsrp.i}
/* SS - 20050912 - E */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{wbrp02.i}

define new shared variable i         as integer no-undo.
define new shared variable ac_recno  as recid no-undo.
define new shared variable fmbgflag  like mfc_logical no-undo.
define new shared variable fm_recno  as recid no-undo.
define new shared variable cur_level as integer no-undo.
define new shared variable xacc      like ac_code no-undo.
define new shared variable tot       as decimal extent 100 no-undo.
define new shared variable tot1      like tot no-undo.
define new shared variable totflag   like mfc_logical extent 100 no-undo.
define new shared variable et_tot    like tot.
define new shared variable et_tot1   like tot1.

define shared variable glname      like en_name no-undo.
define shared variable rptdt       like gltr_eff_dt extent 2 no-undo.
define shared variable sub         like sb_sub no-undo.
define shared variable sub1        like sb_sub no-undo.
define shared variable ctr         like cc_ctr no-undo.
define shared variable ctr1        like cc_ctr no-undo.
define shared variable level       as integer format ">9"
                                   label "Level" no-undo.
define shared variable varflag     like mfc_logical
                                   label "Print Variances" no-undo.
define shared variable budgflag    like mfc_logical extent 2 no-undo.
define shared variable zeroflag    like mfc_logical
                                   label "Suppress Zero Amounts" no-undo.
define shared variable ccflag      like mfc_logical
                                   label "Summarize Cost Centers" no-undo.
define shared variable subflag     like mfc_logical
                                   label "Summarize Sub-Accounts" no-undo.
define shared variable prtflag     like mfc_logical initial yes
                                   label "Suppress Account Numbers" no-undo.
define shared variable peryr       as character format "x(8)" no-undo.
define shared variable per_end     like glc_per extent 2 no-undo.
define shared variable fiscal_yr   as integer extent 2 no-undo.
define shared variable yr_beg      as date extent 2 no-undo.
define shared variable per_beg     like glc_per extent 2 no-undo.
define shared variable yr_end      as date extent 2 no-undo.
define shared variable pl          like co_pl no-undo.
define shared variable ret         like co_pl no-undo.
define shared variable pl_amt      as decimal extent 2 no-undo.
define shared variable balance     as decimal extent 2 no-undo.
define shared variable balance1    like balance extent 2 no-undo.
define shared variable et_balance  like balance.
define shared variable et_balance1 like balance1.
define shared variable entity      like en_entity no-undo.
define shared variable entity1     like en_entity no-undo.
define shared variable cname       like glname no-undo.
define shared variable hdrstring   as character format "x(14)" no-undo.
define shared variable hdrstring1  like hdrstring no-undo.
define shared variable rpt_curr    like gltr_curr no-undo.
define shared variable budgetcode  like bg_code extent 2 no-undo.
define shared variable prt1000     like mfc_logical no-undo
                                   label "Round to Nearest Thousand".
define shared variable roundcnts   like mfc_logical no-undo
                                   label "Round to Nearest Whole Unit".
define shared variable prtfmt      as character format "x(30)" no-undo.
define shared variable vprtfmt     as character format "x(30)" no-undo.
define shared variable per_end_dt  as date extent 2 no-undo.
define shared variable per_end_dt1 as date extent 2 no-undo.

define variable crtot       like balance1 extent 2 no-undo.
define variable skpflag     like mfc_logical no-undo.
define variable variance    as decimal no-undo.
define variable record      as recid extent 100 no-undo.
define variable fpos        like fm_fpos no-undo.
define variable oldacc      like ac_code no-undo.
define variable knt         as integer no-undo.
define variable roundamt    as decimal extent 2 no-undo.
define variable rounderr    as decimal format "(>>>,>>>,>>>,>>9)"
                            extent 2 no-undo.
define variable roundmsg    as character format "x(30)" no-undo.
define variable roundflag   like mfc_logical no-undo.
define variable account     as character format "x(22)" no-undo.
define variable xsub        like sb_sub no-undo.
define variable xcc         like cc_ctr no-undo.
define variable dt          as date no-undo.
define variable dt1         as date no-undo.
define variable xper        like glc_per no-undo.
define variable varpct      as decimal no-undo.
define variable pctchar     as character no-undo.
define variable fmbgrecid   as recid no-undo.
define variable prtcol      like mfc_logical extent 2 no-undo.
define variable et_roundamt like roundamt.
define variable et_crtot    like crtot.

{etvar.i}   /* common euro variables */
{etrpvar.i} /* common euro report variables */

/* CYCLE THROUGH FORMAT POSITION FILE */
assign
   roundmsg  = getTermLabel("DISCREPANCY_DUE_TO_ROUNDING",30)
   roundflag = no
   cur_level = 1.

for first fm_mstr
   fields (fm_desc fm_dr_cr fm_fpos fm_header fm_page_brk
           fm_skip fm_sums_into fm_total fm_type fm_underln)
   use-index fm_fpos
   where fm_type = "B"
     and fm_sums_into = 0 no-lock:
end.

loopa:
repeat:

   if not available fm_mstr then do:
      repeat:
         assign cur_level = cur_level - 1.
         if cur_level < 1 then leave.

         for first fm_mstr
            fields (fm_desc fm_dr_cr fm_fpos fm_header fm_page_brk
                    fm_skip fm_sums_into fm_total fm_type fm_underln)
            where recid(fm_mstr) = record[cur_level] no-lock:
         end.
         assign
            fm_recno = recid(fm_mstr)
            fpos = fm_sums_into.

         /* SS - 20050912 - B */
         /*
         {gprun.i ""glcbsrpb.p""}
             */
             {gprun.i ""a6glcbsrpb.p""}
             /* SS - 20050912 - B */
         if keyfunction(lastkey) = "end-error" then
            undo, leave loopa.

         if fmbgflag and budgflag[1] then do:
            {glfmbg.i &fpos=fm_fpos &yr=fiscal_yr[1] &per=per_beg[1]
                      &per1=per_end[1] &budget=balance[1]
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

            if prt1000 then
               assign balance[1] = round(balance[1] / 1000, 0).
            else
            if roundcnts then
               assign balance[1] = round(balance[1], 0).
            if prt1000 then
               et_balance[1] = round(et_balance[1] / 1000, 0).
            else
            if roundcnts then
               et_balance[1] = round(et_balance[1], 0).
            assign
               tot[cur_level]    = balance[1]
               et_tot[cur_level] = et_balance[1].
         end.

         if fmbgflag and budgflag[2] then do:
            {glfmbg.i &fpos=fm_fpos &yr=fiscal_yr[2] &per=per_beg[2]
                      &per1=per_end[2] &budget=balance[2]
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
            if prt1000 then
               assign balance[2] = round(balance[2] / 1000, 0).
            else
            if roundcnts then
               assign balance[2] = round(balance[2], 0).
            if prt1000 then
               et_balance[2] = round(et_balance[2] / 1000, 0).
            else
            if roundcnts then
               et_balance[2] = round(et_balance[2], 0).
            assign
               tot1[cur_level]    = balance[2]
               et_tot1[cur_level] = et_balance[2].
         end.

         if cur_level > 1 then
            assign
               tot[cur_level - 1]     = tot[cur_level - 1] + tot[cur_level]
               tot1[cur_level - 1]    = tot1[cur_level - 1]
                                      + tot1[cur_level]
               et_tot[cur_level - 1]  = et_tot[cur_level - 1]
                                      + et_tot[cur_level]
               et_tot1[cur_level - 1] = et_tot1[cur_level - 1]
                                      + et_tot1[cur_level].
         else do:
            if not roundflag then
               assign
                  roundamt[1]    = tot[cur_level]
                  roundamt[2]    = tot1[cur_level]
                  et_roundamt[1] = et_tot[cur_level]
                  et_roundamt[2] = et_tot1[cur_level]
                  roundflag      = yes.
            else do:
               assign
                  rounderr[1] = et_roundamt[1] + et_tot[cur_level]
                  rounderr[2] = et_roundamt[2] + et_tot1[cur_level].

               if rounderr[1] <> 0 or rounderr[2] <> 0 then do:
                   /* SS - 20050912 - B */
                   /*
                  if (rounderr[1] >= -10 and rounderr[1] <= 10 and
                      rounderr[1] <> 0) or
                     (rounderr[2] >= -10 and rounderr[2] <= 10 and
                      rounderr[2] <> 0)
                  then
                     put roundmsg at 4.

                  if rounderr[1] <> 0 and rounderr[1] >= -10 and
                     rounderr[1] <= 10
                  then
                     put rounderr[1] to 79.

                  if rounderr[2] <> 0 and rounderr[2] >= -10 and
                     rounderr[2] <= 10
                  then
                     put rounderr[2] to 100.
                  */
                  /* SS - 20050912 - E */

                  if (rounderr[1] >= -10 and rounderr[1] <= 10) then
                     assign
                        tot[cur_level]    = - roundamt[1]
                        et_tot[cur_level] = et_tot[cur_level] - rounderr[1].

                  if (rounderr[2] >= -10 and rounderr[2] <= 10) then
                     assign
                        tot1[cur_level] = - roundamt[2]
                        et_tot1[cur_level] = et_tot1[cur_level] - rounderr[2].
               end.
            end.
         end.

         if level >= cur_level then do:
            if fm_total = no or level = cur_level then do:
               do i = 1 to 2:
                  prtcol[i] = yes.
                  if fmbgflag and fmbgrecid <> recid(fm_mstr) and
                     budgflag[i]
                  then
                     prtcol[i] = no.
               end.
               /* SS - 20050912 - B */
               /*
               if totflag[cur_level] then do:

                  if prtcol[1] then put "--------------------" to 79.
                  if prtcol[2] then put "--------------------" to 100.

                  if prtcol[1] and prtcol[2] and varflag then
                     put "-------------------" to 120
                         "--------" to 130.

                  if prtcol[1] or prtcol[2] then
                     put {gplblfmt.i
                            &FUNC=caps(getTermLabel(""TOTAL"",8))
                            &CONCAT = "' '"
                         } at min(19, cur_level * 2 - 1)

                         fm_desc.
               end.
               else
               if fm_header then
                  put fm_desc at min(19, cur_level * 2 - 1 ).
               */
               /* SS - 20050912 - E */

               if fm_dr_cr = false then
                  assign
                     crtot[1]    = - tot[cur_level]
                     crtot[2]    = - tot1[cur_level]
                     et_crtot[1] = - et_tot[cur_level]
                     et_crtot[2] = - et_tot1[cur_level]
                     variance    = et_crtot[2] - et_crtot[1].
               else
                  assign
                     crtot[1]    = tot[cur_level]
                     crtot[2]    = tot1[cur_level]
                     et_crtot[1] = et_tot[cur_level]
                     et_crtot[2] = et_tot1[cur_level]
                     variance    = et_crtot[1] - et_crtot[2].
               if et_crtot[2] <> 0 then
                  assign
                     varpct = (variance / et_crtot[2]) * 100
/* SS - 091214.1 - B 
                  pctchar = string(varpct, "->>>9.9%").
   SS - 091214.1 - E */
/* SS - 091214.1 - B */
                  pctchar = string(varpct, "->>>>>9.9%").
/* SS - 091214.1 - E */

               else
                  pctchar = "     **".

                  /* SS - 20050912 - B */
                  /*
               if prtcol[1] then
                  put string(et_crtot[1], prtfmt) format "x(20)" to 79.
               if prtcol[2] then
                  put string(et_crtot[2], prtfmt) format "x(20)" to 100.
               if prtcol[1] and prtcol[2] and varflag then
                  put string(variance, vprtfmt) format "x(20)" to 120
                      pctchar to 130.
               */
               /* SS - 20050912 - E */

               if cur_level = 1 and et_show_diff
                  and not prt1000
                  and not roundcnts
               then do:

                  if et_report_curr <> rpt_curr then do:
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input rpt_curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input crtot[1],
                          input true,    /* ROUND */
                          output crtot[1],
                          output mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input rpt_curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input crtot[2],
                          input true,    /* ROUND */
                          output crtot[2],
                          output mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.
                  end.  /* if et_report_curr <> rpt_curr */

                  /* SS - 20050912 - B */
                  /*
                  if ((et_crtot[1] <> crtot[1]) and prtcol[1]) or
                     ((et_crtot[2] <> crtot[2]) and prtcol[2])
                  then do:
                     put et_diff_txt at min(19, cur_level * 2 - 1).

                     if prtcol[1] then
                     put
                        string((et_crtot[1] - crtot[1]), prtfmt)
                        format "x(20)" to 79.

                     if prtcol[2] then
                     put
                        string((et_crtot[2] - crtot[2]), prtfmt)
                        format "x(20)" to 100.

                     put {gplblfmt.i
                            &FUNC=caps(getTermLabel(""TOTAL"",8))
                            &CONCAT = "' '"
                         } at min(19, cur_level * 2 - 1)

                        string(fm_desc + " (" +
                        getTermLabel("ROUNDED",8) + ") ") format "x(34)".

                     if prtcol[1] then
                        put
                           string(crtot[1], prtfmt) format "x(20)" to 79.

                     if prtcol[2] then
                        put
                           string(crtot[2], prtfmt) format "x(20)" to 100.

                  end.
                  */
                  /* SS - 20050912 - E */
               end.

               /* SS - 20050912 - B */
               /*
               if fm_underln then do:

                  if prtcol[1] then put "====================" to 79.
                  if prtcol[2] then put "====================" to 100.
                  if prtcol[1] and prtcol[2] and varflag then
                     put "====================" to 120
                         "========" to 130.

               end.

               if (prtcol[1] or prtcol[2]) and
                  totflag[cur_level] and fm_skip
               then put skip(1).
               */
               /* SS - 20050912 - E */
            end.
            /* SS - 20050912 - B */
            /*
            if fm_page_brk then page.
            */
            /* SS - 20050912 - E */
            if cur_level > 1 then assign totflag[cur_level - 1] = yes.
         end.

         if fmbgrecid = recid(fm_mstr) then assign fmbgflag = no.
         find next fm_mstr use-index fm_fpos
            where fm_type = "B"
              and fm_sums_into = fpos no-lock no-error.
         if available fm_mstr then leave.

      end.
   end.
   if cur_level < 1 then leave.

   /* SS - 20050912 - B */
   /*
   if fm_header = no and level >= cur_level then
      put fm_desc at min(19, cur_level * 2 - 1).
   */
   /* SS - 20050912 - E */

   if budgflag[1] and
      can-find (first bg_mstr where bg_code = budgetcode[1] and
                                    bg_entity >= entity and
                                    bg_entity <= entity1 and
                                    bg_acc = "" and bg_cc = "" and
                                    bg_fpos = fm_fpos and
                                    bg_project = "")
   then
      assign
         fmbgflag = yes
         fmbgrecid = recid(fm_mstr).
   else
   if budgflag[2] and
      can-find (first bg_mstr where bg_code = budgetcode[2] and
                                    bg_entity >= entity and
                                    bg_entity <= entity1 and
                                    bg_acc = "" and bg_cc = "" and
                                    bg_fpos = fm_fpos and
                                    bg_project = "")
   then
      assign
         fmbgflag = yes
         fmbgrecid = recid(fm_mstr).

   assign
      record[cur_level]  = recid(fm_mstr)
      tot[cur_level]     = 0
      totflag[cur_level] = no
      tot1[cur_level]    = 0
      et_tot[cur_level]  = 0
      et_tot1[cur_level] = 0
      fpos               = fm_fpos.

   for first fm_mstr
      fields (fm_desc fm_dr_cr fm_fpos fm_header fm_page_brk
              fm_skip fm_sums_into fm_total fm_type fm_underln)
      use-index fm_fpos
      where fm_sums_into = fpos
        and fm_type = "B" no-lock:
   end.
   if available fm_mstr and cur_level < 100 then do:
      assign cur_level = cur_level + 1.
   end.
   else do:

      for first fm_mstr
         fields (fm_desc fm_dr_cr fm_fpos fm_header fm_page_brk
                 fm_skip fm_sums_into fm_total fm_type fm_underln)
         where recid(fm_mstr) = record[cur_level] no-lock:
      end.
      assign
         fm_recno = recid(fm_mstr)
         fpos = fm_sums_into.

      /* SS - 20050912 - B */
      /*
      {gprun.i ""glcbsrpb.p""}
          */
      {gprun.i ""a6glcbsrpb.p""}
          /* SS - 20050912 - E */
      if keyfunction(lastkey) = "end-error" then
         undo, leave loopa.

      if fmbgflag and budgflag[1] then do:
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

         if prt1000 then
            assign balance[1] = round(balance[1] / 1000, 0).
         else
         if roundcnts then
            assign balance[1] = round(balance[1], 0).
         if prt1000 then
            et_balance[1] = round(et_balance[1] / 1000, 0).
         else
         if roundcnts then
            et_balance[1] = round(et_balance[1], 0).
         assign
            tot[cur_level]    = balance[1]
            et_tot[cur_level] = et_balance[1].
      end.
      if fmbgflag and budgflag[2] then do:
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

         if prt1000 then
            assign balance[2] = round(balance[2] / 1000, 0).
         else
         if roundcnts then
            assign balance[2] = round(balance[2], 0).
         if prt1000 then
            et_balance[2] = round(et_balance[2] / 1000, 0).
         else
         if roundcnts then
            et_balance[2] = round(et_balance[2], 0).
         assign
            tot1[cur_level]    = balance[2]
            et_tot1[cur_level] = et_balance[2].
      end.

      if cur_level > 1 then
         assign
            tot[cur_level - 1]     = tot[cur_level - 1]  + tot[cur_level]
            tot1[cur_level - 1]    = tot1[cur_level - 1] + tot1[cur_level]
            et_tot[cur_level - 1]  = et_tot[cur_level - 1]
                                   + et_tot[cur_level]
            et_tot1[cur_level - 1] = et_tot1[cur_level - 1]
                                   + et_tot1[cur_level].
      else do:
         if not roundflag then
            assign
               roundamt[1]    = tot[cur_level]
               roundamt[2]    = tot1[cur_level]
               et_roundamt[1] = et_tot[cur_level]
               et_roundamt[2] = et_tot1[cur_level]
               roundflag      = yes.
         else do:
            assign
               rounderr[1] = et_roundamt[1] + et_tot[cur_level]
               rounderr[2] = et_roundamt[2] + et_tot1[cur_level].
            if rounderr[1] <> 0 or rounderr[2] <> 0 then do:
                /* SS - 20050912 - B */
                /*
               if (rounderr[1] >= -10 and rounderr[1] <= 10 and
                   rounderr[1] <> 0) or
                  (rounderr[2] >= -10 and rounderr[2] <= 10 and
                   rounderr[2] <> 0)
               then
                  put roundmsg at 4.

               if rounderr[1] <> 0 and rounderr[1] >= -10 and
                  rounderr[1] <= 10
               then put rounderr[1] to 79.

               if rounderr[2] <> 0 and rounderr[2] >= -10 and
                  rounderr[2] <= 10
               then put rounderr[2] to 100.
               */
               /* SS - 20050912 - E */

               if (rounderr[1] >= -10 and rounderr[1] <= 10) then
                  assign
                     tot[cur_level] = - roundamt[1]
                     et_tot[cur_level] = et_tot[cur_level] - rounderr[1].
               if (rounderr[2] >= -10 and rounderr[2] <= 10) then
                  assign
                     tot1[cur_level] = - roundamt[2]
                     et_tot1[cur_level] = et_tot1[cur_level] - rounderr[2].
            end.
         end.
      end.

      if level >= cur_level then do:
         if fm_total = no or level = cur_level then do:
            do i = 1 to 2:
               assign prtcol[i] = yes.
               if fmbgflag and fmbgrecid <> recid(fm_mstr) and
                  budgflag[i]
               then assign prtcol[i] = no.
            end.
            /* SS - 20050912 - B */
            /*
            if totflag[cur_level] then do:

               if prtcol[1] then put "--------------------" to 79.
               if prtcol[2] then put "--------------------" to 100.
               if prtcol[1] and prtcol[2] and varflag then
                  put "-------------------" to 120
                      "--------" to 130.

               if prtcol[1] or prtcol[2] then
                  put {gplblfmt.i
                         &FUNC=caps(getTermLabel(""TOTAL"",8))
                         &CONCAT = "' '"
                      } at min(19, cur_level * 2 - 1)
                      fm_desc.
            end.
            else
            if fm_header then
               put fm_desc at min(19, cur_level * 2 - 1 ).
            */
            /* SS - 20050912 - E */

            if fm_dr_cr = false then
               assign
                  crtot[1]    = - tot[cur_level]
                  crtot[2]    = - tot1[cur_level]
                  et_crtot[1] = - et_tot[cur_level]
                  et_crtot[2] = - et_tot1[cur_level]
                  variance    = et_crtot[2] - et_crtot[1].
            else
               assign
                  crtot[1]    = tot[cur_level]
                  crtot[2]    = tot1[cur_level]
                  et_crtot[1] = et_tot[cur_level]
                  et_crtot[2] = et_tot1[cur_level]
                  variance    = et_crtot[1] - et_crtot[2].
            if et_crtot[2] <> 0 then
               assign
                  varpct = (variance / et_crtot[2]) * 100
/* SS - 091214.1 - B 
                  pctchar = string(varpct, "->>>9.9%").
   SS - 091214.1 - E */
/* SS - 091214.1 - B */
                  pctchar = string(varpct, "->>>>>9.9%").
/* SS - 091214.1 - E */
            else
               pctchar = "     **".

               /* SS - 20050912 - B */
               /*
            if prtcol[1] then
               put string(et_crtot[1], prtfmt) format "x(20)" to 79.

            if prtcol[2] then
               put string(et_crtot[2], prtfmt) format "x(20)" to 100.

            if prtcol[1] and prtcol[2] and varflag then
               put string(variance, vprtfmt) format "x(20)" to 120
                   pctchar to 130.
            */
            /* SS - 20050912 - E */

            if cur_level = 1 and et_show_diff
               and not prt1000
               and not roundcnts
            then do:

               if et_report_curr <> rpt_curr then do:
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input rpt_curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input crtot[1],
                       input true,    /* ROUND */
                       output crtot[1],
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input rpt_curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input crtot[2],
                       input true,    /* ROUND */
                       output crtot[2],
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.
               end.  /* if et_report_curr <> rpt_curr */

               /* SS - 20050912 - B */
               /*
               if ((et_crtot[1] <> crtot[1]) and prtcol[1]) or
                  ((et_crtot[2] <> crtot[2]) and prtcol[2])
               then do:
                  put et_diff_txt at min(19, cur_level * 2 - 1).
                  if prtcol[1] then
                     put
                        string((et_crtot[1] - crtot[1]), prtfmt)
                        format "x(20)" to 79.

                  if prtcol[2] then
                     put
                        string((et_crtot[2] - crtot[2]), prtfmt)
                        format "x(20)" to 100.

                  put {gplblfmt.i
                         &FUNC=caps(getTermLabel(""TOTAL"",8))
                         &CONCAT = "' '"
                      } at min(19, cur_level * 2 - 1)

                      string(fm_desc + " (" +
                      getTermLabel("ROUNDED",8) + ") ") format "x(34)".
                  if prtcol[1] then
                     put string(crtot[1], prtfmt) format "x(20)" to 79.

                  if prtcol[2] then
                     put string(crtot[2], prtfmt) format "x(20)" to 100.

               end.
               */
               /* SS - 20050912 - E */
            end.

            /* SS - 20050912 - B */
            /*
            if fm_underln then do:

               if prtcol[1] then put "====================" to 79.
               if prtcol[2] then put "====================" to 100.
               if prtcol[1] and prtcol[2] and varflag then
                  put "====================" to 120
                      "========" to 130.

            end.

            if (prtcol[1] or prtcol[2]) and
               totflag[cur_level] and fm_skip
            then put skip(1).
            */
            /* SS - 20050912 - E */
         end.
         /* SS - 20050912 - B */
         /*
         if fm_page_brk then page.
         */
         /* SS - 20050912 - E */
         if cur_level > 1 then assign totflag[cur_level - 1] = yes.
      end.

      if fmbgrecid = recid(fm_mstr) then assign fmbgflag = no.
      find next fm_mstr use-index fm_fpos
         where fm_sums_into = fpos
           and fm_type = "B" no-lock no-error.
   end.

   {mfrpchk.i}
end.
{wbrp04.i}
