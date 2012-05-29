/* 库存信息表 */
define {1} shared temp-table tsupp
    field tsu_loc     like loc_loc
    field tsu_part    like pt_part
    field tsu_lot     like ld_lot
    field tsu_ref     like ld_ref
    field tsu_qty     like ld_qty_oh            
    field tsu_tqty    like ld_qty_oh            
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
    field tiss1_nbr      like xxwa_nbr
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
    field trt1_seq      as int
    field trt1_nbr      like xxwa_nbr
    field trt1_pdate    as date
    field trt1_ptime    as integer
    field trt1_sdate    as date
    field trt1_stime    as integer
    field trt1_line     like  xxwa_line
    field trt1_loc      like loc_loc
    field trt1_part     like pt_part
    field trt1_lot      like ld_lot
    field trt1_ref      like ld_ref
    field trt1_qty      like ld_qty_oh
    .
    
/* 取料队列表 */    
define {1} shared temp-table trlt2
    field trt2_seq      as int
    field trt2_nbr      like xxwa_nbr
    field trt2_date     like xxwa_date
    field trt2_time     like xxwa_pstime
    field trt2_loc      like loc_loc
    field trt2_part     like pt_part
    field trt2_lot      like ld_lot
    field trt2_ref      like ld_ref
    field trt2_qty      like ld_qty_oh
    .
/* 已有的取料发料队列表 */       
define {1} shared temp-table tt1swddet
    field tt1swd_ladnbr     like xxwd_ladnbr    
    field tt1swd_nbr        like xxwd_nbr    
    field tt1swd_part       like xxwd_part                                      
    field tt1swd_site       like xxwd_site                                    
    field tt1swd_line       like xxwd_line                             
    field tt1swd_date       like xxwa_date
    field tt1swd_time       as integer
    field tt1swd_loc        like xxwd_loc                                        
    field tt1swd_sn         like xxwd_sn                                        
    field tt1swd_lot        like xxwd_lot                                        
    field tt1swd_ref        like xxwd_ref                                        
    field tt1swd_qty_plan   like xxwd_qty_plan  
    field tt1swd_ok         as log    
    .
define {1} shared temp-table tt2swddet
    field tt2swd_ladnbr     like xxwd_ladnbr    
    field tt2swd_nbr        like xxwd_nbr    
    field tt2swd_part       like xxwd_part                                      
    field tt2swd_site       like xxwd_site                                    
    field tt2swd_line       like xxwd_line                             
    field tt2swd_date       like xxwa_date
    field tt2swd_time       as integer
    field tt2swd_loc        like xxwd_loc                                        
    field tt2swd_sn         like xxwd_sn                                        
    field tt2swd_lot        like xxwd_lot                                        
    field tt2swd_ref        like xxwd_ref                                        
    field tt2swd_qty_plan   like xxwd_qty_plan  
    field tt2swd_ok         as log                                        
    .    

define {1} shared temp-table tt1pwddet
    field tt1pwd_ladnbr     like xxwd_ladnbr    
    field tt1pwd_nbr        like xxwd_nbr    
    field tt1pwd_part       like xxwd_part                                      
    field tt1pwd_site       like xxwd_site                                    
    field tt1pwd_line       like xxwd_line                             
    field tt1pwd_date       like xxwa_date
    field tt1pwd_time       as integer
    field tt1pwd_loc        like xxwd_loc                                        
    field tt1pwd_sn         like xxwd_sn                                        
    field tt1pwd_lot        like xxwd_lot                                        
    field tt1pwd_ref        like xxwd_ref                                        
    field tt1pwd_qty_plan   like xxwd_qty_plan  
    field tt1pwd_ok         as log
    .
define {1} shared temp-table tt2pwddet
    field tt2pwd_ladnbr     like xxwd_ladnbr    
    field tt2pwd_nbr        like xxwd_nbr    
    field tt2pwd_part       like xxwd_part                                      
    field tt2pwd_site       like xxwd_site                                    
    field tt2pwd_line       like xxwd_line                             
    field tt2pwd_date       like xxwa_date
    field tt2pwd_time       as integer
    field tt2pwd_loc        like xxwd_loc                                        
    field tt2pwd_sn         like xxwd_sn                                        
    field tt2pwd_lot        like xxwd_lot                                        
    field tt2pwd_ref        like xxwd_ref                                        
    field tt2pwd_qty_plan   like xxwd_qty_plan  
    field tt2pwd_ok         as log
    .    
define {1} shared temp-table ttmsg
    field tmsg as char format "x(40)".   
define {1} shared var thmsg as char format "x(40)".