/* xxrspold.p - rspoamt.p 2+  cim_load                                       */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

{mfdeclre.i}
{xxrspold.i}
define variable vfile as character.
define variable vchk as character no-undo.
define stream bf.

for each xxtmp exclusive-lock where xx_chk = ""
    break by xx_site by xx_part by xx_eff:
    if first-of(xx_eff) then do:
       assign vfile = execname + "." + mfguser + "." + string(xx_sn,"999999").
       output stream bf to value(vfile + ".bpi").
       put stream bf unformat '"' xx_site '" "' xx_part '" ' xx_eff skip.
    end.
       put stream bf unformat '"' xx_po '"' skip.
       put stream bf trim(string(xx_pct)) skip.
    if last-of(xx_eff) then do:
        put stream bf unformat '.' skip.
        output stream bf close.
        cimrunprogramloop:
        do transaction:
           message xx_sn "/" maxsn.
           input from value(vfile + ".bpi").
           output to value(vfile + ".bpo") keep-messages.
           hide message no-pause.
           batchrun = yes.
           {gprun.i ""rspoamt.p""}
           batchrun = no.
           hide message no-pause.
           output close.
           input close.
           os-delete value(vfile + ".bpi").
           os-delete value(vfile + ".bpo").
           find first qad_wkfl no-lock where qad_domain = global_domain
                  and qad_key1 = "poa_det" and  qad_charfld[3] = xx_site
                  and qad_charfld[2] = xx_part and  qad_charfld[1] = xx_po
                  and qad_datefld[1] = xx_eff no-error.
           if available qad_wkfl then do:
              assign xx_chk = "OK".
           end.
           else do:
              assign xx_chk = "CIM_ERR".
           end.
        end.
    end.
end.
