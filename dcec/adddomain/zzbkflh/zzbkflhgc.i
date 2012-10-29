
find first xxwk no-lock no-error.

put stream bkflh '"' xxwk.emp '"' skip.
put stream bkflh string(day(xxwk.effdate),"99") format "99" "/"
                 string(month(xxwk.effdate),"99") format "99" "/"
                 substring(string(year(xxwk.effdate)),3,2) format "99".
put stream bkflh ' "' TRIM(xxwk.shift) '" "' TRIM(xxwk.site) '"' skip.
put stream bkflh '"' TRIM(xxwk.par) '" ' xxwk.lastop ' "' TRIM(xxwk.line) '"' skip.
put stream bkflh '"' TRIM(xxwk.routing) '" "' TRIM(xxwk.bom_code) '"' skip.
put stream bkflh '"' TRIM(xxwk.wkctr) '" "' TRIM(xxwk.mch) '"' skip.
put stream bkflh '"' xxwk.dept '" ' STRING(xxwk.qty_comp,">>,>>>,>>>,>>9.0<<") ' - - - - - - - - - Y Y' skip.
put stream bkflh "-" skip.      /* start time */

    for first xxwk where xxwk.comp <> "" no-lock:
        put stream bkflh '"' TRIM(xxwk.comp) '" ' xxwk.compop skip.
        put stream bkflh STRING(xxwk.qty_iss,">>,>>>,>>>,>>9.0<<") ' N '.
        put stream bkflh '"' TRIM(xxwk.site) '" "' TRIM(xxwk.comploc) '" "' TRIM(xxwk.complot) '" "' TRIM(xxwk.compref) '"' skip.
    end.

put stream bkflh "." skip.
put stream bkflh "N" skip. /* 显示正在发放的零件 */
put stream bkflh "Y" skip. /* 信息是否正确 */

/* 收货数据 */
find first xxwk no-lock no-error.
put stream bkflh STRING(xxwk.qty_comp,">>,>>>,>>>,>>9.0<<") ' - - "' TRIM(xxwk.site) '" "' TRIM(xxwk.parloc)  '" - - N N' skip.
put stream bkflh 'Y' skip. /* 所有信息是否正确 */
put stream bkflh 'Y' skip. /* 确认更新 */
/* 收货数据 */

put stream bkflh "." skip. /* 工作中心回到员工 */
