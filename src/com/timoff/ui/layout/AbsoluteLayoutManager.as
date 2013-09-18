package com.timoff.ui.layout {
import com.timoff.ui.core.FFComponent;

import com.timoff.ui.layout.Layout;
import com.timoff.ui.layout.LayoutObject;

import flash.display.DisplayObject;
import flash.geom.Rectangle;


public class AbsoluteLayoutManager {
    public static function arrange(container:FFComponent, childs:Array, apply:Boolean):Array {
        const $cWidth:Number = container.contentWidth;
        const $cHeight:Number = container.contentHeight;
        const $cLayout:LayoutObject = container.layout;

        var result:Array = [];

        var child:DisplayObject;
        var ffchild:FFComponent;
        var childRectangle:Rectangle;
        var resultRectangle:Rectangle;
        var layout:LayoutObject;

        for each (child in childs) {
            childRectangle = child.getRect(container);
            resultRectangle = childRectangle.clone();

            if (child is FFComponent) {
                ffchild = child as FFComponent;
                layout = ffchild.layout;

                switch (layout.hAlign) {
                    case Layout.LEFT:
                        resultRectangle.x = layout.hOffset;
                        break;
                    case Layout.CENTER:
                        resultRectangle.x = layout.hOffset + ($cWidth - child.width) / 2;
                        break;
                    case Layout.RIGHT:
                        resultRectangle.x = layout.hOffset + $cWidth - child.width;
                        break;
                }

                switch (layout.vAlign) {
                    case Layout.TOP:
                        resultRectangle.y = layout.vOffset;
                        break;

                    case Layout.MIDDLE:
                        resultRectangle.y = layout.vOffset + ($cHeight - child.height) / 2;
                        break;

                    case Layout.BOTTOM:
                        resultRectangle.y = layout.vOffset + $cHeight - child.height;
                        break;
                }
            }

            resultRectangle.x += $cLayout.paddingLeft;
            resultRectangle.y += $cLayout.paddingTop;

            if (apply) {
                if (ffchild) {
                    if (ffchild.layout.isLayable) {
                        child.x = resultRectangle.x;
                        child.y = resultRectangle.y;
                    }
                }
                else {
                    child.x = resultRectangle.x;
                    child.y = resultRectangle.y;
                }
            }


            result.push(resultRectangle);
        }

        return result;
    }
}
}
