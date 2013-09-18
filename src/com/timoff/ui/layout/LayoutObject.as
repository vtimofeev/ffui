package com.timoff.ui.layout {
import com.timoff.ui.core.FFComponent;

import flash.display.DisplayObject;

public class LayoutObject {


    public var width:Object;
    public var height:Object;

    public var percentWidth:Number = 0;
    public var percentHeight:Number = 0;

    // Paddings
    public var paddingLeft:int = 0;
    public var paddingTop:int = 0;
    public var paddingRight:int = 0;
    public var paddingBottom:int = 0;

    // Gap in hContainers
    public var gap:int = 0;

    // Margins
    public var marginLeft:int = 0;
    public var marginRight:int = 0;
    public var marginTop:int = 0;
    public var marginBottom:int = 0;

    //Tile layout settings
    public var columns:int = 0;
    public var rows:int = 0;
    public var columnWidth:Number;
    public var rowHeight:Number;

    //---------------------------------------------------------------------------------
    // Specific settings
    //---------------------------------------------------------------------------------

    // Gets all free space in container
    public var isSpacer:Boolean = false;
    // Has no visual (draw method is empty)
    public var isVirtual:Boolean = false;
    //
    public var isEnveloped:Boolean = false;
    // Measured if invisible
    public var isMeasuredInvisible:Boolean = true;
    // Sets layout by parent container, if false it always use Absoulte position
    public var isLayable:Boolean = true;
    //
    public var isEnvelopedLabel:Boolean = true;
    // Used only at line layout
    public var isLineFinish:Boolean = false;


    // container layout
    private var _layout:String = Layout.ABSOLUTE;

    // Direction is used by progress bar, slider
    public var direction:String = Layout.HORISONTAL;

    /*
    // custom child layout ( cancel parent layout )
    public var parentLayout:String = null;

    //????
    public var relatedObjectId:String = null;
    //????        
    // layout in absolute layout for UI
    public var relatedObject:DisplayObject;
    */

    // Params are used when align object in absolute containers
    public var hAlign:String = Layout.LEFT;
    public var vAlign:String = Layout.TOP;
    public var hOffset:int = 0;
    public var vOffset:int = 0;

    // Are used to align childs object
    public var contentHAlign:String = Layout.LEFT;
    public var contentVAlign:String = Layout.TOP;

    private var _client:FFComponent;

    public function LayoutObject() {
    }

    public function get client():FFComponent {
        return _client;
    }

    public function set client(value:FFComponent):void {
        _client = value;
    }

    public function set padding(value:int):void
    {
        paddingLeft = paddingRight = paddingTop = paddingBottom = value;
    }

    public function set margin(value:int):void
    {
        marginLeft = marginRight = marginTop = marginBottom = value;
    }

    public function align( hAlign:String, vAlign:String, hOffset:int = 0, vOffset:int = 0):void
    {
        this.hAlign = hAlign;
        this.vAlign = vAlign;
        this.hOffset = hOffset;
        this.vOffset = vOffset;
    }

    public function alignContent( hAlign:String, vAlign:String):void
    {
        this.contentHAlign = hAlign;
        this.contentVAlign = vAlign;
    }

    public function contentAlign( layout:String, hAlign:String = "LEFT", vAlign:String = "TOP"):void {
        this.layout = layout;
        this.contentHAlign = hAlign;
        this.contentVAlign = vAlign;
    }

    public function get layout():String {
        return _layout;
    }

    public function set layout(value:String):void {
        _layout = value;
        if (client) client.invalidateLayout()
    }
}
}
