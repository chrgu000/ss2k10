/* pirp03.p - TAG REPORT                                                      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8.1.4 $                                                       */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 6.0      LAST MODIFIED: 03/06/90   BY: WUG *D015*/
/* REVISION: 6.0      LAST MODIFIED: 10/03/91   BY: alb *D887*(rev only)      */
/* REVISION: 8.6      LAST MODIFIED: 10/15/97   BY: gyk *K0ZS*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/24/00   BY: *N0GJ* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.8.1.4 $  BY: Jean Miller         DATE: 09/14/01  ECO: *N128*  */
/* $Revision: 1.8.1.4 $  BY: Mage Chen           DATE: 09/07/06  ECO: *minth* */
/*----rev history-------------------------------------------------------------------------------------*/
/* 添加零件分类 DATE：2009/04/10  ECO：*hubo* */
/* 添加标签的转换单位 DATE：2009/06/10 ECO: *hubo* */
/* SS - 090827.1  By: Roger Xiao */

/*----rev description---------------------------------------------------------------------------------*/

/* SS - 090827.1 - RNB
程式名由*.* 改为 *9.*
增加列 : 当月产量 当月消耗量 成本 差异金额
SS - 090827.1 - RNE */



/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "090827.1"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE pirp03_p_11 "Select Option"
/* MaxLen: Comment: */

&SCOPED-DEFINE pirp03_p_12 "Sort Option"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable tag             like tag_nbr initial ?.
define new shared variable tag1            like tag_nbr label {t001.i} initial ?.
define new shared variable site            like si_site.
define new shared variable site1           like si_site label {t001.i}.
define new shared variable loc             like loc_loc.
define new shared variable loc1            like loc_loc label {t001.i}.
define new shared variable part            like pt_part.
define new shared variable part1           like pt_part label {t001.i}.
define new shared variable lotser          like tag_serial.
define new shared variable lotser1         like tag_serial label {t001.i}.
define new shared variable seloption       as integer format "9"
   label {&pirp03_p_11} initial 1.
define new shared variable seltextoption   as character extent 3 format "x(29)".
define new shared variable sortoption      as integer label {&pirp03_p_12}
   format "9" initial 1.
define new shared variable sortextoption   as character extent 4 format "x(51)".
define new shared variable earliest_crt_dt as date.
define new shared variable latest_crt_dt   as date.
define new shared variable earliest_frz_dt as date.
define new shared variable latest_frz_dt   as date.
define new shared variable frzdates        as character format "x(17)".
define variable c-label-warning as character no-undo.
define variable c-labelC        as character no-undo.
define variable c-labelN        as character no-undo.
define variable c-labelV        as character no-undo.

/*minth*/ define new shared variable crtdate          as date label "标签产生日期".
/*minth*/ define new shared variable crtdate1          as date label "TO".
assign
   seltextoption[1] = "1 - " + getTermLabel("ALL_TAGS",25)
   seltextoption[2] = "2 - " + getTermLabel("UNPRINTED_TAGS",25)
   seltextoption[3] = "3 - " + getTermLabel("VOID_TAGS",25)
   sortextoption[1] = "1 - " + getTermLabel("BY",2)          + " " +
   getTermLabel("TAG_NUMBER",27)
   sortextoption[2] = "2 - " + getTermLabel("BY",2)          + " " +
   getTermLabel("ITEM",4)        + ", " +
   getTermLabel("SITE",4)        + ", " +
   getTermLabel("LOCATION",8)    + ", " +
   getTermLabel("LOT/SERIAL",10) + ", " +
   getTermLabel("TAG_NUMBER",10)
   sortextoption[3] = "3 - " + getTermLabel("BY", 2)         + " " +
   getTermLabel("SITE",4)        + ", " +
   getTermLabel("LOCATION",8)    + ", " +
   getTermLabel("ITEM",4)        + ", " +
   getTermLabel("LOT/SERIAL",10) + ", " +
   getTermLabel("TAG_NUMBER",10)
   sortextoption[4] = "4 - " + getTermLabel("BY",2)          + " " +
   getTermLabel("ITEM",4)        + ", " +
   getTermLabel("LOT/SERIAL",10) + ", " +
   getTermLabel("SITE",4)        + ", " +
   getTermLabel("LOCATION",8)    + ", " +
   getTermLabel("TAG_NUMBER",10)
   c-label-warning = "*" + getTermLabel("WARNINGS",20) + ":".

/* Count/Recount date precedes freeze date */
{pxmsg.i &MSGNUM=4866 &ERRORLEVEL=1 &MSGBUFFER=c-labelC}
c-labelC = "C - " + c-labelC.

/* No frozen quantity exists */
{pxmsg.i &MSGNUM=4867 &ERRORLEVEL=1 &MSGBUFFER=c-labelN}
c-labelN = "N - " + c-labelN.

/* Variation in freeze dates was detected */
{pxmsg.i &MSGNUM=714 &ERRORLEVEL=1 &MSGBUFFER=c-labelV}
c-labelV = "V - " + c-labelV.

form
   crtdate              colon 21 /*minth*/
   crtdate1             colon 55 /*minth*/
   tag                  colon 21
   tag1                 colon 55
   site                 colon 21
   site1                colon 55
   loc                  colon 21
   loc1                 colon 55
   part                 colon 21
   part1                colon 55
   lotser               colon 21
   lotser1              colon 55

  with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:

   if tag = 0 then tag = ?.
   if tag1 = 99999999 then tag1 = ?.
   if site1 = hi_char then site1 = "".
   if loc1 = hi_char then loc1 = "".
   if part1 = hi_char then part1 = "".
   if lotser1 = hi_char then lotser1 = "".
   if c-application-mode = 'web' then
      assign
         tag  = 0
         tag1 = 99999999.
 /*minth*/ crtdate = today - 10.
/*minth*/ crtdate1 = today. 
   display
      crtdate    /*minth*/
      crtdate1   /*minth*/
      
   with frame a.

   if c-application-mode = 'web' then
      display tag tag1 with frame a.

   if c-application-mode <> 'web' then
   set
       crtdate    /*minth*/
      crtdate1   /*minth*/
      tag
      tag1
      site
      site1
      loc
      loc1
      part
      part1
      lotser
      lotser1
      
   with frame a.

   {wbrp06.i &command = set &fields = " crtdate crtdate1 tag tag1 site site1 loc loc1 part
        part1 lotser lotser1  " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:



      bcdparm = "".

      {mfquoter.i tag}
      {mfquoter.i tag1}
      {mfquoter.i site}
      {mfquoter.i site1}
      {mfquoter.i loc}
      {mfquoter.i loc1}
      {mfquoter.i part}
      {mfquoter.i part1}
      {mfquoter.i lotser}
      {mfquoter.i lotser1}
     

      if tag = ? then tag = 0.
      if tag1 = ? then tag1 = 99999999.
      if site1 = "" then site1 = hi_char.
      if loc1 = "" then loc1 = hi_char.
      if part1 = "" then part1 = hi_char.
      if lotser1 = "" then lotser1 = hi_char.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
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
   {mfphead.i}

   frzdates = "".

   form header
      c-label-warning format "x(22)" skip
      c-labelC format "x(75)" skip
      c-labelN format "x(75)" skip
      c-labelV format "x(75)"
      frzdates
   with frame w width 132 attr-space page-bottom.

   view frame w.

   assign
      earliest_frz_dt = hi_date
      latest_frz_dt = low_date.

    
      {gprun.i ""xxpirp03cx29.p""}
   

   {mfrtrail.i}

   if earliest_frz_dt <> latest_frz_dt
      and earliest_frz_dt <> hi_date
      and latest_frz_dt <> low_date
   then do:
      /* Variation in freeze dates detected */
      {pxmsg.i &MSGNUM=714 &ERRORLEVEL=2}
   end.

end.

{wbrp04.i &frame-spec = a}
