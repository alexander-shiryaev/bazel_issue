https://github.com/bazelbuild/bazel/issues/19752

### Description of the feature request:

Bazel supports 1-to-N transitions, but not if `N == 0`. Let me show an example:

```bzl
# //:BUILD.bazel
load(":defs.bzl", "apply_transition_and_fail")
load("@bazel_skylib//rules:common_settings.bzl", "string_flag")

string_flag(
    name = "color",
    build_setting_default = "default",
    visibility = ["//visibility:public"],
)

apply_transition_and_fail(
    name = "three",
    colors = ["red", "green", "blue"],
)

apply_transition_and_fail(
    name = "zero",
    colors = [],
)

# //:defs.bzl
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
```

If we run `bazel build //:three`, then the result will be as desired:
```
Error in fail: ["blue", "green", "red"]
```

But if we run `bazel build //:zero`, then the result will be surprising:
```
Error in fail: ["default"]
```


### Which category does this issue belong to?

Configurability


### What underlying problem are you trying to solve with this feature?

I want to make a 1-to-N transition, but N may occasionally be zero.


### What is the output of `bazel info release`?

release 6.1.0


### Any other information, logs, or outputs that you want to share?

Code for this proposal: https://github.com/alexander-shiryaev/bazel_issue/tree/main/feature_request/allow_1_to_0_transition
