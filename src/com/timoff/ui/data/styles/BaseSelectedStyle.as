package com.timoff.ui.data.styles {
import flash.net.registerClassAlias;

registerClassAlias("com.timoff.ui.data.styles.BaseSelectedStyle", BaseSelectedStyle);
public class BaseSelectedStyle extends BaseStyle{
    public function BaseSelectedStyle() {
        super();
        defaultBackgroundStyle.fillColors = [0xDDDDDD, 0xFFFFFF];
        textfieldStyle.color = 0x333333;
    }
}
}