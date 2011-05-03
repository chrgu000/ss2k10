/* gl4inrpb.p - GENERAL LEDGER 4-COLUMN INCOME STATEMENT (PART III)     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*K0S5*/
/*V8:ConvertMode=Report                                        */
/* REVISION: 4.0      LAST MODIFIED: 06/10/88   BY: JMS   **A275**      */
/*                                   09/23/88   by: jms   **A454**      */
/*                                   10/10/88   by: jms   **A477**      */
/*                                   11/08/88   by: jms   **A526**      */
/* REVISION: 5.0      LAST MODIFIED: 05/17/89   by: jms   **B066**      */
/*                                   06/19/89   by: jms   **B154**      */
/*                                   09/27/89   by: jms   **B135**      */
/*                                   10/08/89   by: jms   **A789**      */
/*                                   11/21/89   by: jms   **B400**      */
/*                                   02/14/90   by: jms   **B499**      */
/*                            (split into glinrp1a.p and glinrp1b.p)    */
/* REVISION: 6.0      LAST MODIFIED: 09/18/90   by: jms   **D034**      */
/*                                   11/07/90   by: jms   **D189**      */
/*                                   02/07/91   by: jms   **D330**      */
/*                                   04/04/91   by: jms   **D491**      */
/*                                   04/04/91   by: jms   **D493**      */
/*                                   07/23/91   by: jms   **D791**      */
/* REVISION: 7.0      LAST MODIFIED: 11/12/91   by: jms   **F058**      */
/*                                   02/26/92   by: jms   **F231**      */
/* REVISION: 7.3      LAST MODIFIED: 08/18/92   by: mpp   **G030** major*/
/*                                   09/15/92   by: jms   **F890**      */
/*                                   02/21/94   by: srk   **FM29**      */
/*                                   12/29/95   by: mys   **G1HP**      */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   by: ays   **K0S5**      */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* Revision: 8.6E          MODIFIED: 03/12/98   By: *J23W* Sachin Shah  */
/* Revision: 8.6E          MODIFIED: 10/04/98   By: *J314* Alfred Tan   */
/* Revision: 9.0           MODIFIED: 02/08/00   BY: *J3P3* Ranjit Jain  */
/* Revision: 9.1           MODIFIED: 08/14/00   BY: *N0L1* Mark Brown   */
/* REVISION: 9.1      LAST MODIFIED: 08/31/00   BY: *N0QF* Mudit Mehta  */
/* REVISION: 9.1      LAST MODIFIED: 09/13/05   BY: *SS - 20050913* Bill Jiang  */
/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO
 WHEREVER MISSING FOR PERFORMANCE AND SMALLER R-CODE */

         {mfdeclre.i}
/*N0QF*/ {gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE gl4inrpb_p_1 "Summarize Cost Centers"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl4inrpb_p_2 "Summarize Sub-Accounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl4inrpb_p_3 "Suppress Zero Amounts"
/* MaxLen: Comment: */

/*N0QF*
 * &SCOPED-DEFINE gl4inrpb_p_4 "TOTAL "
 * /* MaxLen: Comment: */
 *N0QF*/

&SCOPED-DEFINE gl4inrpb_p_5 "Round to Nearest Thousand"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl4inrpb_p_6 "Level"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*K0S5*/ {wbrp02.i}

/*J23W* no-undo added ** BEGIN */
      define shared variable glname     like en_name no-undo.
      define shared variable begdt      as date extent 4 no-undo.
      define shared variable enddt      as date extent 4 no-undo.
      define shared variable budget     like mfc_logical extent 4 no-undo.
      define shared variable zeroflag   like mfc_logical
                        label {&gl4inrpb_p_3} no-undo.
/*F058*/  define shared variable sub        like sb_sub no-undo.
/*F058*/  define shared variable sub1       like sb_sub no-undo.
/*F058*/  define shared variable ctr        like cc_ctr no-undo.
/*F058*/  define shared variable ctr1       like cc_ctr no-undo.
      define shared variable level      as integer format ">9" initial 99
                        label {&gl4inrpb_p_6} no-undo.
      define shared variable ccflag     like mfc_logical
                        label {&gl4inrpb_p_1} no-undo.
/*F058*/  define shared variable subflag    like mfc_logical
                        label {&gl4inrpb_p_2} no-undo.
      define shared variable entity     like en_entity no-undo.
      define shared variable entity1    like en_entity no-undo.
      define shared variable cname      like glname no-undo.
      define shared variable fiscal_yr  like glc_year extent 4 no-undo.
      define shared variable per_beg    like glc_per extent 4 no-undo.
      define shared variable per_end    like glc_per extent 4 no-undo.
      define shared variable yr_end     as date extent 4 no-undo.
      define shared variable ret        like ac_code no-undo.
      define shared variable income     as decimal extent 4 no-undo.
      define shared variable rpt_curr   like gltr_curr no-undo.
      define shared variable budgetcode like bg_code extent 4 no-undo.
      define shared variable prt1000    like mfc_logical
                        label {&gl4inrpb_p_5} no-undo.
      define shared variable labelname  as character format "x(8)"
                        extent 4 no-undo.

      define new shared variable balance   as decimal
                           format "(>>>,>>>,>>>,>>9)"
                           extent 4 no-undo.
/*J3P3**  define new shared variable fmbgflag  like mfc_logical no-undo.  */
/*J3P3*/  define new shared variable fmbgflag  like mfc_logical extent 4
/*J3P3*/                                                        no-undo.
          define new shared variable ac_recno  as recid no-undo.
          define new shared variable fm_recno  as recid no-undo.
/*F058*/  define new shared variable xacc      like ac_code no-undo.
/*F058*/  define new shared variable cur_level as integer no-undo.
/*J23W* no-undo added ** END */
/*F058*/  define new shared variable totflag   like mfc_logical
                           extent 100 no-undo.
/*F058*/  define new shared variable tot1      as decimal
                           format "(>>>,>>>,>>>,>>9)"
                           extent 100 no-undo.
/*F058*/  define new shared variable tot2      like tot1 no-undo.
/*F058*/  define new shared variable tot3      like tot1 no-undo.
/*F058*/  define new shared variable tot4      like tot1 no-undo.

      define variable record     as recid extent 100 no-undo.
      define variable balance1   like balance no-undo.
      define variable cramt      as decimal
                     format "(>>>,>>>,>>>,>>9)" no-undo.
      define variable pct        as decimal format "->>>>%" no-undo.
      define variable fpos       like fm_fpos no-undo.
      define variable i          as integer no-undo.
      define variable desc1      like ac_desc no-undo.
/*J23W* no-undo added ** BEGIN */
      define variable knt        as integer no-undo.
      DEFINE VARIABLE sum_lev    as integer no-undo.
      DEFINE VARIABLE sort_type  as integer no-undo.
/*F890*/  define variable fmbgrecid  as recid no-undo.
/*F890*/  define variable prtcol     like mfc_logical extent 4 no-undo.
/*J23W* no-undo added ** END */

      /*determine level of summarization, sum_lev*/
      IF ccflag AND subflag THEN
        assign sum_lev=2.
      ELSE IF ccflag OR subflag THEN
        assign sum_lev=1.
      ELSE
        assign sum_lev=0.

      /* CYCLE THROUGH FORMAT POSITION FILE */
/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE */
      assign
         cur_level = 1
/*F890*/ fmbgflag = no.
/*J23W* END OF GROUPING FIELD ASSIGNMENTS */


/*J23W**   find first fm_mstr use-index fm_fpos where fm_type = "I" **/
/*J23W**      and fm_sums_into = 0 no-lock no-error. **/

/*J23W* BEGIN ADD */
          for first fm_mstr
             fields (fm_cc_sort fm_desc fm_dr_cr fm_fpos
             fm_header fm_page_brk fm_skip fm_sub_sort
             fm_sums_into fm_total fm_type fm_underln )
             use-index fm_fpos no-lock where fm_type = "I"
             and fm_sums_into = 0: end.
/*J23W* END ADD */

      loopb:
          repeat:

         if not available fm_mstr then do:
        repeat:
           assign cur_level = cur_level - 1.
           if cur_level < 1 then leave.

/*J23W**    find fm_mstr where recid(fm_mstr) = record[cur_level] **/
/*J23W**           no-lock no-error. **/

/*J23W* BEGIN ADD */
           for first fm_mstr
             fields (fm_cc_sort fm_desc fm_dr_cr fm_fpos
             fm_header fm_page_brk fm_skip fm_sub_sort
             fm_sums_into fm_total fm_type fm_underln )
                     no-lock where recid(fm_mstr) = record[cur_level]: end.
/*J23W* END ADD */

/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE */
       assign
           fpos = fm_sums_into
           fm_recno = recid(fm_mstr).
/*J23W* END OF GROUPING FIELD ASSIGNMENTS */

/*F890*/ /*        fmbgflag = no.
*           if budget[1] or budget[2] or budget[3] or budget[4] then do:
*             find first bg_mstr where (bg_code = budgetcode[1] or
*                           bg_code = budgetcode[2] or
*                           bg_code = budgetcode[3] or
*                           bg_code = budgetcode[4]) and
/*F058*/                                       bg_fpos = fm_fpos and
*                           bg_entity >= entity and
*                           bg_entity <= entity1
/*F058*/                                       no-lock use-index bg_ind1
*                           no-error.
*              if available bg_mstr then fmbgflag = yes.
/*F890*/           end.    */

           /*determine sort_type*/
           IF fm_sub_sort AND NOT(subflag) THEN DO:
              IF fm_cc_sort AND NOT(ccflag) THEN
            assign sort_type=3.
              ELSE
            assign sort_type = 1.
              END.
           ELSE IF NOT(ccflag) THEN DO:
              IF fm_cc_sort THEN
            assign sort_type = 2.
              ELSE IF subflag THEN
            assign sort_type=4.
              ELSE
            assign sort_type=0.
              END.
           ELSE
            assign sort_type=0.
                /*sort type=0=asc*/
           IF sort_type=0 THEN DO:
              {gprun.i ""gl4inrb0.p"" "(sum_lev, sort_type)"}
           END.
                /*sort type=1=sac*/
           ELSE IF sort_type=1 THEN DO:
              {gprun.i ""gl4inrb1.p"" "(sum_lev, sort_type)"}
           END.
                /*sort type=2=cas*/
           ELSE IF sort_type=2 THEN DO:
              {gprun.i ""gl4inrb2.p"" "(sum_lev, sort_type)"}
           END.
                /*sort type=3=sca*/
           ELSE IF sort_type=3 THEN DO:
              {gprun.i ""gl4inrb3.p"" "(sum_lev, sort_type)"}
           END.
                /*sort type=4=acs*/
           ELSE DO:
              {gprun.i ""gl4inrb4.p"" "(sum_lev, sort_type)"}
           END.

           do i = 1 to 4:
/*J3P3**      if fmbgflag and budget[i] then do:  */
/*J3P3*/      if fmbgflag[i] and
/*J3P3*/           budget[i]
/*J3P3*/      then do:
/*F058*/         {glfmbg.i &fpos=fm_fpos &yr=fiscal_yr[i]
                 &per=per_beg[i] &per1=per_end[i] &budget=balance[i]
                 &bcode=budgetcode[i]}
/*FM29*
/*F890*/             if prt1000 then balance[i] = round(balance[i], 1000).
 *FM29*/
/*FM29*/         if prt1000 then assign balance[i] =
/*FM29*/            round(balance[i] / 1000 , 0).

/*F890*/ /*              if fm_dr_cr = false then do:
                assign balance1[i] = - balance[i].
                put balance1[i] at (34 + ((i - 1) * 25)).
             end.
/*F890*/                 else put balance[i] at (34 + ((i - 1 ) * 25)).  */

                 if      i = 1 then assign tot1[cur_level] = balance[i].
                 else if i = 2 then assign tot2[cur_level] = balance[i].
                 else if i = 3 then assign tot3[cur_level] = balance[i].
                 else  /*i = 4*/    assign tot4[cur_level] = balance[i].
              end. /* IF fmbgflag[i] AND budget[i] */
           end.

           if cur_level > 1 then do:
/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE */
           assign
              tot1[cur_level - 1] = tot1[cur_level - 1] +
             tot1[cur_level]
              tot2[cur_level - 1] = tot2[cur_level - 1] +
             tot2[cur_level]
              tot3[cur_level - 1] = tot3[cur_level - 1] +
             tot3[cur_level]
              tot4[cur_level - 1] = tot4[cur_level - 1] +
             tot4[cur_level].
/*J23W* END OF GROUPING FIELD ASSIGNMENTS */
           end.

           if level >= cur_level then do:
              if fm_total = no or level = cur_level then do:
/*F890*/                 do i = 1 to 4:
/*F890*/                    assign prtcol[i] = yes.
/*J3P3** /*F890*/           if fmbgflag and fmbgrecid <> recid(fm_mstr) and */
/*J3P3*/                    if fmbgflag[i]                 and
/*J3P3*/                       fmbgrecid <> recid(fm_mstr) and
/*F890*/                       budget[i] then assign prtcol[i] = no.
/*F890*/                 end.
/* SS - 20050913 - B */
/*
             if totflag[cur_level] then do:
                do i = 1 to 4:
/*F890*/                       if prtcol[i] then
                   put "-----------------" at (34 + ((i - 1) * 25))
                   "------" at (52 + ((i - 1) * 25)).
                end.
/*F890*/                    if prtcol[1] or prtcol[2] or prtcol[3] or
                   prtcol[4] then do:

/*N0QF* /*F231*/       assign desc1 = substring(({&gl4inrpb_p_4} + fm_desc), 1, 24). */
/*N0QF*/               assign desc1 = substring((caps(getTermLabel("TOTAL",5)) + " " + fm_desc), 1, 24).
                   put desc1 at min(9, ((cur_level - 1) * 2 + 1)).
/*F890*/                    end.
             end.
/*G1HP*/                 else if fm_header then
/*G1HP*/                    put fm_desc at min(9, ((cur_level - 1) * 2 + 1)).
*/
/* SS - 20050913 - E */

/* SS - 20050913 - B */
/*
             if fm_dr_cr = false then do:
                assign cramt = - tot1[cur_level]
                pct = 0.
                if income[1] <> 0 then
                   assign pct = cramt / income[1] * 100.
/*F890*/                    if prtcol[1] then put cramt at 34 pct at 52.
                   assign cramt = - tot2[cur_level]
                          pct = 0.
                if income[2] <> 0 then
                   assign pct = cramt / income[2] * 100.
/*F890*/                    if prtcol[2] then put cramt at 59 pct at 77.
                assign cramt = - tot3[cur_level]
                       pct = 0.
                if income[3] <> 0 then
                   assign pct = cramt / income[3] * 100.
/*F890*/                    if prtcol[3] then put cramt at 84 pct at 102.
                assign cramt = - tot4[cur_level]
                       pct = 0.
                if income[4] <> 0 then
                   assign pct = cramt / income[4] * 100.
/*F890*/                    if prtcol[4] then put cramt at 109 pct at 127.
             end.
             else do:
                assign pct = 0.
                if income[1] <> 0 then
                   assign pct = tot1[cur_level] / income[1] * 100.
/*F890*/                    if prtcol[1] then put tot1[cur_level] at 34
                   pct at 52.
                assign pct = 0.
                if income[2] <> 0 then
                   assign pct = tot2[cur_level] / income[2] * 100.
/*F890*/                    if prtcol[2] then put tot2[cur_level] at 59
                   pct at 77.
                assign pct = 0.
                if income[3] <> 0 then
                   assign pct = tot3[cur_level] / income[3] * 100.
/*F890*/                    if prtcol[3] then put tot3[cur_level] at 84
                   pct at 102.
                assign pct = 0.
                if income[4] <> 0 then
                   assign pct = tot4[cur_level] / income[4] * 100.
/*F890*/                    if prtcol[4] then put tot4[cur_level] at 109
                   pct at 127.
             end.
             if fm_underln then do i = 1 to 4:
/*F890*/                    if prtcol[i] then
                   put "=================" at (34 + ((i - 1) * 25))
                   "======" at (52 + ((i - 1) * 25)).
             end.
/*F890*/                 if (prtcol[1] or prtcol[2] or prtcol[3] or prtcol[4])
                and totflag[cur_level] and fm_skip then put skip(1).
*/
/* SS - 20050913 - E */
              end. /* if fm_total = no or level = cur_level then do: */
              /* SS - 20050913 - B */
              /*
              if fm_page_brk then page.
              */
              /* SS - 20050913 - E */
              if cur_level > 1 then
              assign totflag[cur_level - 1] = yes.

           end. /* if level >= cur_level then do: */

/*F890*/   if fmbgrecid = recid(fm_mstr) then assign fmbgflag = no.

           find next fm_mstr use-index fm_fpos where fm_type = "I"
              and fm_sums_into = fpos no-lock no-error.
           if available fm_mstr then leave.

        end.
         end.

         if cur_level < 1 then leave.

         /* SS - 20050913 - B */
         /*
         if fm_header = no and level >= cur_level then
        put fm_desc at min(9, ((cur_level - 1) * 2 + 1)).
         */
         /* SS - 20050913 - E */
/*F890*      else do:  */
/*F890*         if level = cur_level then put fm_desc at */
/*F890*            min(9,((cur_level - 1) * 2 + 1)).*/
/*F890*      end.*/

/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE */
         assign
         record[cur_level] = recid(fm_mstr)
         tot1[cur_level] = 0
         tot2[cur_level] = 0
         tot3[cur_level] = 0
         tot4[cur_level] = 0
         totflag[cur_level] = no.
/*J23W* END OF GROUPING FIELD ASSIGNMENTS */

/*J23W********** RESTRUCTURE FOR PERFORMANCE *** BEGIN DELETE***********
* /*F890*/   if budget[1] or budget[2] or budget[3] or budget[4] then do:
* /*F890*/      find first bg_mstr where (bg_code = budgetcode[1] or
* /*F890*/                               bg_code = budgetcode[2] or
* /*F890*/                               bg_code = budgetcode[3] or
* /*F890*/                               bg_code = budgetcode[4]) and
* /*F890*/                               bg_entity >= entity and
* /*F890*/                               bg_entity <= entity1 and
* /*F890*/                               bg_acc = "" and bg_cc = "" and
* /*F890*/                               bg_project = "" and
* /*F890*/                               bg_fpos = fm_fpos no-lock no-error.
* /*F890*/      if available bg_mstr then do:
*J23W************************* END DELETE *******************************/

/*J23W* BEGIN ADD */
             do i = 1 to 4:
                if budget[i] and
                   can-find (first bg_mstr where bg_code = budgetcode[i] and
                                       bg_entity >= entity and
                                       bg_entity <= entity1 and
                                       bg_acc = "" and bg_cc = "" and
                                       bg_project = "" and
                                       bg_fpos = fm_fpos )
/*J23W* END ADD */

/*J23W*/           then assign
/*J3P3** /*F890*/           fmbgflag = yes  */
/*J3P3*/                fmbgflag[i] = yes
/*F890*/                fmbgrecid = recid(fm_mstr).
/*J23W** /*F890*/        end. **/
/*F890*/     end.

         assign
         fpos = fm_fpos.

/*J23W**      find first fm_mstr use-index fm_fpos where fm_sums_into = fpos **/
/*J23W**      and fm_type = "I" no-lock no-error. **/

/*J23W* BEGIN ADD */
         for first fm_mstr
            fields (fm_cc_sort fm_desc fm_dr_cr fm_fpos
             fm_header fm_page_brk fm_skip fm_sub_sort
             fm_sums_into fm_total fm_type fm_underln )
            use-index fm_fpos where fm_sums_into = fpos
            and fm_type = "I" no-lock: end.
/*J23W* END ADD */

         if available fm_mstr and cur_level < 100 then
        assign cur_level = cur_level + 1.
         else do:

/*J23W**     find fm_mstr where recid(fm_mstr) = record[cur_level] **/
/*J23W**        no-lock no-error. **/

/*J23W* BEGIN ADD */
            for first fm_mstr
               fields (fm_cc_sort fm_desc fm_dr_cr fm_fpos
             fm_header fm_page_brk fm_skip fm_sub_sort
             fm_sums_into fm_total fm_type fm_underln )
               no-lock where recid(fm_mstr) = record[cur_level]: end.
/*J23W* END ADD */

/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE */
        assign
        fpos = fm_sums_into
        fm_recno = recid(fm_mstr).
/*J23W* END OF GROUPING FIELD ASSIGNMENTS */

/*F890*/  /*    fmbgflag = no.
*        if budget[1] or budget[2] or budget[3] or budget[4] then do:
*           find first bg_mstr where (bg_code = budgetcode[1] or
*                        bg_code = budgetcode[2] or
*                        bg_code = budgetcode[3] or
*                        bg_code = budgetcode[4]) and
/*F058*/                                    bg_fpos = fm_fpos and
*                        bg_entity >= entity and
*                        bg_entity <= entity1
/*F058*/                                    no-lock use-index bg_ind1
*                        no-error.
*           if available bg_mstr then fmbgflag = yes.
/*F890*/        end.     */

        /*determine sort_type*/
        IF fm_sub_sort AND NOT(subflag) THEN DO:
           IF fm_cc_sort AND NOT(ccflag) THEN
             assign sort_type=3.
           ELSE
             assign sort_type = 1.
             END.
        ELSE IF NOT(ccflag) THEN DO:
           IF fm_cc_sort THEN
             assign sort_type = 2.
           ELSE IF subflag THEN
             assign sort_type=4.
           ELSE
             assign sort_type=0.
           END.
        ELSE
             assign sort_type=0.
                 /*sort type=0=asc*/
             /* SS - 20050913 - B */
        IF sort_type=0 THEN DO:
           {gprun.i ""a6gl4inrb0.p"" "(sum_lev, sort_type)"}
        END.
                 /*sort type=1=sac*/
        ELSE IF sort_type=1 THEN DO:
           {gprun.i ""a6gl4inrb1.p"" "(sum_lev, sort_type)"}
        END.
                 /*sort type=2=cas*/
        ELSE IF sort_type=2 THEN DO:
           {gprun.i ""a6gl4inrb2.p"" "(sum_lev, sort_type)"}
        END.
                 /*sort type=3=sca*/
        ELSE IF sort_type=3 THEN DO:
           {gprun.i ""a6gl4inrb3.p"" "(sum_lev, sort_type)"}
        END.
                 /*sort type=4=acs*/
        ELSE DO:
           {gprun.i ""a6gl4inrb4.p"" "(sum_lev, sort_type)"}
        END.
           /* SS - 20050913 - E */

        do i = 1 to 4:
/*J3P3**   if fmbgflag and budget[i] then do:  */
/*J3P3*/   if fmbgflag[i] and
/*J3P3*/        budget[i]
/*J3P3*/   then do:
              {glfmbg.i &fpos=fm_fpos &yr=fiscal_yr[i] &per=per_beg[i]
             &per1=per_end[i] &budget=balance[i]
             &bcode=budgetcode[i]}
/*FM29*
/*F890*/                 if prt1000 then balance[i] = round(balance[i], 1000).
 *FM29*/
/*FM29*/                 if prt1000 then assign balance[i] =
/*FM29*/                    round(balance[i] / 1000 , 0).

/*F890*/ /*           if fm_dr_cr = false then do:
             balance1[i] = - balance[i].
             put balance1[i] at (34 + ((i - 1) * 25)).
              end.
/*F890*/              else put balance[i] to (34 + ((i - 1) * 25)).  */
              if      i = 1 then assign tot1[cur_level] = balance[i].
              else if i = 2 then assign tot2[cur_level] = balance[i].
              else if i = 3 then assign tot3[cur_level] = balance[i].
              else  /*i = 4*/    assign tot4[cur_level] = balance[i].
           end. /* IF fmbgflag[i] AND budget[i] */
        end.

        if cur_level > 1 then do:
/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE */
           assign
           tot1[cur_level - 1] = tot1[cur_level - 1] +
              tot1[cur_level]
           tot2[cur_level - 1] = tot2[cur_level - 1] +
              tot2[cur_level]
           tot3[cur_level - 1] = tot3[cur_level - 1] +
              tot3[cur_level]
           tot4[cur_level - 1] = tot4[cur_level - 1] +
              tot4[cur_level].
/*J23W* END OF GROUPING FIELD ASSIGNMENTS */
        end.

        if level >= cur_level then do:
           if fm_total = no or level = cur_level then do:
/*F890*/              do i = 1 to 4:
/*F890*/                 assign prtcol[i] = yes.
/*J3P3** /*F890*/        if fmbgflag and fmbgrecid <> recid(fm_mstr) and  */
/*J3P3*/                 if fmbgflag[i]                 and
/*J3P3*/                    fmbgrecid <> recid(fm_mstr) and
/*F890*/                    budget[i] then assign prtcol[i] = no.
/*F890*/              end.
/* SS - 20050913 - B */
/*
              if totflag[cur_level] then do:
             do i = 1 to 4:
/*F890*/                    if prtcol[i] then
                put "-----------------" at (34 + ((i - 1) * 25))
                "------" at (52 + ((i - 1) * 25)).
             end.
/*F890*/                 if prtcol[1] or prtcol[2] or prtcol[3] or
                prtcol[4] then do:

/*N0QF* /*F231*/     assign desc1 = substring(({&gl4inrpb_p_4} + fm_desc), 1, 24). */
/*N0QF*/             assign desc1 = substring((caps(getTermLabel("TOTAL",5)) + " " + fm_desc), 1, 24).
                put desc1 at min(9, ((cur_level - 1) * 2 + 1)).
/*F890*/                 end.
              end.
/*G1HP*/              else if fm_header then
/*G1HP*/                 put fm_desc at min(9, ((cur_level - 1) * 2 + 1)).
*/
/* SS - 20050913 - E */

/* SS - 20050913 - B */
/*
              if fm_dr_cr = false then do:
/*J23W*/     assign
             cramt = - tot1[cur_level]
             pct = 0.
             if income[1] <> 0 then
                assign pct = cramt / income[1] * 100.
/*F890*/                 if prtcol[1] then put cramt at 34 pct at 52.
                assign cramt = - tot2[cur_level]
                       pct = 0.
             if income[2] <> 0 then
                assign pct = cramt / income[2] * 100.
/*F890*/                 if prtcol[2] then put cramt at 59 pct at 77.
             assign cramt = - tot3[cur_level]
                    pct = 0.
             if income[3] <> 0 then
                assign pct = cramt / income[3] * 100.
/*F890*/                 if prtcol[3] then put cramt at 84 pct at 102.
             assign cramt = - tot4[cur_level]
                    pct = 0.
             if income[4] <> 0 then
                assign pct = cramt / income[4] * 100.
/*F890*/                 if prtcol[4] then put cramt at 109 pct at 127.
              end.
              else do:
                 assign pct = 0.
             if income[1] <> 0 then
                assign pct = tot1[cur_level] / income[1] * 100.
/*F890*/                 if prtcol[1] then put tot1[cur_level] at 34 pct at 52.
             assign pct = 0.
             if income[2] <> 0 then
                assign pct = tot2[cur_level] / income[2] * 100.
/*F890*/                 if prtcol[2] then put tot2[cur_level] at 59 pct at 77.
             assign pct = 0.
             if income[3] <> 0 then
                assign pct = tot3[cur_level] / income[3] * 100.
/*F890*/                 if prtcol[3] then put tot3[cur_level] at 84 pct at 102.
             assign pct = 0.
             if income[4] <> 0 then
                assign pct = tot4[cur_level] / income[4] * 100.
/*F890*/                 if prtcol[4] then put tot4[cur_level] at 109
                pct at 127.
              end.
              if fm_underln then do i = 1 to 4:
/*F890*/                 if prtcol[i] then
                put "=================" at (34 + ((i - 1) * 25))
                "======" at (52 + ((i - 1) * 25)).
              end.
/*F890*/              if (prtcol[1] or prtcol[2] or prtcol[3] or prtcol[4])
             and totflag[cur_level] and fm_skip then put skip(1).
*/
/* SS - 20050913 - E */
           end.
           /* SS - 20050913 - B */
           /*
           if fm_page_brk then page.
           */
           /* SS - 20050913 - E */
           if cur_level > 1 then assign totflag[cur_level - 1] = yes.

        end.

/*F890*/  if fmbgrecid = recid(fm_mstr) then assign fmbgflag = no.

        find next fm_mstr use-index fm_fpos where fm_sums_into = fpos
           and fm_type = "I" no-lock no-error.
         end.

         {mfrpexit.i}
      end.
/*K0S5*/ {wbrp04.i}
