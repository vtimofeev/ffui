/**
 * @Author vtimofeev
 */
package com.timoff.ui.controls.grids {
import com.timoff.ui.controls.Control;
import com.timoff.ui.core.FFComponent;

import flash.utils.Dictionary;

public class DataGrid extends FFComponent {

    private var _dataProvider:Vector.<*>;

    private var _columns:Array = [];
    private var _sortedColumns:Array = [];

    private var _rows:Array;

    private var rowsAtView:Dictionary = new Dictionary(true);
    private var rowsAtCache:Dictionary = new Dictionary(true);

    private var _selectedItems:Array;


    public function DataGrid(id:String, style:String = null) {
        super(id, style, Control.DATAGRID);
    }

    public function set columns(value:Array):void {
    }

    public function addColumn(value:*):void {
    }

    public function swapColumns(index1:uint, index2:uint):void {
    }

    public function deleteColumn(value:*):void {
    }

    public function set dataProvider(value:Vector.<*>):void {
        _dataProvider = value;
    }

    public function get dataProvider():Vector.<*> {
        return _dataProvider;
    }


}
}
