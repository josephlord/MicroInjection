# MicroInjection

A tiny (~100 lines including comments and whitespace) dependency injection framework taking the same approach as the SwiftUI environment.

Read the [blog post about it](https://blog.human-friendly.com/how-does-the-swiftui-environment-work-and-can-it-be-used-outside-swiftui-for-dependency-injection).

![Swift](https://github.com/josephlord/MicroInjection/workflows/Swift/badge.svg?branch=main)

This hasn't been tested in any real project yet and it does use a Swift compiler feature that isn't officially supported (see the blog post for details). The property wrapper could be left out if needed it just wouldn't be quite as nice.

Be aware that the property wrapper uses a compiler feature that is not officially supported (it was included as a possible future extension of the Property Wrappers Swift Evolution proposal). However even in the worst case if the feature is removed it should be possible to repace all the uses of the `@Injection` property wrapper with a computed var, that could mostly be done with a search and replace but would probably just need the type adding in each location.

Currently there is a small test suite covering all the happy cases. There is another test file for cases that shouldn't compile to ensure that is the case. They are commented out so as not to fail builds but could be periodically checked in case any of them do build (and then lead to undesirable behaviour).

It may well be that rather than have it as an external dependency you instead just drop the file into your project as a single file library (might build quicker that way than pulling the package from git).

Regarding license I haven't decided yet, let me know if you are planning to use it. Unless I regard your purpose or organisation as evil I'll grant you a very broad license if you want. Feel free to experment before requesting the license to distribute the code.

## Help wanted

API naming improvement suggestions. I would like other eyes on it if possible before stabilising it for a 1.0 release before March 2021.

If you can see a way to allow the property wrapper to be used on structs and enums that is the additional feature that I'm looking for.
