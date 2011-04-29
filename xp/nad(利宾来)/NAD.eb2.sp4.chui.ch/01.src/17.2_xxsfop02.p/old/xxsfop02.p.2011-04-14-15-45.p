/* sfoptr02.p - LABOR FEEDBACK BY EMPLOYEE TRANSACTION                        */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.17.1.1 $                                                               */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 4.0     LAST MODIFIED: 02/03/88    BY: rl  *A171*                */
/* REVISION: 4.0     LAST MODIFIED: 05/04/88    BY: flm *A222*                */
/* REVISION: 4.0     LAST MODIFIED: 08/18/88    BY: flm *A398*                */
/* REVISION: 4.0     LAST MODIFIED: 09/09/88    BY: flm *A431*                */
/* REVISION: 4.0     LAST MODIFIED: 09/20/88    BY: flm *A443*                */
/* REVISION: 4.0     LAST MODIFIED: 09/21/88    BY: flm *A449*                */
/* REVISION: 4.0     LAST MODIFIED: 12/27/88    BY: flm *A571*                */
/* REVISION: 5.0     LAST MODIFIED: 12/30/88    BY: jlc *B004*                */
/* REVISION: 5.0     LAST MODIFIED: 02/08/89    BY: flm *B029*                */
/* REVISION: 4.0     LAST MODIFIED: 03/29/89    BY: rl  *A688*                */
/* REVISION: 5.0     LAST MODIFIED: 09/26/89    BY: mlb *B316*                */
/* REVISION: 5.0     LAST MODIFIED: 02/07/90    BY: pml *B555*                */
/* REVISION: 5.0     LAST MODIFIED: 02/23/90    BY: mlb *B586*                */
/* REVISION: 5.0     LAST MODIFIED: 04/25/90    BY: emb *B672*                */
/* REVISION: 5.0     LAST MODIFIED: 05/21/90    BY: emb *B690*                */
/* REVISION: 5.0     LAST MODIFIED: 07/05/90    BY: emb *B728*                */
/* REVISION: 6.0     LAST MODIFIED: 01/24/91    BY: emb *D315*                */
/* REVISION: 6.0     LAST MODIFIED: 03/22/91    BY: emb *D448*                */
/* REVISION: 6.0     LAST MODIFIED: 04/30/91    BY: emb *D600*                */
/* REVISION: 6.0     LAST MODIFIED: 06/14/91    BY: emb *D704*                */
/* REVISION: 6.0     LAST MODIFIED: 07/24/91    BY: bjb *D782*                */
/* REVISION: 6.0     LAST MODIFIED: 08/02/91    BY: pma *D806*(rev only)      */
/* REVISION: 7.0     LAST MODIFIED: 12/10/91    BY: dgh *D960*                */
/* REVISION: 7.0     LAST MODIFIED: 04/29/92    BY: emb *F445*                */
/* REVISION: 7.3     LAST MODIFIED: 12/07/92    BY: emb *G400*(rev only)      */
/* REVISION: 7.3     LAST MODIFIED: 03/15/93    BY: emb *G876*                */
/* REVISION: 7.3     LAST MODIFIED: 03/31/93    BY: ram *G886*                */
/* REVISION: 7.3     LAST MODIFIED: 05/18/93    BY: pma *GB08*(rev only)      */
/* REVISION: 7.3     LAST MODIFIED: 08/05/93    BY: emb *GD95*(rev only)      */
/* REVISION: 7.3     LAST MODIFIED: 10/31/94    BY: WUG *GN76*                */
/* REVISION: 8.5     LAST MODIFIED: 12/09/94    BY: mwd *J034*                */
/* REVISION: 7.2     LAST MODIFIED: 07/17/95    BY: qzl *F0T9*                */
/* REVISION: 8.5     LAST MODIFIED: 04/09/96    BY: jym *G1Q9*                */
/* REVISION: 7.3     LAST MODIFIED: 06/13/96    BY: rvw *G1Y4*                */
/* REVISION: 8.6     LAST MODIFIED: 06/11/96    BY: aal *K001*                */
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6     LAST MODIFIED: 02/09/99    BY: *J393* Thomas Fernandes   */
/* REVISION: 9.1     LAST MODIFIED: 08/31/99    BY: *N014* Jeff Wootton       */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 06/20/00    BY: *L0ZV* Vandna Rohira      */
/* REVISION: 9.1     LAST MODIFIED: 08/12/00    BY: *N0KN* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.12      BY: Jean Miller          DATE: 05/10/02  ECO: *P05V*   */
/* Revision: 1.13      BY: Inna Fox             DATE: 06/13/02  ECO: *P04Z*   */
/* Revision: 1.14      BY: Vivek Gogte          DATE: 08/06/02  ECO: *N1QQ*   */
/* Revision: 1.16      BY: Anitha Gopal         DATE: 08/22/02  ECO: *N1RP*   */
/* Revision: 1.17      BY: Narathip W.          DATE: 04/29/03  ECO: *P0QN*   */
/* $Revision: 1.17.1.1 $     BY: A.R. Jayaram         DATE: 08/25/03  ECO: *P10N*   */
/* $Revision: 1.2.01   $     BY: Martin tan     DATE: 14/06/08  ECO: *KM06**/
/* $Revision: 1.3.00   $     BY: Martin tan     DATE: 03/12/08  ECO: *SET2**/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110120.1  By: Roger Xiao */ /*based on Martin's yysfoptr02.p 2+ */
/* SS - 110406.1  By: Roger Xiao */ /*bug fixed in xxsfoptra.p */
/*-Revision end---------------------------------------------------------------*/

{mfdtitle.i "110406.1"}


/* DISPLAY TITLE */
/*{mfdtitle.i "2+ "}*/
{cxcustom.i "SFOPTR02.P"}

/* DEFINE SHARED VARIABLES FOR DAYBOOKS */
{gldydef.i new}

/* DEFINE NRM VARIABLES */
{gldynrm.i new}

define new global shared variable global_rsntyp like rsn_type.

/* LABOR FEEDBACK VARIABLE DECLARATIONS */
{sfopvar.i "new shared"}

define new        shared variable gldetail like mfc_logical no-undo initial no.
define new        shared variable gltrans  like mfc_logical no-undo initial no.
{&SFOPTR02-P-TAG1}

/*SFOP*/  define new shared variable bisu            as integer format ">>9".
/*SET2*  /*SFOP*/  define new shared variable amch            as integer format ">>9".*/
/*SET2*/  define new shared variable amch            as decimal format "->>9.9".
/*SFOP*/  define new shared variable cmmts           as logical initial no.
/*SET2*/  define new shared variable sttype           as char format "x(6)".

define                   variable wonbr      like wr_nbr      no-undo.
define                   variable yn         like mfc_logical no-undo.
define                   variable valid_proj like mfc_logical no-undo.
define                   variable l_move     like mfc_logical no-undo.
/*KM06*/ define variable ptdesc   like pt_desc1      no-undo.

{&SFOPTR02-P-TAG2}
form
   emp            colon 11
   emp_lname      no-label format "x(18)"
   shift          colon 62
   dept           colon 11
/*KM06*   earn           colon 62 skip(1)  **/
/*KM06*/   earn           colon 62
   wr_nbr         colon 11
   op_wkctr       colon 43
   project        colon 62
   wr_lot         colon 11
   op_mch         colon 43
   time_ind       colon 62   
/*KM06*/   ptdesc format "x(48)" no-label colon 11
   wr_op          colon 11
   wr_desc        no-label
   wrstatus       colon 62
with frame a side-labels width 80 attr-space.
{&SFOPTR02-P-TAG3}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


/* SS - 110120.1 - B */
define var v_multi_type as logical label "多类型" initial no.
define var v_multi_rsn  as logical label "多原因" initial no.
/* SS - 110120.1 - E */

/* FRAME B DEFINITION */
/*KM06* {sfopfmb.i} **/
/*KM06*/ {xxsfopfmb.i}

/* DISPLAY */
view frame a.
view frame b.

for first ea_mstr
   fields(ea_earn ea_type)
   where ea_type = "1"
   no-lock:
end. /* FOR FIRST ea_mstr */

if available ea_mstr
then
   earn = ea_earn.
else
   earn = "".

for first opc_ctrl
   fields (opc_move opc_time_ind)
no-lock:

   if opc_time_ind = "D"
   then
      time_ind = yes.
   else
      time_ind = no.
   assign
      l_move = opc_move
      move = opc_move.

end. /* FOR FIRST opc_ctr */

release opc_ctrl.

display
   earn
   time_ind
with frame a.

global_rsntyp = "down".

mainloop:
repeat:

   do transaction with frame a:

      /* VARIABLE MOVE IS INITIALIZED FOR ALL WORK ORDERS AND */
      /* OPERATIONS FROM SHOP FLOOR CONTROL FILE              */
      assign
         move     = l_move
         ststatus = stline[1].

      status input ststatus.
      wrnbr = "".

      prompt-for
         emp
         dept
         shift
         earn
         {&SFOPTR02-P-TAG4}
         wr_nbr
         wr_lot
         wr_op
         op_wkctr
         op_mch
         project
         time_ind
      editing:

         if frame-field = "emp"
         then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i emp_mstr emp emp_addr emp emp_addr emp_addr}

            if recno <> ?
            then do:
               display
                  emp_addr @ emp
                  emp_lname
                  emp_dept @ dept.
            end. /* IF recno <> ? */

         end. /* IF frame-field = "emp" */

         else
         if frame-field = "wr_nbr"
         then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i wr_route wr_nbr wr_nbr wr_nbr wr_nbr wr_nbr}

            if recno <> ?
            then do:

               /* WORK ORDER ROUTING STATUS INCLUDE FILE */
               {mfwrstat.i wrstatus}

               display
                  wr_nbr
                  wr_lot
                  wr_op
                  wr_desc
                  wrstatus
                  wr_wkctr @ op_wkctr
                  wr_mch @ op_mch.

/*KM06***********************************/
    		find pt_mstr where pt_part = wr_part  no-lock no-error no-wait.
    		if available pt_mstr then
    				display
       			trim(pt_part) + " " + trim(pt_desc1) @ ptdesc.
    		else
    			display
       			" " @ ptdesc.
/*KM06***********************************/

               for first wo_mstr
                  fields(wo_lot wo_nbr wo_project wo_site wo_status wo_type)
                  where wo_nbr = wr_nbr
                  and   wo_lot = wr_lot
                  no-lock:
               end. /* FOR FIRST wo_mstr */

               if available wo_mstr
               then
                  display
                     wo_project @ project.

               for first wc_mstr
                  fields(wc_dept wc_mch wc_wkctr)
                  where wc_wkctr = wr_wkctr
                  no-lock:
               end. /* FOR FIRST wc_mstr */

               if available wc_mstr
                  and wc_dept <> ""
                  and input dept = ""
               then
                  display
                     wc_dept @ dept.
            end. /* IF recno <> ? */

            recno = ?.
            wonbr = input wr_nbr. 

         end. /* IF frame-field = "wr_nbr" */

         else if frame-field = "wr_lot"
         then do:

            if wonbr = ""
            then do:
               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp.i wr_route wr_lot wr_lot wr_lot wr_lot wr_lot}
            end. /* IF wonbr = "" */

            else do:
               /* FIND NEXT/PREVIOUS RECORD FOR THE WORK ORDER NUMBER */
               {mfnp01.i wr_route wr_lot wr_lot
                  "input wr_nbr" wr_nbr wr_nbrop}
            end. /* ELSE DO */

            if recno <> ?
            then do:
               display
                  wr_nbr
                  wr_lot
                  wr_op
                  wr_desc
                  wrstatus
                  wr_wkctr @ op_wkctr
                  wr_mch @ op_mch.

/*KM06***********************************/
    		find pt_mstr where pt_part = wr_part  no-lock no-error no-wait.
    		if available pt_mstr then
    				display
       			trim(pt_part) + " " + trim(pt_desc1) @ ptdesc.
    		else
    			display
       			" " @ ptdesc.
/*KM06***********************************/

               for first wo_mstr
                  fields(wo_lot wo_nbr wo_project wo_site wo_status wo_type)
                  where wo_nbr = wr_nbr
                  and   wo_lot = wr_lot
                  no-lock:
               end. /* FOR FIRST wo_mstr */

               if available wo_mstr
               then
                  display
                     wo_project @ project.                   

               for first wc_mstr
                  fields(wc_dept wc_mch wc_wkctr)
                  where wc_wkctr = wr_wkctr
                  no-lock:
               end. /* FOR FIRST wc_mstr */

               if available wc_mstr
                  and wc_dept    <> ""
                  and input dept = ""
               then
                  display
                     wc_dept @ dept.

            end. /* IF recno <> ? */

            recno = ?.        

/*KM06***********************************/
/*message input wr_lot view-as alert-box.*/

	     for first wr_route
	        fields(wr_lot wr_nbr wr_part)
	       where wr_lot = input wr_lot
	        no-lock:
	     end. /* FOR FIRST wo_mstr */

		if avail wr_route then do:               
	  		find pt_mstr where pt_part = wr_part no-lock no-error no-wait.
	  		if available pt_mstr then
	  				display
       			trim(pt_part) + " " + trim(pt_desc1) @ ptdesc.
	  		else
	  			display
	     			" " @ ptdesc.
		  end.
/*KM06***********************************/

         end. /* ELSE IF frame-field = "wr_lot" */

         else if frame-field = "wr_op"
         then do:
         
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp01.i wr_route wr_op wr_op
               "input wr_lot" wr_lot wr_lot}

            if recno <> ?
            then do:

               /* WORK ORDER ROUTING STATUS INCLUDE FILE */
               {mfwrstat.i wrstatus}

               display
                  wr_nbr
                  wr_lot
                  wr_op
                  wr_desc
                  wrstatus
                  wr_wkctr @ op_wkctr
                  wr_mch @ op_mch.

               for first wo_mstr
                  fields(wo_lot wo_nbr wo_project wo_site wo_status wo_type)
                  where wo_nbr = wr_nbr
                  and   wo_lot = wr_lot
                  no-lock:
               end. /* FOR FIRST wo_mstr */

               if available wo_mstr
               then
                  display
                     wo_project @ project.

               for first wc_mstr
                  fields(wc_dept wc_mch wc_wkctr)
                  where wc_wkctr = wr_wkctr
                  no-lock:
               end. /* FOR FIRST wc_mstr */

               if available wc_mstr
                  and wc_dept    <> ""
                  and input dept =  ""
               then
                  display wc_dept @ dept.

            end. /* IF recno <> ? */

/*KM06************************************************/
	find wr_route no-lock where wr_lot = input wr_lot and wr_op = input wr_op no-error.
	if avail wr_route then
               display
                  wr_wkctr @ op_wkctr.                                       
/*KM06************************************************/

         end. /* ELSE IF frame-field = "wr_op" */

         else if frame-field = "op_wkctr"
         then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i wc_mstr op_wkctr wc_wkctr op_mch wc_mch wc_wkctr}

            if recno <> ?
            then do:
               display
                  wc_wkctr @ op_wkctr
                  wc_mch @ op_mch.

               if input dept = ""
               then
                  display
                     wc_dept @ dept.

            end. /* IF recno <> ? */

         end. /* ELSE IF frame-field = "op_wkctr" */

         else if frame-field = "op_mch"
         then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp01.i wc_mstr op_mch wc_mch
               "input op_wkctr" wc_wkctr wc_wkctr}

            if recno <> ?
            then do:

               display
                  wc_wkctr @ op_wkctr
                  wc_mch @ op_mch.
               if input dept = ""
               then
                  display
                     wc_dept @ dept.

            end. /* IF recno <> ? */

         end. /* ELSE IF frame-field = "op_mch" */

         else do:
            status input.
            readkey.
            apply lastkey.
         end. /*  ELSE DO */

      end. /* EDITING */

      if input emp <> ""
      then do:

         for first emp_mstr
            fields(emp_addr emp_dept emp_lname emp_status)
            where emp_addr = input emp
            no-lock:
         end. /* FOR FIRST emp_mstr */

         if not available emp_mstr
         then do:
            /* EMPLOYEE NUMBER DOES NOT EXIST */
            {pxmsg.i &MSGNUM=520 &ERRORLEVEL=3}
            undo,retry.
         end. /* IF NOT AVAILABLE emp_mstr */

         if lookup(emp_status,"AC,PT") = 0
         then do:
            next-prompt emp.
            /* EMPLOYEE NOT ON ACTIVE STATUS */
            {pxmsg.i &MSGNUM=4027 &ERRORLEVEL=3}
            undo,retry.
         end. /* IF LOOKUP(emp_status,"AC,PT") = 0 */

      end. /* IF INPUT emp <> "" */

      else if not batchrun
      then do:
         /* EMPLOYEE CODE IS BLANK */
         {pxmsg.i &MSGNUM=5593 &ERRORLEVEL=2}
      end. /*  ELSE IF NOT BATCHRUN */

      assign
         dept.
      {&SFOPTR02-P-TAG5}

      if available emp_mstr
         and input dept = ""
      then do:
         dept = emp_dept.
         display dept.
      end. /* IF AVAILABLE emp_mstr */

      for first dpt_mstr
         fields(dpt_dept)
         where dpt_dept = dept
         no-lock:
      end. /* FOR FIRST dpt_mstr */

      if not available dpt_mstr
      then do:
         next-prompt dept.
         /* DEPARTMENT DOES NOT EXIST */
         {pxmsg.i &MSGNUM=532 &ERRORLEVEL=3}
         undo, retry.
      end. /* IF NOT AVAILABLE dpt_mstr */
      
/*KM06***ADD-BEGIN*************************************/
      if input shift = ""
      then do:
          /* INVALID EARNINGS CODE */
          {pxmsg.i &MSGNUM=4013 &ERRORLEVEL=3}
          next-prompt shift.
          undo,retry.
      end.
/*KM06***ADD-END***************************************/

      if input earn <> ""
      then do:

         for first ea_mstr
            fields(ea_earn ea_type)
            where ea_earn = input earn
            no-lock:
         end. /* FOR FIRST ea_mstr */

         if not available ea_mstr
         then do:
            /* INVALID EARNINGS CODE */
            {pxmsg.i &MSGNUM=4025 &ERRORLEVEL=3}
            next-prompt earn.
            undo, retry.
         end. /* IF NOT AVAILABLE ea_mstr */

      end. /* IF INPUT earn <> "" */

      assign
         emp
         earn
         shift
         dept
         project.

      if available emp_mstr
      then
         display
            emp_lname.

      clear frame b.

      for first wr_route
         fields(wr_desc wr_lot wr_mch wr_nbr wr_op wr_status wr_wkctr)
         using wr_nbr and wr_lot and wr_op
         no-lock:
      end. /* FOR FIRST wr_route */

      if not available wr_route
      then do:

         if input wr_nbr     > ""
            and input wr_lot > ""
         then

            for first wr_route
               fields(wr_desc wr_lot wr_mch wr_nbr wr_op wr_status wr_wkctr)
               using wr_nbr and wr_lot
               no-lock:
            end. /* FOR FIRST wr_route */

         if input wr_nbr > ""
            and input wr_lot = ""
         then
            for first wr_route
               fields(wr_desc wr_lot wr_mch wr_nbr wr_op wr_status wr_wkctr)
               using wr_nbr
               no-lock:
            end. /* FOR FIRST wr_route */

         if input wr_nbr     = ""
            and input wr_lot > ""
         then
            for first wr_route
               fields(wr_desc wr_lot wr_mch wr_nbr wr_op wr_status wr_wkctr)
               using wr_lot
               no-lock:
            end. /* FOR FIRST wr_route */

      end. /* IF NOT AVAILABLE wr_route */

      if not available wr_route
      then do:
         /* WORK ORDER OPERATION DOES NOT EXIST */
         {pxmsg.i &MSGNUM=511 &ERRORLEVEL=3}
         next-prompt wr_op.
         undo, retry.
      end. /* IF NOT AVAILABLE wr_route */

      for first wo_mstr
         fields(wo_lot wo_nbr wo_project wo_site wo_status wo_type)
         where wo_nbr = wr_nbr
         and   wo_lot = wr_lot
         no-lock:

         if lookup(wo_status,"R,C") = 0
         then do:
            /* RELEASED & CLOSED ORDERS ONLY */
            {pxmsg.i &MSGNUM=525 &ERRORLEVEL=3 &MSGARG1=wo_status}
            next-prompt wr_nbr.
            undo mainloop, retry.
         end. /* IF LOOKUP(wo_status,"R,C") = 0 */

         if wo_type    = "c"
            and wo_nbr = ""
         then do:
            /* WORK ORDER TYPE IS CUMULATIVE */
            {pxmsg.i &MSGNUM=5123 &ERRORLEVEL=3}
            undo mainloop, retry.
         end. /* IF wo_type = "c" */

         if wo_type = "w"
         then do:
            /* WORD ORDER TYPE IS FLOW */
            {pxmsg.i &MSGNUM=5285 &ERRORLEVEL=3}
            undo mainloop, retry.
         end. /* IF wo_type = "w" */

         /* PROCEDURE TO VALIDATE SITES FOR DATA ENTRY */
         {gprun.i ""gpsiver.p""
            "(input wo_site,
              input ?,
              output return_int)"}

         if return_int = 0
         then do:
            /* USER DOES NOT HAVE ACCESS TO SITE #### */
            {pxmsg.i &MSGNUM=2710 &ERRORLEVEL=3 &MSGARG1=wo_site}
            next-prompt wr_nbr with frame a.
            undo mainloop, retry.
         end. /* IF return_int = 0 */

      end. /* FOR FIRST wo_mstr */

      assign
         wrnbr = wr_nbr
         wrlot = wr_lot.

      display
         wr_nbr
         wr_lot.

      /* ADD/MOD/DELETE  */
      for first wr_route
         fields(wr_desc wr_lot wr_mch wr_nbr wr_op wr_status wr_wkctr)
         using wr_lot and wr_op
         no-lock:
      end. /* FOR FIRST wr_route */

      if not available wr_route
      then do:

         /* WORK ORDER OPERATION DOES NOT EXIST */
         {pxmsg.i &MSGNUM=511 &ERRORLEVEL=3}
         next-prompt wr_op.
         undo, retry.

      end. /* IF NOT AVAILABLE wr_route */

      if wr_status = "C"
      then do:
         /* OPERATION CLOSED */
         {pxmsg.i &MSGNUM=524 &ERRORLEVEL=3}
         next-prompt wr_op.
         undo, retry.
      end. /* IF wr_status = "C" */

      /* WORK ORDER ROUTING STATUS INCLUDE FILE */
      {mfwrstat.i wrstatus}

      display
         wr_nbr
         wr_lot
         wr_op
         wr_desc
         wrstatus.

      for first wc_mstr
         fields(wc_dept wc_mch wc_wkctr)
         where wc_wkctr = input op_wkctr
         and   wc_mch   = input op_mch
         no-lock:
      end. /* FOR FIRST wc_mstr */

      if not available wc_mstr
      then do:
         next-prompt op_wkctr.
         /* WORK CENTER/MACHINE DOES NOT EXIST */
         {pxmsg.i &MSGNUM=528 &ERRORLEVEL=3}
         undo, retry.
      end. /* IF NOT AVAILABLE wc_mstr */

      display
         wc_wkctr @ op_wkctr
         wc_mch @ op_mch.

      assign
         time_ind.

      if project = ""
      then do:
         for first wo_mstr
            fields(wo_lot wo_nbr wo_project wo_site wo_status wo_type)
            where wo_nbr = wr_nbr
            and   wo_lot = wr_lot
            no-lock:
         end. /* FOR FIRST wo_mstr */

         if available wo_mstr
         then
            project = wo_project.

         display
            project.

      end. /* IF project = "" */

      /* VALIDATE PROJECT */
      if project <> ""
         and can-find(first gl_ctrl
                where gl_verify)
      then do:
         /* VALIDATE GL ACCOUNTS WITH RESTRICTIONS */
         {gprunp.i "gpglvpl" "p" "initialize"}
         {gprunp.i "gpglvpl" "p" "validate_project"
            "(input project,
              output valid_proj)"}

         if not valid_proj
         then do:
            next-prompt project.
            undo, retry.
         end. /* IF NOT valid_proj */
      end. /* IF project <> "" */

      if not batchrun
      then do:

         if wc_dept <> dept
         then do:
            /* DEPARTMENT IS DIFFERENT THAN WORK CENTER DEPT */
            {pxmsg.i &MSGNUM=540 &ERRORLEVEL=2 &MSGARG1=wc_dept}
            yn = no.
            /* CONTINUE? */
            {pxmsg.i &MSGNUM=32 &ERRORLEVEL=1 &CONFIRM=yn
               &CONFIRM-TYPE='LOGICAL'}
            if yn = no
            then
               undo, retry.
         end. /* IF wc_dept <> dept */

      end. /* IF NOT BATCHRUN THEN */

      assign
         recno    = recid(emp_mstr)
         wr_recno = recid(wr_route)
         wc_recno = recid(wc_mstr).

      status input.

   end. /* DO TRANSACTION WITH FRAME a */

   /* LABOR FEEDBACK CONTINUATION PROGRAM */
/*KM06**   {gprun.i ""sfoptra.p""}   **/
/*KM06*/   {gprun.i ""xxsfoptra.p""}

end. /* REPEAT */

status input.
