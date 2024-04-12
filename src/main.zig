const std = @import("std");
const gm = @import("game_manager.zig");

const print = std.debug.print;

const window_title = "3d Visual Test";
const screen_width = 1920;
const screen_height = 1080;
const target_fps = 144;

pub fn main() !void {
    try gm.GameManager.startGameWindowLoop(window_title, screen_width, screen_height, target_fps);
}
