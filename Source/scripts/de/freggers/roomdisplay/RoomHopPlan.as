package de.freggers.roomdisplay
{
   import de.freggers.data.Level;
   import de.freggers.data.LevelBackground;
   import de.freggers.isostar.IsoStar;
   import de.freggers.locale.RoomDisplay.LocaleStrings;
   import de.freggers.roomlib.Exit;
   import de.freggers.roomlib.util.ResourceManager;
   import de.freggers.util.TextRenderer;
   import de.schulterklopfer.interaction.data.MouseManagerData;
   import de.schulterklopfer.interaction.manager.InteractionManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.errors.IOError;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilter;
   import flash.filters.BlurFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.text.StyleSheet;
   
   public class RoomHopPlan extends Sprite
   {
      
      private static const EXIT_COLOR:int = 16098343;
      
      private static const BORDER_WIDTH:int = 10;
      
      public static var ROOMHOP_INTERACTION_GROUP:String = "__roomhop__";
       
      
      public var onRoomHop:Function;
      
      public var onInitComplete:Function;
      
      public var onInitFailed:Function;
      
      public var onClose:Function;
      
      private var _areaName:String;
      
      private var _hopRoomLabel:String;
      
      private var _exitData:Array;
      
      private var _exits:Array;
      
      private var _roomPlan:IsoStar;
      
      private var _roomMask:Shape;
      
      private var _level:Level;
      
      private var _levelBackground:LevelBackground;
      
      private var _screenWidth:int;
      
      private var _screenHeight:int;
      
      private var _initCancelled:Boolean = false;
      
      private var _closeButton:Sprite;
      
      private var _titleBmp:Bitmap;
      
      private var _title:Sprite;
      
      private var _loadOverlay:MyLoader;
      
      public function RoomHopPlan(param1:String, param2:String, param3:Array, param4:Point)
      {
         super();
         this._hopRoomLabel = param2;
         this._areaName = param1;
         this._exitData = param3;
         this._loadOverlay = new MyLoader(param4.x,param4.y);
         this.mouseEnabled = false;
         addChild(this._loadOverlay);
         this.setScreenSize(param4.x,param4.y);
      }
      
      public function setScreenSize(param1:int, param2:int) : void
      {
         this._screenWidth = param1;
         this._screenHeight = param2;
         this.reorderGUI();
      }
      
      public function requestRoomData() : void
      {
         if(this._initCancelled)
         {
            return;
         }
         this._level = new Level(this._areaName,this._hopRoomLabel);
         this._level.onMediaContainerDecoded = this.handleLevelDecoded;
         this._level.onIOError = this.handleLoadLevelFailed;
         this._level.onLoadProgress = this.handleLoaderProgress;
         ResourceManager.instance.requestLevel(this._level,null,true);
      }
      
      private function handleLoaderProgress(param1:Object, param2:Number, param3:Number) : void
      {
         this._loadOverlay.progress = param2 / param3;
      }
      
      private function handleLevelDecoded(param1:Level) : void
      {
         if(this._initCancelled)
         {
            return;
         }
         this._levelBackground = new LevelBackground(this._areaName,this._hopRoomLabel,100,this._level.bounds.size);
         this._levelBackground.onMediaContainerDecoded = this.handleBackgroundDecoded;
         this._levelBackground.onIOError = this.handleBackgroundLoadingFailed;
         this._levelBackground.onLoadProgress = this.handleLoaderProgress;
         ResourceManager.instance.requestBackground(this._levelBackground);
      }
      
      private function handleLoadLevelFailed(param1:Level, param2:IOError) : void
      {
         var level:Level = param1;
         var err:IOError = param2;
         this.cleanup();
         if(this.onInitFailed != null)
         {
            try
            {
               this.onInitFailed();
               return;
            }
            catch(err:ArgumentError)
            {
               return;
            }
         }
      }
      
      private function reorderGUI() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         this._loadOverlay.handleResize(this._screenWidth,this._screenHeight);
         if(this._roomPlan)
         {
            graphics.clear();
            graphics.beginFill(0);
            graphics.drawRect(0,0,this._screenWidth,this._screenHeight);
            graphics.endFill();
            _loc1_ = Math.min((this._screenWidth - 2 * BORDER_WIDTH) / this._levelBackground.width,(this._screenHeight - 2 * BORDER_WIDTH) / this._levelBackground.height);
            _loc2_ = this._roomPlan.width * _loc1_;
            _loc3_ = this._roomPlan.height * _loc1_;
            this._roomPlan.scaleX = _loc1_;
            this._roomPlan.scaleY = _loc1_;
            this._roomMask.width = _loc2_;
            this._roomMask.height = _loc3_;
            this._roomPlan.x = this._roomMask.x = (this._screenWidth - this._roomPlan.width * _loc1_) / 2;
            this._roomPlan.y = this._roomMask.y = (this._screenHeight - this._roomPlan.height * _loc1_) / 2;
            this._closeButton.x = this._roomPlan.x + _loc2_ - this._closeButton.width / 2;
            this._closeButton.y = 2;
            this.scaleExitArrows(0.7 / _loc1_);
            this.createTitle(this._roomPlan.width * _loc1_);
            this._title.x = (this._screenWidth - this._title.width) / 2;
            this._title.y = this._closeButton.y + this._closeButton.height;
         }
      }
      
      private function createTitle(param1:Number) : void
      {
         var _loc2_:StyleSheet = new StyleSheet();
         _loc2_.setStyle(".foo",{
            "textAlign":"center",
            "fontSize":14,
            "fontWeight":"bold",
            "fontFamily":"Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif",
            "color":"#000000"
         });
         var _loc3_:BitmapData = TextRenderer.renderToBitmap("<span class=\'foo\'>" + LocaleStrings.MSG_ROOM_FULL_ROOM + "</span>",_loc2_,param1 - 20,true,0,false);
         if(!this._title)
         {
            this._title = new Sprite();
            this._title.filters = [new DropShadowFilter(1)];
            this._title.mouseEnabled = this._title.mouseChildren = false;
            addChild(this._title);
         }
         this._title.graphics.clear();
         this._title.graphics.beginFill(16777215,0.8);
         this._title.graphics.drawRoundRect(0,0,param1 - 10,_loc3_.height + 10,5,5);
         this._title.graphics.endFill();
         if(this._titleBmp)
         {
            this._titleBmp.bitmapData = _loc3_;
         }
         else
         {
            this._titleBmp = new Bitmap(_loc3_);
            this._title.addChild(this._titleBmp);
            this._titleBmp.y = 5;
         }
         this._titleBmp.x = (this._title.width - this._titleBmp.width) / 2;
      }
      
      private function scaleExitArrows(param1:Number) : void
      {
         var _loc2_:Exit = null;
         for each(_loc2_ in this._exits)
         {
            _loc2_.exitScale = param1;
         }
      }
      
      private function handleBackgroundDecoded(param1:LevelBackground) : void
      {
         var bg:LevelBackground = param1;
         if(this._initCancelled)
         {
            return;
         }
         var backgroundData:BitmapData = new BitmapData(bg.width,bg.height,false);
         bg.drawPixelsInto(backgroundData,backgroundData.rect);
         var filter:BitmapFilter = new ColorMatrixFilter([0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0,0,0,1,0]);
         backgroundData.applyFilter(backgroundData,backgroundData.rect,backgroundData.rect.topLeft,filter);
         filter = new BlurFilter(20,20,1);
         backgroundData.applyFilter(backgroundData,backgroundData.rect,backgroundData.rect.topLeft,filter);
         bg.pixelData = backgroundData.getPixels(backgroundData.rect);
         this._roomMask = new Shape();
         this._roomMask.graphics.beginFill(153);
         this._roomMask.graphics.drawRect(0,0,100,100);
         this._roomMask.graphics.endFill();
         this._roomPlan = new IsoStar(this._levelBackground,this._level,this._levelBackground.width,this._levelBackground.height);
         this._roomPlan.mask = this._roomMask;
         this._closeButton = new CloseButtonSquare();
         this._closeButton.addEventListener(MouseEvent.CLICK,this.handleCloseButton);
         this._closeButton.buttonMode = true;
         addChild(this._roomPlan);
         addChild(this._roomMask);
         addChild(this._closeButton);
         this.initExits();
         this.reorderGUI();
         if(this.onInitComplete != null)
         {
            try
            {
               this.onInitComplete();
               return;
            }
            catch(err:ArgumentError)
            {
               return;
            }
         }
      }
      
      private function handleBackgroundLoadingFailed(param1:LevelBackground, param2:IOError) : void
      {
         var bg:LevelBackground = param1;
         var err:IOError = param2;
         this.cleanup();
         if(this.onInitFailed != null)
         {
            try
            {
               this.onInitFailed();
               return;
            }
            catch(err:ArgumentError)
            {
               return;
            }
         }
      }
      
      private function initExits() : void
      {
         var _loc1_:Exit = null;
         var _loc3_:uint = 0;
         this._exits = new Array();
         var _loc2_:uint = this._exitData.length;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = new Exit(this._roomPlan,this._exitData[_loc3_]["polygon"],this._exitData[_loc3_]["z"],this._exitData[_loc3_]["dir"],Exit.EXIT_TYPE_HOP);
            _loc1_.exitLabel = this._exitData[_loc3_]["label"];
            _loc1_.buttonMode = true;
            this._roomPlan.addIsoFlatThing(_loc1_);
            this._exits.push(_loc1_);
            InteractionManager.registerForMouse(_loc1_,this.handleExitMouseEvent,ROOMHOP_INTERACTION_GROUP);
            _loc3_++;
         }
      }
      
      private function handleExitMouseEvent(param1:MouseManagerData) : void
      {
         var data:MouseManagerData = param1;
         var exit:Exit = data.currentTarget as Exit;
         if(exit == null)
         {
            return;
         }
         switch(data.type)
         {
            case MouseManagerData.CLICK:
               InteractionManager.removeGroupForMouse(ROOMHOP_INTERACTION_GROUP);
               if(this.onRoomHop != null)
               {
                  try
                  {
                     this.onRoomHop(exit.exitLabel);
                  }
                  catch(err:ArgumentError)
                  {
                  }
               }
         }
      }
      
      private function handleCloseButton(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         if(evt.target == this._closeButton)
         {
            evt.stopImmediatePropagation();
            InteractionManager.removeGroupForMouse(ROOMHOP_INTERACTION_GROUP);
            if(this.onClose != null)
            {
               try
               {
                  this.onClose();
               }
               catch(err:ArgumentError)
               {
               }
            }
         }
      }
      
      public function cleanup() : void
      {
         var _loc1_:Exit = null;
         this._initCancelled = true;
         this.onRoomHop = null;
         this.onInitComplete = null;
         if(this._closeButton != null && this._closeButton.parent != null)
         {
            this._closeButton.parent.removeChild(this._closeButton);
         }
         if(this._title != null)
         {
            if(this._title.parent != null)
            {
               this._title.parent.removeChild(this._title);
            }
            this._title = null;
         }
         if(this._roomPlan != null)
         {
            if(this._roomPlan.parent != null)
            {
               this._roomPlan.parent.removeChild(this._roomPlan);
            }
            this._roomPlan.cleanup();
            this._roomPlan = null;
         }
         if(this._roomMask != null)
         {
            if(this._roomMask.parent != null)
            {
               this._roomMask.parent.removeChild(this._roomMask);
            }
            this._roomMask = null;
         }
         if(this._exitData != null)
         {
            this._exitData = null;
         }
         if(this._exits != null)
         {
            for each(_loc1_ in this._exits)
            {
               _loc1_.cleanup();
            }
            this._exits = null;
         }
         this._loadOverlay.progress = 0;
      }
   }
}
