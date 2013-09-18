/**
 * Author: Vasily
 * Web: http://timoff.com
 * Date: 17.05.11
 * Time: 19:46
 */
package com.timoff.ui.data.layout {
import flash.geom.Point;

public class LinePoint extends Point {

    public var line:Number;

    public function LinePoint(x:Number,y:Number,line:Number) {
        this.line = line;
        super(x,y);
    }
}
}
