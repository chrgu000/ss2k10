/*V8:ConvertMode=Maintenance                                                  */

for each vp_mstr exclusive-lock where vp_mfgr <> "":
   find first ad_mstr no-lock where ad_addr = vp_mfgr
          and ad_type = "supplier" no-error.
   if available ad_mstr then do:
         assign vp__chr02 = ad_name.
   end.
end.
quit.