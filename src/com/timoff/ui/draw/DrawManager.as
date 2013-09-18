package com.timoff.ui.draw {
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.styles.ImageStyleObject;
import com.timoff.ui.styles.RectangleStyleObject;
import com.timoff.ui.styles.TextfieldStyleObject;
import com.timoff.utilites.Library;

import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.utils.Dictionary;

public class DrawManager {


    public static function getTextFormat(style:TextfieldStyleObject):TextFormat {
        if (style == null) return null;

        //style.color = 0xFFFFFF;
        //style.bold = true;
        //style.italic = false;
        //style.multiline = true;

        return new TextFormat(style.fontFamily, style.fontSize, style.color, style.bold, style.italic, style.underline , null, null, (style.align).toLowerCase(), style.leftMargin, style.rightMargin);
    }

    public static function getHtmlTextFormat(style:TextfieldStyleObject):TextFormat {
        return new TextFormat(style.fontFamily, style.fontSize);
    }

    public static function drawTextfield(style:TextfieldStyleObject):TextField {

        if (style == null) return null;

        FFComponent.ffcomponentDrawTextfieldCount++;

        var result:TextField = null;

        result = new TextField();
        result.type = TextFieldType.DYNAMIC;
        result.selectable = false;
        result.autoSize = TextFieldAutoSize.LEFT;
        result.wordWrap = false;
        result.width = 100;
        result.antiAliasType = AntiAliasType.ADVANCED;


        if (style.multiline == true) {
            result.wordWrap = true;
        }

        result.multiline = style.multiline;
        return result;
    }

    public static function drawRectangle(style:RectangleStyleObject, width:Number, height:Number):Shape {

        if (!style) return null;

        FFComponent.ffcomponentDrawRectanglesCount++;

        var result:Shape = new Shape();

        var ratios:Array = [];
        var ratioInc:int = 0;
        var i:* = 0;
        var mtx:Matrix;


        //	draw fill
        if (style.isFill) {
            if (style.fillColors.length > 1 || style.fillAlphas.length > 1) {
                while (style.fillAlphas.length != style.fillColors.length) {
                    if (style.fillAlphas.length < style.fillColors.length)
                        style.fillAlphas.push(style.fillAlphas.length - 1);
                    else
                        style.fillColors.push(style.fillColors [ style.fillColors.length - 1 ]);
                }

                ratios = [];
                ratioInc = int(255 / (  style.fillColors.length  ));

                for (i in style.fillColors)
                    ratios.push(ratioInc * i + ratioInc);

                ratios[ 0 ] = 0;
                ratios[ style.fillColors.length - 1 ] = 255;


                mtx = new Matrix();
                mtx.createGradientBox(width, height, style.fillAngle, 0, 0);

                result.graphics.beginGradientFill(GradientType.LINEAR, style.fillColors, style.fillAlphas, ratios, mtx);
            }
            else
                result.graphics.beginFill(style.fillColors[0], style.fillAlphas[0]);
        }

        // draw border

            if (style.lineColors.length > 1) {
                while (style.lineAlphas.length != style.lineColors.length) {
                    if (style.lineAlphas.length < style.lineColors.length)
                        style.lineAlphas.push(style.lineAlphas [style.lineAlphas.length - 1]);
                    else
                        style.lineColors.push(style.lineColors [ style.lineColors.length - 1 ]);
                }

                ratios = [];
                ratioInc = int(255 / (  style.lineColors.length  ));
                for (i in style.lineColors)
                    ratios.push(int(ratioInc * i + ratioInc));

                ratios[ 0 ] = 0;
                ratios[ style.lineAlphas.length - 1 ] = 255;

                mtx = new Matrix();
                mtx.createGradientBox(width, height, Math.PI / 2, 0, 0);

                if (!style.lineSides) {
                    result.graphics.lineStyle(style.lineWidth);
                    result.graphics.lineGradientStyle("linear", style.lineColors, style.lineAlphas, ratios, mtx);
                }
            }
            else {
                if (!style.lineSides) {
                    result.graphics.lineStyle(style.lineWidth, style.lineColors[0], style.lineAlphas[0]);
                }
            }

        if (style.isFill || style.isBorder) {

            if (style.roundCorners > 0 || style.radiusLeftTop > 0 || style.radiusRightTop > 0 || style.radiusRightBottom > 0 || style.radiusLeftBottom)
            {
                result.graphics.drawRoundRectComplex(0, 0, width - style.lineWidth, height - style.lineWidth,style.radiusLeftTop, style.radiusRightTop, style.radiusLeftBottom, style.radiusRightBottom);
                /*
                if ( style.radiusLeftTop == style.roundCorners &&  style.radiusRightTop == style.roundCorners && style.radiusRightBottom == style.roundCorners  && style.radiusLeftBottom == style.roundCorners)
                {
                    result.graphics.drawRoundRect(0, 0, width - style.lineWidth, height - style.lineWidth, style.roundCorners, style.roundCorners);
                }
                else
                {

                }
                */
            }
            else
                result.graphics.drawRect(0, 0, width - style.lineWidth, height - style.lineWidth);

            result.graphics.endFill();
        }


        if (style.lineSides) {

            if (style.fillColors.length > 1) {
                result.graphics.lineStyle(style.lineWidth);
                result.graphics.lineGradientStyle("linear", style.lineColors, style.lineAlphas, ratios, mtx);
            }
            else {
                result.graphics.lineStyle(style.lineWidth, style.lineColors[0], style.lineAlphas[0]);
            }

            // sides are top, right, bottom or left
            if (style.lineSides.indexOf("top") >= 0) {
                result.graphics.moveTo(0, 0);
                result.graphics.lineTo(width, 0);
            }

            if (style.lineSides.indexOf("right") >= 0) {
                result.graphics.moveTo(width, 0);
                result.graphics.lineTo(width, height);
            }

            if (style.lineSides.indexOf("bottom") >= 0) {
                result.graphics.moveTo(width, height);
                result.graphics.lineTo(0, height);
            }

            if (style.lineSides.indexOf("left") >= 0) {
                result.graphics.moveTo(0, height);
                result.graphics.lineTo(0, 0);
            }
        }

        return result;
    }

    public static function drawImage(imageStyle:ImageStyleObject):DisplayObject {

        FFComponent.ffcomponentDrawImageCount++;

        trace("Draw image " + imageStyle.sourceLibname + " , " + imageStyle.sourceUrl );
        if (imageStyle.sourceUrl || imageStyle.sourceUrl) {
            var dobj:DisplayObject = Library.createDisplayObjectByName(imageStyle.sourceLibname?imageStyle.sourceLibname:imageStyle.sourceUrl);
            return dobj;
        }
        return null;
    }

}
}