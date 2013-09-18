package com.timoff.ui.data.styles.rectangle {
import com.timoff.ui.styles.RectangleStyleObject;
import flash.net.registerClassAlias;

registerClassAlias("com.timoff.ui.data.styles.rectangle.BaseRectangleStyle", BaseRectangleStyle);
public class BaseRectangleStyle extends RectangleStyleObject {

    public static var fillColors:Array = [ 0x000000];
    public static var fillAlphas:Array = [ 1 ];
    public static var fillAngle:int = Math.PI/2;
    public static var isBorder:Boolean = true;
    public static var strokeWidth:int = 1;
    public static var strokeColors:Array = [ 0xCCCCCC ];
    public static var strokeAlphas:Array = [ .4, .2 ];
    public static var roundCorners:int = 0;

    public function BaseRectangleStyle()
    {
        setSimpleStyle(true, fillColors , fillAlphas , isBorder, strokeWidth, strokeColors, strokeAlphas );
        this.roundCorners = roundCorners;
        this.fillAngle = fillAngle;
    }
}
}