/*xxextrl.i - expri contrl                                                   */
/* if chkExpir() then do:                                                    */
/*     {pxmsg.i &MSGNUM=2261 &ERRORLEVEL=2}                                  */
/*     undo, retry.                                                          */
/* end.                                                                      */

define variable ctrli       as integer.
define variable ctrldomain  as character initial 'xxextrl'.
define variable ctrlkey1    as character initial 'acs005'.
define variable ctrlkey2    as character initial 'acs005'.

procedure setExpir:
  define input parameter ifld     as integer.  /*0 qad_charfld;1 qad_charfld1*/
  define input parameter arrayidx as integer.
  define input parameter iprogram as character.
  define input parameter idate    as date.
  find first qad_wkfl exclusive-lock where qad_wkfl.qad_domain = ctrldomain
         and qad_wkfl.qad_key1 = ctrlkey1 and qad_wkfl.qad_key2 = ctrlkey2
         no-error.
  if not available qad_wkfl then do:
     create qad_wkfl.
     assign qad_wkfl.qad_domain = "xxextrl"
            qad_wkfl.qad_key1 = "acs005"
            qad_wkfl.qad_key2 = "acs005".
  end.
  if ifld = 1 then do:
     assign qad_wkfl.qad_charfld1[arrayidx] = iprogram + ';'
                    + string(month(idate),"99") + ","
                    + string(day(idate),"99") + ","
                    + string(year(idate),"9999").
  end.
  else do:
  assign qad_wkfl.qad_charfld[arrayidx] = iprogram + ';'
                 + string(month(idate),"99") + ","
                 + string(day(idate),"99") + ","
                 + string(year(idate),"9999").
  end.
end procedure.

function chkExpir returns integer(programname as character):
   define variable datechar as character.
   find first qad_wkfl no-lock where qad_wkfl.qad_domain = ctrldomain
          and qad_wkfl.qad_key1 = ctrlkey1 and qad_wkfl.qad_key2 = ctrlkey2
          no-error.
   if available qad_wkfl then do:
      do ctrli = 1 to 15:
         assign datechar = "".
         if entry(1,qad_wkfl.qad_charfld[ctrli],";") = programname then do:
            assign datechar = entry(2,qad_wkfl.qad_charfld[1],";").
         end.
         if entry(1,qad_wkfl.qad_charfld1[ctrli],";") = programname then do:
            assign datechar = entry(2,qad_wkfl.qad_charfld1[1],";").
         end.
         if datechar <> "" then do:
            return date(integer(entry(1,datechar,",")),
                        integer(entry(2,datechar,",")),
                        integer(entry(3,datechar,","))) - today.
            leave.
         end.
      end.
   end.
   return -1.
end.

procedure getExpir:
   find first qad_wkfl no-lock where qad_wkfl.qad_domain = ctrldomain
       and qad_wkfl.qad_key1 = ctrlkey1 and qad_wkfl.qad_key2 = ctrlkey2
       no-error.
   if available qad_wkfl then do:
      do ctrli = 1 to 15:
      	 display ctrli replace(qad_wkfl.qad_charfld[ctrli],",","10")
      	  replace(qad_wkfl.qad_charfld[ctrli],",","35") .
/*         put unformat ctrli ";"                                            */
/*                qad_wkfl.qad_domain  ";"                                   */
/*                replace(qad_wkfl.qad_charfld[ctrli],",",";") ";"           */
/*                qad_wkfl.qad_key1 ";"                                      */
/*                replace(qad_wkfl.qad_charfld1[ctrli],",",";") ";"          */
/*                qad_wkfl.qad_key2.                                         */
      end.
      pause 100.
   end.
end procedure.

procedure delExpir:
   find first qad_wkfl exclusive-lock where qad_wkfl.qad_domain = ctrldomain
       and qad_wkfl.qad_key1 = ctrlkey1 and qad_wkfl.qad_key2 = ctrlkey2
       no-error.
   if available qad_wkfl then do:
      delete qad_wkfl.
   end.
end procedure.
