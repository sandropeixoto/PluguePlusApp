import './category.dart';
import './charger.dart';
import './post.dart';
import './service.dart';
import './user.dart';

class HomeData {
  const HomeData({
    required this.categories,
    required this.services,
    required this.chargers,
    required this.posts,
    required this.users,
  });

  final List<Category> categories;
  final List<Service> services;
  final List<Charger> chargers;
  final List<Post> posts;
  final List<User> users;
}
