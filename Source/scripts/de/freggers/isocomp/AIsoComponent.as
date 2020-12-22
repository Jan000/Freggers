package de.freggers.isocomp
{
   import de.freggers.AComponent;
   
   public class AIsoComponent extends AComponent
   {
       
      
      public function AIsoComponent()
      {
         super();
      }
      
      public function get needspredraw() : Boolean
      {
         return false;
      }
      
      public function predraw() : void
      {
      }
      
      public function get needspostdraw() : Boolean
      {
         return false;
      }
      
      public function postdraw() : void
      {
      }
      
      public function get needsupdate() : Boolean
      {
         return false;
      }
      
      public function get policyfile() : String
      {
         return null;
      }
   }
}
