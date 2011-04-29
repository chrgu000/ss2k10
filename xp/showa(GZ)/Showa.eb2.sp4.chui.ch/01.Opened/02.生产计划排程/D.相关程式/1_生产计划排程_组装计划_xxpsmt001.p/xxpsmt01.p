/* xxpsmt01.p  生产计划排程_组装计划  */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110330.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

{mfdtitle.i "110331"}
{mfsprtdf.i new} /*for xxgpseloutxp.i*/

{xxpsmt01var.i "new"}

define var v_days           as integer .
define var v_qty_min        as decimal .
define var v_qty_max        as decimal .
define var v_ii             as integer .
define var v_jj             as integer .

define var v_time_stock     as integer  . /*取几点的库存*/
define var v_time_chg       as decimal  . /*产线的机种换线时间*/
define var v_time_tmp       as decimal  . /*产线的机种换线时间2*/
define var v_time_used      as decimal  . /*已使用的产能时间*/
define var v_part_prev      as char  .
define var v_part_next      as char  .


define var v_is_mp           as logical .
define var v_qty_prod        as decimal .
define var v_qty_rq_need1    as decimal .
define var v_qty_rq_need2    as decimal .
define var v_qty_rq_used     as decimal .
define var v_qty_per_min     as decimal .
define var v_qty_lot         as decimal .

define var v_time_test_b     as integer .
v_rev = "Test"  .    /*版本号规则未加???*/
/*v_rev代表本次运算的版本,周计划,月计划都截取自这里 */


/*test ???*/ v_month = 1 .


form
    SKIP(.2)
    site             colon 28 label "地点"
    v_week           colon 28 label "周计划(0-4)"
    v_month          colon 28 label "月计划(0-6)"
    v_sortby         colon 28 label "系统顺序1/固定顺序2"
    skip(1) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

mainloop:
repeat:

    v_time_test_b = time .

    /*所有待解决的疑问标有问号 ? ************************************/

    /*目前程式逻辑:全从today开始排程, 后2天的是否参与排程计算逻辑未加??? */

    /*临时表,变量等初始化,选择条件输入*/
    {xxpsmt01i01.i}

    /*查找纳入,from sod_det,包含之前未结的*/
    {xxpsmt01i02.i}

    /*计算排程期内,每天的MP件的库存基准*/
    {xxpsmt01i03.i}

    /*排程期内的排程工单(wo_type = "S"),可以不用删除,待由排程表更新排程工单时处理. */

    /*计算排产前的理论库存=(实际库存+未结进度工单-未结销售纳入)*/   
    {xxpsmt01i04.i}

    /*开始排产前的错误检查,有错发生则打印,且中断程式*/
    {xxpsmt01i05.i}
    
    /*计算排程时间点的可用容器数*/  /*容器共用,稍后限制排程程式仅限一人执行!***???*/
    {xxpsmt01i06.i}


    /*查找排程的主生产线,副生产线,及对应产能 */
    {xxpsmt01i07.i}


    /*按v_sortby取的是系统顺序还是固定顺序,计算每个产线的最优排产顺序*/
    {xxpsmt01i08.i}

    /*计算排程期内,各产线每天的可用产能*/
    {xxpsmt01i09.i}

    /*截止排产日,各产线,各班次,已经耗用的加班数??????*/
    {xxpsmt01i10.i}

    /*排程主逻辑*/
    {xxpsmt01i11.i}

    
    /*排程结果打印到文件*/
    find first xps_mstr where xps_rev = v_rev no-lock no-error.
    if not avail xps_mstr then do:
        message "错误:排程未产生" .
        undo,retry.
    end.
    else do:
        {gprun.i ""xxpsmt01ptestprint.p"" } /*print test report*/

         /*{gprun.i ""xxpsmt01p05.p"" } print the result */
    end.

end.  /* mainloop: */
