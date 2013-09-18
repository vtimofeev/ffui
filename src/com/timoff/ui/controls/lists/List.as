/**                     l;;;;;;;;; uyc
 * Created by IntelliJ IDEA.
 * User: Vasily
 * Date: 28.04.11
 * Time: 16:53
 * To change this template use File | Settings | File Templates.
 */
package com.timoff.ui.controls.lists {
import com.timoff.ui.containers.ContentContainer;
import com.timoff.ui.controls.Control;
import com.timoff.ui.controls.Scroller;
import com.timoff.ui.controls.lists.renders.LabelItem;
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.data.controls.ListSettings;
import com.timoff.ui.data.controls.ScrollRules;
import com.timoff.ui.data.core.InvalidationType;
import com.timoff.ui.events.ScrollEvent;
import com.timoff.ui.interfaces.IListItem;
import com.timoff.ui.layout.Layout;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

//import mx.binding.utils.BindingUtils;


public class List extends ContentContainer {

    private var _dataProvider:Vector.<Object> = new Vector.<Object>();
    private var _beginFrom:Number = 0;
    private var _showItems:Number = 0;

    public var selectedIndex:int = -1;
    public var selectedData:Object;
    private var selectedIndexes:Vector.<uint> = new Vector.<uint>();

    // customize fields

    // label field
    // label function
    // filters
    // scroll settings

    // internal scrollers instances
    protected var hScrollInstance:IEventDispatcher;
    protected var vScrollInstance:IEventDispatcher;

    // external scrollers instances
    protected var hScrollManager:IEventDispatcher;
    protected var vScrollManager:IEventDispatcher;

    private var _requiredHScroll:Boolean = false;
    private var _requiredVScroll:Boolean = false;

    private var _hScrollRule:uint = ScrollRules.OFF;
    private var _vScrollRule:uint = ScrollRules.AUTO;

    // items & scrollers generator
    protected var ItemRendererClass:Class = LabelItem;
    protected var HScrollRendererClass:Class = Scroller;
    protected var VScrollRendererClass:Class = Scroller;

    private var itemsAtView:Dictionary = new Dictionary(true);
    private var itemsAtCache:Dictionary = new Dictionary(true);
    private var itemsAtFreeCache:Vector.<IListItem> = new Vector.<IListItem>();

    private var _settings:ListSettings = new ListSettings();

    public function get dataProvider():Object {
        return _dataProvider;
    }

    public function set dataProvider(value:Object):void {
        _dataProvider = value as Vector.<Object>;
        if (dataProvider.length < 7 ) height = int(settings.itemHeight) * dataProvider.length;
        invalidate(InvalidationType.CHILDS, false, false)
    }

    public function List(id:String = '', styleName:String = '', direction:String = Layout.VERTICAL, ItemRendererClass:Class = null, type:String = Control.PANEL) {
        super(id, styleName, type)

        layout.direction = direction;
        contentContainer.layout.layout = layout.direction;

        if (ItemRendererClass) this.ItemRendererClass = ItemRendererClass;
    }

    override protected function addEventListeners():void {
        super.addEventListeners();

        addEventListener(ScrollEvent.EVENT_PREV, prevHandler, false, 1, true);
        addEventListener(ScrollEvent.EVENT_NEXT, leftHandler, false, 1, true);
        addEventListener(ScrollEvent.EVENT_SCROLL_TO, scrollToHandler, false, 1, true);
    }

    protected function scrollToHandler(event:ScrollEvent):void {
        scrollToValue(event.value);
    }

    private function leftHandler(event:Event):void {
        scrollToRelativeValue(1);
    }

    private function prevHandler(event:Event):void {
        scrollToRelativeValue(-1);
    }

    override protected function initControls():void {
        super.initControls();
        contentContainer.layout.percentWidth = 100;
        addChilds([contentContainer]);
    }

    protected function updateItems():void {
        if (!dataProvider) {
            freeItems();
            return;
        }
        if (!dataProvider.length) {
            freeItems();
            return;
        }

        calculateShowItems();
        //trace("List::UpdateItems " + _beginFrom + " , " + showItems);

        const totalItemsCount:int = dataProvider.length;
        const max:Number = max;
        const min:Number = max;

        var show:Boolean;
        var isItemAtView:Boolean;
        var indexAtProvider:int;
        var displayItem:IListItem;
        var freeItem:IListItem;
        var drawFlag:Boolean
        var cacheItem:IListItem;

        for (var i:int = 0; i < totalItemsCount; i++) {
            show = (i >= _beginFrom) ? i < (_beginFrom + showItems) : false;
            indexAtProvider = i;
            isItemAtView = itemsAtView[indexAtProvider] ? true : false;

            if (!show) {
                if (isItemAtView) {
                    displayItem = itemsAtView[indexAtProvider];
                    freeItem = contentContainer.removeChild(displayItem as DisplayObject) as IListItem;

                    itemsAtView[indexAtProvider] = null;

                    if (settings.useCache) {
                        itemsAtCache[indexAtProvider] = freeItem;
                    }
                    else {
                        itemsAtFreeCache.push(freeItem);
                    }
                }
                continue;
            }
        }

        for (var i:int = 0; i < showItems; i++) {
            drawFlag = false;
            freeItem = cacheItem = null;

            indexAtProvider = Math.floor(_beginFrom + i);
            displayItem = itemsAtView[indexAtProvider];

            if (displayItem) {
                IListItem(displayItem).sortOrder = i;
                continue;
            }

            var data:* = dataProvider[indexAtProvider];

            if (settings.useCache) {
                cacheItem = itemsAtCache[indexAtProvider] as IListItem;
                if (cacheItem) itemsAtCache[indexAtProvider] = null;
            }
            else {
                freeItem = itemsAtFreeCache.length ? itemsAtFreeCache.pop() : null;
            }

            drawFlag = !freeItem && !cacheItem;

            var itemInstance:IListItem = freeItem ? freeItem : cacheItem ? cacheItem : new ItemRendererClass(null, settings.itemStyle);

            itemsAtView[indexAtProvider] = itemInstance;
            itemInstance.sortOrder = i;
            itemInstance.setClickCallback(clickCallback);

            if(indexAtProvider == selectedIndex) if ('selected' in itemInstance) Object(itemInstance).selected = true;


            if (!cacheItem) {
                FFComponent(itemInstance).$setSize(settings.itemWidth, settings.itemHeight);
                FFComponent(itemInstance).layout.contentHAlign = Layout.LEFT;
                FFComponent(itemInstance).layout.padding = 10;
                FFComponent(itemInstance).isFreeable = false;
                itemInstance.setData(data);
            }

            addContentChild(itemInstance as DisplayObject);

            if (drawFlag || freeItem) {
                FFComponent(itemInstance).drawNow();
            }
        }

        //updateTime = getTimer();
        contentContainer.containerChilds.sortOn("sortOrder", 16);
        contentContainer.updateLayout();

        //trace("List::UpdateItemsXY " + _beginFrom % 1);

        if (layout.direction == Layout.VERTICAL) {
            contentContainer.layout.isLayable = false;
            contentContainer.y = -(_beginFrom % 1) * int(settings.itemHeight);

        }
    }


    public function freeItems():void {
        selectedIndex = -1;
        selectedIndexes = new Vector.<uint>();

        itemsAtView = new Dictionary(true);
        itemsAtCache = new Dictionary(true);
        itemsAtFreeCache = new Vector.<IListItem>();
        return;
    }

    public function get max():Number {
        calculateShowItems();
        return dataProvider ? dataProvider.length - showItems : 0;
    }

    public function get min():Number {
        return 0;
    }

    private function calculateShowItems():Number {

        var result:Number = 0;

        if (settings.itemsAtViewCount == -1) {
            switch (layout.direction) {
                case Layout.HORISONTAL:
                    result = this.contentContainer.width / int(settings.itemWidth);
                    break;

                default:
                    result = this.contentContainer.height / int(settings.itemHeight);
                    break;
            }

        }
        else {
            result = dataProvider ? dataProvider.length < settings.itemsAtViewCount ? dataProvider.length : settings.itemsAtViewCount : result;
        }

        result = dataProvider ? dataProvider.length < result ? dataProvider.length : result : result;

        _showItems = result
        checkScrollers();
        return result;

    }

    protected function checkScrollers():void {
        var requiredCountScroller:Boolean = dataProvider ? dataProvider.length > showItems : false;
        var requiredSizeScroller:Boolean = layout.direction == Layout.HORISONTAL ? int(settings.itemHeight) > contentContainer.contentHeight : false;
        requiredSizeScroller = layout.direction == Layout.HORISONTAL ? int(settings.itemWidth) > contentContainer.contentWidth : false;

        requiredHScroll = layout.direction == Layout.HORISONTAL ? requiredCountScroller : requiredHScroll;
        requiredVScroll = layout.direction == Layout.VERTICAL ? requiredCountScroller : requiredVScroll;
    }

    private function checkScrollValue(value):Number {
        value = value < min ? min : value;
        value = value > max ? max : value;
        return value;
    }

    public function scrollToValue(value:Number):void {
        beginFrom = checkScrollValue(value);
        return;
    }

    public function scrollToRelativeValue(value:Number):Number {
        return beginFrom = checkScrollValue(beginFrom + value);
    }

    public function get selectedItem():Object {
        if (selectedIndex >= 0 && dataProvider)
            return dataProvider[selectedIndex];
        else
            return null;
    }

    public function get showItems():Number {
        return _showItems;
    }

    public function get settings():ListSettings {
        return _settings;
    }

    public function set settings(value:ListSettings):void {
        if (value.itemInListRenderer) ItemRendererClass = value.itemInListRenderer;
        _settings = value;
    }

    public function get beginFrom():Number {
        return _beginFrom;
    }

    public function set beginFrom(value:Number):void {

        _beginFrom = value;
        invalidate(InvalidationType.CHILDS, false, false)
    }

    override public function updateLayout():void {
        super.updateLayout();
        updateItems();
    }

    override protected function draw():void {
        super.draw();

        var maskArea:DisplayObject = contentContainer.stateManager.getHitArea();//DrawManager.drawRectangle(RectangleStyleObject.getSimpleStyle(true,[0x000000],[1], false, 0, [0], [0] ), contentContainer.width, contentContainer.height);
        if (int(maskArea.width) != int(_hitAreaObject.width) && int(maskArea.height) != int(_hitAreaObject.height)) {
            replaceContent(_hitAreaObject, maskArea);
            contentContainer.mask = _hitAreaObject;
        }
    }


    public function get requiredVScroll():Boolean {
        return _requiredVScroll;
    }

    public function set requiredVScroll(value:Boolean):void {
        if (_requiredVScroll == value) return;
        _requiredVScroll = value;
        if (value && vScrollRule > ScrollRules.EXTERNAL) {
            if (!vScrollInstance) {
                vScrollInstance = new VScrollRendererClass("_vScroller", '', '', Layout.VERTICAL);
                FFComponent(vScrollInstance).$setSize(20, "100%");
                FFComponent(vScrollInstance).isFreeable = false;
                FFComponent(vScrollInstance).layout.align(Layout.RIGHT, Layout.TOP);
                Scroller(vScrollInstance).client = this;
            }

            if (!this.contains(vScrollInstance as DisplayObject)) {
                contentContainer.layout.paddingRight = FFComponent(vScrollInstance).width;
                addVScrollerTimeout = setTimeout(addVScroller, 30);
                //addVScroller();

            }

        }
    }

    private var addVScrollerTimeout:int;


    private function addVScroller():void {
        clearTimeout(addVScrollerTimeout);
        if (!this.contains(vScrollInstance as DisplayObject)) {
            this.addChild(vScrollInstance as DisplayObject);
        }
    }

    public function get requiredHScroll():Boolean {
        return _requiredHScroll;
    }

    public function set requiredHScroll(value:Boolean):void {
        _requiredHScroll = value;
    }

    public function get hScrollRule():uint {
        return _hScrollRule;
    }

    public function set hScrollRule(value:uint):void {
        _hScrollRule = value;
    }

    public function get vScrollRule():uint {
        return _vScrollRule;
    }

    public function set vScrollRule(value:uint):void {
        _vScrollRule = value;
    }

    //--------------------------------------------------------------------------------------
    // Item handlers
    //--------------------------------------------------------------------------------------

    protected function clickCallback(event:Event = null) {

        var indexAtProvider:int;
        var item:Object;

        for (var i:int = 0; i < showItems; i++) {
            indexAtProvider = Math.floor(_beginFrom + i);
            item = itemsAtView[indexAtProvider];
            if(item == event.currentTarget)
            {
                selectedIndex = indexAtProvider;
                selectedData = IListItem(item).getData();
            }
            else
            {
                if('selected' in item) {
                    item.selected = false;
                    item.invalidateSize();
                }
            }
        }

        dispatchEvent(new Event('indexChange'));

    }
}
}
