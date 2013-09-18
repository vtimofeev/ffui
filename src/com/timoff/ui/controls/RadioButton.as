/**
 * Author: Vasily
 * Web: http://timoff.com
 * Date: 19.05.11
 * Time: 9:56
 */
package com.timoff.ui.controls {
import com.timoff.ui.events.ButtonEvent;
import flash.events.Event;

public class RadioButton extends ToggleButton {
    public function RadioButton(id:String = null, styleName:String = null, group:String = null, type:String = Control.RADIOBUTTON, contentRender:Class = null) {
        super(id, styleName, group,  type, contentRender);
    }

    override public function clickHandler(event:Event):void {
        if (_group != null) {
            _group.selection = this;
        } else {
            selected = true;
        }
        dispatchEvent(new Event(ButtonEvent.CLICK))
    }
}
}
