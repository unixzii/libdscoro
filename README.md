#  libdscoro

The dead-simple coroutine library, which is written in C and can be adopted by arbitrary languages (as long as they can call to C).

**NOTE: This library is still working in progress, don't use it in production environment!!**

## Interfaces

### `sched.h` (Scheduler Object)
The scheduler object is used to manage and schedule the tasks that added into it, and it's the main object that should be integrated with you application framework. Because the execution of scheduler is completely controlled by yourself, thus you should repeatedly call `dsco_sched_run` function to make it work properly. For example, in *AppKit* (or *UIKit*), you can call `dsco_sched_run` before the run loop is going to sleep. And this is similar to the mechanism of *CoreAnimation*, which process and submit the layer changes happened in the previous run loop.

### `task.h` (Task Object)
The task object is a work unit of a coroutine, it's similar to a thread (both have their own stack), but totally cooperative. You should periodically call `dsco_task_yield` to hand the control to the scheduler object, otherwise other tasks will get starved. There are also some control functions that are useful: `dsco_task_park` and `dsco_task_unpark`. They can control the task's wait state. If some task need to wait for some resources, you can call `dsco_task_park` to put the task into wait state, and after the resource is ready, call `dsco_task_unpark` to make the task again able to be executed soon. 

## Example
There is a simple Cocoa sample application to show you how to integrate this library with AppKit. Besides the Objective-C wrappers of the library, there are also some utilities that can make it easier to write async code.

Let's get a sneak peek:

```objc
- (IBAction)askAQuestion:(id)sender {
    [[DSCTask taskWithBlock:^{
        AskViewController *vc = [[AskViewController alloc]
                                  initWithNibName:@"AskViewController" bundle:nil];
        [self presentViewControllerAsSheet:vc];

        NSString *answer = vc.promise.await;
        NSLog(@"fake processing: %@", answer);
        [[DSCPromise timeoutAfter:3] await];
        NSLog(@"finished processing: %@", answer);
    }] schedule];
}
```

## Supported Platforms
* Intel x86 64-bit
* ... (no plans now)

## License
MIT
