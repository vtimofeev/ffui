package com.timoff.ui.data.styles {
import flash.net.registerClassAlias;

registerClassAlias("com.timoff.ui.data.styles.BaseSelectedOverStyle", BaseSelectedOverStyle);
public class BaseSelectedOverStyle extends BaseSelectedStyle{
    public function BaseSelectedOverStyle() {
        super();
        defaultBackgroundStyle.fillColors = [0xFFFFFF]
        defaultBackgroundStyle.fillAlphas = [.5];

    }
}
}