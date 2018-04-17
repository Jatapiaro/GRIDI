/**
* ScalesEnum
*
* @author Jacobo Tapia - A01336590
* @author Sofía Aguirre - A01332562
* @author Maximiliano Carmona Miranda - A01650052
*
*/

import java.util.Arrays;

public enum ScalesEnum {


    AJAM(new int[] { 0, 4, 8, 10, 14, 18, 22 }),
    BAYATI(new int[]{ 0, 3, 6, 10, 14, 16, 20 }),
    DORIAN(new int[] { 0, 2, 3, 5, 7, 9, 10 }),  
    EGYPTIAN(new int[] { 0, 2, 5, 7, 10 }),
    HUZAM(new int[] { 0, 3, 7, 9, 15, 17, 21 }),
    IWATO(new int[] { 0, 1, 5, 6, 10 }),
    KUMOI(new int[] { 0, 2, 3, 7, 9 }),
    MAJOR(new int[] { 0, 2, 4, 5, 7, 9, 11 }), 
    NAIRUZ(new int[] { 0, 4, 7, 10, 14, 17, 20 }),
    PURVI(new int[] { 0, 1, 4, 6, 7, 8, 11 }),
    RAST(new int[] { 0, 4, 7, 10, 14, 18, 21 }),
    TODI(new int[] { 0, 1, 3, 6, 7, 8, 11 });

    private int[] scale;

    private ScalesEnum(final int[] scale) {
        this.scale = scale;
    }
    

    @Override
    public String toString() {
        return Arrays.toString(this.scale);
    }

}