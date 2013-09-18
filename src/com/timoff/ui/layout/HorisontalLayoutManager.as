package com.timoff.ui.layout {
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.managers.LayoutManager;

import flash.display.DisplayObject;
import flash.geom.Matrix3D;
import flash.geom.Rectangle;
import flash.geom.Vector3D;

public class HorisontalLayoutManager {

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

        var sumChildsWidth:Number = 0;
        var countSpacers:int = 0;
        var spacerWidth:Number = 0;


        var px:Number = 0;
        var horisontalMargins:Number = 0;

        for each (child in childs) {
            horisontalMargins = 0;

            if (child is FFComponent) {
                ffchild = child as FFComponent;
                if(!ffchild.layout.isLayable) continue;
                if (!ffchild.visible && !ffchild.layout.isMeasuredInvisible)
                    continue;

                if (ffchild.layout.isSpacer) {
                    countSpacers++;
                    continue;
                }


                horisontalMargins = ffchild.layout.marginLeft + ffchild.layout.marginRight;
            }
            sumChildsWidth += child.width + horisontalMargins + $cLayout.gap;
        }

        if (sumChildsWidth) sumChildsWidth -= $cLayout.gap;

        if (countSpacers > 0 && sumChildsWidth < container.contentWidth) {
            spacerWidth = int(( container.contentWidth - sumChildsWidth - $cLayout.gap * countSpacers) / countSpacers);
        }

        if (countSpacers == 0) {
            px = LayoutManager.getHOffset($cLayout.contentHAlign, container.contentWidth, sumChildsWidth);
        }

        FFComponent.log.debug("HLM: id " + container.id + " , " + $cLayout.contentHAlign + " , " + sumChildsWidth + " , " + container.contentWidth + " , " + px + " , " + countSpacers);

        var leftMargin:Number = 0;
        var rightMargin:Number = 0;
        var topMargin:Number = 0;
        var bottomMargin:Number = 0;

        for each (child in childs) {
            leftMargin = rightMargin = topMargin = bottomMargin = 0;
            ffchild = null;
            layout = null;

            var childWidth:Number = child.width;
            var childHeight:Number = child.height;

            if (child is FFComponent) {
                ffchild = child as FFComponent;
                layout = ffchild.layout;

                leftMargin = layout.marginLeft;
                rightMargin = layout.marginRight;
                topMargin = layout.marginTop;
                bottomMargin = layout.marginBottom;
            }

            childRectangle = child.getRect(container);
            resultRectangle = childRectangle.clone();

            switch ($cLayout.contentVAlign) {
                case Layout.TOP:
                    resultRectangle.y = topMargin;
                    break;

                case Layout.BOTTOM:
                    resultRectangle.y = $cHeight - childHeight - bottomMargin;
                    break;

                default:
                    resultRectangle.y = ($cHeight - childHeight) / 2;
                    break;
            }

            resultRectangle.x = px + leftMargin;

            if (ffchild) {
                if (layout.isSpacer)
                    childWidth = spacerWidth - layout.marginLeft - layout.marginRight;
            }

            resultRectangle.width = childWidth;
            resultRectangle.height = childHeight;

            if (ffchild) {
                if (!ffchild.visible && !ffchild.layout.isMeasuredInvisible || !ffchild.layout.isLayable)
                    px = px;
                else
                    px = px + leftMargin + childWidth + rightMargin + $cLayout.gap;

            }
            else
                px = px + leftMargin + childWidth + rightMargin + $cLayout.gap;


            if (apply && ffchild.layout.isLayable) {

                resultRectangle.x += $cLayout.paddingLeft
                resultRectangle.y += $cLayout.paddingTop

                var childX:Number = resultRectangle.x;
                var childY:Number = resultRectangle.y;

                if (ffchild) {
                    if (layout.isSpacer) child.width = childWidth;
                    ffchild.$move(childX, childY);
                }
                else {
                    child.x = childX;
                    child.y = childX;
                }


            }


            result.push(resultRectangle);
        }

        return result;
    }


}
}