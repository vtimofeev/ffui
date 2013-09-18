package com.timoff.ui.events {
import flash.events.Event;

public class DialogEvent extends Event
{
    public static const EVENT_RESULT:String = "result";

    public var result:int;

    public function DialogEvent(type:String, result:int, bubbles:Boolean = false, cancelable:Boolean = true)
    {
        this.result = result;
        super(type, bubbles, cancelable);
    }

    override public function clone():Event {
        return new DialogEvent(type, result, bubbles, cancelable);
    }
}
}