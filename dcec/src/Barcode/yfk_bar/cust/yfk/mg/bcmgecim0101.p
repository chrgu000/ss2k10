{bcdeclre.i}

DEFINE INPUT PARAMETER bfid AS INTEGER.

DEFINE VARIABLE begintime AS INTEGER.
DEFINE VARIABLE endtime AS INTEGER.

FOR FIRST b_bf_det WHERE b_bf_par_id = bfid:
END.


DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO,LEAVE:

  begintime = TIME.
  {bcrun.i ""bcmgbdpro.p"" "(INPUT ""d:\temp\porc.cim"",INPUT ""d:\temp\out.prn"")"}
  endtime = TIME.

  FIND FIRST pod_det NO-LOCK WHERE pod_part = b_bf_part AND pod_nbr = b_bf_nbr NO-ERROR.
  IF AVAILABLE pod_det THEN DO:
          FOR EACH tr_hist NO-LOCK WHERE tr_part = pod_part AND tr_type = "RCT-PO"
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
                 
                 {bcco002.i ""MAT-RETURNED""}
                 STATUS INPUT "完成".
          END.
          ELSE DO:
              STATUS INPUT "数据更新数据库时发生问题，操作取消".
              UNDO,LEAVE.
          END.
          END.
  END.
  ELSE DO:
      STATUS INPUT "数据更新数据库时发生问题，操作取消".
      UNDO,LEAVE.
  END.

END.  /*do*/


