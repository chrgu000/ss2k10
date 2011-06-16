output to value("/home/mfg/micho/xxdtbrp1.txt") .
def var i as integer .
DEF VAR v_by AS CHAR.

DEF TEMP-TABLE tt
   FIELD tt_by AS CHAR
   FIELD tt_value LIKE CODE_value
   FIELD tt_cmmt LIKE CODE_cmmt
   . 

EMPTY TEMP-TABLE tt.
FOR EACH CODE_mstr WHERE CODE_fldname = "pt_promo" :

   CREATE tt .
   ASSIGN
      tt_by = code_user1
      tt_value = CODE_value
      tt_cmmt = CODE_cmmt
      .
END.

/* 第1行为标题行信息 */
put unformatted "表头" ";" "打印时间" ";" "时段" ";" "传票日期" ";"
"总量" ";" "台车总计" ";" "修改版本" ";" . 
for each tt BY tt_by BY tt_value :
   PUT UNFORMATTED tt_cmmt ";" .
end.
put unformatted "传票合计" ";" "QC确认" skip.

/* 第2行为数据行 */
put unformatted "送货动态管理表" ";" "打印时间: 2008-08-06 10:12:49" ";"
"08:00" ";" "08-06 21:00" ";" "100" ";" "10" ";" "调整一" ";" .

i = 0.
for each tt BY tt_by BY tt_value :
i = i + 1 .
put unformatted i ";" .
end.
put unformatted "20" ";" "" skip.

/* 第3行为数据行 */
put unformatted "送货动态管理表" ";" "打印时间: 2008-08-06 10:12:49" ";"
"08:00" ";" "08-06 21:00" ";" "100" ";" "10" ";" "调整二" ";" .

i = 0.
for each tt BY tt_by BY tt_value :
i = i + 1 .
put unformatted i ";" .
end.
put unformatted "20" ";" "" skip.


/* 第4行为数据行 */
put unformatted "送货动态管理表" ";" "打印时间: 2008-08-06 10:12:49" ";"
"08:00" ";" "08-06 21:00" ";" "100" ";" "10" ";" "调整三" ";" .

i = 0.
for each tt BY tt_by BY tt_value :
i = i + 1 .
put unformatted i ";" .
end.
put unformatted "20" ";" "" skip.


output close .

