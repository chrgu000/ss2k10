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
define variable open_ref like wo_qty_ord label "短缺量".
define variable open_ref-1 like wo_qty_ord label "短缺量".

define variable desc1 like pt_desc1.
define variable wrstatus as character format "X(8)" label "状态".
define variable wostatus as character format "X(12)" label "状态".

define variable wkctr like wr_wkctr.
define variable wkctr1 like wr_wkctr.
define variable op like wr_op .
define variable op1 like wr_op .
define variable mch like wr_mch.
define variable mch1 like wr_mch.
define variable sort_op as logical label "一序一单".
define variable total_time like wr_run column-label "标准工时".
define variable start  like wr_star.
define variable start1 like wr_star.
define variable due    like wr_due.
define variable due1   like wr_due.
define variable rel like wo_rel_date.
define variable rel1 like wo_rel_date.
define variable printline as character format "x(90)" extent 26.
define variable addprint  as character format "x(90)" extent 26.
define buffer wrroute for wr_route.
    define variable nextctr like wr_wkctr.
    define variable nextop like wr_op .
    define variable nextctrdesc like wc_desc.
    define variable nextopdesc like wr_desc .






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
    rel       colon 15
    rel1      label {t001.i} colon 49

    skip(1)
    sort_op   colon 15
    SKIP(.4)
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
        if rel = low_date then rel = ?.
        if rel1 = hi_date then rel1 = ?.
				
				 update nbr nbr1 lot lot1 part part1 so_job so_job1
                vend vend1 wkctr wkctr1 mch mch1 op op1 start start1 due due1 rel rel1 sort_op with frame a.


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
            {mfquoter.i rel   }
            {mfquoter.i rel1  }

            {mfquoter.i sort_op}

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
            if rel = ? then rel = low_date.
            if rel1 = ? then rel1 = hi_date.


					{mfselbpr.i "printer" 132}



                    if not sort_op then do:
/* SS 090925.1 - B */
/*
                        {mfphead.i}
*/
                        {mfphead1.i}
/* SS 090925.1 - E */
                        put skip(1).
                        put "加工单 / 标 志                                        已完成量/        " at 1.
                        put "   工序 / 标准工序        零   件   号       订 货 量  工作中心 ST 准时/单时  员工姓名 员工编号    完 工 量     备 注  " at 1.
                        put "------------------ ------------------------ --------- --------- -- ---------  -------- -------- -------------- --------------" at 1.

                        for each wo_mstr where 
                            /* *ss_20090225* */  wo_domain = global_domain and
                            (wo_nbr >= nbr and wo_nbr <= nbr1)
                            and (wo_lot >= lot and wo_lot <= lot1)
                            and (wo_part >= part and wo_part <= part1)
                            and (wo_so_job >= so_job and wo_so_job <= so_job1)
                            and (wo_vend >= vend and wo_vend <= vend1)
                            and (wo_rel_date >= rel and wo_rel_date <= rel1)
                            and wo_status = "r"
                            no-lock by wo_nbr by wo_part
                            with frame b width 132 no-attr-space:

                            if page-size - line-counter < 4 then do:
                                page.
                                put skip(1).
                                put "加工单 / 标 志                                        已完成量/        " at 1.
                                put "   工序 / 标准工序        零   件   号       订 货 量  工作中心 ST 准时/单时  员工姓名 员工编号    完 工 量     备 注  " at 1.
                                put "------------------ ------------------------ --------- --------- -- ---------  -------- -------- -------------- --------------" at 1.
                            end.


                            if not can-find
                            (first wr_route where 
                            /* *ss_20090225* */  wr_domain = global_domain and
                            wr_lot = wo_lot
                            and wr_wkctr >= wkctr and wr_wkctr <= wkctr1
                            and wr_op >= op and wr_op <= op1
                            and wr_mch >= mch and wr_mch <= mch1
                            and wr_start >= start and wr_start <= start1
                            and wr_due >= due and wr_due <= due1
                            ) then next.



                            open_ref-1 = max(wo_qty_ord - wo_qty_comp - wo_qty_rjct ,0).
                            if wo_status = "C"  then open_ref-1 = 0.

                            put wo_nbr at 1 wo_part at 20 wo_qty_ord format ">>>>>9.9<" to 53 wo_qty_comp format ">>>>>9.9<" to 63 wo_status  at 65.

                            find pt_mstr where 
                            /* *ss_20090225* */  pt_domain = global_domain and
                            pt_part = wo_part no-lock no-error.
                            if available pt_mstr and pt_desc1 <> "" then do:
                                put wo_lot at 9 pt_desc1 at 22 pt_desc2 at 48.
                            end.
                            else do:
                                put wo_lot at 9 skip(1).
                            end.

                            for each wr_route where 
                                /* *ss_20090225* */  wr_domain = global_domain and
                                wr_lot = wo_lot
                                and wr_wkctr >= wkctr and wr_wkctr <= wkctr1
                                and wr_op >= op and wr_op <= op1
                                and wr_mch >= mch and wr_mch <= mch1
                                and wr_start >= start and wr_start <= start1
                                and wr_due >= due and wr_due <= due1
                                no-lock by wr_op with frame b:

                                open_ref = max(wr_qty_ord - (wr_qty_comp + wr_sub_comp) - wr_qty_rjct ,0).

                                if wo_status = "C" or wr_status = "C" then open_ref = 0.


                                total_time = open_ref * wr_run.



                                put "GX:" at 1 string(wr_op) format "x(6)" at 4 wr_std_op at 11 wr_desc at 20 wr_qty_ord format ">>>>>9.9<" to 53 wr_qty_comp format ">>>>>>.<<" to 63 wr_status at 65 wr_setup format ">>9.99<<" to 76 .
                                put "________________________ _________" to 53 wr_wkctr to 65 wr_run format ">>9.999<<" to 76 "________ ________ ______________ ______________" at 79.
                                if page-size - line-counter < 2 then do:
                                    put skip(1).
                                    page.
                                    put skip(1).
                                    put "加工单 / 标 志                                        已完成量/        " at 1.
                                    put "   工序 / 标准工序        零   件   号       订 货 量  工作中心 ST 准时/单时  员工姓名 员工编号    完 工 量     备 注  " at 1.
                                    put "------------------ ------------------------ --------- --------- -- ---------  -------- -------- -------------- --------------" at 1.
                                end.


/* SS 090924.1 - B */
/*
                                {mfguirex.i  "false"}
*/
/* SS 090924.1 - E */

                            end.

                            if page-size - line-counter >=1 and line-counter >6 then do:
                                put "------------------ ------------------------ --------- --------- -- --------   -------- -------- -------------- --------------" at 1.
                            end.


/* SS 090924.1 - B */
/*
                            {mfguirex.i }
*/
/* SS 090924.1 - E */

                        end.
                    end.
                    else do:


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
                            and (wo_rel_date >= rel and wo_rel_date <= rel1)
                            and (wo_status = "R")
                            no-lock by wr_part by wr_op with frame c STREAM-IO width 132 no-labels no-box:

                            open_ref = max(wr_route.wr_qty_ord - (wr_route.wr_qty_comp + wr_route.wr_sub_comp) - wr_route.wr_qty_rjct ,0).
                            total_time = open_ref * wr_route.wr_run.

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



                            addprint[1]   = "  员工号码：_____________    姓名：________________    班组：_________     单位：         ".
                            printline[1]  = "┌───┬────┬────┬─────┬──┬────┬──┬────────────┐".
                            printline[2]  = "│部 门 │        │工作中心│          │设备│        │描述│                        │".
                            printline[3]  = "├───┼────┴─┬──┼─────┼──┴─┬──┴──┴┬───┬───────┤".
                            printline[4]  = "│加工单│            │标志│          │开始日期│            │到期日│              │".
                            printline[5]  = "├───┼──────┴──┼──┬──┴────┴──────┴───┴───────┤".
                            printline[6]  = "│零 件 │                  │描述│                                                    │".
                            printline[7]  = "├───┼───┬──┬──┴──┴────┬───┬──────┬───┬──────┤".
                            printline[8]  = "│工 序 │      │描述│                    │需求量│            │短缺量│            │".
                            printline[9]  = "├───┼───┼──┴┬─────────┴──┬┴───┬──┴───┴──────┤".
                            printline[10] = "│加工量│      │下工序│                        │工作中心│                          │".
                            printline[11] = "├───┴──┬┴───┴───┬──────┬─┴────┴┬────┬───────┤".
                            printline[12] = "│标准准备时间│                │标准工时/件 │              │合计工时│              │".
                            printline[13] = "├──────┼────────┼──────┼───────┼────┴─┬─────┤".
                            printline[14] = "│实际准备时间│                │实际加工工时│              │ 首检(日/月)│          │".
                            printline[15] = "├──────┼───┬──┬─┴─┬──┬─┴─┬──┬──┴┬──┬──┴┬────┤".
                            printline[16] = "│分厂验收合格│      │可用│      │废品│      │签字│      │日期│      │完成工时│".
                            printline[17] = "├──────┼───┼──┼───┼──┼───┼──┼───┼──┼───┼────┤".
                            printline[18] = "│总厂验收合格│      │可用│      │废品│      │签字│      │日期│      │        │".
                            printline[19] = "├──────┴───┴──┴───┴──┴───┴──┴───┴──┴───┴────┤".
                            printline[20] = "│  转出人：___________  签收人：___________  实收量：____________ 日期:____________    │".
                            printline[21] = "├───────────────────────────────────────────┤".
                            printline[22] = "│                                                                                      │".
                            printline[23] = "│                                                                                      │".
                            printline[24] = "│                                                                                      │".
                            printline[25] = "└───────────────────────────────────────────┘".

                            display "工   艺   流   程   单" at 37 skip(1).
                            display "员工号码：____________     工作者：______________     班组：___________ "  at 6 "   单位：" pt_um.
                            display printline[1] at 5.
                            display "│部 门 │" at 5  wc_dept at 15 "│工作中心│" at 23 wr_route.wr_wkctr at 35 "│设备│" at 45 wr_route.wr_mch at 53 "│描述│" at 61 wc_desc at 69 "│" at 93.
                            display printline[3] at 5.
                            display "│加工单│" at 5 wo_nbr format "X(12)" at 15 "│标志│" at 27 wo_lot at 35 "│开始日期│" at 45 wr_route.wr_start format "99/99/9999" at 58 "│到期日│" at 69 wr_route.wr_due format "99/99/9999" at 80 "│" at 93.
                            display printline[5] at 5.
                            display "│零 件 │" at 5 wo_part at 15 "│描述│" at 33 pt_desc1 format "x(24)" at 41 pt_desc2 format "x(24)" to 92 "│" at 93 .
                            display printline[7] at 5.
                            display "│工 序 │" at 5 wr_route.wr_op at 15 "│描述│" at 21 wr_route.wr_desc format "x(20)" at 29 "│需求量│" at 49 wr_route.wr_qty_ord format ">>>>>>>9.99" to 70 "│短缺量│" at 71 open_ref format ">>>>>>>9.99" at 81  "│" at 93.
                            display printline[9] at 5.
                            display "│加工量│      │下工序│" at 5 string(nextop) + ' ' + nextopdesc format "x(24)" at 31   "│工作中心│" at 55 nextctr + " " + nextctrdesc format "x(26)" at 67 "│" at 93.
                            display printline[11] at 5.
                            display "│标准准备时间│" at 5 wr_route.wr_setup to 36 "│标准工时/件 │" at 37 wr_route.wr_run to 66  "│合计工时│" at 67 total_time to 92 "│" at 93.
                            display printline[13] at 5.
                            display printline[14] at 5.
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
                            display printline[25] at 5 skip(1).
                            display "--------------------------------------------------------------------------------------------------" at 2 skip(2).

                            down.

                        end.
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