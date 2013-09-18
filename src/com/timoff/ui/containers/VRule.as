/**
 * Author: Vasily
 * Web: http://timoff.com
 * Date: 18.05.11
 * Time: 11:02
 */
package com.timoff.ui.containers {
import com.timoff.ui.controls.Control;
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.layout.Layout;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;

public class VRule extends Rule {
    private var RuleRender:Class;

    public function VRule(id:String = '', styleName:String = '', type:String = Control.VRULE) {
        super(id, styleName, type);
        layout.layout = Layout.VERTICAL;
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

        minRuleValue = prevChild.y;
        maxRuleValue = nextChild.y + nextChild.height;
        super.ruleMouseDownHandler(event);
    }

    override protected function ruleMouseMoveHandler(event:MouseEvent):void {
        var mouseY:Number = this.mouseY;
        mouseY = mouseY > maxRuleValue ? maxRuleValue : mouseY;
        mouseY = mouseY < minRuleValue ? minRuleValue : mouseY;

        var difference:Number = mouseY - activeRule.y;
        prevChild.layout.isSpacer = nextChild.layout.isSpacer = false;

        if (isNaN(prevChild.minHeight)) prevChild.minHeight = 10;
        if (isNaN(nextChild.minHeight)) nextChild.minHeight = 10;

        if (difference < 0 && prevChild.height == prevChild.minHeight) return;
        if (difference > 0 && nextChild.height == nextChild.minHeight) return;

        prevChild.height += difference;
        nextChild.height -= difference;
        return;
    }

    override public function addChild(child:DisplayObject):DisplayObject {

        if (containerChilds.length > 0) {
            var rule:FFComponent = new RuleRenderrer() as FFComponent;
            rule.$setSize("100%", layout.gap);
            addRuleListeners(rule);
            activeRule = rule;
            rulesMap[child] = rule;
            super.addChild(rule);
        }

        return super.addChild(child);
    }
}
}
