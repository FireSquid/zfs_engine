const std = @import("std");

const c = @import("../c_headers.zig");

const ModelMap = std.StringHashMap(c.Model);

pub var models: ModelMap = undefined;

const resourcePath = "../../resources/";

const modelNames = .{
    "turret_test",
    "object_base",
    "planet_blank",
    "ship_blank",
};

pub fn loadModels(alloc: std.mem.Allocator) !void {
    models = ModelMap.init(alloc);

    inline for (modelNames) |modelName| {
        addModelLoad(modelName) catch {
            std.debug.print("Failed to load model: {s}", .{modelName});
        };
    }
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
