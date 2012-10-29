/* GUI CONVERTED from socnuacb.p (converter v1.78) Thu May 28 01:17:11 2009 */
/* socnuacb.p - Sales Order Consignment Usage Window For Final Selection      */
/* Copyright 1986-2009 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* Revision: 1.4         BY: Robin McCarthy       DATE: 10/01/05  ECO: *P3MZ* */
/* Revision: 1.5         BY: Hitendra PV          DATE: 12/02/05  ECO: *P406* */
/* Revision: 1.6         BY: Robin McCarthy       DATE: 12/08/05  ECO: *P49R* */
/* Revision: 1.8         BY: Hitendra PV          DATE: 12/19/05  ECO: *P4CL* */
/* Revision: 1.9         BY: Sarita Gonsalves     DATE: 05/08/07  ECO: *Q14X* */
/* Revision: 1.9.1.1     BY: Ed van de Gevel      DATE: 10/22/07  ECO: *P51G* */
/* Revision: 1.9.1.3     BY: Laxmikant Bondre     DATE: 03/26/09  ECO: *Q2MG* */
/* $Revision: 1.9.1.4 $     BY: Prabu M        DATE: 05/27/09  ECO: *Q2Y0*  */
/*-Revision end---------------------------------------------------------------*/

/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */

/* MODIFICATION TO THIS PROGRAM MAY REQUIRE MODIFICATION TO:                  */
/*    socnua3b.p, socnua5b.p and socnua7b.p                                   */

/*V8:ConvertMode=ReportAndMaintenance                                         */
/* ReportAndMaintenance convert mode required for frame b with swview.i       */

{mfdeclre.i}
{cxcustom.i "SOCNUACB.P"}
{gpglefv.i}

/* STANDARD MAINTENANCE COMPONENT INCLUDE FILE */
{pxmaint.i}
{gplabel.i}

{socnutmp.i}   /* COMMON USAGE TEMP-TABLE DEFINITIONS */

/* PARAMETERS */
define input-output parameter table                for tt_autocr.
define input        parameter ip_sortby            as  character        no-undo.
define input        parameter ip_sel_all           as  character        no-undo.
define input        parameter ip_using_selfbilling as  logical          no-undo.
define input        parameter ip_invoice_domain    as  character        no-undo.
define input        parameter ip_eff_date          as  date             no-undo.
define output       parameter op_continue-yn       as  logical          no-undo.

/* SHARED VARIABLES FOR icsrup.p */
define shared variable multi_entry           like mfc_logical           no-undo.
define shared variable site                  like sr_site               no-undo.
define shared variable location              like sr_loc                no-undo.
define shared variable trans_conv            like sod_um_conv.

{&SOCNUACB-P-TAG1}
/* LOCAL VARIABLES */
{socnuvar.i}   /* COMMON USAGE VARIABLE DEFINITIONS */

/* FRAME D VARIABLES */
define variable frmd_lotser                  like cncix_lotser          no-undo.
define variable frmd_ref                     like cncix_ref             no-undo.
define variable l_backup_domain              like global_domain         no-undo.

{socnufrm.i}   /* COMMON USAGE FORM DEFINITIONS */

/* FRAME B */
FORM /*GUI*/ 
with frame b 5 down width 80
title color normal (getFrameTitle("CONSIGNMENT_SELECTION",78))
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 THREE-D /*GUI*/
&ENDIF /*GUI*/
.


/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

/* FRAME C */
FORM /*GUI*/ 
   

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
{socnfrmc.i}


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame c side-labels width 80

&IF (("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" <> "A")) &THEN
title color normal (getFrameTitle("CONSIGNMENT_DETAILS",78))
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-c-title AS CHARACTER.
 F-c-title = (getFrameTitle("CONSIGNMENT_DETAILS",78)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame c = F-c-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame c =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame c + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame c =
  FRAME c:HEIGHT-PIXELS - RECT-FRAME:Y in frame c - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME c = FRAME c:WIDTH-CHARS - .5. /*GUI*/
&ENDIF /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

loop0:
do transaction:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


   shiploop:
   repeat:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


      hide frame aa.
      clear frame b all.
      view frame b.
      view frame c.
      clear frame d all.
      
      /*
      scroll_loop:
      do with frame b
      on error undo, return error {&GENERAL-APP-EXCEPT}:
         {swview.i &domain        = "true and "
                   &buffer        = tt_autocr
                   &scroll-field  = ac_part
                   &searchkey     = "ac_cncixrecid <> 0"
                   &index-phrase  = "use-index sort_order"
                   &framename     = "b"
                   &framesize     = 5
                   &display1      = ac_part
                   &display2      = ac_order
                   &display3      = ac_line
                   &display4      = ac_tot_qty_oh
                   &display5      = ac_stock_um
                   &display6      = ac_tot_qty_consumed
                   &display7      = ac_consumed_um
                   &display8      = ac_loc
                   &exitlabel     = shiploop
                   &exit-flag     = "true"
                   &record-id     = ac_recid
                   &first-recid   = ac_first_recid
                   &exec_cursor   =
                       " run displayConsignmentDetails
                            (input  ip_invoice_domain,
                             buffer tt_autocr).

                         if return-value <> {&SUCCESS-RESULT} then do:
                            hide frame c.
                            hide frame b.
                            undo shiploop, return.
                         end. "

                   &logical1      = true}

      end. /* DO WITH FRAME b */
      */
      for first tt_autocr: end.
      run displayConsignmentDetails (input  ip_invoice_domain, buffer tt_autocr).
      if return-value <> {&SUCCESS-RESULT} then do:
        hide frame c.
        hide frame b.
        undo shiploop, return.
      end. 
      if keyfunction(lastkey) = "END-ERROR" then do:
               op_continue-yn = ?.   
         leave shiploop.
      end.

      setloop1:
      do on error undo shiploop, leave shiploop :

         /* DISPLAY CURRENT tt_autocr RECORD */
         if ac_recid <> ? then
            for first tt_autocr
               where recid(tt_autocr) = ac_recid
            no-lock:
               run displayConsignmentDetails
                  (input ip_invoice_domain,
                   buffer tt_autocr).

               if return-value <> {&SUCCESS-RESULT} then do:
                  hide frame c.
                  hide frame b.
                  undo shiploop, return.
               end.

               ac_recid = ?.
            end.

         for first si_mstr
            fields (si_db si_domain si_site si_entity)
            where si_domain = global_domain
            and   si_site   = site
         no-lock:
         end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/
 /* FOR FIRST si_mstr */

         if available si_mstr
         then do:

            pause 0.
            {gpglef4.i &from_db =  ip_invoice_domain
                       &to_db   =  si_db
                       &module  = ""IC""
                       &entity  =  si_entity
                       &date    =  ip_eff_date}

            if gpglef_result > 0
            then
               undo shiploop, leave shiploop.

         end. /* IF AVAILABLE si_mstr */

         prompt-for
            part with frame c
         editing :

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i tt_autocr
                      sort_order
                      "true"
                      ac_sortfld2
                      ac_sortfld2}

            if recno <> ? then do:
               run displayConsignmentDetails
                  (input ip_invoice_domain,
                   buffer tt_autocr).

               if return-value <> {&SUCCESS-RESULT} then do:
                  hide frame c.
                  hide frame b.
                  undo shiploop, return.
               end.

               /* SAVE recid FOR RE-POSITIONING */
               ac_recid = recid(tt_autocr).
            end.

         end. /* PROMPT-FOR */

         /* VALIDATE */
         if not can-find(first tt_autocr where
            ac_part = input frame c part)
         then do:
            {pxmsg.i &MSGNUM=5935 &ERRORLEVEL=3} /* RECORD DOESN'T EXIST */
            next-prompt part with frame c.
            undo shiploop, leave shiploop.
         end.

         /* DISPLAY LOWER FRAME */
         if can-find(first tt_autocr
            where ac_part  = input frame c part
            and   ac_loc   = input frame c location
            and   ac_order = input frame c order
            and   ac_line  = input frame c line)
         then do:

            for first tt_autocr
               where ac_part  = input frame c part
               and   ac_loc   = input frame c location
               and   ac_order = input frame c order
               and   ac_line  = input frame c line
            no-lock:
               run displayConsignmentDetails
                  (input ip_invoice_domain,
                   buffer tt_autocr).
            end.

         end.  /* IF CAN-FIND(FIRST tt_autocr) */
         else
            for first tt_autocr
               where ac_part = input frame c part
            no-lock:
               run displayConsignmentDetails
                  (input ip_invoice_domain,
                   buffer tt_autocr).
            end.

         if return-value <> {&SUCCESS-RESULT} then do:
            hide frame c.
            hide frame b.
            hide message.
            undo shiploop, return.
         end.

         assign
            /* SAVE recid FOR RE-POSITIONING IN DOWN FRAME */
            ac_recid         = recid(tt_autocr)
            inventory_domain = ac_domain
            part             = input frame c part
            /* SAVE global FOR LOT/SERIAL LOOKUP */
            global_part      = input frame c part
            global_site      = site
            global_loc       = location.

         /* setloop2 AND 3 FOR FRAME c AND d PPROCESSING */
         {xxsocnuacb.i}
         leave SHIPLOOP.
      end. /* SETLOOP1 */
      leave SHIPLOOP.
   end. /* SHIPLOOP */

   l_backup_domain = global_domain.
   for each tt_autocr
      where tt_autocr.ac_tot_qty_consumed <> 0:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

      assign
         inventory_domain = tt_autocr.ac_domain
         undo_flag        = no.

      if inventory_domain <> global_domain
      then do:
         /* SWITCH TO INVENTORY DOMAIN */
         run switchDomain
            (input  inventory_domain,
             output undo_flag).
         if undo_flag
         then do:
            pause.
            undo loop0, return.
         end. /* IF undo_flag */
      end. /* IF inventory_domain <> global_domain */

      run proc_check_restricted(input  "CN-USE",
                                output undo_flag).

      if undo_flag = no
      then
         run proc_check_restricted(input  "ISS-SO",
                                   output undo_flag).

      if undo_flag
      then do:
         tt_autocr.ac_tot_qty_consumed = 0.

         view frame b.
         view frame c.

         /* UNABLE TO ISSUE OR RECEIVE FOR ITEM */
         {pxmsg.i &MSGNUM=161 &ERRORLEVEL=2 &MSGARG1=tt_autocr.ac_part
                  &MSGARG2=tt_autocr.ac_order &MSGARG3=tt_autocr.ac_line}
      end. /* IF undo_flag */
   end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/
 /* FOR EACH tt_autocr */

   if l_backup_domain <> global_domain
   then do:
      /* SWITCH BACK THE DOMAIN */
      run switchDomain
         (input  l_backup_domain,
          output undo_flag).
      if undo_flag
      then do:
         pause.
         undo loop0, return.
      end. /* IF undo_flag */
   end. /* IF l_backup_domain <> global_domain */

   if can-find(first tt_autocr
      where ac_tot_qty_consumed <> 0)
   then do on endkey undo, leave loop0
           on error  undo, leave loop0:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

      hide frame aa.
      hide message. pause 0.
      ok_to_display = yes.
      /* DISPLAY ITEMS BEING ISSUED */
      /*V8+*/

           
      {mfgmsg10.i 636 1 ok_to_display}
      if ok_to_display = ? then do:
         op_continue-yn = ok_to_display.
         hide frame aa.
         undo, leave loop0.
      end.
        

      if ok_to_display then do:
         /* DISPLAY QUANTITIES */
         for each tt_autocr
            where ac_tot_qty_consumed <> 0
         no-lock
         use-index sort_order:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


            display
               ac_part               @ part
               ac_loc                @ location
               ac_consumed_um        @ um
               ac_tot_qty_consumed   @ tot_qty_consumed
               ac_lotser             @ frmd_lotser
            with frame d
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/
.

            for each tt_sr exclusive-lock:
               delete tt_sr.
            end.

            inventory_domain = ac_domain.

            if inventory_domain <> global_domain then do:
               /* SWITCH TO INVENTORY DOMAIN */
               run switchDomain
                  (input  inventory_domain,
                   output undo_flag).

               if undo_flag then do:
                  pause.
                  undo, return.
               end.
            end.

            /* CREATE tt_sr TEMP-TABLE */
            {gprun.i ""socnucb3.p""
                     "(input        ac_count,
                       input-output table tt_sr)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


            for each tt_sr
            no-lock:

               display
                  tt_sr_lotser   @ frmd_lotser
                  tt_sr_ref      @ frmd_ref
                  tt_sr_qty      @ tot_qty_consumed
                  ac_consumed_um @ um
               with frame d
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/
.

               down with frame d.
            end.

            down with frame d.

         end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/
  /* FOR EACH tt_autocr */
      end.  /* IF ok_to_display */

      /* ASK IF EVERYTHING IS CORRECT. IF YES THEN  */
      /* RETURN YES AS THE OUTPUT PARAMETER TO THE  */
      /* CALLING PROGRAM.                           */
      ok_to_continue = yes.

      /*V8+*/

           
      {mfgmsg10.i 12 1 ok_to_continue}
      if ok_to_continue = ? then do:
         op_continue-yn = ok_to_continue.
         hide frame aa.
         undo, leave loop0.
      end.
        

      op_continue-yn = ok_to_continue.

      if not ok_to_continue then
         undo loop0, leave loop0.
      else
         leave loop0.

   end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/
  /* IF CAN-FIND(FIRST tt_autocr) */
end.  /* loop0 */

hide frame aa.
hide frame b.
hide frame c.
hide message. pause 0.

/* ========================================================================= */
/* ************************ INTERNAL PROCEDURES **************************** */
/* ========================================================================= */

{socnucpl.i}   /* COMMON INTERNAL PROCEDURES FOR ALL USAGE PROGRAMS */
