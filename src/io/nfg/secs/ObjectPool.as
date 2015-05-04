package io.nfg.secs {
  
  /**
   * @author Mateusz Lesiński
   */
  public class ObjectPool {
    protected var _objects:Array;
    protected var _availableObjects:Array;
    
    protected var _objectClass:Class;
    protected var _objectDefaults:Array;
    
    public function ObjectPool(objectType:*, precache:uint = 0, defaultParameters:Array = null) {
      _objects = [];
      _availableObjects = [];
      
      _objectDefaults = (defaultParameters == null) ? [] : defaultParameters;
      _objectClass = (objectType is Class) ? _objectClass = objectType : Class(objectType.constructor);
      
      for (var i:int = 0; i < precache; i++) {
        _availableObjects.push(createObject());
      }
    }
    
    public function addObject(object:*):void {
      this._objects.push(object);
      this._availableObjects.push(object);
    }
    
    public function getObject():* {
      if (_availableObjects.length > 0)
        return _availableObjects.pop() as _objectClass;
      else
        return createObject();
    }
    
    public function freeObject(object:*):void {
      _availableObjects.push(object);
    }
    
    public function freeAllObjects():void {
      _availableObjects = _objects.concat();
    }
    
    public function disposeObject(object:*):void {
      var obj:* = object as _objectClass;
      
      var index:uint = _objects.indexOf(obj);
      if (index > -1)
        _objects.splice(index, 1);
      
      index = _availableObjects.indexOf(obj);
      if (index > -1)
        _objects.splice(index, 1);
    }
    
    private function createObject():* {
      
      var obj:*;
      
      switch (_objectDefaults.length) {
        case 0: 
          obj = new _objectClass() as _objectClass;
          break;
        case 1: 
          obj = new _objectClass(_objectDefaults[0]) as _objectClass;
          break;
        case 2: 
          obj = new _objectClass(_objectDefaults[0], _objectDefaults[1]) as _objectClass;
          break;
        case 3: 
          obj = new _objectClass(_objectDefaults[0], _objectDefaults[1], _objectDefaults[2]) as _objectClass;
          break;
        case 4: 
          obj = new _objectClass(_objectDefaults[0], _objectDefaults[1], _objectDefaults[2], _objectDefaults[3]) as _objectClass;
          break;
        default: 
          throw new Error("Too much arguments for PoolObject");
      }
      
      _objects.push(obj);
      
      return obj;
    }
    
    public function get availableObjects():Array {
      return _availableObjects;
    }
  }
}
