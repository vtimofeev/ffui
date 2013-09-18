package com.timoff.ui.styles {
import com.timoff.ui.types.FillType;
import flash.net.registerClassAlias;

registerClassAlias("com.timoff.ui.styles.ImageStyleObject", ImageStyleObject);
public class ImageStyleObject {
    public var sourceLibname:String = null;
    public var sourceUrl:String = null;
    public var fillType:String = FillType.DEFAULT;

    public function ImageStyleObject(source:String = null, fillType:String = null) {
        if(source) source.indexOf("lib://")==0?this.sourceLibname=source.substr(6):this.sourceUrl=source;
        if(fillType) this.fillType = fillType;
    }
}
}