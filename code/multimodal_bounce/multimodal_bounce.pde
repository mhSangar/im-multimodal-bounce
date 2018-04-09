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
import controlP5.*;

// audio 
Minim minim; // handle to a sound object
AudioPlayer click_sound;
String audio_files [] = {"click.aiff", "wind.wav"};

// definitions
dot d1, d2; // two dots from own dot class
static int dotsize = 20; // size of dot in pixels
int speed = 5; // inital speed value
int latency_value = 1; // initial latency value
PFont f; // handler for font object
boolean soundonoff = true;
PrintWriter output; // handler for file i/o object
int round = 0; // number of times the dots have crossed screen
int prev_round = -1;
ControlP5 cp5; // handler of cp5 sliders and button
Textlabel sound_label;
Textlabel[] labels = new Textlabel[3];
boolean stop_animation = false; // stop or stop the animation
boolean bounce;
boolean pass;

boolean[] mouseover_ctrller = {false, false, false, false};
// images of the toggle button 
PImage[][] bt_images_offhover = new PImage[4][];
PImage[][] bt_images_onhover = new PImage[4][];

void setup()
{
  size(1000,600); // size of the window
  background(0); // black background
  frameRate(100); // 100 frames/second = 0.01s/frame
  createGUI(); // call to the G4P library to create the sliders, etc.
  
  // load toggle images
  load_images();
  
  // cp5
    // sliders
    cp5 = new ControlP5(this);
    cp5.addSlider("speed")
       .setPosition(200,500)
       .setSize(600, 20)
       .setRange(1, 15) // values can range from big to small as well
       .setValue(5)
       .setNumberOfTickMarks(15)
       //.getCaptionLabel().setVisible(false)
       ;
       
    cp5.addSlider("latency_value")
       .setPosition(200,540)
       .setSize(600, 20)
       .setRange(1, 30) // values can range from big to small as well
       .setValue(1)
       .setNumberOfTickMarks(30)
       //.getCaptionLabel().setVisible(false)
       ;
     
    // buttons
    cp5.addToggle("soundonoff")
       .setPosition(width-10-40,5)
       .setSize(40,40)
       .setImages(bt_images_offhover[0])
       ;
    labels[0] = new Textlabel (cp5, "SOUND", width-10-40,45);//275, 468);
    
    cp5.addToggle("stop_animation")
       .setPosition(468,426)
       .setSize(64,64)
       .setImages(bt_images_offhover[1])
       ;
    
    cp5.addButton("bounce")
       .setPosition(220,440)
       .setSize(50,50)
       //.setImages(bt_images_offhover[2])
       .setImages(loadImage("left-arrow_offhover.png"), loadImage("left-arrow_onhover.png"), loadImage("left-arrow_onhover.png"))
       ;
    labels[1] = new Textlabel (cp5, "BOUNCE DETECTED", 275, 462);
    
    cp5.addButton("pass")
       .setPosition(730,440)
       .setSize(50,50)
       .setImages(bt_images_offhover[3])
       ;
    labels[2] = new Textlabel (cp5, "PASS DETECTED", 645, 462);
  
  
  // instantiate dots
  d1 = new dot(); 
    d1.init(1);
  d2 = new dot();
    d2.init(-1); 
  
  minim = new Minim(this); // audio handler 
  click_sound = minim.loadFile(audio_files[1]); // read in a sound file
  
  f = createFont("ArialMT-48.vlw", 12); // get a font
  textFont(f);  
  output = createWriter("results.csv"); // create an output file
  output.println("Round, Bounce, Speed, Latency"); // print labels in the output file
}

void draw()
{ 
  background(0); // clear screen to black
  
  for (int i = 0; i < labels.length; i++)
    labels[i].draw(this);
  
  
  // animate dots
  if (!stop_animation){
    d1.animate(speed);
    d2.animate(speed);
    
    int bounce_detected = 0;
    if (bounce)
      bounce_detected = 1;
    else if (pass)
      bounce_detected = 0;
      
    if (bounce && pass)
      println("both keys pressed");
    else if (bounce || pass){
      if (round > prev_round){
        println("b: " + bounce + ", p: " + pass);
        prev_round = round;
        output.println(round + "," + bounce_detected + "," + speed + "," + latency_value);
      }
      bounce = false;
      pass = false;
    }   
      
    // check if dots coinciding
    if(d1.turned == true) 
    {
      if((abs(d1.x - d2.x) <= (dotsize)*latency_value )) // moment when dots hit
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
  }
  else{
    d1.stay();
    d2.stay();  
  }
  //showlabels(); // show settings on screen
  
  hover_toggle_buttons(); // mouseover toggle sound 
  
}

/////////////////////////////////////////////////////////////////////////////
// functions
void hover_toggle_buttons(){
  String ctrlls [] = {"soundonoff", "stop_animation", "bounce", "pass"};
  
  for (int i = 0; i < ctrlls.length; i++){
    if (cp5.isMouseOver(cp5.getController(ctrlls[i]))){
      cp5.getController(ctrlls[i]).setImages(bt_images_onhover[i]);
      mouseover_ctrller[i] = true;
    }
    else{
      if (mouseover_ctrller[i]){
        mouseover_ctrller[i] = false;
        cp5.getController(ctrlls[i]).setImages(bt_images_offhover[i]);
      }
    }
  }
}

void load_images(){
  bt_images_offhover[0] = new PImage [2];
  bt_images_onhover[0] = new PImage [2];
  bt_images_offhover[0][0] = loadImage("speaker_off_offhover.png");
  bt_images_offhover[0][1] = loadImage("speaker_on_offhover.png");
  bt_images_onhover[0][0] = loadImage("speaker_off_onhover.png");
  bt_images_onhover[0][1] = loadImage("speaker_on_onhover.png");
  
  bt_images_offhover[1] = new PImage [2];
  bt_images_onhover[1] = new PImage [2];
  bt_images_offhover[1][0] = loadImage("pause-button_offhover.png");
  bt_images_offhover[1][1] = loadImage("play-button_offhover.png");
  bt_images_onhover[1][0] = loadImage("pause-button_onhover.png");
  bt_images_onhover[1][1] = loadImage("play-button_onhover.png");
  
  bt_images_offhover[2] = new PImage [3];
  bt_images_onhover[2] = new PImage [3];
  bt_images_offhover[2][0] = loadImage("left-arrow_offhover.png");
  bt_images_offhover[2][1] = loadImage("left-arrow_offhover.png");
  bt_images_offhover[2][2] = loadImage("left-arrow_offhover.png");
  bt_images_onhover[2][0] = loadImage("left-arrow_onhover.png");
  bt_images_onhover[2][1] = loadImage("left-arrow_onhover.png");
  bt_images_onhover[2][2] = loadImage("left-arrow_onhover.png");
  
  bt_images_offhover[3] = new PImage [3];
  bt_images_onhover[3] = new PImage [3];
  bt_images_offhover[3][0] = loadImage("right-arrow_offhover.png");
  bt_images_offhover[3][1] = loadImage("right-arrow_offhover.png");
  bt_images_offhover[3][2] = loadImage("right-arrow_offhover.png");
  bt_images_onhover[3][0] = loadImage("right-arrow_onhover.png");
  bt_images_onhover[3][1] = loadImage("right-arrow_onhover.png");
  bt_images_onhover[3][2] = loadImage("right-arrow_onhover.png");  
}

// callbacks
void keyPressed() 
{
  int bounceDetect = 0;
  if(key == CODED){
    if (keyCode == LEFT){
      bounceDetect = 1;
      cp5.getController("bounce").setImages(bt_images_onhover[2]);
    }
      
    if (keyCode == RIGHT){
      bounceDetect = 0;
      cp5.getController("pass").setImages(bt_images_onhover[3]);
    }
      
  }
  
  // write fata to file
  output.println(round + "," + bounceDetect + "," + speed + "," + latency_value);

  if(key == 'q')
  { // save and quit
    output.flush(); // Write the remaining data
    output.close(); // Finish the file
    exit(); // Stop the program
  }
}

void keyReleased(){
  
  if(key == CODED){
    if (keyCode == LEFT){
      cp5.getController("bounce").setImages(bt_images_offhover[2]);
    }
      
    if (keyCode == RIGHT){
      cp5.getController("pass").setImages(bt_images_offhover[3]);
    }
      
  }
  
}
