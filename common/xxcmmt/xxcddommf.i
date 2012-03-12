/* xxcdommf.i - domain line for different EV                                 */
/* REVISION: 23YB LAST MODIFIED: 11/18/10   BY: zy                           */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

/*  When you run for mfg/pro EB2.1 please not remark domain line             */
/*  else remarkit                                                            */


if frame-field = "cd_domain"
then do:
   {mfnp05.i cd_det cd_ref_type
      " cd_domain  = input cd_domain "
      cd_domain "input cd_domain"}
end.
else