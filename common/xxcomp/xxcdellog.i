/*xxcdellog.i - delete logfile                                               */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

os-delete value(vWorkLog) no-error.
if '{1}' <> 'log' then do:
   os-delete value(vworkfile) no-error.
end.
