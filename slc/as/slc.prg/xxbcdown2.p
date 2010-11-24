/* Creation: eB21SP3 Chui Last Modified: 20081011 By: Davild Xu *ss-20081011.1*/
/* SS - 090915.1 By: Neil Gao */
/* SS - 100429.1 By: Kaine Zhang */

/* SS - 100429.1 - RNB
[100429.1]
本次修改前逻辑顺序:
    ......
    1. 下线.
    2. 生产入库.
    3. 订单出货.
    4. 判断,本包是否属于进出口的.
    5. 如果是,进出口,则向进出口发送xx数据.
    ......

与四轮车(集团),吴一凡电话后.
认为有些问题,需更改.

现更改为:
    ......
    1. 下线.
    2. 判断,本包是否属于进出口的.
    3. 如果是,则
        3.1 生产入库.
        3.2 订单出货.
        3.3 向进出口发送xx数据.
    ......
[100429.1]
SS - 100429.1 - RNE */

/* SS 090915.1 - B */
/*
进出口下线
*/
/* SS 090915.1 - E */

/* TODO
有可能打印 发动机+车架号VIN
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
DEFINE  new shared VARIABLE barcode_vin_id  LIKE xxsovd_id .    /*VIN码*/
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
wolot   colon 18 label "工单ID"     wo_nbr colon 49 label "计划号"
wo_part colon 18 label "成  品"     wo_qty_ord label "派工数量" colon 49
so_cust colon 18 label "客  户"     v_qty_line label "下线数量" colon 49
skip(1)
motorVin    colon 18 label "发动机号"
vin     COLON 18 label "VIN码"
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
                message "未做上线扫描,不能做下线处理!" view-as alert-box .
                next .
            end.
            /*---Add Begin by davild 20081117.1*/
            /*增加显示1.12 前4行 LLCLSD1009F000001 */
            find first cd_det where cd_domain = global_domain
            and cd_ref = xxsovd_part   /*子件状态*/
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
            else display "料号:" + xxsovd_part + " 未维护1.12" @ cd_cmmt[1] with frame Fdesc .
            /*---Add End   by davild 20081117.1*/
            checknumber = "2" .
            {gprun.i ""xxddcheckvinhist.p""
            "(input vin,
            input xxsovd_wolot ,
            input checknumber ,
            output cimError)"}
            if cimError then do:
                message "VIN码 " + vin + " 已经下线了,不需要再次下线." view-as alert-box .
                next .
            end.
            /*自动更新历史记录xxvind_det和汇总记录xxvin_mstr*/
            /*检查是否已下线
            checknumber = 1=上线
            checknumber = 2=下线
            checknumber = 3=检测
            checknumber = 4=包装
            checknumber = 5=入库
            checknumber = 6=装箱    loc 此时要为 装箱单号
            checknumber = 7=出库
            */
            checknumber = "2" .
            {gprun.i ""xxddupdatevinhist.p""
            "(input vin,
            input motorvin ,
            input xxsovd_wolot ,
            input loc,
            input checknumber ,
            output cimError)"}
            message "VIN码 " + vin + " 下线成功." .

            /* SS 090915.1 - B */
            /*入库成品如机组，单机动力*/
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

                    /*自动更新历史记录xxvind_det和汇总记录xxvin_mstr*/
                    /*检查是否已下线
                    checknumber = 1=上线
                    checknumber = 2=下线
                    checknumber = 3=检测
                    checknumber = 4=包装
                    checknumber = 5=入库
                    checknumber = 6=装箱    loc 此时要为 装箱单号
                    checknumber = 7=出库
                    */
                    checknumber = "5" .
                    {gprun.i ""xxddupdatevinhist.p""
                    "(input vin,
                    input motorvin ,
                    input xxsovd_wolot ,
                    input loc,
                    input checknumber ,
                    output cimError)"}
                    message "VIN码 " + string(vin) + " 入库成功." .
                    if cimError then undo,next .
                end.
                else do:
                    message "入库动作失败，请联系管理员." view-as alert-box .
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
            and tr_serial = xxvind_lot      /*批号*/
            and trim(tr_vend_lot) = ""  /*---Add by davild 20081011.1*/
            NO-ERROR.
            IF not AVAIL tr_hist THEN do:
                msg = "VIN码:" + xxvind_id + "没有出库成功".
                display msg with frame a .
                undo,next .
            end.
            /*---Add by davild 20080107.1*/
            else do:
                unix silent value ( "rm -f "  + Trim(usection) + ".i").
                unix silent value ( "rm -f "  + Trim(usection) + ".o").
                message "VIN码 " + string(vin) + " 装箱成功." .
                assign tr_vend_Lot = "BcPackNo:" .
                assign tr__chr06 = xxvind_id .      /*VIN 码*/

                /*自动更新历史记录xxvind_det和汇总记录xxvin_mstr*/
                /*检查是否已下线
                checknumber = 1=上线
                checknumber = 2=下线
                checknumber = 3=检测
                checknumber = 4=包装
                checknumber = 5=装箱
                checknumber = 6=装箱    loc 此时要为 装箱单号
                checknumber = 7=出库
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
            message "VIN码不存在!" view-as alert-box .
        end.
    end.
    leave .
END.

{wbrp04.i &frame-spec = a}
