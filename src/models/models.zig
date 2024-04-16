const std = @import("std");

const c = @import("../c_headers.zig");

const ModelMap = std.StringHashMap(c.Model);

pub var models: ModelMap = undefined;

const resourcePath = "../../resources/";

pub fn loadModels(alloc: std.mem.Allocator) !void {
    models = ModelMap.init(alloc);

    try addModelLoad("turret_test");
}

pub fn unloadModels() void {
    var modelIt = models.iterator();
    while (modelIt.next()) |model| {
        c.UnloadModel(model.value_ptr.*);
    }
    models.deinit();
}

pub fn addModelLoad(comptime name: []const u8) !void {
    const filepath = (resourcePath ++ name ++ ".obj");

    std.log.info("Loading model: {s}", .{filepath});

    try models.put(name, c.LoadModel(filepath));
}

pub fn getModelByName(comptime name: []const u8) c.Model {
    return models.get(name).?;
}
