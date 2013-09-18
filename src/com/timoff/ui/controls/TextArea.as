package com.timoff.ui.controls {
import com.timoff.ui.containers.Container;
import com.timoff.ui.data.controls.TextAreaSettings;
import com.timoff.ui.data.core.InvalidationType;
import com.timoff.ui.events.ScrollEvent;
import com.timoff.ui.layout.Layout;

import flash.events.Event;
import flash.text.TextField;

public class TextArea extends Container {
    private var _text:String = "";

    protected var textLabel:Label;
    protected var vScroller:Scroller;
    protected var hScroller:Scroller;

    private var settings:TextAreaSettings = new TextAreaSettings();

    private var currentH:Number = 0;
    private var maxH:Number = 0;

    private var currentV:Number = 0;
    private var maxV:Number = 0;

    private var requiredVScroller:Boolean = false;
    private var requiredHScroller:Boolean = false;

    public function TextArea(id:String = null, styleName:String = null, type:String = Control.CONTAINER, contentRender:Class = null) {
        super(id, styleName, type, contentRender);
        layout.layout = Layout.HORISONTAL;

        this.addEventListener(ScrollEvent.EVENT_SCROLL_TO, vScrollHandler, false, 1, true)
    }

    override protected function initControls():void {
        textLabel = new Label("textArea_label", null, Control.TEXTAREA);
        textLabel.$initLabel("100%", "100%");
        textLabel.layout.contentAlign(Layout.HORISONTAL, Layout.LEFT, Layout.TOP);
        textLabel.layout.padding = 3;
        textLabel.cacheAsBitmap = false;
        textLabel.addEventListener(Event.CHANGE, textFieldChangeHandler, false, 2, true);
        textLabel.addEventListener(Event.SCROLL, textFieldChangeHandler, false, 2, true);

        this.addChild(textLabel);
    }

    private function textFieldChangeHandler(event:Event):void {
        invalidate(InvalidationType.SCROLL, false, false);
    }

    public function get text():String {
        return textLabel.label;
    }

    public function set text(value:String):void {
        textLabel.label = value;
        invalidate(InvalidationType.DATA, false, false);
    }

    public static function $initTextArea(object:TextArea, width:Object, height:Object, text:String = "", layout:String = null, contentHAlign:String = null, contentVAlign:String = null):void {
        object.$setSize(width, height);

        if (layout) object.layout.layout = layout;
        if (contentHAlign) object.layout.contentHAlign = contentHAlign;
        if (contentVAlign) object.layout.contentVAlign = contentVAlign;

        object.text = text;
        return;
    }

    override protected function draw():void {
        super.draw();
        textLabel.drawNow();
        scrollers();
    }

    private function scrollers():void {
        checkScrollers();
        drawScrollers();
        setVScroll();
    }


    public function get max():Number {
        return maxV;
    }

    public function get value():Number {
        return currentV;
    }

    public function get min():Number {
        return 0;
    }

    protected function checkScrollers():void {
        var tf:TextField = textLabel.textfieldReference;
        if (!tf) return;
        maxV = tf.maxScrollV;
        currentV = tf.scrollV;

        if (vScroller) dispatchEvent(new Event(Event.CHANGE));
        requiredVScroller = maxV > 0;
    }

    private function drawScrollers():void {
        if (requiredVScroller) {
            if (!vScroller) {

                vScroller = new Scroller("textArea_vScroller", null, null, Layout.VERTICAL);
                vScroller.$setSize(settings.vScrollerWidth, "100%")
                vScroller.isFreeable = false;

                textLabel.layout.marginRight = settings.vScrollerWidth;
                textLabel.invalidateSize();

                this.addChild(vScroller);
            }

            if (!this.contains(vScroller))
            {
                this.addChild(vScroller);
            }

            vScroller.client = this;
        }
        else {
            if (vScroller)
                if (this.contains(vScroller)) {
                    textLabel.layout.marginRight = 0;
                    textLabel.invalidateSize();

                    this.removeChild(vScroller);
                }
        }
    }

    private function vScrollHandler(event:ScrollEvent):void {
        currentV = event.value;
        setVScroll();
    }

    private function vPrevHandler(event:ScrollEvent):void {
        currentV = currentV - 1 >= 0 ? currentV - 1 : 0;
        setVScroll();
    }

    private function vNextHandler(event:ScrollEvent):void {
        currentV = currentV + 1 <= maxV ? currentV + 1 : maxV;
        setVScroll();
    }


    private function setVScroll():void {
        var tf:TextField = textLabel.textfieldReference;
        if (tf) tf.scrollV = currentV;
    }


}
}