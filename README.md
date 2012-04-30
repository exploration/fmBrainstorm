fmBrainstorm
============

_Author: [Donald L. Merand](http://donaldmerand.com)_

fmBrainstorm is based around the idea of a brainstorm meeting.
Meeting attendees open up a brainstorm record, and add their ideas,
which are input by category. While they're adding ideas, a central
computer can optionally project a word cloud of the most popular ideas.

Note that if you want to share this file to more than one
computer/iPhone/iPad/etc., you'll have to turn on sharing in FileMaker.
To do this, go to File→Sharing→FileMaker Network… and click the “On”
radio button where it says “Network Sharing”. You only have to do this
from one computer - the other people connect to that computer using
File→Open Remote.


General Usage
=============

We believe that you should be able to do everything without your hands leaving the keyboard. I designed fmBrainstorm around that philosophy.

-   Apple-o - open an existing brainstorm. You can search in the “open”
    dialog.
-   Apple-n - create a new brainstorm
-   Apple-Shift-N - create a new brainstorm category
-   Apple-j / Apple-k - go to next category/previous category in list
    (loops around)
-   Apple-Shift-} / Apple-Shift-{ - go to next/previous idea in selected
    category (loops around)
-   tab - cycle between fields (shift-tab to go backwards)
-   Apple-Shift-E - export a brainstorm outline to the desktop
-   Red buttons delete, green buttons create, blue buttons perform
    actions.
    -   Note: When you delete a category, all ideas in that category are
        deleted as well. When you delete a brainstorm, all of its
        categories and ideas are deleted.


Word Cloud
==========

To use the word cloud application, you'll need to do a couple of things.

-   First, you need to install [Processing](http://processing.org)
-   Now, follow the steps outlined below in "Integrating FileMaker and Processing" to make sure your copy of Brainstorm is integrated into Processing.
-   Now, open up the `brainstorm_tagcloud.pde`, which should launch Processing
-   Find the part of the code that looks like this:

```
//SET THIS TO THE TITLE OF THE BRAINSTORM YOU WANT TO USE  
String brainstormTitle = "curriculum course ideas";
```

-   Replace the part in quotes with the title of the brainstorm you want
    to “cloud” (see note above about naming your brainstorms).
-   Now choose Sketch→Run from the menu bar at the top. If everything
    was set up right, you should see your cloud! At least, you will see
    a cloud once you start entering categories and ideas.
-   If something has gone wrong, Processing will show you the error it's
    having in the bottom portion of the screen. Call your IT person and
    tell them about the error.




Integrating FileMaker and Processing
====================================

It's nice sometimes to have programmatic access to FileMaker databases,
without always having to export/import files. Here's how you do it in
Processing using the JDBC connection feature of FileMaker.

1.  Open up your FileMaker database.
2.  Go to File→Sharing→ODBC/JDBC.
    1.  Make sure that ODBC Sharing is turned on.
    2.  Make sure that the specific file you want to share allows
        sharing
3.  You'll need your FileMaker installation disk. Mount it (or it's disk
    image) up, and navigate to the xDBC/JDBC directory.
4.  Copy the fmjdbc.jar file you find to
    /Library/Java/Extensions/fmjbc.jar . This allows you to use
    FileMaker JDBC access in Java, and Processing, files.

Okay! Your system is now ready to do some integratin'. You can find a sample of how you might do this in the `samples/` folder. Also check the `visualizations` folder to see a more involved example using the fmBrainstorm database. 
