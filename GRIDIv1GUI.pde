import themidibus.*;

import com.dhchoi.CountdownTimer;
import com.dhchoi.CountdownTimerService;

CountdownTimer timer;
MidiBus midi;
int stepX;
int stepY;
int beats = 16;
int chans = 8;
int tk = 0;

GRIDIButton[][] buttys = new GRIDIButton[beats][chans];

//----------------------------
void setup() {
  size(displayWidth, displayHeight);
  MidiBus.list();
  // create and start a timer that has been configured to trigger onTickEvents every 100 ms and run for 5000 ms
  timer = CountdownTimerService.getNewCountdownTimer(this).configure(200, 500000000).start();

  stepX = width/ 16;
  stepY = height/ 8;

  midi = new MidiBus(this, -1, "Bus 1");

  for (int y = 0; y < chans; y++) {
    for (int x=0; x < beats; x++) {
      int indx = beats*y+x; 
      buttys[x][y] = new GRIDIButton(new PVector(x*stepX, y*stepY), new PVector(stepX, stepY), color(0, 179, 179), x);
    }
  }
}



//----------------------------
void draw() {
  background(0);

  for (int i = 0; i< beats+1; i++) {
    stroke(0, 179, 179);
    line(i*stepX, 0, i*stepX, height);
  }
  for (int i = 0; i <chans+1; i++) {
    stroke(0, 179, 179);
    line(0, i*stepY, width, i*stepY);
  }

  fill(179, 0, 179, 80);
  rect(tk*stepX, 0, stepX, height, 15);

  for (int y = 0; y < chans; y++) {
    for (int x=0; x < beats; x++) {
      int indx = beats*y+x; 
      buttys[x][y].draw();
    }
  }
}  

void onTickEvent(CountdownTimer t, long timeLeftUntilFinish) {
  //timerCallbackInfo = "[tick] - timeLeft: " + timeLeftUntilFinish + "ms";
  tk++;
  tk %= beats;
  for (int y = 0; y < chans; y++) {
    for (int x=0; x < beats; x++) {
      int indx = beats*y+x; 

      if (tk == x && buttys[x][y].on) {
        switch(y) {
        case 0:
          midi.sendNoteOn(0, int(60), 90);
          break;
        case 1:
          midi.sendNoteOn(1, int(60), 90);
          break;
        case 2:
          midi.sendNoteOn(2, int(60), 90);
          break;
        case 3:
          midi.sendNoteOn(3, int(60), 90);
          break;
        case 4:
          midi.sendNoteOn(4, 36, 90);
          break;
        case 5:
          midi.sendNoteOn(4, 37, 90);
          break;
        case 6:
          midi.sendNoteOn(4, 38, 90);
          break;
        case 7:
          midi.sendNoteOn(4, 39, 90);
          break;

        }
        //midi.sendNoteOn(y, int(random(30, 80)), 90);
      }
    }
  }
}

void onFinishEvent(CountdownTimer t) {
  //timerCallbackInfo = "[finished]";
}


void mouseReleased() {
  //mouseX
  //mouseY
  println("FrameRaate: " + frameRate);
  for (int y = 0; y < chans; y++) {
    for (int x=0; x < beats; x++) {
      int indx = beats*y+x; 
      buttys[x][y].toggle();
    }
  }
} 

void mouseMoved() {
  //mouseX
  //mouseY
  for (int y = 0; y < chans; y++) {
    for (int x=0; x < beats; x++) {
      int indx = beats*y+x; 
      buttys[x][y].hoover();
    }
  }
} 