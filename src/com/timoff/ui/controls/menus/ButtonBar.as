/**
 * Author: Vasily
 * Web: http://timoff.com
 * Date: 20.05.11
 * Time: 16:52
 */
package com.timoff.ui.controls.menus {
    import com.timoff.ui.containers.Container;
    import com.timoff.ui.controls.Control;
    import com.timoff.ui.controls.LogicalButtonGroup;
    import com.timoff.ui.controls.RadioButton;
    import com.timoff.ui.controls.ToggleButton;
    import com.timoff.ui.data.controls.ButtonBarSettings;
    import com.timoff.ui.data.core.InvalidationType;
    import com.timoff.ui.interfaces.IDataProvider;
    import com.timoff.ui.interfaces.ISelectableDataProvider;

    import flash.events.Event;
    import flash.utils.Dictionary;

    public class ButtonBar extends Container implements IDataProvider, ISelectableDataProvider {

    private var _dataProvider:Vector.<Object>;
    private var _selectedIndex:int = -1;
    private var _selectedValue:Object;
    private var _selectedItem:Object = null;
    private var _settings:ButtonBarSettings = new ButtonBarSettings();

    private var ItemRendererClass:Class;
    private var itemsMap:Dictionary;
    private var _groupName:String;
    protected var group:LogicalButtonGroup;

    public function ButtonBar(id:String = null, styleName:String = null, groupName:String = null, type = Control.BUTTON_BAR) {
        super(id, styleName, type)
        ItemRendererClass = RadioButton;
        if (groupName) this._groupName = groupName;
        else this._groupName = this.id;

        group = LogicalButtonGroup.getGroup(this._groupName);
        group.addEventListener(Event.CHANGE, groupChangeHandler, false, 1, true)
    }

    private function groupChangeHandler(event:Event):void {

        if(group.selection)
        {
            _selectedIndex = itemsMap[group.selection];
            _selectedItem = _selectedIndex >= 0 ? dataProvider[_selectedIndex]: null;
            if (group.selection is ToggleButton) selectedValue = ToggleButton(group.selection).value
        }
        else
        {
            _selectedIndex = -1;
            _selectedItem = null;
            _selectedValue = null;
        }

        dispatchEvent(new Event(Event.CHANGE));
    }

    protected function updateItems():void {

        freeItems();
        if (!dataProvider) {

            return;
        }
        if (!dataProvider.length) {

            return;
        }

        const totalItemsCount:int = dataProvider.length;

        for (var i:int = 0; i < totalItemsCount; i++) {
            var data:Object = dataProvider[i];
            var styleName:String = getItemStyleName(i);

            var itemInstance:ToggleButton = new ItemRendererClass(id + "_" + i, getItemStyleName(i));
            itemInstance.$setSize(settings.itemWidth, settings.itemHeight);
            itemInstance.groupName = this._groupName;
            if(settings.isRoundedButtons)
            {
                setRoundCornersToItem(itemInstance, i, totalItemsCount);
            }

            try {
                itemInstance.label = settings.labelFunction ? settings.labelFunction(data) : settings.labelField in data ? data[settings.labelField] : '';
                itemInstance.value = settings.valueFunction ? settings.valueFunction(data) : settings.valueField in data ? data[settings.valueField] : null;
            }
            catch(error:Error) {
                log.error("Has an error in " + id + " at label/value setting for " + i + " item");
            }
            itemsMap[itemInstance] = i;
            addChild(itemInstance);
        }

    }

    private function setRoundCornersToItem(item:ToggleButton, i:int, itemsCount:int):void {

        var radiuses:Array = i==0?settings.firstButtonRadiuses:i==(itemsCount-1)?settings.endButtonRadiuses:settings.midButtonRadiuses;
        item.setStyleToAllStates("defaultBackgroundStyle", "roundCornersRadiuses",  radiuses);

    }

    private function getItemStyleName(value:int):String {
        var result:String = settings.midButtonStyleName;
        result = value == 0 ? settings.firstButtonStyleName : result;
        result = dataProvider.length - 1 == value ? settings.endButtonStyleName : result;
        result = dataProvider.length < 3 ? settings.midButtonStyleName : result;
        result = settings.styleNameField ? settings.styleNameField in dataProvider[value] ? Object(dataProvider[value])[settings.styleNameField] : result : result;
        return result;
    }

    private function freeItems():void {
        removeChilds();
        itemsMap = new Dictionary(true);
    }


    public function get dataProvider():Object {
        return _dataProvider;
    }

    public function set dataProvider(value:Object):void {
        _dataProvider = value as Vector.<Object>;
        //callLater(updateItems);
        updateItems();
        invalidate(InvalidationType.DATA, false, false);
    }

    public function get selectedIndex():int {
        return _selectedIndex;
    }

    public function get selectedItem():Object {
        return _selectedItem;
    }

    public function get settings():ButtonBarSettings {
        return _settings;
    }

    public function set settings(value:ButtonBarSettings):void {
        _settings = value;
    }

    public function get selectedValue():Object {
        return _selectedValue;
    }

    public function set selectedValue(value:Object):void {
        _selectedValue = value;
    }
}
}
