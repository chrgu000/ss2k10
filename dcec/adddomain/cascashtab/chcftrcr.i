/* GUI CONVERTED from chcftrcr.i (converter v1.71) Sun Oct 21 21:39:26 2007 */
/* chcftrcr.i - CREATE POSTED CASH FLOW TRANSACTION              -CAS    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.  */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                    */
/* REVISION: 9.2CH    LAST MODIFIED: 09/05/02 *CF* XinChao Ma            */
/* REVISION: 9.3      LAST MODIFIED: 10/11/07   BY: LinYun   ECO: *XXLY*  */
/*************************************************************************/
/*!
     {&entity}      Voucher entity 
     {&rflag}       Voucher retroactive/reversing flag
     {&ref}         Voucher reference 
     {&acc}         glt_acct
     {&sub}         glt_sub
     {&cc}          glt_cc
     {&project}     glt_project
     {&line}        glt_line
     {&currency}    glt_curr
*/

   
 

          
    for each xcft_det where xcft_entity    = {&entity}
                         and xcft_ref      = {&ref}
                         and xcft_rflag    = {&rflag}
                         and xcft_ac_code  = {&acc}
                         and xcft_sub      = {&sub}
                         and xcft_cc       = {&cc}
                         and xcft_pro      = {&project}
                         and xcft_glt_line = {&line}
                         and xcft_domain = global_domain
                         no-lock:
 find first xcf_mstr where xcf_ac_code = {&acc}   
/*XXLY*/              and (if xcf_sub <> "*" then xcf_sub = {&sub} else true)  
/*XXLY*/              and (if xcf_cc <> "*" then xcf_cc = {&cc} else true)  
/*XXLY*/              and (if xcf_pro <> "*" then xcf_pro = {&project} else true)  
                      and xcf_active = yes
                      and xcf_domain = global_domain
                          no-lock no-error.
  find first xcf1_mstr where xcf1_mfgc_ac_code = {&acc}          
/*XXLY*/              and (if xcf1_mfgc_sub <> "*" then xcf1_mfgc_sub = {&sub} else true)
/*XXLY*/              and (if xcf1_mfgc_cc <> "*" then xcf1_mfgc_cc = {&cc} else true)
/*XXLY*/              and (if xcf1_mfgc_pro <> "*" then xcf1_mfgc_pro = {&project} else true)
                      and xcf1_active = yes
                      and xcf1_domain = global_domain
                          no-lock no-error.    
/*XXLY*/   if ( (available xcf_mstr) or (available xcf1_mstr) ) then do:  
                 
         create xcftr_hist.
         assign xcftr_entity   = xcft_entity
                xcftr_ref      = xcft_ref
                xcftr_ac_code  = xcft_ac_code
                xcftr_acct     = xcft_acct
                xcftr_desc     = xcft_desc
                xcftr_sub      = xcft_sub
                xcftr_line     = xcft_line
                xcftr_amt      = xcft_amt
                xcftr_curr_amt = xcft_curr_amt
                xcftr_cc       = xcft_cc
                xcftr_pro      =xcft_pro
                xcftr_glt_line = xcft_glt_line
                xcftr_rflag    = xcft_rflag
                xcftr_domain = global_domain. 

     end. /* if available xcf_mstr */ 

  end.  /* for each xcft_det */


