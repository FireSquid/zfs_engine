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

    pub fn str(vec: c.Vector3) []const u8 {
        return @import("std").fmt.comptimePrint("VEC({d:.1},{d:.1},{d:.1})", .{ vec.x, vec.y, vec.z });
    }
};
