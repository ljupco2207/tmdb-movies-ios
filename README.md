# MovieExplorer

A small app for [The Movie Database](https://www.themoviedb.org): browse trending movies, open details, search movies and series, and keep a list of favorites. It runs on iPhone, iPad, Apple Vision and Apple TV.

Built with Swift 6, SwiftUI (plus UIKit for the Trending grid) and MVVM. Minimum iOS is 17.6.

## Running it

1. Open `MovieExplorer.xcodeproj`.
2. Pick the **MovieExplorer Dev** scheme and run.

Swift packages (Kingfisher, SwiftLint) resolve on their own. There's nothing to set up: the TMDB token is committed on purpose so the app runs right away. I'll regenerate it after the review.

## What's where

| Requirement | Where to look |
|---|---|
| Trending with a custom layout | `MovieCollectionView`: a `UICollectionView` in SwiftUI with a compositional layout (1 to 4 columns depending on width) |
| Infinite scrolling | `TrendingViewModel.loadNextPage()`, triggered a few cards before the end |
| Images sized to the view | `TMDBImage` picks the smallest TMDB size that covers the view's pixel width |
| Details (rating, votes, cast and crew) | `DetailsView`, works for movies and series |
| Search, type chosen first, throttled | `SearchViewModel`: Movies/Series picker, 400 ms debounce |
| iPad and orientations | Columns adapt to width; Details keeps a readable width |
| Dev / Prod environments | `Config/*.xcconfig` and the two shared schemes |
| Scheme environment variable | `NETWORK_LOGGING=1` in the Dev scheme turns on request logging |
| SwiftLint | SPM build plugin, rules in `.swiftlint.yml` |

## How it's put together

- `App/` creates the services once (`AppDependencies`) and owns navigation (`RootView`). Screens only push route values, and `RootView` decides which screen to show.
- `Core/` has networking, models, images and favorites. `APIClient` sits on a small `NetworkSession` protocol, so tests can swap the network out. Decoding runs off the main actor.
- `Features/` has one folder per screen, each with a view and an `@Observable` view model.
- `Shared/` has small reusable views and the platform helpers.

## Environments

Dev and Prod each have an xcconfig and a scheme. They differ in app name, bundle id (Dev ends with `.dev`, so both can be installed side by side) and Debug vs Release. TMDB has no staging server, so both talk to the same API.

## Other platforms and older iOS

- **iPad**: adaptive grid and Split View.
- **visionOS**: runs natively, with system glass behind overlays.
- **tvOS**: focus-based navigation with the Siri Remote.
- **iOS 26 vs older**: badges and the offline banner use Liquid Glass on iOS 26 and fall back to a blurred material on earlier versions (`View+GlassBackground`).


## Tests

Run them with ⌘U on the Dev scheme.

- **Unit tests**: mostly Swift Testing. Networking and the search debounce use XCTest, including async tests and expectations (one inverted, to prove nothing is sent while typing).
- **UI tests**: launched with `--uitesting`, so the app uses stubbed responses and an in-memory favorites store. They're fast, offline and don't depend on what's trending this week. `testRecordedFlow` started as an Xcode recording and was then cleaned up.

## Extras

- **Image caching** with Kingfisher, with memory and disk limits.
- **Low-res first**: a tiny blurred image shows right away, then the sharp one fades in.
- **Prefetching**: images for cards about to scroll into view load early.
- **Offline mode**: successful responses are saved, and screens you've seen still load without a connection. A banner tells you you're offline.
- **Favorites**: saved with SwiftData, with a heart on cards and search rows and a Favorites screen.

