/**
 * Created by IntelliJ IDEA.
 * User: Vasily
 * Date: 30.03.11
 * Time: 16:17
 * To change this template use File | Settings | File Templates.
 */
package com.timoff.ui.advanced {
import com.timoff.ui.effects.EffectObject;
import com.timoff.ui.layout.Layout;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

public class TotalGallery extends BaseGallery {

    private var defaultDelay:int = 30;
    private var nextDelay:int = defaultDelay;
    private var updateTimer:Timer = new Timer(defaultDelay, 0);
    private var speed:int = 1;

    private var maskLayer:Sprite;

    public function TotalGallery(id:String = null, styleName:String = null, direction:String = Layout.HORISONTAL, itemRenderrer:Class = null, itemRenderrerStyleName:String = '') {
        super(id, styleName, direction, false, itemRenderrer, itemRenderrerStyleName);
        this.layout.layout = Layout.ABSOLUTE;

        maskLayer = new Sprite();
        this.addChild(maskLayer);
        contentContainer.mask = maskLayer;

        enableMouseControls();
    }

    override protected function initControls():void {
        super.initControls();
        contentContainer.layout.layout = Layout.HORISONTAL;
        contentContainer.layout.isEnveloped = true;
        contentContainer.layout.alignContent(Layout.LEFT, Layout.MIDDLE);
    }

    override protected function calculateShowItems():int {
        if (dataProvider)
            return dataProvider.length;
        else
            return super.calculateShowItems();
    }


    public function enableMouseControls():void {
        this.addEventListener(MouseEvent.MOUSE_OVER, mousePlayerStart);
        this.addEventListener(MouseEvent.MOUSE_OUT, mousePlayerStop);
        updateTimer.addEventListener(TimerEvent.TIMER, updateContent);
    }

    private function updateContent(event:TimerEvent):void {
        startIndex = checkStartIndex(startIndex + speed);
        //updateTimer.delay = nextDelay;

        var resultPosition:int = contentContainer.x + speed;
        var minPosiition:int = this.width - contentContainer.width;
        var maxPosiition:int = 0;//contentContainer.$$width - this.width;
        resultPosition = resultPosition < minPosiition ? minPosiition : resultPosition;
        resultPosition = resultPosition > maxPosiition ? maxPosiition : resultPosition;
        contentContainer.x = resultPosition;
    }

    private function mousePlayerStop(event:Event):void {
        this.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        updateTimer.stop();
    }

    private function mousePlayerStart(event:Event):void {
        this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 1, true);
        updateTimer.start();
    }

    private function mouseMoveHandler(event:MouseEvent):void {
        var diff:int = this.width / 2 - this.mouseX;
        speed = int(diff / (width / 50));
        var delay = (speed == 0) ? defaultDelay : defaultDelay / speed;
        //speed = (speed==0)?0:(speed>0)?1:-1;
        nextDelay = delay > 0 ? delay : -delay;
    }

    override protected function draw():void {

        if (maskLayer.width != this.width || maskLayer.numChildren == 0) {
            var replacedArea:DisplayObject = stateManager.getHitArea();
            replaceContent(maskLayer, replacedArea);
        }

        super.draw();
    }

    override protected function alignContent(content:DisplayObject):void {
        return;
    }

    override public function updateLayout():void {
        super.updateLayout();
        contentContainer.x = 0;
        return;
        //super.updateLayout();
    }


    override protected function updateContainer():void {
        //super.updateContainer();
    }

    override public function get moveEffect():EffectObject {
        return null;//super.moveEffect;
    }

    override protected function setInitialPosition(value:int, object:DisplayObject) {
        return;
    }
}
}
