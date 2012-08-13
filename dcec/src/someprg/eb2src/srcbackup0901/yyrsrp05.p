/* GUI CONVERTED from rsrp05.p (converter v1.76) Wed Aug 28 05:45:02 2002 */
/* rsrp05.p - Release Management Supplier Schedules                         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.16 $                                                         */
/*V8:ConvertMode=FullGUIReport                                                     */
/* REVISION: 7.3      LAST MODIFIED: 12/10/92           BY: WUG *G462*      */
/* REVISION: 7.3      LAST MODIFIED: 06/07/93           BY: WUG *GB76*      */
/* REVISION: 7.3      LAST MODIFIED: 01/12/95           BY: srk *G0C1*      */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97           BY: GYK *K0PC*      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.0      LAST MODIFIED: 12/01/98   BY: *K1QY* Pat McCormick    */
/* REVISION: 9.0      LAST MODIFIED: 02/06/99   BY: *M06R* Doug Norton       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb               */
/* REVISION: 9.1      LAST MODIFIED: 09/11/00   BY: *N0RT* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED: 11/16/00   BY: *M0WL* Shilpa Athalye    */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.15    BY: Mugdha Tambe     DATE: 03/29/01 ECO: *N0XW*          */
/* $Revision: 1.16 $    BY: K Paneesh        DATE: 08/22/02 ECO: *N1RY*          */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rsrp05_p_2 "Print Zero Schedules"
/* MaxLen: Comment: */

&SCOPED-DEFINE rsrp05_p_5 "Sort Option"
/* MaxLen: Comment: */

&SCOPED-DEFINE rsrp05_p_6 "Print Lines With Zero Required Quantity"
/* MaxLen: Comment: */
/* ********** End Translatable Strings Definitions ********* */

/* SUPPLIER SCHEDULE PRINT */
define new shared variable supplier_from like po_vend.
define new shared variable supplier_to like po_vend.
define new shared variable shipto_from like po_ship.
define new shared variable shipto_to like po_ship.
define new shared variable part_from like pod_part.
define new shared variable part_to like pod_part.
define new shared variable po_from like po_nbr.
define new shared variable po_to like po_nbr.
define new shared variable buyer_from like po_buyer.
define new shared variable buyer_to like po_buyer.
define new shared variable schtype like sch_type initial 4 no-undo.
define new shared variable print_zero like mfc_logical initial yes
   label {&rsrp05_p_2}.
define new shared variable sortoption as integer
   label {&rsrp05_p_5} format "9" initial 1.
define new shared variable sortextoption as character
   extent 3 format "x(34)".
define new shared variable zeroqtyline like mfc_logical initial yes
   label {&rsrp05_p_6} no-undo .

define variable yn like mfc_logical initial yes no-undo.
define variable ship_sch_active like mfc_logical initial no no-undo.
define variable sch_type_desc as character format "x(24)" no-undo.
define variable sch_type_numonic as character format "x(8)" no-undo.

/* ************* SET INITIAL VALUES ************* */

sortextoption[1] = "1 - " + getTermLabel("BY",2) + " " +
                            getTermLabel("SHIP-TO",7) + ", " +
                            getTermLabel("SUPPLIER",8) + ", " +
                            getTermLabel("ITEM",4) + ", " +
                            getTermLabel("PURCHASE_ORDER",2).

sortextoption[2] = "2 - " + getTermLabel("BY",2) + " " +
                            getTermLabel("ITEM",4) + ", " +
                            getTermLabel("SHIP-TO",7) + ", " +
                            getTermLabel("SUPPLIER",8) + ", " +
                            getTermLabel("PURCHASE_ORDER",2).

sortextoption[3] = "3 - " + getTermLabel("BY",2) + " " +
                            getTermLabel("PURCHASE_ORDER",2) + ", " +
                            getTermLabel("ITEM",4).

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
po_from              colon 20
   po_to                colon 50 label {t001.i}
   part_from            colon 20
   part_to              colon 50 label {t001.i}
   supplier_from        colon 20
   supplier_to          colon 50 label {t001.i}
   shipto_from          colon 20
   shipto_to            colon 50 label {t001.i}
   buyer_from           colon 20
   buyer_to             colon 50 label {t001.i}
   skip(1)
   schtype              colon 30
   space (3) sch_type_desc no-label
   print_zero           colon 30
   zeroqtyline          colon 40
   sortoption           colon 30
   sortextoption[1]     at 40 no-label
   sortextoption[2]     at 40 no-label
   sortextoption[3]     at 40 no-label
   skip(1)
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

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


/*GUI*/ {mfguirpa.i true "printer" 80 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

   schtype = 4.

   display sortextoption
   with frame a.

   if po_to = hi_char then po_to = "".
   if part_to = hi_char then part_to = "".
   if supplier_to = hi_char then supplier_to = "".
   if shipto_to = hi_char then shipto_to = "".
   if buyer_to = hi_char then buyer_to = "".

   /* CHECK FLAG TO SEE IF MODULE IS TURNED ON */
   if can-find (first mfc_ctrl where
      mfc_field = "enable_shipping_schedules"
      and mfc_seq = 4 and mfc_module = "ADG"
      and mfc_logical = yes)
   then do:
      ship_sch_active = yes.
      schtype = 5.
   end. /* do */
   {gplngn2a.i
      &file     = ""sch_mstr""
      &field    = ""sch_type""
      &code     = string(schtype)
      &mnemonic = sch_type_numonic
      &label    = sch_type_desc}
   if not available lngd_det then
   {pxmsg.i &MSGNUM=4211 &ERRORLEVEL=3} /* Invalid Type */
   else
   display sch_type_desc
      schtype with frame a.
   if c-application-mode <> 'web' then
   
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   {wbrp06.i &command = update
      &fields = "  po_from po_to part_from part_to
                      supplier_from supplier_to shipto_from shipto_to
                      buyer_from buyer_to schtype print_zero zeroqtyline
                      sortoption "
      &frm = "a"}

   {gplngn2a.i
      &file     = ""sch_mstr""
      &field    = ""sch_type""
      &code     = string(schtype)
      &mnemonic = sch_type_numonic
      &label    = sch_type_desc}
   if not available lngd_det
   then do:
      {pxmsg.i &MSGNUM=4211 &ERRORLEVEL=3} /* Invalid Type */
      if (c-application-mode = 'WEB') then
         return.
      else
         /*GUI UNDO removed */ RETURN ERROR.
   end. /* do */
   else do:
      assign sch_type_desc = lngd_translation.
      display sch_type_desc with frame a.
   end. /* else do */
   if can-find (first mfc_ctrl where
      mfc_field = "enable_shipping_schedules"
      and mfc_seq = 4 and mfc_module = "ADG"
      and mfc_logical = yes)
   then do:
      if schtype = 4 then do:
         {pxmsg.i &MSGNUM=4377 &ERRORLEVEL=3}
         /* PRO/PLUS Supplier Schedules in use */
         if (c-application-mode = 'WEB') then
            return.
         else
            /*GUI UNDO removed */ RETURN ERROR.
      end. /* do */
   end. /* do */
   else do:
      if schtype = 5
      or schtype = 6
      then do:
         /* PRO/PLUS Supplier Schedules not in use */
         {pxmsg.i &MSGNUM=5599 &ERRORLEVEL=3}
         if (c-application-mode = 'WEB')
         then
            return.
         else
            /*GUI UNDO removed */ RETURN ERROR.
      end. /* IF schtype = 5 OR ... */
   end. /* ELSE DO */

   if (c-application-mode <> 'WEB') or
      (c-application-mode = 'WEB' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i po_from     }
      {mfquoter.i po_to       }
      {mfquoter.i part_from   }
      {mfquoter.i part_to     }
      {mfquoter.i supplier_from}
      {mfquoter.i supplier_to }
      {mfquoter.i shipto_from }
      {mfquoter.i shipto_to   }
      {mfquoter.i buyer_from  }
      {mfquoter.i buyer_to    }
      {mfquoter.i schtype     }
      {mfquoter.i print_zero  }
      {mfquoter.i zeroqtyline }
      {mfquoter.i sortoption  }

      if po_to = "" then po_to = hi_char.
      if part_to = "" then part_to = hi_char.
      if supplier_to = "" then supplier_to = hi_char.
      if shipto_to = "" then shipto_to = hi_char.
      if buyer_to = "" then buyer_to = hi_char.

   end.

   /* OUTPUT DESTINATION SELECTION */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 80 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:




   if sortoption = 1 then do:
/*judy 07/07/05*/     /* {gprun.i ""rsrp05a.p""}*/
/*judy 07/07/05*/      {gprun.i ""yyrsrp05a.p""}
   end.
   else
      if sortoption = 2 then do:
/*judy 07/07/05*/       /* {gprun.i ""rsrp05b.p""}*/
/*judy 07/07/05*/      {gprun.i ""yyrsrp05b.p""}
   end.
   else
      if sortoption = 3 then do:
/*judy 07/07/05*/        /*{gprun.i ""rsrp05c.p""}*/
/*judy 07/07/05*/      {gprun.i ""yyrsrp05c.p""}
   end.

   
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
{mfreset.i}

   if ship_sch_active
   then do:
      yn = no.
      {pxmsg.i &MSGNUM=4379 &ERRORLEVEL=1 &CONFIRM=yn &CONFIRM-TYPE='LOGICAL'}
      /* Update schedule sent flag? */
      if yn then do:
         for each po_mstr no-lock
               where po_nbr >= po_from and po_nbr <= po_to
               and po_vend >= supplier_from and po_vend <= supplier_to
               and po_buyer >= buyer_from and po_buyer <= buyer_to
               and
               (po_sch_mthd = "" or po_sch_mthd = "p"
               or substring(po_sch_mthd,1,1) = "y")
               /* The following condition selects only PO mstrs that are not
                   EDI for marking as "sent"  */
               and not (substring(po_sch_mthd,2,1) = "e"
                   or  substring(po_sch_mthd,2,1) = "y")
               use-index po_vend,
            each pod_det no-lock
               where pod_nbr = po_nbr
               and pod_sched
               and pod_part >= part_from and pod_part <= part_to
               and pod_site >= shipto_from and pod_site <= shipto_to
               use-index pod_nbrln,
            each pt_mstr no-lock where pt_part = pod_part,
            each sch_mstr
               where sch_type = schtype
               and sch_nbr = pod_nbr
               and length(sch_ship) < 16
               and sch_line = pod_line
               and sch_rlse_id = pod_curr_rlse_id[schtype - 3]:
            assign
               substring(sch_ship,17,2) = string("-1").
         end. /* for each */
      end. /* do */
   end. /* do */

   {pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" po_from po_to part_from part_to supplier_from supplier_to shipto_from shipto_to buyer_from buyer_to schtype print_zero   zeroqtyline sortoption "} /*Drive the Report*/
