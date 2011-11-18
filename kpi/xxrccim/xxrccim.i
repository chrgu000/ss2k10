/* 定义临时表存放数据  */

define {1} shared variable file_name as character format "x(50)".

define {1} shared temp-table  xsch_mstr
		fields xsch_shipfrom like   scx_shipfrom     
    fields xsch_shipto   like   scx_shipto     
    fields xsch_part     like   scx_part      
    fields xsch_po       like   scx_po
    fields xsch_custref  like   scx_custref
    fields xsch_modelyr  like   scx_modelyr
    fields xsch_order	   like   scx_order
    fields xsch_line	   like   scx_line
    fields xsch_rlseid   like   sch_rlse_id
    fields xsch_cmmt     as     logical 
    fields xsch_sdpat    like   sch_sd_pat
    fields xsch_sdtime	 like   sch_sd_time
    fields xsch_prpint   like   sch_prp_int
    fields xsch_prpext   like   sch_prp_ext
    fields xsch_pcrqty   like   sch_pcr_qty
    fields xsch_pcsdate  like   sch_pcs_date
    fields xsch_cum	     like   sch_cumulative
    fields xsch_sddates  like   sch_sd_dates
    fields xsch_effstart like   sch_eff_start
    fields xsch_effend   like   sch_eff_end
    fields xsch_lrasn    as     character format "x(24)"
    fields xsch_lrdate   as     date
    fields xsch_lrtime	 as     character
    fields xsch_lrqty 	 as     decimal format ">>>,>>>,>>9.9<<<<<<<<"
    fields xsch_lrcum    as     decimal format ">>>,>>>,>>9.9<<<<<<<<"
    fields xsch_date     like   schd_date
    fields xsch_time     like   schd_time
    fields xsch_interval like   schd_interval
    fields xsch_ref      like   schd_reference
    fields xsch_updqty   like   schd_upd_qty
    fields xsch_fcqual   like   schd_fc_qual
    fields xsch_cmmts    as     logical   
    fields xsch_rqmts    as     logical
    fields xsch_error    like   mph_rsult
    .
    
define {1} shared temp-table xschd_det
		fields xschd_order  like scx_order    
	  fields xschd_line	  like scx_line
    fields xschd_rlseid like sch_rlse_id
    fields xschd_date     like   schd_date
    fields xschd_time     like   schd_time
    fields xschd_interval like   schd_interval
    fields xschd_ref      like   schd_reference
    fields xschd_updqty   like   schd_upd_qty
    fields xschd_fcqual   like   schd_fc_qual
    index xschd_order_line_id is primary xschd_order xschd_line xschd_rlseid.

