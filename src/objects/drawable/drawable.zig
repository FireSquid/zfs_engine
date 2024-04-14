const std = @import("std");

const DebugSphere = @import("debug_sphere.zig").DebugSphere;

pub const Drawable = union(enum) {
    debugSphere: DebugSphere,

    pub inline fn draw(self: @This()) void {
        switch (self) {
            Drawable.debugSphere => |ds| ds.draw(),
        }
    }
};
