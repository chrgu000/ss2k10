/* xsbcvariable01.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

define shared variable mfguser as character.
define shared variable batchrun as logical.
define shared variable global_userid as character .
define shared variable global_user_lang_dir as character.
define shared variable execname as character.
define shared variable global_gblmgr_handle as handle no-undo.



define variable sTitle as character format "x(50)" no-undo.
define variable sMessage as character format "x(50)" no-undo.
define variable sPromptMessage as character format "x(50)" no-undo.
define variable sConfirmOrExit as character format "x(50)" no-undo.
define variable sConfirm as character initial "Y" no-undo.
define variable sExitFlag as character initial "" no-undo.
define variable sSpecialExitFlag as character initial "E" no-undo.
define variable sPart as character no-undo.
define variable sLot as character no-undo.
define variable sVendor as character no-undo.
define variable sDelimiter as character initial "-" no-undo.
define variable iLastHyphen as integer no-undo.
define variable iTrSeq as integer no-undo.
define variable ciminputfile   as character .
define variable cimoutputfile  as character .



sPromptMessage = "输入或按" + sExitFlag + "退出".
sConfirmOrExit = "按" + sConfirm + "确认或按" + sExitFlag + "退出".

define variable sCscfLoc as character initial "Cscf" no-undo.
define variable sOutLoc as character initial "Out" no-undo.
define variable sWorkPlaceLoc as character initial "Workplace" no-undo.
define variable sQadType as character extent 4 no-undo.
define variable sBarcodeType as character extent 15 no-undo.
define variable bCanAssemble as logical no-undo.
define variable sAssembleFlag as character no-undo.
define variable sAssemblePart as character no-undo.
define variable sWoLot as character no-undo.
define variable sWoNbr as character no-undo.


define variable sectionid as integer init 0 .
define variable WMESSAGE  as char format "x(80)" init "".
define variable wtm_num   as char format "x(20)" init "0".
define variable wtm_fm    as char format "x(16)".
define variable wsection as char format "x(16)".
define variable i as integer .
define variable wtimeout as integer init 99999 .
define variable usection as char format "x(16)".





assign
    sQadType[1] = "RCT-WO"
    sQadType[2] = "ISS-TR"
    sQadType[3] = "RCT-TR"
    sQadType[4] = "ISS-SO"
    .
    
assign
    sBarcodeType[1]     = "RCT-WO"
    sBarcodeType[2]     = "ISS-TR"
    sBarcodeType[3]     = "RCT-TR"
    sBarcodeType[4]     = "ISS-SO"
    sBarcodeType[11]    = "ISS-X-WO"
    sBarcodeType[12]    = "RCT-X-WO"
    sBarcodeType[13]    = "RCT-X-SO"
    .


