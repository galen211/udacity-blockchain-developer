import 'package:flutter_test/flutter_test.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

const String senderPrivateKey =
    '7407a0a98433a3443d61de96194ca85a1ed2270de3865079656908b52c1c4e77';

const String recipientPrivateKey =
    '15a64436bbba2e7bed89b52e02f63e3c2e9fb7bc1a09f96a8b82edb7a40b0368';
const String rpcUrl = 'http://127.0.0.1:8545';

void main() async {
  Web3Client client;
  EthereumAddress senderAddress;
  Credentials senderCredentials;
  EthereumAddress recipientAddress;
  Credentials recipientCredentials;

  setUpAll(() async {
    client = Web3Client(rpcUrl, Client());
  });

  test("Address matches from credentials", () async {
    senderCredentials =
        await client.credentialsFromPrivateKey(senderPrivateKey);
    senderAddress = await senderCredentials.extractAddress();
    expect(senderAddress.toString(),
        '0x197128a71474FAD3a82Cf639ec427fd285F561eb'.toLowerCase());
    recipientCredentials =
        await client.credentialsFromPrivateKey(recipientPrivateKey);
    recipientAddress = await recipientCredentials.extractAddress();
    expect(recipientAddress.toString(),
        '0x7182193dEFE412DD0fcc5EE18c6F7B79aB6D03cC'.toLowerCase());
  });

  test("Can send transaction", () async {
    var initialBalance = await client.getBalance(senderAddress);

    var tx = await client.sendTransaction(
      senderCredentials,
      Transaction(
        to: recipientAddress,
        gasPrice: EtherAmount.inWei(BigInt.one),
        maxGas: 100000,
        value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1),
      ),
    );

    print(tx);
  });

  //test("Can execute a contract call to get operational", () async {});

  //await client.dispose();
}
