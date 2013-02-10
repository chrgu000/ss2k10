/* GUI CONVERTED from yyscximp1.p (converter v1.78) Thu Dec  6 14:46:56 2012 */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i}
{yyscximp.i}

define variable fn as character.
define variable i as integer.
define stream bf.
assign fn = "xxschimp" + string(time).
output stream bf to value(fn + ".bpi").
  for each xsch_data no-lock break by xsd_nbr by xsd_line
        by xsd_pcs_date by xsd_date by xsd_time:
      if first-of(xsd_pcs_date) then do:
/*         put unformat "@@batchload xxrcrsmt1212.p" skip.  */
         put stream bf unformat '"" "" "" "" "" "" "' xsd_nbr '" ' xsd_line skip.
         put stream bf unformat '"' rlseid_from '"' skip.
         put stream bf unformat 'N '.
         put stream bf unformat xsd_pcr_qty ' '.
         put stream bf unformat xsd_pcs_date skip.
      end.
      put stream bf unformat xsd_date ' ' xsd_time skip.
      put stream bf unformat xsd_upd_qty ' "' xsd_fc_qual '" N N' skip.
      if last-of(xsd_pcs_date) then do:
         put stream bf '.' skip.
/*         put "@@END" skip.   */
/*         put unformat 'y' skip.  */
      end.
  end.
output stream bf close.

batchrun = yes.
INPUT FROM VALUE(fn + ".bpi").
OUTPUT TO VALUE(fn + ".bpo").
{gprun.i ""yyrcrsmt1212.p""}
INPUT CLOSE .
OUTPUT CLOSE .
batchrun = NO.

for each xsch_data exclusive-lock:
    find first schd_det no-lock where schd_domain = global_domain
          and schd_type  = 3 and schd_nbr = xsd_nbr and schd_line = xsd_line
          and schd_rlse_id = rlseid_from and schd_date = xsd_date
          and schd_time = substring(xsd_time,1,2) + substring(xsd_time,4,2)
          and schd_upd_qty = xsd_upd_qty
          and schd_fc_qual = xsd_fc_qual no-error.
   if available schd_det then do:
      assign xsd_fc_chk = "OK".
      os-delete VALUE(fn + ".bpi") no-error.
      os-delete value(fn + ".bpo") no-error.
   end.
   else do:
      assign xsd_fc_chk = "FAIL".
   end.
end.
