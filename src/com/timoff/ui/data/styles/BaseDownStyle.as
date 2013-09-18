package com.timoff.ui.data.styles {
import flash.net.registerClassAlias;

registerClassAlias("com.timoff.ui.data.styles.BaseDownStyle", BaseDownStyle);
public class BaseDownStyle extends  BaseStyle {
    public function BaseDownStyle() {
        super();
        defaultBackgroundStyle.fillColors = [0x0];
        textfieldStyle.color = 0xFFFFFF;
    }
}
}