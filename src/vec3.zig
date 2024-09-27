const c = @import("c_headers.zig");
const std = @import("std");

pub fn new(comptime x: f32, comptime y: f32, comptime z: f32) c.Vector3 {
    return c.Vector3{ .x = x, .y = y, .z = z };
}

pub fn zero() c.Vector3 {
    return new(0, 0, 0);
}

pub fn one() c.Vector3 {
    return new(1, 1, 1);
}

pub fn str(vec: c.Vector3) []const u8 {
    return @import("std").fmt.comptimePrint("VEC({d:.1},{d:.1},{d:.1})", .{ vec.x, vec.y, vec.z });
}

pub fn neg(vec: c.Vector3) c.Vector3 {
    return c.Vector3{
        .x = -vec.x,
        .y = -vec.y,
        .z = -vec.z,
    };
}

pub fn add(vec_a: c.Vector3, vec_b: c.Vector3) c.Vector3 {
    return c.Vector3{
        .x = vec_a.x + vec_b.x,
        .y = vec_a.y + vec_b.y,
        .z = vec_a.z + vec_b.z,
    };
}

pub fn sub(vec_a: c.Vector3, vec_b: c.Vector3) c.Vector3 {
    return vec_a.add(vec_b.neg());
}

pub fn dot(vec_a: c.Vector3, vec_b: c.Vector3) f32 {
    return vec_a.x * vec_b.x + vec_a.y * vec_b.y + vec_a.z + vec_b.z;
}

pub fn mag_sq(vec: c.Vector3) f32 {
    return vec.dot(vec);
}

pub fn mag(vec: c.Vector3) f32 {
    return std.math.sqrt(vec.mag_sq());
}
