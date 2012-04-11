/*111123.1 by ken*/
/*111206.1 by ken*/

{mfdeclre.i}
{gplabel.i} 

/*111206.1
DEFINE  SHARED  TEMP-TABLE ttld_det 
    FIELD ttld_sel AS LOGICAL    LABEL "选择"     
    FIELD ttld_lot AS CHARACTER  LABEL "OVDLotNo"  FORMAT "x(18)"
    FIELD ttld_part AS CHARACTER LABEL "转用后"    FORMAT "x(18)"
    FIELD ttld_check AS CHARACTER LABEL "检查"     FORMAT "x(8)"
    FIELD ttld_mfd AS DECIMAL LABEL "mfd"
    FIELD ttld_rc AS DECIMAL LABEL "λc" 
    FIELD ttld_r0 AS DECIMAL LABEL "λ0"
    FIELD ttld_wj AS DECIMAL LABEL "外径"
    FIELD ttld_yxc AS DECIMAL LABEL "有效长"
    FIELD ttld_zzl AS DECIMAL LABEL "总重量"
    FIELD ttld_jszl AS DECIMAL LABEL "计算重量"
    FIELD ttld_jbd AS DECIMAL LABEL "径变动"
    FIELD ttld_rn AS DECIMAL LABEL "△n" 
    FIELD ttld_pxl AS DECIMAL LABEL "偏芯率"
    FIELD ttld_bow AS DECIMAL LABEL "BOW"
    FIELD ttld_fy AS DECIMAL LABEL "非圆"
    FIELD ttld_qp AS CHARACTER LABEL "气泡"
    FIELD ttld_D_core AS DECIMAL LABEL "D-Core"
    FIELD ttld_slope AS DECIMAL LABEL "slope"
    FIELD ttld_D1285 AS DECIMAL LABEL "D1285"
    FIELD ttld_defect AS CHARACTER LABEL "Defect" FORMAT "x(8)"
    FIELD ttld_part1 AS CHARACTER LABEL "转用前"   FORMAT "x(18)"
    FIELD ttld_site AS CHARACTER
    FIELD ttld_loc   AS CHARACTER                 FORMAT "x(8)"
    FIELD ttld_ref   AS CHARACTER
    FIELD ttld_loc_to AS CHARACTER                FORMAT "x(8)"
    FIELD ttld_qty_oh AS DECIMAL
    FIELD ttld_ok  AS CHARACTER
    FIELD ttld_sum_weight AS DECIMAL
    FIELD ttld_count AS INTEGER
    INDEX index1 ttld_lot.
*/

DEFINE SHARED  TEMP-TABLE ttld_det 
    FIELD ttld_sel AS LOGICAL       
    FIELD ttld_lot AS CHARACTER    FORMAT "x(18)"
    FIELD ttld_part AS CHARACTER     FORMAT "x(18)"
    FIELD ttld_check AS CHARACTER      FORMAT "x(8)"
    FIELD ttld_mfd AS DECIMAL 
    FIELD ttld_rc AS DECIMAL  
    FIELD ttld_r0 AS DECIMAL 
    FIELD ttld_wj AS DECIMAL 
    FIELD ttld_yxc AS DECIMAL 
    FIELD ttld_zzl AS DECIMAL 
    FIELD ttld_jszl AS DECIMAL 
    FIELD ttld_jbd AS DECIMAL 
    FIELD ttld_rn AS DECIMAL  
    FIELD ttld_pxl AS DECIMAL 
    FIELD ttld_bow AS DECIMAL 
    FIELD ttld_fy AS DECIMAL 
    FIELD ttld_qp AS CHARACTER 
    FIELD ttld_D_core AS DECIMAL 
    FIELD ttld_slope AS DECIMAL 
    FIELD ttld_D1285 AS DECIMAL 
    FIELD ttld_defect AS CHARACTER  FORMAT "x(8)"
    FIELD ttld_part1 AS CHARACTER    FORMAT "x(18)"
    FIELD ttld_site AS CHARACTER
    FIELD ttld_loc   AS CHARACTER                 FORMAT "x(8)"
    FIELD ttld_ref   AS CHARACTER
    FIELD ttld_loc_to AS CHARACTER                FORMAT "x(8)"
    FIELD ttld_qty_oh AS DECIMAL
    FIELD ttld_ok  AS CHARACTER
    FIELD ttld_sum_weight AS DECIMAL
    FIELD ttld_count AS INTEGER
    INDEX index1 ttld_lot.


DEFINE VARIABLE fn_i AS CHARACTER.
DEFINE VARIABLE v_tr_trnbr LIKE tr_trnbr.


   FOR EACH ttld_det WHERE ttld_sel = YES:

/*
ttld_part
ttld_site ttld_qty_oh  - - ttld_site ttld_loc ttld_lot ttld_ref no
- - - - today - - - - yes
"" 


ttld_part1 
ttld_qty_oh no ttld_site ttld_loc ttld_lot ttld_ref no
.
yes
yes
yes
*/
      fn_i = "zzdivmt312-" + global_userid +  STRING(TIME).
      
      OUTPUT TO VALUE(fn_i + ".inp" ).
      PUT UNFORMATTED ttld_part SKIP.
      PUT UNFORMATTED ttld_site " " ttld_qty_oh  " " "- - " ttld_site " " ttld_loc " " ttld_lot " " """" + ttld_ref + """" " " "NO"   SKIP.
      PUT UNFORMATTED "- - - - - - - - - " "YES" SKIP.
      PUT UNFORMATTED """" + " " + """"  SKIP.
      /*
      PUT UNFORMATTED SKIP(1).
      PUT UNFORMATTED SKIP(1).
      */
      PUT UNFORMATTED ttld_part1 SKIP.
      PUT UNFORMATTED ttld_qty_oh " " "NO" " " ttld_site " " ttld_loc " " ttld_lot  " " """" + ttld_ref + """" " " "no" SKIP.
      PUT UNFORMATTED """" + " " + """" SKIP.
      PUT UNFORMATTED "yes" SKIP.
      PUT UNFORMATTED "yes" SKIP.
      PUT UNFORMATTED "yes" SKIP.
      OUTPUT CLOSE .
      
      FIND LAST tr_hist WHERE tr_domain = GLOBAL_domain NO-LOCK NO-ERROR.
      v_tr_trnbr = tr_trnbr .

      batchrun = yes.
      INPUT FROM VALUE(fn_i + ".inp" ) .
      OUTPUT TO VALUE(fn_i + ".cim" ) .
      {gprun.i ""icunrc01.p""}
      INPUT CLOSE .
      OUTPUT CLOSE .
      batchrun = NO.
       
      FIND LAST tr_hist WHERE tr_domain = GLOBAL_domain 
           AND tr_effdate = TODAY
           AND tr_part = ttld_part1 
           AND tr_loc = ttld_loc 
           AND tr_serial = ttld_lot
           AND tr_ref = ttld_ref
           AND tr_qty_loc = - ttld_qty_oh
           AND tr_trnbr > v_tr_trnbr
           AND tr_type = "ISS-WO" NO-LOCK NO-ERROR .
      IF AVAIL tr_hist THEN DO:
          /*
          UNIX SILENT VALUE("rm -rf " + TRIM(fn_i) + ".inp") .
          UNIX SILENT VALUE("rm -rf " + TRIM(fn_i) + ".cim") .
          */
      end.
      
   END.

