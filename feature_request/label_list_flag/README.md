https://github.com/bazelbuild/bazel/issues/18723

### Description of the feature request:

I [have implemented](https://github.com/alexander-shiryaev/bazel_issue/tree/main/feature_request/label_list_flag/emulation)
the `label_list_flag` using the existing API, but the implementation has several issues:

1. It is divided into two parts - `label_list_flag_emulation` and `label_list_flag_emulation_implementation`
because rules cannot be used as lambda functions (https://github.com/bazelbuild/bazel/issues/14673).
2. Users are required to know the exact absolute label of the created `label_list_flag`, which is not ideal.
3. Applying an aspect to targets in this `label_list_flag` is very difficult. While technically possible,
the aspect needs to have knowledge of the specific implementation of the `label_list_flag` to access the referred targets.
4. The transition that changes the `label_list_flag` requires operating on strings instead of labels.
This demonstrates that the abstraction is leaky.

Having a native implementation will resolve all the aforementioned issues.


### What underlying problem are you trying to solve with this feature?

I want to have a user-configurable list of targets.


### What is the output of `bazel info release`?

release 6.1.0


### Have you found anything relevant by searching the web?

https://github.com/bazelbuild/bazel/issues/17477
https://github.com/bazelbuild/bazel/issues/17828


### Any other information, logs, or outputs that you want to share?

Working example: https://github.com/alexander-shiryaev/bazel_issue/blob/main/feature_request/label_list_flag/example/BUILD.bazel
