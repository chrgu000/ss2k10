/*xxfarpcode.i ȡ�ù̶��ʲ���ͨ�ô���˵��*/
/*��Ϊ�����ӳ�ʽ,���������޸�*/

/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100521.1  By: Roger Xiao */

define var v_fachr01 like code_cmmt .
define var v_fachr02 like code_cmmt .
define var v_fachr03 like code_cmmt .
define var v_fachr04 like code_cmmt .
define var v_disprsn   like code_cmmt .
define var v_facode    like code_cmmt .


/*�������*/
find first code_mstr where code_domain = global_domain and code_fldname = "fa__chr01" and code_value = fa__chr01 no-lock no-error .
v_fachr01 = if avail code_mstr then code_cmmt else  fa__chr01 .

/*��Ѻ���*/
find first code_mstr where code_domain = global_domain and code_fldname = "fa__chr02" and code_value = fa__chr02 no-lock no-error .
v_fachr02 = if avail code_mstr then code_cmmt else  fa__chr02 .

/*����˵��*/
find first code_mstr where code_domain = global_domain and code_fldname = "fa__chr03" and code_value = fa__chr03 no-lock no-error .
v_fachr03 = if avail code_mstr then code_cmmt else  fa__chr03 .


/*�������*/
find first code_mstr where code_domain = global_domain and code_fldname = "fa__chr04" and code_value = fa__chr04 no-lock no-error .
v_fachr04 = if avail code_mstr then code_cmmt else  fa__chr04 .


/*����ԭ��*/
find first code_mstr where code_domain = global_domain and code_fldname = "fa_disp_rsn" and code_value = fa_disp_rsn no-lock no-error .
v_disprsn = if avail code_mstr then code_cmmt else  fa_disp_rsn .


/*�ʲ�������*/
find first code_mstr where code_domain = global_domain and code_fldname = "fa_code" and code_value = fa_code no-lock no-error .
v_facode = if avail code_mstr then code_cmmt else  fa_code .



/*��Ϊ�����ӳ�ʽ,���������޸�*/


