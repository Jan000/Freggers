package de.freggers.roomdisplay.ui
{
   import de.schulterklopfer.interaction.data.MouseManagerData;
   import flash.display.Sprite;
   
   public class CreditsDisplay extends Sprite
   {
       
      
      public var onCoinsClick:Function;
      
      public var onBillsClick:Function;
      
      private var _display:CreditsDisplayGfx;
      
      private var _coinsLabel:CreditsLabel;
      
      private var _billsLabel:CreditsLabel;
      
      public function CreditsDisplay()
      {
         super();
         this._display = new CreditsDisplayGfx();
         addChild(this._display);
         this._coinsLabel = new CreditsLabel();
         this._coinsLabel.x = 60;
         this._coinsLabel.y = 20;
         this._display.coinsDisplay.addChild(this._coinsLabel);
         this._billsLabel = new CreditsLabel();
         this._billsLabel.x = 60;
         this._billsLabel.y = 20;
         this._display.billsDisplay.addChild(this._billsLabel);
         this._display.coinsDisplay.mouseChildren = false;
         this._display.coinsDisplay.buttonMode = true;
         this._display.billsDisplay.mouseChildren = false;
         this._display.billsDisplay.buttonMode = true;
         mouseEnabled = false;
      }
      
      public function get coinsTarget() : Sprite
      {
         return this._display.coinsDisplay.coinsTarget;
      }
      
      public function update(param1:uint, param2:uint) : void
      {
         this._coinsLabel.value = param1;
         this._billsLabel.value = param2;
      }
      
      public function handleMouseManagerData(param1:MouseManagerData) : void
      {
         if(param1.type != MouseManagerData.CLICK)
         {
            return;
         }
         if(param1.target == this._display.coinsDisplay)
         {
            this.onCoinsClick();
         }
         else if(param1.target == this._display.billsDisplay)
         {
            this.onBillsClick();
         }
      }
   }
}

import de.freggers.roomlib.util.StyleSheetBuilder;
import de.freggers.util.BitmapDataUtils;
import de.freggers.util.TextRenderer;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.text.StyleSheet;

class CreditsLabel extends Sprite
{
   
   private static const TEXT_STYLE:StyleSheet = new StyleSheetBuilder(".number").add("fontSize",14).add("fontWeight","bold").add("fontFamily","Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif").add("color","#ffffff").build();
   
   private static const MAX_WIDTH:uint = 30;
   
   private static const MAX_HEIGHT:uint = 30;
    
   
   private var currentValue:uint = 0;
   
   private var _label:Bitmap;
   
   function CreditsLabel()
   {
      super();
      this._label = new Bitmap(null,PixelSnapping.ALWAYS,true);
      addChild(this._label);
      this.render();
   }
   
   public function set value(param1:uint) : void
   {
      if(param1 == this.currentValue)
      {
         return;
      }
      this.currentValue = param1;
      this.render();
   }
   
   private function render() : void
   {
      var _loc2_:Number = NaN;
      var _loc3_:Number = NaN;
      var _loc4_:Number = NaN;
      var _loc1_:BitmapData = TextRenderer.renderToBitmap("<span class=\'number\'>" + this.currentValue + "</span>",TEXT_STYLE,0,false);
      if(_loc1_.width > MAX_WIDTH || _loc1_.height > MAX_HEIGHT)
      {
         _loc2_ = MAX_WIDTH / _loc1_.width;
         _loc3_ = MAX_HEIGHT / _loc1_.height;
         _loc4_ = _loc2_ > _loc3_?Number(_loc3_):Number(_loc2_);
         _loc1_ = BitmapDataUtils.scale(_loc1_,_loc4_,_loc4_);
      }
      this._label.bitmapData = _loc1_;
      this._label.x = -this._label.width;
      this._label.y = -this._label.height;
   }
}
