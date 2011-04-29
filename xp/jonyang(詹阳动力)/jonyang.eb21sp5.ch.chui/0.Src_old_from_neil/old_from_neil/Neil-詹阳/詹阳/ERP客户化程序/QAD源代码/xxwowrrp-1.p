/* xxwowrrp.p - Work Routing  Print  for                            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* REVISION: 8.6      LAST MODIFIED: 12/05/99   BY: jym *Jy001*         */
/* Revision: Version.ui    Modified: 02/25/2009   By: Kaine Zhang     Eco: *ss_20090225* */
/* SS - 090924.1 By: Neil Gao */

&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "090924.1"}

define variable nbr  like wo_nbr label "加工单号".
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
define variable usrname like usr_name format "X(24)".
define variable open_ref like wo_qty_ord.
define variable mmmmm like wo_qty_ord.
define variable wcdesc like wc_desc.
define variable um like pt_um.
define variable ptloc like pt_loc.
define variable pline  as char format "x(215)".
define variable pline1 as char format "x(215)".
define variable mpart like pt_part label "子零件".


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

mainloop:
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
					
            mainloop: do on error undo, return error on endkey undo, return error:




                for each wc_mstr where 
                    /* *ss_20090225* */  wc_domain = global_domain and 
                    (wc_wkctr >= wkctr and wc_wkctr <= wkctr1)
                    use-index wc_wkctr by wc_wkctr by wc_mch :

                    for each wr_route where 
                        /* *ss_20090225* */  wr_domain = global_domain and
                        ( wr_wkctr = wc_wkctr )
                        and (wr_nbr >= nbr and wr_nbr <= nbr1)
                        and (wr_lot >= lot and wr_lot <= lot1),
                    each wo_mstr where 
                        /* *ss_20090225* */  wo_domain = global_domain and
                        wo_status = "R" and wo_lot = wr_lot
                        and (wo_part >= part) and (wo_part <= part1 or part1 = "")
                        and (wo_so_job >= job) and (wo_so_job <= job1 or job1 = "")
                        and (wo_site >= site) and (wo_site <= site1 or site1 = "")
                        break by wr_wkctr by wr_part by wr_nbr by wr_lot by wr_op with frame b1 down width 132:

                        setFrameLabels(frame b1:handle).
                        	
                        desc1 = "".
                        um = "".
                        ptloc = "".
                        find first pt_mstr where 
                        /* *ss_20090225* */  pt_domain = global_domain and
                        pt_part = wo_part use-index pt_part no-lock no-error.
                        if available pt_mstr then
                        assign ptloc = pt_loc
                        desc1 = pt_desc1 + pt_desc2
                        um = pt_um
                        usrname = "".
                        if first-of(wr_nbr) and first-of(wr_lot) then do:
                            if page-size - line-count < 9 then page.
                            put "工艺流程单(2)   工作中心：" at 2  wc_wkctr at 28  "描述：" at 42  wc_desc at 48  " 雇员：_________________  下达日期：_________ " at 88 .
                            pline =  "│加工单│" + string(wo_nbr,"x(12)" ) + "│标志│" + string(wo_lot,"x(8)") + "│零号件│" + string(wo_part,"x(18)") + "│单位│" + pt_um + "│描述│" + string(desc1,"x(46)") + "│" .
                            put "┌───┬──────┬──┬────┬───┬─────────┬──┬─┬──┬───────────────────────┐" at 2 skip.
                            put pline at 2  skip.
                            put "├───┴──────┴──┴────┴───┴─────────┴──┴─┼──┴────┬───┬───────────┬──┤" at 2.
                            put "│加工单需求量：" at 2 wo_qty_ord to 30 " 完成量：" at 32  wo_qty_comp to 54 " 短缺量：" at 56 wo_qty_ord - wo_qty_comp - wo_qty_rjct to 76.
                            put "│  实 际 工 时 │首  检│                      │完成│" at 78.
                            put "│ 工 序       描          述      准备工时 单件工时  需求量  短缺量  加工量│准  备  单  件│签  名│合格数  报废数  检查员│日期│" at 2.
                            put "├───┬────────────┬───┬────┬───┬───┬───┼───┬───┼───┼───┬───┬───┼──┤" at 2.
                        end.
                        open_ref = max(wr_qty_ord - wr_qty_comp - wr_qty_rjct , 0 ) .
                        pline1 = "│" + string(wr_op,">>>>>>") + "│" + string(wr_desc,"x(24)") + "│" + string(wr_setup, ">9.999")
                        + "│" + string(wr_run,">>9.9999") + "│" + string(wr_qty_ord,">>>9.9") + "│" + string(open_ref,">>>9.9") + "│      │      │      │      │      │      │      │    │".

                        put pline1 at 2 skip.

                        if last-of(wr_lot) then do:
                            put "└───┴────────────┴───┴────┴───┴───┴───┴───┴───┴───┴───┴───┴───┴──┘" at 2 skip.
                            put skip(2).
                        end.
                        else do:
                            if page-size - line-count <= 3 then do:
                                put "└───┴────────────┴───┴────┴───┴───┴───┴───┴───┴───┴───┴───┴───┴──┘" at 2 skip.
                                page.
                                put "工艺流程单(2)   工作中心：" at 2  wc_wkctr at 28  "描述：" at 42  wc_desc at 48  " 雇员：_________________  下达日期：_________ " at 88 .
                                pline =  "│加工单│" + string(wo_nbr,"x(12)" ) + "│标志│" + string(wo_lot,"x(8)") + "│零号件│" + string(wo_part,"x(18)") + "│单位│" + pt_um + "│描述│" + string(desc1,"x(46)") + "│" .
                                put "┌───┬──────┬──┬────┬───┬─────────┬──┬─┬──┬───────────────────────┐" at 2 skip.
                                put pline at 2  skip.
                                put "├───┴──────┴──┴────┴───┴─────────┴──┴─┼──┴────┬───┬───────────┬──┤" at 2.
                                put "│加工单需求量：" at 2 wo_qty_ord to 30 " 完成量：" at 32  wo_qty_comp to 54 " 短缺量：" at 56 wo_qty_ord - wo_qty_comp - wo_qty_rjct to 76.
                                put "│  实 际 工 时 │首  检│                      │完成│" at 78.
                                put "│ 工 序       描          述      准备工时 单件工时  需求量  短缺量  加工量│准  备  单  件│签  名│合格数  报废数  检查员│日期│" at 2.
                                put "├───┬────────────┬───┬────┬───┬───┬───┼───┬───┼───┼───┬───┬───┼──┤" at 2.
                            end.
                            else
                            put "├───┼────────────┼───┼────┼───┼───┼───┼───┼───┼───┼───┼───┼───┼──┤" at 2 skip.
                        end.
/* SS 090924.1 - B */
											if not last(wr_wkctr) then do:
                        if last-of(wr_wkctr) then page.
                        if page-size - line-count < 3 then page.
                      end.
/* SS 090924.1 - E */
                    end.

/* SS 090924.1 - B */
/*
                    {mfguirex.i }
*/
/* SS 090924.1 - E */

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


end. /* mainloop */