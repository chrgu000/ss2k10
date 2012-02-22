&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File:

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.
{mfdeclre.i}
/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
{xxsoimp.i "new"}
/* Local Variable Definitions ---                                       */

/* DEFINE TEMP-TABLE tmp-so                               */
/*     FIELDS tso_nbr    LIKE so_nbr                      */
/*     FIELDS tso_cust   LIKE so_cust                     */
/*     FIELDS tso_bill   LIKE so_bill                     */
/*     FIELDS tso_ship   LIKE so_ship                     */
/*     FIELDS tso_req_date LIKE so_req_date               */
/*     FIELDS tso_due_date LIKE so_due_date               */
/*     FIELDS tso_rmks     LIKE so_rmks                   */
/*     FIELDS tso_site     LIKE so_site                   */
/*     FIELDS tso_curr     LIKE so_curr                   */
/*     FIELDS tsod_line    LIKE sod_line                  */
/*     FIELDS tsod_part    LIKE sod_part                  */
/*     FIELDS tsod_site    LIKE sod_site                  */
/*     FIELDS tsod_qty_ord LIKE sod_qty_ord               */
/*     FIELDS tsod_loc     LIKE sod_loc                   */
/*     FIELDS tsod_acct    LIKE sod_acct                  */
/*     FIELDS tsod_sub     LIKE sod_sub                   */
/*     FIELDS tsod_due_date LIKE sod_due_date             */
/*     FIELDS tsod_rmks1    LIKE so_rmks                  */
/*     FIELDS tsod_chk      AS   CHARACTER FORMAT "x(40)" */
/*     INDEX tso_nbr IS PRIMARY tso_nbr tsod_line         */
/*     .                                                  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME brList

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tmp-so

/* Definitions for BROWSE brList                                        */
&Scoped-define FIELDS-IN-QUERY-brList tso_nbr "订单号" tso_cust "销往" tso_bill "发票地址" tso_ship "货物发往" tso_req_date "要求日期" tso_due_date "截止日期" tso_rmks "备注" tso_site "地点" tso_curr "货币" tsod_line "项次" tsod_part "ERP 号" tsod_site "地点" tsod_qty_ord "数量" tsod_loc "库位" tsod_acct "账户" tsod_sub "分账户" tsod_due_date "截止日期" tsod_rmks1 "说明1" tsod_chk "状态"   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brList   
&Scoped-define SELF-NAME brList
&Scoped-define QUERY-STRING-brList FOR EACH tmp-so
&Scoped-define OPEN-QUERY-brList OPEN QUERY {&SELF-NAME} FOR EACH tmp-so.
&Scoped-define TABLES-IN-QUERY-brList tmp-so
&Scoped-define FIRST-TABLE-IN-QUERY-brList tmp-so


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-brList}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiFile btnOpen tnLoad brList 
&Scoped-Define DISPLAYED-OBJECTS fiFile 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getStat wWin 
FUNCTION getStat RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-brList 
       MENU-ITEM m_item         LABEL "刷新"          .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btnDelBOM 
     LABEL "删除" 
     SIZE 9 BY 1.21.

DEFINE BUTTON btnGenCimFile 
     LABEL "测试程序" 
     SIZE 9 BY 1.21.

DEFINE BUTTON btnOpen 
     LABEL "浏览..." 
     SIZE 9 BY 1.21.

DEFINE BUTTON tnLoad 
     LABEL "装入" 
     SIZE 9 BY 1.21.

DEFINE VARIABLE fiFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "文件" 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brList FOR 
      tmp-so SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brList wWin _FREEFORM
  QUERY brList DISPLAY
      tso_nbr         column-label    "订单号"
tso_cust        column-label    "销往"
tso_bill        column-label    "发票地址"
tso_ship        column-label    "货物发往"
tso_req_date    column-label    "要求日期"
tso_due_date    column-label    "截止日期"
tso_rmks        column-label    "备注"
tso_site        column-label    "地点"
tso_curr        column-label    "货币"
tsod_line       column-label    "项次"
tsod_part       column-label    "ERP 号"
tsod_site       column-label    "地点"
tsod_qty_ord    column-label    "数量"
tsod_loc        column-label    "库位"
tsod_acct       column-label    "账户"
tsod_sub        column-label    "分账户"
tsod_due_date   column-label    "截止日期"
tsod_rmks1      column-label    "说明1"
tsod_chk        column-label    "状态"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 100 BY 28.63 ROW-HEIGHT-CHARS .7 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     fiFile AT ROW 1.58 COL 5.1 COLON-ALIGNED
     btnOpen AT ROW 1.58 COL 48
     btnDelBOM AT ROW 1.58 COL 60
     btnGenCimFile AT ROW 1.58 COL 70
     tnLoad AT ROW 1.58 COL 82
     brList AT ROW 3.21 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 101.11 BY 31.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "销售订单装入(xxpoimp.p)"
         HEIGHT             = 31
         WIDTH              = 101.1
         MAX-HEIGHT         = 39.95
         MAX-WIDTH          = 146.2
         VIRTUAL-HEIGHT     = 39.95
         VIRTUAL-WIDTH      = 146.2
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* BROWSE-TAB brList tnLoad fMain */
ASSIGN 
       brList:POPUP-MENU IN FRAME fMain             = MENU POPUP-MENU-brList:HANDLE.

/* SETTINGS FOR BUTTON btnDelBOM IN FRAME fMain
   NO-ENABLE                                                            */
ASSIGN 
       btnDelBOM:HIDDEN IN FRAME fMain           = TRUE.

/* SETTINGS FOR BUTTON btnGenCimFile IN FRAME fMain
   NO-ENABLE                                                            */
ASSIGN 
       btnGenCimFile:HIDDEN IN FRAME fMain           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brList
/* Query rebuild information for BROWSE brList
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tmp-so.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brList */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* 销售订单装入(xxpoimp.p) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* 销售订单装入(xxpoimp.p) */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-RESIZED OF wWin /* 销售订单装入(xxpoimp.p) */
DO:
  FRAME fmain:WIDTH = wWin:WIDTH.
  FRAME fmain:VIRTUAL-WIDTH-CHARS = wWin:WIDTH.
  brList:WIDTH = FRAME fmain:WIDTH - 1.
  FRAME fmain:HEIGHT = wWin:HEIGHT.
  FRAME fmain:VIRTUAL-HEIGHT-CHARS = wWin:HEIGHT.
  brList:HEIGHT = FRAME fmain:HEIGHT - 2.68.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnDelBOM
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnDelBOM wWin
ON CHOOSE OF btnDelBOM IN FRAME fMain /* 删除 */
DO:
   DEFINE VARIABLE errmsg AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE fname  AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE fid    AS INTEGER    NO-UNDO.
   DEFINE VARIABLE tid    AS INTEGER    NO-UNDO.
   DEFINE VARIABLE ret    AS LOGICAL NO-UNDO.
   DEFINE VARIABLE msgs   AS CHARACTER  NO-UNDO.

   ASSIGN fname = "del" + STRING(TIME) + ".cim".
   OUTPUT TO VALUE(fname).
   FOR EACH tmp-so NO-LOCK  :
  
   END.
   OUTPUT CLOSE.
    errmsg = "".
    {gprun.i ""hkbdld.p"" "( INPUT fname, OUTPUT fid, OUTPUT tid)"}
    {gprun.i ""hkbdpro.p"" "(INPUT fid,INPUT tid, OUTPUT ret, OUTPUT errmsg)"}


/*     OS-DELETE VALUE(fname).  */

    SESSION:SET-WAIT-STATE("") .

    IF ret = FALSE THEN DO:
        msgs = msgs + "~r~nCIMLOAD出现以下错误：~r~n" + errmsg.
        MESSAGE msgs VIEW-AS ALERT-BOX INFORMATION.
        RETURN.
    END.

    MESSAGE "操作完成" VIEW-AS ALERT-BOX.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnGenCimFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnGenCimFile wWin
ON CHOOSE OF btnGenCimFile IN FRAME fMain /* 测试程序 */
DO:
  DEFINE VARIABLE svfile AS CHARACTER NO-UNDO.
  DEFINE VARIABLE sel AS LOGICAL INITIAL TRUE.


 SYSTEM-DIALOG GET-FILE svfile
        TITLE      "保存为 ..."
        FILTERS    "CIM load files (*.CIM)"   "*.CIM"
        MUST-EXIST
        USE-FILENAME
        save-as
        UPDATE sel.
    IF SUBSTRING(svfile,LENGTH(svfile) - 3 ) <> '.cim' THEN DO:
        ASSIGN svfile = svfile + '.cim'.
    END.
    IF sel = TRUE THEN DO:
        SESSION:SET-WAIT-STATE ("GENERAL").
        RUN cratePTCim (INPUT svfile ).
        RUN createBOMCim(INPUT svfile ).
        SESSION:SET-WAIT-STATE ("").
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnOpen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnOpen wWin
ON CHOOSE OF btnOpen IN FRAME fMain /* 浏览... */
DO:
    DEFINE VARIABLE vfile AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE desc1 AS CHARACTER FORMAT "x(40)" NO-UNDO.
    DEFINE VARIABLE desc2 AS CHARACTER FORMAT "x(40)" NO-UNDO.
    DEFINE VARIABLE selet AS LOGICAL INITIAL TRUE.
    DEFINE VARIABLE vsn   AS INTEGER INITIAL 0.
    DEFINE VARIABLE excelAppl AS COM-HANDLE.   
    define variable xworkbook as com-handle.
    define variable xworksheet as com-handle.
        SYSTEM-DIALOG GET-FILE vfile
            TITLE      "请选择导入文件..."
            FILTERS    "Excel文件(*.xls)" "*.xls"
            MUST-EXIST
        USE-FILENAME
        UPDATE selet.
    ASSIGN fiFile:SCREEN-VALUE = vfile.
    ASSIGN fifile.

EMPTY TEMP-TABLE tmp-so NO-ERROR.
IF selet THEN DO:
    ASSIGN file_name = fifile.
    {gprun.i ""xxsoimp0.p""}
END.                    
/* IF selet = TRUE THEN DO:                                                                          */
/*     SESSION:SET-WAIT-STAT("GENERAL").                                                             */
/*     IF search(fifile) <>  ? THEN DO:                                                              */
/*         CREATE "Excel.Application" excelAppl.                                                     */
/*         xworkbook = excelAppl:Workbooks:OPEN(fifile).                                             */
/*         xworksheet = excelAppl:sheets:item(1).                                                    */
/*         DO vsn = 2 TO xworksheet:UsedRange:Rows:Count:                                            */
/*                   if trim(xworksheet:cells(vsn,1):VALUE) <> "" then do:                           */
/*                      CREATE tmp-so.                                                               */
/*                      ASSIGN  tso_nbr = string(xworksheet:cells(vsn,1):VALUE)                      */
/*                              tso_cust =  string(xworksheet:cells(vsn,2):VALUE)                    */
/*                              tso_bill =  string(xworksheet:cells(vsn,3):VALUE)                    */
/*                              tso_ship =  string(xworksheet:cells(vsn,4):VALUE)                    */
/*                              tso_req_date =   xworksheet:cells(vsn,5):VALUE                       */
/*                              tso_due_date =   xworksheet:cells(vsn,6):VALUE                       */
/*                              tso_rmks =   string(xworksheet:cells(vsn,7):VALUE)                   */
/*                              tso_site =   string(xworksheet:cells(vsn,8):VALUE)                   */
/*                              tso_curr =   string(xworksheet:cells(vsn,9):VALUE)                   */
/*                              tsod_line =   xworksheet:cells(vsn,10):VALUE                         */
/*                              tsod_part =   string(xworksheet:cells(vsn,11):VALUE)                 */
/*                              tsod_site =   string(xworksheet:cells(vsn,12):VALUE)                 */
/*                              tsod_qty_ord = xworksheet:cells(vsn,13):VALUE                        */
/*                              tsod_loc =   string(xworksheet:cells(vsn,14):VALUE)                  */
/*                              tsod_acct =   string(xworksheet:cells(vsn,15):VALUE)                 */
/*                              tsod_sub =   string(xworksheet:cells(vsn,16):VALUE)                  */
/*                              tsod_due_date   =   xworksheet:cells(vsn,17):VALUE                   */
/*                              tsod_rmks1  =   string(xworksheet:cells(vsn,18):VALUE).              */
/*              end.                                                                                 */
/*              else do:                                                                             */
/*                                 next.                                                             */
/*              end.                                                                                 */
/*                                                                                                   */
/*         END.                                                                                      */
/*        excelAppl:quit.                                                                            */
/*        release object excelAppl.                                                                  */
/*        RELEASE OBJECT xworkbook.                                                                  */
/*        RELEASE OBJECT xworksheet.                                                                 */
/*     SESSION:SET-WAIT-STAT("").                                                                    */
/*  END.                                                                                             */
/*                                                                                                   */
/*                                                                                                   */
/*     FOR EACH TMP-SO EXCLUSIVE-LOCK :                                                              */
/*         ASSIGN vsn = vsn + 1.                                                                     */
/*          IF  TSO_NBR = '' OR tso_nbr = ? THEN DO:                                                 */
/*              DELETE TMP-SO.                                                                       */
/*          END.                                                                                     */
/*          ELSE DO:                                                                                 */
/*               IF tso_curr = ? THEN DO:                                                            */
/*                   FIND FIRST cm_mstr NO-LOCK WHERE cm_addr = tso_cust NO-ERROR.                   */
/*                   IF AVAILABLE cm_mstr THEN DO:                                                   */
/*                       ASSIGN tso_curr = cm_curr.                                                  */
/*                   END.                                                                            */
/*                   ELSE DO:                                                                        */
/*                         for first en_mstr                                                         */
/*                           fields( en_domain en_curr en_entity en_name)                            */
/*                            where en_mstr.en_domain = global_domain and en_entity = current_entity */
/*                           no-lock:                                                                */
/*                         END.                                                                      */
/*                         IF AVAILABLE en_mstr THEN DO:                                             */
/*                             ASSIGN tso_curr = en_curr.                                            */
/*                         END.                                                                      */
/*                   END.                                                                            */
/*               END.                                                                                */
/*               IF tso_rmks = ? THEN ASSIGN tso_rmks = "-".                                         */
/*               IF tsod_acct = ? THEN ASSIGN tsod_acct = "-".                                       */
/*               IF tsod_sub = ? THEN ASSIGN tsod_sub = "-".                                         */
/*               IF tsod_rmks1 = ? THEN ASSIGN tsod_rmks1 = "-".                                     */
/*               IF tsod_loc = ? THEN ASSIGN tsod_loc = "-".                                         */
/*          END.                                                                                     */
/*     END.                                                                                          */
        
   
    OPEN QUERY brlist FOR EACH tmp-so.
    brList:REFRESH().
    STATUS INPUT getstat().
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_item wWin
ON CHOOSE OF MENU-ITEM m_item /* 刷新 */
DO:
  brlist:REFRESH() IN FRAME fmain.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tnLoad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tnLoad wWin
ON CHOOSE OF tnLoad IN FRAME fMain /* 装入 */
DO:
    SESSION:SET-WAIT-STAT("GENERAL").
    {gprun.i ""xxsoimp1.p""}
    SESSION:SET-WAIT-STAT("").
    OPEN QUERY brlist FOR EACH tmp-so.
    brList:REFRESH().
    STATUS INPUT getstat().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brList
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
/* {xxwtitle.i "wWin"} */

SESSION:SET-WAIT-STATE ("").
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  DISPLAY fiFile 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE fiFile btnOpen tnLoad brList 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys
            its contents and itself.
    Notes:
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getStat wWin 
FUNCTION getStat RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
    DEFINE VARIABLE vsn AS INTEGER.
    ASSIGN vsn = 0.
    FOR EACH TMP-SO NO-LOCK:
        ASSIGN vsn = vsn + 1.
    END.
    

  RETURN "共" + STRING(vsn) + "笔".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

