output to "20090427test.txt" .

for each xpk_mstr where xpk_nbr >= "00000262" no-lock:
disp xpk_nbr xpk__int01 xpk_sonbr xpk_soline xpk_part .
end.

output close .


