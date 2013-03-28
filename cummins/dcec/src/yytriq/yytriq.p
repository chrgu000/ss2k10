&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases
          qaddb            PROGRESS
*/
&Scoped-define WINDOW-NAME cWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS cWin
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME brMain

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tr_hist

/* Definitions for BROWSE brMain                                        */
&Scoped-define FIELDS-IN-QUERY-brMain tr_hist.tr_site tr_hist.tr_trnbr ~
tr_hist.tr_type tr_hist.tr_nbr tr_hist.tr_line tr_hist.tr_ship_id ~
tr_hist.tr_rmks tr_hist.tr_lot tr_hist.tr_ref tr_hist.tr_loc ~
tr_hist.tr_date STRING (tr_hist.tr_time,"hh:mm:ss") tr_hist.tr_effdate ~
tr_hist.tr_part tr_hist.tr_um tr_hist.tr_addr tr_hist.tr_qty_chg ~
tr_hist.tr_qty_loc tr_hist.tr_qty_req tr_hist.tr_qty_short ~
tr_hist.tr_begin_qoh tr_hist.tr_loc_begin tr_hist.tr_status ~
tr_hist.tr_serial tr_hist.tr_enduser tr_hist.tr_expire tr_hist.tr_per_date ~
tr_hist.tr_ship_date tr_hist.tr_last_date tr_hist.tr_gl_date ~
tr_hist.tr_curr tr_hist.tr_price tr_hist.tr_cprice tr_hist.tr_gl_amt ~
tr_hist.tr_mtl_std tr_hist.tr_bdn_std tr_hist.tr_lbr_std tr_hist.tr_sub_std ~
tr_hist.tr_ovh_std tr_hist.tr_prod_line tr_hist.tr_program ~
tr_hist.tr_ref_site tr_hist.tr_rev tr_hist.tr_rsn_code tr_hist.tr_batch ~
tr_hist.tr_sa_nbr tr_hist.tr_ship_inv_mov tr_hist.tr_ship_type ~
tr_hist.tr_so_job tr_hist.tr_upd_isb tr_hist.tr_vend_date ~
tr_hist.tr_vend_lot tr_hist.tr_wod_op tr_hist.tr_userid tr_hist.tr_xslspsn1 ~
tr_hist.tr_xslspsn2 tr_hist.tr_slspsn[1] tr_hist.tr_slspsn[2] ~
tr_hist.tr_slspsn[3] tr_hist.tr_slspsn[4] tr_hist.tr_xcr_acct ~
tr_hist.tr_xcr_cc tr_hist.tr_xcr_proj tr_hist.tr_xdr_acct tr_hist.tr_xdr_cc ~
tr_hist.tr_xdr_proj tr_hist.tr_xgl_ref
&Scoped-define ENABLED-FIELDS-IN-QUERY-brMain
&Scoped-define QUERY-STRING-brMain FOR EACH tr_hist NO-LOCK use-index tr_eff_trnbr where tr_domain = global_domain and tr_effdate = today ~
    BY tr_hist.tr_trnbr DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brMain OPEN QUERY brMain FOR EACH tr_hist NO-LOCK use-index tr_eff_trnbr where tr_domain = global_domain and tr_effdate = today ~
    BY tr_hist.tr_trnbr DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brMain tr_hist
&Scoped-define FIRST-TABLE-IN-QUERY-brMain tr_hist


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-brMain}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btQry fiSite fiTrans fiOrder fiPart filot ~
fiType btPrint tgDate fiStart fiEnd fiShip fiLoc fiAddr fiUser btSum ~
rdOrder tgEffDate fiEffStart fiEffEnd brMain
&Scoped-Define DISPLAYED-OBJECTS fiSite fiTrans fiOrder fiPart filot fiType ~
tgDate fiStart fiEnd fiShip fiLoc fiAddr fiUser rdOrder tgEffDate ~
fiEffStart fiEffEnd

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR cWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btPrint
     LABEL "输出"
     SIZE 5.5 BY 1.11.

DEFINE BUTTON btQry
     LABEL "查询"
     SIZE 5.5 BY 1.11.

DEFINE BUTTON btSum
     LABEL "汇总"
     SIZE 5.5 BY 1.11.

DEFINE VARIABLE fiAddr AS CHARACTER FORMAT "X(256)":U
     LABEL "地址"
     VIEW-AS FILL-IN
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE fiEffEnd AS DATE FORMAT "99/99/99":U
     LABEL "至"
     VIEW-AS FILL-IN
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE fiEffStart AS DATE FORMAT "99/99/99":U
     LABEL "生效"
     VIEW-AS FILL-IN
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE fiEnd AS DATE FORMAT "99/99/99":U
     LABEL "至"
     VIEW-AS FILL-IN
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE fiLoc AS CHARACTER FORMAT "X(256)":U
     LABEL "仓库"
     VIEW-AS FILL-IN
     SIZE 5 BY 1 NO-UNDO.

DEFINE VARIABLE filot AS CHARACTER FORMAT "X(256)":U
     LABEL "批号"
     VIEW-AS FILL-IN
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE fiOrder AS CHARACTER FORMAT "X(256)":U
     LABEL "订单号"
     VIEW-AS FILL-IN
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE fiPart AS CHARACTER FORMAT "X(256)":U
     LABEL "零件号"
     VIEW-AS FILL-IN
     SIZE 10.7 BY 1 NO-UNDO.

DEFINE VARIABLE fiShip AS CHARACTER FORMAT "X(256)":U
     LABEL "货运单"
     VIEW-AS FILL-IN
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE fiSite AS CHARACTER FORMAT "X(256)":U
     LABEL "地点"
     VIEW-AS FILL-IN
     SIZE 4.9 BY 1 NO-UNDO.

DEFINE VARIABLE fiStart AS DATE FORMAT "99/99/99":U
     LABEL "日期"
     VIEW-AS FILL-IN
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE fiTrans AS CHARACTER FORMAT "X(256)":U
     LABEL "交易号"
     VIEW-AS FILL-IN
     SIZE 6.3 BY 1 NO-UNDO.

DEFINE VARIABLE fiType AS CHARACTER FORMAT "X(256)":U
     LABEL "交易类型"
     VIEW-AS FILL-IN
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE fiUser AS CHARACTER FORMAT "X(256)":U
     LABEL "操作员"
     VIEW-AS FILL-IN
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE rdOrder AS CHARACTER
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS
          "Trans", "tr_trnbr",
"Site", "tr_site",
"Type", "tr_type",
"Order", "tr_nbr",
"Shipper", "tr_ship_id",
"Date", "tr_date",
"EffDate", "tr_effdate",
"Item", "tr_part",
"Remarks", "tr_rmks"
     SIZE 51 BY 1.11 NO-UNDO.

DEFINE VARIABLE tgDate AS LOGICAL INITIAL no
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .84 NO-UNDO.

DEFINE VARIABLE tgEffDate AS LOGICAL INITIAL no
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .84 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brMain FOR
      tr_hist SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brMain cWin _STRUCTURED
  QUERY brMain NO-LOCK DISPLAY
      tr_hist.tr_site FORMAT "x(8)":U WIDTH 4.3
      tr_hist.tr_trnbr FORMAT ">>>>>>>>":U
      tr_hist.tr_type FORMAT "x(8)":U WIDTH 4.8
      tr_hist.tr_nbr FORMAT "x(18)":U WIDTH 5.6
      tr_hist.tr_line FORMAT ">>>>9":U
      tr_hist.tr_ship_id COLUMN-LABEL "Ship NO" FORMAT "x(20)":U
            WIDTH 7.1
      tr_hist.tr_rmks FORMAT "x(10)":U WIDTH 5.6
      tr_hist.tr_lot FORMAT "x(8)":U WIDTH 4.6
      tr_hist.tr_ref FORMAT "x(8)":U WIDTH 5.6
      tr_hist.tr_loc COLUMN-LABEL "Loc" FORMAT "x(8)":U WIDTH 3.6
      tr_hist.tr_date FORMAT "99/99/99":U WIDTH 6.5
      STRING (tr_hist.tr_time,"hh:mm:ss") COLUMN-LABEL "Time" WIDTH 6.6
      tr_hist.tr_effdate FORMAT "99/99/99":U WIDTH 6.6
      tr_hist.tr_part FORMAT "x(15)":U WIDTH 8.1
      tr_hist.tr_um FORMAT "x(2)":U WIDTH 2.6
      tr_hist.tr_addr FORMAT "x(8)":U WIDTH 8.6
      tr_hist.tr_qty_chg FORMAT "->,>>>,>>9.9<<<<<<<<":U
      tr_hist.tr_qty_loc FORMAT "->,>>>,>>9.9<<<<<<<<":U
      tr_hist.tr_qty_req FORMAT "->,>>>,>>9.9<<<<<<<<":U
      tr_hist.tr_qty_short FORMAT "->,>>>,>>9.9<<<<<<<<":U WIDTH 7.6
      tr_hist.tr_begin_qoh FORMAT "->,>>>,>>9.9<<<<<<<<":U
      tr_hist.tr_loc_begin FORMAT "->,>>>,>>9.9<<<<<<<<":U
      tr_hist.tr_status FORMAT "x(8)":U
      tr_hist.tr_serial FORMAT "x(18)":U WIDTH 4.8
      tr_hist.tr_enduser FORMAT "X(8)":U
      tr_hist.tr_expire FORMAT "99/99/99":U
      tr_hist.tr_per_date FORMAT "99/99/99":U
      tr_hist.tr_ship_date FORMAT "99/99/99":U
      tr_hist.tr_last_date FORMAT "99/99/99":U
      tr_hist.tr_gl_date FORMAT "99/99/99":U
      tr_hist.tr_curr FORMAT "x(3)":U
      tr_hist.tr_price FORMAT "->>>,>>>,>>9.99<<<":U WIDTH 6.3
      tr_hist.tr_cprice COLUMN-LABEL "CPrice" FORMAT ">>>>,>>>,>>9.99<<<":U
            WIDTH 6.1
      tr_hist.tr_gl_amt FORMAT "->>>>>,>>9.99":U WIDTH 7.3
      tr_hist.tr_mtl_std FORMAT "->>>,>>>,>>9.99<<<":U WIDTH 7.1
      tr_hist.tr_bdn_std FORMAT "->>>,>>>,>>9.99<<<":U WIDTH 7
      tr_hist.tr_lbr_std FORMAT "->>>,>>>,>>9.99<<<":U WIDTH 5.8
      tr_hist.tr_sub_std FORMAT "->>>,>>>,>>9.99<<<":U WIDTH 7.9
      tr_hist.tr_ovh_std FORMAT ">>>>,>>>,>>9.99<<<":U WIDTH 6.6
      tr_hist.tr_prod_line FORMAT "x(4)":U
      tr_hist.tr_program FORMAT "x(12)":U
      tr_hist.tr_ref_site FORMAT "x(8)":U
      tr_hist.tr_rev FORMAT "x(4)":U
      tr_hist.tr_rsn_code FORMAT "x(8)":U
      tr_hist.tr_batch FORMAT "x(18)":U WIDTH 6.6
      tr_hist.tr_sa_nbr FORMAT "x(8)":U
      tr_hist.tr_ship_inv_mov FORMAT "x(8)":U
      tr_hist.tr_ship_type FORMAT "x(1)":U
      tr_hist.tr_so_job FORMAT "x(8)":U
      tr_hist.tr_upd_isb FORMAT "yes/no":U
      tr_hist.tr_vend_date FORMAT "99/99/99":U WIDTH 6.7
      tr_hist.tr_vend_lot FORMAT "x(18)":U WIDTH 8.2
      tr_hist.tr_wod_op FORMAT ">>>>>>":U
      tr_hist.tr_userid FORMAT "x(8)":U
      tr_hist.tr_xslspsn1 COLUMN-LABEL "Xalespsn1" FORMAT "x(8)":U
      tr_hist.tr_xslspsn2 COLUMN-LABEL "Xalespsn2" FORMAT "x(8)":U
            WIDTH 6.6
      tr_hist.tr_slspsn[1] COLUMN-LABEL "Salespsn[1]" FORMAT "x(8)":U
            WIDTH 7
      tr_hist.tr_slspsn[2] COLUMN-LABEL "Salespsn[2]" FORMAT "x(8)":U
            WIDTH 6.6
      tr_hist.tr_slspsn[3] COLUMN-LABEL "Salespsn[3]" FORMAT "x(8)":U
            WIDTH 6.9
      tr_hist.tr_slspsn[4] COLUMN-LABEL "Salespsn[4]" FORMAT "x(8)":U
            WIDTH 6.6
      tr_hist.tr_xcr_acct COLUMN-LABEL "Cr Acct" FORMAT "x(8)":U
            WIDTH 6.5
      tr_hist.tr_xcr_cc COLUMN-LABEL "Cr CC" FORMAT "x(4)":U
      tr_hist.tr_xcr_proj COLUMN-LABEL "Cr Project" FORMAT "x(8)":U
            WIDTH 7.1
      tr_hist.tr_xdr_acct COLUMN-LABEL "Dr Acct" FORMAT "x(8)":U
            WIDTH 7.5
      tr_hist.tr_xdr_cc COLUMN-LABEL "Dr CC" FORMAT "x(4)":U
      tr_hist.tr_xdr_proj COLUMN-LABEL "Dr Project" FORMAT "x(8)":U
            WIDTH 7.1
      tr_hist.tr_xgl_ref COLUMN-LABEL "GL Reference" FORMAT "x(14)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89.8 BY 23.05 ROW-HEIGHT-CHARS .79 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     btQry AT ROW 1.26 COL 84
     fiSite AT ROW 1.37 COL 4.9 COLON-ALIGNED
     fiTrans AT ROW 1.37 COL 15.7 COLON-ALIGNED
     fiOrder AT ROW 1.37 COL 27.7 COLON-ALIGNED
     fiPart AT ROW 1.37 COL 41.2 COLON-ALIGNED
     filot AT ROW 1.37 COL 56.1 COLON-ALIGNED
     fiType AT ROW 1.37 COL 71 COLON-ALIGNED
     btPrint AT ROW 2.74 COL 84
     tgDate AT ROW 2.95 COL 2
     fiStart AT ROW 2.95 COL 6.2 COLON-ALIGNED
     fiEnd AT ROW 2.95 COL 17.6 COLON-ALIGNED
     fiShip AT ROW 2.95 COL 32 COLON-ALIGNED
     fiLoc AT ROW 2.95 COL 45 COLON-ALIGNED
     fiAddr AT ROW 2.95 COL 55.2 COLON-ALIGNED
     fiUser AT ROW 2.95 COL 67.6 COLON-ALIGNED
     btSum AT ROW 4.16 COL 84.1
     rdOrder AT ROW 4.26 COL 32 NO-LABEL
     tgEffDate AT ROW 4.32 COL 2
     fiEffStart AT ROW 4.32 COL 6.1 COLON-ALIGNED
     fiEffEnd AT ROW 4.32 COL 17.6 COLON-ALIGNED
     brMain AT ROW 5.68 COL 1.2
     "排序" VIEW-AS TEXT
          SIZE 3 BY .68 AT ROW 4.53 COL 28.7
    WITH 1 DOWN NO-BOX OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 90.11 BY 27.83.


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
  CREATE WINDOW cWin ASSIGN
         HIDDEN             = YES
         TITLE              = "事务交易查询"
         HEIGHT             = 27.84
         WIDTH              = 90.1
         MAX-HEIGHT         = 53.11
         MAX-WIDTH          = 142.2
         VIRTUAL-HEIGHT     = 53.11
         VIRTUAL-WIDTH      = 142.2
         SHOW-IN-TASKBAR    = no
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = yes
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW cWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* BROWSE-TAB brMain fiEffEnd fMain */
ASSIGN
       brMain:NUM-LOCKED-COLUMNS IN FRAME fMain     = 4
       brMain:ALLOW-COLUMN-SEARCHING IN FRAME fMain = TRUE
       brMain:COLUMN-RESIZABLE IN FRAME fMain       = TRUE
       brMain:COLUMN-MOVABLE IN FRAME fMain         = TRUE.

ASSIGN
       tr_hist.tr_curr:VISIBLE IN BROWSE brMain = FALSE
       tr_hist.tr_price:VISIBLE IN BROWSE brMain = FALSE
       tr_hist.tr_cprice:VISIBLE IN BROWSE brMain = FALSE
       tr_hist.tr_gl_amt:VISIBLE IN BROWSE brMain = FALSE
       tr_hist.tr_mtl_std:VISIBLE IN BROWSE brMain = FALSE
       tr_hist.tr_bdn_std:VISIBLE IN BROWSE brMain = FALSE
       tr_hist.tr_lbr_std:VISIBLE IN BROWSE brMain = FALSE
       tr_hist.tr_sub_std:VISIBLE IN BROWSE brMain = FALSE
       tr_hist.tr_ovh_std:VISIBLE IN BROWSE brMain = FALSE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(cWin)
THEN cWin:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brMain
/* Query rebuild information for BROWSE brMain
     _TblList          = "qaddb.tr_hist"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "qaddb.tr_hist.tr_trnbr|no"
     _FldNameList[1]   > qaddb.tr_hist.tr_site
"tr_hist.tr_site" ? ? "character" ? ? ? ? ? ? no ? no no "4.3" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = qaddb.tr_hist.tr_trnbr
     _FldNameList[3]   > qaddb.tr_hist.tr_type
"tr_hist.tr_type" ? ? "character" ? ? ? ? ? ? no ? no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > qaddb.tr_hist.tr_nbr
"tr_hist.tr_nbr" ? ? "character" ? ? ? ? ? ? no ? no no "5.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > qaddb.tr_hist.tr_line
"tr_hist.tr_line" ? ">>>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > qaddb.tr_hist.tr_ship_id
"tr_hist.tr_ship_id" "Ship NO" ? "character" ? ? ? ? ? ? no ? no no "7.1" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > qaddb.tr_hist.tr_rmks
"tr_hist.tr_rmks" ? ? "character" ? ? ? ? ? ? no ? no no "5.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > qaddb.tr_hist.tr_lot
"tr_hist.tr_lot" ? ? "character" ? ? ? ? ? ? no ? no no "4.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > qaddb.tr_hist.tr_ref
"tr_hist.tr_ref" ? ? "character" ? ? ? ? ? ? no ? no no "5.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > qaddb.tr_hist.tr_loc
"tr_hist.tr_loc" "Loc" ? "character" ? ? ? ? ? ? no ? no no "3.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > qaddb.tr_hist.tr_date
"tr_hist.tr_date" ? ? "date" ? ? ? ? ? ? no ? no no "6.5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"STRING (tr_hist.tr_time,""hh:mm:ss"")" "Time" ? ? ? ? ? ? ? ? no ? no no "6.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > qaddb.tr_hist.tr_effdate
"tr_hist.tr_effdate" ? ? "date" ? ? ? ? ? ? no ? no no "6.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > qaddb.tr_hist.tr_part
"tr_hist.tr_part" ? "x(15)" "character" ? ? ? ? ? ? no ? no no "8.1" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > qaddb.tr_hist.tr_um
"tr_hist.tr_um" ? ? "character" ? ? ? ? ? ? no ? no no "2.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > qaddb.tr_hist.tr_addr
"tr_hist.tr_addr" ? ? "character" ? ? ? ? ? ? no ? no no "8.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   = qaddb.tr_hist.tr_qty_chg
     _FldNameList[18]   = qaddb.tr_hist.tr_qty_loc
     _FldNameList[19]   = qaddb.tr_hist.tr_qty_req
     _FldNameList[20]   > qaddb.tr_hist.tr_qty_short
"tr_hist.tr_qty_short" ? ? "decimal" ? ? ? ? ? ? no ? no no "7.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   = qaddb.tr_hist.tr_begin_qoh
     _FldNameList[22]   = qaddb.tr_hist.tr_loc_begin
     _FldNameList[23]   = qaddb.tr_hist.tr_status
     _FldNameList[24]   > qaddb.tr_hist.tr_serial
"tr_hist.tr_serial" ? ? "character" ? ? ? ? ? ? no ? no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   = qaddb.tr_hist.tr_enduser
     _FldNameList[26]   = qaddb.tr_hist.tr_expire
     _FldNameList[27]   = qaddb.tr_hist.tr_per_date
     _FldNameList[28]   = qaddb.tr_hist.tr_ship_date
     _FldNameList[29]   = qaddb.tr_hist.tr_last_date
     _FldNameList[30]   = qaddb.tr_hist.tr_gl_date
     _FldNameList[31]   > qaddb.tr_hist.tr_curr
"tr_hist.tr_curr" ? ? "character" ? ? ? ? ? ? no ? no no ? no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[32]   > qaddb.tr_hist.tr_price
"tr_hist.tr_price" ? ? "decimal" ? ? ? ? ? ? no ? no no "6.3" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[33]   > qaddb.tr_hist.tr_cprice
"tr_hist.tr_cprice" "CPrice" ? "decimal" ? ? ? ? ? ? no ? no no "6.1" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[34]   > qaddb.tr_hist.tr_gl_amt
"tr_hist.tr_gl_amt" ? ? "decimal" ? ? ? ? ? ? no ? no no "7.3" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[35]   > qaddb.tr_hist.tr_mtl_std
"tr_hist.tr_mtl_std" ? ? "decimal" ? ? ? ? ? ? no ? no no "7.1" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[36]   > qaddb.tr_hist.tr_bdn_std
"tr_hist.tr_bdn_std" ? ? "decimal" ? ? ? ? ? ? no ? no no "7" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[37]   > qaddb.tr_hist.tr_lbr_std
"tr_hist.tr_lbr_std" ? ? "decimal" ? ? ? ? ? ? no ? no no "5.8" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[38]   > qaddb.tr_hist.tr_sub_std
"tr_hist.tr_sub_std" ? ? "decimal" ? ? ? ? ? ? no ? no no "7.9" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[39]   > qaddb.tr_hist.tr_ovh_std
"tr_hist.tr_ovh_std" ? ? "decimal" ? ? ? ? ? ? no ? no no "6.6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[40]   = qaddb.tr_hist.tr_prod_line
     _FldNameList[41]   = qaddb.tr_hist.tr_program
     _FldNameList[42]   = qaddb.tr_hist.tr_ref_site
     _FldNameList[43]   = qaddb.tr_hist.tr_rev
     _FldNameList[44]   = qaddb.tr_hist.tr_rsn_code
     _FldNameList[45]   > qaddb.tr_hist.tr_batch
"tr_hist.tr_batch" ? ? "character" ? ? ? ? ? ? no ? no no "6.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[46]   = qaddb.tr_hist.tr_sa_nbr
     _FldNameList[47]   = qaddb.tr_hist.tr_ship_inv_mov
     _FldNameList[48]   = qaddb.tr_hist.tr_ship_type
     _FldNameList[49]   = qaddb.tr_hist.tr_so_job
     _FldNameList[50]   = qaddb.tr_hist.tr_upd_isb
     _FldNameList[51]   > qaddb.tr_hist.tr_vend_date
"tr_hist.tr_vend_date" ? ? "date" ? ? ? ? ? ? no ? no no "6.7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[52]   > qaddb.tr_hist.tr_vend_lot
"tr_hist.tr_vend_lot" ? ? "character" ? ? ? ? ? ? no ? no no "8.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[53]   = qaddb.tr_hist.tr_wod_op
     _FldNameList[54]   = qaddb.tr_hist.tr_userid
     _FldNameList[55]   > qaddb.tr_hist.tr_xslspsn1
"tr_hist.tr_xslspsn1" "Xalespsn1" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[56]   > qaddb.tr_hist.tr_xslspsn2
"tr_hist.tr_xslspsn2" "Xalespsn2" ? "character" ? ? ? ? ? ? no ? no no "6.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[57]   > qaddb.tr_hist.tr_slspsn[1]
"tr_hist.tr_slspsn[1]" "Salespsn[1]" ? "character" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[58]   > qaddb.tr_hist.tr_slspsn[2]
"tr_hist.tr_slspsn[2]" "Salespsn[2]" ? "character" ? ? ? ? ? ? no ? no no "6.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[59]   > qaddb.tr_hist.tr_slspsn[3]
"tr_hist.tr_slspsn[3]" "Salespsn[3]" ? "character" ? ? ? ? ? ? no ? no no "6.9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[60]   > qaddb.tr_hist.tr_slspsn[4]
"tr_hist.tr_slspsn[4]" "Salespsn[4]" ? "character" ? ? ? ? ? ? no ? no no "6.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[61]   > qaddb.tr_hist.tr_xcr_acct
"tr_hist.tr_xcr_acct" "Cr Acct" ? "character" ? ? ? ? ? ? no ? no no "6.5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[62]   > qaddb.tr_hist.tr_xcr_cc
"tr_hist.tr_xcr_cc" "Cr CC" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[63]   > qaddb.tr_hist.tr_xcr_proj
"tr_hist.tr_xcr_proj" "Cr Project" ? "character" ? ? ? ? ? ? no ? no no "7.1" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[64]   > qaddb.tr_hist.tr_xdr_acct
"tr_hist.tr_xdr_acct" "Dr Acct" ? "character" ? ? ? ? ? ? no ? no no "7.5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[65]   > qaddb.tr_hist.tr_xdr_cc
"tr_hist.tr_xdr_cc" "Dr CC" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[66]   > qaddb.tr_hist.tr_xdr_proj
"tr_hist.tr_xdr_proj" "Dr Project" ? "character" ? ? ? ? ? ? no ? no no "7.1" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[67]   > qaddb.tr_hist.tr_xgl_ref
"tr_hist.tr_xgl_ref" "GL Reference" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brMain */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME cWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cWin cWin
ON END-ERROR OF cWin /* 事务交易查询 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cWin cWin
ON WINDOW-CLOSE OF cWin /* 事务交易查询 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cWin cWin
ON WINDOW-RESIZED OF cWin /* 事务交易查询 */
DO:

    FRAME fmain:WIDTH = cWin:WIDTH.
    FRAME fmain:VIRTUAL-WIDTH-CHARS = cWin:WIDTH.
    brMain:WIDTH = FRAME fmain:WIDTH.
    FRAME fmain:HEIGHT = cWin:HEIGHT.
    FRAME fmain:VIRTUAL-HEIGHT-CHARS = cWin:HEIGHT.
    brMain:HEIGHT = FRAME fmain:HEIGHT - 4.68.

/*     IF cWin:WIDTH-CHARS > brMain:WIDTH IN FRAME fMain THEN DO:  */
/*        FRAME fMain:WIDTH = cWin:WIDTH-CHARS - 1.5 .   /*112*/   */
/*        FRAME fMain:HEIGHT = cWin:HEIGHT-CHARS - 0.5. /*36*/     */
/*        brMain:WIDTH IN FRAME fMain = cWin:WIDTH-CHARS - 2.5.    */
/*        brMain:HEIGHT IN FRAME fMain = cWin:HEIGHT-CHARS - 5.5.  */
/*     END.                                                        */
/*     ELSE DO:                                                    */
/*         brMain:WIDTH IN FRAME fMain = cWin:WIDTH-CHARS - 2.5.   */
/*         brMain:HEIGHT IN FRAME fMain = cWin:HEIGHT-CHARS - 5.5. */
/*         FRAME fMain:WIDTH = cWin:WIDTH-CHARS - 1.5.   /*112*/   */
/*         FRAME fMain:HEIGHT = cWin:HEIGHT-CHARS - 0.5. /*36*/    */
/*     END.                                                        */
/*     MESSAGE "w" cWin:WIDTH-CHARS cWin:HEIGHT-CHARS "Br" brMain:WIDTH IN FRAME fMain brMain:HEIGHT IN FRAME fMain "Fm" FRAME fMain:WIDTH FRAME fMain:HEIGHT. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrint
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrint cWin
ON CHOOSE OF btPrint IN FRAME fMain /* 输出 */
DO:
   DEFINE VARIABLE hQuery AS WIDGET-HANDLE.
   DEFINE VARIABLE ret AS LOGICAL.
   DEFINE VARIABLE myFile AS CHARACTER.
   DEFINE VARIABLE desc1 AS CHARACTER FORMAT "x(32)".
   DEFINE VARIABLE adsort AS CHARACTER  FORMAT "x(20)".
   DEFINE VARIABLE username LIKE usr_name NO-UNDO.
   DEFINE VARIABLE i AS INTEGER.
   DEFINE VARIABLE j AS INTEGER.
   DEFINE VARIABLE hExcel        AS COM-HANDLE NO-UNDO.
   DEFINE VARIABLE hWorkbook     AS COM-HANDLE NO-UNDO.
   DEFINE VARIABLE hWorksheet    AS COM-HANDLE NO-UNDO.
	 SESSION:SET-WAIT-STATE("GENERAL").
/*    ASSIGN myFile = "tr_hist.txt".                   */
/*                                                     */
/*    SYSTEM-DIALOG GET-FILE myFile                    */
/*                  FILTERS "文本文件 (*.txt)" "*.txt" */
/*                  ASK-OVERWRITE                      */
/*                  SAVE-AS                            */
/*                  TITLE "保存到文本文件..."          */
/*                  USE-FILENAME UPDATE ret.           */
/*                                                     */
/*                                                     */
/*                                                     */
/*   IF ret = NO THEN RETURN.                          */
/*    OUTPUT TO VALUE(myFile).                         */
  CREATE "Excel.Application" hExcel NO-ERROR.
    hExcel:VISIBLE = FALSE NO-ERROR.
    hWorkbook      = hExcel:Workbooks:Add() NO-ERROR.
    hWorkSheet     = hExcel:Sheets:Item(1) NO-ERROR.

  hQuery = brMain:QUERY.
  hQuery:SET-BUFFERS(BUFFER tr_hist:HANDLE) NO-ERROR.
  hQuery:GET-FIRST().

      hExcel:Worksheets("Sheet1"):Cells(1,1) = "料号".
      hExcel:Worksheets("Sheet1"):Cells(1,2) = "地点".
      hExcel:Worksheets("Sheet1"):Cells(1,3) = "库位".
      hExcel:Worksheets("Sheet1"):Cells(1,4) = "批/序".
      hExcel:Worksheets("Sheet1"):Cells(1,5) = "单号".
      hExcel:Worksheets("Sheet1"):Cells(1,6) = "客户单/工作".
      hExcel:Worksheets("Sheet1"):Cells(1,7) = "数量".
      hExcel:Worksheets("Sheet1"):Cells(1,8) = "交易类型".
      hExcel:Worksheets("Sheet1"):Cells(1,9) = "料号说明".
      hExcel:Worksheets("Sheet1"):Cells(1,10) = "项次".
      hExcel:Worksheets("Sheet1"):Cells(1,11) = "日期".
      hExcel:Worksheets("Sheet1"):Cells(1,12) = "生效日期".
      hExcel:Worksheets("Sheet1"):Cells(1,13) = "厂商/客户".
      hExcel:Worksheets("Sheet1"):Cells(1,14) = "用户ID".
      hExcel:Worksheets("Sheet1"):Cells(1,15) = "用户".

      ASSIGN i = 2.
  REPEAT:
      IF hQuery:QUERY-OFF-END THEN LEAVE.

      FIND pt_mstr WHERE pt_domain = global_domain and pt_part = tr_part NO-LOCK NO-ERROR.
      IF AVAILABLE pt_mstr THEN
          desc1 = pt_desc1.
      FIND ad_mstr WHERE ad_domain = global_domain and ad_addr = tr_addr NO-LOCK NO-ERROR.
      IF AVAILABLE ad_mstr THEN
          adsort = ad_sort.
      FIND FIRST usr_mstr WHERE USr_userid = tr_userid NO-LOCK NO-ERROR.
      IF AVAIL usr_mstr THEN
          ASSIGN username = usr_name.
       hExcel:Worksheets("Sheet1"):Cells(i,1) = "'" + tr_part.
       hExcel:Worksheets("Sheet1"):Cells(i,2) = "'" +  tr_site .
       hExcel:Worksheets("Sheet1"):Cells(i,3) = "'" +  tr_LOC .
       hExcel:Worksheets("Sheet1"):Cells(i,4) = "'" +  tr_serial .
       hExcel:Worksheets("Sheet1"):Cells(i,5) = "'" +  tr_nbr.
       hExcel:Worksheets("Sheet1"):Cells(i,6) = "'" +  tr_so_job.
       hExcel:Worksheets("Sheet1"):Cells(i,7) = tr_qty_loc .
       hExcel:Worksheets("Sheet1"):Cells(i,8) = "'" +  tr_type.
       hExcel:Worksheets("Sheet1"):Cells(i,9) = "'" + desc1.
       hExcel:Worksheets("Sheet1"):Cells(i,10) = tr_line .
       hExcel:Worksheets("Sheet1"):Cells(i,11) = "'" + string(tr_date).
       hExcel:Worksheets("Sheet1"):Cells(i,12) = "'" + string(tr_effdate).
       hExcel:Worksheets("Sheet1"):Cells(i,13) = "'" +  tr_addr .
       hExcel:Worksheets("Sheet1"):Cells(i,14) = "'" +  tr_userid .
       hExcel:Worksheets("Sheet1"):Cells(i,15) = "'" +  username .

/*       DISPLAY                                                                     */
/*              tr_type FORMAT "x(8)"                                                */
/*              tr_site FORMAT "x(4)"                                                */
/*              tr_nbr FORMAT "X(14)"                                                */
/*              tr_line FORMAT ">>>>9"                                               */
/*              tr_ship_id  FORMAT "X(12)"                                           */
/*              trim(tr_rmks) FORMAT "X(20)"                                         */
/*              trim(tr_so_job) FORMAT "X(8)"         COLUMN-LABEL "计划外出/入单号" */
/*              tr_lot FORMAT "X(8)"                                                 */
/*              tr_serial  FORMAT "X(18)"                                            */
/*              tr_ref FORMAT "X(8) "                                                */
/*              Tr_loc FORMAT "X(8)"                                                 */
/*              tr_date FORMAT "99/99/99"                                            */
/*              STRING(tr_time, "HH:MM:SS") FORMAT "x(8)" COLUMN-LABEL "Time"        */
/*              TR_effdate FORMAT "99/99/99"                                         */
/*              Tr_part FORMAT "X(18)"           COLUMN-LABEL "零件号"               */
/*              trim(desc1)                            COLUMN-LABEL "零件描述"       */
/*              Tr_um FORMAT "X(2)"              COLUMN-LABEL "单位"                 */
/*              TRIM(tr_addr) FORMAT "X(8)"            COLUMN-LABEL "厂商/客户号"    */
/*              trim(adsort)                           COLUMN-LABEL "简称"           */
/*              tr_vend_lot FORMAT "X(18)"                                           */
/*              tr_qty_loc FORMAT "->>>,>>>,>>9.9<<"  COLUMN-LABEL "交易数量"        */
/*              tr_userid  COLUMN-LABEL "ID"                                         */
/*              username   COLUMN-LABEL "用户"                                       */
/* /*                                                                                */
/*              tr_price   FORMAT "->>>>9.9<<<"      COLUMN-LABEL "价格"             */
/*              tr_mtl_std FORMAT "->>>>9.9<<<"      COLUMN-LABEL "原料成本"         */
/*              tr_lbr_std FORMAT "->>>9.9<<"      COLUMN-LABEL "人工成本"           */
/*              Tr_bdn_std FORMAT "->>>9.9<<"      COLUMN-LABEL "附加成本"           */
/*              Tr_sub_std FORMAT "->>>9.9<<"      COLUMN-LABEL "外包成本"           */
/*              Tr_ovh_std FORMAT "->>>9.9<<"      COLUMN-LABEL "间接成本"           */
/* */                                                                                */
/*          WITH STREAM-IO WIDTH 320. /*STREAM-IO /*GUI*/ */                         */
				 I = I  + 1.
        hQuery:GET-NEXT().
  END.
      SESSION:SET-WAIT-STATE("").
      hExcel:VISIBLE = TRUE NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQry
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQry cWin
ON CHOOSE OF btQry IN FRAME fMain /* 查询 */
DO:
  ASSIGN fiSite.
  ASSIGN fiTrans.
  ASSIGN fiOrder.
  ASSIGN fiPart.
  ASSIGN fiType.
  ASSIGN fiUser.
  ASSIGN rdOrder.
  ASSIGN fiStart.
  ASSIGN fiEnd.
  ASSIGN fiEffStart.
  ASSIGN fiEffEnd.
  ASSIGN fiLoc.
  ASSIGN fiAddr.
  ASSIGN fiShip.
  ASSIGN tgDate.
  ASSIGN tgEffdate.
  ASSIGN filot.

  DEFINE VARIABLE hQuery AS WIDGET-HANDLE.
  DEFINE VARIABLE Sqlstr AS CHARACTER.

  hQuery = brMain:QUERY.

  Sqlstr = "FOR EACH qaddb.tr_hist no-lock WHERE tr_domain = '" + global_domain + "' and (tr_trnbr <= integer(""" + fiTrans + """) OR """ + fiTrans + """ = """") AND ".
  Sqlstr = Sqlstr + "(tr_nbr BEGINS """ + fiOrder + """ OR """ + fiOrder + """ = """") AND ".
  Sqlstr = Sqlstr + "(tr_part BEGINS """ + fiPart + """) AND ".
  Sqlstr = Sqlstr + "(tr_serial BEGINS """ + filot + """) AND ".
  Sqlstr = Sqlstr + "(index (""" + fiType + """, tr_type) > 0 OR """ + fiType + """ = """") AND ".
  Sqlstr = Sqlstr + "(tr_site = """ + fiSite + """ OR """ + fiSite + """ = """") AND ".
  Sqlstr = Sqlstr + "(tr_ship_id = """ + fiShip + """ OR """ + fiShip + """ = """") AND ".
  Sqlstr = Sqlstr + "(tr_userid = """ + fiUser + """ OR """ + fiUser + """ = """") AND ".
  Sqlstr = Sqlstr + "(tr_loc = """ + fiLoc + """ OR """ + fiLoc + """ = """") AND ".
  Sqlstr = Sqlstr + "(tr_addr = """ + fiAddr + """ OR """ + fiAddr + """ = """") AND ".
  Sqlstr = Sqlstr + "((tr_date >= DATE(""" + fiStart:SCREEN-VALUE + """) OR """ + fiStart:SCREEN-VALUE + """ = """") AND ".
  Sqlstr = Sqlstr + " (tr_date <= DATE(""" + fiEnd:SCREEN-VALUE + """) OR """ + fiEnd:SCREEN-VALUE + """ = """") OR """ + tgDate:SCREEN-VALUE + """ = ""no"" ) AND ".
  Sqlstr = Sqlstr + "((tr_effdate >= DATE(""" + fiEffStart:SCREEN-VALUE + """) OR """ + fiEffStart:SCREEN-VALUE + """ = """") AND ".
  Sqlstr = Sqlstr + " (tr_effdate <= DATE(""" + fiEffEnd:SCREEN-VALUE + """) OR """ + fiEffEnd:SCREEN-VALUE + """ = """") OR """ +  tgEffDate:SCREEN-VALUE + """ = ""no"" ) ".

  Sqlstr = Sqlstr + " use-index tr_part_eff BY " + rdOrder:SCREEN-VALUE + " DESC INDEXED-REPOSITION ".

  SESSION:SET-WAIT-STATE("GENERAL").

  hQuery:QUERY-PREPARE(Sqlstr).
  hQuery:QUERY-OPEN.

  SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSum cWin
ON CHOOSE OF btSum IN FRAME fMain /* 汇总 */
DO:
  DEFINE VARIABLE hQuery AS WIDGET-HANDLE.
  DEFINE VARIABLE std_amt AS DECIMAL FORMAT "->>>>>>>9.9<<" INITIAL 0.
  DEFINE VARIABLE prc_amt AS DECIMAL FORMAT "->>>>>>>9.9<<" INITIAL 0.
  DEFINE VARIABLE prc_amt2 AS DECIMAL FORMAT "->>>>>>>9.9<<" INITIAL 0.
  DEFINE VARIABLE loc_tot AS DECIMAL FORMAT "->>>>>>>>>>9.9<<" INITIAL 0.
  DEFINE VARIABLE chg_tot AS DECIMAL FORMAT "->>>>>>>>>>9.9<<" INITIAL 0.

  STATUS INPUT " 正在汇总...".
  hQuery = brMain:QUERY.
  hQuery:SET-BUFFERS(BUFFER tr_hist:HANDLE) NO-ERROR.

  hQuery:GET-FIRST().
  REPEAT:

      IF hQuery:QUERY-OFF-END THEN LEAVE.
      loc_tot = loc_tot + tr_qty_loc.
      chg_tot = chg_tot + tr_qty_chg.
/*       std_amt = std_amt + tr_gl_amt.               */
/*       prc_amt = prc_amt + tr_price * tr_qty_chg.   */
/*       prc_amt2 = prc_amt + tr_price * tr_qty_loc.  */
      hQuery:GET-NEXT().
  END.

  MESSAGE
          "LOC数量=" TRIM(STRING(loc_tot, "->>,>>>,>>>,>>9.99"))
          "CHG数量=" TRIM(STRING(chg_tot, "->>,>>>,>>>,>>9.99")).
/*           "Prc-chg金额=" TRIM(STRING(prc_amt, "->>,>>>,>>>,>>9.9"))   */
/*           "Prc-loc金额=" TRIM(STRING(prc_amt2, "->>,>>>,>>>,>>9.9"))  */
/*           "GL金额=" TRIM(STRING(std_amt, "->>,>>>,>>>,>>9.9")).       */

  STATUS INPUT " 汇总完毕!".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiAddr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiAddr cWin
ON ANY-KEY OF fiAddr IN FRAME fMain /* 地址 */
DO:

    IF KEYFUNCTION(LASTKEY) = "RETURN" OR KEYFUNCTION(LASTKEY) = "GO" THEN
    DO:
        ASSIGN fiUser.

        OPEN QUERY brMain FOR EACH qaddb.tr_hist WHERE tr_domain = global_domain and tr_userid BEGINS fiUser NO-LOCK BY tr_userid INDEXED-REPOSITION.

    END.
    ELSE IF KEYFUNCTION(LASTKEY) = "cursor-left" OR KEYFUNCTION(LASTKEY) = "cursor-right" THEN
        APPLY LASTKEY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiEffEnd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiEffEnd cWin
ON ANY-KEY OF fiEffEnd IN FRAME fMain /* 至 */
DO:

/*   IF KEYFUNCTION(LASTKEY) = "RETURN" OR KEYFUNCTION(LASTKEY) = "GO" THEN                                                 */
/*   DO:                                                                                                                    */
/*       ASSIGN fiEnd.                                                                                                      */
/*       OPEN QUERY brMain FOR EACH qaddb.tr_hist WHERE tr_domain = global_domain and tr_date <= DATE(fiEnd) NO-LOCK  BY tr_date DESC INDEXED-REPOSITION. */
/*                                                                                                                          */
/*   END.                                                                                                                   */
/*   ELSE IF KEYFUNCTION(LASTKEY) = "cursor-left" OR KEYFUNCTION(LASTKEY) = "cursor-right" THEN                             */
/*       APPLY LASTKEY.                                                                                                     */
/*                                                                                                                          */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiEffStart
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiEffStart cWin
ON ANY-KEY OF fiEffStart IN FRAME fMain /* 生效 */
DO:

/*   IF KEYFUNCTION(LASTKEY) = "RETURN" OR KEYFUNCTION(LASTKEY) = "GO" THEN                                               */
/*   DO:                                                                                                                  */
/*       ASSIGN fiStart.                                                                                                  */
/*       OPEN QUERY brMain FOR EACH qaddb.tr_hist WHERE tr_domain = global_domain and tr_date >= DATE(fiStart) NO-LOCK  BY tr_date INDEXED-REPOSITION.  */
/*                                                                                                                        */
/*   END.                                                                                                                 */
/*   ELSE IF KEYFUNCTION(LASTKEY) = "cursor-left" OR KEYFUNCTION(LASTKEY) = "cursor-right" THEN                           */
/*       APPLY LASTKEY.                                                                                                   */
/*                                                                                                                        */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiEnd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiEnd cWin
ON ANY-KEY OF fiEnd IN FRAME fMain /* 至 */
DO:

/*   IF KEYFUNCTION(LASTKEY) = "RETURN" OR KEYFUNCTION(LASTKEY) = "GO" THEN                                                  */
/*   DO:                                                                                                                     */
/*       ASSIGN fiEnd.                                                                                                       */
/*       OPEN QUERY brMain FOR EACH qaddb.tr_hist WHERE tr_domain = global_domain and tr_date <= DATE(fiEnd) NO-LOCK  BY tr_date DESC INDEXED-REPOSITION.  */
/*                                                                                                                           */
/*   END.                                                                                                                    */
/*   ELSE IF KEYFUNCTION(LASTKEY) = "cursor-left" OR KEYFUNCTION(LASTKEY) = "cursor-right" THEN                              */
/*       APPLY LASTKEY.                                                                                                      */


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiLoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiLoc cWin
ON ANY-KEY OF fiLoc IN FRAME fMain /* 仓库 */
DO:

    IF KEYFUNCTION(LASTKEY) = "RETURN" OR KEYFUNCTION(LASTKEY) = "GO" THEN
    DO:
        ASSIGN fiUser.

        OPEN QUERY brMain FOR EACH qaddb.tr_hist WHERE tr_domain = global_domain and tr_userid BEGINS fiUser NO-LOCK BY tr_userid INDEXED-REPOSITION.

    END.
    ELSE IF KEYFUNCTION(LASTKEY) = "cursor-left" OR KEYFUNCTION(LASTKEY) = "cursor-right" THEN
        APPLY LASTKEY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME filot
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL filot cWin
ON ANY-KEY OF filot IN FRAME fMain /* 批号 */
DO:
  IF KEYFUNCTION(LASTKEY) = "RETURN" OR KEYFUNCTION(LASTKEY) = "GO" THEN
  DO:
      ASSIGN filot.
      OPEN QUERY brMain FOR EACH qaddb.tr_hist WHERE tr_domain = global_domain and tr_serial BEGINS filot NO-LOCK BY tr_serial INDEXED-REPOSITION.

  END.
  ELSE IF KEYFUNCTION(LASTKEY) = "cursor-left" OR KEYFUNCTION(LASTKEY) = "cursor-right" THEN
      APPLY LASTKEY.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiOrder
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiOrder cWin
ON ANY-KEY OF fiOrder IN FRAME fMain /* 订单号 */
DO:
  IF KEYFUNCTION(LASTKEY) = "RETURN" OR KEYFUNCTION(LASTKEY) = "GO" THEN
  DO:
      ASSIGN fiOrder.
      OPEN QUERY brMain FOR EACH qaddb.tr_hist WHERE tr_domain = global_domain and tr_nbr BEGINS fiOrder NO-LOCK BY tr_nbr INDEXED-REPOSITION.

  END.
  ELSE IF KEYFUNCTION(LASTKEY) = "cursor-left" OR KEYFUNCTION(LASTKEY) = "cursor-right" THEN
      APPLY LASTKEY.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiPart
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPart cWin
ON ANY-KEY OF fiPart IN FRAME fMain /* 零件号 */
DO:
  IF KEYFUNCTION(LASTKEY) = "RETURN" OR KEYFUNCTION(LASTKEY) = "GO" THEN
  DO:
      ASSIGN fiPart.
      OPEN QUERY brMain FOR EACH qaddb.tr_hist WHERE tr_domain = global_domain and tr_part BEGINS fiPart NO-LOCK  BY tr_part INDEXED-REPOSITION.

  END.
  ELSE IF KEYFUNCTION(LASTKEY) = "cursor-left" OR KEYFUNCTION(LASTKEY) = "cursor-right" THEN
      APPLY LASTKEY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiShip
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiShip cWin
ON ANY-KEY OF fiShip IN FRAME fMain /* 货运单 */
DO:

    IF KEYFUNCTION(LASTKEY) = "RETURN" OR KEYFUNCTION(LASTKEY) = "GO" THEN
    DO:
        ASSIGN fiUser.

        OPEN QUERY brMain FOR EACH qaddb.tr_hist WHERE tr_domain = global_domain and tr_userid BEGINS fiUser NO-LOCK BY tr_userid INDEXED-REPOSITION.

    END.
    ELSE IF KEYFUNCTION(LASTKEY) = "cursor-left" OR KEYFUNCTION(LASTKEY) = "cursor-right" THEN
        APPLY LASTKEY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiSite
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSite cWin
ON ANY-KEY OF fiSite IN FRAME fMain /* 地点 */
DO:

    IF KEYFUNCTION(LASTKEY) = "RETURN" OR KEYFUNCTION(LASTKEY) = "GO" THEN
    DO:
        ASSIGN fiUser.

        OPEN QUERY brMain FOR EACH qaddb.tr_hist WHERE tr_domain = global_domain and tr_userid BEGINS fiUser NO-LOCK BY tr_userid INDEXED-REPOSITION.

    END.
    ELSE IF KEYFUNCTION(LASTKEY) = "cursor-left" OR KEYFUNCTION(LASTKEY) = "cursor-right" THEN
        APPLY LASTKEY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiStart
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiStart cWin
ON ANY-KEY OF fiStart IN FRAME fMain /* 日期 */
DO:

/*   IF KEYFUNCTION(LASTKEY) = "RETURN" OR KEYFUNCTION(LASTKEY) = "GO" THEN                                               */
/*   DO:                                                                                                                  */
/*       ASSIGN fiStart.                                                                                                  */
/*       OPEN QUERY brMain FOR EACH qaddb.tr_hist WHERE tr_domain = global_domain and tr_date >= DATE(fiStart) NO-LOCK  BY tr_date INDEXED-REPOSITION.  */
/*                                                                                                                        */
/*   END.                                                                                                                 */
/*   ELSE IF KEYFUNCTION(LASTKEY) = "cursor-left" OR KEYFUNCTION(LASTKEY) = "cursor-right" THEN                           */
/*       APPLY LASTKEY.                                                                                                   */


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiTrans
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiTrans cWin
ON ANY-KEY OF fiTrans IN FRAME fMain /* 交易号 */
DO:

  IF KEYFUNCTION(LASTKEY) = "RETURN" OR KEYFUNCTION(LASTKEY) = "GO" THEN
  DO:
      ASSIGN fiTrans.
      OPEN QUERY brMain FOR EACH qaddb.tr_hist WHERE tr_domain = global_domain and tr_trnbr >= INT (fiTrans) NO-LOCK  BY tr_trnbr DESC INDEXED-REPOSITION.

  END.
  ELSE IF KEYFUNCTION(LASTKEY) = "cursor-left" OR KEYFUNCTION(LASTKEY) = "cursor-right" THEN
      APPLY LASTKEY.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiType cWin
ON ANY-KEY OF fiType IN FRAME fMain /* 交易类型 */
DO:
    IF KEYFUNCTION(LASTKEY) = "RETURN" OR KEYFUNCTION(LASTKEY) = "GO" THEN
    DO:

      DEFINE VARIABLE hQuery AS WIDGET-HANDLE.
      DEFINE VARIABLE Sqlstr AS CHARACTER.

      ASSIGN fiType.
      ASSIGN rdOrder.

      hQuery = brMain:QUERY.

      Sqlstr = "FOR EACH qaddb.tr_hist ".
      Sqlstr = Sqlstr + "WHERE tr_domain = '" + global_domain + "' and tr_type BEGINS """ + fiType + """ NO-LOCK BY tr_type BY tr_site BY " + rdOrder:SCREEN-VALUE + " DESC INDEXED-REPOSITION ".

      hQuery:QUERY-PREPARE(Sqlstr).
      hQuery:QUERY-OPEN.

    END.
    ELSE IF KEYFUNCTION(LASTKEY) = "cursor-left" OR KEYFUNCTION(LASTKEY) = "cursor-right" THEN
        APPLY LASTKEY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiUser
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiUser cWin
ON ANY-KEY OF fiUser IN FRAME fMain /* 操作员 */
DO:

    IF KEYFUNCTION(LASTKEY) = "RETURN" OR KEYFUNCTION(LASTKEY) = "GO" THEN
    DO:
        ASSIGN fiUser.

        OPEN QUERY brMain FOR EACH qaddb.tr_hist WHERE tr_domain = global_domain and tr_userid BEGINS fiUser NO-LOCK BY tr_userid INDEXED-REPOSITION.

    END.
    ELSE IF KEYFUNCTION(LASTKEY) = "cursor-left" OR KEYFUNCTION(LASTKEY) = "cursor-right" THEN
        APPLY LASTKEY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brMain
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK cWin


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME}
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

SESSION:SET-WAIT-STATE("").

fiStart = TODAY - 30.
fiEnd = TODAY.
fiEffStart = TODAY - 30.
fiEffEnd = TODAY.

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
/* {xxwtitle.i "cWin"}   */
  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Create-Query cWin
PROCEDURE Create-Query :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI cWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(cWin)
  THEN DELETE WIDGET cWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI cWin  _DEFAULT-ENABLE
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
  DISPLAY fiSite fiTrans fiOrder fiPart filot fiType tgDate fiStart fiEnd fiShip
          fiLoc fiAddr fiUser rdOrder tgEffDate fiEffStart fiEffEnd
      WITH FRAME fMain IN WINDOW cWin.
  ENABLE btQry fiSite fiTrans fiOrder fiPart filot fiType btPrint tgDate
         fiStart fiEnd fiShip fiLoc fiAddr fiUser btSum rdOrder tgEffDate
         fiEffStart fiEffEnd brMain
      WITH FRAME fMain IN WINDOW cWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW cWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

