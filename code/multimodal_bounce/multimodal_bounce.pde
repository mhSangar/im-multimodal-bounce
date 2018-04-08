// bounce experiment
// version: 0.1
// Mikael Fernström
// 2018-02-12
// Version: 02

/////////////////////////////////////////////////////////////////////////////
// GENERAL DESCRIPTION
// Two dots are animated moving across the screen in opposite directions.
// When the objects coincide, a click sound can be heard
// The user can adjust speed (of the dots) and latency (between coinciding location
// and click sound).
// The user can press the 'b' key if experiencing that the objects seem to bounce
// off each other, or 'p' if the objects seem to pass each other.
//
// Press 'q' to save the data and quit the program.
//
// The resulting data is writte to results.csv, a file that later can be opened
// by for example Excel and further analysed statistically.
//
// This code example has not been calibrated in terms of how many milliseonds
// the stimuli is changing with, etc. I leave it to you, the student, to try to 
// calculate the actual timings and include that in your analysis.
/////////////////////////////////////////////////////////////////////////////

// libraries
import ddf.minim.*;
import g4p_controls.*;

// audio 
Minim minim; // handle to a sound object
AudioPlayer click_sound;

// definitions
dot d1, d2; // two dot handles from the dot class
static int dotsize = 20; // size of dot in pixels
int speed = 5; // inital speed value
int latency_value = 1; // initial latency value
PFont f; // handler for font object
boolean soundonoff = true;
PrintWriter output; // handler for file i/o object
int round = 0; // number of times the dots have crossed screen

void setup()
{
  size(1000,600); // size of the window
  background(0); // black background
  frameRate(100); // 100 frames/second = 0.01s/frame
  createGUI(); // call to the G4P library to create the sliders, etc.
  
  // instantiate dots
  d1 = new dot(); 
    d1.init(1);
  d2 = new dot();
    d2.init(-1); 
  
  minim = new Minim(this); // audio handler 
  click_sound = minim.loadFile("click.aiff"); // read in a sound file
  
  f = createFont("ArialMT-48.vlw", 12); // get a font
  textFont(f);  
  output = createWriter("results.csv"); // create an output file
  output.println("Round, Bounce, Speed, Latency"); // print labels in the output file
}

void draw()
{ 
  background(0); // clear screen to black
  
  // animate dots
  d1.animate(speed);
  d2.animate(speed);
  
  // check if dots coinciding
  if(d1.turned == true) 
  {
    if((abs(d1.x - d2.x) <= (dotsize/2)*latency_value )) // moment of visual coincidence
    { 
      round++;
      d1.turned = false;
      if(soundonoff == true)
      {
        click_sound.play();
        click_sound.rewind();
        //print("sound!\n");
      }
    }
  }
  showlabels(); // show settings on screen
}

/////////////////////////////////////////////////////////////////////////////
// functions
void showlabels()
{ // show labels in screen
  fill(255);
  textAlign(LEFT);
  text("SPEED", 300, 515); 
  text("LATENCY", 300, 575);  
  text(speed, 700, 515); 
  text(latency_value, 700, 575);
  text("SOUND ON", 800, 575);
}  

// callbacks
void keyPressed() 
{
  int bounceDetect = 0;
  if(key == 'b')
    bounceDetect = 1;
  if(key == 'p')
    bounceDetect = 0;
  // write fata to file
  output.println(round + "," + bounceDetect + "," + speed + "," + latency_value);

  if(key == 'q')
  { // save and quit
    output.flush(); // Write the remaining data
    output.close(); // Finish the file
    exit(); // Stop the program
  }
}
