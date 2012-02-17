/*V8:ConvertMode=Report                                                      */

{mfdeclre.i}
{xxschimp.i}

define variable fn as character.
define variable i as integer.
assign fn = "xxschimp" + string(time).
output to value(fn + ".bpi").
  for each xsch_data no-lock break by xsd_nbr by xsd_line
        by xsd_pcs_date by xsd_date by xsd_time:
      if first-of(xsd_pcs_date) then do:
/*         put unformat "@@batchload xxschimprssmt114.p" skip.  */
         put unformat '"' xsd_nbr '" " " " " " " ' xsd_line skip.
         put unformat '"' v_rlse_id '"' skip.
         put unformat '- '.
         if xsd_pcr_qty <> ? then do:
            put unformat xsd_pcr_qty ' '.
         end.
         else do:
            put unformat '- '.
         end.
         put unformat xsd_pcs_date ' - - ' trim(string(xsd__dec01,"->>>>>>>>9.9<")).
         put unformat ' ' trim(string(xsd__dec02,"->>>>>>>>9.9<")) skip.
      end.
      put unformat xsd_date ' ' xsd_time skip.
      put unformat xsd_upd_qty ' "' xsd_fc_qual '"' skip.
      if last-of(xsd_pcs_date) then do:
         put '.' skip.
         put '-' skip.
/*         put "@@END" skip.   */
/*         put unformat 'y' skip.  */
      end.
  end.
output close.
/*
batchrun = yes.
INPUT FROM VALUE(fn + ".bpi").
OUTPUT TO VALUE(fn + ".bpo").
{gprun.i ""xxschimprssmt114.p""}
INPUT CLOSE .
OUTPUT CLOSE .
batchrun = NO.

os-delete VALUE(fn + ".bpi") no-error.
os-delete value(fn + ".bpo") no-error.
*/