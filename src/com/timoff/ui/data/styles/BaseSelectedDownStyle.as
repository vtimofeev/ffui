package com.timoff.ui.data.styles {
import flash.net.registerClassAlias;

registerClassAlias("com.timoff.ui.data.styles.BaseSelectedDownStyle", BaseSelectedDownStyle);
public class BaseSelectedDownStyle extends  BaseSelectedStyle {
    public function BaseSelectedDownStyle() {
        super();
        defaultBackgroundStyle.fillColors = [0x000000, 0x999999];
        textfieldStyle.color = 0xFFFFFF;
    }
}
}