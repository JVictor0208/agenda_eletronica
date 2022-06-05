class Contact {
  String name;
  String phone;
  String? email;
  String? image;
  Contact({
    required this.name,
    required this.phone,
    this.email,
    this.image,
  });
}
