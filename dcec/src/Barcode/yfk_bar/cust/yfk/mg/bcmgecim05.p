{mfdeclre.i}
    {bcdeclre.i}

DEFINE INPUT PARAMETER bfid AS INTEGER.
DEFINE OUTPUT PARAMETER succeed AS LOGICAL.

DEFINE VARIABLE begintime AS INTEGER.
DEFINE VARIABLE endtime AS INTEGER.

DEFINE SHARED VARIABLE GLOBAL_recid AS RECID.

ASSIGN GLOBAL_recid = ?.

FOR FIRST b_bf_det WHERE b_bf_id = bfid:
END.


DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO,LEAVE:
  /*begintime = TIME.
  define variable errors as integer.
  {xgcmdef.i "new"}*/
  {bcrun.i ""bcmgbdpro_90.p"" "(INPUT mfguser,INPUT ""d:\temp\out.prn"")"}
  /*{bcrun.i ""bcmgcm001.p""
           "(INPUT ""d:\temp\rcshmt.cim"",
             output errors)"}*/
  
  
  endtime = TIME.

  OS-DELETE VALUE(mfguser).

  FIND FIRST b_bf_det EXCLUSIVE-LOCK WHERE b_bf_id = bfid NO-ERROR.
  IF AVAILABLE b_bf_det THEN DO:
          FOR EACH ABS_mstr NO-LOCK WHERE abs_par_id = "s" + b_bf_abs_id:
          IF ABS_id <> ? THEN DO:
             CREATE b_tr_hist.
             ASSIGN b_tr_nbr = ABS_order
                 b_tr_line = int(abs_line)
                 b_tr_code = ""
                 b_tr_part = abs_item
                 b_tr_lot = abs_lotser
                 /*b_tr_ser = tr_ser*/
                 b_tr_qty_ord = abs_qty
                 b_tr_qty_chg = abs_qty
                 b_tr_qty_loc = abs_qty
                 b_tr_um = ""
                 b_tr_um1 = ""
                 b_tr_um2 = ""
                 b_tr_std_cost = 0
                 b_tr_cur_cost = 0
                 b_tr_tr_cost = 0
                 b_tr_date = abs_shp_date
                 b_tr_tr_date = abs_shp_date
                 b_tr_eff_date = abs_shp_date
                 b_tr_type = ""
                 b_tr_id = 0
                 b_tr_trnbr = 0
                 b_tr_time =0
                 b_tr_loc = abs_loc
                 b_tr_site = abs_site.

                 b_bf_tocim = NO.
                 b_bf_absid = ABS_par_id.
                                 
                 succeed = TRUE.
                 {bcco002.i ""FINI-SHIPPED""}
                 STATUS INPUT "完成".
          END.
          ELSE DO:
              succeed = FALSE.
              STATUS INPUT "数据更新数据库时发生问题，操作取消".
              UNDO,LEAVE.
          END.
          END.
  END.
  ELSE DO:
      succeed = FALSE.
      STATUS INPUT "数据更新数据库时发生问题，操作取消".
      UNDO,LEAVE.
  END.



END.
