/* mfphead2.i - INCLUDE FILE TO PRINT PAGE HEADING FOR REPORTS 80 COLUMNS     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.16 $                                                          */
/*V8:ConvertMode=Report                                                       */
/*  REVISION: 1.0   LAST EDIT: 05/12/86       MODIFIED BY: EMB                */
/*  REVISION: 5.0   LAST EDIT: 11/29/90       MODIFIED BY: emb *B828*/
/*  REVISION: 7.3   LAST EDIT: 03/24/95       MODIFIED BY: jzs *G0FB*/
/*  REVISION: 7.3   LAST EDIT: 01/24/96       MODIFIED BY: dzn *G1KT*/
/*  REVISION: 8.6   LAST EDIT: 09/17/97       MODIFIED BY: kgs *K0J0*/
/*  REVISION: 8.6E  LAST EDIT: 02/23/98       MODIFIED BY: *L007* A. Rahane   */
/*  REVISION: 8.6E  LAST EDIT: 03/11/98       MODIFIED BY: *J2DD* Kawal Batra */
/*  REVISION: 8.6E  LAST EDIT: 05/14/98       MODIFIED BY: *J2MN* Raphael T   */
/*  REVISION: 8.6E  LAST EDIT: 10/04/98       BY: *J314* Alfred Tan           */
/*  REVISION: 9.1   LAST MODIFIED: 07/30/99   BY: *N038* Mugdha Tambe         */
/*  REVISION: 9.1   LAST MODIFIED: 08/13/00   BY: *N0KR* myb                  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.13     BY: Katie Hilbert       DATE: 03/07/01  ECO: *N0XB*     */
/* Revision: 1.14  BY: Dipesh Bector DATE: 07/29/02 ECO: *N1Q0* */
/* $Revision: 1.16 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00G* */
/* 100716.1  $  BY: mage chen  DATE: 07/16/10    ECO: *P45S*  */

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
/************************************************************************
   Implementation notes:  The Include file brprhd.i is an Replica of
   mfphead2.i except that the logical database name is Prefixed to it.
   If there are any changes being done to mfphead2.i these changes need
   to be introduced in brprhd.i as well.
*************************************************************************/

define variable page_counter as integer  no-undo.
define variable co_name as character format "x(30)"  no-undo.

/* GUI has a different dtitle, so need to make an rtitle */
/*V8!
define variable rtitle as character format "x(64)" no-undo.
rtitle = execname
       + fill(" ", 15 - integer( {gprawlen.i &strng=execname} ))
       + fill(" ", integer((48 - {gprawlen.i &strng=dtitle} ) / 2))
       + dtitle.
*/
/*100716.1assign title1 = getTermLabel("BG-SC-08                               SINCERE-HOME",25).*/

for first ls_mstr
 where ls_mstr.ls_domain = global_domain and  ls_addr = "~~reports" and ls_type
 = "company"
no-lock: end.

if available ls_mstr then
   for first ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
   ls_addr no-lock: end.

if available ad_mstr then
   co_name = fill(" ", max ((15 - integer ({gprawlen.i &strng=ad_name} / 2)), 1))
           + ad_name.





form
   header
   /*V8-*/
  "BG-SC-08                             SINCERE-HOME                             打印时间:"  at 2
   today   no-label   string(time, "HH:MM:SS")    no-label
   "领   料   单"   at  40
   getTermLabel("PAGE",8) + ":"     at  88
   string(page-number {2} - page_counter) format "x(8)"

   &IF DEFINED(simulation) &THEN
       if not update_yn then
          getTermLabel("BANNER_SIMULATION",28)
       else
          "" at 31 format "x(28)"
   &ENDIF
   skip(1)
with frame phead2 page-top width 120  no-box no-attr-space.

{wbgp03.i}

if c-application-mode = 'WEB' and c-web-request = 'DATA' then do:
   put stream webstream
      skip {&WEB-LABEL-HEADER-TAG} skip
      dtitle         format "x(64)"
      getTermLabelRtColon("DATE",6) format "x(6)" to 71
      today          skip
      co_name        at 26
      getTermLabelRtColon("TIME",9) format "x(9)" to 71
      string(Time,"hh:mm:ss")
      skip {&WEB-END-HEADER-TAG} skip.
   form
      header
      getTermLabel("PAGE",8) + ":"        at 1
      string(page-number {2} - page_counter) format "x(8)"
      /* DISPLAYS "SIMULATION" TEXT,IF REPORT IS RUN IN SIMULATION  */
      /* MODE THIS DISPLAY IS FOR WEB SPECIFIC PROGRAMS             */
      &IF DEFINED(simulation) &THEN
         if not update_yn then
           getTermLabel("BANNER_SIMULATION",28)
         else
           "" at 31 format "x(28)"
      &ENDIF
   with frame pwebhead page-top width 132 no-box.
   view {1} frame pwebhead.
end.
else
   view {1} frame phead2.

page_counter = page-number {2} - 1.

/*end mfphead2.i*/
