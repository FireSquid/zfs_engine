const std = @import("std");

const c = @import("c_headers.zig");

const Vec3 = @import("vec3.zig");

const Drawable = @import("objects/drawable/drawable.zig").Drawable;
const DebugSphere = @import("objects/drawable/debug_sphere.zig").DebugSphere;
const StaticModel = @import("objects/drawable/static_model.zig").StaticModel;
const Level = @import("level/level.zig").Level;
const Models = @import("models/models.zig");
const ObjectList = @import("objects/object_list.zig").ObjectList;

const DrawList = std.ArrayList(Drawable);

pub const Camera = struct {
    const Self = @This();

    rl_cam: *c.Camera3D,
    allocator: std.mem.Allocator,

    pub fn create(alloc: std.mem.Allocator, pos: c.Vector3, tgt: c.Vector3, up: c.Vector3, v_fov: f32, proj: c_int) !Self {
        const new_rl_cam = try alloc.create(c.Camera3D);
        new_rl_cam.* = c.Camera3D{
            .position = pos,
            .target = tgt,
            .up = up,
            .fovy = v_fov,
            .projection = proj,
        };

        return Self{
            .rl_cam = new_rl_cam,
            .allocator = alloc,
        };
    }

    pub fn destroy(self: Self) void {
        self.allocator.destroy(self.rl_cam);
    }

    pub fn drawFromCamera(self: *Self, obj_list: ObjectList) void {
        {
            c.BeginMode3D(self.rl_cam.*);
            defer c.EndMode3D();

            for (obj_list.modelList.items) |model| {
                model.draw();
            }
        }
    }
};
