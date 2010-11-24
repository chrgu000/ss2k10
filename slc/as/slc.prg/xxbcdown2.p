/* Creation: eB21SP3 Chui Last Modified: 20081011 By: Davild Xu *ss-20081011.1*/
/* SS - 090915.1 By: Neil Gao */
/* SS - 100429.1 By: Kaine Zhang */

/* SS - 100429.1 - RNB
[100429.1]
�����޸�ǰ�߼�˳��:
    ......
    1. ����.
    2. �������.
    3. ��������.
    4. �ж�,�����Ƿ����ڽ����ڵ�.
    5. �����,������,��������ڷ���xx����.
    ......

�����ֳ�(����),��һ���绰��.
��Ϊ��Щ����,�����.

�ָ���Ϊ:
    ......
    1. ����.
    2. �ж�,�����Ƿ����ڽ����ڵ�.
    3. �����,��
        3.1 �������.
        3.2 ��������.
        3.3 ������ڷ���xx����.
    ......
[100429.1]
SS - 100429.1 - RNE */

/* SS 090915.1 - B */
/*
����������
*/
/* SS 090915.1 - E */

/* TODO
�п��ܴ�ӡ ������+���ܺ�VIN
*/  /*---Remark by davild 20081011.1*/

{mfdtitle.i "100429.1"}

DEFINE new shared VARIABLE loginyn as logical .
view frame dtitle .
/*Definition*/
DEFINE VARIABLE vin like xxsovd_id .
DEFINE VARIABLE motorVin like xxsovd_id .
DEFINE VARIABLE qty as inte .
DEFINE VARIABLE i as inte .
DEFINE VARIABLE printyn as logi .
DEFINE VARIABLE updatexxsovd_det_ok as logi .
DEFINE VARIABLE wolot as char .
DEFINE VARIABLE loc as char init "".
define var site like ld_site.

DEFINE  new shared VARIABLE lang            LIKE lng_lang .
DEFINE  new shared VARIABLE barcode_domain  LIKE wo_domain .
DEFINE  new shared VARIABLE barcode_part        LIKE wo_part .
DEFINE  new shared VARIABLE barcode_cust        LIKE so_cust .
DEFINE  new shared VARIABLE barcode_wo_nbr  LIKE wo_nbr .
DEFINE  new shared VARIABLE barcode_wo_lot  LIKE wo_lot .
DEFINE  new shared VARIABLE barcode_sod_nbr LIKE sod_nbr .
DEFINE  new shared VARIABLE barcode_sod_line    LIKE sod_line .
DEFINE  new shared VARIABLE barcode_sod_ord_date    LIKE so_ord_date .
DEFINE  new shared VARIABLE barcode_site        LIKE wo_site .
DEFINE  new shared VARIABLE barcode_wo_vend LIKE wo_vend .
DEFINE  new shared VARIABLE barcode_vin_id  LIKE xxsovd_id .    /*VIN��*/
DEFINE  new shared VARIABLE barcode_lang        LIKE lng_lang .
DEFINE  new shared VARIABLE barcode_end     as char format "x(30)" .


DEFINE   VARIABLE barcode_print_type        as char  .
DEFINE   VARIABLE barcode_path      as char  .
DEFINE   VARIABLE cust          LIKE so_cust .
DEFINE   VARIABLE part          LIKE pt_part .
DEFINE VARIABLE tmp as char extent 16 .
/*---Add Begin by davild 20080107.1*/
DEFINE VARIABLE checknumber as char .
DEFINE VARIABLE cimError as logi .
DEFINE VARIABLE v_nbr  as char .
DEFINE VARIABLE v_line as char .
DEFINE VARIABLE v_qty_line like wo_qty_ord .
/*---Add End   by davild 20080107.1*/
/* SS 090915.1 - B */
/*
define variable usection as char format "x(16)".
*/
DEFINE VARIABLE msg as char format "x(60)" .
/* SS 090915.1 - E */

FORM
SKIP(1)  /*GUI*/
wolot   colon 18 label "����ID"     wo_nbr colon 49 label "�ƻ���"
wo_part colon 18 label "��  Ʒ"     wo_qty_ord label "�ɹ�����" colon 49
so_cust colon 18 label "��  ��"     v_qty_line label "��������" colon 49
skip(1)
motorVin    colon 18 label "��������"
vin     COLON 18 label "VIN��"
/* SS 090915.1 - B */
msg at 1 no-label
/* SS 090915.1 - E */
SKIP(1)  /*GUI*/
WITH FRAME a SIDE-LABELS WIDTH 80 attr-space  THREE-D.
/*setFrameLabels(frame a:handle).*/


{wbrp01.i}
lang = "US" .

REPEAT :
    vin = "" .
    repeat:
        find first wo_mstr where wo_domain = global_domain and wo_lot = wolot  no-lock no-error.
        if avail wo_mstr then do:
            find first so_mstr where so_domain = global_domain and so_nbr = substring(wo_nbr,1,8) no-lock no-error.
            display wo_nbr
            wo_part
            wo_qty_ord
            so_cust
            wolot
            with frame a .
            find first xxvin_mstr where xxvin_domain    = global_domain
            and xxvin_wolot = wolot
            and xxvin_part  = wo_part
            no-lock no-error.
            if avail xxvin_mstr then do:
                assign v_qty_line = xxvin_qty_down .
                display v_qty_line with frame a .
            end.
        end.

        UPDATE
        vin
        WITH FRAME a.

        assign updatexxsovd_det_ok = no .
        find first  xxsovd_det where xxsovd_domain = global_domain and xxsovd_id = vin no-error.
        if avail xxsovd_det then do:
            wolot = xxsovd_wolot .
            find first xxvind_det where xxvind_domain = global_domain and xxvind_id = vin
            and xxvind_up_date <> ? no-lock no-error.
            if not avail xxvind_det  then do:
                message "δ������ɨ��,���������ߴ���!" view-as alert-box .
                next .
            end.
            /*---Add Begin by davild 20081117.1*/
            /*������ʾ1.12 ǰ4�� LLCLSD1009F000001 */
            find first cd_det where cd_domain = global_domain
            and cd_ref = xxsovd_part   /*�Ӽ�״̬*/
            and cd_type = "SC"
            and cd_lang = "CH"
            and cd_seq  = 0
            no-lock no-error.
            if avail cd_det then do:
                display
                cd_cmmt[1] no-label
                cd_cmmt[2] no-label
                cd_cmmt[3] no-label
                cd_cmmt[4] no-label
                with frame Fdesc row 15 overlay.
            end.
            else display "�Ϻ�:" + xxsovd_part + " δά��1.12" @ cd_cmmt[1] with frame Fdesc .
            /*---Add End   by davild 20081117.1*/
            checknumber = "2" .
            {gprun.i ""xxddcheckvinhist.p""
            "(input vin,
            input xxsovd_wolot ,
            input checknumber ,
            output cimError)"}
            if cimError then do:
                message "VIN�� " + vin + " �Ѿ�������,����Ҫ�ٴ�����." view-as alert-box .
                next .
            end.
            /*�Զ�������ʷ��¼xxvind_det�ͻ��ܼ�¼xxvin_mstr*/
            /*����Ƿ�������
            checknumber = 1=����
            checknumber = 2=����
            checknumber = 3=���
            checknumber = 4=��װ
            checknumber = 5=���
            checknumber = 6=װ��    loc ��ʱҪΪ װ�䵥��
            checknumber = 7=����
            */
            checknumber = "2" .
            {gprun.i ""xxddupdatevinhist.p""
            "(input vin,
            input motorvin ,
            input xxsovd_wolot ,
            input loc,
            input checknumber ,
            output cimError)"}
            message "VIN�� " + vin + " ���߳ɹ�." .

            /* SS 090915.1 - B */
            /*����Ʒ����飬��������*/
            /* SS - 100429.1 - B */
            find first so_mstr where so_domain = global_domain and so_nbr = xxvind_nbr no-lock no-error.
                if avail so_mstr then do:
                    find first cm_mstr where cm_domain = global_domain and cm_addr = so_cust and cm_type = "S3" no-lock no-error.
                    if avail cm_mstr then do:
            /* SS - 100429.1 - E */
            site = "10000" .
            loc  = "CJ01" .
            cimError = yes .
            do /*transaction*/ :
                {gprun.i ""xxddautoworc.p""
                "(input vin,
                input site,
                input loc,
                output cimError)"}
                if cimError = no then do:

                    /*�Զ�������ʷ��¼xxvind_det�ͻ��ܼ�¼xxvin_mstr*/
                    /*����Ƿ�������
                    checknumber = 1=����
                    checknumber = 2=����
                    checknumber = 3=���
                    checknumber = 4=��װ
                    checknumber = 5=���
                    checknumber = 6=װ��    loc ��ʱҪΪ װ�䵥��
                    checknumber = 7=����
                    */
                    checknumber = "5" .
                    {gprun.i ""xxddupdatevinhist.p""
                    "(input vin,
                    input motorvin ,
                    input xxsovd_wolot ,
                    input loc,
                    input checknumber ,
                    output cimError)"}
                    message "VIN�� " + string(vin) + " ���ɹ�." .
                    if cimError then undo,next .
                end.
                else do:
                    message "��⶯��ʧ�ܣ�����ϵ����Ա." view-as alert-box .
                    undo,next .
                end.
            end.    /*do transaction*/

            {xxddautosois.i
            xxvind_nbr
            string(xxvind_line)
            """1"""
            """10000"""
            """CJ01"""
            xxvind_lot
            """ """
            }

            FIND LAST tr_hist WHERE tr_domain = global_domain
            AND tr_type = "ISS-SO"
            and tr_effdate = today
            and tr_part = xxvind_part
            AND tr_nbr = xxvind_nbr
            AND tr_loc = "CJ01" AND tr_qty_loc = -1
            and tr_serial = xxvind_lot      /*����*/
            and trim(tr_vend_lot) = ""  /*---Add by davild 20081011.1*/
            NO-ERROR.
            IF not AVAIL tr_hist THEN do:
                msg = "VIN��:" + xxvind_id + "û�г���ɹ�".
                display msg with frame a .
                undo,next .
            end.
            /*---Add by davild 20080107.1*/
            else do:
                unix silent value ( "rm -f "  + Trim(usection) + ".i").
                unix silent value ( "rm -f "  + Trim(usection) + ".o").
                message "VIN�� " + string(vin) + " װ��ɹ�." .
                assign tr_vend_Lot = "BcPackNo:" .
                assign tr__chr06 = xxvind_id .      /*VIN ��*/

                /*�Զ�������ʷ��¼xxvind_det�ͻ��ܼ�¼xxvin_mstr*/
                /*����Ƿ�������
                checknumber = 1=����
                checknumber = 2=����
                checknumber = 3=���
                checknumber = 4=��װ
                checknumber = 5=װ��
                checknumber = 6=װ��    loc ��ʱҪΪ װ�䵥��
                checknumber = 7=����
                */
                checknumber = "7" .
                pause 0 .
                {gprun.i ""xxddupdatevinhist.p""
                "(input xxvind_id,
                input motorvin ,
                input xxvind_wolot ,
                input '',
                input checknumber ,
                output cimError)"}
                if cimError then undo,next .
                
                /* SS - 100429.1 - B
                find first so_mstr where so_domain = global_domain and so_nbr = xxvind_nbr no-lock no-error.
                if avail so_mstr then do:
                    find first cm_mstr where cm_domain = global_domain and cm_addr = so_cust and cm_type = "S3" no-lock no-error.
                    if avail cm_mstr then do:
                SS - 100429.1 - E */
                        if not connected("qadmid") then do:
                            connect midtest -ld qadmid -H 127.0.0.1 -S 16034 -N TCP.
                        end.
                        {gprun.i ""xxbccku2a.p""
                        "(input xxvind_id,
                        input motorvin ,
                        output cimError)" }
                        if cimError then undo,next.
                /* SS - 100429.1 - B
                    end.
                end. /* if avail so_mstr */
                SS - 100429.1 - E */

            end. /* else do: */

            /* SS 090915.1 - E */
            /* SS - 100429.1 - B */
                end.
            end.
            /* SS - 100429.1 - E */

        end.
        else do:
            message "VIN�벻����!" view-as alert-box .
        end.
    end.
    leave .
END.

{wbrp04.i &frame-spec = a}
