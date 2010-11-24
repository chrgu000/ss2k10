
/* 此程序用于将每月的制令入库数量用到的物料明细导入到xxdcq_hst用于成本计算   */

DEFINE INPUT PARAMETER iPeriod AS CHARACTER.
DEFINE VARIABLE vgLAYER AS INTEGER   NO-UNDO.
DEFINE VARIABLE datef AS DATE      NO-UNDO.
DEFINE VARIABLE datet AS DATE      NO-UNDO.
DEFINE TEMP-TABLE tmp_ps
    FIELDS tmp_layer AS INTEGER
    FIELDS tmp_root LIKE pt_part
    FIELDS tmp_part LIKE pt_part
    FIELDS tmp_comp LIKE pt_part
    FIELDS tmp_qty  LIKE ps_qty_per
    FIELDS tmp_qty_per LIKE ps_qty_per
    FIELDS tmp_lcode AS INTEGER.

DEFINE BUFFER psmstr FOR ps_mstr.
DEFINE BUFFER tmpps  FOR tmp_ps.

{xxdcspub.i}

RUN getPeriodDate(INPUT iperiod,OUTPUT datef,OUTPUT datet).

FOR EACH xxdcq_hst EXCLUSIVE-LOCK WHERE xxdcq_period = iperiod:
    DELETE xxdcq_hst.
END.

FOR EACH tr_hist NO-LOCK WHERE tr_effdate >= datef AND tr_effdate <= datet AND
         tr_type = "rct-wo" BREAK BY tr_part:
    ACCUM tr_qty_loc(TOTAL BY tr_part).
    IF LAST-OF(tr_part) THEN DO:
        EMPTY TEMP-TABLE tmp_ps NO-ERROR.
        RUN getBomDetail(INPUT 1,INPUT tr_part,INPUT tr_part,INPUT tr_effdate).
        RUN calcBomQty.
        RUN calcPs(INPUT iperiod).
        FOR EACH xxdcq_hst EXCLUSIVE-LOCK WHERE xxdcq_period  = iperiod
             AND xxdcq_par = tr_part:
          ASSIGN xxdcq_qty_rct = ACCUM TOTAL BY tr_part tr_qty_loc.
        END.
    END.
END.

/*将物料的最底层代码记录在xxdcq_layer里。*/
for each xxdcq_hst exclusive-lock where xxdcq_period = iperiod
   break by xxdcq_period by xxdcq_comp by xxdcq_layer desc:
       IF FIRST-OF(xxdcq_comp) THEN DO:
          ASSIGN vgLAYER = xxdcq_layer.
       END.
       ELSE DO:
          ASSIGN xxdcq_layer= vgLAYER.
       END.
end.

/**将BOM展开到临时表 **/
PROCEDURE getBomDetail:
    DEFINE INPUT PARAMETER ilayer   AS   INTEGER.
    DEFINE INPUT PARAMETER ibompar  LIKE pt_part.
    DEFINE INPUT PARAMETER ibomroot LIKE pt_part.
    DEFINE INPUT PARAMETER idate    AS   DATE.
    FOR EACH ps_mstr NO-LOCK WHERE ps_par = ibompar
        AND (idate = ? OR ps_start <= idate OR ps_start = ?)
        AND (idate = ? OR ps_end >= idate OR ps_end = ?):
        CREATE TMP_PS.
        ASSIGN tmp_layer = ilayer
               tmp_root = ibomroot
               tmp_part = ps_par
               tmp_comp = ps_comp
               tmp_qty_per = ps_qty_per.
           RUN getBomDetail(INPUT ilayer + 1,INPUT ps_comp,
                            INPUT ibomroot, INPUT idate).
    END.
END PROCEDURE.

/* 计算材料在成品上的使用量 */
PROCEDURE calcBomqty:
    DEFINE VARIABLE m AS INTEGER.
    DEFINE VARIABLE n AS INTEGER.
    FOR EACH tmp_ps EXCLUSIVE-LOCK :
        IF n <= tmp_layer THEN ASSIGN n = tmp_layer.
        IF tmp_layer = 1 THEN ASSIGN tmp_qty = tmp_qty_per.
    END.
    DO m = 1 TO n - 1:
        FOR EACH tmp_ps NO-LOCK WHERE tmp_layer = m:
            FOR EACH tmpps EXCLUSIVE-LOCK WHERE
                     tmpps.tmp_layer = tmp_ps.tmp_layer + 1 AND
                     tmpps.tmp_part = tmp_ps.tmp_comp.
              ASSIGN tmpps.tmp_qty = tmp_ps.tmp_qty * tmpps.tmp_qty_per.
            END.
        END.
    END.
END.

/* 将用量汇总到xxdcq_hst */
PROCEDURE calcPs.
DEFINE INPUT PARAMETER iperiod AS CHARACTER.
DEFINE VARIABLE vlayer AS INTEGER.
FOR EACH tmp_ps EXCLUSIVE-LOCK BREAK BY tmp_comp BY tmp_layer DESC:
    IF FIRST-OF(tmp_comp) THEN DO:
        ASSIGN vlayer = tmp_layer.
    END.
    ASSIGN tmp_lcode = vlayer.
/*     DISPLAY tmp_ps WITH WIDTH 300 STREAM-IO. */
END.
FOR EACH tmp_ps NO-LOCK BREAK
      BY tmp_ps.tmp_root BY tmp_ps.tmp_par BY tmp_ps.tmp_comp:
    ACCUM tmp_ps.tmp_qty (TOTAL BY tmp_ps.tmp_part BY tmp_ps.tmp_comp).
    ACCUM tmp_ps.tmp_qty_per (TOTAL BY tmp_ps.tmp_part BY tmp_ps.tmp_comp).
    IF LAST-OF(tmp_ps.tmp_comp) THEN DO:
       CREATE xxdcq_hst.
       ASSIGN xxdcq_period  = iperiod
              xxdcq_par     = tmp_ps.tmp_root
              xxdcq_part    = tmp_ps.tmp_part
              xxdcq_comp    = tmp_ps.tmp_comp
              xxdcq_layer   = tmp_lcode
              xxdcq_qty_per = ACCUM TOTAL BY tmp_ps.tmp_comp tmp_ps.tmp_qty_per
              xxdcq_qty_iss = ACCUM TOTAL BY tmp_ps.tmp_comp tmp_ps.tmp_qty.
    END.
END.
END PROCEDURE.
