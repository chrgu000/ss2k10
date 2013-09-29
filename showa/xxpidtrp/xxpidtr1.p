/* xxpidtr1.p - 盘点原票                      */
/* $Revision: eb2sp4	$BY: Cosesa Yang         DATE: 09/28/13  ECO: *SS - 20130928.1* */

{mfdtitle.i "130928.1"}

DEF VAR v_loc  LIKE tag_loc.
DEF VAR v_loc1 LIKE tag_loc.
DEF VAR lins   AS INT FORMAT ">>>,>>9".
DEF VAR loc1   AS CHAR.
DEF VAR loc2   AS CHAR.
DEF VAR eff    as char.
def var str_dt as char.
define variable tagnbr          like tag_nbr.

form
    v_loc      colon 15  label "库位"
    v_loc1     colon 49  label "至"
    skip
with frame a side-labels attr-space width 80 .

/* REPORT BLOCK */
{wbrp01.i}

mainloop:
REPEAT:
 IF v_loc1 = hi_char THEN v_loc1 = "".
     update
      v_loc
      v_loc1
      with frame a.

      {wbrp06.i &command = update &fields = " v_loc v_loc1 " &frm = "a"}

        {mfquoter.i v_loc  }
        {mfquoter.i v_loc1 }
      
      IF v_loc1 = "" THEN v_loc1 = hi_char.

      {mfselbpr.i "printer" 132}

      PUT UNFORMATTED "#def REPORTPATH=$/库存/实际盘点/xxpidtr1" SKIP.
      PUT UNFORMATTED "#def :end" SKIP.
      str_dt = string(year(today),"9999") + "年" + string(month(today),"99") + "月    日" .

      for each tag_mstr exclusive-lock where tag_loc >= v_loc 
			          and tag_loc <= v_loc1
			          and tag_type = "I"
                and not tag_posted
			          and not tag_void
			          break by tag_part by tag_serial:
	  if last-of(tag_part) then do: 
	     find first ld_det no-lock where ld_part = tag_part and ld_qty_oh <> 0 no-error.
	     if available ld_det then do:
	         find first pt_mstr where pt_part = tag_part no-lock no-error.
           
	         PUT UNFORMATTED str_dt ";" .
	         put tag_part format "x(18)" ";".
	         if avail pt_mstr then put pt_desc1 .
	         else put " " .
	         put skip.
	      end. /* if available ld_det */
	  end. /* if last-of(tag_part) then do: */
	  tag_prt_dt = today.
	  end. /*for each tag_mstr */
       {a6mfrtrail.i}
END.
{wbrp04.i &frame-spec = a}