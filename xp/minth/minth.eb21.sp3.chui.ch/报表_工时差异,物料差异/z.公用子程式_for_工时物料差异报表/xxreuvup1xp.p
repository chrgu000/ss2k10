/* reuvup.p  - REPETITIVE   ACCUMULATED USAGE VARIANCE POST                   */
/* SS - 100401.1  By: Roger Xiao */  
/* SS - 100609.1  By: Roger Xiao */  /*xxreuvup1xp.p: 显示生产线wo_line和ln_desc说明*/
/* SS - 110120.1  By: Roger Xiao */  /*取消gltw_wkfl*/
/*-Revision end---------------------------------------------------------------*/

/*
{mfdtitle.i "2+ "}
*/

{mfdeclre.i}
{ssvdef1.i " " }

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE reuvup_p_1 "Consolidated!Debit"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvup_p_2 "Cum Order Cumulative Variance"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvup_p_3 "Consolidated!Credit"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvup_p_4 "Cum Order Variance To Post"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvup_p_6 "Total Cumulative Variance"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvup_p_7 "Update"
/* MaxLen: 9 Comment: FACILITATE SIMULATION MODE PRINTING */

&SCOPED-DEFINE reuvup_p_8 "Total Variance To Post"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvup_p_9 "Show Zero Variance to Post"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvup_p_10 "Show Zero Cumulative Variance"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

&SCOPED-DEFINE simulation true
   /* PREPROCESSOR USED FOR REPORT'S WITH SIMULATION OPTION */

   {gldydef.i new}
   {gldynrm.i new}

   {gpglefv.i}
    /* {ssvdef.i } */
/*ss - 2008.03.23 - B*/     
define INPUT  PARAMETER  i_eff_date LIKE  tr_effdate .
define INPUT  PARAMETER  i_part     LIKE  wo_part.
define INPUT  PARAMETER  i_part1    LIKE  wo_part.
define INPUT  PARAMETER  i_site     LIKE  wo_site.
define INPUT  PARAMETER  i_site1    LIKE  wo_site .
define INPUT  PARAMETER  i_line     LIKE  wo_line.
define INPUT  PARAMETER  i_line1    LIKE  wo_line .
define INPUT  PARAMETER  i_zero_unposted_var LIKE  mfc_logical .
define INPUT  PARAMETER  i_zero_cum_var      LIKE  mfc_logical . 
DEFINE INPUT  PARAMETER  i_lot  LIKE wo_lot .
DEFINE INPUT  PARAMETER  i_lot1 LIKE wo_lot .
/*ss - 2008.03.23 - E*/
   define buffer womstr for wo_mstr.

define new shared workfile work_op_recids no-undo
   field work_op_recid as recid.
define new shared workfile work_gltw no-undo like gltw_wkfl.

define variable cons_dr_amt like trgl_gl_amt column-label {&reuvup_p_1}
   no-undo.
define variable cons_cr_amt like trgl_gl_amt column-label {&reuvup_p_3}
   NO-UNDO.
  

define variable eff_date like tr_effdate.
define variable part like wo_part.
define variable part1 like wo_part label {t001.i}.
define variable site like wo_site.
define variable site1 like wo_site label {t001.i}.
define variable line like wo_line.
define variable line1 like wo_line label {t001.i}.
DEFINE variable i as integer.

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
DEFINE variable zero_unposted_var like mfc_logical
   label {&reuvup_p_9} initial no no-undo.
define variable zero_cum_var like mfc_logical
   label {&reuvup_p_10} initial no no-undo.
  
define variable l_msg like msg_mstr.msg_desc NO-UNDO.


DEFINE BUFFER b_womstr FOR wo_mstr .
DEFINE VARIABLE wcdesc LIKE wc_desc .
DEFINE VARIABLE desc1  LIKE pt_desc1 .
DEFINE VARIABLE desc2  LIKE pt_desc2 .
DEFINE VARIABLE desc3  LIKE pt_desc1 .
DEFINE VARIABLE desc4  LIKE pt_desc2 .
DEFINE VARIABLE skip_flag AS  LOGICAL INIT NO .

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


form
   wo_lot
   wo_site
   msg_desc format "x(40)"
   si_entity
with frame entity-closed width 132 no-attr-space down.           

    ASSIGN eff_date = i_eff_date
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
   /* THIS MODULE HAS NOT BEEN ENABLED IN CONTROL FILE MAINTENANCE */
   {pxmsg.i &MSGNUM=5119 &ERRORLEVEL=3}
   message.
   message.
   leave.
end.

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.
/* eff_date = today. */

mainloop:
repeat:
  ASSIGN skip_flag = NO  . 
   i = 0.

   if lot1 = hi_char then lot1 = "".
   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".
   if line1 = hi_char then line1 = "".
   


   if lot1 = "" then lot1 = hi_char.
   if part1 = "" then part1 = hi_char.
   if site1 = "" then site1 = hi_char.
   if line1 = "" then line1 = hi_char.

   /*SITE (RANGE-OF) SECURITY CHECK*/
   if not batchrun then do:
      {gprun.i ""gpsirvr.p""
         "(input site, input site1, output return_int)"}
       
      if return_int = 0 then do:
         next-prompt site with frame a.
         undo mainloop, retry mainloop.
        
      end.

   END.
   

/* SS - 110120.1 - B 
   for each gltw_wkfl exclusive-lock  where gltw_wkfl.gltw_domain =
   global_domain and  gltw_batch = mfguser:
      delete gltw_wkfl.
   end.
   SS - 110120.1 - E */

   total_cum_var_amt = 0.
   total_var_to_post = 0.

   /* STANDARDS SHOWN ARE CONTAINED WITHIN THE CUMULATIVE WORK ORDER */
   {pxmsg.i &MSGNUM=3678 &ERRORLEVEL=1 &MSGBUFFER=l_msg}

   /* FRAME DEFINED HERE SO THAT IT WILL PRINT ON ALL PAGES OF THE OUTPUT */
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


        /*find womstr where recid(womstr) = recid(wo_mstr) no-lock no-error .   
         
        {gprun.i ""xxreuvtxp.p"" 
        "(input wo_lot, input eff_date,
          output wo_cum_var_amt, output wo_var_to_post,
          input zero_unposted_var, input zero_cum_var 
        )"}
        **/
              
        define var qty_per like wod_bom_qty .
        

        for each wr_route no-lock
                where wr_route.wr_domain = global_domain 
                and  wr_lot = wo_lot,
            each wod_det no-lock
                where wod_det.wod_domain = global_domain 
                and  wod_lot = wr_lot
                and wod_op = wr_op
        break by wod_lot by wod_op by wod_part with frame f_a down:


                find qad_wkfl 
                   where qad_wkfl.qad_domain = global_domain 
                   and  qad_key1 = "MFWORLA"
                   and qad_key2 = wod_lot + wod_part + string(wod_op) 
                no-lock no-error.

                qty_per = 0.
                if available qad_wkfl and qad_charfld[1] = "s" then qty_per = wod_bom_qty.

              
                    CREATE tt1 .
                    ASSIGN tt1_site = wo_site 
                           tt1_peri = STRING(YEAR(wo_rel_date),'9999') + "/" + STRING(MONTH(wo_rel_date),'99')
                           tt1_pare = wo_part 
                           tt1_comp = wod_part
                           tt1_cc = wo_line
                           tt1_qty_iss = wod_qty_iss 
                           tt1_qty_comp = wr_qty_cumproc
                           tt1_price = wod_bom_amt
                           tt1_qty_per = qty_per 
                           tt1_lot  = wo_lot
                           .       
        end.
         
end. /*for each wo_mstr*/
   
        assign skip_flag = no  . 
        for each tt1 no-lock break by tt1_site  by  tt1_peri  by  tt1_cc by  tt1_pare  by tt1_lot  by  tt1_com :

            accumulate tt1_qty_comp ( total by tt1_site  by  tt1_peri  by  tt1_cc by  tt1_pare by tt1_lot    by  tt1_com   ) .
            accumulate tt1_qty_iss ( total by tt1_site  by  tt1_peri  by  tt1_cc by  tt1_pare   by tt1_lot  by  tt1_com    ) .

            if last-of (tt1_com) then do:

                    find pt_mstr where pt_domain = global_domain 
                    and pt_part = tt1_pare 
                    no-lock no-error .
                    if available pt_mstr then assign desc1 = pt_desc1 desc2 = pt_desc2 .

                    find pt_mstr where pt_domain = global_domain 
                    and pt_part = tt1_comp
                    no-lock no-error .
                    if available pt_mstr then assign desc3 = pt_desc1 desc4 = pt_desc2 .

/* SS - 100609.1 - B 
                    find wc_mstr where wc_domain = global_domain  
                    and wc_wkctr = tt1_cc 
                    no-lock no-error .	  
                    if available wc_mstr then assign wcdesc = wc_desc .
   SS - 100609.1 - E */
/* SS - 100609.1 - B */
                    find first ln_mstr 
                        where ln_domain = global_domain  
                        and ln_site = tt1_site
                        and ln_line = tt1_cc 
                    no-lock no-error .
                    if avail ln_mstr then wcdesc = ln_desc .
/* SS - 100609.1 - E */


                    put  unformatted  
                        tt1_peri  ";"
                        tt1_cc   " "
                        wcdesc  ";"               	
                        tt1_pare       ";" 
                        tt1_lot  ";" 
                        desc1 ";"
                        desc2 ";"
                        accumulate total by tt1_com tt1_qty_comp ';'
                        tt1_comp    ";" 
                        desc3 ";"
                        desc4 ";"
                        tt1_qty_per   ";"
                        ( accumulate total by tt1_com tt1_qty_comp ) *  tt1_qty_per  ";"
                        accumulate total by tt1_com tt1_qty_iss  ";"
                        ( accumulate total by tt1_com tt1_qty_iss )  - ( accumulate total by tt1_com tt1_qty_comp ) *  tt1_qty_per   ";"
                        tt1_price ';'
                        tt1_price * (( accumulate total by tt1_com tt1_qty_iss )  - ( accumulate total by tt1_com tt1_qty_comp ) *  tt1_qty_per )                   
                    skip
                    .

            end .  

        end.   /*for each tt1*/    
        for each tt1: 
            delete tt1 .
        end.   /*for each tt1*/    


leave .

end .  /*mainloop*/


