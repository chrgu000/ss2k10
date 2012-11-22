/* reisslst.p - REPETITIVE   SUBPROGRAM TO MODIFY COMPONENT PART ISSUE LIST   */
/* Copyright 1986-2010 QAD Inc., Santa Barbara, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN77*                */
/* REVISION: 7.3      LAST MODIFIED: 12/16/94   BY: WUG *G09J*                */
/* REVISION: 7.3      LAST MODIFIED: 02/28/95   by: srk *G0FZ*                */
/* REVISION: 7.3      LAST MODIFIED: 03/14/95   BY: pcd *G0H8*                */
/* REVISION: 8.5      LAST MODIFIED: 05/11/95   by: sxb *J04D*                */
/* REVISION: 8.5      LAST MODIFIED: 05/12/95   BY: pma *J04T*                */
/* REVISION: 7.3      LAST MODIFIED: 08/24/95   BY: dzs *G0SY*                */
/* REVISION: 7.3      LAST MODIFIED: 02/05/96   BY: jym *G1G0*                */
/* REVISION: 8.5      LAST MODIFIED: 08/29/96   BY: *G2D9* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 12/31/96   BY: *H0Q8* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 02/03/98   BY: *J2DF* Viswanathan        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 08/26/98   BY: *L07B* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/20/00   BY: *M0Q3* Vandna Rohira      */
/* REVISION: 9.1      LAST MODIFIED: 08/02/00   BY: *N0GD* Peggy Ng           */
/* REVISION: 9.1      LAST MODIFIED: 12/12/00   BY: *L16J* Thomas Fernandes   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.9.1.11  BY: Rajesh Thomas           DATE: 07/23/01 ECO: *M1FL* */
/* Revision: 1.9.1.12  BY: Kirti Desai             DATE: 11/01/01 ECO: *N151* */
/* Revision: 1.9.1.13  BY: Kirti Desai             DATE: 02/08/02 ECO: *M1TV* */
/* Revision: 1.9.1.14  BY: Hareesh V               DATE: 10/11/02 ECO: *N1X2* */
/* Revision: 1.9.1.15  BY: Subramanian Iyer        DATE: 12/10/02 ECO: *N21V* */
/* Revision: 1.9.1.16  BY: Narathip W.             DATE: 04/21/03 ECO: *P0Q9* */
/* Revision: 1.9.1.18  BY: Paul Donnelly (SB)      DATE: 06/28/03 ECO: *Q00K* */
/* Revision: 1.9.1.21  BY: Subramanian Iyer        DATE: 11/24/03 ECO: *P13Q* */
/* Revision: 1.9.1.22  BY: Ken Casey               DATE: 02/19/04 ECO: *N2GM* */
/* Revision: 1.9.1.23  BY: Dayanand Jethwa         DATE: 04/28/04 ECO: *P1YJ* */
/* Revision: 1.9.1.24  BY: Vandna Rohira           DATE: 02/10/05 ECO: *P37N* */
/* Revision: 1.9.1.25  BY: Priyank Khandare        DATE: 05/13/05 ECO: *P3L6* */
/* Revision: 1.9.1.26  BY: Jignesh Rachh           DATE: 10/28/05 ECO: *P46J* */
/* Revision: 1.9.1.27  BY: Samit Patil             DATE: 11/25/05 ECO: *P499* */
/* Revision: 1.9.1.27.2.2 BY: Masroor Alam         DATE: 03/22/06 ECO: *P4LX* */
/* Revision: 1.9.1.27.2.3 BY: Prashant Parab       DATE: 12/12/06 ECO: *P5J3* */
/* Revision: 1.9.1.27.2.4 BY: Prashant Parab       DATE: 12/19/06 ECO: *P5J3* */
/* Revision: 1.9.1.27.2.5 BY: Munira Savai         DATE: 08/22/07 ECO: *P61P* */
/* Revision: 1.9.1.27.2.6 BY: Archana Kirtane      DATE: 12/11/07 ECO: *P6GP* */
/* Revision: 1.9.1.27.2.7 BY: Robert Jensen        DATE: 06/26/08 ECO: *Q1NW* */
/* Revision: 1.9.1.27.2.8 BY: Ambrose Almeida      DATE: 09/12/08 ECO: *Q1SZ* */
/* Revision: 1.9.1.27.2.9 BY: Avishek Chakraborty  DATE: 01/09/09 ECO: *Q213* */
/* Revision: 1.9.1.27.2.11 BY: Winnie Ouyang       DATE: 03/02/09 ECO: *Q2HR* */
/* Revision: 1.9.1.27.2.12 BY: Ruchita Sinde       DATE: 05/07/09 ECO: *Q2V3* */
/* Revision: 1.9.1.27.2.13  BY: Ravi Swami         DATE: 06/18/09 ECO: *Q313* */
/* Revision: 1.9.1.27.2.16  BY: Mukesh Singh       DATE: 07/23/09 ECO: *Q2WN* */
/* Revision: 1.9.1.27.2.17  BY: Ravi Swami         DATE: 10/09/09 ECO: *Q3GS* */
/* Revision: 1.9.1.27.2.18  BY: Katie Hilbert      DATE: 04/05/10 ECO: *Q3ZM* */
/* $Revision: 1.9.1.27.2.19 $  BY: Rajat Kulshreshtha    DATE: 04/15/10 ECO: *Q40C* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

/* TAKEN FROM reisrc01.p */

{mfdeclre.i}
{cxcustom.i "REISSLST.P"}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

{wndvar2.i "new shared"}

define input parameter cumwo_lot as character.
define input parameter wopart    as character.
define input parameter wosite    as character.
define input parameter eff_date  as date.
define input parameter wkctr     as character.
define input parameter qty_comp  as decimal.

define output parameter undo_stat like mfc_logical no-undo.

define new shared variable parent_assy       like pts_par.
define new shared variable part              like wod_part.
define new shared variable wopart_wip_acct   like pl_wip_acct.
define new shared variable wopart_wip_sub    like pl_wip_sub.
define new shared variable wopart_wip_cc     like pl_wip_cc.
define new shared variable site              like sr_site              no-undo.
define new shared variable location          like sr_loc               no-undo.
define new shared variable lotserial         like sr_lotser            no-undo.
define new shared variable lotref            like sr_ref format "x(8)" no-undo.
define new shared variable lotserial_qty     like sr_qty               no-undo.
define new shared variable  multi_entry      as   logical
   label "Multi Entry"                                                 no-undo.
define new shared variable lotserial_control as character.
define new shared variable cline             as character.
define new shared variable row_nbr           as integer.
define new shared variable col_nbr           as integer.
define new shared variable issue_or_receipt  as character.

define new shared variable total_lotserial_qty like wod_qty_chg.
define new shared variable wo_recid            as   recid.
define new shared variable pk_recno            as   recid.
define new shared variable t_pk_recno          as   recid.
define new shared variable comp                like ps_comp.
define new shared variable fill_all            like mfc_logical
   label "Issue Alloc" initial no.
define new shared variable fill_pick           like mfc_logical
   label "Issue Picked" initial yes.
define new shared variable trans_um            like pt_um.
define new shared variable trans_conv          like sod_um_conv.
define new shared variable transtype           as   character.
define new shared variable h_ui_proc           as   handle        no-undo.

define variable wfirst   as   logical     initial yes       no-undo.
define variable nbr      like wo_nbr.
define variable qopen    like wod_qty_all label "Qty Open".
define variable yn       like mfc_logical.
define variable ref      like glt_ref.
define variable desc1    like pt_desc1.
define variable trqty    like tr_qty_chg.
define variable trlot    like tr_lot.
define variable qty_left like tr_qty_chg.
define variable del-yn   like mfc_logical initial no.

define variable tot_lad_all    like lad_qty_all.
define variable ladqtychg      like lad_qty_all.
define variable sub_comp       like mfc_logical label "Substitute".
define variable cancel_bo      like mfc_logical label "Cancel B/O".
define variable default_cancel like cancel_bo.
define variable ptum           like pt_um                          no-undo.
define variable iss_loc        like pk_loc.
define variable rejected       like mfc_logical.
define variable rejected2      like mfc_logical.
define variable op             like wod_op.

define variable l_error          like mfc_logical no-undo.
define variable l_sr_site        like sr_site     no-undo.
define variable l_delete_sr_wkfl like mfc_logical no-undo.
define variable l_update_sr_wkfl like mfc_logical no-undo.
define variable l_sr_lineid      like sr_lineid   no-undo.
define variable lotnext          like wo_lot_next.
define variable lotprcpt         like wo_lot_rcpt no-undo.
define variable l_pk_qty         like pk_qty      no-undo.
define variable l_loc            like pt_loc      no-undo.

{&REISSLST-P-TAG1}

/* TEMP-TABLE t_sr_wkfl STORES THE LIST OF DEFAULT sr_wkfl      */
/* RECORDS (NOT MODIFIED BY THE USER)                           */
/* t_sr_wkfl RECORD IS DELETED WHEN THE DEFAULT sr_wkfl RECORD  */
/* IS MODIFIED. DURING MULTI-ENTRY, IF t_sr_wkfl RECORD EXISTS, */
/* DELETE DEFAULT sr_wkfl RECORD TO AVOID MANUAL DELETION.      */

define temp-table t_sr_wkfl no-undo
   field t_sr_lineid like sr_lineid
   index t_sr_lineid is unique t_sr_lineid.

/* TEMP-TABLE t_pk_det STORES THE LIST OF DEFAULT pk_det RECORDS  */
/* AND IF THE COMPONENT ITEM HAS INSUFFICIENT STOCK TO ISSUE,     */
/* THEN STORES THE STATUS AS "UNABLE TO ISSUE"                    */

define temp-table t_pk_det no-undo
   field t_pk_domain like pk_domain
   field t_pk_user   like pk_user
   field t_pk_part   like pk_part
   field t_pk_ref    like pk_reference
   field t_pk_qty    like pk_qty
   field t_pk_stat   as   character format "x(18)" label "Status"
   field t_pk_recid  as   recid
   index t_pk_det is unique t_pk_domain t_pk_user t_pk_part t_pk_ref.

define buffer ptmstr   for pt_mstr.

define variable datainput as character format "x(20)" no-undo.

issue_or_receipt = getTermLabel("ISSUE",8).

{&REISSLST-P-TAG2}
form
   part           colon 13
   /*V8! View-as fill-in size 18 by 1 */
   op
   wosite         colon 58 label "Site"
   pt_desc1       colon 13
   location       colon 58 label "Loc"
   pt_desc2       colon 13 no-label
   lotserial      colon 58
   lotserial_qty  colon 13
   pt_um                   no-label
   lotref         colon 58
   sub_comp       colon 13
   multi_entry    colon 58
with overlay frame d side-labels width 80 attr-space row 14.
{&REISSLST-P-TAG3}

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

/* EMPTY TEMP-TABLEs  */
empty temp-table t_sr_wkfl.
empty temp-table t_pk_det.
assign
   undo_stat = yes
   {&REISSLST-P-TAG4}
   site      = wosite
   iss_loc   = "".

if can-find (loc_mstr
   where loc_mstr.loc_domain = global_domain
   and   loc_loc  = wkctr
   and   loc_site = wosite)
then
   iss_loc = wkctr.

for first clc_ctrl
   fields(clc_active clc_domain clc_comp_issue)
   where clc_ctrl.clc_domain = global_domain
no-lock:
end. /* FOR FIRST clc_ctrl */

if not available clc_ctrl
then do:
   {gprun.i ""gpclccrt.p""}

   for first clc_ctrl
      fields(clc_active clc_domain clc_comp_issue)
      where clc_ctrl.clc_domain = global_domain
   no-lock:
   end. /* FOR FIRST clc_ctrl */

end. /* IF NOT AVAILABLE clc_ctrl */

do transaction:
   for each sr_wkfl
      where sr_wkfl.sr_domain = global_domain
      and   sr_userid = mfguser
      and   sr_lineid begins "-"
   exclusive-lock:
         delete sr_wkfl.
   end. /* FOR EACH sr_wkfl */

   for each pk_det
      fields( pk_domain pk_loc pk_part pk_qty pk_reference pk_user)
      where pk_det.pk_domain = global_domain
      and   pk_user          = mfguser
   no-lock
   break by pk_user
         by pk_part:

      l_sr_lineid = "-" + string(pk_part,"x(18)") + pk_reference.

      find sr_wkfl
         where sr_wkfl.sr_domain = global_domain
         and   sr_userid = mfguser
         and   sr_lineid = l_sr_lineid
         and   sr_site   = wosite
         and   sr_loc    = pk_loc
         exclusive-lock no-error.

      for first ptmstr
         fields( pt_domain pt_desc1 pt_desc2 pt_loc pt_lot_ser pt_part pt_um)
         where ptmstr.pt_domain = global_domain and  ptmstr.pt_part = pk_part
         no-lock:
      end. /* FOR FIRST ptmstr */

      accumulate pk_qty (sub-total by pk_part).
      if execname = "yyrebkfl.p"
      then
         l_pk_qty = accum sub-total by pk_part pk_qty.
      else
         l_pk_qty = pk_qty.
      if available sr_wkfl and l_pk_qty + sr_qty <> 0 then do:
      {gprun.i ""icedit2.p"" "(input ""ISS-WO"",
                               input wosite,
                               input pk_loc,
                               input ptmstr.pt_part,
                               input """",
                               input """",
                               input l_pk_qty + if available sr_wkfl
                                                then
                                                   sr_qty
                                                else
                                                   0,
                               input ptmstr.pt_um,
                               input """",
                               input ""test1"",
                               output rejected)"
      }
			end.
      /* DEFAULT sr_wkfl RECORD IS STORED IN TEMP-TABLE t_sr_wkfl */
      if not available sr_wkfl
      then do:

         create sr_wkfl.
         create t_sr_wkfl.

         assign
            sr_domain   = global_domain
            sr_userid   = mfguser
            sr_lineid   = l_sr_lineid
            sr_site     = wosite
            sr_loc      = pk_loc
            sr_lotser   = ""
            sr_ref      = ""
            t_sr_lineid = l_sr_lineid.

         if recid(sr_wkfl) = -1
         then
            .

      end. /* IF NOT AVAILABLE sr_wkfl */

      if available sr_wkfl
      then
         sr_qty = sr_qty + pk_qty.
      for first t_pk_det
         where t_pk_det.t_pk_domain = global_domain
         and   t_pk_user            = mfguser
         and   t_pk_part            = pk_part
         and   t_pk_ref             = pk_reference
      exclusive-lock:
      end. /* FOR FIRST t_pk_det */

      if not available t_pk_det
      then do:

         create t_pk_det.

         assign
            t_pk_domain = global_domain
            t_pk_user  = mfguser
            t_pk_part  = pk_part
            t_pk_ref   = pk_reference
            t_pk_qty   = pk_qty
            t_pk_recid = recid(pk_det).
         if recid(t_pk_det) = -1
         then
            .

      end. /* IF NOT AVAILABLE t_pk_det */

      if rejected  = yes
      then do:
         assign
            rejected2 = yes
            t_pk_stat = getTermLabel("UNABLE_TO_ISSUE",15).

         for each t_pk_det
            where t_pk_det.t_pk_domain  =  global_domain
            and   t_pk_det.t_pk_user    =  mfguser
            and   t_pk_det.t_pk_part    =  pk_part
            and   t_pk_det.t_pk_ref    <>  pk_reference
         exclusive-lock:
            t_pk_det.t_pk_stat = getTermLabel("UNABLE_TO_ISSUE",15).
         end. /* FOR EACH pk_det */

      end. /* IF rejected  = yes */

   end. /* FOR EACH pk_det */

end. /* DO TRANSACTION */

seta:
repeat:
   do transaction on error undo, retry:
      setd:
      repeat:

         clear frame d.
         view frame d.

         wfirst = yes.

         select-part:
         repeat on endkey undo, leave:
            if batchrun = no and not {gpisapi.i}
            then do:

               for first t_pk_det
                  where t_pk_det.t_pk_domain = global_domain
                  and   t_pk_user            = mfguser
               exclusive-lock:
               end. /* FOR FIRST t_pk_det */

               datainput = getFrameTitle("ISSUE_DATA_INPUT",20).
               window_row = 6 .
               comp-block  :
               repeat:
                  {windowxt.i
                     &file = t_pk_det
                     &display = "t_pk_part t_pk_ref t_pk_qty t_pk_stat"
                     &index-fld1 = t_pk_part
                     &use-index1 = "use-index t_pk_det"
                     &index-fld2 = t_pk_part
                     &use-index2 = "use-index t_pk_det"
                     &frametitle = datainput
                     &window-down = 5
                     &framephrase = "width 80"
                     &where1 = "where t_pk_det.t_pk_domain = global_domain
                                and t_pk_user = mfguser"
                     &where2 = "where t_pk_det.t_pk_domain = global_domain
                                and true"
                     &and = "(t_pk_user = mfguser)"
                     &time-out = 0
                     }
                 leave comp-block.
               end. /*COMP-BLOCK*/
               if keyfunction(lastkey) <> "END-ERROR" then
                  view frame w.

               assign
                  wfirst     = no
                  t_pk_recno = window_recid.

            end. /* IF batchrun = no */

            if keyfunction(lastkey) = "END-ERROR" and not {gpisapi.i}
            then
               leave.
            clear frame d.
 for each pk_det
        fields( pk_domain pk_loc pk_part pk_qty pk_reference pk_user)
        where pk_det.pk_domain = global_domain and pk_user = mfguser
        no-lock:
  
        l_sr_lineid = "-" + string(pk_part,"x(18)") + pk_reference.
  
        for each sr_wkfl
           fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                  sr_site sr_userid)
           where sr_wkfl.sr_domain = global_domain
           and   sr_userid = mfguser
           and   sr_lineid = l_sr_lineid:
          delete sr_wkfl.
    end.
  end.


            do on error undo , retry with frame d:
               assign
                  part = ""
                  op   = 0.

               if t_pk_recno <> ?
               then do:

                  for first t_pk_det
                     where recid(t_pk_det) = t_pk_recno
                  no-lock:
                  end. /* FOR FIRST t_pk_det */

                  if available t_pk_det
                  then do:

                     for first pk_det
                        fields( pk_domain pk_loc pk_part pk_qty pk_reference
                        pk_user)
                        where recid(pk_det) = t_pk_recid
                     no-lock:
                     end. /* FOR FIRST pk_det */

                     if available pk_det
                     then
                        assign
                           op   = integer(pk_reference)
                           part = pk_part.

                  end. /* IF AVAILABLE t_pk_det */

               end. /* IF t_pk_recno */

               display
                  part
                  op.

               for first pt_mstr
                  fields( pt_domain pt_desc1 pt_desc2 pt_loc pt_lot_ser pt_part
                  pt_um)
                  where pt_mstr.pt_domain = global_domain and  pt_part = part
               no-lock:
               end. /* FOR FIRST pt_mstr */

               if available pt_mstr
               then
                  display
                     pt_desc1
                     pt_desc2.
               else
                  display
                     "" @ pt_desc1
                     "" @ pt_desc2.

               trans_um = "".
               if available pt_mstr
               then
                  trans_um = pt_um.

               trans_conv = 1.
               /* CONDITION ADDED TO IMPROVE PERFORMANCE IN DESKTOP 2 */
               if not {gpiswrap.i}
               then
                  input clear.

               get-part:
               do on error undo , retry:
                  set
                     part
                     op
                     with frame d editing:

                     if frame-field = "part"
                     then do:
                        {mfnp01.i pk_det
                                  part
                                  pk_part
                                  mfguser
                                   " pk_det.pk_domain = global_domain and
                                   pk_user "
                                  pk_det}

                        if recno <> ?
                        then do:
                           assign
                              part = pk_part
                              op   = integer(pk_reference).

                           display
                              part
                              op
                           with frame d.

                           for first pt_mstr
                              fields( pt_domain pt_desc1 pt_desc2 pt_loc
                              pt_lot_ser
                                     pt_part pt_um)
                               where pt_mstr.pt_domain = global_domain and
                               pt_part = part
                              no-lock:
                           end. /* FOR FIRST pt_mstr */

                           if available pt_mstr
                           then do:
                              display
                                 pt_um
                                 pt_desc1
                                 pt_desc2
                              with frame d.
                           end. /* IF AVAILABLE pt_mstr */
                        end. /* IF recno <> ? */
                     end. /* IF framefield = "part" */
                     else do:
                        ststatus = stline[3].
                        status input ststatus.
                        readkey.
                        apply lastkey.
                     end. /* ELSE DO */
                  end. /* SET */

                  for first wr_route
                     fields( wr_domain wr_lot wr_op)
                     where wr_route.wr_domain = global_domain
                     and   wr_lot = cumwo_lot
                     and   wr_op  = op
                  no-lock:
                  end. /* FOR FIRST wr_route */

                  if not available wr_route
                  then do:
                     /* UNABLE TO ISSUE OR RECEIVE FOR ITEM */
                     if not batchrun then do:
                     		{pxmsg.i &MSGNUM=106 &ERRORLEVEL=3}
                     end.
                     next-prompt op.
                     undo, retry.
                  end. /* IF NOT AVAILABLE wr_route */

                  status input.

                  if part = ""
                  then
                     leave.

                  frame-d-loop:
                  repeat:
        /*             pause 0. */
                     assign
                        sub_comp    = no
                        multi_entry = no.

                     find first pk_det
                        where pk_det.pk_domain = global_domain
                        and   pk_user      = mfguser
                        and   pk_part      = part
                        and   pk_reference = string(op)
                     exclusive-lock no-error.

                     if not available pk_det
                     then do:
                        if clc_active
                        then do:

                           if clc_comp_issue
                           then do:

                              /* ITEM DOES NOT EXIST ON THIS BILL OF MATL */
                              if not batchrun then do:
                              	{pxmsg.i &MSGNUM=547 &ERRORLEVEL=2}
                              end.
                           end. /* IF clc_comp_issue */
                           else do:

                              /* COMPLIANCE MODULE RESTRICTS COMP ISSUE   */
                              /* ITEM DOES NOT EXIST ON THIS BILL OF MATL */
                              if not batchrun then do:
                              		{pxmsg.i &MSGNUM=547 &ERRORLEVEL=3}
                              end.
                              undo select-part, retry.
                           end. /* ELSE DO */
                        end. /* IF clc_active */
                        else do:
                           /* ITEM DOES NOT EXIST ON THIS BILL OF MATL */
                           if not batchrun then do:
                           {pxmsg.i &MSGNUM=547 &ERRORLEVEL=2}
                           end.
                        end.

                        create pk_det.
                        assign
                           pk_domain    = global_domain
                           pk_user      = mfguser
                           pk_part      = part
                           pk_reference = string(op).

                        if recid(pk_det) = -1
                        then
                           .

                        for first t_pk_det
                           where t_pk_det.t_pk_domain = global_domain
                           and   t_pk_user            = mfguser
                           and   t_pk_part            = pk_part
                           and   t_pk_ref             = pk_reference
                        exclusive-lock:
                        end. /* FOR FIRST t_pk_det */

                        if not available t_pk_det
                        then do:

                           create t_pk_det.

                              assign
                                 t_pk_domain = global_domain
                                 t_pk_user  = mfguser
                                 t_pk_part  = part
                                 t_pk_ref   = string(op).

                              if recid(t_pk_det) = -1
                              then
                                 .
                        end. /*IF NOT AVAILABLE t_pk_det*/
                     end. /* IF NOT AVAILABLE pk_det */

                     for first pt_mstr
                        fields( pt_domain pt_desc1 pt_desc2 pt_loc pt_lot_ser
                               pt_part pt_um)
                         where pt_mstr.pt_domain = global_domain
                          and  pt_part = part
                        no-lock:
                     end. /* FOR FIRST pt_mstr */

                     if not available pt_mstr
                     then do:
                        /* ITEM NUMBER DOES NOT EXIST */
                        if not batchrun then do:
                        {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
											  end.
                        display
                           part " " @ pt_um
                           " " @ pt_desc1
                           " " @ pt_desc2
                        with frame d.
                        ptum = "".
                        undo get-part , retry get-part.
                     end. /* IF NOT AVAILABLE pt_mstr */
                     else do:
                        for first in_mstr
                           where in_domain = global_domain
                             and in_part   = pk_part
                             and in_site   = wosite
                        no-lock:
                        end. /* FOR FIRST in_mstr */

                        if new pk_det
                        then do:
                           if available in_mstr
                           then
                              pk_loc = in_loc.
                           else
                              pk_loc = pt_loc.
                        end. /* IF NEW pk_det */

                        if iss_loc <> ""
                        then
                           pk_loc = iss_loc.
                        else do:
                           if available in_mstr
                           then
                              pk_loc = in_loc.
                           else
                              pk_loc = pt_loc.
                        end. /*ELSE DO */
                        display
                           pt_part @ part
                           pt_um
                           pt_desc1
                           pt_desc2
                        with frame d.

                        ptum = pt_um.
                     end. /* ELSE DO */
                     assign
                        qopen             = pk_qty
                        lotserial_control = "".

                     if available pt_mstr
                     then
                        lotserial_control = pt_lot_ser.

                     assign
                        location      = ""
                        lotserial     = ""
                        lotref        = ""
                        lotserial_qty = pk_qty
                        cline         = "-" + string(pk_part,"x(18)")
                                            + pk_reference
                        global_part   = pk_part.

                     for first sr_wkfl
                        fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty
                                sr_ref sr_site sr_userid)
                        where sr_wkfl.sr_domain = global_domain
                        and   sr_userid = mfguser
                        and   sr_lineid = cline
                     no-lock:
                     end. /* FOR FIRST sr_wkfl */

                     if available sr_wkfl
                     then do:

                        for first sr_wkfl
                           fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty
                           sr_ref sr_site sr_userid)
                           where sr_wkfl.sr_domain = global_domain
                           and   sr_userid = mfguser
                           and   sr_lineid = cline
                        no-lock:
                        end. /* FOR FIRST sr_wkfl */

                        if available sr_wkfl
                        then
                           assign
                              wosite    = sr_site
                              location  = sr_loc
                              lotserial = sr_lotser
                              lotref    = sr_ref.
                        else
                           multi_entry  = yes.
                     end. /* IF AVAILABLE sr_wkfl */
                     else
                        location = pk_loc.

                     do on error undo, retry
                        on endkey undo select-part, retry:

                        pk_recno = recid(pk_det).

                        update
                           lotserial_qty
                           sub_comp
                           wosite
                           location
                           lotserial
                           lotref
                           multi_entry
                           {&REISSLST-P-TAG5}
                        with frame d
                        editing:
                           assign
                              global_site = input wosite
                              global_loc  = input location
                              global_lot  = input lotserial
                              ststatus    = stline[3].
                           status input ststatus.
                           readkey.
                           apply lastkey.
                        end. /* UPDATE */

                        {&REISSLST-P-TAG6}
                        if sub_comp
                        then do:
                           if can-find (first pts_det
                               where pts_det.pts_domain = global_domain and (
                               pts_part = pk_part
                              and   pts_par  = ""))
                              or can-find (first pts_det
                                  where pts_det.pts_domain = global_domain and
                                  pts_part = pk_part
                                 and   pts_par  = wopart)
                           then do:

                              for first wo_mstr
                                 fields( wo_domain wo_lot wo_part)
                                  where wo_mstr.wo_domain = global_domain and
                                  wo_lot = cumwo_lot
                                 no-lock:
                              end. /* FOR FIRST wo_mstr */

                              {gprun.i ""resumt1.p"" "(input wo_part)"}

                              /*  pk_qty IS UPDATED FROM resumt1.P AND t_pk_qty */
                              /*  ALSO NEED TO BE UPDATED WITH pk_qty  */
                              t_pk_qty = pk_qty.

                              if keyfunction(lastkey) = "END-ERROR"
                              then
                                 undo , retry.

                              for first pt_mstr
                                 fields( pt_domain pt_desc1 pt_desc2 pt_loc
                                         pt_lot_ser pt_part pt_um)
                                 where pt_mstr.pt_domain = global_domain
                                 and   pt_part = part
                              no-lock:
                              end. /* FOR FIRST pt_mstr */

                              if not available pt_mstr
                              then do:
                                 /* ITEM NUMBER DOES NOT EXIST */
                                 if not batchrun then do:
                                 {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
                                 end.
                                 undo seta , retry seta.
                              end. /* IF NOT AVAILABLE pt_mstr */

                              for first pk_det
                                 where  pk_domain    = global_domain
                                    and pk_user      = mfguser
                                    and pk_part      = part
                                    and pk_reference = string(op)
                              exclusive-lock :
                              end. /* FOR FIRST pk_det */

                              if not available pk_det
                              then do:
                                 create pk_det.
                                 assign
                                    pk_domain    = global_domain
                                    pk_user      = mfguser
                                    pk_part      = part
                                    pk_reference = string(op).

                                 if recid(pk_det) = -1
                                 then
                                    .
                                 if iss_loc <> ""
                                 then
                                    pk_loc = iss_loc.
                                 else
                                    pk_loc = pt_loc.
                              end. /* IF NOT AVAILABLE pk_det */

                              pk_qty = pk_qty + lotserial_qty.

                              for first t_pk_det
                                 where t_pk_domain = global_domain
                                 and   t_pk_user   = mfguser
                                 and   t_pk_part   = part
                                 and   t_pk_ref    = pk_reference
                              exclusive-lock:
                              end. /* FOR FIRST t_pk_det */

                              if not available t_pk_det
                              then do:
                                 create t_pk_det.

                                 assign
                                    t_pk_domain = global_domain
                                    t_pk_user  = mfguser
                                    t_pk_part  = pk_part
                                    t_pk_ref   = pk_reference
                                    t_pk_recid = recid(pk_det).

                                 if recid(t_pk_det) = -1
                                 then
                                    .
                              end. /* IF NOT AVAILABLE t_pk_det */

                              t_pk_qty = t_pk_qty + lotserial_qty.

                              {&REISSLST-P-TAG7}
                              find sr_wkfl
                                 where sr_wkfl.sr_domain = global_domain
                                 and   sr_userid = mfguser
                                 and   sr_lineid = cline
                                 and   sr_site   = wosite
                                 and   sr_loc    = pk_loc
                                 and   sr_lotser = ""
                                 and   sr_ref    = ""
                              exclusive-lock no-error.

                              if not available sr_wkfl
                              then do:
                                 create sr_wkfl.

                                 assign
                                    sr_domain = global_domain
                                    sr_userid = mfguser
                                    sr_lineid = cline
                                    sr_site   = wosite
                                    sr_loc    = pk_loc.

                                 if recid(sr_wkfl) = -1
                                 then
                                    .

                                 if not can-find(first t_sr_wkfl
                                    where t_sr_lineid = cline)
                                 then do:

                                    create t_sr_wkfl.
                                    t_sr_lineid = cline.

                                 end. /* IF NOT CAN-FIND(FIRST ... */

                              end. /* IF NOT AVAILABLE sr_wkfl */

                              sr_qty = sr_qty + lotserial_qty.

                              next frame-d-loop.
                           end. /* IF CAN-FIND */

                           else do with frame d:
                              /* APPROVED ALTERNATE ITEM DOES NOT EXIST */
                              if not batchrun then do:
                              	{pxmsg.i &MSGNUM=545 &ERRORLEVEL=3}
                              end.
                              next-prompt sub_comp.
                              undo , retry.
                           end. /* ELSE DO */
                        end. /* IF sub-comp */

                        if can-find (first sr_wkfl
                            where sr_wkfl.sr_domain = global_domain and
                            sr_userid = mfguser and sr_lineid = cline)
                           and not can-find (sr_wkfl
                            where sr_wkfl.sr_domain = global_domain and
                            sr_userid = mfguser and sr_lineid = cline)
                           then
                              multi_entry = yes.

                        total_lotserial_qty = pk_qty.

                        if multi_entry
                        then do:

                           assign
                              l_delete_sr_wkfl = no
                              l_update_sr_wkfl = no
                              transtype        = "ISS-WO"
                              lotnext          = lotserial
                              lotprcpt         = no.

                           if available pt_mstr
                           then
                              trans_um = pt_um.

                           /* DEFAULT CREATED sr_wkfl RECORD IS     */
                           /* DELETED TO AVOID DELETING IT MANUALLY */
                           /* IN MULTI ENTRY SCREEN                 */

                           for first t_sr_wkfl
                              where t_sr_lineid = cline
                              no-lock:

                              find first sr_wkfl
                                 where sr_wkfl.sr_domain = global_domain
                                 and   sr_userid  = mfguser
                                 and   sr_lineid  = t_sr_lineid
                                 and   sr_loc     = pk_loc
                                 and   sr_ref     = ""
                                 and   sr_lot     = ""
                                 and   sr_qty     = pk_qty
                              exclusive-lock no-error.

                              if available sr_wkfl
                              then do:

                                 /* STORING VALUE IN l_sr_site    */
                                 /* TO RE-CREATE DEFAULT sr_wkfl  */
                                 assign
                                    l_sr_site        = sr_site
                                    l_delete_sr_wkfl = yes.

                                 delete sr_wkfl.

                              end. /* IF AVAILABLE sr_wkfl */

                           end. /* FOR FIRST t_sr_wkfl */

                           /* Identify context for QXtend */
                           {gpcontxt.i
                              &STACKFRAG = 'icsrup1,reisslst,rebkfl'
                              &FRAME = 'a'
                              &CONTEXT = 'ISSUE'}
                           for first wo_mstr
                              where wo_domain = global_domain
                              and   wo_lot = cumwo_lot
                           no-lock:
                           end. /* FOR FIRST wo_mstr */
                           if execname = "yyrebkfl.p"
                           then do:
                               {gprun.i ""icsrup1.p""
                                 "(input        wo_site,
                                   input        """",
                                   input        wo_lot,
                                   input-output lotnext,
                                   input        lotprcpt,
                                   input-output l_update_sr_wkfl)"
                                 }
                           end. /* IF execname = "yyrebkfl.p" */
                           else do:
                              {gprun.i ""icsrup1.p""
                                 "(input        wosite,
                                    input        """",
                                    input        """",
                                    input-output lotnext,
                                    input        lotprcpt,
                                    input-output l_update_sr_wkfl)"
                              }
                           end. /* ELSE DO */

                           /* Identify context for QXtend */
                           {gpcontxt.i
                              &STACKFRAG = 'icsrup1,reisslst,rebkfl'
                              &FRAME = 'a'}

                           /* RE-CREATE DEFAULT sr_wkfl, IF sr_wkfl */
                           /* IS NOT UPDATED IN MULTI ENTRY SCREEN. */
                           /* SO THIS RECORD IS DISPLAYED WHEN      */
                           /* "DISPLAY ITEMS BEING ISSUED" = YES    */
                           /* AND INVENTORY VALIDATION CAN BE DONE. */

                           if l_delete_sr_wkfl
                           then do:

                              if not l_update_sr_wkfl
                              then do:

                                 if not can-find(first sr_wkfl
                                      where sr_wkfl.sr_domain = global_domain
                                       and  sr_userid = mfguser
                                       and  sr_lineid = cline)
                                 then do:

                                    create sr_wkfl.

                                    assign
                                       sr_domain           = global_domain
                                       sr_userid           = mfguser
                                       sr_lineid           = cline
                                       sr_site             = l_sr_site
                                       sr_loc              = pk_loc
                                       sr_lotser           = ""
                                       sr_ref              = ""
                                       sr_qty              = pk_qty
                                       total_lotserial_qty = total_lotserial_qty
                                                             + pk_qty.

                                    if recid(sr_wkfl) = -1
                                    then
                                       .

                                 end. /* IF NOT CAN-FIND(FIRST ... */

                              end. /* IF NOT l_update_sr_wkfl */

                              else do:

                                 /* DELETE TEMP-TABLE RECORD TO   */
                                 /* INDICATE DEFAULT sr_wkfl IS   */
                                 /* UPDATED IN MULTI-ENTRY SCREEN */

                                 find first t_sr_wkfl
                                    where sr_lineid = cline
                                    exclusive-lock no-error.

                                 if available t_sr_wkfl
                                 then
                                    delete t_sr_wkfl.

                              end. /* ELSE DO */

                              l_delete_sr_wkfl = no.

                           end. /* IF l_delete_sr_wkfl */

                        end. /* IF multi-entry */

                        else do:

                           if lotserial_qty <> 0
                           then do:
                              {gprun.i ""icedit.p"" "(input ""ISS-WO"",
                                                      input wosite,
                                                      input location,
                                                      input global_part,
                                                      input lotserial,
                                                      input lotref,
                                                      input lotserial_qty,
                                                      input ptum,
                                                      input """",
                                                      input ""test2"",
                                                      output rejected)"
                                 }
                              if rejected
                              then
                                 undo, retry.
                           end. /* IF lotserial_qty */

                           find first sr_wkfl
                              where sr_wkfl.sr_domain = global_domain
                              and   sr_userid = mfguser
                              and   sr_lineid = cline
                           exclusive-lock no-error.

                           if lotserial_qty = 0
                           then do:

                              if available sr_wkfl
                              then
                                 assign
                                    total_lotserial_qty = total_lotserial_qty
                                                           - sr_qty
                                    sr_qty              = 0.

                           end. /* IF lotserial_qty = 0 */
                           else do:
                              if not available sr_wkfl
                              then do:
                                 create sr_wkfl.
                                 assign
                                    sr_domain = global_domain
                                    sr_userid = mfguser
                                    sr_lineid = cline.

                              if recid(sr_wkfl) = -1
                              then
                                 .
                              end. /* IF NOT AVAILABLE sr_wkfl */

                              /* DELETE TEMP-TABLE RECORD TO */
                              /* INDICATE DEFAULT CREATED    */
                              /* RECORD IS MODIFIED          */

                              find first t_sr_wkfl
                                 where t_sr_lineid = cline
                                 exclusive-lock no-error.
                              if available t_sr_wkfl
                              then
                                 delete t_sr_wkfl.
                              assign
                                 total_lotserial_qty = lotserial_qty
                                 sr_site             = wosite
                                 sr_loc              = location
                                 sr_lotser           = lotserial
                                 sr_ref              = lotref
                                 sr_qty              = lotserial_qty.
                           end. /* ELSE DO */
                        end. /* ELSE DO */

                        for first t_pk_det
                           where  t_pk_det.t_pk_domain = global_domain
                           and    t_pk_user            = mfguser
                           and    t_pk_part            = part
                           and    t_pk_ref             = string(op)
                        no-lock:
                        end. /*FOR FIRST t_pk_det*/
                        if available t_pk_det and lotserial_qty <> 0
                        then do:
                           t_pk_qty  =  lotserial_qty. 
                           {gprun.i ""icedit2.p"" "
                              (input ""ISS-WO"",
                               input  wosite,
                               input location,
                               input t_pk_part,
                               input """",
                               input """",
                               input t_pk_qty,
                               input pt_um,
                               input """",
                               input ""test3"",
                               output rejected2)"
                           }
                           if (multi_entry = no and
                               rejected    = no)
                              or (multi_entry and
                                  l_update_sr_wkfl)
                           then
                              t_pk_stat = "".
                        end. /*IF AVAILABLE t_pk_det*/

                        pk_qty = total_lotserial_qty.
                        t_pk_qty  = pk_qty.
                        {&REISSLST-P-TAG8}
                        if lotserial_qty <> 0
                        then do:
                           {gprun.i ""reoptr1f.p""
                                    "(input pk_part,
                                      output yn)"}
                           if yn
                           then
                              undo, retry.
                        end. /* IF lotserial_qty <> 0 */
                     end. /* DO */
                     display
                        total_lotserial_qty @ lotserial_qty with frame d.
                     leave.
                  end. /* FRAME-D-LOOP */
               end. /* GET-PART */
            end. /* DO */
         end. /* SELECT-PART */
         repeat:
            yn = yes.
						if batchrun then yn = no.
            /* Identify context for QXtend */
            {gpcontxt.i
               &STACKFRAG = 'reisslst,rebkfl'
               &FRAME = 'yn' &CONTEXT = 'DISPITEM'}

            /* DISPLAY ITEMS BEING ISSUED */
            if not batchrun then do:
            {pxmsg.i &MSGNUM=636 &ERRORLEVEL=1
                     &CONFIRM=yn &CONFIRM-TYPE='LOGICAL'}
            end.

            /* Clear context for QXtend */
            {gpcontxt.i
               &STACKFRAG = 'reisslst,rebkfl'
               &FRAME = 'yn'}

            if yn = yes
            then do:

               hide frame d no-pause.
               form
                  with frame e down width 80
                  title color normal getFrameTitle("ISSUE_DATA_REVIEW",80).

               /* SET EXTERNAL LABELS */
               setFrameLabels(frame e:handle).

               for each pk_det
                  fields( pk_domain pk_loc pk_part pk_qty pk_reference pk_user)
                  where pk_det.pk_domain = global_domain and pk_user = mfguser
                  no-lock:

                  l_sr_lineid = "-" + string(pk_part,"x(18)") + pk_reference.

                  for each sr_wkfl
                     fields(sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                            sr_site sr_userid)
                     where sr_wkfl.sr_domain = global_domain
                     and   sr_userid = mfguser
                     and   sr_lineid = l_sr_lineid
                     and   sr_qty <> 0
                     no-lock
                     with frame e:

                     display
                        pk_part
                        sr_site
                        sr_loc
                        sr_lotser
                        sr_ref format "x(8)"
                        column-label "Ref"
                        sr_qty.
                     down.
                     {gpwait.i &INSIDELOOP=YES &FRAMENAME=e}
                  end. /* FOR EACH sr_wkfl */
               end. /* FOR EACH pk_det */
               view frame e.
               {gpwait.i &OUTSIDELOOP=YES}

            end. /* IF yn = yes */

            leave.

         end. /* REPEAT */

         do on endkey undo seta , leave seta:
            yn = yes.
            /*V8-*/
            /* IS ALL INFORMATION CORRECT? */
            if not batchrun  then do:
               {pxmsg.i &MSGNUM=12  &ERRORLEVEL=1
                        &CONFIRM=yn &CONFIRM-TYPE='LOGICAL'}
             end.
            /*V8+*/
            /*V8!       {mfgmsg10.i 12 1 yn}
            if yn = ?
            then
               undo seta, leave seta. */
         end. /* DO */

         if yn
         then do:

            /* ADDED A CALL TO icedit4.p AS ALL THE VALIDATIONS OF */
            /* icedit4.p WERE SKIPPED IF THE USER ACCEPTED THE     */
            /* DEFAULTS AND EXITED (F4) NOT PROCESSING THE         */
            /* INDIVIDUAL LINES.                                   */

            l_error = no.

            for each pk_det
               fields( pk_domain pk_loc pk_part pk_qty pk_reference pk_user)
               where pk_det.pk_domain = global_domain and  pk_user = mfguser
            no-lock:

               l_sr_lineid = "-" + string(pk_part,"x(18)") + pk_reference.

               for each sr_wkfl fields( sr_domain sr_userid sr_lineid sr_site
                                       sr_loc    sr_lotser sr_ref sr_qty)
                  where sr_wkfl.sr_domain = global_domain
                  and   sr_userid = pk_user
                  and   sr_lineid = l_sr_lineid
 /****                 and   sr_qty    <> 0.00           */	
 						      and   sr_qty    <> 0
               no-lock:

                  for first pt_mstr
                     fields( pt_domain pt_desc1 pt_desc2 pt_loc pt_lot_ser
                            pt_part  pt_um)
                     where pt_mstr.pt_domain = global_domain
                      and  pt_part = pk_part
                  no-lock:
                  end. /* FOR FIRST pt_mstr ... */

                  ptum = "".
                  if available(pt_mstr)
                  then
                     ptum = pt_um.

                  if (site <> sr_site)
                  then do:

                     /* CODE TO DEFAULT THE COMPONENT ITEM LOCATION */
                     /* AT WORK ORDER SITE                          */

                     l_loc = pt_loc.
                     if execname = "yyrebkfl.p"
                     then do:
                        for first wo_mstr
                           where  wo_domain = global_domain
                           and    wo_lot    = cumwo_lot
                        no-lock:
                           for first in_mstr
                              where  in_domain = global_domain
                              and    in_part   = wo_part
                              and    in_site   = wo_site
                           no-lock:

                              for first ptmstr
                                 where  ptmstr.pt_domain = global_domain
                                 and    ptmstr.pt_part   = wo_part
                                 and    ptmstr.pt_site   = wo_site
                              no-lock :
                              end. /* FOR FIRST ptmstr */
                           if available ptmstr
                           and in_loc = ""
                           then
                              l_loc = ptmstr.pt_loc.
                           else
                              l_loc = in_loc.
                           end. /* for first in_mstr  */
                        end. /* FOR FIRST wo_mstr */
                     end. /* IF execname = */

                     {gprun.i ""icedit4.p""
                        "(input ""ISS-WO"",
                          input site,
                          input sr_site,
                          input l_loc,
                          input sr_loc,
                          input trim(substring(sr_lineid,2,18)),
                          input sr_lotser,
                          input sr_ref,
                          input sr_qty,
                          input ptum,
                          input """",
                          input ""test4"",
                          output yn)"}
                     if yn
                     then do:
                        l_error = yes.
												if not batchrun then do:	
                        /* FOR ITEM/SITE/LOCATION: #/#/#/# */
                        {pxmsg.i &MSGNUM=4578
                                 &ERRORLEVEL=1
                                 &MSGARG1=trim(substring(sr_lineid,2,18))
                                 &MSGARG2=sr_site
                                 &MSGARG3=sr_loc
                                 &MSGARG4=sr_lotser}
                         end.

                     end. /* IF yn     */
                  end. /* IF (site <> sr_site) */
               end. /* FOR EACH sr_wkfl */
            end. /* FOR EACH pk_det */

            if l_error then
               undo seta, retry seta.

            for each pk_det
               fields( pk_domain pk_loc pk_part pk_qty pk_reference pk_user)
               where pk_det.pk_domain = global_domain and pk_user = mfguser
               no-lock:

               l_sr_lineid = "-" + string(pk_part,"x(18)") + pk_reference.

               for each sr_wkfl
                  fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                         sr_site sr_userid)
                  where sr_wkfl.sr_domain = global_domain
                  and   sr_userid = mfguser
                  and   sr_lineid = l_sr_lineid
                  and   sr_qty    <> 0
               no-lock:

                  for first pt_mstr
                     fields( pt_domain pt_desc1 pt_desc2 pt_loc pt_lot_ser
                     pt_part pt_um)
                     where pt_mstr.pt_domain = global_domain
                     and   pt_part = pk_part
                  no-lock:
                  end. /* FOR FIRST pt_mstr */

                  {gprun.i ""icedit2.p"" "(""ISS-WO"",
                                             sr_site,
                                             sr_loc,
                                             pk_part,
                                             sr_lotser,
                                             sr_ref,
                                             sr_qty,
                                             pt_um,
                                             input """",
                                             input ""test5"",
                                             output rejected)"
                     }
                  if rejected
                  then do:
                     /* UNABLE TO ISSUE OR RECEIVE FOR ITEM   */
                     if not batchrun then do:
                    		 {pxmsg.i &MSGNUM=161 &ERRORLEVEL=3 &MSGARG1=pk_part}
                     end.
                     next setd.
                  end. /* IF rejected */

               end. /* for each sr_wkfl */
            end. /* for eack pk_det */

            hide frame d.
            hide frame e.
            undo_stat = no.
            leave seta.

         end.

      end. /* SETD */

   end. /* DO */

end. /* REPEAT */

for each t_sr_wkfl
   exclusive-lock:

   delete t_sr_wkfl.

end. /* FOR EACH t_sr_wkfl */

hide frame d.
