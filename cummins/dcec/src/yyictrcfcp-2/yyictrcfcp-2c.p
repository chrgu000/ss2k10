/* yyictrcfcp-2c.p - Export Data to CSV Format                               */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION END                                                              */
{mfdeclre.i}
{yyictrcfcrpx.i}
define input parameter thfile as CHAR FORMAT "x(50)".
define variable ptdesc2 like pt_desc2.
define variable ptprodline like pt_prod_line.
define variable bexcel as com-handle.
define variable bbook as com-handle.
define variable bsheet as com-handle.
define variable I as integer.
output to value(thfile).
   export delimiter ","
                    "零件号"
                    "地点"
                    "零件描述"
                    "产品类"
                    "ABC类"
                    "保管员代码"
                    "默认库位"
                    "采购员代码"
                    "供应商代码"
                    "E&O"
                    "采购收货"
                    "转移入库"
                    "计划外入库"
                    "加工单入库"
                    "采购退货"
                    "转移出库"
                    "计划外出库"
                    "销售出库"
                    "加工单出库"
                    "盘点调整"
                    "其他".

for each temptr no-lock break by ttr_part by ttr_site:
        if first-of(ttr_part) then do:
           assign ptdesc2 = ""
                  ptprodline = "".
           find first pt_mstr no-lock where pt_domain = global_domain
                  and pt_part = ttr_part no-error.
           if available pt_mstr then do:
              assign ptdesc2 = pt_desc2
                     ptprodline = pt_prod_line.
           end.
        end.
        find first ptp_det no-lock where ptp_domain = global_domain
               and ptp_part = ttr_part and ptp_site = ttr_site no-error.
        find first in_mstr no-lock where in_domain = global_domain
               and in_part = ttr_part and in_site = ttr_site.
                put unformat "'" + ttr_part ",".
                put unformat "'" + ttr_site ",".
                put unformat "'" + ptdesc2 ",".
                put unformat "'" + ptprodline ",".
                if available (in_mstr) then do:
                   put unformat "'" + in_abc ",".
                   put unformat "'" + in__qadc01 ",".
                   put unformat "'" + in_loc ",".
                end.
                else do:
                   put unformat ',,,'.
                end.
                if available ptp_det then do:
                   put unformat "'" + ptp_buyer ",".
                   put unformat "'" + ptp_vend ",".
                   put unformat "'" + ptp_run_seq2 ",".
                end.
                else do:
                  put unformat ',,,'.
                end.
                put unformat ttr_rctpo  ",".
                put unformat ttr_rcttr   ",".
                put unformat ttr_rctunp  ",".
                put unformat ttr_rctwo  "," .
                put unformat ttr_isspo  "," .
                put unformat ttr_isstr  "," .
                put unformat ttr_issunp  ",".
                put unformat ttr_issso   ",".
                put unformat ttr_isswo   ",".
                put unformat ttr_invadj  ",".
                put unformat ttr_oth     "," skip.
    end.
