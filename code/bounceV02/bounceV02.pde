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
import processing.sound.*; // the java sound library works ok on OSX. If you're using 
                           // Windows, you may have to use the minim library instead.
import g4p_controls.*;

SoundFile clicksound; // handle to a sound object

// definitions
dot d1, d2; // two dot handles from the dot class
static int dotsize = 20; // size of dot in pixels
int speed = 5; // inital speed value
int latency_value = 1; // initial latency value
PFont f; // handle to a font object
boolean soundonoff = true;
PrintWriter output; // handle to a file i/o object
int round = 0; // number of times the dots have crossed screen

void setup()
{
  size(1000,800); // size of the window
  background(0); // black background
  frameRate(100); // 100 frames/second = 0.01s/frame
  createGUI(); // call to the G4P library to create the sliders, etc.
  d1 = new dot(); // instantiate dots
  d2 = new dot();
  d1.init(1); // initialise dots
  d2.init(-1); 
  clicksound = new SoundFile(this, "click.aiff"); // read in a sound file
  f = createFont("ArialMT-48.vlw", 12); // get a font
  textFont(f);  
  output = createWriter("results.csv"); // create an output file
  output.println("Round, Bounce, Speed, Latency");
}

void draw()
{
  background(0); // clear screen to black
  d1.animate(speed); // animate dots
  d2.animate(speed);
  if(d1.turned == true) // check if dots coinciding
  {
    if((abs(d1.x - d2.x) <= 10*latency_value ))
    { 
      round++;
      d1.turned = false;
      if(soundonoff == true)
      {
        clicksound.play();
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
  text("SPEED", 300, 715); 
  text("LATENCY", 300, 775);  
  text(speed, 700, 715); 
  text(latency_value, 700, 775);
  text("SOUND ON", 800, 775);
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