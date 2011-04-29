/* reuvup.p  - repetitive   accumulated usage variance post                   */
/* copyright 1986-2004 qad inc., carpinteria, ca, usa.                        */
/* all rights reserved worldwide.  this is an unpublished work.               */
/* $revision: 1.9.1.10 $                                                               */
/* revision: 7.3      last modified: 10/31/94   by: wug *gn77*                */
/* revision: 7.3      last modified: 11/03/94   by: wug *gn98*                */
/* revision: 7.3      last modified: 01/05/95   by: cpp *ft95*                */
/* revision: 7.3      last modified: 02/10/95   by: srk *g0ds*                */
/* revision: 7.3      last modified: 03/29/95   by: dzn *f0pn*                */
/* revision: 8.5      last modified: 05/12/95   by: pma *j04t*                */
/* revision: 8.5      last modified: 09/05/95   by: srk *j07g*                */
/* revision: 7.3      last modified: 01/10/96   by: emb *g1k9*                */
/* revision: 8.5      last modified: 05/01/96   by: jym *g1mn*                */
/* revision: 8.6      last modified: 06/11/96   by: ejh *k001*                */
/* revision: 8.5      last modified: 06/20/96   by: taf *j0vg*                */
/* revision: 8.6e     last modified: 02/23/98   by: *l007* a. rahane          */
/* revision: 8.6e     last modified: 05/20/98   by: *k1q4* alfred tan         */
/* revision: 8.6e     last modified: 10/04/98   by: *j314* alfred tan         */
/* revision: 9.1      last modified: 08/19/99   by: *n01b* john corda         */
/* revision: 9.1      last modified: 10/01/99   by: *n014* jeff wootton       */
/* revision: 9.1      last modified: 11/17/99   by: *n04h* vivek gogte        */
/* revision: 9.1      last modified: 03/24/00   by: *n08t* annasaheb rahane   */
/* revision: 9.1      last modified: 08/12/00   by: *n0kp* mark brown         */
/* revision: 9.1      last modified: 09/11/00   by: *n0rq* balbeers rajput    */
/* revision: 1.9.1.7   by: robin mccarthy        date: 10/01/01  eco: *p025*  */
/* revision: 1.9.1.8  by: vivek gogte date: 08/06/02 eco: *n1qq* */
/* $revision: 1.9.1.10 $ by: paul donnelly (sb) date: 06/28/03 eco: *q00k* */
/* ss - 100329.1  by: roger xiao */  /*取消相关表的锁定*/
/* ss - 100401.1  by: roger xiao */  /*直接抓数,不产生gl数据再undo*/
/* ss - 100524.1 by: jack */  /* first wc_mstr*/
/* SS - 100609.1  By: Roger Xiao */  /*显示生产线wo_line(而非成本中心wr_wkctr)和ln_desc说明,
                                       但是要带出成本中心的费率**找wc_mstr要(工作中心wr_wkctr+机器wr_mch) **/
/* SS - 110120.1  By: Roger Xiao */  /*取消gltw_wkfl*/
/*-revision end---------------------------------------------------------------*/


/******************************************************************************/
/* all patch markers and commented out code have been removed from the source */
/* code below. for all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  the eco marker should only be included in the revision history. */
/******************************************************************************/
/* ss - 100524.1 -by: jack */
/*v8:convertmode=report                                                       */
/*
{mfdtitle.i "2+ "}
*/

{mfdeclre.i}
{ssvdef.i " " }
/* ********** begin translatable strings definitions ********* */

&scoped-define reuvup_p_1 "consolidated!debit"
/* maxlen: comment: */

&scoped-define reuvup_p_2 "cum order cumulative variance"
/* maxlen: comment: */

&scoped-define reuvup_p_3 "consolidated!credit"
/* maxlen: comment: */

&scoped-define reuvup_p_4 "cum order variance to post"
/* maxlen: comment: */

&scoped-define reuvup_p_6 "total cumulative variance"
/* maxlen: comment: */

&scoped-define reuvup_p_7 "update"
/* maxlen: 9 comment: facilitate simulation mode printing */

&scoped-define reuvup_p_8 "total variance to post"
/* maxlen: comment: */

&scoped-define reuvup_p_9 "show zero variance to post"
/* maxlen: comment: */

&scoped-define reuvup_p_10 "show zero cumulative variance"
/* maxlen: comment: */

/* ********** end translatable strings definitions ********* */

&scoped-define simulation true
   /* preprocessor used for report's with simulation option */

   {gldydef.i new}
   {gldynrm.i new}

   {gpglefv.i}
    /* {ssvdef.i } */
/*ss - 2008.03.23 - b*/     
define input parameter i_eff_date like tr_effdate .
define input parameter i_part     like wo_part.
define input parameter i_part1    like wo_part.
define input parameter i_site     like wo_site.
define input parameter i_site1     like wo_site .
define input parameter i_line     like wo_line.
define input parameter i_line1     like wo_line .
define input parameter i_zero_unposted_var like mfc_logical .
define input parameter i_zero_cum_var like mfc_logical .
define input  parameter  i_lot  like wo_lot .
define input  parameter  i_lot1 like wo_lot .
/*ss - 2008.03.23 - e*/

/* SS - 100609.1 - B */
define var v_woline like wo_line .
define var v_mch    like wr_mch  .
/* SS - 100609.1 - E */

   define buffer womstr for wo_mstr.

define new shared workfile work_op_recids no-undo
   field work_op_recid as recid.
define new shared workfile work_gltw no-undo like gltw_wkfl.

define variable cons_dr_amt like trgl_gl_amt column-label {&reuvup_p_1}
   no-undo.
define variable cons_cr_amt like trgl_gl_amt column-label {&reuvup_p_3}
   no-undo.
  

define variable eff_date like tr_effdate.
define variable part like wo_part.
define variable part1 like wo_part label {t001.i}.
define variable site like wo_site.
define variable site1 like wo_site label {t001.i}.
define variable line like wo_line.
define variable line1 like wo_line label {t001.i}.
define variable i as integer.

define variable lot like wo_lot.
define variable lot1 like wo_lot label {t001.i}.


define variable total_cum_var_amt like glt_amt
   label {&reuvup_p_6} no-undo.
define variable total_var_to_post like glt_amt
   label {&reuvup_p_8} no-undo.
define variable update_yn like mfc_logical label {&reuvup_p_7}.
define variable wo_cum_var_amt like glt_amt
   label {&reuvup_p_2}.
define variable wo_var_to_post like glt_amt
   label {&reuvup_p_4}.

define variable zero_unposted_var like mfc_logical
   label {&reuvup_p_9} initial no no-undo.
define variable zero_cum_var like mfc_logical
   label {&reuvup_p_10} initial no no-undo.

define variable l_msg like msg_mstr.msg_desc no-undo.


define buffer b_womstr for wo_mstr .
define variable wcdesc like wc_desc .
define variable desc1  like pt_desc1 .
define variable desc2  like pt_desc2 .
define variable wclbrrate like wc_lbr_rate .
define variable wcbdnpct  like wc_bdn_pct  .
define variable wcmchbdn  like wc_mch_bdn .
define variable woqtyord like wo_qty_ord .
define variable skip_flag as  logical init no .

form
   lot                  colon 20
   lot1                 colon 45
   part                 colon 20
   part1                colon 45
   site                 colon 20
   site1                colon 45
   line                 colon 20
   line1                colon 45
   skip(1)
   zero_unposted_var    colon 32
   zero_cum_var         colon 32
   eff_date             colon 32
   update_yn            colon 32
with frame a side-labels width 80 attr-space.

/*
/* set external labels */
*/
/* the following form statement reports records with */
/* sites which have closed gl period for that entity */
form
   wo_lot
   wo_site
   msg_desc format "x(40)"
   si_entity
with frame entity-closed width 132 no-attr-space down.           
/* set external labels */
/*
setframelabels(frame entity-closed:handle).
*/
    assign eff_date = i_eff_date
           part     = i_part    
           part1    = i_part1   
           site     = i_site    
           site1    = i_site1   
           line     = i_line    
           line1    = i_line1  
           zero_unposted_var = i_zero_unposted_var
           zero_cum_var      = i_zero_cum_var 
           lot = i_lot
           lot1 = i_lot1 
           .	

            
find mfc_ctrl  where mfc_ctrl.mfc_domain = global_domain and  mfc_field =
"rpc_using_new" no-lock no-error.
if not available mfc_ctrl or mfc_logical = false then do:
   /* this module has not been enabled in control file maintenance */
   {pxmsg.i &msgnum=5119 &errorlevel=3}
   message.
   message.
   leave.
end.

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.
 /* eff_date = today. */

mainloop:
repeat:
                assign skip_flag = no  . 
   i = 0.

   if lot1 = hi_char then lot1 = "".
   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".
   if line1 = hi_char then line1 = "".
   
/*ss - 2008.03.23 - b*/    
/*
   update
      lot
      lot1
      part
      part1
      site
      site1
      line
      line1
      zero_unposted_var
      zero_cum_var
      eff_date
      update_yn
   with frame a.

   bcdparm = "".
   {mfquoter.i lot              }
   {mfquoter.i lot1             }
   {mfquoter.i part             }
   {mfquoter.i part1            }
   {mfquoter.i site             }
   {mfquoter.i site1            }
   {mfquoter.i line             }
   {mfquoter.i line1            }
   {mfquoter.i zero_unposted_var}
   {mfquoter.i zero_cum_var     }
   {mfquoter.i eff_date         }
   {mfquoter.i update_yn        }
*/
/*ss - 2008.03.23 - e*/ 

   if lot1 = "" then lot1 = hi_char.
   if part1 = "" then part1 = hi_char.
   if site1 = "" then site1 = hi_char.
   if line1 = "" then line1 = hi_char.
/*ss - 2008.03.23 - b*/ 

   /*site (range-of) security check*/
   if not batchrun then do:
      {gprun.i ""gpsirvr.p""
         "(input site, input site1, output return_int)"}
       
      if return_int = 0 then do:
         next-prompt site with frame a.
         undo mainloop, retry mainloop.
        
      end.

   end.
   
 /*   

   /* output destination selection */
   {gpselout.i &printtype = "printer"
               &printwidth = 132
               &pagedflag = " "
               &stream = " "
               &appendtofile = " "
               &streamedoutputtoterminal = " "
               &withbatchoption = "yes"
               &displaystatementtype = 1
               &withcancelmessage = "yes"
               &pagebottommargin = 6
               &withemail = "yes"
               &withwinprint = "yes"
               &definevariables = "yes"}

   {mfphead.i}
*/
/*ss - 2008.03.23 - e*/ 


/* SS - 110120.1 - B 
   for each gltw_wkfl exclusive-lock  where gltw_wkfl.gltw_domain =
   global_domain and  gltw_batch = mfguser:
      delete gltw_wkfl.
   end.
   SS - 110120.1 - E */

   total_cum_var_amt = 0.
   total_var_to_post = 0.

   /* standards shown are contained within the cumulative work order */
   {pxmsg.i &msgnum=3678 &errorlevel=1 &msgbuffer=l_msg}

   /* frame defined here so that it will print on all pages of the output */
   form
      skip(1)
      l_msg no-label
   with frame footer width 132 page-bottom.


wo-loop:
for each wo_mstr no-lock
          where wo_mstr.wo_domain = global_domain and (  wo_type = "c"
         and wo_lot >= lot and wo_lot <= lot1
         and wo_part >= part and wo_part <= part1
         and wo_site >= site and wo_site <= site1
         and wo_line >= line and wo_line <= line1
         and (wo_rel_date <= eff_date or wo_rel_date = ?)
         and (wo_due_date >= eff_date or wo_due_date = ?)
         and wo_nbr = ""
         ) use-index wo_type_part
         by wo_type by wo_site by wo_part
         by wo_line by wo_due_date by wo_lot:


        {gprun.i ""xxreuvtxp.p"" 
                "(input wo_lot, input eff_date,
                output wo_cum_var_amt, output wo_var_to_post,
                input zero_unposted_var, input zero_cum_var 
        )"}

end. /*for each wo_mstr*/



for each tt1 no-lock break by tt1_site  by tt1_peri by tt1_pare by tt1_lot by tt1_cc  :

    accumulate tt1_qty_comp ( total by tt1_site by tt1_peri by tt1_pare   by tt1_lot by tt1_cc    ) .
    accumulate tt1_qty_iss ( total by tt1_site by tt1_peri by tt1_pare  by tt1_lot by tt1_cc    ) .
    accumulate tt1_setup_std_hrs ( total by tt1_site by tt1_peri by tt1_pare  by tt1_lot by tt1_cc    ) .
    accumulate tt1_setup_act_hrs ( total by tt1_site by tt1_peri by tt1_pare  by tt1_lot  by tt1_cc    ) .
    accumulate tt1_setup_lbr_rte ( total by tt1_site by tt1_peri  by tt1_pare by tt1_lot by tt1_cc    ) .
    accumulate tt1_setup_burden_rte ( total by tt1_site by tt1_peri by tt1_pare by tt1_lot   by tt1_cc    ) .
    accumulate tt1_run_std_hrs ( total by tt1_site by tt1_peri by tt1_pare  by tt1_lot  by tt1_cc    ) .
    accumulate tt1_run_act_hrs ( total by tt1_site by tt1_peri by tt1_pare   by tt1_lot by tt1_cc    ) .
    accumulate tt1_run_lbr_rte ( total by tt1_site by tt1_peri by tt1_pare  by tt1_lot by tt1_cc    ) .
    accumulate tt1_run_burden_rte ( total by tt1_site by tt1_peri by tt1_pare by tt1_lot by tt1_cc    ) .
    accumulate tt1_price ( total by tt1_site by tt1_peri  by tt1_pare by tt1_lot by tt1_cc    ) .
    accumulate tt1_run_per_time ( total by tt1_site by tt1_peri  by tt1_pare by tt1_lot  by tt1_cc    ) .

    if last-of (tt1_cc) then do:
/* SS - 100609.1 - B */
            find first wr_route where wr_domain = global_domain and wr_lot = tt1_lot no-lock no-error .
            v_mch = if avail wr_route then wr_mch else "" .
/* SS - 100609.1 - E */

            find pt_mstr where pt_domain = global_domain 
                 and pt_part = tt1_pare 
                 no-lock no-error .
            if available pt_mstr then assign desc1 = pt_desc1 desc2 = pt_desc2 .
         /* ss 100524.1 -b
            find wc_mstr where wc_domain = global_domain  
                 and wc_wkctr = tt1_cc 
                 no-lock no-error .	  
                 ss - 100524.1 -e */
            /* ss - 10024.1 -b */
             FIND FIRST wc_mstr where wc_domain = global_domain  
                 and wc_wkctr = tt1_cc 
                 no-lock no-error .	  
            /* ss - 100524.1 -e */
            if available wc_mstr  then assign wcdesc = wc_desc  
                        wclbrrate = wc_lbr_rate
                        wcbdnpct = wc_bdn_pct 
                        wcmchbdn = wc_mch_bdn
                        .
/* SS - 100609.1 - B */
            find first wc_mstr 
                where wc_domain = global_domain  
                and   wc_wkctr  = tt1_cc 
                and   wc_mch    = v_mch 
            no-lock no-error .	  
            if available wc_mstr then 
            assign  wcdesc = wc_desc  
                    wclbrrate = wc_lbr_rate
                    wcbdnpct = wc_bdn_pct 
                    wcmchbdn = wc_mch_bdn
                    .
/* SS - 100609.1 - E */

            for first  b_womstr where b_womstr.wo_domain = global_domain
                     and b_womstr.wo_lot = tt1_lot
                     and b_womstr.wo_type = 'c'  no-lock :
                assign woqtyord = b_womstr.wo_qty_ord  .
/* SS - 100609.1 - B */
                    v_woline = b_womstr.wo_line.
                    find first ln_mstr 
                        where ln_domain = global_domain  
                        and ln_site = b_womstr.wo_site
                        and ln_line = v_woline 
                    no-lock no-error .
                    if avail ln_mstr then wcdesc = ln_desc .
/* SS - 100609.1 - E */
            end .      
            put  unformatted  
                tt1_peri  ";"
                tt1_pare       ";" 
                tt1_lot  ";"
                desc1 ";"
                desc2 ";"
/* SS - 100609.1 - B 
                tt1_cc   " "
   SS - 100609.1 - E */
/* SS - 100609.1 - B */
                v_woline  " "
/* SS - 100609.1 - E */

                wcdesc  ";"
                wclbrrate ";"
                wcbdnpct  / 100   ";"
                wcmchbdn   ";"
                accumulate total by tt1_cc tt1_qty_comp  ";"
                woqtyord   ";"
                tt1_setup_per_time  ";"
                tt1_setup_std_hrs   ";"
                tt1_setup_act_hrs   ";"
                tt1_setup_std_hrs  -  tt1_setup_act_hrs  ";"
                ( accumulate total by tt1_cc tt1_setup_lbr_rte )   ";"
                ( accumulate total by tt1_cc tt1_setup_burden_rte  ) ";"
                ( accumulate total by tt1_cc tt1_run_per_time )    ";"
                ( accumulate total by tt1_cc tt1_run_std_hrs )    ";"
                ( accumulate total by tt1_cc tt1_run_act_hrs )    ";"
                (( accumulate total by tt1_cc tt1_run_std_hrs )   -  ( accumulate total by tt1_cc tt1_run_act_hrs  ))   ";"
                ( accumulate total by tt1_cc tt1_run_lbr_rte )     ";"
                ( accumulate total by tt1_cc tt1_run_burden_rte )   ";"
                (accumulate total by tt1_cc tt1_qty_iss)   ";"  
                accumulate total by tt1_cc tt1_price ";"
                ( accumulate total by tt1_cc tt1_price )  *  ( accumulate total by tt1_cc tt1_qty_iss ) 
            skip
            .
    end .  
end. /*for each tt1*/

EMPTY TEMP-TABLE tt1.

leave .
end . /*mainloop*/

