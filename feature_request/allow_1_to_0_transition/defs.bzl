load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")

def _transition_impl(settings, attr):
    return [
        {
            "//:color": color,
        }
        for color in attr.colors
    ]

_transition = transition(
    implementation = _transition_impl,
    inputs = [
    ],
    outputs = [
        "//:color",
    ],
)

def _apply_transition_and_fail_impl(ctx):
    fail([
        target[BuildSettingInfo].value
        for target in ctx.split_attr._flag.values()
    ])

apply_transition_and_fail = rule(
    implementation = _apply_transition_and_fail_impl,
    attrs = {
        "colors": attr.string_list(),
        "_flag": attr.label(
            default = "//:color",
            cfg = _transition,
        ),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
)
