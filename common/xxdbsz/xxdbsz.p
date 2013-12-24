/* xxmeiq.p - Menu INQUIRY                                                   */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 14Y2 LAST MODIFIED: 11/19/10   BY: zy                           */
/* REVISION: 17Y6 LAST MODIFIED: 11/19/10   BY: zy  #Add progName variable   */

{mfdtitle.i "23YT"}

define temp-table filelst
    fields fl_att  as character format "x(20)"
    fields fl_int  as character format "x(4)"
    fields fl_own  as character format "x(18)"
    fields fl_grp  as character format "x(18)"
    fields fl_sz   as character format "x(18)"
    fields fl_dte1  as character format "x(18)"
    fields fl_dte2  as character format "x(18)"
    fields fl_dte3  as character format "x(18)"
    fields fl_name as character format "x(48)"
    fields fl_sznum as decimal
    fields fl_szunit as character
    fields fl_sname as character format "x(14)"
    fields fl_namdn as integer.
define variable cmd as character initial "ls -lha ".
define variable dbdir as character format "x(40)".
form
   space(1)
       dbdir colon 12
   skip(1)
with frame a side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i} usrw_key1 = execname
       and usrw_key2 = global_userid no-error.
if available usrw_wkfl then do:
   assign dbdir = usrw_key3.
end.
display dbdir with frame a.
{wbrp01.i}
repeat:
   for each filelst exclusive-lock: delete filelst. end.
   empty temp-table filelst no-error.
   if c-application-mode <> 'web' then
      update dbdir with frame a.
   {wbrp06.i &command = update &fields = " dbdir " &frm = "a"}

    do transaction:
      find first usrw_wkfl exclusive-lock where {xxusrwdom.i} {xxand.i}
                 usrw_key1 = execname and
                 usrw_key2 = global_userid no-error.
      if not available usrw_wkfl then do:
         create usrw_wkfl.  {xxusrwdom.i}.
         assign usrw_key1 = execname
                usrw_key2 = global_userid.
      end.
       assign usrw_key3 = dbdir.
    end.
   assign cmd = cmd + dbdir + "/*.d[0-9]* > flst.tmp" .
   os-command value(cmd).
   input from value("flst.tmp").
      repeat:
         create filelst.
         import delimiter " " fl_att fl_int fl_own fl_grp fl_sz fl_dte1 fl_dte2 fl_dte3 fl_name no-error.
      end.
   input close.
   for each filelst:
       assign fl_sname = substring(fl_name,r-index(fl_name,"/") + 1).
       assign fl_namdn = integer(substring(fl_sname,index(fl_sname,".") + 2)).
       assign fl_sname = substring(fl_sname,1,length(fl_sname) - 1).
       assign fl_sznum = decimal(substring(fl_sz,1,length(fl_sz) - 1)).
       assign fl_szunit = substring(fl_sz,length(fl_sz)).
   end.
   /* OUTPUT DESTINATION SELECTION */
   /*
   {gpselout.i &printType = "report"
               &printWidth = 320
               &pagedFlag = "nopage"
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
  */
   for each  filelst no-lock with frame f-a break by fl_sname by fl_namdn with width 80:
      setFrameLabels(frame f-a:handle). /* SET EXTERNAL LABELS */
      if last-of(fl_sname) and fl_szunit = "G" then
      display fl_sz fl_sznum fl_szunit  fl_sname fl_namdn.
    /*  {mfrpchk.i} */
   end.

/*   {mfreset.i}   */
 /*  {mfrtrail.i} */
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
