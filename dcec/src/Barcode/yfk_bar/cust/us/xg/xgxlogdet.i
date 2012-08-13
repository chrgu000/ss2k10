/* xgxlogdet.i       ½¨Á¢xlog_det¼ÇÂ¼      */
/* create by: hou   2006.03.08             */

   for each tt_log:
      create xlog_det.
      assign xlog_obj = tt_obj
             xlog_id = tt_id
             xlog_desc = tt_desc
             xlog_date = tt_date
             xlog_time = tt_time.
      delete tt_log.
   end.
