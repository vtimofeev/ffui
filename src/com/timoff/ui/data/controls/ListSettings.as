/**
 * Created by IntelliJ IDEA.
 * User: Vasily
 * Date: 04.05.11
 * Time: 11:39
 * To change this template use File | Settings | File Templates.
 */
package com.timoff.ui.data.controls {
public class ListSettings {

    public var useCache:Boolean = false;

    public var itemWidth:Object = "100%";
    public var itemHeight:Object = 30;

    public var itemIsEnveloped:Boolean = false;
    public var itemsAtViewCount:int = -1;

    public var hScrollRule:uint = ScrollRules.OFF;
    public var vScrollRule:uint = ScrollRules.AUTO;

    public var labelField:String = "label";
    public var labelFunction:Function;
    public var valueField:String = "value";
    public var valueFunction:Function;
    public var itemInListRenderer:Class;
    public var itemStyle:String = null;
    public var minusLabel:String = "Custom";



    public function ListSettings() {
    }
}
}
