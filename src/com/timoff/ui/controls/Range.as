package com.timoff.ui.controls {
import com.timoff.ui.data.core.InvalidationType;
import com.timoff.ui.layout.Layout;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

public class Range extends ProgressBar {

    public static const INTERNAL_START_BUTTON_PART_ID:String = "startButton";
    public static const INTERNAL_END_BUTTON_PART_ID:String = "endButton";

    public static const EVENT_DRAG_START:String = "dragStart";
    public static const EVENT_DRAG_END:String = "dragEnd";
    public static const EVENT_DRAGGING:String = "dragging";

    protected var startSlideBtn:Button;
    protected var endSlideBtn:Button;
    private var draggedBtn:Button;

    public function Range(id:String = null, styleName:String = null, direction:String = Layout.HORISONTAL, type:String = Control.SLIDER, contentRender:Class = null) {
        super(id, styleName, type, contentRender);
        layout.direction = direction;
        initControls();
        initLayout();
    }


    public function get sliderButton():Button {
        return endSlideBtn;
    }

    protected function initControls():void {
        startSlideBtn = new Button(id + "_" + INTERNAL_START_BUTTON_PART_ID);
        endSlideBtn = new Button(id + "_" + INTERNAL_END_BUTTON_PART_ID);

        //startSlideBtn.addEventListener(MouseEvent.ROLL_OVER, slideBtnMouseOverHandler, false, 0, true);
        //startSlideBtn.addEventListener(MouseEvent.ROLL_OUT, slideBtnMouseOutHandler, false, 0, true);
        startSlideBtn.addEventListener(MouseEvent.MOUSE_DOWN, slideBtnMouseDownHandler, false, 0, true);
        startSlideBtn.addEventListener(MouseEvent.MOUSE_UP, slideBtnMouseUpHandler, false, 0, true);

        //endSlideBtn.addEventListener(MouseEvent.ROLL_OVER, slideBtnMouseOverHandler, false, 0, true);
        //endSlideBtn.addEventListener(MouseEvent.ROLL_OUT, slideBtnMouseOutHandler, false, 0, true);
        endSlideBtn.addEventListener(MouseEvent.MOUSE_DOWN, slideBtnMouseDownHandler, false, 0, true);
        endSlideBtn.addEventListener(MouseEvent.MOUSE_UP, slideBtnMouseUpHandler, false, 0, true);

        super.addChild(startSlideBtn);
        super.addChild(endSlideBtn);
    }

    public function initLayout():void {
        if (layout.direction == Layout.HORISONTAL) {
            endSlideBtn.$setSize(100, "100%");
        }
        else {
            endSlideBtn.$setSize("100%", 100);
        }

    }

    override protected function addEventListeners():void {
        super.addEventListeners();

        _currentStateBackgroundObject.addEventListener(MouseEvent.MOUSE_DOWN, slideBtnMouseDownHandler, false, 1, true);
        _currentStateObject.mouseEnabled = false;
    }


    override protected function draw():void {
        super.draw();

        var psx:Number;
        var px:Number;
        var py:Number;

        if (layout.direction == Layout.HORISONTAL) {
            psx = (contentWidth - endSlideBtn.width) * (relativeStartValue) + layout.paddingLeft - .1;
            px = (contentWidth - endSlideBtn.width) * (relativeValue + relativeStartValue) + layout.paddingLeft - .1;
            py = (contentHeight - endSlideBtn.height) / 2 + layout.paddingTop;
        }
        else {
            psx = (contentWidth - endSlideBtn.width) / 2 + layout.paddingLeft;
            px = (contentWidth - endSlideBtn.width) / 2 + layout.paddingLeft;
            py = (contentHeight - endSlideBtn.height) * (relativeValue + relativeStartValue) + layout.paddingTop - .1;
        }

        startSlideBtn.move(psx, py);
        endSlideBtn.move(px, py);
    }

    override public function invalidate(property:String = InvalidationType.ALL, callLater:Boolean = true, updateParent:Boolean = true, updateChilds:Boolean = true):void {
        if (endSlideBtn) endSlideBtn.invalidate(property, callLater, false, false);
        if (startSlideBtn) startSlideBtn.invalidate(property, callLater, false, false);

        super.invalidate(property, callLater, updateParent, updateChilds);
    }

    /*

     override public function get contentWidth():Number {
     return layout.direction==Layout.HORISONTAL?super.contentWidth - slideBtn.width:super.contentWidth;
     }
     override public function get contentHeight():Number {
     return layout.direction==Layout.VERTICAL?super.contentHeight - slideBtn.height:super.contentHeight;
     }

     */

    /*

     private function slideBtnMouseOverHandler(event:MouseEvent):void {
     if (!enabled) return;
     }


     private function slideBtnMouseOutHandler(event:MouseEvent):void {
     if (!enabled) return;
     }

     */

    private function slideBtnMouseDownHandler(event:MouseEvent):void {
        if (!enabled) return;

        draggedBtn = event.currentTarget == startSlideBtn ? startSlideBtn : endSlideBtn;

        addStageListeners(true);
        slideBtnMouseMoveHandler(event);
        dispatchEvent(new Event(EVENT_DRAG_START));
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
                result = ( mouseY - layout.paddingTop ) * ( max - min ) / (contentHeight - endSlideBtn.height);
                if (reverse) result = (max - min) - result;

                if (draggedBtn == startSlideBtn)
                    startValue = result;
                else
                    value = result;
                break;
            default:
                result = (mouseX - layout.paddingLeft - endSlideBtn.width / 2) * (max - min) / (contentWidth - endSlideBtn.width);
                if (reverse) result = (max - min) - result;

                if (draggedBtn == startSlideBtn)
                    startValue = result;
                else
                    value = result;
                break;
        }

        event.stopImmediatePropagation();
        dispatchEvent(new Event(EVENT_DRAGGING));
    }


    private function addStageListeners(value:Boolean = false):void {
        if (!stage) return;

        if (value) {
            addStageEventListener(MouseEvent.MOUSE_UP, slideBtnMouseUpHandler, null, false, 1, true);
            addStageEventListener(MouseEvent.MOUSE_MOVE, slideBtnMouseMoveHandler, null, false, 1, true);
            addStageEventListener(Event.MOUSE_LEAVE, slideBtnMouseUpHandler, null, false, 1, true);
            draggedBtn.disableMouse = true;
            draggedBtn.drawNow();

        }
        else {
            removeStageEventListener(MouseEvent.MOUSE_UP, slideBtnMouseUpHandler);
            removeStageEventListener(MouseEvent.MOUSE_MOVE, slideBtnMouseMoveHandler);
            removeStageEventListener(Event.MOUSE_LEAVE, slideBtnMouseUpHandler);
            draggedBtn.disableMouse = false;
            draggedBtn.state = State.DEFAULT;
        }
    }

    public function getValueAtPoint(point:Point):Number {
        var result:Number = 0;
        switch (layout.direction) {
            case Layout.VERTICAL:
                result = (point.y - layout.paddingTop) * (max - min) / contentHeight;
                if (reverse) result = (max - min) - result;
                value = result;
                break;
            default:
                result = (point.x - layout.paddingLeft) * (max - min) / contentWidth;
                if (reverse) result = (max - min) - result;
                break;
        }

        return result;
    }


    override public function set value(value:Number):void {

        super.value = value;
    }

    private function backgroundMouseDownHandler(event:MouseEvent):void {
        slideBtnMouseMoveHandler(event);
    }


}
}