/* wowoisc.p - WORK ORDER ISSUE WITH SERIAL NUMBERS - ISSUE COMPONENTS        */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.39.1.1 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.5      CREATED:       05/01/96   BY: *G1MN* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 05/13/96   BY: *G1TT* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 07/31/96   BY: *J137* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 03/14/97   BY: *G2JJ* Murli Shastri      */
/* REVISION: 8.5      LAST MODIFIED: 05/02/97   BY: *H0YS* Russ Witt          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Steve Nugent       */
/* REVISION: 9.1      LAST MODIFIED: 12/07/99   BY: *L0M1* Jyoti Thatte       */
/* REVISION: 9.1      LAST MODIFIED: 03/08/00   BY: *L0TF* Kirti Desai        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/17/00   BY: *M0PQ* Falguni Dalal      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb                */
/* REVISION: 9.1      LAST MODIFIED: 11/01/00   BY: *M0VP* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 09/21/00   BY: *N0WT* BalbeerS Rajput    */
/* REVISION: 9.1      LAST MODIFIED: 12/12/00   BY: *L16J* Thomas Fernandes   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.19          BY: Seema Tyagi        DATE: 05/28/01  ECO: *N0Z8* */
/* Revision: 1.21          BY: Vandna Rohira      DATE: 09/18/01  ECO: *M1LJ* */
/* Revision: 1.23          BY: Ashish Maheshwari  DATE: 07/17/02  ECO: *N1GJ* */
/* Revision: 1.24          BY: A.R. Jayaram       DATE: 08/08/02  ECO: *N1QY* */
/* Revision: 1.25          BY: K Paneesh          DATE: 11/14/02  ECO: *N1ZG* */
/* Revision: 1.27          BY: Anitha Gopal       DATE: 03/28/03  ECO: *P0PG* */
/* Revision: 1.28          BY: Narathip W.        DATE: 04/29/03  ECO: *P0QN* */
/* Revision: 1.30          BY: Paul Donnelly (SB) DATE: 06/28/03  ECO: *Q00N* */
/* Revision: 1.33          BY: Shoma Salgaonkar   DATE: 10/09/03  ECO: *P15S* */
/* Revision: 1.37          BY: Ken Casey          DATE: 02/19/04  ECO: *N2GM* */
/* Revision: 1.38          BY: Max Iles           DATE: 07/08/04  ECO: *N2VQ* */
/* Revision: 1.39          BY: Pankaj Goswami     DATE: 11/15/04  ECO: *P2V2* */
/* $Revision: 1.39.1.1 $            BY: Manjusha Inglay    DATE: 03/22/05  ECO: *P3D7* */




/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/01/05  ECO: *xp001*  */ /*同nbr一起发料*/
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/01/22  ECO: *xp002*  */ /*加自编单号*/
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*DISPLAY TITLE */
{mfdeclre.i }

{cxcustom.i "WOWOISC.P"}

{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE wowoisc_p_1 "Substitute"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisc_p_2 "Qty Picked"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisc_p_3 "Qty Open"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisc_p_4 "Qty to Iss"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisc_p_5 "Ref"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisc_p_6 "Multi Entry"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisc_p_7 "Op"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisc_p_8 "Loc"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisc_p_9 "Qty Alloc"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisc_p_10 "Qty B/O"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisc_p_11 "Cancel B/O"
/* MaxLen: Comment: */

/*********** End Translatable Strings Definitions ********* */

define input parameter  wo-op    as   integer.
define output parameter undo-all like mfc_logical.

define variable undo-input  like mfc_logical.
define variable qopen       like wod_qty_all column-label {&wowoisc_p_3}.
define variable yn          like mfc_logical.
define variable i           as   integer.
define variable sub_comp    like mfc_logical label {&wowoisc_p_1}.
define variable firstpass   like mfc_logical.
define variable cancel_bo   like mfc_logical
   label {&wowoisc_p_11}.
define variable op               like wod_op.
define variable msg-counter      as   integer        no-undo.
define variable overissue_ok     like mfc_logical    no-undo.
define variable lineid_list      as   character      no-undo.
define variable currid           as   character      no-undo.
define variable l_remove_srwkfl  like mfc_logical    no-undo.
define variable l_overissue_yn   like mfc_logical    no-undo.
define variable prompt_for_op    like mfc_logical    no-undo.
define variable l_error          like mfc_logical    no-undo.
define variable l_temp_from_part like pt_part        no-undo.
define variable l_temp_to_part   like pt_part        no-undo.
{&WOWOISC-P-TAG3}


define var v_nbr like wo_nbr . /*xp001*/
define var v_lot like wo_lot . /*xp001*/
define var v_qty_open  like wod_qty_all . /*xp001*/
define var v_qty_a     like wod_qty_all . /*xp001*/
define var nbr_rmks    as char format "x(18)" label "自编单".



define temp-table temp 
	field t_domain      like wod_domain 
	field t_nbr         like wod_nbr 
	field t_part        like wod_part 
	field t_qty_all     like wod_qty_all
	field t_qty_chg     like wod_qty_chg 
	field t_qty_iss     like wod_qty_iss  
	field t_qty_pick    like wod_qty_pick
	field t_qty_req     like wod_qty_req 
	field t_bo_chg      like wod_bo_chg
	field t_rmks        as char format "x(18)"
	field t_site        like wod_site 
	field t_loc         like wod_loc	
	/*field t_critical    like wod_critical 
	field t_iss_date    like wod_iss_Date  */	
	index temp IS PRIMARY 
		t_domain  ASCENDING
		t_nbr     ASCENDING
		t_part    ASCENDING .


define temp-table rlswo
		field rls_lot like wo_lot .




define new shared variable transtype           as     character
                                               initial "ISS-WO".
define     shared variable eff_date            like   glt_effdate.
define     shared variable part                like   wod_part.
define     shared variable wo_recno            as     recid.
define     shared variable site                like   sr_site      no-undo.
define     shared variable location            like   sr_loc       no-undo.
define     shared variable lotserial           like   sr_lotser    no-undo.
define     shared variable lotref              like   sr_ref format "x(8)"
                                                                   no-undo.
define     shared variable lotserial_qty       like   sr_qty       no-undo.
define     shared variable multi_entry         like   mfc_logical  no-undo.
define     shared variable lotserial_control   as     character.
define     shared variable cline               as     character.
define     shared variable total_lotserial_qty like   wod_qty_chg.
define     shared variable trans_um            like   pt_um.
define     shared variable trans_conv          like   sod_um_conv.
define     shared variable wod_recno           as     recid.
define     shared variable lotnext             like   wo_lot_next .
define     shared variable lotprcpt            like   wo_lot_rcpt no-undo.
define     shared variable h_wiplottrace_procs as     handle      no-undo.
define     shared variable h_wiplottrace_funcs as     handle      no-undo.

/* FUNCTION FORWARD DECLARATIONS */
{wlfnc.i}

/* CONSTANTS DEFINITIONS */
{wlcon.i}

{&WOWOISC-P-TAG1}

{&WOWOISC-P-TAG4}
form with frame c 5 down no-attr-space width 80.
{&WOWOISC-P-TAG5}

for first clc_ctrl
   fields( clc_domain clc_comp_issue)
    where clc_ctrl.clc_domain = global_domain no-lock:
end. /* FOR FIRST clc_ctrl */

{&WOWOISC-P-TAG6}
form  /*xp001*/
 /*  part           colon 13   label "零件号"
   pt_desc1					 no-label 
   site           colon 53
   
   v_lot          colon 13   label "工单ID" 
   op             colon 31   label {&wowoisc_p_7} 
   location       colon 53   label {&wowoisc_p_8}
 
   lotserial_qty  colon 13
   pt_um          colon 31
   lotserial      colon 53 
   
   sub_comp       colon 13
   cancel_bo      colon 31
   lotref         colon 53
   multi_entry    column-label "多记录"
*/
   part           colon 13
   site           colon 53
   location       colon 68   label {&wowoisc_p_8}
   pt_desc1       colon 13
   lotserial      colon 53
   lotserial_qty  colon 13
   pt_um          colon 31
   lotref         colon 53
   sub_comp       colon 13
   cancel_bo      colon 31
   nbr_rmks       colon 53 



with frame d
side-labels
width 80
attr-space.
{&WOWOISC-P-TAG7}

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).
setFrameLabels(frame d:handle).

pause 0.

view frame c.

view frame d.

{&WOWOISC-P-TAG8}
pause before-hide.


undo-all = yes.

mainloop:
do transaction on endkey undo, leave:

	for each rlswo: delete rlswo . end.

	find wo_mstr where recid(wo_mstr) = wo_recno exclusive-lock.
	v_nbr = wo_nbr. /*xp001*/
	v_lot = wo_lot . /*xp001*/

	for each wo_mstr where wo_domain = global_domain 
					and wo_nbr = v_nbr 
					and (lookup(wo_status,"A,R") <> 0 ) no-lock:
		create rlswo.
		assign rls_lot = wo_lot .
	end.

	find wo_mstr  where recid(wo_mstr) = wo_recno  exclusive-lock.



         for each wod_det
				fields( wod_domain wod_bo_chg  wod_critical wod_iss_date
						wod_loc     wod_lot      wod_nbr
						wod_op      wod_part     wod_qty_all
						wod_qty_chg wod_qty_iss  wod_qty_pick
						wod_qty_req wod_site   wod__chr01)
				 where wod_det.wod_domain = global_domain 
				 and (  wod_nbr  = wo_nbr )
				 and  (wod_op    = wo-op   or    wo-op     = 0)
				 no-lock  ,
			each rlswo where rls_lot = wod_lot no-lock
			 break by wod_part:

			find first temp where t_domain = global_domain 
							and t_site = wod_site 
							and t_nbr  = wod_nbr 
							and t_part = wod_part
			no-error .
			if not avail temp then do:
				create temp .
				assign 
					t_domain = global_domain 
					t_site   = wod_site  /*第一笔wod的site*/
					t_loc    = wod_loc /*第一笔wod的loc*/
					t_nbr    = wod_nbr
					t_part   = wod_part 
					t_qty_all  = wod_qty_all
				    t_qty_chg  = wod_qty_chg 
					t_qty_iss  = wod_qty_iss  
					t_qty_pick = wod_qty_pick
					t_qty_req  = wod_qty_req 
					t_bo_chg   = wod_bo_chg
					t_rmks     = wod__chr01.
			end.
			else do:
				assign 
					t_qty_all  = t_qty_all + wod_qty_all
				    t_qty_chg  = t_qty_chg + wod_qty_chg 
					t_qty_iss  = t_qty_iss + wod_qty_iss  
					t_qty_pick = t_qty_pick + wod_qty_pick
					t_qty_req  = t_qty_req + wod_qty_req 
					t_bo_chg   = t_bo_chg + wod_bo_chg.
			end.

         end. /* FOR EACH wod_det */




   setd:
   do while true:

      /* DISPLAY DETAIL */
      select-part:
      repeat:

         clear frame c all no-pause.

         clear frame d no-pause.

         view frame c.

         view frame d.

		 for each temp where t_domain = global_domain 
			 and  t_nbr  = wo_nbr 			 
			 and   t_part >= part 
             no-lock break by t_part:

            if t_qty_req >= 0
            then
               qopen = max(0, t_qty_req - max(t_qty_iss,0)).
            else
               qopen = min(0, t_qty_req - min(t_qty_iss,0)).

            display
               t_part		label "部品/成品编号"
               qopen        format "->>>>>>>9.9<<<<<<<"
                            label  "短缺量"
               t_qty_all  format "->>>>>>>9.9<<<<<<<"
                            label  "备料量"
               t_qty_pick format "->>>>>>>9.9<<<<<<<"
                            label "已领料量"
               t_qty_chg  format "->>>>>>>9.9<<<<<<<"
                            label "发行数量"
               t_bo_chg   format "->>>>>>>9.9<<<<<<<"
                            label "欠交量"
            with frame c.

            if frame-line(c) = frame-down(c)
            then
               leave.

            down 1 with frame c.

         end. /* FOR EACH temp */

/**************
		 for each wod_det
            fields( wod_domain wod_bo_chg  wod_critical wod_iss_date
                    wod_loc     wod_lot      wod_nbr
                    wod_op      wod_part     wod_qty_all
                    wod_qty_chg wod_qty_iss  wod_qty_pick
                    wod_qty_req wod_site)
             where wod_det.wod_domain = global_domain 
			 and (  /*wod_lot   = wo_lot  xp001*/ wod_nbr  = wo_nbr 			 
					and   wod_part >= part
					and  (wod_op    = wo-op   or    wo-op     = 0)
            ) no-lock
			 /* by wod_lot  xp001*/
            by wod_part:

            if wod_qty_req >= 0
            then
               qopen = max(0, wod_qty_req - max(wod_qty_iss,0)).
            else
               qopen = min(0, wod_qty_req - min(wod_qty_iss,0)).

            display
               wod_part
               qopen        format "->>>>>>>9.9<<<<<<<"
                            label  {&wowoisc_p_3}
               wod_qty_all  format "->>>>>>>9.9<<<<<<<"
                            label  {&wowoisc_p_9}
               wod_qty_pick format "->>>>>>>9.9<<<<<<<"
                            label {&wowoisc_p_2}
               wod_qty_chg  format "->>>>>>>9.9<<<<<<<"
                            label {&wowoisc_p_4}
               wod_bo_chg   format "->>>>>>>9.9<<<<<<<"
                            label {&wowoisc_p_10}
            with frame c.

            if frame-line(c) = frame-down(c)
            then
               leave.

            down 1 with frame c.

         end. /* FOR EACH wod_det */
*********/


         /* gpiswrap.i QUERIES THE SESSION PARAMETER FOR */
         /* THE MFGWRAPPER TAG                           */
         if not {gpiswrap.i}
         then
            input clear.

         assign
            part = ""
            op   = 0.

         do on error undo, retry:

            set
               part
            with frame d
            editing:

			   if frame-field = "part"       then do:

                  recno = ?.

                  /* FIND NEXT/PREVIOUS RECORD */
                  {mfnp05.i 
					 temp 
					 temp
                     " t_domain = global_domain 
					   and t_nbr   = v_nbr
                     "
                     t_part
                     "input part" }

                  if recno <> ?
                  then do:

                     assign
                        part  = t_part.

                     display
                        part
                     with frame d.

                     for first pt_mstr
                        fields( pt_domain pt_critical pt_desc1 pt_loc
                                pt_lot_ser  pt_part  pt_um)
                         where pt_mstr.pt_domain = global_domain and  pt_part =
                         t_part
                        no-lock:
                     end. /* FOR FIRST pt_mstr */

                     if available pt_mstr
                     then
                        display
                           pt_um
                           pt_desc1
                        with frame d.

                     display
                        t_qty_chg   @ lotserial_qty
                        no          @ sub_comp
                        no          @ cancel_bo
                        ""          @ lotserial
                        t_loc       @ location
                        t_site      @ site
						t_rmks      @ nbr_rmks
                        /*""          @ multi_entry*/
                     with frame d.
                     {&WOWOISC-P-TAG9}

                  end. /* IF recno <> ? */

               end. /* IF FRAME-FIELD = "part" */
			   else do:
                  status input.
                  readkey.
                  apply lastkey.
               end. /* ELSE */
            end. /*SET part op WITH FRAME d EDITING */
			assign part .			
			 

            status input.

            if part = ""
            then
               leave.


            firstpass = yes.

            frame-d-loop:
            repeat:

               assign
                  cancel_bo   = no
                  sub_comp    = no
                  multi_entry = no.


				if firstpass = no then do:
						 for each temp : delete temp. end.

						 for each wod_det
								fields( wod_domain wod_bo_chg  wod_critical wod_iss_date
										wod_loc     wod_lot      wod_nbr
										wod_op      wod_part     wod_qty_all
										wod_qty_chg wod_qty_iss  wod_qty_pick
										wod_qty_req wod_site  wod__chr01)
								 where wod_det.wod_domain = global_domain 
								 and (  wod_nbr  = wo_nbr )
								 and  (wod_op    = wo-op   or    wo-op     = 0)
							 no-lock,
							each rlswo where rls_lot = wod_lot no-lock
							break by wod_part:

							find first temp where t_domain = global_domain 
											and t_site = wod_site 
											and t_nbr  = wod_nbr 
											and t_part = wod_part
							no-error .
							if not avail temp then do:
								create temp .
								assign 
									t_domain = global_domain 
									t_site   = wod_site  /*第一笔wod的site*/
									t_loc    = wod_loc /*第一笔wod的loc*/
									t_nbr    = wod_nbr
									t_part   = wod_part 
									t_qty_all  = wod_qty_all
									t_qty_chg  = wod_qty_chg 
									t_qty_iss  = wod_qty_iss  
									t_qty_pick = wod_qty_pick
									t_qty_req  = wod_qty_req 
									t_bo_chg   = wod_bo_chg
									t_rmks     = wod__chr01.
							end.
							else do:
								assign 
									t_qty_all  = t_qty_all + wod_qty_all
									t_qty_chg  = t_qty_chg + wod_qty_chg 
									t_qty_iss  = t_qty_iss + wod_qty_iss  
									t_qty_pick = t_qty_pick + wod_qty_pick
									t_qty_req  = t_qty_req + wod_qty_req 
									t_bo_chg   = t_bo_chg + wod_bo_chg.
							end.

						 end. /* FOR EACH wod_det */

						 /* clear frame c all no-pause.

						 for each temp where t_domain = global_domain 
							 and  t_nbr  = wo_nbr 			 
							 and   t_part >= part 
							 no-lock break by t_part:

							if t_qty_req >= 0
							then
							   qopen = max(0, t_qty_req - max(t_qty_iss,0)).
							else
							   qopen = min(0, t_qty_req - min(t_qty_iss,0)).

							display
							   t_part		label "部品/成品编号"
							   qopen        format "->>>>>>>9.9<<<<<<<"
											label  "短缺量"
							   t_qty_all  format "->>>>>>>9.9<<<<<<<"
											label  "备料量"
							   t_qty_pick format "->>>>>>>9.9<<<<<<<"
											label "已领料量"
							   t_qty_chg  format "->>>>>>>9.9<<<<<<<"
											label "发行数量"
							   t_bo_chg   format "->>>>>>>9.9<<<<<<<"
											label "欠交量"
							with frame c.

							if frame-line(c) = frame-down(c)
							then
							   leave.

							down 1 with frame c.

						 end. FOR EACH temp */


				end. /*if firstpass = no*/

               find first temp  where t_domain = global_domain 
							and t_nbr    = v_nbr
                            and t_part   = part
                            use-index temp
                            exclusive-lock no-error.

               if not available temp
               then do:
					message "零件编号有误,请重新输入." .
					undo,retry .
               end. /* IF NOT AVAILABLE temp */


               for first pt_mstr
                  fields( pt_domain pt_critical pt_desc1 pt_loc
                          pt_lot_ser  pt_part  pt_um)
                   where pt_mstr.pt_domain = global_domain 
				   and  pt_part = t_part
                  no-lock:
               end. /* FOR FIRST pt_mstr */

               if not available pt_mstr
               then do:

                  /* ITEM DOES NOT EXIST */
                  {pxmsg.i &MSGNUM=16 &ERRORLEVEL=2}

                  display
                     part
                     " " @ pt_um
                     " " @ pt_desc1
                  with frame d.

               end. /* IF NOT AVAILABLE pt_mstr */

               else do:


                  display
                     pt_part @ part
                     pt_um
                     pt_desc1
                  with frame d.

               end. /* ELSE */

               assign
                  qopen             = t_qty_req - t_qty_iss
                  lotserial_control = if available pt_mstr
                                      then
                                         pt_lot_ser
                                      else ""
                  site              = ""
                  location          = ""
                  lotserial         = ""
                  lotref            = ""
                  lotserial_qty     = t_qty_chg /*if firstpass
                                      then
                                         t_qty_chg
                                      else
                                         t_qty_chg + lotserial_qty*/
				  global_part       = t_part .
				  cline             =    string(t_part,"x(18)") .  /*xp001*/   
				 
				  nbr_rmks          = t_rmks .

               if not can-find (first sr_wkfl
						where sr_wkfl.sr_domain = global_domain 
						and  sr_userid = mfguser
						and   sr_lineid begins cline)
               then
                  assign
                     site     = t_site
                     location = t_loc.

               else do:  /* if can-find  */

                  for first sr_wkfl
                     fields( sr_domain sr_lineid sr_loc      sr_lotser
                             sr_qty    sr_ref      sr_site
                             sr_userid sr_vend_lot)
                      where sr_wkfl.sr_domain = global_domain 
					  and  sr_userid = mfguser
                     and   sr_lineid begins cline
                     no-lock:
                  end. /* FOR FIRST sr_wkfl */

                  if available sr_wkfl
                  then
                     assign
                        site      = sr_site
                        location  = sr_loc
                        lotserial = sr_lotser
                        lotref    = sr_ref.
/****
                  else multi_entry = yes.
******/

               end. /* if can-find  */

       
               {&WOWOISC-P-TAG12}
               locloop:
               do on error undo, retry
                  on endkey undo select-part, retry:

                  /******wod_recno = recid(wod_det). ****/  /*moved,used by 发放替代料: wosumt.p*/

					
					/*********************************暂时未加多笔发料*/
					multi_entry = no .
					disp  lotserial_qty with frame d .
					/***xp001*/
                  update
                     lotserial_qty when (firstpass = yes )
					 sub_comp 
                     cancel_bo
                     site
                     location
                     lotserial
                     lotref
					 nbr_rmks
                     {&WOWOISC-P-TAG13}
                  with frame d
                  editing:

                     assign
                        global_site = input site
                        global_loc  = input location
                        global_lot  = input lotserial.

                     readkey.
                     apply lastkey.

                  end. /* UPDATE WITH FRAME d EDITING */
     
/*xp001 **********************************/
                  if sub_comp then do:
                     if can-find (first pts_det
                      where pts_det.pts_domain = global_domain and (  pts_part
                      = t_part
                     and   pts_par  = ""))
                     or
                        can-find (first pts_det
                      where pts_det.pts_domain = global_domain and  pts_part =
                      t_part
                     and   pts_par  = wo_part)
                     then do:



                        
						
						find first wod_det where wod_domain = global_domain 
											and wod_nbr = v_nbr 
											and wod_part = t_part
											and (wod_op = wo-op or wo-op = 0 )
						no-lock no-error.
						if avail wod_det then wod_recno = recid(wod_det). 
						else do:
							message "物料清单上无此零件." .
							undo,retry.
						end.

						if lotserial_qty = 0 then do:
							message "发放替代料,数量不可为零" .
							undo,retry .
						end.


                        /* REFRESH VALUE OF wod_qty_chg WITH lotserial_qty */
                        /* BEFORE PASSING VALUE TO wosumt.p                */
						/* wod_qty_chg = lotserial_qty.     */

							v_qty_a = lotserial_qty .

							for each wod_det where wod_domain = global_domain
											 and wod_nbr = v_nbr 
											 and wod_part = t_part
											 and  (wod_op    = wo-op   or    wo-op     = 0)
											 exclusive-lock  ,
								each rlswo where rls_lot = wod_lot no-lock			 
											 break by wod_nbr by wod_lot by wod_op :

								if wod_qty_req >= 0
								then
								   v_qty_open = max(0, wod_qty_req - max(wod_qty_iss,0)).
								else
								   v_qty_open = min(0, wod_qty_req - min(wod_qty_iss,0)).
								
								if (v_qty_a  < v_qty_open ) then do:
									v_qty_open = v_qty_a . /*不够发,=尾数或0*/
								end.

								if last-of(wod_nbr) and (qopen < lotserial_qty ) then do:
									v_qty_open = v_qty_a  .
								end.

								wod_qty_chg = v_qty_open .

								v_qty_a = max(0,v_qty_a  - v_qty_open ).
							end . /*for each wod_det */


                        {gprun.i ""xxwosumt1610.p"" "(input wo-op)"}  /*替代料发放*/ /*xp001*/
/*************************************************************************************************************************************/
                        if keyfunction(lastkey) = "end-error"
                        then
                           undo, retry.

                        firstpass = no.

                        next frame-d-loop.

                     end. /* IF CAN-FIND (FIRST pts_det */

                     else do with frame d:
                        /* APPROVED ALTERNATE ITEM DOES NOT EXIST */
                        {pxmsg.i &MSGNUM=545 &ERRORLEVEL=3}
                        next-prompt sub_comp.
                        undo, retry.
                     end. /* ELSE DO WITH FRAME d */						
                  end. /* IF sub_comp */


                  assign
                     total_lotserial_qty = t_qty_chg
                     trans_um            = if available pt_mstr
                                           then
                                              pt_um
                                           else ""
                     trans_conv          = 1.


                  if multi_entry then do:
						/*************************暂时未加多笔发料*/
                  end. /* IF multi_entry */
                  else do:  /* IF not multi_entry */
                     if lotserial_qty <> 0
                     then do:

                        {gprun.i ""icedit.p""
                           "(""ISS-WO"",
                               site,
                               location,
                               global_part,
                               lotserial,
                               lotref,
                               lotserial_qty,
                               trans_um,
                               """",
                               """",
                               output undo-input)" }

                        if undo-input
                        then
                           undo, retry.

                        if wo_site <> site
                        then do:

                           {gprun.i ""icedit4.p"" "(input ""ISS-WO"",
                                                    input wo_site,
                                                    input site,
                                                    input pt_loc,
                                                    input location,
                                                    input global_part,
                                                    input lotserial,
                                                    input lotref,
                                                    input lotserial_qty,
                                                    input trans_um,
                                                    input """",
                                                    input """",
                                                    output yn)"
                              }

                           if yn
                           then
                              undo locloop, retry.

                        end. /* IF wo_site <> site */

                     end. /* IF lotserial_qty <> 0 */	

					 /*	message "total:" total_lotserial_qty skip
								"input" lotserial_qty skip 
								view-as alert-box.*/
		

                     if lotserial_qty = 0
                     then do:
						for each sr_wkfl where sr_wkfl.sr_domain = global_domain 
										 and  sr_userid = mfguser
										 and   sr_lineid begins cline
                        exclusive-lock :

                           total_lotserial_qty = total_lotserial_qty -
                                                 sr_qty.
                           delete sr_wkfl.
                        end. /* for each sr_wkfl  */

                     end. /* IF lotserail_qty = 0 */
                     else do: /* IF lotserail_qty <> 0 */
						if lotserial_qty < 0 then do:
							message "小于零的数量,会全部发料到第一个工单ID" .
						end.

						if firstpass then do:

							v_qty_a = lotserial_qty .

							for each wod_det where wod_domain = global_domain
											 and wod_nbr = v_nbr 
											 and wod_part = t_part
											 and  (wod_op    = wo-op   or    wo-op     = 0)
											 exclusive-lock ,
								each rlswo where rls_lot = wod_lot no-lock
								break by wod_nbr by wod_lot by wod_op :

								assign wod__chr01 = nbr_rmks .

								if wod_qty_req >= 0
								then
								   v_qty_open = max(0, wod_qty_req - max(wod_qty_iss,0)).
								else
								   v_qty_open = min(0, wod_qty_req - min(wod_qty_iss,0)).

								/*if v_qty_open = 0 then next . ************************************/

								
								if (v_qty_a  < v_qty_open ) then do:
									v_qty_open = v_qty_a . /*不够发,=尾数或0*/
								end.

								if last-of(wod_nbr) and (qopen < lotserial_qty ) then do:
									message "多发料部分,发给最后一个工单ID:" wod_lot .  /*多发料*/
									v_qty_open = v_qty_a  .
								end.
										

								cline   =    string(wod_part,"x(18)")
										   + string(wod_lot,"x(8)")
										   + string(wod_op) . /*xp001*/
								find first sr_wkfl
									 where sr_wkfl.sr_domain = global_domain 
									 and  sr_userid = mfguser  
									 and   sr_lineid = cline
								exclusive-lock no-error.


								if available sr_wkfl
								then
								   assign
									  total_lotserial_qty = total_lotserial_qty -
															sr_qty              +
															v_qty_open
									  sr_site             = site
									  sr_loc              = location
									  sr_lotser           = lotserial
									  sr_ref              = lotref
									  sr_qty              = v_qty_open.

								else do:

								   create sr_wkfl. sr_wkfl.sr_domain = global_domain.

								   assign
									  sr_userid           = mfguser
									  sr_lineid           = cline
									  sr_site             = site
									  sr_loc              = location
									  sr_lotser           = lotserial
									  sr_ref              = lotref
									  sr_qty              = v_qty_open
									  total_lotserial_qty = total_lotserial_qty +
															v_qty_open .

								   if recid(sr_wkfl) = -1 then .

								end.  /* ELSE */

								v_qty_a = max(0,v_qty_a  - v_qty_open ).
							end . /*for each wod_det */

						end. /*if firstpass then */
						else do : /*if not firstpass then */
							total_lotserial_qty = 0 . /**/
							for each wod_det where wod_domain = global_domain
											 and wod_nbr = v_nbr 
											 and wod_part = t_part
											 and  (wod_op    = wo-op   or    wo-op     = 0)
											 exclusive-lock ,
								each rlswo where rls_lot = wod_lot no-lock
								break by wod_nbr by wod_lot by wod_op :

								assign wod__chr01 = nbr_rmks .


								v_qty_open = wod_qty_chg.
										

								cline   =    string(wod_part,"x(18)")
										   + string(wod_lot,"x(8)")
										   + string(wod_op) . /*xp001*/
								find first sr_wkfl
									 where sr_wkfl.sr_domain = global_domain 
									 and  sr_userid = mfguser  
									 and   sr_lineid = cline
								exclusive-lock no-error.


								if available sr_wkfl
								then
								   assign
									  total_lotserial_qty = total_lotserial_qty -
															sr_qty              +
															v_qty_open
									  sr_site             = site
									  sr_loc              = location
									  sr_lotser           = lotserial
									  sr_ref              = lotref
									  sr_qty              = v_qty_open.

								else do:

								   create sr_wkfl. sr_wkfl.sr_domain = global_domain.

								   assign
									  sr_userid           = mfguser
									  sr_lineid           = cline
									  sr_site             = site
									  sr_loc              = location
									  sr_lotser           = lotserial
									  sr_ref              = lotref
									  sr_qty              = v_qty_open
									  total_lotserial_qty = total_lotserial_qty +
															v_qty_open .

								   if recid(sr_wkfl) = -1 then .

								end.  /* ELSE */

							end . /*for each wod_det */
						end. /*if not firstpass then */


                        /* SECTION TO VALIDATE NO OVERISSUE */

                        assign
                           overissue_ok     = no
                           lineid_list      = ""
                           currid           = string(part,"x(18)")
                                              + string(v_lot,"x(8)") /*xp001*/
											  + string(op)
                           l_temp_from_part = string(part, "x(18)")
                           l_temp_to_part   = l_temp_from_part +
                                              hi_char.

                        for each sr_wkfl
                           fields( sr_domain sr_lineid sr_loc      sr_lotser
                                   sr_qty    sr_ref      sr_site
                                   sr_userid sr_vend_lot)
                            where sr_wkfl.sr_domain = global_domain and
                            sr_userid  = mfguser
                           and   sr_lineid >= l_temp_from_part
                           and   sr_lineid <= l_temp_to_part
                           no-lock:

                           if not can-do(lineid_list,sr_lineid)
                           then
                              lineid_list = lineid_list +
                                            sr_lineid   +
                                            ",".

                        end. /* FOR EACH sr_wkfl */

                        {gprun.i ""icoviss1.p""
                           "(input  part,
                             input  lineid_list,
                             input  currid,
                             output overissue_ok)"
                           }

                        if not overissue_ok
                        then
                           undo, retry.

                     end. /* IF lotserail_qty <> 0 */
                  end.  /* IF not multi_entry */
					 /*	message "total:" total_lotserial_qty skip
															view-as alert-box.*/

                  {&WOWOISC-P-TAG14}
                  assign
					 t_rmks    = nbr_rmks 
                     t_qty_chg = if firstpass then  total_lotserial_qty else t_qty_chg 
                     t_bo_chg  = if cancel_bo
                                   then
                                      0
                                   else
                                      t_qty_req -
                                      t_qty_iss -
                                      t_qty_chg.

                  if t_qty_req >= 0
                  then
                     t_bo_chg = max(t_bo_chg,0).

                  if t_qty_req < 0
                  then
                     t_bo_chg = min(t_bo_chg,0).





				for each wod_det where wod_domain = global_domain
								 and wod_nbr = v_nbr 
								 and wod_part = t_part
								 and  (wod_op    = wo-op   or    wo-op     = 0)
								 exclusive-lock ,
					each rlswo where rls_lot = wod_lot no-lock
					break by wod_lot by wod_op :	
					
					assign wod__chr01 = nbr_rmks .

						cline   =    string(wod_part,"x(18)")
								   + string(wod_lot,"x(8)")
								   + string(wod_op) . /*xp001*/


						find first sr_wkfl
							 where sr_wkfl.sr_domain = global_domain 
							 and  sr_userid = mfguser  
							 and   sr_lineid = cline
						exclusive-lock no-error.
						if available sr_wkfl then do:
							  assign
								 wod_qty_chg = sr_qty
								 wod_bo_chg  = if cancel_bo
											   then
												  0
											   else
												  wod_qty_req -
												  wod_qty_iss -
												  wod_qty_chg.

							  if wod_qty_req >= 0
							  then
								 wod_bo_chg = max(wod_bo_chg,0).

							  if wod_qty_req < 0
							  then
								 wod_bo_chg = min(wod_bo_chg,0).
							
						end.


						if  cancel_bo
							and not can-find (first sr_wkfl
								   where sr_wkfl.sr_domain = global_domain and  sr_userid =
								   mfguser and   sr_lineid = cline)
						then do:

								 create sr_wkfl. sr_wkfl.sr_domain = global_domain.

								 assign
									sr_userid = mfguser
									sr_lineid = cline
									sr_qty    = 0
									sr_site   = site.
									recno     = recid(sr_wkfl).

						end. /* IF cancel_bo */
				end . /*for each wod_det */

/********************************** xp001*/

               end. /* locloop */

               leave.

            end. /* frame-d-loop */

         end. /* DO ON ERROR, UNDO RETRY */

      end. /* select-part */
/**********************************************************************************************/
      {&WOWOISC-P-TAG15}
      do on endkey undo mainloop, leave mainloop:

         assign
            l_remove_srwkfl = yes
            yn              = yes.

         /*V8-*/
         /* DISPLAY ITEMS BEING ISSUED */
         {pxmsg.i &MSGNUM=636 &ERRORLEVEL=1 &CONFIRM=yn
                  &CONFIRM-TYPE='LOGICAL'}
         /*V8+*/

         /*V8!
         /* DISPLAY ITEMS BEING ISSUED */
         {mfgmsg10.i 636 1 yn}
         */

         if yn
         then do:

            hide frame c no-pause.

            hide frame d no-pause.

            for each wod_det
					   fields( wod_domain wod_bo_chg  wod_critical wod_iss_date
							   wod_loc     wod_lot      wod_nbr
							   wod_op      wod_part     wod_qty_all
							   wod_qty_chg wod_qty_iss  wod_qty_pick
							   wod_qty_req wod_site)
						where wod_det.wod_domain = global_domain 
						/*and  wod_lot = wo_lot  xp001*/
						and wod_nbr = wo_nbr    no-lock,
				each rlswo where rls_lot = wod_lot no-lock,
                each sr_wkfl
					  fields( sr_domain sr_lineid sr_loc      sr_lotser
							  sr_qty    sr_ref      sr_site
							  sr_userid sr_vend_lot)
					   where sr_wkfl.sr_domain = global_domain 
					   and   sr_userid = mfguser
					   and   sr_lineid = string(wod_part,"x(18)")
										+ string(wod_lot,"x(8)") /*xp001*/
										+ string(wod_op)
					   and sr_qty <> 0  /*xp001*/
					  no-lock
				with frame dd
				width 80:

               /* SET EXTERNAL LABELS */
               setFrameLabels(frame dd:handle).

               display
			      wod_lot 
                  wod_part
                  sr_site
                  sr_loc
                  sr_lotser
                  /*sr_ref format "x(8)" column-label {&wowoisc_p_5} */
                  sr_qty.
               {gpwait.i &INSIDELOOP=yes &FRAMENAME=dd}
            end. /* FOR EACH wod_det */
            {gpwait.i &OUTSIDELOOP=yes}

         end. /* IF yn */

         /*V8!
         else
         if yn = ?
         then
            undo mainloop, leave mainloop.
         */

      end. /* DO ON ENDKEY UNDO mainloop, LEAVE mainloop */

      do on endkey undo mainloop, leave mainloop:

         /* Identify context for QXtend */
         {gpcontxt.i
            &STACKFRAG = 'wowoisc,wowois'
            &FRAME = 'yn' &CONTEXT = 'INFO'}

         /*V8-*/
         yn = yes.

         /* IS ALL INFORMATION CORRECT */
         {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn
                  &CONFIRM-TYPE='LOGICAL'}
         /*V8+*/

         /*V8!
         yn = yes.

         /* IS ALL INFORMATION CORRECT */
         {mfgmsg10.i 12 1 yn}
         if yn = ?
         then
            undo mainloop, leave mainloop.
         */

         /* Clear context for QXtend */
         {gpcontxt.i
            &STACKFRAG = 'wowoisc,wowois'
            &FRAME = 'yn'}

         l_remove_srwkfl = no.

         if yn
         then do:

            {&WOWOISC-P-TAG2}

            /* CODE TO VALIDATE OVERISSUE WHEN DEFAULT ISSUE       */
            /* QTY IS ACCEPTED DIRECTLY WITHOUT ANY MODIFICATION   */
            assign
               currid         = "-99"
               l_overissue_yn = no.

            for each wod_det
				   fields( wod_domain wod_bo_chg  wod_critical wod_iss_date wod_loc
						   wod_lot     wod_nbr      wod_op       wod_part
						   wod_qty_all wod_qty_chg  wod_qty_iss  wod_qty_pick
						   wod_qty_req wod_site)
					where wod_det.wod_domain = global_domain 
					 /*and  wod_lot = wo_lotxp001*/
					 and wod_nbr = wo_nbr  no-lock ,
				each rlswo where rls_lot = wod_lot no-lock
                break by wod_part:

               if first-of(wod_part)
               then do:

                  assign
                     overissue_ok     = no
                     lineid_list      = ""
                     l_temp_from_part = string(wod_part, "x(18)")
                     l_temp_to_part   = l_temp_from_part +
                                        hi_char.

                  for each sr_wkfl
                     fields( sr_domain sr_lineid sr_loc    sr_lotser
                             sr_qty    sr_ref    sr_site
                             sr_userid sr_vend_lot)
                      where sr_wkfl.sr_domain = global_domain and  sr_userid  =
                      mfguser
                     and   sr_lineid >= l_temp_from_part
                     and   sr_lineid <= l_temp_to_part
                     no-lock:

                     if not can-do(lineid_list,sr_lineid)
                     then
                        lineid_list = lineid_list +
                                      sr_lineid   +
                                      ",".

                  end. /* FOR EACH sr_wkfl ... */

                  {gprun.i ""icoviss1.p"" "(input wod_part,
                                            input lineid_list,
                                            input currid,
                                            output overissue_ok)"
                  }

                  if not overissue_ok
                  then
                     l_overissue_yn = yes.

               end. /* IF FIRST-OF (wod_det) */

            end. /* FOR EACH wod_det ... */

            if l_overissue_yn
            then
               next setd.

            /* ADDED A CALL TO icedit4.p AS ALL THE VALIDATIONS OF */
            /* DEFAULTS AND EXITED (F4) NOT PROCESSING THE         */
            /* INDIVIDUAL LINES.                                   */

            l_error = no.

            for each wod_det
					   fields( wod_domain wod_bo_chg   wod_iss_date   wod_loc
							  wod_lot      wod_nbr        wod_op
							  wod_part     wod_qty_chg    wod_qty_iss
							  wod_critical wod_qty_all    wod_qty_pick
							  wod_qty_req  wod_site)
						where wod_det.wod_domain = global_domain 
						/*and  wod_lot = wo_lotxp001*/
					    and wod_nbr = wo_nbr no-lock,	
			   each rlswo where rls_lot = wod_lot no-lock ,
			   each sr_wkfl
					  fields( sr_domain sr_userid sr_lineid sr_site
							 sr_loc    sr_lotser sr_ref
							 sr_qty    sr_vend_lot)
					   where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
					   and   sr_lineid = string(wod_part,"x(18)")
									   + string(wod_lot,"x(8)") /*xp001*/
										+ string(wod_op)
					   and   sr_qty    <> 0.00
			   no-lock:

               for first pt_mstr
                  fields( pt_domain pt_critical pt_desc1 pt_loc
                         pt_lot_ser  pt_part  pt_um)
                   where pt_mstr.pt_domain = global_domain and  pt_part =
                   wod_part
                  no-lock:
               end. /* FOR FIRST pt_mstr ... */

               if (wo_site <> sr_site)
               then do:

                  {gprun.i ""icedit4.p""
                     "(input ""ISS-WO"",
                       input wo_site,
                       input sr_site,
                       input pt_loc,
                       input sr_loc,
                       input trim(substring(sr_lineid,1,18)),
                       input sr_lotser,
                       input sr_ref,
                       input sr_qty,
                       input pt_um,
                       input """",
                       input """",
                       output yn)"}

                  if yn
                  then do:

                     l_error = yes.

                     /* FOR ITEM: # SITE: # LOCATION: # */
                      {pxmsg.i &MSGNUM=4578 &ERRORLEVEL=1
                                &MSGARG1=trim(substring(sr_lineid,1,18))
                                &MSGARG2=sr_site
                                &MSGARG3=sr_loc
                                &MSGARG4=sr_lotser}

                  end. /* IF yn */

               end. /* IF wo_site <> sr_site */

            end. /* FOR EACH wod_det */

            if l_error
            then
               undo mainloop, retry mainloop.

/*xp001***:gplock.i仅lock一笔资料
            {gplock.i &domain="wo_mstr.wo_domain = global_domain and "
               &file-name     = wo_mstr
               &find-criteria = "recid(wo_mstr) = wo_recno"
               &exit-allowed  = yes
               &record-id     = recno}
***xp001*/
			{gplock1.i  &domain="wo_mstr.wo_domain = global_domain and "
						&file-name      = wo_mstr
						&group-criteria = "wo_mstr.wo_nbr = v_nbr  and (lookup(wo_status,'A,R') <> 0 ) "
						&find-criteria  = "recid(wo_mstr) = wo_recno"
						&undo-block     = mainloop
						&retry          = "retry mainloop"
						&record-id      = recno}  /*xp001*/

            /*V8-*/
            if keyfunction(lastkey) = "end-error"
            then do:

               for first wo_mstr
                  fields( wo_domain wo_lot      wo_nbr  wo_part
                          wo_rel_date wo_site wo_type)
                  where recid(wo_mstr) = wo_recno
                  no-lock:
               end. /* FOR FIRST wo_mstr */

               next setd.

            end. /* IF KEYFUNCTION(LASTKEY) = "END-ERROR" */

            /*V8+*/

            if not available wo_mstr
            then do:
               /*  WORK ORDER/ID DOES NOT EXIST.*/
               {pxmsg.i &MSGNUM=510 &ERRORLEVEL=4}
               leave mainloop.
            end. /* IF NOT AVAILABLE wo_mstr */


            /* ADDED SECTION TO DO FINAL ISSUE CHECK */

            {icintr2.i "sr_userid = mfguser"
               transtype
               right-trim(substring(sr_lineid,1,18))
               trans_um
               undo-input
               """use pt_mstr"""
               }

            if undo-input
            then do:
               /* UNABLE TO ISSUE OR RECEIVE FOR ITEM */
               {pxmsg.i &MSGNUM=161 &ERRORLEVEL=3
                        &MSGARG1=substring(sr_lineid,1,18)}
               next setd.
            end. /* IF undo-input */

            hide frame c.

            hide frame d.

            leave setd.

         end. /* IF yn */

         /*V8!
         else
         if not yn
         then do:

            for first wo_mstr
               fields (wo_lot      wo_nbr  wo_part
                       wo_rel_date wo_site wo_type)
               where recid(wo_mstr) = wo_recno
               no-lock:
            end. /* FOR FIRST wo_mstr */

            next setd.

         end. /* IF NOT yn */

         else
            leave mainloop.
         */

      end. /* DO ON ENDKEY UNDO mainloop, LEAVE mainloop */

   end. /* setd */

   undo-all = no.

end. /* mainloop */

/* Clear context for QXtend */
{gpcontxt.i
   &STACKFRAG = 'wowoisc,wowois'
   &FRAME = 'yn'}

hide frame dd no-pause.

for each sr_wkfl
    where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
   exclusive-lock:

   sr_vend_lot = 'wowoisc.p'.

   if l_remove_srwkfl
   then
      delete sr_wkfl.

end. /* FOR EACH sr_wkfl */
