/**
 * Author: Vasily
 * Web: http://timoff.com
 * Date: 19.05.11
 * Time: 13:13
 */
package com.examples {
import com.timoff.ui.containers.Container;
import com.timoff.ui.data.styles.textfield.BaseTextFieldStyle;
import com.timoff.ui.layout.Layout;
import com.timoff.ui.managers.PopUpManager;
import com.timoff.ui.managers.StyleStorageManager;

import com.timoff.ui.managers.TooltipManager;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

[SWF(width="800", height="600", frameRate="60", backgroundColor="#DFDFDF")]
public class BaseFramework extends Sprite {

    [Embed(source="C:/WINDOWS/Fonts/ARIALN.TTF",fontFamily="ArialNarrow",embedAsCFF="false")]
    public var ArialNarrow:Class;

    protected var baseContainer:Container;
    protected var contentContainer:Container;
    protected var popupContainer:Container;
    protected var tooltipContainer:Container;

    public function BaseFramework() {
        super();

        //Log.enableTrace = false;
        initStyles();
        addEventListeners();
    }

    protected function initStyles():void {
        BaseTextFieldStyle.DEFAULT_FONT_FAMILY = "ArialNarrow";
        BaseTextFieldStyle.fontFamily = "ArialNarrow";
        StyleStorageManager.init();
    }

    private function addEventListeners():void {
        this.addEventListener(Event.ADDED_TO_STAGE, stageHandler, false, 0, true);

    }


    protected function stageHandler(event:Event):void {

        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        stage.stageFocusRect = false;
        stage.tabChildren = false;

        stage.addEventListener(Event.RESIZE, stageResizeHandler, false, 1, true);

        this.graphics.beginFill(0xEFEFEF, 1);
        this.graphics.drawRect(0, 0, 800, 600);
        this.graphics.endFill();

        TooltipManager.registerFacadeStage(facadeName, this);
        PopUpManager.registerStageByFacade(facadeName, this)

        initContainers();
        tests();
    }

    private function initContainers():void {
        baseContainer = new Container("base");
        baseContainer.$setSize(stage.stageWidth, stage.stageHeight);
        baseContainer.facadeId = facadeName;

        contentContainer = new Container("contentContainer");
        contentContainer.$setSize("100%", "100%");
        contentContainer.layout.layout = Layout.VERTICAL;
        contentContainer.layout.gap = 10;


        popupContainer = new Container("popupContainer");
        popupContainer.$setSize("100%", "100%");

        tooltipContainer = new Container("tooltipContainer");
        tooltipContainer.$setSize("100%", "100%");


        this.addChild(baseContainer);
        baseContainer.addChilds([contentContainer, popupContainer, tooltipContainer]);
    }

    private function stageResizeHandler(event:Event):void {
        if (baseContainer) {
            baseContainer.setSize(stage.stageWidth, stage.stageHeight);
        }
    }

    protected function tests():void {
    }

    protected function get facadeName():String {
        return "default";
    }

}
}
