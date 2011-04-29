/* xxkbrp008.p  厂内CKD库存管制表                                                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                               */
/* All rights reserved worldwide.  This is an unpublished work.                      */
/*V8:ConvertMode=NoConvert                                                           */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao   /*xp001*/ */
/*-Revision end------------------------------------------------------------          */



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */

define var part  like xmpt_part .
define var part1 like xmpt_part .
define var loc  like ld_loc .
define var loc1 like ld_loc .
define var desc1 like pt_desc1.
define var desc2 like pt_desc2 .
define var um    like pt_um .
define var v_abc like pt_abc .
define var v_ord_per like pt_ord_per .

define var site  like xmpt_site .
define var v_buyer    like ptp_buyer   label  "计划员" .

define var v_vd as integer format "9" label "采购属性" initial 3 .
define var v_vd_type as char label "采购属性"  .

define var v_vend       like po_vend .
define var v_qty_ord    like ld_qty_oh .
define var v_qty_rct    like prh_rcvd .
define var v_qty_onway  like prh_rcvd .



define var v_qty_oh     like ld_qty_oh label "现有库存".
define var v_qty_oh2    like ld_qty_oh label "折合成品库存".
define var v_qty_req    like ld_qty_oh label "次月成品需求".
define var v_qty_saf    like ld_qty_oh label "安全库存".
define var v_qty_err    like ld_qty_oh label "需求差异量" .


define var  eff_date as date . eff_Date = today .
define var  parent like ps_par no-undo.
define var  level as integer no-undo.
define var  record as integer extent 500.
define var  recno_to as recid . 
define var  qty as decimal initial 1 no-undo.
define var  save_qty as decimal extent 100 no-undo.

define temp-table tmpbom
    field tmp_part    like xkb_part   label "零件号"
    field tmp_par    like ps_par      label "父件号"
    field tmp_qty_per like ps_qty_per label "单耗量"
    .


define temp-table onway
    field t_part      like xkb_part   label "零件号"
    field t_vend      like po_vend     
    field t_qty_onway like tr_qty_loc .

define temp-table ttsch
    field tt_part      like xkb_part   label "零件号"
    field tt_vend      like po_vend 
    field tt_nbr       like pod_nbr 
    field tt_line      like pod_line 
    field tt_date      as date
    field tt_qty       like tr_qty_loc .


find icc_ctrl where icc_domain = global_domain no-lock no-error.
site = if avail icc_ctrl then icc_site else global_site .


/* DISPLAY SELECTION FORM */
define  frame a.
form

    SKIP(.2)
    site                      colon 18      
    loc                       colon 18
    loc1                      colon 45   label  {t001.i} 
    part                      colon 18
    part1                     colon 45   label  {t001.i} 
    v_buyer                   colon 18   label  "计划员"


    skip(1)

    v_vd                              colon 18 
    "(1-国产件 2-进口件 3-所有)"       
    skip(1)

    
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    if part1 = part       then part1 = "".
    if loc1 = loc         then loc1 = "".
/*     if rel1 = hi_date then rel1 = ? . */
/*     if rel  = low_date then rel = ? . */
    
    if c-application-mode <> 'web' then  
        update site loc loc1 part part1 v_buyer v_vd with frame a.

	{wbrp06.i &command = update &fields = " site loc loc1 part part1  v_buyer v_vd "  &frm = "a"}
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
    

        bcdparm = "".
        {mfquoter.i site     }
        {mfquoter.i v_buyer     }  
        {mfquoter.i loc       }
        {mfquoter.i loc1     }
        {mfquoter.i part     }
        {mfquoter.i part1    }
        {mfquoter.i v_vd     }
/*         {mfquoter.i rel      } */
/*         {mfquoter.i rel1     } */

/*         if rel <> low_date and rel1 = ? then rel1 = rel . */
/*         if rel = ?        then rel = low_date .           */
/*         if rel1 = ?       then rel1 = hi_date.            */
        if loc1 = ""      then loc1 = loc .
        if part1 = ""     then part1 = part.


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

/*{mfphead.i}   put skip "test start: " string(time,"hh:mm:ss")skip . */


for each tmpbom:
    delete tmpbom .
end.

PUT UNFORMATTED "#def REPORTPATH=$/Minth/xxkbrp008" SKIP.
PUT UNFORMATTED "#def :end" SKIP.

for each ld_det where ld_domain = global_domain and ld_site = site 
                and ld_loc >= loc   and (ld_loc <= loc1 or loc1 = "" )
                and ld_part >= part and (ld_part <= part1 or part1 = "" ) 
                and ld_qty_oh > 0 
                and (can-find(first ptp_det where ptp_domain = global_domain and ptp_site = site 
                              and ptp_part = ld_part and ( ptp_pm_code = "p" or ptp_pm_code = "" ) 
                              and (ptp_buyer = v_buyer  or v_buyer = "") )
                      or
                    ((not can-find(first ptp_det where ptp_domain = global_domain and ptp_site = site 
                                   and ptp_part = ld_part and ( ptp_pm_code = "p" or ptp_pm_code = "" )  
                                   and (ptp_buyer = v_buyer or v_buyer = "" )))
                      and can-find(first pt_mstr where pt_domain = global_domain  and pt_part = ld_part 
                                   and ( pt_pm_code = "p" or pt_pm_code = "" )
                                   and (pt_buyer = v_buyer or v_buyer = "" ))) )
                no-lock break by ld_part with frame x  with width 300 :

    v_vd_type = (if v_vd = 1 then "01" else if v_vd = 2 then "02" else "" ) .
    find first xppt_mstr where xppt_domain = global_domain and xppt_part = ld_part and xppt_type = v_vd_type  no-lock no-error .
    if avail xppt_mstr then do:
        /* find first code_mstr where code_domain = global_domain and code_fldname = 'xppt_type' and code_value = v_vd_type no-lock no-error . */
        /* v_vd_type = if avail code_mstr then code_cmmt else "" .                                                                             */
    end.
    else do:
         if v_vd = 1 or v_vd = 2 then next .
    end.

    if first-of(ld_part) then do:

/* ********* part 1 ****** */
        v_qty_oh  = 0 . 

/* ********* part 2 ****** */
        qty = 1 .
        level = 1. 
        parent = ld_part.
        find first ps_mstr use-index ps_comp where  ps_mstr.ps_domain = global_domain and  ps_comp = parent no-lock no-error .
        repeat:  /*repeat: bom */       
           if not avail ps_mstr then do:                        
                 repeat:  
                    level = level - 1.
                    if level < 1 then leave .                    
                    find ps_mstr where recid(ps_mstr) = record[level] no-lock no-error.
                    parent = ps_comp .      
                    qty = save_qty[level].
                    find next ps_mstr use-index ps_comp where  ps_mstr.ps_domain = global_domain and  ps_comp = parent no-lock no-error.
                    if avail ps_mstr then leave .               
                end.
            end.  /*if not avail ps_mstr*/
        
            if level < 1 then leave .
            record[level] = recid(ps_mstr).
         
            if (ps_end = ? or eff_date <= ps_end) then do :
                   save_qty[level] = qty.
                   qty = qty * ps_qty_per * (100 / (100 - ps_scrp_pct)).
            
                   parent = ps_par .
                   level = level + 1.
                   recno_to =  recid(ps_mstr). 
        
                   find first ps_mstr use-index ps_comp where  ps_mstr.ps_domain = global_domain and ps_comp = parent no-lock no-error.
                   if not avail ps_mstr then do:
                      find ps_mstr where recid(ps_mstr) = recno_to no-lock no-error.
                      find first tmpbom where tmp_part = ld_part and tmp_par = ps_par exclusive-lock no-error .
                      if not avail tmpbom then do:
                          create tmpbom.
                          assign tmp_part = caps(ld_part)
                                 tmp_par = ps_par
                                 tmp_qty_per = qty .                              
                      end.
                      else do:
                                 tmp_qty_per = tmp_qty_per + qty .
                      end.                                   
                   end.
        
        
                   find first ps_mstr use-index ps_comp where  ps_mstr.ps_domain = global_domain and ps_comp = parent no-lock no-error.
            end.   /*if (ps_end = ? or eff_date <= ps_end)*/
            else do:
                   find next ps_mstr use-index ps_comp where  ps_mstr.ps_domain = global_domain and ps_comp = parent no-lock no-error.
            end.  /* not (ps_end = ? or eff_date <= ps_end)  */    
        end. /*repeat: bom */


        v_vend = "" .
        v_qty_onway = 0 .
        for each pod_Det where pod_domain = global_domain 
                    and pod_part = ld_part 
                    and pod_stat = "" no-lock,
            each po_mstr where po_domain  = global_domain and po_nbr = pod_nbr  no-lock,
            each schd_Det no-lock where schd_det.schd_domain = global_domain and  schd_type = 4
                    and schd_nbr = pod_nbr and schd_line = pod_line
                    and schd_rlse_id =  pod_curr_rlse_id[1],
            each sch_mstr no-lock where sch_mstr.sch_domain =  global_domain and  sch_type = 4 
                    and sch_nbr = pod_nbr and sch_line = pod_line 
                    and sch_rlse_id = pod_curr_rlse_id[1] 
            break  by pod_part by po_vend by pod_nbr by pod_line :
        
            if first-of(po_vend) then do:
               v_qty_ord = 0 . 
               v_qty_rct = 0 .
               v_qty_onway = 0 .
               v_vend = po_vend .
            end.              
        
            v_Qty_ord = v_Qty_ord + schd_discr_qty 
                                    /* ???? (if sch_cumulative then schd_cum_qty else schd_discr_qty )*/ .
        
            if last-of(pod_nbr) then do:
                for each prh_hist where prh_domain = global_domain 
                    and prh_nbr = pod_nbr  
                    and prh_part = pod_part no-lock :
                    v_qty_rct = v_qty_rct + prh_rcvd .
                end.        
            end.
        
            if last-of(po_vend) then do:
               v_qty_onway = max(v_qty_ord - v_qty_rct ,0 ) .          
/* ********* part 3 ****** */
               find first onway where t_part = ld_part and t_vend = po_vend exclusive-lock no-error .
               if not avail onway then do:
                   create onway .
                   assign t_part = ld_part 
                          t_vend = po_vend
                          t_qty_onway = v_qty_onway .                   
               end.
               else  t_qty_onway = t_qty_onway + v_qty_onway .


            end.

            /* 记录太多,仅显示本月的排程 */
            if schd_date >= date(month(eff_Date),01,year(eff_Date)) then do:
/* ********* part 4 ****** */
                find first ttsch where tt_part = ld_part and tt_vend = po_vend  and tt_date = schd_date exclusive-lock no-error .
                if not avail ttsch then do:
                    create ttsch .
                    assign tt_part = ld_part 
                        tt_vend = po_vend 
                        tt_nbr  = pod_nbr 
                        tt_line = pod_line 
                        tt_date = schd_date
                        tt_qty  = schd_discr_qty .
                end.
                else do:
                        tt_qty  = tt_qty + schd_discr_qty .
                end.            
            end.
    

            /*disp po_vend pod_nbr pod_line schd_discr_qty v_qty_ord v_qty_rct v_qty_onway with width 100. */
        
        end. /*  for each pod_Det  */ 

/* ********* part check  ****** */
        /*防止 for each ,each 无记录 ,ld_part 缺失*/
        find first tmpbom where tmp_part = ld_part exclusive-lock no-error .
        if not avail tmpbom then do:
            create tmpbom.
            assign tmp_part = caps(ld_part)
                tmp_par = "" .       
        end.
        find first onway where t_part = ld_part exclusive-lock no-error .
        if not avail onway then do:
            create onway .
            assign t_part = ld_part t_vend = "" .
        end.
        find first ttsch where tt_part = ld_part exclusive-lock no-error .
        if not avail ttsch then do:
            create ttsch .
            assign tt_part = ld_part tt_vend = "" .
        end.

    end.   /*if first-of(ld_part)*/


    v_qty_oh = v_qty_oh + ld_qty_oh .

    if last-of(ld_part) then do:

/* ********* part disp out  ****** */
        for each tmpbom no-lock where tmp_part = ld_part  ,
            each onway no-lock where t_part = ld_part  ,
            each ttsch no-lock where tt_part = ld_part and tt_vend = t_vend 
            break by tmp_part by tmp_par by t_vend by tt_date 
            with frame xxx width 300  :

            if first-of(tmp_part) then do:
                find first pt_mstr where pt_domain = global_domain and pt_part = tmp_part no-lock no-error .
                desc1 = if avail pt_mstr then pt_desc1 else "" .
                desc2 = if avail pt_mstr then pt_desc2 else "" .
                um = if avail pt_mstr then pt_um else "" .
                v_qty_saf = if avail pt_mstr then pt_sfty_stk else  0 .
                
                find first xppt_mstr where xppt_domain = global_domain and xppt_part = tmp_part no-lock no-error .
                v_vd_type = if avail xppt_mstr then xppt_type else "" .
                find first code_mstr where code_domain = global_domain and code_fldname = 'xppt_type' and code_value = v_vd_type no-lock no-error .
                v_vd_type = if avail code_mstr then code_cmmt else "" .
                
                v_ord_per = 0 .
                find first ptp_det  where ptp_domain = global_domain and ptp_site = site and ptp_part = tmp_part no-lock no-error .
                if avail ptp_det then do:
                    if ptp_ord_per <> 0   then v_ord_per = ptp_ord_per  .
                    else do:
                        find first pt_mstr  where pt_domain = global_domain and pt_part = tmp_part no-lock no-error .
                        if avail pt_mstr then do:
                            if pt_ord_per <> 0   then v_ord_per = pt_ord_per .
                        end.
                    end.
                end.
                else do:
                    find first pt_mstr  where pt_domain = global_domain and pt_part = tmp_part no-lock no-error .
                    if avail pt_mstr then do:
                        if  pt_ord_per <> 0   then v_ord_per = pt_ord_per .
                    end.
                end.           

            end.  /*  if first-of(tmp_part) */

            v_qty_oh2 = 0 .
            v_qty_oh2 = if tmp_qty_per <> 0 then  v_qty_oh / tmp_qty_per else 0 .

            if first-of(tmp_par) then do:
                v_qty_req = 0 .
                for each mrp_det where mrp_domain = global_domain
                                 and mrp_site = site
                                 and  mrp_due_date >= /*次月start*/ date( if month(eff_date)<= 11 then month(eff_date) + 1 else 1 ,
                                                                          01,
                                                                          if month(eff_date)<= 11 then year(eff_date) else year(eff_date) + 1 )
                                 and  mrp_due_date <= /*次月end*/ date( if month(eff_date)<= 10 then month(eff_date) + 2 else month(eff_date) - 12 + 2  ,
                                                                        01,
                                                                        if month(eff_date)<= 10 then year(eff_date) else year(eff_date) + 1 ) - 1
                                 and  mrp_type = "DEMAND"
                                 and mrp_part = tmp_par  no-lock :
                    v_qty_req = v_qty_req + mrp_qty .
                end.                
            end.

            v_qty_err = ( v_qty_oh2 - v_qty_req ) * tmp_qty_per - v_qty_saf .

            export delimiter ";"
                  v_vd_type v_ord_per
                  ld_part desc1 desc2 um v_qty_oh v_qty_saf
                  tmp_par tmp_qty_per v_qty_oh2 v_qty_req v_qty_err
                  t_vend t_qty_onway
                  tt_date  tt_qty 
                  "" "" "" "" "" ""  .

            /*             disp  v_vd_type v_ord_per                               */
            /*                   ld_part desc1 desc2 um v_qty_saf                  */
            /*                   v_qty_oh                                          */
            /*                   tmp_par tmp_qty_per v_qty_oh2 v_qty_req v_qty_err */
            /*                   t_vend t_qty_onway                                */
            /*                   tt_date tt_nbr tt_line tt_qty with frame xxx .    */
        end.  /*for each tmpbom ,each onway */


        for each tmpbom:
            delete tmpbom .
        end.
        
        for each onway :
            delete onway .
        end.
        
        for each ttsch:
            delete ttsch  .
        end.

    end.  /* if last-of(ld_part) then */
end.    /*for each ld_det */


    for each tmpbom:
        delete tmpbom .
    end.
    
    for each onway :
        delete onway .
    end.
    
    for each ttsch:
        delete ttsch  .
    end.

    /* put skip(3) "test end: " string(time,"hh:mm:ss") skip . */
    end. /* mainloop: */
    /* {mfrtrail.i}  REPORT TRAILER  */
    {mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
