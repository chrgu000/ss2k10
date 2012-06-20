output to wc.txt.
for each wc_mstr no-lock:
    put unformat '@@batchload xxlnwkmt.p' skip.
    put unformat '"' wc_wkctr '" "gsa01"' skip.
    put unformat '-' skip.
    put unformat '10' skip.
    put unformat '"NO" "023000" "030000" "020000" "213000" "220000" "000000" "233000" 0 "D"' skip.
    put unformat '@@end' skip.
    put unformat '@@batchload xxlnwkmt.p' skip. 
    put unformat '"' wc_wkctr '" "gsa01"' skip. 
    put unformat '-' skip. 
    put unformat '12' skip. 
    put unformat '"NO" "034500" "070000" "030000" "213000" "220000" "000000" "233000" 0 "D"' skip. 
    put unformat '@@end' skip. 
    put unformat '@@batchload xxlnwkmt.p' skip. 
    put unformat '"' wc_wkctr '" "gsa01"' skip. 
    put unformat '-' skip. 
    put unformat '14' skip. 
    put unformat '"NO" "071000" "085959" "040000" "213000" "220000" "000000" "233000" 0 "D"' skip. 
    put unformat '@@end' skip. 
    put unformat '@@batchload xxlnwkmt.p' skip. 
    put unformat '"' wc_wkctr '" "gsa01"' skip. 
    put unformat '-' skip. 
    put unformat '40' skip. 
    put unformat '"YES" "090000" "110000" "090000" "043000" "050000" "063000" "070000" 0 "D"' skip. 
    put unformat '@@end' skip. 
    put unformat '@@batchload xxlnwkmt.p' skip. 
    put unformat '"' wc_wkctr '" "gsa01"' skip. 
    put unformat '-' skip. 
    put unformat '50' skip. 
    put unformat '"YES" "110000" "114500" "110000" "063000" "070000" "083000" "090000" 0 "D"' skip. 
    put unformat '@@end' skip. 
    put unformat '@@batchload xxlnwkmt.p' skip. 
    put unformat '"' wc_wkctr '" "gsa01"' skip. 
    put unformat '-' skip. 
    put unformat '52' skip. 
    put unformat '"YES" "124000" "140000" "110000" "063000" "070000" "083000" "090000" 0 "D"' skip. 
    put unformat '@@end' skip. 
    put unformat '@@batchload xxlnwkmt.p' skip. 
    put unformat '"' wc_wkctr '" "gsa01"' skip. 
    put unformat '-' skip. 
    put unformat '60' skip. 
    put unformat '"YES" "140000" "150000" "140000" "090000" "100000" "113000" "120000" 0 "D"' skip. 
    put unformat '@@end' skip. 
    put unformat '@@batchload xxlnwkmt.p' skip. 
    put unformat '"' wc_wkctr '" "gsa01"' skip. 
    put unformat '-' skip. 
    put unformat '62' skip. 
    put unformat '"YES" "151000" "161000" "140000" "090000" "100000" "113000" "120000" 0 "D"' skip. 
    put unformat '@@end' skip. 
    put unformat '@@batchload xxlnwkmt.p' skip. 
    put unformat '"' wc_wkctr '" "gsa01"' skip. 
    put unformat '-' skip. 
    put unformat '70' skip. 
    put unformat '"YES" "161000" "181000" "160000" "113000" "120000" "133000" "140000" 0 "D"' skip. 
    put unformat '@@end' skip. 
    put unformat '@@batchload xxlnwkmt.p' skip. 
    put unformat '"' wc_wkctr '" "gsa01"' skip. 
    put unformat '-' skip. 
    put unformat '80' skip. 
    put unformat '"YES" "181000" "200000" "180000" "133000" "140000" "153000" "160000" 0 "D"' skip. 
    put unformat '@@end' skip. 
    put unformat '@@batchload xxlnwkmt.p' skip. 
    put unformat '"' wc_wkctr '" "gsa01"' skip. 
    put unformat '-' skip. 
    put unformat '90' skip. 
    put unformat '"YES" "201000" "220000" "200000" "153000" "160000" "173000" "180000" 0 "D"' skip. 
    put unformat '@@end' skip. 
    put unformat '@@batchload xxlnwkmt.p' skip. 
    put unformat '"' wc_wkctr '" "gsa01"' skip. 
    put unformat '-' skip. 
    put unformat '100' skip. 
    put unformat '"YES" "221000" "233000" "220000" "173000" "180000" "193000" "200000" 0 "D"' skip. 
    put unformat '@@end' skip. 
    put unformat '@@batchload xxlnwkmt.p' skip. 
    put unformat '"' wc_wkctr '" "gsa01"' skip. 
    put unformat '-' skip. 
    put unformat '110' skip. 
    put unformat '"YES" "233000" "235959" "220000" "173000" "180000" "193000" "200000" 0 "D"' skip. 
    put unformat '@@end' skip. 
    put unformat '@@batchload xxlnwkmt.p' skip. 
    put unformat '"' wc_wkctr '" "gsa01"' skip. 
    put unformat '-' skip. 
    put unformat '120' skip. 
    put unformat '"YES" "000000" "001000" "220000" "173000" "180000" "193000" "200000" 0 "D"' skip. 
    put unformat '@@end' skip. 
    put unformat '@@batchload xxlnwkmt.p' skip. 
    put unformat '"' wc_wkctr '" "gsa01"' skip. 
    put unformat '-' skip. 
    put unformat '130' skip. 
    put unformat '"YES" "002000" "022000" "000000" "193000" "200000" "213000" "220000" 0 "D"' skip. 
    put unformat '@@end' skip. 
end.
output close
