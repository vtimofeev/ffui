/**
 * Author: Vasily
 * Web: http://timoff.com
 * Date: 19.05.11
 * Time: 13:13
 */
package com.examples {
import com.timoff.ui.controls.Label;
import com.timoff.ui.controls.State;
import com.timoff.ui.layout.Layout;
import com.timoff.ui.managers.StyleManager;
import com.timoff.ui.managers.StyleStorageManager;
import com.timoff.ui.styles.ImageStyleObject;
import com.timoff.ui.styles.StyleObject;


public class SimpleComponents extends BaseFramework {

    private var simpleLabel:Label;
    private var styledLabel:Label;
    private var styledLabelWithAlignContent:Label;

    private var styledLabelWithIcon:Label;
    private var styledLabelWithAlignedIcon:Label;
    private var styledLabelWithLongText:Label;
    private var styledMultilineLabel:Label;

    private const ID_STYLED_LABEL:String = "styledLabel";
    private const ID_STYLED_ICON_LABEL:String = "styledIconLabel";
    private const ID_STYLED_MULTILINE_LABEL:String = "multilineLabel";

    public function SimpleComponents() {
        super();
    }


    override protected function tests():void {
        simpleLabel = new Label();
        simpleLabel.$initLabel(100,30,"Simple Label");
        
        styledLabel = new Label(ID_STYLED_LABEL);
        styledLabel.$initLabel(200,30, "Simple styled label");

        styledLabelWithAlignContent = new Label(ID_STYLED_LABEL);
        styledLabelWithAlignContent.$initLabel(300,30, "Simple styled label with RM aligned content", Layout.HORISONTAL, Layout.RIGHT);

        styledLabelWithIcon = new Label(ID_STYLED_ICON_LABEL);
        styledLabelWithIcon.$initLabel(200,30, "Styled label with icon");
        styledLabelWithIcon.layout.padding = 5;

        styledLabelWithAlignedIcon = new Label(ID_STYLED_ICON_LABEL);
        styledLabelWithAlignedIcon.$initLabel(250,50, "Styled label with simple aligned content");
        styledLabelWithAlignedIcon.layout.contentAlign(Layout.VERTICAL, Layout.CENTER, Layout.MIDDLE);

        styledMultilineLabel = new Label(ID_STYLED_MULTILINE_LABEL);
        styledMultilineLabel.$initLabel(300,100, "Styled multiline label which contains a long long text. Styled multiline label which contains a long long text. Styled multiline label which contains a long long text. Styled multiline label which contains a long long text. Styled multiline label which contains a long long text.Styled multiline label which contains a long long text. Styled multiline label which contains a long long text. Styled multiline label which contains a long long text. Styled multiline label which contains a long long text. Styled multiline label which contains a long long text.Styled multiline label which contains a long long text. Styled multiline label which contains a long long text. Styled multiline label which contains a long long text. Styled multiline label which contains a long long text. Styled multiline label which contains a long long text.");
        styledMultilineLabel.layout.padding = 20;

        styledLabelWithLongText = new Label(ID_STYLED_LABEL);
        styledLabelWithLongText.$initLabel(300,30, "Styled label which contains a long long text. Styled label which contains a long long text. ");
        styledLabelWithLongText.layout.padding = 5;

        contentContainer.addChilds([simpleLabel, styledLabel,styledLabelWithAlignContent, styledLabelWithIcon,styledLabelWithAlignedIcon]);
        contentContainer.addChilds([styledLabelWithLongText, styledMultilineLabel]);
        return;
    }

    override protected function initStyles():void {
        super.initStyles();

        var style:StyleObject;

        style = StyleStorageManager.getStateStyleObjectById(facadeName, ID_STYLED_LABEL);
        style.defaultBackgroundStyle.fillColors = [0xFF0000, 0x00FF00];
        style.textfieldStyle.color = 0;

        style = StyleStorageManager.getStateStyleObjectById(facadeName, ID_STYLED_ICON_LABEL);
        style.defaultBackgroundStyle.fillColors = [0xCCCCCC, 0xFFFFFF];
        style.defaultBackgroundStyle.lineColors = [0];
        style.defaultBackgroundStyle.lineAlphas = [.5];
        style.defaultBackgroundStyle.roundCorners = 10;
        style.defaultBackgroundStyle.radiusLeftBottom = style.defaultBackgroundStyle.radiusRightBottom = 0;

        style.textfieldStyle.color = 0;
        style.textfieldStyle.fontSize = 15;

        style.iconStyle = new ImageStyleObject("lib://ASSET_sample_icon");

        style = StyleStorageManager.getStateStyleObjectById(facadeName, ID_STYLED_MULTILINE_LABEL);
        style.textfieldStyle.color = 0;
        style.textfieldStyle.multiline = true;
    }
}
}
