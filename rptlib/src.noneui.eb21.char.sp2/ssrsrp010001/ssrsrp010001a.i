/* rsrp01.i - Release Management Supplier Schedules                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*F0PN*/ /*V8:ConvertMode=Report                                            */
/* REVISION: 7.0    LAST MODIFIED: 01/29/92           BY: WUG *F110*        */
/* REVISION: 7.0    LAST MODIFIED: 06/30/92           BY: WUG *F747*        */
/* REVISION: 7.4    LAST MODIFIED: 09/29/93           BY: WUG *H142*        */
/* REVISION: 8.5    LAST MODIFIED: 02/26/96     BY: *J0CV* Brandy J Ewing   */
/* REVISION: 8.5    LAST MODIFIED: 04/16/96           BY: kjm *G1T0*        */
/* REVISION: 9.0    LAST MODIFIED: 07/12/98     BY: *K1QY* Pat McCormick    */
/* REVISION: 9.0    LAST MODIFIED: 03/13/99     BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00     BY: *N0KP* myb              */
/* $Revision: 1.11 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/* $Revision: 1.11 $ BY: Bill Jiang DATE: 08/07/08 ECO: *SS - 20080807.1* */
/*-Revision end---------------------------------------------------------------*/


/* SCHEDULE REPORT INCLUDE */

if current_ind then do:
   find sch_mstr  where sch_mstr.sch_domain = global_domain and  sch_type =
   schtype
/*K1QY   + 3                                        /*F747*/   */
   and sch_nbr = pod_nbr and sch_line = pod_line
/*G1T0*/ and sch_cr_date >= date_from and sch_cr_date <= date_to
/*K1QY   and sch_rlse_id = pod_curr_rlse_id[schtype /*F747 + 3 */]  */
/*K1QY*/   and sch_rlse_id = pod_curr_rlse_id[schtype - 3]
   no-lock no-error.
   if available sch_mstr then do:
      /*F747 CHANGED FOLLOWING FROM rciq1a.p TO rsiq1a.p*/
/*K1QY      {gprun.i ""rsiq1a.p"" "(input schtype + 3,     */
      /* SS - 20080807.1 - B */
      /*
/*K1QY*/      {gprun.i ""rsiq1a.p"" "(input schtype,
                 input pod_nbr, input pod_line, input sch_rlse_id,
                 input no, input yes)"}
      */
/*K1QY*/      {gprun.i ""ssrsrp010001iq1a.p"" "(input schtype,
                 input pod_nbr, input pod_line, input sch_rlse_id,
                 input no, input yes)"}
      /* SS - 20080807.1 - E */
/**J0CV**ADDED LAST INPUT ABOVE TO SPECIFY THAT ERS FIELDS SHOULD BE SHOWN**/
/**J0CV**                          input no)"}    **/

   end.
end.
else do:
   for each sch_mstr no-lock
/*K1QY   where sch_type = schtype + 3  */
    where sch_mstr.sch_domain = global_domain and  sch_type = schtype
   and sch_nbr = pod_nbr and sch_line = pod_line
   and sch_cr_date >= date_from and sch_cr_date <= date_to
   by sch_cr_date by sch_cr_time:
      /*F747 CHANGED FOLLOWING FROM rciq1a.p TO rsiq1a.p*/
/*K1QY      {gprun.i ""rsiq1a.p"" "(input schtype + 3,    */
      /* SS - 20080807.1 - B */
      /*
/*K1QY*/    {gprun.i ""rsiq1a.p"" "(input schtype,
                  input sch_nbr, input sch_line, input sch_rlse_id,
                  input no, input yes)"}
      */
/*K1QY*/    {gprun.i ""ssrsrp010001iq1a.p"" "(input schtype,
                  input sch_nbr, input sch_line, input sch_rlse_id,
                  input no, input yes)"}
      /* SS - 20080807.1 - E */
/**J0CV**ADDED LAST INPUT ABOVE TO SPECIFY THAT ERS FIELDS SHOULD BE SHOWN**/
/**J0CV**                              input no)"}   **/
   end.
end.
