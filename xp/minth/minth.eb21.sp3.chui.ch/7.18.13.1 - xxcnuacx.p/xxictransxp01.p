/* ictrans.p - Creates TR_HIST transaction using ictrans.i                   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.5 $                                         */

/*****************************************************************************/
/* DESCRIPTION:  This program accepts input parameters for all of the        */
/*               symbolic fields used in ictrans.i to create a transaction   */
/*               history record. See ICTRANS.I for specifics on what values  */
/*               to pass in.                                                 */
/*****************************************************************************/

/* Revision: 1.3  BY: Ellen Borden DATE: 04/04/02 ECO: *P00F* */
/* $Revision: 1.5 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00G* */
/*-Revision end---------------------------------------------------------------*/


/*V8:ConvertMode=NoConvert                                                   */

/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */







/*************************************************************以下为版本历史 */  
/* SS - 090401.1  By: Roger Xiao */

/*************************************************************以下为发版说明 */

/* SS - 090401.1 - RNB
1.原程式库存记录锁定时间太长,原因查找abs_mstr时未加domain,太慢, 仅修改xxsocncixx.p
xxcnuacx.p --> xxsocnuac2x.p --> xxsocnisx.p --> xxsocncixx.p
2.取消锁定库存记录:原xxsocnisx.p直接调用ictrans.i,现改为: xxsocnisx.p  --> xxictransxp01.p --> xxictransxp01.i
  并release ld_det & in_mstr 
  注意: &slspsn3 &slspsn4 &trordrev 在xxictransxp01.i与ictrans.i使用方式不同

SS - 090401.1 - RNE */













{mfdeclre.i}

define input  parameter ip_addr             like tr_addr        no-undo.
define input  parameter ip_bdn_std          like tr_bdn_std     no-undo.
define input  parameter ip_cr_acct          like trgl_cr_acct   no-undo.
define input  parameter ip_cr_sub           like trgl_cr_sub    no-undo.
define input  parameter ip_cr_cc            like trgl_cr_cc     no-undo.
define input  parameter ip_cr_proj          like trgl_cr_proj   no-undo.
define input  parameter ip_curr             like tr_curr        no-undo.
define input  parameter ip_dr_acct          like trgl_dr_acct   no-undo.
define input  parameter ip_dr_sub           like trgl_dr_sub    no-undo.
define input  parameter ip_dr_cc            like trgl_dr_cc     no-undo.
define input  parameter ip_dr_proj          like trgl_dr_proj   no-undo.
define input  parameter eff_date            like glt_effdate    no-undo.
define input  parameter ip_ex_rate          like tr_ex_rate     no-undo.
define input  parameter ip_ex_rate2         like tr_ex_rate2    no-undo.
define input  parameter ip_ex_ratetype      like tr_ex_ratetype no-undo.
define input  parameter ip_exru_seq         like tr_exru_seq    no-undo.
define input  parameter ip_gl_amt           like tr_gl_amt      no-undo.
define input  parameter ip_lbr_std          like tr_lbr_std     no-undo.
define input  parameter ip_location         like tr_loc         no-undo.
define input  parameter ip_trlot            like tr_lot         no-undo.
define input  parameter ip_lotref           like tr_ref         no-undo.
define input  parameter ip_lotser           like tr_serial      no-undo.
define input  parameter ip_mtl_std          like tr_mtl_std     no-undo.
define input  parameter ip_ordernbr         like tr_nbr         no-undo.
define input  parameter ip_orderline        like tr_line        no-undo.
define input  parameter ip_ovh_std          like tr_ovh_std     no-undo.
define input  parameter ip_part             like tr_part        no-undo.
define input  parameter ip_perf_date        like tr_per_date    no-undo.
define input  parameter ip_price            like tr_price       no-undo.
define input  parameter ip_required_qty     like sr_qty         no-undo.
define input  parameter ip_backorder_qty    like sr_qty         no-undo.
define input  parameter ip_transaction_qty  like sr_qty         no-undo.
define input  parameter ip_rev              like tr_rev         no-undo.
define input  parameter ip_rmks             like tr_rmks        no-undo.
define input  parameter ip_ship_type        like tr_ship_type   no-undo.
define input  parameter ip_site             like tr_site        no-undo.
define input  parameter ip_salesperson1     like tr_xslspsn1    no-undo.
define input  parameter ip_salesperson2     like tr_xslspsn2    no-undo.
define input  parameter ip_so_job           like tr_so_job      no-undo.
define input  parameter ip_sub_std          like tr_sub_std     no-undo.
define input  parameter ip_transtype        like tr_type        no-undo.
define input  parameter ip_msg              like tr_msg         no-undo.
define input  parameter ip_ref_site         like tr_site        no-undo.


/* SS - 090401.1 - B */
define input  parameter ip_invmov           like tr_ship_inv_mov    no-undo. 
define input  parameter ip_shipdate         like tr_ship_date       no-undo. 
define input  parameter ip_shipnbr          like tr_ship_id         no-undo. 
define input  parameter ip_slspsn3          like tr_slspsn[3]       no-undo. 
define input  parameter ip_slspsn4          like tr_slspsn[4]       no-undo. 
define input  parameter ip_tempid           like tr_trnbr           no-undo. 
define input  parameter ip_trordrev         like tr_ord_rev         no-undo. 
define input  parameter ip_sctrecno         as recid initial ?      no-undo. 
define output parameter op_trglrecno        as recid initial ?      no-undo. 
define output parameter op_trrecno          as recid initial ?      no-undo. 

recno = ip_sctrecno .
/* SS - 090401.1 - E */


define output parameter op_tr_trnbr         like tr_trnbr       no-undo.

define        variable  gl_tmp_amt          as   decimal no-undo.
define        variable  ref                 like glt_ref no-undo.
define        variable  transaction_qty     as decimal  no-undo.

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.


{xxictransxp01.i
   &addrid         = ip_addr
   &bdnstd         = ip_bdn_std
   &cracct         = ip_cr_acct
   &crsub          = ip_cr_sub
   &crcc           = ip_cr_cc
   &crproj         = ip_cr_proj
   &curr           = ip_curr
   &dracct         = ip_dr_acct
   &drsub          = ip_dr_sub
   &drcc           = ip_dr_cc
   &drproj         = ip_dr_proj
   &effdate        = eff_date
   &exrate         = ip_ex_rate
   &exrate2        = ip_ex_rate2
   &exratetype     = ip_ex_ratetype
   &exruseq        = ip_exru_seq
   &glamt          = ip_gl_amt
   &lbrstd         = ip_lbr_std
   &location       = ip_location
   &lotnumber      = ip_trlot
   &lotref         = ip_lotref
   &lotserial      = ip_lotser
   &mtlstd         = ip_mtl_std
   &ordernbr       = ip_ordernbr
   &line           = ip_orderline
   &ovhstd         = ip_ovh_std
   &part           = ip_part
   &perfdate       = ip_perf_date
   &price          = ip_price
   &quantityreq    = ip_required_qty
   &quantityshort  = ip_backorder_qty
   &quantity       = ip_transaction_qty
   &revision       = ip_rev
   &rmks           = ip_rmks
   &shiptype       = ip_ship_type
   &site           = ip_site
   &slspsn1        = ip_salesperson1
   &slspsn2        = ip_salesperson2
   &sojob          = ip_so_job
   &substd         = ip_sub_std
   &transtype      = ip_transtype
   &msg            = ip_msg
   &ref_site       = ip_ref_site

/* SS - 090401.1 - B */
   &invmov         = ip_invmov     
   &shipdate       = ip_shipdate   
   &shipnbr        = ip_shipnbr    
   &slspsn3        = ip_slspsn3    
   &slspsn4        = ip_slspsn4    
   &tempid         = ip_tempid     
   &trordrev       = ip_trordrev   
/* SS - 090401.1 - E */
                    
   }             
   
/* SS - 090401.1 - B */
   op_trglrecno = recid(trgl_det) .  
   op_trrecno   = recid(tr_hist ) .  
/* SS - 090401.1 - E */
                           
   op_tr_trnbr = tr_trnbr.  
