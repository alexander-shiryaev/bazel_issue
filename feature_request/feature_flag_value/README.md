https://github.com/bazelbuild/bazel/issues/18911

### Description of the feature request:

I would like to pass a computed string to an arbitrary rule. If the string can only take a finite number of values,
the problem can be solved by implementing a rule that returns `config_common.FeatureFlagInfo` and a set of config_setting,
one for each of the allowed values (see `resolve_feature_flag_emulation`).
```
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
```

However, if the string can have an unlimited number of values, there is currently no way to achieve the desired functionality.

In [this example](https://github.com/alexander-shiryaev/bazel_issue/blob/main/feature_request/feature_flag_value/BUILD.bazel),
you can see how the value of the `shared_lib_name` attribute should be computed based on the given `string_flag`.

My suggestion is to implement the `resolve_feature_flag` operator, which would function similarly to `select` and
convert the value from `config_common.FeatureFlagInfo` to a string, similar to how `resolve_feature_flag_emulation` works.
However, it should support an unlimited set of values.


### What underlying problem are you trying to solve with this feature?

I want to have an ability to pass computed values to the rule attributes.


### What is the output of `bazel info release`?

release 6.1.0


### Have you found anything relevant by searching the web?

No.


### Any other information, logs, or outputs that you want to share?

Code for this proposal: https://github.com/alexander-shiryaev/bazel_issue/tree/main/feature_request/feature_flag_value
