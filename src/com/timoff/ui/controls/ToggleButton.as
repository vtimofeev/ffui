package com.timoff.ui.controls {
import com.timoff.ui.interfaces.ILogicalGroupClient;

import flash.events.Event;

public class ToggleButton extends Button implements ILogicalGroupClient {

    private var _groupName:String;
    protected var _group:LogicalButtonGroup;
    private var _value:Object;

    public function ToggleButton(id:String = null, styleName:String = null, group:String = null, type:String = Control.TOGGLEBUTTON, contentRender:Class = null) {

        super(id, styleName, type, contentRender);
        if (group) groupName = group;
    }

    override public function get states():Array {
        return new Array(
                State.DEFAULT,
                State.DISABLED,
                State.DOWN,
                State.OVER,
                State.SELECTED_DEFAULT,
                State.SELECTED_DOWN,
                State.SELECTED_OVER
                );
    }


    override public function set selected(value:Boolean):void {
        if (selected == value) return;
        super.selected = value;
        state = getSelectedState(state, value);
        dispatchEvent(new Event(Event.CHANGE));
    }

    protected function getSelectedState(state:String, value:Boolean):String {
        if (value) {
            switch (state) {
                case State.DEFAULT:
                    return State.SELECTED_DEFAULT;
                case State.DOWN:
                    return State.SELECTED_DOWN;
            }
        }
        else {
            switch (state) {
                case State.SELECTED_DEFAULT:
                    return State.DEFAULT;
                case State.SELECTED_DOWN:
                    return State.DOWN;
            }
        }

        return State.DEFAULT;
    }

    override public function clickHandler(event:Event):void {
        if (_group != null) {
            _group.selection = _group.selection == this ? null : this;
        } else {
            selected = !selected;
        }

        super.clickHandler(event);
    }

    public function get groupName():String {
        return _groupName;
    }

    public function set groupName(value:String):void {

        if (value == _groupName) return;

        if (_group != null) {
            _group.removeClient(this);
            _group.removeEventListener(Event.CHANGE, groupChangeHandler);
        }

        _group = (value == null) ? null : LogicalButtonGroup.getGroup(value);

        if (_group != null) {
            // Default to the easiest option, which is to select a newly added selected rb.
            _group.addClient(this);
            _group.addEventListener(Event.CHANGE, groupChangeHandler, false, 0, true);
        }

        _groupName = value;
        return;
    }

    private function groupChangeHandler(event:Event):void {
        selected = _group.selection == this;
    }

    /*
     public function set groupName(group:String):void {

     if (_group != null) {
     _group.removeRadioButton(this);
     _group.removeEventListener(Event.CHANGE,handleChange);
     }
     _group = (group == null) ? null : RadioButtonGroup.getGroup(group);
     if (_group != null)
     {
     // Default to the easiest option, which is to select a newly added selected rb.
     _group.addRadioButton(this);
     _group.addEventListener(Event.CHANGE,handleChange,false,0,true);
     }

     }

     public function get group():RadioButtonGroup {

     return _group;

     }

     public function set group(name:RadioButtonGroup):void {

     groupName = name.name;

     }

     protected function handleChange(event:Event):void
     {
     toggle = (_group.selection == this);
     dispatchEvent(new Event(Event.CHANGE, true));
     }

     private function setThis():void {
     var g:RadioButtonGroup = _group;
     if(g != null) {
     if (g.selection != this) {
     g.selection = this;
     }
     } else {
     toggle = true;
     }
     }

     */

    public function get value():Object {
        return _value;
    }

    public function set value(value:Object):void {
        _value = value;
    }
}
}