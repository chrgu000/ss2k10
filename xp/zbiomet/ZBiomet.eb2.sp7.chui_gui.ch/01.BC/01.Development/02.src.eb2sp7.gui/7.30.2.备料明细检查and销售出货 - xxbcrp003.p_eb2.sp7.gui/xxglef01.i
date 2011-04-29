/*{&effdate}  {&entity}  {&module} 
{&module} 未使用,所以限制仅为"IC" 和"GL"
*/
aPass = "Y".
find first gl_ctrl no-lock no-error .
if avail gl_ctrl and gl_verify = yes then do:
    find first glc_cal where glc_start <=   {&effdate} and glc_end   >= {&effdate} no-lock no-error.
    if avail glc_cal then do:
        find first glcd_det where  glcd_year = glc_year  and glcd_per  = glc_per and glcd_entity = {&entity} no-lock no-error.
        if not avail glcd_det then do:
            aPass = "N".
        end.
        else do:
            if glcd_gl_clsd then do:
                aPass = "N".
            end.
            else do:
                find first qad_wkfl  where qad_key1 = "GLCD_DET" and qad_key2 = string(glc_year,"9999") + string(glc_per, "999")  +  {&entity} no-lock no-error.
                if available qad_wkfl and (qad_decfld[4] = 1) then aPass = "N".                
            end.
        end.

   end.
   else do:
        aPass = "N".
   end.
end.

