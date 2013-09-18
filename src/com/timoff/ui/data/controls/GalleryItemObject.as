package com.timoff.ui.data.controls {
public class GalleryItemObject extends Object {

    public var name:String = "";
    public var label:String = "";
    public var dsc:String = "";
    public var action:String = "";
    public var imageUrl:String = "";
    public var isVirtual:Boolean = false;

    public function GalleryItemObject(name:String, dsc:String, action:String, imageUrl:String, isVirtual:Boolean = false) {
        this.name = name;
        this.label = name;
        this.dsc = dsc;
        this.action = action;
        this.imageUrl = imageUrl;
        this.isVirtual = isVirtual;
    }

    public function setItem():void
    {

    }
}
}