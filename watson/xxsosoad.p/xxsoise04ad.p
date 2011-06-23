/* soise04.p - SALES ORDER BILL COMPONENT BACKFLUSH TRANSACTION              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.13.1.18 $                                                    */
/* REVISION: 7.0      LAST MODIFIED: 11/05/91   BY: pma *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 01/28/92   BY: pma *F104*               */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*               */
/* REVISION: 7.0      LAST MODIFIED: 05/08/92   BY: afs *F459*               */
/* REVISION: 7.0      LAST MODIFIED: 06/25/92   BY: sas *F595*               */
/* Revision: 7.3          Last edit: 09/27/93   By: jcd *G247*               */
/* REVISION: 7.3      LAST MODIFIED: 10/05/94   BY: pxd *FR90*               */
/* REVISION: 7.3      LAST MODIFIED: 01/14/95   BY: aep *G0C7*               */
/* REVISION: 8.5      LAST MODIFIED: 11/28/94   BY: taf *J038*               */
/* REVISION: 8.5      LAST MODIFIED: 05/23/95   BY: sxb *J04D*               */
/* REVISION: 7.4      LAST MODIFIED: 08/16/95   BY: DAH *G0C7*               */
/* REVISION: 8.5      LAST MODIFIED: 07/20/95   BY: taf *J053*               */
/* REVISION: 7.3      LAST MODIFIED: 11/02/95   BY: jym *F0TC*               */
/* REVISION: 7.3      LAST MODIFIED: 03/05/96   BY: ais *G1PS*               */
/* REVISION: 8.6      LAST MODIFIED: 10/08/96   BY: *K003* forrest mori      */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 08/25/97   BY: *H1DD* Ajit Deodhar      */
/* REVISION: 8.6      LAST MODIFIED: 11/06/97   BY: *K15N* Jim Williams      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Old ECO marker removed, but no ECO header exists *K1Q4*                   */
/* REVISION: 8.6E     LAST MODIFIED: 06/29/98   BY: *L034* Markus Barone     */
/* REVISION: 8.6E     LAST MODIFIED: 06/22/99   BY: *J3BX* Reetu Kapoor      */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Robin McCarthy    */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *N0CF* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb               */
/* REVISION: 9.1      LAST MODIFIED: 10/11/00   BY: *N0W8* Mudit Mehta       */
/* Revision: 1.13.1.9     BY: Kirti Desai    DATE: 04/04/01 ECO: *M14R*      */
/* Revision: 1.13.1.10    BY: Niranjan R.    DATE: 07/13/01 ECO: *P00L*      */
/* Revision: 1.13.1.11    BY: Raghuvir Goradia  DATE: 02/27/02 ECO: *M1VX*   */
/* Revision: 1.13.1.12    BY: Ellen Borden   DATE: 06/08/01 ECO: *P00G*      */
/* Revision: 1.13.1.13    BY: Jeff Wootton   DATE: 05/14/02  ECO: *P03G*      */
/* Revision: 1.13.1.15    BY: Manisha Sawant DATE: 09/23/02 ECO: *N1QH* */
/* Revision: 1.13.1.17    BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/* $Revision: 1.13.1.18 $   BY: Shoma Salgaonkar   DATE: 08/25/04 ECO: *Q0CJ* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{cxcustom.i "SOISE04.P"}

define input parameter sodnbr like sod_nbr.
define input parameter sodln like sod_line.

define shared variable sod_recno as recid.
define shared variable eff_date as date.
define shared variable accum_wip like tr_gl_amt.
define shared variable qty_iss_rcv like tr_qty_loc.
define shared variable wolot  like tr_lot.
define shared variable change_db like mfc_logical.

define new shared variable pt_recid as recid.
define new shared variable nbr like tr_nbr.
define new shared variable cr_acct like trgl_cr_acct.
define new shared variable cr_sub like trgl_cr_sub.
define new shared variable cr_cc like trgl_cr_cc.
define new shared variable cr_proj like trgl_cr_proj.
define new shared variable transtype as character format "x(7)".

define variable trqty like tr_qty_chg.
define variable wopart_wip_acct like pl_wip_acct.
define variable wopart_wip_sub like pl_wip_sub.
define variable wopart_wip_cc like pl_wip_cc.
define variable wopart_wip_proj like wo_proj.
define variable ref like glt_ref.
define variable qty as decimal.
define variable serial like tr_serial.
define variable loc like ld_loc.
define variable site like ld_site.
define variable lotqty like wod_qty_chg.
define variable yn like mfc_logical.
define variable i as integer.
define variable part like pt_part.
define variable dr_acct like sod_acct.
define variable dr_sub like sod_sub.
define variable dr_cc like sod_cc.
define variable wip_acct like sod_acct.
define variable wip_sub like sod_sub.
define variable wip_cc like sod_cc.
define variable sod_entity like si_entity.
define variable gl_amt like glt_amt.
define variable glcost like sct_cst_tot.
define variable gl_cost like sct_cst_tot.
define variable assay like tr_assay.
define variable grade like tr_grade.
define variable expire like tr_expire.
define variable trans-ok like mfc_logical.
define variable gl_tmp_amt as decimal no-undo.
define variable iss_trnbr like tr_trnbr no-undo.
define variable rct_trnbr like tr_trnbr no-undo.

/* SS - 20080812.1 - B */
DEF SHARED VAR v_loc LIKE tr_loc .
DEF SHARED VAR v_dn LIKE tr_loc .
DEF SHARED VAR v_bill LIKE so_bill.
DEF SHARED VAR v_ship LIKE so_ship.
/* SS - 20080812.1 - E */

/* SS - 20081226.1 - B */
DEFINE SHARED VAR v_flag_item AS LOGICAL .
/* SS - 20081226.1 - E */

{&SOISE04-P-TAG1}

for first clc_ctrl
      fields( clc_domain clc_lotlevel)
       where clc_ctrl.clc_domain = global_domain no-lock:
end. /* FOR FIRST CLC_CTRL */

if not available clc_ctrl then do:
   {gprun.i ""gpclccrt.p""}

   for first clc_ctrl
         fields( clc_domain clc_lotlevel)
          where clc_ctrl.clc_domain = global_domain no-lock:
   end. /* FOR FIRST CLC_CTRL */
end.

for first gl_ctrl
      fields( gl_domain gl_rnd_mthd gl_wip_acct gl_wip_cc gl_wip_sub)  where
      gl_ctrl.gl_domain = global_domain no-lock:
end. /* FOR FIRST GL_CTRL */

/* IF THE INVENTORY DB IS THE SAME AS THE CENTRAL DB LOOKUP */
/* SALES ORDER LINE BY recid FOR MORE EFFICIENT PROCESSING. */

if change_db then
   for first sod_det
      fields( sod_domain sod_line sod_nbr sod_part sod_project sod_site
      sod_um_conv)
       where sod_det.sod_domain = global_domain and  sod_nbr = sodnbr and
       sod_line = sodln no-lock:
   end. /* FOR FIRST SOD_DET */
else
   for first sod_det
      fields( sod_domain sod_line sod_nbr sod_part sod_project sod_site
      sod_um_conv)
      where recid(sod_det) = sod_recno no-lock:
   end.   /* FOR FIRST SOD_DET */

for first pt_mstr
   fields( pt_domain pt_abc pt_avg_int pt_cyc_int pt_loc pt_part pt_cfg_type
   pt_prod_line
          pt_rctpo_active pt_rctpo_status pt_rctwo_active
          pt_rctwo_status pt_shelflife pt_um)
    where pt_mstr.pt_domain = global_domain and  pt_part = sod_part no-lock:
end. /* FOR FIRST PT_MSTR */

for first si_mstr
   fields( si_domain si_cur_set si_entity si_gl_set si_site si_status)
    where si_mstr.si_domain = global_domain and  si_site = sod_site no-lock:
end. /* FOR FIRST SI_MSTR */

assign
   sod_entity  = si_entity
   qty_iss_rcv = 0
   pt_recid    = recid(pt_mstr).

if available pt_mstr then
   for first pl_mstr
      fields( pl_domain pl_inv_acct pl_inv_cc pl_inv_sub pl_prod_line
             pl_wip_acct pl_wip_cc pl_wip_sub)
       where pl_mstr.pl_domain = global_domain and  pl_prod_line = pt_prod_line
       no-lock:
   end. /* FOR FIRST PL_MSTR */
{gprun.i ""glactdft.p"" "(input ""WO_WIP_ACCT"",
                          input pt_prod_line,
                          input sod_site,
                          input """",
                          input """",
                          input yes,
                          output wopart_wip_acct,
                          output wopart_wip_sub,
                          output wopart_wip_cc)"}
assign
   wopart_wip_proj = sod_project
   nbr = sod_nbr + "." + string(sod_line).

/* RECEIPT TRANSACTIONS */
/* NOTE: THE END ITEM IS RECEIVED AT THE SOD SITE */
/* AND THEN TRANSFERRED TO THE SHIPPING SITE.     */
/* AS THE END ITEMS ARE ACTUALLY SHIPPED IN       */
/* PROGRAM SOSOISU3.P THEY ARE TRANSFERRED        */
/* BACK TO (AND SHIPPED FROM) THE SOD_SITE        */

part = sod_part.

for first pt_mstr
   fields( pt_domain pt_abc pt_avg_int pt_cyc_int pt_loc pt_part pt_cfg_type
   pt_prod_line
          pt_rctpo_active pt_rctpo_status pt_rctwo_active
          pt_rctwo_status pt_shelflife pt_um)
    where pt_mstr.pt_domain = global_domain and  pt_part = sod_part no-lock:
end. /* FOR FIRST PT_MSTR */

for each sr_wkfl no-lock  where sr_wkfl.sr_domain = global_domain and
sr_userid = mfguser
   and trim(sr_lineid) = trim(string(sod_line)):
   trqty = sr_qty * sod_um_conv.

   for first ld_det
      fields( ld_domain ld_assay ld_expire ld_grade ld_loc ld_lot ld_part
             ld_qty_all ld_qty_frz ld_qty_oh ld_ref ld_site
             ld_status)
       where ld_det.ld_domain = global_domain and  ld_site = sr_site   and
            ld_loc  = sr_loc    and
            ld_part = part      and
            ld_lot  = sr_lotser and
            ld_ref  = sr_ref no-lock:
   end. /* FOR FIRST LD_DET */

   if available ld_det then
      assign
         assay = ld_assay
         grade = ld_grade
         expire = ld_expire
         qty_iss_rcv = qty_iss_rcv + trqty.
   else
   if pt_shelflife <> 0 then
      expire = eff_date + pt_shelflife.

   /* Find the appropriate cost set */
   {gpsct06.i &part=pt_part &site=sod_site &type=""GL""}

   assign
      wip_acct = wopart_wip_acct
      wip_sub = wopart_wip_sub
      wip_cc = wopart_wip_cc
      transtype = "RCT-WO"
      glcost = sct_cst_tot
      gl_amt = trqty * glcost.

   /* ADD CALL TO GPICLT.P TO CREATE LOT_MSTR */

   /* COMPLIANCE CHECK IS NO LONGER DONE FOR KIT PARENT ITEMS */
   if  (clc_lotlevel <> 0)
   and (sr_lotser    <> "")
   and (pt_cfg_type  <> "2")
   then do:
      {gprun.i ""gpiclt.p"" "(input part,
                                       input sr_lotser,
                                       input """",
                                       input """",
                                       output trans-ok)"}
      if not trans-ok then do:
         {pxmsg.i &MSGNUM=2740 &ERRORLEVEL=4}
         /* CURRENT TRANSACTION REJECTED - */
         undo, next.         /* CONTINUE WITH NEXT TRANSACTION */
      end. /* IF NOT TRANS-OK */
   end. /* IF (CLC_LOTLEV <> 0) */

   /* trlot was changed to wolot in lotnumber             */
   /* changed &drproj and &crproj to have the same values */
   /* CHANGED &location FROM location TO if ... else ... */
   /* ADDED SECOND EXCHANGE RATE, TYPE, SEQUENCE */

   /* SS - 20081226.1 - B */
   IF v_flag_item = YES THEN DO:
      UNDO,NEXT .
   END.
   /* SS - 20081226.1 - E */

   {ictrans.i
      &addrid=""""
      &bdnstd=0
      &cracct=wip_acct
      &crsub=wip_sub
      &crcc=wip_cc
      &crproj=wopart_wip_proj
      &curr=""""
      &dracct="if available pld_det then pld_inv_acct
                     else pl_inv_acct"
      &drsub="if available pld_det then pld_inv_sub
                     else pl_inv_sub"
      &drcc="if available pld_det then pld_inv_cc
                     else pl_inv_cc"
      &drproj=wopart_wip_proj
      &effdate=eff_date
      &exrate=0
      &exrate2=0
      &exratetype=""""
      &exruseq=0
      &glamt=gl_amt
      &lbrstd=0
      &line=sod_line
      &location="(if sod_site <> sr_site then pt_loc else sr_loc)"
      &lotnumber=wolot
      &lotserial=sr_lotser
      &lotref=sr_ref
      &mtlstd=0
      &ordernbr=nbr
      &ovhstd=0
      &part=part
      &perfdate=?
      &price=glcost
      &quantityreq=0
      &quantityshort=0
      &quantity=trqty
      &revision=""""
      &rmks=""""
      &shiptype=""""
      &site=sod_site
      &slspsn1=""""
      &slspsn2=""""
      &sojob=sod_nbr
      &substd=0
      &transtype=""RCT-FAS""
      &msg=0
      &ref_site=tr_site
      }

   /* SS - 20081114.1 - B */
   ASSIGN
      tr_user1 = v_bill
      tr_user2 = v_ship
      tr_so_job = v_dn
      tr__dec01 = trqty
      tr__chr01 = sod_um
      .
   /* SS - 20081114.1 - E */

   accum_wip = accum_wip - gl_amt.
   /* Transfer parts if ship site doesn't match scheduled site */
   if sr_site <> sod_site then do:
      assign
         tr_assay = assay
         tr_grade = grade
         tr_expire = expire
         global_part = sod_part
         global_addr = "".

      {gprun.i ""icxfer.p"" "(wolot,
                              sr_lotser,
                              sr_ref,
                              sr_ref,
                              trqty,
                              nbr,
                              sod_nbr,
                              """",
                              wopart_wip_proj,
                              eff_date,
                              sod_site,
                              pt_loc,
                              sr_site,
                              sr_loc,
                              no,
                              """",
                              ?,
                              """",
                              0,
                              """",
                              output gl_cost,
                              output iss_trnbr,
                              output rct_trnbr,
                              input-output assay,
                              input-output grade,
                              input-output expire)"
         }
   end.
end.

/* CREATE WO VARIANCE POSTINGS TO GL */
do transaction on error undo, retry:
   {&SOISE04-P-TAG2}
   find qad_wkfl  where qad_wkfl.qad_domain = global_domain and  qad_key1 =
   mfguser
      and qad_key2 = sod_nbr + "." + string(sod_line)
      exclusive-lock no-error.
   {&SOISE04-P-TAG3}

   if not available qad_wkfl then do:
      create qad_wkfl. qad_wkfl.qad_domain = global_domain.
      assign
         qad_key1       = mfguser
         qad_key2       = sod_nbr + "." + string(sod_line)
         qad_charfld[1] = wopart_wip_acct
         qad_charfld[2] = wopart_wip_cc
         qad_charfld[4] = wopart_wip_sub
         qad_charfld[3] = sod_project.
   end.
   qad_decfld[1] = accum_wip.
   release qad_wkfl.
end.
