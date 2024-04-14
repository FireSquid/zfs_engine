const c = @import("c_headers.zig");

pub const Vec3 = struct {
    pub fn new(comptime x: f32, comptime y: f32, comptime z: f32) c.Vector3 {
        return c.Vector3{ .x = x, .y = y, .z = z };
    }

    pub fn zero() c.Vector3 {
        return Vec3.new(0, 0, 0);
    }

    pub fn one() c.Vector3 {
        return Vec3.new(1, 1, 1);
    }
};
