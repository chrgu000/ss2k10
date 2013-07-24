define input parameter xxdate as character .
define output parameter xxoutdate as date .
define output parameter errmsg as character format "x(30)" .

define variable xxyear as character .
define variable xxmonth as character .
define variable xxday as character .
define variable xxdate1 as character .
define variable xxcount as integer .


xxdate1 = xxdate .
xxcount = index(xxdate1, ".") .
xxyear = substring(xxdate1,1,xxcount - 1) .

xxdate1 = substring(xxdate1,xxcount +  1) .
xxcount = index(xxdate1, ".") .
xxmonth = substring(xxdate1,1,xxcount - 1) .

xxdate1 = substring(xxdate1,xxcount +  1) .
xxcount = index(xxdate1, ".") .
xxday = substring(xxdate1,1,xxcount - 1) .

errmsg = "" .
xxoutdate = date(trim(xxday) + "/" + trim(xxmonth) + "/" + trim(xxyear)) no-error .

if xxoutdate = ? then errmsg = "日期格式不正确或日期不正确" .
