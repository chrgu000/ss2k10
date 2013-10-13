/* mflabels.p - Perform security checking and set lables for menu            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*V8:ConvertMode=NoConvert                                                   */
/*K1Q4*/ /*V8:RunMode=Character                                              */
/* Revision: 8.5        Last modified: 06/05/96         By: rkc   *G1VJ*     */
/* Revision: 8.5        Last modified: 07/03/97     By: *J1VR* Cynthia Terry */
/* Revision: 8.5        Last Modified: 04/20/98     BY: *J2JB* Suhas Bhargave */
/* Revision: 8.6        Last Modified: 05/20/98     BY: *K1Q4* Alfred Tan     */
/* Revision: 9.0        Last Modified: 02/06/99     BY: *M06R* Doug Norton    */
/* Revision: 9.0        Last Modified: 03/13/99     BY: *M0BD* Alfred Tan     */
/* Revision: 9.1        Last Modified: 08/13/00     BY: *N0KR* myb            */

/*J2JB* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE
        FOR PERFORMANCE AND SMALLER R-CODE */

    {mfdeclre.i}
    {mf1.i}

        define shared variable proclabel like mnt_label extent 8
            format "x(36)".
        define shared variable procselect as integer extent 8.
        define shared variable procexec as character extent 8.
        define shared variable menu as character.
/*J1VR*/ define variable pLabel as character no-undo.
         for each mnd_det
/*J2JB*/ fields(mnd_canrun mnd_exec mnd_nbr mnd_select)
         no-lock where mnd_nbr = menu:
           if mnd_select > 0 and mnd_select <= 36 then do:

              {mfsec2.i &mndnbr=mnd_det.mnd_nbr &mndselect=mnd_det.mnd_select
                        &show_message=false}

              if can_do_menu then do:
/*J1VR*/      {gprun.i ""gpns2lbl.p"" "(mnd_det.mnd_nbr, mnd_det.mnd_select)"}
/*J1VR*/      assign pLabel = return-value.

/*J1VR*****************************************************************
        find mnt_det where mnt_nbr = mnd_nbr
            and mnt_select = mnd_select
            and mnt_lang = global_user_lang
            no-lock no-error.
             if available mnt_det then
******************************************************************J1VR*/

            assign
            proclabel[mnd_select] = proclabel[mnd_select]
/*J1VR*             + mnt_label. */
/*J1VR*/            + pLabel

         procselect[mnd_select] = mnd_select.
         procexec[mnd_select] = mnd_exec.
          end.
           end.
    end.
