

function createMenu(ItemSelected)
{

	var ItemSelectedTrimmed = '';
	
	var EndofArray;
    var EndofArray = UseArray.length;


   // FOR CHILD TESTING
	var HasChildren = 0;
	var IsTopParent = 0;
	var IsSubParent = 0;
	
	var LASTCHILD = '';
	var LASTTOPPARENT = '';
	var LASTSUBPARENT = '';
	
	var ItemSelectedString = ItemSelected + '.';
	
	var ItemSelectedLength = ItemSelectedString.length;

    var slimending = '<tr><td colspan="3" width="125" align="left" valign="middle"><img src="http://support.qad.com/images/blank.gif" width="125" height="1"></td></tr>';
	var healthyending = '<tr><td colspan="3" width="125" align="left" valign="middle"><img src="http://support.qad.com/images/blank.gif" width="125" height="15"></td></tr>';
		
	
	// FOR SIBLING TESTING
	if (ItemSelected.length > 2) {
		ItemSelectedTrimmed = String(ItemSelected).substring(0,(ItemSelected.length-2));
	}

  if (EndofArray > 0) {
  // There is Array Data
  
		// ITERATION #1 OF ARRAY - DIRECT CHILD TEST
		for(fa=0;fa<EndofArray;fa++)
		{

			//IF TOP LEVEL
				if ((ItemSelected.length <= 2) && (UseArray[fa][1].length <= 2 )) {
				IsTopParent = 1;
				LASTTOPPARENT = UseArray[fa][1];
				}
				
				// IF A PARENT WITH CHILDREN
				if ((UseArray[fa][1].indexOf(ItemSelectedString) != -1) && ( (ItemSelectedLength+2) == UseArray[fa][1].length ) ) {
				HasChildren = 1;
				LASTCHILD = UseArray[fa][1];
				}
				
				// EVERYTHING ON THE SAME LEVEL IN CASE IT DOESNT HAVE CHILDREN
				if ((ItemSelected.length > 2) &&  ((ItemSelected.length) == UseArray[fa][1].length) &&  (UseArray[fa][1].indexOf(ItemSelectedTrimmed) != -1) ) {
				LASTSUBPARENT = UseArray[fa][1];
				}
			
				
		}
		// BACK #1

        if ((IsTopParent != 1) || (HasChildren != 1)) {
			IsSubParent = 1;
		}

        document.write('<table width="137" border="0" cellpadding="0" cellspacing="0">');

        // ITERATION #2 OF ARRAY - PAINT SELECTED PORTIONS OF ARRAY
		for(x=0;x<EndofArray;x++)
		{



		targetstring = '';
		stringToDraw = '';
		nwtoDraw = '';
		dopaint = 0;


            // STRING PROCESSING -----------

			if (UseArray[x][3] != '') {
				//Has a Target
				targetstring = ' target="'+UseArray[x][3]+'"';
			}
		
			if (ItemSelected == UseArray[x][1]) {
				// HIGHLIGHT THE SELECTED LEVEL
				stringToDraw = '<font class="navtxt">'+UseArray[x][0]+'</font>';
			} else {
				if (UseArray[x][3] == '_blank') {
				nwtoDraw = ' onclick="nw(\''+ UseArray[x][2]+'\');return false;"';
				} else if (UseArray[x][3] == '_support') {
				nwtoDraw = ' onclick="sw(\''+ UseArray[x][2]+'\');return false;"';
				}
				
				stringToDraw = '<font class="navtxt"><a class="three"' + nwtoDraw + ' href="'+ UseArray[x][2]+'"'+targetstring+'>'+UseArray[x][0]+'</a></font>';
			}

			// END STRING PROCESSING -----------

			if (HasChildren == 1) {
				
  				// Paint Just the Children if the item has children
				if ((UseArray[x][1].indexOf(ItemSelectedString) != -1) && ( (ItemSelectedLength+2) == UseArray[x][1].length ) ) 
				{
				  dopaint = 1;
				}

			} else {
				
				if ((ItemSelected.length <= 2) && (UseArray[x][1].length <= 2 )) {
				// A TRUE TOP LEVEL PARENT
				   dopaint = 1;
				} else if ((ItemSelected.length > 2) &&  ((ItemSelected.length) == UseArray[x][1].length) &&  (UseArray[x][1].indexOf(ItemSelectedTrimmed) != -1) ) {
				// SUB LEVEL, NO CHILDREN, PAINT SIBLINGS
				   dopaint = 1;
				}
				
			}

			    if (UseArray[x][4] != '') {
					sectionarrowString = '<img src="http://support.qad.com/images/arrow7C95CB.gif" width="7" height="11">';
				} else {
					sectionarrowString = '<img src="http://support.qad.com/images/blank.gif" width="7" height="11">';
				}
			

			    if (dopaint == 1) {
					
					document.write('<tr>');
					document.write('<td width="7" align="left" valign="top">');
					document.write(sectionarrowString);
					document.write('</td>');
					document.write('<td width="5" align="left" valign="middle"><img src="http://support.qad.com/images/blank.gif" width="5" height="1"></td>');
					document.write('<td width="125" align="left" valign="middle">');
					document.write(stringToDraw);		
					document.write('</td>');
					document.write('</tr>');				
		
		      	  ////////// DRAW THE END SPACING
                   if ((IsTopParent == 1)  && (UseArray[x][1] == LASTTOPPARENT)) {
						// Slim ending for the last top parent that occurs anywhere in the array
						document.write(slimending);
				   } else if ((IsSubParent == 1)  && (UseArray[x][1] == LASTSUBPARENT)) {
						// Slim ending for the last subparent anywhere in the array
						document.write(slimending);
				   } else if ((HasChildren == 1)  && (UseArray[x][1] == LASTCHILD)) {
						// Slim ending for the last child anywhere in the array
						document.write(slimending);
				   } else { 
					    document.write(healthyending);
				   }
				   // END CHILDREN ENDING

				}
				// END DOPAINT IF
	
		}
		// BACK #2
		
	document.write('</table>');
   
   } 
   // END IF THERE IS ARRAY DATA
   
}
// END FUNCTION

function createResourcesHR()
{
	document.write('<hr width="69" align="left">');
}