package com.timoff.ui {
import com.timoff.ui.containers.Window;

public class TestPanel  extends Window {

    public function TestPanel(id:String, styleName:String) {
        super(id, styleName);
        $setSize(400,400);
        title = "Hello world!";
        setButtons(true, null, null, "+", null);
    }
}
}