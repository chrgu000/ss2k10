/* sosois.p - SALES ORDER SHIPMENT WITH SERIAL NUMBERS                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7.2.3 $                                                               */
/*                                                                            */
/* REVISION: 6.0      LAST MODIFIED: 03/14/90   BY: emb *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 03/14/90   BY: WUG *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 04/30/90   BY: MLB *D021*                */
/* REVISION: 6.0      LAST MODIFIED: 12/17/90   BY: WUG *D447*                */
/* REVISION: 6.0      LAST MODIFIED: 01/14/91   BY: emb *D313*                */
/* REVISION: 6.0      LAST MODIFIED: 02/18/91   BY: afs *D354*                */
/* REVISION: 6.0      LAST MODIFIED: 03/18/91   BY: MLB *D443*                */
/* REVISION: 6.0      LAST MODIFIED: 04/03/91   BY: afs *D477*   (rev only)   */
/* REVISION: 6.0      LAST MODIFIED: 04/08/91   BY: afs *D497*                */
/* REVISION: 6.0      LAST MODIFIED: 04/09/91   BY: afs *D510*                */
/* REVISION: 6.0      LAST MODIFIED: 05/09/91   BY: emb *D643*                */
/* REVISION: 6.0      LAST MODIFIED: 05/28/91   BY: emb *D661*                */
/* REVISION: 6.0      LAST MODIFIED: 06/04/91   BY: emb *D673*                */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*                */
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: MLV *F029*                */
/* REVISION: 7.0      LAST MODIFIED: 11/13/91   BY: WUG *D887*                */
/* REVISION: 7.0      LAST MODIFIED: 11/18/91   BY: WUG *D858*                */
/* REVISION: 7.0      LAST MODIFIED: 11/18/91   BY: WUG *D953*                */
/* REVISION: 7.0      LAST MODIFIED: 11/25/91   BY: SAS *F017*                */
/* REVISION: 7.0      LAST MODIFIED: 02/19/91   BY: afs *F209*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 02/26/92   BY: afs *F240*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 03/05/92   BY: afs *F247*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 03/18/92   BY: TMD *F263*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 03/26/92   BY: dld *F297*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 04/08/92   BY: tmd *F367*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 04/16/92   BY: tjs *F405*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 05/01/92   BY: afs *F459*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 06/04/92   BY: tjs *F504*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 06/19/92   BY: tmd *F458*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 06/25/92   BY: sas *F595*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 06/29/92   BY: afs *F674*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 06/30/92   BY: tjs *F646*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 07/06/92   BY: tjs *F726*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 07/06/92   BY: tjs *F732*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 07/23/92   BY: tjs *F805*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 07/29/92   BY: emb *F817*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 08/24/92   BY: tjs *F859*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 09/12/92   BY: tjs *G035*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 09/25/92   BY: tjs *G087*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 10/21/92   BY: afs *G218*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 10/21/92   BY: afs *G219*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 11/09/92   BY: emb *G292*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 11/09/92   BY: afs *G302*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 11/16/92   BY: tjs *G318*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 01/12/92   BY: tjs *G536*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 01/26/93   BY: afs *G595*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 02/09/93   BY: bcm *G424*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 02/19/93   BY: tjs *G702*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 03/12/93   BY: tjs *G451*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 03/18/93   BY: afs *G818*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 04/12/93   BY: tjs *G935*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 04/13/93   BY: tjs *G946*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 04/26/93   BY: WUG *GA39*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 05/05/93   BY: afs *GA57*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 05/19/93   BY: kgs *GB22*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 05/19/93   BY: kgs *GB24*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 06/09/93   BY: sas *GB82*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 07/01/93   BY: cdt *GC90*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 07/02/93   BY: jjs *GC96*   (rev only)   */
/* REVISION: 7.4      LAST MODIFIED: 07/02/93   BY: jjs *H019*   (rev only)   */
/* REVISION: 7.4      LAST MODIFIED: 07/03/93   BY: bcm *H002*   (rev only)   */
/* REVISION: 7.4      LAST MODIFIED: 08/13/93   BY: dpm *H069*   (rev only)   */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*   (rev only)   */
/* REVISION: 7.4      LAST MODIFIED: 10/4/93    BY: dpm *H075*   (rev only)   */
/* REVISION: 7.4      LAST MODIFIED: 10/28/93   BY: dpm *H067*   (rev only)   */
/* REVISION: 7.4      LAST MODIFIED: 11/14/93   BY: afs *H222*   (rev only)   */
/* REVISION: 7.4      LAST MODIFIED: 11/22/93   BY: tjs *H237*   (rev only)   */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: aal *K001*                */
/* REVISION: 8.5      LAST MODIFIED: 06/13/96   BY: *G1Y6* Sue Poland         */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.7.2.2    BY: John Corda           DATE: 08/12/02  ECO: *N1QP*  */
/* $Revision: 1.7.2.3 $   BY: Dorota Hohol   DATE: 02/25/03  ECO: *P0N6* */
/* $Revision: 1.7.2.3 $   BY: Micho Yang         DATE: 08/23/08  ECO: *SS - 20080823.1* */
/* $Revision: 1.7.2.3 $   BY: Micho Yang         DATE: 10/27/08  ECO: *SS - 20081027.1* */
/* $Revision: 1.7.2.3 $   BY: Micho Yang         DATE: 11/14/08  ECO: *SS - 20081114.1* */
/* $Revision: 1.7.2.3 $   BY: Micho Yang         DATE: 11/18/08  ECO: *SS - 20081118.1* */
/* $Revision: 1.7.2.3 $   BY: Micho Yang         DATE: 11/20/08  ECO: *SS - 20081120.1* */
/* $Revision: 1.7.2.3 $   BY: Micho Yang         DATE: 11/27/08  ECO: *SS - 20081127.1* */
/* SS - 20081202.1 By: Micho Yang */
/* SS - 20081205.1 By: Micho Yang */
/* SS - 20081208.1 By: Micho Yang */
/* SS - 20081215.1 By: Micho Yang */
/* SS - 20081219.1 By: Micho Yang */
/* SS - 20081226.1 By: Micho Yang */
/* SS - 20090114.1 By: Micho Yang */
/* SS - 20090223.1 By: Micho Yang */
/* SS - 20090226.1 By: Micho Yang */
/* SS - 20090303.1 By: Micho Yang */
/* SS - 20090304.1 By: Micho Yang */
/* SS - 20090305.1 By: Micho Yang */
/* SS - 20090721.1 update By: Micho Yang                          */
/*ss - 101124.1 by ken */
/*
  FIX When input second Loading, if input not existed line no, the program will abnormally abort to menu screen
*/

/* SS - 20090721.1 - B */
/*
取消 fill_all = yes
*/
/* SS - 20090721.1 - E */                                    
                                    
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20090305.1 - B */
/*
1. validation sequence
2. reset effdate v_bill v_dn
3. vv_site 
*/
/* SS - 20090305.1 - E */

/* SS - 20090304.1 - B */
/*
global_site  问题
*/
/* SS - 20090304.1 - E */

/* SS - 20090303.1 - B */
/*
单位换算时，小数尾差的问题  （xxsosoisd.p)
*/
/* SS - 20090303.1 - E */

/* SS - 20090226.1 - B */
/*
1. update global site variable EVERYTIME a new SO# is selected.
2. Sales Order add item cannot get the conversion factor (happen occasionally)
check xxsosois/un/rc/ad prg, when UOM conversion not matched 
case 1: SO UM = item UM & conv.factor <> 1
Case 2: SO UM <> item UM & conv.factor not match
ERROR 4982 No unit of measure conversion exists for measurement
*/   
/* SS - 20090226.1 - E */
                      
/* SS - 20090223.1 - B */
/*
Allow update Bill-To with same update logic in xxsosomt
  - check customer type
  - update to ship-to
AND update new bill-to to SO maintenance

Rationale: Minimise Retail Users input effort from navigating between 
xxsosomt- 
xxsosois/xxsosoun/xxsosorc/xxsosoad 
especially for Gas station order.
*/
/* SS - 20090223.1 - E */

/* SS - 20090114.1 - B */
/*
不准許通過客戶 Type:X 
cm_type = "X"
*/
/* SS - 20090114.1 - E */

/* SS - 20081226.1 - B */
/*
ldd_det 
*/
/* SS - 20081226.1 - E */

/* SS - 20081219.1 - B */
/*
a.effective date must > postdate
*/
/* SS - 20081219.1 - E */
                         
/* SS - 20081215.1 - B */
/*
显示 tr_user1 和 tr_user2
*/
/* SS - 20081215.1 - B */

/* SS - 20081208.1 - B */
/*
98              xxsoso*         1               1. only allow integer qty               New             2008/12/5 phone Micho by Tommy
*/
/* SS - 20081208.1 - E */

/* SS - 20081205.1 - B */
/* 
取消 四舍五入的警告    sosoisc.p soistr12.p
*/                                                                          
/* SS - 20081205.1 - E */

/* SS - 20081202.1 - B */
/*   
NEW Request
Add ONE more checking for DN ID & Rtn#
2142 Duplicate record exists.  Cannot create
  */
/* SS - 20081202.1 - E */  

/* SS - 20081127.1 - B */
/*
1. not allow update bill-to & ship-to
2. header location : not allow blank,and check security from 3.24.24
3. not allow update item location
*/
/* SS - 20081127.1 - E */

/* SS - 20081120.1 - B */
/*
保留订单中的数量(tr__dec01)和单位(tr__chr01)
*/
/* SS - 20081120.1 - E */

/* SS - 20081118.1 - B */
/*
New Request:
   2. xxsosois, xxsosoun, xxsosorc, xxsosoad: Header Location: NOT allow BLANK
*/
/* SS - 20081118.1 - E */

/* SS - 20081114.1 - B */
/* 
新增了配置产品的处理
*/
/* SS - 20081114.1 - E */

/* SS - 20081027.1 - B */
/*
Another feedback from user testing, if possible when Qty ordered = 0,      
do not show following warning                                              
(note that we will import zero Qty ordered for empty bottle & plastic crate)
622
 WARNING: Qty shipped + Qty to ship is greater than Qty ordered.            
(in xxsosois & xxsosoun)                                                    
90002
 WARNING: 90002 - Qty returned + Qty to return is greater than Qty ordered.
(in xxsosorc & xxsosoad)
*/
/* SS - 20081027.1 - E */

                         
/* SS - 20080823.1 - B */
/*
仅适用于非指定"Category[sod_order_category]"的行
且只允许输入正数

指定"Category[sod_order_category]"通过以下程序维护
  - COPS Interface Control [xxsoipm.p]
  
默认发货为短缺量
在头栏增加并允许维护以下字段:
  - Bill To[so_bill]:Driver,保存于"tr_ship_inv_mov"
  - Ship-To[so_ship]:Truck,保存于"tr_ship_id"
  - Location[ship_loc]:为行指定默认值
  - DN No.[shp-id]:保存于"tr_so_job" 不允许为空
按以下顺序修改浏览字段(20080726.1:应用于字段"line"):
  - Ln
  - Item Number
  - UM(替换T)
  - Qty Ordered(替换Qty Alloc,同时取消Qty Picked)
  - Shipped   保存于 sod__dec02
  - Backorder 短缺量
  - To ship 
  - Category(替换Site)
*/                                                                          
/* SS - 20080823.1 - E */


/* SS - 101124.1 B*/
/*
{mfdtitle.i "090721.1"}
*/
{mfdtitle.i "101124.1"}
/* SS - 101124.1 E*/

{cxcustom.i "SOSOIS.P"}
{sosois1.i new}

{gldydef.i new}
{gldynrm.i new}
{&SOSOIS-P-TAG1}

/* PREVIOUSLY, THE USER COULD SHIP SO'S OR RMA'S WITH SOSOIS.P. */
/* NOW, ONLY SO'S MAY BE SHIPPED WITH SOSOIS.P.  RMA'S ARE      */
/* SHIPPED IN FSRMASH.P.                                        */

sorec = fssoship.

/* SS - 20080823.1 - B */
{gprun.i ""xxsosoismun.p""}
/* SS - 20080823.1 - E */
