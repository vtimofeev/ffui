/**
 * Created by IntelliJ IDEA.
 * User: Vasily
 * Date: 06.04.11
 * Time: 12:52
 * To change this template use File | Settings | File Templates.
 */
package com.timoff.ui.advanced {
import com.timoff.ui.containers.H3DContainer;
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.data.controls.GalleryItemObject;
import com.timoff.ui.interfaces.IGalleryItem;
import com.timoff.ui.layout.Layout;

import flash.geom.Matrix3D;
import flash.geom.Vector3D;

public class Base3DGallery extends BaseGallery {

    public function Base3DGallery(id:String = null, styleName:String = null, direction:String = Layout.HORISONTAL, itemRenderrer:Class = null, itemRenderrerStyleName:String = '') {
        super(id, styleName, direction, false, itemRenderrer, itemRenderrerStyleName);

    }

    override protected function initContentContainer():void {
        contentContainer = new H3DContainer();
    }

    override protected function initControls():void {
        super.initControls();
        contentContainer.layout.layout = Layout.HORISONTAL_3D_V2;
    }

    override protected function calculateShowItems():int {
        var result:int = super.calculateShowItems();
        if (result % 2 == 0) result--;
        showChilds = result;
        return result;
    }

    public function get activeIndex():int {
        var result:int = startIndex + Math.floor(showChilds/2);
        result = result >= dataProvider.length ? (result - dataProvider.length) : result;
        trace("ActiveIndex: " + result);
        return result;
    }

    public function get activeShowIndex():int {
        return Math.floor(showChilds/2);
    }

    public function get activeItem():Object {
        var result:GalleryItemObject = (activeIndex > -1) ? dataProvider[activeIndex] as GalleryItemObject : null;
        return result ? result : null;
    }

    public function get activeGalleryItem():FFComponent {
        var result:FFComponent = contentContainer.containerChilds[Math.floor(showChilds/2)];
        return result;
    }

    override protected function draw():void {
        trace("pre draw::" + showChilds);
        super.draw();
    }

    override public function set dataProvider(value:Vector.<GalleryItemObject>):void {
        super.dataProvider = value;
    }
}
}
