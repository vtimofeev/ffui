package com.timoff.ui.styles {
import com.timoff.utilites.ObjectUtils;

import flash.net.registerClassAlias;

registerClassAlias("com.timoff.ui.styles.RectangleStyleObject", RectangleStyleObject);
public class RectangleStyleObject {


    public var fillColors:Array = new Array(0xFFFFFF * Math.random(), 0xCCCCCC);
    public var fillBitmap:String = null;
    public var fillAngle:Number = Math.PI / 2;
    public var lineColors:Array = new Array(0xEFEFEF, 0xCCCCCC);
    public var lineAngle:Number = Math.PI / 2;
    public var lineSides:String = null;
    public var fillAlphas:Array = new Array(1);
    public var lineAlphas:Array = new Array(1);

    public var lineWidth:Number = 1;
    private var _roundCorners:Number = 0;

    public var isFill:Boolean = false;
    public var isBorder:Boolean = false;

    // round corners
    public var radiusLeftTop:Number = 0;
    public var radiusRightTop:Number = 0;
    public var radiusRightBottom:Number = 0;
    public var radiusLeftBottom:Number = 0;

    public function RectangleStyleObject() {
    }

    public function setSimpleStyle(isFill:Boolean, fillColors:Array, fillAlphas:Array, isBorder:Boolean, lineWidth:Number, lineColors:Array, lineAlphas:Array, roundCorners:Number = 0, fillAngle:Number = 1.57, lineAngle:Number = 1.57):void {

        this.isFill = isFill;
        this.isBorder = isBorder;

        this.fillColors = fillColors;
        this.fillAlphas = fillAlphas;
        this.fillAngle = fillAngle;

        this.lineWidth = lineWidth;
        this.lineColors = lineColors;
        this.lineAlphas = lineAlphas;
        this.lineAngle = lineAngle;

    }

    public static function getSimpleStyle(isFill:Boolean, fillColors:Array, fillAlphas:Array, isBorder:Boolean, lineWidth:Number, lineColors:Array, lineAlphas:Array, roundCorners:Number = 0, fillAngle:Number = 1.57, lineAngle:Number = 1.57):RectangleStyleObject {

        var result:RectangleStyleObject = new RectangleStyleObject();
        result.isFill = isFill;
        result.isBorder = isBorder;

        result.fillColors = fillColors;
        result.fillAlphas = fillAlphas;
        result.fillAngle = fillAngle;

        result.lineWidth = lineWidth;
        result.lineColors = lineColors;
        result.lineAlphas = lineAlphas;
        result.lineAngle = lineAngle;
        return result;
    }

    public static function get propertiesMap():Object {
        return {fillColors:'', fillBitmap:'', fillAngle:'', lineColors:'', lineAngle:'', lineSides:'', fillAlphas:'', lineAlphas:'', lineWidth:'', roundCorners:'', isFill:'', isBorder:'', radiusLeftTop:'', radiusRightTop:'', radiusRightBottom:'', radiusLeftBottom:''};
    }

    public function get roundCorners():Number {
        return _roundCorners;
    }

    public function set roundCorners(value:Number):void {
        radiusLeftTop = radiusRightTop = radiusRightBottom = radiusLeftBottom = value;
        _roundCorners = value;
    }

    public function set roundCornersRadiuses(value:Array):void {
        radiusLeftTop = value[0];
        radiusRightTop = value[1];
        radiusRightBottom = value[2];
        radiusLeftBottom = value[3];
        return;
    }

    public function merge(value:Object):void
    {
        ObjectUtils.merge(this, value);
    }

    public function copy():RectangleStyleObject
    {
        return ObjectUtils.copy(this) as RectangleStyleObject;
    }



}
}