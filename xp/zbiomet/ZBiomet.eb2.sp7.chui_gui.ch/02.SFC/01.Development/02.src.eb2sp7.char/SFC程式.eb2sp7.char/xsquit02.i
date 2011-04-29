/* xsquit02.i ����������part2                                               */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*
1.v_line_prev[ ��xsmf002���ʼ��ֵ xslndefine.i  
2.���ļ�����������ָ��xsquit.p,�Է�,����ָ�� ������ʽxsmf002.p����
3.�رմ��û����л�����δ��ָ��(������,Ӧ����ÿ������ֻ��һ����δ���) 

*/



define var v_time_used as integer . /*ʱ�䷴��*/
define var v_qty_fb    as decimal . /*��������*/

v_date   = today.                 /*ִ������*/
v_time   = time - (time mod 60) . /*ִ��ʱ��:������֤ʱ���һ��*/
v_time_used = 0 .                 /*�ۼƵ�ʱ��*/
v_qty_fb   = 0 .                  /*�ۼƵ�����*/




/*����ÿһ��δ��ָ��*/
for each tt :
    find xxfb_hist where recid(xxfb_hist) = t_rec  no-error .
    if avail xxfb_hist and xxfb_date_end = ? then do:  /*֮ǰ��ָ��,����δ��ָ��,��ִ�б��γ�ʽ */
        
        /*ָ�����*/
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

        /*��ʾ��Ϣ*/
        /*message   "�û�/����:"  xxfb_user  "/"  xxfb_wc skip
                  "����/����:    "  xxfb_wolot "/"  xxfb_op skip
                  "ָ�����:"   xxfb_type2  "       "
        view-as alert-box title "".
        */
    end. /*if avail xxfb_hist*/

end. /*for each tt*/


{xsgetuser01.i} /*��¼���û�����ˢ���Ļ���������,��Ϊ�´ε�½ʱ��Ĭ��ֵ*/

