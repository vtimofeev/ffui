/**
 * Author: Vasily
 * Web: http://timoff.com
 * Date: 20.05.11
 * Time: 10:59
 */
package com.examples {
import com.timoff.ui.containers.HContainer;
import com.timoff.ui.controls.Button;
import com.timoff.ui.controls.RadioButton;
import com.timoff.ui.controls.State;
import com.timoff.ui.controls.ToggleButton;
import com.timoff.ui.controls.menus.ButtonBar;
import com.timoff.ui.data.controls.GalleryItemObject;
import com.timoff.ui.layout.Layout;
import com.timoff.ui.managers.StyleStorageManager;
import com.timoff.ui.styles.ImageStyleObject;
import com.timoff.ui.styles.StyleObject;

import flash.events.Event;

public class ButtonComponents extends BaseFramework {

    private static const ID_STYLED_BUTTON:String = "styledButton";
    private static const ID_BUTTON_BAR:String = "buttonBarId";
    private static const BLUE_BUTTON_STYLE:String = "blueButtonStyle";
    private static const SN_DEFAUT_BUTTON:String = "defaultButton";

    private var simpleButton:Button;
    private var toggleButton:ToggleButton;

    private var radioGroupContainer:HContainer;
    private var radioButton0:RadioButton;
    private var radioButton1:RadioButton;
    private var radioButton2:RadioButton;

    private var toggleGroupContainer:HContainer;
    private var toggleButton0:ToggleButton;
    private var toggleButton1:ToggleButton;
    private var toggleButton2:ToggleButton;

    private var styledButton:Button;
    private var styledIconToggleButton:ToggleButton;

    private var buttonBar:ButtonBar;
    private var tabBar:ButtonBar;
    private var vTabBar:ButtonBar;



    public function ButtonComponents() {
        super();
    }

    override protected function initStyles():void {
        super.initStyles();

        var style:StyleObject = StyleStorageManager.getStateStyleObjectById(facadeName, ID_STYLED_BUTTON);
        style.defaultBackgroundStyle.fillColors = [0x777777, 0xCCCCCC];
        style.defaultBackgroundStyle.lineColors = [0];
        style.defaultBackgroundStyle.lineAlphas = [.1];
        style.defaultBackgroundStyle.roundCorners = 10;
        style.defaultBackgroundStyle.radiusLeftBottom = style.defaultBackgroundStyle.radiusRightBottom = 0;
        style.iconStyle = new ImageStyleObject("lib://ASSET_sample_icon");

        var style:StyleObject = StyleStorageManager.getStateStyleObjectById(facadeName, ID_STYLED_BUTTON, State.OVER);
        style.defaultBackgroundStyle.fillColors = [0x333333, 0x999999];
        style.defaultBackgroundStyle.lineColors = [0];
        style.defaultBackgroundStyle.lineAlphas = [.1];
        style.defaultBackgroundStyle.roundCorners = 10;
        style.defaultBackgroundStyle.radiusLeftBottom = style.defaultBackgroundStyle.radiusRightBottom = 0;
        style.iconStyle = new ImageStyleObject("lib://ASSET_sample_icon");

        var style:StyleObject = StyleStorageManager.getStateStyleObjectById(facadeName, ID_STYLED_BUTTON, State.SELECTED_DEFAULT);
        style.defaultBackgroundStyle.fillColors = [0xFF3333, 0xFFCCCC];
        style.defaultBackgroundStyle.lineColors = [0];
        style.defaultBackgroundStyle.lineAlphas = [.1];
        style.defaultBackgroundStyle.roundCorners = 10;
        style.defaultBackgroundStyle.radiusLeftBottom = style.defaultBackgroundStyle.radiusRightBottom = 0;
        style.textfieldStyle.color = 0;
        style.iconStyle = new ImageStyleObject("lib://ASSET_sample_icon");

        var style:StyleObject = StyleStorageManager.getStateStyleObjectById(facadeName, ID_STYLED_BUTTON, State.SELECTED_OVER);
        style.defaultBackgroundStyle.fillColors = [0xFFCCCC, 0xFF0000];
        style.defaultBackgroundStyle.lineColors = [0];
        style.defaultBackgroundStyle.lineAlphas = [.1];
        style.defaultBackgroundStyle.roundCorners = 10;
        style.defaultBackgroundStyle.radiusLeftBottom = style.defaultBackgroundStyle.radiusRightBottom = 0;
        style.textfieldStyle.color = 0;
        style.iconStyle = new ImageStyleObject("lib://ASSET_sample_icon");

        var style:StyleObject = StyleStorageManager.getStateStyleObjectById(facadeName, ID_BUTTON_BAR);
        style.defaultBackgroundStyle.fillColors = [0xFFCCCC, 0xFF0000];
        style.defaultBackgroundStyle.lineColors = [0];
        style.defaultBackgroundStyle.lineAlphas = [.1];
        style.defaultBackgroundStyle.roundCorners = 10;

        var style:StyleObject = StyleStorageManager.getStateStyleObjectByStyleName(facadeName, SN_DEFAUT_BUTTON)
        style.defaultBackgroundStyle.fillColors = [0xCCFFCC, 0x00FF00];
        style.defaultBackgroundStyle.lineColors = [0];
        style.defaultBackgroundStyle.lineAlphas = [.3];
        style.defaultBackgroundStyle.roundCorners = 10;

        var style:StyleObject = StyleStorageManager.getStateStyleObjectByStyleName(facadeName, SN_DEFAUT_BUTTON, State.OVER)
        style.defaultBackgroundStyle.fillColors = [0xFFFFFF, 0x00FF00];
        style.defaultBackgroundStyle.lineColors = [0];
        style.defaultBackgroundStyle.lineAlphas = [.3];
        style.defaultBackgroundStyle.roundCorners = 10;

        var style:StyleObject = StyleStorageManager.getStateStyleObjectByStyleName(facadeName, SN_DEFAUT_BUTTON, State.SELECTED_DEFAULT)
        style.defaultBackgroundStyle.fillColors = [0x66CC66, 0x33CC33];
        style.defaultBackgroundStyle.lineColors = [0];
        style.defaultBackgroundStyle.lineAlphas = [.3];
        style.defaultBackgroundStyle.roundCorners = 10;

        var style:StyleObject = StyleStorageManager.getStateStyleObjectByStyleName(facadeName, SN_DEFAUT_BUTTON, State.SELECTED_OVER)
        style.defaultBackgroundStyle.fillColors = [0xFFFFFF, 0xCCCCCC];
        style.defaultBackgroundStyle.lineColors = [0];
        style.defaultBackgroundStyle.lineAlphas = [.3];
        style.defaultBackgroundStyle.roundCorners = 10;

        var style:StyleObject = StyleStorageManager.getStateStyleObjectByStyleName(facadeName, BLUE_BUTTON_STYLE);
        style.defaultBackgroundStyle.fillColors = [0xCCCCFF, 0x0000FF];
        style.defaultBackgroundStyle.lineColors = [0];
        style.defaultBackgroundStyle.lineAlphas = [.2];
        style.defaultBackgroundStyle.roundCorners = 8;

        var style:StyleObject = StyleStorageManager.getStateStyleObjectByStyleName(facadeName, BLUE_BUTTON_STYLE, State.OVER);
        style.defaultBackgroundStyle.fillColors = [0xDDDDFF, 0x0000FF];
        style.defaultBackgroundStyle.lineColors = [0];
        style.defaultBackgroundStyle.lineAlphas = [.2];
        style.defaultBackgroundStyle.roundCorners = 8;

        var style:StyleObject = StyleStorageManager.getStateStyleObjectByStyleName(facadeName, BLUE_BUTTON_STYLE, State.DOWN);
        style.defaultBackgroundStyle.fillColors = [0x5555FF, 0x0000FF];
        style.defaultBackgroundStyle.lineColors = [0];
        style.defaultBackgroundStyle.lineAlphas = [.5];
        style.defaultBackgroundStyle.roundCorners = 8;


        var style:StyleObject = StyleStorageManager.getStateStyleObjectByStyleName(facadeName, BLUE_BUTTON_STYLE, State.SELECTED_DEFAULT);
        style.defaultBackgroundStyle.fillColors = [0xAAAAFF, 0xAAAAFF];
        style.defaultBackgroundStyle.lineColors = [0];
        style.defaultBackgroundStyle.lineAlphas = [.3];
        style.defaultBackgroundStyle.roundCorners = 8;

        return;
    }

    override protected function tests():void {

        simpleButton = new Button();
        simpleButton.$initButton(100, 30, "Simple button", clickHandler);

        toggleButton = new ToggleButton();
        toggleButton.$initButton(200,30, "Simple toggle button")

        radioGroupContainer = new HContainer();
        radioGroupContainer.$setSize(700, 30);
        radioGroupContainer.layout.gap = 5;

        radioButton0 = new RadioButton(null,SN_DEFAUT_BUTTON,"group0");
        radioButton0.$initButton(150,30, "Radio button 0");

        radioButton1 = new RadioButton(null,SN_DEFAUT_BUTTON,"group0");
        radioButton1.$initButton(150,30, "Radio button 1");

        radioButton2 = new RadioButton(null,null,"group0");
        radioButton2.$initButton(150,30, "Radio button 2");

        radioGroupContainer.addChilds([radioButton0, radioButton1, radioButton2]);

        toggleGroupContainer = new HContainer();
        toggleGroupContainer.$setSize(700, 30);
        toggleGroupContainer.layout.gap = 5;

        toggleButton0 = new ToggleButton(null,null,"group0");
        toggleButton0.$initButton(150,30, "Toggle button 0 in group");

        toggleButton1 = new ToggleButton(null,null,"group0");
        toggleButton1.$initButton(150,30, "Toggle button 1 in group");

        toggleButton2 = new ToggleButton(null,null,"group0");
        toggleButton2.$initButton(150,30, "Toggle button 2 in group");

        toggleGroupContainer.addChilds([toggleButton0, toggleButton1, toggleButton2]);

        styledButton = new Button(ID_STYLED_BUTTON);
        styledButton.$initButton(300,30, "Styled icon button");

        styledIconToggleButton = new ToggleButton(ID_STYLED_BUTTON);
        styledIconToggleButton.$initButton(250,30, "Styled icon toggle button");

        var dp:Vector.<Object> = new Vector.<Object>();
        for (var i = 0; i < 5; i++)
        {
            dp.push(new GalleryItemObject(i + " title", i + " description", i + " extra", "lib://ASSET_play"));
        }

        buttonBar = new ButtonBar(ID_BUTTON_BAR);
        buttonBar.$setSize(520, 50);
        buttonBar.layout.layout = Layout.HORISONTAL;
        buttonBar.settings.itemHeight = 30;
        buttonBar.settings.itemWidth = 100;
        buttonBar.layout.gap = 0;
        buttonBar.layout.padding = 10;
        buttonBar.layout.isEnveloped = true;
        buttonBar.dataProvider = dp;

        tabBar = new ButtonBar();
        tabBar.$setSize(600, 50);
        tabBar.layout.layout = Layout.HORISONTAL;
        tabBar.settings.itemHeight = 30;
        tabBar.settings.itemWidth = 100;
        tabBar.settings.firstButtonRadiuses = tabBar.settings.midButtonRadiuses = tabBar.settings.endButtonRadiuses = [ 10, 10, 0, 0 ];
        tabBar.layout.gap = 5;
        tabBar.layout.isEnveloped = true;
        tabBar.dataProvider = dp;

        vTabBar = new ButtonBar();
        vTabBar.$setSize(200, 500);
        vTabBar.layout.layout = Layout.VERTICAL;
        vTabBar.settings.itemHeight = 30;
        vTabBar.settings.itemWidth = "100%";
        vTabBar.settings.itemsStyleName = BLUE_BUTTON_STYLE;
        vTabBar.settings.firstButtonRadiuses = vTabBar.settings.midButtonRadiuses = vTabBar.settings.endButtonRadiuses = [ 0, 10, 10, 0 ];
        vTabBar.layout.gap = 1;
        vTabBar.layout.isEnveloped = true;
        vTabBar.dataProvider = dp;

        contentContainer.addChilds([simpleButton, toggleButton]);
        contentContainer.addChilds([radioGroupContainer, toggleGroupContainer]);
        contentContainer.addChilds([styledButton, styledIconToggleButton]);
        contentContainer.addChilds([buttonBar,tabBar,vTabBar]);
    }

    private function clickHandler(event:Event):void {
        trace ("ButtonClick + " + event.currentTarget );
    }
}
}
