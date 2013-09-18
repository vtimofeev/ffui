package com.timoff.ui.containers {
import com.timoff.ui.controls.Control;
import com.timoff.ui.core.FFComponent;

import flash.display.DisplayObject;

public class Container extends FFComponent {

    public function Container(id:String = null, styleName:String = null, type:String = Control.CONTAINER, contentRender:Class = null) {
        super(id, styleName, type, contentRender);
           initControls();
    }

    protected function initControls():void {
    }

    public function addChilds(value:Array):void
    {
        var child:DisplayObject;
        for each(child in value)
        {
            addChild(child);
        }
    }

    public static function $init(object:Container, width:Object, height:Object, layout:String = null, padding:int = 0, contentHAlign:String = null, contentVAlign:String = null):void {
        object.$setSize(width, height);
        object.layout.padding = padding;
        
        if (layout) object.layout.layout = layout;
        if (contentHAlign) object.layout.contentHAlign = contentHAlign;
        if (contentVAlign) object.layout.contentVAlign = contentVAlign;
        return;
    }
}
}