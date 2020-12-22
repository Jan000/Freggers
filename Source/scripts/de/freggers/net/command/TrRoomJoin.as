package de.freggers.net.command
{
   import de.freggers.net.UtfMessage;
   import de.freggers.net.data.AnimationData;
   import de.freggers.net.data.AvatarData;
   import de.freggers.net.data.EffectData;
   import de.freggers.net.data.GhosttrailData;
   import de.freggers.net.data.IAvatarData;
   import de.freggers.net.data.IWOBStatus;
   import de.freggers.net.data.LightmapData;
   import de.freggers.net.data.Path;
   import de.freggers.net.data.Position;
   import de.freggers.net.data.SoundBlock;
   
   public final class TrRoomJoin extends Cmd implements IAvatarData, IWOBStatus
   {
       
      
      private var data:AvatarData;
      
      public function TrRoomJoin(param1:UtfMessage)
      {
         super();
         this.data = new AvatarData(param1,1);
      }
      
      public function get wobId() : int
      {
         return this.data.wobId;
      }
      
      public function get userId() : int
      {
         return this.data.userId;
      }
      
      public function get userName() : String
      {
         return this.data.userName;
      }
      
      public function get rights() : int
      {
         return this.data.rights;
      }
      
      public function get status() : Array
      {
         return this.data.status;
      }
      
      public function get path() : Path
      {
         return this.data.path;
      }
      
      public function get position() : Position
      {
         return this.data.position;
      }
      
      public function get lightmap() : LightmapData
      {
         return this.data.lightmap;
      }
      
      public function get effect() : EffectData
      {
         return this.data.effect;
      }
      
      public function get animation() : AnimationData
      {
         return this.data.animation;
      }
      
      public function get sound() : SoundBlock
      {
         return this.data.sound;
      }
      
      public function get ghostTrail() : GhosttrailData
      {
         return this.data.ghostTrail;
      }
   }
}
