/**
 * Created by IntelliJ IDEA.
 * User: Vasily
 * Date: 04.05.11
 * Time: 10:03
 * To change this template use File | Settings | File Templates.
 */
package com.timoff.ui.controls.inputs {
import com.timoff.ui.containers.Container;
import com.timoff.ui.controls.Button;
import com.timoff.ui.controls.Control;
import com.timoff.ui.controls.Input;
import com.timoff.ui.data.controls.StepperSettings;
import com.timoff.ui.data.core.InvalidationType;
import com.timoff.ui.layout.Layout;

import flash.events.Event;

public class NumericStepper extends Container {

    private var plusButton:Button;
    private var minusButton:Button;
    private var input:Input;

    private var _min:Number = 0;
    private var _max:Number = 100;
    private var _value:Number = 0;
    private var _step:Number = 1;

    private var _settings:StepperSettings;

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


        if (input) input.label = value.toString();

        invalidate(InvalidationType.DATA);
        dispatchEvent(new Event(Event.CHANGE));
    }

    public function get step():Number {
        return _step;
    }

    public function set step(value:Number):void {
        _step = value;
    }

    public function NumericStepper(id:String = '', styleName:String = '', type:String = Control.NUMERIC_STEPPER) {
        _settings = new StepperSettings();
        super(id, styleName, type)
    }

    override protected function initControls():void {

        plusButton = new Button(id + "_plusButton", settings.buttonStyleName);
        plusButton.$initButton(_settings.buttonAreaWidth, "50%", "+", plusHandler);
        plusButton.layout.align(Layout.RIGHT, Layout.TOP);

        minusButton = new Button(id + "_minusButton", settings.buttonStyleName);
        minusButton.$initButton(_settings.buttonAreaWidth, "50%", "-", minusHandler);
        minusButton.layout.align(Layout.RIGHT, Layout.BOTTOM);

        input = new Input(id + "_input", settings.inputStyleName)
        input.$initLabel(this.width - _settings.buttonAreaWidth, "100%", value.toString());
        input.layout.contentHAlign = Layout.MIDDLE;
        input.layout.paddingLeft = 3;
        input.addEventListener(Event.CHANGE, inputChangeHandler);
        input.setIntInput(3);


        addChilds([input, plusButton, minusButton]);
    }

    private function inputChangeHandler(event:Event):void {
        if (input.textfieldReference)
        {
            value = Number(input.textfieldReference.text);
        }
    }

    private function minusHandler(event:Event):void {
        value = value - step;
    }

    private function plusHandler(event:Event):void {
        value = value + step;
    }

    override public function invalidate(property:String = 'all', callLater:Boolean = true, updateParent:Boolean = true, updateChilds:Boolean = true):void {

        if(InvalidationType.STYLES)
        {
            if(settings.buttonStyleName)
            {
                plusButton.styleName = minusButton.styleName = settings.buttonStyleName;
                plusButton.invalidateStyle();
                minusButton.invalidateStyle();
            }

            if(settings.inputStyleName)
            {
                input.styleName = settings.inputStyleName;
                input.invalidateStyle();
            }
        }

        if (property == InvalidationType.SIZE && input) {
            input.width = this.width - _settings.buttonAreaWidth;
        }

        super.invalidate(property, callLater, updateParent, updateChilds);
    }

    public function get settings():StepperSettings {
        return _settings;
    }

    public function set settings(value:StepperSettings):void {
        _settings = value;
    }
}
}
