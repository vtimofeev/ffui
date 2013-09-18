/**
 * Created by IntelliJ IDEA.
 * User: Vasily
 * Date: 06.04.11
 * Time: 14:20
 */
package com.timoff.ui.layout {
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.geom.AdvancedRectangle;
import com.timoff.ui.interfaces.IGalleryItem;
import com.timoff.ui.managers.LayoutManager;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.geom.Matrix3D;
import flash.geom.PerspectiveProjection;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Vector3D;

public class LineZ3DLayoutManager {

    public static var OVERLAP:Number = .3;

    public static function arrange(container:FFComponent, childs:Array, apply:Boolean):Array {

        const $cWidth:Number = container.contentWidth;
        const $cHeight:Number = container.contentHeight;
        const $cLayout:LayoutObject = container.layout;


        var result:Array = [];
        var layout3DOverlap:Number = OVERLAP;

        var child:DisplayObject;
        var ffchild:FFComponent;
        var childRectangle:Rectangle;
        var resultRectangle:AdvancedRectangle;
        var layout:LayoutObject;

        var sumChildsWidth:Number = 0;
        var countSpacers:int = 0;
        var spacerWidth:Number = 0;

        var px:Number = 0;
        var horisontalMargins:Number = 0;

        var destIndex:int = 0;
        var activeIndex:int = childs.length;
        var i:int = 0;

        var leftMargin:Number = 0;
        var rightMargin:Number = 0;
        var topMargin:Number = 0;
        var bottomMargin:Number = 0;

        var childsCount:int = childs.length;

        i = 0;

        for each (child in childs) {
            leftMargin = rightMargin = topMargin = bottomMargin = 0;
            ffchild = null;
            layout = null;

            resultRectangle = new AdvancedRectangle(0, 0, child.width, child.height);
            destIndex = activeIndex - i;
            resultRectangle.scaleX = resultRectangle.scaleY = getScaleFactor(i, activeIndex, child.width);
            resultRectangle.zIndex = getZIndex(i, activeIndex, childsCount);

            var childWidth:Number = child.width * resultRectangle.scaleX;
            var childHeight:Number = child.height * resultRectangle.scaleY;

            if (child is FFComponent) {
                ffchild = child as FFComponent;
                layout = ffchild.layout;

                leftMargin = layout.marginLeft;
                rightMargin = layout.marginRight;
                topMargin = layout.marginTop;
                bottomMargin = layout.marginBottom;

                // set up to center
                child.x = ( container.contentWidth - ( child.width *  child.scaleX ))/2 ;
                child.y = ( container.contentHeight - ( child.height * child.scaleY ))/2 ;
            }

            childRectangle = child.getRect(container);
            //resultRectangle = childRectangle.clone();

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

            resultRectangle.x =   ( container.contentWidth - ( child.width *   resultRectangle.scaleX ))/2 - $cLayout.marginLeft;

            if (ffchild) {
                if (layout.isSpacer)
                    childWidth = spacerWidth - layout.marginLeft - layout.marginRight;
            }


            resultRectangle.width = child.width;
            resultRectangle.height = child.height;


            if (apply)
            {

                ffchild.$move(resultRectangle.x, resultRectangle.y, NaN, NaN, NaN, NaN, resultRectangle.scaleX, resultRectangle.scaleY);
                if (ffchild is IGalleryItem) IGalleryItem(ffchild).activeIndex = destIndex;



                var parent:DisplayObjectContainer = child.parent;
                if(parent) parent.swapChildrenAt(parent.getChildIndex(child), IGalleryItem(child).sortOrder );


            }
            i++;
            result.push(resultRectangle);
        }


        var pp:PerspectiveProjection = new PerspectiveProjection();
        pp.projectionCenter = new Point(container.width/2,container.height/2);
        container.transform.perspectiveProjection = pp;


        return result;
    }

    private static function onEnterFrameHandler(event:Event):void {
        //FFComponent(event.target).$rotationY += 1;
        trace("rotate" + FFComponent(event.target).id);
        FFComponent(event.target).transform.matrix3D.appendRotation(1, Vector3D.Y_AXIS);

    }

    public static function getScaleFactor(current:int, active:int, width:int):Number {
        return (active-current+1)*40/width + 1;
    }

    public static function getRotationXFactor(current:int, active:int):Number {
        if (current == active) return 0;
        return  -10 * getDistanceBetweenIndexes(current, active) + 10;
    }

    public static function getRotationYFactor(current:int, active:int):Number {
        if (current == active) return 0;
        var destIndex:int = getDistanceBetweenIndexes(current, active);
        return   35 * (destIndex>2?(2 + (destIndex-2)/3):destIndex) - 35;

    }


    public static function getDistanceBetweenIndexes(current:int, active:int):int {
        var result:int = current - active;
        result = (result < 0) ? -result : result;
        return ++result;
    }


    public static function getZIndex(current:int, active:int, total:int):int {
        var result:int = (current < active) ? current * 2 : ((total - current) * 2 - 1);
        result = (current == active) ? (total - 1) : result;
        return result;
    }


}
}
