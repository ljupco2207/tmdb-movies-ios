import XCTest

@MainActor
final class MovieExplorerUITests: XCTestCase {
    func testOpeningTrendingMovieShowsDetails() {
        let app = launchApp()

        let movie = app.staticTexts["Movie 101"]
        XCTAssertTrue(movie.waitForExistence(timeout: 5))
        movie.tap()

        let title = app.staticTexts["details.title"]
        XCTAssertTrue(title.waitForExistence(timeout: 5))
        XCTAssertEqual(title.label, "Movie 101")

        app.navigationBars.buttons["Trending"].tap()
        XCTAssertTrue(movie.waitForExistence(timeout: 5))
    }

    func testScrollingTrendingLoadsNextPage() {
        let app = launchApp()
        let list = app.collectionViews["trending.list"]
        XCTAssertTrue(app.staticTexts["Movie 101"].waitForExistence(timeout: 5))

        let nextPageMovie = app.staticTexts["Movie 201"]
        for _ in 0..<15 where !nextPageMovie.exists {
            list.swipeUp()
        }
        XCTAssertTrue(nextPageMovie.exists)
    }

    func testSearchingSeriesOpensDetails() {
        let app = launchApp()

        app.buttons["Search"].tap()
        let searchField = app.searchFields["Search"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText("dark")
        XCTAssertTrue(app.staticTexts["dark Movie"].waitForExistence(timeout: 5))

        app.buttons["Series"].tap()
        let series = app.staticTexts["dark Series"]
        XCTAssertTrue(series.waitForExistence(timeout: 5))
        series.tap()

        let title = app.staticTexts["details.title"]
        XCTAssertTrue(title.waitForExistence(timeout: 5))
        XCTAssertEqual(title.label, "Series 2")
    }

    func testFavoritingMovieShowsItInFavoritesAndOnCard() {
        let app = launchApp()

        let movie = app.staticTexts["Movie 101"]
        XCTAssertTrue(movie.waitForExistence(timeout: 5))
        movie.tap()
        let addButton = app.buttons["Add to favorites"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()
        XCTAssertTrue(app.buttons["Remove from favorites"].exists)

        app.navigationBars.buttons["Trending"].tap()
        XCTAssertTrue(app.images["Favorite"].waitForExistence(timeout: 5))

        app.buttons["Favorites"].tap()
        XCTAssertTrue(app.navigationBars["Favorites"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Movie 101"].exists)
    }

    /// Recorded with Xcode's recorder, then cleaned up: stub data, stable queries and assertions.
    func testRecordedFlow() {
        let app = launchApp()
        let list = app.collectionViews["trending.list"]
        XCTAssertTrue(app.staticTexts["Movie 101"].waitForExistence(timeout: 5))

        list.swipeUp()
        list.cells.firstMatch.tap()
        XCTAssertTrue(app.staticTexts["details.title"].waitForExistence(timeout: 5))
        app.navigationBars.buttons["Trending"].tap()

        app.buttons["Search"].tap()
        let searchField = app.searchFields["Search"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText("a")
        XCTAssertTrue(app.staticTexts["a Movie"].waitForExistence(timeout: 5))

        app.buttons["Close"].tap()
        app.navigationBars.buttons["Trending"].tap()
        XCTAssertTrue(list.waitForExistence(timeout: 5))
    }

    private func launchApp() -> XCUIApplication {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
        return app
    }
}
