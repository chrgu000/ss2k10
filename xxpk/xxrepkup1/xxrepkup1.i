/* xxrepkup1.i - REPETITIVE PICKLIST Temporary Variable Definition list.     */
/*V8:ConvertMode=NoConvert                                                   */
/* REVISION: 0CYH LAST MODIFIED: 05/30/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

define temp-table xwd
	fields xwd_part like pt_part
	fields xwd_qty_req like ps_qty_req
	index xwd_part xwd_part.

/*------------------------------------------------------------------------------
  Purpose:展开工单明细
  Parameters: par_item (工单成品)
  Memo: 展开工单到第一层非虚零件将料号,需求存到表xwd
------------------------------------------------------------------------------*/
procedure getWod:
	define input parameter par_item like wo_part.
	
end procedure.