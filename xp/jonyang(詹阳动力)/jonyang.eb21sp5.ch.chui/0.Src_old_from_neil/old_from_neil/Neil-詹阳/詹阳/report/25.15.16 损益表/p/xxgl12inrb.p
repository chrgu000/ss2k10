/* gl12inrb.p - GENERAL LEDGER 12-COLUMN INCOME STATEMENT (PART III)    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.13 $                                                    */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 7.0      LAST MODIFIED: 03/31/92   by: jms   *F340*        */
/* REVISION: 8.6      LAST MODIFIED: 12/15/97   by: bvm   *K1DS*        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E          MODIFIED: 03/12/98   By: *J23W* Sachin Shah  */
/* REVISION: 8.6E     LAST MODIFIED: 24 apr 98  BY: *L00S* D. Sidel     */
/* REVISION: 8.6E          MODIFIED: 10/04/98   By: *J314* Alfred Tan   */
/* REVISION: 9.1           MODIFIED: 08/14/00   By: *N0L1* Mark Brown   */
/* Old ECO marker removed, but no ECO header exists *F0PN*              */
/* Revision: 1.11  BY: Katie Hilbert DATE: 03/10/01 ECO: *N0XB* */
/* $Revision: 1.13 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* SS - 090715.1 By: Neil Gao */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE gl12inrb_p_1 "Suppress Zero Amounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl12inrb_p_2 "Summarize Sub-Accounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl12inrb_p_3 "Summarize Cost Centers"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl12inrb_p_4 "Round to Nearest Thousand"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl12inrb_p_5 "Level"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{wbrp02.i}

define shared variable glname like en_name no-undo.
define shared variable begdt as date extent 12 no-undo.
define shared variable enddt as date extent 12 no-undo.
define shared variable actual like mfc_logical extent 12 no-undo.
define shared variable budget like mfc_logical extent 12 no-undo.
define shared variable bcode as character format "x(8)" extent 12
      no-undo.
define shared variable variance like mfc_logical extent 12 no-undo.
define shared variable varpct like mfc_logical extent 12 no-undo.
define shared variable incpct like mfc_logical extent 12 no-undo.
define shared variable zeroflag like mfc_logical
      initial no label {&gl12inrb_p_1} no-undo.
define shared variable ctr like cc_ctr no-undo.
define shared variable ctr1 like cc_ctr no-undo.
define shared variable sub like sb_sub no-undo.
define shared variable sub1 like sb_sub no-undo.
define shared variable level as integer
      format ">9" initial 99 label {&gl12inrb_p_5} no-undo.
define shared variable ccflag like mfc_logical
      label {&gl12inrb_p_3} no-undo.
define shared variable subflag like mfc_logical
      label {&gl12inrb_p_2} no-undo.
define shared variable entity like en_entity no-undo.
define shared variable entity1 like en_entity no-undo.
define shared variable cname like glname no-undo.
define shared variable fiscal_yr like glc_year extent 12 no-undo.
define shared variable per_beg like glc_per extent 12 no-undo.
define shared variable per_end like glc_per extent 12 no-undo.
define shared variable ret like ac_code no-undo.
define shared variable yr_end as date extent 12 no-undo.
define shared variable income as decimal extent 12 no-undo.
define shared variable rpt_curr like gltr_curr no-undo.
define shared variable prt1000 like mfc_logical
      label {&gl12inrb_p_4} no-undo.
define shared variable label1 as character format "x(12)"
      extent 12 no-undo.
define shared variable label2 as character format "x(12)"
      extent 12 no-undo.
define shared variable label3 as character format "X(12)"
      extent 12 no-undo.

define new shared variable balance as decimal
      format "(>>,>>>,>>>,>>9)" extent 12 no-undo.
define new shared variable fmbgflag as logical extent 12 no-undo.
define new shared variable ac_recno as recid no-undo.
define new shared variable fm_recno as recid no-undo.
define new shared variable totflag like mfc_logical extent 100
      no-undo.
define new shared variable tot1 as decimal extent 100 no-undo.
define new shared variable tot2 like tot1 no-undo.
define new shared variable tot3 like tot1 no-undo.
define new shared variable tot4 like tot1 no-undo.
define new shared variable tot5 like tot1 no-undo.
define new shared variable tot6 like tot1 no-undo.
define new shared variable tot7 like tot1 no-undo.
define new shared variable tot8 like tot1 no-undo.
define new shared variable tot9 like tot1 no-undo.
define new shared variable tot10 like tot1 no-undo.
define new shared variable tot11 like tot1 no-undo.
define new shared variable tot12 like tot1 no-undo.
define new shared variable xacc like ac_code no-undo.
define new shared variable cur_level as integer no-undo.
define new shared variable fpos like fm_fpos no-undo.

define variable record as recid extent 100 no-undo.

{etvar.i}
{etrpvar.i}

/* CYCLE THROUGH FORMAT POSITION FILE */
assign cur_level = 1.

for first fm_mstr
      fields( fm_domain fm_header fm_desc fm_fpos fm_sums_into fm_type)
      use-index fm_fpos no-lock  where fm_mstr.fm_domain = global_domain and
      fm_type = "I"
      and fm_sums_into = 0:
end.

   loopb:
   repeat:

      if not available fm_mstr then do:
         repeat:
            assign cur_level = cur_level - 1.
            if cur_level < 1 then leave.

            for first fm_mstr
                  fields( fm_domain fm_header fm_desc fm_fpos fm_sums_into
                  fm_type)
                  no-lock where recid(fm_mstr) = record[cur_level]:
            end.

            assign
               fpos = fm_sums_into
               fm_recno = recid(fm_mstr).

/* SS 090715.1 - B */
/*
            {gprun.i ""gl12inrg.p""}
*/
            {gprun.i ""xxgl12inrg.p""}
/* SS 090715.1 - E */

            find next fm_mstr use-index fm_fpos  where fm_mstr.fm_domain =
            global_domain and  fm_type = "I"
               and fm_sums_into = fpos no-lock no-error.
            if available fm_mstr then leave.

         end.
      end.

      if cur_level < 1 then leave.

      if fm_header = no and level >= cur_level then
         put fm_desc at min(9, ((cur_level - 1) * 2 + 1)).
      else do:
         if level = cur_level then
         put fm_desc at
            min(9,((cur_level - 1) * 2 + 1)).
      end.

      assign
         record[cur_level] = recid(fm_mstr)
         tot1[cur_level] = 0
         tot2[cur_level] = 0
         tot3[cur_level] = 0
         tot4[cur_level] = 0
         tot5[cur_level] = 0
         tot6[cur_level] = 0
         tot7[cur_level] = 0
         tot8[cur_level] = 0
         tot9[cur_level] = 0
         tot10[cur_level] = 0
         tot11[cur_level] = 0
         tot12[cur_level] = 0
         totflag[cur_level] = no
         fpos = fm_fpos.

      for first fm_mstr
            fields( fm_domain fm_header fm_desc fm_fpos fm_sums_into fm_type)
            use-index fm_fpos  where fm_mstr.fm_domain = global_domain and
            fm_sums_into = fpos
            and fm_type = "I" no-lock:
      end.

      if available fm_mstr and cur_level < 100 then
         assign cur_level = cur_level + 1.
      else do:

         for first fm_mstr
               fields( fm_domain fm_header fm_desc fm_fpos fm_sums_into fm_type)
               no-lock where recid(fm_mstr) = record[cur_level]:
         end.
         assign
            fpos = fm_sums_into
            fm_recno = recid(fm_mstr).

/* SS 090715.1 - B */
/*
         {gprun.i ""gl12inrg.p""}
*/
         {gprun.i ""xxgl12inrg.p""}
/* SS 090715.1 - E */
         find next fm_mstr use-index fm_fpos  where fm_mstr.fm_domain =
         global_domain and  fm_type = "I"
            and fm_sums_into = fpos no-lock no-error.
      end.

      {mfrpchk.i}
   end.

   {wbrp04.i}
