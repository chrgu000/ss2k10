/* xxbmpsrp10.p - bom runtime report                                          */
/* REVISION:101020.2 LAST MODIFIED: 10/20/10 BY: zy                           */
/* REVISION:101028.1 LAST MODIFIED: 10/28/10 BY: zy                       *as**/
/*-Revision end---------------------------------------------------------------*/
/* Environment: Progress:10.1b   QAD:eb21sp5                                  */

/*as*/ /* {mfdtitle.i "101020.2"} */
/*as*/ {mfdtitle.i "101028.1"}
define VARIABLE vpar     LIKE pt_part initial "".
define VARIABLE vscrppct as DECIMAL format "->>>>9.9<<<%" INITIAL 101.35.
define VARIABLE vscrppca as DECIMAL format "->>>>>>>9.9<<<<<<".
define VARIABLE vwopct   as DECIMAL format "->>>>9.9<<<%" INITIAL 110.22.
define VARIABLE vwopca   as DECIMAL format "->>>>>>>9.9<<<<<<".
define VARIABLE vlbrpct  as DECIMAL format "->>>>9.9<<<"  INITIAL 0.08.
define VARIABLE vmfgpct  as DECIMAL format "->>>>9.9<<<"  INITIAL 0.13.
define variable vptdesc  like pt_desc1 format "x(72)" no-undo.
define variable vpsdesc  like pt_desc1 format "x(72)" no-undo.
define variable venddate as   date     no-undo.  /*program end date variable*/
define variable venddays as   integer  no-undo.  /*program end date variable*/
define variable vqty1    as   decimal  no-undo.
define variable varset   like ro_setup no-undo.
define variable varrun   like ro_run   no-undo.
define variable varcst   as   decimal  no-undo.
define BUFFER psmstr  for ps_mstr.

/*** 此表用于确定那个材料是vpart下的非虚零件要显示在报表上                ****/
define temp-table levx no-undo
  fields levx_part like pt_part
  fields levx_set  like ro_setup
  fields levx_run  like ro_run
  fields levx_qty  like ps_qty_per.

/*此表用于存储下层物料的工时准备时间明细*/
define temp-table tmprun no-undo
  fields tmprun_part like pt_part
  fields tmprun_set  like ro_setup format "->>>>>>9.9<<<<<"
  index tmprun_part tmprun_part.

/* 计算累计加工时间*/
/* 用到的表有tmpbomdet tmprundet*/
/* 用到的procedure有 gettmprundet gettmpbomdet getRunTime */

/*此表用于保存需要计算工时料号的层次数据*/
define temp-table tmpbomdet no-undo
  fields tbd_part like ps_comp
  fields tbd_level as integer
  index tbd_part tbd_part.

/*此表用于保存每个料号的累加工时*/
define temp-table tmprundet no-undo
  fields trd_part like ro_routing
  fields trd_run  like ro_run
  index trd_part trd_part.

/**此表保存最终结果                                                          */
define temp-table tmpbom
  fields tbm_sn   as   integer
  fields tbm_part like pt_part
  fields tbm_comp like pt_part
/*as*/ /*  fields tbm_pqty like ps_qty_per  format "->>>>>>9.9<<<<"  */
/*as*/ /*  fields tbm_cqty like ps_qty_per  format "->>>>>9.9<<<<"   */
/*as*/ /*  fields tbm_cost like sct_cst_tot format "->>>>>9.9<<<<"   */
/*as*/ /*  fields tbm_set  like ro_setup    format "->>>>>>9.9<<<<<" */
/*as*/ /*  fields tbm_run  like ro_run      format "->>>>>>9.9<<<<<" */
/*as*/  fields tbm_pqty as decimal format "->>>>>>9.9<<<<"
/*as*/  fields tbm_cqty as decimal format "->>>>>9.9<<<<"
/*as*/  fields tbm_cost as decimal format "->>>>>9.9<<<<"
/*as*/  fields tbm_set  as decimal format "->>>>>>9.9<<<<<"
/*as*/  fields tbm_run  as decimal format "->>>>>>9.9<<<<<"
  fields tbm_mtl_cst as decimal  format "->>>>>>9.9<<<<"
  fields tbm_lbr_cst as decimal  format "->>>>>>9.9<<<<"
  fields tbm_bdn_cst as decimal  format "->>>>>>9.9<<<<"
  fields tbm_cst     as decimal  format "->>>>>>9.9<<<<"
  fields tbm_unit_cost as decimal  format "->>>>>>>>9.9<<<<"
  index tbm_part_comp tbm_part tbm_comp.

form
    vpar     colon 15
    vscrppct colon 15
    vwopct   colon 15
    vlbrpct  colon 15
    vmfgpct  colon 15 skip
with frame a side-labels width 80.
setframelabels(frame a:handle).
find first qad_wkfl no-lock where
           qad_wkfl.qad_domain = global_domain and
           qad_wkfl.qad_key1 = "xxbmpsrp10.p.param" and
           qad_wkfl.qad_key2 = global_userid
           no-error.
if available qad_wkfl then do:
    assign vpar     = qad_wkfl.qad_charfld[1]
           vscrppct = qad_wkfl.qad_decfld[1]
           vwopct   = qad_wkfl.qad_decfld[2]
           vlbrPct  = qad_wkfl.qad_decfld[3]
           vmfgpct  = qad_wkfl.qad_decfld[4].
end.
else do:
     if vscrppct <> 1.0135 then vscrppct = 101.35.
     if vwopct <> 110.22 then vwopct = 110.22.
     if vlbrPct <> 0.08 then vlbrpct = 0.08.
     if vmfgpct <> 0.13 then vmfgpct = 0.13.
end.
{wbrp01.i}
mainloop:
repeat with frame a
    on endkey undo, leave:
    update vpar vscrppct vwopct vlbrpct vmfgpct.
    if (c-application-mode <> 'web')
        or (c-application-mode = 'web' and (c-web-request begins 'data'))
    then do:
        bcdparm = "".
        {mfquoter.i vpar    }
        {mfquoter.i vscrppct}
        {mfquoter.i vwopct  }
        {mfquoter.i vlbrpct }
        {mfquoter.i vmfgpct }
    end.

    find first qad_wkfl exclusive-lock where
               qad_wkfl.qad_domain = global_domain and
               qad_wkfl.qad_key1 = "xxbmpsrp10.p.param" and
               qad_wkfl.qad_key2 = global_userid
               no-error.
    if available qad_wkfl then do:
       if not locked(qad_wkfl) then do:
          assign qad_wkfl.qad_charfld[1] = vpar
                 qad_wkfl.qad_decfld[1] = vscrppct
                 qad_wkfl.qad_decfld[2] = vwopct
                 qad_wkfl.qad_decfld[3] = vlbrPct
                 qad_wkfl.qad_decfld[4] = vmfgpct.
       end.
    end.
    else do:
         create qad_wkfl.
         assign qad_wkfl.qad_domain = global_domain
                qad_wkfl.qad_key1 = "xxbmpsrp10.p.param"
                qad_wkfl.qad_key2 = global_userid
                qad_wkfl.qad_charfld[1] = vpar
                qad_wkfl.qad_decfld[1] = vscrppct
                qad_wkfl.qad_decfld[2] = vwopct
                qad_wkfl.qad_decfld[3] = vlbrPct
                qad_wkfl.qad_decfld[4] = vmfgpct.
    end.
/*as*/ /*   assign venddate = date(11,1,2010).                                */
/*as*/ /*   if venddate - today <= 0 then do:                                 */
/*as*/ /*       {pxmsg.i &MSGNUM=2261 &ERRORLEVEL=3}                          */
/*as*/ /*        undo mainloop,retry.                                         */
/*as*/ /*   end.                                                              */
/*as*/ /*   if venddate - today <= 5 then do:                                 */
/*as*/ /*       venddays = venddate - today.                                  */
/*as*/ /*       {pxmsg.i &MSGNUM=5580 &ERRORLEVEL=2 &MSGARG1=venddays         */
/*as*/ /*                &MSGARG2=venddate}                                   */
/*as*/ /*   end.                                                              */

    /* output destination selection */
    {gpselout.i
        &printtype = "page"
        &printwidth = 380
        &pagedflag = "nopage"
        &stream = " "
        &appendtofile = " "
        &streamedoutputtoterminal = " "
        &withbatchoption = "yes"
        &displaystatementtype = 1
        &withcancelmessAge = "yes"
        &pagebottommargin = 6
        &withemail = "yes"
        &withwinprint = "yes"
        &definevariables = "yes"
    }

assign vqty1 = 1.
empty temp-table levx no-error.
empty temp-table tmpbom no-error.
run getPhList(input vpar,input-output vqty1).

/*计算准备时间*/
for each levx exclusive-lock:
    run getSet(input levx_part,output varset ).
    assign levx_set = varset.
end.

for each levx no-lock:
  assign vqty1 = 1.
  if not can-find (first psmstr no-lock
        where  psmstr.ps_domain = global_domain
          and  psmstr.ps_par = levx_part
          and (psmstr.ps_start <= today or psmstr.ps_start = ?)
          and (psmstr.ps_end >= today or psmstr.ps_end = ?))
  then do:
    find first tmpbom exclusive-lock
         where tbm_part = levx_part
           and tbm_comp = "" no-error.
    if not available tmpbom then do:
       create tmpbom.
       assign tbm_part = levx_part
              tbm_comp = ""
              tbm_pqty = levx_qty.
    end.
  end.
  else do:
    run getLeave(input levx_part,input levx_part,input-outpu vqty1).
  end.
  for each tmpbom exclusive-lock where tbm_part = levx_part:
      assign tbm_pqty = levx_qty.
  end.
end.

/*计算累计加工时间到tmprundet临时表*/
run gettmprundet(input vpar).
for each tmpbom exclusive-lock break by tbm_part by tbm_comp:
  assign varcst = 0.
  if first-of(tbm_part) then do:
     /*准备时间*/
     find first levx no-lock where levx_part = tbm_part no-error.
     if available levx then do:
        assign tbm_set = levx_set.
     end.
     /*加工时间累计*/
     find first tmprundet no-lock where trd_part = tbm_part no-error.
     if available tmprundet then do:
        assign tbm_run = trd_run.
     end.
  end.
  if tbm_comp = "" then do:
     run getprice(input tbm_part,output varcst).
  end.
  else do:
     run getprice(input tbm_comp,output varcst).
  end.
  assign tbm_cost = varcst.
end.

/*显示要查询物料的工时*/
run getSetTime(input vpar,output varset).
run getRunTime(input vpar,output varrun).
create tmpbom.
assign tbm_sn   = -1
       tbm_part = ""
       tbm_comp = ""
       tbm_pqty = 1
       tbm_cqty = 1
       tbm_set  = varset
       tbm_run  = varrun.
assign vscrppca = vscrppct * 0.01
       vwopca   = vwopct * 0.01.
for each tmpbom exclusive-lock:
/*as*/ /* assign tbm_mtl_cst = tbm_pqty * tbm_cqty * tbm_cost * vscrppct      */
/*as*/   if tbm_comp <> "" and tbm_cqty <> 0 then
/*as*/      assign
/*as*/      tbm_mtl_cst = (tbm_pqty * tbm_cqty * tbm_cost
/*as*/                  * vscrppca) / 1.17.
/*as*/   else
/*as*/      assign
/*as*/      tbm_mtl_cst = (tbm_pqty * tbm_cost * vscrppca) / 1.17.
/*as*/   assign
         tbm_lbr_cst = tbm_pqty * tbm_run * vscrppca
                     * vwopca * vlbrpct
         tbm_bdn_cst = tbm_pqty * tbm_run * vscrppca
                     * vwopca * vmfgpct.
  assign tbm_cst = tbm_mtl_cst + tbm_lbr_cst + tbm_bdn_cst.
  assign tbm_unit_cost = tbm_cst / tbm_pqty when tbm_pqty <> 0.
end.

{mfphead.i}
for each tmpbom no-lock break by vpar by tbm_part by tbm_sn
    with frame b width 360 no-attr-space:
    if first-of(tbm_part) then do:
       assign vptdesc= "".
       find first pt_mstr no-lock where pt_domain = global_domain
       and pt_part = tbm_part no-error.
       if avail pt_mstr then do:
          assign vptdesc = pt_desc1 + "/" + pt_desc2.
       end.
    end.
    assign vpsdesc= "".
    find first pt_mstr no-lock where pt_domain = global_domain
    and pt_part = tbm_comp no-error.
    if avail pt_mstr then do:
       assign vpsdesc = pt_desc1 + "/" + pt_desc2.
    end.
    display vpar           /*01产品*/
            tbm_part       /*02零件代码*/
            vptdesc        /*03说明*/
            tbm_pqty       /*04每件需求量*/
            tbm_comp       /*05耗用材料*/
            vpsdesc        /*06说明*/
            tbm_cqty       /*07耗用数量*/
            tbm_cost       /*08材料价格*/
            tbm_set        /*09准结工时*/
            tbm_run        /*10单件工时*/
            tbm_mtl_cst    /*11材料成本*/
            tbm_lbr_cst    /*12人工成本*/
            tbm_bdn_cst    /*13制造费用*/
            tbm_cst        /*14定额成本*/
            tbm_unit_cost. /*15单件成本*/
      ACCUM tbm_pqty(total)
            tbm_cqty(total)
            tbm_cost(total)
            tbm_set(total)
            tbm_run(total)
            tbm_mtl_cst(total)
            tbm_lbr_cst(total)
            tbm_bdn_cst(total)
            tbm_cst(total)
            tbm_unit_cost(total).
    if last-of(vpar) then do:
       down .
       display getTermLabelRt("TOTAL",10) @ tbm_part
               accum total(tbm_pqty)      @ tbm_pqty
               accum total(tbm_cqty)      @ tbm_cqty
               accum total(tbm_cost)      @ tbm_cost
               accum total(tbm_set)       @ tbm_set
               accum total(tbm_run)       @ tbm_run
               accum total(tbm_mtl_cst)   @ tbm_mtl_cst
               accum total(tbm_lbr_cst)   @ tbm_lbr_cst
               accum total(tbm_bdn_cst)   @ tbm_bdn_cst
               accum total(tbm_cst)       @ tbm_cst
               accum total(tbm_unit_cost) @ tbm_unit_cost.
    end.
    {mfrpchk.i}
    setframelabels(frame b:handle).
end.

{mfrtrail.i}
/*  {mfreset.i}   */
/*  {mfgrptrm.i}  */
end.

{wbrp04.i &frame-spec = a}

/*求第一层非虚零件的用量*/
procedure getPhList:
  define input parameter ipart like ps_par.
  define input-output parameter ioqty like ps_qty_per.
  define variable vqty like ps_qty_per.
  for each ps_mstr no-lock where ps_mstr.ps_domain = global_domain
       and ps_par = ipart
       and (ps_mstr.ps_start <= today or ps_mstr.ps_start = ?)
       and (ps_mstr.ps_end >= today or ps_mstr.ps_end = ?):

       assign vqty = ioqty * ps_mstr.ps_qty_per * (100 / (100 - ps_scrp_pct)).

       find first pt_mstr no-lock where pt_domain = global_domain
              and pt_part = ps_mstr.ps_comp no-error.
       if available pt_mstr then do:
         if pt_phantom then do:
            run getPhList(input ps_mstr.ps_comp,input-output vqty).
         end.
         else do:
            find first levx exclusive-lock where levx_part = ps_mstr.ps_comp
                 no-error.
            if available levx then do:
               assign levx_qty = levx_qty + vqty.
            end.
            else do:
               create levx.
               assign levx_part = ps_mstr.ps_comp
                      levx_qty  = vqty.
            end.
         end.
       end.
  end.
end procedure.

/*求第一层非虚零件的材料用量*/
procedure getLeave:
define input parameter iPart like pt_part.
define input parameter iroot like pt_part.
define input-output parameter ioqty like ps_mstr.ps_qty_per.

define variable vqty like ps_qty_per.

  for each ps_mstr no-lock where ps_mstr.ps_domain = global_domain
       and ps_par = ipart
       and (ps_mstr.ps_start <= today or ps_mstr.ps_start = ?)
       and (ps_mstr.ps_end >= today or ps_mstr.ps_end = ?):
       assign vqty = ioqty * ps_mstr.ps_qty_per * (100 / (100 - ps_scrp_pct)).
       if not can-find (first psmstr no-lock
          where  psmstr.ps_domain = global_domain
            and  psmstr.ps_par = ps_mstr.ps_comp
            and (psmstr.ps_start <= today or psmstr.ps_start = ?)
            and (psmstr.ps_end >= today or psmstr.ps_end = ?))
       then do:
            if ps_mstr.ps_comp = iroot then do:
                find first tmpbom exclusive-lock
                     where tbm_part = ps_mstr.ps_comp
                       and tbm_comp = "" no-error.
                if not available tmpbom then do:
                   create tmpbom.
                   assign tbm_part = ps_mstr.ps_comp
                          tbm_comp = "".
                end.
            end.
            else do:
                find first tmpbom exclusive-lock
                     where tbm_part = iroot
                       and tbm_comp = ps_mstr.ps_comp no-error.
                if not available tmpbom then do:
                   create tmpbom.
                   assign tbm_part = iroot
                          tbm_comp = ps_mstr.ps_comp
                          tbm_cqty = vqty.
                end.
                else do:
                    assign tbm_cqty = tbm_cqty + vqty.
                end.
            end.
       end.
       else do:
            run getLeave(input ps_mstr.ps_comp,input iroot,input-output vqty).
       end.
 end.
end procedure.

/*查找物料单价*/
procedure getPrice:
define input parameter iPart like pt_part.
define output parameter oprice like pt_price.

  find first pc_mstr no-lock where pc_domain = global_domain and
       pc_part = ipart and
      (pc_start <= today or pc_start = ?) and
      (pc_expir >= today or pc_expir = ?) no-error.
  if available pc_mstr then do:
      assign oprice = pc_amt[1].
  end.
  else do:
      find first pt_mstr where pt_domain = global_domain
             and pt_part = ipart no-error.
      if available pt_mstr then do:
         assign oprice = pt_price.
      end.
  end.
end procedure.

procedure getset:
  define input parameter iRouting like ro_routing.
  define output parameter oset    like ro_setup.

  define variable vset like ro_setup.
  define variable vrun like ro_run.
  define variable vset1 like ro_setup.
  define variable vrun1 like ro_run.

  run getSetTime(input iRouting,output vset1).
  empty temp-table tmprun no-error.
  run gettmpRun(input iRouting).
  for each tmprun no-lock:
      assign vset = vset + tmprun_set.
  end.
  assign oset = vset1 + vset.
end procedure.

procedure gettmpRun:
  define input parameter ipart like pt_part.

  define variable vpart like pt_part.
  define variable vset  like ro_setup.
  define variable vrun  like ro_run.
  for each ps_mstr no-lock where ps_mstr.ps_domain = global_domain
       and ps_par = ipart
       and (ps_start <= today or ps_start = ?)
       and (ps_end >= today or ps_end = ?):
       assign vrun = 0
              vset = 0.
       run getSetTime(input ps_mstr.ps_comp,output vset).
       create tmprun.
       assign tmprun_part = ps_mstr.ps_comp
              tmprun_set  = vset.
/*            tmprun_qty  = ps_mstr.ps_qty_per * (100 / (100 - ps_scrp_pct)) */
   run gettmpRun(input ps_mstr.ps_comp).
  end.
end procedure.

procedure getSetTime:
define input parameter iPart like ro_routing.
define output parameter oset like ro_setup.
define variable vset like ro_setup.

for each ro_det no-lock where ro_domain = global_domain
    and ro_routing = iPart
    and (ro_start <= today or ro_start = ?)
    and (ro_end >= today or ro_end = ?):
    assign vset = vset + ro_setup.
end.
assign oset = vset.
end procedure.

procedure getRunTime:
define input parameter iPart like ro_routing.
define output parameter orun like ro_run.

define variable vrun like ro_run.

for each ro_det no-lock where ro_domain = global_domain
    and ro_routing = iPart
    and (ro_start <= today or ro_start = ?)
    and (ro_end >= today or ro_end = ?):
    assign vrun = vrun + ro_run.
end.
assign orun = vrun.
end procedure.

/*计算每个料号的累计加工时间*/
procedure gettmprundet:
define input parameter iPart like pt_part.

define variable i as integer.
define variable vsett like ro_setup.
define variable vrunu like ro_run.
define variable vrund like ro_run.
define variable vrunt like ro_run.

empty temp-table tmpbomdet no-error.
empty temp-table tmprundet no-error.
run gettmpbomdet(ipart,1).
/*删除重复的料号以免重复计算*/
assign i = 0.
for each tmpbomdet exclusive-lock
    break by tbd_part by tbd_level descending:
    if tbd_level > i then assign i = tbd_leve.
    if not first-of(tbd_part) then do:
       delete tmpbomdet.
    end.
end.

/*自下往上滚动计算加工时间*/
do while i >= 1:
   for each tmpbomdet exclusive-lock where tbd_level = i:
      assign vrund = 0.
      for each ps_mstr no-lock where ps_mstr.ps_domain = global_domain
           and ps_mstr.ps_par = tbd_part
           and (ps_mstr.ps_start <= today or ps_mstr.ps_start= ?)
           and (ps_mstr.ps_end >= today or ps_mstr.ps_end = ?):
           find first tmprundet no-lock where trd_part = ps_comp no-error.
           if available tmprundet then do:
              assign vrunt = trd_run * ps_qty_per.
           end.
           assign vrund = vrund + vrunt.
      end.
      run getruntime(input tbd_part,output vrunu).
      create tmprundet.
      assign trd_part = tbd_part
             trd_run  = vrunu + vrund.
   end. /* for each tmpbomdet */
   assign i = i - 1.
end.  /*do while i >= 1:*/
end procedure.

procedure gettmpbomdet:
define input parameter ipart like ps_par.
define input parameter ilayer as integer.

define variable vset like ro_setup.
define variable vrun like ro_run.
for each ps_mstr no-lock where ps_mstr.ps_domain = global_domain
     and ps_mstr.ps_par = ipart
     and (ps_mstr.ps_start <= today or ps_mstr.ps_start = ?)
     and (ps_mstr.ps_end >= today or ps_mstr.ps_end = ?):
     /* run getRunTime(input ps_mstr.ps_comp,output vset,output vrun). */
     create tmpbomdet.
     assign tbd_part = ps_comp
            tbd_level = ilayer.
     run gettmpbomdet(input ps_mstr.ps_comp,input ilayer + 1).
end.
end procedure.
