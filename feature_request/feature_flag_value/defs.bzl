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

def resolve_feature_flag_emulation(allowed_values):
    def _(feature_flag_name):
        cases = {}

        for index, feature_flag_value in enumerate(allowed_values):
            config_setting_name = "{}-{}".format(feature_flag_name, index)

            native.config_setting(
                name = config_setting_name,
                flag_values = {feature_flag_name: feature_flag_value},
                visibility = ["//visibility:private"],
            )

            cases[config_setting_name] = feature_flag_value

        return select(cases, no_match_error = "unable to resolve feature flag: allowed_values = {}".format(allowed_values))

    return _
