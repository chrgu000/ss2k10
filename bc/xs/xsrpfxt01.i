{xxrpfx01var.i "new"}

EMPTY TEMP-TABLE ttsod_det.
SET-SIZE(v_mem) = 10.
{xsrpfxt.i}






          vv_sum_ttsod = 0.
          FOR EACH ttsod_det NO-LOCK:
              vv_sum_ttsod = vv_sum_ttsod + 1.
          END.
          IF vv_sum_ttsod / 6 -  TRUNCATE(vv_sum_ttsod / 6,0) > 0 THEN DO:
              vv_sum_ttsod = TRUNCATE(vv_sum_ttsod / 6,0) + 1.
          END.
          ELSE DO:
              vv_sum_ttsod = TRUNCATE(vv_sum_ttsod / 6,0).
          END.

          DO vv_i = 1 TO vv_sum_ttsod:




            vv_filename = "/app/bc/temp/" + "labelfxt" + STRING(TIME) + string(vv_i) + ".l".



            EMPTY TEMP-TABLE ttlbfxt.
            INPUT FROM VALUE("/app/bc/labels/labelfxt01") .
            REPEAT:

                  CREATE ttlbfxt .
                  IMPORT UNFORMATTED ttlbfxt.

            END.
            INPUT CLOSE.



            OUTPUT TO VALUE(vv_filename) APPEND .
            FOR EACH ttlbfxt :
              IF INDEX(ttlbfxt_cmmt,"YYYY") <> 0 THEN DO:
                  FIND FIRST ttsod_det NO-LOCK NO-ERROR.
                  IF AVAIL ttsod_det THEN
                     ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4) + ttsod_year.
              END.

              IF INDEX(ttlbfxt_cmmt,"MM") <> 0 THEN DO:
                  FIND FIRST ttsod_det NO-LOCK NO-ERROR.
                  IF AVAIL ttsod_det THEN
                     ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 2) + ttsod_month.
              END.

              IF INDEX(ttlbfxt_cmmt,"DD") <> 0 THEN DO:
                  FIND FIRST ttsod_det NO-LOCK NO-ERROR.
                  IF AVAIL ttsod_det THEN
                     ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 2) + ttsod_day.
              END.


              IF INDEX(ttlbfxt_cmmt,"%PERIOD%") <> 0 THEN DO:
                  FIND FIRST ttsod_det NO-LOCK NO-ERROR.
                  IF AVAIL ttsod_det THEN
                     ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 8) + ttsod_time + " (P" + STRING(vv_i) + ")".
              END.


              IF INDEX(ttlbfxt_cmmt,"%AFFIRMANT%") <> 0 THEN DO:
                     ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 11) .
              END.

              IF INDEX(ttlbfxt_cmmt,"%PRODUCER%") <> 0 THEN DO:
                     ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 10) .
              END.



              IF INDEX(ttlbfxt_cmmt,"%PN1%") <> 0 THEN DO:
                  FIND FIRST ttsod_det WHERE ttsod_seq = STRING(1 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                  IF AVAIL ttsod_det THEN
                     ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 5) + ttsod_part .
                  ELSE
                     ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 5) .   

              END.

              IF INDEX(ttlbfxt_cmmt,"%QTY1%") <> 0 THEN DO:
                  FIND FIRST ttsod_det WHERE ttsod_seq = STRING(1 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                  IF AVAIL ttsod_det THEN
                     ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 6) + ttsod_qty.
                  ELSE
                     ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 6) .
              END.

              IF INDEX(ttlbfxt_cmmt,"%J1%") <> 0 THEN DO:
                  FIND FIRST ttsod_det WHERE ttsod_seq = STRING(1 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                  IF AVAIL ttsod_det THEN
                     ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4) + ttsod_ck.
                  ELSE
                     ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4) .
              END.

              IF INDEX(ttlbfxt_cmmt,"%R1%") <> 0 THEN DO:
                  FIND FIRST ttsod_det WHERE ttsod_seq = STRING(1 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                  IF AVAIL ttsod_det THEN
                     ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4) + ttsod_rmks.
                  ELSE
                     ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4).
              END.


              
              IF INDEX(ttlbfxt_cmmt,"%PN2%") <> 0 THEN DO:
                   FIND FIRST ttsod_det WHERE ttsod_seq = STRING(2 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                   IF AVAIL ttsod_det THEN
                      ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 5) + ttsod_part.
                   ELSE
                      ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 5) .   

               END.

               IF INDEX(ttlbfxt_cmmt,"%QTY2%") <> 0 THEN DO:
                   FIND FIRST ttsod_det WHERE ttsod_seq = STRING(2 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                   IF AVAIL ttsod_det THEN
                      ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 6) + ttsod_qty.
                   ELSE
                      ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 6) .
               END.

               IF INDEX(ttlbfxt_cmmt,"%J2%") <> 0 THEN DO:
                   FIND FIRST ttsod_det WHERE ttsod_seq = STRING(2 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                   IF AVAIL ttsod_det THEN
                      ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4) + ttsod_ck.
                   ELSE
                      ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4) .
               END.

               IF INDEX(ttlbfxt_cmmt,"%R2%") <> 0 THEN DO:
                   FIND FIRST ttsod_det WHERE ttsod_seq = STRING(2 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                   IF AVAIL ttsod_det THEN
                      ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4) + ttsod_rmks.
                   ELSE
                      ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4).
               END.


               IF INDEX(ttlbfxt_cmmt,"%PN3%") <> 0 THEN DO:
                    FIND FIRST ttsod_det WHERE ttsod_seq = STRING(3 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                    IF AVAIL ttsod_det THEN
                       ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 5) + ttsod_part.
                    ELSE
                       ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 5) .   

                END.

                IF INDEX(ttlbfxt_cmmt,"%QTY3%") <> 0 THEN DO:
                    FIND FIRST ttsod_det WHERE ttsod_seq = STRING(3 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                    IF AVAIL ttsod_det THEN
                       ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 6) + ttsod_qty.
                    ELSE
                       ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 6) .
                END.

                IF INDEX(ttlbfxt_cmmt,"%J3%") <> 0 THEN DO:
                    FIND FIRST ttsod_det WHERE ttsod_seq = STRING(3 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                    IF AVAIL ttsod_det THEN
                       ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4) + ttsod_ck.
                    ELSE
                       ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4) .
                END.

                IF INDEX(ttlbfxt_cmmt,"%R3%") <> 0 THEN DO:
                    FIND FIRST ttsod_det WHERE ttsod_seq = STRING(3 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                    IF AVAIL ttsod_det THEN
                       ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4) + ttsod_rmks.
                    ELSE
                       ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4).
                END.


                IF INDEX(ttlbfxt_cmmt,"%PN4%") <> 0 THEN DO:
                     FIND FIRST ttsod_det WHERE ttsod_seq = STRING(4 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                     IF AVAIL ttsod_det THEN
                        ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 5) + ttsod_part.
                     ELSE
                        ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 5) .   

                 END.

                 IF INDEX(ttlbfxt_cmmt,"%QTY4%") <> 0 THEN DO:
                     FIND FIRST ttsod_det WHERE ttsod_seq = STRING(4 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                     IF AVAIL ttsod_det THEN
                        ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 6) + ttsod_qty.
                     ELSE
                        ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 6) .
                 END.

                 IF INDEX(ttlbfxt_cmmt,"%J4%") <> 0 THEN DO:
                     FIND FIRST ttsod_det WHERE ttsod_seq = STRING(4 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                     IF AVAIL ttsod_det THEN
                        ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4) + ttsod_ck.
                     ELSE
                        ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4) .
                 END.

                 IF INDEX(ttlbfxt_cmmt,"%R4%") <> 0 THEN DO:
                     FIND FIRST ttsod_det WHERE ttsod_seq = STRING(4 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                     IF AVAIL ttsod_det THEN
                        ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4) + ttsod_rmks.
                     ELSE
                        ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4).
                 END.



                 IF INDEX(ttlbfxt_cmmt,"%PN5%") <> 0 THEN DO:
                      FIND FIRST ttsod_det WHERE ttsod_seq = STRING(5 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                      IF AVAIL ttsod_det THEN
                         ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 5) + ttsod_part.
                      ELSE
                         ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 5) .   

                  END.

                  IF INDEX(ttlbfxt_cmmt,"%QTY5%") <> 0 THEN DO:
                      FIND FIRST ttsod_det WHERE ttsod_seq = STRING(5 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                      IF AVAIL ttsod_det THEN
                         ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 6) + ttsod_qty.
                      ELSE
                         ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 6) .
                  END.

                  IF INDEX(ttlbfxt_cmmt,"%J5%") <> 0 THEN DO:
                      FIND FIRST ttsod_det WHERE ttsod_seq = STRING(5 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                      IF AVAIL ttsod_det THEN
                         ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4) + ttsod_ck.
                      ELSE
                         ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4) .
                  END.

                  IF INDEX(ttlbfxt_cmmt,"%R5%") <> 0 THEN DO:
                      FIND FIRST ttsod_det WHERE ttsod_seq = STRING(5 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                      IF AVAIL ttsod_det THEN
                         ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4) + ttsod_rmks.
                      ELSE
                         ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4).
                  END.



                  IF INDEX(ttlbfxt_cmmt,"%PN6%") <> 0 THEN DO:
                       FIND FIRST ttsod_det WHERE ttsod_seq = STRING(6 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                       IF AVAIL ttsod_det THEN
                          ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 5) + ttsod_part.
                       ELSE
                          ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 5) .   

                   END.

                   IF INDEX(ttlbfxt_cmmt,"%QTY6%") <> 0 THEN DO:
                       FIND FIRST ttsod_det WHERE ttsod_seq = STRING(6 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                       IF AVAIL ttsod_det THEN
                          ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 6) + ttsod_qty.
                       ELSE
                          ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 6) .
                   END.

                   IF INDEX(ttlbfxt_cmmt,"%J6%") <> 0 THEN DO:
                       FIND FIRST ttsod_det WHERE ttsod_seq = STRING(6 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                       IF AVAIL ttsod_det THEN
                          ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4) + ttsod_ck.
                       ELSE
                          ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4) .
                   END.

                   IF INDEX(ttlbfxt_cmmt,"%R6%") <> 0 THEN DO:
                       FIND FIRST ttsod_det WHERE ttsod_seq = STRING(6 + 6 * (vv_i - 1)) NO-LOCK NO-ERROR.
                       IF AVAIL ttsod_det THEN
                          ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4) + ttsod_rmks.
                       ELSE
                          ttlbfxt_cmmt = SUBSTRING(ttlbfxt_cmmt,1,LENGTH(ttlbfxt_cmmt) - 4).
                   END.

                 PUT UNFORMATTED  ttlbfxt_cmmt SKIP.

            END. /*for each ttlbfxt*/
            OUTPUT CLOSE .

            OUTPUT TO VALUE(vv_FILENAME) BINARY NO-CONVERT APPEND.
                INPUT FROM VALUE("/app/bc/labels/labelfxt02") BINARY NO-CONVERT APPEND.
                REPEAT:
                    IMPORT v_mem.
                    EXPORT v_mem.
                END.
                INPUT CLOSE.
           OUTPUT CLOSE.



            unix silent value ("chmod 777  " + trim(vv_FILENAME)).
            /*
            unix silent value ("lp -d xs " + " " + trim(vv_filename)).
            */

            unix silent value ( trim(prd_path) + " " + trim(vv_filename)).


            unix silent value ( trim(prd_path) + " " + trim(vv_filename)).

            unix silent value ("clear").


        END.

