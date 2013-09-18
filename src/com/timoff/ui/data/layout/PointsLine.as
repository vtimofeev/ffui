/**
 * Author: Vasily
 * Web: http://timoff.com
 * Date: 17.05.11
 * Time: 19:47
 */
package com.timoff.ui.data.layout {
import flash.geom.Point;

public class PointsLine {
    public var startX:Number;
    public var endX:Number;
    public var y:Number;
    public var deleteFlag:Boolean = false;


    public function PointsLine(sX:Number,  eX:Number, y:Number) {
        startX = sX;
        endX = eX;
        this.y = y;
    }

    public function get width():Number
    {
        return endX - startX;
    }
}
}
