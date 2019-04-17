class Asset {
  final String id;
  final String symbol;
  final int precision;
  final String description;
  final String issuer;

  Asset(this.id, this.symbol, this.precision, this.description, this.issuer);

  @override
  String toString() {
    return issuer == '1.2.0' ? 'bit$symbol' : symbol;
  }

  String getObjectId() {
    // return String.format(Locale.US, "%d.%d.%d", space, type, instance);
  }
}
