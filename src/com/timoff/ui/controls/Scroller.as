/**
 * Created by IntelliJ IDEA.
 * User: Vasily
 * Date: 07.04.11
 * Time: 14:06
 * To change this template use File | Settings | File Templates.
 */
package com.timoff.ui.controls {
import com.timoff.ui.containers.Container;
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.events.ScrollEvent;
import com.timoff.ui.layout.Layout;

import flash.events.Event;
import flash.events.IEventDispatcher;

public class Scroller extends Container {

    public static const SCROLLER_PREV_BTN_PART_ID:String = "prevButton";
    public static const SCROLLER_NEXT_BTN_PART_ID:String = "nextButton";
    public static const SCROLLER_SLIDER_PART_ID:String = "slider";

    private var firstButton:Button;
    private var endButton:Button;
    private var slider:Slider;
    private var _client:IEventDispatcher;
    private var isDragging:Boolean = false;

    public function Scroller(id:String = null, styleName:String = null, type:String = Control.SCROLLER, layout:String = Layout.HORISONTAL, contentRender:Class = null) {
        super(id, styleName, type, contentRender);
        this.layout.layout = layout;
        initLayout();
    }

    override public function invalidateLayout():void {
        initLayout();
        super.invalidateLayout();
    }

    protected function initLayout():void {

        if (layout.layout == Layout.HORISONTAL) {
            firstButton.$initButton(20, "100%", "-", firstClickHandler);
            endButton.$initButton(20, "100%", "+", endClickHandler);
            slider.$setSize(1, "100%");
        }
        else {
            firstButton.$initButton("100%", 20, "-", firstClickHandler);
            endButton.$initButton("100%", 20, "+", endClickHandler);
            slider.$setSize("100%", 1);
        }

        slider.layout.direction = layout.layout;
        slider.initLayout();
    }

    public function get prevButton():Button {
        return firstButton;
    }

    public function get nextButton():Button {
        return endButton;
    }

    public function get sliderButton():Button {
        return slider.sliderButton;
    }

    override protected function initControls():void {
        this.layout.gap = 10;

        firstButton = new Button(id + "_" + SCROLLER_PREV_BTN_PART_ID);

        endButton = new Button(id + "_" + SCROLLER_NEXT_BTN_PART_ID);

        slider = new Slider(id + "_" + SCROLLER_SLIDER_PART_ID);
        slider.layout.isSpacer = true;

        slider.addEventListener(Slider.EVENT_DRAGGING, scrollingHandler, false, 1, true);
        slider.addEventListener(Slider.EVENT_DRAG_END, dragEndHandler, false, 1, true);

        addChilds([firstButton,slider,endButton]);
    }

    private function dragEndHandler(event:Event):void {
        isDragging = false;
    }

    private function scrollingHandler(event:Event):void {

        isDragging = true;

        if (client) {
            var se:ScrollEvent = new ScrollEvent(ScrollEvent.EVENT_SCROLL_TO);
            se.value = slider.value;
            client.dispatchEvent(se);
        }
    }

    private function endClickHandler(event:Event):void {
        if (client)
            client.dispatchEvent(new ScrollEvent(ScrollEvent.EVENT_NEXT));
    }

    private function firstClickHandler(event:Event):void {
        if (client)
            client.dispatchEvent(new ScrollEvent(ScrollEvent.EVENT_PREV));
    }

    public function get client():IEventDispatcher {
        return _client;
    }

    public function set client(value:IEventDispatcher):void {

        if ("max" in value) slider.max = value['max'];
        if ("min" in value) slider.min = value['min'];
        if ("value" in value) slider.value = value['value'];

        FFComponent.log.debug("SliderMM :: " + slider.min + " < " + slider.max);
        _client = value;

        if(!client.hasEventListener(Event.CHANGE))
        {
            client.addEventListener(Event.CHANGE, clientChangeHandler, false, 1, true);
        }
    }

    private function clientChangeHandler(event:Event):void {
        if (client['value'] == slider.value) return;

        if (!isDragging) slider.value = client['value'];
    }

    public function set isAdaptiveSlider(value:Boolean):void {
        slider.isAdaptiveSlider = value;
    }

    public function get isAdaptiveSlider():Boolean {
        if (slider) return slider.isAdaptiveSlider;
        return false;
    }

    public function set percentAtView(value:Number) {
        if (slider) slider.percentAtView = value;
    }

    public function get percentAtView():Number {
        if (slider) return slider.percentAtView;
        return NaN;
    }

}
}
