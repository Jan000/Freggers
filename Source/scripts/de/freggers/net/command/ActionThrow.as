package de.freggers.net.command
{
   import de.freggers.net.UtfMessage;
   import de.freggers.net.data.EffectData;
   import de.freggers.net.data.GhosttrailData;
   import flash.geom.Vector3D;
   
   public final class ActionThrow extends Cmd
   {
       
      
      public var gui:String;
      
      public var source:Object;
      
      public var target:Object;
      
      public var height:int;
      
      public var duration:int;
      
      public var ghosttrailData:GhosttrailData;
      
      public var endEffectData:EffectData;
      
      public function ActionThrow(param1:UtfMessage)
      {
         super();
         this.init(param1);
      }
      
      private function init(param1:UtfMessage) : void
      {
         this.gui = param1.get_string_arg(1);
         if(param1.get_arg_type(2) == UtfMessage.TYPE_RECORD)
         {
            this.source = param1.get_message_arg(2).get_int_list_arg(0);
         }
         else
         {
            this.source = param1.get_int_arg(2);
         }
         if(param1.get_arg_type(3) == UtfMessage.TYPE_RECORD)
         {
            this.target = param1.get_message_arg(3).get_int_list_arg(0);
         }
         else
         {
            this.target = param1.get_int_arg(3);
         }
         var _loc2_:Array = param1.get_int_list_arg(4);
         this.height = _loc2_[0];
         this.duration = _loc2_[1];
         if(param1.get_arg_type(5) == UtfMessage.TYPE_RECORD)
         {
            this.ghosttrailData = GhosttrailData.fromUtfMessage(param1.get_message_arg(5) as UtfMessage);
         }
         if(param1.get_arg_type(6) == UtfMessage.TYPE_RECORD)
         {
            this.endEffectData = EffectData.fromUtfMessage(param1.get_message_arg(6) as UtfMessage);
         }
      }
      
      public function sourceAsVector3D() : Vector3D
      {
         var _loc1_:Array = null;
         if(this.source is Array)
         {
            _loc1_ = this.source as Array;
            return new Vector3D(_loc1_[0],_loc1_[1],_loc1_[2]);
         }
         return null;
      }
      
      public function sourceAsInt() : int
      {
         if(this.source is int)
         {
            return this.source as int;
         }
         return 0;
      }
      
      public function targetAsVector3D() : Vector3D
      {
         var _loc1_:Array = null;
         if(this.target is Array)
         {
            _loc1_ = this.target as Array;
            return new Vector3D(_loc1_[0],_loc1_[1],_loc1_[2]);
         }
         return null;
      }
      
      public function targetAsInt() : int
      {
         if(this.target is int)
         {
            return this.target as int;
         }
         return 0;
      }
   }
}
