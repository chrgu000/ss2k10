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
  Purpose:չ��������ϸ
  Parameters: par_item (������Ʒ)
  Memo: չ����������һ�����������Ϻ�,����浽��xwd
------------------------------------------------------------------------------*/
procedure getWod:
	define input parameter par_item like wo_part.
	
end procedure.