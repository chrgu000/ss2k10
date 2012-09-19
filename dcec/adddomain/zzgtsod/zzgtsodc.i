/* zzgtsodc.i -  */


define {1} shared workfile wkgtm
/*                  field    wkgtm_ref      as character format "x(20)" column-label "参考号"
                  field    wkgtm_line     as integer   format ">>>9"  column-label "行数"
                  field    wkgtm_name     as character format "x(100)" column-label "客户名称"
                  field    wkgtm_taxid    as character format "x(15)" column-label "税号"
                  field    wkgtm_addr     as character format "x(80)" column-label "客户地址"
                  field    wkgtm_bkacct   as character format "x(80)" column-label "银行"
                  field    wkgtm_rmks     as character format "x160)" column-label "备注"
                  field    wkgtm_status   as character format "x(1)"  column-label "T"
                  field    wkgtm_msg      as character format "x(40)" column-label "错误信息"
                  field    wkgtm_totamt   as decimal   format "->>>>>>>>>>>>9.99"  column-label "总金额"
                  field    wkgtm_site     like so_site                column-label "地点"
                  field    wkgtm_bill     like so_bill                column-label "客户"
                  . */
                  field    wkgtm_ref      as character format "x(20)" column-label "单据号"
                  field    wkgtm_line     as integer   format ">>>9"  column-label "行数"
                  field    wkgtm_name     as character format "x(100)" column-label "购方名称"
                  field    wkgtm_taxid    as character format "x(15)" column-label "购方税号"
                  field    wkgtm_addr     as character format "x(80)" column-label "购方地址电话"
                  field    wkgtm_bkacct   as character format "x(80)" column-label "购方银行"
                  field    wkgtm_rmks     as character format "x(160)" column-label "备注"
                  field    wkgtm_status   as character format "x(1)"  column-label "T"
                  field    wkgtm_msg      as character format "x(40)" column-label "错误信息"
                  field    wkgtm_totamt   as decimal   format "->>>>>>>>>>>>9.99"  column-label "总金额"
                  field    wkgtm_site     like so_site                column-label "地点"
                  field    wkgtm_bill     like so_bill                column-label "客户"
                  .

define {1} shared workfile wkgtd
/*                  field    wkgtd_ref      as character format "x(50)"
                  field    wkgtd_line     as integer   format ">>>9"
                  field    wkgtd_item     as character format "x(30)"
                  field    wkgtd_um       as character format "x(6)"
                  field    wkgtd_spec     as character format "x(16)"
                  field    wkgtd_qty      as decimal   format "->>>>>>>>>>>>>>9.9<<<<<"
                  field    wkgtd_totamt      as decimal   format "->>>>>>>>>>>>>.99"
                  field    wkgtd_taxpct   as decimal   format ">>>9.99"
                  field    wkgtd_kind     as character format "x(5)"
                  field    wkgtd_discamt  as decimal   format "->>>>>>>>>>>>9.99"
                  field    wkgtd_netamt   as decimal   format "->>>>>>>>>>>>9.99"
                  field    wkgtd_status   as character format "x(1)"
                  . lb01*/
                  field    wkgtd_ref      as character format "x(20)"
                  field    wkgtd_line     as integer   format ">>>9"
                  field    wkgtd_item     as character format "x(60)"
                  field    wkgtd_um       as character format "x(16)"
                  field    wkgtd_spec     as character format "x(30)"
                  field    wkgtd_qty      as decimal   format "->>>>>>>>>>>>>>9.9<<<<<"
                  field    wkgtd_totamt      as decimal   format "->>>>>>>>>>>>9.99"
                  field    wkgtd_taxpct   as decimal   format ">>>9.99"
                  field    wkgtd_kind     as character format "x(5)"
                  field    wkgtd_discamt  as decimal   format "->>>>>>>>>>>>9.99"
                  field    wkgtd_netamt   as decimal   format "->>>>>>>>>>>>9.99"
                  field    wkgtd_status   as character format "x(1)"
                  .
