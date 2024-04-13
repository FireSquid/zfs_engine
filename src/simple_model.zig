const std = @import("std");

const c = @import("c_headers.zig");

pub const SimpleModel = struct {
    position: c.Vector3,
    scale: c.Vector3,
    model: c.Model,

    pub fn create(pos: c.Vector3, scl: c.Vector3, modelFile: [*c]const u8) @This() {
        return @This(){
            .position = pos,
            .scale = scl,
            .model = c.LoadModel(modelFile),
        };
    }

    pub fn destroy(self: @This()) void {
        c.UnloadModel(self.model);
    }

    pub fn draw(self: @This()) void {
        c.DrawModel(self.model, self.position, self.scale.x, c.WHITE);
    }
};
