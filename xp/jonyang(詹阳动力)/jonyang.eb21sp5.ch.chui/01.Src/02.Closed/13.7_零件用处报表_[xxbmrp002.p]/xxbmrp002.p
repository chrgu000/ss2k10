/* xxbmrp002.p - WHERE-USED REPORT                                               */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100804.1  By: Roger Xiao */


/* DISPLAY TITLE */
{mfdtitle.i "100804.1"}


define var component1 like ps_comp .
define var component2 like ps_comp .
define var buyer      like pt_buyer .
define var buyer1     like pt_buyer.
define var eff_date as date .
define var maxlevel as integer format ">>9" label "Levels".

define var v_desc1 like pt_desc1 .
define var v_desc2 like pt_desc1 .
define var v_buyer like pt_buyer .
define var v_time_set as decimal .
define var v_time_run as decimal .
define var v_ii       as integer .

define temp-table temp1
        field t1_ii          as integer 
        field t1_part        like pt_part 
        field t1_par         like ps_par   label "父零件" 
        field t1_comp        like ps_comp  label "子零件"
        field t1_qty_per     like ps_qty_per
        field t1_lvl         as char 
        .

define temp-table temp2
        field t2_part        like pt_part 
        field t2_time_set    as decimal
        field t2_time_run    as decimal 
        .

define temp-table temp3
        field t3_part        like pt_part 
        field t3_comp        like ps_comp  label "子零件"
        field t3_qty_per     like ps_qty_per
        .


eff_date = today .

form
    SKIP(.2)
	
    component1        colon 20
    component2        colon 45 label "To"
    buyer             colon 20
    buyer1            colon 45 
    skip(1)
    eff_date          colon 25
    maxlevel          colon 25
	
skip(1) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).



form
    t1_part    label "零件号"
    v_desc1    label "零件描述"
    v_buyer     label "采计"
    t1_par     label "父件"
    v_desc2    label "父件描述"
    t1_qty_per label "零件用量"
    v_time_set label "准备时间"
    v_time_run label "运行时间"
with frame x  width 300 down.




{wbrp01.i}
repeat:
    for each temp1 :  delete temp1 .  end .
    for each temp2 :  delete temp2 .  end .

    if buyer1      = hi_char then buyer1     = "" .



    update 
        component1
        component2
        buyer
        buyer1
        eff_date  
        maxlevel   
    with frame a.

    if eff_date    = ?  then eff_date = today.
    if component2  = "" then component2 = component1.
    if buyer1      = "" then buyer1     = hi_char .


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
    
    for each temp1 :  delete temp1 .  end .
    for each temp2 :  delete temp2 .  end .

    v_ii = 0 .

    for each pt_mstr 
            where pt_domain = global_domain 
            and pt_part  >= component1 and pt_part <= component2
            and pt_buyer >= buyer      and pt_buyer <= buyer1
        no-lock:

        run bom_down (input pt_part,input eff_date ).  /*取子件等的准备,运行时间*/ 
        run bom_up (input pt_part,input eff_date ,input maxlevel ). /*取所用之处*/

    end. /*for each pt_mstr*/

    for each temp1 
        break by t1_part by t1_par :

        if first-of(t1_part) then do:
            find first pt_mstr where pt_domain = global_domain and pt_part = t1_part no-lock no-error .
            v_desc1 = if avail pt_mstr then pt_desc1 else "".
            v_buyer = if avail pt_mstr then pt_buyer else "".
            find first temp2 where t2_part = t1_part no-error.
            v_time_set = if avail temp2 then t2_time_set else 0.
            v_time_run = if avail temp2 then t2_time_run else 0.
        end.

        find first pt_mstr where pt_domain = global_domain and pt_part = t1_par no-lock no-error .
        v_desc2 = if avail pt_mstr then pt_desc1 else "".

        disp 
            t1_part
            v_desc1
            v_buyer
            t1_par    
            v_desc2
            t1_qty_per
            v_time_set
            v_time_run 
        with frame x.
        down 1 with frame x.
    end.

	end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}




/*--------------------------------------------------------------------------------------------------------*/


procedure bom_up:
    define input  parameter vv_part     as character .
    define input  parameter vv_eff_date as date format "99/99/99" .
    define input  parameter vv_maxlevel as integer format ">>>" label "Levels".
    
    define var  vv_lvl      as character format "x(7)".
    define var  vv_comp     like ps_comp no-undo.
    define var  vv_level    as integer   no-undo.
    define var  vv_record   as integer extent 500.
    define var  vv_qty      as decimal initial 1  no-undo.
    define var  vv_save_qty as decimal extent 500 no-undo.
    define var  vv_recno    like recno .



assign vv_level = 1 
       vv_comp  = vv_part
       vv_save_qty = 0 
       vv_qty      = 1 .

find first ps_mstr use-index ps_comp where ps_domain = global_domain and  ps_comp = vv_comp no-lock no-error .
repeat:        
    if not avail ps_mstr then do:                        
        repeat:  
            vv_level = vv_level - 1.
            if vv_level < 1 then leave .                    
            find ps_mstr where recid(ps_mstr) = vv_record[vv_level] no-lock no-error.
            vv_comp = ps_comp.    
            vv_qty = vv_save_qty[vv_level]. 
            find next ps_mstr use-index ps_comp where ps_domain = global_domain and   ps_comp = vv_comp no-lock no-error.
            if avail ps_mstr then leave .               
        end.
    end.  /*if not avail ps_mstr*/

    if vv_level < 1 then leave .
    vv_record[vv_level] = recid(ps_mstr).
    vv_lvl = ".......".
    vv_lvl = substring(vv_lvl,1,min(vv_level - 1,6)) + string(vv_level).
    if length(vv_lvl) > 7 then vv_lvl = substring(vv_lvl,length(vv_lvl) - 6,7).

    if (ps_end = ? or vv_eff_date <= ps_end) then do :
        vv_save_qty[vv_level] = vv_qty.
        vv_qty = vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct)).

        if vv_level < vv_maxlevel or vv_maxlevel = 0 then do:
            vv_comp = ps_par .
            vv_level = vv_level + 1.

            vv_recno = recid(ps_mstr) .            
            find first ps_mstr 
                use-index ps_comp 
                where ps_domain = global_domain 
                and ps_comp = vv_comp 
                and (ps_end = ? or vv_eff_date <= ps_end)
            no-lock no-error.
            if not avail ps_mstr then do:
                find ps_mstr where recid(ps_mstr) = vv_recno  no-lock no-error.
                if avail ps_mstr then do:
                    find first temp1 where t1_part = vv_part and t1_par = ps_par /*and t1_comp = ps_comp*/ no-error.
                    if not available temp1 then do:
                        v_ii =  v_ii + 1 .
                        create temp1.
                        assign
                            t1_ii       = v_ii 
                            t1_part     = caps(vv_part)
                            t1_par      = caps(ps_par ) 
                            /*t1_comp     = caps(ps_comp)
                            t1_lvl      = vv_lvl*/
                            t1_qty_per  = vv_qty 
                            .
                    end.
                    else t1_qty_per   = t1_qty_per + vv_qty  .  
                end.
            end.

            find first ps_mstr use-index ps_comp where ps_domain = global_domain and  ps_comp = vv_comp no-lock no-error.
        end. /* IF level < maxlevel OR maxlevel = 0 */
        else do: /*not continue*/
                    find first temp1 where t1_part = vv_part and t1_par = ps_par /* and t1_comp = ps_comp*/ no-error.
                    if not available temp1 then do:
                        v_ii =  v_ii + 1 .
                        create temp1.
                        assign
                            t1_ii       = v_ii 
                            t1_part     = caps(vv_part)
                            t1_par      = caps(ps_par )
                            /*t1_comp     = caps(ps_comp)
                            t1_lvl      = vv_lvl*/
                            t1_qty_per  = vv_qty 
                            .
                    end.
                    else t1_qty_per   = t1_qty_per + vv_qty  .  

                    find next ps_mstr use-index ps_comp where ps_domain = global_domain and  ps_comp = vv_comp no-lock no-error.
        end. /*not continue*/
    end.   /*if (ps_end = ? or vv_eff_date <= ps_end)*/
    else do: /*over eff-date*/
        find next ps_mstr use-index ps_comp where ps_domain = global_domain and  ps_comp = vv_comp no-lock no-error.
    end.   /*over eff-date*/

end. /*repeat:*/
  

end procedure. /*bom_up*/




procedure bom_down:
    define input  parameter vv_part     as character .
    define input  parameter vv_eff_date as date format "99/99/99" .
    
    define var  vv_comp     like ps_comp no-undo.
    define var  vv_level    as integer   no-undo.
    define var  vv_record   as integer extent 500.
    define var  vv_qty      as decimal initial 1  no-undo.
    define var  vv_save_qty as decimal extent 500 no-undo.


    for each temp3 :  delete temp3 .  end .

    assign vv_level = 1 
           vv_comp  = vv_part
           vv_save_qty = 0 
           vv_qty      = 1 .

    
find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error .
repeat:        
       if not avail ps_mstr then do:                        
             repeat:  
                vv_level = vv_level - 1.
                if vv_level < 1 then leave .                    
                find ps_mstr where recid(ps_mstr) = vv_record[vv_level] no-lock no-error.
                vv_comp  = ps_par.  
                vv_qty = vv_save_qty[vv_level].            
                find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and  ps_par = vv_comp  no-lock no-error.
                if avail ps_mstr then leave .               
            end.
        end.  /*if not avail ps_mstr*/
    
        if vv_level < 1 then leave .
        vv_record[vv_level] = recid(ps_mstr).                
        
        
        if (ps_end = ? or vv_eff_date <= ps_end) then do :
                vv_save_qty[vv_level] = vv_qty.

                vv_comp  = ps_comp .
                vv_qty = vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct)).
                vv_level = vv_level + 1.


                find first temp3 where t3_part = vv_part and t3_comp = ps_comp no-error.
                if not available temp3 then do:
                    create temp3.
                    assign
                        t3_part     = caps(vv_part)
                        t3_comp     = caps(ps_comp)
                        t3_qty_per  = vv_qty 
                        .
                end.
                else t3_qty_per   = t3_qty_per + vv_qty  .  

                find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error.     
        end.   /*if (ps_end = ? or vv_eff_date <= ps_end)*/
        else do:
              find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error.
        end.  /* not (ps_end = ? or vv_eff_date <= ps_end)  */
end. /*repeat:*/   


v_time_set = 0 .
v_time_run = 0 .
for each temp3 where t3_part = vv_part :
    for each ro_det where ro_domain = global_domain and ro_routing = t3_comp no-lock :
        v_time_set = v_time_set + ro_setup.
        v_time_run = v_time_run + ro_run * t3_qty_per  .
    end.
end.
for each ro_det where ro_domain = global_domain and ro_routing = vv_part no-lock :
    v_time_set = v_time_set + ro_setup.
    v_time_run = v_time_run + ro_run   .
end.

find first temp2 where t2_part = vv_part no-error.
if not avail temp2 then do:
    create temp2.
    assign t2_part = vv_part 
           t2_time_set = v_time_set 
           t2_time_run = v_time_run.
end.

end procedure. /*bom_down*/
