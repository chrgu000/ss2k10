/* SS - 090827.1 By: Neil Gao */
/* SS - 090915.1 By: Neil Gao */
/* SS - 100519.1 By: Kaine Zhang */

/* SS - 100507.1 - RNB
[100519.1]
2010-5-17
���� 09:55:44
�������ֳ��ӿ���
��xlmd_motor��д��ֵ
��д��xlmd_part����ȥ
[100519.1]
SS - 100507.1 - RNE */


/*
���ӽ����ڽӿ�
*/
/*
һ. ��������Ϣ. xlm_mstr.
�ֶ���                ��ǩ         ˵��
xlm_barcode           �����       ������������ϵͳ��,Ψһֵ.
xlm_site              �ջ��ص�     3
xlm_loc               �ջ���λ     001
xlm_package           ���         �ɹ���+"*"+5λ�������ַ�.������λ������5λ,�貹��ǰ�ߵ�0.����09010161*00045
xlm_length            ��           ���ӵĳ���,����޷��ṩ,��ʱ������. (����,�����ڵĵ�֤������Ҫʹ����Щ���ݵ�,�������ǻ��������).
xlm_width             ��           ���ӵĿ��,����޷��ṩ,��ʱ������. (����,�����ڵĵ�֤������Ҫʹ����Щ���ݵ�,�������ǻ��������).
xlm_height            ��           ���ӵĸ߶�,����޷��ṩ,��ʱ������. (����,�����ڵĵ�֤������Ҫʹ����Щ���ݵ�,�������ǻ��������).
xlm_gross_weight      ë��         ���ӵ�ë��,����޷��ṩ,��ʱ������. (����,�����ڵĵ�֤������Ҫʹ����Щ���ݵ�,�������ǻ��������).
xlm_net_weight        ����         ���ӵľ���,����޷��ṩ,��ʱ������. (����,�����ڵĵ�֤������Ҫʹ����Щ���ݵ�,�������ǻ��������).
xlm_make_date         ��������     ��������
xlm_pack_date         ��װ����     ��װ����
xlm_store_date        �������     �������
xlm_vendor            ��Ӧ��       SLC.
xlm_po_nbr            �ɹ�����     �����ڵĲɹ�������.����09010161.
xlm_datetime          ����ʱ��     ��ӿڱ�д���ݵ�ʱ��ʱ��.(datetime).(now).
xlm_import            ����         �������Ƿ�Ա������ݽ������ջ�(����).���ֶγ�ʼֵΪNo,�����ڽ��պ�,���޸���ΪYes.
xlm_pack_mode         ��װ��ʽ     ���ӵİ�װ����.����ֽƤ,��Ƥ,ľ���.����޷��ṩ,��ʱ������. (����,�����ڵĵ�֤������Ҫʹ����Щ���ݵ�,�������ǻ��������).

��. ����������ϸ. xlmd_det.
�ֶ���                ��ǩ         ˵��
xlmd_barcode          barcode      �����.
xlmd_part             Part         ���ϱ���(��100000-02A0-00501).ע�����ֳ��ı���,������ڵı���,�Ƿ�һ��.(���糵��,�����ֳ�����ΪPLM01,�Ƿ��ڽ����ڴ���ΪPLM02).
xlmd_serial           Serial       ���ʹ���(��LX100-14).���������ĸ�����.
xlmd_motor            Motor        �ɳ�����(��LX100-14-00C-5R).���������ĸ��ɳ�.
xlmd_vin              VIN          ���ܺ�.�ɳ��г��ܺ�,����������.���,û�г��ܺŵ�,���Բ���.
xlmd_engine           engine       ������.�ɳ��з�����,����������.���,û�з�������,���Բ���.
xlmd_qty              Quantity     ����.�ڱ�����,�����ʹ���+�ɳ�����+���ϱ��������.���ͬһ���,���ڲ�ͬ�ĳ��ʹ���,����ֱ����.
xlmd_datetime         datetime     ��ӿڱ�д���ݵ�ʱ��ʱ��.(datetime).(now).
xlmd_import           import       �������Ƿ�Ա�����ϸ���ݽ������ջ�(����).���ֶγ�ʼֵΪNo,�����ڽ��պ�,���޸���ΪYes.
xlmd_make_character01 flag         һ�����.�����,�����ڲ���ʹ����.��������ֵ�ڱ�����ҪΨһ,���������д����.���������дһ��������ȥ,ֻҪ��֤�ڱ���Ψһ����.
xlmd_pinpai           Ʒ��         �����ϵ�Ʒ��.Ʒ����ζ�,��Ҫ�������,�����칫˾ѯ��.��˵���Ǿ��������,�������λ�.����޷��ṩ,��ʱ������. 
xlmd_biaozhi          ��ʶ         �����ϵı�ʶ.��ʶ��ζ�,��Ҫ�������,�����칫˾ѯ��.��˵���Ǿ��������,�������λ�.����޷��ṩ,��ʱ������. 
xlmd_xinghao          �ͺ�         �����ϵ��ͺ�.�ͺ���ζ�,��Ҫ�������,�����칫˾ѯ��.��˵���Ǿ��������,�������λ�.����޷��ṩ,��ʱ������. 
*/

define shared var global_domain like pt_domain.
define input parameter iptf1 like xxvind_id.
define input parameter iptf2 like xxsovd_id.

define output parameter optf1 as logical.
	

	optf1 = yes.
	
	find first xxvind_det where xxvind_domain = global_domain 
			and xxvind_id = iptf1 and xxvind_log01 = yes no-lock no-error.
	if not avail xxvind_det then return.
	
	find first so_mstr where so_domain = global_domain and so_nbr = xxvind_nbr no-lock no-error.
	if not avail so_mstr then return.
	
	find first pt_mstr where pt_domain = global_domain and pt_part = xxvind_part no-lock no-error.
	
 	create 	qadmid.xlm_mstr.
	assign 	xlm_barcode = iptf1
					xlm_site    = "3"
					xlm_loc     = "001"
					xlm_package = if avail xxvind_det then xxvind_chr02 else ""
					xlm_make_date = xxvind_down_date
					xlm_pack_date = xxvind_pack_date
					xlm_store_date = xxvind_cuku_date
					xlm_vendor  = "SLC"
					xlm_po_nbr = so__chr03
					xlm_datetime = now
					xlm_import = no
					.
	create  qadmid.xlmd_det.
	/* SS - 100519.1 - B
	assign  xlmd_barcode = iptf1
					xlmd_part    = ""
					xlmd_serial  = if avail pt_mstr then pt_desc1 else ""
					xlmd_motor   = xxvind_part
					xlmd_vin     = iptf1
					xlmd_engine  = iptf2
					xlmd_qty     = 1
					xlmd_datetime = now
					xlmd_import = no
					xlmd_make_character01 = "SLC" + iptf1
					.
    SS - 100519.1 - E */
    /* SS - 100519.1 - B */
    assign
        xlmd_barcode = iptf1
		xlmd_part    = xxvind_part
        xlmd_serial  = if avail pt_mstr then pt_desc1 else ""
        xlmd_motor   = xxvind_part
        xlmd_vin     = iptf1
        xlmd_engine  = iptf2
        xlmd_qty     = 1
        xlmd_datetime = now
        xlmd_import = no
        xlmd_make_character01 = "SLC" + iptf1
        .
    /* SS - 100519.1 - E */
					
	optf1 = no.

/* SS 091202.1 - B */
/*	
if connected("qadmid") then do:
	disconnect qadmid.
end.
*/
/* SS 091202.1 - E */