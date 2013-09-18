package com.timoff.ui.controls {
import com.timoff.services.loader.events.LoaderErrorEvent;
import com.timoff.services.loader.events.LoaderEvent;
import com.timoff.services.loader.managers.BasicLoadManager;
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.data.controls.ImageStatus;
import com.timoff.ui.data.core.InvalidationType;
import com.timoff.ui.events.ImageEvent;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;

public class Image extends FFComponent {



    private var _content:String = null;
    private var _contentAtLoading:String = null;
    private var _contentAtFail:String = null;

    private var _status:int = ImageStatus.NONE;
    private var _resizedBd:Object = {};
    private var _loadedBd:BitmapData;

    private var _bitmap:Bitmap;
    public var autoResize:Boolean = true;


    public function Image(id:String = null, styleName:String = null, content:String = null, contentAtLoading:String = null, contentAtFail:String = null) {
        super(id, styleName, Control.IMAGE);
        this.content = content;
    }

    public function get content():String {
        return _content;
    }

    public function set content(value:String):void {
        if(_content==value) return;

        _content = value;
        bitmap = null;
        status = ImageStatus.NONE;
        invalidate(InvalidationType.DATA, false, false);
    }

    public function get contentAtLoading():String {
        return _contentAtLoading;
    }

    public function set contentAtLoading(value:String):void {
        _contentAtLoading = value;
    }

    public function get contentAtFail():String {
        return _contentAtFail;
    }

    public function set contentAtFail(value:String):void {
        _contentAtFail = value;
    }


    public function load():void {
        status = ImageStatus.LOADING;
        //BasicLoadManager.contextLoad(content, loadHandler, loadHandler);
        //@todo : check rewrite
        BasicLoadManager.load(content, loadHandler, loadHandler);
    }

    private function loadHandler(event:LoaderEvent):void {

        if (event is LoaderErrorEvent) {
            status = ImageStatus.LOADED_FAULT;
        }
        else {
            _loadedBd = (event.firstResult.content as Bitmap).bitmapData;
            status = ImageStatus.LOADED_SUCCESS;
        }
        dispatchEvent(new Event(ImageEvent.LOADED));
        $setLaterInvalidate();
    }

    public function get status():int {
        return _status;
    }

    public function set status(value:int):void {
        _status = value;
    }

    public function get resizedBd():Object {
        return _resizedBd;
    }

    public function get loadedBd():BitmapData {
        return _loadedBd;
    }

    public function get bitmap():Bitmap {
        return _bitmap;
    }

    public function set bitmap(value:Bitmap):void {
        _bitmap = value;
        invalidate(InvalidationType.DATA, false, false);
    }
}
}