/* adstrp.p - CUSTOMER SHIP TO REPORT                                   */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.6.1.7 $                                             */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 6.0      LAST MODIFIED: 03/19/90   BY: ftb *D006**/
/* REVISION: 7.0      LAST MODIFIED: 11/22/91   BY: afs *F056**/
/* REVISION: 7.0      LAST MODIFIED: 04/03/92   BY: tjs *F353**/
/* REVISION: 7.0      LAST MODIFIED: 06/03/94   BY: dpm *FO57**/
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   BY: GYK *K0V0*          */
/* REVISION: 8.6      LAST MODIFIED: 10/29/97   BY: *H1G4* Manish K.    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.6.1.6     BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002* */
/* $Revision: 1.6.1.7 $    BY: Narathip W.    DATE: 04/17/03 ECO: *P0Q4* */
/* $Revision: 1.6.1.7 $    BY: Bill Jiang    DATE: 05/23/06 ECO: *SS - 20060523.1* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20060523.1 - B */
/*
1. 标准输入输出
*/
/* SS - 20060523.1 - E */

/* SS - 20060523.1 - B */
{a6adstrp01.i "new"}
/* SS - 20060523.1 - E */

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
{cxcustom.i "ADSTRP.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE adstrp_p_1 "Customer"
/* MaxLen: Comment: */

&SCOPED-DEFINE adstrp_p_2 "Ship To"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable code like cm_addr.
define variable code1 like cm_addr.
define variable name like ad_name.
define variable name1 like ad_name.
define variable bill_to like mfc_logical initial yes.
define buffer ad_ship for ad_mstr.
define variable ship like ad_addr.
define variable blank_line like ad_line1.
define variable slspsn like sp_addr.
define variable slspsn1 like slspsn.

form
   code           colon 14
   code1          label {t001.i} colon 48 skip
   name           colon 14
   name1          label {t001.i} colon 48 skip
   slspsn         colon 14
   slspsn1        label {t001.i} colon 48 skip (1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

   if code1 = hi_char then code1 = "".
   if name1 = hi_char then name1 = "".
   if slspsn1 = hi_char then slspsn1 = "".

   if c-application-mode <> 'web' then
      update code code1 name name1 slspsn slspsn1 with frame a.

   {wbrp06.i &command = update &fields = "  code code1 name name1 slspsn
slspsn1" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i code    }
      {mfquoter.i code1   }
      {mfquoter.i name    }
      {mfquoter.i name1   }
      {mfquoter.i slspsn  }
      {mfquoter.i slspsn1 }

      if code1 = "" then code1 = hi_char.
      if name1 = "" then name1 = hi_char.
      if slspsn1 = "" then slspsn1 = hi_char.

   end.
   /* Select printer */
   {mfselbpr.i "printer" 132}
      /* SS - 20060523.1 - B */
      /*
   {mfphead.i}

   form header
      skip(1)
   with frame a1 page-top width 132.
   view frame a1.

   for each cm_mstr where (cm_sort >= name and cm_sort <= name1)
         and (cm_addr >= code and cm_addr <= code1)
         and (cm_slspsn[1] >= slspsn and  cm_slspsn[1] <= slspsn1)
         {&ADSTRP-P-TAG1}
         no-lock by cm_sort with frame b width 132 no-attr-space no-box
         {&ADSTRP-P-TAG2}
         down:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
      if page-size - line-counter <  4 then page.
      find ad_mstr where ad_addr = cm_addr no-lock.
      {&ADSTRP-P-TAG3}
      display cm_addr label {&adstrp_p_1} ship  label {&adstrp_p_2}
         ad_mstr.ad_name
         ad_mstr.ad_line1 ad_mstr.ad_state
         ad_mstr.ad_zip ad_mstr.ad_phone ad_ext  ad_temp format "yes/".
      {&ADSTRP-P-TAG4}

      if ad_mstr.ad_line2 <> "" then do:
         down 1.
         {&ADSTRP-P-TAG5}
         display ad_mstr.ad_line2 @ ad_mstr.ad_line1.
         {&ADSTRP-P-TAG6}
      end.
      if ad_mstr.ad_line3 <> "" then do:
         down 1.
         {&ADSTRP-P-TAG7}
         display ad_mstr.ad_line3 @ ad_mstr.ad_line1.
         {&ADSTRP-P-TAG8}
      end.
      if ad_mstr.ad_city <> "" then do:
         down 1.
         display ad_mstr.ad_city @ ad_mstr.ad_line1.
      end.
      if ad_mstr.ad_county <> "" then do:
         down 1.
         display ad_mstr.ad_county @ ad_mstr.ad_line1.
      end.
      if ad_mstr.ad_country <> "" then do:
         down 1.

         display ad_mstr.ad_country @ ad_mstr.ad_line1
            ad_mstr.ad_ctry @ ad_mstr.ad_state.
      end.
      if ad_mstr.ad_attn <> "" then do:
         down 1.
         display ad_mstr.ad_attn @ ad_mstr.ad_line1.
      end.
      down 1.

      for each ad_ship where ad_ship.ad_ref = ad_mstr.ad_addr no-lock,
            each ls_mstr where ls_addr = ad_ship.ad_addr and ls_type = "ship-to"
            no-lock with frame b:

         if page-size - line-counter < 4 then page.
         down 1.
         {&ADSTRP-P-TAG9}
         display
            ad_ship.ad_addr @ ship ad_ship.ad_name @ ad_mstr.ad_name
            ad_ship.ad_line1 @ ad_mstr.ad_line1
            ad_ship.ad_state @ ad_mstr.ad_state
            ad_ship.ad_zip @ ad_mstr.ad_zip
            ad_ship.ad_phone @ ad_mstr.ad_phone
            ad_ship.ad_ext @ ad_mstr.ad_ext
            ad_ship.ad_temp @ ad_mstr.ad_temp.
         {&ADSTRP-P-TAG10}

         if ad_ship.ad_line2 <> ""  then do:
            down 1.
            {&ADSTRP-P-TAG11}
            display ad_ship.ad_line2 @ ad_mstr.ad_line1.
            {&ADSTRP-P-TAG12}
         end.
         if ad_ship.ad_line3 <> "" then do:
            down 1.
            {&ADSTRP-P-TAG13}
            display ad_ship.ad_line3 @ ad_mstr.ad_line1.
            {&ADSTRP-P-TAG14}
         end.
         if ad_ship.ad_city <> "" then do:
            down 1.
            display ad_ship.ad_city @ ad_mstr.ad_line1.
         end.
         if ad_ship.ad_county <> "" then do:
            down 1.
            display ad_ship.ad_county @ ad_mstr.ad_line1.
         end.
         if ad_ship.ad_country <> "" then do:
            down 1.

            display ad_ship.ad_country @ ad_mstr.ad_line1
               ad_ship.ad_ctry @ ad_mstr.ad_state.
         end.
         if ad_ship.ad_attn <> "" then do:
            down 1.
            display ad_ship.ad_attn @ ad_mstr.ad_line1.
         end.
         {mfrpexit.i}
         down 1.
      end.
   end.

   /* REPORT TRAILER  */

   {mfrtrail.i}
      */
      PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

    FOR EACH tta6adstrp01:
        DELETE tta6adstrp01.
    END.

   {gprun.i ""a6adstrp01.p"" "(
      input CODE,
      input code1,
      input NAME,
      input name1,
      input slspsn,
      input slspsn1
      )"}

    EXPORT DELIMITER ";" "ad_addr" "ad_name".
    FOR EACH tta6adstrp01:
        EXPORT DELIMITER ";" tta6adstrp01.
    END.

    PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

    {a6mfrtrail.i}
      /* SS - 20060523.1 - E */

end.

{wbrp04.i &frame-spec = a}
