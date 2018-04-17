import com.dhchoi.CountdownTimer;
import com.dhchoi.CountdownTimerService;
import java.util.List;
import java.util.ArrayList;
import TUIO.*;

CountdownTimer timer;

GRIDIButton[][] buttons;
List<GRIDIButton> buttonList;
List<GRIDIButton> hoveredButtons;
int buttonWidth, buttonHeight, beats, channels, currentTick;

/*
* Reactivision stuff 
*/
TuioProcessing tuioClient;

// these are some helper variables which are used
// to create scalable graphical feedback
float cursor_size = 15;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;
PFont font;
boolean verbose = false; // print console debug messages
boolean callback = true; // updates only after callbacks

void setup() {
  size(displayWidth, displayHeight);
  this.variableSetup();
  this.setupButtons();
  this.tuioSetup();
  loop(); //Remove it when you are working with a real camera
}

void variableSetup() {
  this.buttonList = new ArrayList<GRIDIButton>();
  this.hoveredButtons = new ArrayList<GRIDIButton>();
  this.currentTick = 0;
  this.beats = 16;
  this.channels = 8;
  this.buttonWidth = width/16;
  this.buttonHeight = width/8;
  this.timer = CountdownTimerService.getNewCountdownTimer(this).configure(200, Integer.MAX_VALUE).start();
}

void setupButtons() {
  buttons = new GRIDIButton[16][8];
  for (int y = 0; y < this.channels; y++) {
    for (int x=0; x < this.beats; x++) {
      GRIDIButton b = new GRIDIButton(
        new PVector(x*buttonWidth, y*buttonHeight), 
        new PVector(buttonWidth, buttonHeight), 
        color(0, 179, 179), x, y);
      buttons[x][y] = b;
      buttonList.add(b);
    }
  }
}

void draw() {
  
  background(0);
  this.drawTuioObjects();
  this.drawGrid();
  
}

void drawGrid() {
  
  for (int i = 0; i< beats+1; i++) {
    stroke(0, 179, 179);
    line(i*this.buttonWidth, 0, i*this.buttonWidth, height);
  }
  for (int i = 0; i <channels+1; i++) {
    stroke(0, 179, 179);
    line(0, i*this.buttonHeight, width, i*this.buttonHeight);
  }

  fill(179, 0, 179, 80);
  rect(this.currentTick*this.buttonWidth, 0, this.buttonWidth, height, 15);  
  for ( GRIDIButton b : this.buttonList ) {
    this.checkIfButtonIsHovered(b);
    b.draw();
  }
  
}

void checkIfButtonIsHovered(GRIDIButton btn) {
  
  GRIDIButton aux = null;
  for ( GRIDIButton b : this.hoveredButtons ) {
    if ( btn.equals(b) ) {
      btn.hover = true;
      aux = new GRIDIButton(b.id);
      break;
    } else {
      btn.hover = false;
    }
    
    if (aux != null) {
      this.hoveredButtons.remove(aux);
    }
  }
  
}

void onTickEvent(CountdownTimer t, long timeLeftUntilFinish) {
  this.currentTick++;
  this.currentTick %= this.beats;
}


/*
* Custom exit method
*/
@Override
void exit() {
  println("Stoped");
  super.exit();
}

void onFinishEvent(CountdownTimer t) {
  //JUST DO NOTHING!
}


/*
* TUIO methods
*/

/*
* TUIO methods
*/
void tuioSetup() {
  // GUI setup
  noCursor();
  noStroke();
  fill(1);
  
  // periodic updates
  if (!callback) {
    frameRate(60);
    loop();
  } else noLoop(); // or callback updates 
  
  font = createFont("Arial-Bold", 18);
  scale_factor = height/table_size;
  
  // finally we create an instance of the TuioProcessing client
  // since we add "this" class as an argument the TuioProcessing class expects
  // an implementation of the TUIO callback methods in this class (see below)
  tuioClient  = new TuioProcessing(this);
}

void drawTuioObjects() {
  this.hoveredButtons = new ArrayList<GRIDIButton>();
  float obj_size = object_size*scale_factor; 
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  for (int i=0; i < tuioObjectList.size(); i++) {
    TuioObject tobj = tuioObjectList.get(i);
    stroke(1);
    fill(1,1,1);
    pushMatrix();
    {
      fill(255, 255, 255);
      translate(tobj.getScreenX(width),tobj.getScreenY(height));
      rotate(tobj.getAngle());
      rect(-obj_size/2,-obj_size/2,obj_size,obj_size);
    }
    popMatrix();
    
    fill(0, 0, 0);
    text(
      ""+tobj.getSymbolID(), 
      tobj.getScreenX(width), 
      tobj.getScreenY(height)
      );
    textAlign(CENTER, BOTTOM);
    
    float fiducialXPosition = tobj.getScreenX(width);
    float defX = (fiducialXPosition)-(obj_size/2);
    float fiducialYPosition = tobj.getScreenY(height);
    float defY = (fiducialYPosition)-(obj_size/2);
    GRIDIButton b = new GRIDIButton(
      new PVector(defX, defY),
      new PVector(defX+obj_size, obj_size),
      0, 0, 0
    );
    for ( GRIDIButton gb : this.buttonList ) {
      boolean res = gb.onCollisionEnter(b);
      if ( res ) {
        GRIDIButton aux = new GRIDIButton(gb.id);
        if ( !this.hoveredButtons.contains(aux) ){
          this.hoveredButtons.add(aux);
        }
        println(hoveredButtons);
        break;
      }
    }
  }
}

// --------------------------------------------------------------
// these callback methods are called whenever a TUIO event occurs
// there are three callbacks for add/set/del events for each object/cursor/blob type
// the final refresh callback marks the end of each TUIO frame

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  if (verbose) println("add obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
  //this.master.addFiducial(tobj.getSymbolID());
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  if (verbose) println("set obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
          +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());   
          
          //this.master.updateFiducial(tobj.getSymbolID(), tobj.getAngleDegrees());
          
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  if (verbose) println("del obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
  //this.master.removeFiducial(tobj.getSymbolID());
}

// --------------------------------------------------------------
// called at the end of each TUIO frame
void refresh(TuioTime frameTime) {
  if (verbose) println("frame #"+frameTime.getFrameID()+" ("+frameTime.getTotalMilliseconds()+")");
  if (callback) redraw();
}