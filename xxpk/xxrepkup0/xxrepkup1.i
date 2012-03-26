/* 库存信息表 */
define {1} shared temp-table tsupp
    field tsu_loc     like loc_loc
    field tsu_part    like pt_part
    field tsu_lot     like ld_lot
    field tsu_ref     like ld_ref
    field tsu_qty     like ld_qty_oh            
    field tsu_flg     like loc_user2            /* 备料标志　*/               
    field tsu_abc     like pt__chr10            /* A B C类　*/                
    field tsu_lpacks  like ld_qty_oh            /* 本批次多少个包装 */        
    field tsu_ltrail  like ld_qty_oh            /* 本批次包装尾数 */          
    field tsu_bpacks  like ld_qty_oh            /* 本批次多少个托盘 */        
    field tsu_btrail  like ld_qty_oh            /* 本批次托盘尾数 */          
    field tsu_lit     like ld_qty_oh            /* 包装数量 */                
    field tsu_big     like ld_qty_oh            /* 托盘数量 */                
    .
    
/* 生产线需求表 */    
define {1} shared temp-table tiss1
    field tiss1_pdate    like xxwa_date
    field tiss1_sdate    like xxwa_date
    field tiss1_rdate    like xxwa_date
    field tiss1_ptime    like xxwa_pstime
    field tiss1_stime    like xxwa_sstime
    field tiss1_rtime    like xxwa_rtime
    field tiss1_line     like xxwa_line
    field tiss1_part     like xxwa_part
    field tiss1_qty      like xxwa_ord_mult
    .


/*
   托盘数量 pt__qad20   
   最小包装 pt__qad19
   pt__chr10  A/B/C类  
   A类 按托取 发料按包装数发
   B类 需求取 需求发
   C类 最小包装取 最小包装发
   loc_user2 可备料标志
 */

/* 发料队列表 */
define {1} shared temp-table trlt1
    field trt1_seq   as int
    field trt1_pdate as date
    field trt1_ptime as integer
    field trt1_sdate as date
    field trt1_stime as integer
    field trt1_line like  xxwa_line
    field trt1_loc like loc_loc
    field trt1_part like pt_part
    field trt1_lot like ld_lot
    field trt1_ref like ld_ref
    field trt1_qty like ld_qty_oh
    .
    
/* 取料队列表 */    
define {1} shared temp-table trlt2
    field trt2_seq      as int
    field trt2_date     like xxwa_date
    field trt2_time     like xxwa_pstime
    field trt2_loc      like loc_loc
    field trt2_part     like pt_part
    field trt2_lot      like ld_lot
    field trt2_ref      like ld_ref
    field trt2_qty      like ld_qty_oh
    .
