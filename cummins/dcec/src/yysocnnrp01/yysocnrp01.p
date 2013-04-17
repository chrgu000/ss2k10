/* GUI CONVERTED from socnrp01.p (converter v1.78) Fri Oct 29 14:38:03 2004 */
/* socnrp01.p - Consignment Cross Reference Report                           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.8 $                                                    */

/* Revision: 1.6         BY: Steve Nugent DATE: 04/04/02  ECO: *P00F* */
/* $Revision: 1.8 $        BY: Steve Nugent DATE: 06/19/02  ECO: *P091* */

/*V8:ConvertMode=FullGUIReport                                            */
/*                                                                           */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----   */
/*                                                                           */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.            */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN         */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO  */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES  */
/*                                                                           */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----   */
/*                                                                           */


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

define variable shipfrom_from like cncix_site label "Ship-From" no-undo.
define variable shipfrom_to like cncix_site no-undo.
define variable cust_from like cncix_cust no-undo.
define variable cust_to like cncix_cust no-undo.
define variable shipto_from like cncix_shipto no-undo.
define variable shipto_to like cncix_shipto no-undo.
define variable part_from like cncix_part label "Item Number" no-undo.
define variable part_to like cncix_part no-undo.
define variable po_from like cncix_po label "PO Number" no-undo.
define variable po_to like cncix_po no-undo.
define variable order_from like cncix_so_nbr label "Order" no-undo.
define variable order_to   like cncix_so_nbr no-undo.
define variable date_from like cncix_ship_date label "Date Created" no-undo.
define variable date_to   like cncix_ship_date no-undo.
define variable sort_option as integer
           label "Sort Option" format "9" initial 1 no-undo.
define variable sortoption1 as character format "x(53)" no-undo.
define variable sortoption2 as character format "x(53)" no-undo.
define variable show_amts like mfc_logical label "Show Amounts" no-undo.


assign
   sortoption1 = "1 - " + getTermLabel("BY_SHIP-FROM",12) + ", " +
                          getTermLabel("CUSTOMER",8) + ", " +
                          getTermLabel("SHIP-TO",7) + ", " +
                          getTermLabel("ORDER",5) + ", " +
                          getTermLabel("ITEM",4) + ", " +
                          getTermLabel("PURCHASE_ORDER",2)
   sortoption2 = "2 - " + getTermLabel("BY_SHIP-FROM",12) + ", " +
                          getTermLabel("ITEM",4) + ", " +
                          getTermLabel("CUSTOMER",8) + ", " +
                          getTermLabel("SHIP-TO",7) + ", " +
                          getTermLabel("ORDER",5) + ", " +
                          getTermLabel("PURCHASE_ORDER",2).

/* SELECTION FORM A */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/

 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
shipfrom_from  colon 15
    shipfrom_to    colon 45 label {t001.i}
    cust_from      colon 15
    cust_to        colon 45 label {t001.i}
    shipto_from    colon 15
    shipto_to      colon 45 label {t001.i}
    part_from      colon 15
    part_to        colon 45 label {t001.i}
    po_from        colon 15
    po_to          colon 45 label {t001.i}
    order_from     colon 15
    order_to       colon 45 label {t001.i}
    date_from      colon 15
    date_to        colon 45 label {t001.i}
    skip(1)
    show_amts       colon 35
    sort_option    colon 15
    skip
    sortoption1    at 17 no-label
    sortoption2    at 17 no-label
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
   if date_from = low_date  then date_from = ?.
   if date_to = hi_date     then date_to = ?.


   display
      sortoption1
      sortoption2
   with frame a.
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
                 date_from date_to
                 show_amts sort_option"
     &frm = "a"}

   /* VALIDATE SORT OPTION FIELD */
   if sort_option <> 1  and
      sort_option <> 2  then do:
      {pxmsg.i &MSGNUM=2313 &ERRORLEVEL=3} /* INVALID SORT OPTION */
      /*GUI NEXT-PROMPT removed */
      /*GUI UNDO removed */ RETURN ERROR.
   end.

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
       {mfquoter.i date_from    }
       {mfquoter.i date_to      }
       {mfquoter.i show_amts}
       {mfquoter.i sort_option  }


   end. /* IF (c-application-mode */

    if  shipfrom_to = "" then shipfrom_to = hi_char.
    if  cust_to = ""     then cust_to = hi_char.
    if  shipto_to = ""   then shipto_to = hi_char.
    if  part_to = ""     then part_to = hi_char.
    if  po_to = ""       then po_to = hi_char.
    if  order_to = ""    then order_to = hi_char.
    if  date_from = ?    then date_from = low_date.
    if  date_to = ?      then date_to = hi_date.

   /* OUTPUT DESTINATION SELECTION */

/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:




   {mfphead.i}

   if sort_option = 1 then do:
      {gprun.i ""yysocnrp1a.p""
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
       input date_from,
       input date_to,
       input show_amts)"
      }
   end.
   else
   if sort_option = 2 then do:
      {gprun.i ""yysocnrp1b.p""
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
       input date_from,
       input date_to,
       input show_amts)"
      }
   end.

   /* REPORT TRAILER */

/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end. /*REPEAT*/

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" shipfrom_from shipfrom_to cust_from cust_to shipto_from shipto_to part_from part_to po_from po_to order_from order_to date_from date_to show_amts sort_option "} /*Drive the Report*/
