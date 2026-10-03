enum SampleResponses {
    static let trendingPage = """
    {
      "page": 1,
      "total_pages": 500,
      "total_results": 10000,
      "results": [
        {
          "id": 1248832,
          "title": "Digger",
          "overview": "The most powerful man in the world...",
          "backdrop_path": "/b7t3r39Oll5qPxBKzLZ8eHMBD7l.jpg",
          "poster_path": "/1ATXKrIPJyKNwnJ6lcG088Sa6zi.jpg",
          "vote_average": 7.782
        },
        {
          "id": 2,
          "title": "No Backdrop",
          "overview": "",
          "backdrop_path": null
        }
      ]
    }
    """

    static let movieDetails = """
    {
      "id": 1, "title": "Digger", "tagline": "A man. A plan.", "overview": "Story",
      "backdrop_path": "/b.jpg", "release_date": "2026-09-28", "runtime": 129, "status": "Released",
      "vote_average": 7.4, "vote_count": 24, "genres": [{"id": 35, "name": "Comedy"}],
      "credits": {
        "cast": [{"credit_id": "c1", "name": "Tom Cruise", "character": "Digger"}],
        "crew": [
          {"name": "A. Director", "job": "Director", "department": "Directing"},
          {"name": "A. Director", "job": "Screenplay", "department": "Writing"},
          {"name": "B. Writer", "job": "Story", "department": "Writing"},
          {"name": "B. Writer", "job": "Screenplay", "department": "Writing"},
          {"name": "C. Editor", "job": "Editor", "department": "Editing"}
        ]
      }
    }
    """

    static let seriesDetails = """
    {
      "id": 2, "name": "Dark", "overview": "Story", "backdrop_path": null, "first_air_date": "2017-12-01",
      "number_of_seasons": 3, "number_of_episodes": 26, "status": "Ended",
      "vote_average": 8.4, "vote_count": 1, "genres": [],
      "created_by": [{"name": "Baran bo Odar"}, {"name": "Jantje Friese"}],
      "credits": {"cast": [], "crew": []}
    }
    """
}
