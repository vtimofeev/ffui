/**
 * Author: Vasily
 * Web: http://timoff.com
 * Date: 28.05.11
 * Time: 12:50
 */
package com.timoff.ui.data.controls {
import com.timoff.ui.layout.LayoutObject;

public class ContentObject {

    public var content:Object;
    public var layoutObject:LayoutObject;
    public var sizeObject:SizeObject;

    public function ContentObject(content:Object, layoutObject:LayoutObject = null, sizeObject:SizeObject = null) {
        this.content = content;
        this.layoutObject = layoutObject;
        this.sizeObject = sizeObject;
    }
}
}
