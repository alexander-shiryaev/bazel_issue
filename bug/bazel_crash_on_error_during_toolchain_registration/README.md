https://github.com/bazelbuild/bazel/issues/TODO

### Description of the bug:

Bazel crashes if, when registering a toolchain, in the chain of its dependencies
it encounters a target with `target_compatible_with = ["@platforms//:incompatible"]` set.

```
Starting local Bazel server and connecting to it...
Computing main repo mapping: 
Computing main repo mapping: 
Computing main repo mapping: 
Computing main repo mapping: 
Loading: 
Loading: 0 packages loaded
Analyzing: target //:require_toolchain (1 packages loaded, 0 targets configured)
Analyzing: target //:require_toolchain (1 packages loaded, 0 targets configured)
[0 / 1] checking cached actions
FATAL: bazel crashed due to an internal error. Printing stack trace:
java.lang.RuntimeException: Unrecoverable error while evaluating node 'ConfiguredTargetKey{label=//:toolchain, config=BuildConfigurationKey[60f5dea2735e7a00db22cffca4067ff08ba19e8732f149961005afa9128121f4]}' (requested by nodes 'RegisteredToolchainsValue.Key{configurationKey: BuildConfigurationKey[60f5dea2735e7a00db22cffca4067ff08ba19e8732f149961005afa9128121f4]}')
    at com.google.devtools.build.skyframe.AbstractParallelEvaluator$Evaluate.run(AbstractParallelEvaluator.java:550)
    at com.google.devtools.build.lib.concurrent.AbstractQueueVisitor$WrappedRunnable.run(AbstractQueueVisitor.java:414)
    at java.base/java.util.concurrent.ForkJoinTask$RunnableExecuteAction.exec(Unknown Source)
    at java.base/java.util.concurrent.ForkJoinTask.doExec(Unknown Source)
    at java.base/java.util.concurrent.ForkJoinPool$WorkQueue.topLevelExec(Unknown Source)
    at java.base/java.util.concurrent.ForkJoinPool.scan(Unknown Source)
    at java.base/java.util.concurrent.ForkJoinPool.runWorker(Unknown Source)
    at java.base/java.util.concurrent.ForkJoinWorkerThread.run(Unknown Source)
Caused by: java.lang.NullPointerException
    at com.google.common.base.Preconditions.checkNotNull(Preconditions.java:903)
    at com.google.common.collect.ImmutableList$Builder.add(ImmutableList.java:815)
    at java.base/java.util.stream.ReduceOps$3ReducingSink.accept(Unknown Source)
    at java.base/java.util.stream.ReferencePipeline$3$1.accept(Unknown Source)
    at java.base/java.util.AbstractList$RandomAccessSpliterator.forEachRemaining(Unknown Source)
    at java.base/java.util.stream.AbstractPipeline.copyInto(Unknown Source)
    at java.base/java.util.stream.AbstractPipeline.wrapAndCopyInto(Unknown Source)
    at java.base/java.util.stream.ReduceOps$ReduceOp.evaluateSequential(Unknown Source)
    at java.base/java.util.stream.AbstractPipeline.evaluate(Unknown Source)
    at java.base/java.util.stream.ReferencePipeline.collect(Unknown Source)
    at com.google.devtools.build.lib.rules.platform.Toolchain.create(Toolchain.java:57)
    at com.google.devtools.build.lib.rules.platform.Toolchain.create(Toolchain.java:38)
    at com.google.devtools.build.lib.analysis.ConfiguredTargetFactory.createRule(ConfiguredTargetFactory.java:408)
    at com.google.devtools.build.lib.analysis.ConfiguredTargetFactory.createConfiguredTarget(ConfiguredTargetFactory.java:194)
    at com.google.devtools.build.lib.skyframe.SkyframeBuildView.createConfiguredTarget(SkyframeBuildView.java:1312)
    at com.google.devtools.build.lib.skyframe.ConfiguredTargetFunction.createConfiguredTarget(ConfiguredTargetFunction.java:385)
    at com.google.devtools.build.lib.skyframe.ConfiguredTargetFunction.compute(ConfiguredTargetFunction.java:312)
    at com.google.devtools.build.skyframe.AbstractParallelEvaluator$Evaluate.run(AbstractParallelEvaluator.java:461)
    ... 7 more
```

### What is the output of `bazel info release`?

release 6.1.0


### Have you found anything relevant by searching the web?

No.


### Any other information, logs, or outputs that you want to share?

Code for this proposal: https://github.com/alexander-shiryaev/bazel_issue/tree/main/TODO
