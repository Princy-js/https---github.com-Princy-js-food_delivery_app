import 'package:flutter/material.dart';
import 'package:food_delivery_app/custom_components/my_current_location.dart';
import 'package:food_delivery_app/custom_components/my_description_box.dart';
import 'package:food_delivery_app/custom_components/my_drawer.dart';
import 'package:food_delivery_app/custom_components/my_food_tile.dart';
import 'package:food_delivery_app/custom_components/my_sliver_appbar.dart';
import 'package:food_delivery_app/custom_components/my_tab_bar.dart';
import 'package:food_delivery_app/model/food.dart';
import 'package:food_delivery_app/model/restaurent.dart';
import 'package:food_delivery_app/pages/food_details_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

// tab controller
late TabController _tabController;

@override
  void initState() {
    super.initState();
    _tabController = TabController(length: FoodCategory.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // sort out and return a list of food items that belong to a specific category
  List<Food> _filterMenuByCategory(FoodCategory category, List<Food> fullMenu){
    return fullMenu.where((food) => food.category == category).toList();
  }

  // return list of foods in given category
  List<Widget> getFoodInThisCategory(List<Food> fullMenu){
    return FoodCategory.values.map((category) {

      // get category menu
      List<Food> categoryMenu = _filterMenuByCategory(category, fullMenu);
      return ListView.builder(
        itemCount: categoryMenu.length,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: (context, index){

          //get individual food
          final food = categoryMenu[index];

          // return the food tile in the UI
          return MyFoodTile(
            food: food, 
            onTap: () => Navigator.push(context,
             MaterialPageRoute(
              builder: (context) => FoodDetailsPage(food: food)))
          );
        });
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled)=>[
          MySliverAppBar(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Divider(
                  indent: 25,
                  endIndent: 25,
                  color: Theme.of(context).colorScheme.secondary,
                ),
               // current location
                MyCurrentLocation(),
               // Description
               MyDescriptionBox(),
              ],
            ), 
            title: MyTabBar(
              tabController:_tabController ))
        ],
         body: Consumer<Restaurant>(
           builder: (BuildContext context, Restaurant value, Widget? child)=> TabBarView(
            controller: _tabController,
              children: getFoodInThisCategory(value.menu)
            ),
         )
         ),
    );
  }
}