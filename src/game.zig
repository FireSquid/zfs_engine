const std = @import("std");
const cam = @import("camera.zig");

const c = @import("c_headers.zig");

const Vec3 = @import("vec3.zig");

const model = @import("models/models.zig");
const ObjectList = @import("objects/object_list.zig").ObjectList;
const mouse = @import("input/mouse.zig");

pub var main_camera: ?*cam.Camera = null;

pub const Game = struct {
    const Self = @This();

    main_camera: cam.Camera,
    obj_list: ObjectList,
    base_handle: ?usize,

    fn create(alloc: std.mem.Allocator) !Self {
        return Self{
            .main_camera = try cam.Camera.create(
                alloc,
                Vec3.new(10, 10, -6),
                Vec3.new(10, 0, 6),
                Vec3.new(0, 1, 0),
                70.0,
                c.CAMERA_PERSPECTIVE,
            ),
            .obj_list = ObjectList.create(alloc),
            .base_handle = null,
        };
    }

    fn destroy(self: Self) void {
        self.main_camera.destroy();
        self.obj_list.destroy();
    }

    pub fn startGameWindowLoop(title: [*c]const u8, width: i32, height: i32, fps_target: i32) !void {
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        defer {
            switch (gpa.deinit()) {
                .leak => @panic("=========== Detected Memory Leak ============"),
                else => {},
            }
        }

        // -- Initialize raylib
        c.InitWindow(width, height, title);
        defer c.CloseWindow();
        c.SetTargetFPS(fps_target);

        // -- Load in models
        model.loadModels(allocator) catch {
            std.debug.panic("Model loading failed.\n", .{});
        };
        defer model.unloadModels();

        var game = try Game.create(allocator);
        defer game.destroy();

        main_camera = &game.main_camera;

        game.base_handle = try game.obj_list.addModel(Vec3.new(9, 0, 9), Vec3.one(), "planet_blank");

        while (!c.WindowShouldClose()) {
            game.gameLogic();
            game.drawWindow();
        }
    }

    fn drawWindow(self: *Self) void {
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.BLACK);

        c.DrawFPS(10, 10);

        self.main_camera.drawFromCamera(&self.obj_list);
    }

    fn gameLogic(self: *Self) void {
        const ray_col: c.RayCollision = c.GetRayCollisionSphere(c.GetMouseRay(c.GetMousePosition(), main_camera.?.rl_cam.*), Vec3.new(9, 2, 9), 1);
        if (ray_col.hit) {
            self.obj_list.modelList.items[self.base_handle.?].set_pos(Vec3.new(9, 2, 9));
        } else {
            self.obj_list.modelList.items[self.base_handle.?].set_pos(Vec3.new(9, 0, 9));
        }
    }
};
