/* Creation: eb2 sp11  chui  modified: 12/10/06   BY: Kaine Zhang  *ss-20061210.1*            */

    OUTPUT TO VALUE(strPrtInvInputFileName) .
    
    PUT
        "~"" AT 1   xxshd_so_nbr FORMAT "x(8)" "~"" " "
        "~""   xxshd_so_nbr FORMAT "x(8)" "~"" " "
        "- - - - - - - - "
        xxshm_date
        " n n n y - - - - y y n -"
        SKIP
        "~"" AT 1 "SsCimInv" "~"" " "
        "-"
        SKIP
        "y" AT 1
        .
    
    OUTPUT CLOSE .
    
    
    
    INPUT FROM VALUE(strPrtInvInputFileName) .
    OUTPUT TO VALUE(strPrtInvOutputFileName) .
    batchrun = YES.
    {gprun.i ""sosorp10.p""}
    batchrun = NO.
    INPUT CLOSE.
    OUTPUT CLOSE.
    
    OS-DELETE VALUE(strPrtInvInputFileName) .
	OS-DELETE VALUE(strPrtInvOutputFileName) .

    