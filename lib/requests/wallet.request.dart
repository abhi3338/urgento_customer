import 'package:fuodz/constants/api.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/models/wallet.dart';
import 'package:fuodz/models/wallet_transaction.dart';
import 'package:fuodz/services/http.service.dart';

class WalletRequest extends HttpService {
  //
  Future<Wallet> walletBalance() async {
    final apiResult = await get(Api.walletBalance);
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return Wallet.fromJson(apiResponse.body);
    }

    throw apiResponse.message;
  }

  Future<String> walletTopup(String amount) async {
    final apiResult = await post(Api.walletTopUp, {"amount": amount});
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.body["link"];
    }

    throw apiResponse.message;
  }

  Future<List<WalletTransaction>> walletTransactions({int page = 1}) async {
    final apiResult =
        await get(Api.walletTransactions, queryParameters: {"page": page});

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return (apiResponse.body["data"] as List)
          .map((e) => WalletTransaction.fromJson(e))
          .toList();
    }

    throw apiResponse.message;
  }

  Future<ApiResponse> myWalletAddress() async {
    final apiResult = await get(Api.myWalletAddress);
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> getWalletAddress(String keyword) async {
    final apiResult = await get(
      Api.walletAddressesSearch,
      queryParameters: {
        "keyword": keyword,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> transferWallet(
    String amount,
    String walletAddress,
    String password,
  ) async {
    final apiResult = await post(
      Api.walletTransfer,
      {
        "wallet_address": walletAddress,
        "amount": amount,
        "password": password,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }
}
