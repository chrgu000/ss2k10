/* xsbcvariable01.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

define shared variable mfguser as character.
define shared variable batchrun as logical.

define variable sTitle as character format "x(50)" no-undo.
define variable sMessage as character format "x(50)" no-undo.
define variable sPromptMessage as character format "x(50)"no-undo.
define variable sConfirmOrExit as character format "x(50)"no-undo.
define variable sConfirm as character initial "Y" no-undo.
define variable sExitFlag as character initial "" no-undo.
define variable sSpecialExitFlag as character initial "E" no-undo.
define variable sPart as character no-undo.
define variable sLot as character no-undo.
define variable sVendor as character no-undo.
define variable sDelimiter as character initial "$" no-undo.
define variable iTrSeq as integer no-undo.

sPromptMessage = "输入或按" + sExitFlag + "退出".
sConfirmOrExit = "按" + sConfirm + "确认或按" + sExitFlag + "退出".