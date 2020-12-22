package de.freggers.roomdisplay
{
   import de.freggers.roomlib.IsoObjectContainer;
   import de.freggers.roomlib.ItemInteraction;
   import de.freggers.ui.ISelectable;
   import de.schulterklopfer.interaction.data.MouseManagerData;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.filters.BitmapFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   
   public class MessageContainer extends Sprite implements ISelectable
   {
      
      private static const HIGHLIGHT_FILTER:BitmapFilter = new GlowFilter(16763955,0.7,2,2,10,2);
      
      private static const OVERHEARD_FILTER:BitmapFilter = new GlowFilter(255,0.7,2,2,10,2);
       
      
      private var _display:Sprite;
      
      private var _target:Rectangle;
      
      private var _timestamp:int;
      
      private var _scale:Number;
      
      private var _msgSender:IsoObjectContainer;
      
      private var _env:String;
      
      private var _layer:int;
      
      private var _mode:int;
      
      private var _timeout:int;
      
      private var _overheard:Boolean;
      
      private var _messagemanager:MessageManager;
      
      private var _closeButton:TextBarClose;
      
      private var _user_data:Object;
      
      public var mouseHandlerCallback:Function;
      
      public function MessageContainer(param1:MessageManager, param2:int, param3:IsoObjectContainer, param4:String, param5:Sprite, param6:Rectangle, param7:int, param8:int, param9:int, param10:Boolean = false, param11:Boolean = false, param12:Object = null)
      {
         super();
         this._messagemanager = param1;
         this._display = param5;
         this._timestamp = param7;
         this._target = param6;
         this._msgSender = param3;
         this._layer = param2;
         this._mode = param9;
         this._timeout = param8;
         this._env = param4;
         this._overheard = param10;
         this._user_data = param12;
         this.addChild(this._display);
         this.mouseEnabled = true;
         this._display.mouseEnabled = this._display.mouseChildren = false;
         if(param11)
         {
            this._closeButton = new TextBarClose();
            this._closeButton.y = 0;
            this._closeButton.x = this._display.x + this._display.width;
            this._closeButton.buttonMode = true;
            this.addChild(this._closeButton);
         }
         this.filters = !!this._overheard?[OVERHEARD_FILTER]:null;
      }
      
      public function handleMouseManagerData(param1:MouseManagerData) : void
      {
         var data:MouseManagerData = param1;
         if(this.mouseHandlerCallback != null)
         {
            try
            {
               this.mouseHandlerCallback(data);
               return;
            }
            catch(e:ArgumentError)
            {
               return;
            }
         }
      }
      
      public function get head() : String
      {
         if(this._msgSender)
         {
            return this._msgSender.name;
         }
         return "System";
      }
      
      public function get text() : String
      {
         return this._env + "<br>" + new Date(this._timestamp).toTimeString();
      }
      
      public function get modifiers() : Array
      {
         return null;
      }
      
      public function get target() : Rectangle
      {
         return this._target;
      }
      
      public function get timestamp() : int
      {
         return this._timestamp;
      }
      
      public function get display() : Sprite
      {
         return this._display;
      }
      
      public function get scale() : Number
      {
         return this._scale;
      }
      
      public function get layer() : int
      {
         return this._layer;
      }
      
      public function get mode() : int
      {
         return this._mode;
      }
      
      public function set highlight(param1:Boolean) : void
      {
         var _loc2_:* = [];
         if(param1)
         {
            _loc2_.push(HIGHLIGHT_FILTER);
         }
         if(this._overheard)
         {
            _loc2_.push(OVERHEARD_FILTER);
         }
         this.filters = _loc2_;
      }
      
      public function get timeout() : int
      {
         return this._timeout;
      }
      
      public function set scale(param1:Number) : void
      {
         this._scale = param1;
         this._display.scaleX = this._display.scaleY = param1;
         this._display.x = (this._target.width - this._display.width) / 2;
         this._display.y = (this._target.height - this._display.height) / 2;
      }
      
      public function get sender() : IsoObjectContainer
      {
         return this._msgSender;
      }
      
      public function cleanup() : void
      {
         if(this._user_data == null)
         {
            return;
         }
         if(this._user_data["icon"] == null || !(this._user_data["icon"] is BitmapData))
         {
            return;
         }
         (this._user_data["icon"] as BitmapData).dispose();
      }
      
      public function get interactions() : Vector.<ItemInteraction>
      {
         if(this._user_data == null)
         {
            return null;
         }
         return this._user_data["interactions"];
      }
      
      public function get wobId() : int
      {
         if(this._user_data == null)
         {
            return 0;
         }
         return this._user_data["wobId"];
      }
      
      override public function get name() : String
      {
         if(this._user_data == null)
         {
            return null;
         }
         return this._user_data["name"];
      }
      
      public function get icon() : BitmapData
      {
         if(this._user_data == null)
         {
            return null;
         }
         return this._user_data["icon"];
      }
      
      public function get isThrowTarget() : Boolean
      {
         return false;
      }
      
      public function get isTrash() : Boolean
      {
         return false;
      }
   }
}
