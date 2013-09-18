package com.timoff.ui.data.styles {
import com.timoff.ui.data.styles.image.BaseImageStyle;
import com.timoff.ui.data.styles.rectangle.BaseRectangleStyle;
import com.timoff.ui.data.styles.textfield.BaseTextFieldStyle;
import com.timoff.ui.styles.RectangleStyleObject;
import com.timoff.ui.styles.StyleObject;
import flash.net.registerClassAlias;


registerClassAlias("com.timoff.ui.data.styles.BaseStyle", BaseStyle);
public class BaseStyle extends StyleObject{
    public function BaseStyle()
    {
        super(new BaseRectangleStyle(), new BaseTextFieldStyle());
    }
}

}