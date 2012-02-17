/*V8:ConvertMode=Report                                                       */
{mfdeclre.i}
{xxschexp.i}
{gplabel.i}

define variable vl as integer.
define variable vc as integer.
define variable xap as com-handle.
define variable xwb as com-handle.
define variable xws as com-handle.
define variable fn as character.

empty temp-table xxsch_dtidx no-error.
session:set-wait-stat("general").
   CREATE "Excel.Application" xap.
   xwb = xap:Workbooks:add().
   xws = xap:sheets:item(1) no-error.
   xwb:Activate.

   xws:cells(1,1) = "S/A".
   xws:cells(1,1):Font:Size = 24.
   xws:cells(1,1):Font:Color = -1003520.
   xws:cells(1,1):Font:Bold = True.

   xws:cells(1,2) = "xxschimp.p".
   xws:cells(1,3) = getTermLabel("IMPORT",12) + ":xxrssmt.p(5.5.3.3)".
   xws:cells(1,4) = getTermLabel("RELEASE_ID",12).
   xws:cells(1,5) = "'" + vrlseid.
   xws:cells(2,3) = "'"
                  + string(year(today) , "9999") + "-"
                  + string(month(today) , "99") + "-"
                  + string(day(today) , "99") + " "
                  + string(time,"HH:MM:SS").
   xws:cells(4,1) = getTermLabel("PO_NUMBER",12).
   xws:cells(4,2) = getTermLabel("Line",12).
   xws:cells(4,3) = getTermLabel("ITEM_NUMBER",12).
   xws:cells(4,4) = getTermLabel("PRIOR_CUM_DEMAND",16).
   xws:cells(4,5) = getTermLabel("PRIOR_CUM_DATE",16).
   xws:cells(4,6) = getTermLabel("FORECAST1",16).
   xws:cells(4,7) = getTermLabel("FORECAST2",17).
   xws:cells(5,8):select no-error.
   xap:ActiveWindow:FreezePanes = TRUE NO-ERROR.
   for each schd_det no-lock where schd_domain = global_domain
        and schd_nbr = vpo and schd_rlse_id = vrlseid by schd_line:
        if not can-find (first xxsch_dtidx where xdti_date = schd_date and
                               xdti_time = schd_time) then do:
           create xxsch_dtidx.
           assign xdti_date = schd_date
                  xdti_time = schd_time.
        end.
   end.

   assign vc = 8.
   for each xxsch_dtidx exclusive-lock break by xdti_date by xdti_time:
       assign xdti_idx = vc.
       assign vc = vc + 1.
   end.

   for each xxsch_dtidx exclusive-lock break by xdti_idx:
       xws:cells(3,xdti_idx) =  "'"
                            + string(year(xdti_date) , "9999") + "-"
                            + string(month(xdti_date) , "99") + "-"
                            + string(day(xdti_date) , "99").
       xws:cells(3,xdti_idx):AddComment.
       xws:cells(3,xdti_idx):Comment:Visible = False.
       xws:cells(3,xdti_idx):Comment:Text("请不要删除文本前面的'").
       xws:cells(4,xdti_idx) = "'" + string(xdti_time,"99:99").
       xws:cells(4,xdti_idx):AddComment.
       xws:cells(4,xdti_idx):Comment:Visible = False.
       xws:cells(4,xdti_idx):Comment:Text("请不要删除文本前面的'").
   end.
   xap:visible = true.
   assign vl = 5.
   for each sch_mstr no-lock where sch_domain = global_domain
        and sch_nbr = vpo and sch_rlse_id = vrlseid
         by sch_line:
      find first pod_det no-lock where pod_domain = sch_domain and
                 pod_nbr = sch_nbr and pod_line = sch_line.
      if not available pod_det then do:
         next.
      end.
      xws:cells(vl,1) = "'" + sch_nbr.
      xws:cells(vl,2) = sch_line.
      xws:cells(vl,3) = "'" + pod_part.
      xws:cells(vl,4) = sch_pcr_qty.
      xws:cells(vl,5) = "'" + string(year(sch_pcs_date) , "9999") + "-"
                            + string(month(sch_pcs_date) , "99") + "-"
                            + string(day(sch_pcs_date) , "99").
      xws:cells(vl,5):AddComment.
      xws:cells(vl,5):Comment:Visible = False.
      xws:cells(vl,5):Comment:Text("请不要删除文本前面的'").
      xws:cells(vl,6) = sch__dec01.
      xws:cells(vl,7) = sch__dec02.

      for each schd_det no-lock where schd_domain = sch_domain
          and schd_type = sch_type and schd_nbr = sch_nbr
          and schd_line = sch_line
          and schd_rlse_id = sch_rlse_id:
          find first xxsch_dtidx where xdti_date = schd_date
                 and xdti_time = schd_time no-error.
          if available xxsch_dtidx then do:
              xws:cells(vl,xdti_idx) = schd_discr_qty.
              xws:cells(2,xdti_idx) = schd_fc_qual.
          end.
      end.
      assign vl = vl + 1.
   end.
   xap:visible = true.
   xwb:saved = true.
/*    xap:quit. */
   release OBJECT xws.
   release OBJECT xwb.
   release object xap.
session:set-wait-stat("").
