/* ����˵���� �Զ�����ά������                                            */
/* �Զ�������ƣ�xx_ptdet                                                   */
/* ���˵����  �������ǵĺܶ����������ԭ pt_det ��û���ֶο���ʹ�ã���ԭ�� */
/* ������ֶν��ǳ���Ҫȫ�����±��룬�����������һ��pt����Զ��������� */
/* ������ݣ�  ���ϵ�λ����������Ա��ÿ��������ÿ������                     */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i }

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

{wbrp01.i}

define variable ppform as character no-undo.

ppform = "a".

{gprun.i ""xxinv.p"" "(input ppform)"}
/*! gprun.i �����﷨
Runs a program from a 2-letter subdirectory, where the program MUST be.

{1} program name ��������
{2} parameters to pass the program
{3} optional [ PERSISTENT [set handle] ] parameter for Progress v7.

Sample: run value(global_user_lang_dir + substring({1},1,2) + '/' + {1}) {3} {2}.
*/


{wbrp04.i}
