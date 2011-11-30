/* sfoptr01.p - LABOR FEEDBACK BY WORK ORDER TRANSACTION                      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.23 $                                                               */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 4.0     LAST MODIFIED: 02/03/88    BY: rl  *A171*                */
/* REVISION: 4.0     LAST MODIFIED: 05/04/88    BY: flm *A222*                */
/* REVISION: 4.0     LAST MODIFIED: 08/18/88    BY: flm *A398*                */
/* REVISION: 4.0     LAST MODIFIED: 09/09/88    BY: flm *A431*                */
/* REVISION: 4.0     LAST MODIFIED: 09/20/88    BY: flm *A443*                */
/* REVISION: 4.0     LAST MODIFIED: 09/21/88    BY: flm *A449*                */
/* REVISION: 4.0     LAST MODIFIED: 12/27/88    BY: flm *A571*                */
/* REVISION: 5.0     LAST MODIFIED: 02/08/89    BY: flm *B029*                */
/* REVISION: 4.0     LAST MODIFIED: 03/29/89    BY: rl  *A688*                */
/* REVISION: 5.0     LAST MODIFIED: 09/26/89    BY: mlb *B316*                */
/* REVISION: 5.0     LAST MODIFIED: 12/11/89    BY: wug *B437*                */
/* REVISION: 5.0     LAST MODIFIED: 02/07/90    BY: pml *B555*                */
/* REVISION: 5.0     LAST MODIFIED: 04/25/90    BY: emb *B672*                */
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
/* REVISION: 7.3     LAST MODIFIED: 06/02/94    BY: pxd *FO53*                */
/* REVISION: 7.3     LAST MODIFIED: 10/31/94    BY: WUG *GN76*                */
/* REVISION: 8.5     LAST MODIFIED: 12/09/94    BY: mwd *J034*                */
/* REVISION: 7.2     LAST MODIFIED: 07/17/95    BY: qzl *F0T9*                */
/* REVISION: 8.5     LAST MODIFIED: 04/09/96    BY: jym *G1Q9*                */
/* REVISION: 8.6     LAST MODIFIED: 06/11/96    BY: aal *K001*                */
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6     LAST MODIFIED: 02/09/99    BY: *J393* Thomas Fernandes   */
/* REVISION: 9.1     LAST MODIFIED: 08/31/99    BY: *N014* Jeff Wootton       */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 06/20/00    BY: *L0ZV* Vandna Rohira      */
/* REVISION: 9.1     LAST MODIFIED: 08/12/00    BY: *N0KN* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.15      BY: Jean Miller          DATE: 05/10/02  ECO: *P05V*   */
/* Revision: 1.16      BY: Inna Fox             DATE: 06/13/02  ECO: *P04Z*   */
/* Revision: 1.17      BY: Vivek Gogte          DATE: 08/06/02  ECO: *N1QQ*   */
/* Revision: 1.18      BY: Anitha Gopal         DATE: 08/22/02  ECO: *N1RP*   */
/* Revision: 1.19      BY: Narathip W. DATE: 04/29/03 ECO: *P0QN* */
/* Revision: 1.21      BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/* Revision: 1.22     BY: A.R. Jayaram       DATE: 08/25/03 ECO: *P10N* */
/* $Revision: 1.23 $     BY: Marian Kucera     DATE: 07/14/04 ECO: *Q06H* */



/* REVISION: 1.0      LAST MODIFIED: 2008/01/15   BY: Softspeed roger xiao  ECO: *xp001*     */
/*-Revision end-------------------------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "1+ "}
{cxcustom.i "SFOPTR01.P"}

/* DEFINE SHARED VARIABLES FOR DAYBOOKS */
{gldydef.i new}

/* DEFINE NRM VARIABLES */
{gldynrm.i new}

define new global shared variable global_rsntyp like rsn_type.

/* LABOR FEEDBACK VARIABLE DECLARATIONS */
{sfopvar.i "new shared"}

define new shared variable gldetail   like mfc_logical no-undo initial no.
define new shared variable gltrans    like mfc_logical no-undo initial no.
{&SFOPTR01-P-TAG1}

define            variable msgnbr     like msg_nbr     no-undo.
define            variable wonbr      like wr_nbr      no-undo.
define            variable wolot      like wr_lot      no-undo.
define            variable yn         like mfc_logical no-undo.
define            variable valid_proj like mfc_logical no-undo.
define            variable l_move     like mfc_logical no-undo.
define var v_uncomp like wo_qty_comp  label "δ������" . /*xp001*/
define var v_part   like wo_part label "��Ʒ���" .  /*xp001*/

/* RE-ARRANGED FIELD POSITIONS TO DISPLAY FULL OP DESC */
{&SFOPTR01-P-TAG2}
form
   wr_nbr         colon 17
   wr_lot         colon 62
   wr_op          colon 17
   wr_desc        no-label
   wrstatus       colon 62
   /*skip(1)*/  /*xp001*/
   v_part         colon 17  /*xp001*/
   v_uncomp       colon 62 /*xp001*/
   emp            colon 17
   emp_lname      no-label format "x(18)"
   earn           colon 62
   dept           colon 17
   op_wkctr       colon 40
   time_ind       colon 62
   shift          colon 17
   op_mch         colon 40
   project        colon 62
with frame a side-labels width 80 attr-space.
{&SFOPTR01-P-TAG3}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

lh_frame_a = frame a:handle.

/* FRAME b DEFINITION */
{sfopfmb.i}

/* DISPLAY */
view frame a.
view frame b.

for first ea_mstr
   fields( ea_domain ea_earn ea_type)
    where ea_mstr.ea_domain = global_domain and  ea_type = "1"
   no-lock:
end. /* FOR FIRST ea_mstr */

if available ea_mstr
then
   earn = ea_earn.
else
   earn = "".

for first opc_ctrl
   fields( opc_domain opc_move opc_time_ind)
    where opc_ctrl.opc_domain = global_domain no-lock:

   if opc_time_ind = "D"
   then
      time_ind = yes.
   else
      time_ind = no.

   assign
      l_move = opc_move
      move   = opc_move.

end. /* FOR FIRST opc_ctrl */

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

 /*xp001*/	v_uncomp = 0 .
 /*xp001*/	v_part = ""  .

      prompt-for
         wr_nbr
         wr_lot
         wr_op
      editing:

         if frame-field = "wr_nbr"
         then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i wr_route wr_nbr  " wr_route.wr_domain = global_domain and
            wr_nbr "  wr_nbr wr_nbr wr_nbr}
            wonbr = input wr_nbr.
         end. /* IF FRAME-FIELD = "wr_nbr" */

         else if frame-field = "wr_lot"
         then do:

            if wonbr = ""
            then do:
               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp.i wr_route wr_lot  " wr_route.wr_domain = global_domain
               and wr_lot "  wr_lot wr_lot wr_lot}
            end. /* IF wonbr = "" */

            else do:
               /* FIND NEXT/PREVIOUS RECORD FOR THE WORK ORDER NUMBER */
               {mfnp01.i wr_route wr_lot wr_lot
                  "input wr_nbr"  " wr_route.wr_domain = global_domain and
                  wr_nbr "  wr_nbrop}
            end. /* ELSE DO */

            wolot = input wr_lot.
         end. /* ELSE IF FRAME-FIELD = "wr_lot" */

         else if frame-field = "wr_op"
         then do:

            if input wr_nbr > ""
               and wolot    = ""
            then do:
               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp01.i wr_route wr_op wr_op
                  "input wr_nbr"  " wr_route.wr_domain = global_domain and
                  wr_nbr "  wr_nbrop}
            end. /* IF INPUT wr_nbr > "" */

            else do:
               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp01.i wr_route wr_op wr_op
                  "input wr_lot"  " wr_route.wr_domain = global_domain and
                  wr_lot "  wr_lot}
            end. /* ELSE DO */

         end. /* ELSE IF FRAME-FIELD = "wr_op" */

         else do:
            status input.
            readkey.
            apply lastkey.
         end. /* ELSE DO */

         if recno <> ?
         then do:

            /* WORK ORDER ROUTING STATUS */
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
               fields( wo_domain wo_lot wo_nbr wo_project wo_site wo_status
               wo_type  wo_qty_ord wo_qty_comp wo_part)  /*xp001*/
                where wo_mstr.wo_domain = global_domain and  wo_nbr = wr_nbr
               and   wo_lot = wr_lot
               no-lock:
            end. /* FOR FIRST wo_mstr */

            if available wo_mstr
            then do:  /*xp001*/
				v_uncomp = max(0,wo_qty_ord - wo_qty_comp) .
				v_part = wo_part .
               display
					v_part 
					v_uncomp 
                  wo_project @ project.
			end.  /*xp001*/

            for first wc_mstr
               fields( wc_domain wc_dept wc_mch wc_wkctr)
                where wc_mstr.wc_domain = global_domain and  wc_wkctr = wr_wkctr
               and   wc_mch   = wr_mch
               no-lock:
            end. /* FOR FIRST wc_mstr */

            if available wc_mstr
            then
               display
                  wc_dept @ dept.

         end. /* IF recno <> ? */

         recno = ?.

      end. /* EDITING */

      if input wr_nbr     > ""
         and input wr_lot > ""
         and input wr_op  > ""
      then
         for first wr_route
            fields( wr_domain wr_desc wr_lot wr_mch wr_nbr wr_op wr_status
            wr_wkctr)
using  wr_nbr and wr_lot and wr_op where wr_route.wr_domain = global_domain
no-lock:

         end. /* FOR FIRST wr_route */

      if input wr_nbr     > ""
         and input wr_lot = ""
         and input wr_op  > ""
      then
         for first wr_route
            fields( wr_domain wr_desc wr_lot wr_mch wr_nbr wr_op wr_status
            wr_wkctr)
using  wr_nbr and wr_op where wr_route.wr_domain = global_domain  no-lock:

         end. /* FOR FIRST wr_route */

      if input wr_nbr     = ""
         and input wr_lot > ""
         and input wr_op  > ""
      then
         for first wr_route
            fields( wr_domain wr_desc wr_lot wr_mch wr_nbr wr_op wr_status
            wr_wkctr)
using  wr_lot and wr_op where wr_route.wr_domain = global_domain  no-lock:

         end. /* FOR FIRST wr_route */

      if not available wr_route
      then do:

         next-prompt wr_nbr.

         msgnbr = 510.

         if input wr_nbr     > ""
            and input wr_lot > ""
         then do:

            for first wo_mstr
               fields( wo_domain wo_lot wo_nbr wo_project wo_site wo_status
               wo_type)
                where wo_mstr.wo_domain = global_domain and  wo_nbr = input
                wr_nbr
               and   wo_lot = input wr_lot
               no-lock:
            end. /* FOR FIRST wo_mstr */

            if not available wo_mstr
            then do:
               /* WORK ORDER/LOT DOES NOT EXIST */
               msgnbr = 510.
               /* LOT NUMBER BELONGS TO DIFFERENT WORK ORDER */
               if can-find (first wo_mstr
                               where wo_mstr.wo_domain = global_domain and
                               wo_nbr = input wr_nbr)
                  and can-find (first wo_mstr
                                   where wo_mstr.wo_domain = global_domain and
                                   wo_lot = input wr_lot)
               then
                  msgnbr = 508.
            end. /* IF NOT AVAILABLE wo_mstr */

         end. /* IF INPUT wr_nbr > ""*/

         if input wr_nbr     > ""
            and input wr_lot = ""
         then do:

            for first wo_mstr
               fields( wo_domain wo_lot wo_nbr wo_project wo_site wo_status
               wo_type)
                where wo_mstr.wo_domain = global_domain and  wo_nbr = input
                wr_nbr
               no-lock:
            end. /* FOR FIRST wo_mstr */

            /* WORK ORDER NUMBER DOES NOT EXIST */
            if not available wo_mstr
            then
               msgnbr = 503.

         end. /* IF INPUT wr_nbr > "" */

         if input wr_nbr     = ""
            and input wr_lot > ""
         then do:
            next-prompt wr_lot.

            for first wo_mstr
               fields( wo_domain wo_lot wo_nbr wo_project wo_site wo_status
               wo_type)
                where wo_mstr.wo_domain = global_domain and  wo_lot = input
                wr_lot
               no-lock:
            end. /* FOR FIRST wo_mstr */

            /* LOT NUMBER DOES NOT EXIST */
            if not available wo_mstr
            then
               msgnbr = 509.

         end. /* IF INPUT wr_nbr = "" */

         if not available wo_mstr
         then do:
            {pxmsg.i &MSGNUM=msgnbr &ERRORLEVEL=3}
            undo, retry.
         end. /* IF NOT AVAILABLE wo_mstr */

      end. /* IF NOT AVAILABLE wr_route */

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

      for first wo_mstr
         fields( wo_domain wo_lot wo_nbr wo_project wo_site wo_status wo_type)
          where wo_mstr.wo_domain = global_domain and  wo_nbr = wr_nbr
         and   wo_lot = wr_lot
         no-lock:

         if lookup(wo_status,"R,C") = 0
         then do:
            /* RELEASED & CLOSED ORDERS ONLY */
            {pxmsg.i &MSGNUM=525 &ERRORLEVEL=3 &MSGARG1=wo_status}
            next-prompt wr_nbr.
            undo mainloop, retry.
         end. /* IF lookup(wo_status,"R,C") = 0 */

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
            undo mainloop, retry.
         end. /* IF return_int = 0 */

      end. /* FOR FIRST wo_mstr */

      assign
         wrnbr = wr_nbr
         wrlot = wr_lot.

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
         fields( wo_domain wo_lot wo_nbr wo_project wo_site wo_status wo_type 
		 wo_qty_ord wo_qty_comp wo_part )  /*xp001*/
          where wo_mstr.wo_domain = global_domain and  wo_lot = wr_lot
         no-lock:
      end. /* FOR FIRST wo_mstr */


            if available wo_mstr
            then do:  /*xp001*/
				v_uncomp = max(0,wo_qty_ord - wo_qty_comp) .
				v_part = wo_part .
               display
					v_part
					v_uncomp 
                  wo_project @ project.
			end.  /*xp001*/

      for first wc_mstr
         fields( wc_domain wc_dept wc_mch wc_wkctr)
          where wc_mstr.wc_domain = global_domain and  wc_wkctr = wr_wkctr
         and   wc_mch   = wr_mch
         no-lock:
      end. /* FOR FIRST wc_mstr */

      if available wc_mstr
      then
         display
            wc_dept @ dept.

      clear frame b.

      do on error undo, retry:

         if retry and batchrun
         then
            undo mainloop, leave mainloop.

         prompt-for
            {&SFOPTR01-P-TAG4}
            emp
            dept
            shift
            op_wkctr
            op_mch
            earn
            time_ind
            project
         editing:

            if frame-field = "emp"
            then do:
               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp.i emp_mstr emp  " emp_mstr.emp_domain = global_domain and
               emp_addr "  emp emp_addr emp_addr}

               if recno <> ?
               then do:
                  display
                     emp_addr @ emp
                     emp_lname.
               end. /* IF recno <> ? */

            end. /* IF FRAME-FIELD = "emp" */

            else if frame-field = "op_wkctr"
            then do:

               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp.i wc_mstr op_wkctr  " wc_mstr.wc_domain = global_domain
               and wc_wkctr "  op_mch wc_mch wc_wkctr}

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

            end. /* ELSE IF FRAME-FIELD = "op_wkctr" */

            else if frame-field = "op_mch"
            then do:

               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp01.i wc_mstr op_mch wc_mch "input op_wkctr"
                   " wc_mstr.wc_domain = global_domain and wc_wkctr "  wc_wkctr}

               if recno <> ?
               then do:
                  display
                     wc_wkctr @ op_wkctr
                     wc_mch @ op_mch.
                  if input dept = ""
                  then
                     display wc_dept @ dept.
               end. /* IF recno <> ? */

            end. /* ELSE IF FRAME-FIELD = "op_mch" */

            else do:
               status input.
               readkey.
               apply lastkey.
            end. /* ELSE DO */

         end. /* EDITING */
         {&SFOPTR01-P-TAG5}

         if input emp <> ""
         then do:

            for first emp_mstr
               fields( emp_domain emp_addr emp_dept emp_lname emp_status)
                where emp_mstr.emp_domain = global_domain and  emp_addr = input
                emp
               no-lock:
            end. /* FOR FIRST emp_mstr */

            if not available emp_mstr
            then do:
               next-prompt emp.
               /* EMPLOYEE NUMBER DOES NOT EXIST */
               {pxmsg.i &MSGNUM=520 &ERRORLEVEL=3}
               undo,retry.
            end. /* IF NOT AVAILABLE emp_mstr */

            if lookup(emp_status,"AC,PT") = 0
            then do:
               next-prompt emp.
               /* "EMPLOYEE NOT ON ACTIVE STATUS" */
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

         if available emp_mstr
            and input dept = ""
         then do:
            dept = emp_dept.
            display
               dept.
         end. /* IF AVAILABLE emp_mstr */

         for first dpt_mstr
            fields( dpt_domain dpt_dept)
             where dpt_mstr.dpt_domain = global_domain and  dpt_dept = dept
            no-lock:
         end. /* FOR FIRST dpt_mstr */

         if not available dpt_mstr
         then do:
            next-prompt dept.
            /* DEPARTMENT DOES NOT EXIST */
            {pxmsg.i &MSGNUM=532 &ERRORLEVEL=3}
            undo, retry.
         end. /* IF NOT AVAILABLE dpt_mstr */

         if input earn <> ""
         then do:
            for first ea_mstr
               fields( ea_domain ea_earn ea_type)
                where ea_mstr.ea_domain = global_domain and  ea_earn = input
                earn
               no-lock:
            end. /* FOR FIRST ea_mstr */

            if not available ea_mstr
            then do:
               next-prompt earn.
               /* INVALID EARNINGS CODE */
               {pxmsg.i &MSGNUM=4025 &ERRORLEVEL=3}
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

         for first wc_mstr
            fields( wc_domain wc_dept wc_mch wc_wkctr)
             where wc_mstr.wc_domain = global_domain and  wc_wkctr = input
             op_wkctr
            and   wc_mch   = input op_mch
            no-lock:
         end. /* FOR FIRST wc_mstr */

         if not available wc_mstr
         then do:
            next-prompt op_wkctr.
            /* WORK CENTER/MACHINE NOT FOUND */
            {pxmsg.i &MSGNUM=528 &ERRORLEVEL=3}
            undo, retry.
         end. /* IF NOT AVAILABLE wc_mstr */

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
         end. /* IF NOT BATCHRUN ... */

         if project = ""
         then do:

            for first wo_mstr
               fields( wo_domain wo_lot wo_nbr wo_project wo_site wo_status
               wo_type)
                where wo_mstr.wo_domain = global_domain and  wo_nbr = wr_nbr
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
                    where gl_ctrl.gl_domain = global_domain and  gl_verify)
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

      end. /* DO ON ERROR UNDO, RETRY */

      recno = recid(wr_route).
      wr_recno = recid(wr_route).
      wc_recno = recid(wc_mstr).

      assign time_ind.
      status input.

   end. /* DO TRANSACTION WITH FRAME a */

   /* LABOR FEEDBACK CONTINUATION PROGRAM */
   {gprun.i ""sfoptra.p""}  
end. /* REPEAT */

status input.