const std = @import("std");
const DebugObj = @import("debug_object.zig").DebugObject;
const ModelObj = @import("simple_model.zig").SimpleModel;

const c = @import("c_headers.zig");

const vec3 = @import("utils.zig").vec3;

const Drawable = @import("objects/drawable/drawable.zig").Drawable;
const DebugSphere = @import("objects/drawable/debug_sphere.zig").DebugSphere;

const DrawList = std.ArrayList(Drawable);

pub const Camera = struct {
    const Self = @This();

    rl_cam: *c.Camera3D,
    debug_obj: DebugObj,
    model_obj: ModelObj,
    allocator: *std.mem.Allocator,

    draw_list: DrawList,

    pub fn create(alloc: *std.mem.Allocator, pos: c.Vector3, tgt: c.Vector3, up: c.Vector3, v_fov: f32, proj: c_int) !Self {
        const new_rl_cam = try alloc.create(c.Camera3D);
        new_rl_cam.* = c.Camera3D{
            .position = pos,
            .target = tgt,
            .up = up,
            .fovy = v_fov,
            .projection = proj,
        };

        var draw_objs = DrawList.init(alloc.*);

        inline for (0..10) |num| {
            try draw_objs.append(DebugSphere.init(vec3.new(5, 1, num), 0.2).drawable());
        }

        return Self{
            .rl_cam = new_rl_cam,
            .debug_obj = DebugObj.init(
                vec3.new(5, 0, 5),
                0.1,
            ),
            .model_obj = ModelObj.create(vec3.new(5, 0, 5), vec3.new(1, 1, 1), "../../resources/turret_test.obj"),
            .allocator = alloc,
            .draw_list = draw_objs,
        };
    }

    pub fn destroy(self: Self) void {
        self.allocator.destroy(self.rl_cam);
        self.model_obj.destroy();
        self.draw_list.deinit();
    }

    pub fn drawFromCamera(self: Self) void {
        c.BeginMode3D(self.rl_cam.*);
        defer c.EndMode3D();

        self.debug_obj.draw();
        self.model_obj.draw();

        for (self.draw_list.items) |drawable| {
            drawable.draw();
        }
    }
};
