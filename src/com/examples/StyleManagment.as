/**
 * Author: Vasily
 * Web: http://timoff.com
 * Date: 30.05.11
 * Time: 12:24
 */
package com.examples {
import com.adobe.serialization.json.JSON;
import com.adobe.serialization.json.JSONEncoder;
import com.timoff.ui.managers.StyleStorageManager;

public class StyleManagment  extends BaseFramework {

    [Embed(source="simpleStyle.json", mimeType="application/octet-stream")]
    public var SimpleStyleJsonClass:Class;

    public function StyleManagment() {
    }

    override protected function initStyles():void {
        super.initStyles();
        var stylesStr:Object = new SimpleStyleJsonClass();
        var stylesObject:Object = JSON.decode(stylesStr.toString(), false);
        StyleStorageManager.parseStyle("default", stylesObject);
        trace(stylesObject);
    }

    override protected function tests():void {
        super.tests();
    }
}
}
