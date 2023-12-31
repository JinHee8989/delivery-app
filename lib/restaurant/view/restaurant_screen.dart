import "package:delivery/common/const/data.dart";
import "package:delivery/common/dio/dio.dart";
import "package:delivery/restaurant/component/restaurant_card.dart";
import "package:delivery/restaurant/model/restaurant_model.dart";
import "package:delivery/restaurant/view/restaurant_detail_screen.dart";
import "package:dio/dio.dart";
import "package:flutter/material.dart";

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List> paginateRestaurant() async {
    final dio = Dio();

    dio.interceptors.add(CustomInterceptor(storage: storage));

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      'http://$ip/restaurant',
      options: Options(
        headers: {
          'authorization': 'Bearer $accessToken',
        },
      ),
    );

    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<List>(
              future: paginateRestaurant(),
              builder: (context, AsyncSnapshot<List> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.separated(
                    itemBuilder: (_, index) {
                      final item = snapshot.data![index];
                      final pItem = RestaurantModel.fromJson(item);

                      return GestureDetector(
                        child: RestaurantCard.fromModel(model: pItem),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) =>
                                    RestaurantDetailScreen(id: pItem.id)),
                          );
                        },
                      );
                    },
                    separatorBuilder: (_, index) {
                      return SizedBox(
                        height: 16.0,
                      );
                    },
                    itemCount: snapshot.data!.length);
              },
            )),
      ),
    );
  }
}
