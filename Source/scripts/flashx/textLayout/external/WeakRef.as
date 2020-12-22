package flashx.textLayout.external
{
   import flash.utils.Dictionary;
   
   public class WeakRef
   {
       
      
      private var dic:Dictionary;
      
      public function WeakRef(param1:*)
      {
         super();
         this.dic = new Dictionary(true);
         if(param1 != null)
         {
            this.dic[param1] = 1;
         }
      }
      
      public function get() : *
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.dic)
         {
            return _loc1_;
         }
         return null;
      }
   }
}
