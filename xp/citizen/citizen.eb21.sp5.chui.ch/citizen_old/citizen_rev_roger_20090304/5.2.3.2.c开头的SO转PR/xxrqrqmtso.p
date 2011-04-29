/* rqrqmt.p   - REQUISITION MAINTENANCE                                       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.2.1.2 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* Revision: 8.6    LAST MODIFIED BY: 04/22/97  By: Bill Gates        *J1Q2*  */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98     BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00     BY: *N0KP* Mark Brown         */
/* $Revision: 1.2.1.2 $  BY: Jean Miller         DATE: 12/05/01  ECO: *P039*  */


/* LAST MODIFIED: 2008/06/13   BY: Softspeed roger xiao  ECO:*xp001*          */  /*仅限C开头的PR号,自动找同号的SO,copy其中so_part为采购件的SO项次到PR*/
/*xp001
2.	客户化逻辑
A)	SO 转成 PR
条件 : 订单号码开头为  C  
          采购(P)件的物料才产生PR
          PR 数量 = SO 数量 (不考虑其它条件 :库存/......)  
B)	PR 号码 = SO 号码 ，PR LINE = SO LINE

备注：
1）销售订单自动转化为采购申请单时，采购申请单明细的供应商默认取自1.4.17的供应商；如1.4.17没有设置则取自1.4.7的供应商。
*/

/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "b+ "}

{gprun.i ""xxrqrqmt0so.p""} /*xp001*/
