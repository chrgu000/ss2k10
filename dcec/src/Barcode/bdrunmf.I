&SCOPED-DEFINE mfselprt_i_1 "MFG/PRO 送至分页的终端"
&SCOPED-DEFINE mfselprt_i_2 "输出"
&IF "{&WEB-SELPRT-VARS}" = "" &THEN
 DEFINE VARIABLE l-web-options-ok LIKE mfc_logical NO-UNDO.
 DEFINE VARIABLE i-web-pagesize   AS INTEGER NO-UNDO.
 DEFINE VARIABLE batch_id LIKE bcd_batch.
 /*DEFINE NEW GLOBAL SHARED VAR global_user AS CHAR.*/

  
   


 DEFINE VARIABLE dev AS CHARACTER FORMAT "x(8)"  LABEL {&mfselprt_i_2}  .
  
/*DEF FRAME a
    dev TO 78.5 SPACE(.5) SKIP(.4)

WITH WIDTH 80 SIDE-LABELS THREE-D.
 IF lang = 'en' THEN DO:
 ASSIGN dev:LABEL = 'Output'.
     END.*/
 DEFINE VARIABLE c-web-outopt AS CHARACTER NO-UNDO.


 {wbgp03.i}
 
 &GLOBAL-DEFINE WEB-SELPRT-VARS FALSE
 &ENDIF
 
         define shared variable printdefault like prd_dev.
         define shared variable printdefaultlevel as integer.
         define variable chr_string as character format "X(64)".
         define variable chr_position as integer.
         define variable pagesize as integer.
         define variable path like prd_path.
         define variable spooler like prd_spooler.
         define variable scrollonly like prd_scroll_only.
         define variable printwidth as integer.
         define variable printype as character.
      
         define variable terminal-window as widget-handle.
         define variable save-window as widget-handle.
       
         define variable l-filename as character no-undo.



        
                       
         flag-report-exit = FALSE.
         printwidth = {2}.
         printype = "{1}".
         IF dev = "" OR dev = ? THEN DO:
           IF "{1}" = "terminal" THEN DO:
             IF printdefault = "" OR printdefaultlevel <> 1 THEN dev = "terminal".
             ELSE dev = printdefault.
           END.
           ELSE DO:
             IF printdefault <> "" THEN dev = printdefault.
             ELSE DO:
                IF CAN-FIND(prd_det WHERE prd_dev = "printer") THEN dev = "printer".
                ELSE do:
                  FIND LAST prd_det WHERE prd_path <> "terminal" AND prd_dev <> "terminal" AND prd_path <> "window" AND prd_dev <> "window" NO-LOCK NO-ERROR.
                  IF AVAILABLE prd_det THEN dev = prd_dev.
                  ELSE dev = "printer".
                END.
             END.
           END.
         END.



       /*  IF c-application-mode <> 'WEB':U THEN ASSIGN DEV = GLOBAL_USER.*/
          dev = 'bdlog.txt'.
         /*DISPLAY dev TO 78.5 SPACE(.5) SKIP(.4) WITH FRAME a.*/
         
         selprt:
         DO WITH FRAME a ON ERROR UNDO:
            IF global-beam-me-up THEN UNDO, LEAVE.
           path = dev.
           
           scrollonly = NO.
           FIND prd_det WHERE prd_dev = dev NO-LOCK NO-ERROR.
           IF AVAILABLE prd_det THEN DO:
             IF prd_scroll_only AND "{3}" <> "" THEN DO:
               {mfmsg.i 89 3}
               IF c-application-mode = 'WEB':U THEN RETURN.
               UNDO, RETRY.
             END.
             IF prd_path <> "" THEN path = prd_path.
             scrollonly = prd_scroll_only.
           END.
           ELSE DO:
             IF NOT batchrun THEN DO:
               IF c-application-mode = 'WEB':U THEN DO:
                 RUN get-outopt-field IN h-wblib (INPUT 'FILE':U, OUTPUT l-filename).
               END.
             END.
           END.
           IF (path = "terminal" OR path = "/dev/tty" OR path = "tt:" OR scrollonly) AND "{4}" > "" THEN DO:
             {mfmsg.i 35 3}
             IF c-application-mode = 'WEB':U THEN RETURN.
             UNDO , RETRY.
           END.
         END.
         IF global-beam-me-up THEN UNDO, LEAVE.
 

         STATUS INPUT.
         maxpage = 0.
         pagesize = 66.
         spooler = NO.

         IF AVAILABLE prd_det THEN DO:
           maxpage = prd_max_page.
           pagesize = prd_length.
           spooler = prd_spooler.
         END.

         IF path = "printer" OR OPSYS <> "unix" OR scrollonly THEN spooler = NO.

         IF scrollonly THEN DO:
            path = mfguser + ".out".
            IF SEARCH(path) <> ? THEN DO:
                {gpfildel.i &filename=search(path)}
            END.
         END.
         ELSE IF NOT AVAILABLE prd_det AND path <> "printer" AND path <> "window" AND path <> "terminal" THEN path = path + ".prn".
         
         IF AVAILABLE prd_det AND prd_init_pro <> "" THEN DO:
           IF OPSYS = "unix" THEN UNIX SILENT VALUE(prd_init_pro).
           ELSE IF OPSYS = "msdos" OR OPSYS = "win32" THEN DOS SILENT VALUE(prd_init_pro).
         END.
         ELSE  IF path <> "window" THEN   DO:
           IF "{3}" = "nopage" THEN DO:
             IF spooler THEN OUTPUT {4} THROUGH VALUE(path) PAGE-SIZE 0.
             ELSE OUTPUT {4} TO VALUE(path) {5} PAGE-SIZE 0.
           END.
           ELSE DO:
             IF c-application-mode = 'WEB':U THEN printlength = i-web-pagesize.
             ELSE printlength = pagesize - 6.
             IF spooler THEN DO:
               OUTPUT {4} THROUGH VALUE(path)
               PAGED PAGE-SIZE VALUE(printlength).
             END.
             ELSE DO:

                 IF b_runmfg = 1 THEN DO:
  /*                   OUTPUT {4} TO VALUE(path) {5} PAGED PAGE-SIZE VALUE(printlength).
*/
                 END.
                 ELSE DO:
                    LEAVE.
                 END.
             END.
           END.
         END.

