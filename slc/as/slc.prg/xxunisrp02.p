/* By: Neil Gao Date: 20070413 ECO: * ss 20070413.1 * */

{mfdeclre.i}  
{gplabel.i} 

/* ss 20070410.1 - b */
define input parameter iplcsn as char. 
define new shared variable sntype 				 as char init "lcsnjc" .
define new shared variable snnbr					 as char format "x(11)".
define new shared variable snnbr1					 like snnbr.
define new shared variable rdate           like prh_rcp_date.
define new shared variable rdate1          like prh_rcp_date.
define new shared variable part            like pt_part.
define new shared variable part1           like pt_part.
define new shared variable site            like pt_site.
define new shared variable site1           like pt_site.
define new shared variable noprinter				as logical init yes.
define variable confirm-yn like mfc_logical init yes.
/* ss 20070410.1 - e */


form
   snnbr            colon 15
   snnbr1           label "To" colon 49 skip
   rdate            colon 15
   rdate1           label "To" colon 49 skip
   part             colon 15
   part1            label "To" colon 49 skip
   site             colon 15
   site1            label "To" colon 49 skip(1)
   noprinter				colon 30   label "Œ¥¥Ú”°µ•æ›" skip
with frame a side-labels width 80 attr-space.
{&POPORP06-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

snnbr = iplcsn.
snnbr1 = iplcsn.
  
{wbrp01.i}
repeat:

   {&POPORP06-P-TAG3}
   if snnbr1 = hi_char then snnbr1 = "".
   if rdate = low_date then rdate = ?.
   if rdate1 = hi_date then rdate1 = ?.
   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".

   if c-application-mode <> 'web' then
   update
      {&POPORP06-P-TAG4}
      snnbr snnbr1 rdate rdate1 part part1 site site1 noprinter
   with frame a.

   {&POPORP06-P-TAG5}
   {wbrp06.i &command = update
      &fields = " snnbr snnbr1 rdate rdate1 part part1
        site site1 noprinter "
      &frm = "a"}


      {&POPORP06-P-TAG7}
      bcdparm = "".
      {mfquoter.i snnbr           }
      {mfquoter.i snnbr1          }
      {mfquoter.i rdate           }
      {mfquoter.i rdate1          }
      {mfquoter.i part            }
      {mfquoter.i part1           }
      {mfquoter.i site            }
      {mfquoter.i site1           }

      if rdate = ? then rdate = low_date.
      if rdate1 = ? then rdate1 = today.
      if snnbr1 = "" then snnbr1 = hi_char.
      if part1 = "" then part1 = hi_char.
      if site1 = "" then site1 = hi_char.
      

   {mfselprt.i "printer" 132}

   {gprun.i ""xxunisrp01.p""}

 	 {mfreset.i}
	 {mfgrptrm.i}

   {pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.

/*V8-*/
{wbrp04.i &frame-spec = a}
/*V8+*/

hide frame a no-pause.