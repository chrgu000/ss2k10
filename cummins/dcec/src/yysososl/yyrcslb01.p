/* rcslb01.p - DO ALLOCATIONS FOR A SCHEDULED ORDER LINE AND STAGE         */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */

/* REVISION: 7.5    LAST MODIFIED: 01/02/96           BY: GWM *J049*       */
/* REVISION: 8.6    LAST MODIFIED: 09/16/96   BY: *K003* Vinay Nayak-Sujir */
/* REVISION: 8.6    LAST MODIFIED: 10/02/96   BY: *K003* forrest mori      */
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E   LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E   LAST MODIFIED: 06/07/98   BY: *J2MH* Dana Tunstall     */
/* REVISION: 9.1    LAST MODIFIED: 06/14/99   BY: *N004* Patrick Rowan     */
/* REVISION: 9.1    LAST MODIFIED: 12/02/99   BY: *L0M0* Manish  K.        */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown        */
/* REVISION: 9.1    LAST MODIFIED: 09/06/00   BY: *N0RG* Mudit Mehta       */
/* Revision: 1.8.3.6  BY: Paul Donnelly (SB)   DATE: 06/28/03   ECO: *Q00K* */
/* Revision: 1.8.3.7  BY: Rajinder Kamra       DATE: 05/05/03   ECO: *Q003* */
/* $Revision: 1.8.3.7.1.1 $  BY: Mochesh Chandran     DATE: 04/10/07   ECO: *P5FK*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*-Revision end---------------------------------------------------------------*/
/*V8:ConvertMode=NoConvert                                                 */
{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

/* ********** End Translatable Strings Definitions ********* */

/* INPUT VARIABLES */
define input parameter so_recid as recid no-undo.
define input parameter sod_recid as recid no-undo.
define input parameter all_only as logical no-undo.
define input parameter alloc_cont as logical no-undo.
define input parameter open_qty like sod_qty_ord no-undo.
define input parameter shipgrp like sg_grp no-undo.
define input parameter inv_mov like abs_inv_mov no-undo.
define input parameter nrseq like abs_preship_nr_id no-undo.
define input parameter cons_ship like abs_cons_ship no-undo.
define input parameter l_create_um like mfc_logical  no-undo.
define output parameter abnormal_exit as logical no-undo.

/* LOCAL VARIABLES */
define variable so_db like si_db no-undo.
define variable err_flag as integer no-undo.
define variable total_alloc like lad_qty_all no-undo.
define variable l_delproc like mfc_logical no-undo.

/* SHARED VARIABLES FOR SOPKALL.P */
define new shared variable alc_sod_nbr like sod_nbr.
define new shared variable alc_sod_line like sod_line.
define new shared variable tot_qty_all like lad_qty_all.
define new shared variable sod_recno as recid.
define new shared variable so_recno as recid.

/* SHARED VARIABLES FOR CUSTOMER SEQUENCE SCHEDULES */
{sosqvars.i}

find sod_det where recid(sod_det) = sod_recid.

assign
   so_db = global_db
   alc_sod_nbr = sod_nbr
   alc_sod_line = sod_line
   sod_recno = sod_recid
   so_recno = so_recid.

/*CREATE HARD ALLOCATIONS IN THE INVENTORY SITE*/
if sod_type = "" then do:

   /* SWITCH TO THE INVENTORY SITE */
   {gprun.i ""gpalias2.p"" "(input sod_site, output err_flag)"}

   if err_flag <> 0 and err_flag <> 9 then do:

      /* DOMAIN # IS NOT AVAILABLE */

      {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4
         &MSGARG1=getTermLabel(""FOR_REMOTE_INVENTORY"",25)}
      abnormal_exit = true.
      return.
   end.

   /* DO THE DETAIL ALLOCATIONS */
   /* ADDED INPUT  PARAMETER FOR AUTOMATIC CONTAINER ALLOCATION */
   /* LOGIC                                                     */
   {gprun.i ""yysopkall.p"" "(input alloc_cont)"}

   /* Added shipgrp, inv_mov, nrseq, cons_ship */
   /* CREATE THE STAGE LIST LINES */
   /* ADDED INPUT PARAMETER L_CREATE_UM */
   {gprun.i ""yysosle01.p""
      "(input sod_nbr,
        input sod_line,
        input alloc_cont,
        input so_db,
        input shipgrp,
        input inv_mov,
        input nrseq,
        input cons_ship,
        input l_create_um,
        output total_alloc,
        output abnormal_exit)"}

   /* HANDLE ABNORMAL EXIT FLAG */
   if abnormal_exit then return.

   /* SET TOT_QTY_ALL FOR SOSOPKA2.P */
   tot_qty_all = total_alloc.

   /* UPDATE SALES ORDER QTY PICK AND QTY ALLOC AND PICK DATE */
   if so_db <> global_db then do:

      /* UPDATE DETAIL QTY ALL, QTY PICK */
      /* ADDED FOURTH INPUT PARAMETER L_DELPROC */
      {gprun.i ""sosopka2.p""
         "(input alc_sod_nbr,
           input alc_sod_line,
           input tot_qty_all,
           input l_delproc)"}
   end.

   /* SWITCH BACK TO THE SALES ORDER DOMAIN */
   {gprun.i ""gpalias3.p"" "(so_db, output err_flag)"}

   if err_flag <> 0 and err_flag <> 9 then do:

      /* DOMAIN # IS NOT AVAILABLE*/

      {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4
         &MSGARG1=getTermLabel(""FOR_SALES_ORDERS"",25)}
      abnormal_exit = true.
      return.
   end.

end.

/* UPDATE SOD IN SO DOMAIN */
/* UPDATE DETAIL QTY ALL, QTY PICK */
/* ADDED FOURTH INPUT PARAMETER    */
{gprun.i ""sosopka2.p""
   "(input alc_sod_nbr,
     input alc_sod_line,
     input tot_qty_all,
     input l_delproc )"}

/* IF NO ALLOCATIONS AND PRINT ALL OPEN LINES THEN CREATE TEMP REC */
if total_alloc = 0 and not all_only and open_qty > 0 then do:

   find qad_wkfl  where qad_wkfl.qad_domain = global_domain and
      qad_key1 = mfguser + global_db + "stage_list"
      and qad_key2 = sod_nbr + string(sod_line) no-lock no-error.

   if not available qad_wkfl then do:

      find so_mstr  where so_mstr.so_domain = global_domain and
         so_nbr = sod_nbr no-lock.
      for first pt_mstr
         fields( pt_domain pt_part pt_um)
         where pt_mstr.pt_domain = global_domain and  pt_part =
         sod_part no-lock:
      end. /* FOR FIRST PT_MSTR */

      create qad_wkfl.
      qad_wkfl.qad_domain = global_domain.

      assign
         qad_key1 = mfguser + global_db + "stage_list"
         qad_key2 = sod_nbr + string(sod_line)
         qad_decfld[1] = 0
         qad_charfld[1] = so_site
         qad_charfld[2] = sod_part
         qad_charfld[6] = so_ship
         qad_charfld[7] = sod_nbr
         qad_charfld[8] = string(sod_line)
         qad_charfld[10] = if not l_create_um and available pt_mstr then
         pt_um
         else
         sod_um
         qad_charfld[11] = if not l_create_um and available pt_mstr then
         string("1")
         else
         string(sod_um_conv)
         qad_charfld[12] = sod_site
         qad_charfld[13] = shipgrp + "," + inv_mov
         qad_charfld[14] = nrseq + "," + cons_ship.

      if using_seq_schedules and so_seq_order then do:
         /*CREATE SEQ. STAGE LIST ENTRIES (qad_wkfl) */
         {gprunmo.i
            &program = ""rcslb03.p""
            &module = "ASQ"
            &param = """(input sod_nbr,
              input sod_line,
              input recid(qad_wkfl),
              input all_only)"""}
      end.  /* if using_seq_schedules */

   end.
end.
