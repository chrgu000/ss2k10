/* xsquit01.i ����������part1                                               */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*
1.v_line_prev[ ��xsmf002���ʼ��ֵ xslndefine.i  
2.���ļ�����������ָ��xsquit.p,�Է�,����ָ�� ������ʽxsmf002.p����
3.�رմ��û����л�����δ��ָ��

*/

define temp-table tt  
    field t_rec as recid
    field t_wc  as char .
for each tt : delete tt . end. 

/*�Ҵ��û����л�����δ��ָ��*/
for each xxfb_hist  
        use-index xxfb_userwc 
        where xxfb_user = v_user
        /*and xxfb_wc     = v_wc*/ 
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

/*����Ҫ��Ҫ��У��? ��ʱ����*/
