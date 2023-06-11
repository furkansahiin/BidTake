
class Bid {
  final int bidId;
  final int userId;
  final double amount;
  final int auctionId;
  final DateTime createDate;

  Bid({
    required this.bidId,
    required this.userId,
    required this.amount,
    required this.auctionId,
    required this.createDate,
  });

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      bidId: int.tryParse(json['bid_id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      auctionId: int.tryParse(json['auction_id'].toString()) ?? 0,
      createDate: DateTime.parse(json['create_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bid_id': bidId,
      'user_id': userId,
      'amount': amount,
      'auction_id': auctionId,
      'create_date': createDate.toIso8601String(),
    };
  }
}