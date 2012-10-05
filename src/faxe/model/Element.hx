package faxe.model;

import nme.Assets;
import nme.display.Sprite;
import nme.display.DisplayObject;
import nme.display.DisplayObjectContainer;
import nme.geom.Matrix;
import nme.geom.Rectangle;
import nme.geom.ColorTransform;

import faxe.Main;
import faxe.model.ElementSprite;
import jarnik.gaxe.Debug;

class Element
{
    public var transform:Matrix;
    public var color:ColorTransform;
    public var children:Array<Element>;
    public var name:String;
    public var s:Sprite;
    public var alignment:AlignConfig;

	public function new () 
	{
        children = [];
        name = "";
        transform = new Matrix();
        transform.identity();
        color = new ColorTransform();
        alignment = { h: ALIGN_H_NONE, v: ALIGN_V_NONE };
	}

    public function renderContent():Sprite {
        /*
        var e:ElementSprite = new ElementSprite();
        e.name = name;
        e.alignment = alignment;
        e.transform.matrix = transform;
        e.transform.colorTransform = color;*/
        var s:Sprite = new Sprite();
        s.transform.matrix = transform;
        s.transform.colorTransform = color;
        return s;
    }

    public function move( x:Float, y:Float ):Void {
        transform.translate( x, y );
    }

    public function setAlpha( alpha:Float ):Void {
        color.alphaMultiplier = alpha;
    }

    public function toString():String {
        var out:String = "> "+name+" start\n";
        for ( c in children )
            out += c.toString()+"\n";
        out += "< "+name+" end\n";
        return out;
    }

    public function addChild( e:Element ):Void {
        children.push( e );
    }

    public function addChildAt( e:Element, index:Int ):Void {
        children.insert( index, e );
    }

    public function render( rigidLevel:Int = 0, isRoot:Bool = false ):ElementSprite {

        var e:ElementSprite = new ElementSprite( isRoot );
        e.name = name;
        e.alignment = alignment;

        var c:Sprite = renderContent();

        for ( e in children ) {
            c.addChild( 
                e.render( Std.int(Math.max(0,rigidLevel - 1)) ) 
            );
        }

        e.addContent( c, rigidLevel == 0 );

        return e;
    }

}
