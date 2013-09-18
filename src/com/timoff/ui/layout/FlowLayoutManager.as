/**
 * Author: Vasily
 * Web: http://timoff.com
 * Date: 17.05.11
 * Time: 14:42
 */
package com.timoff.ui.layout {
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.data.layout.PointsLine;

import flash.display.DisplayObject;
import flash.geom.Rectangle;
import flash.utils.getTimer;

public class FlowLayoutManager {

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

        FFComponent.log.debug("HLM: id " + container.id + " , " + $cLayout.contentHAlign + " , " + sumChildsWidth + " , " + container.contentWidth + " , " + px + " , " + countSpacers);

        var leftMargin:Number = 0;
        var rightMargin:Number = 0;
        var topMargin:Number = 0;
        var bottomMargin:Number = 0;

        var boundsRects:Array = [];
        var boundsRectangle:Rectangle;
        var slice:Object = { maxX : 0, maxY:0, lastLine:0};
        var lines:Vector.<PointsLine> = new Vector.<PointsLine>();

        var timer:Number = getTimer();
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
            resultRectangle.width = childWidth;
            resultRectangle.height = childHeight;

            boundsRectangle = new Rectangle();
            boundsRectangle.width = child.width + leftMargin + rightMargin + $cLayout.gap;
            boundsRectangle.height = child.height + topMargin + bottomMargin + $cLayout.gap;

            arrangeBounds(boundsRectangle, boundsRects, container.contentWidth, lines, slice);

            if (ffchild) {
                if (!ffchild.visible && !ffchild.layout.isMeasuredInvisible)
                    ;
                else
                    boundsRects.push(boundsRectangle);
            }
            else
                boundsRects.push(boundsRectangle);

            resultRectangle.x = boundsRectangle.x;
            resultRectangle.y = boundsRectangle.y;

            if (apply) {

                resultRectangle.x += $cLayout.paddingLeft
                resultRectangle.y += $cLayout.paddingTop

                var childX:Number = resultRectangle.x;
                var childY:Number = resultRectangle.y;

                if (ffchild) {
                    ffchild.$move(childX, childY);
                }
                else {
                    child.x = childX;
                    child.y = childX;
                }
            }
            result.push(resultRectangle);
        }

        trace ("*** Flow time " + ( getTimer() - timer ) );
        return result;
    }


    private static function compareXY(current:PointsLine, next:PointsLine):Number {
        return current.startX < next.startX && current.y <= next.y ? -1 : current.y < next.y ? -1 : 1;//&& current.y >= next.y ? 1 : current.y < next.y ? -1 : -1;
    }

    private static function compareX(current:PointsLine, next:PointsLine):Number {
        return current.startX >= next.startX ? 1 : -1;
    }

    private static function compareY(current:PointsLine, next:PointsLine):Number {
        return current.y > next.y ? -1 : 1;
    }


    private static function arrangeBounds(boundsRectangle:Rectangle, boundsRects:Array, containerWidth:Number, lines:Vector.<PointsLine>,slice:Object ):void {

        var countItems:int = boundsRects.length;
        var mrect:Rectangle;
        var i:int;
        var maxX:Number = slice.maxX;
        var maxY:Number = slice.maxY;
        var lastLine:Number = slice.lastLine;

        if (countItems == 0) return;

        for (i = lastLine; i < countItems; i++) {
            mrect = boundsRects[i];
            var pl:PointsLine = new PointsLine(mrect.x, mrect.x + mrect.width, mrect.y + mrect.height);
            lines.push(pl);
            maxX = pl.endX > maxX ? pl.endX : maxX;
            maxY = pl.y > maxY ? pl.y : maxY;
        }


        if (maxX + boundsRectangle.width <= containerWidth) {
            boundsRectangle.x = maxX;
            boundsRectangle.y = 0;
            return;
        }

        if (maxX < containerWidth) lines.push(new PointsLine(maxX, containerWidth, 0));

        //trace("---------------- PLACE " + boundsRects.length + " count bounds " + boundsRects.length);

        checkIntersection(lines);
        checkIntersection(lines);


        var currentX:Number;
        var currentEndX:Number;
        var currentY:Number;

        var maxLines:Vector.<PointsLine> = new Vector.<PointsLine>();
        var currentPl:PointsLine;
        var nextPl:PointsLine;
        var prevPl:PointsLine;
        var s:int;

        countItems = lines.length;
        lines.sort(compareX);

        for (i = 0; i < countItems; i++) {
            currentPl = lines[i];
            //trace("after is line " + i + ", s:" + currentPl.startX + ", e:" + currentPl.endX + " , y:" + currentPl.y);
            currentX = currentPl.startX;
            currentEndX = currentPl.endX;
            currentY = currentPl.y;

            s = i;
            while (--s >= 0) {
                prevPl = lines[s];
                if (prevPl.y < currentPl.y) currentX = prevPl.startX;
                else break;
            }

            s = i;
            while (++s < countItems) {
                nextPl = lines[s];
                if (nextPl.y < currentPl.y) currentEndX = nextPl.endX;
                else break;
            }

            maxLines.push(new PointsLine(currentX, currentEndX, currentY));
        }

        countItems = maxLines.length;
        maxLines.sort(compareXY)

        slice.lastLine = lines.length - 1;
        slice.maxX = maxX;
        slice.maxY = maxY;

        for (i = 0; i < countItems; i++) {
            currentPl = maxLines[i];
            //trace(":: MAX LINES " + i + " :" + currentPl.startX + " , :" + currentPl.endX + " , on:" + currentPl.y);
            if (currentPl.width >= boundsRectangle.width) {
                boundsRectangle.x = currentPl.startX;
                boundsRectangle.y = currentPl.y;
                return;
            }
        }
        boundsRectangle.x = 0;
        boundsRectangle.y = maxY;
        return;
    }


    private static function lineIn(line, checkedLine):Number {
        if (line == checkedLine) return 0;
        if (line.y < checkedLine.y) return 0;

        var startIn:Boolean = checkedLine.startX >= line.startX && checkedLine.startX < line.endX;
        var endIn:Boolean = checkedLine.endX > line.startX && checkedLine.endX <= line.endX;

        if (startIn && !endIn) checkedLine.startX = line.endX;
        if (!startIn && endIn) checkedLine.endX = line.startX;

        return int(startIn) + int(endIn);
    }

    private static function checkIntersection(lines:Vector.<PointsLine>):void {
        lines.sort(compareY);

        var line:PointsLine;
        var checkedline:PointsLine;
        var typeIn:Number;

        for each(line in lines) {
            for each(checkedline in lines) {
                if (!checkedline.deleteFlag) {
                    if (typeIn = lineIn(line, checkedline)) {
                        if(typeIn == 2)
                        {
                        checkedline.deleteFlag = true;
                        }
                    }
                }
            }
        }

        var linesCount:int = lines.length;
        for (var i = 0; i < linesCount; i++) {
            line = lines[i];

            if (line.deleteFlag) {
                lines.splice(i, 1);
                i--;
                linesCount--;
            }
        }


    }

}
}
