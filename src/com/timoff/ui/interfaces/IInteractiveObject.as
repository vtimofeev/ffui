package com.timoff.ui.interfaces {
import flash.events.Event;
import flash.events.MouseEvent;

public interface IInteractiveObject
{
    	function mouseOverHandler( event:MouseEvent ):void;
        function mouseOutHandler( event:MouseEvent ):void;
        function mouseDownHandler( event:MouseEvent ):void;
        function mouseUpHandler( event:MouseEvent ):void;
        function clickHandler( event:Event ):void;
}
}