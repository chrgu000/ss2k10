/* xsreadkey.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/08/2009   By: Kaine Zhang     Eco: *ss_20090708* */


readkey pause wtimeout.
if lastkey = -1 then quit.
apply lastkey.