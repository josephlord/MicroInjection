# MicroInjection

A tiny (~80 lines including comments and whitespace) dependency injection framework taking the same approach as the SwiftUI environment.

Read the [blog post about it](https://blog.human-friendly.com/how-does-the-swiftui-environment-work-and-can-it-be-used-outside-swiftui-for-dependency-injection).

This hasn't been tested in any real project yet and it does use a Swift compiler feature that isn't officially supported (see the blog post for details). The property wrapper could be left out if needed it just wouldn't be quite as nice.

Currently there is a small test suite covering all the happy cases. I have a mind to create another test file for all the cases that shouldn't compile to ensure that is the case. They would then be commented out so as not to fail builds but could be periodically checked in case any of them do build (and then lead to undesirable behaviour).
