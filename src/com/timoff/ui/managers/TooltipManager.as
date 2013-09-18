/**
 * Author: Vasily
 * Web: http://timoff.com
 * Date: 19.05.11
 * Time: 10:16
 */
package com.timoff.ui.managers {
import flash.events.Event;
import flash.utils.Dictionary;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Stage;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.geom.Rectangle;
import flash.utils.Timer;

import com.timoff.ui.controls.Label;
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.layout.Layout;

public class TooltipManager extends EventDispatcher {

    private static var _instances:Dictionary = new Dictionary(false);

    private var _facadeStage:DisplayObjectContainer;
    private var _targets:Array;
    private var _showDelay:uint = 1000; // at milliseconds
    private var _hideDelay:uint = 30000; // at milliseconds
    private var _offset:uint = 5;

    private var _currentTarget:DisplayObject = null;
    private var _currentText:String = null;
    private var pervoisTarget:DisplayObject = null;
    private var _currentTooltip:Label = null;

    private var showTimer:Timer;
    private var hideTimer:Timer;
    private var scrubTimer:Timer;

    /////////////////////////////////// Static|Class methods

    public static function getInstance(facadeId:String):TooltipManager {
        if (_instances[facadeId] == null)
            return _instances[facadeId] = new TooltipManager();
        else
            return _instances[facadeId];
    }

    public static function registerTooltip(facadeId:String, target:DisplayObject, oldTooltip:String, newTooltip:String):void {
        getInstance(facadeId).registerTooltip(target, oldTooltip, newTooltip);
    }

    public static function registerFacadeStage(facadeId:String, value:DisplayObjectContainer):void {
        getInstance(facadeId).registerStage(value);
    }


    ////////////////////////////////// Instance methods

    public function TooltipManager() {
        _targets = new Array();

        if (!showTimer) {
            showTimer = new Timer(0, 1);
            showTimer.addEventListener(TimerEvent.TIMER,
                    showTimer_timerHandler);
        }

        if (!hideTimer) {
            hideTimer = new Timer(0, 1);
            hideTimer.addEventListener(TimerEvent.TIMER,
                    hideTimer_timerHandler);
        }

        if (!scrubTimer)
            scrubTimer = new Timer(0, 1);

    }

    public function get currentTarget():DisplayObject {
        return _currentTarget;
    }

    public function set currentTarget(value:DisplayObject):void {
        _currentTarget = value;
    }

    public function get hideDelay():int {
        return _hideDelay;
    }

    public function set hideDelay(value:int):void {
        _hideDelay = value;
    }

    public function get showDelay():int {
        return _showDelay;
    }

    public function set showDelay(value:int):void {
        _showDelay = value;
    }

    public function registerStage(value:DisplayObjectContainer):void {
        _facadeStage = value;
    }


    public function get offset():uint {
        return _offset;
    }

    public function registerTooltip(target:DisplayObject, oldTooltip:String, newTooltip:String):void {
        if (!oldTooltip && newTooltip) {
            //(target as DisplayObjectContainer).mouseChildren = false;
            target.addEventListener(MouseEvent.MOUSE_OVER, tooltipMouseOverHandler);
            target.addEventListener(MouseEvent.MOUSE_OUT, tooltipMouseOutHandler);
            FFComponent(target).addStageEventListener(Event.MOUSE_LEAVE, tooltipMouseOutHandler)

            if (mouseIsOver(target))
                showImmediately(target);
        }
        else if (oldTooltip && !newTooltip) {
            target.removeEventListener(MouseEvent.MOUSE_OVER, tooltipMouseOverHandler);
            target.removeEventListener(MouseEvent.MOUSE_OUT, tooltipMouseOutHandler);
            FFComponent(target).removeStageEventListener(Event.MOUSE_LEAVE, tooltipMouseOutHandler);

            if (mouseIsOver(target))
            //hideImmediately(target);
                removeTooltip();
        }
    }

    protected function tooltipMouseOverHandler(event:MouseEvent):void {
        if (!event) return;
        var target:DisplayObject = event.currentTarget as DisplayObject;

        if (target != currentTarget)
            onTargetChange(currentTarget, target);
    }

    protected function tooltipMouseOutHandler(event:MouseEvent):void {
        if (mouseIsOver(event.currentTarget as DisplayObject))
            return;
        if (!event) return;
        onTargetChange(_currentTarget, null);
    }

    private function onTargetChange(oldTarget:DisplayObject, newTarget:DisplayObject):void {
        if (oldTarget == newTarget)
            return;

        pervoisTarget = currentTarget;
        currentTarget = newTarget;

        reset();

        if (_currentTooltip) {
            removeTooltip();
        }

        if (!currentTarget)
            return;

        if (currentTarget is FFComponent)
            _currentText = FFComponent(currentTarget).tooltip;

        if (!_currentText)
            return;

        //trace ("Start a Tooltip prepare");
        showTimer.delay = showDelay;
        showTimer.start();

        hideTimer.delay = showDelay + hideDelay;
        hideTimer.start();
    }

    private function showTimer_timerHandler(event:TimerEvent):void {
        if (currentTarget)
            createTooltip();
        return;
    }

    private function hideTimer_timerHandler(event:TimerEvent):void {
        if (_currentTooltip)
            removeTooltip();
        return;
    }

    private function preInitTooltip():DisplayObject {
        _currentTooltip = new Label("tooltip");
        _currentTooltip.layout.hAlign = Layout.CENTER;
        _currentTooltip.layout.vAlign = Layout.MIDDLE;
        _currentTooltip.layout.isEnveloped = true;
        _currentTooltip.layout.margin = 10;
        _currentTooltip.layout.isLayable = false;

        _currentTooltip.width = 100;
        _currentTooltip.height = 100;
        _currentTooltip.label = _currentText;

        return _currentTooltip;
    }

    private function createTooltip():void {
        if (!_facadeStage)
            throw new Error("The Stage ( DisplayObjectContainer ) must be registered at the instance, use TooltipManager.registerStage.");

        preInitTooltip();

        // @todo Need to detect stage;
        var uiRect:Rectangle = currentTarget.getRect(_facadeStage);
        var containerRect:Rectangle = new Rectangle(0, 0, _facadeStage.stage.stageWidth, _facadeStage.stage.stageHeight);
        var TooltipRect:Rectangle = new Rectangle(0, 0, _currentTooltip.width, _currentTooltip.height);

        // calcultate a Tooltip position
        switch (getContentRectangle(containerRect, uiRect, TooltipRect)) {

            case Layout.TOP:
                _currentTooltip.x = uiRect.x;
                _currentTooltip.y = uiRect.y - _currentTooltip.height - offset;
                break;

            case Layout.LEFT:
                _currentTooltip.x = uiRect.x - _currentTooltip.width - offset;
                _currentTooltip.y = uiRect.y;
                break;

            case Layout.RIGHT:
                _currentTooltip.x = uiRect.x + uiRect.width + offset;
                _currentTooltip.y = uiRect.y;
                break;

            default:
                _currentTooltip.x = uiRect.x;
                _currentTooltip.y = uiRect.y + uiRect.height + offset;
                break;
        }

        /*
        _currentTooltip.x = uiRect.x;
        _currentTooltip.y = uiRect.y;
        */




        _facadeStage.addChild(_currentTooltip);
    }

    private function getContentRectangle(stageRect:Rectangle, uiRect:Rectangle, TooltipRect:Rectangle):String {
        var downRect:Rectangle = new Rectangle(uiRect.x, uiRect.y + uiRect.height, stageRect.width - stageRect.x, stageRect.height - uiRect.y - uiRect.height);
        if (canBePlacedToContainer(downRect, TooltipRect))
            return Layout.BOTTOM;

        var rightRect:Rectangle = new Rectangle(uiRect.x + uiRect.width, uiRect.y, stageRect.width - stageRect.x - uiRect.width, stageRect.height - uiRect.y);
        if (canBePlacedToContainer(rightRect, TooltipRect))
            return Layout.RIGHT;

        var topRect:Rectangle = new Rectangle(uiRect.x + uiRect.width, uiRect.y, stageRect.width - stageRect.x - uiRect.width, stageRect.height - uiRect.y);
        if (canBePlacedToContainer(topRect, TooltipRect))
            return Layout.TOP;

        var leftRect:Rectangle = new Rectangle(0, uiRect.y, uiRect.x, stageRect.height - uiRect.y);
        if (canBePlacedToContainer(leftRect, TooltipRect))
            return Layout.LEFT

        return Layout.BOTTOM;
    }


    private function removeTooltip():void {
        if (_currentTooltip) {
            _facadeStage.removeChild(_currentTooltip);
            _currentTooltip = null;
        }
    }


    private function reset():void {
        showTimer.reset();
        hideTimer.reset();
    }


    private function mouseIsOver(target:DisplayObject):Boolean {
        if (!target || !target.stage)
            return false;

        if ((target.stage.mouseX == 0) && (target.stage.mouseY == 0))
            return false;

        //trace ( "target.hitTestPoint " + target.mouseX + " , "  +  target.mouseY + " , " + target.hitTestPoint(target.stage.mouseX,target.stage.mouseY, true) );
        return target.hitTestPoint(target.stage.mouseX, target.stage.mouseY, true);
    }

    private function showImmediately(target:DisplayObject):void {
        var oldShowDelay:int = this.showDelay;
        this.showDelay = 0;
        onTargetChange(currentTarget, target);
        this.showDelay = oldShowDelay;
        return;
    }

    public static function canBePlacedToContainer(container:Rectangle, content:Rectangle):Boolean {
        if (container && content)
            if (container.width > content.width && container.height > content.height)
                return true;

        return false;
    }


}
}	