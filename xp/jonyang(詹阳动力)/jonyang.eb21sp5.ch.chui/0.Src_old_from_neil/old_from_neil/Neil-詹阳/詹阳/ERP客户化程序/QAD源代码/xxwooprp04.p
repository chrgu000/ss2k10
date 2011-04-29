/* xxwooprp01.p - WORK ORDER OPERATION REPORT                             */
/* GUI CONVERTED from wooprp.p (converter v1.69) Sat Mar 30 01:26:44 1996 */
/* wooprp.p - WORK ORDER OPERATION REPORT                               */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      LAST MODIFIED: 04/15/86   BY: PML      */
/* REVISION: 1.0      LAST MODIFIED: 05/06/86   BY: EMB      */
/* REVISION: 1.0      LAST MODIFIED: 09/12/86   BY: EMB *12* */
/* REVISION: 2.1      LAST MODIFIED: 10/19/87   BY: WUG *A94**/
/* REVISION: 4.0      LAST MODIFIED: 02/17/88   BY: RL  *A171**/
/* REVISION: 4.0      LAST MODIFIED: 02/24/88   BY: WUG *A175**/
/* REVISION: 4.0      LAST MODIFIED: 04/05/88   BY: WUG *A194**/
/* REVISION: 5.0      LAST MODIFIED: 04/10/89   BY: MLB *B096**/
/* REVISION: 5.0      LAST MODIFIED: 10/26/89   BY: emb *B357**/
/* REVISION: 6.0      LAST MODIFIED: 10/29/90   BY: WUG *D151**/
/* REVISION: 6.0      LAST MODIFIED: 01/22/91   BY: bjb *D248**/
/* REVISION: 6.0      LAST MODIFIED: 08/21/91   BY: bjb *D811**/
/* REVISION: 7.3      LAST MODIFIED: 04/27/92   BY: pma *G999**/
/* Revision: Version.ui    Modified: 02/25/2009   By: Kaine Zhang     Eco: *ss_20090225* */
/* SS - 090924.1 By: Neil Gao */

&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE

&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "090924.1"}

define variable nbr like wr_nbr.
define variable nbr1 like wr_nbr.
define variable lot like wr_lot.
define variable lot1 like wr_lot.
define variable vend like wo_vend.
define variable vend1 like wo_vend.
define variable part like wo_part.
define variable part1 like wo_part.
define variable so_job like wo_so_job.
define variable so_job1 like wo_so_job.
define variable open_ref like wo_qty_ord label "��ȱ��".
define variable desc1 like pt_desc1.
define variable wrstatus as character format "X(8)" label "״̬".
define variable wostatus as character format "X(12)" label "״̬".

define variable wkctr like wr_wkctr.
define variable wkctr1 like wr_wkctr.
define variable op like wr_op .
define variable op1 like wr_op .
define variable mch like wr_mch.
define variable mch1 like wr_mch.
define variable total_time like wr_run column-label "��׼��ʱ".
define variable start  like wr_star.
define variable start1 like wr_star.
define variable due    like wr_due.
define variable due1   like wr_due.
define variable printline as character format "x(90)" extent 28.
define variable addprint  as character format "x(90)" extent 28.
define buffer wrroute for wr_route.
define variable nextctr like wr_wkctr.
define variable nextop like wr_op .
define variable nextctrdesc like wc_desc.
define variable nextopdesc like wr_desc .

define variable mpart like pt_part label "�����".
define variable um like pt_um.
define variable desc1-c like pt_desc1.
define variable mmmmm like wo_qty_ord.



&SCOPED-DEFINE PP_FRAME_NAME A

FORM
nbr            colon 15
nbr1           label {t001.i} colon 49
lot            colon 15
lot1           label {t001.i} colon 49
part           colon 15
part1          label {t001.i} colon 49
so_job         colon 15
so_job1        label {t001.i} colon 49
vend           colon 15
vend1          label {t001.i} colon 49
wkctr     colon 15
wkctr1    label {t001.i} colon 49
mch       colon 15
mch1      label {t001.i} colon 49
op        colon 15
op1       label {t001.i} colon 49
start     colon 15
start1    label {t001.i} colon 49
due       colon 15
due1      label {t001.i} colon 49
with frame a side-labels width 80 attr-space.

setFrameLabels(frame a:handle).

&UNDEFINE PP_FRAME_NAME

repeat:

    if nbr1 = hi_char then nbr1 = "".
    if lot1 = hi_char then lot1 = "".
    if part1 = hi_char then part1 = "".
    if so_job1 = hi_char then so_job1 = "".
    if vend1 = hi_char then vend1 = "".
    if wkctr1 = hi_char then wkctr1 = "".
    if mch1 = hi_char then mch1 = "".
    if op1 = 999999 then op1 = 0.
    if start = low_date then start = ?.
    if start1 = hi_date then start1 = ?.
    if due = low_date then due = ?.
    if due1 = hi_date then due1 = ?.

		update nbr nbr1 lot lot1 part part1 so_job so_job1
    vend vend1 wkctr wkctr1 mch mch1 op op1 start start1 due due1 with frame a.

		
    bcdparm = "".
    {mfquoter.i nbr    }
    {mfquoter.i nbr1   }
    {mfquoter.i lot    }
    {mfquoter.i lot1   }
    {mfquoter.i wkctr }
    {mfquoter.i wkctr1 }
    {mfquoter.i mch   }
    {mfquoter.i mch1  }
    {mfquoter.i op    }
    {mfquoter.i op1   }
    {mfquoter.i start }
    {mfquoter.i start1}
    {mfquoter.i due   }
    {mfquoter.i due1  }

    if  nbr1 = "" then nbr1 = hi_char.
    if  lot1 = "" then lot1 = hi_char.
    if  part1 = "" then part1 = hi_char.
    if  so_job1 = "" then so_job1 = hi_char.
    if  vend1 = "" then vend1 = hi_char.
    if wkctr1 = "" then wkctr1 = hi_char.
    if mch1 = "" then mch1 = hi_char.
    if op1 = 0 then op1 = 999999.
    if start = ? then start = low_date .
    if start1 = ? then start1 = hi_date.
    if due = ? then due = low_date.
    if due1 = ? then due1 = hi_date.


					{mfselbpr.i "printer" 132}

        for each wr_route where 
            /* *ss_20090225* */  wr_domain = global_domain and
            wr_lot >= lot and wr_lot <= lot1
            and wr_wkctr >= wkctr and wr_wkctr <= wkctr1
            and wr_op >= op and wr_op <= op1
            and wr_mch >= mch and wr_mch <= mch1
            and wr_start >= start and wr_start <= start1
            and wr_due >= due and wr_due <= due1
            and wr_nbr >= nbr and wr_nbr <= nbr1,
            each wo_mstr where 
            /* *ss_20090225* */  wo_domain = global_domain and
            (wo_lot = wr_lot)
            and (wo_part >= part and wo_part <= part1)
            and (wo_so_job >= so_job and wo_so_job <= so_job1)
            and (wo_vend >= vend and wo_vend <= vend1)
            and (wo_status = "R")
            no-lock by wr_part by wr_op with frame c STREAM-IO width 132 no-labels no-box:

            open_ref = max(wr_route.wr_qty_ord - (wr_route.wr_qty_comp + wr_route.wr_sub_comp),0).
            total_time = open_ref * wr_route.wr_run.

            desc1-c = "".
            um = "".
            mmmmm = 0.
            mpart = "".

            find first wod_det where 
            /* *ss_20090225* */  wod_domain = global_domain and
            wod_lot = wo_lot use-index  wod_det no-lock no-error.
            if available wod_det then do:
                assign mpart = wod_part
                mmmmm = wod_qty_req / wo_qty_ord.
                find first pt_mstr where 
                /* *ss_20090225* */  pt_domain = global_domain and
                pt_part = mpart use-index pt_part no-lock no-error.
                if available pt_mstr then assign
                desc1-c = trim(pt_desc1) + " " + pt_desc2
                um = pt_um.
                else assign desc1-c= ""
                um = pt_um.
            end.
            else assign mpart = ""
            mmmmm = 0.

            find first wrroute where 
            /* *ss_20090225* */  wrroute.wr_domain = global_domain and
            wrroute.wr_nbr = wr_route.wr_nbr
            and wrroute.wr_lot = wr_route.wr_lot
            and wrroute.wr_op > wr_route.wr_op
            use-index wr_nbrop no-lock no-error.

            if available wrroute then assign nextctr = wrroute.wr_wkctr
            nextop = wrroute.wr_op
            nextopdesc = wrroute.wr_desc.
            else assign nextctr = ""
            nextop = 0
            nextopdesc = "".
            find first wc_mstr where 
            /* *ss_20090225* */  wc_domain = global_domain and
            wc_wkctr = wrroute.wr_wkctr and wc_mch = wrroute.wr_mch no-lock no-error.
            if available wc_mstr then nextctrdesc = wc_desc.
            else nextctrdesc = "".


            if wo_status = "C" or wr_route.wr_status = "C" then do:
                open_ref = 0.
                next.
            end.

            find pt_mstr where 
            /* *ss_20090225* */  pt_domain = global_domain and
            pt_part = wo_part no-lock no-error.
            find first wc_mstr where 
            /* *ss_20090225* */  wc_domain = global_domain and
            wc_wkctr = wr_route.wr_wkctr and wc_mch = wr_route.wr_mch no-lock no-error.

            if page-size - line-counter < 27 then page.

            addprint[1]   = "  Ա�����룺_____________    ������________________________    ���飺_______    ��λ��    ".
            printline[1]  = "���������Щ��������Щ��������Щ����������Щ����Щ��������Щ����Щ�������������������������".
            printline[2]  = "���� �� ��        ���������ĩ�          ���豸��        ��������                        ��".
            printline[3]  = "���������੤�������੤�������੤���������੤���ة��Щ����ة����ةЩ������Щ���������������".
            printline[4]  = "���ӹ�����        �� ��  ־ ��          ����ʼ���ک�            �������թ�              ��".
            printline[5]  = "���������੤�������ة��������੤���Щ����ة��������ة������������ة������ة���������������".
            printline[6]  = "���� �� ��                  ��������                                                    ��".
            printline[7]  = "���������੤�����Щ����Щ����ة����ة��������Щ������Щ������������Щ������Щ�������������".
            printline[8]  = "���� �� ��      ��������                    ����������            ����ȱ����            ��".
            printline[9]  = "���������੤�����੤���ةЩ������������������ة����Щة������Щ����ة������ة�������������".
            printline[10] = "���ӹ�����      ���¹���                        ���������ĩ�                          ��".
            printline[11] = "�������Щة����Щة��Щ��ة������Щ����Щ����������੤�������੤���Щ������������Щ�������".
            printline[12] = "��׼ʱ��      ����ʱ��          ���ϼƩ�          ��ʵ��׼ʱ��    ��ʵ�ʼӹ���ʱ��      ��".
            printline[13] = "�������ةЩ����ة����ة����������ة����ة����������ة��������ة����੤�������Щ��ة�������".
            printline[14] = "���������12345678901234567890123456789012345678901234567890123456������������12345678  ��".
            printline[15] = "�������Щة����Щ��������Щ������Щ����Щ������Щ������Щ����������ة��������ة�����������".

            printline[16] = "��Ӳ�ȩ�      ����Ʒ���ة�      �����ة�      �������ߩ�                                ��".
            printline[17] = "�������ة������੤�����Щة��Щ��ةЩ��ةЩ����੤���Щة��Щ������Щ����������Щ���������".
            printline[18] = "���ֳ����պϸ�      �����é�    �����ϩ�    ���Ϸϩ�    �����Ա��          ����ɹ�ʱ��".
            printline[19] = "���������������੤�����੤���੤���੤���੤���੤���੤���੤�����੤���������੤��������".
            printline[20] = "���ܳ����պϸ�      �����é�    �����ϩ�    ���Ϸϩ�    �����Ա��          ��        ��".
            printline[21] = "�����������Щ��ة������੤���ة����ةЩ��ة����੤���ة����੤�����ةЩ��������੤��������".
            printline[22] = "����Ʒ���ة�          ����Ʒ������ʱ��        ����Ʒ�ܹ�ʱ��        ��������ک�        ��".
            printline[23] = "�����������ة����������ة������������ة��������ة����������ة��������ة��������ة���������".
            printline[24] = "��  ת���ˣ�___________  ǩ���ˣ�___________  ʵ������____________ ����:____________    ��".
            printline[25] = "������������������������������������������������������������������������������������������".
            printline[26] = "�� ʩ��˵����                                                                           ��".
            printline[27] = "������������������������������������������������������������������������������������������".
            display "��   ��   ��   ��   ��" at 37 .
            display "Ա�����룺____________     �����ߣ�______________     ���飺___________ "  at 6 "   ��λ��" pt_um.
            display printline[1] at 5.
            display "���� �� ��" at 5  wc_dept at 15 "���������ĩ�" at 23 wr_route.wr_wkctr at 35 "���豸��" at 45 wr_route.wr_mch at 53 "��������" at 61 wc_desc at 69 "��" at 93.
            display printline[3] at 5.
            display "���ӹ�����" at 5 wo_nbr format "X(8)" at 15 "�� ��  ־ ��" at 23 wo_lot at 35 "����ʼ���ک�" at 45 wr_route.wr_start format "99/99/9999" at 58 "�������թ�" at 69 wr_route.wr_due format "99/99/9999" at 80 "��" at 93.
            display printline[5] at 5.
            display "���� �� ��" at 5 wo_part at 15 "��������" at 33 pt_desc1 format "x(24)" at 41 pt_desc2 format "x(24)" to 92 "��" at 93 .
            display printline[7] at 5.
            display "���� �� ��" at 5 wr_route.wr_op at 15 "��������" at 21 wr_route.wr_desc format "x(20)" at 29 "����������" at 49 wr_route.wr_qty_ord format ">>>>>>>9.99" to 70 "����ȱ����" at 71 open_ref format ">>>>>>>9.99" at 81  "��" at 93.
            display printline[9] at 5.
            display "���ӹ�����      ���¹���" at 5 string(nextop) + ' ' + nextopdesc format "x(24)" at 31   "���������ĩ�" at 55 nextctr + " " + nextctrdesc format "x(26)" at 67 "��" at 93.
            display printline[11] at 5.
            display "��׼ʱ��" at 5 wr_route.wr_setup format ">9.99<" to 18 "����ʱ��" at 19 wr_route.wr_run format ">>>9.99<<<" to 36  "���ϼƩ�" at 37 total_time format ">>>>9.99<<" to 54 "��ʵ��׼ʱ��    ��ʵ�ʼӹ���ʱ��      ��" at 55.
            display printline[13] at 5.
            display "���������" at 5 trim(mpart) + " " + desc1-c format "x(56)" at 15 "������������" at 71 mmmmm format ">>>9.99<" at 83 um at 91 "��" at 93 .
            display printline[15] at 5.
            display printline[16] at 5.
            display printline[17] at 5.
            display printline[18] at 5.
            display printline[19] at 5.
            display printline[20] at 5.
            display printline[21] at 5.
            display printline[22] at 5.
            display printline[23] at 5.
            display printline[24] at 5.
            display printline[25] at 5.
            display printline[26] at 5.
            display printline[27] at 5 skip(1).
            display "--------------------------------------------------------------------------------------------------" at 2 skip(1).

            down.

        end.

/* SS 090924.1 - B */
/*
 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .
*/
		{mfreset.i}
		{mfgrptrm.i}
/* SS 090924.1 - E */
    end.

