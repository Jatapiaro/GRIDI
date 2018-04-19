/**
* ScalesEnum
*
* @author Jacobo Tapia - A01336590
* @author Sofía Aguirre - A01332562
* @author Maximiliano Carmona Miranda - A01650052
*
*/

import java.util.Arrays;

public enum InstrumentsEnum {

    NNXT(0),
    EUROPA(1),
    GRAIN(2),
    MALSTROM(3);
    
    private int channel;

    private InstrumentsEnum(final int channel) {
        this.channel = channel;
    }

    @Override
    public String toString() {
        return this.channel+"";
    }

}