/* GUI CONVERTED from bmpsiq.p (converter v1.78) Fri Oct 29 14:36:05 2004 */
/* bmpsiq.p - PRODUCT STRUCTURE INQUIRY                                       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.28 $                                                         */
/*K10M         */
/*V8:ConvertMode=Report                                              */
/* REVISION: 1.0        LAST EDIT: 06/11/86       MODIFIED BY: EMB            */
/* REVISION: 1.0        LAST EDIT: 11/03/86       MODIFIED BY: EMB *12*       */
/* REVISION: 1.0        LAST EDIT: 11/03/86       MODIFIED BY: EMB *36*       */
/* REVISION: 2.0        LAST EDIT: 03/23/87       MODIFIED BY: EMB *12*       */
/* REVISION: 2.1        LAST EDIT: 10/20/87       MODIFIED BY: WUG *A94*      */
/* REVISION: 4.0        LAST EDIT: 12/30/87                BY: WUG*A137*      */
/* REVISION: 4.0        LAST EDIT: 04/28/88       MODIFIED BY: EMB (*12*)     */
/* REVISION: 5.0        LAST EDIT: 05/03/89                BY:WUG *B098*      */
/* REVISION: 7.0        LAST EDIT: 03/23/92       MODIFIED BY: emb *F671*     */
/* Revision: 7.3        Last edit: 11/19/92             By: jcd *G345*        */
/* REVISION: 7.3        LAST EDIT: 02/24/93             BY: sas *G740*        */
/* REVISION: 7.3        LAST EDIT: 12/20/93             BY: ais *GH69*        */
/* Revision: 7.3        Last edit: 12/29/93             By: ais *FL07*        */
/* REVISION: 7.4        LAST EDIT: 01/07/94             BY: qzl *H013*        */
/* REVISION: 7.4        LAST EDIT: 05/16/94             BY: qzl *H370*        */
/* REVISION: 7.4        LAST EDIT: 08/08/94             BY: ais *FP95*        */
/* REVISION: 7.4        LAST EDIT: 08/09/94             BY: bcm *H474*        */
/* REVISION: 7.2        LAST EDIT: 01/18/94             By: qzl *F0FD*        */
/* REVISION: 8.5    LAST MODIFIED: 07/30/96  BY: *J12T* Sue Poland            */
/* REVISION: 8.5    LAST MODIFIED: 10/16/96  BY: *J168* Murli Shastri         */
/* REVISION: 8.6    LAST MODIFIED: 01/30/97  BY: *K05D* Kieu Nguyen           */
/* REVISION: 8.6    LAST MODIFIED: 10007/97  BY: *K0LP* John Worden           */
/* REVISION: 8.6        LAST EDIT: 10/15/97             By: mur *K10M*        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 9.0      LAST MODIFIED: 09/22/98   BY: *J30L* Raphael T.         */
/* REVISION: 9.0      LAST MODIFIED: 01/19/99   BY: *M05Y* Mark Badock        */
/* REVISION: 9.0      LAST MODIFIED: 02/24/99   BY: *K1ZM* Mugdha Tambe       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 07/15/99   BY: *J3J4* Jyoti Thatte       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn                  */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.25  BY: Kirti Desai DATE: 11/19/01 ECO: *M1QD* */
/* Revision: 1.27  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* $Revision: 1.28 $ BY: Manish Dani        DATE: 09/16/04 ECO: *P2KR* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* Note: Changes made here may be desireable in fspsiq.p also. */

/* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "1+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE bmpsiq_p_1 "/no"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsiq_p_2 "PCO Number"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsiq_p_3 "As Of"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsiq_p_4 "Ph"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsiq_p_5 "Levels"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsiq_p_6 "Level"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsiq_p_7 "Parent Item/BOM Code"
/* MaxLen:26 Comment: Parent Item or Bill Of Material Code */

/* ********** End Translatable Strings Definitions ********* */

define variable comp like ps_comp.
define variable level as integer.
define variable maxlevel as integer format ">>>" label {&bmpsiq_p_5}.
define variable eff_date as date column-label {&bmpsiq_p_3}.
define variable parent like ps_par label {&bmpsiq_p_7} no-undo.
define variable desc1 like pt_desc1.
define variable um like pt_um.
define variable phantom like mfc_logical format "yes" label {&bmpsiq_p_4}.
define variable iss_pol like pt_iss_pol format {&bmpsiq_p_1}.
define variable lvl as character format "x(7)" label {&bmpsiq_p_6}.
define variable ecmnbr like ecm_nbr label {&bmpsiq_p_2}.
define variable ecmid     like wo_lot.
define variable dbase     like si_db.
define shared variable global_recid as recid.
define variable rev like pt_rev.
define variable relation like mfc_logical.

eff_date = today.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
parent  colon 23
   desc1   colon 44 no-label
   um      colon 74 no-label
   eff_date   colon 13 label {&bmpsiq_p_3}
   maxlevel   colon 31
   rev        colon 51
   ecmnbr     colon 13
   ecmid      colon 31
   dbase      colon 51
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM /*GUI*/ 
   lvl
   ps_comp
   desc1
   ps_qty_per
   um
   phantom
   ps_ps_code
   iss_pol
with STREAM-IO /*GUI*/  frame heading  width 80 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame heading:handle).

/* SET PARENT TO GLOBAL PART NUMBER */
parent = global_part.

{wbrp01.i}
repeat:

   /* update parent eff_date maxlevel with frame a editing: */
   if c-application-mode <> 'web'
   then
      update
         parent
         eff_date
         maxlevel
         rev
         ecmnbr
         ecmid
         dbase
         with frame a
   editing:

      if frame-field = "parent"
      then do:
         /* NEXT/PREV THRU 'NON-SERVICE' BOMS */
         {mfnp05.i bom_mstr bom_fsm_type " bom_mstr.bom_domain = global_domain
         and bom_fsm_type  = """" "
            bom_parent "input parent"}

         if recno <> ?
         then do:
            parent = bom_parent.

            display
               parent
               bom_desc     @ desc1
               bom_batch_um @ um
               with frame a.

            if bom_desc = ""
            then do:

               for first pt_mstr
                  fields( pt_domain pt_bom_code pt_desc1 pt_desc2 pt_iss_pol
                         pt_part pt_phantom pt_um)
                   where pt_mstr.pt_domain = global_domain and  pt_part = parent
                  no-lock:
               end. /* FOR FIRST pt_mstr */

               if available pt_mstr
               then
                  display
                     pt_desc1 @ desc1
                     with frame a.
            end.

            recno = ?.
         end.
      end.    /* if frame-field = "parent" */
      else
      if frame-field = "ecmnbr"
      then do:
         global_recid = ?.
         {mfnp05.i ecm_mstr ecm_mstr
            " ecm_mstr.ecm_domain = global_domain and (ecm_eff_date  <> ?)"
            ecm_nbr "input ecmnbr"}
         if global_recid <> ?
         then do:

            recno = global_recid.

            for first ecm_mstr
               fields( ecm_domain ecm_eff_date ecm_nbr)
               where recid(ecm_mstr) = recno
               no-lock:
            end. /* FOR FIRST ecm_mstr */

            global_recid = ?.
         end.

         if recno <> ?
         then
            display
               substring(ecm_nbr,1,8)  @ ecmnbr
               substring(ecm_nbr,9,8)  @ ecmid
               substring(ecm_nbr,17,8) @ dbase
               with frame a.
      end.
      else do:
         status input.
         readkey.
         apply lastkey.
      end.
   end. /*editing*/

   {wbrp06.i &command = update &fields = "  parent eff_date maxlevel rev
        ecmnbr ecmid dbase " &frm = "a"}

   if maxlevel = ?
   then do:

      maxlevel = 0.
      display
         maxlevel
      with frame a.
   end.  /* if maxlevel = ? */

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      assign
         desc1 = ""
         um = "".

      for first pt_mstr
         fields( pt_domain pt_bom_code pt_desc1 pt_desc2 pt_iss_pol
                pt_part pt_phantom pt_um)
         use-index pt_part
          where pt_mstr.pt_domain = global_domain and  pt_part = parent
         no-lock:
      end. /* FOR FIRST pt_mstr */

      for first bom_mstr
         fields( bom_domain bom_batch_um bom_desc bom_fsm_type bom_parent)
          where bom_mstr.bom_domain = global_domain and  bom_parent = parent
         no-lock:
      end. /* FOR FIRST bom_mstr */

      if available bom_mstr
      then do:

         /* WARN USER IF A SERVICE BOM */
         if bom_fsm_type = "FSM"
         then do:

            {pxmsg.i &MSGNUM=7487 &ERRORLEVEL=2}
            /* THIS IS AN SSM BILL OF MATERIAL.. */
         end.     /* if bom_fsm_type = "FSM" */

         assign
            um = bom_batch_um
            parent = bom_parent.

         if bom_desc <> ""
         then
            desc1 = bom_desc.
         else
         if available pt_mstr
         then
            desc1 = pt_desc1.
      end.
      else
      if available pt_mstr
      then
         assign
            um = pt_um
            desc1 = pt_desc1
            parent = pt_part.

      if not available pt_mstr
      and not available bom_mstr
      then do:

         hide message no-pause.
         /* PART NUMBER DOES NOT EXIST. */
         {pxmsg.i &MSGNUM=17 &ERRORLEVEL=3}

         display
            desc1
            um
            with frame a.

         if c-application-mode = 'web'
         then
            return.

         undo, retry.
      end.

      display
         parent
         desc1
         um
         with frame a.

      hide frame heading no-pause.
      clear frame heading all no-pause.

      assign
         level    = 1
         comp     = parent
         lvl      = getTermLabel("PARENT",6)
         maxlevel = min(maxlevel,99).

      if (ecmnbr + ecmid + dbase) <> ""
      then do:
         for first ecm_mstr
            fields( ecm_domain ecm_eff_date ecm_nbr)
             where ecm_mstr.ecm_domain = global_domain and  ecm_nbr =
             string(ecmnbr,"x(8)") +
                            string(ecmid,"x(8)") +
                            string(dbase,"x(8)")
            no-lock:
         end. /* FOR FIRST ecm_mstr */

         if not available ecm_mstr
         then do:

            /* PCO DOES NOT EXIST */
            {pxmsg.i &MSGNUM=2155 &ERRORLEVEL=3}

            if c-application-mode = 'web'
            then
               return.
            else
               next-prompt ecmnbr with frame a.

            undo, retry.
         end.
         else
         if available ecm_mstr
         and ecm_eff_date = ?
         then do:

            /* PCO HAS NOT BEEN INCORPORATED */
            {pxmsg.i &MSGNUM=2181 &ERRORLEVEL=3}

            if c-application-mode = 'web'
            then
               return.
            else
               next-prompt ecmnbr with frame a.

            undo, retry.
         end.
         eff_date = ecm_eff_date.
      end.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 80
               &pagedFlag = " "
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
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


   if rev <> ""
   then do:
      relation = no.
      for each ecm_mstr
         fields( ecm_domain ecm_eff_date ecm_nbr)
         no-lock
          where ecm_mstr.ecm_domain = global_domain and  ecm_eff_date <> ?,
            each ecd_det
            fields( ecd_domain ecd_nbr ecd_new_rev ecd_part)
            no-lock
             where ecd_det.ecd_domain = global_domain and  ecd_nbr = ecm_nbr
            and ecd_new_rev = rev
            break by ecm_eff_date
            descending: /* to find the latest effective ecn of entered rev */
         if ecd_part = parent
         then do:

            assign
               relation = yes
               eff_date = ecm_eff_date.
            leave.
         end.
      end.
   end.
   else
   if (ecmnbr + ecmid + dbase) <> ""
   then do:
      {gprun.i ""ecbmec01.p"" "(input comp, input ecm_nbr,
           input maxlevel, output relation)"}
   end.

   if available pt_mstr
   then
      comp = if pt_bom_code <> ""
             then
                pt_bom_code
             else
                pt_part.

   display
      lvl
      parent @ ps_comp
      desc1
      um
      with frame heading STREAM-IO /*GUI*/ .
      down with frame heading.

   if  available pt_mstr
   and pt_desc2 > ""
   then do with frame heading:
      display
         pt_desc2 @ desc1 WITH STREAM-IO /*GUI*/ .
      down with frame heading.
   end. /* IF AVAILABLE pt_mstr ... */

   if comp <> parent
   then do with frame heading:
      display
         (getTermLabel("BILL_OF_MATERIAL",3) + ": " + comp) @ desc1 WITH STREAM-IO /*GUI*/ .
      down with frame heading.
   end. /* IF comp <> parent */

   if ((rev <> "" or ecmnbr + ecmid + dbase <> "") and relation) or
      (rev = "" and ecmnbr + ecmid + dbase = "")
   then do:

      run process_report (input comp,input level).

   end. /* End of if relation */

   {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

global_part = parent.

{wbrp04.i &frame-spec = a}

PROCEDURE process_report:
   define input parameter comp like ps_comp no-undo.
   define input parameter level as integer no-undo.

   define query q_ps_mstr for ps_mstr
      fields( ps_domain ps_comp ps_end ps_par ps_ps_code ps_qty_per ps_start).

   for first bom_mstr
      fields( bom_domain bom_batch_um bom_desc bom_fsm_type bom_parent)
       where bom_mstr.bom_domain = global_domain and  bom_parent = comp
      no-lock:
   end. /* FOR FIRST bom_mstr */

   for first pt_mstr
      fields( pt_domain pt_bom_code pt_desc1 pt_desc2
      pt_iss_pol  pt_part  pt_phantom pt_um)
      no-lock
       where pt_mstr.pt_domain = global_domain and  pt_part = comp:
   end. /* FOR FIRST pt_mstr */

   if available pt_mstr
   and pt_bom_code <> ""
   then
      comp = pt_bom_code.

   open query q_ps_mstr
      for each ps_mstr
      use-index ps_parcomp
       where ps_mstr.ps_domain = global_domain and  ps_par = comp no-lock.

   get first q_ps_mstr no-lock.

   if not available ps_mstr
   then
      return.

   repeat while available ps_mstr with frame heading  down:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame heading:handle).
      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/


      if eff_date = ? or (eff_date <> ? and
         (ps_start = ? or ps_start <= eff_date)
         and (ps_end = ? or eff_date <= ps_end))
      then do:

         assign
            um = ""
            desc1 = ""
            iss_pol = no
            phantom = no.

         for first pt_mstr
            fields( pt_domain pt_bom_code pt_desc1 pt_desc2 pt_iss_pol
                   pt_part pt_phantom pt_um)
             where pt_mstr.pt_domain = global_domain and  pt_part = ps_comp
            no-lock:
         end. /* FOR FIRST pt_mstr */

         if available pt_mstr
         then do:
            assign
               um = pt_um
               desc1 = pt_desc1
               iss_pol = pt_iss_pol
               phantom = pt_phantom.
         end.
         else do:
            for first bom_mstr
               fields( bom_domain bom_batch_um bom_desc bom_fsm_type bom_parent)
                where bom_mstr.bom_domain = global_domain and  bom_parent =
                ps_comp
               no-lock:
            end. /* FOR FIRST bom_mstr */
            if available bom_mstr
            then
               assign
                  um = bom_batch_um
                  desc1 = bom_desc.
         end.

         assign
            lvl = "......."
            lvl = substring(lvl,1,min(level - 1,6)) + string(level).

         if length(lvl) > 7
         then
            lvl = substring(lvl,length(lvl) - 6,7).

         if frame-line = frame-down and frame-down <> 0
            and available pt_mstr and pt_desc2 > ""
         then
            down 1 with frame heading.

         display
            lvl
            ps_comp
            desc1
            ps_qty_per
            um
            phantom
            ps_ps_code
            iss_pol
         with frame heading STREAM-IO /*GUI*/ .
         down 1 with frame heading.

         if available pt_mstr
         and pt_desc2 > ""
         then do with frame heading:
            display
               pt_desc2 @ desc1
               with frame heading  STREAM-IO /*GUI*/ .
            down 1 with frame heading.
         end.

         if level < maxlevel
         or maxlevel = 0
         then do:

            run process_report (input ps_comp, input level + 1).
            get next q_ps_mstr no-lock.
         end.
         else do:
            get next q_ps_mstr no-lock.
         end.
      end.  /* End of Valid date */
      else do:
         get next q_ps_mstr no-lock.
      end.
   end.  /* End of Repeat loop */
   close query q_ps_mstr.
END PROCEDURE.
