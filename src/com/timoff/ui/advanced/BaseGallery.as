package com.timoff.ui.advanced {
import com.timoff.ui.containers.ContentContainer;
import com.timoff.ui.controls.Button;
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.data.controls.GalleryItemObject;
import com.timoff.ui.data.controls.GallerySettingsObject;
import com.timoff.ui.data.core.InvalidationType;
import com.timoff.ui.effects.EffectContent;
import com.timoff.ui.effects.EffectObject;
import com.timoff.ui.events.FFComponentEvent;
import com.timoff.ui.events.ScrollEvent;
import com.timoff.ui.geom.AdvancedRectangle;
import com.timoff.ui.interfaces.IGalleryItem;
import com.timoff.ui.layout.Layout;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Dictionary;
import flash.utils.Timer;
import flash.utils.clearInterval;
import flash.utils.getTimer;
import flash.utils.setInterval;

public class BaseGallery extends ContentContainer {


    public static const MODE_SCROLL_QUEUE:int = 1;
    public static const MODE_REFRESH_QUEUE:int = 0;

    private var _dataProvider:Vector.<GalleryItemObject>;
    private var _hasButtons:Boolean = true;
    private var _settings:GallerySettingsObject = new GallerySettingsObject();

    private var firstButton:Button;
    private var endButton:Button;

    private var _startIndex:Number = 0;
    protected var showChilds:Number = -1;
    private var _invalidateChilds:int = -1;

    private var ItemRenderrer:Class = BaseGalleryItem;
    private var itemRendererStyleName:String = '';

    private var itemRenders:Vector.<DisplayObject> = new Vector.<DisplayObject>();
    private var freeItemRenders:Vector.<IGalleryItem> = new Vector.<IGalleryItem>();
    private var cacheRenders:Dictionary = new Dictionary();
    private var itemIndexesMap:Dictionary = new Dictionary(true);
    private var itemDisplayObjectsMap:Dictionary = new Dictionary(true);


    private var itemClickHandler:Function;

    private var mode:int = MODE_SCROLL_QUEUE;
    private var scrollTasks:Array = [];
    private var scrollTimer:Timer = new Timer(100, 0);
    private var effectsEnabled:Boolean = true;
    private var updateTime:int = 0;
    private var useCache:Boolean = true;
    private var sortInterval:uint;


    public function BaseGallery(id:String = null, styleName:String = null, direction:String = Layout.HORISONTAL, hasButtons:Boolean = true, itemRenderrer:Class = null, itemRenderrerStyleName:String = '') {
        _hasButtons = hasButtons;
        super(id, styleName);
        layout.direction = direction;
        setSize(400, 300);
        this.layout.layout = layout.direction;

        if (itemRenderrer) this.ItemRenderrer = itemRenderrer;
        if (itemRenderrerStyleName) this.itemRendererStyleName = itemRendererStyleName;


    }

    override protected function initControls():void {
        super.initControls();

        firstButton = new Button(id + "_startButton");
        firstButton.$initButton(50, "100%", "<", firstClickHandler);

        endButton = new Button(id + "_endButton");
        endButton.$initButton(50, "100%", ">", endClickHandler);

        contentContainer.layout.layout = layout.direction;

        this.layout.layout = layout.direction;
        this.layout.gap = 0;

        contentContainer.layout.layout = Layout.HORISONTAL;
        contentContainer.layout.contentHAlign = Layout.CENTER;
        contentContainer.layout.contentVAlign = Layout.MIDDLE;

        applySettings();

        addEventListener(ScrollEvent.EVENT_PREV, leftHandler, false, 1, true);
        addEventListener(ScrollEvent.EVENT_NEXT, rightHandler, false, 1, true);
        addEventListener(ScrollEvent.EVENT_SCROLL_TO, scrollToHandler, false, 1, true);

        scrollTimer.addEventListener(TimerEvent.TIMER, scrollTimerHandler, false, 2, true);

        if (_hasButtons)
            addChilds([firstButton, contentContainer, endButton]);
        else
            addChilds([contentContainer]);


        updateLayout();
    }

    private function scrollTimerHandler(event:Event):void {


        if (!scrollTasks.length) {
            scrollTimer.stop();
            return;
        }
        var newStartIndex:int = scrollTasks[0];
        scrollTasks.splice(0, 1);
        //scrollTimer.delay = itemEffectDuration * 1000;

        invalidateChilds = newStartIndex < startIndex ? 1 : 0;
        startIndex = newStartIndex;


    }

    private function applySettings():void {
        contentContainer.layout.gap = settings.itemGap;
    }

    //------------------------------------------------------------------
    // Core
    //------------------------------------------------------------------

    protected function refreshChilds(direction:String = null):void {
        if (!dataProvider) return;
        if (!dataProvider.length) return;


        calculateShowItems();
        const countItems:int = dataProvider.length;
        trace("GALLERY::Refresh " + startIndex + " , " + showChilds);

        for (var i:int = 0; i < countItems; i++) {

            var show:Boolean = (i >= startIndex) ? i < (startIndex + showChilds) : false;
            if ((startIndex + showChilds > max + 1))
                if (!show) show = (startIndex + showChilds - max - 1 ) > i;


            var indexAtProvider:int = i;
            var itemAtView:Boolean = itemIndexesMap[indexAtProvider] ? true : false;

            if (!show) {
                if (itemAtView) {
                    var displayItem:DisplayObject = itemDisplayObjectsMap[indexAtProvider];
                    var freeItem:IGalleryItem = contentContainer.removeChild(displayItem) as IGalleryItem;

                    itemIndexesMap[indexAtProvider] = null;
                    itemDisplayObjectsMap[indexAtProvider] = null;

                    if (useCache) {
                        cacheRenders[indexAtProvider] = freeItem;
                    }
                    else {
                        freeItemRenders.push(freeItem);
                    }
                }
                continue;
            }
        }


        for (var i:int = 0; i < showChilds; i++) {

            var indexAtProvider:int = startIndex + i;
            indexAtProvider = indexAtProvider > max ? indexAtProvider - max - 1 : indexAtProvider;
            var itemAtView:Boolean = itemIndexesMap[indexAtProvider] ? true : false;
            var drawFlag:Boolean = false;
            var freeItem:IGalleryItem = null;
            var cacheItem:IGalleryItem = null;


            if (itemAtView) {
                IGalleryItem(itemDisplayObjectsMap[indexAtProvider]).sortOrder = i;
                continue;
            }

            var data:* = dataProvider[indexAtProvider];

            if (useCache) {
                cacheItem = cacheRenders[indexAtProvider] as IGalleryItem;
                if (cacheItem) cacheRenders[indexAtProvider] = null;

            }
            else {
                freeItem = freeItemRenders.length ? freeItemRenders.pop() : null;
            }

            if (!freeItem && !cacheItem) drawFlag = true;

            var itemInstance:IGalleryItem = freeItem ? freeItem : cacheItem ? cacheItem : new ItemRenderrer();

            if (itemInstance && (cacheItem || freeItem)) {
                DisplayObject(itemInstance).scaleX = DisplayObject(itemInstance).scaleY = 1;
            }


            itemIndexesMap[indexAtProvider] = data;
            itemDisplayObjectsMap[indexAtProvider] = itemInstance as DisplayObject;

            itemInstance.sortOrder = i;
            itemInstance.setData(data);

            trace("Ix in provider " + i + " , " + indexAtProvider)

            if (!cacheItem) {
                FFComponent(itemInstance).cacheAsBitmap = false;
                FFComponent(itemInstance).isFreeable = false;
                FFComponent(itemInstance).$setSize(settings.itemWidth, settings.itemHeight);
                FFComponent(itemInstance).setEffect(FFComponentEvent.EVENT_MOVE, moveEffect);
            }

            if (invalidateChilds == 1) {
                setInitialPosition(i, itemInstance as DisplayObject);
                contentContainer.addChildAt(itemInstance as DisplayObject, 0);
            }
            else {
                setInitialPosition(i, itemInstance as DisplayObject);
                addContentChild(itemInstance as DisplayObject);
            }

            if (drawFlag) {
                FFComponent(itemInstance).drawNow();
            }
        }

        updateTime = getTimer();


        contentContainer.containerChilds.sortOn("sortOrder", 16);
        invalidateChilds = -1;
        contentContainer.updateLayout();

        sortInterval = setInterval(delayedSort, itemEffectDuration / 2 + 20);

    }

    private function delayedSort():void {
        clearInterval(sortInterval);
        lastLayoutResult = contentContainer.lastLayoutResult;
        if (!lastLayoutResult) return;
        if (!(lastLayoutResult[0] is AdvancedRectangle)) return;


        var i:uint = 0;

        for each(var arect:AdvancedRectangle in lastLayoutResult) {

            var child:DisplayObject = contentContainer.containerChilds[i] as DisplayObject;
            if (arect.zIndex > -1) {
                var parent:DisplayObjectContainer = child.parent;
                parent.swapChildrenAt(parent.getChildIndex(child), arect.zIndex);
            }
            i++;
        }


    }


    protected function setInitialPosition(value:int, object:DisplayObject) {
        var itemInstance = object;

        DisplayObject(itemInstance).x = (contentContainer.width - settings.itemWidth / 2) / 2;
        DisplayObject(itemInstance).y = (contentContainer.height - settings.itemHeight / 2) / 2;
    }

    public function hasItem(value:GalleryItemObject):Boolean {
        for each (var item:IGalleryItem in contentContainer.ffchilds) {
            if (item.getData() == value) {
                return true;
            }
        }
        return false;
    }

    public function getItemIndex(value:GalleryItemObject):int {
        var i:int = 0;
        for each (var item:IGalleryItem in contentContainer.containerChilds) {
            if (item) {
                if (item.getData() == value)
                    return contentContainer.containerChilds.indexOf(item);
            }

            i++;
        }
        return -1;
    }


//------------------------------------------------------------------
// Setters
//------------------------------------------------------------------


    public function get dataProvider():Vector.<GalleryItemObject> {
        return _dataProvider;
    }

    public function set dataProvider(value:Vector.<GalleryItemObject>):void {
        _dataProvider = value;
        startIndex = 0;
        showChilds = calculateShowItems();
        contentContainer.removeChilds();
        itemIndexesMap = new Dictionary(true);
        itemDisplayObjectsMap = new Dictionary(true)
        cacheRenders = new Dictionary(true);
        invalidateChilds = 0;
        refreshChilds();
        contentContainer.updateLayout();

    }

    public function get settings():GallerySettingsObject {
        return _settings;
    }

    public function set settings(value:GallerySettingsObject):void {
        //layout.gap = value.itemGap;
        _settings = value;
        applySettings();
        invalidate(InvalidationType.ALL);
        contentContainer.invalidate(InvalidationType.ALL, false, false);
    }

    public function checkStartIndex(value:int):int {
        value = (value < 0) ? max : value;
        value = (value >= 0) ? value : min;
        value = (value > max) ? 0 : value;
        return value;
    }

//------------------------------------------------------------------
// Event Handlers
//------------------------------------------------------------------

    private function firstClickHandler(event:Event):void {

        dispatchEvent(new Event(ScrollEvent.EVENT_PREV));
    }

    public function leftHandler(event:Event):void {
        scrollByRelValue(-1);
    }


    protected function rightHandler(event:Event):void {
        scrollByRelValue(1);
    }

    protected function scrollToHandler(event:ScrollEvent) {
        var oldIndex:int = startIndex;

        if (mode == MODE_REFRESH_QUEUE) {

            startIndex = checkStartIndex(event.value);

            if (startIndex != oldIndex) {
                invalidateChilds = startIndex < oldIndex ? 1 : 0;
            }

        }
        else {

            var lastIndex:int = scrollTasks.length ? scrollTasks[scrollTasks.length - 1] : startIndex;
            var _scrollTask:Array = [];
            var _diff:int = checkStartIndex(event.value) - lastIndex;
            var _sign:int = _diff < 0 ? -1 : 1;
            _diff = _diff < 0 ? -_diff : _diff;

            for (var i = 1; i <= _diff; i++) {
                var index:int = lastIndex + i * _sign;

                var indexTask:int = scrollTasks.indexOf(index);
                trace("Index " + index + " , " + indexTask);
                if (indexTask >= 0) {
                    //scrollTasks.splice(indexTask, 1);
                    continue;
                }

                var result:int = index;
                if (result != startIndex)
                    scrollTasks.push(result);
            }

            log.debug("JoinTasks: " + scrollTasks.join(","));

            if (scrollTasks.length) {
                if (!scrollTimer.running) scrollTimer.start();
            }

        }
        return;
    }

    public function scrollByRelValue(value:int = 0) {

        var oldIndex:int = startIndex;

        var _diff:int = value;
        value = startIndex + value;


        if (mode == MODE_REFRESH_QUEUE) {

            startIndex = checkStartIndex(value);

            if (startIndex != oldIndex) {
                invalidateChilds = startIndex < oldIndex ? 1 : 0;
            }

        }
        else {

            var lastIndex:int = scrollTasks.length ? scrollTasks[scrollTasks.length - 1] : startIndex;
            var _scrollTask:Array = [];
            var checkedValue:int = checkStartIndex(value);
            var _sign:int = _diff < 0 ? -1 : 1;
            _diff = _diff < 0 ? -_diff : _diff;


            for (var i = 1; i <= _diff; i++) {
                var index:int = checkStartIndex(lastIndex + i * _sign);

                var indexTask:int = scrollTasks.indexOf(index);
                trace("Index " + index + " , " + indexTask);
                if (indexTask >= 0) {
                    continue;
                }
                var result:int = index;
                if (result != startIndex)
                    scrollTasks.push(result);
            }

            log.debug("JoinTasks: " + scrollTasks.join(","));
            if (scrollTasks.length) {
                if (!scrollTimer.running) scrollTimer.start();
            }

        }

        return;
    }


    public function get itemEffectDuration():Number {
        var result:Number = .21 / (scrollTasks.length + 1);
        return result < .08 ? .08 : result;

    }


    private function endClickHandler(event:Event):void {
        dispatchEvent(new Event(ScrollEvent.EVENT_NEXT));
    }


    protected function drawItemsContainer():void {
        var showChildsUpdated:Number = calculateShowItems();

        if (showChildsUpdated != showChilds) {
            //startIndex = 0;
            showChilds = showChildsUpdated;
            contentContainer.removeChilds();
            itemIndexesMap = new Dictionary(true);
            itemDisplayObjectsMap = new Dictionary(true)
            refreshChilds();
        }
        else
        if (invalidateChilds > -1) {
            refreshChilds();
        }


    }

    override protected function draw():void {
        super.draw();
    }

    protected function calculateShowItems():int {

        if (settings.showItems < 0) {
            log.debug("COUNT SHOW ITEMS:: " + contentContainer.contentWidth + " , " + settings.itemWidth);
            var showChildsUpdated:int = Math.floor(contentContainer.contentWidth / (settings.itemWidth + settings.itemGap));
            showChildsUpdated = (showChildsUpdated <= 0) ? 1 : showChildsUpdated;
        }
        else {
            showChildsUpdated = settings.showItems;
        }


        if (dataProvider) {
            if (showChildsUpdated > dataProvider.length) showChildsUpdated = dataProvider.length;
        }

        showChilds = showChildsUpdated;

        return showChildsUpdated;
    }


    public function get max():Number {
        return dataProvider ? dataProvider.length - 1 : 0;
    }

    public function get min():Number {
        return 0;
    }

    public function get value():Number {
        return startIndex;
    }

    public function get startIndex():int {
        return _startIndex;
    }

    public function set startIndex(value:int):void {
        if (_startIndex == value) return;

        this.invalidate(InvalidationType.ITEMS_LIST);
        _startIndex = value;
        dispatchEvent(new Event(Event.CHANGE));
    }

    public function get invalidateChilds():int {
        return _invalidateChilds;
    }

    public function set invalidateChilds(value:int):void {
        invalidate(InvalidationType.ITEMS_LIST);
        _invalidateChilds = value;

    }

    public function get moveEffect():EffectObject {
        var duration:Number = .2;

        var effect_move:EffectObject = new EffectObject(null, duration);
        effect_move.mathFunction = function (t:Number, b:Number, c:Number, d:Number) { return c * t / d + b; };

        effect_move.addContent(EffectContent.PROPERTY_X, 0, 0, duration);
        effect_move.addContent(EffectContent.PROPERTY_Y, 0, 0, duration);
        effect_move.addContent(EffectContent.PROPERTY_Z, 0, 0, duration);
        effect_move.addContent(EffectContent.PROPERTY_ROTATION_X, 0, 0, duration);
        effect_move.addContent(EffectContent.PROPERTY_ROTATION_Y, 0, 0, duration);
        effect_move.addContent(EffectContent.PROPERTY_SCALEX, 0, 0, duration);
        effect_move.addContent(EffectContent.PROPERTY_SCALEY, 0, 0, duration);
        //effect_move.addContent(EffectContent.PROPERTY_Z, 0, 0, duration);

        effect_move.useCenter = false;

        return effect_move;
    }


    public function get removeEffect():EffectObject {
        var duration:Number = .2;

        var effect:EffectObject = new EffectObject(null, duration);
        effect.mathFunction = function (t:Number, b:Number, c:Number, d:Number) {
            return c * t / d + b;
        }

        effect.addContent(EffectContent.PROPERTY_SCALEX, 1, 0, duration);
        effect.addContent(EffectContent.PROPERTY_SCALEY, 1, 0, duration);
        effect.useCenter = true;

        return effect;
    }


    override public function invalidate(property:String = InvalidationType.ALL, callLater:Boolean = true, updateParent:Boolean = true, updateChilds:Boolean = true):void {
        if (property == InvalidationType.ITEMS_LIST) {
            if (callLater) {
                this.callLater(drawItemsContainer);
            }
        }
        else
            super.invalidate(property, callLater, updateParent, updateChilds);
    }

}
2
}