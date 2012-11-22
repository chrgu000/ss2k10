/* xxsh1201.i - sh1201 item request calc                                     */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1C04   QAD:eb21sp6    Interface:Character        */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

define {1} shared variable site    like si_site.
define {1} shared variable sdate    as date initial today.
define {1} shared variable flhload  as character format "x(70)".
define {1} shared variable maxArray as integer initial 30.
define {1} shared variable planItems as character.

/*成品需求表*/
define {1} shared temp-table xxpln_mstr no-undo
       fields xxpln_par like ps_par
       fields xxpln_date as date
       fields xxpln_qty like pod_qty_ord
       index xxpln_par_date is primary xxpln_par xxpln_date.

/*BOM用量表*/
define {1} shared temp-table temp3
        field t3_part        like pt_part
        field t3_comp        like ps_comp
        field t3_qty_per     like ps_qty_per.

define {1} shared temp-table xxpnd_det no-undo
        fields xxpnd_comp like ps_comp
        fields xxpnd_date as date
        fields xxpnd_dev_date as date
        fields xxpnd_qty like pod_qty_ord
        fields xxpnd_dev_qty like pod_qty_ord
        fields xxpnd_qty_oh like ld_qty_oh
        fields xxpnd_qty_onpo like pod_qty_ord
        index xxpod_comp_date is primary xxpnd_comp xxpnd_date
        index xxpod_comp_dev_date xxpnd_comp xxpnd_dev_date.

FUNCTION getWeekTerm RETURNS Character(idate as date):
  define variable vid as integer.
  define variable oTerm as character.
  assign vid = weekday(idate).
  case vid:
       when 1 then assign oTerm = "SUNDAY".
       when 2 then assign oTerm = "MONDAY".
       when 3 then assign oTerm = "TUESDAY".
       when 4 then assign oTerm = "WEDNESDAY".
       when 5 then assign oTerm = "THURSDAY".
       when 6 then assign oTerm = "FRIDAY".
       when 7 then assign oTerm = "SATURDAY".
       OTHERWISE assign oTerm = "DAY_OF_WEEK".
  end.
  return oTerm.
END FUNCTION. /*FUNCTION getWeekTerm*/

procedure getSubQty:
 /* -----------------------------------------------------------
    Purpose: 计算BOM用量到table temp3
    Parameters: vv_par:父零件,vv_eff_date:生效日
    Notes:
  -------------------------------------------------------------*/

    define input  parameter vv_part     as character .
    define input  parameter vv_eff_date as date format "99/99/99" .

    define var  vv_comp     like ps_comp no-undo.
    define var  vv_level    as integer   no-undo.
    define var  vv_record   as integer extent 500.
    define var  vv_qty      as decimal initial 1  no-undo.
    define var  vv_save_qty as decimal extent 500 no-undo.

    assign vv_level = 1
           vv_comp  = vv_part
           vv_save_qty = 0
           vv_qty      = 1 .

find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and
           ps_par = vv_comp  no-lock no-error .
repeat:
       if not avail ps_mstr then do:
             repeat:
                vv_level = vv_level - 1.
                if vv_level < 1 then leave .
                find ps_mstr where recid(ps_mstr) = vv_record[vv_level]
                             no-lock no-error.
                vv_comp  = ps_par.
                vv_qty = vv_save_qty[vv_level].
                find next ps_mstr use-index ps_parcomp where
                          ps_domain = global_domain and
                          ps_par = vv_comp  no-lock no-error.
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


                find first temp3 where t3_part = vv_part and
                           t3_comp = ps_comp no-error.
                if not available temp3 then do:
                    create temp3.
                    assign
                        t3_part     = caps(vv_part)
                        t3_comp     = caps(ps_comp)
                        t3_qty_per  = vv_qty
                        .
                end.
                else t3_qty_per   = t3_qty_per + vv_qty  .

                find first ps_mstr use-index ps_parcomp where
                           ps_domain = global_domain and
                           ps_par = vv_comp  no-lock no-error.
        end.   /*if (ps_end = ? or vv_eff_date <= ps_end)*/
        else do:
              find next ps_mstr use-index ps_parcomp where
                        ps_domain = global_domain and
                        ps_par = vv_comp  no-lock no-error.
        end.  /* not (ps_end = ? or vv_eff_date <= ps_end)  */
end. /*repeat:*/

end procedure. /*bom_down*/

PROCEDURE getplanItems:
/* -----------------------------------------------------------
   Purpose:get Plan Items
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
	assign planItems = "".
	for each code_mstr no-lock where code_domain = global_domain
		   and code_fldname = "DGPLAN_PT_GROUP":
		   if planItems = "" then do:
		   		assign planItems = code_value.
		   end.
		   else do:
		   	 	assign planItems = planItems + "," + code_value.
		   end.
	end.
END PROCEDURE. /* PROCEDURE getplanItems*/
