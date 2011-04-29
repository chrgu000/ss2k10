/* xxptstkrp02.p - INVOICE/PURCHASE COST VARIANCE REPORT                      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.9.1.7 $                                                       */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 4.0        LAST EDIT: 01/14/87    MODIFIED BY: FLM               */
/* REVISION: 6.0    LAST MODIFIED: 06/28/91    BY: MLV *D733*                 */
/* REVISION: 7.0    LAST MODIFIED: 07/30/91    BY: MLV *F001*                 */
/* REVISION: 7.0    LAST MODIFIED: 08/14/92    BY: MLV *F847*                 */
/* REVISION: 7.3    LAST MODIFIED: 05/17/93    BY: JJS *GB03* (rev only)      */
/*                                 06/21/93    by: jms *GC52* (rev only)      */
/*                                 04/10/96    by: jzw *G1LD*                 */
/* REVISION: 8.6    LAST MODIFIED: 10/11/97    BY: ckm *K0SY*                 */
/* REVISION: 8.6    LAST MODIFIED: 10/20/97    BY: *H1FW* Samir Bavkar        */
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane           */
/* REVISION: 8.6E   LAST MODIFIED: 04/10/98    BY: *L00K* RVSL                */
/* REVISION: 8.6E   LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan          */
/* REVISION: 9.0    LAST MODIFIED: 03/10/99    BY: *M0B3* Michael Amaladhas   */
/* REVISION: 9.0    LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan          */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1    LAST MODIFIED: 08/11/00    BY: *N0KK* jyn                 */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.9.1.6    BY: Katie Hilbert     DATE: 03/12/03  ECO: *P0NL*    */
/* $Revision: 1.9.1.7 $    BY: Subramanian Iyer  DATE: 11/24/03  ECO: *P13Q*    */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* $Revision: eb21sp4   BY: Davild Xu   DATE: 20061103  ECO: SS - 20061103.1 */
/* $Revision: eb21sp4   BY: Davild Xu   DATE: 20070118  ECO: SS - 20070118.1 */
/* Add By:  SS - 20070118.1 Begin */
/* $Revision: eb21sp4   BY: Micho Yang  DATE: 20070228  ECO: SS - 20070228.1 */
/* $Revision: eb21sp4   BY: Micho Yang  DATE: 20070308  ECO: SS - 20070308.1 */
/* $Revision: eb21sp4   BY: Micho Yang  DATE: 20070308  ECO: SS - 20070310.1 */
/* $Revision: eb21sp4   BY: Micho Yang  DATE: 20070308  ECO: SS - 20070425.1 */
/* $Revision: eb21sp4   BY: Micho Yang  DATE: 04/28/07  ECO: SS - 20070428.1 */
/* SS - 091014.1 By: Bill Jiang */
/* SS - 091020.1 By: Bill Jiang */
/* SS - 100407.1  By: Roger Xiao */  /*�������Ľ���,��Ҫ��"ovh post"��trgl��¼,��Ϊ���Ǽ�ӷ����Ѿ�������rct-wo��*/





/* SS - 091020.1 - RNB
[091020.1]

������"ISS-TR ���˵�ת"��һ��BUG.

[091020.1]

SS - 091020.1 - RNE */

/* SS - 091014.1 - RNB
[091014.1]

������QAD��׼����(ͨ�����õ��ӳ���a6ppptrp0701.p)��һ��BUG.

[091014.1]

SS - 091014.1 - RNE */

/******************** SS - 20070310.1 - B ********************/
/* ���� ��MITHʹ�ã��硰��̩����ʹ�� 
   ��Ϊ��MITH��ҵʹ�á�xxncsois.p ������ʹ��xxrcsois.p ,
   �����Ҫ�� ��xxrcsois.p" ��Ϊ "xxncsois.p" �����˵�ת��" 
*/
/******************** SS - 20070310.1 - B ********************/

                                                                         
/******************** SS - 20070310.1 - B ********************/
/*
�����շ��汨����δ�������ϳ���(����״̬��)�������˻�����,���ڱ����˳������������������ʾ,
�������ƿ�ΪISS-TR ���˵�ת���˻���RCT-TR ���˵�ת���˻�лл
  */
/******************** SS - 20070310.1 - E ********************/
  
/******************** SS - 20070308.1 - B ********************/
/*
1��ϵͳ�����ı�����һ�С���λ��������û���κ���ʾ
2�����¼��У��Ƿ���Բ��������������������ɹ��Ľ��Ǳ�׼�ɱ���
�ⲿ�ɹ�-����  �ⲿ�ɹ�-����  �����ڲ��ݹ�    �ⲿ�ݹ�-����  �ⲿ�ݹ�-����
�����ڲ��յ���Ʊ    �ⲿ�յ���Ʊ-����    �ⲿ�յ�Ʊ-����
3������˵���ݹ������⣬������Ҫ��������ʷδ����ݹ�����ʱ������
��12��31���ݹ�Ϊ100 �����ڳ��ݹ���
  1��5���ջ�200
  1��10���յ���Ʊ60
  2��20�������ջ�80

��3��1�ղ鿴����
ѡ������Ϊ��1��1��-1��31��
�򱨱����跴ӳ��
�ɹ�����200
��Ʊ����60
�ݹ�����240
*/
/******************** SS - 20070308.1 - E ********************/

/******************** SS - 20070228.1 - B ********************/
/*
  �����������Ϊ "RCT-TR" ��"ISS-TR" ,��Ҫ���ݵ��ݺŵ�ǰ2�����ϸ��(18.22.3.24 "���ݿ��Ƶ�")
*/
/******************** SS - 20070228.1 - E ********************/

/*
	1.(�ȶ���һ������xxlogpmt.p��ά����������ʱֻ�������Ϳ��ԣ����ɰ�F2����ȡ��)��
	2.ȡ����λ��ʾ�������п�λ���ݼ��ܣ�
	3.�ڼ���ISS-TR��RCT-TR������ʱ��ֻ�е��ݺ�
	  �Ĳ�Ҫ���ܲ��ҿ�λ�ǳ����λ(��λ˵���ĵ�
	  һλ�Ƿ���""@"")
*/
/* Add By:  SS - 20070118.1 End */

/*
	�������� rcttype = "CH" . ���� = "FR"
*/
{mfdtitle.i "100407.1"}
/* Add By:  SS - 20061103.1 Begin */
	/*
	[��Ʒ�����汨��]
	[ѡ������:]										
			
		
										��ע:	
										[1]	"�����ڲ�","�ⲿ����"��"�ⲿ����"���ݹ�Ӧ������ȷ��
										[2]	"�ɹ�"��ʾ���ڲɹ��ջ�		                
		1	�ص�:			��:				[3]	"�ݹ�"��ʾ��ǰ�ݹ����		                
		2	��λ��			��:				[4]	"�յ���Ʊ"��ʾ����ά����ƾ֤���ջ�		
		3	��λ����[6]��					
		4	��Ч����:		��:			
		5	��Ʒ��:			��:			
		6	�����:			��:			

	[����������:]
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	��λ	���	����	���	������λ	��׼�ɱ�	�ڳ�����	�ڳ����	����:ί�п������	����:ί�п����	�����������һ����	�����������һ���	��	��	���ڳ�������һ����	���ڳ�������һ���	��	��

	��δ�������	��δ�����	����:ί�п����δ�������	����:ί�п����δ�����

	�����ڲ��ɹ�[1]	�ⲿ�ɹ�-����[02]	�ⲿ�ɹ�-����[03]	�����ڲ��ݹ�
			
	�ⲿ�ݹ�-����	�ⲿ�ݹ�-����	�����ڲ��յ���Ʊ	�ⲿ�յ���Ʊ-����	�ⲿ�յ�Ʊ-����
		
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	*/

{a6ppptrp0701.i "new"}

DEFINE TEMP-TABLE tta6ictrrp0303
   FIELD tta6ictrrp0303_inv_nbr LIKE tr_rmks
   FIELD tta6ictrrp0303_nbr LIKE tr_nbr
   FIELD tta6ictrrp0303_line LIKE tr_line
   FIELD tta6ictrrp0303_site LIKE tr_site
   FIELD tta6ictrrp0303_pl LIKE tr_prod_line
   FIELD tta6ictrrp0303_part LIKE tr_part
   FIELD tta6ictrrp0303_trnbr LIKE tr_trnbr
   FIELD tta6ictrrp0303_traddr LIKE tr_addr
   FIELD tta6ictrrp0303_lot LIKE tr_lot
   FIELD tta6ictrrp0303_effdate LIKE tr_effdate
   FIELD tta6ictrrp0303_date LIKE tr_date
   FIELD tta6ictrrp0303_type LIKE tr_type
   FIELD tta6ictrrp0303_loc LIKE tr_loc
   FIELD tta6ictrrp0303_qty_dr LIKE tr_qty_loc
   FIELD tta6ictrrp0303_amt_dr LIKE trgl_gl_amt
   FIELD tta6ictrrp0303_qty_cr LIKE tr_qty_loc
   FIELD tta6ictrrp0303_amt_cr LIKE trgl_gl_amt
   FIELD tta6ictrrp0303_program LIKE tr_program /* add by: SS - 20070301.1 */
   FIELD tta6ictrrp0303_ship_type LIKE tr_ship_type                                                                      
   index index1 tta6ictrrp0303_part tta6ictrrp0303_type tta6ictrrp0303_trnbr
   index index2 tta6ictrrp0303_loc tta6ictrrp0303_part tta6ictrrp0303_type tta6ictrrp0303_trnbr
   index index3 tta6ictrrp0303_type
   index index4 tta6ictrrp0303_type tta6ictrrp0303_program tta6ictrrp0303_nbr
   index index5 tta6ictrrp0303_part
   .

DEF TEMP-TABLE tttr 
   FIELD tttr_part LIKE tr_part
   FIELD tttr_rct_loc LIKE tr_loc
   FIELD tttr_rct_trnbr LIKE tr_trnbr
   FIELD tttr_rct_qty_dr LIKE tr_qty_loc
   FIELD tttr_rct_amt_dr LIKE trgl_gl_amt
   FIELD tttr_iss_loc LIKE tr_loc
   FIELD tttr_iss_trnbr LIKE tr_trnbr
   FIELD tttr_iss_qty_dr LIKE tr_qty_loc
   FIELD tttr_iss_amt_dr LIKE trgl_gl_amt
   FIELD tttr_iss_integer AS INTEGER 
   FIELD tttr_rct_integer AS INTEGER 
   INDEX index1 tttr_part 
   .

DEF VAR v_rct_qty LIKE tr_qty_loc .
DEF VAR v_rct_amt LIKE trgl_gl_amt .
DEF VAR v_iss_qty LIKE tr_qty_loc .
DEF VAR v_iss_amt LIKE trgl_gl_amt .
DEF VAR v_rct_integer AS INTEGER .
DEF VAR v_iss_integer AS INTEGER .
DEF VAR v_log1 AS LOGICAL .
DEF VAR v_log2 AS LOGICAL .

define temp-table xxptstkrp02
   field xxptstkrp02_loc			like pt_loc 
   field xxptstkrp02_part			like pt_part
   field xxptstkrp02_desc1			like pt_desc1
   field xxptstkrp02_desc2			like pt_desc2
   field xxptstkrp02_um			like pt_um
   field xxptstkrp02_sct			as   decimal
   /*�ڳ�*/
   field xxptstkrp02_start_qty_oh		like ld_qty_oh		/*����ί�п��Ŀ����*/
   field xxptstkrp02_start_amt		like trgl_gl_amt
   field xxptstkrp02_start_cust_consi_qty	like ld_qty_oh		/*�ڳ��ͻ�ί�п��*/
   field xxptstkrp02_start_cust_consi_amt	like trgl_gl_amt
   /*field xxptstkrp02_start_supp_consi_qty	like ld_qty_oh		/*�ڳ���Ӧ��ί�п��*/
   field xxptstkrp02_start_supp_consi_amt	like trgl_gl_amt	*/
   /*��⼰��������*/
   field xxptstkrp02_rctiss_qty		like ld_qty_oh   extent 60
   field xxptstkrp02_rctiss_amt		like trgl_gl_amt extent 60
   /*��ĩ���*/
   field xxptstkrp02_end_qty_oh		like ld_qty_oh		/*����ί�п��Ŀ����*/
   field xxptstkrp02_end_amt		like trgl_gl_amt
   field xxptstkrp02_end_cust_consi_qty	like ld_qty_oh		/*�ڳ��ͻ�ί�п��*/
   field xxptstkrp02_end_cust_consi_amt	like trgl_gl_amt
   /*field xxptstkrp02_end_supp_consi_qty	like ld_qty_oh		/*�ڳ���Ӧ��ί�п��*/
   field xxptstkrp02_end_supp_consi_amt	like trgl_gl_amt*/
   /*�����ڲ� �ⲿ���� �ⲿ����*/
   field xxptstkrp02_jtnb_rct_qty		like ld_qty_oh	/*�����ڲ��ɹ�*/
   field xxptstkrp02_wbjk_rct_qty		like ld_qty_oh
   field xxptstkrp02_wbgn_rct_qty		like ld_qty_oh
   field xxptstkrp02_jtnb_tmp_qty		like ld_qty_oh	/* �����ڲ��ݹ� = �����ڲ��ɹ� - �����ڲ���Ʊ */
   field xxptstkrp02_wbjk_tmp_qty		like ld_qty_oh
   field xxptstkrp02_wbgn_tmp_qty		like ld_qty_oh
   field xxptstkrp02_jtnb_inv_qty		like ld_qty_oh	/*�����ڲ���Ʊ*/
   field xxptstkrp02_wbjk_inv_qty		like ld_qty_oh
   field xxptstkrp02_wbgn_inv_qty		like ld_qty_oh
   /*�����ڲ� �ⲿ���� �ⲿ���� ���*/
   field xxptstkrp02_jtnb_rct_amt		like trgl_gl_amt	/*�����ڲ��ɹ�*/
   field xxptstkrp02_wbjk_rct_amt		like trgl_gl_amt
   field xxptstkrp02_wbgn_rct_amt		like trgl_gl_amt
   field xxptstkrp02_jtnb_tmp_amt		like trgl_gl_amt	/* �����ڲ��ݹ� = �����ڲ��ɹ� - �����ڲ���Ʊ */
   field xxptstkrp02_wbjk_tmp_amt		like trgl_gl_amt
   field xxptstkrp02_wbgn_tmp_amt		like trgl_gl_amt
   field xxptstkrp02_jtnb_inv_amt		like trgl_gl_amt	/*�����ڲ���Ʊ*/
   field xxptstkrp02_wbjk_inv_amt		like trgl_gl_amt
   field xxptstkrp02_wbgn_inv_amt		like trgl_gl_amt
   index index1  	xxptstkrp02_part
   .		/* Add By:  SS - 20070118.1 */

define temp-table tt	
   /*
   ���������񼰳���������	
   1 rct-po
   2 rct-unp
   3 iss-so
   4 iss-wo
   �ȵ�
   */
   field tt_integer	 as integer
   field tt_trtype		as char 
   field tt_trtype_name as char 
   FIELD tt_class       AS CHAR 
   index index1 tt_integer tt_trtype 
   .

/* Add By:  SS - 20061103.1 End */
define variable site     like prh_site     no-undo.
define variable site1    like prh_site     no-undo.
define variable loc	 like ld_loc       no-undo.
define variable loc1	 like ld_loc       no-undo.
define variable locgroup as char format "x(30)" .

define variable idate    like vph_inv_date no-undo.
define variable idate1   like vph_inv_date no-undo.
define variable line     like pt_prod_line no-undo.
define variable line1    like pt_prod_line no-undo.
define variable part     like prh_part     no-undo.
define variable part1    like prh_part     no-undo.
define variable vendor   like prh_vend     no-undo.
define variable vendor1  like prh_vend     no-undo.
define variable rcttype as char .
define variable ii as inte .
define variable maxii as inte .
define variable v_yn as logi.

/*a6apicrp02 var*/
define  variable buyer    like prh_buyer    no-undo.
define  variable buyer1   like prh_buyer    no-undo.
define  variable order    like prh_nbr      no-undo.
define  variable order1   like prh_nbr      no-undo.
define  variable sel_inv  like mfc_logical  no-undo
                          label "Inventory Items" initial yes.
define  variable sel_sub  like mfc_logical  no-undo
                          label "Subcontracted Items" initial yes.
define  variable sel_mem  like mfc_logical  no-undo
                          label "Memo Items" initial no.
define  variable sel_neg  like mfc_logical  no-undo
                                    label "Include Returns" initial no.

/*a6ppptrp0701 var*/
define variable abc		like pt_abc       no-undo.
define variable abc1		like pt_abc       no-undo.
define variable part_group    like pt_group     no-undo.
define variable part_group1   like pt_group     no-undo.
define variable part_type     like pt_part_type no-undo.
define variable part_type1    like pt_part_type no-undo.
define variable as_of_date        like tr_effdate no-undo.
define variable neg_qty       like mfc_logical initial yes
   label "Include Negative Inventory" no-undo.
define variable net_qty       like mfc_logical initial yes
   label "Include Non-nettable Inventory" no-undo.
define variable inc_zero_qty  like mfc_logical initial no
   label "Include Zero Quantity" no-undo.
define variable zero_cost     like mfc_logical initial yes
   label "Accept Zero Initial Cost" no-undo.
/* CONSIGNMENT VARIABLES */
{pocnvars.i}
{pocnvar2.i}

/*a6ictrrp0301*/
define variable glref  like trgl_gl_ref.
define variable glref1 like trgl_gl_ref.
define variable efdate like tr_effdate.
define variable efdate1 like tr_date.
define variable trtype like tr_type.
define variable entity like en_entity.
define variable entity1 like en_entity.
define variable acct like glt_acct.
define variable acct1 like glt_acct.
define variable sub like glt_sub.
define variable sub1 like glt_sub.
define variable proj like glt_project.
define variable proj1 like glt_project.
define variable cc like glt_cc.
define variable cc1 like glt_cc.
define variable trdate like tr_date.
define variable trdate1 like tr_date.

DEF VAR v_idate LIKE tr_date .
DEF TEMP-TABLE tt2 
   FIELD tt2_part LIKE tr_part
   field tt2_jtnb_rct_qty		like ld_qty_oh	/*�����ڲ��ɹ�*/
   field tt2_wbjk_rct_qty		like ld_qty_oh
   field tt2_wbgn_rct_qty		like ld_qty_oh
   field tt2_jtnb_inv_qty		like ld_qty_oh	/*�����ڲ���Ʊ*/
   field tt2_wbjk_inv_qty		like ld_qty_oh
   field tt2_wbgn_inv_qty		like ld_qty_oh
   field tt2_jtnb_rct_amt		like trgl_gl_amt	/*�����ڲ��ɹ�*/
   field tt2_wbjk_rct_amt		like trgl_gl_amt
   field tt2_wbgn_rct_amt		like trgl_gl_amt
   field tt2_jtnb_inv_amt		like trgl_gl_amt	/*�����ڲ���Ʊ*/
   field tt2_wbjk_inv_amt		like trgl_gl_amt
   field tt2_wbgn_inv_amt		like trgl_gl_amt
   INDEX ipart tt2_part
   .

DEF TEMP-TABLE tt3 
   FIELD tt3_type LIKE tr_type
   FIELD tt3_program LIKE tr_program
   FIELD tt3_nbr LIKE tr_nbr
   INDEX nbr1 tt3_type tt3_program tt3_nbr 
   .

def var v_jtnb_tmp_qty like ld_qty_oh.
def var v_wbjk_tmp_qty like ld_qty_oh.
def var v_wbgn_tmp_qty like ld_qty_oh.
def var v_jtnb_tmp_amt like trgl_gl_amt.
def var v_wbjk_tmp_amt like trgl_gl_amt.
def var v_wbgn_tmp_amt like trgl_gl_amt.

/* THE FIELD LABEL OF THE DATE SELECTION CHANGED FROM INVOICE DATE */
/* TO EFFECTIVE.                                                   */

FORM
   site		colon 15               
   site1	label {t001.i} colon 49
   loc		colon 15               
   loc1		label {t001.i} colon 49
   locgroup	label "��λ����" colon 15
   
   idate	label "Effective" colon 15      
   idate1	label "To"        colon 49 skip 
   line		colon 15                    
   line1	label {t001.i} colon 49 skip
   part		colon 15                    
   part1	label {t001.i} colon 49 skip
   /*   vendor	colon 15                    
   vendor1	label {t001.i} colon 49 skip
   */
   with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
	hide all no-pause .
	view frame dtitle .

   if idate   = low_date then idate = ?.
   if idate1  = hi_date then idate1 = ?.
   if vendor1 = hi_char then vendor1 = "".
   if loc1    = hi_char then loc1  = "".
   if part1   = hi_char then part1 = "".
   if site1   = hi_char then site1 = "".
   if line1   = hi_char then line1 = "".
   if glref1 = hi_char then glref1 = "".
   if trdate = low_date then trdate = ?.
   if trdate1 = hi_date then trdate1 = ?.
   if acct1  = hi_char then acct1  = "".
   if sub1   = hi_char then sub1   = "".
   if cc1    = hi_char then cc1    = "".
   if proj1  = hi_char then proj1  = "".

   if c-application-mode <> 'web' then
      update
      site		
      site1	
      loc		
      loc1		
      locgroup		              
      idate	
      idate1	
      line		
      line1	
      part		
      part1	
      /*vendor	
      vendor1*/	
      with frame a.

   {wbrp06.i &command = update &fields = " 
      site		
      site1	
      loc		
      loc1		
      locgroup		              
      idate	
      idate1	
      line		
      line1	
      part		
      part1	
      " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      bcdparm = "".

      {mfquoter.i site	}
      {mfquoter.i site1	}
      {mfquoter.i loc	}
      {mfquoter.i loc1	}
      {mfquoter.i locgroup}
      {mfquoter.i idate	}
      {mfquoter.i idate1	}
      {mfquoter.i line	}
      {mfquoter.i line1	}
      {mfquoter.i part	}
      {mfquoter.i part1	}

      if idate = ? then idate = low_date.
      if idate1 = ? then idate1 = hi_date.
      if vendor1 = "" then vendor1 = hi_char.
      if part1 = "" then part1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if loc1    = "" then loc1  = hi_char.
      if line1   = "" then line1 = hi_char.
      if glref1 = "" then glref1 = hi_char.
      if entity1 = "" then entity1 = hi_char.
      if acct1  = "" then acct1  = hi_char.
      if sub1   = "" then sub1   = hi_char.
      if cc1    = "" then cc1    = hi_char.
      if proj1  = "" then proj1  = hi_char.
      if trdate = ? then trdate = low_date.
      if trdate1 = ? then trdate1 = hi_date.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   /*�ڳ����--BEGIN*/
   FOR EACH tta6ppptrp0701:
      DELETE tta6ppptrp0701.
   END.
	
	assign as_of_date = idate - 1 .		/*�ڳ�*/
   {gprun.i ""a6ppptrp0701.p"" "(
      INPUT part,
      INPUT part1,
      INPUT LINE,
      INPUT line1,
      INPUT vendor,
      INPUT vendor1,
      INPUT abc,
      INPUT abc1,
      INPUT site,
      INPUT site1,
      INPUT loc,
      INPUT loc1,
      INPUT part_group,
      INPUT part_group1,
      INPUT part_type,
      INPUT part_type1,
      
      INPUT AS_of_date,
      INPUT neg_qty,
      INPUT net_qty,
      INPUT inc_zero_qty,
      INPUT zero_cost,
      INPUT customer_consign,
      INPUT supplier_consign
      )"}

   /* Remark By:  SS - 20061103.1 Begin ****/
   /*
   EXPORT DELIMITER ";" "site" "loc" "part" "desc" "abc" "qty" "um" "sct" "ext" "Qty_none_consign" "Qty_supp_consign" "Qty_cust_consign".
   FOR EACH tta6ppptrp0701:
      EXPORT DELIMITER ";" tta6ppptrp0701.
   END.
   
   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
   */
   /****** Remark By:  SS - 20061103.1 End */

	FOR EACH tta6ppptrp0701:
		
      /*�ж��Ƿ��ڿ�λ������--BEGIN*/
      run pro_locgroup(input tta6ppptrp0701_loc,locgroup,output v_yn).                        
      if v_yn = no then next .
      /*�ж��Ƿ��ڿ�λ������--END*/

		find first xxptstkrp02 
         where /*xxptstkrp02_loc = tta6ppptrp0701_loc and --ȡ����ʾ��λ*/  /* Remark By:  SS - 20070118.1 */
			xxptstkrp02_part = tta6ppptrp0701_part no-error.
		if avail xxptstkrp02 then do:
			assign 
            xxptstkrp02_start_qty_oh		= xxptstkrp02_start_qty_oh + tta6ppptrp0701_qty_non_consign + tta6ppptrp0701_qty_cust_consign + tta6ppptrp0701_qty_supp_consign
            xxptstkrp02_start_amt		= xxptstkrp02_start_amt + (tta6ppptrp0701_qty_non_consign + tta6ppptrp0701_qty_cust_consign + tta6ppptrp0701_qty_supp_consign) * tta6ppptrp0701_sct 
            xxptstkrp02_start_cust_consi_qty = xxptstkrp02_start_cust_consi_qty + tta6ppptrp0701_qty_cust_consign
            xxptstkrp02_start_cust_consi_amt = xxptstkrp02_start_cust_consi_amt + tta6ppptrp0701_qty_cust_consign * tta6ppptrp0701_sct 
            .
		end.
		else do:
         /*
         find first pt_mstr where pt_domain = global_domain and pt_part = tta6ppptrp0701_part no-lock no-error.
         */
			create xxptstkrp02.
			assign 
            xxptstkrp02_part			= tta6ppptrp0701_part
            xxptstkrp02_sct			= tta6ppptrp0701_sct
            xxptstkrp02_start_qty_oh		= tta6ppptrp0701_qty_non_consign + tta6ppptrp0701_qty_cust_consign + tta6ppptrp0701_qty_supp_consign
            xxptstkrp02_start_amt		= (tta6ppptrp0701_qty_non_consign + tta6ppptrp0701_qty_cust_consign + tta6ppptrp0701_qty_supp_consign) * tta6ppptrp0701_sct 
            xxptstkrp02_start_cust_consi_qty = tta6ppptrp0701_qty_cust_consign
            xxptstkrp02_start_cust_consi_amt = tta6ppptrp0701_qty_cust_consign * tta6ppptrp0701_sct 
            .
		end.
	END.
	/*�ڳ����--END*/
	
	/*��ĩ���--BEGIN*/
   FOR EACH tta6ppptrp0701:
      DELETE tta6ppptrp0701.
   END.
	
	assign as_of_date = idate1 .		/*�ڳ�*/
   {gprun.i ""a6ppptrp0701.p"" "(
      INPUT part,
      INPUT part1,
      INPUT LINE,
      INPUT line1,
      INPUT vendor,
      INPUT vendor1,
      INPUT abc,
      INPUT abc1,
      INPUT site,
      INPUT site1,
      INPUT loc,
      INPUT loc1,
      INPUT part_group,
      INPUT part_group1,
      INPUT part_type,
      INPUT part_type1,
      
      INPUT AS_of_date,
      INPUT neg_qty,
      INPUT net_qty,
      INPUT inc_zero_qty,
      INPUT zero_cost,
      INPUT customer_consign,
      INPUT supplier_consign
      )"}

   /* Remark By:  SS - 20061103.1 Begin ****
   EXPORT DELIMITER ";" "site" "loc" "part" "desc" "abc" "qty" "um" "sct" "ext" "Qty_none_consign" "Qty_supp_consign" "Qty_cust_consign".
   FOR EACH tta6ppptrp0701:
      EXPORT DELIMITER ";" tta6ppptrp0701.
   END.
   
   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
   ****** Remark By:  SS - 20061103.1 End */
	
	FOR EACH tta6ppptrp0701:
      /*�ж��Ƿ��ڿ�λ������--BEGIN*/
      run pro_locgroup(input tta6ppptrp0701_loc,locgroup,output v_yn).
      if v_yn = no then next .
      /*�ж��Ƿ��ڿ�λ������--END*/
		find first xxptstkrp02 where xxptstkrp02_part = tta6ppptrp0701_part no-error.
		if avail xxptstkrp02 then do:
			assign 
            xxptstkrp02_end_qty_oh		= xxptstkrp02_end_qty_oh + tta6ppptrp0701_qty_non_consign + tta6ppptrp0701_qty_cust_consign + tta6ppptrp0701_qty_supp_consign
            xxptstkrp02_end_amt		= xxptstkrp02_end_amt + (tta6ppptrp0701_qty_non_consign + tta6ppptrp0701_qty_cust_consign + tta6ppptrp0701_qty_supp_consign) * tta6ppptrp0701_sct 
            xxptstkrp02_end_cust_consi_qty   = xxptstkrp02_end_cust_consi_qty + tta6ppptrp0701_qty_cust_consign
            xxptstkrp02_end_cust_consi_amt   = xxptstkrp02_end_cust_consi_amt + tta6ppptrp0701_qty_cust_consign * tta6ppptrp0701_sct 
            .
		end.		
	END.
	/*��ĩ���--END*/

	FOR EACH tta6ictrrp0303:
      DELETE tta6ictrrp0303.
   END.
	assign 
      efdate = idate
      efdate1 = idate1 
      .  
   for each tr_hist 
      FIELD( tr_rmks tr_nbr tr_line tr_site tr_prod_line tr_part tr_trnbr tr_addr tr_lot tr_effdate tr_date tr_type tr_loc tr_program tr_qty_loc )
      where tr_hist.tr_domain = global_domain
      AND tr_part >= part 
      AND tr_part <= part1
      AND tr_ship_type = ""
      AND tr_loc >= loc 
      AND tr_loc <= loc1
      AND tr_site >= site 
      AND tr_site <= site1
      AND tr_prod_line >= LINE
      AND tr_prod_line <= LINE1
      and ( 
         (tr_effdate >= efdate and tr_effdate <= efdate1 or tr_effdate = ?)
         and (tr_type = trtype or trtype = "")
         and (tr_date >= trdate and tr_date <= trdate1 or tr_date = ?) 
         ) 
      NO-LOCK 
      ,each trgl_det 
      FIELD( trgl_dr_acct trgl_gl_amt
/* SS - 100407.1 - B */
trgl_type
/* SS - 100407.1 - E */      
      )  
      where trgl_det.trgl_domain = global_domain 
      and ( trgl_trnbr = tr_trnbr
            and ( trgl_gl_ref  >= glref  and trgl_gl_ref  <= glref1)
            and ((trgl_dr_acct >= acct and trgl_dr_acct <= acct1) or (trgl_cr_acct >= acct and trgl_cr_acct <= acct1))
            and ((trgl_dr_sub >= sub and trgl_dr_sub <= sub1) or (trgl_cr_sub >= sub and trgl_cr_sub <= sub1))
            and ((trgl_dr_cc >= cc and trgl_dr_cc <= cc1) or (trgl_cr_cc >= cc and trgl_cr_cc <= cc1))
            and ((trgl_dr_proj >= proj and trgl_dr_proj <= proj1) or (trgl_cr_proj >= proj and trgl_cr_proj <= proj1))  
            )
      NO-LOCK  
      BREAK 
      BY tr_type 
      BY tr_program 
      BY substring(tr_nbr,1,2) 
      BY tr_part 
      :

/* SS - 100407.1 - B */
if tr_type = "rct-wo" and trgl_type = "OVH POST" then next .
/* SS - 100407.1 - E */

      CREATE tta6ictrrp0303.
      ASSIGN
         tta6ictrrp0303_inv_nbr = tr_rmks
         tta6ictrrp0303_nbr     = tr_nbr
         tta6ictrrp0303_line    = tr_line
         tta6ictrrp0303_site    = tr_site
         tta6ictrrp0303_pl      = tr_prod_line
         tta6ictrrp0303_part    = tr_part
         tta6ictrrp0303_trnbr   = tr_trnbr
         tta6ictrrp0303_traddr  = tr_addr
         tta6ictrrp0303_lot     = tr_lot
         tta6ictrrp0303_effdate = tr_effdate
         tta6ictrrp0303_date    = tr_date
         tta6ictrrp0303_type    = tr_type
         tta6ictrrp0303_loc     = tr_loc
         tta6ictrrp0303_program = tr_program /* add by: SS - 20070301.1 */
         .
      IF  (trgl_dr_acct >= acct and trgl_dr_acct <= acct1) THEN DO:
         ASSIGN
            tta6ictrrp0303_qty_dr = tr_qty_loc
            tta6ictrrp0303_amt_dr = trgl_gl_amt
            .
      END.
      ELSE DO:
         ASSIGN
             tta6ictrrp0303_qty_cr = tr_qty_loc
             tta6ictrrp0303_amt_cr = - trgl_gl_amt
             .
      END.
      IF FIRST-OF(substring(tr_nbr,1,2)) THEN DO:
          CREATE tt3 .
          ASSIGN 
              tt3_type = tr_type 
              tt3_program = tr_program
              tt3_nbr = SUBSTRING(tr_nbr,1,2) 
              .
      END.
      IF FIRST-OF(tr_part) THEN DO:
         FIND FIRST xxptstkrp02 WHERE xxptstkrp02_part =tr_part NO-LOCK NO-ERROR.
         IF NOT AVAIL xxptstkrp02 THEN DO:
             create xxptstkrp02.
             assign 
                xxptstkrp02_part			= tr_part
                .
         END.
      END.
   END.

   /* Remark By:  SS - 20061103.1 Begin **** */
   /*   
   EXPORT DELIMITER ";" "inv_nbr" "nbr" "line" "site" "pl" "part" "wo_part" "trnbr" "traddr" "lot" "effdate" "date" "type" "loc" "acct" "sub" "cc" "proj" "qty_dr" "amt_dr" "qty_cr" "amt_cr".
   FOR EACH tta6ictrrp0303:
      EXPORT DELIMITER ";" tta6ictrrp0303.
   END.
   
   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
   */   
   /***** Remark By:  SS - 20061103.1 End */
    
   ii = 1 .
   FOR EACH tt3 
      WHERE (tt3_type = "CYC-RCNT" OR tt3_type = "TAG-CNT") 
      BREAK 
      BY tt3_type 
      :
      if first-of(tt3_type) then do:
         create  tt .
         assign	
            tt_integer = ii 
            tt_trtype  = tt3_type
            tt_class = "TYPE" 
            .
         ii = ii + 1 .
      end.
   END.
	for each tt3 
      where tt3_type >= "RCT" 
      and tt3_type <= "RCTZ" 
      AND tt3_type <> "RCT-TR" 
      break 
      by tt3_type
      :
		if first-of(tt3_type) then do:
			create  tt .
			assign	
            tt_integer = ii 
				tt_trtype  = tt3_type
            tt_class = "TYPE" 
            .
			ii = ii + 1 .
		end.
	end.
	for each tt3 
      where tt3_type = "RCT-TR" 
      AND tt3_nbr <> ""
      ,EACH xdn_ctrl NO-LOCK 
      WHERE xdn_domain = GLOBAL_domain 
      AND xdn_type = tt3_nbr 
      break 
      by tt3_nbr 
      :
		if first-of(tt3_nbr) then do:
			create  tt .
			assign	
            tt_integer = ii 
            tt_trtype  = "RCT-TR " + tt3_nbr 
            tt_class = "NBR" 
            .
			ii = ii + 1 .
		end.
	end.       
   FIND FIRST tt3 WHERE tt3_type = "RCT-TR" AND ( tt3_program = 'xxsocnxfer.p' OR tt3_program = 'socnxfer.p') NO-LOCK NO-ERROR.
   IF AVAIL tt3 THEN DO:
      CREATE tt .
      ASSIGN
         tt_integer = ii
         tt_class = "PROGRAM"
         tt_trtype = "RCT-TR " + "ί�п��ת��"
         .
      ii = ii + 1 .
   END.
   FIND FIRST tt3 WHERE tt3_type = "RCT-TR" AND ( tt3_program = 'xxncsois.p' OR tt3_program = 'xxrcunis.p' OR tt3_program = 'xxkbncsois.p' 
                                                  /* SS - 091020.1 - B */
                                                  OR tt3_program = "xxrcsois.p" 
                                                  OR tt3_program = "rcunis.p" 
                                                  /* SS - 091020.1 - E */
                                                  ) NO-LOCK NO-ERROR.
   IF AVAIL tt3 THEN DO:
      CREATE tt .
      ASSIGN
         tt_integer = ii
         tt_class = "PROGRAM"
         tt_trtype = "RCT-TR " + "���˵�ת��"
         .
      ii = ii + 1 .
   END.
   FIND FIRST tt3 WHERE tt3_type = "RCT-TR" AND ( tt3_program = 'xxrcsoisx2.p') NO-LOCK NO-ERROR.
   IF AVAIL tt3 THEN DO:
      CREATE tt .
      ASSIGN
         tt_integer = ii
         tt_class = "PROGRAM"
         tt_trtype = "RCT-TR " + "���˵�ת���˻�"
         .
      ii = ii + 1 .
   END.
   FIND FIRST tt3 WHERE tt3_type = "RCT-TR" AND ( tt3_program = 'iclotr02.p') NO-LOCK NO-ERROR.
   IF AVAIL tt3 THEN DO:
      CREATE tt .
      ASSIGN
         tt_integer = ii
         tt_class = "PROGRAM"
         tt_trtype = "RCT-TR " + "��һ������ת��"
         .
      ii = ii + 1 .
   END.
	for each tt3 
      where tt3_type >= "ISS" 
      and tt3_type <= "ISSZ" 
      AND tt3_type <> "ISS-TR" 
      break 
      by tt3_type
      :
		if first-of(tt3_type) then do:
			create tt .
			ASSIGN 
            tt_integer = ii 
            tt_trtype  = tt3_type
            tt_class = "TYPE" 
            .
			ii = ii + 1 .
		end.
	end.
	for each tt3 
      WHERE tt3_type = "ISS-TR" 
      AND tt3_nbr <> "" 
      ,EACH xdn_ctrl NO-LOCK 
      WHERE xdn_domain = GLOBAL_domain 
      AND xdn_type = tt3_nbr 
      break 
      by tt3_nbr 
      :
		if first-of(tt3_nbr) then do:
			create  tt .
			assign	
            tt_integer = ii 
            tt_trtype  = "ISS-TR " + tt3_nbr
            tt_class = "NBR"  
            .
			ii = ii + 1 .
		end.
	end.
   FIND FIRST tt3 WHERE tt3_type = "ISS-TR" AND (tt3_program = 'xxsocnxfer.p' OR tt3_program = 'socnxfer.p') NO-LOCK NO-ERROR.
   IF AVAIL tt3 THEN DO:
      CREATE tt .
      ASSIGN
         tt_integer = ii
         tt_class = "PROGRAM"
         tt_trtype = "ISS-TR " + "ί�п��ת��"
         .
      ii = ii + 1 .
   END.
   FIND FIRST tt3 WHERE tt3_type = "ISS-TR" AND (tt3_program = 'xxncsois.p' OR tt3_program = 'xxrcunis.p' OR tt3_program = 'xxkbncsois.p' 
                                                 /* SS - 091020.1 - B */
                                                 OR tt3_program = "xxrcsois.p" 
                                                 OR tt3_program = "rcunis.p" 
                                                 /* SS - 091020.1 - E */
                                                 ) NO-LOCK NO-ERROR.
   IF AVAIL tt3 THEN DO:
      CREATE tt .
      ASSIGN
         tt_integer = ii
         tt_class = "PROGRAM"
         tt_trtype = "ISS-TR " + "���˵�ת��"
         .
      ii = ii + 1 .
   END.
   FIND FIRST tt3 WHERE tt3_type = "ISS-TR" AND (tt3_program = 'xxrcsoisx2.p') NO-LOCK NO-ERROR.
   IF AVAIL tt3 THEN DO:
      CREATE tt .
      ASSIGN
         tt_integer = ii
         tt_class = "PROGRAM"
         tt_trtype = "ISS-TR " + "���˵�ת���˻�"
         .
      ii = ii + 1 .
   END.
   FIND FIRST tt3 WHERE tt3_type = "ISS-TR" AND ( tt3_program = 'iclotr02.p') NO-LOCK NO-ERROR.
   IF AVAIL tt3 THEN DO:
      CREATE tt .
      ASSIGN
         tt_integer = ii
         tt_class = "PROGRAM"
         tt_trtype = "ISS-TR " + "��һ������ת��"
         .
      ii = ii + 1 .
   END.
	maxii = ii - 1 .

	FOR EACH xxptstkrp02 :   
      /* cyc-rcnt tag-cnt  B*/
      FOR EACH tta6ictrrp0303 
         FIELD(tta6ictrrp0303_part tta6ictrrp0303_type tta6ictrrp0303_loc tta6ictrrp0303_trnbr tta6ictrrp0303_qty_dr tta6ictrrp0303_amt_dr)
         WHERE tta6ictrrp0303_part = xxptstkrp02_part 
         AND (tta6ictrrp0303_type = 'CYC-RCNT' OR tta6ictrrp0303_type = 'TAG-CNT') 
         BREAK 
         by tta6ictrrp0303_type 
         by tta6ictrrp0303_trnbr 
         :
         /*�ж��Ƿ��ڿ�λ������--BEGIN*/
         run pro_locgroup(input tta6ictrrp0303_loc,locgroup,output v_yn).
         if v_yn = no then next .

         if not (tta6ictrrp0303_loc >= loc and tta6ictrrp0303_loc <= loc1) then next .
         /*�ж��Ƿ��ڿ�λ������--END*/
         find first tt where tt_trtype = tta6ictrrp0303_type no-error.
         if not avail tt then next .
         else do:         
            if first-of(tta6ictrrp0303_trnbr) then
               assign xxptstkrp02_rctiss_qty[tt_integer] = xxptstkrp02_rctiss_qty[tt_integer] + tta6ictrrp0303_qty_dr .
            assign xxptstkrp02_rctiss_amt[tt_integer] = xxptstkrp02_rctiss_amt[tt_integer] + tta6ictrrp0303_amt_dr .
         end.
      END.
      /* cyc-rcnt tag-cnt  E*/

      /*�����������--BEGIN*/
      for each tta6ictrrp0303 
         FIELD(tta6ictrrp0303_part tta6ictrrp0303_type tta6ictrrp0303_loc tta6ictrrp0303_nbr tta6ictrrp0303_trnbr tta6ictrrp0303_qty_dr tta6ictrrp0303_amt_dr tta6ictrrp0303_program )  
         where tta6ictrrp0303_part = xxptstkrp02_part
         and ((tta6ictrrp0303_type >= "RCT" and tta6ictrrp0303_type <= "RCTZ") /* OR tta6ictrrp0303_type = "ISS-PRV" */ )
         BREAK 
         by tta6ictrrp0303_type 
         by tta6ictrrp0303_trnbr 
         :
         /*�ж��Ƿ��ڿ�λ������--BEGIN*/
         run pro_locgroup(input tta6ictrrp0303_loc,locgroup,output v_yn).
         if v_yn = no then next .            
         if not (tta6ictrrp0303_loc >= loc and tta6ictrrp0303_loc <= loc1) then next .
         /*�ж��Ƿ��ڿ�λ������--END*/
         
         IF tta6ictrrp0303_type <> "RCT-TR" THEN DO: 
            find first tt where tt_trtype = tta6ictrrp0303_type no-error.
            if not avail tt then next .
            else do:         
               if first-of(tta6ictrrp0303_trnbr) then
                  assign xxptstkrp02_rctiss_qty[tt_integer] = xxptstkrp02_rctiss_qty[tt_integer] + tta6ictrrp0303_qty_dr .
               assign xxptstkrp02_rctiss_amt[tt_integer] = xxptstkrp02_rctiss_amt[tt_integer] + tta6ictrrp0303_amt_dr .
            end.
         END.
         ELSE IF tta6ictrrp0303_type = "RCT-TR" THEN DO:
            IF (tta6ictrrp0303_program = "xxsocnxfer.p" OR tta6ictrrp0303_program = "socnxfer.p" ) THEN DO:
               find first tt where tt_trtype = "RCT-TR " + "ί�п��ת��" no-error.
               if not avail tt THEN DO: 
                  next .
               END.
               else do:      
                  if first-of(tta6ictrrp0303_trnbr) THEN
                     assign xxptstkrp02_rctiss_qty[tt_integer] = xxptstkrp02_rctiss_qty[tt_integer] + tta6ictrrp0303_qty_dr .
                  assign xxptstkrp02_rctiss_amt[tt_integer] = xxptstkrp02_rctiss_amt[tt_integer] + tta6ictrrp0303_amt_dr .  
               end.
            END.
            ELSE IF (tta6ictrrp0303_program = "xxncsois.p" OR tta6ictrrp0303_program = "xxrcunis.p" OR tta6ictrrp0303_program = 'xxkbncsois.p' 
                     /* SS - 091020.1 - B */
                     OR tta6ictrrp0303_program = "xxrcsois.p" 
                     OR tta6ictrrp0303_program = "rcunis.p" 
                     /* SS - 091020.1 - E */
                     ) THEN DO:
               find first tt where tt_trtype = "RCT-TR " + "���˵�ת��" no-error.
               if not avail tt THEN DO: 
                  next .
               END.
               else do:      
                  if first-of(tta6ictrrp0303_trnbr) THEN
                     assign xxptstkrp02_rctiss_qty[tt_integer] = xxptstkrp02_rctiss_qty[tt_integer] + tta6ictrrp0303_qty_dr .
                  assign xxptstkrp02_rctiss_amt[tt_integer] = xxptstkrp02_rctiss_amt[tt_integer] + tta6ictrrp0303_amt_dr .  
               end.
            END.
            ELSE IF tta6ictrrp0303_program = "xxrcsoisx2.p" THEN DO:
               find first tt where tt_trtype = "RCT-TR " + "���˵�ת���˻�" no-error.
               if not avail tt THEN DO: 
                  next .
               END.
               else do:      
                  if first-of(tta6ictrrp0303_trnbr) THEN
                     assign xxptstkrp02_rctiss_qty[tt_integer] = xxptstkrp02_rctiss_qty[tt_integer] + tta6ictrrp0303_qty_dr .
                  assign xxptstkrp02_rctiss_amt[tt_integer] = xxptstkrp02_rctiss_amt[tt_integer] + tta6ictrrp0303_amt_dr .  
               end.
            END.
            ELSE IF tta6ictrrp0303_program = "iclotr02.p" THEN DO:
               find first tt where tt_trtype = "RCT-TR " + "��һ������ת��" no-error.
               if not avail tt THEN DO: 
                  next .
               END.
               else do:      
                  if first-of(tta6ictrrp0303_trnbr) THEN
                     assign xxptstkrp02_rctiss_qty[tt_integer] = xxptstkrp02_rctiss_qty[tt_integer] + tta6ictrrp0303_qty_dr .
                  assign xxptstkrp02_rctiss_amt[tt_integer] = xxptstkrp02_rctiss_amt[tt_integer] + tta6ictrrp0303_amt_dr .  
               end.
            END.
            ELSE DO:
               find first tt where tt_trtype = "RCT-TR " + substring(tta6ictrrp0303_nbr,1,2) no-error.
               if not avail tt THEN DO: 
                  next .
               END.
               else do:      
                  /* Add By:  SS - 20070118.1 Begin */
                  IF tta6ictrrp0303_nbr = "" then next .	/*���û�е��ݺ��򲻿���*/ 
                  /*
                  find loc_mstr where loc_domain = global_domain and loc_loc = tta6ictrrp0303_loc no-lock no-error.
                  /*�����λ˵����һλ����@�򲻿���*/
                  if avail loc_mstr and substring(loc_desc,1,1) <> "@" then next .	
                  */
                  /* Add By:  SS - 20070118.1 End */
                  
                  if first-of(tta6ictrrp0303_trnbr) THEN
                     assign xxptstkrp02_rctiss_qty[tt_integer] = xxptstkrp02_rctiss_qty[tt_integer] + tta6ictrrp0303_qty_dr .
                  assign xxptstkrp02_rctiss_amt[tt_integer] = xxptstkrp02_rctiss_amt[tt_integer] + tta6ictrrp0303_amt_dr .  
                  
                  /* "8����������ϸ����ͬһ���������һ����λ������Ŀ�λ֮��ĵ�����ϵͳ�����Զ��������������ڱ�����
                  ���磺��01004���200����01014�⣬���ѡ��01004��01014��������λ��01004��01014��������λ���һ��
                  ��λ���飬�����������ʱѡ�������λ���飬�򱨱��ϵ�ISS-TR TR��RCT-TR TR�����ж�������ʾ200
                  ע�⣺���ֵ���ֻ��ͬ��һ����λ����Ŀ�λ֮��ĵ�����Ч" */
                  IF substring(tta6ictrrp0303_nbr,1,2) = "TR" THEN DO:
                     CREATE tttr .
                     ASSIGN
                        tttr_part = xxptstkrp02_part
                        tttr_rct_loc = tta6ictrrp0303_loc 
                        tttr_rct_trnbr = tta6ictrrp0303_trnbr
                        tttr_rct_qty_dr = - tta6ictrrp0303_qty_dr
                        tttr_rct_amt_dr = - tta6ictrrp0303_amt_dr
                        tttr_rct_integer = tt_integer 
                        .
                  END.
               end. /* else do: */
            END. /* ELSE DO: */
         END. /* ELSE IF tta6ictrrp0303_type = "RCT-TR" THEN DO: */
      END. /* for each tta6ictrrp0303  */
      /*�����������--END*/

		/*���³�������--BEGIN*/
		for each tta6ictrrp0303 
         FIELD(tta6ictrrp0303_part tta6ictrrp0303_type tta6ictrrp0303_loc tta6ictrrp0303_nbr tta6ictrrp0303_trnbr tta6ictrrp0303_qty_dr tta6ictrrp0303_amt_dr tta6ictrrp0303_program ) 
         where tta6ictrrp0303_part = xxptstkrp02_part
         and tta6ictrrp0303_type >= "ISS" 
         and tta6ictrrp0303_type <= "ISSZ"
         BREAK 
         by tta6ictrrp0303_type 
         by tta6ictrrp0303_trnbr 
         :
         /*�ж��Ƿ��ڿ�λ������--BEGIN*/         
         run pro_locgroup(input tta6ictrrp0303_loc,locgroup,output v_yn).
         if v_yn = no then next .               
         if not (tta6ictrrp0303_loc >= loc and tta6ictrrp0303_loc <= loc1) then next .            
         /*�ж��Ƿ��ڿ�λ������--END*/
         
         IF tta6ictrrp0303_type <> "ISS-TR" THEN DO:
            find first tt where tt_trtype = tta6ictrrp0303_type no-error.
            if not avail tt then next .
            else do:         
               if first-of(tta6ictrrp0303_trnbr) then
                  assign xxptstkrp02_rctiss_qty[tt_integer] = xxptstkrp02_rctiss_qty[tt_integer] + tta6ictrrp0303_qty_dr .
               assign xxptstkrp02_rctiss_amt[tt_integer] = xxptstkrp02_rctiss_amt[tt_integer] + tta6ictrrp0303_amt_dr .            
            end.
         END.
         ELSE IF tta6ictrrp0303_type = "ISS-TR" THEN DO:
            IF (tta6ictrrp0303_program = "xxsocnxfer.p" OR tta6ictrrp0303_program = "socnxfer.p" ) THEN DO:
               find first tt where tt_trtype = "ISS-TR " + "ί�п��ת��" no-error.
               if not avail tt THEN DO: 
                  next .
               END.
               else do:
                  if first-of(tta6ictrrp0303_trnbr) then
                     assign xxptstkrp02_rctiss_qty[tt_integer] = xxptstkrp02_rctiss_qty[tt_integer] + tta6ictrrp0303_qty_dr .
                  assign xxptstkrp02_rctiss_amt[tt_integer] = xxptstkrp02_rctiss_amt[tt_integer] + tta6ictrrp0303_amt_dr .            
               END.
            END.
            ELSE IF (tta6ictrrp0303_program = "xxncsois.p" OR tta6ictrrp0303_program = "xxrcunis.p" OR tta6ictrrp0303_program = 'xxkbncsois.p' 
                     /* SS - 091020.1 - B */
                     OR tta6ictrrp0303_program = "xxrcsois.p" 
                     OR tta6ictrrp0303_program = "rcunis.p" 
                     /* SS - 091020.1 - E */
                     ) THEN DO:
               find first tt where tt_trtype = "ISS-TR " + "���˵�ת��" no-error.
               if not avail tt THEN DO: 
                  next .
               END.
               else do:
                  if first-of(tta6ictrrp0303_trnbr) then
                     assign xxptstkrp02_rctiss_qty[tt_integer] = xxptstkrp02_rctiss_qty[tt_integer] + tta6ictrrp0303_qty_dr .
                  assign xxptstkrp02_rctiss_amt[tt_integer] = xxptstkrp02_rctiss_amt[tt_integer] + tta6ictrrp0303_amt_dr .            
               END.
            END.
            ELSE IF tta6ictrrp0303_program = "xxrcsoisx2.p" THEN DO:
               find first tt where tt_trtype = "ISS-TR " + "���˵�ת���˻�" no-error.
               if not avail tt THEN DO: 
                  next .
               END.
               else do:
                  if first-of(tta6ictrrp0303_trnbr) then
                     assign xxptstkrp02_rctiss_qty[tt_integer] = xxptstkrp02_rctiss_qty[tt_integer] + tta6ictrrp0303_qty_dr .
                  assign xxptstkrp02_rctiss_amt[tt_integer] = xxptstkrp02_rctiss_amt[tt_integer] + tta6ictrrp0303_amt_dr .            
               END.
            END.
            ELSE IF tta6ictrrp0303_program = "iclotr02.p" THEN DO:
               find first tt where tt_trtype = "ISS-TR " + "��һ������ת��" no-error.
               if not avail tt THEN DO: 
                  next .
               END.
               else do:
                  if first-of(tta6ictrrp0303_trnbr) then
                     assign xxptstkrp02_rctiss_qty[tt_integer] = xxptstkrp02_rctiss_qty[tt_integer] + tta6ictrrp0303_qty_dr .
                  assign xxptstkrp02_rctiss_amt[tt_integer] = xxptstkrp02_rctiss_amt[tt_integer] + tta6ictrrp0303_amt_dr .            
               END.
            END.
            ELSE DO:
               find first tt where tt_trtype = "ISS-TR " + substring(tta6ictrrp0303_nbr,1,2) no-error.
               if not avail tt THEN DO: 
                  next .
               END.
               else do:
                  /* Add By:  SS - 20070118.1 Begin */
                  if tta6ictrrp0303_nbr = "" then next .	/*���û�е��ݺ��򲻿���*/ 
                  /*
                  find loc_mstr where loc_domain = global_domain and loc_loc = tta6ictrrp0303_loc no-lock no-error.
                  /*�����λ˵����һλ����@�򲻿���*/
                  if avail loc_mstr and substring(loc_desc,1,1) <> "@" then next .	
                  */
                  /* Add By:  SS - 20070118.1 End */
                  if first-of(tta6ictrrp0303_trnbr) then
                     assign xxptstkrp02_rctiss_qty[tt_integer] = xxptstkrp02_rctiss_qty[tt_integer] + tta6ictrrp0303_qty_dr .
                  assign xxptstkrp02_rctiss_amt[tt_integer] = xxptstkrp02_rctiss_amt[tt_integer] + tta6ictrrp0303_amt_dr .            
                  
                  /* "8����������ϸ����ͬһ���������һ����λ������Ŀ�λ֮��ĵ�����ϵͳ�����Զ��������������ڱ�����
                  ���磺��01004���200����01014�⣬���ѡ��01004��01014��������λ��01004��01014��������λ���һ��
                  ��λ���飬�����������ʱѡ�������λ���飬�򱨱��ϵ�ISS-TR TR��RCT-TR TR�����ж�������ʾ200
                  ע�⣺���ֵ���ֻ��ͬ��һ����λ����Ŀ�λ֮��ĵ�����Ч" */
                  IF substring(tta6ictrrp0303_nbr,1,2) = "TR" THEN DO:
                     FIND FIRST tttr WHERE tttr_part = xxptstkrp02_part AND (tttr_rct_trnbr = tta6ictrrp0303_trnbr + 1) NO-ERROR.
                     IF AVAIL tttr THEN DO:
                        ASSIGN
                           tttr_iss_loc = tta6ictrrp0303_loc 
                           tttr_iss_trnbr = tta6ictrrp0303_trnbr
                           tttr_iss_qty_dr = - tta6ictrrp0303_qty_dr
                           tttr_iss_amt_dr = - tta6ictrrp0303_amt_dr
                           tttr_iss_integer = tt_integer 
                           .
                     END.
                  END.
               end. /* else do: */
            END. /* ELSE DO: */
         END. /* ELSE IF tta6ictrrp0303_type = "ISS-TR" THEN DO: */
      END. /* for each tta6ictrrp0303  */
		/*���³�������--END*/
	END.  /*End for each xxptstkrp02*/

	PUT UNFORMATTED "#def REPORTPATH=$/Minth/xxptrp05" SKIP.
	PUT UNFORMATTED "#def :end" SKIP.
	/*Header--BEGIN*/
	define variable max_BI_Field_pcs as inte init 91 .
	max_BI_Field_pcs = 91 .
   PUT UNFORMATTED "#define column1 as char[18]" SKIP.
	PUT UNFORMATTED		"���;"	.
	PUT UNFORMATTED		"����;"	.
	PUT UNFORMATTED		"���;"	.
	PUT UNFORMATTED		"������λ;"	.
	PUT UNFORMATTED		"��׼�ɱ�;"	.		
	PUT UNFORMATTED		"�ڳ�����;"	.
	PUT UNFORMATTED		"�ڳ����;"	.
	PUT UNFORMATTED		"����:ί�п������;" .	
	PUT UNFORMATTED		"����:ί�п����;" .
	for each tt by tt_integer:
      find first code_mstr where code_domain = global_domain and code_fldname = "tr_type" and code_value = tt_trtype no-lock no-error.
      if avail code_Mstr then assign tt_trtype_name = code_cmmt .
      else assign tt_trtype_name = tt_trtype .         
      PUT UNFORMATTED tt_trtype_name + " ����;"   tt_trtype_name + " ���;" .
	end.
	PUT UNFORMATTED	"��δ�������;"			.
	PUT UNFORMATTED	"��δ�����;"			.
	PUT UNFORMATTED	"����:ί�п����δ�������;"	.
	PUT UNFORMATTED	"����:ί�п����δ�����;"	.

	DO ii = 1 to max_BI_Field_pcs - 15 - (maxii * 2) - 1 :
		PUT UNFORMATTED ";" .
	END.  /* END DO */    

	put skip .
	/*Header--END*/
	FOR EACH xxptstkrp02
      /******************** SS - 20070906.1 - B ********************/
      ,EACH pt_mstr 
      WHERE pt_domain = GLOBAL_domain 
      AND pt_part = xxptstkrp02_part 
      NO-LOCK 
      /******************** SS - 20070906.1 - B ********************/ 
      :   
      v_rct_qty = 0.
      v_rct_amt = 0.
      v_iss_qty = 0.
      v_iss_amt = 0.
      v_rct_integer = 0.
      v_iss_integer = 0.
      FOR EACH tttr 
         WHERE tttr_part = xxptstkrp02_part 
         AND tttr_rct_loc <> ""  
         AND tttr_iss_loc <> "" 
         AND tttr_rct_loc >= loc 
         AND tttr_rct_loc <= loc1 
         AND tttr_iss_loc >= loc 
         AND tttr_iss_loc <= loc1 
         :
         v_rct_qty = v_rct_qty + tttr_rct_qty .
         v_rct_amt = v_rct_amt + tttr_rct_amt .
         v_iss_qty = v_iss_qty + tttr_iss_qty .
         v_iss_amt = v_iss_amt + tttr_iss_amt .
         v_rct_integer = tttr_rct_integer .
         v_iss_integer = tttr_iss_integer .
         ASSIGN
            xxptstkrp02_rctiss_qty[v_rct_integer] = v_rct_qty + xxptstkrp02_rctiss_qty[v_rct_integer] 
            xxptstkrp02_rctiss_amt[v_rct_integer] = v_rct_amt + xxptstkrp02_rctiss_amt[v_rct_integer] 
            xxptstkrp02_rctiss_qty[v_iss_integer] = v_iss_qty + xxptstkrp02_rctiss_qty[v_iss_integer] 
            xxptstkrp02_rctiss_amt[v_iss_integer] = v_iss_amt + xxptstkrp02_rctiss_amt[v_iss_integer] 
            .
      END.
      
      v_log1 = NO .
      v_log2 = NO .
      IF (xxptstkrp02_start_qty_oh <> 0 OR
         xxptstkrp02_start_amt <> 0 OR xxptstkrp02_start_cust_consi_qty <> 0 OR 
         xxptstkrp02_start_cust_consi_amt <> 0 OR
         xxptstkrp02_end_qty_oh <> 0 OR xxptstkrp02_end_amt <> 0 OR
         xxptstkrp02_end_cust_consi_qty <> 0 OR 
         xxptstkrp02_end_cust_consi_amt <> 0 ) THEN v_log1 = YES .
      IF maxii >= 1 THEN DO:
         DO ii = 1 TO maxii :
            IF xxptstkrp02_rctiss_qty[ii] <> 0 OR xxptstkrp02_rctiss_amt[ii] <> 0 THEN v_log2 = YES.
         END.
      END.
      
      IF v_log1 = YES OR v_log2 = YES THEN DO:
         PUT UNFORMATTED xxptstkrp02_part			  ";" .
         PUT UNFORMATTED pt_desc1			  ";" .
         PUT UNFORMATTED pt_desc2			  ";" .
         PUT UNFORMATTED pt_um			  ";" .
         PUT UNFORMATTED xxptstkrp02_sct			  ";" .
         PUT UNFORMATTED xxptstkrp02_start_qty_oh		  ";" .
         PUT UNFORMATTED xxptstkrp02_start_amt		  ";" .
         PUT UNFORMATTED xxptstkrp02_start_cust_consi_qty	  ";" .
         PUT UNFORMATTED xxptstkrp02_start_cust_consi_amt	  ";" .
         if maxii >= 1 THEN do:
            DO ii = 1 to maxii:
               IF xxptstkrp02_rctiss_qty[ii] >= 0 THEN DO:
                  PUT UNFORMATTED xxptstkrp02_rctiss_qty[ii]	";" .
                  PUT UNFORMATTED abs(xxptstkrp02_rctiss_amt[ii])	";" .
               END.
               ELSE DO:
                  PUT UNFORMATTED xxptstkrp02_rctiss_qty[ii]	";" .
                  PUT UNFORMATTED - abs(xxptstkrp02_rctiss_amt[ii])	";" .
               END.
            END.   
         end.
         PUT UNFORMATTED xxptstkrp02_end_qty_oh		";" . 
         PUT UNFORMATTED xxptstkrp02_end_amt			";" . 
         PUT UNFORMATTED xxptstkrp02_end_cust_consi_qty	";" . 
         PUT UNFORMATTED xxptstkrp02_end_cust_consi_amt	";" . 
         
         DO ii = 1 to max_BI_Field_pcs - 15 - (maxii * 2) - 1 :
            PUT UNFORMATTED ";" .
         END.  
         put skip .
      END.
      
      delete xxptstkrp02 .
   END.
	
   for each tt:
      delete tt.
   end.
   
   {a6mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}

procedure pro_locgroup:
   define input parameter pro_loc as char .
   define input parameter pro_locgroup as char .
   define output parameter pro_yesno as logi .
   
   define variable prov_1 as char extent 20 .
   define variable prov_2 as char extent 20 .
   define variable jj as inte  .
   define variable kk as inte .
   define variable yn as logi .
   define variable iiii as inte .
   define variable loc33 as char extent 10 .

	
	pro_yesno = no .
	

   /* Add By:  SS - 20070118.1 Begin */
	find code_mstr  
      where code_mstr.code_domain = global_domain 
      and code_fldname = "locgroup"
      and code_value = pro_locgroup 
      no-lock no-error.
	if avail code_mstr then do:
		DO iiii = 1 to 10 :
			assign loc33[iiii] = substring(code_cmmt, (iiii - 1) * 60 + 1 ,60) .
		END.
		DO iiii = 1 to 10 :
			assign pro_locgroup = loc33[iiii]  .
			
			if pro_locgroup <> "" and pro_yesno = no then do:
				jj = 1 .
				yn = no .		
				DO kk = 1 to 20 :
					assign  
                  prov_1[kk] = "" 
						prov_2[kk] = "" 
                  .
				END.  /* END DO */
				DO kk = 1 to length(pro_locgroup) :
					if substr(pro_locgroup,kk,1) <> "" then do:
						if substr(pro_locgroup,kk,1) = "-" then do:
							assign 
                        yn = yes 
								prov_2[jj] = "" 
                        .
						end.
						else if substr(pro_locgroup,kk,1) = "," then do:
							assign yn = no .
							if kk <> length(pro_locgroup) then assign jj = jj + 1 .
						end.
						else do:
							if yn = no then 
								assign 
                        prov_1[jj] = prov_1[jj] + substr(pro_locgroup,kk,1)
                        prov_2[jj] = prov_2[jj] + substr(pro_locgroup,kk,1) 
                        .
							else assign    prov_2[jj] = prov_2[jj] + substr(pro_locgroup,kk,1) .
						end.
					end.
				END.  /* END DO */
				do kk = 1 to jj + 1:
				   /*
               disp 
                  prov_1[kk]
                  prov_2[kk] 
                  .
               */
					
					if pro_loc >= prov_1[kk] and pro_loc <= prov_2[kk] then assign pro_yesno = yes .
				end.
			end.
		END.
	end.	/*���������Ч*/
	else assign pro_yesno = yes .
   /* Add By:  SS - 20070118.1 End */
end.
