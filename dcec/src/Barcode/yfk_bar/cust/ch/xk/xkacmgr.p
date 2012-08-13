/*----------------------------------------------------------
  File         xkgpwtmt.p
  Description  Kanban item group window time maintenance
  Author       Yang Enping
  Created      2004-04-16
  History
       2004-6-12, Yang Enping, 0001
           1. Spec: 零件组及要货单规范V2.doc
       2004-7-5, Yang Enping, 0009
           Add check date and check time to avoid miss P.L.
	   because of slow system
       2004-11-04, Xiang WH
           add the interval var to replace fixed 2 seconds pause
  ---------------------------------------------------------*/
/*last modified by Tracy 11/17/2004 *zx01* */
/*last modified by hou   03/10/2006 *H01*  */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "AO"}

{pxmaint.i}

/* Define handles for ROP programs */
{pxphdef.i gputlxr}
{pxphdef.i kbknbxr}
{pxphdef.i xkknbxr}
{pxphdef.i kbknbdxr}

/* Kanban Constants */
{kbconst.i}

/* Define Local Variables */

define variable KanbanTransNbr      as integer            no-undo.
define variable msg-text       as character format "x(75)" no-undo.
define variable refInfo as character format "x(18)" label "Reference" no-undo.
define variable prev-next-time           like knbl_next_time no-undo.

define variable time-H-M-S         as character format "99:99:99" no-undo.
define variable time-Days          as integer   format ">>9" no-undo.
define variable time-Hours         as integer   format ">9" no-undo.
define variable time-Minutes       as integer   format ">9" no-undo.
define variable time-Seconds       as integer   format ">9" no-undo.

define buffer bf-knbd_det     for knbd_det.
define buffer bf-knbism_det   for knbism_det.
define buffer bf-knbl_det     for knbl_det.

define buffer bf-xkgp_mstr    for xkgp_mstr .
define var	interval AS  int.



FORM 
 interval label "Interval" colon 30
 SKIP(2)  
with frame a side-labels width  80 THREE-D .


/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


FORM /*GUI*/ 
   time-H-M-S   column-label "Trans Time"
   kbtr_id
   kbtr_part
   kbtr_supermarket_id  column-label "Supermarket"
   refInfo
with STREAM-IO /*GUI*/  down frame b.

setFrameLabels(frame b:handle).

define var prevAuthTime as int .
define var invKanbanCount as int .
define var minKanbanCount as int .
define var urgency as logical .

define var nextPLDate as date .
define var nextPLTime as int .

/*0009*----*/
define var checkDate as date .
define var checkTime as int .
/*----*0009*/

mainloop:
repeat on endkey undo, leave:
/*xwh1103-----*/
   if c-application-mode <> 'web' THEN DO:
      update
         interval
      with frame a.
      {mfquoter.i interval}
   END. 
/*-------xwh1103*/
   hide frame a.

   /* See gpselout.i header for explanation of parameters */
   {gpselout.i
      &printType = "terminal"
      &printWidth = 80
      &pagedFlag = "nopage"
      &stream = " "
      &appendToFile = " "
      &streamedOutputToFile = " "
      &withBatchOption = "yes"
      &displayStatementType = 1
      &withCancelMessage = "yes"
      &pageBottomMargin = 6
      &withEmail = "yes"
      &withWinprint = "yes"
      &defineVariables = "yes"}

   AccumLoop:
   repeat
      on endkey undo AccumLoop, leave AccumLoop
      with frame b down width 80:

      /* Display progress loop information */
      {pxrun.i &PROC  = 'calculateTimeInDDHHMMSS'
               &PROGRAM = 'gputlxr.p'
               &HANDLE = ph_gputlxr
               &PARAM = "(input  time,
                          output time-Days,
                          output time-Hours,
                          output time-Minutes,
                          output time-Seconds)"
               &NOAPPERROR = true
               &CATCHERROR = true}

      msg-text = getTermLabel("PROCESSING",20) + ": " + string(today) +
                 " " + getTermLabel("TIME",20) + ": " +
                 string(time-Hours,"99") +  ":" +
                 string(time-Minutes,"99") +  ":" +
                 string(time-Seconds,"99").
      message msg-text.

      pause interval.


      /* FIRST, FIND CARDS WHERE THE PERIOD RANGE HAS BECOME ACTIVE      */
      /* AND THE CARD IS INACTIVE, MAKE THE CARD ACTIVE AND SEE IF IT    */
      /* CAN BE AUTHORIZED.                                              */
      KNBL-LOOP1:
      for each knbd_det no-lock where
         not knbd_active and
         knbd_active_code = {&KB-CARD-ACTIVE-CODE-PERIOD} and
         /*H01********
         knbd_active_start_date <= today and
         knbd_active_end_date >= today,
         **H01*******/
         /*H01* *下列修改与xgfgmt.p的看板逻辑相关 */
         (knbd_active_start_date <= today and knbd_pou_ref = "" or
          (knbd_active_start_date < today or 
           knbd_active_start_date = today and integer(knbd_pou_ref) <= time)),
         /*H01*/
         each knbl_det fields (knbl_knb_keyid) no-lock where
            knbl_keyid = knbd_knbl_keyid and
            knbl_card_type = {&KB-CARDTYPE-REPLENISHMENT},
         each knb_mstr fields (knb_knbsm_keyid knb_knbi_keyid) no-lock where
            knb_keyid = knbl_knb_keyid,
         each knbsm_mstr fields (knbsm_site) no-lock where
            knbsm_keyid = knb_knbsm_keyid,
         each knbism_det no-lock where
            knbism_knbsm_keyid = knb_knbsm_keyid and
            knbism_knbi_keyid = knb_knbi_keyid:

         /* IN DESKTOP, IF IT FINDS A LOCKED RECORD, IT WILL NOT DETECT THAT */
         /* THE RECORD IS EVER RELEASED; THEREFORE, LOCK ALL OF THE          */
         /* RECORDS NEEDED BEFORE THE WORK IS DONE, IF THE RECORDS CANNOT BE */
         /* LOCKED, THEN SKIP THOSE RECORDS FOR NOW.                         */
         find first bf-knbd_det where
            rowid(bf-knbd_det) = rowid(knbd_det)
            exclusive-lock no-wait no-error.
         if available bf-knbd_det then do:
            find first bf-knbism_det  where
               rowid(bf-knbism_det) = rowid(knbism_det)
               exclusive-lock no-wait no-error.
            if available bf-knbism_det then do:
            find first bf-knbl_det where
               rowid(bf-knbl_det) = rowid(knbl_det)
               exclusive-lock no-wait no-error.
               if available bf-knbl_det then do:

                  {pxrun.i &PROC ='activateCard' &PROGRAM='kbknbdxr.p'
                     &HANDLE=ph_kbknbdxr
                     &PARAM="(buffer bf-knbism_det,
                              buffer bf-knbd_det,
                              buffer bf-knbl_det)"}

                  {pxrun.i &PROC ='updateKanbanCardWithEvent'
                     &PROGRAM='kbknbdxr.p'
                     &HANDLE=ph_kbknbdxr
                     &PARAM="(buffer bf-knbd_det,
                           input {&KB-CARDEVENT-CONSUME},
                           input today,
                           input knbsm_site,
                           input '',
                           output KanbanTransNbr)"}

               end. /* if available bf-knbl_det */
            end.   /* if available bf-knbism_det */
         end. /* if available bf-knbd_det */

         
        {mfrpchk.i } 


      end. /* KNBL-LOOP1 */

      /*------------ Authorization empty kanbans ----------------------*/
      
      KNBL-LOOP1_5:
      for each knbl_det no-lock 
      where knbl_card_type = {&KB-CARDTYPE-REPLENISHMENT}:

         if not can-find(first knbd_det 
    	    where knbd_knbl_keyid = knbl_keyid
	        and knbd_status = {&KB-CARDSTATE-EMPTYACC}
            and knbd_active) then
	        next KNBL-LOOP1_5.

         /* IN DESKTOP, IF IT FINDS A LOCKED RECORD, IT WILL NOT DETECT THAT */
         /* THE RECORD IS EVER RELEASED; THEREFORE, LOCK ALL OF THE          */
         /* RECORDS NEEDED BEFORE THE WORK IS DONE, IF THE RECORDS CANNOT BE */
         /* LOCKED, THEN SKIP THOSE RECORDS FOR NOW.                         */

         find first bf-knbl_det 
	 where rowid(bf-knbl_det) = rowid(knbl_det)
         exclusive-lock no-wait no-error.
         
	 if available bf-knbl_det then do:

            for each knbd_det no-lock
	    where knbd_knbl_keyid = bf-knbl_det.knbl_keyid 
	    and   knbd_status = {&KB-CARDSTATE-EMPTYACC}
            and knbd_active:

               find first bf-knbd_det 
	       where rowid(bf-knbd_det) = rowid(knbd_det)
               exclusive-lock no-wait no-error.
               
	       if not available bf-knbd_det then next KNBL-LOOP1_5.

            end. /* for each knbd_det */

	    {pxrun.i &PROC ='authorizeAccumulatorCards' &PROGRAM='xkknbxr.p'
                     &HANLDE=ph_xkknbxr.p
                     &PARAM="(buffer knbl_det)"
            }

	    prevAuthTime = time .

            /* Show all kanban transaction history created */
            for each knb_mstr
            fields(knb_knbi_keyid)
            no-lock where knb_keyid = knbl_knb_keyid,
            
	    each knbi_mstr  fields(knbi_part knbi_step) no-lock
	    where knbi_keyid = knb_knbi_keyid,
            
	    each kbtr_hist no-lock 
	    where kbtr_part = knbi_part 
	    and  kbtr_step = knbi_step 
	    and  kbtr_trans_date  = today 
	    and  kbtr_trans_time >= integer(prevAuthTime) 
	    and  kbtr_transaction_event = {&KB-CARDEVENT-AUTHORIZE}:

               {pxrun.i &PROC  = 'calculateTimeInDDHHMMSS'
                        &PROGRAM = 'gputlxr.p'
                        &HANDLE = ph_gputlxr
                        &PARAM = "(input  kbtr_trans_time,
                                   output time-Days,
                                   output time-Hours,
                                   output time-Minutes,
                                   output time-Seconds)"
                        &NOAPPERROR = true
                        &CATCHERROR = true}
               assign
                  refInfo =  string(kbtr_source_ref1 +
                                   (if kbtr_source_ref2 <> ""
                   then "-" else "") +
                                   kbtr_source_ref2 +
                                   (if kbtr_source_ref3 <> ""
                   then "-" else "") +
                                   kbtr_source_ref3 +
                                   (if kbtr_source_ref4 <> ""
                   then "-" else "") +
                                   kbtr_source_ref4 +
                                   (if kbtr_source_ref5 <> ""
                   then "-" else "") +
                                   kbtr_source_ref5)
                  time-H-M-S =     string(time-Hours,"99") +
                                   string(time-Minutes,"99") +
                                   string(time-Seconds,"99").

               display
                  time-H-M-S
                  kbtr_id
                  kbtr_part
                  kbtr_supermarket_id
                  refInfo
               with frame b STREAM-IO /*GUI*/ .
               down 1 with frame b.

               pause 10 before-hide.

            end. /* for each knb_mstr.... */
         end. /* if available bf-knbl_det */
        {mfrpchk.i } 

      end. /* for each knbl_det */
      /*------ End of authorization kanbans ---------------------*/

      /*-------- Check and print pick list ----------------------*/

      for each xkgp_mstr no-lock
      where xkgp_auto,
      each xkgpd_det no-lock
      where xkgpd_group = xkgp_group 
      and xkgpd__log01,
      first knbi_mstr no-lock
      where knbi_part = xkgpd_part,
      each knb_mstr no-lock
      where knb_knbi_keyid = knbi_keyid,
      first knbsm_mstr no-lock
      where knbsm_keyid = knb_knbsm_keyid
      and knbsm_supermarket_id = xkgpd_sup
      and knbsm_site = xkgpd_site,
      first knbl_det no-lock
      where knbl_knb_keyid = knb_keyid
      and knbl_card_type = {&KB-CARDTYPE-REPLENISHMENT}
      break by xkgpd_group by xkgpd_line:
         if first-of(xkgpd_group) then do:
            FOR EACH usrw_wkfl WHERE usrw_key1 = "emptykb" + mfguser:
               DELETE usrw_wkfl .
            END.
            /*0009*----*/
	    checkDate = today .
	    checkTime = time .
	    /*----*0009*/
	 end .

	 /* check if urgency replenishment is necessary */
	 urgency = false .
	 invKanbanCount = 0 .

	 for each knbd_det no-lock
	 where knbd_knbl_keyid = knbl_keyid
         and knbd_active
         and not (   knbd_status = {&KB-CARDSTATE-EMPTYACC}
	           or 
		     (   knbd_status = {&KB-CARDSTATE-EMPTYAUTH}
                      and knbd_print_dispatch
		      )
		  ):
            invKanbanCount = invKanbanCount + 1 .
	 end .
         if invKanbanCount <= xkgpd_urgcard then do:
	    urgency = true .

	    for each knbd_det no-lock
	    where knbd_knbl_keyid = knbl_keyid
	    and knbd_active
	    and knbd_status = {&KB-CARDSTATE-EMPTYAUTH}
	    and knbd_print_dispatch:
               {gprun.i ""xkplpre.p""
                        "(input knbd_id, true, urgency,false)" 
               }
	    end .
         end .

	 /* check if schedule replenishment is necessary */
	 if not urgency
	 and (xkgp_next_date < checkDate
	      or 
	      (xkgp_next_date = checkDate and xkgp_next_time <= checkTime)
	     )
	 then do:
	    urgency = false .

	    for each knbd_det no-lock
	    where knbd_knbl_keyid = knbl_keyid
	    and knbd_active
	    and knbd_status = {&KB-CARDSTATE-EMPTYAUTH}
	    and knbd_print_dispatch:

               {gprun.i ""xkplpre.p""
                        "(input knbd_id, true, urgency,false)" 
               }
	    end .

	 end .

	 if last-of(xkgpd_group) then do:
            {gprun.i ""xkkbdlrp1.p""} 

	    /* Assign next PL print time */
	    nextPLDate = ? .
            {pxrun.i &PROC ='GetGroupNextPLTime'
                     &PROGRAM='xkknbxr.p'
                     &HANDLE=ph_xkknbxr
                     &PARAM="(
                              input xkgp_group,
			      /*0009*----*/
			      input checkDate,
			      input checkTime,
			      /*----*0009*/
                              output nextPLDate,
			      output nextPLTime
			      )"
            }

	    if nextPLDate <> ? then do:
	       find first bf-xkgp_mstr exclusive-lock
	       where recid(bf-xkgp_mstr) = recid(xkgp_mstr) 
	       no-error .
	       if available(bf-xkgp_mstr) then do:
                  assign bf-xkgp_mstr.xkgp_next_date = nextPLDate
		         bf-xkgp_mstr.xkgp_next_time = nextPLTime .
	       end .
            end .

	 end .

      end .

      /*--------- End of check and print pick list --------------*/

      {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

   end. /* AccumLoop */

end.   /************************ mainloop ********************/
