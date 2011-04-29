/* bmpsiq.p - PRODUCT STRUCTURE INQUIRY                                       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/ /*K10M*/
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
/* REVISION: 9.1      LAST MODIFIED: 11/19/01 BY: *M1QD* Kirti Desai          */
/* REVISION: eB SP5 Linux US    LAST MODIFIED: 11/28/05    BY: *Kaine Zhang*    *eas051a* */

/* Note: Changes made here may be desireable in fspsiq.p also. */

     /* DISPLAY TITLE */
     /*eas051a*  {mfdtitle.i "b+ "} /*FL07*/  */
     /*eas051a*/ {mfdeclre.i}
     /*eas051a*/ {gplabel.i}

/* ***********************eas051a B Add********************** */
DEFINE SHARED WORK-TABLE xtpar_mstr
	FIELD xtpar_part	LIKE pt_part
	.
	
DEFINE SHARED WORK-TABLE xtsub_mstr
	FIELD xtsub_part	LIKE pt_part
	.
/* ***********************eas051a E Add********************** */

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
/*GH69*  define variable eff_date like ar_effdate.      */
/*FL07*  /*GH69*/ define variable eff_date as date column-label "As of Dt". */
/*FL07*/ define variable eff_date as date column-label {&bmpsiq_p_3}.
/*J3J4** define variable parent like ps_par.       */
/*J3J4*/ define variable parent like ps_par label {&bmpsiq_p_7} no-undo.
     define variable desc1 like pt_desc1.
     define variable um like pt_um.
     define variable phantom like mfc_logical format "yes" label {&bmpsiq_p_4}.
     define variable iss_pol like pt_iss_pol format {&bmpsiq_p_1}.
/*J30L*     define variable record as integer extent 100. */
     define variable lvl as character format "x(7)" label {&bmpsiq_p_6}.

/*K05D* /*H013*/ define variable ecmnbr like ecm_nbr /*H474*/ label "ECN Number".   */
/*K05D*/ define variable ecmnbr like ecm_nbr label {&bmpsiq_p_2}.
/*H013*/ define variable ecmid     like wo_lot.
/*H013*/ define variable dbase     like si_db.
/*H013*/ define shared variable global_recid as recid.

/*M1QD** /*H013*/ define buffer psmstr for ps_mstr. */

/*H013*/ define variable rev like pt_rev.
/*H013*/ define variable relation like mfc_logical.

     eff_date = today.

/*H013*/ /****************** Delete: Begin **************************
*    form
*       space(1)
*       parent
*           desc1
*       um
*       eff_date
*       maxlevel
*    with frame a width 80 attr-space no-underline.
/*H013*/ ******************* Delete: End ****************************/

     form
/*J3J4**  parent  colon 13          */
/*J3J4*/  parent  colon 23
/*J3J4**  desc1   colon 38 no-label */
/*J3J4*/  desc1   colon 44 no-label
/*J168* um        colon 62 no-label */
/*J3J4** /*J168*/um   colon 64 no-label */
/*J3J4*/  um      colon 74 no-label
       eff_date   colon 13 label {&bmpsiq_p_3}
       maxlevel   colon 31
       rev        colon 51
       ecmnbr     colon 13
       ecmid      colon 31
       dbase      colon 51
     with frame a side-label width 80.

     /* SET EXTERNAL LABELS */
     setFrameLabels(frame a:handle).

     /* SET PARENT TO GLOBAL PART NUMBER */
     parent = global_part.

/*K10M*/ {wbrp01.i}
     /*eas051a*  REPEAT:  */
     /*eas051a*/  FOR EACH xtpar_mstr NO-LOCK:

/* ***********************eas051a B Add********************** *
 *	/*H013*/ /* update parent eff_date maxlevel with frame a editing: */
 *	/*K10M*/ if c-application-mode <> 'web':u then
 *	/*H013*/    update parent eff_date maxlevel rev ecmnbr ecmid dbase
 *	/*H013*/    with frame a editing:
 *	
 *	
 *	           if frame-field = "parent" then do:
 *	/*J12T*/          /* NEXT/PREV THRU 'NON-SERVICE' BOMS */
 *	/*J12T*/          {mfnp05.i bom_mstr bom_fsm_type "bom_fsm_type = """" "
 *	                   bom_parent "input parent"}
 *	
 *	/*J12T*       {mfnp.i bom_mstr parent bom_parent parent bom_parent     */
 *	/*J12T*       bom_parent}                                              */
 *	
 *	          if recno <> ? then do:
 *	             parent = bom_parent.
 *	/*J168*/             /** BEGIN DELETE SECTION **
 *	.            display bom_parent @ parent with frame a.
 *	.            find pt_mstr where pt_part = parent no-lock no-error.
 *	.            if available pt_mstr
 *	.            then display pt_desc1 @ desc1 pt_um @ um with frame a.
 *	.            else display bom_desc @ desc1 bom_batch_um @ um
 *	.           with frame a.
 *	/*J168*/             ** END DELETE SECTION **/
 *	/*J168*              ** BEGIN ADD SECTION **/
 *	             display parent
 *	                             bom_desc     @ desc1
 *	                             bom_batch_um @ um with frame a.
 *	
 *	                     if bom_desc = "" then do:
 *	                        find pt_mstr where pt_part = parent no-lock no-error.
 *	                        if available pt_mstr
 *	                        then display pt_desc1 @ desc1 with frame a.
 *	                     end.
 *	/*J168*              ** END ADD SECTION **/
 *	             recno = ?.
 *	          end.
 *	           end.    /* if frame-field = "parent" */
 *	/*H013*/ /******************* Added: Begin **************************/
 *	           else if frame-field = "ecmnbr" then do:
 *	          global_recid = ?.
 *	          {mfnp05.i ecm_mstr ecm_mstr
 *	          "(ecm_eff_date <> ?)"
 *	          ecm_nbr "input ecmnbr"}
 *	          if global_recid <> ? then do:
 *	             recno = global_recid.
 *	             find ecm_mstr where recid(ecm_mstr) = recno.
 *	             global_recid = ?.
 *	          end.
 *	
 *	          if recno <> ? then display
 *	             substring(ecm_nbr,1,8)  @ ecmnbr
 *	             substring(ecm_nbr,9,8)  @ ecmid
 *	             substring(ecm_nbr,17,8) @ dbase with frame a.
 *	           end.
 *	/*H013*/ /****************** Added: End ****************************/
 *	           else do:
 *	          status input.
 *	          readkey.
 *	          apply lastkey.
 *	           end.
 *	        end. /*editing*/
 * ***********************eas051a E Add********************** */

/*eas051a*  /*K10M*/ {wbrp06.i &command = update &fields = "  parent eff_date maxlevel rev  */
        /*eas051a*  ecmnbr ecmid dbase " &frm = "a"}  */

/* ***********************eas051a B Add********************** */
PARENT = xtpar_part.
/* ***********************eas051a E Add********************** */

/*M05Y*/ if maxlevel = ? then do:
/*M05Y*/   assign maxlevel = 0.
/*eas051a*  /*M05Y*/   DISPLAY  */
/*eas051a*  /*M05Y*/     maxlevel  */
/*eas051a*  /*M05Y*/   with frame a.  */
/*M05Y*/  end.  /* if maxlevel = ? */

/*K10M*/ if (c-application-mode <> 'web':u) or
/*K10M*/ (c-application-mode = 'web':u and
/*K10M*/ (c-web-request begins 'data':u)) then do:

        desc1 = "".
        um = "".

        find pt_mstr use-index pt_part
           where pt_part = parent no-lock no-error.
/*FP95*/    find bom_mstr no-lock where bom_parent = parent no-error.
/*FP95*/    if available bom_mstr then /*G740*/ do:

/*J12T* /*G740*/       {fsbomv.i bom_parent 2}  */
/*J12T*/       /* WARN USER IF A SERVICE BOM */
/*J12T*/       if bom_fsm_type = "FSM" then do:
/*eas051a*  /*J12T*/            {mfmsg.i 7487 2}    /* THIS IS AN SSM BILL OF MATERIAL.. */  */
/*J12T*/       end.     /* if bom_fsm_type = "FSM" */

/*FP95*/       assign um = bom_batch_um
/*F0FD* /*FP95*/  desc1 = if bom_desc <> "" then bom_desc else pt_desc1 */
/*FP95*/          parent = bom_parent.
/*F0FD*/          if bom_desc <> "" then desc1 = bom_desc.
/*F0FD*/          else if available pt_mstr then desc1 = pt_desc1.
/*FP95*/    end.
/*FP95*/    else
        if available pt_mstr then do:
           assign um = pt_um
           desc1 = pt_desc1
          parent = pt_part.
        end.
/*FP95**    MOVED THE FOLLOWING CODE HIGHER, SO IT IS THE DEFAULT RATHER
      *     THAN PT_MSTR
      *
      *     else do:
      *        find bom_mstr no-lock where bom_parent = parent no-error.
      *        if available bom_mstr then  /*G740*/ do:
/*G740*/          {fsbomv.i bom_parent 2}
      *           assign um = bom_batch_um
      *              parent = bom_parent.
/*G740*/       end.
/*FP95*/    end.        */

/*F671*     if parent = "" then do: */
/*F671*/    if not available pt_mstr and not available bom_mstr then do:
           hide message no-pause.
           /*eas051a*  {mfmsg.i 17 3}  */
           /* PART NUMBER DOES NOT EXIST. */
           /*eas051a*  display desc1 um with frame a.  */
/*K10M*/     if c-application-mode = 'web':u then return.
           undo, retry.
        end.

        /*eas051a*  display parent desc1 um with frame a.  */

/*J30L*      hide frame heading.          */
/*J30L*/     hide frame heading no-pause.
/*J30L*/     clear frame heading all no-pause.

        assign
           level    = 1
           comp     = parent
/*M1QD*/   lvl      = getTermLabel("PARENT",6)
           maxlevel = min(maxlevel,99).

/*H013*/    /****************** Added: Begin *******************************/
        if (ecmnbr + ecmid + dbase) <> "" then do:
           find ecm_mstr where ecm_nbr = string(ecmnbr,"x(8)") +
           string(ecmid,"x(8)") + string(dbase,"x(8)") no-lock no-error.
           if not available ecm_mstr then do:
/*K05D*       {mfmsg.i 5610 3}    /* ECN DOES NOT EXIST */          */

/*K1ZM**      /*K05D*/      {mfmsg.i 9710 3}    /* PCO DOES NOT EXIST */  */
/*eas051a*  /*K1ZM*/      {mfmsg.i 2155 3}  */
/*K1ZM*/      /* PCO DOES NOT EXIST */

/*K10M*/ if c-application-mode = 'web':u then return.
        /*eas051a*  else next-prompt ecmnbr with frame a.  */
          undo, retry.
           end.
           else if available ecm_mstr and ecm_eff_date = ? then do:
/*K05D*       {mfmsg.i 5685 3}    /* ECN HAS NOT BEEN INCORPORATED */   */

/*K1ZM**      /*K05D*/  {mfmsg.i 9785 3}  /* PCO HAS NOT BEEN INCORPORATED */ */
/*K1ZM*/      {mfmsg.i 2181 3}
/*K1ZM*/      /* PCO HAS NOT BEEN INCORPORATED */

/*K10M*/ if c-application-mode = 'web':u then return.
        /*eas051a*  else next-prompt ecmnbr with frame a.  */
          undo, retry.
           end.
           eff_date = ecm_eff_date.
        end.



/*K10M*/ end.
         /* SELECT PRINTER */
         /*eas051a*  {mfselprt.i "terminal" 80}.  */

        if rev <> "" then do:
           relation = no.
           for each ecm_mstr no-lock where ecm_eff_date <> ?, each ecd_det
           no-lock where ecd_nbr = ecm_nbr and ecd_new_rev = rev break by
           ecm_eff_date
/*H370*/       descending: /* to find the latest effective ecn of entered rev */
          if ecd_part = parent then do:
             relation = yes.
             eff_date = ecm_eff_date.
             leave.
          end.
           end.
        end.
        else if (ecmnbr + ecmid + dbase) <> "" then do:
           {gprun.i ""ecbmec01.p"" "(input comp, input ecm_nbr,
           input maxlevel, output relation)"}
        end.
/*H013*/    /******************* Added: End ********************************/

/*M1QD*/    /* BEGIN ADD SECTION */

            if available pt_mstr
            then
               comp = if pt_bom_code <> ""
                      then
                         pt_bom_code
                      else
                         pt_part.

            /*eas051a*  display  */
               /*eas051a*  lvl  */
               /*eas051a*  parent @ ps_comp  */
               /*eas051a*  desc1  */
               /*eas051a*  um  */
            /*eas051a*  with frame heading.  */
            /*eas051a*  down with frame heading.  */

            if  available pt_mstr
            and pt_desc2 > ""
            then do with frame heading:
               /*eas051a*  display  */
                  /*eas051a*  pt_desc2 @ desc1.  */
               /*eas051a*  down with frame heading.  */
            end. /* IF AVAILABLE pt_mstr ... */

            if comp <> parent
            then do with frame heading:
               /*eas051a*  display  */
                  /*eas051a*  (getTermLabel("BOM",3) + ": " + comp) @ desc1.  */
               /*eas051a*  down with frame heading.  */
            end. /* IF comp <> parent */

/*M1QD*/    /* END ADD SECTION */

/*H013*/    if ((rev <> "" or ecmnbr + ecmid + dbase <> "") and relation) or
/*H013*/    (rev = "" and ecmnbr + ecmid + dbase = "") then do:
/*J30L*/      run process_report in this-procedure (input comp,input level).

/*J30L*/  /* Changed entire logic to Recursive calling of Internal Procedure */
/*J30L**  BEGIN DELETE **
 *        find first ps_mstr use-index ps_parcomp where ps_par = comp
 *            no-lock no-error.
 *         repeat with frame heading:
 *
 *            {mfrpchk.i}                            /*G345*/
 *
 *            /*DETAIL FORM */
 *            form
 *           lvl
 *           ps_comp
 *           desc1
 *           ps_qty_per
 *           um
 *           phantom
 *           ps_ps_code
 *           iss_pol
 *            with frame heading width 80
 *            no-attr-space.
 *
 *            if not available ps_mstr then do:
 *           repeat:
 *              level = level - 1.
 *              if level < 1 then leave.
 *              find ps_mstr where recid(ps_mstr) = record[level]
 *              no-lock no-error.
 *              comp = ps_par.
 *              find next ps_mstr use-index ps_parcomp where ps_par = comp
 *              no-lock no-error.
 *              if available ps_mstr then leave.
 *           end.
 *            end.
 *            if level < 1 then leave.
 *
 *            if eff_date = ? or (eff_date <> ? and
 *            (ps_start = ? or ps_start <= eff_date)
 *            and (ps_end = ? or eff_date <= ps_end)) then do:
 *
 *           assign um = ""
 *               desc1 = ""
 *             iss_pol = no
 *             phantom = no.
 *
 *           find pt_mstr where pt_part = ps_comp no-lock no-error.
 *           if available pt_mstr then do:
 *              assign um = pt_um
 *              desc1 = pt_desc1
 *                iss_pol = pt_iss_pol
 *                phantom = pt_phantom.
 *           end.
 *           else do:
 *              find bom_mstr no-lock where bom_parent = ps_comp no-error.
 *              if available bom_mstr then
 *              assign um = bom_batch_um
 *              desc1 = bom_desc.
 *           end.
 *
 *           record[level] = recid(ps_mstr).
 *           lvl = ".......".
 *           lvl = substring(lvl,1,min(level - 1,6)) + string(level).
 *           if length(lvl) > 7
 *           then lvl = substring(lvl,length(lvl) - 6,7).
 *
 *           if frame-line = frame-down and frame-down <> 0
 *           and available pt_mstr and pt_desc2 > ""
 *           then down 1 with frame heading.
 *
 *           display lvl ps_comp desc1
 *           ps_qty_per
 *           um phantom ps_ps_code iss_pol
 *           with frame heading.
 *
 *           if available pt_mstr and pt_desc2 > ""
 *           then do with frame heading:
 *              down 1.
 *              display pt_desc2 @ desc1.
 *           end.
 *
 *           if level < maxlevel or maxlevel = 0 then do:
 *              comp = ps_comp.
 *              level = level + 1.
 *              find first ps_mstr use-index ps_parcomp where ps_par = comp
 *              no-lock no-error.
 *           end.
 *           else do:
 *              find next ps_mstr use-index ps_parcomp where ps_par = comp
 *              no-lock no-error.
 *           end.
 *            end.
 *            else do:
 *           find next ps_mstr use-index ps_parcomp where ps_par = comp
 *           no-lock no-error.
 *            end.
 *         end.
 *J30L** END DELETE */

/*H013*/    end. /* End of if relation */
        /*eas051a*  {mfreset.i}  */
        /*eas051a*  {mfmsg.i 8 1}  */
     END.
     global_part = parent.

/*eas051a*  /*K10M*/ {wbrp04.i &frame-spec = a}  */

/* ***********************eas051a B Add********************** */
/************************************************************/
/************************************************************/
/* ***********************eas051a E Add********************** */

/*J30L* BEGIN ADD PROCEDURE */
procedure process_report:
define query q_ps_mstr for ps_mstr .
define input parameter comp like ps_comp no-undo.
define input parameter level as integer no-undo.
           /*DETAIL FORM */
find bom_mstr no-lock where bom_parent = comp no-error.
/*J3J4** find pt_mstr no-lock where pt_part = bom_parent no-error.   */
/*J3J4*/    for first pt_mstr
/*J3J4*/       fields (pt_bom_code pt_desc1 pt_desc2
/*J3J4*/               pt_iss_pol  pt_part  pt_phantom pt_um)
/*J3J4*/       no-lock where pt_part = comp:
/*J3J4*/    end. /* FOR FIRST pt_mstr */
/*J3J4*/    if available pt_mstr and pt_bom_code <> "" then
/*J3J4*/       comp = pt_bom_code.

open query q_ps_mstr for each ps_mstr use-index ps_parcomp
             where ps_par = comp no-lock.

get first q_ps_mstr no-lock.

if not available ps_mstr then return.

   form
     lvl
     ps_comp
     desc1
     ps_qty_per
     um
     phantom
     ps_ps_code
     iss_pol
   with frame heading  width 80 no-attr-space.

repeat while avail ps_mstr with frame heading  down :

  /* SET EXTERNAL LABELS */
  setFrameLabels(frame heading:handle).
  {mfrpchk.i}

  if eff_date = ? or (eff_date <> ? and
     (ps_start = ? or ps_start <= eff_date)
     and (ps_end = ? or eff_date <= ps_end)) then do:

     assign um = ""
            desc1 = ""
        iss_pol = no
        phantom = no.

     find pt_mstr where pt_part = ps_comp no-lock no-error.
     if available pt_mstr then do:
       assign um = pt_um
          desc1 = pt_desc1
          iss_pol = pt_iss_pol
              phantom = pt_phantom.
     end.
     else do:
       find bom_mstr no-lock where bom_parent = ps_comp no-error.
       if available bom_mstr then
         assign um = bom_batch_um
            desc1 = bom_desc.
     end.

     lvl = ".......".
     lvl = substring(lvl,1,min(level - 1,6)) + string(level).

     if length(lvl) > 7
     then lvl = substring(lvl,length(lvl) - 6,7).

     if frame-line = frame-down and frame-down <> 0
        and available pt_mstr and pt_desc2 > ""
     /*eas051a*  then down 1 with frame heading.  */
     /*eas051a*/  THEN .

     /*eas051a*  display  */
       /*eas051a*  lvl ps_comp  */
       /*eas051a*  desc1 ps_qty_per  */
       /*eas051a*  um phantom ps_ps_code iss_pol  */
     /*eas051a*  with frame heading.  */
     /*eas051a*  down 1 with frame heading.  */
     
		/* ***********************eas051a B Add********************** */
		IF NOT CAN-FIND(FIRST xtsub_mstr WHERE xtsub_part = ps_comp) THEN DO:
			CREATE xtsub_mstr.
			xtsub_part = ps_comp.
		END.
		/* ***********************eas051a E Add********************** */

     if available pt_mstr and pt_desc2 > ""
     then do with frame heading:
       /*eas051a*  display pt_desc2 @ desc1 with frame heading .  */
       /*eas051a*  down 1 with frame heading.  */
     end.

     if level < maxlevel or maxlevel = 0 then do:

       run process_report in this-procedure (input ps_comp, input level + 1).
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
end procedure.
/*J30L* END ADD PROCEDURE */
