/* xxsocnimp01.p - import from xls                                            */

/***** 是否有价格表判定:如果是日程单取1.10.1.2普通采购单取1.10.1.1 ****/
find first sod_det no-lock where sod_domain = global_domain
       and sod_nbr = xsd_so and sod_line = xsd_line no-error.
find first so_mstr no-lock where so_domain = global_domain
       and so_nbr = xsd_so no-error.
if available sod_det then do:
    if sod_sched then do:
         find first pc_mstr
             where pc_mstr.pc_domain = global_domain
              and pc_list      = sod_pr_list
              and pc_curr      = so_curr
              and pc_prod_line = ""
              and pc_part      = sod_part
              and pc_um        = sod_um
            no-lock no-error.
         if available pc_mstr then do:
            assign xsd_price = pc_amt[1]
                   xsd_amt = pc_amt[1] * xsd_qty_used.
         end.
         else do:
            /* Required price list for Item # in UM # not found
            {pxmsg.i &MSGNUM=689 &ERRORLEVEL=3
                     &MSGARG1=sod_part &MSGARG2=sod_um}
            */
            assign xsd_chk = "价格表不存在".
         end.

    end. /*  if sod_sched then do: */
    else do:
/*       find first pi_mstr no-lock where pi_domain = global_domain          */
/*              and pi_list = so_cust                                        */
/*              and pi_part_code = sod_part                                  */
/*              and pi_curr = so_curr                                        */
/*              and pi_um = sod_um                                           */
/*              and pi_amt_type = "1"                                        */
/*              and (pi_start <= sod_due_date or pi_start = ?)               */
/*              and (pi_expir >= sod_due_date or pi_expir = ?) no-error.     */
/*       if available pi_mstr then do:                                       */
/*            assign xsd_price = pi_list_price                               */
/*                   xsd_amt = pi_list_price * xsd_qty_used.                 */
/*       end.                                                                */
/*       else do:                                                            */
/*            assign xsd_chk = "价格表不存在".                               */
/*       end.                                                                */
          {gprun.i ""xxgppiwk01.p"" "(1, sod_nbr, sod_line)"}
          find first pt_mstr no-lock where pt_domain = global_domain
                 and pt_part = sod_part no-error.
          find first wkpi_wkfl where wkpi_parent   = ""  and
                         wkpi_feature  = ""  and
                         wkpi_option   = ""  and
                         wkpi_amt_type = "1"
                      no-lock no-error.
          if not available wkpi_wkfl then do:
               /* CHECK PRICE LIST AVAILABILITY FOR INVENTORY ITEMS */
               if right-trim(sod_det.sod_type) = ""
                  or (right-trim(sod_det.sod_type) <> ""
                  and available pt_mstr)
               then do:
                  /* REQUIRED PRICE TABLE FOR ITEM # IN UM # NOT FOUND */
 /*                  6231 零件 # 以 # 为单位的价格表未找到              */
 /*                     {pxmsg.i &MSGNUM=6231 &ERRORLEVEL=4             */
 /*                              &MSGARG1=sod_det.sod_part              */
 /*                              &MSGARG2=sod_det.sod_um}               */
                  assign xsd_chk = "价格表不存在".
               end. /* IF RIGHT-TRIM(SOD_DET.SOD_TYPE) = "" OR ... */
         end. /* IF AVAILABLE WKPI_WKFL ... */
         else do:
              assign xsd_price = wkpi_amt
                     xsd_amt = wkpi_amt * xsd_qty_used.
         end.
   end. /* if sod_sched else do: */
end.
if xsd_price = 0 or xsd_amt = 0 then assign xsd_chk = "价格表不存在".
