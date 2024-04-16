const std = @import("std");

const DebugSphere = @import("debug_sphere.zig").DebugSphere;
const StaticModel = @import("static_model.zig").StaticModel;

pub const Drawable = union(enum) {
    const Self = @This();

    debugSphere: DebugSphere,
    staticModel: StaticModel,

    pub fn draw(self: Self) void {
        switch (self) {
            Self.debugSphere => |ds| ds.draw(),
            Self.staticModel => |sm| sm.draw(),
        }
    }

    pub fn destroy(self: Self) void {
        switch (self) {
            Self.debugSphere => {},
            Self.staticModel => {},
        }
    }
};
