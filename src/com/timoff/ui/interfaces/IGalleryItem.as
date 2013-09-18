package com.timoff.ui.interfaces {
import com.timoff.ui.data.controls.GalleryItemObject;

public interface IGalleryItem {
    function setData(value:GalleryItemObject):void;

    function getData():GalleryItemObject;

    function get isVirtual():Boolean;

    function get sortOrder():int;

    function set sortOrder(value:int):void;


    function get activeIndex():int;

    function set activeIndex(value:int):void;



}


}