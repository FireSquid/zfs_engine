const std = @import("std");

const c = @import("c_headers.zig");

/// Debug sphere at a location
pub const DebugObject = struct {
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
};
