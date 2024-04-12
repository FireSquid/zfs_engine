const std = @import("std");

const c = struct {
    usingnamespace @import("c_headers.zig");
};

pub const Object = struct {
    position: c.Vector3,
    scale: c.Vector3,

    pub fn init(pos: c.Vector3, scl: c.Vector3) @This() {
        return @This(){
            .position = pos,
            .scale = scl,
        };
    }

    pub fn drawObject(self: @This()) void {
        c.DrawCubeV(self.position, self.scale, c.RED);
    }
};
