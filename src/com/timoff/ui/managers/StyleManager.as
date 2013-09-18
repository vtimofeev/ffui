package com.timoff.ui.managers {
import com.timoff.ui.controls.State;
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.data.styles.rectangle.BaseRectangleStyle;
import com.timoff.ui.data.styles.textfield.BaseTextFieldStyle;
import com.timoff.ui.styles.RectangleStyleObject;
import com.timoff.ui.styles.StyleObject;
import com.timoff.ui.styles.TextfieldStyleObject;
import com.timoff.utilites.ObjectUtils;


public class StyleManager {

    public static const STYLE_DEFAULT:String = "default";

    public static const styles:Object = {};
    public static const partStyles:Object = {};
    public static var notparsedStyles:Object = {};
    public static var applicationDefaultStyleObject:StyleObject;

    private var _styles:Object;
    protected var client:FFComponent;
    protected var facadeId:String;

    private var stylesChanges:Array = [];

    public function StyleManager(client:FFComponent, facadeId:String = "default") {
        this.client = client;
        this.facadeId = facadeId;
        initStyles();
        getStyle();
    }

    public function getStyle(state:String = null, facadeId:String = "default"):StyleObject {

        if (!state) state = client.state;
        //trace("StyleManager:: Get style for " + client.state + " state");
        
        var result:StyleObject = _styles[state];

        return result?result:_styles[State.DEFAULT];
    }

    public function setStyle(state:String, style:StyleObject):void {
        _styles[state] == style;
    }


    public function setStylePropertyToAllStates(style:String, property:String, value:Object, refresh:Boolean = false):void
    {
        if (!refresh) stylesChanges.push ({style: style, property:property, value: value});

        var currentStyle:Object;
        for each(var so:StyleObject in _styles)
        {
            currentStyle = null;
            if (style in so) currentStyle = so[style];
            if (property in currentStyle) currentStyle[property] = value;
        }

        return;
    }

    public function setStyleProperty( property:String, value:Object, state:String = null):void
    {
        for each(var so:StyleObject in _styles)
        {
            if(!so) continue;
            if(property in so) so[property] = value;
            if(so.textfieldStyle) if(property in so.textfieldStyle) so.textfieldStyle[property] = value;
            if(so.defaultBackgroundStyle) if(property in so.defaultBackgroundStyle) so.defaultBackgroundStyle[property] = value;
        }

        return;
    }

    protected function applyStyleChanges():void
    {
        var props:Object;
        for each(props in stylesChanges)
        {
            setStylePropertyToAllStates(props.style, props.property, props.value, true);
        }
    }

    public function initStyles():void {
        const $facadeId:String = facadeId = client.facadeId;
        const $control:String = client.type;
        const $styleName:String = "." + client.styleName;
        const $id:String = "#" + client.id;

        FFComponent.log.debug("Init style::" + $facadeId + ", id " + $id + ", sn " + $styleName + ", ctr " + $control);
        //trace("Init style::" + $facadeId + ", id " + $id + ", sn " + $styleName + ", ctr " + $control);

        if (!($facadeId in styles))
            styles[$facadeId] = {};

        const $facadeStyles:Object = styles[$facadeId];

        var controlsSo:Object = ($control in $facadeStyles) ? $facadeStyles[$control] : null;
        var styleNameSo:Object = ($styleName in $facadeStyles) ? $facadeStyles[$styleName] : null;
        var idSo:Object = ($id in $facadeStyles) ? $facadeStyles[$id] : null;

        var result:Object = _styles = {};
        var state:String;

        for each(state in client.states) {
            result[state] = {}

            if (idSo) {
                if (idSo[state])
                    result[state] = idSo[state];
                else
                    result[state] = idSo[State.DEFAULT];

                continue;
            }

            if (styleNameSo) {
                if (styleNameSo[state])
                    result[state] = ObjectUtils.copy(styleNameSo[state]);
                else
                    result[state] = ObjectUtils.copy(styleNameSo[State.DEFAULT]);
                continue;
            }

            if (controlsSo) {
                if (controlsSo[state])
                    result[state] = ObjectUtils.copy(controlsSo[state]);
                else
                    result[state] = ObjectUtils.copy(controlsSo[State.DEFAULT]);
                continue;
            }

            result[state] = new StyleObject();
            mergeJsonStyle(result[state], $id, $styleName, state);
        }

        FFComponent.log.debug("Finish init styles " + $id + " , " + $control);
    }

    private function mergeJsonStyle(value:StyleObject, id:String, styleName:String, state:String):void {
        const partStyles:Object = partStyles[facadeId];

        if(!partStyles) return;

        const jsonStylesArray:Array = partStyles[styleName];
        const jsonIdStylesArray:Array = partStyles[styleName];

        if(state in jsonStylesArray) StyleObject.mergeSoWithObject(value, jsonStylesArray[state]);
        if(state in jsonIdStylesArray) StyleObject.mergeSoWithObject(value, jsonIdStylesArray[state]);
   }


    public static function loadStylesByObject(value:Object, facadeId:String = "default"):Boolean {

        if (!value) return false;

        if (!(facadeId in styles))
            styles[facadeId] = {};

        if (!facadeId in notparsedStyles)
            notparsedStyles[facadeId] = {};

        var storage:Object = notparsedStyles[facadeId];
        var styleObject:Object = value;

        for (var i:Object in styleObject) {
            var styleName:String = i as String;
            for (var j:Object in styleObject[i]) {
                var stateName:String = ( j as String).toUpperCase();
                if (!storage[styleName][stateName])
                    storage[styleName][stateName] = {};

                for (var c:Object in styleObject[i][j]) {
                    var propertyName:String = c as String;
                    storage[styleName][stateName][propertyName] = styleObject[i][j][c];
                }
            }
        }

        return true;
    }

    public function update():void {
        initStyles();
        applyStyleChanges();
    }


}
}