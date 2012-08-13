/* xxptcuiqb.p - ITEM MASTER INQUIRY SUBROUTINE                           */
/* Copyright 2004 Shanghai e-Steering Inc., Shanghai , CHINA                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* REVISION: 8.6            CREATED: 11/20/97   BY: *G2QD* Manmohan Pardesi   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/05/98   BY: *H1L1* Samir Bavkar */
/* REVISION: 8.6E     LAST MODIFIED: 05/15/98   BY: *J2LM* Suresh Nayak    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 05/12/00   BY: *N09X* Antony Babu      */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb                */
/* Revision: 1.1.2.9.1.4     BY: Russ Witt    DATE: 09/21/01 ECO: *P01H*       */
/* $Revision: 1.1.2.9.1.5 $    BY: Zheng Huang    DATE: 01/31/02 ECO: *P000*       */
/*V8:ConvertMode=Report                                                 */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* CHANGES DONE IN THIS PROGRAM ALSO NEEDS TO BE DONE IN ppptiqa.p            */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "C+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ppptiqb_p_1 "This Level"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptiqb_p_2 "Total"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptiqb_p_3 "A/O"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptiqb_p_5 "Pri"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptiqb_p_6 "Category"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptiqb_p_8 "Lower Level"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptiqb_p_17 "Element"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* input   ppform       character   Set 'a' if only Item Engineering */
/*                                  data is to be displayed. Set 'e' */
/*                                  if Inventory data, Planning data */
/*                                  etc. is to be displayed with     */
/*                                  pt_mstr values. MRP Required     */
/*                                  and Item cost data will display  */
/*                                  site-specific values based on    */
/*                                  item's default site(pt_site).    */

define input parameter ppform as character no-undo.

define new shared variable in_recno as recid.
define new shared variable si_recno as recid.
define new shared variable csset as character.
define new shared variable global_costsim like sc_sim.
define new shared variable global_category like sc_category.

define new shared workfile sptwkfl
   field element  like spt_element column-label {&ppptiqb_p_17}
   field primary  like mfc_logical column-label {&ppptiqb_p_5}
   field prim2    like mfc_logical
   field ao       like spt_ao      column-label {&ppptiqb_p_3}
   field cst_tl   like spt_cst_tl  column-label {&ppptiqb_p_1}
   field cst_ll   like spt_cst_ll  column-label {&ppptiqb_p_8}
   field cst_tot  like spt_cst_tl  column-label {&ppptiqb_p_2}
   field cat_desc as character     column-label {&ppptiqb_p_6}
   field seq      like spt_pct_ll
   field part     like pt_part.

define new shared frame d.
define new shared frame d0.
define new shared frame d1.

define variable s_mtl like sct_mtl_tl no-undo.
define variable s_lbr like sct_lbr_tl no-undo.
define variable s_bdn like sct_bdn_tl no-undo.
define variable s_ovh like sct_ovh_tl no-undo.
define variable s_sub like sct_sub_tl no-undo.
define variable yn like mfc_logical no-undo.
define variable cfg like pt_cfg_type format "x(3)" no-undo.
define variable cfglabel as character format "x(24)" label ""
   no-undo.
define variable frtitle as character format "x(24)" no-undo.
define variable cfgcode as character format "x(1)" no-undo.

define variable btb-type like pt_btb_type format "x(8)" no-undo.
define variable btb-type-desc like glt_desc no-undo.
define variable atp-enforcement      like pt_atp_enforcement format "x(8)"
   no-undo.
define variable atp-enforce-desc like glt_desc no-undo.
define variable l_comm_code like com_comm_code no-undo.

/* PRINTABLE VERSION OF FRAME a */
FORM /*GUI*/ 
   {ppptmta1.i}
   pt_site colon 19
with STREAM-IO /*GUI*/  frame a0 side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a0:handle).


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
    {ppptmta1.i}
   pt_site colon 19
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

FORM /*GUI*/ 
   /*{ppptmta2.i} */

   pt_prod_line   colon 15
   pt_part_type   colon 36
   pt_draw        colon 58           skip(.1)   
   pt_add         colon 15
   pt_status      colon 36
   pt_rev         colon 58           skip(.1)   
   pt_dsgn_grp    colon 15
   pt_group       colon 36
   pt_drwg_loc    colon 58
   pt_drwg_size            label "Size"              skip(.1)   
   pt_promo       colon 15 label "Promo Group"
   pt_break_cat   colon 58  SKIP(1)
   pt__dec01    COLON 58   LABEL "Copper Std. Usage(BOM)" 
   pt__dec02    COLON 58   LABEL "Additional Usage" SKIP(1)
with STREAM-IO /*GUI*/  frame a1 title color normal (getFrameTitle("ITEM_DATA",20))
   side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a1:handle).

FORM /*GUI*/ 
   {ppptmta3.i}
with STREAM-IO /*GUI*/  frame b1 title color normal
   (getFrameTitle("ITEM_INVENTORY_DATA",28))
   side-labels width 80 attr-space .

/* SET EXTERNAL LABELS */
setFrameLabels(frame b1:handle).

FORM /*GUI*/ 
   {ppptmta4.i}
with STREAM-IO /*GUI*/  frame c title color normal
   (getFrameTitle("ITEM_PLANNING_DATA",26))
   side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

FORM /*GUI*/ 
   {ppptmta5.i}
with STREAM-IO /*GUI*/  frame d1 title color normal
   (getFrameTitle("ITEM_PRICE_DATA",23))
   side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d1:handle).

FORM /*GUI*/ 
   {ppptmta9.i}
with STREAM-IO /*GUI*/  frame d ? down title color normal frtitle
   width 80 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

FORM /*GUI*/ 
   {ppptmta9.i}
with STREAM-IO /*GUI*/  frame d0 1 down width 80 no-labels
   title color normal (getFrameTitle("TOTALS",16)) no-attr-space.

FORM /*GUI*/ 
   {ppptmt10.i}
with STREAM-IO /*GUI*/  frame bb title color normal
   (getFrameTitle("ITEM_SHIPPING_DATA",26))
   side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame bb:handle).

{wbrp02.i}
mainloop:
repeat:

   hide frame a1.
   hide frame b1.
   hide frame c.
   hide frame d0.
   hide frame d.
   hide frame d1.
   hide frame bb.

   display global_part @ pt_part with frame a.

   if c-application-mode <> 'web' then
   prompt-for pt_part
   with no-validate frame a
      editing:
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i pt_mstr pt_part pt_part pt_part pt_part pt_part}
      if recno <> ? then do:
         display {ppptmta1.i} with frame a.
      end.
   end. /* EDITING */

   {wbrp06.i &command = prompt-for &fields =" pt_part " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      if input pt_part = "" then do:
         {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}  /*BLANK NOT ALLOWED*/
         if c-application-mode = 'web' then return.
         else undo, retry.
      end. /*INPUT BLANK*/

      find pt_mstr using pt_part no-lock no-error.
      if not available pt_mstr then do:
         {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3} /* ITEM NUMBER DOES NOT EXIST */
         if c-application-mode = 'web' then return.
         else  undo, retry.
      end. /* IF NOT AVAILABLE pt_mstr */

      global_part = pt_part.

      display
         {ppptmta1.i}
         pt_site
      with frame a.

   end. /* IF (c-application-mode <> 'web') or */

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
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
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


   find in_mstr where in_part = pt_part and in_site = pt_site
   no-lock no-error.
   if available in_mstr then do:

      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

      yn = yes.

      if dev = "terminal" then
      display
         {ppptmta1.i}
         pt_site
      with frame a.

      else
         if dev = "window" then
      display
         {ppptmta1.i}
         pt_site
      with frame a0 STREAM-IO /*GUI*/ .

      display {ppptmta2.i}
          with frame a1 STREAM-IO /*GUI*/ .

      DISPLAY pt__dec01 FORMAT "->,>>>,>>>9.9<<<<<<<<" WITH FRAME a1 STREAM-IO .
      DISPLAY pt__dec02 FORMAT "->,>>>,>>>9.9<<<<<<<<" WITH FRAME a1 STREAM-IO .

      if c-application-mode <> 'web' then
         pause before-hide.

      if ppform = "e"
      then do:

         hide frame a1.

         find qad_wkfl where qad_key1 = "RCPT-STAT"
            and qad_key2 = in_part + in_site
         no-lock no-error.

         display {ppptmta3.i} with frame b1 STREAM-IO /*GUI*/ .
         hide frame b1.

         assign l_comm_code = "".
         for first comd_det where comd_part = pt_part
         no-lock:
         end.
         if available comd_det then
            assign l_comm_code = comd_comm_code.

         display {ppptmt10.i} with frame bb STREAM-IO /*GUI*/ .

         if keyfunction(lastkey) = "end-error" then
            undo, next mainloop.

         hide frame bb.

         /* GET DEFAULT BTB TYPE FROM lngd_det */
         {gplngn2a.i &file = ""emt""
            &field = ""btb-type""
            &code  = pt_btb_type
            &mnemonic = btb-type
            &label = btb-type-desc}

         /* GET DEFAULT ATP ENFORCEMENT TYPE FROM lngd_det */
         {gplngn2a.i &file = ""atp""
            &field = ""atp-enforcement""
            &code  = pt_atp_enforcement
            &mnemonic = atp-enforcement
            &label = atp-enforce-desc}

         display {ppptmta4.i} with frame c STREAM-IO /*GUI*/ .
         display in_mrp @ pt_mrp with frame c STREAM-IO /*GUI*/ .

         if pt_bom_code <> "" then
         find bom_mstr no-lock
            where bom_parent = pt_bom_code no-error.
         else
         find bom_mstr no-lock
            where bom_parent = pt_part no-error.
         display
            bom_batch when (available bom_mstr and bom_batch <> 0)
            @ pt_batch
            1 when ( not available bom_mstr
            or (available bom_mstr and bom_batch = 0)) @ pt_batch
         with frame c STREAM-IO /*GUI*/ .

         /* DISPLAY CONFIGURATION TYPE */
         assign
            cfg = pt_cfg_type
            cfglabel = ""
            cfgcode = "".
         /* GET MNEMONIC cfg AND cfglabel FROM LNGD_DET */
         {gplngn2a.i &file     = ""pt_mstr""
            &field    = ""pt_cfg_type""
            &code     = pt_cfg_type
            &mnemonic = cfg
            &label    = cfglabel}

         display cfg with frame c STREAM-IO /*GUI*/ .

         if keyfunction(lastkey) = "end-error" then
            undo, next mainloop.

         if dev = "terminal" then yn = no.

         hide frame c.

         display {ppptmta5.i} with frame d1 STREAM-IO /*GUI*/ .

         find first icc_ctrl no-lock.

         if in_gl_set = "" then
         find sct_det where sct_sim = icc_gl_set
            and sct_part = in_part and sct_site = in_gl_cost_site
         no-lock no-error.
         else
         find sct_det where sct_sim = in_gl_set
            and sct_part = in_part and sct_site = in_gl_cost_site
         no-lock no-error.

         if available sct_det then do:
            assign csset = sct_det.sct_sim.

            frtitle = getFrameTitle("GL_COST_DATA",16).
            frtitle = frtitle + "(" +  getTermLabel("SITE",8) +
            ": " + in_gl_cost_site + " / " +
            getTermLabel("SET",6)  + ": " + csset + ") ".

            {gprun.i ""ppptiqd.p""
               "(input recid(sct_det), input frtitle)"}
         end. /* IF AVAILABLE sct_det */

         put skip.
         clear frame d all.
         hide frame d0.
         hide frame d.

         if keyfunction(lastkey) = "end-error" then
            undo, next mainloop.

         if in_cur_set = "" then
         find sct_det where sct_sim = icc_cur_set
            and sct_part = in_part and sct_site = in_site
         no-lock no-error.
         else
         find sct_det where sct_sim = in_cur_set
            and sct_part = in_part and sct_site = in_site
         no-lock no-error.

         if available sct_det then do:
            assign csset = sct_det.sct_sim.

            frtitle = getFrameTitle("CURRENT_COST_DATA",24).
            frtitle = frtitle + "(" +  getTermLabel("SITE",8) + ": " +
            in_site + " / " + getTermLabel("SET",6)  + ": " +
            csset + ") ".

            {gprun.i ""ppptiqd.p""
               "(input recid(sct_det), input frtitle)"}
         end. /* IF AVAILABLE sct_det */

         clear frame d all.
         hide frame d0.
         hide frame d1.
         hide frame d.

      end. /* IF ppform = "e" */

      if keyfunction(lastkey) = "end-error" then undo, next mainloop.
      if dev = "terminal" and yn then
         if c-application-mode <> 'web' then
         pause.
      put skip.

   end.  /* IF AVAILABLE in_mstr */

   {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1} /* LIST COMPLETE */

end. /* MAINLOOP */

{wbrp04.i &frame-spec = a}
