/* ss - 110813.1 by: jack */
/* ss - 111213.1 by: jack */  /* $u for so_job */
/* sales ord label */
define variable sectionid as integer init 0 .
define variable WMESSAGE  as char format "x(80)" init "".
define variable wtm_num   as char format "x(20)" init "0".
define variable wtm_fm    as char format "x(16)".
define variable wsection as char format "x(16)".
define variable i as integer .

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xspor01wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

mainloop:
REPEAT:
     /* CYCLE COUNTER -SECTION ID -- START*/
      sectionid = sectionid + 1 .
     /* SECTION ID -- END  */

      
     /* START  LINE :1002  地点[SITE]  */
     V1002L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1002           as char format "x(50)".
        define variable PV1002          as char format "x(50)".
        define variable L10021          as char format "x(40)".
        define variable L10022          as char format "x(40)".
        define variable L10023          as char format "x(40)".
        define variable L10024          as char format "x(40)".
        define variable L10025          as char format "x(40)".
        define variable L10026          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        {xsdfsite.i}  
       
        V1002 = wDefSite.
        V1002 = ENTRY(1,V1002,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1002 = ENTRY(1,V1002,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF aPASS = "Y" then
        leave V1002L.
        /* LOGICAL SKIP END */
                display "[销售工单标签]" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

                /* LABEL 1 - START */ 
                L10021 = "地点设定有误" .
                display L10021          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L10022 = "1.没有设定默认地点" .
                display L10022          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L10023 = "2.权限设定有误" .
                display L10023          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L10024 = "  请查核" .
                display L10024          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1002 no-box.
        Update V1002
        WITH  fram F1002 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* PRESS e EXIST CYCLE */
        IF V1002 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1002.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1002.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not trim(V1002) = "E" THEN DO:
                display skip "Error , Retry " @ WMESSAGE NO-LABEL with fram F1002.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1002.
        pause 0.
        leave V1002L.
     END.
     PV1002 = V1002.

    
     /* END    LINE :1002  地点[SITE]  */


   /* Additional Labels Format */
     /* START  LINE :1100  wo_nbr */
     V1100L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1100           as char format "x(50)".
        define variable PV1100          as char format "x(50)".
        define variable L11001          as char format "x(40)".
        define variable L11002          as char format "x(40)".
        define variable L11003          as char format "x(40)".
        define variable L11004          as char format "x(40)".
        define variable L11005          as char format "x(40)".
        define variable L11006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1100 = PV1100 .
        V1100 = ENTRY(1,V1100,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售工单标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 no-box.

                /* LABEL 1 - START */ 
                L11001 = "工单号码" .
                display L11001          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11002 = "" . 
                display L11002          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11003 = "" . 
                display L11003          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11004 = "" . 
                display L11004          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1100 no-box.
        Update V1100
        WITH  fram F1100 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1100.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(wo_mstr) = ? THEN find first wo_mstr where 
                              wo_status = "r" AND (WO_SITE = "" OR WO_SITE = V1002) AND  
                              WO_NBR >=  INPUT V1100
                               no-lock no-error.
                  ELSE find next wo_mstr where 
                              WO_STATUS = "r" AND  (wo_SITE = "" OR wo_SITE = V1002)  
                               no-lock no-error.
                  IF AVAILABLE wo_mstr then display skip 
            wo_NBR @ V1100 trim( wo_NBR ) + "/" + trim( wo_VEND ) @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(wo_mstr) = ? THEN find first wo_mstr where 
                              wo_status = "r" AND (WO_SITE = "" OR WO_SITE = V1002) AND  
            wo_NBR <=  INPUT V1100
                               no-lock no-error.
                  ELSE find prev wo_mstr where 
                               wo_status = "r" AND (WO_SITE = "" OR WO_SITE = V1002) 
                               no-lock no-error.
                  IF AVAILABLE wo_mstr then display skip 
            wo_NBR @ V1100 trim( wo_NBR )  @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1100 = "e" THEN DO: 
           
            LEAVE MAINLOOP.
        END.
        display  skip WMESSAGE NO-LABEL with fram F1100.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first wo_mstr where wo_NBR = V1100 AND wo_status = "r" AND  ( wo_SITE = "" OR wo_SITE = V1002 )  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE wo_mstr then do:
                display skip "无效或被锁!" @ WMESSAGE NO-LABEL with fram F1100.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
     END.
     PV1100 = V1100.
     /* END    LINE :1100  wo_nbr  */


   /* Additional Labels Format */
     /* START  LINE :1101  wo_part  */
     V1101L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1101           as char format "x(50)".
        define variable PV1101          as char format "x(50)".
        define variable L11011          as char format "x(40)".
        define variable L11012          as char format "x(40)".
        define variable L11013          as char format "x(40)".
        define variable L11014          as char format "x(40)".
        define variable L11015          as char format "x(40)".
        define variable L11016          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first wo_mstr where wo_nbr = V1100  no-lock no-error.
If AVAILABLE (wo_mstr) then
        V1101 = trim( wo_part ).
/*         V1101 = ENTRY(1,V1101,"@"). */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


/*         /* --CYCLE TIME DEFAULT  VALUE -- START  */ */
/*         V1101 = ENTRY(1,V1101,"@").                 */
/*         /* --CYCLE TIME DEFAULT  VALUE -- END  */   */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

       

        

                display "[销售工单标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1101 no-box.

                /* LABEL 1 - START */ 
                  L11011 = "料品" . 
                display L11011          format "x(40)" skip with fram F1101 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11012 = "" . 
                display L11012          format "x(40)" skip with fram F1101 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11013 = "" . 
                display L11013          format "x(40)" skip with fram F1101 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11014 = "" . 
                display L11014          format "x(40)" skip with fram F1101 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1101 no-box.
        /* DISPLAY ONLY */
        define variable X1101           as char format "x(40)".
        X1101 = V1101.
      
        /* DISPLAY ONLY */
        Update V1101
        WITH  fram F1101 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end. 

      
           apply lastkey.
        end.
       
       
    
        /* PRESS e EXIST CYCLE */
        IF V1101 = "e" THEN DO:
          
            LEAVE MAINLOOP.
        END.
        display  skip WMESSAGE NO-LABEL with fram F1101.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1101.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1101.
        pause 0.
        leave V1101L.
     END.
     PV1101 = V1101.
     /* END    LINE :1101  粒划启  */


   /* Additional Labels Format */
     /* START  LINE :1102  so_nbr //wo_so_job  */
     V1102L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1102           as char format "x(50)".
        define variable PV1102          as char format "x(50)".
        define variable L11021          as char format "x(40)".
        define variable L11022          as char format "x(40)".
        define variable L11023          as char format "x(40)".
        define variable L11024          as char format "x(40)".
        define variable L11025          as char format "x(40)".
        define variable L11026          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */
        /* ss - 111213.1 -b */
        DEFINE VAR v1103 LIKE so_po .
        
        /* ss - 111213.1 -e */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
      FIND FIRST wo_mstr WHERE wo_nbr = v1100 NO-LOCK NO-ERROR .
      IF AVAILABLE wo_mstr THEN
        V1102 = SUBSTRING(wo_so_job,1,LENGTH(wo_so_job) - 1 ).
      ELSE 
          v1102 = "" .
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1102 = ENTRY(1,V1102,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

       


        

                display "[销售工单标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1102 no-box.

                /* LABEL 1 - START */ 
                  L11021 = "销售订单" . 
                display L11021          format "x(40)" skip with fram F1102 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11022 = "" . 
                display L11022          format "x(40)" skip with fram F1102 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11023 = "" . 
                display L11023          format "x(40)" skip with fram F1102 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11024 = "" . 
                display L11024          format "x(40)" skip with fram F1102 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1102 no-box.
        /* DISPLAY ONLY */
        define variable X1102           as char format "x(40)".
        X1102 = V1102.
        
        /* DISPLAY ONLY */
        Update V1102
        WITH  fram F1102 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
/*         V1102 = X1102. */
       
        FIND FIRST so_mstr WHERE so_nbr = v1102 NO-LOCK NO-ERROR .
        IF NOT AVAILABLE so_mstr THEN DO:

              display skip "not so_nbr  " @ WMESSAGE NO-LABEL with fram F1102.
                pause 0 before-hide.
                undo, retry.

        END.

        /* ss - 111213.1 -b */
        v1103 = so_po .
        /* ss - 111213.1 -e */

        /* PRESS e EXIST CYCLE */
        IF V1102 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1102.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1102.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1102.
        pause 0.
        leave V1102L.
     END.
     PV1102 = V1102.
     /* END    LINE :1102  so_nbr */


  


   /* Additional Labels Format */
     /* START  LINE :1203  date */
     V1203L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1203           as char format "x(50)".
        define variable PV1203          as char format "x(50)".
        define variable L12031          as char format "x(40)".
        define variable L12032          as char format "x(40)".
        define variable L12033          as char format "x(40)".
        define variable L12034          as char format "x(40)".
        define variable L12035          as char format "x(40)".
        define variable L12036          as char format "x(40)".
        define variable D1203           as date .
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1203 = string ( today ).
        D1203 = Date ( V1203).
        V1203 = ENTRY(1,V1203,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


       
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售工单标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1203 no-box.

                /* LABEL 1 - START */ 
                L12031 = "日期?" .
                display L12031          format "x(40)" skip with fram F1203 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L12032 = string ( today ) .
                display L12032          format "x(40)" skip with fram F1203 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L12033 = "" . 
                display L12033          format "x(40)" skip with fram F1203 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L12034 = "" . 
                display L12034          format "x(40)" skip with fram F1203 no-box.
                /* LABEL 4 - END */ 
                display "输入 "      format "x(40)" skip
        skip with fram F1203 no-box.
        Update D1203
        WITH  fram F1203 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* PRESS e EXIST CYCLE */
        IF V1203 = "e" THEN  LEAVE MAINLOOP.
        V1203 = string ( D1203).
        display  skip WMESSAGE NO-LABEL with fram F1203.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1203.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1203.
        pause 0.
        leave V1203L.
     END.
     PV1203 = V1203.
     /* END    LINE :1203  date  */


   /* Additional Labels Format */
   /* Internal Cycle Input :1205    */
  
     /* START  LINE :1205  rev */
     V1205L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1205           as char format "x(50)".
        define variable PV1205          as char format "x(50)".
        define variable L12051          as char format "x(40)".
        define variable L12052          as char format "x(40)".
        define variable L12053          as char format "x(40)".
        define variable L12054          as char format "x(40)".
        define variable L12055          as char format "x(40)".
        define variable L12056          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        FIND FIRST pt_mstr WHERE pt_part = v1101 NO-LOCK NO-ERROR .
        IF AVAILABLE pt_mstr THEN
        V1205 = pt_rev.
        ELSE
            v1205 = "" .
        V1205 = ENTRY(1,V1205,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1205 = ENTRY(1,V1205,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
       
        /* LOGICAL SKIP END */
                display "[销售工单标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1205 no-box.

                /* LABEL 1 - START */ 
                L12051 = "版本" .
                display L12051          format "x(40)" skip with fram F1205 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L12052 = "" . 
                display L12052          format "x(40)" skip with fram F1205 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L12053 = "" . 
                display L12053          format "x(40)" skip with fram F1205 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L12054 = "" . 
                display L12054          format "x(40)" skip with fram F1205 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1205 no-box.
        Update V1205
        WITH  fram F1205 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
         
           apply lastkey.
       
        END.

        display skip "^" @ WMESSAGE NO-LABEL with fram F1205.
          


        /* PRESS e EXIST CYCLE */
        /* **SKIP TO MAIN LOOP START** */
        IF V1205 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        display  skip WMESSAGE NO-LABEL with fram F1205.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1205.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
       

        display  "" @ WMESSAGE NO-LABEL with fram F1205.
        pause 0.
        leave V1205L.
     END.
     PV1205 = V1205.
     /* END    LINE :1205  pt_rev  */

     
     

   /* Additional Labels Format */
     /* START  LINE :1300  prodline */
     V1300L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1300           as char format "x(50)".
        define variable PV1300          as char format "x(50)".
        define variable L13001          as char format "x(40)".
        define variable L13002          as char format "x(40)".
        define variable L13003          as char format "x(40)".
        define variable L13004          as char format "x(40)".
        define variable L13005          as char format "x(40)".
        define variable L13006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


       


        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售工单标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 no-box.

                /* LABEL 1 - START */ 

                  /* LABEL 1 - START */ 
                l13001 = "生产线" .
                display l13001          format "x(40)" skip with fram f1300 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  l13002 = "" . 
                display l13002          format "x(40)" skip with fram f1300 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  l13003 = "" . 
                display l13003          format "x(40)" skip with fram f1300 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  l13004 = "" . 
                display l13004          format "x(40)" skip with fram f1300 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram f1300 no-box.

              

        V1300 = "".
        /* DISPLAY ONLY */
        Update V1300
        WITH  fram F1300 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        

        FIND FIRST CODE_mstr WHERE CODE_fldname = "barcodefgline" AND CODE_value = v1300 NO-LOCK NO-ERROR .
        IF NOT AVAILABLE CODE_mstr  THEN DO:

              display skip "错误,重试." @ WMESSAGE NO-LABEL with fram f1300.
                pause 0 before-hide.
                undo, retry.

        END.
        ELSE DO:
            l13002 = CODE_cmmt .
             display l13002          format "x(40)" skip with fram f1300 no-box.
        END.

        /* PRESS e EXIST CYCLE */
        IF V1300 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1300.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        leave V1300L.
     END.
    
     PV1300 = V1300.
  
     /* END    LINE :1300 prod_line  */


   /* Additional Labels Format */
     /* START  LINE :1301  shift  */
     V1301L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1301           as char format "x(50)".
        define variable PV1301          as char format "x(50)".
        define variable L13011          as char format "x(40)".
        define variable L13012          as char format "x(40)".
        define variable L13013          as char format "x(40)".
        define variable L13014          as char format "x(40)".
        define variable L13015          as char format "x(40)".
        define variable L13016          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
       


      

                display "[销售工单标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1301 no-box.

                /* LABEL 1 - START */ 
                  L13011 = "班次" . 
                display L13011          format "x(40)" skip with fram F1301 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13012 = "D - 为日班" . 
                display L13012          format "x(40)" skip with fram F1301 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13013 = "N - 为夜班 " . 
                display L13013          format "x(40)" skip with fram F1301 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13014 = "" . 
                display L13014          format "x(40)" skip with fram F1301 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1301 no-box.
        /* DISPLAY ONLY */
        define variable X1301           as char format "x(40)".
      
        /* DISPLAY ONLY */
        Update V1301
        WITH  fram F1301 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
       
        IF INDEX("d,n",v1301) = 0 THEN DO:

            display skip "错误,重试." @ WMESSAGE NO-LABEL with fram F1301.
              pause 0 before-hide.
              undo, retry.


        END.

        /* PRESS e EXIST CYCLE */
        IF V1301 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1301.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1301.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1301.
        pause 0.
        leave V1301L.
     END.
     PV1301 = V1301.
     /* END    LINE :1301  Supplier  */





  
/*    /* Internal Cycle Input :9110    */ */
/*    V9110LMAINLOOP:                     */
/*    REPEAT:                          110813.1 -b   */
   /*Logical Enter Cycle9110    */
/*    IF NOT (V9010 = "Y" AND V1700 = "Y" ) THEN LEAVE V9110LMAINLOOP. */
     /* START  LINE :9110  沭钨奻杅讲[QTY ON LABEL] AUTO  */
     V9110L:   /* qty */
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9110           as char format "x(50)".
        define variable PV9110          as char format "x(50)".
        define variable L91101          as char format "x(40)".
        define variable L91102          as char format "x(40)".
        define variable L91103          as char format "x(40)".
        define variable L91104          as char format "x(40)".
        define variable L91105          as char format "x(40)".
        define variable L91106          as char format "x(40)".
        DEFINE VAR V1500 AS CHAR . /* lot */
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
       
        /* --FIRST TIME DEFAULT  VALUE -- END  */


      
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售工单标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9110 no-box.

                /* LABEL 1 - START */ 
                find first pt_mstr where pt_part = V1101  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L91101 = pt_um + ": 标签数量?" .
                else L91101 = "" . 
                display L91101          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91102 = "料品:" + trim( V1101 ) .
                display L91102          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L91103 = "描述" + Trim(pt_desc1) .
                display L91103          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
               
                L91104 = "批号:" + STRING(v1205) + SUBstring( STRING(YEAR(D1203) ),3) + STRING(MONTH(D1203),"99")
                     + STRING(DAY(D1203),"99") + STRING(v1300) + STRING(v1301). /* lot */
                v1500 = STRING(v1205) + SUBstring( STRING(YEAR(D1203) ),3) + STRING(MONTH(D1203),"99")
                     + STRING(DAY(D1203),"99") + STRING(v1300) + STRING(v1301) .
               
                display L91104          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F9110 no-box.
        Update V9110
        WITH  fram F9110 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* PRESS e EXIST CYCLE */
        IF V9110 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9110.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9110.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V9110 = "" OR V9110 = "-" OR V9110 = "." OR V9110 = ".-" OR V9110 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F9110.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V9110).
                If index("0987654321.-", substring(V9110,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F9110.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not V9110 <> "0" THEN DO:
                display skip "Error , Retry " @ WMESSAGE NO-LABEL with fram F9110.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9110.
        pause 0.
        leave V9110L.
     END.
     PV9110 = V9110.
     /* END    LINE :9110  沭钨奻杅讲[QTY ON LABEL] AUTO  */


   /* Additional Labels Format */
     /* START  LINE :9120  沭钨跺杅[No Of Label] AUTO  */
     V9120L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9120           as char format "x(50)".
        define variable PV9120          as char format "x(50)".
        define variable L91201          as char format "x(40)".
        define variable L91202          as char format "x(40)".
        define variable L91203          as char format "x(40)".
        define variable L91204          as char format "x(40)".
        define variable L91205          as char format "x(40)".
        define variable L91206          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9120 = "1".
        V9120 = ENTRY(1,V9120,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9120 = ENTRY(1,V9120,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售工单标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9120 no-box.

                /* LABEL 1 - START */ 
                L91201 = "标签个数?" .
                display L91201          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91202 = "料品:" + trim( V1101 ) .
                display L91202          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L91203 = "批号:" + Trim(V1500) .
                display L91203          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L91204 = "" . 
                display L91204          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F9120 no-box.
        Update V9120
        WITH  fram F9120 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* PRESS e EXIST CYCLE */
        IF V9120 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9120.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9120.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V9120 = "" OR V9120 = "-" OR V9120 = "." OR V9120 = ".-" OR V9120 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F9120.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V9120).
                If index("0987654321.-", substring(V9120,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F9120.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9120.
        pause 0.
        leave V9120L.
     END.
     PV9120 = V9120.
     /* END    LINE :9120  沭钨跺杅[No Of Label] AUTO  */


   wtm_num = V9120.
   /* Additional Labels Format */
     /* START  LINE :9130  湖荂侬[Printer]  */
     V9130L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9130           as char format "x(50)".
        define variable PV9130          as char format "x(50)".
        define variable L91301          as char format "x(40)".
        define variable L91302          as char format "x(40)".
        define variable L91303          as char format "x(40)".
        define variable L91304          as char format "x(40)".
        define variable L91305          as char format "x(40)".
        define variable L91306          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first upd_det where upd_nbr = "por01" and upd_select = 99 no-lock no-error.
If AVAILABLE ( upd_det ) then
        V9130 = UPD_DEV.
        V9130 = ENTRY(1,V9130,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9130 = ENTRY(1,V9130,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF 1 <> 1 THEN
        leave V9130L.
        /* LOGICAL SKIP END */
                display "[销售工单标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9130 no-box.

                /* LABEL 1 - START */ 
                L91301 = "打印机?" .
                display L91301          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91302 = "条码上数量:" + trim ( V9110 ) .
                display L91302          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L91303 = "条码个数:" + trim ( V9120) .
                display L91303          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L91304 = "" . 
                display L91304          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F9130 no-box.
        Update V9130
        WITH  fram F9130 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F9130.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find first PRD_DET where 
                              PRD_DEV >=  INPUT V9130
                               no-lock no-error.
                  ELSE find next PRD_DET where 
                               no-lock no-error.
                  IF AVAILABLE PRD_DET then display skip 
            PRD_DEV @ V9130 PRD_DESC @ WMESSAGE NO-LABEL with fram F9130.
                  else   display skip "" @ WMESSAGE with fram F9130.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find first PRD_DET where 
            PRD_DEV <=  INPUT V9130
                               no-lock no-error.
                  ELSE find prev PRD_DET where 
                               no-lock no-error.
                  IF AVAILABLE PRD_DET then display skip 
            PRD_DEV @ V9130 PRD_DESC @ WMESSAGE NO-LABEL with fram F9130.
                  else   display skip "" @ WMESSAGE with fram F9130.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V9130 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9130.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9130.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first PRD_DET where PRD_DEV = V9130  no-lock no-error.
        IF NOT AVAILABLE PRD_DET then do:
                display skip "打印机有误 " @ WMESSAGE NO-LABEL with fram F9130.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9130.
        pause 0.
        leave V9130L.
     END.
     PV9130 = V9130.
     /* END    LINE :9130  湖荂侬[Printer]  */

     


   /* Additional Labels Format */
     Define variable ts9130 AS CHARACTER FORMAT "x(100)".
     Define variable av9130 AS CHARACTER FORMAT "x(100)".
     PROCEDURE por019130l.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/mfgpro/rf/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then 
        LabelsPath = LabelsPath + "/".
        /* Define Labels Path  END */
     INPUT FROM VALUE(LabelsPath + "sor001" + trim ( wtm_fm ) ).
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value(  trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9130.
       
/*         av9130 = v1205.  /* pt_rev */                                                                                            */
/*        IF INDEX(ts9130,"&E") <> 0  THEN DO:                                                                                      */
/*        TS9130 = substring(TS9130, 1, Index(TS9130 , "&E") - 1) + av9130                                                          */
/*        + SUBSTRING( ts9130 , index(ts9130 ,"&E") + length("&E"), LENGTH(ts9130) - ( index(ts9130 ,"&E" ) + length("&E") - 1 ) ). */
/*        END.                                                                                                                      */

       find first pt_mstr where pt_part = v1101  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = trim(pt_desc1).
       IF INDEX(ts9130,"$E") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$E") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$E") + length("$E"), LENGTH(ts9130) - ( index(ts9130 ,"$E" ) + length("$E") - 1 ) ).
       END.
/*         av9130 = v9110. /* qty */                                                                                                */
/*        IF INDEX(ts9130,"$O") <> 0  THEN DO:                                                                                      */
/*        TS9130 = substring(TS9130, 1, Index(TS9130 , "$O") - 1) + av9130                                                          */
/*        + SUBSTRING( ts9130 , index(ts9130 ,"$O") + length("$O"), LENGTH(ts9130) - ( index(ts9130 ,"$O" ) + length("$O") - 1 ) ). */
/*        END.      
                                                                                                                
                                                                                                                */
       /* 10 barcode */ 
       av9130 = trim(v1101) + "@" + trim(V1203).
       IF INDEX(ts9130,"&B") <> 0  THEN DO:
           
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&B") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"&B") + length("&B"), LENGTH(ts9130) - ( index(ts9130 ,"&B" ) + length("&B") - 1 ) ).

      

       END.

       /* cust part */
       FIND FIRST so_mstr WHERE so_nbr = v1102 NO-LOCK NO-ERROR .
       IF AVAILABLE so_mstr  THEN DO:
           FIND FIRST cp_mstr WHERE cp_cust = so_cust AND cp_part = v1101 NO-LOCK NO-ERROR .
           IF AVAILABLE cp_mstr  THEN
               av9130 = TRIM(cp_cust_part) .
           ELSE
               av9130 = "" .
       END.
        ELSE
               av9130 = "" .
      
       IF INDEX(ts9130,"$F") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$F") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$F") + length("$F"), LENGTH(ts9130) - ( index(ts9130 ,"$F" ) + length("$F") - 1 ) ).
       END.
        /* cust part */
    
        av9130 = v1101.  /* wo_part */
       IF INDEX(ts9130,"$P") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$P") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$P") + length("$P"), LENGTH(ts9130) - ( index(ts9130 ,"$P" ) + length("$P") - 1 ) ).
       END.


        av9130 = V9110.
       IF INDEX(ts9130,"$Q") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$Q") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$Q") + length("$Q"), LENGTH(ts9130) - ( index(ts9130 ,"$Q" ) + length("$Q") - 1 ) ).
       END.

        av9130 = V1500.
       IF INDEX(ts9130,"$L") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$L") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$L") + length("$L"), LENGTH(ts9130) - ( index(ts9130 ,"$L" ) + length("$L") - 1 ) ).
       END.

       /* so_po */
       
       /* ss - 111213.1 -b
        av9130 = v1102.
        ss - 111213.1 -e */
       /* ss - 111213.1 -b */
       av9130 = v1103.
       /* ss - 111213.1 -e */
       IF INDEX(ts9130,"$U") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$U") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$U") + length("$U"), LENGTH(ts9130) - ( index(ts9130 ,"$U" ) + length("$U") - 1 ) ).
       END.

       /* date */
        av9130 = v1203.
       IF INDEX(ts9130,"$D") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$D") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$D") + length("$D"), LENGTH(ts9130) - ( index(ts9130 ,"$D" ) + length("$D") - 1 ) ).
       END.


/*         av9130 = if length( trim ( V1500 ) ) >= 8 then substring ( trim ( V1500 ),7,2) else "00".                                */
/*        IF INDEX(ts9130,"&M") <> 0  THEN DO:                                                                                      */
/*        TS9130 = substring(TS9130, 1, Index(TS9130 , "&M") - 1) + av9130                                                          */
/*        + SUBSTRING( ts9130 , index(ts9130 ,"&M") + length("&M"), LENGTH(ts9130) - ( index(ts9130 ,"&M" ) + length("&M") - 1 ) ). */
/*        END.                                                                                                                      */
/*                                                                                                                                  */
/*        find first pt_mstr where pt_part = v1101  no-lock no-error.                                                               */
/* If AVAILABLE ( pt_mstr )  then                                                                                                   */
/*         av9130 = if pt_avg_int <> 0 and pt_avg_int <> 90 then "保质期:" + trim ( string ( pt_avg_int ) ) + "月" else "".         */
/*        IF INDEX(ts9130,"&D") <> 0  THEN DO:                                                                                      */
/*        TS9130 = substring(TS9130, 1, Index(TS9130 , "&D") - 1) + av9130                                                          */
/*        + SUBSTRING( ts9130 , index(ts9130 ,"&D") + length("&D"), LENGTH(ts9130) - ( index(ts9130 ,"&D" ) + length("&D") - 1 ) ). */
/*        END.                                                                                                                      */


       put unformatted ts9130 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.


     run por019130l.
     
    
     do i = 1 to integer(wtm_num):
       find first PRD_DET where PRD_DEV = V9130 no-lock no-error.
       IF AVAILABLE PRD_DET then do:
         unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
       end.
     End.
   /* Internal Cycle END :9130    */
   


/*    END. 110813.1 -b*/
   pause 0 before-hide.
end.
