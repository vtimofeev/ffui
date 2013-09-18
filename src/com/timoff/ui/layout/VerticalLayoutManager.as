package com.timoff.ui.layout {

import com.timoff.ui.core.FFComponent;
import com.timoff.ui.layout.Layout;
import com.timoff.ui.layout.LayoutObject;

import flash.display.DisplayObject;
import flash.geom.Rectangle;


public class VerticalLayoutManager {


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

        var sumChildsHeight:Number = 0;
        var countSpacers:int = 0;
        var spacerHeight:Number = 0;


        var py:Number = 0;
        var verticalMargins:Number = 0;

        for each (child in childs) {
            verticalMargins = 0;

            if (child is FFComponent) {
                ffchild = child as FFComponent;
                if (ffchild.layout.isSpacer) {
                    countSpacers++;
                    continue;
                }
                if (!ffchild.visible && !ffchild.layout.isMeasuredInvisible)
                continue;

                verticalMargins = ffchild.layout.marginTop + ffchild.layout.marginBottom;
            }
            sumChildsHeight += child.height + verticalMargins + $cLayout.gap;
        }

        sumChildsHeight -= $cLayout.gap;

        if (countSpacers > 0 && sumChildsHeight < $cHeight ) {
            spacerHeight = int(( $cHeight - sumChildsHeight - countSpacers*$cLayout.gap ) / countSpacers);
        }

        var leftMargin:Number = 0;
        var rightMargin:Number = 0;
        var topMargin:Number = 0;
        var bottomMargin:Number = 0;

        for each (child in childs) {


            leftMargin = rightMargin = topMargin = bottomMargin = 0;
            ffchild = null;
            layout = null;

            var childWidth :Number = child.width;
            var childHeight:Number = child.height;

            if (child is FFComponent) {
                ffchild = child as FFComponent;
                layout = ffchild.layout;

                leftMargin = layout.marginLeft;
                rightMargin = layout.marginRight;
                topMargin = layout.marginTop;
                bottomMargin = layout.marginBottom;
            }
            else
            {
                leftMargin = 0;
                rightMargin = 0;
                topMargin = 0;
                bottomMargin = 0;
            }

            childRectangle = child.getRect(container);
            resultRectangle = childRectangle.clone();

            switch ($cLayout.contentHAlign) {
                case Layout.RIGHT:
                    resultRectangle.x = $cWidth - childWidth - rightMargin;
                    break;

                case Layout.CENTER:
                    resultRectangle.x = ($cWidth - childWidth ) / 2;
                    break;

                default:
                    resultRectangle.x = leftMargin;
                    break;
            }


            resultRectangle.y = py + topMargin;

            if (ffchild) {
                if (layout.isSpacer)
                    childHeight = spacerHeight - layout.marginTop - layout.marginBottom;
            }

            resultRectangle.width = childWidth ;
            resultRectangle.height = childHeight;

            if (!ffchild.visible && !ffchild.layout.isMeasuredInvisible)
                py = py;
            else
                py = py + topMargin + childHeight  + bottomMargin + $cLayout.gap;

            resultRectangle.x += $cLayout.paddingLeft;
            resultRectangle.y += $cLayout.paddingTop;

            if (apply)
            {
                child.x = resultRectangle.x;
                child.y = resultRectangle.y;
                if (ffchild)
                {
                    if (layout.isSpacer) child.height = childHeight;
                }
            }
            
            result.push(resultRectangle);
        }
        return result;
    }

}
}