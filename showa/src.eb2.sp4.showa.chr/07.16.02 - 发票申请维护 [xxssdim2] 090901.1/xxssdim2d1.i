/* 以下为版本历史 */                                                             
/* SS - 090819.1 By: Bill Jiang */

/* 显示 */

assign
   nbr_rqm	       = rqm_nbr      
   site_rqm = rqm_site
   vend_rqm          = rqm_vend       
   rqby_userid_rqm   = rqm_rqby_userid       
   req_date_rqm      = rqm_req_date    
   log01__rqm        = rqm__log01
   .

sel_total = 0.                                                  
FOR EACH rqd_det NO-LOCK
   WHERE rqd_nbr = rqm_nbr
   :
   sel_total = sel_total + rqd_req_qty * rqd_pur_cost.
END.

display 
   nbr_rqm	      
   site_rqm
   vend_rqm        
   rqby_userid_rqm    
   req_date_rqm  
   log01__rqm
   auto_select
   sel_total
   with frame a.
