class GRIDIButton {

  color buttonColor;
  boolean hover, on;
  PVector position, size;
  int beat;

  /**
  * Constructor
  * @param PVector position where this button is
  * @param PVector size of this button
  * @param PVector buttonColor for this button
  * @param int beat the beat that corresponds to this button
  */
  GRIDIButton(PVector position, PVector size, color buttonColor, int beat) {

    this.on = hover = false;
    this.position = position;
    this.size = size;
    this.buttonColor = buttonColor;
    this.beat = beat;
  }
  
  /**
  * If the mouse is inside the button
  * we click on it, we set the button as on
  */
  void toggle() {
    if (mouseX > this.position.x && mouseX < (this.position.x + size.x)) {
      if (mouseY> this.position.y && mouseY < (this.position.y + size.y)) {
        on = !on;
      }
    }
  }

  /**
  * If the mouse is inside the button
  * we put the button state has hover
  */
  void hoover() {
    
    this.hover = false;
    
    if (mouseX > this.position.x && mouseX < (this.position.x + size.x)) {
      if (mouseY> this.position.y && mouseY < (this.position.y + size.y)) {
        this.hover = true;
      }
    }
  }


  /**
  * Draws the button
  */
  void draw() {
    
    if (this.on) {
      fill(this.buttonColor);
      rect(this.position.x, this.position.y, size.x, size.y, 15);
    } else {
      noFill();
      rect(this.position.x, this.position.y, size.x, size.y, 15);
    }

    if (this.hover) {
      fill(this.buttonColor, 80);
      rect(this.position.x, this.position.y, size.x, size.y, 15);
    } else {
      noFill();
      rect(this.position.x, this.position.y, size.x, size.y, 15);
    }
  
  }
  
}