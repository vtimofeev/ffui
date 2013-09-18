/**
 * Created by IntelliJ IDEA.
 * User: Vasily
 * Date: 06.04.11
 * Time: 14:25
 * To change this template use File | Settings | File Templates.
 */
package com.timoff.ui.geom {
import flash.geom.Rectangle;

public class AdvancedRectangle extends Rectangle {

    public var scaleX:Number = -1;
    public var scaleY:Number = -1;
    public var scaleZ:Number = -1;

    public var rotationX:Number;
    public var rotationY:Number;
    public var rotationZ:Number;

    public var zIndex:int = -1;

    public function AdvancedRectangle(x:Number,y:Number,width:Number,height:Number)
    {
        super(x,y,width,height);
    }
}
}
