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
{yyldicunrc.i "new"}

    DEFINE STREAM bf.

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
&Scoped-define INTERNAL-TABLES xim

/* Definitions for BROWSE brList                                        */
&Scoped-define FIELDS-IN-QUERY-brList xim_part xim_qty xim_site xim_sojob xim_nbr xim_rmks xim_effdate xim_lot xim_chk xim_loc /*   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brList xim_qty_tr */   
&Scoped-define SELF-NAME brList
&Scoped-define QUERY-STRING-brList FOR EACH xim
&Scoped-define OPEN-QUERY-brList OPEN QUERY {&SELF-NAME} FOR EACH xim.
&Scoped-define TABLES-IN-QUERY-brList xim
&Scoped-define FIRST-TABLE-IN-QUERY-brList xim


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-brList}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiFile hbtnOpen tnLoad btnXls brList 
&Scoped-Define DISPLAYED-OBJECTS fiFile 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-brList 
       MENU-ITEM m_item         LABEL "刷新"          
       RULE
       MENU-ITEM m_del          LABEL "删除"          .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btnGenCimFile 
     LABEL "测试程序" 
     SIZE 9 BY 1.21.

DEFINE BUTTON btnXls 
     LABEL "输出" 
     SIZE 9 BY 1.21.

DEFINE BUTTON hbtnOpen 
     LABEL "浏览..." 
     SIZE 9 BY 1.21.

DEFINE BUTTON tnLoad 
     LABEL "装入" 
     SIZE 9 BY 1.21.

DEFINE VARIABLE fiFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "文件" 
     VIEW-AS FILL-IN 
     SIZE 51.9 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brList FOR 
      xim SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brList wWin _FREEFORM
  QUERY brList DISPLAY
      xim_part    COLUMN-LABEL '料号'
        xim_qty     COLUMN-LABEL '数量'
        xim_site    COLUMN-LABEL '地点'
        xim_sojob   COLUMN-LABEL '项目'
        xim_nbr     COLUMN-LABEL '单号'
        xim_rmks    COLUMN-LABEL '备注'
        xim_effdate COLUMN-LABEL '生效'
        xim_lot     COLUMN-LABEL '批序'
        xim_chk     COLUMN-LABEL '状态'
        xim_loc     COLUMN-LABEL '库位'

/*     ENABLE xim_qty_tr */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 116 BY 31.74 ROW-HEIGHT-CHARS .68 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     fiFile AT ROW 1.58 COL 5.1 COLON-ALIGNED
     hbtnOpen AT ROW 1.53 COL 60
     tnLoad AT ROW 1.53 COL 70
     btnXls AT ROW 1.53 COL 80.5
     btnGenCimFile AT ROW 1.53 COL 92.5
     brList AT ROW 3.21 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 117.6 BY 33.95.


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
         TITLE              = "DCEC-计划外出库批量导入(yyldicunis.p)"
         HEIGHT             = 33.95
         WIDTH              = 117.6
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB brList btnGenCimFile fMain */
ASSIGN 
       brList:POPUP-MENU IN FRAME fMain             = MENU POPUP-MENU-brList:HANDLE
       brList:COLUMN-RESIZABLE IN FRAME fMain       = TRUE.

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
OPEN QUERY {&SELF-NAME} FOR EACH xim.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brList */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* DCEC-计划外出库批量导入(yyldicunis.p) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* DCEC-计划外出库批量导入(yyldicunis.p) */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-RESIZED OF wWin /* DCEC-计划外出库批量导入(yyldicunis.p) */
DO:
    FRAME fmain:WIDTH = wWin:WIDTH NO-ERROR.
    FRAME fmain:VIRTUAL-WIDTH-CHARS = wWin:WIDTH NO-ERROR.
    brList:WIDTH = wWin:WIDTH - 2 NO-ERROR.
    FRAME fmain:HEIGHT= wWin:HEIGHT NO-ERROR.
    FRAME fmain:VIRTUAL-HEIGHT-CHARS = wWin:HEIGHT NO-ERROR.
    brList:HEIGHT = wWin:HEIGHT - 2.64 NO-ERROR.

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


&Scoped-define SELF-NAME btnXls
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnXls wWin
ON CHOOSE OF btnXls IN FRAME fMain /* 输出 */
DO:
  DEFINE VARIABLE h-tt AS HANDLE.
  DEFINE VARIABLE inp_where     AS CHAR.
  DEFINE VARIABLE inp_sortby    AS CHAR.
  DEFINE VARIABLE inp_bwstitle  AS CHAR.
  DEFINE VARIABLE v_list AS CHAR INITIAL "".

  h-tt = TEMP-TABLE xim:HANDLE.
  {gprun.i ""yytoexcel.p"" 
                                 "(INPUT TABLE-HANDLE h-tt, 
                                         INPUT inp_where, INPUT inp_sortby, 
                                         INPUT v_list,
                                         INPUT inp_bwstitle)"}
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFile wWin
ON RETURN OF fiFile IN FRAME fMain /* 文件 */
DO:

    DEFINE VARIABLE vchk AS CHARACTER FORMAT "x(40)" NO-UNDO.
    DEFINE VARIABLE vdesc LIKE pt_desc1 NO-UNDO.
    DEFINE VARIABLE vsn   AS INTEGER INITIAL 0.
    DEFINE VARIABLE v_qty_req LIKE ld_qty_oh.
    DEFINE VARIABLE v_qty_ld LIKE ld_qty_oh.
    DEFINE VARIABLE v_qty_tr LIKE ld_qty_oh.

    ASSIGN fifile.
    if fifile = "" then do:
         message "请先装入文件!" view-as alert-box error.
         leave.
    end.
    if search(fifile) = ? then do:
                message "文件未找到！" view-as alert-box error.
                leave.
    end.
    find first usrw_wkfl EXCLUSIVE-LOCK where usrw_domain = global_domain
           and usrw_key1 = "yyictrld.p.parameter"
           and usrw_key2 = "parameter" no-error.
    if not available usrw_wkfl then do:
             create usrw_wkfl. usrw_domain = global_domain.
             assign usrw_key1 = "yyictrld.p.parameter"
                    usrw_key2 = "parameter".
    end.
        assign usrw_charfld[3] = fifile.
        ASSIGN FN = fifile.

    EMPTY TEMP-TABLE xim NO-ERROR.
    {GPRUN.I ""yyldicunld.p""}
    FOR EACH xim EXCLUSIVE-LOCK WHERE xim_chk = "":
        FIND FIRST ld_det NO-LOCK WHERE ld_domain = GLOBAL_domain AND
                   ld_site = xim_site AND ld_loc = xim_loc AND 
                   ld_part = ld_part AND ld_lot = xim_lot AND
                   ld_qty_oh >= xim_qty  NO-ERROR.
        
        IF NOT AVAILABLE ld_det THEN DO:
           ASSIGN xim_chk = "库存不足".
        END.
    END.
    IF CAN-FIND (FIRST xim) THEN DO:
      OPEN QUERY brlist FOR EACH xim.
      brList:REFRESH().
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME hbtnOpen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hbtnOpen wWin
ON CHOOSE OF hbtnOpen IN FRAME fMain /* 浏览... */
DO:
    DEFINE VARIABLE vfile AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE selet AS LOGICAL INITIAL TRUE.
    SYSTEM-DIALOG GET-FILE vfile
        TITLE      "请选择导入文件..."
        FILTERS    "Microsoft Excel文件(*.xls)"   "*.xls"
        MUST-EXIST
        USE-FILENAME
        UPDATE selet.
    IF selet THEN DO:
        ASSIGN fiFile:SCREEN-VALUE = vfile.
        assign fiFile.
        apply "RETURN":U to fiFIle.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_del wWin
ON CHOOSE OF MENU-ITEM m_del /* 删除 */
DO:


DEFINE VARIABLE br-col1 AS WIDGET.
DEFINE VARIABLE br-col2 AS WIDGET.
DEFINE VARIABLE br-col3 AS WIDGET.
DEFINE VARIABLE br-col4 AS WIDGET.
DEFINE VARIABLE br-col5 AS WIDGET.
DEFINE VARIABLE br-col6 AS WIDGET.
DEFINE VARIABLE ibrowse       AS INTEGER NO-UNDO.
DEFINE VARIABLE method-return AS LOGICAL NO-UNDO.
OPEN QUERY querybrowse1 FOR EACH xim EXCLUSIVE-LOCK.
DO ibrowse = 1 TO brList:NUM-SELECTED-ROWS IN FRAME fmain :
    method-return = brList:FETCH-SELECTED-ROW(ibrowse).
    DELETE xim.
END.
brList:REFRESH().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_item wWin
ON CHOOSE OF MENU-ITEM m_item /* 刷新 */
DO:
  IF CAN-FIND(FIRST xim) THEN
  brlist:REFRESH() IN FRAME fmain.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tnLoad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tnLoad wWin
ON CHOOSE OF tnLoad IN FRAME fMain /* 装入 */
DO:
    DEFINE VARIABLE msgs AS CHARACTER NO-UNDO.
    DEFINE VARIABLE ret AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE yn AS LOGICAL NO-UNDO.
    DEFINE VARIABLE vfile AS CHARACTER NO-UNDO.

    define variable trrecid as recid.


    ret = YES.
    IF NOT CAN-FIND (FIRST xim NO-LOCK) THEN DO:
        MESSAGE "未查到资料！请先装入资料"   VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN.
    END.
    IF CAN-FIND(FIRST xim NO-LOCK WHERE xim_chk <> "") THEN DO:
        ASSIGN msgs = "系统检查资料有错误！".
        ASSIGN ret = NO.
    END.
    IF ret = NO THEN DO:
        ASSIGN yn = NO.
        msgs = "库存调拨出现以下错误：~r~n~r~n" + msgs + "~r~n~r~n yes继续或no返回检查资料".

       MESSAGE msgs VIEW-AS ALERT-BOX INFORMATION BUTTONS YES-NO  TITLE "系统提示" UPDATE yn  .

       IF NOT yn THEN LEAVE.

    END.
    SESSION:SET-WAIT-STATE ("GENERAL").
    FOR EACH xim EXCLUSIVE-LOCK WHERE xim_chk = "":
        assign trrecid = current-value(tr_sq01).
        ASSIGN vfile = "yyldicunrc.p." + string(xim_sn,"9999").
        OUTPUT STREAM bf TO VALUE (vfile + ".bpi").
        PUT STREAM bf UNFORMAT '"' xim_part '"' SKIP.
        PUT STREAM bf UNFORMAT xim_qty ' - - "' xim_site '" "' xim_loc '" "'.
        put STREAM bf unformat xim_lot '" - N "' xim_sojob '"' SKIP.
        PUT STREAM bf UNFORMAT '"' xim_nbr '" - - "' xim_rmks '" ' xim_effdate SKIP.
        OUTPUT STREAM bf CLOSE.


         batchrun = yes.
         input from value(vfile + ".bpi").
         output to value(vfile + ".bpo") keep-messages.
         {gprun.i ""yyicunis.p""}
         hide message no-pause.
         output close.
         input close.
         batchrun = no.
                                                                                                         
        FIND FIRST tr_hist NO-LOCK WHERE tr_domain = GLOBAL_domain AND tr_trnbr >= integer(trrecid)      
               AND tr_nbr = xim_nbr AND tr_part = xim_part AND tr_site = xim_site                       
               AND tr_loc = xim_loc AND tr_serial = xim_lot AND tr_type = "ISS-UNP"                     
               AND tr_qty_loc = (- xim_qty) NO-ERROR.                                                   
        IF AVAILABLE tr_hist THEN DO:                                                                    
            ASSIGN xim_chk = "ISS-UNP:[" + trim(string(tr_trnbr,">>>>>>>>>>>>>9")) + "]".                 
        END.                                                                                             
         os-delete value(vfile + ".bpi") no-error.
         os-delete value(vfile + ".bpo") no-error.
    END.
    SESSION:SET-WAIT-STATE ("").
    IF CAN-FIND(FIRST xim) THEN brlist:REFRESH() IN FRAME fmain.
/*     MESSAGE "操作完成！！！" VIEW-AS ALERT-BOX INFORMATION TITLE "系统消息". */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brList
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */

SESSION:SET-WAIT-STATE ("").
find first usrw_wkfl no-lock where usrw_domain = global_domain
       and usrw_key1 = "yyictrld.p.parameter"
       and usrw_key2 = "parameter" no-error.
IF AVAILABLE usrw_wkfl THEN DO:
      assign fifile =  usrw_charfld[3].
END.

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
  ENABLE fiFile hbtnOpen tnLoad btnXls brList 
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

