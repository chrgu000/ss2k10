/* xxwowrrp.p - Work Routing  Print  for                            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* REVISION: 8.6      LAST MODIFIED: 12/05/99   BY: jym *Jy001*         */
/* Revision: Version.ui    Modified: 02/25/2009   By: Kaine Zhang     Eco: *ss_20090225* */
/* SS - 090924.1 By: Neil Gao */

&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "090924.1"}

define variable nbr  like wo_nbr label "�ӹ�����".
define variable nbr1 like wo_nbr.
define variable lot  like wo_lot.
define variable lot1 like wo_lot.
define variable job  like wo_so_job.
define variable job1 like wo_so_job.
define variable part  like wo_part.
define variable part1 like wo_part.
define variable wkctr  like wr_wkctr.
define variable wkctr1 like wr_wkctr.
define variable desc1 like pt_desc1.
define variable first_pass like mfc_logical.
define variable site  like wo_site.
define variable site1 like wo_site.
define variable desc2 like pt_desc2.
define variable open_ref like wo_qty_ord.
define variable mmmmm like wo_qty_ord.
define variable wcdesc like wc_desc.
define variable um like pt_um.
define variable ptloc like pt_loc.
define variable pline  as char format "x(215)".
define variable pline1 as char format "x(215)".
define variable mpart like pt_part label "�����".

define variable desc1-c like pt_desc1.
define variable desc2-c like pt_desc2.
define variable printline as character format "x(90)" extent 60.


&SCOPED-DEFINE PP_FRAME_NAME A

FORM
wkctr          colon 20
wkctr1         label {t001.i} colon 49 skip
nbr            colon 20
nbr1           label {t001.i} colon 49 skip
lot            colon 20
lot1           label {t001.i} colon 49 skip
part           colon 20
part1          label {t001.i} colon 49 skip
site           colon 20
site1          label {t001.i} colon 49 skip
job            colon 20
job1           label {t001.i} colon 49 skip (1)
with frame a width 80 side-labels.

setFrameLabels(frame a:handle).

&UNDEFINE PP_FRAME_NAME

repeat:

    if wkctr1 = hi_char then wkctr1 = "".
    if nbr1 = hi_char then nbr1 = "".
    if lot1 = hi_char then lot1 = "".
    if part1 = hi_char then part1 = "".
    if site1 = hi_char then site1 = "".
    if job1 = hi_char then job1 = "".


   	update wkctr wkctr1 nbr nbr1 lot lot1 part part1 site site1 job job1 with frame a.


    bcdparm = "".
    {mfquoter.i wkctr       }
    {mfquoter.i wkctr1      }
    {mfquoter.i nbr         }
    {mfquoter.i nbr1        }
    {mfquoter.i lot         }
    {mfquoter.i lot1        }
    {mfquoter.i part        }
    {mfquoter.i part1       }
    {mfquoter.i site        }
    {mfquoter.i site1       }
    {mfquoter.i job         }
    {mfquoter.i job1        }


    if  wkctr1 = "" then wkctr1 = hi_char.
    if  nbr1 = "" then nbr1 = hi_char.
    if  lot1 = "" then lot1 = hi_char.
    if  job1 = "" then job1 = hi_char.
    if  part1 = "" then part1 = hi_char.
    if  site1 = "" then site1 = hi_char.



					{mfselbpr.i "printer" 132}

                printline[1]  = "���������Щ��������Щ��������Щ����������Щ����Щ��������Щ����Щ�������������������������".
                printline[2]  = "����  �ũ�        ���������ĩ�          ���豸��        ��������                        ��".
                printline[3]  = "���������੤�������੤�������੤���������੤���ة��Щ����ة����ةЩ������Щ���������������".
                printline[4]  = "���ӹ�����        �� ��  ־ ��          ���´����ک�            �������թ�              ��".
                printline[5]  = "���������੤�������ة��������੤���Щ����ة��������ة������������ة������ة���������������".
                printline[6]  = "������ũ�                  ��������                                                    ��".
                printline[7]  = "���������੤�����Щ����Щ����ة����ة��������Щ������Щ������������Щ������Щ�������������".
                printline[8]  = "����  ��      ��������                    ����������            ����ȱ����            ��".
                printline[9]  = "���������੤�����੤���੤���������Щ������Щة������ة������������ة������ة�������������".
                printline[10] = "��׼  ʱ��23.123����ʱ��123.123456���������                                            ��".
                printline[11] = "���������ةЩ����ة����ة��Щ������ةЩ����ة��Щ����Щ������������Щ��������Щ�����������".
                printline[14] = "������������12345.12345678��ɳ�����        �����       ��/�թ���ʼ���ک�          ��".
                printline[15] = "�����������ة��������������ة��������ة��������ة����ة��Щ��������ة��������ة�����������".
                printline[16] = "��                  ��  ��  ��  ¼                      ��       ��  ��  ��  ¼         ��".
                printline[17] = "���������������������������������������������������������੤���Щ����Щ����Щ����Щ�������".
                printline[18] = "��������:                    ������:                    ��һɳ����ɳ����ɳ�� �� ��  ��  ��".
                printline[19] = "��Ա�����:                  Ա�����:                  �����ͩ����ͩ����ͩ� �� ��  ��  ��".
                printline[20] = "���������Щ��������Щ��������Щ������������Щ�������������Ʒ����Ʒ����Ʒ���� �� ��  Ա  ��".
                printline[22] = "���� �� ��ʵ������������������  ͣ��ԭ��  ��  ��     ע ��    ��    ��    �� �� �� ǩ�� ��".
                printline[23] = "���������੤�������੤�������੤�����������੤�����������੤���੤���੤���੤���੤������".
                printline[24] = "��      ��        ��        ��            ��            ��    ��    ��    ��    ��      ��".
                printline[25] = "���������੤�������੤�������੤�����������੤�����������੤���੤���੤���੤���੤������".
                printline[26] = "��      ��        ��        ��            ��            ��    ��    ��    ��    ��      ��".
                printline[27] = "���������੤�������੤�������੤�����������੤�����������੤���੤���੤���੤���੤������".
                printline[28] = "��      ��        ��        ��            ��            ��    ��    ��    ��    ��      ��".
                printline[29] = "���������੤�������੤�������੤�����������੤�����������੤���੤���੤���੤���੤������".
                printline[30] = "��      ��        ��        ��            ��            ��    ��    ��    ��    ��      ��".
                printline[31] = "���������੤�������੤�������੤�����������੤�����������੤���੤���੤���੤���੤������".
                printline[32] = "��      ��        ��        ��            ��            ��    ��    ��    ��    ��      ��".
                printline[33] = "���������੤�������੤�������੤�����������੤�����������੤���੤���੤���੤���੤������".
                printline[34] = "��      ��        ��        ��            ��            ��    ��    ��    ��    ��      ��".
                printline[35] = "���������੤�������੤�������੤�����������੤�����������੤���੤���੤���੤���੤������".
                printline[36] = "��      ��        ��        ��            ��            ��    ��    ��    ��    ��      ��".
                printline[37] = "���������੤�������੤�������੤�����������੤�����������੤���੤���੤���੤���੤������".
                printline[38] = "��      ��        ��        ��            ��            ��    ��    ��    ��    ��      ��".
                printline[39] = "���������੤�������੤�������੤�����������੤�����������੤���੤���੤���੤���੤������".
                printline[40] = "��      ��        ��        ��            ��            ��    ��    ��    ��    ��      ��".
                printline[41] = "���������੤�������੤�������੤�����������੤�����������੤���੤���੤���੤���੤������".
                printline[42] = "��      ��        ��        ��            ��            ��    ��    ��    ��    ��      ��".
                printline[43] = "���������੤�������੤�������੤�����������੤�����������੤���੤���੤���੤���੤������".
                printline[44] = "��      ��        ��        ��            ��            ��    ��    ��    ��    ��      ��".
                printline[45] = "���������੤�������੤�������੤�����������੤�����������੤���੤���੤���੤���੤������".
                printline[46] = "��      ��        ��        ��            ��            ��    ��    ��    ��    ��      ��".
                printline[47] = "���������੤�������੤�������੤�����������੤�����������੤���੤���੤���੤���੤������".
                printline[48] = "��      ��        ��        ��            ��            ��    ��    ��    ��    ��      ��".
                printline[49] = "���������੤�������੤�������੤�����������੤�����������੤���੤���੤���੤���੤������".
                printline[50] = "��      ��        ��        ��            ��            ��    ��    ��    ��    ��      ��".
                printline[51] = "���������੤�������੤�������੤�����������੤�����������੤���੤���੤���੤���੤������".
                printline[52] = "��      ��        ��        ��            ��            ��    ��    ��    ��    ��      ��".
                printline[53] = "���������੤�������੤�������੤�����������੤�����������੤���੤���੤���੤���੤������".
                printline[54] = "��      ��        ��        ��            ��            ��    ��    ��    ��    ��      ��".
                printline[55] = "���������੤�������੤�������੤�����������੤�����������੤���੤���੤���੤���੤������".
                printline[56] = "��      ��        ��        ��            ��            ��    ��    ��    ��    ��      ��".
                printline[57] = "���������ة��������ة��������ة������������ة������������ة����ة����ة����ة����ة�������".

                for each wc_mstr where 
                    /* *ss_20090225* */  wc_domain = global_domain and
                    (wc_wkctr >= wkctr and wc_wkctr <= wkctr1)
                    use-index wc_wkctr by wc_wkctr by wc_mch :

                    for each wr_route where 
                        /* *ss_20090225* */  wr_domain = global_domain and
                        ( wr_wkctr = wc_wkctr )
                        and (wr_nbr >= nbr and wr_nbr <= nbr1)
                        and (wr_lot >= lot and wr_lot <= lot1),
                        each wo_mstr where wo_status = "R" and wo_lot = wr_lot
                        and (wo_part >= part) and (wo_part <= part1 or part1 = "")
                        and (wo_so_job >= job) and (wo_so_job <= job1 or job1 = "")
                        and (wo_site >= site) and (wo_site <= site1 or site1 = "")
                        break by wr_wkctr by wr_part by wr_nbr by wr_lot by wr_op with frame b1 down width 132:

                        desc1 = "".
                        desc1 = "".
                        desc1-c = "".
                        um = "".
                        mmmmm = 0.
                        mpart = "".
                        find first pt_mstr where 
                        /* *ss_20090225* */  pt_domain = global_domain and
                        pt_part = wo_part use-index pt_part no-lock no-error.
                        if available pt_mstr then
                        assign ptloc = pt_loc
                        desc1 = pt_desc1
                        desc2 = pt_desc2.

                        find first wod_det where 
                        /* *ss_20090225* */  wod_domain = global_domain and
                        wod_lot = wo_lot use-index  wod_det no-lock no-error.
                        if available wod_det then
                        assign mpart = wod_part
                        mmmmm = wod_qty_req / wo_qty_ord.
                        find first pt_mstr where 
                        /* *ss_20090225* */  pt_domain = global_domain and
                        pt_part = mpart use-index pt_part no-lock no-error.
                        if available pt_mstr then
                        desc1-c = trim(pt_desc1) + " " + pt_desc2.
                        um = pt_um.

                        put "��   ��   ��   ��   �� ( ˫  ��  ��  ��  ��  ��  Ʊ )"  at 23 skip(1).
                        put "���������Щ��������Щ��������Щ����������Щ����Щ��������Щ����Щ�������������������������" at 5 skip.
                        put "����  �ũ�" at 5  wc_dept at 15 "���������ĩ�" at 23 wr_route.wr_wkctr at 35 "���豸��" at 45 wr_route.wr_mch at 53 "��������" at 61 wc_desc at 69 "��" at 93.
                        put "���������੤�������੤�������੤���������੤���ة��Щ����ة����ةЩ������Щ���������������" at 5.
                        put "���ӹ�����" at 5 wo_nbr format "X(8)" at 15 "�� ��  ־ ��" at 23 wo_lot at 35 "����ʼ���ک�" at 45 wr_route.wr_start format "99/99/9999" at 58 "�������թ�" at 69 wr_route.wr_due format "99/99/9999" at 80 "��" at 93.
                        put "���������੤�������ة��������੤���Щ����ة��������ة������������ة������ة���������������" at 5.
                        put "������ũ�" at 5 wo_part at 15 "��������" at 33 desc1 format "x(24)" at 41 desc2 format "x(24)" to 92 "��" at 93 .
                        put "���������੤�����Щ����Щ����ة����ة��������Щ������Щ������������Щ������Щ�������������" at 5.
                        open_ref = max(wr_qty_ord - wr_qty_comp , 0 ) .
                        put "����  ��" at 5 wr_route.wr_op at 15 "��������" at 21 wr_route.wr_desc format "x(20)" at 29 "����������" at 49 wr_route.wr_qty_ord format ">>>>>>>9.99" to 70 "����ȱ����" at 71 open_ref format ">>>>>>>9.99" at 81  "��" at 93.
                        put "���������੤�����੤���੤���������Щ������Щة������ة������������ة������ة�������������" at  5.
                        put "��׼  ʱ��" at 5 wr_route.wr_setup format ">9.99<" to 20 "����ʱ��" at 21 wr_route.wr_run format ">>>9.99<<<" to 38 "���������" at 39 trim(mpart) + " " + desc1-c format "x(43)" at 49  "��" at 93.
                        put "���������ةЩ����ة����ة��Щ������ةЩ����ة��Щ����Щ������������Щ��������Щ�����������" at 5.
                        put "������������" at 5 mmmmm format ">>>>9.99<" to 26 um at 29 "��ɳ�����        �����       ��/�թ���ʼ���ک�          ��" to 94.
                        put printline[15] at 5.
                        put printline[16] at 5.
                        put printline[17] at 5.
                        put printline[18] at 5.
                        put printline[19] at 5.
                        put printline[20] at 5.
                        put printline[22] at 5.
                        put printline[23] at 5.
                        put printline[24] at 5.
                        put printline[25] at 5.
                        put printline[26] at 5.
                        put printline[27] at 5.
                        put printline[28] at 5.
                        put printline[29] at 5.
                        put printline[30] at 5.
                        put printline[31] at 5.
                        put printline[32] at 5.
                        put printline[33] at 5.
                        put printline[34] at 5.
                        put printline[35] at 5.
                        put printline[36] at 5.
                        put printline[37] at 5.
                        put printline[38] at 5.
                        put printline[39] at 5.
                        put printline[40] at 5.
                        put printline[41] at 5.
                        put printline[42] at 5.
                        put printline[43] at 5.
                        put printline[44] at 5.
                        put printline[45] at 5.
                        put printline[46] at 5.
                        put printline[47] at 5.
                        put printline[48] at 5.
                        put printline[49] at 5.
                        put printline[50] at 5.
                        put printline[51] at 5.
                        put printline[52] at 5.
                        put printline[53] at 5.
                        put printline[54] at 5.
                        put printline[55] at 5.
                        put printline[56] at 5.
                        put printline[57] at 5 skip(1).
                        page.

                    end.
/* SS 090924.1 - B */
/*
                    {mfguirex.i }
*/
/* SS 090924.1 - E */
                end.




                {mfreset.i}

                {mfgrptrm.i}

            end.

