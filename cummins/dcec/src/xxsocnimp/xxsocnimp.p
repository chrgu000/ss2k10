&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases
*/
&Scoped-define WINDOW-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin
/*------------------------------------------------------------------------

  File:

  Description:

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:

  Created:

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{mfdeclre.i}
    {gplabel.i}
{xxsocnimp.i "new"}
{pppiwkpi.i "new"}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME brDet

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES xsc_d

/* Definitions for BROWSE brDet                                         */
&Scoped-define FIELDS-IN-QUERY-brDet xsd_ship xsd_cust xsd_so xsd_line xsd_serial xsd_sched xsd_part xsd_desc2 /* xsd_desc1 */ xsd_qty_used xsd_site xsd_loc xsd_qty_keep xsd_lot xsd_ref xsd_eff xsd_price xsd_amt xsd_newpc xsd_chk
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDet
&Scoped-define SELF-NAME brDet
&Scoped-define QUERY-STRING-brDet FOR EACH xsc_d
&Scoped-define OPEN-QUERY-brDet OPEN QUERY {&SELF-NAME} FOR EACH xsc_d.
&Scoped-define TABLES-IN-QUERY-brDet xsc_d
&Scoped-define FIRST-TABLE-IN-QUERY-brDet xsc_d


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-brDet}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS vFile bChk bExp bLoad brDet
&Scoped-Define DISPLAYED-OBJECTS vFile

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bChk
     LABEL "���"
     SIZE 15 BY 1.32.

DEFINE BUTTON bExp
     LABEL "���"
     SIZE 15 BY 1.32.

DEFINE BUTTON bLoad
     LABEL "װ��"
     SIZE 15 BY 1.32.

DEFINE VARIABLE vFile AS CHARACTER FORMAT "X(256)":U
     LABEL "�ļ���"
     VIEW-AS FILL-IN
     SIZE 26 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDet FOR
      xsc_d SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDet wWin _FREEFORM
  QUERY brDet DISPLAY
      xsd_ship     COLUMN-LABEL "������"
    xsd_cust    COLUMN-LABEL "����"
    xsd_so       COLUMN-LABEL "���۶�����"
    xsd_line     COLUMN-LABEL "���"
    xsd_serial   COLUMN-LABEL "���"
    xsd_sched     COLUMN-LABEL "�ճ̵�"
    xsd_part     COLUMN-LABEL "����"
    xsd_desc2    COLUMN-LABEL "��������"
/*    xsd_desc1    COLUMN-LABEL "Ӣ������" */
    xsd_qty_used COLUMN-LABEL "ʹ������"
    xsd_site     COLUMN-LABEL "�ص�"
    xsd_loc      COLUMN-LABEL "��λ"
    xsd_qty_keep COLUMN-LABEL "ʣ����"
    xsd_lot      COLUMN-LABEL "��������"
    xsd_ref      COLUMN-LABEL "�ο�"
    xsd_eff      COLUMN-LABEL "��Ч����"
    xsd_price    COLUMN-LABEL "����"
    xsd_amt      COLUMN-LABEL "�ϼ�"
    xsd_newpc    COLUMN-LABEL "���±���"
    xsd_chk      COLUMN-LABEL "���"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 97.78 BY 24.32 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     vFile AT ROW 2.27 COL 7 COLON-ALIGNED WIDGET-ID 2
     bChk AT ROW 2 COL 36 WIDGET-ID 4
     bExp AT ROW 2 COL 52.56 WIDGET-ID 6
     bLoad AT ROW 2 COL 68.56 WIDGET-ID 8
     brDet AT ROW 3.68 COL 1.22 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 98.33 BY 27 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "�ͻ����ۿ��ʹ��װ�루xxsocnimp.p��"
         HEIGHT             = 27
         WIDTH              = 98.33
         MAX-HEIGHT         = 44.14
         MAX-WIDTH          = 170.78
         VIRTUAL-HEIGHT     = 44.14
         VIRTUAL-WIDTH      = 170.78
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB brDet bLoad fMain */
ASSIGN
       brDet:COLUMN-RESIZABLE IN FRAME fMain       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDet
/* Query rebuild information for BROWSE brDet
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH xsc_d.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDet */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* �ͻ����ۿ��ʹ��װ�루xxsocnimp.p�� */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* �ͻ����ۿ��ʹ��װ�루xxsocnimp.p�� */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-RESIZED OF wWin /* �ͻ����ۿ��ʹ��װ�루xxsocnimp.p�� */
DO:
   IF wwin:HEIGHT >= 14 THEN DO:
      FRAME fmain:WIDTH = wwin:WIDTH NO-ERROR.
      FRAME fmain:VIRTUAL-WIDTH-CHARS = wwin:WIDTH NO-ERROR.
      FRAME fmain:HEIGHT= wwin:HEIGHT NO-ERROR.
      FRAME fmain:VIRTUAL-HEIGHT-CHARS = wwin:HEIGHT NO-ERROR.
      brdet:WIDTH = wwin:WIDTH - 1 NO-ERROR.
      brdet:HEIGHT = wwin:HEIGHT - 3 NO-ERROR.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bChk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bChk wWin
ON CHOOSE OF bChk IN FRAME fMain /* ��� */
DO:
    DEFINE VARIABLE i AS INTEGER.
    define variable qty_cn like cncix_qty_stock.
    EMPTY TEMP-TABLE xsc_d NO-ERROR.
    EMPTY TEMP-TABLE xsa_r NO-ERROR.
    SESSION:SET-WAIT-STAT("general").
    APPLY "RETURN" TO vFile.

    FIND FIRST xsc_m NO-LOCK NO-ERROR.
    IF AVAILABLE xsc_m THEN DO:
        FOR EACH xsc_m EXCLUSIVE-LOCK BREAK BY xsm_ship by xsm_part:
            assign xsm_stat = "".
            IF FIRST-OF(xsm_part) THEN DO:
              {xxsocnimpcr.i}
            END.
        END.
/*13827 ɾ���и������ŵ�����                                                 */
/*13827 for each xsa_r exclusive-lock:                                       */
/*13827     find first cncix_mstr no-lock where cncix_domain = global_domain */
/*13827            and cncix_so_nbr = xsr_so and cncix_sod_line = xsr_line   */
/*13827            and cncix_lot = xsr_lot and xsr_oh <= 0 no-error.         */
/*13827     if available cncix_mstr then do:                                 */
/*13827        delete xsa_r.                                                 */
/*13827     end.                                                             */
/*13827 end.                                                                 */
        {xxsocnimp01a.i}
    END.

  assign i = 1.
  for each xsc_d exclusive-lock where xsd_chk = "" break by xsd_mid:
      ASSIGN xsd_sn = i.
      i = i + 1.
      /***** �Ƿ��м۸���ж�:������ճ̵�ȡ1.10.1.2��ͨ�ɹ���ȡ1.10.1.1 ****/
     {xxsocnimp01.i}
      IF xsd_eff = ?  THEN DO:
          ASSIGN xsd_eff = TODAY.
      END.
      FIND FIRST pt_mstr NO-LOCK WHERE pt_domain = global_domain AND pt_part = xsd_part NO-ERROR.
      IF AVAILABLE pt_mstr THEN DO:
          ASSIGN xsd_desc1 = pt_desc1
                 xsd_desc2 = pt_desc2.
      END.
      ELSE DO:
          ASSIGN xsd_chk = getmsg(16).
      END.
      ASSIGN xsd_amt = xsd_price * xsd_qty_used.
  END.
  FOR EACH xsc_d EXCLUSIVE-LOCK WHERE xsd_chk = "":
      ASSIGN xsd_chk = "PASS".
  END.
    OPEN QUERY brDet FOR EACH xsc_d by xsd_serial by xsd_so descendin.
    IF CAN-FIND(FIRST xsc_d) THEN DO:
         brdet:REFRESH().
    END.
    SESSION:SET-WAIT-STAT("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bExp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bExp wWin
ON CHOOSE OF bExp IN FRAME fMain /* ��� */
DO:

    DEFINE VARIABLE GFILE AS CHARACTER NO-UNDO.
    DEFINE VARIABLE gfret AS LOGICAL NO-UNDO.

  ASSIGN vfile.
/*  ASSIGN GFILE = vfile.                                   */
/*    SYSTEM-DIALOG GET-FILE gfile                          */
/*        TITLE      "���Ϊ..."                            */
/*        FILTERS    "EXCEL������(*.xls)"   "*.xls"         */
/*        MUST-EXIST                                        */
/*        ASK-OVERWRITE                                     */
/*        INITIAL-DIR "."                                   */
/*        DEFAULT-EXTENSION ".xls"                          */
/*        SAVE-AS                                           */
/*        USE-FILENAME                                      */
/*        UPDATE gfret.                                     */
/*        if gfret then do:                                 */
 /*        {gprun.i ""xxsocnimp02.p"" "(input gfile)"}      */
/*        end.                                              */
       {gprun.i ""xxsocnimp02.p""}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bLoad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bLoad wWin
ON CHOOSE OF bLoad IN FRAME fMain /* װ�� */
DO:
define variable lChoice like mfc_logical.
  IF not CAN-FIND(FIRST xsc_d NO-LOCK WHERE) THEN DO:
     MESSAGE "δ�ҵ���������װ������." VIEW-AS ALERT-BOX INFORMATION.
     UNDO,LEAVE.
  END.
  IF CAN-FIND(FIRST xsc_d NO-LOCK WHERE xsd_chk = "") THEN DO:
     MESSAGE "װ��ǰ���ȼ������." VIEW-AS ALERT-BOX INFORMATION.
     UNDO,LEAVE.
  END.
  if not can-find(first xsc_d no-lock where xsd_chk = "PASS") then do:
     MESSAGE "δ�ҵ���װ�������,���ȼ������." VIEW-AS ALERT-BOX INFORMATION.
     UNDO,LEAVE.
  end.
/* ELSE IF CAN-FIND(FIRST xsc_d NO-LOCK WHERE xsd_chk <> "PASS") THEN DO:   */
/*    MESSAGE "���ݼ�鷢�ִ���.����ȷ�����ݡ�" VIEW-AS ALERT-BOX ERROR.    */
/*    UNDO,LEAVE.                                                           */
/* END.                                                                     */
  if can-find(first xsc_d no-lock where xsd_chk = "pass") and
     can-find(first xsc_d no-lock where xsd_chk <> "pass") then do:
     assign lChoice = no.
     MESSAGE "���ݼ�鷢�ִ���,�Ƿ�װ����ͨ��������"
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO title "ϵͳ��Ϣ"
              UPDATE lChoice.
     if lChoice = no then do:
        undo,leave.
     end.
  end.
  SESSION:SET-WAIT-STAT("GENERAL").
  {gprun.i ""xxsocnimp03.p""}

  OPEN QUERY brDet FOR EACH xsc_d by xsd_serial by xsd_so descendin.
  IF CAN-FIND(FIRST xsc_d) THEN DO:
       brdet:REFRESH().
  END.
  SESSION:SET-WAIT-STAT("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vFile wWin
ON RETURN OF vFile IN FRAME fMain /* �ļ��� */
DO:
  DEFINE VARIABL selet AS LOGICAL .
      ASSIGN vfile.
  IF search(vfile) = ? THEN DO:
       SYSTEM-DIALOG GET-FILE vfile
           TITLE      "��ѡ�����ļ�..."
           FILTERS    "Excel�ļ�(*.xls)" "*.xls"
           MUST-EXIST
       USE-FILENAME
       UPDATE selet.
       display vfile with frame fMain.
       ASSIGN vfile.
   END.
/* IF lower(ENTRY(2,VFILE,".")) <> "xls" AND lower(ENTRY(2,VFILE,".")) <> "xlsx" THEN DO: */
/*         MESSAGE "�ļ�������Excel�ļ�" VIEW-AS ALERT-BOX ERROR. */
/*        LEAVE.                                                  */
/*    END.                                                        */
/*    EMPTY TEMP-TABLE xsc_m NO-ERROR. */
  IF vfile <> "" THEN DO:
     do transaction:
        FIND FIRST usrw_wkfl EXCLUSIVE-LOCK
             WHERE usrw_domain = global_domain
               AND usrw_key1 = execname
               AND usrw_key2 = global_userid NO-ERROR.
        IF NOT AVAILABLE usrw_wkfl THEN DO:
           CREATE Usrw_wkfl. usrw_domain = global_domain.
           ASSIGN Usrw_key1 = execname
                  Usrw_key2 = global_userid.
        END.
        ASSIGN USrw_key3 = vfile.
     end.
     release usrw_wkfl.
  END.

   SESSION:SET-WAIT-STAT("general").
   EMPTY TEMP-TABLE xsc_m NO-ERROR.
   EMPTY TEMP-TABLE xsa_r NO-ERROR.
   EMPTY TEMP-TABLE xsc_d NO-ERROR.
   IF vfile <> "" THEN DO:
      {gprun.i ""xxsocnimp01.p"" "(input vfile)"}
      for each xsc_m exclusive-lock where xsm_newpc = ?:
        assign xsm_newpc = no.
      end.
   end.
       APPLY "CHOOSE" TO bChk.
    OPEN QUERY brDet FOR EACH xsc_d by xsd_serial  by xsd_so descendin.
    IF CAN-FIND(FIRST xsc_d) THEN DO:
         brdet:REFRESH().
    END.
   SESSION:SET-WAIT-STAT("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDet
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME}
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.
session:date-format = 'dmy'.
SESSION:SET-WAIT-STAT("").

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:

DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  FIND FIRST usrw_wkfl NO-LOCK WHERE usrw_domain = global_domain AND usrw_key1 = execname AND usrw_key2 = global_userid NO-ERROR.
     IF AVAILABLE usrw_wkfl THEN DO:
         DISPLAY usrw_key3 @ vFile WITH FRAME fmain.
         ASSIGN vfile.
     END.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

setFrameLabels(frame fmain:handle).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY vFile
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE vFile bChk bExp bLoad brDet
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
