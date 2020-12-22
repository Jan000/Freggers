package de.freggers.net.data
{
   import de.freggers.net.Client;
   import de.freggers.net.ItemProperties;
   import de.freggers.net.UtfMessage;
   
   public class ItemData implements IWobData, IWOBStatus
   {
       
      
      public var name:String;
      
      private var _wobId:int;
      
      public var gui:String;
      
      private var _position:Position;
      
      private var _path:Path;
      
      private var _animation:AnimationData;
      
      private var _sound:SoundBlock;
      
      private var _lightmap:LightmapData;
      
      public var status:Array;
      
      private var _effect:EffectData;
      
      private var _ghostTrail:GhosttrailData;
      
      public var properties:ItemProperties;
      
      public var interactions:InteractionData;
      
      private var _primaryInteractionLabel:String;
      
      public function ItemData(param1:UtfMessage)
      {
         super();
         this.init(param1);
      }
      
      private function init(param1:UtfMessage) : void
      {
         var _loc2_:int = 0;
         this.name = param1.get_string_arg(_loc2_);
         this._wobId = param1.get_int_arg(++_loc2_);
         this.gui = param1.get_string_arg(++_loc2_);
         if(param1.get_arg_type(++_loc2_) == UtfMessage.TYPE_RECORD)
         {
            this._path = Path.fromUtfMessage(param1.get_message_arg(_loc2_) as UtfMessage);
         }
         else
         {
            this._position = Position.fromArray(param1.get_int_list_arg(_loc2_));
         }
         this._animation = AnimationData.fromUtfMessage(param1.get_message_arg(++_loc2_) as UtfMessage);
         this._sound = SoundBlock.fromUtfMessage(param1.get_message_arg(++_loc2_) as UtfMessage);
         this._lightmap = LightmapData.fromUtfMessage(param1.get_message_arg(++_loc2_) as UtfMessage);
         this.status = Client.getObjectStatusData(param1.get_message_arg(++_loc2_) as UtfMessage);
         this._effect = EffectData.fromUtfMessage(param1.get_message_arg(++_loc2_) as UtfMessage);
         this._ghostTrail = GhosttrailData.fromUtfMessage(param1.get_message_arg(++_loc2_) as UtfMessage);
         this.properties = new ItemProperties(param1.get_int_list_arg(++_loc2_));
         this.interactions = InteractionData.fromUtfMessage(param1.get_message_arg(++_loc2_) as UtfMessage);
         this._primaryInteractionLabel = param1.get_string_arg(++_loc2_);
      }
      
      public function get wobId() : int
      {
         return this._wobId;
      }
      
      public function get position() : Position
      {
         return this._position;
      }
      
      public function get path() : Path
      {
         return this._path;
      }
      
      public function get animation() : AnimationData
      {
         return this._animation;
      }
      
      public function get sound() : SoundBlock
      {
         return this._sound;
      }
      
      public function get lightmap() : LightmapData
      {
         return this._lightmap;
      }
      
      public function get effect() : EffectData
      {
         return this._effect;
      }
      
      public function get ghostTrail() : GhosttrailData
      {
         return this._ghostTrail;
      }
      
      public function get primaryInteractionLabel() : String
      {
         return this._primaryInteractionLabel;
      }
   }
}
