package msf.extras;
#if FLX_KEYBOARD
import flixel.FlxBasic;
import flixel.text.FlxText.FlxTextAlign;
import flixel.addons.ui.FlxInputText;
import openfl.events.KeyboardEvent;
import flixel.util.FlxColor;
import flixel.FlxG;
/**
 * FlxInputText with support for RTL languages.
 */
class FlxInputTextRTL extends FlxInputText 
{

	public var extraUtils:ExtraUtils;
	/**
	 * letter hack to avoid placing letters incorrectly
	 */
	var __hebrewOffset = 0;

	public var isRtl(default, null):Bool;

	/**
	 * @param	X				The X position of the text.
	 * @param	Y				The Y position of the text.
	 * @param	Width			The width of the text object (height is determined automatically).
	 * @param	Text			The actual text you would like to display initially.
	 * @param   size			Initial size of the font
	 * @param	TextColor		The color of the text
	 * @param	BackgroundColor	The color of the background (FlxColor.TRANSPARENT for no background color)
	 * @param	EmbeddedFont	Whether this text field uses embedded fonts or not
	 */
	public function new(X:Float = 0, Y:Float = 0, Width:Int = 150, ?Text:String, size:Int = 8,startEnglish:Bool = true, TextColor:Int = FlxColor.BLACK, BackgroundColor:Int = FlxColor.WHITE, EmbeddedFont:Bool = true) {
		super(X, Y, Width, Text, size, TextColor, BackgroundColor, EmbeddedFont);
		if (startEnglish) {isRtl = false; alignment = LEFT;} else {isRtl = true; alignment = RIGHT;}

		extraUtils = new ExtraUtils(this);
		wordWrap = true;

	}

	final function pressSpace()
	{
		#if windows
		if (isRtl)
		{
			__hebrewOffset++;
			caretIndex -= __hebrewOffset;
		}
		else
		{
			caretIndex += __hebrewOffset;
			__hebrewOffset = 0;
		}
		#end
		text = insertSubstring(text, " ", caretIndex);
		caretIndex = text.length;
		text = text;
	}
	
	override function set_hasFocus(newFocus:Bool):Bool {
		if (newFocus) {
			if (hasFocus != newFocus) {
				_caretTimer = new flixel.util.FlxTimer().start(0.5, toggleCaret, 0);
				caret.visible = true;
				caretIndex = 0;
			}
		} else {
			// Graphics
			caret.visible = false;
			if (_caretTimer != null) {
				_caretTimer.cancel();
			}
		}

		if (newFocus != hasFocus) {
			calcFrame();
		}
		return hasFocus = newFocus;
	}
	
	override function onKeyDown(e:KeyboardEvent) {

		if (e.altKey && e.shiftKey) {
			isRtl = !isRtl;
		}
		// some of this is from the overriden void but the actual char code entry is altered
		var key:Int = e.keyCode;

		if (hasFocus) 
		{
			var overridenString = mapCharCode(e.charCode);
			if (overridenString == null && key != 8 && key != 46 && key != 36 && key != 35 && key != 32) 
			{
				// not mapped, do default handling
				super.onKeyDown(e);
			}
			// backspace key
			else if (key == 8) {
				if (caretIndex > 0) {
					caretIndex--;
					text = text.substring(0, caretIndex) + text.substring(caretIndex + 1);
					onChange(FlxInputText.BACKSPACE_ACTION);
				}
			}
			// delete key
			else if (key == 46) {
				#if windows 
				if (isRtl && __hebrewOffset > 0) __hebrewOffset--;
				#end
				if (text.length > 0 && caretIndex < text.length) {
					text = text.substring(0, caretIndex) + text.substring(caretIndex + 1);
					onChange(FlxInputText.DELETE_ACTION);
					text = text;
				}
			}
			//end key
			else if (key == 36) {
				caretIndex = text.length;
				text = text; // forces scroll update
			}
			//home key
			else if (key == 35) {
				caretIndex = 0;
				text = text; // forces scroll update
			}
			//if the charCode is a typeable letter, try and insert it at the start of the LTR string,
			//therefore being inserted correctly
			else 
			{
				var newText:String = overridenString;


				if (newText.length > 0 && (maxLength == 0 || (text.length + newText.length) < maxLength)) {
					#if windows
					if (isRtl)
					{
						__hebrewOffset++;
						caretIndex -= __hebrewOffset;
					}
					else
					{
						caretIndex += __hebrewOffset;
						__hebrewOffset = 0;
					}
					#end
					text = insertSubstring(text, newText, caretIndex);
					caretIndex = text.length;				
					text = text; // forces scroll update
					onChange(FlxInputText.INPUT_ACTION);
				}
			}
		}
	}

	var charMap:Map<Int, String> = [
		113 => "/",
		119 => "'",
		101 => "ק",
		114 => "ר",
		116 => "א",
		121 => "ט",
		117 => "ו",
		105 => "ן",
		111 => "ם",
		112 => "פ",
		97 => "ש",
		115 => "ד",
		100 => "ג",
		103 => "ע",
		104 => "י",
		106 => "ח",
		107 => "ל",
		108 => "ך",
		59 => "ף",
		122 => "ז",
		120 => "ס",
		99 => "ב",
		118 => "ה",
		98 => "נ",
		110 => "מ",
		109 => "צ",
		60 => '>',
		62 => "<",
		44 => "ץ",
		46 => "ת",
		102 => "כ",
		32 => "",
		47 => ".",
		63 => "?",
		39 => ",",
		96 => ";",
	];

	var englishMap:Map<Int, String> = [
		113 => "q",
		119 => "w",
		101 => "e",
		114 => "r",
		116 => "t",
		121 => "y",
		117 => "u",
		105 => "i",
		111 => "o",
		112 => "p",
		97 => "a",
		115 => "s",
		100 => "d",
		103 => "g",
		104 => "h",
		106 => "j",
		107 => "k",
		108 => "l",
		59 => ";",
		122 => "z",
		120 => "x",
		99 => "c",
		118 => "v",
		98 => "b",
		110 => "n",
		109 => "m",
		60 => '>',
		62 => "<",
		44 => ".",
		46 => ",",
		102 => "f",
		32 => "",
		47 => "/",
		63 => "?",
		39 => "'",
		96 => "`",
	];



	function mapCharCode(charCode:Int):String
	{
		return if (isRtl) charMap[charCode] else englishMap[charCode];
	}
	#if FLX_KEYBOARD
	public override function update(elapsed:Float) {
		super.update(elapsed);
		if (hasFocus) {
			if (FlxG.keys.justPressed.SPACE) {
				pressSpace();
			}
		}
	}
	#end
}

private final class ExtraUtils extends FlxBasic {

	var textRTL:FlxInputTextRTL;

	public var backgroundVisible(default, set):Bool;
	
	function set_backgroundVisible(backgroundVisible:Bool):Bool {
		textRTL.backgroundColor = FlxColor.TRANSPARENT;
		return backgroundVisible;
	}

	public var borderVisible(default, set):Bool;

	function set_borderVisible(borderVisible:Bool):Bool {
		textRTL.fieldBorderColor = FlxColor.TRANSPARENT;
		return borderVisible;
	}

	public function new(inputText:FlxInputTextRTL) {
		super();
		this.textRTL = inputText;
		
	}

}
#end