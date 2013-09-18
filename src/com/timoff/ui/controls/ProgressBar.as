package com.timoff.ui.controls {
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.data.core.InvalidationType;

import flash.events.Event;

public class ProgressBar extends FFComponent {

    private var _min:Number = 0;
    private var _max:Number = 100;
    protected var _value:Number = 0;
    private var _startValue:Number;
    private var _reverse:Boolean = false;

    public function ProgressBar(id:String = null, styleName:String = null, type:String = Control.PROGRESSBAR, contentRender:Class = null) {
        super(id, styleName, type, contentRender);
    }

    public function get min():Number {
        return _min;
    }

    public function set min(value:Number):void {
        _min = value;
    }

    public function get max():Number {
        return _max;
    }

    public function set max(value:Number):void {
        _max = value;
    }

    public function get value():Number {
        return _value;
    }

    public function set value(value:Number):void {

        if (value == _value) return;

        if (!value) value = min;

        if (value < min) value = min;
        else if (value > max) value = max;

        _value = value;

        invalidate(InvalidationType.DATA, false, false);
        dispatchEvent(new Event(Event.CHANGE));
    }

    public function get relativeValue():Number {
        if (!isNaN(startValue))
            return (value - startValue) / (max - min);
        else
            return value / (max - min)
    }

    public function get reverse():Boolean {
        return _reverse;
    }

    public function set reverse(value:Boolean):void {
        _reverse = value;
    }

    public function get startValue():Number {
        return _startValue;
    }

    public function set startValue(value:Number):void {
        if (value < min) value = min;
        else if (value > max) value = max;

        _startValue = value;
        invalidate(InvalidationType.DATA, false, false);
    }

    public function get diffValue():Number
    {
        return isNaN(startValue)?value:value - startValue;
    }

    public function get relativeStartValue():Number {
        return isNaN(_startValue) ? 0 : _startValue / (max - min);
    }
}
}