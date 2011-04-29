/* gplabel.p - LABEL FUNCTION LIBRARY.                                        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.33 $                                                          */
/* ****************************** Tokens ************************************ */
/*V8:ConvertMode=NoConvert                                                    */
/*V8:ClientServerMode=Client                                                  */
/* **************************** History ************************************* */
/* REVISION: 9.1         CREATED: 03/01/00   *N08T*   BY: Dennis Taylor       */
/* REVISION: 9.1        MODIFIED: 03/12/00   *N096*   BY: Dennis Taylor       */
/* REVISION: 9.1        MODIFIED: 05/18/00   *N0BJ*   BY: Annasaheb Rahane    */
/* REVISION: 9.1        MODIFIED: 05/22/00   *N098*   BY: Annasaheb Rahane    */
/* REVISION: 9.1        MODIFIED: 07/07/00   *N0F9*   BY: Annasaheb Rahane    */
/* REVISION: 9.1        MODIFIED: 07/12/00   *N0FX*   BY: Annasaheb Rahane    */
/* REVISION: 9.1        MODIFIED: 07/21/00   *N0GP*   BY: Annasaheb Rahane    */
/* REVISION: 9.1        MODIFIED: 08/01/00   *N0HJ*   BY: Annasaheb Rahane    */
/* REVISION: 9.1        MODIFIED: 07/28/00   *N059*   BY: Brian Wintz         */
/* REVISION: 9.1        MODIFIED: 08/08/00   *N0J9*   BY: Jean Miller         */
/* REVISION: 9.1        MODIFIED: 08/11/00   *N0K4*   BY: Dave Caveney        */
/* REVISION: 9.1        MODIFIED: 08/17/00   *N0LV*   BY: Jean Miller         */
/* REVISION: 9.1        MODIFIED: 08/25/00   *N0P4*   BY: Annasaheb Rahane    */
/* Revision: 1.26       BY: Annasaheb Rahane     DATE: 12/13/00   ECO: *N0V5* */
/* Revision: 1.27       BY: Annasaheb Rahane     DATE: 02/07/01   ECO: *N0WQ* */
/* Revision: 1.29       BY: Annasaheb Rahane     DATE: 04/06/01   ECO: *N0XZ* */
/* Revision: 1.30       BY: Annasaheb Rahane     DATE: 06/13/01   ECO: *N0ZF* */
/* Revision: 1.31       BY: Falguni Dalal        DATE: 07/20/01   ECO: *N10K* */
/* Revision: 1.32       BY: Annasaheb Rahane     DATE: 08/27/01   ECO: *N11Q* */
/* $Revision: 1.33 $    BY: Jean Miller          DATE: 06/10/02   ECO: *N1KZ* */
/* Revision: EB       BY: Leemy Lee     DATE: 01/16/03   ECO: *SoftSpeed      */
/*********Description:  Call Standard Label for Customization Program********/   
/*** eg.  xxpoporp03.p Call poporp03.p lable ********************************/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}

/* ************************** Local Variables ************************** */

/* DEFINE LABEL TEMP TABLE */
define temp-table tt_lbl no-undo
   field tt_lbl_lang       like lbl_lang
   field tt_lbl_execname   like lbld_execname
   field tt_lbl_fieldname  like lbld_fieldname
   field tt_lbl_term       like lbl_term
   field tt_lbl_long       like lbl_long
   field tt_lbl_medium     like lbl_medium
   field tt_lbl_short      like lbl_short
   field tt_lbl_stacked    like lbl_stacked
   index labelvar tt_lbl_lang tt_lbl_execname tt_lbl_fieldname tt_lbl_term.

/* DEFINE LOCAL VARIABLES. */
define variable i-colbegpos   as integer extent 60 no-undo.
define variable i-colendpos   as integer extent 60 no-undo.
define variable i-colwidth    as integer extent 60 no-undo.
define variable l-colstacked  as logical extent 60 no-undo.
define variable l-colnolabel  as logical extent 60 no-undo.
define variable c-execname    like execname no-undo.

THIS-PROCEDURE:private-data = "GPLABEL".

define buffer lblc_ctrl for lblc_ctrl.
run getLabelControl(buffer lblc_ctrl).

PROCEDURE getLabelControl:
/*------------------------------------------------------------------
Purpose:    Retrieves a lblc_ctrl record.
Parameters: labelControl - Buffer for resulting label control record.
Notes:
------------------------------------------------------------------*/
   define parameter buffer labelControl for lblc_ctrl.

   /* GET LABEL CONTROL */
   for first labelControl
      no-lock:
   end.
   if not available labelControl
   then do:
      create labelControl.
      assign
         labelControl.lblc_mod_date   = today
         labelControl.lblc_mod_userid = global_userid.
   end.
END PROCEDURE.

FUNCTION getFieldLabel returns character ( input p-field as character,
      input p-length as integer).
/*------------------------------------------------------------------
Purpose:    Public function.
            Returns a label for a specified field.
Parameters: Input p-field  - Field to get label for.
                  p-length - Number of characters label is limited to.
Notes:      If no label is found "^" is returned.
------------------------------------------------------------------*/
   define variable c-label as character format "x(50)" no-undo.

   c-execname = substring(execname,1,r-index(execname,".") - 1 ).

   for first tt_lbl
      where tt_lbl_lang      = global_user_lang and
            tt_lbl_execname  = execname and
            tt_lbl_fieldname = p-field
      no-lock :
   end.

   if not available ( tt_lbl ) or
      ( tt_lbl_long = "" and tt_lbl_medium = "" and tt_lbl_short = "" )
   then do:
      /* CREATE RECORD IN TEMP TABLE IF LABEL IS DIFFERENT FOR EXECNAME */
      for first lbld_det
         where lbld_fieldname = p-field and
               entry(1,lbld_execname,".") = c-execname
         no-lock:
      end.
      if available ( lbld_det )
      then do:
         for first  lbl_mstr
            where lbl_lang = global_user_lang and
                  lbl_term = lbld_term
            no-lock:
         end.
      end.
      if available ( lbld_det ) and available ( lbl_mstr ) and
         ( lbl_long <> "" or lbl_medium <> "" or lbl_short <> "" )
      then do:
         create tt_lbl.
         assign
            tt_lbl_lang      = global_user_lang
            tt_lbl_execname  = lbld_execname
            tt_lbl_fieldname = lbld_fieldname
            tt_lbl_term      = lbl_term
            tt_lbl_long      = lbl_long
            tt_lbl_medium    = lbl_medium
            tt_lbl_short     = lbl_short
            tt_lbl_stacked   = lbl_stacked.
      end. /* if available ( lbld_det ) then */
      else do:
         for first tt_lbl
            where tt_lbl_lang      = global_user_lang and
                  tt_lbl_execname  = "" and
                  tt_lbl_fieldname = p-field
            no-lock :
         end.
         if not available ( tt_lbl )
         then do:
            for first lbld_det
               where lbld_execname  = ""       and
                     lbld_fieldname = p-field
               no-lock :
            end.
            if available ( lbld_det )
            then do:
               for first  lbl_mstr
                  where lbl_lang = global_user_lang and
                        lbl_term = lbld_term
                  no-lock:
               end.
               if available ( lbl_mstr )
               then do:
                  create tt_lbl.
                  assign
                     tt_lbl_lang      = global_user_lang
                     tt_lbl_execname  = lbld_execname
                     tt_lbl_fieldname = lbld_fieldname
                     tt_lbl_term      = lbl_term
                     tt_lbl_long      = lbl_long
                     tt_lbl_medium    = lbl_medium
                     tt_lbl_short     = lbl_short
                     tt_lbl_stacked   = lbl_stacked.
               end. /* available ( lbl_mstr ) */
            end. /* if available ( lbld_det ) */
         end. /* if not available ( tt_lbl ) */
      end. /* else available lbld_det */
   end. /* if not available ( tt_lbl ) */
   if available ( tt_lbl )
   then do:
      if length(tt_lbl_long,"raw") <= p-length  and
         tt_lbl_long <> ? and tt_lbl_long <> ""
      then
         c-label =  tt_lbl_long.
      else
         if length(tt_lbl_medium,"raw") <= p-length  and
            tt_lbl_medium <> ? and tt_lbl_medium <> ""
         then
            c-label = tt_lbl_medium.
         else
            if length(tt_lbl_short,"raw")  <= p-length  and
               tt_lbl_short <> ? and tt_lbl_short <> ""
            then
               c-label = tt_lbl_short.
            else
               c-label = substring(tt_lbl_long,1,p-length,"raw").
   end.

   /* IF LABEL DETAIL WAS NOT FOUND. */
   if c-label = "" or c-label = ?
   then do:
      run getLabelControl(buffer lblc_ctrl).
      /* PRODUCTION MODE RETURNS NOT FOUND SYMBOL. */
      if lblc_ctrl.lblc__qadl01 = no
      then
         c-label = "^".
      else
         /* TEST MODE RETURNS FIELD CAPITALIZED. */
         c-label = caps(substring(p-field,1,p-length)).
   end.
   return c-label.

END FUNCTION. /* getFieldLabel */

FUNCTION getTermLabel returns character ( input p-term as character,
      input p-length as integer).
/*------------------------------------------------------------------
Purpose:    Public Function.
            Returns a label for a specified term.
Parameters: Input p-term   - Term to get label for.
                  p-length - Number of characters label is limited to.
Notes:
------------------------------------------------------------------*/
   define variable c-label        as character format "x(50)" no-undo.
   define variable c-originalterm as character no-undo.

   c-originalterm = p-term.

   /* CONVERT INPUT STRING TO TERM FORMAT */
   assign
      p-term = trim(p-term)
      p-term = caps(replace(p-term," ","_")).

   for first tt_lbl
      where tt_lbl_lang      = global_user_lang and
            tt_lbl_execname  = "" and
            tt_lbl_fieldname = "" and
            tt_lbl_term      = p-term
      no-lock :
   end.
   if not available ( tt_lbl )
   then do:
      for first  lbl_mstr
         where lbl_lang = global_user_lang and
              lbl_term = p-term
         no-lock :
      end.
      if available ( lbl_mstr )
      then do:
         create tt_lbl.
         assign
            tt_lbl_lang      = global_user_lang
            tt_lbl_execname  = ""
            tt_lbl_fieldname = ""
            tt_lbl_term      = lbl_term
            tt_lbl_long      = lbl_long
            tt_lbl_medium    = lbl_medium
            tt_lbl_short     = lbl_short
            tt_lbl_stacked   = lbl_stacked.
      end. /* available ( lbl_mstr ) */
   end.
   if available ( tt_lbl )
   then do:
      if length(tt_lbl_long,"raw") <= p-length  and
         tt_lbl_long <> ? and tt_lbl_long <> ""
      then
         c-label =  tt_lbl_long.
      else
         if length(tt_lbl_medium,"raw") <= p-length  and
            tt_lbl_medium <> ? and tt_lbl_medium <> ""
         then
            c-label = tt_lbl_medium.
         else
            if length(tt_lbl_short,"raw")  <= p-length  and
               tt_lbl_short <> ? and tt_lbl_short <> ""
            then
               c-label = tt_lbl_short.
            else
               c-label = substring(tt_lbl_long,1,p-length,"raw").
   end.

   /* IF LABEL TERM IS NOT FOUND. */
   if c-label = "" or c-label = ?
   then do:
      run getLabelControl(buffer lblc_ctrl).
      /* PRODUCTION MODE RETURNS INPUT TERM. */
      if lblc_ctrl.lblc__qadl01 = no
      then
         c-label = c-originalterm.
      else
         /* TEST MODE RETURNS INPUT TERM CAPITALIZED. */
         c-label = caps(substring(p-term,1,p-length)).
   end.

   return c-label.

END FUNCTION. /* getTermLabel */

FUNCTION getTermLabelCentered returns character
      (input p-term as character,
      input p-length as integer).
/*------------------------------------------------------------------
Purpose:    Public function.
            Returns the label for the specified term centered in a
            string of the specified length.
Parameters: Input p-term   - Term to get label for.
                  p-length - Length in bytes of the returned string.
Notes:      If no label record is found p-term is returned as label.
------------------------------------------------------------------*/
   define variable c-centered as character format "x(80)" no-undo.
   define variable i-labelwidth  as integer no-undo.
   define variable i-pos         as integer no-undo.

   /* GET LABEL */
   c-centered = getTermLabel(p-term,p-length).

   /* CENTER */
   run centerLabel
      (input        p-length,
       input-output c-centered).

   return c-centered.

END FUNCTION. /* getTermLabelCentered */

FUNCTION getTermLabelFillCentered returns character
      (input p-term            as character,
       input p-length          as integer,
       input p-fillchar        as character).
/*------------------------------------------------------------------
Purpose:    Returns the label for the specified term, centered in a
            string of the specified length which is filled by the
            specified character. (Example: "****** Label *******".)
Parameters: Input p-term     - Term to get label for.
                  p-length   - Length in bytes of returned string
                  p-fillchar - Character with which to fill string
------------------------------------------------------------------*/
   define variable p-label as character format "x(80)" no-undo.
   define variable i-labelwidth  as integer no-undo.
   define variable i-pos         as integer no-undo.

   /* GET LABEL */
   if p-length > 4
   then
      p-label = p-fillchar + " " + getTermLabel(p-term,p-length - 4) +
                " " + p-fillchar.
   else
      p-label = getTermLabel(p-term,p-length).

   i-labelwidth  = length(p-label,"raw").

   /* IF LABEL LENGTH IS LESS THAN AVAILABLE SPACE, CENTER LABEL. */
   if i-labelwidth  < p-length
   then do:
      assign
         /* GET STARTING POSITION */
         i-pos = integer((p-length - (i-labelwidth )) / 2)
         p-label = fill(p-fillchar,i-pos) + p-label +
                   fill(p-fillchar, p-length - i-labelwidth - i-pos ).
   end.  /* end of if i-labelwidth  < p-length */

   return p-label.

END FUNCTION. /* getTermLabelFillCentered */

FUNCTION getTermLabelRt returns character ( input p-term as character,
      input p-length as integer).
/*------------------------------------------------------------------
Purpose:    Public function.
            Returns a string that consists of a right-justified label
            in a string of the specified length.
Parameters: Input p-term   - Term to get label for.
                  p-length - Length in bytes of returned string.
Notes:      If no label record is found, p-term is returned as label.
------------------------------------------------------------------*/
   define variable c-rtterm as character format "x(50)" no-undo.

   /* GET LABEL */
   c-rtterm = getTermLabel(p-term,p-length).

   /* RIGHT JUSTIFY */
   run rightJustifyLabel
      (input        p-length,
       input-output c-rtterm).

   return c-rtterm.

END FUNCTION. /* getTermLabelRt */

FUNCTION getTermLabelRtColon returns character ( input p-term as character,
      input p-length as integer).
/*------------------------------------------------------------------
Purpose:    Public function.
            Returns a string that consists of a right-justified label
            and an appended colon.
Parameters: Input p-term   - Term to get label for.
                  p-length - Length in bytes of the returned string.
Notes:      If no label is found p-term is returned as label.
------------------------------------------------------------------*/
   define variable c-rtterm as character format "x(50)" no-undo.

   /* GET LABEL */
   assign
      /* SEND LENGTH TO GET LABEL -1 TO ALLOW FOR COLON. */
      c-rtterm = getTermLabel(p-term,p-length - 1)
      c-rtterm = c-rtterm + ":".

   /* RIGHT JUSTIFY */
   run rightJustifyLabel
      (input        p-length,
       input-output c-rtterm).

   return c-rtterm.
END FUNCTION. /* getTermLabelRtColon */

FUNCTION getFrameTitle returns character (input p-term as character,
      input p-length as integer).
/*------------------------------------------------------------------
Purpose:    Public function. Returns a frame title for a specified
            term. A frame title is a string that consists of a label
            and a single white space at the before and after the
            label.
Parameters: Input p-term   - Term to get label for.
                  p-length - Length in bytes the string is limited to.
Notes:      If no label is found p-term is returned as label.
------------------------------------------------------------------*/
   define variable c-rtterm as character format "x(50)" no-undo.

   /* GET LABEL */
   if p-length > 2
   then
      p-term = getTermLabel(p-term,p-length - 2).

   /* CONCAT LABELS WITH SPACES */
   p-term = " " + p-term + " ".

   return p-term.

END FUNCTION. /* getFrameTitle */

FUNCTION setFrameLabels returns character
      (input p-frame as handle).
/*------------------------------------------------------------------
Purpose:    Public function.
            Sets translated labels on frames.
Parameters: Input p-frame - Handle of frame to set labels on.
Notes:      setFrameLabels sets translated labels on frames. It
            takes as input a frame handle. Then it determines the
            type of frame and delegates
            responsibility to the proper internal procedure
            based on the frame type.
------------------------------------------------------------------*/
   define variable l-registered as logical no-undo.

    /**Softspeed */ if length(execname)>=2 then do:
    /**Softspeed */    if substring(execname,1,2) = "xx" then execname = substring(execname,3, (LENGTH(execname) - 2) ).
    /**Softspeed */  end.

   /* IF TRANSLATED FRAMES IS TURNED OFF DO NOT */
   /* USE EXTERNALIZED LABELS.                 */
   run getLabelControl(buffer lblc_ctrl).
   if not available lblc_ctrl or
      available lblc_ctrl and not lblc_ctrl.lblc_trans_frame
   then
      leave.

   /* IF FRAME HAS ALREADY BEEN TRANSLATED */
   /* NO NEED TO CONTINUE ANY FURTHER.    */
   run checkFrameRegistration
      (input  p-frame,
       output l-registered).

   if l-registered
   then
      leave.

   /* SIDE LABELS */
   if p-frame:type = "DIALOG-BOX" or  p-frame:side-labels
   then do:
      run setSideLabels
         (input p-frame).
   end.
   else /* COLUMN-LABELS */
   if p-frame:labels
   then do:
      run setColumnLabels
         (input p-frame).
   end.

END FUNCTION. /* setFrameLabels */

FUNCTION clearFrameRegistration returns character
      (input p-frame as handle).
/*------------------------------------------------------------------
Purpose:    Public function.
            Clears translated frame registration for
            menu level applications.
Parameters: Input  p-frame - Handle of frame to clear registration on.
            If unknown then clears all registrations.
Notes:      The frame registration table prevents already translated
            frames from being translated twice within an application.
------------------------------------------------------------------*/
   if valid-handle(p-frame)
   then
      p-frame:private-data = ?.

END FUNCTION. /* clearFrameRegistration */

FUNCTION getTranslateFramesFlag returns logical.
/*------------------------------------------------------------------
Purpose:    Public function.
            Returns true if "Translate Frame"
            setting is turned on.
Parameters: <None>
Notes:      The frame registration table prevents already translated
------------------------------------------------------------------*/
   run getLabelControl(buffer lblc_ctrl).
   return (not available(lblc_ctrl) or
      (available(lblc_ctrl) and lblc_ctrl.lblc_trans_frame)).

END FUNCTION. /* getTranslateFramesFlag */

FUNCTION deleteLabelTempTable returns logical.
/*------------------------------------------------------------------
Purpose:    Public function.
            Empties label temp table.
Parameters: <None>
Notes:      It is useful to have a point (such as the sign-on screen)
            where labels in the temp table are deleted so that new
            values can be stored and displayed.
------------------------------------------------------------------*/
   empty temp-table tt_lbl no-error.
   return true.

END FUNCTION. /* deleteLabelTempTable */

PROCEDURE setSideLabels:
/*------------------------------------------------------------------
Purpose:    Private method.
            Sets translated labels for side-label frames.
Parameters: Input p-frame - Handle of frame to set labels on.
Notes:      This function walks the frame's widget tree, identifying
            widgets with side-labels. If a widget is detected with a
            side label, the field's translated label is retrieved
            and set via getFieldLabel. If a widget is determined to
            be a variable used as a label, its translated label
            is retrieved and set via getFieldLabel. If a literal
            string is detected, its translated label is retreived
            and set via getTermLabel. (This last feature is meant to
            handle legacy code.)
------------------------------------------------------------------*/
   define input parameter p-frame as handle.

   define variable h-widget     as handle no-undo.
   define variable h-next       as handle no-undo.
   define variable i-available  as integer no-undo.
   define variable i-beg        as integer no-undo.
   define variable i-end        as integer no-undo.

   define variable c-fieldname  as character no-undo.
   define variable c-label      as character no-undo.

   assign
      h-widget = p-frame:first-child.        /* FOREGROUND FIELD-GROUP */
      h-widget = h-widget:first-child.       /* FIRST FIELD */

   do while valid-handle(h-widget):
      assign
         c-label = ""
         c-fieldname = "".
      if h-widget:index = 0 or
         h-widget:index = ?
      then
         c-fieldname = h-widget:name.
      else
         c-fieldname = h-widget:name + "[" + string(h-widget:index) + "]".

      /* IF CAN SET LABEL ON WIDGET AND  */
      /* IT'S NOT A TOGGLE BOX AND       */
      /* THE WIDGET HAS A SIDELABEL THEN */
      /* SET LABEL FOR LABELED FIELDS.   */
      if can-set(h-widget, "LABEL") and
         h-widget:type <> "TOGGLE-BOX" and
         h-widget:type <> "BUTTON" and
         h-widget:type <> "RADIO-SET" and
         valid-handle(h-widget:side-label-handle)
      then do:
         /* IGNORE FIELDS dev & batch_id FOR WEB ENVIRONMENT */
         if c-application-mode = 'web'    and
            ( h-widget:name  = "dev"      or
            h-widget:name  = "batch_id" )
         then.
         else do:
            /* GET AVAILABLE SIZE FOR THE LABEL*/
            run getAvailableSideLabelSize
               (input h-widget:side-label-handle,
                output i-available).

            /* GET LABEL */
            c-label = getFieldLabel(c-fieldname,i-available).
            /* SET LABEL ON WIDGET IF ONE WAS FOUND. */
            if c-label <> "^"
            then
               h-widget:label = c-label.

            /* FOR LOGICALS SET THEIR FORMAT */
            if h-widget:data-type = "LOGICAL"
            then
               assign
                  i-available = 50
                  h-widget:format = getTermLabel(h-widget:format,i-available).
         end. /* else if c-application-mode */
      end.
      else
         if can-set(h-widget, "LABEL") and
            (h-widget:type = "BUTTON" or
             h-widget:type = "TOGGLE-BOX" or
             h-widget:type = "RADIO-SET")
         then do:
            /* SET LABEL ON BUTTON WIDGETS */
            if h-widget:type = "BUTTON"
            then do:
               /* STD BUTTON WIDGETS HAVE NAMES */
               if c-fieldname <> ?  and c-fieldname <> ""
               then
                  c-label =
                     getFieldLabel(c-fieldname,integer(h-widget:width-chars)).
               else
                  /* BUTTONS FOR SELECTION LISTS DO NOT HAVE NAMES */
                  c-label =
                     getTermLabel(h-widget:label,integer(h-widget:width-chars)).

               /* SET LABEL ON WIDGET IF ONE WAS FOUND. */
               if c-label <> "^"
               then
                  h-widget:label = c-label.
            end.
            else
               if h-widget:type = "TOGGLE-BOX"
               then do:
                  c-label =
                     getFieldLabel(c-fieldname,length(h-widget:label,"raw")).
                  /* SET LABEL ON WIDGET IF ONE WAS FOUND. */
                  if c-label <> "^"
                  then
                     h-widget:label = c-label.
               end.
               if h-widget:type = "RADIO-SET"
               then do:
                  run setRadioSetLabels
                     (input h-widget).
               end.
            end.
            else
              if can-set(h-widget, "SCREEN-VALUE")
              then do:
                 /* EXAMINE LITERAL WIDGETS TO SEE IF THEY ARE       */
                 /* STANDALONE TEXT STRINGS THAT NEED TRANSLATING.   */
                 /* (I.E. THEY ARE NOT BEING USED AS SIDE-LABELS.)   */
                 h-next = h-widget:next-sibling.
                 if not valid-handle(h-next) or     /* LAST WIDGET ON FRAME */
                  ( valid-handle(h-next) and
                    if h-next:type = "BUTTON"
                    then true
                    else h-widget:handle <> h-next:side-label-handle
                  )
                 then do:
                    /* GET LABEL FOR HARDCODED STRINGS */
                    if h-widget:type = "LITERAL"
                    then do:
                       /* GET AVAILABLE SIZE */
                       run getAvailableSideLabelSize
                          (input h-widget,
                          output i-available).

                       /* IGNORE MESSAGES EMBEDDED IN FRAMES */
                       /* (SUCH AS {t###.i})                 */
                       if i-available < 40
                       then do:
                          assign
                             /* RECORD CURRENT POSITION */
                             i-beg = h-widget:column
                             i-end = i-beg +
                                     length(h-widget:screen-value,"raw") - 1
                             /* SET LABEL */
                             h-widget:screen-value =
                               getTermLabelRt(h-widget:screen-value,i-available)
                             /* ADJUST COLUMN POSITION PER */
                             /* TRANSLATED LABEL LENGTH    */
                             h-widget:column =
                                i-end - length(h-widget:screen-value,"raw") + 1.
                       end. /* if available < 40 then do: */
                    end.
                    else do:
                       /* IF WE'VE MADE IT HERE WITHOUT DOING ANYTHING */
                       /* WE PROBABLY HAVE A NO-LABEL FIELD.           */

                       /* FOR LOGICALS SET THEIR FORMAT */
                       if h-widget:data-type = "LOGICAL"
                       then
                          assign
                             i-available = 50
                             h-widget:format =
                                getTermLabel(h-widget:format,i-available).
                    end.
                 end. /* if h-widget:handle <> h-next:side-label-handle */
              end. /* else do: */

      /* GET NEXT FIELD WIDGET */
      h-widget = h-widget:next-sibling.

   end. /*do while valid-handle(h-widget)...*/

   /* REGISTER FRAME AS TRANSLATED. */
   run addFrameRegistration
      (input p-frame).

   return "".

END PROCEDURE. /* setSideLabels */

PROCEDURE setColumnLabels:
/*------------------------------------------------------------------
Purpose:    Private method.
            Sets translated labels on frames using column labels.
Parameters: Input p-frame - Handle of frame to set labels on.
Notes:      This function walks the frame's foreground frame-group to
            identify how many columns and each column's coordinates
            defined by the field's format.
            Once the number of columns and their coordinates have been
            identified the function then walks the frame's background
            frame-group, identifying literal widgets that are used as
            column labels. The literal widgets are expanded to the
            full format size to maximize real estate for translated
            labels.
            The translated label is then retrieved and set for each
            widget on the frame.
------------------------------------------------------------------*/
   define input parameter p-frame as handle.

   define variable h-widget      as handle no-undo.
   define variable h-background  as handle no-undo.
   define variable h-literal     as handle no-undo.
   define variable h-templiteral as handle no-undo.
   define variable h-next        as handle no-undo.
   define variable h-prev        as handle no-undo.

   define variable i-colnbr      as integer no-undo.
   define variable i-headerwidth as integer no-undo.
   define variable i-prevcolumn  as integer no-undo.
   define variable i-currcol     as integer no-undo.
   define variable i-colbeg      as integer no-undo.
   define variable i-colend      as integer no-undo.
   define variable i-available   as integer no-undo.
   define variable i-beg         as integer no-undo.
   define variable i-end         as integer no-undo.

   define variable c-label       as character format "x(50)" no-undo.
   define variable c-length      as character no-undo.

   define variable c-label1      as character format "x(50)" no-undo.
   define variable c-label2      as character format "x(50)" no-undo.
   define variable c-label3      as character format "x(50)" no-undo.

   define variable c-fieldname   as character no-undo.

   assign
      l-colstacked = no
      l-colnolabel = no
      i-prevcolumn = 0
      i-colnbr     = 0
      i-colbegpos  = 0
      i-colendpos  = 0
      i-colwidth   = 0.

   /* GET NUMBER OF COLUMNS, START AND END POSITIONS FROM WIDGET */
   /* FORMATS.                                                   */
   assign
      h-widget = p-frame:first-child
      h-widget = h-widget:first-child.
   do while valid-handle(h-widget):
      i-colnbr = i-colnbr + 1.
      if i-colnbr > 60
      then
         return "".

      /* RECORD COLUMN BEGINNING POSITION. */
      i-colbegpos[i-colnbr] = h-widget:column.
      if can-set(h-widget, "LABEL")
      then
         l-colnolabel[i-colnbr] = ( h-widget:label = "" or h-widget:label = ? ).
      else
         l-colnolabel[i-colnbr] = true.
      /* GET COLUMN WIDTH BASED ON FORMAT   */
      /* NOTE: WIDTH-CHAR ATTRIBUTE GIVES   */
      /* DIFFERENT RESULTS IN CHAR AND GUI. */
      run getFormatLength
         (input  h-widget,
          output i-colwidth[i-colnbr]).

      /* RECORD COLUMN ENDING POSITION. */
      i-colendpos[i-colnbr] =
         i-colbegpos[i-colnbr] + i-colwidth[i-colnbr] - 1.

      /* CHANGE END POSITION FOR PREVIOUS WIDGET IF CURRENT WIDGET OVERLAPS */
      if i-colnbr > 1 and i-colbegpos[i-colnbr] <= i-colendpos[i-colnbr - 1]
      then
         i-colendpos[i-colnbr - 1] = i-colbegpos[i-colnbr] - 1.

      if session:display-type <> "GUI" and
         i-colendpos[i-colnbr] > p-frame:width
      then
         /* Check for frame width */
         assign
            i-colendpos[i-colnbr] = p-frame:width - 2
            i-colwidth[i-colnbr]  = i-colendpos[i-colnbr] -
                                    i-colbegpos[i-colnbr] + 1.

      /* GET NEXT LITERAL WIDGET. */
      h-widget = h-widget:next-sibling.
   end.

   /* SPIN THROUGH FRAME'S FRAME-GROUPS FOR BACKGROUND FRAME-GROUP */
   /* WHICH HAS LITERAL WIDGETS USED FOR COLUMN LABELS. MAXIMIZE   */
   /* AND RECORD SPACE AVAILABLE FOR LABEL BASED ON WIDGET FORMAT  */
   /* LENGTH OR WIDGET LABEL LENGTH (WHICHEVER IS LONGER). DENOTE  */
   /* COLUMNS THAT ARE USING STACKED LABELS.                       */

   h-widget = p-frame:first-child.      /* FRAME-GROUP */
   do while valid-handle(h-widget):

      if not h-widget:foreground
      then do:
         /* BACKGROUND FRAME-GROUP. */
         assign
            h-literal = h-widget:handle
            h-literal = h-literal:first-child.

         do while valid-handle(h-literal):

            /* IGNORE COLUMN UNDERLINE WIDGET */
            if index(h-literal:screen-value,"--") =  0
            then do:

               /* EXPAND COLUMN LABEL LITERAL WIDGETS TO COLUMN    */
               /* WIDTH WHICH INCREASES AVAILABLE REAL ESTATE FOR  */
               /* TRANSLATED LABELS                                */

               /* IDENTIFY COLUMN THAT LITERAL WIDGET REPRESENTS   */

               do i-currcol = 1 to i-colnbr:

                  /*** CAUTION:  ANY CHANGE TO THE FOLLOWING CODE       ***/
                  /*** SHOULD TAKE INTO CONSIDERATION THE EFFECT IT     ***/
                  /*** WILL HAVE ON THE DISPLAY OF PROPORTIONAL FONTS   ***/

                  if  /* BEGIN LITERAL >= BEGPOS AND BEGIN LITERAL <= ENDPOS */
                      /* AND END LITERAL > ENDPOS                            */
                     ((integer(h-literal:column) >= i-colbegpos[i-currcol] and
                     integer(h-literal:column) <= i-colendpos[i-currcol]) and
                     (integer(h-literal:column) +
                     length(h-literal:SCREEN-VALUE,"raw") - 1)
                     <=
                     i-colendpos[i-currcol])
                     or
                     /* BEGIN LITERAL STARTS IN COLUMN RANGE AND DOESN'T END */
                     /* IN NEXT COLUMN'S RANGE                               */
                     ((integer(h-literal:column) >= i-colbegpos[i-currcol] and
                     integer(h-literal:column) <= i-colendpos[i-currcol]) and
                     integer(h-literal:column) < i-colbegpos[i-currcol + 1] )
                     or
                     /* LABEL IS LARGER THAN FORMAT AND FORMAT IS WITHIN  */
                     /* LITERAL COORDINATES                               */
                     (i-colbegpos[i-currcol] >= integer(h-literal:column) and
                     i-colendpos[i-currcol] <=integer(h-literal:column) +
                     length(h-literal:SCREEN-VALUE,"raw") - 1)
                  then
                     leave.
               end.

               /* IF LABEL IS LONGER THAN FORMAT USE LABEL COORDINATES */
               if length(h-literal:screen-value,"raw") > i-colwidth[i-currcol]
               then do:
                  assign
                     i-colbegpos[i-currcol] = h-literal:column
                     i-colendpos[i-currcol] = h-literal:column +
                                        length(h-literal:screen-value,"raw") - 1
                     i-colwidth[i-currcol] =
                                            length(h-literal:screen-value,"raw")
                     /* LITERAL POSITION CALCULATED ABOVE SHOULD NOT OVERLAP */
                     h-templiteral = h-literal:next-sibling.
                  if valid-handle(h-templiteral) and i-currcol < i-colnbr and
                     h-templiteral:row = h-literal:row
                  then do:
                     if integer(h-templiteral:column) >
                        i-colbegpos[i-currcol + 1] and
                        not(l-colnolabel[i-currcol + 1])
                     then
                        h-templiteral:column = i-colbegpos[i-currcol + 1].
                     if integer(h-templiteral:column) < i-colendpos[i-currcol]
                     then
                        assign
                           i-colendpos[i-currcol] =
                                               integer(h-templiteral:column) - 1
                           i-colwidth[i-currcol]  = i-colendpos[i-currcol] -
                                                     i-colbegpos[i-currcol] + 1.
                  end. /* if valid-handle(h-templiteral) */
               end.

               assign
                  /* SET COLUMN BEGINNING POSTION TO ALLOW EXPANSION */
                  h-literal:column = i-colbegpos[i-currcol]

                  /* EXPAND LITERAL TO FULL COLUMN WIDTH */
                  h-literal:width-chars = i-colwidth[i-currcol].

               /* DETERMINE IF THE COLUMN IS USING STACKED LABELS */
               if i-currcol = i-prevcolumn and
                  l-colstacked[i-currcol] = no
               then
                  l-colstacked[i-currcol] = yes.

               /* ASSIGN PREVIOUS COLUMN */
               i-prevcolumn = i-currcol.

            end. /* if index(h-literal:screen-value,"--") =  0 then do: */

            /* GET NEXT LITERAL WIDGET */
            h-literal = h-literal:next-sibling.
         end. /* do while valid-handle(h-literal): */
      end. /* if not h-widget:foreground then do: */
      /* GET NEXT FRAMEGROUP WIDGET */
      h-widget = h-widget:next-sibling.
   end. /* do while valid-handle(h-widget): */

   /* CYCLE THROUGH FRAME'S FIELDS, GETTING AND SETTING */
   /* THEIR TRANSLATED LABELS                           */
   assign
      h-widget = p-frame:first-child        /* FOREGROUND FIELD-GROUP */
      h-widget = h-widget:first-child       /* FIRST FIELD */
      i-currcol = 1.

   do while valid-handle(h-widget):
      assign
         c-label = ""
         c-fieldname = "".
      if h-widget:index = 0
      then
         c-fieldname = h-widget:name.
      else
         c-fieldname = h-widget:name + "[" + string(h-widget:index) + "]".

      /* SET LABEL FOR LABELED FIELDS */
      if can-set(h-widget, "LABEL")
      then do:

         /* IF WIDGET DOESN'T HAVE NO-LABEL FORMAT, */
         /* SET TRANSLATED LABELS                   */
         if h-widget:label <> ?
         then do:

            /* SINGLE COLUMN LABEL */
            if not l-colstacked[i-currcol]
            then do:

               /* GET LABEL FOR UNSTACKED LABELS */
               c-label =
                  getFieldLabel(input c-fieldname, input i-colwidth[i-currcol]).

               /* SET LABEL ON WIDGET IF ONE WAS FOUND */
               if c-label <> "^"
               then do:
                  /* JUSTIFY LABEL BY DATA TYPE */
                  run justifyLabelByDataType
                     (input h-widget,
                      input i-colwidth[i-currcol],
                      input-output c-label).

                  /* SET LABEL ON WIDGET */
                  h-widget:label = c-label.
               end. /* if c-label <> "^" then do */

            end. /* if not-column stacked */
            else do: /* column-stacked */

               /* GET STACKED COLUMN LABEL FOR FIELD */
               run getStackedLabel
                  (input  c-fieldname,
                   input  i-colwidth[i-currcol],
                   output c-label1,
                   output c-label2,
                   output c-label3).

               /* SET LABEL ON WIDGET IF ONE WAS FOUND */
               if c-label1 <> "^" or c-label2 <> "^" or
                  c-label3 <> "^"
               then do:

                  /* SET LITERAL WIDGETS USED FOR STACKED LABELS */
                  run setStackedColumnLabels
                     (input p-frame,
                      input h-widget,
                      input i-currcol,
                      input c-label1,
                      input c-label2,
                      input c-label3).

               end. /* if c-label1 <> "^" or c-label2 <> "^" or */

            end. /* column-stacked */

         end. /*if h-widget:label <> ? then do:*/

      end. /* can-set label */
      else do:

         /* GET LABEL FOR HARDCODED STRINGS */
         if h-widget:type = "LITERAL"
         then
            /* SET LABEL */
            h-widget:screen-value =
               getTermLabel(h-widget:screen-value,
               length(h-widget:screen-value,"raw")).
         else
            if /* TEST TO SEE IF VARIABLE IS A LABEL */
               h-widget:screen-value <> ""
            then do:
               /* USE EXISTING LENGTH FOR VARIABLES USED AS LABELS */
               assign
                  i-beg = index(h-widget:format,"(")
                  i-end = index(h-widget:format,")")
                  i-available = integer(substring
                          (h-widget:format,i-beg + 1 ,i-end - i-beg - 1,"raw")).
                  /* GET LABEL */
                  c-label = getFieldLabel(c-fieldname,i-available).

               /* SET LABEL ON WIDGET IF ONE WAS FOUND */
               if c-label <> "^"
               then do:
                  h-widget:screen-value = c-label.

                  /* SET LITERAL WIDGETS VALUE = TO SCREEN-VALUE */
                  if can-set(h-widget, "VALUE")
                  then
                     h-widget:value = h-widget:screen-value.
               end. /* if c-label <> "^" then do */
           end.
        end.

        assign
           /* GET NEXT FIELD WIDGET */
           h-widget = h-widget:next-sibling
           i-currcol = i-currcol + 1.

   end. /*do while valid-handle(h-widget)...*/

   /* REGISTER FRAME AS TRANSLATED. */
   run addFrameRegistration
      (input p-frame).

   return "".

END PROCEDURE. /* setColumnLabels */

FUNCTION  setColumnLabelsUnstacked returns character
      (input p-frame as handle).
/*------------------------------------------------------------------
Purpose:    Private method.
            Sets translated labels on frames using column labels.
Parameters: Input p-frame - Handle of frame to set labels on.
Notes:      This function accepts as input a frame handle. First it
            walks the frames foreground framegroup to identify how
            many columns and each column's coordinates defined by the
            fields format.
            Once the number of columns and their coordinates have been
            identified the function then walks the frame's background
            framegroup identifying literal widgets that are used to display
            column labels. The literal widgets are expanded to the
            full format size to maximize real estate for translated
            labels.
            The translated label is then retrieved and
            set for each widget on the frame.
------------------------------------------------------------------*/
   define variable h-widget      as handle no-undo.
   define variable h-background  as handle no-undo.
   define variable h-literal     as handle no-undo.
   define variable h-templiteral as handle no-undo.
   define variable h-next        as handle no-undo.
   define variable h-prev        as handle no-undo.

   define variable i-colnbr      as integer no-undo.
   define variable i-headerwidth as integer no-undo.
   define variable i-prevcolumn  as integer no-undo.
   define variable i-currcol     as integer no-undo.
   define variable i-colbeg      as integer no-undo.
   define variable i-colend      as integer no-undo.
   define variable i-available   as integer no-undo.
   define variable i-beg         as integer no-undo.
   define variable i-end         as integer no-undo.

   define variable c-label       as character format "x(50)" no-undo.
   define variable c-length      as character no-undo.

   define variable c-label1      as character format "x(50)" no-undo.
   define variable c-label2      as character format "x(50)" no-undo.
   define variable c-label3      as character format "x(50)" no-undo.

   define variable c-fieldname   as character no-undo.

   /* IF TRANSLATED FRAMES IS TURNED OFF DO NOT */
   /* USE EXTERNALIZED LABELS.                  */
   run getLabelControl(buffer lblc_ctrl).
   if not available lblc_ctrl or
      available lblc_ctrl and not lblc_ctrl.lblc_trans_frame
   then leave.

   assign
      l-colstacked = no
      l-colnolabel = no
      i-prevcolumn = 0
      i-colnbr     = 0
      i-colbegpos  = 0
      i-colendpos  = 0
      i-colwidth   = 0.

   /* GET NUMBER OF COLUMNS, START AND END POSITIONS FROM WIDGET */
   /* FORMATS.                                                  */
   assign
      h-widget = p-frame:first-child
      h-widget = h-widget:first-child.

   do while valid-handle(h-widget):
      i-colnbr = i-colnbr + 1.
      if i-colnbr > 60
      then
         return "".

      assign
         /* RECORD COLUMN BEGINNING POSITION. */
         i-colbegpos[i-colnbr] = h-widget:column
         l-colnolabel[i-colnbr] = ( h-widget:label = "" or h-widget:label = ? ).

      /* GET COLUMN WIDTH BASED ON FORMAT   */
      /* NOTE: :WIDTH-CHAR ATTRIBUTE GIVES  */
      /* DIFFERENT RESULTS IN CHAR AND GUI. */
      run getFormatLength
         (input  h-widget,
         output i-colwidth[i-colnbr]).

      assign
         /* RECORD COLUMN ENDING POSITION. */
         i-colendpos[i-colnbr] =
                                i-colbegpos[i-colnbr] + i-colwidth[i-colnbr] - 1
         /* GET NEXT LITERAL WIDGET. */
         h-widget = h-widget:next-sibling.
   end.

   h-widget = p-frame:first-child.      /* FRAMEGROUP */

   do while valid-handle(h-widget):

      if not h-widget:foreground
      then do:
         /* BACKGROUND FRAME GROUP */
         assign
            h-literal = h-widget:handle
            h-literal = h-literal:first-child
            i-currcol = 0.

         do while valid-handle(h-literal):

            /* IGNORE COLUMN UNDERLINE WIDGET */
            if index(h-literal:screen-value,"--") =  0
            then do:

               /* EXPAND COLUMN LABEL LITERAL WIDGETS TO COLUMN    */
               /* WIDTH WHICH INCREASES AVAILABLE REAL ESTATE FOR  */
               /* TRANSLATED LABELS                                */

               /* IDENTIFY COLUMN THAT LITERAL WIDGET REPRESENTS  */

               i-currcol = i-currcol + 1.

               /* IF LABEL IS LONGER THAN FORMAT USE LABEL COORDINATES */
               if length(h-literal:screen-value,"raw") > i-colwidth[i-currcol]
               then do:
                  assign
                     i-colbegpos[i-currcol] = h-literal:column
                     i-colendpos[i-currcol] = h-literal:column +
                                        length(h-literal:screen-value,"raw") - 1
                     i-colwidth[i-currcol] =
                                            length(h-literal:screen-value,"raw")
                     /* LITERAL POSITION CALCULATED ABOVE SHOULD NOT OVERLAP */
                     h-templiteral = h-literal:next-sibling.
                  if valid-handle(h-templiteral) and i-currcol < i-colnbr and
                     h-templiteral:row = h-literal:row
                  then do:
                     if integer(h-templiteral:column) >
                        i-colbegpos[i-currcol + 1] and
                        not (l-colnolabel[i-currcol + 1])
                     then
                        h-templiteral:column = i-colbegpos[i-currcol + 1].
                     if integer(h-templiteral:column) < i-colendpos[i-currcol]
                     then
                        assign
                           i-colendpos[i-currcol] =
                                               integer(h-templiteral:column) - 1
                           i-colwidth[i-currcol]  = i-colendpos[i-currcol] -
                                                     i-colbegpos[i-currcol] + 1.
                  end. /* if valid-handle(h-templiteral) */
               end.

               assign
                  /* SET COLUMN BEGINNING POSTION TO ALLOW EXPANSION */
                  h-literal:column = i-colbegpos[i-currcol]

                  /* EXPAND LITERAL TO FULL COLUMN WIDTH */
                  h-literal:width-chars = i-colwidth[i-currcol]

                  /* ASSIGN PREVIOUS COLUMN */
                  i-prevcolumn = i-currcol.

            end. /* if index(h-literal:screen-value,"--") =  0 then do: */

            /* GET NEXT LITERAL WIDGET */
            h-literal = h-literal:next-sibling.
         end. /* do while valid-handle(h-literal): */
      end. /* if not h-widget:foreground then do: */
      /* GET NEXT FRAMEGROUP WIDGET */
      h-widget = h-widget:next-sibling.
   end. /* do while valid-handle(h-widget): */

   /* CYCLE THROUGH FRAMES FIELD'S, GETTING AND SETTING */
   /* THEIR TRANSLATED LABELS                           */
   assign
      h-widget = p-frame:first-child        /*ForeGround Field-Group*/
      h-widget = h-widget:first-child       /*first field*/
      i-currcol = 1.

   do while valid-handle(h-widget):

      assign
         c-label = ""
         c-fieldname = "".
      if h-widget:index = 0
      then
         c-fieldname = h-widget:name.
      else
         c-fieldname = h-widget:name + "[" + string(h-widget:index) + "]".

      /* SET LABEL FOR LABELED FIELDS */
      if can-set(h-widget, "LABEL")
      then do:

         /* IF WIDGET DOESN'T HAVE NO-LABEL FORMAT */
         /* SET TRANSLATED LABELS                  */
         if h-widget:label <> ?
         then do:

            /* GET LABEL FOR UNSTACKED LABELS */
            c-label =
               getFieldLabel(input c-fieldname, input i-colwidth[i-currcol]).

            /* SET LABEL ON WIDGET IF ONE WAS FOUND. */
            if c-label <> "^"
            then do:
               /* JUSTIFY LABEL BY DATA TYPE */
               run justifyLabelByDataType
                  (input h-widget,
                   input i-colwidth[i-currcol],
                   input-output c-label).

               /* SET LABEL ON WIDGET */
               h-widget:label = c-label.
            end. /* if c-label <> "^" then do */

         end. /*if h-widget:label <> ? then do:*/

      end. /* can-set label */

      /* GET NEXT FIELD WIDGET */
      assign
         h-widget = h-widget:next-sibling
         i-currcol = i-currcol + 1.

   end. /* do while valid-handle(h-widget)...*/

   /* REGISTER FRAME AS TRANSLATED */
   run addFrameRegistration
      (input p-frame).

   return "".

END FUNCTION . /* setColumnLabelsUnstacked */

PROCEDURE getStackedLabel:
/*------------------------------------------------------------------
Purpose:    Private method.
            Returns the stacked label for a specified field.
Parameters: Input  p-field  - Field to get stacked label for.
            Output p-label1 - String returned as top label.
                   p-label2 - String returned as middle label(triple Stacked)
                              or bottom label(stacked labels).
                   p-label3 - String returned as bottom label(triple stacked
                              labels).
Notes:      If no label is found, c-term will be returned as top
            and bottom label.
------------------------------------------------------------------*/
   define input  parameter p-field    as character.
   define input  parameter p-length   as integer.
   define output parameter p-label1   as character.
   define output parameter p-label2   as character.
   define output parameter p-label3   as character.

   define variable i-pos as integer  extent 2 no-undo.
   define variable i     as integer           no-undo.

   c-execname = substring(execname,1,r-index(execname,".") - 1,"raw").

   for first tt_lbl
      where
         tt_lbl_lang      = global_user_lang and
         tt_lbl_execname  = execname and
         tt_lbl_fieldname = p-field
      no-lock :
   end.
   if not available ( tt_lbl )
   then do:
      /* CREATE RECORD IN TEMP TABLE IF LABEL IS DIFFERENT FOR EXECNAME */
      for first lbld_det
         where
            lbld_fieldname = p-field and
            entry(1,lbld_execname,".") = c-execname
         no-lock:
      end.
      if available ( lbld_det )
      then do:
         for first  lbl_mstr
            where
               lbl_lang = global_user_lang and
               lbl_term = lbld_term
            no-lock:
         end.
         if available ( lbl_mstr )
         then do:
            create tt_lbl.
            assign
               tt_lbl_lang      = global_user_lang
               tt_lbl_execname  = lbld_execname
               tt_lbl_fieldname = lbld_fieldname
               tt_lbl_term      = lbl_term
               tt_lbl_long      = lbl_long
               tt_lbl_medium    = lbl_medium
               tt_lbl_short     = lbl_short
               tt_lbl_stacked   = lbl_stacked.
         end. /* available ( lbl_mstr ) */
      end. /* if available ( lbld_det ) then */
      else do:
         for first tt_lbl
            where
               tt_lbl_lang      = global_user_lang and
               tt_lbl_execname  = "" and
               tt_lbl_fieldname = p-field
            no-lock:
         end.
         if not available ( tt_lbl )
         then do:
            for first lbld_det
               where
                  lbld_execname  = ""       and
                  lbld_fieldname = p-field
               no-lock:
            end.
            if available ( lbld_det )
            then do:
               find lbl_mstr
                  where
                     lbl_lang = global_user_lang and
                     lbl_term = lbld_term
                  no-lock no-error.
               if available ( lbl_mstr )
               then do:
                  create tt_lbl.
                  assign
                     tt_lbl_lang      = global_user_lang
                     tt_lbl_execname  = lbld_execname
                     tt_lbl_fieldname = lbld_fieldname
                     tt_lbl_term      = lbl_term
                     tt_lbl_long      = lbl_long
                     tt_lbl_medium    = lbl_medium
                     tt_lbl_short     = lbl_short
                     tt_lbl_stacked   = lbl_stacked.
               end. /* available ( lbl_mstr ) */
            end.
         end.
      end.
   end.
   if available ( tt_lbl )
   then do:
      if tt_lbl_stacked <> "" and tt_lbl_stacked <> ?
      then do:
         i-pos = 0.
         /* Find delimiters */
         do i = 1 to 2:
            if i = 1
            then
               i-pos[i] = index(tt_lbl_stacked,"!").
            else
               if i = 2
               then
                  i-pos[i] = index(tt_lbl_stacked,"!",i-pos[i - 1] + 1) .
         end.

         /* NOTE: SUBSTRING AND LENGTH FUNCTIONS USED TO DETERMINE VALUES OF */
         /*       VARAIBLES p-label1, p-label2 AND p-label3 MUST PASS TYPE   */
         /*       AS "CHARACTER" AND NOT "RAW".                              */

         /* PARSE FIRST LABEL */
         p-label1 = substring(tt_lbl_stacked,1,i-pos[1] - 1,"character").

         /* FOR STACKED LABELS PARSE SECOND LABEL. */
         if i-pos[2] = 0
         then
            p-label2 = substring(tt_lbl_stacked,i-pos[1] + 1,
                          length(tt_lbl_stacked,"character"),"character").
         else do: /* TRIPLE STACKED PARSE SECOND AND THIRD LABELS. */
            assign
               p-label2 = substring(tt_lbl_stacked,i-pos[1] + 1,
                                    i-pos[2] - i-pos[1] - 1, "character")
               p-label3 = substring(tt_lbl_stacked,i-pos[2] + 1,
                             length(tt_lbl_stacked,"character"),"character").
         end.

      end.
   end.

   run getLabelControl(buffer lblc_ctrl).

   /* IF NO LABEL TRANSLATION WAS FOUND */
   if ( p-label1 = "" or p-label1 = ? ) and
      ( p-label2 = "" or p-label2 = ? ) and
      ( p-label3 = "" or p-label3 = ? )
   then do:
      /* PRODUCTION MODE RETURNS NOT FOUND SYMBOL */
      if lblc_ctrl.lblc__qadl01 = no
      then
         assign
            p-label1 = "^"
            p-label2 = "^"
            p-label3 = "^".
      else /* TEST MODE:RETURNS FIELD CAPITALIZED. */
         p-label1 = caps(p-field).
   end.

   /* LIMIT LENGTH TO REQUESTED SIZE */
   assign
      p-label1 = substring(p-label1,1,p-length,"raw")
      p-label2 = substring(p-label2,1,p-length,"raw")
      p-label3 = substring(p-label3,1,p-length,"raw").

END PROCEDURE. /* getStackedLabel */

PROCEDURE setStackedColumnLabels:
/*------------------------------------------------------------------
Purpose:    Private method.
            Identifies literal widgets used for stacked column labels
            and sets them to input values.
Parameters: Input p-frame  - Frame handle.
                  p-widget - Widget labels are being set for.
                  p-column - Column number widget is representing.
                  p-label1 - String used as top label.
                  p-label2 - String used as middle label (for triple stacked)
                             or bottom label (for double stacked labels).
                  p-label3 - String used as bottom label (for triple stacked
                             labels).
Notes:
------------------------------------------------------------------*/
   define input parameter p-frame as handle no-undo.
   define input parameter p-widget as handle no-undo.
   define input parameter p-column as integer no-undo.
   define input parameter p-label1 as character format "x(50)" no-undo.
   define input parameter p-label2 as character format "x(50)" no-undo.
   define input parameter p-label3 as character format "x(50)" no-undo.

   define variable h-widget as handle no-undo.
   define variable h-background as handle no-undo.
   define variable l-setlabel as logical extent 3 no-undo initial no.

   define variable i-cnt as integer no-undo.

   assign
      l-setlabel[1] = yes
      h-widget = p-frame:first-child.      /* FRAMEGROUP */

   /* SPIN THROUGH FRAMEGROUPS TO FIND BACKGROUND FRAMEGROUP */
   /* WHICH CONTAINS WIDGETS USED FOR COLUMN LABELS          */
   do while valid-handle(h-widget):

      /* BACKGROUND FRAMEGROUP */
      if not h-widget:foreground
      then do:
         assign
            h-background = h-widget:handle
            h-background = h-background:first-child.

         do while valid-handle(h-background):

            /* DO NOT RESET VALUES ON UNDERSCORE COLUMN LABEL */
            if index(h-background:screen-value,"--") =  0
            then do:

               /* IDENIFY WHICH COLUMN # THE LITERAL WIDGET IS FOR */
               do i-cnt = 1 to 60:
                  if h-background:column >= i-colbegpos[i-cnt] and
                     h-background:column <= i-colendpos[i-cnt]
                  then
                     leave.
               end.

               /* IF THE LITERAL WIDGET IS USED ON THIS COLUMN */
               /* SET THE LABEL                                */
               if i-cnt = p-column
               then do:

                  /* SET COLUMN POSITION OF A LITERAL WIDGET IF IT IS */
                  /* CHANGED BECAUSE OF SECOND STACKED COLUMN LABEL   */
                  if h-background:column > i-colbegpos[p-column]
                  then
                     h-background:column = i-colbegpos[p-column].

                  /* SET WIDTH OF A LITERAL WIDGET IF IT IS CHANGED */
                  /* BECAUSE OF SECOND STACKED COLUMN LABEL         */
                  if h-background:width-chars < i-colwidth[p-column]
                  then
                     h-background:width-chars = i-colwidth[p-column].

                  /* FIRST TIME THROUGH SET 1st LABEL */
                  if l-setlabel[1]
                  then do:
                     if p-label1 <> "^"
                     then do:
                        run justifyLabelByDataType
                           (input        p-widget,
                            input        i-colwidth[p-column],
                            input-output p-label1).
                        h-background:screen-value = p-label1.
                     end.
                     assign
                        l-setlabel[1] = no
                        l-setlabel[2] =yes.
                  end.
                  else
                     if l-setlabel[2]
                     then do: /* SET 2nd LABEL */
                        if p-label2 <> "^"
                        then do:
                           run justifyLabelByDataType
                              (input        p-widget,
                               input        i-colwidth[p-column],
                               input-output p-label2).
                           h-background:screen-value = p-label2.
                     end.
                     assign
                        l-setlabel[2] = no
                        l-setlabel[3] =yes.
                  end.
                  else
                     if l-setlabel[3]
                     then do: /* SET 3rd LABEL */
                        if p-label3 <> "^"
                        then do:

                           run justifyLabelByDataType
                              (input        p-widget,
                               input        i-colwidth[p-column],
                               input-output p-label3).
                           h-background:screen-value = p-label3.
                     end.
                        l-setlabel[3] = no.
                  end.

               end.

            end.

            /* IF ALL 3 LABELS FOR THE COLUMN HAVE BEEN SET, THEN LEAVE */
            if not l-setlabel[1] and
               not l-setlabel[2] and
               not l-setlabel[3]
            then
               leave.

            /* GET NEXT WIDGET IN FRAME */
            h-background = h-background:next-sibling.
         end. /* do while valid-handle(h-background): */
      end. /* if not h-widget:foreground then do: */
      h-widget = h-widget:next-sibling.
   end. /* do while valid-handle(h-widget): */

END PROCEDURE. /*  setStackedColumnLabels */

PROCEDURE justifyLabelByDataType:
/*------------------------------------------------------------------
Purpose:    Private method.
            Right justifies label according to data-type widget is
            being set for.
Parameters: Input        p-widget     - The widget the label is being set for.
                         p-realestate - Character length available for label.
            Input-Output p-label      - Actual label.
Notes:      Used primarily for setting column labels. Side-labels
            are always right-justified.
------------------------------------------------------------------*/
   define input parameter p-widget as handle no-undo.
   define input parameter p-realestate as integer no-undo.
   define input-output parameter p-label as character format "x(50)" no-undo.

   define variable i-labelwidth  as integer no-undo.
   define variable i-pos         as integer no-undo.

   /* ONLY NUMERIC FIELD LABELS ARE RIGHT JUSTIFIED */
   if p-widget:data-type = "DECIMAL" or
      p-widget:data-type = "INTEGER"
   then do:
      run rightJustifyLabel
         (input        p-realestate,
          input-output p-label).
   end.

END PROCEDURE.

PROCEDURE centerLabel:
/*------------------------------------------------------------------
Purpose:    Private method.
            Centers label within a string of a certain length.
Parameters: Input        p-realestate - Length (in bytes) available for label.
            Input-Output p-label      - Label.
Notes:
------------------------------------------------------------------*/
   define input parameter p-length as integer no-undo.
   define input-output parameter p-label as character format "x(80)" no-undo.

   define variable i-labelwidth  as integer no-undo.
   define variable i-pos         as integer no-undo.

   i-labelwidth  = length(p-label,"raw").

   /* IF LABEL LENGTH IS LESS THAN AVAILABLE SPACE CENTER LABEL */
   if i-labelwidth  < p-length
   then do:
      /* GET STARTING POSITION */
      i-pos = integer((p-length - (i-labelwidth )) / 2).
      p-label = fill(" ",i-pos) + p-label +
         fill(" ", p-length - i-labelwidth - i-pos ).
   end.

END PROCEDURE. /* centerLabel */

PROCEDURE rightJustifyLabel:
/*------------------------------------------------------------------
Purpose:    Private method.
            Right-justifies label within a string of a specified length.
Parameters: Input        p-realestate - Length (in bytes) available for label.
            Input-Output p-label      - Label.
Notes:
------------------------------------------------------------------*/
   define input parameter p-realestate as integer no-undo.
   define input-output parameter p-label as character format "x(50)" no-undo.

   define variable i-labelwidth  as integer no-undo.
   define variable i-pos         as integer no-undo.

   i-labelwidth  = length(p-label,"raw").
   /* IF LABEL LENGTH IS LESS THAN COLUMN WIDTH RT JUSTIFY */
   if i-labelwidth  < p-realestate
   then
      assign
         /* GET STARTING POSITION */
         i-pos = p-realestate - i-labelwidth
         p-label = fill(" ",i-pos) + p-label.

END PROCEDURE. /* rightJustifyLabel */

PROCEDURE checkFrameRegistration:
/*------------------------------------------------------------------
Purpose:    Private method.
            Checks if frame has already been translated for a
            particular program.
Parameters: Input  h-frame            - Frame handle.
            Output p-frame-registered - Logical set to true denoting frame
                                        translation has already been performed.
Notes:      For better performance, Frame Registration prevents already
            translated frames from being translated more than once
            within the repeated iterations of a loop.
------------------------------------------------------------------*/
   define input parameter p-frame as handle no-undo.
   define output parameter p-frame-registered as logical no-undo.

   p-frame-registered = (p-frame:private-data = "TRANSLATED").

END PROCEDURE. /* checkFrameRegistration */

PROCEDURE addFrameRegistration:
/*------------------------------------------------------------------
Purpose:    Private method. Sets "already translated" flag.
Parameters: Input h-frame - Frame handle.
Notes:      For better performance, Frame Registration prevents already
            translated frames from being translated more than once
            within the repeated iterations of a loop.
------------------------------------------------------------------*/
   define input parameter p-frame as handle no-undo.

   p-frame:private-data = "TRANSLATED".

END PROCEDURE. /* addFrameRegistration */

PROCEDURE getFormatLength:
/*------------------------------------------------------------------
Purpose:    Private method.
            Calculates format length in bytes.
Parameters: Input  p-widget - Handle to widget.
            Output p-length - Integer length of format.
Notes:
------------------------------------------------------------------*/
   define input  parameter p-widget as handle.
   define output parameter p-length as integer.

   define variable i-beg        as integer.
   define variable i-end        as integer.

   if p-widget:data-type = "CHARACTER"
   then do:
      /* IF WIDGET IS SELECTION-LIST  RETURN 0 SINCE WE CAN'T CALC WIDTH */
      if p-widget:type <> "SELECTION-LIST"
         and p-widget:type <> "EDITOR"
      then do:

         /* GET STANDARD CHARACTER FORMAT i.e."x(12)" */
         if index(p-widget:format,"(") <> 0
         then do:
            assign
               i-beg = index(p-widget:format,"(")
               i-end = index(p-widget:format,")")
               p-length = integer(substring(p-widget:format,i-beg + 1,
                                  i-end - i-beg - 1,"raw")).
         end.
         else do: /*NON-STANDARD FORMATS: "x", "xx:xx", "xx/xx" etc... */
            p-length = length(p-widget:format,"raw").
         end.
      end.
   end.
   else
   if p-widget:data-type = "INTEGER"  or
      p-widget:data-type = "DATE"
   then do:
      /* IF WIDGET IS RADIO-SET RETURN 0 SINCE WE CAN'T CALC WIDTH */
      if p-widget:type <> "RADIO-SET"
      then
         p-length = length(p-widget:format,"raw").
   end.
   else
   if p-widget:data-type = "DECIMAL"
   then do:
      if index(p-widget:FORMAT,"<")  > 0
      then
         p-length = index(p-widget:FORMAT,"<") - 1.
      else
         p-length = length(p-widget:format,"raw").
   end.
   else
      if p-widget:data-type = "LOGICAL"
      then
         assign
            i-end = length(p-widget:format,"raw")
            i-beg = index(p-widget:format,"/")
            p-length = max(i-beg - 1, i-end - i-beg).
      else
      if p-widget:type = "LITERAL"
      then
         p-length = length(p-widget:screen-value,"raw").

END PROCEDURE. /* getFormatLength */

PROCEDURE getAvailableSideLabelSize:
/*------------------------------------------------------------------
Purpose:    Private method.
            Calculates maximum available size in bytes for a label.
Parameters: Input  h-labeledwidget - Handle to widget that is displaying
                                     string on the UI.
            Output i-available     - Integer length of available space for
                                     label.
Notes:
------------------------------------------------------------------*/
   define input  parameter h-labeledwidget as handle.
   define output parameter i-available as integer.

   define variable i-row as integer.
   define variable i-nextcolumn as integer.
   define variable i-currlength as integer.

   define variable i-prevlength as integer.
   define variable i-beg        as integer.
   define variable i-end        as integer.

   define variable h-prevsibling as handle.

   /* GET HANDLE TO WIDGET PRECEDING THIS WIDGET */
   h-prevsibling = h-labeledwidget:prev-sibling.

   /* DETERMINE IF WIDGET IS FIRST WIDGET IN ROW */
   if not valid-handle(h-prevsibling)               /* FIRST ROW FIRST LABEL */
      or h-labeledwidget:row <> h-prevsibling:row   /* FIRST WIDGET IN ROW   */
   then do:
      /* IF LABEL HAS BEEN HARD CODED TO COLUMN 1 USE 1 AS NEXT COLUMN. */
      if h-labeledwidget:column = 1
      then
         i-nextcolumn = 1.
      else /* SET NEXT AVAILABLE COLUMN = 2 */
      i-nextcolumn = 2.

      /* CALCULATE AVAILABLE SPACE */
      i-available = length(h-labeledwidget:screen-value,"raw") +
                    (h-labeledwidget:column - i-nextcolumn).

   end.
   else do:
      /* REST OF LABELED WIDGETS IN ROW ALWAYS HAVE A PREVIOUS SIBLING */
      if valid-handle(h-prevsibling)
      then do:

         /* GET LENGTH OF PREVIOUS FIELD */
         run getFormatLength
            (input  h-prevsibling,
             output i-prevlength).

         /* IF WE COULD CALCULATE A LENGTH ON PREVIOUS WIDGET */
         if i-prevlength > 0
         then
            assign
               /* CALCULATE NEXT AVAILABLE COLUMN */
               i-nextcolumn = h-prevsibling:column + i-prevlength + 1
               /* CALCULATE AVAILABLE LENGTH */
               i-available = length(h-labeledwidget:screen-value,"raw") +
                                        (h-labeledwidget:column - i-nextcolumn).
         else do:
            /* WE COULDN'T GET A FORMAT LENGTH FROM PREVIOUS WIDGET */
            /* LET'S USE EXISTING LABEL LENGTH.                     */
            i-available = length(h-labeledwidget:screen-value,"raw").
         end.

         /* IF CALCULATED LENGTH IS LESS THAN CURRENT LENGTH */
         /* THEN USE CURRENT LENGTH. THIS OCCURS WHEN THE    */
         /* PREVIOUS FIELD HAS A FORMAT LENGTH GREATER THAN  */
         /* ITS VIEW-AS SIZE. SINCE WIDTH-CHARS ATTRIBUTE    */
         /* GIVES SKEWED RESULTS BETWEEN CHAR AND GUI THERE  */
         /* DOESN'T SEEM TO BE A BETTER WAY TO DO THIS.      */
         if i-available < length(h-labeledwidget:screen-value,"raw")
         then
            i-available = length(h-labeledwidget:screen-value,"raw").

      end. /* if valid-handle(h-prevsibling) then do: */
   end. /* else do: */

END PROCEDURE. /* getAvailableSideLabelSize */

FUNCTION setBrowseLabels returns character
      (input p-browse as handle).
/*------------------------------------------------------------------
Purpose:    Public function.
            Sets translated labels on browse's.
Parameters: Input p-browse - Handle of browse to set labels on.
Notes:
------------------------------------------------------------------*/
   define variable h-widget  as handle    no-undo.
   define variable i-length  as integer   no-undo.
   define variable c-label   as character no-undo.
   define variable save-exec as character no-undo.

   /* IF TRANSLATED FRAMES IS TURNED OFF DO NOT */
   /* USE EXTERNALIZED LABELS                   */
   run getLabelControl(buffer lblc_ctrl).
   if not available lblc_ctrl or
      ( available lblc_ctrl and not lblc_ctrl.lblc_trans_frame )
   then
      leave.

   assign
      save-exec = execname
      execname = program-name(2).

   /* If this is a lookup and there is a power browse, it should be execname */
   {gpstrip.i execname}

   if substring(execname,3,2) = "lu" then do:
      if (search(substring(execname,1,2) + "br" +
                 substring(execname,5) + ".p") <> ?)
      or (search(global_user_lang_dir + substring(execname,1,2) + "/" +
          substring(execname,1,2) + "br" + substring(execname,5) + ".r") <> ?)
      then do:
      substring(execname,3,2) = "br".
      end.
   end.

   h-widget = p-browse:first-column .

   do while valid-handle(h-widget):

      /* SET LABEL FOR LABELED FIELDS */
      if can-set(h-widget, "LABEL") and
         h-widget:label <> ?
      then do:

         /* GET WIDTH OF COLUMN IN CHARACTERS */
         run getFormatLength
            (input h-widget,
             output i-length).

         /*  LENGTH OF LABEL IS LONGER THAN FORMAT LENGTH */
         if i-length < length(h-widget:label,"raw")
         then
            i-length = length(h-widget:label,"raw").

         /* FIND THE LABEL FOR A BROWSE FIELD BASED ON NAME/EXECUTABLE */
         /* SINGLE COLUMN LABEL */
         if index(h-widget:label,"!") = 0
         then
            /* GET LABEL FOR UNSTACKED LABELS */
            c-label = getFieldLabel(input substring(h-widget:name,4), i-length).

         if index(h-widget:label,"!") <> 0 or c-label = "^"
         then do:
            assign
               c-execname = substring(execname,1,r-index(execname,".") - 1 )
               c-label    = "^".

            /* FIND A DETAIL RECORD FOR THE FIELD NAME/BROWSE NAME */
            for first lbld_det
               where
                  lbld_fieldname = substring(h-widget:name,4) and
                  entry(1,lbld_execname,".") = c-execname
               no-lock:
            end.

            if available (lbld_det)
            then do:
               for first  lbl_mstr
                  where
                     lbl_lang = global_user_lang and
                     lbl_term = lbld_term
                  no-lock:
                  if lbl_stacked <> ""
                  then
                     c-label = lbl_stacked.
               end.
            end.
            else do:
               for first lbld_det
                  where
                     lbld_fieldname = substring(h-widget:name,4) and
                     lbld_execname  = ""
                  no-lock:
               end.

               if available (lbld_det)
               then do:
                  for first lbl_mstr
                     where
                        lbl_lang = global_user_lang and
                        lbl_term = lbld_term
                     no-lock:
                    if lbl_stacked <> ""
                    then
                       c-label = lbl_stacked.
                  end.
               end.

            end. /* else do */

         end. /* if the label is stacked */

         /* GET TERM LABEL USING BROWSE LABEL. */
         if c-label = "^"
         then
            c-label = getTermLabel(input h-widget:label, input i-length).

         /* SET LABEL ON WIDGET IF ONE WAS FOUND. */
         if c-label <> "^"
         then
            h-widget:label = c-label.

         /* GET NEXT COLUMN */
         h-widget = h-widget:next-column.

      end. /* if can-set(h-widget,"LABEL")        */
   end. /* do while valid-handle(h-widget): */

   execname = save-exec.

END FUNCTION. /* setBrowseLabels */

FUNCTION setFrameBrowseLabels returns character
      (input p-browse as handle).
/*------------------------------------------------------------------
Purpose:    Public function.
            Sets translated labels on browses in frame.
Parameters: Input p-browse - Handle of browse to set labels on.
Notes:
------------------------------------------------------------------*/
   define variable h-widget  as handle    no-undo.
   define variable i-length  as integer   no-undo.
   define variable c-label   as character no-undo.

   /* IF TRANSLATED FRAMES IS TURNED OFF DO NOT */
   /* USE EXTERNALIZED LABELS                   */
   run getLabelControl(buffer lblc_ctrl).
   if not available lblc_ctrl or
      ( available lblc_ctrl and not lblc_ctrl.lblc_trans_frame )
   then
      leave.

   h-widget = p-browse:first-column .

   do while valid-handle(h-widget):

      /* SET LABEL FOR LABELED FIELDS */
      if can-set(h-widget, "LABEL") and
         h-widget:label <> ?
      then do:

         /* GET WIDTH OF COLUMN IN CHARACTERS */
         run getFormatLength
            (input h-widget,
             output i-length).

         /*  LENGTH OF LABEL IS LONGER THAN FORMAT LENGTH */
         if i-length < length(h-widget:label,"raw")
         then
            i-length = length(h-widget:label,"raw").

         /* FIND THE LABEL FOR A BROWSE FIELD BASED ON NAME/EXECUTABLE */
         /* SINGLE COLUMN LABEL */
         if index(h-widget:label,"!") = 0
         then
            /* GET LABEL FOR UNSTACKED LABELS */
            c-label = getFieldLabel(input h-widget:name, i-length).

         if index(h-widget:label,"!") <> 0 or c-label = "^"
         then do:
            assign
               c-execname = substring(execname,1,r-index(execname,".") - 1 )
               c-label    = "^".

            /* FIND A DETAIL RECORD FOR THE FIELD NAME/BROWSE NAME */
            for first lbld_det
               where
                  lbld_fieldname = h-widget:name and
                  entry(1,lbld_execname,".") = c-execname
               no-lock:
            end.

            if available (lbld_det)
            then do:
               for first  lbl_mstr
                  where
                     lbl_lang = global_user_lang and
                     lbl_term = lbld_term
                  no-lock:
                  if lbl_stacked <> ""
                  then
                     c-label = lbl_stacked.
               end.
            end.
            else do:
               for first lbld_det
                  where
                     lbld_fieldname = h-widget:name and
                     lbld_execname = ""
                  no-lock:
               end.

               if available (lbld_det)
               then do:
                  for first lbl_mstr
                     where
                        lbl_lang = global_user_lang and
                        lbl_term = lbld_term
                     no-lock:
                     if lbl_stacked <> ""
                     then
                        c-label = lbl_stacked.
                  end.
               end.

            end. /* else do */

         end. /* if the label is stacked */

         /* GET TERM LABEL USING BROWSE LABEL. */
         if c-label = "^"
         then
            c-label = getTermLabel(input h-widget:label, input i-length).

         /* SET LABEL ON WIDGET IF ONE WAS FOUND. */
         if c-label <> "^"
         then
            h-widget:label = c-label.

         /* GET NEXT COLUMN */
         h-widget = h-widget:next-column.

      end. /* if can-set(h-widget,"LABEL")        */
   end. /* do while valid-handle(h-widget): */

END FUNCTION. /* setFrameBrowseLabels */

FUNCTION setMenuLabels returns character
      (input p-menu as handle).
/*------------------------------------------------------------------
Purpose:    Public function. Sets translated labels on menu's.
Parameters: Input p-menu - Handle of menu to set labels on.
Notes:
------------------------------------------------------------------*/
   define variable h-sub as handle no-undo.

   /* IF TRANSLATED FRAMES IS TURNED OFF DO NOT */
   /* USE EXTERNALIZED LABELS                   */
   run getLabelControl(buffer lblc_ctrl).
   if not available lblc_ctrl or
      available lblc_ctrl and not lblc_ctrl.lblc_trans_frame
   then
      leave.

   /* START WITH FIRST SUB-MENU */
   p-menu = p-menu:first-child.

   /* EXTERNALIZE ALL SUBMENUS */
   do while valid-handle(p-menu):
      /* SUB-MENU ITEMS */
      h-sub = p-menu:first-child.
      do while valid-handle(h-sub):
         /* DO NOT TRANSLATE USER FUNCTIONS */
         if h-sub:label <> ?
            and (p-menu:name <> "user-bar-ptr" or
            (p-menu:name = "user-bar-ptr" and
            index(h-sub:label,"&") <> 0))
         then
            /* GET TRANSLATED LABELS FOR SUB-MENU ITEMS */
            h-sub:label = getTermLabel(h-sub:label,30).
         h-sub = h-sub:next-sibling.
      end.

      /* GET TRANSLATED LABELS FOR SUB-MENU LABELS */
      if p-menu:label <> ?
      then
         p-menu:label = getTermLabel(p-menu:label,30).

      p-menu = p-menu:next-sibling.
   end.

END FUNCTION. /* setMenuLabels */

PROCEDURE setRadioSetLabels:
/*------------------------------------------------------------------
Purpose:    Private method.
            Sets externalized labels on radio-set widgets.
Parameters: Input p-widget - Widget labels are being set for.
Notes:
------------------------------------------------------------------*/
   define input parameter p-widget as handle no-undo.

   define variable c-newlist   as character no-undo.
   define variable c-label     as character no-undo.
   define variable i           as integer   no-undo.
   define variable i-available as integer   no-undo.

   if can-set(p-widget, "LABEL") and
      p-widget:label <> ?
   then do:
      /* GET AVAILABLE SIZE FOR THE LABEL*/
      if valid-handle(p-widget:side-label-handle)
      then
         run getAvailableSideLabelSize
            (input p-widget:side-label-handle,
             output i-available).
      /* GET LABEL AND ASSIGN TO WIDGET */
      assign
         c-label = getFieldLabel(p-widget:name, i-available)
         p-widget:label = c-label.
   end. /* if can-set(p-widget, "LABEL") */

   c-newlist = p-widget:radio-buttons.

   /* CYCLE THROUGH LABELS AND DETERMINE AVAILABLE LENGTH */
   do i = 1 to num-entries(p-widget:radio-buttons) by 2:
      if length(entry(i,p-widget:radio-buttons),"raw") > i-available
      then
         i-available = length(entry(i,p-widget:radio-buttons),"raw").
   end.

   /* CYCLE THROUGH AND GET EXTERNALIZED LABELS */
   do i = 1 to num-entries(p-widget:radio-buttons) by 2:
      assign
         c-label = getTermLabel(entry(i,p-widget:radio-buttons),i-available)
         entry(i,c-newlist) = c-label.
   end.

   p-widget:radio-buttons = c-newlist.

END PROCEDURE. /* setRadioSetLabels */
