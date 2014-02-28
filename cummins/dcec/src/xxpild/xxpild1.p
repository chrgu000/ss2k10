/* xxpold0.p - import from xls                                            */
{mfdeclre.i}
{xxpild.i}
DEFINE VARIABLE i AS INTEGER.
assign i  = 0.
FOR EACH xxtmppi EXCLUSIVE-LOCK:
    assign i = i + 1.
    assign xxpi_sn = i.
    if xxpi_start < today then do:
       assign xxpi_chk = getMsg(728).
       next.
    end.
END.
