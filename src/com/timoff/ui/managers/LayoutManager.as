package com.timoff.ui.managers {
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.layout.AbsoluteLayoutManager;
import com.timoff.ui.layout.FlowLayoutManager;
import com.timoff.ui.layout.Horisontal3D_V2_LayoutManager;
import com.timoff.ui.layout.HorisontalLayoutManager;
import com.timoff.ui.layout.Layout;
import com.timoff.ui.layout.LayoutObject;
import com.timoff.ui.layout.LineZ3DLayoutManager;
import com.timoff.ui.layout.VerticalLayoutManager;

import flash.display.DisplayObject;
import flash.geom.Rectangle;

public class LayoutManager {
    public static function arrange(container:FFComponent, childs:Array, apply:Boolean = false):Array {
        if (!container || !childs)
            return null;

        if (childs.length == 0)
            return null;

        switch (container.layout.layout) {
            case Layout.HORISONTAL:
                return HorisontalLayoutManager.arrange(container, childs, apply);

            case Layout.HORISONTAL_3D:
                return Horisontal3D_V2_LayoutManager.arrange(container, childs, apply);

            case Layout.HORISONTAL_3D_V2:
                return Horisontal3D_V2_LayoutManager.arrange(container, childs, apply);


            case Layout.LINE_Z_3D:
               return LineZ3DLayoutManager.arrange(container, childs, apply);

            case Layout.VERTICAL:
                return VerticalLayoutManager.arrange(container, childs, apply);
            case Layout.FLOW:
                return FlowLayoutManager.arrange(container, childs, apply);
            default:
                return AbsoluteLayoutManager.arrange(container, childs, apply);
        }
    }

    public static function simpleArrange(layout:LayoutObject, childs:Array, width:Number, height:Number, apply:Boolean = false):Array {

        const $cWidth:Number = width;
        const $cHeight:Number = height;
        const $cLayout:LayoutObject = layout;

        var result:Array = [];

        var child:DisplayObject;
        var childRectangle:Rectangle;
        var resultRectangle:Rectangle;
        var layout:LayoutObject;

        /*
         var leftMargin:Number = 0;
         var rightMargin:Number = 0;
         var topMargin:Number = 0;
         var bottomMargin:Number = 0;
         */

        var px:Number = 0;
        var py:Number = 0;

        var sumChildWidth:Number = 0;
        var sumChildHeight:Number = 0;

        for each (child in childs) {
            sumChildWidth += child.width;
            sumChildHeight += child.height;
        }

        var hOffset:Number = getHOffset(layout.contentHAlign, $cWidth, sumChildWidth);
        var vOffset:Number = getVOffset(layout.contentVAlign, $cHeight, sumChildHeight);

        for each (child in childs) {
            //leftMargin = rightMargin = topMargin = bottomMargin = 0;
            var childWidth:Number = child.width;
            var childHeight:Number = child.height;

            childRectangle = child.getRect(child);
            resultRectangle = childRectangle.clone();

            switch (layout.layout) {
                case Layout.HORISONTAL:
                    resultRectangle.x = px + hOffset;
                    resultRectangle.y = getSimpleVPosition(layout.contentVAlign, $cHeight, childHeight);

                    px += childWidth;
                    break;
                case Layout.VERTICAL:
                    resultRectangle.x = getSimpleHPosition(layout.contentHAlign, $cWidth, childWidth);
                    resultRectangle.y = py + vOffset;
                    py += childHeight;
                    break;
                default:
                    resultRectangle.x = 0;
                    resultRectangle.y = 0;
                    break;
            }
            /*
             resultRectangle.width = childWidth;
             resultRectangle.height = childHeight;
             */
            if (apply) {
                child.x = resultRectangle.x;
                child.y = resultRectangle.y;
            }

            result.push(resultRectangle);
        }

        return result;
    }

    private static function getSimpleVPosition(vAlign:String, containerHeight:Number, height:Number):Number {
        switch (vAlign) {
            case Layout.TOP:
                return 0;
                break;
            case Layout.MIDDLE:
                return (containerHeight - height) / 2;
                break;
            case Layout.BOTTOM:
                return containerHeight - height;
                break;
        }
        return 0;
    }

    private static function getSimpleHPosition(hAlign:String, containerWidth:Number, width:Number):Number {
        switch (hAlign) {
            case Layout.LEFT:
                return 0;
                break;
            case Layout.CENTER:
                return (containerWidth - width) / 2;
                break;
            case Layout.RIGHT:
                return containerWidth - width;
                break;
        }
        return 0;
    }

    public static function getHOffset(hAlign:String, containerWidth:Number, childsWidth:Number):Number {
        switch (hAlign) {
            case Layout.LEFT:
                return 0;
                break;
            case Layout.CENTER:
                return (containerWidth - childsWidth) / 2;
                break;
            case Layout.RIGHT:
                return containerWidth - childsWidth;
                break;
        }
        return 0;
    }

    public static function getVOffset(vAlign:String, containerHeight:Number, childsHeight:Number):Number {
        switch (vAlign) {
            case Layout.TOP:
                return 0;
                break;
            case Layout.MIDDLE:
                return (containerHeight - childsHeight) / 2;
                break;
            case Layout.BOTTOM:
                return containerHeight - childsHeight;
                break;
        }
        return 0;
    }


}
}