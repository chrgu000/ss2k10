find first xbmd_det 
    where xbmd_domain = global_domain 
    and   xbmd_lot    = {&lot}  
    /*
    and   xbmd_par    = {&part}   
    and   xbmd_wolot  = {&wolot} */ 
    and   xbmd_comp   = {&comp}
exclusive-lock no-error.
if not avail xbmd_det then do:
    create  xbmd_det.
    assign  xbmd_domain   = global_domain 
            xbmd_lot      = {&lot}     
            xbmd_par      = {&part}     
            xbmd_wolot    = {&wolot}   
            xbmd_comp     = {&comp}     
            xbmd_comp2    = {&compby}  
            xbmd_qty_bom  = {&qtybom}
            xbmd_sn       = {&sn}
            xbmd_hide     = if {&hide} = yes then "Y" else ""
            .
end.
else do:
    xbmd_qty_bom  = xbmd_qty_bom + {&qtybom} .
end.