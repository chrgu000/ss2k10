/* mgflprrp.p - PROCEDURE HELP TEXT REPORT                              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* web convert mgflprrp.p (converter v1.00) Fri Oct 10 13:58:13 1997 */
/* web tag in mgflprrp.p (converter v1.00) Mon Oct 06 14:18:56 1997 */
/*F0PN*/ /*K1CJ*/ /*                                                    */
/*V8:ConvertMode=FullGUIReport                                 */
/* Revision: 7.3     Last Modified: 05/26/93     By: rwl *GB25*         */
/* Revision: 8.6     Last Modified: 12/08/97     By: bvm *K1CJ*         */


/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KR* myb              */
/*K1CJ*/ {mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mgflprrp_p_1 "Procedure"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*K1CJ* def var lang            like flhm_lang.
 * def var pgm_from        like flhm_call_pg label "Procedure".
 * def var pgm_to          like flhm_call_pg label {t001.i}.
 * def var status_from  like flhm_status.
 * def var status_to    like flhm_status label {t001.i}.
 * def var type_from       like flhd_type init "".
 * def var type_to         like flhd_type init "" label {t001.i}.*/
/*K1CJ*/ define variable lang            like flhm_lang.
/*K1CJ*/ define variable pgm_from        like flhm_call_pg label {&mgflprrp_p_1}.
/*K1CJ*/ define variable pgm_to          like flhm_call_pg label {t001.i}.
/*K1CJ*/ define variable status_from    like flhm_status.
/*K1CJ*/ define variable status_to  like flhm_status label {t001.i}.
/*K1CJ*/ define variable type_from       like flhd_type initial "".
/*K1CJ*/ define variable type_to         like flhd_type initial "" label {t001.i}.

/*K1CJ* {mfdtitle.i "b+ "} * moved up*/

form
   lang         colon 10
   pgm_from     colon 10
   pgm_to       colon 46
   status_from  colon 10
   status_to    colon 46
   type_from    colon 10
   type_to      colon 46
   skip
with frame a side-labels attr-space
/*K1CJ*/ width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   flhm_lang         colon 25
   lng_desc         no-label
   flhm_call_pg     colon 25
   flhm_status      colon 68
   flhm_lnk_pgm     colon 25
   flhm_sub         colon 25
   flhm_label       colon 25
   flhm_col_label   colon 25
   flhm_class       colon 25
   flhm_validate    colon 25
   flhm_default     colon 25
   flhm_type        colon 25
   flhm_format      colon 25
   flhm_len         colon 68

with frame b down side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

form
    space(5)
    flhd_type
    flhd_text
    with frame c down width 80.

    /* SET EXTERNAL LABELS */
    setFrameLabels(frame c:handle).

lang = global_user_lang.

/*K1CJ*/ {wbrp01.i}

repeat:
   if pgm_to = hi_char then pgm_to = "".
   if type_to = hi_char then type_to = "".
   if status_to = hi_char then status_to = "".

/*K1CJ*/ if c-application-mode <> 'web' then
   update
        lang
        pgm_from
        pgm_to
            status_from
            status_to
        type_from
        type_to
        with frame a.

/*K1CJ*/ {wbrp06.i &command = update &fields = "  lang pgm_from pgm_to
          status_from status_to type_from type_to" &frm = "a"}

/*K1CJ*/ if (c-application-mode <> 'web') or
/*K1CJ*/ (c-application-mode = 'web' and
/*K1CJ*/ (c-web-request begins 'data')) then do:

   bcdparm = "".
   {mfquoter.i lang}
   {mfquoter.i pgm_from}
   {mfquoter.i pgm_to}
   {mfquoter.i status_from}
   {mfquoter.i status_to}
   {mfquoter.i type_from}
   {mfquoter.i type_to}

   if pgm_to = "" then pgm_to = hi_char.
   if status_to = "" then status_to = hi_char.
   if type_to = "" then type_to = hi_char.

/*K1CJ*/ end.

   /* SELECT PRINTER */
   {mfselbpr.i "printer" 80}

  /* {mfphead2.i} */

   for each flhm_mst no-lock use-index flhm_lang
   where flhm_lang = lang
   and flhm_field = ""
   and flhm_call_pg >= pgm_from and flhm_call_pg <= pgm_to
   and flhm_status >= status_from and flhm_status <= status_to:

      display
        flhm_lang
        flhm_call_pg
        flhm_status
        flhm_lnk_pgm
        flhm_sub
        flhm_label
        flhm_col_label
        flhm_validate
        flhm_default
        flhm_class
        flhm_type
        flhm_format
        flhm_len
            with frame b.

      for each flhd_det no-lock use-index flhd_type
      where flhd_lang = flhm_lang
      and flhd_field = flhm_field
      and flhd_call_pg = flhm_call_pg
      and flhd_type >= type_from and flhd_type <= type_to
      break by flhd_type by flhd_line:

     if first-of(flhd_type) then display flhd_type with frame c.
     else display "" @ flhd_type with frame c.

     display flhd_text with frame c.
     down 1 with frame c.

     if last-of(flhd_type) then put skip(2).

      end.

      {mfrpexit.i}

      page.

   end.

 /*  {mftrl080.i} */
 {mfreset.i}

end.

/*K1CJ*/ {wbrp04.i &frame-spec = a}
