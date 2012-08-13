{bcdeclre.i}

DEFINE INPUT PARAMETER bfid AS INTEGER.
DEFINE OUTPUT PARAMETER suc AS LOGICAL.

DEFINE VARIABLE begintime AS INTEGER.
DEFINE VARIABLE endtime AS INTEGER.

FOR FIRST b_bf_det WHERE b_bf_id = bfid:
END.


DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO,LEAVE:

  begintime = TIME.
  {bcrun.i ""bcmgbdpro.p"" "(INPUT ""d:\temp\repcim.cim"",INPUT ""d:\temp\out.prn"")"}
  endtime = TIME.

  FIND FIRST wo_mstr NO-LOCK WHERE wo_part = b_bf_part NO-ERROR.
  IF AVAILABLE wo_mstr THEN DO:
      FIND FIRST wod_det NO-LOCK WHERE wod_lot = wo_lot AND string(wod_op) = b_bf_ref NO-ERROR.
      IF AVAILABLE wod_det THEN DO:
          FOR EACH tr_hist NO-LOCK WHERE tr_part = wod_part AND tr_type = "ISS-WO"
              AND (tr_time >= begintime AND tr_time <= endtime):
          IF tr_part <> ? THEN DO:
             CREATE b_tr_hist.
             ASSIGN b_tr_nbr = tr_nbr
                 b_tr_line = tr_line
                 b_tr_code = ""
                 b_tr_part = tr_part
                 b_tr_lot = tr_lot
                 /*b_tr_ser = tr_ser*/
                 b_tr_qty_ord = tr_qty_req
                 b_tr_qty_chg = tr_qty_chg
                 b_tr_qty_loc = tr_qty_loc
                 b_tr_um = tr_um
                 b_tr_um1 = ""
                 b_tr_um2 = ""
                 b_tr_std_cost = 0
                 b_tr_cur_cost = 0
                 b_tr_tr_cost = 0
                 b_tr_date = tr_date
                 b_tr_tr_date = tr_date
                 b_tr_eff_date = tr_date
                 b_tr_type = tr_type
                 b_tr_id = tr_trnbr
                 b_tr_trnbr = tr_trnbr
                 b_tr_time = tr_time
                 b_tr_loc = tr_loc
                 b_tr_site = tr_site.

                 b_bf_tocim = NO.
                 
                 suc = TRUE.
                 STATUS INPUT "完成".
          END.
          ELSE DO:
              suc = FALSE.
              STATUS INPUT "数据更新数据库时发生问题，操作取消".
              UNDO,LEAVE.
          END.
          END.
      END.
      ELSE DO:
          suc = FALSE.
          STATUS INPUT "数据更新数据库时发生问题，操作取消".
          UNDO,LEAVE.
      END.
  END.
  ELSE DO:
      suc = FALSE.
      STATUS INPUT "数据更新数据库时发生问题，操作取消".
      UNDO,LEAVE.
  END.


END.
