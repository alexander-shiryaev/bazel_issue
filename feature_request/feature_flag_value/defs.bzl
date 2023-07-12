load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")

def _shared_lib_name_info_impl(ctx):
    return [
        config_common.FeatureFlagInfo(
            value = ctx.attr._prefix[BuildSettingInfo].value + ctx.attr.basename,
        ),
    ]

shared_lib_name_info = rule(
    implementation = _shared_lib_name_info_impl,
    attrs = {
        "basename": attr.string(mandatory = True),
        "_prefix": attr.label(
            default = "@feature_flag_value//:shared_lib_name_prefix",
        ),
    },
)

def not_implemented(*args):
    return "not_implemented"
