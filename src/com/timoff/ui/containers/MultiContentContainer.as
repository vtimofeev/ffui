/**
 * Author: Vasily
 * Web: http://timoff.com
 * Date: 24.05.11
 * Time: 19:53
 */
package com.timoff.ui.containers {
import com.timoff.ui.controls.Control;
import com.timoff.ui.controls.State;
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.data.controls.ContentObject;
import com.timoff.ui.data.controls.SizeObject;
import com.timoff.ui.layout.Layout;
import com.timoff.ui.layout.LayoutObject;

import flash.display.DisplayObject;
import flash.utils.Dictionary;

public class MultiContentContainer extends Container {

    private var defaultLayout:LayoutObject;
    private var defaultSize:SizeObject;

    private var statesContents:Dictionary = new Dictionary(true);

    public function MultiContentContainer(id:String = '', styleName:String = '', type:String = Control.MULTICONTAINER) {
        super(id, styleName, type);
    }

    public function addContent(content:Object, stateName:String = State.DEFAULT, layout:LayoutObject = null, sizeObject:SizeObject = null) {
        statesContents[stateName] = new ContentObject(content, layout, sizeObject);
    }

    override public function set state(value:String):void {
        if (state == value) return;
        const contentObject:ContentObject = statesContents[value] as ContentObject;

        if (contentObject) {
            removeChilds();
            if (contentObject.content is DisplayObject) {
                this.addChild(contentObject.content as DisplayObject);
            }
            else if (contentObject.content is Array) {
                this.addChilds(contentObject.content as Array);
            }
        }

        super.state = value;
        return;
    }


    override public function addChild(child:DisplayObject):DisplayObject {

        if(child is FFComponent)
        {
            FFComponent(child).isFreeable = false;
        }

        return super.addChild(child);
    }


}
}
