/////////////////////////////////////////////////////////////////////////
// file name : Readme_Eng.txt
// person in charge : arx119@empal.com
// date of issue : 2003/ 06/ 22
// date of update 
//        : 2003/ 08/ 30
//        : 2004/ 01/ 02 (1.0.0.55)
//        : 2004/ 01/ 19 (1.0.0.56)
//	  : 2004/ 04/ 24 (1.0.0.57)
//        : 2004/ 06/ 16 (1.0.0.58)
//        : 2004/ 09/ 29 (1.0.0.59)
//        : 2005/ 01/ 07 (1.0.0.59)
//        : 2005/ 01/ 27 (1.0.0.60)
//        : 2005/ 02/ 28 (1.0.0.61)
//        : 2005/ 03/ 09 (1.0.0.62)
//        : 2005/ 03/ 12 (1.0.0.63)
//	  : 2005/ 06/ 05 (1.0.0.64)
//	  : 2005/ 06/ 20 (1.0.0.65)
//	  : 2005/ 06/ 20 (1.0.0.66)
//	  : 2005/ 06/ 20 (1.0.0.67)
//	  : 2005/ 11/ 17 (1.0.0.68)
//	  : 2006/ 03/ 28 (1.0.0.68)
//	  : 2006/ 03/ 31 (1.0.0.69)
//	  : 2006/ 04/ 17 (1.0.0.70)
// version : iDwgTab™ 1.0 - Released
/////////////////////////////////////////////////////////////////////////

==============
* description 
 ~~~~~~~~~~~~~

iDwgTab™ is an utility program running on the AutoCAD R2000 or above.
It makes it easy to manipulate multi windows on AutoCAD2000 application program.
It's so easy that user need not to learn about it. 
Please read the below.

iDwgTab2000.arx runs on AutoCAD (LT)2000/2000i/2002.
iDwgTab2004.arx runs on AutoCAD (LT)2004/2005/2006.
iDwgTab2007.arx runs on AutoCAD (LT)2007.


================
* program test
 ~~~~~~~~~~~~~~~

O.S     : Windows 2000,Windows XP, Explorer 6.0
AutoCAD : R2000(Kor)/R2000i(Eng)/R2002(Eng)/R2004(Kor)/R2005(Beta,Demo)/R2006/R2007
          LT2000(Kor)/LT2000i(Eng)/LT2002(Kor)/LT2004(Kor)/LT2005/LT2006

We confirm that this program never contains any virus codes for bad functions or information collecting.


- list of files 

 ScreenShot <directory>
 Scripts    <directory>
 iDwgTab.ini
 iDwgTab2000.arx
 iDwgTab2004.arx
 iDwgTab2007.arx
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
However if you want to pack this program into the commercial 3rd-party program에서 함께 
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

================
* Program function
 ~~~~~~~~~~~~~~~

- iDwgTab™ runs on AutoCAD and LT. 
  (but, LT needs the arx utility)

- icon is available for DWG/DXF file.

- right mouse button is used on tab key.
  (close, close all, windows commands, ...)

- the whole path and drawing information can be seen by tooltip of active tab key.

- the command can be executed to all the opened documents through script file.

  ex) mouse on tab -> right mouse click -> select Script...
      -> command execution to all the drawing 

      test.scr 
      ------- 
      zoom
      e
      plot

  (remarks) When you want to apply script to many drawings, you should check the routine
of script. If any error, it happens to all the drawings. In this case, please close all the files.
   
- drawing preview / file information

- arrangement of opened drawings

- to find and activate an opened drawing (ex: "a*.dwg")

=======================
* program update
 ~~~~~~~~~~~~~~~~~~~~~~
 1.0.0.2  : tabbar size adjustment, debugging of Saveas error, preview function

 1.0.0.3  : tooltip function, language selection, BOTTOM docking

 1.0.0.4  : local command of 'close' suggested by "Klaus Dorwarth"

 1.0.0.5  : script/save all function suggested by 'MIN' of GoCad.
	    Tab control is not seen when only one drawing is opened.

1.0.0.51 : debugging of plot script 
           debugging of a problem which occurs when one drawing is opened and closed more than one time.
	   (supplied script samples do not run if the language of AutoCAD is different.)

1.0.0.52 : debugging of repeating of script 
           (remarks)
           - please check whether the script runs in AutoCAD.
           - If script in iDwgTab is closed properly, the script take place every time when the drawing is active.
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

           ;ommision mark for file name, , 0 is not used , positive number above 5
           #TABSHORTEN  = 10
           ;#TABSHORTEN  = 0


1.0.0.58 : function of changing of active tab position suggested by Mr. Hong Sung Hyun (email72 version)

           [key combination]
           Ctrl + LEFT (arrow key) : to move the active tab to the previous position
           Ctrl + RIGHT (arrow key) : to move the active tab to the next position
           Ctrl + UP   (arrow key) : to move the active tab to the first position
           Ctrl + DOWN (arrow key) : to move the active tab to the last position

           Shift + LEFT (arrow key) : to make the previous tab active
           Shift + RIGHT (arrow key) : to make the next tab active 
           Shift + UP   (arrow key) : to make the first tab active 
           Shift + DOWN  (arrow key): to make the last tab active

1.0.0.59 : function of tab color & icon changing in Read only suggested by Mr. Robert Plummer

	   ;value setting in ini can be done in dialog box 
           #TABICON	
           #TABEXT
           #TABSHORTEN

           - recognizing of tab icon and character color in Read only
           - environment and autoloading can be selected by 'start up' dialog box
           - command of closing all the opened drawings without saving

1.0.0.59 : debugging of error of CAD closing when the Ctrl key pressed after closing all the drawings.
         : adding of closing option as zoom or extend when the drawing is saved.
1.0.0.60 : debugging of the error advised by Mr. Robert Plummer.
           (problems of Shift and Ctrl keys using. the error of showing "Cancel" in the command window of the second drawing.
1.0.0.61 : debugging of script function problem advised by MIN user who are using GoCAD.
           It makes the script function perfect now which was imperfect before.
           (the sample script may be different according the systems.
1.0.0.62 : debugging of TAB dissapearing when Esc or Enter keys are pressed while TAB control is selected.
1.0.0.63 : The file is opened if the multi files are selected and draged and release over the TAB control.           
1.0.0.64 :
1.0.0.65 :
1.0.0.66 :
1.0.0.67 :

We didn't get any permission for mentioning the name of suggester above. 
If you don't want to be mentioned, please let us know.
We appreciate again for your supporting.


==================
* program updating
 ~~~~~~~~~~~~~~~~~

(http://www.icomtools.com)

If you have any suggestion or error report, please contact us 'arx119@empal.com'
Thank you!

