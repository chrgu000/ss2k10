/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song */
/* INV TRANSFER                                                               */
/* Generate date / time  2007-6-8 10:29:06                                    */
/* ------- Barcode 69 拆分前转移-将拆分前的物料批次转移到指定库位             */
define variable sectionid as integer init 0 .
define variable WMESSAGE as char format "x(80)" init "".
define variable wtm_num as char format "x(20)" init "0".
define variable wsection as char format "x(16)".
define variable yn as logical no-undo.
define variable i as integer .
/*SS - 080912.1 B*/
DEFINE VARIABLE vv_loc_oh AS DECIMAL.
DEFINE VARIABLE vv_loc_from as character.
define variable vv_qty as decimal.
define variable vv_ld_stat as character.
define variable VV_Loclist as character.
define variable vtrrecid as recid .
define variable vv_Key1 as character.
{xxtrctrl.i}
/*SS - 080912.1 E*/

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsinv23wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

mainloop:
REPEAT:
     /* CYCLE COUNTER -SECTION ID -- START*/
      sectionid = sectionid + 1 .
     /* SECTION ID -- END  */
xsictr69loop:
repeat:
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
                display "[拆分前转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

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
                display "输入或按E退出"       format "x(40)" skip
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


     /* START  LINE :1100  发票号[ORDER]  */
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

        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1100L .
        /* --CYCLE TIME SKIP -- END  */

                display "[拆分前转移]" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 no-box.

                /* LABEL 1 - START */
                L11001 = "发票号码或发票号码@托号?" .
                display L11001 format "x(40)" skip with fram F1100 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L11002 = "" .
                display L11002 format "x(40)" skip with fram F1100 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L11003 = "" .
                display L11003 format "x(40)" skip with fram F1100 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L11004 = "" .
                display L11004 format "x(40)" skip with fram F1100 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1100 no-box.
          Update V1100
          WITH  fram F1100 NO-LABEL
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
        IF V1100 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1100.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
         if index(v1100,"@") = 0 then  assign v1100 = v1100 + "@".
        /* CHECK FOR NUMBER VARIABLE START  */
         if index(V1100,"@") > 0 then do:
            assign i = 0.
            run isNumber(input trim(entry(2,V1100,"@")),output i).
            if i > 1 then do:
               display skip "托号有误,请重新输入." @ wmessage no-label with fram F1100.
               pause 0 before-hide.
               undo, retry.
            end.
            if i = 0 then do:
               find first xxship_det no-lock where xxship_nbr = trim(entry(1,V1100,"@"))
                     and xxship_case = integer(trim(entry(2,V1100,"@")))
                     and xxship__chr03 = "" no-error.
               if not available xxship_det then do:
                  display skip "仅限日供件,请重新输入1." @ wmessage no-label with fram F1100.
                  pause 0 before-hide.
                  undo, retry.
               end.
            end.
         end. /* if index(V1100,"@") > 0 then do: */
        /* CHECK FOR NUMBER VARIABLE  END */
/*   IF not length( trim ( V1100 ) ) <= 18 THEN DO:                                     */
/*           display skip "长度不能超过18位" @ WMESSAGE NO-LABEL with fram F1100.       */
/*           pause 0 before-hide.                                                       */
/*           undo, retry.                                                               */
/*   end.                                                                               */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
     END.
     if index(V1100,"@") > 0 then
     PV1100 = V1100.
     else
     pv1100 = v1100 + "@".
/* END    LINE :1100  发票号[inv_nbr]  */

/* START  LINE :1110  托号[panel]  */
 V1110L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1110           as char format "x(50)".
        define variable PV1110          as char format "x(50)".
        define variable L11101          as char format "x(40)".
        define variable L11102          as char format "x(40)".
        define variable L11103          as char format "x(40)".
        define variable L11104          as char format "x(40)".
        define variable L11105          as char format "x(40)".
        define variable L11106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1110 = ENTRY(2,V1100,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

                display "[拆分前转移]" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1110 no-box.

                /* LABEL 1 - START */
                L11101 = "托号?" .
                display L11101 format "x(40)" skip with fram F1110 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L11102 = "" .
                display L11102 format "x(40)" skip with fram F1110 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L11103 = "" .
                display L11103 format "x(40)" skip with fram F1110 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L11104 = "" .
                display L11104 format "x(40)" skip with fram F1110 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1110 no-box.
          Update V1110
          WITH  fram F1110 NO-LABEL
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
        IF V1110 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1110.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1110.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        if V1110 = "" then do:
           display skip "托号有误,请重新输入." @ wmessage no-label with fram F1110.
           pause 0 before-hide.
           undo, retry.
        end.
        run isNumber(input V1110,output i).
            if i >= 1 then do:
               display skip "托号有误,请重新输入." @ wmessage no-label with fram F1110.
               pause 0 before-hide.
               undo, retry.
            end.
            find first xxship_det no-lock where xxship_nbr = trim(entry(1,V1100,"@"))
                   and xxship_case = integer(trim(V1110)) no-error.
            if not available xxship_det then do:
                display skip "仅限日供件,请重新输入3." @ wmessage no-label with fram F1110.
                pause 0 before-hide.
                undo, retry.
             end.

        display  "" @ WMESSAGE NO-LABEL with fram F1110.
        pause 0.
        leave V1110L.
     END.
        PV1110 = V1110.
/* END  LINE :1110  托号[panel]  */

/* START  LINE :1120  批号[Lot]  */
 V1120L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1120           as char format "x(50)".
        define variable PV1120          as char format "x(50)".
        define variable L11201          as char format "x(40)".
        define variable L11202          as char format "x(40)".
        define variable L11203          as char format "x(40)".
        define variable L11204          as char format "x(40)".
        define variable L11205          as char format "x(40)".
        define variable L11206          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */
        find first xxship_det no-lock where xxship_nbr =  trim(entry(1,pv1100,"@"))
               and xxship_case = int(trim(PV1110)).
       if available xxship_det then do:
          V1120 = xxship__chr01.
       end.
       else do:
          V1120 = "".
      end.

        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

                display "[拆分前转移]" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1120 no-box.

                /* LABEL 1 - START */
                L11201 = "发票号码@托号:" + trim(entry(1,pv1100,"@")) + "@" + trim(PV1110) .
                display L11201 format "x(40)" skip with fram F1120 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L11202 = "" .
                display L11202 format "x(40)" skip with fram F1120 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L11203 = "" .
                display L11203 format "x(40)" skip with fram F1120 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L11204 = "批号?" .
                display L11204 format "x(40)" skip with fram F1120 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1120 no-box.
          Update V1120
          WITH  fram F1120 NO-LABEL
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
        IF V1120 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1120.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1120.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        IF trim (V1120) = "" THEN DO:
           display skip "批号不可为空!" @ WMESSAGE NO-LABEL with fram F1120.
           pause 0 before-hide.
           undo, retry.
        end.
        find first xxship_det no-lock where xxship_nbr = trim(entry(1,V1100,"@"))
               and xxship_case = integer(trim(V1110)) and xxship__chr03 = "" no-error.
        if available xxship_det then do:
           if xxship__chr01 <> V1120 then do:
              display skip "批号错误,请重新输入." @ wmessage no-label with fram F1120.
              pause 0 before-hide.
              undo, retry.
           end.
        end.
        assign vv_loc_from = "".
        for each xxship_det no-lock where xxship_nbr = trim(entry(1,V1100,"@"))
               and xxship_case = integer(trim(V1110)) and xxship__chr03 = "":
            find first ld_det no-lock use-index ld_part_lot where ld_part = xxship_part2
                   and ld_lot = xxship__chr01 and ld_qty_oh > 0 no-error.
            if available ld_det then do:
               assign vv_loc_from = ld_loc.
               leave.
            end.
         end.
         if vv_loc_from = "" then do:
            display skip "无可用库存,请重新输入." @ wmessage no-label with fram F1120.
            pause 0 before-hide.
            undo, retry.
         end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1120.
        pause 0.
        leave V1120L.
     END.
     PV1120 = V1120.
/* END  LINE :1120  批号[Lot]  */


     /* START  LINE :1130  from_location[从库位]  */
     V1130L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1130           as char format "x(50)".
        define variable PV1130          as char format "x(50)".
        define variable L11301          as char format "x(40)".
        define variable L11302          as char format "x(40)".
        define variable L11303          as char format "x(40)".
        define variable L11304          as char format "x(40)".
        define variable L11305          as char format "x(40)".
        define variable L11306          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


                display "[拆分前转移]" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1130 no-box.

                /* LABEL 1 - START */
                L11301 = "从库位：" + vv_loc_from + "?" .
                assign V1130 = vv_loc_from.
                display L11301 format "x(40)" skip with fram F1130 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L11302 = "发票号码@托号:" + trim(entry(1,pv1100,"@")) + "@" + trim(PV1110) .
                display L11302 format "x(40)" skip with fram F1130 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L11303 = "" .
                display L11303 format "x(40)" skip with fram F1130 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L11304 = "" .
                display L11304 format "x(40)" skip with fram F1130 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1130 no-box.
          Update V1130
          WITH  fram F1130 NO-LABEL
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
        IF V1130 = "e" THEN  LEAVE MAINLOOP.
        display skip WMESSAGE NO-LABEL with fram F1130.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1130.
        pause 0.
         /*  ---- Valid Check ----  START  */
        assign yn = no.
        for each xxship_det no-lock where xxship_nbr = trim(entry(1,V1100,"@"))
               and xxship_case = integer(trim(V1110)) and xxship__chr03 = "":
           find first ld_det no-lock use-index ld_part_lot where ld_part = xxship_part2
                     and ld_lot = xxship__chr01 and ld_site = V1002
                     and ld_loc = trim(v1130) and ld_qty_oh > 0 no-error.
           if available ld_det then do:
              assign yn = yes.
              leave.
           end.
        end.
        if not yn then do:
              display skip "此库位无可用库存,请重新输入." @ wmessage no-label with fram F1130.
              pause 0 before-hide.
              undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1130.
        pause 0.
        leave V1130L.
     END.
/* END    LINE :1130  from_location[从库位]   */


     /* START  LINE :1140  from_location[到库位]  */
     V1140L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1140           as char format "x(50)".
        define variable PV1140          as char format "x(50)".
        define variable L11401          as char format "x(40)".
        define variable L11402          as char format "x(40)".
        define variable L11403          as char format "x(40)".
        define variable L11404          as char format "x(40)".
        define variable L11405          as char format "x(40)".
        define variable L11406          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


                display "[拆分前转移]" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1140 no-box.

                /* LABEL 1 - START */
                L11401 = "到库位?" .
                display L11401 format "x(40)" skip with fram F1140 no-box.
                /* LABEL 1 - END */
                assign VV_Loclist = "".
                run getInvTrLoc(input trim(entry(1,V1100,"@")),input integer(trim(V1110)),output VV_Loclist).

                /* LABEL 2 - START */
                L11402 = VV_Loclist.
                display L11402 format "x(40)" skip with fram F1140 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L11403 = "" .
                display L11403 format "x(40)" skip with fram F1140 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L11404 = "" .
                display L11404 format "x(40)" skip with fram F1140 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1140 no-box.
          Update V1140
          WITH  fram F1140 NO-LABEL
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
        IF V1140 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1140.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1140.
        pause 0.

        find first LOC_MSTR where LOC_SITE = V1002 and LOC_LOC = V1140 and V1140 <> V1130 no-lock no-error.
        IF NOT AVAILABLE LOC_MSTR then do:
               display skip "Error:库位不可用 , Retry." @ WMESSAGE NO-LABEL with fram F1140.
               pause 0 before-hide.
               undo, retry.
        end.

        if can-find(first usrw_wkfl no-lock where usrw_key1 = "TRANSLATE-LOCATION" and usrw_key2 = V1140 and usrw_key3 = "50") then do:
              display skip "Error:不允许调入生产库位, Retry." @ WMESSAGE NO-LABEL with fram F1140.
              pause 0 before-hide.
              undo, retry.
        end.

/**确认目的库位是否允许调拨***********************/
        if lookup(V1140,VV_Loclist,";") = 0 then do:
           yn = no.
           message "库位不在定制范围.Y/N" update yn.
           if not yn then do:
              pause 0 before-hide.
              undo, retry.
           end.
        end.

        display  "" @ WMESSAGE NO-LABEL with fram F1140.
        pause 0.
        leave V1140L.
     END.
/* END    LINE :1140  from_location[到库位]   */

     /* START  LINE :1150  确认[CONFIRM]  */
     V1150L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1150           as char format "x(50)".
        define variable PV1150          as char format "x(50)".
        define variable L11501          as char format "x(40)".
        define variable L11502          as char format "x(40)".
        define variable L11503          as char format "x(40)".
        define variable L11504          as char format "x(40)".
        define variable L11505          as char format "x(40)".
        define variable L11506          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1150 = "Y".
        /* --FIRST TIME DEFAULT  VALUE -- END  */

               display "[拆分前转移]" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1150 no-box.

                /* LABEL 1 - START */
                L11501 = "发票号码@托号:" + trim(entry(1,pv1100,"@")) + "@" + trim(PV1110).
                display L11501          format "x(40)" skip with fram F1150 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L11502 =  "从:" + trim( V1130 ) + "到:" + trim( V1140 ) .
                display L11502          format "x(40)" skip with fram F1150 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L11503 = "".
                display L11503          format "x(40)" skip with fram F1150 no-box.
                /* LABEL 3 - END */

                /* LABEL 4 - START */
                L11504 = "".
                display L11504          format "x(40)" skip with fram F1150 no-box.
                /* LABEL 4 - END */
                display "确认过帐[Y],E退出"   format "x(40)" skip
        skip with fram F1150 no-box.
        Update V1150
        WITH  fram F1150 NO-LABEL
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
        IF V1150 = "e" or v1150 = "n" THEN  LEAVE xsictr69loop.
        display  skip WMESSAGE NO-LABEL with fram F1150.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1150.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */

        display  "" @ WMESSAGE NO-LABEL with fram F1150.
        pause 0.
        leave V1150L.
     END.
     PV1150 = V1150.
     /* END    LINE :1150  确认[CONFIRM]  */

    {xstrshipall.i}

    if yn then do:
        WMESSAGE = "调拨成功".
    end.
    else do:
        WMESSAGE = "调拨失败，请查询资料".
    end.
        /* START  LINE :1160  确认[CONFIRM]  */
     V1160L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1160           as char format "x(50)".
        define variable PV1160          as char format "x(50)".
        define variable L11601          as char format "x(40)".
        define variable L11602          as char format "x(40)".
        define variable L11603          as char format "x(40)".
        define variable L11604          as char format "x(40)".
        define variable L11605          as char format "x(40)".
        define variable L11606          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1160 = "Y".
        /* --FIRST TIME DEFAULT  VALUE -- END  */

               display "[拆分前转移]" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1160 no-box.

                /* LABEL 1 - START */
                L11601 = "发票号码@托号:" + trim(entry(1,pv1100,"@")) + "@" + trim(PV1110).
                display L11601          format "x(40)" skip with fram F1160 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L11602 =  "从:" + trim( V1130 ) + "到:" + trim( V1140 ) .
                display L11602          format "x(40)" skip with fram F1160 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L11603 = "".
                display L11603          format "x(40)" skip with fram F1160 no-box.
                /* LABEL 3 - END */

                /* LABEL 4 - START */
                L11604 = "".
                display L11604          format "x(40)" skip with fram F1160 no-box.
                display  skip WMESSAGE NO-LABEL with fram F1160.
                /* LABEL 4 - END */
                display "继续[Y],E退出"   format "x(40)" skip

        skip with fram F1160 no-box.
        Update V1160
        WITH  fram F1160 NO-LABEL
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
        IF V1160 = "e" THEN  LEAVE xsictr69loop.
        display  skip WMESSAGE NO-LABEL with fram F1160.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1160.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */

        display  "" @ WMESSAGE NO-LABEL with fram F1160.
        pause 0.
        leave V1160L.
     END.
end.
    leave mainloop.
   END.
   pause 0 before-hide.


procedure isNumber:
define input parameter iChkvalue as character.
define output parameter oChkRet as integer.

/* -----------------------------------------------------------
   Purpose: check input value if number type.
   Parameters: oChkRet = 0/PASS ,1/NULL , 2/FALE
   Notes:
 -------------------------------------------------------------*/

assign oChkRet = 0.
define variable i as integer.
  if iChkvalue <> "" then do:
      do i = 1 to length(iChkvalue).
          if index("0987654321", substring(iChkvalue,i,1)) = 0 then do:
             assign oChkRet = 2.
          end.
      end.
  end.
  else do:
      assign oChkRet = 1.
  end.
end procedure.