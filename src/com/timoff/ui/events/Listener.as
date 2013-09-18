package com.timoff.ui.events {
public class Listener extends Object {

    public var type:String;
    public var listener:Function;
    public var useCapture:Boolean;

    public function Listener( type:String, listener:Function, useCapture:Boolean) {

        this.type = type;
        this.listener = listener;
        this.useCapture = useCapture;
    }

    public function free():void
    {       
        listener = null;   
    }
}
}