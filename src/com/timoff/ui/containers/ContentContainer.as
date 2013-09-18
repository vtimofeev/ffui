package com.timoff.ui.containers {
import com.timoff.ui.controls.Control;
import com.timoff.ui.layout.Layout;

import flash.display.DisplayObject;

public class ContentContainer extends Container {

    protected var contentContainer:Container;
    protected var contentInstanceReference:Container;

    public function ContentContainer(id:String = null, styleName:String = null, type:String = Control.CONTAINER, contentRender:Class = null) {

        super(id, styleName, type, contentRender);
        layout.layout = Layout.ABSOLUTE;

    }

    override protected function initControls():void
    {
        initContentContainer();
        contentContainer.layout.isSpacer = true;
        Container.$init(contentContainer, 1, "100%", Layout.HORISONTAL, 0, Layout.LEFT, Layout.MIDDLE);
        contentInstanceReference = contentContainer;
    }

    protected function initContentContainer():void {
        contentContainer = new Container(id + "_contentContainer");
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



}
}