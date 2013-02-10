/* xxrspold.p - rspoamt.p 2+  cim_load                                       */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */
{mfdeclre.i}
{xxrspold.i}
{xxloaddata.i}
define variable txt as character.
define variable i as integer.
define variable pct as decimal.
empty temp-table xxtmp no-error.
input from value(flhload).
repeat:
    import unformat txt.
    if entry(1,txt,",") <= "ZZZZZZZZZZZZ" and entry(1,txt,",") <> ""
       and decimal(entry(5,txt,",")) <> 0 then do:
       create xxtmp.
       assign xx_site = entry(1,txt,",") no-error.
       assign xx_part = entry(2,txt,",") no-error.
       assign xx_eff  = str2Date(entry(3,txt,","),"dmy") no-error.
       assign xx_po = entry(4,txt,",") no-error.
       assign xx_pct = decimal(entry(5,txt,",")) no-error.
    end.
end.
input close.

i = 0.
for each xxtmp exclusive-lock break by xx_site by xx_part by xx_eff:
    if first-of(xx_eff) then do:
       assign i = i + 1.
    end.
    assign xx_sn = i.
    if first-of(xx_eff) then do:
       assign pct = 0.
    end.
    assign pct = pct + xx_pct.
    if last-of(xx_eff) then do:
       if pct <> 100 then do:
          assign xx_chk = "not 100%".
       end.
    end.
end.
ASSIGN maxsn = I.
for each xxtmp exclusive-lock
      break by xx_site by xx_part by xx_eff by xx_chk desc:
    if first-of(xx_eff) then do:
       assign txt = "".
    end.
    if first-of(xx_eff) and xx_chk <> "" then do:
       assign txt = xx_chk.
    end.
    if not first-of(xx_eff) and txt <> "" then do:
       assign xx_chk = txt.
    end.
end.
