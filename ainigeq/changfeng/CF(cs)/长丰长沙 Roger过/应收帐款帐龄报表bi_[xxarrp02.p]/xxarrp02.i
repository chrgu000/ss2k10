procedure curr_conv :
   def input param et_report_curr like ap_curr .
   def input param vi_curr like ap_curr.
   def input param vi_date as date .
   def input param vi_amt AS DECIMAL .
   def output param vo_amt AS DECIMAL .

   find first exr_rate 
      where exr_start_date <= vi_date 
      and exr_end_date >= vi_date
      and exr_curr1 = et_report_curr 
      and exr_curr2 = vi_curr 
      no-lock 
      no-error
      .
   if available exr_rate then do:
      assign vo_amt  = round(vi_amt * exr_rate / exr_rate2 ,2) .
   end.
   else do:
      find first exr_rate 
         where  exr_start_date <= vi_date 
         and exr_end_date >= vi_date
         and exr_curr1 = vi_curr 
         and exr_curr2 =et_report_curr 
         no-lock 
         no-error
         .
      if available exr_rate then do:
         assign vo_amt  = round(vi_amt * exr_rate2 / exr_rate ,2) .
      end.
   end.
end.
