/* GUI CONVERTED from yy000203.p (converter v1.78) Mon Oct  8 11:33:50 2012 */
/* icsiiq.p - SITE INQUIRY                                                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.12 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 6.0          LAST EDIT: 02/07/90   MODIFIED BY: EMB              */
/* REVISION: 6.0          LAST EDIT: 09/03/91   BY: afs *D847*                */
/* Revision: 7.3          Last edit: 11/19/92   By: jcd *G339*                */
/*           7.3                     09/10/94   BY: bcm *GM02*                */
/*           7.3                     03/15/95   by: str *F0N1*                */
/* REVISION: 8.6          LAST EDIT: 03/09/98   BY: *K1KX* Beena Mol          */
/* REVISION: 8.6          LAST EDIT: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6          LAST EDIT: 06/02/98   BY: *K1RQ* A.Shobha           */
/* REVISION: 9.0          LAST EDIT: 03/10/99   BY: *M0B8* Hemanth Ebenezer   */
/* REVISION: 9.0          LAST EDIT: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.12 $    BY: Jean Miller          DATE: 04/06/02  ECO: *P056*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "121008.1"}


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
/* 过期物料列表 */
DEFINE variable v_Exp_item_key as character initial "yy000201.p.exp.item".
/* 过期库存 */
DEFINE variable v_Exp_in_key as character initial "yy000201.p.exp.in".

DEFINE VARIABLE v_site1 LIKE si_site NO-UNDO.
DEFINE VARIABLE v_site2 LIKE si_site NO-UNDO.
DEFINE VARIABLE v_part1 LIKE pt_part NO-UNDO.
DEFINE VARIABLE v_part2 LIKE pt_part NO-UNDO.
DEFINE VARIABLE v_pline1 LIKE pt_prod_line NO-UNDO.
DEFINE VARIABLE v_pline2 LIKE pt_prod_line NO-UNDO.
DEFINE VARIABLE v_type1 LIKE pt_part_type NO-UNDO.
DEFINE VARIABLE v_type2 LIKE pt_part_type NO-UNDO.
DEFINE VARIABLE v_group1 LIKE pt_group NO-UNDO.
DEFINE VARIABLE v_group2 LIKE pt_group NO-UNDO.
DEFINE VARIABLE v_effdate AS DATE INITIAL TODAY.
DEFINE VARIABLE v_days AS INTEGER NO-UNDO INITIAL 365.
DEFINE VARIABLE v_costflag like mfc_logical no-undo initial yes.
DEFINE VARIABLE v_ditem like mfc_logical NO-UNDO.
define new shared variable v_rptfmt like mfc_logical
   label "1-stdout/2-browseout" format "1-stdout/2-browseout".

 DEFINE TEMP-TABLE xtplink
    FIELDS xtp_part LIKE pt_part LABEL "零件号"
    FIELDS xtp_site  AS CHARACTER LABEL "地点"
    FIELDS xtp_desc1 LIKE pt_desc1 COLUMN-LABEL "描述(中文)"
    FIELDS xtp_desc2 LIKE pt_desc1 COLUMN-LABEL "描述(英文)"
    FIELDS xtp_line AS INTEGER LABEL "项"
    FIELDS xtp_buyer LIKE pt_buyer
    FIELDS xtp_cst LIKE sct_cst_tot
    FIELDS xtp_qty_oh LIKE IN_qty_oh LABEL "当前库存量"
    FIELDS xtp_amt_oh AS DECIMAL FORMAT "->>>>>>>>9.9<<<<<<<" LABEL "当前库存值"
    FIELDS xtp_amt AS DECIMAL FORMAT "->>>>>>>>9.9<<<<<<<" LABEL "准备计提金额"
    FIELDS xtp_last_stat AS LOGICAL LABEL "上次判定结果"
    FIELDS xtp_rmks AS CHARACTER FORMAT "x(40)" LABEL "说明"
     INDEX xtp_part_site IS PRIMARY xtp_part xtp_site
     INDEX xtp_site_part xtp_site xtp_part.


    DEF VAR h-tt AS HANDLE.
    h-tt = TEMP-TABLE xtplink:HANDLE.


FORM /*GUI*/

 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
space(1)
   v_site1 COLON 20 v_site2 COLON 48 LABEL {t001.i}
   v_part1 COLON 20 v_part2 COLON 48 LABEL {t001.i}
   v_pline1 COLON 20 v_pline2 COLON 48 LABEL {t001.i}
   v_type1 COLON 20 v_type2 COLON 48 LABEL {t001.i}
   v_group1 COLON 20 v_group2 COLON 48 LABEL {t001.i}
   v_effdate COLON 20
   v_days COLON 20
   v_costflag colon 20
   v_rptfmt COLON 20 SKIP(1)
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

   EMPTY TEMP-TABLE xtplink NO-ERROR.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:
    IF v_site2 = hi_char THEN v_site2 = "".
    IF v_part2 = hi_char THEN v_part2 = "".
    IF v_pline2 = hi_char THEN v_pline2 = "".
    IF v_type2 = hi_char THEN v_type2 = "".
    IF v_group2 = hi_char THEN v_group2 = "".

   DISPLAY v_effdate v_days WITH FRAME a.
   UPDATE v_site1 v_site2 v_part1 v_part2 v_pline1 v_pline2 v_type1 v_type2
          v_group1 v_group2 v_effdate v_days v_costflag v_rptfmt WITH FRAME a.
   {wbrp06.i &command = prompt-for &fields = " v_site1 v_site2 v_part1 v_part2
          v_pline1 v_pline2 v_type1 v_type2 v_group1 v_group2 v_effdate 
          v_days v_costflag v_rptfmt"
             &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

     IF v_site2 = "" THEN v_site2 = hi_char.
     IF v_part2 = "" THEN v_part2 = hi_char.
     IF v_pline2 = "" THEN v_pline2 = hi_char.
     IF v_type2 = "" THEN v_type2 = hi_char.
     IF v_group2 = "" THEN v_group2 = hi_char.
      hide frame b.

   end.
   for each usrw_wkfl exclusive-lock where usrw_domain = global_domain and
           (usrw_key1 = v_Exp_item_key OR usrw_key1 = v_Exp_in_key):
       delete usrw_wkfl.
   end.
   FOR EACH IN_mstr NO-LOCK WHERE in_domain = global_domain
        AND IN_site >= v_site1 AND IN_site <= v_site2
        AND IN_part >= v_part1 AND IN_part <= v_part2,
       EACH pt_mstr NO-LOCK WHERE pt_domain = global_domain
        AND pt_part = IN_part
        AND pt_prod_line >= v_pline1 AND pt_prod_line <= v_pline2
        AND pt_part_type >= v_type1 AND pt_part_type <= v_type2
        AND pt_group >= v_group1 AND pt_group <= v_group2
       BREAK BY IN_part BY IN_site:
       IF FIRST-OF(IN_part) THEN DO:
           ASSIGN v_ditem = FALSE.
           FIND first tr_hist NO-LOCK WHERE tr_domain = global_domain
           				and tr_part = pt_part
                  and tr_effdate >= v_effdate - v_days
                  AND (tr_type = "ISS-SO" or tr_type = "ISS-WO" or
                       tr_type = "ISS-UNP" or tr_type = "ISS-FAS")
           use-index tr_part_eff NO-ERROR.
           IF not available tr_hist THEN do:
               FIND FIRST xtplink EXCLUSIVE-LOCK WHERE xtp_part = pt_part NO-ERROR.
               IF NOT AVAILABLE xtplink THEN DO:
                  {gpsct03.i &cost=sct_cst_tot}
                   create usrw_wkfl. usrw_domain = global_domain.
                   assign usrw_key1 = v_Exp_item_key
                          usrw_key2 = in_part
                          usrw_decfld[1] = glxcst.
                   v_ditem = TRUE.
               END.
           end.
       END. /* IF FIRST-OF(IN_part) THEN DO: */
       IF v_ditem THEN DO:
           find first xtplink exclusive-lock where xtp_part = in_part
                  and xtp_site = in_site no-error.
           if not available xtplink then do:
              CREATE xtplink.
              ASSIGN xtp_part = in_part
                     xtp_site = in_site.
           end.
           ASSIGN xtp_cst = glxcst
                  xtp_desc1 = pt_desc2
                  xtp_desc2 = pt_desc1
                  xtp_buyer = pt_buyer
                  xtp_qty_oh = IN_qty_oh
                  xtp_amt_oh = glxcst  * IN_qty_oh
                  xtp_amt =  glxcst  * IN_qty_oh
                  xtp_last_stat = YES WHEN substring(IN_user2,1,1) = "Y"
                  xtp_rmks = SUBSTRING(IN_user2,3).
                  .

           FIND FIRST usrw_wkfl EXCLUSIVE-LOCK WHERE usrw_domain = global_domain
                  AND usrw_key1 = v_Exp_in_key
                  AND usrw_key2 = in_site + "@" + in_part NO-ERROR.
           IF NOT AVAILABLE usrw_wkfl THEN DO:
               CREATE usrw_wkfl. usrw_domain = global_domain.
               ASSIGN usrw_key1 = v_Exp_in_key
                      usrw_key2 = in_site + "@" + in_part.
           END.
               ASSIGN usrw_key3 = IN_part
                      usrw_key4 = IN_site
                      usrw_charfld[1] = pt_desc2
                      usrw_charfld[2] = pt_desc1
                      usrw_charfld[3] = pt_buyer
                      usrw_decfld[1] = glxcst
                      usrw_decfld[2] = IN_qty_oh
                      usrw_decfld[3] = glxcst * IN_qty_oh
                      usrw_logfld[1] = YES WHEN substring(IN_user2,1,1) = "Y"
                      usrw_charfld[4] = SUBSTRING(IN_user2,3).
       END.
   END.

     RUN value(lc(global_user_lang) + "\yy\yyut2browse.p") (INPUT-OUTPUT TABLE-HANDLE h-tt,
                                         INPUT "yy000201",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "").

/*                                                                          */
/*    /* OUTPUT DESTINATION SELECTION */                                    */
   {gpselout.i &printType = "terminal"
               &printWidth = 220
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   for each xtplink NO-LOCK WITH FRAME c WIDTH 220 down:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

      DISPLAY xtplink WITH STREAM-IO /*GUI*/ .
   end.

   {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
/*                                                                                                    */
/*    {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}                                                               */
/*                                                                                                    */
end.

{wbrp04.i &frame-spec = a}

