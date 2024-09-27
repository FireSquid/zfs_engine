const c = @import("../c_headers.zig");

const std = @import("std");

const game = @import("../game.zig");

pub fn GetMouseFloorPosition(camera_override: ?*const @import("../camera.zig").Camera) c.Vector3 {
    const camera = camera_override orelse game.main_camera orelse unreachable;

    const mouse_ray = c.GetMouseRay(c.GetMousePosition(), camera.rl_cam.*);
    const ray_scale = -(mouse_ray.position.y / mouse_ray.direction.y);
    const floor_pos = c.Vector3{
        .x = mouse_ray.position.x + mouse_ray.direction.x * ray_scale,
        .y = 0,
        .z = mouse_ray.position.z + mouse_ray.direction.z * ray_scale,
    };

    return floor_pos;
}
