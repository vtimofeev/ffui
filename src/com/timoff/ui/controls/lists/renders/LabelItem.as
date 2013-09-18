/**
 * Created by IntelliJ IDEA.
 * User: Vasily
 * Date: 04.05.11
 * Time: 13:13
 * To change this template use File | Settings | File Templates.
 */
package com.timoff.ui.controls.lists.renders {
import com.timoff.ui.controls.Control;
import com.timoff.ui.controls.Label;
import com.timoff.ui.controls.State;
import com.timoff.ui.controls.ToggleButton;
import com.timoff.ui.interfaces.IListItem;

import flash.events.Event;



public class LabelItem extends ToggleButton implements IListItem {
    private var data;
    private var _sortOrder:int = 0;
    private var clickCallback:Function;

    public function LabelItem(id:String = null, styleName:String = null, type:String = Control.TOGGLEBUTTON, contentRender:Class = null) {
        super(id, styleName, null, type, contentRender);
    }

    public function setData(value:Object):void {
        data = value;
        if("label" in value) label = value.label;
    }

    public function getData():Object {
        return data;
    }

    public function get sortOrder():int {
        return _sortOrder;
    }

    public function set sortOrder(value:int):void {
        _sortOrder = value;
    }


    override public function free(force:Boolean = false):void {
        data = null;
        selected = false;
        clickCallback = null;
        super.free(force);
    }

    public function setClickCallback(value:Function):void {
        clickCallback = value;
    }


    override public function clickHandler(event:Event):void {

        if(clickCallback) clickCallback(event);

        super.clickHandler(event);
    }
}
}
