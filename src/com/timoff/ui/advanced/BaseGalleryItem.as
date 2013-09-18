package com.timoff.ui.advanced {
import com.timoff.ui.containers.Container;
import com.timoff.ui.controls.Button;
import com.timoff.ui.controls.Image;
import com.timoff.ui.controls.Label;
import com.timoff.ui.data.controls.GalleryItemObject;
import com.timoff.ui.data.core.InvalidationType;
import com.timoff.ui.interfaces.IGalleryItem;
import com.timoff.ui.layout.Layout;

public class BaseGalleryItem extends Container implements IGalleryItem {

    private var image:Image;
    private var nameLb:Label;
    private var dscLb:Label;
    private var btn:Button;
    private var data:GalleryItemObject;
    private var _sortOrder:int;
    private var _activeOrder:int;

    public function BaseGalleryItem(id:String = "galleryItem", styleName:String = "galleryItem")
    {
        super(id, styleName);
        $setSize(30,200);
        layout.layout = Layout.VERTICAL;
        layout.gap = 5;
        layout.padding = 2;
    }

    override protected function initControls():void
    {
        image = new Image("galleryItemImage");
        image.$setSize("100%", 100);
        image.layout.isEnveloped = true;

        nameLb = new Label("galleryItemName");
        nameLb.$initLabel("100%", 20, Layout.ABSOLUTE, Layout.LEFT, Layout.TOP);
        nameLb.layout.isEnveloped = true;

        dscLb = new Label("galleryItemDescription");
        dscLb.$initLabel("100%", 30, "", Layout.ABSOLUTE, Layout.LEFT, Layout.TOP);
        //dscLb.layout.isSpacer = true;
        dscLb.layout.isEnveloped = true;


        btn = new Button("galleryButton");
        btn.$initButton(50,30,"Click");

        log.debug("INIT NEW " + id);
        addChilds([image, nameLb, dscLb]);
        //addChilds([btn]);
    }

    public function setData(value:GalleryItemObject):void
    {
        data = value;

        image.content = value.imageUrl;
        nameLb.label = value.name;
        dscLb.label = value.dsc;

        layout.isVirtual = value.isVirtual;

        invalidate(InvalidationType.ALL, false, false);

        if(layout.isVirtual) removeChilds();
    }

    public function getData():GalleryItemObject
    {
        return data;
    }

    public function get isVirtual():Boolean {
        return layout.isSpacer;
    }


    public function get sortOrder():int {
        return _sortOrder;
    }

    public function set sortOrder(value:int):void {
        _sortOrder = value;
    }

    public function get activeIndex():int {
        return _activeOrder;
    }

    public function set activeIndex(value:int):void {
        _activeOrder = value;
    }
}
}