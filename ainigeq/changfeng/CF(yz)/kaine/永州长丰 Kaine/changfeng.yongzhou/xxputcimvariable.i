/* xxputcimvariable.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/*
 *  {1}:
 *      "qq", ���ӡ������ʱ��,����������
 *      ����, ֱ�Ӵ�ӡ����
 *  {2}:
 *      ����ӡ�ı���
 *  {3}:
 *      ��ӡ��λ��. ���� "at 1"
 */
 
if {1} = "qq" then do:
    put
        unformatted
        "~"" {3}
        {2}
        "~""
        " "
        .
end.
else do:
    put
        unformatted
        {2}
        {3}
        " "
        .
end.