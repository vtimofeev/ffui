/**
 * Author: Vasily
 * Web: http://timoff.com
 * Date: 18.05.11
 * Time: 10:59
 */
package com.timoff.ui.containers {
import com.timoff.ui.controls.Control;
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.data.containers.RuleSettings;
import com.timoff.ui.layout.Layout;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;

public class HRule extends Rule {

    public function HRule(id:String = '', styleName:String = '', type:String = Control.HRULE) {
        super(id, styleName, type);
        layout.layout = Layout.HORISONTAL;
    }

    override protected function ruleMouseDownHandler(event:Event):void {
        activeRule = event.currentTarget as FFComponent;
        const childsCount:int = containerChilds.length;
        for (var i:int = 0; i < childsCount; i++) {
            if (containerChilds[i] == activeRule) {
                prevChild = containerChilds[i - 1] as FFComponent;
                nextChild = containerChilds[i + 1] as FFComponent;
                break;
            }
        }

        minRuleValue = prevChild.x;
        maxRuleValue = nextChild.x + nextChild.width;
        super.ruleMouseDownHandler(event);
    }

    override protected function ruleMouseMoveHandler(event:MouseEvent):void {
        var mouseX:Number = this.mouseX;
        mouseX = mouseX > maxRuleValue ? maxRuleValue : mouseX;
        mouseX = mouseX < minRuleValue ? minRuleValue : mouseX;

        var difference:Number = mouseX - activeRule.x;
        prevChild.layout.isSpacer = nextChild.layout.isSpacer = false;

        if (isNaN(prevChild.minWidth)) prevChild.minWidth = 10;
        if (isNaN(nextChild.minWidth)) nextChild.minWidth = 10;

        if (difference < 0 && prevChild.width == prevChild.minWidth) return;
        if (difference > 0 && nextChild.width == nextChild.minWidth) return;

        prevChild.width += difference;
        nextChild.width -= difference;


    }

    override public function addChild(child:DisplayObject):DisplayObject {

        if (containerChilds.length > 0) {
            var rule:FFComponent = new RuleRenderrer() as FFComponent;
            rule.$setSize(layout.gap, "100%");
            addRuleListeners(rule);
            activeRule = rule;
            rulesMap[child] = rule;
            super.addChild(rule);
        }


        return super.addChild(child);
    }
}
}
