package de.freggers.roomdisplay.ui.controlbar
{
   import caurina.transitions.Tweener;
   import de.freggers.roomdisplay.ControlsEvent;
   import de.schulterklopfer.interaction.data.MouseManagerData;
   import de.schulterklopfer.interaction.manager.InteractionManager;
   import flash.display.MovieClip;
   
   public final class OptionsDelegate
   {
       
      
      private var _optionsView:MovieClip;
      
      private var _sliderButton:MovieClip;
      
      private var _visible:Boolean;
      
      private var _musicIcon:MovieClip;
      
      private var _effectsIcon:MovieClip;
      
      public function OptionsDelegate(param1:MovieClip)
      {
         super();
         this.init(param1);
      }
      
      private function init(param1:MovieClip) : void
      {
         this._optionsView = param1;
         this._sliderButton = this._optionsView["sliderButton"];
         this._musicIcon = this._optionsView["musicIcon"];
         this._effectsIcon = this._optionsView["effectsIcon"];
         this._musicIcon.gotoAndStop("on");
         this._effectsIcon.gotoAndStop("on");
         this._sliderButton.buttonMode = true;
         this._musicIcon.buttonMode = true;
         this._effectsIcon.buttonMode = true;
         this.setOptionsVisible(true);
         InteractionManager.registerForMouse(this._sliderButton,this.handleMouseManagerData);
         InteractionManager.registerForMouse(this._musicIcon,this.handleMouseManagerData);
         InteractionManager.registerForMouse(this._effectsIcon,this.handleMouseManagerData);
      }
      
      public function handleMouseManagerData(param1:MouseManagerData) : void
      {
         var _loc2_:Boolean = false;
         if(param1.type == MouseManagerData.CLICK)
         {
            if(param1.currentTarget == this._sliderButton)
            {
               if(!this._visible)
               {
                  this._visible = true;
                  this._optionsView.dispatchEvent(new ControlsEvent(ControlsEvent.OPTIONS_SHOW));
                  Tweener.addTween(this._optionsView,{
                     "x":-this._optionsView.background.width,
                     "time":0.5
                  });
                  Tweener.addTween(this._sliderButton,{
                     "rotation":180,
                     "time":0.5
                  });
               }
               else
               {
                  this._visible = false;
                  this._optionsView.dispatchEvent(new ControlsEvent(ControlsEvent.OPTIONS_HIDE));
                  Tweener.addTween(this._optionsView,{
                     "x":-30,
                     "time":0.5
                  });
                  Tweener.addTween(this._sliderButton,{
                     "rotation":0,
                     "time":0.5
                  });
               }
            }
            else if(param1.currentTarget == this._musicIcon)
            {
               _loc2_ = this.isActive(this._musicIcon);
               this.setActive(this._musicIcon,!_loc2_);
               this._optionsView.dispatchEvent(new ControlsEvent(!!_loc2_?ControlsEvent.SOUND_DEACTIVATE:ControlsEvent.SOUND_ACTIVATE));
            }
            else if(param1.currentTarget == this._effectsIcon)
            {
               _loc2_ = this.isActive(this._effectsIcon);
               this.setActive(this._effectsIcon,!_loc2_);
               this._optionsView.dispatchEvent(new ControlsEvent(!!_loc2_?ControlsEvent.EFFECTS_DEACTIVATE:ControlsEvent.EFFECTS_ACTIVATE));
            }
         }
      }
      
      public function isActive(param1:MovieClip) : Boolean
      {
         return param1.currentLabel == "on";
      }
      
      public function setActive(param1:MovieClip, param2:Boolean) : void
      {
         param1.gotoAndStop(!!param2?"on":"off");
      }
      
      public function setMusicActive(param1:Boolean) : void
      {
         this.setActive(this._musicIcon,param1);
      }
      
      public function setEffectsActive(param1:Boolean) : void
      {
         this.setActive(this._effectsIcon,param1);
      }
      
      public function setOptionsVisible(param1:Boolean) : void
      {
         this._visible = param1;
         this._optionsView.x = !!param1?Number(-this._optionsView.background.width):Number(-30);
         this._sliderButton.rotation = !!param1?Number(180):Number(0);
      }
   }
}
