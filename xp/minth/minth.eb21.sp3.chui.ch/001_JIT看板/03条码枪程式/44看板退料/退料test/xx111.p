/* .p                                                    */
/* REVISION: 9.1      LAST MODIFIED: 07/09/03   BY: xp001        */
/*-Revision end---------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */

define var part  like xmpt_part .
define var part1 like xmpt_part .
define var desc1 like pt_desc1.
define var desc2 like pt_desc2 .

define var site  like xmpt_site .
define var v_line    like pt_prod_line .
define var v_line1   like pt_prod_line.
define var v_type    like pt_part_type .
define var v_type1   like pt_part_type.
define var v_group   like pt_group .
define var v_group1  like pt_group .
define var v_stat_from like xkb_status .
define var v_stat_to   like xkb_status .
define var id_from     like xkb_kb_id .
define var id_to       like xkb_kb_id .
define var v_yn        as logical .

define var i as integer .

define var trnbr like tr_trnbr.
define buffer xkbhhist for xkbh_hist.

define buffer xkbmstr for xkb_mstr .

find icc_ctrl where icc_domain = global_domain no-lock no-error.
site = if avail icc_ctrl then icc_site else global_site .


define var v_effdate as date label "生效日期" .

define var v_sn as char format "x(25)"    .
define var v_comb1       as logical .
define var v_comb2       as logical .
define variable cumwo_lot            as character .
define var v_Start as  date .
define var v_wostat as char format "x(1)".
define var v_qty_oh like ld_qty_oh .
define var v_qty_tr like ld_qty_oh label "trqty" .
define var line as char .
define var op like ro_op .


define  frame a.

v_effdate = date(04,22,2008) .

/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
           v_sn colon 18 label "领料看板条码"
           v_effdate colon 18 
    skip (2)

with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

    

    if c-application-mode <> 'web' then  
        update v_sn v_effdate  with frame a.

	{wbrp06.i &command = update &fields = "v_sn v_effdate "  &frm = "a"}
    if (c-application-mode <> 'web') or (c-application-mode = 'web' and (c-web-request begins 'data')) then do:

        find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = site) no-lock no-error .
        if not avail xkbc_ctrl then do:
            find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = "" ) no-lock no-error .
            if not avail xkbc_ctrl then do:
                /* {pxmsg.i &MSGNUM=???? &ERRORLEVEL=3} */
                message "看板模块没有开启" view-as alert-box .
                leave .
            end.
        end.
           



	end.  /* if c-application-mode <> 'web' */

    /* PRINTER SELECTION */
    /* OUTPUT DESTINATION SELECTION */
    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = " "
                &stream = " "
                &appendToFile = " "
                &streamedOutputToTerminal = " "
                &withBatchOption = "yes"
                &displayStatementType = 1
                &withCancelMessage = "yes"
                &pageBottomMargin = 6
                &withEmail = "yes"
                &withWinprint = "yes"
                &defineVariables = "yes"}
    mainloop: 
    do on error undo, return error on endkey undo, return error:                    
        
put skip "程序名         生效日 交易类型   事务号       交易数量     累计数量" skip .
put "----------  --------- -------- ---------- ------------ ------------" skip  .

for each xkb_mstr where xkb_domain = global_domain and xkb_type + xkb_part + string(xkb_kb_id,"999") = v_sn no-lock with frame x width 300 :
    find first xmpt_mstr where xmpt_domain = global_domain and xmpt_part = xkb_part no-lock no-error .
    v_comb1 = if avail xmpt_mstr then xmpt_comb else no.
    find first xppt_mstr where xppt_domain = global_domain and xppt_part = xkb_part no-lock no-error .
    v_comb2 = if avail xppt_mstr then xppt_comb else no.
   

        find first ro_det where ro_domain = global_domain and  ro_routing = xkb_par 
                                             and ro_start <= v_effdate and (ro_end >= v_effdate or ro_end = ? ) no-lock no-error.
        if not avail ro_det then do:
                   line = "xxx" .
                   op = 10 .
        end.  /*if not avail ro_det */
        else do:  /*if  avail ro_det */
            line = ro_wkctr .
            op  = ro_op .
        end.


         v_start = ? .
         cumwo_lot = ? .
         {gprun.i ""regetwo.p""
         "(input xkb_site,
           input xkb_par,
           input v_effdate,
           input line,
           input xkb_par,
           input xkb_par,
           output cumwo_lot)"}

           if cumwo_lot = ?
            then do:

                {gprun.i ""xxrecrtwo.p""
                  "(input xkb_site,
                    input xkb_par,
                    input v_effdate,
                    input line,
                    input xkb_par,
                    input xkb_par,
                    output cumwo_lot)"}
           end.
           if cumwo_lot = ?   then   next  .
           else do:
                      for first wo_mstr
                         fields( wo_domain wo_assay wo_due_date wo_expire wo_grade wo_loc wo_lot
                                wo_lot_next wo_lot_rcpt wo_part wo_rctstat wo_status
                                wo_rctstat_active wo_rel_date wo_routing wo_site)
                          where wo_mstr.wo_domain = global_domain and  wo_lot = cumwo_lot
                      no-lock:
                      end. /* FOR FIRST wo_mstr */
                      v_wostat = wo_status .
                      v_start = wo_rel_Date .    /* xp001 */ 
           end. /* ELSE DO :  IF cumwo_lot <> ? */

            v_qty_oh = 0 .
            for each ld_det where ld_domain = global_domain and ld_site = xkb_site and ld_part = xkb_part
                 and ld_loc = line and ld_lot = xkb_lot and ld_ref = xkb_ref and ld_qty_oh > 0 no-lock :
                v_qty_oh = v_qty_oh + ld_qty_oh .
            end.

            v_qty_tr = 0 .
            for each tr_hist
                where tr_domain = global_domain 
                and tr_site = xkb_site 
                and (tr_type = "RCT-TR" or tr_type = "ISS-TR" ) 
                and tr_effdate >= v_start
                and tr_part = xkb_part  
                and tr_loc = line 
                and ( tr_rmks = xkb_par ) 
                and tr_serial = xkb_lot 
                and tr_ref = xkb_ref   no-lock:
                 v_qty_tr = v_qty_tr + tr_qty_loc .
put skip  tr_program "" tr_effdate "" tr_type "" tr_trnbr ""  tr_qty_loc "" v_qty_tr skip  .
            end.
            for each tr_hist where tr_domain = global_domain and tr_site = site and tr_type = "ISS-WO" and tr_effdate >= v_start
                and tr_part = xkb_part  and tr_loc = line and (tr_lot = cumwo_lot ) and tr_serial = xkb_lot and tr_ref = xkb_ref  
                no-lock:
                 v_qty_tr = v_qty_tr + tr_qty_loc .
put skip  tr_program "" tr_effdate "" tr_type "" tr_trnbr ""  tr_qty_loc "" v_qty_tr skip  .
                /* message  tr_type tr_trnbr tr_qty_loc v_qty_tr view-as alert-box .*/

            end.




         setFrameLabels(frame x:handle).

         disp v_sn v_comb1 v_comb2
             xkb_par 
             line op  
             cumwo_lot v_start v_wostat
             v_qty_oh  xkb_lot xkb_ref
             v_qty_tr

         with frame x .


end.


end. /* mainloop: */
{mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
