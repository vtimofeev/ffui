package com.timoff.ui.containers {
import com.timoff.ui.controls.Control;
import com.timoff.ui.layout.Layout;

public class VContainer extends Container {
    public function VContainer(id:String = null, styleName:String = null, type:String = Control.CONTAINER, contentRender:Class = null) {
        super(id, styleName, type, contentRender);
        layout.layout = Layout.HORISONTAL;
    }
}
}