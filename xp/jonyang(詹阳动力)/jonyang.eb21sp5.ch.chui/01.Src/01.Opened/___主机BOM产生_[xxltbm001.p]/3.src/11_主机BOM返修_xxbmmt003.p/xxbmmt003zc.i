find first xbmzp_det 
    where xbmzp_domain = global_domain 
    and   xbmzp_lot    = {&lot}    
    /*
    and   xbmzp_par    = {&part}   
    and   xbmzp_wolot  = {&wolot} */ 
    and   xbmzp_zppart = {&zppart}
    and   xbmzp_comp   = {&comp}
exclusive-lock no-error.
if not avail xbmzp_det then do:
    create  xbmzp_det.
    assign  xbmzp_domain   = global_domain 
            xbmzp_lot      = {&lot}     
            xbmzp_par      = {&part}     
            xbmzp_wolot    = {&wolot}   
            xbmzp_zppart   = {&zppart}
            xbmzp_comp     = {&comp}     
            xbmzp_comp2    = {&compby}  
            xbmzp_qty_bom  = {&qtybom}
            xbmzp_sn       = {&sn}
            xbmzp_hide     = if {&hide} = yes then "Y" else ""
            xbmzp_zpwo     = {&zpwo}
            .
end.
else do:
    xbmzp_qty_bom  = xbmzp_qty_bom + {&qtybom} .
end.