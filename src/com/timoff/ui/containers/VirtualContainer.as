/**
 * @author vasily.timofeev@gmail.com
 */
package com.timoff.ui.containers
{
    import com.timoff.ui.controls.Control;

    public class VirtualContainer extends Container
    {
        public function VirtualContainer(id:String = null, styleName:String = null, type:String = Control.CONTAINER, contentRender:Class = null) {
             super(id, styleName, type, contentRender);

         }

    }
}
