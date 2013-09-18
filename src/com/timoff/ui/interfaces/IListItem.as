/**
 * Created by IntelliJ IDEA.
 * User: Vasily
 * Date: 04.05.11
 * Time: 10:53
 * To change this template use File | Settings | File Templates.
 */
package com.timoff.ui.interfaces {
public interface IListItem extends IFreeable {

    function setData(value:Object):void;
    function setClickCallback(value:Function):void;
    function getData():Object;

    function get sortOrder():int;
    function set sortOrder(value:int):void;


}
}
