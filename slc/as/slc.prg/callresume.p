/*����Ƿ�������
	checknumber = 1=����
	checknumber = 2=����
	checknumber = 3=���
	checknumber = 4=��װ
	checknumber = 5=���
	checknumber = 6=װ��	loc ��ʱҪΪ װ�䵥��
	checknumber = 7=����
	*/

checknumber = "1" .
{gprun.i ""xxddcheckvinhist.p""
"(input vin,
  input xxsovd_wolot ,
  input checknumber ,
  output cimError)"}


/*�Զ�������ʷ��¼xxvind_det�ͻ��ܼ�¼xxvin_mstr*/
/*����Ƿ�������
	checknumber = 1=����
	checknumber = 2=����
	checknumber = 3=���
	checknumber = 4=��װ
	checknumber = 5=���
	checknumber = 6=װ��	loc ��ʱҪΪ װ�䵥��
	checknumber = 7=����
*/
checknumber = "1" .
{gprun.i ""xxddupdatevinhist.p""
 "(input vin,
   input motorvin ,    �������� ֻ��checknumber = 1�����ã�����û��
   input xxsovd_wolot ,
   input loc,
   input checknumber ,
   output cimError)"}


/*����xxvind_det and xxvin_mstr */
{gprun.i ""xxddcreatevinhist.p""
 "(input vin)"}

/*COPYCreate xxvind_det and xxvin_mstr */
/*����VIN�滻�ɻ��鹤��IDʱCOPYԭ������VIN������Ϣ*/
{gprun.i ""xxddcopyvinhist.p""
 "(input vin,
   input wolot)"}

/*�õ���ǰ����������û���*/
{gprun.i ""xxddgetbarcodeuser.p"" 
"(output barcode_userid)"}

/*���߷��ϰ��Ʒ����鶯��*/
{gprun.i ""xxddautowois.p""
"(input vin,
  input wolot,
  output cimError)"}

/*��������Ʒ����飬��������*/
{gprun.i ""xxddautoworc.p""
"(input vin,
  input site,
  input loc,
  output cimError)"}

/*
1.��ѯ����ID�ĳ���⼰���߰�װ����

  input wolot    ����ID
  output qty_pack ��װ��
  output qty_line ������
  output qty_ruku �����
  output qty_cuku ������
  */
 {gprun.i ""xxddgetxxsovdqty.p"" 
"(input wo_lot,
	output qty_pack,
	output qty_line,
	output qty_ruku,
	output qty_cuku)"
	}

/*�ַ��Զ���ȡ*/
/*
input tmp_char ,	�����ַ�����
input 108,		ÿ�ж��ٸ��ֽ�
output tmp_char ,	����ַ����� ��^�ָ�
output k		�ܹ��ж�����
*/
 {gprun.i ""xxddgetstring.p"" 
"( input tmp_char ,
   input 108 ,
   output tmp_char ,
   output k 
)"}


/*�õ�VIN��������ͨ��Ϣ��xxsovinck2.p�����ù�*/
 {gprun.i ""xxddiqvindet.p"" 
  "(input xxsovd_id)"
	}	/*�õ�VIN����Ϣ*/



/*ȡ��xxvind_det xxvin_mstr �ȱ� ���ߣ���װ����⣬���߳���״̬*/
/*
��������
����ID
���
*/
{gprun.i ""xxddcancelvinhist.p""
 "(input xxvinimport_date ,	
   input xxvinimport_wolot ,
   input vin ,
   input checknumber
   )"}

/*ȡ��ISS-SO ת�� �������� */
/*
����
����ID
���
*/
{gprun.i ""xxddcancelbarcode.p""
 "(input xxvinimport_date ,	
   input xxvinimport_wolot ,
   input checknumber
   )"}