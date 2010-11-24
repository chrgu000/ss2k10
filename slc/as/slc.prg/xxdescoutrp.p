/*designed by axiang 2009-04-09 ����������������*/
/* SS - 091013.1 By: Neil Gao */

{mfdtitle.i "091013.1"}
  
define variable part like pt_part.
define variable part1 like pt_part.
define variable desc1 as char format "x(230)".
define variable oldname like pt_desc1.


form 
	part              label "��������" colon 15 
	part1             label "��" colon 49  skip
with frame a side-labels width 80.


setFrameLabels(frame a:handle).  
form
	"����������������" at 40
with frame phead.


{wbrp01.i}

repeat:

	if part1 = hi_char then part1 = "".
	
	if c-application-mode <> 'web' then
	update
		part part1
	with frame a.

   {wbrp06.i &command = update &fields = "part part1" &frm = "a"}
   
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      {mfquoter.i part   }
      {mfquoter.i part1  }
      
      if part1 = "" then part1 = hi_char.
   end.


   {gpselout.i &printType = "page"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   
   view frame phead.       

   for each cd_det where cd_domain = global_domain 
                     and cd_ref >= part and cd_ref <= part1
                     and cd_ref < "D" 
                     and cd_type = "SC" no-lock,
       each pt_mstr where pt_domain = global_domain
                     and pt_part = cd_ref no-lock:
                  desc1 = cd_cmmt[1] + cd_cmmt[2] + cd_cmmt[3] + cd_cmmt[4].
                  
                  {gprun.i ""xxaddoldname"" "(input cd_ref,output oldname)"}
                  
                  display
                  	cd_ref    column-label "���ϱ���" format "x(20)"
                  	pt_desc1  column-label "��������"
                  	oldname   column-label "�ϳ���"
/* SS 091013.1 - B */
                  	pt_status column-label "״̬"
/* SS 091013.1 - E */
                  	desc1     column-label "��������"
                  with stream-io width 400.
                  desc1 = "".
   end. /*for each cd_det*/                 
      
   {mfrtrail.i}   
end.  /*repeat*/
 {wbrp04.i &frame-spec = a}
 