package flashx.textLayout.elements
{
   public final class BreakElement extends SpecialCharacterElement
   {
       
      
      public function BreakElement()
      {
         super();
         this.text = " ";
      }
      
      override protected function get abstract() : Boolean
      {
         return false;
      }
   }
}
