/* xxrepkup0.i - REPETITIVE PICK LIST HARD ALLOCATIONS                    */
/*V8:ConvertMode=Maintenance                                              */

define variable isite like si_site.
define variable isite1 like si_site.
define variable iDate as date.
define variable iDate1 as date.
define variable iline like ln_line.
define variable iline1 like ln_line.

define variable vtime   as decimal.
define variable vtime1  as decimal.

DEFINE VARIABLE recno   AS RECID.

/************************
for each rps_mstr no-lock where rps_line = "HPS" and rps_rel_date = today,
   each lnd_det where lnd_line = rps_line and lnd_site = rps_site and
        lnd_part = rps_part:
display rps_rel_date rps_part rps_qty_req rps_user1 lnd_rate rps_qty_req / lnd_rate
column-label "times".
end.

|Item Number        Qty Scheduled Ufld1          lnd_rate      times|
|MHSLG3-0N1-1-CK            160.0 1                 85.71       1.87|
|MHTB03-0N1-1-CK            775.0 4                 85.71       9.04|
|MHTB03-N50-1-CK             65.0 6                 85.71       0.76|



for each xxlnw_det no-lock where xxlnw_line = "HPS" and xxlnw_on:
display xxlnw_sn xxlnw_start xxlnw_stime xxlnw_end xxlnw_wktime.
end.


****************************/

DEFINE TEMP-TABLE tmp_file0
    FIELDS t0_date   LIKE rps_rel_date
    FIELDS t0_record LIKE rps_record
    FIELDS t0_site   LIKE si_site
    FIELDS t0_line   LIKE ln_line
    FIELDS t0_sn     AS   INTEGER
    FIELDS t0_part   LIKE pt_part
    FIELDS t0_wktime AS   DECIMAL
    FIELDS t0_tttime AS   DECIMAL
    FIELDS t0_time   AS   DECIMAL
    FIELDS t0_user1  LIKE rps_user1
    INDEX t0_idx1 IS PRIMARY t0_date t0_site t0_line t0_user1.

DEFINE TEMP-TABLE tmp_file1
    FIELDS t1_sn LIKE xxlnw_sn
    FIELDS t1_avli AS DECIMAL.

assign isite = "gsa01"
       isite1 = "gsa01"
       iline = "hps"
       iline1 = "hps"
       idate = TODAY - 1 
       idate1 = today.

EMPTY TEMP-TABLE tmp_file0 NO-ERROR.
OUTPUT TO xx23x.txt.
for each rps_mstr no-lock where rps_rel_date >= idate
     and rps_rel_date <= idate1
     and rps_line >= iLine
     and rps_line <= iline1 
     AND rps_qty_req - rps_qty_comp > 0,
    each lnd_det no-lock where lnd_line = rps_line
     and lnd_site = rps_site and
        lnd_part = rps_part 
 BREAK BY rps_rel_date BY rps_site BY rps_line BY rps_part BY rps_user1:
       IF FIRST-OF(rps_line) THEN DO:
           EMPTY TEMP-TABLE tmp_file1.
           FOR EACH xxlnw_det NO-LOCK WHERE xxlnw_site = rps_site
               AND xxlnw_line = rps_line AND xxlnw_on:
               CREATE tmp_file1.
               ASSIGN t1_sn = xxlnw_sn
                      t1_avli = xxlnw_wktime.
    
           END.
          
       END.
       ASSIGN vtime1 = (rps_qty_req - rps_qty_comp) / lnd_rate.
       ASSIGN vtime = (rps_qty_req - rps_qty_comp) / lnd_rate.
       FOR EACH tmp_file1 EXCLUSIVE-LOCK WHERE t1_avli > 0 AND vtime > 0 BY t1_sn:
         
          IF t1_avli >= vtime THEN DO:
               CREATE tmp_file0.
               ASSIGN t0_record = rps_record
                   t0_date = rps_rel_date
                   t0_site = rps_site
                   t0_line = rps_line
                   t0_part  = rps_part
                   t0_user1 = rps_user1
                   t0_sn = t1_sn
                   t0_wktime = VTIME1.
                   t0_tttime = vtime.
               ASSIGN t1_avli = t1_avli - vtime.
               LEAVE.
           END.
           ELSE DO:
               CREATE tmp_file0.
               ASSIGN t0_record = rps_record
                  t0_date = rps_rel_date
                  t0_site = rps_site
                  t0_line = rps_line
                  t0_sn = t1_sn
                  t0_part  = rps_part
                  t0_user1 = rps_user1
                  t0_wktime = VTIME1
                  t0_tttime = t1_avli
                  .
               ASSIGN vtime = vtime - t1_avli.
               ASSIGN t1_avli = 0.
           END.
       END.
end.


FOR EACH tmp_file0:
    DISPLAY tmp_file0 WITH WIDTH 300 STREAM-IO.
END.
 
/*  DO vd = idate TO idate1:                                   */
/*     ASSIGN vtime = 0.                                       */
/*     FOR EACH xxlnw_det NO-LOCK WHERE xxlnw_site >= isite    */
/*          AND xxlnw_site <= isite1 AND xxlnw_line >= iline   */
/*          AND xxlnw_line <= iline1 AND xxlnw_on BY xxlnw_sn: */
/*         IF REno = ? THEN DO:                                */
/*             FIND FIRST tmp_file0 WHERE tmp_date = vd        */
/*                    AND tmp_site = xxlnw_site AND            */
/*                                                             */
/*         END.                                                */
/*         REPEAT:                                             */
/*             FIND                                            */
/*         END.                                                */
/*     END.                                                    */
/*  END.                                                       */




    /* display rps_part rps_qty_req rps_user1 lnd_rate rps_qty_req / lnd_rate. */
/*     IF FIRST-OF (rps_rel_date) THEN DO:                                */
/*          ASSIGN vtime1 = 0.                                            */
/*     END.                                                               */
/*     ASSIGN vtime = (rps_qty_req - rps_qty_comp) / lnd_rate.            */
/*     IF recno = ? THEN DO:                                              */
/*     find first xxlnw_det no-lock where xxlnw_site = rps_site           */
/*            and xxlnw_line = rps_line and xxlnw_on no-error.            */
/*     IF AVAILABLE xxlnw_det THEN                                        */
/*     ASSIGN recno = RECID(xxlnw_det).                                   */
/*     END.                                                               */
/*     REPEAT:                                                            */
/*         FIND FIRST xxlnw_det WHERE RECID(xxlnw_det) = recno.           */
/*         IF AVAILABLE xxlnw_det THEN DO:                                */
/*            IF xxlnw_wktime > vtime THEN DO:                            */
/*                                                                        */
/*                FIND NEXT xxlnw_det no-lock where xxlnw_site = rps_site */
/*                      and xxlnw_line = rps_line and xxlnw_on no-error.  */
/*                IF AVAILABLE xxlnw_det THEN DO:                         */
/*                   ASSIGN recno = RECID(xxlnw_det).                     */
/*                END.                                                    */
/*                LEAVE.                                                  */
/*           END.                                                        */
/*         END.                                                           */
/*     END.                                                               */



/*          ASSIGN vtime = xxlnw_wktime - vtime.                                                                  */
/*              DO WHILE vtime > 0:                                                                               */
/*                 FOR EACH tmp_file0 EXCLUSIVE-LOCK WHERE t0_date = vd                                           */
/*                     AND t0_site = xxlnw_site AND t0_line = xxlnw_line AND t0_tttime > 0:                       */
/*                     IF t0_tttime < vtime  THEN DO:                                                             */
/*                         ASSIGN vtime = vtime - t0_tttime                                                       */
/*                                t0_tttime = vtime - t0_tttime.                                                  */
/*                     END.                                                                                       */
/*                     ELSE DO:                                                                                   */
/*                         vtime = 0.                                                                             */
/*                         LEAVE.                                                                                 */
/*                     END.                                                                                       */
/*                        DISPLAY xxlnw_sn t0_date t0_site t0_line t0_part t0_wktime t0_tttime xxlnw_wktime vtime */
/*                                WITH WIDTH 300 STREAM-IO.                                                       */
/*                      IF vtime = 0 THEN LEAVE.                                                                  */
/*                 END.                                                                                           */
/*              END.                                                                                              */

/*                                                                                                                    */
/*          IF AVAILABLE tmp_file0 THEN DO:                                                                           */
/*                    IF t0_wktime > vtime THEN DO:                                                                   */
/*                        DISPLAY vd "A" @ xxlnw_start xxlnw_sn xxlnw_line xxlnw_wktime t0_part t0_wktime t0_tttime.  */
/*                        ASSIGN vtime = 0.                                                                           */
/*                    END.                                                                                            */
/*                    ELSE DO:                                                                                        */
/*                        DISPLAY vd "B" @ xxlnw_start  xxlnw_sn xxlnw_line xxlnw_wktime t0_part t0_wktime t0_tttime. */
/*                        ASSIGN vtime = t0_wktime - vtime.                                                           */
/*                    END.                                                                                            */
/*                                                                                                                    */
/*                END.                                                                                                */
/*                                                                                                                    */

/*    FOR EACH tmp_file0 BREAK BY t0_date BY t0_sn BY t0_user1:  */
/*        IF vtime = 0 THEN ASSIGN vtime = t0_wktime.            */
/*        IF vtime1 = 0 THEN ASSIGN vtime1 = t0_tttime.          */
/*        IF t0_wktime >= t0_tttime THEN DO:                     */
/*            ASSIGN t0_time = t0_tttime.                        */
/*        END.                                                   */
/*        ELSE DO:                                               */
/*            ASSIGN t0_time = t0_wktime.                        */
/*        END.                                                   */
/* /*        DISPLAY tmp_file0 WITH WIDTH 200 STREAM-IO. */      */
/*       DISPLAY t0_date t0_sn t0_wktime t0_tttime vtime vtime1. */
/*    END.                                                       */
