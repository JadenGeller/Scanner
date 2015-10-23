# Scanner

Remember in C how you had to use `printf`---it was so gross!
```c
int x = 5;
printf("The number is %i", x); // -> The number is 5
```

But then Swift came to the rescue with super pretty string interpolation!
```swift
let x = 5
print("The number is \(x)") // -> The number is 5
```

Can Swift save us again from the nasty `scanf`?
```c
char *name
int age;
scanf("%s %i", name, &age);
```

You betcha!
```swift
let name = Scannable<String>()
let age = Scannable<Int>()
scan("\(name) \(age)")
```

BAM! It's that easy! Parse a `String` with `String.scan` if you'd like as well. And verify the format is what you'd like too.
```swift
let input = "There are 5 apples in the bowl."

let count  = Scannable<Int>()
let object = Scannable<String>()
let place  = Scannable<String>()

guard input.scan("There are \(count) \(object) in the \(place).") else { return fatalError("Scan failed!") }

print("Whoa, look! Guess what I found \(count.value) of in the \(place.value)---\(object.value)!")
// -> Whoa, look! Guess what I found 5 of in the bowl---apples!
```

Pretty nifty, right?
