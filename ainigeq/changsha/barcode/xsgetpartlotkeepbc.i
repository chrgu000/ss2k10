/* xsgetpartlotkeepbc.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */
/* SS - 090903.1 By: Kaine Zhang */
/* SS - 110314.1 By: Kaine Zhang */

/*
 *  ��ɨ���������,��ȡ���ϱ���,����,��Ӧ��.
 *  {1} -- ������Դ.
 *  {2} -- ���ϱ���
 *  {3} -- ����
 *  {4} -- ��Ϣ��ʾ����
 *  {5} -- ��ʾ���ĸ�frame��
 *  {6} -- �����,������loop
 */  

/* *ss_20090730* ���������ȷ��,�������ǳ����׼����,����б�׼ת��. */
if {1} = "" then do:
    display
        "���벻������" @ {4}
    with frame {5}.
    undo {6}, retry {6}.
end.

/* +����ж� */
if substring({1}, length({1}, "RAW"), 1) <> "+" then do:
    {4} = "���һλ����+,����������". 
    display {4} with frame {5}.
    undo {6}, retry {6}.
end.

/* -����ж� */
assign
    {2} = ""
    {3} = ""
    .

/* SS - 110314.1 - B
assign    
    {2} = entry(1, {1}, "-")
    {3} = entry(2, {1}, "-")
    no-error
    .
SS - 110314.1 - E */
/* SS - 110314.1 - B */
assign
    {2} = substring({1}, 1, length({1}) - 11)
    {3} = substring({1}, length({1}) - 9, 10)
    no-error
    .
/* SS - 110314.1 - E */

if error-status:error then do:
    {4} = "�������,�޷���ȡ�Ϻ�����".
    display {4} with frame {5}.
    undo {6}, retry {6}.
end.

/* 003����ж�. (003�ǳ���ɳ����Ϊ�ɷݹ�˾��Ӧ�̵Ĵ���) */
if substring({2}, 1, 3) <> "003" then do:
    {4} = "�������,��003�ṩ".
    display {4} with frame {5}.
    undo {6}, retry {6}.
end.
substring({2}, 1, 3) = "".

substring({3}, length({3}), 1) = "".
/* Ϊ��֤ϵͳ��������˳��(��ʷ����,��Ϊ������ܻ��ڳ��ڱȽ϶�),������֤�ݲ�����
find first pt_mstr
    no-lock
    where pt_part = {2}
    no-error.
if not(available(pt_mstr)) then do:
    display
        "���ϱ�����Ч" @ {4}
    with frame {5}.
    undo {6}, retry {6}.
end.
*/

