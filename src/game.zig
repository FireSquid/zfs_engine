const std = @import("std");
const cam = @import("camera.zig");

const c = @import("c_headers.zig");

const Vec3 = @import("vec3.zig").Vec3;

const model = @import("models/models.zig");

pub const Game = struct {
    const Self = @This();

    main_camera: cam.Camera,

    fn create(alloc: std.mem.Allocator) !Self {
        return Self{
            .main_camera = try cam.Camera.create(
                alloc,
                Vec3.new(0, 5, 0),
                Vec3.new(5, 0, 5),
                Vec3.new(0, 1, 0),
                70.0,
                c.CAMERA_PERSPECTIVE,
            ),
        };
    }

    fn destroy(self: Self) void {
        self.main_camera.destroy();
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

        const game = try Game.create(allocator);
        defer game.destroy();

        while (!c.WindowShouldClose()) {
            game.drawWindow();
        }
    }

    fn drawWindow(self: Self) void {
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.BLACK);

        c.DrawFPS(10, 10);

        (&self.main_camera).drawFromCamera();
    }
};
