/* xxpiadcr.p - 补打程序                      */
/* $Revision: eb2sp4	$BY: Cosesa Yang         DATE: 09/27/13  ECO: *SS - 20130927.1* */

{mfdtitle.i "130927.1"}
 
def var str_dt as char.
DEF VAR prt_tbl as int format "9" initial 1.
DEF VAR prttype as char format "x(20)" .

DEF VAR lins   AS INT FORMAT ">9".
define variable v_loc            like loc_loc.
define variable v_loc1           like loc_loc .
define variable v_par           like pt_part.
define variable v_par1          like pt_part .
define variable tnbr          like tag_nbr init 0.
define variable tagnbr          like tag_nbr.
define variable bcode         as char .

assign prttype =  "( 1-原表/2-原票 )" .

form
    prt_tbl    colon 15  label "补打"
    prttype    at 20 no-label
    v_par      colon 15  label "图号"
    v_loc      colon 15  label "库位"
    v_loc1     colon 49  label "至"
    skip
with frame a side-labels attr-space width 80 .

/* REPORT BLOCK */
{wbrp01.i}
view frame a.

mainloop:
REPEAT:
       IF v_loc1 = hi_char THEN v_loc1 = "".
       IF v_par1 = hi_char THEN v_par1 = "".

       disp prttype with frame a.
       UPDATE prt_tbl v_par v_loc v_loc1 with frame a.

       {wbrp06.i &command = update &fields = "prt_tbl  v_par v_loc v_loc1 " &frm = "a"} 

        assign bcdparm = "".
        {mfquoter.i v_par      }
        {mfquoter.i v_loc       }
        {mfquoter.i v_loc1      }
        {mfquoter.i prt_tbl   }

	IF v_loc1 = ""    THEN v_loc1 = "ZZZZZZZZ".
	IF v_par = ""     THEN v_par1 = hi_char.
	ELSE v_par1 = v_par.
        lins = 0.

	if prt_tbl < 1 or prt_tbl > 2
        then do:     
           message "请正确选择补打数据报表" .
           next-prompt prt_tbl with frame a.
           undo, retry.
         end. 

	find last tag_mstr where tag_nbr >= 0 no-lock no-error.
        if available tag_mstr then tagnbr = tag_nbr .
	if tagnbr >= 999999 then do:
           message "标签将超条码位数，请删除标签" .
           next-prompt prt_tbl with frame a.
           undo, retry.
	end.
	 tnbr = tagnbr + 1. 

	{mfselbpr.i "printer" 132}
        
	if prt_tbl = 1 then do:
       
	PUT UNFORMATTED "#def REPORTPATH=$/库存/实际盘点/xxpimacr" SKIP.
        PUT UNFORMATTED "#def :end" SKIP.
        str_dt = "日期:" + substring(string(year(today)),3) + "年" + string(month(today),"99") + "月" .

	for each ld_det no-lock where ld_part >= v_par and ld_part <= v_par1
	                          and ld_loc >= v_loc  and ld_loc  <= v_loc1
				  break by ld_loc by ld_part by ld_lot:

	find first tag_mstr  where tag_part = ld_part and tag_loc >= ld_loc
			       and tag_site = ld_site and tag_serial = ld_lot
			      no-lock no-error.
	 if not avail tag_mstr then do:
		    tagnbr = tagnbr + 1.
	     create tag_mstr.
             assign
                    tag_nbr        = tagnbr 
		    tag_site       = ld_site
		    tag_loc        = ld_loc
		    tag_part       = ld_part
		    tag_serial     = ld_lot
		    tag_ref        = ld_ref
		    tag_type       = "I"
		    tag_crt_dt     = today
		    tag_cnt_cnv    = 1
		    tag_rcnt_cnv   = 1
		    tag__qad01     = ld_qty_oh  .

             if tagnbr >= 999999 then leave.
	 end.

	end. /*for each ld_det */

	for each tag_mstr  where tag_nbr >= tnbr and tag_part >= v_par
			      and tag_part <= v_par1
			      and tag_loc >= v_loc 
			      and tag_loc <= v_loc1
			      and tag__qad01 <> 0
			      and tag_type = "I"
		              and not tag_posted
			      and not tag_void
			      and tag_prt_dt = ?
			      break by tag_nbr by tag_site by tag_loc by tag_part:
         lins = lins + 1 .
	 if lins > 15 then lins = 1.

	 find first in_mstr where in_part = tag_part and in_site = tag_site no-lock no-error.
	 find first pt_mstr where pt_part = tag_part no-lock no-error.
   
	    bcode = string(tag_nbr).	    

	    if tag_nbr < 10 then bcode = "00000" + bcode.
	    else 
	    if tag_nbr >= 10 and tag_nbr < 100 then bcode = "0000" + bcode.
	    else
	    if tag_nbr >= 100 and tag_nbr < 1000 then bcode = "000" + bcode.
	    else
	    if tag_nbr >= 1000 and tag_nbr < 10000 then bcode = "00" + bcode.
	    else
	    if tag_nbr >= 10000 and tag_nbr < 100000 then bcode = "0" + bcode.

	    PUT UNFORMATTED str_dt ";" .
	    put lins format ">>>,>>9" ";" tag_loc format "x(8)" ";" .
	    if avail in_mstr then put in_abc format "x(2)" ";" .
	    else put UNFORMATTED  " ;" .
	    PUT UNFORMATTED tag_part ";" tag_nbr ";" "*" + bcode + "*" ";" .
	    if avail pt_mstr then put pt_desc1 format "x(24)" ";" .
	    else put UNFORMATTED " ;".
	    put UNFORMATTED " ; ; ; ; ; " skip.
	    
	    tag_prt_dt = today.
	 end. /*for each tag_mstr*/

	end.
	else 
	if prt_tbl = 2 then do:

        PUT UNFORMATTED "#def REPORTPATH=$/库存/实际盘点/xxpidtrp" SKIP.
        PUT UNFORMATTED "#def :end" SKIP.
        str_dt = string(year(today),"9999") + "年" + string(month(today),"99") + "月度" .
	 
	  for each tag_mstr no-lock where tag_part >= v_par
			      and tag_part <= v_par1
			      and tag_loc >= v_loc 
			      and tag_loc <= v_loc1
			      and tag__qad01 <> 0
			      and tag_type = "I"
		              and not tag_posted
			      and not tag_void
			      break by tag_part by tag_serial:

	   if last-of(tag_part) then do:
	   find first pt_mstr where pt_part = tag_part no-lock no-error.
	   
	    bcode = string(tag_nbr).	    

	    if tag_nbr < 10 then bcode = "00000" + bcode.
	    else 
	    if tag_nbr >= 10 and tag_nbr < 100 then bcode = "0000" + bcode.
	    else
	    if tag_nbr >= 100 and tag_nbr < 1000 then bcode = "000" + bcode.
	    else
	    if tag_nbr >= 1000 and tag_nbr < 10000 then bcode = "00" + bcode.
	    else
	    if tag_nbr >= 10000 and tag_nbr < 100000 then bcode = "0" + bcode.
   
	    PUT UNFORMATTED str_dt ";" .
	    PUT  tag_part format "x(18)" ";" tag_nbr ";" "*" + bcode + "*" ";" .
	    if avail pt_mstr then put pt_desc1 .
	    put skip.

	    end.
	   end. 

	end.
	

        {a6mfrtrail.i}
END.
{wbrp04.i &frame-spec = a}