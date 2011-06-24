/* xsgetpartlot.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/*
 *  ��ɨ���������,��ȡ���ϱ���,����,��Ӧ��.
 *  {1} -- ������Դ.
 *  {2} -- ���ϱ���
 *  {3} -- ����
 *  {4} -- ��Ϣ��ʾ����
 *  {5} -- ��ʾ���ĸ�frame��
 *  {6} -- �����,������loop
 *  {7} -- ��Ӧ�̱���
 */  

/* *ss_20090730* ���������ȷ��,�������ǳ����׼����,����б�׼ת��. */
if {1} = "" then do:
    display
        "���벻������" @ {4}
    with frame {5}.
    undo {6}, retry {6}.
end.
if substring({1}, length({1}, "RAW"), 1) = "+" then do:
    {1} = substring({1}, 4, length({1}, "RAW") - 4, "RAW").
    {1} = replace({1}, "-", "$").
end.

assign
    {2} = ""
    {3} = ""
    .

assign    
    {2} = entry(1, {1}, sDelimiter)
    {3} = entry(2, {1}, sDelimiter)
    no-error
    .
    
if error-status:error then do:
    display
        "�������������Ŵ���" @ {4}
    with frame {5}.
    undo {6}, retry {6}.
end.

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

{7} = substring({3}, 7, 4).
