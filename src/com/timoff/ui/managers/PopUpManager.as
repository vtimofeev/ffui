package com.timoff.ui.managers {
import com.timoff.ui.containers.Window;
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.layout.Layout;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.utils.Dictionary;

public class PopUpManager {

    private static var pops:Object = {};
    private static var facadesStages:Dictionary = new Dictionary();

    public static function registerStageByFacade(facadeName:String, stage:DisplayObject) {
        facadesStages[facadeName] = stage;
    }


    public static function createParentPopUp(parent:DisplayObjectContainer, ClassDefinition:Class, id:String = "popup", closeHandler:Function = null, hAlign:String = Layout.CENTER, vAlign:String = Layout.TOP, facade:String = "default"):FFComponent {
        var wnd:FFComponent = new ClassDefinition(id, null);

        wnd.layout.hAlign = hAlign;
        wnd.layout.vAlign = vAlign;

        if (parent) parent.addChild(wnd)
        return wnd;
    }

    public static function createPopUp(ClassDefinition:Class, facadeName:String = 'default', id:String = "popup", closeHandler:Function = null, hAlign:String = Layout.CENTER, vAlign:String = Layout.TOP, facade:String = "default"):FFComponent {

        var parent:DisplayObjectContainer = facadesStages[facadeName] as DisplayObjectContainer;
        //trace ("Has Parent " + parent);

        var wnd:FFComponent = new ClassDefinition(id, null);
        wnd.layout.hAlign = hAlign;
        wnd.layout.vAlign = vAlign;

        // todo analyze necessity
        if (!pops[facade]) pops[facade] = [];

        if (parent) parent.addChild(wnd)
        return wnd;
    }

    public static function removePopUp(instance:Window, facade:String = "default"):void {
        if (!instance)
            return;
        if (!instance.parent)
            return;

        instance.parent.removeChild(instance);
        return;
    }

}
}