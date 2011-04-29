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
V xxcermta1.p xxcepmta.p 2) �������,���NG��ԭ���������ά�����޸ġ���Ʒ�ߡ�˵����������λ��װ��ߴ硱��λ����޸����ں��޸��˶����䣬��ͼ6
V xxpopom1a.p 1.�ɹ�������JZY2��ͷ�����Ϻſ��Բ�����������
V xxpopom1b.p  ȷ��״̬Ĭ��ΪN���Ҳ������޸�
δ���˴����°汾��MARTIN V xxoiointd.p û����Ч���ڵ�CER
V xxcermta1.p xxcepmta.p 2.����޸�������ں��˲��䣻
V xxrqrqmta.p 3.���뵥�ڶ���ɹ��˻�ȡֵ����ȷ��
*/
/*---Add End   by davild 20080722.1*/
/*---Add Begin by davild 20080715.1*/
/*
V xxpopom1d.p 1.������͵�������Ϊ����ΪTODAY*/
/*---Add End   by davild 20080715.1*/

/*---Add Begin by davild 20080624.1*/
/*
xxcepomt.p��popomt.p��
	xxcerpomt.p(pomt.p)
		xxcepopomtb.p(popomtb.p)	po_DUE_Date ǿ��Ϊ��	f)���
		xxcepopomta.p(popomta.p)				g)���
			xxcepopomtr.p(popomtr.p)
				xxcepopomtr1.p(popomtr1.p)	��������ת	f)���		
			xxcepopomtea.p(popomtea.p)
			xxcepopomtd.p(popomtd.p)	c)b)a)d)

a)�����ж�5.2.1.24�Ƿ�����CER���飬��û�������������߼����޸�ǰһ����
b)��5.2.1.24��������1.4.3���������ҪCER�������߼����޸�ǰһ����
c)����CER��鵽��Ч����С�ڲɹ����������ڣ�pod_due_date���ķ�"���ϸ�"CER���û����Խ��вɹ�����ά����������ʾ�ò���ά���ɹ�������
d)����"M"���Ͳɹ�������Ҫ����CER���飬�����߼����޸�ǰһ����
e)����ѯ����CER���룬��¼���ɹ�������ϸ������pod__chr08�����������ɹ����ͣ����Ѿ�����������¼��pod__dec01��xxcer_ord_qty�У����ɹ������������޸ģ�Ҳ�����޸�pod__dec01����(����ע�⣬���˻���ʱ���������� - �˻����� <= �޹�����)��
V xxcepopomtb.p xxcepopomtr1--> f)���ɹ�������ͷ��������ǿ���ÿգ��Ա�֤�û��ֹ�����ɹ����뵥ʱ���뵥�������ں͵��������Զ�תΪ�ɹ������������ں͵������ڣ�{****Davild0623****ȡ���뵥�ŵ��������ں͵�������}
g)�ɹ�������ϸ�е�˰��;(pod_tax_usage)����˰����(pod_taxc)Ĭ��ȡֵ�ɹ�������ͷ��Ӧֵ(po_taxc/po_tax_usage)���û������޸ģ�{****Davild0623****ǿ�����ͷһ��}
h)���������(pt_net_wt)С���㣬����ʾ�û�����������ܲɹ���
20080714
a. ���Ʋ�����û����������ʱ�������߼����޸�ǰһ����
b. ���Ѿ����òɹ�����������̣�ֻ��ȷ��"N"�Ĳɹ������������޸ģ�
c.���������Ҫ��¼�ڲɹ�������ʷ��¼�У�
d. �Ѿ�ȷ�ϵ�"Y"�Ĳɹ������������޸ġ���������Ҫ�޸ģ�������Ҫ��ȡ��ȷ�ϡ����û��޸�ȷ�ϵĲɹ���������ʾ"�ɹ���������ˣ�����ȡ�����"���ܾ��޸ġ�
*/
/*---Add End   by davild 20080624.1*/

/* ss-081226.1 jack */
/* ss-081230.1 jack */
/* ss-090104.1 jack */
/* ss-090108.1 jack */
/* ss-090109.1 jack */
/* ss - 090617.1 by: jack */  /* �������ȡ��ʱҲ��ʾ�Ƿ����¸��³ɱ�*/  /*xxpopom1d.p */
/* ss - 091105.1 by: jack */  
/* SS - 110104.1  By: Roger Xiao */  /*old-prog-name xxpopom1.p , New_po only if vd__chr03 = "AC" */
/* SS - 110223.1  By: Roger Xiao */ /*just xxpopom1a.p: pod_taxable = po_taxable ;xxpopom1r1.p : cancel p_pod_disc_pct */
/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}

/* INPUT OF FALSE MEANS THIS IS NOT A BLANKET PURCHASE ORDER */
{gprun.i ""xxpopom1t.p"" "(input false)"}	/*---Add by davild 20080624.1*/
