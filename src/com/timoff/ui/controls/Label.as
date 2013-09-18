package com.timoff.ui.controls {
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.data.core.InvalidationType;
import com.timoff.ui.layout.Layout;

import flash.text.TextField;

public class Label extends FFComponent {

    private var _label:String = "";
    protected var _textfieldRef:TextField;

    public function Label(id:String = null, styleName:String = null, type:String = Control.LABEL, contentRender:Class = null) {
        super(id, styleName, type, contentRender);
        layout.contentAlign(Layout.HORISONTAL, Layout.LEFT, Layout.MIDDLE);
    }

    public function get label():String {
        return _label;
    }

    public function set label(value:String):void {
        _label = value;
        invalidate(InvalidationType.DATA, false, false);
    }

    public final function $initLabel(width:Object, height:Object, label:String = "", layout:String = null, contentHAlign:String = null, contentVAlign:String = null):void
    {
        Label.$init( this, width, height, label, layout, contentHAlign, contentVAlign );
    }

    public static function $init(object:Label, width:Object, height:Object, label:String = "", layout:String = null, contentHAlign:String = null, contentVAlign:String = null):void
    {
        object.$setSize(width, height);

        if (layout) object.layout.layout = layout;
        if (contentHAlign) object.layout.contentHAlign = contentHAlign;
        if (contentVAlign) object.layout.contentVAlign = contentVAlign;

        object.label = label;
        return;
    }

    // its variable var 
    public function set textfieldReference(value:TextField):void {
        _textfieldRef = value;
    }

    public function get textfieldReference():TextField {
        return _textfieldRef;
    }

}
}