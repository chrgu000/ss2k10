 DEF VAR h AS INT.
 DEF VAR mdb AS CHAR FORMAT 'x(15)'.
 DO h = 1 TO NUM-DBS:
          IF LDBNAME(h) BEGINS 'qadbar'  THEN do:
              mdb = PDBNAME(LDBNAME(h)).
              LEAVE.
          END.
      END.
      IF mdb = '' THEN DO:
          MESSAGE '条码数据库逻辑名必须以qadbar开头!' VIEW-AS ALERT-BOX ERROR.
          QUIT.
          END.
          DO WHILE INDEX(mdb,'\') <> 0 OR INDEX(mdb,'/') <> 0:
            IF INDEX(mdb,'\') <> 0 THEN  mdb =  SUBSTR(mdb,INDEX(mdb,'\') + 1).
                  ELSE mdb = SUBSTR(mdb,INDEX(mdb,'/') + 1).

                   END.
                   IF INDEX(mdb,'.') <> 0 THEN mdb = SUBSTR(mdb,1,INDEX(mdb,'.') - 1).
DEFINE VAR C-Win AS WIDGET-HANDLE .
 
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "条码系统-" + mdb 
          HEIGHT-CHARS             = 17
         WIDTH-CHARS            =  30
       /*  MAX-HEIGHT         = 17
         MAX-WIDTH          = 30
         VIRTUAL-HEIGHT     = 120
         VIRTUAL-WIDTH      = 133     */
         /*RESIZE             = YES*/
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = NO
         THREE-D            = yes
         MESSAGE-AREA       = NO
         SENSITIVE          = yes.


ASSIGN CURRENT-WINDOW                = c-win
       THIS-PROCEDURE:CURRENT-WINDOW = c-win.
C-Win:HIDDEN = no.
/*
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
CREATE WIDGET-POOL.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 
&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no
&Scoped-define FRAME-NAME DEFAULT-FRAME
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PROCEDURE-SETTINGS

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "global_title"
         x                  = 1
         y                  = 1
         HEIGHT             = 16
         WIDTH              = 30
         MAX-HEIGHT         = 20
         MAX-WIDTH          = 30
         VIRTUAL-HEIGHT     = 120
         VIRTUAL-WIDTH      = 133
         RESIZE             = yes
         MIN-BUTTON         = no
         MAX-BUTTON         = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&ANALYZE-RESUME



&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.
VIEW c-win.
ASSIGN CURRENT-WINDOW                = c-win
       THIS-PROCEDURE:CURRENT-WINDOW = c-win.
VIEW c-win.
&ANALYZE-RESUME
*/
