/* xxputcimvariable.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/*
 *  {1}:
 *      "qq", 则打印变量的时候,补充上引号
 *      否则, 直接打印变量
 *  {2}:
 *      待打印的变量
 *  {3}:
 *      打印的位置. 例如 "at 1"
 */
 
if {1} = "qq" then do:
    put
        unformatted
        "~"" {3}
        {2}
        "~""
        " "
        .
end.
else do:
    put
        unformatted
        {2}
        {3}
        " "
        .
end.