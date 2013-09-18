/**
 * Author: Vasily
 * Web: http://timoff.com
 * Date: 16.06.11
 * Time: 18:09
 */
package com.timoff.ui.interfaces {
import flash.events.IEventDispatcher;

public interface IScrollerClient extends IEventDispatcher {

    function get max():Number;
    function get min():Number;
    // function get percentAtView():Number;

}
}
