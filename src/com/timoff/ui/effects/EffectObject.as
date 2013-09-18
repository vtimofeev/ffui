package com.timoff.ui.effects {
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.events.EffectEvent;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.clearInterval;
import flash.utils.setInterval;

public class EffectObject extends EventDispatcher {
    public static const EFFECT_INTERVAL:int = 20;

    public var cancelable:Boolean = true;
    public var blocker:Boolean = true;

    public var startFunction:Function;
    public var delayFunction:Function;
    public var finishFunction:Function;

    public var useCenter:Boolean = true;

    public var contents:Array = [];

    private var _interval:int = 0;
    private var intervalCounter:int = 0;

    private var value:Number = 0;
    public var client:Object;

    private var _duration:int = 0;
    private var _cacheClientAsBitmap:Boolean = false;

    // @todo: Linear.easeNone;
    public var mathFunction:Function = function (t:Number, b:Number, c:Number, d:Number) { return c * t / d + b; };
    public var finishManagerFunction:Function;

    public function EffectObject(client:Object, durationSeconds:Number, blocker:Boolean = true, cancelable:Boolean = true, finishFunction:Function = null) {
        this.client = client;
        this.duration = int(durationSeconds * 1000);
        this.blocker = blocker;
        this.cancelable = cancelable;
        this.finishFunction = finishFunction;
    }

    //EffectContent.TARGET_CURRENT )
    public function addContent(property:String, startValue:Number, finishValue:Number, durationSeconds:Number = -1, delaySeconds:Number = -1, target:int = 0):EffectContent
    {
        var duration:int = (durationSeconds > 0) ? durationSeconds * 1000 : duration;
        var delay:int = (delaySeconds > 0) ? delaySeconds * 1000 : 0;

        this.duration = (int(duration + delay) > this.duration) ? int(duration + delay) : this.duration;

        var eCont:EffectContent = new EffectContent(target, property, startValue, finishValue, duration, delay);
        eCont.mathFunction = this.mathFunction;
        contents.push(eCont);
        return eCont;
    }

    public function getContent(property:String):EffectContent {
        for each(var content:EffectContent in contents) {
            if (content.property == property)
                return content;
        }
        return null;
    }

    public function updateContent(property:String, startValue:Number, endValue:Number, active:Boolean = true):void {
        var content:EffectContent = getContent(property);
        if (!content) return;

        content.setStartKeyframeValue(startValue);
        content.setEndKeyframeValue(endValue);
        content.active = active;

    }

    public function start():void {
        reset();
        //FFComponent.log.debug("Effect started " + client.hasOwnProperty('id')?client.id:"unknown");

        if (cacheClientAsBitmap && client is DisplayObject) client.cacheAsBitmap = true;
        _interval = setInterval(progressHandler, EFFECT_INTERVAL);
        dispatchEvent(new Event(EffectEvent.EVENT_START));
    }

    private function progressHandler():void {
        intervalCounter++;
        const $time:Number = intervalCounter * EFFECT_INTERVAL;
        value = $time / duration;

        var content:EffectContent;

        for each (content in contents) {
            if (!content.active) continue;
            content.progress($time);
            this.client[content.property] = content.value;
        }

        if (useCenter) {
            setToCenter();
        }

        if (value >= 1) {
            if (Boolean(finishFunction))  finishFunction();
            if (Boolean(finishManagerFunction))  finishManagerFunction(this);

            reset();

            dispatchEvent(new Event(EffectEvent.EVENT_FINISH));
            return;
        }

        dispatchEvent(new Event(EffectEvent.EVENT_PROGRESS));
    }

    private function setToCenter():void {
        if (!(client is FFComponent)) return;
        client.x = client.layoutRectangle.x - (client.width * (client.scaleX - 1)) / 2
        client.y = client.layoutRectangle.y - (client.height * (client.scaleY - 1)) / 2
    }

    public function finish():void {
        if (cacheClientAsBitmap && client is DisplayObject) client.cacheAsBitmap = false;

        FFComponent.log.debug("Effect finished " + client.id);
        value = 1;
        var content:EffectContent;
        for each (content in contents) {
            content.value = 1;
            this.client[content.property] = content.endValue;
        }

        if (useCenter) {
            setToCenter();
        }

        if (Boolean(finishFunction))  finishFunction();
        reset();
        dispatchEvent(new Event(EffectEvent.EVENT_FINISH));
        return;
    }

    public function pause():void {
        clearInterval(_interval);
    }

    public function resume():void {
        _interval = setInterval(progressHandler, EFFECT_INTERVAL);
    }

    public function stop():void {
        reset();
    }

    public function reset():void {
        if (useCenter) {
            setToCenter();
        }

        clearInterval(_interval);
        intervalCounter = 0;
    }

    public function get isFinished():Boolean {
        return value >= 1;
    }


    public function get interval():int {
        return _interval;
    }

    public function set interval(value:int):void {
        _interval = value;
    }

    public function get duration():int {
        return _duration;
    }

    public function set duration(value:int):void {

        for each(var content:EffectContent in contents) {
            content.duration = value;
        }

        _duration = value;
    }

    public function set durationSeconds(value:Number):void {
        duration = value * 1000;
    }

    public function get cacheClientAsBitmap():Boolean {
        return _cacheClientAsBitmap;
    }

    public function set cacheClientAsBitmap(value:Boolean):void {
        _cacheClientAsBitmap = value;
    }

    public function free():void
    {
        client = null;
        startFunction = null;
        delayFunction = null;
        finishFunction = null;
        finishManagerFunction = null;

    }
}
}
