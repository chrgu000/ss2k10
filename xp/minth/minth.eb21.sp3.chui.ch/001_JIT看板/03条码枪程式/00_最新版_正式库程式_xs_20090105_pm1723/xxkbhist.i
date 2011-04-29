/* xxkbhist.i  create history record for JIT                                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 06/20/2007   BY: Softspeed tommy xie         */


    find last xkbhhist where xkbhhist.xkbh_domain = global_domain
	 use-index xkbh_trnbr no-lock no-error.
    trnbr = (if available xkbhhist then xkbhhist.xkbh_trnbr else 0).

    create xkbh_hist.
    assign
       xkbh_hist.xkbh_domain      = global_domain
       xkbh_hist.xkbh_type        = {&type}   
       xkbh_hist.xkbh_part        = {&part}
       xkbh_hist.xkbh_site        = {&site}   
       xkbh_hist.xkbh_kb_id       = {&kb_id}
       xkbh_hist.xkbh_trnbr       = trnbr + 1
       xkbh_hist.xkbh_eff_date    = {&effdate} 
       xkbh_hist.xkbh_date        = today 
       xkbh_hist.xkbh_time        = time
       xkbh_hist.xkbh_program     = {&program}
       xkbh_hist.xkbh_userid      = global_userid
       xkbh_hist.xkbh_qty         = {&qty}
       xkbh_hist.xkbh_ori_qty     = {&ori_qty}
       xkbh_hist.xkbh_tr_trnbr    = {&tr_trnbr}
       xkbh_hist.xkbh_b_status    = {&b_status} 
       xkbh_hist.xkbh_c_status    = {&c_status} 
       xkbh_hist.xkbh_kb_rain_qty = {&rain_qty}.
