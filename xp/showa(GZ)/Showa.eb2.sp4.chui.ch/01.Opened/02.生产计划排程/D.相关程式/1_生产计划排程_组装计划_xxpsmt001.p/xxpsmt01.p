/* xxpsmt01.p  �����ƻ��ų�_��װ�ƻ�  */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110330.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

{mfdtitle.i "110331"}
{mfsprtdf.i new} /*for xxgpseloutxp.i*/

{xxpsmt01var.i "new"}

define var v_days           as integer .
define var v_qty_min        as decimal .
define var v_qty_max        as decimal .
define var v_ii             as integer .
define var v_jj             as integer .

define var v_time_stock     as integer  . /*ȡ����Ŀ��*/
define var v_time_chg       as decimal  . /*���ߵĻ��ֻ���ʱ��*/
define var v_time_tmp       as decimal  . /*���ߵĻ��ֻ���ʱ��2*/
define var v_time_used      as decimal  . /*��ʹ�õĲ���ʱ��*/
define var v_part_prev      as char  .
define var v_part_next      as char  .


define var v_is_mp           as logical .
define var v_qty_prod        as decimal .
define var v_qty_rq_need1    as decimal .
define var v_qty_rq_need2    as decimal .
define var v_qty_rq_used     as decimal .
define var v_qty_per_min     as decimal .
define var v_qty_lot         as decimal .

define var v_time_test_b     as integer .
v_rev = "Test"  .    /*�汾�Ź���δ��???*/
/*v_rev����������İ汾,�ܼƻ�,�¼ƻ�����ȡ������ */


/*test ???*/ v_month = 1 .


form
    SKIP(.2)
    site             colon 28 label "�ص�"
    v_week           colon 28 label "�ܼƻ�(0-4)"
    v_month          colon 28 label "�¼ƻ�(0-6)"
    v_sortby         colon 28 label "ϵͳ˳��1/�̶�˳��2"
    skip(1) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

mainloop:
repeat:

    v_time_test_b = time .

    /*���д���������ʱ����ʺ� ? ************************************/

    /*Ŀǰ��ʽ�߼�:ȫ��today��ʼ�ų�, ��2����Ƿ�����ų̼����߼�δ��??? */

    /*��ʱ��,�����ȳ�ʼ��,ѡ����������*/
    {xxpsmt01i01.i}

    /*��������,from sod_det,����֮ǰδ���*/
    {xxpsmt01i02.i}

    /*�����ų�����,ÿ���MP���Ŀ���׼*/
    {xxpsmt01i03.i}

    /*�ų����ڵ��ų̹���(wo_type = "S"),���Բ���ɾ��,�����ų̱�����ų̹���ʱ����. */

    /*�����Ų�ǰ�����ۿ��=(ʵ�ʿ��+δ����ȹ���-δ����������)*/   
    {xxpsmt01i04.i}

    /*��ʼ�Ų�ǰ�Ĵ�����,�д������ӡ,���жϳ�ʽ*/
    {xxpsmt01i05.i}
    
    /*�����ų�ʱ���Ŀ���������*/  /*��������,�Ժ������ų̳�ʽ����һ��ִ��!***???*/
    {xxpsmt01i06.i}


    /*�����ų̵���������,��������,����Ӧ���� */
    {xxpsmt01i07.i}


    /*��v_sortbyȡ����ϵͳ˳���ǹ̶�˳��,����ÿ�����ߵ������Ų�˳��*/
    {xxpsmt01i08.i}

    /*�����ų�����,������ÿ��Ŀ��ò���*/
    {xxpsmt01i09.i}

    /*��ֹ�Ų���,������,�����,�Ѿ����õļӰ���??????*/
    {xxpsmt01i10.i}

    /*�ų����߼�*/
    {xxpsmt01i11.i}

    
    /*�ų̽����ӡ���ļ�*/
    find first xps_mstr where xps_rev = v_rev no-lock no-error.
    if not avail xps_mstr then do:
        message "����:�ų�δ����" .
        undo,retry.
    end.
    else do:
        {gprun.i ""xxpsmt01ptestprint.p"" } /*print test report*/

         /*{gprun.i ""xxpsmt01p05.p"" } print the result */
    end.

end.  /* mainloop: */
