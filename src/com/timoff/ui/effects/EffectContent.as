package com.timoff.ui.effects {
public class EffectContent {
    public static const PROPERTY_ALPHA:String = 'alpha';

    public static const PROPERTY_X:String = "x";
    public static const PROPERTY_Y:String = "y";
    public static const PROPERTY_Z:String = "z";

    public static const PROPERTY_SCALEX:String = 'scaleX';
    public static const PROPERTY_SCALEY:String = 'scaleY';
    public static const PROPERTY_SCALEZ:String = 'scaleZ';

    public static const PROPERTY_ROTATION_X:String = "rotationX";
    public static const PROPERTY_ROTATION_Y:String = "rotationY";
    public static const PROPERTY_ROTATION_Z:String = "rotationZ";

    public static const TARGET_CURRENT:uint = 1;
    public static const TARGET_CURRENT_BG:uint = 2;
    public static const TARGET_CURRENT_CONTENT:uint = 4;

    public static const TARGET_NEXT_BG:uint = 8;
    public static const TARGET_NEXT_CONTENT:uint = 16;

    ///////////////////////////////////////////////////////////////////
    ///

    public var property:String;
    public var target:int = TARGET_CURRENT;

    public var startValue:Number = 0;
    public var endValue:Number = 0;
    public var value:Number = 0;
    public var active:Boolean = true;

    public var mathFunction:Function = function () { return 1; }//@todo : math fnc;
    private var keyframes:Vector.<EffectKeyframe>;
    private var _duration:int = 0;

    public function EffectContent(target:int, property:String, startValue:Number, endValue:Number, duration:int, delay:int = 0) {
        this.target = target;
        this.property = property;
        this.duration = duration;
        this.startValue = startValue;
        this.endValue = endValue;

        keyframes = new Vector.<EffectKeyframe>();
        this.addKeyframe(0, startValue);
        if (delay) this.addKeyframe(delay, startValue);
        this.addKeyframe(duration, endValue);
    }

    public function addKeyframe(time:Number, value:Number):void {
        keyframes.push(new EffectKeyframe(time, value));
        return;
    }

    public function setStartKeyframeValue(value:Number):void
    {
        if(keyframes.length) keyframes[0].value = value;
    }

    public function setEndKeyframeValue(value:Number):void
    {
        if(keyframes.length) keyframes[keyframes.length-1].value = value;
    }

    public function progress($time:Number):Number {
        var startKey:EffectKeyframe;
        var endKey:EffectKeyframe;
        const length:int = keyframes.length;
        var i:int;

        for (i = 0; i < length; i++) {
            endKey = keyframes[i];
            if (endKey.time >= $time) break;
        }

        if (i > 0) startKey = keyframes[i - 1];

        if (!startKey) {
            if (!endKey) return startValue;
            else return endKey.value;
        }

        const diffValue:Number = endKey.value - startKey.value;
        const diffTime:Number = endKey.time - startKey.time;

        var progress:Number = ($time - startKey.time) / diffTime;
//                trace ($time, startKey.time, diffTime);
        progress = (progress < 0) ? 0 : (progress > 1) ? 1 : progress;

        //trace (progress);
        return value = mathFunction(progress, startKey.value, diffValue, 1);
    }

    public function get duration():int {
        return _duration;
    }

    public function set duration(value:int):void {
        if(keyframes) if(keyframes.length > 1) keyframes[keyframes.length-1].time = value;

        _duration = value;
    }
}
}