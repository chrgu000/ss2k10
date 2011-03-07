/* xxbmpsrp10.p - bom runtime report                                          */
/* REVISION:101028.1 LAST MODIFIED: 10/28/10 BY: zy                           */
/* REVISION:110217.1 LAST MODIFIED: 02/17/11 BY: zy                       *2h**/
/*-Revision end---------------------------------------------------------------*/
/* Environment: Progress:10.1C04   QAD:eb21sp6                                */
/*V8:ConvertMode=NoConvert                                                    */
define buffer ptmstr for pt_mstr.

procedure getTmpbom:
    define input parameter ipart like pt_part.
    define variable vqty1 as decimal no-undo.
    define variable varset   like ro_setup no-undo.
    define variable varrun   like ro_run   no-undo.
    define variable varcst      as decimal format "->>>>>>9.9<<<<" no-undo.
    assign vqty1 = 1.
    empty temp-table levx no-error.
    empty temp-table tmpbom no-error.
    empty temp-table tempb no-error.
    run getPhList(input ipart,input-output vqty1).
    /*计算准备时间*/
    for each levx exclusive-lock:
        run getSet(input levx_part,output varset).
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
/*2h /**find iroot ro_det*/                                                  */
/*2h for each ro_det fields(ro_domain ro_routing ro_wkctr                    */
/*2h          ro_start ro_end ro_setup ro_run) no-lock                       */
/*2h    where ro_domain = global_domain and ro_routing = iPart               */
/*2h      and (ro_start <= today or ro_start = ?)                            */
/*2h      and (ro_end >= today or ro_end = ?):                               */
/*2h    find first tempb exclusive-lock where tmpb_par = iPart               */
/*2h           and tmpb_comp = iPart                                         */
/*2h           and tmpb_wc = ro_wkctr no-error.                              */
/*2h    if available tempb then do:                                          */
/*2h       assign tmpb_set = tmpb_set + ro_setup                             */
/*2h              tmpb_run = tmpb_run + ro_run.                              */
/*2h    end.                                                                 */
/*2h    else do:                                                             */
/*2h       create tempb.                                                     */
/*2h       assign tmpb_par = iPart                                           */
/*2h              tmpb_comp = iPart                                          */
/*2h              tmpb_wc = ro_wkctr                                         */
/*2h              tmpb_set = ro_setup                                        */
/*2h              tmpb_run = ro_run.                                         */
/*2h    end.                                                                 */
/*2h end.                                                                    */
    /*计算累计加工时间到tmprundet临时表*/
    run gettmprundet(input ipart).
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
    run getSetTime(input ipart,output varset).
    run getRunTime(input ipart,input ipart,input 0,output varrun).
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
     if tbm_comp <> "" and tbm_cqty <> 0 then
        assign
           tbm_mtl_cst = (tbm_pqty * tbm_cqty * tbm_cost * vscrppca) / 1.17.
     else
        assign tbm_mtl_cst = (tbm_pqty * tbm_cost * vscrppca) / 1.17.
     assign
        tbm_lbr_cst = tbm_pqty * tbm_run * vscrppca * vwopca * vlbrpct
        tbm_bdn_cst = tbm_pqty * tbm_run * vscrppca * vwopca * vmfgpct
        tbm_cst = tbm_mtl_cst + tbm_lbr_cst + tbm_bdn_cst
        tbm_unit_cost = tbm_cst / tbm_pqty when tbm_pqty <> 0.
    end.
end procedure.

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
       find first ptmstr no-lock where ptmstr.pt_domain = global_domain
              and ptmstr.pt_part = ps_mstr.ps_comp no-error.
       if available ptmstr then do:
         if ptmstr.pt_phantom then do:
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
/*2h*/ /**第一层非虚零件工艺流程*/
/*2h*/ for each ro_det fields(ro_domain ro_routing ro_wkctr
/*2h*/          ro_start ro_end ro_setup ro_run) no-lock
/*2h*/    where ro_domain = global_domain and ro_routing = ipart
/*2h*/      and (ro_start <= today or ro_start = ?)
/*2h*/      and (ro_end >= today or ro_end = ?):
/*2h*/    find first tempb exclusive-lock where tmpb_par = iroot
/*2h*/           and tmpb_comp = iPart
/*2h*/           and tmpb_wc = ro_wkctr no-error.
/*2h*/    if available tempb then do:
/*2h*/       assign tmpb_set = tmpb_set + ro_setup
/*2h*/              tmpb_run = tmpb_run + ro_run * ioqty.
/*2h*/    end.
/*2h*/    else do:
/*2h*/       create tempb.
/*2h*/       assign tmpb_par = iroot
/*2h*/              tmpb_comp = iPart
/*2h*/              tmpb_wc = ro_wkctr
/*2h*/              tmpb_set = ro_setup
/*2h*/              tmpb_run = ro_run * ioqty.
/*2h*/    end.
/*2h*/ end.
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
      find first ptmstr where ptmstr.pt_domain = global_domain
             and ptmstr.pt_part = ipart no-error.
      if available ptmstr then do:
         assign oprice = ptmstr.pt_price.
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
define input parameter iroot like ro_routing.
define input parameter irun  like ro_run.
define output parameter orun like ro_run.
define variable vrun like ro_run.
for each ro_det no-lock where ro_domain = global_domain
    and ro_routing = iPart
    and (ro_start <= today or ro_start = ?)
    and (ro_end >= today or ro_end = ?):
    assign vrun = vrun + ro_run.
/*2h*/    find first tempb exclusive-lock where tmpb_par = iroot
/*2h*/           and tmpb_comp = ipart
/*2h*/           and tmpb_wc = ro_wkctr no-error.
/*2h*/    if not available tempb then do:
/*2h*/       create tempb.
/*2h*/       assign tmpb_par = iroot
/*2h*/              tmpb_comp = ro_routing
/*2h*/              tmpb_wc = ro_wkctr
/*2h*/              tmpb_set = ro_setup
/*2h*/              tmpb_run = irun + ro_run.  /* vrunu + vrund. */
/*2h*/    end.
          else do:
               assign tmpb_set = tmpb_set + ro_setup
                      tmpb_run = tmpb_run + irun + ro_run.
          end.
end.
assign orun = vrun.
end procedure.

/*计算每个料号的累计加工时间*/
procedure gettmprundet:
define input parameter iPart like pt_part.
define variable i as integer.
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
              assign vrunt = ps_qty_per * (100 / (100 - ps_scrp_pct)) * trd_run.
/*              assign vrunt = ps_qty_per * trd_run.                          */
           end.
           assign vrund = vrund + vrunt.
      end.
      run getruntime(input tbd_part,input ipart,input vrund,output vrunu).
/*2h for each ro_det fields(ro_domain ro_routing ro_wkctr                    */
/*2h          ro_start ro_end ro_setup ro_run) no-lock                       */
/*2h    where ro_domain = global_domain and ro_routing = tbd_part            */
/*2h      and (ro_start <= today or ro_start = ?)                            */
/*2h      and (ro_end >= today or ro_end = ?):                               */
/*2h    find first tempb exclusive-lock where tmpb_par = ipart               */
/*2h           and tmpb_comp = ro_routing                                    */
/*2h           and tmpb_wc = ro_wkctr no-error.                              */
/*2h    if available tempb then do:                                          */
/*2h       assign tmpb_set = tmpb_set + ro_setup                             */
/*2h              tmpb_run = tmpb_run + ro_run.                              */
/*2h    end.                                                                 */
/*2h    else do:                                                             */
/*2h       create tempb.                                                     */
/*2h       assign tmpb_par = ipart                                           */
/*2h              tmpb_comp = ro_routing                                     */
/*2h              tmpb_wc = ro_wkctr                                         */
/*2h              tmpb_set = ro_setup                                        */
/*2h              tmpb_run = tmpb_run + ro_run.  /* vrunu + vrund. */        */
/*2h    end.                                                                 */
/*2h end.                                                                    */
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
     create tmpbomdet.
     assign tbd_part = ps_comp
            tbd_level = ilayer.
     run gettmpbomdet(input ps_mstr.ps_comp,input ilayer + 1).
end.
end procedure.

/*2h*此过程用于将工作中心排序*/
/*2h*/ procedure setTmpbSort:
/*2h*/     define variable i as integer.
/*2h*/     assign i = 0.
/*2h*/     for each tempb exclusive-lock where tmpb_set = 0 and tmpb_run = 0:
/*2h*/         delete tempb.
/*2h*/     end.
/*2h*/     assign wcid = "".
/*2h*/     for each code_mstr no-lock where code_domain = global_domain
/*2h*/          and code_fldname = 'xxbmpsrp10-wkctr' by code_user1:
/*2h*/         if can-find (first tempb where code_value = tmpb_wc ) then do:
/*2h*/            assign i = i + 1.
/*2h*/            for each tempb exclusive-lock where tmpb_wc = code_value:
/*2h*/                assign tmpb_sort = i
/*2h*/                       wcid[i] = tmpb_wc.
/*2h*/            end.
/*2h*/         end.
/*2h*/     end.
/*2h*/ end procedure.

/*2h*此过程用于转置后输出*/
/*2h*/ procedure tmpb2tmpbom:
/*2h*/     define input parameter iroot like pt_part.
/*2h*/     define variable vset like ro_setup.
/*2h*/     define variable vrun like ro_run.
/*2h*/     define variable i    as   integer.
/*2h*/ run setTmpbSort.
/*2h*/ for each tmpbom exclusive-lock break by tbm_part:
/*2h*/    if first-of(tbm_part) then do:
              assign vset = 0 vrun = 0.
/*2h*/        for each tempb no-lock where (tmpb_par = tbm_part) or
/*2h*/           (tmpb_par = tmpb_comp and iroot = tmpb_par and tbm_par = "")
/*2h*/            break by tmpb_sort:
/*2h*/           if first-of(tmpb_sort) then do:
/*2h*/              assign vset = 0
/*2h*/                     vrun = 0.
/*2h*/           end.
/*2h*/           assign vset = vset + tmpb_set
/*2h*/                  vrun = vrun + tmpb_run.
/*2h*/           if last-of(tmpb_sort) and tmpb_sort <> 0  then do:
/*2h*/                 assign tbm_wcset[tmpb_sort] = vset
/*2h*/                        tbm_wcrun[tmpb_sort] = vrun.
/*2h*/           end.
/*2h*/           accum tmpb_set(total)
/*2h*/                 tmpb_run(total).
/*2h*/        end.
/*2h*/ /**第一层非虚零件无子件工时状况*/
/*2h*/      assign vset = accum total tmpb_set
/*2h*/             vrun = accum total tmpb_run.
/*2h*/      if vset <> tbm_set or vrun <> tbm_run then do:
/*2h*/         for each tempb exclusive-lock use-index tmpb_comp_par where
/*2h*/                  tmpb_comp = tbm_part and tmpb_par <> tbm_comp
/*2h*/             break by tmpb_sort:
/*2h*/             do i = 1 to 15:
/*2h*/                if wcid[i] = tmpb_wc then assign tmpb_sort = i.
/*2h*/             end.
/*2h*/         end.
/*2h*/         for each tempb no-lock use-index tmpb_comp_par where
/*2h*/                  tmpb_comp = tbm_part and tmpb_par <> tbm_comp
/*2h*/             break by tmpb_sort:
/*2h*/             if first-of(tmpb_sort) then do:
/*2h*/                 assign vset = 0
/*2h*/                        vrun = 0.
/*2h*/             end.
/*2h*/             assign vset = vset + tmpb_set
/*2h*/                    vrun = vrun + tmpb_run.
/*2h*/              if last-of(tmpb_sort) and tmpb_sort <> 0  then do:
/*2h*/                    assign tbm_wcset[tmpb_sort] = vset
/*2h*/                           tbm_wcrun[tmpb_sort] = vrun.
/*2h*/              end.
/*2h*/         end.
/*2h*/      end.
/*2h*/      assign vrun = 0 vset = 0.
/*2h*/      do i = 1 to 15:
/*2h*/         assign vset = vset + tbm_wcset[i]
/*2h*/                vrun = vrun + tbm_wcrun[i].
/*2h*/      end.
/*2h*/      assign tbm_setdif = tbm_set - vset
/*2h*/             tbm_rundif = tbm_run - vrun.
/*2h*/    end. /* if first-of(tbm_part) then do: */
/*2h*/ end.    /* for each tmpbom exclusive-lock */
/*2h*/ end procedure.
