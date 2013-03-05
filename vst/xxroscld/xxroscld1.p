/* xxrold.p - rwromt.p cim load                                              */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

{mfdeclre.i}
{xxroscld.i}
{xxloaddata.i}
define variable vfile as character.
define variable clearwkfl as logical initial yes no-undo.
define variable j as integer.
DEFINE STREAM xp.

assign clearwkfl = deltmpfile().
for each xxro exclusive-lock by xxro_sn:
    assign vfile = "xxrold.p." + string(today,"9999-99-99")
                 + "." + string(xxro_sn,"9999999").
    output STREAM xp to value(vfile + ".bpi").
    put STREAM xp unformat '"' xxro_routing '" ' xxro_op ' ' xxro_start skip.
    put STREAM xp unformat '-' skip.
    put STREAM xp unformat '- - - - - - - - - - - - - - - - - - ' xxro_sub_cost ' N' skip.
    output STREAM xp close.


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
       if available ro_det and ro_wkctr = xxro_wkctr
                and ro_sub_cost = xxro_sub_cost
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
