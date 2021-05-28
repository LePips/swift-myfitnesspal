# swift-myfitnesspal

Package to access MyFitnessPal without the use of their API.

Heavily influenced by [python-myfitnesspal](https://github.com/coddingtonbear/python-myfitnesspal).

# Client and Usage

A MyFitnessPalClient is created with the user's MyFitnessPal username and password.

```swift
let client = MyFitnessPalClient(username: "JohnnyAppleseed", password: "iLikeApples1234")
```

### Login

Before any calls can be completed, the user must first login.

The completion closure returns a `Result<AuthToken, MyFitnessPalError`. The auth token is provided so the client can store it themselves.

```swift
client.login { result in
  switch result {
    case .success(let authToken):
      self.Store(authToken)
    case .failure(let error):
      print(error)
  }
}
```

### GetDay

Retrieves meal and calorie information for a given day. Two calls are available, one that takes in a `Date` object and another that specifies the year, month, and day.

The completion closure returns a `Result<Day, MyFitnessPalError>`.

```swift
client.getDay(Date()) { result in
  switch result {
    case .success(let day):
      print(day.meals)
    case .failure(let error):
      print(error)
  }
}
```

# Development and TODO

The project is marked with a lot of `TODO` comments where speed of development was prioritized over "correct" development (mainly error checking)

Some TODOs include:
- [ ] Allow password gathering from Keychain
- [ ] Complete user MetaData call
- [ ] Create list of functions to gather
