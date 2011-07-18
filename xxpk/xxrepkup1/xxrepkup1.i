/* xxrepkup1.i - REPETITIVE PICKLIST Temporary Variable Definition list.     */
/*V8:ConvertMode=NoConvert                                                   */
/* REVISION: 0CYH LAST MODIFIED: 05/30/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

/*** 此表用于确定那个材料是vpart下的非虚零件要显示在报表上                ****/
define temp-table levx no-undo
  fields levx_part like pt_part
  fields levx_qty  like ps_qty_per
  index levx_part levx_part.
define buffer ptmstr for pt_mstr.
/*------------------------------------------------------------------------------
  Purpose:展开工单明细第一层非虚零件的用量
  Parameters: par_item (工单成品)
  Memo: 展开工单到第一层非虚零件将料号,需求存到表levx
------------------------------------------------------------------------------*/
procedure getPhList:
  define input parameter ipart like ps_par.
  define input-output parameter ioqty like ps_qty_per.
  define variable vqty like ps_qty_per.
  for each ps_mstr no-lock where  ps_par = ipart
       and (ps_mstr.ps_start <= today or ps_mstr.ps_start = ?)
       and (ps_mstr.ps_end >= today or ps_mstr.ps_end = ?):

       assign vqty = ioqty * ps_mstr.ps_qty_per * (100 / (100 - ps_scrp_pct)).
       find first ptmstr no-lock
            where ptmstr.pt_part = ps_mstr.ps_comp no-error.
       if available ptmstr then do:
         if ptmstr.pt_phantom then do:
            run getPhList(input ps_mstr.ps_comp,input-output vqty).
         end.
         else do:
            find first levx exclusive-lock where levx_part = ps_mstr.ps_comp
                 no-error.
            if available levx then do:
               assign levx_qty = levx_qty + vqty.
            end.
            else do:
               create levx.
               assign levx_part = ps_mstr.ps_comp
                      levx_qty  = vqty.
            end.
         end.
       end.
  end.
end procedure.
