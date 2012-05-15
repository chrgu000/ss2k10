/* xxcompile.i - compile procedure parameter file                            */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */

define {1} shared variable c-comp-pgms as character format "x(20)" no-undo.
define {1} shared variable vWorkFile as character initial "utcompile.wrk" no-undo.
define {1} shared variable lng as character format "x(2)" no-undo.
define {1} shared variable kbc_display_pause as integer initial 3 format ">9" no-undo.
define {1} shared variable xrcDir as character format "x(160)" no-undo.
define {1} shared variable destDir as character format "x(160)" no-undo.
define {1} shared variable v_oldpropath as character no-undo.
define {1} shared variable v_DirSepChr as character no-undo.
define {1} shared variable v_comppropath as character no-undo.
define {1} shared variable v_incdestpropath as character no-undo.
