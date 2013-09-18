package com.timoff.ui.core
{
import com.timoff.services.log.Log;
import com.timoff.ui.containers.Container;
import com.timoff.ui.controls.Control;
import com.timoff.ui.controls.Input;
import com.timoff.ui.controls.State;
import com.timoff.ui.controls.lists.List;
import com.timoff.ui.data.core.InvalidationType;
import com.timoff.ui.effects.EffectObject;
import com.timoff.ui.events.FFComponentEvent;
import com.timoff.ui.events.Listener;
import com.timoff.ui.interfaces.IInteractiveObject;
import com.timoff.ui.layout.Layout;
import com.timoff.ui.layout.LayoutObject;
import com.timoff.ui.managers.EffectManager;
import com.timoff.ui.managers.LayoutManager;
import com.timoff.ui.managers.StateManager;
import com.timoff.ui.managers.StyleManager;
import com.timoff.ui.managers.TooltipManager;
import com.timoff.ui.styles.StyleObject;
import com.timoff.utilites.NameUtils;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.geom.Rectangle;
import flash.utils.Timer;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

public class FFComponent extends Sprite
    {
        //--------------------------------
        // Common
        //--------------------------------

        public static const FACADE_NAME:String = "FFUI";
        public static const VERSION:String = "1.";

        //--------------------------------
        // items to collect statistic
        //--------------------------------
        private static var perfomanceTimer:Timer = new Timer(2500, 0);
        private static var __ffcomponentsCounter:Number = 0;
        private static var __ffcomponentsFreeCounter:Number = 0;
        private static var __ffcomponentsChangeStateCounter:Number = 0;
        private static var __ffcomponentsDrawCounter:Number = 0;
        public static var ffcomponentDrawImageCount:Number = 0;
        public static var ffcomponentDrawRectanglesCount:Number = 0;
        public static var ffcomponentDrawTextfieldCount:Number = 0;

        //--------------------------------
        // event statistic listeners collections
        //--------------------------------
        public static var listenersCounter:Number = 0;
        public static var stageListenersCounter:Number = 0;

        //--------------------------------
        // draw flags
        //--------------------------------
        protected static var FLAG_DRAW_NULL:uint = 1;
        protected static var FLAG_DRAW_HITAREA:uint = 2;
        protected static var FLAG_DRAW_BACKGROUND:uint = 4;
        protected static var FLAG_DRAW_CONTENT:uint = 8;
        protected static var FLAG_DRAW_FOCUS:uint = 16;
        protected static var FLAG_ALIGN_CONTENT:uint = 32;
        protected static var FLAG_ARRANGE_CHILDS:uint = 64;

        //--------------------------------
        // global object managers
        //--------------------------------

        private var _stateManager:StateManager;
        private var _styleManager:StyleManager;
        private var _effectManager:EffectManager;

        //--------------------------------
        // common properties ( unique, style, facade ... etc )
        //--------------------------------
        {

            private var _id:String;
            private var _type:String;
            private var _styleName:String;
            private var _facadeId:String = 'default';
            private var _tooltip:String;

        }
        //--------------------------------
        // size  & rotation properties
        //--------------------------------
        {

            private var _width:Number;
            private var _height:Number;
            private var _x:Number;
            private var _y:Number;

            private var _maxWidth:Number;
            private var _maxHeight:Number;

            private var _minWidth:Number;
            private var _minHeight:Number;

            private var _rotationX:Number;
            private var _rotationY:Number;
            private var _rotationZ:Number;

        }
        //--------------------------------
        // internal properties
        //--------------------------------

        protected var _contentRenderer:Class;
        protected var _containerChilds:Array;

        //--------------------------------
        // runtime properties
        //--------------------------------
        {

            public var lastLayoutResult:Array;
            // draw stat
            public var drawCounter:int = 0;

            // draw settings collection (contains bit flags)
            protected var drawFlags:uint = 0;

            // state container
            private var _stateName:String = State.DEFAULT;
            private var _layoutRectangle:Rectangle = new Rectangle();
            private var _startZIndex:int = 0;

            //inalidation
            private var _delayedInvalidateInterval:int = 0;
            private var _laterInvalidateFlag:Boolean = false;
            private var _inCallLaterPhase:Boolean = false;

            //private var callLaterMethods:Dictionary = new Dictionary(false);
            private var invalidHash:Object = new Object();

            // Interactivity
            private var _enabled:Boolean = true;
            private var _isFocused:Boolean = false;

        }
        //--------------------------------
        // Free properties & event listeners
        //--------------------------------

        private var _listeners:Vector.<Listener>;
        private var _stageListeners:Vector.<Listener>;
        private var _isFreeable:Boolean = true;

        //--------------------------------
        // Layout
        //--------------------------------

        protected var _currentStateBackgroundObject:Sprite;
        protected var _currentStateObject:Sprite;
        protected var _hitAreaObject:Sprite;

        //--------------------------------
        // Propeties collections intances
        //--------------------------------

        private var _enableEvents:Boolean = true;

        private var _layout:LayoutObject = new LayoutObject();
        //private var _effect:EffectObject = null;
        //private var effectsQueue:Array = [];
        private var isDrawLater:Boolean = false;

        public function FFComponent(id:String = null, styleName:String = null, type:String = Control.FFCOMPONENT, contentRender:Class = null, layout:String = Layout.ABSOLUTE, isVirtual:Boolean = false)
        {
            initEventListners();
            super();

            __ffcomponentsCounter++;
            _id = id ? id : NameUtils.createUniqueName(this);

            _styleName = styleName;
            _type = type;
            _contentRenderer = contentRender;

            // dont create any managers if object is virtual,
            // common of groups must be virtual objects
            if (!isVirtual)
            {
                _currentStateObject = new Sprite();
                _currentStateBackgroundObject = new Sprite();

                _stateManager = new StateManager(this);
                _styleManager = new StyleManager(this);
                _effectManager = new EffectManager(this);
            }

            // @todo: check when we need to _containerChilds
            _containerChilds = new Array();

            super.addChild(_currentStateBackgroundObject);
            _startZIndex++;

            super.addChild(_currentStateObject);
            _startZIndex++;

            if (!this is Input)
            {
                _currentStateObject.mouseChildren = false;
            }

            _currentStateBackgroundObject.mouseChildren = false;

            if (this is IInteractiveObject || this is List)
            {
                // todo : rewrite hit area for masking
                _hitAreaObject = new Sprite();
                super.addChild(_hitAreaObject);
                _startZIndex++;
            }

            _layout.client = this;
            invalidateSize();
            addEventListeners();
        }

        //--------------------------------
        // COMMON getters/setters
        //--------------------------------
        {

            public function get id():String
            {
                return _id;
            }

            public function set id(id:String):void
            {
                _id = id;
                updateStyles();
            }

            public function get facadeId():String
            {
                return _facadeId;
            }

            public function set facadeId(value:String):void
            {
                if (_facadeId == value) return;

                const oldFacadeId:String = _facadeId;
                _facadeId = value;

                for each (var ffchild:FFComponent in ffchilds)
                {
                    ffchild.facadeId = value;
                }

                if (_tooltip)
                {
                    TooltipManager.registerTooltip(oldFacadeId, this, _tooltip, null);
                    TooltipManager.registerTooltip(facadeId, this, null, _tooltip);
                }

                updateStyles();
            }

            // must be overrided in components that's extended
            public function get states():Array
            {
                return [State.DEFAULT];
            }

            public function get styleName():String
            {
                return _styleName;
            }

            public function set styleName(value:String):void
            {
                _styleName = value;
                invalidateStyle();
            }

            public function get style():StyleObject
            {
                return _styleManager.getStyle();
            }

            public function get layout():LayoutObject
            {
                return _layout;
            }

            public function get stateManager():StateManager
            {
                return _stateManager;
            }

            public function get effectManager():EffectManager
            {
                return _effectManager;
            }

            public function get state():String
            {
                return _stateName;
            }


            public function set state(value:String):void
            {
                log.debug("Set state:" + id + " , " + value + " , current " + _stateName);

                if (value == _stateName)
                    return;

                __ffcomponentsChangeStateCounter++;
                _stateName = value;


                //if (effectManager) effectManager.changeStateHandler(getStateChangeEffect(value, _stateName));
                /*
                if (effectManager.currentEffects)
                    if (!effectManager.currentEffects.isFinished)
                        return;
                if (_effectNext && effectManager.currentEffects)
                {
                    if (!effectManager.currentEffects.isFinished) effectManager.currentEffects.finish();
                }
                effectManager.currentEffects = _effectNext;

                __ffcomponentsChangeStateCounter++;
                _stateName = value;
                if (effectManager.currentEffects)
                {
                    effectManager.currentEffects.finishFunction = invalidateState;
                    effectManager.currentEffects.start();
                    return;
                }
                */

                invalidateState();
            }

            private function getStateChangeEffect(newState:String, oldState:String):String
            {
                if (newState == State.OVER && oldState == State.DEFAULT)
                    return FFComponentEvent.EVENT_CHANGE_STATE_OVER;
                if (newState == State.DEFAULT && oldState == State.OVER)
                    return FFComponentEvent.EVENT_CHANGE_STATE;

                return null;
            }

            public function set enabled(value:Boolean):void
            {
                if (value == _enabled)
                {
                    return;
                }
                _enabled = value;

                state = (_enabled) ? State.DEFAULT : State.DISABLED;
                invalidate(InvalidationType.STATE, false, false);
                return;
            }

            public function get enabled():Boolean
            {
                return _enabled;
            }


            public function get type():String
            {
                return _type;
            }

            public function get tooltip():String
            {
                return _tooltip;
            }

            public function set tooltip(value:String):void
            {
                var oldValue:String = _tooltip;
                _tooltip = value;

                TooltipManager.registerTooltip(facadeId, this, oldValue, value);
                dispatchEvent(new Event(FFComponentEvent.EVENT_CHANGE_TOOLTIP));
            }
        }
        //--------------------------------
        //
        // SIZE/POSITIONS getters/setters
        //
        //--------------------------------
        {
            override public function get width():Number
            {
                var result:Number;
                const layoutPercentWidth:Number = layout.percentWidth;

                if (layout.percentWidth == 0)
                {
                    result = _width;
                }
                else
                {
                    if (parent is FFComponent)
                        result = (layoutPercentWidth * FFComponent(parent).contentWidth / 100) - layout.marginLeft - layout.marginRight;
                    else
                    if (parent is DisplayObject)
                        result = layoutPercentWidth * parent.width / 100;
                }

                if (!isNaN(maxWidth)) result = result > maxWidth ? maxWidth : result;
                if (!isNaN(minWidth)) result = result < minWidth ? minWidth : result;

                return result;
            }

            override public function set width(value:Number):void
            {
                _width = value;
                invalidateSize();
            }

            final public function set $width(value:Object):void
            {
                if (value is Number || value is int)
                {
                    if (!isNaN(maxWidth)) value = value > maxWidth ? maxWidth : value;
                    if (!isNaN(minWidth)) value = value < minWidth ? minWidth : value;

                    _width = value as Number;
                    layout.percentWidth = 0;
                }
                else
                {
                    value = String(value).replace('%', '');
                    layout.percentWidth = Number(value);
                }

                invalidateSize();
                return;
            }


            override public function get height():Number
            {
                var result:Number;
                const layoutPercentHeight:Number = layout.percentHeight;

                if (layoutPercentHeight == 0)
                {
                    result = _height;
                }
                else
                {
                    if (parent is FFComponent)
                        result = (layoutPercentHeight * FFComponent(parent).contentHeight / 100) - layout.marginTop - layout.marginBottom;
                    else
                    if (parent is DisplayObject)
                        result = layoutPercentHeight * parent.height / 100;
                }

                if (!isNaN(maxHeight)) result = result > maxHeight ? maxHeight : result;
                if (!isNaN(minHeight)) result = result < minHeight ? minHeight : result;
                return result;
            }

            override public function set height(value:Number):void
            {
                _height = value;
                invalidateSize();
            }

            final public function set $height(value:Object):void
            {
                if (value is Number || value is int)
                {
                    layout.percentHeight = 0;
                    _height = value as Number;
                }
                else
                {
                    value = String(value).replace('%', '');
                    layout.percentHeight = Number(value);
                }
                invalidateSize();
                return;
            }

            final public function $setSize(width:Object, height:Object):void
            {
                $width = width;
                $height = height;
                return;
            }

            public function get contentWidth():Number
            {
                return width - layout.paddingLeft - layout.paddingRight;
            }

            public function get contentHeight():Number
            {
                return height - layout.paddingTop - layout.paddingBottom;
            }

            protected function isInvalid(property:String, ...properties:Array):Boolean
            {
                if (invalidHash[property] || invalidHash[InvalidationType.ALL])
                {
                    return true;
                }
                while (properties.length > 0)
                {
                    if (invalidHash[properties.pop()])
                    {
                        return true;
                    }
                }
                return false
            }


            protected function alignContent(content:DisplayObject):void
            {
                if (!content) return;
                content.x = layout.paddingLeft + content.x;
                content.y = layout.paddingTop + content.y;
            }


            public function move(x:Number, y:Number):void
            {
                _x = x;
                _y = y;
                super.x = Math.round(x);
                super.y = Math.round(y);
                dispatchEvent(new Event(FFComponentEvent.EVENT_MOVE));
            }

            public final function $setRotation(x:Number = 0, y:Number = 0, z:Number = 0):void
            {
                rotationX = x;
                rotationY = y;
                rotationZ = z;
            }

            public function setEffect(event:String, effect:EffectObject, data:Object = null):void
            {
                _effectManager.setEffect(event, effect, data);
            }

            override public function get rotationX():Number
            {
                return _rotationX;
            }

            override public function set rotationX(value:Number):void
            {
                _rotationX = value;
                super.rotationX = value;
            }

            override public function get rotationY():Number
            {
                return _rotationY;

            }

            override public function set rotationY(value:Number):void
            {
                _rotationY = value;
                super.rotationY = value;
            }

            override public function get rotationZ():Number
            {
                return _rotationZ;
            }

            override public function set rotationZ(value:Number):void
            {
                _rotationZ = value;
            }


            protected function getScaleY():Number
            {
                return super.scaleY;
            }

            protected function setScaleY(value:Number):void
            {
                super.scaleY = value;
            }

            protected function getScaleX():Number
            {
                return super.scaleX;
            }

            protected function setScaleX(value:Number):void
            {
                super.scaleX = value;
            }

            public function setSize(width:Number, height:Number):void
            {
                if (width == _width && height == _height) return;

                _width = width;
                _height = height;

                invalidate(InvalidationType.SIZE, false, false);
                dispatchEvent(new Event(FFComponentEvent.RESIZE, false));
            }


            public function get maxWidth():Number
            {
                return _maxWidth;
            }

            public function set maxWidth(value:Number):void
            {
                _maxWidth = value;
                invalidate(InvalidationType.SIZE, false, false);
            }

            public function get maxHeight():Number
            {
                return _maxHeight;
            }

            public function set maxHeight(value:Number):void
            {
                _maxHeight = value;
                invalidate(InvalidationType.SIZE, false, false);
            }

            public function get minWidth():Number
            {
                return _minWidth;
            }

            public function set minWidth(value:Number):void
            {
                _minWidth = value;
                invalidate(InvalidationType.SIZE, false, false);
            }

            public function get minHeight():Number
            {
                return _minHeight;
            }

            public function set minHeight(value:Number):void
            {
                _minHeight = value;
                invalidate(InvalidationType.SIZE, false, false);
            }

            public function get layoutRectangle():Rectangle
            {
                return _layoutRectangle;
            }

            public function set layoutRectangle(value:Rectangle):void
            {
                _layoutRectangle = value;
            }
        }


        //-----------------------------------------------------------------------------------------------------------------
        //
        // Child Management
        //
        //-----------------------------------------------------------------------------------------------------------------
        {
            public function get childs():Array
            {
                var result:Array = new Array();
                try
                {
                    for (var i:int = 0; i < this.numChildren; i++)
                    {
                        result.push(this.getChildAt(i));
                    }
                }
                catch (error:Error)
                {
                    return null;
                }

                return result;
            }

            public function get ffchilds():Array
            {
                var result:Array = new Array();
                try
                {
                    for (var i:int = 0; i < this.numChildren; i++)
                    {
                        if (this.getChildAt(i) is FFComponent)
                            result.push(this.getChildAt(i));
                    }
                }
                catch (error:Error)
                {
                    return null;
                }

                return result;
            }

            public function updateChilds():void
            {
                if (_inCallLaterPhase)
                    drawNow();
                else
                    invalidate(InvalidationType.SIZE, true, false, false);
                return;
            }

            protected function updateParent():void
            {
                if (parent is FFComponent)
                {
                    FFComponent(parent).$setLaterInvalidate();
                }
                return;
            }

            public function updateLayout():void
            {
                lastLayoutResult = LayoutManager.arrange(this, _containerChilds, true);
                const childsLength:int = _containerChilds.length;

                for (var i = 0; i < childsLength; i++)
                {
                    if (_containerChilds[i] is FFComponent) FFComponent(_containerChilds[i]).layoutRectangle = lastLayoutResult[i];
                }
                return;
            }

            protected function updateContainer():void
            {
                var result:Array = LayoutManager.arrange(this, _containerChilds, true);
                var child:DisplayObject
                var i:int = 0;

                for each(child in  _containerChilds)
                {
                    if (child is FFComponent)
                    {
                        FFComponent(child).layoutRectangle = result[i];
                        FFComponent(child).updateChilds();
                    }
                    i++;
                }
                return;
            }


            public function get containerChilds():Array
            {
                return _containerChilds;
            }

            override public function addChild(child:DisplayObject):DisplayObject
            {
                beforeAddChild(child);
                _containerChilds.push(child);
                invalidate(InvalidationType.CHILDS, false, false);
                return super.addChild(child);
            }

            override public function addChildAt(child:DisplayObject, index:int):DisplayObject
            {
                if (index < 0 || (index >= _containerChilds.length && index != 0))
                    throw new Error("Logical index " + index + " out of bounds container childs");

                var childDepthIndexAtIndex:int = containerChilds.length > index ? getChildIndex(_containerChilds[index]) : -1;
                if (childDepthIndexAtIndex < 0) return null;

                beforeAddChild(child);
                _containerChilds.splice(index, 0, child);
                invalidate(InvalidationType.CHILDS, false, false);
                return super.addChildAt(child, childDepthIndexAtIndex);
            }

            /*
             override public function getChildIndex(child:DisplayObject):int {
             return _containerChilds.indexOf(child);
             }
             */

            public function bringChildUp(child:DisplayObject):void
            {
                if (!child) return;

                if (child.parent != this) return;
                const currentIndex:int = super.getChildIndex(child);
                if (currentIndex < (numChildren - 1)) swapChildrenAt(currentIndex, currentIndex + 1);
            }

            public function bringChildDown(child:DisplayObject):void
            {
                if (!child) return;
                if (child.parent != this) return;

                const currentIndex:int = super.getChildIndex(child);
                if (currentIndex > _startZIndex) swapChildrenAt(currentIndex, currentIndex - 1);
            }

            override public function removeChild(child:DisplayObject):DisplayObject
            {
                var indexOfChild:int = _containerChilds.indexOf(child);

                if (indexOfChild < 0)
                {
                    if (this.contains(child))
                    {
                        return super.removeChild(child);
                    }
                    else
                        return null;
                }

                if (child is FFComponent)
                {
                    FFComponent(child).free();
                }

                _containerChilds.splice(indexOfChild, 1);
                invalidate(InvalidationType.CHILDS, false, false);
                return super.removeChild(child);
            }

            override public function removeChildAt(index:int):DisplayObject
            {
                if (index < 0 || (index >= _containerChilds.length && index != 0))
                    throw new Error("Logical index " + index + " out of bounds container childs");

                return removeChild(_containerChilds.length > index ? _containerChilds[index] as DisplayObject : null);
            }

            public function removeChilds():void
            {
                var child:DisplayObject;
                for each(child in _containerChilds)
                {
                    super.removeChild(child);
                }
                _containerChilds = [];
                invalidate(InvalidationType.CHILDS, false, false);
            }

            private function beforeAddChild(child:DisplayObject):void
            {
                var ffchild:FFComponent = child as FFComponent;
                if (ffchild)
                {
                    if (ffchild.facadeId != this.facadeId && ffchild.facadeId == 'default')
                    {
                        ffchild.facadeId = this.facadeId;
                    }
                }
                return;
            }
        }
        //-----------------------------------------------------------------------------------------------------------------
        //
        // STYLE MANAGEMENT AREA
        //
        //-----------------------------------------------------------------------------------------------------------------
        {
            public function getStyle(value:String):Object
            {
                return _styleManager.getStyle(value);
            }

            public function setStyle(name:String, value:Object):void
            {
                _stateManager.setStyle(name, value);
                invalidate(InvalidationType.STYLES, false, false);
            }

            public function setStyleProperty(name:String, value:Object, state:String = null)
            {
                _styleManager.setStyleProperty(name, value);
                invalidate(InvalidationType.STYLES, false, false);
            }

            public function updateStyles():void
            {
                _styleManager.update();
                invalidate(InvalidationType.STYLES, false, false);
            }

            public function setStyleToAllStates(style:String, prop:String, value:Object):void
            {
                _styleManager.setStylePropertyToAllStates(style, prop, value);
            }


        }

        //-----------------------------------------------------------------------------------------------------------------
        //
        // Event Handlers & Advanced Handler Engine AREA
        //
        //-----------------------------------------------------------------------------------------------------------------
        {
            public function set enableEvents(value:Boolean):void
            {
                _enableEvents = value;
            }


            private function initEventListners()
            {
                if (!_listeners) _listeners = new Vector.<Listener>();
                if (!_stageListeners) _stageListeners = new Vector.<Listener>();
            }

            // to override
            protected function addEventListeners():void
            {

            }

            override public function dispatchEvent(event:Event):Boolean
            {
                return _enableEvents ? super.dispatchEvent(event) : false;
            }

            override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
            {
                listenersCounter++;
                super.addEventListener(type, listener, useCapture, priority, useWeakReference);
                _listeners.push(new Listener(type, listener, useCapture));
            }

            override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
            {
                const listenersLength:int = _listeners.length;
                var _listener:Listener;


                for (var i:int = 0; i < listenersLength; i++)
                {
                    _listener = _listeners[i];
                    if (_listener.type == type && _listener.listener == listener)
                    {
                        super.removeEventListener(_listener.type, _listener.listener, _listener.useCapture);
                        _listeners.splice(i, 1);
                        _listener.free();
                        listenersCounter--;
                        return;
                    }
                }
                return;
            }

            public function addStageEventListener(type:String, listener:Function, stage:Stage = null, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false)
            {
                var _stage:Stage;
                _stage = stage ? stage : this.stage;

                if (_stage)
                {
                    _stage.addEventListener(type, listener, useCapture, priority, useWeakReference);
                    _stageListeners.push(new Listener(type, listener, useCapture));
                    stageListenersCounter++;
                }
                else
                {
                    // throw new Error("FFC: " + id + " has no stage to add listener " + type);
                }
            }

            public function removeStageEventListener(type:String, listener:Function):Boolean
            {
                const stageListenersCount:int = _stageListeners.length;

                var _listener:Listener;
                for (var i:int = 0; i < stageListenersCount; i++)
                {
                    _listener = _stageListeners[i];

                    if (_listener.type == type && _listener.listener == listener)
                    {
                        this.stage.removeEventListener(_listener.type, _listener.listener, _listener.useCapture);
                        _stageListeners.splice(i, 1);
                        _listener.free();
                        stageListenersCounter--;
                        return true;
                    }
                }
                return false;
            }

            public function set isFreeable(value:Boolean):void
            {
                _isFreeable = value;
            }


        }
        //---------------------------------------------------------------------------------
        //
        // DRAW METHODS AREA
        //
        //---------------------------------------------------------------------------------
        {

            protected function draw():void
            {
                //log.debug("FFC:: Draw::" + id + ", " + this.width + "  , " + this.height + " , " + drawFlags.toString(2));
                //trace("FFC:: Draw::" + id + ", " + this.width + "  , " + this.height + " , " + drawFlags.toString(2));

                var isContentSizeChanged:Boolean = false;

                if (drawFlags & FLAG_DRAW_HITAREA && this is IInteractiveObject)
                {
                    if (_hitAreaObject.width != this.width)
                    {
                        var replacedArea:DisplayObject = stateManager.getHitArea();
                        replaceContent(_hitAreaObject, replacedArea);
                    }
                }

                if (layout.isVirtual)
                {
                    clearContainer(_currentStateBackgroundObject);
                    return;
                }

                drawCounter++;
                __ffcomponentsDrawCounter++;

                if (drawFlags & FLAG_ARRANGE_CHILDS)
                {
                    updateLayout();
                }

                if (drawFlags & FLAG_DRAW_CONTENT && !(this is Container))
                {
                    if (!layout.isEnveloped)
                    {
                        replaceContent(_currentStateObject, stateManager.getContentState());
                    }
                    else
                    {
                        var content:DisplayObject = stateManager.getContentState();
                        var current:DisplayObject = _currentStateObject.numChildren ? _currentStateObject.getChildAt(0) : null;

                        if (current)
                        {
                            isContentSizeChanged = int(current.width) == int(content.width) && int(current.height) == int(content.height) ? false : true;
                        }

                        if (!current || isContentSizeChanged)
                        {
                            replaceContent(_currentStateObject, stateManager.getContentState());
                        }
                    }
                }

                if (drawFlags & FLAG_ALIGN_CONTENT)
                {
                    var content:DisplayObject = _currentStateObject.numChildren ? _currentStateObject.getChildAt(0) : null;
                    alignContent(content);
                }

                if (drawFlags & FLAG_DRAW_BACKGROUND)
                {
                    replaceContent(_currentStateBackgroundObject, stateManager.getBackgroundState());
                }

                // Updates an enveloped component parent object
                if (parent is FFComponent && isContentSizeChanged)
                {
                    FFComponent(parent).invalidateByChild(InvalidationType.SIZE)
                }

                drawFlags = 0;
                laterInvalidateFlag = false;

                if (isInvalid(InvalidationType.SIZE)) resizeHandler();

                if (isInvalid(InvalidationType.SIZE, InvalidationType.STYLES))
                {
                    if (_isFocused)
                    {
                        drawFocus(true);
                    }
                }

                validate();
                //dispatchEvent(new Event(Event.RENDER));
            }

            // could be overrided
            public function resizeHandler():void {
            }

            public function drawNow():void
            {
                draw();
            }

            private function drawFocus(value:Boolean):void
            {
                // todo enable focus
            }

        }

        //-----------------------------------------------------------------------------------------------------------------
        //
        // INVALIDATION AREA
        //
        //-----------------------------------------------------------------------------------------------------------------
        {

            private final function invalidateState():void
            {
                invalidate(InvalidationType.STATE, false, false);
            }


            public function get laterInvalidateFlag():Boolean
            {
                return _laterInvalidateFlag;
            }

            public function set laterInvalidateFlag(value:Boolean):void
            {
                _laterInvalidateFlag = value;
            }


            /**
             * @private (protected)
             *
             * @langversion 3.0
             * @playerversion Flash 9.0.28.0
             */
            protected function validate():void
            {
                invalidHash = {};
            }

            /**
             * UIComponent CallLater
             */
            protected function callLater(fn:Function):void
            {
                if (_inCallLaterPhase)
                {
                    return;
                }

                isDrawLater = true;
                if (stage)
                {
                    stage.addEventListener(Event.EXIT_FRAME, callLaterDispatcher, false, 0, true);
                    stage.invalidate();
                } else
                {
                    addEventListener(Event.ADDED_TO_STAGE, callLaterDispatcher, false, 0, true);
                }
            }

            /**
             * UIComponent CallLater
             */
            private function callLaterDispatcher(event:Event):void
            {

                if (event.type == Event.ADDED_TO_STAGE)
                {
                    removeEventListener(Event.ADDED_TO_STAGE, callLaterDispatcher);
                    // now we can listen for render event:
                    stage.addEventListener(Event.EXIT_FRAME, callLaterDispatcher, false, 0, true);
                    //stage.dispatchEvent(new Event(Event.EXIT_FRAME));
                    //stage.invalidate();

                    return;
                } else
                {
                    event.target.removeEventListener(Event.EXIT_FRAME, callLaterDispatcher);
                    if (stage == null)
                    {
                        // received render, but the stage is not available, so we will listen for addedToStage again:
                        addEventListener(Event.ADDED_TO_STAGE, callLaterDispatcher, false, 0, true);
                        return;
                    }
                }

                _inCallLaterPhase = true;
                draw();
                isDrawLater = false;
                _inCallLaterPhase = false;
                /*
                for (var method:Object in callLaterMethods)
                {
                    method();
                    delete(callLaterMethods[method]);
                }
                */
            }


            public final function $setLaterInvalidate():void
            {
                laterInvalidateFlag = true;
                if (_delayedInvalidateInterval) clearTimeout(_delayedInvalidateInterval);
                _delayedInvalidateInterval = setTimeout($laterInvalidate, 50);
            }

            public final function $laterInvisible():void
            {
                invalidateByParent();
                super.visible = false;
            }

            protected final function $laterInvalidate():void
            {
                if (_delayedInvalidateInterval) clearTimeout(_delayedInvalidateInterval);
                _delayedInvalidateInterval = null;
                invalidate(InvalidationType.DATA, false, false);
            }

            public function invalidateByChild(childProperty:String = InvalidationType.ALL, callLater:Boolean = true)
            {
                switch (childProperty)
                {
                    case InvalidationType.SIZE:
                        if (layout.isEnveloped)
                        {
                            drawFlags |= FLAG_DRAW_NULL | FLAG_DRAW_HITAREA | FLAG_DRAW_BACKGROUND | FLAG_DRAW_CONTENT | FLAG_ALIGN_CONTENT | FLAG_ARRANGE_CHILDS | FLAG_DRAW_FOCUS;
                        }
                        else
                        {
                            drawFlags |= FLAG_ARRANGE_CHILDS;
                        }
                        break;

                    case InvalidationType.DATA:
                        break;

                    case InvalidationType.CHILDS:
                        break;

                    case InvalidationType.STATE:
                        break;

                    case InvalidationType.STYLES:
                        break;

                    case InvalidationType.LAYOUT_PROPRETIES:
                        if (layout.isEnveloped)
                        {
                            drawFlags |= FLAG_DRAW_NULL | FLAG_DRAW_HITAREA | FLAG_DRAW_BACKGROUND | FLAG_DRAW_CONTENT | FLAG_ALIGN_CONTENT | FLAG_ARRANGE_CHILDS | FLAG_DRAW_FOCUS;
                        }
                        else
                        {
                            drawFlags |= FLAG_ARRANGE_CHILDS;
                        }
                        break;
                }

                if (isDrawLater)
                {
                    return;
                }
                else
                {
                    invalidate(childProperty, callLater, false, false);
                }
            }

            protected function invalidateByParent(parentProperty:String = InvalidationType.ALL):void
            {
                switch (parentProperty)
                {
                    case InvalidationType.SIZE:
                        if (layout.percentHeight || layout.percentWidth) invalidate(parentProperty, false, false);
                        break;

                    case InvalidationType.DATA:
                        break;

                    case InvalidationType.CHILDS:
                        break;

                    case InvalidationType.STATE:
                        break;

                    case InvalidationType.STYLES:
                        break;

                    case InvalidationType.LAYOUT_PROPRETIES:
                        invalidate(InvalidationType.SIZE, true, false, false);
                        break;
                }
            }

            public function invalidate(property:String = InvalidationType.ALL, callLater:Boolean = true, updateParent:Boolean = true, updateChilds:Boolean = true):void
            {
                switch (property)
                {
                    case InvalidationType.ALL:
                    case InvalidationType.SIZE:
                        drawFlags |= FLAG_DRAW_NULL | FLAG_DRAW_HITAREA | FLAG_DRAW_BACKGROUND | FLAG_ALIGN_CONTENT | FLAG_ARRANGE_CHILDS | FLAG_DRAW_FOCUS;
                        drawFlags |= layout.isEnveloped ? 0 : FLAG_DRAW_CONTENT;
                        break;

                    case InvalidationType.DATA:
                        drawFlags |= FLAG_DRAW_CONTENT | FLAG_ALIGN_CONTENT;
                        break;

                    case InvalidationType.CHILDS:
                        if (layout.isEnveloped)
                            drawFlags |= FLAG_DRAW_NULL | FLAG_DRAW_HITAREA | FLAG_DRAW_BACKGROUND | FLAG_ARRANGE_CHILDS | FLAG_DRAW_FOCUS;
                        else
                            drawFlags |= FLAG_ARRANGE_CHILDS;
                        break;

                    case InvalidationType.STATE:
                        drawFlags |= FLAG_DRAW_BACKGROUND | FLAG_ALIGN_CONTENT | FLAG_DRAW_CONTENT;
                        break;

                    case InvalidationType.STYLES:
                        drawFlags |= FLAG_DRAW_BACKGROUND | FLAG_ALIGN_CONTENT | FLAG_DRAW_CONTENT;
                        break;


                    case InvalidationType.LAYOUT_PROPRETIES:
                        drawFlags |= FLAG_DRAW_HITAREA | FLAG_DRAW_BACKGROUND | FLAG_ALIGN_CONTENT | FLAG_ARRANGE_CHILDS;
                        break;
                }

                // request to change a parent
                if (parent is FFComponent && updateParent)
                {
                    FFComponent(parent).invalidateByChild(property);
                }

                // request to change at childs
                if(updateChilds)
                {
                    var ffchild:FFComponent;
                    for each(var child:Object in  _containerChilds)
                    {
                        ffchild = child as FFComponent;
                        if (ffchild) ffchild.invalidateByParent(property);
                    }
                }

                // finally code
                if (isDrawLater)
                {
                    return;
                }
                else
                {
                    invalidHash[property] = true;
                    this.callLater(draw);
                }
            }

            public function invalidateSize():void
            {
                invalidate(InvalidationType.SIZE, false, false);
            }

            public function invalidateStyle():void
            {
                invalidate(InvalidationType.STYLES, false, false);
            }

            public function invalidateLayout():void
            {
                invalidate(InvalidationType.CHILDS, false, false);
            }

        }

        //-------------------------------------------------
        //
        // FREE
        //
        //-------------------------------------------------
        {
            protected function removeListeners():void
            {
                for each(var ls:Listener in _listeners)
                {
                    super.removeEventListener(ls.type, ls.listener, ls.useCapture);
                    ls.free();
                    listenersCounter--;
                }
                _listeners = new Vector.<Listener>();
            }

            protected function removeStageListeners():void
            {
                for each(var ls:Listener in _stageListeners)
                {
                    if (this.stage)
                    {
                        stage.removeEventListener(ls.type, ls.listener, ls.useCapture);
                        stageListenersCounter--;
                    }
                    ls.free();
                }
                _stageListeners = new Vector.<Listener>();
            }
        }

        //--------------------------------------------------------------------
        // Effects area ...
        //--------------------------------------------------------------------
        {
            [Inspectable(defaultValue=true, verbose=1)]
            override public function get visible():Boolean
            {
                return super.visible;
            }

            override public function set visible(value:Boolean):void
            {
                if (value == super.visible) return;
                super.visible = value;
                return;

                const eventType:String = (value) ? FFComponentEvent.EVENT_VISIBLE : FFComponentEvent.EVENT_INVISIBLE;
                if (effectManager) effectManager.visibleHandler(eventType);
                else super.visible = value;
                dispatchEvent(new Event(eventType));
                return;
                /*
                const hasEffect:Boolean = _effectManager.eventEffect(eventType, null, value ? null : $laterInvisible);
                if (value || !hasEffect)
                {
                    invalidateByParent();
                    super.visible = value;
                }
                */
            }

            public function $move(x:Number, y:Number, z:Number = NaN, rX:Number = NaN, rY:Number = NaN, rZ:Number = NaN, sX:Number = NaN, sY:Number = NaN):void
            {
                  if (effectManager) effectManager.moveHandler(x, y, z, rX,  rY, rZ, sX, sY);
            }

            /*
            private function effectPlayQueue():void
            {
                var effectProps:Object = effectsQueue[0];
                effectsQueue.splice(0, 1);
                if (_effect)  _effect.finishFunction = null;
                if (effectProps)   $move(effectProps.x, effectProps.y, effectProps.z, effectProps.rX, effectProps.rY, effectProps.rZ)
            }



            public function $move(x:Number, y:Number, z:Number = NaN, rX:Number = NaN, rY:Number = NaN, rZ:Number = NaN, sX:Number = NaN, sY:Number = NaN):void
            {
                if (!_effectManager)
                {
                    move(x, y);
                    return;
                }

                if (_effect)
                {

                    if (!_effect.isFinished)
                    {
                        effectsQueue.push({x:x, y:y,z:z, rX:rX, rY:rY, rZ:rZ});
                        _effect.finishFunction = effectPlayQueue;
                    }
                }

                _effect = _effectManager.getEffect(FFComponentEvent.EVENT_MOVE);

                if (!_effect)
                {
                    move(x, y);
                    return;
                }

                if (!parent)
                {
                    effectsQueue = [];
                    return;
                }

                if (parent.parent is BaseGallery)
                {
                    _effect.durationSeconds = BaseGallery(parent.parent).itemEffectDuration;
                }

                _effect.updateContent(EffectContent.PROPERTY_X, this.x, x, !isNaN(x));
                _effect.updateContent(EffectContent.PROPERTY_Y, this.y, y, !isNaN(y));
                _effect.updateContent(EffectContent.PROPERTY_Z, this.z, z, !isNaN(z));
                _effect.updateContent(EffectContent.PROPERTY_ROTATION_X, super.rotationX, rX, !isNaN(rX));
                _effect.updateContent(EffectContent.PROPERTY_ROTATION_Y, super.rotationY, rY, !isNaN(rY));
                _effect.updateContent(EffectContent.PROPERTY_SCALEX, this.scaleX, sX, !isNaN(sX));
                _effect.updateContent(EffectContent.PROPERTY_SCALEY, this.scaleY, sY, !isNaN(sY));

                _effect.start();
            }
            */


        }
        //------------------------------------------------------------------
        //
        // FREE & ACCESSIBILITY METHODS AREA
        //
        //-------------------------------------------------------------------
        {

            public function free(force:Boolean = false):void
            {
                if (_isFreeable || force)
                {
                    __ffcomponentsFreeCounter++;
                    removeStageListeners();
                    removeListeners();
                    if(layout) _layout.client = null;
                    _layout = null;

                    //@todo free effect manager
                    //@todo free style manager
                    //@todo free state manager
                    if (_stateManager)
                    {
                        _stateManager.free();
                        _stateManager = null;
                    }
                }
            }

            protected function initializeAccessibility():void
            {
                // TODO !
                //super.initializeAccessibility();
            }


        }
        //------------------------------------------------------------------
        //
        // UTILS METHODS AREA
        //
        //-------------------------------------------------------------------
        {
            protected static function replaceContent(container:Sprite, content:DisplayObject):void
            {
                if (container.numChildren)
                {
                    if (container.getChildAt(0) == content)
                        return;
                    else
                        clearContainer(container)
                }
                if (content)
                    container.addChild(content);
            }

            protected static function clearContainer(value:DisplayObjectContainer):void
            {
                if (value)
                {
                    while (value.numChildren > 0)
                        value.removeChildAt(0);
                }
            }
        }
        //------------------------------------------------------------------
        //
        // Static statistic initializator
        //
        //-------------------------------------------------------------------
        {
            init();

            private static function init():void
            {
                log.info(FACADE_NAME + " version " + VERSION);
                perfomanceTimer.addEventListener(TimerEvent.TIMER, perfomanceStatisticHandler);
                perfomanceTimer.start();
            }

            private static function perfomanceStatisticHandler(event:Event):void
            {
                var result:String = FACADE_NAME + " statistic. ";
                result += " FFC " + __ffcomponentsCounter;
                result += ", FFC was free " + __ffcomponentsFreeCounter;
                result += ", LISTC " + FFComponent.listenersCounter;
                result += ", SLISTC " + FFComponent.stageListenersCounter;
                result += ", DRAW " + FFComponent.__ffcomponentsDrawCounter;
                result += ", DRAW RECTS " + FFComponent.ffcomponentDrawRectanglesCount;
                result += ", DRAW TFS " + FFComponent.ffcomponentDrawTextfieldCount;
                result += ", DRAW IMAGE " + FFComponent.ffcomponentDrawImageCount;
                log.info("*** " + result + " ***");
                trace("*** " + result + " ***")
            }

            public static function get log():Log
            {
                return Log.getInstanceByFacade(FACADE_NAME);
            }
        }
    }
}
