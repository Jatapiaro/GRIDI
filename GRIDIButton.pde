class GRIDIButton {

  color buttonColor;
  boolean hover, on;
  PVector position, size;
  int beat, channel;
  float top, bottom, left, right;
  String id;

  /**
  * Constructor
  * @param PVector position where this button is
  * @param PVector size of this button
  * @param PVector buttonColor for this button
  * @param int beat the beat that corresponds to this button
  */
  GRIDIButton(PVector position, PVector size, color buttonColor, int beat, int channel) {

    this.on = hover = false;
    this.position = position;
    this.size = size;
    this.buttonColor = buttonColor;
    this.beat = beat;
    this.channel = channel;
    this.initializeDimentions();
    this.id = channel+"-"+beat;
    
  }
  
  GRIDIButton( String id ) {
    this.id = id;
  }
  
  /**
  * Initialize the auxiliar variables to handle
  * the collision detection
  */
  void initializeDimentions() {
    this.left = this.position.x;
    this.right = this.position.x + this.size.x;
    this.top = this.position.y;
    this.bottom = this.position.y + this.size.y;
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
  
  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    if ( this.position != null ) {
      sb.append("["+this.position.x+",");
      sb.append(this.position.y+"]");
    } else {
      sb.append("ID: "+id);
    }
    return sb.toString();
  }
  
  @Override
  public boolean equals(Object o){
    GRIDIButton other = (GRIDIButton)o;
    return this.id.equals(other.id);
  }
  
  /**
  * Check if another object is colliding with this object
  * @param GRIDIButton o, the other object to be checked
  */
  public boolean onCollisionEnter(GRIDIButton o) {
    return !(this.position.x > o.position.x || 
      this.right < o.left || 
      this.top > o.bottom || 
      this.bottom < o.top);
  }
  
}