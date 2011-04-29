/* xslnprev01.i ����ǰ��ָ��,�ۼ�׼��������ʱ��  */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*
1.v_line_prev[] ��xsmf002���ʼ��ֵ xslndefine.i  
2.���ļ�������ָ���ʽ����
3.��ǰһ��δ���¼ by �û� by ���� by wolot



ָ����Ҫ�����޸ĵ��ļ�:

*/

define var v_fix_edate as date label "��������" .  
define var v_fix_etime as integer  label "����ʱ��".
define var v_fix_eh as integer format "99" label "����ʱ���Сʱ".
define var v_fix_em as integer format "99" label "����ʱ��ķ���".

v_fix_edate = v_date .
v_fix_eh    = integer(substring(string(v_time,"hh:mm"),1,2)) .
v_fix_em    = integer(substring(string(v_time,"hh:mm"),4,2)) .

form
    skip(1)
    v_fix_edate colon 20  label "��������(������)"
    v_fix_eh    colon 20  label "����ʱ��(24ʱ��)"     
    v_fix_em              label     ""
    skip(1)
with frame fixm 
title color normal "����ά�޽���ʱ��"
side-labels width 50 
row 8 centered overlay .   






define var v_time_used as integer . /*ʱ�䷴��*/
define var v_qty_fb    as decimal . /*��������*/

v_time_used = 0 .
v_qty_fb   = 0 .

/*�����һ��xxfb_hist*/
v_recno = ? .
if v_tail_wc then do:
    for each xxfb_hist  
            use-index xxfb_userwc 
            where xxfb_user = v_user and xxfb_wc = v_wc 
            and xxfb_date_end = ? 
            and ((xxfb_wolot  = v_wolot and xxfb_op = v_op )
                or xxfb_wolot = "" )
            no-lock 
            break by xxfb_user by xxfb_wc by xxfb_trnbr :

            if last(xxfb_user) then v_recno = recid(xxfb_hist) .
    end.
end. /*�������*/
else do:
    for each xxfb_hist  
            use-index xxfb_userwc 
            where xxfb_user = v_user and xxfb_wc = v_wc 
            and xxfb_date_end = ? 
            no-lock 
            break by xxfb_user by xxfb_wc by xxfb_trnbr :

            if last(xxfb_user) then v_recno = recid(xxfb_hist) .
    end.
end. /*�Ǻ������*/

find xxfb_hist where recid(xxfb_hist) = v_recno  no-error .
if avail xxfb_hist and xxfb_date_end = ? then do:  /*֮ǰ��ָ��,����δ��ָ��,��ִ�б��γ�ʽ */

    /*����ά��,����ʱ������ֹ�(��֮ǰ)����,*/
    if xxfb_type = v_line_prev[19]  then do on error undo,retry :
        message "����ά����δ����,��ȷ�Ͻ���ʱ��." .

        update v_fix_edate v_fix_eh v_fix_em with frame fixm.

        {xserr001.i "v_fix_eh" } /*���������λ�Ƿ��������ʺ�*/
        {xserr001.i "v_fix_em" } /*���������λ�Ƿ��������ʺ�*/

        if v_fix_edate = ? then do:
            message "����ȷ����ά�޽�������." .
            next-prompt v_fix_edate.
            undo,retry .
        end.

        if v_fix_eh >= 24 then do:
            message "����ȷ����ά�޽���ʱ��." .
            next-prompt v_fix_eh.
            undo,retry .
        end.

        if v_fix_em >= 60 then do:
            message "����ȷ����ά�޽���ʱ��." .
            next-prompt v_fix_em.
            undo,retry .
        end.

        v_fix_etime   = v_fix_eh * 60 * 60 + v_fix_em * 60  . 
        v_fix_etime   = v_fix_etime - (v_fix_etime mod 60). 
        if (integer(v_fix_edate) + v_fix_etime / 86400 ) > (integer(v_date) + (v_time - (v_time mod 60)) / 86400 ) then do:
            message "����ʱ�䲻�ɳ���:����(" v_date "" string(v_time,"hh:mm") ")." .
            undo,retry .
        end.
        if (integer(xxfb_date_start) + xxfb_time_start / 86400 ) > (integer(v_fix_edate) + v_fix_etime / 86400 ) then do:
            message "����ʱ�䲻������:ά�޿�ʼʱ��(" v_fix_edate "" string(v_fix_etime,"hh:mm") ")." .
            undo,retry .
        end.

        hide frame fixm no-pause .

        v_msgtxt = xxfb_type2 + ":ָ�����,  "  .
        assign  xxfb_date_end    = v_fix_edate
                xxfb_time_end    = v_fix_etime .
    end. /*if xxfb_type = v_line_prev[19] */
    else do: /*�ǻ���ά��,����ʱ�䶼��now*/


        v_msgtxt = xxfb_type2 + ":ָ�����,  "  .
        assign  xxfb_date_end    = v_date
                xxfb_time_end    = v_time .

        /*׼��ʱ��*/   
        if xxfb_type = v_line_prev[1] then do:
            if xxfb_date_start = v_date then do:
                v_time_used = xxfb_time_end - xxfb_time_start .
            end.
            else do:
                v_time_used = (xxfb_date_end - xxfb_date_start) * (60 * 60 * 24) - xxfb_time_start + xxfb_time_end .
            end.

            find first xxwrd_det where xxwrd_wolot = xxfb_wolot and xxwrd_op = xxfb_op no-error .
            if avail xxwrd_Det then do:
                xxwrd_time_setup = xxwrd_time_setup + v_time_used .
            end.
            
        end.

        /*����ʱ��*/
        if xxfb_type = v_line_prev[2]  then do:
            if xxfb_date_start = v_date then do:
                v_time_used = xxfb_time_end - xxfb_time_start .
            end.
            else do:
                v_time_used = (xxfb_date_end - xxfb_date_start) * (60 * 60 * 24) - xxfb_time_start  + xxfb_time_end .
            end.

            find first xxwrd_det where xxwrd_wolot = xxfb_wolot and xxwrd_op = xxfb_op no-error .
            if avail xxwrd_Det then do:
                xxwrd_time_run = xxwrd_time_run + v_time_used .
            end.
        end.

        /*����ʱ��,�Է�ʱ��,����ͣ��,������ͣ��ʱ��,
                            ��ʱ���ﲻ������������,ֻ��ǰ���¼����ʱ�伴��*/

    end.  /*�ǻ���ά��,����ʱ�䶼��now*/
end. /*if avail xxfb_hist*/

