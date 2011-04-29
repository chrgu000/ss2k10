/* xxqmcplmt.p  海关进/出口清单的产生                                       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 01/28/2008   BY: Softspeed tommy xie         */


{mfdtitle.i "1.0"}

define variable site like si_site label "地点".
define variable par as char format "x(18)" label "出口零件".
define variable par1 as char format "x(18)".
define variable nbr like so_nbr label "客户订单号".
define variable nbr1 like so_nbr label "至".
define variable exp_nbr like xxcpl_list_nbr label "出口计划单号".
define variable exp_nbr1 like xxcpl_list_nbr label "至".
define variable start_dt as date label "出口日期" /*"订单/预测/出口日期"*/.
define variable end_dt as date label "至".
define variable list_nbr as char format "x(12)" label "计划清单号" no-undo.
define variable sel_opt as char format "x(1)" label "产生方式" initial "1".
define variable updt_all like mfc_logical label "更新".

define variable cu_part like xxcpt_cu_part.
define variable cu_um   like xxcpt_um.
define variable cu_desc like xxcpt_desc.
define variable cust_part like xxcpt_cu_part.
define variable cust_desc like xxcpt_desc.
define variable cu_comp like xxcps_cu_comp.
define variable cu_ln like xxcpt_ln.
define variable cu_conv like xxccpt_um_conv.
define variable comp_desc like xxcpt_desc.
define variable cu_qty_per like xxcps_cu_qty_per.

define var v_qty_cu like xxcpl_cu_qty .
define var v_qty    like xxcpl_cu_qty.

define temp-table temp1
    field t1_cu_ln       like xxcpt_ln
    field t1_cu_comp     like xxcpt_cu_part
    field t1_cu_desc1    like pt_desc1
    field t1_cu_qty      like xxcpl_cu_qty
    field t1_qty         like xxcpl_qty
    field t1_cu_um       like xxcpt_um
    field t1_conv        like xxccpt_um_conv
    field t1_par_ln      like xxcpt_ln label "父零件"
    field t1_par         like ps_par label "父零件"  
    field t1_comp        like ps_comp label "子零件"
    field t1_cdesc1      as char format "x(24)" label "说明1"
    field t1_um          like pt_um
    field t1_qty_per     like ps_qty_per
    field t1_qty_per_cu     like ps_qty_per
    field t1_type        as char.

define temp-table temp2
    field t2_nbr      like xxepld_nbr
    field t2_cu_ln       like xxcpt_ln
    field t2_cu_part  like xxcpl_cu_part
    field t2_cu_desc1 like pt_desc1
    field t2_cu_qty   like xxcpl_cu_qty
    field t2_cu_um    like xxcpl_cu_um
    field t2_par      like xxcpl_par
    field t2_desc1    like pt_desc1
    field t2_desc2    like pt_desc2
    field t2_um       like xxcpl_um
    field t2_qty      like xxcpl_qty
    field t2_exp_date like xxcpl_exp_date
    field t2_conv     like xxccpt_um_conv
    field t2_type     as char.

find first icc_ctrl where icc_domain = global_domain no-lock no-error.
site = (if available icc_ctrl then icc_site else global_domain).

list_nbr = substring(string(year(today)),3,2) + string(month(today), "99") + string(day(today), "99").

form
    list_nbr               colon 25
    skip(1)
    site                   colon 25
    exp_nbr                colon 25 
    exp_nbr1    label "至" colon 49    
    par                    colon 25 
    par1        label "至" colon 49

    start_dt               colon 25
    end_dt      label "至" colon 49

    /*nbr       colon 25 
    nbr1        label "至" colon 49
    sel_opt   colon 25 space(0) "1-按海关计划, 2-客户订单, 3-预测"*/ 
    skip(1)
    updt_all  colon 25
    skip(1)
with frame a side-labels attr-space width 80.

{wbrp01.i}
repeat:
    hide all no-pause . {xxtop.i}
    view frame  a  .
            if par1 = hi_char then par1 = "".
            if nbr1 = hi_char then nbr1 = "".
            if exp_nbr1 = hi_char then exp_nbr1 = "".
            if start_dt = low_date then start_dt = ?.
            if end_dt = hi_date then end_dt = ?.

            display list_nbr with frame a.

            if c-application-mode <> 'web' then
               update list_nbr site exp_nbr exp_nbr1 par par1 
                      start_dt end_dt updt_all with frame a.
            
            {wbrp06.i &command = update 
                      &fields = " list_nbr site exp_nbr exp_nbr1 par par1 start_dt end_dt updt_all"
                      &frm = "a"}

            if (c-application-mode <> 'web') or
               (c-application-mode = 'web' and
               (c-web-request begins 'data')) then do:

               if list_nbr = "" then do:
                  message "清单号不可为空，请重新输入！"  view-as alert-box.
                  list_nbr = substring(string(year(today)),3,2) + string(month(today), "99") + string(day(today), "99").
                  next-prompt list_nbr with frame a.
                  undo, retry.                  
               end.

                if not can-find(si_mstr  where si_mstr.si_domain = global_domain and si_site = site)
                then do:        
                    {mfmsg.i 708 3} /* SITE DOES NOT EXIST */
                    next-prompt site.
                    undo, retry.
                end.

              find first xxcpl_mstr where xxcpl_domain = global_domain and xxcpl_list_nbr = list_nbr and xxcpl_stat <> "" no-lock no-error .
              if avail xxcpl_mstr then do:
                  message "清单" list_nbr "已产生海关手册,不可再更新." view-as alert-box.
                  list_nbr = substring(string(year(today)),3,2) + string(month(today), "99") + string(day(today), "99").
                  next-prompt list_nbr with frame a.
                  undo, retry.   
              end.
               
               /*if lookup(sel_opt,"1,2,3") = 0 then do:
                  message "错误：选择 1-按海关计划, 2-客户订单，请重新输入！"  view-as alert-box.
                  next-prompt sel_opt with frame a.
                  undo, retry.                  
               end.*/

               bcdparm = "".
               {mfquoter.i list_nbr    }
               {mfquoter.i site    }
               {mfquoter.i par     }
               {mfquoter.i par1    }
               {mfquoter.i nbr     }
               {mfquoter.i nbr1    }
               {mfquoter.i exp_nbr }
               {mfquoter.i exp_nbr1}
               {mfquoter.i start_dt}
               {mfquoter.i end_dt  }
               {mfquoter.i updt_all}

               if par1 = "" then par1 = hi_char.
               if nbr1 = "" then nbr1 = hi_char.
               if exp_nbr1 = "" then exp_nbr1 = hi_char.
               if start_dt = ? then start_dt = low_date.
               if end_dt = ? then end_dt = hi_date.
               if list_nbr = "" then list_nbr = substring(string(year(today)),3,2) + string(month(today), "99") + string(day(today), "99").
            end.  /* if c-application-mode <> 'web' */

            {gpselout.i &printType = "printer"
                        &printWidth = 132
                        &pagedFlag = " "
                        &stream = " "
                        &appendToFile = " "
                        &streamedOutputToTerminal = " "
                        &withBatchOption = "yes"
                        &displayStatementType = 1
                        &withCancelMessage = "yes"
                        &pageBottomMargin = 6
                        &withEmail = "yes"
                        &withWinprint = "yes"
                        &defineVariables = "yes"}
            
            {mfphead.i}
put  skip(1) skip "进出口计划清单号:" list_nbr  .
if not updt_all then put ",本次将新增如下数量: " skip.
else                 put ",本次已新增如下数量: " skip.
put "================================================" skip. 


for each temp1: delete temp1. end.
for each temp2: delete temp2. end.

if sel_opt = "1" then do:

   for each xxepld_det no-lock 
      where xxepld_domain = global_domain
        and xxepld_part >= par and xxepld_part <= par1
        and xxepld_nbr >= exp_nbr and xxepld_nbr <= exp_nbr1
        and xxepld_edate >= start_dt and xxepld_edate <= end_dt
        and (can-find(first ptp_det where ptp_domain = global_domain
                        and ptp_part = xxepld_part and ptp_site = site) or
                      (not can-find(first ptp_det where ptp_domain = global_domain
                                      and ptp_part = xxepld_part and ptp_site = site) 
                       and can-find(first pt_mstr where pt_domain = global_domain 
                                      and pt_part = xxepld_part and pt_site = site) ) )
   break by xxepld_nbr by xxepld_part:
      if last-of(xxepld_part) then do:

         find first pt_mstr where pt_domain = global_domain
                and pt_part = xxepld_part no-lock no-error.
         if available pt_mstr then do:

            cu_part = "N/A".
            cu_um   = "/".                   
            cu_conv = 0.
            cu_ln = 0 .

            find first xxccpt_mstr where xxccpt_domain = global_domain
                   and xxccpt_part = xxepld_part no-lock no-error. 
            if available xxccpt_mstr then do:
               find first xxcpt_mstr where xxcpt_domain = global_domain
                      and xxcpt_ln = xxccpt_ln no-lock no-error.

               if available xxcpt_mstr then do:
                  cu_part = xxcpt_cu_part.
                  cu_ln   = xxcpt_ln .
                  cu_um   = xxcpt_um.    
                  cu_desc = xxcpt_desc .
               end.
               /*cu_conv = xxccpt_um_conv.*/
            end.

            create temp2.
            assign
               t2_nbr      = xxepld_nbr
               t2_cu_ln    = cu_ln 
               t2_cu_part  = cu_part
               t2_cu_desc1 = cu_desc   
               t2_cu_um    = cu_um
               t2_cu_qty   = xxepld_cu_qty
               t2_qty      = xxepld_qty
               t2_exp_date = xxepld_edate
               t2_type     = "PLAN"
               /*
               t2_par      = xxepld_part
               t2_desc1    = pt_desc1
               t2_desc2    = pt_desc2               
               t2_um       = pt_um   
               t2_conv     = cu_conv
               */
               .

         end. /* if available pt_mstr */
      end.  /* if last-of(xxepld_part) */
   end.  /* for each xxepld_det */
end.  /* sel_opt = "1" */

if sel_opt = "2" then do:
   for each sod_det no-lock 
      where sod_domain = global_domain
        and sod_part >= par and sod_part <= par1
        and sod_nbr >= exp_nbr and sod_nbr <= exp_nbr1
        and sod_due_date >= start_dt and sod_due_date <= end_dt
   break by sod_nbr by sod_part:
      if last-of(sod_part) then do:

         find first pt_mstr where pt_domain = global_domain
                and pt_part = sod_part no-lock no-error.
         if available pt_mstr then do:


            cu_part = "N/A".
            cu_um   = "/".                   
            cu_conv = 0.
            cu_ln = 0 .

            find first xxccpt_mstr where xxccpt_domain = global_domain
                   and xxccpt_part = sod_part no-lock no-error. 
            if available xxccpt_mstr then do:
               find first xxcpt_mstr where xxcpt_domain = global_domain
                      and xxcpt_ln = xxccpt_ln no-lock no-error.
               if available xxcpt_mstr then do:
                  cu_part = xxcpt_cu_part.
                  cu_ln   = xxcpt_ln .
                  cu_um   = xxcpt_um.  
                  cu_desc = xxcpt_desc .
               end.
               /*cu_conv = xxccpt_um_conv.*/
            end.

            create temp2.
            assign
               t2_nbr      = sod_nbr
               t2_cu_ln    = cu_ln 
               t2_cu_part  = cu_part
               t2_cu_desc1 = cu_desc 
               t2_cu_um    = cu_um
               t2_cu_qty   = sod_qty_ord * cu_conv
               t2_qty      = sod_qty_ord
               t2_exp_date = sod_due_date
               t2_type     = "so"
               /*
               t2_par      = sod_part
               t2_desc1    = pt_Desc1
               t2_desc2    = pt_desc2               
               t2_um       = pt_um
               t2_conv     = cu_conv            
               */      
               .

         end. /* if available pt_mstr */
      end.  /* if last-of(sod_part) */
   end.  /* for each sod_det */            
end.  /* sel_opt = "2" */

/*找海关BOM主模版零件做公司零件*/
for each temp2:
    find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_ln = t2_cu_ln and xxccpt_key_bom = yes no-lock no-error .
    if avail xxccpt_mstr then do:
        find first pt_mstr where pt_domain = global_domain and pt_part = xxccpt_part no-lock no-error .
        if avail pt_mstr then do:
            assign 
               t2_par      = pt_part
               t2_desc1    = pt_Desc1
               t2_desc2    = pt_desc2               
               t2_um       = pt_um
               t2_conv     = xxccpt_um_conv 
               .
        end.
    end.
end.


for each temp2 break by t2_cu_ln :
    if first-of(t2_cu_ln) then do:
        v_qty_cu = 0 .
        v_qty    = 0 .
    end.

    v_qty_cu = v_qty_cu + t2_cu_qty .
    v_qty    = v_qty    + t2_qty .

    if last-of(t2_cu_ln) then do:
        find first xxcps_mstr where xxcps_domain = global_domain and xxcps_par_ln = t2_cu_ln no-lock no-error .
        if not avail xxcps_mstr then next.

        for each xxcps_mstr where xxcps_domain = global_domain and xxcps_par_ln = t2_cu_ln no-lock :
        
            find first temp1 where t1_par_ln = xxcps_par_ln and t1_cu_ln = xxcps_comp_ln no-error .
            if not avail temp1 then do:
                cu_comp = "N/A".   
                comp_desc = "N/A".
                cu_um = "/".
                cu_conv = 0 .
                cu_ln = 0 .

                find first xxccpt_mstr 
                    where xxccpt_domain = global_domain
                    and xxccpt_part = xxcps_comp 
                no-lock no-error.
                if available xxccpt_mstr then do:
                    find first xxcpt_mstr 
                        where xxcpt_domain = global_domain
                        and xxcpt_ln = xxccpt_ln 
                    no-lock no-error.
                    if available xxcpt_mstr then do:
                        cu_comp  = xxcpt_cu_part. 
                        cu_ln    = xxcpt_ln .
                        comp_desc = xxcpt_desc .
                    end.
                    cu_conv = xxccpt_um_conv.
                end.

                find first pt_mstr where pt_domain = global_domain and pt_part = xxcps_comp no-lock no-error .

                create temp1 .
                assign  t1_par  = xxcps_par
                        t1_par_ln = xxcps_par_ln
                        t1_comp = xxcps_comp
                        t1_cdesc1   = pt_desc1
                        t1_um       = pt_um 
                        t1_cu_comp  = cu_comp
                        t1_cu_ln    = cu_ln 
                        t1_cu_desc1 = comp_desc
                        t1_cu_um   = xxcps_cu_um
                        t1_conv    = cu_conv 
                        t1_qty_per_cu = xxcps_cu_qty_per
                        t1_qty_per = xxcps_qty_per
                        t1_cu_qty  = xxcps_cu_qty_per * v_qty_cu
                        t1_qty  = xxcps_qty_per * v_qty_cu .                 


            end.
            else do:
                t1_qty_per_cu = xxcps_cu_qty_per + t1_qty_per_cu.
                t1_qty_per = xxcps_qty_per + t1_qty_per.
                t1_cu_qty  = xxcps_cu_qty_per * v_qty_cu + t1_cu_qty .
                t1_qty  = xxcps_qty_per * v_qty_cu + t1_qty. 
            end.
        end. /*for each xxcps_mstr */
    end. /*if last-of(t2_cu_ln)*/
end. /*for each temp2 */






/*父商品*/
form
   t2_cu_ln       label "公司序"
   t2_cu_part     label "父商品"
   t2_cu_desc1    label "品名"
   t2_par         label "零件号"
   t2_desc1       label "说明1"
   t2_cu_qty      label "海关数量"
   t2_cu_um       label "单位"
   t2_nbr         column-label "出口计划号/!客户订单号"
   t2_exp_date    label "出口日期" 
   t2_conv        label "转换因子"   
   t2_qty         label "数量"
   t2_um          label "单位"
   
with down frame b width 320.

/*子商品*/
form    
   t1_cu_ln    label "公司序"
   t1_cu_comp  label "子商品"
   t1_cu_desc1 label "品名"
   t1_comp     label "子零件"
   t1_cdesc1   label "说明1" 
   t1_cu_qty   label "数量"
   t1_cu_um    label "单位" 
with down frame c width 320.


for each temp2 no-lock 
    break by t2_cu_part by t2_cu_ln :  

    if first-of(t2_cu_ln) then do:
        v_qty_cu = 0 .
        v_qty    = 0 .
    end.

    v_qty_cu = v_qty_cu + t2_cu_qty .
    v_qty    = v_qty    + t2_qty .

   display
       t2_cu_ln       label "公司序"
       t2_cu_part     label "父商品"
       t2_cu_desc1    label "品名"
       t2_par         label "零件号"
       t2_desc1       label "说明1"
       t2_cu_qty      label "数量"
       t2_cu_um       label "单位"
       t2_nbr         column-label "出口计划号/!客户订单号"
       t2_exp_date    label "出口日期" 
       t2_conv        label "转换因子"   
       t2_qty         label "数量"
       t2_um          label "单位"
   with down frame b width 320.
   down 1 with frame b.

   if last-of(t2_cu_ln) then do:
       for each temp1 no-lock where t1_par_ln = t2_cu_ln
       break by t1_par_ln by t1_cu_ln :

          display
             t1_cu_ln    label "公司序"
             t1_cu_comp  label "子商品"
             t1_cu_desc1 label "品名"
             t1_cu_qty   label "数量"
             t1_cu_um    label "单位"
             t1_comp     label "子零件"
             t1_cdesc1   label "说明1"
          with down frame c width 320.
          down 1 with frame c.
       end.  


       if updt_all then do:
              /*
              for each xxcpl_mstr where xxcpl_domain = global_domain and xxcpl_list_nbr = list_nbr and xxcpl_stat = "":
                    delete xxcpl_mstr .
              end.
              for each xxcpld_det where xxcpld_domain = global_domain and xxcpld_list_nbr = list_nbr  and xxcpld_stat = "" :
                    delete xxcpld_det .
              end.
              */
            
              if t2_cu_part = "N/A" then
                 message "错误：父商品没有输入， 请输入后更新!".
              
              if t2_cu_desc1 = "N/A" then
                 message  "错误：父商品品名没有输入， 请输入后更新!".

              if t2_cu_part <> "N/A" and t2_cu_desc1 <> "N/A"
              then do:
                 find first xxcpl_mstr where xxcpl_domain = global_domain
                        and xxcpl_list_nbr = list_nbr
                        and xxcpl_cu_ln  = t2_cu_ln  no-error.

                 if not available xxcpl_mstr then do:
                    create xxcpl_mstr.
                    assign
                       xxcpl_domain   = global_domain
                       xxcpl_list_nbr = list_nbr
                       xxcpl_cu_ln    = t2_cu_ln
                       xxcpl_cu_part  = t2_cu_part
                       xxcpl_par      = t2_par
                       xxcpl_cu_qty   = v_qty_cu
                       xxcpl_qty      = v_qty
                       xxcpl_cu_um    = t2_cu_um
                       xxcpl_um       = t2_um
                       xxcpl_stat     = ""
                       xxcpl_userid   = global_userid
                       xxcpl_cr_date  = today  
                       xxcpl_exp_date = t2_exp_date
                       xxcpl_type     = t2_type 
                       .
                 end.
                 else do:
                    xxcpl_cu_qty   = v_qty_cu +  xxcpl_cu_qty .
                    xxcpl_qty      = v_qty +  xxcpl_qty .
                 end.

                for each temp1 no-lock where t1_par_ln = t2_cu_ln
                    break by t1_par_ln by t1_cu_ln:

                    if t1_cu_comp = "N/A" then
                    message "错误：子商品没有输入， 请输入后更新!".

                    if t1_cu_desc1 = "N/A" then
                    message  "错误：子商品品名没有输入， 请输入后更新!".

                    find first xxcpld_det where xxcpld_domain   = global_domain 
                           and xxcpld_list_nbr = list_nbr
                           and xxcpld_cu_ln   = t1_cu_ln no-error.

                    if not available xxcpld_det then do:
                            create xxcpld_det.
                            assign
                                    xxcpld_domain   = global_domain
                                    xxcpld_list_nbr = list_nbr
                                    xxcpld_cu_ln    = t1_cu_ln 
                                    xxcpld_cu_comp  = t1_cu_comp
                                    xxcpld_cu_um    = t1_cu_um
                                    xxcpld_comp     = t1_comp
                                    xxcpld_um       = t1_um
                                    xxcpld_cu_qty   =  t1_cu_qty
                                    xxcpld_qty      =  t1_qty 
                                    xxcpl_type      = t2_type  
                                    .
                    end.
                    else do:
                        xxcpld_cu_qty   = xxcpld_cu_qty +  t1_cu_qty.   
                        xxcpld_qty      = xxcpld_qty +  t1_qty.  
                    end.
                end. /*for each temp1 */

              end. /*if t2_cu_part <> "N/A" and t2_cu_desc1 <> "N/A"*/
       
       end. /*if updt_all then*/
   end. /*if last-of(t2_cu_ln)*/
end. /*for each temp2 */

{mfreset.i}
end. /*repeat:*/

         
         
         
         
         
         
         
         
