/*Zzfcbtchdel.p, for batch delete the forecast detail*/
/*Last modified by: Kevin, 10/15/2003                */

         /* DISPLAY TITLE */
{mfdtitle.i "120816.1"}

def var year like fcs_year.
def var site like si_site.
def var site1 like si_site.
def var effdate like tr_effdate.
def var effdate1 like tr_effdate.
def var part like pt_part.
def var part1 like pt_part.
DEFINE VARIABLE START LIKE ro_start NO-UNDO.
def stream fcsdel.
def var fcsdelfile as char format "x(40)".
def var yn as logic.

define temp-table tmpb_ym
       fields tby_year as integer
       fields tby_month as integer
       fields tby_date as date
       fields tby_sort as character
       fields tby_sn   as integer.

def var i as inte.

def var str as char.

         /* DISPLAY SELECTION FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/

 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
year colon 22
site colon 22   site1 colon 45 label {t001.i} skip(1)
effdate colon 22    effdate1 colon 45 label {t001.i}
part colon 22       part1 colon 45 label {t001.i}
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME
setFrameLabels(frame a:handle).

mainloop:
repeat:

    fcsdelfile = execname.

    year = year(today).
    if site1 = hi_char then site1 = "".
    if effdate = low_date then effdate = ?.
    if effdate1 = hi_date then effdate1 = ?.
    if part1 = hi_char then part1 = "".

    update year site site1 effdate effdate1 part part1 with frame a.

    bcdparm = "".
    {mfquoter.i site}
    {mfquoter.i site1}
    {mfquoter.i effdate    }
    {mfquoter.i effdate1   }
    {mfquoter.i part }
    {mfquoter.i part1}
		if year = ? then do:
	  	 {mfmsg.i 40 3}
	  	 undo,retry.
	  end.
    if site1 = "" then site1 = hi_char.
    if effdate = ? then effdate = date(1,1,year).
    if effdate1 = ? then effdate1 = date(12,31,year).
    if part1 = "" then part1 = hi_char.

/*J034*/       if not batchrun then do:
/*J034*/          {gprun.i ""gpsirvr.p""
                   "(input site, input site1, output return_int)"}
/*J034*/          if return_int = 0 then do:
/*J034*/             next-prompt site with frame a.
/*J034*/             undo mainloop, retry mainloop.
/*J034*/          end.
/*J034*/       end.

    if effdate = low_date and effdate1 = hi_date then do:
        message "请确认日期范围" view-as alert-box error.
        next-prompt effdate1 with frame a.
        undo mainloop, retry mainloop.
    end.
    if effdate > effdate1 then do:
        message "起始日期大于截止日期,请重新输入!" view-as alert-box error.
        next-prompt effdate with frame a.
        undo mainloop, retry mainloop.
    end.

    yn = no.
    message "确认删除" view-as alert-box question buttons yes-no update yn.
    if not yn then undo mainloop, retry mainloop.


    /* SELECT PRINTER */
/*    {mfselbpr.i "printer" 132}*/
empty temp-table tmpb_ym no-error.
start = ?.
    {fcsdate1.i year start}
         do i = 1 to 52:
           create tmpb_ym.
           assign tby_year = year
                  tby_month = month(start)
                  tby_date = start
                  tby_sort = string(year(start),">>>9") + string(month(start),"99")
                  tby_sn = i.
           assign start = start + 7.
         end.

 		for each tmpb_ym exclusive-lock:
			  IF tby_date < effdate or tby_date > effdate1 then do:
			  	 delete tmpb_ym.
			  end.
 	  end.
    output stream fcsdel to value(fcsdelfile + ".bpi").

    for each fcs_sum where fcs_domain = global_domain and fcs_year = year
                       and fcs_site >= site and fcs_site <= site1
                       and fcs_part >= part and fcs_part <= part1
                       no-lock:
          put stream fcsdel unformat '"' fcs_part '" "' fcs_site '" ' fcs_year skip.
          do i = 1 to 52:
						 if can-find (first tmpb_ym no-lock where tby_sn = i) then do:
						 		put stream fcsdel unformat  '0'.
						 end.
						 else do:
						 	  put stream fcsdel unformat  '-'.
						 end.
						 if i <> 52 then put stream fcsdel unformat ' '.
						 					  else put stream fcsdel skip.
          end.
/*
          put stream fcsdel "~"" at 1 fcs_part "~"" " ~"" fcs_site "~" " fcs_year skip.

          do i = 1 to 52:
               if start[i] >= effdate and start[i] <= effdate1 then
                   put stream fcsdel 0 " ".
               else put stream fcsdel "- ".
          end. /*do i = 1 to 52*/
*/
          /*put stream fcsdel "." at 1.*/

    end. /*for each fcs_sum*/

    output stream fcsdel close.

    /*begin to call the forecast maintenance program to update data*/
    batchrun = yes.
    input from value(fcsdelfile + ".bpi").
    output to value(fcsdelfile + ".bpo") keep-messages.

    hide message no-pause.
    {gprun.i ""fcfsmt01.p""}
    hide message no-pause.

    output close.
    input close.
    batchrun = no.
    /*End of calling the forecast maintenance program to update data*/
		os-delete value(fcsdelfile + ".bpi") no-error.
		os-delete value(fcsdelfile + ".bpo") no-error.
/*    {mfreset.i {1}}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/    */

end. /*repeat*/


