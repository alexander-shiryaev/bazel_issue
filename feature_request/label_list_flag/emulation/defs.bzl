load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")

def label_list_flag_emulation(
        name,
        implementation_token,
        build_setting_default,
        **kwargs):
    """A label_list-typed build setting that can be set on the command line.

    Args:
        implementation_token: __unspecified-type__

            The token returned from the `label_list_flag_emulation_implementation`.
            Type of the token is unspecified.

        build_setting_default: `label_list`

            Specifies default value for the build setting.

        **kwargs: standard attributes
    """
    return implementation_token(
        name = name,
        build_setting_default = build_setting_default,
        **kwargs
    )

def label_list_flag_emulation_implementation(
        label):
    """Creates an implementation token to be passed into `label_list_flag_emulation`.

    This function is required because Bazel API does not allow declaring rules in a macro call.
    Here the details: https://github.com/bazelbuild/bazel/issues/14673

    Returns
        The implementation token to be passed into `label_list_flag_emulation`.
        Type of the token is unspecified.

    Args:
        label: `string`

            Absolute label of the `label_list_flag_emulation` target
    """

    label_list_item_target_name = "@label_list_flag_emulation//:_item"

    def _label_list_flag_emulation_transition_impl(settings, attr):
        # Bazel does not preserve the order in 1-to-N transitions
        # We save the 'item_label_str' to restore the order later
        return {
            item_label_str: {label_list_item_target_name: Label("@//:all").relative(item_label_str)}
            for item_label_str in settings[label]
        }

    _label_list_flag_emulation_transition = transition(
        implementation = _label_list_flag_emulation_transition_impl,
        inputs = [
            label,
        ],
        outputs = [
            label_list_item_target_name,
        ],
    )

    def _label_list_flag_emulation_impl(ctx):
        targets = [
            ctx.split_attr._item[name][_LabelFlagInfo].actual
            for name in ctx.build_setting_value
        ]

        return [BuildSettingInfo(value = targets)]

    return rule(
        implementation = _label_list_flag_emulation_impl,
        build_setting = config.string_list(
            flag = True,
            repeatable = True,
        ),
        attrs = {
            "_item": attr.label(
                default = label_list_item_target_name,
                cfg = _label_list_flag_emulation_transition,
                aspects = [_label_flag_aspect],
            ),
            "_allowlist_function_transition": attr.label(
                default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
            ),
        },
    )

_LabelFlagInfo = provider(
    doc = """
        Used to get an actual target from the `label_flag`.

        If not used, alias target will be returned:
            "<alias target @label_list_flag_emulation//:_item of //my/target:name>"

        But we want the following:
            "<target //my/target:name>"
    """,
    fields = [
        "actual",
    ],
)

def _label_flag_aspect_impl(target, aspect_ctx):
    return [_LabelFlagInfo(actual = target)]

_label_flag_aspect = aspect(
    implementation = _label_flag_aspect_impl,
)
