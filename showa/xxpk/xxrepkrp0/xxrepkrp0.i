
procedure getSEtime:
    define input parameter iType as character.
    define input parameter iSite as character.
    define input parameter iLine as character.
    define input parameter iRuntime as integer.
    define output parameter ostime as integer.
    define output parameter oetime as integer.
    find first xxlnw_det no-lock where xxlnw_site = isite and
              (xxlnw_line = iLine or iLine = "") and
               xxlnw_ptime = iRunTime no-error.
    if available xxlnw_det then do:
       if iType = "p" then do:
          assign ostime = xxlnw_pstime
                 oetime = xxlnw_petime.
       end.
       else do:
          assign ostime = xxlnw_sstime
                 oetime = xxlnw_setime.
       end.
    end.
end procedure.
