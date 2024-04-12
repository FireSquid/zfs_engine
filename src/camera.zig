const std = @import("std");
const Object = @import("object.zig").Object;

const c = struct {
    usingnamespace @import("c_headers.zig");
};

pub const Camera = struct {
    rl_cam: *c.Camera3D,
    test_cube: Object,

    pub fn create(alloc: std.mem.Allocator, pos: c.Vector3, tgt: c.Vector3, up: c.Vector3, v_fov: f32, proj: c_int) !@This() {
        const new_rl_cam = try alloc.create(c.Camera3D);
        new_rl_cam.* = c.Camera3D{
            .position = pos,
            .target = tgt,
            .up = up,
            .fovy = v_fov,
            .projection = proj,
        };

        return @This(){
            .rl_cam = new_rl_cam,
            .test_cube = Object.init(
                c.Vector3{ .x = 5.0, .y = 0.0, .z = 5.0 },
                c.Vector3{ .x = 1.0, .y = 1.0, .z = 1.0 },
            ),
        };
    }

    pub fn kill(self: @This(), alloc: std.mem.Allocator) void {
        alloc.destroy(self.rl_cam);
    }

    pub fn update(self: @This()) void {
        //c.UpdateCamera(self.rl_cam, c.CameraMode.CAMERA_FREE);
        self.rl_cam.*.target.x -= 0.01;
    }

    pub fn drawFromCamera(self: @This()) void {
        c.BeginMode3D(self.rl_cam.*);
        defer c.EndMode3D();

        self.test_cube.drawObject();
    }
};
