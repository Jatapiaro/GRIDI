import java.util.*;
import themidibus.*;

public class InstrumentsMaster {
  
  /*
  * Hash map to have quick acces to all the columns
  * An Integer is used as a key or the 16 columns that maps
  * a List of fiducials for that column
  */
  private HashMap<Integer, List<Fiducial>> columns;
  /*
  * This will help us to track when a fiducial is taken off
  * Basically we store the column, alongside the fiducial id
  * Se when is removed, we just check the id, and then we look
  * for it on the columns to remove it.
  */
  private HashMap<Integer, Integer> fiducialInColumn;
  
  private List<Fiducial> waitingList;
  
  private int stepVelocity, lastStepSoundAt, step;
  
  private int inDeviceNum, outDeviceNum;

  private MidiBus midiBus;
  
  public InstrumentsMaster() {
    
    this.columns = new HashMap<Integer, List<Fiducial>>();
    /* Initialice all columns */
    for( int i = 0; i<16; i++ ) {
      this.columns.put(i, new ArrayList<Fiducial>());
    }    
    
    this.fiducialInColumn = new HashMap<Integer, Integer>();
    this.waitingList = new ArrayList<Fiducial>();
    
    this.inDeviceNum = 0;
    this.outDeviceNum = 1;
    this.midiBus = new MidiBus(this, this.inDeviceNum, this.outDeviceNum);
    
  }
  
  public void addFiducial(int id, PVector position, float rotation, int tick) {
    //println("Add fid: "+id);
    Fiducial f = new Fiducial(id, position, rotation, tick, this.midiBus);
    if ( !this.waitingList.contains(f) ) {
      this.waitingList.add(f);
    }
    //println("Waiting: "+this.waitingList);
  }
  
  public void updateFiducial(int id, PVector position, float rotation, int tick) {
    this.onUpdateHandleWaitingList(id, position, rotation, tick);
    this.onUpdateHandleFiducialsInColumns(id, position, rotation, tick);
  }
  
  private void onUpdateHandleWaitingList(int id, PVector position, float rotation ,int tick) {
    
    if ( this.waitingList.contains(new Fiducial(id)) ) {
      int index = this.waitingList.indexOf(new Fiducial(id));
      Fiducial f = this.waitingList.get(index);
      f.updatePosition(position, tick);
      f.updateRotation(rotation);
    }  
    
  }
  
  private void onUpdateHandleFiducialsInColumns(int id, PVector position, float rotation ,int tick) {
    if ( fiducialInColumn.containsKey(id) ) {
      int column = this.fiducialInColumn.get(id);
      Fiducial f = new Fiducial(id);
      int index = this.columns.get(column).indexOf(f);
      Fiducial aux = this.columns.get(column).get(index);
      aux.updatePosition(position, tick);
      aux.updateRotation(rotation);
      if ( !aux.readyToProduceSound ) {
        this.fiducialInColumn.remove(id);
        this.columns.get(column).remove(f);
        this.waitingList.add(aux);
      }
    }
  }
  
  public void onCollisionIsReadyToProduceSound(int id, int channel, int beat) {
    if ( this.waitingList.contains(new Fiducial(id)) ) {
      int index = this.waitingList.indexOf(new Fiducial(id));
      Fiducial f = this.waitingList.get(index);
      if ( f.readyToProduceSound ) {
        this.waitingList.remove(f);
        this.fiducialInColumn.put(id, beat);
        f.setChannel(channel);
        this.columns.get(beat).add(f);
        //println("After: "+beat);
        //println(columns);
      }    
    }
  }
  
  public boolean isFiducialMakingSound(int id)  {
    return this.fiducialInColumn.containsKey(id);
  }
   
  public void removeFiducial(int id) {
    if ( this.waitingList.contains(new Fiducial(id)) ) {
      this.waitingList.remove(new Fiducial(id));
    }    
    if ( this.fiducialInColumn.containsKey(id) ) {
      int theColumn = this.fiducialInColumn.get(id);
      this.columns.get(theColumn).remove(new Fiducial(id));
      this.fiducialInColumn.remove(id);
    }
  }
  
  void play(int tick) {
    List<Fiducial> l = this.columns.get(tick);
    println(tick+": "+l);
    for ( Fiducial f : l ) {
      f.play();
    }
  }
  
}