package com.timoff.ui.styles {

import com.timoff.ui.data.styles.rectangle.BaseRectangleStyle;
import com.timoff.ui.layout.LayoutObject;
import com.timoff.utilites.ObjectUtils;

import flash.net.registerClassAlias;

registerClassAlias("com.timoff.ui.styles.StyleObject", StyleObject);
public class StyleObject extends Object {

    public var hasBackground:Boolean = false;
    public var hasTextfield:Boolean = false;
    public var hasIcon:Boolean = false;
    // todo - determinate necessity of variable
    public var hasBackgroundImage:Boolean = false;

    public var backgroundStyles:Vector.<RectangleStyleObject> = new Vector.<RectangleStyleObject>;
    public var backgroundImageStyle:ImageStyleObject;
    public var textfieldStyle:TextfieldStyleObject;
    public var iconStyle:ImageStyleObject;
    public var layout:LayoutObject;

    /*
    Sets style objects
    */
    public function StyleObject(bgStyle:RectangleStyleObject = null, tfStyle:TextfieldStyleObject = null, sourceImage:String = null) {
        if (bgStyle) {    
            hasBackground = true;
            backgroundStyles.push(bgStyle)
        }

        if (tfStyle) {
            hasTextfield = true;
            textfieldStyle = tfStyle;
        }

        if (sourceImage) {
            hasBackgroundImage = true;
            backgroundImageStyle = new ImageStyleObject();
            if (sourceImage.indexOf("lib://") == 0)
                backgroundImageStyle.sourceLibname = sourceImage;
            else
                backgroundImageStyle.sourceUrl = sourceImage;
        }
    }

    public function get hasLayout():Boolean {
        return Boolean(layout);
    }

    public function get defaultBackgroundStyle():RectangleStyleObject {
        const result:RectangleStyleObject = backgroundStyles.length > 0 ? backgroundStyles[0] : null;
        return result;
    }

    public function clone():StyleObject {
        return ObjectUtils.copy(this) as StyleObject;
    }

    //------------------------------------------------------------------------------------
    //
    // Static methods
    //
    //------------------------------------------------------------------------------------

    public static function merge(baseObject:StyleObject, value:StyleObject):StyleObject {
        var result:StyleObject = baseObject.clone();

        if (result.hasTextfield = value.hasTextfield) {
            result.textfieldStyle = ObjectUtils.castedMerge(result.textfieldStyle, value.textfieldStyle, TextfieldStyleObject, TextfieldStyleObject.propertiesMap) as TextfieldStyleObject;
        }
        else {
            result.textfieldStyle = null;
        }

        if (result.hasBackground = value.hasBackground) {
            if (baseObject.backgroundStyles.length > 0 && value.backgroundStyles.length > 0) {
                var resultBgStyle_0:RectangleStyleObject = baseObject.backgroundStyles[0];
                var valueBgStyle_0:RectangleStyleObject = value.backgroundStyles[0];

                result.backgroundStyles = new Vector.<RectangleStyleObject>();
                result.backgroundStyles.push(ObjectUtils.castedMerge(resultBgStyle_0, valueBgStyle_0, RectangleStyleObject, RectangleStyleObject.propertiesMap));
            }
            else
            if (value.backgroundStyles.length > 0) {
                result.backgroundStyles = new Vector.<RectangleStyleObject>();
                result.backgroundStyles.push(value.backgroundStyles[0]);
            }
            else {
                result.hasBackground = false;
                result.backgroundStyles = null;
            }
        }
        else {
            result.backgroundStyles = null;
        }

        result.hasBackgroundImage = value.hasBackgroundImage;
        result.hasIcon = value.hasIcon;
        return result;
    }


    public static function mergeSoWithObject(value:StyleObject, style:Object):StyleObject {
        const result:StyleObject = value;

        result.hasTextfield = ('hasTextfield' in style) ? style.hasTextfield : result.hasTextfield;
        result.hasBackground = ('hasBackground' in style) ? style.hasBackground : result.hasBackground;
        result.hasBackgroundImage = ('hasBackgroundImage' in style) ? style.hasBackgroundImage : result.hasBackgroundImage;
        result.hasIcon = ('hasIcon' in style) ? style.hasIcon : result.hasIcon;

        if (result.hasTextfield && style.textfieldStyle) {
            ObjectUtils.merge(result.textfieldStyle, style.textfieldStyle);
        }
        else {
            result.textfieldStyle = null;
        }

        if (result.hasBackground && style.backgroundStyles) {
            if (!result.backgroundStyles) result.backgroundStyles = new Vector.<RectangleStyleObject>();
            if (!result.backgroundStyles.length) result.backgroundStyles.push(new BaseRectangleStyle());

            if (style.backgroundStyles.length > 0 && value.backgroundStyles.length > 0) {
                var resultBgStyle_0:RectangleStyleObject = result.backgroundStyles[0];
                var valueBgStyle_0:Object = style.backgroundStyles[0];
                result.backgroundStyles = new Vector.<RectangleStyleObject>();
                ObjectUtils.merge(resultBgStyle_0, valueBgStyle_0);
            }
        }
        else {
            result.backgroundStyles = null;
        }

        if (result.hasBackgroundImage && style.backgroundImageStyle)
        {
            result.backgroundImageStyle = result.backgroundImageStyle ? result.backgroundImageStyle : new ImageStyleObject();
            ObjectUtils.merge(result.backgroundImageStyle,style.backgroundImagesStyle) as ImageStyleObject;
        }

        if ('layout' in style)
        {
            result.layout = new LayoutObject();
            ObjectUtils.merge(result.layout, style.layout);
        }

        return result;
    }

}
}