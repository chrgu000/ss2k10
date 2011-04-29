/* mfphead.i - INCLUDE FILE TO PRINT PAGE HEADING FOR REPORTS              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.19 $                                                       */
/*V8:ConvertMode=Report                                                    */
/*  REVISION: 1.0          LAST EDIT: 02/13/86       MODIFIED BY: EMB      */
/*  REVISION: 5.0          LAST EDIT: 11/29/90       MODIFIED BY: emb *B828*/
/*  REVISION: 7.3          LAST EDIT: 03/24/95       MODIFIED BY: jzs *G0FB*/
/*  REVISION: 7.3          LAST EDIT: 01/24/96       MODIFIED BY: dzn *G1KT*/
/*  REVISION: 8.6          LAST EDIT: 09/17/97       MODIFIED BY: kgs *K0J0*/
/*  REVISION: 8.6E         LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/*  REVISION: 8.6E     LAST EDIT: 05/15/98       BY: *H1L9*  Vijaya Pakala */
/*  REVISION: 8.6E     LAST EDIT: 10/04/98       BY: *J314* Alfred Tan     */
/*  REVISION: 9.1      LAST MODIFIED: 07/26/99   BY: *N038* John Corda     */
/*  REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb            */
/* Old ECO marker removed, but no ECO header exists *F0PN*                 */
/* Revision: 1.12  BY: Katie Hilbert DATE: 03/07/01 ECO: *N0XB* */
/* Revision: 1.14  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00G* */
/* Revision: 1.15  BY: Ed van de Gevel DATE: 07/08/03 ECO: *Q003* */
/* Revision: 1.18  BY: Patrick de Jong DATE: 07/15/03 ECO: *Q016* */
/* $Revision: 1.19 $ BY: Ed van de Gevel DATE: 01/20/04 ECO: *Q05C* */
/* SS - 090925.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/***************************************************************************/
/*!
{1} "STREAM stream-name" (optional - but if used must include STREAM keyword)
{2} "(stream-name)"      (optional - needed if {1} is used (omit keyword)
*/
/***************************************************************************/

define variable rtitle as character format "x(100)".
define variable co_name as character format "x(30)".
define variable len_raw as integer.

find ls_mstr  where ls_mstr.ls_domain = global_domain and  ls_addr =
"~~reports" and ls_type = "company"
   no-lock no-error.

if available ls_mstr then
   find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr = ls_addr
   no-lock no-error.

if available ad_mstr then
   co_name = fill(" ", max( (15 - integer( {gprawlen.i &strng=ad_name} / 2)), 1) ) +
                  ad_name.

if global_usrc_right_hdr_disp < 2
then len_raw = {gprawlen.i &strng=substring(dtitle,16,50)}.
else len_raw = {gprawlen.i &strng=substring(dtitle,22,44)}.
/* GUI has a different dtitle, so we need to adjust rtitle differently. */

/*V8-*/
if global_usrc_right_hdr_disp < 2
/* SS 090925.1 - B */
/*
then rtitle = substring(dtitle,1,15) + fill(" ",25) +
              substring(dtitle,16,50 - (len_raw - 50)).
else rtitle = substring(dtitle,1,21) + fill(" ",25) +
              substring(dtitle,22,44 - (len_raw - 44)).
*/
then rtitle = substring(dtitle,1,25) + fill(" ",15) +
              substring(dtitle,26,50 - (len_raw - 50)).
else rtitle = substring(dtitle,1,31) + fill(" ",15) +
              substring(dtitle,32,44 - (len_raw - 44)).
/* SS 090925.1 - E */
/*V8+*/

/*V8!
{gprtitle.i
   &rpt_title=rtitle
   &exec_name=execname
   &exec_length=15
   &def_titl_col=52
   &def_title=dtitle}
*/

form
   header
   rtitle
   getTermLabelRtColon("DATE",9) format "x(9)" to 123
   today           skip
   getTermLabel("PAGE",8) + ":" at 1
   string(page-number {2}) format "x(8)"
   co_name         at 53
   getTermLabelRtColon("TIME",9) format "x(9)" to 123
   string(Time,"hh:mm:ss")

   /* DISPLAYS "SIMULATION" TEXT, IF REPORT IS RUN IN SIMULATION MODE */
   &IF DEFINED(simulation) &THEN
      if not update_yn then
         getTermLabel("BANNER_SIMULATION",28)
      else
         "" at 58 format "x(28)"
   &ENDIF

with frame phead page-top width 132 no-box.

{wbgp03.i}

if c-application-mode = 'WEB' and c-web-request = 'DATA' then do:
   put stream webstream
     skip {&WEB-LABEL-HEADER-TAG} skip
     rtitle
     getTermLabelRtColon("DATE",9) format "x(9)" to 123
     today skip
     co_name at 53
     getTermLabelRtColon("TIME",9) format "x(9)" to 123
     string(Time,"hh:mm:ss")
     skip {&WEB-END-HEADER-TAG} skip.
   form
     header
     getTermLabel("PAGE",8) + ":"        at 1
     string(page-number {2}) format "x(8)"

     /* DISPLAYS "SIMULATION" TEXT, IF REPORT IS RUN IN SIMULATION */
     /* MODE THIS DISPLAY IS FOR WEB SPECIFIC PROGRAMS             */

     &IF DEFINED(simulation) &THEN
        if not update_yn then
           getTermLabel("BANNER_SIMULATION",28)
        else
           "" at 58 format "x(28)"
     &ENDIF

   with frame pwebhead page-top width 132 no-box.
   view {1} frame pwebhead.
 end.
 else
    view {1} frame phead.

/*end mfphead.i*/
