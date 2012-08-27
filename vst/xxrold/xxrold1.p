/* xxrold.p - rwromt.p cim load                                              */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

{mfdeclre.i}
{xxrold.i}
define variable vfile as character.
define variable clearwkfl as logical initial yes no-undo.
define variable j as integer.

find first code_mstr no-lock where code_fldname = "Keep_Temp_WorkFile"
       and code_value = "YES|OTHER" and code_cmmt = "YES" no-error.
if available code_mstr then do:
    assign clearwkfl = no.
end.
for each xxro exclusive-lock where xxro_chk = "" by xxro_sn:
    assign vfile = "xxrold.p." + string(today,"9999-99-99")
                 + "." + string(xxro_sn,"9999999").
    output to value(vfile + ".bpi").
    put unformat '"' xxro_routing '" ' xxro_op ' ' xxro_start skip.
    find first pt_mstr no-lock where pt_part = xxro_routing no-error.
    if available pt_mstr then do:
       put '-' skip.
    end.
    put unformat '"' xxro_wkctr '" "' xxro_mch '"' skip.
    put unformat '"' xxro_desc '" - - - - - - - - - '.
    put unformat xxro_run ' - ' xxro_start ' ' xxro_end.
    put unformat ' - - - - - N' skip.
    put unformat '-' skip.
    output close.

    if cloadfile then do:
/*     {pxmsg.i &MSGNUM=776 &MSGARG1=xxro_sn &MSGARG2=i &ERRORLEVEL=1}       */
       batchrun = yes.
       input from value(vfile + ".bpi").
       output to value(vfile + ".bpo") keep-messages.
       hide message no-pause.
       cimrunprogramloop:
       do on stop undo cimrunprogramloop,leave cimrunprogramloop:
          {gprun.i ""rwromt.p""}
       end.
       hide message no-pause.
       output close.
       input close.
       batchrun = no.

       find first ro_det no-lock where ro_routing = xxro_routing
              and ro_op = xxro_op and ro_start = xxro_start no-error.
       if available ro_det and ro_end = xxro_end and ro_wkctr = xxro_wkctr
                and ro_mch = xxro_mch and ro_desc = xxro_desc
                and ro_run = xxro_run
       then do:
          assign xxro_chk = "OK".
       end.
       else do:
          assign xxro_chk = "FAIL".
       end.

       if clearwkfl then do:
          os-delete value(vfile + ".bpi").
          os-delete value(vfile + ".bpo").
       end.
    end.
end.
