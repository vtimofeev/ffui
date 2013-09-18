/**
 * Created by IntelliJ IDEA.
 * User: Vasily
 * Date: 06.05.11
 * Time: 17:19
 * To change this template use File | Settings | File Templates.
 */
package com.timoff.ui.controls.lists {
import com.timoff.ui.containers.Container;

import com.timoff.ui.controls.Button;
import com.timoff.ui.controls.Control;
import com.timoff.ui.controls.Label;
import com.timoff.ui.data.controls.ListSettings;

import com.timoff.ui.layout.Layout;
import com.timoff.ui.managers.PopUpManager;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

public class ComboBox extends Container {

    private var _dataProvider:Vector.<Object> = new Vector.<Object>();
    private var _selectedIndex:int = -1;
    private var _selectedIndexes:Vector.<uint> = new Vector.<uint>();

    private var dropdownBtn:Button;
    private var label:Label;

    private var _settings:ListSettings = new ListSettings();

    protected var isMouseRegistred:Boolean = false;
    protected var listReferrence:List;
    protected var list:List;

    public var selectedData:Object = null;


    public function ComboBox(id:String = '', styleName:String = '', type:String = Control.COMBOBOX)
    {
        super(id, styleName, type)
    }

    override protected function addEventListeners():void {
        super.addEventListeners();
    }

    override protected function initControls():void {
        super.initControls();

        layout.layout = Layout.HORISONTAL;

        dropdownBtn = new Button(id + "_btn");
        dropdownBtn.$initButton(16, "100%", "+", dropdownClickHandler);
        dropdownBtn.layout.margin = 0;

        label = new Label(id + "_label");
        label.$initLabel(1, "100%", "");
        label.layout.isSpacer = true;
        label.label = "";
        label.addEventListener(MouseEvent.MOUSE_UP, dropdownClickHandler, false, 1, true);
        label.useHandCursor = true;

        this.addChilds([label,dropdownBtn]);
    }

    public function set isEnvelopedLabel(value:Boolean):void
    {
        label.layout.isEnveloped = value;
        label.invalidateSize();
    }

    public function set isEnvelopedTextLabel(value:Boolean):void
    {
        label.layout.isEnvelopedLabel = value;
        label.invalidateSize();
    }


    private function dropdownClickHandler(event:Event):void
    {
        if(list) return;

        list = PopUpManager.createPopUp(List, facadeId, id + "_listPart") as List;
        list.settings = settings;
        list.$setSize(this.width, 500);
        list.dataProvider = dataProvider;
        list.layout.isLayable = false;
        list.addEventListener("indexChange", changeIndexHandler, false, 1, true);

        if (!list.parent) this.parent.addChild(list);

        var bounds:Rectangle = this.getRect(list.parent);
        //trace ("CB in LIST:: " + bounds.x + " , " + bounds.y );

        list.x = bounds.x;
        list.y = bounds.y + this.height;
        trace ("LIST .... ",  list.y , list.height, stage.height);

        if ( (list.height + list.y) > stage.height)
        {
            list.y = bounds.y - list.height;
        }

        trace ("LIST .... ",  list.y , list.height, stage.height);

        isMouseRegistred = true;

        addStageEventListener(Event.MOUSE_LEAVE, removeListHandler, null, false, 1, true);
        addStageEventListener(MouseEvent.CLICK,  removeListHandler, null, false, 1, true);

        this.addEventListener(MouseEvent.MOUSE_OVER, registerMouse, false, 1, true);
        list.addEventListener(MouseEvent.MOUSE_OVER, registerMouse, false, 1, true);
        this.addEventListener(MouseEvent.MOUSE_OUT, unregisterMouse, false, 1, true);
        list.addEventListener(MouseEvent.MOUSE_OUT, unregisterMouse, false, 1, true);
    }

    private function changeIndexHandler(event:Event):void {

        selectedIndex = list.selectedIndex;
        selectedData = list.selectedData;

        removeListHandler(event, true);

        if(selectedData) if("label" in selectedData) label.label = selectedData.label;




    }

    private function removeListHandler(event:Event, force:Boolean = false):void {

        if (isMouseRegistred && !force) return;

        removeStageEventListener(Event.MOUSE_LEAVE, removeListHandler);
        removeStageEventListener(MouseEvent.CLICK,  removeListHandler);

        removeEventListener(MouseEvent.MOUSE_OVER, registerMouse, false);
        list.removeEventListener(MouseEvent.MOUSE_OVER, registerMouse, false);
        removeEventListener(MouseEvent.MOUSE_OUT, unregisterMouse, false);
        list.removeEventListener(MouseEvent.MOUSE_OUT, unregisterMouse, false);

        list.parent.removeChild(list);
        list.free();
        list = null;
    }

    private function registerMouse(event:Event):void {
        //trace (id + " mouse is ");
        isMouseRegistred = true;
    }

    private function unregisterMouse(event:Event):void {
        //trace (id + " mouse out ");
        isMouseRegistred = false;
    }


    public function get dataProvider():Object {
        return _dataProvider;
    }

    public function set dataProvider(value:Object):void {
        _dataProvider = value as Vector.<Object>;
        selectedIndex = -1;
    }

    public function get selectedIndex():int {
        return _selectedIndex;
    }

    public function set selectedIndex(value:int):void {
        if(selectedIndex == value) return;

        if(value >=  0 && dataProvider)
        {
            if(value < dataProvider.length)
            {
                var data:Object = dataProvider[value];
                if('label' in data)
                    label.label = data['label'];

                selectedData = data;
            }
        }

        if(value < 0)
        {
            label.label = settings.minusLabel;
            selectedData = null;
        }

        _selectedIndex = value;
        dispatchEvent(new Event(Event.CHANGE));
    }

    public function get selectedIndexes():Vector.<uint> {
        return _selectedIndexes;
    }

    public function set selectedIndexes(value:Vector.<uint>):void {
        _selectedIndexes = value;
    }

    public function get settings():ListSettings {
        return _settings;
    }

    public function set settings(value:ListSettings):void {
        _settings = value;
    }
}
}
