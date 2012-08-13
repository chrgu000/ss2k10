/* GUI CONVERTED from bmcsru.p (converter v1.78) Tue Jan 20 21:57:30 2009 */
/* bmcsru.p - BOM COST ROLL-UP                                          */
/* Copyright 1986-2009 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* REVISION: 7.0      LAST MODIFIED: 09/25/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 01/30/92   BY: pma *F116*          */
/* REVISION: 7.0      LAST MODIFIED: 02/18/92   BY: pma *F206*          */
/* REVISION: 7.0      LAST MODIFIED: 04/01/92   BY: emb *F345*          */
/* REVISION: 7.0      LAST MODIFIED: 05/28/92   BY: pma *F542*          */
/* REVISION: 7.2      LAST MODIFIED: 11/09/92   BY: emb *G294*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 02/18/93   BY: emb *G700*          */
/* REVISION: 7.3      LAST MODIFIED: 02/19/93   BY: pma *G681*          */
/* REVISION: 7.3      LAST MODIFIED: 12/20/93   BY: ais *GH69*          */
/* REVISION: 7.3      LAST MODIFIED: 01/28/94   BY: pma *GI54*          */
/* REVISION: 8.5      LAST MODIFIED: 10/20/94   BY: mwd *J034*          */
/* REVISION: 7.3      LAST MODIFIED: 06/07/95   BY: str *G0N9*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 10/06/99   BY: *N03B* Jyoti Thatte */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn              */
/* REVISION: 9.1      LAST MODIFIED: 08/29/00   BY: *N0PP* Jean Miller      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.8.1.11  BY: Rajesh Thomas DATE: 06/28/01 ECO: *M1CD* */
/* Revision: 1.8.1.13  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* Revision: 1.8.1.14  BY: Rajinder Kamra  DATE: 06/23/03  ECO *Q003*  */
/* Revision: 1.8.1.15  BY: Rajat Kulshreshtha DATE: 12/11/08  ECO *Q22T*  */
/* $Revision: 1.8.1.16 $ BY: Rajat Kulshreshtha DATE: 01/19/09  ECO *Q28L*  */
/*-Revision end---------------------------------------------------------------*/
/*V8:ConvertMode=Report                                                 */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "1+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE bmcsru_p_1 "Print Audit Trail"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_2 "As of Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_3 "All/Changed Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_4 "All/Changed"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_5 "Low Level Labor Time"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_6 "Low Level Labor"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_7 "Low Level Material"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_8 "Low Level Overhead"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_9 "Low Level Setup Time"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_10 "Low Level Subcontract"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_11 "Low Level Burden"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_12 "Include Yield %"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable site  like si_site.
define new shared variable csset like sct_sim.
define new shared variable part  like pt_part.
define new shared variable part1 like pt_part.

define new shared variable line  like pt_prod_line.
define new shared variable line1 like pt_prod_line.
define new shared variable type  like pt_part_type.
define new shared variable type1 like pt_part_type.
define new shared variable grp   like pt_group.
define new shared variable grp1  like pt_group.

define new shared variable eff_date as date initial today
   label {&bmcsru_p_2}.
define new shared variable part_type like pt_part_type.
define new shared variable mtl_flag like mfc_logical initial yes
   label {&bmcsru_p_7}.
define new shared variable lbr_flag like mfc_logical initial yes
   label {&bmcsru_p_6}.
define new shared variable bdn_flag like mfc_logical initial yes
   label {&bmcsru_p_11}.
define new shared variable ovh_flag like mfc_logical initial yes
   label {&bmcsru_p_8}.
define new shared variable sub_flag like mfc_logical initial yes
   label {&bmcsru_p_10}.
define new shared variable labor_flag like mfc_logical
   label {&bmcsru_p_5}.
define new shared variable setup_flag like mfc_logical
   label {&bmcsru_p_9}.
define new shared variable audit_yn like mfc_logical initial yes
   label {&bmcsru_p_1}.
define new shared variable cst_flag like mfc_logical initial yes
   label  {&bmcsru_p_3} format {&bmcsru_p_4}.
define new shared variable yield_flag like mfc_logical initial yes
   label {&bmcsru_p_12}.
define new shared variable rollup_id like qad_key3.

define variable yn like mfc_logical.
define variable l_is_oracle like mfc_logical initial no.
define variable i as integer.
define variable method as character format "x(15)".
define variable frm-text as character format "x(30)" no-undo.

define shared variable transtype as character format "x(7)".


frm-text = getTermLabel("SET_COST_UPDATE_FIELD_FOR",30).


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
site           colon 18
   csset          colon 18
   cs_desc        colon 30 no-label
   method                  no-label
   part           colon 18 part1  label {t001.i} colon 49
   line           colon 18 line1  label {t001.i} colon 49
   type           colon 18 type1  label {t001.i} colon 49
   grp            colon 18 grp1   label {t001.i} colon 49
   skip(1)
   eff_date       colon 25
   mtl_flag       colon 25
   frm-text       at 40    no-label
   lbr_flag       colon 25
   cst_flag       colon 56
   bdn_flag       colon 25
   ovh_flag       colon 25
   sub_flag       colon 25
   skip(1)
   labor_flag     colon 25
   yield_flag     colon 56
   setup_flag     colon 25
   audit_yn       colon 25
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

find first icc_ctrl  where icc_ctrl.icc_domain = global_domain no-lock.

/* IF NOT ORACLE THEN L_IS_ORACLE = NO ELSE L_IS_ORACLE = YES */
assign
   l_is_oracle = (dbtype ("qaddb") = "ORACLE")
   site = global_site.

if transtype <> "SC"
   and csset = ""
then do:
   find si_mstr no-lock  where si_mstr.si_domain = global_domain and  si_site =
   site no-error.
   if available si_mstr then csset = si_cur_set.
   if csset = "" then csset = icc_cur_set.
end.

display
   site
   csset
   part part1
   line line1
   type type1
   grp grp1
   eff_date
   mtl_flag
   lbr_flag
   bdn_flag
   ovh_flag
   sub_flag
   labor_flag
   setup_flag
   audit_yn
   cst_flag
   yield_flag
   frm-text
with frame a.

mainloop:
repeat:

   if part1 = hi_char then part1 = "".
   if line1 = hi_char then line1 = "".
   if type1 = hi_char then type1 = "".
   if grp1 = hi_char then grp1 = "".

   if not batchrun then do:
      seta1:
      do transaction on error undo, retry:
         set site with frame a
         editing:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i si_mstr site  " si_mstr.si_domain = global_domain and
            si_site "  site si_site si_site}

            if recno <> ? then do:
               site = si_site.
               display site with frame a.
               recno = ?.
            end.
         end.

         find si_mstr  where si_mstr.si_domain = global_domain and  si_site =
         site no-lock no-error.
         if not available si_mstr then do:
            /* SITE DOES NOT EXIST */
            {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
            next-prompt site with frame a.
            undo, retry.
         end.

         if si_db <> global_db then do:
            /* SITE IS NOT ASSIGNED TO THIS DOMAIN */
            {pxmsg.i &MSGNUM=6251 &ERRORLEVEL=3}
            next-prompt site with frame a.
            undo, retry.
         end.

         {gprun.i ""gpsiver.p""
            "(input site, input recid(si_mstr), output return_int)"}
         if return_int = 0 then do:
            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
            /* USER DOES NOT HAVE ACCESS TO THIS SITE */
            next-prompt site with frame a.
            undo mainloop, retry mainloop.
         end.

         if transtype <> "SC"
            and csset = ""
         then do:
            if si_cur_set > "" then csset = si_cur_set.
            else csset = icc_cur_set.
            display csset with frame a.
         end.
      end.

      seta2:
      do transaction on error undo, retry:

         set csset with frame a
         editing:
            /* FIND NEXT/PREVIOUS RECORD */
            if transtype = "SC" then do:
               {mfnp01.i cs_mstr csset cs_set ""SIM""  " cs_mstr.cs_domain =
               global_domain and cs_type "  cs_type}
            end.
            else do:
               {mfnp.i cs_mstr csset  " cs_mstr.cs_domain = global_domain and
               cs_set "  csset cs_set cs_set}
            end.
            if recno <> ? then do:
               csset = cs_set.
               display csset with frame a.
               find cs_mstr  where cs_mstr.cs_domain = global_domain and
               cs_set = csset no-lock no-error.
               method = "".
               if available cs_mstr then do:
                  method = "[ " + cs_method + " / " + cs_type + " ]".
                  display cs_desc method with frame a.
               end.
               recno = ?.
            end.
         end.

         if csset = "" then do:
            {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
            /* BLANK NOT ALLOWED */
            next-prompt csset.
            undo, retry.
         end.

         find cs_mstr  where cs_mstr.cs_domain = global_domain and  cs_set =
         csset no-lock no-error.
         if not available cs_mstr then do:
            {pxmsg.i &MSGNUM=5407 &ERRORLEVEL=3}
            /* COST SET DOES NOT EXIST */
            next-prompt csset.
            undo, retry.
         end.

         if transtype = "SC" then do:
            if not can-find(first cs_mstr  where cs_mstr.cs_domain =
            global_domain and  cs_set = csset
               and cs_type = "SIM" ) then do:
               {pxmsg.i &MSGNUM=5405 &ERRORLEVEL=3}
               /* NOT A SIMULATION COST SET */
               next-prompt csset.
               undo, retry.
            end.
         end.

         method = "[ " + cs_method + " / " + cs_type + " ]".
         display cs_desc method with frame a.
         if cs_method = "AVG" and cs_type = "CURR" then do:
            {pxmsg.i &MSGNUM=5419 &ERRORLEVEL=2}
            /* ROLL-UP WILL INVALIDATE AVG COST */
         end.
         else if cs_method = "AVG" and cs_type = "GL" then do:
            {pxmsg.i &MSGNUM=5419 &ERRORLEVEL=4}
            /* ROLL-UP WILL INVALIDATE AVG COST */
            next-prompt csset.
            undo, retry.
         end.
      end.

      status input.
      update
         part part1
         line line1
         type type1
         grp grp1
         eff_date
         mtl_flag
         lbr_flag
         bdn_flag
         ovh_flag
         sub_flag
         labor_flag
         setup_flag
         audit_yn
         cst_flag
         yield_flag
      with frame a.

   end. /*if not batchrun*/

   else do:
      update
         site
         csset
         part part1
         line line1
         type type1
         grp grp1
         eff_date
         mtl_flag
         lbr_flag
         bdn_flag
         ovh_flag
         sub_flag
         labor_flag
         setup_flag
         audit_yn
         cst_flag
         yield_flag
      with frame a.
      find si_mstr  where si_mstr.si_domain = global_domain and  si_site = site
      no-lock no-error.
   end.

   bcdparm = "".
   {gprun.i ""gpquote.p"" "(input-output bcdparm,
                     20,
                     site,
                     csset,
                     part,
                     part1,
                     line,
                     line1,
                     type,
                     type1,
                     grp,
                     grp1,
                     string(eff_date),
                     string(mtl_flag),
                     string(lbr_flag),
                     string(bdn_flag),
                     string(ovh_flag),
                     string(sub_flag),
                     string(labor_flag),
                     string(setup_flag),
                     string(audit_yn),
                     string(cst_flag))"}

   {gprun.i ""gpquote.p"" "(input-output bcdparm,
                     1,
                     string(yield_flag),
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char)"}

   if part1 = "" then part1 = hi_char.
   if line1 = "" then line1 = hi_char.
   if type1 = "" then type1 = hi_char.
   if grp1 = "" then grp1 = hi_char.

   if eff_date = ?
   then do:
      eff_date =  today.
      display eff_date with frame a.
   end. /* IF eff_date ... */

   /*****************************************************************/
   /*ADDED THE FOLLOWING SECTION IN ORDER TO GENERATE A UNIQUE ID   */
   /*SO THAT ONCE AN ITEM IS ROLLED UP, IT WILL NOT BE ROLLED UP    */
   /*MULTIPLE TIMES.  SIMULTANEOUS ROLLUPS WITH THE SAME EFFECTIVE  */
   /*DATE AND FLAG SETTINGS WILL SHARE THIS UNIQUE ID.  SIMULTANEOUS*/
   /*ROLLUPS FOR THE SAME SITE/COSTSET WITH DIFFERENT EFFECTIVITIES */
   /*AND/OR FLAGS ARE PROHIBITED.                                   */
   /*****************************************************************/

   /*OUTER ERROR LOOP RETRY'S EVEN THOUGH NOTHING CHANGES*/
   transloop:
   repeat:

      /*ERROR WHEN TWO PROCESSES CREATE SIMULTANEOUS QAD_WKFL*/
      repeat transaction on error undo, retry:
         pause 0.
         hide message no-pause.

         /*DELETE THE NON-ACTIVE QAD_WKFL, IF ONE EXISTS*/

         /* IF NOT ORACLE THE FIND QAD_WKFL RECORD WITH EXCL-LOCK */
         if l_is_oracle = no then
         do:
            find qad_wkfl exclusive-lock
                where qad_wkfl.qad_domain = global_domain and  qad_key1 =
                "BMCSRUB"
               and qad_key2 = site + "::" + csset
               no-error no-wait.
            if available qad_wkfl then delete qad_wkfl.
         end. /* IF L_IS_ORACLE = NO */

         /*FIND THE ACTIVE QAD_WKFL, IF ONE EXISTS*/
         for first qad_wkfl
            where qad_wkfl.qad_domain = global_domain
            and   qad_key1            = "BMCSRUB"
            and   qad_key2            = site + "::" + csset no-lock :
         end. /* FOR FIRST qad_wkfl */


         /*TEST TO ENSURE CONFLICT CONDITIONS DON'T EXIST*/
         if available qad_wkfl and
            (   qad_datefld[1] <> eff_date
            or qad_decfld[1] <> integer(mtl_flag)
            or qad_decfld[2] <> integer(lbr_flag)
            or qad_decfld[3] <> integer(bdn_flag)
            or qad_decfld[4] <> integer(ovh_flag)
            or qad_decfld[5] <> integer(sub_flag)
            or qad_decfld[6] <> integer(labor_flag)
            or qad_decfld[7] <> integer(setup_flag)
            or qad_decfld[8] <> integer(cst_flag)
            or qad_decfld[9] <> integer(yield_flag))
         then do:

            do on endkey undo mainloop, retry mainloop:
               if l_is_oracle = yes then do on error undo, retry:

                  /* ARE MULTIPLE SESSIONS ROLLING COSTS  */
                  /* FOR THE SAME SITE/COST SET?          */
               {pxmsg.i &MSGNUM=3336 &ERRORLEVEL=1
                        &CONFIRM=yn  &CONFIRM-TYPE='LOGICAL'}
                  if yn = no then do:
                     find qad_wkfl exclusive-lock
                         where qad_wkfl.qad_domain = global_domain and
                         qad_key1 = "BMCSRUB"
                        and   qad_key2 = site + "::" + csset
                        no-error no-wait.
                     if available qad_wkfl then delete qad_wkfl.
                     else yn = yes.
                  end. /* IF YN = NO */

               end. /* IF L_IS_ORACLE = YES */
            end. /* ON ENDKEY UNDO MAINLOOP, RETRY MAINLOOP */

            if l_is_oracle = no or yn = yes  then do:
               /* CONFLICTING ROLLUP IN PROGRESS */
               {pxmsg.i &MSGNUM=5306 &ERRORLEVEL=4}
               undo mainloop, retry.
            end. /* IF L_IS_ORACLE = NO OR YN = YES */

         end. /* IF AVAILABLE QAD_WKFL */

         /*FIRST PROCESS CREATES NEW QAD_WKFL*/

         if not available qad_wkfl then do:
            create qad_wkfl. qad_wkfl.qad_domain = global_domain.
            assign
               qad_key1       = "BMCSRUB"
               qad_key2       = site + "::" + csset
               qad_datefld[1] = eff_date
               qad_decfld[1]  = integer(mtl_flag)
               qad_decfld[2]  = integer(lbr_flag)
               qad_decfld[3]  = integer(bdn_flag)
               qad_decfld[4]  = integer(ovh_flag)
               qad_decfld[5]  = integer(sub_flag)
               qad_decfld[6]  = integer(labor_flag)
               qad_decfld[7]  = integer(setup_flag)
               qad_decfld[8]  = integer(cst_flag)
               qad_charfld[1] = mfguser
               qad_decfld[9]  = integer(yield_flag)

               /*PROGRAM DEFINED DATE FORMAT TO AVOID CONFLICT BETWEEN */
               /*USERS WITH A DIFFERENT -d DATE DEFAULT                */
               qad_key3 = substring(string(year(today),"9999"),3,2)
                        + string(month(today),"99")
                        + string(day(today),"99")
                        + " "
                        + string(time).

         end.

         rollup_id = qad_key3.
         release qad_wkfl.
         leave transloop.

      end.

      hide message no-pause.
      pause 0.

   end.

   if audit_yn then do:
      /* OUTPUT DESTINATION SELECTION */
      {gpselout.i &printType = "printer"
                  &printWidth = 132
                  &pagedFlag = " "
                  &stream = " "
                  &appendToFile = " "
                  &streamedOutputToTerminal = " "
                  &withBatchOption = "yes"
                  &displayStatementType = 1
                  &withCancelMessage = "yes"
                  &pageBottomMargin = 6
                  &withEmail = "yes"
                  &withWinprint = "yes"
                  &defineVariables = "yes"}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

      {mfphead.i}
   end.
   else if not batchrun then do:
      yn = yes.
      /* BEGIN COST ROLL-UP ? */
      {pxmsg.i &MSGNUM=207 &ERRORLEVEL=1 &CONFIRM=yn
         &CONFIRM-TYPE='LOGICAL'}
      if not yn then undo, retry.
   end.

   {gprun.i ""bmcsrub.p""}


   global_type = "".

   /* REPORT TRAILER  */
   if audit_yn then do:
      {mfrtrail.i}
   end.

   /*SCOPE QAD_WKFL TO MAINLOOP*/

   do transaction:
      find qad_wkfl
          where qad_wkfl.qad_domain = global_domain and  qad_key1       =
          "BMCSRUB" and
         qad_key2       = site + "::" + csset and
         qad_key3       = rollup_id and
         qad_charfld[1] = mfguser
         exclusive-lock no-error.
      if available qad_wkfl then
            delete qad_wkfl.
   end. /* DO TRANSACTION */

   release qad_wkfl.

end.
