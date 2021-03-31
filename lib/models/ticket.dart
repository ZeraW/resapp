import 'dart:convert';

class Ticket {
  final int? id;
  final String? name, from, to;

  Ticket({
    this.id,
    this.to,
    this.from,
    this.name,
  });

  factory Ticket.fromJson(Map<String, dynamic> jsonData) {
    return Ticket(
      id: jsonData['id'],
      to: jsonData['to'],
      from: jsonData['size'],
      name: jsonData['name'],
    );
  }

  static Map<String, dynamic> toMap(Ticket music) => {
        'id': music.id,
        'to': music.to,
        'size': music.from,
        'name': music.name,
      };

  static String encode(List<Ticket> tickets) => json.encode(
        tickets
            .map<Map<String, dynamic>>((music) => Ticket.toMap(music))
            .toList(),
      );

  static List<Ticket> decode(String tickets) =>
      (json.decode(tickets) as List<dynamic>)
          .map<Ticket>((item) => Ticket.fromJson(item))
          .toList();
}
