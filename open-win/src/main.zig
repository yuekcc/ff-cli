// powershell -c "Invoke-Item docutil-logo.png"

const std = @import("std");
const process = std.process;

const allocator = std.heap.page_allocator;

fn invokeFile(a: std.mem.Allocator, path: []const u8) !void {
    const script = try std.fmt.allocPrint(a, "Invoke-Item \"{s}\"", .{path});

    const argv = &[_][]const u8{
        "powershell",
        "-c",
        script,
    };
    var child = process.Child.init(argv, a);
    try child.spawn();
}

pub fn main() !void {
    var args_iter = try std.process.argsWithAllocator(allocator);
    defer args_iter.deinit();
    _ = args_iter.next().?;
    const filepath = args_iter.next().?;
    try invokeFile(allocator, filepath);
}
