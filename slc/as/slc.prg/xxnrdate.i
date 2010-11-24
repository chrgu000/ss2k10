/* nrdate.i - NUMBER RANGE MANAGEMENT ENGINE - DATE-TYPE SEGMENTS       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.12 $                                                         */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 8.6      LAST MODIFIED: 04/30/96   BY: PCD *K002*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/*                                   09/27/96   BY: jzw *K00R*          */
/*                                   10/22/96   BY: jzw *K018*          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb              */
/* $Revision: 1.12 $    BY: Reetu Kapoor   DATE: 02/15/02 ECO: *N19J*         */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* ******************************************************************** */

PROCEDURE seg_make_date:
   /* CREATE A NEW SEGMENT DATA STRUCTURE OF THE DATE TYPE.  */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE nrdate_i_1 "New Seg Nbr"
/* MaxLen: Comment: */

&SCOPED-DEFINE nrdate_i_2 "Control Segment"
/* MaxLen: Comment: */

&SCOPED-DEFINE nrdate_i_4 "Date Format"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

   define output parameter new_segment   as recid no-undo.

   /* ONLY ONE DATE-DRIVEN SEGMENT ALLOWED */
/*SS 20080713 - B*/
/*
   for each segment
      where seg_attached
        and (seg_rank = "1" or seg_rank = "0" ):
      assign
         Error_state = true
         Error_nbr   = 2922. /* SEQ ALREADY CONTAINS A DATE-DRIVEN SEGMENT */
      return.
   end. /* FOR EACH segment */
*/
/*SS 20080713 - E*/
		
   create segment.
   new_segment = recid (segment).

   assign
      seg_type          = "2"
      seg_exe_generate  = "seg_generate_date"
      seg_exe_validate  = "seg_validate_date"
      seg_exe_edit      = "seg_edit_date"
      seg_exe_display   = "seg_display_date"
      seg_format        = "Y"
      seg_rank          = "1"
      seg_valuemask     = "0909".

END PROCEDURE. /* seg_make_date */

PROCEDURE seg_set_date:

   /* SET CUSTOM VALUES FOR THE DATE SEGMENT. */
   define input parameter p-seg-recid as recid     no-undo.
   define input parameter date-format as character no-undo.
   define input parameter control-seg as logical   no-undo.

   define variable dummy        as logical               no-undo.
   define variable format-valid as logical initial true  no-undo.
   define variable reset        as logical initial false no-undo.
   define variable i            as integer initial 1     no-undo.
   define variable value-mask   as character             no-undo.
   define variable year-mask    as character             no-undo.
   define variable date-min     as character             no-undo.
   define variable date-max     as character             no-undo.
   define variable hold-date    as date                  no-undo.

   if index(date-format,",") > 0
   then do:
      assign
         Error_state = true
         Error_nbr   = 2920. /* COMMA IS NOT ALLOWED. */
      return.
   end. /* IF INDEX(date-format,",") > 0 */

   if ( index(date-format,"Y") = 0 )
   then
      format-valid = false.

   if  ( index(date-format,"D") > 0 )
   and ( index(date-format,"Y") = 0 or
         index(date-format,"M") = 0 )
   then
      format-valid = false.

   /* CHECK TO SEE IF DATE COMPONENT HAS BEEN ENTERED MORE THAN ONCE */
   if ( index(date-format,"Y") <> r-index(date-format,"Y") )
   or ( index(date-format,"M") <> r-index(date-format,"M") )
   or ( index(date-format,"W") <> r-index(date-format,"W") )
   or ( index(date-format,"D") <> r-index(date-format,"D") )
   then
      format-valid = false.

   /* REJECT FISCAL SETTINGS (P,P3) TO AVOID CONFUSION */
   if index(date-format,"P")  > 0
   or index(date-format,"P3") > 0
   then
      format-valid = false.

   if not format-valid
   then do:
      assign
         Error_state = true
         Error_nbr   = 2904. /* INVALID DATE FORMAT */
      return.
   end. /* IF NOT format-valid */

   /* DATE FORMAT VALID */
   find segment
      where recid(segment) = p-seg-recid
   no-error.
   seg_format = date-format.

   /* CALCULATE THE valuemask FOR THE DATE SEGMENT */
   assign
      hold-date     = Trans_effdate
      Trans_effdate = Effdate.

   run seg_format_date ( p-seg-recid, output date-min ).

   Trans_effdate = Expdate.
   run seg_format_date ( p-seg-recid, output date-max ).

   Trans_effdate = hold-date.

   do while not reset and i <= 4:
      year-mask = year-mask + substring(string(year(Effdate)),i,1)
                            + substring(string(year(Expdate)),i,1).
      if substring(string(year(Effdate)),i,1) <
         substring(string(year(Expdate)),i,1)
      then
         reset = true.
      i = i + 1.
   end. /* DO WHILE ... */

   assign
      i         = ( 8 - length(year-mask) ) / 2
      year-mask = year-mask + fill("09", i ).

   do i = 1 to length(date-format):
      if substring(date-format,i,2) = "Y4"
      then
         assign
            value-mask = value-mask + year-mask
            i          = i + 1
            date-min   = substring(date-min,5)
            date-max   = substring(date-max,5).
      else
      if substring(date-format,i,1) = "Y"
      or substring(date-format,i,1) = "M"
      or substring(date-format,i,1) = "W"
      or substring(date-format,i,1) = "D"
      then do:

         if substring(date-format,i,1) = "Y"
         then
            value-mask = value-mask + substring(year-mask,5).
         else
         if  substring(date-format,i,1) = "M"
         and year(Expdate) <> year(Effdate)
         then
            value-mask = value-mask + "0109".
         else
         if  substring(date-format,i,1) = "D"
         and ( year(Expdate)  <> year(Effdate) or
               month(Expdate) <> month(Effdate) )
         then
            value-mask = value-mask + "0309".
         else
         if  substring(date-format,i,1) = "W"
         and year(Expdate) <> year(Effdate)
         then
            value-mask = value-mask + "0509".
         else do:
            value-mask = value-mask + substring(date-min,1,1) +
                         substring(date-max,1,1).
            if substring(date-min,1,1) <> substring(date-max,1,1)
            then
               value-mask = value-mask + "09".
            else
               value-mask = value-mask + substring(date-min,2,1) +
                            substring(date-max,2,1).
         end. /* ELSE DO */
         assign
            date-min = substring(date-min,3)
            date-max = substring(date-max,3).
      end. /* ELSE IF SUBSTRING(date-format,i,1) = "Y" ... */
      else
         assign
            value-mask = value-mask +
                         string ( fill( substring(date-format,i,1),2) )
            date-min   = substring(date-min,2)
            date-max   = substring(date-max,2).
   end. /* DO I = 1 to LENGTH(date-format) */

   seg_valuemask = value-mask.

   if control-seg
   then
      seg_rank = "0".
   else
      seg_rank = "1".

   run seg_generate_date (p-seg-recid, output dummy).

END PROCEDURE. /* seg_set_date */

PROCEDURE seg_generate_date:

   /*  EVALUATE A SEGMENT OF DATE TYPE */
   define input  parameter p-seg-recid as recid                 no-undo.
   define output parameter reset       as logical initial false no-undo.

   define variable seg-fmt-val as character no-undo.

   run seg_format_date ( p-seg-recid, output seg-fmt-val ).

   find segment
      where recid(segment) = p-seg-recid
   no-error.

   if seg_value <> seg-fmt-val
   then
      assign
         seg_value = seg-fmt-val
         reset     = true.

END PROCEDURE. /* seg_generate_date */

PROCEDURE seg_validate_date:

   define input        parameter p-seg-recid as recid                no-undo.
   define input-output parameter val         as character            no-undo.
   define output       parameter is-valid    as logical initial true no-undo.

   define variable seg-fmt-val as character.

   run seg_format_date ( p-seg-recid, output seg-fmt-val ).

   if seg-fmt-val <> substring(val,1,length(seg-fmt-val))
   then
      is-valid = false.
   else
      val = substring( val, length(seg-fmt-val) + 1 ).

END PROCEDURE. /* seg_validate_date */

PROCEDURE seg_format_date:

   define input  parameter p-seg-recid as recid     no-undo.
   define output parameter seg-fmt-val as character no-undo.

   define variable i        as integer no-undo.
   define variable num-days as integer no-undo.

   find segment
      where recid(segment) = p-seg-recid
   no-error.

   do i = 1 to length(seg_format):

      CASE substring(seg_format,i,1):

         when "Y"
         then do:
            if substring(segment.seg_format,i,2) = "Y4"
            then
               assign
                  seg-fmt-val = seg-fmt-val +
                                string(year(Trans_effdate),"9999")
                  i           = i + 1.
            else
               seg-fmt-val = seg-fmt-val +
                           substring((string(year(Trans_effdate),"9999")),3,2).
         end. /* WHEN "Y" */

         when "M"
         then
            seg-fmt-val = seg-fmt-val + string(month(Trans_effdate),"99").

         when "D"
         then
            seg-fmt-val = seg-fmt-val + string(day(Trans_effdate),"99").

         when "W"
         then do:
            /* CALCULATE THE NUMBER OF WEEKS SINCE BEGINNING OF YEAR */
            /* ALL DAYS BEFORE THE FIRST MONDAY OF THE YEAR ARE      */
            /* CONSIDERED TO BE WEEK 0.                              */

            {gprun.i ""fcsdate2.p""
                      "(input Trans_effdate,
                        output num-days)"}

            seg-fmt-val = seg-fmt-val + string( num-days,"99").
         end. /* WHEN "W" */

         otherwise
            seg-fmt-val = seg-fmt-val + substring(segment.seg_format,i,1).

      END CASE.

   end. /* DO */

END PROCEDURE. /* seg_format_date */

PROCEDURE seg_edit_date:

   define input parameter seg-recno as recid.

   define variable new-seg-nbr like seg_nbr format ">9"
      label {&nrdate_i_1}.
   define variable date-format as character format "x(16)"
      label {&nrdate_i_4}.
   define variable control-seg as logical format "yes/no"
      label {&nrdate_i_2}.

   form
      new-seg-nbr colon 12
      control-seg colon 45
      date-format colon 45
   with side-labels width 80
      title color normal (getFrameTitle("DATE_SEGMENT_EDITOR",28))
   with frame segdate overlay centered.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame segdate:handle).

   find segment
      where recid (segment) = seg-recno.
   control-seg = (seg_rank = "0").

   ststatus = stline[2].
   status input ststatus.

   display
      seg_nbr    @ new-seg-nbr
      control-seg
      seg_format @ date-format
   with frame segdate.

   Segment_edited = false.

   set_block:
   do on endkey undo, leave:

      run nr_clear_error.

      set
         new-seg-nbr
         control-seg
         date-format
         go-on (F5 CTRL-D)
         with frame segdate
      editing:

         /* REJECT ENTRY OF UNKNOWN */
         {gprejqm.i}

         /* Delete logic. */
         {nrdel.i
             &seg-recno = seg-recno
             &undo-block = set_block
             &frame = segdate}

         if del-yn
         then do:
            hide frame segdate.
            return.
         end. /* IF del-yn */
      end. /* EDITING */

      if   new-seg-nbr <> seg_nbr
      and ( new-seg-nbr > Segment_count or
            new-seg-nbr < 1 )
      then do:
         /* SEGMENT NUMBERS MUST BE CONSECUTIVE */
         {pxmsg.i &MSGNUM=2932 &ERRORLEVEL=3}
         next-prompt new-seg-nbr with frame segdate.
         undo set_block.
      end. /* IF new-seg-nbr <> seg_nbr ... */

      run seg_set_date (seg-recno, date-format, control-seg).
      if Error_state
      then do:
         {pxmsg.i &MSGNUM=Error_nbr &ERRORLEVEL=3}
         next-prompt date-format with frame segdate.
         undo set_block, retry.
      end. /* IF Error_state */

      if new-seg-nbr <> seg_nbr
      then
         run nr_set_seg_nbr ( seg_nbr, new-seg-nbr ).

      Segment_edited = true.

   end. /* set_block */

   hide frame segdate.

END PROCEDURE. /* seg_edit_date */

PROCEDURE seg_display_date:
   define input  parameter seg-recno    as recid.
   define output parameter seg-settings as character no-undo.
   define output parameter seg-control  as character no-undo.

   define variable i as integer no-undo.

   find segment
      where recid(segment) = seg-recno.

   seg-settings = seg_format + " (".

   do i = 1 to length(seg_format):
      if substring(seg_format,i,2) = "Y4"
      then
         assign
            seg-settings = seg-settings + "YYYY"
            i            = i + 1.
      else
      if substring(seg_format,i,1) = "Y"
      or substring(seg_format,i,1) = "M"
      or substring(seg_format,i,1) = "D"
      or substring(seg_format,i,1) = "W"
      then
         seg-settings = seg-settings + fill(substring(seg_format,i,1),2).
      else
         seg-settings = seg-settings + substring(seg_format,i,1).
   end. /* DO i = 1 TO LENGTH(seg_format) */

   assign
      seg-settings = seg-settings + ")"
      seg-control  = string( seg_rank = "0").

END PROCEDURE. /* seg_display_date */
