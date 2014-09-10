/* xxschld0.p - load temp-work file from csv file                             */

{mfdeclre.i}
{yyschld.i}
define variable i as integer.
define variable vc as character.
define variable old-dte-fmt as character.
empty temp-table xsch_data no-error.

assign i = 1.
input from value(flhload).
repeat:
    create xsch_data.
    import unformat xsd_data.
    assign xsd_sn = i.
    assign i = i + 1.
end.
input close.

/*get MaxEntry.*/
find first xsch_data no-lock where index(xsd_data,",") > 0 no-error.
if available xsch_data then do:
   assign vc = xsd_data
          maxEntry = 0.
   repeat while vc <> "":
      maxEntry = maxEntry + 1.
      if index(vc,",") > 0 then do:
         assign vc = substring(vc,index(vc,",") + 1).
      end.
      else do:
         assign vc = "".
      end.
   end.
end.
/****
old-dte-fmt = session:date-format.
session:date-format = 'mdy'.
for each xsch_data no-lock where xsd_sn = 1:
  do i = 5 to MaxEntry:
     message date(entry(i,xsd_data,",")) view-as alert-box.
  end.
end.
session:date-format = old-dte-fmt.
****/
for each xsch_data exclusive-lock where xsd_sn >= 3:
    find first scx_ref no-lock where scx_domain = global_domain and
               scx_type = 1 and
               scx_order = entry(4,xsd_data,",") and 
               scx_part = entry(1,xsd_data,",") no-error.
    if not available scx_ref then do:
       assign xsd_chk = "¶©µ¥²»´æÔÚ.".
       next.
    end.
    else do:
       xsd_line = scx_line.
    end.
    
end.