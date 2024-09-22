const std = @import("std");

const c = @import("../../c_headers.zig");

const Drawable = @import("drawable.zig").Drawable;

const Models = @import("../../models/models.zig");

pub const StaticModel = struct {
    const Self = @This();

    position: c.Vector3,
    scale: c.Vector3,
    model: c.Model,

    pub fn init(pos: c.Vector3, scl: c.Vector3, comptime modelName: []const u8) Self {
        return @This(){
            .position = pos,
            .scale = scl,
            .model = Models.getModelByName(modelName),
        };
    }

    pub fn draw(self: Self) void {
        c.DrawModel(self.model, self.position, self.scale.x, c.WHITE);
    }

    pub fn draw_pos(self: Self) void {
        c.DrawText(c.TextFormat("%.1f | %.1f", self.position.x, self.position.z), 10, 100, 20, c.LIME);
    }

    pub fn drawable(self: Self) Drawable {
        return Drawable{ .staticModel = self };
    }

    pub fn set_pos(self: *Self, new_pos: c.Vector3) void {
        self.position = new_pos;
    }
};
