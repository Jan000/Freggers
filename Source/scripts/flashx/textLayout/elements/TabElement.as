package flashx.textLayout.elements
{
   public final class TabElement extends SpecialCharacterElement
   {
       
      
      public function TabElement()
      {
         super();
         this.text = "\t";
      }
      
      override protected function get abstract() : Boolean
      {
         return false;
      }
   }
}
