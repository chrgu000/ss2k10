/*CIM_LOAD and check cim result.*/

{mfdeclre.i}
{xxsocnimp.i}
  define variable stat as logical.
  DEFINE VARIABLE cfile AS CHARACTER.
  define variable errmsg as character.
  define variable trrecid as recid.
  define variable trref as integer.
  define variable ret as character.
  define stream bf.
FOR EACH xsc_d WHERE xsd_chk = "PASS":
    ASSIGN cfile = execname + "." + STRING(xsd_sn,"99999999").
    OUTPUT STREAM bf TO VALUE(cfile + ".bpi").
    PUT STREAM bf UNFORMAT '"' xsd_ship '" "' xsd_cust '"' SKIP.
    PUT STREAM bf UNFORMAT '- - - - - - "' xsd_so '" "' xsd_so '" "' xsd_part '" "' xsd_part '" '.
    PUT STREAM bf UNFORMAT xsd_line ' "' xsd_site '" "' xsd_loc '" ' xsd_eff SKIP.
    PUT STREAM bf UNFORMAT '-' SKIP.
    PUT STREAM bf UNFORMAT '"' xsd_part '"' SKIP.
    PUT STREAM bf UNFORMAT xsd_qty_used ' - "' xsd_lot '" "' xsd_ref '" N' SKIP.
    PUT STREAM bf UNFORMAT '- - ' xsd_eff SKIP.
    PUT STREAM bf UNFORMAT 'N' SKIP.
    PUT STREAM bf UNFORMAT 'Y' SKIP.
    PUT STREAM bf UNFORMAT '.' SKIP.
    OUTPUT STREAM bf CLOSE.
    assign trrecid = current-value(tr_sq01).

    input from value(cfile + ".bpi").
    output to value(cfile + ".bpo") keep-messages.
    hide message no-pause.
    batchrun  = yes.
    {gprun.i ""xxsocnuac.p""}
    batchrun  = no.
    hide message no-pause.
    output close.
    input close.
    stat = no.
    FIND FIRST tr_hist NO-LOCK WHERE tr_domain = GLOBAL_domain
           and tr_trnbr > integer(trrecid) AND tr_type = "CN-USE"
           and tr_part = xsd_part and tr_effdate = xsd_eff
           and tr_site = xsd_site and tr_loc = xsd_loc
           and tr_so_job = xsd_so and tr_line = xsd_line no-error.
    IF AVAILABLE tr_hist then do:
       assign trref = integer(tr_rmks)
              ret = string(tr_trnbr).
       find first tr_hist no-lock where tr_domain = global_domain
              and tr_trnbr = trref and tr_type = "ISS-SO"
              and tr_part = xsd_part and tr_effdate = xsd_eff
              and tr_site = xsd_site and tr_loc = xsd_loc
              and tr_qty_loc = - xsd_qty_used no-error.
       if available tr_hist then do:
          assign stat = yes.
          assign xsd_chk = "[CN-USE:" + ret + "]-[ISS-SO:" + string(tr_trnbr)+ "]".
          os-delete value(cfile + ".bpi").
          os-delete value(cfile + ".bpo").
       end.
    end.
    if stat = no then do:
        errmsg  = "".
        cfile = cfile + ".bpo".
       {gprun.i ""xxgetcimerr.p"" "(input cfile,output errmsg)"}
       assign xsd_chk = "CIM´íÎó:" + errmsg.
    end.
END.