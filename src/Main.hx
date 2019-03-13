import h3d.scene.*;

class Main extends hxd.App {
	var time:Float = 0.;
	var p:Mesh;
	var p2:Mesh;

	override function init() {
		// Create a floor plane where we can view our cast shadows
		var floor = new h3d.prim.Cube(10, 10, 0.1);
		// Make sure we add normals
		floor.addNormals();
		floor.translate(-5, -5, 0);

		var m = new h3d.scene.Mesh(floor, s3d);
		// Enabled lighting
		m.material.mainPass.enableLights = true;
		// Enable receieiving of shadows. Our floor does not need to cast
		m.material.receiveShadows = true;

		// Greate some sphere geometry for casting and receiving shadows
		//var plane2D = new h3d.prim.Plane2D()
		var sphere = new h3d.prim.Sphere(1, 32, 24);
		// Make sure we add normals
		sphere.addNormals();

		p = new h3d.scene.Mesh(sphere, s3d);
		p.z = 1;
		p.material.mainPass.enableLights = true;
		// Enable casting and receiving of shadows
		p.material.shadows = true;
		p.material.color.setColor(Std.random(0x1000000));

		p2 = new h3d.scene.Mesh(sphere, s3d);
		p2.z = 1;
		// p2.x = 1;
		// p2.y = 1;
		p2.scale(0.5);
		p2.material.mainPass.enableLights = true;
		// Enable casting and receiving of shadows
		p2.material.shadows = true;
		p2.material.color.setColor(Std.random(0x1000000));
		p2.addChild(p);

		// creates another text field with this font
		var tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
		tf.textColor = 0xFFFFFF;
		tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
		tf.text = "Test d'interface";

		tf.y = 20;
		tf.x = 20;
		tf.scale(7);

		// Set up a light otherwise we don't get any shadows
		var directionalLight = new h3d.scene.DirLight(new h3d.Vector(-0.3, -0.2, -1), s3d);

		// Move our camera to a position to see the shadows
		s3d.camera.pos.set(12, 12, 6);

		// Setup a Camera Controller to move the camera
		new h3d.scene.CameraController(s3d).loadFromCamera();
	}

	override function update(dt:Float) {
		// time is flying...
		time += 0.6 * dt;

		// Get the direction vector
		var directionCameraToMesh = directionCameraToMesh(s3d.camera, p2);
		trace(directionCameraToMesh);

		p.setPosition((p.x / 2) + (Math.sin(time) * 3), (p.y / 2) + (Math.cos(time) * 3), (p.z / 2) + (Math.sin(time) * 3));

		if (hxd.Key.isDown(hxd.Key.UP)) {
			p2.setPosition(p2.x + (directionCameraToMesh.x * 5) * dt, p2.y + (directionCameraToMesh.y * 5) * dt, p2.z);
		}

        if (hxd.Key.isDown(hxd.Key.DOWN)) {
			p2.setPosition(p2.x + (-directionCameraToMesh.x * 5) * dt, p2.y + (-directionCameraToMesh.y * 5) * dt, p2.z);
		}

		if (hxd.Key.isDown(hxd.Key.RIGHT)) {
			p2.setPosition(p2.x + (-directionCameraToMesh.y * 5) * dt, p2.y + (directionCameraToMesh.x * 5) * dt, p2.z);
		}

		if (hxd.Key.isDown(hxd.Key.LEFT)) {
			p2.setPosition(p2.x + (directionCameraToMesh.y * 5) * dt, p2.y + (-directionCameraToMesh.x * 5) * dt, p2.z);
		}

		// Update the target
		s3d.camera.target.set(p2.x, p2.y, p2.z, 1);
	}

	/**
	 * Allow to get the normalized direction vector between a camera and a mesh
	 * @param camera the camera
	 * @return h3d.Vector Direction vector
	 */
	function directionCameraToMesh(camera:h3d.Camera, mesh:h3d.scene.Mesh):h3d.Vector
	{
		return new h3d.Vector(p2.x - camera.pos.x, p2.y - camera.pos.y, 0, 0).getNormalized();
	}

	static function main() {
		new Main();
	}
}
