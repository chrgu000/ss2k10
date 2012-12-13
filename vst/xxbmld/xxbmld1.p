/* xxinvld.p - bom load                                                      */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120703.1 LAST MODIFIED: 07/03/12 BY:                            */
/* REVISION END                                                              */
{mfdeclre.i}
{xxbmld.i}
define variable vfile as character.
define variable vi as integer.
define stream xp.
assign vi = 1.
for each tmpbomn exclusive-lock:
    assign tbmn_sn = vi.
    assign vi = vi + 1.
end.
vi = vi - 1.
for each tmpbomn no-lock:
find first ps_mstr no-lock where ps_par = tbmn_par and ps_comp = tbmn_comp
       and ps_ref = tbmn_ref and ps_start = tbmn_start and tbmn_end = ps_end no-error.
if available ps_mstr then do:
   next.
end.
if cloadfile then do:
assign vfile = "xxbmld.p." + string(tbmn_sn,"9999999999").
output stream xp to value(vfile + ".bpi").
    put stream xp unformat '"' tbmn_par '"' skip.
    put stream xp unformat '"' tbmn_comp '" "' tbmn_ref '" ' tbmn_start skip.
    put stream xp unformat tbmn_qty_per ' - - ' tbmn_end ' - ' tbmn_scrp.
             put stream xp ' - - - - - - N' skip.
    put stream xp "." skip.
output stream xp close.
       batchrun = yes.
       input from value(vfile + ".bpi").
       output to value(vfile + ".bpo") keep-messages.
       hide message no-pause.
       cimrunprogramloop:
       do on stop undo cimrunprogramloop,leave cimrunprogramloop:
          {gprun.i ""bmpsmt.p""}
       end.
       hide message no-pause.
       output close.
       input close.
       batchrun = no.
       find first code_mstr no-lock where
                  code_fldname = "KEEP_Temp_WorkFile" and
                  code_value = "YES|OTHER" no-error.
       if (available code_mstr and code_cmmt <> "Yes") or
          not available code_mstr then do:
             os-delete value(vfile + ".bpi").
             os-delete value(vfile + ".bpo").
       end.
/*       {pxmsg.i &MSGNUM=776 &MSGARG1=tbmn_sn &MSGARG2=vi &ERRORLEVEL=1} */

end.   /* if cloadfile then do: */
end.

for each tmpbomn exclusive-lock:
    find first ps_mstr no-lock where ps_par = tbmn_par
           and ps_comp = tbmn_comp and ps_ref = tbmn_ref
           and ps_start = tbmn_start and ps_end = tbmn_end 
           and ps_qty_per = tbmn_qty_per and ps_scrp_pct = tbmn_scrp no-error.
    if available ps_mstr then do:
       assign tbmn_chk = "OK".
    end.
    else do:
       assign tbmn_chk = "Fail".
    end.
end.
