const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const pic = b.option(bool, "pic", "Enable Position Independent Code option");

    const upstream = b.dependency("ogg", .{});

    const lib = b.addLibrary(.{
        .name = "ogg",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .pic = pic,
        }),
    });

    lib.root_module.addCSourceFiles(.{
        .root = upstream.path(""),
        .files = &.{
            "src/bitwise.c",
            "src/framing.c",
        },
        .language = .c,
    });

    lib.root_module.addIncludePath(upstream.path("include"));
    lib.root_module.addIncludePath(b.path("include"));

    lib.installHeadersDirectory(upstream.path("include"), "", .{});
    lib.installHeadersDirectory(b.path("include"), "", .{});
    b.installArtifact(lib);
}
