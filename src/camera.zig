const std = @import("std");
const Object = @import("object.zig").Object;

const zrl = @import("raylib");

pub const Camera = struct {
    rl_cam: *zrl.Camera3D,
    test_cube: Object,

    pub fn create(alloc: std.mem.Allocator, pos: zrl.Vector3, tgt: zrl.Vector3, up: zrl.Vector3, v_fov: f32, proj: zrl.CameraProjection) !@This() {
        const new_rl_cam = try alloc.create(zrl.Camera3D);
        new_rl_cam.* = zrl.Camera3D{
            .position = pos,
            .target = tgt,
            .up = up,
            .fovy = v_fov,
            .projection = proj,
        };

        return @This(){
            .rl_cam = new_rl_cam,
            .test_cube = Object.init(
                zrl.Vector3{ .x = 5.0, .y = 0.0, .z = 5.0 },
                zrl.Vector3{ .x = 1.0, .y = 1.0, .z = 1.0 },
            ),
        };
    }

    pub fn kill(self: @This(), alloc: std.mem.Allocator) void {
        alloc.destroy(self.rl_cam);
    }

    pub fn update(self: @This()) void {
        //zrl.UpdateCamera(self.rl_cam, zrl.CameraMode.CAMERA_FREE);
        self.rl_cam.*.target.x -= 0.01;
    }

    pub fn drawFromCamera(self: @This()) void {
        zrl.BeginMode3D(self.rl_cam.*);
        defer zrl.EndMode3D();

        self.test_cube.drawObject();
    }
};
