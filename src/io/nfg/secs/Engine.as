package io.nfg.secs {
  import io.nfg.secs.core.secs_internal;
  import io.nfg.secs.core.ISystem;

  import io.nfg.secs.EntityList;
  import flash.utils.Dictionary;
  //import flash.utils.getQualifiedClassName;
  //import flash.utils.getDefinitionByName;
  
  /**
   * Engine class provides an easy way to manage and update all systems
   * @author NotFoundGames
   */
  public class Engine {
    use namespace secs_internal;
    
    private static var _systems:Dictionary = new Dictionary();
    private static var _resources:Dictionary = new Dictionary();
    private static var _lists:Object = new Object();
    
    public function Engine() {
      throw new Error("You can't create an instance of type Engine");
    }
    
    /**
     *
     * @param components
     * @return
     */
    static public function getList(components:Array):EntityList {
      
      var name:String, names:Array = [];
      for (var i:int = 0; i < components.length; i++)
        names.push(components[i].toString());
      names.sort();
      
      name = names.join("").replace('object ', '.');
      
      if( Engine._lists.hasOwnProperty(name) == false || Engine._lists[name] == null)
        Engine._lists[name] = new EntityList(components);

      return Engine._lists[name];
    }
    
    /**
     * Updates all systems
     * @param ms
     */
    static public function update(ms:uint):void {
    
    if( ms == 0 ) return;
    
    var system:ISystem;
      for each( system in Engine._systems) {
        system.update(ms);
      }
    }
    
    /**
     * Adds a new system to the engine
     * @param system
     */
    static public function addSystem(system:ISystem):void {
      var systemClass:Class = Class((system as Object).constructor);
      if(systemClass != null) {
        if(Engine._systems[systemClass] == null) {
          Engine._systems[systemClass] = system;
        } else {
          throw new Error('[SECS] system "' + flash.utils.getQualifiedClassName(systemClass) + " can't be added twice");
        }
      }
    }
    
    /**
     * Returns a system of give type
     * @param systemClass
     * @return  Object of type System or null if such system doesn't exist
     */
    static public function getSystem(systemClass:Class):ISystem {
      if(Engine._systems[systemClass] != null)
        return Engine._systems[systemClass];
      else
        throw new Error('[SECS] No System found for class "' + systemClass + '"');
    }
    
    /**
     * Adds a global reference to a resource
     * @param name
     * @param resource
     */
    static public function addResource(name:String, resource:Object):void {
      Engine._resources[name] = resource;
    }
    
    /**
     * Retrives a global reference to a give resource
     * @param name
     */
    static public function getResource(name:String):Object {
      if(Engine._resources[name] != null)
        return Engine._resources[name];
      else
        throw new Error('[SECS] No Resource found for key "' + name + '"');
    }
    
    static public function addEntity( entity:Entity ) : void {
      
      entity.secs_internal::_inEngine = true;
      
      var k:String;
      var isAntisocial:Boolean = true;
      for( k in Engine._lists) {
        if( Engine._lists[k].secs_internal::doesEntityMatch( entity ) ) {
          Engine._lists[k].secs_internal::addEntity( entity );
          isAntisocial = false;
        }
      }

      if(isAntisocial)
        throw new Error("[SECS] " + entity + " is not a part of any entityList, please init entityList with getList([Component1, Component2, ...] before adding entity to the engine");

    }
    
    static public function removeEntity(entity:Entity) : void {
      var k:String;
      
      for( k in Engine._lists)
        Engine._lists[k].secs_internal::removeEntity( entity );
      
      entity.secs_internal::_inEngine = false;
    }
    
    static secs_internal function updateEntity( entity:Entity ) : void {
      var k:String;
      for( k in Engine._lists ) {
        if( entity._lists.indexOf( Engine._lists[k] ) == -1
        && Engine._lists[k].secs_internal::doesEntityMatch( entity ) )
          Engine._lists[k].secs_internal::addEntity( entity );
      }
    }
  }
}
