/* GUI CONVERTED from iclotr.p (converter v1.76) Wed Jan 22 00:56:23 2003 */
/* iclotr.p - LOCATION TRANSFER UN ISSUE / UN RECEIPT                         */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.35 $                                         */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 1.0      LAST MODIFIED: 06/11/86   BY: PML                       */
/* REVISION: 6.0      LAST MODIFIED: 03/14/90   BY: emb *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 04/03/90   BY: WUG *D015*                */
/* REVISION: 6.0      LAST MODIFIED: 05/03/90   BY: WUG *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 10/31/90   BY: WUG *D156*                */
/* REVISION: 6.0      LAST MODIFIED: 03/14/91   BY: WUG *D472*                */
/* REVISION: 6.0      LAST MODIFIED: 04/19/91   BY: WUG *D547*                */
/* REVISION: 6.0      LAST MODIFIED: 07/15/91   BY: WUG *D770*                */
/* REVISION: 6.0      LAST MODIFIED: 08/01/91   BY: emb *D800*                */
/* REVISION: 7.0      LAST MODIFIED: 10/18/91   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   BY: WUG *D887*                */
/* REVISION: 7.0      LAST MODIFIED: 01/25/92   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 02/10/92   BY: pma *F190*                */
/* REVISION: 7.0      LAST MODIFIED: 06/26/92   BY: pma *F701*                */
/* REVISION: 7.0      LAST MODIFIED: 09/14/92   BY: pma *F895*                */
/* REVISION: 7.0      LAST MODIFIED: 09/28/92   BY: pma *G102*                */
/* Revision: 7.3        Last edit: 09/27/93     By: jcd *G247*                */
/* REVISION: 7.3      LAST MODIFIED: 11/16/92   BY: pma *G319*                */
/* REVISION: 7.3      LAST MODIFIED: 06/16/93   BY: pma *GC07*                */
/* REVISION: 7.3      LAST MODIFIED: 09/09/93   BY: ram *GE98*                */
/* REVISION: 7.3      LAST MODIFIED: 09/09/93   BY: pxd *GH52*                */
/* REVISION: 7.3      LAST MODIFIED: 02/15/94   BY: ais *FM01*                */
/* REVISION: 7.3      LAST MODIFIED: 05/20/94   BY: ais *FO32*                */
/* REVISION: 7.3      LAST MODIFIED: 07/15/94   BY: pxd *GK75*                */
/* REVISION: 7.3      LAST MODIFIED: 09/16/94   BY: dpm *FR46*                */
/* REVISION: 8.5      LAST MODIFIED: 10/05/94   BY: mwd *J034*                */
/* REVISION: 7.3      LAST MODIFIED: 10/07/94   BY: qzl *FS18*                */
/* REVISION: 7.3      LAST MODIFIED: 11/03/94   BY: pxd *FT37*                */
/* REVISION: 8.5      LAST MODIFIED: 11/16/94   BY: ktn *J038*                */
/* REVISION: 7.3      LAST MODIFIED: 01/06/95   BY: ais *F0D2*                */
/* REVISION: 7.3      LAST MODIFIED: 01/18/95   BY: ais *F0FH*                */
/* REVISION: 7.3      LAST MODIFIED: 03/20/95   BY: pxd *F0NL*                */
/* REVISION: 7.2      LAST MODIFIED: 05/16/95   BY: qzl *F0RN*                */
/* REVISION: 7.3      LAST MODIFIED: 07/26/95   BY: dzs *G0SQ*                */
/* REVISION: 7.3      LAST MODIFIED: 11/01/95   BY: ais *G0V9*                */
/* REVISION: 7.4      LAST MODIFIED: 11/13/95   BY: jym *G1D2*                */
/* REVISION: 7.4      LAST MODIFIED: 12/07/95   BY: jym *G1FP*                */
/* REVISION: 8.5      LAST MODIFIED: 07/11/96   BY: *G1ZM* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 11/05/96   BY: *J17R* Murli Shastri      */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 04/18/97   BY: *H0S4* Russ Witt          */
/* REVISION: 8.6      LAST MODIFIED: 07/09/97   BY: *J1W2* Manmohan K.Pardesi */
/* REVISION: 8.6      LAST MODIFIED: 11/17/97   BY: *H1GR* Viji Pakala        */
/* REVISION: 7.4      LAST MODIFIED: 12/22/97   BY: *H1HN* Jean Miller        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/19/98   BY: *J2JV* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 08/17/98   BY: *L062* Steve Nugent       */
/* REVISION: 8.6E     LAST MODIFIED: 09/02/98   BY: *J2YJ* Felcy D'Souza      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Vijaya Pakala      */
/* REVISION: 9.1      LAST MODIFIED: 06/29/99   BY: *J3HJ* G.Latha            */
/* REVISION: 9.1      LAST MODIFIED: 10/15/99   BY: *J3KH* G.Latha            */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Steve Nugent       */
/* REVISION: 9.1      LAST MODIFIED: 07/06/00   BY: *L11B* Rajesh Thomas      */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb                */
/* REVISION: 9.1      LAST MODIFIED: 09/01/00   BY: *N0R0* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 10/19/00   BY: *N0W6* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 11/29/01   BY: *N16N* Ed van de Gevel    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.31        BY: Ellen Borden        DATE: 05/30/01  ECO: *P00G*  */
/* Revision: 1.33        BY: Jean Miller         DATE: 04/06/02  ECO: *P055*  */
/* Revision: 1.34        BY: Jeff Wootton        DATE: 05/14/02  ECO: *P03G*  */
/* $Revision: 1.35 $     BY: Subramanian Iyer   DATE: 01/21/03  ECO: *N24M*  */

/*****************************************************************************/
/* THIS PROGRAM WAS CLONED TO kblotr.p 05/14/02, REMOVING UI.      */
/* CHANGES TO THIS PROGRAM MAY ALSO NEED TO BE APPLIED TO kblotr.p */
/*****************************************************************************/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* Last Modified: hou        2006.03.10                           *H01*       */

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
{cxcustom.i "ICLOTR.P"}
{&ICLOTR-P-TAG1}
/*lb01*/
define input PARAMETER rdcnbr like tr_nbr.
define input PARAMETER rdcpart like pt_part.
define input PARAMETER rdceffdate as date.
define input PARAMETER rdcqty like pod_qty_chg.


define input PARAMETER rdcsite like pt_site.
define input PARAMETER rdcloc like pt_loc.
define input PARAMETER rdcdsite like pt_site.
define input PARAMETER rdcdloc like pt_loc.



define output parameter rdcrcvqty like pod_qty_chg.

define new shared variable lotserial like sr_lotser no-undo.
define new shared variable lotserial_qty like sr_qty no-undo.
define new shared variable nbr like tr_nbr label "Order" no-undo.
define new shared variable so_job like tr_so_job no-undo.
define new shared variable rmks like tr_rmks no-undo.
define new shared variable transtype as character format "x(7)" initial "ISS-TR".
define new shared variable from_nettable like mfc_logical.
define new shared variable to_nettable like mfc_logical.
define new shared variable null_ch as character initial "".
define new shared variable old_mrpflag like pt_mrp.
define new shared variable eff_date like tr_effdate.
define new shared variable intermediate_acct like trgl_dr_acct.
define new shared variable intermediate_sub like trgl_dr_sub.
define new shared variable intermediate_cc like trgl_dr_cc.
define new shared variable from_expire like ld_expire.
define new shared variable from_date like ld_date.
define new shared variable site_from like pt_site no-undo.
define new shared variable loc_from like pt_loc no-undo.
define new shared variable lotser_from like sr_lotser no-undo.
define new shared variable lotref_from like ld_ref no-undo.
define new shared variable status_from like ld_status no-undo.
define new shared variable site_to like pt_site no-undo.
define new shared variable loc_to like pt_loc no-undo.
define new shared variable lotser_to like sr_lotser no-undo.
define new shared variable lotref_to like ld_ref no-undo.
define new shared variable h_wiplottrace_procs as handle no-undo.
define new shared variable h_wiplottrace_funcs as handle no-undo.

define shared variable trtype as character.

define variable glcost like sct_cst_tot.
define variable undo-input like mfc_logical.
define variable yn like mfc_logical.
define variable assay like tr_assay.
define variable grade like tr_grade.
define variable expire like tr_expire.
define variable ld_recid as recid.
define variable v_abs_recid as   recid           no-undo.
define variable v_shipnbr   like tr_ship_id      no-undo.
define variable v_shipdate  like tr_ship_date    no-undo.
define variable v_invmov    like tr_ship_inv_mov no-undo.
define variable ld_recid_from as recid no-undo.
define variable lot_control like clc_lotlevel no-undo.
define variable errmsg as integer no-undo.
define variable lot_found like mfc_logical no-undo.
define variable mesg_desc as character no-undo.
define variable ve_recid as recid no-undo.
{&ICLOTR-P-TAG2}
define variable part like pt_part no-undo.
define variable trans_nbr like tr_trnbr no-undo.
define variable from-label as character no-undo.
define variable to-label as character no-undo.

define buffer lddet for ld_det.
define buffer lddet1 for ld_det.


{wlfnc.i} /* FUNCTION FORWARD DECLARATIONS */

if is_wiplottrace_enabled() then do:
   {gprunmo.i &program=""wlpl.p"" &module="AWT"
      &persistent="""persistent set h_wiplottrace_procs"""}
   {gprunmo.i &program=""wlfl.p"" &module="AWT"
      &persistent="""persistent set h_wiplottrace_funcs"""}
end.

define variable iss_trnbr like tr_trnbr no-undo.
define variable rct_trnbr like tr_trnbr no-undo.

/* CONSIGNMENT VARIABLES. */
{socnvars.i}

{gpglefdf.i}

/* SHARED TEMP TABLES */
{icshmtdf.i "new" }

/* REPLACED pt_part USING LOCAL VARIABLE part TO TRIGGER */
/* DATABASE VALIDATION                                   */
{&ICLOTR-P-TAG3}

from-label = getTermLabelRt("FROM",8).
to-label   = getTermLabelRt("TO",8).


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
part             colon 22
   pt_desc1         colon 22
   pt_desc2         colon 51 no-label
   pt_um            colon 22
   skip(1)
   lotserial_qty    colon 22
   eff_date         colon 55
   nbr              colon 22
   so_job           colon 22
   rmks             colon 22
   skip(1)
   from-label       to 27    no-label
   to-label         to 58    no-label
   site_from        colon 22     site_to          colon 55
   loc_from         colon 22     loc_to           colon 55
   lotser_from      colon 22     lotser_to        colon 55
   lotref_from      colon 22     lotref_to        colon 55
   status_from      colon 22     lddet.ld_status  colon 55
 SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


{&ICLOTR-P-TAG4}

setFrameLabels(frame a:handle). 

/* DISPLAY */

do transaction:
   {gprun.i ""gplotwdl.p""}
   {&ICLOTR-P-TAG5}

   assign
      nbr = rdcnbr
      so_job = ""
      rmks = ""
		lotserial_qty = rdcqty
       eff_date = rdceffdate
      .

	part = rdcpart.  /*lb01*/
   
   find first pt_mstr no-lock where pt_part = part no-error.
   if not available pt_mstr then leave.

   site_from = rdcsite.
   loc_from = rdcloc.

   old_mrpflag = pt_mrp.

   /* SET GLOBAL PART VARIABLE */
   global_part = pt_part.

    find si_mstr where si_site = site_from no-lock no-error.
    if not available si_mstr then do:
       {pxmsg.i &MSGNUM=708  &MSGARG1 = ""-Item:"" &MSGARG2=part &ERRORLEVEL=3}  /* SITE DOES NOT EXIST */
/*lb01             next-prompt site_from with frame a.
       undo from-loop, retry from-loop. */
       undo, return.
    end.

    /* Check Site Security */
    {gprun.i ""gpsiver.p""
       "(input si_site, input recid(si_mstr), output return_int)"}

    if return_int = 0 then do:
       {pxmsg.i &MSGNUM=725 &MSGARG1 = ""-Item:"" &MSGARG2=part &ERRORLEVEL=3}    /* USER DOES NOT HAVE */
       /* ACCESS TO THIS SITE*/
/*               next-prompt site_from with frame a.
       undo from-loop, retry from-loop.*/
       undo,return.
    end.

    /* OPEN PERIOD VALIDATION FOR THE ENTITY OF FROM SITE*/
    {xkgpglef02.i &module = ""IC""
       &entity = si_entity
       &date   = eff_date  /* lb01
       &prompt = "site_from" 
       &frame  = "a"
       &loop   = "from-loop"*/ }
        
    assign
       site_to   = rdcdsite
       loc_to    = rdcdloc
       lotser_to = ""
       lotref_to = "".

    find ld_det where ld_det.ld_part = pt_part
       and ld_det.ld_site = site_from
       and ld_det.ld_loc = loc_from
       and ld_det.ld_lot = lotser_from
       and ld_det.ld_ref = lotref_from
    no-lock no-error.

    if not available ld_det then do:

       find si_mstr where si_site = site_from no-lock no-error.
       find loc_mstr where loc_site = site_from
          and loc_loc = loc_from no-lock no-error.

       if not available si_mstr then do:
          /* Invalid Site */
          {pxmsg.i &MSGNUM=708  &MSGARG1 = ""-Item:"" &MSGARG2=part &ERRORLEVEL=3}
       /*   undo from-loop, retry from-loop. lb01 */
       		undo,return.
       end.

       if not available loc_mstr then do:
          if not si_auto_loc then do:
             /* Location/lot/item/serial does not exist */
             {pxmsg.i &MSGNUM=305  &MSGARG1 = ""-Item:"" &MSGARG2=part &ERRORLEVEL=3}
             /*next-prompt loc_from. lb01
             if not batchrun then
                undo from-loop, retry from-loop.
             else
                undo from-loop, leave transloop.*/
                undo, return.
          end.
          else do:
             find is_mstr where is_status = si_status
             no-lock no-error.
             if available is_mstr and is_overissue then do:
                create loc_mstr.
                assign
                   loc_site = si_site
                   loc_loc = loc_from
                   loc_date = today
                   loc_perm = no
                   loc_status = si_status.
             end.
             else do:
                /* QUANTITY AVAILABLE IN SITE LOCATION FOR LOT/SERIAL */
                {pxmsg.i &MSGNUM=208 &MSGARG1 = ""-Item:"" &MSGARG2=part  &ERRORLEVEL=3 &MSGARG1=0}
              /*  undo xferloop, retry xferloop. lb01*/
              	undo,return.
             end.
          end.
       end. /* if not available loc_mstr */


       find is_mstr where is_status = loc_status
       no-lock no-error.

       if available is_mstr and is_overissue and
          ((pt_lot_ser <> "" and lotser_from <> "") or pt_lot_ser = "" )
       then do:
              create ld_det.
              assign
                 ld_det.ld_site = site_from
                 ld_det.ld_loc = loc_from
                 ld_det.ld_part = pt_part
                 ld_det.ld_lot = lotser_from
                 ld_det.ld_ref = lotref_from
                 ld_det.ld_status = loc_status
                 status_from = loc_status.
       end.
       else do:
              /* Location/lot/item/serial does not exist */
              {pxmsg.i &MSGNUM=305  &MSGARG1 = ""-Item:"" &MSGARG2=part &ERRORLEVEL=3}
             /* undo xferloop, retry xferloop. */
             	undo,return.
        end.
	end.
	
    else
    if ld_det.ld_qty_oh - lotserial_qty -
       ld_det.ld_qty_all < 0
       and ld_det.ld_qty_all > 0
       and ld_det.ld_qty_oh > 0
       and lotserial_qty > 0
    then do:
    
       status_from = ld_det.ld_status.
 /*      display status_from with frame a. lb01*/
       yn = yes.
       /* Not enough unallocated inventory.  Are you sure? */
       {pxmsg.i &MSGNUM=434 &ERRORLEVEL=2 &CONFIRM=yn}
/*               if not yn then undo, retry. */
       if not yn then undo, return.
    end.

    else do:
       status_from = ld_det.ld_status.
    end.


    ld_recid_from = recid(ld_det).

    {gprun.i ""icedit.p""
       "(""ISS-TR"",
         site_from,
         loc_from,
         pt_part,
         lotser_from,
         lotref_from,
         lotserial_qty,
         pt_um,
         """",
         """",
         output undo-input)"}
    
    if undo-input then undo, return.
    
    find si_mstr where si_site = site_to no-lock no-error.
    if not available si_mstr then do:
       {pxmsg.i &MSGNUM=708  &MSGARG1 = ""-Item:"" &MSGARG2=part &ERRORLEVEL=3}  /* SITE DOES NOT EXIST */
/*lb01*            next-prompt site_to with frame a.
       undo toloop, retry. */
       undo,return.
    end.

    {gprun.i ""gpsiver.p""
       "(input site_to, input ?, output return_int)"}

    if return_int = 0 then do:
       {pxmsg.i &MSGNUM=725  &MSGARG1 = ""-Item:"" &MSGARG2=part &ERRORLEVEL=3}    /* USER DOES NOT HAVE */
       /* ACCESS TO THIS SITE*/
    /*   next-prompt site_to with frame a.
       undo toloop, retry. lb01*/
       undo,return.
    end.

    /* OPEN PERIOD VALIDATION FOR THE ENTITY OF TO SITE  */
    {xkgpglef02.i &module = ""IC""
       &entity = si_entity  
       &date   = eff_date /*
       &prompt = "site_to"
       &frame  = "a"
       &loop   = "toloop"*/ }

    if (pt_lot_ser <> "") and (lotser_from <> lotser_to)
    then do:

       /* PERFORM COMPLIANCE CHECK  */
       {gprun.i ""gpltfnd1.p""
          "(pt_part,
            lotser_to,
            """",
            """",
            output lot_control,
            output lot_found,
            output errmsg)"}


       if ( lot_control > 0 and lot_found ) then do:
          /* SERIAL NUMBER ALREADY EXISTS */
          {pxmsg.i &MSGNUM=7482  &MSGARG1 = ""-Item:"" &MSGARG2=part &ERRORLEVEL=3}
    /*      next-prompt lotser_to.
          undo, retry. */
          undo,return.
       end.

    end.

    /* TO PREVENT DEADLOCK IN MULTIPLE SESSIONS LDDET EXCLUSIVE LOCKED */
    find lddet where lddet.ld_part = pt_part
       and lddet.ld_site = site_to
       and lddet.ld_loc  = loc_to
       and lddet.ld_lot  = lotser_to
       and lddet.ld_ref  = lotref_to
    exclusive-lock no-error.

    ld_recid = ?.
    if not available lddet then do:

       create lddet.
       assign
          lddet.ld_site = site_to
          lddet.ld_loc = loc_to
          lddet.ld_part = pt_part
          lddet.ld_lot = lotser_to
          lddet.ld_ref = lotref_to.

       find loc_mstr where loc_site = site_to and
          loc_loc = loc_to no-lock no-error.

       if available loc_mstr then do:
          lddet.ld_status = loc_status.
       end.
       else do:
          find si_mstr where si_site = site_to no-lock no-error.
          if available si_mstr then do:
             lddet.ld_status = si_status.
          end.
       end.

       ld_recid = recid(lddet).

    end.

    /*ERROR CONDITIONS*/
    if  ld_det.ld_site = lddet.ld_site
       and ld_det.ld_loc  = lddet.ld_loc
       and ld_det.ld_part = lddet.ld_part
       and ld_det.ld_lot  = lddet.ld_lot
       and ld_det.ld_ref  = lddet.ld_ref
    then do:
       {pxmsg.i &MSGNUM=1919  &MSGARG1 = ""-Item:"" &MSGARG2=part &ERRORLEVEL=3}
       /*Data results in null transfer*/
    /*   undo, retry. lb01*/
    	undo,return.
    end.

    if (pt_lot_ser = "S") then do:
       /* LDDET EXACTLY MATCHES THE USER'S 'TO' CRITERIA */
       if lddet.ld_part = pt_part
          and lddet.ld_site = site_to
          and lddet.ld_loc  = loc_to
          and lddet.ld_lot  = lotser_to
          and lddet.ld_ref  = lotref_to
          and lddet.ld_qty_oh > 0
       then do:
          mesg_desc = lddet.ld_site + ', ' + lddet.ld_loc.
          /* SERIAL EXISTS AT SITE, LOCATION */
          {pxmsg.i &MSGNUM=79  &MSGARG1 = ""-Item:"" &MSGARG2=part &ERRORLEVEL=2 &MSGARG1=mesg_desc}
       end.
       else do:
          find first lddet1 where lddet1.ld_part = pt_part
             and lddet1.ld_lot  = lotser_to
             and lddet1.ld_qty_oh > 0
             and recid(lddet1) <> ld_recid_from
          no-lock no-error.
          if available lddet1 then do:
             mesg_desc = lddet1.ld_site + ', ' + lddet1.ld_loc.
             /* SERIAL EXISTS AT SITE, LOCATION */
             {pxmsg.i &MSGNUM=79 &ERRORLEVEL=2 &MSGARG1=mesg_desc}
          end.
       end.
    end.

    if lddet.ld_qty_oh = 0 then do:
       assign
          lddet.ld_date  = ld_det.ld_date
          lddet.ld_assay = ld_det.ld_assay
          lddet.ld_grade = ld_det.ld_grade
          lddet.ld_expire = ld_det.ld_expire.
    end.
    else do:
       /*Assay, grade or expiration conflict. Xfer not allowed*/
       if lddet.ld_grade  <> ld_det.ld_grade
          or lddet.ld_expire <> ld_det.ld_expire
          or lddet.ld_assay  <> ld_det.ld_assay then do:
          {pxmsg.i &MSGNUM=1918 &MSGARG1 = ""-Item:"" &MSGARG2=part  &ERRORLEVEL=4}
    /*      undo, retry. lb01*/
    		undo,return.
       end.
    end.

    if status_from <> lddet.ld_status then do:

    	if lddet.ld_qty_oh = 0 then do:

            if trtype = "LOT/SER" then do:
                     /*To-loc has zero balance. Status may be changed*/
                     {pxmsg.i &MSGNUM=1911  &MSGARG1 = ""-Item:"" &MSGARG2=part &ERRORLEVEL=1}
                     bell.
                     /*lb01*
                     statusloop:
                     do on error undo, retry:*/
                     /*lb01*/ lddet.ld_status = status_from.
	        end. /*ld_qty_oh = 0 and trtype = "LOT/SER"*/

/*H01*/ end. 
/*H01***Delete Begin***********
            else do:

                 yn = no.
                 bell.
                 /*Status conflict.  Use "to" steatus?*/
                 {pxmsg.i &MSGNUM=1917 &MSGARG1 = ""-Item:"" &MSGARG2=part  &ERRORLEVEL=1 &CONFIRM=yn}

                 if not yn then do:

                    yn = yes.
                    /*Status conflict.  Use "from" status?*/
                    {pxmsg.i &MSGNUM=1916  &MSGARG1 = ""-Item:"" &MSGARG2=part &ERRORLEVEL=1 &CONFIRM=yn}

                    if yn then do:
                       /* TO GENERATE ERROR MESSAGE WHEN "TO"       */
                       /* INVENTORY STATUS IS DIFFERENT FROM "FROM" */
                       /* INVENTORY STATUS AND IF ld_status IS      */
                       /* RESTRICTED FOR THE USER IN FIELD SECURITY */
                       /* MAINTENANCE                               */
                       if ( { gppswd3.i &field = ""ld_status"" } = no)
                       then do:
                          /* USER DOES NOT HAVE ACCESS TO FIELD */
                          {pxmsg.i &MSGNUM=3337 &ERRORLEVEL=3
                                   &MSGARG1=""ld_status""}
                    /*       undo,retry. lb01*/
                    		undo, return.
                       end. /* IF ({ gppswd3.i */
                       lddet.ld_status = ld_det.ld_status.
                      /* display lddet.ld_status. lb01*/
                    end.

                    else do:
                        /*   undo, retry. */
                       	undo,return.
                    end.
				 end.
			end. /*ld_qty_oh = 0 and trtype <> "LOT/SER"*/

		end. /*ld_qty_oh = 0*/

       	else do:
          /*Status conflict.  Use "to" status?*/
          yn = yes.
          bell.
                 {pxmsg.i &MSGNUM=1917 &MSGARG1 = ""-Item:"" &MSGARG2=part &ERRORLEVEL=1 &CONFIRM=yn}
 /*          {pxmsg.i &MSGNUM=1917 &ERRORLEVEL=1 &CONFIRM=yn}
                 if not yn then undo, retry. lb01*/
          if not yn then undo, return.
        end. /*ld_qty_oh <> 0 & LOT/SER*/
**H01***Delete End**********/       	

	end. /*lddet.ld_status <> ld_det.ld_status*/

    find is_mstr where is_status = lddet.ld_status no-lock.
    if not is_overissue and lddet.ld_qty_oh + lotserial_qty < 0
    then do:
       /*Transfer will result in negative qty at "to" loc*/
       {pxmsg.i &MSGNUM=1920  &MSGARG1 = ""-Item:"" &MSGARG2=part &ERRORLEVEL=3}
     /*  undo, retry. lb01*/
     	undo,return.
    end.

    {gprun.i ""icedit.p""
       "(""RCT-TR"",
         site_to,
         loc_to,
         pt_part,
         lotser_to,
         lotref_to,
         lotserial_qty,
         pt_um,
         """",
         """",
         output undo-input)"}
    if undo-input then undo, return.
         
 	rdcrcvqty = lotserial_qty .  /*lb01*/

    release lddet.
    release ld_det.

    {gprun.i ""icedit.p""
       "(""ISS-TR"",
         site_from,
         loc_from,
         pt_part,
         lotser_from,
         lotref_from,
         lotserial_qty,
         pt_um,
         """",
         """",
         output undo-input)"}
    if undo-input then undo, return.

     hide message.

     /* RESET GLOBAL PART VARIABLE IN CASE IT HAS BEEN CHANGED*/
     global_part = pt_part.
     global_addr = "".

     /*PASS BOTH LOTSER_FROM & LOTSER_TO IN PARAMETER LOTSERIAL*/
     lotserial = lotser_from.
     if lotser_to = "" then
        substring(lotserial,40,1) = "#".
     else
        substring(lotserial,19,18) = lotser_to.


     /* Clear shipper line item temp table */
     {gprun.i  ""icshmt1c.p"" }


     {&ICLOTR-P-TAG13}
     /* Add to shipper line item temp table */
     {gprun.i ""icshmt1a.p""
        "(pt_part,
          lotser_from,
          lotref_from,
          site_from,
          loc_from,
          lotserial_qty,
          pt_um,
          1,
          pt_net_wt * lotserial_qty,
          pt_net_wt_um,
          pt_size * lotserial_qty,
          pt_size_um)" }


     /* Create shipper */
     {gprun.i ""icshmt.p""
        "(site_from,
          site_to,
          ""ISS-TR"",
          eff_date,
          output v_abs_recid)" }

     /* Get associated shipper */
     find abs_mstr where recid(abs_mstr) = v_abs_recid
     no-lock no-error.
     if available abs_mstr then
     assign
        v_shipnbr  = substring(abs_id,2)
        v_shipdate = abs_shp_date
        v_invmov   = abs_inv_mov.
     else
     assign
        v_shipnbr  = ""
        v_shipdate = ?
        v_invmov   = "".

     /* SHIP_NBR, SHIP_DATE, INV_MOV,                                 */

     {&ICLOTR-P-TAG15}
     {gprun.i ""icxfer.p""
        "("""",
          lotserial,
          lotref_from,
          lotref_to,
          lotserial_qty,
          nbr,
          so_job,
          rmks,
          """",
          eff_date,
          site_from,
          loc_from,
          site_to,
          loc_to,
          no,
          v_shipnbr,
          v_shipdate,
          v_invmov,
          0,
          output glcost,
          output iss_trnbr,
          output rct_trnbr,
          input-output assay,
          input-output grade,
          input-output expire)"}


      /* CHECK TO SEE IF CONSIGNMENT IS ACTIVE */
      {gprun.i ""gpmfc01.p""
         "(input ENABLE_CUSTOMER_CONSIGNMENT,
           input 10,
           input ADG,
           input CUST_CONSIGN_CTRL_TABLE,
           output using_cust_consignment)"}


      if using_cust_consignment then do:
         {gprunmo.i
            &program=""socncix1.p""
            &module="ACN"
            &param="""(input pt_part,
              input lotserial_qty,
              input nbr,
              input site_from,
              input loc_from,
              input lotser_from,
              input lotref_from,
              input site_to,
              input loc_to,
              input lotser_to,
              input lotref_to,
              input so_job,
              input pt_um,
              input iss_trnbr,
              input rct_trnbr)"""}
      end. /*IF USING_CUST_CONSIGNMENT*/

      /* DETERMINE IF SUPPLIER PERFORMANCE IS INSTALLED */
      if can-find (mfc_ctrl where
                  mfc_field = "enable_supplier_perf" and mfc_logical) and
         can-find (_File where _File-name = "vef_ctrl") then do:
         /* REPLACED INPUT PARAMETER ve_recid WITH pt-part  */
         {gprunmo.i
            &program=""iclotrve.p""
            &module="ASP"
            &param="""(input pt_part)"""}
      end.  /* IF ENABLE SUPPLIER PERFORMANCE */

      /* RECORD WIP LOT TRACING DATA WHEN CHANGING ONE LOT/SERIAL */
      /* NUMBER TO ANOTHER LOT/SERIAL NUMBER                      */
      if is_wiplottrace_enabled() and
         lotser_from <> ""        and
         lotser_to <> ""
      then do:

         run get_transaction_number in h_wiplottrace_procs
            (output trans_nbr).

         run record_lot_serial_change in h_wiplottrace_procs
            (input trans_nbr,
             input lotser_from,
             input lotser_to,
             input pt_part,
             input lotserial_qty).

      end. /* if is_wiplottrace_enabled */

      do:
         if ld_recid <> ? then
            find ld_det where ld_recid = recid(ld_det) no-error.

         if available ld_det then do:
            find loc_mstr where loc_site = ld_det.ld_site
                            and loc_loc  = ld_det.ld_loc
            no-lock.
            if ld_det.ld_qty_oh = 0 and ld_det.ld_qty_all = 0 and
               not loc_perm and
               not can-find(first tag_mstr
                            where tag_site   = ld_det.ld_site
                              and tag_loc    = ld_det.ld_loc
                              and tag_part   = ld_det.ld_part
                              and tag_serial = ld_det.ld_lot
                              and tag_ref    = ld_det.ld_ref)
            then
               delete ld_det.
         end.
      end. 
 end.

if is_wiplottrace_enabled() then
   delete PROCEDURE h_wiplottrace_procs no-error.
if is_wiplottrace_enabled() then
   delete PROCEDURE h_wiplottrace_funcs no-error.
{&ICLOTR-P-TAG18}

