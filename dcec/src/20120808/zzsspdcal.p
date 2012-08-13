/*zzsspdcal.p to calculate the period, By: Kevin, 11/24/2003*/

def shared var start like tr_effdate.
def shared var sdate as date extent 7.
def shared var edate as date extent 7.
def var i as inte.
def var fdate like tr_effdate.

sdate[1] = date(month(start),1,year(start)).


if weekday(sdate[1]) = 7 then do:
    sdate[1] = sdate[1] + 2.
    edate[1] = sdate[1] + 6.
    fdate = sdate[1].
    sdate[2] = sdate[1] + 7.
    edate[2] = edate[1] + 7.
end.    
else if weekday(sdate[1]) = 1 then do:
    sdate[1] = sdate[1] + 1.
    edate[1] = sdate[1] + 6.
    fdate = sdate[1].
    sdate[2] = sdate[1] + 7.
    edate[2] = edate[1] + 7.    
end.    
else do:
    sdate[1] = sdate[1].
    fdate = sdate[1] - weekday(sdate[1]) + 2.
    sdate[2] = fdate + 7.
    edate[1] = sdate[2] - 1.
    edate[2] = edate[1] + 7.
end.     

Do i = 3 to 5:
    sdate[i] = sdate[i - 1] + 7.
    edate[i] = edate[i - 1] + 7.
end.


if sdate[5] <> ? then do:
    if month(sdate[5]) <> month(sdate[4]) then do:
        sdate[5] = ?.
        edate[5] = ?.
    end.
    else do:
        if month(edate[5]) <> month(edate[4]) then do:
            edate[5] = date(month(edate[5]),1,year(edate[5])) - 1.
        end.
    end.
end.
else do:
    if month(sdate[4]) <> month(sdate[3]) then do:
        sdate[4] = ?.
        edate[4] = ?.
    end.
    else do:
        if month(edate[4]) <> month(edate[3]) then do:
            edate[4] = date(month(edate[4]),1,year(edate[4])) - 1.
        end.
    end.    
end.

if month(sdate[4]) <> month(sdate[3]) then do:
    sdate[4] = ?.
    edate[4] = ?.
end.
else do:
    if month(edate[4]) <> month(edate[3]) then do:
        edate[4] = date(month(edate[4]),1,year(edate[4])) - 1.
    end.
end.    


/*for calculation the 6,7 period*/
define var date1 as date.
if sdate[5] <> ? then do:
    date1 = sdate[5].
end.
else do:
    date1 = sdate[4].
end.

if month(date1) = 12 then do:
    sdate[6] = date(1,1,year(date1) + 1).
    edate[6] = date(1,31,year(date1) + 1).
    sdate[7] = date(2,1,year(date1) + 1).
    edate[7] = date(3,1,year(date1) + 1) - 1.    
end.
else if month(date1) = 11 then do:
    sdate[6] = date(12,1,year(date1)).
    edate[6] = date(12,31,year(date1)).
    sdate[7] = date(1,1,year(date1) + 1).
    edate[7] = date(1,31,year(date1) + 1).        
end.
else do:
    sdate[6] = date(month(date1) + 1,1,year(date1)).
    sdate[7] = date(month(date1) + 2,1,year(date1)).
    edate[6] = sdate[7] - 1.
    if month(date1) <> 10 then edate[7] = date(month(date1) + 3,1,year(date1)) - 1.
    else edate[7] = date(12,31,year(date1)).
end.
     
