const std = @import("std");
const DebugObj = @import("debug_object.zig").DebugObject;
const ModelObj = @import("simple_model.zig").SimpleModel;

const c = @import("c_headers.zig");

pub const Camera = struct {
    rl_cam: *c.Camera3D,
    debugObj: DebugObj,
    modelObj: ModelObj,

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
            .debugObj = DebugObj.init(
                c.Vector3{ .x = 5.0, .y = 0.0, .z = 5.0 },
                0.1,
            ),
            .modelObj = ModelObj.create(.{ .x = 5.0, .y = 0.0, .z = 5.0 }, .{ .x = 1.0, .y = 1.0, .z = 1.0 }, "../../resources/turret_test.obj"),
        };
    }

    pub fn kill(self: @This(), alloc: std.mem.Allocator) void {
        alloc.destroy(self.rl_cam);
        self.modelObj.destroy();
    }

    pub fn update(self: @This()) void {
        _ = self;
    }

    pub fn drawFromCamera(self: @This()) void {
        c.BeginMode3D(self.rl_cam.*);
        defer c.EndMode3D();

        self.debugObj.draw();
        self.modelObj.draw();
    }
};
