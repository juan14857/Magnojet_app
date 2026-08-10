class ApiConstants {
  static const String sheetsBaseUrl =
      'https://sheets.googleapis.com/v4/spreadsheets';
  static const String spreadsheetId =
      '1SRT19sUQ2pZ2bNGUa4tVXvmFgPjKRqPwHfyHB7Hi2Fw';
  static const String apiKey =
      'AIzaSyCgvqccq469KDLj51a-tx95M9ccpbV5Z8E';
  static const String sheetName = 'Hoja1';
  static const int lowStockThreshold = 10;

  static String get inventoryUrl =>
      '$sheetsBaseUrl/$spreadsheetId/values/$sheetName!A:J?key=$apiKey';
}
