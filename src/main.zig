const std = @import("std");

const zrl = @import("raylib");

const print = std.debug.print;

pub fn main() !void {
    zrl.SetConfigFlags(zrl.ConfigFlags{ .FLAG_WINDOW_RESIZABLE = true });
    zrl.InitWindow(800, 800, "hello world!");
    zrl.SetTargetFPS(60);

    defer zrl.CloseWindow();

    while (!zrl.WindowShouldClose()) {
        zrl.BeginDrawing();
        defer zrl.EndDrawing();

        zrl.ClearBackground(zrl.BLACK);
        zrl.DrawFPS(10, 10);

        zrl.DrawText("hello world!", 100, 100, 20, zrl.YELLOW);
    }
}
