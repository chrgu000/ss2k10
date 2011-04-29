/* mfmenu.p - MFG/PRO Manufacturing System Menu                               */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* Parameter: rstatus = return status to mf1a.p                               */
/* Added with patch G0C0 to return back to the calling programe mf1a.p        */
/* in order to clean-up the qad_wkfl record associated with the mfguser       */
/* value.  We now delete the record at the end of mf1a.p before exiting       */
/* mfg/pro.  The "quit" statements have been replaced with "returns",         */
/* with the exception of the "expired demo" section.                          */
/*  REVISION: 1.0       LAST EDIT: 07/28/86      MODIFIED BY: EMB *08*        */
/*  REVISION: 6.0       LAST EDIT: 06/29/90      MODIFIED BY: WUG *D043*      */
/*                                 07/06/90      MODIFIED BY: WUG *D044*      */
/*                                 07/06/90      MODIFIED BY: WUG *D045*      */
/*  REVISION: 5.0       LAST EDIT: 07/16/90      MODIFIED BY: emb *B695*      */
/*  REVISION: 6.0       LAST EDIT: 08/10/90      MODIFIED BY: WUG *D054*      */
/*                                 10/01/90      MODIFIED BY: TJT *D074*      */
/*                                 10/24/90      MODIFIED BY: pml *D139*      */
/*                                 12/05/90      MODIFIED BY: WUG *D246*      */
/*                                 03/11/91      MODIFIED BY: WUG *D415*      */
/*                                 04/23/91      MODIFIED BY: WUG *D576*      */
/*                                 06/13/91      MODIFIED BY: WUG *D700*      */
/*                                 06/27/91      MODIFIED BY: emb *D730*      */
/*                                 07/26/91      MODIFIED BY: pml *D793*      */
/*                                 09/08/91      MODIFIED BY: afs *F040*      */
/*                                 10/08/91      MODIFIED BY: dgh *D892*      */
/*  REVISION: 7.0       LAST EDIT: 11/14/91      MODIFIED BY: jms *Fxyz*      */
/*                                 02/21/92      MODIFIED BY: WUG *F221*      */
/*                                 03/19/92      MODIFIED BY: WUG *F283*      */
/*                                 03/19/92      MODIFIED BY: WUG *F285*      */
/*                                 04/06/92               By: jcd *F394*      */
/*                                 05/23/92               By: jcd *F527*      */
/*                                 06/23/92               By: jcd *F679*      */
/*                                 06/30/92      MODIFIED BY: afs *F719*      */
/* Revision: 7.3        Last edit: 09/27/92               By: jcd *G247*      */
/*                                 03/16/93               By: rwl *G821*      */
/*                                 07/01/93               By: rwl *GC91*      */
/*                                 09/22/93               By: gjp *GF76*      */
/* Revision: 7.4        Last edit: 11/30/93               By: rwl *H251*      */
/*                                 03/02/94               By: kws *FM56*      */
/*                                 06/20/94               By: rmh *FO78*      */
/* Oracle changes (share-locks)    09/12/94               By: rwl *FR19*      */
/*                                 01/13/95               By: rwl *G0C0*      */
/*                                 08/22/95               By: str *G0V7*      */
/* Revision: 8.5       Modified:   10/11/95               By: aed *J08V*      */
/* Revision: 8.5       Modified:   11/22/95               By: tvo *J094*      */
/*                                 12/20/95               By: ame *F0WW*      */
/*                                 02/08/96               By: qzl *G1MM*      */
/* Revision: 7.3       Modified:   04/03/96               By: jpm *G1MP*      */
/* Revision: 8.5       Modified:   05/07/96               By: jpm *J0LD*      */
/*                                 05/20/96               By: rkc *G1VJ*      */
/* Revision: 7.3       Modified:   08/12/96               By: taf *G2BY*      */
/* Revision: 8.5       Modified:   01/09/97  By: *H0QT* Cynthia Terry         */
/* REVISION: 8.6E LAST MODIFIED:   02/23/98  BY: *L007* A. Rahane             */
/* Revision: 8.5       Modified:   03/12/98  By: *J2GL* Jean Miller           */
/* Revision: 8.6E      Modified:   04/13/98  By: *G2RK* Vijaya Pakala         */
/* Revision: 8.6E Last Modified:   05/08/98  BY: *J2JB* Suhas Bhargave        */
/* Revision: 8.6E      Modified:   06/02/98  By: *K1NM* Paul Knopf            */
/* Revision: 8.6E Last Modified:   06/11/98  BY: *H1L9* Vijaya Pakala         */
/* Revision: 8.6e                  07/31/98  By: *H1MQ* Vijaya Pakala         */
/* Revision: 8.6E Last Modified:   10/04/98  BY: *J314* Alfred Tan            */
/* Revision: 9.0       Modified:   02/06/99  By: *M06R* Doug Norton           */
/* Revision: 9.0       Modified:   03/13/99  By: *M0BD* Alfred Tan            */
/* Revision: 9.0  Last Modified:   02/23/00  BY: *J3PC* Raphael Thoppil       */
/* Revision: 9.0  Last Modified:   03/29/00  BY: *M0LD* Raphael Thoppil       */
/* Revision: 9.1  Last Modified:   08/13/00  BY: *N0KR* Mark Brown            */
/* Old ECO marker removed, but no ECO header exists *H0CH*                    */
/* Revision: 1.31     BY: Tiziana Giustozzi     DATE: 09/16/01  ECO: *N12M*   */
/* Revision: 1.32     BY: Annasaheb Rahane      DATE: 01/09/02  ECO: *N17M*   */
/* Revision: 1.32     BY: Jean Miller           DATE: 06/26/02  ECO: *P09H*   */
/* Revision: 1.37     BY: Jean Miller           DATE: 06/28/02  ECO: *P08G*   */
/* Revision: 1.38     BY: Ed van de Gevel       DATE: 04/23/03  ECO: *Q003*   */
/* Revision: 1.39     BY: Seema Tyagi           DATE: 08/11/03  ECO: *P0WK*   */
/* $Revision: 1.41 $ BY: Shivganesh Hegde DATE: 02/16/06 ECO: *Q0R3* */

/* SS - 100401.1  By: Roger Xiao */  /*record logs for what program users used everytime */



/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:RunMode=Character                                                        */
/*V8:ConvertMode=NoConvert                                                    */
{mfdeclre.i}
{gplabel.i}
{mf1.i}

define output parameter rstatus as character no-undo.

define shared variable menu as character.
define shared variable menu_log as decimal.

define variable selection as character format "!(1)" no-undo.

define new shared variable proclabel like mnt_label extent 36 format "x(36)".
define new shared variable procselect as integer extent 36.
define new shared variable procexec as character extent 36.
define new shared variable tmpthismenu as character no-undo.
define new shared variable tmpthisselection as integer no-undo.

define variable menutitle as character format "x(63)" no-undo.
define variable offset as integer no-undo.
define variable cselection as character format "x(16)" no-undo.
define variable menuselection as character no-undo.
define variable lastmenu as character no-undo.
define variable thismenu as character no-undo.
define variable thisselection as integer no-undo.
define variable line as character format "x(78)" no-undo.
define variable run_file as character no-undo.
define variable trun_file as character no-undo.
define variable i as integer no-undo.
define variable selchar as character no-undo.
define variable isaprogram like mfc_logical no-undo.
define variable numericselection like mfc_logical no-undo.
define variable lastperiod as integer no-undo.
define variable periods as integer no-undo.
define variable passnbr like mnd_nbr no-undo.
define variable lr_ok like mfc_logical no-undo.
define variable menu1 as character extent 9 no-undo.
define variable j as integer no-undo.
define variable menu_entries as integer no-undo.
define variable t1 as character format "x(18)" no-undo.
define variable t2 as character format "x(18)" no-undo.
define variable t3 as character format "x(18)" no-undo.
define variable menu_title as character format "x(60)" extent 9 no-undo.
define variable can_do_menu as logical no-undo.
define variable group_indx as integer no-undo.
define variable company_name like name no-undo.
define variable user_excluded like mfc_logical no-undo.
define variable tmp_canrun as character no-undo.
define variable rownbr as integer initial 1 no-undo.
define variable c-menu-label as character no-undo.
define variable new-exec-pgm-1 as character no-undo.
define variable new-exec-pgm-2 as character no-undo.
define variable lit-text  as character format "x(47)" no-undo.
define variable lit-text1 as character format "x(20)" no-undo.

define variable l_menu          as   integer     no-undo.
define variable l_menu2         as   character   no-undo.
define variable l_n_selection   as   integer     no-undo.
define variable l_n_menu        as   character   no-undo.
define variable l_thisselection as   integer     no-undo.
define variable l_flag          like mfc_logical no-undo.

define buffer mnddet for mnd_det.
define buffer qadwkfl for qad_wkfl.

assign
   t1 = CAPS(getTermLabelCentered("DISTRIBUTION",18))
   t2 = CAPS(getTermLabelCentered("MANUFACTURING",18))
   t3 = CAPS(getTermLabelCentered("FINANCIAL",18)).

assign rstatus = "".

/* Keep hackers out of expired demos */
if  menu_log <> 55702683.14 then quit.

assign menu = "".

for first mnt_det fields(mnt_label mnt_lang mnt_nbr mnt_select)
   where mnt_nbr = ""
     and mnt_select = 0
     and mnt_lang = global_user_lang
   no-lock :
end.

if available mnt_det then assign menu_title[1] = mnt_label.

/* THE FOLLOWING SECTION ALSO APPEARS IN mfmgmt06.p */
if not can-find(first mnd_det where mnd_nbr >= "" and mnd_select >= 0)
then do:
   if search(global_user_lang_dir + "mg/mgmgmt24.r") <> ? then
      run value(global_user_lang_dir + "mg/mgmgmt24.p").
   else run "mgmgmt24.p".
end.

main-loop:
repeat:
   form
      dtitle
   with frame aa no-labels width 80 no-attr-space page-top
   row rownbr overlay title color normal name.

   {pxmsg.i &MSGNUM=4690 &ERRORLEVEL=1 &MSGBUFFER=lit-text}

   form
      lit-text at 1
      cselection
   with frame bb no-labels width 80 attr-space.

   lit-text:screen-value = lit-text.

   form
      proclabel[1]  proclabel[13]  skip
      proclabel[2]  proclabel[14]  skip
      proclabel[3]  proclabel[15]  skip
      proclabel[4]  proclabel[16]  skip
      proclabel[5]  proclabel[17]  skip
      proclabel[6]  proclabel[18]  skip
      proclabel[7]  proclabel[19]  skip
      proclabel[8]  proclabel[20]  skip
      proclabel[9]  proclabel[21]  skip
      proclabel[10] proclabel[22]  skip
      proclabel[11] proclabel[23]  skip
      proclabel[12] proclabel[24]  skip
   with frame dd no-labels width 80 attr-space.

   form
      t1             at 5
      t2             at 31
      t3             at 57
      skip
      proclabel[01]  format "x(24)"      proclabel[13]  format "x(24)"
      proclabel[25]  format "x(24)" skip proclabel[02]  format "x(24)"
      proclabel[14]  format "x(24)"      proclabel[26]  format "x(24)"
      skip
      proclabel[03]  format "x(24)"      proclabel[15]  format "x(24)"
      proclabel[27]  format "x(24)" skip proclabel[04]  format "x(24)"
      proclabel[16]  format "x(24)"      proclabel[28]  format "x(24)"
      skip
      proclabel[05]  format "x(24)"      proclabel[17]  format "x(24)"
      proclabel[29]  format "x(24)" skip proclabel[06]  format "x(24)"
      proclabel[18]  format "x(24)"      proclabel[30]  format "x(24)"
      skip
      proclabel[07]  format "x(24)"      proclabel[19]  format "x(24)"
      proclabel[31]  format "x(24)" skip proclabel[08]  format "x(24)"
      proclabel[20]  format "x(24)"      proclabel[32]  format "x(24)"
      skip
      proclabel[09]  format "x(24)"      proclabel[21]  format "x(24)"
      proclabel[33]  format "x(24)" skip proclabel[10]  format "x(24)"
      proclabel[22]  format "x(24)"      proclabel[34]  format "x(24)"
      skip
      proclabel[11]  format "x(24)"      proclabel[23]  format "x(24)"
      proclabel[35]  format "x(24)" skip proclabel[12]  format "x(24)"
      proclabel[24]  format "x(24)"      proclabel[36]  format "x(24)"
      skip
   with frame ee no-labels width 80 attr-space.

   assign
      menu1[1] = "exit"
      menu1[2] = "0"
      j = 2.

   if menu = ""
   then do:
      assign
         menu = "0"
         printdefault = "".
   end.

   hide message no-pause.

   /* Press F2 for Help */
   {pxmsg.i &MSGNUM=4868 &ERRORLEVEL=1 &MSGBUFFER=lit-text1}

   block:
   repeat on error undo , retry block:
      assign menu = menu1[j].
      if menu1[j] = "exit" then leave block.

      block1:
      repeat on endkey undo block1 , leave block1:
         status input lit-text1.
         /* Initialize the list of procedure names to be run */
         do i = 1 to 36:
            assign
               proclabel[i] = string(i,">9") + ". "
               procselect[i] = 0
               procexec[i] = "".
         end.

         assign menu_entries = if j = 2 then 36 else 24.

         {gprun1.i ""mflabels.p""}

         if j = 2
         then do:
            hide frame bb.
            hide frame dd.
         end.
         else
            if j = 3 then hide frame bb.

         /* To find the correct company name if 1) it has been changed  */
         /* since last run; 2) database has been switched in multi      */
         /* database environment.                                       */
         release ls_mstr.
         release ad_mstr.
         {gprun.i ""gplkconm.p"" "(input-output company_name)"}

         if global_usrc_right_hdr_disp < 2
         then assign
            name   = company_name + " : " + sdbname("qaddb")
            dtitle = "mfmenu"
            + fill(" ",integer (max (1,39
            - {gprawlen.i &strng="menu_title[j - 1]"} / 2) - 6))
            + menu_title[j - 1]
            + fill(" ",integer (max (1,39
            - {gprawlen.i &strng="menu_title[j - 1]"} / 2) - 8.5))
            + (if global_usrc_right_hdr_disp = 1
               then string(global_userid)
               else string(today)).
         else do:
           find dom_mstr where dom_domain = global_domain no-lock no-error.
           assign name = sdbname("qaddb").
                dtitle = string(dom_sname,"x(14)") + " [" + base_curr + "] "
                       + menu_title[j - 1].
           overlay(dtitle,71,8) = if global_usrc_right_hdr_disp = 3
                                  then string(global_userid,"x(8)")
                                  else string(today,"99/99/99").
         end.

         display dtitle with frame aa.

         if j = 2
         then do:
            color display messages t1 t2 t3 with frame ee.
            color display normal proclabel with frame ee.
            display t1 t2 t3 proclabel with frame ee.

            if l_flag = yes
            then do:
               {pxmsg.i
                  &MSGNUM=5218
                  &ERRORLEVEL=3}
               l_flag = no.
            end. /* IF l_flag = yes*/

         end.
         /* Display 24 labels */
         else do:
            color display normal proclabel[1 for 24] with frame dd.
            display
               proclabel[1] proclabel[2] proclabel[3] proclabel[4]
               proclabel[5] proclabel[6] proclabel[7] proclabel[8]
               proclabel[9] proclabel[10] proclabel[11] proclabel[12]
               proclabel[13] proclabel[14] proclabel[15] proclabel[16]
               proclabel[17] proclabel[18] proclabel[19] proclabel[20]
               proclabel[21] proclabel[22] proclabel[23] proclabel[24]
            with frame dd.
         end.

         display "" @ cselection with frame bb.

         /* Updates mon_mstr when a user goes to a menu screen */
         {gprunp.i "lvgenpl" "p" "setMonitorRecord"
            "(input ""MFG/PRO"",
              input global_userid,
              input mfguser,
              input program-name(1),
              input menu,
              input 0)" }

         mselect:
         do on error undo with frame bb:
            assign
               tmpthismenu = ""
               tmpthisselection = 0
               cselection = "".

            setbb:
            do on error undo , retry:
               assign
                  i = 1
                  lr_ok = no.

               input clear.

               set
                  cselection deblank
               editing:

                  if j = 2 then
                     display proclabel[i] with frame ee.
                  else
                     display proclabel[i] with frame dd.

                  /* Recover from applhelp and setup to timeout */
                  if global_timeout_min > 0
                  then do:
                     readkey pause global_timeout_min * 60.
                            if lastkey = -1 then return.
                  end.

                  else do:
                     readkey.
                  end.

                  hide message no-pause.

                  if keyfunction(lastkey) = "tab" or
                     keyfunction(lastkey) = "cursor-up" or
                     keyfunction(lastkey) = "cursor-down" or
                     (keyfunction (lastkey) = "cursor-left"
                     and lr_ok = yes) or
                     (keyfunction (lastkey) = "cursor-right"
                     and lr_ok = yes) then do on error undo , retry:

                     if keyfunction(lastkey) = "cursor-up"
                     then do:
                        if j = 2 then
                           color display normal proclabel[i]
                           with frame ee.
                        else
                           color display normal proclabel[i]
                           with frame dd.

                        if i = 1 and lr_ok then bell.

                        if i > 1
                        then do while i > 1:
                           assign i = i - 1.
                           if length(proclabel[i]) <> 4 then leave.
                        end.

                        if lr_ok = no
                        then do:
                           assign i = menu_entries.
                           if length(proclabel[i]) = 4 then
                              do while length(proclabel[i]) = 4:
                                 assign i = i - 1.
                              end.

                        end.

                        if j = 2 then
                           color display messages proclabel[i]
                           with frame ee.
                        else
                           color display messages proclabel[i]
                           with frame dd.

                        assign cselection = string(i).
                        display cselection with frame bb.

                     end. /* CURSOR-UP */

                     else
                     if keyfunction(lastkey) = "cursor-down" or
                        keyfunction(lastkey) = "tab"
                     then do:
                        if j = 2 then
                           color display normal proclabel[i]
                           with frame ee.
                        else
                           color display normal proclabel[i]
                           with frame dd.

                        if i = menu_entries then bell.

                        if i < menu_entries then
                           do while i < menu_entries:
                              assign i = i + 1.
                              if length(proclabel[i]) <> 4 then leave.
                           end.

                        if i = menu_entries and length(proclabel[i]) = 4
                        then do while length(proclabel[i]) = 4:
                           assign i = i - 1.
                           if length(proclabel[i]) <> 4 then bell.
                        end.

                        if lr_ok = no then i = 1.

                        if j = 2 then
                           color display messages proclabel[i]
                           with frame ee.
                        else
                           color display messages proclabel[i]
                           with frame dd.

                        assign cselection = string(i).
                        display cselection with frame bb.

                     end. /* CURSOR-DOWN */

                     else if keyfunction(lastkey) = "cursor-right"
                     then do:
                        if j = 2 then
                           color display normal proclabel[i]
                           with frame ee.
                        else
                           color display normal proclabel[i]
                           with frame dd.

                        if i >= menu_entries - 12 + 1 then bell.

                        if i < menu_entries - 12 + 1 then assign i = i + 12.

                        if j = 2 then
                           color display messages proclabel[i]
                           with frame ee.
                        else
                           color display messages proclabel[i]
                           with frame dd.

                        assign cselection = string(i).
                        display cselection with frame bb.

                     end. /* CURSOR-RIGHT */

                     else
                     if keyfunction(lastkey) = "cursor-left"
                     then do:
                        if j = 2 then
                           color display normal proclabel[i]
                           with frame ee.
                        else
                           color display normal proclabel[i]
                           with frame dd.

                        if i <= 12 then bell.

                        if i > 12 then assign i = i - 12.

                        if j = 2 then
                           color display messages proclabel[i]
                           with frame ee.
                        else
                           color display messages proclabel[i]
                           with frame dd.

                        assign cselection = string(i).
                        display cselection with frame bb.

                     end. /* CURSOR-LEFT */

                     if lr_ok = no then assign lr_ok = yes.
                  end.

                  else do:
                     if lr_ok = yes
                     then do:
                        if lastkey = keycode("F1") or
                           keyfunction(lastkey) = "return" or
                           keyfunction(lastkey) = "go" then leave.

                        if j = 2 then
                           color display normal proclabel[i]
                           with frame ee.
                        else
                           color display normal proclabel[i]
                           with frame dd.

                        apply keycode("F7").
                        assign lr_ok = no.

                     end.
                     apply lastkey.

                  end.

               end. /* SET CSELECTION EDITING */

               /* Added and changed '>' to "<>" in following if statements */
               if index(cselection," ") <> 0
               then do:
                  cselection =
                  substring(cselection,1,index(cselection," ") - 1).
               end.

               if index(cselection,".p") <> 0
               then do:
                  assign
                     cselection =
                     substring(cselection,1,index(cselection,".p") - 1).
               end.

               else
               if index(cselection,".w") <> 0 then
                  assign cselection =
                     substring(cselection,1,index(cselection,".w") - 1,"raw").

               /* Added logic for .r extension.                 *G2RK*/
               if index(cselection,".r") <> 0
               then do:
                  assign cselection =
                     substring(cselection,1,index(cselection,".r") - 1,"raw").
               end.

            end. /* setbb: do on error undo */

            if cselection = "" then leave.

            i = index(cselection,",").
            do while i > 0:
               assign
                  substring(cselection,i,1) = "."
                  i = index(cselection,",").
            end.

            assign
               menuselection = menu + "." + cselection.

            if cselection begins "." then
               assign menuselection = "0" + cselection.

            if cselection = "" or cselection = "."
               or index(cselection,"/") > 0
               or index(cselection,"[") > 0
               or index(cselection,"~\") > 0
               or cselection begins "help" or cselection begins "dict"
            then do:
               {pxmsg.i &MSGNUM=13 &ERRORLEVEL=3} /* NOT A VALID CHOICE */
               undo , retry mselect.
            end.

            assign
               numericselection = yes
               i = 1
               lastperiod = 0
               periods = 0.

            do while i <= length(menuselection):
               assign selchar = substring(menuselection,i,1,"raw").

               if selchar = "."
               then do:
                  assign
                     lastperiod = i
                     periods = periods + 1.
               end.

               else if selchar < "0" or selchar > "9" then
                  assign numericselection = no.

               assign i = i + 1.

            end.

            if selchar = "."
            then do:
               /* ENTERED SELECTION CANT END WITH A PERIOD */
               {pxmsg.i &MSGNUM=13 &ERRORLEVEL=3} /* NOT A VALID CHOICE */
               undo , retry mselect.
            end.

            assign isaprogram = no.

            /* ENTERED A NUMERIC MENU SELECTION EG 23 or 23.21.1 */
            if numericselection
            then do:
               if menuselection begins "0."
               then do:
                  if periods = 1 then assign thismenu = "0".
                  else
                  assign
                     thismenu = substring(menuselection,
                     3,lastperiod - 3,"raw").

               end.

               else
                  assign
                     thismenu = substring(menuselection,1,
                     lastperiod - 1,"raw").

               assign
                  thisselection =
                  integer(substring(menuselection,
                  lastperiod + 1,16,"raw"))
                  tmpthismenu = thismenu
                  tmpthisselection = thisselection.

               for first mnd_det
                  fields(mnd_canrun mnd_exec mnd_label mnd_name
                         mnd_nbr mnd_select)
                  where mnd_nbr = thismenu
                    and mnd_select = thisselection no-lock :
               end.

               if not available mnd_det
               then do:
                  {pxmsg.i &MSGNUM=13 &ERRORLEVEL=3} /* NOT A VALID CHOICE */
                  undo , retry mselect.
               end.

               if mnd_nbr = "0" then
                  assign menu_title[j] = string(mnd_select) + ". ".
               else
                  assign menu_title[j] = mnd_nbr + "." +
                     string(mnd_select) + " ".

               for first mnt_det
                  fields(mnt_label mnt_lang mnt_nbr mnt_select)
                  where mnt_nbr = mnd_nbr
                    and mnt_select = mnd_select
                    and mnt_lang = global_user_lang no-lock :
               end.

               if available mnt_det then
                  assign menu_title[j] = menu_title[j] + mnt_label.

               /* DO PASSWORD CHECKING LOOK AT THIS LEVEL UP TO THE */
               /* LAST CHECKED MENU LEVEL TO SEE IF PROTECTED       */
               {gprun1.i ""mfsec.p"" "(input mnd_det.mnd_nbr,
                  input mnd_det.mnd_select,
                  input true,
                  output can_do_menu)"}

               if can_do_menu = false
                  then undo mselect, retry mselect.

               execname = mnd_exec.

               if not can-find(first mnd_det where mnd_nbr = execname)
               then do:
                  assign isaprogram = yes.
               end.

               else do:
                  /* IT IS ANOTHER MENU, BUT IF FROM TOP LEVEL */
                  /* VIA .selection DONT PERMIT IT             */
                  if cselection begins "."
                  then do:
                     {pxmsg.i &MSGNUM=61 &ERRORLEVEL=3}
                     /* SELECTION OF SUBMENUS PERMITTED  */
                     /* FROM MAIN MENU ONLY              */
                     undo , retry mselect.
                  end.

               end.

            end. /* if numericselection then do */

            else do:
               /* THEY ENTERED A MENU SELECTION NAME OR     */
               /* A PROGRAM NAME, SEE IF IT IS IN mnd_det   */
               /* AND CHECK PASSWORD.                       */
               assign
                  execname = cselection
                  isaprogram = yes
                  thismenu = ""
                  thisselection = 0.

               /* SEE IF THEY ENTERED A MENU SELECTION NAME. */

               for first mnd_det
                  fields(mnd_canrun mnd_exec mnd_label mnd_name
                         mnd_nbr mnd_select)
                  where mnd_name = cselection
               no-lock :
               end.

               if available mnd_det
               then do:
                  if mnd_nbr = "0" then
                     assign menu_title[j] = "".
                  else
                     assign menu_title[j] = mnd_nbr + ".".

                  assign
                     menu_title[j] =
                     menu_title[j] + string(mnd_select) + " ".

                  for first mnt_det
                     fields(mnt_label mnt_lang mnt_nbr mnt_select)
                     where mnt_nbr = mnd_nbr
                       and mnt_select = mnd_select
                       and mnt_lang = global_user_lang no-lock :
                  end.

                  if available mnt_det then
                     assign menu_title[j] = menu_title[j] + mnt_label.

                  /* DO PASSWORD CHECKING LOOK AT THIS LEVEL UP TO THE  */
                  /* LAST CHECKED MENU LEVEL TO SEE IF PROTECTED        */
                  {gprun1.i ""mfsec.p"" "(input mnd_det.mnd_nbr,
                     input mnd_det.mnd_select,
                     input true,
                     output can_do_menu)"}

                  if can_do_menu = false
                    then undo mselect, retry mselect.

                  assign
                     thismenu = mnd_nbr
                     thisselection = mnd_select
                     execname = mnd_exec.

                  if can-find(first mnd_det where mnd_nbr = execname)
                  then do:
                     assign isaprogram = no.
                     if menu <> "0"
                     then do:
                        {pxmsg.i &MSGNUM=61 &ERRORLEVEL=3}
                        undo mselect , retry mselect.
                     end.

                  end.

               end. /* if available mnd_det */

               else do:

                  assign run_file = execname.

                  if index(run_file,".") <> 0
                  then do:
                     assign
                        new-exec-pgm-1 = run_file
                        overlay(new-exec-pgm-1,index(run_file,"."),
                        length(run_file,"character"),
                        "character") = ".~."
                        new-exec-pgm-1 = trim(new-exec-pgm-1).
                  end.

                  else assign new-exec-pgm-1 = run_file + ".~.".

                  /* If this program is a substituion for another with */
                  /* an mnd_det, then check that mnd_det's security.   */
                  for each mnds_det no-lock
                    where mnds_exec_sub matches new-exec-pgm-1:

                     if index(mnds_exec,".") <> 0
                     then do:
                        assign
                           new-exec-pgm-2 = mnds_exec
                           overlay(new-exec-pgm-2,index(mnds_exec,"."),
                           length(mnds_exec,"character"),
                           "character") = ".~."
                           new-exec-pgm-2 = trim(new-exec-pgm-2).
                     end.

                     else assign new-exec-pgm-2 = mnds_exec + ".~.".

                     for each mnd_det no-lock
                        where mnd_exec matches new-exec-pgm-2:

                        {gprun1.i ""mfsec.p"" "(input mnd_det.mnd_nbr,
                           input mnd_det.mnd_select,
                           input true,
                           output can_do_menu)"}

                        if can_do_menu = false
                           then undo mselect, retry mselect.

                     end.

                  end.

                  for first mnd_det
                     fields (mnd_canrun mnd_exec mnd_label mnd_name
                             mnd_nbr mnd_select)
                     where mnd_exec matches new-exec-pgm-1
                  no-lock :
                  end.

                  if available mnd_det
                  then do:
                     assign thismenu = mnd_nbr
                        thisselection = mnd_select.

                  for each mnd_det no-lock
                        where mnd_exec matches new-exec-pgm-1:

                        /* DO PSWD CHECK LOOK AT THIS LEVEL UP TO THE  */
                        /* LAST CHECKED MENU LEVEL TO SEE IF PROTECTED */
                        {gprun1.i ""mfsec.p"" "(input mnd_det.mnd_nbr,
                           input mnd_det.mnd_select,
                           input true,
                           output can_do_menu)"}

                        if can_do_menu = false
                           then undo mselect, retry mselect.

                     end. /* for each mnddet */

                  end. /* if available mnd_det */

               end. /* else do (if not available mnd_det) */

            end. /* else do (if not numericselection) */

            if isaprogram
            then do:
               /* IT IS EITHER A MENU PROGRAM SELECTION                    */
               /* OR AN ACTUAL PROGRAMNAME, SO FIND IT AND IF FOUND RUN IT */
               if execname = "QUIT" then leave.

               run_file = execname.

               if index(run_file,".p") > 0 then
                  assign run_file =
                     substring(run_file,1,index(run_file,".p") - 1,"raw").

               else if index(run_file,".w") > 0 then
                  assign run_file =
                     substring(run_file,1,index(run_file,".w") - 1,"raw").

               if index(run_file,".r") > 0 then
                  assign run_file =
                     substring(run_file,1,index(run_file,".r") - 1,"raw").

               assign run_file = global_user_lang_dir
                  + substring(run_file,1,2)
                  + "/" + run_file.

               if search(run_file + ".r") = ?
                  and search(run_file + ".p") = ?
                  and search(run_file + ".w") = ?
               then do:
                  /* NOW LOOK IN THE MAIN DIRECTORY */
                  assign run_file = substring(run_file,
                     length(global_user_lang_dir) + 4,50).

                  if search(run_file + ".r") = ?
                     and search(run_file + ".p") = ?
                     and search(run_file + ".w") = ?
                  then do:
                     /* Selection thisselection (Program execname) */
                     /* not currently installed                    */
                     {pxmsg.i &MSGNUM=4869 &ERRORLEVEL=1
                        &MSGARG1=string(thisselection)
                        &MSGARG2=execname}
                     undo, retry mselect.
                  end.

               end.

               assign dtitle = lc (execname).

               for first mnd_det
                  fields(mnd_canrun mnd_exec mnd_label mnd_name mnd_nbr
                         mnd_select)
                  where mnd_nbr = thismenu
                    and mnd_select = thisselection no-lock :
               end.

               {mfmenu.i}
               hide all no-pause.
               assign help_exec = execname.

               /* FIND PRINTER DEFAULT */
               assign thismenu = thismenu + "." + string(thisselection).
               {mfprdef.i thismenu}

               assign
                  batchrun = no
                  report_userid = global_userid.

               /* Make sure we don't have a transaction outstanding */
               {gprun.i ""gpistran.p""
                  "(input 1,
                    input "" "")"}

               /* Display the Plain Data Entry mode status line, */
               /* (w/o F5=Delete) as default for all programs.  */
               assign ststatus = stline[3].
               status input ststatus.

               c-menu-label = "".

               if available mnd_det and mnd_exec = execname
               then do:
                  if global_user_lang = "" then
                     assign c-menu-label = mnd_label.

                  else if available mnt_det and global_user_lang <> "" then
                     assign c-menu-label = mnt_label.
               end.

               assign
                  trun_file = run_file
                  trun_file =
                  substring(trun_file,r-index(trun_file,"/") + 1,
                  {gprawlen.i &strng=trun_file}).

               assign
                  trun_file =
                  substring(trun_file,r-index(trun_file,"~\") + 1,
                  {gprawlen.i &strng=trun_file})
                  execname = "mfmenu.p" .


/* SS - 100401.1 - B */
{xxlogin-eb21.i}
/* SS - 100401.1 - E */



               if search(run_file + ".r") <> ?
               then do:
                  assign trun_file = trun_file + ".r".
                  {gprun.i ""gpwinrun.p""
                     "(input trun_file, input c-menu-label)"}
               end.
               else if search(run_file + ".p") <> ?
               then do:
                  assign trun_file = trun_file + ".p".
                  {gprun.i ""gpwinrun.p""
                     "(input trun_file, input c-menu-label)"}
               end.

               else if search(run_file + ".w") <> ?
               then do:
                  assign trun_file = trun_file + ".w".
                  {gprun.i ""gpwinrun.p""
                     "(input trun_file, input c-menu-label)"}
               end.
/* SS - 100401.1 - B */
{xxlogoff-eb21.i}
/* SS - 100401.1 - E */


               pause before-hide.

               hide all no-pause.

               assign
                  help_exec = ?
                  dtitle = "".

            end. /* if isaprogram */

            else do:
              /* IT IS A REFERENCE TO ANOTHER MENU */
               assign
                  lastmenu = menu
                  help_exec = execname
                  menu = execname
                  menu1[j] = lastmenu
                  j = j + 1.
            end.

            if     j > 2
               and substring(run_file,7,length(run_file)) = "mgdomchg"
            then do:
               assign
                  l_menu          = length(menu) -
                                       length(substring(menu,1,index(menu,".")
                                          - 1)).
                  l_menu2         = substring(menu,index(menu,".") + 1,
                                       l_menu).
                  l_n_selection   = int(substring(l_menu2,
                                       index(l_menu2,".") + 1,2)).
                  l_thisselection = length(substring(l_menu2,index(l_menu2,".")
                                       + 1 ,2)).
                  l_n_menu        = substring(menu,1,length(menu) -
                                       l_thisselection - 1).

               for first mnd_det
                  fields(mnd_canrun mnd_exec mnd_label
                         mnd_name   mnd_nbr  mnd_select)
                  where mnd_nbr    = l_n_menu
                  and   mnd_select = l_n_selection
               no-lock :
               end. /* FOR FIRST mnd_det */

               /* DO PASSWORD CHECKING LOOK AT THIS LEVEL UP TO THE */
               /* LAST CHECKED MENU LEVEL TO SEE IF PROTECTED       */
               {gprun1.i ""mfsec.p""
                  "(input mnd_det.mnd_nbr,
                    input mnd_det.mnd_select,
                    input false,
                    output can_do_menu)"}

               if can_do_menu = false
               then do:
                  l_flag = yes.
                  next main-loop.
               end. /* IF can_do_menu = FALSE */
            end.  /* IF j > 2 .... */

         end. /* mselect: do on error */

      end.  /* block1: repeat */

      assign j = j - 1.

   end. /* block: repeat */

   assign
      selection = ""
      menu = "".

   repeat:

      assign selection = getTermLabel("NO",1).

      if not can-find(first msg_mstr where
                            msg_lang = global_user_lang and
                            msg_nbr  = 36)
      then
         leave main-loop.

      {pxmsg.i &MSGNUM=36 &ERRORLEVEL=1 &CONFIRM=selection
         &CONFIRM-TYPE='NON-LOGICAL'}  /* PLEASE CONFIRM EXIT */

      if selection = getTermLabel("YES",1) then leave main-loop.

      if selection = "P"
      then do:
         for first mnd_det
            fields(mnd_canrun mnd_exec mnd_label mnd_name mnd_nbr mnd_select)
            where mnd_nbr = "" and mnd_select = 1 no-lock :
         end.

         if not available mnd_det then leave main-loop.

         if available mnd_det
         then do:
            {mfsec.i "mnd_det"}
            if can_do_menu then leave main-loop.
         end.

         /* User is not allowed to access this function */
         {pxmsg.i &MSGNUM=5218 &ERRORLEVEL=3}
         pause.

      end. /* if selection = "P" */

      {pxmsg.i &MSGNUM=37 &ERRORLEVEL=1} /* RETURNING TO MENU */

      input clear.
      assign menu = "".
      next main-loop.

   end. /* repeat */

   input clear.

end. /* mainloop: repeat */

hide all no-pause.

/* CLEAN UP THE QAD_WKFL RECORDS FOR THE CTRL-B FEATURE */
for each qadwkfl exclusive-lock  where qadwkfl.qad_domain = global_domain and
 qad_key1 = mfguser:
   delete qadwkfl.
end.

if selection = "P" then assign rstatus = "P".
