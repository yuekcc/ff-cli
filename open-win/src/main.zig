// powershell -c "Invoke-Item docutil-logo.png"

const std = @import("std");
const process = std.process;
const windows = std.os.windows;

// SHELLEXECUTEINFOW
const ShellExecuteInfo = extern struct {
    cbSize: u32,
    fMask: u32,
    hwnd: ?windows.HWND,
    lpVerb: ?[*:0]const u16,
    lpFile: ?[*:0]const u16,
    lpParameters: ?[*:0]const u16,
    lpDirectory: ?[*:0]const u16,
    nShow: i32,
    hInstApp: ?windows.HINSTANCE,
    lpIDList: ?*anyopaque,
    lpClass: ?[*:0]const u16,
    hkeyClass: ?windows.HKEY,
    dwHotKey: u32,
    Anonymous: extern union {
        hIcon: ?windows.HANDLE,
        hMonitor: ?windows.HANDLE,
    },
    hProcess: ?windows.HANDLE,
};

pub extern "shell32" fn ShellExecuteExW(
    pExecInfo: ?*ShellExecuteInfo,
) callconv(.winapi) windows.BOOL;

// 定义常量
const SEE_MASK_NOCLOSEPROCESS = 0x00000040;
const SW_SHOW = 5;

const allocator = std.heap.page_allocator;

pub fn main(init: std.process.Init) !void {
    const arena: std.mem.Allocator = init.arena.allocator();
    var args_iter = try init.minimal.args.iterateAllocator(arena);
    defer args_iter.deinit();
    _ = args_iter.next() orelse unreachable;
    const filepath = args_iter.next() orelse unreachable;

    var sei: ShellExecuteInfo = .{
        .cbSize = @sizeOf(ShellExecuteInfo),
        .fMask = SEE_MASK_NOCLOSEPROCESS,
        .hwnd = null,
        .lpVerb = try std.unicode.utf8ToUtf16LeAllocZ(allocator, "open"),
        .lpFile = try std.unicode.utf8ToUtf16LeAllocZ(allocator, filepath),
        .lpParameters = null,
        .lpDirectory = null,
        .nShow = SW_SHOW,
        .hInstApp = null,
        .lpIDList = null,
        .lpClass = null,
        .hkeyClass = null,
        .dwHotKey = 0,
        .Anonymous = .{
            .hMonitor = null,
        },
        .hProcess = null,
    };

    const result = ShellExecuteExW(&sei);
    process.exit(if (result.toBool())  1 else 0);
}
