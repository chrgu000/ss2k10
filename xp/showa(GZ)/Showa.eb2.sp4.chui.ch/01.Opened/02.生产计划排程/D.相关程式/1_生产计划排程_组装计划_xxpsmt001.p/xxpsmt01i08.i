    /*********************************************
        假设某产线可排程ABC三个机种,B机种本次是否排程,会影响AC的顺序,
        所以,需要先排程(xln_used = yes),再根据已排产的机种计算顺序,
        但是生产顺序又先影响产能时间,每次要重新算! ??????
    *********************************************/

    
    
    
    /*计算每个产线的最优排产顺序*/
    for each xln_det 
        where xln_site = site
        and   xln_used = yes /*限:已排程的机种,所以xxpsmt01i08.i这里不会执行*/
        break by xln_site by xln_line :
        if last-of(xln_line) then do:
            {gprun.i ""xxpsmt01p02.p""  "(input xln_site, input xln_line)"}
        end.
    end. /* for each xln_det */
