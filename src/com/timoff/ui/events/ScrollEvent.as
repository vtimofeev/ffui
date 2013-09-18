/**
 * Created by IntelliJ IDEA.
 * User: Vasily
 * Date: 07.04.11
 * Time: 11:03
 * To change this template use File | Settings | File Templates.
 */
package com.timoff.ui.events {
import flash.events.Event;

public class ScrollEvent extends Event {
    public static const EVENT_PREV:String = "event_prev";
    public static const EVENT_NEXT:String = "event_next";

    public static const EVENT_SCROLL_TO:String = "event_scroll_to";
    public var value:Number;

    public function ScrollEvent(name:String, bubbles:Boolean = false, canellable:Boolean = true) {
        super(name, bubbles, cancelable);
    }
}
}
