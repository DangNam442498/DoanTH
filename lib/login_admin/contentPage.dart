import 'package:recipes_app/page/admin/show_recipe.dart';
import 'package:recipes_app/page/maps_page.dart';
import 'package:recipes_app/page/myrecipes/list_my_recipe.dart';
import 'package:recipes_app/widgets/home_page.dart';

abstract class Content {
  Future<HomePageRecipes> lista();
  Future<ListMyRecipe> myrecipe(String id);
  Future<MapsPage> mapa();
  Future<InicioPage> admin();
}

class ContentPage implements Content {
  Future<HomePageRecipes> lista() async {
    return HomePageRecipes();
  }

  Future<MapsPage> mapa() async {
    return MapsPage();
  }

  Future<InicioPage> admin() async {
    return InicioPage();
  }

  Future<ListMyRecipe> myrecipe(String id) async {
    print('Liệt kê công thức nấu ăn của tôi $id');
    return ListMyRecipe(
      id: id,
    );
  }
}
