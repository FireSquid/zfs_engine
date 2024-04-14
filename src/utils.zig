const c = @import("c_headers.zig");

pub const vec3 = struct {
    pub fn new(comptime x: f32, comptime y: f32, comptime z: f32) c.Vector3 {
        return c.Vector3{ .x = x, .y = y, .z = z };
    }

    pub fn zero() c.Vector3 {
        return c.Vector3{};
    }
};
