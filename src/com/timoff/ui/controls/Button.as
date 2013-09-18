package com.timoff.ui.controls {
import com.timoff.ui.controls.Button;
import com.timoff.ui.events.ButtonEvent;
import com.timoff.ui.interfaces.IInteractiveObject;

import com.timoff.ui.layout.Layout;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.registerClassAlias;

public class Button extends Label implements IInteractiveObject {

    private var _selected:Boolean = false;
    private var _disabledMouse:Boolean = false;

    [Event(name="buttonClick", type="flash.events.Event")]
    public function Button(id:String = null, styleName:String = null, type:String = Control.BUTTON, contentRender:Class = null) {

        super(id, styleName, type, contentRender);
        layout.contentAlign(Layout.HORISONTAL, Layout.CENTER, Layout.MIDDLE);
        buttonMode = true;
        useHandCursor = true;
    }

    override protected function addEventListeners():void {

        this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 1, true);
        this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 1, true);
        this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 1, true);
        this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 1, true);
    }

    override public function get states():Array {

        return new Array(
                State.DEFAULT,
                State.DISABLED,
                State.DOWN,
                State.OVER
                );
    }

    public function mouseOverHandler(event:MouseEvent):void {
        if (_disabledMouse || !enabled)
            return;

        if (!_selected)
            state = State.OVER;
        else
            state = State.SELECTED_OVER;

    }

    public function mouseOutHandler(event:MouseEvent):void {
        if (_disabledMouse || !enabled)
            return;

        if (!_selected)
            state = State.DEFAULT;
        else
            state = State.SELECTED_DEFAULT;
    }

    public function mouseDownHandler(event:MouseEvent):void {
        if (_disabledMouse || !enabled)
            return;

        if (!_selected)
            state = State.DOWN;
        else
            state = State.SELECTED_DOWN;

        //event.stopImmediatePropagation();

    }

    public function mouseUpHandler(event:MouseEvent):void {
        if (_disabledMouse || !enabled)
            return;

        clickHandler(event);

        if (!_selected)
            state = State.OVER;
        else
            state = State.SELECTED_OVER;


    }

    public function clickHandler(event:Event):void {
        dispatchEvent(new Event(ButtonEvent.CLICK));
    }

    public function get selected():Boolean {
        return _selected;
    }

    public function set selected(value:Boolean):void {
        _selected = value;
    }

    public function get disableMouse():Boolean {
        return _disabledMouse;
    }

    public function set disableMouse(value:Boolean):void {
        _disabledMouse = value;
    }

    public function $initButton(width:Object, height:Object, label:String = "", clickHandler:Function = null, contentHAlign:String = null, contentVAlign:String = null):void {
        Button.$init( this, width, height, label, clickHandler, contentHAlign, contentVAlign);
    }

    public static function $init(object:Button, width:Object, height:Object, label:String = "", clickHandler:Function = null, contentHAlign:String = null, contentVAlign:String = null):void {
        object.$setSize(width, height);

        if (Boolean(clickHandler)) object.addEventListener(ButtonEvent.CLICK, clickHandler, false, 1, true);

        if (contentHAlign) object.layout.contentHAlign = contentHAlign;
        if (contentVAlign) object.layout.contentHAlign = contentVAlign;

        object.label = label;
        return;
    }
}
}