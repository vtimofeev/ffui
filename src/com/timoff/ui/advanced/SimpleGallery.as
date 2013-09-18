/**
 * Created by IntelliJ IDEA.
 * User: Vasily
 * Date: 07.04.11
 * Time: 17:08
 * To change this template use File | Settings | File Templates.
 */
package com.timoff.ui.advanced {
import com.timoff.ui.layout.Layout;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.trace.Trace;
import flash.utils.Timer;

public class SimpleGallery extends BaseGallery {

    private var defaultDelay:int = 1000;
    private var nextDelay:int = defaultDelay;
    private var updateTimer:Timer = new Timer(defaultDelay,0);
    private var speed:int = 1;

    public function SimpleGallery(id:String = null, styleName:String = null, direction:String = Layout.HORISONTAL, itemRenderrer:Class = null, itemRenderrerStyleName:String = '') {
        super(id, styleName, direction, false, itemRenderrer, itemRenderrerStyleName);
    }

    public function enableMouseControls():void {
        this.addEventListener(MouseEvent.MOUSE_OVER, mousePlayerStart);
        this.addEventListener(MouseEvent.MOUSE_OUT, mousePlayerStop);
        updateTimer.addEventListener(TimerEvent.TIMER, updateContent );
    }

    private function updateContent(event:TimerEvent):void {
        startIndex = checkStartIndex(startIndex + speed);
        updateTimer.delay = nextDelay;
        refreshChilds((speed<0)?Layout.LEFT:Layout.RIGHT);
    }

    private function mousePlayerStop(event:Event):void {
        this.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        updateTimer.stop();
    }

    private function mousePlayerStart(event:Event):void {
        this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 1, true);
        updateTimer.start();
    }

    private function mouseMoveHandler(event:MouseEvent):void
    {
        var diff:int = this.width/2 - this.mouseX;
        speed = -int(diff/(width/12));
        var delay = (speed==0)?defaultDelay:defaultDelay/speed;
        speed = (speed==0)?0:(speed>0)?1:-1;
        nextDelay = delay>0?delay:-delay;
    }
}
}
