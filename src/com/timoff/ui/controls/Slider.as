package com.timoff.ui.controls {
import com.timoff.ui.data.core.InvalidationType;
import com.timoff.ui.layout.Layout;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

public class Slider extends ProgressBar {

    public static const INTERNAL_SLIDER_BUTTON_PART_ID:String = "sliderButton";

    public static const EVENT_DRAG_START:String = "dragStart";
    public static const EVENT_DRAG_END:String = "dragEnd";
    public static const EVENT_DRAGGING:String = "dragging";
    protected var slideBtn:Button;

    private var _isAdaptiveSlider:Boolean = false;
    private var _percentAtView:Number;
    public var minimumSize:int = 5;
    public var defaultSize:int = 50;
    public var isDragging:Boolean = false;

    public function Slider(id:String = null, styleName:String = null, direction:String = Layout.HORISONTAL, type:String = Control.SLIDER, contentRender:Class = null) {
        super(id, styleName, type, contentRender);
        layout.direction = direction;
        initControls();
        setSliderSize();
    }

    public function get sliderButton():Button {
        return slideBtn;
    }

    protected function initControls():void {
        slideBtn = new Button(id + "_" + INTERNAL_SLIDER_BUTTON_PART_ID);
        slideBtn.addEventListener(MouseEvent.ROLL_OVER, slideBtnMouseOverHandler, false, 0, true);
        slideBtn.addEventListener(MouseEvent.ROLL_OUT, slideBtnMouseOutHandler, false, 0, true);
        slideBtn.addEventListener(MouseEvent.MOUSE_DOWN, slideBtnMouseDownHandler, false, 0, true);
        slideBtn.addEventListener(MouseEvent.MOUSE_UP, slideBtnMouseUpHandler, false, 0, true);
        super.addChild(slideBtn);
    }

    public function initLayout():void {
        setSliderSize();
    }

    private function setSliderSize():void {
        if (isAdaptiveSlider) {
            if (!isNaN(percentAtView)) {
                if (layout.direction == Layout.HORISONTAL)
                {
                    slideBtn.width = int(percentAtView * contentWidth);
                    slideBtn.width = slideBtn.width < minimumSize ? minimumSize : slideBtn.width;
                }
                else
                {
                    slideBtn.height = int(percentAtView * contentHeight);
                    slideBtn.height = slideBtn.height < minimumSize ? minimumSize : slideBtn.height;
                }
            }
        }
        else
        {
            if (layout.direction == Layout.HORISONTAL) {
                slideBtn.$setSize(defaultSize, "100%");
            }
            else {
                slideBtn.$setSize("100%", defaultSize);
            }
        }
    }

    override protected function addEventListeners():void {
        super.addEventListeners();
        _currentStateBackgroundObject.addEventListener(MouseEvent.MOUSE_DOWN, slideBtnMouseDownHandler, false, 1, true);
        _currentStateObject.mouseEnabled = false;
    }

    override protected function draw():void {
        setSliderSize();
        super.draw();

        var px:Number;
        var py:Number;
        var size:Number;

        if (layout.direction == Layout.HORISONTAL) {
            size = contentWidth - slideBtn.width;

            if(reverse)
                px = size - ( size * (relativeValue + relativeStartValue) ) + layout.paddingLeft - .1;
            else
                px = (contentWidth - slideBtn.width) * (relativeValue + relativeStartValue) + layout.paddingLeft - .1;
            
            py = (contentHeight - slideBtn.height) / 2 + layout.paddingTop;
        }
        else {
           size = contentHeight - slideBtn.height;

           px = (contentWidth - slideBtn.width) / 2 + layout.paddingLeft;
            if (reverse)
                py = size - size * (relativeValue + relativeStartValue) + layout.paddingTop - .1;
            else
                py = size * (relativeValue + relativeStartValue) + layout.paddingTop - .1;
        }

        slideBtn.move(px, py);
    }

    private function slideBtnMouseOverHandler(event:MouseEvent):void {
        if (!enabled) return;
    }

    /*
     override public function get contentWidth():Number {
     return layout.direction==Layout.HORISONTAL?super.contentWidth - slideBtn.width:super.contentWidth;
     }
     override public function get contentHeight():Number {
     return layout.direction==Layout.VERTICAL?super.contentHeight - slideBtn.height:super.contentHeight;
     }
     */

    private function slideBtnMouseOutHandler(event:MouseEvent):void {
        if (!enabled) return;
    }

    private function slideBtnMouseDownHandler(event:MouseEvent):void {
        if (!enabled) return;
        addStageListeners(true);
        slideBtnMouseMoveHandler(event);
        dispatchEvent(new Event(EVENT_DRAG_START));
    }

    private function addStageListeners(value:Boolean = false):void {
        if (!stage) return;

        if (value) {
            isDragging = true;
            addStageEventListener(MouseEvent.MOUSE_UP, slideBtnMouseUpHandler, null, false, 1, true);
            addStageEventListener(MouseEvent.MOUSE_MOVE, slideBtnMouseMoveHandler, null, false, 1, true);
            addStageEventListener(Event.MOUSE_LEAVE, slideBtnMouseUpHandler, null, false, 1, true);
            slideBtn.disableMouse = true;
            slideBtn.drawNow();

        }
        else {
            isDragging = false;
            removeStageEventListener(MouseEvent.MOUSE_UP, slideBtnMouseUpHandler);
            removeStageEventListener(MouseEvent.MOUSE_MOVE, slideBtnMouseMoveHandler);
            removeStageEventListener(Event.MOUSE_LEAVE, slideBtnMouseUpHandler);
            slideBtn.disableMouse = false;
            slideBtn.state = State.DEFAULT;
        }
    }

    private function slideBtnMouseUpHandler(event:MouseEvent):void {
        if (!enabled) return;
        addStageListeners(false);
        dispatchEvent(new Event(EVENT_DRAG_END));
    }

    private function slideBtnMouseMoveHandler(event:MouseEvent):void {
        var mouseX:Number = event.stageX;
        var mouseY:Number = event.stageY;

        var localPt:Point = globalToLocal(new Point(mouseX, mouseY));
        mouseX = localPt.x;
        mouseY = localPt.y;

        var result:Number;

        switch (layout.direction) {
            case Layout.VERTICAL:
                result = ( mouseY - layout.paddingTop - slideBtn.height / 2) * ( max - min ) / (contentHeight - slideBtn.height);
                if (reverse) result = (max - min) - result;
                value = result;
                break;
            default:
                result = (mouseX - layout.paddingLeft - slideBtn.width / 2) * (max - min) / (contentWidth - slideBtn.width);
                if (reverse) result = (max - min) - result;
                value = result;
                break;
        }

        event.stopImmediatePropagation();
        dispatchEvent(new Event(EVENT_DRAGGING));
    }

    public function getValueAtPoint(point:Point):Number {

        var result:Number = 0;
        switch (layout.direction) {
            case Layout.VERTICAL:
                result = ( mouseY - layout.paddingTop - slideBtn.height / 2) * ( max - min ) / (contentHeight - slideBtn.height);
                if (reverse) result = (max - min) - result;
                //value = result;
                break;
            default:
                trace("VALUE ::: " , mouseX , contentWidth , slideBtn.width);
                result = (mouseX - layout.paddingLeft - slideBtn.width / 2) * (max - min) / (contentWidth - slideBtn.width);
                if (reverse) result = (max - min) - result;
                break;
        }

        return result;
    }

    override public function set value(value:Number):void {
        //trace("Set value " + value + ", " + reverse);
        super.value = value;
    }

    private function backgroundMouseDownHandler(event:MouseEvent):void {
        slideBtnMouseMoveHandler(event);
    }

    public function get isAdaptiveSlider():Boolean {
        return _isAdaptiveSlider;
    }

    public function set isAdaptiveSlider(value:Boolean):void {
        _isAdaptiveSlider = value;
        setSliderSize();
    }

    public function get percentAtView():Number {
        return _percentAtView;
    }

    public function set percentAtView(value:Number):void {
        _percentAtView = value/100;
        setSliderSize();
    }
}
}