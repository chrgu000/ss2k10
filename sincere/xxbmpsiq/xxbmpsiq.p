/* xxbmpsiq.p - PRODUCT STRUCTURE INQUIRY - copy forom bmpsiq.p              */
/* REVISION: 0BYP LAST MODIFIED: 12/01/10   BY: zy                           */
/* Environment: Progress:10.1B   QAD:eb21sp6    Interface:Character          */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "101201.1"}

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

form
   parent  colon 23
   desc1   colon 44 no-label
   um      colon 74 no-label
   eff_date   colon 13 label {&bmpsiq_p_3}
   maxlevel   colon 31
   rev        colon 51
   ecmnbr     colon 13
   ecmid      colon 31
   dbase      colon 51
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   lvl
   ps_comp
   ps_qty_per
   um
   phantom
   ps_ps_code
   iss_pol
   desc1
   pt_desc2
with frame heading  width 106 no-attr-space.

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
      with frame heading.
   if available pt_mstr then display pt_desc2 with frame heading.
      down with frame heading.
/*   if  available pt_mstr                                 */
/*   and pt_desc2 > ""                                     */
/*   then do with frame heading:                           */
/*      display                                            */
/*         pt_desc2 @ desc1.                               */
/*      down with frame heading.                           */
/*   end. /* IF AVAILABLE pt_mstr ... */                   */

   if comp <> parent
   then do with frame heading:
      display
         (getTermLabel("BILL_OF_MATERIAL",3) + ": " + comp) @ desc1.
      down with frame heading.
   end. /* IF comp <> parent */

   if ((rev <> "" or ecmnbr + ecmid + dbase <> "") and relation) or
      (rev = "" and ecmnbr + ecmid + dbase = "")
   then do:

      run process_report (input comp,input level).

   end. /* End of if relation */

   {mfreset.i}

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
      {mfrpchk.i}

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
         with frame heading.
         if available pt_mstr then display pt_desc2 with frame heading.
         down 1 with frame heading.

/*         if available pt_mstr                             */
/*         and pt_desc2 > ""                                */
/*         then do with frame heading:                      */
/*            display                                       */
/*               pt_desc2 @ desc1                           */
/*               with frame heading .                       */
/*            down 1 with frame heading.                    */
/*         end.                                             */

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
