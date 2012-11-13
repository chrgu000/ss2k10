define variable sInputFile as character no-undo.
define variable sOutputFile as character no-undo.
define variable dteTrDate like tr_date no-undo.
define variable iTrSeq like tr_trnbr no-undo.
define variable iCimMsgNum as integer no-undo.

assign
    dteTrDate = today
    iTrSeq = 0
    .


