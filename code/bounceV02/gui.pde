/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void latency_change(GSlider source, GEvent event) { //_CODE_:latency:834946:
  //println("latency - GSlider >> GEvent." + event + " @ " + millis());
  latency_value = latency.getValueI();
} //_CODE_:latency:834946:

public void speed_sl_change(GSlider source, GEvent event) { //_CODE_:speed_sl:912188:
  //println("speed_sl - GSlider >> GEvent." + event + " @ " + millis());
  speed = speed_sl.getValueI();
} //_CODE_:speed_sl:912188:

public void soundon_clicked(GCheckbox source, GEvent event) { //_CODE_:soundon:500402:
  //println("soundon - GCheckbox >> GEvent." + event + " @ " + millis());
  if(soundon.isSelected() == true)
    soundonoff = true;
    else
        soundonoff = false;
} //_CODE_:soundon:500402:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setCursor(ARROW);
  surface.setTitle("Sketch Window");
  latency = new GSlider(this, 360, 740, 300, 60, 10.0);
  latency.setLimits(1.0, 0.0, 30.0);
  latency.setNumberFormat(G4P.DECIMAL, 2);
  latency.setOpaque(false);
  latency.addEventHandler(this, "latency_change");
  speed_sl = new GSlider(this, 360, 680, 300, 60, 10.0);
  speed_sl.setLimits(5.0, 1.0, 30.0);
  speed_sl.setNumberFormat(G4P.DECIMAL, 2);
  speed_sl.setOpaque(false);
  speed_sl.addEventHandler(this, "speed_sl_change");
  soundon = new GCheckbox(this, 870, 750, 40, 40);
  soundon.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  soundon.setOpaque(false);
  soundon.addEventHandler(this, "soundon_clicked");
  soundon.setSelected(true);
}

// Variable declarations 
// autogenerated do not edit
GSlider latency; 
GSlider speed_sl; 
GCheckbox soundon; 