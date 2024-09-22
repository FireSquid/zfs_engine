const std = @import("std");

const c = @import("c_headers.zig");

const Vec3 = @import("vec3.zig").Vec3;

const Drawable = @import("objects/drawable/drawable.zig").Drawable;
const DebugSphere = @import("objects/drawable/debug_sphere.zig").DebugSphere;
const StaticModel = @import("objects/drawable/static_model.zig").StaticModel;
const Level = @import("level/level.zig").Level;
const Models = @import("models/models.zig");

const DrawList = std.ArrayList(Drawable);

pub const Camera = struct {
    const Self = @This();

    rl_cam: *c.Camera3D,
    allocator: std.mem.Allocator,

    draw_list: DrawList,

    move_base: *StaticModel,

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

        try draw_objs.append(StaticModel.init(Vec3.new(0, 0, 0), Vec3.one(), "object_base").drawable());
        try draw_objs.append(StaticModel.init(Vec3.new(19, 0, 0), Vec3.one(), "object_base").drawable());
        try draw_objs.append(StaticModel.init(Vec3.new(0, 0, 11), Vec3.one(), "object_base").drawable());
        try draw_objs.append(StaticModel.init(Vec3.new(19, 0, 11), Vec3.one(), "object_base").drawable());

        try draw_objs.append(StaticModel.init(Vec3.new(0, 0, 0), Vec3.one(), "ship_blank").drawable());
        try draw_objs.append(StaticModel.init(Vec3.new(19, 0, 0), Vec3.one(), "planet_blank").drawable());
        try draw_objs.append(StaticModel.init(Vec3.new(0, 0, 11), Vec3.one(), "planet_blank").drawable());
        try draw_objs.append(StaticModel.init(Vec3.new(19, 0, 11), Vec3.one(), "ship_blank").drawable());

        const new_move_base = try alloc.create(StaticModel);
        new_move_base.* = StaticModel.init(Vec3.new(0, 0, 0), Vec3.one(), "object_base");
        try draw_objs.append(new_move_base.drawable());

        return Self{
            .rl_cam = new_rl_cam,
            .allocator = alloc,
            .draw_list = draw_objs,
            .move_base = new_move_base,
        };
    }

    pub fn destroy(self: Self) void {
        self.allocator.destroy(self.rl_cam);
        self.allocator.destroy(self.move_base);
        self.draw_list.deinit();
    }

    pub fn drawFromCamera(self: *Self, mouse_pos: c.Vector2) void {
        const mouseRay = c.GetMouseRay(mouse_pos, self.rl_cam.*);
        const rayScale = -(mouseRay.position.y / mouseRay.direction.y);
        const floorPos = c.Vector3{
            .x = mouseRay.position.x + mouseRay.direction.x * rayScale,
            .y = 0,
            .z = mouseRay.position.z + mouseRay.direction.z * rayScale,
        };
        self.move_base.set_pos(floorPos);

        {
            c.BeginMode3D(self.rl_cam.*);
            defer c.EndMode3D();

            for (self.draw_list.items) |drawable| {
                drawable.draw();
            }

            self.move_base.draw();
        }

        c.DrawText(c.TextFormat("(%.1f,\t%.1f)", mouse_pos.x, mouse_pos.y), 10, 35, 20, c.LIME);
        c.DrawText(c.TextFormat("(%.1f,\t%.1f)", floorPos.x, floorPos.z), 10, 60, 20, c.LIME);

        self.move_base.draw_pos();
    }
};
