import themidibus.*;

public class Fiducial {
  
  private int id, channel;
  private float rotation;
  private int[] scale;
  private MidiBus midiBus;
  private Note midiBusNote;
  private int note;
  private PVector position;
  private int lastUpdatedTick;
  public boolean readyToProduceSound;
  
  public Fiducial(int id){
    this.id = id;
  }

  public Fiducial(int id, PVector position, float rotation, int tick, MidiBus midiBus) {
    this.id = id;
    this.note = 60;
    this.midiBusNote = new Note(0, 60, 127);
    this.scale = ScalesEnum.MAJOR.scale;
    this.rotation = rotation;
    this.mapNoteFromRotation(true, 0);
    this.extraSettings(position, tick);
    this.midiBus = midiBus;
  }
  
  public void extraSettings(PVector position, int tick) {
    this.position = position;
    this.lastUpdatedTick = tick;
    this.readyToProduceSound = false;
  }
  
  public int getId() {
    return this.id;
  }
  
  public void play() {
    this.midiBus.sendNoteOn(this.channel, this.note, 127);
    this.midiBus.sendNoteOff(this.channel, this.note, 127);
  }
  
  private void mapNoteFromRotation(boolean first, float rotation) {
    
    if ( first ) {
      int mapRotation = (int)map(this.rotation, 0, 360, 0, this.scale.length);
      this.note = 60 + scale[mapRotation];
      this.midiBusNote.setPitch(this.note);
    }
    if ( rotation < this.rotation ) {
      int mapRotation = (int)map(this.rotation, 0, 360, 0, this.scale.length);
      this.midiBusNote.setPitch(this.note);
      this.note = 60 - scale[mapRotation];
    } else {
      int mapRotation = (int)map(this.rotation, 0, 360, 0, this.scale.length);
      this.midiBusNote.setPitch(this.note);
      this.note = 60 + scale[mapRotation];
    }
    
  }
  
  public void updatePosition( PVector newPosition, int newTick ) {
    if ( this.lastUpdatedTick != newTick ) {
      if ( newPosition.x == this.position.x && newPosition.y == this.position.y ) {
        this.position = newPosition;
        this.readyToProduceSound = true;
        this.lastUpdatedTick = newTick;
      } else {
        extraSettings(newPosition, newTick);
      }
    }
  }
  
  public void updateRotation( float rotation ) {
    this.rotation = rotation;
    this.mapNoteFromRotation(false, this.rotation);
  }
  
  public void setChannel(int channel) {
    /*
    * TODO change the scale to a drum scale if the channel correpsonds 
    * to one related to redrum or something
    */
    this.channel = channel;
  }
  
  @Override
  public boolean equals( Object o ) {
    Fiducial other = (Fiducial)o;
    return other.getId() == this.id;
  }

  @Override
  public String toString() {
    return this.midiBusNote.name();
  }
  
}