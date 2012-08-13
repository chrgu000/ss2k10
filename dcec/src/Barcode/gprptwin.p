/* gprptwin.p - Report Output to a WINDOW                               */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */


/******************************** Tokens ********************************/
/*V8:ConvertMode=NoConvert                                              */
/************************************************************************/


/******************************** History *******************************/
/* Revision: 8.3     Last Modified: 03/27/95     By: jpm                */
/* Revision: 8.3     Last Modified: 03/28/95     By: aed                */
/* Revision: 8.3     Last Modified: 03/29/95     By: aed                */
/* Revision: 8.3     Last Modified: 06/27/95     By: str    *G0R6*      */
/* Revision: 8.3     Last Modified: 11/03/95     By: str    *G1C4*      */
/* Revision: 8.5     Last Modified: 01/25/96     By: jpm    *J0CF*      */
/* Revision: 8.3     Last Modified: 03/12/96     By: rkc    *G1MR*      */
/* Revision: 8.5     Last Modified: 06/17/97   BY: *J1TB* Cynthia Terry */
/* Revision: 8.5     Last Modified: 09/05/97   By: *J20D* Jean Miller   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* Revision: 8.6E    Last Modified: 07/17/98   By: *H1M6* A. Philips    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb          */
/************************************************************************/

/*J20D*/ /*Removed Run Mode = Windows tag*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE gprptwin_p_1 "Text is too large to paste."
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_2 "Reports(*.rpt)"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_3 "Use a different filename."
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_4 "Report has changes which have not been saved."
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_5 "Text(*.txt)"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_6 "Save changes before closing?"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_7 "Text is too large to cut."
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_8 "Save As"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_9 "Text is too large to copy."
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_10 "Save &As..."
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_11 "Unable to find or open file."
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_12 "Widget type: "
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_13 "Find &Next"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_14 "&Up"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_15 "Cannot paste.  Editor is full."
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_16 "Find &Previous"
/* MaxLen: Comment: */

/*&SCOPED-DEFINE gprptwin_p_17 "&down"*/                                /*H1M6*/
&SCOPED-DEFINE gprptwin_p_17 "&Down"                                    /*H1M6*/
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_18 "Cannot save to this file."
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_19 "Find text not found."
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_20 "&Wrap at End"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_21 "Cancel"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_22 "File is read-only or the path specified is invalid."
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_23 "&Wrap at Beginning/End"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_24 "Close"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_25 "Menu Drop procedure: "
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_26 "&Replace With"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_27 "All Files(*.*)"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_28 "Match &Case"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_29 "&Find What"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_30 "All Files(*)"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_31 "Procedure must be executed from SUB-MENU widget type."
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_33 "OK"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_34 "Open"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_35 "Cu&t"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_36 "E&xit"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_37 "Direction:"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_38 "Direction"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_39 "File"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_40 "Open..."
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_41 "Save"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_42 "Edit"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_43 "Copy"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_44 "Paste"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_45 "Read Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_46 "Search"
/* MaxLen: Comment: */

&SCOPED-DEFINE gprptwin_p_47 "Find..."
/* MaxLen: Comment: */

/*N09X**  -------------- BEGIN - COMMENT ----------------------------
* &SCOPED-DEFINE gprptwin_p_32 " Find "
* /* MaxLen: Comment: */
**N09X**  -------------- END - COMMENT ----------------------------*/

/* ********** End Translatable Strings Definitions ********* */

define shared variable global_user_lang_dir like lng_dir.

/*N09X*/ {gplabel.i} /* EXTERNAL LABEL INCLUDE */

/*G1MR* &GLOBAL-DEFINE  RPT-LEADER      "Report - "  */
/*G1MR* &GLOBAL-DEFINE  RPT-UNTITLED    "Untitled"   */
/*G1MR*/ {gprptdef.i}

&GLOBAL-DEFINE  PW_LABEL            1
&GLOBAL-DEFINE  PW_DATA-TYPE        2
&GLOBAL-DEFINE  PW_INITIAL-VALUE    3

/* Procedure WINDOW Attributes (Persistent Data).  Used for preserving
   values of some dialog boxes after dialog box is closed.

       Format:  PW_Attribute        "label,DATA-TYPE,initial-VALUE"

   The values of each are located using the ENTRY function, such as
   the ENTRY( {&PW_INITIAL-VALUE} , {&PW_FIND_TEXT} ) returns the
   initial value of a Procedure WINDOW's Find Text field.

   The label value is used for programming references only and is not
   used in a displayed manner.
*/

/* These two PW Attributes are stored in dynamic fill-ins because they can hold
   multi-line text and this is difficult to manage with the ENTRY function (what
   should the delimiter be?
*/
&GLOBAL-DEFINE  PW_FIND_TEXT          "Find-Text,CHARACTER,"
&GLOBAL-DEFINE  PW_REPLACE_TEXT       "Replace_Text,CHARACTER,"

/*&GLOBAL-DEFINE  PW_FIND_DIRECTION     "Find-Direction,CHARACTER,doWN"*/ /*H1M6*/
&GLOBAL-DEFINE  PW_FIND_DIRECTION     "Find-Direction,CHARACTER,DOWN"     /*H1M6*/
&GLOBAL-DEFINE  PW_FIND_CASE          "Find-Case,LOGICAL,NO"
&GLOBAL-DEFINE  PW_FIND_WRAP          "Find-Wrap,LOGICAL,YES"
&GLOBAL-DEFINE  PW_REPLACE_CASE       "Replace_Case,LOGICAL,NO"
&GLOBAL-DEFINE  PW_REPLACE_WRAP       "Replace_Wrap,LOGICAL,YES"
&GLOBAL-DEFINE  PW_SCHEMA_PREFIX      "Schema_Prefix,INTEGER,1"
/*G1MR*/&GLOBAL-DEFINE  PW_READ_FIRST "Read_First,LOGICAL,YES"

/* _Pos Defines - specify the element position within :PRIVATE-DATA that each PW
   attribute is located. */
&GLOBAL-DEFINE  PW_FIND_DIRECTION_POS   1
&GLOBAL-DEFINE  PW_FIND_CASE_POS        2
&GLOBAL-DEFINE  PW_FIND_WRAP_POS        3
&GLOBAL-DEFINE  PW_REPLACE_CASE_POS     4
&GLOBAL-DEFINE  PW_REPLACE_WRAP_POS     5
&GLOBAL-DEFINE  PW_SCHEMA_PREFIX_POS    6
/*G1MR*/&GLOBAL-DEFINE  PW_READ_FIRST_POS    7


/*G1MR* &GLOBAL-DEFINE  PW_NUM-ATTRS    6  */
/*G1MR*/&GLOBAL-DEFINE  PW_NUM-ATTRS    7

define variable e as character view-as EDITOR
                  INNER-CHARS 70
                  INNER-LINES 15
                  SCROLLBAR-VERTICAL
                  SCROLLBAR-HORIZONTAL
                  LARGE.

DEFINE FRAME rpt-frame
 e  /* editor widget */
WITH NO-label no-box THREE-D.

define variable h-menu      as widget no-undo.  /*... Menu-bar             */
define variable h-submenu   as widget no-undo.  /*... Sub-Menu             */
define variable h           as widget no-undo.  /*... generic handle       */
define variable h-read-only as widget no-undo.  /* handle to Read-only item  */
define variable h-edit-menu as widget no-undo.  /* handle to Edit-menu  */

define variable i-find-criteria as integer no-undo.
define variable i-find-command  as integer no-undo.

define variable c-find-text as character label {&gprptwin_p_29}
  format "x(128)" view-as fill-in size 40 by 1 {&STDPH_FILL} no-undo.
define variable c-replace-text as character label {&gprptwin_p_26}
  format "x(128)" view-as fill-in size 40 by 1 {&STDPH_FILL} no-undo.

define variable c-find-direction as character label {&gprptwin_p_38} initial "DOWN"
  view-as RADIO-SET HORIZONTAL
          RADIO-BUTTONS {&gprptwin_p_14},   "UP",
/*                        {&gprptwin_p_17}, "doWN" .*/      /*H1M6*/
                        {&gprptwin_p_17}, "DOWN" .          /*H1M6*/

define variable l-status-ok     as logical no-undo.
define variable l-wrap-find     as logical no-undo.
define variable l-text-found    as logical no-undo.
define variable l-find-executed as logical no-undo.

/* Find and Find/Replace Filter Types. */
define variable i-case-sensitive as integer initial 1 no-undo.
define variable i-wrap-around    as integer initial 2 no-undo.

define variable l-find-filters as logical extent 2
  initial ["false","true"]
  label  {&gprptwin_p_28}:L20,
         {&gprptwin_p_23}:L20
  view-as TOGGLE-BOX no-undo.

define variable l-replace-filters as logical extent 2
  initial ["false","true"]
  label {&gprptwin_p_28}:L20,
        {&gprptwin_p_20}:L20
  view-as TOGGLE-BOX no-undo.

define button Btn-Find-OK label {&gprptwin_p_33}
    size 10 by 1.2 AUTO-GO.

define button Btn-Find-Cancel label {&gprptwin_p_21}
    size 10 by 1.2 AUTO-ENDKEY.


/*---------------- Find Text Dialog Box ----------------*/
FORM
    skip( .5 )
      c-find-text &if "{&WINDOW-SYSTEM}" <> "OSF/Motif"
                &then AT 2 &else COLON 13 &ENDif
      SPACE (1)
      skip( .5 )
      l-find-filters[ 1 /* Match Case */ ] at 2
      skip( .5 )
      l-find-filters[2 /* Wrap_Around */ ] at 2
      {&gprptwin_p_37} view-as TEXT
          AT ROW-OF l-find-filters[1] + .25
             COL-OF l-find-filters[1] + 35
      skip( .25 )
      c-find-direction NO-label AT ROW-OF l-find-filters[ 2 ]
                                 COL-OF l-find-filters[ 2 ] + 35
      skip( 1 )
      Btn-Find-OK at 5
      Btn-Find-Cancel at 35
      skip(.5)
    with frame FindText
/*N09X** view-as DIALOG-BOX TITLE {&gprptwin_p_32} side-labels  */
/*N09X*/ view-as DIALOG-BOX TITLE getFrameTitle("Find",10) side-labels
                 DEFAULT-BUTTON Btn-Find-OK
                 CANCEL-BUTTON  Btn-Find-Cancel THREE-D.

/* MAIN */
do on STOP undo, LEAVE:

/* Create a MENU-BAR */
CREATE MENU h-menu assign
  POPUP-ONLY = no.

/* Create a File sub-menu... */
CREATE SUB-MENU h-submenu assign
/*  label  = "&File"*/                                      /*H1M6*/
  label  = "&" + {&gprptwin_P_39}                           /*H1M6*/
  PARENT = h-menu.
/*... add menu-items.  ..*/

CREATE MENU-ITEM h assign
/*  label  = "&Open..."*/                                   /*H1M6*/
  label  = "&" + {&gprptwin_P_40}                           /*H1M6*/
  ACCELERATOR = "Ctrl-O"
  PARENT = h-submenu
  TRIGGERS:
    ON CHOOSE PERSISTENT run p-handle-file
                           (INPUT "OPEN").
  END TRIGGERS.

CREATE MENU-ITEM h assign
/*  label  = "&Close"*/                                     /*H1M6*/
  label  = "&":U + {&gprptwin_p_24}                         /*H1M6*/
  PARENT = h-submenu
  TRIGGERS:
    ON CHOOSE PERSISTENT run p-handle-file
                           (INPUT "CLOSE").
  END TRIGGERS.

CREATE MENU-ITEM h assign
/*  label  = "&Save"*/                                      /*H1M6*/
  label  =   "&" + {&gprptwin_P_41}                         /*H1M6*/
  PARENT = h-submenu
  TRIGGERS:
    ON CHOOSE PERSISTENT run p-handle-file
                           (INPUT "SAVE").
  END TRIGGERS.

CREATE MENU-ITEM h assign
  label  = {&gprptwin_p_10}
  PARENT = h-submenu
  TRIGGERS:
    ON CHOOSE PERSISTENT run p-handle-file
                           (INPUT "SAVE-AS").
  END TRIGGERS.

CREATE MENU-ITEM h assign
  SUBTYPE  = "RULE"
  PARENT   = h-submenu.

CREATE MENU-ITEM h assign
  label  = {&gprptwin_p_36}
  PARENT = h-submenu
  TRIGGERS:
    ON CHOOSE PERSISTENT run p-handle-file
                           (INPUT "CLOSE").
  END TRIGGERS.

/* Create an Edit sub-menu... */
CREATE SUB-MENU h-submenu assign
/*  label  = "&Edit"*/                                      /*H1M6*/
  label  = "&" + {&gprptwin_P_42}                           /*H1M6*/
  PARENT = h-menu
/*J1TB**&if "{&WINDOW-SYSTEM}" = "MS-WINDOWS" &then */
/*J1TB*/
&IF "{&WINDOW-SYSTEM}" <> "TTY":U &THEN
  TRIGGERS:
    ON MENU-DROP PERSISTENT run p-handle-edit-menu-drop.
  END TRIGGERS
&ENDif
  .
h-edit-menu = h-submenu. /* save it */

/*... add menu-items.  ..*/
CREATE MENU-ITEM h assign
  label       = {&gprptwin_p_35}
  ACCELERATOR = "Ctrl-X"
  PARENT      = h-submenu
  TRIGGERS:
    ON CHOOSE PERSISTENT run p-handle-edit
                           (INPUT "CUT").
  END TRIGGERS
  .
CREATE MENU-ITEM h assign
/*  label       = "&Copy"*/                                 /*H1M6*/
  label       = "&" + {&gprptwin_P_43}                      /*H1M6*/
  ACCELERATOR = "Ctrl-C"
  PARENT      = h-submenu
  TRIGGERS:
    ON CHOOSE PERSISTENT run p-handle-edit
                           (INPUT "COPY").
  END TRIGGERS.
CREATE MENU-ITEM h assign
/*  label       = "&Paste"*/                                /*H1M6*/
  label       = "&" + {&gprptwin_P_44}                      /*H1M6*/
  ACCELERATOR = "Ctrl-V"
  PARENT      = h-submenu
  TRIGGERS:
    ON CHOOSE PERSISTENT run p-handle-edit
                           (INPUT "PASTE").
  END TRIGGERS
  .
CREATE MENU-ITEM h assign
  SUBTYPE  = "RULE"
  PARENT   = h-submenu.

CREATE MENU-ITEM h assign
/*  label  = "&Read-Only"*/                                 /*H1M6*/
  label  = "&" + {&gprptwin_P_45}                           /*H1M6*/
  PARENT = h-submenu
  TOGGLE-BOX = true
  CHECKED = true.

h-read-only = h.    /* save copy of handle */

ON ANY-PRINTABLE OF E do:
    if h-read-only:CHECKED then do:
        BELL.
        RETURN NO-APPLY.
    END.
END.

ON BACKSPACE, RETURN OF E do:
    if h-read-only:CHECKED then do:
        BELL.
        RETURN NO-APPLY.
    END.
END.

ON DELETE, TAB OF E do:
    if h-read-only:CHECKED then do:
        BELL.
        RETURN NO-APPLY.
    END.
END.

ON CTRL-V, CTRL-X OF E do:
    if h-read-only:CHECKED then do:
        BELL.
        RETURN NO-APPLY.
    END.
END.

ON WINDOW-CLOSE OF CURRENT-WINDOW do:
/* does nothing, except to override the "close" trigger in gpwinrun */
END.

/* Create an Search sub-menu... */
CREATE SUB-MENU h-submenu assign
/*  label  = "&Search"*/                                    /*H1M6*/
  label  = "&" + {&gprptwin_P_46}                           /*H1M6*/
  PARENT = h-menu.
/*... add menu-items.  ..*/

CREATE MENU-ITEM h assign
/*  label       = "&Find..."*/                              /*H1M6*/
  label       = "&" + {&gprptwin_P_47}                      /*H1M6*/
  ACCELERATOR = "Ctrl-F"
  PARENT      = h-submenu
  TRIGGERS:
    ON CHOOSE PERSISTENT run p-handle-search
                           (INPUT "FIND").
  END TRIGGERS.

CREATE MENU-ITEM h assign
  label       = {&gprptwin_p_13}
  ACCELERATOR = "F3"
  PARENT      = h-submenu
  TRIGGERS:
    ON CHOOSE PERSISTENT run p-handle-search
                           (INPUT "FIND-NEXT").
  END TRIGGERS.

CREATE MENU-ITEM h assign
  label       = {&gprptwin_p_16}
  ACCELERATOR = "Shift-F3"
  PARENT      = h-submenu
  TRIGGERS:
    ON CHOOSE PERSISTENT run p-handle-search
                           (INPUT "FIND-PREV").
  END TRIGGERS.

    assign
        CURRENT-WINDOW:HEIGHT           = 23.29
        CURRENT-WINDOW:WIDTH            = 100
        CURRENT-WINDOW:MAX-HEIGHT       = 23.29
        CURRENT-WINDOW:MAX-WIDTH        = 100
        CURRENT-WINDOW:VIRTUAL-HEIGHT   = 24
        CURRENT-WINDOW:RESIZE           = yes
        CURRENT-WINDOW:SCROLL-BARS      = no
        CURRENT-WINDOW:STATUS-AREA      = yes
        CURRENT-WINDOW:BGCOLOR          = ?
        CURRENT-WINDOW:FGCOLOR          = ?
        CURRENT-WINDOW:MESSAGE-AREA     = no
        CURRENT-WINDOW:SENSITIVE        = yes.
    .
    assign
        frame rpt-frame:width-pixels = CURRENT-WINDOW:width-pixels
/*                                     - frame rpt-frame:border-left-pixels
                                     - frame rpt-frame:border-right-pixels */
        frame rpt-frame:height-pixels = CURRENT-WINDOW:height-pixels
                                     - frame rpt-frame:border-top-pixels
                                     - frame rpt-frame:border-bottom-pixels
        frame rpt-frame:font = 2
        frame rpt-frame:scrollable = no
    .
    assign
        e:font IN FRAME rpt-frame = 2
        e:width-pixels in frame rpt-frame = frame rpt-frame:width-pixels - 1
        e:word-wrap in frame rpt-frame = false
        e:height-pixels in frame rpt-frame = frame rpt-frame:height-pixels - 11
        e:NAME                    = {&RPT-UNTITLED}
/*G1MR*   CURRENT-WINDOW:TITLE      = {&RPT-LEADER} + e:NAME  */
/*        e:READ-ONLY IN FRAME rpt-frame = yes */
    .

  run p-create-frame-attr
    (INPUT frame rpt-frame:HANDLE,
     INPUT {&PW_FIND_TEXT}).

  run p-init-attr
    (INPUT e:HANDLE in frame rpt-frame).

  run enable_UI.

  WAIT-FOR "WINDOW-CLOSE" OF CURRENT-WINDOW.

  run disable_UI.

END. /* MAIN */


/* **********************  Internal Procedures  *********************** */

PROCEDURE enable_UI :
/* -----------------------------------------------------------
  Purpose:     Enable the User Interface
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/

  CURRENT-WINDOW:MENU-BAR = h-menu.

  enable e with frame rpt-frame.

  run p-read-file
    (INPUT e:Handle in frame rpt-frame  ,
     INPUT  "report.rpt"   ,
     OUTPUT l-status-ok).

  {gprun.i ""gpcursor.p"" "('')"}

END PROCEDURE.


PROCEDURE disable_UI :
/* -----------------------------------------------------------
  Purpose:     Disable the User Interface
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/

  return "".

END PROCEDURE.

PROCEDURE p-handle-file:
/* -----------------------------------------------------------
  Purpose:     Execute File Menu commands
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define input parameter p-action as character no-undo.

  repeat on STOP undo, retry:
    if retry then leave.

    CASE p-action:
      when "OPEN"     then run p-file-open.
      when "CLOSE"    then run p-file-close.
      when "SAVE"     then run p-file-save.
      when "SAVE-AS"  then run p-file-save-as.
    END CASE.

    leave.

  end. /* REPEAT */

END PROCEDURE.

PROCEDURE p-file-open:
/* -----------------------------------------------------------
  Purpose:     Open a new file
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define variable h-rpt-window as widget-handle no-undo.
define variable h-pw-editor  as widget-handle no-undo.
define variable l-dlg-answer as logical       no-undo.
define variable l-ok-close   as logical       no-undo.
define variable l-read-ok    as logical       no-undo.
define variable c-file-name  as character     no-undo.

  /* Get widget handles of Procedure WINDOW and its editor widget. */
  run p-get-window-handle
    (INPUT SELF ,
     OUTPUT h-rpt-window ).

  run p-get-editor-handle
    (INPUT h-rpt-window ,
     OUTPUT h-pw-editor ).

  run p-file-close-low-level
    (INPUT h-rpt-window,
     INPUT h-pw-editor ,
     INPUT {&gprptwin_p_34},
     OUTPUT l-ok-close ).

  if l-ok-close <> true then RETURN.

  run p-get-file
    (INPUT h-rpt-window ,
     INPUT {&gprptwin_p_34} ,
     INPUT {&gprptwin_p_34} ,
     INPUT "OPEN" ,
     INPUT-OUTPUT c-file-name ,
     OUTPUT l-dlg-answer).

  if l-dlg-answer = NO then RETURN.

  /* Try to read specified file into editor widget. if successful,
     h-pw-editor:NAME and h-rpt-window:TITLE are updated to reflect file
     name read.
  */

  run p-read-file
    (INPUT  h-pw-editor   ,
     INPUT  c-file-name   ,
     OUTPUT l-read-ok      ).

  if l-read-ok = false then RETURN.

  apply "ENTRY":U to h-pw-editor.


END PROCEDURE.

PROCEDURE p-file-close:
/* -----------------------------------------------------------
  Purpose:     Close a file
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define variable h-rpt-window as widget-handle no-undo.
define variable h-pw-editor  as widget-handle no-undo.
define variable l-ok-close   as logical       no-undo.

  /* Get widget handles of Procedure WINDOW and its editor widget. */
  run p-get-window-handle
    (INPUT SELF ,
     OUTPUT h-rpt-window ).

  run p-get-editor-handle
    (INPUT h-rpt-window ,
     OUTPUT h-pw-editor ).

  run p-file-close-low-level
    (INPUT h-rpt-window,
     INPUT h-pw-editor ,
     INPUT {&gprptwin_p_24},
     OUTPUT l-ok-close ).

  if l-ok-close <> true then return ERROR.

  run p-delete-WINDOW
    (INPUT h-rpt-window ).

END PROCEDURE.

PROCEDURE p-file-close-low-level:
/* -----------------------------------------------------------
  Purpose:     Close a file
  Parameters:  <none>
  Notes:       p-ok-close = true means its ok to continue
               operation.
               = false or ? means its not.
-------------------------------------------------------------*/
define input  parameter  p-window   as widget-handle no-undo.
define input  parameter  p-editor   as widget-handle no-undo.
define input  parameter  p-action   as character     no-undo.
define output parameter  p-ok-close as logical       no-undo.

define variable c-file-name   as character no-undo.
define variable l-ok          as logical   no-undo.

  repeat on stop undo, retry:
    if retry then do:
      assign p-ok-close = ?.    /* Cancel */
      RETURN.
    end.

    /* Bring PW to top. */
    assign l-ok = p-window:MOVE-TO-TOP().

    /* Ask user to Save Changes: Yes-No-Cancel. Returns NO if unsaved
      changes or if user answered NO. */
    run p-file-CHANGED
      (INPUT p-editor ,
       INPUT p-action ,
       OUTPUT p-ok-close ).

    if p-ok-close = ? then RETURN.  /* Cancel */

    if p-ok-close = no then do:     /* NO - don't Save. */
      assign p-ok-close = true.     /* Means ok to contine and close file. */
      RETURN.
    end.

    if p-ok-close = YES then do: /* Yes->Save. */
      /* if Untitled, open Save As dialog box. */
      if p-editor:NAME begins {&RPT-UNTITLED} then do:
        run p-get-file
          (INPUT p-window ,
           INPUT {&gprptwin_p_8} ,
           INPUT {&gprptwin_p_8} ,
           INPUT "SAVE",
           INPUT-OUTPUT c-file-name ,
           OUTPUT p-ok-close ).

        if p-ok-close = no then STOP.     /* Cancel */
        assign p-editor:NAME = c-file-name.
      end.

      /* Actual save to disk failed so return without completing
        File command. That failure will report Close OK as false.
      */
      run p-file-save-low-level
        (INPUT p-editor ,
         INPUT p-editor:NAME ,
         OUTPUT p-ok-close ).

    end.

    leave.

  end.

END PROCEDURE.

PROCEDURE p-file-save:
/* -----------------------------------------------------------
  Purpose:     Save a file
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define variable h-rpt-window as widget-handle no-undo.
define variable h-pw-editor  as widget-handle no-undo.

define variable c-file-name  as character no-undo.
define variable l-save-ok    as logical   no-undo.
define variable l-dlg-answer as logical   no-undo.

  /* Get widget handles of Procedure WINDOW and its editor widget. */
  run p-get-window-handle
    (INPUT SELF ,
     OUTPUT h-rpt-window ).
  run p-get-editor-handle
    (INPUT h-rpt-window ,
     OUTPUT h-pw-editor ).

  /* if Untitled, open Save As dialog box. */
  if h-pw-editor:NAME begins {&RPT-UNTITLED} then do:
    run p-file-save-as.
    RETURN.
  end.

  run p-file-save-low-level
    (INPUT h-pw-editor ,
     INPUT h-pw-editor:NAME ,
     OUTPUT l-save-ok ).

  assign h-rpt-window:TITLE = {&RPT-LEADER} + h-pw-editor:NAME.

END PROCEDURE.

PROCEDURE p-file-save-low-level:
/* -----------------------------------------------------------
  Purpose:     Save a file
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define input  parameter p-editor        as widget-handle no-undo.
define input  parameter p-file-selected as character     no-undo.
define output parameter p-saved-file    as logical       no-undo.

define variable h-rpt-window as widget-handle no-undo.

  /* Get widget handles of Procedure WINDOW. */
  run p-get-window-handle
    (INPUT p-editor ,
     OUTPUT h-rpt-window ).

  assign p-saved-file = p-editor:SAVE-FILE( p-file-selected ) no-error .

  if ( p-saved-file = false ) then do:
    message p-file-selected skip
      {&gprptwin_p_18}  skip(1)
/*G0R6* "File is read-only or the path specified" skip */
/*G0R6* "is invalid. Use a different filename."        */
/*G0R6*/{&gprptwin_p_22} skip
/*G0R6*/{&gprptwin_p_3}
        view-as ALERT-BOX WARNING BUTTONS OK IN WINDOW h-rpt-window.
  end.
  else do:
    /* assign new file name to editor widget. */
    assign p-editor:NAME = p-file-selected.
  end.

END PROCEDURE.

PROCEDURE p-file-save-as:
/* -----------------------------------------------------------
  Purpose:     Save a file with a different name
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define variable h-rpt-window as widget-handle no-undo.
define variable h-pw-editor  as widget-handle no-undo.
define variable c-file-name  as character no-undo.
define variable l-save-ok    as logical   no-undo.
define variable l-dlg-answer as logical   no-undo.

    /* Get widget handles of Procedure WINDOW and its editor widget. */
  run p-get-window-handle
    (INPUT SELF ,
     OUTPUT h-rpt-window ).
  run p-get-editor-handle
    (INPUT h-rpt-window ,
     OUTPUT h-pw-editor ).

  assign c-file-name = if h-pw-editor:NAME BEGINS {&RPT-UNTITLED}
                     then ""
                     else h-pw-editor:NAME .
           .
  run p-get-file
    (INPUT h-rpt-window ,
     INPUT {&gprptwin_p_8} ,
     INPUT {&gprptwin_p_8} ,
     INPUT "SAVE",
     INPUT-OUTPUT c-file-name ,
     OUTPUT l-dlg-answer ).

  if l-dlg-answer = YES then do:
    /* if l-save-ok is true, the ed:SAVE-FILE was successful and the
       ed:NAME field has the saved file name.
    */

    run p-file-save-low-level
      (INPUT h-pw-editor ,
       INPUT c-file-name ,
       OUTPUT l-save-ok ).

    if l-save-ok then
      assign h-rpt-window:TITLE = {&RPT-LEADER} + h-pw-editor:NAME.
  end.

END PROCEDURE.

PROCEDURE p-handle-edit-menu-drop:
/* -----------------------------------------------------------
  Purpose:     Save a file with a different name
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define variable h-rpt-window   as widget    no-undo.
define variable h-pw-editor    as widget    no-undo.
define variable h-menu-item    as widget    no-undo.

  /*J1TB* &IF "{&WINDOW-SYSTEM}" = "MS-WINDOWS":U &THEN****/
  /*J1TB*/
  &IF "{&WINDOW-SYSTEM}" <> "TTY":U &THEN
  do on STOP undo, leave:

    /* Get widget handles of Procedure Window and its editor widget. */
    run p-get-window-handle
      (INPUT SELF ,
       OUTPUT h-rpt-window ).

    run p-get-editor-handle
      (INPUT h-rpt-window ,
       OUTPUT h-pw-editor ).

    if SELF:TYPE <> "SUB-MENU":U then do:
        MESSAGE
/*G1C4*            "Menu Drop procedure" PROGRAM-NAME(1) "executed from" skip */
/*G1C4*     "widget of type" SELF:TYPE "- must be SUB-MENU type."      */
/*G1C4*/    {&gprptwin_p_25} PROGRAM-NAME(1) {&gprptwin_p_12} SELF:TYPE
/*G1C4*/    skip {&gprptwin_p_31}
            view-as ALERT-BOX ERROR.
        RETURN.
    end.

    assign h-menu-item           = h-edit-menu:FIRST-CHILD          /* Cut   */
           h-menu-item:SENSITIVE = /* true if... */
/*              ( NOT h-pw-editor:READ-ONLY ) AND ( h-pw-editor:TEXT-SELECTED ) */
                ( NOT h-read-only:CHECKED ) AND ( h-pw-editor:TEXT-SELECTED )
           h-menu-item           = h-menu-item:NEXT-SIBLING  /* Copy  */
           h-menu-item:SENSITIVE = /* true if... */
                ( h-pw-editor:TEXT-SELECTED )
           h-menu-item           = h-menu-item:NEXT-SIBLING  /* Paste */
           h-menu-item:SENSITIVE = /* true if... */
/*              ( CLIPBOARD:NUM-FORMATS > 0 ) AND ( NOT h-pw-editor:READ-ONLY ) */
                ( CLIPBOARD:NUM-FORMATS > 0 ) AND ( NOT h-read-only:CHECKED )
    .

  end.

  &ENDIF

END PROCEDURE.

PROCEDURE p-handle-edit:
/* -----------------------------------------------------------
  Purpose:     Execute Procedure WINDOW Edit menu commands and
               handle various other events, like TAB, BACK-TAB,
               and END-ERROR when they occur in the editor widget.
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define input parameter p-action as character no-undo.

define variable h-rpt-window  as widget-handle no-undo.
define variable h-pw-editor   as widget-handle no-undo.

  repeat on STOP undo, retry:
    if RETRY then leave.

    /* Get widget handles of Procedure WINDOW and its editor widget. */
    run p-get-window-handle
      (INPUT SELF ,
       OUTPUT h-rpt-window ).

    run p-get-editor-handle
      (INPUT h-rpt-window ,
       OUTPUT h-pw-editor ).

    CASE p-action:
      when "CUT"       then run p-edit-cut
                             (INPUT h-pw-editor).
      when "COPY"      then run p-edit-copy
                             (INPUT h-pw-editor).
      when "PASTE"     then run p-edit-paste
                             (INPUT h-pw-editor).
      when "READ-ONLY" then run p-edit-read-only
                             (INPUT h-pw-editor).
    END CASE.

    LEAVE.

  end.

END PROCEDURE.

PROCEDURE p-edit-cut:
/* -----------------------------------------------------------
  Purpose:     Copies the contents of the current selection to
               the OS's Native Clipboard, overwriting the
               clipboards previous contents, and then deletes
               the current selection and its contents.
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define input parameter p-buffer as widget-handle no-undo .

define variable l-status-error   as logical       no-undo.
define variable hv-window        as widget-handle no-undo.
define variable l-clip-multiple  as logical       no-undo initial false.

  do on STOP undo, leave on ERROR undo, leave:
    if h-read-only:CHECKED then
        LEAVE.
    if p-buffer:TYPE <> "EDITOR":U then
        LEAVE.
    assign
        l-clip-multiple     = CLIPBOARD:MULTIPLE
        CLIPBOARD:MULTIPLE = false
    .

    if ( p-buffer:TEXT-SELECTED = true ) then do: /* Text is selected. */
      /* Can Progress ditem handle the text to be cut? */
      assign CLIPBOARD:VALUE = p-buffer:SELECTION-TEXT NO-ERROR.

      if ( ERROR-STATUS:NUM-MESSAGES > 0 ) then do:
        assign
          hv-window = p-buffer:FRAME
          hv-window = hv-window:PARENT   /* WINDOW */
        .

        message {&gprptwin_p_7} skip(1)
          ERROR-STATUS:GET-MESSAGE(1)
          view-as ALERT-BOX ERROR BUTTONS OK IN WINDOW hv-window.
      end.
      else do:
        assign l-status-error = p-buffer:REPLACE-SELECTION-TEXT("").
      end.
    end.

  end.

  /* Restore clipboard multiple value. */
  assign  CLIPBOARD:MULTIPLE = l-clip-multiple.

  /* Put focus back in editor widget. */
  apply "ENTRY":U to p-buffer.

END PROCEDURE.


PROCEDURE p-edit-copy:
/* -----------------------------------------------------------
  Purpose:     Copies the contents of the current selection to
               the OS's Native Clipboard, overwriting the
               clipboards previous contents.
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define input parameter p-buffer as widget-handle no-undo .

define variable hv-window        as widget-handle no-undo.
define variable l-clip-multiple  as logical       no-undo initial false.

  do on STOP undo, leave on ERROR undo, leave:
    if p-buffer:TYPE <> "EDITOR":U then
      LEAVE.
    assign
      l-clip-multiple     = CLIPBOARD:MULTIPLE
      CLIPBOARD:MULTIPLE = false
    .

    if p-buffer:TEXT-SELECTED then do: /* Text is selected. */
      assign CLIPBOARD:VALUE = p-buffer:SELECTION-TEXT NO-ERROR.
      if ( ERROR-STATUS:NUM-MESSAGES > 0 ) then do:
        assign
          hv-window = p-buffer:FRAME
          hv-window = hv-window:PARENT   /* WINDOW */
        .
        message {&gprptwin_p_9} skip(1)
          ERROR-STATUS:GET-MESSAGE(1)
          view-as ALERT-BOX ERROR BUTTONS OK IN WINDOW hv-window.
      end.

    end.
  end.

  /* Restore clipboard multiple value. */
  assign  CLIPBOARD:MULTIPLE = l-clip-multiple.

  /* Put focus back in editor widget. */
  apply "ENTRY":U to p-buffer.

END PROCEDURE.


PROCEDURE p-edit-paste:
/* -----------------------------------------------------------
  Purpose:     Inserts the contents of the OS's clipboard at
               the current position (insert point).  does not
               change the clipboard's contents
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define input parameter p-buffer as widget-handle no-undo .

define variable l-status-error   as logical   no-undo.
define variable c-paste-text     as character no-undo.
define variable hv-window        as widget    no-undo.
define variable l-clip-multiple  as logical   no-undo initial false.

  do on STOP undo, leave on error undo, leave :
    if h-read-only:CHECKED then
      LEAVE.
    if p-buffer:TYPE <> "EDITOR":U then
      LEAVE.
    assign
      l-clip-multiple     = CLIPBOARD:MULTIPLE
      CLIPBOARD:MULTIPLE = false
    .

    if CLIPBOARD:NUM-FORMATS > 0 then do: /* Clipboard not empty. */
      assign
        hv-window = p-buffer:FRAME
        hv-window = hv-window:PARENT   /* WINDOW */
      .

      /* Can Progress ditem handle the text to be pasted? */
      assign c-paste-text = CLIPBOARD:VALUE NO-ERROR.
      if ( ERROR-STATUS:NUM-MESSAGES > 0 ) then do:

        message {&gprptwin_p_1} skip(1)
        ERROR-STATUS:GET-MESSAGE(1)

        view-as ALERT-BOX ERROR BUTTONS OK IN WINDOW hv-window.
      end.
      else do:

         /* if something selected, replace it with clipboard value. */
        if p-buffer:TEXT-SELECTED then
             assign l-status-error =
                    p-buffer:REPLACE-SELECTION-TEXT( CLIPBOARD:VALUE ) .
        else /* Insert pasted text at current insert point. */
             assign l-status-error =
                    p-buffer:INSERT-STRING( CLIPBOARD:VALUE ) .
        if ( l-status-error = false ) then
                MESSAGE {&gprptwin_p_15}
                view-as ALERT-BOX ERROR BUTTONS OK IN WINDOW hv-window.
      end.
    end.
  end.

  /* Restore clipboard multiple value. */
  assign  CLIPBOARD:MULTIPLE = l-clip-multiple.

  /* Put focus back in editor widget. */
  apply "ENTRY":U to p-buffer.

END PROCEDURE.

PROCEDURE p-get-window-handle:
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define input  parameter p-widget  as widget-handle no-undo.
define output parameter p-window as widget-handle no-undo.

  assign p-window = ? .

  /* Handle exceptions... */
  if not VALID-HANDLE( p-widget ) or
    (p-widget:TYPE = "PSEUDO-WIDGET":U ) then
       RETURN.

  /* Take care of menus, submenus, and menu items. */
  if CAN-QUERY( p-widget , "WINDOW":U ) then do:
    assign p-window = p-widget:WINDOW .
    RETURN.
  end.

  CASE p-widget:TYPE :
    when "WINDOW":U then assign p-window = p-widget.
    when "FRAME":U  then assign p-window = p-widget:PARENT.
    when "FIELD-GROUP":U then do:
      assign
        p-window = p-widget:PARENT   /* Frame  */
        p-window = p-window:PARENT   /* WINDOW */
      NO-ERROR.

    end.
    otherwise do: /* Field-level */
      assign
        p-window = p-widget:FRAME
        p-window = p-window:PARENT
        NO-ERROR.
    end.
  END CASE.

END PROCEDURE.

PROCEDURE p-get-editor-handle:
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define input parameter  p-window as widget-handle no-undo.
define output parameter p-editor as widget-handle no-undo.

define variable h-widget as widget-handle no-undo.

  assign p-editor = ?.

  /* Find the Procedure WINDOW frame and editor widget. */
  if p-window:TYPE = "WINDOW":U then do:
    assign h-widget = p-window
           h-widget = h-widget:FIRST-CHILD.  /* Editor Frame */
    if VALID-HANDLE( h-widget ) then
      assign
        h-widget  = h-widget:FIRST-CHILD  /*Field group. */
        p-editor = h-widget:FIRST-CHILD  /* The editor. */
      .
  end.

END PROCEDURE.

PROCEDURE p-get-file:
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define input parameter p-window          as widget-handle no-undo.
define input parameter p-action          as character     no-undo.
define input parameter p-title           as character     no-undo.
define input parameter p-mode            as character     no-undo.
define input-output parameter p-filename as character     no-undo.
define output parameter p-ok             as logical       no-undo.

define variable c-filter-namestring as character extent 3     no-undo.
define variable c-filter-filespec   as character extent 3     no-undo.
define variable h-cwin            as widget-handle          no-undo.

  assign
    c-filter-namestring[ 1 ] = {&gprptwin_p_2}
    c-filter-filespec[ 1 ]   = "*.rpt"

    c-filter-namestring[ 2 ] = {&gprptwin_p_5}
    c-filter-filespec[ 2 ]   = "*.txt"

    c-filter-namestring[ 3 ] = if OPSYS = "UNIX":U
                                then {&gprptwin_p_30}
                                else {&gprptwin_p_27}
    c-filter-filespec[ 3 ]   = if OPSYS = "UNIX":U
                                then "*"
                                else "*.*".
  do on STOP undo, leave:

    /* Workaround until SYSTEM-DIALOGs have IN WINDOW option. */
    if VALID-HANDLE( p-window )
      then assign h-cwin         = CURRENT-WINDOW
                  CURRENT-WINDOW = p-window.

    /* File-names to open must exist */
    if p-mode EQ "OPEN"
    then SYSTEM-DIALOG GET-FILE p-filename
      TITLE    p-title
      FILTERS  c-filter-namestring[ 1 ]   c-filter-filespec[ 1 ],
               c-filter-namestring[ 2 ]   c-filter-filespec[ 2 ],
               c-filter-namestring[ 3 ]   c-filter-filespec[ 3 ]
      MUST-EXIST
      UPDATE   p-ok.

    /* File-names to save must be writeable */
    else SYSTEM-DIALOG GET-FILE p-filename
      TITLE   p-title
      FILTERS c-filter-namestring[ 1 ]  c-filter-filespec[ 1 ],
              c-filter-namestring[ 2 ]  c-filter-filespec[ 2 ],
              c-filter-namestring[ 3 ]  c-filter-filespec[ 3 ]
      SAVE-AS
      USE-FILENAME
      ASK-OVERWRITE
      CREATE-TEST-FILE
      UPDATE  p-ok.

  end.

  /* Workaround until SYSTEM-DIALOGs have IN WINDOW option. */
  if VALID-HANDLE( h-cwin )
    then assign CURRENT-WINDOW = h-cwin.

END PROCEDURE.

PROCEDURE p-read-file:
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define input  parameter p-editor    as widget    no-undo.
define input  parameter p-filename  as character no-undo.
define output parameter p-read-ok   as logical   no-undo.

define variable h-rpt-window   as widget    no-undo.
define variable l-dlg-answer   as logical   no-undo.
define variable l-ok-close     as logical   no-undo.
/*G1MR*/define variable c-private-data  as character     no-undo.


  /* Get widget handle of Procedure WINDOW. */
  run p-get-window-handle
    (INPUT p-editor ,
     OUTPUT h-rpt-window ).

  /* Try to read file. */
  assign p-read-ok = p-editor:READ-FILE( p-filename ) NO-ERROR.
  if (p-read-ok = false) OR (ERROR-STATUS:NUM-MESSAGES > 0) then do:
    message p-filename skip
            {&gprptwin_p_11}
             view-as ALERT-BOX ERROR BUTTONS OK
             in WINDOW h-rpt-window.
  end.

  if p-read-ok = false then RETURN.

  /* Update information. */
/*G1MR*  assign
*    p-editor:NAME   = if p-filename = "report.rpt" then {&RPT-UNTITLED}
*                      else p-filename
*    h-rpt-window:TITLE = {&RPT-LEADER} + p-editor:NAME
*  .
*G1MR*/

/*G1MR*/if ENTRY( {&PW_READ_FIRST_POS} , p-editor:PRIVATE-DATA ) = "YES" then
/*G1MR*/ /* use window name passed in for first read*/
/*G1MR*/   assign
/*G1MR*/      p-editor:NAME = {&RPT-Untitled}
/*G1MR*/ /* Bug workaround - ENTRY statement balks at :PRIVATE-DATA. */
/*G1MR*/      c-private-data = p-editor:PRIVATE-DATA
/*G1MR*/      ENTRY( {&PW_READ_FIRST_POS} , c-private-data ) = "NO"
/*G1MR*/      p-editor:PRIVATE-DATA = c-private-data
/*G1MR*/.
/*G1MR*/else assign
/*G1MR*/   p-editor:NAME = p-filename
/*G1MR*/   h-rpt-window:TITLE = {&RPT-Leader} + p-editor:NAME
/*G1MR*/.


END PROCEDURE.

PROCEDURE p-file-changed:
/* -----------------------------------------------------------
  Purpose:     Executes File Changed dialog which asks the user
               to save changes made to a modified file before
               continuing some operation
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define input  parameter p-editor       as widget-handle no-undo.
define input  parameter p-title        as character     no-undo.
define output parameter p-save-changes as logical       no-undo.

define variable h-pw-window    as widget-handle no-undo.
define variable l-buf-modified as logical       no-undo.

  assign p-save-changes = ?.  /* Default to Cancel. */

  if ( p-editor:MODIFIED = no ) or
     ( p-editor:NAME BEGINS {&RPT-UNTITLED} and
       p-editor:EMPTY )
  then
    l-buf-modified = false.
  else
    l-buf-modified = true.

  if ( l-buf-modified = true ) then do:

    /* Get widget handle of Procedure WINDOW. */
    run p-get-window-handle
      (INPUT p-editor ,
       OUTPUT h-pw-window ).

    p-save-changes = yes.

    message p-editor:NAME skip
      {&gprptwin_p_4} skip(1)
      {&gprptwin_p_6}
      view-as ALERT-BOX WARNING BUTTONS YES-NO-CANCEL
           UPDATE p-save-changes
           in WINDOW h-pw-window.
  end.
  else
    p-save-changes = no.  /* No changes, so skip the save. */

END PROCEDURE.

PROCEDURE p-delete-window:
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define input parameter h-rpt-window as widget-handle no-undo.

define variable h-temp as widget no-undo.
define variable h-next as widget no-undo.

  assign h-rpt-window:VISIBLE = false.

  /* Delete contained frames */
  h-next = h-rpt-window:FIRST-CHILD.
  do WHILE h-next <> ?:
    assign h-temp = h-next
           h-next = h-next:NEXT-SIBLING.
    if h-temp:DYNAMIC then
        DELETE WIDGET h-temp.
  end.

  /* Delete menubar. */
  assign h-temp = h-rpt-window:MENUBAR.
  if VALID-HANDLE( h-temp ) then delete WIDGET h-temp.

  /* Delete the WINDOW. */
  apply "WINDOW-CLOSE":U to h-rpt-window.

END PROCEDURE.

PROCEDURE p-init-attr:
/* -----------------------------------------------------------
  Purpose:     initializes the PW Persistent Attributes initial
               values in Editor widget's PRIVATE-DATA.
  Parameters:  <none>
  Notes:       initialize the list to the number of PW attributes
               less one by filling with commas - the delimeter.
-------------------------------------------------------------*/
define input parameter p-editor as widget-handle no-undo.

define variable c-private-data as character no-undo.

  assign p-editor:PRIVATE-DATA = FILL( "," , {&PW_NUM-ATTRS} - 1)
    c-private-data = p-editor:PRIVATE-DATA.

  /* assign PW initial Attribute values to ED:PRIVATE-DATA. */
  assign ENTRY( {&PW_FIND_DIRECTION_POS} , c-private-data  )
              = ENTRY ({&PW_INITIAL-VALUE} , {&PW_FIND_DIRECTION})
         ENTRY( {&PW_FIND_CASE_POS} , c-private-data  )
              = ENTRY ({&PW_INITIAL-VALUE} , {&PW_FIND_CASE})
         ENTRY( {&PW_FIND_WRAP_POS} , c-private-data  )
              = ENTRY ({&PW_INITIAL-VALUE} , {&PW_FIND_WRAP})
         ENTRY( {&PW_REPLACE_CASE_POS} , c-private-data  )
              = ENTRY ({&PW_INITIAL-VALUE} , {&PW_REPLACE_CASE})
         ENTRY( {&PW_REPLACE_WRAP_POS} , c-private-data  )
              = ENTRY ({&PW_INITIAL-VALUE} , {&PW_REPLACE_WRAP})
         ENTRY( {&PW_SCHEMA_PREFIX_POS} , c-private-data  )
              = ENTRY ({&PW_INITIAL-VALUE} , {&PW_SCHEMA_PREFIX})
/*G1MR*/ ENTRY( {&PW_READ_FIRST_POS} , c-private-data  )
/*G1MR*/      = ENTRY ({&PW_INITIAL-VALUE} , {&PW_READ_FIRST})

         p-editor:PRIVATE-DATA = c-private-data
         .

END PROCEDURE.


PROCEDURE p-create-frame-attr:
/* -----------------------------------------------------------
  Purpose:     Creates a FILL-IN field of a specified data-type
               and attaches it to a specified Frame.
  Parameters:  <none>
  Notes:       This procedure extracts the needed information
               from the PW Attribute String p_Attr to create a
               fill-in field for the specified frame.
-------------------------------------------------------------*/
define input parameter p-frame as widget-handle no-undo.
define input parameter p-attr  as character     no-undo.

define variable h-pw-attr        as widget-handle no-undo.
define variable h-pw-label       as widget-handle no-undo.

  create TEXT h-pw-label
  assign FORMAT       = "x(50)"
         SCREEN-VALUE = ENTRY( {&PW_LABEL} , p-attr )
         FRAME        = p-frame
         VISIBLE      = false
  .

  create FILL-IN h-pw-attr
  assign DATA-TYPE          = ENTRY( {&PW_DATA-TYPE} , p-attr )
         PRIVATE-DATA       = ENTRY( {&PW_INITIAL-VALUE} , p-attr )
         SIDE-label-HANDLE  = h-pw-label
         FRAME              = p-frame
         VISIBLE            = false
  .

END PROCEDURE.


PROCEDURE p-get-frame-attr:
/* -----------------------------------------------------------
  Purpose:     Returns the handle of a FILL-IN field specified
               by a Procedure WINDOW Attribute string.
  Parameters:  <none>
  Notes:       This procedure extracts the needed information
               from the PW Attribute String p-attr to find the
               matching fill-in field for the specified frame
               and returns the fill-in's handle.
-------------------------------------------------------------*/
define input  parameter p-frame       as widget-handle no-undo.
define input  parameter p-attr        as character     no-undo.
define output parameter p-attr-handle as widget-handle no-undo.

define variable h-widget as widget-handle no-undo.

  assign h-widget = p-frame:FIRST-CHILD    /* Field-Group.        */
         h-widget = h-widget:FIRST-CHILD    /* First Field widget. */
  .

  do while VALID-HANDLE( h-widget ):
    if h-widget:label = ENTRY( {&PW_LABEL} , p-attr ) then do:
      assign p-attr-handle = h-widget.
      RETURN.
    end.
    else
      assign h-widget = h-widget:NEXT-SIBLING.
  end.

END PROCEDURE.



PROCEDURE p-get-srch-attr:
/* -----------------------------------------------------------
  Purpose:     Gets the persistent PW Search Attributes and
               assigns them to the appropriate common dialog
               field variables
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define input parameter p-editor as widget-handle no-undo.
define input parameter p-action as character     no-undo.

define variable h-find-text      as widget-handle no-undo.
define variable h-repl-text      as widget-handle no-undo.

  /* Get the persistent Find Field values. */
  run p-get-frame-attr
    (INPUT p-editor:FRAME ,
     INPUT {&PW_FIND_TEXT} ,
     OUTPUT h-find-text ).

  assign c-find-text = h-find-text:PRIVATE-DATA .

  if p-action begins "FIND" then do:
    assign c-find-direction                 =
                ENTRY( {&PW_FIND_DIRECTION_POS} , p-editor:PRIVATE-DATA )
           l-find-filters[ i-case-sensitive ] =
              ( ENTRY( {&PW_FIND_CASE_POS} , p-editor:PRIVATE-DATA ) =
                STRING( true , l-find-filters[1]:FORMAT IN FRAME FindText ) )
           l-find-filters[ i-wrap-around ]    =
              ( ENTRY( {&PW_FIND_WRAP_POS} , p-editor:PRIVATE-DATA ) =
                STRING( true , l-find-filters[2]:FORMAT IN FRAME FindText ) )
           .
  end.

END PROCEDURE.


PROCEDURE p-put-srch-attr:
/* -----------------------------------------------------------
  Purpose:     Puts the Search Common Dialogs field variable
               values into the persistent PW Search Attributes
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define input parameter p-editor as widget-handle no-undo.
define input parameter p-action as character     no-undo.

define variable h-find-text      as widget-handle no-undo.
define variable h-repl-text      as widget-handle no-undo.
define variable c-private-data  as character     no-undo.

  /* Put the dialog values back into the PW Attribute Fields. */
  run p-get-frame-attr
    (INPUT p-editor:FRAME ,
     INPUT {&PW_FIND_TEXT} ,
     OUTPUT h-find-text ).

  /* Bug workaround - ENTRY statement balks at :PRIVATE-DATA. */
  assign c-private-data = p-editor:PRIVATE-DATA.

  assign h-find-text:PRIVATE-DATA        = c-find-text
         ENTRY( {&PW_FIND_DIRECTION_POS} , c-private-data )
              = c-find-direction
         ENTRY( {&PW_FIND_CASE_POS} , c-private-data )
              = STRING( l-find-filters[i-case-sensitive] )
         ENTRY( {&PW_FIND_WRAP_POS} , c-private-data )
              = STRING( l-find-filters[ i-wrap-around ]  )
  .

  assign p-editor:PRIVATE-DATA = c-private-data.

END PROCEDURE.

PROCEDURE p-handle-search:
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define input parameter p-action as character no-undo.

define variable h-rpt-window      as widget-handle no-undo.
define variable h-pw-editor       as widget-handle no-undo.
define variable h-cwin          as widget-handle no-undo.

  repeat on STOP undo, retry:

    if RETRY then LEAVE.

    /* Get widget handles of Procedure WINDOW and its editor widget. */
    run p-get-window-handle
      (INPUT SELF ,
       OUTPUT h-rpt-window ).
    run p-get-editor-handle
      (INPUT h-rpt-window ,
       OUTPUT h-pw-editor ).

    /* Save CURRENT-WINDOW handle to restore later. */
    assign
      h-cwin         = CURRENT-WINDOW
      CURRENT-WINDOW = h-rpt-window.

    /* Get the current values of the Search fields. */
    run p-get-srch-attr
      (INPUT h-pw-editor ,
       p-action ).

    CASE p-action:
      when "FIND"
        then run p-find-text
               (INPUT h-pw-editor ).
      when "FIND-NEXT"
        then run p-find-next
               (INPUT h-pw-editor ,
                INPUT FIND-NEXT-OCCURRENCE ).
      when "FIND-PREV"
        then run p-find-prev
               (INPUT h-pw-editor ,
                INPUT FIND-PREV-OCCURRENCE ).
    END CASE.

    /* Put the current values of the Search fields to the PW attribtes. */
    run p-put-srch-attr
      (INPUT h-pw-editor ,
       INPUT p-action ).

    leave.

  end.

  /* Repoint CURRENT-WINDOW. */
  if VALID-HANDLE( h-cwin )
   then assign CURRENT-WINDOW = h-cwin .

END PROCEDURE.

PROCEDURE p-find-text:
/* -----------------------------------------------------------
  Purpose:     Executes the FIND command, which allows user to
               search for specific text strings in the edit buffer.
  Parameters:  <none>
  Notes:       <EDITOR>:SEARCH Invalid Flag combinations are:
               (FIND-NEXT-OCCURRENCE + FIND-PREV-OCCURRENCE)
               or  (FIND-GLOBAL)
-------------------------------------------------------------*/
define input parameter p-buffer as widget-handle no-undo.

define variable hv-window         as widget-handle no-undo.

  on GO of frame FindText
  do:
    hide frame FindText no-pause.

    i-find-command = if c-find-direction:SCREEN-VALUE in frame FindText = "DOWN"
                    then FIND-NEXT-OCCURRENCE
                    else FIND-PREV-OCCURRENCE.
    assign
      c-find-text = input frame FindText c-find-text
      input frame FindText l-find-filters[1 for 2]
      input frame FindText c-find-direction
      l-find-executed = true.

    /* Allow user to search for question mark ( ? ). Needs special handling. */
    run p-make-q-mark
      (INPUT-OUTPUT c-find-text ,
       INPUT p-buffer:LARGE ).
    run p-find-assign
      (OUTPUT i-find-criteria ) .
    run p-find-again
      (INPUT p-buffer ,
       INPUT i-find-command ,
       INPUT i-find-criteria ).
  end.

  on WINDOW-CLOSE of frame FindText
  do:
    apply "END-ERROR":U to frame FindText.
  end.

  &IF ( "{&WINDOW-SYSTEM}" <> "TTY":U ) &THEN
  /* if text is selected (highlighted), use as default c-find-text. GUI Only. */
  if p-buffer:TEXT-SELECTED
      then assign c-find-text = p-buffer:SELECTION-TEXT .
  &ENDIF

  DLG_FIND:
  do on endkey undo DLG_FIND , leave DLG_FIND :
    assign hv-window = p-buffer:FRAME
           hv-window = hv-window:PARENT   /* WINDOW */
    .

    display
      c-find-direction
      l-find-filters[1 for 2]
    with frame FindText in WINDOW hv-window.
    enable all with frame FindText.
    update c-find-text
      with frame FindText.
  end.

  hide frame FindText no-pause.
  apply "ENTRY":U to p-buffer .

END PROCEDURE.


PROCEDURE p-find-assign:
/* -----------------------------------------------------------
  Purpose:     Assigns the Find Text and Find Criteria
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define output parameter p-find-criteria as integer no-undo .

  assign
    p-find-criteria = FIND-SELECT

    p-find-criteria = if l-find-filters[i-case-sensitive]
                        then p-find-criteria + FIND-CASE-SENSITIVE
                        else p-find-criteria

    p-find-criteria = if l-find-filters[i-wrap-around]
                        then p-find-criteria + FIND-WRAP-AROUND
                        else p-find-criteria
  . /* END assign. */

END PROCEDURE.

PROCEDURE p-find-next:
/* -----------------------------------------------------------
  Purpose:     Executes the Find Next command
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define input parameter p-buffer as widget-handle no-undo.
define input parameter p-find-criteria as integer no-undo.

  /* Set basic Find Criteria. */
  run p-find-assign
    (OUTPUT p-find-criteria ) .

  &IF ( "{&WINDOW-SYSTEM}" <> "TTY":U ) &THEN
  /* Supported under GUI only. */
  /* assign Find Text the Currently Selected text, if any. */
  c-find-text = (If p-buffer:TEXT-SELECTED
                   then p-buffer:SELECTION-TEXT
                   else c-find-text ) .
  &ENDIF

  /* Allow user to search for question mark ( ? ). Needs special handling. */
  run p-make-q-mark
    (INPUT-OUTPUT c-find-text , INPUT p-buffer:LARGE ).
  run p-find-again
    (INPUT p-buffer ,
     INPUT FIND-NEXT-OCCURRENCE ,
     INPUT p-find-criteria).

END PROCEDURE.


PROCEDURE p-find-prev:
/* -----------------------------------------------------------
  Purpose:     Executes the Find Previous command
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define input parameter p-buffer as widget-handle no-undo.
define input parameter p-find-criteria as integer no-undo.

  /* Set basic Find Criteria. */
  run p-find-assign
    (OUTPUT p-find-criteria ) .

  &IF ( "{&WINDOW-SYSTEM}" <> "TTY":U ) &THEN
  /* Supported under GUI only. */
  /* assign Find Text the Currently Selected text, if any. */
  c-find-text = (If p-buffer:TEXT-SELECTED
                   then p-buffer:SELECTION-TEXT
                   else c-find-text ) .
  &ENDIF

  /* Allow user to search for question mark ( ? ). Needs special handling. */
  run p-make-q-mark
    (INPUT-OUTPUT c-find-text ,
     INPUT p-buffer:LARGE ).
  run p-find-again
    (INPUT p-buffer ,
     INPUT FIND-PREV-OCCURRENCE ,
     INPUT p-find-criteria).

END PROCEDURE.

PROCEDURE p-find-again:
/* -----------------------------------------------------------
  Purpose:     Re-Executes the previous Find command
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
define input parameter p-buffer              as widget-handle no-undo.
define input parameter p-again-find-command  as integer no-undo.
define input parameter p-again-find-criteria as integer no-undo.

define variable i-again-find-flags as integer no-undo.
define variable hv-window          as widget-handle no-undo.

  assign hv-window = p-buffer:FRAME
         hv-window = hv-window:PARENT   /* WINDOW */
  . /* assign */


  assign i-again-find-flags = p-again-find-command + p-again-find-criteria
         l-wrap-find        = NO
  . /* END assign. */

  Continue_Search:
  do while true:

    l-text-found = p-buffer:SEARCH(c-find-text, i-again-find-flags)  .
    if l-text-found then LEAVE Continue_Search.
    message {&gprptwin_p_19}
      view-as ALERT-BOX INFORMATION BUTTONS OK in WINDOW hv-window.
    leave Continue_Search.

  end.   /* Continue_Search */

END PROCEDURE.


PROCEDURE p-make-q-mark:
/* -----------------------------------------------------------
  Purpose:     Makes the unknown value a question mark and
               allows for proper searching of the literal "?".
  Parameters:  <none>
  Notes:       if string is Unknown Value, convert it to a single
               Question Mark for All platforms, except MSW LARGE
               editor - convert to two qmarks.  This is because
               the MSW LARGE Editor treats ? as a wildcard, whereas
               two are taken to mean the literal ?.

               This allows user to search for instances of a
               question mark in their code.
-------------------------------------------------------------*/
define input-output parameter p-string as character no-undo.
define input        parameter p-large  as logical   no-undo.

  if p-string = ? OR p-string = "?" then
 /*J1TB*   assign p-string = if ( SESSION:WINDOW-SYSTEM = "MS-WINDOWS" AND */
    assign p-string = if ( SESSION:WINDOW-SYSTEM <> "TTY":U AND
                            p-large = true )
                      then "??"
                      else "?".

END PROCEDURE.
