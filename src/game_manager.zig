const std = @import("std");
const cam = @import("camera.zig");

const c = @import("c_headers.zig");

pub const GameManager = struct {
    const Self = @This();

    main_camera: cam.Camera,

    fn create(alloc: *std.mem.Allocator) !Self {
        return Self{
            .main_camera = try cam.Camera.create(
                alloc,
                c.Vector3{ .x = 0.0, .y = 0.0, .z = 0.0 },
                c.Vector3{ .x = 5.0, .y = 0.0, .z = 5.0 },
                c.Vector3{ .x = 0.0, .y = 1.0, .z = 0.0 },
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
        var allocator = gpa.allocator();
        defer {
            switch (gpa.deinit()) {
                .leak => @panic("=========== Detected Memory Leak ============"),
                else => {},
            }
        }

        c.InitWindow(width, height, title);
        defer c.CloseWindow();

        c.SetTargetFPS(fps_target);

        const manager = try GameManager.create(&allocator);
        defer manager.destroy();

        while (!c.WindowShouldClose()) {
            manager.drawWindow();
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
