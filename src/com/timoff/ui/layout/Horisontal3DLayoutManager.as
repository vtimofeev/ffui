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

public class Horisontal3DLayoutManager {

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
        var activeIndex:int = Math.ceil((childs.length - 1) / 2);
        var i:int = 0;

        for each (child in childs) {
            horisontalMargins = 0;
            var scaleFactor:Number = getScaleFactor(i, activeIndex);

            if (child is FFComponent) {
                ffchild = child as FFComponent;

                if (!ffchild.visible && !ffchild.layout.isMeasuredInvisible)
                    continue;

                if (ffchild.layout.isSpacer) {
                    countSpacers++;
                    continue;
                }

                horisontalMargins = ffchild.layout.marginLeft + ffchild.layout.marginRight;
            }
            sumChildsWidth += child.width * scaleFactor + horisontalMargins + $cLayout.gap - get3DOffset(i, activeIndex, child.width, layout3DOverlap);
            i++;
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

        var childsCount:int = childs.length;

        i = 0;

        for each (child in childs) {
            leftMargin = rightMargin = topMargin = bottomMargin = 0;
            ffchild = null;
            layout = null;

            resultRectangle = new AdvancedRectangle(0, 0, child.width, child.height);
            destIndex = getDistanceBetweenIndexes(i, activeIndex);
            resultRectangle.scaleX = resultRectangle.scaleY = getScaleFactor(i, activeIndex);
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

            resultRectangle.x = px + leftMargin;

            if (ffchild) {
                if (layout.isSpacer)
                    childWidth = spacerWidth - layout.marginLeft - layout.marginRight;
            }

            resultRectangle.width = child.width;
            resultRectangle.height = child.height;

            if (ffchild) {
                if (!ffchild.visible && !ffchild.layout.isMeasuredInvisible)
                    px = px;
                else
                    px = px + leftMargin + childWidth + rightMargin + $cLayout.gap - get3DOffset(i + 1, activeIndex, child.width, layout3DOverlap);
            }
            else
                px = px + leftMargin + childWidth + rightMargin + $cLayout.gap - get3DOffset(i + 1, activeIndex, child.width, layout3DOverlap);


            if (apply) {
                resultRectangle.x += $cLayout.paddingLeft;
                resultRectangle.y += $cLayout.paddingTop;
                resultRectangle.x += (i>childsCount/2)?(i-activeIndex)*30:0;

                var childX:Number = resultRectangle.x;
                var childY:Number = resultRectangle.y + destIndex*25;

                if (resultRectangle.zIndex > -1) {
                    var parent:DisplayObjectContainer = child.parent;
                    parent.swapChildrenAt(parent.getChildIndex(child), resultRectangle.zIndex);
                }

                if (ffchild is IGalleryItem) {
                    IGalleryItem(ffchild).activeIndex = destIndex;
                }

                trace("arranged i element " + i + ":" + child.parent + " , " + childX + " , " + childY + " , " + resultRectangle.scaleX + " , " + resultRectangle.scaleY)

                if (ffchild) {
                    var sign:int = i < childsCount / 2 ? 1 : -1;
                    var rotationY = sign * getRotationYFactor(i, activeIndex);
                    var rotationX = getRotationXFactor(i, activeIndex);
                    /*
                     if (activeIndex == i) child.transform.matrix3D = null;
                     */
                    var childZ:Number = 350*(destIndex-1);
                    if (i > childsCount / 2) childZ -= 150;

                    ffchild.$move(childX, childY, childZ, rotationX, rotationY, 0);
                    trace("3d ========== " + i + " , " + destIndex + " , " + ffchild.z);

                    /*
                     var matrix3d:Matrix3D = ffchild._currentStateBackgroundObject.transform.matrix3D = new Matrix3D();
                     if (!matrix3d) matrix3d = ffchild._currentStateBackgroundObject.transform.matrix3D = new Matrix3D();
                     matrix3d.prependTranslation(child.width / 2, child.height / 2, 0);
                     matrix3d.prependRotation(-45, Vector3D.Y_AXIS);
                     matrix3d.prependTranslation(-child.width / 2, -child.height / 2, 0);
                     */
                    /*
                     var pp:PerspectiveProjection = new PerspectiveProjection();
                     pp.projectionCenter = new Point(ffchild.width/2,ffchild.height/2);
                     ffchild.transform.perspectiveProjection = pp;
                     */
                    /*
                     var matrix3d:Matrix3D = child.transform.matrix3D;
                     if(!matrix3d) matrix3d = child.transform.matrix3D = new Matrix3D();
                     //matrix3d.prependTranslation(child.width / 2, child.height / 2, 0);

                     matrix3d.prependScale(resultRectangle.scaleX, resultRectangle.scaleY, resultRectangle.scaleY );
                     }p;l0o9i8- 99  9bnbhnhu8jji9- i78
                     //matrix3d.prependTranslation(child.parent.width / 2, child.parent.height / 2,0);
                     //matrix3d.prependRotation(ffchild.rotationX, Vector3D.X_AXIS);
                     matrix3d.prependRotation(rotationY, Vector3D.Y_AXIS);
                     */
                }
                else {
                    child.x = childX;
                    child.y = childX;
                    child.scaleX = resultRectangle.scaleX;
                    child.scaleY = resultRectangle.scaleY;
                }

                /*
                 if (activeIndex != i) {
                 var rotation:int = int(-(activeIndex - i) * 90 / 3);
                 var matrix3d:Matrix3D = child.transform.matrix3D = new Matrix3D();
                 matrix3d.prependTranslation(child.width / 2, child.height / 2, 0);
                 matrix3d.prependRotation(rotation, Vector3D.Y_AXIS);
                 }
                 */

                i++;
                result.push(resultRectangle);
            }

        }
        var pp:PerspectiveProjection = new PerspectiveProjection();
        pp.projectionCenter = new Point(container.width/2,container.height/2);//child.parent.height/2);
        container.transform.perspectiveProjection = pp;

        return result;
    }

    private static function containerHandler(event:Event):void {


        var cont:FFComponent = event.target as FFComponent;

        var pp1:PerspectiveProjection = cont.transform.perspectiveProjection;
        var pp2:PerspectiveProjection = new PerspectiveProjection();

        //pp1.focalLength=100;
        pp2.projectionCenter = new Point(pp1.projectionCenter.x + .2, pp1.projectionCenter.y + .2);//child.parent.height/2);
        trace (pp2.projectionCenter.toString());


        cont.transform.perspectiveProjection = pp2;


    }

    private static function onEnterFrameHandler(event:Event):void {
        //FFComponent(event.target).$rotationY += 1;
        trace("rotate" + FFComponent(event.target).id);
        FFComponent(event.target).transform.matrix3D.appendRotation(1, Vector3D.Y_AXIS);

    }

    public static function getScaleFactor(current:int, active:int):Number {
        return .8 + .2 / getDistanceBetweenIndexes(current, active);
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

    public static function get3DOffset(current:int, active:int, width:Number, offset:Number):Number {
        var result = 0;
        var offsetIndex = current <= active ? current > 0 ? current - 1 : 0 : current;

        if (current == 0) return 0;
        var sf:Number = getScaleFactor(offsetIndex, active);
        result = sf * width * offset;
        return result ;
    }


    public static function getZIndex(current:int, active:int, total:int):int {
        var result:int = (current < active) ? current * 2 : ((total - current) * 2 - 1);
        result = (current == active) ? (total - 1) : result;
        return result;
    }


}
}
