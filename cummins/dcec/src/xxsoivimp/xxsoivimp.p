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
{xxsoivimp.i "new"}

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
&Scoped-define INTERNAL-TABLES tmp-so

/* Definitions for BROWSE brDet                                         */
&Scoped-define FIELDS-IN-QUERY-brDet tso_nbr "订单号" tso_cust "销往" tso_bill "发票地址" tso_ship "货物发往" tso_ord_date "订货日期" tso_rmks "备注" tso_site "地点" "TEMP" "库位" tso_channel "通道" tso_tax_usage "税用途" tsod_line "项次" tsod_part "料号" tsod_site "地点" tsod_qty_ord "数量" "M" "类别" tsod_acct "账户" tsod_sub "分账户" tsod_cc "成本中心" tsod_project "项目" tsod_chk "状态"   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDet   
&Scoped-define SELF-NAME brDet
&Scoped-define QUERY-STRING-brDet FOR EACH tmp-so
&Scoped-define OPEN-QUERY-brDet OPEN QUERY {&SELF-NAME} FOR EACH tmp-so.
&Scoped-define TABLES-IN-QUERY-brDet tmp-so
&Scoped-define FIRST-TABLE-IN-QUERY-brDet tmp-so


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
     LABEL "检查" 
     SIZE 15 BY 1.31.

DEFINE BUTTON bExp 
     LABEL "输出" 
     SIZE 15 BY 1.31.

DEFINE BUTTON bLoad 
     LABEL "装入" 
     SIZE 15 BY 1.31.

DEFINE VARIABLE vFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "文件名" 
     VIEW-AS FILL-IN 
     SIZE 26 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDet FOR 
      tmp-so SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDet wWin _FREEFORM
  QUERY brDet DISPLAY
      tso_nbr         column-label    "订单号"
tso_cust        column-label    "销往"
tso_bill        column-label    "发票地址"
tso_ship        column-label    "货物发往"
tso_ord_date    column-label    "订货日期" 
tso_rmks        column-label    "备注"
tso_site        column-label    "地点"
"TEMP"          COLUMN-LABEL    "库位"
tso_channel     COLUMN-LABEL    "通道"
tso_tax_usage   COLUMN-LABEL    "税用途"
tsod_line       column-label    "项次"
tsod_part       column-label    "料号"
tsod_site       column-label    "地点"
tsod_qty_ord    column-label    "数量"
"M"             COLUMN-LABEL    "类别"
tsod_acct       column-label    "账户"
tsod_sub        column-label    "分账户"
tsod_cc         column-label    "成本中心"
tsod_project    column-label    "项目"
tsod_chk        column-label    "状态"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 106.5 BY 28.75 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     vFile AT ROW 2.25 COL 7 COLON-ALIGNED WIDGET-ID 2
     bChk AT ROW 2 COL 36 WIDGET-ID 4
     bExp AT ROW 2 COL 52.5 WIDGET-ID 6
     bLoad AT ROW 2 COL 68.5 WIDGET-ID 8
     brDet AT ROW 3.69 COL 1.25 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 106.75 BY 31.75 WIDGET-ID 100.


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
         TITLE              = "客户寄售库存使用装入（xxcnimp.p）"
         HEIGHT             = 31.75
         WIDTH              = 106.75
         MAX-HEIGHT         = 44.13
         MAX-WIDTH          = 170.75
         VIRTUAL-HEIGHT     = 44.13
         VIRTUAL-WIDTH      = 170.75
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDet
/* Query rebuild information for BROWSE brDet
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tmp-so.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDet */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* 客户寄售库存使用装入（xxcnimp.p） */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* 客户寄售库存使用装入（xxcnimp.p） */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-RESIZED OF wWin /* 客户寄售库存使用装入（xxcnimp.p） */
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
ON CHOOSE OF bChk IN FRAME fMain /* 检查 */
DO:
     SESSION:SET-WAIT-STAT("GENERAL").
    {gprun.i ""xxsoivimp1.p""}
    SESSION:SET-WAIT-STAT("").
    OPEN QUERY brlist FOR EACH tmp-so.
    IF CAN-FIND(FIRST tmp-so) THEN DO:
    brdet:REFRESH(). 
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bExp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bExp wWin
ON CHOOSE OF bExp IN FRAME fMain /* 输出 */
DO:

    DEFINE VARIABLE GFILE AS CHARACTER NO-UNDO.
    DEFINE VARIABLE gfret AS LOGICAL NO-UNDO.

  ASSIGN vfile.
  ASSIGN GFILE = vfile.
    SYSTEM-DIALOG GET-FILE gfile
        TITLE      "另存为..."
        FILTERS    "EXCEL工作簿(*.xsl)"   "*.xls"
        MUST-EXIST
        ASK-OVERWRITE
        INITIAL-DIR "."
        DEFAULT-EXTENSION ".xls"
        SAVE-AS
        USE-FILENAME
        UPDATE gfret.
        if gfret then do:
           {gprun.i ""xxsoivimp02.p"" "(input gfile)"}
        end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bLoad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bLoad wWin
ON CHOOSE OF bLoad IN FRAME fMain /* 装入 */
DO:
  IF not CAN-FIND(FIRST tmp-so NO-LOCK WHERE) THEN DO:
     MESSAGE "未找到数据请先装入数据." VIEW-AS ALERT-BOX INFORMATION.
     UNDO,LEAVE.
  END.
  IF CAN-FIND(FIRST tmp-so NO-LOCK WHERE tsod_chk = "") THEN DO:
     MESSAGE "装入前请先检查数据." VIEW-AS ALERT-BOX INFORMATION.
     UNDO,LEAVE.
  END.
  ELSE IF CAN-FIND(FIRST tmp-so NO-LOCK WHERE tsod_chk <> "PASS") THEN DO:
     MESSAGE "数据检查发现错误.请先确认数据。" VIEW-AS ALERT-BOX ERROR.
     UNDO,LEAVE.
  END.
  SESSION:SET-WAIT-STAT("GENERAL").
  {gprun.i ""xxsoivimp3.p""}

  IF CAN-FIND(FIRST tmp-so) THEN DO:
  OPEN QUERY brDet FOR EACH tmp-so.
       brdet:REFRESH().
  END.
  SESSION:SET-WAIT-STAT("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vFile wWin
ON RETURN OF vFile IN FRAME fMain /* 文件名 */
DO:
    DEFINE VARIABL selet AS LOGICAL . 
    ASSIGN vfile.
    
   ASSIGN vFile.
   IF SEARCH(vfile) = ? THEN DO:
   
       SYSTEM-DIALOG GET-FILE vfile
           TITLE      "请选择导入文件..."
           FILTERS    "Excel文件(*.xls)" "*.xls"
           MUST-EXIST
       USE-FILENAME
       UPDATE selet. 
       ASSIGN vfile.
   END.
   /* IF lower(ENTRY(2,VFILE,".")) <> "xls" AND lower(ENTRY(2,VFILE,".")) <> "xlsx" THEN DO: */
/*         MESSAGE "文件必须是Excel文件" VIEW-AS ALERT-BOX ERROR. */
/*        LEAVE.                                                  */
/*    END.                                                        */
/*    EMPTY TEMP-TABLE xsc_m NO-ERROR. */
  IF vfile <> "" THEN DO:
     FIND FIRST usrw_wkfl EXCLUSIVE-LOCK WHERE usrw_domain = GLOBAL_domain AND usrw_key1 = execname
            AND usrw_key2 = global_userid NO-ERROR.
     IF NOT AVAILABLE usrw_wkfl THEN DO:
        CREATE Usrw_wkfl. usrw_domain = GLOBAL_domain.
        ASSIGN Usrw_key1 = execname
               Usrw_key2 = GLOBAL_userid.
     END.
     ASSIGN USrw_key3 = vfile.
  END.
  ASSIGN FILE_name = vfile.
   EMPTY TEMP-TABLE tmp-so NO-ERROR.
   SESSION:SET-WAIT-STAT("general").
   {gprun.i ""xxsoivimp0.p""}
      IF CAN-FIND(FIRST tmp-so) THEN DO:
      OPEN QUERY brDet FOR EACH tmp-so.
      
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
  FIND FIRST usrw_wkfl NO-LOCK WHERE usrw_domain = GLOBAL_domain AND usrw_key1 = execname AND usrw_key2 = global_userid NO-ERROR.
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

