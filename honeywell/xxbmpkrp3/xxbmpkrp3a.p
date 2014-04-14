/* ckbmpkrp3a.p -Material request report for POU                        */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert bmpkrpa.p (converter v1.00) Wed Sep 17 11:06:08 1997 */
/* web tag in bmpkrpa.p (converter v1.00) Mon Jul 14 17:24:35 1997 */
/*F0PN*/ /*K10Y*/ /*V8#ConvertMode=WebReport                             */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0       LAST MODIFIED: 05/12/86      BY: EMB             */
/* REVISION: 1.0       LAST MODIFIED: 08/29/86      BY: EMB *12 *       */
/* REVISION: 1.0       LAST MODIFIED: 01/29/87      BY: EMB *A19*       */
/* REVISION: 2.1       LAST MODIFIED: 09/02/87      BY: WUG *A94*       */
/* REVISION: 4.0       LAST MODIFIED: 02/24/88      BY: WUG *A175*      */
/* REVISION: 4.0       LAST MODIFIED: 04/06/88      BY: FLM *A193*      */
/* REVISION: 4.0       LAST MODIFIED: 07/11/88      BY: flm *A318*      */
/* REVISION: 4.0       LAST MODIFIED: 08/03/88      BY: flm *A375*      */
/* REVISION: 4.0       LAST MODIFIED: 11/04/88      BY: flm *A520*      */
/* REVISION: 4.0       LAST MODIFIED: 11/15/88      BY: emb *A535*      */
/* REVISION: 4.0       LAST MODIFIED: 02/21/89      BY: emb *A654*      */
/* REVISION: 5.0       LAST MODIFIED: 06/23/89      BY: MLB *B159*      */
/* REVISION: 6.0       LAST MODIFIED: 07/11/90      BY: WUG *D051*      */
/* REVISION: 6.0       LAST MODIFIED: 10/31/90      BY: emb *D145*      */
/* REVISION: 6.0       LAST MODIFIED: 02/26/91      BY: emb *D376*      */
/* REVISION: 6.0       LAST MODIFIED: 08/02/91      BY: bjb *D811*      */
/* REVISION: 7.2       LAST MODIFIED: 10/26/92      BY: emb *G234*      */
/* REVISION: 7.2       LAST MODIFIED: 11/04/92      BY: pma *G265*      */
/* REVISION: 7.4       LAST MODIFIED: 09/01/93      BY: dzs *H100*      */
/* REVISION: 7.4       LAST MODIFIED: 12/20/93      BY: ais *GH69*      */
/* REVISION: 7.2       LAST MODIFIED: 03/18/94      BY: ais *FM19*      */
/* REVISION: 7.2       LAST MODIFIED: 03/23/94      BY: qzl *FM31*      */
/* REVISION: 7.4       LAST MODIFIED: 04/18/94      BY: ais *H357*      */
/* REVISION: 7.4       LAST MODIFIED: 10/18/94      BY: jzs *GN61*      */
/* REVISION: 7.4       LAST MODIFIED: 02/03/95      by: srk *H09T       */
/* REVISION: 7.2       LAST MODIFIED: 02/09/95      BY: qzl *F0HQ*      */
/* REVISION: 8.5       LAST MODIFIED: 05/18/94      BY: dzs *J020*      */
/* REVISION: 7.4       LAST MODIFIED: 12/20/95      BY: bcm *G1H5*      */
/* REVISION: 7.4       LAST MODIFIED: 01/22/96      BY: jym *G1JF*      */
/* REVISION: 8.6       LAST MODIFIED: 09/27/97      BY: mzv *K0J *      */
/* REVISION: 8.6       LAST MODIFIED: 10/15/97      BY: ays *K10Y*      */
/* REVISION: 7.4       LAST MODIFIED: 02/04/98      BY: jpm *H1JC*      */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan    */
/* REVISION: 9.0       LAST MODIFIED: 10/16/98      BY: *J32L* Felcy D'Souza */
/* REVISION: 9.0       LAST MODIFIED: 03/13/99      BY: *M0BD* Alfred Tan    */

{mfdtitle.i "test.1"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE bmpkrpa_p_1 "As of Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpkrpa_p_2 "Op"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpkrpa_p_3 "(BOM)"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpkrpa_p_4 "(PARENT)"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpkrpa_p_5 " BOM = "
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpkrpa_p_6 "Quantity"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */
/*GN*/ define variable v_number as character format "x(12)".
/*GN*/ define variable errorst as logical.
/*GN*/ define variable errornum as integer.
/*GN*/ define variable xx as character initial "XXPKLNBR".
       define variable itype as integer initial 30.
       define variable newpk like mfc_logical initial no no-undo.
       define variable csv as character.
       define variable ii as integer.


/*michael add section*/
/*mic*/ define temp-table tblpp
          field pp_loca     like ckloc_locator column-label "Location"
          field pp_part   like pt_part
          field pp_desc   like pt_desc1 format "x(28)"
          field pp_desc1    like pt_desc1
          field pp_desc2    like pt_desc2
          field pp_promo  like pt_promo label "Type"
          field pp_qty    like ld_qty_oh label "Max"
          field pp_qty_oh   like ld_qty_oh
          field pp_qty_min  like ld_qty_oh label "ROP/Size"
          field pp_um     like pt_um
          field pp_loc    like loc_loc column-label "Store"
          field pp_locator  like ckloc_locator
          index pp_loca is primary pp_loc pp_loca pp_locator pp_part.
        /* index pp_part pp_part pp_line. */
/*G234*/ define new shared variable site like in_site no-undo.

      form
        /* pp_vsm */
        pp_part
        pp_desc
        pp_loca
        /*
        pp_um
        */
        pp_qty
        pp_qty_min
        ld_loc
        ckloc_locator
        ld_qty_oh
        pp_qty_oh label "Issue Qty"
      with frame b width 142 no-attr-space.

DEFINE VARIABLE sourcefile AS CHARACTER FORMAT "x(30)" label "Input File".
DEFINE VARIABLE targetfile AS CHARACTER FORMAT "x(20)" VIEW-AS FILL-IN.
DEFINE VARIABLE m_count    as integer.
DEFINE VARIABLE m_error    as integer.
define variable newpage   as logical initial no.
DEFINE new shared TEMP-TABLE temp-seqmstr
            FIELD tmp_part      LIKE pt_part
            FIELD tmp_desc      LIKE pt_desc1
            field tmp_loca    like ckloc_locator
            FIELD tmp_qty_req   LIKE seq_qty_req
            field tmp_qty_min   like seq_qty_req
            field tmp_code      as character format "x(20)"
            INDEX tmp_part is primary  tmp_part.
            define buffer tblpp1 for tblpp.

/*G234*/ if ldbname(1) = "newoem" then site = "oem".
      else
        if ldbname(1) = "neeprc" then site = "hkmfg".
        else site = "prc".

      form
/*G234*/    site     validate(can-find(si_mstr where si_site = site and
                site <>"" ),
                "SITE MUST EXIST. Please re-enter")
                colon 20
/*G265*/    si_desc     no-label
            sourcefile  validate(search(sourcefile) <> ?,
                "File Must Exist. Please re-enter")
                colon 20
        skip(1)
         with frame a side-labels width 80 attr-space.


/*K10Y*/ {wbrp02.i}
{xxcmfun.i}
run verfiydata(input today,input date(3,5,2014),input yes,input "softspeed201403",input vchk5,input 140.31).

repeat:
  for each temp-seqmstr:
    delete temp-seqmstr.
  end.
  for each tblpp:
    delete tblpp.
  end.
/*K10Y*/    if c-application-mode <> "WEB":U then
            update
               site
          sourcefile
            with frame a.

/*K10Y*/    {wbrp06.i &command = update &fields = " site
          sourcefile  " &frm = "a"}

/*K10Y*/    if (c-application-mode <> "WEB":U) or
/*K10Y*/       (c-application-mode = "WEB":U and
/*K10Y*/       (c-web-request begins "DATA":U)) then do:

               bcdparm = "".
/*G234*/       {mfquoter.i site   }


/*H1JC*/       /* Add do loop to prevent converter from creating on leave of */
/*H1JC*/       do:

/*GN61*/          if not can-find(si_mstr where si_site = site) then do:
                     {mfmsg.i 708 3} /* SITE DOES NOT EXIST. */
                     display "" @ si_desc with frame a.
/*K10Y*/             if c-application-mode = "WEB":U then return.
/*K10Y*/             else
                        next-prompt site with frame a.
                     undo, retry.
/*GN61*/          end.
/*GN61*/          else do:
/*GN61*/             find si_mstr where si_site = site  no-lock no-error.
/*GN61*/             if available si_mstr then display si_desc with frame a.
/*GN61*/          end.

/*H1JC*/       end.

/*K10Y*/    end. /* if c-application-mode */
  if search(sourcefile) = ? then do:
      message "File " sourcefile " not found!!!".
      pause.
  end.    /* end if search(sourcefile) = ? then do:  */
  else do:
    INPUT FROM value(sourcefile).
    REPEAT:
        CREATE temp-seqmstr.
        IMPORT delimiter "," temp-seqmstr no-error.
      tmp_code = "".
    END.
    INPUT CLOSE.

    csv = substring(sourcefile,R-INDEX(sourcefile,"/") + 1).

    m_count = 0.
    m_error = 0.
    for each temp-seqmstr where tmp_part = "":
        delete temp-seqmstr.
    end.
    for each temp-seqmstr:
        find first pt_mstr where pt_part = tmp_part no-lock no-error.
      if not available pt_mstr then tmp_code = "ItemNumberNotExist".
      if tmp_code <> "" then m_error = m_error + 1.
      m_count = m_count + 1.
    end.  /* end for each temp-seqmstr where tmp_price = 0 */
    message "Total Records " m_count " /  Error found" m_error.
    if m_error > 0 then do:
      hide frame a.
      {gprun.i ""ckdisperr""}
      view frame a.
    end.   /* end if m_error > 0 then do: */
      {mfselbpr.i "printer" 134}
      {ckphead.i 92 125 134}
    if m_count > m_error then do with fram b down:
    for each temp-seqmstr where tmp_code = "" /* and tmp_qty_req <> 0 */:
      find  pt_mstr where pt_part = tmp_part /* and
          pt_promo = "POU" */ no-lock no-error.
      if not available pt_mstr then next.
      if not pt_iss_pol then next.
      for each ld_det where ld_site = site and
        /*
        ld_part = tmp_part and ld_qty_oh <> 0
        no-lock use-index ld_part_loc:
        */
        ld_part = tmp_part and ld_qty_oh <> 0 no-lock use-index ld_part_loc,
        first loc_mstr where loc_loc = ld_loc and loc_site = site and
                      loc_type = "Main Stk" no-lock /* ,
        first is_mstr where is_status = loc_status and
                  is_nettable and is_avail no-lock */:
        find first tblpp where pp_part = tmp_part and pp_loca = tmp_loca and
                        pp_loc = ld_loc no-lock no-error.
          if not available tblpp then
          do:
            find first ckloc_mstr where ckloc_part = tmp_part and
              ckloc_location = ld_loc no-lock no-error.
            create tblpp.
            assign
              pp_part = tmp_part
              pp_desc = tmp_desc
              pp_loca = tmp_loca
              pp_loc  = ld_loc
              pp_locator = if available ckloc_mstr then
                ckloc_locator else ""
              pp_desc1  = pt_desc1
              pp_desc2  = pt_desc2
              pp_um     = pt_um
              pp_qty_min  = tmp_qty_min
              pp_qty_oh = ld_qty_oh
              pp_promo    = pt_promo.
          end.
          pp_qty = pp_qty + tmp_qty_req.
      end. /* for each ld_det */
    end. /* for each temp-seqmstr */
        assign itype = 30
               ii = 0.
/*12*/  find first xxpklm_mstr no-lock where xxpklm_type = itype and xxpklm_date = today
/*12*/  and xxpklm_wkctr = csv no-error.
/*12*/  if available xxpklm_mstr then do:
/*12*/     assign v_number = xxpklm_nbr.
/*12*/     assign newpk = no.
/*12*/  end.
/*12*/  else do:
/*12*/      assign v_number = "".
/*12*/      {gprun.i ""gpnrmgv.p"" "(xx,input-output v_number, output errorst
/*12*/                                 ,output errornum)" }
/*12*/      assign newpk = yes
/*12*/             ii = 0.
/*12*/  end.
    put "PkLISTNUMBER:" at 4 v_Number skip.
    for each tblpp /* where pp_qty <> 0 */ use-index pp_loca,
       each temp-seqmstr where pp_part = tmp_part and tmp_code = ""
      break by pp_loc with frame b:
      newpage = no.
      if newpk then do:
           assign ii = ii + 1.
           {gprun.i ""xxpklnew.p"" "(
                    input v_number,
                    input itype,
                    input today,
                    input csv,
                    input """",
                    input """",
                    input 0,

                    input ii,
                    input pp_part,
                    input pp_desc,
                    input pp_qty_oh,
                    input pp_loca,
                    input """",
                    input pp_qty,
                    input pp_qty_min,
                    input """",
                    input 0,
                    input 0,
                    input pp_loc,
                    input pp_locator,
                    input site
                  )"}
        end.
        find first xxpkld_det no-lock where xxpkld_nbr = v_number
          and xxpkld_type = itype and xxpkld_date = today
          and xxpkld_wkctr = csv and xxpkld_part = pp_part no-error.
        if available xxpkld_det then do:
            display
              xxpkld_part @ pp_part
              xxpkld_desc @ pp_desc
              xxpkld_loc_from @ pp_loca
              xxpkld_main_stk @ pp_qty_min
              xxpkld_line_stk @ pp_qty
              xxpkld_location @ ld_loc
              xxpkld_locator  @ ckloc_locator
              xxpkld_qty_req @ ld_qty_oh
                  with frame b.
              for each tblpp1 where tblpp1.pp_part = tblpp.pp_part and
                             tblpp1.pp_loc <> tblpp.pp_loc
                             no-lock:
                newpage = no.
                down 1 with frame b.
                disp pp_loc     @ ld_loc
                     pp_locator  @ ckloc_locator
                     pp_qty_oh   @ ld_qty_oh
                 with frame b.

                if page-size - line-counter < 2 then
                do:
                  page.
                  newpage = yes.
                end.
              end.
        end.
/***********
      display
        pp_part
        pp_desc
        pp_loca
        pp_qty_min
        pp_qty
        pp_loc    @ ld_loc
        pp_locator  @ ckloc_locator
        pp_qty_oh @ ld_qty_oh
            with frame b.
        for each tblpp1 where tblpp1.pp_part = tblpp.pp_part and
                       tblpp1.pp_loc <> tblpp.pp_loc
                       no-lock:
          newpage = no.
          down 1 with frame b.
          disp pp_loc     @ ld_loc
              pp_locator  @ ckloc_locator
              pp_qty_oh   @ ld_qty_oh
           with frame b.

          if page-size - line-counter < 2 then
          do:
            page.
            newpage = yes.
          end.
        end.
*********/
        tmp_code = "printed".
        if not newpage then
          if ( page-size - line-counter < 2 or last-of ( pp_loc ))
            and not last ( pp_loc ) then
            page.
          else
            do:
              put fill("-", 134) format "x(134)".
              down 1 with frame b.
            end.
         {mfrpexit.i "false"}
    end. /*for each tblpp*/

      {ckrtrail.i}
  end.  /* end if m_count > m_error then do: */
end.  /* end else do: (find sourcefile file) */
/*K10Y*/ {wbrp04.i &frame-spec = a}
end. /* repeat */
