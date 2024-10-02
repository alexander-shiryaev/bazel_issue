def _feature_flag_impl(ctx):
    return config_common.FeatureFlagInfo(
        value = "feature_flag",
    )

feature_flag = rule(
    implementation = _feature_flag_impl,
    attrs = {
        "deps": attr.label_list(),
    },
)

def _require_toolchain_impl(ctx):
    print(ctx.toolchains["//:toolchain_type"].value)

require_toolchain = rule(
    implementation = _require_toolchain_impl,
    toolchains = [
        "//:toolchain_type",
    ],
)

def _some_toolchain_impl(ctx):
    return platform_common.ToolchainInfo(
        value = "some_toolchain",
    )

some_toolchain = rule(
    implementation = _some_toolchain_impl,
)
