
class Endpoints {
  static const metadata = "https://archive.org/metadata/";

  static const base = "https://archive.org/download";

  static const commonParams =
      "q=collection:(librivoxaudio)&fl=runtime,avg_rating,num_reviews,title,description,identifier,creator,date,downloads,subject,item_size";

  static const latestBooksApi =
      "https://archive.org/advancedsearch.php?$commonParams&sort[]=addeddate desc&output=json";

  static const mostDownloaded =
      "https://archive.org/advancedsearch.php?$commonParams&sort[]=downloads desc&rows=10&page=1&output=json";
  static const query = "title:(secret tomb) AND collection:(librivoxaudio)";
}

class DbTexts {
  static const String bookTable = "books";
  final String authorTable = "authors";
  static const String audioFilesTable = "audiofiles";

  static const String columnId = "identifier";
  static const String columnTitle = "title";

  static const String bookDescriptionColumn = "description";
  static const String bookRuntimeColumn = "runtime";
  static const String bookCreatorColumn = "creator";
  static const String bookDateColumn = "date";
  static const String bookDownloadsColumn = "downloads";
  static const String bookSubjectColumn = "subject";
  static const String bookItemSizeColumn = "item_size";
  static const String bookAvgRatingColumn = "avg_rating";
  static const String bookNumReviewsColumn = "num_reviews";

  static const String afBookIdColumn = "book_id";
  static const String afUrlColumn = "url";
  static const String afNameColumn = "name";
  static const String afLengthColumn = "length";
  static const String afTrackColumn = "track";
  static const String afSizeColumn = "size";
}
