/* xxrepkup0.i - REPETITIVE PICK LIST HARD ALLOCATIONS                       */
/*V8:ConvertMode=Maintenance                                                 */

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
    FIELDS t0_start  as   integer
    FIELDS t0_end    as   integer
    FIELDS t0_qtya   like rps_qty_req
    FIELDS t0_qty    like rps_qty_req
    FIELDS t0_user1  LIKE rps_user1
    INDEX t0_idx1 IS PRIMARY t0_date t0_site t0_line t0_user1.

DEFINE TEMP-TABLE tmp_file1
    FIELDS t1_sn LIKE xxlnw_sn
    FIELDS t1_start like xxlnw_stime
    fields t1_end   like xxlnw_etime
    FIELDS t1_avli AS DECIMAL.


PROCEDURE gett0:

define input parameter iDate as date.
define input parameter iDate1 as date.
define input parameter isite like si_site.
define input parameter isite1 like si_site.
define input parameter iline like ln_line.
define input parameter iline1 like ln_line.

define variable vtime   as decimal.
DEFINE VARIABLE recno   AS RECID.

EMPTY TEMP-TABLE tmp_file0 NO-ERROR.
 
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
                      t1_avli = xxlnw_wktime
                      t1_start = xxlnw_stime
                      t1_end = xxlnw_etime.
           END.
          
       END.
       ASSIGN vtime = (rps_qty_req - rps_qty_comp) / lnd_rate.
       FOR EACH tmp_file1 EXCLUSIVE-LOCK WHERE 
       			    t1_avli > 0 AND vtime > 0 BY t1_sn:
          IF t1_avli >= vtime THEN DO:
               CREATE tmp_file0.
               ASSIGN t0_record = rps_record
                   t0_date = rps_rel_date
                   t0_site = rps_site
                   t0_line = rps_line
                   t0_part  = rps_part
                   t0_user1 = rps_user1
                   t0_sn = t1_sn
                   t0_start = t1_start
                   t0_end   = t1_end
                   t0_wktime = (rps_qty_req - rps_qty_comp) / lnd_rate
                   t0_qtya = rps_qty_req - rps_qty_comp
                   t0_qty =truncate(t0_qtya * (vtime / t0_wktime),0)
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
                  t0_start = t1_start
                  t0_end   = t1_end
                  t0_qtya = rps_qty_req - rps_qty_comp
                  t0_wktime = (rps_qty_req - rps_qty_comp) / lnd_rate
                  t0_tttime = t1_avli
                  t0_qty = truncate(t0_qtya * (t1_avli / t0_wktime),0)
                  .
               ASSIGN vtime = vtime - t1_avli.
               ASSIGN t1_avli = 0.
           END.
       END.
end.

END PROCEDURE.

/* run gett0(input today - 2 ,input today  ,           */
/*                     input "gsa01" ,input "gsa01" ,  */
/*                     input "HPS",input "HPS").       */
/*                                                     */
/* output to xxxxxssxx.txt.                            */
/*     for each tmp_file0:                             */
/*     display t0_date                                 */
/*             t0_record                               */
/*             t0_site                                 */
/*             t0_line                                 */
/*             t0_sn                                   */
/*             t0_part                                 */
/*             t0_wktime                               */
/*             t0_tttime                               */
/*             string(t0_start ,"hh:mm:ss") @ t0_start */
/*             string(t0_end ,"hh:mm:ss") @ t0_end     */
/*             t0_qtyA                                 */
/*             t0_qty                                  */
/*             t0_user1                                */
/*  with width 300 stream-io.                          */
/* end.                                                */
/* output close.                                       */
