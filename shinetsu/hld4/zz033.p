/*Browse 里重复引用表mpd_det的解决方案*/
/* 引用 getdesc(substr(mpd_nbr,3)) */
/*
add calculate columns fields expression: getdesc(substr(mpd_nbr,3))
*/
def temp-table tt
   field tt_nbr as char
   field tt_desc as char format "x(20)".

for each mpd_det no-lock where mpd_domain = global_domain and
         mpd_nbr begins "XC" and
         mpd_type = "00001":
    find first tt where tt_nbr = substr(mpd_nbr,3) exclusive-lock no-error.
    if not avail tt then do:
       create tt.
       assign tt_nbr = substr(mpd_nbr,3).
    end.
    assign tt_desc = mpd_tol.
end.

function getdesc returns character(v_nbr as char):
    find first tt where tt_nbr = v_nbr no-lock no-error.
    if avail tt then return tt_desc.
end.
