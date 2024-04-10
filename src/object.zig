const std = @import("std");

const zrl = @import("raylib");

pub const Object = struct {
    position: zrl.Vector3,
    scale: zrl.Vector3,

    pub fn init(pos: zrl.Vector3, scl: zrl.Vector3) @This() {
        return @This(){
            .position = pos,
            .scale = scl,
        };
    }

    pub fn drawObject(self: @This()) void {
        zrl.DrawCubeV(self.position, self.scale, zrl.RED);
    }
};
