/**
 * Author: Vasily
 * Web: http://timoff.com
 * Date: 18.05.11
 * Time: 15:55
 */
package com.timoff.ui.containers {
import com.timoff.ui.controls.Button;
import com.timoff.ui.controls.Control;
import com.timoff.ui.controls.State;
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.data.containers.RuleSettings;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

public class Rule extends Container {
    protected var RuleRenderrer:Class = Button;

    protected var _settings:RuleSettings;

    protected var rulesMap:Dictionary = new Dictionary(true);

    protected var activeRule:FFComponent;

    protected var prevChild:FFComponent;

    protected var nextChild:FFComponent;

    protected var minRuleValue:Number;

    protected var maxRuleValue:Number;

    public function Rule(id,styleName,type:String = Control.RULE) {
        super(id, styleName, type);

        settings = new RuleSettings();
    }

    public function get settings():RuleSettings {
        return _settings;
    }

    public function set settings(value:RuleSettings):void {
        _settings = value;
        layout.gap = settings.size;
    }

    protected function addRuleListeners(rule:DisplayObject):void {
        rule.addEventListener(MouseEvent.MOUSE_DOWN, ruleMouseDownHandler, false, 1, true);
    }

    protected function ruleMouseDownHandler(event:Event):void {

        addRuleStageListeners(true);
    }

    private function ruleMouseUpHandler(event:Event):void {
        addRuleStageListeners(false);
        activeRule = null;
    }

    protected function ruleMouseMoveHandler(event:MouseEvent):void {


        return;
    }

    private function addRuleStageListeners(value:Boolean = false):void {
        if (!stage || !activeRule) return;

        if (value) {
            addStageEventListener(MouseEvent.MOUSE_UP, ruleMouseUpHandler, null, false, 1, true);
            addStageEventListener(MouseEvent.MOUSE_MOVE, ruleMouseMoveHandler, null, false, 1, true);
            addStageEventListener(Event.MOUSE_LEAVE, ruleMouseUpHandler, null, false, 1, true);
            if (activeRule is Button) Button(activeRule).disableMouse = true;
        }
        else {
            removeStageEventListener(MouseEvent.MOUSE_UP, ruleMouseUpHandler);
            removeStageEventListener(MouseEvent.MOUSE_MOVE, ruleMouseMoveHandler);
            removeStageEventListener(Event.MOUSE_LEAVE, ruleMouseUpHandler);
            if (activeRule is Button) Button(activeRule).disableMouse = false;
            activeRule.state = State.DEFAULT;
        }
    }

    override public function removeChild(child:DisplayObject):DisplayObject {
        var mappedRule:DisplayObject = rulesMap[child] as DisplayObject;
        if (mappedRule) super.removeChild(mappedRule);
        return super.removeChild(child);
    }
}
}
