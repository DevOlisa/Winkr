class User {
  final int id;
  final String name;
  final String pic;
  List<User> favourites = [];
  List<User> contacts = [];

  User(this.name, this.pic, this.id);

  void toggleFavourite(User person) {
    if (this.favourites.contains(person)) {
      this.favourites.removeWhere((element) => element == person);
    } else {
      this.favourites.insert(0, person);
    }
  }
}

List<User> people = [
  User('Shelia', 'shelia.jpg', 0),
  User('Matt', 'matt.jpg', 1),
  User('Anna', 'anna.jpg', 2),
  User('Lauren', 'lauren.jpg', 3),
  User('Josh', 'josh.jpg', 4),
  User('Mitchelle', 'mitchelle.jpg', 5),
  User('Damon', 'damon.jpg', 6),
  User('Destiny', 'destiny.jpg', 7),
  User('Zazzy', 'zazzy.jpg', 8)
];

User user = new User('Sam', 'sam.jpg', 9);

List<User> favourites = [people[6], people[1], people[5], people[3], people[4]];
