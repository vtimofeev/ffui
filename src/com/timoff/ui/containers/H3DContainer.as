/**
 * Created by IntelliJ IDEA.
 * User: Vasily
 * Date: 06.04.11
 * Time: 14:06
 * To change this template use File | Settings | File Templates.
 */
package com.timoff.ui.containers {
import com.timoff.ui.core.FFComponent;

import com.timoff.ui.layout.Layout;

import flash.display.DisplayObject;

public class H3DContainer extends Container {
    public function H3DContainer() {
        super.layout.layout = Layout.HORISONTAL_3D
    }

    override protected function updateContainer():void {
        super.updateContainer();

        /*
        var child:DisplayObject;
        var i:int = 0;
        var scaleFactor:int = 1;
        var actIndex = Math.ceil((_containerChilds.length-1)/ 2);

        for each(child in  _containerChilds) {
            if (child is FFComponent) {
                var destIndex:int = actIndex - i;
                destIndex = (destIndex < 0) ? -destIndex : destIndex;
                destIndex++;
                child.scaleX = child.scaleY = 1 / destIndex;
            }
            i++;
        }
        return;
        */

    }
}
}
