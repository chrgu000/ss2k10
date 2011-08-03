/* xxrepkupu0.p - REPETITIVE PICKLIST CALCULATION                            */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 0CYH LAST MODIFIED: 05/30/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

{mfdeclre.i}

/* {xxtimestr.i}  */

define shared variable site   like si_site.
define shared variable site1  like si_site.
define shared variable wkctr  like op_wkctr.
define shared variable wkctr1 like op_wkctr.
define shared variable issue  like wo_rel_date.

define variable timedif as integer.
define variable rev  as character.
define variable vRate as decimal.     /*产能(个/每秒)                      */
define variable itceTime as integer.  /*时间用于记录计算时每个分界时间     */
define variable itceTimeS as integer. /*时间用于记录计算时每个分界时间开始 */
define variable itceTimeE as integer. /*时间用于记录计算时每个分界时间结束 */
define variable i as integer.
define variable rid as recid.
define variable vqty  as decimal.
define variable vqtya as decimal.
define variable vtype as character.
define variable v_number as character format "x(12)".
define variable errorst as logical.
define variable errornum as integer.
define shared variable nbrstart as   character format "x(10)".

    /* clear pk data */
    for each xxlw_mst exclusive-lock where xxlw_date = issue and
            (xxlw_site >= site) and (xxlw_site <= site1 or site1 = "") and
             xxlw_line >= wkctr and (xxlw_line <= wkctr1 or wkctr1 = ""):
             for each xxwa_det exclusive-lock where
                      xxwa_date = xxlw_date and
                      xxwa_site = xxlw_site and
                      xxwa_line = xxlw_line and
                      xxwa_par = xxlw_part:
                 delete xxwa_det.   /*明细表*/
             end.
        delete xxlw_mst.  /*主表*/
    end.

    /* 切割时间段 */
    for each rps_mstr no-lock use-index rps_site_line
       where rps_due_date = issue
         and rps_site >= site and (rps_site <= site1 or site1 = "")
         and rps_line >= wkctr and (rps_line <= wkctr1 or wkctr1 = "")
       break by rps_due_date by rps_site by rps_line by rps_user1:
        if first-of(rps_line) then do:
           find first xxlnw_det no-lock use-index xxlnw_siteline where
                      xxlnw_site = rps_site and xxlnw_line = rps_line and
                      xxlnw_on no-error.
           if available xxlnw_det then do:
              assign itcetimes = xxlnw_stime.
              assign recno = recid(xxlnw_det).
           end.
        end.
        /*每个物料产能 (个/秒) */
        find first lnd_det no-lock where lnd_site = rps_site and
                   lnd_line = rps_line and lnd_part = rps_part no-error.
        if available lnd_det then do:
           vrate = lnd_rate / 3600.
        end.
        itcetimee = itcetimes + rps_qty_req / vrate. /*做到什么时间完成*/

    calcloop1:
    repeat:
        find first xxlnw_det no-lock where recid(xxlnw_det) = recno no-error.
        if xxlnw_etime >= itcetimee then do:
           create xxlw_mst.
           assign xxlw_date = rps_due_date
                  xxlw_site = rps_site
                  xxlw_line = rps_line
                  xxlw_part = rps_part
                  xxlw_sn   = xxlnw_sn
                  xxlw_start = itcetimes
                  xxlw_end = itcetimee
                  xxlw_qty_src = rps_qty_req
                  xxlw__dec01 = rps_qty_req  /*调试程序使用,用完删除*/
                  xxlw__int01 = xxlnw_etime. /*调试程序使用,用完删除*/
           assign itcetimes = itcetimee.
           leave calcloop1.
        end.
        else do:
           create xxlw_mst.
           assign xxlw_date = rps_due_date
                  xxlw_site = rps_site
                  xxlw_line = rps_line
                  xxlw_part = rps_part
                  xxlw_sn   = xxlnw_sn
                  xxlw_start = itcetimes
                  xxlw_end = xxlnw_etime
                  xxlw_qty_src = rps_qty_req
                  xxlw__dec01 = rps_qty_req   /*调试程序使用,用完删除*/
                  xxlw__int01 = xxlnw_etime.  /*调试程序使用,用完删除*/
          assign timedif = xxlnw_etime
                 itcetimes = xxlnw_etime.
          find next xxlnw_det no-lock where xxlnw_site = rps_site and
                    xxlnw_line = rps_line and xxlnw_on no-error.
          IF AVAILABLE xxlnw_det THEN DO:
             assign recno = recid(xxlnw_det).
             assign timedif = xxlnw_stime - timedif.
             assign itcetimee = itcetimee + timedif
                    itcetimes = itcetimes + timedif.
          END.
        end.
      end.
        for each xxlw_mst exclusive-lock where xxlw_date = rps_due_date
             and xxlw_site = rps_site and xxlw_line = rps_line
             and xxlw_part = rps_part:
             assign xxlw_qty_req = ROUND(vrate * (xxlw_end - xxlw_start),0).
        end.
    end. /* for each rps_mstr no-lock user-index rps_site_line where */

      for each xxlw_mst no-lock where
           xxlw_date = issue and
           xxlw_site >= site and (xxlw_site <= site1 or site1 = "") and
           xxlw_line >= wkctr and (xxlw_line <= wkctr1 or wkctr1 = ""):
           for each xxwp_mst no-lock where
              xxwp_date = xxlw_date and xxwp_site = xxlw_site and
              xxwp_line = xxlw_line and xxwp_par = xxlw_part:
       create xxwa_det.
       assign xxwa_date = xxlw_date
              xxwa_site = xxlw_site
              xxwa_line = xxlw_line
              xxwa_par = xxwp_par
              xxwa_part = xxwp_part
              xxwa_sn = xxlw_sn
              xxwa_qty_req = xxwp_qty_req * (xxlw_qty_req / xxlw_qty_src)
              xxwa_qty_pln = xxwa_qty_req
              xxwa_rtime = xxlw_start.
            end.
      end.
 /*****
  for each xxlw_mst no-lock where
       xxlw_date = issue and
       xxlw_site >= site and (xxlw_site <= site1 or site1 = "") and
       xxlw_line >= wkctr and (xxlw_line <= wkctr1 or wkctr1 = "")
       BREAK BY xxlw_date BY xxlw_site BY xxlw_line BY xxlw_start:
       display xxlw_date
               xxlw_site
               xxlw_line
               xxlw_part
               xxlw_sn
               string(xxlw_start,"hh:mm:ss") column-label "xxlnw_start
               string(xxlw_end  ,"hh:mm:ss") column-label "xxlnw_end"
               xxlw_qty_req
               xxlw__dec01
               string(xxlw__int01,"hh:mm:ss") column-label "xxlw__int01"
                with width 300.
  end.
*****/
  /*计算取料,发料时间区间*/
  for each xxwa_det exclusive-lock where
           xxwa_date = issue and
           xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
           xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "")
  break by xxwa_date by xxwa_site by xxwa_line by xxwa_part by xxwa_sn:
        assign vtype = "*".
        if first-of(xxwa_part) then do:
           find first pt_mstr where pt_mstr.pt_part = xxwa_part
                no-lock no-error.
           if available pt_mstr then do:
              assign vtype = pt_mstr.pt__chr10.
           end.
        end.
        find last xxlnm_det where xxlnm_line = xxwa_line
               and xxlnm_site = xxwa_site
               and (xxlnm_type = vtype or xxlnm_type = "*")
               no-lock no-error.
        if not available xxlnm_det then do:
           find first xxlnm_det no-lock no-error.
        end.
        if available xxlnm_det then do:
           find first xxlnw_det where xxlnw_site = xxwa_site
                  and xxlnw_line = xxwa_line
                  and xxlnw_sn = xxwa_sn no-lock no-error.
           if available xxlnw_det then do:
           assign xxwa_pstime = xxlnw_stime - xxlnm_pkstart * 60
                  xxwa_petime = xxlnw_stime - xxlnm_pkend * 60
                  xxwa_sstime = xxlnw_stime - xxlnm_sdstart * 60
                  xxwa_setime = xxlnw_stime - xxlnm_sdend * 60.
           end.
        end.
        else do:
            assign xxwa_pstime = -1.
        end.
  end. /* for each xxwa_det exclusive-lock where  */

  /*计算单号,序号*/
  for each xxwa_det exclusive-lock where
           xxwa_date = issue and
           xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
           xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "")
  break by xxwa_date by xxwa_site by xxwa_line by xxwa_sn by xxwa_part:
      if first-of(xxwa_sn) then do:
        assign v_number = "".
        {gprun.i ""gpnrmgv.p"" "(""xxwa_det"",input-output v_number
                                 ,output errorst,output errornum)" }
        i = 1.
      end.
      assign xxwa_nbr = v_number
             xxwa_recid = i.
      i = i + 1.
  end.
  /*
   for each xxwa_det no-lock where xxwa_date = issue and
           xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
           xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "")
      break by xxwa_nbr:
      if first-of(xxwa_nbr) then do:
         for each xxwd_det exclusive-lock where xxwd_nbr = xxwa_nbr:
             delete xxwd_det.
         end.
      end.
  end.
  */

/*C类物料以最小包装量发放*/
    for each xxwa_det exclusive-lock where
             xxwa_date = issue and
             xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
             xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = ""),
        each pt_mstr no-lock where pt_mstr.pt_part = xxwa_part and
             pt_mstr.pt__chr10 = "C"
    break by xxwa_date by xxwa_site by xxwa_line by xxwa_part by xxwa_sn:
       if first-of(xxwa_part) then do:
          assign vqty = xxwa_qty_pln.
       end.
       else do:
          assign vqty = xxwa_qty_pln - vqty.
       end.
       if pt_ord_min <> 0 then do:
         assign xxwa_qty_pln = round(vqty / pt_ord_min,0) * pt_ord_min.
       end.
       assign vqty = round(vqty / pt_ord_min,0) * pt_ord_min - vqty.
    end.

  for each xxwd_det exclusive-lock:
    delete xxwd_det.
  end.

  /*计算发料库位及数量*/
  for each xxwa_det no-lock where
           xxwa_date = issue and
           xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
           xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "")
      break by xxwa_date by xxwa_site by xxwa_line by xxwa_sn by xxwa_part:

      if first-of(xxwa_part) then do:
         assign vqty = xxwa_qty_pln
                vqtya = 0.
      end.
      else do:
        assign vqty = xxwa_qty_pln - vqty.
      end.
      find first lad_det where lad_dataset = "rps_det" and
                 lad_site = xxwa_site and lad_line = xxwa_line and
                 SUBSTRING(lad_nbr,9 ,10 ) >= nbrstart and
                 lad_part = xxwa_part no-lock no-error.
      if availabl(lad_det) then do:
         assign recno = recid(lad_det).
      end.
      repeat:
         find first lad_det where recid(lad_det) = recno no-lock no-error.
         assign vqtya = lad_qty_all - vqtya.
         if vqty <= vqtya then do:
           create xxwd_det.
           assign xxwd_nbr = xxwa_nbr
                  xxwd_ladnbr = lad_nbr
                  xxwd_recid = xxwa_recid
                  xxwd_part = xxwa_part
                  xxwd_site = lad_site
                  xxwd_loc = lad_loc
                  xxwd_lot = lad_lot
                  xxwd_ref = lad_ref
                  xxwd_qty_plan = vqty.
            assign vqtya = vqty.
            leave.
         end.
         else do:
           create xxwd_det.
           assign xxwd_nbr = xxwa_nbr
                  xxwd_ladnbr = lad_nbr
                  xxwd_recid = xxwa_recid
                  xxwd_part = xxwa_part
                  xxwd_site = lad_site
                  xxwd_loc = lad_loc
                  xxwd_lot = lad_lot
                  xxwd_ref = lad_ref
                  xxwd_qty_plan = vqtya.
           assign vqtya = 0.
                  vqty = vqty - vqtya.
           find next lad_det where lad_dataset = "rps_det" and
                 lad_site = xxwa_site and lad_line = xxwa_line and
                 SUBSTRING(lad_nbr,9 ,10 ) >= nbrstart and
                 lad_part = xxwa_part no-lock no-error.
           if availabl(lad_det) then do:
               assign recno = recid(lad_det).
           end.
           else do:
              leave.
           end.
         end.  /*else do:*/
      end.   /* repeat */
  end.
