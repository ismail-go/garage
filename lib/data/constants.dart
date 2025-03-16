class Cons {
  // Private static instance of the class
  static final Cons _instance = Cons._internal();

  // Private named constructor
  Cons._internal();

  // Factory constructor to return the same instance
  factory Cons() {
    return _instance;
  }
}
