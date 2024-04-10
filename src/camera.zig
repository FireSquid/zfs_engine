const std = @import("std");

const zrl = @import("raylib");

pub const Camera = struct {
    rl_cam: *zrl.Camera3D,

    pub fn create(alloc: std.mem.Allocator, pos: zrl.Vector3, tgt: zrl.Vector3, up: zrl.Vector3, v_fov: f32, proj: zrl.CameraProjection) !@This() {
        const new_rl_cam = try alloc.create(zrl.Camera3D);
        new_rl_cam.* = zrl.Camera3D{
            .position = pos,
            .target = tgt,
            .up = up,
            .fovy = v_fov,
            .projection = proj,
        };

        return .{
            .rl_cam = new_rl_cam,
        };
    }

    pub fn kill(self: @This(), alloc: std.mem.Allocator) void {
        alloc.destroy(self.rl_cam);
    }

    pub fn update(self: @This()) void {
        zrl.UpdateCamera(self.rl_cam, zrl.CameraMode.CAMERA_ORBITAL);
    }

    pub fn drawFromCamera(self: @This()) void {
        zrl.BeginMode3D(self.rl_cam.*);
        defer zrl.EndMode3D();
    }
};
