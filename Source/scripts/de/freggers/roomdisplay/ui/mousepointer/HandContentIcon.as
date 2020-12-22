package de.freggers.roomdisplay.ui.mousepointer
{
   import de.freggers.roomlib.util.ResourceManager;
   import de.freggers.roomlib.util.ResourceRequest;
   import de.freggers.roomlib.util.StyleSheetBuilder;
   import de.freggers.util.BABitmapDataContainer;
   import de.freggers.util.TextRenderer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.StyleSheet;
   
   public final class HandContentIcon extends Sprite
   {
      
      private static const COUNT_STYLE:StyleSheet = new StyleSheetBuilder(".number").add("fontSize",12).add("fontWeight","bold").add("color","#ffffff").add("fontFamily","Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif").build();
       
      
      private var _handContentGui:String;
      
      private var _handContentCount:int = 0;
      
      private var _handContentIcon:Bitmap;
      
      private var _handContentCountIcon:Bitmap;
      
      private var _handContentIsThrowable:Boolean;
      
      private var _consumerWobids:Array;
      
      private var _backup:HandContentIconBackup;
      
      public var onSizeChanged:Function;
      
      public function HandContentIcon()
      {
         super();
         this.init();
      }
      
      private static function loadHandContentIcon(param1:String, param2:Function, param3:Function) : void
      {
         var _loc4_:String = ResourceManager.instance.getPortableItemUrl(param1,"_s");
         if(!_loc4_)
         {
            param2(null,createDummyContentBABitmapDataContainer(),null);
         }
         else
         {
            ResourceManager.instance.requestImageData(_loc4_,null,param2,param3);
         }
      }
      
      private static function createCounterBitmapData(param1:int, param2:StyleSheet) : BitmapData
      {
         var _loc3_:Point = new Point(2,2);
         var _loc4_:int = 10;
         var _loc5_:int = 15;
         var _loc6_:BitmapData = TextRenderer.renderToBitmap("<span class=\'number\'>" + param1 + "</span>",param2,_loc4_ - 2 * _loc3_.x,false,0,true);
         var _loc7_:BitmapData = new BitmapData(_loc4_,_loc5_,false,16777215);
         var _loc8_:Rectangle = _loc7_.rect.clone();
         _loc8_.x = 1;
         _loc8_.width = _loc8_.width - 2;
         _loc8_.y = 1;
         _loc8_.height = _loc8_.height - 2;
         _loc7_.fillRect(_loc8_,5207415);
         _loc7_.copyPixels(_loc6_,_loc6_.rect,new Point((_loc7_.width - _loc6_.width) / 2,(_loc7_.height - _loc6_.height) / 2),null,null,true);
         _loc6_.dispose();
         return _loc7_;
      }
      
      private static function createDummyContentBABitmapDataContainer() : BABitmapDataContainer
      {
         var _loc1_:BitmapData = new BitmapData(20,20,false,65280);
         _loc1_.fillRect(new Rectangle(2,2,16,16),255);
         _loc1_.fillRect(new Rectangle(6,6,8,8),16711680);
         return new BABitmapDataContainer(_loc1_);
      }
      
      private function init() : void
      {
         this._handContentIcon = new Bitmap(null,PixelSnapping.AUTO,true);
         this._handContentCountIcon = new Bitmap(null,PixelSnapping.AUTO,true);
         addChild(this._handContentIcon);
         addChild(this._handContentCountIcon);
         this.sizeChanged();
      }
      
      public function setHandContent(param1:String, param2:int = 1, param3:Array = null, param4:Boolean = false) : Boolean
      {
         var _loc5_:BitmapData = null;
         if(this._handContentGui != param1)
         {
            if(this._handContentIcon.bitmapData != null)
            {
               _loc5_ = this._handContentIcon.bitmapData;
               this._handContentIcon.bitmapData = null;
               this._handContentIcon.visible = false;
               _loc5_.dispose();
            }
            if(param1 != null)
            {
               HandContentIcon.loadHandContentIcon(param1,this.__cb_handContentIconLoaded,this.__cb_handContentIconLoadingFailed);
            }
         }
         this._consumerWobids = param3;
         this._handContentIsThrowable = param4;
         if(this._handContentGui != param1 || this._handContentCount != param2)
         {
            this._handContentGui = param1;
            this._handContentCount = param2;
            this.updateCountIcon();
            this.sizeChanged();
            return true;
         }
         return false;
      }
      
      public function removeHandContent() : void
      {
         var _loc1_:BitmapData = null;
         if(this._handContentIcon.bitmapData != null)
         {
            _loc1_ = this._handContentIcon.bitmapData;
            this._handContentIcon.bitmapData = null;
            _loc1_.dispose();
         }
         this._handContentIcon.visible = false;
         this._handContentGui = null;
         this._handContentCount = 0;
         this._handContentCountIcon.visible = false;
         this._handContentIsThrowable = false;
      }
      
      private function repositionCountIcon() : void
      {
         if(this._handContentCount < 1 || this._handContentIcon.bitmapData == null)
         {
            this._handContentCountIcon.visible = false;
         }
         else
         {
            this._handContentCountIcon.visible = true;
            this._handContentCountIcon.x = this._handContentIcon.x + this._handContentIcon.width - this._handContentCountIcon.width / 2;
            this._handContentCountIcon.y = this._handContentIcon.y - this._handContentCountIcon.height / 2;
         }
      }
      
      private function updateCountIcon() : void
      {
         var _loc1_:BitmapData = null;
         if(this._handContentCountIcon.bitmapData)
         {
            _loc1_ = this._handContentCountIcon.bitmapData;
         }
         this._handContentCountIcon.bitmapData = createCounterBitmapData(this._handContentCount,COUNT_STYLE);
         if(_loc1_ != null)
         {
            _loc1_.dispose();
         }
      }
      
      private function sizeChanged() : void
      {
         this.repositionCountIcon();
         if(this.onSizeChanged != null)
         {
            try
            {
               this.onSizeChanged();
               return;
            }
            catch(e:ArgumentError)
            {
               return;
            }
         }
      }
      
      public function backup() : void
      {
         if(this._backup != null)
         {
            return;
         }
         var _loc1_:HandContentIconBackup = new HandContentIconBackup();
         _loc1_.consumerWobids = this._consumerWobids;
         _loc1_.handContentCount = this._handContentCount;
         _loc1_.handContentGui = this._handContentGui;
         _loc1_.handContentIsThrowable = this._handContentIsThrowable;
         this._backup = _loc1_;
      }
      
      public function restore() : void
      {
         if(this._backup == null)
         {
            return;
         }
         var _loc1_:HandContentIconBackup = this._backup;
         this._backup = null;
         this.setHandContent(_loc1_.handContentGui,_loc1_.handContentCount,_loc1_.consumerWobids,_loc1_.handContentIsThrowable);
      }
      
      public function get handContentCount() : int
      {
         return this._handContentCount;
      }
      
      public function get isThrowable() : Boolean
      {
         return this._handContentIsThrowable;
      }
      
      override public function get width() : Number
      {
         if(this._handContentIcon == null)
         {
            return 0;
         }
         return this._handContentIcon.width;
      }
      
      override public function get height() : Number
      {
         if(this._handContentIcon == null)
         {
            return 0;
         }
         return this._handContentIcon.height;
      }
      
      public function get handContentGui() : String
      {
         return this._handContentGui;
      }
      
      public function consumedBy(param1:int) : Boolean
      {
         if(this._consumerWobids == null)
         {
            return false;
         }
         return this._consumerWobids.indexOf(param1) > -1;
      }
      
      public function get consumers() : Array
      {
         return this._consumerWobids;
      }
      
      private function __cb_handContentIconLoaded(param1:Object, param2:BABitmapDataContainer, param3:ResourceRequest) : void
      {
         this._handContentIcon.bitmapData = param2.bitmapData;
         this._handContentIcon.x = -this._handContentIcon.width / 2;
         this._handContentIcon.y = -this._handContentIcon.height / 2;
         this._handContentIcon.visible = true;
         this.sizeChanged();
      }
      
      private function __cb_handContentIconLoadingFailed(param1:Object, param2:BABitmapDataContainer, param3:ResourceRequest) : void
      {
         this.__cb_handContentIconLoaded(param1,createDummyContentBABitmapDataContainer(),param3);
      }
   }
}
