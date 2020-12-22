package de.freggers.roomlib
{
   import de.freggers.content.Effects;
   import de.freggers.content.IIsoSpriteContent;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class IsoSpriteDisplayObjectContent extends Sprite implements IIsoSpriteContent
   {
       
      
      protected var _displayObject:DisplayObject;
      
      protected var _effectsLayer:Sprite;
      
      protected var _effects:Effects;
      
      public function IsoSpriteDisplayObjectContent(param1:DisplayObject)
      {
         super();
         this._displayObject = param1;
         this._effectsLayer = new Sprite();
         this._effects = new Effects();
         addChild(this._displayObject);
         addChild(this._effectsLayer);
         this._effects.renderLayer = this._effectsLayer;
      }
      
      public function get displayObject() : DisplayObject
      {
         return this._displayObject;
      }
      
      public function cleanup() : void
      {
      }
      
      public function update(param1:int) : void
      {
         if(this._effects != null)
         {
            this._effects.update(param1);
         }
      }
      
      public function set direction(param1:int) : void
      {
      }
      
      public function get effects() : Effects
      {
         return this._effects;
      }
   }
}
