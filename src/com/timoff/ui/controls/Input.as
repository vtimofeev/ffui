package com.timoff.ui.controls {
import flash.text.TextField;

public class Input extends Label {

    private var _editable:Boolean = true;
    private var _maxChars:int = -1;
    private var _restrict:String = null;

    public function get textfield():TextField
    {
        return _textfieldRef;
    }

    public function Input(id:String = null, styleName:String = null, type:String = Control.INPUT, contentRender:Class = null) {
        super(id, styleName, type, contentRender);
    }


    public function get editable():Boolean {
        return _editable;
    }

    public function set editable(value:Boolean):void {
        _editable = value;
    }

    public function setNumericInput(length:int):void
    {
        _restrict = "-. 0-9"
        _maxChars = length;
    }

    public function setIntInput(length:int):void
    {
        _restrict = "- 0-9"
        _maxChars = length;
    }

    public function setUintInput(length:int):void
    {
        _restrict = "0-9"
        _maxChars = length;
    }


    public function setTextInput(length:int):void
    {
        _restrict = null;
        _maxChars = length;
    }


    public function get maxChars():int {
        return _maxChars;
    }

    public function set maxChars(value:int):void {
        _maxChars = value;
    }

    public function get restrict():String {
        return _restrict;
    }

    public function set restrict(value:String):void {
        _restrict = value;
    }
}
}