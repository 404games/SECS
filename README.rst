====================================
SECS, Simple Entity Component System
====================================

At 404games, we like to have simple, flexible library that respect the principle of IOC while being explicit in our naming conventions.
We also focus on performance, trying to avoid any wastefull computation.

Our framework is stable for several games running in production.
However it's still quite young, and there's probably a lot of improvement to make, and maybe usecase we didn't thought of.

Please feel free to open issue or send any pull request, we're quite a reactive team and will probably handle it within a week.


Installation
============

Include secs.swc to your project:

- with mxmlc using command line argument: -library-path+=secs.swc
- or using your IDE


Example:
========
.. code-block:: actionscript

  // FILE: components/Visible.as
  class Visible implements IComponent {
    public var mesh:Mesh;
    public var material:TextureMaterial;
    public var animator:VertexAnimator;
  }

  // FILE: components/Position.as
  class Position implements IComponent {
    public var x:Number;
    public var y:Number;
    
    public function setXY(x:Number, y:Number):Position {
      this.x = x;
      this.y = y;
      return this;
    }
  }

  // FILE: systems/RenderingSystem.as
  class RenderingSystem implements ISystem {
    [...]
    public function RenderingSystem(sprite:Sprite, renderableList:EntityList) {
      this._renderableList = renderableList;
      this._sprite = sprite;
    }

    public function update(ms:uint):void {
      var i:int;
      for ( i = 0; i < this._renderableList.length; i++ ) {
        visible = this._renderableList.list[i].getComponent(Visible);
        position = this._renderableList.list[i].getComponent(Position);

        // update visible and position components
      }
    }
  }


  // FILE: Game.as
  class Game extends Sprite {
    public function Game {

      // -> entity lists first
      var renderableList:EntityList = Engine.getList([Visible, Position]);

      // -> init entities
      var entity:Entity = new Entity();
      entity.addComponent(Visible).addComponentWith(new Position().setXY(50, 100));
      Engine.addEntity(entity);
      
      // -> systems
      Engine.addSystem(
        new RenderingSystem(this, renderableList)
      );

      // Tick
      this.addEventListener(Event.ENTER_FRAME, function(e:Event):void {
        Engine.update(60);
      });
    }
  }
