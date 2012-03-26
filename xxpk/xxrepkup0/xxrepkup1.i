/* �����Ϣ�� */
define {1} shared temp-table tsupp
    field tsu_loc     like loc_loc
    field tsu_part    like pt_part
    field tsu_lot     like ld_lot
    field tsu_ref     like ld_ref
    field tsu_qty     like ld_qty_oh            
    field tsu_flg     like loc_user2            /* ���ϱ�־��*/               
    field tsu_abc     like pt__chr10            /* A B C�ࡡ*/                
    field tsu_lpacks  like ld_qty_oh            /* �����ζ��ٸ���װ */        
    field tsu_ltrail  like ld_qty_oh            /* �����ΰ�װβ�� */          
    field tsu_bpacks  like ld_qty_oh            /* �����ζ��ٸ����� */        
    field tsu_btrail  like ld_qty_oh            /* ����������β�� */          
    field tsu_lit     like ld_qty_oh            /* ��װ���� */                
    field tsu_big     like ld_qty_oh            /* �������� */                
    .
    
/* ����������� */    
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
   �������� pt__qad20   
   ��С��װ pt__qad19
   pt__chr10  A/B/C��  
   A�� ����ȡ ���ϰ���װ����
   B�� ����ȡ ����
   C�� ��С��װȡ ��С��װ��
   loc_user2 �ɱ��ϱ�־
 */

/* ���϶��б� */
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
    
/* ȡ�϶��б� */    
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
