/* xxkbrp007.p  材料利用率分析表                                                       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                                 */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/*V8:ConvertMode=NoConvert                                                             */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07    BY: Softspeed roger xiao  ECO:*xp001* */

/* REVISION: 1.0      LAST MODIFIED: 2008/03/31  BY: Softspeed roger xiao  ECO:*xp002* */
/*-Revision end------------------------------------------------------------           */



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */

define var part  like xmpt_part .
define var part1 like xmpt_part .
define var par  like xkb_par .
define var par1 like xkb_par .
define var desc1 like pt_desc1 label "说明".
define var desc2 like pt_desc2 label "说明" .
define var desc3 like pt_desc1 label "说明".
define var desc4 like pt_desc2  label "说明".
define var um    like pt_um .
define var site  like xmpt_site .
define var v_buyer    like ptp_buyer   label  "计划员" .
define var rel  as date .
define var rel1 as date .

define var  comp like ps_comp no-undo.
define var  level as integer no-undo.
define var  record as integer extent 100.
define var recno_to as recid .
define var lvl as character format "x(7)".
define var qty as decimal initial 1 no-undo.
define var save_qty as decimal extent 100 no-undo.
define var v_part as character .
define var eff_date as date format "99/99/99" .
define var v_qty_ls  like tr_qty_loc label "领料量".
define var v_qty_ly  like tr_qty_loc label "超领量".
define var v_qty_rt  like tr_qty_loc label "退料量".
define var v_qty_err  like tr_qty_loc label "差异量".
define var v_qty_par  like tr_qty_loc label "需求量". 

{gpxpld01.i "new shared"} /*xp00_bom*/
define  variable phantom like mfc_logical. /*xp00_bom*/

define temp-table tmpkb 
    field tmp_part    like xkb_part label "零件号"
    field tmp_comp    like ps_comp  label "零件号"
    field tmp_qty_per like ps_qty_per label "单耗量"
    field tmp_qty_req like tr_qty_loc label "成品需求量" 
    field tmp_qty_wo  like tr_qty_loc label "实际用量".

define temp-table temp 
    field t_part like pt_part 
    field t_qty_per like ps_qty_per
    field t_qty_req like v_qty_par 
    field t_qty_iss like v_qty_ls
    field t_qty_rt  like v_qty_rt 
    field t_qty_wo  like tr_qty_loc .

define temp-table temp2 
    field t2_lot     like wo_lot   label "累计工单"
    field t2_part    like wo_part label "零件号".

rel1 = today .
rel  = date(month(today),1,year(today)) . 

find icc_ctrl where icc_domain = global_domain no-lock no-error.
site = if avail icc_ctrl then icc_site else global_site .
disp site with frame a .   

define  frame a.


/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
    site                      colon 18      
    v_buyer                   colon 18   label  "计划员"
    par                       colon 18
    par1                      colon 54   label  {t001.i} 
    part                      colon 18
    part1                     colon 54   label  {t001.i} 
    rel                       colon 18
    rel1                      colon 54   label  {t001.i} 
    
    skip(1)

    
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    if part1 = part       then part1 = "".
    if par1 = par         then par1 = "".
    if rel1 = hi_date then rel1 = ? .
    if rel  = low_date then rel = ? .
    
    if c-application-mode <> 'web' then  
        update site v_buyer par par1 part part1  rel  rel1   with frame a.

        {wbrp06.i &command = update &fields = " site v_buyer par par1 part part1  rel  rel1 "  &frm = "a"}
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
        {mfquoter.i par       }
        {mfquoter.i par1     }
        {mfquoter.i part     }
        {mfquoter.i part1    }
        {mfquoter.i rel      }
        {mfquoter.i rel1     }

        if rel <> low_date and rel1 = ? then rel1 = rel .
        if rel = ?        then rel = low_date .
        if rel1 = ?       then rel1 = hi_date.        
        if par1 = ""      then par1 = par .
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

         /*put skip "#test start: " string(time,"hh:mm:ss")skip . */



        for each tmpkb :
            delete tmpkb .
        end.
        for each temp :
            delete temp .
        end.

        for each temp2 :
            delete temp2 .
        end.



        /*找期间内所有成品入库记录,并展bom,计算其零件的计划需求数,展bom只展到备料单一样的阶层*/
        for each tr_hist use-index tr_type  
            where tr_domain = global_domain 
            and tr_effdate >= rel and (tr_effdate <= rel1 or rel1 = ?) 
            and tr_type = "RCT-WO"
            and tr_part >= par and (tr_part <= par1 or par1 = "" ) 
            no-lock break by tr_part with frame x width 300:
            
            find first temp2 where t2_lot = tr_lot no-lock no-error.
            if not avail temp2 then do:
                create temp2 . assign t2_lot = tr_lot t2_part = tr_part  .
            end.
            
            if first-of(tr_part) then do:
                 v_qty_par = 0 . 
            end.

            v_qty_par = v_qty_par + tr_qty_loc .

            if last-of(tr_part) then do:
                 /*xp00_bom****start*/
                    find first ptp_det where ptp_domain = global_domain and ptp_site = tr_site and ptp_part = tr_part no-lock no-error .
                    if not avail ptp_det then do:
                        find first pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock no-error .
                        if avail pt_mstr then do:
                            phantom = pt_phantom .

                        end.
                    end.
                    else phantom = ptp_phantom .

                    eff_date = tr_effdate . 
                    
                    {gpxpldps.i
                    &date=eff_date
                    &site=tr_site
                    &comp=tr_part 
                    &group=null_char
                    &process=null_char
                    &op=?
                    &phantom=phantom}

                    for each pk_det
                           where pk_det.pk_domain = global_domain and  pk_user = mfguser
                           exclusive-lock  .
                           find first tmpkb where tmp_part = tr_part and tmp_comp = pk_part exclusive-lock no-error .
                           if not avail tmpkb then do:
                               create tmpkb.
                               assign tmp_part = caps(tr_part)
                                      tmp_comp = pk_part
                                      tmp_qty_per = pk_qty
                                      tmp_qty_req = v_qty_par   .                              
                           end.
                           else do:
                                      tmp_qty_per = tmp_qty_per + pk_qty .
                           end.   


                           delete pk_det . 
                    end.
                 /*xp00_bom****end*/
            end.    /* if last-of(tr_part) */
        end.    /* for each tr_hist */

        /*按统计的所有累计工单temp2,按tr_hist 查找零件实际使用量iss-wo*/
        for each temp2 :
            for each tr_hist 
                    where tr_domain = global_domain 
                    and tr_type = "iss-wo" 
                    and tr_lot = t2_lot 
                    and tr_effdate >= rel and (tr_effdate <= rel1 or rel1 = ? ) 
                    and tr_part >= part and (tr_part <= part1 or part1 = "" ) no-lock  :
                    find first tmpkb where tmp_part = t2_part and tmp_comp = tr_part no-lock no-error .
                    if avail tmpkb then do:
                        tmp_qty_wo = tmp_qty_wo + ( -  tr_qty_loc ) .
                    end.
                    else do:
                        create tmpkb.
                        assign tmp_part  = caps(t2_part)
                              tmp_comp   = tr_part
                              tmp_qty_wo = - tr_qty_loc   . 
                    end.
            end.
        end.


        PUT UNFORMATTED "#def REPORTPATH=$/Minth/xxkbrp007" SKIP.
        PUT UNFORMATTED "#def :end" SKIP.

        /*计算零件看板领退料数量*/
        for each tmpkb where tmp_comp >= part and (tmp_comp <= part1 or part1 = "" )
            and (can-find(first ptp_det where ptp_domain = global_domain and ptp_site = site 
                              and ptp_part = tmp_comp and (ptp_buyer = v_buyer  or v_buyer = "") )
                  or
                ((not can-find(first ptp_det where ptp_domain = global_domain and ptp_site = site 
                               and ptp_part = tmp_comp and (ptp_buyer = v_buyer or v_buyer = "" )))
                  and can-find(first pt_mstr where pt_domain = global_domain  and pt_part = tmp_comp 
                               and (pt_buyer = v_buyer or v_buyer = "" ))) )
            no-lock break by tmp_part by tmp_comp :

            v_qty_par = tmp_qty_req * tmp_qty_per .
            v_qty_ls  = 0 .
            v_qty_ly  = 0 .
            v_qty_rt  = 0 .
            v_qty_err = tmp_qty_wo .

            for each tr_hist 
                      where tr_domain = global_domain 
                      and tr_part = tmp_comp 
                      and tr_effdate >= rel and (tr_effdate <= rel1 or rel1 = ? ) 
                      and tr_rmks = tmp_part 
                      and ( tr_nbr begins "Ls" or tr_nbr begins "LY" or tr_nbr begins "RT")
                      no-lock:
                     if tr_type = "rct-tr" and ( tr_nbr begins "Ls" or tr_nbr begins "LY" ) then  v_qty_ls  = v_qty_ls  + tr_qty_loc .
                     if tr_type = "iss-tr" and tr_nbr begins "rt" then  v_qty_rt  = v_qty_rt  - tr_qty_loc .
            end.


            v_qty_ly = if v_qty_err <> 0 then 100 * v_qty_par / v_qty_err  else  0 . /*xp002*/



            find first pt_mstr where pt_domain = global_domain and pt_part = tmp_part no-lock no-error .
            desc1 = if avail pt_mstr then pt_desc1 else "" .
            desc2 = if avail pt_mstr then pt_desc2 else "" .
            find first pt_mstr where pt_domain = global_domain and pt_part = tmp_comp no-lock no-error .
            desc3 = if avail pt_mstr then pt_desc1 else "" .
            desc4 = if avail pt_mstr then pt_desc2 else "" .
            um = if avail pt_mstr then pt_um else "" .
            
             if first-of(tmp_part) then 
                        export delimiter ";"                                       
                             tmp_part 
                             desc1 /*desc2*/
                             tmp_qty_req
                             tmp_comp desc3 desc4
                             tmp_qty_per um
                             v_qty_par   /*计划*/
                             v_qty_ls     /*实际领*/
                             v_qty_rt      /*实际退*/
                             v_qty_err     /*实际用*/
                             v_qty_ly    /*利用率*/
                             ""
                             ""
                             ""
                         .
             else 
                       export delimiter ";"                                       
                             "" 
                             "" 
                             ""
                             tmp_comp desc3 desc4
                             tmp_qty_per um
                             v_qty_par   /*计划*/
                             v_qty_ls     /*实际领*/
                             v_qty_rt      /*实际退*/
                             v_qty_err     /*实际用*/
                             v_qty_ly    /*利用率*/
                           ""
                           ""
                           ""
                         .

                find first temp where t_part = tmp_comp exclusive-lock no-error .
                if not avail temp then do:
                    create temp .
                    assign t_part = tmp_comp .
                end.
                t_qty_per = max(t_qty_per , tmp_qty_per ).
                t_qty_req = t_qty_req + v_qty_par .
                t_qty_iss = t_qty_iss + v_qty_ls  .
                t_qty_rt  = t_qty_rt  + v_qty_rt  .
                t_qty_wo  = t_qty_wo  + v_qty_err .


        end.  /*for each tmpkb */
        
        /*计算零件 -非看板- 领退料数量*/
        for each tmpkb where tmp_comp >= part and (tmp_comp <= part1 or part1 = "" )
            and (can-find(first ptp_det where ptp_domain = global_domain and ptp_site = site 
                              and ptp_part = tmp_comp and (ptp_buyer = v_buyer  or v_buyer = "") )
                  or
                ((not can-find(first ptp_det where ptp_domain = global_domain and ptp_site = site 
                               and ptp_part = tmp_comp and (ptp_buyer = v_buyer or v_buyer = "" )))
                  and can-find(first pt_mstr where pt_domain = global_domain  and pt_part = tmp_comp 
                               and (pt_buyer = v_buyer or v_buyer = "" ))) )
            no-lock break by tmp_comp  :
            if first-of(tmp_comp) then do:


                    v_qty_par = 0 .
                    v_qty_ls  = 0 .
                    v_qty_ly  = 0 .
                    v_qty_rt  = 0 .
                    v_qty_err = 0 .
                    for each tr_hist 
                              where tr_domain = global_domain 
                              and tr_part = tmp_comp
                              and tr_effdate >= rel and (tr_effdate <= rel1 or rel1 = ? ) 
                              and (tr_rmks = "" )
                              and ( tr_nbr begins "Ls" or tr_nbr begins "LY" or tr_nbr begins "rt")
                              no-lock:
                                if tr_type = "rct-tr" and ( tr_nbr begins "Ls" or tr_nbr begins "LY" ) then  v_qty_ls  = v_qty_ls  + tr_qty_loc .
                                if tr_type = "iss-tr" and tr_nbr begins "rt" then  v_qty_rt  = v_qty_rt  - tr_qty_loc .                          
                    end.

                    /*
                    for each tr_hist 
                              where tr_domain = global_domain and tr_type = "iss-tr"
                              and tr_effdate >= rel and (tr_effdate <= rel1 or rel1 = ? ) 
                              and tr_part = tmp_comp and (tr_addr = "" )
                              and tr_nbr begins "RT"
                              no-lock:
                              find first ln_mstr where ln_domain = global_domain and  ln_site = tr_site and ln_line = tr_loc no-lock no-error .
                              if avail ln_mstr then do:
                                  v_qty_rt  = v_qty_rt  - tr_qty_loc .
                              end.        
                         
                    end.*/

                    find first pt_mstr where pt_domain = global_domain and pt_part = tmp_comp no-lock no-error .
                    desc3 = if avail pt_mstr then pt_desc1 else "" .
                    desc4 = if avail pt_mstr then pt_desc2 else "" .
                    um = if avail pt_mstr then pt_um else "" .
                    
                   if v_qty_ls <> 0 or v_qty_rt <> 0 then do:
                             export delimiter ";"                                       
                                 "未知父件" 
                                 "" 
                                 ""
                                 tmp_comp desc3 desc4
                                 ""
                                 um
                                 v_qty_par  
                                 v_qty_ls   
                                 v_qty_rt   
                                 v_qty_err  
                                 v_qty_ly   
                               ""
                               ""
                               ""
                             .


                            find first temp where t_part = tmp_comp exclusive-lock no-error .
                            if not avail temp then do:
                                create temp .
                                assign t_part = tmp_comp .
                            end.
                            t_qty_iss = t_qty_iss + v_qty_ls  .
                            t_qty_rt  = t_qty_rt  + v_qty_rt  .

                    end.

            end. 
       end.       /*for each tmpkb*/     

        export delimiter ";"   "" "" ""  "" "" ""  "" "" ""  "" "" ""  "" "" "" "" .
        export delimiter ";"   "" "" ""  "" "" ""  "" "" ""  "" "" ""  "" "" "" "" .



        /*输出按零件不按父件汇总后的数据*/
        for each temp break by t_part :
                        find first pt_mstr where pt_domain = global_domain and pt_part = t_part no-lock no-error .
                        desc3 = if avail pt_mstr then pt_desc1 else "" .
                        desc4 = if avail pt_mstr then pt_desc2 else "" .
                        um = if avail pt_mstr then pt_um else "" .
                        v_qty_err = t_qty_wo .
                        v_qty_ly  = if v_qty_err <> 0 then 100 * t_qty_req / v_qty_err else 0 .  /*xp002*/
                        if first(t_part) then
                            export delimiter ";" 
                                   ""
                                   ""
                                   "Total:"
                                   t_part
                                   desc3 
                                   desc4
                                   t_qty_per
                                   um
                                   t_qty_req
                                   t_qty_iss
                                   t_qty_rt
                                   v_qty_err
                                   v_qty_ly
                                   ""
                                   ""
                                   ""
                                 .
                        else 
                            export delimiter ";" 
                                   ""
                                   ""
                                   ""
                                   t_part
                                   desc3 
                                   desc4
                                   t_qty_per
                                   um
                                   t_qty_req
                                   t_qty_iss
                                   t_qty_rt
                                   v_qty_err
                                   v_qty_ly
                                   ""
                                   ""
                                   ""
                                 .

        end.


        for each tmpkb :
            delete tmpkb .
        end.
        for each temp :
            delete temp .
        end.
        for each temp2 :
            delete temp2 .
        end.


         /*put skip(3) "test end: " string(time,"hh:mm:ss") skip . */
        
    end. /* mainloop: */
    /* {mfrtrail.i}  REPORT TRAILER  */
    {mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
