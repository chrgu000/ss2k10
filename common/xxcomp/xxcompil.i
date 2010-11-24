/* xxcompil.i - INCLUDE FILE TO MOVE FILES FOR UTCOMPIL                      */
/*            - Modify from utcompil.i                                       */
/* REVISION: 0BYJ LAST MODIFIED: 11/19/10   BY: zy                           */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

if dirname <> "mf" then do:
   if opsys = "unix" then do:
      unix silent mkdir value(destDir + "/" + lng).
      unix silent mkdir value(destDir + "/" + lng + "/" + dirname).
   end.
   else
   if opsys = "msdos" or opsys = "win32" then do:
      dos silent mkdir value(destDir + "\\" + lng + "\\" + dirname).
   end.
   /* MOVE FILES */
   if opsys = "unix" then do:
      unix silent value("mv " + destDir + "/" + dirname + "*.r "
                              + destDir + "/" + lng + "/" + dirname).
      unix silent value("mv src/" + destDir + "/" + dirname + "*.r "
                                  + destDir + "/" + lng + dirname).
   end.
   else
   if opsys = "msdos" or opsys = "win32" then do:
      dos silent value("copy " + destdir + "~\" + dirname + "*.r "
                               + destDir + "~\" + lng + "~\" + dirname).
      dos silent value("del " + destdir + "~\" + dirname + "*.r").
      dos silent value("copy src~\" + destdir + "~\" + dirname + "*.r "
                              + destDir + "~\" + lng + "~\" + dirname).
      dos silent value("del src~\" + destdir + "~\" + dirname + "*.r").
   end.
end.  /* if dirname <> "mf" */
else do:
   /* MOVE FILES TO CURRENT DIRECTORY */
   if opsys = "unix" then do:
      unix silent value("mv src/" + destDir + "/" + dirname + "*.r "
                              + destDir).
   end.
   else
   if opsys = "msdos" or opsys = "win32" then do:
      dos silent value("copy src~\" + destDir + "~\" + dirname + "*.r "
                                    + destDir).
      dos silent value("del src~\" + destDir + "~\" + dirname + "*.r").
   end.
end.
