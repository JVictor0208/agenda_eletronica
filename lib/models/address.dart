class Address {
  String? cep;
  String? city;
  String? uf;
  String? street;
  String? number;
  String? complement;

  Address({
    this.cep,
    this.city,
    this.uf,
    this.street,
    this.number,
    this.complement,
  });
  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      cep: map['cep'],
      city: map['city'],
      complement: map['complement'],
      number: map['number'],
      street: map['street'],
      uf: map['uf'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ep': cep,
      'city': city,
      'complement': complement,
      'number': number,
      'street': street,
      'uf': uf,
    };
  }
}
