const std = @import("std");

const c = @import("c_headers.zig");

const Vec3 = @import("vec3.zig").Vec3;

const Drawable = @import("objects/drawable/drawable.zig").Drawable;
const DebugSphere = @import("objects/drawable/debug_sphere.zig").DebugSphere;
const StaticModel = @import("objects/drawable/static_model.zig").StaticModel;

const DrawList = std.ArrayList(Drawable);

pub const Camera = struct {
    const Self = @This();

    rl_cam: *c.Camera3D,
    allocator: std.mem.Allocator,

    draw_list: DrawList,

    pub fn create(alloc: std.mem.Allocator, pos: c.Vector3, tgt: c.Vector3, up: c.Vector3, v_fov: f32, proj: c_int) !Self {
        const new_rl_cam = try alloc.create(c.Camera3D);
        new_rl_cam.* = c.Camera3D{
            .position = pos,
            .target = tgt,
            .up = up,
            .fovy = v_fov,
            .projection = proj,
        };

        var draw_objs = DrawList.init(alloc);

        inline for (0..10) |num| {
            try draw_objs.append(DebugSphere.init(Vec3.new(5, 1, num), 0.2).drawable());
        }
        inline for (0..4) |num| {
            try draw_objs.append(StaticModel.init(Vec3.new(num * 2, -2, 5), Vec3.one(), "turret_test").drawable());
        }

        return Self{
            .rl_cam = new_rl_cam,
            .allocator = alloc,
            .draw_list = draw_objs,
        };
    }

    pub fn destroy(self: Self) void {
        self.allocator.destroy(self.rl_cam);
        self.draw_list.deinit();
    }

    pub fn drawFromCamera(self: Self) void {
        c.BeginMode3D(self.rl_cam.*);
        defer c.EndMode3D();

        for (self.draw_list.items) |drawable| {
            drawable.draw();
        }
    }
};
