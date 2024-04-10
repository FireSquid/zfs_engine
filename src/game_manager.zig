const std = @import("std");
const cam = @import("camera.zig");

const zrl = @import("raylib");

pub const GameManager = struct {
    main_camera: cam.Camera,

    fn create(alloc: std.mem.Allocator) !@This() {
        return @This(){
            .main_camera = try cam.Camera.create(
                alloc,
                zrl.Vector3{ .x = 0.0, .y = 0.0, .z = 0.0 },
                zrl.Vector3{ .x = 1.0, .y = 0.0, .z = 0.0 },
                zrl.Vector3{ .x = 0.0, .y = 1.0, .z = 0.0 },
                70.0,
                zrl.CameraProjection.CAMERA_PERSPECTIVE,
            ),
        };
    }

    fn kill(self: @This(), alloc: std.mem.Allocator) void {
        self.main_camera.kill(alloc);
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

        zrl.InitWindow(width, height, title);
        defer zrl.CloseWindow();

        zrl.SetTargetFPS(fps_target);

        const manager = try GameManager.create(allocator);
        defer manager.kill(allocator);

        while (!zrl.WindowShouldClose()) {
            manager.drawWindow();
        }
    }

    fn drawWindow(self: @This()) void {
        self.main_camera.update();

        zrl.BeginDrawing();
        defer zrl.EndDrawing();

        zrl.ClearBackground(zrl.BLACK);

        zrl.DrawFPS(10, 10);

        (&self.main_camera).drawFromCamera();
    }
};
