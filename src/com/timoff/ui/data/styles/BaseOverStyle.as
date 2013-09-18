package com.timoff.ui.data.styles {
import flash.net.registerClassAlias;

registerClassAlias("com.timoff.ui.data.styles.BaseOverStyle", BaseOverStyle);
public class BaseOverStyle extends  BaseStyle {
    public function BaseOverStyle() {
        super();
        defaultBackgroundStyle.fillColors = [0xFFFFFF]
        defaultBackgroundStyle.fillAlphas = [.9,.5];

        textfieldStyle.color = 0xCCCCCC;

    }
}
}