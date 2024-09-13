class Post {
  int id;
  String title;
  double price;
  String description;
  String category;
  String image;
  Rating rating;

  Post({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: Rating.fromJson(json['rating']),
    );
  }

  @override
  String toString() {
    return 'Post{id: $id, title: $title, price: $price, description: $description, category: $category, image: $image, rating: $rating}';
  }
}

class Rating {
  double rate;
  int count;

  Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'],
    );
  }

  @override
  String toString() {
    return 'Rating{rate: $rate, count: $count}';
  }
}
