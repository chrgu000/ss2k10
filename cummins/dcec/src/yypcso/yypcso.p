/* GUI CONVERTED from icsiiq.p (converter v1.78) Fri Oct 29 14:37:07 2004 */
/* icsiiq.p - SITE INQUIRY                                                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.14 $                                                          */
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
/* Revision: 1.12  BY: Jean Miller DATE: 04/06/02 ECO: *P056* */
/* $Revision: 1.14 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00G* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "130204.1"}

define variable pclist like pc_list.
define variable part like pc_part.
define variable star like pc_start INITIAL TODAY.
define variable cmsort like cm_sort.
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/

 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
space(1)
   pclist
   part
   star
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

{wbrp01.i}

repeat:
   DISPLAY pclist part star WITH FRAME a.
   if c-application-mode <> 'web' then
      prompt-for pclist part star with frame a
   editing:

      if frame-field = "pclist" then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i pc_mstr pclist  " pc_domain = global_domain and
         pc_list " pclist pc_list pc_list pc_list}

         if recno <> ? then display pc_list @ pclist with frame a.
         recno = ?.
      end.
      if frame-field = "part" then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i pc_mstr part  " pc_domain = global_domain and
             pc_list = INPUT pclist AND pc_part  "
             part pc_part pc_part pc_part}

         if recno <> ? then display pc_list @ pclist with frame a.
         recno = ?.
      end.
      else do:
         status input.
         readkey.
         apply lastkey.
      end.
   end.
   status input.

   {wbrp06.i &command = prompt-for &fields = " pclist part star " &frm = "a"}


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


   for each pc_mstr  where pc_domain = global_domain AND
        (pc_list =input pclist OR INPUT pclist = "") AND
       (pc_part = INPUT part OR INPUT part = "") AND
       (pc_start <= INPUT star ) AND
       (pc_expir >= INPUT star OR pc_expir = ?)
   no-lock with frame b width 80 no-attr-space down:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).


/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
      find first cm_mstr no-lock where cm_domain = global_domain 
             and cm_addr = pc_list no-error.
      if available cm_mstr then do:
         assign cmsort = cm_sort.
      end.
      else do:
         assign cmsort = "".
      end.   
      display
          pc_list
          cmsort @ cm_sort
          pc_part
          pc_um
          pc_start
          pc_expir
           WITH STREAM-IO /*GUI*/ .

   end.

   {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
