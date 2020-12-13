import 'dart:convert';

class Accounts {
  Accounts({
    this.addresses,
    this.privateKeys,
  });

  final Map<String, Address> addresses;
  final Map<String, String> privateKeys;

  factory Accounts.fromRawJson(String str) =>
      Accounts.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Accounts.fromJson(Map<String, dynamic> json) => Accounts(
        addresses: Map.from(json["addresses"])
            .map((k, v) => MapEntry<String, Address>(k, Address.fromJson(v))),
        privateKeys: Map.from(json["private_keys"])
            .map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "addresses": Map.from(addresses)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "private_keys": Map.from(privateKeys)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

class Address {
  Address({
    this.secretKey,
    this.publicKey,
    this.address,
    this.account,
  });

  final Key secretKey;
  final Key publicKey;
  final String address;
  final Account account;

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        secretKey: Key.fromJson(json["secretKey"]),
        publicKey: Key.fromJson(json["publicKey"]),
        address: json["address"],
        account: Account.fromJson(json["account"]),
      );

  Map<String, dynamic> toJson() => {
        "secretKey": secretKey.toJson(),
        "publicKey": publicKey.toJson(),
        "address": address,
        "account": account.toJson(),
      };
}

class Account {
  Account({
    this.nonce,
    this.balance,
    this.stateRoot,
    this.codeHash,
  });

  final Nonce nonce;
  final Balance balance;
  final String stateRoot;
  final String codeHash;

  factory Account.fromRawJson(String str) => Account.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        nonce: nonceValues.map[json["nonce"]],
        balance: balanceValues.map[json["balance"]],
        stateRoot: json["stateRoot"],
        codeHash: json["codeHash"],
      );

  Map<String, dynamic> toJson() => {
        "nonce": nonceValues.reverse[nonce],
        "balance": balanceValues.reverse[balance],
        "stateRoot": stateRoot,
        "codeHash": codeHash,
      };
}

enum Balance { THE_0_X056_BC75_E2_D63100000 }

final balanceValues =
    EnumValues({"0x056bc75e2d63100000": Balance.THE_0_X056_BC75_E2_D63100000});

enum Nonce { THE_0_X }

final nonceValues = EnumValues({"0x": Nonce.THE_0_X});

class Key {
  Key({
    this.type,
    this.data,
  });

  final Type type;
  final List<int> data;

  factory Key.fromRawJson(String str) => Key.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Key.fromJson(Map<String, dynamic> json) => Key(
        type: typeValues.map[json["type"]],
        data: List<int>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}

enum Type { BUFFER }

final typeValues = EnumValues({"Buffer": Type.BUFFER});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
