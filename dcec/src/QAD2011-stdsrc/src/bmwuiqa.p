/* GUI CONVERTED from bmwuiqa.p (converter v1.78) Wed Sep 28 23:41:07 2011 */
/* bmwuiqa.p - WHERE-USED INQUIRY                                       */
/* Copyright 1986-2011 QAD Inc., Santa Barbara, CA, USA.                */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* REVISION: 1.0      LAST EDIT:     06/11/86   BY: EMB                 */
/* REVISION: 2.1      LAST EDIT:     09/02/87   BY: WUG *A94*           */
/* REVISION: 4.0      LAST EDIT:     12/30/87   BY: WUG *A137*          */
/* REVISION: 4.0      LAST EDIT:     04/28/88   BY: EMB                 */
/* REVISION: 5.0      LAST EDIT:     05/03/89   BY: WUG *B098*          */
/* REVISION: 5.0      LAST EDIT:     08/16/90   BY: WUG *D051*          */
/* REVISION: 6.0      LAST EDIT:     01/07/91   BY: bjb *D248*          */
/* REVISION: 7.2      LAST MODIFIED: 11/02/92   BY: pma *G265*          */
/* REVISION: 7.3      LAST MODIFIED: 10/26/93   BY: ais *GG68*          */
/* REVISION: 7.3      LAST MODIFIED: 12/20/93   BY: ais *GH69*          */
/* REVISION: 7.3      LAST MODIFIED: 12/29/93   BY: ais *FL07*          */
/* REVISION: 8.6      LAST MODIFIED: 10/15/97   BY: mur *K124*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan    */
/* REVISION: 9.0      LAST MODIFIED: 07/30/99   BY: *J3J4* Jyoti Thatte  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 07/04/00   BY: *N0F3* Rajinder Kamra    */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Old ECO marker removed, but no ECO header exists *G345*                   */
/* Revision: 1.9.1.8  BY: Falguni                DATE: 06/28/01  ECO: *M1C6*  */
/* Revision: 1.9.1.10 BY: Subashini Bala         DATE: 01/29/02  ECO: *N18L*  */
/* Revision: 1.9.1.11 BY: Ashish Kapadia         DATE: 06/12/02  ECO: *N1L7*  */
/* Revision: 1.9.1.12 BY: Ashish Maheshwari      DATE: 11/08/02  ECO: *N1Z4*  */
/* Revision: 1.9.1.13 BY: Vinod Nair             DATE: 11/19/02  ECO: *N1ZW*  */
/* Revision: 1.9.1.14 BY: Deepali Kotavadekar    DATE: 03/28/03  ECO: *P0PD*  */
/* Revision: 1.9.1.16 BY: Paul Donnelly (SB)     DATE: 06/26/03  ECO: *Q00B*  */
/* Revision: 1.9.1.17 BY: Manish Dani            DATE: 04/15/04  ECO: *P1TV*  */
/* Revision: 1.9.1.18 BY: Reena Ambavi           DATE: 07/06/04  ECO: *P28F*  */
/* Revision: 1.9.1.19 BY: Bhavik Rathod          DATE: 03/29/05  ECO: *P3DH*  */
/* Revision: 1.9.1.20 BY: SurenderSingh Nihalani DATE: 07/13/05  ECO: *P3T5*  */
/* Revision: 1.9.1.21 BY: Tejasvi Kulkarni       DATE: 10/17/05  ECO: *P452*  */
/* Revision: 1.9.1.22 BY: Preeti Sattur          DATE: 07/12/06  ECO: *P4X5*  */
/* Revision: 1.9.1.23 BY: Ambrose Almeida        DATE: 12/15/06  ECO: *P5JJ*  */
/* Revision: 1.9.1.24 BY: Ambrose Almeida        DATE: 03/24/08  ECO: *Q1K6*  */
/* Revision: 1.9.1.24.1.1 BY: Ambrose Almeida    DATE: 04/11/08  ECO: *Q1KW*  */
/* Revision: 1.9.1.24.1.2 BY: Ambrose Almeida    DATE: 07/28/10  ECO: *Q49C*  */
/* $Revision: 1.9.1.24.1.3 $  BY: Tushar Shetty     DATE: 09/28/11  ECO: *Q51P*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/****************************************************************************/
/*             THIS PROGRAM COMBINES BMWUIQ.P & FMWUIQ.P                    */
/*       BOTH PROGRAMS NAMED THE DETAIL FRAME 'HEADING";  THIS              */
/*       COMBIND PROGRAM USES FRAMES BM & FM.  WHERE THESE FRAME            */
/*       NAMES ARE USED, THE PREVIOUS PROGRAMS USED 'HEADING'               */
/****************************************************************************/
/*V8:ConvertMode=Report                                                     */

/* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "1+ "}

define shared variable transtype as character format "x(4)".
define variable comp like ps_comp.
define variable level as integer.
define variable maxlevel as integer format ">>>" label "Levels".
define variable eff_date as date column-label "As Of".
define variable parent    like ps_comp.
define variable l_parent1 like ps_comp no-undo.
define variable desc1 like pt_desc1.
define variable um like pt_um.
define variable phantom like mfc_logical initial true label "Ph".
define variable iss_pol like pt_iss_pol  initial false no-undo.
define variable record as integer extent 100.
define variable lvl as character format "x(7)" label "Level".

define variable l_phantom as   character      format "x(3)" label "Pha" no-undo.
define variable l_iss_pol as   character      format "x(3)" label "Iss" no-undo.
define variable l_leave   like mfc_logical    initial no    no-undo.

define temp-table item-bom no-undo
   field  item like pt_part
   field  bom  like pt_bom_code
   field  par  like ps_par
   field  ref  like ps_ref
   index  item-bom-par is unique item bom par ref.



/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   parent
   desc1
   um
   eff_date
   maxlevel
with frame a width 80 attr-space no-underline THREE-D /*GUI*/.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* INTRODUCED VARIABLE l_parent1 TO BE USED INSTEAD OF VARIABLE parent IN */
/* WEB APPLICATION MODE TO AVOID CONFLICT OF VALUE OF parent IN BOTH THE  */
/* FRAMES                                                                 */
FORM /*GUI*/ 
   l_parent1
   desc1
   um
   eff_date at 60
   maxlevel label "            Levels"
with STREAM-IO /*GUI*/  frame a1 width 90 attr-space no-underline.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a1:handle).

/*DETAIL FORM (BM)*/
FORM /*GUI*/ 
   lvl
   ps_par
   desc1
   ps_qty_per
   um
   l_phantom format "x(3)"
   ps_ps_code
   l_iss_pol format "x(3)"
with STREAM-IO /*GUI*/  frame bm width 80 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame bm:handle).

assign
   l_phantom:label in frame bm = GetTermLabel("PHANTOM",3)
   l_iss_pol:label in frame bm = GetTermLabel("ISSUE_POLICY",3).

/*DETAIL FORM (FM)*/
FORM /*GUI*/ 
   lvl
   ps_par
   desc1
   ps_qty_per_b
   ps_qty_type
   um
   l_phantom format "x(3)"
   ps_ps_code
with STREAM-IO /*GUI*/  frame fm width 80 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame fm:handle).

l_phantom:label in frame fm = GetTermLabel("PHANTOM",3).

eff_date = today.

/* SET PARENT TO GLOBAL PART NUMBER */
parent = global_part.

{wbrp02.i}

if c-application-mode = 'WEB'
then
   assign
      l_parent1   = global_part
      desc1:label = ""
      um:label    = "".

repeat:

   if c-application-mode <> 'web'
   then
      update
         parent
         eff_date
         maxlevel
      with frame a editing:

      if frame-field = "parent"
      then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i ps_mstr parent  " ps_mstr.ps_domain = global_domain
                                   and ps_comp "  parent ps_comp ps_comp}

         if recno <> ?
         then do:

            assign
               parent:screen-value  = ps_comp
               parent  = ps_comp
               desc1   = "".

            find pt_mstr
               where pt_mstr.pt_domain = global_domain
               and   pt_part = parent
               no-lock no-error.

            if available pt_mstr
            then
               desc1 = pt_desc1.
            else do:
               find bom_mstr
                  where bom_mstr.bom_domain = global_domain
                  and   bom_parent = parent
                  no-lock no-error.

               if available bom_mstr
               then
                  desc1 = bom_desc.
            end.

            display parent desc1 with frame a.
            recno = ?.

         end.  /* IF recno <> ? */
      end. /* IF frame-field = "parent" */
      else do:

         status input.
         readkey.
         apply lastkey.

      end. /* ELSE DO */
   end. /* IF c-application-mode <> 'web' */

   {wbrp06.i
      &command = update
      &fields = "l_parent1 eff_date maxlevel"
      &frm = "a1"}

   empty temp-table item-bom.
   clear frame bm all no-pause.
   clear frame fm all no-pause.

   if c-application-mode = 'web'
   then
      parent = l_parent1.

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      assign
         desc1 = ""
         um    = ""
         parent
         l_parent1.

      find pt_mstr
         use-index pt_part
         where pt_mstr.pt_domain = global_domain
         and   pt_part = parent
         no-lock no-error.

      if not available pt_mstr
      then do:

         find bom_mstr
            where bom_mstr.bom_domain = global_domain
            and  bom_parent = parent
            no-lock no-error.

         if not available bom_mstr
         then do:

            hide message no-pause.
            {pxmsg.i &MSGNUM=17 &ERRORLEVEL=3}
            display desc1 um with frame a.
            if c-application-mode = 'web'
            then
               return.
            undo, retry.

         end.

         assign
            um        = bom_batch_um
            desc1     = bom_desc
            parent    = bom_parent
            l_parent1 = parent.

      end. /* IF NOT AVAILABLE pt_mstr */
      else
         assign
            desc1     = pt_desc1
            um        = pt_um
            parent    = pt_part
            l_parent1 = parent.

      display parent desc1 um with frame a.

      hide frame bm.
      hide frame fm.

   end. /* IF (c-application-mode <> 'web') OR... */

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i
      &printType = "terminal"
      &printWidth = 80
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

   assign
      level     = 0
      comp      = parent
      maxlevel  = min(maxlevel,99)
      level     = 1.

   for first ps_mstr
      use-index ps_comp
      where ps_domain  = global_domain
      and   ps_comp    = comp
      and  ((ps_start <= eff_date and
             ps_end    = ?)
         or (ps_start  = ?        and
             ps_end   >= eff_date)
         or (ps_start  = ?        and
             ps_end    = ?)
         or (ps_start <= eff_date and
             ps_end   >= eff_date)
         or  eff_date  = ?)
   no-lock :
   end.  /* FOR FIRST ps_mstr */

   repeat:

      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/


      if not available ps_mstr
      then do:

         repeat:

            level = level - 1.
            if level < 1
            then
               leave.

            find ps_mstr
               where recid(ps_mstr) = record[level]
               no-lock no-error.

            if available ps_mstr
            then
               comp = ps_par.

            run p_find_ptp_det(input false,
                               input true).


            if available ps_mstr
            then do:

               run p_find_ptp_det(input true,
                                  input false).

                level = level + 1.
                leave.

            end. /* IF AVAIL ps_mstr */

            find ps_mstr
               where recid(ps_mstr) = record[level]
               no-lock no-error.

            if available ps_mstr
            then
               comp = ps_comp.

            find next ps_mstr
               use-index ps_comp
               where ps_domain  = global_domain
               and   ps_comp    = comp
               and  ((ps_start <= eff_date and
                      ps_end    = ?)
                  or (ps_start  = ?        and
                      ps_end   >= eff_date)
                  or (ps_start  = ?        and
                      ps_end    = ?)
                  or (ps_start <= eff_date and
                      ps_end   >= eff_date)
                  or  eff_date  = ?)
               no-lock no-error.

            if available ps_mstr
            then do:

               run p_find_ptp_det(input false,
                                  input false).

               leave.

            end.  /* IF AVAILABLE ps_mstr */

         end. /* REPEAT */

      end. /* IF NOT AVAILABLE ps_mstr */

      if level < 1
      then
         leave.

      if available ps_mstr
         and (eff_date = ?
                or (eff_date <> ?
                      and (ps_start = ?
                         or ps_start <= eff_date)
                      and (ps_end = ?
                         or eff_date <= ps_end)
                   )
             )
      then do:

         assign
            desc1 = ""
            um    = ""
            iss_pol = no
            phantom = no.

         find pt_mstr
            where pt_mstr.pt_domain = global_domain
            and   pt_part = ps_par
            no-lock no-error.

         if available pt_mstr
         then
            assign
               desc1   = pt_desc1
               um      = pt_um
               iss_pol = pt_iss_pol
               phantom = pt_phantom.
         else do:

            find bom_mstr
               where bom_mstr.bom_domain = global_domain
               and   bom_parent = ps_par
               no-lock no-error.

            if available bom_mstr
            then
               assign
                  um    = bom_batch_um
                  desc1 = bom_desc.
         end. /* ELSE DO */

         if phantom
         then
            l_phantom  = getTermLabel("Yes",3).
         else
            l_phantom =  getTermLabel("No",3).

         if iss_pol
         then
            l_iss_pol  = getTermLabel("Yes",3).
         else
            l_iss_pol =  getTermLabel("No",3).

         assign
            record[level] = recid(ps_mstr)
            lvl           = "......."
            lvl           = substring(lvl,1,min(level - 1,6))
                               + string(level).

         if length(lvl) > 7
         then
            lvl = substring(lvl,length(lvl) - 6,7).

         if transtype = "BM"
         then do with frame bm down:

            if frame-line = frame-down and frame-down <> 0
               and available pt_mstr and pt_desc2 > ""
            then
               down 1 with frame bm.

            display
               lvl
               ps_par
               desc1
               ps_qty_per
               um
               l_phantom format "x(3)"
               ps_ps_code
               l_iss_pol format "x(3)"
            with frame bm STREAM-IO /*GUI*/ .

            if available bom_mstr and not available pt_mstr
            then
               display
                  getTermLabel("BOM",3) format "x(3)" @ l_phantom
               with frame bm STREAM-IO /*GUI*/ .

            down 1 with frame bm.

            if  available pt_mstr
            and pt_desc2 > ""
            then do with frame bm:
               display pt_desc2 @ desc1 WITH STREAM-IO /*GUI*/ .
               down 1.
            end.
         end.
         else do with frame fm down:

            if frame-line = frame-down and frame-down <> 0
               and available pt_mstr and pt_desc2 > ""
            then
               down 1 with frame fm.

            display
               lvl
               ps_par
               desc1
               ps_qty_per_b
               ps_qty_type
               um
               l_phantom format "x(3)"
               ps_ps_code
            with frame fm STREAM-IO /*GUI*/ .

            if available bom_mstr and not available pt_mstr
            then
               display
                  getTermLabel("BOM",3) format "x(3)" @ l_phantom
               with frame fm STREAM-IO /*GUI*/ .

            down 1 with frame fm.

            if available pt_mstr and pt_desc2 > ""
            then do with frame fm:
               display pt_desc2 @ desc1 WITH STREAM-IO /*GUI*/ .
               down 1.
            end.
         end. /* ELSE DO WITH FRAME fm DOWN */

         if level < maxlevel or maxlevel = 0
         then do:

            assign
               comp = ps_par
               level = level + 1.

            for first ps_mstr
               use-index ps_comp
               where ps_domain  = global_domain
               and   ps_comp    = comp
               and  ((ps_start <= eff_date and
                      ps_end    = ?)
                  or (ps_start  = ?        and
                      ps_end   >= eff_date)
                  or (ps_start  = ?        and
                      ps_end    = ?)
                  or (ps_start <= eff_date and
                      ps_end   >= eff_date)
                  or  eff_date  = ?)
            no-lock :
            end. /* FOR FIRST ps_mstr */

            if available ps_mstr
            then
               run p_find_ptp_det(input false,
                                  input false).

         end. /* IF level < maxlevel OR maxlevel = 0 */
         else do:

            find next ps_mstr
               use-index ps_comp
               where ps_domain  = global_domain
               and   ps_comp    = comp
               and  ((ps_start <= eff_date and
                      ps_end    = ?)
                  or (ps_start  = ?        and
                      ps_end   >= eff_date)
                  or (ps_start  = ?        and
                      ps_end    = ?)
                  or (ps_start <= eff_date and
                      ps_end   >= eff_date)
                  or  eff_date  = ?)
               no-lock no-error.

            if not available ps_mstr
            then do:
               if level <> 1
               then
                  run p_find_ptp_det(input false,
                                     input true).
            end. /* IF NOT AVAILABLE ps_mstr */
            else
               run p_find_ptp_det(input false,
                                  input false).

         end. /* ELSE DO */
      end. /* IF AVAILABLE ps_mstr */
      else
         find next ps_mstr
            use-index ps_comp
            where ps_domain  = global_domain
            and   ps_comp    = comp
            and  ((ps_start <= eff_date and
                   ps_end    = ?)
               or (ps_start  = ?        and
                   ps_end   >= eff_date)
               or (ps_start  = ?        and
                   ps_end    = ?)
               or (ps_start <= eff_date and
                   ps_end   >= eff_date)
               or  eff_date  = ?)
            no-lock no-error.

   end. /* REPEAT */

   {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end. /* REPEAT */

global_part = parent.

if c-application-mode = 'web'
then
   global_part = l_parent1.

{wbrp04.i &frame-spec = a1}


/* GO THRU ITEM PLANNING DETAIL TABLE TO FIND THE PART */
/* AND THEN CHECK FOR ITS BOM                          */
procedure p_find_ptp_det:

   define input  parameter ip-check-level   like mfc_logical no-undo.
   define input  parameter ip-find-psmstr   like mfc_logical no-undo.

   define variable l_ptp_avail like mfc_logical no-undo.

   l_ptp_avail = no.

   if ip-find-psmstr
   then
      find first ps_mstr
         where  recid(ps_mstr) =  -1
         no-lock no-error.

   for each ptp_det
      fields (ptp_domain ptp_bom_code ptp_part)
      where ptp_domain   = global_domain
      and   ptp_bom_code = comp
   no-lock:

      l_ptp_avail = yes.

      if ip-find-psmstr
      then do:

         for first ps_mstr
            use-index ps_comp
            where ps_domain  = global_domain
            and   ps_comp    = ptp_part
            and  ((ps_start <= eff_date and
                   ps_end    = ?)
               or (ps_start  = ?        and
                   ps_end   >= eff_date)
               or (ps_start  = ?        and
                   ps_end    = ?)
               or (ps_start <= eff_date and
                   ps_end   >= eff_date)
               or  eff_date   = ?)
            no-lock :
            end. /* FOR FIRST ps_mstr */

         if not available ps_mstr
         then
            next.

      end. /* IF ip-find-psmstr */

      run p_check_item_bom(input  ptp_part,
                           input  ptp_bom_code,
                           input  ps_mstr.ps_par,
                           input  ps_mstr.ps_ref,
                           input  ip-check-level,
                           output l_leave).
      if l_leave
      then do:

         l_leave = false.
         leave.

      end. /* IF l_leave */

   end. /* FOR EACH ptp_det */

   if not l_ptp_avail
   then do:
      for each pt_mstr
         fields(pt_domain pt_part pt_bom_code)
         where pt_domain   = global_domain
         and   pt_bom_code = comp
      no-lock:

         if ip-find-psmstr
         then do:
            for first ps_mstr
               use-index ps_comp
               where ps_domain  = global_domain
               and   ps_comp    = pt_part
               and  ((ps_start <= eff_date and
                      ps_end    = ?)
                  or (ps_start  = ?        and
                      ps_end   >= eff_date)
                  or (ps_start  = ?        and
                      ps_end    = ?)
                  or (ps_start <= eff_date and
                      ps_end   >= eff_date)
                  or  eff_date   = ?)
            no-lock:
            end. /* FOR FIRST ps_mstr */

            if not available ps_mstr
            then
               next.

         end. /* IF ip-find-psmstr */

         run p_check_item_bom(input  pt_part,
                              input  pt_bom_code,
                              input  ps_mstr.ps_par,
                              input  ps_mstr.ps_ref,
                              input  ip-check-level,
                              output l_leave).
         if l_leave
         then do:
            l_leave = false.
            leave.
         end. /* IF l_leave */
      end. /* FOR EACH pt_mstr */
   end. /* IF NOT l_ptp_avail */
end procedure. /* PROCEDURE p_find_ptp_det */


/* CHECK IF THE GIVEN COMBINATION OF PART, BOM CODE, PARENT AND  */
/* REFERENCE NUMBER IS ALREADY EXISTING. IF NOT EXISTING THEN WE */
/* CREATE THE TEMP TABLE OTHERWISE WE CLEAR THE ps_mstr BUFFER   */
procedure p_check_item_bom:

   define input  parameter ip-item          like ptp_part     no-undo.
   define input  parameter ip-bom           like ptp_bom_code no-undo.
   define input  parameter ip-par           like ps_par       no-undo.
   define input  parameter ip-ref           like ps_ref       no-undo.
   define input  parameter ip-check-level   like mfc_logical  no-undo.
   define output parameter op-leave         like mfc_logical  no-undo.

   for first item-bom
      where  item-bom.item = ip-item
      and    item-bom.bom  = ip-bom
      and    item-bom.par  = ip-par
      and    item-bom.ref  = ip-ref
   no-lock:
   end. /* FOR FIRST item-bom */

   if not available item-bom
   then do:

      run p_create_item_bom(input ip-item,
                            input ip-bom,
                            input ip-par,
                            input ip-ref).

      op-leave = true.

   end.  /* IF NOT AVAILABLE item-bom */
   else do:
      if  (ip-check-level
           and level >= maxlevel
           and maxlevel <> 0)
      or not ip-check-level
      then do:

         find first ps_mstr
            where  recid(ps_mstr) =  -1
            no-lock no-error.

         op-leave = true.

      end. /* IF  (ip-check-level... */

   end. /* ELSE DO */

end procedure. /* PROCEDURE p_check_item_bom */


/* CREATE TEMP-TABLE WITH A PART,BOM CODE,PARENT */
/* AND REFERENCE NUMBER COMBINATION              */
procedure p_create_item_bom:

   define input parameter ip-item like pt_part     no-undo.
   define input parameter ip-bom  like pt_bom_code no-undo.
   define input parameter ip-par  like ps_par      no-undo.
   define input parameter ip-ref  like ps_ref      no-undo.

   create item-bom.
   assign
      item-bom.item = ip-item
      item-bom.bom  = ip-bom
      item-bom.par  = ip-par
      item-bom.ref  = ip-ref.

end procedure. /* PROCEDURE p_create_item_bom */
