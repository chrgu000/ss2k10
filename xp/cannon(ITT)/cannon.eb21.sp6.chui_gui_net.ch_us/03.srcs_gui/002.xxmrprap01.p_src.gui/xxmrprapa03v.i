define {1} shared var v_tmp_nbr like rqf_nbr .
define {1} shared var v_tmp_pre like rqf_pre .


/*存放待审批的记录*/
define {1} shared temp-table temp1 
    field t1_wolot      like wo_lot
    field t1_part       like pt_part 
    field t1_vend       like rqm_mstr.rqm_vend

    field t1_pct        like xxqtd_pct  /*分配比例*/
    field t1_pctqty     like wo_qty_ord /*按分配比例的标准分配量*/ 
    field t1_main_vend  as logical  /*主供应商标志*/
    field t1_qty        like wo_qty_ord /*调整后的分配量,做实际请购采购*/

    field t1_nbr        like rqm_mstr.rqm_nbr   /*存放程式运行时显示的nbr,最后被真实产生的nbr_new覆盖*/
    field t1_nbr_new    like rqm_mstr.rqm_nbr   /*存放最后真实产生的nbr*/
    field t1_rqdline    like rqd_det.rqd_line   /*存放最后真实产生的rqd_line*/
    field t1_wonbr      like wo_nbr
    field t1_due_date   like wo_due_date
    field t1_rel_date   like wo_rel_date
    
    index t1_pct is primary
          t1_wolot t1_part t1_vend 
    index t1_nbr 
          t1_nbr
    index t1_nbr_new 
          t1_nbr_new
    .


/*t2_nbr = t1_nbr ----> t1_nbr_new = t2_nbr_new*/

/*存放临时单号的临时表*/
define {1} shared temp-table temp2 
    field t2_nbr        like rqm_mstr.rqm_nbr
    field t2_nbr_new    like rqm_mstr.rqm_nbr
    index t2_nbr is primary
          t2_nbr
    .