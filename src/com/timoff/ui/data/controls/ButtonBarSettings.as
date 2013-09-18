/**
 * Author: Vasily
 * Web: http://timoff.com
 * Date: 20.05.11
 * Time: 16:53
 */
package com.timoff.ui.data.controls {
import com.timoff.ui.layout.Layout;

public class ButtonBarSettings {

    public var isRoundedButtons:Boolean = true;
    public var firstButtonRadiuses:Array = [ 5 , 0 , 0 , 5 ];
    public var midButtonRadiuses:Array = [ 0 , 0 , 0 , 0];
    public var endButtonRadiuses:Array = [ 0 , 5 , 5, 0 ];

    public var firstButtonStyleName:String;
    public var midButtonStyleName:String;
    public var endButtonStyleName:String;

    // layout
    private var isItemEnveloped:Boolean = true;
    public var itemWidth:Object = "100%";
    public var itemHeight:Object = 30;
    public var itemPadding:Number = 5;

    // data
    public var labelField:String = "label";
    public var labelFunction:Function;

    public var valueField:String = "value";
    public var valueFunction:Function;

    public var styleNameField:String;


    public function ButtonBarSettings() {
    }

    public function set itemsStyleName(value:String):void {
        firstButtonStyleName = midButtonStyleName = endButtonStyleName = value;
    }
}
}
