package com.timoff.ui.data.styles {
import flash.net.registerClassAlias;

registerClassAlias("com.timoff.ui.data.styles.BaseDisabledStyle", BaseDisabledStyle);
public class BaseDisabledStyle extends  BaseStyle {
    public function BaseDisabledStyle() {
        super();
        defaultBackgroundStyle.fillColors = [0xCCCCCC];
        textfieldStyle.color = 0x999999;
    }
}
}