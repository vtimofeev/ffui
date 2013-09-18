package com.examples {
import com.timoff.ui.advanced.Base3DGallery;
import com.timoff.ui.advanced.BaseGallery;
import com.timoff.ui.advanced.SimpleGallery;
import com.timoff.ui.advanced.TotalGallery;
import com.timoff.ui.containers.Container;
import com.timoff.ui.containers.HRule;
import com.timoff.ui.containers.Window;
import com.timoff.ui.controls.Button;
import com.timoff.ui.controls.Control;
import com.timoff.ui.controls.Input;
import com.timoff.ui.controls.Label;
import com.timoff.ui.controls.ProgressBar;
import com.timoff.ui.controls.Scroller;
import com.timoff.ui.controls.Slider;
import com.timoff.ui.controls.TextArea;
import com.timoff.ui.controls.ToggleButton;
import com.timoff.ui.controls.inputs.NumericStepper;
import com.timoff.ui.controls.lists.ComboBox;
import com.timoff.ui.controls.lists.List;
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.data.controls.GalleryItemObject;
import com.timoff.ui.data.styles.rectangle.BaseRectangleStyle;
import com.timoff.ui.data.styles.textfield.BaseTextFieldStyle;
import com.timoff.ui.layout.Layout;
import com.timoff.ui.managers.StyleStorageManager;
import com.timoff.ui.managers.TooltipManager;
import com.timoff.ui.styles.StyleObject;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.sampler.getSize;
import flash.utils.Timer;

[SWF(width="800", height="568", frameRate="60")]
public class TestFramework extends Sprite {
   [Embed(source="C:/WINDOWS/Fonts/ARIALN.TTF", fontFamily="ArialNarrow",embedAsCFF="false")]
    public var ArialNarrow:Class;

    private var ffcomp:FFComponent;
    private var fftimer:Timer = new Timer(100);
    private var fflabel:Label;
    private var ffpb:ProgressBar;
    private var ffbtn:Button;
    private var ffsl:Slider;
    private var fftb:ToggleButton;
    private var ffit:Input;

    private var ffcont:Container;
    private var stageCont:Container;
    private var ffcont2:Container;
    private var ffcont3:Container;
    private const ID_CONTAINER:String = "id_container";
    var scr2:Scroller;

    public function TestFramework() {
        super();
        BaseTextFieldStyle.fontFamily = "ArialNarrow";
        //BaseTextFieldStyle['fontFamily'] = "ArialNarrow2";

        StyleStorageManager.init();
        var so:StyleObject = StyleStorageManager.getStateStyleObjectById("default", ID_CONTAINER);
        so.defaultBackgroundStyle.fillColors = [0x00FF00];

        var style:StyleObject = StyleStorageManager.getStateStyleObjectById("default", "g3d");
        style.hasBackground = true;
        style.defaultBackgroundStyle.fillColors = [0x777777, 0xCCCCCC];
        style.defaultBackgroundStyle.lineColors = [0];
        style.defaultBackgroundStyle.lineAlphas = [.1];
        style.defaultBackgroundStyle.roundCorners = 10;
        style.defaultBackgroundStyle.radiusLeftBottom = style.defaultBackgroundStyle.radiusRightBottom = 0;
        //StyleStorageManager.loadJSONStyles('simpleStyle.json')

        //Log.enableTrace = false;
        addEventListeners();
    }

    private function addEventListeners():void {
        this.addEventListener(Event.ADDED_TO_STAGE, stageHandler, false, 0, true);
        fftimer.addEventListener(TimerEvent.TIMER, timerHandler, false, 1, true);
    }

    private function timerHandler(event:TimerEvent):void {
        ffcont.width = Math.random() * 600 + 400;
        BaseRectangleStyle.fillDefaultColors = [ int(0xFFFFFF * Math.random()), int(0xFFFFFF * Math.random()) ];
        BaseRectangleStyle.strokeDefaultColors = [ int(0xFFFFFF * Math.random()), int(0xFFFFFF * Math.random()) ];
        BaseTextFieldStyle.DEFAULT_FONT_COLOR = 0xFFFFFF;

        StyleStorageManager.init();
    }

    private function stageHandler(event:Event):void {

        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.LEFT;

        stage.stageFocusRect = false;
        stage.tabChildren = false;

        this.graphics.beginFill(0xFF0000, 0.5);
        this.graphics.drawRect(0, 0, 1000, 1000);
        this.graphics.endFill();

        tests();
    }

    private function tests():void {
        //baseTest();
        containerTest();
    }

    private function baseTest():void {
        ffcomp = new FFComponent();
        ffcomp.setSize(100, 100);

        fflabel = new Label("fflabel", 'label');
        fflabel.$setSize(1000, 50);
        fflabel.move(100, 0);
        fflabel.label = "Hello world"

        ffbtn = new Button("fflabel", 'label');
        ffbtn.$setSize(100, 50);
        ffbtn.move(100, 100);
        ffbtn.label = "Hello";

        this.addChild(ffcomp);
        this.addChild(fflabel);
        this.addChild(ffbtn);
    }


    private function containerTest():void {
        stageCont = new Container();
        stageCont.$setSize(1000, 1000);

        TooltipManager.registerFacadeStage("default", stageCont);

        ffcont = new Container();
        ffcont.$setSize(600, "100%");
        ffcont.layout.layout = Layout.ABSOLUTE;

        trace("FFC\ONTSize " + getSize(ffcont));

        ffcont2 = new Container("ff2");
        ffcont2.$setSize("100%", "100%");

        ffcont3 = new Container("ff3");
        ffcont3.$setSize("100%", "100%");

        fflabel = new Label("fflabel", 'label');
        fflabel.$setSize(100, 30);
        fflabel.label = "Hello world"

        ffbtn = new Button("fflabel", 'label');
        ffbtn.$setSize(100, 50);
        ffbtn.label = "You";
        ffbtn.layout.align(Layout.CENTER, Layout.MIDDLE, 0, 50);
        ffbtn.addEventListener(MouseEvent.MOUSE_DOWN, clickHandler);

        ffpb = new ProgressBar('', '', Control.PROGRESSBAR);
        ffpb.$setSize(500, 50);
        ffpb.layout.padding = 5;
        ffpb.startValue = 20;
        ffpb.value = 50;
        ffpb.max = 100;
        ffpb.layout.align(Layout.CENTER, Layout.MIDDLE, 0, 0);

        ffsl = new Slider();
        ffsl.$setSize(500, 30);
        ffsl.layout.padding = 10;
        ffsl.value = 50;
        ffsl.layout.align(Layout.CENTER, Layout.MIDDLE, 0, 300);

        fftb = new ToggleButton();
        fftb.$setSize(80, 30);
        fftb.label = "ToggleBtn";
        fftb.layout.align(Layout.CENTER, Layout.MIDDLE, 0, 0);

        ffit = new Input();
        ffit.$setSize(150, 30);
        ffit.label = "ToggleBtn";
        ffit.layout.align(Layout.CENTER, Layout.TOP, 30, 30);

        //ffcont.addChild(fflabel);
        //ffcont.addChild(ffbtn);
        //ffcont.addChild(ffsl);
        //ffcont.addChild(fftb);
        //ffcont2.addChild(ffcont3);
        //ffcont.addChild(ffcont2);

        var ffpanel:Window = new Window("defaultPanel");
        ffpanel.$setSize(400, 300);
        ffpanel.layout.align(Layout.LEFT, Layout.TOP, 100, 100);
        ffpanel.setButtons(true, null, null, "GOOD", null);

        var ffta:TextArea = new TextArea("defaultTa");
        TextArea.$initTextArea(ffta, 300, 300, "Hello world!");

        ffta.layout.align(Layout.LEFT, Layout.TOP, 0, 0);
        trace("FFCONTSize FINISH " + getSize(ffcont));

        var dp:Vector.<GalleryItemObject> = new Vector.<GalleryItemObject>();
        var dp2:Vector.<Object> = new Vector.<Object>();
        for ( var i = 0 ; i < 10 ; i++ )
        {
        //dp.push(new GalleryItemObject(i+ "a",i+ "b",i + "c", "lib://ASSET_bigplay"));
        }
        /*
        dp.push(new GalleryItemObject("1first", "second second sdfsdf sd fsd fsd fsd fsd fssecond second sdfsdf sd fsd fsd fsd fsd fssecond second sdfsdf sd fsd fsd fsd fsd fssecond second sdfsdf sd fsd fsd fsd fsd fssecond second sdfsdf sd fsd fsd fsd fsd fssecond second sdfsdf sd fsd fsd fsd fsd fs", "three", "lib://ASSET_bigplay"));
        dp.push(new GalleryItemObject("2first second second sdfsdf sd fsd fsd fsd fsd fssecond second sdfsdf sd fsd fsd fsd fsd fssecond second sdfsdf sd fsd fsd fsd fsd fs", "second", "three", "lib://ASSET_play"));
        dp.push(new GalleryItemObject("3fisecond second sdfsdf sd fsd fsd fsd fsd fssecond second sdfsdf sd fsd fsd fsd fsd fssecond second sdfsdf sd fsd fsd fsd fsd fsrst", "second second sdfsdf sd fsd fsd fsd fsd fssecond second sdfsdf sd fsd fsd fsd fsd fssecond second sdfsdf sd fsd fsd fsd fsd fssecond", "three", "lib://ASSET_bigplay_over"));
        dp.push(new GalleryItemObject("4firsecond second sdfsdf sd fsd fsd fsd fsd fssecond second sdfsdf sd fsd fsd fsd fsd fssecond second sdfsdf sd fsd fsd fsd fsd fsst", "second", "three", "lib://ASSET_bigplay"));
        dp.push(new GalleryItemObject("5second second sdfsdf sd fsd fsd fsd fsd fssecond second sdfsdf sd fsd fsd fsd fsd fssecond second sdfsdf sd fsd fsd fsd fsd fsfirst", "second", "three", "lib://ASSET_play"));
        //dp.push(new GalleryItemObject("6first", "second", "three", "afisha.jpg"));
        dp.push(new GalleryItemObject("7first", "second", "three", "lib://ASSET_bigplay"));
        dp.push(new GalleryItemObject("8first", "second", "three", "lib://ASSET_play"));
        dp.push(new GalleryItemObject("9first", "second", "three", "lib://ASSET_bigplay_over"));
        dp.push(new GalleryItemObject("10first", "second", "three", "lib://ASSET_bigplay"));
        dp.push(new GalleryItemObject("11first", "second", "three", "lib://ASSET_play"));
        dp.push(new GalleryItemObject("12first", "second", "three", "lib://ASSET_bigplay_over"));
        dp.push(new GalleryItemObject("13first", "second", "three", "lib://ASSET_bigplay"));
        dp.push(new GalleryItemObject("14first", "second", "three", "lib://ASSET_play"));
        dp.push(new GalleryItemObject("15first", "second", "three", "lib://ASSET_bigplay_over"));
        */

        for (var i = 0; i < 42; i++) {

            dp.push(new GalleryItemObject(i + " title ", i + " dsc", i + " extra ", "lib://ASSET_play"));
            dp2.push(new GalleryItemObject(i + " title ", i + " dsc", i + " extra ", "lib://ASSET_play"));
        }

        var fflist:List = new List("theList");
        fflist.setSize(300, 150);
        fflist.layout.align(Layout.CENTER, Layout.TOP, 0, 0);
        fflist.dataProvider = dp2;

        var ffg:BaseGallery = new BaseGallery();
        ffg.$setSize("100%", 200);
        ffg.dataProvider = dp;

        var ff3g:Base3DGallery = new Base3DGallery("g3d");
        ff3g.$setSize(600, 300);
        ff3g.dataProvider = dp;
        ff3g.layout.align(Layout.CENTER, Layout.MIDDLE);
        ff3g.x = 0;
        ff3g.y = 0;

        var sg:SimpleGallery = new SimpleGallery("test_SimpleGallry")
        sg.$setSize(550, 200);
        sg.dataProvider = dp;
        sg.layout.align(Layout.CENTER, Layout.MIDDLE, 0, 150);
        sg.enableMouseControls();

        var scr:Scroller = new Scroller("scr_test");
        scr.client = ff3g;
        scr.$setSize(550, 30);
        scr.layout.align(Layout.CENTER, Layout.MIDDLE, 0, 150);
        scr.prevButton.setSize(30, 30);
        scr.nextButton.setSize(30, 30);

        scr2 = new Scroller();
        scr2.client = fflist;
        scr2.$setSize(30, 500);
        scr2.layout.layout = Layout.VERTICAL;
        scr2.layout.align(Layout.CENTER, Layout.MIDDLE, 0, 0);


        var ffCBox:ComboBox = new ComboBox("_cb");
        ffCBox.$setSize(300, 30);
        ffCBox.layout.align(Layout.CENTER, Layout.TOP, 0, 50);
        ffCBox.dataProvider = dp2;


        var tg:TotalGallery = new TotalGallery("test_TotalGallery");
        tg.$setSize(550, 200);
        //tg.dataProvider = dp;
        tg.layout.align(Layout.CENTER, Layout.MIDDLE, 0, 150);


        //stageCont.addChild(ffpanel);
        ffta.text = "sdfsdfsdf sdf sdf sd \n\n\n\n\n\n\n\nfsf sf s fsdf \n\nfsf sf s fsdf\n\nfsf sf s fsdfs fsfsf sd fs\n\ndf sdf sdf s\n\n\d fsdf sf sf \n\ndf sdf sdf s\n\n\d fsdf sf sf \n\ndf sdf sdf s\n\n\d fsdf sf sf";
        stageCont.addChild(ffta);
        //stageCont.addChild(ffcont);

        scr2.percentAtView = 2;

        var btn:ToggleButton = new ToggleButton();
        btn.$initButton(100, 100, "Set adaptive", clickAdaptHandler);

        //ffcont.addChild(ffg);
        ffcont.addChild(scr);
        ffcont.addChild(scr2);
        ffcont.addChild(btn);
        ffcont.addChild(ff3g);

        //ffcont.addChild(tg);
        ffcont.addChild(fflist);
        ffcont.addChild(ffCBox);
        //ffcont.addChild(ffpb);

        //      ffcont.addChild(ffit);
        var hrule:HRule = new HRule();
        hrule.$setSize(900, 300);

        var c0:* = new Window();
        c0.$setSize(300, 100);

        var c1:Window = new Window();
        c1.$setSize(300, 100);

        var c2:Window = new Window();
        c2.$setSize(300, 100);

        hrule.addChilds([c0, c1, c2]);

        var nstepper = new NumericStepper("ns");
        nstepper.setSize(200, 50);
        nstepper.value = 50;
        nstepper.layout.align(Layout.LEFT, Layout.MIDDLE);
        nstepper.tooltip = "hello pizdous";

       ffcont.addChild(nstepper);
       ffcont.addChild(ffpanel);
        //ffcont.layout.layout = Layout.VERTICAL;
        //var customChild:Label;

        /*
         for(var i = 0; i < 150; i++)
         {
         customChild = new Label(ID_CONTAINER);
         customChild.$setSize( 1 + int(Math.random()*50),  1 + int(Math.random()*50) );
         //customChild.$setSize(110 - i*5, 110 - i*5);
         //customChild.$setSize(10 + i*5, 10 + i*5);
         customChild.label = i;
         ffcont.addChild(customChild);
         }
         */

        this.addChild(stageCont);
        ff3g.$setSize(500, 300);

        stageCont.addChild(ffcont);
        ffcont.addChild(ffit);

        //stageCont.addChild(ff3g);
        //stageCont.addChild(scr);
        //fftimer.start();
        //PopUpManager.createPopUp(stageCont, TestPanel, "popup");
    }

    private function clickAdaptHandler(event:Event):void {
        scr2.isAdaptiveSlider = !scr2.isAdaptiveSlider;
    }

    private function clickHandler(event:Event):void {
        fftb.visible = !fftb.visible;

    }

}
}