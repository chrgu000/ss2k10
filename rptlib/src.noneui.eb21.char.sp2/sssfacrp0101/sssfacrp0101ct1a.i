/* sfacct1a.i - OPERATIONS ACCOUNTING REPORT INCLUDE FILE                  */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.6 $                                                            */
/*V8:ConvertMode=Report                                                    */
/* Revision: 1.3      BY: Vandna Rohira          DATE: 08/07/01   ECO: *M1DM* */
/* Revision: 1.5      BY: Paul Donnelly (SB)     DATE: 06/28/03   ECO: *Q00L* */
/* $Revision: 1.6 $       BY: Annapurna V            DATE: 11/22/04   ECO: *P2VY* */
/* $Revision: 1.6 $       BY: Bill Jiang            DATE: 05/06/08   ECO: *SS - 20080506.1* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*-------------------------------------------------------------------------*/
/* DESCRIPTION: THIS PROGRAM CONTAINS THE PROCESSING LOGIC FOR CREATING    */
/*              RECORDS IN THE TEMP-TABLE tt_gltw_wkfl WHEN gl_yn IS SET   */
/*              TO YES AND PRINTING THE REPORT WHEN tr_yn IS SET TO YES    */
/*                                                                         */
/*-------------------------------------------------------------------------*/

/* SS - 20080506.1 - B */
if gl_yn
then do:
   /* CREATING RECORDS IN tt_gltw_wkfl */
   {gprun.i ""sssfacrp0101ct02.p"" "(
      buffer opgl_det,
      buffer op_hist,
      INPUT acct,
      INPUT acct1,
      INPUT sub,
      INPUT sub1,
      INPUT cc,
      INPUT cc1,
      INPUT proj,
      INPUT proj1
      )"}
end.   /* IF GL_YN   */
/*
if gl_yn
then do:
   /* CREATING RECORDS IN tt_gltw_wkfl */
   {gprun.i ""sfacct02.p""
      "(buffer opgl_det,
        buffer op_hist)"}
end.   /* IF GL_YN   */

if tr_yn
then do:

   assign
      desc1 = ""
      desc2 = "".

   for first pt_mstr
         fields( pt_domain pt_desc1 pt_part)
          where pt_mstr.pt_domain = global_domain and  pt_part = op_part
         no-lock:
      desc1 = pt_desc1.
   end. /* FOR FIRST pt_mstr */

   if page-size - line-counter < 4
   then
      page.

   if opgl_type matches "LBR-.000"
   then
      desc2 = opgl_type + ": " + getTermLabel("LABOR",16).
   else
   if opgl_type matches "BDN-.000"
   then
      desc2 = opgl_type + ": " + getTermLabel("BURDEN",16).
   else
   if opgl_type matches "SUB-.000"
   then
      desc2 = opgl_type + ": " + getTermLabel("SUBCONTRACT",16).
   else
   if opgl_type matches "LBR-.001"
   then
      desc2 = opgl_type + ": " +
      getTermLabel("LABOR_RATE_VARIANCE",16).
   else
   if opgl_type matches "BDN-.001"
   then
      desc2 = opgl_type + ": " +
      getTermLabel("BURDEN_RATE_VARIANCE",16).
   else
   if opgl_type matches "SUB-.001"
   then
      desc2 = opgl_type + ": " +
      getTermLabel("SUB_RATE_VARIANCE",16).
   else
   if opgl_type matches "LBR-.002"
   then
      desc2 = opgl_type + ": " +
      getTermLabel("LABOR_USAGE_VARIANCE",16).
   else
   if opgl_type matches "BDN-.002"
   then
      desc2 = opgl_type + ": " +
      getTermLabel("BURDEN_USAGE_VARIANCE",16).
   else
   if opgl_type matches "SUB-.002"
   then
      desc2 = opgl_type + ": " +
      getTermLabel("SUB_USAGE_VARIANCE",16).
   else
   if opgl_type begins "PR-"
   then
      desc2 = opgl_type + ": " +
      getTermLabel("PAYROLL_XFER_VARIANCE",16).
   else desc2 = opgl_type.

   if opgl_type matches "...-1000"
   then
      desc2 = desc2 + " " + getTermLabel("SETUP",5).
   if desc2 = ""
   then
      desc2 = op_type.

   if oldtrnbr <> op_trnbr
   then do:

      down 1 with frame b.
      display
         op_part @ op_wo_nbr
         op_wo_lot @ oplot
         desc1 @ desc2
         with frame b.

      oldtrnbr = op_trnbr.

   end. /* IF oldtrnbr <> op_trnbr */

   if l_optrnbr <> op_trnbr
   then do:

      down 1 with frame b.
      display
         op_date
         op_trnbr format ">>>>>>>9"
         op_wo_nbr
          string(op_wo_op) @ oplot
         opgl_gl_ref
         desc2
         opgl_dr_acct @ drcract
         opgl_dr_sub  @ subact
         opgl_dr_cc   @ ccdisp
         opgl_gl_amt
         with frame b.
      down 1 with frame b.
      display
         opgl_cr_acct @ drcract
         opgl_cr_sub  @ subact
         opgl_cr_cc   @ ccdisp
         with frame b.

      l_optrnbr = op_trnbr.

   end. /* IF l_optrnbr <> op_trnbr */
   else do:

      down 1 with frame b.
      display
         opgl_gl_ref
         desc2
         opgl_dr_acct @ drcract
         opgl_dr_sub  @ subact
         opgl_dr_cc   @ ccdisp
         opgl_gl_amt
         with frame b.
      down 1 with frame b.
      display
         opgl_cr_acct @ drcract
         opgl_cr_sub  @ subact
         opgl_cr_cc   @ ccdisp
         with frame b.

   end. /* IF l_optrnbr = op_trnbr */

   {mfrpexit.i "false"}

end. /* IF tr_yn */
*/
/* SS - 20080506.1 - E */
