package;

import flixel.addons.ui.FlxInputText;
import flixel.system.FlxAssets;
import msf.extras.FlxInputTextRTL;
import flixel.FlxState;

class ___State extends FlxState{

    public override function create() {
        super.create();
        FlxAssets.FONT_DEFAULT = "assets/data/VarelaRound.ttf";
        add(new FlxInputTextRTL(0,20, 800, "", 40));
        
    }

    public override function update(elapsed:Float) {
        super.update(elapsed);
        
            
    }
}