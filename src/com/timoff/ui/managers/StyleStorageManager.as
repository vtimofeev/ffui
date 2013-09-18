package com.timoff.ui.managers {
import com.adobe.serialization.json.JSON;
import com.timoff.services.loader.events.LoaderErrorEvent;
import com.timoff.services.loader.events.LoaderEvent;
import com.timoff.services.loader.managers.BasicLoadManager;
import com.timoff.services.loader.managers.LoadSettings;
import com.timoff.ui.controls.Control;
import com.timoff.ui.controls.State;
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.data.styles.BaseDisabledStyle;
import com.timoff.ui.data.styles.BaseDownStyle;
import com.timoff.ui.data.styles.BaseOverStyle;
import com.timoff.ui.data.styles.BaseSelectedDownStyle;
import com.timoff.ui.data.styles.BaseSelectedOverStyle;
import com.timoff.ui.data.styles.BaseSelectedStyle;
import com.timoff.ui.data.styles.BaseStyle;
import com.timoff.ui.data.styles.rectangle.BaseRectangleStyle;
import com.timoff.ui.data.styles.textfield.BaseTextFieldStyle;
import com.timoff.ui.styles.RectangleStyleObject;
import com.timoff.ui.styles.StyleNode;
import com.timoff.ui.styles.StyleObject;
import com.timoff.ui.styles.TextfieldStyleObject;
import com.timoff.utilites.ObjectUtils;

public class StyleStorageManager {

    public static function init(facadeId:String = "default"):void {
        if (!StyleManager.styles[facadeId])
            StyleManager.styles[facadeId] = {};

        var storage:Object = StyleManager.styles[facadeId];
        var defaultStyle:Object;
        var so:Object;

        defaultStyle = storage[StyleManager.STYLE_DEFAULT] = {};
        defaultStyle[State.DEFAULT] = new BaseStyle();


        var containerStyle:Object = storage[Control.CONTAINER] = storage[Control.MULTICONTAINER] = {};
        containerStyle[State.DEFAULT] = new StyleObject();

        var labelStyle:Object = storage[Control.LABEL] = {};
        labelStyle[State.DEFAULT] = new BaseStyle();
        StyleObject(labelStyle[State.DEFAULT]).hasBackground = false;

        labelStyle = storage[Control.INPUT] = {};
        labelStyle[State.DEFAULT] = new BaseStyle();
        StyleObject(labelStyle[State.DEFAULT]).hasBackground = true;


        labelStyle = storage[Control.TEXTAREA] = {};
        labelStyle[State.DEFAULT] = new BaseStyle();
        StyleObject(labelStyle[State.DEFAULT]).hasBackground = true;

        labelStyle = storage[Control.PANEL] = {};
        labelStyle[State.DEFAULT] = new BaseStyle();
        StyleObject(labelStyle[State.DEFAULT]).hasBackground = true;

        so = storage["#galleryItem"] = storage[".galleryItem"] = storage["galleryItemName"] = {};
        so[State.DEFAULT] = new BaseStyle();
        StyleObject(so[State.DEFAULT]).hasBackground = true;
        StyleObject(so[State.DEFAULT]).defaultBackgroundStyle.fillAlphas = [.8]

        so = storage["#tooltip"] = {};
        so[State.DEFAULT] = new BaseStyle();
        StyleObject(so[State.DEFAULT]).defaultBackgroundStyle.fillColors = [0x313131];
        StyleObject(so[State.DEFAULT]).hasBackground = true;

        var buttonStyle:Object = storage[Control.BUTTON] = {};
        buttonStyle[State.DEFAULT] = new BaseStyle();
        buttonStyle[State.OVER] = new BaseOverStyle();
        buttonStyle[State.DOWN] = new BaseDownStyle();
        buttonStyle[State.DISABLED] = new BaseDisabledStyle();
        buttonStyle[State.SELECTED_DEFAULT] = new BaseSelectedStyle();
        buttonStyle[State.SELECTED_OVER] = new BaseSelectedOverStyle();
        buttonStyle[State.SELECTED_DOWN] = new BaseSelectedDownStyle();

        storage[Control.RADIOBUTTON] = storage[Control.TOGGLEBUTTON] = buttonStyle;

        var progressStyle:Object = storage[Control.PROGRESSBAR] = {};
        progressStyle[State.DEFAULT] = new BaseStyle();
        var defaultProgressStyle:StyleObject = progressStyle[State.DEFAULT];
        defaultProgressStyle.backgroundStyles.push(new BaseRectangleStyle());

        storage[Control.SCROLLER] = storage[Control.SLIDER] = progressStyle;

        FFComponent.log.debug("Finish init the style store.")
    }


    ///////////////////////////////////////////////////////////////////
    // Static Methods
    ///////////////////////////////////////////////////////////////////

    public static function getComponentStyle(facadeId:String, value:String, unique:Boolean = true):Object {
        if (!(facadeId in StyleManager.styles))
            StyleManager.styles[facadeId] = {};

        var facadeStyles:Object = StyleManager.styles[facadeId];
        var styleName:String = unique ? "#" + value : "." + value;

        if (styleName in facadeStyles) return facadeStyles[styleName];
        return facadeStyles[styleName] = {};
    }

    public static function getStateStyleObject(so:Object, state:String):StyleObject {
        if (state in so) return so[state] as StyleObject;
        return so[state] = new StyleObject(new BaseRectangleStyle(), new BaseTextFieldStyle());
    }

    public static function setStateStyleObject(so:Object, style:StyleObject, state:String = State.DEFAULT):StyleObject {
        return so[state] = style;
    }

    public static function setImageToggleButtonStyle(facadeId:String, value:String, RectangleStyleClass:Class, TextFieldStyleClass:Class, defaultImage:String, overImage:String = null, downImage:String = null, selectedDefaultImage:String = null, selectedOverImage:String = null, selectedDownImage:String = null, disabledImage:String = null):Object {

        var styles:Object = StyleManager.styles[facadeId];
        var result:Object = styles["#" + value] = {};


        var rectStyle:RectangleStyleObject = RectangleStyleClass ? new RectangleStyleClass() : null;
        var textStyle:TextfieldStyleObject = TextFieldStyleClass ? new TextFieldStyleClass() : null;


        var defaultObject:Object = result[State.DEFAULT] = new StyleObject(rectStyle, textStyle, defaultImage);
        var selectedDefaultObject:Object;

        if (overImage)
            result[State.OVER] = new StyleObject(rectStyle, textStyle, overImage);
        else
            result[State.OVER] = defaultObject;

        if (downImage)
            result[State.DOWN] = new StyleObject(rectStyle, textStyle, downImage);
        else
            result[State.DOWN] = defaultObject;

        if (selectedDefaultImage)
            result[State.SELECTED_DEFAULT] = new StyleObject(rectStyle, textStyle, selectedDefaultImage);
        else
            result[State.SELECTED_DEFAULT] = defaultObject;

        selectedDefaultObject = result[State.SELECTED_DEFAULT];


        if (selectedOverImage)
            result[State.SELECTED_OVER] = new StyleObject(rectStyle, textStyle, selectedOverImage);
        else {
            result[State.SELECTED_OVER] = selectedDefaultObject;
        }

        if (selectedDownImage)
            result[State.SELECTED_DOWN] = new StyleObject(rectStyle, textStyle, selectedDownImage);
        else
            result[State.SELECTED_DOWN] = selectedDefaultObject;

        if (disabledImage)
            result[State.DISABLED] = new StyleObject(rectStyle, textStyle, disabledImage);
        else
            result[State.DISABLED] = defaultObject;

        return result;
    }

    public static function setSimpleImageToggleButtonStyle(facadeId:String, value:String, selected:Boolean, defaultRectangle:RectangleStyleObject, defaultImage:String, overRectangle:RectangleStyleObject = null, overImage:String = null, downRectangle:RectangleStyleObject = null, downImage:String = null, disabledRectangle:RectangleStyleObject = null, disabledImage:String = null):Object {
        var styles:Object = StyleManager.styles[facadeId];
        var result:Object = styles["#" + value] = {};

        var defaultState:String = selected ? State.SELECTED_DEFAULT : State.DEFAULT;
        var overState:String = selected ? State.SELECTED_OVER : State.OVER;
        var downState:String = selected ? State.SELECTED_DOWN : State.DOWN;

        var defaultObject:Object = result[defaultState] = new StyleObject(defaultRectangle, null, defaultImage);

        if (overImage)
            result[overState] = new StyleObject(overRectangle, null, overImage);
        else
            result[overState] = defaultObject;

        if (downImage)
            result[downState] = new StyleObject(downRectangle, null, downImage);
        else
            result[downState] = defaultObject;

        if (disabledImage)
            result[State.DISABLED] = new StyleObject(disabledRectangle, null, disabledImage);
        else
            result[State.DISABLED] = defaultObject;

        return result;
    }

    public static function getStateStyleObjectById(facadeId:String, id:String, state:String = State.DEFAULT):StyleObject {
        var styles:Object = StyleManager.styles[facadeId];
        var name:String = "#" + id;
        var so:Object = name in styles ? styles[name] : styles[name] = {};

        if (state in so)
            return so[state] as StyleObject;
        else
            return so[state] = new BaseStyle();
    }

    public static function getStateStyleObjectByStyleName(facadeId:String, name:String, state:String = State.DEFAULT):StyleObject {
        var styles:Object = StyleManager.styles[facadeId];
        var name:String = "." + name;
        var so:Object = name in styles ? styles[name] : styles[name] = {};

        if (state in so)
            return so[state] as StyleObject;
        else
            return so[state] = new BaseStyle();
    }

    /*
     public static function parseStyle(facadeId:String, stylesObject:Object):void
     {
     if (!stylesObject) return;

     if ("fonts" in stylesObject) ;

     if ("global" in stylesObject)
     {
     parseGlobalStyle(facadeId, stylesObject);
     }


     for each( var property:String in stylesObject )
     {
     if(property == "global")
     {
     //parseGlobalStyle();
     }

     }

     }

     private static function parseGlobalStyle(facadeId:String, stylesObject:Object):void
     {

     }
     */

    //-----------------------------------------------------------------------------------------
    //
    // Load Json Styles
    //
    //-----------------------------------------------------------------------------------------

    private static var jsonFacadeId:String;

    public static function loadJSONStyles(jsonUrl:String, facadeId:String = "default"):void {
        jsonFacadeId = facadeId;
        BasicLoadManager.load(jsonUrl, successLoadJson, faultLoadJson, new LoadSettings({}));
        return;
    }

    private static function successLoadJson(event:LoaderEvent):void {
        const json:String = event.firstResult.content as String;
        const resultJSON:Object = JSON.decode(json, false);
        const storage:Object = StyleManager.styles[jsonFacadeId];

        // parse global styles, sets BaseTextField and BaseRectangle static properties
        parseJsonGlobalStyle(resultJSON['global']);

        for (var jStyleName:Object in resultJSON) {
            if (!jStyleName.indexOf(".") == 0 && !jStyleName.indexOf("#") == 0) parseComponentStyle(jStyleName, resultJSON[jStyleName]);
        }

        for (var jStyleName:Object in resultJSON) {
            if (jStyleName.indexOf(".") == 0 || jStyleName.indexOf("#") == 0) parseComponentStyle(jStyleName, resultJSON[jStyleName]);
        }
    }

    private static function faultLoadJson(event:LoaderErrorEvent):void {
        //trace("Error loading Json on " + event.firstResult.url);
    }

    //-----------------------------------------------------------------------------------------
    //
    // Parse Json Style Notation
    //
    //-----------------------------------------------------------------------------------------

    private static function parseJsonGlobalStyle(jObject:Object):void {
        if (!jObject) return;

        const textfieldProperties:Array = ['fontFamily', 'fontSize', 'bold', 'align', 'italic', 'underline'];
        const rectangleProperties:Array = ['fillColors', 'fillAlphas', 'fillAngle', 'isBorder', 'strokeWidth', 'strokeColors', 'strokeAlphas', 'roundCorners'];

        for each (var property:String in textfieldProperties)
            if (property in jObject) BaseTextFieldStyle[property] = jObject[property];

        for each (var property:String in rectangleProperties)
            if (property in jObject) BaseRectangleStyle[property] = jObject[property];
    }

    private static function parseComponentStyle(jStyleName:Object, jObject:Object):void {
        const storage:Object = StyleManager.styles[jsonFacadeId] ? StyleManager.styles[jsonFacadeId] : StyleManager.styles[jsonFacadeId] = {};
        const storageSoArray:Object = storage[jStyleName];


        if (!storageSoArray) throw new Error('Error::Component style ' + jStyleName + ' not found.')
        setComponentNodeStyles(jsonFacadeId, jObject, storageSoArray);
    }

    private static function setComponentNodeStyles(facadeId:String,  jObject:Object, stylesArray:Object, nodeName:String = null, nodeIndex:int = -1):void {
        const defaultState:Object = stylesArray[State.DEFAULT];
        const nodeFields:Object = { 'bgStyles':'backgroundStyles', 'bgImgStyle':'backgroundImageStyle', 'iconStyle':'iconStyle', 'txtStyle':'textfieldStyle', 'layout':'layout' };

        const states:Object = { 'none':State.DEFAULT, 'over':State.OVER, 'down':State.DOWN };

        const extendsStyleName:String = jObject['extends'];
        const baseComponent:String = jObject['type'];
        const componentSo:Object = getComponentStyle(facadeId, baseComponent);

        const so:Object = extendsStyleName ? {} : ObjectUtils.copy(StyleManager.styles[extendsStyleName]);

        // fill states
        for (var stateName:String in states) {
            var styleStateName:String = states[stateName];

            if (!styleStateName in so) {
                so[styleStateName] = new BaseStyle();
                const cmpStateStyle:StyleObject = componentSo[styleStateName];
                if (cmpStateStyle) mergeStyleObjects(so[styleStateName], cmpStateStyle);
            }
        }

        for (var jNodeFieldName:String in nodeFields) {
            var sNodeStyleName:String = nodeFields[jNodeFieldName];
            mergeStyleProperties(sNodeStyleName, so, jObject[jNodeFieldName]);
        }

        /*
         for (var jPropName:String in jObject) {
         var state:Object = defaultState;
         var realPropName = jPropName;
         const jPropValue:Object = jObject[jPropName];
         if (jPropName.indexOf(".") > 0) {
         const names:Array = jPropName.split(".");
         realPropName = names[0];
         state = stylesArray[names[1]] ? stylesArray[names[1]] : stylesArray[names[1]] = new BaseStyle();
         }

         if (nodeName) {
         state[nodeName] = createComponentNode(nodeName, state, nodeIndex);

         if (nodeIndex >= 0) {
         state[nodeName][nodeIndex] = state[nodeName][nodeIndex] ? state[nodeName][nodeIndex] : new BaseRectangleStyle();
         state[nodeName][nodeIndex][realPropName] = jPropValue;
         }
         else {
         state[nodeName][realPropName] = jPropValue;
         }
         }
         else {
         if (nodeFields.indexOf(realPropName) < 0) state[realPropName] = jPropValue;
         else {
         if (jPropValue is Array) {
         setNodeComponentArrayStyles(jPropValue as Array, stylesArray, jPropName);
         }
         else {
         setComponentNodeStyles(jPropValue, stylesArray, jPropName);
         }
         }
         }

         }
         */
    }

    private static function mergeStyleProperties(nodeStyleName:String, so:Object, jObj:*):void {

        const states:Object = { 'none':State.DEFAULT, 'over':State.OVER, 'down':State.DOWN };

        // fill default states
        for each(var property:String in so) {
            switch (property) {
                case "hasBackground":
                case "hasTextfield":
                case "hasIcon":
                    so[property] = jObj[property];
                    break;
                case StyleNode.BACKGROUND_STYLES:
                    if (!'bgStyle' in jObj) return;
                    var inObject:Object = so.backgroundStyles[0];
                    var fromObject:Object = jObj.bgStyle;
                    ObjectUtils.merge(inObject, fromObject);
                    break;
                case StyleNode.TEXTFIELD_STYLE:
                    if (!'txtStyle' in jObj) return;
                    ObjectUtils.merge(so[property], jObj.txtStyle);
                    break;
                case StyleNode.ICON_STYLE:
                    if (!'iconStyle' in jObj) return;
                    ObjectUtils.merge(so[property], jObj.txtStyle);
                    break;
            }
        }

        // copy to over states
        /*
         for (var stateName:String in states) {
         var styleStateName:String = states[stateName];
         mergeStyleObjects(so[styleStateName], so[State.DEFAULT]);
         }
         */

        for each(var property:String in jObj) {
            switch (property) {
                case "bgStyle":
                    const rootProperty:String = "defaultBackgroundStyle";
                    setPropertiesForStates(rootProperty, states, property, so, jObj);
                    break;
                case "txtStyle":
                    setPropertiesForStates(StyleNode.TEXTFIELD_STYLE, states, property, so, jObj);
                    break;
                case "iconStyle":
                    setPropertiesForStates(StyleNode.ICON_STYLE, states, property, so, jObj);
                    break;
            }
        }


    }

    private static function setPropertiesForStates(rootProperty:String, states:Object, property:String, so:Object, jObj:Object):void {
        for each(var jProp:String in jObj[property]) {
            const pointIndex:int = jProp.indexOf(".");
            if (pointIndex > 0) {
                const jState:String = jProp.substr(pointIndex);
                const sState:String = states[jState];
                const cleanProperty = jProp.substr(0, pointIndex + 1);
                so[sState][rootProperty][property] = jObj[property][cleanProperty];
            }
        }
        return;
    }


    private static function mergeStyleObjects(so:StyleObject, componentSo:StyleObject):void {

        for each(var property:String in so) {
            switch (property) {
                case StyleNode.BACKGROUND_STYLES:
                    var inObject:Object = so.backgroundStyles[0];
                    var fromObject:Object = componentSo.backgroundStyles[0];
                    ObjectUtils.merge(inObject, fromObject);
                    break;
                case StyleNode.TEXTFIELD_STYLE:
                case StyleNode.BACKGROUND_IMAGE_STYLE:
                case StyleNode.LAYOUT:
                    ObjectUtils.merge(so[property], componentSo[property]);
                    break;
            }
        }
    }

    /*
     private static function setNodeComponentArrayStyles(array:Array, stylesArray:Object, jPropName:String):void {
     for (var i:int = 0; i < array.length; i++) {
     setComponentNodeStyles(array[i], stylesArray, jPropName);
     }
     }
     */

    /*
     private static function createComponentNode(nodeName:String, state:Object, nodeIndex:int):* {

     if (state[nodeName]) return state[nodeName];

     switch (nodeName) {
     case StyleNode.BACKGROUND_STYLES:
     return new Vector.<RectangleStyleObject>(1);

     case StyleNode.TEXTFIELD_STYLE:
     return new BaseTextFieldStyle();

     case StyleNode.BACKGROUND_IMAGE_STYLE:
     return new BaseImageStyle();

     case StyleNode.LAYOUT:
     return new LayoutObject();
     }
     return null;
     }
     */

    /*
     public static function parseStyle(jStyleName:Object, jObject:Object):void {
     const partStorage:Object = StyleManager.partStyles[jsonFacadeId] = {};
     const partStyleArray:Object = partStorage[jStyleName] ? partStorage[jStyleName] : partStorage[jStyleName] = {};
     setNodeStyles(jObject, partStyleArray);
     }
     */

    private static function setNodeStyles(jObject:Object, stylesArray:Object, nodeName:String = null, nodeIndex:int = -1):void {
        const defaultState:Object = stylesArray[State.DEFAULT] = {};
        const nodeFields:Array = ['textfieldStyle', 'backgroundStyles', 'backgroundImageStyle', 'iconStyle', 'layout'];

        for (var jPropName:String in jObject) {
            var state:Object = defaultState;
            var realPropName = jPropName;
            const jPropValue:Object = jObject[jPropName];
            if (jPropName.indexOf(".") > 0) {
                const names:Array = jPropName.split(".");
                realPropName = names[0];
                state = stylesArray[names[1]] ? stylesArray[names[1]] : stylesArray[names[1]] = {};
            }

            if (nodeName) {
                state[nodeName] = nodeName in state ? state[nodeName] : (nodeIndex >= 0) ? [] : {};

                if (nodeIndex >= 0) {
                    state[nodeName][nodeIndex] = state[nodeName][nodeIndex] ? state[nodeName][nodeIndex] : {};
                    state[nodeName][nodeIndex][realPropName] = jPropValue;
                }
                else {
                    state[nodeName][realPropName] = jPropValue;
                }
            }
            else {
                if (nodeFields.indexOf(realPropName) < 0) state[realPropName] = jPropValue;
                else {
                    if (jPropValue is Array) {
                        setNodeArrayStyles(jPropValue as Array, stylesArray, jPropName);
                    }
                    else {
                        setNodeStyles(jPropValue, stylesArray, jPropName);
                    }
                }
            }
        }
    }

    private static function setNodeArrayStyles(array:Array, stylesArray:Object, jPropName:String):void {
        for (var i:int = 0; i < array.length; i++) {
            setNodeStyles(array[i], stylesArray, jPropName, i);
        }
    }
}
}