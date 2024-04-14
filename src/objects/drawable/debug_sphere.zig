const std = @import("std");

const c = @import("../../c_headers.zig");

const Drawable = @import("drawable.zig").Drawable;

/// Debug sphere at a location
pub const DebugSphere = struct {
    const Self = @This();

    position: c.Vector3,
    scale: f32,

    pub fn init(pos: c.Vector3, scl: f32) Self {
        return Self{
            .position = pos,
            .scale = scl,
        };
    }

    pub fn draw(self: Self) void {
        c.DrawSphere(self.position, self.scale, c.PINK);
    }

    pub fn drawable(self: Self) Drawable {
        return Drawable{ .debugSphere = self };
    }
};
