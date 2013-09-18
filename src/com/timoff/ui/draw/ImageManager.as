package com.timoff.ui.draw {

import com.timoff.ui.styles.ImageStyleObject;
import com.timoff.utilites.Library;
import flash.display.DisplayObject;

public class ImageManager {


    public function ImageManager() {
    }

    public static function getImage(style:ImageStyleObject):DisplayObject
    {
        if (!style)
            return null;


        if (style.sourceLibname)
            return Library.createDisplayObjectByName(style.sourceLibname);
        else
        {
            if(style.sourceUrl)
            {
                
            }
            else
            {
                // error no image
            }
        }
        return null;
    }
}
}