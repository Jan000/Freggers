package de.freggers.net.data
{
   import de.freggers.net.UtfMessage;
   import flash.geom.Vector3D;
   
   public class SoundBlock
   {
       
      
      private var _context:String;
      
      private var _label:String;
      
      private var _loopCount:int = 1;
      
      private var _position:int = 0;
      
      private var _volume:int = 100;
      
      private var _playMode:int = 0;
      
      private var _minValue:int = 0;
      
      private var _maxValue:int = 0;
      
      private var _range:int = -1;
      
      private var _coordsInRoom:Vector3D = null;
      
      public var fadeInValue:int = 0;
      
      public function SoundBlock(param1:String, param2:String, param3:Array, param4:Vector3D)
      {
         super();
         this._context = param1;
         this._label = param2;
         this._coordsInRoom = param4;
         this.initFromConfig(param3);
      }
      
      public static function fromUtfMessage(param1:UtfMessage) : SoundBlock
      {
         var _loc3_:Array = null;
         if(!param1)
         {
            return null;
         }
         var _loc2_:Vector3D = null;
         if(param1.get_arg_type(3) == UtfMessage.TYPE_INT)
         {
            _loc3_ = param1.get_int_list_arg(3);
            _loc2_ = new Vector3D(_loc3_[0],_loc3_[1],_loc3_[2]);
         }
         return new SoundBlock(param1.get_string_arg(0),param1.get_string_arg(1),param1.get_int_list_arg(2),_loc2_);
      }
      
      public static function listFromUtfMessage(param1:UtfMessage) : Array
      {
         var _loc4_:Object = null;
         var _loc2_:Array = new Array();
         var _loc3_:uint = param1.get_arg_count();
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = SoundBlock.fromUtfMessage(param1.get_message_arg(_loc5_) as UtfMessage);
            _loc2_.push(_loc4_);
            _loc5_++;
         }
         return _loc2_;
      }
      
      public function get context() : String
      {
         return this._context;
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function get loopCount() : int
      {
         return this._loopCount;
      }
      
      public function get position() : int
      {
         return this._position;
      }
      
      public function get volume() : int
      {
         return this._volume;
      }
      
      public function get playMode() : int
      {
         return this._playMode;
      }
      
      public function get minValue() : int
      {
         return this._minValue;
      }
      
      public function get maxValue() : int
      {
         return this._maxValue;
      }
      
      public function get range() : int
      {
         return this._range;
      }
      
      public function get coordsInRoom() : Vector3D
      {
         return this._coordsInRoom;
      }
      
      private function initFromConfig(param1:Array) : void
      {
         this._loopCount = param1[0];
         this._position = param1[1];
         this._volume = param1[2];
         this._playMode = param1[3];
         this._minValue = param1[4];
         this._maxValue = param1[5];
         this._range = param1[6];
      }
   }
}
