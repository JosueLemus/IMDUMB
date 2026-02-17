enum Flavor {
  qa,
  prod,
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.qa:
        return 'IMDUMB QA';
      case Flavor.prod:
        return 'IMDUMB';
    }
  }

}
