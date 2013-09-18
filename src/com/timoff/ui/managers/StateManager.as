package com.timoff.ui.managers {
import com.timoff.ui.controls.Control;
import com.timoff.ui.controls.Image;
import com.timoff.ui.controls.Input;
import com.timoff.ui.controls.Label;
import com.timoff.ui.controls.ProgressBar;
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.data.controls.ImageStatus;
import com.timoff.ui.draw.DrawManager;
import com.timoff.ui.draw.ImageManager;
import com.timoff.ui.layout.Layout;
import com.timoff.ui.layout.LayoutObject;
import com.timoff.ui.styles.RectangleStyleObject;
import com.timoff.ui.styles.StyleObject;
import com.timoff.utilites.ImageUtils;
import com.timoff.utilites.Library;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.text.AntiAliasType;
import flash.text.GridFitType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.utils.Dictionary;

public class StateManager {

    protected var client:FFComponent
    private var stylesChache:Dictionary = new Dictionary(true);
    private var tfChache:TextField;

    public function StateManager(client:FFComponent) {
        this.client = client;
    }

    public function getHitArea():DisplayObject {
        return DrawManager.drawRectangle(RectangleStyleObject.getSimpleStyle(true, [ 0x0 ], [ 0 ], false, 0, [ 0x0 ], [ 0 ]), client.width, client.height);
    }

    public function getBackgroundState(value:String = null, index:int = 0):DisplayObject {
        const $styleObj:StyleObject = client.style;

        var result:DisplayObjectContainer;
        var rectBg:DisplayObject = null;

        if ($styleObj.hasBackground && $styleObj.backgroundStyles.length > 0) {
            const $style:RectangleStyleObject = $styleObj.backgroundStyles[0] as RectangleStyleObject;
            rectBg = DrawManager.drawRectangle($style, client.width, client.height);

            stylesChache[$style] = rectBg;
        }

        trace("Get background for " + client.id + " , " + $styleObj.hasBackgroundImage + " , " + $styleObj.backgroundImageStyle);
        if ($styleObj.hasBackgroundImage && $styleObj.backgroundImageStyle) {
            var image:DisplayObject = DrawManager.drawImage($styleObj.backgroundImageStyle);
            if (image) {
                image.x = (client.width - image.width) / 2;
                image.y = (client.height - image.height) / 2;
            }

            if (image) {
                result = new Sprite();

                if (rectBg) {
                    result.addChild(rectBg);
                }

                result.addChild(image);
                return result;
            }
        }

        return rectBg;
    }

    public function getContentState(value:String = null):DisplayObject {

        if (client.layout.isVirtual) return null;

        switch (client.type) {
            case Control.INPUT:
            case Control.LABEL:
            case Control.BUTTON:
            case Control.TOGGLEBUTTON:
            case Control.RADIOBUTTON:
                var result:Sprite = getLabelContent(client as Label, tfChache);
                if (result) {
                    tfChache = result.getChildAt(0) as TextField;
                    if (tfChache) {
                        tfChache.addEventListener(Event.CHANGE, dispatchEvent);
                        tfChache.addEventListener(Event.SCROLL, dispatchEvent);
                    }
                }

                return result;


            case Control.TEXTAREA:
                var result:Sprite = getTextContent(client as Label, tfChache);
                if (result) {
                    tfChache = result.getChildAt(0) as TextField;
                    if (tfChache) {
                        tfChache.addEventListener(Event.CHANGE, client.dispatchEvent, false, 2, true);
                        tfChache.addEventListener(Event.SCROLL, client.dispatchEvent, false, 2, true);
                    }
                }

                return result;


            case Control.PROGRESSBAR:
                return getProgressBarContent(client as ProgressBar);

            case Control.IMAGE:
                return getImageContent(client as Image);
            default:
                return null;
        }
    }

    private function dispatchEvent(event:Event):void {

        if (client is Input) Input(client).label = TextField(event.target).text;
        //trace("tf.change " + event.target);
    }

    private function getImageContent(image:Image):DisplayObject {

        const content:String = image.content;

        if (!image.content) return null;
        if (image.content == "manual") {
            image.bitmap.width = image.contentWidth;
            image.bitmap.height = image.contentHeight;
            return image.bitmap;
        }

        if (content.indexOf("lib://") >= 0) {
            var name:String = content.substr(6);
            //trace("try to get .. " + name);
            var result:Object = Library.createInstanceByName(name);
            if (result is BitmapData) {
                return ImageUtils.resizeHq(image.contentWidth, image.contentHeight, result as BitmapData);
            }
            else
            if (result is DisplayObject) {
                result.width = image.width;
                result.height = image.height;
                return result as DisplayObject;
            }
            return null;
        }

        switch (image.status) {
            case ImageStatus.NONE:
                image.load();
                break;

            case ImageStatus.LOADING:
                return null;

            case ImageStatus.LOADED_SUCCESS:
                //trace("ResizeHq prepare " + image.width + " , " + image.height + image.parent.width + " , " + image.parent.height);

                var bitmap:Bitmap;
                if (image.bitmap) {
                    if (image.bitmap.width == image.contentWidth) {
                        return image.bitmap;
                    }
                }

                if ((image.contentWidth == image.loadedBd.width && image.contentHeight == image.loadedBd.height) || image.autoResize == false )
                    bitmap = new Bitmap(image.loadedBd);
                else
                    bitmap = ImageUtils.resize(image.contentWidth, image.contentHeight, image.loadedBd);

                if (image.bitmap) {
                    var freeBitmap:BitmapData = image.bitmap.bitmapData;
                    if (freeBitmap != image.loadedBd) freeBitmap.dispose();
                }

                image.bitmap = bitmap;

                if (image.layout.isEnveloped) {
                    image.width = bitmap.width + image.layout.paddingLeft + image.layout.paddingRight;
                    image.height = bitmap.height + image.layout.paddingTop + image.layout.paddingBottom;
                }

                //trace ("SimpleArrange :: " + image.layout, bitmap.width, image.contentWidth, image.contentHeight)
                var res:Array = LayoutManager.simpleArrange(image.layout, [bitmap], image.contentWidth, image.contentHeight, true);
                bitmap.x = res[0].x;
                bitmap.y = res[0].y;

                return bitmap;

            case ImageStatus.LOADED_FAULT:
                return null;
        }


        return null;
    }

    public static function getLabelContent(component:Label, textFieldCache:TextField):Sprite {
        const styleObj:StyleObject = component.style;
        const layout:LayoutObject = component.layout;

        if (!styleObj.textfieldStyle) return null;

        var result:Sprite = new Sprite();
        var resultArray:Array = [];

        var tf:TextField = textFieldCache ? textFieldCache : DrawManager.drawTextfield(styleObj.textfieldStyle);

        if (styleObj.textfieldStyle.multiline/* styleObj.textfieldStyle.isInput */)
            tf.autoSize = TextFieldAutoSize.NONE;
        else
            tf.autoSize = TextFieldAutoSize.LEFT;



        tf.embedFonts = true;
        tf.antiAliasType = AntiAliasType.ADVANCED;
        tf.gridFitType = GridFitType.PIXEL;


        var label:String;

        if (styleObj.textfieldStyle.isHtml) {
            //tf.embedFonts = false;
            tf.selectable = false;
            tf.htmlText = (("label" in component) ? component["label"] : "");
        }
        else {
            tf.text = label = ("label" in component) ? component["label"] : "";
            tf.setTextFormat(DrawManager.getTextFormat(styleObj.textfieldStyle));
        }


        switch (component.type) {
            case Control.INPUT:
            case Control.TEXTAREA:
                tf.type = Input(component).editable ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
                tf.autoSize = TextFieldAutoSize.NONE;
                tf.selectable = true;
                tf.restrict = Input(component).restrict;
                if (Input(component).maxChars > 0) tf.maxChars = Input(component).maxChars;
                break;
        }

        if (component.layout.isEnveloped) {

            tf.autoSize = TextFieldAutoSize.LEFT;
            var firstWidth:int = component.width;
            var firstHeight:int = component.height;
            var parentLayout:String = (component.parent is FFComponent) ? FFComponent(component.parent).layout.layout : Layout.HORISONTAL;

            if (parentLayout == Layout.HORISONTAL) tf.height = component.contentHeight;
            else tf.width = component.contentWidth;

            if (parentLayout == Layout.HORISONTAL) component.width = int(tf.textWidth + component.layout.paddingLeft + component.layout.paddingRight + 5);
            else component.height = int(tf.textHeight + component.layout.paddingTop + component.layout.paddingBottom + 5);

            //trace("S_ENVELOPED:::: " + component.id + " , " + parentLayout + " sizes " + component.width + " , " + component.height + " , tf " + tf.width + " , " + tf.height);

            if (firstWidth != component.width || firstHeight != component.height)
                component.laterInvalidateFlag = true;

        }
        else {

            if (component.layout.isEnvelopedLabel && tf.textWidth > component.contentWidth) {

                if (tf.textWidth > component.contentWidth && tf.text.length > 12) {
                    var relLength:int = Math.floor(component.contentWidth * (label.length + 3) / tf.textWidth);
                    label = label.substr(0, relLength);
                    updateTextField(tf, label, styleObj);
                }

                while (tf.textWidth > component.contentWidth && tf.text.length > 3) {
                    //trace("while:: " + tf.textWidth + " , " + tf.text.length + " , " + tf.text);
                    label = label.substr(0, label.length - 3);
                    updateTextField(tf, label, styleObj);
                }

                updateTextField(tf, label + "*", styleObj);
            }

            tf.width = component.contentWidth;
            tf.height = component.contentHeight;
        }

        var ic:DisplayObject = ImageManager.getImage(styleObj.iconStyle);

        if (ic) {
            result.addChild(ic);
            resultArray.push(ic);
        }

        result.addChild(tf);
        resultArray.push(tf);

        component.textfieldReference = tf;


        LayoutManager.simpleArrange(layout, resultArray, component.contentWidth, component.contentHeight, true);
        return result;
    }

    private static function updateTextField(tf:TextField, label:String, styleObj:StyleObject):void {
        tf.text = label;
        tf.setTextFormat(DrawManager.getTextFormat(styleObj.textfieldStyle));
    }

    public static function getTextContent(component:Label, textFieldCache:TextField):Sprite {

        const styleObj:StyleObject = component.style;
        const layout:LayoutObject = component.layout;
        var result:Sprite = new Sprite();
        var resultArray:Array = [];


        var tf:TextField = textFieldCache ? textFieldCache : DrawManager.drawTextfield(styleObj.textfieldStyle);
        tf = styleObj.textfieldStyle.isHtml ? DrawManager.drawTextfield(styleObj.textfieldStyle) : tf;
        tf.autoSize = TextFieldAutoSize.LEFT;
        tf.antiAliasType = AntiAliasType.ADVANCED;
        tf.gridFitType = GridFitType.PIXEL;

        if (styleObj.textfieldStyle.isHtml) {
            tf.embedFonts = false;
            tf.selectable = false;
            tf.htmlText = (("label" in component) ? component["label"] : "");
        }
        else {
            tf.text = ("label" in component) ? component["label"] : "";
            tf.setTextFormat(DrawManager.getTextFormat(styleObj.textfieldStyle));

            switch (component.type) {
                case Control.TEXTAREA:
                    tf.type = TextFieldType.INPUT;
                    tf.autoSize = TextFieldAutoSize.NONE;
                    tf.selectable = true;
                    tf.multiline = true;
                    tf.border = false;
                    break;
            }

            tf.multiline = true;
            tf.embedFonts = true;
        }


        tf.width = component.contentWidth;
        tf.height = component.contentHeight;

        result.addChild(tf);
        resultArray.push(tf);

        component.textfieldReference = tf;
        LayoutManager.simpleArrange(layout, resultArray, component.contentWidth, component.contentHeight, true);
        return result;
    }

    public static function getProgressBarContent(component:ProgressBar):DisplayObject {
        const $styleObj:StyleObject = component.style;

        var result:DisplayObjectContainer;
        var startOffset:Number = 0;
        var rectBg:DisplayObject = null;

        FFComponent.log.debug("progressBarValue: " + component.value + " , " + component.relativeValue);

        if ($styleObj.backgroundStyles.length > 0)
        {
            const $style:RectangleStyleObject = ($styleObj.backgroundStyles.length > 1) ? $styleObj.backgroundStyles[1] as RectangleStyleObject : $styleObj.backgroundStyles[0] as RectangleStyleObject;
            switch (component.layout.direction)
            {
                case Layout.VERTICAL:
                    rectBg = DrawManager.drawRectangle($style, component.contentWidth, component.contentHeight * component.relativeValue);

                    if (component.reverse)
                    {
                        rectBg.y = int(component.contentHeight - component.contentHeight * component.relativeValue);
                    }
                   break;


                default:
                    if (!isNaN(component.startValue)) startOffset = component.contentWidth * component.relativeStartValue;
                    rectBg = DrawManager.drawRectangle($style, component.contentWidth * component.relativeValue, component.contentHeight);

                    if (component.reverse)
                    {
                        rectBg.x = int(component.contentWidth - component.contentWidth * component.relativeValue);
                    }
                    else
                    {
                        rectBg.x = startOffset;
                    }

                    break;
            }
        }

        return rectBg;
    }

    public function getStyle(value:String):Object {
        return null;
    }

    public function setStyle(name:String, value:Object):void {
    }

    public function setStyleProperty(name:String, value:Object):void {
    }

    public function free()
    {
        client = null;
    }
}
}