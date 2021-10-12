package msf.extras;

import openfl.events.Event;
import flixel.FlxG;
import flixel.FlxSprite;
/**
 * A fast way to create a background `FlxSprite`
 */
class FlxBackground extends FlxSprite {
    
    /**
     * create a new background `FlxSprite`
     * @param color the color of the background
     */
    public function new(color:Int) {
        
        makeGraphic(FlxG.width, FlxG.height, color);
        super(x, y);
    }

    /**
     * Self-explanatory, call after a window/stage resize.
     */
    public function resizeToStageSize() {
        makeGraphic(FlxG.width, FlxG.height, color);
    }
        

}