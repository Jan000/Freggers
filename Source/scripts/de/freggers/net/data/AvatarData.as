package de.freggers.net.data
{
   import de.freggers.net.Client;
   import de.freggers.net.UtfMessage;
   
   public class AvatarData implements IAvatarData
   {
       
      
      public var _userName:String;
      
      public var _wobId:int;
      
      public var _userId:int;
      
      public var _gender:int;
      
      public var _rights:int;
      
      public var _status:Array;
      
      public var _position:Position;
      
      public var _path:Path;
      
      public var _animation:AnimationData;
      
      public var _sound:SoundBlock;
      
      public var _lightmap:LightmapData;
      
      public var _effect:EffectData;
      
      public var _ghostTrail:GhosttrailData;
      
      public function AvatarData(param1:UtfMessage, param2:int = 0)
      {
         super();
         this.init(param1,param2);
      }
      
      private function init(param1:UtfMessage, param2:int = 0) : void
      {
         this._userName = param1.get_string_arg(0 + param2);
         var _loc3_:Array = param1.get_int_list_arg(1 + param2);
         this._wobId = _loc3_[0] as int;
         this._userId = _loc3_[1] as int;
         this._gender = _loc3_[2] as int;
         this._rights = _loc3_[3] as int;
         this._status = Client.getObjectStatusData(param1.get_message_arg(2 + param2) as UtfMessage);
         if(param1.get_arg_type(3 + param2) == UtfMessage.TYPE_INT)
         {
            this._position = Position.fromArray(param1.get_int_list_arg(3 + param2));
         }
         else
         {
            this._path = Path.fromUtfMessage(param1.get_message_arg(3 + param2) as UtfMessage);
         }
         this._animation = AnimationData.fromUtfMessage(param1.get_message_arg(4 + param2) as UtfMessage);
         this._sound = SoundBlock.fromUtfMessage(param1.get_message_arg(5 + param2) as UtfMessage);
         this._lightmap = LightmapData.fromUtfMessage(param1.get_message_arg(6 + param2) as UtfMessage);
         this._effect = EffectData.fromUtfMessage(param1.get_message_arg(7 + param2) as UtfMessage);
         this._ghostTrail = GhosttrailData.fromUtfMessage(param1.get_message_arg(8 + param2) as UtfMessage);
      }
      
      public function get wobId() : int
      {
         return this._wobId;
      }
      
      public function get userId() : int
      {
         return this._userId;
      }
      
      public function get userName() : String
      {
         return this._userName;
      }
      
      public function get rights() : int
      {
         return this._rights;
      }
      
      public function get status() : Array
      {
         return this._status;
      }
      
      public function get path() : Path
      {
         return this._path;
      }
      
      public function get position() : Position
      {
         return this._position;
      }
      
      public function get lightmap() : LightmapData
      {
         return this._lightmap;
      }
      
      public function get effect() : EffectData
      {
         return this._effect;
      }
      
      public function get animation() : AnimationData
      {
         return this._animation;
      }
      
      public function get sound() : SoundBlock
      {
         return this._sound;
      }
      
      public function get ghostTrail() : GhosttrailData
      {
         return this._ghostTrail;
      }
   }
}
