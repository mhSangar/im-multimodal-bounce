// bounce experiment
//----------------------------------------------
// Original code:           Mikael Fernström
// Author of this version:  Mario Sánchez García
// Date:                    2018-04-16
// Version:                 03
//----------------------------------------------

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

// PARAMS
String observer = "x";

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
int latency_value = 0; // initial latency value
int audio_file_index = 0;  // initial sound
PFont f; // handler for font object
boolean soundonoff = true;
Table table;
int round = 0; // number of times the dots have crossed screen
int prev_round = -1;
ControlP5 cp5; // handler of cp5 sliders and button
Textlabel sound_label;
Textlabel[] labels = new Textlabel[4];
boolean stop_animation = false; // stop or stop the animation
boolean bounce;  // bounce detected
boolean pass;    // pass/stream detected
boolean sound_played = true;
int sound_prev = 0;  // sound on the prev round
int time_ = 0; 

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
    /*  SPEED
    cp5.addSlider("speed")
       .setPosition(200,500)
       .setSize(600, 20)
       .setRange(1, 15) // values can range from big to small as well
       .setValue(5)
       .setNumberOfTickMarks(15)
       //.getCaptionLabel().setVisible(false)
       ;
    */
       
    cp5.addSlider("latency_value")
       .setPosition(200,510)
       .setSize(600, 20)
       .setRange(-200, 200) // values can range from big to small as well
       .setValue(0)
       .setNumberOfTickMarks(3)
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
       .setImages(bt_images_offhover[2])
       ;
    labels[1] = new Textlabel (cp5, "BOUNCE DETECTED", 275, 462);
    
    cp5.addButton("pass")
       .setPosition(730,440)
       .setSize(50,50)
       .setImages(bt_images_offhover[3])
       ;
    labels[2] = new Textlabel (cp5, "PASS DETECTED", 645, 462);
    
    cp5.addRadioButton("radio_button")
      .setPosition(350,550)
      .setSize(25, 25)
      .setItemsPerRow(2)
      .setSpacingColumn(230)
      .addItem("Original sound", 0)
      .addItem("Whoosh sound", 1)
      .activate(0);
      
    labels[3] = new Textlabel (cp5, "0", 5, 5);  
    
  // instantiate dots
  d1 = new dot(); 
    d1.init(1);
  d2 = new dot();
    d2.init(-1); 
  
  minim = new Minim(this); // audio handler 
  click_sound = minim.loadFile(audio_files[audio_file_index]); // read in a sound file
  
  f = createFont("ArialMT-48.vlw", 12); // get a font
  textFont(f);  

  table = new Table();
  table.addColumn("Round");
  table.addColumn("Bounce");
  table.addColumn("Audio File");
  table.addColumn("Latency");
  
  time_ = millis();
}

void draw()
{ 
  background(0); // clear screen to black
  
  for (int i = 0; i < labels.length; i++){
    labels[3] = new Textlabel (cp5, new Integer(round).toString(), 5, 5);
    labels[i].draw(this);
  }
  
  if (sound_prev != audio_file_index){
    click_sound = minim.loadFile(audio_files[audio_file_index]); // read in a sound file
    sound_prev = audio_file_index;
  }
  
  // animate dots
  if (!stop_animation){
    d1.animate(speed);
    d2.animate(speed);
    
    // get feedback from user
    int bounce_detected = 0;
    if (bounce)
      bounce_detected = 1;
    else if (pass)
      bounce_detected = 0;
      
    if (bounce && pass)
      println("both keys pressed");
    else if (bounce || pass){
      if (round > prev_round){
        println("bounce: " + bounce + ", pass: " + pass);
        prev_round = round;
        
        TableRow newRow = table.addRow();
        newRow.setInt("Round", round);
        newRow.setInt("Bounce", bounce_detected);
        newRow.setInt("Audio File", audio_file_index);
        newRow.setInt("Latency", latency_value);
      }
      bounce = false;
      pass = false;
    }   
      
    // when dots hit each other
    if( abs(d1.x - d2.x) <= dotsize && d1.turned){  
      d1.turned = false;
      round++;
      //println(round + ": " + (millis() - time_) );  //round time ~1940ms
      time_ = millis();
    }
    
    // when dots hit the border of the window (offset because variable speed)
    if (d1.x < dotsize + 20 || d1.x > width-dotsize-20)
      sound_played = false;

    // play sound
    if (!sound_played){
      // Before (-200ms)
      if (abs(d1.x - d2.x) <= 230 && d1.turned && latency_value < 0){
        if(soundonoff == true)
        {
          click_sound.play();
          click_sound.rewind();
          sound_played = true;
          print("sound: |  prev | expected: -200(+/-5)ms | real: " + (millis() - time_ - 1940) + "ms |\n");
          
        }
      }
      // After (+200ms)
      else if (abs(d1.x - d2.x) <= 175 && abs(d1.x - d2.x) > 175-(speed+1)  && !d1.turned && latency_value > 0){
        if(soundonoff == true)
        {
          click_sound.play();
          click_sound.rewind();
          sound_played = true;
          print("sound: | after | expected:  200(+/-5)ms | real:  " + (millis() - time_) + "ms |\n");
          //stop_animation = true;
        }
      }
      // When they collide (0ms)
      else if (abs(d1.x - d2.x) <= dotsize && latency_value == 0){
        if(soundonoff == true)
        {
          click_sound.play();
          click_sound.rewind();
          sound_played = true;
          print("sound: |   now | expected:    0(+/-5)ms | real:    " + (millis() - time_) + "ms |\n");
          
        }
      }
    }
    
  }
  // animate dots when animation is stopped
  else{
    d1.stay();
    d2.stay();  
  }
  
  hover_toggle_buttons(); // update hover animations
  
}

/////////////////////////////////////////////////////////////////////////////
// functions
void hover_toggle_buttons(){
  // widgets with hover
  String ctrlls [] = {"soundonoff", "stop_animation", "bounce", "pass"};
  
  for (int i = 0; i < ctrlls.length; i++){
    // if mouse over widget
    if (cp5.isMouseOver(cp5.getController(ctrlls[i]))){
      cp5.getController(ctrlls[i]).setImages(bt_images_onhover[i]);
      mouseover_ctrller[i] = true;
    }
    // if mouse out widget
    else{
      if (mouseover_ctrller[i]){
        mouseover_ctrller[i] = false;
        cp5.getController(ctrlls[i]).setImages(bt_images_offhover[i]);
      }
    }
  }
}

// load images for icons
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
  int bounce_detected = -1;
  if(key == CODED){
    if (keyCode == LEFT){
      bounce_detected = 1;
      cp5.getController("bounce").setImages(bt_images_onhover[2]);
      println("bounce: true, pass: false");
    }      
    else if (keyCode == RIGHT){
      bounce_detected = 0;
      cp5.getController("pass").setImages(bt_images_onhover[3]);
      println("bounce: false, pass: true");
    }
      
  }
  
  if (bounce_detected != -1){
    // write fata to file
    TableRow newRow = table.addRow();
    newRow.setInt("Round", round);
    newRow.setInt("Bounce", bounce_detected);
    newRow.setInt("Audio File", audio_file_index);
    newRow.setInt("Latency", latency_value);
  }
   
  if(key == 'q')
  { // save and quit
    saveTable(table, "results/observer_" + observer + "_results.csv");
    exit(); // Stop the program
  }
}

// update keyboard icons  
void keyReleased(){
  if(key == CODED){
    if (keyCode == LEFT)
      cp5.getController("bounce").setImages(bt_images_offhover[2]);  
    else if (keyCode == RIGHT)
      cp5.getController("pass").setImages(bt_images_offhover[3]);
  }
  
}

// obtain values from the radio button (sound change)
void controlEvent(ControlEvent theEvent) {
  if(theEvent.isGroup() && theEvent.getName().equals("radio_button")) {
    // sound == original 
    if (theEvent.getArrayValue()[0] == 1)    
      audio_file_index = 0;
    // sound == whoosh
    else
      audio_file_index = 1;
  }
}
