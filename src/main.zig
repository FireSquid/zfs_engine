const std = @import("std");
const Game = @import("game.zig").Game;

const window_title = "3d Visual Test";
const screen_width = 1920;
const screen_height = 1080;
const target_fps = 144;

pub fn main() !void {
    const c = @import("c_headers.zig");

    std.debug.assert(c.ChangeDirectory(c.GetApplicationDirectory()));

    try Game.startGameWindowLoop(window_title, screen_width, screen_height, target_fps);
}
