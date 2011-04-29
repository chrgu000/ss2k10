




/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

define variable part   like pt_part      no-undo.
define variable part1  like pt_part      no-undo.
define variable line   like pt_prod_line no-undo.
define variable line1  like pt_prod_line no-undo.
define variable type like pt_part_type.
define variable type1 like pt_part_type.
define variable ptgroup like pt_group.
define variable group1 like pt_group.
define var      date	as date .
define var      date1	as date .

define var v_linename as char format "x(24)" .
define var v_sct as char initial "Standard" .
define var v_qty_iss like tr_qty_loc .
define var v_qty_rct like tr_qty_loc .
define var v_wolot   like wo_lot .
define var v_site    like wo_site .



define temp-table t1 
    field t1_prod_line like pt_prod_line 
    field t1_par       like pt_part
    field t1_comp      like wod_part
    field t1_qty_comp  like wo_qty_comp
    field t1_sct       like sct_cst_tot
    field t1_qty_per   like ps_qty_per
    field t1_qty_iss   like wod_qty_iss
    /*
    field t1_qty_req   like wod_qty_req
    field t1_amt_req   like tr_gl_amt
    field t1_amt_iss   like tr_gl_amt  */ .

define temp-table t2  /*所有有入库的wo*/
    field t2_part   like wo_part 
    field t2_wolot  like wo_lot .



define var v_um1     like pt_um .
define var v_um2     like pt_um .
define var v_desc1   like pt_desc1 .
define var v_desc2   like pt_desc2.
define var v_desc3   like pt_desc1 .
define var v_desc4   like pt_desc2.
/*prodline小计*/
define var xx_qty_comp like tr_qty_loc .
define var xx_qty_req like tr_qty_loc .
define var xx_qty_iss like tr_qty_loc .
define var xx_qty_err like tr_qty_loc .
define var xx_amt_req like tr_qty_loc .
define var xx_amt_iss like tr_qty_loc .
define var xx_amt_err like tr_qty_loc .

/*总计*/
define var xxx_qty_comp like tr_qty_loc .
define var xxx_qty_req like tr_qty_loc .
define var xxx_qty_iss like tr_qty_loc .
define var xxx_qty_err like tr_qty_loc .
define var xxx_amt_req like tr_qty_loc .
define var xxx_amt_iss like tr_qty_loc .
define var xxx_amt_err like tr_qty_loc .


define  frame a.

/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
   line           colon 15 label "生产线"
   line1          label {t001.i} colon 49 skip	
   part           colon 15
   part1          label {t001.i} colon 49 skip
   type           colon 15
   type1          label {t001.i} colon 49 skip
   ptgroup        colon 15
   group1         label {t001.i} colon 49 skip
   date	          label "生效日期" colon 15 
   date1          label {t001.i} colon 49 skip
   skip(1)
   v_sct          label "成本集" colon 15
	
skip(2) 
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
   if part1 = hi_char then part1 = "".
   if line1 = hi_char then line1 = "".
   if type1 = hi_char then type1 = "".
   if group1 = hi_char then group1 = "".
   if date  = low_date then date = ?.
   if date1 = hi_date  then date1 = ?.
   
 update line line1 part part1 type type1 ptgroup group1 date date1 v_sct
 with frame a.

   if part1 = "" then part1 = hi_char.
   if line1 = "" then line1 = hi_char.
   if type1 = "" then type1 = hi_char.
   if group1 = "" then group1 = hi_char.
   if date  = ? then date = low_date.
   if date1 = ?  then date1 = hi_date.
   if v_sct = "" then v_sct = "Standard" .

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

for each t1 : delete t1 . end.
for each t2 : delete t2 . end.

for each pt_mstr use-index pt_prod_part
        where pt_mstr.pt_domain = global_domain 
        and (pt_part >= part and pt_part <= part1)
        and (pt_prod_line >= line and pt_prod_line <= line1)
        and (pt_part_type >= type and pt_part_type <= type1)
        and (pt_group >= ptgroup and pt_group <= group1)
        no-lock 
    break by pt_prod_line by pt_part 
    with frame b with width 300 :

    find first tr_hist use-index tr_type
        where tr_domain  = global_domain 
        and tr_type = "RCT-WO"
        and tr_effdate >= date and tr_effdate <= date1 
        and tr_part = pt_part 
    no-lock no-error .
    if not avail tr_hist then next .
    else do: /*avail tr_hist*/
        v_qty_rct = 0. 
        v_qty_iss = 0. 
        
        find first wo_mstr where wo_domain  = global_domain and wo_part = pt_part no-lock no-error.
        v_wolot = if avail wo_mstr then wo_lot else "" . /*标准工单, 晕 */
        v_site  = if avail wo_mstr then wo_site  else "" .  /*标准工单的地点,抓成本集用*/

        for each tr_hist 
            field (tr_domain tr_type tr_effdate tr_part tr_qty_loc tr_lot) 
            where tr_domain = global_domain
            and tr_type = "RCT-WO"
            and tr_effdate >= date and tr_effdate <= date1 
            and tr_part = pt_part no-lock:

            find first t2 where t2_part = pt_part and t2_wolot = tr_lot no-error .
            if not avail t2 then do  :
                create t2 .
                assign t2_part = pt_part  t2_wolot = tr_lot .
            end.
            v_qty_rct = v_qty_rct + tr_qty_loc .
        end. /*for each tr_hist*/

        if v_qty_rct <> 0 then do:
            for each wod_det 
                where wod_domain = global_domain 
                and wod_lot = v_wolot no-lock:

                find first t1 where t1_par = pt_part and t1_comp = wod_part no-error.
                if not avail t1 then do:
                    find first sct_det 
                        where sct_domain = global_domain
                        and sct_sim = v_sct
                        and sct_part = wod_part
                        and sct_site = v_site 
                    no-lock no-error .

                    create t1.
                    assign  t1_prod_line = pt_prod_line
                            t1_par       = pt_part 
                            t1_comp      = wod_part
                            t1_qty_comp  = v_qty_rct
                            t1_qty_per   = wod_bom_qty
                            t1_sct       = if avail sct_det then sct_mtl_tl else 0 
                            .
                end.       
                else do:
                    t1_qty_per   = wod_bom_qty + t1_qty_per .
                end.
            end. /*for each wod_det*/

            for each t2 where t2_part = pt_part :
                    
                    for each  tr_hist 
                        field (tr_domain tr_type tr_effdate tr_part tr_qty_loc tr_lot) 
                        where tr_domain = global_domain
                        and tr_type = "ISS-WO"
                        and tr_effdate >= date and tr_effdate <= date1 
                        and tr_lot  = t2_wolot 
                        no-lock break by tr_part :
                        if first-of(tr_part) then v_qty_iss = 0. 

                        v_qty_iss = v_qty_iss + tr_qty_loc .

                        if last-of(tr_part) then do:
                            find first t1 where t1_par = t2_part and t1_comp = tr_part no-error.
                            if not avail t1 then do: /*其他wo有,标准wo无的wod_part*/
                                find first sct_det 
                                    where sct_domain = global_domain
                                    and sct_sim = v_sct
                                    and sct_part = tr_part
                                    and sct_site = v_site 
                                no-lock no-error .

                                create t1.
                                assign  t1_prod_line = pt_prod_line
                                        t1_par       = pt_part 
                                        t1_comp      = tr_part
                                        t1_qty_comp  = 0
                                        t1_qty_per   = 0
                                        t1_sct       = if avail sct_det then sct_mtl_tl else 0 
                                        t1_qty_iss   = v_qty_iss.
                            end.
                            else do :
                                t1_qty_iss   = v_qty_iss.
                            end.
                        end.
                    end. /*for each tr_hist*/  
                    
            end. /*for each t2 */


        end. /*if v_qty_rct <> 0*/
    end. /*avail tr_hist*/
end. /*for each pt_mstr*/



PUT UNFORMATTED "#def REPORTPATH=$/Citizen/xxqmrp097" SKIP.
PUT UNFORMATTED "#def :end" SKIP.


xxx_qty_comp = 0 .
xxx_qty_req  = 0 .
xxx_qty_iss = 0 .
xxx_qty_err = 0 .
xxx_amt_req  = 0 .
xxx_amt_iss = 0 .
xxx_amt_err = 0 .

for each t1 break by t1_prod_line by t1_par by t1_comp :
    if first-of(t1_prod_line) then do:
        find first pl_mstr 
            where pl_domain = global_domain 
            and pl_prod_line = t1_prod_line 
        no-lock no-error .
        v_linename  = if avail pl_mstr then pl_desc else "" .  
            xx_qty_comp = 0 .
            xx_qty_req  = 0 .
            xx_qty_iss = 0 .
            xx_qty_err = 0 .
            xx_amt_req  = 0 .
            xx_amt_iss = 0 .
            xx_amt_err = 0 .
    end.

    find first pt_mstr where pt_domain  = global_domain and pt_part = t1_par no-lock no-error.
    if avail pt_mstr then do:
        v_um1 = pt_um .
        v_desc1 = pt_desc1 .
        v_desc2 = pt_desc2 .
    end.

    find first pt_mstr where pt_domain  = global_domain and pt_part = t1_comp no-lock no-error.
    if avail pt_mstr then do:
        v_um2 = pt_um .
        v_desc3 = pt_desc1 .
        v_desc4 = pt_desc2 .
    end.

        /*if date = ? then put  UNFORMATTED  "日期:由 - ;". 
        else             put UNFORMATTED "日期:由 " year(date) "/" month(date) "/" day(date) ";". 
        if date1 = ? then put  UNFORMATTED  " 至 - ;". 
        else             put UNFORMATTED  " 至 "year(date1) "/" month(date1) "/" day(date1) ";" . */
        if date = ? then put  UNFORMATTED  ";". 
        else             put UNFORMATTED  year(date) "/" month(date) "/" day(date) ";". 
        if date1 = ? then put  UNFORMATTED  ";". 
        else             put UNFORMATTED  year(date1) "/" month(date1) "/" day(date1) ";" .

        put  UNFORMATTED t1_prod_line ";".
        put  UNFORMATTED v_linename ";".  
        put  UNFORMATTED t1_par ";". 
        put  UNFORMATTED v_desc1 ";". 
        put  UNFORMATTED v_desc2 ";".
        put  UNFORMATTED v_um1 ";". 
        put  UNFORMATTED t1_qty_comp ";". 
        put  UNFORMATTED t1_comp ";". 
        put  UNFORMATTED v_desc3 ";". 
        put  UNFORMATTED v_desc4 ";". 
        put  UNFORMATTED v_um2 ";". 
        put  UNFORMATTED t1_qty_per ";". 
        put  UNFORMATTED t1_sct ";". 
        put  UNFORMATTED t1_qty_per * t1_qty_comp ";". 
        put  UNFORMATTED t1_sct * t1_qty_per * t1_qty_comp ";". 
        put  UNFORMATTED t1_qty_iss ";". 
        put  UNFORMATTED t1_sct * t1_qty_iss ";". 
        put  UNFORMATTED t1_qty_iss - t1_qty_per * t1_qty_comp  ";". 
        put  UNFORMATTED t1_sct * (t1_qty_iss - t1_qty_per * t1_qty_comp ) .
        put skip .

        xx_qty_comp =  xx_qty_comp + t1_qty_comp .
        xx_qty_req  = xx_qty_req + t1_qty_per * t1_qty_comp .
        xx_qty_iss  = xx_qty_iss + t1_qty_iss .
        xx_qty_err  = xx_qty_err + t1_qty_iss - t1_qty_per * t1_qty_comp .
        xx_amt_req  = xx_amt_req  + t1_sct * t1_qty_per * t1_qty_comp .
        xx_amt_iss  = xx_amt_iss + t1_sct * t1_qty_iss .
        xx_amt_err  = xx_amt_err + t1_sct * (t1_qty_iss - t1_qty_per * t1_qty_comp )  .

        if last-of(t1_prod_line) then do:
            if date = ? then put  UNFORMATTED  ";". 
            else             put UNFORMATTED  year(date) "/" month(date) "/" day(date) ";". 
            if date1 = ? then put  UNFORMATTED  ";". 
            else             put UNFORMATTED  year(date1) "/" month(date1) "/" day(date1) ";" .
            put  UNFORMATTED t1_prod_line ";".
            put  UNFORMATTED v_linename ";".  
            put  UNFORMATTED "小计: ;". 
            put  UNFORMATTED  ";". 
            put  UNFORMATTED  ";".
            put  UNFORMATTED  ";". 
            put  UNFORMATTED xx_qty_comp ";". 
            put  UNFORMATTED ";". 
            put  UNFORMATTED ";". 
            put  UNFORMATTED ";". 
            put  UNFORMATTED ";". 
            put  UNFORMATTED ";". 
            put  UNFORMATTED ";". 
            put  UNFORMATTED /*xx_qty_req  */ ";". 
            put  UNFORMATTED xx_amt_req ";". 
            put  UNFORMATTED /*xx_qty_iss */ ";". 
            put  UNFORMATTED xx_amt_iss ";". 
            put  UNFORMATTED /*xx_qty_err */ ";". 
            put  UNFORMATTED xx_amt_err .
            put skip . 
            
            xxx_qty_comp = xxx_qty_comp + xx_qty_comp .
            xxx_qty_req  = xxx_qty_req + xx_qty_req .
            xxx_qty_iss  = xxx_qty_iss + xx_qty_iss .
            xxx_qty_err  = xxx_qty_err + xx_qty_err  .
            xxx_amt_req  = xxx_amt_req  + xx_amt_req .
            xxx_amt_iss  = xxx_amt_iss + xx_amt_iss .
            xxx_amt_err  = xxx_amt_err +  xx_amt_err .

        end. /*if last-of(t1_prod_line) */
        
end . /*for each t1 */

        if date = ? then put  UNFORMATTED  ";". 
        else             put UNFORMATTED  year(date) "/" month(date) "/" day(date) ";". 
        if date1 = ? then put  UNFORMATTED  ";". 
        else             put UNFORMATTED  year(date1) "/" month(date1) "/" day(date1) ";" . 
        put  UNFORMATTED  ";".
        put  UNFORMATTED  ";".  
        put  UNFORMATTED "总计: ;". 
        put  UNFORMATTED  ";". 
        put  UNFORMATTED  ";".
        put  UNFORMATTED  ";". 
        put  UNFORMATTED xxx_qty_comp ";". 
        put  UNFORMATTED ";". 
        put  UNFORMATTED ";". 
        put  UNFORMATTED ";". 
        put  UNFORMATTED ";". 
        put  UNFORMATTED ";". 
        put  UNFORMATTED ";". 
        put  UNFORMATTED /*xxx_qty_req  */ ";". 
        put  UNFORMATTED xxx_amt_req ";". 
        put  UNFORMATTED /*xxx_qty_iss */ ";". 
        put  UNFORMATTED xxx_amt_iss ";". 
        put  UNFORMATTED /*xxx_qty_err */ ";". 
        put  UNFORMATTED xxx_amt_err .
        put skip . 


	end. /* mainloop: */
    {a6mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}

