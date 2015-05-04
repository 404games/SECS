package io.nfg.secs {
  import io.nfg.secs.core.secs_internal;
  import io.nfg.secs.core.IComponent;
  import flash.utils.Dictionary;
  //import flash.utils.getDefinitionByName;
  //import flash.utils.getQualifiedClassName;
  
  public class Entity {
    
    use namespace secs_internal;
    secs_internal static var _ids:int = 0;
    
    secs_internal var _inEngine:Boolean = false;
    secs_internal var _lists:Vector.<EntityList>
    
    public var id:int = ++_ids;
    
    protected var _components:Object;
    
    public function Entity():void {
      this._components = { };
      this._lists = new Vector.<EntityList>();
    }
    
    /**
     * Adds a component to the entity
     * @param component
     * @return
     */
    public function addComponent(component:Class):* {
      return this.addComponentWith( new component () );
    }
    
    public function addComponentWith(component:IComponent):* {
      var componentClass:Class = Class((component as Object).constructor);
      this._components[componentClass] = component;
      
      if ( _inEngine )
        Engine.secs_internal::updateEntity ( this );
      
      return this;
    }
    
    /**
     * Returns the component as a proper Class object. If there is no component
     * of givent type, method returns null.
     * @param componentClass
     * @return
     */
    public function getComponent(componentClass:Class):* {
      return this._components.hasOwnProperty(componentClass) ? (this._components[componentClass] as componentClass) : null;
    }
    
    public function hasComponent(componentClass:Class):Boolean {
      return this._components.hasOwnProperty(componentClass) ? true : false;
    }
    
    public function removeComponent(componentClass:Class):void {
      
      var list:EntityList;
      var listToBeRemoved:Array = [];
      
      for each ( list in this._lists ) {
        if ( list._componentsNeeded.indexOf(componentClass) > -1 ) {
          list.secs_internal::removeEntity(this, false);
          listToBeRemoved.push(list);
        }
      }
      
      for each (list in listToBeRemoved)
        this._lists.splice(this._lists.indexOf(list), 1);
      
      delete this._components[componentClass];
    }
    
    public function toString():String {
      return "Entity " + this.id;
    }
    
    secs_internal function _addedToEntitiesList ( list:EntityList ) : void {
      this._lists.push ( list );
    }
  }
}
