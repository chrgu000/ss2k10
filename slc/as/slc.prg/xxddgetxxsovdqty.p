/* Creation: eB21SP3 Chui Last Modified: 20080107 By: Davild Xu *ss-20071228.1*/
/* Creation: eB21SP3 Chui Last Modified: 20080107 By: Davild Xu *ss-20071228.1*/
/*Modified by Billy 2008-12-27                                                */
/*---Add Begin by davild 20080107.1*/
/*改成调用xxvin_mstr了
1.查询工单ID的出入库及下线包装数量
*/
/*---Add End   by davild 20080107.1*/

/*
xxwoiq04.p 有调用
xxwoiq05.p 有调用
*/


{mfdeclre.i}
{gplabel.i}

DEF INPUT PARAM wolot LIKE wo_lot .
DEFINE output PARAM qty_pack like ld_qty_oh .
DEFINE output PARAM qty_line like ld_qty_oh .
DEFINE output PARAM qty_ruku like ld_qty_oh .
DEFINE output PARAM qty_cuku like ld_qty_oh .
qty_pack  = 0 .
qty_line  = 0 . 
qty_ruku  = 0 . 
qty_cuku  = 0 . 
for each xxvin_mstr where xxvin_domain = global_domain and xxvin_wolot = wolot no-lock:
	qty_pack = xxvin_qty_up .
	qty_line = xxvin_qty_down .
	qty_ruku = xxvin_qty_ruku .
	qty_cuku = xxvin_qty_cuku .
end.

