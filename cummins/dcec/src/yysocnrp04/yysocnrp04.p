/* GUI CONVERTED from socnrp04.p (converter v1.78) Fri Oct 29 14:38:03 2004 */
/* socnrp04.p - Consignment Material Usage Report - By Order                 */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.5 $                                                    */

/* Revision: 1.3    BY: Steve Nugent   DATE: 04/04/02  ECO: *P00F*  */
/* $Revision: 1.5 $   BY: Dan Herman    DATE: 06/19/02  ECO: *P091*  */

/*V8:ConvertMode=FullGUIReport                                               */
/*                                                                           */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----   */
/*                                                                           */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.            */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN         */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO  */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES. */
/*                                                                           */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----   */
/*                                                                           */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}


define variable shipfrom_from like cncu_site no-undo.
define variable shipfrom_to   like cncu_site no-undo.
define variable cust_from     like cncu_cust no-undo.
define variable cust_to       like cncu_cust no-undo.
define variable shipto_from   like cncu_shipto no-undo.
define variable shipto_to     like cncu_shipto no-undo.
define variable part_from     like cncu_part label "Item Number" no-undo.
define variable part_to       like cncu_part no-undo.
define variable po_from       like cncu_po label "PO Number" no-undo.
define variable po_to         like cncu_po no-undo.
define variable order_from    like cncu_so_nbr label "Order" no-undo.
define variable order_to      like cncu_so_nbr no-undo.
define variable effdate       like cncu_eff_date no-undo.
define variable effdate1      like cncu_eff_date no-undo.
define variable usage_id_from like cncu_batch no-undo.
define variable usage_id_to   like cncu_batch label "Usage ID" no-undo.
define variable cust_usage_ref_from like cncu_cust_usage_ref
                             label "Cust Usage Ref" no-undo.
define variable cust_usage_ref_to
                              like cncu_cust_usage_ref no-undo.


/* SELECTION FORM A */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
shipfrom_from        colon 23
   shipfrom_to          colon 52 label {t001.i}
   cust_from            colon 23
   cust_to              colon 52 label {t001.i}
   shipto_from          colon 23
   shipto_to            colon 52 label {t001.i}
   part_from            colon 23
   part_to              colon 52 label {t001.i}
   po_from              colon 23
   po_to                colon 52 label {t001.i}
   order_from           colon 23
   order_to             colon 52 label {t001.i}
   effdate              colon 23
   effdate1             colon 52 label {t001.i}
   usage_id_from        colon 23
   usage_id_to          colon 52 label {t001.i}
   cust_usage_ref_from  colon 23  view-as fill-in size 20 by 1
   cust_usage_ref_to    colon 52 label {t001.i}
                                  view-as fill-in size 20 by 1
   skip(1)
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF DEFINED(GPLABEL_I)=0 &THEN
   &IF (DEFINED(SELECTION_CRITERIA) = 0)
   &THEN " Selection Criteria "
   &ELSE {&SELECTION_CRITERIA}
   &ENDIF 
&ELSE 
   getTermLabel("SELECTION_CRITERIA", 25).
&ENDIF.
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


/*GUI*/ {mfguirpa.i true "printer" 132 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


   if shipfrom_to = hi_char then shipfrom_to = "".
   if cust_to = hi_char     then cust_to = "".
   if shipto_to = hi_char   then shipto_to = "".
   if part_to = hi_char     then part_to = "".
   if po_to = hi_char       then po_to = "".
   if order_to = hi_char    then order_to = "".
   if effdate = low_date    then effdate = ?.
   if effdate1 = hi_date    then effdate1 = ?.
   if cust_usage_ref_to = hi_char then cust_usage_ref_to = "".
   if usage_id_to = 999999999  then usage_id_to = 0.

   if (c-application-mode <> "WEB") then
      
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   {wbrp06.i &command = update
      &fields = "shipfrom_from shipfrom_to
                 cust_from cust_to
                 shipto_from shipto_to
                 part_from part_to
                 po_from po_to
                 order_from  order_to
                 effdate effdate1
                 usage_id_from usage_id_to
                 cust_usage_ref_from cust_usage_ref_to"

      &frm = "a"}


   if (c-application-mode <> "WEB") or
      (c-application-mode <> "WEB" and
      (c-web-request begins "DATA")) then do:

      bcdparm = "".
      {mfquoter.i shipfrom_from}
      {mfquoter.i shipfrom_to  }
      {mfquoter.i cust_from    }
      {mfquoter.i cust_to      }
      {mfquoter.i shipto_from  }
      {mfquoter.i shipto_to    }
      {mfquoter.i part_from    }
      {mfquoter.i part_to      }
      {mfquoter.i po_from      }
      {mfquoter.i po_to        }
      {mfquoter.i order_from   }
      {mfquoter.i order_to     }
      {mfquoter.i effdate      }
      {mfquoter.i effdate1     }
      {mfquoter.i usage_id_from }
      {mfquoter.i usage_id_to  }
      {mfquoter.i cust_usage_ref_from  }
      {mfquoter.i cust_usage_ref_to  }

   end. /* IF (c-application-mode */

   if  shipfrom_to = "" then shipfrom_to = hi_char.
   if  cust_to = ""     then cust_to = hi_char.
   if  shipto_to = ""   then shipto_to = hi_char.
   if  part_to = ""     then part_to = hi_char.
   if  po_to = ""       then po_to = hi_char.
   if  order_to = ""    then order_to = hi_char.
   if  effdate = ?      then effdate = low_date.
   if  effdate1 = ?     then effdate1 = hi_date.
   if  cust_usage_ref_to = "" then cust_usage_ref_to = hi_char.
   if  usage_id_to = 0  then usage_id_to = 999999999.

   /* OUTPUT DESTINATION SELECTION */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:




   {mfphead.i}

   {gprun.i ""yysocnrp4b.p""
     "(input shipfrom_from,
       input shipfrom_to,
       input cust_from,
       input cust_to,
       input shipto_from,
       input shipto_to,
       input part_from,
       input part_to,
       input po_from,
       input po_to,
       input order_from,
       input order_to,
       input effdate,
       input effdate1,
       input usage_id_from,
       input usage_id_to,
       input cust_usage_ref_from,
       input cust_usage_ref_to)"
      }

   /* REPORT TRAILER */
   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end. /*REPEAT*/

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" shipfrom_from shipfrom_to cust_from cust_to shipto_from shipto_to part_from part_to po_from po_to order_from order_to effdate effdate1 usage_id_from usage_id_to cust_usage_ref_from cust_usage_ref_to "} /*Drive the Report*/
