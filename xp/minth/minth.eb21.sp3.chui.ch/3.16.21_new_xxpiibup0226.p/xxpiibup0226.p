/* piibup.p - INVENTORY BALANCE UPDATE                                        */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.10.1.10 $                                                      */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 6.0      LAST MODIFIED: 03/06/90   BY: WUG *D015*                */
/* REVISION: 6.0      LAST MODIFIED: 10/03/91   BY: alb *D887*(rev only)      */
/* REVISION: 6.0      LAST MODIFIED: 03/05/92   BY: WUG *F254*                */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*                */
/* REVISION: 7.5      LAST MODIFIED: 12/22/94   BY: mwd *J034*                */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: aal *K001*                */
/*                                   03/19/97   BY: *K082* E. Hughart         */
/* REVISION: 8.5      LAST MODIFIED: 11/18/97   BY: *J26G* Sandesh Mahagaokar */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/02/99   BY: *N01B* Mugdha Tambe       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/10/00   BY: *N0J4* Mudit Mehta        */
/* REVISION: 9.0      LAST MODIFIED: 04/11/01   BY: *M146* Vinod Kumar        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.10.1.7      BY: Manjusha Inglay    DATE: 08/16/02 ECO: *N1QP*  */
/* Revision: 1.10.1.9      BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J*  */
/* $Revision: 1.10.1.10 $     BY: Bhavik Rathod      DATE: 06/30/05 ECO: *P3RC*  */



/* SS - 100226.1  By: Roger Xiao */ /*修改前版本mage:091230.1,修改内容见xxpiibup.i,修改原因call:SS-547 */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "100226.1"}

{gldydef.i new}
{gldynrm.i new}

define new shared variable site            like si_site.
define new shared variable site1           like si_site       label "To".
define new shared variable loc             like loc_loc.
define new shared variable loc1            like loc_loc       label "To".
define new shared variable line            like pl_prod_line.
define new shared variable line1           like pl_prod_line  label "To".
define new shared variable part            like pt_part.
define new shared variable part1           like pt_part       label "To".
define new shared variable abc             like pt_abc.
define new shared variable abc1            like pt_abc        label "To".

/* VARIABLE NAME CHANGED FROM UPDATE_INV to UPDATE_YN TO MAINTAIN  */
/* THE CONSISTENCY BETWEEN REPORTS WITH SIMULATION OPTION          */
define new shared variable update_yn       like mfc_logical
                                           label "Update" no-undo.
define new shared variable eff_date        like glt_effdate.
define new shared variable yn              like mfc_logical.
define new shared variable todays_date     as   date.
define new shared variable sortoption      as   integer
                                           label "Sort Option"
                                           format "9" initial 1.
define new shared variable sortextoption   as character extent 3
                                           format "x(46)".

define variable l_inv_advno_lst            as character no-undo.
define variable l_snd_cc_resp              as logical   no-undo.

/*minth*/ define  new shared variable crtdate           as date label "标签产生日期".
/*minth*/ define  new shared variable crtdate1          as date label "TO".  
/*minth*/ define  new shared variable startdate         as date label "财务周期开始日".
/*minth*/ define  new shared variable enddate           as date label "TO".  




assign
   sortextoption[1] = "1 - " +
                      getTermLabel("BY",4)          + " "  +
                      getTermLabel("ITEM",6)        + ", " +
                      getTermLabel("SITE",6)        + ", " +
                      getTermLabel("LOCATION",9)    + ", " +
                      getTermLabel("LOT/SERIAL",10)
   sortextoption[2] = "2 - " +
                      getTermLabel("BY",4)          + " "  +
                      getTermLabel("SITE",6)        + ", " +
                      getTermLabel("LOCATION",9)    + ", " +
                      getTermLabel("ITEM",6)        + ", " +
                      getTermLabel("LOT/SERIAL",10)
   sortextoption[3] = "3 - " +
                      getTermLabel("BY",4)          + " "  +
                      getTermLabel("ITEM",6)        + ", " +
                      getTermLabel("LOT/SERIAL",10) + ", " +
                      getTermLabel("SITE",6)        + ", " +
                      getTermLabel("LOCATION",9).

{gpglefdf.i}

form
   site                 colon 15
   site1                colon 49
   crtdate                 colon 15  /*minth*/
   crtdate1                colon 49  /*minth*/
   startdate               colon 15  /*minth*/ label "财务周期始"
   enddate                 colon 49  /*minth*/
   loc                  colon 15
   loc1                 colon 49
   line                 colon 15
   line1                colon 49
   part                 colon 15
   part1                colon 49
   abc                  colon 15
   abc1                 colon 49
   skip(1)
   update_yn            colon 25
   eff_date             colon 25
   sortoption           colon 25
   sortextoption[1]     at 30 no-label
   sortextoption[2]     at 30 no-label
   sortextoption[3]     at 30 no-label
   skip(1)
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
/*minth*/ crtdate = today - 10.
/*minth*/ crtdate1 = today. 
/*ss - 090514.1 - b*/

/*ss - 090514.1 - e*/

mainloop:
repeat:
   if site1 = hi_char
   then
      site1 = "".
   if loc1  = hi_char
   then
      loc1 = "".
   if line1 = hi_char
   then
      line1 = "".
   if part1 = hi_char
   then
      part1 = "".
   if abc1  = hi_char
   then
      abc1 = "".

   eff_date = today.

   display
      sortextoption
   with frame a.
/*ss - 090902.1 - b*/
  if day(today)  >= 20 then do:
     startdate = today - day(today) + 1  .
     enddate = today .
  end.
  else do:
     startdate = date(month(today - day(today)), 1, year(today - day(today)) ).
     enddate   = today - day(today) .
  end.
/*ss - 090902.1 - e*/    

   update
      site
      site1
      crtdate                  /*minth*/
      crtdate1                 /*minth*/
      startdate               /*minth*/
      enddate                /*minth*/
      loc
      loc1
      line
      line1
      part
      part1
      abc
      abc1
      update_yn
      eff_date
      sortoption
   with frame a.

   if site1 = ""
   then
      site1 = hi_char.
   if loc1  = ""
   then
      loc1  = hi_char.
   if line1 = ""
   then
      line1 = hi_char.
   if part1 = ""
   then
      part1 = hi_char.
   if abc1  = ""
   then
      abc1  = hi_char.

   {gprun.i ""gpsirvr.p""
      "(input  site,
        input  site1,
        output return_int)"}
   if return_int = 0
   then do:
      next-prompt
         site
      with frame a.
      undo mainloop, retry mainloop.
   end. /* IF return-int = 0 */

   if sortoption < 1 or sortoption > 3
   then do:
      /* Invalid option */
      {pxmsg.i &MSGNUM=712 &ERRORLEVEL=3}
      next-prompt
         sortoption
      with frame a.
      undo, retry.
   end. /* IF sortoption < 1 OR ... */

   for each si_mstr
      fields (si_domain si_entity si_site)
      where si_domain = global_domain
        and si_site  >=site
        and si_site  <=site1
   no-lock :
      {gprun.i ""gpglef.p""
               "(input  ""IC"",
                 input  si_entity ,
                 input  eff_date,
                 input  1,
                 output gpglef)"}

       if gpglef = 3036
       then do:
          update
             eff_date
          with frame a.
          undo,retry.
       end. /* IF gpglef = 3036 */
    end. /* FOR EACH si_mstr */

    if keyfunction(lastkey) = "END-ERROR"
    then
       undo,retry.

   bcdparm = "".
   {gprun.i ""gpquote2.p""
      "(input-output bcdparm,
        input 15,
        input site,
        input site1,
	input crtdate,
        input crtdate1,  
        input loc,
        input loc1,
        input line,
        input line1,
        input part,
        input part1,
        input abc,
        input abc1,
        input string(update_yn),
        input string(eff_date),
        input string(sortoption),
        input null_char,
        input null_char,
        input null_char,
        input null_char,
        input null_char,
        input null_char,
        input null_char,
        input null_char,
        input null_char,
        input null_char,
        input null_char,
        input null_char,
        input null_char,
         input null_char,
        input null_char)"}

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

   todays_date = today.

   if sortoption = 1
   then do:
      /* ADDED INPUT PARAM L_INV_ADVNO_LST */
      {gprun.i ""xxpiibupa0226.p""                    /*minth*/
         "(input-output l_inv_advno_lst)"}
   end. /* IF sortoption = 1 */
   else
   if sortoption = 2
   then do:
      /* ADDED INPUT PARAM L_INV_ADVNO_LST */
      {gprun.i ""xxpiibupb0226.p""                   /*minth*/
         "(input-output l_inv_advno_lst)"}
   end. /* IF sortoption = 2 */
   else
   if sortoption = 3
   then do:
      /* ADDED INPUT PARAM L_INV_ADVNO_LST */
      {gprun.i ""xxpiibupc0226.p"" "(input-output l_inv_advno_lst)"}    /*minth*/
   end. /* IF sortoption = 3 */

   {mfrtrail.i}

   if update_yn
   then do:
      /* Update complete */
      {pxmsg.i &MSGNUM=1300 &ERRORLEVEL=1}
   end. /* IF update_yn */

   /* CALL INVENTORY ADVICE 'CYCLE COUNT' EXPORT ONLY  */
   /* IF THE INVENTORY ADVICE NUMBER LIST IS POPULATED */
   /* AND THE ALSO RECORDS EXISTS IN QAD WORKFILE FOR  */
   /* INVENTORY ADVICE NUMBER THAT IS IN THE LIST AND  */
   /* 'UPDATE INVENTORY' FLAG IS SET TO 'YES'          */

   if l_inv_advno_lst <> ""
      and update_yn
      and can-find(first qad_wkfl use-index qad_index2
              where qad_wkfl.qad_domain = global_domain and  qad_key3 >=
              entry(1,l_inv_advno_lst)
      and qad_key4 <=
          entry(num-entries(l_inv_advno_lst),
             l_inv_advno_lst))
   then do:

      /* NOW PROMPT THE USER TO SEE OF THEY WANTED TO  */
      /* SEND OUTBOUND INVENTORY ADVICE CYCLE COUNT    */
      /* RESPONSE                                      */
      l_snd_cc_resp = no.

      status input off.
      hide message no-pause.

      /* Send Inventory Advice 'Cycle Count' response? */
      {pxmsg.i &MSGNUM=4889 &ERRORLEVEL=1 &CONFIRM=l_snd_cc_resp}

      if l_snd_cc_resp
      then do:

         hide frame a.

         {gprun.i
            ""edomccsl.p""
            "(input l_inv_advno_lst,
              input no)"}  /* DO NOT PROMPT THE USER */

         view frame a.

      end. /* IF l_cc_resp THEN */

      status input.

   end. /* IF l_frm_inv_advno <> "" AND */

end. /* MAINLOOP */
