import 'sheets_parser.dart';

class CurrencyFormatter {
  static String format(double amount) => SheetsParser.formatCOP(amount);
}
