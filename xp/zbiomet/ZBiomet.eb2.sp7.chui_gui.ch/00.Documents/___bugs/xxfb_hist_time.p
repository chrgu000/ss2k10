
OUTPUT TO c:\xxfb_time_end_zero.prn.

for each xxfb_hist no-lock
  where xxfb_time_end = 0  :

display xxfb_date xxfb_date_start xxfb_date_end

    /* string(xxfb_time_start, "HH:MM:SS") label "��ʼʱ��"
       string(xxfb_time_end, "HH:MM:SS") label "����ʱ��" */

    xxfb_time_start
    xxfb_time_end
  WITH DOWN FRAME b WIDTH 320 STREAM-IO.




for each xxfb_hist no-lock
    where xxfb_date_end <> ?
    and xxfb_time_end = 0  :

    display 
    xxfb_trnbr xxfb_type2 
    xxfb_wolot xxfb_op 
    xxfb_date_start xxfb_date_end
    string(xxfb_time_start, "HH:MM:SS") label "��ʼʱ��"
    string(xxfb_time_end, "HH:MM:SS") label "����ʱ��"
    .

end.



  ���׺� ָ������ ������־   ���� ��ʼ���� �������� ��ʼʱ�� ����ʱ��
-------- -------- -------- ------ -------- -------- -------- --------
     373 ����ʱ�� 751293       20 09/02/12 09/02/13 00:19:00 00:00:00
     773 ����ʱ�� 762382       20 09/02/14 09/02/15 23:41:00 00:00:00
    1341 ����ʱ�� 762415       30 09/02/19 09/02/20 19:07:00 00:00:00
    1342 ����ʱ�� 762368       30 09/02/19 09/02/20 19:08:00 00:00:00
    1344 �ϸ��� 762368       30 09/02/20 09/02/20 00:00:00 00:00:00
    1345 �ϸ��� 762415       30 09/02/20 09/02/20 00:00:00 00:00:00
    1873 ����ʱ�� 762537       10 09/02/24 09/02/25 23:56:00 00:00:00
    1877 �ϸ��� 762537       10 09/02/25 09/02/25 00:00:00 00:00:00
    3780 ����/׼  782383       30 09/03/04 09/03/04 00:00:00 00:00:00
    7680 ����ʱ�� 774585       10 09/03/12 09/03/13 16:06:00 00:00:00
    7889 �ϸ��� 774585       10 09/03/13 09/03/13 00:00:00 00:00:00
   12777 ����ʱ�� 776301        5 09/03/20 09/03/20 00:00:00 00:00:00
   12778 ����ʱ�� 774526        8 09/03/20 09/03/20 00:00:00 00:00:00
   12779 �ϸ��� 774526        8 09/03/20 09/03/20 00:00:00 00:00:00
   15180 ����ʱ�� 796440       15 09/03/23 09/03/24 23:59:00 00:00:00
   15182 ����ʱ�� 772200       10 09/03/24 09/03/24 00:00:00 00:00:00
   16037 ����ʱ�� 772117        5 09/03/24 09/03/25 20:03:00 00:00:00
   16264 �ϸ��� 772117        5 09/03/25 09/03/25 00:00:00 00:00:00
   19226 ����ʱ�� 773681       10 09/03/28 09/03/29 17:01:00 00:00:00
   19235 ����ʱ�� 771986        5 09/03/28 09/03/29 17:09:00 00:00:00
   19461 �ϸ��� 771986        5 09/03/29 09/03/29 00:00:00 00:00:00
   19462 �ϸ��� 773681       10 09/03/29 09/03/29 00:00:00 00:00:00
   20091 ����ʱ�� 784308        5 09/03/30 09/03/31 20:17:00 00:00:00
   20725 ����ʱ�� 784374        5 09/03/31 09/04/01 17:13:00 00:00:00
   20851 �ϸ��� 784374        5 09/04/01 09/04/01 00:00:00 00:00:00
   