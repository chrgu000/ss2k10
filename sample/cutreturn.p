/*例子-把物料说明中的换行符或回车符去掉*/
/* chr(10)  不值转换成ascii字符*/
/* asc("A") 把字符转换成ascii值*/

define var i as integer.
define var desc1 as character.
define var desc2 as character.
for each pt_mstr :
    desc1 = "".
    do i = 1 to length(pt_desc1) :
       if asc(substring(pt_desc1,i,1,"RAW")) <> 10 and
          asc(substring(pt_desc1,i,1,"RAW")) <> 13 then do:
          desc1 = desc1 + substring(pt_desc1,i,1,"RAW")
       end.
    end.
    pt_desc1 = desc1.
    desc2 = "".
    do i = 1 to length(pt_desc2) :
       if asc(substring(pt_desc2,i,1,"RAW")) <> 10 and
          asc(substring(pt_desc2,i,1,"RAW")) <> 13 then do:
         desc2 = desc2 + substring(pt_desc2,i,1,"RAW")
       end.
    end.
    pt_desc2 = desc2.
end.
