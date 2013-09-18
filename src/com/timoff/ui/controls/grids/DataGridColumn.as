/**
 * @Author vtimofeev
 */
package com.timoff.ui.controls.grids {
import com.timoff.ui.containers.Container;
import com.timoff.ui.controls.Control;
import com.timoff.ui.controls.Input;
import com.timoff.ui.controls.Label;
import com.timoff.ui.controls.ToggleButton;

public class DataGridColumn extends Container {

    public var editable:Boolean = false;
    public var sortEnable:Boolean = false;
    public var dragEnable:Boolean = false;
    public var resizeEnable:Boolean = false;

    public var defaultCellRenderrer:Class = Label;
    public var defaultCellRenderredSettings:Object;

    public var editCellRenderrer:Class = Input;
    public var editCellRenderredSettings:Object;

    public var cellValueRenderredSettings:Object;
    public var cellValueLabelFunction:Function;

    public var headerRenderrer:Class = ToggleButton;
    public var headerRenderrerSettings:Object;

    public var _sortDirection:Boolean = false;

    public var label:String = '';

    public function DataGridColumn(id:String, style:String = null) {
        super(id, style, Control.DATAGRID_COLUMN);
    }

    override protected function initControls():void {
        super.initControls();
    }
}
}
