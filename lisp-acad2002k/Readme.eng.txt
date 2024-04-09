/////////////////////////////////////////////////////////////////////////
// file name : Readme_Eng.txt
// person in charge : arx119@empal.com / IMS: arx119@hotmail.com
// date of issue : 2003/ 11 /18
// date of update
//        : 2006/ 12/ 12 (2.0.0.2)	
//        : 2006/ 11/ 20 (2.0.0.1)	
//        : 2006/ 05/ 27 (1.0.0.72)	
//        : 2006/ 05/ 16 (1.0.0.71)
//        : 2006/ 04/ 17 (1.0.0.70)
//        : 2006/ 03/ 31 (1.0.0.69)
//        : 2006/ 03/ 28 (1.0.0.68)
//        : 2005/ 11/ 17 (1.0.0.68)
//        : 2005/ 06/ 20 (1.0.0.67)
//        : 2005/ 06/ 20 (1.0.0.66)
//        : 2005/ 06/ 20 (1.0.0.65)
//        : 2005/ 06/ 05 (1.0.0.64)
//        : 2005/ 03/ 12 (1.0.0.63)
//        : 2005/ 03/ 09 (1.0.0.62)
//        : 2005/ 02/ 28 (1.0.0.61)
//        : 2005/ 01/ 27 (1.0.0.60)
//        : 2005/ 01/ 07 (1.0.0.59)
//        : 2004/ 09/ 29 (1.0.0.59)
//        : 2004/ 06/ 16 (1.0.0.58)
//        : 2004/ 04/ 24 (1.0.0.57)
//        : 2004/ 01/ 19 (1.0.0.56)
//        : 2004/ 01/ 02 (1.0.0.55)
//        : 2003/ 08/ 30
// VERSION : iDwgTab™ 1.0 - Released
//         : iDwgTab™ 2.0 - Released (2.0.0.1)
/////////////////////////////////////////////////////////////////////////

==============
* description
 ~~~~~~~~~~~~~
iDwgTab™ is a Freeware utility program produced by BizIcom which is can be
used by anybody. It is debugged and improved continuously by us.

iDwgTab™ is an utility program running on the AutoCAD R2000 or above.
It makes it easy for you to manipulate multi windows on AutoCAD2000 program.
It's so easy that user need not to learn about it.
Please read the below.

iDwgTab2000.arx runs on AutoCAD (LT)2000/2000i/2002.
iDwgTab2004.arx runs on AutoCAD (LT)2004/2005/2006.
iDwgTab2007.arx runs on AutoCAD (LT)2007.


========================================================
* Program function
 ~~~~~~~~~~~~~~~
- iDwgTab™ runs on AutoCAD and LT.
  (but, LT needs the arx utility)

- icon is available for DWG/DXF file.

- right mouse button is used on tab key.
  (close, close all, windows commands, ...)

- the whole path and drawing information can be seen by tooltip of active tab
key.

- the command can be executed to all the opened documents through script file.

  ex) mouse on tab -> right mouse click -> select Script...
      -> command execution to all the drawing

      test.scr
      -------
      zoom
      e
      plot

  (remarks) When you want to apply script to many drawings, you should check the
routine
of script. If any error, it happens to all the drawings. In this case, please
close all the files.
  
- drawing preview / file information

- arrangement of opened drawings

- to find and activate an opened drawing (ex: "a*.dwg")

- function to modify the context menu (reference: iDwgTab.ini)
- function to change the languages (reference: iDwgTab.ini)
- Thumb Nail Image is available on the context menu
- You can check the drawing information on the tooltip of tab
- The layout of drawing can be active immediately
- I can open all the active drawings and close all the inactive drawings
- function to save all the opened drawings (with the option of Zoom & Extents)
- The opened drawing can be saved into another folder
- function to close all the opened drawings with saving
- function to close all the opened drawings without saving
- all the opened drawings can be showed in cascade
- horizontal tile
- vertical tile
- arrangement of icom
- Script File (SCR) can be executed on the opened drawing
- all the drawings can be show in the ascending order
- all the drawings can be show in the descending order
- a drawing can be searched by the similar name among the opened drawings
- the dialog box is availabe for setting invironment
- user can design the context menu (user can register some commands)
- the upper directory can be opened above the selected drawing
- the order of tabs can be made by Ctrl, shift and arrow keys
- the file is opened by dragging through tab control
- the menu of right mouse is placed in reverse when the position of tab docking
is bottom (id:pillager)
- when the drawing is open, the position of tab is sorted (id:daum2704442)
- function to open easily the previously opened drawing (id:kaka568)
- the unused menu can be hided
- taps can be selected in multiple like in Excel (id:lechen, cloudx)
- the close button on tab is available
- the version of drawing is shown on tab icon
- the version of drawing is shown on icon
- the direct selection by Ctrl+Tab
- Script can be executed to the selected tap
- The size of Tab can be made by the size of font







================
* program test
 ~~~~~~~~~~~~~~~

O.S     : Windows 2000,Windows XP, Explorer 6.0
AutoCAD : R2000(Kor)/
          R2000i(Eng)/
          R2002(Eng)/
          R2004(Kor)/
          R2005(Beta,Demo)/R2005(Kor)
          R2006/ R2006(Eng)
          R2007(Eng)

          LT2000(Kor)/
          LT2000i(Eng)/
          LT2002(Kor)/
          LT2004(Kor)/ LT2004(Eng)
          LT2005/
          LT2006(Kor) / LT2006(Eng)
          LT2007(Kor)

We confirm that this program never contains any virus codes for bad functions or
information collecting.


- list of files
 LangugePack<directory>
 ScreenShot <directory>
 Scripts    <directory>
 ctxmenu.xml
 iDwgTab2000.arx
 iDwgTab2004.arx
 iDwgTab2007.arx
 iDwgTab.xml
 Readme_kor.txt
 Readme_eng.txt


==================
* program installation
 ~~~~~~~~~~~~~~~~~

iDwgTab™ can be loaded independently and run as below.
(zip contents should be in the same directory. It runs by 'ini' file)

- designate the arx program at 'appload'         : Application
- (arxload "iDwgTab2000/2004.arx")               : Lisp
- add "iDwgTab2000.arx" or "iDwgTab2004.arx"     : acad.rx
- acedLoadModule("iDwgTab2000/2004.arx", true)   : ObjectARX


==========================
* notice
 ~~~~~~~~~~~~~~~~~~~~~~~~

iDwgTab™ is a 100% Freeware.
However if you want to pack this program into the commercial 3rd-party
program에서 함께
Packing, please contact us 'arx119@empal.com' for support.


===================
* multi language
~~~~~~~~~~~~~~~~~~~

It's easy. You can set #LANGUAGE value in the file of iDwgTab.ini.

If you want to set English, you can do as below.
#LANGUAGE = ENGLISH,

If you want to set Korean, you can do as below.
#LANGUAGE = KOREAN,

ENGLISH, KOREAN is the table name for the language.


=======================
* program update
 ~~~~~~~~~~~~~~~~~~~~~~
 1.0.0.2  : tabbar size adjustment, debugging of Saveas error, preview function

 1.0.0.3  : tooltip function, language selection, BOTTOM docking

 1.0.0.4  : local command of 'close' suggested by "Klaus Dorwarth"

 1.0.0.5  : script/save all function suggested by 'MIN' of GoCad.
	    Tab control is not seen when only one drawing is opened.

1.0.0.51 : debugging of plot script
           debugging of a problem which occurs when one drawing is opened and
closed more than one time.
	   (supplied script samples do not run if the language of AutoCAD is
different.)

1.0.0.52 : debugging of repeating of script
           (remarks)
           - please check whether the script runs in AutoCAD.
           - If script in iDwgTab is closed properly, the script take place
every time when the drawing is active.
             In this case, please close all the drawings.

1.0.0.53 : Layout Converting function
           memo in preview of basic drawing can be printed out.

1.0.0.55 : debugging of error in exercuting of script command
           sorting of tab in ascending or descending order
           easy finding function of drawing to be active
           (Sort version)

1.0.0.56 : The command of 'close all' will save the files first and close them.

1.0.0.57 : uses can select tab size of icon, ommision mark, extension mark
           Popup menu can close drawings except active ones

	   additional functions in iDwgTab.ini

	   ;Tab icon use
           #TABICON  = ON
           ;#TABICON  = OFF

           ;file extension showing
           #TABEXT  = ON
           ;#TABEXT  = OFF

           ;ommision mark for file name, , 0 is not used , positive number above
5
           #TABSHORTEN  = 10
           ;#TABSHORTEN  = 0


1.0.0.58 : function of changing of active tab position suggested by Mr. Hong
Sung Hyun (email72 version)

           [key combination]
           Ctrl + LEFT (arrow key) : to move the active tab to the previous
position
           Ctrl + RIGHT (arrow key) : to move the active tab to the next
position
           Ctrl + UP   (arrow key) : to move the active tab to the first
position
           Ctrl + DOWN (arrow key) : to move the active tab to the last position

           Shift + LEFT (arrow key) : to make the previous tab active
           Shift + RIGHT (arrow key) : to make the next tab active
           Shift + UP   (arrow key) : to make the first tab active
           Shift + DOWN  (arrow key): to make the last tab active

1.0.0.59 : function of tab color & icon changing in Read only suggested by Mr.
Robert Plummer

	   ;value setting in ini can be done in dialog box
           #TABICON	
           #TABEXT
           #TABSHORTEN

           - recognizing of tab icon and character color in Read only
           - environment and autoloading can be selected by 'start up' dialog
box
           - command of closing all the opened drawings without saving

1.0.0.59 : debugging of error of CAD closing when the Ctrl key pressed after
closing all the drawings.
         : adding of closing option as zoom or extend when the drawing is saved.
1.0.0.60 : debugging of the error advised by Mr. Robert Plummer.
           (problems of Shift and Ctrl keys using. the error of showing "Cancel"
in the command window of the second drawing.
1.0.0.61 : debugging of script function problem advised by MIN user who are
using GoCAD.
           It makes the script function perfect now which was imperfect before.
           (the sample script may be different according the systems.
1.0.0.62 : debugging of TAB dissapearing when Esc or Enter keys are pressed
while TAB control is selected.
1.0.0.63 : The file is opened if the multi files are selected and draged and
droped over the TAB control.          
1.0.0.64 : the mark of modification is shown on tap icon. The shell menu and
upper folder
           opening can be done by the right clicking on the drawing
1.0.0.65 : The opened drawings can be saved into any folder.
           The function of opening of the recently opened drawing is availabe.
           (some options for opening and saving can be set in the invironment
setting

1.0.0.66 : the user revised version of the context menu.
           the XML stucture is applied for user to design the context menu.
           the context menu is the pop-up menu which is opened by the mouse
right click.

1.0.0.67 : the completion of user's context menu. the shell menu is deleted.

[example of user's menu]

<menu>
	<item name="&Spelling">_spell</item>
	<item name="[--]"></item>
	<group name="user menu">
		<item name="menutest1">명령1</item>
		<item name="menutest2">명령2</item>
		<item name="menutest3">명령3</item>
	</group>
</menu>

               |
               V
-----------------
| Spelling       |
-----------------  --------------
| user menu   ->  |menutest1 |
--------------------            -
                   |menutest2 |
                   -            -
                   |menutest3 |
                   --------------

-XML schima

menu : context menu

item : menu item

name : string of character in the context menu
       [--] is the horizontal line

group : lower menu


1.0.0.68 : debug of unchanged name after the execution of 'saveas' command


1.0.0.68+: AutoCAD R2007 modules are added

1.0.0.69 : when the position of tab docking is bottom, the menu of right mouse
is displayed in reverse order.
           The tap position is determinded by sort when the drawing is opened
(by the option of invironment setting)

1.0.0.70 : the function of 'favorite' is to open easily the previously opened
drawing.
           the commands are 'favorite', 'add a drawing to favorite', 'delete a
drawing from favorite'
           'open all the favorite' and 'favorite build with the opened files'
           If you select 'Recent file Open(favorites)', the drawing is opened
from 'favorite'

1.0.0.71 : Many drawings can be selected by Ctrl or Shift keys.

1.0.0.72 : debug of tap closing of multi selection in 2004~2007 versions
           the icon of version can be used by invironment setting
           the option of tap showing even when a single drawing is opened.
           the switching of drawing is done easily by Ctrl+Tab keys

1.0.1.72 : debug of not working script
           debug of CAD closing when frequent closing all the drawing





We didn't get any permission for mentioning the name of suggester above.
If you don't want to be mentioned, please let us know.
We appreciate again for your supporting.


==================
* program updating
 ~~~~~~~~~~~~~~~~~

(http://www.icomtools.com)

If you have any suggestion or error report, please contact us 'arx119@empal.com'
Thank you!

