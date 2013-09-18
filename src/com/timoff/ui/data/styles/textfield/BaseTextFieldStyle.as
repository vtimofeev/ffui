package com.timoff.ui.data.styles.textfield {
import com.timoff.ui.layout.Layout;
import com.timoff.ui.styles.TextfieldStyleObject;

import flash.net.registerClassAlias;


registerClassAlias("com.timoff.ui.data.styles.textfield.BaseTextFieldStyle", BaseTextFieldStyle);
public class BaseTextFieldStyle extends TextfieldStyleObject
{
    public static var DEFAULT_FONT_FAMILY:String = "Arial";
    public static var DEFAULT_FONT_COLOR:int = 0xFFFFFF;

    public static var align:String = Layout.LEFT;
    public static var bold:Boolean = false;
    public static var italic:Boolean = false;
    public static var underline:Boolean = false;
    public static var color:int = DEFAULT_FONT_COLOR;//* Math.random();
    public static var fontSize:Number = 12;
    public static var fontFamily:String = DEFAULT_FONT_FAMILY;

    public function BaseTextFieldStyle()
    {
        align = BaseTextFieldStyle.align;
        bold = BaseTextFieldStyle.bold;
        italic = BaseTextFieldStyle.italic;
        underline = BaseTextFieldStyle.underline;
    }
}
}