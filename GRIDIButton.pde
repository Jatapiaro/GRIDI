class GRIDIButton {

  boolean on;
  boolean hv;
  PVector pos;
  color clr;
  PVector size;
  int beat;

  //-------------------------------------------------
  GRIDIButton(PVector _pos, PVector _size, color _clr, int _beat) {

    on = false;
    pos = _pos;
    size= _size;
    clr = _clr;
    hv = false;
    beat = _beat;
    
  }
  //-------------------------------------------------
  void toggle() {
    if (mouseX > pos.x && mouseX < (pos.x + size.x)) {
      if (mouseY> pos.y && mouseY < (pos.y + size.y)) {
        on = !on;
      }
    }
  }

  //-------------------------------------------------
  void hoover() {
    
    hv = false;
    
    if (mouseX > pos.x && mouseX < (pos.x + size.x)) {
      if (mouseY> pos.y && mouseY < (pos.y + size.y)) {
        hv = true;
      }
    }
  }


  //-------------------------------------------------
  void draw() {
    if (on) {
      fill(clr);
      rect(pos.x, pos.y, size.x, size.y, 15);
    } else {
      noFill();
      rect(pos.x, pos.y, size.x, size.y, 15);
    }

    if (hv) {
      fill(clr, 80);
      rect(pos.x, pos.y, size.x, size.y, 15);
    } else {
      noFill();
      rect(pos.x, pos.y, size.x, size.y, 15);
    }
  }
}