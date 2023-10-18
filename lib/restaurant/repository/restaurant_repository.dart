import 'package:delivery/restaurant/model/restaurant_detail_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  // retrofit을 사용하기위해 인스턴스화가 되지 않도록 abstract로 선언해줘야함

  // http://$ip/restaurant
  factory RestaurantRepository(Dio dio,
          {String baseUrl}) //같은 dio 인스턴트를 공유해야하는 이유는?
      = _RestaurantRepository;

  // http://$ip/restaurant
  // @GET('/')
  // paginate();

  // http://$ip/restaurant/:id
  @GET('/{id}')
  @Headers({'authorization': 'true'}) // 강제로 헤더 넣어주기 위해서 선언
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
