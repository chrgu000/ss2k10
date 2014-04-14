/* xxporcldrp.p - PART LOCATION REPORT                                       */
/*V8:ConvertMode=FullGUIReport                                               */

{mfdeclre.i} /*G960*/
{xxporcld.i}
  /* SELECT PRINTER */
{mfselbpr.i "printer" 132}
for each tmp_pod no-lock where with frame b width 132:
   display tpo_sel
           tpo_po
           tpo_line
           tpo_part
           tpo_loc
           tpo_qty_req
           tpo_qty_rc
           tpo_receive
           tpo_stat.
end.
{mfreset.i}
