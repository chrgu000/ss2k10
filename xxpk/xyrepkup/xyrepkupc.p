/* repkupc.p - REPETITIVE PICKLIST CALCULATION                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* REVISION: 7.3      LAST MODIFIED: 03/14/95   BY: ais  *G0HC*         */


/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 07/22/98   BY: *J2TB* Niranjan R.  */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb          */


      {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE repkupc_p_1 "Delete When Done"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


/*G0HC*/  define shared variable delete_pklst like mfc_logical initial no
                     label {&repkupc_p_1}.

/*G0HC*/  define buffer laddet for lad_det.


/*G0HC*/  /* ADDED SECTION TO DELETE 'FLAG' lad_det, AS WELL AS PICKLISTS
          THAT WERE CREATED THIS SESSION BUT SHOULD BE DELETED         */
/*G0HC*/  for each lad_det
              where   lad_site = string(mfguser,"x(10)")
              and     lad_loc  = "rps_det"
              and     lad_part = "rps_det"
              and     lad_lot  = "rps_det"
              and     lad_ref  = "rps_det"
              and     lad_dataset = "rps_det"
              and     lad_line = "rps_det" exclusive-lock:
              if delete_pklst
              then do:
                for each laddet
                    where laddet.lad_dataset = "rps_det"
/*J2TB**               and laddet.lad_nbr begins lad_det.lad_nbr */
/*J2TB*/               and trim(laddet.lad_nbr) begins trim(lad_det.lad_nbr)
                       and lad_line <> "rps_det" exclusive-lock:
                   if laddet.lad_qty_all <> 0 or
                      laddet.lad_qty_pick <> 0 then do:

                      find ld_det where ld_site = laddet.lad_site
                           and ld_loc = laddet.lad_loc
                           and ld_part = laddet.lad_part
                           and ld_lot = laddet.lad_lot
                           and ld_ref = laddet.lad_ref
                           no-error.
                      if available ld_det
                         then ld_qty_all = ld_qty_all - lad_qty_all
                                           - lad_qty_pick.

                      find in_mstr where in_site = lad_site
                                   and in_part = lad_part no-error.

                      if available in_mstr
                      then in_qty_all = in_qty_all - lad_qty_all
                                        - lad_qty_pick.
                   end.
                   delete laddet.
                end.
              end.
              delete lad_det.
/*G0HC*/  end.
