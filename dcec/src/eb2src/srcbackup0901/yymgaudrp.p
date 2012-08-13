/* GUI CONVERTED from mgaudrp.p (converter v1.76) Tue May 28 13:03:11 2002 */
/* mgaudrp.p - AUDIT TRAIL REPORT                                       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.12 $                                                     */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 7.3      LAST MODIFIED: 09/18/92   by: JMS  *G069*         */
/*                                   09/21/92   by: jms  *G078*         */
/*                                        (name changed from gpaudrp.p) */
/*                                   02/22/93   by: jms  *G657*         */
/* REVISION: 7.3      LAST MODIFIED: 04/22/94   by: gjp  *GJ53*         */
/* REVISION: 7.3      LAST MODIFIED: 01/22/95   by: rmh  *FQ49*         */
/* REVISION: 7.3      LAST MODIFIED: 03/31/95   BY: jwy  *G0JT*         */
/* REVISION: 7.3      LAST MODIFIED: 03/28/96   BY: qzl  *G1RR*         */
/* REVISION: 8.6      LAST MODIFIED: 11/11/97   BY: bvm  *K19K*         */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/10/00   BY: *M0QW* Falguni Dalal    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.12 $    BY: Katie Hilbert         DATE: 05/25/02  ECO: *P072*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*cj* 08/26/05 extend addr output*/

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

define variable usrid        like aud_userid.
define variable usrid1       like aud_userid.
define variable dt           like aud_date.
define variable dt1          like aud_date.
define variable fld          like aud_field.
define variable fld1         like aud_field.
define variable tbl          like aud_dataset label "Table Name".
define variable tbl1         like aud_dataset.
define variable addr         like aud_key1    label "Address Code".
define variable addr1        like addr.
define variable data         as character format "x(30)"
                             column-label "Field Name!Old Data!New Data".
define variable array_field  like mfc_logical.
define variable print_time   like mfc_logical.
define variable i            as integer.
define variable fldstring    like aud_field.
define variable seq          as integer format ">>>>9" label "Sequence".
define variable seq1         like seq.
define variable cseq         as character.
define variable cseq1        as character.
define variable sort_by_addr like mfc_logical
                             label "Sort by Address".
define variable nines        as integer initial 99999.

/* SELECT FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
tbl          colon 25   tbl1    colon 50 label "To"
   fld          colon 25
   fld1         colon 25                    label "To"
   addr         colon 25   addr1   colon 50 label "To"
   dt           colon 25   dt1     colon 50 label "To"
   usrid        colon 25   usrid1  colon 50 label "To"
   seq          colon 25   seq1    colon 50 label "To"
   sort_by_addr colon 25
 SKIP(.4)  /*GUI*/
with frame a side-labels attr-space
   width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " Selection Criteria "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

/* REPORT BLOCK */

/*GUI*/ {mfguirpa.i true "printer" 132 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

   if tbl1    = hi_char  then tbl1   = "".
   if fld1    = hi_char  then fld1   = "".
   if addr1   = hi_char  then addr1  = "".
   if usrid1  = hi_char  then usrid1 = "".
   if dt      = low_date then dt     = ?.
   if dt1     = hi_date  then dt1    = ?.
   if seq1    = nines    then seq1   = 0.

   if c-application-mode <> 'web' then
      
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   {wbrp06.i &command = update &fields = "  tbl tbl1 fld fld1 addr addr1
        dt dt1 usrid usrid1  seq seq1 sort_by_addr" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      /* CREATE BATCH INPUT STRING */
      bcdparm = "".
      {mfquoter.i tbl    }
      {mfquoter.i tbl1   }
      {mfquoter.i fld    }
      {mfquoter.i fld1   }
      {mfquoter.i addr   }
      {mfquoter.i addr1  }
      {mfquoter.i dt     }
      {mfquoter.i dt1    }
      {mfquoter.i usrid  }
      {mfquoter.i usrid1 }
      {mfquoter.i seq    }
      {mfquoter.i seq1   }
      {mfquoter.i sort_by_addr}

      if tbl1   = "" then tbl1   = hi_char.
      if fld1   = "" then fld1   = hi_char.
      if addr1  = "" then addr1  = hi_char.
      if dt     = ?  then dt     = low_date.
      if dt1    = ?  then dt1    = hi_date.
      if usrid1 = "" then usrid1 = hi_char.
      if seq1   = 0  then seq1   = nines.

      cseq = string(seq,"99999").
      if cseq = "00000" then cseq = "".
      cseq1 = string(seq1,"99999").

   end.

   /* OUTPUT DESTINATION SELECTION */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:



   {mfphead.i}

   if sort_by_addr then do:
      for each aud_det
         where aud_dataset >= tbl   and aud_dataset <= tbl1  and
               aud_key1    >= addr  and aud_key1    <= addr1 and
               aud_key2    >= cseq  and aud_key2    <= cseq1 and
               aud_date    >= dt    and aud_date    <= dt1   and
               aud_field   >= fld   and aud_field   <= fld1  and
               aud_userid  >= usrid and aud_userid  <= usrid1
         no-lock /* use-index aud_field */
            by aud_dataset
            by aud_key1
            by aud_key2 descending
            by aud_date descending
            by aud_time descending
         with frame b width 132 no-box
            no-attr-space:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).

         {mgaudrp1.i}
         
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

      end.
   end.

   else do:
      for each aud_det
         where aud_dataset >= tbl   and aud_dataset <= tbl1  and
               aud_key1    >= addr  and aud_key1    <= addr1 and
               aud_key2    >= cseq  and aud_key2    <= cseq1 and
               aud_date    >= dt    and aud_date    <= dt1   and
               aud_field   >= fld   and aud_field   <= fld1  and
               aud_userid  >= usrid and aud_userid  <= usrid1
         no-lock /* use-index aud_field */
            by aud_dataset
            by aud_date descending
            by aud_time descending
            by aud_key2 descending
         with frame c width 132 no-box
            no-attr-space:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame c:handle).
/*cj*/   {yymgaudrp1.i}
         
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

      end.
   end.

   /* REPORT TRAILER  */
   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end.

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" tbl tbl1 fld fld1 addr addr1 dt dt1 usrid usrid1 seq seq1 sort_by_addr "} /*Drive the Report*/
