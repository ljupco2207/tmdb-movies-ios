@testable import MovieExplorer
import Testing

struct IntCountedTests {
    @Test func usesSingularOnlyForOne() {
        #expect(1.counted("vote") == "1 vote")
        #expect(0.counted("vote") == "0 votes")
        #expect(2.counted("season") == "2 seasons")
    }

    @Test func usesCustomPlural() {
        #expect(3.counted("person", plural: "people") == "3 people")
    }
}
