package com.timoff.ui.containers {
import com.timoff.ui.controls.Button;
import com.timoff.ui.controls.Control;
import com.timoff.ui.controls.Label;
import com.timoff.ui.data.core.InvalidationType;
import com.timoff.ui.events.DialogEvent;
import com.timoff.ui.layout.Layout;
import com.timoff.ui.managers.PopUpManager;
import com.timoff.ui.types.DialogResult;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

public class Window extends Container {

    protected var titleLabel:Label;
    protected var closeButton:Button;

    protected var yesButton:Button;
    protected var noButton:Button;
    protected var cancelButton:Button;
    protected var okButton:Button;

    protected var topContainer:Container;
    protected var contentContainer:Container;
    // refernece to instance
    protected var contentInstanceReference:Container;

    protected var showFooter:Boolean = false;
    protected var footerContainer:Container;
    protected var result:int = DialogResult.NONE;

    private var lastAligment:Point;
    private var lastResizePoint;
    private var lastPosition = -1;
    private var inResizePhaze:Boolean = false;

    public function Window(id:String = null, styleName:String = null, type:String = Control.PANEL, contentRender:Class = null) {
        super(id, styleName, type, contentRender);
        layout.layout = Layout.VERTICAL;
        //initControls();
    }

    override protected function initControls():void {
        topContainer = new Container(id + "_topContainer");
        Container.$init(topContainer, "100%", 30, Layout.ABSOLUTE, 5, Layout.LEFT, Layout.MIDDLE);

        contentContainer = new Container(id + "_contentContainer");
        contentContainer.layout.isSpacer = true;
        Container.$init(contentContainer, "100%", "100%", Layout.HORISONTAL, 5, Layout.LEFT, Layout.MIDDLE);

        footerContainer = new Container(id + "_footerContainer");
        Container.$init(footerContainer, "100%", 30, Layout.HORISONTAL, 5, Layout.CENTER, Layout.MIDDLE);

        footerContainer.layout.gap = 10;
        contentInstanceReference = contentContainer;

        addChilds([topContainer, contentContainer, footerContainer]);

        initTopContainerControls();
        initFooterContainerControls();
        initDrag();
        initResize();
    }

    private function initResize():void {
        this.addEventListener(MouseEvent.MOUSE_OVER, resizeAreaOverHandler);
        this.addEventListener(MouseEvent.MOUSE_MOVE, resizeAreaOverHandler);
        this.addEventListener(MouseEvent.MOUSE_OUT, resizeAreaOutHandler);
        this.addEventListener(MouseEvent.MOUSE_DOWN, resizeAreaDownHandler);
        this.addStageEventListener(Event.MOUSE_LEAVE, resizeAreaOutHandler);
    }

    private function resizeAreaDownHandler(event:MouseEvent):void {
        var position:int;
        if ((position = checkMouseInResizeArea(mouseX, mouseY)) >= 0) {
            inResizePhaze = true;
            lastPosition = position;
            lastResizePoint = new Point(event.stageX, event.stageY);
            addResizeStageListeners(true);
            layout.isLayable = false;
        }
    }

    private function addResizeStageListeners(value:Boolean):void {
        if (value) {
            addStageEventListener(MouseEvent.MOUSE_MOVE, resizeMouseMoveHandler, null, false, 1, true);
            addStageEventListener(MouseEvent.MOUSE_UP, resizeFinishHandler, null, false, 1, true);
            addStageEventListener(Event.MOUSE_LEAVE, resizeFinishHandler, null, false, 1, true);
        }
        else {
            removeStageEventListener(MouseEvent.MOUSE_MOVE, resizeMouseMoveHandler);
            removeStageEventListener(MouseEvent.MOUSE_MOVE, resizeFinishHandler);
            removeStageEventListener(MouseEvent.MOUSE_MOVE, resizeFinishHandler);
        }
    }

    private function resizeMouseMoveHandler(event:MouseEvent):void {

        if (!lastResizePoint) return;

        var changeX:Number = event.stageX - lastResizePoint.x;
        var changeY:Number = event.stageY - lastResizePoint.y;

        //trace ("PRERESIZE:: " + x, y, width, height);

        switch (lastPosition) {
            case 0:
                x += changeX;
                y += changeY;
                width -= changeX;
                height -= changeY;
                break;
            case 1:
                y += changeY;
                height -= changeY;
                break;
            case 2:
                y += changeY;
                width += changeX;
                height -= changeY;

                break;
            case 3:
                    width += changeX;
                break;
            case 4:
                width += changeX;
                height += changeY;

                break;
            case 5:
                height += changeY;

                break;
            case 6:
                x += changeX;
                width -= changeX;
                height += changeY;
                break;
            case 7:
                x += changeX;
                width -= changeX;
                break;
        }

        //trace ("POST::RESIZE:: " + x, y, width, height);

        lastResizePoint = new Point(event.stageX, event.stageY);

    }

    private function resizeFinishHandler(event:Event):void {
        inResizePhaze = false;
        lastPosition = -1;
        addResizeStageListeners(false);
        Mouse.cursor = MouseCursor.ARROW;
    }

    private function resizeAreaOutHandler(Event):void {
        if (inResizePhaze) return;
        Mouse.cursor = MouseCursor.ARROW;
        lastPosition = -1;
        //trace("/::: Mouse out");
    }


    private function resizeAreaOverHandler(event:Event):void {
        if (inResizePhaze) return;
        var position:int = -1;
        if ((position = checkMouseInResizeArea(mouseX, mouseY)) >= 0) {
            if (lastPosition != position) {
                //trace("Mouse Position " + position);
                Mouse.cursor = MouseCursor.IBEAM;
            }
        }
    }


    private function checkMouseInResizeArea(x:Number, y:Number):int {

        const areaSize:int = 10;

        var inBeginX:Boolean = x < areaSize
        var inEndX:Boolean = x > width - areaSize;
        var inBeginY:Boolean = y < areaSize
        var inEndY:Boolean = y > height - areaSize;

        var outX:Boolean = x < 0 || x > width;
        var outY:Boolean = y < 0 || y > height;

        if (outX || outY) return -1;

        // todo compact expression
        if (inBeginX && inBeginY) return 0;
        if (inBeginX && inEndY) return 6;
        if (inBeginX) return 7;

        if (inEndX && inEndY) return 4;
        if (inEndX && inBeginY) return 2;
        if (inEndX) return 3;

        if (inBeginY) return 1;
        if (inEndY) return 5;

        return -1;
    }


    private function initDrag():void {
        titleLabel.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 1, true);


    }

    private function mouseDownHandler(event:MouseEvent):void {
        addStageListeners(true);
        lastAligment = new Point(event.stageX, event.stageY);
    }

    private function addStageListeners(value:Boolean):void {

        if (value) {
            addStageEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, null, false, 1, true);
            addStageEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, null, false, 1, true);
            addStageEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler, null, false, 1, true);
        }
        else {
            removeStageEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            removeStageEventListener(MouseEvent.MOUSE_MOVE, mouseUpHandler);
            removeStageEventListener(MouseEvent.MOUSE_MOVE, mouseLeaveHandler);
        }
    }

    private function mouseLeaveHandler(event:Event):void {
        addStageListeners(false);
    }

    private function mouseUpHandler(event:MouseEvent):void {
        addStageListeners(false);
    }

    private function mouseMoveHandler(event:MouseEvent):void {

        if (!lastAligment) return;

        var currentAligment:Point = new Point(event.stageX, event.stageY);

        x += currentAligment.x - lastAligment.x;
        y += currentAligment.y - lastAligment.y;

        lastAligment = currentAligment;
    }

    protected function initTopContainerControls():void {
        titleLabel = new Label(id + "_titleLabel");
        Label.$init(titleLabel, "100%", 20, "Title");

        closeButton = new Button(id + "_closeButton");
        closeButton.layout.align(Layout.RIGHT, Layout.MIDDLE);
        Button.$init(closeButton, 20, 20, "x", closeHandler);


        topContainer.addChilds([ titleLabel, closeButton ]);
    }


    protected function initFooterContainerControls():void {

        yesButton = new Button(id + "_yesBtn");
        noButton = new Button(id + "_noBtn");
        //noButton.layout.isSpacer = true;
        okButton = new Button(id + "_okBtn");
        cancelButton = new Button(id + "_canelBtn");

        Button.$init(yesButton, 70, 20, "Yes", closeHandler);
        Button.$init(noButton, 70, 20, "No", closeHandler);
        Button.$init(okButton, 70, 20, "Cancel", closeHandler);
        Button.$init(cancelButton, 70, 20, "Cancel", closeHandler);

        footerContainer.addChilds([yesButton, noButton, okButton, cancelButton]);
    }

    public function set title(value:String):void {
        titleLabel.label = value;
    }

    public function setButtons(enabled:Boolean, yesButtonLabel:String = "Yes", noButtonLabel:String = "No", okButtonLabel:String = "Ok", cancelButtonLabel:String = "Canel"):void {
        footerContainer.visible = enabled;

        this.yesButton.visible = Boolean(yesButtonLabel);
        this.yesButton.label = (yesButtonLabel) ? yesButtonLabel : "Yes";

        this.noButton.visible = Boolean(noButtonLabel);
        this.noButton.label = (noButtonLabel) ? noButtonLabel : "No";

        this.okButton.visible = Boolean(okButtonLabel);
        this.okButton.label = okButtonLabel ? okButtonLabel : "Ok";

        this.cancelButton.visible = Boolean(cancelButtonLabel);
        this.cancelButton.label = cancelButtonLabel ? cancelButtonLabel : "Cancel";

        footerContainer.invalidate(InvalidationType.SIZE, false, false);
    }


    public function addContentChild(child:DisplayObject):DisplayObject {
        return contentInstanceReference.addChild(child);
    }

    public function addContentChilds(value:Array):void {
        contentInstanceReference.addChilds(value);
        return;
    }

    public function removeContentChild(child:DisplayObject):DisplayObject {
        return contentInstanceReference.removeChild(child);
    }

    public function removeContentChilds():void {
        contentInstanceReference.removeChilds();
        return;
    }

    // -----------------------------------------------------------------------------------
    // event handlers
    // -----------------------------------------------------------------------------------

    protected function closeHandler(event:Event):void {

        if (event.target == yesButton)
            result = DialogResult.YES;

        if (event.target == noButton)
            result = DialogResult.NO;

        if (event.target == okButton)
            result = DialogResult.OK;

        if (event.target == cancelButton)
            result = DialogResult.CANCEL;

        dispatchEvent(new DialogEvent(DialogEvent.EVENT_RESULT, result));

        PopUpManager.removePopUp(this);
    }


}
}