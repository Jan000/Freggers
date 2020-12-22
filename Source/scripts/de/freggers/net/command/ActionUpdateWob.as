package de.freggers.net.command
{
   import de.freggers.net.UtfMessage;
   import de.freggers.net.data.AnimationData;
   import de.freggers.net.data.EffectData;
   import de.freggers.net.data.GhosttrailData;
   import de.freggers.net.data.IWOBStatus;
   import de.freggers.net.data.LightmapData;
   import de.freggers.net.data.Path;
   import de.freggers.net.data.Position;
   import de.freggers.net.data.SoundBlock;
   
   public final class ActionUpdateWob extends Cmd implements IWOBStatus
   {
       
      
      private var _wobId:int;
      
      private var _position:Position;
      
      private var _path:Path;
      
      private var _animation:AnimationData;
      
      private var _sound:SoundBlock;
      
      private var _lightmap:LightmapData;
      
      private var _effect:EffectData;
      
      private var _ghostTrail:GhosttrailData;
      
      public function ActionUpdateWob(param1:UtfMessage)
      {
         super();
         this.init(param1);
      }
      
      private function init(param1:UtfMessage) : void
      {
         this._wobId = param1.get_int_arg(1);
         if(param1.get_arg_type(2) == UtfMessage.TYPE_INT)
         {
            this._position = Position.fromArray(param1.get_int_list_arg(2));
         }
         else
         {
            this._path = Path.fromUtfMessage(param1.get_message_arg(2) as UtfMessage);
         }
         this._animation = AnimationData.fromUtfMessage(param1.get_message_arg(3) as UtfMessage);
         this._sound = SoundBlock.fromUtfMessage(param1.get_message_arg(4) as UtfMessage);
         this._lightmap = LightmapData.fromUtfMessage(param1.get_message_arg(5) as UtfMessage);
         this._effect = EffectData.fromUtfMessage(param1.get_message_arg(6) as UtfMessage);
         if(param1.get_arg_type(7) == UtfMessage.TYPE_INT)
         {
            if(param1.get_int_arg(7) == 0)
            {
               this._ghostTrail = null;
            }
         }
         else if(param1.get_arg_type(7) == UtfMessage.TYPE_RECORD)
         {
            this._ghostTrail = GhosttrailData.fromUtfMessage(param1.get_message_arg(7) as UtfMessage);
         }
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
   }
}
