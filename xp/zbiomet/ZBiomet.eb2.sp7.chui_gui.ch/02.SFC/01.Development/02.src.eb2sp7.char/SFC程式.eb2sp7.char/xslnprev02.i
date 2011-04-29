/* xslnprev02.i �������û�����������δ��ָ��,�ۼ�׼��������ʱ��  */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*
1.v_line_prev[] ��xsmf002���ʼ��ֵ xslndefine.i  
2.���ļ�������ָ���ʽ����
3.�Ҵ��û�����������δ���ָ�� by �û� by ����



ָ����Ҫ�����޸ĵ��ļ�:

*/



define var v_time_used as integer . /*ʱ�䷴��*/
define var v_qty_fb    as decimal . /*��������*/

v_time_used = 0 .
v_qty_fb   = 0 .


define temp-table tt  
    field t_rec as recid
    field t_wc  as char .
for each tt : delete tt . end. 

/*�Ҵ��û�����������δ���ָ��xxfb_hist*/
for each xxfb_hist  
        use-index xxfb_userwc 
        where xxfb_user = v_user
        and xxfb_wc     = v_wc 
        and xxfb_date_end = ? 
        no-lock 
        break by xxfb_user by xxfb_wc by xxfb_trnbr :

        find first tt where t_rec = recid(xxfb_hist) no-lock no-error .
        if not avail tt then do:
            create tt .
            assign t_rec = recid(xxfb_hist) 
                   t_wc  = xxfb_wc .
        end.
end.

/*����ÿһ��δ��ָ��*/
for each tt :
    find xxfb_hist where recid(xxfb_hist) = t_rec  no-error .
    if avail xxfb_hist and xxfb_date_end = ? then do:  /*֮ǰ��ָ��,����δ��ָ��,��ִ�б��γ�ʽ */

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

    end. /*if avail xxfb_hist*/
end. /*for each tt*/