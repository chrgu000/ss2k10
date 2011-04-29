/* reisslst.p - REPETITIVE   SUBPROGRAM TO MODIFY COMPONENT PART ISSUE LIST   */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.9.1.25 $                                                      */
/*V8:ConvertMode=Maintenance                                                  */
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
/* $Revision: 1.9.1.25 $ BY: Priyank Khandare        DATE: 05/13/05 ECO: *P3L6* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

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

define input parameter woop      like wr_op .  /*xp001*/
define input parameter wocomp    like pt_part .  /*xp001*/
define input parameter v_qty    as decimal.   /*xp001*/


define output parameter undo_stat like mfc_logical no-undo.

define  shared var lot_from  like xkb_lot .  /*xp001*/
define  shared var ref_from  like xkb_ref . /*xp001*/



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
define variable op             like wod_op.

define variable l_error          like mfc_logical no-undo.
define variable l_sr_site        like sr_site     no-undo.
define variable l_delete_sr_wkfl like mfc_logical no-undo.
define variable l_update_sr_wkfl like mfc_logical no-undo.
define variable l_sr_lineid      like sr_lineid   no-undo.
define variable lotnext          like wo_lot_next.
define variable lotprcpt         like wo_lot_rcpt no-undo.
{&REISSLST-P-TAG1}

/* TEMP-TABLE t_sr_wkfl STORES THE LIST OF DEFAULT sr_wkfl      */
/* RECORDS (NOT MODIFIED BY THE USER)                           */
/* t_sr_wkfl RECORD IS DELETED WHEN THE DEFAULT sr_wkfl RECORD  */
/* IS MODIFIED. DURING MULTI-ENTRY, IF t_sr_wkfl RECORD EXISTS, */
/* DELETE DEFAULT sr_wkfl RECORD TO AVOID MANUAL DELETION.      */

define temp-table t_sr_wkfl no-undo
   field t_sr_lineid like sr_lineid
   index t_sr_lineid is unique t_sr_lineid.

define buffer ptmstr for pt_mstr.

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

/* INITIALISE TEMP-TABLE t_sr_wkfl */
for each t_sr_wkfl
   exclusive-lock:

   delete t_sr_wkfl.

end. /* FOR EACH t_sr_wkfl */

assign
   undo_stat = yes
   {&REISSLST-P-TAG4}
   site      = wosite
   iss_loc   = "".

if can-find (loc_mstr
    where loc_mstr.loc_domain = global_domain and  loc_loc  = wkctr
   and   loc_site = wosite)
then
   iss_loc = wkctr.

for first clc_ctrl
   fields( clc_domain clc_comp_issue)
    where clc_ctrl.clc_domain = global_domain no-lock:
end. /* FOR FIRST clc_ctrl */

if not available clc_ctrl
then do:
   {gprun.i ""gpclccrt.p""}

   for first clc_ctrl
      fields( clc_domain clc_comp_issue)
       where clc_ctrl.clc_domain = global_domain no-lock:
   end. /* FOR FIRST clc_ctrl */

end. /* IF NOT AVAILABLE clc_ctrl */

do transaction:
   for each sr_wkfl
       where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
      and   sr_lineid begins "-"
   exclusive-lock:
         delete sr_wkfl.
   end. /* FOR EACH sr_wkfl */

   for each pk_det
      fields( pk_domain pk_loc pk_part pk_qty pk_reference pk_user)
       where pk_det.pk_domain = global_domain and  pk_user = mfguser
       and /*xp001*/  pk_det.pk_part = wocomp
      no-lock:

      

      l_sr_lineid = "-" + string(pk_part,"x(18)") + pk_reference.

      find sr_wkfl
          where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
         and   sr_lineid = l_sr_lineid
         and   sr_site   = wosite
         and   sr_loc    = pk_loc
         exclusive-lock no-error.

      for first ptmstr
         fields( pt_domain pt_desc1 pt_desc2 pt_loc pt_lot_ser pt_part pt_um)
          where ptmstr.pt_domain = global_domain and  ptmstr.pt_part = pk_part
         no-lock:
      end. /* FOR FIRST ptmstr */
/*  message wosite pk_loc ptmstr.pt_part pk_qty + if available sr_wkfl then sr_qty else 0  ptmstr.pt_um view-as alert-box . */
      {gprun.i ""icedit2.p"" "(input ""ISS-WO"",
                               input wosite,
                               input pk_loc,
                               input ptmstr.pt_part,
                               input """",
                               input """",
                               input pk_qty + if available sr_wkfl
                                              then
                                                 sr_qty
                                              else
                                                 0,
                               input ptmstr.pt_um,
                               input """",
                               input """",
                               output rejected)"
      }

      if rejected
      then do on endkey undo , retry:
         /* UNABLE TO ISSUE OR RECEIVE FOR ITEM */
/*          {pxmsg.i &MSGNUM=161 &ERRORLEVEL=2 */
/*                   &MSGARG1=ptmstr.pt_part}  */
             run xxmsg01.p (input 161 , input "a" + ptmstr.pt_part  ,input yes )  .
         /* PAUSE IS INTRODUCED TO AVOID USER INTERVENTION */
         /* AFTER DISPLAY OF MESSAGE                       */
/*          pause . */
      end. /* IF rejected */

      /* DEFAULT sr_wkfl RECORD IS STORED IN TEMP-TABLE t_sr_wkfl */
      if not available sr_wkfl
      then do:

         create sr_wkfl. sr_wkfl.sr_domain = global_domain.
         create t_sr_wkfl.

         assign
            sr_userid   = mfguser
            sr_lineid   = l_sr_lineid
            sr_site     = wosite
            sr_loc      = pk_loc
            sr_lotser   = lot_from   /*xp001*/
            sr_ref      = ref_from   /*xp001*/
            t_sr_lineid = l_sr_lineid.

         if recid(sr_wkfl) = -1
         then
            .

      end. /* IF NOT AVAILABLE sr_wkfl */

      if available sr_wkfl
      then
         sr_qty = sr_qty + pk_qty.

   end. /* FOR EACH pk_det */
end. /* DO TRANSACTION */

seta:
do transaction on error undo, leave :

               clear frame d.

               assign part = wocomp 
                      op   = woop 
                      sub_comp    = no
                      multi_entry = no.


               for first pt_mstr
                  fields( pt_domain pt_desc1 pt_desc2 pt_loc pt_lot_ser pt_part pt_um)
                   where pt_mstr.pt_domain = global_domain and  pt_part = part
                  no-lock:
               end. /* FOR FIRST pt_mstr */

               trans_um = "".
               if available pt_mstr
               then trans_um = pt_um.
               trans_conv = 1.

               /* CONDITION ADDED TO IMPROVE PERFORMANCE IN DESKTOP 2 */
               if not {gpiswrap.i} then input clear.

/* wr_route */
              for first wr_route
                 fields( wr_domain wr_lot wr_op)
                  where wr_route.wr_domain = global_domain and  wr_lot = cumwo_lot and   wr_op  = op
                 no-lock:
              end. /* FOR FIRST wr_route */

              if not available wr_route then do:
                 /* UNABLE TO ISSUE OR RECEIVE FOR ITEM */
                 /* {pxmsg.i &MSGNUM=106 &ERRORLEVEL=3} */
                    run xxmsg01.p (input 106 , input ""  ,input yes )  .
                 leave .
              end. /* IF NOT AVAILABLE wr_route */


/* pk_det */
             find first pk_det
                 where pk_det.pk_domain = global_domain and  pk_user = mfguser
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
                      /* {pxmsg.i &MSGNUM=547 &ERRORLEVEL=2}*/
                         run xxmsg01.p (input 547 , input ""  ,input yes )  .
                   end. /* IF clc_comp_issue */
                   else do:

                      /* COMPLIANCE MODULE RESTRICTS COMP ISSUE   */
                      /* ITEM DOES NOT EXIST ON THIS BILL OF MATL */
                        /* {pxmsg.i &MSGNUM=547 &ERRORLEVEL=3} */
                            run xxmsg01.p (input 547 , input ""  ,input yes )  .
                              undo seta ,leave seta .
                   end. /* ELSE DO */
                end. /* IF clc_active */
                else
                   /* ITEM DOES NOT EXIST ON THIS BILL OF MATL */
                    /* {pxmsg.i &MSGNUM=547 &ERRORLEVEL=2}*/
                         run xxmsg01.p (input 547 , input ""  ,input yes )  .

                create pk_det. pk_det.pk_domain = global_domain.
                assign
                   pk_user      = mfguser
                   pk_part      = part
                   pk_reference = string(op).

                if recid(pk_det) = -1 then .
             end. /* IF NOT AVAILABLE pk_det */

             for first pt_mstr
                fields( pt_domain pt_desc1 pt_desc2 pt_loc pt_lot_ser
                       pt_part pt_um)
                 where pt_mstr.pt_domain = global_domain and  pt_part = part
                no-lock:
             end. /* FOR FIRST pt_mstr */

             if available pt_mstr then  do:
                if new pk_det
                then
                   pk_loc = pt_loc.
                if iss_loc <> ""
                then
                   pk_loc = iss_loc.
                else
                   pk_loc = pt_loc.

/*                 display           */
/*                    pt_part @ part */
/*                    pt_um          */
/*                    pt_desc1       */
/*                    pt_desc2       */
/*                 with frame d.     */

                ptum = pt_um.
             end. 

             assign
                qopen             = pk_qty
                lotserial_control = "".

             if available pt_mstr
             then
                lotserial_control = pt_lot_ser.

             assign
                location      = ""
                lotserial     = lot_from   /*xp001*/
                lotref        = ref_from   /*xp001*/
                lotserial_qty = pk_qty
                cline         = "-" + string(pk_part,"x(18)")
                                    + pk_reference
                global_part   = pk_part.


             for first sr_wkfl
                fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty
                sr_ref sr_site sr_userid)
                 where sr_wkfl.sr_domain = global_domain and  sr_userid
                 = mfguser
                and   sr_lineid = cline
                no-lock:
             end. /* FOR FIRST sr_wkfl */

             if available sr_wkfl
             then do:

                for first sr_wkfl
                   fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty
                   sr_ref sr_site sr_userid)
                    where sr_wkfl.sr_domain = global_domain and sr_userid = mfguser
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

              pk_recno = recid(pk_det).



/*                         update                              */
/*                            lotserial_qty                    */
/*                            sub_comp                         */
/*                            wosite                           */
/*                            location                         */
/*                            lotserial                        */
/*                            lotref                           */
/*                            multi_entry                      */
/*                            {&REISSLST-P-TAG5}               */
/*                         with frame d                        */
/*                         editing:                            */
/*                            assign                           */
/*                               global_site = input wosite    */
/*                               global_loc  = input location  */
/*                               global_lot  = input lotserial */
/*                               ststatus    = stline[3].      */
/*                            status input ststatus.           */
/*                            readkey.                         */
/*                            apply lastkey.                   */
/*                         end. /* UPDATE */                   */

                  assign lotserial_qty  = v_qty 
                         global_site = wosite
                         global_loc  = location
                         global_lot  = lotserial  .

                        multi_entry = no .
                        total_lotserial_qty = pk_qty.

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
                                                  input """",
                                                  output rejected)"
                             }
                          if rejected then do :
                              pause .
                              undo seta ,leave seta .
                          end.
                       end. /* IF lotserial_qty */

                           
                           
/* SR_wkfl */
                       find first sr_wkfl
                           where sr_wkfl.sr_domain = global_domain and
                           sr_userid = mfguser
                          and   sr_lineid = cline
                          exclusive-lock no-error.

                       if lotserial_qty = 0 then do:

                          if available sr_wkfl then
                          assign total_lotserial_qty = total_lotserial_qty - sr_qty
                                 sr_qty              = 0.

                       end. /* IF lotserial_qty = 0 */
                       else do:
                          if not available sr_wkfl
                          then do:
                                 create sr_wkfl. 
                                 sr_wkfl.sr_domain = global_domain.
                                 assign
                                    sr_userid = mfguser
                                    sr_lineid = cline.

                                 if recid(sr_wkfl) = -1 then .
                          end. /* IF NOT AVAILABLE sr_wkfl */

                          /* DELETE TEMP-TABLE RECORD TO */
                          /* INDICATE DEFAULT CREATED    */
                          /* RECORD IS MODIFIED          */
                          find first t_sr_wkfl where t_sr_lineid = cline exclusive-lock no-error.
                          if available t_sr_wkfl then delete t_sr_wkfl.

                          assign
                             total_lotserial_qty = lotserial_qty
                             sr_site             = wosite
                             sr_loc              = location
                             sr_lotser           = lotserial
                             sr_ref              = lotref
                             sr_qty              = lotserial_qty.
                       end. /* ELSE DO */



                        pk_qty = total_lotserial_qty.
                        {&REISSLST-P-TAG8}
                        if lotserial_qty <> 0
                        then do:
                           {gprun.i ""reoptr1f.p""
                                    "(input pk_part,
                                      output yn)"}
                           if yn then
                              undo seta , leave seta .
                        end. /* IF lotserial_qty <> 0 */



/*                hide frame d no-pause.                                                                     */
/*                                                                                                           */
/*                form with frame e down width 80  title color normal getFrameTitle("ISSUE_DATA_REVIEW",80). */
/*                setFrameLabels(frame e:handle).                                                            */
/*                                                                                                           */
/*                for each pk_det                                                                            */
/*                   fields( pk_domain pk_loc pk_part pk_qty pk_reference pk_user)                           */
/*                    where pk_det.pk_domain = global_domain and  pk_user = mfguser                          */
/*                   no-lock:                                                                                */
/*                                                                                                           */
/*                   l_sr_lineid = "-" + string(pk_part,"x(18)") + pk_reference.                             */
/*                                                                                                           */
/*                   for each sr_wkfl                                                                        */
/*                      fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref                           */
/*                             sr_site sr_userid)                                                            */
/*                       where sr_wkfl.sr_domain = global_domain and  sr_userid =                            */
/*                       mfguser                                                                             */
/*                      and   sr_lineid = l_sr_lineid                                                        */
/*                      and   sr_qty <> 0                                                                    */
/*                      no-lock                                                                              */
/*                      with frame e:                                                                        */
/*                                                                                                           */
/*                      display                                                                              */
/*                         pk_part                                                                           */
/*                         sr_site                                                                           */
/*                         sr_loc                                                                            */
/*                         sr_lotser                                                                         */
/*                         sr_ref format "x(8)"                                                              */
/*                         column-label "Ref"                                                                */
/*                         sr_qty.                                                                           */
/*                      down.                                                                                */
/*                   end. /* FOR EACH sr_wkfl */                                                             */
/*                end. /* FOR EACH pk_det */                                                                 */
/*                view frame e.                                                                              */



/*          do on endkey undo seta , leave seta:             */
/*             yn = yes.                                     */
/*             /* IS ALL INFORMATION CORRECT? */             */
/*             {pxmsg.i &MSGNUM=12  &ERRORLEVEL=1            */
/*                      &CONFIRM=yn &CONFIRM-TYPE='LOGICAL'} */
/*          end. /* DO */                                    */
/*          if yn then do:                                   */

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

               for each sr_wkfl fields( sr_domain sr_userid sr_lineid sr_site sr_loc sr_lotser sr_ref sr_qty)
                   where sr_wkfl.sr_domain = global_domain and  sr_userid = pk_user
                  and   sr_lineid = l_sr_lineid
                  and   sr_qty    <> 0.00
               no-lock:

                  for first pt_mstr
                     fields( pt_domain pt_desc1 pt_desc2 pt_loc pt_lot_ser
                            pt_part  pt_um)
                      where pt_mstr.pt_domain = global_domain and  pt_part =
                      pk_part
                  no-lock:
                  end. /* FOR FIRST pt_mstr ... */

                  ptum = "".
                  if available(pt_mstr)
                  then
                     ptum = pt_um.

                  if (site <> sr_site)
                  then do:
                     {gprun.i ""icedit4.p""
                        "(input ""ISS-WO"",
                          input site,
                          input sr_site,
                          input pt_loc,
                          input sr_loc,
                          input trim(substring(sr_lineid,2,18)),
                          input sr_lotser,
                          input sr_ref,
                          input sr_qty,
                          input ptum,
                          input """",
                          input """",
                          output yn)"}

                     if yn
                     then do:
                        l_error = yes.


                         run xxmsg01.p (input 4578 , input trim(substring(sr_lineid,2,18))  ,input yes )  .
                        /* FOR ITEM/SITE/LOCATION: #/#/#/# */
                        /* {pxmsg.i &MSGNUM=4578                             */
                        /*          &ERRORLEVEL=1                            */
                        /*          &MSGARG1=trim(substring(sr_lineid,2,18)) */
                        /*          &MSGARG2=sr_site                         */
                        /*          &MSGARG3=sr_loc                          */
                        /*          &MSGARG4=sr_lotser}                      */

                     end. /* IF yn     */
                  end. /* IF (site <> sr_site) */
               end. /* FOR EACH sr_wkfl */
            end. /* FOR EACH pk_det */

            if l_error then
               undo seta, leave seta
                .

            for each pk_det
               fields( pk_domain pk_loc pk_part pk_qty pk_reference pk_user)
                where pk_det.pk_domain = global_domain and  pk_user = mfguser
                      and   pk_part      = part
                      and   pk_reference = string(op)
               no-lock:

                   l_sr_lineid = "-" + string(pk_part,"x(18)") + pk_reference.
    
                   for each sr_wkfl
                      fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                             sr_site sr_userid)
                       where sr_wkfl.sr_domain = global_domain and  sr_userid =
                       mfguser
                      and   sr_lineid = l_sr_lineid
                      and   sr_qty    <> 0
                      no-lock:
    
                      for first pt_mstr
                         fields( pt_domain pt_desc1 pt_desc2 pt_loc pt_lot_ser
                         pt_part pt_um)
                          where pt_mstr.pt_domain = global_domain and  pt_part =
                          pk_part
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
                                                 input """",
                                                 output rejected)"
                         }
    
                       if rejected then do:
                             /* UNABLE TO ISSUE OR RECEIVE FOR ITEM   */
                             /* {pxmsg.i &MSGNUM=161 &ERRORLEVEL=3 &MSGARG1=pk_part} */
                             run xxmsg01.p (input 161 , input "b:" + pk_part  ,input yes )  .
                             undo seta , leave seta .
                       end. /* IF rejected */
    
                   end. /* for each sr_wkfl */
            end. /* for eack pk_det */

            undo_stat = no.

/*          end. /* IF yn */ */

end. /* seta */  

for each t_sr_wkfl exclusive-lock:
   delete t_sr_wkfl.
end. /* FOR EACH t_sr_wkfl */

hide frame d.
