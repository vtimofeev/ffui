package com.timoff.ui.styles {
import com.timoff.ui.data.styles.BaseStyle;
import com.timoff.ui.data.styles.textfield.BaseTextFieldStyle;
import com.timoff.ui.layout.Layout;
import flash.net.registerClassAlias;

registerClassAlias("com.timoff.ui.styles.TextfieldStyleObject", TextfieldStyleObject );
public dynamic class TextfieldStyleObject extends Object
{
    public var isHtml:Boolean = false;
    public var isInput:Boolean = false;

    public var multiline:Boolean = false;
    public var embedded:Boolean = true;
    public var maxchars:int = 0;

    public var align:String = Layout.LEFT;

    public var bold:Boolean = false;
    public var italic:Boolean = false;
    public var underline:Boolean = false;

    public var color:int = BaseTextFieldStyle.color;//* Math.random();
    public var fontSize:Number = BaseTextFieldStyle.fontSize;
    public var fontFamily:String = BaseTextFieldStyle.fontFamily;

    public var leftMargin:Number = 0;

    public function TextfieldStyleObject() {
    }

    public var rightMargin:Number = 0;
    public var letterSpacing:int;

    public function setSimpleStyle( color:int, fontSize:Number, fontFamily:String, bold:Boolean = false,  italic:Boolean = false, underline:Boolean = false, multiline:Boolean = false, align:String = "left", isHtml:Boolean = false, isInput:Boolean = false):void
    {
        this.color = color;
        this.fontSize = fontSize;
        this.fontFamily = fontFamily;
        this.bold = bold;
        this.italic = italic;
        this.underline = underline;
        this.multiline = multiline;
        this.align = align;
        this.isHtml = isHtml
        this.isInput = isInput;
    }
	
	public static function get propertiesMap():Object 
	{
		return { isHtml:'' , isInput:'', multiline:'', maxchars:'', align:'', bold:'', italic:'', underline:'', color:'', fontSize:'', fontFamily:'', leftMargin:'', rightMargin:'', letterSpacing:'' };
	}

    public static function getSimpleStyle(color:int, fontSize:Number, fontFamily:String, bold:Boolean = false,  italic:Boolean = false, underline:Boolean = false, multiline:Boolean = false, align:String = "left", isHtml:Boolean = false, isInput:Boolean = false):TextfieldStyleObject
    {
        var result:TextfieldStyleObject = new TextfieldStyleObject();
        result.setSimpleStyle(color,fontSize,fontFamily,bold,italic,underline,multiline,align,isHtml,isInput);
        return result;



    }

}
}