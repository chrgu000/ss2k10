/* xxdf2tab.p - convert .df file to csv format                               */
/* revision: 131011.1   created on: 20131011   by: zhang yun                 */

/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "3AYC"}

define variable del-yn like mfc_logical initial no.
define variable v_key as character initial "-CTRL".
define variable vadd1 as character.
define variable vadd2 as character.
define variable vadd3 as character.
define variable vadd4 as character.
define variable inti  as integer.
define variable intj  as integer.
{gpcdget.i "UT"}

define temp-table xxtd
       fields xd_data as character format "x(80)"
       fields xd_key1 as character format "x(18)"
       fields xd_key2 as character format "x(18)"
       fields xd_key3 as character format "x(18)"
       fields xd_key4 as character format "x(18)"
       fields xd_ppt as character format "x(16)"
       fields xd_val as character format "x(20)"
       fields xd_test as character.

define temp-table xxt0
       fields xt_type as character
       fields xt_tab as character format "x(16)"
       fields xt_fld as character format "x(24)"
       fields xt_ord as character format "x(8)"
       fields xt_lab as character format "x(40)"
       fields xt_clab as character format "x(40)"
       fields xt_fldtp as character format "x(12)"
       fields xt_fmt  as character format "x(18)"
       fields xt_desc as character format "x(60)"
       fields xt_ext  as character format "x(6)"
       fields xt_valexp as character format "x(60)"
       fields xt_valmsg as character format "x(60)"
       fields xt_ini as character format "x(20)"
       fields xt_sn as integer
       index xt_idx1 is primary xt_type xt_tab xt_fld
       index xt_idx2 xt_type xt_tab xt_ord.

assign v_key = upper(execName + v_key).

/* DISPLAY SELECTION FORM */
form
/*   usrw_key1 colon 16 format "x(20)"                                       */
/*   usrw_key2 colon 16 format "x(20)" skip(1)                               */
   usrw_key3 colon 16 format "x(180)" view-as fill-in size 40 by 1 skip(2)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

find usrw_wkfl exclusive-lock where usrw_key1 = v_key and
     usrw_key2 = v_key no-error.
if available usrw_wkfl then do:
   display usrw_key3 with frame a.
end.
else do:
   display "" @ usrw_key3.
end.
/* DISPLAY */
view frame a.

{wbrp01.i}
/* {xxchklv.i 'MODEL-CAN-RUN' 10} */
mainloop:
repeat with frame a:
   for each xxtd exclusive-lock: delete xxtd. end.
   for each xxt0 exclusive-lock: delete xxt0. end.

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
        update usrw_key3 with frame a.
   end.

   {wbrp06.i &command = update &fields = " usrw_key3" &frm = "a"}

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 460
               &pagedFlag = " nopage "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
    assign vadd1 = ""
           vadd2 = ""
           vadd3 = ""
           vadd4 = "" .
   do on error undo, retry:

   find usrw_wkfl exclusive-lock where usrw_key1 = v_key and
        usrw_key2 = v_key no-error.

   if not available usrw_wkfl then do:
      create usrw_wkfl.
      assign usrw_key1 = v_key
             usrw_key2 = v_key.
   end.

   display usrw_key3 with frame a.

   if search(usrw_key3) = ? or search(usrw_key3) = "" then do:
      {mfmsg.i 53 3}
      undo,retry.
   end.

end.
    input from value(usrw_key3).
    repeat:
        import unformat vadd1.
        if trim(vadd1) = "." or trim(vadd1) = "PSC"  then leave.
        if trim(vadd1) = "" then next.
        create xxtd.
        assign xd_data = trim(vadd1).
    end.
    input close.

    for each xxtd exclusive-lock by recid(xxtd):
        if index(xd_data,"ADD TABLE") > 0 then do:
            assign vadd1 = "TABLE"
                   vadd2 = entry(3,xd_data," ")
                   vadd3 = ""
                   vadd4 = "" .
            if substring(vadd2,1,1) = '~"' then do:
               assign vadd2 = substring(vadd2,2,length(vadd2) - 2).
            end.
        end.
        if index(xd_data,"ADD FIELD") > 0 or index(xd_data,"ADD INDEX") > 0 then do:
           if trim(entry(2,xd_data," ")) = "FIELD" then do:
              assign vadd1 = entry(2,xd_data," ").
              assign vadd2 = entry(5,xd_data," ").
              assign vadd3 = entry(3,xd_data," ").
              assign vadd4 = entry(7,xd_data," ").
           end.
           else do:
              assign vadd1 = entry(2,xd_data," ").
              assign vadd2 = entry(5,xd_data," ").
              assign vadd3 = entry(3,xd_data," ").
              assign vadd4 = "".
           end.
           if substring(vadd1,1,1) = '~"' then do:
              assign vadd1 = substring(vadd1,2,length(vadd1) - 2).
           end.
           if substring(vadd2,1,1) = '~"' then do:
              assign vadd2 = substring(vadd2,2,length(vadd2) - 2).
           end.
           if substring(vadd3,1,1) = '~"' then do:
              assign vadd3 = substring(vadd3,2,length(vadd3) - 2).
           end.
           if substring(vadd4,1,1) = '~"' then do:
              assign vadd4 = substring(vadd4,2,length(vadd4) - 2).
           end.
        end.
        else do:
           assign xd_key1 = vadd1
                  xd_key2 = vadd2
                  xd_key3 = vadd3
                  xd_key4 = vadd4.
           if index(xd_data," ") > 0 then do:
              assign xd_ppt = entry(1,xd_data," ")
                     xd_val = trim(substring(xd_data,index(xd_data," "))).
              if xd_ppt = "INDEX-FIELD" then do:
                   assign xd_key4 = trim(substring(xd_val,index(xd_val," ")))
                          xd_val = entry(1,trim(xd_val)," ").
              end.
           end.
           else do:
              assign xd_ppt = xd_data
                     xd_val = xd_data.
           end.
           if substring(xd_val,1,1) = '~"' then do:
              assign xd_val = substring(xd_val,2,length(xd_val) - 2).
           end.
          end.
    end.
    assign intj = 0.
    for each xxtd no-lock where xd_key1 = "FIELD":
        assign intj = intj + 1.
        find first xxt0 exclusive-lock where xt_type = xd_key1 and
                   xt_tab = xd_key2 and xt_fld = xd_key3 no-error.
        if not available xxt0 then do:
           create xxt0.
           assign xt_tab = xd_key2
                  xt_fld = xd_key3
                  xt_type = xd_key1
                  xt_sn = intj.
        end.
        assign xt_fldtp = xd_key4.
        case xd_ppt :
             when "Description" then assign xt_desc = xd_val.
             when "FORMAT" then assign xt_fmt = xd_val.
             when "INITIAL" then assign xt_ini = xd_val.
             when "LABEL" then assign xt_lab = xd_val xt_clab = xd_val.
             when "COLUMN-LABEL" then assign xt_clab = xd_val.
             when "ORDER" then assign xt_ord = xd_val.
             when "EXTENT" then assign xt_ext = xd_val.
             when "VALEXP" then assign xt_valexp = xd_val.
             when "VALMSG" then assign xt_valmsg = xd_val.
             /*
             when "DECIMALS" then assign = xd_val.
             when "LENGTH" then assign = xd_val.
             when "MANDATORY" then assign = xd_val.
             when "MAX-WIDTH" then assign = xd_val.
             when "POSITION" then assign = xd_val.
             when "VALMSG-SA" then assign = xd_val.
             */
        end case.

    end.
   inti = 0.
   for each xxtd no-lock where xd_key1 = "INDEX" by recid(xxtd):
       if xd_key4 = "" then do:
          case xd_ppt:
               when "AREA" then do:
                    assign vadd1 = xd_val
                           vadd2 = "NO"
                           vadd3 = "NO"
                           vadd4 = "".
               end.
               when "PRIMARY" then assign vadd2 = "YES".
               when "UNIQUE" then assign vadd3 = "YES".
          end case.
       end.
       else do:
          case xd_ppt:
               when "INDEX-FIELD" then do:
                    inti = inti  + 1.
                    vadd4 = xd_key4.
                    find first xxt0 exclusive-lock where xt_type = xd_key1 and
                               xt_tab = xd_key2 and xt_fld = xd_key3 and
                               xt_ini = string(inti,"99999999") no-error.
                    if not available xxt0 then do:
                       create xxt0.
                       assign xt_tab = xd_key2
                              xt_fld = xd_val
                              xt_type = xd_key1
                              xt_ini = string(inti,"99999999").
                    end.
                    assign xt_valexp = xd_key3
                           xt_fldtp = vadd2
                           xt_fmt = vadd3
                           xt_lab = vadd1
                           xt_clab = vadd4.
               end.
          end case.
       end.
   end.

    for each xxtd no-lock where xd_key1 = "TABLE":
        find first xxt0 where xt_type = xd_key1 and xt_tab = xd_key2
                          and xt_fld = xd_key2 no-error.
        if not available xxt0 then do:
           create xxt0.
           assign xt_type = xd_key1
                  xt_tab = xd_key2
                  xt_fld = xd_key2
                  xt_sn = recid(xxtd).
        end.
        if xd_ppt = "DESCRIPTION" then do:
           assign xt_valexp = xd_val.
        end.
        if xd_ppt = "AREA" then do:
           assign xt_valmsg = xd_val.
        end.
    end.

    for each xxt0 no-lock where xt_type = "TABLE" by xt_sn:
        export delimiter "~t" xt_tab xt_valexp xt_valmsg.
    end.
    page.
    put skip.
    for each xxt0 no-lock where xt_type = "FIELD" by xt_sn:
        export delimiter "~t" xt_tab xt_fld xt_lab xt_fldtp xt_fmt
                              xt_desc xt_ext xt_valexp xt_valmsg xt_ini.
    end.
    page.
    put skip.
    for each xxt0 no-lock where xt_type = "INDEX" by xt_ini:
        export delimiter "~t" xt_valexp xt_fldtp xt_fmt xt_lab xt_tab xt_fld xt_clab.
    end.
    {mfreset.i}
end.
{wbrp04.i &frame-spec = a}
