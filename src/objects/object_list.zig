const c = @import("../c_headers.zig");

const std = @import("std");

const StaticModel = @import("./drawable/static_model.zig").StaticModel;

const ModelList = std.ArrayList(StaticModel);

pub const ObjectList = struct {
    const Self = @This();

    alloc: std.mem.Allocator,
    modelList: ModelList,

    pub fn create(allocator: std.mem.Allocator) Self {
        return Self{
            .alloc = allocator,
            .modelList = ModelList.init(allocator),
        };
    }

    pub fn destroy(self: Self) void {
        self.modelList.deinit();
    }

    pub fn addModel(self: *Self, position: c.Vector3, scale: c.Vector3, comptime modelName: []const u8) !usize {
        const handle = self.modelList.items.len;
        try self.modelList.append(StaticModel.init(position, scale, modelName));
        return handle;
    }
};
