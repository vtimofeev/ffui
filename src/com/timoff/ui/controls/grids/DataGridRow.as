/**
 * @Author vtimofeev
 */
package com.timoff.ui.controls.grids {
import com.timoff.ui.containers.Container;
import com.timoff.ui.controls.State;

public class DataGridRow extends Container {
    public function DataGridRow(id:String, styleName:String) {
    }

    override public function get states():Array {
        return [State.DEFAULT, State.OVER, State.SELECTED_DEFAULT, State.SELECTED_OVER, State.DISABLED];
    }
}
}
