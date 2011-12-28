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

/* Local Variable Definitions ---                                       */
{xxitmt01.i "new"}

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
&Scoped-define INTERNAL-TABLES tmp_data

/* Definitions for BROWSE brList                                        */
&Scoped-define FIELDS-IN-QUERY-brList td_part td_routing td_op td_nbr td_id td_feature td_attr td_methd td_spec td_um td_effdate td_enddate td_rmks[1] td_rmks[2] td_rmks[3] td_rmks[4] td_rmks[5] td_chk   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brList   
&Scoped-define SELF-NAME brList
&Scoped-define QUERY-STRING-brList FOR EACH tmp_data
&Scoped-define OPEN-QUERY-brList OPEN QUERY {&SELF-NAME} FOR EACH tmp_data.
&Scoped-define TABLES-IN-QUERY-brList tmp_data
&Scoped-define FIRST-TABLE-IN-QUERY-brList tmp_data


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
      tmp_data SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brList wWin _FREEFORM
  QUERY brList DISPLAY
      td_part COLUMN-LABEL "零件号"                         
td_routing COLUMN-LABEL "工艺流程/过程"                
td_op COLUMN-LABEL "工序"                             
td_nbr COLUMN-LABEL "单据"                          
td_id COLUMN-LABEL "编号"                       
td_feature COLUMN-LABEL "特性"                   
td_attr COLUMN-LABEL "属性"                
td_methd COLUMN-LABEL "测试方法"                  
td_spec COLUMN-LABEL "技术规格"              
td_um COLUMN-LABEL "计量"                      
td_effdate COLUMN-LABEL "生效日期"                        
td_enddate COLUMN-LABEL "结束有效日"                          
td_rmks[1] COLUMN-LABEL "说明1"
td_rmks[2] COLUMN-LABEL "说明2"
td_rmks[3] COLUMN-LABEL "说明3"
td_rmks[4] COLUMN-LABEL "说明4"
td_rmks[5] COLUMN-LABEL "说明5"
td_chk COLUMN-LABEL "状态"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 100 BY 28.63 ROW-HEIGHT-CHARS .68 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     fiFile AT ROW 1.58 COL 5.13 COLON-ALIGNED
     btnOpen AT ROW 1.58 COL 48
     btnDelBOM AT ROW 1.58 COL 60
     btnGenCimFile AT ROW 1.58 COL 71.63
     tnLoad AT ROW 1.58 COL 82.75
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
         TITLE              = "物料测试技术要求装入(xxitmt01ci.w)-111204.1"
         HEIGHT             = 29.05
         WIDTH              = 100
         MAX-HEIGHT         = 39.95
         MAX-WIDTH          = 146.25
         VIRTUAL-HEIGHT     = 39.95
         VIRTUAL-WIDTH      = 146.25
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
       brList:POPUP-MENU IN FRAME fMain             = MENU POPUP-MENU-brList:HANDLE
       brList:COLUMN-RESIZABLE IN FRAME fMain       = TRUE.

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
OPEN QUERY {&SELF-NAME} FOR EACH tmp_data.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brList */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* 物料测试技术要求装入(xxitmt01ci.w)-111204.1 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* 物料测试技术要求装入(xxitmt01ci.w)-111204.1 */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-RESIZED OF wWin /* 物料测试技术要求装入(xxitmt01ci.w)-111204.1 */
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
   FOR EACH tmp_data NO-LOCK  :
  
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
            FILTERS    "Excel文件(*.xlsx)" "*.xlsx,*.xls"  
            MUST-EXIST
        USE-FILENAME
        UPDATE selet.
    ASSIGN fiFile:SCREEN-VALUE = vfile.
    ASSIGN fifile.

EMPTY TEMP-TABLE tmp_data NO-ERROR.
IF selet = TRUE THEN DO:
    SESSION:SET-WAIT-STAT("GENERAL").
    IF search(fifile) <>  ? THEN DO:
        CREATE "Excel.Application" excelAppl.   
        xworkbook = excelAppl:Workbooks:OPEN(fifile).
        xworksheet = excelAppl:sheets:item(1).
        DO vsn = 2 TO xworksheet:UsedRange:Rows:Count:
           if trim(xworksheet:cells(vsn,1):VALUE) <> "" then do:
              CREATE tmp_data.
              ASSIGN td_part = string(xworksheet:cells(vsn,1):VALUE)
                     td_routing = string(xworksheet:cells(vsn,2):VALUE)
                     td_op = xworksheet:cells(vsn,3):VALUE
                     td_nbr = string(xworksheet:cells(vsn,4):VALUE)
                     td_id = string(xworksheet:cells(vsn,5):VALUE)
                     td_feature = string(xworksheet:cells(vsn,6):VALUE)
                     td_attr = string(xworksheet:cells(vsn,7):VALUE)
                     td_methd =  string(xworksheet:cells(vsn,8):VALUE)
                     td_spec = string(xworksheet:cells(vsn,9):VALUE)
                     td_um = string(xworksheet:cells(vsn,10):VALUE)
                     td_effdate = xworksheet:cells(vsn,11):VALUE
                     td_enddate = xworksheet:cells(vsn,12):VALUE
                     td_rmks[1] = string(xworksheet:cells(vsn,13):VALUE)
                     td_rmks[2] = string(xworksheet:cells(vsn,14):VALUE)
                     td_rmks[3] = string(xworksheet:cells(vsn,15):VALUE)
                     td_rmks[4] = string(xworksheet:cells(vsn,16):VALUE)
                     td_rmks[5] = string(xworksheet:cells(vsn,17):VALUE).
             end.
             else do:
                 next.
             end.

        END.
       excelAppl:quit.
       release object excelAppl.
       RELEASE OBJECT xworkbook.
       RELEASE OBJECT xworksheet.
    SESSION:SET-WAIT-STAT("").
 END.
    
 FOR EACH tmp_data EXCLUSIVE-LOCK:
     IF td_feature = ? THEN ASSIGN td_feature = "".
     IF td_attr = ? THEN ASSIGN td_attr = "".
     IF td_methd = ? THEN ASSIGN td_methd = "".
     IF td_spec = ? THEN ASSIGN td_spec = "".
     IF td_um = ? THEN ASSIGN td_um = "".
     IF td_rmks[1] = ? THEN ASSIGN td_rmks[1] = "".
     IF td_rmks[2] = ? THEN ASSIGN td_rmks[2] = "".
     IF td_rmks[3] = ? THEN ASSIGN td_rmks[3] = "".
     IF td_rmks[4] = ? THEN ASSIGN td_rmks[4] = "".
     IF td_rmks[5] = ? THEN ASSIGN td_rmks[5] = "".
 END.
    RUN chkData.
    OPEN QUERY brlist FOR EACH tmp_data.
    brList:REFRESH().
    STATUS INPUT getstat().

 END.

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
    DEFINE VARIABLE fname AS CHARACTER NO-UNDO.
    DEFINE VARIABLE errmsg AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i AS INTEGER.
    DEFINE VARIABLE mem AS LOGICAL.
    IF NOT CAN-FIND (FIRST tmp_data NO-LOCK) THEN DO:
        MESSAGE "未查到资料！请先装入资料"   VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN.
    END.
    IF CAN-FIND(FIRST tmp_data WHERE td_chk <> "") THEN DO:
        MESSAGE "发现资料错误,请调整资料后重新装入!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        UNDO,LEAVE.
    END.

    SESSION:SET-WAIT-STATE("GENERAL") .
    ASSIGN fname = "xxitmt01ci." + STRING(TIME).
    OUTPUT TO VALUE(fname  + ".bpi").
        FOR EACH tmp_data NO-LOCK:
/*             PUT UNFORMAT "@@batchload mpitmt01.p" SKIP.  */
            PUT UNFORMAT '"' td_part '" "' td_routing '" ' trim(string(td_op,">>>>9")) SKIP.
            PUT UNFORMAT '"' td_nbr '"' SKIP.
            PUT UNFORMAT '"' td_id '" '.
            FIND FIRST ipd_det NO-LOCK WHERE  ipd_domain = GLOBAL_domain AND
                       ipd_part = td_part AND ipd_routing = td_routing AND
                       ipd_op = td_op AND ipd_test = td_id AND ipd_start = td_effdate NO-ERROR.
            IF AVAILABLE ipd_det THEN DO:
                PUT UNFORMAT ipd_start.
            END.
            PUT SKIP.
            PUT UNFORMAT '"' td_feature '" "' td_attr '" "' td_methd '" "' td_spec '" "' td_um '" ' .
            PUT UNFORMAT td_effdate ' ' td_enddate " Yes" SKIP. 
            PUT UNFORMAT trim(string(td_op,">>>>9")) " - - -" SKIP.
            DO i = 1 TO 5:
                PUT UNFORMAT '"' td_rmks[i] '" '.
            END.
            PUT UNFORMAT SKIP "-" SKIP "." SKIP "." SKIP.
/*             PUT UNFORMAT "@@END" SKIP.  */
        END.
    OUTPUT CLOSE.
    
    batchrun  = yes.
    input from value(fname + ".bpi").
    output to value(fname + ".bpo") keep-messages.
    hide message no-pause.
    {gprun.i ""mpitmt01.p""}
    hide message no-pause.
    output close.
    input close.
    batchrun  = no.

    FOR EACH tmp_data EXCLUSIVE-LOCK:
        FIND FIRST ipd_det NO-LOCK WHERE  ipd_domain = GLOBAL_domain AND
                       ipd_part = td_part AND ipd_routing = td_routing AND
                       ipd_op = td_op AND ipd_test = td_id AND ipd_start = td_effdate NO-ERROR.
        IF NOT AVAILABLE ipd_det THEN DO:
           ASSIGN td_chk  = "资料装入失败.".
        END.
        ELSE DO:
            ASSIGN td_chk = "OK".
        END.
    END.
    SESSION:SET-WAIT-STATE("") .
    brList:REFRESH().
/*     IF NOT CAN-FIND(FIRST tmp_data WHERE td_chk <> "OK") THEN DO:  */
/*        OS-DELETE VALUE(fname + ".bpi"). */
/*        OS-DELETE VALUE(fname + ".bpo"). */
/*     END. */
    MESSAGE "操作完成！！！" VIEW-AS ALERT-BOX INFORMATION TITLE "系统消息".
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
    FOR EACH TMP_data NO-LOCK:
        ASSIGN vsn = vsn + 1.
    END.
    

  RETURN "共" + STRING(vsn) + "笔".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

