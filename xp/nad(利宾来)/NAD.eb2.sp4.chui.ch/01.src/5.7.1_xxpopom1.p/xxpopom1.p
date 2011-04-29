/* popomt.p - PURCHASE ORDER MAINTENANCE                                      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.3.4.4 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/*                                                                            */
/* Revision: 6.0  BY:SVG                DATE:08/13/90         ECO: *D058*     */
/* Revision: 7.0  BY:AFS   (rev only)   DATE:07/01/92         ECO: *F727*     */
/* Revision: 8.6  BY:Alfred Tan         DATE:05/20/98         ECO: *K1Q4*     */
/* Revision: 9.1  BY:Annasaheb Rahane   DATE:03/24/00         ECO: *N08T*     */
/* Revision: 1.3.4.2     BY: Mark B. Smith       DATE:11/08/99   ECO: *N059*  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.3.4.3     BY: Jean Miller         DATE: 12/11/01  ECO: *P03N*  */
/* $Revision: 1.3.4.4 $  BY: Jean Miller         DATE: 01/07/02  ECO: *P040*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* Creation: eB21SP3 Chui Last Modified: 20080624 By: Davild Xu *ss-20080624.1*/
/* Creation: eB21SP3 Chui Last Modified: 20080715 By: Davild Xu *ss-20080715.1*/
/* Creation: eB21SP3 Chui Last Modified: 20080722 By: Davild Xu *ss-20080722.1*/
/*---Add Begin by davild 20080722.1*/
/*
V xxcermta1.p xxcepmta.p 2) 设置零件,结果NG。原因：零件数据维护中修改“产品线、说明、计量单位、装箱尺寸”栏位最后修改日期和修改人都不变，附图6
V xxpopom1a.p 1.采购单中以JZY2开头不的料号可以不输入重量，
V xxpopom1b.p  确认状态默认为N，且不允许修改
未发运此最新版本给MARTIN V xxoiointd.p 没有有效日期的CER
V xxcermta1.p xxcepmta.p 2.零件修改最后日期和人不变；
V xxrqrqmta.p 3.申请单第二项采购账户取值不正确；
*/
/*---Add End   by davild 20080722.1*/
/*---Add Begin by davild 20080715.1*/
/*
V xxpopom1d.p 1.若需求和到期日期为空则为TODAY*/
/*---Add End   by davild 20080715.1*/

/*---Add Begin by davild 20080624.1*/
/*
xxcepomt.p（popomt.p）
	xxcerpomt.p(pomt.p)
		xxcepopomtb.p(popomtb.p)	po_DUE_Date 强制为空	f)完成
		xxcepopomta.p(popomta.p)				g)完成
			xxcepopomtr.p(popomtr.p)
				xxcepopomtr1.p(popomtr1.p)	到期日期转	f)完成		
			xxcepopomtea.p(popomtea.p)
			xxcepopomtd.p(popomtd.p)	c)b)a)d)

a)首先判断5.2.1.24是否启动CER检验，若没有启动，处理逻辑与修改前一样；
b)在5.2.1.24启动后，若1.4.3中零件不需要CER，处理逻辑与修改前一样；
c)若在CER检查到生效日期小于采购单到期日期（pod_due_date）的非"不合格"CER，用户可以进行采购订单维护，否则提示用不能维护采购订单；
d)对于"M"类型采购，不需要进行CER检验，处理逻辑与修改前一样；
e)将查询到的CER代码，记录到采购订单明细资料中pod__chr08，若是限量采购类型，将已经订购数量记录在pod__dec01和xxcer_ord_qty中，若采购订单数量有修改，也必须修改pod__dec01内容(必须注意，当退换货时，订购数量 - 退货数量 <= 限购数量)。
V xxcepopomtb.p xxcepopomtr1--> f)将采购订单单头需求日期强制置空，以保证用户手工输入采购申请单时申请单需求日期和到期日期自动转为采购订单需求日期和到期日期；{****Davild0623****取申请单号的需求日期和到期日期}
g)采购订单明细中的税用途(pod_tax_usage)和纳税类型(pod_taxc)默认取值采购订单单头对应值(po_taxc/po_tax_usage)，用户可以修改；{****Davild0623****强制与表头一样}
h)若零件净重(pt_net_wt)小于零，则提示用户，该零件不能采购。
20080714
a. 控制参数中没有启动参数时，处理逻辑与修改前一样；
b. 当已经启用采购订单审核流程，只有确认"N"的采购订单，才能修改；
c.审核事务，需要记录在采购订单历史记录中；
d. 已经确认的"Y"的采购订单，不能修改。若订单需要修改，必须需要先取消确认。若用户修改确认的采购订单，提示"采购订单已审核，请先取消审核"并拒绝修改。
*/
/*---Add End   by davild 20080624.1*/

/* ss-081226.1 jack */
/* ss-081230.1 jack */
/* ss-090104.1 jack */
/* ss-090108.1 jack */
/* ss-090109.1 jack */
/* ss - 090617.1 by: jack */  /* 订单项次取消时也提示是否重新更新成本*/  /*xxpopom1d.p */
/* ss - 091105.1 by: jack */  
/* SS - 110104.1  By: Roger Xiao */  /*old-prog-name xxpopom1.p , New_po only if vd__chr03 = "AC" */
/* SS - 110223.1  By: Roger Xiao */ /*just xxpopom1a.p: pod_taxable = po_taxable ;xxpopom1r1.p : cancel p_pod_disc_pct */
/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}

/* INPUT OF FALSE MEANS THIS IS NOT A BLANKET PURCHASE ORDER */
{gprun.i ""xxpopom1t.p"" "(input false)"}	/*---Add by davild 20080624.1*/
