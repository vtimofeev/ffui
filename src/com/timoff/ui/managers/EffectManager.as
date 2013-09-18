package com.timoff.ui.managers {
import com.timoff.ui.core.FFComponent;
import com.timoff.ui.effects.EffectContent;
import com.timoff.ui.effects.EffectObject;
    import com.timoff.ui.events.EffectEvent;
    import com.timoff.ui.events.FFComponentEvent;

public class EffectManager {
    protected var client:FFComponent;
    protected var facadeId:String;
    protected var effects:Object = {};
    public var activeEffects:Array = [];

    public function EffectManager(client:FFComponent, facadeId:String = "default") {
        this.client = client;
        this.facadeId = facadeId;
    }

    public function getEffect(eventType:String, data:Object = null):EffectObject {
        if (eventType in effects) return effects[eventType];
        return null;
    }

    public function setEffect(event:String, effect:EffectObject, data:Object):void {
        if(!effect || !event) return;
        effect.client = this.client;
        effects[event] = effect;
    }

    public function startEffect(name:String, mode:int = 0):void
    {
        // @todo effectMode
        const effect:EffectObject = getEffect(name);
        if(!effect) return;
        effect.finishManagerFunction = managerFinishHandler;
        if (activeEffects.indexOf(effect) < 0) activeEffects.push(effect);
        effect.start();
    }

    private function managerFinishHandler(effect:EffectObject):void
    {
        const indexEffect:int = activeEffects.indexOf(effect);
        if (indexEffect > -1) activeEffects.splice(indexEffect,1);
    }

    public function eventEffect(name:String, startHandler:Function = null, delayHandler:Function = null, finishHandler:Function = null, data:Object = null):Boolean
     {
         const e:EffectObject = getEffect(name, data);
         if (!e) {
             trace("eventEffect:: Has no effect related: " + name);
             return false;
         }

         e.startFunction = startHandler;
         e.delayFunction = delayHandler;
         e.finishFunction = finishHandler;
         return true;
     }

    public function free():void
    {
        var effect:EffectObject;
        for each(effect in activeEffects) effect.stop();

        for (var name in effects)
        {
            effect = effects[name];
            if (effect) effect.free();
            delete (effects[name]);
        }
        client = null;
    }

    //---------------------------------------------------------------
    // Client Event Handlers
    //---------------------------------------------------------------

    public function moveHandler(x:Number, y:Number, z:Number = NaN, rX:Number = NaN, rY:Number = NaN, rZ:Number = NaN, sX:Number = NaN, sY:Number = NaN)
    {
        const effect = getEffect(FFComponentEvent.EVENT_MOVE);
        if (!effect)
        {
            client.move(x, y);
            return;
        }
        effect.updateContent(EffectContent.PROPERTY_X, client.x, x, !isNaN(x));
        effect.updateContent(EffectContent.PROPERTY_Y, client.y, y, !isNaN(y));
        effect.updateContent(EffectContent.PROPERTY_Z, client.z, z, !isNaN(z));
        effect.updateContent(EffectContent.PROPERTY_ROTATION_X, client.rotationX, rX, !isNaN(rX));
        effect.updateContent(EffectContent.PROPERTY_ROTATION_Y, client.rotationY, rY, !isNaN(rY));
        effect.updateContent(EffectContent.PROPERTY_SCALEX, client.scaleX, sX, !isNaN(sX));
        effect.updateContent(EffectContent.PROPERTY_SCALEY, client.scaleY, sY, !isNaN(sY));

        startEffect(FFComponentEvent.EVENT_MOVE);
    }

    public function changeStateHandler(value:String):void
    {
        startEffect(value);
    }


    public function visibleHandler(event:String):void
    {
        startEffect(event);
    }

    //---------------------------------------------------------------
    // Default effects area
    //---------------------------------------------------------------

    public function initDefaultEffects():void {
        var duration:Number = 1;

        const effect:EffectObject = new EffectObject(client, duration);
        effect.addContent(EffectContent.PROPERTY_ALPHA, 1, 0, duration);
        effect.addContent(EffectContent.PROPERTY_SCALEX, 1, 2, duration);
        effect.addContent(EffectContent.PROPERTY_SCALEY, 1, 2, duration);

        const effect_reverse:EffectObject = new EffectObject(client, duration);
        effect_reverse.addContent(EffectContent.PROPERTY_ALPHA, 0, 1, duration);
        effect_reverse.addContent(EffectContent.PROPERTY_SCALEX, 2, 1, duration);
        effect_reverse.addContent(EffectContent.PROPERTY_SCALEY, 2, 1, duration);

        const effect_move:EffectObject = new EffectObject(client, duration);
        effect_move.cacheClientAsBitmap = true;
        effect_move.addContent(EffectContent.PROPERTY_X, client.x, client.x, duration);
        effect_move.addContent(EffectContent.PROPERTY_Y, client.y, client.y, duration);
        effect_move.addContent(EffectContent.PROPERTY_Z, client.z, client.z, duration);
        effect_move.addContent(EffectContent.PROPERTY_ROTATION_X, client.rotationX, client.rotationX, duration);
        effect_move.addContent(EffectContent.PROPERTY_ROTATION_Y, client.rotationY, client.rotationY, duration);
        effect_move.addContent(EffectContent.PROPERTY_ROTATION_Z, client.rotationZ, client.rotationZ, duration);
        effect_move.useCenter = false;

        const effect_change_state_over:EffectObject = new EffectObject(client, duration);
        effect_change_state_over.addContent(EffectContent.PROPERTY_SCALEX, 1, 1.5, duration);
        effect_change_state_over.addContent(EffectContent.PROPERTY_SCALEY, 1, 1.5, duration);

        const effect_change_state_default:EffectObject = new EffectObject(client, duration);
        effect_change_state_default.addContent(EffectContent.PROPERTY_SCALEX, 1.5, 1, duration);
        effect_change_state_default.addContent(EffectContent.PROPERTY_SCALEY, 1.5, 1, duration);

        effects[FFComponentEvent.EVENT_MOVE] = effect_move;
        effects[FFComponentEvent.EVENT_VISIBLE] = effect_reverse;
        effects[FFComponentEvent.EVENT_INVISIBLE] = effect;
        effects[FFComponentEvent.EVENT_CHANGE_STATE] = effect_change_state_default;
        effects[FFComponentEvent.EVENT_CHANGE_STATE_OVER] = effect_change_state_over;

        /*
        if (client.id == "bigplayBtn")
        {
            effects[FFComponentEvent.EVENT_CHANGE_STATE] = effect_change_state_default;
            effects[FFComponentEvent.EVENT_CHANGE_STATE_OVER] = effect_change_state_over;
        }
        */
    }

}
}