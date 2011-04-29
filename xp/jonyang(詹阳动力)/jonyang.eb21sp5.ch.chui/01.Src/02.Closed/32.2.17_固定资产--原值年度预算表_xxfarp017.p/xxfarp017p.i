/*xxfarp017p.i 打印输出子程式: 多次调用,按同样的格式,分段多次输出 */
/*用法:
{xxfarp017p.i ""期初余额"" t1_amt_beg  }
{xxfarp017p.i ""期末余额"" t1_amt_end  }
*/



for each temp2 break by t2_class by t2_type:
    if first(t2_class) then do:
        put unformatted {1} ";;" .
        v_ii = 0 .
        do v_ii = yr to yr1 :
            put unformatted v_ii ";" .
        end.
        put skip.
    end.

    find first facls_mstr where facls_domain = global_domain and facls_id = t2_class no-lock no-error .
    v_typename = if avail facls_mstr then facls_desc else t2_class .
    if t2_type <> "" then do:
        find first code_mstr where code_domain = global_domain and code_fldname = "fa__chr04" and code_value = t2_type no-lock no-error .
        v_typename = v_typename + "-" + if avail code_mstr then  code_cmmt else t2_type .    
    end.
    put unformatted  ";" v_typename ";" .

    for each temp1 where t1_class = t2_class and t1_type = t2_type no-lock break by t1_year :
        put unformatted  {2} ";" .
    end.
    put skip.
    if last(t2_class) then do:
        put unformatted {1} "-合计:;;".
        for each temp1 no-lock break by t1_year :
            if first-of(t1_year) then v_amt_temp = 0.
            v_amt_temp = v_amt_temp + {2} .
            if last-of(t1_year) then put unformatted  v_amt_temp ";" .
        end.
        put skip.
    end.
end. /*for each temp2*/

