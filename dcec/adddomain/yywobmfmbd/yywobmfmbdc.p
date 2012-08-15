{mfdeclre.i}

DEFINE INPUT PARAMETER inp-part LIKE pt_part.
DEFINE INPUT PARAMETER inp-site LIKE pt_site.
DEFINE INPUT PARAMETER inp-date AS DATE.

DEFINE SHARED TEMP-TABLE ttx9
    FIELDS ttx9_part LIKE pt_part
    FIELDS ttx9_site LIKE pt_site
    FIELDS ttx9_bomcode LIKE pt_part
    FIELDS ttx9_chk_bom  AS LOGICAL INITIAL NO
    FIELDS ttx9_chk_cwo  AS LOGICAL INITIAL NO
    FIELDS ttx9_version  AS INTEGER
    FIELDS ttx9_cmmt     AS CHAR
    INDEX  ttx9_idx1 IS PRIMARY UNIQUE ttx9_part ttx9_site.

DEFINE VARIABLE v_pm_code AS CHAR.


         define variable site like ptp_site.
         define variable comp like ps_comp.
         define variable level as integer.
         define variable maxlevel as integer format ">>>" .
         define variable eff_date like ar_effdate.
/*J3J4*/ define variable parent like ps_par  no-undo.
         define variable desc1 like pt_desc1.
         define variable um like pt_um.
         define variable phantom like mfc_logical format "yes" .
         define variable iss_pol like pt_iss_pol. 
/*J30L*  define variable record as integer extent 100. */
         define variable lvl as character format "x(7)".
         define variable bom_code like pt_bom_code.



         FIND FIRST ttx9 WHERE ttx9_part = inp-part AND ttx9_site = inp-site NO-LOCK NO-ERROR.
         IF AVAILABLE ttx9 THEN LEAVE.



         /* SET PARENT TO GLOBAL PART NUMBER */
         parent = inp-part.
         site = inp-site.
         eff_date = inp-date.

         assign
/*N0MD*/      lvl = ""
/*G1YQ*/      bom_code = ""
              level = 1
              comp = parent
              maxlevel = min(maxlevel,99).

            FIND FIRST pt_mstr WHERE pt_part = inp-part NO-LOCK NO-ERROR.
            IF NOT AVAILABLE pt_mstr THEN LEAVE.

            ASSIGN v_pm_code = pt_pm_code.


/*N027*/    /* COMBINED FOLLOWING ASSIGNMENTS */
            find ptp_det no-lock where ptp_part = parent AND ptp_site = site no-error.
            if available ptp_det then
                assign comp    = if ptp_bom_code <> "" then ptp_bom_code
                                                       else ptp_part
/*N027*/               phantom = ptp_phantom
/*N027*/               iss_pol = ptp_iss_pol.
            else if available pt_mstr then
                assign comp    = if pt_bom_code <> "" then pt_bom_code
                                                      else pt_part
/*N027*/               phantom = pt_phantom
/*N027*/               iss_pol = pt_iss_pol.

            IF AVAILABLE ptp_det THEN ASSIGN v_pm_code = ptp_pm_code.

            IF lookup(v_pm_code,"P,D") <> 0 THEN NEXT.
            ELSE DO:
                CREATE ttx9.
                ASSIGN 
                    ttx9_part = pt_part
                    ttx9_site = inp-site
                    ttx9_bomcode = comp
                    ttx9_chk_cwo = NO
                    ttx9_chk_bom = NO.
            END.



/*J30L*/   run process_report in this-procedure (input comp,input level).


/*J30L*  BEGIN ADD PROCEDURE */
procedure process_report:
define query q_ps_mstr for ps_mstr .
define input parameter comp like ps_comp no-undo.
define input parameter level as integer no-undo.
           /*DETAIL FORM */

find pt_mstr no-lock where pt_part = comp no-error.
/*J3J4*/ if available pt_mstr and pt_bom_code <> "" then
/*J3J4*/    comp = pt_bom_code.

open query q_ps_mstr for each ps_mstr use-index ps_parcomp
     where ps_par = comp and ps_ps_code <> "J" no-lock.

get first q_ps_mstr no-lock.

if not available ps_mstr then return.

repeat while avail ps_mstr:


  if eff_date = ? or (eff_date <> ? and
   (ps_start = ? or ps_start <= eff_date)
    and (ps_end = ? or eff_date <= ps_end)) then do:

    assign um = ""
         desc1 = ""
         iss_pol = no
         phantom = no.
    
    ASSIGN v_pm_code = "".


    find pt_mstr where pt_part = ps_comp no-lock no-error.
    if available pt_mstr then do:
      assign um = pt_um
             desc1 = pt_desc1
             iss_pol = pt_iss_pol
             phantom = pt_phantom.
      v_pm_code = pt_pm_code.
    end.
    else do:
      find bom_mstr no-lock where bom_parent = ps_comp no-error.
      if available bom_mstr then
        assign um = bom_batch_um
               desc1 = bom_desc.
    end.

    assign bom_code = ps_comp.

    find ptp_det no-lock where ptp_part = ps_comp
         and ptp_site = site no-error.
    if available ptp_det
    then assign iss_pol = ptp_iss_pol
    phantom = ptp_phantom.
    else if available pt_mstr
    then assign iss_pol = pt_iss_pol
    phantom = pt_phantom.

    if available ptp_det then
    bom_code = if ptp_bom_code <> "" then ptp_bom_code
    else ptp_part.
    else if available pt_mstr then
    bom_code = if pt_bom_code <> "" then pt_bom_code else pt_part.

    lvl = ".......".
    lvl = substring(lvl,1,min(level - 1,6)) + string(level).
    if length(lvl) > 7 then lvl = substring(lvl,length(lvl) - 6,7).

    IF AVAILABLE ptp_det THEN ASSIGN v_pm_code = ptp_pm_code.
    IF AVAILABLE pt_mstr AND LOOKUP(v_pm_code, "P,D") = 0 THEN DO:
        FIND FIRST ttx9 WHERE ttx9_part = pt_part AND ttx9_site = inp-site NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ttx9 THEN DO:
            CREATE ttx9.
            ASSIGN 
                ttx9_part = pt_part
                ttx9_site = inp-site
                ttx9_bomcode = bom_code
                ttx9_chk_cwo = NO
                ttx9_chk_bom = NO.
        END.
    END.
    /*
    display lvl ps_comp desc1
                  ps_qty_per
                  um phantom ps_ps_code iss_pol
    with frame heading.
    */

    if available ptp_det then if ptp_bom_code <> ""
      then bom_code = ptp_bom_code.
      else if available pt_mstr and pt_bom_code <> ""
      then bom_code = pt_bom_code.


    if level < maxlevel or maxlevel = 0 then do:
/*J3J4*/ run process_report in this-procedure(input bom_code, input level + 1).

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
/*J30L*  END ADD PROCEDURE */
