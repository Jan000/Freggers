package de.freggers.roomdisplay.ui
{
   import de.freggers.roomdisplay.ui.controlbar.IconsDelegate;
   import de.freggers.roomdisplay.ui.controlbar.InputDelegate;
   import de.freggers.roomdisplay.ui.controlbar.OptionsDelegate;
   import de.freggers.roomdisplay.ui.controlbar.UniversalHelperDelegate;
   import de.schulterklopfer.interaction.data.MouseManagerData;
   import de.schulterklopfer.interaction.manager.InteractionManager;
   
   public final class ControlBar extends ControlBarGfx
   {
       
      
      private var _inputDelegate:InputDelegate;
      
      private var _iconsDelegate:IconsDelegate;
      
      private var _optionsDelegate:OptionsDelegate;
      
      public function ControlBar()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.mouseEnabled = false;
         shadow.mouseEnabled = shadow.mouseChildren = false;
         background.mouseChildren = background.mouseEnabled = false;
         options.mouseEnabled = false;
         this._inputDelegate = new InputDelegate(input);
         this._iconsDelegate = new IconsDelegate(icons);
         this._optionsDelegate = new OptionsDelegate(options);
         InteractionManager.registerForMouse(input,this.handleMouseManagerData,RoomDisplay.INTERACTION_GROUP_WIDGETS);
      }
      
      public function handleMouseManagerData(param1:MouseManagerData) : void
      {
         param1.mouseEvent.stopImmediatePropagation();
      }
      
      public function update(param1:int) : void
      {
         this._inputDelegate.update(param1);
      }
      
      public function get universalHelper() : UniversalHelperDelegate
      {
         return this._iconsDelegate.universalHelperDelegate;
      }
      
      public function get textInput() : InputDelegate
      {
         return this._inputDelegate;
      }
      
      public function get optionsDelegate() : OptionsDelegate
      {
         return this._optionsDelegate;
      }
   }
}
