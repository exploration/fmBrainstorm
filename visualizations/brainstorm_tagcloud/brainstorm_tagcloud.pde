/*
written by Donald Merand
visualizes the brainstorm items currently being entered in the brainstorm DB, as a tag cloud
you need to have the file brainstorm.fp7 open for this sketch to make any sense.

adopted from Processing Tag Cloud Demo, using
MCavallo's OpenCloud Library
>> http://opencloud.mcavallo.org/
>> http://sourceforge.net/users/mcavallo
 
Press the mouse to see the words reorganized by weight instead of alphabetically.
Press the "g" key to get a screenshot
*/

import org.mcavallo.opencloud.*;
import java.sql.*;
import java.io.*;

//set this to the title of the running brainstorm
String brainstormTitle = "curriculum course ideas";
float  maxWordDisplaySize = 50.0;
int    maxNumTags = 200;
int    refreshRate = 60;

Cloud  cloud;
String ideas[] = new String[0];

PFont  theFont = createFont ("GillSans", 48);
 
//================================================================
void setup() {
  frameRate(15);
  size (800,600);
  textFont (theFont);
  createCloud(); //loads the data, stores it in a Cloud object
}
 
void draw() {
  if (frameCount % refreshRate == 1) { createCloud(); } //every five seconds refresh the data
  
  background (0);
  print_logo(); //props
  
  List tags = cloud.tags();
  int nTags = tags.size();

  // Sort the tags in reverse order of size.
  if (mousePressed) { tags = cloud.tags(new Tag.ScoreComparatorDesc()); }
   
  float xMargin = 20;
  float ySpacing = 30;
  float xPos = xMargin; // initial x position
  float yPos = 40;      // initial y position
  
  for (int i=0; i<nTags; i++) {
    // Fetch each tag and its properties.
    // Compute its display size based on its tag cloud "weight";
    // Then reshape the display size non-linearly, for display purposes.
    Tag aTag = (Tag) tags.get(i);
    String tName = aTag.getName();
    float tWeight = (float) aTag.getWeight();
    float wordSize =  maxWordDisplaySize * ( pow (tWeight/maxWordDisplaySize, 0.6));
     
    // Draw the word
    textSize(wordSize);
    //alternate fill color
    if (i%2==0) {
      fill (255, 153, 0); // explo orange
    } else {
      fill (0, 102, 255); // explo blue
    }
    text (tName, xPos,yPos);
 
    // Advance the writing position.
    xPos += textWidth (tName) + 4.0;
    if (xPos > (width - (xMargin*7))) { //sort of an arbitrary bound
      xPos  = xMargin;
      yPos += ySpacing;
    }
  }
}

//=========== UTILITY FUNCTIONS =============
// take data from loadIdeas(), load it into the cloud object
void createCloud () {
  cloud = new Cloud(); // create cloud
  cloud.setMaxWeight(maxWordDisplaySize); // max font size
  cloud.setMaxTagsToDisplay (maxNumTags);
 
  // Load the text file
  loadIdeas();
  int nLines = ideas.length;
  for (int i=0; i<nLines; i++) {
    int nChars = ideas[i].length();
    if (nChars > 0) {
      String lineWords[] = split(ideas[i], " ");
      int nLineWords = lineWords.length;
      for (int j=0; j<nLineWords; j++) {
        String aWord = trim(lineWords[j]);

        // simple filter to remove trailing punctuation
        if (aWord.endsWith(".") || aWord.endsWith(",") || aWord.endsWith("!") || aWord.endsWith("?")) {
          aWord = aWord.substring(0, aWord.length()-1);
        }
        if (!ignore(aWord)) { cloud.addTag(new Tag(aWord)); }
      }
    }
  } 
}

//loads brainstorm data from FileMaker into global variable ideas
void loadIdeas() {
  String url = "jdbc:filemaker://localhost/fmBrainstorm";
  String driver = "com.filemaker.jdbc.Driver";
  String user = "admin";
  String password = "";
  ideas = new String[0];
  
  System.setProperty("jdbc.drivers", driver);
  try {
    Connection connection = DriverManager.getConnection (url, user, password);
    Statement statement = connection.createStatement ();
    String q = "SELECT ideas.idea, categories.category FROM ideas ";
    q += "INNER JOIN categories ON ideas.category_id=categories.id ";
    q += "INNER JOIN brainstorms ON categories.brainstorm_id=brainstorms.id ";
    q += "WHERE (brainstorms.title='" + brainstormTitle + "')";
    ResultSet srs = statement.executeQuery (q);

    for (int i = 0; srs.next(); i++)
    {
      //NOTE there is a CATEGORY string getting pulled, but we're not doign
      String row = srs.getString("IDEA").toLowerCase();
      ideas = append(ideas, row);
    }
    
    srs.close();
    connection.close();
  } catch (Exception e) {
    print (e);
  }
}

//if a key is pressed
void keyPressed() {
  switch (key) {
    case 'g': saveFrame(brainstormTitle + "_###.png"); break; //screenshot
  }
}

// words to ignore. not the most sophisticated routine
boolean ignore(String blob) {
  String[] ignore_list = {"&","+","the","using","to","of","from",
    "through","with","on","out","in","into","and",
    "a","as","for","-"};
  for (int i=0; i<ignore_list.length; i++) {
    if (blob.equals(ignore_list[i])) { return true; }
  }
  return false;
}

//print the explo logo
void print_logo() {
  PImage logo;
  logo = loadImage("explo_logo.png");
  image (logo, width - logo.width - 10, height - logo.height - 10);
}
