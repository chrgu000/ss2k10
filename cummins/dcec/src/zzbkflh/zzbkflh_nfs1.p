/*Last modified: 2004/1, By: kevin for serial control of final goods*/
/*Last modified: 02/03/2004, By: kevin for non-serial control of final goods*/

/******************comments****************************************
input file layout:
        Field             Format
     1. 雇员                 x(18)
     2. 生效日期            YYYY/MM/DD
     3. 班次                 x(2)
     4. 地点                 x(8)
     5. SO号                 x(18)
     6. 最后道工序          >>>>9
     7. 生产线              x(8)
     8. 工艺流程          x(18)
     9. BOM Code            x(18)
    10. 工作中心           x(8)
    11. 设备              x(8)
    12. 部门                x(8)
    13. 完成数量          >>>>>>>>9
    14. 子零件               x(18)
    15. 子零件工序         >>>>9
    16. 发放数量          >>>>>>>>9
    17. 库位                x(8)
    18. 批/序号            x(16)
    19. 参考号            x(8)
    20. So号                x(18)
    21. 库位                x(8)
    22. 序列号              x(16)
    23. 参考号              x(8)
******************end comments************************************/

/*Program save as   /data3/batch/backflush                                   */
disable triggers for load of glt_det.
disable triggers for load of wo_mstr.
disable triggers for load of wod_det.
disable triggers for load of spt_det.
disable triggers for load of wr_route.
disable triggers for load of tr_hist.
disable triggers for load of in_mstr.
disable triggers for load of ld_det.

session:date-format = 'mdy'.
{mfdeclre.i "new global"}
{mf1.i "new global"}

base_curr = "RMB".
global_userid = "MFG".
mfguser = "".
global_user_lang = "us".
global_user_lang_dir = "us/".
global_domain = "DCEC".
global_db = "DCEC".
execname = "zzbkflh.p".

/*G1MN*/ {gpglefv.i}
define variable srcdir as char format "x(20)".    /*source file directory*/
define variable okdir as char format "x(20)".     /*verified file directory*/
define variable errdir as char format "x(20)".    /*incorrect file directory*/
define variable listfile as char.
define variable logfile as char.
define variable xxinfile as character .
define variable x_data as char extent 26 format "x(20)".
define variable trrecid as recid.
def workfile xxwk
       field emp like emp_addr
       field effdate like tr_effdate
       field shift as char format "x(2)"
       field site like si_site
       field par like ps_par
       field lastop like ro_op
       field line like ln_line
       field routing like ptp_routing
       field bom_code like ptp_bom_code
       field wkctr like wc_wkctr
       field mch like wc_mch
       field dept like dpt_dept
       field qty_comp like tr_qty_loc
       field comp like ps_comp
       field compop like ro_op
       field qty_iss like tr_qty_loc
       field comploc like ld_loc
       field complot like ld_lot
       field compref like ld_ref
       field par2 like ps_par
       field parloc like ld_loc
       field parlot like ld_lot
       field parref like ld_ref.

define variable filename as char.
define workfile list
       field filename as char format "x(40)".

define stream bkfile.
define stream src.
define stream bkflh.
define stream bkflhcim.  /*judy*/
define stream chklog.
define variable bkflh_file as char.
define variable bkflh_filecim as char.    /*judy*/
define variable i as inte.
define variable j as inte.
define variable count as inte.
define variable routing like ro_routing.
define variable bom_code like bom_parent.
define variable cumwo_lot as character.
define variable schedwo_lot as character.
define variable ok_yn as logic.
define variable cim_yn as logic no-undo.
/*judy*/
 define temp-table xxld_wkfl
        field  xxld_part like pt_part
        field  xxld_site like ld_site
        field  xxld_loc like ld_loc
        field  xxld_lot like ld_lot
        field  xxld_ref like ld_ref
        field  xxld_qty_oh like ld_qty_oh.
for each xxld_wkfl:
    delete xxld_wkfl.
end.
/*judy*/


find first usrw_wkfl where usrw_domain = global_domain
       and usrw_key1 = "BKFLH-CTRL" no-lock no-error.
if not available usrw_wkfl then do:
    message "回冲事务控制文件[yybkctl.p]没有设置!" view-as alert-box error.
    leave.
end.

srcdir = usrw_charfld[10].
okdir = usrw_charfld[11].
errdir = usrw_charfld[12].
logfile = usrw_charfld[13] + "xxbkflh.log".
bkflh_file = usrw_charfld[14] + "bkflh_file.in".
bkflh_filecim = usrw_charfld[14] + "bkflh_file.in".
listfile = usrw_charfld[14] + "list.txt".

srcdir = "/data3/batch/bkfl/source/".
okdir = "/data3/batch/bkfl/correct".
errdir = "/data3/batch/bkfl/error".
logfile = "/data3/batch/bkfl/xxbkflh_nfs.log".
bkflh_file = "/data3/batch/bkfl/temp/bkflh_file_nfs.in".
bkflh_filecim = "/data3/batch/bkfl/temp/bkflh_file_nfs.in".
listfile = "/data3/batch/bkfl/temp/" + "list_nfs.txt".

/*******To get the backflush source file list***********/
if opsys = "UNIX" then
unix silent value("ls " + srcdir + " > " + listfile).
else
Dos silent value("dir /b " + srcdir + " > " + listfile).

input stream bkfile from value(listfile).
repeat:
    import stream bkfile delimiter "," filename.
    create list.
    assign list.filename = filename.
end.
input stream bkfile close.

/*record the log file*/
output stream chklog close.
output stream chklog to value(logfile) append.

put stream chklog unformat skip(2).
put stream chklog unformat "=======================  Run Date: " today   "   Start Run Time: " string(time,"HH:MM:SS") "================" skip.

find first list no-lock no-error.
if not available list then do:
     put stream chklog unformat "Error: No source file for backflush!" at 1.
     leave.
end.
put stream chklog unformat "begin List: " string(time,"HH:MM:SS") skip.
for each list where list.filename <> "" no-lock:

output stream bkflh close.
assign bkflh_file = bkflh_filecim + list.filename + ".in".
output stream bkflh to value(bkflh_file).
      for each xxwk exclusive-lock: delete xxwk. end.

      ok_yn = yes.
      put stream chklog unformat skip(1).
      put stream chklog unformat "Now process file: " + list.filename at 1 skip.
         /*for log file*/
       xxinfile = srcdir + list.filename.
       if opsys = "UNIX" then
       input stream src through value("cat '" + xxinfile + "' |" +  "tr -d '\015'").
       else
       input stream src from value(xxinfile).
       i = 0.
       repeat: /*repeat #1*/
          i = i + 1.
         import stream src delimiter "," x_data.

          if i > 1 then do:
               create xxwk.
               assign xxwk.emp = x_data[1]
                      xxwk.effdate = date(int(substr(x_data[2],6,2))
                                         ,int(substr(x_data[2],9,2))
                                         ,int(substr(x_data[2],1,4)))
                      xxwk.shift = x_data[3]
                      xxwk.site = x_data[4]
                      xxwk.par = x_data[5]
                      xxwk.lastop = inte(x_data[6])
                      xxwk.line = x_data[7]
                      xxwk.routing = x_data[8]
                      xxwk.bom_code = x_data[9]
                      xxwk.wkctr = x_data[10]
                      xxwk.mch = x_data[11]
                      xxwk.dept = x_data[12]
                      xxwk.qty_comp = deci(x_data[13])
                      xxwk.comp = x_data[14]
                      xxwk.compop = inte(x_data[15])
                      xxwk.qty_iss = deci(x_data[16])
                      xxwk.comploc = x_data[17]
                      xxwk.complot = x_data[18]
                      xxwk.compref = x_data[19]
                      xxwk.par2 = x_data[20]
                      xxwk.parloc = x_data[21]
                      xxwk.parlot = x_data[22]
                      xxwk.parref = x_data[23].

         end. /*if i > 1*/

       end. /*repeat #1*/
      input stream src close.

       find first xxwk no-lock no-error.
       if not available xxwk then do:
            put stream chklog unformat "Error: No data need to process!" at 5 skip.
            ok_yn = no.
       end.
put stream chklog unformat "Start Progress " + list.filename + ":" + string(time,"HH:MM:SS") skip.
/***********************
if ok_yn = no then do:
  if opsys = "UNIX" then
         unix silent value("mv '" + srcdir + list.filename + "' " + errdir).
  else
         Dos silent value("move " + "~"" + srcdir + list.filename + "~"" + " " + errdir).
         next.
end.
***********************/
       /*verify every field before cimload*/
        find emp_mstr where emp_domain = global_domain and
             emp_addr = xxwk.emp no-lock no-error.
       if not available emp_mstr then do:
              put stream chklog unformat "错误: 雇员号不存在 " xxwk.emp at 5 skip.
              ok_yn = no.
       end.

               /*verify the site*/
               find si_mstr where si_domain = global_domain and
                    si_site = xxwk.site no-lock no-error.

               if not available si_mstr then do:
                    put stream chklog unformat "错误: 地点不存在" at 5 skip.
                    ok_yn = no.
               end.
/*
/*J04T*/       {gprun.i ""gpsiver.p"" "(input site,
                                        input recid(si_mstr),
                                        output return_int)"
               }

/*J04T*/       if return_int = 0 then do:
                    put stream chklog unformat "错误: 用户无访问此地点的权限" at 5 skip.
                    ok_yn = no.
/*J04T*/       end.
*/

          /*verify the GL period*/
          /* VALIDATE OPEN GL PERIOD FOR SPECIFIED ENTITY */
          /* DEFINE VALIDATION PARAMETERS */
          gpglef_tr_type  = "IC".
          gpglef_entity   = si_entity.
          gpglef_effdate  = xxwk.effdate.
          global_user_lang_dir = "ch/" .
          {gprun.i ""gpglef1.p""
                "( input  gpglef_tr_type,
                   input  gpglef_entity,
                   input  gpglef_effdate,
                   output gpglef_result,
                   output gpglef_msg_nbr
                 )" }

          /* PROCESS VALIDATION RESULTS */
          if gpglef_result > 0 then do:

             /* INVALID PERIOD */
             if gpglef_result = 1 then do:
                put stream chklog unformat "错误: 无效的周期／年份" at 5 skip.
                ok_yn = no.
             end.
             /* PERIOD CLOSED FOR ENTITY */
             else if gpglef_result = 2 then do:
                put stream chklog unformat "错误: 会计单位的期间已经结束" at 5 skip.
                ok_yn = no.
             end.
          end.

          /*verify the parent number*/
        if SESSION:PARAMETER = "" then do:
           find pt_mstr where pt_domain = global_domain and
                pt_part = xxwk.par no-lock no-error.
           if not available pt_mstr then do:
                put stream chklog unformat "错误: 父零件号 " + xxwk.par + " 不存在" at 5 skip.
                ok_yn = no.
           end.
        end.
/*G1ZV*/   if can-find(first isd_det where isd_domain = global_domain and
/*G1ZV*/              isd_status = string(pt_status,"x(8)") + "#"
/*G1ZV*/              and (isd_tr_type = "ISS-WO" or isd_tr_type = "RCT-WO")) then do:
                put stream chklog unformat "错误: 零件状态代码的限定过程 " + pt_status at 5 skip.
              ok_yn = no.
/*F089*/   end.

        /*verify the produce line*/
/*G2JT*/    find first lnd_det
/*G2JT*/    where lnd_domain = global_domain and lnd_line = xxwk.line
/*G2JT*/      and lnd_site = xxwk.site
/*G2JT*/      and lnd_part = xxwk.par
/*G2JT*/      and (lnd_start <= today or lnd_start = ?)
/*G2JT*/    no-lock no-error.

            if not available lnd_det then do:
                 put stream chklog unformat "错误: 对于地点 " + xxwk.site + " ,零件 "
                                 + xxwk.par + " 的生产线 " + xxwk.line + " 不存在" at 5 skip.
                 ok_yn = no.
            end.

         /*verify the*/

        /*verify whether there is any unexpolded schedule*/
               /*FIND DEFAULT BOM AND ROUTING CODES*/
               {gprun.i ""reoptr1b.p""
               "(input xxwk.site, input xxwk.line, input xxwk.par, input xxwk.lastop, input xxwk.effdate,
               output routing, output bom_code, output schedwo_lot)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*G1Z7*/       if schedwo_lot = "?" then do:
/*G1Z7*/            /* Unexploded schedule with consumption period */
                    put stream chklog unformat "错误: 未分解的日程在消耗期间内" at 5 skip.
                    ok_yn = no.
/*G1Z7*/       end.

          /*verify the routing code*/
         if xxwk.routing = "" then
            find first ro_det where ro_domain = global_domain and ro_routing = xxwk.par
                                and (ro_start = ? or ro_start  <= xxwk.effdate)
                                and (ro_end = ? or ro_end    >= xxwk.effdate)no-lock no-error.
         else find first ro_det where ro_domain = global_domain and ro_routing = xxwk.routing
                                and (ro_start = ? or ro_start  <= xxwk.effdate)
                                and (ro_end = ? or ro_end    >= xxwk.effdate)no-lock no-error.

         if not available ro_det then do:
                 put stream chklog unformat "错误: 工艺流程不存在" at 5 skip.
                 ok_yn = no.
         end.

         /*verify the op*/
      if xxwk.routing > "" then
        find ro_det where ro_domain = global_domain and
          ro_routing = xxwk.routing and
          ro_op      = xxwk.lastop and
          (ro_start = ? or ro_start  <= xxwk.effdate) and
          (ro_end = ? or ro_end    >= xxwk.effdate)
          no-lock no-error.
      else
        find ro_det where ro_domain = global_domain and
          ro_routing = xxwk.par and
          ro_op      = xxwk.lastop and
          (ro_start = ? or ro_start  <= xxwk.effdate) and
          (ro_end = ? or ro_end    >= xxwk.effdate)
          no-lock no-error.
     if not available ro_det then do:
        put stream chklog unformat "错误: 输入的最后一道工序在工艺流程中不存在" at 5 skip.
        ok_yn = no.
    end.

      /*verify the routing code and bom code*/
         find ptp_det no-lock where ptp_domain = global_domain and ptp_part = xxwk.par
           and ptp_site = xxwk.site no-error.

         /* IF BOTH THE ROUTING AND BOM_CODE ARE DEFAULTS, THEN NO      */
         /* ALTERNATE ROUTING OR BOM_CODE IS REQURIED.                  */
         if not
           (xxwk.routing = ""
             or xxwk.routing = xxwk.par
             or (not available ptp_det
                 and available pt_mstr and xxwk.routing = pt_routing)
             or (available ptp_det and xxwk.routing = ptp_routing)
            )
            or
            not
            (xxwk.bom_code = ""
             or xxwk.bom_code = xxwk.par
             or (not available ptp_det
                 and available pt_mstr and xxwk.bom_code = pt_bom_code )
             or (available ptp_det and xxwk.bom_code = ptp_bom_code)
            )
         then do:
               put stream chklog unformat "错误: 工艺流程代码或产品结构代码无效" at 5 skip.
               ok_yn = no.
         end.


    /*FIND CUM ORDER. */
    cumwo_lot = ?.
    {gprun.i ""regetwo.p"" "(xxwk.site, xxwk.par, xxwk.effdate,
       xxwk.line, xxwk.routing, xxwk.bom_code, output cumwo_lot)"}
    if cumwo_lot <> ? then do:
       find wo_mstr where wo_domain = global_domain and wo_lot = cumwo_lot no-lock no-error.
       if wo_status = "C" then do:
             put stream chklog unformat "错误: 累计加工单,标" + wo_lot + " 已结" at 5 skip.
             ok_yn = no.
       end.
    end.

      /*verify whether the input last op is the actual last one*/
      if cumwo_lot <> ? then do:
        find first wr_route where wr_domain = global_domain and
                   wr_lot = cumwo_lot and wr_op = xxwk.lastop no-lock no-error.
        if not available wr_route then do:
            put stream chklog unformat "错误: 输入的最后一道工序在加工单工艺流程中不存在" at 5 skip.
            ok_yn = no.
        end.

        find last wr_route where wr_domain = global_domain and
                  wr_lot = cumwo_lot no-lock no-error.
        if available wr_route then do:
           if wr_op <> xxwk.lastop then do:
              put stream chklog unformat "错误: 输入的最后一道工序不是加工单工艺流程中的最后一道工序" at 5 skip.
              ok_yn = no.
           end.
        end.
     end.
     else do:
         if xxwk.routing = "" then
             find last ro_det where ro_domain = global_domain and
                       ro_routing = xxwk.par no-lock no-error.
         else find last ro_det where ro_domain = global_domain and
                        ro_routing = xxwk.routing no-lock no-error.
         if available ro_det then do:
               if ro_op <> xxwk.lastop then do:
                      put stream chklog unformat "错误: 输入的最后一道工序不是工艺流程中的最后一道工序" at 5 skip.
                      ok_yn = no.
               end.
         end.
      end.

         /*verify the work center*/
         find wc_mstr where wc_domain = global_domain and
              wc_wkctr = xxwk.wkctr and wc_mch = xxwk.mch no-lock no-error.
         if not available wc_mstr then do:
               put stream chklog unformat "错误: 工作中心不存在" at 5 skip.
               ok_yn = no.
         end.

       if SESSION:PARAMETER = "" then do:
          if xxwk.qty_comp <= 0 then do:
               put stream chklog unformat "错误: 完成数量必须大于零" at 5 skip.
               ok_yn = no.
          end.
       end.

       /*verify the data of components*/
      find first xxwk no-lock no-error.
       repeat:
           if available xxwk then do:
              /*verify the components item number*/
              find pt_mstr where pt_domain = global_domain and
                   pt_part = xxwk.comp no-lock no-error.
              if not available pt_mstr then do:
                    put stream chklog unformat "错误: 子零件 " + xxwk.comp + " 不存在" at 5 skip.
                    ok_yn = no.
              end.

/*judy begin added*/
            find pt_mstr where pt_domain = global_domain and
                 pt_part = xxwk.comp no-lock no-error.
      if avail pt_mstr then do:
  /*G1ZV*/   if can-find(first isd_det where isd_domain = global_Domain and
  /*G1ZV*/              isd_status = string(pt_status,"x(8)") + "#"
  /*G1ZV*/              and (isd_tr_type = "ISS-WO" or isd_tr_type = "RCT-WO")) then do:
      put stream chklog unformat "错误: 零件" + xxwk.comp + "状态代码的限定过程 " + pt_status at 5 skip.
          ok_yn = no.
       end.
     end.
/*judy end of added*/

              /*verify the components op*/
              if cumwo_lot <> ? then do:
                  find first wr_route where wr_domain = global_domain and
                             wr_lot = cumwo_lot and wr_op = xxwk.compop no-lock no-error.
                  if not available wr_route then do:
                     put stream chklog unformat "错误: 子零件 " + xxwk.comp + " 的工序 " + string(xxwk.compop)
                                      + " 在加工单 " + cumwo_lot
                                      + "　的工艺流程中不存在" at 5 skip.
                     ok_yn = no.
                  end.
              end.
              else do:
                  if xxwk.routing > "" then
                        find ro_det where ro_domain = global_domain and
                                          ro_routing = xxwk.routing and
                                          ro_op      = xxwk.compop and
                                         (ro_start = ? or ro_start  <= xxwk.effdate) and
                                         (ro_end = ? or ro_end    >= xxwk.effdate)
                                         no-lock no-error.
                  else
                        find ro_det where ro_domain = global_domain and
                             ro_routing = xxwk.par and
                                          ro_op      = xxwk.compop and
                                          (ro_start = ? or ro_start  <= xxwk.effdate) and
                                          (ro_end = ? or ro_end    >= xxwk.effdate)
                                          no-lock no-error.
                  if not available ro_det then do:
                         put stream chklog unformat "错误: 子零件 " + xxwk.comp + " 的工序 " + string(xxwk.compop) +
                                         " 在工艺流程中不存在" at 5 skip.
                         ok_yn = no.
                  end.
              end. /*if cumwo_lot = ?*/

              /*verify the components location & it's status*/
              find loc_mstr where loc_domain = global_domain and
                   loc_site = xxwk.site and loc_loc = xxwk.comploc no-lock no-error.
              if not available loc_mstr then do:
                   put stream chklog unformat "错误: 子零件 " + xxwk.comp + " 所对应的库位 " + xxwk.site + ","
                                   + xxwk.comploc + " 不存在" at 5 skip.
                   ok_yn = no.
              end.

/*judy begin added*/
             FIND FIRST IS_mstr WHERE is_domain = global_domain and
                        IS_status = (if available loc_mstr and loc_status <> "" then loc_status
                                      else si_status) NO-LOCK NO-ERROR.
             IF IS_overissue = NO and avail loc_mstr then DO:
          for each ld_det  WHERE ld_domain = global_domain and
                   ld_site = xxwk.site AND ld_part = xxwk.comp
          AND ld_loc = xxwk.comploc AND ld_lot = xxwk.complot
          AND ld_ref = xxwk.compref no-lock:
       find first xxld_wkfl where xxld_part = ld_part
        and xxld_loc = ld_loc
        and xxld_site = ld_site
        and xxld_lot = ld_lot
        and xxld_ref = ld_ref no-error.

       if not avail xxld_wkfl then do:
          create xxld_wkfl.
          assign xxld_part = ld_part
           xxld_site = ld_site
           xxld_loc = ld_loc
           xxld_lot = ld_lot
           xxld_ref = ld_ref
           xxld_qty_oh = ld_qty_oh.
              end.
           end.
           find first xxld_wkfl where xxld_site = xxwk.site
        and xxld_loc = xxwk.comploc
        and xxld_lot = xxwk.complot
        and xxld_ref = xxwk.compref
        and xxld_part = xxwk.comp  no-error.
     if avail xxld_wkfl then do:
       xxld_qty_oh = xxld_qty_oh  -  xxwk.qty_iss.
       if xxld_qty_oh < 0 then  do:
           put stream chklog unformat "错误: 子零件 " + xxwk.comp + " 所对应的库位 " + xxwk.site + ","
             + xxwk.comploc + "发放数量大于库存量" + STRING( xxld_qty_oh)  at 5 skip.
           ok_yn = no.
        END.

      end.
      else if not avail xxld_wkfl then do:
         put stream chklog unformat "错误: 子零件 " + xxwk.comp + " 所对应的库位 " + xxwk.site + ","
             + xxwk.comploc + "发放数量大于库存量" + "0"  at 5 skip.
         ok_yn = no.
      end.

            END.

/*judy end of added*/

              find isd_det no-lock where isd_domain = global_domain and isd_tr_type = "iss-wo"
                                      and isd_status =
                                     (if available loc_mstr and loc_status <> "" then loc_status
                                      else si_status) no-error.
              if available isd_det then do:
                   put stream chklog unformat "子零件 " + xxwk.comp + " 所对应的库位 " + xxwk.site + "," + xxwk.comploc
                                   + " 的状态为限定状态" at 1 skip.
                   ok_yn = no.
              end.

              find next xxwk no-lock no-error.
           end. /*if available xxwk*/
           else leave.
      end.

      /*verify the data of final goods*/
      count = 0.
      find first xxwk where xxwk.par2 <> "" no-lock no-error.
      if not available xxwk then do:
           put stream chklog unformat "错误: 没有发动机入库的信息" at 5 skip.
           ok_yn = no.
      end.
      repeat:
           if available xxwk then do:
                  count = count + 1.
                  /*verify the xxwk.par2 item number*/
                  find pt_mstr where pt_domain = global_domain and
                       pt_part = xxwk.par2 no-lock no-error.
                  if not available pt_mstr then do:
                       put stream chklog unformat "错误: SO号 " + xxwk.par2 + " 不存在" at 5 skip.
                       ok_yn = no.
                  end.

                  /*verify the lot number*/
                  if xxwk.parlot = "" then do:
                       put stream chklog unformat "错误: 存在无流水号的SO" at 5 skip.
                       ok_yn = no.
                  end.

                  find loc_mstr where loc_domain = global_domain and
                       loc_site = xxwk.site and loc_loc = xxwk.parloc no-lock no-error.
                  if not available loc_mstr then do:
                         put stream chklog unformat "发动机所对应的库位 " + xxwk.site + "," + xxwk.parloc + " 不存在" at 5 skip.
                             ok_yn = no.
                     end.

                     find isd_det no-lock where isd_domain = global_domain and
                          isd_tr_type = "rct-wo"
                                             and isd_status =
                                            (if available loc_mstr and loc_status <> "" then loc_status
                                            else si_status) no-error.
                     if available isd_det then do:
                           put stream chklog unformat "发动机所对应的库位 " + xxwk.site + "," + xxwk.comploc
                                         + " 的状态为限定状态" at 1 skip.
                           ok_yn = no.
                    end.
                  find next xxwk where xxwk.par2 <> "" no-lock no-error.
           end.
           else leave.
      end.

      find first xxwk where xxwk.par2 <> "" no-lock no-error.
      if available xxwk then do:
           if count <> xxwk.qty_comp then do:
                 put stream chklog unformat "错误: 发动机流水号的个数与回报的完成量不一致" at 5 skip.
                 ok_yn = no.
           end.
     end.
    put stream chklog unformat "数据检查完成! " string(time,"HH:MM:SS") skip.
      /****exchange the list data to stream format data for batch input***/

     /*create the header format*/
     find first xxwk no-lock no-error.
      put stream bkflh "~"" at 1 xxwk.emp "~"".
      put stream bkflh UNFORMAT xxwk.effdate at 1.
      put stream bkflh UNFORMAT " ~"" xxwk.shift "~"" " ~"" xxwk.site "~"".
      put stream bkflh UNFORMAT "~"" at 1 xxwk.par "~" " xxwk.lastop " ~"" xxwk.line "~"".
      put stream bkflh UNFORMAT "~"" at 1 xxwk.routing "~"" " ~"" xxwk.bom_code "~"".
      put stream bkflh UNFORMAT "~"" at 1 xxwk.wkctr "~"" " ~"" xxwk.mch "~"".
      put stream bkflh UNFORMAT "~"" at 1 xxwk.dept "~" " xxwk.qty_comp " - - - - - - - - - Y Y".

     /*create the detail components issue format*/
      put stream bkflh UNFORMAT  "-" AT 1.
      for each xxwk where xxwk.comp <> "" no-lock:
          put stream bkflh UNFORMAT "~"" at 1 xxwk.comp "~" " xxwk.compop.
          put stream bkflh UNFORMAT xxwk.qty_iss at 1 " N " "~"" xxwk.site "~"" " ~"" xxwk.comploc "~""
                              " ~"" xxwk.complot "~"" " ~"" xxwk.compref "~"".
      end.

      put stream bkflh UNFORMAT "." at 1 skip.
      find first xxwk no-lock no-error.
      put stream bkflh UNFORMAT xxwk.qty_comp at 1 " - - " "~"" xxwk.site "~"" " ~"" xxwk.parloc  "~"" " - - " "N N".

    put stream bkflh skip "yes" skip "yes" skip.
    put stream bkflh "." at 1.
    put stream bkflh "." at 1.
    put stream bkflh "." at 1 skip.
    output stream bkflh close.
if ok_yn = no then do:
   put stream chklog unformat "check error found" skip.
end.
else do:
    put stream chklog unformat "CIM_LOAD: " string(time,"HH:MM:SS") skip.
    cimrunprogramloop:
    do on stop undo cimrunprogramloop,leave cimrunprogramloop:
        assign trrecid = current-value(tr_sq01).
        input from value(bkflh_file).
        output to value(bkflh_filecim + ".out") append.
        batchrun = yes.
        {gprun.i ""xxrebkfl1.p""}
        batchrun = no.
        output close.
        input close.
    /*    put stream chklog unformat "CIM_LOAD 完成,检查CIM结果:" string(time,"HH:MM:SS") skip. */
        /* check cim_load status! */
        assign cim_yn = yes.
        find first tr_hist no-lock where tr_domain = global_domain and
                   tr_trnbr > integer(trrecid) and tr_part = xxwk.par and
                   tr_type = "rct-wo" and tr_qty_loc = xxwk.qty_comp and
                   tr_site = xxwk.site and tr_loc = xxwk.parloc no-error.
        if not available tr_hist then do:
           put stream chklog unformatted "错误:" + srcdir + list.filename + "CIM_LOAD失败。" at 5.
           put stream chklog unformat xxwk.par " " xxwk.parloc  " iss-wo " xxwk.qty_comp at 5.
           assign cim_yn = no.
        end.
        for each xxwk where xxwk.comp <> "" and xxwk.qty_iss <> 0 no-lock:
            find first tr_hist no-lock where tr_domain = global_domain and
                tr_trnbr > integer(trrecid) and tr_part = xxwk.comp and
                tr_type = "iss-wo" and tr_qty_loc = -1 * xxwk.qty_iss and
                tr_site = xxwk.site and tr_loc = xxwk.comploc and
                tr_serial = xxwk.complot AND tr_ref = xxwk.compref
                no-error.
            if not availabl tr_hist then do:
                put stream chklog unformatted "错误:" + srcdir + list.filename + "CIM_LOAD失败。" at 5.
                put stream chklog unformat xxwk.comp " " xxwk.comploc " " xxwk.complot " iss-wo " xxwk.qty_iss at 5.
                assign  cim_yn = no.
            end.
        end.
        if cim_yn = no then do:
           undo cimrunprogramloop, leave.
        end.
    end.    /* cimrunprogramloop */
        put stream chklog unformat list.filename " 处理完成! " string(time,"HH:MM:SS") skip.
end.  /* if ok_yn = no else do: */
    if ok_yn = no or cim_yn = no then do:
        if opsys = "UNIX" then
           unix silent value("mv + '" + srcdir + list.filename + "' '" + errdir + list.filename + "'").
        else
           Dos silent value("move " + "~"" + srcdir + list.filename + "~"" + " " + errdir + list.filename).
    end.
    else do:
         if opsys = "UNIX" then
            unix silent value("mv '" + srcdir + list.filename + "' " + okdir).
         else
            Dos silent value("move " + "~"" + srcdir  + list.filename + "~"" + " " + okdir).
    end.
end. /*for each list*/


put skip(1).
put unformat "=======================  Run Date: " today.
put unformat "   End Run Time: " string(time,"HH:MM:SS") "================" skip(1).
