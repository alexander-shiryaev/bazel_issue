load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")

def _print_and_fail_impl(ctx):
    fail("This fail is intentional: {label} = {value}".format(
        label = ctx.attr.label_list_flag_emulation.label,
        value = ctx.attr.label_list_flag_emulation[BuildSettingInfo].value,
    ))

print_and_fail = rule(
    implementation = _print_and_fail_impl,
    attrs = {
        "label_list_flag_emulation": attr.label(mandatory = True),
    },
)
